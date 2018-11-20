
vmm/guest/obj/user/testshell:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 00 59 80 00 00 	movabs $0x805900,%rdi
  800098:	00 00 00 
  80009b:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 0d 59 80 00 00 	movabs $0x80590d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 14 00 00 00       	mov    $0x14,%esi
  8000c4:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 9f 4d 80 00 00 	movabs $0x804d9f,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 34 59 80 00 00 	movabs $0x805934,%rdx
  800108:	00 00 00 
  80010b:	be 16 00 00 00       	mov    $0x16,%esi
  800110:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf 40 59 80 00 00 	movabs $0x805940,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 7b 27 80 00 00 	movabs $0x80277b,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 64 59 80 00 00 	movabs $0x805964,%rdx
  80016e:	00 00 00 
  800171:	be 1b 00 00 00       	mov    $0x1b,%esi
  800176:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 6d 59 80 00 00 	movabs $0x80596d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 70 59 80 00 00 	movabs $0x805970,%rsi
  800200:	00 00 00 
  800203:	48 bf 73 59 80 00 00 	movabs $0x805973,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 7d 3d 80 00 00 	movabs $0x803d7d,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 7b 59 80 00 00 	movabs $0x80597b,%rdx
  800234:	00 00 00 
  800237:	be 22 00 00 00       	mov    $0x22,%esi
  80023c:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 5a 53 80 00 00 	movabs $0x80535a,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 85 59 80 00 00 	movabs $0x805985,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 98 59 80 00 00 	movabs $0x805998,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002f7:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba bb 59 80 00 00 	movabs $0x8059bb,%rdx
  800373:	00 00 00 
  800376:	be 34 00 00 00       	mov    $0x34,%esi
  80037b:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba d5 59 80 00 00 	movabs $0x8059d5,%rdx
  8003a9:	00 00 00 
  8003ac:	be 36 00 00 00       	mov    $0x36,%esi
  8003b1:	48 bf 23 59 80 00 00 	movabs $0x805923,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 06                	jne    8003d9 <umain+0x396>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	74 4b                	je     800424 <umain+0x3e1>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003d9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003dd:	75 12                	jne    8003f1 <umain+0x3ae>
  8003df:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e3:	75 0c                	jne    8003f1 <umain+0x3ae>
  8003e5:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003e9:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ed:	38 c2                	cmp    %al,%dl
  8003ef:	74 19                	je     80040a <umain+0x3c7>
			wrong(rfd, kfd, nloff);
  8003f1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fa:	89 ce                	mov    %ecx,%esi
  8003fc:	89 c7                	mov    %eax,%edi
  8003fe:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040a:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80040e:	3c 0a                	cmp    $0xa,%al
  800410:	75 09                	jne    80041b <umain+0x3d8>
			nloff = off+1;
  800412:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800415:	83 c0 01             	add    $0x1,%eax
  800418:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  80041f:	e9 fd fe ff ff       	jmpq   800321 <umain+0x2de>
		if (n1 < 0)
			panic("reading testshell.out: %e", n1);
		if (n2 < 0)
			panic("reading testshell.key: %e", n2);
		if (n1 == 0 && n2 == 0)
			break;
  800424:	90                   	nop
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
	cprintf("shell ran correctly\n");
  800425:	48 bf ef 59 80 00 00 	movabs $0x8059ef,%rdi
  80042c:	00 00 00 
  80042f:	b8 00 00 00 00       	mov    $0x0,%eax
  800434:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  80043b:	00 00 00 
  80043e:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800440:	cc                   	int3   

	breakpoint();
}
  800441:	90                   	nop
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 2c 31 80 00 00 	movabs $0x80312c,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 2c 31 80 00 00 	movabs $0x80312c,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 08 5a 80 00 00 	movabs $0x805a08,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 2a 5a 80 00 00 	movabs $0x805a2a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 39 5a 80 00 00 	movabs $0x805a39,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf 47 5a 80 00 00 	movabs $0x805a47,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	90                   	nop
  800582:	c9                   	leaveq 
  800583:	c3                   	retq   

0000000000800584 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800584:	55                   	push   %rbp
  800585:	48 89 e5             	mov    %rsp,%rbp
  800588:	48 83 ec 20          	sub    $0x20,%rsp
  80058c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800592:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800595:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800599:	be 01 00 00 00       	mov    $0x1,%esi
  80059e:	48 89 c7             	mov    %rax,%rdi
  8005a1:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  8005a8:	00 00 00 
  8005ab:	ff d0                	callq  *%rax
}
  8005ad:	90                   	nop
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <getchar>:

int
getchar(void)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
  8005b4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005bc:	ba 01 00 00 00       	mov    $0x1,%edx
  8005c1:	48 89 c6             	mov    %rax,%rsi
  8005c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c9:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  8005d0:	00 00 00 
  8005d3:	ff d0                	callq  *%rax
  8005d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005dc:	79 05                	jns    8005e3 <getchar+0x33>
		return r;
  8005de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e1:	eb 14                	jmp    8005f7 <getchar+0x47>
	if (r < 1)
  8005e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e7:	7f 07                	jg     8005f0 <getchar+0x40>
		return -E_EOF;
  8005e9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ee:	eb 07                	jmp    8005f7 <getchar+0x47>
	return c;
  8005f0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f4:	0f b6 c0             	movzbl %al,%eax

}
  8005f7:	c9                   	leaveq 
  8005f8:	c3                   	retq   

00000000008005f9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f9:	55                   	push   %rbp
  8005fa:	48 89 e5             	mov    %rsp,%rbp
  8005fd:	48 83 ec 20          	sub    $0x20,%rsp
  800601:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800604:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800608:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80060b:	48 89 d6             	mov    %rdx,%rsi
  80060e:	89 c7                	mov    %eax,%edi
  800610:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  800617:	00 00 00 
  80061a:	ff d0                	callq  *%rax
  80061c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800623:	79 05                	jns    80062a <iscons+0x31>
		return r;
  800625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800628:	eb 1a                	jmp    800644 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80062a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062e:	8b 10                	mov    (%rax),%edx
  800630:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800637:	00 00 00 
  80063a:	8b 00                	mov    (%rax),%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	0f 94 c0             	sete   %al
  800641:	0f b6 c0             	movzbl %al,%eax
}
  800644:	c9                   	leaveq 
  800645:	c3                   	retq   

0000000000800646 <opencons>:

int
opencons(void)
{
  800646:	55                   	push   %rbp
  800647:	48 89 e5             	mov    %rsp,%rbp
  80064a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800652:	48 89 c7             	mov    %rax,%rdi
  800655:	48 b8 40 2a 80 00 00 	movabs $0x802a40,%rax
  80065c:	00 00 00 
  80065f:	ff d0                	callq  *%rax
  800661:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800664:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800668:	79 05                	jns    80066f <opencons+0x29>
		return r;
  80066a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066d:	eb 5b                	jmp    8006ca <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800673:	ba 07 04 00 00       	mov    $0x407,%edx
  800678:	48 89 c6             	mov    %rax,%rsi
  80067b:	bf 00 00 00 00       	mov    $0x0,%edi
  800680:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  800687:	00 00 00 
  80068a:	ff d0                	callq  *%rax
  80068c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800693:	79 05                	jns    80069a <opencons+0x54>
		return r;
  800695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800698:	eb 30                	jmp    8006ca <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80069a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8006a5:	00 00 00 
  8006a8:	8b 12                	mov    (%rdx),%edx
  8006aa:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006bb:	48 89 c7             	mov    %rax,%rdi
  8006be:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  8006c5:	00 00 00 
  8006c8:	ff d0                	callq  *%rax
}
  8006ca:	c9                   	leaveq 
  8006cb:	c3                   	retq   

00000000008006cc <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006cc:	55                   	push   %rbp
  8006cd:	48 89 e5             	mov    %rsp,%rbp
  8006d0:	48 83 ec 30          	sub    $0x30,%rsp
  8006d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e5:	75 13                	jne    8006fa <devcons_read+0x2e>
		return 0;
  8006e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ec:	eb 49                	jmp    800737 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8006ee:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 e3 1e 80 00 00 	movabs $0x801ee3,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x4e>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5b>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6b>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be 51 5a 80 00 00 	movabs $0x805a51,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800845:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	25 ff 03 00 00       	and    $0x3ff,%eax
  800856:	48 98                	cltq   
  800858:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80085f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800866:	00 00 00 
  800869:	48 01 c2             	add    %rax,%rdx
  80086c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800873:	00 00 00 
  800876:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800879:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80087d:	7e 14                	jle    800893 <libmain+0x5d>
		binaryname = argv[0];
  80087f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800883:	48 8b 10             	mov    (%rax),%rdx
  800886:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  80088d:	00 00 00 
  800890:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800893:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 c7                	mov    %eax,%edi
  80089f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008a6:	00 00 00 
  8008a9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008ab:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  8008b2:	00 00 00 
  8008b5:	ff d0                	callq  *%rax
}
  8008b7:	90                   	nop
  8008b8:	c9                   	leaveq 
  8008b9:	c3                   	retq   

00000000008008ba <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008ba:	55                   	push   %rbp
  8008bb:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8008be:	48 b8 35 2d 80 00 00 	movabs $0x802d35,%rax
  8008c5:	00 00 00 
  8008c8:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8008ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8008cf:	48 b8 1f 1f 80 00 00 	movabs $0x801f1f,%rax
  8008d6:	00 00 00 
  8008d9:	ff d0                	callq  *%rax
}
  8008db:	90                   	nop
  8008dc:	5d                   	pop    %rbp
  8008dd:	c3                   	retq   

00000000008008de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008de:	55                   	push   %rbp
  8008df:	48 89 e5             	mov    %rsp,%rbp
  8008e2:	53                   	push   %rbx
  8008e3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008ea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008f1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8008f7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8008fe:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800905:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80090c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800913:	84 c0                	test   %al,%al
  800915:	74 23                	je     80093a <_panic+0x5c>
  800917:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80091e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800922:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800926:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80092a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80092e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800932:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800936:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80093a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800941:	00 00 00 
  800944:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80094b:	00 00 00 
  80094e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800952:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800959:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800960:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800967:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  80096e:	00 00 00 
  800971:	48 8b 18             	mov    (%rax),%rbx
  800974:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  80097b:	00 00 00 
  80097e:	ff d0                	callq  *%rax
  800980:	89 c6                	mov    %eax,%esi
  800982:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800988:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80098f:	41 89 d0             	mov    %edx,%r8d
  800992:	48 89 c1             	mov    %rax,%rcx
  800995:	48 89 da             	mov    %rbx,%rdx
  800998:	48 bf 68 5a 80 00 00 	movabs $0x805a68,%rdi
  80099f:	00 00 00 
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a7:	49 b9 18 0b 80 00 00 	movabs $0x800b18,%r9
  8009ae:	00 00 00 
  8009b1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009b4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009bb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009c2:	48 89 d6             	mov    %rdx,%rsi
  8009c5:	48 89 c7             	mov    %rax,%rdi
  8009c8:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  8009cf:	00 00 00 
  8009d2:	ff d0                	callq  *%rax
	cprintf("\n");
  8009d4:	48 bf 8b 5a 80 00 00 	movabs $0x805a8b,%rdi
  8009db:	00 00 00 
  8009de:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e3:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  8009ea:	00 00 00 
  8009ed:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009ef:	cc                   	int3   
  8009f0:	eb fd                	jmp    8009ef <_panic+0x111>

00000000008009f2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009f2:	55                   	push   %rbp
  8009f3:	48 89 e5             	mov    %rsp,%rbp
  8009f6:	48 83 ec 10          	sub    $0x10,%rsp
  8009fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8009fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a05:	8b 00                	mov    (%rax),%eax
  800a07:	8d 48 01             	lea    0x1(%rax),%ecx
  800a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a0e:	89 0a                	mov    %ecx,(%rdx)
  800a10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a13:	89 d1                	mov    %edx,%ecx
  800a15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a19:	48 98                	cltq   
  800a1b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a23:	8b 00                	mov    (%rax),%eax
  800a25:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a2a:	75 2c                	jne    800a58 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a30:	8b 00                	mov    (%rax),%eax
  800a32:	48 98                	cltq   
  800a34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a38:	48 83 c2 08          	add    $0x8,%rdx
  800a3c:	48 89 c6             	mov    %rax,%rsi
  800a3f:	48 89 d7             	mov    %rdx,%rdi
  800a42:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  800a49:	00 00 00 
  800a4c:	ff d0                	callq  *%rax
        b->idx = 0;
  800a4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a52:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5c:	8b 40 04             	mov    0x4(%rax),%eax
  800a5f:	8d 50 01             	lea    0x1(%rax),%edx
  800a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a66:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a69:	90                   	nop
  800a6a:	c9                   	leaveq 
  800a6b:	c3                   	retq   

0000000000800a6c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a6c:	55                   	push   %rbp
  800a6d:	48 89 e5             	mov    %rsp,%rbp
  800a70:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a77:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a7e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a85:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a8c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a93:	48 8b 0a             	mov    (%rdx),%rcx
  800a96:	48 89 08             	mov    %rcx,(%rax)
  800a99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aa1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aa5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800aa9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ab0:	00 00 00 
    b.cnt = 0;
  800ab3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800aba:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800abd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ac4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800acb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ad2:	48 89 c6             	mov    %rax,%rsi
  800ad5:	48 bf f2 09 80 00 00 	movabs $0x8009f2,%rdi
  800adc:	00 00 00 
  800adf:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  800ae6:	00 00 00 
  800ae9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800aeb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800af1:	48 98                	cltq   
  800af3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800afa:	48 83 c2 08          	add    $0x8,%rdx
  800afe:	48 89 c6             	mov    %rax,%rsi
  800b01:	48 89 d7             	mov    %rdx,%rdi
  800b04:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  800b0b:	00 00 00 
  800b0e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b10:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b16:	c9                   	leaveq 
  800b17:	c3                   	retq   

0000000000800b18 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b18:	55                   	push   %rbp
  800b19:	48 89 e5             	mov    %rsp,%rbp
  800b1c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b23:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800b2a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b31:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b38:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b3f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b46:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b4d:	84 c0                	test   %al,%al
  800b4f:	74 20                	je     800b71 <cprintf+0x59>
  800b51:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b55:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b59:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b5d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b61:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b65:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b69:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b6d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b71:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b78:	00 00 00 
  800b7b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b82:	00 00 00 
  800b85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b89:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b90:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b97:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800b9e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ba5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bac:	48 8b 0a             	mov    (%rdx),%rcx
  800baf:	48 89 08             	mov    %rcx,(%rax)
  800bb2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bb6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bbe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bc2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bc9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bd0:	48 89 d6             	mov    %rdx,%rsi
  800bd3:	48 89 c7             	mov    %rax,%rdi
  800bd6:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  800bdd:	00 00 00 
  800be0:	ff d0                	callq  *%rax
  800be2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800be8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bee:	c9                   	leaveq 
  800bef:	c3                   	retq   

0000000000800bf0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bf0:	55                   	push   %rbp
  800bf1:	48 89 e5             	mov    %rsp,%rbp
  800bf4:	48 83 ec 30          	sub    $0x30,%rsp
  800bf8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800bfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c00:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800c04:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800c07:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800c0b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c0f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c12:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800c16:	77 54                	ja     800c6c <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c18:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c1b:	8d 78 ff             	lea    -0x1(%rax),%edi
  800c1e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	48 f7 f6             	div    %rsi
  800c2d:	49 89 c2             	mov    %rax,%r10
  800c30:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800c33:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c36:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800c3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c3e:	41 89 c9             	mov    %ecx,%r9d
  800c41:	41 89 f8             	mov    %edi,%r8d
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	4c 89 d2             	mov    %r10,%rdx
  800c49:	48 89 c7             	mov    %rax,%rdi
  800c4c:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  800c53:	00 00 00 
  800c56:	ff d0                	callq  *%rax
  800c58:	eb 1c                	jmp    800c76 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c5a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c5e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c65:	48 89 ce             	mov    %rcx,%rsi
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c6c:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800c70:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800c74:	7f e4                	jg     800c5a <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c76:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c82:	48 f7 f1             	div    %rcx
  800c85:	48 b8 90 5c 80 00 00 	movabs $0x805c90,%rax
  800c8c:	00 00 00 
  800c8f:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800c93:	0f be d0             	movsbl %al,%edx
  800c96:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c9e:	48 89 ce             	mov    %rcx,%rsi
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	ff d0                	callq  *%rax
}
  800ca5:	90                   	nop
  800ca6:	c9                   	leaveq 
  800ca7:	c3                   	retq   

0000000000800ca8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ca8:	55                   	push   %rbp
  800ca9:	48 89 e5             	mov    %rsp,%rbp
  800cac:	48 83 ec 20          	sub    $0x20,%rsp
  800cb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cb4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cb7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cbb:	7e 4f                	jle    800d0c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc1:	8b 00                	mov    (%rax),%eax
  800cc3:	83 f8 30             	cmp    $0x30,%eax
  800cc6:	73 24                	jae    800cec <getuint+0x44>
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd4:	8b 00                	mov    (%rax),%eax
  800cd6:	89 c0                	mov    %eax,%eax
  800cd8:	48 01 d0             	add    %rdx,%rax
  800cdb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdf:	8b 12                	mov    (%rdx),%edx
  800ce1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ce4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce8:	89 0a                	mov    %ecx,(%rdx)
  800cea:	eb 14                	jmp    800d00 <getuint+0x58>
  800cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cf4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800cf8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d00:	48 8b 00             	mov    (%rax),%rax
  800d03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d07:	e9 9d 00 00 00       	jmpq   800da9 <getuint+0x101>
	else if (lflag)
  800d0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d10:	74 4c                	je     800d5e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800d12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d16:	8b 00                	mov    (%rax),%eax
  800d18:	83 f8 30             	cmp    $0x30,%eax
  800d1b:	73 24                	jae    800d41 <getuint+0x99>
  800d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d21:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d29:	8b 00                	mov    (%rax),%eax
  800d2b:	89 c0                	mov    %eax,%eax
  800d2d:	48 01 d0             	add    %rdx,%rax
  800d30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d34:	8b 12                	mov    (%rdx),%edx
  800d36:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3d:	89 0a                	mov    %ecx,(%rdx)
  800d3f:	eb 14                	jmp    800d55 <getuint+0xad>
  800d41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d45:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d49:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d51:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d55:	48 8b 00             	mov    (%rax),%rax
  800d58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d5c:	eb 4b                	jmp    800da9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800d5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d62:	8b 00                	mov    (%rax),%eax
  800d64:	83 f8 30             	cmp    $0x30,%eax
  800d67:	73 24                	jae    800d8d <getuint+0xe5>
  800d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d6d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d75:	8b 00                	mov    (%rax),%eax
  800d77:	89 c0                	mov    %eax,%eax
  800d79:	48 01 d0             	add    %rdx,%rax
  800d7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d80:	8b 12                	mov    (%rdx),%edx
  800d82:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d89:	89 0a                	mov    %ecx,(%rdx)
  800d8b:	eb 14                	jmp    800da1 <getuint+0xf9>
  800d8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d91:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d95:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800da1:	8b 00                	mov    (%rax),%eax
  800da3:	89 c0                	mov    %eax,%eax
  800da5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dad:	c9                   	leaveq 
  800dae:	c3                   	retq   

0000000000800daf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800daf:	55                   	push   %rbp
  800db0:	48 89 e5             	mov    %rsp,%rbp
  800db3:	48 83 ec 20          	sub    $0x20,%rsp
  800db7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dbb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dbe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dc2:	7e 4f                	jle    800e13 <getint+0x64>
		x=va_arg(*ap, long long);
  800dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc8:	8b 00                	mov    (%rax),%eax
  800dca:	83 f8 30             	cmp    $0x30,%eax
  800dcd:	73 24                	jae    800df3 <getint+0x44>
  800dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddb:	8b 00                	mov    (%rax),%eax
  800ddd:	89 c0                	mov    %eax,%eax
  800ddf:	48 01 d0             	add    %rdx,%rax
  800de2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800de6:	8b 12                	mov    (%rdx),%edx
  800de8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800deb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800def:	89 0a                	mov    %ecx,(%rdx)
  800df1:	eb 14                	jmp    800e07 <getint+0x58>
  800df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dfb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800dff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e03:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e07:	48 8b 00             	mov    (%rax),%rax
  800e0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e0e:	e9 9d 00 00 00       	jmpq   800eb0 <getint+0x101>
	else if (lflag)
  800e13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e17:	74 4c                	je     800e65 <getint+0xb6>
		x=va_arg(*ap, long);
  800e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1d:	8b 00                	mov    (%rax),%eax
  800e1f:	83 f8 30             	cmp    $0x30,%eax
  800e22:	73 24                	jae    800e48 <getint+0x99>
  800e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e28:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e30:	8b 00                	mov    (%rax),%eax
  800e32:	89 c0                	mov    %eax,%eax
  800e34:	48 01 d0             	add    %rdx,%rax
  800e37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e3b:	8b 12                	mov    (%rdx),%edx
  800e3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e44:	89 0a                	mov    %ecx,(%rdx)
  800e46:	eb 14                	jmp    800e5c <getint+0xad>
  800e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e50:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e58:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e5c:	48 8b 00             	mov    (%rax),%rax
  800e5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e63:	eb 4b                	jmp    800eb0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e69:	8b 00                	mov    (%rax),%eax
  800e6b:	83 f8 30             	cmp    $0x30,%eax
  800e6e:	73 24                	jae    800e94 <getint+0xe5>
  800e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e74:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7c:	8b 00                	mov    (%rax),%eax
  800e7e:	89 c0                	mov    %eax,%eax
  800e80:	48 01 d0             	add    %rdx,%rax
  800e83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e87:	8b 12                	mov    (%rdx),%edx
  800e89:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e90:	89 0a                	mov    %ecx,(%rdx)
  800e92:	eb 14                	jmp    800ea8 <getint+0xf9>
  800e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e98:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e9c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ea0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ea8:	8b 00                	mov    (%rax),%eax
  800eaa:	48 98                	cltq   
  800eac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800eb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eb4:	c9                   	leaveq 
  800eb5:	c3                   	retq   

