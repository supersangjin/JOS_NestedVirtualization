
vmm/guest/obj/user/vmm:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 a4 04 00 00       	callq  8004e5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <map_in_guest>:
//
// Return 0 on success, <0 on failure.
//
static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz, 
	      int fd, size_t filesz, off_t fileoffset ) {
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 70          	sub    $0x70,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  800052:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  800056:	89 4d b8             	mov    %ecx,-0x48(%rbp)
  800059:	4c 89 45 a0          	mov    %r8,-0x60(%rbp)
  80005d:	44 89 4d 9c          	mov    %r9d,-0x64(%rbp)
	struct PageInfo *p = NULL;	
  800061:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  800068:	00 
	size_t i;	
	int result;
	void* hva;	
	envid_t host_env_id;
	
    if (seek(fd, fileoffset) < 0)
  800069:	8b 55 9c             	mov    -0x64(%rbp),%edx
  80006c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80006f:	89 d6                	mov    %edx,%esi
  800071:	89 c7                	mov    %eax,%edi
  800073:	48 b8 c3 27 80 00 00 	movabs $0x8027c3,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 0a                	jns    80008d <map_in_guest+0x4a>
		return -E_NO_SYS;
  800083:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  800088:	e9 e1 00 00 00       	jmpq   80016e <map_in_guest+0x12b>
	
	host_env_id = sys_getenvid();
  80008d:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 ec             	mov    %eax,-0x14(%rbp)

	for (i = 0; i < filesz; i += PGSIZE) {
  80009c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8000a3:	00 
  8000a4:	e9 b2 00 00 00       	jmpq   80015b <map_in_guest+0x118>
		if ((hva = malloc(PGSIZE)) == 0)
  8000a9:	bf 00 10 00 00       	mov    $0x1000,%edi
  8000ae:	48 b8 68 39 80 00 00 	movabs $0x803968,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8000be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8000c3:	75 0a                	jne    8000cf <map_in_guest+0x8c>
			return -E_NO_MEM;
  8000c5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8000ca:	e9 9f 00 00 00       	jmpq   80016e <map_in_guest+0x12b>

		if ((result = read(fd, hva, PGSIZE)) < 0)
  8000cf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8000d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8000db:	48 89 ce             	mov    %rcx,%rsi
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 a4 25 80 00 00 	movabs $0x8025a4,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8000ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8000f3:	79 05                	jns    8000fa <map_in_guest+0xb7>
			return result;
  8000f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8000f8:	eb 74                	jmp    80016e <map_in_guest+0x12b>

		if ((result = sys_ept_map(host_env_id, ROUNDDOWN(hva, PGSIZE), guest, ROUNDDOWN((void *)gpa + i, PGSIZE), __EPTE_FULL)) < 0){
  8000fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000fe:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800102:	48 01 d0             	add    %rdx,%rax
  800105:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800109:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80010d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800113:	48 89 c1             	mov    %rax,%rcx
  800116:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80011a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80011e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800122:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800128:	48 89 c6             	mov    %rax,%rsi
  80012b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80012e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800131:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800137:	89 c7                	mov    %eax,%edi
  800139:	48 b8 dd 1f 80 00 00 	movabs $0x801fdd,%rax
  800140:	00 00 00 
  800143:	ff d0                	callq  *%rax
  800145:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800148:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80014c:	79 05                	jns    800153 <map_in_guest+0x110>
			return result;
  80014e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800151:	eb 1b                	jmp    80016e <map_in_guest+0x12b>
    if (seek(fd, fileoffset) < 0)
		return -E_NO_SYS;
	
	host_env_id = sys_getenvid();

	for (i = 0; i < filesz; i += PGSIZE) {
  800153:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80015a:	00 
  80015b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80015f:	48 3b 45 a0          	cmp    -0x60(%rbp),%rax
  800163:	0f 82 40 ff ff ff    	jb     8000a9 <map_in_guest+0x66>
		if ((result = sys_ept_map(host_env_id, ROUNDDOWN(hva, PGSIZE), guest, ROUNDDOWN((void *)gpa + i, PGSIZE), __EPTE_FULL)) < 0){
			return result;
		}
	}
	
	return 0;
  800169:	b8 00 00 00 00       	mov    $0x0,%eax
} 
  80016e:	c9                   	leaveq 
  80016f:	c3                   	retq   

0000000000800170 <copy_guest_kern_gpa>:
//
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {
  800170:	55                   	push   %rbp
  800171:	48 89 e5             	mov    %rsp,%rbp
  800174:	48 83 ec 40          	sub    $0x40,%rsp
  800178:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80017b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	uint8_t *binary = NULL;
  80017f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  800186:	00 
	struct File *file = NULL;
  800187:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80018e:	00 
	int result, fd;
	struct Elf *elf = NULL;
  80018f:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  800196:	00 
	struct Proghdr *ph, *eph;
	envid_t host_env_id;
	struct ENV *e;

	if ((fd = open( fname, O_RDONLY)) < 0 ) {
  800197:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80019b:	be 00 00 00 00       	mov    $0x0,%esi
  8001a0:	48 89 c7             	mov    %rax,%rdi
  8001a3:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	callq  *%rax
  8001af:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8001b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8001b6:	79 2d                	jns    8001e5 <copy_guest_kern_gpa+0x75>
		cprintf("open %s for read: %e\n", fname, fd );
  8001b8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8001bb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8001bf:	48 89 c6             	mov    %rax,%rsi
  8001c2:	48 bf 20 4b 80 00 00 	movabs $0x804b20,%rdi
  8001c9:	00 00 00 
  8001cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d1:	48 b9 c7 07 80 00 00 	movabs $0x8007c7,%rcx
  8001d8:	00 00 00 
  8001db:	ff d1                	callq  *%rcx
		return fd;
  8001dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001e0:	e9 69 01 00 00       	jmpq   80034e <copy_guest_kern_gpa+0x1de>
	}
	
	if ((binary = malloc(1024)) == 0)
  8001e5:	bf 00 04 00 00       	mov    $0x400,%edi
  8001ea:	48 b8 68 39 80 00 00 	movabs $0x803968,%rax
  8001f1:	00 00 00 
  8001f4:	ff d0                	callq  *%rax
  8001f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8001fa:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8001ff:	75 0a                	jne    80020b <copy_guest_kern_gpa+0x9b>
		return -E_NO_MEM;
  800201:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  800206:	e9 43 01 00 00       	jmpq   80034e <copy_guest_kern_gpa+0x1de>

	if ((result = read(fd, binary, 1024) < 0))
  80020b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80020f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800212:	ba 00 04 00 00       	mov    $0x400,%edx
  800217:	48 89 ce             	mov    %rcx,%rsi
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	48 b8 a4 25 80 00 00 	movabs $0x8025a4,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
  800228:	c1 e8 1f             	shr    $0x1f,%eax
  80022b:	0f b6 c0             	movzbl %al,%eax
  80022e:	89 45 d8             	mov    %eax,-0x28(%rbp)
  800231:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800235:	74 08                	je     80023f <copy_guest_kern_gpa+0xcf>
		return result;
  800237:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80023a:	e9 0f 01 00 00       	jmpq   80034e <copy_guest_kern_gpa+0x1de>
		
	elf = (struct Elf *)binary;
  80023f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800243:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if (elf && elf->e_magic == ELF_MAGIC) {
  800247:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80024c:	0f 84 cd 00 00 00    	je     80031f <copy_guest_kern_gpa+0x1af>
  800252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800256:	8b 00                	mov    (%rax),%eax
  800258:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80025d:	0f 85 bc 00 00 00    	jne    80031f <copy_guest_kern_gpa+0x1af>
		ph = (struct Proghdr *)((uint8_t *)elf + elf->e_phoff);
  800263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800267:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80026b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80026f:	48 01 d0             	add    %rdx,%rax
  800272:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		eph = ph + elf->e_phnum;
  800276:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80027a:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80027e:	0f b7 c0             	movzwl %ax,%eax
  800281:	48 c1 e0 03          	shl    $0x3,%rax
  800285:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80028c:	00 
  80028d:	48 29 c2             	sub    %rax,%rdx
  800290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800294:	48 01 d0             	add    %rdx,%rax
  800297:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		for(;ph < eph; ph++) {
  80029b:	eb 76                	jmp    800313 <copy_guest_kern_gpa+0x1a3>
			if (ph->p_type == ELF_PROG_LOAD) {
  80029d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8002a1:	8b 00                	mov    (%rax),%eax
  8002a3:	83 f8 01             	cmp    $0x1,%eax
  8002a6:	75 66                	jne    80030e <copy_guest_kern_gpa+0x19e>
				if ((result = map_in_guest(guest, ph->p_pa, ph->p_memsz, fd, ph->p_filesz, ph->p_offset)) < 0) {
  8002a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8002ac:	48 8b 40 08          	mov    0x8(%rax),%rax
  8002b0:	41 89 c0             	mov    %eax,%r8d
  8002b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8002b7:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8002bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8002bf:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8002c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8002c7:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8002cb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8002ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8002d1:	45 89 c1             	mov    %r8d,%r9d
  8002d4:	49 89 f8             	mov    %rdi,%r8
  8002d7:	89 c7                	mov    %eax,%edi
  8002d9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax
  8002e5:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8002e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8002ec:	79 20                	jns    80030e <copy_guest_kern_gpa+0x19e>
					cprintf("map in guest fail\n");
  8002ee:	48 bf 36 4b 80 00 00 	movabs $0x804b36,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
					return result;
  800309:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80030c:	eb 40                	jmp    80034e <copy_guest_kern_gpa+0x1de>
	elf = (struct Elf *)binary;

	if (elf && elf->e_magic == ELF_MAGIC) {
		ph = (struct Proghdr *)((uint8_t *)elf + elf->e_phoff);
		eph = ph + elf->e_phnum;
		for(;ph < eph; ph++) {
  80030e:	48 83 45 f8 38       	addq   $0x38,-0x8(%rbp)
  800313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800317:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  80031b:	72 80                	jb     80029d <copy_guest_kern_gpa+0x12d>
	if ((result = read(fd, binary, 1024) < 0))
		return result;
		
	elf = (struct Elf *)binary;

	if (elf && elf->e_magic == ELF_MAGIC) {
  80031d:	eb 2a                	jmp    800349 <copy_guest_kern_gpa+0x1d9>
					return result;
				}
			}
		}
	} else {
		panic("Invalid Binary");
  80031f:	48 ba 49 4b 80 00 00 	movabs $0x804b49,%rdx
  800326:	00 00 00 
  800329:	be 59 00 00 00       	mov    $0x59,%esi
  80032e:	48 bf 58 4b 80 00 00 	movabs $0x804b58,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	48 b9 8d 05 80 00 00 	movabs $0x80058d,%rcx
  800344:	00 00 00 
  800347:	ff d1                	callq  *%rcx
	}

	return 0;
  800349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80034e:	c9                   	leaveq 
  80034f:	c3                   	retq   

0000000000800350 <umain>:

void
umain(int argc, char **argv) {
  800350:	55                   	push   %rbp
  800351:	48 89 e5             	mov    %rsp,%rbp
  800354:	48 83 ec 50          	sub    $0x50,%rsp
  800358:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80035b:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ * 10, JOS_ENTRY )) < 0) {
  80035f:	be 00 70 00 00       	mov    $0x7000,%esi
  800364:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800369:	48 b8 3d 20 80 00 00 	movabs $0x80203d,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
  800375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037c:	79 2c                	jns    8003aa <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  80037e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800381:	89 c6                	mov    %eax,%esi
  800383:	48 bf 68 4b 80 00 00 	movabs $0x804b68,%rdi
  80038a:	00 00 00 
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  800399:	00 00 00 
  80039c:	ff d2                	callq  *%rdx
		exit();
  80039e:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
	}
	guest = ret;
  8003aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
    // Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  8003b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003b3:	48 be 8b 4b 80 00 00 	movabs $0x804b8b,%rsi
  8003ba:	00 00 00 
  8003bd:	89 c7                	mov    %eax,%edi
  8003bf:	48 b8 70 01 80 00 00 	movabs $0x800170,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
  8003cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003d2:	79 2c                	jns    800400 <umain+0xb0>
		cprintf("Error copying page into the guest - %e\n.", ret);
  8003d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003d7:	89 c6                	mov    %eax,%esi
  8003d9:	48 bf 98 4b 80 00 00 	movabs $0x804b98,%rdi
  8003e0:	00 00 00 
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  8003ef:	00 00 00 
  8003f2:	ff d2                	callq  *%rdx
		exit();
  8003f4:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	callq  *%rax
	}
	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  800400:	be 00 00 00 00       	mov    $0x0,%esi
  800405:	48 bf c1 4b 80 00 00 	movabs $0x804bc1,%rdi
  80040c:	00 00 00 
  80040f:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80041e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800422:	79 36                	jns    80045a <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  800424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	48 be c1 4b 80 00 00 	movabs $0x804bc1,%rsi
  800430:	00 00 00 
  800433:	48 bf 20 4b 80 00 00 	movabs $0x804b20,%rdi
  80043a:	00 00 00 
  80043d:	b8 00 00 00 00       	mov    $0x0,%eax
  800442:	48 b9 c7 07 80 00 00 	movabs $0x8007c7,%rcx
  800449:	00 00 00 
  80044c:	ff d1                	callq  *%rcx
		exit();
  80044e:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
	}
	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
  80045a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80045d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800460:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800466:	41 b8 00 02 00 00    	mov    $0x200,%r8d
  80046c:	89 d1                	mov    %edx,%ecx
  80046e:	ba 00 02 00 00       	mov    $0x200,%edx
  800473:	be 00 70 00 00       	mov    $0x7000,%esi
  800478:	89 c7                	mov    %eax,%edi
  80047a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80048d:	79 2c                	jns    8004bb <umain+0x16b>
		cprintf("Error mapping bootloader into the guest - %e\n.", ret);
  80048f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800492:	89 c6                	mov    %eax,%esi
  800494:	48 bf d0 4b 80 00 00 	movabs $0x804bd0,%rdi
  80049b:	00 00 00 
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  8004aa:	00 00 00 
  8004ad:	ff d2                	callq  *%rdx
		exit();
  8004af:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  8004b6:	00 00 00 
  8004b9:	ff d0                	callq  *%rax

	cprintf("Create VHD finished\n");
#endif

	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  8004bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004be:	be 02 00 00 00       	mov    $0x2,%esi
  8004c3:	89 c7                	mov    %eax,%edi
  8004c5:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8004cc:	00 00 00 
  8004cf:	ff d0                	callq  *%rax
	wait(guest);
  8004d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004d4:	89 c7                	mov    %eax,%edi
  8004d6:	48 b8 04 44 80 00 00 	movabs $0x804404,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
}
  8004e2:	90                   	nop
  8004e3:	c9                   	leaveq 
  8004e4:	c3                   	retq   

00000000008004e5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004e5:	55                   	push   %rbp
  8004e6:	48 89 e5             	mov    %rsp,%rbp
  8004e9:	48 83 ec 10          	sub    $0x10,%rsp
  8004ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8004f4:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  8004fb:	00 00 00 
  8004fe:	ff d0                	callq  *%rax
  800500:	25 ff 03 00 00       	and    $0x3ff,%eax
  800505:	48 98                	cltq   
  800507:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80050e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800515:	00 00 00 
  800518:	48 01 c2             	add    %rax,%rdx
  80051b:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  800522:	00 00 00 
  800525:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800528:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80052c:	7e 14                	jle    800542 <libmain+0x5d>
		binaryname = argv[0];
  80052e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800532:	48 8b 10             	mov    (%rax),%rdx
  800535:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80053c:	00 00 00 
  80053f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800542:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800549:	48 89 d6             	mov    %rdx,%rsi
  80054c:	89 c7                	mov    %eax,%edi
  80054e:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80055a:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  800561:	00 00 00 
  800564:	ff d0                	callq  *%rax
}
  800566:	90                   	nop
  800567:	c9                   	leaveq 
  800568:	c3                   	retq   

0000000000800569 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800569:	55                   	push   %rbp
  80056a:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80056d:	48 b8 cc 23 80 00 00 	movabs $0x8023cc,%rax
  800574:	00 00 00 
  800577:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800579:	bf 00 00 00 00       	mov    $0x0,%edi
  80057e:	48 b8 ce 1b 80 00 00 	movabs $0x801bce,%rax
  800585:	00 00 00 
  800588:	ff d0                	callq  *%rax
}
  80058a:	90                   	nop
  80058b:	5d                   	pop    %rbp
  80058c:	c3                   	retq   

000000000080058d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80058d:	55                   	push   %rbp
  80058e:	48 89 e5             	mov    %rsp,%rbp
  800591:	53                   	push   %rbx
  800592:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800599:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005a0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005a6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8005ad:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005b4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005bb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005c2:	84 c0                	test   %al,%al
  8005c4:	74 23                	je     8005e9 <_panic+0x5c>
  8005c6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005cd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005d1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005d5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005d9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8005dd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8005e1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8005e5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8005e9:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8005f0:	00 00 00 
  8005f3:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8005fa:	00 00 00 
  8005fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800601:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800608:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80060f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800616:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80061d:	00 00 00 
  800620:	48 8b 18             	mov    (%rax),%rbx
  800623:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  80062a:	00 00 00 
  80062d:	ff d0                	callq  *%rax
  80062f:	89 c6                	mov    %eax,%esi
  800631:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800637:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80063e:	41 89 d0             	mov    %edx,%r8d
  800641:	48 89 c1             	mov    %rax,%rcx
  800644:	48 89 da             	mov    %rbx,%rdx
  800647:	48 bf 10 4c 80 00 00 	movabs $0x804c10,%rdi
  80064e:	00 00 00 
  800651:	b8 00 00 00 00       	mov    $0x0,%eax
  800656:	49 b9 c7 07 80 00 00 	movabs $0x8007c7,%r9
  80065d:	00 00 00 
  800660:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800663:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80066a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800671:	48 89 d6             	mov    %rdx,%rsi
  800674:	48 89 c7             	mov    %rax,%rdi
  800677:	48 b8 1b 07 80 00 00 	movabs $0x80071b,%rax
  80067e:	00 00 00 
  800681:	ff d0                	callq  *%rax
	cprintf("\n");
  800683:	48 bf 33 4c 80 00 00 	movabs $0x804c33,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80069e:	cc                   	int3   
  80069f:	eb fd                	jmp    80069e <_panic+0x111>

00000000008006a1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006a1:	55                   	push   %rbp
  8006a2:	48 89 e5             	mov    %rsp,%rbp
  8006a5:	48 83 ec 10          	sub    $0x10,%rsp
  8006a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b4:	8b 00                	mov    (%rax),%eax
  8006b6:	8d 48 01             	lea    0x1(%rax),%ecx
  8006b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006bd:	89 0a                	mov    %ecx,(%rdx)
  8006bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006c2:	89 d1                	mov    %edx,%ecx
  8006c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006c8:	48 98                	cltq   
  8006ca:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d9:	75 2c                	jne    800707 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006df:	8b 00                	mov    (%rax),%eax
  8006e1:	48 98                	cltq   
  8006e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e7:	48 83 c2 08          	add    $0x8,%rdx
  8006eb:	48 89 c6             	mov    %rax,%rsi
  8006ee:	48 89 d7             	mov    %rdx,%rdi
  8006f1:	48 b8 45 1b 80 00 00 	movabs $0x801b45,%rax
  8006f8:	00 00 00 
  8006fb:	ff d0                	callq  *%rax
        b->idx = 0;
  8006fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800701:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070b:	8b 40 04             	mov    0x4(%rax),%eax
  80070e:	8d 50 01             	lea    0x1(%rax),%edx
  800711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800715:	89 50 04             	mov    %edx,0x4(%rax)
}
  800718:	90                   	nop
  800719:	c9                   	leaveq 
  80071a:	c3                   	retq   

000000000080071b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80071b:	55                   	push   %rbp
  80071c:	48 89 e5             	mov    %rsp,%rbp
  80071f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800726:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80072d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800734:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80073b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800742:	48 8b 0a             	mov    (%rdx),%rcx
  800745:	48 89 08             	mov    %rcx,(%rax)
  800748:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80074c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800750:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800754:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800758:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80075f:	00 00 00 
    b.cnt = 0;
  800762:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800769:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80076c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800773:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80077a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800781:	48 89 c6             	mov    %rax,%rsi
  800784:	48 bf a1 06 80 00 00 	movabs $0x8006a1,%rdi
  80078b:	00 00 00 
  80078e:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  800795:	00 00 00 
  800798:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80079a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007a0:	48 98                	cltq   
  8007a2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007a9:	48 83 c2 08          	add    $0x8,%rdx
  8007ad:	48 89 c6             	mov    %rax,%rsi
  8007b0:	48 89 d7             	mov    %rdx,%rdi
  8007b3:	48 b8 45 1b 80 00 00 	movabs $0x801b45,%rax
  8007ba:	00 00 00 
  8007bd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007c5:	c9                   	leaveq 
  8007c6:	c3                   	retq   

00000000008007c7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007c7:	55                   	push   %rbp
  8007c8:	48 89 e5             	mov    %rsp,%rbp
  8007cb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007d2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8007d9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8007e0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8007e7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8007ee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8007f5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8007fc:	84 c0                	test   %al,%al
  8007fe:	74 20                	je     800820 <cprintf+0x59>
  800800:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800804:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800808:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80080c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800810:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800814:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800818:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80081c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800820:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800827:	00 00 00 
  80082a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800831:	00 00 00 
  800834:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800838:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80083f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800846:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80084d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800854:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80085b:	48 8b 0a             	mov    (%rdx),%rcx
  80085e:	48 89 08             	mov    %rcx,(%rax)
  800861:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800865:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800869:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80086d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800871:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800878:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80087f:	48 89 d6             	mov    %rdx,%rsi
  800882:	48 89 c7             	mov    %rax,%rdi
  800885:	48 b8 1b 07 80 00 00 	movabs $0x80071b,%rax
  80088c:	00 00 00 
  80088f:	ff d0                	callq  *%rax
  800891:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800897:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80089d:	c9                   	leaveq 
  80089e:	c3                   	retq   

000000000080089f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80089f:	55                   	push   %rbp
  8008a0:	48 89 e5             	mov    %rsp,%rbp
  8008a3:	48 83 ec 30          	sub    $0x30,%rsp
  8008a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008b3:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008b6:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008ba:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8008c1:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8008c5:	77 54                	ja     80091b <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008c7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8008ca:	8d 78 ff             	lea    -0x1(%rax),%edi
  8008cd:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8008d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d9:	48 f7 f6             	div    %rsi
  8008dc:	49 89 c2             	mov    %rax,%r10
  8008df:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8008e2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8008e5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8008e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008ed:	41 89 c9             	mov    %ecx,%r9d
  8008f0:	41 89 f8             	mov    %edi,%r8d
  8008f3:	89 d1                	mov    %edx,%ecx
  8008f5:	4c 89 d2             	mov    %r10,%rdx
  8008f8:	48 89 c7             	mov    %rax,%rdi
  8008fb:	48 b8 9f 08 80 00 00 	movabs $0x80089f,%rax
  800902:	00 00 00 
  800905:	ff d0                	callq  *%rax
  800907:	eb 1c                	jmp    800925 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800909:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80090d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800910:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800914:	48 89 ce             	mov    %rcx,%rsi
  800917:	89 d7                	mov    %edx,%edi
  800919:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80091b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80091f:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800923:	7f e4                	jg     800909 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800925:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092c:	ba 00 00 00 00       	mov    $0x0,%edx
  800931:	48 f7 f1             	div    %rcx
  800934:	48 b8 30 4e 80 00 00 	movabs $0x804e30,%rax
  80093b:	00 00 00 
  80093e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800942:	0f be d0             	movsbl %al,%edx
  800945:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800949:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80094d:	48 89 ce             	mov    %rcx,%rsi
  800950:	89 d7                	mov    %edx,%edi
  800952:	ff d0                	callq  *%rax
}
  800954:	90                   	nop
  800955:	c9                   	leaveq 
  800956:	c3                   	retq   

