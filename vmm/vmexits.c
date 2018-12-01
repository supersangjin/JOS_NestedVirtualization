#include <vmm/vmx.h>
#include <inc/error.h>
#include <inc/malloc.h>
#include <vmm/vmexits.h>
#include <vmm/ept.h>
#include <vmm/vmx_asm.h>
#include <inc/x86.h>
#include <inc/assert.h>
#include <kern/pmap.h>
#include <kern/console.h>
#include <kern/kclock.h>
#include <kern/multiboot.h>
#include <inc/string.h>
#include <inc/stdio.h>
#include <kern/syscall.h>
#include <kern/env.h>
#include <kern/cpu.h>
#include <kern/trap.h>

#define JOS_ENTRY 0x7000

static int vmdisk_number = 0;	//this number assign to the vm
int 
vmx_get_vmdisk_number() {
	return vmdisk_number;
}

void
vmx_incr_vmdisk_number() {
	vmdisk_number++;
}
bool
find_msr_in_region(uint32_t msr_idx, uintptr_t *area, int area_sz, struct vmx_msr_entry **msr_entry) {
	struct vmx_msr_entry *entry = (struct vmx_msr_entry *)area;
	int i;
	for(i=0; i<area_sz; ++i) {
		if(entry->msr_index == msr_idx) {
			*msr_entry = entry;
			return true;
		}
	}
	return false;
}


bool
handle_interrupt_window(struct Trapframe *tf, struct VmxGuestInfo *ginfo, uint32_t host_vector) {
	uint64_t rflags;
	uint32_t procbased_ctls_or;
	
	procbased_ctls_or = vmcs_read32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS );
            
        //disable the interrupt window exiting
        procbased_ctls_or &= ~(VMCS_PROC_BASED_VMEXEC_CTL_INTRWINEXIT); 
        
        vmcs_write32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS, 
		      procbased_ctls_or);
        //write back the host_vector, which can insert a virtual interrupt            
	vmcs_write32( VMCS_32BIT_CONTROL_VMENTRY_INTERRUPTION_INFO , host_vector);
	return true;
}
bool
handle_interrupts(struct Trapframe *tf, struct VmxGuestInfo *ginfo, uint32_t host_vector) {
	uint64_t rflags;
	uint32_t procbased_ctls_or;
	rflags = vmcs_read64(VMCS_GUEST_RFLAGS);
	
	if ( !(rflags & (0x1 << 9)) ) {	//we have to wait the interrupt window open
		//get the interrupt info
		
		procbased_ctls_or = vmcs_read32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS);
            
		//disable the interrupt window exiting
		procbased_ctls_or |= VMCS_PROC_BASED_VMEXEC_CTL_INTRWINEXIT; 
		
		vmcs_write32( VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS, 
			      procbased_ctls_or);
	}
	else {	//revector the host vector to the guest vector
		
		vmcs_write32( VMCS_32BIT_CONTROL_VMENTRY_INTERRUPTION_INFO , host_vector);
	}
	
	
	
	return true;
}

bool
handle_rdmsr(struct Trapframe *tf, struct VmxGuestInfo *ginfo) {
    uint64_t msr = tf->tf_regs.reg_rcx;
	msr = EFER_MSR;
    if(msr == EFER_MSR) {
		// TODO: setup msr_bitmap to ignore EFER_MSR
		uint64_t val;
		struct vmx_msr_entry *entry;
		bool r = find_msr_in_region(msr, ginfo->msr_guest_area, ginfo->msr_count, &entry);
		assert(r);
		val = entry->msr_value;

		tf->tf_regs.reg_rdx = val << 32;
		tf->tf_regs.reg_rax = val & 0xFFFFFFFF;

		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		return true;
	}
	return false;
}

bool 
handle_wrmsr(struct Trapframe *tf, struct VmxGuestInfo *ginfo) {
	uint64_t msr = tf->tf_regs.reg_rcx;
	msr = EFER_MSR;
	if(msr == EFER_MSR) {

		uint64_t cur_val, new_val;
		struct vmx_msr_entry *entry;
		bool r = 
			find_msr_in_region(msr, ginfo->msr_guest_area, ginfo->msr_count, &entry);
		assert(r);
		cur_val = entry->msr_value;

		new_val = (tf->tf_regs.reg_rdx << 32)|tf->tf_regs.reg_rax;
		if(BIT(cur_val, EFER_LME) == 0 && BIT(new_val, EFER_LME) == 1) {
			// Long mode enable.
			uint32_t entry_ctls = vmcs_read32( VMCS_32BIT_CONTROL_VMENTRY_CONTROLS );
			//entry_ctls |= VMCS_VMENTRY_x64_GUEST;
			vmcs_write32( VMCS_32BIT_CONTROL_VMENTRY_CONTROLS, 
				      entry_ctls );

		}

		entry->msr_value = new_val;
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		return true;
	}

	return false;
}

bool
handle_eptviolation(uint64_t *eptrt, struct VmxGuestInfo *ginfo) {
	uint64_t gpa = vmcs_read64(VMCS_64BIT_GUEST_PHYSICAL_ADDR);
	int r;

	cprintf("gpa %x\n", gpa);

	if(gpa < 0xA0000 || (gpa >= 0x100000 && gpa < ginfo->phys_sz)) 

	{
		// Allocate a new page to the guest.
		struct PageInfo *p = page_alloc(0);
		if(!p) {
			cprintf("vmm: handle_eptviolation: Failed to allocate a page for guest---out of memory.\n");
			return false;
		}
		p->pp_ref += 1;
		r = ept_map_hva2gpa(eptrt, 
				    page2kva(p), (void *)ROUNDDOWN(gpa, PGSIZE), __EPTE_FULL, 0);
		assert(r >= 0);

		//cprintf("EPT violation for gpa:%x mapped KVA:%x\n", gpa, page2kva(p));
		return true;
	} else if (gpa >= CGA_BUF && gpa < CGA_BUF + PGSIZE) {
		// FIXME: This give direct access to VGA MMIO region.
		r = ept_map_hva2gpa(eptrt, 
				    (void *)(KERNBASE + CGA_BUF), (void *)CGA_BUF, __EPTE_FULL, 0);
		assert(r >= 0);
		return true;
	}
	cprintf("vmm: handle_eptviolation: Case 2, gpa %x\n", gpa);
	return false;
}

bool
handle_ioinstr(struct Trapframe *tf, struct VmxGuestInfo *ginfo) {
	static int port_iortc;
	
	uint64_t qualification = vmcs_read64(VMCS_VMEXIT_QUALIFICATION);
	int port_number = (qualification >> 16) & 0xFFFF;
	bool is_in = BIT(qualification, 3);
	bool handled = false;
	
	// handle reading physical memory from the CMOS.
	if(port_number == IO_RTC) {
		if(!is_in) {
			port_iortc = tf->tf_regs.reg_rax;
			handled = true;
		}
	} else if (port_number == IO_RTC + 1) {
		if(is_in) {
			if(port_iortc == NVRAM_BASELO) {
				tf->tf_regs.reg_rax = 640 & 0xFF;
				handled = true;
			} else if (port_iortc == NVRAM_BASEHI) {
				tf->tf_regs.reg_rax = (640 >> 8) & 0xFF;
				handled = true;
			} else if (port_iortc == NVRAM_EXTLO) {
				tf->tf_regs.reg_rax = ((ginfo->phys_sz / 1024) - 1024) & 0xFF;
				handled = true;
			} else if (port_iortc == NVRAM_EXTHI) {
				tf->tf_regs.reg_rax = (((ginfo->phys_sz / 1024) - 1024) >> 8) & 0xFF;
				handled = true;
			}
		}
		
	} 

	if(handled) {
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
		return true;
	} else {
		cprintf("%x %x\n", qualification, port_iortc);
		return false;    
	}
}

