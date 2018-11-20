
obj/user/vmm:     file format elf64-x86-64


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
  80003c:	e8 83 05 00 00       	callq  8005c4 <libmain>
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
  800073:	48 b8 9e 29 80 00 00 	movabs $0x80299e,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 0a                	jns    80008d <map_in_guest+0x4a>
		return -E_NO_SYS;
  800083:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  800088:	e9 e1 00 00 00       	jmpq   80016e <map_in_guest+0x12b>
	
	host_env_id = sys_getenvid();
  80008d:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 ec             	mov    %eax,-0x14(%rbp)

	for (i = 0; i < filesz; i += PGSIZE) {
  80009c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8000a3:	00 
  8000a4:	e9 b2 00 00 00       	jmpq   80015b <map_in_guest+0x118>
		if ((hva = malloc(PGSIZE)) == 0)
  8000a9:	bf 00 10 00 00       	mov    $0x1000,%edi
  8000ae:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
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
  8000e0:	48 b8 7f 27 80 00 00 	movabs $0x80277f,%rax
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
  800139:	48 b8 bc 20 80 00 00 	movabs $0x8020bc,%rax
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
  8001a3:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	callq  *%rax
  8001af:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8001b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8001b6:	79 2d                	jns    8001e5 <copy_guest_kern_gpa+0x75>
		cprintf("open %s for read: %e\n", fname, fd );
  8001b8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8001bb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8001bf:	48 89 c6             	mov    %rax,%rsi
  8001c2:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  8001c9:	00 00 00 
  8001cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d1:	48 b9 a6 08 80 00 00 	movabs $0x8008a6,%rcx
  8001d8:	00 00 00 
  8001db:	ff d1                	callq  *%rcx
		return fd;
  8001dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001e0:	e9 69 01 00 00       	jmpq   80034e <copy_guest_kern_gpa+0x1de>
	}
	
	if ((binary = malloc(1024)) == 0)
  8001e5:	bf 00 04 00 00       	mov    $0x400,%edi
  8001ea:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
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
  80021c:	48 b8 7f 27 80 00 00 	movabs $0x80277f,%rax
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
  8002ee:	48 bf 96 4b 80 00 00 	movabs $0x804b96,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
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
  80031f:	48 ba a9 4b 80 00 00 	movabs $0x804ba9,%rdx
  800326:	00 00 00 
  800329:	be 59 00 00 00       	mov    $0x59,%esi
  80032e:	48 bf b8 4b 80 00 00 	movabs $0x804bb8,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	48 b9 6c 06 80 00 00 	movabs $0x80066c,%rcx
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
  800354:	48 83 ec 60          	sub    $0x60,%rsp
  800358:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80035b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ * 10, JOS_ENTRY )) < 0) {
  80035f:	be 00 70 00 00       	mov    $0x7000,%esi
  800364:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800369:	48 b8 1c 21 80 00 00 	movabs $0x80211c,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
  800375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037c:	79 2c                	jns    8003aa <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  80037e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800381:	89 c6                	mov    %eax,%esi
  800383:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  80038a:	00 00 00 
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  800399:	00 00 00 
  80039c:	ff d2                	callq  *%rdx
		exit();
  80039e:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
	}
	guest = ret;
  8003aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
    // Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  8003b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003b3:	48 be eb 4b 80 00 00 	movabs $0x804beb,%rsi
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
  8003d9:	48 bf f8 4b 80 00 00 	movabs $0x804bf8,%rdi
  8003e0:	00 00 00 
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  8003ef:	00 00 00 
  8003f2:	ff d2                	callq  *%rdx
		exit();
  8003f4:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	callq  *%rax
	}
	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  800400:	be 00 00 00 00       	mov    $0x0,%esi
  800405:	48 bf 21 4c 80 00 00 	movabs $0x804c21,%rdi
  80040c:	00 00 00 
  80040f:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80041e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800422:	79 36                	jns    80045a <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  800424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	48 be 21 4c 80 00 00 	movabs $0x804c21,%rsi
  800430:	00 00 00 
  800433:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  80043a:	00 00 00 
  80043d:	b8 00 00 00 00       	mov    $0x0,%eax
  800442:	48 b9 a6 08 80 00 00 	movabs $0x8008a6,%rcx
  800449:	00 00 00 
  80044c:	ff d1                	callq  *%rcx
		exit();
  80044e:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
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
  800494:	48 bf 30 4c 80 00 00 	movabs $0x804c30,%rdi
  80049b:	00 00 00 
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  8004aa:	00 00 00 
  8004ad:	ff d2                	callq  *%rdx
		exit();
  8004af:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  8004b6:	00 00 00 
  8004b9:	ff d0                	callq  *%rax
	}
    
#ifndef VMM_GUEST	
	sys_vmx_incr_vmdisk_number();	//increase the vmdisk number
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	48 ba 27 22 80 00 00 	movabs $0x802227,%rdx
  8004c7:	00 00 00 
  8004ca:	ff d2                	callq  *%rdx
	//create a new guest disk image

	vmdisk_number = sys_vmx_get_vmdisk_number();
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	48 ba eb 21 80 00 00 	movabs $0x8021eb,%rdx
  8004d8:	00 00 00 
  8004db:	ff d2                	callq  *%rdx
  8004dd:	89 45 f0             	mov    %eax,-0x10(%rbp)
	snprintf(filename_buffer, 50, "/vmm/fs%d.img", vmdisk_number);
  8004e0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8004e3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8004e7:	89 d1                	mov    %edx,%ecx
  8004e9:	48 ba 5f 4c 80 00 00 	movabs $0x804c5f,%rdx
  8004f0:	00 00 00 
  8004f3:	be 32 00 00 00       	mov    $0x32,%esi
  8004f8:	48 89 c7             	mov    %rax,%rdi
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800507:	00 00 00 
  80050a:	41 ff d0             	callq  *%r8

	cprintf("Creating a new virtual HDD at /vmm/fs%d.img\n", vmdisk_number);
  80050d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800510:	89 c6                	mov    %eax,%esi
  800512:	48 bf 70 4c 80 00 00 	movabs $0x804c70,%rdi
  800519:	00 00 00 
  80051c:	b8 00 00 00 00       	mov    $0x0,%eax
  800521:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  800528:	00 00 00 
  80052b:	ff d2                	callq  *%rdx
	r = copy("vmm/clean-fs.img", filename_buffer);
  80052d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800531:	48 89 c6             	mov    %rax,%rsi
  800534:	48 bf 9d 4c 80 00 00 	movabs $0x804c9d,%rdi
  80053b:	00 00 00 
  80053e:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  800545:	00 00 00 
  800548:	ff d0                	callq  *%rax
  80054a:	89 45 ec             	mov    %eax,-0x14(%rbp)

	if (r < 0) {
  80054d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800551:	79 2c                	jns    80057f <umain+0x22f>
		cprintf("Create new virtual HDD failed: %e\n", r);
  800553:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800556:	89 c6                	mov    %eax,%esi
  800558:	48 bf b0 4c 80 00 00 	movabs $0x804cb0,%rdi
  80055f:	00 00 00 
  800562:	b8 00 00 00 00       	mov    $0x0,%eax
  800567:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  80056e:	00 00 00 
  800571:	ff d2                	callq  *%rdx
		exit();
  800573:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
	}

	cprintf("Create VHD finished\n");
  80057f:	48 bf d3 4c 80 00 00 	movabs $0x804cd3,%rdi
  800586:	00 00 00 
  800589:	b8 00 00 00 00       	mov    $0x0,%eax
  80058e:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  800595:	00 00 00 
  800598:	ff d2                	callq  *%rdx
#endif

	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  80059a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80059d:	be 02 00 00 00       	mov    $0x2,%esi
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	48 b8 6a 1e 80 00 00 	movabs $0x801e6a,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
	wait(guest);
  8005b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005b3:	89 c7                	mov    %eax,%edi
  8005b5:	48 b8 df 45 80 00 00 	movabs $0x8045df,%rax
  8005bc:	00 00 00 
  8005bf:	ff d0                	callq  *%rax
}
  8005c1:	90                   	nop
  8005c2:	c9                   	leaveq 
  8005c3:	c3                   	retq   

00000000008005c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	48 83 ec 10          	sub    $0x10,%rsp
  8005cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8005d3:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  8005da:	00 00 00 
  8005dd:	ff d0                	callq  *%rax
  8005df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005e4:	48 98                	cltq   
  8005e6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8005ed:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8005f4:	00 00 00 
  8005f7:	48 01 c2             	add    %rax,%rdx
  8005fa:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  800601:	00 00 00 
  800604:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800607:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80060b:	7e 14                	jle    800621 <libmain+0x5d>
		binaryname = argv[0];
  80060d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800611:	48 8b 10             	mov    (%rax),%rdx
  800614:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80061b:	00 00 00 
  80061e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800621:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800628:	48 89 d6             	mov    %rdx,%rsi
  80062b:	89 c7                	mov    %eax,%edi
  80062d:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  800634:	00 00 00 
  800637:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800639:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  800640:	00 00 00 
  800643:	ff d0                	callq  *%rax
}
  800645:	90                   	nop
  800646:	c9                   	leaveq 
  800647:	c3                   	retq   

0000000000800648 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800648:	55                   	push   %rbp
  800649:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80064c:	48 b8 a7 25 80 00 00 	movabs $0x8025a7,%rax
  800653:	00 00 00 
  800656:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800658:	bf 00 00 00 00       	mov    $0x0,%edi
  80065d:	48 b8 ad 1c 80 00 00 	movabs $0x801cad,%rax
  800664:	00 00 00 
  800667:	ff d0                	callq  *%rax
}
  800669:	90                   	nop
  80066a:	5d                   	pop    %rbp
  80066b:	c3                   	retq   

000000000080066c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80066c:	55                   	push   %rbp
  80066d:	48 89 e5             	mov    %rsp,%rbp
  800670:	53                   	push   %rbx
  800671:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800678:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80067f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800685:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80068c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800693:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80069a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8006a1:	84 c0                	test   %al,%al
  8006a3:	74 23                	je     8006c8 <_panic+0x5c>
  8006a5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8006ac:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8006b0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8006b4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8006b8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8006bc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8006c0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8006c4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8006c8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8006cf:	00 00 00 
  8006d2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8006d9:	00 00 00 
  8006dc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006e0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8006e7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8006ee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006f5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8006fc:	00 00 00 
  8006ff:	48 8b 18             	mov    (%rax),%rbx
  800702:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  800709:	00 00 00 
  80070c:	ff d0                	callq  *%rax
  80070e:	89 c6                	mov    %eax,%esi
  800710:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800716:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80071d:	41 89 d0             	mov    %edx,%r8d
  800720:	48 89 c1             	mov    %rax,%rcx
  800723:	48 89 da             	mov    %rbx,%rdx
  800726:	48 bf f8 4c 80 00 00 	movabs $0x804cf8,%rdi
  80072d:	00 00 00 
  800730:	b8 00 00 00 00       	mov    $0x0,%eax
  800735:	49 b9 a6 08 80 00 00 	movabs $0x8008a6,%r9
  80073c:	00 00 00 
  80073f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800742:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800749:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800750:	48 89 d6             	mov    %rdx,%rsi
  800753:	48 89 c7             	mov    %rax,%rdi
  800756:	48 b8 fa 07 80 00 00 	movabs $0x8007fa,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
	cprintf("\n");
  800762:	48 bf 1b 4d 80 00 00 	movabs $0x804d1b,%rdi
  800769:	00 00 00 
  80076c:	b8 00 00 00 00       	mov    $0x0,%eax
  800771:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  800778:	00 00 00 
  80077b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80077d:	cc                   	int3   
  80077e:	eb fd                	jmp    80077d <_panic+0x111>

0000000000800780 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800780:	55                   	push   %rbp
  800781:	48 89 e5             	mov    %rsp,%rbp
  800784:	48 83 ec 10          	sub    $0x10,%rsp
  800788:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80078b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80078f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	8d 48 01             	lea    0x1(%rax),%ecx
  800798:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80079c:	89 0a                	mov    %ecx,(%rdx)
  80079e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007a1:	89 d1                	mov    %edx,%ecx
  8007a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007a7:	48 98                	cltq   
  8007a9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8007ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b1:	8b 00                	mov    (%rax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8007ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007be:	8b 00                	mov    (%rax),%eax
  8007c0:	48 98                	cltq   
  8007c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007c6:	48 83 c2 08          	add    $0x8,%rdx
  8007ca:	48 89 c6             	mov    %rax,%rsi
  8007cd:	48 89 d7             	mov    %rdx,%rdi
  8007d0:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  8007d7:	00 00 00 
  8007da:	ff d0                	callq  *%rax
        b->idx = 0;
  8007dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8007e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ea:	8b 40 04             	mov    0x4(%rax),%eax
  8007ed:	8d 50 01             	lea    0x1(%rax),%edx
  8007f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007f4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8007f7:	90                   	nop
  8007f8:	c9                   	leaveq 
  8007f9:	c3                   	retq   

00000000008007fa <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8007fa:	55                   	push   %rbp
  8007fb:	48 89 e5             	mov    %rsp,%rbp
  8007fe:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800805:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80080c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800813:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80081a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800821:	48 8b 0a             	mov    (%rdx),%rcx
  800824:	48 89 08             	mov    %rcx,(%rax)
  800827:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80082b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80082f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800833:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800837:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80083e:	00 00 00 
    b.cnt = 0;
  800841:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800848:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80084b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800852:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800859:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800860:	48 89 c6             	mov    %rax,%rsi
  800863:	48 bf 80 07 80 00 00 	movabs $0x800780,%rdi
  80086a:	00 00 00 
  80086d:	48 b8 44 0c 80 00 00 	movabs $0x800c44,%rax
  800874:	00 00 00 
  800877:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800879:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80087f:	48 98                	cltq   
  800881:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800888:	48 83 c2 08          	add    $0x8,%rdx
  80088c:	48 89 c6             	mov    %rax,%rsi
  80088f:	48 89 d7             	mov    %rdx,%rdi
  800892:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  800899:	00 00 00 
  80089c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80089e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8008a4:	c9                   	leaveq 
  8008a5:	c3                   	retq   

00000000008008a6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8008a6:	55                   	push   %rbp
  8008a7:	48 89 e5             	mov    %rsp,%rbp
  8008aa:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8008b1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8008b8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8008bf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8008c6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8008cd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8008d4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8008db:	84 c0                	test   %al,%al
  8008dd:	74 20                	je     8008ff <cprintf+0x59>
  8008df:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8008e3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8008e7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8008eb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8008ef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8008f3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8008f7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8008fb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8008ff:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800906:	00 00 00 
  800909:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800910:	00 00 00 
  800913:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800917:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80091e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800925:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80092c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800933:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80093a:	48 8b 0a             	mov    (%rdx),%rcx
  80093d:	48 89 08             	mov    %rcx,(%rax)
  800940:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800944:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800948:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80094c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800950:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800957:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80095e:	48 89 d6             	mov    %rdx,%rsi
  800961:	48 89 c7             	mov    %rax,%rdi
  800964:	48 b8 fa 07 80 00 00 	movabs $0x8007fa,%rax
  80096b:	00 00 00 
  80096e:	ff d0                	callq  *%rax
  800970:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800976:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80097c:	c9                   	leaveq 
  80097d:	c3                   	retq   

000000000080097e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80097e:	55                   	push   %rbp
  80097f:	48 89 e5             	mov    %rsp,%rbp
  800982:	48 83 ec 30          	sub    $0x30,%rsp
  800986:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80098a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80098e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800992:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800995:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800999:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80099d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8009a0:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8009a4:	77 54                	ja     8009fa <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009a6:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8009a9:	8d 78 ff             	lea    -0x1(%rax),%edi
  8009ac:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	48 f7 f6             	div    %rsi
  8009bb:	49 89 c2             	mov    %rax,%r10
  8009be:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8009c1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8009c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8009c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009cc:	41 89 c9             	mov    %ecx,%r9d
  8009cf:	41 89 f8             	mov    %edi,%r8d
  8009d2:	89 d1                	mov    %edx,%ecx
  8009d4:	4c 89 d2             	mov    %r10,%rdx
  8009d7:	48 89 c7             	mov    %rax,%rdi
  8009da:	48 b8 7e 09 80 00 00 	movabs $0x80097e,%rax
  8009e1:	00 00 00 
  8009e4:	ff d0                	callq  *%rax
  8009e6:	eb 1c                	jmp    800a04 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009e8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8009ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8009ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009f3:	48 89 ce             	mov    %rcx,%rsi
  8009f6:	89 d7                	mov    %edx,%edi
  8009f8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009fa:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8009fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800a02:	7f e4                	jg     8009e8 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a04:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a10:	48 f7 f1             	div    %rcx
  800a13:	48 b8 10 4f 80 00 00 	movabs $0x804f10,%rax
  800a1a:	00 00 00 
  800a1d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800a21:	0f be d0             	movsbl %al,%edx
  800a24:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a2c:	48 89 ce             	mov    %rcx,%rsi
  800a2f:	89 d7                	mov    %edx,%edi
  800a31:	ff d0                	callq  *%rax
}
  800a33:	90                   	nop
  800a34:	c9                   	leaveq 
  800a35:	c3                   	retq   

0000000000800a36 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a36:	55                   	push   %rbp
  800a37:	48 89 e5             	mov    %rsp,%rbp
  800a3a:	48 83 ec 20          	sub    $0x20,%rsp
  800a3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a42:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a45:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a49:	7e 4f                	jle    800a9a <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	8b 00                	mov    (%rax),%eax
  800a51:	83 f8 30             	cmp    $0x30,%eax
  800a54:	73 24                	jae    800a7a <getuint+0x44>
  800a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a62:	8b 00                	mov    (%rax),%eax
  800a64:	89 c0                	mov    %eax,%eax
  800a66:	48 01 d0             	add    %rdx,%rax
  800a69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6d:	8b 12                	mov    (%rdx),%edx
  800a6f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a76:	89 0a                	mov    %ecx,(%rdx)
  800a78:	eb 14                	jmp    800a8e <getuint+0x58>
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a82:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a8e:	48 8b 00             	mov    (%rax),%rax
  800a91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a95:	e9 9d 00 00 00       	jmpq   800b37 <getuint+0x101>
	else if (lflag)
  800a9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a9e:	74 4c                	je     800aec <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa4:	8b 00                	mov    (%rax),%eax
  800aa6:	83 f8 30             	cmp    $0x30,%eax
  800aa9:	73 24                	jae    800acf <getuint+0x99>
  800aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab7:	8b 00                	mov    (%rax),%eax
  800ab9:	89 c0                	mov    %eax,%eax
  800abb:	48 01 d0             	add    %rdx,%rax
  800abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac2:	8b 12                	mov    (%rdx),%edx
  800ac4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acb:	89 0a                	mov    %ecx,(%rdx)
  800acd:	eb 14                	jmp    800ae3 <getuint+0xad>
  800acf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ad7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae3:	48 8b 00             	mov    (%rax),%rax
  800ae6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aea:	eb 4b                	jmp    800b37 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af0:	8b 00                	mov    (%rax),%eax
  800af2:	83 f8 30             	cmp    $0x30,%eax
  800af5:	73 24                	jae    800b1b <getuint+0xe5>
  800af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b03:	8b 00                	mov    (%rax),%eax
  800b05:	89 c0                	mov    %eax,%eax
  800b07:	48 01 d0             	add    %rdx,%rax
  800b0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0e:	8b 12                	mov    (%rdx),%edx
  800b10:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b17:	89 0a                	mov    %ecx,(%rdx)
  800b19:	eb 14                	jmp    800b2f <getuint+0xf9>
  800b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b23:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b2f:	8b 00                	mov    (%rax),%eax
  800b31:	89 c0                	mov    %eax,%eax
  800b33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b3b:	c9                   	leaveq 
  800b3c:	c3                   	retq   

0000000000800b3d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b3d:	55                   	push   %rbp
  800b3e:	48 89 e5             	mov    %rsp,%rbp
  800b41:	48 83 ec 20          	sub    $0x20,%rsp
  800b45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b49:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b4c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b50:	7e 4f                	jle    800ba1 <getint+0x64>
		x=va_arg(*ap, long long);
  800b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b56:	8b 00                	mov    (%rax),%eax
  800b58:	83 f8 30             	cmp    $0x30,%eax
  800b5b:	73 24                	jae    800b81 <getint+0x44>
  800b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b61:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b69:	8b 00                	mov    (%rax),%eax
  800b6b:	89 c0                	mov    %eax,%eax
  800b6d:	48 01 d0             	add    %rdx,%rax
  800b70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b74:	8b 12                	mov    (%rdx),%edx
  800b76:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7d:	89 0a                	mov    %ecx,(%rdx)
  800b7f:	eb 14                	jmp    800b95 <getint+0x58>
  800b81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b85:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b89:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b91:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b95:	48 8b 00             	mov    (%rax),%rax
  800b98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b9c:	e9 9d 00 00 00       	jmpq   800c3e <getint+0x101>
	else if (lflag)
  800ba1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ba5:	74 4c                	je     800bf3 <getint+0xb6>
		x=va_arg(*ap, long);
  800ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bab:	8b 00                	mov    (%rax),%eax
  800bad:	83 f8 30             	cmp    $0x30,%eax
  800bb0:	73 24                	jae    800bd6 <getint+0x99>
  800bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbe:	8b 00                	mov    (%rax),%eax
  800bc0:	89 c0                	mov    %eax,%eax
  800bc2:	48 01 d0             	add    %rdx,%rax
  800bc5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc9:	8b 12                	mov    (%rdx),%edx
  800bcb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd2:	89 0a                	mov    %ecx,(%rdx)
  800bd4:	eb 14                	jmp    800bea <getint+0xad>
  800bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bda:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bde:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800be2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800be6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bea:	48 8b 00             	mov    (%rax),%rax
  800bed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bf1:	eb 4b                	jmp    800c3e <getint+0x101>
	else
		x=va_arg(*ap, int);
  800bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf7:	8b 00                	mov    (%rax),%eax
  800bf9:	83 f8 30             	cmp    $0x30,%eax
  800bfc:	73 24                	jae    800c22 <getint+0xe5>
  800bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c02:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0a:	8b 00                	mov    (%rax),%eax
  800c0c:	89 c0                	mov    %eax,%eax
  800c0e:	48 01 d0             	add    %rdx,%rax
  800c11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c15:	8b 12                	mov    (%rdx),%edx
  800c17:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c1e:	89 0a                	mov    %ecx,(%rdx)
  800c20:	eb 14                	jmp    800c36 <getint+0xf9>
  800c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c26:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c2a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c32:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c36:	8b 00                	mov    (%rax),%eax
  800c38:	48 98                	cltq   
  800c3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c42:	c9                   	leaveq 
  800c43:	c3                   	retq   

