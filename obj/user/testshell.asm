
obj/user/testshell:     file format elf64-x86-64


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
  800057:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
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
  800091:	48 bf 80 58 80 00 00 	movabs $0x805880,%rdi
  800098:	00 00 00 
  80009b:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 8d 58 80 00 00 	movabs $0x80588d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 14 00 00 00       	mov    $0x14,%esi
  8000c4:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 9b 4e 80 00 00 	movabs $0x804e9b,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba b4 58 80 00 00 	movabs $0x8058b4,%rdx
  800108:	00 00 00 
  80010b:	be 16 00 00 00       	mov    $0x16,%esi
  800110:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf c0 58 80 00 00 	movabs $0x8058c0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 77 28 80 00 00 	movabs $0x802877,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba e4 58 80 00 00 	movabs $0x8058e4,%rdx
  80016e:	00 00 00 
  800171:	be 1b 00 00 00       	mov    $0x1b,%esi
  800176:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
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
  8001a6:	48 b8 60 2e 80 00 00 	movabs $0x802e60,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 60 2e 80 00 00 	movabs $0x802e60,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba ed 58 80 00 00 	movabs $0x8058ed,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be f0 58 80 00 00 	movabs $0x8058f0,%rsi
  800200:	00 00 00 
  800203:	48 bf f3 58 80 00 00 	movabs $0x8058f3,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 79 3e 80 00 00 	movabs $0x803e79,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba fb 58 80 00 00 	movabs $0x8058fb,%rdx
  800234:	00 00 00 
  800237:	be 22 00 00 00       	mov    $0x22,%esi
  80023c:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 56 54 80 00 00 	movabs $0x805456,%rax
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
  80029c:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 05 59 80 00 00 	movabs $0x805905,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 18 59 80 00 00 	movabs $0x805918,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002f7:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
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
  800332:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 3b 59 80 00 00 	movabs $0x80593b,%rdx
  800373:	00 00 00 
  800376:	be 34 00 00 00       	mov    $0x34,%esi
  80037b:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
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
  8003a2:	48 ba 55 59 80 00 00 	movabs $0x805955,%rdx
  8003a9:	00 00 00 
  8003ac:	be 36 00 00 00       	mov    $0x36,%esi
  8003b1:	48 bf a3 58 80 00 00 	movabs $0x8058a3,%rdi
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
  800425:	48 bf 6f 59 80 00 00 	movabs $0x80596f,%rdi
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
  80045f:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 88 59 80 00 00 	movabs $0x805988,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf aa 59 80 00 00 	movabs $0x8059aa,%rdi
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
  8004e6:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf b9 59 80 00 00 	movabs $0x8059b9,%rdi
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
  800545:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf c7 59 80 00 00 	movabs $0x8059c7,%rdi
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
  8005c9:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
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
  800610:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
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
  800655:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
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
  8006be:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
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
  800816:	48 be d1 59 80 00 00 	movabs $0x8059d1,%rsi
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
  8008be:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
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
  800998:	48 bf e8 59 80 00 00 	movabs $0x8059e8,%rdi
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
  8009d4:	48 bf 0b 5a 80 00 00 	movabs $0x805a0b,%rdi
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
  800c85:	48 b8 10 5c 80 00 00 	movabs $0x805c10,%rax
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
  800f67:	48 b8 38 5c 80 00 00 	movabs $0x805c38,%rax
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
  8010ae:	48 b8 60 5b 80 00 00 	movabs $0x805b60,%rax
  8010b5:	00 00 00 
  8010b8:	48 63 d3             	movslq %ebx,%rdx
  8010bb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010bf:	4d 85 e4             	test   %r12,%r12
  8010c2:	75 2e                	jne    8010f2 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8010c4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010cc:	89 d9                	mov    %ebx,%ecx
  8010ce:	48 ba 21 5c 80 00 00 	movabs $0x805c21,%rdx
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
  8010fd:	48 ba 2a 5c 80 00 00 	movabs $0x805c2a,%rdx
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
  801154:	49 bc 2d 5c 80 00 00 	movabs $0x805c2d,%r12
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
  801e60:	48 ba e8 5e 80 00 00 	movabs $0x805ee8,%rdx
  801e67:	00 00 00 
  801e6a:	be 24 00 00 00       	mov    $0x24,%esi
  801e6f:	48 bf 05 5f 80 00 00 	movabs $0x805f05,%rdi
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

00000000008023da <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8023de:	48 83 ec 08          	sub    $0x8,%rsp
  8023e2:	6a 00                	pushq  $0x0
  8023e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fa:	be 00 00 00 00       	mov    $0x0,%esi
  8023ff:	bf 13 00 00 00       	mov    $0x13,%edi
  802404:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
  802410:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  802414:	90                   	nop
  802415:	c9                   	leaveq 
  802416:	c3                   	retq   

0000000000802417 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802417:	55                   	push   %rbp
  802418:	48 89 e5             	mov    %rsp,%rbp
  80241b:	48 83 ec 10          	sub    $0x10,%rsp
  80241f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802425:	48 98                	cltq   
  802427:	48 83 ec 08          	sub    $0x8,%rsp
  80242b:	6a 00                	pushq  $0x0
  80242d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802433:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802439:	b9 00 00 00 00       	mov    $0x0,%ecx
  80243e:	48 89 c2             	mov    %rax,%rdx
  802441:	be 00 00 00 00       	mov    $0x0,%esi
  802446:	bf 14 00 00 00       	mov    $0x14,%edi
  80244b:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax
  802457:	48 83 c4 10          	add    $0x10,%rsp
}
  80245b:	c9                   	leaveq 
  80245c:	c3                   	retq   

000000000080245d <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  80245d:	55                   	push   %rbp
  80245e:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802461:	48 83 ec 08          	sub    $0x8,%rsp
  802465:	6a 00                	pushq  $0x0
  802467:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80246d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802473:	b9 00 00 00 00       	mov    $0x0,%ecx
  802478:	ba 00 00 00 00       	mov    $0x0,%edx
  80247d:	be 00 00 00 00       	mov    $0x0,%esi
  802482:	bf 15 00 00 00       	mov    $0x15,%edi
  802487:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
  802493:	48 83 c4 10          	add    $0x10,%rsp
}
  802497:	c9                   	leaveq 
  802498:	c3                   	retq   

0000000000802499 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802499:	55                   	push   %rbp
  80249a:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80249d:	48 83 ec 08          	sub    $0x8,%rsp
  8024a1:	6a 00                	pushq  $0x0
  8024a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b9:	be 00 00 00 00       	mov    $0x0,%esi
  8024be:	bf 16 00 00 00       	mov    $0x16,%edi
  8024c3:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax
  8024cf:	48 83 c4 10          	add    $0x10,%rsp
}
  8024d3:	90                   	nop
  8024d4:	c9                   	leaveq 
  8024d5:	c3                   	retq   

00000000008024d6 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8024d6:	55                   	push   %rbp
  8024d7:	48 89 e5             	mov    %rsp,%rbp
  8024da:	48 83 ec 30          	sub    $0x30,%rsp
  8024de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8024e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e6:	48 8b 00             	mov    (%rax),%rax
  8024e9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8024ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024f5:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8024f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fb:	83 e0 02             	and    $0x2,%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	75 40                	jne    802542 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802506:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  80250d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802511:	49 89 d0             	mov    %rdx,%r8
  802514:	48 89 c1             	mov    %rax,%rcx
  802517:	48 ba 18 5f 80 00 00 	movabs $0x805f18,%rdx
  80251e:	00 00 00 
  802521:	be 1f 00 00 00       	mov    $0x1f,%esi
  802526:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  80252d:	00 00 00 
  802530:	b8 00 00 00 00       	mov    $0x0,%eax
  802535:	49 b9 de 08 80 00 00 	movabs $0x8008de,%r9
  80253c:	00 00 00 
  80253f:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802542:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802546:	48 c1 e8 0c          	shr    $0xc,%rax
  80254a:	48 89 c2             	mov    %rax,%rdx
  80254d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802554:	01 00 00 
  802557:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80255b:	25 07 08 00 00       	and    $0x807,%eax
  802560:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802566:	74 4e                	je     8025b6 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  802568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256c:	48 c1 e8 0c          	shr    $0xc,%rax
  802570:	48 89 c2             	mov    %rax,%rdx
  802573:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80257a:	01 00 00 
  80257d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802581:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802585:	49 89 d0             	mov    %rdx,%r8
  802588:	48 89 c1             	mov    %rax,%rcx
  80258b:	48 ba 40 5f 80 00 00 	movabs $0x805f40,%rdx
  802592:	00 00 00 
  802595:	be 22 00 00 00       	mov    $0x22,%esi
  80259a:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  8025a1:	00 00 00 
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	49 b9 de 08 80 00 00 	movabs $0x8008de,%r9
  8025b0:	00 00 00 
  8025b3:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8025b6:	ba 07 00 00 00       	mov    $0x7,%edx
  8025bb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8025c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c5:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	callq  *%rax
  8025d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8025d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025d8:	79 30                	jns    80260a <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8025da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025dd:	89 c1                	mov    %eax,%ecx
  8025df:	48 ba 6b 5f 80 00 00 	movabs $0x805f6b,%rdx
  8025e6:	00 00 00 
  8025e9:	be 28 00 00 00       	mov    $0x28,%esi
  8025ee:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  8025f5:	00 00 00 
  8025f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fd:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802604:	00 00 00 
  802607:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80260a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80260e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802616:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80261c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802621:	48 89 c6             	mov    %rax,%rsi
  802624:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802629:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802635:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802639:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80263d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802641:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802647:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80264d:	48 89 c1             	mov    %rax,%rcx
  802650:	ba 00 00 00 00       	mov    $0x0,%edx
  802655:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80265a:	bf 00 00 00 00       	mov    $0x0,%edi
  80265f:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802666:	00 00 00 
  802669:	ff d0                	callq  *%rax
  80266b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80266e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802672:	79 30                	jns    8026a4 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802674:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802677:	89 c1                	mov    %eax,%ecx
  802679:	48 ba 7e 5f 80 00 00 	movabs $0x805f7e,%rdx
  802680:	00 00 00 
  802683:	be 2d 00 00 00       	mov    $0x2d,%esi
  802688:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  80268f:	00 00 00 
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
  802697:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80269e:	00 00 00 
  8026a1:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8026a4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8026a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ae:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8026bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026c1:	79 30                	jns    8026f3 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8026c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026c6:	89 c1                	mov    %eax,%ecx
  8026c8:	48 ba 8f 5f 80 00 00 	movabs $0x805f8f,%rdx
  8026cf:	00 00 00 
  8026d2:	be 31 00 00 00       	mov    $0x31,%esi
  8026d7:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  8026de:	00 00 00 
  8026e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e6:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8026ed:	00 00 00 
  8026f0:	41 ff d0             	callq  *%r8

}
  8026f3:	90                   	nop
  8026f4:	c9                   	leaveq 
  8026f5:	c3                   	retq   

00000000008026f6 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8026f6:	55                   	push   %rbp
  8026f7:	48 89 e5             	mov    %rsp,%rbp
  8026fa:	48 83 ec 30          	sub    $0x30,%rsp
  8026fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802701:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802704:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802707:	c1 e0 0c             	shl    $0xc,%eax
  80270a:	89 c0                	mov    %eax,%eax
  80270c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802710:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802717:	01 00 00 
  80271a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80271d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802721:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802729:	25 02 08 00 00       	and    $0x802,%eax
  80272e:	48 85 c0             	test   %rax,%rax
  802731:	74 0e                	je     802741 <duppage+0x4b>
  802733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802737:	25 00 04 00 00       	and    $0x400,%eax
  80273c:	48 85 c0             	test   %rax,%rax
  80273f:	74 70                	je     8027b1 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802745:	25 07 0e 00 00       	and    $0xe07,%eax
  80274a:	89 c6                	mov    %eax,%esi
  80274c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802750:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802753:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802757:	41 89 f0             	mov    %esi,%r8d
  80275a:	48 89 c6             	mov    %rax,%rsi
  80275d:	bf 00 00 00 00       	mov    $0x0,%edi
  802762:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802769:	00 00 00 
  80276c:	ff d0                	callq  *%rax
  80276e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802771:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802775:	79 30                	jns    8027a7 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802777:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80277a:	89 c1                	mov    %eax,%ecx
  80277c:	48 ba 7e 5f 80 00 00 	movabs $0x805f7e,%rdx
  802783:	00 00 00 
  802786:	be 50 00 00 00       	mov    $0x50,%esi
  80278b:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  802792:	00 00 00 
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8027a1:	00 00 00 
  8027a4:	41 ff d0             	callq  *%r8
		return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ac:	e9 c4 00 00 00       	jmpq   802875 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8027b1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8027b5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027bc:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8027c2:	48 89 c6             	mov    %rax,%rsi
  8027c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ca:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027dd:	79 30                	jns    80280f <duppage+0x119>
		panic("sys_page_map: %e", r);
  8027df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e2:	89 c1                	mov    %eax,%ecx
  8027e4:	48 ba 7e 5f 80 00 00 	movabs $0x805f7e,%rdx
  8027eb:	00 00 00 
  8027ee:	be 64 00 00 00       	mov    $0x64,%esi
  8027f3:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  8027fa:	00 00 00 
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802809:	00 00 00 
  80280c:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80280f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802817:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80281d:	48 89 d1             	mov    %rdx,%rcx
  802820:	ba 00 00 00 00       	mov    $0x0,%edx
  802825:	48 89 c6             	mov    %rax,%rsi
  802828:	bf 00 00 00 00       	mov    $0x0,%edi
  80282d:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
  802839:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80283c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802840:	79 30                	jns    802872 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802842:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802845:	89 c1                	mov    %eax,%ecx
  802847:	48 ba 7e 5f 80 00 00 	movabs $0x805f7e,%rdx
  80284e:	00 00 00 
  802851:	be 66 00 00 00       	mov    $0x66,%esi
  802856:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  80285d:	00 00 00 
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
  802865:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80286c:	00 00 00 
  80286f:	41 ff d0             	callq  *%r8
	return r;
  802872:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802875:	c9                   	leaveq 
  802876:	c3                   	retq   