// Emulate a cpuid instruction.
// It is sufficient to issue the cpuid instruction here and collect the return value.
// You can store the output of the instruction in Trapframe tf,
//  but you should hide the presence of vmx from the guest if processor features are requested.
// 
// Return true if the exit is handled properly, false if the VM should be terminated.
//
// Finally, you need to increment the program counter in the trap frame.
// 
// Hint: The TA's solution does not hard-code the length of the cpuid instruction.
bool
handle_cpuid(struct Trapframe *tf, struct VmxGuestInfo *ginfo)
{
	uint32_t eax, ebx, ecx, edx;	
	
	cpuid(tf->tf_regs.reg_rax, &eax, &ebx, &ecx, &edx);

	if (tf->tf_regs.reg_rax == 0x1){
		if (ecx & 0x20)
			ecx -= 0x20; 
	}

	tf->tf_regs.reg_rax = eax;
	tf->tf_regs.reg_rbx = ebx;
	tf->tf_regs.reg_rcx = ecx;
	tf->tf_regs.reg_rdx = edx;

	tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
	return true;
}


// Handle vmcall traps from the guest.
// We currently support 3 traps: read the virtual e820 map, 
//   and use host-level IPC (send andrecv).
//
// Return true if the exit is handled properly, false if the VM should be terminated.
//
// Finally, you need to increment the program counter in the trap frame.
// 
// Hint: The TA's solution does not hard-code the length of the cpuid instruction.//

bool
handle_vmcall(struct Trapframe *tf, struct VmxGuestInfo *gInfo, uint64_t *eptrt)
{
	bool handled = false;
	struct multiboot_info *mbinfo;
	struct memory_map *mmap;
	int perm, r, i;
	void *gpa_pg, *hva_pg;
	envid_t to_env;
	uint32_t val;
	// phys address of the multiboot map in the guest.
	uint64_t multiboot_map_addr = 0x6000;
	struct PageInfo *p;

	switch(tf->tf_regs.reg_rax) {
	case VMX_VMCALL_MBMAP:
		// Craft a multiboot (e820) memory map for the guest.
		//
		// Create three  memory mapping segments: 640k of low mem, the I/O hole (unusable), and 
		//   high memory (phys_size - 1024k).
		//
		// Once the map is ready, find the kernel virtual address of the guest page (if present),
		//   or allocate one and map it at the multiboot_map_addr (0x6000).
		// Copy the mbinfo and memory_map_t (segment descriptions) into the guest page, and return
		//   a pointer to this region in rbx (as a guest physical address).
		/* Your code here */

		// check mapping exist
		ept_gpa2hva((void *)eptrt, (void *)multiboot_map_addr, &hva_pg);
		if (hva_pg == NULL){
			p = page_alloc(ALLOC_ZERO);
			hva_pg = page2kva(p);
			ept_map_hva2gpa((void *)eptrt, hva_pg, (void *)multiboot_map_addr, __EPTE_FULL, 0);
		}
		
		mbinfo = (struct multiboot_info *)hva_pg;
		mbinfo->flags = MB_FLAG_MMAP;
		mbinfo->mmap_addr = (uint64_t)(multiboot_map_addr + sizeof(struct multiboot_info));
		mbinfo->mmap_length = 3 * sizeof(memory_map_t);

		mmap = (memory_map_t *)(hva_pg + sizeof(struct multiboot_info));
		mmap->size = 20;
		mmap->base_addr_low = 0;
		mmap->base_addr_high = 0;
		mmap->length_low = 0xA0000;
		mmap->length_high = 0;	
		mmap->type = MB_TYPE_USABLE;

		mmap+=1;
		mmap->size = 20;
		mmap->base_addr_low = 0xA0000;
		mmap->base_addr_high = 0;
		mmap->length_low = 0x60000;;
		mmap->length_high = 0;
		mmap->type = MB_TYPE_RESERVED;

		mmap+=1;
		mmap->size = 20; 
		mmap->base_addr_low = 0x100000;
		mmap->base_addr_high = 0;
		mmap->length_low = gInfo->phys_sz - 0x100000;
		mmap->length_high = 0;
		mmap->type = MB_TYPE_USABLE;	

		tf->tf_regs.reg_rbx = multiboot_map_addr;		
		handled = true;
		break;
	case VMX_VMCALL_IPCSEND:
		// Issue the sys_ipc_send call to the host.
		// 
		// If the requested environment is the HOST FS, this call should
		//  do this translation.
		//
		// The input should be a guest physical address; you will need to convert
		//  this to a host virtual address for the IPC to work properly.
		/* Your code here */
		ept_gpa2hva(eptrt, (void *)tf->tf_regs.reg_rdx, &hva_pg);
		
		for (i = 0; i < NENV; i++) {
			if (envs[i].env_type == tf->tf_regs.reg_rbx){
				to_env =  envs[i].env_id;
				break;
			}
		}
		
		tf->tf_regs.reg_rax = syscall(SYS_ipc_try_send,
						to_env,
						tf->tf_regs.reg_rcx, 
						(uint64_t)hva_pg,
						PTE_P | PTE_W | PTE_U,
						0);	
		handled = true;
		break;

	case VMX_VMCALL_IPCRECV:
		// Issue the sys_ipc_recv call for the guest.
		// NB: because recv can call schedule, clobbering the VMCS, 
		// you should go ahead and increment rip before this call.
		/* Your code here */
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH); 
		/*ept_gpa2hva(eptrt, (void *)tf->tf_regs.reg_rbx, &hva_pg);
		tf->tf_regs.reg_rax = syscall(SYS_ipc_recv,
			(uint64_t)hva_pg,
			0, 0, 0, 0);	
		*/
		
		tf->tf_regs.reg_rax = syscall(SYS_ipc_recv,
			(uint64_t)tf->tf_regs.reg_rbx,
			0, 0, 0, 0);	
		handled = true;
		return handled;
	case VMX_VMCALL_LAPICEOI:
		lapic_eoi();
		handled = true;
		break;
	case VMX_VMCALL_BACKTOHOST:
		cprintf("Now back to the host, VM halt in the background, run vmmanager to resume the VM.\n");
		curenv->env_status = ENV_NOT_RUNNABLE;	//mark the guest not runable
		ENV_CREATE(user_sh, ENV_TYPE_USER);	//create a new host shell
		handled = true;
		break;	
	case VMX_VMCALL_GETDISKIMGNUM:	//alloc a number to guest
		tf->tf_regs.reg_rax = vmdisk_number;
		handled = true;
		break;
         
	}
	if(handled) {
		/* Advance the program counter by the length of the vmcall instruction. 
		 * 
		 * Hint: The TA solution does not hard-code the length of the vmcall instruction.
		 */
		/* Your code here */
		tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
	}
	return handled;
}

bool
handle_vmclear(struct Trapframe *tf, struct VmxGuestInfo *gInfo)
{
    physaddr_t L1_gpa = tf->tf_regs.reg_rax;
    pml4e_t *ept_pml4e = L0_env->ept_pml4e;   
    void *hva;
    uint8_t error;
    ept_gpa2hva(ept_pml4e, (void *)L1_gpa, &hva);
   
    if (hva == NULL)
        return false;
    
    error = vmclear(PADDR(hva));
	if (error)
        panic("-E_VMCS_INIT");

    tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
    
    return true;
}