0000000000800957 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800957:	55                   	push   %rbp
  800958:	48 89 e5             	mov    %rsp,%rbp
  80095b:	48 83 ec 20          	sub    $0x20,%rsp
  80095f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800963:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800966:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80096a:	7e 4f                	jle    8009bb <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	8b 00                	mov    (%rax),%eax
  800972:	83 f8 30             	cmp    $0x30,%eax
  800975:	73 24                	jae    80099b <getuint+0x44>
  800977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	8b 00                	mov    (%rax),%eax
  800985:	89 c0                	mov    %eax,%eax
  800987:	48 01 d0             	add    %rdx,%rax
  80098a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098e:	8b 12                	mov    (%rdx),%edx
  800990:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800997:	89 0a                	mov    %ecx,(%rdx)
  800999:	eb 14                	jmp    8009af <getuint+0x58>
  80099b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009a3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009af:	48 8b 00             	mov    (%rax),%rax
  8009b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b6:	e9 9d 00 00 00       	jmpq   800a58 <getuint+0x101>
	else if (lflag)
  8009bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009bf:	74 4c                	je     800a0d <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8009c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c5:	8b 00                	mov    (%rax),%eax
  8009c7:	83 f8 30             	cmp    $0x30,%eax
  8009ca:	73 24                	jae    8009f0 <getuint+0x99>
  8009cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d8:	8b 00                	mov    (%rax),%eax
  8009da:	89 c0                	mov    %eax,%eax
  8009dc:	48 01 d0             	add    %rdx,%rax
  8009df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e3:	8b 12                	mov    (%rdx),%edx
  8009e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ec:	89 0a                	mov    %ecx,(%rdx)
  8009ee:	eb 14                	jmp    800a04 <getuint+0xad>
  8009f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009f8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a00:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a04:	48 8b 00             	mov    (%rax),%rax
  800a07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a0b:	eb 4b                	jmp    800a58 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	83 f8 30             	cmp    $0x30,%eax
  800a16:	73 24                	jae    800a3c <getuint+0xe5>
  800a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	8b 00                	mov    (%rax),%eax
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 01 d0             	add    %rdx,%rax
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	8b 12                	mov    (%rdx),%edx
  800a31:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a38:	89 0a                	mov    %ecx,(%rdx)
  800a3a:	eb 14                	jmp    800a50 <getuint+0xf9>
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a44:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a50:	8b 00                	mov    (%rax),%eax
  800a52:	89 c0                	mov    %eax,%eax
  800a54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a5c:	c9                   	leaveq 
  800a5d:	c3                   	retq   

0000000000800a5e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a5e:	55                   	push   %rbp
  800a5f:	48 89 e5             	mov    %rsp,%rbp
  800a62:	48 83 ec 20          	sub    $0x20,%rsp
  800a66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a6a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a6d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a71:	7e 4f                	jle    800ac2 <getint+0x64>
		x=va_arg(*ap, long long);
  800a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	83 f8 30             	cmp    $0x30,%eax
  800a7c:	73 24                	jae    800aa2 <getint+0x44>
  800a7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a82:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	8b 00                	mov    (%rax),%eax
  800a8c:	89 c0                	mov    %eax,%eax
  800a8e:	48 01 d0             	add    %rdx,%rax
  800a91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a95:	8b 12                	mov    (%rdx),%edx
  800a97:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9e:	89 0a                	mov    %ecx,(%rdx)
  800aa0:	eb 14                	jmp    800ab6 <getint+0x58>
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800aaa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800aae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab6:	48 8b 00             	mov    (%rax),%rax
  800ab9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800abd:	e9 9d 00 00 00       	jmpq   800b5f <getint+0x101>
	else if (lflag)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ac6:	74 4c                	je     800b14 <getint+0xb6>
		x=va_arg(*ap, long);
  800ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acc:	8b 00                	mov    (%rax),%eax
  800ace:	83 f8 30             	cmp    $0x30,%eax
  800ad1:	73 24                	jae    800af7 <getint+0x99>
  800ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	8b 00                	mov    (%rax),%eax
  800ae1:	89 c0                	mov    %eax,%eax
  800ae3:	48 01 d0             	add    %rdx,%rax
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	8b 12                	mov    (%rdx),%edx
  800aec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af3:	89 0a                	mov    %ecx,(%rdx)
  800af5:	eb 14                	jmp    800b0b <getint+0xad>
  800af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800aff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b0b:	48 8b 00             	mov    (%rax),%rax
  800b0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b12:	eb 4b                	jmp    800b5f <getint+0x101>
	else
		x=va_arg(*ap, int);
  800b14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b18:	8b 00                	mov    (%rax),%eax
  800b1a:	83 f8 30             	cmp    $0x30,%eax
  800b1d:	73 24                	jae    800b43 <getint+0xe5>
  800b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b23:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2b:	8b 00                	mov    (%rax),%eax
  800b2d:	89 c0                	mov    %eax,%eax
  800b2f:	48 01 d0             	add    %rdx,%rax
  800b32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b36:	8b 12                	mov    (%rdx),%edx
  800b38:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3f:	89 0a                	mov    %ecx,(%rdx)
  800b41:	eb 14                	jmp    800b57 <getint+0xf9>
  800b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b47:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b4b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b53:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b57:	8b 00                	mov    (%rax),%eax
  800b59:	48 98                	cltq   
  800b5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b63:	c9                   	leaveq 
  800b64:	c3                   	retq   

0000000000800b65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b65:	55                   	push   %rbp
  800b66:	48 89 e5             	mov    %rsp,%rbp
  800b69:	41 54                	push   %r12
  800b6b:	53                   	push   %rbx
  800b6c:	48 83 ec 60          	sub    $0x60,%rsp
  800b70:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b74:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b78:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b7c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b80:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b84:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b88:	48 8b 0a             	mov    (%rdx),%rcx
  800b8b:	48 89 08             	mov    %rcx,(%rax)
  800b8e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b92:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b96:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b9a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b9e:	eb 17                	jmp    800bb7 <vprintfmt+0x52>
			if (ch == '\0')
  800ba0:	85 db                	test   %ebx,%ebx
  800ba2:	0f 84 b9 04 00 00    	je     801061 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800ba8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb0:	48 89 d6             	mov    %rdx,%rsi
  800bb3:	89 df                	mov    %ebx,%edi
  800bb5:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bbb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bbf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bc3:	0f b6 00             	movzbl (%rax),%eax
  800bc6:	0f b6 d8             	movzbl %al,%ebx
  800bc9:	83 fb 25             	cmp    $0x25,%ebx
  800bcc:	75 d2                	jne    800ba0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bce:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bd2:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800bd9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800be7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bf6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bfa:	0f b6 00             	movzbl (%rax),%eax
  800bfd:	0f b6 d8             	movzbl %al,%ebx
  800c00:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c03:	83 f8 55             	cmp    $0x55,%eax
  800c06:	0f 87 22 04 00 00    	ja     80102e <vprintfmt+0x4c9>
  800c0c:	89 c0                	mov    %eax,%eax
  800c0e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c15:	00 
  800c16:	48 b8 58 4e 80 00 00 	movabs $0x804e58,%rax
  800c1d:	00 00 00 
  800c20:	48 01 d0             	add    %rdx,%rax
  800c23:	48 8b 00             	mov    (%rax),%rax
  800c26:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c28:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c2c:	eb c0                	jmp    800bee <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c2e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c32:	eb ba                	jmp    800bee <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c34:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c3b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c3e:	89 d0                	mov    %edx,%eax
  800c40:	c1 e0 02             	shl    $0x2,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	01 c0                	add    %eax,%eax
  800c47:	01 d8                	add    %ebx,%eax
  800c49:	83 e8 30             	sub    $0x30,%eax
  800c4c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c53:	0f b6 00             	movzbl (%rax),%eax
  800c56:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c59:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5c:	7e 60                	jle    800cbe <vprintfmt+0x159>
  800c5e:	83 fb 39             	cmp    $0x39,%ebx
  800c61:	7f 5b                	jg     800cbe <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c63:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6d:	83 f8 30             	cmp    $0x30,%eax
  800c70:	73 17                	jae    800c89 <vprintfmt+0x124>
  800c72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c76:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c79:	89 d2                	mov    %edx,%edx
  800c7b:	48 01 d0             	add    %rdx,%rax
  800c7e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c81:	83 c2 08             	add    $0x8,%edx
  800c84:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c87:	eb 0c                	jmp    800c95 <vprintfmt+0x130>
  800c89:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c8d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c95:	8b 00                	mov    (%rax),%eax
  800c97:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c9a:	eb 23                	jmp    800cbf <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ca0:	0f 89 48 ff ff ff    	jns    800bee <vprintfmt+0x89>
				width = 0;
  800ca6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cad:	e9 3c ff ff ff       	jmpq   800bee <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cb2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cb9:	e9 30 ff ff ff       	jmpq   800bee <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cbe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc3:	0f 89 25 ff ff ff    	jns    800bee <vprintfmt+0x89>
				width = precision, precision = -1;
  800cc9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ccc:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ccf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cd6:	e9 13 ff ff ff       	jmpq   800bee <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cdb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800cdf:	e9 0a ff ff ff       	jmpq   800bee <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ce4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce7:	83 f8 30             	cmp    $0x30,%eax
  800cea:	73 17                	jae    800d03 <vprintfmt+0x19e>
  800cec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf3:	89 d2                	mov    %edx,%edx
  800cf5:	48 01 d0             	add    %rdx,%rax
  800cf8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfb:	83 c2 08             	add    $0x8,%edx
  800cfe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d01:	eb 0c                	jmp    800d0f <vprintfmt+0x1aa>
  800d03:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d07:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d0f:	8b 10                	mov    (%rax),%edx
  800d11:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d19:	48 89 ce             	mov    %rcx,%rsi
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	ff d0                	callq  *%rax
			break;
  800d20:	e9 37 03 00 00       	jmpq   80105c <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d28:	83 f8 30             	cmp    $0x30,%eax
  800d2b:	73 17                	jae    800d44 <vprintfmt+0x1df>
  800d2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d34:	89 d2                	mov    %edx,%edx
  800d36:	48 01 d0             	add    %rdx,%rax
  800d39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3c:	83 c2 08             	add    $0x8,%edx
  800d3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d42:	eb 0c                	jmp    800d50 <vprintfmt+0x1eb>
  800d44:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d48:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d50:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x1f3>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 15             	cmp    $0x15,%ebx
  800d5b:	7f 16                	jg     800d73 <vprintfmt+0x20e>
  800d5d:	48 b8 80 4d 80 00 00 	movabs $0x804d80,%rax
  800d64:	00 00 00 
  800d67:	48 63 d3             	movslq %ebx,%rdx
  800d6a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d6e:	4d 85 e4             	test   %r12,%r12
  800d71:	75 2e                	jne    800da1 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d73:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7b:	89 d9                	mov    %ebx,%ecx
  800d7d:	48 ba 41 4e 80 00 00 	movabs $0x804e41,%rdx
  800d84:	00 00 00 
  800d87:	48 89 c7             	mov    %rax,%rdi
  800d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8f:	49 b8 6b 10 80 00 00 	movabs $0x80106b,%r8
  800d96:	00 00 00 
  800d99:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d9c:	e9 bb 02 00 00       	jmpq   80105c <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800da1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800da5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da9:	4c 89 e1             	mov    %r12,%rcx
  800dac:	48 ba 4a 4e 80 00 00 	movabs $0x804e4a,%rdx
  800db3:	00 00 00 
  800db6:	48 89 c7             	mov    %rax,%rdi
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbe:	49 b8 6b 10 80 00 00 	movabs $0x80106b,%r8
  800dc5:	00 00 00 
  800dc8:	41 ff d0             	callq  *%r8
			break;
  800dcb:	e9 8c 02 00 00       	jmpq   80105c <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800dd0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd3:	83 f8 30             	cmp    $0x30,%eax
  800dd6:	73 17                	jae    800def <vprintfmt+0x28a>
  800dd8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ddf:	89 d2                	mov    %edx,%edx
  800de1:	48 01 d0             	add    %rdx,%rax
  800de4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800de7:	83 c2 08             	add    $0x8,%edx
  800dea:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ded:	eb 0c                	jmp    800dfb <vprintfmt+0x296>
  800def:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800df3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800df7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dfb:	4c 8b 20             	mov    (%rax),%r12
  800dfe:	4d 85 e4             	test   %r12,%r12
  800e01:	75 0a                	jne    800e0d <vprintfmt+0x2a8>
				p = "(null)";
  800e03:	49 bc 4d 4e 80 00 00 	movabs $0x804e4d,%r12
  800e0a:	00 00 00 
			if (width > 0 && padc != '-')
  800e0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e11:	7e 78                	jle    800e8b <vprintfmt+0x326>
  800e13:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e17:	74 72                	je     800e8b <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e19:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e1c:	48 98                	cltq   
  800e1e:	48 89 c6             	mov    %rax,%rsi
  800e21:	4c 89 e7             	mov    %r12,%rdi
  800e24:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  800e2b:	00 00 00 
  800e2e:	ff d0                	callq  *%rax
  800e30:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e33:	eb 17                	jmp    800e4c <vprintfmt+0x2e7>
					putch(padc, putdat);
  800e35:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e39:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e41:	48 89 ce             	mov    %rcx,%rsi
  800e44:	89 d7                	mov    %edx,%edi
  800e46:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e50:	7f e3                	jg     800e35 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e52:	eb 37                	jmp    800e8b <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800e54:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e58:	74 1e                	je     800e78 <vprintfmt+0x313>
  800e5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e5d:	7e 05                	jle    800e64 <vprintfmt+0x2ff>
  800e5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e62:	7e 14                	jle    800e78 <vprintfmt+0x313>
					putch('?', putdat);
  800e64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6c:	48 89 d6             	mov    %rdx,%rsi
  800e6f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e74:	ff d0                	callq  *%rax
  800e76:	eb 0f                	jmp    800e87 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e80:	48 89 d6             	mov    %rdx,%rsi
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e87:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e8b:	4c 89 e0             	mov    %r12,%rax
  800e8e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e92:	0f b6 00             	movzbl (%rax),%eax
  800e95:	0f be d8             	movsbl %al,%ebx
  800e98:	85 db                	test   %ebx,%ebx
  800e9a:	74 28                	je     800ec4 <vprintfmt+0x35f>
  800e9c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ea0:	78 b2                	js     800e54 <vprintfmt+0x2ef>
  800ea2:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ea6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eaa:	79 a8                	jns    800e54 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eac:	eb 16                	jmp    800ec4 <vprintfmt+0x35f>
				putch(' ', putdat);
  800eae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb6:	48 89 d6             	mov    %rdx,%rsi
  800eb9:	bf 20 00 00 00       	mov    $0x20,%edi
  800ebe:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ec0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ec4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ec8:	7f e4                	jg     800eae <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800eca:	e9 8d 01 00 00       	jmpq   80105c <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ecf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed3:	be 03 00 00 00       	mov    $0x3,%esi
  800ed8:	48 89 c7             	mov    %rax,%rdi
  800edb:	48 b8 5e 0a 80 00 00 	movabs $0x800a5e,%rax
  800ee2:	00 00 00 
  800ee5:	ff d0                	callq  *%rax
  800ee7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eef:	48 85 c0             	test   %rax,%rax
  800ef2:	79 1d                	jns    800f11 <vprintfmt+0x3ac>
				putch('-', putdat);
  800ef4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efc:	48 89 d6             	mov    %rdx,%rsi
  800eff:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f04:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0a:	48 f7 d8             	neg    %rax
  800f0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f11:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f18:	e9 d2 00 00 00       	jmpq   800fef <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f21:	be 03 00 00 00       	mov    $0x3,%esi
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 57 09 80 00 00 	movabs $0x800957,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
  800f35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f39:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f40:	e9 aa 00 00 00       	jmpq   800fef <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800f45:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f49:	be 03 00 00 00       	mov    $0x3,%esi
  800f4e:	48 89 c7             	mov    %rax,%rdi
  800f51:	48 b8 57 09 80 00 00 	movabs $0x800957,%rax
  800f58:	00 00 00 
  800f5b:	ff d0                	callq  *%rax
  800f5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f61:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f68:	e9 82 00 00 00       	jmpq   800fef <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800f6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f75:	48 89 d6             	mov    %rdx,%rsi
  800f78:	bf 30 00 00 00       	mov    $0x30,%edi
  800f7d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f87:	48 89 d6             	mov    %rdx,%rsi
  800f8a:	bf 78 00 00 00       	mov    $0x78,%edi
  800f8f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f94:	83 f8 30             	cmp    $0x30,%eax
  800f97:	73 17                	jae    800fb0 <vprintfmt+0x44b>
  800f99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fa0:	89 d2                	mov    %edx,%edx
  800fa2:	48 01 d0             	add    %rdx,%rax
  800fa5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fa8:	83 c2 08             	add    $0x8,%edx
  800fab:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fae:	eb 0c                	jmp    800fbc <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800fb0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fb4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fbc:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fbf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fc3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fca:	eb 23                	jmp    800fef <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fcc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fd0:	be 03 00 00 00       	mov    $0x3,%esi
  800fd5:	48 89 c7             	mov    %rax,%rdi
  800fd8:	48 b8 57 09 80 00 00 	movabs $0x800957,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
  800fe4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fe8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fef:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ff4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ff7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ffa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801002:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801006:	45 89 c1             	mov    %r8d,%r9d
  801009:	41 89 f8             	mov    %edi,%r8d
  80100c:	48 89 c7             	mov    %rax,%rdi
  80100f:	48 b8 9f 08 80 00 00 	movabs $0x80089f,%rax
  801016:	00 00 00 
  801019:	ff d0                	callq  *%rax
			break;
  80101b:	eb 3f                	jmp    80105c <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80101d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801021:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801025:	48 89 d6             	mov    %rdx,%rsi
  801028:	89 df                	mov    %ebx,%edi
  80102a:	ff d0                	callq  *%rax
			break;
  80102c:	eb 2e                	jmp    80105c <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80102e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801032:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801036:	48 89 d6             	mov    %rdx,%rsi
  801039:	bf 25 00 00 00       	mov    $0x25,%edi
  80103e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801040:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801045:	eb 05                	jmp    80104c <vprintfmt+0x4e7>
  801047:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80104c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801050:	48 83 e8 01          	sub    $0x1,%rax
  801054:	0f b6 00             	movzbl (%rax),%eax
  801057:	3c 25                	cmp    $0x25,%al
  801059:	75 ec                	jne    801047 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  80105b:	90                   	nop
		}
	}
  80105c:	e9 3d fb ff ff       	jmpq   800b9e <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801061:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801062:	48 83 c4 60          	add    $0x60,%rsp
  801066:	5b                   	pop    %rbx
  801067:	41 5c                	pop    %r12
  801069:	5d                   	pop    %rbp
  80106a:	c3                   	retq   

000000000080106b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80106b:	55                   	push   %rbp
  80106c:	48 89 e5             	mov    %rsp,%rbp
  80106f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801076:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80107d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801084:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80108b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801092:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801099:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010a0:	84 c0                	test   %al,%al
  8010a2:	74 20                	je     8010c4 <printfmt+0x59>
  8010a4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010a8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010ac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010b0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010b4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010b8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010bc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010c0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010c4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010cb:	00 00 00 
  8010ce:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010d5:	00 00 00 
  8010d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010dc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010e3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010ea:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010f1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010f8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010ff:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801106:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80110d:	48 89 c7             	mov    %rax,%rdi
  801110:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  801117:	00 00 00 
  80111a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80111c:	90                   	nop
  80111d:	c9                   	leaveq 
  80111e:	c3                   	retq   

000000000080111f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111f:	55                   	push   %rbp
  801120:	48 89 e5             	mov    %rsp,%rbp
  801123:	48 83 ec 10          	sub    $0x10,%rsp
  801127:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80112a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80112e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801132:	8b 40 10             	mov    0x10(%rax),%eax
  801135:	8d 50 01             	lea    0x1(%rax),%edx
  801138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80113f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801143:	48 8b 10             	mov    (%rax),%rdx
  801146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80114e:	48 39 c2             	cmp    %rax,%rdx
  801151:	73 17                	jae    80116a <sprintputch+0x4b>
		*b->buf++ = ch;
  801153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801157:	48 8b 00             	mov    (%rax),%rax
  80115a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80115e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801162:	48 89 0a             	mov    %rcx,(%rdx)
  801165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801168:	88 10                	mov    %dl,(%rax)
}
  80116a:	90                   	nop
  80116b:	c9                   	leaveq 
  80116c:	c3                   	retq   

000000000080116d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80116d:	55                   	push   %rbp
  80116e:	48 89 e5             	mov    %rsp,%rbp
  801171:	48 83 ec 50          	sub    $0x50,%rsp
  801175:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801179:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80117c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801180:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801184:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801188:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80118c:	48 8b 0a             	mov    (%rdx),%rcx
  80118f:	48 89 08             	mov    %rcx,(%rax)
  801192:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801196:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80119a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80119e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011a2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011a6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011aa:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011ad:	48 98                	cltq   
  8011af:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011b7:	48 01 d0             	add    %rdx,%rax
  8011ba:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011c5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011ca:	74 06                	je     8011d2 <vsnprintf+0x65>
  8011cc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011d0:	7f 07                	jg     8011d9 <vsnprintf+0x6c>
		return -E_INVAL;
  8011d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d7:	eb 2f                	jmp    801208 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011d9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011dd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011e5:	48 89 c6             	mov    %rax,%rsi
  8011e8:	48 bf 1f 11 80 00 00 	movabs $0x80111f,%rdi
  8011ef:	00 00 00 
  8011f2:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  8011f9:	00 00 00 
  8011fc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801202:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801205:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   

000000000080120a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801215:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80121c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801222:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801229:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801230:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801237:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80123e:	84 c0                	test   %al,%al
  801240:	74 20                	je     801262 <snprintf+0x58>
  801242:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801246:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80124a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80124e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801252:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801256:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80125a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80125e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801262:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801269:	00 00 00 
  80126c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801273:	00 00 00 
  801276:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80127a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801281:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801288:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80128f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801296:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80129d:	48 8b 0a             	mov    (%rdx),%rcx
  8012a0:	48 89 08             	mov    %rcx,(%rax)
  8012a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012af:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012b3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012ba:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012c1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012c7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012ce:	48 89 c7             	mov    %rax,%rdi
  8012d1:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  8012d8:	00 00 00 
  8012db:	ff d0                	callq  *%rax
  8012dd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012e3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 18          	sub    $0x18,%rsp
  8012f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012fe:	eb 09                	jmp    801309 <strlen+0x1e>
		n++;
  801300:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801304:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	84 c0                	test   %al,%al
  801312:	75 ec                	jne    801300 <strlen+0x15>
		n++;
	return n;
  801314:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	48 83 ec 20          	sub    $0x20,%rsp
  801321:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801325:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801329:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801330:	eb 0e                	jmp    801340 <strnlen+0x27>
		n++;
  801332:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801336:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80133b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801340:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801345:	74 0b                	je     801352 <strnlen+0x39>
  801347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134b:	0f b6 00             	movzbl (%rax),%eax
  80134e:	84 c0                	test   %al,%al
  801350:	75 e0                	jne    801332 <strnlen+0x19>
		n++;
	return n;
  801352:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801355:	c9                   	leaveq 
  801356:	c3                   	retq   