0000000000800c44 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %rbp
  800c45:	48 89 e5             	mov    %rsp,%rbp
  800c48:	41 54                	push   %r12
  800c4a:	53                   	push   %rbx
  800c4b:	48 83 ec 60          	sub    $0x60,%rsp
  800c4f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c53:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800c57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c5b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800c5f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c63:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c67:	48 8b 0a             	mov    (%rdx),%rcx
  800c6a:	48 89 08             	mov    %rcx,(%rax)
  800c6d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c71:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c75:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c79:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7d:	eb 17                	jmp    800c96 <vprintfmt+0x52>
			if (ch == '\0')
  800c7f:	85 db                	test   %ebx,%ebx
  800c81:	0f 84 b9 04 00 00    	je     801140 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800c87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8f:	48 89 d6             	mov    %rdx,%rsi
  800c92:	89 df                	mov    %ebx,%edi
  800c94:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c96:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c9a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c9e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ca2:	0f b6 00             	movzbl (%rax),%eax
  800ca5:	0f b6 d8             	movzbl %al,%ebx
  800ca8:	83 fb 25             	cmp    $0x25,%ebx
  800cab:	75 d2                	jne    800c7f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cad:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800cb1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800cb8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800cbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800cc6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ccd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cd1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cd5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800cd9:	0f b6 00             	movzbl (%rax),%eax
  800cdc:	0f b6 d8             	movzbl %al,%ebx
  800cdf:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ce2:	83 f8 55             	cmp    $0x55,%eax
  800ce5:	0f 87 22 04 00 00    	ja     80110d <vprintfmt+0x4c9>
  800ceb:	89 c0                	mov    %eax,%eax
  800ced:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800cf4:	00 
  800cf5:	48 b8 38 4f 80 00 00 	movabs $0x804f38,%rax
  800cfc:	00 00 00 
  800cff:	48 01 d0             	add    %rdx,%rax
  800d02:	48 8b 00             	mov    (%rax),%rax
  800d05:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800d07:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800d0b:	eb c0                	jmp    800ccd <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d0d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800d11:	eb ba                	jmp    800ccd <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d13:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d1a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d1d:	89 d0                	mov    %edx,%eax
  800d1f:	c1 e0 02             	shl    $0x2,%eax
  800d22:	01 d0                	add    %edx,%eax
  800d24:	01 c0                	add    %eax,%eax
  800d26:	01 d8                	add    %ebx,%eax
  800d28:	83 e8 30             	sub    $0x30,%eax
  800d2b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d32:	0f b6 00             	movzbl (%rax),%eax
  800d35:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d38:	83 fb 2f             	cmp    $0x2f,%ebx
  800d3b:	7e 60                	jle    800d9d <vprintfmt+0x159>
  800d3d:	83 fb 39             	cmp    $0x39,%ebx
  800d40:	7f 5b                	jg     800d9d <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d42:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d47:	eb d1                	jmp    800d1a <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800d49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4c:	83 f8 30             	cmp    $0x30,%eax
  800d4f:	73 17                	jae    800d68 <vprintfmt+0x124>
  800d51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d58:	89 d2                	mov    %edx,%edx
  800d5a:	48 01 d0             	add    %rdx,%rax
  800d5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d60:	83 c2 08             	add    $0x8,%edx
  800d63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d66:	eb 0c                	jmp    800d74 <vprintfmt+0x130>
  800d68:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d6c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d70:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d74:	8b 00                	mov    (%rax),%eax
  800d76:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d79:	eb 23                	jmp    800d9e <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800d7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d7f:	0f 89 48 ff ff ff    	jns    800ccd <vprintfmt+0x89>
				width = 0;
  800d85:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d8c:	e9 3c ff ff ff       	jmpq   800ccd <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d91:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d98:	e9 30 ff ff ff       	jmpq   800ccd <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da2:	0f 89 25 ff ff ff    	jns    800ccd <vprintfmt+0x89>
				width = precision, precision = -1;
  800da8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dab:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800dae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800db5:	e9 13 ff ff ff       	jmpq   800ccd <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dba:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800dbe:	e9 0a ff ff ff       	jmpq   800ccd <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800dc3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc6:	83 f8 30             	cmp    $0x30,%eax
  800dc9:	73 17                	jae    800de2 <vprintfmt+0x19e>
  800dcb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dcf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dd2:	89 d2                	mov    %edx,%edx
  800dd4:	48 01 d0             	add    %rdx,%rax
  800dd7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dda:	83 c2 08             	add    $0x8,%edx
  800ddd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800de0:	eb 0c                	jmp    800dee <vprintfmt+0x1aa>
  800de2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800de6:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800dea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dee:	8b 10                	mov    (%rax),%edx
  800df0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800df4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df8:	48 89 ce             	mov    %rcx,%rsi
  800dfb:	89 d7                	mov    %edx,%edi
  800dfd:	ff d0                	callq  *%rax
			break;
  800dff:	e9 37 03 00 00       	jmpq   80113b <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800e04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e07:	83 f8 30             	cmp    $0x30,%eax
  800e0a:	73 17                	jae    800e23 <vprintfmt+0x1df>
  800e0c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e13:	89 d2                	mov    %edx,%edx
  800e15:	48 01 d0             	add    %rdx,%rax
  800e18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1b:	83 c2 08             	add    $0x8,%edx
  800e1e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e21:	eb 0c                	jmp    800e2f <vprintfmt+0x1eb>
  800e23:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e27:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e2f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	79 02                	jns    800e37 <vprintfmt+0x1f3>
				err = -err;
  800e35:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e37:	83 fb 15             	cmp    $0x15,%ebx
  800e3a:	7f 16                	jg     800e52 <vprintfmt+0x20e>
  800e3c:	48 b8 60 4e 80 00 00 	movabs $0x804e60,%rax
  800e43:	00 00 00 
  800e46:	48 63 d3             	movslq %ebx,%rdx
  800e49:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e4d:	4d 85 e4             	test   %r12,%r12
  800e50:	75 2e                	jne    800e80 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800e52:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5a:	89 d9                	mov    %ebx,%ecx
  800e5c:	48 ba 21 4f 80 00 00 	movabs $0x804f21,%rdx
  800e63:	00 00 00 
  800e66:	48 89 c7             	mov    %rax,%rdi
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6e:	49 b8 4a 11 80 00 00 	movabs $0x80114a,%r8
  800e75:	00 00 00 
  800e78:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e7b:	e9 bb 02 00 00       	jmpq   80113b <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e80:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e88:	4c 89 e1             	mov    %r12,%rcx
  800e8b:	48 ba 2a 4f 80 00 00 	movabs $0x804f2a,%rdx
  800e92:	00 00 00 
  800e95:	48 89 c7             	mov    %rax,%rdi
  800e98:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9d:	49 b8 4a 11 80 00 00 	movabs $0x80114a,%r8
  800ea4:	00 00 00 
  800ea7:	41 ff d0             	callq  *%r8
			break;
  800eaa:	e9 8c 02 00 00       	jmpq   80113b <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800eaf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eb2:	83 f8 30             	cmp    $0x30,%eax
  800eb5:	73 17                	jae    800ece <vprintfmt+0x28a>
  800eb7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ebe:	89 d2                	mov    %edx,%edx
  800ec0:	48 01 d0             	add    %rdx,%rax
  800ec3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ec6:	83 c2 08             	add    $0x8,%edx
  800ec9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ecc:	eb 0c                	jmp    800eda <vprintfmt+0x296>
  800ece:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ed2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ed6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eda:	4c 8b 20             	mov    (%rax),%r12
  800edd:	4d 85 e4             	test   %r12,%r12
  800ee0:	75 0a                	jne    800eec <vprintfmt+0x2a8>
				p = "(null)";
  800ee2:	49 bc 2d 4f 80 00 00 	movabs $0x804f2d,%r12
  800ee9:	00 00 00 
			if (width > 0 && padc != '-')
  800eec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ef0:	7e 78                	jle    800f6a <vprintfmt+0x326>
  800ef2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ef6:	74 72                	je     800f6a <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800efb:	48 98                	cltq   
  800efd:	48 89 c6             	mov    %rax,%rsi
  800f00:	4c 89 e7             	mov    %r12,%rdi
  800f03:	48 b8 f8 13 80 00 00 	movabs $0x8013f8,%rax
  800f0a:	00 00 00 
  800f0d:	ff d0                	callq  *%rax
  800f0f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800f12:	eb 17                	jmp    800f2b <vprintfmt+0x2e7>
					putch(padc, putdat);
  800f14:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800f18:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f20:	48 89 ce             	mov    %rcx,%rsi
  800f23:	89 d7                	mov    %edx,%edi
  800f25:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f27:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f2f:	7f e3                	jg     800f14 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f31:	eb 37                	jmp    800f6a <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800f33:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f37:	74 1e                	je     800f57 <vprintfmt+0x313>
  800f39:	83 fb 1f             	cmp    $0x1f,%ebx
  800f3c:	7e 05                	jle    800f43 <vprintfmt+0x2ff>
  800f3e:	83 fb 7e             	cmp    $0x7e,%ebx
  800f41:	7e 14                	jle    800f57 <vprintfmt+0x313>
					putch('?', putdat);
  800f43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4b:	48 89 d6             	mov    %rdx,%rsi
  800f4e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f53:	ff d0                	callq  *%rax
  800f55:	eb 0f                	jmp    800f66 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800f57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f5f:	48 89 d6             	mov    %rdx,%rsi
  800f62:	89 df                	mov    %ebx,%edi
  800f64:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f66:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f6a:	4c 89 e0             	mov    %r12,%rax
  800f6d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f71:	0f b6 00             	movzbl (%rax),%eax
  800f74:	0f be d8             	movsbl %al,%ebx
  800f77:	85 db                	test   %ebx,%ebx
  800f79:	74 28                	je     800fa3 <vprintfmt+0x35f>
  800f7b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f7f:	78 b2                	js     800f33 <vprintfmt+0x2ef>
  800f81:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f85:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f89:	79 a8                	jns    800f33 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f8b:	eb 16                	jmp    800fa3 <vprintfmt+0x35f>
				putch(' ', putdat);
  800f8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f95:	48 89 d6             	mov    %rdx,%rsi
  800f98:	bf 20 00 00 00       	mov    $0x20,%edi
  800f9d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fa3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fa7:	7f e4                	jg     800f8d <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800fa9:	e9 8d 01 00 00       	jmpq   80113b <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800fae:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fb2:	be 03 00 00 00       	mov    $0x3,%esi
  800fb7:	48 89 c7             	mov    %rax,%rdi
  800fba:	48 b8 3d 0b 80 00 00 	movabs $0x800b3d,%rax
  800fc1:	00 00 00 
  800fc4:	ff d0                	callq  *%rax
  800fc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fce:	48 85 c0             	test   %rax,%rax
  800fd1:	79 1d                	jns    800ff0 <vprintfmt+0x3ac>
				putch('-', putdat);
  800fd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fdb:	48 89 d6             	mov    %rdx,%rsi
  800fde:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fe3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe9:	48 f7 d8             	neg    %rax
  800fec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ff0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ff7:	e9 d2 00 00 00       	jmpq   8010ce <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ffc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801000:	be 03 00 00 00       	mov    $0x3,%esi
  801005:	48 89 c7             	mov    %rax,%rdi
  801008:	48 b8 36 0a 80 00 00 	movabs $0x800a36,%rax
  80100f:	00 00 00 
  801012:	ff d0                	callq  *%rax
  801014:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801018:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80101f:	e9 aa 00 00 00       	jmpq   8010ce <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  801024:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801028:	be 03 00 00 00       	mov    $0x3,%esi
  80102d:	48 89 c7             	mov    %rax,%rdi
  801030:	48 b8 36 0a 80 00 00 	movabs $0x800a36,%rax
  801037:	00 00 00 
  80103a:	ff d0                	callq  *%rax
  80103c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801040:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801047:	e9 82 00 00 00       	jmpq   8010ce <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  80104c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801050:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801054:	48 89 d6             	mov    %rdx,%rsi
  801057:	bf 30 00 00 00       	mov    $0x30,%edi
  80105c:	ff d0                	callq  *%rax
			putch('x', putdat);
  80105e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801062:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801066:	48 89 d6             	mov    %rdx,%rsi
  801069:	bf 78 00 00 00       	mov    $0x78,%edi
  80106e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801070:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801073:	83 f8 30             	cmp    $0x30,%eax
  801076:	73 17                	jae    80108f <vprintfmt+0x44b>
  801078:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80107c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80107f:	89 d2                	mov    %edx,%edx
  801081:	48 01 d0             	add    %rdx,%rax
  801084:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801087:	83 c2 08             	add    $0x8,%edx
  80108a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80108d:	eb 0c                	jmp    80109b <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  80108f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801093:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801097:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80109b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80109e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8010a2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8010a9:	eb 23                	jmp    8010ce <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8010ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010af:	be 03 00 00 00       	mov    $0x3,%esi
  8010b4:	48 89 c7             	mov    %rax,%rdi
  8010b7:	48 b8 36 0a 80 00 00 	movabs $0x800a36,%rax
  8010be:	00 00 00 
  8010c1:	ff d0                	callq  *%rax
  8010c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010c7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010ce:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010d3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010d6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010dd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e5:	45 89 c1             	mov    %r8d,%r9d
  8010e8:	41 89 f8             	mov    %edi,%r8d
  8010eb:	48 89 c7             	mov    %rax,%rdi
  8010ee:	48 b8 7e 09 80 00 00 	movabs $0x80097e,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
			break;
  8010fa:	eb 3f                	jmp    80113b <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801100:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801104:	48 89 d6             	mov    %rdx,%rsi
  801107:	89 df                	mov    %ebx,%edi
  801109:	ff d0                	callq  *%rax
			break;
  80110b:	eb 2e                	jmp    80113b <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80110d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801111:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801115:	48 89 d6             	mov    %rdx,%rsi
  801118:	bf 25 00 00 00       	mov    $0x25,%edi
  80111d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80111f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801124:	eb 05                	jmp    80112b <vprintfmt+0x4e7>
  801126:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80112b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80112f:	48 83 e8 01          	sub    $0x1,%rax
  801133:	0f b6 00             	movzbl (%rax),%eax
  801136:	3c 25                	cmp    $0x25,%al
  801138:	75 ec                	jne    801126 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  80113a:	90                   	nop
		}
	}
  80113b:	e9 3d fb ff ff       	jmpq   800c7d <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801140:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801141:	48 83 c4 60          	add    $0x60,%rsp
  801145:	5b                   	pop    %rbx
  801146:	41 5c                	pop    %r12
  801148:	5d                   	pop    %rbp
  801149:	c3                   	retq   

000000000080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
  80114e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801155:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80115c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801163:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80116a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801171:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801178:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80117f:	84 c0                	test   %al,%al
  801181:	74 20                	je     8011a3 <printfmt+0x59>
  801183:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801187:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80118b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80118f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801193:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801197:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80119b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80119f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8011a3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8011aa:	00 00 00 
  8011ad:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8011b4:	00 00 00 
  8011b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011bb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011c9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011d0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011d7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011de:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011e5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011ec:	48 89 c7             	mov    %rax,%rdi
  8011ef:	48 b8 44 0c 80 00 00 	movabs $0x800c44,%rax
  8011f6:	00 00 00 
  8011f9:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011fb:	90                   	nop
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 10          	sub    $0x10,%rsp
  801206:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801209:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80120d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801211:	8b 40 10             	mov    0x10(%rax),%eax
  801214:	8d 50 01             	lea    0x1(%rax),%edx
  801217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	48 8b 10             	mov    (%rax),%rdx
  801225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801229:	48 8b 40 08          	mov    0x8(%rax),%rax
  80122d:	48 39 c2             	cmp    %rax,%rdx
  801230:	73 17                	jae    801249 <sprintputch+0x4b>
		*b->buf++ = ch;
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	48 8b 00             	mov    (%rax),%rax
  801239:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80123d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801241:	48 89 0a             	mov    %rcx,(%rdx)
  801244:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801247:	88 10                	mov    %dl,(%rax)
}
  801249:	90                   	nop
  80124a:	c9                   	leaveq 
  80124b:	c3                   	retq   

000000000080124c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80124c:	55                   	push   %rbp
  80124d:	48 89 e5             	mov    %rsp,%rbp
  801250:	48 83 ec 50          	sub    $0x50,%rsp
  801254:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801258:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80125b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80125f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801263:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801267:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80126b:	48 8b 0a             	mov    (%rdx),%rcx
  80126e:	48 89 08             	mov    %rcx,(%rax)
  801271:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801275:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801279:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80127d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801281:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801285:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801289:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80128c:	48 98                	cltq   
  80128e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801292:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801296:	48 01 d0             	add    %rdx,%rax
  801299:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80129d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8012a4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8012a9:	74 06                	je     8012b1 <vsnprintf+0x65>
  8012ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8012af:	7f 07                	jg     8012b8 <vsnprintf+0x6c>
		return -E_INVAL;
  8012b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b6:	eb 2f                	jmp    8012e7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8012b8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8012bc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8012c0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012c4:	48 89 c6             	mov    %rax,%rsi
  8012c7:	48 bf fe 11 80 00 00 	movabs $0x8011fe,%rdi
  8012ce:	00 00 00 
  8012d1:	48 b8 44 0c 80 00 00 	movabs $0x800c44,%rax
  8012d8:	00 00 00 
  8012db:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012e1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012e4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012e7:	c9                   	leaveq 
  8012e8:	c3                   	retq   

00000000008012e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012f4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012fb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801301:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801308:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80130f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801316:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80131d:	84 c0                	test   %al,%al
  80131f:	74 20                	je     801341 <snprintf+0x58>
  801321:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801325:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801329:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80132d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801331:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801335:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801339:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80133d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801341:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801348:	00 00 00 
  80134b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801352:	00 00 00 
  801355:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801359:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801360:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801367:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80136e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801375:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80137c:	48 8b 0a             	mov    (%rdx),%rcx
  80137f:	48 89 08             	mov    %rcx,(%rax)
  801382:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801386:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80138a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80138e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801392:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801399:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8013a0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8013a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8013ad:	48 89 c7             	mov    %rax,%rdi
  8013b0:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  8013b7:	00 00 00 
  8013ba:	ff d0                	callq  *%rax
  8013bc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013c2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013c8:	c9                   	leaveq 
  8013c9:	c3                   	retq   

00000000008013ca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013ca:	55                   	push   %rbp
  8013cb:	48 89 e5             	mov    %rsp,%rbp
  8013ce:	48 83 ec 18          	sub    $0x18,%rsp
  8013d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013dd:	eb 09                	jmp    8013e8 <strlen+0x1e>
		n++;
  8013df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ec:	0f b6 00             	movzbl (%rax),%eax
  8013ef:	84 c0                	test   %al,%al
  8013f1:	75 ec                	jne    8013df <strlen+0x15>
		n++;
	return n;
  8013f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013f6:	c9                   	leaveq 
  8013f7:	c3                   	retq   

00000000008013f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	48 83 ec 20          	sub    $0x20,%rsp
  801400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80140f:	eb 0e                	jmp    80141f <strnlen+0x27>
		n++;
  801411:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801415:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80141a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80141f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801424:	74 0b                	je     801431 <strnlen+0x39>
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	84 c0                	test   %al,%al
  80142f:	75 e0                	jne    801411 <strnlen+0x19>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801434:	c9                   	leaveq 
  801435:	c3                   	retq   

0000000000801436 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	48 83 ec 20          	sub    $0x20,%rsp
  80143e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801442:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80144e:	90                   	nop
  80144f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801453:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801457:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80145b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80145f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801463:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801467:	0f b6 12             	movzbl (%rdx),%edx
  80146a:	88 10                	mov    %dl,(%rax)
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	84 c0                	test   %al,%al
  801471:	75 dc                	jne    80144f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801477:	c9                   	leaveq 
  801478:	c3                   	retq   

0000000000801479 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801479:	55                   	push   %rbp
  80147a:	48 89 e5             	mov    %rsp,%rbp
  80147d:	48 83 ec 20          	sub    $0x20,%rsp
  801481:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801485:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148d:	48 89 c7             	mov    %rax,%rdi
  801490:	48 b8 ca 13 80 00 00 	movabs $0x8013ca,%rax
  801497:	00 00 00 
  80149a:	ff d0                	callq  *%rax
  80149c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80149f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014a2:	48 63 d0             	movslq %eax,%rdx
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a9:	48 01 c2             	add    %rax,%rdx
  8014ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b0:	48 89 c6             	mov    %rax,%rsi
  8014b3:	48 89 d7             	mov    %rdx,%rdi
  8014b6:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  8014bd:	00 00 00 
  8014c0:	ff d0                	callq  *%rax
	return dst;
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014c6:	c9                   	leaveq 
  8014c7:	c3                   	retq   

00000000008014c8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014c8:	55                   	push   %rbp
  8014c9:	48 89 e5             	mov    %rsp,%rbp
  8014cc:	48 83 ec 28          	sub    $0x28,%rsp
  8014d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014e4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014eb:	00 
  8014ec:	eb 2a                	jmp    801518 <strncpy+0x50>
		*dst++ = *src;
  8014ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014fe:	0f b6 12             	movzbl (%rdx),%edx
  801501:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	84 c0                	test   %al,%al
  80150c:	74 05                	je     801513 <strncpy+0x4b>
			src++;
  80150e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801513:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801520:	72 cc                	jb     8014ee <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801526:	c9                   	leaveq 
  801527:	c3                   	retq   

0000000000801528 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801528:	55                   	push   %rbp
  801529:	48 89 e5             	mov    %rsp,%rbp
  80152c:	48 83 ec 28          	sub    $0x28,%rsp
  801530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801534:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801538:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80153c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801540:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801544:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801549:	74 3d                	je     801588 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80154b:	eb 1d                	jmp    80156a <strlcpy+0x42>
			*dst++ = *src++;
  80154d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801551:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801555:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801559:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80155d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801561:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801565:	0f b6 12             	movzbl (%rdx),%edx
  801568:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80156a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80156f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801574:	74 0b                	je     801581 <strlcpy+0x59>
  801576:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157a:	0f b6 00             	movzbl (%rax),%eax
  80157d:	84 c0                	test   %al,%al
  80157f:	75 cc                	jne    80154d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	48 29 c2             	sub    %rax,%rdx
  801593:	48 89 d0             	mov    %rdx,%rax
}
  801596:	c9                   	leaveq 
  801597:	c3                   	retq   

0000000000801598 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801598:	55                   	push   %rbp
  801599:	48 89 e5             	mov    %rsp,%rbp
  80159c:	48 83 ec 10          	sub    $0x10,%rsp
  8015a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015a8:	eb 0a                	jmp    8015b4 <strcmp+0x1c>
		p++, q++;
  8015aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015af:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	84 c0                	test   %al,%al
  8015bd:	74 12                	je     8015d1 <strcmp+0x39>
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	0f b6 10             	movzbl (%rax),%edx
  8015c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	38 c2                	cmp    %al,%dl
  8015cf:	74 d9                	je     8015aa <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	0f b6 00             	movzbl (%rax),%eax
  8015d8:	0f b6 d0             	movzbl %al,%edx
  8015db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	0f b6 c0             	movzbl %al,%eax
  8015e5:	29 c2                	sub    %eax,%edx
  8015e7:	89 d0                	mov    %edx,%eax
}
  8015e9:	c9                   	leaveq 
  8015ea:	c3                   	retq   