bool
handle_vmptrld(struct Trapframe *tf, struct VmxGuestInfo *gInfo)
{
    physaddr_t L1_gpa = tf->tf_regs.reg_rax;
    pml4e_t *ept_pml4e = L0_env->ept_pml4e;
    void *hva;
    uint8_t error;
    ept_gpa2hva(ept_pml4e, (void *)L1_gpa, &hva);

    if (hva == NULL)
        return false;
    
    /* save L2 vmcs region */
    L1_env->L2_vmcs = hva; 
    
    /* Noting to do with vmptrld just change rip */
	tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
    return true;
}

bool
handle_vmwrite(struct Trapframe *tf, struct VmxGuestInfo *gInfo)
{
    // change to L2 vmcs region 
    vmptrld(PADDR(L1_env->L2_vmcs));
   
    vmcs_writel(tf->tf_regs.reg_rdx, tf->tf_regs.reg_rax);

    // change back to L1 vmcs region
    vmptrld(PADDR(L1_env->env_vmxinfo.vmcs));
    
	tf->tf_rip += vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
    return true;
}

bool
handle_vmlaunch(struct Trapframe *tf, struct VmxGuestInfo *gInfo)
{
    pml4e_t *ept_01 = NULL;
    pml4e_t *ept_12_L1_gpa = NULL;
    pml4e_t *ept_12 = NULL;
    pml4e_t *ept_02 = NULL;
	uint8_t error;
	uintptr_t *vmcs;
	uintptr_t *msr_host_area;
	uintptr_t *msr_guest_area;

	vmcs2cache(vmcs01);
	vmptrld(PADDR(L1_env->L2_vmcs));
	vmcs2cache(vmcs12);
	vmptrld(PADDR(L1_env->env_vmxinfo.vmcs));

	//cache2vmcs_host(vmcs01);
	//cache2vmcs_guest(vmcs12);
	//cache2vmcs_ctl_host(vmcs01);
	//cache2vmcs_ctl_guest(vmcs12);

	//EPT table construct
	ept_01 = (pml4e_t *)(~0xfff & (uint64_t)KADDR((physaddr_t)vmcs01->vmcs_64bit_control_eptptr));
	ept_12_L1_gpa = (pml4e_t *)(~0xfff & (uint64_t)vmcs12->vmcs_64bit_control_eptptr);
	ept_gpa2hva(ept_01, ept_12_L1_gpa, (void **)&ept_12);
	ept_02 = ept_construct(ept_01, ept_12);


	vmptrld(PADDR(vmcs_launch));
	// Set EPT to VMCS02 
	vmcs_write64( VMCS_64BIT_CONTROL_EPTPTR, PADDR(ept_02) | VMX_EPT_DEFAULT_MT | (VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT) );		
	
    // vmlaunch to L2
	tf->tf_rsp = vmcs_read64(VMCS_GUEST_RSP);
	tf->tf_rip = vmcs_read64(VMCS_GUEST_RIP);
	//vmcs_dump_cpu_1();
	//print_trapframe(tf);
	
	asm_vmrun_L2( tf );
	panic("vmlaunch should never return^^");
}

pml4e_t *
ept_construct(pml4e_t *ept_01, pml4e_t *ept_12)
{
	physaddr_t p;
	pte_t *pte_L1 = NULL;
	pte_t *pte_L0 = NULL;
	pml4e_t *ept_02 = NULL;

	// allocate a page for EPT 02
	struct PageInfo *p_ept02 = NULL;

	if (!(p_ept02 = page_alloc(ALLOC_ZERO)))
		panic("-E_NO_MEM");

	memset(p_ept02, 0, sizeof(struct PageInfo));
	ept_02 = page2kva(p_ept02);

	for (p = JOS_ENTRY; p < JOS_ENTRY + GUEST_MEM_SZ * 2; p += PGSIZE)
	{
		pte_L1 = pml4e_walk_L1(ept_01 ,ept_12, (void *)p, 0);	
		if (pte_L1 == NULL)
			continue;

		pte_L0 = pml4e_walk(ept_01, (void *)(*pte_L1), 0);
		if (pte_L0 == NULL)
			panic("L2 is not mapped to L0");

		if (ept_map_hva2gpa(ept_02, (void *)KADDR(*pte_L0), (void *)p, __EPTE_FULL, 0) < 0)
			panic("-E_NO_MEM");
	}

	return ept_02;
}