0000000000800eb6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb6:	55                   	push   %rbp
  800eb7:	48 89 e5             	mov    %rsp,%rbp
  800eba:	41 54                	push   %r12
  800ebc:	53                   	push   %rbx
  800ebd:	48 83 ec 60          	sub    $0x60,%rsp
  800ec1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ec5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ec9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ecd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ed1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ed9:	48 8b 0a             	mov    (%rdx),%rcx
  800edc:	48 89 08             	mov    %rcx,(%rax)
  800edf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eeb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eef:	eb 17                	jmp    800f08 <vprintfmt+0x52>
			if (ch == '\0')
  800ef1:	85 db                	test   %ebx,%ebx
  800ef3:	0f 84 b9 04 00 00    	je     8013b2 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800ef9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f01:	48 89 d6             	mov    %rdx,%rsi
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f08:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f10:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f14:	0f b6 00             	movzbl (%rax),%eax
  800f17:	0f b6 d8             	movzbl %al,%ebx
  800f1a:	83 fb 25             	cmp    $0x25,%ebx
  800f1d:	75 d2                	jne    800ef1 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f1f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f23:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f2a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f38:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f3f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f4b:	0f b6 00             	movzbl (%rax),%eax
  800f4e:	0f b6 d8             	movzbl %al,%ebx
  800f51:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f54:	83 f8 55             	cmp    $0x55,%eax
  800f57:	0f 87 22 04 00 00    	ja     80137f <vprintfmt+0x4c9>
  800f5d:	89 c0                	mov    %eax,%eax
  800f5f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f66:	00 
  800f67:	48 b8 b8 5c 80 00 00 	movabs $0x805cb8,%rax
  800f6e:	00 00 00 
  800f71:	48 01 d0             	add    %rdx,%rax
  800f74:	48 8b 00             	mov    (%rax),%rax
  800f77:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f79:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f7d:	eb c0                	jmp    800f3f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f7f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f83:	eb ba                	jmp    800f3f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f85:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800f8c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800f8f:	89 d0                	mov    %edx,%eax
  800f91:	c1 e0 02             	shl    $0x2,%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	01 c0                	add    %eax,%eax
  800f98:	01 d8                	add    %ebx,%eax
  800f9a:	83 e8 30             	sub    $0x30,%eax
  800f9d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fa0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fa4:	0f b6 00             	movzbl (%rax),%eax
  800fa7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800faa:	83 fb 2f             	cmp    $0x2f,%ebx
  800fad:	7e 60                	jle    80100f <vprintfmt+0x159>
  800faf:	83 fb 39             	cmp    $0x39,%ebx
  800fb2:	7f 5b                	jg     80100f <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fb4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fb9:	eb d1                	jmp    800f8c <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800fbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fbe:	83 f8 30             	cmp    $0x30,%eax
  800fc1:	73 17                	jae    800fda <vprintfmt+0x124>
  800fc3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fca:	89 d2                	mov    %edx,%edx
  800fcc:	48 01 d0             	add    %rdx,%rax
  800fcf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fd2:	83 c2 08             	add    $0x8,%edx
  800fd5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fd8:	eb 0c                	jmp    800fe6 <vprintfmt+0x130>
  800fda:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fde:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fe2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fe6:	8b 00                	mov    (%rax),%eax
  800fe8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800feb:	eb 23                	jmp    801010 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800fed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ff1:	0f 89 48 ff ff ff    	jns    800f3f <vprintfmt+0x89>
				width = 0;
  800ff7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ffe:	e9 3c ff ff ff       	jmpq   800f3f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801003:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80100a:	e9 30 ff ff ff       	jmpq   800f3f <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80100f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801010:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801014:	0f 89 25 ff ff ff    	jns    800f3f <vprintfmt+0x89>
				width = precision, precision = -1;
  80101a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80101d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801020:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801027:	e9 13 ff ff ff       	jmpq   800f3f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80102c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801030:	e9 0a ff ff ff       	jmpq   800f3f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801035:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801038:	83 f8 30             	cmp    $0x30,%eax
  80103b:	73 17                	jae    801054 <vprintfmt+0x19e>
  80103d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801041:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801044:	89 d2                	mov    %edx,%edx
  801046:	48 01 d0             	add    %rdx,%rax
  801049:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80104c:	83 c2 08             	add    $0x8,%edx
  80104f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801052:	eb 0c                	jmp    801060 <vprintfmt+0x1aa>
  801054:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801058:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80105c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801060:	8b 10                	mov    (%rax),%edx
  801062:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801066:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80106a:	48 89 ce             	mov    %rcx,%rsi
  80106d:	89 d7                	mov    %edx,%edi
  80106f:	ff d0                	callq  *%rax
			break;
  801071:	e9 37 03 00 00       	jmpq   8013ad <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801076:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801079:	83 f8 30             	cmp    $0x30,%eax
  80107c:	73 17                	jae    801095 <vprintfmt+0x1df>
  80107e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801082:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801085:	89 d2                	mov    %edx,%edx
  801087:	48 01 d0             	add    %rdx,%rax
  80108a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80108d:	83 c2 08             	add    $0x8,%edx
  801090:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801093:	eb 0c                	jmp    8010a1 <vprintfmt+0x1eb>
  801095:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801099:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80109d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010a1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010a3:	85 db                	test   %ebx,%ebx
  8010a5:	79 02                	jns    8010a9 <vprintfmt+0x1f3>
				err = -err;
  8010a7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010a9:	83 fb 15             	cmp    $0x15,%ebx
  8010ac:	7f 16                	jg     8010c4 <vprintfmt+0x20e>
  8010ae:	48 b8 e0 5b 80 00 00 	movabs $0x805be0,%rax
  8010b5:	00 00 00 
  8010b8:	48 63 d3             	movslq %ebx,%rdx
  8010bb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010bf:	4d 85 e4             	test   %r12,%r12
  8010c2:	75 2e                	jne    8010f2 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8010c4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010cc:	89 d9                	mov    %ebx,%ecx
  8010ce:	48 ba a1 5c 80 00 00 	movabs $0x805ca1,%rdx
  8010d5:	00 00 00 
  8010d8:	48 89 c7             	mov    %rax,%rdi
  8010db:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e0:	49 b8 bc 13 80 00 00 	movabs $0x8013bc,%r8
  8010e7:	00 00 00 
  8010ea:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010ed:	e9 bb 02 00 00       	jmpq   8013ad <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010f2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010fa:	4c 89 e1             	mov    %r12,%rcx
  8010fd:	48 ba aa 5c 80 00 00 	movabs $0x805caa,%rdx
  801104:	00 00 00 
  801107:	48 89 c7             	mov    %rax,%rdi
  80110a:	b8 00 00 00 00       	mov    $0x0,%eax
  80110f:	49 b8 bc 13 80 00 00 	movabs $0x8013bc,%r8
  801116:	00 00 00 
  801119:	41 ff d0             	callq  *%r8
			break;
  80111c:	e9 8c 02 00 00       	jmpq   8013ad <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801121:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801124:	83 f8 30             	cmp    $0x30,%eax
  801127:	73 17                	jae    801140 <vprintfmt+0x28a>
  801129:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801130:	89 d2                	mov    %edx,%edx
  801132:	48 01 d0             	add    %rdx,%rax
  801135:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801138:	83 c2 08             	add    $0x8,%edx
  80113b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80113e:	eb 0c                	jmp    80114c <vprintfmt+0x296>
  801140:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801144:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801148:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80114c:	4c 8b 20             	mov    (%rax),%r12
  80114f:	4d 85 e4             	test   %r12,%r12
  801152:	75 0a                	jne    80115e <vprintfmt+0x2a8>
				p = "(null)";
  801154:	49 bc ad 5c 80 00 00 	movabs $0x805cad,%r12
  80115b:	00 00 00 
			if (width > 0 && padc != '-')
  80115e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801162:	7e 78                	jle    8011dc <vprintfmt+0x326>
  801164:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801168:	74 72                	je     8011dc <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80116a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80116d:	48 98                	cltq   
  80116f:	48 89 c6             	mov    %rax,%rsi
  801172:	4c 89 e7             	mov    %r12,%rdi
  801175:	48 b8 6a 16 80 00 00 	movabs $0x80166a,%rax
  80117c:	00 00 00 
  80117f:	ff d0                	callq  *%rax
  801181:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801184:	eb 17                	jmp    80119d <vprintfmt+0x2e7>
					putch(padc, putdat);
  801186:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80118a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80118e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801192:	48 89 ce             	mov    %rcx,%rsi
  801195:	89 d7                	mov    %edx,%edi
  801197:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801199:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80119d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011a1:	7f e3                	jg     801186 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011a3:	eb 37                	jmp    8011dc <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8011a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011a9:	74 1e                	je     8011c9 <vprintfmt+0x313>
  8011ab:	83 fb 1f             	cmp    $0x1f,%ebx
  8011ae:	7e 05                	jle    8011b5 <vprintfmt+0x2ff>
  8011b0:	83 fb 7e             	cmp    $0x7e,%ebx
  8011b3:	7e 14                	jle    8011c9 <vprintfmt+0x313>
					putch('?', putdat);
  8011b5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011bd:	48 89 d6             	mov    %rdx,%rsi
  8011c0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011c5:	ff d0                	callq  *%rax
  8011c7:	eb 0f                	jmp    8011d8 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8011c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011d1:	48 89 d6             	mov    %rdx,%rsi
  8011d4:	89 df                	mov    %ebx,%edi
  8011d6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011d8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011dc:	4c 89 e0             	mov    %r12,%rax
  8011df:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8011e3:	0f b6 00             	movzbl (%rax),%eax
  8011e6:	0f be d8             	movsbl %al,%ebx
  8011e9:	85 db                	test   %ebx,%ebx
  8011eb:	74 28                	je     801215 <vprintfmt+0x35f>
  8011ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8011f1:	78 b2                	js     8011a5 <vprintfmt+0x2ef>
  8011f3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8011f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8011fb:	79 a8                	jns    8011a5 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011fd:	eb 16                	jmp    801215 <vprintfmt+0x35f>
				putch(' ', putdat);
  8011ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801203:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801207:	48 89 d6             	mov    %rdx,%rsi
  80120a:	bf 20 00 00 00       	mov    $0x20,%edi
  80120f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801211:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801215:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801219:	7f e4                	jg     8011ff <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  80121b:	e9 8d 01 00 00       	jmpq   8013ad <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801220:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801224:	be 03 00 00 00       	mov    $0x3,%esi
  801229:	48 89 c7             	mov    %rax,%rdi
  80122c:	48 b8 af 0d 80 00 00 	movabs $0x800daf,%rax
  801233:	00 00 00 
  801236:	ff d0                	callq  *%rax
  801238:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	48 85 c0             	test   %rax,%rax
  801243:	79 1d                	jns    801262 <vprintfmt+0x3ac>
				putch('-', putdat);
  801245:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801249:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80124d:	48 89 d6             	mov    %rdx,%rsi
  801250:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801255:	ff d0                	callq  *%rax
				num = -(long long) num;
  801257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125b:	48 f7 d8             	neg    %rax
  80125e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801262:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801269:	e9 d2 00 00 00       	jmpq   801340 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80126e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801272:	be 03 00 00 00       	mov    $0x3,%esi
  801277:	48 89 c7             	mov    %rax,%rdi
  80127a:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  801281:	00 00 00 
  801284:	ff d0                	callq  *%rax
  801286:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80128a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801291:	e9 aa 00 00 00       	jmpq   801340 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  801296:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80129a:	be 03 00 00 00       	mov    $0x3,%esi
  80129f:	48 89 c7             	mov    %rax,%rdi
  8012a2:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  8012a9:	00 00 00 
  8012ac:	ff d0                	callq  *%rax
  8012ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8012b2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8012b9:	e9 82 00 00 00       	jmpq   801340 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  8012be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012c6:	48 89 d6             	mov    %rdx,%rsi
  8012c9:	bf 30 00 00 00       	mov    $0x30,%edi
  8012ce:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012d0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012d8:	48 89 d6             	mov    %rdx,%rsi
  8012db:	bf 78 00 00 00       	mov    $0x78,%edi
  8012e0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8012e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012e5:	83 f8 30             	cmp    $0x30,%eax
  8012e8:	73 17                	jae    801301 <vprintfmt+0x44b>
  8012ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012f1:	89 d2                	mov    %edx,%edx
  8012f3:	48 01 d0             	add    %rdx,%rax
  8012f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012f9:	83 c2 08             	add    $0x8,%edx
  8012fc:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012ff:	eb 0c                	jmp    80130d <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801301:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801305:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801309:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80130d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801310:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801314:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80131b:	eb 23                	jmp    801340 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80131d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801321:	be 03 00 00 00       	mov    $0x3,%esi
  801326:	48 89 c7             	mov    %rax,%rdi
  801329:	48 b8 a8 0c 80 00 00 	movabs $0x800ca8,%rax
  801330:	00 00 00 
  801333:	ff d0                	callq  *%rax
  801335:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801339:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801340:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801345:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801348:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80134b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801353:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801357:	45 89 c1             	mov    %r8d,%r9d
  80135a:	41 89 f8             	mov    %edi,%r8d
  80135d:	48 89 c7             	mov    %rax,%rdi
  801360:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  801367:	00 00 00 
  80136a:	ff d0                	callq  *%rax
			break;
  80136c:	eb 3f                	jmp    8013ad <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80136e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801372:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801376:	48 89 d6             	mov    %rdx,%rsi
  801379:	89 df                	mov    %ebx,%edi
  80137b:	ff d0                	callq  *%rax
			break;
  80137d:	eb 2e                	jmp    8013ad <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80137f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801383:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801387:	48 89 d6             	mov    %rdx,%rsi
  80138a:	bf 25 00 00 00       	mov    $0x25,%edi
  80138f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801391:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801396:	eb 05                	jmp    80139d <vprintfmt+0x4e7>
  801398:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80139d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a1:	48 83 e8 01          	sub    $0x1,%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	3c 25                	cmp    $0x25,%al
  8013aa:	75 ec                	jne    801398 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  8013ac:	90                   	nop
		}
	}
  8013ad:	e9 3d fb ff ff       	jmpq   800eef <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8013b2:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013b3:	48 83 c4 60          	add    $0x60,%rsp
  8013b7:	5b                   	pop    %rbx
  8013b8:	41 5c                	pop    %r12
  8013ba:	5d                   	pop    %rbp
  8013bb:	c3                   	retq   

00000000008013bc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013bc:	55                   	push   %rbp
  8013bd:	48 89 e5             	mov    %rsp,%rbp
  8013c0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013c7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013ce:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8013d5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8013dc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013e3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013ea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 20                	je     801415 <printfmt+0x59>
  8013f5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8013f9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8013fd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801401:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801405:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801409:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80140d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801411:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801415:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80141c:	00 00 00 
  80141f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801426:	00 00 00 
  801429:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80142d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801434:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80143b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801442:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801449:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801450:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801457:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80145e:	48 89 c7             	mov    %rax,%rdi
  801461:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  801468:	00 00 00 
  80146b:	ff d0                	callq  *%rax
	va_end(ap);
}
  80146d:	90                   	nop
  80146e:	c9                   	leaveq 
  80146f:	c3                   	retq   

0000000000801470 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801470:	55                   	push   %rbp
  801471:	48 89 e5             	mov    %rsp,%rbp
  801474:	48 83 ec 10          	sub    $0x10,%rsp
  801478:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80147b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80147f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801483:	8b 40 10             	mov    0x10(%rax),%eax
  801486:	8d 50 01             	lea    0x1(%rax),%edx
  801489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801494:	48 8b 10             	mov    (%rax),%rdx
  801497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80149f:	48 39 c2             	cmp    %rax,%rdx
  8014a2:	73 17                	jae    8014bb <sprintputch+0x4b>
		*b->buf++ = ch;
  8014a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a8:	48 8b 00             	mov    (%rax),%rax
  8014ab:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014b3:	48 89 0a             	mov    %rcx,(%rdx)
  8014b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014b9:	88 10                	mov    %dl,(%rax)
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leaveq 
  8014bd:	c3                   	retq   

00000000008014be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014be:	55                   	push   %rbp
  8014bf:	48 89 e5             	mov    %rsp,%rbp
  8014c2:	48 83 ec 50          	sub    $0x50,%rsp
  8014c6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014ca:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014cd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014d1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014d5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8014d9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8014dd:	48 8b 0a             	mov    (%rdx),%rcx
  8014e0:	48 89 08             	mov    %rcx,(%rax)
  8014e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014f7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8014fb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8014fe:	48 98                	cltq   
  801500:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801504:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801508:	48 01 d0             	add    %rdx,%rax
  80150b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80150f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801516:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80151b:	74 06                	je     801523 <vsnprintf+0x65>
  80151d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801521:	7f 07                	jg     80152a <vsnprintf+0x6c>
		return -E_INVAL;
  801523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801528:	eb 2f                	jmp    801559 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80152a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80152e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801532:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801536:	48 89 c6             	mov    %rax,%rsi
  801539:	48 bf 70 14 80 00 00 	movabs $0x801470,%rdi
  801540:	00 00 00 
  801543:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  80154a:	00 00 00 
  80154d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80154f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801553:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801556:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801566:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80156d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801573:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  80157a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801581:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801588:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80158f:	84 c0                	test   %al,%al
  801591:	74 20                	je     8015b3 <snprintf+0x58>
  801593:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801597:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80159b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80159f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015a3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015a7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015ab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015af:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015b3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015ba:	00 00 00 
  8015bd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015c4:	00 00 00 
  8015c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015cb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015d2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015d9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8015e0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8015e7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8015ee:	48 8b 0a             	mov    (%rdx),%rcx
  8015f1:	48 89 08             	mov    %rcx,(%rax)
  8015f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8015f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8015fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801600:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801604:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80160b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801612:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801618:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80161f:	48 89 c7             	mov    %rax,%rdi
  801622:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  801629:	00 00 00 
  80162c:	ff d0                	callq  *%rax
  80162e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801634:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80163a:	c9                   	leaveq 
  80163b:	c3                   	retq   

000000000080163c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	48 83 ec 18          	sub    $0x18,%rsp
  801644:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801648:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80164f:	eb 09                	jmp    80165a <strlen+0x1e>
		n++;
  801651:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801655:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80165a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	84 c0                	test   %al,%al
  801663:	75 ec                	jne    801651 <strlen+0x15>
		n++;
	return n;
  801665:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801668:	c9                   	leaveq 
  801669:	c3                   	retq   

000000000080166a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80166a:	55                   	push   %rbp
  80166b:	48 89 e5             	mov    %rsp,%rbp
  80166e:	48 83 ec 20          	sub    $0x20,%rsp
  801672:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801676:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80167a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801681:	eb 0e                	jmp    801691 <strnlen+0x27>
		n++;
  801683:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80168c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801691:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801696:	74 0b                	je     8016a3 <strnlen+0x39>
  801698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	84 c0                	test   %al,%al
  8016a1:	75 e0                	jne    801683 <strnlen+0x19>
		n++;
	return n;
  8016a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016a6:	c9                   	leaveq 
  8016a7:	c3                   	retq   

00000000008016a8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016a8:	55                   	push   %rbp
  8016a9:	48 89 e5             	mov    %rsp,%rbp
  8016ac:	48 83 ec 20          	sub    $0x20,%rsp
  8016b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016c0:	90                   	nop
  8016c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016d1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016d5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8016d9:	0f b6 12             	movzbl (%rdx),%edx
  8016dc:	88 10                	mov    %dl,(%rax)
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	84 c0                	test   %al,%al
  8016e3:	75 dc                	jne    8016c1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8016e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016e9:	c9                   	leaveq 
  8016ea:	c3                   	retq   

00000000008016eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	48 83 ec 20          	sub    $0x20,%rsp
  8016f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ff:	48 89 c7             	mov    %rax,%rdi
  801702:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  801709:	00 00 00 
  80170c:	ff d0                	callq  *%rax
  80170e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801711:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801714:	48 63 d0             	movslq %eax,%rdx
  801717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171b:	48 01 c2             	add    %rax,%rdx
  80171e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801722:	48 89 c6             	mov    %rax,%rsi
  801725:	48 89 d7             	mov    %rdx,%rdi
  801728:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80172f:	00 00 00 
  801732:	ff d0                	callq  *%rax
	return dst;
  801734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801738:	c9                   	leaveq 
  801739:	c3                   	retq   

000000000080173a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80173a:	55                   	push   %rbp
  80173b:	48 89 e5             	mov    %rsp,%rbp
  80173e:	48 83 ec 28          	sub    $0x28,%rsp
  801742:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801746:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80174a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80174e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801752:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801756:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80175d:	00 
  80175e:	eb 2a                	jmp    80178a <strncpy+0x50>
		*dst++ = *src;
  801760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801764:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801768:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80176c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801770:	0f b6 12             	movzbl (%rdx),%edx
  801773:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	84 c0                	test   %al,%al
  80177e:	74 05                	je     801785 <strncpy+0x4b>
			src++;
  801780:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801785:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80178a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801792:	72 cc                	jb     801760 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801798:	c9                   	leaveq 
  801799:	c3                   	retq   

000000000080179a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80179a:	55                   	push   %rbp
  80179b:	48 89 e5             	mov    %rsp,%rbp
  80179e:	48 83 ec 28          	sub    $0x28,%rsp
  8017a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017b6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017bb:	74 3d                	je     8017fa <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017bd:	eb 1d                	jmp    8017dc <strlcpy+0x42>
			*dst++ = *src++;
  8017bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017cf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017d3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017d7:	0f b6 12             	movzbl (%rdx),%edx
  8017da:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8017dc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8017e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017e6:	74 0b                	je     8017f3 <strlcpy+0x59>
  8017e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	84 c0                	test   %al,%al
  8017f1:	75 cc                	jne    8017bf <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8017f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8017fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801802:	48 29 c2             	sub    %rax,%rdx
  801805:	48 89 d0             	mov    %rdx,%rax
}
  801808:	c9                   	leaveq 
  801809:	c3                   	retq   

000000000080180a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80180a:	55                   	push   %rbp
  80180b:	48 89 e5             	mov    %rsp,%rbp
  80180e:	48 83 ec 10          	sub    $0x10,%rsp
  801812:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801816:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80181a:	eb 0a                	jmp    801826 <strcmp+0x1c>
		p++, q++;
  80181c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801821:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182a:	0f b6 00             	movzbl (%rax),%eax
  80182d:	84 c0                	test   %al,%al
  80182f:	74 12                	je     801843 <strcmp+0x39>
  801831:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801835:	0f b6 10             	movzbl (%rax),%edx
  801838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183c:	0f b6 00             	movzbl (%rax),%eax
  80183f:	38 c2                	cmp    %al,%dl
  801841:	74 d9                	je     80181c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801843:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801847:	0f b6 00             	movzbl (%rax),%eax
  80184a:	0f b6 d0             	movzbl %al,%edx
  80184d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	0f b6 c0             	movzbl %al,%eax
  801857:	29 c2                	sub    %eax,%edx
  801859:	89 d0                	mov    %edx,%eax
}
  80185b:	c9                   	leaveq 
  80185c:	c3                   	retq   

000000000080185d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80185d:	55                   	push   %rbp
  80185e:	48 89 e5             	mov    %rsp,%rbp
  801861:	48 83 ec 18          	sub    $0x18,%rsp
  801865:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801869:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80186d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801871:	eb 0f                	jmp    801882 <strncmp+0x25>
		n--, p++, q++;
  801873:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801878:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80187d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801882:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801887:	74 1d                	je     8018a6 <strncmp+0x49>
  801889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	84 c0                	test   %al,%al
  801892:	74 12                	je     8018a6 <strncmp+0x49>
  801894:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801898:	0f b6 10             	movzbl (%rax),%edx
  80189b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189f:	0f b6 00             	movzbl (%rax),%eax
  8018a2:	38 c2                	cmp    %al,%dl
  8018a4:	74 cd                	je     801873 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ab:	75 07                	jne    8018b4 <strncmp+0x57>
		return 0;
  8018ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b2:	eb 18                	jmp    8018cc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b8:	0f b6 00             	movzbl (%rax),%eax
  8018bb:	0f b6 d0             	movzbl %al,%edx
  8018be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c2:	0f b6 00             	movzbl (%rax),%eax
  8018c5:	0f b6 c0             	movzbl %al,%eax
  8018c8:	29 c2                	sub    %eax,%edx
  8018ca:	89 d0                	mov    %edx,%eax
}
  8018cc:	c9                   	leaveq 
  8018cd:	c3                   	retq   

00000000008018ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018ce:	55                   	push   %rbp
  8018cf:	48 89 e5             	mov    %rsp,%rbp
  8018d2:	48 83 ec 10          	sub    $0x10,%rsp
  8018d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018da:	89 f0                	mov    %esi,%eax
  8018dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8018df:	eb 17                	jmp    8018f8 <strchr+0x2a>
		if (*s == c)
  8018e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8018eb:	75 06                	jne    8018f3 <strchr+0x25>
			return (char *) s;
  8018ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f1:	eb 15                	jmp    801908 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fc:	0f b6 00             	movzbl (%rax),%eax
  8018ff:	84 c0                	test   %al,%al
  801901:	75 de                	jne    8018e1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801908:	c9                   	leaveq 
  801909:	c3                   	retq   

000000000080190a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	48 83 ec 10          	sub    $0x10,%rsp
  801912:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801916:	89 f0                	mov    %esi,%eax
  801918:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80191b:	eb 11                	jmp    80192e <strfind+0x24>
		if (*s == c)
  80191d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801921:	0f b6 00             	movzbl (%rax),%eax
  801924:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801927:	74 12                	je     80193b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801929:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80192e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801932:	0f b6 00             	movzbl (%rax),%eax
  801935:	84 c0                	test   %al,%al
  801937:	75 e4                	jne    80191d <strfind+0x13>
  801939:	eb 01                	jmp    80193c <strfind+0x32>
		if (*s == c)
			break;
  80193b:	90                   	nop
	return (char *) s;
  80193c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 18          	sub    $0x18,%rsp
  80194a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80194e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801951:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801955:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80195a:	75 06                	jne    801962 <memset+0x20>
		return v;
  80195c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801960:	eb 69                	jmp    8019cb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801962:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801966:	83 e0 03             	and    $0x3,%eax
  801969:	48 85 c0             	test   %rax,%rax
  80196c:	75 48                	jne    8019b6 <memset+0x74>
  80196e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801972:	83 e0 03             	and    $0x3,%eax
  801975:	48 85 c0             	test   %rax,%rax
  801978:	75 3c                	jne    8019b6 <memset+0x74>
		c &= 0xFF;
  80197a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801981:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801984:	c1 e0 18             	shl    $0x18,%eax
  801987:	89 c2                	mov    %eax,%edx
  801989:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80198c:	c1 e0 10             	shl    $0x10,%eax
  80198f:	09 c2                	or     %eax,%edx
  801991:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801994:	c1 e0 08             	shl    $0x8,%eax
  801997:	09 d0                	or     %edx,%eax
  801999:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80199c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a0:	48 c1 e8 02          	shr    $0x2,%rax
  8019a4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ae:	48 89 d7             	mov    %rdx,%rdi
  8019b1:	fc                   	cld    
  8019b2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019b4:	eb 11                	jmp    8019c7 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019c1:	48 89 d7             	mov    %rdx,%rdi
  8019c4:	fc                   	cld    
  8019c5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019cb:	c9                   	leaveq 
  8019cc:	c3                   	retq   

00000000008019cd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019cd:	55                   	push   %rbp
  8019ce:	48 89 e5             	mov    %rsp,%rbp
  8019d1:	48 83 ec 28          	sub    $0x28,%rsp
  8019d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8019e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8019e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8019f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8019f9:	0f 83 88 00 00 00    	jae    801a87 <memmove+0xba>
  8019ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a07:	48 01 d0             	add    %rdx,%rax
  801a0a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a0e:	76 77                	jbe    801a87 <memmove+0xba>
		s += n;
  801a10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a14:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a24:	83 e0 03             	and    $0x3,%eax
  801a27:	48 85 c0             	test   %rax,%rax
  801a2a:	75 3b                	jne    801a67 <memmove+0x9a>
  801a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a30:	83 e0 03             	and    $0x3,%eax
  801a33:	48 85 c0             	test   %rax,%rax
  801a36:	75 2f                	jne    801a67 <memmove+0x9a>
  801a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3c:	83 e0 03             	and    $0x3,%eax
  801a3f:	48 85 c0             	test   %rax,%rax
  801a42:	75 23                	jne    801a67 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a48:	48 83 e8 04          	sub    $0x4,%rax
  801a4c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a50:	48 83 ea 04          	sub    $0x4,%rdx
  801a54:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a58:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a5c:	48 89 c7             	mov    %rax,%rdi
  801a5f:	48 89 d6             	mov    %rdx,%rsi
  801a62:	fd                   	std    
  801a63:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a65:	eb 1d                	jmp    801a84 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a73:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801a77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7b:	48 89 d7             	mov    %rdx,%rdi
  801a7e:	48 89 c1             	mov    %rax,%rcx
  801a81:	fd                   	std    
  801a82:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801a84:	fc                   	cld    
  801a85:	eb 57                	jmp    801ade <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8b:	83 e0 03             	and    $0x3,%eax
  801a8e:	48 85 c0             	test   %rax,%rax
  801a91:	75 36                	jne    801ac9 <memmove+0xfc>
  801a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a97:	83 e0 03             	and    $0x3,%eax
  801a9a:	48 85 c0             	test   %rax,%rax
  801a9d:	75 2a                	jne    801ac9 <memmove+0xfc>
  801a9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa3:	83 e0 03             	and    $0x3,%eax
  801aa6:	48 85 c0             	test   %rax,%rax
  801aa9:	75 1e                	jne    801ac9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801aab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aaf:	48 c1 e8 02          	shr    $0x2,%rax
  801ab3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801abe:	48 89 c7             	mov    %rax,%rdi
  801ac1:	48 89 d6             	mov    %rdx,%rsi
  801ac4:	fc                   	cld    
  801ac5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ac7:	eb 15                	jmp    801ade <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801ac9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801acd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ad1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ad5:	48 89 c7             	mov    %rax,%rdi
  801ad8:	48 89 d6             	mov    %rdx,%rsi
  801adb:	fc                   	cld    
  801adc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ae2:	c9                   	leaveq 
  801ae3:	c3                   	retq   