0000000000801357 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801357:	55                   	push   %rbp
  801358:	48 89 e5             	mov    %rsp,%rbp
  80135b:	48 83 ec 20          	sub    $0x20,%rsp
  80135f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801363:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80136f:	90                   	nop
  801370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801374:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801378:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80137c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801380:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801384:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801388:	0f b6 12             	movzbl (%rdx),%edx
  80138b:	88 10                	mov    %dl,(%rax)
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	84 c0                	test   %al,%al
  801392:	75 dc                	jne    801370 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801398:	c9                   	leaveq 
  801399:	c3                   	retq   

000000000080139a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80139a:	55                   	push   %rbp
  80139b:	48 89 e5             	mov    %rsp,%rbp
  80139e:	48 83 ec 20          	sub    $0x20,%rsp
  8013a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	48 89 c7             	mov    %rax,%rdi
  8013b1:	48 b8 eb 12 80 00 00 	movabs $0x8012eb,%rax
  8013b8:	00 00 00 
  8013bb:	ff d0                	callq  *%rax
  8013bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c3:	48 63 d0             	movslq %eax,%rdx
  8013c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ca:	48 01 c2             	add    %rax,%rdx
  8013cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d1:	48 89 c6             	mov    %rax,%rsi
  8013d4:	48 89 d7             	mov    %rdx,%rdi
  8013d7:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  8013de:	00 00 00 
  8013e1:	ff d0                	callq  *%rax
	return dst;
  8013e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013e7:	c9                   	leaveq 
  8013e8:	c3                   	retq   

00000000008013e9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013e9:	55                   	push   %rbp
  8013ea:	48 89 e5             	mov    %rsp,%rbp
  8013ed:	48 83 ec 28          	sub    $0x28,%rsp
  8013f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801401:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801405:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80140c:	00 
  80140d:	eb 2a                	jmp    801439 <strncpy+0x50>
		*dst++ = *src;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801417:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80141b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80141f:	0f b6 12             	movzbl (%rdx),%edx
  801422:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801424:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	84 c0                	test   %al,%al
  80142d:	74 05                	je     801434 <strncpy+0x4b>
			src++;
  80142f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801434:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801441:	72 cc                	jb     80140f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801447:	c9                   	leaveq 
  801448:	c3                   	retq   

0000000000801449 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801449:	55                   	push   %rbp
  80144a:	48 89 e5             	mov    %rsp,%rbp
  80144d:	48 83 ec 28          	sub    $0x28,%rsp
  801451:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801455:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801459:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80145d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801461:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801465:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80146a:	74 3d                	je     8014a9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80146c:	eb 1d                	jmp    80148b <strlcpy+0x42>
			*dst++ = *src++;
  80146e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801472:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801476:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80147a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80147e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801482:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801486:	0f b6 12             	movzbl (%rdx),%edx
  801489:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80148b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801490:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801495:	74 0b                	je     8014a2 <strlcpy+0x59>
  801497:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 cc                	jne    80146e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b1:	48 29 c2             	sub    %rax,%rdx
  8014b4:	48 89 d0             	mov    %rdx,%rax
}
  8014b7:	c9                   	leaveq 
  8014b8:	c3                   	retq   

00000000008014b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014b9:	55                   	push   %rbp
  8014ba:	48 89 e5             	mov    %rsp,%rbp
  8014bd:	48 83 ec 10          	sub    $0x10,%rsp
  8014c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014c9:	eb 0a                	jmp    8014d5 <strcmp+0x1c>
		p++, q++;
  8014cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d9:	0f b6 00             	movzbl (%rax),%eax
  8014dc:	84 c0                	test   %al,%al
  8014de:	74 12                	je     8014f2 <strcmp+0x39>
  8014e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e4:	0f b6 10             	movzbl (%rax),%edx
  8014e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	38 c2                	cmp    %al,%dl
  8014f0:	74 d9                	je     8014cb <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	0f b6 d0             	movzbl %al,%edx
  8014fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	0f b6 c0             	movzbl %al,%eax
  801506:	29 c2                	sub    %eax,%edx
  801508:	89 d0                	mov    %edx,%eax
}
  80150a:	c9                   	leaveq 
  80150b:	c3                   	retq   

000000000080150c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	48 83 ec 18          	sub    $0x18,%rsp
  801514:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801518:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80151c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801520:	eb 0f                	jmp    801531 <strncmp+0x25>
		n--, p++, q++;
  801522:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801527:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801531:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801536:	74 1d                	je     801555 <strncmp+0x49>
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	84 c0                	test   %al,%al
  801541:	74 12                	je     801555 <strncmp+0x49>
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	0f b6 10             	movzbl (%rax),%edx
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	38 c2                	cmp    %al,%dl
  801553:	74 cd                	je     801522 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801555:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80155a:	75 07                	jne    801563 <strncmp+0x57>
		return 0;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	eb 18                	jmp    80157b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	0f b6 d0             	movzbl %al,%edx
  80156d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801571:	0f b6 00             	movzbl (%rax),%eax
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 10          	sub    $0x10,%rsp
  801585:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801589:	89 f0                	mov    %esi,%eax
  80158b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80158e:	eb 17                	jmp    8015a7 <strchr+0x2a>
		if (*s == c)
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80159a:	75 06                	jne    8015a2 <strchr+0x25>
			return (char *) s;
  80159c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a0:	eb 15                	jmp    8015b7 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ab:	0f b6 00             	movzbl (%rax),%eax
  8015ae:	84 c0                	test   %al,%al
  8015b0:	75 de                	jne    801590 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b7:	c9                   	leaveq 
  8015b8:	c3                   	retq   

00000000008015b9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015b9:	55                   	push   %rbp
  8015ba:	48 89 e5             	mov    %rsp,%rbp
  8015bd:	48 83 ec 10          	sub    $0x10,%rsp
  8015c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c5:	89 f0                	mov    %esi,%eax
  8015c7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ca:	eb 11                	jmp    8015dd <strfind+0x24>
		if (*s == c)
  8015cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d0:	0f b6 00             	movzbl (%rax),%eax
  8015d3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015d6:	74 12                	je     8015ea <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	84 c0                	test   %al,%al
  8015e6:	75 e4                	jne    8015cc <strfind+0x13>
  8015e8:	eb 01                	jmp    8015eb <strfind+0x32>
		if (*s == c)
			break;
  8015ea:	90                   	nop
	return (char *) s;
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015ef:	c9                   	leaveq 
  8015f0:	c3                   	retq   

00000000008015f1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015f1:	55                   	push   %rbp
  8015f2:	48 89 e5             	mov    %rsp,%rbp
  8015f5:	48 83 ec 18          	sub    $0x18,%rsp
  8015f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015fd:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801600:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801604:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801609:	75 06                	jne    801611 <memset+0x20>
		return v;
  80160b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160f:	eb 69                	jmp    80167a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801615:	83 e0 03             	and    $0x3,%eax
  801618:	48 85 c0             	test   %rax,%rax
  80161b:	75 48                	jne    801665 <memset+0x74>
  80161d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801621:	83 e0 03             	and    $0x3,%eax
  801624:	48 85 c0             	test   %rax,%rax
  801627:	75 3c                	jne    801665 <memset+0x74>
		c &= 0xFF;
  801629:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801630:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801633:	c1 e0 18             	shl    $0x18,%eax
  801636:	89 c2                	mov    %eax,%edx
  801638:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80163b:	c1 e0 10             	shl    $0x10,%eax
  80163e:	09 c2                	or     %eax,%edx
  801640:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801643:	c1 e0 08             	shl    $0x8,%eax
  801646:	09 d0                	or     %edx,%eax
  801648:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80164b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164f:	48 c1 e8 02          	shr    $0x2,%rax
  801653:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801656:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80165d:	48 89 d7             	mov    %rdx,%rdi
  801660:	fc                   	cld    
  801661:	f3 ab                	rep stos %eax,%es:(%rdi)
  801663:	eb 11                	jmp    801676 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801665:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801669:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80166c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801670:	48 89 d7             	mov    %rdx,%rdi
  801673:	fc                   	cld    
  801674:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80167a:	c9                   	leaveq 
  80167b:	c3                   	retq   

000000000080167c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80167c:	55                   	push   %rbp
  80167d:	48 89 e5             	mov    %rsp,%rbp
  801680:	48 83 ec 28          	sub    $0x28,%rsp
  801684:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801688:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80168c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801690:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801694:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016a8:	0f 83 88 00 00 00    	jae    801736 <memmove+0xba>
  8016ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	48 01 d0             	add    %rdx,%rax
  8016b9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016bd:	76 77                	jbe    801736 <memmove+0xba>
		s += n;
  8016bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cb:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d3:	83 e0 03             	and    $0x3,%eax
  8016d6:	48 85 c0             	test   %rax,%rax
  8016d9:	75 3b                	jne    801716 <memmove+0x9a>
  8016db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016df:	83 e0 03             	and    $0x3,%eax
  8016e2:	48 85 c0             	test   %rax,%rax
  8016e5:	75 2f                	jne    801716 <memmove+0x9a>
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	83 e0 03             	and    $0x3,%eax
  8016ee:	48 85 c0             	test   %rax,%rax
  8016f1:	75 23                	jne    801716 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	48 83 e8 04          	sub    $0x4,%rax
  8016fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ff:	48 83 ea 04          	sub    $0x4,%rdx
  801703:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801707:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80170b:	48 89 c7             	mov    %rax,%rdi
  80170e:	48 89 d6             	mov    %rdx,%rsi
  801711:	fd                   	std    
  801712:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801714:	eb 1d                	jmp    801733 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80171e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801722:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 89 d7             	mov    %rdx,%rdi
  80172d:	48 89 c1             	mov    %rax,%rcx
  801730:	fd                   	std    
  801731:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801733:	fc                   	cld    
  801734:	eb 57                	jmp    80178d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173a:	83 e0 03             	and    $0x3,%eax
  80173d:	48 85 c0             	test   %rax,%rax
  801740:	75 36                	jne    801778 <memmove+0xfc>
  801742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801746:	83 e0 03             	and    $0x3,%eax
  801749:	48 85 c0             	test   %rax,%rax
  80174c:	75 2a                	jne    801778 <memmove+0xfc>
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	83 e0 03             	and    $0x3,%eax
  801755:	48 85 c0             	test   %rax,%rax
  801758:	75 1e                	jne    801778 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80175a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175e:	48 c1 e8 02          	shr    $0x2,%rax
  801762:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801769:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80176d:	48 89 c7             	mov    %rax,%rdi
  801770:	48 89 d6             	mov    %rdx,%rsi
  801773:	fc                   	cld    
  801774:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801776:	eb 15                	jmp    80178d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801780:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801784:	48 89 c7             	mov    %rax,%rdi
  801787:	48 89 d6             	mov    %rdx,%rsi
  80178a:	fc                   	cld    
  80178b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80178d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801791:	c9                   	leaveq 
  801792:	c3                   	retq   

0000000000801793 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801793:	55                   	push   %rbp
  801794:	48 89 e5             	mov    %rsp,%rbp
  801797:	48 83 ec 18          	sub    $0x18,%rsp
  80179b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80179f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ab:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b3:	48 89 ce             	mov    %rcx,%rsi
  8017b6:	48 89 c7             	mov    %rax,%rdi
  8017b9:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  8017c0:	00 00 00 
  8017c3:	ff d0                	callq  *%rax
}
  8017c5:	c9                   	leaveq 
  8017c6:	c3                   	retq   

00000000008017c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017c7:	55                   	push   %rbp
  8017c8:	48 89 e5             	mov    %rsp,%rbp
  8017cb:	48 83 ec 28          	sub    $0x28,%rsp
  8017cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017eb:	eb 36                	jmp    801823 <memcmp+0x5c>
		if (*s1 != *s2)
  8017ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f1:	0f b6 10             	movzbl (%rax),%edx
  8017f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	38 c2                	cmp    %al,%dl
  8017fd:	74 1a                	je     801819 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	0f b6 d0             	movzbl %al,%edx
  801809:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	0f b6 c0             	movzbl %al,%eax
  801813:	29 c2                	sub    %eax,%edx
  801815:	89 d0                	mov    %edx,%eax
  801817:	eb 20                	jmp    801839 <memcmp+0x72>
		s1++, s2++;
  801819:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80181e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801827:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80182b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80182f:	48 85 c0             	test   %rax,%rax
  801832:	75 b9                	jne    8017ed <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   

000000000080183b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	48 83 ec 28          	sub    $0x28,%rsp
  801843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801847:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80184a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80184e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	48 01 d0             	add    %rdx,%rax
  801859:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80185d:	eb 19                	jmp    801878 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80185f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801863:	0f b6 00             	movzbl (%rax),%eax
  801866:	0f b6 d0             	movzbl %al,%edx
  801869:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80186c:	0f b6 c0             	movzbl %al,%eax
  80186f:	39 c2                	cmp    %eax,%edx
  801871:	74 11                	je     801884 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801873:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801880:	72 dd                	jb     80185f <memfind+0x24>
  801882:	eb 01                	jmp    801885 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801884:	90                   	nop
	return (void *) s;
  801885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801889:	c9                   	leaveq 
  80188a:	c3                   	retq   

000000000080188b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	48 83 ec 38          	sub    $0x38,%rsp
  801893:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801897:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80189b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80189e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018a5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018ac:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ad:	eb 05                	jmp    8018b4 <strtol+0x29>
		s++;
  8018af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b8:	0f b6 00             	movzbl (%rax),%eax
  8018bb:	3c 20                	cmp    $0x20,%al
  8018bd:	74 f0                	je     8018af <strtol+0x24>
  8018bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c3:	0f b6 00             	movzbl (%rax),%eax
  8018c6:	3c 09                	cmp    $0x9,%al
  8018c8:	74 e5                	je     8018af <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	3c 2b                	cmp    $0x2b,%al
  8018d3:	75 07                	jne    8018dc <strtol+0x51>
		s++;
  8018d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018da:	eb 17                	jmp    8018f3 <strtol+0x68>
	else if (*s == '-')
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	3c 2d                	cmp    $0x2d,%al
  8018e5:	75 0c                	jne    8018f3 <strtol+0x68>
		s++, neg = 1;
  8018e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018f7:	74 06                	je     8018ff <strtol+0x74>
  8018f9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018fd:	75 28                	jne    801927 <strtol+0x9c>
  8018ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	3c 30                	cmp    $0x30,%al
  801908:	75 1d                	jne    801927 <strtol+0x9c>
  80190a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190e:	48 83 c0 01          	add    $0x1,%rax
  801912:	0f b6 00             	movzbl (%rax),%eax
  801915:	3c 78                	cmp    $0x78,%al
  801917:	75 0e                	jne    801927 <strtol+0x9c>
		s += 2, base = 16;
  801919:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80191e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801925:	eb 2c                	jmp    801953 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801927:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80192b:	75 19                	jne    801946 <strtol+0xbb>
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 30                	cmp    $0x30,%al
  801936:	75 0e                	jne    801946 <strtol+0xbb>
		s++, base = 8;
  801938:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80193d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801944:	eb 0d                	jmp    801953 <strtol+0xc8>
	else if (base == 0)
  801946:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80194a:	75 07                	jne    801953 <strtol+0xc8>
		base = 10;
  80194c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801957:	0f b6 00             	movzbl (%rax),%eax
  80195a:	3c 2f                	cmp    $0x2f,%al
  80195c:	7e 1d                	jle    80197b <strtol+0xf0>
  80195e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801962:	0f b6 00             	movzbl (%rax),%eax
  801965:	3c 39                	cmp    $0x39,%al
  801967:	7f 12                	jg     80197b <strtol+0xf0>
			dig = *s - '0';
  801969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196d:	0f b6 00             	movzbl (%rax),%eax
  801970:	0f be c0             	movsbl %al,%eax
  801973:	83 e8 30             	sub    $0x30,%eax
  801976:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801979:	eb 4e                	jmp    8019c9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80197b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197f:	0f b6 00             	movzbl (%rax),%eax
  801982:	3c 60                	cmp    $0x60,%al
  801984:	7e 1d                	jle    8019a3 <strtol+0x118>
  801986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198a:	0f b6 00             	movzbl (%rax),%eax
  80198d:	3c 7a                	cmp    $0x7a,%al
  80198f:	7f 12                	jg     8019a3 <strtol+0x118>
			dig = *s - 'a' + 10;
  801991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801995:	0f b6 00             	movzbl (%rax),%eax
  801998:	0f be c0             	movsbl %al,%eax
  80199b:	83 e8 57             	sub    $0x57,%eax
  80199e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019a1:	eb 26                	jmp    8019c9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a7:	0f b6 00             	movzbl (%rax),%eax
  8019aa:	3c 40                	cmp    $0x40,%al
  8019ac:	7e 47                	jle    8019f5 <strtol+0x16a>
  8019ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	3c 5a                	cmp    $0x5a,%al
  8019b7:	7f 3c                	jg     8019f5 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8019b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bd:	0f b6 00             	movzbl (%rax),%eax
  8019c0:	0f be c0             	movsbl %al,%eax
  8019c3:	83 e8 37             	sub    $0x37,%eax
  8019c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019cc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019cf:	7d 23                	jge    8019f4 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8019d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019d6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019d9:	48 98                	cltq   
  8019db:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019e0:	48 89 c2             	mov    %rax,%rdx
  8019e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019e6:	48 98                	cltq   
  8019e8:	48 01 d0             	add    %rdx,%rax
  8019eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019ef:	e9 5f ff ff ff       	jmpq   801953 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019f4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019f5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019fa:	74 0b                	je     801a07 <strtol+0x17c>
		*endptr = (char *) s;
  8019fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a00:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a04:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a0b:	74 09                	je     801a16 <strtol+0x18b>
  801a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a11:	48 f7 d8             	neg    %rax
  801a14:	eb 04                	jmp    801a1a <strtol+0x18f>
  801a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a1a:	c9                   	leaveq 
  801a1b:	c3                   	retq   

0000000000801a1c <strstr>:

char * strstr(const char *in, const char *str)
{
  801a1c:	55                   	push   %rbp
  801a1d:	48 89 e5             	mov    %rsp,%rbp
  801a20:	48 83 ec 30          	sub    $0x30,%rsp
  801a24:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a30:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a34:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a38:	0f b6 00             	movzbl (%rax),%eax
  801a3b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a3e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a42:	75 06                	jne    801a4a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a48:	eb 6b                	jmp    801ab5 <strstr+0x99>

	len = strlen(str);
  801a4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a4e:	48 89 c7             	mov    %rax,%rdi
  801a51:	48 b8 eb 12 80 00 00 	movabs $0x8012eb,%rax
  801a58:	00 00 00 
  801a5b:	ff d0                	callq  *%rax
  801a5d:	48 98                	cltq   
  801a5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a6b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a6f:	0f b6 00             	movzbl (%rax),%eax
  801a72:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a75:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a79:	75 07                	jne    801a82 <strstr+0x66>
				return (char *) 0;
  801a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a80:	eb 33                	jmp    801ab5 <strstr+0x99>
		} while (sc != c);
  801a82:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a86:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a89:	75 d8                	jne    801a63 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a97:	48 89 ce             	mov    %rcx,%rsi
  801a9a:	48 89 c7             	mov    %rax,%rdi
  801a9d:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	75 b6                	jne    801a63 <strstr+0x47>

	return (char *) (in - 1);
  801aad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab1:	48 83 e8 01          	sub    $0x1,%rax
}
  801ab5:	c9                   	leaveq 
  801ab6:	c3                   	retq   

0000000000801ab7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ab7:	55                   	push   %rbp
  801ab8:	48 89 e5             	mov    %rsp,%rbp
  801abb:	53                   	push   %rbx
  801abc:	48 83 ec 48          	sub    $0x48,%rsp
  801ac0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ac3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ac6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aca:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801ace:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ad2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ad6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ad9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801add:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ae1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ae5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ae9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801aed:	4c 89 c3             	mov    %r8,%rbx
  801af0:	cd 30                	int    $0x30
  801af2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801af6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801afa:	74 3e                	je     801b3a <syscall+0x83>
  801afc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b01:	7e 37                	jle    801b3a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b07:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b0a:	49 89 d0             	mov    %rdx,%r8
  801b0d:	89 c1                	mov    %eax,%ecx
  801b0f:	48 ba 08 51 80 00 00 	movabs $0x805108,%rdx
  801b16:	00 00 00 
  801b19:	be 24 00 00 00       	mov    $0x24,%esi
  801b1e:	48 bf 25 51 80 00 00 	movabs $0x805125,%rdi
  801b25:	00 00 00 
  801b28:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2d:	49 b9 8d 05 80 00 00 	movabs $0x80058d,%r9
  801b34:	00 00 00 
  801b37:	41 ff d1             	callq  *%r9

	return ret;
  801b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b3e:	48 83 c4 48          	add    $0x48,%rsp
  801b42:	5b                   	pop    %rbx
  801b43:	5d                   	pop    %rbp
  801b44:	c3                   	retq   

0000000000801b45 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b45:	55                   	push   %rbp
  801b46:	48 89 e5             	mov    %rsp,%rbp
  801b49:	48 83 ec 10          	sub    $0x10,%rsp
  801b4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5d:	48 83 ec 08          	sub    $0x8,%rsp
  801b61:	6a 00                	pushq  $0x0
  801b63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6f:	48 89 d1             	mov    %rdx,%rcx
  801b72:	48 89 c2             	mov    %rax,%rdx
  801b75:	be 00 00 00 00       	mov    $0x0,%esi
  801b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b7f:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	callq  *%rax
  801b8b:	48 83 c4 10          	add    $0x10,%rsp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leaveq 
  801b91:	c3                   	retq   

0000000000801b92 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b92:	55                   	push   %rbp
  801b93:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b96:	48 83 ec 08          	sub    $0x8,%rsp
  801b9a:	6a 00                	pushq  $0x0
  801b9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bad:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb2:	be 00 00 00 00       	mov    $0x0,%esi
  801bb7:	bf 01 00 00 00       	mov    $0x1,%edi
  801bbc:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	callq  *%rax
  801bc8:	48 83 c4 10          	add    $0x10,%rsp
}
  801bcc:	c9                   	leaveq 
  801bcd:	c3                   	retq   