0000000000802877 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802877:	55                   	push   %rbp
  802878:	48 89 e5             	mov    %rsp,%rbp
  80287b:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  80287f:	48 bf d6 24 80 00 00 	movabs $0x8024d6,%rdi
  802886:	00 00 00 
  802889:	48 b8 ec 54 80 00 00 	movabs $0x8054ec,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802895:	b8 07 00 00 00       	mov    $0x7,%eax
  80289a:	cd 30                	int    $0x30
  80289c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80289f:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8028a2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8028a5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028a9:	79 08                	jns    8028b3 <fork+0x3c>
		return envid;
  8028ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028ae:	e9 0b 02 00 00       	jmpq   802abe <fork+0x247>
	if (envid == 0) {
  8028b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028b7:	75 3e                	jne    8028f7 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8028b9:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8028ca:	48 98                	cltq   
  8028cc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8028d3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028da:	00 00 00 
  8028dd:	48 01 c2             	add    %rax,%rdx
  8028e0:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8028e7:	00 00 00 
  8028ea:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	e9 c7 01 00 00       	jmpq   802abe <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8028f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028fe:	e9 a6 00 00 00       	jmpq   8029a9 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802906:	c1 f8 12             	sar    $0x12,%eax
  802909:	89 c2                	mov    %eax,%edx
  80290b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802912:	01 00 00 
  802915:	48 63 d2             	movslq %edx,%rdx
  802918:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291c:	83 e0 01             	and    $0x1,%eax
  80291f:	48 85 c0             	test   %rax,%rax
  802922:	74 21                	je     802945 <fork+0xce>
  802924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802927:	c1 f8 09             	sar    $0x9,%eax
  80292a:	89 c2                	mov    %eax,%edx
  80292c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802933:	01 00 00 
  802936:	48 63 d2             	movslq %edx,%rdx
  802939:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293d:	83 e0 01             	and    $0x1,%eax
  802940:	48 85 c0             	test   %rax,%rax
  802943:	75 09                	jne    80294e <fork+0xd7>
			pn += NPTENTRIES;
  802945:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80294c:	eb 5b                	jmp    8029a9 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80294e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802951:	05 00 02 00 00       	add    $0x200,%eax
  802956:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802959:	eb 46                	jmp    8029a1 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80295b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802962:	01 00 00 
  802965:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802968:	48 63 d2             	movslq %edx,%rdx
  80296b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296f:	83 e0 05             	and    $0x5,%eax
  802972:	48 83 f8 05          	cmp    $0x5,%rax
  802976:	75 21                	jne    802999 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  802978:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  80297f:	74 1b                	je     80299c <fork+0x125>
				continue;
			duppage(envid, pn);
  802981:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802984:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802987:	89 d6                	mov    %edx,%esi
  802989:	89 c7                	mov    %eax,%edi
  80298b:	48 b8 f6 26 80 00 00 	movabs $0x8026f6,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
  802997:	eb 04                	jmp    80299d <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802999:	90                   	nop
  80299a:	eb 01                	jmp    80299d <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80299c:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80299d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8029a7:	7c b2                	jl     80295b <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8029a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ac:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8029b1:	0f 86 4c ff ff ff    	jbe    802903 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8029b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8029bf:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8029c4:	89 c7                	mov    %eax,%edi
  8029c6:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8029d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8029d9:	79 30                	jns    802a0b <fork+0x194>
		panic("allocating exception stack: %e", r);
  8029db:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029de:	89 c1                	mov    %eax,%ecx
  8029e0:	48 ba a8 5f 80 00 00 	movabs $0x805fa8,%rdx
  8029e7:	00 00 00 
  8029ea:	be 9e 00 00 00       	mov    $0x9e,%esi
  8029ef:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  8029f6:	00 00 00 
  8029f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fe:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802a05:	00 00 00 
  802a08:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802a0b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802a12:	00 00 00 
  802a15:	48 8b 00             	mov    (%rax),%rax
  802a18:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802a1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a22:	48 89 d6             	mov    %rdx,%rsi
  802a25:	89 c7                	mov    %eax,%edi
  802a27:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
  802a33:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802a36:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a3a:	79 30                	jns    802a6c <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802a3c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a3f:	89 c1                	mov    %eax,%ecx
  802a41:	48 ba c8 5f 80 00 00 	movabs $0x805fc8,%rdx
  802a48:	00 00 00 
  802a4b:	be a2 00 00 00       	mov    $0xa2,%esi
  802a50:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  802a57:	00 00 00 
  802a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802a66:	00 00 00 
  802a69:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802a6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a6f:	be 02 00 00 00       	mov    $0x2,%esi
  802a74:	89 c7                	mov    %eax,%edi
  802a76:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
  802a82:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802a85:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a89:	79 30                	jns    802abb <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802a8b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a8e:	89 c1                	mov    %eax,%ecx
  802a90:	48 ba e7 5f 80 00 00 	movabs $0x805fe7,%rdx
  802a97:	00 00 00 
  802a9a:	be a7 00 00 00       	mov    $0xa7,%esi
  802a9f:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  802aa6:	00 00 00 
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aae:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  802ab5:	00 00 00 
  802ab8:	41 ff d0             	callq  *%r8

	return envid;
  802abb:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802abe:	c9                   	leaveq 
  802abf:	c3                   	retq   

0000000000802ac0 <sfork>:

// Challenge!
int
sfork(void)
{
  802ac0:	55                   	push   %rbp
  802ac1:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802ac4:	48 ba fe 5f 80 00 00 	movabs $0x805ffe,%rdx
  802acb:	00 00 00 
  802ace:	be b1 00 00 00       	mov    $0xb1,%esi
  802ad3:	48 bf 31 5f 80 00 00 	movabs $0x805f31,%rdi
  802ada:	00 00 00 
  802add:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae2:	48 b9 de 08 80 00 00 	movabs $0x8008de,%rcx
  802ae9:	00 00 00 
  802aec:	ff d1                	callq  *%rcx

0000000000802aee <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802aee:	55                   	push   %rbp
  802aef:	48 89 e5             	mov    %rsp,%rbp
  802af2:	48 83 ec 08          	sub    $0x8,%rsp
  802af6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802afa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802afe:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802b05:	ff ff ff 
  802b08:	48 01 d0             	add    %rdx,%rax
  802b0b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 08          	sub    $0x8,%rsp
  802b19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802b1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b21:	48 89 c7             	mov    %rax,%rdi
  802b24:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
  802b2b:	00 00 00 
  802b2e:	ff d0                	callq  *%rax
  802b30:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802b36:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802b3a:	c9                   	leaveq 
  802b3b:	c3                   	retq   

0000000000802b3c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b3c:	55                   	push   %rbp
  802b3d:	48 89 e5             	mov    %rsp,%rbp
  802b40:	48 83 ec 18          	sub    $0x18,%rsp
  802b44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b4f:	eb 6b                	jmp    802bbc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b54:	48 98                	cltq   
  802b56:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b5c:	48 c1 e0 0c          	shl    $0xc,%rax
  802b60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b68:	48 c1 e8 15          	shr    $0x15,%rax
  802b6c:	48 89 c2             	mov    %rax,%rdx
  802b6f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b76:	01 00 00 
  802b79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b7d:	83 e0 01             	and    $0x1,%eax
  802b80:	48 85 c0             	test   %rax,%rax
  802b83:	74 21                	je     802ba6 <fd_alloc+0x6a>
  802b85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b89:	48 c1 e8 0c          	shr    $0xc,%rax
  802b8d:	48 89 c2             	mov    %rax,%rdx
  802b90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b97:	01 00 00 
  802b9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b9e:	83 e0 01             	and    $0x1,%eax
  802ba1:	48 85 c0             	test   %rax,%rax
  802ba4:	75 12                	jne    802bb8 <fd_alloc+0x7c>
			*fd_store = fd;
  802ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802baa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bae:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb6:	eb 1a                	jmp    802bd2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802bb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bbc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802bc0:	7e 8f                	jle    802b51 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802bcd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802bd2:	c9                   	leaveq 
  802bd3:	c3                   	retq   

0000000000802bd4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802bd4:	55                   	push   %rbp
  802bd5:	48 89 e5             	mov    %rsp,%rbp
  802bd8:	48 83 ec 20          	sub    $0x20,%rsp
  802bdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802be3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802be7:	78 06                	js     802bef <fd_lookup+0x1b>
  802be9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802bed:	7e 07                	jle    802bf6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bf4:	eb 6c                	jmp    802c62 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf9:	48 98                	cltq   
  802bfb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c01:	48 c1 e0 0c          	shl    $0xc,%rax
  802c05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c0d:	48 c1 e8 15          	shr    $0x15,%rax
  802c11:	48 89 c2             	mov    %rax,%rdx
  802c14:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c1b:	01 00 00 
  802c1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c22:	83 e0 01             	and    $0x1,%eax
  802c25:	48 85 c0             	test   %rax,%rax
  802c28:	74 21                	je     802c4b <fd_lookup+0x77>
  802c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c2e:	48 c1 e8 0c          	shr    $0xc,%rax
  802c32:	48 89 c2             	mov    %rax,%rdx
  802c35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c3c:	01 00 00 
  802c3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c43:	83 e0 01             	and    $0x1,%eax
  802c46:	48 85 c0             	test   %rax,%rax
  802c49:	75 07                	jne    802c52 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c50:	eb 10                	jmp    802c62 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802c52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c56:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c5a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c62:	c9                   	leaveq 
  802c63:	c3                   	retq   

0000000000802c64 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c64:	55                   	push   %rbp
  802c65:	48 89 e5             	mov    %rsp,%rbp
  802c68:	48 83 ec 30          	sub    $0x30,%rsp
  802c6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c70:	89 f0                	mov    %esi,%eax
  802c72:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c79:	48 89 c7             	mov    %rax,%rdi
  802c7c:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
  802c88:	89 c2                	mov    %eax,%edx
  802c8a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c8e:	48 89 c6             	mov    %rax,%rsi
  802c91:	89 d7                	mov    %edx,%edi
  802c93:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca6:	78 0a                	js     802cb2 <fd_close+0x4e>
	    || fd != fd2)
  802ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cac:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802cb0:	74 12                	je     802cc4 <fd_close+0x60>
		return (must_exist ? r : 0);
  802cb2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802cb6:	74 05                	je     802cbd <fd_close+0x59>
  802cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbb:	eb 70                	jmp    802d2d <fd_close+0xc9>
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc2:	eb 69                	jmp    802d2d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802cc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc8:	8b 00                	mov    (%rax),%eax
  802cca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cce:	48 89 d6             	mov    %rdx,%rsi
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	48 b8 2f 2d 80 00 00 	movabs $0x802d2f,%rax
  802cda:	00 00 00 
  802cdd:	ff d0                	callq  *%rax
  802cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce6:	78 2a                	js     802d12 <fd_close+0xae>
		if (dev->dev_close)
  802ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cec:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cf0:	48 85 c0             	test   %rax,%rax
  802cf3:	74 16                	je     802d0b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf9:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cfd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d01:	48 89 d7             	mov    %rdx,%rdi
  802d04:	ff d0                	callq  *%rax
  802d06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d09:	eb 07                	jmp    802d12 <fd_close+0xae>
		else
			r = 0;
  802d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802d12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d16:	48 89 c6             	mov    %rax,%rsi
  802d19:	bf 00 00 00 00       	mov    $0x0,%edi
  802d1e:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802d25:	00 00 00 
  802d28:	ff d0                	callq  *%rax
	return r;
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d2d:	c9                   	leaveq 
  802d2e:	c3                   	retq   

0000000000802d2f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d2f:	55                   	push   %rbp
  802d30:	48 89 e5             	mov    %rsp,%rbp
  802d33:	48 83 ec 20          	sub    $0x20,%rsp
  802d37:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d3a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802d3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d45:	eb 41                	jmp    802d88 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802d47:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802d4e:	00 00 00 
  802d51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d54:	48 63 d2             	movslq %edx,%rdx
  802d57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d5b:	8b 00                	mov    (%rax),%eax
  802d5d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d60:	75 22                	jne    802d84 <dev_lookup+0x55>
			*dev = devtab[i];
  802d62:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802d69:	00 00 00 
  802d6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d6f:	48 63 d2             	movslq %edx,%rdx
  802d72:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d82:	eb 60                	jmp    802de4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d84:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d88:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802d8f:	00 00 00 
  802d92:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d95:	48 63 d2             	movslq %edx,%rdx
  802d98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d9c:	48 85 c0             	test   %rax,%rax
  802d9f:	75 a6                	jne    802d47 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802da1:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802da8:	00 00 00 
  802dab:	48 8b 00             	mov    (%rax),%rax
  802dae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802db4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802db7:	89 c6                	mov    %eax,%esi
  802db9:	48 bf 18 60 80 00 00 	movabs $0x806018,%rdi
  802dc0:	00 00 00 
  802dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc8:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  802dcf:	00 00 00 
  802dd2:	ff d1                	callq  *%rcx
	*dev = 0;
  802dd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802ddf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802de4:	c9                   	leaveq 
  802de5:	c3                   	retq   

0000000000802de6 <close>:

int
close(int fdnum)
{
  802de6:	55                   	push   %rbp
  802de7:	48 89 e5             	mov    %rsp,%rbp
  802dea:	48 83 ec 20          	sub    $0x20,%rsp
  802dee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802df1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802df5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802df8:	48 89 d6             	mov    %rdx,%rsi
  802dfb:	89 c7                	mov    %eax,%edi
  802dfd:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  802e04:	00 00 00 
  802e07:	ff d0                	callq  *%rax
  802e09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e10:	79 05                	jns    802e17 <close+0x31>
		return r;
  802e12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e15:	eb 18                	jmp    802e2f <close+0x49>
	else
		return fd_close(fd, 1);
  802e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1b:	be 01 00 00 00       	mov    $0x1,%esi
  802e20:	48 89 c7             	mov    %rax,%rdi
  802e23:	48 b8 64 2c 80 00 00 	movabs $0x802c64,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	callq  *%rax
}
  802e2f:	c9                   	leaveq 
  802e30:	c3                   	retq   

0000000000802e31 <close_all>:

void
close_all(void)
{
  802e31:	55                   	push   %rbp
  802e32:	48 89 e5             	mov    %rsp,%rbp
  802e35:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e40:	eb 15                	jmp    802e57 <close_all+0x26>
		close(i);
  802e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e45:	89 c7                	mov    %eax,%edi
  802e47:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802e53:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e57:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e5b:	7e e5                	jle    802e42 <close_all+0x11>
		close(i);
}
  802e5d:	90                   	nop
  802e5e:	c9                   	leaveq 
  802e5f:	c3                   	retq   

0000000000802e60 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e60:	55                   	push   %rbp
  802e61:	48 89 e5             	mov    %rsp,%rbp
  802e64:	48 83 ec 40          	sub    $0x40,%rsp
  802e68:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e6b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e6e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e72:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e75:	48 89 d6             	mov    %rdx,%rsi
  802e78:	89 c7                	mov    %eax,%edi
  802e7a:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  802e81:	00 00 00 
  802e84:	ff d0                	callq  *%rax
  802e86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8d:	79 08                	jns    802e97 <dup+0x37>
		return r;
  802e8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e92:	e9 70 01 00 00       	jmpq   803007 <dup+0x1a7>
	close(newfdnum);
  802e97:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e9a:	89 c7                	mov    %eax,%edi
  802e9c:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802ea8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802eab:	48 98                	cltq   
  802ead:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802eb3:	48 c1 e0 0c          	shl    $0xc,%rax
  802eb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802ebb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ebf:	48 89 c7             	mov    %rax,%rdi
  802ec2:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
  802ece:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed6:	48 89 c7             	mov    %rax,%rdi
  802ed9:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
  802ee5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eed:	48 c1 e8 15          	shr    $0x15,%rax
  802ef1:	48 89 c2             	mov    %rax,%rdx
  802ef4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802efb:	01 00 00 
  802efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f02:	83 e0 01             	and    $0x1,%eax
  802f05:	48 85 c0             	test   %rax,%rax
  802f08:	74 71                	je     802f7b <dup+0x11b>
  802f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0e:	48 c1 e8 0c          	shr    $0xc,%rax
  802f12:	48 89 c2             	mov    %rax,%rdx
  802f15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f1c:	01 00 00 
  802f1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f23:	83 e0 01             	and    $0x1,%eax
  802f26:	48 85 c0             	test   %rax,%rax
  802f29:	74 50                	je     802f7b <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2f:	48 c1 e8 0c          	shr    $0xc,%rax
  802f33:	48 89 c2             	mov    %rax,%rdx
  802f36:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f3d:	01 00 00 
  802f40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f44:	25 07 0e 00 00       	and    $0xe07,%eax
  802f49:	89 c1                	mov    %eax,%ecx
  802f4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f53:	41 89 c8             	mov    %ecx,%r8d
  802f56:	48 89 d1             	mov    %rdx,%rcx
  802f59:	ba 00 00 00 00       	mov    $0x0,%edx
  802f5e:	48 89 c6             	mov    %rax,%rsi
  802f61:	bf 00 00 00 00       	mov    $0x0,%edi
  802f66:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
  802f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f79:	78 55                	js     802fd0 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7f:	48 c1 e8 0c          	shr    $0xc,%rax
  802f83:	48 89 c2             	mov    %rax,%rdx
  802f86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f8d:	01 00 00 
  802f90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f94:	25 07 0e 00 00       	and    $0xe07,%eax
  802f99:	89 c1                	mov    %eax,%ecx
  802f9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fa3:	41 89 c8             	mov    %ecx,%r8d
  802fa6:	48 89 d1             	mov    %rdx,%rcx
  802fa9:	ba 00 00 00 00       	mov    $0x0,%edx
  802fae:	48 89 c6             	mov    %rax,%rsi
  802fb1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb6:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802fbd:	00 00 00 
  802fc0:	ff d0                	callq  *%rax
  802fc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc9:	78 08                	js     802fd3 <dup+0x173>
		goto err;

	return newfdnum;
  802fcb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802fce:	eb 37                	jmp    803007 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802fd0:	90                   	nop
  802fd1:	eb 01                	jmp    802fd4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802fd3:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd8:	48 89 c6             	mov    %rax,%rsi
  802fdb:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe0:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802fec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff0:	48 89 c6             	mov    %rax,%rsi
  802ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff8:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
	return r;
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803007:	c9                   	leaveq 
  803008:	c3                   	retq   

0000000000803009 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803009:	55                   	push   %rbp
  80300a:	48 89 e5             	mov    %rsp,%rbp
  80300d:	48 83 ec 40          	sub    $0x40,%rsp
  803011:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803014:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803018:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80301c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803020:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803023:	48 89 d6             	mov    %rdx,%rsi
  803026:	89 c7                	mov    %eax,%edi
  803028:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303b:	78 24                	js     803061 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80303d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803041:	8b 00                	mov    (%rax),%eax
  803043:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803047:	48 89 d6             	mov    %rdx,%rsi
  80304a:	89 c7                	mov    %eax,%edi
  80304c:	48 b8 2f 2d 80 00 00 	movabs $0x802d2f,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
  803058:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80305f:	79 05                	jns    803066 <read+0x5d>
		return r;
  803061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803064:	eb 76                	jmp    8030dc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306a:	8b 40 08             	mov    0x8(%rax),%eax
  80306d:	83 e0 03             	and    $0x3,%eax
  803070:	83 f8 01             	cmp    $0x1,%eax
  803073:	75 3a                	jne    8030af <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803075:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80307c:	00 00 00 
  80307f:	48 8b 00             	mov    (%rax),%rax
  803082:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803088:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80308b:	89 c6                	mov    %eax,%esi
  80308d:	48 bf 37 60 80 00 00 	movabs $0x806037,%rdi
  803094:	00 00 00 
  803097:	b8 00 00 00 00       	mov    $0x0,%eax
  80309c:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  8030a3:	00 00 00 
  8030a6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030ad:	eb 2d                	jmp    8030dc <read+0xd3>
	}
	if (!dev->dev_read)
  8030af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030b7:	48 85 c0             	test   %rax,%rax
  8030ba:	75 07                	jne    8030c3 <read+0xba>
		return -E_NOT_SUPP;
  8030bc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030c1:	eb 19                	jmp    8030dc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030cf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030d3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030d7:	48 89 cf             	mov    %rcx,%rdi
  8030da:	ff d0                	callq  *%rax
}
  8030dc:	c9                   	leaveq 
  8030dd:	c3                   	retq   