00000000008015eb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015eb:	55                   	push   %rbp
  8015ec:	48 89 e5             	mov    %rsp,%rbp
  8015ef:	48 83 ec 18          	sub    $0x18,%rsp
  8015f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015ff:	eb 0f                	jmp    801610 <strncmp+0x25>
		n--, p++, q++;
  801601:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801606:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801610:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801615:	74 1d                	je     801634 <strncmp+0x49>
  801617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	84 c0                	test   %al,%al
  801620:	74 12                	je     801634 <strncmp+0x49>
  801622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801626:	0f b6 10             	movzbl (%rax),%edx
  801629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	38 c2                	cmp    %al,%dl
  801632:	74 cd                	je     801601 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801634:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801639:	75 07                	jne    801642 <strncmp+0x57>
		return 0;
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
  801640:	eb 18                	jmp    80165a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	0f b6 d0             	movzbl %al,%edx
  80164c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	0f b6 c0             	movzbl %al,%eax
  801656:	29 c2                	sub    %eax,%edx
  801658:	89 d0                	mov    %edx,%eax
}
  80165a:	c9                   	leaveq 
  80165b:	c3                   	retq   

000000000080165c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80165c:	55                   	push   %rbp
  80165d:	48 89 e5             	mov    %rsp,%rbp
  801660:	48 83 ec 10          	sub    $0x10,%rsp
  801664:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801668:	89 f0                	mov    %esi,%eax
  80166a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80166d:	eb 17                	jmp    801686 <strchr+0x2a>
		if (*s == c)
  80166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801673:	0f b6 00             	movzbl (%rax),%eax
  801676:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801679:	75 06                	jne    801681 <strchr+0x25>
			return (char *) s;
  80167b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167f:	eb 15                	jmp    801696 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801681:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	84 c0                	test   %al,%al
  80168f:	75 de                	jne    80166f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801696:	c9                   	leaveq 
  801697:	c3                   	retq   

0000000000801698 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801698:	55                   	push   %rbp
  801699:	48 89 e5             	mov    %rsp,%rbp
  80169c:	48 83 ec 10          	sub    $0x10,%rsp
  8016a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016a4:	89 f0                	mov    %esi,%eax
  8016a6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016a9:	eb 11                	jmp    8016bc <strfind+0x24>
		if (*s == c)
  8016ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016b5:	74 12                	je     8016c9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	84 c0                	test   %al,%al
  8016c5:	75 e4                	jne    8016ab <strfind+0x13>
  8016c7:	eb 01                	jmp    8016ca <strfind+0x32>
		if (*s == c)
			break;
  8016c9:	90                   	nop
	return (char *) s;
  8016ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016ce:	c9                   	leaveq 
  8016cf:	c3                   	retq   

00000000008016d0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016d0:	55                   	push   %rbp
  8016d1:	48 89 e5             	mov    %rsp,%rbp
  8016d4:	48 83 ec 18          	sub    $0x18,%rsp
  8016d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016e8:	75 06                	jne    8016f0 <memset+0x20>
		return v;
  8016ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ee:	eb 69                	jmp    801759 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f4:	83 e0 03             	and    $0x3,%eax
  8016f7:	48 85 c0             	test   %rax,%rax
  8016fa:	75 48                	jne    801744 <memset+0x74>
  8016fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801700:	83 e0 03             	and    $0x3,%eax
  801703:	48 85 c0             	test   %rax,%rax
  801706:	75 3c                	jne    801744 <memset+0x74>
		c &= 0xFF;
  801708:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80170f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801712:	c1 e0 18             	shl    $0x18,%eax
  801715:	89 c2                	mov    %eax,%edx
  801717:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80171a:	c1 e0 10             	shl    $0x10,%eax
  80171d:	09 c2                	or     %eax,%edx
  80171f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801722:	c1 e0 08             	shl    $0x8,%eax
  801725:	09 d0                	or     %edx,%eax
  801727:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80172a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172e:	48 c1 e8 02          	shr    $0x2,%rax
  801732:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801735:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801739:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80173c:	48 89 d7             	mov    %rdx,%rdi
  80173f:	fc                   	cld    
  801740:	f3 ab                	rep stos %eax,%es:(%rdi)
  801742:	eb 11                	jmp    801755 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801744:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801748:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80174b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80174f:	48 89 d7             	mov    %rdx,%rdi
  801752:	fc                   	cld    
  801753:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801759:	c9                   	leaveq 
  80175a:	c3                   	retq   

000000000080175b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80175b:	55                   	push   %rbp
  80175c:	48 89 e5             	mov    %rsp,%rbp
  80175f:	48 83 ec 28          	sub    $0x28,%rsp
  801763:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801767:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80176b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80176f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801773:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80177f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801783:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801787:	0f 83 88 00 00 00    	jae    801815 <memmove+0xba>
  80178d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	48 01 d0             	add    %rdx,%rax
  801798:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80179c:	76 77                	jbe    801815 <memmove+0xba>
		s += n;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b2:	83 e0 03             	and    $0x3,%eax
  8017b5:	48 85 c0             	test   %rax,%rax
  8017b8:	75 3b                	jne    8017f5 <memmove+0x9a>
  8017ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017be:	83 e0 03             	and    $0x3,%eax
  8017c1:	48 85 c0             	test   %rax,%rax
  8017c4:	75 2f                	jne    8017f5 <memmove+0x9a>
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	83 e0 03             	and    $0x3,%eax
  8017cd:	48 85 c0             	test   %rax,%rax
  8017d0:	75 23                	jne    8017f5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d6:	48 83 e8 04          	sub    $0x4,%rax
  8017da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017de:	48 83 ea 04          	sub    $0x4,%rdx
  8017e2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017e6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017ea:	48 89 c7             	mov    %rax,%rdi
  8017ed:	48 89 d6             	mov    %rdx,%rsi
  8017f0:	fd                   	std    
  8017f1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017f3:	eb 1d                	jmp    801812 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801801:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	48 89 d7             	mov    %rdx,%rdi
  80180c:	48 89 c1             	mov    %rax,%rcx
  80180f:	fd                   	std    
  801810:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801812:	fc                   	cld    
  801813:	eb 57                	jmp    80186c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801819:	83 e0 03             	and    $0x3,%eax
  80181c:	48 85 c0             	test   %rax,%rax
  80181f:	75 36                	jne    801857 <memmove+0xfc>
  801821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801825:	83 e0 03             	and    $0x3,%eax
  801828:	48 85 c0             	test   %rax,%rax
  80182b:	75 2a                	jne    801857 <memmove+0xfc>
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	83 e0 03             	and    $0x3,%eax
  801834:	48 85 c0             	test   %rax,%rax
  801837:	75 1e                	jne    801857 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	48 c1 e8 02          	shr    $0x2,%rax
  801841:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801848:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80184c:	48 89 c7             	mov    %rax,%rdi
  80184f:	48 89 d6             	mov    %rdx,%rsi
  801852:	fc                   	cld    
  801853:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801855:	eb 15                	jmp    80186c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80185f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801863:	48 89 c7             	mov    %rax,%rdi
  801866:	48 89 d6             	mov    %rdx,%rsi
  801869:	fc                   	cld    
  80186a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80186c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801870:	c9                   	leaveq 
  801871:	c3                   	retq   

0000000000801872 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 18          	sub    $0x18,%rsp
  80187a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80187e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801882:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801886:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80188e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801892:	48 89 ce             	mov    %rcx,%rsi
  801895:	48 89 c7             	mov    %rax,%rdi
  801898:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  80189f:	00 00 00 
  8018a2:	ff d0                	callq  *%rax
}
  8018a4:	c9                   	leaveq 
  8018a5:	c3                   	retq   

00000000008018a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018a6:	55                   	push   %rbp
  8018a7:	48 89 e5             	mov    %rsp,%rbp
  8018aa:	48 83 ec 28          	sub    $0x28,%rsp
  8018ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018ca:	eb 36                	jmp    801902 <memcmp+0x5c>
		if (*s1 != *s2)
  8018cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d0:	0f b6 10             	movzbl (%rax),%edx
  8018d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d7:	0f b6 00             	movzbl (%rax),%eax
  8018da:	38 c2                	cmp    %al,%dl
  8018dc:	74 1a                	je     8018f8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e2:	0f b6 00             	movzbl (%rax),%eax
  8018e5:	0f b6 d0             	movzbl %al,%edx
  8018e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	0f b6 c0             	movzbl %al,%eax
  8018f2:	29 c2                	sub    %eax,%edx
  8018f4:	89 d0                	mov    %edx,%eax
  8018f6:	eb 20                	jmp    801918 <memcmp+0x72>
		s1++, s2++;
  8018f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018fd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80190a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80190e:	48 85 c0             	test   %rax,%rax
  801911:	75 b9                	jne    8018cc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801918:	c9                   	leaveq 
  801919:	c3                   	retq   

000000000080191a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80191a:	55                   	push   %rbp
  80191b:	48 89 e5             	mov    %rsp,%rbp
  80191e:	48 83 ec 28          	sub    $0x28,%rsp
  801922:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801926:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801929:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80192d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801935:	48 01 d0             	add    %rdx,%rax
  801938:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80193c:	eb 19                	jmp    801957 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80193e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801942:	0f b6 00             	movzbl (%rax),%eax
  801945:	0f b6 d0             	movzbl %al,%edx
  801948:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80194b:	0f b6 c0             	movzbl %al,%eax
  80194e:	39 c2                	cmp    %eax,%edx
  801950:	74 11                	je     801963 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801952:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80195b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80195f:	72 dd                	jb     80193e <memfind+0x24>
  801961:	eb 01                	jmp    801964 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801963:	90                   	nop
	return (void *) s;
  801964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801968:	c9                   	leaveq 
  801969:	c3                   	retq   

000000000080196a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80196a:	55                   	push   %rbp
  80196b:	48 89 e5             	mov    %rsp,%rbp
  80196e:	48 83 ec 38          	sub    $0x38,%rsp
  801972:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801976:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80197a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80197d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801984:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80198b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80198c:	eb 05                	jmp    801993 <strtol+0x29>
		s++;
  80198e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801993:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801997:	0f b6 00             	movzbl (%rax),%eax
  80199a:	3c 20                	cmp    $0x20,%al
  80199c:	74 f0                	je     80198e <strtol+0x24>
  80199e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a2:	0f b6 00             	movzbl (%rax),%eax
  8019a5:	3c 09                	cmp    $0x9,%al
  8019a7:	74 e5                	je     80198e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ad:	0f b6 00             	movzbl (%rax),%eax
  8019b0:	3c 2b                	cmp    $0x2b,%al
  8019b2:	75 07                	jne    8019bb <strtol+0x51>
		s++;
  8019b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019b9:	eb 17                	jmp    8019d2 <strtol+0x68>
	else if (*s == '-')
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	0f b6 00             	movzbl (%rax),%eax
  8019c2:	3c 2d                	cmp    $0x2d,%al
  8019c4:	75 0c                	jne    8019d2 <strtol+0x68>
		s++, neg = 1;
  8019c6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019d6:	74 06                	je     8019de <strtol+0x74>
  8019d8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019dc:	75 28                	jne    801a06 <strtol+0x9c>
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	0f b6 00             	movzbl (%rax),%eax
  8019e5:	3c 30                	cmp    $0x30,%al
  8019e7:	75 1d                	jne    801a06 <strtol+0x9c>
  8019e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ed:	48 83 c0 01          	add    $0x1,%rax
  8019f1:	0f b6 00             	movzbl (%rax),%eax
  8019f4:	3c 78                	cmp    $0x78,%al
  8019f6:	75 0e                	jne    801a06 <strtol+0x9c>
		s += 2, base = 16;
  8019f8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019fd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a04:	eb 2c                	jmp    801a32 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a06:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a0a:	75 19                	jne    801a25 <strtol+0xbb>
  801a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a10:	0f b6 00             	movzbl (%rax),%eax
  801a13:	3c 30                	cmp    $0x30,%al
  801a15:	75 0e                	jne    801a25 <strtol+0xbb>
		s++, base = 8;
  801a17:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a1c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a23:	eb 0d                	jmp    801a32 <strtol+0xc8>
	else if (base == 0)
  801a25:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a29:	75 07                	jne    801a32 <strtol+0xc8>
		base = 10;
  801a2b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a36:	0f b6 00             	movzbl (%rax),%eax
  801a39:	3c 2f                	cmp    $0x2f,%al
  801a3b:	7e 1d                	jle    801a5a <strtol+0xf0>
  801a3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a41:	0f b6 00             	movzbl (%rax),%eax
  801a44:	3c 39                	cmp    $0x39,%al
  801a46:	7f 12                	jg     801a5a <strtol+0xf0>
			dig = *s - '0';
  801a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4c:	0f b6 00             	movzbl (%rax),%eax
  801a4f:	0f be c0             	movsbl %al,%eax
  801a52:	83 e8 30             	sub    $0x30,%eax
  801a55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a58:	eb 4e                	jmp    801aa8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5e:	0f b6 00             	movzbl (%rax),%eax
  801a61:	3c 60                	cmp    $0x60,%al
  801a63:	7e 1d                	jle    801a82 <strtol+0x118>
  801a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a69:	0f b6 00             	movzbl (%rax),%eax
  801a6c:	3c 7a                	cmp    $0x7a,%al
  801a6e:	7f 12                	jg     801a82 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a74:	0f b6 00             	movzbl (%rax),%eax
  801a77:	0f be c0             	movsbl %al,%eax
  801a7a:	83 e8 57             	sub    $0x57,%eax
  801a7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a80:	eb 26                	jmp    801aa8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a86:	0f b6 00             	movzbl (%rax),%eax
  801a89:	3c 40                	cmp    $0x40,%al
  801a8b:	7e 47                	jle    801ad4 <strtol+0x16a>
  801a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a91:	0f b6 00             	movzbl (%rax),%eax
  801a94:	3c 5a                	cmp    $0x5a,%al
  801a96:	7f 3c                	jg     801ad4 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9c:	0f b6 00             	movzbl (%rax),%eax
  801a9f:	0f be c0             	movsbl %al,%eax
  801aa2:	83 e8 37             	sub    $0x37,%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801aa8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aab:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801aae:	7d 23                	jge    801ad3 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801ab0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ab5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ab8:	48 98                	cltq   
  801aba:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801abf:	48 89 c2             	mov    %rax,%rdx
  801ac2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ac5:	48 98                	cltq   
  801ac7:	48 01 d0             	add    %rdx,%rax
  801aca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ace:	e9 5f ff ff ff       	jmpq   801a32 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ad3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ad4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801ad9:	74 0b                	je     801ae6 <strtol+0x17c>
		*endptr = (char *) s;
  801adb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801adf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ae3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aea:	74 09                	je     801af5 <strtol+0x18b>
  801aec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af0:	48 f7 d8             	neg    %rax
  801af3:	eb 04                	jmp    801af9 <strtol+0x18f>
  801af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801af9:	c9                   	leaveq 
  801afa:	c3                   	retq   

0000000000801afb <strstr>:

char * strstr(const char *in, const char *str)
{
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 30          	sub    $0x30,%rsp
  801b03:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b0f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b13:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b17:	0f b6 00             	movzbl (%rax),%eax
  801b1a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b1d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b21:	75 06                	jne    801b29 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b27:	eb 6b                	jmp    801b94 <strstr+0x99>

	len = strlen(str);
  801b29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b2d:	48 89 c7             	mov    %rax,%rdi
  801b30:	48 b8 ca 13 80 00 00 	movabs $0x8013ca,%rax
  801b37:	00 00 00 
  801b3a:	ff d0                	callq  *%rax
  801b3c:	48 98                	cltq   
  801b3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b46:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b4e:	0f b6 00             	movzbl (%rax),%eax
  801b51:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b54:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b58:	75 07                	jne    801b61 <strstr+0x66>
				return (char *) 0;
  801b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5f:	eb 33                	jmp    801b94 <strstr+0x99>
		} while (sc != c);
  801b61:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b65:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b68:	75 d8                	jne    801b42 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b76:	48 89 ce             	mov    %rcx,%rsi
  801b79:	48 89 c7             	mov    %rax,%rdi
  801b7c:	48 b8 eb 15 80 00 00 	movabs $0x8015eb,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	callq  *%rax
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	75 b6                	jne    801b42 <strstr+0x47>

	return (char *) (in - 1);
  801b8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b90:	48 83 e8 01          	sub    $0x1,%rax
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	53                   	push   %rbx
  801b9b:	48 83 ec 48          	sub    $0x48,%rsp
  801b9f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ba2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ba5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ba9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bad:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bb1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bb8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bbc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bc0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801bc4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bc8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bcc:	4c 89 c3             	mov    %r8,%rbx
  801bcf:	cd 30                	int    $0x30
  801bd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bd5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bd9:	74 3e                	je     801c19 <syscall+0x83>
  801bdb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801be0:	7e 37                	jle    801c19 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801be2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801be6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801be9:	49 89 d0             	mov    %rdx,%r8
  801bec:	89 c1                	mov    %eax,%ecx
  801bee:	48 ba e8 51 80 00 00 	movabs $0x8051e8,%rdx
  801bf5:	00 00 00 
  801bf8:	be 24 00 00 00       	mov    $0x24,%esi
  801bfd:	48 bf 05 52 80 00 00 	movabs $0x805205,%rdi
  801c04:	00 00 00 
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0c:	49 b9 6c 06 80 00 00 	movabs $0x80066c,%r9
  801c13:	00 00 00 
  801c16:	41 ff d1             	callq  *%r9

	return ret;
  801c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c1d:	48 83 c4 48          	add    $0x48,%rsp
  801c21:	5b                   	pop    %rbx
  801c22:	5d                   	pop    %rbp
  801c23:	c3                   	retq   

0000000000801c24 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c24:	55                   	push   %rbp
  801c25:	48 89 e5             	mov    %rsp,%rbp
  801c28:	48 83 ec 10          	sub    $0x10,%rsp
  801c2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c3c:	48 83 ec 08          	sub    $0x8,%rsp
  801c40:	6a 00                	pushq  $0x0
  801c42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4e:	48 89 d1             	mov    %rdx,%rcx
  801c51:	48 89 c2             	mov    %rax,%rdx
  801c54:	be 00 00 00 00       	mov    $0x0,%esi
  801c59:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5e:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801c65:	00 00 00 
  801c68:	ff d0                	callq  *%rax
  801c6a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c6e:	90                   	nop
  801c6f:	c9                   	leaveq 
  801c70:	c3                   	retq   

0000000000801c71 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c71:	55                   	push   %rbp
  801c72:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c75:	48 83 ec 08          	sub    $0x8,%rsp
  801c79:	6a 00                	pushq  $0x0
  801c7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c91:	be 00 00 00 00       	mov    $0x0,%esi
  801c96:	bf 01 00 00 00       	mov    $0x1,%edi
  801c9b:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	callq  *%rax
  801ca7:	48 83 c4 10          	add    $0x10,%rsp
}
  801cab:	c9                   	leaveq 
  801cac:	c3                   	retq   

0000000000801cad <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cad:	55                   	push   %rbp
  801cae:	48 89 e5             	mov    %rsp,%rbp
  801cb1:	48 83 ec 10          	sub    $0x10,%rsp
  801cb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbb:	48 98                	cltq   
  801cbd:	48 83 ec 08          	sub    $0x8,%rsp
  801cc1:	6a 00                	pushq  $0x0
  801cc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ccf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cd4:	48 89 c2             	mov    %rax,%rdx
  801cd7:	be 01 00 00 00       	mov    $0x1,%esi
  801cdc:	bf 03 00 00 00       	mov    $0x3,%edi
  801ce1:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801ce8:	00 00 00 
  801ceb:	ff d0                	callq  *%rax
  801ced:	48 83 c4 10          	add    $0x10,%rsp
}
  801cf1:	c9                   	leaveq 
  801cf2:	c3                   	retq   

0000000000801cf3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cf3:	55                   	push   %rbp
  801cf4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cf7:	48 83 ec 08          	sub    $0x8,%rsp
  801cfb:	6a 00                	pushq  $0x0
  801cfd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d13:	be 00 00 00 00       	mov    $0x0,%esi
  801d18:	bf 02 00 00 00       	mov    $0x2,%edi
  801d1d:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801d24:	00 00 00 
  801d27:	ff d0                	callq  *%rax
  801d29:	48 83 c4 10          	add    $0x10,%rsp
}
  801d2d:	c9                   	leaveq 
  801d2e:	c3                   	retq   

0000000000801d2f <sys_yield>:


void
sys_yield(void)
{
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d33:	48 83 ec 08          	sub    $0x8,%rsp
  801d37:	6a 00                	pushq  $0x0
  801d39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4f:	be 00 00 00 00       	mov    $0x0,%esi
  801d54:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d59:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801d60:	00 00 00 
  801d63:	ff d0                	callq  *%rax
  801d65:	48 83 c4 10          	add    $0x10,%rsp
}
  801d69:	90                   	nop
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 10          	sub    $0x10,%rsp
  801d74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d7b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d81:	48 63 c8             	movslq %eax,%rcx
  801d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8b:	48 98                	cltq   
  801d8d:	48 83 ec 08          	sub    $0x8,%rsp
  801d91:	6a 00                	pushq  $0x0
  801d93:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d99:	49 89 c8             	mov    %rcx,%r8
  801d9c:	48 89 d1             	mov    %rdx,%rcx
  801d9f:	48 89 c2             	mov    %rax,%rdx
  801da2:	be 01 00 00 00       	mov    $0x1,%esi
  801da7:	bf 04 00 00 00       	mov    $0x4,%edi
  801dac:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801db3:	00 00 00 
  801db6:	ff d0                	callq  *%rax
  801db8:	48 83 c4 10          	add    $0x10,%rsp
}
  801dbc:	c9                   	leaveq 
  801dbd:	c3                   	retq   