0000000000801bce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bce:	55                   	push   %rbp
  801bcf:	48 89 e5             	mov    %rsp,%rbp
  801bd2:	48 83 ec 10          	sub    $0x10,%rsp
  801bd6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdc:	48 98                	cltq   
  801bde:	48 83 ec 08          	sub    $0x8,%rsp
  801be2:	6a 00                	pushq  $0x0
  801be4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bf5:	48 89 c2             	mov    %rax,%rdx
  801bf8:	be 01 00 00 00       	mov    $0x1,%esi
  801bfd:	bf 03 00 00 00       	mov    $0x3,%edi
  801c02:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	callq  *%rax
  801c0e:	48 83 c4 10          	add    $0x10,%rsp
}
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c18:	48 83 ec 08          	sub    $0x8,%rsp
  801c1c:	6a 00                	pushq  $0x0
  801c1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	be 00 00 00 00       	mov    $0x0,%esi
  801c39:	bf 02 00 00 00       	mov    $0x2,%edi
  801c3e:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801c45:	00 00 00 
  801c48:	ff d0                	callq  *%rax
  801c4a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c4e:	c9                   	leaveq 
  801c4f:	c3                   	retq   

0000000000801c50 <sys_yield>:


void
sys_yield(void)
{
  801c50:	55                   	push   %rbp
  801c51:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c54:	48 83 ec 08          	sub    $0x8,%rsp
  801c58:	6a 00                	pushq  $0x0
  801c5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c70:	be 00 00 00 00       	mov    $0x0,%esi
  801c75:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c7a:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
  801c86:	48 83 c4 10          	add    $0x10,%rsp
}
  801c8a:	90                   	nop
  801c8b:	c9                   	leaveq 
  801c8c:	c3                   	retq   

0000000000801c8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c8d:	55                   	push   %rbp
  801c8e:	48 89 e5             	mov    %rsp,%rbp
  801c91:	48 83 ec 10          	sub    $0x10,%rsp
  801c95:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c9c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca2:	48 63 c8             	movslq %eax,%rcx
  801ca5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cac:	48 98                	cltq   
  801cae:	48 83 ec 08          	sub    $0x8,%rsp
  801cb2:	6a 00                	pushq  $0x0
  801cb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cba:	49 89 c8             	mov    %rcx,%r8
  801cbd:	48 89 d1             	mov    %rdx,%rcx
  801cc0:	48 89 c2             	mov    %rax,%rdx
  801cc3:	be 01 00 00 00       	mov    $0x1,%esi
  801cc8:	bf 04 00 00 00       	mov    $0x4,%edi
  801ccd:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
  801cd9:	48 83 c4 10          	add    $0x10,%rsp
}
  801cdd:	c9                   	leaveq 
  801cde:	c3                   	retq   

0000000000801cdf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801cdf:	55                   	push   %rbp
  801ce0:	48 89 e5             	mov    %rsp,%rbp
  801ce3:	48 83 ec 20          	sub    $0x20,%rsp
  801ce7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cee:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cf1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cf5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801cf9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cfc:	48 63 c8             	movslq %eax,%rcx
  801cff:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d06:	48 63 f0             	movslq %eax,%rsi
  801d09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d10:	48 98                	cltq   
  801d12:	48 83 ec 08          	sub    $0x8,%rsp
  801d16:	51                   	push   %rcx
  801d17:	49 89 f9             	mov    %rdi,%r9
  801d1a:	49 89 f0             	mov    %rsi,%r8
  801d1d:	48 89 d1             	mov    %rdx,%rcx
  801d20:	48 89 c2             	mov    %rax,%rdx
  801d23:	be 01 00 00 00       	mov    $0x1,%esi
  801d28:	bf 05 00 00 00       	mov    $0x5,%edi
  801d2d:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	callq  *%rax
  801d39:	48 83 c4 10          	add    $0x10,%rsp
}
  801d3d:	c9                   	leaveq 
  801d3e:	c3                   	retq   

0000000000801d3f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d3f:	55                   	push   %rbp
  801d40:	48 89 e5             	mov    %rsp,%rbp
  801d43:	48 83 ec 10          	sub    $0x10,%rsp
  801d47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d55:	48 98                	cltq   
  801d57:	48 83 ec 08          	sub    $0x8,%rsp
  801d5b:	6a 00                	pushq  $0x0
  801d5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d69:	48 89 d1             	mov    %rdx,%rcx
  801d6c:	48 89 c2             	mov    %rax,%rdx
  801d6f:	be 01 00 00 00       	mov    $0x1,%esi
  801d74:	bf 06 00 00 00       	mov    $0x6,%edi
  801d79:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801d80:	00 00 00 
  801d83:	ff d0                	callq  *%rax
  801d85:	48 83 c4 10          	add    $0x10,%rsp
}
  801d89:	c9                   	leaveq 
  801d8a:	c3                   	retq   

0000000000801d8b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d8b:	55                   	push   %rbp
  801d8c:	48 89 e5             	mov    %rsp,%rbp
  801d8f:	48 83 ec 10          	sub    $0x10,%rsp
  801d93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d96:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9c:	48 63 d0             	movslq %eax,%rdx
  801d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da2:	48 98                	cltq   
  801da4:	48 83 ec 08          	sub    $0x8,%rsp
  801da8:	6a 00                	pushq  $0x0
  801daa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db6:	48 89 d1             	mov    %rdx,%rcx
  801db9:	48 89 c2             	mov    %rax,%rdx
  801dbc:	be 01 00 00 00       	mov    $0x1,%esi
  801dc1:	bf 08 00 00 00       	mov    $0x8,%edi
  801dc6:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801dcd:	00 00 00 
  801dd0:	ff d0                	callq  *%rax
  801dd2:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd6:	c9                   	leaveq 
  801dd7:	c3                   	retq   

0000000000801dd8 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801dd8:	55                   	push   %rbp
  801dd9:	48 89 e5             	mov    %rsp,%rbp
  801ddc:	48 83 ec 10          	sub    $0x10,%rsp
  801de0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801de7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dee:	48 98                	cltq   
  801df0:	48 83 ec 08          	sub    $0x8,%rsp
  801df4:	6a 00                	pushq  $0x0
  801df6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e02:	48 89 d1             	mov    %rdx,%rcx
  801e05:	48 89 c2             	mov    %rax,%rdx
  801e08:	be 01 00 00 00       	mov    $0x1,%esi
  801e0d:	bf 09 00 00 00       	mov    $0x9,%edi
  801e12:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	48 83 c4 10          	add    $0x10,%rsp
}
  801e22:	c9                   	leaveq 
  801e23:	c3                   	retq   

0000000000801e24 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
  801e28:	48 83 ec 10          	sub    $0x10,%rsp
  801e2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3a:	48 98                	cltq   
  801e3c:	48 83 ec 08          	sub    $0x8,%rsp
  801e40:	6a 00                	pushq  $0x0
  801e42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4e:	48 89 d1             	mov    %rdx,%rcx
  801e51:	48 89 c2             	mov    %rax,%rdx
  801e54:	be 01 00 00 00       	mov    $0x1,%esi
  801e59:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e5e:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	callq  *%rax
  801e6a:	48 83 c4 10          	add    $0x10,%rsp
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 20          	sub    $0x20,%rsp
  801e78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e83:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e89:	48 63 f0             	movslq %eax,%rsi
  801e8c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e93:	48 98                	cltq   
  801e95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e99:	48 83 ec 08          	sub    $0x8,%rsp
  801e9d:	6a 00                	pushq  $0x0
  801e9f:	49 89 f1             	mov    %rsi,%r9
  801ea2:	49 89 c8             	mov    %rcx,%r8
  801ea5:	48 89 d1             	mov    %rdx,%rcx
  801ea8:	48 89 c2             	mov    %rax,%rdx
  801eab:	be 00 00 00 00       	mov    $0x0,%esi
  801eb0:	bf 0c 00 00 00       	mov    $0xc,%edi
  801eb5:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
  801ec1:	48 83 c4 10          	add    $0x10,%rsp
}
  801ec5:	c9                   	leaveq 
  801ec6:	c3                   	retq   

0000000000801ec7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	48 83 ec 10          	sub    $0x10,%rsp
  801ecf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ed3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed7:	48 83 ec 08          	sub    $0x8,%rsp
  801edb:	6a 00                	pushq  $0x0
  801edd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eee:	48 89 c2             	mov    %rax,%rdx
  801ef1:	be 01 00 00 00       	mov    $0x1,%esi
  801ef6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801efb:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	callq  *%rax
  801f07:	48 83 c4 10          	add    $0x10,%rsp
}
  801f0b:	c9                   	leaveq 
  801f0c:	c3                   	retq   

0000000000801f0d <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f11:	48 83 ec 08          	sub    $0x8,%rsp
  801f15:	6a 00                	pushq  $0x0
  801f17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f23:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f28:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2d:	be 00 00 00 00       	mov    $0x0,%esi
  801f32:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f37:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	callq  *%rax
  801f43:	48 83 c4 10          	add    $0x10,%rsp
}
  801f47:	c9                   	leaveq 
  801f48:	c3                   	retq   

0000000000801f49 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	48 83 ec 10          	sub    $0x10,%rsp
  801f51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f55:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801f58:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801f5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5f:	48 83 ec 08          	sub    $0x8,%rsp
  801f63:	6a 00                	pushq  $0x0
  801f65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f71:	48 89 d1             	mov    %rdx,%rcx
  801f74:	48 89 c2             	mov    %rax,%rdx
  801f77:	be 00 00 00 00       	mov    $0x0,%esi
  801f7c:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f81:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801f88:	00 00 00 
  801f8b:	ff d0                	callq  *%rax
  801f8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801f91:	c9                   	leaveq 
  801f92:	c3                   	retq   

0000000000801f93 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801f93:	55                   	push   %rbp
  801f94:	48 89 e5             	mov    %rsp,%rbp
  801f97:	48 83 ec 10          	sub    $0x10,%rsp
  801f9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f9f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801fa2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801fa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa9:	48 83 ec 08          	sub    $0x8,%rsp
  801fad:	6a 00                	pushq  $0x0
  801faf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fbb:	48 89 d1             	mov    %rdx,%rcx
  801fbe:	48 89 c2             	mov    %rax,%rdx
  801fc1:	be 00 00 00 00       	mov    $0x0,%esi
  801fc6:	bf 10 00 00 00       	mov    $0x10,%edi
  801fcb:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
  801fd7:	48 83 c4 10          	add    $0x10,%rsp
}
  801fdb:	c9                   	leaveq 
  801fdc:	c3                   	retq   

0000000000801fdd <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801fdd:	55                   	push   %rbp
  801fde:	48 89 e5             	mov    %rsp,%rbp
  801fe1:	48 83 ec 20          	sub    $0x20,%rsp
  801fe5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fe8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fec:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801fef:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ff3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801ff7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ffa:	48 63 c8             	movslq %eax,%rcx
  801ffd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802001:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802004:	48 63 f0             	movslq %eax,%rsi
  802007:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200e:	48 98                	cltq   
  802010:	48 83 ec 08          	sub    $0x8,%rsp
  802014:	51                   	push   %rcx
  802015:	49 89 f9             	mov    %rdi,%r9
  802018:	49 89 f0             	mov    %rsi,%r8
  80201b:	48 89 d1             	mov    %rdx,%rcx
  80201e:	48 89 c2             	mov    %rax,%rdx
  802021:	be 00 00 00 00       	mov    $0x0,%esi
  802026:	bf 11 00 00 00       	mov    $0x11,%edi
  80202b:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
  802037:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80203b:	c9                   	leaveq 
  80203c:	c3                   	retq   

000000000080203d <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80203d:	55                   	push   %rbp
  80203e:	48 89 e5             	mov    %rsp,%rbp
  802041:	48 83 ec 10          	sub    $0x10,%rsp
  802045:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802049:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80204d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802055:	48 83 ec 08          	sub    $0x8,%rsp
  802059:	6a 00                	pushq  $0x0
  80205b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802061:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802067:	48 89 d1             	mov    %rdx,%rcx
  80206a:	48 89 c2             	mov    %rax,%rdx
  80206d:	be 00 00 00 00       	mov    $0x0,%esi
  802072:	bf 12 00 00 00       	mov    $0x12,%edi
  802077:	48 b8 b7 1a 80 00 00 	movabs $0x801ab7,%rax
  80207e:	00 00 00 
  802081:	ff d0                	callq  *%rax
  802083:	48 83 c4 10          	add    $0x10,%rsp
}
  802087:	c9                   	leaveq 
  802088:	c3                   	retq   

0000000000802089 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802089:	55                   	push   %rbp
  80208a:	48 89 e5             	mov    %rsp,%rbp
  80208d:	48 83 ec 08          	sub    $0x8,%rsp
  802091:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802095:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802099:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020a0:	ff ff ff 
  8020a3:	48 01 d0             	add    %rdx,%rax
  8020a6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020aa:	c9                   	leaveq 
  8020ab:	c3                   	retq   

00000000008020ac <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020ac:	55                   	push   %rbp
  8020ad:	48 89 e5             	mov    %rsp,%rbp
  8020b0:	48 83 ec 08          	sub    $0x8,%rsp
  8020b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020bc:	48 89 c7             	mov    %rax,%rdi
  8020bf:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax
  8020cb:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8020d1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8020d5:	c9                   	leaveq 
  8020d6:	c3                   	retq   

00000000008020d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8020d7:	55                   	push   %rbp
  8020d8:	48 89 e5             	mov    %rsp,%rbp
  8020db:	48 83 ec 18          	sub    $0x18,%rsp
  8020df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ea:	eb 6b                	jmp    802157 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8020ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ef:	48 98                	cltq   
  8020f1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020f7:	48 c1 e0 0c          	shl    $0xc,%rax
  8020fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8020ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802103:	48 c1 e8 15          	shr    $0x15,%rax
  802107:	48 89 c2             	mov    %rax,%rdx
  80210a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802111:	01 00 00 
  802114:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802118:	83 e0 01             	and    $0x1,%eax
  80211b:	48 85 c0             	test   %rax,%rax
  80211e:	74 21                	je     802141 <fd_alloc+0x6a>
  802120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802124:	48 c1 e8 0c          	shr    $0xc,%rax
  802128:	48 89 c2             	mov    %rax,%rdx
  80212b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802132:	01 00 00 
  802135:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802139:	83 e0 01             	and    $0x1,%eax
  80213c:	48 85 c0             	test   %rax,%rax
  80213f:	75 12                	jne    802153 <fd_alloc+0x7c>
			*fd_store = fd;
  802141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802145:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802149:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	eb 1a                	jmp    80216d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802153:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802157:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80215b:	7e 8f                	jle    8020ec <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80215d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802161:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802168:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80216d:	c9                   	leaveq 
  80216e:	c3                   	retq   

000000000080216f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	48 83 ec 20          	sub    $0x20,%rsp
  802177:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80217a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80217e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802182:	78 06                	js     80218a <fd_lookup+0x1b>
  802184:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802188:	7e 07                	jle    802191 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80218a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80218f:	eb 6c                	jmp    8021fd <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802191:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802194:	48 98                	cltq   
  802196:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80219c:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a8:	48 c1 e8 15          	shr    $0x15,%rax
  8021ac:	48 89 c2             	mov    %rax,%rdx
  8021af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021b6:	01 00 00 
  8021b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021bd:	83 e0 01             	and    $0x1,%eax
  8021c0:	48 85 c0             	test   %rax,%rax
  8021c3:	74 21                	je     8021e6 <fd_lookup+0x77>
  8021c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8021cd:	48 89 c2             	mov    %rax,%rdx
  8021d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021d7:	01 00 00 
  8021da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021de:	83 e0 01             	and    $0x1,%eax
  8021e1:	48 85 c0             	test   %rax,%rax
  8021e4:	75 07                	jne    8021ed <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021eb:	eb 10                	jmp    8021fd <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8021ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021f5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fd:	c9                   	leaveq 
  8021fe:	c3                   	retq   

00000000008021ff <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8021ff:	55                   	push   %rbp
  802200:	48 89 e5             	mov    %rsp,%rbp
  802203:	48 83 ec 30          	sub    $0x30,%rsp
  802207:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80220b:	89 f0                	mov    %esi,%eax
  80220d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802210:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802214:	48 89 c7             	mov    %rax,%rdi
  802217:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  80221e:	00 00 00 
  802221:	ff d0                	callq  *%rax
  802223:	89 c2                	mov    %eax,%edx
  802225:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802229:	48 89 c6             	mov    %rax,%rsi
  80222c:	89 d7                	mov    %edx,%edi
  80222e:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802235:	00 00 00 
  802238:	ff d0                	callq  *%rax
  80223a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802241:	78 0a                	js     80224d <fd_close+0x4e>
	    || fd != fd2)
  802243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802247:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80224b:	74 12                	je     80225f <fd_close+0x60>
		return (must_exist ? r : 0);
  80224d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802251:	74 05                	je     802258 <fd_close+0x59>
  802253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802256:	eb 70                	jmp    8022c8 <fd_close+0xc9>
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	eb 69                	jmp    8022c8 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80225f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802263:	8b 00                	mov    (%rax),%eax
  802265:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802269:	48 89 d6             	mov    %rdx,%rsi
  80226c:	89 c7                	mov    %eax,%edi
  80226e:	48 b8 ca 22 80 00 00 	movabs $0x8022ca,%rax
  802275:	00 00 00 
  802278:	ff d0                	callq  *%rax
  80227a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802281:	78 2a                	js     8022ad <fd_close+0xae>
		if (dev->dev_close)
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	48 8b 40 20          	mov    0x20(%rax),%rax
  80228b:	48 85 c0             	test   %rax,%rax
  80228e:	74 16                	je     8022a6 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802294:	48 8b 40 20          	mov    0x20(%rax),%rax
  802298:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80229c:	48 89 d7             	mov    %rdx,%rdi
  80229f:	ff d0                	callq  *%rax
  8022a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a4:	eb 07                	jmp    8022ad <fd_close+0xae>
		else
			r = 0;
  8022a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b1:	48 89 c6             	mov    %rax,%rsi
  8022b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b9:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  8022c0:	00 00 00 
  8022c3:	ff d0                	callq  *%rax
	return r;
  8022c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022c8:	c9                   	leaveq 
  8022c9:	c3                   	retq   

00000000008022ca <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8022ca:	55                   	push   %rbp
  8022cb:	48 89 e5             	mov    %rsp,%rbp
  8022ce:	48 83 ec 20          	sub    $0x20,%rsp
  8022d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8022d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022e0:	eb 41                	jmp    802323 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8022e2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8022e9:	00 00 00 
  8022ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022ef:	48 63 d2             	movslq %edx,%rdx
  8022f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f6:	8b 00                	mov    (%rax),%eax
  8022f8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022fb:	75 22                	jne    80231f <dev_lookup+0x55>
			*dev = devtab[i];
  8022fd:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802304:	00 00 00 
  802307:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80230a:	48 63 d2             	movslq %edx,%rdx
  80230d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802315:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
  80231d:	eb 60                	jmp    80237f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80231f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802323:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80232a:	00 00 00 
  80232d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802330:	48 63 d2             	movslq %edx,%rdx
  802333:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802337:	48 85 c0             	test   %rax,%rax
  80233a:	75 a6                	jne    8022e2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80233c:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  802343:	00 00 00 
  802346:	48 8b 00             	mov    (%rax),%rax
  802349:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80234f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802352:	89 c6                	mov    %eax,%esi
  802354:	48 bf 38 51 80 00 00 	movabs $0x805138,%rdi
  80235b:	00 00 00 
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
  802363:	48 b9 c7 07 80 00 00 	movabs $0x8007c7,%rcx
  80236a:	00 00 00 
  80236d:	ff d1                	callq  *%rcx
	*dev = 0;
  80236f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802373:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80237a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80237f:	c9                   	leaveq 
  802380:	c3                   	retq   

0000000000802381 <close>:

int
close(int fdnum)
{
  802381:	55                   	push   %rbp
  802382:	48 89 e5             	mov    %rsp,%rbp
  802385:	48 83 ec 20          	sub    $0x20,%rsp
  802389:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80238c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802390:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802393:	48 89 d6             	mov    %rdx,%rsi
  802396:	89 c7                	mov    %eax,%edi
  802398:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
  8023a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ab:	79 05                	jns    8023b2 <close+0x31>
		return r;
  8023ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b0:	eb 18                	jmp    8023ca <close+0x49>
	else
		return fd_close(fd, 1);
  8023b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b6:	be 01 00 00 00       	mov    $0x1,%esi
  8023bb:	48 89 c7             	mov    %rax,%rdi
  8023be:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
}
  8023ca:	c9                   	leaveq 
  8023cb:	c3                   	retq   

00000000008023cc <close_all>:

void
close_all(void)
{
  8023cc:	55                   	push   %rbp
  8023cd:	48 89 e5             	mov    %rsp,%rbp
  8023d0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8023d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023db:	eb 15                	jmp    8023f2 <close_all+0x26>
		close(i);
  8023dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e0:	89 c7                	mov    %eax,%edi
  8023e2:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8023ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023f2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023f6:	7e e5                	jle    8023dd <close_all+0x11>
		close(i);
}
  8023f8:	90                   	nop
  8023f9:	c9                   	leaveq 
  8023fa:	c3                   	retq   

00000000008023fb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8023fb:	55                   	push   %rbp
  8023fc:	48 89 e5             	mov    %rsp,%rbp
  8023ff:	48 83 ec 40          	sub    $0x40,%rsp
  802403:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802406:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802409:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80240d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802410:	48 89 d6             	mov    %rdx,%rsi
  802413:	89 c7                	mov    %eax,%edi
  802415:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802424:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802428:	79 08                	jns    802432 <dup+0x37>
		return r;
  80242a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242d:	e9 70 01 00 00       	jmpq   8025a2 <dup+0x1a7>
	close(newfdnum);
  802432:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802435:	89 c7                	mov    %eax,%edi
  802437:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  80243e:	00 00 00 
  802441:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802443:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802446:	48 98                	cltq   
  802448:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80244e:	48 c1 e0 0c          	shl    $0xc,%rax
  802452:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80245a:	48 89 c7             	mov    %rax,%rdi
  80245d:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax
  802469:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80246d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802471:	48 89 c7             	mov    %rax,%rdi
  802474:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	callq  *%rax
  802480:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802488:	48 c1 e8 15          	shr    $0x15,%rax
  80248c:	48 89 c2             	mov    %rax,%rdx
  80248f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802496:	01 00 00 
  802499:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249d:	83 e0 01             	and    $0x1,%eax
  8024a0:	48 85 c0             	test   %rax,%rax
  8024a3:	74 71                	je     802516 <dup+0x11b>
  8024a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ad:	48 89 c2             	mov    %rax,%rdx
  8024b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b7:	01 00 00 
  8024ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024be:	83 e0 01             	and    $0x1,%eax
  8024c1:	48 85 c0             	test   %rax,%rax
  8024c4:	74 50                	je     802516 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8024c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ce:	48 89 c2             	mov    %rax,%rdx
  8024d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024d8:	01 00 00 
  8024db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024df:	25 07 0e 00 00       	and    $0xe07,%eax
  8024e4:	89 c1                	mov    %eax,%ecx
  8024e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ee:	41 89 c8             	mov    %ecx,%r8d
  8024f1:	48 89 d1             	mov    %rdx,%rcx
  8024f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f9:	48 89 c6             	mov    %rax,%rsi
  8024fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802501:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  802508:	00 00 00 
  80250b:	ff d0                	callq  *%rax
  80250d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802510:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802514:	78 55                	js     80256b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80251a:	48 c1 e8 0c          	shr    $0xc,%rax
  80251e:	48 89 c2             	mov    %rax,%rdx
  802521:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802528:	01 00 00 
  80252b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252f:	25 07 0e 00 00       	and    $0xe07,%eax
  802534:	89 c1                	mov    %eax,%ecx
  802536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80253e:	41 89 c8             	mov    %ecx,%r8d
  802541:	48 89 d1             	mov    %rdx,%rcx
  802544:	ba 00 00 00 00       	mov    $0x0,%edx
  802549:	48 89 c6             	mov    %rax,%rsi
  80254c:	bf 00 00 00 00       	mov    $0x0,%edi
  802551:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802564:	78 08                	js     80256e <dup+0x173>
		goto err;

	return newfdnum;
  802566:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802569:	eb 37                	jmp    8025a2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80256b:	90                   	nop
  80256c:	eb 01                	jmp    80256f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80256e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80256f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802573:	48 89 c6             	mov    %rax,%rsi
  802576:	bf 00 00 00 00       	mov    $0x0,%edi
  80257b:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802587:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258b:	48 89 c6             	mov    %rax,%rsi
  80258e:	bf 00 00 00 00       	mov    $0x0,%edi
  802593:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  80259a:	00 00 00 
  80259d:	ff d0                	callq  *%rax
	return r;
  80259f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025a2:	c9                   	leaveq 
  8025a3:	c3                   	retq   