00000000008030de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8030de:	55                   	push   %rbp
  8030df:	48 89 e5             	mov    %rsp,%rbp
  8030e2:	48 83 ec 30          	sub    $0x30,%rsp
  8030e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030f8:	eb 47                	jmp    803141 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8030fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fd:	48 98                	cltq   
  8030ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803103:	48 29 c2             	sub    %rax,%rdx
  803106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803109:	48 63 c8             	movslq %eax,%rcx
  80310c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803110:	48 01 c1             	add    %rax,%rcx
  803113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803116:	48 89 ce             	mov    %rcx,%rsi
  803119:	89 c7                	mov    %eax,%edi
  80311b:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
  803127:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80312a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80312e:	79 05                	jns    803135 <readn+0x57>
			return m;
  803130:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803133:	eb 1d                	jmp    803152 <readn+0x74>
		if (m == 0)
  803135:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803139:	74 13                	je     80314e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80313b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803144:	48 98                	cltq   
  803146:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80314a:	72 ae                	jb     8030fa <readn+0x1c>
  80314c:	eb 01                	jmp    80314f <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80314e:	90                   	nop
	}
	return tot;
  80314f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803152:	c9                   	leaveq 
  803153:	c3                   	retq   

0000000000803154 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803154:	55                   	push   %rbp
  803155:	48 89 e5             	mov    %rsp,%rbp
  803158:	48 83 ec 40          	sub    $0x40,%rsp
  80315c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80315f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803163:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803167:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80316b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80316e:	48 89 d6             	mov    %rdx,%rsi
  803171:	89 c7                	mov    %eax,%edi
  803173:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  80317a:	00 00 00 
  80317d:	ff d0                	callq  *%rax
  80317f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803186:	78 24                	js     8031ac <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318c:	8b 00                	mov    (%rax),%eax
  80318e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803192:	48 89 d6             	mov    %rdx,%rsi
  803195:	89 c7                	mov    %eax,%edi
  803197:	48 b8 2f 2d 80 00 00 	movabs $0x802d2f,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
  8031a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031aa:	79 05                	jns    8031b1 <write+0x5d>
		return r;
  8031ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031af:	eb 75                	jmp    803226 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b5:	8b 40 08             	mov    0x8(%rax),%eax
  8031b8:	83 e0 03             	and    $0x3,%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	75 3a                	jne    8031f9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8031bf:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8031c6:	00 00 00 
  8031c9:	48 8b 00             	mov    (%rax),%rax
  8031cc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031d2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031d5:	89 c6                	mov    %eax,%esi
  8031d7:	48 bf 53 60 80 00 00 	movabs $0x806053,%rdi
  8031de:	00 00 00 
  8031e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e6:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  8031ed:	00 00 00 
  8031f0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8031f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031f7:	eb 2d                	jmp    803226 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fd:	48 8b 40 18          	mov    0x18(%rax),%rax
  803201:	48 85 c0             	test   %rax,%rax
  803204:	75 07                	jne    80320d <write+0xb9>
		return -E_NOT_SUPP;
  803206:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80320b:	eb 19                	jmp    803226 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80320d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803211:	48 8b 40 18          	mov    0x18(%rax),%rax
  803215:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803219:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80321d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803221:	48 89 cf             	mov    %rcx,%rdi
  803224:	ff d0                	callq  *%rax
}
  803226:	c9                   	leaveq 
  803227:	c3                   	retq   

0000000000803228 <seek>:

int
seek(int fdnum, off_t offset)
{
  803228:	55                   	push   %rbp
  803229:	48 89 e5             	mov    %rsp,%rbp
  80322c:	48 83 ec 18          	sub    $0x18,%rsp
  803230:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803233:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803236:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80323a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80323d:	48 89 d6             	mov    %rdx,%rsi
  803240:	89 c7                	mov    %eax,%edi
  803242:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
  80324e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803255:	79 05                	jns    80325c <seek+0x34>
		return r;
  803257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325a:	eb 0f                	jmp    80326b <seek+0x43>
	fd->fd_offset = offset;
  80325c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803260:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803263:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326b:	c9                   	leaveq 
  80326c:	c3                   	retq   

000000000080326d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80326d:	55                   	push   %rbp
  80326e:	48 89 e5             	mov    %rsp,%rbp
  803271:	48 83 ec 30          	sub    $0x30,%rsp
  803275:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803278:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80327b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80327f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803282:	48 89 d6             	mov    %rdx,%rsi
  803285:	89 c7                	mov    %eax,%edi
  803287:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803296:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329a:	78 24                	js     8032c0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80329c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a0:	8b 00                	mov    (%rax),%eax
  8032a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032a6:	48 89 d6             	mov    %rdx,%rsi
  8032a9:	89 c7                	mov    %eax,%edi
  8032ab:	48 b8 2f 2d 80 00 00 	movabs $0x802d2f,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
  8032b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032be:	79 05                	jns    8032c5 <ftruncate+0x58>
		return r;
  8032c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c3:	eb 72                	jmp    803337 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8032c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c9:	8b 40 08             	mov    0x8(%rax),%eax
  8032cc:	83 e0 03             	and    $0x3,%eax
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	75 3a                	jne    80330d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8032d3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8032da:	00 00 00 
  8032dd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8032e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8032e6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032e9:	89 c6                	mov    %eax,%esi
  8032eb:	48 bf 70 60 80 00 00 	movabs $0x806070,%rdi
  8032f2:	00 00 00 
  8032f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fa:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  803301:	00 00 00 
  803304:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80330b:	eb 2a                	jmp    803337 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80330d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803311:	48 8b 40 30          	mov    0x30(%rax),%rax
  803315:	48 85 c0             	test   %rax,%rax
  803318:	75 07                	jne    803321 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80331a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80331f:	eb 16                	jmp    803337 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803325:	48 8b 40 30          	mov    0x30(%rax),%rax
  803329:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80332d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803330:	89 ce                	mov    %ecx,%esi
  803332:	48 89 d7             	mov    %rdx,%rdi
  803335:	ff d0                	callq  *%rax
}
  803337:	c9                   	leaveq 
  803338:	c3                   	retq   

0000000000803339 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803339:	55                   	push   %rbp
  80333a:	48 89 e5             	mov    %rsp,%rbp
  80333d:	48 83 ec 30          	sub    $0x30,%rsp
  803341:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803344:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803348:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80334c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80334f:	48 89 d6             	mov    %rdx,%rsi
  803352:	89 c7                	mov    %eax,%edi
  803354:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  80335b:	00 00 00 
  80335e:	ff d0                	callq  *%rax
  803360:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803367:	78 24                	js     80338d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80336d:	8b 00                	mov    (%rax),%eax
  80336f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803373:	48 89 d6             	mov    %rdx,%rsi
  803376:	89 c7                	mov    %eax,%edi
  803378:	48 b8 2f 2d 80 00 00 	movabs $0x802d2f,%rax
  80337f:	00 00 00 
  803382:	ff d0                	callq  *%rax
  803384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803387:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338b:	79 05                	jns    803392 <fstat+0x59>
		return r;
  80338d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803390:	eb 5e                	jmp    8033f0 <fstat+0xb7>
	if (!dev->dev_stat)
  803392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803396:	48 8b 40 28          	mov    0x28(%rax),%rax
  80339a:	48 85 c0             	test   %rax,%rax
  80339d:	75 07                	jne    8033a6 <fstat+0x6d>
		return -E_NOT_SUPP;
  80339f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033a4:	eb 4a                	jmp    8033f0 <fstat+0xb7>
	stat->st_name[0] = 0;
  8033a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033aa:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8033ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8033b8:	00 00 00 
	stat->st_isdir = 0;
  8033bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8033c6:	00 00 00 
	stat->st_dev = dev;
  8033c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8033d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033dc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8033e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033e4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8033e8:	48 89 ce             	mov    %rcx,%rsi
  8033eb:	48 89 d7             	mov    %rdx,%rdi
  8033ee:	ff d0                	callq  *%rax
}
  8033f0:	c9                   	leaveq 
  8033f1:	c3                   	retq   

00000000008033f2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8033f2:	55                   	push   %rbp
  8033f3:	48 89 e5             	mov    %rsp,%rbp
  8033f6:	48 83 ec 20          	sub    $0x20,%rsp
  8033fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803406:	be 00 00 00 00       	mov    $0x0,%esi
  80340b:	48 89 c7             	mov    %rax,%rdi
  80340e:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  803415:	00 00 00 
  803418:	ff d0                	callq  *%rax
  80341a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803421:	79 05                	jns    803428 <stat+0x36>
		return fd;
  803423:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803426:	eb 2f                	jmp    803457 <stat+0x65>
	r = fstat(fd, stat);
  803428:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80342c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342f:	48 89 d6             	mov    %rdx,%rsi
  803432:	89 c7                	mov    %eax,%edi
  803434:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  80343b:	00 00 00 
  80343e:	ff d0                	callq  *%rax
  803440:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803446:	89 c7                	mov    %eax,%edi
  803448:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
	return r;
  803454:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803457:	c9                   	leaveq 
  803458:	c3                   	retq   

0000000000803459 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803459:	55                   	push   %rbp
  80345a:	48 89 e5             	mov    %rsp,%rbp
  80345d:	48 83 ec 10          	sub    $0x10,%rsp
  803461:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803464:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803468:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80346f:	00 00 00 
  803472:	8b 00                	mov    (%rax),%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	75 1f                	jne    803497 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803478:	bf 01 00 00 00       	mov    $0x1,%edi
  80347d:	48 b8 6b 57 80 00 00 	movabs $0x80576b,%rax
  803484:	00 00 00 
  803487:	ff d0                	callq  *%rax
  803489:	89 c2                	mov    %eax,%edx
  80348b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803492:	00 00 00 
  803495:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803497:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80349e:	00 00 00 
  8034a1:	8b 00                	mov    (%rax),%eax
  8034a3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034a6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034ab:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8034b2:	00 00 00 
  8034b5:	89 c7                	mov    %eax,%edi
  8034b7:	48 b8 d6 56 80 00 00 	movabs $0x8056d6,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8034c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8034cc:	48 89 c6             	mov    %rax,%rsi
  8034cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d4:	48 b8 15 56 80 00 00 	movabs $0x805615,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
}
  8034e0:	c9                   	leaveq 
  8034e1:	c3                   	retq   

00000000008034e2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8034e2:	55                   	push   %rbp
  8034e3:	48 89 e5             	mov    %rsp,%rbp
  8034e6:	48 83 ec 20          	sub    $0x20,%rsp
  8034ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034ee:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8034f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f5:	48 89 c7             	mov    %rax,%rdi
  8034f8:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8034ff:	00 00 00 
  803502:	ff d0                	callq  *%rax
  803504:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803509:	7e 0a                	jle    803515 <open+0x33>
		return -E_BAD_PATH;
  80350b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803510:	e9 a5 00 00 00       	jmpq   8035ba <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803515:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803519:	48 89 c7             	mov    %rax,%rdi
  80351c:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  803523:	00 00 00 
  803526:	ff d0                	callq  *%rax
  803528:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80352b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352f:	79 08                	jns    803539 <open+0x57>
		return r;
  803531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803534:	e9 81 00 00 00       	jmpq   8035ba <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353d:	48 89 c6             	mov    %rax,%rsi
  803540:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803547:	00 00 00 
  80354a:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803556:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355d:	00 00 00 
  803560:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803563:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356d:	48 89 c6             	mov    %rax,%rsi
  803570:	bf 01 00 00 00       	mov    $0x1,%edi
  803575:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  80357c:	00 00 00 
  80357f:	ff d0                	callq  *%rax
  803581:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803584:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803588:	79 1d                	jns    8035a7 <open+0xc5>
		fd_close(fd, 0);
  80358a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358e:	be 00 00 00 00       	mov    $0x0,%esi
  803593:	48 89 c7             	mov    %rax,%rdi
  803596:	48 b8 64 2c 80 00 00 	movabs $0x802c64,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
		return r;
  8035a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a5:	eb 13                	jmp    8035ba <open+0xd8>
	}

	return fd2num(fd);
  8035a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ab:	48 89 c7             	mov    %rax,%rdi
  8035ae:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax

}
  8035ba:	c9                   	leaveq 
  8035bb:	c3                   	retq   

00000000008035bc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8035bc:	55                   	push   %rbp
  8035bd:	48 89 e5             	mov    %rsp,%rbp
  8035c0:	48 83 ec 10          	sub    $0x10,%rsp
  8035c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8035c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8035cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035d6:	00 00 00 
  8035d9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8035db:	be 00 00 00 00       	mov    $0x0,%esi
  8035e0:	bf 06 00 00 00       	mov    $0x6,%edi
  8035e5:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
}
  8035f1:	c9                   	leaveq 
  8035f2:	c3                   	retq   

00000000008035f3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8035f3:	55                   	push   %rbp
  8035f4:	48 89 e5             	mov    %rsp,%rbp
  8035f7:	48 83 ec 30          	sub    $0x30,%rsp
  8035fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803603:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360b:	8b 50 0c             	mov    0xc(%rax),%edx
  80360e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803615:	00 00 00 
  803618:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80361a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803621:	00 00 00 
  803624:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803628:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80362c:	be 00 00 00 00       	mov    $0x0,%esi
  803631:	bf 03 00 00 00       	mov    $0x3,%edi
  803636:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  80363d:	00 00 00 
  803640:	ff d0                	callq  *%rax
  803642:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803645:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803649:	79 08                	jns    803653 <devfile_read+0x60>
		return r;
  80364b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364e:	e9 a4 00 00 00       	jmpq   8036f7 <devfile_read+0x104>
	assert(r <= n);
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803656:	48 98                	cltq   
  803658:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80365c:	76 35                	jbe    803693 <devfile_read+0xa0>
  80365e:	48 b9 96 60 80 00 00 	movabs $0x806096,%rcx
  803665:	00 00 00 
  803668:	48 ba 9d 60 80 00 00 	movabs $0x80609d,%rdx
  80366f:	00 00 00 
  803672:	be 86 00 00 00       	mov    $0x86,%esi
  803677:	48 bf b2 60 80 00 00 	movabs $0x8060b2,%rdi
  80367e:	00 00 00 
  803681:	b8 00 00 00 00       	mov    $0x0,%eax
  803686:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80368d:	00 00 00 
  803690:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803693:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80369a:	7e 35                	jle    8036d1 <devfile_read+0xde>
  80369c:	48 b9 bd 60 80 00 00 	movabs $0x8060bd,%rcx
  8036a3:	00 00 00 
  8036a6:	48 ba 9d 60 80 00 00 	movabs $0x80609d,%rdx
  8036ad:	00 00 00 
  8036b0:	be 87 00 00 00       	mov    $0x87,%esi
  8036b5:	48 bf b2 60 80 00 00 	movabs $0x8060b2,%rdi
  8036bc:	00 00 00 
  8036bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c4:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8036cb:	00 00 00 
  8036ce:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8036d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d4:	48 63 d0             	movslq %eax,%rdx
  8036d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036db:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8036e2:	00 00 00 
  8036e5:	48 89 c7             	mov    %rax,%rdi
  8036e8:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
	return r;
  8036f4:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8036f7:	c9                   	leaveq 
  8036f8:	c3                   	retq   