0000000000801dbe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dbe:	55                   	push   %rbp
  801dbf:	48 89 e5             	mov    %rsp,%rbp
  801dc2:	48 83 ec 20          	sub    $0x20,%rsp
  801dc6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dc9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dcd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dd0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dd4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dd8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ddb:	48 63 c8             	movslq %eax,%rcx
  801dde:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801de2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801de5:	48 63 f0             	movslq %eax,%rsi
  801de8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801def:	48 98                	cltq   
  801df1:	48 83 ec 08          	sub    $0x8,%rsp
  801df5:	51                   	push   %rcx
  801df6:	49 89 f9             	mov    %rdi,%r9
  801df9:	49 89 f0             	mov    %rsi,%r8
  801dfc:	48 89 d1             	mov    %rdx,%rcx
  801dff:	48 89 c2             	mov    %rax,%rdx
  801e02:	be 01 00 00 00       	mov    $0x1,%esi
  801e07:	bf 05 00 00 00       	mov    $0x5,%edi
  801e0c:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	callq  *%rax
  801e18:	48 83 c4 10          	add    $0x10,%rsp
}
  801e1c:	c9                   	leaveq 
  801e1d:	c3                   	retq   

0000000000801e1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e1e:	55                   	push   %rbp
  801e1f:	48 89 e5             	mov    %rsp,%rbp
  801e22:	48 83 ec 10          	sub    $0x10,%rsp
  801e26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e34:	48 98                	cltq   
  801e36:	48 83 ec 08          	sub    $0x8,%rsp
  801e3a:	6a 00                	pushq  $0x0
  801e3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e48:	48 89 d1             	mov    %rdx,%rcx
  801e4b:	48 89 c2             	mov    %rax,%rdx
  801e4e:	be 01 00 00 00       	mov    $0x1,%esi
  801e53:	bf 06 00 00 00       	mov    $0x6,%edi
  801e58:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
  801e64:	48 83 c4 10          	add    $0x10,%rsp
}
  801e68:	c9                   	leaveq 
  801e69:	c3                   	retq   

0000000000801e6a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e6a:	55                   	push   %rbp
  801e6b:	48 89 e5             	mov    %rsp,%rbp
  801e6e:	48 83 ec 10          	sub    $0x10,%rsp
  801e72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e75:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e7b:	48 63 d0             	movslq %eax,%rdx
  801e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e81:	48 98                	cltq   
  801e83:	48 83 ec 08          	sub    $0x8,%rsp
  801e87:	6a 00                	pushq  $0x0
  801e89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e95:	48 89 d1             	mov    %rdx,%rcx
  801e98:	48 89 c2             	mov    %rax,%rdx
  801e9b:	be 01 00 00 00       	mov    $0x1,%esi
  801ea0:	bf 08 00 00 00       	mov    $0x8,%edi
  801ea5:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801eac:	00 00 00 
  801eaf:	ff d0                	callq  *%rax
  801eb1:	48 83 c4 10          	add    $0x10,%rsp
}
  801eb5:	c9                   	leaveq 
  801eb6:	c3                   	retq   

0000000000801eb7 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801eb7:	55                   	push   %rbp
  801eb8:	48 89 e5             	mov    %rsp,%rbp
  801ebb:	48 83 ec 10          	sub    $0x10,%rsp
  801ebf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ec6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ecd:	48 98                	cltq   
  801ecf:	48 83 ec 08          	sub    $0x8,%rsp
  801ed3:	6a 00                	pushq  $0x0
  801ed5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801edb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee1:	48 89 d1             	mov    %rdx,%rcx
  801ee4:	48 89 c2             	mov    %rax,%rdx
  801ee7:	be 01 00 00 00       	mov    $0x1,%esi
  801eec:	bf 09 00 00 00       	mov    $0x9,%edi
  801ef1:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801ef8:	00 00 00 
  801efb:	ff d0                	callq  *%rax
  801efd:	48 83 c4 10          	add    $0x10,%rsp
}
  801f01:	c9                   	leaveq 
  801f02:	c3                   	retq   

0000000000801f03 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f03:	55                   	push   %rbp
  801f04:	48 89 e5             	mov    %rsp,%rbp
  801f07:	48 83 ec 10          	sub    $0x10,%rsp
  801f0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f19:	48 98                	cltq   
  801f1b:	48 83 ec 08          	sub    $0x8,%rsp
  801f1f:	6a 00                	pushq  $0x0
  801f21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f2d:	48 89 d1             	mov    %rdx,%rcx
  801f30:	48 89 c2             	mov    %rax,%rdx
  801f33:	be 01 00 00 00       	mov    $0x1,%esi
  801f38:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f3d:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
  801f49:	48 83 c4 10          	add    $0x10,%rsp
}
  801f4d:	c9                   	leaveq 
  801f4e:	c3                   	retq   

0000000000801f4f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f4f:	55                   	push   %rbp
  801f50:	48 89 e5             	mov    %rsp,%rbp
  801f53:	48 83 ec 20          	sub    $0x20,%rsp
  801f57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f5e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f62:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f68:	48 63 f0             	movslq %eax,%rsi
  801f6b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f72:	48 98                	cltq   
  801f74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f78:	48 83 ec 08          	sub    $0x8,%rsp
  801f7c:	6a 00                	pushq  $0x0
  801f7e:	49 89 f1             	mov    %rsi,%r9
  801f81:	49 89 c8             	mov    %rcx,%r8
  801f84:	48 89 d1             	mov    %rdx,%rcx
  801f87:	48 89 c2             	mov    %rax,%rdx
  801f8a:	be 00 00 00 00       	mov    $0x0,%esi
  801f8f:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f94:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801f9b:	00 00 00 
  801f9e:	ff d0                	callq  *%rax
  801fa0:	48 83 c4 10          	add    $0x10,%rsp
}
  801fa4:	c9                   	leaveq 
  801fa5:	c3                   	retq   

0000000000801fa6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fa6:	55                   	push   %rbp
  801fa7:	48 89 e5             	mov    %rsp,%rbp
  801faa:	48 83 ec 10          	sub    $0x10,%rsp
  801fae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb6:	48 83 ec 08          	sub    $0x8,%rsp
  801fba:	6a 00                	pushq  $0x0
  801fbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fcd:	48 89 c2             	mov    %rax,%rdx
  801fd0:	be 01 00 00 00       	mov    $0x1,%esi
  801fd5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fda:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  801fe1:	00 00 00 
  801fe4:	ff d0                	callq  *%rax
  801fe6:	48 83 c4 10          	add    $0x10,%rsp
}
  801fea:	c9                   	leaveq 
  801feb:	c3                   	retq   

0000000000801fec <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801fec:	55                   	push   %rbp
  801fed:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ff0:	48 83 ec 08          	sub    $0x8,%rsp
  801ff4:	6a 00                	pushq  $0x0
  801ff6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ffc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802002:	b9 00 00 00 00       	mov    $0x0,%ecx
  802007:	ba 00 00 00 00       	mov    $0x0,%edx
  80200c:	be 00 00 00 00       	mov    $0x0,%esi
  802011:	bf 0e 00 00 00       	mov    $0xe,%edi
  802016:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
  802022:	48 83 c4 10          	add    $0x10,%rsp
}
  802026:	c9                   	leaveq 
  802027:	c3                   	retq   

0000000000802028 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  802028:	55                   	push   %rbp
  802029:	48 89 e5             	mov    %rsp,%rbp
  80202c:	48 83 ec 10          	sub    $0x10,%rsp
  802030:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802034:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  802037:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80203a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80203e:	48 83 ec 08          	sub    $0x8,%rsp
  802042:	6a 00                	pushq  $0x0
  802044:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80204a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802050:	48 89 d1             	mov    %rdx,%rcx
  802053:	48 89 c2             	mov    %rax,%rdx
  802056:	be 00 00 00 00       	mov    $0x0,%esi
  80205b:	bf 0f 00 00 00       	mov    $0xf,%edi
  802060:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802067:	00 00 00 
  80206a:	ff d0                	callq  *%rax
  80206c:	48 83 c4 10          	add    $0x10,%rsp
}
  802070:	c9                   	leaveq 
  802071:	c3                   	retq   

0000000000802072 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802072:	55                   	push   %rbp
  802073:	48 89 e5             	mov    %rsp,%rbp
  802076:	48 83 ec 10          	sub    $0x10,%rsp
  80207a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80207e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802081:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802088:	48 83 ec 08          	sub    $0x8,%rsp
  80208c:	6a 00                	pushq  $0x0
  80208e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802094:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209a:	48 89 d1             	mov    %rdx,%rcx
  80209d:	48 89 c2             	mov    %rax,%rdx
  8020a0:	be 00 00 00 00       	mov    $0x0,%esi
  8020a5:	bf 10 00 00 00       	mov    $0x10,%edi
  8020aa:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8020b1:	00 00 00 
  8020b4:	ff d0                	callq  *%rax
  8020b6:	48 83 c4 10          	add    $0x10,%rsp
}
  8020ba:	c9                   	leaveq 
  8020bb:	c3                   	retq   

00000000008020bc <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8020bc:	55                   	push   %rbp
  8020bd:	48 89 e5             	mov    %rsp,%rbp
  8020c0:	48 83 ec 20          	sub    $0x20,%rsp
  8020c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020ce:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020d2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020d9:	48 63 c8             	movslq %eax,%rcx
  8020dc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e3:	48 63 f0             	movslq %eax,%rsi
  8020e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ed:	48 98                	cltq   
  8020ef:	48 83 ec 08          	sub    $0x8,%rsp
  8020f3:	51                   	push   %rcx
  8020f4:	49 89 f9             	mov    %rdi,%r9
  8020f7:	49 89 f0             	mov    %rsi,%r8
  8020fa:	48 89 d1             	mov    %rdx,%rcx
  8020fd:	48 89 c2             	mov    %rax,%rdx
  802100:	be 00 00 00 00       	mov    $0x0,%esi
  802105:	bf 11 00 00 00       	mov    $0x11,%edi
  80210a:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
  802116:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80211a:	c9                   	leaveq 
  80211b:	c3                   	retq   

000000000080211c <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80211c:	55                   	push   %rbp
  80211d:	48 89 e5             	mov    %rsp,%rbp
  802120:	48 83 ec 10          	sub    $0x10,%rsp
  802124:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802128:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80212c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802134:	48 83 ec 08          	sub    $0x8,%rsp
  802138:	6a 00                	pushq  $0x0
  80213a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802140:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802146:	48 89 d1             	mov    %rdx,%rcx
  802149:	48 89 c2             	mov    %rax,%rdx
  80214c:	be 00 00 00 00       	mov    $0x0,%esi
  802151:	bf 12 00 00 00       	mov    $0x12,%edi
  802156:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80215d:	00 00 00 
  802160:	ff d0                	callq  *%rax
  802162:	48 83 c4 10          	add    $0x10,%rsp
}
  802166:	c9                   	leaveq 
  802167:	c3                   	retq   

0000000000802168 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802168:	55                   	push   %rbp
  802169:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  80216c:	48 83 ec 08          	sub    $0x8,%rsp
  802170:	6a 00                	pushq  $0x0
  802172:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802178:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80217e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802183:	ba 00 00 00 00       	mov    $0x0,%edx
  802188:	be 00 00 00 00       	mov    $0x0,%esi
  80218d:	bf 13 00 00 00       	mov    $0x13,%edi
  802192:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax
  80219e:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  8021a2:	90                   	nop
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 10          	sub    $0x10,%rsp
  8021ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  8021b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b3:	48 98                	cltq   
  8021b5:	48 83 ec 08          	sub    $0x8,%rsp
  8021b9:	6a 00                	pushq  $0x0
  8021bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021cc:	48 89 c2             	mov    %rax,%rdx
  8021cf:	be 00 00 00 00       	mov    $0x0,%esi
  8021d4:	bf 14 00 00 00       	mov    $0x14,%edi
  8021d9:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	callq  *%rax
  8021e5:	48 83 c4 10          	add    $0x10,%rsp
}
  8021e9:	c9                   	leaveq 
  8021ea:	c3                   	retq   

00000000008021eb <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8021eb:	55                   	push   %rbp
  8021ec:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8021ef:	48 83 ec 08          	sub    $0x8,%rsp
  8021f3:	6a 00                	pushq  $0x0
  8021f5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802201:	b9 00 00 00 00       	mov    $0x0,%ecx
  802206:	ba 00 00 00 00       	mov    $0x0,%edx
  80220b:	be 00 00 00 00       	mov    $0x0,%esi
  802210:	bf 15 00 00 00       	mov    $0x15,%edi
  802215:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80221c:	00 00 00 
  80221f:	ff d0                	callq  *%rax
  802221:	48 83 c4 10          	add    $0x10,%rsp
}
  802225:	c9                   	leaveq 
  802226:	c3                   	retq   

0000000000802227 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802227:	55                   	push   %rbp
  802228:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80222b:	48 83 ec 08          	sub    $0x8,%rsp
  80222f:	6a 00                	pushq  $0x0
  802231:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802237:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80223d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802242:	ba 00 00 00 00       	mov    $0x0,%edx
  802247:	be 00 00 00 00       	mov    $0x0,%esi
  80224c:	bf 16 00 00 00       	mov    $0x16,%edi
  802251:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
  80225d:	48 83 c4 10          	add    $0x10,%rsp
}
  802261:	90                   	nop
  802262:	c9                   	leaveq 
  802263:	c3                   	retq   

0000000000802264 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802264:	55                   	push   %rbp
  802265:	48 89 e5             	mov    %rsp,%rbp
  802268:	48 83 ec 08          	sub    $0x8,%rsp
  80226c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802270:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802274:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80227b:	ff ff ff 
  80227e:	48 01 d0             	add    %rdx,%rax
  802281:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802285:	c9                   	leaveq 
  802286:	c3                   	retq   

0000000000802287 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802287:	55                   	push   %rbp
  802288:	48 89 e5             	mov    %rsp,%rbp
  80228b:	48 83 ec 08          	sub    $0x8,%rsp
  80228f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802297:	48 89 c7             	mov    %rax,%rdi
  80229a:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  8022a1:	00 00 00 
  8022a4:	ff d0                	callq  *%rax
  8022a6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8022ac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 18          	sub    $0x18,%rsp
  8022ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022c5:	eb 6b                	jmp    802332 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ca:	48 98                	cltq   
  8022cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8022d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022de:	48 c1 e8 15          	shr    $0x15,%rax
  8022e2:	48 89 c2             	mov    %rax,%rdx
  8022e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ec:	01 00 00 
  8022ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f3:	83 e0 01             	and    $0x1,%eax
  8022f6:	48 85 c0             	test   %rax,%rax
  8022f9:	74 21                	je     80231c <fd_alloc+0x6a>
  8022fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ff:	48 c1 e8 0c          	shr    $0xc,%rax
  802303:	48 89 c2             	mov    %rax,%rdx
  802306:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80230d:	01 00 00 
  802310:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802314:	83 e0 01             	and    $0x1,%eax
  802317:	48 85 c0             	test   %rax,%rax
  80231a:	75 12                	jne    80232e <fd_alloc+0x7c>
			*fd_store = fd;
  80231c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802320:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802324:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	eb 1a                	jmp    802348 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80232e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802332:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802336:	7e 8f                	jle    8022c7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802343:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802348:	c9                   	leaveq 
  802349:	c3                   	retq   

000000000080234a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80234a:	55                   	push   %rbp
  80234b:	48 89 e5             	mov    %rsp,%rbp
  80234e:	48 83 ec 20          	sub    $0x20,%rsp
  802352:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802355:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802359:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80235d:	78 06                	js     802365 <fd_lookup+0x1b>
  80235f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802363:	7e 07                	jle    80236c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802365:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236a:	eb 6c                	jmp    8023d8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80236c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80236f:	48 98                	cltq   
  802371:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802377:	48 c1 e0 0c          	shl    $0xc,%rax
  80237b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80237f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802383:	48 c1 e8 15          	shr    $0x15,%rax
  802387:	48 89 c2             	mov    %rax,%rdx
  80238a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802391:	01 00 00 
  802394:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802398:	83 e0 01             	and    $0x1,%eax
  80239b:	48 85 c0             	test   %rax,%rax
  80239e:	74 21                	je     8023c1 <fd_lookup+0x77>
  8023a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8023a8:	48 89 c2             	mov    %rax,%rdx
  8023ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b2:	01 00 00 
  8023b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b9:	83 e0 01             	and    $0x1,%eax
  8023bc:	48 85 c0             	test   %rax,%rax
  8023bf:	75 07                	jne    8023c8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023c6:	eb 10                	jmp    8023d8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023d0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 30          	sub    $0x30,%rsp
  8023e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023e6:	89 f0                	mov    %esi,%eax
  8023e8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ef:	48 89 c7             	mov    %rax,%rdi
  8023f2:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
  8023fe:	89 c2                	mov    %eax,%edx
  802400:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802404:	48 89 c6             	mov    %rax,%rsi
  802407:	89 d7                	mov    %edx,%edi
  802409:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802418:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241c:	78 0a                	js     802428 <fd_close+0x4e>
	    || fd != fd2)
  80241e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802422:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802426:	74 12                	je     80243a <fd_close+0x60>
		return (must_exist ? r : 0);
  802428:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80242c:	74 05                	je     802433 <fd_close+0x59>
  80242e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802431:	eb 70                	jmp    8024a3 <fd_close+0xc9>
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	eb 69                	jmp    8024a3 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80243a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80243e:	8b 00                	mov    (%rax),%eax
  802440:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802444:	48 89 d6             	mov    %rdx,%rsi
  802447:	89 c7                	mov    %eax,%edi
  802449:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802450:	00 00 00 
  802453:	ff d0                	callq  *%rax
  802455:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245c:	78 2a                	js     802488 <fd_close+0xae>
		if (dev->dev_close)
  80245e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802462:	48 8b 40 20          	mov    0x20(%rax),%rax
  802466:	48 85 c0             	test   %rax,%rax
  802469:	74 16                	je     802481 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80246b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802473:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802477:	48 89 d7             	mov    %rdx,%rdi
  80247a:	ff d0                	callq  *%rax
  80247c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247f:	eb 07                	jmp    802488 <fd_close+0xae>
		else
			r = 0;
  802481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248c:	48 89 c6             	mov    %rax,%rsi
  80248f:	bf 00 00 00 00       	mov    $0x0,%edi
  802494:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax
	return r;
  8024a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024a3:	c9                   	leaveq 
  8024a4:	c3                   	retq   

00000000008024a5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8024a5:	55                   	push   %rbp
  8024a6:	48 89 e5             	mov    %rsp,%rbp
  8024a9:	48 83 ec 20          	sub    $0x20,%rsp
  8024ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8024b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024bb:	eb 41                	jmp    8024fe <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024bd:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024c4:	00 00 00 
  8024c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024ca:	48 63 d2             	movslq %edx,%rdx
  8024cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d1:	8b 00                	mov    (%rax),%eax
  8024d3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024d6:	75 22                	jne    8024fa <dev_lookup+0x55>
			*dev = devtab[i];
  8024d8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024df:	00 00 00 
  8024e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024e5:	48 63 d2             	movslq %edx,%rdx
  8024e8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024f0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f8:	eb 60                	jmp    80255a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024fe:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802505:	00 00 00 
  802508:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80250b:	48 63 d2             	movslq %edx,%rdx
  80250e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802512:	48 85 c0             	test   %rax,%rax
  802515:	75 a6                	jne    8024bd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802517:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  80251e:	00 00 00 
  802521:	48 8b 00             	mov    (%rax),%rax
  802524:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80252a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	48 bf 18 52 80 00 00 	movabs $0x805218,%rdi
  802536:	00 00 00 
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	48 b9 a6 08 80 00 00 	movabs $0x8008a6,%rcx
  802545:	00 00 00 
  802548:	ff d1                	callq  *%rcx
	*dev = 0;
  80254a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80254e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802555:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80255a:	c9                   	leaveq 
  80255b:	c3                   	retq   

000000000080255c <close>:

int
close(int fdnum)
{
  80255c:	55                   	push   %rbp
  80255d:	48 89 e5             	mov    %rsp,%rbp
  802560:	48 83 ec 20          	sub    $0x20,%rsp
  802564:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802567:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80256e:	48 89 d6             	mov    %rdx,%rsi
  802571:	89 c7                	mov    %eax,%edi
  802573:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  80257a:	00 00 00 
  80257d:	ff d0                	callq  *%rax
  80257f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802582:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802586:	79 05                	jns    80258d <close+0x31>
		return r;
  802588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258b:	eb 18                	jmp    8025a5 <close+0x49>
	else
		return fd_close(fd, 1);
  80258d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802591:	be 01 00 00 00       	mov    $0x1,%esi
  802596:	48 89 c7             	mov    %rax,%rdi
  802599:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  8025a0:	00 00 00 
  8025a3:	ff d0                	callq  *%rax
}
  8025a5:	c9                   	leaveq 
  8025a6:	c3                   	retq   

00000000008025a7 <close_all>:

void
close_all(void)
{
  8025a7:	55                   	push   %rbp
  8025a8:	48 89 e5             	mov    %rsp,%rbp
  8025ab:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8025af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025b6:	eb 15                	jmp    8025cd <close_all+0x26>
		close(i);
  8025b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bb:	89 c7                	mov    %eax,%edi
  8025bd:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  8025c4:	00 00 00 
  8025c7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025cd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025d1:	7e e5                	jle    8025b8 <close_all+0x11>
		close(i);
}
  8025d3:	90                   	nop
  8025d4:	c9                   	leaveq 
  8025d5:	c3                   	retq   

00000000008025d6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025d6:	55                   	push   %rbp
  8025d7:	48 89 e5             	mov    %rsp,%rbp
  8025da:	48 83 ec 40          	sub    $0x40,%rsp
  8025de:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025e1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025e4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025e8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025eb:	48 89 d6             	mov    %rdx,%rsi
  8025ee:	89 c7                	mov    %eax,%edi
  8025f0:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	callq  *%rax
  8025fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802603:	79 08                	jns    80260d <dup+0x37>
		return r;
  802605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802608:	e9 70 01 00 00       	jmpq   80277d <dup+0x1a7>
	close(newfdnum);
  80260d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802610:	89 c7                	mov    %eax,%edi
  802612:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80261e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802621:	48 98                	cltq   
  802623:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802629:	48 c1 e0 0c          	shl    $0xc,%rax
  80262d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802635:	48 89 c7             	mov    %rax,%rdi
  802638:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  80263f:	00 00 00 
  802642:	ff d0                	callq  *%rax
  802644:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264c:	48 89 c7             	mov    %rax,%rdi
  80264f:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  802656:	00 00 00 
  802659:	ff d0                	callq  *%rax
  80265b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80265f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802663:	48 c1 e8 15          	shr    $0x15,%rax
  802667:	48 89 c2             	mov    %rax,%rdx
  80266a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802671:	01 00 00 
  802674:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802678:	83 e0 01             	and    $0x1,%eax
  80267b:	48 85 c0             	test   %rax,%rax
  80267e:	74 71                	je     8026f1 <dup+0x11b>
  802680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802684:	48 c1 e8 0c          	shr    $0xc,%rax
  802688:	48 89 c2             	mov    %rax,%rdx
  80268b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802692:	01 00 00 
  802695:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802699:	83 e0 01             	and    $0x1,%eax
  80269c:	48 85 c0             	test   %rax,%rax
  80269f:	74 50                	je     8026f1 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8026a9:	48 89 c2             	mov    %rax,%rdx
  8026ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026b3:	01 00 00 
  8026b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8026bf:	89 c1                	mov    %eax,%ecx
  8026c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c9:	41 89 c8             	mov    %ecx,%r8d
  8026cc:	48 89 d1             	mov    %rdx,%rcx
  8026cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d4:	48 89 c6             	mov    %rax,%rsi
  8026d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026dc:	48 b8 be 1d 80 00 00 	movabs $0x801dbe,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ef:	78 55                	js     802746 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8026f9:	48 89 c2             	mov    %rax,%rdx
  8026fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802703:	01 00 00 
  802706:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270a:	25 07 0e 00 00       	and    $0xe07,%eax
  80270f:	89 c1                	mov    %eax,%ecx
  802711:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802715:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802719:	41 89 c8             	mov    %ecx,%r8d
  80271c:	48 89 d1             	mov    %rdx,%rcx
  80271f:	ba 00 00 00 00       	mov    $0x0,%edx
  802724:	48 89 c6             	mov    %rax,%rsi
  802727:	bf 00 00 00 00       	mov    $0x0,%edi
  80272c:	48 b8 be 1d 80 00 00 	movabs $0x801dbe,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
  802738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273f:	78 08                	js     802749 <dup+0x173>
		goto err;

	return newfdnum;
  802741:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802744:	eb 37                	jmp    80277d <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802746:	90                   	nop
  802747:	eb 01                	jmp    80274a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802749:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80274a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274e:	48 89 c6             	mov    %rax,%rsi
  802751:	bf 00 00 00 00       	mov    $0x0,%edi
  802756:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802762:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802766:	48 89 c6             	mov    %rax,%rsi
  802769:	bf 00 00 00 00       	mov    $0x0,%edi
  80276e:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
	return r;
  80277a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80277d:	c9                   	leaveq 
  80277e:	c3                   	retq   