0000000000801ae4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ae4:	55                   	push   %rbp
  801ae5:	48 89 e5             	mov    %rsp,%rbp
  801ae8:	48 83 ec 18          	sub    $0x18,%rsp
  801aec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801af0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801af8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801afc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b04:	48 89 ce             	mov    %rcx,%rsi
  801b07:	48 89 c7             	mov    %rax,%rdi
  801b0a:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  801b11:	00 00 00 
  801b14:	ff d0                	callq  *%rax
}
  801b16:	c9                   	leaveq 
  801b17:	c3                   	retq   

0000000000801b18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b18:	55                   	push   %rbp
  801b19:	48 89 e5             	mov    %rsp,%rbp
  801b1c:	48 83 ec 28          	sub    $0x28,%rsp
  801b20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b3c:	eb 36                	jmp    801b74 <memcmp+0x5c>
		if (*s1 != *s2)
  801b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b42:	0f b6 10             	movzbl (%rax),%edx
  801b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b49:	0f b6 00             	movzbl (%rax),%eax
  801b4c:	38 c2                	cmp    %al,%dl
  801b4e:	74 1a                	je     801b6a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b54:	0f b6 00             	movzbl (%rax),%eax
  801b57:	0f b6 d0             	movzbl %al,%edx
  801b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5e:	0f b6 00             	movzbl (%rax),%eax
  801b61:	0f b6 c0             	movzbl %al,%eax
  801b64:	29 c2                	sub    %eax,%edx
  801b66:	89 d0                	mov    %edx,%eax
  801b68:	eb 20                	jmp    801b8a <memcmp+0x72>
		s1++, s2++;
  801b6a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b6f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b78:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b80:	48 85 c0             	test   %rax,%rax
  801b83:	75 b9                	jne    801b3e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8a:	c9                   	leaveq 
  801b8b:	c3                   	retq   

0000000000801b8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	48 83 ec 28          	sub    $0x28,%rsp
  801b94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b98:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801b9b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba7:	48 01 d0             	add    %rdx,%rax
  801baa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bae:	eb 19                	jmp    801bc9 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb4:	0f b6 00             	movzbl (%rax),%eax
  801bb7:	0f b6 d0             	movzbl %al,%edx
  801bba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bbd:	0f b6 c0             	movzbl %al,%eax
  801bc0:	39 c2                	cmp    %eax,%edx
  801bc2:	74 11                	je     801bd5 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801bc4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bcd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bd1:	72 dd                	jb     801bb0 <memfind+0x24>
  801bd3:	eb 01                	jmp    801bd6 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bd5:	90                   	nop
	return (void *) s;
  801bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bda:	c9                   	leaveq 
  801bdb:	c3                   	retq   

0000000000801bdc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bdc:	55                   	push   %rbp
  801bdd:	48 89 e5             	mov    %rsp,%rbp
  801be0:	48 83 ec 38          	sub    $0x38,%rsp
  801be4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801be8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801bec:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801bf6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801bfd:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bfe:	eb 05                	jmp    801c05 <strtol+0x29>
		s++;
  801c00:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c09:	0f b6 00             	movzbl (%rax),%eax
  801c0c:	3c 20                	cmp    $0x20,%al
  801c0e:	74 f0                	je     801c00 <strtol+0x24>
  801c10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c14:	0f b6 00             	movzbl (%rax),%eax
  801c17:	3c 09                	cmp    $0x9,%al
  801c19:	74 e5                	je     801c00 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1f:	0f b6 00             	movzbl (%rax),%eax
  801c22:	3c 2b                	cmp    $0x2b,%al
  801c24:	75 07                	jne    801c2d <strtol+0x51>
		s++;
  801c26:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c2b:	eb 17                	jmp    801c44 <strtol+0x68>
	else if (*s == '-')
  801c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c31:	0f b6 00             	movzbl (%rax),%eax
  801c34:	3c 2d                	cmp    $0x2d,%al
  801c36:	75 0c                	jne    801c44 <strtol+0x68>
		s++, neg = 1;
  801c38:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c3d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c44:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c48:	74 06                	je     801c50 <strtol+0x74>
  801c4a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c4e:	75 28                	jne    801c78 <strtol+0x9c>
  801c50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c54:	0f b6 00             	movzbl (%rax),%eax
  801c57:	3c 30                	cmp    $0x30,%al
  801c59:	75 1d                	jne    801c78 <strtol+0x9c>
  801c5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5f:	48 83 c0 01          	add    $0x1,%rax
  801c63:	0f b6 00             	movzbl (%rax),%eax
  801c66:	3c 78                	cmp    $0x78,%al
  801c68:	75 0e                	jne    801c78 <strtol+0x9c>
		s += 2, base = 16;
  801c6a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c6f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c76:	eb 2c                	jmp    801ca4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c78:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c7c:	75 19                	jne    801c97 <strtol+0xbb>
  801c7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c82:	0f b6 00             	movzbl (%rax),%eax
  801c85:	3c 30                	cmp    $0x30,%al
  801c87:	75 0e                	jne    801c97 <strtol+0xbb>
		s++, base = 8;
  801c89:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c8e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801c95:	eb 0d                	jmp    801ca4 <strtol+0xc8>
	else if (base == 0)
  801c97:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c9b:	75 07                	jne    801ca4 <strtol+0xc8>
		base = 10;
  801c9d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ca4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca8:	0f b6 00             	movzbl (%rax),%eax
  801cab:	3c 2f                	cmp    $0x2f,%al
  801cad:	7e 1d                	jle    801ccc <strtol+0xf0>
  801caf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb3:	0f b6 00             	movzbl (%rax),%eax
  801cb6:	3c 39                	cmp    $0x39,%al
  801cb8:	7f 12                	jg     801ccc <strtol+0xf0>
			dig = *s - '0';
  801cba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbe:	0f b6 00             	movzbl (%rax),%eax
  801cc1:	0f be c0             	movsbl %al,%eax
  801cc4:	83 e8 30             	sub    $0x30,%eax
  801cc7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cca:	eb 4e                	jmp    801d1a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd0:	0f b6 00             	movzbl (%rax),%eax
  801cd3:	3c 60                	cmp    $0x60,%al
  801cd5:	7e 1d                	jle    801cf4 <strtol+0x118>
  801cd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdb:	0f b6 00             	movzbl (%rax),%eax
  801cde:	3c 7a                	cmp    $0x7a,%al
  801ce0:	7f 12                	jg     801cf4 <strtol+0x118>
			dig = *s - 'a' + 10;
  801ce2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce6:	0f b6 00             	movzbl (%rax),%eax
  801ce9:	0f be c0             	movsbl %al,%eax
  801cec:	83 e8 57             	sub    $0x57,%eax
  801cef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cf2:	eb 26                	jmp    801d1a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801cf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf8:	0f b6 00             	movzbl (%rax),%eax
  801cfb:	3c 40                	cmp    $0x40,%al
  801cfd:	7e 47                	jle    801d46 <strtol+0x16a>
  801cff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d03:	0f b6 00             	movzbl (%rax),%eax
  801d06:	3c 5a                	cmp    $0x5a,%al
  801d08:	7f 3c                	jg     801d46 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801d0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0e:	0f b6 00             	movzbl (%rax),%eax
  801d11:	0f be c0             	movsbl %al,%eax
  801d14:	83 e8 37             	sub    $0x37,%eax
  801d17:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d1d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d20:	7d 23                	jge    801d45 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801d22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d27:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d2a:	48 98                	cltq   
  801d2c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d31:	48 89 c2             	mov    %rax,%rdx
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	48 98                	cltq   
  801d39:	48 01 d0             	add    %rdx,%rax
  801d3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d40:	e9 5f ff ff ff       	jmpq   801ca4 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d45:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d46:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d4b:	74 0b                	je     801d58 <strtol+0x17c>
		*endptr = (char *) s;
  801d4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d51:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d55:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d5c:	74 09                	je     801d67 <strtol+0x18b>
  801d5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d62:	48 f7 d8             	neg    %rax
  801d65:	eb 04                	jmp    801d6b <strtol+0x18f>
  801d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d6b:	c9                   	leaveq 
  801d6c:	c3                   	retq   

0000000000801d6d <strstr>:

char * strstr(const char *in, const char *str)
{
  801d6d:	55                   	push   %rbp
  801d6e:	48 89 e5             	mov    %rsp,%rbp
  801d71:	48 83 ec 30          	sub    $0x30,%rsp
  801d75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801d7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d81:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d85:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801d89:	0f b6 00             	movzbl (%rax),%eax
  801d8c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801d8f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801d93:	75 06                	jne    801d9b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801d95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d99:	eb 6b                	jmp    801e06 <strstr+0x99>

	len = strlen(str);
  801d9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9f:	48 89 c7             	mov    %rax,%rdi
  801da2:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
  801dae:	48 98                	cltq   
  801db0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801db4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801dc0:	0f b6 00             	movzbl (%rax),%eax
  801dc3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801dc6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801dca:	75 07                	jne    801dd3 <strstr+0x66>
				return (char *) 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	eb 33                	jmp    801e06 <strstr+0x99>
		} while (sc != c);
  801dd3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801dd7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801dda:	75 d8                	jne    801db4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ddc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801de4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de8:	48 89 ce             	mov    %rcx,%rsi
  801deb:	48 89 c7             	mov    %rax,%rdi
  801dee:	48 b8 5d 18 80 00 00 	movabs $0x80185d,%rax
  801df5:	00 00 00 
  801df8:	ff d0                	callq  *%rax
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	75 b6                	jne    801db4 <strstr+0x47>

	return (char *) (in - 1);
  801dfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e02:	48 83 e8 01          	sub    $0x1,%rax
}
  801e06:	c9                   	leaveq 
  801e07:	c3                   	retq   

0000000000801e08 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e08:	55                   	push   %rbp
  801e09:	48 89 e5             	mov    %rsp,%rbp
  801e0c:	53                   	push   %rbx
  801e0d:	48 83 ec 48          	sub    $0x48,%rsp
  801e11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e14:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e17:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e1b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e1f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e23:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e2a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e2e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e32:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e36:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e3a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e3e:	4c 89 c3             	mov    %r8,%rbx
  801e41:	cd 30                	int    $0x30
  801e43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e4b:	74 3e                	je     801e8b <syscall+0x83>
  801e4d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e52:	7e 37                	jle    801e8b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e5b:	49 89 d0             	mov    %rdx,%r8
  801e5e:	89 c1                	mov    %eax,%ecx
  801e60:	48 ba 68 5f 80 00 00 	movabs $0x805f68,%rdx
  801e67:	00 00 00 
  801e6a:	be 24 00 00 00       	mov    $0x24,%esi
  801e6f:	48 bf 85 5f 80 00 00 	movabs $0x805f85,%rdi
  801e76:	00 00 00 
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7e:	49 b9 de 08 80 00 00 	movabs $0x8008de,%r9
  801e85:	00 00 00 
  801e88:	41 ff d1             	callq  *%r9

	return ret;
  801e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e8f:	48 83 c4 48          	add    $0x48,%rsp
  801e93:	5b                   	pop    %rbx
  801e94:	5d                   	pop    %rbp
  801e95:	c3                   	retq   

0000000000801e96 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801e96:	55                   	push   %rbp
  801e97:	48 89 e5             	mov    %rsp,%rbp
  801e9a:	48 83 ec 10          	sub    $0x10,%rsp
  801e9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ea2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eae:	48 83 ec 08          	sub    $0x8,%rsp
  801eb2:	6a 00                	pushq  $0x0
  801eb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec0:	48 89 d1             	mov    %rdx,%rcx
  801ec3:	48 89 c2             	mov    %rax,%rdx
  801ec6:	be 00 00 00 00       	mov    $0x0,%esi
  801ecb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed0:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
  801edc:	48 83 c4 10          	add    $0x10,%rsp
}
  801ee0:	90                   	nop
  801ee1:	c9                   	leaveq 
  801ee2:	c3                   	retq   

0000000000801ee3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee3:	55                   	push   %rbp
  801ee4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ee7:	48 83 ec 08          	sub    $0x8,%rsp
  801eeb:	6a 00                	pushq  $0x0
  801eed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801efe:	ba 00 00 00 00       	mov    $0x0,%edx
  801f03:	be 00 00 00 00       	mov    $0x0,%esi
  801f08:	bf 01 00 00 00       	mov    $0x1,%edi
  801f0d:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	callq  *%rax
  801f19:	48 83 c4 10          	add    $0x10,%rsp
}
  801f1d:	c9                   	leaveq 
  801f1e:	c3                   	retq   

0000000000801f1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f1f:	55                   	push   %rbp
  801f20:	48 89 e5             	mov    %rsp,%rbp
  801f23:	48 83 ec 10          	sub    $0x10,%rsp
  801f27:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2d:	48 98                	cltq   
  801f2f:	48 83 ec 08          	sub    $0x8,%rsp
  801f33:	6a 00                	pushq  $0x0
  801f35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f41:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f46:	48 89 c2             	mov    %rax,%rdx
  801f49:	be 01 00 00 00       	mov    $0x1,%esi
  801f4e:	bf 03 00 00 00       	mov    $0x3,%edi
  801f53:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	callq  *%rax
  801f5f:	48 83 c4 10          	add    $0x10,%rsp
}
  801f63:	c9                   	leaveq 
  801f64:	c3                   	retq   

0000000000801f65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f69:	48 83 ec 08          	sub    $0x8,%rsp
  801f6d:	6a 00                	pushq  $0x0
  801f6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f80:	ba 00 00 00 00       	mov    $0x0,%edx
  801f85:	be 00 00 00 00       	mov    $0x0,%esi
  801f8a:	bf 02 00 00 00       	mov    $0x2,%edi
  801f8f:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
  801f9b:	48 83 c4 10          	add    $0x10,%rsp
}
  801f9f:	c9                   	leaveq 
  801fa0:	c3                   	retq   

0000000000801fa1 <sys_yield>:


void
sys_yield(void)
{
  801fa1:	55                   	push   %rbp
  801fa2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fa5:	48 83 ec 08          	sub    $0x8,%rsp
  801fa9:	6a 00                	pushq  $0x0
  801fab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc1:	be 00 00 00 00       	mov    $0x0,%esi
  801fc6:	bf 0b 00 00 00       	mov    $0xb,%edi
  801fcb:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
  801fd7:	48 83 c4 10          	add    $0x10,%rsp
}
  801fdb:	90                   	nop
  801fdc:	c9                   	leaveq 
  801fdd:	c3                   	retq   

0000000000801fde <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801fde:	55                   	push   %rbp
  801fdf:	48 89 e5             	mov    %rsp,%rbp
  801fe2:	48 83 ec 10          	sub    $0x10,%rsp
  801fe6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fe9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fed:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ff0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ff3:	48 63 c8             	movslq %eax,%rcx
  801ff6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ffd:	48 98                	cltq   
  801fff:	48 83 ec 08          	sub    $0x8,%rsp
  802003:	6a 00                	pushq  $0x0
  802005:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200b:	49 89 c8             	mov    %rcx,%r8
  80200e:	48 89 d1             	mov    %rdx,%rcx
  802011:	48 89 c2             	mov    %rax,%rdx
  802014:	be 01 00 00 00       	mov    $0x1,%esi
  802019:	bf 04 00 00 00       	mov    $0x4,%edi
  80201e:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	48 83 c4 10          	add    $0x10,%rsp
}
  80202e:	c9                   	leaveq 
  80202f:	c3                   	retq   

0000000000802030 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802030:	55                   	push   %rbp
  802031:	48 89 e5             	mov    %rsp,%rbp
  802034:	48 83 ec 20          	sub    $0x20,%rsp
  802038:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80203b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80203f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802042:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802046:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80204a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80204d:	48 63 c8             	movslq %eax,%rcx
  802050:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802054:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802057:	48 63 f0             	movslq %eax,%rsi
  80205a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802061:	48 98                	cltq   
  802063:	48 83 ec 08          	sub    $0x8,%rsp
  802067:	51                   	push   %rcx
  802068:	49 89 f9             	mov    %rdi,%r9
  80206b:	49 89 f0             	mov    %rsi,%r8
  80206e:	48 89 d1             	mov    %rdx,%rcx
  802071:	48 89 c2             	mov    %rax,%rdx
  802074:	be 01 00 00 00       	mov    $0x1,%esi
  802079:	bf 05 00 00 00       	mov    $0x5,%edi
  80207e:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
  80208a:	48 83 c4 10          	add    $0x10,%rsp
}
  80208e:	c9                   	leaveq 
  80208f:	c3                   	retq   

0000000000802090 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802090:	55                   	push   %rbp
  802091:	48 89 e5             	mov    %rsp,%rbp
  802094:	48 83 ec 10          	sub    $0x10,%rsp
  802098:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80209b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80209f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a6:	48 98                	cltq   
  8020a8:	48 83 ec 08          	sub    $0x8,%rsp
  8020ac:	6a 00                	pushq  $0x0
  8020ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ba:	48 89 d1             	mov    %rdx,%rcx
  8020bd:	48 89 c2             	mov    %rax,%rdx
  8020c0:	be 01 00 00 00       	mov    $0x1,%esi
  8020c5:	bf 06 00 00 00       	mov    $0x6,%edi
  8020ca:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	callq  *%rax
  8020d6:	48 83 c4 10          	add    $0x10,%rsp
}
  8020da:	c9                   	leaveq 
  8020db:	c3                   	retq   

00000000008020dc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020dc:	55                   	push   %rbp
  8020dd:	48 89 e5             	mov    %rsp,%rbp
  8020e0:	48 83 ec 10          	sub    $0x10,%rsp
  8020e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020e7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8020ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ed:	48 63 d0             	movslq %eax,%rdx
  8020f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f3:	48 98                	cltq   
  8020f5:	48 83 ec 08          	sub    $0x8,%rsp
  8020f9:	6a 00                	pushq  $0x0
  8020fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802101:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802107:	48 89 d1             	mov    %rdx,%rcx
  80210a:	48 89 c2             	mov    %rax,%rdx
  80210d:	be 01 00 00 00       	mov    $0x1,%esi
  802112:	bf 08 00 00 00       	mov    $0x8,%edi
  802117:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax
  802123:	48 83 c4 10          	add    $0x10,%rsp
}
  802127:	c9                   	leaveq 
  802128:	c3                   	retq   

0000000000802129 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802129:	55                   	push   %rbp
  80212a:	48 89 e5             	mov    %rsp,%rbp
  80212d:	48 83 ec 10          	sub    $0x10,%rsp
  802131:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802134:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802138:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80213c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213f:	48 98                	cltq   
  802141:	48 83 ec 08          	sub    $0x8,%rsp
  802145:	6a 00                	pushq  $0x0
  802147:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80214d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802153:	48 89 d1             	mov    %rdx,%rcx
  802156:	48 89 c2             	mov    %rax,%rdx
  802159:	be 01 00 00 00       	mov    $0x1,%esi
  80215e:	bf 09 00 00 00       	mov    $0x9,%edi
  802163:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
  80216f:	48 83 c4 10          	add    $0x10,%rsp
}
  802173:	c9                   	leaveq 
  802174:	c3                   	retq   

0000000000802175 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802175:	55                   	push   %rbp
  802176:	48 89 e5             	mov    %rsp,%rbp
  802179:	48 83 ec 10          	sub    $0x10,%rsp
  80217d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802180:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802184:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218b:	48 98                	cltq   
  80218d:	48 83 ec 08          	sub    $0x8,%rsp
  802191:	6a 00                	pushq  $0x0
  802193:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802199:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80219f:	48 89 d1             	mov    %rdx,%rcx
  8021a2:	48 89 c2             	mov    %rax,%rdx
  8021a5:	be 01 00 00 00       	mov    $0x1,%esi
  8021aa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021af:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	callq  *%rax
  8021bb:	48 83 c4 10          	add    $0x10,%rsp
}
  8021bf:	c9                   	leaveq 
  8021c0:	c3                   	retq   

00000000008021c1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021c1:	55                   	push   %rbp
  8021c2:	48 89 e5             	mov    %rsp,%rbp
  8021c5:	48 83 ec 20          	sub    $0x20,%rsp
  8021c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021d4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021da:	48 63 f0             	movslq %eax,%rsi
  8021dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e4:	48 98                	cltq   
  8021e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ea:	48 83 ec 08          	sub    $0x8,%rsp
  8021ee:	6a 00                	pushq  $0x0
  8021f0:	49 89 f1             	mov    %rsi,%r9
  8021f3:	49 89 c8             	mov    %rcx,%r8
  8021f6:	48 89 d1             	mov    %rdx,%rcx
  8021f9:	48 89 c2             	mov    %rax,%rdx
  8021fc:	be 00 00 00 00       	mov    $0x0,%esi
  802201:	bf 0c 00 00 00       	mov    $0xc,%edi
  802206:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80220d:	00 00 00 
  802210:	ff d0                	callq  *%rax
  802212:	48 83 c4 10          	add    $0x10,%rsp
}
  802216:	c9                   	leaveq 
  802217:	c3                   	retq   

0000000000802218 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802218:	55                   	push   %rbp
  802219:	48 89 e5             	mov    %rsp,%rbp
  80221c:	48 83 ec 10          	sub    $0x10,%rsp
  802220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802228:	48 83 ec 08          	sub    $0x8,%rsp
  80222c:	6a 00                	pushq  $0x0
  80222e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802234:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80223a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80223f:	48 89 c2             	mov    %rax,%rdx
  802242:	be 01 00 00 00       	mov    $0x1,%esi
  802247:	bf 0d 00 00 00       	mov    $0xd,%edi
  80224c:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	48 83 c4 10          	add    $0x10,%rsp
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802262:	48 83 ec 08          	sub    $0x8,%rsp
  802266:	6a 00                	pushq  $0x0
  802268:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80226e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802274:	b9 00 00 00 00       	mov    $0x0,%ecx
  802279:	ba 00 00 00 00       	mov    $0x0,%edx
  80227e:	be 00 00 00 00       	mov    $0x0,%esi
  802283:	bf 0e 00 00 00       	mov    $0xe,%edi
  802288:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80228f:	00 00 00 
  802292:	ff d0                	callq  *%rax
  802294:	48 83 c4 10          	add    $0x10,%rsp
}
  802298:	c9                   	leaveq 
  802299:	c3                   	retq   

000000000080229a <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  80229a:	55                   	push   %rbp
  80229b:	48 89 e5             	mov    %rsp,%rbp
  80229e:	48 83 ec 10          	sub    $0x10,%rsp
  8022a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022a6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8022a9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8022ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b0:	48 83 ec 08          	sub    $0x8,%rsp
  8022b4:	6a 00                	pushq  $0x0
  8022b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022c2:	48 89 d1             	mov    %rdx,%rcx
  8022c5:	48 89 c2             	mov    %rax,%rdx
  8022c8:	be 00 00 00 00       	mov    $0x0,%esi
  8022cd:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022d2:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	callq  *%rax
  8022de:	48 83 c4 10          	add    $0x10,%rsp
}
  8022e2:	c9                   	leaveq 
  8022e3:	c3                   	retq   

00000000008022e4 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  8022e4:	55                   	push   %rbp
  8022e5:	48 89 e5             	mov    %rsp,%rbp
  8022e8:	48 83 ec 10          	sub    $0x10,%rsp
  8022ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022f0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  8022f3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8022f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fa:	48 83 ec 08          	sub    $0x8,%rsp
  8022fe:	6a 00                	pushq  $0x0
  802300:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802306:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80230c:	48 89 d1             	mov    %rdx,%rcx
  80230f:	48 89 c2             	mov    %rax,%rdx
  802312:	be 00 00 00 00       	mov    $0x0,%esi
  802317:	bf 10 00 00 00       	mov    $0x10,%edi
  80231c:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802323:	00 00 00 
  802326:	ff d0                	callq  *%rax
  802328:	48 83 c4 10          	add    $0x10,%rsp
}
  80232c:	c9                   	leaveq 
  80232d:	c3                   	retq   

000000000080232e <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80232e:	55                   	push   %rbp
  80232f:	48 89 e5             	mov    %rsp,%rbp
  802332:	48 83 ec 20          	sub    $0x20,%rsp
  802336:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802339:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80233d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802340:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802344:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802348:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80234b:	48 63 c8             	movslq %eax,%rcx
  80234e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802352:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802355:	48 63 f0             	movslq %eax,%rsi
  802358:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80235c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235f:	48 98                	cltq   
  802361:	48 83 ec 08          	sub    $0x8,%rsp
  802365:	51                   	push   %rcx
  802366:	49 89 f9             	mov    %rdi,%r9
  802369:	49 89 f0             	mov    %rsi,%r8
  80236c:	48 89 d1             	mov    %rdx,%rcx
  80236f:	48 89 c2             	mov    %rax,%rdx
  802372:	be 00 00 00 00       	mov    $0x0,%esi
  802377:	bf 11 00 00 00       	mov    $0x11,%edi
  80237c:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
  802388:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80238c:	c9                   	leaveq 
  80238d:	c3                   	retq   