00000000008036f9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8036f9:	55                   	push   %rbp
  8036fa:	48 89 e5             	mov    %rsp,%rbp
  8036fd:	48 83 ec 40          	sub    $0x40,%rsp
  803701:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803705:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803709:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80370d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803715:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80371c:	00 
  80371d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803721:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803725:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80372a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80372e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803732:	8b 50 0c             	mov    0xc(%rax),%edx
  803735:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80373c:	00 00 00 
  80373f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803741:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803748:	00 00 00 
  80374b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80374f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803753:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803757:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375b:	48 89 c6             	mov    %rax,%rsi
  80375e:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803765:	00 00 00 
  803768:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  80376f:	00 00 00 
  803772:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803774:	be 00 00 00 00       	mov    $0x0,%esi
  803779:	bf 04 00 00 00       	mov    $0x4,%edi
  80377e:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
  80378a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80378d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803791:	79 05                	jns    803798 <devfile_write+0x9f>
		return r;
  803793:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803796:	eb 43                	jmp    8037db <devfile_write+0xe2>
	assert(r <= n);
  803798:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379b:	48 98                	cltq   
  80379d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037a1:	76 35                	jbe    8037d8 <devfile_write+0xdf>
  8037a3:	48 b9 96 60 80 00 00 	movabs $0x806096,%rcx
  8037aa:	00 00 00 
  8037ad:	48 ba 9d 60 80 00 00 	movabs $0x80609d,%rdx
  8037b4:	00 00 00 
  8037b7:	be a2 00 00 00       	mov    $0xa2,%esi
  8037bc:	48 bf b2 60 80 00 00 	movabs $0x8060b2,%rdi
  8037c3:	00 00 00 
  8037c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cb:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8037d2:	00 00 00 
  8037d5:	41 ff d0             	callq  *%r8
	return r;
  8037d8:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8037db:	c9                   	leaveq 
  8037dc:	c3                   	retq   

00000000008037dd <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8037dd:	55                   	push   %rbp
  8037de:	48 89 e5             	mov    %rsp,%rbp
  8037e1:	48 83 ec 20          	sub    $0x20,%rsp
  8037e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8037ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f1:	8b 50 0c             	mov    0xc(%rax),%edx
  8037f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fb:	00 00 00 
  8037fe:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803800:	be 00 00 00 00       	mov    $0x0,%esi
  803805:	bf 05 00 00 00       	mov    $0x5,%edi
  80380a:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
  803816:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803819:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381d:	79 05                	jns    803824 <devfile_stat+0x47>
		return r;
  80381f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803822:	eb 56                	jmp    80387a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803824:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803828:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80382f:	00 00 00 
  803832:	48 89 c7             	mov    %rax,%rdi
  803835:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803841:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803848:	00 00 00 
  80384b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803851:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803855:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80385b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803862:	00 00 00 
  803865:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80386b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80387a:	c9                   	leaveq 
  80387b:	c3                   	retq   

000000000080387c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80387c:	55                   	push   %rbp
  80387d:	48 89 e5             	mov    %rsp,%rbp
  803880:	48 83 ec 10          	sub    $0x10,%rsp
  803884:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803888:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80388b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388f:	8b 50 0c             	mov    0xc(%rax),%edx
  803892:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803899:	00 00 00 
  80389c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80389e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038a5:	00 00 00 
  8038a8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038ab:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8038ae:	be 00 00 00 00       	mov    $0x0,%esi
  8038b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8038b8:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  8038bf:	00 00 00 
  8038c2:	ff d0                	callq  *%rax
}
  8038c4:	c9                   	leaveq 
  8038c5:	c3                   	retq   

00000000008038c6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8038c6:	55                   	push   %rbp
  8038c7:	48 89 e5             	mov    %rsp,%rbp
  8038ca:	48 83 ec 10          	sub    $0x10,%rsp
  8038ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8038d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d6:	48 89 c7             	mov    %rax,%rdi
  8038d9:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
  8038e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8038ea:	7e 07                	jle    8038f3 <remove+0x2d>
		return -E_BAD_PATH;
  8038ec:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8038f1:	eb 33                	jmp    803926 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8038f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f7:	48 89 c6             	mov    %rax,%rsi
  8038fa:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803901:	00 00 00 
  803904:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803910:	be 00 00 00 00       	mov    $0x0,%esi
  803915:	bf 07 00 00 00       	mov    $0x7,%edi
  80391a:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  803921:	00 00 00 
  803924:	ff d0                	callq  *%rax
}
  803926:	c9                   	leaveq 
  803927:	c3                   	retq   

0000000000803928 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803928:	55                   	push   %rbp
  803929:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80392c:	be 00 00 00 00       	mov    $0x0,%esi
  803931:	bf 08 00 00 00       	mov    $0x8,%edi
  803936:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  80393d:	00 00 00 
  803940:	ff d0                	callq  *%rax
}
  803942:	5d                   	pop    %rbp
  803943:	c3                   	retq   

0000000000803944 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803944:	55                   	push   %rbp
  803945:	48 89 e5             	mov    %rsp,%rbp
  803948:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80394f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803956:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80395d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803964:	be 00 00 00 00       	mov    $0x0,%esi
  803969:	48 89 c7             	mov    %rax,%rdi
  80396c:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  803973:	00 00 00 
  803976:	ff d0                	callq  *%rax
  803978:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80397b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397f:	79 28                	jns    8039a9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803984:	89 c6                	mov    %eax,%esi
  803986:	48 bf c9 60 80 00 00 	movabs $0x8060c9,%rdi
  80398d:	00 00 00 
  803990:	b8 00 00 00 00       	mov    $0x0,%eax
  803995:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  80399c:	00 00 00 
  80399f:	ff d2                	callq  *%rdx
		return fd_src;
  8039a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a4:	e9 76 01 00 00       	jmpq   803b1f <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8039a9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8039b0:	be 01 01 00 00       	mov    $0x101,%esi
  8039b5:	48 89 c7             	mov    %rax,%rdi
  8039b8:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8039c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8039cb:	0f 89 ad 00 00 00    	jns    803a7e <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8039d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039d4:	89 c6                	mov    %eax,%esi
  8039d6:	48 bf df 60 80 00 00 	movabs $0x8060df,%rdi
  8039dd:	00 00 00 
  8039e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e5:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  8039ec:	00 00 00 
  8039ef:	ff d2                	callq  *%rdx
		close(fd_src);
  8039f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f4:	89 c7                	mov    %eax,%edi
  8039f6:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  8039fd:	00 00 00 
  803a00:	ff d0                	callq  *%rax
		return fd_dest;
  803a02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a05:	e9 15 01 00 00       	jmpq   803b1f <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803a0a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a0d:	48 63 d0             	movslq %eax,%rdx
  803a10:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a1a:	48 89 ce             	mov    %rcx,%rsi
  803a1d:	89 c7                	mov    %eax,%edi
  803a1f:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
  803a2b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803a32:	79 4a                	jns    803a7e <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803a34:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a37:	89 c6                	mov    %eax,%esi
  803a39:	48 bf f9 60 80 00 00 	movabs $0x8060f9,%rdi
  803a40:	00 00 00 
  803a43:	b8 00 00 00 00       	mov    $0x0,%eax
  803a48:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  803a4f:	00 00 00 
  803a52:	ff d2                	callq  *%rdx
			close(fd_src);
  803a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a57:	89 c7                	mov    %eax,%edi
  803a59:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803a60:	00 00 00 
  803a63:	ff d0                	callq  *%rax
			close(fd_dest);
  803a65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a68:	89 c7                	mov    %eax,%edi
  803a6a:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
			return write_size;
  803a76:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a79:	e9 a1 00 00 00       	jmpq   803b1f <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803a7e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a88:	ba 00 02 00 00       	mov    $0x200,%edx
  803a8d:	48 89 ce             	mov    %rcx,%rsi
  803a90:	89 c7                	mov    %eax,%edi
  803a92:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
  803a9e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803aa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803aa5:	0f 8f 5f ff ff ff    	jg     803a0a <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803aaf:	79 47                	jns    803af8 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803ab1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ab4:	89 c6                	mov    %eax,%esi
  803ab6:	48 bf 0c 61 80 00 00 	movabs $0x80610c,%rdi
  803abd:	00 00 00 
  803ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac5:	48 ba 18 0b 80 00 00 	movabs $0x800b18,%rdx
  803acc:	00 00 00 
  803acf:	ff d2                	callq  *%rdx
		close(fd_src);
  803ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad4:	89 c7                	mov    %eax,%edi
  803ad6:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803add:	00 00 00 
  803ae0:	ff d0                	callq  *%rax
		close(fd_dest);
  803ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae5:	89 c7                	mov    %eax,%edi
  803ae7:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803aee:	00 00 00 
  803af1:	ff d0                	callq  *%rax
		return read_size;
  803af3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803af6:	eb 27                	jmp    803b1f <copy+0x1db>
	}
	close(fd_src);
  803af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afb:	89 c7                	mov    %eax,%edi
  803afd:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803b04:	00 00 00 
  803b07:	ff d0                	callq  *%rax
	close(fd_dest);
  803b09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b0c:	89 c7                	mov    %eax,%edi
  803b0e:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803b15:	00 00 00 
  803b18:	ff d0                	callq  *%rax
	return 0;
  803b1a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803b1f:	c9                   	leaveq 
  803b20:	c3                   	retq   

0000000000803b21 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803b21:	55                   	push   %rbp
  803b22:	48 89 e5             	mov    %rsp,%rbp
  803b25:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  803b2c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803b33:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803b3a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803b41:	be 00 00 00 00       	mov    $0x0,%esi
  803b46:	48 89 c7             	mov    %rax,%rdi
  803b49:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
  803b55:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b58:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b5c:	79 08                	jns    803b66 <spawn+0x45>
		return r;
  803b5e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b61:	e9 11 03 00 00       	jmpq   803e77 <spawn+0x356>
	fd = r;
  803b66:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b69:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803b6c:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803b73:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803b77:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803b7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803b81:	ba 00 02 00 00       	mov    $0x200,%edx
  803b86:	48 89 ce             	mov    %rcx,%rsi
  803b89:	89 c7                	mov    %eax,%edi
  803b8b:	48 b8 de 30 80 00 00 	movabs $0x8030de,%rax
  803b92:	00 00 00 
  803b95:	ff d0                	callq  *%rax
  803b97:	3d 00 02 00 00       	cmp    $0x200,%eax
  803b9c:	75 0d                	jne    803bab <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803b9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba2:	8b 00                	mov    (%rax),%eax
  803ba4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803ba9:	74 43                	je     803bee <spawn+0xcd>
		close(fd);
  803bab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803bae:	89 c7                	mov    %eax,%edi
  803bb0:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803bb7:	00 00 00 
  803bba:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803bbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc0:	8b 00                	mov    (%rax),%eax
  803bc2:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803bc7:	89 c6                	mov    %eax,%esi
  803bc9:	48 bf 28 61 80 00 00 	movabs $0x806128,%rdi
  803bd0:	00 00 00 
  803bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd8:	48 b9 18 0b 80 00 00 	movabs $0x800b18,%rcx
  803bdf:	00 00 00 
  803be2:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803be4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803be9:	e9 89 02 00 00       	jmpq   803e77 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803bee:	b8 07 00 00 00       	mov    $0x7,%eax
  803bf3:	cd 30                	int    $0x30
  803bf5:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803bf8:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803bfb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803bfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c02:	79 08                	jns    803c0c <spawn+0xeb>
		return r;
  803c04:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c07:	e9 6b 02 00 00       	jmpq   803e77 <spawn+0x356>
	child = r;
  803c0c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c0f:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803c12:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c15:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c1a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c21:	00 00 00 
  803c24:	48 98                	cltq   
  803c26:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803c2d:	48 01 c2             	add    %rax,%rdx
  803c30:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803c37:	48 89 d6             	mov    %rdx,%rsi
  803c3a:	ba 18 00 00 00       	mov    $0x18,%edx
  803c3f:	48 89 c7             	mov    %rax,%rdi
  803c42:	48 89 d1             	mov    %rdx,%rcx
  803c45:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803c48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803c50:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803c57:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803c5e:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803c65:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803c6c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c6f:	48 89 ce             	mov    %rcx,%rsi
  803c72:	89 c7                	mov    %eax,%edi
  803c74:	48 b8 db 40 80 00 00 	movabs $0x8040db,%rax
  803c7b:	00 00 00 
  803c7e:	ff d0                	callq  *%rax
  803c80:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c83:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c87:	79 08                	jns    803c91 <spawn+0x170>
		return r;
  803c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c8c:	e9 e6 01 00 00       	jmpq   803e77 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c95:	48 8b 40 20          	mov    0x20(%rax),%rax
  803c99:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803ca0:	48 01 d0             	add    %rdx,%rax
  803ca3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cae:	e9 80 00 00 00       	jmpq   803d33 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  803cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb7:	8b 00                	mov    (%rax),%eax
  803cb9:	83 f8 01             	cmp    $0x1,%eax
  803cbc:	75 6b                	jne    803d29 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  803cbe:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc9:	8b 40 04             	mov    0x4(%rax),%eax
  803ccc:	83 e0 02             	and    $0x2,%eax
  803ccf:	85 c0                	test   %eax,%eax
  803cd1:	74 04                	je     803cd7 <spawn+0x1b6>
			perm |= PTE_W;
  803cd3:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdb:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803cdf:	41 89 c1             	mov    %eax,%r9d
  803ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce6:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cee:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf6:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803cfa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803cfd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d00:	48 83 ec 08          	sub    $0x8,%rsp
  803d04:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803d07:	57                   	push   %rdi
  803d08:	89 c7                	mov    %eax,%edi
  803d0a:	48 b8 87 43 80 00 00 	movabs $0x804387,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
  803d16:	48 83 c4 10          	add    $0x10,%rsp
  803d1a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d21:	0f 88 2a 01 00 00    	js     803e51 <spawn+0x330>
  803d27:	eb 01                	jmp    803d2a <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803d29:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803d2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d2e:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803d33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d37:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803d3b:	0f b7 c0             	movzwl %ax,%eax
  803d3e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803d41:	0f 8f 6c ff ff ff    	jg     803cb3 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803d47:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803d4a:	89 c7                	mov    %eax,%edi
  803d4c:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803d53:	00 00 00 
  803d56:	ff d0                	callq  *%rax
	fd = -1;
  803d58:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803d5f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803d62:	89 c7                	mov    %eax,%edi
  803d64:	48 b8 73 45 80 00 00 	movabs $0x804573,%rax
  803d6b:	00 00 00 
  803d6e:	ff d0                	callq  *%rax
  803d70:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803d73:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803d77:	79 30                	jns    803da9 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  803d79:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d7c:	89 c1                	mov    %eax,%ecx
  803d7e:	48 ba 42 61 80 00 00 	movabs $0x806142,%rdx
  803d85:	00 00 00 
  803d88:	be 86 00 00 00       	mov    $0x86,%esi
  803d8d:	48 bf 58 61 80 00 00 	movabs $0x806158,%rdi
  803d94:	00 00 00 
  803d97:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9c:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803da3:	00 00 00 
  803da6:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803da9:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803db0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803db3:	48 89 d6             	mov    %rdx,%rsi
  803db6:	89 c7                	mov    %eax,%edi
  803db8:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  803dbf:	00 00 00 
  803dc2:	ff d0                	callq  *%rax
  803dc4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803dc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803dcb:	79 30                	jns    803dfd <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  803dcd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dd0:	89 c1                	mov    %eax,%ecx
  803dd2:	48 ba 64 61 80 00 00 	movabs $0x806164,%rdx
  803dd9:	00 00 00 
  803ddc:	be 8a 00 00 00       	mov    $0x8a,%esi
  803de1:	48 bf 58 61 80 00 00 	movabs $0x806158,%rdi
  803de8:	00 00 00 
  803deb:	b8 00 00 00 00       	mov    $0x0,%eax
  803df0:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803df7:	00 00 00 
  803dfa:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803dfd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803e00:	be 02 00 00 00       	mov    $0x2,%esi
  803e05:	89 c7                	mov    %eax,%edi
  803e07:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
  803e13:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803e16:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803e1a:	79 30                	jns    803e4c <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  803e1c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e1f:	89 c1                	mov    %eax,%ecx
  803e21:	48 ba 7e 61 80 00 00 	movabs $0x80617e,%rdx
  803e28:	00 00 00 
  803e2b:	be 8d 00 00 00       	mov    $0x8d,%esi
  803e30:	48 bf 58 61 80 00 00 	movabs $0x806158,%rdi
  803e37:	00 00 00 
  803e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  803e46:	00 00 00 
  803e49:	41 ff d0             	callq  *%r8

	return child;
  803e4c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803e4f:	eb 26                	jmp    803e77 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803e51:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803e52:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803e55:	89 c7                	mov    %eax,%edi
  803e57:	48 b8 1f 1f 80 00 00 	movabs $0x801f1f,%rax
  803e5e:	00 00 00 
  803e61:	ff d0                	callq  *%rax
	close(fd);
  803e63:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803e66:	89 c7                	mov    %eax,%edi
  803e68:	48 b8 e6 2d 80 00 00 	movabs $0x802de6,%rax
  803e6f:	00 00 00 
  803e72:	ff d0                	callq  *%rax
	return r;
  803e74:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  803e77:	c9                   	leaveq 
  803e78:	c3                   	retq   