00000000008025a4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025a4:	55                   	push   %rbp
  8025a5:	48 89 e5             	mov    %rsp,%rbp
  8025a8:	48 83 ec 40          	sub    $0x40,%rsp
  8025ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025be:	48 89 d6             	mov    %rdx,%rsi
  8025c1:	89 c7                	mov    %eax,%edi
  8025c3:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8025ca:	00 00 00 
  8025cd:	ff d0                	callq  *%rax
  8025cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d6:	78 24                	js     8025fc <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025dc:	8b 00                	mov    (%rax),%eax
  8025de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025e2:	48 89 d6             	mov    %rdx,%rsi
  8025e5:	89 c7                	mov    %eax,%edi
  8025e7:	48 b8 ca 22 80 00 00 	movabs $0x8022ca,%rax
  8025ee:	00 00 00 
  8025f1:	ff d0                	callq  *%rax
  8025f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fa:	79 05                	jns    802601 <read+0x5d>
		return r;
  8025fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ff:	eb 76                	jmp    802677 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802605:	8b 40 08             	mov    0x8(%rax),%eax
  802608:	83 e0 03             	and    $0x3,%eax
  80260b:	83 f8 01             	cmp    $0x1,%eax
  80260e:	75 3a                	jne    80264a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802610:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  802617:	00 00 00 
  80261a:	48 8b 00             	mov    (%rax),%rax
  80261d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802623:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802626:	89 c6                	mov    %eax,%esi
  802628:	48 bf 57 51 80 00 00 	movabs $0x805157,%rdi
  80262f:	00 00 00 
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	48 b9 c7 07 80 00 00 	movabs $0x8007c7,%rcx
  80263e:	00 00 00 
  802641:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802643:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802648:	eb 2d                	jmp    802677 <read+0xd3>
	}
	if (!dev->dev_read)
  80264a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802652:	48 85 c0             	test   %rax,%rax
  802655:	75 07                	jne    80265e <read+0xba>
		return -E_NOT_SUPP;
  802657:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80265c:	eb 19                	jmp    802677 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80265e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802662:	48 8b 40 10          	mov    0x10(%rax),%rax
  802666:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80266a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80266e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802672:	48 89 cf             	mov    %rcx,%rdi
  802675:	ff d0                	callq  *%rax
}
  802677:	c9                   	leaveq 
  802678:	c3                   	retq   

0000000000802679 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802679:	55                   	push   %rbp
  80267a:	48 89 e5             	mov    %rsp,%rbp
  80267d:	48 83 ec 30          	sub    $0x30,%rsp
  802681:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802684:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802688:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80268c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802693:	eb 47                	jmp    8026dc <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802698:	48 98                	cltq   
  80269a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80269e:	48 29 c2             	sub    %rax,%rdx
  8026a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a4:	48 63 c8             	movslq %eax,%rcx
  8026a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ab:	48 01 c1             	add    %rax,%rcx
  8026ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026b1:	48 89 ce             	mov    %rcx,%rsi
  8026b4:	89 c7                	mov    %eax,%edi
  8026b6:	48 b8 a4 25 80 00 00 	movabs $0x8025a4,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8026c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026c9:	79 05                	jns    8026d0 <readn+0x57>
			return m;
  8026cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026ce:	eb 1d                	jmp    8026ed <readn+0x74>
		if (m == 0)
  8026d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026d4:	74 13                	je     8026e9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026d9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026df:	48 98                	cltq   
  8026e1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8026e5:	72 ae                	jb     802695 <readn+0x1c>
  8026e7:	eb 01                	jmp    8026ea <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8026e9:	90                   	nop
	}
	return tot;
  8026ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026ed:	c9                   	leaveq 
  8026ee:	c3                   	retq   

00000000008026ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8026ef:	55                   	push   %rbp
  8026f0:	48 89 e5             	mov    %rsp,%rbp
  8026f3:	48 83 ec 40          	sub    $0x40,%rsp
  8026f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802702:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802706:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802709:	48 89 d6             	mov    %rdx,%rsi
  80270c:	89 c7                	mov    %eax,%edi
  80270e:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
  80271a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802721:	78 24                	js     802747 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802727:	8b 00                	mov    (%rax),%eax
  802729:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80272d:	48 89 d6             	mov    %rdx,%rsi
  802730:	89 c7                	mov    %eax,%edi
  802732:	48 b8 ca 22 80 00 00 	movabs $0x8022ca,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax
  80273e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802741:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802745:	79 05                	jns    80274c <write+0x5d>
		return r;
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274a:	eb 75                	jmp    8027c1 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80274c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802750:	8b 40 08             	mov    0x8(%rax),%eax
  802753:	83 e0 03             	and    $0x3,%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	75 3a                	jne    802794 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80275a:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  802761:	00 00 00 
  802764:	48 8b 00             	mov    (%rax),%rax
  802767:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80276d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802770:	89 c6                	mov    %eax,%esi
  802772:	48 bf 73 51 80 00 00 	movabs $0x805173,%rdi
  802779:	00 00 00 
  80277c:	b8 00 00 00 00       	mov    $0x0,%eax
  802781:	48 b9 c7 07 80 00 00 	movabs $0x8007c7,%rcx
  802788:	00 00 00 
  80278b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80278d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802792:	eb 2d                	jmp    8027c1 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802798:	48 8b 40 18          	mov    0x18(%rax),%rax
  80279c:	48 85 c0             	test   %rax,%rax
  80279f:	75 07                	jne    8027a8 <write+0xb9>
		return -E_NOT_SUPP;
  8027a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a6:	eb 19                	jmp    8027c1 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ac:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027b8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027bc:	48 89 cf             	mov    %rcx,%rdi
  8027bf:	ff d0                	callq  *%rax
}
  8027c1:	c9                   	leaveq 
  8027c2:	c3                   	retq   

00000000008027c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8027c3:	55                   	push   %rbp
  8027c4:	48 89 e5             	mov    %rsp,%rbp
  8027c7:	48 83 ec 18          	sub    $0x18,%rsp
  8027cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ce:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d8:	48 89 d6             	mov    %rdx,%rsi
  8027db:	89 c7                	mov    %eax,%edi
  8027dd:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8027e4:	00 00 00 
  8027e7:	ff d0                	callq  *%rax
  8027e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f0:	79 05                	jns    8027f7 <seek+0x34>
		return r;
  8027f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f5:	eb 0f                	jmp    802806 <seek+0x43>
	fd->fd_offset = offset;
  8027f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8027fe:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802806:	c9                   	leaveq 
  802807:	c3                   	retq   

0000000000802808 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802808:	55                   	push   %rbp
  802809:	48 89 e5             	mov    %rsp,%rbp
  80280c:	48 83 ec 30          	sub    $0x30,%rsp
  802810:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802813:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802816:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80281a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80281d:	48 89 d6             	mov    %rdx,%rsi
  802820:	89 c7                	mov    %eax,%edi
  802822:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
  80282e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802831:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802835:	78 24                	js     80285b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283b:	8b 00                	mov    (%rax),%eax
  80283d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802841:	48 89 d6             	mov    %rdx,%rsi
  802844:	89 c7                	mov    %eax,%edi
  802846:	48 b8 ca 22 80 00 00 	movabs $0x8022ca,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
  802852:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802855:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802859:	79 05                	jns    802860 <ftruncate+0x58>
		return r;
  80285b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285e:	eb 72                	jmp    8028d2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802864:	8b 40 08             	mov    0x8(%rax),%eax
  802867:	83 e0 03             	and    $0x3,%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	75 3a                	jne    8028a8 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80286e:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  802875:	00 00 00 
  802878:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80287b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802881:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802884:	89 c6                	mov    %eax,%esi
  802886:	48 bf 90 51 80 00 00 	movabs $0x805190,%rdi
  80288d:	00 00 00 
  802890:	b8 00 00 00 00       	mov    $0x0,%eax
  802895:	48 b9 c7 07 80 00 00 	movabs $0x8007c7,%rcx
  80289c:	00 00 00 
  80289f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a6:	eb 2a                	jmp    8028d2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ac:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028b0:	48 85 c0             	test   %rax,%rax
  8028b3:	75 07                	jne    8028bc <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028ba:	eb 16                	jmp    8028d2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8028cb:	89 ce                	mov    %ecx,%esi
  8028cd:	48 89 d7             	mov    %rdx,%rdi
  8028d0:	ff d0                	callq  *%rax
}
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 30          	sub    $0x30,%rsp
  8028dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028e3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ea:	48 89 d6             	mov    %rdx,%rsi
  8028ed:	89 c7                	mov    %eax,%edi
  8028ef:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8028f6:	00 00 00 
  8028f9:	ff d0                	callq  *%rax
  8028fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802902:	78 24                	js     802928 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802908:	8b 00                	mov    (%rax),%eax
  80290a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80290e:	48 89 d6             	mov    %rdx,%rsi
  802911:	89 c7                	mov    %eax,%edi
  802913:	48 b8 ca 22 80 00 00 	movabs $0x8022ca,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	callq  *%rax
  80291f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802926:	79 05                	jns    80292d <fstat+0x59>
		return r;
  802928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292b:	eb 5e                	jmp    80298b <fstat+0xb7>
	if (!dev->dev_stat)
  80292d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802931:	48 8b 40 28          	mov    0x28(%rax),%rax
  802935:	48 85 c0             	test   %rax,%rax
  802938:	75 07                	jne    802941 <fstat+0x6d>
		return -E_NOT_SUPP;
  80293a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80293f:	eb 4a                	jmp    80298b <fstat+0xb7>
	stat->st_name[0] = 0;
  802941:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802945:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802948:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80294c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802953:	00 00 00 
	stat->st_isdir = 0;
  802956:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80295a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802961:	00 00 00 
	stat->st_dev = dev;
  802964:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802968:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80296c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802977:	48 8b 40 28          	mov    0x28(%rax),%rax
  80297b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80297f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802983:	48 89 ce             	mov    %rcx,%rsi
  802986:	48 89 d7             	mov    %rdx,%rdi
  802989:	ff d0                	callq  *%rax
}
  80298b:	c9                   	leaveq 
  80298c:	c3                   	retq   

000000000080298d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80298d:	55                   	push   %rbp
  80298e:	48 89 e5             	mov    %rsp,%rbp
  802991:	48 83 ec 20          	sub    $0x20,%rsp
  802995:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802999:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80299d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a1:	be 00 00 00 00       	mov    $0x0,%esi
  8029a6:	48 89 c7             	mov    %rax,%rdi
  8029a9:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
  8029b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bc:	79 05                	jns    8029c3 <stat+0x36>
		return fd;
  8029be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c1:	eb 2f                	jmp    8029f2 <stat+0x65>
	r = fstat(fd, stat);
  8029c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ca:	48 89 d6             	mov    %rdx,%rsi
  8029cd:	89 c7                	mov    %eax,%edi
  8029cf:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
  8029db:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8029de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
	return r;
  8029ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8029f2:	c9                   	leaveq 
  8029f3:	c3                   	retq   

00000000008029f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8029f4:	55                   	push   %rbp
  8029f5:	48 89 e5             	mov    %rsp,%rbp
  8029f8:	48 83 ec 10          	sub    $0x10,%rsp
  8029fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a03:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a0a:	00 00 00 
  802a0d:	8b 00                	mov    (%rax),%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 1f                	jne    802a32 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a13:	bf 01 00 00 00       	mov    $0x1,%edi
  802a18:	48 b8 19 4a 80 00 00 	movabs $0x804a19,%rax
  802a1f:	00 00 00 
  802a22:	ff d0                	callq  *%rax
  802a24:	89 c2                	mov    %eax,%edx
  802a26:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a2d:	00 00 00 
  802a30:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a32:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a39:	00 00 00 
  802a3c:	8b 00                	mov    (%rax),%eax
  802a3e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a41:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a46:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802a4d:	00 00 00 
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 0d 48 80 00 00 	movabs $0x80480d,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a62:	ba 00 00 00 00       	mov    $0x0,%edx
  802a67:	48 89 c6             	mov    %rax,%rsi
  802a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6f:	48 b8 4c 47 80 00 00 	movabs $0x80474c,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
}
  802a7b:	c9                   	leaveq 
  802a7c:	c3                   	retq   

0000000000802a7d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a7d:	55                   	push   %rbp
  802a7e:	48 89 e5             	mov    %rsp,%rbp
  802a81:	48 83 ec 20          	sub    $0x20,%rsp
  802a85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a89:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a90:	48 89 c7             	mov    %rax,%rdi
  802a93:	48 b8 eb 12 80 00 00 	movabs $0x8012eb,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802aa4:	7e 0a                	jle    802ab0 <open+0x33>
		return -E_BAD_PATH;
  802aa6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802aab:	e9 a5 00 00 00       	jmpq   802b55 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ab0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ab4:	48 89 c7             	mov    %rax,%rdi
  802ab7:	48 b8 d7 20 80 00 00 	movabs $0x8020d7,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	callq  *%rax
  802ac3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aca:	79 08                	jns    802ad4 <open+0x57>
		return r;
  802acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acf:	e9 81 00 00 00       	jmpq   802b55 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad8:	48 89 c6             	mov    %rax,%rsi
  802adb:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ae2:	00 00 00 
  802ae5:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802af1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802af8:	00 00 00 
  802afb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802afe:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802b04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b08:	48 89 c6             	mov    %rax,%rsi
  802b0b:	bf 01 00 00 00       	mov    $0x1,%edi
  802b10:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
  802b1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b23:	79 1d                	jns    802b42 <open+0xc5>
		fd_close(fd, 0);
  802b25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b29:	be 00 00 00 00       	mov    $0x0,%esi
  802b2e:	48 89 c7             	mov    %rax,%rdi
  802b31:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
		return r;
  802b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b40:	eb 13                	jmp    802b55 <open+0xd8>
	}

	return fd2num(fd);
  802b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b46:	48 89 c7             	mov    %rax,%rdi
  802b49:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax

}
  802b55:	c9                   	leaveq 
  802b56:	c3                   	retq   

0000000000802b57 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802b57:	55                   	push   %rbp
  802b58:	48 89 e5             	mov    %rsp,%rbp
  802b5b:	48 83 ec 10          	sub    $0x10,%rsp
  802b5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b67:	8b 50 0c             	mov    0xc(%rax),%edx
  802b6a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b71:	00 00 00 
  802b74:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b76:	be 00 00 00 00       	mov    $0x0,%esi
  802b7b:	bf 06 00 00 00       	mov    $0x6,%edi
  802b80:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
}
  802b8c:	c9                   	leaveq 
  802b8d:	c3                   	retq   

0000000000802b8e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b8e:	55                   	push   %rbp
  802b8f:	48 89 e5             	mov    %rsp,%rbp
  802b92:	48 83 ec 30          	sub    $0x30,%rsp
  802b96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b9e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ba2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ba9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bb0:	00 00 00 
  802bb3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802bb5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bbc:	00 00 00 
  802bbf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802bc7:	be 00 00 00 00       	mov    $0x0,%esi
  802bcc:	bf 03 00 00 00       	mov    $0x3,%edi
  802bd1:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
  802bdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be4:	79 08                	jns    802bee <devfile_read+0x60>
		return r;
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	e9 a4 00 00 00       	jmpq   802c92 <devfile_read+0x104>
	assert(r <= n);
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	48 98                	cltq   
  802bf3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bf7:	76 35                	jbe    802c2e <devfile_read+0xa0>
  802bf9:	48 b9 b6 51 80 00 00 	movabs $0x8051b6,%rcx
  802c00:	00 00 00 
  802c03:	48 ba bd 51 80 00 00 	movabs $0x8051bd,%rdx
  802c0a:	00 00 00 
  802c0d:	be 86 00 00 00       	mov    $0x86,%esi
  802c12:	48 bf d2 51 80 00 00 	movabs $0x8051d2,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  802c28:	00 00 00 
  802c2b:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802c2e:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802c35:	7e 35                	jle    802c6c <devfile_read+0xde>
  802c37:	48 b9 dd 51 80 00 00 	movabs $0x8051dd,%rcx
  802c3e:	00 00 00 
  802c41:	48 ba bd 51 80 00 00 	movabs $0x8051bd,%rdx
  802c48:	00 00 00 
  802c4b:	be 87 00 00 00       	mov    $0x87,%esi
  802c50:	48 bf d2 51 80 00 00 	movabs $0x8051d2,%rdi
  802c57:	00 00 00 
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5f:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  802c66:	00 00 00 
  802c69:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6f:	48 63 d0             	movslq %eax,%rdx
  802c72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c76:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802c7d:	00 00 00 
  802c80:	48 89 c7             	mov    %rax,%rdi
  802c83:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
	return r;
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802c92:	c9                   	leaveq 
  802c93:	c3                   	retq   

0000000000802c94 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c94:	55                   	push   %rbp
  802c95:	48 89 e5             	mov    %rsp,%rbp
  802c98:	48 83 ec 40          	sub    $0x40,%rsp
  802c9c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ca0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ca4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802ca8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802cac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802cb0:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802cb7:	00 
  802cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbc:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802cc0:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802cc5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ccd:	8b 50 0c             	mov    0xc(%rax),%edx
  802cd0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802cd7:	00 00 00 
  802cda:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802cdc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ce3:	00 00 00 
  802ce6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cea:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802cee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cf2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cf6:	48 89 c6             	mov    %rax,%rsi
  802cf9:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802d00:	00 00 00 
  802d03:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802d0f:	be 00 00 00 00       	mov    $0x0,%esi
  802d14:	bf 04 00 00 00       	mov    $0x4,%edi
  802d19:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
  802d25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d2c:	79 05                	jns    802d33 <devfile_write+0x9f>
		return r;
  802d2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d31:	eb 43                	jmp    802d76 <devfile_write+0xe2>
	assert(r <= n);
  802d33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d36:	48 98                	cltq   
  802d38:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802d3c:	76 35                	jbe    802d73 <devfile_write+0xdf>
  802d3e:	48 b9 b6 51 80 00 00 	movabs $0x8051b6,%rcx
  802d45:	00 00 00 
  802d48:	48 ba bd 51 80 00 00 	movabs $0x8051bd,%rdx
  802d4f:	00 00 00 
  802d52:	be a2 00 00 00       	mov    $0xa2,%esi
  802d57:	48 bf d2 51 80 00 00 	movabs $0x8051d2,%rdi
  802d5e:	00 00 00 
  802d61:	b8 00 00 00 00       	mov    $0x0,%eax
  802d66:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  802d6d:	00 00 00 
  802d70:	41 ff d0             	callq  *%r8
	return r;
  802d73:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802d76:	c9                   	leaveq 
  802d77:	c3                   	retq   

0000000000802d78 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d78:	55                   	push   %rbp
  802d79:	48 89 e5             	mov    %rsp,%rbp
  802d7c:	48 83 ec 20          	sub    $0x20,%rsp
  802d80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8c:	8b 50 0c             	mov    0xc(%rax),%edx
  802d8f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d96:	00 00 00 
  802d99:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d9b:	be 00 00 00 00       	mov    $0x0,%esi
  802da0:	bf 05 00 00 00       	mov    $0x5,%edi
  802da5:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
  802db1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db8:	79 05                	jns    802dbf <devfile_stat+0x47>
		return r;
  802dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbd:	eb 56                	jmp    802e15 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc3:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802dca:	00 00 00 
  802dcd:	48 89 c7             	mov    %rax,%rdi
  802dd0:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ddc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802de3:	00 00 00 
  802de6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802dec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802df6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802dfd:	00 00 00 
  802e00:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e0a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e15:	c9                   	leaveq 
  802e16:	c3                   	retq   

0000000000802e17 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e17:	55                   	push   %rbp
  802e18:	48 89 e5             	mov    %rsp,%rbp
  802e1b:	48 83 ec 10          	sub    $0x10,%rsp
  802e1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e23:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2a:	8b 50 0c             	mov    0xc(%rax),%edx
  802e2d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e34:	00 00 00 
  802e37:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e39:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e40:	00 00 00 
  802e43:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e46:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e49:	be 00 00 00 00       	mov    $0x0,%esi
  802e4e:	bf 02 00 00 00       	mov    $0x2,%edi
  802e53:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802e5a:	00 00 00 
  802e5d:	ff d0                	callq  *%rax
}
  802e5f:	c9                   	leaveq 
  802e60:	c3                   	retq   

0000000000802e61 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e61:	55                   	push   %rbp
  802e62:	48 89 e5             	mov    %rsp,%rbp
  802e65:	48 83 ec 10          	sub    $0x10,%rsp
  802e69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e71:	48 89 c7             	mov    %rax,%rdi
  802e74:	48 b8 eb 12 80 00 00 	movabs $0x8012eb,%rax
  802e7b:	00 00 00 
  802e7e:	ff d0                	callq  *%rax
  802e80:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e85:	7e 07                	jle    802e8e <remove+0x2d>
		return -E_BAD_PATH;
  802e87:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e8c:	eb 33                	jmp    802ec1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e92:	48 89 c6             	mov    %rax,%rsi
  802e95:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802e9c:	00 00 00 
  802e9f:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802eab:	be 00 00 00 00       	mov    $0x0,%esi
  802eb0:	bf 07 00 00 00       	mov    $0x7,%edi
  802eb5:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802ebc:	00 00 00 
  802ebf:	ff d0                	callq  *%rax
}
  802ec1:	c9                   	leaveq 
  802ec2:	c3                   	retq   

0000000000802ec3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ec3:	55                   	push   %rbp
  802ec4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ec7:	be 00 00 00 00       	mov    $0x0,%esi
  802ecc:	bf 08 00 00 00       	mov    $0x8,%edi
  802ed1:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  802ed8:	00 00 00 
  802edb:	ff d0                	callq  *%rax
}
  802edd:	5d                   	pop    %rbp
  802ede:	c3                   	retq   