000000000080277f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80277f:	55                   	push   %rbp
  802780:	48 89 e5             	mov    %rsp,%rbp
  802783:	48 83 ec 40          	sub    $0x40,%rsp
  802787:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80278a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80278e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802792:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802796:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802799:	48 89 d6             	mov    %rdx,%rsi
  80279c:	89 c7                	mov    %eax,%edi
  80279e:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  8027a5:	00 00 00 
  8027a8:	ff d0                	callq  *%rax
  8027aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b1:	78 24                	js     8027d7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b7:	8b 00                	mov    (%rax),%eax
  8027b9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027bd:	48 89 d6             	mov    %rdx,%rsi
  8027c0:	89 c7                	mov    %eax,%edi
  8027c2:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8027c9:	00 00 00 
  8027cc:	ff d0                	callq  *%rax
  8027ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d5:	79 05                	jns    8027dc <read+0x5d>
		return r;
  8027d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027da:	eb 76                	jmp    802852 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e0:	8b 40 08             	mov    0x8(%rax),%eax
  8027e3:	83 e0 03             	and    $0x3,%eax
  8027e6:	83 f8 01             	cmp    $0x1,%eax
  8027e9:	75 3a                	jne    802825 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027eb:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8027f2:	00 00 00 
  8027f5:	48 8b 00             	mov    (%rax),%rax
  8027f8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027fe:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802801:	89 c6                	mov    %eax,%esi
  802803:	48 bf 37 52 80 00 00 	movabs $0x805237,%rdi
  80280a:	00 00 00 
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
  802812:	48 b9 a6 08 80 00 00 	movabs $0x8008a6,%rcx
  802819:	00 00 00 
  80281c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80281e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802823:	eb 2d                	jmp    802852 <read+0xd3>
	}
	if (!dev->dev_read)
  802825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802829:	48 8b 40 10          	mov    0x10(%rax),%rax
  80282d:	48 85 c0             	test   %rax,%rax
  802830:	75 07                	jne    802839 <read+0xba>
		return -E_NOT_SUPP;
  802832:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802837:	eb 19                	jmp    802852 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802839:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802841:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802845:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802849:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80284d:	48 89 cf             	mov    %rcx,%rdi
  802850:	ff d0                	callq  *%rax
}
  802852:	c9                   	leaveq 
  802853:	c3                   	retq   

0000000000802854 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802854:	55                   	push   %rbp
  802855:	48 89 e5             	mov    %rsp,%rbp
  802858:	48 83 ec 30          	sub    $0x30,%rsp
  80285c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80285f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802863:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802867:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80286e:	eb 47                	jmp    8028b7 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802873:	48 98                	cltq   
  802875:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802879:	48 29 c2             	sub    %rax,%rdx
  80287c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287f:	48 63 c8             	movslq %eax,%rcx
  802882:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802886:	48 01 c1             	add    %rax,%rcx
  802889:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80288c:	48 89 ce             	mov    %rcx,%rsi
  80288f:	89 c7                	mov    %eax,%edi
  802891:	48 b8 7f 27 80 00 00 	movabs $0x80277f,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
  80289d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028a4:	79 05                	jns    8028ab <readn+0x57>
			return m;
  8028a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028a9:	eb 1d                	jmp    8028c8 <readn+0x74>
		if (m == 0)
  8028ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028af:	74 13                	je     8028c4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028b4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ba:	48 98                	cltq   
  8028bc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028c0:	72 ae                	jb     802870 <readn+0x1c>
  8028c2:	eb 01                	jmp    8028c5 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8028c4:	90                   	nop
	}
	return tot;
  8028c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028c8:	c9                   	leaveq 
  8028c9:	c3                   	retq   

00000000008028ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028ca:	55                   	push   %rbp
  8028cb:	48 89 e5             	mov    %rsp,%rbp
  8028ce:	48 83 ec 40          	sub    $0x40,%rsp
  8028d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e4:	48 89 d6             	mov    %rdx,%rsi
  8028e7:	89 c7                	mov    %eax,%edi
  8028e9:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fc:	78 24                	js     802922 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802902:	8b 00                	mov    (%rax),%eax
  802904:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802908:	48 89 d6             	mov    %rdx,%rsi
  80290b:	89 c7                	mov    %eax,%edi
  80290d:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax
  802919:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802920:	79 05                	jns    802927 <write+0x5d>
		return r;
  802922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802925:	eb 75                	jmp    80299c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292b:	8b 40 08             	mov    0x8(%rax),%eax
  80292e:	83 e0 03             	and    $0x3,%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	75 3a                	jne    80296f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802935:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  80293c:	00 00 00 
  80293f:	48 8b 00             	mov    (%rax),%rax
  802942:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802948:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80294b:	89 c6                	mov    %eax,%esi
  80294d:	48 bf 53 52 80 00 00 	movabs $0x805253,%rdi
  802954:	00 00 00 
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
  80295c:	48 b9 a6 08 80 00 00 	movabs $0x8008a6,%rcx
  802963:	00 00 00 
  802966:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802968:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80296d:	eb 2d                	jmp    80299c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80296f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802973:	48 8b 40 18          	mov    0x18(%rax),%rax
  802977:	48 85 c0             	test   %rax,%rax
  80297a:	75 07                	jne    802983 <write+0xb9>
		return -E_NOT_SUPP;
  80297c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802981:	eb 19                	jmp    80299c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802983:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802987:	48 8b 40 18          	mov    0x18(%rax),%rax
  80298b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80298f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802993:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802997:	48 89 cf             	mov    %rcx,%rdi
  80299a:	ff d0                	callq  *%rax
}
  80299c:	c9                   	leaveq 
  80299d:	c3                   	retq   

000000000080299e <seek>:

int
seek(int fdnum, off_t offset)
{
  80299e:	55                   	push   %rbp
  80299f:	48 89 e5             	mov    %rsp,%rbp
  8029a2:	48 83 ec 18          	sub    $0x18,%rsp
  8029a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029a9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029b3:	48 89 d6             	mov    %rdx,%rsi
  8029b6:	89 c7                	mov    %eax,%edi
  8029b8:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
  8029c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cb:	79 05                	jns    8029d2 <seek+0x34>
		return r;
  8029cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d0:	eb 0f                	jmp    8029e1 <seek+0x43>
	fd->fd_offset = offset;
  8029d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029d9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e1:	c9                   	leaveq 
  8029e2:	c3                   	retq   

00000000008029e3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029e3:	55                   	push   %rbp
  8029e4:	48 89 e5             	mov    %rsp,%rbp
  8029e7:	48 83 ec 30          	sub    $0x30,%rsp
  8029eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ee:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f8:	48 89 d6             	mov    %rdx,%rsi
  8029fb:	89 c7                	mov    %eax,%edi
  8029fd:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  802a04:	00 00 00 
  802a07:	ff d0                	callq  *%rax
  802a09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a10:	78 24                	js     802a36 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a16:	8b 00                	mov    (%rax),%eax
  802a18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1c:	48 89 d6             	mov    %rdx,%rsi
  802a1f:	89 c7                	mov    %eax,%edi
  802a21:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802a28:	00 00 00 
  802a2b:	ff d0                	callq  *%rax
  802a2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a34:	79 05                	jns    802a3b <ftruncate+0x58>
		return r;
  802a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a39:	eb 72                	jmp    802aad <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3f:	8b 40 08             	mov    0x8(%rax),%eax
  802a42:	83 e0 03             	and    $0x3,%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	75 3a                	jne    802a83 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a49:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  802a50:	00 00 00 
  802a53:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a5f:	89 c6                	mov    %eax,%esi
  802a61:	48 bf 70 52 80 00 00 	movabs $0x805270,%rdi
  802a68:	00 00 00 
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a70:	48 b9 a6 08 80 00 00 	movabs $0x8008a6,%rcx
  802a77:	00 00 00 
  802a7a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a81:	eb 2a                	jmp    802aad <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a87:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a8b:	48 85 c0             	test   %rax,%rax
  802a8e:	75 07                	jne    802a97 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a90:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a95:	eb 16                	jmp    802aad <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aa3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802aa6:	89 ce                	mov    %ecx,%esi
  802aa8:	48 89 d7             	mov    %rdx,%rdi
  802aab:	ff d0                	callq  *%rax
}
  802aad:	c9                   	leaveq 
  802aae:	c3                   	retq   

0000000000802aaf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802aaf:	55                   	push   %rbp
  802ab0:	48 89 e5             	mov    %rsp,%rbp
  802ab3:	48 83 ec 30          	sub    $0x30,%rsp
  802ab7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802abe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac5:	48 89 d6             	mov    %rdx,%rsi
  802ac8:	89 c7                	mov    %eax,%edi
  802aca:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
  802ad6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802add:	78 24                	js     802b03 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802adf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae3:	8b 00                	mov    (%rax),%eax
  802ae5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae9:	48 89 d6             	mov    %rdx,%rsi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b01:	79 05                	jns    802b08 <fstat+0x59>
		return r;
  802b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b06:	eb 5e                	jmp    802b66 <fstat+0xb7>
	if (!dev->dev_stat)
  802b08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b10:	48 85 c0             	test   %rax,%rax
  802b13:	75 07                	jne    802b1c <fstat+0x6d>
		return -E_NOT_SUPP;
  802b15:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1a:	eb 4a                	jmp    802b66 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b20:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b27:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b2e:	00 00 00 
	stat->st_isdir = 0;
  802b31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b35:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b3c:	00 00 00 
	stat->st_dev = dev;
  802b3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b47:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b52:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b5a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b5e:	48 89 ce             	mov    %rcx,%rsi
  802b61:	48 89 d7             	mov    %rdx,%rdi
  802b64:	ff d0                	callq  *%rax
}
  802b66:	c9                   	leaveq 
  802b67:	c3                   	retq   

0000000000802b68 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
  802b6c:	48 83 ec 20          	sub    $0x20,%rsp
  802b70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7c:	be 00 00 00 00       	mov    $0x0,%esi
  802b81:	48 89 c7             	mov    %rax,%rdi
  802b84:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	callq  *%rax
  802b90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b97:	79 05                	jns    802b9e <stat+0x36>
		return fd;
  802b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9c:	eb 2f                	jmp    802bcd <stat+0x65>
	r = fstat(fd, stat);
  802b9e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba5:	48 89 d6             	mov    %rdx,%rsi
  802ba8:	89 c7                	mov    %eax,%edi
  802baa:	48 b8 af 2a 80 00 00 	movabs $0x802aaf,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
  802bb6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
	return r;
  802bca:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bcd:	c9                   	leaveq 
  802bce:	c3                   	retq   

0000000000802bcf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
  802bd3:	48 83 ec 10          	sub    $0x10,%rsp
  802bd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bde:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802be5:	00 00 00 
  802be8:	8b 00                	mov    (%rax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	75 1f                	jne    802c0d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bee:	bf 01 00 00 00       	mov    $0x1,%edi
  802bf3:	48 b8 7d 4a 80 00 00 	movabs $0x804a7d,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
  802bff:	89 c2                	mov    %eax,%edx
  802c01:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c08:	00 00 00 
  802c0b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c0d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c14:	00 00 00 
  802c17:	8b 00                	mov    (%rax),%eax
  802c19:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c1c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c21:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802c28:	00 00 00 
  802c2b:	89 c7                	mov    %eax,%edi
  802c2d:	48 b8 e8 49 80 00 00 	movabs $0x8049e8,%rax
  802c34:	00 00 00 
  802c37:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c42:	48 89 c6             	mov    %rax,%rsi
  802c45:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4a:	48 b8 27 49 80 00 00 	movabs $0x804927,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
}
  802c56:	c9                   	leaveq 
  802c57:	c3                   	retq   

0000000000802c58 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c58:	55                   	push   %rbp
  802c59:	48 89 e5             	mov    %rsp,%rbp
  802c5c:	48 83 ec 20          	sub    $0x20,%rsp
  802c60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c64:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6b:	48 89 c7             	mov    %rax,%rdi
  802c6e:	48 b8 ca 13 80 00 00 	movabs $0x8013ca,%rax
  802c75:	00 00 00 
  802c78:	ff d0                	callq  *%rax
  802c7a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c7f:	7e 0a                	jle    802c8b <open+0x33>
		return -E_BAD_PATH;
  802c81:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c86:	e9 a5 00 00 00       	jmpq   802d30 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c8b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c8f:	48 89 c7             	mov    %rax,%rdi
  802c92:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	79 08                	jns    802caf <open+0x57>
		return r;
  802ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caa:	e9 81 00 00 00       	jmpq   802d30 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	48 89 c6             	mov    %rax,%rsi
  802cb6:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802cbd:	00 00 00 
  802cc0:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ccc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802cd3:	00 00 00 
  802cd6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cd9:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce3:	48 89 c6             	mov    %rax,%rsi
  802ce6:	bf 01 00 00 00       	mov    $0x1,%edi
  802ceb:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  802cf2:	00 00 00 
  802cf5:	ff d0                	callq  *%rax
  802cf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfe:	79 1d                	jns    802d1d <open+0xc5>
		fd_close(fd, 0);
  802d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d04:	be 00 00 00 00       	mov    $0x0,%esi
  802d09:	48 89 c7             	mov    %rax,%rdi
  802d0c:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  802d13:	00 00 00 
  802d16:	ff d0                	callq  *%rax
		return r;
  802d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1b:	eb 13                	jmp    802d30 <open+0xd8>
	}

	return fd2num(fd);
  802d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d21:	48 89 c7             	mov    %rax,%rdi
  802d24:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax

}
  802d30:	c9                   	leaveq 
  802d31:	c3                   	retq   

0000000000802d32 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d32:	55                   	push   %rbp
  802d33:	48 89 e5             	mov    %rsp,%rbp
  802d36:	48 83 ec 10          	sub    $0x10,%rsp
  802d3a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d42:	8b 50 0c             	mov    0xc(%rax),%edx
  802d45:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d4c:	00 00 00 
  802d4f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d51:	be 00 00 00 00       	mov    $0x0,%esi
  802d56:	bf 06 00 00 00       	mov    $0x6,%edi
  802d5b:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  802d62:	00 00 00 
  802d65:	ff d0                	callq  *%rax
}
  802d67:	c9                   	leaveq 
  802d68:	c3                   	retq   

0000000000802d69 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d69:	55                   	push   %rbp
  802d6a:	48 89 e5             	mov    %rsp,%rbp
  802d6d:	48 83 ec 30          	sub    $0x30,%rsp
  802d71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d79:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d81:	8b 50 0c             	mov    0xc(%rax),%edx
  802d84:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d8b:	00 00 00 
  802d8e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d90:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d97:	00 00 00 
  802d9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d9e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802da2:	be 00 00 00 00       	mov    $0x0,%esi
  802da7:	bf 03 00 00 00       	mov    $0x3,%edi
  802dac:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
  802db8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbf:	79 08                	jns    802dc9 <devfile_read+0x60>
		return r;
  802dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc4:	e9 a4 00 00 00       	jmpq   802e6d <devfile_read+0x104>
	assert(r <= n);
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	48 98                	cltq   
  802dce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802dd2:	76 35                	jbe    802e09 <devfile_read+0xa0>
  802dd4:	48 b9 96 52 80 00 00 	movabs $0x805296,%rcx
  802ddb:	00 00 00 
  802dde:	48 ba 9d 52 80 00 00 	movabs $0x80529d,%rdx
  802de5:	00 00 00 
  802de8:	be 86 00 00 00       	mov    $0x86,%esi
  802ded:	48 bf b2 52 80 00 00 	movabs $0x8052b2,%rdi
  802df4:	00 00 00 
  802df7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfc:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  802e03:	00 00 00 
  802e06:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802e09:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802e10:	7e 35                	jle    802e47 <devfile_read+0xde>
  802e12:	48 b9 bd 52 80 00 00 	movabs $0x8052bd,%rcx
  802e19:	00 00 00 
  802e1c:	48 ba 9d 52 80 00 00 	movabs $0x80529d,%rdx
  802e23:	00 00 00 
  802e26:	be 87 00 00 00       	mov    $0x87,%esi
  802e2b:	48 bf b2 52 80 00 00 	movabs $0x8052b2,%rdi
  802e32:	00 00 00 
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  802e41:	00 00 00 
  802e44:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4a:	48 63 d0             	movslq %eax,%rdx
  802e4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e51:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802e58:	00 00 00 
  802e5b:	48 89 c7             	mov    %rax,%rdi
  802e5e:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
	return r;
  802e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802e6d:	c9                   	leaveq 
  802e6e:	c3                   	retq   

0000000000802e6f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e6f:	55                   	push   %rbp
  802e70:	48 89 e5             	mov    %rsp,%rbp
  802e73:	48 83 ec 40          	sub    $0x40,%rsp
  802e77:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e7b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e7f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802e83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802e8b:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802e92:	00 
  802e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e97:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802e9b:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802ea0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea8:	8b 50 0c             	mov    0xc(%rax),%edx
  802eab:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802eb2:	00 00 00 
  802eb5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802eb7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ebe:	00 00 00 
  802ec1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802ec9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ecd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed1:	48 89 c6             	mov    %rax,%rsi
  802ed4:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802edb:	00 00 00 
  802ede:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802eea:	be 00 00 00 00       	mov    $0x0,%esi
  802eef:	bf 04 00 00 00       	mov    $0x4,%edi
  802ef4:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f07:	79 05                	jns    802f0e <devfile_write+0x9f>
		return r;
  802f09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0c:	eb 43                	jmp    802f51 <devfile_write+0xe2>
	assert(r <= n);
  802f0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f11:	48 98                	cltq   
  802f13:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f17:	76 35                	jbe    802f4e <devfile_write+0xdf>
  802f19:	48 b9 96 52 80 00 00 	movabs $0x805296,%rcx
  802f20:	00 00 00 
  802f23:	48 ba 9d 52 80 00 00 	movabs $0x80529d,%rdx
  802f2a:	00 00 00 
  802f2d:	be a2 00 00 00       	mov    $0xa2,%esi
  802f32:	48 bf b2 52 80 00 00 	movabs $0x8052b2,%rdi
  802f39:	00 00 00 
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  802f48:	00 00 00 
  802f4b:	41 ff d0             	callq  *%r8
	return r;
  802f4e:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802f51:	c9                   	leaveq 
  802f52:	c3                   	retq   

0000000000802f53 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f53:	55                   	push   %rbp
  802f54:	48 89 e5             	mov    %rsp,%rbp
  802f57:	48 83 ec 20          	sub    $0x20,%rsp
  802f5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f67:	8b 50 0c             	mov    0xc(%rax),%edx
  802f6a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f71:	00 00 00 
  802f74:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f76:	be 00 00 00 00       	mov    $0x0,%esi
  802f7b:	bf 05 00 00 00       	mov    $0x5,%edi
  802f80:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	callq  *%rax
  802f8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f93:	79 05                	jns    802f9a <devfile_stat+0x47>
		return r;
  802f95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f98:	eb 56                	jmp    802ff0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f9e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802fa5:	00 00 00 
  802fa8:	48 89 c7             	mov    %rax,%rdi
  802fab:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fb7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fbe:	00 00 00 
  802fc1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fcb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fd1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fd8:	00 00 00 
  802fdb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fe1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff0:	c9                   	leaveq 
  802ff1:	c3                   	retq   

0000000000802ff2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ff2:	55                   	push   %rbp
  802ff3:	48 89 e5             	mov    %rsp,%rbp
  802ff6:	48 83 ec 10          	sub    $0x10,%rsp
  802ffa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ffe:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803001:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803005:	8b 50 0c             	mov    0xc(%rax),%edx
  803008:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80300f:	00 00 00 
  803012:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803014:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80301b:	00 00 00 
  80301e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803021:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803024:	be 00 00 00 00       	mov    $0x0,%esi
  803029:	bf 02 00 00 00       	mov    $0x2,%edi
  80302e:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
}
  80303a:	c9                   	leaveq 
  80303b:	c3                   	retq   

000000000080303c <remove>:

// Delete a file
int
remove(const char *path)
{
  80303c:	55                   	push   %rbp
  80303d:	48 89 e5             	mov    %rsp,%rbp
  803040:	48 83 ec 10          	sub    $0x10,%rsp
  803044:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304c:	48 89 c7             	mov    %rax,%rdi
  80304f:	48 b8 ca 13 80 00 00 	movabs $0x8013ca,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
  80305b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803060:	7e 07                	jle    803069 <remove+0x2d>
		return -E_BAD_PATH;
  803062:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803067:	eb 33                	jmp    80309c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306d:	48 89 c6             	mov    %rax,%rsi
  803070:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803077:	00 00 00 
  80307a:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  803081:	00 00 00 
  803084:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803086:	be 00 00 00 00       	mov    $0x0,%esi
  80308b:	bf 07 00 00 00       	mov    $0x7,%edi
  803090:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  803097:	00 00 00 
  80309a:	ff d0                	callq  *%rax
}
  80309c:	c9                   	leaveq 
  80309d:	c3                   	retq   