000000000080238e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80238e:	55                   	push   %rbp
  80238f:	48 89 e5             	mov    %rsp,%rbp
  802392:	48 83 ec 10          	sub    $0x10,%rsp
  802396:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80239a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80239e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a6:	48 83 ec 08          	sub    $0x8,%rsp
  8023aa:	6a 00                	pushq  $0x0
  8023ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023b8:	48 89 d1             	mov    %rdx,%rcx
  8023bb:	48 89 c2             	mov    %rax,%rdx
  8023be:	be 00 00 00 00       	mov    $0x0,%esi
  8023c3:	bf 12 00 00 00       	mov    $0x12,%edi
  8023c8:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8023cf:	00 00 00 
  8023d2:	ff d0                	callq  *%rax
  8023d4:	48 83 c4 10          	add    $0x10,%rsp
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 30          	sub    $0x30,%rsp
  8023e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8023e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ea:	48 8b 00             	mov    (%rax),%rax
  8023ed:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8023f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023f9:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8023fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ff:	83 e0 02             	and    $0x2,%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	75 40                	jne    802446 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80240a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802411:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802415:	49 89 d0             	mov    %rdx,%r8
  802418:	48 89 c1             	mov    %rax,%rcx
  80241b:	48 ba 98 5f 80 00 00 	movabs $0x805f98,%rdx
  802422:	00 00 00 
  802425:	be 1f 00 00 00       	mov    $0x1f,%esi
  80242a:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  802431:	00 00 00 
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	49 b9 de 08 80 00 00 	movabs $0x8008de,%r9
  802440:	00 00 00 
  802443:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80244a:	48 c1 e8 0c          	shr    $0xc,%rax
  80244e:	48 89 c2             	mov    %rax,%rdx
  802451:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802458:	01 00 00 
  80245b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245f:	25 07 08 00 00       	and    $0x807,%eax
  802464:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80246a:	74 4e                	je     8024ba <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80246c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802470:	48 c1 e8 0c          	shr    $0xc,%rax
  802474:	48 89 c2             	mov    %rax,%rdx
  802477:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80247e:	01 00 00 
  802481:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802485:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802489:	49 89 d0             	mov    %rdx,%r8
  80248c:	48 89 c1             	mov    %rax,%rcx
  80248f:	48 ba c0 5f 80 00 00 	movabs $0x805fc0,%rdx
  802496:	00 00 00 
  802499:	be 22 00 00 00       	mov    $0x22,%esi
  80249e:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8024a5:	00 00 00 
  8024a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ad:	49 b9 de 08 80 00 00 	movabs $0x8008de,%r9
  8024b4:	00 00 00 
  8024b7:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8024ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8024bf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c9:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	callq  *%rax
  8024d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8024d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024dc:	79 30                	jns    80250e <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8024de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e1:	89 c1                	mov    %eax,%ecx
  8024e3:	48 ba eb 5f 80 00 00 	movabs $0x805feb,%rdx
  8024ea:	00 00 00 
  8024ed:	be 28 00 00 00       	mov    $0x28,%esi
  8024f2:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8024f9:	00 00 00 
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802508:	00 00 00 
  80250b:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80250e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802512:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802520:	ba 00 10 00 00       	mov    $0x1000,%edx
  802525:	48 89 c6             	mov    %rax,%rsi
  802528:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80252d:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80253d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802545:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80254b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802551:	48 89 c1             	mov    %rax,%rcx
  802554:	ba 00 00 00 00       	mov    $0x0,%edx
  802559:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80255e:	bf 00 00 00 00       	mov    $0x0,%edi
  802563:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80256a:	00 00 00 
  80256d:	ff d0                	callq  *%rax
  80256f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802572:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802576:	79 30                	jns    8025a8 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802578:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80257b:	89 c1                	mov    %eax,%ecx
  80257d:	48 ba fe 5f 80 00 00 	movabs $0x805ffe,%rdx
  802584:	00 00 00 
  802587:	be 2d 00 00 00       	mov    $0x2d,%esi
  80258c:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  802593:	00 00 00 
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8025a2:	00 00 00 
  8025a5:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8025a8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8025ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b2:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
  8025be:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8025c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025c5:	79 30                	jns    8025f7 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8025c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025ca:	89 c1                	mov    %eax,%ecx
  8025cc:	48 ba 0f 60 80 00 00 	movabs $0x80600f,%rdx
  8025d3:	00 00 00 
  8025d6:	be 31 00 00 00       	mov    $0x31,%esi
  8025db:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8025e2:	00 00 00 
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ea:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8025f1:	00 00 00 
  8025f4:	41 ff d0             	callq  *%r8

}
  8025f7:	90                   	nop
  8025f8:	c9                   	leaveq 
  8025f9:	c3                   	retq   

00000000008025fa <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
  8025fe:	48 83 ec 30          	sub    $0x30,%rsp
  802602:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802605:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802608:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80260b:	c1 e0 0c             	shl    $0xc,%eax
  80260e:	89 c0                	mov    %eax,%eax
  802610:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802614:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80261b:	01 00 00 
  80261e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802621:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802625:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262d:	25 02 08 00 00       	and    $0x802,%eax
  802632:	48 85 c0             	test   %rax,%rax
  802635:	74 0e                	je     802645 <duppage+0x4b>
  802637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263b:	25 00 04 00 00       	and    $0x400,%eax
  802640:	48 85 c0             	test   %rax,%rax
  802643:	74 70                	je     8026b5 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802649:	25 07 0e 00 00       	and    $0xe07,%eax
  80264e:	89 c6                	mov    %eax,%esi
  802650:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802654:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80265b:	41 89 f0             	mov    %esi,%r8d
  80265e:	48 89 c6             	mov    %rax,%rsi
  802661:	bf 00 00 00 00       	mov    $0x0,%edi
  802666:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
  802672:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802675:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802679:	79 30                	jns    8026ab <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80267b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80267e:	89 c1                	mov    %eax,%ecx
  802680:	48 ba fe 5f 80 00 00 	movabs $0x805ffe,%rdx
  802687:	00 00 00 
  80268a:	be 50 00 00 00       	mov    $0x50,%esi
  80268f:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  802696:	00 00 00 
  802699:	b8 00 00 00 00       	mov    $0x0,%eax
  80269e:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8026a5:	00 00 00 
  8026a8:	41 ff d0             	callq  *%r8
		return 0;
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	e9 c4 00 00 00       	jmpq   802779 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8026b5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8026b9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026c0:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8026c6:	48 89 c6             	mov    %rax,%rsi
  8026c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ce:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
  8026da:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8026dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026e1:	79 30                	jns    802713 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8026e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e6:	89 c1                	mov    %eax,%ecx
  8026e8:	48 ba fe 5f 80 00 00 	movabs $0x805ffe,%rdx
  8026ef:	00 00 00 
  8026f2:	be 64 00 00 00       	mov    $0x64,%esi
  8026f7:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8026fe:	00 00 00 
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80270d:	00 00 00 
  802710:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802713:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271b:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802721:	48 89 d1             	mov    %rdx,%rcx
  802724:	ba 00 00 00 00       	mov    $0x0,%edx
  802729:	48 89 c6             	mov    %rax,%rsi
  80272c:	bf 00 00 00 00       	mov    $0x0,%edi
  802731:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802738:	00 00 00 
  80273b:	ff d0                	callq  *%rax
  80273d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802740:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802744:	79 30                	jns    802776 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802746:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802749:	89 c1                	mov    %eax,%ecx
  80274b:	48 ba fe 5f 80 00 00 	movabs $0x805ffe,%rdx
  802752:	00 00 00 
  802755:	be 66 00 00 00       	mov    $0x66,%esi
  80275a:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  802761:	00 00 00 
  802764:	b8 00 00 00 00       	mov    $0x0,%eax
  802769:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802770:	00 00 00 
  802773:	41 ff d0             	callq  *%r8
	return r;
  802776:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802779:	c9                   	leaveq 
  80277a:	c3                   	retq   

000000000080277b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80277b:	55                   	push   %rbp
  80277c:	48 89 e5             	mov    %rsp,%rbp
  80277f:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802783:	48 bf da 23 80 00 00 	movabs $0x8023da,%rdi
  80278a:	00 00 00 
  80278d:	48 b8 f0 53 80 00 00 	movabs $0x8053f0,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802799:	b8 07 00 00 00       	mov    $0x7,%eax
  80279e:	cd 30                	int    $0x30
  8027a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8027a3:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8027a6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8027a9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ad:	79 08                	jns    8027b7 <fork+0x3c>
		return envid;
  8027af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027b2:	e9 0b 02 00 00       	jmpq   8029c2 <fork+0x247>
	if (envid == 0) {
  8027b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027bb:	75 3e                	jne    8027fb <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8027bd:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027ce:	48 98                	cltq   
  8027d0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8027d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027de:	00 00 00 
  8027e1:	48 01 c2             	add    %rax,%rdx
  8027e4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8027eb:	00 00 00 
  8027ee:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	e9 c7 01 00 00       	jmpq   8029c2 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8027fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802802:	e9 a6 00 00 00       	jmpq   8028ad <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280a:	c1 f8 12             	sar    $0x12,%eax
  80280d:	89 c2                	mov    %eax,%edx
  80280f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802816:	01 00 00 
  802819:	48 63 d2             	movslq %edx,%rdx
  80281c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802820:	83 e0 01             	and    $0x1,%eax
  802823:	48 85 c0             	test   %rax,%rax
  802826:	74 21                	je     802849 <fork+0xce>
  802828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282b:	c1 f8 09             	sar    $0x9,%eax
  80282e:	89 c2                	mov    %eax,%edx
  802830:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802837:	01 00 00 
  80283a:	48 63 d2             	movslq %edx,%rdx
  80283d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802841:	83 e0 01             	and    $0x1,%eax
  802844:	48 85 c0             	test   %rax,%rax
  802847:	75 09                	jne    802852 <fork+0xd7>
			pn += NPTENTRIES;
  802849:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802850:	eb 5b                	jmp    8028ad <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802855:	05 00 02 00 00       	add    $0x200,%eax
  80285a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80285d:	eb 46                	jmp    8028a5 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80285f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802866:	01 00 00 
  802869:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80286c:	48 63 d2             	movslq %edx,%rdx
  80286f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802873:	83 e0 05             	and    $0x5,%eax
  802876:	48 83 f8 05          	cmp    $0x5,%rax
  80287a:	75 21                	jne    80289d <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80287c:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802883:	74 1b                	je     8028a0 <fork+0x125>
				continue;
			duppage(envid, pn);
  802885:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802888:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80288b:	89 d6                	mov    %edx,%esi
  80288d:	89 c7                	mov    %eax,%edi
  80288f:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802896:	00 00 00 
  802899:	ff d0                	callq  *%rax
  80289b:	eb 04                	jmp    8028a1 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80289d:	90                   	nop
  80289e:	eb 01                	jmp    8028a1 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  8028a0:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8028a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8028ab:	7c b2                	jl     80285f <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8028ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b0:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8028b5:	0f 86 4c ff ff ff    	jbe    802807 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8028bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028be:	ba 07 00 00 00       	mov    $0x7,%edx
  8028c3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8028c8:	89 c7                	mov    %eax,%edi
  8028ca:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	callq  *%rax
  8028d6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8028d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8028dd:	79 30                	jns    80290f <fork+0x194>
		panic("allocating exception stack: %e", r);
  8028df:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8028e2:	89 c1                	mov    %eax,%ecx
  8028e4:	48 ba 28 60 80 00 00 	movabs $0x806028,%rdx
  8028eb:	00 00 00 
  8028ee:	be 9e 00 00 00       	mov    $0x9e,%esi
  8028f3:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8028fa:	00 00 00 
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802902:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802909:	00 00 00 
  80290c:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80290f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802916:	00 00 00 
  802919:	48 8b 00             	mov    (%rax),%rax
  80291c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802923:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802926:	48 89 d6             	mov    %rdx,%rsi
  802929:	89 c7                	mov    %eax,%edi
  80292b:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  802932:	00 00 00 
  802935:	ff d0                	callq  *%rax
  802937:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80293a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80293e:	79 30                	jns    802970 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802940:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802943:	89 c1                	mov    %eax,%ecx
  802945:	48 ba 48 60 80 00 00 	movabs $0x806048,%rdx
  80294c:	00 00 00 
  80294f:	be a2 00 00 00       	mov    $0xa2,%esi
  802954:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  80295b:	00 00 00 
  80295e:	b8 00 00 00 00       	mov    $0x0,%eax
  802963:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80296a:	00 00 00 
  80296d:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802970:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802973:	be 02 00 00 00       	mov    $0x2,%esi
  802978:	89 c7                	mov    %eax,%edi
  80297a:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  802981:	00 00 00 
  802984:	ff d0                	callq  *%rax
  802986:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802989:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80298d:	79 30                	jns    8029bf <fork+0x244>
		panic("sys_env_set_status: %e", r);
  80298f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802992:	89 c1                	mov    %eax,%ecx
  802994:	48 ba 67 60 80 00 00 	movabs $0x806067,%rdx
  80299b:	00 00 00 
  80299e:	be a7 00 00 00       	mov    $0xa7,%esi
  8029a3:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8029aa:	00 00 00 
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b2:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8029b9:	00 00 00 
  8029bc:	41 ff d0             	callq  *%r8

	return envid;
  8029bf:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8029c2:	c9                   	leaveq 
  8029c3:	c3                   	retq   

00000000008029c4 <sfork>:

// Challenge!
int
sfork(void)
{
  8029c4:	55                   	push   %rbp
  8029c5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8029c8:	48 ba 7e 60 80 00 00 	movabs $0x80607e,%rdx
  8029cf:	00 00 00 
  8029d2:	be b1 00 00 00       	mov    $0xb1,%esi
  8029d7:	48 bf b1 5f 80 00 00 	movabs $0x805fb1,%rdi
  8029de:	00 00 00 
  8029e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e6:	48 b9 de 08 80 00 00 	movabs $0x8008de,%rcx
  8029ed:	00 00 00 
  8029f0:	ff d1                	callq  *%rcx

00000000008029f2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8029f2:	55                   	push   %rbp
  8029f3:	48 89 e5             	mov    %rsp,%rbp
  8029f6:	48 83 ec 08          	sub    $0x8,%rsp
  8029fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a02:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a09:	ff ff ff 
  802a0c:	48 01 d0             	add    %rdx,%rax
  802a0f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a13:	c9                   	leaveq 
  802a14:	c3                   	retq   

0000000000802a15 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	48 83 ec 08          	sub    $0x8,%rsp
  802a1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a25:	48 89 c7             	mov    %rax,%rdi
  802a28:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
  802a34:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a3a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a3e:	c9                   	leaveq 
  802a3f:	c3                   	retq   

0000000000802a40 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a40:	55                   	push   %rbp
  802a41:	48 89 e5             	mov    %rsp,%rbp
  802a44:	48 83 ec 18          	sub    $0x18,%rsp
  802a48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a53:	eb 6b                	jmp    802ac0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	48 98                	cltq   
  802a5a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a60:	48 c1 e0 0c          	shl    $0xc,%rax
  802a64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6c:	48 c1 e8 15          	shr    $0x15,%rax
  802a70:	48 89 c2             	mov    %rax,%rdx
  802a73:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a7a:	01 00 00 
  802a7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a81:	83 e0 01             	and    $0x1,%eax
  802a84:	48 85 c0             	test   %rax,%rax
  802a87:	74 21                	je     802aaa <fd_alloc+0x6a>
  802a89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8d:	48 c1 e8 0c          	shr    $0xc,%rax
  802a91:	48 89 c2             	mov    %rax,%rdx
  802a94:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a9b:	01 00 00 
  802a9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aa2:	83 e0 01             	and    $0x1,%eax
  802aa5:	48 85 c0             	test   %rax,%rax
  802aa8:	75 12                	jne    802abc <fd_alloc+0x7c>
			*fd_store = fd;
  802aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ab2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aba:	eb 1a                	jmp    802ad6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802abc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ac0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802ac4:	7e 8f                	jle    802a55 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aca:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802ad1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802ad6:	c9                   	leaveq 
  802ad7:	c3                   	retq   

0000000000802ad8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	48 83 ec 20          	sub    $0x20,%rsp
  802ae0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802ae7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802aeb:	78 06                	js     802af3 <fd_lookup+0x1b>
  802aed:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802af1:	7e 07                	jle    802afa <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802af3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802af8:	eb 6c                	jmp    802b66 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802afa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802afd:	48 98                	cltq   
  802aff:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b05:	48 c1 e0 0c          	shl    $0xc,%rax
  802b09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b11:	48 c1 e8 15          	shr    $0x15,%rax
  802b15:	48 89 c2             	mov    %rax,%rdx
  802b18:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b1f:	01 00 00 
  802b22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b26:	83 e0 01             	and    $0x1,%eax
  802b29:	48 85 c0             	test   %rax,%rax
  802b2c:	74 21                	je     802b4f <fd_lookup+0x77>
  802b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b32:	48 c1 e8 0c          	shr    $0xc,%rax
  802b36:	48 89 c2             	mov    %rax,%rdx
  802b39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b40:	01 00 00 
  802b43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b47:	83 e0 01             	and    $0x1,%eax
  802b4a:	48 85 c0             	test   %rax,%rax
  802b4d:	75 07                	jne    802b56 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b54:	eb 10                	jmp    802b66 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b5a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b5e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b66:	c9                   	leaveq 
  802b67:	c3                   	retq   

0000000000802b68 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
  802b6c:	48 83 ec 30          	sub    $0x30,%rsp
  802b70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b74:	89 f0                	mov    %esi,%eax
  802b76:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b7d:	48 89 c7             	mov    %rax,%rdi
  802b80:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	89 c2                	mov    %eax,%edx
  802b8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b92:	48 89 c6             	mov    %rax,%rsi
  802b95:	89 d7                	mov    %edx,%edi
  802b97:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	callq  *%rax
  802ba3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802baa:	78 0a                	js     802bb6 <fd_close+0x4e>
	    || fd != fd2)
  802bac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802bb4:	74 12                	je     802bc8 <fd_close+0x60>
		return (must_exist ? r : 0);
  802bb6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802bba:	74 05                	je     802bc1 <fd_close+0x59>
  802bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbf:	eb 70                	jmp    802c31 <fd_close+0xc9>
  802bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc6:	eb 69                	jmp    802c31 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bcc:	8b 00                	mov    (%rax),%eax
  802bce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bd2:	48 89 d6             	mov    %rdx,%rsi
  802bd5:	89 c7                	mov    %eax,%edi
  802bd7:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
  802be3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bea:	78 2a                	js     802c16 <fd_close+0xae>
		if (dev->dev_close)
  802bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf0:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bf4:	48 85 c0             	test   %rax,%rax
  802bf7:	74 16                	je     802c0f <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c01:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c05:	48 89 d7             	mov    %rdx,%rdi
  802c08:	ff d0                	callq  *%rax
  802c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0d:	eb 07                	jmp    802c16 <fd_close+0xae>
		else
			r = 0;
  802c0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c1a:	48 89 c6             	mov    %rax,%rsi
  802c1d:	bf 00 00 00 00       	mov    $0x0,%edi
  802c22:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
	return r;
  802c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c31:	c9                   	leaveq 
  802c32:	c3                   	retq   

0000000000802c33 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c33:	55                   	push   %rbp
  802c34:	48 89 e5             	mov    %rsp,%rbp
  802c37:	48 83 ec 20          	sub    $0x20,%rsp
  802c3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c49:	eb 41                	jmp    802c8c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c4b:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c52:	00 00 00 
  802c55:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c58:	48 63 d2             	movslq %edx,%rdx
  802c5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c5f:	8b 00                	mov    (%rax),%eax
  802c61:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c64:	75 22                	jne    802c88 <dev_lookup+0x55>
			*dev = devtab[i];
  802c66:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c6d:	00 00 00 
  802c70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c73:	48 63 d2             	movslq %edx,%rdx
  802c76:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	eb 60                	jmp    802ce8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802c88:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c8c:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c93:	00 00 00 
  802c96:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c99:	48 63 d2             	movslq %edx,%rdx
  802c9c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ca0:	48 85 c0             	test   %rax,%rax
  802ca3:	75 a6                	jne    802c4b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ca5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802cac:	00 00 00 
  802caf:	48 8b 00             	mov    (%rax),%rax
  802cb2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802cbb:	89 c6                	mov    %eax,%esi
  802cbd:	48 bf 98 60 80 00 00 	movabs $0x806098,%rdi
  802cc4:	00 00 00 
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccc:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  802cd3:	00 00 00 
  802cd6:	ff d1                	callq  *%rcx
	*dev = 0;
  802cd8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cdc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802ce3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ce8:	c9                   	leaveq 
  802ce9:	c3                   	retq   

0000000000802cea <close>:

int
close(int fdnum)
{
  802cea:	55                   	push   %rbp
  802ceb:	48 89 e5             	mov    %rsp,%rbp
  802cee:	48 83 ec 20          	sub    $0x20,%rsp
  802cf2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cf5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cfc:	48 89 d6             	mov    %rdx,%rsi
  802cff:	89 c7                	mov    %eax,%edi
  802d01:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
  802d0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d14:	79 05                	jns    802d1b <close+0x31>
		return r;
  802d16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d19:	eb 18                	jmp    802d33 <close+0x49>
	else
		return fd_close(fd, 1);
  802d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1f:	be 01 00 00 00       	mov    $0x1,%esi
  802d24:	48 89 c7             	mov    %rax,%rdi
  802d27:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
}
  802d33:	c9                   	leaveq 
  802d34:	c3                   	retq   

0000000000802d35 <close_all>:

void
close_all(void)
{
  802d35:	55                   	push   %rbp
  802d36:	48 89 e5             	mov    %rsp,%rbp
  802d39:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d44:	eb 15                	jmp    802d5b <close_all+0x26>
		close(i);
  802d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d49:	89 c7                	mov    %eax,%edi
  802d4b:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d5b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d5f:	7e e5                	jle    802d46 <close_all+0x11>
		close(i);
}
  802d61:	90                   	nop
  802d62:	c9                   	leaveq 
  802d63:	c3                   	retq   

0000000000802d64 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d64:	55                   	push   %rbp
  802d65:	48 89 e5             	mov    %rsp,%rbp
  802d68:	48 83 ec 40          	sub    $0x40,%rsp
  802d6c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d6f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d72:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d76:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d79:	48 89 d6             	mov    %rdx,%rsi
  802d7c:	89 c7                	mov    %eax,%edi
  802d7e:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
  802d8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d91:	79 08                	jns    802d9b <dup+0x37>
		return r;
  802d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d96:	e9 70 01 00 00       	jmpq   802f0b <dup+0x1a7>
	close(newfdnum);
  802d9b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d9e:	89 c7                	mov    %eax,%edi
  802da0:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  802da7:	00 00 00 
  802daa:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802dac:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802daf:	48 98                	cltq   
  802db1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802db7:	48 c1 e0 0c          	shl    $0xc,%rax
  802dbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802dbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc3:	48 89 c7             	mov    %rax,%rdi
  802dc6:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
  802dd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802dd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dda:	48 89 c7             	mov    %rax,%rdi
  802ddd:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
  802de9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df1:	48 c1 e8 15          	shr    $0x15,%rax
  802df5:	48 89 c2             	mov    %rax,%rdx
  802df8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802dff:	01 00 00 
  802e02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e06:	83 e0 01             	and    $0x1,%eax
  802e09:	48 85 c0             	test   %rax,%rax
  802e0c:	74 71                	je     802e7f <dup+0x11b>
  802e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e12:	48 c1 e8 0c          	shr    $0xc,%rax
  802e16:	48 89 c2             	mov    %rax,%rdx
  802e19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e20:	01 00 00 
  802e23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e27:	83 e0 01             	and    $0x1,%eax
  802e2a:	48 85 c0             	test   %rax,%rax
  802e2d:	74 50                	je     802e7f <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e33:	48 c1 e8 0c          	shr    $0xc,%rax
  802e37:	48 89 c2             	mov    %rax,%rdx
  802e3a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e41:	01 00 00 
  802e44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e48:	25 07 0e 00 00       	and    $0xe07,%eax
  802e4d:	89 c1                	mov    %eax,%ecx
  802e4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e57:	41 89 c8             	mov    %ecx,%r8d
  802e5a:	48 89 d1             	mov    %rdx,%rcx
  802e5d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e62:	48 89 c6             	mov    %rax,%rsi
  802e65:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6a:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
  802e76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7d:	78 55                	js     802ed4 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e83:	48 c1 e8 0c          	shr    $0xc,%rax
  802e87:	48 89 c2             	mov    %rax,%rdx
  802e8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e91:	01 00 00 
  802e94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e98:	25 07 0e 00 00       	and    $0xe07,%eax
  802e9d:	89 c1                	mov    %eax,%ecx
  802e9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ea7:	41 89 c8             	mov    %ecx,%r8d
  802eaa:	48 89 d1             	mov    %rdx,%rcx
  802ead:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb2:	48 89 c6             	mov    %rax,%rsi
  802eb5:	bf 00 00 00 00       	mov    $0x0,%edi
  802eba:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802ec1:	00 00 00 
  802ec4:	ff d0                	callq  *%rax
  802ec6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecd:	78 08                	js     802ed7 <dup+0x173>
		goto err;

	return newfdnum;
  802ecf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ed2:	eb 37                	jmp    802f0b <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ed4:	90                   	nop
  802ed5:	eb 01                	jmp    802ed8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ed7:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edc:	48 89 c6             	mov    %rax,%rsi
  802edf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee4:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802eeb:	00 00 00 
  802eee:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ef0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef4:	48 89 c6             	mov    %rax,%rsi
  802ef7:	bf 00 00 00 00       	mov    $0x0,%edi
  802efc:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
	return r;
  802f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f0b:	c9                   	leaveq 
  802f0c:	c3                   	retq   

0000000000802f0d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f0d:	55                   	push   %rbp
  802f0e:	48 89 e5             	mov    %rsp,%rbp
  802f11:	48 83 ec 40          	sub    $0x40,%rsp
  802f15:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f18:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f1c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f20:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f24:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f27:	48 89 d6             	mov    %rdx,%rsi
  802f2a:	89 c7                	mov    %eax,%edi
  802f2c:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
  802f38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3f:	78 24                	js     802f65 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f45:	8b 00                	mov    (%rax),%eax
  802f47:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f4b:	48 89 d6             	mov    %rdx,%rsi
  802f4e:	89 c7                	mov    %eax,%edi
  802f50:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f63:	79 05                	jns    802f6a <read+0x5d>
		return r;
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f68:	eb 76                	jmp    802fe0 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6e:	8b 40 08             	mov    0x8(%rax),%eax
  802f71:	83 e0 03             	and    $0x3,%eax
  802f74:	83 f8 01             	cmp    $0x1,%eax
  802f77:	75 3a                	jne    802fb3 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f79:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802f80:	00 00 00 
  802f83:	48 8b 00             	mov    (%rax),%rax
  802f86:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f8c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f8f:	89 c6                	mov    %eax,%esi
  802f91:	48 bf b7 60 80 00 00 	movabs $0x8060b7,%rdi
  802f98:	00 00 00 
  802f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa0:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  802fa7:	00 00 00 
  802faa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802fac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fb1:	eb 2d                	jmp    802fe0 <read+0xd3>
	}
	if (!dev->dev_read)
  802fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb7:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fbb:	48 85 c0             	test   %rax,%rax
  802fbe:	75 07                	jne    802fc7 <read+0xba>
		return -E_NOT_SUPP;
  802fc0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fc5:	eb 19                	jmp    802fe0 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcb:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fcf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fd3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fd7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fdb:	48 89 cf             	mov    %rcx,%rdi
  802fde:	ff d0                	callq  *%rax
}
  802fe0:	c9                   	leaveq 
  802fe1:	c3                   	retq   