void
vmcs2cache(struct Vmcs *cache)
{
	// 16bit control
	cache->vmcs_16bit_control_vpid = vmcs_read16(VMCS_16BIT_CONTROL_VPID);		
	cache->vmcs_16bit_control_posted_interrupt_vector = vmcs_read16(VMCS_16BIT_CONTROL_POSTED_INTERRUPT_VECTOR);
	cache->vmcs_16bit_control_eptp_index = vmcs_read16(VMCS_16BIT_CONTROL_EPTP_INDEX);
	
	// 16bit guest
	cache->vmcs_16bit_guest_es_selector = vmcs_read16(VMCS_16BIT_GUEST_ES_SELECTOR);
	cache->vmcs_16bit_guest_ss_selector = vmcs_read16(VMCS_16BIT_GUEST_SS_SELECTOR);
	cache->vmcs_16bit_guest_ds_selector = vmcs_read16(VMCS_16BIT_GUEST_DS_SELECTOR);
	cache->vmcs_16bit_guest_fs_selector = vmcs_read16(VMCS_16BIT_GUEST_FS_SELECTOR);
	cache->vmcs_16bit_guest_gs_selector = vmcs_read16(VMCS_16BIT_GUEST_GS_SELECTOR);
	cache->vmcs_16bit_guest_ldtr_selector = vmcs_read16(VMCS_16BIT_GUEST_LDTR_SELECTOR);
	cache->vmcs_16bit_guest_tr_selector = vmcs_read16(VMCS_16BIT_GUEST_TR_SELECTOR);
	cache->vmcs_16bit_guest_interrupt_status = vmcs_read16(VMCS_16BIT_GUEST_INTERRUPT_STATUS);

	// 16bit host
	cache->vmcs_16bit_host_es_selector = vmcs_read16(VMCS_16BIT_HOST_ES_SELECTOR);
	cache->vmcs_16bit_host_cs_selector = vmcs_read16(VMCS_16BIT_HOST_CS_SELECTOR);
	cache->vmcs_16bit_host_ss_selector = vmcs_read16(VMCS_16BIT_HOST_SS_SELECTOR);
	cache->vmcs_16bit_host_ds_selector = vmcs_read16(VMCS_16BIT_HOST_DS_SELECTOR);
	cache->vmcs_16bit_host_fs_selector = vmcs_read16(VMCS_16BIT_HOST_FS_SELECTOR);
	cache->vmcs_16bit_host_gs_selector = vmcs_read16(VMCS_16BIT_HOST_GS_SELECTOR);
	cache->vmcs_16bit_host_tr_selector = vmcs_read16(VMCS_16BIT_HOST_TR_SELECTOR);

	// 64bit control 
	cache->vmcs_64bit_control_io_bitmap_a = vmcs_read64(VMCS_64BIT_CONTROL_IO_BITMAP_A);
	cache->vmcs_64bit_control_io_bitmap_a_hi = vmcs_read64(VMCS_64BIT_CONTROL_IO_BITMAP_A_HI);
	cache->vmcs_64bit_control_io_bitmap_b = vmcs_read64(VMCS_64BIT_CONTROL_IO_BITMAP_B);
	cache->vmcs_64bit_control_io_bitmap_b_hi = vmcs_read64(VMCS_64BIT_CONTROL_IO_BITMAP_B_HI);
	cache->vmcs_64bit_control_msr_bitmaps = vmcs_read64(VMCS_64BIT_CONTROL_MSR_BITMAPS);
	cache->vmcs_64bit_control_msr_bitmaps_hi = vmcs_read64(VMCS_64BIT_CONTROL_MSR_BITMAPS_HI);
	cache->vmcs_64bit_control_vmexit_msr_store_addr = vmcs_read64(VMCS_64BIT_CONTROL_VMEXIT_MSR_STORE_ADDR);
	cache->vmcs_64bit_control_vmexit_msr_store_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VMEXIT_MSR_STORE_ADDR_HI);
	cache->vmcs_64bit_control_vmexit_msr_load_addr = vmcs_read64(VMCS_64BIT_CONTROL_VMEXIT_MSR_LOAD_ADDR);
	cache->vmcs_64bit_control_vmexit_msr_load_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VMEXIT_MSR_LOAD_ADDR_HI);
	cache->vmcs_64bit_control_vmentry_msr_load_addr = vmcs_read64(VMCS_64BIT_CONTROL_VMENTRY_MSR_LOAD_ADDR);
	cache->vmcs_64bit_control_vmentry_msr_load_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VMENTRY_MSR_LOAD_ADDR_HI);
	cache->vmcs_64bit_control_executive_vmcs_ptr = vmcs_read64(VMCS_64BIT_CONTROL_EXECUTIVE_VMCS_PTR);
	cache->vmcs_64bit_control_executive_vmcs_ptr_hi = vmcs_read64(VMCS_64BIT_CONTROL_EXECUTIVE_VMCS_PTR_HI);
	cache->vmcs_64bit_control_tsc_offset = vmcs_read64(VMCS_64BIT_CONTROL_TSC_OFFSET);
	cache->vmcs_64bit_control_tsc_offset_hi = vmcs_read64(VMCS_64BIT_CONTROL_TSC_OFFSET_HI);
	cache->vmcs_64bit_control_virtual_apic_page_addr = vmcs_read64(VMCS_64BIT_CONTROL_VIRTUAL_APIC_PAGE_ADDR);
	cache->vmcs_64bit_control_virtual_apic_page_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VIRTUAL_APIC_PAGE_ADDR_HI);
	cache->vmcs_64bit_control_apic_access_addr = vmcs_read64(VMCS_64BIT_CONTROL_APIC_ACCESS_ADDR);
	cache->vmcs_64bit_control_apic_access_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_APIC_ACCESS_ADDR_HI);
	cache->vmcs_64bit_control_posted_interrupt_desc_addr = vmcs_read64(VMCS_64BIT_CONTROL_POSTED_INTERRUPT_DESC_ADDR);
	cache->vmcs_64bit_control_posted_interrupt_desc_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_POSTED_INTERRUPT_DESC_ADDR_HI);
	cache->vmcs_64bit_control_vmfunc_ctrls = vmcs_read64(VMCS_64BIT_CONTROL_VMFUNC_CTRLS);
	cache->vmcs_64bit_control_vmfunc_ctrls_hi = vmcs_read64(VMCS_64BIT_CONTROL_VMFUNC_CTRLS_HI);
	cache->vmcs_64bit_control_eptptr = vmcs_read64(VMCS_64BIT_CONTROL_EPTPTR);
	cache->vmcs_64bit_control_eptptr_hi = vmcs_read64(VMCS_64BIT_CONTROL_EPTPTR_HI);
	cache->vmcs_64bit_control_eoi_exit_bitmap0 = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP0);
	cache->vmcs_64bit_control_eoi_exit_bitmap0_hi = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP0_HI);
	cache->vmcs_64bit_control_eoi_exit_bitmap1 = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP1);
	cache->vmcs_64bit_control_eoi_exit_bitmap1_hi = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP1_HI);
	cache->vmcs_64bit_control_eoi_exit_bitmap2 = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP2);
	cache->vmcs_64bit_control_eoi_exit_bitmap2_hi = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP2_HI);
	cache->vmcs_64bit_control_eoi_exit_bitmap3 = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP3);
	cache->vmcs_64bit_control_eoi_exit_bitmap3_hi = vmcs_read64(VMCS_64BIT_CONTROL_EOI_EXIT_BITMAP3_HI);
	cache->vmcs_64bit_control_eptp_list_address = vmcs_read64(VMCS_64BIT_CONTROL_EPTP_LIST_ADDRESS);
	cache->vmcs_64bit_control_eptp_list_address_hi = vmcs_read64(VMCS_64BIT_CONTROL_EPTP_LIST_ADDRESS_HI);
	cache->vmcs_64bit_control_vmread_bitmap_addr = vmcs_read64(VMCS_64BIT_CONTROL_VMREAD_BITMAP_ADDR);
	cache->vmcs_64bit_control_vmread_bitmap_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VMREAD_BITMAP_ADDR_HI);
	cache->vmcs_64bit_control_vmwrite_bitmap_addr = vmcs_read64(VMCS_64BIT_CONTROL_VMWRITE_BITMAP_ADDR);
	cache->vmcs_64bit_control_vmwrite_bitmap_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VMWRITE_BITMAP_ADDR_HI);
	cache->vmcs_64bit_control_ve_exception_info_addr = vmcs_read64(VMCS_64BIT_CONTROL_VE_EXCEPTION_INFO_ADDR);
	cache->vmcs_64bit_control_ve_exception_info_addr_hi = vmcs_read64(VMCS_64BIT_CONTROL_VE_EXCEPTION_INFO_ADDR_HI);

	// 64bit read only guest
	cache->vmcs_64bit_guest_physical_addr = vmcs_read64(VMCS_64BIT_GUEST_PHYSICAL_ADDR);
	cache->vmcs_64bit_guest_physical_addr_hi = vmcs_read64(VMCS_64BIT_GUEST_PHYSICAL_ADDR_HI);

	// 64bit guest
	cache->vmcs_64bit_guest_link_pointer = vmcs_read64(VMCS_64BIT_GUEST_LINK_POINTER);
	cache->vmcs_64bit_guest_link_pointer_hi = vmcs_read64(VMCS_64BIT_GUEST_LINK_POINTER_HI);
	cache->vmcs_64bit_guest_ia32_debugctl = vmcs_read64(VMCS_64BIT_GUEST_IA32_DEBUGCTL);
	cache->vmcs_64bit_guest_ia32_debugctl_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_DEBUGCTL_HI);
	cache->vmcs_64bit_guest_ia32_pat = vmcs_read64(VMCS_64BIT_GUEST_IA32_PAT);
	cache->vmcs_64bit_guest_ia32_pat_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_PAT_HI);
	cache->vmcs_64bit_guest_ia32_efer = vmcs_read64(VMCS_64BIT_GUEST_IA32_EFER);
	cache->vmcs_64bit_guest_ia32_efer_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_EFER_HI);
	cache->vmcs_64bit_guest_ia32_perf_global_ctrl = vmcs_read64(VMCS_64BIT_GUEST_IA32_PERF_GLOBAL_CTRL);
	cache->vmcs_64bit_guest_ia32_perf_global_ctrl_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_PERF_GLOBAL_CTRL_HI);
	cache->vmcs_64bit_guest_ia32_pdpte0 = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE0);
	cache->vmcs_64bit_guest_ia32_pdpte0_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE0_HI);
	cache->vmcs_64bit_guest_ia32_pdpte1 = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE1);
	cache->vmcs_64bit_guest_ia32_pdpte1_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE1_HI);
	cache->vmcs_64bit_guest_ia32_pdpte2 = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE2);
	cache->vmcs_64bit_guest_ia32_pdpte2_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE2_HI);
	cache->vmcs_64bit_guest_ia32_pdpte3 = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE3);
	cache->vmcs_64bit_guest_ia32_pdpte3_hi = vmcs_read64(VMCS_64BIT_GUEST_IA32_PDPTE3_HI);

	// 64bit host
	cache->vmcs_64bit_host_ia32_pat = vmcs_read64(VMCS_64BIT_HOST_IA32_PAT);
	cache->vmcs_64bit_host_ia32_pat_hi = vmcs_read64(VMCS_64BIT_HOST_IA32_PAT_HI);
	cache->vmcs_64bit_host_ia32_efer = vmcs_read64(VMCS_64BIT_HOST_IA32_EFER);
	cache->vmcs_64bit_host_ia32_efer_hi = vmcs_read64(VMCS_64BIT_HOST_IA32_EFER_HI);
	cache->vmcs_64bit_host_ia32_perf_global_ctrl = vmcs_read64(VMCS_64BIT_HOST_IA32_PERF_GLOBAL_CTRL);
	cache->vmcs_64bit_host_ia32_perf_global_ctrl_hi = vmcs_read64(VMCS_64BIT_HOST_IA32_PERF_GLOBAL_CTRL_HI);

	// 32bit control
	cache->vmcs_32bit_control_pin_based_exec_controls = vmcs_read32(VMCS_32BIT_CONTROL_PIN_BASED_EXEC_CONTROLS);
	cache->vmcs_32bit_control_processor_based_vmexec_controls = vmcs_read32(VMCS_32BIT_CONTROL_PROCESSOR_BASED_VMEXEC_CONTROLS);
	cache->vmcs_32bit_control_exception_bitmap = vmcs_read32(VMCS_32BIT_CONTROL_EXCEPTION_BITMAP);
	cache->vmcs_32bit_control_page_fault_err_code_mask = vmcs_read32(VMCS_32BIT_CONTROL_PAGE_FAULT_ERR_CODE_MASK);
	cache->vmcs_32bit_control_page_fault_err_code_match = vmcs_read32(VMCS_32BIT_CONTROL_PAGE_FAULT_ERR_CODE_MATCH);
	cache->vmcs_32bit_control_cr3_target_count = vmcs_read32(VMCS_32BIT_CONTROL_CR3_TARGET_COUNT);
	cache->vmcs_32bit_control_vmexit_controls = vmcs_read32(VMCS_32BIT_CONTROL_VMEXIT_CONTROLS);
	cache->vmcs_32bit_control_vmexit_msr_store_count = vmcs_read32(VMCS_32BIT_CONTROL_VMEXIT_MSR_STORE_COUNT);
	cache->vmcs_32bit_control_vmexit_msr_load_count = vmcs_read32(VMCS_32BIT_CONTROL_VMEXIT_MSR_LOAD_COUNT);

	cache->vmcs_32bit_control_vmentry_controls = vmcs_read32(VMCS_32BIT_CONTROL_VMENTRY_CONTROLS);
	cache->vmcs_32bit_control_vmentry_msr_load_count = vmcs_read32(VMCS_32BIT_CONTROL_VMENTRY_MSR_LOAD_COUNT);
	cache->vmcs_32bit_control_vmentry_interruption_info = vmcs_read32(VMCS_32BIT_CONTROL_VMENTRY_INTERRUPTION_INFO);
	cache->vmcs_32bit_control_vmentry_exception_err_code = vmcs_read32(VMCS_32BIT_CONTROL_VMENTRY_EXCEPTION_ERR_CODE);
	cache->vmcs_32bit_control_vmentry_instruction_length = vmcs_read32(VMCS_32BIT_CONTROL_VMENTRY_INSTRUCTION_LENGTH);
	cache->vmcs_32bit_control_tpr_threshold = vmcs_read32(VMCS_32BIT_CONTROL_TPR_THRESHOLD);
	cache->vmcs_32bit_control_secondary_vmexec_controls = vmcs_read32(VMCS_32BIT_CONTROL_SECONDARY_VMEXEC_CONTROLS);
	cache->vmcs_32bit_control_pause_loop_exiting_gap = vmcs_read32(VMCS_32BIT_CONTROL_PAUSE_LOOP_EXITING_GAP);
	cache->vmcs_32bit_control_pause_loop_exiting_window = vmcs_read32(VMCS_32BIT_CONTROL_PAUSE_LOOP_EXITING_WINDOW);

	// 32bit read only data field
	cache->vmcs_32bit_instruction_error = vmcs_read32(VMCS_32BIT_INSTRUCTION_ERROR);
	cache->vmcs_32bit_vmexit_reason = vmcs_read32(VMCS_32BIT_VMEXIT_REASON);
	cache->vmcs_32bit_vmexit_interruption_info = vmcs_read32(VMCS_32BIT_VMEXIT_INTERRUPTION_INFO);
	cache->vmcs_32bit_vmexit_interruption_err_code = vmcs_read32(VMCS_32BIT_VMEXIT_INTERRUPTION_ERR_CODE);
	cache->vmcs_32bit_idt_vectoring_info = vmcs_read32(VMCS_32BIT_IDT_VECTORING_INFO);
	cache->vmcs_32bit_idt_vectoring_err_code = vmcs_read32(VMCS_32BIT_IDT_VECTORING_ERR_CODE);
	cache->vmcs_32bit_vmexit_instruction_length = vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_LENGTH);
	cache->vmcs_32bit_vmexit_instruction_info = vmcs_read32(VMCS_32BIT_VMEXIT_INSTRUCTION_INFO);

	// 32bit guest
	cache->vmcs_32bit_guest_es_limit = vmcs_read32(VMCS_32BIT_GUEST_ES_LIMIT);
	cache->vmcs_32bit_guest_cs_limit = vmcs_read32(VMCS_32BIT_GUEST_CS_LIMIT);
	cache->vmcs_32bit_guest_ss_limit = vmcs_read32(VMCS_32BIT_GUEST_SS_LIMIT);
	cache->vmcs_32bit_guest_ds_limit = vmcs_read32(VMCS_32BIT_GUEST_DS_LIMIT);
	cache->vmcs_32bit_guest_fs_limit = vmcs_read32(VMCS_32BIT_GUEST_FS_LIMIT);
	cache->vmcs_32bit_guest_gs_limit = vmcs_read32(VMCS_32BIT_GUEST_GS_LIMIT);
	cache->vmcs_32bit_guest_ldtr_limit = vmcs_read32(VMCS_32BIT_GUEST_LDTR_LIMIT);
	cache->vmcs_32bit_guest_tr_limit = vmcs_read32(VMCS_32BIT_GUEST_TR_LIMIT);
	cache->vmcs_32bit_guest_gdtr_limit = vmcs_read32(VMCS_32BIT_GUEST_GDTR_LIMIT);
	cache->vmcs_32bit_guest_idtr_limit = vmcs_read32(VMCS_32BIT_GUEST_IDTR_LIMIT);
	cache->vmcs_32bit_guest_es_access_rights = vmcs_read32(VMCS_32BIT_GUEST_ES_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_cs_access_rights = vmcs_read32(VMCS_32BIT_GUEST_CS_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_ss_access_rights = vmcs_read32(VMCS_32BIT_GUEST_SS_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_ds_access_rights = vmcs_read32(VMCS_32BIT_GUEST_DS_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_fs_access_rights = vmcs_read32(VMCS_32BIT_GUEST_FS_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_gs_access_rights = vmcs_read32(VMCS_32BIT_GUEST_GS_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_ldtr_access_rights = vmcs_read32(VMCS_32BIT_GUEST_LDTR_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_tr_access_rights = vmcs_read32(VMCS_32BIT_GUEST_TR_ACCESS_RIGHTS);
	cache->vmcs_32bit_guest_interruptibility_state = vmcs_read32(VMCS_32BIT_GUEST_INTERRUPTIBILITY_STATE);
	cache->vmcs_32bit_guest_activity_state = vmcs_read32(VMCS_32BIT_GUEST_ACTIVITY_STATE);
	cache->vmcs_32bit_guest_smbase = vmcs_read32(VMCS_32BIT_GUEST_SMBASE);
	cache->vmcs_32bit_guest_ia32_sysenter_cs_msr = vmcs_read32(VMCS_32BIT_GUEST_IA32_SYSENTER_CS_MSR);
	cache->vmcs_32bit_guest_preemption_timer_value = vmcs_read32(VMCS_32BIT_GUEST_PREEMPTION_TIMER_VALUE);
	
	// 32bit host 
	cache->vmcs_32bit_host_ia32_sysenter_cs_msr = vmcs_read32(VMCS_32BIT_HOST_IA32_SYSENTER_CS_MSR);
	
	// natural width control
	cache->vmcs_control_cr0_guest_host_mask = vmcs_read64(VMCS_CONTROL_CR0_GUEST_HOST_MASK);
	cache->vmcs_control_cr4_guest_host_mask = vmcs_read64(VMCS_CONTROL_CR4_GUEST_HOST_MASK);
	cache->vmcs_control_cr0_read_shadow = vmcs_read64(VMCS_CONTROL_CR0_READ_SHADOW);
	cache->vmcs_control_cr4_read_shadow = vmcs_read64(VMCS_CONTROL_CR4_READ_SHADOW);
	cache->vmcs_cr3_target0 = vmcs_read64(VMCS_CR3_TARGET0);
	cache->vmcs_cr3_target1 = vmcs_read64(VMCS_CR3_TARGET1);
	cache->vmcs_cr3_target2 = vmcs_read64(VMCS_CR3_TARGET2);
	cache->vmcs_cr3_target3 = vmcs_read64(VMCS_CR3_TARGET3);

	// natural width read only data field
	cache->vmcs_vmexit_qualification = vmcs_read64(VMCS_VMEXIT_QUALIFICATION);
	cache->vmcs_io_rcx = vmcs_read64(VMCS_IO_RCX);
	cache->vmcs_io_rsi = vmcs_read64(VMCS_IO_RSI);
	cache->vmcs_io_rdi = vmcs_read64(VMCS_IO_RDI);
	cache->vmcs_io_rip = vmcs_read64(VMCS_IO_RIP);
	cache->vmcs_guest_linear_addr = vmcs_read64(VMCS_GUEST_LINEAR_ADDR);

	// natural width guest
	cache->vmcs_guest_cr0 = vmcs_read64(VMCS_GUEST_CR0);
	cache->vmcs_guest_cr3 = vmcs_read64(VMCS_GUEST_CR3);
	cache->vmcs_guest_es_base = vmcs_read64(VMCS_GUEST_ES_BASE);
	cache->vmcs_guest_cs_base = vmcs_read64(VMCS_GUEST_CS_BASE);
	cache->vmcs_guest_ss_base = vmcs_read64(VMCS_GUEST_SS_BASE);
	cache->vmcs_guest_ds_base = vmcs_read64(VMCS_GUEST_DS_BASE);
	cache->vmcs_guest_fs_base = vmcs_read64(VMCS_GUEST_FS_BASE);
	cache->vmcs_guest_gs_base = vmcs_read64(VMCS_GUEST_GS_BASE);
	cache->vmcs_guest_ldtr_base = vmcs_read64(VMCS_GUEST_LDTR_BASE);
	cache->vmcs_guest_tr_base = vmcs_read64(VMCS_GUEST_TR_BASE);
	cache->vmcs_guest_gdtr_base = vmcs_read64(VMCS_GUEST_GDTR_BASE);
	cache->vmcs_guest_idtr_base = vmcs_read64(VMCS_GUEST_IDTR_BASE);
	cache->vmcs_guest_dr7 = vmcs_read64(VMCS_GUEST_DR7);
	cache->vmcs_guest_rsp = vmcs_read64(VMCS_GUEST_RSP);
	cache->vmcs_guest_rip = vmcs_read64(VMCS_GUEST_RIP);
	cache->vmcs_guest_rflags = vmcs_read64(VMCS_GUEST_RFLAGS);
	cache->vmcs_guest_pending_dbg_exceptions = vmcs_read64(VMCS_GUEST_PENDING_DBG_EXCEPTIONS);
	cache->vmcs_guest_ia32_sysenter_esp_msr = vmcs_read64(VMCS_GUEST_IA32_SYSENTER_ESP_MSR);
	cache->vmcs_guest_ia32_sysenter_eip_msr = vmcs_read64(VMCS_GUEST_IA32_SYSENTER_EIP_MSR);

	// natural width host
	cache->vmcs_host_cr0 = vmcs_read64(VMCS_HOST_CR0);
	cache->vmcs_host_cr3 = vmcs_read64(VMCS_HOST_CR3);
	cache->vmcs_host_cr4 = vmcs_read64(VMCS_HOST_CR4);
	cache->vmcs_host_fs_base = vmcs_read64(VMCS_HOST_FS_BASE);
	cache->vmcs_host_gs_base = vmcs_read64(VMCS_HOST_GS_BASE);
	cache->vmcs_host_tr_base = vmcs_read64(VMCS_HOST_TR_BASE);
	cache->vmcs_host_gdtr_base = vmcs_read64(VMCS_HOST_GDTR_BASE);
	cache->vmcs_host_idtr_base = vmcs_read64(VMCS_HOST_IDTR_BASE);
	cache->vmcs_host_ia32_sysenter_esp_msr = vmcs_read64(VMCS_HOST_IA32_SYSENTER_ESP_MSR);
	cache->vmcs_host_ia32_sysenter_eip_msr = vmcs_read64(VMCS_HOST_IA32_SYSENTER_EIP_MSR);
	cache->vmcs_host_rsp = vmcs_read64(VMCS_HOST_RSP);
	cache->vmcs_host_rip = vmcs_read64(VMCS_HOST_RIP);
/*
	// natural width control
	cache->vmcs_pin_based_vmexec_ctl_exintexit = vmcs_read64(VMCS_PIN_BASED_VMEXEC_CTL_EXINTEXIT);
	cache->vmcs_pin_based_vmexec_ctl_nmiexit = vmcs_read64(VMCS_PIN_BASED_VMEXEC_CTL_NMIEXIT);
	cache->vmcs_pin_based_vmexec_ctl_virtnmis = vmcs_read64(VMCS_PIN_BASED_VMEXEC_CTL_VIRTNMIS);
	cache->vmcs_proc_based_vmexec_ctl_intrwinexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_INTRWINEXIT);
	cache->vmcs_proc_based_vmexec_ctl_usetscoff = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_USETSCOFF);
	cache->vmcs_proc_based_vmexec_ctl_hltexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_HLTEXIT);
	cache->vmcs_proc_based_vmexec_ctl_invlpgexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_INVLPGEXIT);
	cache->vmcs_proc_based_vmexec_ctl_mwaitexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_MWAITEXIT);
	cache->vmcs_proc_based_vmexec_ctl_rdpmcexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_RDPMCEXIT);
	cache->vmcs_proc_based_vmexec_ctl_rdtscexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_RDTSCEXIT);
	cache->vmcs_proc_based_vmexec_ctl_cr3loadexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_CR3LOADEXIT);
	cache->vmcs_proc_based_vmexec_ctl_cr3storeexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_CR3STOREEXIT);
	cache->vmcs_proc_based_vmexec_ctl_cr8loadexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_CR8LOADEXIT);
	cache->vmcs_proc_based_vmexec_ctl_cr8storeexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_CR8STOREEXIT);
	cache->vmcs_proc_based_vmexec_ctl_usetprshadow = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_USETPRSHADOW);
	cache->vmcs_proc_based_vmexec_ctl_nmiwinexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_NMIWINEXIT);
	cache->vmcs_proc_based_vmexec_ctl_movdrexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_MOVDREXIT);
	cache->vmcs_proc_based_vmexec_ctl_uncondioexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_UNCONDIOEXIT);
	cache->vmcs_proc_based_vmexec_ctl_useiobmp = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_USEIOBMP);
	cache->vmcs_proc_based_vmexec_ctl_mtf = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_MTF);
	cache->vmcs_proc_based_vmexec_ctl_usemsrbmp = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_USEMSRBMP);
	cache->vmcs_proc_based_vmexec_ctl_monitorexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_USEMSRBMP);
	cache->vmcs_proc_based_vmexec_ctl_pauseexit = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_PAUSEEXIT);
	cache->vmcs_proc_based_vmexec_ctl_activesecctl = vmcs_read64(VMCS_PROC_BASED_VMEXEC_CTL_ACTIVESECCTL);
	cache->vmcs_secondary_vmexec_ctl_enable_ept = vmcs_read64(VMCS_SECONDARY_VMEXEC_CTL_ENABLE_EPT);
	cache->vmcs_secondary_vmexec_ctl_unrestricted_guest = vmcs_read64(VMCS_SECONDARY_VMEXEC_CTL_UNRESTRICTED_GUEST);
	cache->vmcs_vmexit_host_addr_size = vmcs_read64(VMCS_VMEXIT_HOST_ADDR_SIZE);
	cache->vmcs_vmexit_guest_ack_intr_on_exit = vmcs_read64(VMCS_VMEXIT_GUEST_ACK_INTR_ON_EXIT);
	cache->vmcs_vmentry_x64_guest = vmcs_read64(VMCS_VMENTRY_x64_GUEST);
*/
}

void 
cache2vmcs_host(struct Vmcs *cache)
{
	// 16 bit host
	vmcs_write16(VMCS_16BIT_HOST_ES_SELECTOR, cache->vmcs_16bit_host_es_selector);
	vmcs_write16(VMCS_16BIT_HOST_CS_SELECTOR, cache->vmcs_16bit_host_cs_selector);
	vmcs_write16(VMCS_16BIT_HOST_SS_SELECTOR, cache->vmcs_16bit_host_ss_selector);
	vmcs_write16(VMCS_16BIT_HOST_DS_SELECTOR, cache->vmcs_16bit_host_ds_selector);
	vmcs_write16(VMCS_16BIT_HOST_FS_SELECTOR, cache->vmcs_16bit_host_fs_selector);
	vmcs_write16(VMCS_16BIT_HOST_GS_SELECTOR, cache->vmcs_16bit_host_gs_selector);
	vmcs_write16(VMCS_16BIT_HOST_TR_SELECTOR, cache->vmcs_16bit_host_tr_selector);

	// 64bit host
	vmcs_write64(VMCS_64BIT_HOST_IA32_PAT, cache->vmcs_64bit_host_ia32_pat);
	vmcs_write64(VMCS_64BIT_HOST_IA32_PAT_HI, cache->vmcs_64bit_host_ia32_pat_hi);
	vmcs_write64(VMCS_64BIT_HOST_IA32_EFER, cache->vmcs_64bit_host_ia32_efer);
	vmcs_write64(VMCS_64BIT_HOST_IA32_EFER_HI, cache->vmcs_64bit_host_ia32_efer_hi);
	vmcs_write64(VMCS_64BIT_HOST_IA32_PERF_GLOBAL_CTRL, cache->vmcs_64bit_host_ia32_perf_global_ctrl);
	vmcs_write64(VMCS_64BIT_HOST_IA32_PERF_GLOBAL_CTRL_HI, cache->vmcs_64bit_host_ia32_perf_global_ctrl_hi);

	// 32bit host 
	vmcs_write32(VMCS_32BIT_HOST_IA32_SYSENTER_CS_MSR, cache->vmcs_32bit_host_ia32_sysenter_cs_msr);
	
	// natural width host
	vmcs_write64(VMCS_HOST_CR0, cache->vmcs_host_cr0);
	vmcs_write64(VMCS_HOST_CR3, cache->vmcs_host_cr3);
	vmcs_write64(VMCS_HOST_CR4, cache->vmcs_host_cr4);
	vmcs_write64(VMCS_HOST_FS_BASE, cache->vmcs_host_fs_base);
	vmcs_write64(VMCS_HOST_GS_BASE, cache->vmcs_host_gs_base);
	vmcs_write64(VMCS_HOST_TR_BASE, cache->vmcs_host_tr_base);
	vmcs_write64(VMCS_HOST_GDTR_BASE, cache->vmcs_host_gdtr_base);
	vmcs_write64(VMCS_HOST_IDTR_BASE, cache->vmcs_host_idtr_base);
	vmcs_write64(VMCS_HOST_IA32_SYSENTER_ESP_MSR, cache->vmcs_host_ia32_sysenter_esp_msr);
	vmcs_write64(VMCS_HOST_IA32_SYSENTER_EIP_MSR, cache->vmcs_host_ia32_sysenter_eip_msr);
	vmcs_write64(VMCS_HOST_RSP, cache->vmcs_host_rsp);
	vmcs_write64(VMCS_HOST_RIP, cache->vmcs_host_rip);
}

void
cache2vmcs_guest(struct Vmcs *cache)
{
	// 16bit guest
	vmcs_write16(VMCS_16BIT_GUEST_ES_SELECTOR, cache->vmcs_16bit_guest_es_selector);
	vmcs_write16(VMCS_16BIT_GUEST_SS_SELECTOR, cache->vmcs_16bit_guest_ss_selector);
	vmcs_write16(VMCS_16BIT_GUEST_DS_SELECTOR, cache->vmcs_16bit_guest_ds_selector);
	vmcs_write16(VMCS_16BIT_GUEST_FS_SELECTOR, cache->vmcs_16bit_guest_fs_selector);
	vmcs_write16(VMCS_16BIT_GUEST_GS_SELECTOR, cache->vmcs_16bit_guest_gs_selector);
	vmcs_write16(VMCS_16BIT_GUEST_LDTR_SELECTOR, cache->vmcs_16bit_guest_ldtr_selector);
	vmcs_write16(VMCS_16BIT_GUEST_TR_SELECTOR, cache->vmcs_16bit_guest_tr_selector);
	vmcs_write16(VMCS_16BIT_GUEST_INTERRUPT_STATUS, cache->vmcs_16bit_guest_interrupt_status);

	// 64bit read only guest
	vmcs_write64(VMCS_64BIT_GUEST_PHYSICAL_ADDR, cache->vmcs_64bit_guest_physical_addr);
	vmcs_write64(VMCS_64BIT_GUEST_PHYSICAL_ADDR_HI, cache->vmcs_64bit_guest_physical_addr_hi);

	// 64bit guest
	vmcs_write64(VMCS_64BIT_GUEST_LINK_POINTER, cache->vmcs_64bit_guest_link_pointer);
	vmcs_write64(VMCS_64BIT_GUEST_LINK_POINTER_HI, cache->vmcs_64bit_guest_link_pointer_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_DEBUGCTL, cache->vmcs_64bit_guest_ia32_debugctl);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_DEBUGCTL_HI, cache->vmcs_64bit_guest_ia32_debugctl_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PAT, cache->vmcs_64bit_guest_ia32_pat);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PAT_HI, cache->vmcs_64bit_guest_ia32_pat_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_EFER, cache->vmcs_64bit_guest_ia32_efer);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_EFER_HI, cache->vmcs_64bit_guest_ia32_efer_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PERF_GLOBAL_CTRL, cache->vmcs_64bit_guest_ia32_perf_global_ctrl);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PERF_GLOBAL_CTRL_HI, cache->vmcs_64bit_guest_ia32_perf_global_ctrl_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE0, cache->vmcs_64bit_guest_ia32_pdpte0);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE0_HI, cache->vmcs_64bit_guest_ia32_pdpte0_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE1, cache->vmcs_64bit_guest_ia32_pdpte1);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE1_HI, cache->vmcs_64bit_guest_ia32_pdpte1_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE2, cache->vmcs_64bit_guest_ia32_pdpte2);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE2_HI, cache->vmcs_64bit_guest_ia32_pdpte2_hi);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE3, cache->vmcs_64bit_guest_ia32_pdpte3);
	vmcs_write64(VMCS_64BIT_GUEST_IA32_PDPTE3_HI, cache->vmcs_64bit_guest_ia32_pdpte3_hi);

	// 32bit guest
	vmcs_write32(VMCS_32BIT_GUEST_ES_LIMIT, cache->vmcs_32bit_guest_es_limit);
	vmcs_write32(VMCS_32BIT_GUEST_CS_LIMIT, cache->vmcs_32bit_guest_cs_limit);
	vmcs_write32(VMCS_32BIT_GUEST_SS_LIMIT, cache->vmcs_32bit_guest_ss_limit);
	vmcs_write32(VMCS_32BIT_GUEST_DS_LIMIT, cache->vmcs_32bit_guest_ds_limit);
	vmcs_write32(VMCS_32BIT_GUEST_FS_LIMIT, cache->vmcs_32bit_guest_fs_limit);
	vmcs_write32(VMCS_32BIT_GUEST_GS_LIMIT, cache->vmcs_32bit_guest_gs_limit);
	vmcs_write32(VMCS_32BIT_GUEST_LDTR_LIMIT, cache->vmcs_32bit_guest_ldtr_limit);
	vmcs_write32(VMCS_32BIT_GUEST_TR_LIMIT, cache->vmcs_32bit_guest_tr_limit);
	vmcs_write32(VMCS_32BIT_GUEST_GDTR_LIMIT, cache->vmcs_32bit_guest_gdtr_limit);
	vmcs_write32(VMCS_32BIT_GUEST_IDTR_LIMIT, cache->vmcs_32bit_guest_idtr_limit);
	vmcs_write32(VMCS_32BIT_GUEST_ES_ACCESS_RIGHTS, cache->vmcs_32bit_guest_es_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_CS_ACCESS_RIGHTS, cache->vmcs_32bit_guest_cs_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_SS_ACCESS_RIGHTS, cache->vmcs_32bit_guest_ss_access_rights );
	vmcs_write32(VMCS_32BIT_GUEST_DS_ACCESS_RIGHTS, cache->vmcs_32bit_guest_ds_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_FS_ACCESS_RIGHTS, cache->vmcs_32bit_guest_fs_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_GS_ACCESS_RIGHTS, cache->vmcs_32bit_guest_gs_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_LDTR_ACCESS_RIGHTS, cache->vmcs_32bit_guest_ldtr_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_TR_ACCESS_RIGHTS, cache->vmcs_32bit_guest_tr_access_rights);
	vmcs_write32(VMCS_32BIT_GUEST_INTERRUPTIBILITY_STATE, cache->vmcs_32bit_guest_interruptibility_state);
	vmcs_write32(VMCS_32BIT_GUEST_ACTIVITY_STATE, cache->vmcs_32bit_guest_activity_state);
	vmcs_write32(VMCS_32BIT_GUEST_SMBASE, cache->vmcs_32bit_guest_smbase);
	vmcs_write32(VMCS_32BIT_GUEST_IA32_SYSENTER_CS_MSR, cache->vmcs_32bit_guest_ia32_sysenter_cs_msr);
	vmcs_write32(VMCS_32BIT_GUEST_PREEMPTION_TIMER_VALUE, cache->vmcs_32bit_guest_preemption_timer_value);

	// natural width guest
	vmcs_write64(VMCS_GUEST_CR0, cache->vmcs_guest_cr0);
	vmcs_write64(VMCS_GUEST_CR3, cache->vmcs_guest_cr3);
	vmcs_write64(VMCS_GUEST_ES_BASE, cache->vmcs_guest_es_base);
	vmcs_write64(VMCS_GUEST_CS_BASE, cache->vmcs_guest_cs_base);
	vmcs_write64(VMCS_GUEST_SS_BASE, cache->vmcs_guest_ss_base);
	vmcs_write64(VMCS_GUEST_DS_BASE, cache->vmcs_guest_ds_base);
	vmcs_write64(VMCS_GUEST_FS_BASE, cache->vmcs_guest_fs_base);
	vmcs_write64(VMCS_GUEST_GS_BASE, cache->vmcs_guest_gs_base);
	vmcs_write64(VMCS_GUEST_LDTR_BASE, cache->vmcs_guest_ldtr_base);
	vmcs_write64(VMCS_GUEST_TR_BASE, cache->vmcs_guest_tr_base);
	vmcs_write64(VMCS_GUEST_GDTR_BASE, cache->vmcs_guest_gdtr_base);
	vmcs_write64(VMCS_GUEST_IDTR_BASE, cache->vmcs_guest_idtr_base);
	vmcs_write64(VMCS_GUEST_DR7, cache->vmcs_guest_dr7);
	vmcs_write64(VMCS_GUEST_RSP, cache->vmcs_guest_rsp);
	vmcs_write64(VMCS_GUEST_RIP, cache->vmcs_guest_rip);
	vmcs_write64(VMCS_GUEST_RFLAGS, cache->vmcs_guest_rflags);
	vmcs_write64(VMCS_GUEST_PENDING_DBG_EXCEPTIONS, cache->vmcs_guest_pending_dbg_exceptions);
	vmcs_write64(VMCS_GUEST_IA32_SYSENTER_ESP_MSR, cache->vmcs_guest_ia32_sysenter_esp_msr);
	vmcs_write64(VMCS_GUEST_IA32_SYSENTER_EIP_MSR, cache->vmcs_guest_ia32_sysenter_eip_msr);
}

void
cache2vmcs_ctl_host(struct Vmcs *cache)
{



}

void
cache2vmcs_ctl_guest(struct Vmcs *cache)
{
	vmcs_write64(VMCS_64BIT_CONTROL_VMENTRY_MSR_LOAD_ADDR, cache->vmcs_64bit_control_vmentry_msr_load_addr);
	vmcs_write32(VMCS_32BIT_CONTROL_VMENTRY_MSR_LOAD_COUNT, cache->vmcs_32bit_control_vmentry_msr_load_count);
	vmcs_write32(VMCS_32BIT_CONTROL_VMENTRY_CONTROLS, cache->vmcs_32bit_control_vmentry_controls);

	vmcs_write32(VMCS_32BIT_CONTROL_EXCEPTION_BITMAP, cache->vmcs_32bit_control_exception_bitmap);
	vmcs_write32(VMCS_64BIT_CONTROL_IO_BITMAP_A, cache->vmcs_64bit_control_io_bitmap_a);
	vmcs_write64(VMCS_64BIT_CONTROL_IO_BITMAP_B, cache->vmcs_64bit_control_io_bitmap_b);

}