0000000000803e79 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803e79:	55                   	push   %rbp
  803e7a:	48 89 e5             	mov    %rsp,%rbp
  803e7d:	41 55                	push   %r13
  803e7f:	41 54                	push   %r12
  803e81:	53                   	push   %rbx
  803e82:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803e89:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803e90:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  803e97:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803e9e:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803ea5:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803eac:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803eb3:	84 c0                	test   %al,%al
  803eb5:	74 26                	je     803edd <spawnl+0x64>
  803eb7:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803ebe:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803ec5:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803ec9:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803ecd:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803ed1:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803ed5:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803ed9:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803edd:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803ee4:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803ee7:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803eee:	00 00 00 
  803ef1:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803ef8:	00 00 00 
  803efb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803eff:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803f06:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803f0d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803f14:	eb 07                	jmp    803f1d <spawnl+0xa4>
		argc++;
  803f16:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803f1d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f23:	83 f8 30             	cmp    $0x30,%eax
  803f26:	73 23                	jae    803f4b <spawnl+0xd2>
  803f28:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  803f2f:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f35:	89 d2                	mov    %edx,%edx
  803f37:	48 01 d0             	add    %rdx,%rax
  803f3a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f40:	83 c2 08             	add    $0x8,%edx
  803f43:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803f49:	eb 12                	jmp    803f5d <spawnl+0xe4>
  803f4b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f52:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803f56:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f5d:	48 8b 00             	mov    (%rax),%rax
  803f60:	48 85 c0             	test   %rax,%rax
  803f63:	75 b1                	jne    803f16 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803f65:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803f6b:	83 c0 02             	add    $0x2,%eax
  803f6e:	48 89 e2             	mov    %rsp,%rdx
  803f71:	48 89 d3             	mov    %rdx,%rbx
  803f74:	48 63 d0             	movslq %eax,%rdx
  803f77:	48 83 ea 01          	sub    $0x1,%rdx
  803f7b:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803f82:	48 63 d0             	movslq %eax,%rdx
  803f85:	49 89 d4             	mov    %rdx,%r12
  803f88:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803f8e:	48 63 d0             	movslq %eax,%rdx
  803f91:	49 89 d2             	mov    %rdx,%r10
  803f94:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803f9a:	48 98                	cltq   
  803f9c:	48 c1 e0 03          	shl    $0x3,%rax
  803fa0:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803fa4:	b8 10 00 00 00       	mov    $0x10,%eax
  803fa9:	48 83 e8 01          	sub    $0x1,%rax
  803fad:	48 01 d0             	add    %rdx,%rax
  803fb0:	be 10 00 00 00       	mov    $0x10,%esi
  803fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  803fba:	48 f7 f6             	div    %rsi
  803fbd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803fc1:	48 29 c4             	sub    %rax,%rsp
  803fc4:	48 89 e0             	mov    %rsp,%rax
  803fc7:	48 83 c0 07          	add    $0x7,%rax
  803fcb:	48 c1 e8 03          	shr    $0x3,%rax
  803fcf:	48 c1 e0 03          	shl    $0x3,%rax
  803fd3:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803fda:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803fe1:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803fe8:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803feb:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803ff1:	8d 50 01             	lea    0x1(%rax),%edx
  803ff4:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803ffb:	48 63 d2             	movslq %edx,%rdx
  803ffe:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804005:	00 

	va_start(vl, arg0);
  804006:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80400d:	00 00 00 
  804010:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804017:	00 00 00 
  80401a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80401e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804025:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80402c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804033:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80403a:	00 00 00 
  80403d:	eb 60                	jmp    80409f <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  80403f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804045:	8d 48 01             	lea    0x1(%rax),%ecx
  804048:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80404e:	83 f8 30             	cmp    $0x30,%eax
  804051:	73 23                	jae    804076 <spawnl+0x1fd>
  804053:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80405a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804060:	89 d2                	mov    %edx,%edx
  804062:	48 01 d0             	add    %rdx,%rax
  804065:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80406b:	83 c2 08             	add    $0x8,%edx
  80406e:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804074:	eb 12                	jmp    804088 <spawnl+0x20f>
  804076:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80407d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  804081:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804088:	48 8b 10             	mov    (%rax),%rdx
  80408b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804092:	89 c9                	mov    %ecx,%ecx
  804094:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804098:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80409f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8040a5:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  8040ab:	72 92                	jb     80403f <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8040ad:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8040b4:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8040bb:	48 89 d6             	mov    %rdx,%rsi
  8040be:	48 89 c7             	mov    %rax,%rdi
  8040c1:	48 b8 21 3b 80 00 00 	movabs $0x803b21,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	48 89 dc             	mov    %rbx,%rsp
}
  8040d0:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8040d4:	5b                   	pop    %rbx
  8040d5:	41 5c                	pop    %r12
  8040d7:	41 5d                	pop    %r13
  8040d9:	5d                   	pop    %rbp
  8040da:	c3                   	retq   

00000000008040db <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8040db:	55                   	push   %rbp
  8040dc:	48 89 e5             	mov    %rsp,%rbp
  8040df:	48 83 ec 50          	sub    $0x50,%rsp
  8040e3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8040e6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8040ea:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8040ee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040f5:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8040f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8040fd:	eb 33                	jmp    804132 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8040ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804102:	48 98                	cltq   
  804104:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80410b:	00 
  80410c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804110:	48 01 d0             	add    %rdx,%rax
  804113:	48 8b 00             	mov    (%rax),%rax
  804116:	48 89 c7             	mov    %rax,%rdi
  804119:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  804120:	00 00 00 
  804123:	ff d0                	callq  *%rax
  804125:	83 c0 01             	add    $0x1,%eax
  804128:	48 98                	cltq   
  80412a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80412e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804132:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804135:	48 98                	cltq   
  804137:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80413e:	00 
  80413f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804143:	48 01 d0             	add    %rdx,%rax
  804146:	48 8b 00             	mov    (%rax),%rax
  804149:	48 85 c0             	test   %rax,%rax
  80414c:	75 b1                	jne    8040ff <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80414e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804152:	48 f7 d8             	neg    %rax
  804155:	48 05 00 10 40 00    	add    $0x401000,%rax
  80415b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80415f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804163:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80416b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80416f:	48 89 c2             	mov    %rax,%rdx
  804172:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804175:	83 c0 01             	add    $0x1,%eax
  804178:	c1 e0 03             	shl    $0x3,%eax
  80417b:	48 98                	cltq   
  80417d:	48 f7 d8             	neg    %rax
  804180:	48 01 d0             	add    %rdx,%rax
  804183:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804187:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80418b:	48 83 e8 10          	sub    $0x10,%rax
  80418f:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804195:	77 0a                	ja     8041a1 <init_stack+0xc6>
		return -E_NO_MEM;
  804197:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80419c:	e9 e4 01 00 00       	jmpq   804385 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8041a1:	ba 07 00 00 00       	mov    $0x7,%edx
  8041a6:	be 00 00 40 00       	mov    $0x400000,%esi
  8041ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8041b0:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8041b7:	00 00 00 
  8041ba:	ff d0                	callq  *%rax
  8041bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041c3:	79 08                	jns    8041cd <init_stack+0xf2>
		return r;
  8041c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c8:	e9 b8 01 00 00       	jmpq   804385 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8041cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8041d4:	e9 8a 00 00 00       	jmpq   804263 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  8041d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8041dc:	48 98                	cltq   
  8041de:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8041e5:	00 
  8041e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041ea:	48 01 d0             	add    %rdx,%rax
  8041ed:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8041f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041f6:	48 01 ca             	add    %rcx,%rdx
  8041f9:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  804200:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  804203:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804206:	48 98                	cltq   
  804208:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80420f:	00 
  804210:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804214:	48 01 d0             	add    %rdx,%rax
  804217:	48 8b 10             	mov    (%rax),%rdx
  80421a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80421e:	48 89 d6             	mov    %rdx,%rsi
  804221:	48 89 c7             	mov    %rax,%rdi
  804224:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80422b:	00 00 00 
  80422e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804230:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804233:	48 98                	cltq   
  804235:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80423c:	00 
  80423d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804241:	48 01 d0             	add    %rdx,%rax
  804244:	48 8b 00             	mov    (%rax),%rax
  804247:	48 89 c7             	mov    %rax,%rdi
  80424a:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  804251:	00 00 00 
  804254:	ff d0                	callq  *%rax
  804256:	83 c0 01             	add    $0x1,%eax
  804259:	48 98                	cltq   
  80425b:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80425f:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804263:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804266:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804269:	0f 8c 6a ff ff ff    	jl     8041d9 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80426f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804272:	48 98                	cltq   
  804274:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80427b:	00 
  80427c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804280:	48 01 d0             	add    %rdx,%rax
  804283:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80428a:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804291:	00 
  804292:	74 35                	je     8042c9 <init_stack+0x1ee>
  804294:	48 b9 98 61 80 00 00 	movabs $0x806198,%rcx
  80429b:	00 00 00 
  80429e:	48 ba be 61 80 00 00 	movabs $0x8061be,%rdx
  8042a5:	00 00 00 
  8042a8:	be f6 00 00 00       	mov    $0xf6,%esi
  8042ad:	48 bf 58 61 80 00 00 	movabs $0x806158,%rdi
  8042b4:	00 00 00 
  8042b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8042bc:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  8042c3:	00 00 00 
  8042c6:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8042c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042cd:	48 83 e8 08          	sub    $0x8,%rax
  8042d1:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8042d6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8042da:	48 01 ca             	add    %rcx,%rdx
  8042dd:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8042e4:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  8042e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042eb:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8042ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042f2:	48 98                	cltq   
  8042f4:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8042f7:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8042fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804300:	48 01 d0             	add    %rdx,%rax
  804303:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804309:	48 89 c2             	mov    %rax,%rdx
  80430c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804310:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804313:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804316:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80431c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804321:	89 c2                	mov    %eax,%edx
  804323:	be 00 00 40 00       	mov    $0x400000,%esi
  804328:	bf 00 00 00 00       	mov    $0x0,%edi
  80432d:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
  804339:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80433c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804340:	78 26                	js     804368 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804342:	be 00 00 40 00       	mov    $0x400000,%esi
  804347:	bf 00 00 00 00       	mov    $0x0,%edi
  80434c:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804353:	00 00 00 
  804356:	ff d0                	callq  *%rax
  804358:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80435b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80435f:	78 0a                	js     80436b <init_stack+0x290>
		goto error;

	return 0;
  804361:	b8 00 00 00 00       	mov    $0x0,%eax
  804366:	eb 1d                	jmp    804385 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  804368:	90                   	nop
  804369:	eb 01                	jmp    80436c <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  80436b:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80436c:	be 00 00 40 00       	mov    $0x400000,%esi
  804371:	bf 00 00 00 00       	mov    $0x0,%edi
  804376:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80437d:	00 00 00 
  804380:	ff d0                	callq  *%rax
	return r;
  804382:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804385:	c9                   	leaveq 
  804386:	c3                   	retq   

0000000000804387 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804387:	55                   	push   %rbp
  804388:	48 89 e5             	mov    %rsp,%rbp
  80438b:	48 83 ec 50          	sub    $0x50,%rsp
  80438f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804392:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804396:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80439a:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80439d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8043a1:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8043a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043a9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8043ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043b5:	74 21                	je     8043d8 <map_segment+0x51>
		va -= i;
  8043b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ba:	48 98                	cltq   
  8043bc:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8043c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c3:	48 98                	cltq   
  8043c5:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8043c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043cc:	48 98                	cltq   
  8043ce:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8043d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d5:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8043d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043df:	e9 79 01 00 00       	jmpq   80455d <map_segment+0x1d6>
		if (i >= filesz) {
  8043e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e7:	48 98                	cltq   
  8043e9:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8043ed:	72 3c                	jb     80442b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8043ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f2:	48 63 d0             	movslq %eax,%rdx
  8043f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043f9:	48 01 d0             	add    %rdx,%rax
  8043fc:	48 89 c1             	mov    %rax,%rcx
  8043ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804402:	8b 55 10             	mov    0x10(%rbp),%edx
  804405:	48 89 ce             	mov    %rcx,%rsi
  804408:	89 c7                	mov    %eax,%edi
  80440a:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804411:	00 00 00 
  804414:	ff d0                	callq  *%rax
  804416:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804419:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80441d:	0f 89 33 01 00 00    	jns    804556 <map_segment+0x1cf>
				return r;
  804423:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804426:	e9 46 01 00 00       	jmpq   804571 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80442b:	ba 07 00 00 00       	mov    $0x7,%edx
  804430:	be 00 00 40 00       	mov    $0x400000,%esi
  804435:	bf 00 00 00 00       	mov    $0x0,%edi
  80443a:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804441:	00 00 00 
  804444:	ff d0                	callq  *%rax
  804446:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804449:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80444d:	79 08                	jns    804457 <map_segment+0xd0>
				return r;
  80444f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804452:	e9 1a 01 00 00       	jmpq   804571 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804457:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80445a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445d:	01 c2                	add    %eax,%edx
  80445f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804462:	89 d6                	mov    %edx,%esi
  804464:	89 c7                	mov    %eax,%edi
  804466:	48 b8 28 32 80 00 00 	movabs $0x803228,%rax
  80446d:	00 00 00 
  804470:	ff d0                	callq  *%rax
  804472:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804475:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804479:	79 08                	jns    804483 <map_segment+0xfc>
				return r;
  80447b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80447e:	e9 ee 00 00 00       	jmpq   804571 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804483:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80448a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448d:	48 98                	cltq   
  80448f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804493:	48 29 c2             	sub    %rax,%rdx
  804496:	48 89 d0             	mov    %rdx,%rax
  804499:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80449d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044a0:	48 63 d0             	movslq %eax,%rdx
  8044a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a7:	48 39 c2             	cmp    %rax,%rdx
  8044aa:	48 0f 47 d0          	cmova  %rax,%rdx
  8044ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8044b1:	be 00 00 40 00       	mov    $0x400000,%esi
  8044b6:	89 c7                	mov    %eax,%edi
  8044b8:	48 b8 de 30 80 00 00 	movabs $0x8030de,%rax
  8044bf:	00 00 00 
  8044c2:	ff d0                	callq  *%rax
  8044c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8044c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8044cb:	79 08                	jns    8044d5 <map_segment+0x14e>
				return r;
  8044cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044d0:	e9 9c 00 00 00       	jmpq   804571 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8044d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d8:	48 63 d0             	movslq %eax,%rdx
  8044db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044df:	48 01 d0             	add    %rdx,%rax
  8044e2:	48 89 c2             	mov    %rax,%rdx
  8044e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8044e8:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8044ec:	48 89 d1             	mov    %rdx,%rcx
  8044ef:	89 c2                	mov    %eax,%edx
  8044f1:	be 00 00 40 00       	mov    $0x400000,%esi
  8044f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8044fb:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804502:	00 00 00 
  804505:	ff d0                	callq  *%rax
  804507:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80450a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80450e:	79 30                	jns    804540 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804510:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804513:	89 c1                	mov    %eax,%ecx
  804515:	48 ba d3 61 80 00 00 	movabs $0x8061d3,%rdx
  80451c:	00 00 00 
  80451f:	be 29 01 00 00       	mov    $0x129,%esi
  804524:	48 bf 58 61 80 00 00 	movabs $0x806158,%rdi
  80452b:	00 00 00 
  80452e:	b8 00 00 00 00       	mov    $0x0,%eax
  804533:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  80453a:	00 00 00 
  80453d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804540:	be 00 00 40 00       	mov    $0x400000,%esi
  804545:	bf 00 00 00 00       	mov    $0x0,%edi
  80454a:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  804551:	00 00 00 
  804554:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804556:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80455d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804560:	48 98                	cltq   
  804562:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804566:	0f 82 78 fe ff ff    	jb     8043e4 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80456c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804571:	c9                   	leaveq 
  804572:	c3                   	retq   

0000000000804573 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804573:	55                   	push   %rbp
  804574:	48 89 e5             	mov    %rsp,%rbp
  804577:	48 83 ec 30          	sub    $0x30,%rsp
  80457b:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80457e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804585:	00 
  804586:	e9 eb 00 00 00       	jmpq   804676 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  80458b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80458f:	48 c1 f8 12          	sar    $0x12,%rax
  804593:	48 89 c2             	mov    %rax,%rdx
  804596:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80459d:	01 00 00 
  8045a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045a4:	83 e0 01             	and    $0x1,%eax
  8045a7:	48 85 c0             	test   %rax,%rax
  8045aa:	74 21                	je     8045cd <copy_shared_pages+0x5a>
  8045ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045b0:	48 c1 f8 09          	sar    $0x9,%rax
  8045b4:	48 89 c2             	mov    %rax,%rdx
  8045b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8045be:	01 00 00 
  8045c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045c5:	83 e0 01             	and    $0x1,%eax
  8045c8:	48 85 c0             	test   %rax,%rax
  8045cb:	75 0d                	jne    8045da <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  8045cd:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  8045d4:	00 
  8045d5:	e9 9c 00 00 00       	jmpq   804676 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  8045da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045de:	48 05 00 02 00 00    	add    $0x200,%rax
  8045e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  8045e8:	eb 7e                	jmp    804668 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  8045ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8045f1:	01 00 00 
  8045f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8045f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045fc:	25 01 04 00 00       	and    $0x401,%eax
  804601:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  804607:	75 5a                	jne    804663 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  804609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80460d:	48 c1 e0 0c          	shl    $0xc,%rax
  804611:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  804615:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80461c:	01 00 00 
  80461f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804623:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804627:	25 07 0e 00 00       	and    $0xe07,%eax
  80462c:	89 c6                	mov    %eax,%esi
  80462e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804632:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804639:	41 89 f0             	mov    %esi,%r8d
  80463c:	48 89 c6             	mov    %rax,%rsi
  80463f:	bf 00 00 00 00       	mov    $0x0,%edi
  804644:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80464b:	00 00 00 
  80464e:	ff d0                	callq  *%rax
  804650:	48 98                	cltq   
  804652:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  804656:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80465b:	79 06                	jns    804663 <copy_shared_pages+0xf0>
						return r;
  80465d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804661:	eb 28                	jmp    80468b <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  804663:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80466c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804670:	0f 8c 74 ff ff ff    	jl     8045ea <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  804676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80467a:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  804680:	0f 86 05 ff ff ff    	jbe    80458b <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  804686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80468b:	c9                   	leaveq 
  80468c:	c3                   	retq   

000000000080468d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80468d:	55                   	push   %rbp
  80468e:	48 89 e5             	mov    %rsp,%rbp
  804691:	48 83 ec 20          	sub    $0x20,%rsp
  804695:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804698:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80469c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80469f:	48 89 d6             	mov    %rdx,%rsi
  8046a2:	89 c7                	mov    %eax,%edi
  8046a4:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8046ab:	00 00 00 
  8046ae:	ff d0                	callq  *%rax
  8046b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046b7:	79 05                	jns    8046be <fd2sockid+0x31>
		return r;
  8046b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046bc:	eb 24                	jmp    8046e2 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8046be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c2:	8b 10                	mov    (%rax),%edx
  8046c4:	48 b8 c0 80 80 00 00 	movabs $0x8080c0,%rax
  8046cb:	00 00 00 
  8046ce:	8b 00                	mov    (%rax),%eax
  8046d0:	39 c2                	cmp    %eax,%edx
  8046d2:	74 07                	je     8046db <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8046d4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8046d9:	eb 07                	jmp    8046e2 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8046db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046df:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8046e2:	c9                   	leaveq 
  8046e3:	c3                   	retq   

00000000008046e4 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8046e4:	55                   	push   %rbp
  8046e5:	48 89 e5             	mov    %rsp,%rbp
  8046e8:	48 83 ec 20          	sub    $0x20,%rsp
  8046ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8046ef:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8046f3:	48 89 c7             	mov    %rax,%rdi
  8046f6:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  8046fd:	00 00 00 
  804700:	ff d0                	callq  *%rax
  804702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804709:	78 26                	js     804731 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80470b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80470f:	ba 07 04 00 00       	mov    $0x407,%edx
  804714:	48 89 c6             	mov    %rax,%rsi
  804717:	bf 00 00 00 00       	mov    $0x0,%edi
  80471c:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804723:	00 00 00 
  804726:	ff d0                	callq  *%rax
  804728:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80472b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472f:	79 16                	jns    804747 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804731:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804734:	89 c7                	mov    %eax,%edi
  804736:	48 b8 f3 4b 80 00 00 	movabs $0x804bf3,%rax
  80473d:	00 00 00 
  804740:	ff d0                	callq  *%rax
		return r;
  804742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804745:	eb 3a                	jmp    804781 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80474b:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  804752:	00 00 00 
  804755:	8b 12                	mov    (%rdx),%edx
  804757:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  804759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804768:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80476b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80476e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804772:	48 89 c7             	mov    %rax,%rdi
  804775:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
  80477c:	00 00 00 
  80477f:	ff d0                	callq  *%rax
}
  804781:	c9                   	leaveq 
  804782:	c3                   	retq   