0000000000802edf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802edf:	55                   	push   %rbp
  802ee0:	48 89 e5             	mov    %rsp,%rbp
  802ee3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802eea:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ef1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ef8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802eff:	be 00 00 00 00       	mov    $0x0,%esi
  802f04:	48 89 c7             	mov    %rax,%rdi
  802f07:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
  802f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1a:	79 28                	jns    802f44 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1f:	89 c6                	mov    %eax,%esi
  802f21:	48 bf e9 51 80 00 00 	movabs $0x8051e9,%rdi
  802f28:	00 00 00 
  802f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f30:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  802f37:	00 00 00 
  802f3a:	ff d2                	callq  *%rdx
		return fd_src;
  802f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3f:	e9 76 01 00 00       	jmpq   8030ba <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f44:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f4b:	be 01 01 00 00       	mov    $0x101,%esi
  802f50:	48 89 c7             	mov    %rax,%rdi
  802f53:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
  802f5f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f62:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f66:	0f 89 ad 00 00 00    	jns    803019 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f6f:	89 c6                	mov    %eax,%esi
  802f71:	48 bf ff 51 80 00 00 	movabs $0x8051ff,%rdi
  802f78:	00 00 00 
  802f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f80:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  802f87:	00 00 00 
  802f8a:	ff d2                	callq  *%rdx
		close(fd_src);
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	89 c7                	mov    %eax,%edi
  802f91:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
		return fd_dest;
  802f9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa0:	e9 15 01 00 00       	jmpq   8030ba <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802fa5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fa8:	48 63 d0             	movslq %eax,%rdx
  802fab:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fb5:	48 89 ce             	mov    %rcx,%rsi
  802fb8:	89 c7                	mov    %eax,%edi
  802fba:	48 b8 ef 26 80 00 00 	movabs $0x8026ef,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802fcd:	79 4a                	jns    803019 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802fcf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fd2:	89 c6                	mov    %eax,%esi
  802fd4:	48 bf 19 52 80 00 00 	movabs $0x805219,%rdi
  802fdb:	00 00 00 
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe3:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  802fea:	00 00 00 
  802fed:	ff d2                	callq  *%rdx
			close(fd_src);
  802fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff2:	89 c7                	mov    %eax,%edi
  802ff4:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  802ffb:	00 00 00 
  802ffe:	ff d0                	callq  *%rax
			close(fd_dest);
  803000:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803003:	89 c7                	mov    %eax,%edi
  803005:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
			return write_size;
  803011:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803014:	e9 a1 00 00 00       	jmpq   8030ba <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803019:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803023:	ba 00 02 00 00       	mov    $0x200,%edx
  803028:	48 89 ce             	mov    %rcx,%rsi
  80302b:	89 c7                	mov    %eax,%edi
  80302d:	48 b8 a4 25 80 00 00 	movabs $0x8025a4,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
  803039:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80303c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803040:	0f 8f 5f ff ff ff    	jg     802fa5 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803046:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80304a:	79 47                	jns    803093 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80304c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80304f:	89 c6                	mov    %eax,%esi
  803051:	48 bf 2c 52 80 00 00 	movabs $0x80522c,%rdi
  803058:	00 00 00 
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
  803060:	48 ba c7 07 80 00 00 	movabs $0x8007c7,%rdx
  803067:	00 00 00 
  80306a:	ff d2                	callq  *%rdx
		close(fd_src);
  80306c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306f:	89 c7                	mov    %eax,%edi
  803071:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
		close(fd_dest);
  80307d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803080:	89 c7                	mov    %eax,%edi
  803082:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
		return read_size;
  80308e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803091:	eb 27                	jmp    8030ba <copy+0x1db>
	}
	close(fd_src);
  803093:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803096:	89 c7                	mov    %eax,%edi
  803098:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  80309f:	00 00 00 
  8030a2:	ff d0                	callq  *%rax
	close(fd_dest);
  8030a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a7:	89 c7                	mov    %eax,%edi
  8030a9:	48 b8 81 23 80 00 00 	movabs $0x802381,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
	return 0;
  8030b5:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8030ba:	c9                   	leaveq 
  8030bb:	c3                   	retq   

00000000008030bc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 20          	sub    $0x20,%rsp
  8030c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030ce:	48 89 d6             	mov    %rdx,%rsi
  8030d1:	89 c7                	mov    %eax,%edi
  8030d3:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8030da:	00 00 00 
  8030dd:	ff d0                	callq  *%rax
  8030df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e6:	79 05                	jns    8030ed <fd2sockid+0x31>
		return r;
  8030e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030eb:	eb 24                	jmp    803111 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8030ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f1:	8b 10                	mov    (%rax),%edx
  8030f3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8030fa:	00 00 00 
  8030fd:	8b 00                	mov    (%rax),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	74 07                	je     80310a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803103:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803108:	eb 07                	jmp    803111 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80310a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803111:	c9                   	leaveq 
  803112:	c3                   	retq   

0000000000803113 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803113:	55                   	push   %rbp
  803114:	48 89 e5             	mov    %rsp,%rbp
  803117:	48 83 ec 20          	sub    $0x20,%rsp
  80311b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80311e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803122:	48 89 c7             	mov    %rax,%rdi
  803125:	48 b8 d7 20 80 00 00 	movabs $0x8020d7,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	78 26                	js     803160 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80313a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313e:	ba 07 04 00 00       	mov    $0x407,%edx
  803143:	48 89 c6             	mov    %rax,%rsi
  803146:	bf 00 00 00 00       	mov    $0x0,%edi
  80314b:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315e:	79 16                	jns    803176 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803160:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803163:	89 c7                	mov    %eax,%edi
  803165:	48 b8 22 36 80 00 00 	movabs $0x803622,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
		return r;
  803171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803174:	eb 3a                	jmp    8031b0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803181:	00 00 00 
  803184:	8b 12                	mov    (%rdx),%edx
  803186:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803197:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80319a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80319d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
}
  8031b0:	c9                   	leaveq 
  8031b1:	c3                   	retq   

00000000008031b2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 83 ec 30          	sub    $0x30,%rsp
  8031ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c8:	89 c7                	mov    %eax,%edi
  8031ca:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
  8031d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031dd:	79 05                	jns    8031e4 <accept+0x32>
		return r;
  8031df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e2:	eb 3b                	jmp    80321f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8031e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ef:	48 89 ce             	mov    %rcx,%rsi
  8031f2:	89 c7                	mov    %eax,%edi
  8031f4:	48 b8 ff 34 80 00 00 	movabs $0x8034ff,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
  803200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803207:	79 05                	jns    80320e <accept+0x5c>
		return r;
  803209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320c:	eb 11                	jmp    80321f <accept+0x6d>
	return alloc_sockfd(r);
  80320e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803211:	89 c7                	mov    %eax,%edi
  803213:	48 b8 13 31 80 00 00 	movabs $0x803113,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 83 ec 20          	sub    $0x20,%rsp
  803229:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80322c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803230:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803236:	89 c7                	mov    %eax,%edi
  803238:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax
  803244:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324b:	79 05                	jns    803252 <bind+0x31>
		return r;
  80324d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803250:	eb 1b                	jmp    80326d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803252:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803255:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325c:	48 89 ce             	mov    %rcx,%rsi
  80325f:	89 c7                	mov    %eax,%edi
  803261:	48 b8 7e 35 80 00 00 	movabs $0x80357e,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
}
  80326d:	c9                   	leaveq 
  80326e:	c3                   	retq   

000000000080326f <shutdown>:

int
shutdown(int s, int how)
{
  80326f:	55                   	push   %rbp
  803270:	48 89 e5             	mov    %rsp,%rbp
  803273:	48 83 ec 20          	sub    $0x20,%rsp
  803277:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80327a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80327d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803280:	89 c7                	mov    %eax,%edi
  803282:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
  80328e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803295:	79 05                	jns    80329c <shutdown+0x2d>
		return r;
  803297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329a:	eb 16                	jmp    8032b2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80329c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80329f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a2:	89 d6                	mov    %edx,%esi
  8032a4:	89 c7                	mov    %eax,%edi
  8032a6:	48 b8 e2 35 80 00 00 	movabs $0x8035e2,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
}
  8032b2:	c9                   	leaveq 
  8032b3:	c3                   	retq   

00000000008032b4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8032b4:	55                   	push   %rbp
  8032b5:	48 89 e5             	mov    %rsp,%rbp
  8032b8:	48 83 ec 10          	sub    $0x10,%rsp
  8032bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8032c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c4:	48 89 c7             	mov    %rax,%rdi
  8032c7:	48 b8 8a 4a 80 00 00 	movabs $0x804a8a,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	83 f8 01             	cmp    $0x1,%eax
  8032d6:	75 17                	jne    8032ef <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8032d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032dc:	8b 40 0c             	mov    0xc(%rax),%eax
  8032df:	89 c7                	mov    %eax,%edi
  8032e1:	48 b8 22 36 80 00 00 	movabs $0x803622,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	eb 05                	jmp    8032f4 <devsock_close+0x40>
	else
		return 0;
  8032ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f4:	c9                   	leaveq 
  8032f5:	c3                   	retq   

00000000008032f6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032f6:	55                   	push   %rbp
  8032f7:	48 89 e5             	mov    %rsp,%rbp
  8032fa:	48 83 ec 20          	sub    $0x20,%rsp
  8032fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803301:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803305:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803308:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80330b:	89 c7                	mov    %eax,%edi
  80330d:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
  803319:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803320:	79 05                	jns    803327 <connect+0x31>
		return r;
  803322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803325:	eb 1b                	jmp    803342 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803327:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80332a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	48 89 ce             	mov    %rcx,%rsi
  803334:	89 c7                	mov    %eax,%edi
  803336:	48 b8 4f 36 80 00 00 	movabs $0x80364f,%rax
  80333d:	00 00 00 
  803340:	ff d0                	callq  *%rax
}
  803342:	c9                   	leaveq 
  803343:	c3                   	retq   

0000000000803344 <listen>:

int
listen(int s, int backlog)
{
  803344:	55                   	push   %rbp
  803345:	48 89 e5             	mov    %rsp,%rbp
  803348:	48 83 ec 20          	sub    $0x20,%rsp
  80334c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80334f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803352:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803355:	89 c7                	mov    %eax,%edi
  803357:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80335e:	00 00 00 
  803361:	ff d0                	callq  *%rax
  803363:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336a:	79 05                	jns    803371 <listen+0x2d>
		return r;
  80336c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336f:	eb 16                	jmp    803387 <listen+0x43>
	return nsipc_listen(r, backlog);
  803371:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803377:	89 d6                	mov    %edx,%esi
  803379:	89 c7                	mov    %eax,%edi
  80337b:	48 b8 b3 36 80 00 00 	movabs $0x8036b3,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
}
  803387:	c9                   	leaveq 
  803388:	c3                   	retq   

0000000000803389 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803389:	55                   	push   %rbp
  80338a:	48 89 e5             	mov    %rsp,%rbp
  80338d:	48 83 ec 20          	sub    $0x20,%rsp
  803391:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803399:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80339d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a1:	89 c2                	mov    %eax,%edx
  8033a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a7:	8b 40 0c             	mov    0xc(%rax),%eax
  8033aa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033b3:	89 c7                	mov    %eax,%edi
  8033b5:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
}
  8033c1:	c9                   	leaveq 
  8033c2:	c3                   	retq   

00000000008033c3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033c3:	55                   	push   %rbp
  8033c4:	48 89 e5             	mov    %rsp,%rbp
  8033c7:	48 83 ec 20          	sub    $0x20,%rsp
  8033cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033db:	89 c2                	mov    %eax,%edx
  8033dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e1:	8b 40 0c             	mov    0xc(%rax),%eax
  8033e4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033ed:	89 c7                	mov    %eax,%edi
  8033ef:	48 b8 bf 37 80 00 00 	movabs $0x8037bf,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
}
  8033fb:	c9                   	leaveq 
  8033fc:	c3                   	retq   

00000000008033fd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8033fd:	55                   	push   %rbp
  8033fe:	48 89 e5             	mov    %rsp,%rbp
  803401:	48 83 ec 10          	sub    $0x10,%rsp
  803405:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803409:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80340d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803411:	48 be 47 52 80 00 00 	movabs $0x805247,%rsi
  803418:	00 00 00 
  80341b:	48 89 c7             	mov    %rax,%rdi
  80341e:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  803425:	00 00 00 
  803428:	ff d0                	callq  *%rax
	return 0;
  80342a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80342f:	c9                   	leaveq 
  803430:	c3                   	retq   

0000000000803431 <socket>:

int
socket(int domain, int type, int protocol)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 83 ec 20          	sub    $0x20,%rsp
  803439:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80343c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80343f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803442:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803445:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803448:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80344b:	89 ce                	mov    %ecx,%esi
  80344d:	89 c7                	mov    %eax,%edi
  80344f:	48 b8 77 38 80 00 00 	movabs $0x803877,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
  80345b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803462:	79 05                	jns    803469 <socket+0x38>
		return r;
  803464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803467:	eb 11                	jmp    80347a <socket+0x49>
	return alloc_sockfd(r);
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346c:	89 c7                	mov    %eax,%edi
  80346e:	48 b8 13 31 80 00 00 	movabs $0x803113,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
}
  80347a:	c9                   	leaveq 
  80347b:	c3                   	retq   

000000000080347c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80347c:	55                   	push   %rbp
  80347d:	48 89 e5             	mov    %rsp,%rbp
  803480:	48 83 ec 10          	sub    $0x10,%rsp
  803484:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803487:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  80348e:	00 00 00 
  803491:	8b 00                	mov    (%rax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	75 1f                	jne    8034b6 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803497:	bf 02 00 00 00       	mov    $0x2,%edi
  80349c:	48 b8 19 4a 80 00 00 	movabs $0x804a19,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	89 c2                	mov    %eax,%edx
  8034aa:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  8034b1:	00 00 00 
  8034b4:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8034b6:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  8034bd:	00 00 00 
  8034c0:	8b 00                	mov    (%rax),%eax
  8034c2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034c5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034ca:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8034d1:	00 00 00 
  8034d4:	89 c7                	mov    %eax,%edi
  8034d6:	48 b8 0d 48 80 00 00 	movabs $0x80480d,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8034e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e7:	be 00 00 00 00       	mov    $0x0,%esi
  8034ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f1:	48 b8 4c 47 80 00 00 	movabs $0x80474c,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
}
  8034fd:	c9                   	leaveq 
  8034fe:	c3                   	retq   

00000000008034ff <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034ff:	55                   	push   %rbp
  803500:	48 89 e5             	mov    %rsp,%rbp
  803503:	48 83 ec 30          	sub    $0x30,%rsp
  803507:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80350a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803512:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803519:	00 00 00 
  80351c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80351f:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803521:	bf 01 00 00 00       	mov    $0x1,%edi
  803526:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
  803532:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803535:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803539:	78 3e                	js     803579 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80353b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803542:	00 00 00 
  803545:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354d:	8b 40 10             	mov    0x10(%rax),%eax
  803550:	89 c2                	mov    %eax,%edx
  803552:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803556:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80355a:	48 89 ce             	mov    %rcx,%rsi
  80355d:	48 89 c7             	mov    %rax,%rdi
  803560:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  803567:	00 00 00 
  80356a:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80356c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803570:	8b 50 10             	mov    0x10(%rax),%edx
  803573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803577:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80357c:	c9                   	leaveq 
  80357d:	c3                   	retq   

000000000080357e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80357e:	55                   	push   %rbp
  80357f:	48 89 e5             	mov    %rsp,%rbp
  803582:	48 83 ec 10          	sub    $0x10,%rsp
  803586:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803589:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80358d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803590:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803597:	00 00 00 
  80359a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80359d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80359f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a6:	48 89 c6             	mov    %rax,%rsi
  8035a9:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8035b0:	00 00 00 
  8035b3:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8035bf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035c6:	00 00 00 
  8035c9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035cc:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8035cf:	bf 02 00 00 00       	mov    $0x2,%edi
  8035d4:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
}
  8035e0:	c9                   	leaveq 
  8035e1:	c3                   	retq   

00000000008035e2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8035e2:	55                   	push   %rbp
  8035e3:	48 89 e5             	mov    %rsp,%rbp
  8035e6:	48 83 ec 10          	sub    $0x10,%rsp
  8035ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035ed:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8035f0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035f7:	00 00 00 
  8035fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035fd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8035ff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803606:	00 00 00 
  803609:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80360c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80360f:	bf 03 00 00 00       	mov    $0x3,%edi
  803614:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
}
  803620:	c9                   	leaveq 
  803621:	c3                   	retq   

0000000000803622 <nsipc_close>:

int
nsipc_close(int s)
{
  803622:	55                   	push   %rbp
  803623:	48 89 e5             	mov    %rsp,%rbp
  803626:	48 83 ec 10          	sub    $0x10,%rsp
  80362a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80362d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803634:	00 00 00 
  803637:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80363a:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80363c:	bf 04 00 00 00       	mov    $0x4,%edi
  803641:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
}
  80364d:	c9                   	leaveq 
  80364e:	c3                   	retq   

000000000080364f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80364f:	55                   	push   %rbp
  803650:	48 89 e5             	mov    %rsp,%rbp
  803653:	48 83 ec 10          	sub    $0x10,%rsp
  803657:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80365a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80365e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803661:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803668:	00 00 00 
  80366b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80366e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803670:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803677:	48 89 c6             	mov    %rax,%rsi
  80367a:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803681:	00 00 00 
  803684:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  80368b:	00 00 00 
  80368e:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803690:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803697:	00 00 00 
  80369a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80369d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8036a0:	bf 05 00 00 00       	mov    $0x5,%edi
  8036a5:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
}
  8036b1:	c9                   	leaveq 
  8036b2:	c3                   	retq   

00000000008036b3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 10          	sub    $0x10,%rsp
  8036bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036be:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8036c1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036c8:	00 00 00 
  8036cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036ce:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8036d0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036d7:	00 00 00 
  8036da:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036dd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8036e0:	bf 06 00 00 00       	mov    $0x6,%edi
  8036e5:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
}
  8036f1:	c9                   	leaveq 
  8036f2:	c3                   	retq   

00000000008036f3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8036f3:	55                   	push   %rbp
  8036f4:	48 89 e5             	mov    %rsp,%rbp
  8036f7:	48 83 ec 30          	sub    $0x30,%rsp
  8036fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803702:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803705:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803708:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80370f:	00 00 00 
  803712:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803715:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803717:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80371e:	00 00 00 
  803721:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803724:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803727:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80372e:	00 00 00 
  803731:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803734:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803737:	bf 07 00 00 00       	mov    $0x7,%edi
  80373c:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374f:	78 69                	js     8037ba <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803751:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803758:	7f 08                	jg     803762 <nsipc_recv+0x6f>
  80375a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375d:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803760:	7e 35                	jle    803797 <nsipc_recv+0xa4>
  803762:	48 b9 4e 52 80 00 00 	movabs $0x80524e,%rcx
  803769:	00 00 00 
  80376c:	48 ba 63 52 80 00 00 	movabs $0x805263,%rdx
  803773:	00 00 00 
  803776:	be 62 00 00 00       	mov    $0x62,%esi
  80377b:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  803782:	00 00 00 
  803785:	b8 00 00 00 00       	mov    $0x0,%eax
  80378a:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  803791:	00 00 00 
  803794:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803797:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379a:	48 63 d0             	movslq %eax,%rdx
  80379d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a1:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8037a8:	00 00 00 
  8037ab:	48 89 c7             	mov    %rax,%rdi
  8037ae:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
	}

	return r;
  8037ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037bd:	c9                   	leaveq 
  8037be:	c3                   	retq   

00000000008037bf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037bf:	55                   	push   %rbp
  8037c0:	48 89 e5             	mov    %rsp,%rbp
  8037c3:	48 83 ec 20          	sub    $0x20,%rsp
  8037c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037ce:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8037d1:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8037d4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037db:	00 00 00 
  8037de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e1:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8037e3:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8037ea:	7e 35                	jle    803821 <nsipc_send+0x62>
  8037ec:	48 b9 84 52 80 00 00 	movabs $0x805284,%rcx
  8037f3:	00 00 00 
  8037f6:	48 ba 63 52 80 00 00 	movabs $0x805263,%rdx
  8037fd:	00 00 00 
  803800:	be 6d 00 00 00       	mov    $0x6d,%esi
  803805:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  80380c:	00 00 00 
  80380f:	b8 00 00 00 00       	mov    $0x0,%eax
  803814:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  80381b:	00 00 00 
  80381e:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803821:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803824:	48 63 d0             	movslq %eax,%rdx
  803827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382b:	48 89 c6             	mov    %rax,%rsi
  80382e:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803835:	00 00 00 
  803838:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  80383f:	00 00 00 
  803842:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803844:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80384b:	00 00 00 
  80384e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803851:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803854:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80385b:	00 00 00 
  80385e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803861:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803864:	bf 08 00 00 00       	mov    $0x8,%edi
  803869:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  803870:	00 00 00 
  803873:	ff d0                	callq  *%rax
}
  803875:	c9                   	leaveq 
  803876:	c3                   	retq   

0000000000803877 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803877:	55                   	push   %rbp
  803878:	48 89 e5             	mov    %rsp,%rbp
  80387b:	48 83 ec 10          	sub    $0x10,%rsp
  80387f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803882:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803885:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803888:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80388f:	00 00 00 
  803892:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803895:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803897:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80389e:	00 00 00 
  8038a1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038a4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8038a7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038ae:	00 00 00 
  8038b1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038b4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8038b7:	bf 09 00 00 00       	mov    $0x9,%edi
  8038bc:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
}
  8038c8:	c9                   	leaveq 
  8038c9:	c3                   	retq   