000000000080309e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80309e:	55                   	push   %rbp
  80309f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030a2:	be 00 00 00 00       	mov    $0x0,%esi
  8030a7:	bf 08 00 00 00       	mov    $0x8,%edi
  8030ac:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
}
  8030b8:	5d                   	pop    %rbp
  8030b9:	c3                   	retq   

00000000008030ba <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030ba:	55                   	push   %rbp
  8030bb:	48 89 e5             	mov    %rsp,%rbp
  8030be:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030c5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030cc:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030d3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030da:	be 00 00 00 00       	mov    $0x0,%esi
  8030df:	48 89 c7             	mov    %rax,%rdi
  8030e2:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f5:	79 28                	jns    80311f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fa:	89 c6                	mov    %eax,%esi
  8030fc:	48 bf c9 52 80 00 00 	movabs $0x8052c9,%rdi
  803103:	00 00 00 
  803106:	b8 00 00 00 00       	mov    $0x0,%eax
  80310b:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  803112:	00 00 00 
  803115:	ff d2                	callq  *%rdx
		return fd_src;
  803117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311a:	e9 76 01 00 00       	jmpq   803295 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80311f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803126:	be 01 01 00 00       	mov    $0x101,%esi
  80312b:	48 89 c7             	mov    %rax,%rdi
  80312e:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  803135:	00 00 00 
  803138:	ff d0                	callq  *%rax
  80313a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80313d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803141:	0f 89 ad 00 00 00    	jns    8031f4 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803147:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314a:	89 c6                	mov    %eax,%esi
  80314c:	48 bf df 52 80 00 00 	movabs $0x8052df,%rdi
  803153:	00 00 00 
  803156:	b8 00 00 00 00       	mov    $0x0,%eax
  80315b:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  803162:	00 00 00 
  803165:	ff d2                	callq  *%rdx
		close(fd_src);
  803167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316a:	89 c7                	mov    %eax,%edi
  80316c:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
		return fd_dest;
  803178:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80317b:	e9 15 01 00 00       	jmpq   803295 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803180:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803183:	48 63 d0             	movslq %eax,%rdx
  803186:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80318d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803190:	48 89 ce             	mov    %rcx,%rsi
  803193:	89 c7                	mov    %eax,%edi
  803195:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax
  8031a1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031a8:	79 4a                	jns    8031f4 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8031aa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031ad:	89 c6                	mov    %eax,%esi
  8031af:	48 bf f9 52 80 00 00 	movabs $0x8052f9,%rdi
  8031b6:	00 00 00 
  8031b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031be:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  8031c5:	00 00 00 
  8031c8:	ff d2                	callq  *%rdx
			close(fd_src);
  8031ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cd:	89 c7                	mov    %eax,%edi
  8031cf:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
			close(fd_dest);
  8031db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031de:	89 c7                	mov    %eax,%edi
  8031e0:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
			return write_size;
  8031ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031ef:	e9 a1 00 00 00       	jmpq   803295 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031f4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fe:	ba 00 02 00 00       	mov    $0x200,%edx
  803203:	48 89 ce             	mov    %rcx,%rsi
  803206:	89 c7                	mov    %eax,%edi
  803208:	48 b8 7f 27 80 00 00 	movabs $0x80277f,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803217:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80321b:	0f 8f 5f ff ff ff    	jg     803180 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803221:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803225:	79 47                	jns    80326e <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803227:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80322a:	89 c6                	mov    %eax,%esi
  80322c:	48 bf 0c 53 80 00 00 	movabs $0x80530c,%rdi
  803233:	00 00 00 
  803236:	b8 00 00 00 00       	mov    $0x0,%eax
  80323b:	48 ba a6 08 80 00 00 	movabs $0x8008a6,%rdx
  803242:	00 00 00 
  803245:	ff d2                	callq  *%rdx
		close(fd_src);
  803247:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324a:	89 c7                	mov    %eax,%edi
  80324c:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  803253:	00 00 00 
  803256:	ff d0                	callq  *%rax
		close(fd_dest);
  803258:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80325b:	89 c7                	mov    %eax,%edi
  80325d:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
		return read_size;
  803269:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80326c:	eb 27                	jmp    803295 <copy+0x1db>
	}
	close(fd_src);
  80326e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803271:	89 c7                	mov    %eax,%edi
  803273:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  80327a:	00 00 00 
  80327d:	ff d0                	callq  *%rax
	close(fd_dest);
  80327f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803282:	89 c7                	mov    %eax,%edi
  803284:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
	return 0;
  803290:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 20          	sub    $0x20,%rsp
  80329f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8032a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a9:	48 89 d6             	mov    %rdx,%rsi
  8032ac:	89 c7                	mov    %eax,%edi
  8032ae:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
  8032ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c1:	79 05                	jns    8032c8 <fd2sockid+0x31>
		return r;
  8032c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c6:	eb 24                	jmp    8032ec <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8032c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cc:	8b 10                	mov    (%rax),%edx
  8032ce:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8032d5:	00 00 00 
  8032d8:	8b 00                	mov    (%rax),%eax
  8032da:	39 c2                	cmp    %eax,%edx
  8032dc:	74 07                	je     8032e5 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8032de:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032e3:	eb 07                	jmp    8032ec <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8032e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e9:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8032ec:	c9                   	leaveq 
  8032ed:	c3                   	retq   

00000000008032ee <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8032ee:	55                   	push   %rbp
  8032ef:	48 89 e5             	mov    %rsp,%rbp
  8032f2:	48 83 ec 20          	sub    $0x20,%rsp
  8032f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8032f9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032fd:	48 89 c7             	mov    %rax,%rdi
  803300:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803313:	78 26                	js     80333b <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	ba 07 04 00 00       	mov    $0x407,%edx
  80331e:	48 89 c6             	mov    %rax,%rsi
  803321:	bf 00 00 00 00       	mov    $0x0,%edi
  803326:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803339:	79 16                	jns    803351 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80333b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333e:	89 c7                	mov    %eax,%edi
  803340:	48 b8 fd 37 80 00 00 	movabs $0x8037fd,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax
		return r;
  80334c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334f:	eb 3a                	jmp    80338b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803355:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80335c:	00 00 00 
  80335f:	8b 12                	mov    (%rdx),%edx
  803361:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803367:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80336e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803372:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803375:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337c:	48 89 c7             	mov    %rax,%rdi
  80337f:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
}
  80338b:	c9                   	leaveq 
  80338c:	c3                   	retq   

000000000080338d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80338d:	55                   	push   %rbp
  80338e:	48 89 e5             	mov    %rsp,%rbp
  803391:	48 83 ec 30          	sub    $0x30,%rsp
  803395:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803398:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80339c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033a3:	89 c7                	mov    %eax,%edi
  8033a5:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
  8033b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b8:	79 05                	jns    8033bf <accept+0x32>
		return r;
  8033ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033bd:	eb 3b                	jmp    8033fa <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8033bf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033c3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ca:	48 89 ce             	mov    %rcx,%rsi
  8033cd:	89 c7                	mov    %eax,%edi
  8033cf:	48 b8 da 36 80 00 00 	movabs $0x8036da,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e2:	79 05                	jns    8033e9 <accept+0x5c>
		return r;
  8033e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e7:	eb 11                	jmp    8033fa <accept+0x6d>
	return alloc_sockfd(r);
  8033e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ec:	89 c7                	mov    %eax,%edi
  8033ee:	48 b8 ee 32 80 00 00 	movabs $0x8032ee,%rax
  8033f5:	00 00 00 
  8033f8:	ff d0                	callq  *%rax
}
  8033fa:	c9                   	leaveq 
  8033fb:	c3                   	retq   

00000000008033fc <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033fc:	55                   	push   %rbp
  8033fd:	48 89 e5             	mov    %rsp,%rbp
  803400:	48 83 ec 20          	sub    $0x20,%rsp
  803404:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80340b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80340e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803411:	89 c7                	mov    %eax,%edi
  803413:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
  80341f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803426:	79 05                	jns    80342d <bind+0x31>
		return r;
  803428:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342b:	eb 1b                	jmp    803448 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80342d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803430:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803437:	48 89 ce             	mov    %rcx,%rsi
  80343a:	89 c7                	mov    %eax,%edi
  80343c:	48 b8 59 37 80 00 00 	movabs $0x803759,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
}
  803448:	c9                   	leaveq 
  803449:	c3                   	retq   

000000000080344a <shutdown>:

int
shutdown(int s, int how)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	48 83 ec 20          	sub    $0x20,%rsp
  803452:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803455:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803458:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80345b:	89 c7                	mov    %eax,%edi
  80345d:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  803464:	00 00 00 
  803467:	ff d0                	callq  *%rax
  803469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803470:	79 05                	jns    803477 <shutdown+0x2d>
		return r;
  803472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803475:	eb 16                	jmp    80348d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803477:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80347a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347d:	89 d6                	mov    %edx,%esi
  80347f:	89 c7                	mov    %eax,%edi
  803481:	48 b8 bd 37 80 00 00 	movabs $0x8037bd,%rax
  803488:	00 00 00 
  80348b:	ff d0                	callq  *%rax
}
  80348d:	c9                   	leaveq 
  80348e:	c3                   	retq   

000000000080348f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80348f:	55                   	push   %rbp
  803490:	48 89 e5             	mov    %rsp,%rbp
  803493:	48 83 ec 10          	sub    $0x10,%rsp
  803497:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80349b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349f:	48 89 c7             	mov    %rax,%rdi
  8034a2:	48 b8 ee 4a 80 00 00 	movabs $0x804aee,%rax
  8034a9:	00 00 00 
  8034ac:	ff d0                	callq  *%rax
  8034ae:	83 f8 01             	cmp    $0x1,%eax
  8034b1:	75 17                	jne    8034ca <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8034b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b7:	8b 40 0c             	mov    0xc(%rax),%eax
  8034ba:	89 c7                	mov    %eax,%edi
  8034bc:	48 b8 fd 37 80 00 00 	movabs $0x8037fd,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
  8034c8:	eb 05                	jmp    8034cf <devsock_close+0x40>
	else
		return 0;
  8034ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034cf:	c9                   	leaveq 
  8034d0:	c3                   	retq   

00000000008034d1 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034d1:	55                   	push   %rbp
  8034d2:	48 89 e5             	mov    %rsp,%rbp
  8034d5:	48 83 ec 20          	sub    $0x20,%rsp
  8034d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e6:	89 c7                	mov    %eax,%edi
  8034e8:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  8034ef:	00 00 00 
  8034f2:	ff d0                	callq  *%rax
  8034f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034fb:	79 05                	jns    803502 <connect+0x31>
		return r;
  8034fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803500:	eb 1b                	jmp    80351d <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803502:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803505:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	48 89 ce             	mov    %rcx,%rsi
  80350f:	89 c7                	mov    %eax,%edi
  803511:	48 b8 2a 38 80 00 00 	movabs $0x80382a,%rax
  803518:	00 00 00 
  80351b:	ff d0                	callq  *%rax
}
  80351d:	c9                   	leaveq 
  80351e:	c3                   	retq   

000000000080351f <listen>:

int
listen(int s, int backlog)
{
  80351f:	55                   	push   %rbp
  803520:	48 89 e5             	mov    %rsp,%rbp
  803523:	48 83 ec 20          	sub    $0x20,%rsp
  803527:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80352a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80352d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803530:	89 c7                	mov    %eax,%edi
  803532:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  803539:	00 00 00 
  80353c:	ff d0                	callq  *%rax
  80353e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803541:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803545:	79 05                	jns    80354c <listen+0x2d>
		return r;
  803547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354a:	eb 16                	jmp    803562 <listen+0x43>
	return nsipc_listen(r, backlog);
  80354c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80354f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803552:	89 d6                	mov    %edx,%esi
  803554:	89 c7                	mov    %eax,%edi
  803556:	48 b8 8e 38 80 00 00 	movabs $0x80388e,%rax
  80355d:	00 00 00 
  803560:	ff d0                	callq  *%rax
}
  803562:	c9                   	leaveq 
  803563:	c3                   	retq   

0000000000803564 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803564:	55                   	push   %rbp
  803565:	48 89 e5             	mov    %rsp,%rbp
  803568:	48 83 ec 20          	sub    $0x20,%rsp
  80356c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803570:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803574:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357c:	89 c2                	mov    %eax,%edx
  80357e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803582:	8b 40 0c             	mov    0xc(%rax),%eax
  803585:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803589:	b9 00 00 00 00       	mov    $0x0,%ecx
  80358e:	89 c7                	mov    %eax,%edi
  803590:	48 b8 ce 38 80 00 00 	movabs $0x8038ce,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
}
  80359c:	c9                   	leaveq 
  80359d:	c3                   	retq   

000000000080359e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80359e:	55                   	push   %rbp
  80359f:	48 89 e5             	mov    %rsp,%rbp
  8035a2:	48 83 ec 20          	sub    $0x20,%rsp
  8035a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8035b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b6:	89 c2                	mov    %eax,%edx
  8035b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035bc:	8b 40 0c             	mov    0xc(%rax),%eax
  8035bf:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035c8:	89 c7                	mov    %eax,%edi
  8035ca:	48 b8 9a 39 80 00 00 	movabs $0x80399a,%rax
  8035d1:	00 00 00 
  8035d4:	ff d0                	callq  *%rax
}
  8035d6:	c9                   	leaveq 
  8035d7:	c3                   	retq   

00000000008035d8 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035d8:	55                   	push   %rbp
  8035d9:	48 89 e5             	mov    %rsp,%rbp
  8035dc:	48 83 ec 10          	sub    $0x10,%rsp
  8035e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8035e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ec:	48 be 27 53 80 00 00 	movabs $0x805327,%rsi
  8035f3:	00 00 00 
  8035f6:	48 89 c7             	mov    %rax,%rdi
  8035f9:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  803600:	00 00 00 
  803603:	ff d0                	callq  *%rax
	return 0;
  803605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80360a:	c9                   	leaveq 
  80360b:	c3                   	retq   

000000000080360c <socket>:

int
socket(int domain, int type, int protocol)
{
  80360c:	55                   	push   %rbp
  80360d:	48 89 e5             	mov    %rsp,%rbp
  803610:	48 83 ec 20          	sub    $0x20,%rsp
  803614:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803617:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80361a:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80361d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803620:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803623:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803626:	89 ce                	mov    %ecx,%esi
  803628:	89 c7                	mov    %eax,%edi
  80362a:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803631:	00 00 00 
  803634:	ff d0                	callq  *%rax
  803636:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803639:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363d:	79 05                	jns    803644 <socket+0x38>
		return r;
  80363f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803642:	eb 11                	jmp    803655 <socket+0x49>
	return alloc_sockfd(r);
  803644:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803647:	89 c7                	mov    %eax,%edi
  803649:	48 b8 ee 32 80 00 00 	movabs $0x8032ee,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
}
  803655:	c9                   	leaveq 
  803656:	c3                   	retq   

0000000000803657 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803657:	55                   	push   %rbp
  803658:	48 89 e5             	mov    %rsp,%rbp
  80365b:	48 83 ec 10          	sub    $0x10,%rsp
  80365f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803662:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803669:	00 00 00 
  80366c:	8b 00                	mov    (%rax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	75 1f                	jne    803691 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803672:	bf 02 00 00 00       	mov    $0x2,%edi
  803677:	48 b8 7d 4a 80 00 00 	movabs $0x804a7d,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
  803683:	89 c2                	mov    %eax,%edx
  803685:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  80368c:	00 00 00 
  80368f:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803691:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803698:	00 00 00 
  80369b:	8b 00                	mov    (%rax),%eax
  80369d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8036a0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036a5:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8036ac:	00 00 00 
  8036af:	89 c7                	mov    %eax,%edi
  8036b1:	48 b8 e8 49 80 00 00 	movabs $0x8049e8,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8036bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8036c2:	be 00 00 00 00       	mov    $0x0,%esi
  8036c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036cc:	48 b8 27 49 80 00 00 	movabs $0x804927,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
}
  8036d8:	c9                   	leaveq 
  8036d9:	c3                   	retq   

00000000008036da <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036da:	55                   	push   %rbp
  8036db:	48 89 e5             	mov    %rsp,%rbp
  8036de:	48 83 ec 30          	sub    $0x30,%rsp
  8036e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8036ed:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036f4:	00 00 00 
  8036f7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036fa:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036fc:	bf 01 00 00 00       	mov    $0x1,%edi
  803701:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  803708:	00 00 00 
  80370b:	ff d0                	callq  *%rax
  80370d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803714:	78 3e                	js     803754 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803716:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80371d:	00 00 00 
  803720:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803728:	8b 40 10             	mov    0x10(%rax),%eax
  80372b:	89 c2                	mov    %eax,%edx
  80372d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803731:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803735:	48 89 ce             	mov    %rcx,%rsi
  803738:	48 89 c7             	mov    %rax,%rdi
  80373b:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374b:	8b 50 10             	mov    0x10(%rax),%edx
  80374e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803752:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803754:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803757:	c9                   	leaveq 
  803758:	c3                   	retq   

0000000000803759 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803759:	55                   	push   %rbp
  80375a:	48 89 e5             	mov    %rsp,%rbp
  80375d:	48 83 ec 10          	sub    $0x10,%rsp
  803761:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803764:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803768:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80376b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803772:	00 00 00 
  803775:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803778:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80377a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80377d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803781:	48 89 c6             	mov    %rax,%rsi
  803784:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80378b:	00 00 00 
  80378e:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80379a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037a1:	00 00 00 
  8037a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037a7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8037aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8037af:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  8037b6:	00 00 00 
  8037b9:	ff d0                	callq  *%rax
}
  8037bb:	c9                   	leaveq 
  8037bc:	c3                   	retq   

00000000008037bd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8037bd:	55                   	push   %rbp
  8037be:	48 89 e5             	mov    %rsp,%rbp
  8037c1:	48 83 ec 10          	sub    $0x10,%rsp
  8037c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037c8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8037cb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037d2:	00 00 00 
  8037d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037d8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8037da:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037e1:	00 00 00 
  8037e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037e7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8037ea:	bf 03 00 00 00       	mov    $0x3,%edi
  8037ef:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  8037f6:	00 00 00 
  8037f9:	ff d0                	callq  *%rax
}
  8037fb:	c9                   	leaveq 
  8037fc:	c3                   	retq   

00000000008037fd <nsipc_close>:

int
nsipc_close(int s)
{
  8037fd:	55                   	push   %rbp
  8037fe:	48 89 e5             	mov    %rsp,%rbp
  803801:	48 83 ec 10          	sub    $0x10,%rsp
  803805:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803808:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80380f:	00 00 00 
  803812:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803815:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803817:	bf 04 00 00 00       	mov    $0x4,%edi
  80381c:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
}
  803828:	c9                   	leaveq 
  803829:	c3                   	retq   

000000000080382a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80382a:	55                   	push   %rbp
  80382b:	48 89 e5             	mov    %rsp,%rbp
  80382e:	48 83 ec 10          	sub    $0x10,%rsp
  803832:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803835:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803839:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80383c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803843:	00 00 00 
  803846:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803849:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80384b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80384e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803852:	48 89 c6             	mov    %rax,%rsi
  803855:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80385c:	00 00 00 
  80385f:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  803866:	00 00 00 
  803869:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80386b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803872:	00 00 00 
  803875:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803878:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80387b:	bf 05 00 00 00       	mov    $0x5,%edi
  803880:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
}
  80388c:	c9                   	leaveq 
  80388d:	c3                   	retq   

000000000080388e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80388e:	55                   	push   %rbp
  80388f:	48 89 e5             	mov    %rsp,%rbp
  803892:	48 83 ec 10          	sub    $0x10,%rsp
  803896:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803899:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80389c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038a3:	00 00 00 
  8038a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038a9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8038ab:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038b2:	00 00 00 
  8038b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038b8:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8038bb:	bf 06 00 00 00       	mov    $0x6,%edi
  8038c0:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
}
  8038cc:	c9                   	leaveq 
  8038cd:	c3                   	retq   

00000000008038ce <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038ce:	55                   	push   %rbp
  8038cf:	48 89 e5             	mov    %rsp,%rbp
  8038d2:	48 83 ec 30          	sub    $0x30,%rsp
  8038d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038dd:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8038e0:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8038e3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038ea:	00 00 00 
  8038ed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038f0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8038f2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038f9:	00 00 00 
  8038fc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038ff:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803902:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803909:	00 00 00 
  80390c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80390f:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803912:	bf 07 00 00 00       	mov    $0x7,%edi
  803917:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803926:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392a:	78 69                	js     803995 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80392c:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803933:	7f 08                	jg     80393d <nsipc_recv+0x6f>
  803935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803938:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80393b:	7e 35                	jle    803972 <nsipc_recv+0xa4>
  80393d:	48 b9 2e 53 80 00 00 	movabs $0x80532e,%rcx
  803944:	00 00 00 
  803947:	48 ba 43 53 80 00 00 	movabs $0x805343,%rdx
  80394e:	00 00 00 
  803951:	be 62 00 00 00       	mov    $0x62,%esi
  803956:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  80395d:	00 00 00 
  803960:	b8 00 00 00 00       	mov    $0x0,%eax
  803965:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  80396c:	00 00 00 
  80396f:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803975:	48 63 d0             	movslq %eax,%rdx
  803978:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397c:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803983:	00 00 00 
  803986:	48 89 c7             	mov    %rax,%rdi
  803989:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  803990:	00 00 00 
  803993:	ff d0                	callq  *%rax
	}

	return r;
  803995:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803998:	c9                   	leaveq 
  803999:	c3                   	retq   

000000000080399a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80399a:	55                   	push   %rbp
  80399b:	48 89 e5             	mov    %rsp,%rbp
  80399e:	48 83 ec 20          	sub    $0x20,%rsp
  8039a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039a9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8039ac:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8039af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039b6:	00 00 00 
  8039b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039bc:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8039be:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8039c5:	7e 35                	jle    8039fc <nsipc_send+0x62>
  8039c7:	48 b9 64 53 80 00 00 	movabs $0x805364,%rcx
  8039ce:	00 00 00 
  8039d1:	48 ba 43 53 80 00 00 	movabs $0x805343,%rdx
  8039d8:	00 00 00 
  8039db:	be 6d 00 00 00       	mov    $0x6d,%esi
  8039e0:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  8039e7:	00 00 00 
  8039ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ef:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  8039f6:	00 00 00 
  8039f9:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039ff:	48 63 d0             	movslq %eax,%rdx
  803a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a06:	48 89 c6             	mov    %rax,%rsi
  803a09:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803a10:	00 00 00 
  803a13:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a26:	00 00 00 
  803a29:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803a2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a36:	00 00 00 
  803a39:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a3c:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803a3f:	bf 08 00 00 00       	mov    $0x8,%edi
  803a44:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
}
  803a50:	c9                   	leaveq 
  803a51:	c3                   	retq   