0000000000804783 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804783:	55                   	push   %rbp
  804784:	48 89 e5             	mov    %rsp,%rbp
  804787:	48 83 ec 30          	sub    $0x30,%rsp
  80478b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80478e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804792:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804796:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804799:	89 c7                	mov    %eax,%edi
  80479b:	48 b8 8d 46 80 00 00 	movabs $0x80468d,%rax
  8047a2:	00 00 00 
  8047a5:	ff d0                	callq  *%rax
  8047a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ae:	79 05                	jns    8047b5 <accept+0x32>
		return r;
  8047b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b3:	eb 3b                	jmp    8047f0 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8047b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8047b9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8047bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047c0:	48 89 ce             	mov    %rcx,%rsi
  8047c3:	89 c7                	mov    %eax,%edi
  8047c5:	48 b8 d0 4a 80 00 00 	movabs $0x804ad0,%rax
  8047cc:	00 00 00 
  8047cf:	ff d0                	callq  *%rax
  8047d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d8:	79 05                	jns    8047df <accept+0x5c>
		return r;
  8047da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047dd:	eb 11                	jmp    8047f0 <accept+0x6d>
	return alloc_sockfd(r);
  8047df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047e2:	89 c7                	mov    %eax,%edi
  8047e4:	48 b8 e4 46 80 00 00 	movabs $0x8046e4,%rax
  8047eb:	00 00 00 
  8047ee:	ff d0                	callq  *%rax
}
  8047f0:	c9                   	leaveq 
  8047f1:	c3                   	retq   

00000000008047f2 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8047f2:	55                   	push   %rbp
  8047f3:	48 89 e5             	mov    %rsp,%rbp
  8047f6:	48 83 ec 20          	sub    $0x20,%rsp
  8047fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804801:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804804:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804807:	89 c7                	mov    %eax,%edi
  804809:	48 b8 8d 46 80 00 00 	movabs $0x80468d,%rax
  804810:	00 00 00 
  804813:	ff d0                	callq  *%rax
  804815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80481c:	79 05                	jns    804823 <bind+0x31>
		return r;
  80481e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804821:	eb 1b                	jmp    80483e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804823:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804826:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80482a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482d:	48 89 ce             	mov    %rcx,%rsi
  804830:	89 c7                	mov    %eax,%edi
  804832:	48 b8 4f 4b 80 00 00 	movabs $0x804b4f,%rax
  804839:	00 00 00 
  80483c:	ff d0                	callq  *%rax
}
  80483e:	c9                   	leaveq 
  80483f:	c3                   	retq   

0000000000804840 <shutdown>:

int
shutdown(int s, int how)
{
  804840:	55                   	push   %rbp
  804841:	48 89 e5             	mov    %rsp,%rbp
  804844:	48 83 ec 20          	sub    $0x20,%rsp
  804848:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80484b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80484e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804851:	89 c7                	mov    %eax,%edi
  804853:	48 b8 8d 46 80 00 00 	movabs $0x80468d,%rax
  80485a:	00 00 00 
  80485d:	ff d0                	callq  *%rax
  80485f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804862:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804866:	79 05                	jns    80486d <shutdown+0x2d>
		return r;
  804868:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80486b:	eb 16                	jmp    804883 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80486d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804873:	89 d6                	mov    %edx,%esi
  804875:	89 c7                	mov    %eax,%edi
  804877:	48 b8 b3 4b 80 00 00 	movabs $0x804bb3,%rax
  80487e:	00 00 00 
  804881:	ff d0                	callq  *%rax
}
  804883:	c9                   	leaveq 
  804884:	c3                   	retq   

0000000000804885 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804885:	55                   	push   %rbp
  804886:	48 89 e5             	mov    %rsp,%rbp
  804889:	48 83 ec 10          	sub    $0x10,%rsp
  80488d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804895:	48 89 c7             	mov    %rax,%rdi
  804898:	48 b8 dc 57 80 00 00 	movabs $0x8057dc,%rax
  80489f:	00 00 00 
  8048a2:	ff d0                	callq  *%rax
  8048a4:	83 f8 01             	cmp    $0x1,%eax
  8048a7:	75 17                	jne    8048c0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8048a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048ad:	8b 40 0c             	mov    0xc(%rax),%eax
  8048b0:	89 c7                	mov    %eax,%edi
  8048b2:	48 b8 f3 4b 80 00 00 	movabs $0x804bf3,%rax
  8048b9:	00 00 00 
  8048bc:	ff d0                	callq  *%rax
  8048be:	eb 05                	jmp    8048c5 <devsock_close+0x40>
	else
		return 0;
  8048c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048c5:	c9                   	leaveq 
  8048c6:	c3                   	retq   

00000000008048c7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8048c7:	55                   	push   %rbp
  8048c8:	48 89 e5             	mov    %rsp,%rbp
  8048cb:	48 83 ec 20          	sub    $0x20,%rsp
  8048cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048d6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8048d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048dc:	89 c7                	mov    %eax,%edi
  8048de:	48 b8 8d 46 80 00 00 	movabs $0x80468d,%rax
  8048e5:	00 00 00 
  8048e8:	ff d0                	callq  *%rax
  8048ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048f1:	79 05                	jns    8048f8 <connect+0x31>
		return r;
  8048f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f6:	eb 1b                	jmp    804913 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8048f8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8048fb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8048ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804902:	48 89 ce             	mov    %rcx,%rsi
  804905:	89 c7                	mov    %eax,%edi
  804907:	48 b8 20 4c 80 00 00 	movabs $0x804c20,%rax
  80490e:	00 00 00 
  804911:	ff d0                	callq  *%rax
}
  804913:	c9                   	leaveq 
  804914:	c3                   	retq   

0000000000804915 <listen>:

int
listen(int s, int backlog)
{
  804915:	55                   	push   %rbp
  804916:	48 89 e5             	mov    %rsp,%rbp
  804919:	48 83 ec 20          	sub    $0x20,%rsp
  80491d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804920:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804923:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804926:	89 c7                	mov    %eax,%edi
  804928:	48 b8 8d 46 80 00 00 	movabs $0x80468d,%rax
  80492f:	00 00 00 
  804932:	ff d0                	callq  *%rax
  804934:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804937:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80493b:	79 05                	jns    804942 <listen+0x2d>
		return r;
  80493d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804940:	eb 16                	jmp    804958 <listen+0x43>
	return nsipc_listen(r, backlog);
  804942:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804945:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804948:	89 d6                	mov    %edx,%esi
  80494a:	89 c7                	mov    %eax,%edi
  80494c:	48 b8 84 4c 80 00 00 	movabs $0x804c84,%rax
  804953:	00 00 00 
  804956:	ff d0                	callq  *%rax
}
  804958:	c9                   	leaveq 
  804959:	c3                   	retq   

000000000080495a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80495a:	55                   	push   %rbp
  80495b:	48 89 e5             	mov    %rsp,%rbp
  80495e:	48 83 ec 20          	sub    $0x20,%rsp
  804962:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804966:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80496a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80496e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804972:	89 c2                	mov    %eax,%edx
  804974:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804978:	8b 40 0c             	mov    0xc(%rax),%eax
  80497b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80497f:	b9 00 00 00 00       	mov    $0x0,%ecx
  804984:	89 c7                	mov    %eax,%edi
  804986:	48 b8 c4 4c 80 00 00 	movabs $0x804cc4,%rax
  80498d:	00 00 00 
  804990:	ff d0                	callq  *%rax
}
  804992:	c9                   	leaveq 
  804993:	c3                   	retq   

0000000000804994 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804994:	55                   	push   %rbp
  804995:	48 89 e5             	mov    %rsp,%rbp
  804998:	48 83 ec 20          	sub    $0x20,%rsp
  80499c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8049a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8049a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8049a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049ac:	89 c2                	mov    %eax,%edx
  8049ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049b2:	8b 40 0c             	mov    0xc(%rax),%eax
  8049b5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8049b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8049be:	89 c7                	mov    %eax,%edi
  8049c0:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  8049c7:	00 00 00 
  8049ca:	ff d0                	callq  *%rax
}
  8049cc:	c9                   	leaveq 
  8049cd:	c3                   	retq   

00000000008049ce <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8049ce:	55                   	push   %rbp
  8049cf:	48 89 e5             	mov    %rsp,%rbp
  8049d2:	48 83 ec 10          	sub    $0x10,%rsp
  8049d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8049da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8049de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049e2:	48 be f5 61 80 00 00 	movabs $0x8061f5,%rsi
  8049e9:	00 00 00 
  8049ec:	48 89 c7             	mov    %rax,%rdi
  8049ef:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  8049f6:	00 00 00 
  8049f9:	ff d0                	callq  *%rax
	return 0;
  8049fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a00:	c9                   	leaveq 
  804a01:	c3                   	retq   

0000000000804a02 <socket>:

int
socket(int domain, int type, int protocol)
{
  804a02:	55                   	push   %rbp
  804a03:	48 89 e5             	mov    %rsp,%rbp
  804a06:	48 83 ec 20          	sub    $0x20,%rsp
  804a0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804a0d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804a10:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804a13:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804a16:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804a19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a1c:	89 ce                	mov    %ecx,%esi
  804a1e:	89 c7                	mov    %eax,%edi
  804a20:	48 b8 48 4e 80 00 00 	movabs $0x804e48,%rax
  804a27:	00 00 00 
  804a2a:	ff d0                	callq  *%rax
  804a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a33:	79 05                	jns    804a3a <socket+0x38>
		return r;
  804a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a38:	eb 11                	jmp    804a4b <socket+0x49>
	return alloc_sockfd(r);
  804a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a3d:	89 c7                	mov    %eax,%edi
  804a3f:	48 b8 e4 46 80 00 00 	movabs $0x8046e4,%rax
  804a46:	00 00 00 
  804a49:	ff d0                	callq  *%rax
}
  804a4b:	c9                   	leaveq 
  804a4c:	c3                   	retq   

0000000000804a4d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804a4d:	55                   	push   %rbp
  804a4e:	48 89 e5             	mov    %rsp,%rbp
  804a51:	48 83 ec 10          	sub    $0x10,%rsp
  804a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804a58:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804a5f:	00 00 00 
  804a62:	8b 00                	mov    (%rax),%eax
  804a64:	85 c0                	test   %eax,%eax
  804a66:	75 1f                	jne    804a87 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804a68:	bf 02 00 00 00       	mov    $0x2,%edi
  804a6d:	48 b8 6b 57 80 00 00 	movabs $0x80576b,%rax
  804a74:	00 00 00 
  804a77:	ff d0                	callq  *%rax
  804a79:	89 c2                	mov    %eax,%edx
  804a7b:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804a82:	00 00 00 
  804a85:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804a87:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804a8e:	00 00 00 
  804a91:	8b 00                	mov    (%rax),%eax
  804a93:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804a96:	b9 07 00 00 00       	mov    $0x7,%ecx
  804a9b:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804aa2:	00 00 00 
  804aa5:	89 c7                	mov    %eax,%edi
  804aa7:	48 b8 d6 56 80 00 00 	movabs $0x8056d6,%rax
  804aae:	00 00 00 
  804ab1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  804ab8:	be 00 00 00 00       	mov    $0x0,%esi
  804abd:	bf 00 00 00 00       	mov    $0x0,%edi
  804ac2:	48 b8 15 56 80 00 00 	movabs $0x805615,%rax
  804ac9:	00 00 00 
  804acc:	ff d0                	callq  *%rax
}
  804ace:	c9                   	leaveq 
  804acf:	c3                   	retq   

0000000000804ad0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804ad0:	55                   	push   %rbp
  804ad1:	48 89 e5             	mov    %rsp,%rbp
  804ad4:	48 83 ec 30          	sub    $0x30,%rsp
  804ad8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804adb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804adf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804ae3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804aea:	00 00 00 
  804aed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804af0:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804af2:	bf 01 00 00 00       	mov    $0x1,%edi
  804af7:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804afe:	00 00 00 
  804b01:	ff d0                	callq  *%rax
  804b03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b0a:	78 3e                	js     804b4a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804b0c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b13:	00 00 00 
  804b16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804b1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b1e:	8b 40 10             	mov    0x10(%rax),%eax
  804b21:	89 c2                	mov    %eax,%edx
  804b23:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b2b:	48 89 ce             	mov    %rcx,%rsi
  804b2e:	48 89 c7             	mov    %rax,%rdi
  804b31:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804b38:	00 00 00 
  804b3b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b41:	8b 50 10             	mov    0x10(%rax),%edx
  804b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b48:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804b4d:	c9                   	leaveq 
  804b4e:	c3                   	retq   