00000000008038ca <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  8038ca:	55                   	push   %rbp
  8038cb:	48 89 e5             	mov    %rsp,%rbp
  8038ce:	48 83 ec 20          	sub    $0x20,%rsp
  8038d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  8038da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e2:	48 01 d0             	add    %rdx,%rax
  8038e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8038e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8038f1:	eb 64                	jmp    803957 <isfree+0x8d>
		if (va >= (uintptr_t) mend
  8038f3:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  8038fa:	00 00 00 
  8038fd:	48 8b 00             	mov    (%rax),%rax
  803900:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803904:	73 42                	jae    803948 <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803906:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390a:	48 c1 e8 15          	shr    $0x15,%rax
  80390e:	48 89 c2             	mov    %rax,%rdx
  803911:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803918:	01 00 00 
  80391b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80391f:	83 e0 01             	and    $0x1,%eax
  803922:	48 85 c0             	test   %rax,%rax
  803925:	74 28                	je     80394f <isfree+0x85>
  803927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392b:	48 c1 e8 0c          	shr    $0xc,%rax
  80392f:	48 89 c2             	mov    %rax,%rdx
  803932:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803939:	01 00 00 
  80393c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803940:	83 e0 01             	and    $0x1,%eax
  803943:	48 85 c0             	test   %rax,%rax
  803946:	74 07                	je     80394f <isfree+0x85>
			return 0;
  803948:	b8 00 00 00 00       	mov    $0x0,%eax
  80394d:	eb 17                	jmp    803966 <isfree+0x9c>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80394f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803956:	00 
  803957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80395f:	72 92                	jb     8038f3 <isfree+0x29>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803961:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803966:	c9                   	leaveq 
  803967:	c3                   	retq   

0000000000803968 <malloc>:

void*
malloc(size_t n)
{
  803968:	55                   	push   %rbp
  803969:	48 89 e5             	mov    %rsp,%rbp
  80396c:	48 83 ec 60          	sub    $0x60,%rsp
  803970:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803974:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80397b:	00 00 00 
  80397e:	48 8b 00             	mov    (%rax),%rax
  803981:	48 85 c0             	test   %rax,%rax
  803984:	75 1a                	jne    8039a0 <malloc+0x38>
		mptr = mbegin;
  803986:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  80398d:	00 00 00 
  803990:	48 8b 10             	mov    (%rax),%rdx
  803993:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80399a:	00 00 00 
  80399d:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  8039a0:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  8039a7:	00 
  8039a8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8039ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b0:	48 01 d0             	add    %rdx,%rax
  8039b3:	48 83 e8 01          	sub    $0x1,%rax
  8039b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8039bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8039c4:	48 f7 75 f0          	divq   -0x10(%rbp)
  8039c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039cc:	48 29 d0             	sub    %rdx,%rax
  8039cf:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
	
	if (n >= MAXMALLOC)
  8039d3:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  8039da:	00 
  8039db:	76 0a                	jbe    8039e7 <malloc+0x7f>
		return 0;
  8039dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e2:	e9 f0 02 00 00       	jmpq   803cd7 <malloc+0x36f>
	
	if ((uintptr_t) mptr % PGSIZE){
  8039e7:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8039ee:	00 00 00 
  8039f1:	48 8b 00             	mov    (%rax),%rax
  8039f4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8039f9:	48 85 c0             	test   %rax,%rax
  8039fc:	0f 84 0f 01 00 00    	je     803b11 <malloc+0x1a9>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803a02:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803a09:	00 
  803a0a:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803a11:	00 00 00 
  803a14:	48 8b 00             	mov    (%rax),%rax
  803a17:	48 89 c2             	mov    %rax,%rdx
  803a1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1e:	48 01 d0             	add    %rdx,%rax
  803a21:	48 83 e8 01          	sub    $0x1,%rax
  803a25:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a32:	48 f7 75 e0          	divq   -0x20(%rbp)
  803a36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3a:	48 29 d0             	sub    %rdx,%rax
  803a3d:	48 83 e8 04          	sub    $0x4,%rax
  803a41:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803a45:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803a4c:	00 00 00 
  803a4f:	48 8b 00             	mov    (%rax),%rax
  803a52:	48 c1 e8 0c          	shr    $0xc,%rax
  803a56:	48 89 c1             	mov    %rax,%rcx
  803a59:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803a60:	00 00 00 
  803a63:	48 8b 00             	mov    (%rax),%rax
  803a66:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803a6a:	48 83 c2 03          	add    $0x3,%rdx
  803a6e:	48 01 d0             	add    %rdx,%rax
  803a71:	48 c1 e8 0c          	shr    $0xc,%rax
  803a75:	48 39 c1             	cmp    %rax,%rcx
  803a78:	75 4a                	jne    803ac4 <malloc+0x15c>
			(*ref)++;
  803a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7e:	8b 00                	mov    (%rax),%eax
  803a80:	8d 50 01             	lea    0x1(%rax),%edx
  803a83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a87:	89 10                	mov    %edx,(%rax)
			v = mptr;
  803a89:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803a90:	00 00 00 
  803a93:	48 8b 00             	mov    (%rax),%rax
  803a96:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  803a9a:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803aa1:	00 00 00 
  803aa4:	48 8b 10             	mov    (%rax),%rdx
  803aa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803aab:	48 01 c2             	add    %rax,%rdx
  803aae:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ab5:	00 00 00 
  803ab8:	48 89 10             	mov    %rdx,(%rax)
			return v;
  803abb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803abf:	e9 13 02 00 00       	jmpq   803cd7 <malloc+0x36f>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803ac4:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803acb:	00 00 00 
  803ace:	48 8b 00             	mov    (%rax),%rax
  803ad1:	48 89 c7             	mov    %rax,%rdi
  803ad4:	48 b8 d9 3c 80 00 00 	movabs $0x803cd9,%rax
  803adb:	00 00 00 
  803ade:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803ae0:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ae7:	00 00 00 
  803aea:	48 8b 00             	mov    (%rax),%rax
  803aed:	48 05 00 10 00 00    	add    $0x1000,%rax
  803af3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803af7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803afb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803b01:	48 89 c2             	mov    %rax,%rdx
  803b04:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b0b:	00 00 00 
  803b0e:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  803b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  803b18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b1c:	48 8d 50 04          	lea    0x4(%rax),%rdx
  803b20:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b27:	00 00 00 
  803b2a:	48 8b 00             	mov    (%rax),%rax
  803b2d:	48 89 d6             	mov    %rdx,%rsi
  803b30:	48 89 c7             	mov    %rax,%rdi
  803b33:	48 b8 ca 38 80 00 00 	movabs $0x8038ca,%rax
  803b3a:	00 00 00 
  803b3d:	ff d0                	callq  *%rax
  803b3f:	85 c0                	test   %eax,%eax
  803b41:	75 72                	jne    803bb5 <malloc+0x24d>
			break;
		mptr += PGSIZE;
  803b43:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b4a:	00 00 00 
  803b4d:	48 8b 00             	mov    (%rax),%rax
  803b50:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  803b57:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b5e:	00 00 00 
  803b61:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  803b64:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b6b:	00 00 00 
  803b6e:	48 8b 10             	mov    (%rax),%rdx
  803b71:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803b78:	00 00 00 
  803b7b:	48 8b 00             	mov    (%rax),%rax
  803b7e:	48 39 c2             	cmp    %rax,%rdx
  803b81:	75 95                	jne    803b18 <malloc+0x1b0>
			mptr = mbegin;
  803b83:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803b8a:	00 00 00 
  803b8d:	48 8b 10             	mov    (%rax),%rdx
  803b90:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b97:	00 00 00 
  803b9a:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  803b9d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  803ba1:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  803ba5:	0f 85 6d ff ff ff    	jne    803b18 <malloc+0x1b0>
				return 0;	/* out of address space */
  803bab:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb0:	e9 22 01 00 00       	jmpq   803cd7 <malloc+0x36f>
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
  803bb5:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bbd:	e9 a1 00 00 00       	jmpq   803c63 <malloc+0x2fb>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803bc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc5:	05 00 10 00 00       	add    $0x1000,%eax
  803bca:	48 98                	cltq   
  803bcc:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803bd0:	48 83 c2 04          	add    $0x4,%rdx
  803bd4:	48 39 d0             	cmp    %rdx,%rax
  803bd7:	73 07                	jae    803be0 <malloc+0x278>
  803bd9:	b8 00 04 00 00       	mov    $0x400,%eax
  803bde:	eb 05                	jmp    803be5 <malloc+0x27d>
  803be0:	b8 00 00 00 00       	mov    $0x0,%eax
  803be5:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803be8:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803beb:	83 c8 07             	or     $0x7,%eax
  803bee:	89 c2                	mov    %eax,%edx
  803bf0:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803bf7:	00 00 00 
  803bfa:	48 8b 08             	mov    (%rax),%rcx
  803bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c00:	48 98                	cltq   
  803c02:	48 01 c8             	add    %rcx,%rax
  803c05:	48 89 c6             	mov    %rax,%rsi
  803c08:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0d:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	79 3f                	jns    803c5c <malloc+0x2f4>
			for (; i >= 0; i -= PGSIZE)
  803c1d:	eb 30                	jmp    803c4f <malloc+0x2e7>
				sys_page_unmap(0, mptr + i);
  803c1f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c26:	00 00 00 
  803c29:	48 8b 10             	mov    (%rax),%rdx
  803c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c2f:	48 98                	cltq   
  803c31:	48 01 d0             	add    %rdx,%rax
  803c34:	48 89 c6             	mov    %rax,%rsi
  803c37:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3c:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  803c43:	00 00 00 
  803c46:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  803c48:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  803c4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c53:	79 ca                	jns    803c1f <malloc+0x2b7>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  803c55:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5a:	eb 7b                	jmp    803cd7 <malloc+0x36f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803c5c:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c66:	48 98                	cltq   
  803c68:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803c6c:	48 83 c2 04          	add    $0x4,%rdx
  803c70:	48 39 d0             	cmp    %rdx,%rax
  803c73:	0f 82 49 ff ff ff    	jb     803bc2 <malloc+0x25a>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  803c79:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c80:	00 00 00 
  803c83:	48 8b 00             	mov    (%rax),%rax
  803c86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c89:	48 63 d2             	movslq %edx,%rdx
  803c8c:	48 83 ea 04          	sub    $0x4,%rdx
  803c90:	48 01 d0             	add    %rdx,%rax
  803c93:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  803c97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c9b:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  803ca1:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ca8:	00 00 00 
  803cab:	48 8b 00             	mov    (%rax),%rax
  803cae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  803cb2:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803cb9:	00 00 00 
  803cbc:	48 8b 10             	mov    (%rax),%rdx
  803cbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cc3:	48 01 c2             	add    %rax,%rdx
  803cc6:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ccd:	00 00 00 
  803cd0:	48 89 10             	mov    %rdx,(%rax)
	return v;
  803cd3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  803cd7:	c9                   	leaveq 
  803cd8:	c3                   	retq   

0000000000803cd9 <free>:

void
free(void *v)
{
  803cd9:	55                   	push   %rbp
  803cda:	48 89 e5             	mov    %rsp,%rbp
  803cdd:	48 83 ec 30          	sub    $0x30,%rsp
  803ce1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  803ce5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cea:	0f 84 56 01 00 00    	je     803e46 <free+0x16d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  803cf0:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803cf7:	00 00 00 
  803cfa:	48 8b 00             	mov    (%rax),%rax
  803cfd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803d01:	77 13                	ja     803d16 <free+0x3d>
  803d03:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803d0a:	00 00 00 
  803d0d:	48 8b 00             	mov    (%rax),%rax
  803d10:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803d14:	72 35                	jb     803d4b <free+0x72>
  803d16:	48 b9 90 52 80 00 00 	movabs $0x805290,%rcx
  803d1d:	00 00 00 
  803d20:	48 ba be 52 80 00 00 	movabs $0x8052be,%rdx
  803d27:	00 00 00 
  803d2a:	be 7b 00 00 00       	mov    $0x7b,%esi
  803d2f:	48 bf d3 52 80 00 00 	movabs $0x8052d3,%rdi
  803d36:	00 00 00 
  803d39:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3e:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  803d45:	00 00 00 
  803d48:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  803d4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  803d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d57:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803d5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803d61:	eb 7b                	jmp    803dde <free+0x105>
		sys_page_unmap(0, c);
  803d63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d67:	48 89 c6             	mov    %rax,%rsi
  803d6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d6f:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
		c += PGSIZE;
  803d7b:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803d82:	00 
		assert(mbegin <= c && c < mend);
  803d83:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803d8a:	00 00 00 
  803d8d:	48 8b 00             	mov    (%rax),%rax
  803d90:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803d94:	77 13                	ja     803da9 <free+0xd0>
  803d96:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803d9d:	00 00 00 
  803da0:	48 8b 00             	mov    (%rax),%rax
  803da3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803da7:	72 35                	jb     803dde <free+0x105>
  803da9:	48 b9 e0 52 80 00 00 	movabs $0x8052e0,%rcx
  803db0:	00 00 00 
  803db3:	48 ba be 52 80 00 00 	movabs $0x8052be,%rdx
  803dba:	00 00 00 
  803dbd:	be 82 00 00 00       	mov    $0x82,%esi
  803dc2:	48 bf d3 52 80 00 00 	movabs $0x8052d3,%rdi
  803dc9:	00 00 00 
  803dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd1:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  803dd8:	00 00 00 
  803ddb:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de2:	48 c1 e8 0c          	shr    $0xc,%rax
  803de6:	48 89 c2             	mov    %rax,%rdx
  803de9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803df0:	01 00 00 
  803df3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803df7:	25 00 04 00 00       	and    $0x400,%eax
  803dfc:	48 85 c0             	test   %rax,%rax
  803dff:	0f 85 5e ff ff ff    	jne    803d63 <free+0x8a>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  803e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e09:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  803e0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  803e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e17:	8b 00                	mov    (%rax),%eax
  803e19:	8d 50 ff             	lea    -0x1(%rax),%edx
  803e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e20:	89 10                	mov    %edx,(%rax)
  803e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e26:	8b 00                	mov    (%rax),%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	75 1b                	jne    803e47 <free+0x16e>
		sys_page_unmap(0, c);
  803e2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e30:	48 89 c6             	mov    %rax,%rsi
  803e33:	bf 00 00 00 00       	mov    $0x0,%edi
  803e38:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  803e3f:	00 00 00 
  803e42:	ff d0                	callq  *%rax
  803e44:	eb 01                	jmp    803e47 <free+0x16e>
{
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
		return;
  803e46:	90                   	nop
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
		sys_page_unmap(0, c);
}
  803e47:	c9                   	leaveq 
  803e48:	c3                   	retq   

0000000000803e49 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e49:	55                   	push   %rbp
  803e4a:	48 89 e5             	mov    %rsp,%rbp
  803e4d:	53                   	push   %rbx
  803e4e:	48 83 ec 38          	sub    $0x38,%rsp
  803e52:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e56:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e5a:	48 89 c7             	mov    %rax,%rdi
  803e5d:	48 b8 d7 20 80 00 00 	movabs $0x8020d7,%rax
  803e64:	00 00 00 
  803e67:	ff d0                	callq  *%rax
  803e69:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e70:	0f 88 bf 01 00 00    	js     804035 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7a:	ba 07 04 00 00       	mov    $0x407,%edx
  803e7f:	48 89 c6             	mov    %rax,%rsi
  803e82:	bf 00 00 00 00       	mov    $0x0,%edi
  803e87:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  803e8e:	00 00 00 
  803e91:	ff d0                	callq  *%rax
  803e93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e9a:	0f 88 95 01 00 00    	js     804035 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803ea0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ea4:	48 89 c7             	mov    %rax,%rdi
  803ea7:	48 b8 d7 20 80 00 00 	movabs $0x8020d7,%rax
  803eae:	00 00 00 
  803eb1:	ff d0                	callq  *%rax
  803eb3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eb6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eba:	0f 88 5d 01 00 00    	js     80401d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ec0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ec9:	48 89 c6             	mov    %rax,%rsi
  803ecc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed1:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
  803edd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ee0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ee4:	0f 88 33 01 00 00    	js     80401d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eee:	48 89 c7             	mov    %rax,%rdi
  803ef1:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  803ef8:	00 00 00 
  803efb:	ff d0                	callq  *%rax
  803efd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f05:	ba 07 04 00 00       	mov    $0x407,%edx
  803f0a:	48 89 c6             	mov    %rax,%rsi
  803f0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803f12:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  803f19:	00 00 00 
  803f1c:	ff d0                	callq  *%rax
  803f1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f25:	0f 88 d9 00 00 00    	js     804004 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f2f:	48 89 c7             	mov    %rax,%rdi
  803f32:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  803f39:	00 00 00 
  803f3c:	ff d0                	callq  *%rax
  803f3e:	48 89 c2             	mov    %rax,%rdx
  803f41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f45:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f4b:	48 89 d1             	mov    %rdx,%rcx
  803f4e:	ba 00 00 00 00       	mov    $0x0,%edx
  803f53:	48 89 c6             	mov    %rax,%rsi
  803f56:	bf 00 00 00 00       	mov    $0x0,%edi
  803f5b:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  803f62:	00 00 00 
  803f65:	ff d0                	callq  *%rax
  803f67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f6e:	78 79                	js     803fe9 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f74:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  803f7b:	00 00 00 
  803f7e:	8b 12                	mov    (%rdx),%edx
  803f80:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f91:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  803f98:	00 00 00 
  803f9b:	8b 12                	mov    (%rdx),%edx
  803f9d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fa3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803faa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fae:	48 89 c7             	mov    %rax,%rdi
  803fb1:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  803fb8:	00 00 00 
  803fbb:	ff d0                	callq  *%rax
  803fbd:	89 c2                	mov    %eax,%edx
  803fbf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fc3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803fc5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fc9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd1:	48 89 c7             	mov    %rax,%rdi
  803fd4:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  803fdb:	00 00 00 
  803fde:	ff d0                	callq  *%rax
  803fe0:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe7:	eb 4f                	jmp    804038 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803fe9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803fea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fee:	48 89 c6             	mov    %rax,%rsi
  803ff1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff6:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  803ffd:	00 00 00 
  804000:	ff d0                	callq  *%rax
  804002:	eb 01                	jmp    804005 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804004:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804005:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804009:	48 89 c6             	mov    %rax,%rsi
  80400c:	bf 00 00 00 00       	mov    $0x0,%edi
  804011:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  804018:	00 00 00 
  80401b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80401d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804021:	48 89 c6             	mov    %rax,%rsi
  804024:	bf 00 00 00 00       	mov    $0x0,%edi
  804029:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  804030:	00 00 00 
  804033:	ff d0                	callq  *%rax
err:
	return r;
  804035:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804038:	48 83 c4 38          	add    $0x38,%rsp
  80403c:	5b                   	pop    %rbx
  80403d:	5d                   	pop    %rbp
  80403e:	c3                   	retq   

000000000080403f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80403f:	55                   	push   %rbp
  804040:	48 89 e5             	mov    %rsp,%rbp
  804043:	53                   	push   %rbx
  804044:	48 83 ec 28          	sub    $0x28,%rsp
  804048:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80404c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804050:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  804057:	00 00 00 
  80405a:	48 8b 00             	mov    (%rax),%rax
  80405d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804063:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804066:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80406a:	48 89 c7             	mov    %rax,%rdi
  80406d:	48 b8 8a 4a 80 00 00 	movabs $0x804a8a,%rax
  804074:	00 00 00 
  804077:	ff d0                	callq  *%rax
  804079:	89 c3                	mov    %eax,%ebx
  80407b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80407f:	48 89 c7             	mov    %rax,%rdi
  804082:	48 b8 8a 4a 80 00 00 	movabs $0x804a8a,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
  80408e:	39 c3                	cmp    %eax,%ebx
  804090:	0f 94 c0             	sete   %al
  804093:	0f b6 c0             	movzbl %al,%eax
  804096:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804099:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8040a0:	00 00 00 
  8040a3:	48 8b 00             	mov    (%rax),%rax
  8040a6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040ac:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040b2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040b5:	75 05                	jne    8040bc <_pipeisclosed+0x7d>
			return ret;
  8040b7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040ba:	eb 4a                	jmp    804106 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8040bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040bf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040c2:	74 8c                	je     804050 <_pipeisclosed+0x11>
  8040c4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8040c8:	75 86                	jne    804050 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8040ca:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8040d1:	00 00 00 
  8040d4:	48 8b 00             	mov    (%rax),%rax
  8040d7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040dd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040e3:	89 c6                	mov    %eax,%esi
  8040e5:	48 bf fd 52 80 00 00 	movabs $0x8052fd,%rdi
  8040ec:	00 00 00 
  8040ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f4:	49 b8 c7 07 80 00 00 	movabs $0x8007c7,%r8
  8040fb:	00 00 00 
  8040fe:	41 ff d0             	callq  *%r8
	}
  804101:	e9 4a ff ff ff       	jmpq   804050 <_pipeisclosed+0x11>

}
  804106:	48 83 c4 28          	add    $0x28,%rsp
  80410a:	5b                   	pop    %rbx
  80410b:	5d                   	pop    %rbp
  80410c:	c3                   	retq   

000000000080410d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80410d:	55                   	push   %rbp
  80410e:	48 89 e5             	mov    %rsp,%rbp
  804111:	48 83 ec 30          	sub    $0x30,%rsp
  804115:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804118:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80411c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80411f:	48 89 d6             	mov    %rdx,%rsi
  804122:	89 c7                	mov    %eax,%edi
  804124:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80412b:	00 00 00 
  80412e:	ff d0                	callq  *%rax
  804130:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804137:	79 05                	jns    80413e <pipeisclosed+0x31>
		return r;
  804139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413c:	eb 31                	jmp    80416f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80413e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804142:	48 89 c7             	mov    %rax,%rdi
  804145:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80414c:	00 00 00 
  80414f:	ff d0                	callq  *%rax
  804151:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804159:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80415d:	48 89 d6             	mov    %rdx,%rsi
  804160:	48 89 c7             	mov    %rax,%rdi
  804163:	48 b8 3f 40 80 00 00 	movabs $0x80403f,%rax
  80416a:	00 00 00 
  80416d:	ff d0                	callq  *%rax
}
  80416f:	c9                   	leaveq 
  804170:	c3                   	retq   

0000000000804171 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804171:	55                   	push   %rbp
  804172:	48 89 e5             	mov    %rsp,%rbp
  804175:	48 83 ec 40          	sub    $0x40,%rsp
  804179:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80417d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804181:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804189:	48 89 c7             	mov    %rax,%rdi
  80418c:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804193:	00 00 00 
  804196:	ff d0                	callq  *%rax
  804198:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80419c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041a4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041ab:	00 
  8041ac:	e9 90 00 00 00       	jmpq   804241 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041b1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041b6:	74 09                	je     8041c1 <devpipe_read+0x50>
				return i;
  8041b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bc:	e9 8e 00 00 00       	jmpq   80424f <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8041c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041c9:	48 89 d6             	mov    %rdx,%rsi
  8041cc:	48 89 c7             	mov    %rax,%rdi
  8041cf:	48 b8 3f 40 80 00 00 	movabs $0x80403f,%rax
  8041d6:	00 00 00 
  8041d9:	ff d0                	callq  *%rax
  8041db:	85 c0                	test   %eax,%eax
  8041dd:	74 07                	je     8041e6 <devpipe_read+0x75>
				return 0;
  8041df:	b8 00 00 00 00       	mov    $0x0,%eax
  8041e4:	eb 69                	jmp    80424f <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041e6:	48 b8 50 1c 80 00 00 	movabs $0x801c50,%rax
  8041ed:	00 00 00 
  8041f0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f6:	8b 10                	mov    (%rax),%edx
  8041f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fc:	8b 40 04             	mov    0x4(%rax),%eax
  8041ff:	39 c2                	cmp    %eax,%edx
  804201:	74 ae                	je     8041b1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804203:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80420f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804213:	8b 00                	mov    (%rax),%eax
  804215:	99                   	cltd   
  804216:	c1 ea 1b             	shr    $0x1b,%edx
  804219:	01 d0                	add    %edx,%eax
  80421b:	83 e0 1f             	and    $0x1f,%eax
  80421e:	29 d0                	sub    %edx,%eax
  804220:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804224:	48 98                	cltq   
  804226:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80422b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80422d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804231:	8b 00                	mov    (%rax),%eax
  804233:	8d 50 01             	lea    0x1(%rax),%edx
  804236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80423c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804245:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804249:	72 a7                	jb     8041f2 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80424b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80424f:	c9                   	leaveq 
  804250:	c3                   	retq   

0000000000804251 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804251:	55                   	push   %rbp
  804252:	48 89 e5             	mov    %rsp,%rbp
  804255:	48 83 ec 40          	sub    $0x40,%rsp
  804259:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80425d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804261:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804265:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804269:	48 89 c7             	mov    %rax,%rdi
  80426c:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804273:	00 00 00 
  804276:	ff d0                	callq  *%rax
  804278:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80427c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804280:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804284:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80428b:	00 
  80428c:	e9 8f 00 00 00       	jmpq   804320 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804291:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804299:	48 89 d6             	mov    %rdx,%rsi
  80429c:	48 89 c7             	mov    %rax,%rdi
  80429f:	48 b8 3f 40 80 00 00 	movabs $0x80403f,%rax
  8042a6:	00 00 00 
  8042a9:	ff d0                	callq  *%rax
  8042ab:	85 c0                	test   %eax,%eax
  8042ad:	74 07                	je     8042b6 <devpipe_write+0x65>
				return 0;
  8042af:	b8 00 00 00 00       	mov    $0x0,%eax
  8042b4:	eb 78                	jmp    80432e <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8042b6:	48 b8 50 1c 80 00 00 	movabs $0x801c50,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c6:	8b 40 04             	mov    0x4(%rax),%eax
  8042c9:	48 63 d0             	movslq %eax,%rdx
  8042cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d0:	8b 00                	mov    (%rax),%eax
  8042d2:	48 98                	cltq   
  8042d4:	48 83 c0 20          	add    $0x20,%rax
  8042d8:	48 39 c2             	cmp    %rax,%rdx
  8042db:	73 b4                	jae    804291 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e1:	8b 40 04             	mov    0x4(%rax),%eax
  8042e4:	99                   	cltd   
  8042e5:	c1 ea 1b             	shr    $0x1b,%edx
  8042e8:	01 d0                	add    %edx,%eax
  8042ea:	83 e0 1f             	and    $0x1f,%eax
  8042ed:	29 d0                	sub    %edx,%eax
  8042ef:	89 c6                	mov    %eax,%esi
  8042f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f9:	48 01 d0             	add    %rdx,%rax
  8042fc:	0f b6 08             	movzbl (%rax),%ecx
  8042ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804303:	48 63 c6             	movslq %esi,%rax
  804306:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80430a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80430e:	8b 40 04             	mov    0x4(%rax),%eax
  804311:	8d 50 01             	lea    0x1(%rax),%edx
  804314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804318:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80431b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804324:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804328:	72 98                	jb     8042c2 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80432a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80432e:	c9                   	leaveq 
  80432f:	c3                   	retq   

0000000000804330 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804330:	55                   	push   %rbp
  804331:	48 89 e5             	mov    %rsp,%rbp
  804334:	48 83 ec 20          	sub    $0x20,%rsp
  804338:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80433c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804344:	48 89 c7             	mov    %rax,%rdi
  804347:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80434e:	00 00 00 
  804351:	ff d0                	callq  *%rax
  804353:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80435b:	48 be 10 53 80 00 00 	movabs $0x805310,%rsi
  804362:	00 00 00 
  804365:	48 89 c7             	mov    %rax,%rdi
  804368:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  80436f:	00 00 00 
  804372:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804378:	8b 50 04             	mov    0x4(%rax),%edx
  80437b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80437f:	8b 00                	mov    (%rax),%eax
  804381:	29 c2                	sub    %eax,%edx
  804383:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804387:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80438d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804391:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804398:	00 00 00 
	stat->st_dev = &devpipe;
  80439b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80439f:	48 b9 00 71 80 00 00 	movabs $0x807100,%rcx
  8043a6:	00 00 00 
  8043a9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8043b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043b5:	c9                   	leaveq 
  8043b6:	c3                   	retq   

00000000008043b7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8043b7:	55                   	push   %rbp
  8043b8:	48 89 e5             	mov    %rsp,%rbp
  8043bb:	48 83 ec 10          	sub    $0x10,%rsp
  8043bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8043c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c7:	48 89 c6             	mov    %rax,%rsi
  8043ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cf:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8043db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043df:	48 89 c7             	mov    %rax,%rdi
  8043e2:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8043e9:	00 00 00 
  8043ec:	ff d0                	callq  *%rax
  8043ee:	48 89 c6             	mov    %rax,%rsi
  8043f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8043f6:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  8043fd:	00 00 00 
  804400:	ff d0                	callq  *%rax
}
  804402:	c9                   	leaveq 
  804403:	c3                   	retq   