0000000000802fe2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802fe2:	55                   	push   %rbp
  802fe3:	48 89 e5             	mov    %rsp,%rbp
  802fe6:	48 83 ec 30          	sub    $0x30,%rsp
  802fea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ffc:	eb 47                	jmp    803045 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803001:	48 98                	cltq   
  803003:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803007:	48 29 c2             	sub    %rax,%rdx
  80300a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300d:	48 63 c8             	movslq %eax,%rcx
  803010:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803014:	48 01 c1             	add    %rax,%rcx
  803017:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80301a:	48 89 ce             	mov    %rcx,%rsi
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
  80302b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80302e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803032:	79 05                	jns    803039 <readn+0x57>
			return m;
  803034:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803037:	eb 1d                	jmp    803056 <readn+0x74>
		if (m == 0)
  803039:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80303d:	74 13                	je     803052 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80303f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803042:	01 45 fc             	add    %eax,-0x4(%rbp)
  803045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803048:	48 98                	cltq   
  80304a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80304e:	72 ae                	jb     802ffe <readn+0x1c>
  803050:	eb 01                	jmp    803053 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803052:	90                   	nop
	}
	return tot;
  803053:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803056:	c9                   	leaveq 
  803057:	c3                   	retq   

0000000000803058 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803058:	55                   	push   %rbp
  803059:	48 89 e5             	mov    %rsp,%rbp
  80305c:	48 83 ec 40          	sub    $0x40,%rsp
  803060:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803063:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803067:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80306b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80306f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803072:	48 89 d6             	mov    %rdx,%rsi
  803075:	89 c7                	mov    %eax,%edi
  803077:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308a:	78 24                	js     8030b0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80308c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803090:	8b 00                	mov    (%rax),%eax
  803092:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803096:	48 89 d6             	mov    %rdx,%rsi
  803099:	89 c7                	mov    %eax,%edi
  80309b:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  8030a2:	00 00 00 
  8030a5:	ff d0                	callq  *%rax
  8030a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ae:	79 05                	jns    8030b5 <write+0x5d>
		return r;
  8030b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b3:	eb 75                	jmp    80312a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b9:	8b 40 08             	mov    0x8(%rax),%eax
  8030bc:	83 e0 03             	and    $0x3,%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	75 3a                	jne    8030fd <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030c3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8030ca:	00 00 00 
  8030cd:	48 8b 00             	mov    (%rax),%rax
  8030d0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030d6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030d9:	89 c6                	mov    %eax,%esi
  8030db:	48 bf d3 60 80 00 00 	movabs $0x8060d3,%rdi
  8030e2:	00 00 00 
  8030e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ea:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  8030f1:	00 00 00 
  8030f4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030fb:	eb 2d                	jmp    80312a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8030fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803101:	48 8b 40 18          	mov    0x18(%rax),%rax
  803105:	48 85 c0             	test   %rax,%rax
  803108:	75 07                	jne    803111 <write+0xb9>
		return -E_NOT_SUPP;
  80310a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80310f:	eb 19                	jmp    80312a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803111:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803115:	48 8b 40 18          	mov    0x18(%rax),%rax
  803119:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80311d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803121:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803125:	48 89 cf             	mov    %rcx,%rdi
  803128:	ff d0                	callq  *%rax
}
  80312a:	c9                   	leaveq 
  80312b:	c3                   	retq   

000000000080312c <seek>:

int
seek(int fdnum, off_t offset)
{
  80312c:	55                   	push   %rbp
  80312d:	48 89 e5             	mov    %rsp,%rbp
  803130:	48 83 ec 18          	sub    $0x18,%rsp
  803134:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803137:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80313a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80313e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803141:	48 89 d6             	mov    %rdx,%rsi
  803144:	89 c7                	mov    %eax,%edi
  803146:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80314d:	00 00 00 
  803150:	ff d0                	callq  *%rax
  803152:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803155:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803159:	79 05                	jns    803160 <seek+0x34>
		return r;
  80315b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315e:	eb 0f                	jmp    80316f <seek+0x43>
	fd->fd_offset = offset;
  803160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803164:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803167:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80316a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80316f:	c9                   	leaveq 
  803170:	c3                   	retq   

0000000000803171 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803171:	55                   	push   %rbp
  803172:	48 89 e5             	mov    %rsp,%rbp
  803175:	48 83 ec 30          	sub    $0x30,%rsp
  803179:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80317c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80317f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803183:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803186:	48 89 d6             	mov    %rdx,%rsi
  803189:	89 c7                	mov    %eax,%edi
  80318b:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
  803197:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80319e:	78 24                	js     8031c4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a4:	8b 00                	mov    (%rax),%eax
  8031a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031aa:	48 89 d6             	mov    %rdx,%rsi
  8031ad:	89 c7                	mov    %eax,%edi
  8031af:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
  8031bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c2:	79 05                	jns    8031c9 <ftruncate+0x58>
		return r;
  8031c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c7:	eb 72                	jmp    80323b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cd:	8b 40 08             	mov    0x8(%rax),%eax
  8031d0:	83 e0 03             	and    $0x3,%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	75 3a                	jne    803211 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8031d7:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8031de:	00 00 00 
  8031e1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8031e4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031ea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031ed:	89 c6                	mov    %eax,%esi
  8031ef:	48 bf f0 60 80 00 00 	movabs $0x8060f0,%rdi
  8031f6:	00 00 00 
  8031f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fe:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  803205:	00 00 00 
  803208:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80320a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80320f:	eb 2a                	jmp    80323b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	48 8b 40 30          	mov    0x30(%rax),%rax
  803219:	48 85 c0             	test   %rax,%rax
  80321c:	75 07                	jne    803225 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80321e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803223:	eb 16                	jmp    80323b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803229:	48 8b 40 30          	mov    0x30(%rax),%rax
  80322d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803231:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803234:	89 ce                	mov    %ecx,%esi
  803236:	48 89 d7             	mov    %rdx,%rdi
  803239:	ff d0                	callq  *%rax
}
  80323b:	c9                   	leaveq 
  80323c:	c3                   	retq   

000000000080323d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80323d:	55                   	push   %rbp
  80323e:	48 89 e5             	mov    %rsp,%rbp
  803241:	48 83 ec 30          	sub    $0x30,%rsp
  803245:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803248:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80324c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803250:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803253:	48 89 d6             	mov    %rdx,%rsi
  803256:	89 c7                	mov    %eax,%edi
  803258:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80325f:	00 00 00 
  803262:	ff d0                	callq  *%rax
  803264:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803267:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326b:	78 24                	js     803291 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80326d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803271:	8b 00                	mov    (%rax),%eax
  803273:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803277:	48 89 d6             	mov    %rdx,%rsi
  80327a:	89 c7                	mov    %eax,%edi
  80327c:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80328f:	79 05                	jns    803296 <fstat+0x59>
		return r;
  803291:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803294:	eb 5e                	jmp    8032f4 <fstat+0xb7>
	if (!dev->dev_stat)
  803296:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80329e:	48 85 c0             	test   %rax,%rax
  8032a1:	75 07                	jne    8032aa <fstat+0x6d>
		return -E_NOT_SUPP;
  8032a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032a8:	eb 4a                	jmp    8032f4 <fstat+0xb7>
	stat->st_name[0] = 0;
  8032aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ae:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8032bc:	00 00 00 
	stat->st_isdir = 0;
  8032bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032ca:	00 00 00 
	stat->st_dev = dev;
  8032cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8032dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032e8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8032ec:	48 89 ce             	mov    %rcx,%rsi
  8032ef:	48 89 d7             	mov    %rdx,%rdi
  8032f2:	ff d0                	callq  *%rax
}
  8032f4:	c9                   	leaveq 
  8032f5:	c3                   	retq   

00000000008032f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032f6:	55                   	push   %rbp
  8032f7:	48 89 e5             	mov    %rsp,%rbp
  8032fa:	48 83 ec 20          	sub    $0x20,%rsp
  8032fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803302:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330a:	be 00 00 00 00       	mov    $0x0,%esi
  80330f:	48 89 c7             	mov    %rax,%rdi
  803312:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
  80331e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803325:	79 05                	jns    80332c <stat+0x36>
		return fd;
  803327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332a:	eb 2f                	jmp    80335b <stat+0x65>
	r = fstat(fd, stat);
  80332c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803330:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803333:	48 89 d6             	mov    %rdx,%rsi
  803336:	89 c7                	mov    %eax,%edi
  803338:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  80333f:	00 00 00 
  803342:	ff d0                	callq  *%rax
  803344:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334a:	89 c7                	mov    %eax,%edi
  80334c:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803353:	00 00 00 
  803356:	ff d0                	callq  *%rax
	return r;
  803358:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80335b:	c9                   	leaveq 
  80335c:	c3                   	retq   

000000000080335d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80335d:	55                   	push   %rbp
  80335e:	48 89 e5             	mov    %rsp,%rbp
  803361:	48 83 ec 10          	sub    $0x10,%rsp
  803365:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80336c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803373:	00 00 00 
  803376:	8b 00                	mov    (%rax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	75 1f                	jne    80339b <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80337c:	bf 01 00 00 00       	mov    $0x1,%edi
  803381:	48 b8 e6 57 80 00 00 	movabs $0x8057e6,%rax
  803388:	00 00 00 
  80338b:	ff d0                	callq  *%rax
  80338d:	89 c2                	mov    %eax,%edx
  80338f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803396:	00 00 00 
  803399:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80339b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a2:	00 00 00 
  8033a5:	8b 00                	mov    (%rax),%eax
  8033a7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033aa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033af:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8033b6:	00 00 00 
  8033b9:	89 c7                	mov    %eax,%edi
  8033bb:	48 b8 da 55 80 00 00 	movabs $0x8055da,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8033c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8033d0:	48 89 c6             	mov    %rax,%rsi
  8033d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d8:	48 b8 19 55 80 00 00 	movabs $0x805519,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
}
  8033e4:	c9                   	leaveq 
  8033e5:	c3                   	retq   

00000000008033e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8033e6:	55                   	push   %rbp
  8033e7:	48 89 e5             	mov    %rsp,%rbp
  8033ea:	48 83 ec 20          	sub    $0x20,%rsp
  8033ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8033f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f9:	48 89 c7             	mov    %rax,%rdi
  8033fc:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80340d:	7e 0a                	jle    803419 <open+0x33>
		return -E_BAD_PATH;
  80340f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803414:	e9 a5 00 00 00       	jmpq   8034be <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803419:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 40 2a 80 00 00 	movabs $0x802a40,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803433:	79 08                	jns    80343d <open+0x57>
		return r;
  803435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803438:	e9 81 00 00 00       	jmpq   8034be <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80343d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803441:	48 89 c6             	mov    %rax,%rsi
  803444:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80344b:	00 00 00 
  80344e:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80345a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803461:	00 00 00 
  803464:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803467:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80346d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803471:	48 89 c6             	mov    %rax,%rsi
  803474:	bf 01 00 00 00       	mov    $0x1,%edi
  803479:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803480:	00 00 00 
  803483:	ff d0                	callq  *%rax
  803485:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348c:	79 1d                	jns    8034ab <open+0xc5>
		fd_close(fd, 0);
  80348e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803492:	be 00 00 00 00       	mov    $0x0,%esi
  803497:	48 89 c7             	mov    %rax,%rdi
  80349a:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
		return r;
  8034a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a9:	eb 13                	jmp    8034be <open+0xd8>
	}

	return fd2num(fd);
  8034ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034af:	48 89 c7             	mov    %rax,%rdi
  8034b2:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax

}
  8034be:	c9                   	leaveq 
  8034bf:	c3                   	retq   

00000000008034c0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034c0:	55                   	push   %rbp
  8034c1:	48 89 e5             	mov    %rsp,%rbp
  8034c4:	48 83 ec 10          	sub    $0x10,%rsp
  8034c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8034d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034da:	00 00 00 
  8034dd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8034df:	be 00 00 00 00       	mov    $0x0,%esi
  8034e4:	bf 06 00 00 00       	mov    $0x6,%edi
  8034e9:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  8034f0:	00 00 00 
  8034f3:	ff d0                	callq  *%rax
}
  8034f5:	c9                   	leaveq 
  8034f6:	c3                   	retq   

00000000008034f7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8034f7:	55                   	push   %rbp
  8034f8:	48 89 e5             	mov    %rsp,%rbp
  8034fb:	48 83 ec 30          	sub    $0x30,%rsp
  8034ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803503:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803507:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80350b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350f:	8b 50 0c             	mov    0xc(%rax),%edx
  803512:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803519:	00 00 00 
  80351c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80351e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803525:	00 00 00 
  803528:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80352c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803530:	be 00 00 00 00       	mov    $0x0,%esi
  803535:	bf 03 00 00 00       	mov    $0x3,%edi
  80353a:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803541:	00 00 00 
  803544:	ff d0                	callq  *%rax
  803546:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803549:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354d:	79 08                	jns    803557 <devfile_read+0x60>
		return r;
  80354f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803552:	e9 a4 00 00 00       	jmpq   8035fb <devfile_read+0x104>
	assert(r <= n);
  803557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355a:	48 98                	cltq   
  80355c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803560:	76 35                	jbe    803597 <devfile_read+0xa0>
  803562:	48 b9 16 61 80 00 00 	movabs $0x806116,%rcx
  803569:	00 00 00 
  80356c:	48 ba 1d 61 80 00 00 	movabs $0x80611d,%rdx
  803573:	00 00 00 
  803576:	be 86 00 00 00       	mov    $0x86,%esi
  80357b:	48 bf 32 61 80 00 00 	movabs $0x806132,%rdi
  803582:	00 00 00 
  803585:	b8 00 00 00 00       	mov    $0x0,%eax
  80358a:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803591:	00 00 00 
  803594:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803597:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80359e:	7e 35                	jle    8035d5 <devfile_read+0xde>
  8035a0:	48 b9 3d 61 80 00 00 	movabs $0x80613d,%rcx
  8035a7:	00 00 00 
  8035aa:	48 ba 1d 61 80 00 00 	movabs $0x80611d,%rdx
  8035b1:	00 00 00 
  8035b4:	be 87 00 00 00       	mov    $0x87,%esi
  8035b9:	48 bf 32 61 80 00 00 	movabs $0x806132,%rdi
  8035c0:	00 00 00 
  8035c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c8:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8035cf:	00 00 00 
  8035d2:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8035d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d8:	48 63 d0             	movslq %eax,%rdx
  8035db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035df:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035e6:	00 00 00 
  8035e9:	48 89 c7             	mov    %rax,%rdi
  8035ec:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  8035f3:	00 00 00 
  8035f6:	ff d0                	callq  *%rax
	return r;
  8035f8:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8035fb:	c9                   	leaveq 
  8035fc:	c3                   	retq   

00000000008035fd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035fd:	55                   	push   %rbp
  8035fe:	48 89 e5             	mov    %rsp,%rbp
  803601:	48 83 ec 40          	sub    $0x40,%rsp
  803605:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803609:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80360d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803611:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803615:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803619:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803620:	00 
  803621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803625:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803629:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80362e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803636:	8b 50 0c             	mov    0xc(%rax),%edx
  803639:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803640:	00 00 00 
  803643:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803645:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364c:	00 00 00 
  80364f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803653:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803657:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80365b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80365f:	48 89 c6             	mov    %rax,%rsi
  803662:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803669:	00 00 00 
  80366c:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803678:	be 00 00 00 00       	mov    $0x0,%esi
  80367d:	bf 04 00 00 00       	mov    $0x4,%edi
  803682:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
  80368e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803691:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803695:	79 05                	jns    80369c <devfile_write+0x9f>
		return r;
  803697:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80369a:	eb 43                	jmp    8036df <devfile_write+0xe2>
	assert(r <= n);
  80369c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80369f:	48 98                	cltq   
  8036a1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036a5:	76 35                	jbe    8036dc <devfile_write+0xdf>
  8036a7:	48 b9 16 61 80 00 00 	movabs $0x806116,%rcx
  8036ae:	00 00 00 
  8036b1:	48 ba 1d 61 80 00 00 	movabs $0x80611d,%rdx
  8036b8:	00 00 00 
  8036bb:	be a2 00 00 00       	mov    $0xa2,%esi
  8036c0:	48 bf 32 61 80 00 00 	movabs $0x806132,%rdi
  8036c7:	00 00 00 
  8036ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cf:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8036d6:	00 00 00 
  8036d9:	41 ff d0             	callq  *%r8
	return r;
  8036dc:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8036df:	c9                   	leaveq 
  8036e0:	c3                   	retq   

00000000008036e1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8036e1:	55                   	push   %rbp
  8036e2:	48 89 e5             	mov    %rsp,%rbp
  8036e5:	48 83 ec 20          	sub    $0x20,%rsp
  8036e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8036f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ff:	00 00 00 
  803702:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803704:	be 00 00 00 00       	mov    $0x0,%esi
  803709:	bf 05 00 00 00       	mov    $0x5,%edi
  80370e:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803715:	00 00 00 
  803718:	ff d0                	callq  *%rax
  80371a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803721:	79 05                	jns    803728 <devfile_stat+0x47>
		return r;
  803723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803726:	eb 56                	jmp    80377e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803728:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372c:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803733:	00 00 00 
  803736:	48 89 c7             	mov    %rax,%rdi
  803739:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  803740:	00 00 00 
  803743:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803745:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80374c:	00 00 00 
  80374f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803755:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803759:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80375f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803766:	00 00 00 
  803769:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80376f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803773:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80377e:	c9                   	leaveq 
  80377f:	c3                   	retq   

0000000000803780 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803780:	55                   	push   %rbp
  803781:	48 89 e5             	mov    %rsp,%rbp
  803784:	48 83 ec 10          	sub    $0x10,%rsp
  803788:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80378c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80378f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803793:	8b 50 0c             	mov    0xc(%rax),%edx
  803796:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379d:	00 00 00 
  8037a0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8037a2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a9:	00 00 00 
  8037ac:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037af:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8037b2:	be 00 00 00 00       	mov    $0x0,%esi
  8037b7:	bf 02 00 00 00       	mov    $0x2,%edi
  8037bc:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  8037c3:	00 00 00 
  8037c6:	ff d0                	callq  *%rax
}
  8037c8:	c9                   	leaveq 
  8037c9:	c3                   	retq   

00000000008037ca <remove>:

// Delete a file
int
remove(const char *path)
{
  8037ca:	55                   	push   %rbp
  8037cb:	48 89 e5             	mov    %rsp,%rbp
  8037ce:	48 83 ec 10          	sub    $0x10,%rsp
  8037d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8037d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037da:	48 89 c7             	mov    %rax,%rdi
  8037dd:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
  8037e9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8037ee:	7e 07                	jle    8037f7 <remove+0x2d>
		return -E_BAD_PATH;
  8037f0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8037f5:	eb 33                	jmp    80382a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8037f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fb:	48 89 c6             	mov    %rax,%rsi
  8037fe:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803805:	00 00 00 
  803808:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803814:	be 00 00 00 00       	mov    $0x0,%esi
  803819:	bf 07 00 00 00       	mov    $0x7,%edi
  80381e:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803825:	00 00 00 
  803828:	ff d0                	callq  *%rax
}
  80382a:	c9                   	leaveq 
  80382b:	c3                   	retq   

000000000080382c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80382c:	55                   	push   %rbp
  80382d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803830:	be 00 00 00 00       	mov    $0x0,%esi
  803835:	bf 08 00 00 00       	mov    $0x8,%edi
  80383a:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
}
  803846:	5d                   	pop    %rbp
  803847:	c3                   	retq   

0000000000803848 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803848:	55                   	push   %rbp
  803849:	48 89 e5             	mov    %rsp,%rbp
  80384c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803853:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80385a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803861:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803868:	be 00 00 00 00       	mov    $0x0,%esi
  80386d:	48 89 c7             	mov    %rax,%rdi
  803870:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  803877:	00 00 00 
  80387a:	ff d0                	callq  *%rax
  80387c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80387f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803883:	79 28                	jns    8038ad <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803888:	89 c6                	mov    %eax,%esi
  80388a:	48 bf 49 61 80 00 00 	movabs $0x806149,%rdi
  803891:	00 00 00 
  803894:	b8 00 00 00 00       	mov    $0x0,%eax
  803899:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  8038a0:	00 00 00 
  8038a3:	ff d2                	callq  *%rdx
		return fd_src;
  8038a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a8:	e9 76 01 00 00       	jmpq   803a23 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8038ad:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8038b4:	be 01 01 00 00       	mov    $0x101,%esi
  8038b9:	48 89 c7             	mov    %rax,%rdi
  8038bc:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
  8038c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8038cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038cf:	0f 89 ad 00 00 00    	jns    803982 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8038d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038d8:	89 c6                	mov    %eax,%esi
  8038da:	48 bf 5f 61 80 00 00 	movabs $0x80615f,%rdi
  8038e1:	00 00 00 
  8038e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e9:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  8038f0:	00 00 00 
  8038f3:	ff d2                	callq  *%rdx
		close(fd_src);
  8038f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f8:	89 c7                	mov    %eax,%edi
  8038fa:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803901:	00 00 00 
  803904:	ff d0                	callq  *%rax
		return fd_dest;
  803906:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803909:	e9 15 01 00 00       	jmpq   803a23 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80390e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803911:	48 63 d0             	movslq %eax,%rdx
  803914:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80391b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80391e:	48 89 ce             	mov    %rcx,%rsi
  803921:	89 c7                	mov    %eax,%edi
  803923:	48 b8 58 30 80 00 00 	movabs $0x803058,%rax
  80392a:	00 00 00 
  80392d:	ff d0                	callq  *%rax
  80392f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803932:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803936:	79 4a                	jns    803982 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803938:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80393b:	89 c6                	mov    %eax,%esi
  80393d:	48 bf 79 61 80 00 00 	movabs $0x806179,%rdi
  803944:	00 00 00 
  803947:	b8 00 00 00 00       	mov    $0x0,%eax
  80394c:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  803953:	00 00 00 
  803956:	ff d2                	callq  *%rdx
			close(fd_src);
  803958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395b:	89 c7                	mov    %eax,%edi
  80395d:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
			close(fd_dest);
  803969:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80396c:	89 c7                	mov    %eax,%edi
  80396e:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803975:	00 00 00 
  803978:	ff d0                	callq  *%rax
			return write_size;
  80397a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80397d:	e9 a1 00 00 00       	jmpq   803a23 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803982:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803989:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398c:	ba 00 02 00 00       	mov    $0x200,%edx
  803991:	48 89 ce             	mov    %rcx,%rsi
  803994:	89 c7                	mov    %eax,%edi
  803996:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8039a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039a9:	0f 8f 5f ff ff ff    	jg     80390e <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8039af:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039b3:	79 47                	jns    8039fc <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8039b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039b8:	89 c6                	mov    %eax,%esi
  8039ba:	48 bf 8c 61 80 00 00 	movabs $0x80618c,%rdi
  8039c1:	00 00 00 
  8039c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c9:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  8039d0:	00 00 00 
  8039d3:	ff d2                	callq  *%rdx
		close(fd_src);
  8039d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d8:	89 c7                	mov    %eax,%edi
  8039da:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
		close(fd_dest);
  8039e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039e9:	89 c7                	mov    %eax,%edi
  8039eb:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  8039f2:	00 00 00 
  8039f5:	ff d0                	callq  *%rax
		return read_size;
  8039f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039fa:	eb 27                	jmp    803a23 <copy+0x1db>
	}
	close(fd_src);
  8039fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ff:	89 c7                	mov    %eax,%edi
  803a01:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
	close(fd_dest);
  803a0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a10:	89 c7                	mov    %eax,%edi
  803a12:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803a19:	00 00 00 
  803a1c:	ff d0                	callq  *%rax
	return 0;
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803a23:	c9                   	leaveq 
  803a24:	c3                   	retq   