0000000000804b4f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804b4f:	55                   	push   %rbp
  804b50:	48 89 e5             	mov    %rsp,%rbp
  804b53:	48 83 ec 10          	sub    $0x10,%rsp
  804b57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b5e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804b61:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b68:	00 00 00 
  804b6b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b6e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804b70:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b77:	48 89 c6             	mov    %rax,%rsi
  804b7a:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804b81:	00 00 00 
  804b84:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804b8b:	00 00 00 
  804b8e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804b90:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b97:	00 00 00 
  804b9a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b9d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804ba0:	bf 02 00 00 00       	mov    $0x2,%edi
  804ba5:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804bac:	00 00 00 
  804baf:	ff d0                	callq  *%rax
}
  804bb1:	c9                   	leaveq 
  804bb2:	c3                   	retq   

0000000000804bb3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804bb3:	55                   	push   %rbp
  804bb4:	48 89 e5             	mov    %rsp,%rbp
  804bb7:	48 83 ec 10          	sub    $0x10,%rsp
  804bbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804bbe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804bc1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bc8:	00 00 00 
  804bcb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804bce:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804bd0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bd7:	00 00 00 
  804bda:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804bdd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804be0:	bf 03 00 00 00       	mov    $0x3,%edi
  804be5:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804bec:	00 00 00 
  804bef:	ff d0                	callq  *%rax
}
  804bf1:	c9                   	leaveq 
  804bf2:	c3                   	retq   

0000000000804bf3 <nsipc_close>:

int
nsipc_close(int s)
{
  804bf3:	55                   	push   %rbp
  804bf4:	48 89 e5             	mov    %rsp,%rbp
  804bf7:	48 83 ec 10          	sub    $0x10,%rsp
  804bfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804bfe:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c05:	00 00 00 
  804c08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804c0b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804c0d:	bf 04 00 00 00       	mov    $0x4,%edi
  804c12:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804c19:	00 00 00 
  804c1c:	ff d0                	callq  *%rax
}
  804c1e:	c9                   	leaveq 
  804c1f:	c3                   	retq   

0000000000804c20 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804c20:	55                   	push   %rbp
  804c21:	48 89 e5             	mov    %rsp,%rbp
  804c24:	48 83 ec 10          	sub    $0x10,%rsp
  804c28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804c32:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c39:	00 00 00 
  804c3c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804c3f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804c41:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c48:	48 89 c6             	mov    %rax,%rsi
  804c4b:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804c52:	00 00 00 
  804c55:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804c5c:	00 00 00 
  804c5f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804c61:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c68:	00 00 00 
  804c6b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804c6e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804c71:	bf 05 00 00 00       	mov    $0x5,%edi
  804c76:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804c7d:	00 00 00 
  804c80:	ff d0                	callq  *%rax
}
  804c82:	c9                   	leaveq 
  804c83:	c3                   	retq   

0000000000804c84 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804c84:	55                   	push   %rbp
  804c85:	48 89 e5             	mov    %rsp,%rbp
  804c88:	48 83 ec 10          	sub    $0x10,%rsp
  804c8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c8f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804c92:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c99:	00 00 00 
  804c9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804c9f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804ca1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ca8:	00 00 00 
  804cab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804cae:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804cb1:	bf 06 00 00 00       	mov    $0x6,%edi
  804cb6:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804cbd:	00 00 00 
  804cc0:	ff d0                	callq  *%rax
}
  804cc2:	c9                   	leaveq 
  804cc3:	c3                   	retq   

0000000000804cc4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804cc4:	55                   	push   %rbp
  804cc5:	48 89 e5             	mov    %rsp,%rbp
  804cc8:	48 83 ec 30          	sub    $0x30,%rsp
  804ccc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804ccf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804cd3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804cd6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804cd9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ce0:	00 00 00 
  804ce3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804ce6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804ce8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cef:	00 00 00 
  804cf2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804cf5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804cf8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cff:	00 00 00 
  804d02:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804d05:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804d08:	bf 07 00 00 00       	mov    $0x7,%edi
  804d0d:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804d14:	00 00 00 
  804d17:	ff d0                	callq  *%rax
  804d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d20:	78 69                	js     804d8b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804d22:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804d29:	7f 08                	jg     804d33 <nsipc_recv+0x6f>
  804d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d2e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804d31:	7e 35                	jle    804d68 <nsipc_recv+0xa4>
  804d33:	48 b9 fc 61 80 00 00 	movabs $0x8061fc,%rcx
  804d3a:	00 00 00 
  804d3d:	48 ba 11 62 80 00 00 	movabs $0x806211,%rdx
  804d44:	00 00 00 
  804d47:	be 62 00 00 00       	mov    $0x62,%esi
  804d4c:	48 bf 26 62 80 00 00 	movabs $0x806226,%rdi
  804d53:	00 00 00 
  804d56:	b8 00 00 00 00       	mov    $0x0,%eax
  804d5b:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  804d62:	00 00 00 
  804d65:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d6b:	48 63 d0             	movslq %eax,%rdx
  804d6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d72:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804d79:	00 00 00 
  804d7c:	48 89 c7             	mov    %rax,%rdi
  804d7f:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804d86:	00 00 00 
  804d89:	ff d0                	callq  *%rax
	}

	return r;
  804d8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804d8e:	c9                   	leaveq 
  804d8f:	c3                   	retq   

0000000000804d90 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804d90:	55                   	push   %rbp
  804d91:	48 89 e5             	mov    %rsp,%rbp
  804d94:	48 83 ec 20          	sub    $0x20,%rsp
  804d98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804d9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804da2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804da5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804dac:	00 00 00 
  804daf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804db2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804db4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804dbb:	7e 35                	jle    804df2 <nsipc_send+0x62>
  804dbd:	48 b9 32 62 80 00 00 	movabs $0x806232,%rcx
  804dc4:	00 00 00 
  804dc7:	48 ba 11 62 80 00 00 	movabs $0x806211,%rdx
  804dce:	00 00 00 
  804dd1:	be 6d 00 00 00       	mov    $0x6d,%esi
  804dd6:	48 bf 26 62 80 00 00 	movabs $0x806226,%rdi
  804ddd:	00 00 00 
  804de0:	b8 00 00 00 00       	mov    $0x0,%eax
  804de5:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  804dec:	00 00 00 
  804def:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804df2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804df5:	48 63 d0             	movslq %eax,%rdx
  804df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dfc:	48 89 c6             	mov    %rax,%rsi
  804dff:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804e06:	00 00 00 
  804e09:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  804e10:	00 00 00 
  804e13:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804e15:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804e1c:	00 00 00 
  804e1f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804e22:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804e25:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804e2c:	00 00 00 
  804e2f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804e32:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804e35:	bf 08 00 00 00       	mov    $0x8,%edi
  804e3a:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804e41:	00 00 00 
  804e44:	ff d0                	callq  *%rax
}
  804e46:	c9                   	leaveq 
  804e47:	c3                   	retq   

0000000000804e48 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804e48:	55                   	push   %rbp
  804e49:	48 89 e5             	mov    %rsp,%rbp
  804e4c:	48 83 ec 10          	sub    $0x10,%rsp
  804e50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e53:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804e56:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804e59:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804e60:	00 00 00 
  804e63:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804e66:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804e68:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804e6f:	00 00 00 
  804e72:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804e75:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804e78:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804e7f:	00 00 00 
  804e82:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804e85:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804e88:	bf 09 00 00 00       	mov    $0x9,%edi
  804e8d:	48 b8 4d 4a 80 00 00 	movabs $0x804a4d,%rax
  804e94:	00 00 00 
  804e97:	ff d0                	callq  *%rax
}
  804e99:	c9                   	leaveq 
  804e9a:	c3                   	retq   

0000000000804e9b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804e9b:	55                   	push   %rbp
  804e9c:	48 89 e5             	mov    %rsp,%rbp
  804e9f:	53                   	push   %rbx
  804ea0:	48 83 ec 38          	sub    $0x38,%rsp
  804ea4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804ea8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804eac:	48 89 c7             	mov    %rax,%rdi
  804eaf:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  804eb6:	00 00 00 
  804eb9:	ff d0                	callq  *%rax
  804ebb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ebe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ec2:	0f 88 bf 01 00 00    	js     805087 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804ec8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ecc:	ba 07 04 00 00       	mov    $0x407,%edx
  804ed1:	48 89 c6             	mov    %rax,%rsi
  804ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  804ed9:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804ee0:	00 00 00 
  804ee3:	ff d0                	callq  *%rax
  804ee5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ee8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804eec:	0f 88 95 01 00 00    	js     805087 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804ef2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804ef6:	48 89 c7             	mov    %rax,%rdi
  804ef9:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  804f00:	00 00 00 
  804f03:	ff d0                	callq  *%rax
  804f05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f0c:	0f 88 5d 01 00 00    	js     80506f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804f12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f16:	ba 07 04 00 00       	mov    $0x407,%edx
  804f1b:	48 89 c6             	mov    %rax,%rsi
  804f1e:	bf 00 00 00 00       	mov    $0x0,%edi
  804f23:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804f2a:	00 00 00 
  804f2d:	ff d0                	callq  *%rax
  804f2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f32:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f36:	0f 88 33 01 00 00    	js     80506f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f40:	48 89 c7             	mov    %rax,%rdi
  804f43:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  804f4a:	00 00 00 
  804f4d:	ff d0                	callq  *%rax
  804f4f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804f53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804f57:	ba 07 04 00 00       	mov    $0x407,%edx
  804f5c:	48 89 c6             	mov    %rax,%rsi
  804f5f:	bf 00 00 00 00       	mov    $0x0,%edi
  804f64:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  804f6b:	00 00 00 
  804f6e:	ff d0                	callq  *%rax
  804f70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f77:	0f 88 d9 00 00 00    	js     805056 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f81:	48 89 c7             	mov    %rax,%rdi
  804f84:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  804f8b:	00 00 00 
  804f8e:	ff d0                	callq  *%rax
  804f90:	48 89 c2             	mov    %rax,%rdx
  804f93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804f97:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804f9d:	48 89 d1             	mov    %rdx,%rcx
  804fa0:	ba 00 00 00 00       	mov    $0x0,%edx
  804fa5:	48 89 c6             	mov    %rax,%rsi
  804fa8:	bf 00 00 00 00       	mov    $0x0,%edi
  804fad:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804fb4:	00 00 00 
  804fb7:	ff d0                	callq  *%rax
  804fb9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804fbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fc0:	78 79                	js     80503b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804fc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fc6:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804fcd:	00 00 00 
  804fd0:	8b 12                	mov    (%rdx),%edx
  804fd2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804fdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fe3:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804fea:	00 00 00 
  804fed:	8b 12                	mov    (%rdx),%edx
  804fef:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804ff1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ff5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804ffc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805000:	48 89 c7             	mov    %rax,%rdi
  805003:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
  80500a:	00 00 00 
  80500d:	ff d0                	callq  *%rax
  80500f:	89 c2                	mov    %eax,%edx
  805011:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805015:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805017:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80501b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80501f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805023:	48 89 c7             	mov    %rax,%rdi
  805026:	48 b8 ee 2a 80 00 00 	movabs $0x802aee,%rax
  80502d:	00 00 00 
  805030:	ff d0                	callq  *%rax
  805032:	89 03                	mov    %eax,(%rbx)
	return 0;
  805034:	b8 00 00 00 00       	mov    $0x0,%eax
  805039:	eb 4f                	jmp    80508a <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80503b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80503c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805040:	48 89 c6             	mov    %rax,%rsi
  805043:	bf 00 00 00 00       	mov    $0x0,%edi
  805048:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80504f:	00 00 00 
  805052:	ff d0                	callq  *%rax
  805054:	eb 01                	jmp    805057 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  805056:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805057:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80505b:	48 89 c6             	mov    %rax,%rsi
  80505e:	bf 00 00 00 00       	mov    $0x0,%edi
  805063:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80506a:	00 00 00 
  80506d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80506f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805073:	48 89 c6             	mov    %rax,%rsi
  805076:	bf 00 00 00 00       	mov    $0x0,%edi
  80507b:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  805082:	00 00 00 
  805085:	ff d0                	callq  *%rax
err:
	return r;
  805087:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80508a:	48 83 c4 38          	add    $0x38,%rsp
  80508e:	5b                   	pop    %rbx
  80508f:	5d                   	pop    %rbp
  805090:	c3                   	retq   

0000000000805091 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805091:	55                   	push   %rbp
  805092:	48 89 e5             	mov    %rsp,%rbp
  805095:	53                   	push   %rbx
  805096:	48 83 ec 28          	sub    $0x28,%rsp
  80509a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80509e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8050a2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8050a9:	00 00 00 
  8050ac:	48 8b 00             	mov    (%rax),%rax
  8050af:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8050b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8050b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050bc:	48 89 c7             	mov    %rax,%rdi
  8050bf:	48 b8 dc 57 80 00 00 	movabs $0x8057dc,%rax
  8050c6:	00 00 00 
  8050c9:	ff d0                	callq  *%rax
  8050cb:	89 c3                	mov    %eax,%ebx
  8050cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8050d1:	48 89 c7             	mov    %rax,%rdi
  8050d4:	48 b8 dc 57 80 00 00 	movabs $0x8057dc,%rax
  8050db:	00 00 00 
  8050de:	ff d0                	callq  *%rax
  8050e0:	39 c3                	cmp    %eax,%ebx
  8050e2:	0f 94 c0             	sete   %al
  8050e5:	0f b6 c0             	movzbl %al,%eax
  8050e8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8050eb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8050f2:	00 00 00 
  8050f5:	48 8b 00             	mov    (%rax),%rax
  8050f8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8050fe:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805101:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805104:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805107:	75 05                	jne    80510e <_pipeisclosed+0x7d>
			return ret;
  805109:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80510c:	eb 4a                	jmp    805158 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80510e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805111:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805114:	74 8c                	je     8050a2 <_pipeisclosed+0x11>
  805116:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80511a:	75 86                	jne    8050a2 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80511c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  805123:	00 00 00 
  805126:	48 8b 00             	mov    (%rax),%rax
  805129:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80512f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805132:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805135:	89 c6                	mov    %eax,%esi
  805137:	48 bf 43 62 80 00 00 	movabs $0x806243,%rdi
  80513e:	00 00 00 
  805141:	b8 00 00 00 00       	mov    $0x0,%eax
  805146:	49 b8 18 0b 80 00 00 	movabs $0x800b18,%r8
  80514d:	00 00 00 
  805150:	41 ff d0             	callq  *%r8
	}
  805153:	e9 4a ff ff ff       	jmpq   8050a2 <_pipeisclosed+0x11>

}
  805158:	48 83 c4 28          	add    $0x28,%rsp
  80515c:	5b                   	pop    %rbx
  80515d:	5d                   	pop    %rbp
  80515e:	c3                   	retq   

000000000080515f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80515f:	55                   	push   %rbp
  805160:	48 89 e5             	mov    %rsp,%rbp
  805163:	48 83 ec 30          	sub    $0x30,%rsp
  805167:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80516a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80516e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805171:	48 89 d6             	mov    %rdx,%rsi
  805174:	89 c7                	mov    %eax,%edi
  805176:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  80517d:	00 00 00 
  805180:	ff d0                	callq  *%rax
  805182:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805189:	79 05                	jns    805190 <pipeisclosed+0x31>
		return r;
  80518b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80518e:	eb 31                	jmp    8051c1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805194:	48 89 c7             	mov    %rax,%rdi
  805197:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  80519e:	00 00 00 
  8051a1:	ff d0                	callq  *%rax
  8051a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8051a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8051af:	48 89 d6             	mov    %rdx,%rsi
  8051b2:	48 89 c7             	mov    %rax,%rdi
  8051b5:	48 b8 91 50 80 00 00 	movabs $0x805091,%rax
  8051bc:	00 00 00 
  8051bf:	ff d0                	callq  *%rax
}
  8051c1:	c9                   	leaveq 
  8051c2:	c3                   	retq   

