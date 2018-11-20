#include <inc/lib.h>
#include <inc/vmx.h>
#include <inc/elf.h>
#include <inc/ept.h>
#include <inc/stdio.h>
#include <fs/fs.h>

#define GUEST_KERN "/vmm/kernel"
#define GUEST_BOOT "/vmm/boot"

#define JOS_ENTRY 0x7000

size_t gpa_idx = 0;

// The region to map in the guest should be memsz.  The region can span multiple pages.
//
// Return 0 on success, <0 on failure.
//
static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz, 
	      int fd, size_t filesz, off_t fileoffset ) {
	struct PageInfo *p = NULL;	
	size_t i;	
	int result;
	void* hva;	
	envid_t host_env_id;
	
    if (seek(fd, fileoffset) < 0)
		return -E_NO_SYS;
	
	host_env_id = sys_getenvid();

	for (i = 0; i < filesz; i += PGSIZE) {
		if ((hva = malloc(PGSIZE)) == 0)
			return -E_NO_MEM;

		if ((result = read(fd, hva, PGSIZE)) < 0)
			return result;

		if ((result = sys_ept_map(host_env_id, ROUNDDOWN(hva, PGSIZE), guest, ROUNDDOWN((void *)gpa + i, PGSIZE), __EPTE_FULL)) < 0){
			return result;
		}
	}
	
	return 0;
} 

// Read the ELF headers of kernel file specified by fname,
// mapping all valid segments into guest physical memory as appropriate.
//
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {
	uint8_t *binary = NULL;
	struct File *file = NULL;
	int result, fd;
	struct Elf *elf = NULL;
	struct Proghdr *ph, *eph;
	envid_t host_env_id;
	struct ENV *e;

	if ((fd = open( fname, O_RDONLY)) < 0 ) {
		cprintf("open %s for read: %e\n", fname, fd );
		return fd;
	}
	
	if ((binary = malloc(1024)) == 0)
		return -E_NO_MEM;

	if ((result = read(fd, binary, 1024) < 0))
		return result;
		
	elf = (struct Elf *)binary;

	if (elf && elf->e_magic == ELF_MAGIC) {
		ph = (struct Proghdr *)((uint8_t *)elf + elf->e_phoff);
		eph = ph + elf->e_phnum;
		for(;ph < eph; ph++) {
			if (ph->p_type == ELF_PROG_LOAD) {
				if ((result = map_in_guest(guest, ph->p_pa, ph->p_memsz, fd, ph->p_filesz, ph->p_offset)) < 0) {
					cprintf("map in guest fail\n");
					return result;
				}
			}
		}
	} else {
		panic("Invalid Binary");
	}

	return 0;
}

void
umain(int argc, char **argv) {

	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ * 10, JOS_ENTRY )) < 0) {
		cprintf("Error creating a guest OS env: %e\n", ret );
		exit();
	}
	guest = ret;
    // Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
		cprintf("Error copying page into the guest - %e\n.", ret);
		exit();
	}
	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
		exit();
	}
	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
		cprintf("Error mapping bootloader into the guest - %e\n.", ret);
		exit();
	}
    
#ifndef VMM_GUEST	
	sys_vmx_incr_vmdisk_number();	//increase the vmdisk number
	//create a new guest disk image

	vmdisk_number = sys_vmx_get_vmdisk_number();
	snprintf(filename_buffer, 50, "/vmm/fs%d.img", vmdisk_number);

	cprintf("Creating a new virtual HDD at /vmm/fs%d.img\n", vmdisk_number);
	r = copy("vmm/clean-fs.img", filename_buffer);

	if (r < 0) {
		cprintf("Create new virtual HDD failed: %e\n", r);
		exit();
	}

	cprintf("Create VHD finished\n");
#endif

	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
	wait(guest);
}