0000000000803a25 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803a25:	55                   	push   %rbp
  803a26:	48 89 e5             	mov    %rsp,%rbp
  803a29:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  803a30:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803a37:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803a3e:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803a45:	be 00 00 00 00       	mov    $0x0,%esi
  803a4a:	48 89 c7             	mov    %rax,%rdi
  803a4d:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  803a54:	00 00 00 
  803a57:	ff d0                	callq  *%rax
  803a59:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a5c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a60:	79 08                	jns    803a6a <spawn+0x45>
		return r;
  803a62:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a65:	e9 11 03 00 00       	jmpq   803d7b <spawn+0x356>
	fd = r;
  803a6a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a6d:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803a70:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803a77:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803a7b:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803a82:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a85:	ba 00 02 00 00       	mov    $0x200,%edx
  803a8a:	48 89 ce             	mov    %rcx,%rsi
  803a8d:	89 c7                	mov    %eax,%edi
  803a8f:	48 b8 e2 2f 80 00 00 	movabs $0x802fe2,%rax
  803a96:	00 00 00 
  803a99:	ff d0                	callq  *%rax
  803a9b:	3d 00 02 00 00       	cmp    $0x200,%eax
  803aa0:	75 0d                	jne    803aaf <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803aa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa6:	8b 00                	mov    (%rax),%eax
  803aa8:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803aad:	74 43                	je     803af2 <spawn+0xcd>
		close(fd);
  803aaf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ab2:	89 c7                	mov    %eax,%edi
  803ab4:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac4:	8b 00                	mov    (%rax),%eax
  803ac6:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803acb:	89 c6                	mov    %eax,%esi
  803acd:	48 bf a8 61 80 00 00 	movabs $0x8061a8,%rdi
  803ad4:	00 00 00 
  803ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  803adc:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  803ae3:	00 00 00 
  803ae6:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803ae8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803aed:	e9 89 02 00 00       	jmpq   803d7b <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803af2:	b8 07 00 00 00       	mov    $0x7,%eax
  803af7:	cd 30                	int    $0x30
  803af9:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803afc:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803aff:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b02:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b06:	79 08                	jns    803b10 <spawn+0xeb>
		return r;
  803b08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b0b:	e9 6b 02 00 00       	jmpq   803d7b <spawn+0x356>
	child = r;
  803b10:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b13:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803b16:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b19:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b1e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b25:	00 00 00 
  803b28:	48 98                	cltq   
  803b2a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803b31:	48 01 c2             	add    %rax,%rdx
  803b34:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803b3b:	48 89 d6             	mov    %rdx,%rsi
  803b3e:	ba 18 00 00 00       	mov    $0x18,%edx
  803b43:	48 89 c7             	mov    %rax,%rdi
  803b46:	48 89 d1             	mov    %rdx,%rcx
  803b49:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803b4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b50:	48 8b 40 18          	mov    0x18(%rax),%rax
  803b54:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803b5b:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803b62:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803b69:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803b70:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b73:	48 89 ce             	mov    %rcx,%rsi
  803b76:	89 c7                	mov    %eax,%edi
  803b78:	48 b8 df 3f 80 00 00 	movabs $0x803fdf,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	callq  *%rax
  803b84:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b87:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b8b:	79 08                	jns    803b95 <spawn+0x170>
		return r;
  803b8d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b90:	e9 e6 01 00 00       	jmpq   803d7b <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b99:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b9d:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803ba4:	48 01 d0             	add    %rdx,%rax
  803ba7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bb2:	e9 80 00 00 00       	jmpq   803c37 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  803bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbb:	8b 00                	mov    (%rax),%eax
  803bbd:	83 f8 01             	cmp    $0x1,%eax
  803bc0:	75 6b                	jne    803c2d <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  803bc2:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803bc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcd:	8b 40 04             	mov    0x4(%rax),%eax
  803bd0:	83 e0 02             	and    $0x2,%eax
  803bd3:	85 c0                	test   %eax,%eax
  803bd5:	74 04                	je     803bdb <spawn+0x1b6>
			perm |= PTE_W;
  803bd7:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdf:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803be3:	41 89 c1             	mov    %eax,%r9d
  803be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bea:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf2:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfa:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803bfe:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803c01:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c04:	48 83 ec 08          	sub    $0x8,%rsp
  803c08:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803c0b:	57                   	push   %rdi
  803c0c:	89 c7                	mov    %eax,%edi
  803c0e:	48 b8 8b 42 80 00 00 	movabs $0x80428b,%rax
  803c15:	00 00 00 
  803c18:	ff d0                	callq  *%rax
  803c1a:	48 83 c4 10          	add    $0x10,%rsp
  803c1e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c21:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c25:	0f 88 2a 01 00 00    	js     803d55 <spawn+0x330>
  803c2b:	eb 01                	jmp    803c2e <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803c2d:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803c2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c32:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803c37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c3b:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803c3f:	0f b7 c0             	movzwl %ax,%eax
  803c42:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803c45:	0f 8f 6c ff ff ff    	jg     803bb7 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803c4b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c4e:	89 c7                	mov    %eax,%edi
  803c50:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
	fd = -1;
  803c5c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803c63:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c66:	89 c7                	mov    %eax,%edi
  803c68:	48 b8 77 44 80 00 00 	movabs $0x804477,%rax
  803c6f:	00 00 00 
  803c72:	ff d0                	callq  *%rax
  803c74:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c77:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c7b:	79 30                	jns    803cad <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  803c7d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c80:	89 c1                	mov    %eax,%ecx
  803c82:	48 ba c2 61 80 00 00 	movabs $0x8061c2,%rdx
  803c89:	00 00 00 
  803c8c:	be 86 00 00 00       	mov    $0x86,%esi
  803c91:	48 bf d8 61 80 00 00 	movabs $0x8061d8,%rdi
  803c98:	00 00 00 
  803c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca0:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803ca7:	00 00 00 
  803caa:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803cad:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803cb4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803cb7:	48 89 d6             	mov    %rdx,%rsi
  803cba:	89 c7                	mov    %eax,%edi
  803cbc:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  803cc3:	00 00 00 
  803cc6:	ff d0                	callq  *%rax
  803cc8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ccb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ccf:	79 30                	jns    803d01 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  803cd1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cd4:	89 c1                	mov    %eax,%ecx
  803cd6:	48 ba e4 61 80 00 00 	movabs $0x8061e4,%rdx
  803cdd:	00 00 00 
  803ce0:	be 8a 00 00 00       	mov    $0x8a,%esi
  803ce5:	48 bf d8 61 80 00 00 	movabs $0x8061d8,%rdi
  803cec:	00 00 00 
  803cef:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf4:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803cfb:	00 00 00 
  803cfe:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803d01:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d04:	be 02 00 00 00       	mov    $0x2,%esi
  803d09:	89 c7                	mov    %eax,%edi
  803d0b:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  803d12:	00 00 00 
  803d15:	ff d0                	callq  *%rax
  803d17:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d1e:	79 30                	jns    803d50 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  803d20:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d23:	89 c1                	mov    %eax,%ecx
  803d25:	48 ba fe 61 80 00 00 	movabs $0x8061fe,%rdx
  803d2c:	00 00 00 
  803d2f:	be 8d 00 00 00       	mov    $0x8d,%esi
  803d34:	48 bf d8 61 80 00 00 	movabs $0x8061d8,%rdi
  803d3b:	00 00 00 
  803d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d43:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803d4a:	00 00 00 
  803d4d:	41 ff d0             	callq  *%r8

	return child;
  803d50:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d53:	eb 26                	jmp    803d7b <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803d55:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803d56:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d59:	89 c7                	mov    %eax,%edi
  803d5b:	48 b8 1f 1f 80 00 00 	movabs $0x801f1f,%rax
  803d62:	00 00 00 
  803d65:	ff d0                	callq  *%rax
	close(fd);
  803d67:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803d6a:	89 c7                	mov    %eax,%edi
  803d6c:	48 b8 ea 2c 80 00 00 	movabs $0x802cea,%rax
  803d73:	00 00 00 
  803d76:	ff d0                	callq  *%rax
	return r;
  803d78:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  803d7b:	c9                   	leaveq 
  803d7c:	c3                   	retq   

0000000000803d7d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803d7d:	55                   	push   %rbp
  803d7e:	48 89 e5             	mov    %rsp,%rbp
  803d81:	41 55                	push   %r13
  803d83:	41 54                	push   %r12
  803d85:	53                   	push   %rbx
  803d86:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d8d:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803d94:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  803d9b:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803da2:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803da9:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803db0:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803db7:	84 c0                	test   %al,%al
  803db9:	74 26                	je     803de1 <spawnl+0x64>
  803dbb:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803dc2:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803dc9:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803dcd:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803dd1:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803dd5:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803dd9:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803ddd:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803de1:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803de8:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803deb:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803df2:	00 00 00 
  803df5:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803dfc:	00 00 00 
  803dff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e03:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803e0a:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803e11:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803e18:	eb 07                	jmp    803e21 <spawnl+0xa4>
		argc++;
  803e1a:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803e21:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803e27:	83 f8 30             	cmp    $0x30,%eax
  803e2a:	73 23                	jae    803e4f <spawnl+0xd2>
  803e2c:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  803e33:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803e39:	89 d2                	mov    %edx,%edx
  803e3b:	48 01 d0             	add    %rdx,%rax
  803e3e:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803e44:	83 c2 08             	add    $0x8,%edx
  803e47:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803e4d:	eb 12                	jmp    803e61 <spawnl+0xe4>
  803e4f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e56:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803e5a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e61:	48 8b 00             	mov    (%rax),%rax
  803e64:	48 85 c0             	test   %rax,%rax
  803e67:	75 b1                	jne    803e1a <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803e69:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803e6f:	83 c0 02             	add    $0x2,%eax
  803e72:	48 89 e2             	mov    %rsp,%rdx
  803e75:	48 89 d3             	mov    %rdx,%rbx
  803e78:	48 63 d0             	movslq %eax,%rdx
  803e7b:	48 83 ea 01          	sub    $0x1,%rdx
  803e7f:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803e86:	48 63 d0             	movslq %eax,%rdx
  803e89:	49 89 d4             	mov    %rdx,%r12
  803e8c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803e92:	48 63 d0             	movslq %eax,%rdx
  803e95:	49 89 d2             	mov    %rdx,%r10
  803e98:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803e9e:	48 98                	cltq   
  803ea0:	48 c1 e0 03          	shl    $0x3,%rax
  803ea4:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803ea8:	b8 10 00 00 00       	mov    $0x10,%eax
  803ead:	48 83 e8 01          	sub    $0x1,%rax
  803eb1:	48 01 d0             	add    %rdx,%rax
  803eb4:	be 10 00 00 00       	mov    $0x10,%esi
  803eb9:	ba 00 00 00 00       	mov    $0x0,%edx
  803ebe:	48 f7 f6             	div    %rsi
  803ec1:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803ec5:	48 29 c4             	sub    %rax,%rsp
  803ec8:	48 89 e0             	mov    %rsp,%rax
  803ecb:	48 83 c0 07          	add    $0x7,%rax
  803ecf:	48 c1 e8 03          	shr    $0x3,%rax
  803ed3:	48 c1 e0 03          	shl    $0x3,%rax
  803ed7:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803ede:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803ee5:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803eec:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803eef:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803ef5:	8d 50 01             	lea    0x1(%rax),%edx
  803ef8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803eff:	48 63 d2             	movslq %edx,%rdx
  803f02:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803f09:	00 

	va_start(vl, arg0);
  803f0a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803f11:	00 00 00 
  803f14:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803f1b:	00 00 00 
  803f1e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f22:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803f29:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803f30:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803f37:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803f3e:	00 00 00 
  803f41:	eb 60                	jmp    803fa3 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  803f43:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803f49:	8d 48 01             	lea    0x1(%rax),%ecx
  803f4c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f52:	83 f8 30             	cmp    $0x30,%eax
  803f55:	73 23                	jae    803f7a <spawnl+0x1fd>
  803f57:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  803f5e:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f64:	89 d2                	mov    %edx,%edx
  803f66:	48 01 d0             	add    %rdx,%rax
  803f69:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f6f:	83 c2 08             	add    $0x8,%edx
  803f72:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803f78:	eb 12                	jmp    803f8c <spawnl+0x20f>
  803f7a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f81:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803f85:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f8c:	48 8b 10             	mov    (%rax),%rdx
  803f8f:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f96:	89 c9                	mov    %ecx,%ecx
  803f98:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803f9c:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803fa3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803fa9:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  803faf:	72 92                	jb     803f43 <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803fb1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803fb8:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803fbf:	48 89 d6             	mov    %rdx,%rsi
  803fc2:	48 89 c7             	mov    %rax,%rdi
  803fc5:	48 b8 25 3a 80 00 00 	movabs $0x803a25,%rax
  803fcc:	00 00 00 
  803fcf:	ff d0                	callq  *%rax
  803fd1:	48 89 dc             	mov    %rbx,%rsp
}
  803fd4:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803fd8:	5b                   	pop    %rbx
  803fd9:	41 5c                	pop    %r12
  803fdb:	41 5d                	pop    %r13
  803fdd:	5d                   	pop    %rbp
  803fde:	c3                   	retq   

0000000000803fdf <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803fdf:	55                   	push   %rbp
  803fe0:	48 89 e5             	mov    %rsp,%rbp
  803fe3:	48 83 ec 50          	sub    $0x50,%rsp
  803fe7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803fea:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803fee:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803ff2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ff9:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803ffa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804001:	eb 33                	jmp    804036 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804003:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804006:	48 98                	cltq   
  804008:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80400f:	00 
  804010:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804014:	48 01 d0             	add    %rdx,%rax
  804017:	48 8b 00             	mov    (%rax),%rax
  80401a:	48 89 c7             	mov    %rax,%rdi
  80401d:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  804024:	00 00 00 
  804027:	ff d0                	callq  *%rax
  804029:	83 c0 01             	add    $0x1,%eax
  80402c:	48 98                	cltq   
  80402e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804032:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804036:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804039:	48 98                	cltq   
  80403b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804042:	00 
  804043:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804047:	48 01 d0             	add    %rdx,%rax
  80404a:	48 8b 00             	mov    (%rax),%rax
  80404d:	48 85 c0             	test   %rax,%rax
  804050:	75 b1                	jne    804003 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804056:	48 f7 d8             	neg    %rax
  804059:	48 05 00 10 40 00    	add    $0x401000,%rax
  80405f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804063:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804067:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80406b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80406f:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804073:	48 89 c2             	mov    %rax,%rdx
  804076:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804079:	83 c0 01             	add    $0x1,%eax
  80407c:	c1 e0 03             	shl    $0x3,%eax
  80407f:	48 98                	cltq   
  804081:	48 f7 d8             	neg    %rax
  804084:	48 01 d0             	add    %rdx,%rax
  804087:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80408b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80408f:	48 83 e8 10          	sub    $0x10,%rax
  804093:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804099:	77 0a                	ja     8040a5 <init_stack+0xc6>
		return -E_NO_MEM;
  80409b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8040a0:	e9 e4 01 00 00       	jmpq   804289 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8040a5:	ba 07 00 00 00       	mov    $0x7,%edx
  8040aa:	be 00 00 40 00       	mov    $0x400000,%esi
  8040af:	bf 00 00 00 00       	mov    $0x0,%edi
  8040b4:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8040bb:	00 00 00 
  8040be:	ff d0                	callq  *%rax
  8040c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040c7:	79 08                	jns    8040d1 <init_stack+0xf2>
		return r;
  8040c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040cc:	e9 b8 01 00 00       	jmpq   804289 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8040d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8040d8:	e9 8a 00 00 00       	jmpq   804167 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  8040dd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040e0:	48 98                	cltq   
  8040e2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040e9:	00 
  8040ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040ee:	48 01 d0             	add    %rdx,%rax
  8040f1:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8040f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040fa:	48 01 ca             	add    %rcx,%rdx
  8040fd:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  804104:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  804107:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80410a:	48 98                	cltq   
  80410c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804113:	00 
  804114:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804118:	48 01 d0             	add    %rdx,%rax
  80411b:	48 8b 10             	mov    (%rax),%rdx
  80411e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804122:	48 89 d6             	mov    %rdx,%rsi
  804125:	48 89 c7             	mov    %rax,%rdi
  804128:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80412f:	00 00 00 
  804132:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804134:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804137:	48 98                	cltq   
  804139:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804140:	00 
  804141:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804145:	48 01 d0             	add    %rdx,%rax
  804148:	48 8b 00             	mov    (%rax),%rax
  80414b:	48 89 c7             	mov    %rax,%rdi
  80414e:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  804155:	00 00 00 
  804158:	ff d0                	callq  *%rax
  80415a:	83 c0 01             	add    $0x1,%eax
  80415d:	48 98                	cltq   
  80415f:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804163:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804167:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80416a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80416d:	0f 8c 6a ff ff ff    	jl     8040dd <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804176:	48 98                	cltq   
  804178:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80417f:	00 
  804180:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804184:	48 01 d0             	add    %rdx,%rax
  804187:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80418e:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804195:	00 
  804196:	74 35                	je     8041cd <init_stack+0x1ee>
  804198:	48 b9 18 62 80 00 00 	movabs $0x806218,%rcx
  80419f:	00 00 00 
  8041a2:	48 ba 3e 62 80 00 00 	movabs $0x80623e,%rdx
  8041a9:	00 00 00 
  8041ac:	be f6 00 00 00       	mov    $0xf6,%esi
  8041b1:	48 bf d8 61 80 00 00 	movabs $0x8061d8,%rdi
  8041b8:	00 00 00 
  8041bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8041c0:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8041c7:	00 00 00 
  8041ca:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8041cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041d1:	48 83 e8 08          	sub    $0x8,%rax
  8041d5:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8041da:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8041de:	48 01 ca             	add    %rcx,%rdx
  8041e1:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8041e8:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  8041eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041ef:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8041f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041f6:	48 98                	cltq   
  8041f8:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8041fb:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804200:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804204:	48 01 d0             	add    %rdx,%rax
  804207:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80420d:	48 89 c2             	mov    %rax,%rdx
  804210:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804214:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804217:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80421a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804220:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804225:	89 c2                	mov    %eax,%edx
  804227:	be 00 00 40 00       	mov    $0x400000,%esi
  80422c:	bf 00 00 00 00       	mov    $0x0,%edi
  804231:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804238:	00 00 00 
  80423b:	ff d0                	callq  *%rax
  80423d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804240:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804244:	78 26                	js     80426c <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804246:	be 00 00 40 00       	mov    $0x400000,%esi
  80424b:	bf 00 00 00 00       	mov    $0x0,%edi
  804250:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804257:	00 00 00 
  80425a:	ff d0                	callq  *%rax
  80425c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80425f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804263:	78 0a                	js     80426f <init_stack+0x290>
		goto error;

	return 0;
  804265:	b8 00 00 00 00       	mov    $0x0,%eax
  80426a:	eb 1d                	jmp    804289 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  80426c:	90                   	nop
  80426d:	eb 01                	jmp    804270 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  80426f:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  804270:	be 00 00 40 00       	mov    $0x400000,%esi
  804275:	bf 00 00 00 00       	mov    $0x0,%edi
  80427a:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804281:	00 00 00 
  804284:	ff d0                	callq  *%rax
	return r;
  804286:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804289:	c9                   	leaveq 
  80428a:	c3                   	retq   

000000000080428b <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80428b:	55                   	push   %rbp
  80428c:	48 89 e5             	mov    %rsp,%rbp
  80428f:	48 83 ec 50          	sub    $0x50,%rsp
  804293:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804296:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80429a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80429e:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8042a1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8042a5:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8042a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042ad:	25 ff 0f 00 00       	and    $0xfff,%eax
  8042b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b9:	74 21                	je     8042dc <map_segment+0x51>
		va -= i;
  8042bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042be:	48 98                	cltq   
  8042c0:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8042c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c7:	48 98                	cltq   
  8042c9:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8042cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d0:	48 98                	cltq   
  8042d2:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8042d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d9:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8042dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042e3:	e9 79 01 00 00       	jmpq   804461 <map_segment+0x1d6>
		if (i >= filesz) {
  8042e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042eb:	48 98                	cltq   
  8042ed:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8042f1:	72 3c                	jb     80432f <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8042f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f6:	48 63 d0             	movslq %eax,%rdx
  8042f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042fd:	48 01 d0             	add    %rdx,%rax
  804300:	48 89 c1             	mov    %rax,%rcx
  804303:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804306:	8b 55 10             	mov    0x10(%rbp),%edx
  804309:	48 89 ce             	mov    %rcx,%rsi
  80430c:	89 c7                	mov    %eax,%edi
  80430e:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804315:	00 00 00 
  804318:	ff d0                	callq  *%rax
  80431a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80431d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804321:	0f 89 33 01 00 00    	jns    80445a <map_segment+0x1cf>
				return r;
  804327:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80432a:	e9 46 01 00 00       	jmpq   804475 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80432f:	ba 07 00 00 00       	mov    $0x7,%edx
  804334:	be 00 00 40 00       	mov    $0x400000,%esi
  804339:	bf 00 00 00 00       	mov    $0x0,%edi
  80433e:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804345:	00 00 00 
  804348:	ff d0                	callq  *%rax
  80434a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80434d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804351:	79 08                	jns    80435b <map_segment+0xd0>
				return r;
  804353:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804356:	e9 1a 01 00 00       	jmpq   804475 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80435b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80435e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804361:	01 c2                	add    %eax,%edx
  804363:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804366:	89 d6                	mov    %edx,%esi
  804368:	89 c7                	mov    %eax,%edi
  80436a:	48 b8 2c 31 80 00 00 	movabs $0x80312c,%rax
  804371:	00 00 00 
  804374:	ff d0                	callq  *%rax
  804376:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804379:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80437d:	79 08                	jns    804387 <map_segment+0xfc>
				return r;
  80437f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804382:	e9 ee 00 00 00       	jmpq   804475 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804387:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80438e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804391:	48 98                	cltq   
  804393:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804397:	48 29 c2             	sub    %rax,%rdx
  80439a:	48 89 d0             	mov    %rdx,%rax
  80439d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8043a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043a4:	48 63 d0             	movslq %eax,%rdx
  8043a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ab:	48 39 c2             	cmp    %rax,%rdx
  8043ae:	48 0f 47 d0          	cmova  %rax,%rdx
  8043b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8043b5:	be 00 00 40 00       	mov    $0x400000,%esi
  8043ba:	89 c7                	mov    %eax,%edi
  8043bc:	48 b8 e2 2f 80 00 00 	movabs $0x802fe2,%rax
  8043c3:	00 00 00 
  8043c6:	ff d0                	callq  *%rax
  8043c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8043cf:	79 08                	jns    8043d9 <map_segment+0x14e>
				return r;
  8043d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043d4:	e9 9c 00 00 00       	jmpq   804475 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8043d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043dc:	48 63 d0             	movslq %eax,%rdx
  8043df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043e3:	48 01 d0             	add    %rdx,%rax
  8043e6:	48 89 c2             	mov    %rax,%rdx
  8043e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043ec:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8043f0:	48 89 d1             	mov    %rdx,%rcx
  8043f3:	89 c2                	mov    %eax,%edx
  8043f5:	be 00 00 40 00       	mov    $0x400000,%esi
  8043fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ff:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804406:	00 00 00 
  804409:	ff d0                	callq  *%rax
  80440b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80440e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804412:	79 30                	jns    804444 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804414:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804417:	89 c1                	mov    %eax,%ecx
  804419:	48 ba 53 62 80 00 00 	movabs $0x806253,%rdx
  804420:	00 00 00 
  804423:	be 29 01 00 00       	mov    $0x129,%esi
  804428:	48 bf d8 61 80 00 00 	movabs $0x8061d8,%rdi
  80442f:	00 00 00 
  804432:	b8 00 00 00 00       	mov    $0x0,%eax
  804437:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80443e:	00 00 00 
  804441:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804444:	be 00 00 40 00       	mov    $0x400000,%esi
  804449:	bf 00 00 00 00       	mov    $0x0,%edi
  80444e:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804455:	00 00 00 
  804458:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80445a:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804461:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804464:	48 98                	cltq   
  804466:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80446a:	0f 82 78 fe ff ff    	jb     8042e8 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804470:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804475:	c9                   	leaveq 
  804476:	c3                   	retq   

0000000000804477 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804477:	55                   	push   %rbp
  804478:	48 89 e5             	mov    %rsp,%rbp
  80447b:	48 83 ec 30          	sub    $0x30,%rsp
  80447f:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  804482:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804489:	00 
  80448a:	e9 eb 00 00 00       	jmpq   80457a <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  80448f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804493:	48 c1 f8 12          	sar    $0x12,%rax
  804497:	48 89 c2             	mov    %rax,%rdx
  80449a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8044a1:	01 00 00 
  8044a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044a8:	83 e0 01             	and    $0x1,%eax
  8044ab:	48 85 c0             	test   %rax,%rax
  8044ae:	74 21                	je     8044d1 <copy_shared_pages+0x5a>
  8044b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b4:	48 c1 f8 09          	sar    $0x9,%rax
  8044b8:	48 89 c2             	mov    %rax,%rdx
  8044bb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044c2:	01 00 00 
  8044c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044c9:	83 e0 01             	and    $0x1,%eax
  8044cc:	48 85 c0             	test   %rax,%rax
  8044cf:	75 0d                	jne    8044de <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  8044d1:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  8044d8:	00 
  8044d9:	e9 9c 00 00 00       	jmpq   80457a <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  8044de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044e2:	48 05 00 02 00 00    	add    $0x200,%rax
  8044e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  8044ec:	eb 7e                	jmp    80456c <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  8044ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044f5:	01 00 00 
  8044f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804500:	25 01 04 00 00       	and    $0x401,%eax
  804505:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  80450b:	75 5a                	jne    804567 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  80450d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804511:	48 c1 e0 0c          	shl    $0xc,%rax
  804515:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  804519:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804520:	01 00 00 
  804523:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804527:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80452b:	25 07 0e 00 00       	and    $0xe07,%eax
  804530:	89 c6                	mov    %eax,%esi
  804532:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804536:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80453d:	41 89 f0             	mov    %esi,%r8d
  804540:	48 89 c6             	mov    %rax,%rsi
  804543:	bf 00 00 00 00       	mov    $0x0,%edi
  804548:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80454f:	00 00 00 
  804552:	ff d0                	callq  *%rax
  804554:	48 98                	cltq   
  804556:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80455a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80455f:	79 06                	jns    804567 <copy_shared_pages+0xf0>
						return r;
  804561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804565:	eb 28                	jmp    80458f <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  804567:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80456c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804570:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804574:	0f 8c 74 ff ff ff    	jl     8044ee <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80457a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80457e:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  804584:	0f 86 05 ff ff ff    	jbe    80448f <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  80458a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80458f:	c9                   	leaveq 
  804590:	c3                   	retq   

0000000000804591 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  804591:	55                   	push   %rbp
  804592:	48 89 e5             	mov    %rsp,%rbp
  804595:	48 83 ec 20          	sub    $0x20,%rsp
  804599:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80459c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045a3:	48 89 d6             	mov    %rdx,%rsi
  8045a6:	89 c7                	mov    %eax,%edi
  8045a8:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  8045af:	00 00 00 
  8045b2:	ff d0                	callq  *%rax
  8045b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045bb:	79 05                	jns    8045c2 <fd2sockid+0x31>
		return r;
  8045bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c0:	eb 24                	jmp    8045e6 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8045c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c6:	8b 10                	mov    (%rax),%edx
  8045c8:	48 b8 c0 80 80 00 00 	movabs $0x8080c0,%rax
  8045cf:	00 00 00 
  8045d2:	8b 00                	mov    (%rax),%eax
  8045d4:	39 c2                	cmp    %eax,%edx
  8045d6:	74 07                	je     8045df <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8045d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8045dd:	eb 07                	jmp    8045e6 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8045df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e3:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8045e6:	c9                   	leaveq 
  8045e7:	c3                   	retq   

00000000008045e8 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8045e8:	55                   	push   %rbp
  8045e9:	48 89 e5             	mov    %rsp,%rbp
  8045ec:	48 83 ec 20          	sub    $0x20,%rsp
  8045f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8045f3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8045f7:	48 89 c7             	mov    %rax,%rdi
  8045fa:	48 b8 40 2a 80 00 00 	movabs $0x802a40,%rax
  804601:	00 00 00 
  804604:	ff d0                	callq  *%rax
  804606:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804609:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80460d:	78 26                	js     804635 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80460f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804613:	ba 07 04 00 00       	mov    $0x407,%edx
  804618:	48 89 c6             	mov    %rax,%rsi
  80461b:	bf 00 00 00 00       	mov    $0x0,%edi
  804620:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804627:	00 00 00 
  80462a:	ff d0                	callq  *%rax
  80462c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80462f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804633:	79 16                	jns    80464b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804635:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804638:	89 c7                	mov    %eax,%edi
  80463a:	48 b8 f7 4a 80 00 00 	movabs $0x804af7,%rax
  804641:	00 00 00 
  804644:	ff d0                	callq  *%rax
		return r;
  804646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804649:	eb 3a                	jmp    804685 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80464b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80464f:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  804656:	00 00 00 
  804659:	8b 12                	mov    (%rdx),%edx
  80465b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80465d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804661:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80466c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80466f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  804672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804676:	48 89 c7             	mov    %rax,%rdi
  804679:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  804680:	00 00 00 
  804683:	ff d0                	callq  *%rax
}
  804685:	c9                   	leaveq 
  804686:	c3                   	retq   