0000000000803a52 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a52:	55                   	push   %rbp
  803a53:	48 89 e5             	mov    %rsp,%rbp
  803a56:	48 83 ec 10          	sub    $0x10,%rsp
  803a5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a5d:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a60:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a63:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a6a:	00 00 00 
  803a6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a70:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a79:	00 00 00 
  803a7c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a89:	00 00 00 
  803a8c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a8f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a92:	bf 09 00 00 00       	mov    $0x9,%edi
  803a97:	48 b8 57 36 80 00 00 	movabs $0x803657,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
}
  803aa3:	c9                   	leaveq 
  803aa4:	c3                   	retq   

0000000000803aa5 <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  803aa5:	55                   	push   %rbp
  803aa6:	48 89 e5             	mov    %rsp,%rbp
  803aa9:	48 83 ec 20          	sub    $0x20,%rsp
  803aad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ab1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  803ab5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ab9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abd:	48 01 d0             	add    %rdx,%rax
  803ac0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ac8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803acc:	eb 64                	jmp    803b32 <isfree+0x8d>
		if (va >= (uintptr_t) mend
  803ace:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803ad5:	00 00 00 
  803ad8:	48 8b 00             	mov    (%rax),%rax
  803adb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803adf:	73 42                	jae    803b23 <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae5:	48 c1 e8 15          	shr    $0x15,%rax
  803ae9:	48 89 c2             	mov    %rax,%rdx
  803aec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803af3:	01 00 00 
  803af6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803afa:	83 e0 01             	and    $0x1,%eax
  803afd:	48 85 c0             	test   %rax,%rax
  803b00:	74 28                	je     803b2a <isfree+0x85>
  803b02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b06:	48 c1 e8 0c          	shr    $0xc,%rax
  803b0a:	48 89 c2             	mov    %rax,%rdx
  803b0d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b14:	01 00 00 
  803b17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b1b:	83 e0 01             	and    $0x1,%eax
  803b1e:	48 85 c0             	test   %rax,%rax
  803b21:	74 07                	je     803b2a <isfree+0x85>
			return 0;
  803b23:	b8 00 00 00 00       	mov    $0x0,%eax
  803b28:	eb 17                	jmp    803b41 <isfree+0x9c>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803b2a:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803b31:	00 
  803b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b36:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803b3a:	72 92                	jb     803ace <isfree+0x29>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803b3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803b41:	c9                   	leaveq 
  803b42:	c3                   	retq   

0000000000803b43 <malloc>:

void*
malloc(size_t n)
{
  803b43:	55                   	push   %rbp
  803b44:	48 89 e5             	mov    %rsp,%rbp
  803b47:	48 83 ec 60          	sub    $0x60,%rsp
  803b4b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803b4f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b56:	00 00 00 
  803b59:	48 8b 00             	mov    (%rax),%rax
  803b5c:	48 85 c0             	test   %rax,%rax
  803b5f:	75 1a                	jne    803b7b <malloc+0x38>
		mptr = mbegin;
  803b61:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803b68:	00 00 00 
  803b6b:	48 8b 10             	mov    (%rax),%rdx
  803b6e:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803b75:	00 00 00 
  803b78:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  803b7b:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  803b82:	00 
  803b83:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8b:	48 01 d0             	add    %rdx,%rax
  803b8e:	48 83 e8 01          	sub    $0x1,%rax
  803b92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  803b9f:	48 f7 75 f0          	divq   -0x10(%rbp)
  803ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba7:	48 29 d0             	sub    %rdx,%rax
  803baa:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
	
	if (n >= MAXMALLOC)
  803bae:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  803bb5:	00 
  803bb6:	76 0a                	jbe    803bc2 <malloc+0x7f>
		return 0;
  803bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbd:	e9 f0 02 00 00       	jmpq   803eb2 <malloc+0x36f>
	
	if ((uintptr_t) mptr % PGSIZE){
  803bc2:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803bc9:	00 00 00 
  803bcc:	48 8b 00             	mov    (%rax),%rax
  803bcf:	25 ff 0f 00 00       	and    $0xfff,%eax
  803bd4:	48 85 c0             	test   %rax,%rax
  803bd7:	0f 84 0f 01 00 00    	je     803cec <malloc+0x1a9>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803bdd:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803be4:	00 
  803be5:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803bec:	00 00 00 
  803bef:	48 8b 00             	mov    (%rax),%rax
  803bf2:	48 89 c2             	mov    %rax,%rdx
  803bf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf9:	48 01 d0             	add    %rdx,%rax
  803bfc:	48 83 e8 01          	sub    $0x1,%rax
  803c00:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c08:	ba 00 00 00 00       	mov    $0x0,%edx
  803c0d:	48 f7 75 e0          	divq   -0x20(%rbp)
  803c11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c15:	48 29 d0             	sub    %rdx,%rax
  803c18:	48 83 e8 04          	sub    $0x4,%rax
  803c1c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803c20:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c27:	00 00 00 
  803c2a:	48 8b 00             	mov    (%rax),%rax
  803c2d:	48 c1 e8 0c          	shr    $0xc,%rax
  803c31:	48 89 c1             	mov    %rax,%rcx
  803c34:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c3b:	00 00 00 
  803c3e:	48 8b 00             	mov    (%rax),%rax
  803c41:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803c45:	48 83 c2 03          	add    $0x3,%rdx
  803c49:	48 01 d0             	add    %rdx,%rax
  803c4c:	48 c1 e8 0c          	shr    $0xc,%rax
  803c50:	48 39 c1             	cmp    %rax,%rcx
  803c53:	75 4a                	jne    803c9f <malloc+0x15c>
			(*ref)++;
  803c55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c59:	8b 00                	mov    (%rax),%eax
  803c5b:	8d 50 01             	lea    0x1(%rax),%edx
  803c5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c62:	89 10                	mov    %edx,(%rax)
			v = mptr;
  803c64:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c6b:	00 00 00 
  803c6e:	48 8b 00             	mov    (%rax),%rax
  803c71:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  803c75:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c7c:	00 00 00 
  803c7f:	48 8b 10             	mov    (%rax),%rdx
  803c82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c86:	48 01 c2             	add    %rax,%rdx
  803c89:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803c90:	00 00 00 
  803c93:	48 89 10             	mov    %rdx,(%rax)
			return v;
  803c96:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c9a:	e9 13 02 00 00       	jmpq   803eb2 <malloc+0x36f>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803c9f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ca6:	00 00 00 
  803ca9:	48 8b 00             	mov    (%rax),%rax
  803cac:	48 89 c7             	mov    %rax,%rdi
  803caf:	48 b8 b4 3e 80 00 00 	movabs $0x803eb4,%rax
  803cb6:	00 00 00 
  803cb9:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803cbb:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803cc2:	00 00 00 
  803cc5:	48 8b 00             	mov    (%rax),%rax
  803cc8:	48 05 00 10 00 00    	add    $0x1000,%rax
  803cce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803cd2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803cd6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803cdc:	48 89 c2             	mov    %rax,%rdx
  803cdf:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ce6:	00 00 00 
  803ce9:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  803cec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  803cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cf7:	48 8d 50 04          	lea    0x4(%rax),%rdx
  803cfb:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803d02:	00 00 00 
  803d05:	48 8b 00             	mov    (%rax),%rax
  803d08:	48 89 d6             	mov    %rdx,%rsi
  803d0b:	48 89 c7             	mov    %rax,%rdi
  803d0e:	48 b8 a5 3a 80 00 00 	movabs $0x803aa5,%rax
  803d15:	00 00 00 
  803d18:	ff d0                	callq  *%rax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	75 72                	jne    803d90 <malloc+0x24d>
			break;
		mptr += PGSIZE;
  803d1e:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803d25:	00 00 00 
  803d28:	48 8b 00             	mov    (%rax),%rax
  803d2b:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  803d32:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803d39:	00 00 00 
  803d3c:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  803d3f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803d46:	00 00 00 
  803d49:	48 8b 10             	mov    (%rax),%rdx
  803d4c:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803d53:	00 00 00 
  803d56:	48 8b 00             	mov    (%rax),%rax
  803d59:	48 39 c2             	cmp    %rax,%rdx
  803d5c:	75 95                	jne    803cf3 <malloc+0x1b0>
			mptr = mbegin;
  803d5e:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803d65:	00 00 00 
  803d68:	48 8b 10             	mov    (%rax),%rdx
  803d6b:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803d72:	00 00 00 
  803d75:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  803d78:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  803d7c:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  803d80:	0f 85 6d ff ff ff    	jne    803cf3 <malloc+0x1b0>
				return 0;	/* out of address space */
  803d86:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8b:	e9 22 01 00 00       	jmpq   803eb2 <malloc+0x36f>
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
  803d90:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803d91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d98:	e9 a1 00 00 00       	jmpq   803e3e <malloc+0x2fb>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da0:	05 00 10 00 00       	add    $0x1000,%eax
  803da5:	48 98                	cltq   
  803da7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803dab:	48 83 c2 04          	add    $0x4,%rdx
  803daf:	48 39 d0             	cmp    %rdx,%rax
  803db2:	73 07                	jae    803dbb <malloc+0x278>
  803db4:	b8 00 04 00 00       	mov    $0x400,%eax
  803db9:	eb 05                	jmp    803dc0 <malloc+0x27d>
  803dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc0:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803dc3:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803dc6:	83 c8 07             	or     $0x7,%eax
  803dc9:	89 c2                	mov    %eax,%edx
  803dcb:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803dd2:	00 00 00 
  803dd5:	48 8b 08             	mov    (%rax),%rcx
  803dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddb:	48 98                	cltq   
  803ddd:	48 01 c8             	add    %rcx,%rax
  803de0:	48 89 c6             	mov    %rax,%rsi
  803de3:	bf 00 00 00 00       	mov    $0x0,%edi
  803de8:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  803def:	00 00 00 
  803df2:	ff d0                	callq  *%rax
  803df4:	85 c0                	test   %eax,%eax
  803df6:	79 3f                	jns    803e37 <malloc+0x2f4>
			for (; i >= 0; i -= PGSIZE)
  803df8:	eb 30                	jmp    803e2a <malloc+0x2e7>
				sys_page_unmap(0, mptr + i);
  803dfa:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803e01:	00 00 00 
  803e04:	48 8b 10             	mov    (%rax),%rdx
  803e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0a:	48 98                	cltq   
  803e0c:	48 01 d0             	add    %rdx,%rax
  803e0f:	48 89 c6             	mov    %rax,%rsi
  803e12:	bf 00 00 00 00       	mov    $0x0,%edi
  803e17:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  803e1e:	00 00 00 
  803e21:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  803e23:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  803e2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e2e:	79 ca                	jns    803dfa <malloc+0x2b7>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  803e30:	b8 00 00 00 00       	mov    $0x0,%eax
  803e35:	eb 7b                	jmp    803eb2 <malloc+0x36f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803e37:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e41:	48 98                	cltq   
  803e43:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803e47:	48 83 c2 04          	add    $0x4,%rdx
  803e4b:	48 39 d0             	cmp    %rdx,%rax
  803e4e:	0f 82 49 ff ff ff    	jb     803d9d <malloc+0x25a>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  803e54:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803e5b:	00 00 00 
  803e5e:	48 8b 00             	mov    (%rax),%rax
  803e61:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e64:	48 63 d2             	movslq %edx,%rdx
  803e67:	48 83 ea 04          	sub    $0x4,%rdx
  803e6b:	48 01 d0             	add    %rdx,%rax
  803e6e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  803e72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e76:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  803e7c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803e83:	00 00 00 
  803e86:	48 8b 00             	mov    (%rax),%rax
  803e89:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  803e8d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803e94:	00 00 00 
  803e97:	48 8b 10             	mov    (%rax),%rdx
  803e9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e9e:	48 01 c2             	add    %rax,%rdx
  803ea1:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803ea8:	00 00 00 
  803eab:	48 89 10             	mov    %rdx,(%rax)
	return v;
  803eae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  803eb2:	c9                   	leaveq 
  803eb3:	c3                   	retq   

0000000000803eb4 <free>:

void
free(void *v)
{
  803eb4:	55                   	push   %rbp
  803eb5:	48 89 e5             	mov    %rsp,%rbp
  803eb8:	48 83 ec 30          	sub    $0x30,%rsp
  803ebc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  803ec0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ec5:	0f 84 56 01 00 00    	je     804021 <free+0x16d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  803ecb:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803ed2:	00 00 00 
  803ed5:	48 8b 00             	mov    (%rax),%rax
  803ed8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803edc:	77 13                	ja     803ef1 <free+0x3d>
  803ede:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803ee5:	00 00 00 
  803ee8:	48 8b 00             	mov    (%rax),%rax
  803eeb:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803eef:	72 35                	jb     803f26 <free+0x72>
  803ef1:	48 b9 70 53 80 00 00 	movabs $0x805370,%rcx
  803ef8:	00 00 00 
  803efb:	48 ba 9e 53 80 00 00 	movabs $0x80539e,%rdx
  803f02:	00 00 00 
  803f05:	be 7b 00 00 00       	mov    $0x7b,%esi
  803f0a:	48 bf b3 53 80 00 00 	movabs $0x8053b3,%rdi
  803f11:	00 00 00 
  803f14:	b8 00 00 00 00       	mov    $0x0,%eax
  803f19:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  803f20:	00 00 00 
  803f23:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  803f26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f2a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  803f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f32:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803f38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803f3c:	eb 7b                	jmp    803fb9 <free+0x105>
		sys_page_unmap(0, c);
  803f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f42:	48 89 c6             	mov    %rax,%rsi
  803f45:	bf 00 00 00 00       	mov    $0x0,%edi
  803f4a:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  803f51:	00 00 00 
  803f54:	ff d0                	callq  *%rax
		c += PGSIZE;
  803f56:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f5d:	00 
		assert(mbegin <= c && c < mend);
  803f5e:	48 b8 d8 70 80 00 00 	movabs $0x8070d8,%rax
  803f65:	00 00 00 
  803f68:	48 8b 00             	mov    (%rax),%rax
  803f6b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803f6f:	77 13                	ja     803f84 <free+0xd0>
  803f71:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803f78:	00 00 00 
  803f7b:	48 8b 00             	mov    (%rax),%rax
  803f7e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803f82:	72 35                	jb     803fb9 <free+0x105>
  803f84:	48 b9 c0 53 80 00 00 	movabs $0x8053c0,%rcx
  803f8b:	00 00 00 
  803f8e:	48 ba 9e 53 80 00 00 	movabs $0x80539e,%rdx
  803f95:	00 00 00 
  803f98:	be 82 00 00 00       	mov    $0x82,%esi
  803f9d:	48 bf b3 53 80 00 00 	movabs $0x8053b3,%rdi
  803fa4:	00 00 00 
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fac:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  803fb3:	00 00 00 
  803fb6:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803fb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fbd:	48 c1 e8 0c          	shr    $0xc,%rax
  803fc1:	48 89 c2             	mov    %rax,%rdx
  803fc4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fcb:	01 00 00 
  803fce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fd2:	25 00 04 00 00       	and    $0x400,%eax
  803fd7:	48 85 c0             	test   %rax,%rax
  803fda:	0f 85 5e ff ff ff    	jne    803f3e <free+0x8a>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  803fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe4:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  803fea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  803fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ff2:	8b 00                	mov    (%rax),%eax
  803ff4:	8d 50 ff             	lea    -0x1(%rax),%edx
  803ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ffb:	89 10                	mov    %edx,(%rax)
  803ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804001:	8b 00                	mov    (%rax),%eax
  804003:	85 c0                	test   %eax,%eax
  804005:	75 1b                	jne    804022 <free+0x16e>
		sys_page_unmap(0, c);
  804007:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80400b:	48 89 c6             	mov    %rax,%rsi
  80400e:	bf 00 00 00 00       	mov    $0x0,%edi
  804013:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  80401a:	00 00 00 
  80401d:	ff d0                	callq  *%rax
  80401f:	eb 01                	jmp    804022 <free+0x16e>
{
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
		return;
  804021:	90                   	nop
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
		sys_page_unmap(0, c);
}
  804022:	c9                   	leaveq 
  804023:	c3                   	retq   

0000000000804024 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804024:	55                   	push   %rbp
  804025:	48 89 e5             	mov    %rsp,%rbp
  804028:	53                   	push   %rbx
  804029:	48 83 ec 38          	sub    $0x38,%rsp
  80402d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804031:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804035:	48 89 c7             	mov    %rax,%rdi
  804038:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  80403f:	00 00 00 
  804042:	ff d0                	callq  *%rax
  804044:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804047:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80404b:	0f 88 bf 01 00 00    	js     804210 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804051:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804055:	ba 07 04 00 00       	mov    $0x407,%edx
  80405a:	48 89 c6             	mov    %rax,%rsi
  80405d:	bf 00 00 00 00       	mov    $0x0,%edi
  804062:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  804069:	00 00 00 
  80406c:	ff d0                	callq  *%rax
  80406e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804071:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804075:	0f 88 95 01 00 00    	js     804210 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80407b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80407f:	48 89 c7             	mov    %rax,%rdi
  804082:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
  80408e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804091:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804095:	0f 88 5d 01 00 00    	js     8041f8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80409b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80409f:	ba 07 04 00 00       	mov    $0x407,%edx
  8040a4:	48 89 c6             	mov    %rax,%rsi
  8040a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ac:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
  8040b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040bf:	0f 88 33 01 00 00    	js     8041f8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8040c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c9:	48 89 c7             	mov    %rax,%rdi
  8040cc:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  8040d3:	00 00 00 
  8040d6:	ff d0                	callq  *%rax
  8040d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8040e5:	48 89 c6             	mov    %rax,%rsi
  8040e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ed:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8040f4:	00 00 00 
  8040f7:	ff d0                	callq  *%rax
  8040f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804100:	0f 88 d9 00 00 00    	js     8041df <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804106:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80410a:	48 89 c7             	mov    %rax,%rdi
  80410d:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  804114:	00 00 00 
  804117:	ff d0                	callq  *%rax
  804119:	48 89 c2             	mov    %rax,%rdx
  80411c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804120:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804126:	48 89 d1             	mov    %rdx,%rcx
  804129:	ba 00 00 00 00       	mov    $0x0,%edx
  80412e:	48 89 c6             	mov    %rax,%rsi
  804131:	bf 00 00 00 00       	mov    $0x0,%edi
  804136:	48 b8 be 1d 80 00 00 	movabs $0x801dbe,%rax
  80413d:	00 00 00 
  804140:	ff d0                	callq  *%rax
  804142:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804145:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804149:	78 79                	js     8041c4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80414b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80414f:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804156:	00 00 00 
  804159:	8b 12                	mov    (%rdx),%edx
  80415b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80415d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804161:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804168:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416c:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  804173:	00 00 00 
  804176:	8b 12                	mov    (%rdx),%edx
  804178:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80417a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80417e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804189:	48 89 c7             	mov    %rax,%rdi
  80418c:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  804193:	00 00 00 
  804196:	ff d0                	callq  *%rax
  804198:	89 c2                	mov    %eax,%edx
  80419a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80419e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8041a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041a4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8041a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041ac:	48 89 c7             	mov    %rax,%rdi
  8041af:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  8041b6:	00 00 00 
  8041b9:	ff d0                	callq  *%rax
  8041bb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8041bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8041c2:	eb 4f                	jmp    804213 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8041c4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8041c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c9:	48 89 c6             	mov    %rax,%rsi
  8041cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d1:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  8041d8:	00 00 00 
  8041db:	ff d0                	callq  *%rax
  8041dd:	eb 01                	jmp    8041e0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8041df:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8041e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e4:	48 89 c6             	mov    %rax,%rsi
  8041e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8041ec:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8041f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041fc:	48 89 c6             	mov    %rax,%rsi
  8041ff:	bf 00 00 00 00       	mov    $0x0,%edi
  804204:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  80420b:	00 00 00 
  80420e:	ff d0                	callq  *%rax
err:
	return r;
  804210:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804213:	48 83 c4 38          	add    $0x38,%rsp
  804217:	5b                   	pop    %rbx
  804218:	5d                   	pop    %rbp
  804219:	c3                   	retq   

000000000080421a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80421a:	55                   	push   %rbp
  80421b:	48 89 e5             	mov    %rsp,%rbp
  80421e:	53                   	push   %rbx
  80421f:	48 83 ec 28          	sub    $0x28,%rsp
  804223:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804227:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80422b:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  804232:	00 00 00 
  804235:	48 8b 00             	mov    (%rax),%rax
  804238:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80423e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804245:	48 89 c7             	mov    %rax,%rdi
  804248:	48 b8 ee 4a 80 00 00 	movabs $0x804aee,%rax
  80424f:	00 00 00 
  804252:	ff d0                	callq  *%rax
  804254:	89 c3                	mov    %eax,%ebx
  804256:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80425a:	48 89 c7             	mov    %rax,%rdi
  80425d:	48 b8 ee 4a 80 00 00 	movabs $0x804aee,%rax
  804264:	00 00 00 
  804267:	ff d0                	callq  *%rax
  804269:	39 c3                	cmp    %eax,%ebx
  80426b:	0f 94 c0             	sete   %al
  80426e:	0f b6 c0             	movzbl %al,%eax
  804271:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804274:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  80427b:	00 00 00 
  80427e:	48 8b 00             	mov    (%rax),%rax
  804281:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804287:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80428a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80428d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804290:	75 05                	jne    804297 <_pipeisclosed+0x7d>
			return ret;
  804292:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804295:	eb 4a                	jmp    8042e1 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804297:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80429a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80429d:	74 8c                	je     80422b <_pipeisclosed+0x11>
  80429f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8042a3:	75 86                	jne    80422b <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8042a5:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8042ac:	00 00 00 
  8042af:	48 8b 00             	mov    (%rax),%rax
  8042b2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8042b8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8042bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042be:	89 c6                	mov    %eax,%esi
  8042c0:	48 bf dd 53 80 00 00 	movabs $0x8053dd,%rdi
  8042c7:	00 00 00 
  8042ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8042cf:	49 b8 a6 08 80 00 00 	movabs $0x8008a6,%r8
  8042d6:	00 00 00 
  8042d9:	41 ff d0             	callq  *%r8
	}
  8042dc:	e9 4a ff ff ff       	jmpq   80422b <_pipeisclosed+0x11>

}
  8042e1:	48 83 c4 28          	add    $0x28,%rsp
  8042e5:	5b                   	pop    %rbx
  8042e6:	5d                   	pop    %rbp
  8042e7:	c3                   	retq   

00000000008042e8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8042e8:	55                   	push   %rbp
  8042e9:	48 89 e5             	mov    %rsp,%rbp
  8042ec:	48 83 ec 30          	sub    $0x30,%rsp
  8042f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042f3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8042f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042fa:	48 89 d6             	mov    %rdx,%rsi
  8042fd:	89 c7                	mov    %eax,%edi
  8042ff:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  804306:	00 00 00 
  804309:	ff d0                	callq  *%rax
  80430b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804312:	79 05                	jns    804319 <pipeisclosed+0x31>
		return r;
  804314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804317:	eb 31                	jmp    80434a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80431d:	48 89 c7             	mov    %rax,%rdi
  804320:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  804327:	00 00 00 
  80432a:	ff d0                	callq  *%rax
  80432c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804334:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804338:	48 89 d6             	mov    %rdx,%rsi
  80433b:	48 89 c7             	mov    %rax,%rdi
  80433e:	48 b8 1a 42 80 00 00 	movabs $0x80421a,%rax
  804345:	00 00 00 
  804348:	ff d0                	callq  *%rax
}
  80434a:	c9                   	leaveq 
  80434b:	c3                   	retq   

000000000080434c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80434c:	55                   	push   %rbp
  80434d:	48 89 e5             	mov    %rsp,%rbp
  804350:	48 83 ec 40          	sub    $0x40,%rsp
  804354:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804358:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80435c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804364:	48 89 c7             	mov    %rax,%rdi
  804367:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  80436e:	00 00 00 
  804371:	ff d0                	callq  *%rax
  804373:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804377:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80437b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80437f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804386:	00 
  804387:	e9 90 00 00 00       	jmpq   80441c <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80438c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804391:	74 09                	je     80439c <devpipe_read+0x50>
				return i;
  804393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804397:	e9 8e 00 00 00       	jmpq   80442a <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80439c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a4:	48 89 d6             	mov    %rdx,%rsi
  8043a7:	48 89 c7             	mov    %rax,%rdi
  8043aa:	48 b8 1a 42 80 00 00 	movabs $0x80421a,%rax
  8043b1:	00 00 00 
  8043b4:	ff d0                	callq  *%rax
  8043b6:	85 c0                	test   %eax,%eax
  8043b8:	74 07                	je     8043c1 <devpipe_read+0x75>
				return 0;
  8043ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8043bf:	eb 69                	jmp    80442a <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8043c1:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8043c8:	00 00 00 
  8043cb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8043cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d1:	8b 10                	mov    (%rax),%edx
  8043d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d7:	8b 40 04             	mov    0x4(%rax),%eax
  8043da:	39 c2                	cmp    %eax,%edx
  8043dc:	74 ae                	je     80438c <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8043de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8043ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ee:	8b 00                	mov    (%rax),%eax
  8043f0:	99                   	cltd   
  8043f1:	c1 ea 1b             	shr    $0x1b,%edx
  8043f4:	01 d0                	add    %edx,%eax
  8043f6:	83 e0 1f             	and    $0x1f,%eax
  8043f9:	29 d0                	sub    %edx,%eax
  8043fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043ff:	48 98                	cltq   
  804401:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804406:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80440c:	8b 00                	mov    (%rax),%eax
  80440e:	8d 50 01             	lea    0x1(%rax),%edx
  804411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804415:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804417:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80441c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804420:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804424:	72 a7                	jb     8043cd <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80442a:	c9                   	leaveq 
  80442b:	c3                   	retq   

000000000080442c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80442c:	55                   	push   %rbp
  80442d:	48 89 e5             	mov    %rsp,%rbp
  804430:	48 83 ec 40          	sub    $0x40,%rsp
  804434:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804438:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80443c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804444:	48 89 c7             	mov    %rax,%rdi
  804447:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  80444e:	00 00 00 
  804451:	ff d0                	callq  *%rax
  804453:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804457:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80445b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80445f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804466:	00 
  804467:	e9 8f 00 00 00       	jmpq   8044fb <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80446c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804474:	48 89 d6             	mov    %rdx,%rsi
  804477:	48 89 c7             	mov    %rax,%rdi
  80447a:	48 b8 1a 42 80 00 00 	movabs $0x80421a,%rax
  804481:	00 00 00 
  804484:	ff d0                	callq  *%rax
  804486:	85 c0                	test   %eax,%eax
  804488:	74 07                	je     804491 <devpipe_write+0x65>
				return 0;
  80448a:	b8 00 00 00 00       	mov    $0x0,%eax
  80448f:	eb 78                	jmp    804509 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804491:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  804498:	00 00 00 
  80449b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80449d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a1:	8b 40 04             	mov    0x4(%rax),%eax
  8044a4:	48 63 d0             	movslq %eax,%rdx
  8044a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ab:	8b 00                	mov    (%rax),%eax
  8044ad:	48 98                	cltq   
  8044af:	48 83 c0 20          	add    $0x20,%rax
  8044b3:	48 39 c2             	cmp    %rax,%rdx
  8044b6:	73 b4                	jae    80446c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8044b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bc:	8b 40 04             	mov    0x4(%rax),%eax
  8044bf:	99                   	cltd   
  8044c0:	c1 ea 1b             	shr    $0x1b,%edx
  8044c3:	01 d0                	add    %edx,%eax
  8044c5:	83 e0 1f             	and    $0x1f,%eax
  8044c8:	29 d0                	sub    %edx,%eax
  8044ca:	89 c6                	mov    %eax,%esi
  8044cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d4:	48 01 d0             	add    %rdx,%rax
  8044d7:	0f b6 08             	movzbl (%rax),%ecx
  8044da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044de:	48 63 c6             	movslq %esi,%rax
  8044e1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8044e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044e9:	8b 40 04             	mov    0x4(%rax),%eax
  8044ec:	8d 50 01             	lea    0x1(%rax),%edx
  8044ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8044f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804503:	72 98                	jb     80449d <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804509:	c9                   	leaveq 
  80450a:	c3                   	retq   

000000000080450b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80450b:	55                   	push   %rbp
  80450c:	48 89 e5             	mov    %rsp,%rbp
  80450f:	48 83 ec 20          	sub    $0x20,%rsp
  804513:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804517:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80451b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80451f:	48 89 c7             	mov    %rax,%rdi
  804522:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  804529:	00 00 00 
  80452c:	ff d0                	callq  *%rax
  80452e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804536:	48 be f0 53 80 00 00 	movabs $0x8053f0,%rsi
  80453d:	00 00 00 
  804540:	48 89 c7             	mov    %rax,%rdi
  804543:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  80454a:	00 00 00 
  80454d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80454f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804553:	8b 50 04             	mov    0x4(%rax),%edx
  804556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455a:	8b 00                	mov    (%rax),%eax
  80455c:	29 c2                	sub    %eax,%edx
  80455e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804562:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80456c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804573:	00 00 00 
	stat->st_dev = &devpipe;
  804576:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80457a:	48 b9 00 71 80 00 00 	movabs $0x807100,%rcx
  804581:	00 00 00 
  804584:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80458b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804590:	c9                   	leaveq 
  804591:	c3                   	retq   

0000000000804592 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804592:	55                   	push   %rbp
  804593:	48 89 e5             	mov    %rsp,%rbp
  804596:	48 83 ec 10          	sub    $0x10,%rsp
  80459a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80459e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045a2:	48 89 c6             	mov    %rax,%rsi
  8045a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8045aa:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  8045b1:	00 00 00 
  8045b4:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8045b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ba:	48 89 c7             	mov    %rax,%rdi
  8045bd:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  8045c4:	00 00 00 
  8045c7:	ff d0                	callq  *%rax
  8045c9:	48 89 c6             	mov    %rax,%rsi
  8045cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8045d1:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  8045d8:	00 00 00 
  8045db:	ff d0                	callq  *%rax
}
  8045dd:	c9                   	leaveq 
  8045de:	c3                   	retq   