0000000000804404 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804404:	55                   	push   %rbp
  804405:	48 89 e5             	mov    %rsp,%rbp
  804408:	48 83 ec 20          	sub    $0x20,%rsp
  80440c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80440f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804413:	75 35                	jne    80444a <wait+0x46>
  804415:	48 b9 17 53 80 00 00 	movabs $0x805317,%rcx
  80441c:	00 00 00 
  80441f:	48 ba 22 53 80 00 00 	movabs $0x805322,%rdx
  804426:	00 00 00 
  804429:	be 0a 00 00 00       	mov    $0xa,%esi
  80442e:	48 bf 37 53 80 00 00 	movabs $0x805337,%rdi
  804435:	00 00 00 
  804438:	b8 00 00 00 00       	mov    $0x0,%eax
  80443d:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  804444:	00 00 00 
  804447:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80444a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80444d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804452:	48 98                	cltq   
  804454:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80445b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804462:	00 00 00 
  804465:	48 01 d0             	add    %rdx,%rax
  804468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80446c:	eb 0c                	jmp    80447a <wait+0x76>
		sys_yield();
  80446e:	48 b8 50 1c 80 00 00 	movabs $0x801c50,%rax
  804475:	00 00 00 
  804478:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80447a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80447e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804484:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804487:	75 0e                	jne    804497 <wait+0x93>
  804489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804493:	85 c0                	test   %eax,%eax
  804495:	75 d7                	jne    80446e <wait+0x6a>
		sys_yield();
}
  804497:	90                   	nop
  804498:	c9                   	leaveq 
  804499:	c3                   	retq   

000000000080449a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80449a:	55                   	push   %rbp
  80449b:	48 89 e5             	mov    %rsp,%rbp
  80449e:	48 83 ec 20          	sub    $0x20,%rsp
  8044a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8044a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044a8:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8044ab:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8044af:	be 01 00 00 00       	mov    $0x1,%esi
  8044b4:	48 89 c7             	mov    %rax,%rdi
  8044b7:	48 b8 45 1b 80 00 00 	movabs $0x801b45,%rax
  8044be:	00 00 00 
  8044c1:	ff d0                	callq  *%rax
}
  8044c3:	90                   	nop
  8044c4:	c9                   	leaveq 
  8044c5:	c3                   	retq   

00000000008044c6 <getchar>:

int
getchar(void)
{
  8044c6:	55                   	push   %rbp
  8044c7:	48 89 e5             	mov    %rsp,%rbp
  8044ca:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8044ce:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8044d2:	ba 01 00 00 00       	mov    $0x1,%edx
  8044d7:	48 89 c6             	mov    %rax,%rsi
  8044da:	bf 00 00 00 00       	mov    $0x0,%edi
  8044df:	48 b8 a4 25 80 00 00 	movabs $0x8025a4,%rax
  8044e6:	00 00 00 
  8044e9:	ff d0                	callq  *%rax
  8044eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8044ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044f2:	79 05                	jns    8044f9 <getchar+0x33>
		return r;
  8044f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f7:	eb 14                	jmp    80450d <getchar+0x47>
	if (r < 1)
  8044f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044fd:	7f 07                	jg     804506 <getchar+0x40>
		return -E_EOF;
  8044ff:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804504:	eb 07                	jmp    80450d <getchar+0x47>
	return c;
  804506:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80450a:	0f b6 c0             	movzbl %al,%eax

}
  80450d:	c9                   	leaveq 
  80450e:	c3                   	retq   

000000000080450f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80450f:	55                   	push   %rbp
  804510:	48 89 e5             	mov    %rsp,%rbp
  804513:	48 83 ec 20          	sub    $0x20,%rsp
  804517:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80451a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80451e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804521:	48 89 d6             	mov    %rdx,%rsi
  804524:	89 c7                	mov    %eax,%edi
  804526:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80452d:	00 00 00 
  804530:	ff d0                	callq  *%rax
  804532:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804535:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804539:	79 05                	jns    804540 <iscons+0x31>
		return r;
  80453b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80453e:	eb 1a                	jmp    80455a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804544:	8b 10                	mov    (%rax),%edx
  804546:	48 b8 40 71 80 00 00 	movabs $0x807140,%rax
  80454d:	00 00 00 
  804550:	8b 00                	mov    (%rax),%eax
  804552:	39 c2                	cmp    %eax,%edx
  804554:	0f 94 c0             	sete   %al
  804557:	0f b6 c0             	movzbl %al,%eax
}
  80455a:	c9                   	leaveq 
  80455b:	c3                   	retq   

000000000080455c <opencons>:

int
opencons(void)
{
  80455c:	55                   	push   %rbp
  80455d:	48 89 e5             	mov    %rsp,%rbp
  804560:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804564:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804568:	48 89 c7             	mov    %rax,%rdi
  80456b:	48 b8 d7 20 80 00 00 	movabs $0x8020d7,%rax
  804572:	00 00 00 
  804575:	ff d0                	callq  *%rax
  804577:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80457a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80457e:	79 05                	jns    804585 <opencons+0x29>
		return r;
  804580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804583:	eb 5b                	jmp    8045e0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804589:	ba 07 04 00 00       	mov    $0x407,%edx
  80458e:	48 89 c6             	mov    %rax,%rsi
  804591:	bf 00 00 00 00       	mov    $0x0,%edi
  804596:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  80459d:	00 00 00 
  8045a0:	ff d0                	callq  *%rax
  8045a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a9:	79 05                	jns    8045b0 <opencons+0x54>
		return r;
  8045ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ae:	eb 30                	jmp    8045e0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8045b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b4:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  8045bb:	00 00 00 
  8045be:	8b 12                	mov    (%rdx),%edx
  8045c0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8045c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8045cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045d1:	48 89 c7             	mov    %rax,%rdi
  8045d4:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  8045db:	00 00 00 
  8045de:	ff d0                	callq  *%rax
}
  8045e0:	c9                   	leaveq 
  8045e1:	c3                   	retq   

00000000008045e2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045e2:	55                   	push   %rbp
  8045e3:	48 89 e5             	mov    %rsp,%rbp
  8045e6:	48 83 ec 30          	sub    $0x30,%rsp
  8045ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045fb:	75 13                	jne    804610 <devcons_read+0x2e>
		return 0;
  8045fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804602:	eb 49                	jmp    80464d <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804604:	48 b8 50 1c 80 00 00 	movabs $0x801c50,%rax
  80460b:	00 00 00 
  80460e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804610:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  804617:	00 00 00 
  80461a:	ff d0                	callq  *%rax
  80461c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80461f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804623:	74 df                	je     804604 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804629:	79 05                	jns    804630 <devcons_read+0x4e>
		return c;
  80462b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462e:	eb 1d                	jmp    80464d <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804630:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804634:	75 07                	jne    80463d <devcons_read+0x5b>
		return 0;
  804636:	b8 00 00 00 00       	mov    $0x0,%eax
  80463b:	eb 10                	jmp    80464d <devcons_read+0x6b>
	*(char*)vbuf = c;
  80463d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804640:	89 c2                	mov    %eax,%edx
  804642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804646:	88 10                	mov    %dl,(%rax)
	return 1;
  804648:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80464d:	c9                   	leaveq 
  80464e:	c3                   	retq   

000000000080464f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80464f:	55                   	push   %rbp
  804650:	48 89 e5             	mov    %rsp,%rbp
  804653:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80465a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804661:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804668:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80466f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804676:	eb 76                	jmp    8046ee <devcons_write+0x9f>
		m = n - tot;
  804678:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80467f:	89 c2                	mov    %eax,%edx
  804681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804684:	29 c2                	sub    %eax,%edx
  804686:	89 d0                	mov    %edx,%eax
  804688:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80468b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80468e:	83 f8 7f             	cmp    $0x7f,%eax
  804691:	76 07                	jbe    80469a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804693:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80469a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80469d:	48 63 d0             	movslq %eax,%rdx
  8046a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a3:	48 63 c8             	movslq %eax,%rcx
  8046a6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8046ad:	48 01 c1             	add    %rax,%rcx
  8046b0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046b7:	48 89 ce             	mov    %rcx,%rsi
  8046ba:	48 89 c7             	mov    %rax,%rdi
  8046bd:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  8046c4:	00 00 00 
  8046c7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8046c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046cc:	48 63 d0             	movslq %eax,%rdx
  8046cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046d6:	48 89 d6             	mov    %rdx,%rsi
  8046d9:	48 89 c7             	mov    %rax,%rdi
  8046dc:	48 b8 45 1b 80 00 00 	movabs $0x801b45,%rax
  8046e3:	00 00 00 
  8046e6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046eb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8046ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f1:	48 98                	cltq   
  8046f3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046fa:	0f 82 78 ff ff ff    	jb     804678 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804700:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804703:	c9                   	leaveq 
  804704:	c3                   	retq   

0000000000804705 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804705:	55                   	push   %rbp
  804706:	48 89 e5             	mov    %rsp,%rbp
  804709:	48 83 ec 08          	sub    $0x8,%rsp
  80470d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804716:	c9                   	leaveq 
  804717:	c3                   	retq   

0000000000804718 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804718:	55                   	push   %rbp
  804719:	48 89 e5             	mov    %rsp,%rbp
  80471c:	48 83 ec 10          	sub    $0x10,%rsp
  804720:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804724:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472c:	48 be 47 53 80 00 00 	movabs $0x805347,%rsi
  804733:	00 00 00 
  804736:	48 89 c7             	mov    %rax,%rdi
  804739:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  804740:	00 00 00 
  804743:	ff d0                	callq  *%rax
	return 0;
  804745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80474a:	c9                   	leaveq 
  80474b:	c3                   	retq   

000000000080474c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80474c:	55                   	push   %rbp
  80474d:	48 89 e5             	mov    %rsp,%rbp
  804750:	48 83 ec 30          	sub    $0x30,%rsp
  804754:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80475c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804760:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804765:	75 0e                	jne    804775 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804767:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80476e:	00 00 00 
  804771:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804779:	48 89 c7             	mov    %rax,%rdi
  80477c:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  804783:	00 00 00 
  804786:	ff d0                	callq  *%rax
  804788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80478b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80478f:	79 27                	jns    8047b8 <ipc_recv+0x6c>
		if (from_env_store)
  804791:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804796:	74 0a                	je     8047a2 <ipc_recv+0x56>
			*from_env_store = 0;
  804798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80479c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8047a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047a7:	74 0a                	je     8047b3 <ipc_recv+0x67>
			*perm_store = 0;
  8047a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8047b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b6:	eb 53                	jmp    80480b <ipc_recv+0xbf>
	}
	if (from_env_store)
  8047b8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047bd:	74 19                	je     8047d8 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8047bf:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8047c6:	00 00 00 
  8047c9:	48 8b 00             	mov    (%rax),%rax
  8047cc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8047d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d6:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8047d8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047dd:	74 19                	je     8047f8 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8047df:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8047e6:	00 00 00 
  8047e9:	48 8b 00             	mov    (%rax),%rax
  8047ec:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8047f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f6:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8047f8:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8047ff:	00 00 00 
  804802:	48 8b 00             	mov    (%rax),%rax
  804805:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80480b:	c9                   	leaveq 
  80480c:	c3                   	retq   

000000000080480d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80480d:	55                   	push   %rbp
  80480e:	48 89 e5             	mov    %rsp,%rbp
  804811:	48 83 ec 30          	sub    $0x30,%rsp
  804815:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804818:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80481b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80481f:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804822:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804827:	75 1c                	jne    804845 <ipc_send+0x38>
		pg = (void*) UTOP;
  804829:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804830:	00 00 00 
  804833:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804837:	eb 0c                	jmp    804845 <ipc_send+0x38>
		sys_yield();
  804839:	48 b8 50 1c 80 00 00 	movabs $0x801c50,%rax
  804840:	00 00 00 
  804843:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804845:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804848:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80484b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80484f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804852:	89 c7                	mov    %eax,%edi
  804854:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  80485b:	00 00 00 
  80485e:	ff d0                	callq  *%rax
  804860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804863:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804867:	74 d0                	je     804839 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80486d:	79 30                	jns    80489f <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80486f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804872:	89 c1                	mov    %eax,%ecx
  804874:	48 ba 4e 53 80 00 00 	movabs $0x80534e,%rdx
  80487b:	00 00 00 
  80487e:	be 47 00 00 00       	mov    $0x47,%esi
  804883:	48 bf 64 53 80 00 00 	movabs $0x805364,%rdi
  80488a:	00 00 00 
  80488d:	b8 00 00 00 00       	mov    $0x0,%eax
  804892:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  804899:	00 00 00 
  80489c:	41 ff d0             	callq  *%r8

}
  80489f:	90                   	nop
  8048a0:	c9                   	leaveq 
  8048a1:	c3                   	retq   

00000000008048a2 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8048a2:	55                   	push   %rbp
  8048a3:	48 89 e5             	mov    %rsp,%rbp
  8048a6:	53                   	push   %rbx
  8048a7:	48 83 ec 28          	sub    $0x28,%rsp
  8048ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8048af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8048b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8048bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048c2:	75 0e                	jne    8048d2 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8048c4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048cb:	00 00 00 
  8048ce:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8048d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048d6:	ba 07 00 00 00       	mov    $0x7,%edx
  8048db:	48 89 c6             	mov    %rax,%rsi
  8048de:	bf 00 00 00 00       	mov    $0x0,%edi
  8048e3:	48 b8 8d 1c 80 00 00 	movabs $0x801c8d,%rax
  8048ea:	00 00 00 
  8048ed:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8048ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8048f7:	48 89 c2             	mov    %rax,%rdx
  8048fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804901:	01 00 00 
  804904:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804908:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80490e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804912:	b8 03 00 00 00       	mov    $0x3,%eax
  804917:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80491b:	48 89 d3             	mov    %rdx,%rbx
  80491e:	0f 01 c1             	vmcall 
  804921:	89 f2                	mov    %esi,%edx
  804923:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804926:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804929:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80492d:	79 05                	jns    804934 <ipc_host_recv+0x92>
		return r;
  80492f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804932:	eb 03                	jmp    804937 <ipc_host_recv+0x95>
	}
	return val;
  804934:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804937:	48 83 c4 28          	add    $0x28,%rsp
  80493b:	5b                   	pop    %rbx
  80493c:	5d                   	pop    %rbp
  80493d:	c3                   	retq   

000000000080493e <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80493e:	55                   	push   %rbp
  80493f:	48 89 e5             	mov    %rsp,%rbp
  804942:	53                   	push   %rbx
  804943:	48 83 ec 38          	sub    $0x38,%rsp
  804947:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80494a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80494d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804951:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804954:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80495b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804960:	75 0e                	jne    804970 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804962:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804969:	00 00 00 
  80496c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804970:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804974:	48 c1 e8 0c          	shr    $0xc,%rax
  804978:	48 89 c2             	mov    %rax,%rdx
  80497b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804982:	01 00 00 
  804985:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804989:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80498f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804993:	b8 02 00 00 00       	mov    $0x2,%eax
  804998:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80499b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80499e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049a2:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8049a5:	89 fb                	mov    %edi,%ebx
  8049a7:	0f 01 c1             	vmcall 
  8049aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8049ad:	eb 26                	jmp    8049d5 <ipc_host_send+0x97>
		sys_yield();
  8049af:	48 b8 50 1c 80 00 00 	movabs $0x801c50,%rax
  8049b6:	00 00 00 
  8049b9:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8049bb:	b8 02 00 00 00       	mov    $0x2,%eax
  8049c0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049c3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8049c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049ca:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8049cd:	89 fb                	mov    %edi,%ebx
  8049cf:	0f 01 c1             	vmcall 
  8049d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8049d5:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8049d9:	74 d4                	je     8049af <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8049db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8049df:	79 30                	jns    804a11 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8049e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049e4:	89 c1                	mov    %eax,%ecx
  8049e6:	48 ba 4e 53 80 00 00 	movabs $0x80534e,%rdx
  8049ed:	00 00 00 
  8049f0:	be 79 00 00 00       	mov    $0x79,%esi
  8049f5:	48 bf 64 53 80 00 00 	movabs $0x805364,%rdi
  8049fc:	00 00 00 
  8049ff:	b8 00 00 00 00       	mov    $0x0,%eax
  804a04:	49 b8 8d 05 80 00 00 	movabs $0x80058d,%r8
  804a0b:	00 00 00 
  804a0e:	41 ff d0             	callq  *%r8

}
  804a11:	90                   	nop
  804a12:	48 83 c4 38          	add    $0x38,%rsp
  804a16:	5b                   	pop    %rbx
  804a17:	5d                   	pop    %rbp
  804a18:	c3                   	retq   

0000000000804a19 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a19:	55                   	push   %rbp
  804a1a:	48 89 e5             	mov    %rsp,%rbp
  804a1d:	48 83 ec 18          	sub    $0x18,%rsp
  804a21:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a2b:	eb 4d                	jmp    804a7a <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804a2d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a34:	00 00 00 
  804a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a3a:	48 98                	cltq   
  804a3c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a43:	48 01 d0             	add    %rdx,%rax
  804a46:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a4c:	8b 00                	mov    (%rax),%eax
  804a4e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a51:	75 23                	jne    804a76 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804a53:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a5a:	00 00 00 
  804a5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a60:	48 98                	cltq   
  804a62:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a69:	48 01 d0             	add    %rdx,%rax
  804a6c:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804a72:	8b 00                	mov    (%rax),%eax
  804a74:	eb 12                	jmp    804a88 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804a76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a7a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a81:	7e aa                	jle    804a2d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a88:	c9                   	leaveq 
  804a89:	c3                   	retq   

0000000000804a8a <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804a8a:	55                   	push   %rbp
  804a8b:	48 89 e5             	mov    %rsp,%rbp
  804a8e:	48 83 ec 18          	sub    $0x18,%rsp
  804a92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a9a:	48 c1 e8 15          	shr    $0x15,%rax
  804a9e:	48 89 c2             	mov    %rax,%rdx
  804aa1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804aa8:	01 00 00 
  804aab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804aaf:	83 e0 01             	and    $0x1,%eax
  804ab2:	48 85 c0             	test   %rax,%rax
  804ab5:	75 07                	jne    804abe <pageref+0x34>
		return 0;
  804ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  804abc:	eb 56                	jmp    804b14 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ac2:	48 c1 e8 0c          	shr    $0xc,%rax
  804ac6:	48 89 c2             	mov    %rax,%rdx
  804ac9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ad0:	01 00 00 
  804ad3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ad7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804adb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804adf:	83 e0 01             	and    $0x1,%eax
  804ae2:	48 85 c0             	test   %rax,%rax
  804ae5:	75 07                	jne    804aee <pageref+0x64>
		return 0;
  804ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  804aec:	eb 26                	jmp    804b14 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804af2:	48 c1 e8 0c          	shr    $0xc,%rax
  804af6:	48 89 c2             	mov    %rax,%rdx
  804af9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b00:	00 00 00 
  804b03:	48 c1 e2 04          	shl    $0x4,%rdx
  804b07:	48 01 d0             	add    %rdx,%rax
  804b0a:	48 83 c0 08          	add    $0x8,%rax
  804b0e:	0f b7 00             	movzwl (%rax),%eax
  804b11:	0f b7 c0             	movzwl %ax,%eax
}
  804b14:	c9                   	leaveq 
  804b15:	c3                   	retq   