0000000000804687 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804687:	55                   	push   %rbp
  804688:	48 89 e5             	mov    %rsp,%rbp
  80468b:	48 83 ec 30          	sub    $0x30,%rsp
  80468f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804692:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804696:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80469a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80469d:	89 c7                	mov    %eax,%edi
  80469f:	48 b8 91 45 80 00 00 	movabs $0x804591,%rax
  8046a6:	00 00 00 
  8046a9:	ff d0                	callq  *%rax
  8046ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046b2:	79 05                	jns    8046b9 <accept+0x32>
		return r;
  8046b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b7:	eb 3b                	jmp    8046f4 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8046b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8046bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8046c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046c4:	48 89 ce             	mov    %rcx,%rsi
  8046c7:	89 c7                	mov    %eax,%edi
  8046c9:	48 b8 d4 49 80 00 00 	movabs $0x8049d4,%rax
  8046d0:	00 00 00 
  8046d3:	ff d0                	callq  *%rax
  8046d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046dc:	79 05                	jns    8046e3 <accept+0x5c>
		return r;
  8046de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046e1:	eb 11                	jmp    8046f4 <accept+0x6d>
	return alloc_sockfd(r);
  8046e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046e6:	89 c7                	mov    %eax,%edi
  8046e8:	48 b8 e8 45 80 00 00 	movabs $0x8045e8,%rax
  8046ef:	00 00 00 
  8046f2:	ff d0                	callq  *%rax
}
  8046f4:	c9                   	leaveq 
  8046f5:	c3                   	retq   

00000000008046f6 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8046f6:	55                   	push   %rbp
  8046f7:	48 89 e5             	mov    %rsp,%rbp
  8046fa:	48 83 ec 20          	sub    $0x20,%rsp
  8046fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804701:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804705:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804708:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80470b:	89 c7                	mov    %eax,%edi
  80470d:	48 b8 91 45 80 00 00 	movabs $0x804591,%rax
  804714:	00 00 00 
  804717:	ff d0                	callq  *%rax
  804719:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80471c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804720:	79 05                	jns    804727 <bind+0x31>
		return r;
  804722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804725:	eb 1b                	jmp    804742 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804727:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80472a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80472e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804731:	48 89 ce             	mov    %rcx,%rsi
  804734:	89 c7                	mov    %eax,%edi
  804736:	48 b8 53 4a 80 00 00 	movabs $0x804a53,%rax
  80473d:	00 00 00 
  804740:	ff d0                	callq  *%rax
}
  804742:	c9                   	leaveq 
  804743:	c3                   	retq   

0000000000804744 <shutdown>:

int
shutdown(int s, int how)
{
  804744:	55                   	push   %rbp
  804745:	48 89 e5             	mov    %rsp,%rbp
  804748:	48 83 ec 20          	sub    $0x20,%rsp
  80474c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80474f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804752:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804755:	89 c7                	mov    %eax,%edi
  804757:	48 b8 91 45 80 00 00 	movabs $0x804591,%rax
  80475e:	00 00 00 
  804761:	ff d0                	callq  *%rax
  804763:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804766:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80476a:	79 05                	jns    804771 <shutdown+0x2d>
		return r;
  80476c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80476f:	eb 16                	jmp    804787 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  804771:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804777:	89 d6                	mov    %edx,%esi
  804779:	89 c7                	mov    %eax,%edi
  80477b:	48 b8 b7 4a 80 00 00 	movabs $0x804ab7,%rax
  804782:	00 00 00 
  804785:	ff d0                	callq  *%rax
}
  804787:	c9                   	leaveq 
  804788:	c3                   	retq   

0000000000804789 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804789:	55                   	push   %rbp
  80478a:	48 89 e5             	mov    %rsp,%rbp
  80478d:	48 83 ec 10          	sub    $0x10,%rsp
  804791:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804799:	48 89 c7             	mov    %rax,%rdi
  80479c:	48 b8 57 58 80 00 00 	movabs $0x805857,%rax
  8047a3:	00 00 00 
  8047a6:	ff d0                	callq  *%rax
  8047a8:	83 f8 01             	cmp    $0x1,%eax
  8047ab:	75 17                	jne    8047c4 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8047ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047b1:	8b 40 0c             	mov    0xc(%rax),%eax
  8047b4:	89 c7                	mov    %eax,%edi
  8047b6:	48 b8 f7 4a 80 00 00 	movabs $0x804af7,%rax
  8047bd:	00 00 00 
  8047c0:	ff d0                	callq  *%rax
  8047c2:	eb 05                	jmp    8047c9 <devsock_close+0x40>
	else
		return 0;
  8047c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047c9:	c9                   	leaveq 
  8047ca:	c3                   	retq   

00000000008047cb <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8047cb:	55                   	push   %rbp
  8047cc:	48 89 e5             	mov    %rsp,%rbp
  8047cf:	48 83 ec 20          	sub    $0x20,%rsp
  8047d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047da:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8047dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047e0:	89 c7                	mov    %eax,%edi
  8047e2:	48 b8 91 45 80 00 00 	movabs $0x804591,%rax
  8047e9:	00 00 00 
  8047ec:	ff d0                	callq  *%rax
  8047ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047f5:	79 05                	jns    8047fc <connect+0x31>
		return r;
  8047f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047fa:	eb 1b                	jmp    804817 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8047fc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8047ff:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804803:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804806:	48 89 ce             	mov    %rcx,%rsi
  804809:	89 c7                	mov    %eax,%edi
  80480b:	48 b8 24 4b 80 00 00 	movabs $0x804b24,%rax
  804812:	00 00 00 
  804815:	ff d0                	callq  *%rax
}
  804817:	c9                   	leaveq 
  804818:	c3                   	retq   

0000000000804819 <listen>:

int
listen(int s, int backlog)
{
  804819:	55                   	push   %rbp
  80481a:	48 89 e5             	mov    %rsp,%rbp
  80481d:	48 83 ec 20          	sub    $0x20,%rsp
  804821:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804824:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804827:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80482a:	89 c7                	mov    %eax,%edi
  80482c:	48 b8 91 45 80 00 00 	movabs $0x804591,%rax
  804833:	00 00 00 
  804836:	ff d0                	callq  *%rax
  804838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80483b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80483f:	79 05                	jns    804846 <listen+0x2d>
		return r;
  804841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804844:	eb 16                	jmp    80485c <listen+0x43>
	return nsipc_listen(r, backlog);
  804846:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484c:	89 d6                	mov    %edx,%esi
  80484e:	89 c7                	mov    %eax,%edi
  804850:	48 b8 88 4b 80 00 00 	movabs $0x804b88,%rax
  804857:	00 00 00 
  80485a:	ff d0                	callq  *%rax
}
  80485c:	c9                   	leaveq 
  80485d:	c3                   	retq   

000000000080485e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80485e:	55                   	push   %rbp
  80485f:	48 89 e5             	mov    %rsp,%rbp
  804862:	48 83 ec 20          	sub    $0x20,%rsp
  804866:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80486a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80486e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804876:	89 c2                	mov    %eax,%edx
  804878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80487c:	8b 40 0c             	mov    0xc(%rax),%eax
  80487f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804883:	b9 00 00 00 00       	mov    $0x0,%ecx
  804888:	89 c7                	mov    %eax,%edi
  80488a:	48 b8 c8 4b 80 00 00 	movabs $0x804bc8,%rax
  804891:	00 00 00 
  804894:	ff d0                	callq  *%rax
}
  804896:	c9                   	leaveq 
  804897:	c3                   	retq   

0000000000804898 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804898:	55                   	push   %rbp
  804899:	48 89 e5             	mov    %rsp,%rbp
  80489c:	48 83 ec 20          	sub    $0x20,%rsp
  8048a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8048a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8048a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8048ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b0:	89 c2                	mov    %eax,%edx
  8048b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048b6:	8b 40 0c             	mov    0xc(%rax),%eax
  8048b9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8048bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048c2:	89 c7                	mov    %eax,%edi
  8048c4:	48 b8 94 4c 80 00 00 	movabs $0x804c94,%rax
  8048cb:	00 00 00 
  8048ce:	ff d0                	callq  *%rax
}
  8048d0:	c9                   	leaveq 
  8048d1:	c3                   	retq   

00000000008048d2 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8048d2:	55                   	push   %rbp
  8048d3:	48 89 e5             	mov    %rsp,%rbp
  8048d6:	48 83 ec 10          	sub    $0x10,%rsp
  8048da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8048de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8048e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048e6:	48 be 75 62 80 00 00 	movabs $0x806275,%rsi
  8048ed:	00 00 00 
  8048f0:	48 89 c7             	mov    %rax,%rdi
  8048f3:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  8048fa:	00 00 00 
  8048fd:	ff d0                	callq  *%rax
	return 0;
  8048ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804904:	c9                   	leaveq 
  804905:	c3                   	retq   

0000000000804906 <socket>:

int
socket(int domain, int type, int protocol)
{
  804906:	55                   	push   %rbp
  804907:	48 89 e5             	mov    %rsp,%rbp
  80490a:	48 83 ec 20          	sub    $0x20,%rsp
  80490e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804911:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804914:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804917:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80491a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80491d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804920:	89 ce                	mov    %ecx,%esi
  804922:	89 c7                	mov    %eax,%edi
  804924:	48 b8 4c 4d 80 00 00 	movabs $0x804d4c,%rax
  80492b:	00 00 00 
  80492e:	ff d0                	callq  *%rax
  804930:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804937:	79 05                	jns    80493e <socket+0x38>
		return r;
  804939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80493c:	eb 11                	jmp    80494f <socket+0x49>
	return alloc_sockfd(r);
  80493e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804941:	89 c7                	mov    %eax,%edi
  804943:	48 b8 e8 45 80 00 00 	movabs $0x8045e8,%rax
  80494a:	00 00 00 
  80494d:	ff d0                	callq  *%rax
}
  80494f:	c9                   	leaveq 
  804950:	c3                   	retq   

0000000000804951 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804951:	55                   	push   %rbp
  804952:	48 89 e5             	mov    %rsp,%rbp
  804955:	48 83 ec 10          	sub    $0x10,%rsp
  804959:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80495c:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804963:	00 00 00 
  804966:	8b 00                	mov    (%rax),%eax
  804968:	85 c0                	test   %eax,%eax
  80496a:	75 1f                	jne    80498b <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80496c:	bf 02 00 00 00       	mov    $0x2,%edi
  804971:	48 b8 e6 57 80 00 00 	movabs $0x8057e6,%rax
  804978:	00 00 00 
  80497b:	ff d0                	callq  *%rax
  80497d:	89 c2                	mov    %eax,%edx
  80497f:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804986:	00 00 00 
  804989:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80498b:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804992:	00 00 00 
  804995:	8b 00                	mov    (%rax),%eax
  804997:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80499a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80499f:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  8049a6:	00 00 00 
  8049a9:	89 c7                	mov    %eax,%edi
  8049ab:	48 b8 da 55 80 00 00 	movabs $0x8055da,%rax
  8049b2:	00 00 00 
  8049b5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8049b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8049bc:	be 00 00 00 00       	mov    $0x0,%esi
  8049c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8049c6:	48 b8 19 55 80 00 00 	movabs $0x805519,%rax
  8049cd:	00 00 00 
  8049d0:	ff d0                	callq  *%rax
}
  8049d2:	c9                   	leaveq 
  8049d3:	c3                   	retq   

00000000008049d4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8049d4:	55                   	push   %rbp
  8049d5:	48 89 e5             	mov    %rsp,%rbp
  8049d8:	48 83 ec 30          	sub    $0x30,%rsp
  8049dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8049df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8049e7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049ee:	00 00 00 
  8049f1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8049f4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8049f6:	bf 01 00 00 00       	mov    $0x1,%edi
  8049fb:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804a02:	00 00 00 
  804a05:	ff d0                	callq  *%rax
  804a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a0e:	78 3e                	js     804a4e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804a10:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a17:	00 00 00 
  804a1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a22:	8b 40 10             	mov    0x10(%rax),%eax
  804a25:	89 c2                	mov    %eax,%edx
  804a27:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a2f:	48 89 ce             	mov    %rcx,%rsi
  804a32:	48 89 c7             	mov    %rax,%rdi
  804a35:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804a3c:	00 00 00 
  804a3f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a45:	8b 50 10             	mov    0x10(%rax),%edx
  804a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a4c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a51:	c9                   	leaveq 
  804a52:	c3                   	retq   

0000000000804a53 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804a53:	55                   	push   %rbp
  804a54:	48 89 e5             	mov    %rsp,%rbp
  804a57:	48 83 ec 10          	sub    $0x10,%rsp
  804a5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a62:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804a65:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a6c:	00 00 00 
  804a6f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a72:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804a74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a7b:	48 89 c6             	mov    %rax,%rsi
  804a7e:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804a85:	00 00 00 
  804a88:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804a8f:	00 00 00 
  804a92:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804a94:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a9b:	00 00 00 
  804a9e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804aa1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804aa4:	bf 02 00 00 00       	mov    $0x2,%edi
  804aa9:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804ab0:	00 00 00 
  804ab3:	ff d0                	callq  *%rax
}
  804ab5:	c9                   	leaveq 
  804ab6:	c3                   	retq   

0000000000804ab7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804ab7:	55                   	push   %rbp
  804ab8:	48 89 e5             	mov    %rsp,%rbp
  804abb:	48 83 ec 10          	sub    $0x10,%rsp
  804abf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ac2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804ac5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804acc:	00 00 00 
  804acf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804ad2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804ad4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804adb:	00 00 00 
  804ade:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804ae1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804ae4:	bf 03 00 00 00       	mov    $0x3,%edi
  804ae9:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804af0:	00 00 00 
  804af3:	ff d0                	callq  *%rax
}
  804af5:	c9                   	leaveq 
  804af6:	c3                   	retq   

0000000000804af7 <nsipc_close>:

int
nsipc_close(int s)
{
  804af7:	55                   	push   %rbp
  804af8:	48 89 e5             	mov    %rsp,%rbp
  804afb:	48 83 ec 10          	sub    $0x10,%rsp
  804aff:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804b02:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b09:	00 00 00 
  804b0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b0f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804b11:	bf 04 00 00 00       	mov    $0x4,%edi
  804b16:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804b1d:	00 00 00 
  804b20:	ff d0                	callq  *%rax
}
  804b22:	c9                   	leaveq 
  804b23:	c3                   	retq   

0000000000804b24 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804b24:	55                   	push   %rbp
  804b25:	48 89 e5             	mov    %rsp,%rbp
  804b28:	48 83 ec 10          	sub    $0x10,%rsp
  804b2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b33:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804b36:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b3d:	00 00 00 
  804b40:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b43:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804b45:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b4c:	48 89 c6             	mov    %rax,%rsi
  804b4f:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804b56:	00 00 00 
  804b59:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804b60:	00 00 00 
  804b63:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804b65:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b6c:	00 00 00 
  804b6f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b72:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804b75:	bf 05 00 00 00       	mov    $0x5,%edi
  804b7a:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804b81:	00 00 00 
  804b84:	ff d0                	callq  *%rax
}
  804b86:	c9                   	leaveq 
  804b87:	c3                   	retq   

0000000000804b88 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804b88:	55                   	push   %rbp
  804b89:	48 89 e5             	mov    %rsp,%rbp
  804b8c:	48 83 ec 10          	sub    $0x10,%rsp
  804b90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b93:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804b96:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b9d:	00 00 00 
  804ba0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804ba3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804ba5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bac:	00 00 00 
  804baf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804bb2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804bb5:	bf 06 00 00 00       	mov    $0x6,%edi
  804bba:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804bc1:	00 00 00 
  804bc4:	ff d0                	callq  *%rax
}
  804bc6:	c9                   	leaveq 
  804bc7:	c3                   	retq   

0000000000804bc8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804bc8:	55                   	push   %rbp
  804bc9:	48 89 e5             	mov    %rsp,%rbp
  804bcc:	48 83 ec 30          	sub    $0x30,%rsp
  804bd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804bd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804bd7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804bda:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804bdd:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804be4:	00 00 00 
  804be7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804bea:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804bec:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bf3:	00 00 00 
  804bf6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804bf9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804bfc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c03:	00 00 00 
  804c06:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804c09:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804c0c:	bf 07 00 00 00       	mov    $0x7,%edi
  804c11:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804c18:	00 00 00 
  804c1b:	ff d0                	callq  *%rax
  804c1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c24:	78 69                	js     804c8f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804c26:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804c2d:	7f 08                	jg     804c37 <nsipc_recv+0x6f>
  804c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c32:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804c35:	7e 35                	jle    804c6c <nsipc_recv+0xa4>
  804c37:	48 b9 7c 62 80 00 00 	movabs $0x80627c,%rcx
  804c3e:	00 00 00 
  804c41:	48 ba 91 62 80 00 00 	movabs $0x806291,%rdx
  804c48:	00 00 00 
  804c4b:	be 62 00 00 00       	mov    $0x62,%esi
  804c50:	48 bf a6 62 80 00 00 	movabs $0x8062a6,%rdi
  804c57:	00 00 00 
  804c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  804c5f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  804c66:	00 00 00 
  804c69:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c6f:	48 63 d0             	movslq %eax,%rdx
  804c72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c76:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804c7d:	00 00 00 
  804c80:	48 89 c7             	mov    %rax,%rdi
  804c83:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804c8a:	00 00 00 
  804c8d:	ff d0                	callq  *%rax
	}

	return r;
  804c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804c92:	c9                   	leaveq 
  804c93:	c3                   	retq   

0000000000804c94 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804c94:	55                   	push   %rbp
  804c95:	48 89 e5             	mov    %rsp,%rbp
  804c98:	48 83 ec 20          	sub    $0x20,%rsp
  804c9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ca3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804ca6:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804ca9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cb0:	00 00 00 
  804cb3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804cb6:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804cb8:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804cbf:	7e 35                	jle    804cf6 <nsipc_send+0x62>
  804cc1:	48 b9 b2 62 80 00 00 	movabs $0x8062b2,%rcx
  804cc8:	00 00 00 
  804ccb:	48 ba 91 62 80 00 00 	movabs $0x806291,%rdx
  804cd2:	00 00 00 
  804cd5:	be 6d 00 00 00       	mov    $0x6d,%esi
  804cda:	48 bf a6 62 80 00 00 	movabs $0x8062a6,%rdi
  804ce1:	00 00 00 
  804ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  804ce9:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  804cf0:	00 00 00 
  804cf3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804cf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cf9:	48 63 d0             	movslq %eax,%rdx
  804cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d00:	48 89 c6             	mov    %rax,%rsi
  804d03:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804d0a:	00 00 00 
  804d0d:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804d14:	00 00 00 
  804d17:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804d19:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d20:	00 00 00 
  804d23:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804d26:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804d29:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d30:	00 00 00 
  804d33:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804d36:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804d39:	bf 08 00 00 00       	mov    $0x8,%edi
  804d3e:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804d45:	00 00 00 
  804d48:	ff d0                	callq  *%rax
}
  804d4a:	c9                   	leaveq 
  804d4b:	c3                   	retq   

0000000000804d4c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804d4c:	55                   	push   %rbp
  804d4d:	48 89 e5             	mov    %rsp,%rbp
  804d50:	48 83 ec 10          	sub    $0x10,%rsp
  804d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d57:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804d5a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804d5d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d64:	00 00 00 
  804d67:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804d6a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804d6c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d73:	00 00 00 
  804d76:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804d79:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804d7c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d83:	00 00 00 
  804d86:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804d89:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804d8c:	bf 09 00 00 00       	mov    $0x9,%edi
  804d91:	48 b8 51 49 80 00 00 	movabs $0x804951,%rax
  804d98:	00 00 00 
  804d9b:	ff d0                	callq  *%rax
}
  804d9d:	c9                   	leaveq 
  804d9e:	c3                   	retq   

0000000000804d9f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804d9f:	55                   	push   %rbp
  804da0:	48 89 e5             	mov    %rsp,%rbp
  804da3:	53                   	push   %rbx
  804da4:	48 83 ec 38          	sub    $0x38,%rsp
  804da8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804dac:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804db0:	48 89 c7             	mov    %rax,%rdi
  804db3:	48 b8 40 2a 80 00 00 	movabs $0x802a40,%rax
  804dba:	00 00 00 
  804dbd:	ff d0                	callq  *%rax
  804dbf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804dc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804dc6:	0f 88 bf 01 00 00    	js     804f8b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804dcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dd0:	ba 07 04 00 00       	mov    $0x407,%edx
  804dd5:	48 89 c6             	mov    %rax,%rsi
  804dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  804ddd:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804de4:	00 00 00 
  804de7:	ff d0                	callq  *%rax
  804de9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804dec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804df0:	0f 88 95 01 00 00    	js     804f8b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804df6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804dfa:	48 89 c7             	mov    %rax,%rdi
  804dfd:	48 b8 40 2a 80 00 00 	movabs $0x802a40,%rax
  804e04:	00 00 00 
  804e07:	ff d0                	callq  *%rax
  804e09:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e10:	0f 88 5d 01 00 00    	js     804f73 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e1a:	ba 07 04 00 00       	mov    $0x407,%edx
  804e1f:	48 89 c6             	mov    %rax,%rsi
  804e22:	bf 00 00 00 00       	mov    $0x0,%edi
  804e27:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804e2e:	00 00 00 
  804e31:	ff d0                	callq  *%rax
  804e33:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e36:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e3a:	0f 88 33 01 00 00    	js     804f73 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e44:	48 89 c7             	mov    %rax,%rdi
  804e47:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  804e4e:	00 00 00 
  804e51:	ff d0                	callq  *%rax
  804e53:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e5b:	ba 07 04 00 00       	mov    $0x407,%edx
  804e60:	48 89 c6             	mov    %rax,%rsi
  804e63:	bf 00 00 00 00       	mov    $0x0,%edi
  804e68:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804e6f:	00 00 00 
  804e72:	ff d0                	callq  *%rax
  804e74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e7b:	0f 88 d9 00 00 00    	js     804f5a <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e85:	48 89 c7             	mov    %rax,%rdi
  804e88:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  804e8f:	00 00 00 
  804e92:	ff d0                	callq  *%rax
  804e94:	48 89 c2             	mov    %rax,%rdx
  804e97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e9b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804ea1:	48 89 d1             	mov    %rdx,%rcx
  804ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  804ea9:	48 89 c6             	mov    %rax,%rsi
  804eac:	bf 00 00 00 00       	mov    $0x0,%edi
  804eb1:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804eb8:	00 00 00 
  804ebb:	ff d0                	callq  *%rax
  804ebd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ec0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ec4:	78 79                	js     804f3f <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804eca:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804ed1:	00 00 00 
  804ed4:	8b 12                	mov    (%rdx),%edx
  804ed6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804ed8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804edc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804ee3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ee7:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804eee:	00 00 00 
  804ef1:	8b 12                	mov    (%rdx),%edx
  804ef3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804ef5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ef9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804f00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f04:	48 89 c7             	mov    %rax,%rdi
  804f07:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  804f0e:	00 00 00 
  804f11:	ff d0                	callq  *%rax
  804f13:	89 c2                	mov    %eax,%edx
  804f15:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f19:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804f1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f1f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804f23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f27:	48 89 c7             	mov    %rax,%rdi
  804f2a:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  804f31:	00 00 00 
  804f34:	ff d0                	callq  *%rax
  804f36:	89 03                	mov    %eax,(%rbx)
	return 0;
  804f38:	b8 00 00 00 00       	mov    $0x0,%eax
  804f3d:	eb 4f                	jmp    804f8e <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804f3f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804f40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804f44:	48 89 c6             	mov    %rax,%rsi
  804f47:	bf 00 00 00 00       	mov    $0x0,%edi
  804f4c:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804f53:	00 00 00 
  804f56:	ff d0                	callq  *%rax
  804f58:	eb 01                	jmp    804f5b <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804f5a:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804f5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f5f:	48 89 c6             	mov    %rax,%rsi
  804f62:	bf 00 00 00 00       	mov    $0x0,%edi
  804f67:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804f6e:	00 00 00 
  804f71:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804f73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f77:	48 89 c6             	mov    %rax,%rsi
  804f7a:	bf 00 00 00 00       	mov    $0x0,%edi
  804f7f:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804f86:	00 00 00 
  804f89:	ff d0                	callq  *%rax