00000000008045df <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8045df:	55                   	push   %rbp
  8045e0:	48 89 e5             	mov    %rsp,%rbp
  8045e3:	48 83 ec 20          	sub    $0x20,%rsp
  8045e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8045ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045ee:	75 35                	jne    804625 <wait+0x46>
  8045f0:	48 b9 f7 53 80 00 00 	movabs $0x8053f7,%rcx
  8045f7:	00 00 00 
  8045fa:	48 ba 02 54 80 00 00 	movabs $0x805402,%rdx
  804601:	00 00 00 
  804604:	be 0a 00 00 00       	mov    $0xa,%esi
  804609:	48 bf 17 54 80 00 00 	movabs $0x805417,%rdi
  804610:	00 00 00 
  804613:	b8 00 00 00 00       	mov    $0x0,%eax
  804618:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  80461f:	00 00 00 
  804622:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804625:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804628:	25 ff 03 00 00       	and    $0x3ff,%eax
  80462d:	48 98                	cltq   
  80462f:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804636:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80463d:	00 00 00 
  804640:	48 01 d0             	add    %rdx,%rax
  804643:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804647:	eb 0c                	jmp    804655 <wait+0x76>
		sys_yield();
  804649:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  804650:	00 00 00 
  804653:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804659:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80465f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804662:	75 0e                	jne    804672 <wait+0x93>
  804664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804668:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80466e:	85 c0                	test   %eax,%eax
  804670:	75 d7                	jne    804649 <wait+0x6a>
		sys_yield();
}
  804672:	90                   	nop
  804673:	c9                   	leaveq 
  804674:	c3                   	retq   

0000000000804675 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804675:	55                   	push   %rbp
  804676:	48 89 e5             	mov    %rsp,%rbp
  804679:	48 83 ec 20          	sub    $0x20,%rsp
  80467d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804680:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804683:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804686:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80468a:	be 01 00 00 00       	mov    $0x1,%esi
  80468f:	48 89 c7             	mov    %rax,%rdi
  804692:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  804699:	00 00 00 
  80469c:	ff d0                	callq  *%rax
}
  80469e:	90                   	nop
  80469f:	c9                   	leaveq 
  8046a0:	c3                   	retq   

00000000008046a1 <getchar>:

int
getchar(void)
{
  8046a1:	55                   	push   %rbp
  8046a2:	48 89 e5             	mov    %rsp,%rbp
  8046a5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8046a9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8046ad:	ba 01 00 00 00       	mov    $0x1,%edx
  8046b2:	48 89 c6             	mov    %rax,%rsi
  8046b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8046ba:	48 b8 7f 27 80 00 00 	movabs $0x80277f,%rax
  8046c1:	00 00 00 
  8046c4:	ff d0                	callq  *%rax
  8046c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8046c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046cd:	79 05                	jns    8046d4 <getchar+0x33>
		return r;
  8046cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d2:	eb 14                	jmp    8046e8 <getchar+0x47>
	if (r < 1)
  8046d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d8:	7f 07                	jg     8046e1 <getchar+0x40>
		return -E_EOF;
  8046da:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8046df:	eb 07                	jmp    8046e8 <getchar+0x47>
	return c;
  8046e1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8046e5:	0f b6 c0             	movzbl %al,%eax

}
  8046e8:	c9                   	leaveq 
  8046e9:	c3                   	retq   

00000000008046ea <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8046ea:	55                   	push   %rbp
  8046eb:	48 89 e5             	mov    %rsp,%rbp
  8046ee:	48 83 ec 20          	sub    $0x20,%rsp
  8046f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8046f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8046f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046fc:	48 89 d6             	mov    %rdx,%rsi
  8046ff:	89 c7                	mov    %eax,%edi
  804701:	48 b8 4a 23 80 00 00 	movabs $0x80234a,%rax
  804708:	00 00 00 
  80470b:	ff d0                	callq  *%rax
  80470d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804714:	79 05                	jns    80471b <iscons+0x31>
		return r;
  804716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804719:	eb 1a                	jmp    804735 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80471b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80471f:	8b 10                	mov    (%rax),%edx
  804721:	48 b8 40 71 80 00 00 	movabs $0x807140,%rax
  804728:	00 00 00 
  80472b:	8b 00                	mov    (%rax),%eax
  80472d:	39 c2                	cmp    %eax,%edx
  80472f:	0f 94 c0             	sete   %al
  804732:	0f b6 c0             	movzbl %al,%eax
}
  804735:	c9                   	leaveq 
  804736:	c3                   	retq   

0000000000804737 <opencons>:

int
opencons(void)
{
  804737:	55                   	push   %rbp
  804738:	48 89 e5             	mov    %rsp,%rbp
  80473b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80473f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804743:	48 89 c7             	mov    %rax,%rdi
  804746:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  80474d:	00 00 00 
  804750:	ff d0                	callq  *%rax
  804752:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804755:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804759:	79 05                	jns    804760 <opencons+0x29>
		return r;
  80475b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80475e:	eb 5b                	jmp    8047bb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804760:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804764:	ba 07 04 00 00       	mov    $0x407,%edx
  804769:	48 89 c6             	mov    %rax,%rsi
  80476c:	bf 00 00 00 00       	mov    $0x0,%edi
  804771:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  804778:	00 00 00 
  80477b:	ff d0                	callq  *%rax
  80477d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804780:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804784:	79 05                	jns    80478b <opencons+0x54>
		return r;
  804786:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804789:	eb 30                	jmp    8047bb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80478b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80478f:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804796:	00 00 00 
  804799:	8b 12                	mov    (%rdx),%edx
  80479b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80479d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8047a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047ac:	48 89 c7             	mov    %rax,%rdi
  8047af:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  8047b6:	00 00 00 
  8047b9:	ff d0                	callq  *%rax
}
  8047bb:	c9                   	leaveq 
  8047bc:	c3                   	retq   

00000000008047bd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8047bd:	55                   	push   %rbp
  8047be:	48 89 e5             	mov    %rsp,%rbp
  8047c1:	48 83 ec 30          	sub    $0x30,%rsp
  8047c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8047d1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047d6:	75 13                	jne    8047eb <devcons_read+0x2e>
		return 0;
  8047d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8047dd:	eb 49                	jmp    804828 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8047df:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8047e6:	00 00 00 
  8047e9:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8047eb:	48 b8 71 1c 80 00 00 	movabs $0x801c71,%rax
  8047f2:	00 00 00 
  8047f5:	ff d0                	callq  *%rax
  8047f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047fe:	74 df                	je     8047df <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804800:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804804:	79 05                	jns    80480b <devcons_read+0x4e>
		return c;
  804806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804809:	eb 1d                	jmp    804828 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80480b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80480f:	75 07                	jne    804818 <devcons_read+0x5b>
		return 0;
  804811:	b8 00 00 00 00       	mov    $0x0,%eax
  804816:	eb 10                	jmp    804828 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804818:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481b:	89 c2                	mov    %eax,%edx
  80481d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804821:	88 10                	mov    %dl,(%rax)
	return 1;
  804823:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804828:	c9                   	leaveq 
  804829:	c3                   	retq   

000000000080482a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80482a:	55                   	push   %rbp
  80482b:	48 89 e5             	mov    %rsp,%rbp
  80482e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804835:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80483c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804843:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80484a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804851:	eb 76                	jmp    8048c9 <devcons_write+0x9f>
		m = n - tot;
  804853:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80485a:	89 c2                	mov    %eax,%edx
  80485c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80485f:	29 c2                	sub    %eax,%edx
  804861:	89 d0                	mov    %edx,%eax
  804863:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804866:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804869:	83 f8 7f             	cmp    $0x7f,%eax
  80486c:	76 07                	jbe    804875 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80486e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804875:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804878:	48 63 d0             	movslq %eax,%rdx
  80487b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80487e:	48 63 c8             	movslq %eax,%rcx
  804881:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804888:	48 01 c1             	add    %rax,%rcx
  80488b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804892:	48 89 ce             	mov    %rcx,%rsi
  804895:	48 89 c7             	mov    %rax,%rdi
  804898:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  80489f:	00 00 00 
  8048a2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8048a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048a7:	48 63 d0             	movslq %eax,%rdx
  8048aa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8048b1:	48 89 d6             	mov    %rdx,%rsi
  8048b4:	48 89 c7             	mov    %rax,%rdi
  8048b7:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  8048be:	00 00 00 
  8048c1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8048c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048c6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8048c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048cc:	48 98                	cltq   
  8048ce:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8048d5:	0f 82 78 ff ff ff    	jb     804853 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8048db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8048de:	c9                   	leaveq 
  8048df:	c3                   	retq   

00000000008048e0 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8048e0:	55                   	push   %rbp
  8048e1:	48 89 e5             	mov    %rsp,%rbp
  8048e4:	48 83 ec 08          	sub    $0x8,%rsp
  8048e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8048ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048f1:	c9                   	leaveq 
  8048f2:	c3                   	retq   

00000000008048f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8048f3:	55                   	push   %rbp
  8048f4:	48 89 e5             	mov    %rsp,%rbp
  8048f7:	48 83 ec 10          	sub    $0x10,%rsp
  8048fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8048ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804907:	48 be 27 54 80 00 00 	movabs $0x805427,%rsi
  80490e:	00 00 00 
  804911:	48 89 c7             	mov    %rax,%rdi
  804914:	48 b8 36 14 80 00 00 	movabs $0x801436,%rax
  80491b:	00 00 00 
  80491e:	ff d0                	callq  *%rax
	return 0;
  804920:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804925:	c9                   	leaveq 
  804926:	c3                   	retq   

0000000000804927 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804927:	55                   	push   %rbp
  804928:	48 89 e5             	mov    %rsp,%rbp
  80492b:	48 83 ec 30          	sub    $0x30,%rsp
  80492f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804933:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804937:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80493b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804940:	75 0e                	jne    804950 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804942:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804949:	00 00 00 
  80494c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804950:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804954:	48 89 c7             	mov    %rax,%rdi
  804957:	48 b8 a6 1f 80 00 00 	movabs $0x801fa6,%rax
  80495e:	00 00 00 
  804961:	ff d0                	callq  *%rax
  804963:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804966:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80496a:	79 27                	jns    804993 <ipc_recv+0x6c>
		if (from_env_store)
  80496c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804971:	74 0a                	je     80497d <ipc_recv+0x56>
			*from_env_store = 0;
  804973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804977:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80497d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804982:	74 0a                	je     80498e <ipc_recv+0x67>
			*perm_store = 0;
  804984:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804988:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80498e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804991:	eb 53                	jmp    8049e6 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804993:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804998:	74 19                	je     8049b3 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80499a:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8049a1:	00 00 00 
  8049a4:	48 8b 00             	mov    (%rax),%rax
  8049a7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8049ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049b1:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8049b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049b8:	74 19                	je     8049d3 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8049ba:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8049c1:	00 00 00 
  8049c4:	48 8b 00             	mov    (%rax),%rax
  8049c7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8049cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049d1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8049d3:	48 b8 28 80 80 00 00 	movabs $0x808028,%rax
  8049da:	00 00 00 
  8049dd:	48 8b 00             	mov    (%rax),%rax
  8049e0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8049e6:	c9                   	leaveq 
  8049e7:	c3                   	retq   

00000000008049e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8049e8:	55                   	push   %rbp
  8049e9:	48 89 e5             	mov    %rsp,%rbp
  8049ec:	48 83 ec 30          	sub    $0x30,%rsp
  8049f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8049f3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8049f6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8049fa:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8049fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a02:	75 1c                	jne    804a20 <ipc_send+0x38>
		pg = (void*) UTOP;
  804a04:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a0b:	00 00 00 
  804a0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804a12:	eb 0c                	jmp    804a20 <ipc_send+0x38>
		sys_yield();
  804a14:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  804a1b:	00 00 00 
  804a1e:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804a20:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a23:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804a26:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a2d:	89 c7                	mov    %eax,%edi
  804a2f:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  804a36:	00 00 00 
  804a39:	ff d0                	callq  *%rax
  804a3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a3e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804a42:	74 d0                	je     804a14 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a48:	79 30                	jns    804a7a <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a4d:	89 c1                	mov    %eax,%ecx
  804a4f:	48 ba 2e 54 80 00 00 	movabs $0x80542e,%rdx
  804a56:	00 00 00 
  804a59:	be 47 00 00 00       	mov    $0x47,%esi
  804a5e:	48 bf 44 54 80 00 00 	movabs $0x805444,%rdi
  804a65:	00 00 00 
  804a68:	b8 00 00 00 00       	mov    $0x0,%eax
  804a6d:	49 b8 6c 06 80 00 00 	movabs $0x80066c,%r8
  804a74:	00 00 00 
  804a77:	41 ff d0             	callq  *%r8

}
  804a7a:	90                   	nop
  804a7b:	c9                   	leaveq 
  804a7c:	c3                   	retq   

0000000000804a7d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a7d:	55                   	push   %rbp
  804a7e:	48 89 e5             	mov    %rsp,%rbp
  804a81:	48 83 ec 18          	sub    $0x18,%rsp
  804a85:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a8f:	eb 4d                	jmp    804ade <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804a91:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a98:	00 00 00 
  804a9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9e:	48 98                	cltq   
  804aa0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804aa7:	48 01 d0             	add    %rdx,%rax
  804aaa:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804ab0:	8b 00                	mov    (%rax),%eax
  804ab2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ab5:	75 23                	jne    804ada <ipc_find_env+0x5d>
			return envs[i].env_id;
  804ab7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804abe:	00 00 00 
  804ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ac4:	48 98                	cltq   
  804ac6:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804acd:	48 01 d0             	add    %rdx,%rax
  804ad0:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804ad6:	8b 00                	mov    (%rax),%eax
  804ad8:	eb 12                	jmp    804aec <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804ada:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ade:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804ae5:	7e aa                	jle    804a91 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804aec:	c9                   	leaveq 
  804aed:	c3                   	retq   

0000000000804aee <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804aee:	55                   	push   %rbp
  804aef:	48 89 e5             	mov    %rsp,%rbp
  804af2:	48 83 ec 18          	sub    $0x18,%rsp
  804af6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804afe:	48 c1 e8 15          	shr    $0x15,%rax
  804b02:	48 89 c2             	mov    %rax,%rdx
  804b05:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b0c:	01 00 00 
  804b0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b13:	83 e0 01             	and    $0x1,%eax
  804b16:	48 85 c0             	test   %rax,%rax
  804b19:	75 07                	jne    804b22 <pageref+0x34>
		return 0;
  804b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b20:	eb 56                	jmp    804b78 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b26:	48 c1 e8 0c          	shr    $0xc,%rax
  804b2a:	48 89 c2             	mov    %rax,%rdx
  804b2d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b34:	01 00 00 
  804b37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b43:	83 e0 01             	and    $0x1,%eax
  804b46:	48 85 c0             	test   %rax,%rax
  804b49:	75 07                	jne    804b52 <pageref+0x64>
		return 0;
  804b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b50:	eb 26                	jmp    804b78 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b56:	48 c1 e8 0c          	shr    $0xc,%rax
  804b5a:	48 89 c2             	mov    %rax,%rdx
  804b5d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b64:	00 00 00 
  804b67:	48 c1 e2 04          	shl    $0x4,%rdx
  804b6b:	48 01 d0             	add    %rdx,%rax
  804b6e:	48 83 c0 08          	add    $0x8,%rax
  804b72:	0f b7 00             	movzwl (%rax),%eax
  804b75:	0f b7 c0             	movzwl %ax,%eax
}
  804b78:	c9                   	leaveq 
  804b79:	c3                   	retq   