00000000008051c3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8051c3:	55                   	push   %rbp
  8051c4:	48 89 e5             	mov    %rsp,%rbp
  8051c7:	48 83 ec 40          	sub    $0x40,%rsp
  8051cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8051cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8051d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8051d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051db:	48 89 c7             	mov    %rax,%rdi
  8051de:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  8051e5:	00 00 00 
  8051e8:	ff d0                	callq  *%rax
  8051ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8051ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8051f6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051fd:	00 
  8051fe:	e9 90 00 00 00       	jmpq   805293 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  805203:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805208:	74 09                	je     805213 <devpipe_read+0x50>
				return i;
  80520a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80520e:	e9 8e 00 00 00       	jmpq   8052a1 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805217:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80521b:	48 89 d6             	mov    %rdx,%rsi
  80521e:	48 89 c7             	mov    %rax,%rdi
  805221:	48 b8 91 50 80 00 00 	movabs $0x805091,%rax
  805228:	00 00 00 
  80522b:	ff d0                	callq  *%rax
  80522d:	85 c0                	test   %eax,%eax
  80522f:	74 07                	je     805238 <devpipe_read+0x75>
				return 0;
  805231:	b8 00 00 00 00       	mov    $0x0,%eax
  805236:	eb 69                	jmp    8052a1 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805238:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  80523f:	00 00 00 
  805242:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805248:	8b 10                	mov    (%rax),%edx
  80524a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80524e:	8b 40 04             	mov    0x4(%rax),%eax
  805251:	39 c2                	cmp    %eax,%edx
  805253:	74 ae                	je     805203 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805255:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80525d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805265:	8b 00                	mov    (%rax),%eax
  805267:	99                   	cltd   
  805268:	c1 ea 1b             	shr    $0x1b,%edx
  80526b:	01 d0                	add    %edx,%eax
  80526d:	83 e0 1f             	and    $0x1f,%eax
  805270:	29 d0                	sub    %edx,%eax
  805272:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805276:	48 98                	cltq   
  805278:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80527d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80527f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805283:	8b 00                	mov    (%rax),%eax
  805285:	8d 50 01             	lea    0x1(%rax),%edx
  805288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80528c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80528e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805297:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80529b:	72 a7                	jb     805244 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80529d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8052a1:	c9                   	leaveq 
  8052a2:	c3                   	retq   

00000000008052a3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8052a3:	55                   	push   %rbp
  8052a4:	48 89 e5             	mov    %rsp,%rbp
  8052a7:	48 83 ec 40          	sub    $0x40,%rsp
  8052ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8052af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8052b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8052b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052bb:	48 89 c7             	mov    %rax,%rdi
  8052be:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  8052c5:	00 00 00 
  8052c8:	ff d0                	callq  *%rax
  8052ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8052ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8052d6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8052dd:	00 
  8052de:	e9 8f 00 00 00       	jmpq   805372 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8052e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8052e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052eb:	48 89 d6             	mov    %rdx,%rsi
  8052ee:	48 89 c7             	mov    %rax,%rdi
  8052f1:	48 b8 91 50 80 00 00 	movabs $0x805091,%rax
  8052f8:	00 00 00 
  8052fb:	ff d0                	callq  *%rax
  8052fd:	85 c0                	test   %eax,%eax
  8052ff:	74 07                	je     805308 <devpipe_write+0x65>
				return 0;
  805301:	b8 00 00 00 00       	mov    $0x0,%eax
  805306:	eb 78                	jmp    805380 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805308:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  80530f:	00 00 00 
  805312:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805318:	8b 40 04             	mov    0x4(%rax),%eax
  80531b:	48 63 d0             	movslq %eax,%rdx
  80531e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805322:	8b 00                	mov    (%rax),%eax
  805324:	48 98                	cltq   
  805326:	48 83 c0 20          	add    $0x20,%rax
  80532a:	48 39 c2             	cmp    %rax,%rdx
  80532d:	73 b4                	jae    8052e3 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80532f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805333:	8b 40 04             	mov    0x4(%rax),%eax
  805336:	99                   	cltd   
  805337:	c1 ea 1b             	shr    $0x1b,%edx
  80533a:	01 d0                	add    %edx,%eax
  80533c:	83 e0 1f             	and    $0x1f,%eax
  80533f:	29 d0                	sub    %edx,%eax
  805341:	89 c6                	mov    %eax,%esi
  805343:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80534b:	48 01 d0             	add    %rdx,%rax
  80534e:	0f b6 08             	movzbl (%rax),%ecx
  805351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805355:	48 63 c6             	movslq %esi,%rax
  805358:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80535c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805360:	8b 40 04             	mov    0x4(%rax),%eax
  805363:	8d 50 01             	lea    0x1(%rax),%edx
  805366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80536a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80536d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805376:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80537a:	72 98                	jb     805314 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80537c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  805380:	c9                   	leaveq 
  805381:	c3                   	retq   

0000000000805382 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805382:	55                   	push   %rbp
  805383:	48 89 e5             	mov    %rsp,%rbp
  805386:	48 83 ec 20          	sub    $0x20,%rsp
  80538a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80538e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805396:	48 89 c7             	mov    %rax,%rdi
  805399:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  8053a0:	00 00 00 
  8053a3:	ff d0                	callq  *%rax
  8053a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8053a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053ad:	48 be 56 62 80 00 00 	movabs $0x806256,%rsi
  8053b4:	00 00 00 
  8053b7:	48 89 c7             	mov    %rax,%rdi
  8053ba:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  8053c1:	00 00 00 
  8053c4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8053c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8053ca:	8b 50 04             	mov    0x4(%rax),%edx
  8053cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8053d1:	8b 00                	mov    (%rax),%eax
  8053d3:	29 c2                	sub    %eax,%edx
  8053d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053d9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8053df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053e3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8053ea:	00 00 00 
	stat->st_dev = &devpipe;
  8053ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053f1:	48 b9 00 81 80 00 00 	movabs $0x808100,%rcx
  8053f8:	00 00 00 
  8053fb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805402:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805407:	c9                   	leaveq 
  805408:	c3                   	retq   

0000000000805409 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805409:	55                   	push   %rbp
  80540a:	48 89 e5             	mov    %rsp,%rbp
  80540d:	48 83 ec 10          	sub    $0x10,%rsp
  805411:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  805415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805419:	48 89 c6             	mov    %rax,%rsi
  80541c:	bf 00 00 00 00       	mov    $0x0,%edi
  805421:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  805428:	00 00 00 
  80542b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80542d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805431:	48 89 c7             	mov    %rax,%rdi
  805434:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  80543b:	00 00 00 
  80543e:	ff d0                	callq  *%rax
  805440:	48 89 c6             	mov    %rax,%rsi
  805443:	bf 00 00 00 00       	mov    $0x0,%edi
  805448:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80544f:	00 00 00 
  805452:	ff d0                	callq  *%rax
}
  805454:	c9                   	leaveq 
  805455:	c3                   	retq   

0000000000805456 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805456:	55                   	push   %rbp
  805457:	48 89 e5             	mov    %rsp,%rbp
  80545a:	48 83 ec 20          	sub    $0x20,%rsp
  80545e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805461:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805465:	75 35                	jne    80549c <wait+0x46>
  805467:	48 b9 5d 62 80 00 00 	movabs $0x80625d,%rcx
  80546e:	00 00 00 
  805471:	48 ba 68 62 80 00 00 	movabs $0x806268,%rdx
  805478:	00 00 00 
  80547b:	be 0a 00 00 00       	mov    $0xa,%esi
  805480:	48 bf 7d 62 80 00 00 	movabs $0x80627d,%rdi
  805487:	00 00 00 
  80548a:	b8 00 00 00 00       	mov    $0x0,%eax
  80548f:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  805496:	00 00 00 
  805499:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80549c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80549f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8054a4:	48 98                	cltq   
  8054a6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8054ad:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8054b4:	00 00 00 
  8054b7:	48 01 d0             	add    %rdx,%rax
  8054ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8054be:	eb 0c                	jmp    8054cc <wait+0x76>
		sys_yield();
  8054c0:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  8054c7:	00 00 00 
  8054ca:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8054cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054d0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8054d6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8054d9:	75 0e                	jne    8054e9 <wait+0x93>
  8054db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054df:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8054e5:	85 c0                	test   %eax,%eax
  8054e7:	75 d7                	jne    8054c0 <wait+0x6a>
		sys_yield();
}
  8054e9:	90                   	nop
  8054ea:	c9                   	leaveq 
  8054eb:	c3                   	retq   

00000000008054ec <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8054ec:	55                   	push   %rbp
  8054ed:	48 89 e5             	mov    %rsp,%rbp
  8054f0:	48 83 ec 20          	sub    $0x20,%rsp
  8054f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8054f8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8054ff:	00 00 00 
  805502:	48 8b 00             	mov    (%rax),%rax
  805505:	48 85 c0             	test   %rax,%rax
  805508:	75 6f                	jne    805579 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80550a:	ba 07 00 00 00       	mov    $0x7,%edx
  80550f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805514:	bf 00 00 00 00       	mov    $0x0,%edi
  805519:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  805520:	00 00 00 
  805523:	ff d0                	callq  *%rax
  805525:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805528:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80552c:	79 30                	jns    80555e <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  80552e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805531:	89 c1                	mov    %eax,%ecx
  805533:	48 ba 88 62 80 00 00 	movabs $0x806288,%rdx
  80553a:	00 00 00 
  80553d:	be 22 00 00 00       	mov    $0x22,%esi
  805542:	48 bf a7 62 80 00 00 	movabs $0x8062a7,%rdi
  805549:	00 00 00 
  80554c:	b8 00 00 00 00       	mov    $0x0,%eax
  805551:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  805558:	00 00 00 
  80555b:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80555e:	48 be 8d 55 80 00 00 	movabs $0x80558d,%rsi
  805565:	00 00 00 
  805568:	bf 00 00 00 00       	mov    $0x0,%edi
  80556d:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  805574:	00 00 00 
  805577:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805579:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805580:	00 00 00 
  805583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805587:	48 89 10             	mov    %rdx,(%rax)
}
  80558a:	90                   	nop
  80558b:	c9                   	leaveq 
  80558c:	c3                   	retq   

000000000080558d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80558d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805590:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  805597:	00 00 00 
call *%rax
  80559a:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  80559c:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8055a3:	00 08 
    movq 152(%rsp), %rax
  8055a5:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8055ac:	00 
    movq 136(%rsp), %rbx
  8055ad:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8055b4:	00 
movq %rbx, (%rax)
  8055b5:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8055b8:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8055bc:	4c 8b 3c 24          	mov    (%rsp),%r15
  8055c0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8055c5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8055ca:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8055cf:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8055d4:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8055d9:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8055de:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8055e3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8055e8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8055ed:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8055f2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8055f7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8055fc:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805601:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805606:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80560a:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  80560e:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80560f:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  805614:	c3                   	retq   

0000000000805615 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805615:	55                   	push   %rbp
  805616:	48 89 e5             	mov    %rsp,%rbp
  805619:	48 83 ec 30          	sub    $0x30,%rsp
  80561d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805621:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805625:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  805629:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80562e:	75 0e                	jne    80563e <ipc_recv+0x29>
		pg = (void*) UTOP;
  805630:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805637:	00 00 00 
  80563a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80563e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805642:	48 89 c7             	mov    %rax,%rdi
  805645:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  80564c:	00 00 00 
  80564f:	ff d0                	callq  *%rax
  805651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805658:	79 27                	jns    805681 <ipc_recv+0x6c>
		if (from_env_store)
  80565a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80565f:	74 0a                	je     80566b <ipc_recv+0x56>
			*from_env_store = 0;
  805661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805665:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80566b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805670:	74 0a                	je     80567c <ipc_recv+0x67>
			*perm_store = 0;
  805672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805676:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80567c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80567f:	eb 53                	jmp    8056d4 <ipc_recv+0xbf>
	}
	if (from_env_store)
  805681:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805686:	74 19                	je     8056a1 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  805688:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80568f:	00 00 00 
  805692:	48 8b 00             	mov    (%rax),%rax
  805695:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80569b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80569f:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8056a1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8056a6:	74 19                	je     8056c1 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8056a8:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8056af:	00 00 00 
  8056b2:	48 8b 00             	mov    (%rax),%rax
  8056b5:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8056bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056bf:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8056c1:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8056c8:	00 00 00 
  8056cb:	48 8b 00             	mov    (%rax),%rax
  8056ce:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8056d4:	c9                   	leaveq 
  8056d5:	c3                   	retq   

00000000008056d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8056d6:	55                   	push   %rbp
  8056d7:	48 89 e5             	mov    %rsp,%rbp
  8056da:	48 83 ec 30          	sub    $0x30,%rsp
  8056de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8056e1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8056e4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8056e8:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8056eb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8056f0:	75 1c                	jne    80570e <ipc_send+0x38>
		pg = (void*) UTOP;
  8056f2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8056f9:	00 00 00 
  8056fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805700:	eb 0c                	jmp    80570e <ipc_send+0x38>
		sys_yield();
  805702:	48 b8 a1 1f 80 00 00 	movabs $0x801fa1,%rax
  805709:	00 00 00 
  80570c:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80570e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805711:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805714:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805718:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80571b:	89 c7                	mov    %eax,%edi
  80571d:	48 b8 c1 21 80 00 00 	movabs $0x8021c1,%rax
  805724:	00 00 00 
  805727:	ff d0                	callq  *%rax
  805729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80572c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805730:	74 d0                	je     805702 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  805732:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805736:	79 30                	jns    805768 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  805738:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80573b:	89 c1                	mov    %eax,%ecx
  80573d:	48 ba b5 62 80 00 00 	movabs $0x8062b5,%rdx
  805744:	00 00 00 
  805747:	be 47 00 00 00       	mov    $0x47,%esi
  80574c:	48 bf cb 62 80 00 00 	movabs $0x8062cb,%rdi
  805753:	00 00 00 
  805756:	b8 00 00 00 00       	mov    $0x0,%eax
  80575b:	49 b8 de 08 80 00 00 	movabs $0x8008de,%r8
  805762:	00 00 00 
  805765:	41 ff d0             	callq  *%r8

}
  805768:	90                   	nop
  805769:	c9                   	leaveq 
  80576a:	c3                   	retq   

000000000080576b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80576b:	55                   	push   %rbp
  80576c:	48 89 e5             	mov    %rsp,%rbp
  80576f:	48 83 ec 18          	sub    $0x18,%rsp
  805773:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805776:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80577d:	eb 4d                	jmp    8057cc <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80577f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805786:	00 00 00 
  805789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80578c:	48 98                	cltq   
  80578e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805795:	48 01 d0             	add    %rdx,%rax
  805798:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80579e:	8b 00                	mov    (%rax),%eax
  8057a0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8057a3:	75 23                	jne    8057c8 <ipc_find_env+0x5d>
			return envs[i].env_id;
  8057a5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8057ac:	00 00 00 
  8057af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057b2:	48 98                	cltq   
  8057b4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8057bb:	48 01 d0             	add    %rdx,%rax
  8057be:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8057c4:	8b 00                	mov    (%rax),%eax
  8057c6:	eb 12                	jmp    8057da <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8057c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8057cc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8057d3:	7e aa                	jle    80577f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8057d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8057da:	c9                   	leaveq 
  8057db:	c3                   	retq   

00000000008057dc <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8057dc:	55                   	push   %rbp
  8057dd:	48 89 e5             	mov    %rsp,%rbp
  8057e0:	48 83 ec 18          	sub    $0x18,%rsp
  8057e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8057e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057ec:	48 c1 e8 15          	shr    $0x15,%rax
  8057f0:	48 89 c2             	mov    %rax,%rdx
  8057f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8057fa:	01 00 00 
  8057fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805801:	83 e0 01             	and    $0x1,%eax
  805804:	48 85 c0             	test   %rax,%rax
  805807:	75 07                	jne    805810 <pageref+0x34>
		return 0;
  805809:	b8 00 00 00 00       	mov    $0x0,%eax
  80580e:	eb 56                	jmp    805866 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  805810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805814:	48 c1 e8 0c          	shr    $0xc,%rax
  805818:	48 89 c2             	mov    %rax,%rdx
  80581b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805822:	01 00 00 
  805825:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805829:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80582d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805831:	83 e0 01             	and    $0x1,%eax
  805834:	48 85 c0             	test   %rax,%rax
  805837:	75 07                	jne    805840 <pageref+0x64>
		return 0;
  805839:	b8 00 00 00 00       	mov    $0x0,%eax
  80583e:	eb 26                	jmp    805866 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  805840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805844:	48 c1 e8 0c          	shr    $0xc,%rax
  805848:	48 89 c2             	mov    %rax,%rdx
  80584b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805852:	00 00 00 
  805855:	48 c1 e2 04          	shl    $0x4,%rdx
  805859:	48 01 d0             	add    %rdx,%rax
  80585c:	48 83 c0 08          	add    $0x8,%rax
  805860:	0f b7 00             	movzwl (%rax),%eax
  805863:	0f b7 c0             	movzwl %ax,%eax
}
  805866:	c9                   	leaveq 
  805867:	c3                   	retq   