err:
	return r;
  804f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804f8e:	48 83 c4 38          	add    $0x38,%rsp
  804f92:	5b                   	pop    %rbx
  804f93:	5d                   	pop    %rbp
  804f94:	c3                   	retq   

0000000000804f95 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804f95:	55                   	push   %rbp
  804f96:	48 89 e5             	mov    %rsp,%rbp
  804f99:	53                   	push   %rbx
  804f9a:	48 83 ec 28          	sub    $0x28,%rsp
  804f9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804fa2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804fa6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804fad:	00 00 00 
  804fb0:	48 8b 00             	mov    (%rax),%rax
  804fb3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804fb9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fc0:	48 89 c7             	mov    %rax,%rdi
  804fc3:	48 b8 57 58 80 00 00 	movabs $0x805857,%rax
  804fca:	00 00 00 
  804fcd:	ff d0                	callq  *%rax
  804fcf:	89 c3                	mov    %eax,%ebx
  804fd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fd5:	48 89 c7             	mov    %rax,%rdi
  804fd8:	48 b8 57 58 80 00 00 	movabs $0x805857,%rax
  804fdf:	00 00 00 
  804fe2:	ff d0                	callq  *%rax
  804fe4:	39 c3                	cmp    %eax,%ebx
  804fe6:	0f 94 c0             	sete   %al
  804fe9:	0f b6 c0             	movzbl %al,%eax
  804fec:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804fef:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804ff6:	00 00 00 
  804ff9:	48 8b 00             	mov    (%rax),%rax
  804ffc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805002:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805005:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805008:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80500b:	75 05                	jne    805012 <_pipeisclosed+0x7d>
			return ret;
  80500d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805010:	eb 4a                	jmp    80505c <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  805012:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805015:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805018:	74 8c                	je     804fa6 <_pipeisclosed+0x11>
  80501a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80501e:	75 86                	jne    804fa6 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805020:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  805027:	00 00 00 
  80502a:	48 8b 00             	mov    (%rax),%rax
  80502d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805033:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805036:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805039:	89 c6                	mov    %eax,%esi
  80503b:	48 bf c3 62 80 00 00 	movabs $0x8062c3,%rdi
  805042:	00 00 00 
  805045:	b8 00 00 00 00       	mov    $0x0,%eax
  80504a:	49 b8 18 0b 80 00 00 	movabs $0x800b18,%r8
  805051:	00 00 00 
  805054:	41 ff d0             	callq  *%r8
	}
  805057:	e9 4a ff ff ff       	jmpq   804fa6 <_pipeisclosed+0x11>

}
  80505c:	48 83 c4 28          	add    $0x28,%rsp
  805060:	5b                   	pop    %rbx
  805061:	5d                   	pop    %rbp
  805062:	c3                   	retq   

0000000000805063 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805063:	55                   	push   %rbp
  805064:	48 89 e5             	mov    %rsp,%rbp
  805067:	48 83 ec 30          	sub    $0x30,%rsp
  80506b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80506e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805072:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805075:	48 89 d6             	mov    %rdx,%rsi
  805078:	89 c7                	mov    %eax,%edi
  80507a:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  805081:	00 00 00 
  805084:	ff d0                	callq  *%rax
  805086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80508d:	79 05                	jns    805094 <pipeisclosed+0x31>
		return r;
  80508f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805092:	eb 31                	jmp    8050c5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805098:	48 89 c7             	mov    %rax,%rdi
  80509b:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  8050a2:	00 00 00 
  8050a5:	ff d0                	callq  *%rax
  8050a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8050ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050b3:	48 89 d6             	mov    %rdx,%rsi
  8050b6:	48 89 c7             	mov    %rax,%rdi
  8050b9:	48 b8 95 4f 80 00 00 	movabs $0x804f95,%rax
  8050c0:	00 00 00 
  8050c3:	ff d0                	callq  *%rax
}
  8050c5:	c9                   	leaveq 
  8050c6:	c3                   	retq   

00000000008050c7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8050c7:	55                   	push   %rbp
  8050c8:	48 89 e5             	mov    %rsp,%rbp
  8050cb:	48 83 ec 40          	sub    $0x40,%rsp
  8050cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8050d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8050d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8050db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050df:	48 89 c7             	mov    %rax,%rdi
  8050e2:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  8050e9:	00 00 00 
  8050ec:	ff d0                	callq  *%rax
  8050ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8050f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8050f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8050fa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805101:	00 
  805102:	e9 90 00 00 00       	jmpq   805197 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  805107:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80510c:	74 09                	je     805117 <devpipe_read+0x50>
				return i;
  80510e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805112:	e9 8e 00 00 00       	jmpq   8051a5 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805117:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80511b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80511f:	48 89 d6             	mov    %rdx,%rsi
  805122:	48 89 c7             	mov    %rax,%rdi
  805125:	48 b8 95 4f 80 00 00 	movabs $0x804f95,%rax
  80512c:	00 00 00 
  80512f:	ff d0                	callq  *%rax
  805131:	85 c0                	test   %eax,%eax
  805133:	74 07                	je     80513c <devpipe_read+0x75>
				return 0;
  805135:	b8 00 00 00 00       	mov    $0x0,%eax
  80513a:	eb 69                	jmp    8051a5 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80513c:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  805143:	00 00 00 
  805146:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805148:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80514c:	8b 10                	mov    (%rax),%edx
  80514e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805152:	8b 40 04             	mov    0x4(%rax),%eax
  805155:	39 c2                	cmp    %eax,%edx
  805157:	74 ae                	je     805107 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805159:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80515d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805161:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805169:	8b 00                	mov    (%rax),%eax
  80516b:	99                   	cltd   
  80516c:	c1 ea 1b             	shr    $0x1b,%edx
  80516f:	01 d0                	add    %edx,%eax
  805171:	83 e0 1f             	and    $0x1f,%eax
  805174:	29 d0                	sub    %edx,%eax
  805176:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80517a:	48 98                	cltq   
  80517c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805181:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805187:	8b 00                	mov    (%rax),%eax
  805189:	8d 50 01             	lea    0x1(%rax),%edx
  80518c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805190:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805192:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80519b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80519f:	72 a7                	jb     805148 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8051a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8051a5:	c9                   	leaveq 
  8051a6:	c3                   	retq   

00000000008051a7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8051a7:	55                   	push   %rbp
  8051a8:	48 89 e5             	mov    %rsp,%rbp
  8051ab:	48 83 ec 40          	sub    $0x40,%rsp
  8051af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8051b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8051b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8051bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051bf:	48 89 c7             	mov    %rax,%rdi
  8051c2:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  8051c9:	00 00 00 
  8051cc:	ff d0                	callq  *%rax
  8051ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8051d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8051da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051e1:	00 
  8051e2:	e9 8f 00 00 00       	jmpq   805276 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8051e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8051eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051ef:	48 89 d6             	mov    %rdx,%rsi
  8051f2:	48 89 c7             	mov    %rax,%rdi
  8051f5:	48 b8 95 4f 80 00 00 	movabs $0x804f95,%rax
  8051fc:	00 00 00 
  8051ff:	ff d0                	callq  *%rax
  805201:	85 c0                	test   %eax,%eax
  805203:	74 07                	je     80520c <devpipe_write+0x65>
				return 0;
  805205:	b8 00 00 00 00       	mov    $0x0,%eax
  80520a:	eb 78                	jmp    805284 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80520c:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  805213:	00 00 00 
  805216:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80521c:	8b 40 04             	mov    0x4(%rax),%eax
  80521f:	48 63 d0             	movslq %eax,%rdx
  805222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805226:	8b 00                	mov    (%rax),%eax
  805228:	48 98                	cltq   
  80522a:	48 83 c0 20          	add    $0x20,%rax
  80522e:	48 39 c2             	cmp    %rax,%rdx
  805231:	73 b4                	jae    8051e7 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805237:	8b 40 04             	mov    0x4(%rax),%eax
  80523a:	99                   	cltd   
  80523b:	c1 ea 1b             	shr    $0x1b,%edx
  80523e:	01 d0                	add    %edx,%eax
  805240:	83 e0 1f             	and    $0x1f,%eax
  805243:	29 d0                	sub    %edx,%eax
  805245:	89 c6                	mov    %eax,%esi
  805247:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80524b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80524f:	48 01 d0             	add    %rdx,%rax
  805252:	0f b6 08             	movzbl (%rax),%ecx
  805255:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805259:	48 63 c6             	movslq %esi,%rax
  80525c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805264:	8b 40 04             	mov    0x4(%rax),%eax
  805267:	8d 50 01             	lea    0x1(%rax),%edx
  80526a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80526e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805271:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80527a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80527e:	72 98                	jb     805218 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  805284:	c9                   	leaveq 
  805285:	c3                   	retq   

0000000000805286 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805286:	55                   	push   %rbp
  805287:	48 89 e5             	mov    %rsp,%rbp
  80528a:	48 83 ec 20          	sub    $0x20,%rsp
  80528e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805292:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80529a:	48 89 c7             	mov    %rax,%rdi
  80529d:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  8052a4:	00 00 00 
  8052a7:	ff d0                	callq  *%rax
  8052a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8052ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052b1:	48 be d6 62 80 00 00 	movabs $0x8062d6,%rsi
  8052b8:	00 00 00 
  8052bb:	48 89 c7             	mov    %rax,%rdi
  8052be:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  8052c5:	00 00 00 
  8052c8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8052ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052ce:	8b 50 04             	mov    0x4(%rax),%edx
  8052d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052d5:	8b 00                	mov    (%rax),%eax
  8052d7:	29 c2                	sub    %eax,%edx
  8052d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052dd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8052e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052e7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8052ee:	00 00 00 
	stat->st_dev = &devpipe;
  8052f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052f5:	48 b9 00 81 80 00 00 	movabs $0x808100,%rcx
  8052fc:	00 00 00 
  8052ff:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80530b:	c9                   	leaveq 
  80530c:	c3                   	retq   

000000000080530d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80530d:	55                   	push   %rbp
  80530e:	48 89 e5             	mov    %rsp,%rbp
  805311:	48 83 ec 10          	sub    $0x10,%rsp
  805315:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  805319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80531d:	48 89 c6             	mov    %rax,%rsi
  805320:	bf 00 00 00 00       	mov    $0x0,%edi
  805325:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80532c:	00 00 00 
  80532f:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  805331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805335:	48 89 c7             	mov    %rax,%rdi
  805338:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  80533f:	00 00 00 
  805342:	ff d0                	callq  *%rax
  805344:	48 89 c6             	mov    %rax,%rsi
  805347:	bf 00 00 00 00       	mov    $0x0,%edi
  80534c:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  805353:	00 00 00 
  805356:	ff d0                	callq  *%rax
}
  805358:	c9                   	leaveq 
  805359:	c3                   	retq   

000000000080535a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80535a:	55                   	push   %rbp
  80535b:	48 89 e5             	mov    %rsp,%rbp
  80535e:	48 83 ec 20          	sub    $0x20,%rsp
  805362:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805365:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805369:	75 35                	jne    8053a0 <wait+0x46>
  80536b:	48 b9 dd 62 80 00 00 	movabs $0x8062dd,%rcx
  805372:	00 00 00 
  805375:	48 ba e8 62 80 00 00 	movabs $0x8062e8,%rdx
  80537c:	00 00 00 
  80537f:	be 0a 00 00 00       	mov    $0xa,%esi
  805384:	48 bf fd 62 80 00 00 	movabs $0x8062fd,%rdi
  80538b:	00 00 00 
  80538e:	b8 00 00 00 00       	mov    $0x0,%eax
  805393:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80539a:	00 00 00 
  80539d:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8053a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8053a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8053a8:	48 98                	cltq   
  8053aa:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8053b1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8053b8:	00 00 00 
  8053bb:	48 01 d0             	add    %rdx,%rax
  8053be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8053c2:	eb 0c                	jmp    8053d0 <wait+0x76>
		sys_yield();
  8053c4:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  8053cb:	00 00 00 
  8053ce:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8053d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8053d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8053da:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8053dd:	75 0e                	jne    8053ed <wait+0x93>
  8053df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8053e3:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8053e9:	85 c0                	test   %eax,%eax
  8053eb:	75 d7                	jne    8053c4 <wait+0x6a>
		sys_yield();
}
  8053ed:	90                   	nop
  8053ee:	c9                   	leaveq 
  8053ef:	c3                   	retq   

00000000008053f0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8053f0:	55                   	push   %rbp
  8053f1:	48 89 e5             	mov    %rsp,%rbp
  8053f4:	48 83 ec 20          	sub    $0x20,%rsp
  8053f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8053fc:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805403:	00 00 00 
  805406:	48 8b 00             	mov    (%rax),%rax
  805409:	48 85 c0             	test   %rax,%rax
  80540c:	75 6f                	jne    80547d <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80540e:	ba 07 00 00 00       	mov    $0x7,%edx
  805413:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805418:	bf 00 00 00 00       	mov    $0x0,%edi
  80541d:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  805424:	00 00 00 
  805427:	ff d0                	callq  *%rax
  805429:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80542c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805430:	79 30                	jns    805462 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805435:	89 c1                	mov    %eax,%ecx
  805437:	48 ba 08 63 80 00 00 	movabs $0x806308,%rdx
  80543e:	00 00 00 
  805441:	be 22 00 00 00       	mov    $0x22,%esi
  805446:	48 bf 27 63 80 00 00 	movabs $0x806327,%rdi
  80544d:	00 00 00 
  805450:	b8 00 00 00 00       	mov    $0x0,%eax
  805455:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80545c:	00 00 00 
  80545f:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  805462:	48 be 91 54 80 00 00 	movabs $0x805491,%rsi
  805469:	00 00 00 
  80546c:	bf 00 00 00 00       	mov    $0x0,%edi
  805471:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  805478:	00 00 00 
  80547b:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80547d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805484:	00 00 00 
  805487:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80548b:	48 89 10             	mov    %rdx,(%rax)
}
  80548e:	90                   	nop
  80548f:	c9                   	leaveq 
  805490:	c3                   	retq   

0000000000805491 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805491:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805494:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  80549b:	00 00 00 
call *%rax
  80549e:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8054a0:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8054a7:	00 08 
    movq 152(%rsp), %rax
  8054a9:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8054b0:	00 
    movq 136(%rsp), %rbx
  8054b1:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8054b8:	00 
movq %rbx, (%rax)
  8054b9:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8054bc:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8054c0:	4c 8b 3c 24          	mov    (%rsp),%r15
  8054c4:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8054c9:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8054ce:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8054d3:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8054d8:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8054dd:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8054e2:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8054e7:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8054ec:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8054f1:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8054f6:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8054fb:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805500:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805505:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80550a:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80550e:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805512:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805513:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  805518:	c3                   	retq   

0000000000805519 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805519:	55                   	push   %rbp
  80551a:	48 89 e5             	mov    %rsp,%rbp
  80551d:	48 83 ec 30          	sub    $0x30,%rsp
  805521:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805525:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805529:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80552d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805532:	75 0e                	jne    805542 <ipc_recv+0x29>
		pg = (void*) UTOP;
  805534:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80553b:	00 00 00 
  80553e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  805542:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805546:	48 89 c7             	mov    %rax,%rdi
  805549:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  805550:	00 00 00 
  805553:	ff d0                	callq  *%rax
  805555:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805558:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80555c:	79 27                	jns    805585 <ipc_recv+0x6c>
		if (from_env_store)
  80555e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805563:	74 0a                	je     80556f <ipc_recv+0x56>
			*from_env_store = 0;
  805565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805569:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80556f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805574:	74 0a                	je     805580 <ipc_recv+0x67>
			*perm_store = 0;
  805576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80557a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  805580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805583:	eb 53                	jmp    8055d8 <ipc_recv+0xbf>
	}
	if (from_env_store)
  805585:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80558a:	74 19                	je     8055a5 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80558c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  805593:	00 00 00 
  805596:	48 8b 00             	mov    (%rax),%rax
  805599:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80559f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055a3:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8055a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8055aa:	74 19                	je     8055c5 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8055ac:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055b3:	00 00 00 
  8055b6:	48 8b 00             	mov    (%rax),%rax
  8055b9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8055bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055c3:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8055c5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055cc:	00 00 00 
  8055cf:	48 8b 00             	mov    (%rax),%rax
  8055d2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8055d8:	c9                   	leaveq 
  8055d9:	c3                   	retq   

00000000008055da <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8055da:	55                   	push   %rbp
  8055db:	48 89 e5             	mov    %rsp,%rbp
  8055de:	48 83 ec 30          	sub    $0x30,%rsp
  8055e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055e5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8055e8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8055ec:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8055ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8055f4:	75 1c                	jne    805612 <ipc_send+0x38>
		pg = (void*) UTOP;
  8055f6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8055fd:	00 00 00 
  805600:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805604:	eb 0c                	jmp    805612 <ipc_send+0x38>
		sys_yield();
  805606:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  80560d:	00 00 00 
  805610:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805612:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805615:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805618:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80561c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80561f:	89 c7                	mov    %eax,%edi
  805621:	48 b8 c1 21 80 00 00 	movabs $0x8021c1,%rax
  805628:	00 00 00 
  80562b:	ff d0                	callq  *%rax
  80562d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805630:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805634:	74 d0                	je     805606 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  805636:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80563a:	79 30                	jns    80566c <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80563c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80563f:	89 c1                	mov    %eax,%ecx
  805641:	48 ba 35 63 80 00 00 	movabs $0x806335,%rdx
  805648:	00 00 00 
  80564b:	be 47 00 00 00       	mov    $0x47,%esi
  805650:	48 bf 4b 63 80 00 00 	movabs $0x80634b,%rdi
  805657:	00 00 00 
  80565a:	b8 00 00 00 00       	mov    $0x0,%eax
  80565f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  805666:	00 00 00 
  805669:	41 ff d0             	callq  *%r8

}
  80566c:	90                   	nop
  80566d:	c9                   	leaveq 
  80566e:	c3                   	retq   

000000000080566f <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80566f:	55                   	push   %rbp
  805670:	48 89 e5             	mov    %rsp,%rbp
  805673:	53                   	push   %rbx
  805674:	48 83 ec 28          	sub    $0x28,%rsp
  805678:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  80567c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  805683:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  80568a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80568f:	75 0e                	jne    80569f <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  805691:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805698:	00 00 00 
  80569b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  80569f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056a3:	ba 07 00 00 00       	mov    $0x7,%edx
  8056a8:	48 89 c6             	mov    %rax,%rsi
  8056ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8056b0:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8056b7:	00 00 00 
  8056ba:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8056bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8056c4:	48 89 c2             	mov    %rax,%rdx
  8056c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8056ce:	01 00 00 
  8056d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056d5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8056db:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  8056df:	b8 03 00 00 00       	mov    $0x3,%eax
  8056e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8056e8:	48 89 d3             	mov    %rdx,%rbx
  8056eb:	0f 01 c1             	vmcall 
  8056ee:	89 f2                	mov    %esi,%edx
  8056f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8056f3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  8056f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8056fa:	79 05                	jns    805701 <ipc_host_recv+0x92>
		return r;
  8056fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8056ff:	eb 03                	jmp    805704 <ipc_host_recv+0x95>
	}
	return val;
  805701:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  805704:	48 83 c4 28          	add    $0x28,%rsp
  805708:	5b                   	pop    %rbx
  805709:	5d                   	pop    %rbp
  80570a:	c3                   	retq   

000000000080570b <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80570b:	55                   	push   %rbp
  80570c:	48 89 e5             	mov    %rsp,%rbp
  80570f:	53                   	push   %rbx
  805710:	48 83 ec 38          	sub    $0x38,%rsp
  805714:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805717:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80571a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80571e:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  805721:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  805728:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80572d:	75 0e                	jne    80573d <ipc_host_send+0x32>
		pg = (void*) UTOP;
  80572f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805736:	00 00 00 
  805739:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80573d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805741:	48 c1 e8 0c          	shr    $0xc,%rax
  805745:	48 89 c2             	mov    %rax,%rdx
  805748:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80574f:	01 00 00 
  805752:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805756:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80575c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  805760:	b8 02 00 00 00       	mov    $0x2,%eax
  805765:	8b 7d dc             	mov    -0x24(%rbp),%edi
  805768:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80576b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80576f:	8b 75 cc             	mov    -0x34(%rbp),%esi
  805772:	89 fb                	mov    %edi,%ebx
  805774:	0f 01 c1             	vmcall 
  805777:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80577a:	eb 26                	jmp    8057a2 <ipc_host_send+0x97>
		sys_yield();
  80577c:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  805783:	00 00 00 
  805786:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  805788:	b8 02 00 00 00       	mov    $0x2,%eax
  80578d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  805790:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805793:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805797:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80579a:	89 fb                	mov    %edi,%ebx
  80579c:	0f 01 c1             	vmcall 
  80579f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8057a2:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8057a6:	74 d4                	je     80577c <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8057a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8057ac:	79 30                	jns    8057de <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8057ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057b1:	89 c1                	mov    %eax,%ecx
  8057b3:	48 ba 35 63 80 00 00 	movabs $0x806335,%rdx
  8057ba:	00 00 00 
  8057bd:	be 79 00 00 00       	mov    $0x79,%esi
  8057c2:	48 bf 4b 63 80 00 00 	movabs $0x80634b,%rdi
  8057c9:	00 00 00 
  8057cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8057d1:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8057d8:	00 00 00 
  8057db:	41 ff d0             	callq  *%r8

}
  8057de:	90                   	nop
  8057df:	48 83 c4 38          	add    $0x38,%rsp
  8057e3:	5b                   	pop    %rbx
  8057e4:	5d                   	pop    %rbp
  8057e5:	c3                   	retq   

00000000008057e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8057e6:	55                   	push   %rbp
  8057e7:	48 89 e5             	mov    %rsp,%rbp
  8057ea:	48 83 ec 18          	sub    $0x18,%rsp
  8057ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8057f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8057f8:	eb 4d                	jmp    805847 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8057fa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805801:	00 00 00 
  805804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805807:	48 98                	cltq   
  805809:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805810:	48 01 d0             	add    %rdx,%rax
  805813:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805819:	8b 00                	mov    (%rax),%eax
  80581b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80581e:	75 23                	jne    805843 <ipc_find_env+0x5d>
			return envs[i].env_id;
  805820:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805827:	00 00 00 
  80582a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80582d:	48 98                	cltq   
  80582f:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805836:	48 01 d0             	add    %rdx,%rax
  805839:	48 05 c8 00 00 00    	add    $0xc8,%rax
  80583f:	8b 00                	mov    (%rax),%eax
  805841:	eb 12                	jmp    805855 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805843:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805847:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80584e:	7e aa                	jle    8057fa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805850:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805855:	c9                   	leaveq 
  805856:	c3                   	retq   

0000000000805857 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  805857:	55                   	push   %rbp
  805858:	48 89 e5             	mov    %rsp,%rbp
  80585b:	48 83 ec 18          	sub    $0x18,%rsp
  80585f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805867:	48 c1 e8 15          	shr    $0x15,%rax
  80586b:	48 89 c2             	mov    %rax,%rdx
  80586e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805875:	01 00 00 
  805878:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80587c:	83 e0 01             	and    $0x1,%eax
  80587f:	48 85 c0             	test   %rax,%rax
  805882:	75 07                	jne    80588b <pageref+0x34>
		return 0;
  805884:	b8 00 00 00 00       	mov    $0x0,%eax
  805889:	eb 56                	jmp    8058e1 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  80588b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80588f:	48 c1 e8 0c          	shr    $0xc,%rax
  805893:	48 89 c2             	mov    %rax,%rdx
  805896:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80589d:	01 00 00 
  8058a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8058a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8058a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058ac:	83 e0 01             	and    $0x1,%eax
  8058af:	48 85 c0             	test   %rax,%rax
  8058b2:	75 07                	jne    8058bb <pageref+0x64>
		return 0;
  8058b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8058b9:	eb 26                	jmp    8058e1 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8058bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8058c3:	48 89 c2             	mov    %rax,%rdx
  8058c6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8058cd:	00 00 00 
  8058d0:	48 c1 e2 04          	shl    $0x4,%rdx
  8058d4:	48 01 d0             	add    %rdx,%rax
  8058d7:	48 83 c0 08          	add    $0x8,%rax
  8058db:	0f b7 00             	movzwl (%rax),%eax
  8058de:	0f b7 c0             	movzwl %ax,%eax
}
  8058e1:	c9                   	leaveq 
  8058e2:	c3                   	retq   
