
vmm/guest/obj/user/icode:     file format elf64-x86-64


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
  80003c:	e8 19 02 00 00       	callq  80025a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#endif


void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800062:	00 00 00 
  800065:	48 b9 00 4e 80 00 00 	movabs $0x804e00,%rcx
  80006c:	00 00 00 
  80006f:	48 89 08             	mov    %rcx,(%rax)

	cprintf("icode startup\n");
  800072:	48 bf 06 4e 80 00 00 	movabs $0x804e06,%rdi
  800079:	00 00 00 
  80007c:	b8 00 00 00 00       	mov    $0x0,%eax
  800081:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800088:	00 00 00 
  80008b:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008d:	48 bf 15 4e 80 00 00 	movabs $0x804e15,%rdi
  800094:	00 00 00 
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  8000a3:	00 00 00 
  8000a6:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a8:	be 00 00 00 00       	mov    $0x0,%esi
  8000ad:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  8000b4:	00 00 00 
  8000b7:	48 b8 f2 27 80 00 00 	movabs $0x8027f2,%rax
  8000be:	00 00 00 
  8000c1:	ff d0                	callq  *%rax
  8000c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ca:	79 30                	jns    8000fc <umain+0xb9>
		panic("icode: open /motd: %e", fd);
  8000cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000cf:	89 c1                	mov    %eax,%ecx
  8000d1:	48 ba 34 4e 80 00 00 	movabs $0x804e34,%rdx
  8000d8:	00 00 00 
  8000db:	be 18 00 00 00       	mov    $0x18,%esi
  8000e0:	48 bf 4a 4e 80 00 00 	movabs $0x804e4a,%rdi
  8000e7:	00 00 00 
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8000f6:	00 00 00 
  8000f9:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fc:	48 bf 57 4e 80 00 00 	movabs $0x804e57,%rdi
  800103:	00 00 00 
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800112:	00 00 00 
  800115:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800117:	eb 3a                	jmp    800153 <umain+0x110>
		cprintf("Writing MOTD\n");
  800119:	48 bf 6a 4e 80 00 00 	movabs $0x804e6a,%rdi
  800120:	00 00 00 
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  80012f:	00 00 00 
  800132:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800134:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800137:	48 63 d0             	movslq %eax,%rdx
  80013a:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800141:	48 89 d6             	mov    %rdx,%rsi
  800144:	48 89 c7             	mov    %rax,%rdi
  800147:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800153:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80015a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80015d:	ba 00 02 00 00       	mov    $0x200,%edx
  800162:	48 89 ce             	mov    %rcx,%rsi
  800165:	89 c7                	mov    %eax,%edi
  800167:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800176:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80017a:	7f 9d                	jg     800119 <umain+0xd6>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017c:	48 bf 78 4e 80 00 00 	movabs $0x804e78,%rdi
  800183:	00 00 00 
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800192:	00 00 00 
  800195:	ff d2                	callq  *%rdx
	close(fd);
  800197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  8001a3:	00 00 00 
  8001a6:	ff d0                	callq  *%rax


	cprintf("icode: spawn /sbin/init\n");
  8001a8:	48 bf 8c 4e 80 00 00 	movabs $0x804e8c,%rdi
  8001af:	00 00 00 
  8001b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b7:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  8001be:	00 00 00 
  8001c1:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c9:	48 b9 a5 4e 80 00 00 	movabs $0x804ea5,%rcx
  8001d0:	00 00 00 
  8001d3:	48 ba ae 4e 80 00 00 	movabs $0x804eae,%rdx
  8001da:	00 00 00 
  8001dd:	48 be b7 4e 80 00 00 	movabs $0x804eb7,%rsi
  8001e4:	00 00 00 
  8001e7:	48 bf bc 4e 80 00 00 	movabs $0x804ebc,%rdi
  8001ee:	00 00 00 
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f6:	49 b9 89 31 80 00 00 	movabs $0x803189,%r9
  8001fd:	00 00 00 
  800200:	41 ff d1             	callq  *%r9
  800203:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800206:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80020a:	79 30                	jns    80023c <umain+0x1f9>
		panic("icode: spawn /sbin/init: %e", r);
  80020c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80020f:	89 c1                	mov    %eax,%ecx
  800211:	48 ba c7 4e 80 00 00 	movabs $0x804ec7,%rdx
  800218:	00 00 00 
  80021b:	be 26 00 00 00       	mov    $0x26,%esi
  800220:	48 bf 4a 4e 80 00 00 	movabs $0x804e4a,%rdi
  800227:	00 00 00 
  80022a:	b8 00 00 00 00       	mov    $0x0,%eax
  80022f:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  800236:	00 00 00 
  800239:	41 ff d0             	callq  *%r8

	cprintf("icode: exiting\n");
  80023c:	48 bf e3 4e 80 00 00 	movabs $0x804ee3,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800252:	00 00 00 
  800255:	ff d2                	callq  *%rdx
}
  800257:	90                   	nop
  800258:	c9                   	leaveq 
  800259:	c3                   	retq   

000000000080025a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025a:	55                   	push   %rbp
  80025b:	48 89 e5             	mov    %rsp,%rbp
  80025e:	48 83 ec 10          	sub    $0x10,%rsp
  800262:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800265:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800269:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  800270:	00 00 00 
  800273:	ff d0                	callq  *%rax
  800275:	25 ff 03 00 00       	and    $0x3ff,%eax
  80027a:	48 98                	cltq   
  80027c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800283:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80028a:	00 00 00 
  80028d:	48 01 c2             	add    %rax,%rdx
  800290:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800297:	00 00 00 
  80029a:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002a1:	7e 14                	jle    8002b7 <libmain+0x5d>
		binaryname = argv[0];
  8002a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a7:	48 8b 10             	mov    (%rax),%rdx
  8002aa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002b1:	00 00 00 
  8002b4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002be:	48 89 d6             	mov    %rdx,%rsi
  8002c1:	89 c7                	mov    %eax,%edi
  8002c3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002ca:	00 00 00 
  8002cd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002cf:	48 b8 de 02 80 00 00 	movabs $0x8002de,%rax
  8002d6:	00 00 00 
  8002d9:	ff d0                	callq  *%rax
}
  8002db:	90                   	nop
  8002dc:	c9                   	leaveq 
  8002dd:	c3                   	retq   

00000000008002de <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002de:	55                   	push   %rbp
  8002df:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8002e2:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8002ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8002f3:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  8002fa:	00 00 00 
  8002fd:	ff d0                	callq  *%rax
}
  8002ff:	90                   	nop
  800300:	5d                   	pop    %rbp
  800301:	c3                   	retq   

0000000000800302 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800302:	55                   	push   %rbp
  800303:	48 89 e5             	mov    %rsp,%rbp
  800306:	53                   	push   %rbx
  800307:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80030e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800315:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80031b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800322:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800329:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800330:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800337:	84 c0                	test   %al,%al
  800339:	74 23                	je     80035e <_panic+0x5c>
  80033b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800342:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800346:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80034a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80034e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800352:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800356:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80035a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80035e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800365:	00 00 00 
  800368:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80036f:	00 00 00 
  800372:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800376:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80037d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800384:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800392:	00 00 00 
  800395:	48 8b 18             	mov    (%rax),%rbx
  800398:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
  8003a4:	89 c6                	mov    %eax,%esi
  8003a6:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8003ac:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8003b3:	41 89 d0             	mov    %edx,%r8d
  8003b6:	48 89 c1             	mov    %rax,%rcx
  8003b9:	48 89 da             	mov    %rbx,%rdx
  8003bc:	48 bf 00 4f 80 00 00 	movabs $0x804f00,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	49 b9 3c 05 80 00 00 	movabs $0x80053c,%r9
  8003d2:	00 00 00 
  8003d5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003df:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e6:	48 89 d6             	mov    %rdx,%rsi
  8003e9:	48 89 c7             	mov    %rax,%rdi
  8003ec:	48 b8 90 04 80 00 00 	movabs $0x800490,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
	cprintf("\n");
  8003f8:	48 bf 23 4f 80 00 00 	movabs $0x804f23,%rdi
  8003ff:	00 00 00 
  800402:	b8 00 00 00 00       	mov    $0x0,%eax
  800407:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  80040e:	00 00 00 
  800411:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800413:	cc                   	int3   
  800414:	eb fd                	jmp    800413 <_panic+0x111>

0000000000800416 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800416:	55                   	push   %rbp
  800417:	48 89 e5             	mov    %rsp,%rbp
  80041a:	48 83 ec 10          	sub    $0x10,%rsp
  80041e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800421:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800429:	8b 00                	mov    (%rax),%eax
  80042b:	8d 48 01             	lea    0x1(%rax),%ecx
  80042e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800432:	89 0a                	mov    %ecx,(%rdx)
  800434:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800437:	89 d1                	mov    %edx,%ecx
  800439:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043d:	48 98                	cltq   
  80043f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800447:	8b 00                	mov    (%rax),%eax
  800449:	3d ff 00 00 00       	cmp    $0xff,%eax
  80044e:	75 2c                	jne    80047c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800454:	8b 00                	mov    (%rax),%eax
  800456:	48 98                	cltq   
  800458:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80045c:	48 83 c2 08          	add    $0x8,%rdx
  800460:	48 89 c6             	mov    %rax,%rsi
  800463:	48 89 d7             	mov    %rdx,%rdi
  800466:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
        b->idx = 0;
  800472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800476:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80047c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800480:	8b 40 04             	mov    0x4(%rax),%eax
  800483:	8d 50 01             	lea    0x1(%rax),%edx
  800486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80048d:	90                   	nop
  80048e:	c9                   	leaveq 
  80048f:	c3                   	retq   

0000000000800490 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800490:	55                   	push   %rbp
  800491:	48 89 e5             	mov    %rsp,%rbp
  800494:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80049b:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004a2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004a9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004b0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004b7:	48 8b 0a             	mov    (%rdx),%rcx
  8004ba:	48 89 08             	mov    %rcx,(%rax)
  8004bd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004c1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004c5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004d4:	00 00 00 
    b.cnt = 0;
  8004d7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004de:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004e1:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004e8:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004ef:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004f6:	48 89 c6             	mov    %rax,%rsi
  8004f9:	48 bf 16 04 80 00 00 	movabs $0x800416,%rdi
  800500:	00 00 00 
  800503:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80050f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800515:	48 98                	cltq   
  800517:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80051e:	48 83 c2 08          	add    $0x8,%rdx
  800522:	48 89 c6             	mov    %rax,%rsi
  800525:	48 89 d7             	mov    %rdx,%rdi
  800528:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800534:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80053a:	c9                   	leaveq 
  80053b:	c3                   	retq   

000000000080053c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80053c:	55                   	push   %rbp
  80053d:	48 89 e5             	mov    %rsp,%rbp
  800540:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800547:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80054e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800555:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80055c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800563:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80056a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800571:	84 c0                	test   %al,%al
  800573:	74 20                	je     800595 <cprintf+0x59>
  800575:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800579:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80057d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800581:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800585:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800589:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80058d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800591:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800595:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80059c:	00 00 00 
  80059f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005a6:	00 00 00 
  8005a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005bb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005c2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005d0:	48 8b 0a             	mov    (%rdx),%rcx
  8005d3:	48 89 08             	mov    %rcx,(%rax)
  8005d6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005da:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005de:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005e6:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f4:	48 89 d6             	mov    %rdx,%rsi
  8005f7:	48 89 c7             	mov    %rax,%rdi
  8005fa:	48 b8 90 04 80 00 00 	movabs $0x800490,%rax
  800601:	00 00 00 
  800604:	ff d0                	callq  *%rax
  800606:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80060c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800612:	c9                   	leaveq 
  800613:	c3                   	retq   

0000000000800614 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800614:	55                   	push   %rbp
  800615:	48 89 e5             	mov    %rsp,%rbp
  800618:	48 83 ec 30          	sub    $0x30,%rsp
  80061c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800620:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800624:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800628:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80062b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80062f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800633:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800636:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80063a:	77 54                	ja     800690 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80063c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80063f:	8d 78 ff             	lea    -0x1(%rax),%edi
  800642:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
  80064e:	48 f7 f6             	div    %rsi
  800651:	49 89 c2             	mov    %rax,%r10
  800654:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800657:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80065a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80065e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800662:	41 89 c9             	mov    %ecx,%r9d
  800665:	41 89 f8             	mov    %edi,%r8d
  800668:	89 d1                	mov    %edx,%ecx
  80066a:	4c 89 d2             	mov    %r10,%rdx
  80066d:	48 89 c7             	mov    %rax,%rdi
  800670:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800677:	00 00 00 
  80067a:	ff d0                	callq  *%rax
  80067c:	eb 1c                	jmp    80069a <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800682:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800689:	48 89 ce             	mov    %rcx,%rsi
  80068c:	89 d7                	mov    %edx,%edi
  80068e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800690:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800694:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800698:	7f e4                	jg     80067e <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80069d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a6:	48 f7 f1             	div    %rcx
  8006a9:	48 b8 30 51 80 00 00 	movabs $0x805130,%rax
  8006b0:	00 00 00 
  8006b3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8006b7:	0f be d0             	movsbl %al,%edx
  8006ba:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c2:	48 89 ce             	mov    %rcx,%rsi
  8006c5:	89 d7                	mov    %edx,%edi
  8006c7:	ff d0                	callq  *%rax
}
  8006c9:	90                   	nop
  8006ca:	c9                   	leaveq 
  8006cb:	c3                   	retq   

00000000008006cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006cc:	55                   	push   %rbp
  8006cd:	48 89 e5             	mov    %rsp,%rbp
  8006d0:	48 83 ec 20          	sub    $0x20,%rsp
  8006d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006df:	7e 4f                	jle    800730 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	8b 00                	mov    (%rax),%eax
  8006e7:	83 f8 30             	cmp    $0x30,%eax
  8006ea:	73 24                	jae    800710 <getuint+0x44>
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	8b 00                	mov    (%rax),%eax
  8006fa:	89 c0                	mov    %eax,%eax
  8006fc:	48 01 d0             	add    %rdx,%rax
  8006ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800703:	8b 12                	mov    (%rdx),%edx
  800705:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	89 0a                	mov    %ecx,(%rdx)
  80070e:	eb 14                	jmp    800724 <getuint+0x58>
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	48 8b 40 08          	mov    0x8(%rax),%rax
  800718:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800724:	48 8b 00             	mov    (%rax),%rax
  800727:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072b:	e9 9d 00 00 00       	jmpq   8007cd <getuint+0x101>
	else if (lflag)
  800730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800734:	74 4c                	je     800782 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	83 f8 30             	cmp    $0x30,%eax
  80073f:	73 24                	jae    800765 <getuint+0x99>
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074d:	8b 00                	mov    (%rax),%eax
  80074f:	89 c0                	mov    %eax,%eax
  800751:	48 01 d0             	add    %rdx,%rax
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	8b 12                	mov    (%rdx),%edx
  80075a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800761:	89 0a                	mov    %ecx,(%rdx)
  800763:	eb 14                	jmp    800779 <getuint+0xad>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 40 08          	mov    0x8(%rax),%rax
  80076d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800771:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800775:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800779:	48 8b 00             	mov    (%rax),%rax
  80077c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800780:	eb 4b                	jmp    8007cd <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	8b 00                	mov    (%rax),%eax
  800788:	83 f8 30             	cmp    $0x30,%eax
  80078b:	73 24                	jae    8007b1 <getuint+0xe5>
  80078d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800791:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	8b 00                	mov    (%rax),%eax
  80079b:	89 c0                	mov    %eax,%eax
  80079d:	48 01 d0             	add    %rdx,%rax
  8007a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a4:	8b 12                	mov    (%rdx),%edx
  8007a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ad:	89 0a                	mov    %ecx,(%rdx)
  8007af:	eb 14                	jmp    8007c5 <getuint+0xf9>
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007b9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	89 c0                	mov    %eax,%eax
  8007c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d1:	c9                   	leaveq 
  8007d2:	c3                   	retq   

00000000008007d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d3:	55                   	push   %rbp
  8007d4:	48 89 e5             	mov    %rsp,%rbp
  8007d7:	48 83 ec 20          	sub    $0x20,%rsp
  8007db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e6:	7e 4f                	jle    800837 <getint+0x64>
		x=va_arg(*ap, long long);
  8007e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ec:	8b 00                	mov    (%rax),%eax
  8007ee:	83 f8 30             	cmp    $0x30,%eax
  8007f1:	73 24                	jae    800817 <getint+0x44>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	89 c0                	mov    %eax,%eax
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080a:	8b 12                	mov    (%rdx),%edx
  80080c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800813:	89 0a                	mov    %ecx,(%rdx)
  800815:	eb 14                	jmp    80082b <getint+0x58>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80081f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082b:	48 8b 00             	mov    (%rax),%rax
  80082e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800832:	e9 9d 00 00 00       	jmpq   8008d4 <getint+0x101>
	else if (lflag)
  800837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083b:	74 4c                	je     800889 <getint+0xb6>
		x=va_arg(*ap, long);
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	8b 00                	mov    (%rax),%eax
  800843:	83 f8 30             	cmp    $0x30,%eax
  800846:	73 24                	jae    80086c <getint+0x99>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	8b 00                	mov    (%rax),%eax
  800856:	89 c0                	mov    %eax,%eax
  800858:	48 01 d0             	add    %rdx,%rax
  80085b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085f:	8b 12                	mov    (%rdx),%edx
  800861:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	89 0a                	mov    %ecx,(%rdx)
  80086a:	eb 14                	jmp    800880 <getint+0xad>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 40 08          	mov    0x8(%rax),%rax
  800874:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800880:	48 8b 00             	mov    (%rax),%rax
  800883:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800887:	eb 4b                	jmp    8008d4 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088d:	8b 00                	mov    (%rax),%eax
  80088f:	83 f8 30             	cmp    $0x30,%eax
  800892:	73 24                	jae    8008b8 <getint+0xe5>
  800894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800898:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a0:	8b 00                	mov    (%rax),%eax
  8008a2:	89 c0                	mov    %eax,%eax
  8008a4:	48 01 d0             	add    %rdx,%rax
  8008a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ab:	8b 12                	mov    (%rdx),%edx
  8008ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b4:	89 0a                	mov    %ecx,(%rdx)
  8008b6:	eb 14                	jmp    8008cc <getint+0xf9>
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008c0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cc:	8b 00                	mov    (%rax),%eax
  8008ce:	48 98                	cltq   
  8008d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d8:	c9                   	leaveq 
  8008d9:	c3                   	retq   

00000000008008da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008da:	55                   	push   %rbp
  8008db:	48 89 e5             	mov    %rsp,%rbp
  8008de:	41 54                	push   %r12
  8008e0:	53                   	push   %rbx
  8008e1:	48 83 ec 60          	sub    $0x60,%rsp
  8008e5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008e9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ed:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008f9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008fd:	48 8b 0a             	mov    (%rdx),%rcx
  800900:	48 89 08             	mov    %rcx,(%rax)
  800903:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800907:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80090b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80090f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800913:	eb 17                	jmp    80092c <vprintfmt+0x52>
			if (ch == '\0')
  800915:	85 db                	test   %ebx,%ebx
  800917:	0f 84 b9 04 00 00    	je     800dd6 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80091d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800921:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800925:	48 89 d6             	mov    %rdx,%rsi
  800928:	89 df                	mov    %ebx,%edi
  80092a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800930:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800934:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800938:	0f b6 00             	movzbl (%rax),%eax
  80093b:	0f b6 d8             	movzbl %al,%ebx
  80093e:	83 fb 25             	cmp    $0x25,%ebx
  800941:	75 d2                	jne    800915 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800943:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800947:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80094e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800955:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80095c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800963:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800967:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80096b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80096f:	0f b6 00             	movzbl (%rax),%eax
  800972:	0f b6 d8             	movzbl %al,%ebx
  800975:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800978:	83 f8 55             	cmp    $0x55,%eax
  80097b:	0f 87 22 04 00 00    	ja     800da3 <vprintfmt+0x4c9>
  800981:	89 c0                	mov    %eax,%eax
  800983:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80098a:	00 
  80098b:	48 b8 58 51 80 00 00 	movabs $0x805158,%rax
  800992:	00 00 00 
  800995:	48 01 d0             	add    %rdx,%rax
  800998:	48 8b 00             	mov    (%rax),%rax
  80099b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80099d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009a1:	eb c0                	jmp    800963 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009a7:	eb ba                	jmp    800963 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009b3:	89 d0                	mov    %edx,%eax
  8009b5:	c1 e0 02             	shl    $0x2,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	01 c0                	add    %eax,%eax
  8009bc:	01 d8                	add    %ebx,%eax
  8009be:	83 e8 30             	sub    $0x30,%eax
  8009c1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009c4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d1:	7e 60                	jle    800a33 <vprintfmt+0x159>
  8009d3:	83 fb 39             	cmp    $0x39,%ebx
  8009d6:	7f 5b                	jg     800a33 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009dd:	eb d1                	jmp    8009b0 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e2:	83 f8 30             	cmp    $0x30,%eax
  8009e5:	73 17                	jae    8009fe <vprintfmt+0x124>
  8009e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009eb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ee:	89 d2                	mov    %edx,%edx
  8009f0:	48 01 d0             	add    %rdx,%rax
  8009f3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f6:	83 c2 08             	add    $0x8,%edx
  8009f9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009fc:	eb 0c                	jmp    800a0a <vprintfmt+0x130>
  8009fe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a02:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a06:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a0a:	8b 00                	mov    (%rax),%eax
  800a0c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a0f:	eb 23                	jmp    800a34 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800a11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a15:	0f 89 48 ff ff ff    	jns    800963 <vprintfmt+0x89>
				width = 0;
  800a1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a22:	e9 3c ff ff ff       	jmpq   800963 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a27:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a2e:	e9 30 ff ff ff       	jmpq   800963 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a38:	0f 89 25 ff ff ff    	jns    800963 <vprintfmt+0x89>
				width = precision, precision = -1;
  800a3e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a41:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a44:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a4b:	e9 13 ff ff ff       	jmpq   800963 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a50:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a54:	e9 0a ff ff ff       	jmpq   800963 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5c:	83 f8 30             	cmp    $0x30,%eax
  800a5f:	73 17                	jae    800a78 <vprintfmt+0x19e>
  800a61:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a68:	89 d2                	mov    %edx,%edx
  800a6a:	48 01 d0             	add    %rdx,%rax
  800a6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a70:	83 c2 08             	add    $0x8,%edx
  800a73:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a76:	eb 0c                	jmp    800a84 <vprintfmt+0x1aa>
  800a78:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a7c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a80:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a84:	8b 10                	mov    (%rax),%edx
  800a86:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8e:	48 89 ce             	mov    %rcx,%rsi
  800a91:	89 d7                	mov    %edx,%edi
  800a93:	ff d0                	callq  *%rax
			break;
  800a95:	e9 37 03 00 00       	jmpq   800dd1 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9d:	83 f8 30             	cmp    $0x30,%eax
  800aa0:	73 17                	jae    800ab9 <vprintfmt+0x1df>
  800aa2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aa6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa9:	89 d2                	mov    %edx,%edx
  800aab:	48 01 d0             	add    %rdx,%rax
  800aae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab1:	83 c2 08             	add    $0x8,%edx
  800ab4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab7:	eb 0c                	jmp    800ac5 <vprintfmt+0x1eb>
  800ab9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800abd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ac1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ac7:	85 db                	test   %ebx,%ebx
  800ac9:	79 02                	jns    800acd <vprintfmt+0x1f3>
				err = -err;
  800acb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800acd:	83 fb 15             	cmp    $0x15,%ebx
  800ad0:	7f 16                	jg     800ae8 <vprintfmt+0x20e>
  800ad2:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  800ad9:	00 00 00 
  800adc:	48 63 d3             	movslq %ebx,%rdx
  800adf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ae3:	4d 85 e4             	test   %r12,%r12
  800ae6:	75 2e                	jne    800b16 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ae8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af0:	89 d9                	mov    %ebx,%ecx
  800af2:	48 ba 41 51 80 00 00 	movabs $0x805141,%rdx
  800af9:	00 00 00 
  800afc:	48 89 c7             	mov    %rax,%rdi
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	49 b8 e0 0d 80 00 00 	movabs $0x800de0,%r8
  800b0b:	00 00 00 
  800b0e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b11:	e9 bb 02 00 00       	jmpq   800dd1 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1e:	4c 89 e1             	mov    %r12,%rcx
  800b21:	48 ba 4a 51 80 00 00 	movabs $0x80514a,%rdx
  800b28:	00 00 00 
  800b2b:	48 89 c7             	mov    %rax,%rdi
  800b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b33:	49 b8 e0 0d 80 00 00 	movabs $0x800de0,%r8
  800b3a:	00 00 00 
  800b3d:	41 ff d0             	callq  *%r8
			break;
  800b40:	e9 8c 02 00 00       	jmpq   800dd1 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b48:	83 f8 30             	cmp    $0x30,%eax
  800b4b:	73 17                	jae    800b64 <vprintfmt+0x28a>
  800b4d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b51:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b54:	89 d2                	mov    %edx,%edx
  800b56:	48 01 d0             	add    %rdx,%rax
  800b59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b5c:	83 c2 08             	add    $0x8,%edx
  800b5f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b62:	eb 0c                	jmp    800b70 <vprintfmt+0x296>
  800b64:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b68:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b6c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b70:	4c 8b 20             	mov    (%rax),%r12
  800b73:	4d 85 e4             	test   %r12,%r12
  800b76:	75 0a                	jne    800b82 <vprintfmt+0x2a8>
				p = "(null)";
  800b78:	49 bc 4d 51 80 00 00 	movabs $0x80514d,%r12
  800b7f:	00 00 00 
			if (width > 0 && padc != '-')
  800b82:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b86:	7e 78                	jle    800c00 <vprintfmt+0x326>
  800b88:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b8c:	74 72                	je     800c00 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b91:	48 98                	cltq   
  800b93:	48 89 c6             	mov    %rax,%rsi
  800b96:	4c 89 e7             	mov    %r12,%rdi
  800b99:	48 b8 8e 10 80 00 00 	movabs $0x80108e,%rax
  800ba0:	00 00 00 
  800ba3:	ff d0                	callq  *%rax
  800ba5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ba8:	eb 17                	jmp    800bc1 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800baa:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bae:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb6:	48 89 ce             	mov    %rcx,%rsi
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bbd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc5:	7f e3                	jg     800baa <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc7:	eb 37                	jmp    800c00 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bcd:	74 1e                	je     800bed <vprintfmt+0x313>
  800bcf:	83 fb 1f             	cmp    $0x1f,%ebx
  800bd2:	7e 05                	jle    800bd9 <vprintfmt+0x2ff>
  800bd4:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd7:	7e 14                	jle    800bed <vprintfmt+0x313>
					putch('?', putdat);
  800bd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be1:	48 89 d6             	mov    %rdx,%rsi
  800be4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800be9:	ff d0                	callq  *%rax
  800beb:	eb 0f                	jmp    800bfc <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800bed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf5:	48 89 d6             	mov    %rdx,%rsi
  800bf8:	89 df                	mov    %ebx,%edi
  800bfa:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bfc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c00:	4c 89 e0             	mov    %r12,%rax
  800c03:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c07:	0f b6 00             	movzbl (%rax),%eax
  800c0a:	0f be d8             	movsbl %al,%ebx
  800c0d:	85 db                	test   %ebx,%ebx
  800c0f:	74 28                	je     800c39 <vprintfmt+0x35f>
  800c11:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c15:	78 b2                	js     800bc9 <vprintfmt+0x2ef>
  800c17:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c1f:	79 a8                	jns    800bc9 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c21:	eb 16                	jmp    800c39 <vprintfmt+0x35f>
				putch(' ', putdat);
  800c23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2b:	48 89 d6             	mov    %rdx,%rsi
  800c2e:	bf 20 00 00 00       	mov    $0x20,%edi
  800c33:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3d:	7f e4                	jg     800c23 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800c3f:	e9 8d 01 00 00       	jmpq   800dd1 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c48:	be 03 00 00 00       	mov    $0x3,%esi
  800c4d:	48 89 c7             	mov    %rax,%rdi
  800c50:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800c57:	00 00 00 
  800c5a:	ff d0                	callq  *%rax
  800c5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c64:	48 85 c0             	test   %rax,%rax
  800c67:	79 1d                	jns    800c86 <vprintfmt+0x3ac>
				putch('-', putdat);
  800c69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c71:	48 89 d6             	mov    %rdx,%rsi
  800c74:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c79:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7f:	48 f7 d8             	neg    %rax
  800c82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c86:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c8d:	e9 d2 00 00 00       	jmpq   800d64 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c96:	be 03 00 00 00       	mov    $0x3,%esi
  800c9b:	48 89 c7             	mov    %rax,%rdi
  800c9e:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  800ca5:	00 00 00 
  800ca8:	ff d0                	callq  *%rax
  800caa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cb5:	e9 aa 00 00 00       	jmpq   800d64 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800cba:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cbe:	be 03 00 00 00       	mov    $0x3,%esi
  800cc3:	48 89 c7             	mov    %rax,%rdi
  800cc6:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  800ccd:	00 00 00 
  800cd0:	ff d0                	callq  *%rax
  800cd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cd6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cdd:	e9 82 00 00 00       	jmpq   800d64 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800ce2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cea:	48 89 d6             	mov    %rdx,%rsi
  800ced:	bf 30 00 00 00       	mov    $0x30,%edi
  800cf2:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cf4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfc:	48 89 d6             	mov    %rdx,%rsi
  800cff:	bf 78 00 00 00       	mov    $0x78,%edi
  800d04:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d09:	83 f8 30             	cmp    $0x30,%eax
  800d0c:	73 17                	jae    800d25 <vprintfmt+0x44b>
  800d0e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d12:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d15:	89 d2                	mov    %edx,%edx
  800d17:	48 01 d0             	add    %rdx,%rax
  800d1a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d1d:	83 c2 08             	add    $0x8,%edx
  800d20:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d23:	eb 0c                	jmp    800d31 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800d25:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d29:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d31:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d38:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d3f:	eb 23                	jmp    800d64 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d41:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d45:	be 03 00 00 00       	mov    $0x3,%esi
  800d4a:	48 89 c7             	mov    %rax,%rdi
  800d4d:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  800d54:	00 00 00 
  800d57:	ff d0                	callq  *%rax
  800d59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d5d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d64:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d69:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d6c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d73:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7b:	45 89 c1             	mov    %r8d,%r9d
  800d7e:	41 89 f8             	mov    %edi,%r8d
  800d81:	48 89 c7             	mov    %rax,%rdi
  800d84:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	callq  *%rax
			break;
  800d90:	eb 3f                	jmp    800dd1 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9a:	48 89 d6             	mov    %rdx,%rsi
  800d9d:	89 df                	mov    %ebx,%edi
  800d9f:	ff d0                	callq  *%rax
			break;
  800da1:	eb 2e                	jmp    800dd1 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800da3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dab:	48 89 d6             	mov    %rdx,%rsi
  800dae:	bf 25 00 00 00       	mov    $0x25,%edi
  800db3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800db5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dba:	eb 05                	jmp    800dc1 <vprintfmt+0x4e7>
  800dbc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dc1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dc5:	48 83 e8 01          	sub    $0x1,%rax
  800dc9:	0f b6 00             	movzbl (%rax),%eax
  800dcc:	3c 25                	cmp    $0x25,%al
  800dce:	75 ec                	jne    800dbc <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800dd0:	90                   	nop
		}
	}
  800dd1:	e9 3d fb ff ff       	jmpq   800913 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dd6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dd7:	48 83 c4 60          	add    $0x60,%rsp
  800ddb:	5b                   	pop    %rbx
  800ddc:	41 5c                	pop    %r12
  800dde:	5d                   	pop    %rbp
  800ddf:	c3                   	retq   

0000000000800de0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800de0:	55                   	push   %rbp
  800de1:	48 89 e5             	mov    %rsp,%rbp
  800de4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800deb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800df2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800df9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800e00:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e07:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e0e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e15:	84 c0                	test   %al,%al
  800e17:	74 20                	je     800e39 <printfmt+0x59>
  800e19:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e1d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e21:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e25:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e29:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e2d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e31:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e35:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e39:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e40:	00 00 00 
  800e43:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e4a:	00 00 00 
  800e4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e51:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e58:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e5f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e66:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e6d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e74:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e7b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e82:	48 89 c7             	mov    %rax,%rdi
  800e85:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800e8c:	00 00 00 
  800e8f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e91:	90                   	nop
  800e92:	c9                   	leaveq 
  800e93:	c3                   	retq   

0000000000800e94 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e94:	55                   	push   %rbp
  800e95:	48 89 e5             	mov    %rsp,%rbp
  800e98:	48 83 ec 10          	sub    $0x10,%rsp
  800e9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea7:	8b 40 10             	mov    0x10(%rax),%eax
  800eaa:	8d 50 01             	lea    0x1(%rax),%edx
  800ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb8:	48 8b 10             	mov    (%rax),%rdx
  800ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebf:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ec3:	48 39 c2             	cmp    %rax,%rdx
  800ec6:	73 17                	jae    800edf <sprintputch+0x4b>
		*b->buf++ = ch;
  800ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ecc:	48 8b 00             	mov    (%rax),%rax
  800ecf:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ed3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed7:	48 89 0a             	mov    %rcx,(%rdx)
  800eda:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800edd:	88 10                	mov    %dl,(%rax)
}
  800edf:	90                   	nop
  800ee0:	c9                   	leaveq 
  800ee1:	c3                   	retq   

0000000000800ee2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee2:	55                   	push   %rbp
  800ee3:	48 89 e5             	mov    %rsp,%rbp
  800ee6:	48 83 ec 50          	sub    $0x50,%rsp
  800eea:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eee:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ef1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ef5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ef9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800efd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f01:	48 8b 0a             	mov    (%rdx),%rcx
  800f04:	48 89 08             	mov    %rcx,(%rax)
  800f07:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f0b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f0f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f13:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f1b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f1f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f22:	48 98                	cltq   
  800f24:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f2c:	48 01 d0             	add    %rdx,%rax
  800f2f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f33:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f3a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f3f:	74 06                	je     800f47 <vsnprintf+0x65>
  800f41:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f45:	7f 07                	jg     800f4e <vsnprintf+0x6c>
		return -E_INVAL;
  800f47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4c:	eb 2f                	jmp    800f7d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f4e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f52:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f56:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f5a:	48 89 c6             	mov    %rax,%rsi
  800f5d:	48 bf 94 0e 80 00 00 	movabs $0x800e94,%rdi
  800f64:	00 00 00 
  800f67:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800f6e:	00 00 00 
  800f71:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f77:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f7a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f7d:	c9                   	leaveq 
  800f7e:	c3                   	retq   

0000000000800f7f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f7f:	55                   	push   %rbp
  800f80:	48 89 e5             	mov    %rsp,%rbp
  800f83:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f8a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f91:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f97:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800f9e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fa5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fb3:	84 c0                	test   %al,%al
  800fb5:	74 20                	je     800fd7 <snprintf+0x58>
  800fb7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fbb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fbf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fc3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fc7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fcb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fcf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fd3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fd7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fde:	00 00 00 
  800fe1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fe8:	00 00 00 
  800feb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fef:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ff6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ffd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801004:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80100b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801012:	48 8b 0a             	mov    (%rdx),%rcx
  801015:	48 89 08             	mov    %rcx,(%rax)
  801018:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80101c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801020:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801024:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801028:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80102f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801036:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80103c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801043:	48 89 c7             	mov    %rax,%rdi
  801046:	48 b8 e2 0e 80 00 00 	movabs $0x800ee2,%rax
  80104d:	00 00 00 
  801050:	ff d0                	callq  *%rax
  801052:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801058:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 18          	sub    $0x18,%rsp
  801068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801073:	eb 09                	jmp    80107e <strlen+0x1e>
		n++;
  801075:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801079:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	0f b6 00             	movzbl (%rax),%eax
  801085:	84 c0                	test   %al,%al
  801087:	75 ec                	jne    801075 <strlen+0x15>
		n++;
	return n;
  801089:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80108c:	c9                   	leaveq 
  80108d:	c3                   	retq   

000000000080108e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80108e:	55                   	push   %rbp
  80108f:	48 89 e5             	mov    %rsp,%rbp
  801092:	48 83 ec 20          	sub    $0x20,%rsp
  801096:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a5:	eb 0e                	jmp    8010b5 <strnlen+0x27>
		n++;
  8010a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ba:	74 0b                	je     8010c7 <strnlen+0x39>
  8010bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c0:	0f b6 00             	movzbl (%rax),%eax
  8010c3:	84 c0                	test   %al,%al
  8010c5:	75 e0                	jne    8010a7 <strnlen+0x19>
		n++;
	return n;
  8010c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 83 ec 20          	sub    $0x20,%rsp
  8010d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010e4:	90                   	nop
  8010e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010f9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010fd:	0f b6 12             	movzbl (%rdx),%edx
  801100:	88 10                	mov    %dl,(%rax)
  801102:	0f b6 00             	movzbl (%rax),%eax
  801105:	84 c0                	test   %al,%al
  801107:	75 dc                	jne    8010e5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80110d:	c9                   	leaveq 
  80110e:	c3                   	retq   

000000000080110f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80110f:	55                   	push   %rbp
  801110:	48 89 e5             	mov    %rsp,%rbp
  801113:	48 83 ec 20          	sub    $0x20,%rsp
  801117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80111f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801123:	48 89 c7             	mov    %rax,%rdi
  801126:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  80112d:	00 00 00 
  801130:	ff d0                	callq  *%rax
  801132:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801138:	48 63 d0             	movslq %eax,%rdx
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113f:	48 01 c2             	add    %rax,%rdx
  801142:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801146:	48 89 c6             	mov    %rax,%rsi
  801149:	48 89 d7             	mov    %rdx,%rdi
  80114c:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  801153:	00 00 00 
  801156:	ff d0                	callq  *%rax
	return dst;
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80115c:	c9                   	leaveq 
  80115d:	c3                   	retq   

000000000080115e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80115e:	55                   	push   %rbp
  80115f:	48 89 e5             	mov    %rsp,%rbp
  801162:	48 83 ec 28          	sub    $0x28,%rsp
  801166:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801176:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80117a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801181:	00 
  801182:	eb 2a                	jmp    8011ae <strncpy+0x50>
		*dst++ = *src;
  801184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801188:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80118c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801190:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801194:	0f b6 12             	movzbl (%rdx),%edx
  801197:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801199:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119d:	0f b6 00             	movzbl (%rax),%eax
  8011a0:	84 c0                	test   %al,%al
  8011a2:	74 05                	je     8011a9 <strncpy+0x4b>
			src++;
  8011a4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011b6:	72 cc                	jb     801184 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011bc:	c9                   	leaveq 
  8011bd:	c3                   	retq   

00000000008011be <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011be:	55                   	push   %rbp
  8011bf:	48 89 e5             	mov    %rsp,%rbp
  8011c2:	48 83 ec 28          	sub    $0x28,%rsp
  8011c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011da:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011df:	74 3d                	je     80121e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011e1:	eb 1d                	jmp    801200 <strlcpy+0x42>
			*dst++ = *src++;
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011f7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011fb:	0f b6 12             	movzbl (%rdx),%edx
  8011fe:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801200:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801205:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80120a:	74 0b                	je     801217 <strlcpy+0x59>
  80120c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801210:	0f b6 00             	movzbl (%rax),%eax
  801213:	84 c0                	test   %al,%al
  801215:	75 cc                	jne    8011e3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80121e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801226:	48 29 c2             	sub    %rax,%rdx
  801229:	48 89 d0             	mov    %rdx,%rax
}
  80122c:	c9                   	leaveq 
  80122d:	c3                   	retq   

000000000080122e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80122e:	55                   	push   %rbp
  80122f:	48 89 e5             	mov    %rsp,%rbp
  801232:	48 83 ec 10          	sub    $0x10,%rsp
  801236:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80123e:	eb 0a                	jmp    80124a <strcmp+0x1c>
		p++, q++;
  801240:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801245:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	84 c0                	test   %al,%al
  801253:	74 12                	je     801267 <strcmp+0x39>
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	0f b6 10             	movzbl (%rax),%edx
  80125c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801260:	0f b6 00             	movzbl (%rax),%eax
  801263:	38 c2                	cmp    %al,%dl
  801265:	74 d9                	je     801240 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	0f b6 d0             	movzbl %al,%edx
  801271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801275:	0f b6 00             	movzbl (%rax),%eax
  801278:	0f b6 c0             	movzbl %al,%eax
  80127b:	29 c2                	sub    %eax,%edx
  80127d:	89 d0                	mov    %edx,%eax
}
  80127f:	c9                   	leaveq 
  801280:	c3                   	retq   

0000000000801281 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	48 83 ec 18          	sub    $0x18,%rsp
  801289:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801291:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801295:	eb 0f                	jmp    8012a6 <strncmp+0x25>
		n--, p++, q++;
  801297:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80129c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ab:	74 1d                	je     8012ca <strncmp+0x49>
  8012ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b1:	0f b6 00             	movzbl (%rax),%eax
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 12                	je     8012ca <strncmp+0x49>
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	0f b6 10             	movzbl (%rax),%edx
  8012bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	38 c2                	cmp    %al,%dl
  8012c8:	74 cd                	je     801297 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012cf:	75 07                	jne    8012d8 <strncmp+0x57>
		return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb 18                	jmp    8012f0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	0f b6 d0             	movzbl %al,%edx
  8012e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e6:	0f b6 00             	movzbl (%rax),%eax
  8012e9:	0f b6 c0             	movzbl %al,%eax
  8012ec:	29 c2                	sub    %eax,%edx
  8012ee:	89 d0                	mov    %edx,%eax
}
  8012f0:	c9                   	leaveq 
  8012f1:	c3                   	retq   

00000000008012f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	48 83 ec 10          	sub    $0x10,%rsp
  8012fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fe:	89 f0                	mov    %esi,%eax
  801300:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801303:	eb 17                	jmp    80131c <strchr+0x2a>
		if (*s == c)
  801305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801309:	0f b6 00             	movzbl (%rax),%eax
  80130c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80130f:	75 06                	jne    801317 <strchr+0x25>
			return (char *) s;
  801311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801315:	eb 15                	jmp    80132c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801317:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80131c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801320:	0f b6 00             	movzbl (%rax),%eax
  801323:	84 c0                	test   %al,%al
  801325:	75 de                	jne    801305 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 10          	sub    $0x10,%rsp
  801336:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133a:	89 f0                	mov    %esi,%eax
  80133c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80133f:	eb 11                	jmp    801352 <strfind+0x24>
		if (*s == c)
  801341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801345:	0f b6 00             	movzbl (%rax),%eax
  801348:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80134b:	74 12                	je     80135f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80134d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	84 c0                	test   %al,%al
  80135b:	75 e4                	jne    801341 <strfind+0x13>
  80135d:	eb 01                	jmp    801360 <strfind+0x32>
		if (*s == c)
			break;
  80135f:	90                   	nop
	return (char *) s;
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801364:	c9                   	leaveq 
  801365:	c3                   	retq   

0000000000801366 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801366:	55                   	push   %rbp
  801367:	48 89 e5             	mov    %rsp,%rbp
  80136a:	48 83 ec 18          	sub    $0x18,%rsp
  80136e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801372:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801375:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801379:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80137e:	75 06                	jne    801386 <memset+0x20>
		return v;
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801384:	eb 69                	jmp    8013ef <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138a:	83 e0 03             	and    $0x3,%eax
  80138d:	48 85 c0             	test   %rax,%rax
  801390:	75 48                	jne    8013da <memset+0x74>
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801396:	83 e0 03             	and    $0x3,%eax
  801399:	48 85 c0             	test   %rax,%rax
  80139c:	75 3c                	jne    8013da <memset+0x74>
		c &= 0xFF;
  80139e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a8:	c1 e0 18             	shl    $0x18,%eax
  8013ab:	89 c2                	mov    %eax,%edx
  8013ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b0:	c1 e0 10             	shl    $0x10,%eax
  8013b3:	09 c2                	or     %eax,%edx
  8013b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b8:	c1 e0 08             	shl    $0x8,%eax
  8013bb:	09 d0                	or     %edx,%eax
  8013bd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c4:	48 c1 e8 02          	shr    $0x2,%rax
  8013c8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d2:	48 89 d7             	mov    %rdx,%rdi
  8013d5:	fc                   	cld    
  8013d6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013d8:	eb 11                	jmp    8013eb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013e5:	48 89 d7             	mov    %rdx,%rdi
  8013e8:	fc                   	cld    
  8013e9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ef:	c9                   	leaveq 
  8013f0:	c3                   	retq   

00000000008013f1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	48 83 ec 28          	sub    $0x28,%rsp
  8013f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801401:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801405:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801409:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80140d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80141d:	0f 83 88 00 00 00    	jae    8014ab <memmove+0xba>
  801423:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801427:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142b:	48 01 d0             	add    %rdx,%rax
  80142e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801432:	76 77                	jbe    8014ab <memmove+0xba>
		s += n;
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80143c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801440:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	83 e0 03             	and    $0x3,%eax
  80144b:	48 85 c0             	test   %rax,%rax
  80144e:	75 3b                	jne    80148b <memmove+0x9a>
  801450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801454:	83 e0 03             	and    $0x3,%eax
  801457:	48 85 c0             	test   %rax,%rax
  80145a:	75 2f                	jne    80148b <memmove+0x9a>
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	83 e0 03             	and    $0x3,%eax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 23                	jne    80148b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146c:	48 83 e8 04          	sub    $0x4,%rax
  801470:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801474:	48 83 ea 04          	sub    $0x4,%rdx
  801478:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80147c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801480:	48 89 c7             	mov    %rax,%rdi
  801483:	48 89 d6             	mov    %rdx,%rsi
  801486:	fd                   	std    
  801487:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801489:	eb 1d                	jmp    8014a8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80148b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	48 89 d7             	mov    %rdx,%rdi
  8014a2:	48 89 c1             	mov    %rax,%rcx
  8014a5:	fd                   	std    
  8014a6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014a8:	fc                   	cld    
  8014a9:	eb 57                	jmp    801502 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	83 e0 03             	and    $0x3,%eax
  8014b2:	48 85 c0             	test   %rax,%rax
  8014b5:	75 36                	jne    8014ed <memmove+0xfc>
  8014b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bb:	83 e0 03             	and    $0x3,%eax
  8014be:	48 85 c0             	test   %rax,%rax
  8014c1:	75 2a                	jne    8014ed <memmove+0xfc>
  8014c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c7:	83 e0 03             	and    $0x3,%eax
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	75 1e                	jne    8014ed <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	48 c1 e8 02          	shr    $0x2,%rax
  8014d7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e2:	48 89 c7             	mov    %rax,%rdi
  8014e5:	48 89 d6             	mov    %rdx,%rsi
  8014e8:	fc                   	cld    
  8014e9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014eb:	eb 15                	jmp    801502 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f9:	48 89 c7             	mov    %rax,%rdi
  8014fc:	48 89 d6             	mov    %rdx,%rsi
  8014ff:	fc                   	cld    
  801500:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801506:	c9                   	leaveq 
  801507:	c3                   	retq   

0000000000801508 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801508:	55                   	push   %rbp
  801509:	48 89 e5             	mov    %rsp,%rbp
  80150c:	48 83 ec 18          	sub    $0x18,%rsp
  801510:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801514:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801518:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80151c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801520:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801528:	48 89 ce             	mov    %rcx,%rsi
  80152b:	48 89 c7             	mov    %rax,%rdi
  80152e:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  801535:	00 00 00 
  801538:	ff d0                	callq  *%rax
}
  80153a:	c9                   	leaveq 
  80153b:	c3                   	retq   

000000000080153c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	48 83 ec 28          	sub    $0x28,%rsp
  801544:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801548:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801554:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801558:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80155c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801560:	eb 36                	jmp    801598 <memcmp+0x5c>
		if (*s1 != *s2)
  801562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801566:	0f b6 10             	movzbl (%rax),%edx
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	38 c2                	cmp    %al,%dl
  801572:	74 1a                	je     80158e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801578:	0f b6 00             	movzbl (%rax),%eax
  80157b:	0f b6 d0             	movzbl %al,%edx
  80157e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	0f b6 c0             	movzbl %al,%eax
  801588:	29 c2                	sub    %eax,%edx
  80158a:	89 d0                	mov    %edx,%eax
  80158c:	eb 20                	jmp    8015ae <memcmp+0x72>
		s1++, s2++;
  80158e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801593:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015a4:	48 85 c0             	test   %rax,%rax
  8015a7:	75 b9                	jne    801562 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ae:	c9                   	leaveq 
  8015af:	c3                   	retq   

00000000008015b0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015b0:	55                   	push   %rbp
  8015b1:	48 89 e5             	mov    %rsp,%rbp
  8015b4:	48 83 ec 28          	sub    $0x28,%rsp
  8015b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015bc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	48 01 d0             	add    %rdx,%rax
  8015ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015d2:	eb 19                	jmp    8015ed <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d8:	0f b6 00             	movzbl (%rax),%eax
  8015db:	0f b6 d0             	movzbl %al,%edx
  8015de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015e1:	0f b6 c0             	movzbl %al,%eax
  8015e4:	39 c2                	cmp    %eax,%edx
  8015e6:	74 11                	je     8015f9 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015e8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015f5:	72 dd                	jb     8015d4 <memfind+0x24>
  8015f7:	eb 01                	jmp    8015fa <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015f9:	90                   	nop
	return (void *) s;
  8015fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015fe:	c9                   	leaveq 
  8015ff:	c3                   	retq   

0000000000801600 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801600:	55                   	push   %rbp
  801601:	48 89 e5             	mov    %rsp,%rbp
  801604:	48 83 ec 38          	sub    $0x38,%rsp
  801608:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80160c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801610:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801613:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80161a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801621:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801622:	eb 05                	jmp    801629 <strtol+0x29>
		s++;
  801624:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	3c 20                	cmp    $0x20,%al
  801632:	74 f0                	je     801624 <strtol+0x24>
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 09                	cmp    $0x9,%al
  80163d:	74 e5                	je     801624 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	3c 2b                	cmp    $0x2b,%al
  801648:	75 07                	jne    801651 <strtol+0x51>
		s++;
  80164a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80164f:	eb 17                	jmp    801668 <strtol+0x68>
	else if (*s == '-')
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 2d                	cmp    $0x2d,%al
  80165a:	75 0c                	jne    801668 <strtol+0x68>
		s++, neg = 1;
  80165c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166c:	74 06                	je     801674 <strtol+0x74>
  80166e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801672:	75 28                	jne    80169c <strtol+0x9c>
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	3c 30                	cmp    $0x30,%al
  80167d:	75 1d                	jne    80169c <strtol+0x9c>
  80167f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801683:	48 83 c0 01          	add    $0x1,%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	3c 78                	cmp    $0x78,%al
  80168c:	75 0e                	jne    80169c <strtol+0x9c>
		s += 2, base = 16;
  80168e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801693:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80169a:	eb 2c                	jmp    8016c8 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80169c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016a0:	75 19                	jne    8016bb <strtol+0xbb>
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	3c 30                	cmp    $0x30,%al
  8016ab:	75 0e                	jne    8016bb <strtol+0xbb>
		s++, base = 8;
  8016ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016b9:	eb 0d                	jmp    8016c8 <strtol+0xc8>
	else if (base == 0)
  8016bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016bf:	75 07                	jne    8016c8 <strtol+0xc8>
		base = 10;
  8016c1:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	3c 2f                	cmp    $0x2f,%al
  8016d1:	7e 1d                	jle    8016f0 <strtol+0xf0>
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	3c 39                	cmp    $0x39,%al
  8016dc:	7f 12                	jg     8016f0 <strtol+0xf0>
			dig = *s - '0';
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	0f b6 00             	movzbl (%rax),%eax
  8016e5:	0f be c0             	movsbl %al,%eax
  8016e8:	83 e8 30             	sub    $0x30,%eax
  8016eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ee:	eb 4e                	jmp    80173e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f4:	0f b6 00             	movzbl (%rax),%eax
  8016f7:	3c 60                	cmp    $0x60,%al
  8016f9:	7e 1d                	jle    801718 <strtol+0x118>
  8016fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ff:	0f b6 00             	movzbl (%rax),%eax
  801702:	3c 7a                	cmp    $0x7a,%al
  801704:	7f 12                	jg     801718 <strtol+0x118>
			dig = *s - 'a' + 10;
  801706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170a:	0f b6 00             	movzbl (%rax),%eax
  80170d:	0f be c0             	movsbl %al,%eax
  801710:	83 e8 57             	sub    $0x57,%eax
  801713:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801716:	eb 26                	jmp    80173e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	3c 40                	cmp    $0x40,%al
  801721:	7e 47                	jle    80176a <strtol+0x16a>
  801723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801727:	0f b6 00             	movzbl (%rax),%eax
  80172a:	3c 5a                	cmp    $0x5a,%al
  80172c:	7f 3c                	jg     80176a <strtol+0x16a>
			dig = *s - 'A' + 10;
  80172e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801732:	0f b6 00             	movzbl (%rax),%eax
  801735:	0f be c0             	movsbl %al,%eax
  801738:	83 e8 37             	sub    $0x37,%eax
  80173b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80173e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801741:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801744:	7d 23                	jge    801769 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801746:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80174b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80174e:	48 98                	cltq   
  801750:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801755:	48 89 c2             	mov    %rax,%rdx
  801758:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80175b:	48 98                	cltq   
  80175d:	48 01 d0             	add    %rdx,%rax
  801760:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801764:	e9 5f ff ff ff       	jmpq   8016c8 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801769:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80176a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80176f:	74 0b                	je     80177c <strtol+0x17c>
		*endptr = (char *) s;
  801771:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801775:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801779:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80177c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801780:	74 09                	je     80178b <strtol+0x18b>
  801782:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801786:	48 f7 d8             	neg    %rax
  801789:	eb 04                	jmp    80178f <strtol+0x18f>
  80178b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80178f:	c9                   	leaveq 
  801790:	c3                   	retq   

0000000000801791 <strstr>:

char * strstr(const char *in, const char *str)
{
  801791:	55                   	push   %rbp
  801792:	48 89 e5             	mov    %rsp,%rbp
  801795:	48 83 ec 30          	sub    $0x30,%rsp
  801799:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80179d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017a9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017b3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017b7:	75 06                	jne    8017bf <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	eb 6b                	jmp    80182a <strstr+0x99>

	len = strlen(str);
  8017bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c3:	48 89 c7             	mov    %rax,%rdi
  8017c6:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  8017cd:	00 00 00 
  8017d0:	ff d0                	callq  *%rax
  8017d2:	48 98                	cltq   
  8017d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e4:	0f b6 00             	movzbl (%rax),%eax
  8017e7:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017ea:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017ee:	75 07                	jne    8017f7 <strstr+0x66>
				return (char *) 0;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	eb 33                	jmp    80182a <strstr+0x99>
		} while (sc != c);
  8017f7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017fb:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017fe:	75 d8                	jne    8017d8 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801800:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801804:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180c:	48 89 ce             	mov    %rcx,%rsi
  80180f:	48 89 c7             	mov    %rax,%rdi
  801812:	48 b8 81 12 80 00 00 	movabs $0x801281,%rax
  801819:	00 00 00 
  80181c:	ff d0                	callq  *%rax
  80181e:	85 c0                	test   %eax,%eax
  801820:	75 b6                	jne    8017d8 <strstr+0x47>

	return (char *) (in - 1);
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	48 83 e8 01          	sub    $0x1,%rax
}
  80182a:	c9                   	leaveq 
  80182b:	c3                   	retq   

000000000080182c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	53                   	push   %rbx
  801831:	48 83 ec 48          	sub    $0x48,%rsp
  801835:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801838:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80183b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80183f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801843:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801847:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80184b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80184e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801852:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801856:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80185a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80185e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801862:	4c 89 c3             	mov    %r8,%rbx
  801865:	cd 30                	int    $0x30
  801867:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80186b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80186f:	74 3e                	je     8018af <syscall+0x83>
  801871:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801876:	7e 37                	jle    8018af <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80187c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80187f:	49 89 d0             	mov    %rdx,%r8
  801882:	89 c1                	mov    %eax,%ecx
  801884:	48 ba 08 54 80 00 00 	movabs $0x805408,%rdx
  80188b:	00 00 00 
  80188e:	be 24 00 00 00       	mov    $0x24,%esi
  801893:	48 bf 25 54 80 00 00 	movabs $0x805425,%rdi
  80189a:	00 00 00 
  80189d:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a2:	49 b9 02 03 80 00 00 	movabs $0x800302,%r9
  8018a9:	00 00 00 
  8018ac:	41 ff d1             	callq  *%r9

	return ret;
  8018af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018b3:	48 83 c4 48          	add    $0x48,%rsp
  8018b7:	5b                   	pop    %rbx
  8018b8:	5d                   	pop    %rbp
  8018b9:	c3                   	retq   

00000000008018ba <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	48 83 ec 10          	sub    $0x10,%rsp
  8018c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d2:	48 83 ec 08          	sub    $0x8,%rsp
  8018d6:	6a 00                	pushq  $0x0
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	48 89 d1             	mov    %rdx,%rcx
  8018e7:	48 89 c2             	mov    %rax,%rdx
  8018ea:	be 00 00 00 00       	mov    $0x0,%esi
  8018ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f4:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
  801900:	48 83 c4 10          	add    $0x10,%rsp
}
  801904:	90                   	nop
  801905:	c9                   	leaveq 
  801906:	c3                   	retq   

0000000000801907 <sys_cgetc>:

int
sys_cgetc(void)
{
  801907:	55                   	push   %rbp
  801908:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80190b:	48 83 ec 08          	sub    $0x8,%rsp
  80190f:	6a 00                	pushq  $0x0
  801911:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801917:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801922:	ba 00 00 00 00       	mov    $0x0,%edx
  801927:	be 00 00 00 00       	mov    $0x0,%esi
  80192c:	bf 01 00 00 00       	mov    $0x1,%edi
  801931:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
  80193d:	48 83 c4 10          	add    $0x10,%rsp
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	48 83 ec 10          	sub    $0x10,%rsp
  80194b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80194e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801951:	48 98                	cltq   
  801953:	48 83 ec 08          	sub    $0x8,%rsp
  801957:	6a 00                	pushq  $0x0
  801959:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801965:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196a:	48 89 c2             	mov    %rax,%rdx
  80196d:	be 01 00 00 00       	mov    $0x1,%esi
  801972:	bf 03 00 00 00       	mov    $0x3,%edi
  801977:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  80197e:	00 00 00 
  801981:	ff d0                	callq  *%rax
  801983:	48 83 c4 10          	add    $0x10,%rsp
}
  801987:	c9                   	leaveq 
  801988:	c3                   	retq   

0000000000801989 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801989:	55                   	push   %rbp
  80198a:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80198d:	48 83 ec 08          	sub    $0x8,%rsp
  801991:	6a 00                	pushq  $0x0
  801993:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801999:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a9:	be 00 00 00 00       	mov    $0x0,%esi
  8019ae:	bf 02 00 00 00       	mov    $0x2,%edi
  8019b3:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	callq  *%rax
  8019bf:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c3:	c9                   	leaveq 
  8019c4:	c3                   	retq   

00000000008019c5 <sys_yield>:


void
sys_yield(void)
{
  8019c5:	55                   	push   %rbp
  8019c6:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019c9:	48 83 ec 08          	sub    $0x8,%rsp
  8019cd:	6a 00                	pushq  $0x0
  8019cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e5:	be 00 00 00 00       	mov    $0x0,%esi
  8019ea:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019ef:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
  8019fb:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ff:	90                   	nop
  801a00:	c9                   	leaveq 
  801a01:	c3                   	retq   

0000000000801a02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a02:	55                   	push   %rbp
  801a03:	48 89 e5             	mov    %rsp,%rbp
  801a06:	48 83 ec 10          	sub    $0x10,%rsp
  801a0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a11:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a17:	48 63 c8             	movslq %eax,%rcx
  801a1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a21:	48 98                	cltq   
  801a23:	48 83 ec 08          	sub    $0x8,%rsp
  801a27:	6a 00                	pushq  $0x0
  801a29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2f:	49 89 c8             	mov    %rcx,%r8
  801a32:	48 89 d1             	mov    %rdx,%rcx
  801a35:	48 89 c2             	mov    %rax,%rdx
  801a38:	be 01 00 00 00       	mov    $0x1,%esi
  801a3d:	bf 04 00 00 00       	mov    $0x4,%edi
  801a42:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801a49:	00 00 00 
  801a4c:	ff d0                	callq  *%rax
  801a4e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a52:	c9                   	leaveq 
  801a53:	c3                   	retq   

0000000000801a54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a54:	55                   	push   %rbp
  801a55:	48 89 e5             	mov    %rsp,%rbp
  801a58:	48 83 ec 20          	sub    $0x20,%rsp
  801a5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a63:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a66:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a6a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a6e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a71:	48 63 c8             	movslq %eax,%rcx
  801a74:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7b:	48 63 f0             	movslq %eax,%rsi
  801a7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a85:	48 98                	cltq   
  801a87:	48 83 ec 08          	sub    $0x8,%rsp
  801a8b:	51                   	push   %rcx
  801a8c:	49 89 f9             	mov    %rdi,%r9
  801a8f:	49 89 f0             	mov    %rsi,%r8
  801a92:	48 89 d1             	mov    %rdx,%rcx
  801a95:	48 89 c2             	mov    %rax,%rdx
  801a98:	be 01 00 00 00       	mov    $0x1,%esi
  801a9d:	bf 05 00 00 00       	mov    $0x5,%edi
  801aa2:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
  801aae:	48 83 c4 10          	add    $0x10,%rsp
}
  801ab2:	c9                   	leaveq 
  801ab3:	c3                   	retq   

0000000000801ab4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ab4:	55                   	push   %rbp
  801ab5:	48 89 e5             	mov    %rsp,%rbp
  801ab8:	48 83 ec 10          	sub    $0x10,%rsp
  801abc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801abf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ac3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aca:	48 98                	cltq   
  801acc:	48 83 ec 08          	sub    $0x8,%rsp
  801ad0:	6a 00                	pushq  $0x0
  801ad2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ade:	48 89 d1             	mov    %rdx,%rcx
  801ae1:	48 89 c2             	mov    %rax,%rdx
  801ae4:	be 01 00 00 00       	mov    $0x1,%esi
  801ae9:	bf 06 00 00 00       	mov    $0x6,%edi
  801aee:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	callq  *%rax
  801afa:	48 83 c4 10          	add    $0x10,%rsp
}
  801afe:	c9                   	leaveq 
  801aff:	c3                   	retq   

0000000000801b00 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b00:	55                   	push   %rbp
  801b01:	48 89 e5             	mov    %rsp,%rbp
  801b04:	48 83 ec 10          	sub    $0x10,%rsp
  801b08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b11:	48 63 d0             	movslq %eax,%rdx
  801b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b17:	48 98                	cltq   
  801b19:	48 83 ec 08          	sub    $0x8,%rsp
  801b1d:	6a 00                	pushq  $0x0
  801b1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2b:	48 89 d1             	mov    %rdx,%rcx
  801b2e:	48 89 c2             	mov    %rax,%rdx
  801b31:	be 01 00 00 00       	mov    $0x1,%esi
  801b36:	bf 08 00 00 00       	mov    $0x8,%edi
  801b3b:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801b42:	00 00 00 
  801b45:	ff d0                	callq  *%rax
  801b47:	48 83 c4 10          	add    $0x10,%rsp
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 10          	sub    $0x10,%rsp
  801b55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b63:	48 98                	cltq   
  801b65:	48 83 ec 08          	sub    $0x8,%rsp
  801b69:	6a 00                	pushq  $0x0
  801b6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b77:	48 89 d1             	mov    %rdx,%rcx
  801b7a:	48 89 c2             	mov    %rax,%rdx
  801b7d:	be 01 00 00 00       	mov    $0x1,%esi
  801b82:	bf 09 00 00 00       	mov    $0x9,%edi
  801b87:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	callq  *%rax
  801b93:	48 83 c4 10          	add    $0x10,%rsp
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 10          	sub    $0x10,%rsp
  801ba1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ba8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801baf:	48 98                	cltq   
  801bb1:	48 83 ec 08          	sub    $0x8,%rsp
  801bb5:	6a 00                	pushq  $0x0
  801bb7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc3:	48 89 d1             	mov    %rdx,%rcx
  801bc6:	48 89 c2             	mov    %rax,%rdx
  801bc9:	be 01 00 00 00       	mov    $0x1,%esi
  801bce:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bd3:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801bda:	00 00 00 
  801bdd:	ff d0                	callq  *%rax
  801bdf:	48 83 c4 10          	add    $0x10,%rsp
}
  801be3:	c9                   	leaveq 
  801be4:	c3                   	retq   

0000000000801be5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	48 83 ec 20          	sub    $0x20,%rsp
  801bed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bfe:	48 63 f0             	movslq %eax,%rsi
  801c01:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c08:	48 98                	cltq   
  801c0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0e:	48 83 ec 08          	sub    $0x8,%rsp
  801c12:	6a 00                	pushq  $0x0
  801c14:	49 89 f1             	mov    %rsi,%r9
  801c17:	49 89 c8             	mov    %rcx,%r8
  801c1a:	48 89 d1             	mov    %rdx,%rcx
  801c1d:	48 89 c2             	mov    %rax,%rdx
  801c20:	be 00 00 00 00       	mov    $0x0,%esi
  801c25:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c2a:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801c31:	00 00 00 
  801c34:	ff d0                	callq  *%rax
  801c36:	48 83 c4 10          	add    $0x10,%rsp
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 10          	sub    $0x10,%rsp
  801c44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4c:	48 83 ec 08          	sub    $0x8,%rsp
  801c50:	6a 00                	pushq  $0x0
  801c52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	be 01 00 00 00       	mov    $0x1,%esi
  801c6b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c70:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c86:	48 83 ec 08          	sub    $0x8,%rsp
  801c8a:	6a 00                	pushq  $0x0
  801c8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca2:	be 00 00 00 00       	mov    $0x0,%esi
  801ca7:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cac:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
  801cb8:	48 83 c4 10          	add    $0x10,%rsp
}
  801cbc:	c9                   	leaveq 
  801cbd:	c3                   	retq   

0000000000801cbe <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
  801cc2:	48 83 ec 10          	sub    $0x10,%rsp
  801cc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cca:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801ccd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd4:	48 83 ec 08          	sub    $0x8,%rsp
  801cd8:	6a 00                	pushq  $0x0
  801cda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce6:	48 89 d1             	mov    %rdx,%rcx
  801ce9:	48 89 c2             	mov    %rax,%rdx
  801cec:	be 00 00 00 00       	mov    $0x0,%esi
  801cf1:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cf6:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801cfd:	00 00 00 
  801d00:	ff d0                	callq  *%rax
  801d02:	48 83 c4 10          	add    $0x10,%rsp
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 10          	sub    $0x10,%rsp
  801d10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d14:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d17:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1e:	48 83 ec 08          	sub    $0x8,%rsp
  801d22:	6a 00                	pushq  $0x0
  801d24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d30:	48 89 d1             	mov    %rdx,%rcx
  801d33:	48 89 c2             	mov    %rax,%rdx
  801d36:	be 00 00 00 00       	mov    $0x0,%esi
  801d3b:	bf 10 00 00 00       	mov    $0x10,%edi
  801d40:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
  801d4c:	48 83 c4 10          	add    $0x10,%rsp
}
  801d50:	c9                   	leaveq 
  801d51:	c3                   	retq   

0000000000801d52 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	48 83 ec 20          	sub    $0x20,%rsp
  801d5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d61:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d64:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d68:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d6c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d6f:	48 63 c8             	movslq %eax,%rcx
  801d72:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d79:	48 63 f0             	movslq %eax,%rsi
  801d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d83:	48 98                	cltq   
  801d85:	48 83 ec 08          	sub    $0x8,%rsp
  801d89:	51                   	push   %rcx
  801d8a:	49 89 f9             	mov    %rdi,%r9
  801d8d:	49 89 f0             	mov    %rsi,%r8
  801d90:	48 89 d1             	mov    %rdx,%rcx
  801d93:	48 89 c2             	mov    %rax,%rdx
  801d96:	be 00 00 00 00       	mov    $0x0,%esi
  801d9b:	bf 11 00 00 00       	mov    $0x11,%edi
  801da0:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	callq  *%rax
  801dac:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801db0:	c9                   	leaveq 
  801db1:	c3                   	retq   

0000000000801db2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	48 83 ec 10          	sub    $0x10,%rsp
  801dba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dca:	48 83 ec 08          	sub    $0x8,%rsp
  801dce:	6a 00                	pushq  $0x0
  801dd0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ddc:	48 89 d1             	mov    %rdx,%rcx
  801ddf:	48 89 c2             	mov    %rax,%rdx
  801de2:	be 00 00 00 00       	mov    $0x0,%esi
  801de7:	bf 12 00 00 00       	mov    $0x12,%edi
  801dec:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801df3:	00 00 00 
  801df6:	ff d0                	callq  *%rax
  801df8:	48 83 c4 10          	add    $0x10,%rsp
}
  801dfc:	c9                   	leaveq 
  801dfd:	c3                   	retq   

0000000000801dfe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	48 83 ec 08          	sub    $0x8,%rsp
  801e06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e0a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e0e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e15:	ff ff ff 
  801e18:	48 01 d0             	add    %rdx,%rax
  801e1b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e1f:	c9                   	leaveq 
  801e20:	c3                   	retq   

0000000000801e21 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e21:	55                   	push   %rbp
  801e22:	48 89 e5             	mov    %rsp,%rbp
  801e25:	48 83 ec 08          	sub    $0x8,%rsp
  801e29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e31:	48 89 c7             	mov    %rax,%rdi
  801e34:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e46:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 18          	sub    $0x18,%rsp
  801e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e5f:	eb 6b                	jmp    801ecc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e64:	48 98                	cltq   
  801e66:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e6c:	48 c1 e0 0c          	shl    $0xc,%rax
  801e70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e78:	48 c1 e8 15          	shr    $0x15,%rax
  801e7c:	48 89 c2             	mov    %rax,%rdx
  801e7f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e86:	01 00 00 
  801e89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8d:	83 e0 01             	and    $0x1,%eax
  801e90:	48 85 c0             	test   %rax,%rax
  801e93:	74 21                	je     801eb6 <fd_alloc+0x6a>
  801e95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e99:	48 c1 e8 0c          	shr    $0xc,%rax
  801e9d:	48 89 c2             	mov    %rax,%rdx
  801ea0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea7:	01 00 00 
  801eaa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eae:	83 e0 01             	and    $0x1,%eax
  801eb1:	48 85 c0             	test   %rax,%rax
  801eb4:	75 12                	jne    801ec8 <fd_alloc+0x7c>
			*fd_store = fd;
  801eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ebe:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec6:	eb 1a                	jmp    801ee2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ec8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ecc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ed0:	7e 8f                	jle    801e61 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801edd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ee2:	c9                   	leaveq 
  801ee3:	c3                   	retq   

0000000000801ee4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ee4:	55                   	push   %rbp
  801ee5:	48 89 e5             	mov    %rsp,%rbp
  801ee8:	48 83 ec 20          	sub    $0x20,%rsp
  801eec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ef3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef7:	78 06                	js     801eff <fd_lookup+0x1b>
  801ef9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801efd:	7e 07                	jle    801f06 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f04:	eb 6c                	jmp    801f72 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f09:	48 98                	cltq   
  801f0b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f11:	48 c1 e0 0c          	shl    $0xc,%rax
  801f15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1d:	48 c1 e8 15          	shr    $0x15,%rax
  801f21:	48 89 c2             	mov    %rax,%rdx
  801f24:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f2b:	01 00 00 
  801f2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f32:	83 e0 01             	and    $0x1,%eax
  801f35:	48 85 c0             	test   %rax,%rax
  801f38:	74 21                	je     801f5b <fd_lookup+0x77>
  801f3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f42:	48 89 c2             	mov    %rax,%rdx
  801f45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f4c:	01 00 00 
  801f4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f53:	83 e0 01             	and    $0x1,%eax
  801f56:	48 85 c0             	test   %rax,%rax
  801f59:	75 07                	jne    801f62 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f60:	eb 10                	jmp    801f72 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f66:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f6a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f72:	c9                   	leaveq 
  801f73:	c3                   	retq   

0000000000801f74 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f74:	55                   	push   %rbp
  801f75:	48 89 e5             	mov    %rsp,%rbp
  801f78:	48 83 ec 30          	sub    $0x30,%rsp
  801f7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f80:	89 f0                	mov    %esi,%eax
  801f82:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f89:	48 89 c7             	mov    %rax,%rdi
  801f8c:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	89 c2                	mov    %eax,%edx
  801f9a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f9e:	48 89 c6             	mov    %rax,%rsi
  801fa1:	89 d7                	mov    %edx,%edi
  801fa3:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
  801faf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb6:	78 0a                	js     801fc2 <fd_close+0x4e>
	    || fd != fd2)
  801fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fc0:	74 12                	je     801fd4 <fd_close+0x60>
		return (must_exist ? r : 0);
  801fc2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fc6:	74 05                	je     801fcd <fd_close+0x59>
  801fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcb:	eb 70                	jmp    80203d <fd_close+0xc9>
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	eb 69                	jmp    80203d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd8:	8b 00                	mov    (%rax),%eax
  801fda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fde:	48 89 d6             	mov    %rdx,%rsi
  801fe1:	89 c7                	mov    %eax,%edi
  801fe3:	48 b8 3f 20 80 00 00 	movabs $0x80203f,%rax
  801fea:	00 00 00 
  801fed:	ff d0                	callq  *%rax
  801fef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff6:	78 2a                	js     802022 <fd_close+0xae>
		if (dev->dev_close)
  801ff8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffc:	48 8b 40 20          	mov    0x20(%rax),%rax
  802000:	48 85 c0             	test   %rax,%rax
  802003:	74 16                	je     80201b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802009:	48 8b 40 20          	mov    0x20(%rax),%rax
  80200d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802011:	48 89 d7             	mov    %rdx,%rdi
  802014:	ff d0                	callq  *%rax
  802016:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802019:	eb 07                	jmp    802022 <fd_close+0xae>
		else
			r = 0;
  80201b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802026:	48 89 c6             	mov    %rax,%rsi
  802029:	bf 00 00 00 00       	mov    $0x0,%edi
  80202e:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  802035:	00 00 00 
  802038:	ff d0                	callq  *%rax
	return r;
  80203a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80203d:	c9                   	leaveq 
  80203e:	c3                   	retq   

000000000080203f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80203f:	55                   	push   %rbp
  802040:	48 89 e5             	mov    %rsp,%rbp
  802043:	48 83 ec 20          	sub    $0x20,%rsp
  802047:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80204a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80204e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802055:	eb 41                	jmp    802098 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802057:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80205e:	00 00 00 
  802061:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802064:	48 63 d2             	movslq %edx,%rdx
  802067:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206b:	8b 00                	mov    (%rax),%eax
  80206d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802070:	75 22                	jne    802094 <dev_lookup+0x55>
			*dev = devtab[i];
  802072:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802079:	00 00 00 
  80207c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80207f:	48 63 d2             	movslq %edx,%rdx
  802082:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802086:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80208a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
  802092:	eb 60                	jmp    8020f4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802094:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802098:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80209f:	00 00 00 
  8020a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020a5:	48 63 d2             	movslq %edx,%rdx
  8020a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ac:	48 85 c0             	test   %rax,%rax
  8020af:	75 a6                	jne    802057 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020b1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8020b8:	00 00 00 
  8020bb:	48 8b 00             	mov    (%rax),%rax
  8020be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c7:	89 c6                	mov    %eax,%esi
  8020c9:	48 bf 38 54 80 00 00 	movabs $0x805438,%rdi
  8020d0:	00 00 00 
  8020d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d8:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  8020df:	00 00 00 
  8020e2:	ff d1                	callq  *%rcx
	*dev = 0;
  8020e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020f4:	c9                   	leaveq 
  8020f5:	c3                   	retq   

00000000008020f6 <close>:

int
close(int fdnum)
{
  8020f6:	55                   	push   %rbp
  8020f7:	48 89 e5             	mov    %rsp,%rbp
  8020fa:	48 83 ec 20          	sub    $0x20,%rsp
  8020fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802101:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802105:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802108:	48 89 d6             	mov    %rdx,%rsi
  80210b:	89 c7                	mov    %eax,%edi
  80210d:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  802114:	00 00 00 
  802117:	ff d0                	callq  *%rax
  802119:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802120:	79 05                	jns    802127 <close+0x31>
		return r;
  802122:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802125:	eb 18                	jmp    80213f <close+0x49>
	else
		return fd_close(fd, 1);
  802127:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212b:	be 01 00 00 00       	mov    $0x1,%esi
  802130:	48 89 c7             	mov    %rax,%rdi
  802133:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
}
  80213f:	c9                   	leaveq 
  802140:	c3                   	retq   

0000000000802141 <close_all>:

void
close_all(void)
{
  802141:	55                   	push   %rbp
  802142:	48 89 e5             	mov    %rsp,%rbp
  802145:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802150:	eb 15                	jmp    802167 <close_all+0x26>
		close(i);
  802152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802155:	89 c7                	mov    %eax,%edi
  802157:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  80215e:	00 00 00 
  802161:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802163:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802167:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80216b:	7e e5                	jle    802152 <close_all+0x11>
		close(i);
}
  80216d:	90                   	nop
  80216e:	c9                   	leaveq 
  80216f:	c3                   	retq   

0000000000802170 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802170:	55                   	push   %rbp
  802171:	48 89 e5             	mov    %rsp,%rbp
  802174:	48 83 ec 40          	sub    $0x40,%rsp
  802178:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80217b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80217e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802182:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802185:	48 89 d6             	mov    %rdx,%rsi
  802188:	89 c7                	mov    %eax,%edi
  80218a:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219d:	79 08                	jns    8021a7 <dup+0x37>
		return r;
  80219f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a2:	e9 70 01 00 00       	jmpq   802317 <dup+0x1a7>
	close(newfdnum);
  8021a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021aa:	89 c7                	mov    %eax,%edi
  8021ac:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021b8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021bb:	48 98                	cltq   
  8021bd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021c3:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cf:	48 89 c7             	mov    %rax,%rdi
  8021d2:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	callq  *%rax
  8021de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e6:	48 89 c7             	mov    %rax,%rdi
  8021e9:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
  8021f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fd:	48 c1 e8 15          	shr    $0x15,%rax
  802201:	48 89 c2             	mov    %rax,%rdx
  802204:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80220b:	01 00 00 
  80220e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802212:	83 e0 01             	and    $0x1,%eax
  802215:	48 85 c0             	test   %rax,%rax
  802218:	74 71                	je     80228b <dup+0x11b>
  80221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221e:	48 c1 e8 0c          	shr    $0xc,%rax
  802222:	48 89 c2             	mov    %rax,%rdx
  802225:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222c:	01 00 00 
  80222f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802233:	83 e0 01             	and    $0x1,%eax
  802236:	48 85 c0             	test   %rax,%rax
  802239:	74 50                	je     80228b <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223f:	48 c1 e8 0c          	shr    $0xc,%rax
  802243:	48 89 c2             	mov    %rax,%rdx
  802246:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224d:	01 00 00 
  802250:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802254:	25 07 0e 00 00       	and    $0xe07,%eax
  802259:	89 c1                	mov    %eax,%ecx
  80225b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80225f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802263:	41 89 c8             	mov    %ecx,%r8d
  802266:	48 89 d1             	mov    %rdx,%rcx
  802269:	ba 00 00 00 00       	mov    $0x0,%edx
  80226e:	48 89 c6             	mov    %rax,%rsi
  802271:	bf 00 00 00 00       	mov    $0x0,%edi
  802276:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  80227d:	00 00 00 
  802280:	ff d0                	callq  *%rax
  802282:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802285:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802289:	78 55                	js     8022e0 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80228b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228f:	48 c1 e8 0c          	shr    $0xc,%rax
  802293:	48 89 c2             	mov    %rax,%rdx
  802296:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229d:	01 00 00 
  8022a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8022a9:	89 c1                	mov    %eax,%ecx
  8022ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b3:	41 89 c8             	mov    %ecx,%r8d
  8022b6:	48 89 d1             	mov    %rdx,%rcx
  8022b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022be:	48 89 c6             	mov    %rax,%rsi
  8022c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c6:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  8022cd:	00 00 00 
  8022d0:	ff d0                	callq  *%rax
  8022d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d9:	78 08                	js     8022e3 <dup+0x173>
		goto err;

	return newfdnum;
  8022db:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022de:	eb 37                	jmp    802317 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022e0:	90                   	nop
  8022e1:	eb 01                	jmp    8022e4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8022e3:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e8:	48 89 c6             	mov    %rax,%rsi
  8022eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f0:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802300:	48 89 c6             	mov    %rax,%rsi
  802303:	bf 00 00 00 00       	mov    $0x0,%edi
  802308:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80230f:	00 00 00 
  802312:	ff d0                	callq  *%rax
	return r;
  802314:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802317:	c9                   	leaveq 
  802318:	c3                   	retq   

0000000000802319 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802319:	55                   	push   %rbp
  80231a:	48 89 e5             	mov    %rsp,%rbp
  80231d:	48 83 ec 40          	sub    $0x40,%rsp
  802321:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802324:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802328:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80232c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802330:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802333:	48 89 d6             	mov    %rdx,%rsi
  802336:	89 c7                	mov    %eax,%edi
  802338:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802347:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234b:	78 24                	js     802371 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80234d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802351:	8b 00                	mov    (%rax),%eax
  802353:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802357:	48 89 d6             	mov    %rdx,%rsi
  80235a:	89 c7                	mov    %eax,%edi
  80235c:	48 b8 3f 20 80 00 00 	movabs $0x80203f,%rax
  802363:	00 00 00 
  802366:	ff d0                	callq  *%rax
  802368:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236f:	79 05                	jns    802376 <read+0x5d>
		return r;
  802371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802374:	eb 76                	jmp    8023ec <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237a:	8b 40 08             	mov    0x8(%rax),%eax
  80237d:	83 e0 03             	and    $0x3,%eax
  802380:	83 f8 01             	cmp    $0x1,%eax
  802383:	75 3a                	jne    8023bf <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802385:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80238c:	00 00 00 
  80238f:	48 8b 00             	mov    (%rax),%rax
  802392:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802398:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80239b:	89 c6                	mov    %eax,%esi
  80239d:	48 bf 57 54 80 00 00 	movabs $0x805457,%rdi
  8023a4:	00 00 00 
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  8023b3:	00 00 00 
  8023b6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023bd:	eb 2d                	jmp    8023ec <read+0xd3>
	}
	if (!dev->dev_read)
  8023bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023c7:	48 85 c0             	test   %rax,%rax
  8023ca:	75 07                	jne    8023d3 <read+0xba>
		return -E_NOT_SUPP;
  8023cc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023d1:	eb 19                	jmp    8023ec <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023df:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023e3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e7:	48 89 cf             	mov    %rcx,%rdi
  8023ea:	ff d0                	callq  *%rax
}
  8023ec:	c9                   	leaveq 
  8023ed:	c3                   	retq   

00000000008023ee <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	48 83 ec 30          	sub    $0x30,%rsp
  8023f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802408:	eb 47                	jmp    802451 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80240a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240d:	48 98                	cltq   
  80240f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802413:	48 29 c2             	sub    %rax,%rdx
  802416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802419:	48 63 c8             	movslq %eax,%rcx
  80241c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802420:	48 01 c1             	add    %rax,%rcx
  802423:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802426:	48 89 ce             	mov    %rcx,%rsi
  802429:	89 c7                	mov    %eax,%edi
  80242b:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802432:	00 00 00 
  802435:	ff d0                	callq  *%rax
  802437:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80243a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80243e:	79 05                	jns    802445 <readn+0x57>
			return m;
  802440:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802443:	eb 1d                	jmp    802462 <readn+0x74>
		if (m == 0)
  802445:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802449:	74 13                	je     80245e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80244b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80244e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802454:	48 98                	cltq   
  802456:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80245a:	72 ae                	jb     80240a <readn+0x1c>
  80245c:	eb 01                	jmp    80245f <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80245e:	90                   	nop
	}
	return tot;
  80245f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802462:	c9                   	leaveq 
  802463:	c3                   	retq   

0000000000802464 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
  802468:	48 83 ec 40          	sub    $0x40,%rsp
  80246c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80246f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802473:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802477:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80247b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80247e:	48 89 d6             	mov    %rdx,%rsi
  802481:	89 c7                	mov    %eax,%edi
  802483:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802496:	78 24                	js     8024bc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249c:	8b 00                	mov    (%rax),%eax
  80249e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a2:	48 89 d6             	mov    %rdx,%rsi
  8024a5:	89 c7                	mov    %eax,%edi
  8024a7:	48 b8 3f 20 80 00 00 	movabs $0x80203f,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax
  8024b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ba:	79 05                	jns    8024c1 <write+0x5d>
		return r;
  8024bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bf:	eb 75                	jmp    802536 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c5:	8b 40 08             	mov    0x8(%rax),%eax
  8024c8:	83 e0 03             	and    $0x3,%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	75 3a                	jne    802509 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024cf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024d6:	00 00 00 
  8024d9:	48 8b 00             	mov    (%rax),%rax
  8024dc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024e2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	48 bf 73 54 80 00 00 	movabs $0x805473,%rdi
  8024ee:	00 00 00 
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f6:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  8024fd:	00 00 00 
  802500:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802507:	eb 2d                	jmp    802536 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802511:	48 85 c0             	test   %rax,%rax
  802514:	75 07                	jne    80251d <write+0xb9>
		return -E_NOT_SUPP;
  802516:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80251b:	eb 19                	jmp    802536 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80251d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802521:	48 8b 40 18          	mov    0x18(%rax),%rax
  802525:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802529:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80252d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802531:	48 89 cf             	mov    %rcx,%rdi
  802534:	ff d0                	callq  *%rax
}
  802536:	c9                   	leaveq 
  802537:	c3                   	retq   

0000000000802538 <seek>:

int
seek(int fdnum, off_t offset)
{
  802538:	55                   	push   %rbp
  802539:	48 89 e5             	mov    %rsp,%rbp
  80253c:	48 83 ec 18          	sub    $0x18,%rsp
  802540:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802543:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802546:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80254a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80254d:	48 89 d6             	mov    %rdx,%rsi
  802550:	89 c7                	mov    %eax,%edi
  802552:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  802559:	00 00 00 
  80255c:	ff d0                	callq  *%rax
  80255e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802565:	79 05                	jns    80256c <seek+0x34>
		return r;
  802567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256a:	eb 0f                	jmp    80257b <seek+0x43>
	fd->fd_offset = offset;
  80256c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802570:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802573:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257b:	c9                   	leaveq 
  80257c:	c3                   	retq   

000000000080257d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80257d:	55                   	push   %rbp
  80257e:	48 89 e5             	mov    %rsp,%rbp
  802581:	48 83 ec 30          	sub    $0x30,%rsp
  802585:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802588:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80258b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80258f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802592:	48 89 d6             	mov    %rdx,%rsi
  802595:	89 c7                	mov    %eax,%edi
  802597:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025aa:	78 24                	js     8025d0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b0:	8b 00                	mov    (%rax),%eax
  8025b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b6:	48 89 d6             	mov    %rdx,%rsi
  8025b9:	89 c7                	mov    %eax,%edi
  8025bb:	48 b8 3f 20 80 00 00 	movabs $0x80203f,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	callq  *%rax
  8025c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ce:	79 05                	jns    8025d5 <ftruncate+0x58>
		return r;
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d3:	eb 72                	jmp    802647 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d9:	8b 40 08             	mov    0x8(%rax),%eax
  8025dc:	83 e0 03             	and    $0x3,%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	75 3a                	jne    80261d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025e3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025ea:	00 00 00 
  8025ed:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025f9:	89 c6                	mov    %eax,%esi
  8025fb:	48 bf 90 54 80 00 00 	movabs $0x805490,%rdi
  802602:	00 00 00 
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  802611:	00 00 00 
  802614:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802616:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80261b:	eb 2a                	jmp    802647 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80261d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802621:	48 8b 40 30          	mov    0x30(%rax),%rax
  802625:	48 85 c0             	test   %rax,%rax
  802628:	75 07                	jne    802631 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80262a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80262f:	eb 16                	jmp    802647 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802635:	48 8b 40 30          	mov    0x30(%rax),%rax
  802639:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80263d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802640:	89 ce                	mov    %ecx,%esi
  802642:	48 89 d7             	mov    %rdx,%rdi
  802645:	ff d0                	callq  *%rax
}
  802647:	c9                   	leaveq 
  802648:	c3                   	retq   

0000000000802649 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802649:	55                   	push   %rbp
  80264a:	48 89 e5             	mov    %rsp,%rbp
  80264d:	48 83 ec 30          	sub    $0x30,%rsp
  802651:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802654:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802658:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80265c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80265f:	48 89 d6             	mov    %rdx,%rsi
  802662:	89 c7                	mov    %eax,%edi
  802664:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	callq  *%rax
  802670:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802673:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802677:	78 24                	js     80269d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267d:	8b 00                	mov    (%rax),%eax
  80267f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802683:	48 89 d6             	mov    %rdx,%rsi
  802686:	89 c7                	mov    %eax,%edi
  802688:	48 b8 3f 20 80 00 00 	movabs $0x80203f,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
  802694:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802697:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269b:	79 05                	jns    8026a2 <fstat+0x59>
		return r;
  80269d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a0:	eb 5e                	jmp    802700 <fstat+0xb7>
	if (!dev->dev_stat)
  8026a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026aa:	48 85 c0             	test   %rax,%rax
  8026ad:	75 07                	jne    8026b6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026af:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026b4:	eb 4a                	jmp    802700 <fstat+0xb7>
	stat->st_name[0] = 0;
  8026b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ba:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026c8:	00 00 00 
	stat->st_isdir = 0;
  8026cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026cf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026d6:	00 00 00 
	stat->st_dev = dev;
  8026d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ec:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026f4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026f8:	48 89 ce             	mov    %rcx,%rsi
  8026fb:	48 89 d7             	mov    %rdx,%rdi
  8026fe:	ff d0                	callq  *%rax
}
  802700:	c9                   	leaveq 
  802701:	c3                   	retq   

0000000000802702 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802702:	55                   	push   %rbp
  802703:	48 89 e5             	mov    %rsp,%rbp
  802706:	48 83 ec 20          	sub    $0x20,%rsp
  80270a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802716:	be 00 00 00 00       	mov    $0x0,%esi
  80271b:	48 89 c7             	mov    %rax,%rdi
  80271e:	48 b8 f2 27 80 00 00 	movabs $0x8027f2,%rax
  802725:	00 00 00 
  802728:	ff d0                	callq  *%rax
  80272a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802731:	79 05                	jns    802738 <stat+0x36>
		return fd;
  802733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802736:	eb 2f                	jmp    802767 <stat+0x65>
	r = fstat(fd, stat);
  802738:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80273c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273f:	48 89 d6             	mov    %rdx,%rsi
  802742:	89 c7                	mov    %eax,%edi
  802744:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
  802750:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802756:	89 c7                	mov    %eax,%edi
  802758:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
	return r;
  802764:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 10          	sub    $0x10,%rsp
  802771:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802774:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802778:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80277f:	00 00 00 
  802782:	8b 00                	mov    (%rax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	75 1f                	jne    8027a7 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802788:	bf 01 00 00 00       	mov    $0x1,%edi
  80278d:	48 b8 e5 4c 80 00 00 	movabs $0x804ce5,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
  802799:	89 c2                	mov    %eax,%edx
  80279b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027a2:	00 00 00 
  8027a5:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027a7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ae:	00 00 00 
  8027b1:	8b 00                	mov    (%rax),%eax
  8027b3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027b6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027bb:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8027c2:	00 00 00 
  8027c5:	89 c7                	mov    %eax,%edi
  8027c7:	48 b8 d9 4a 80 00 00 	movabs $0x804ad9,%rax
  8027ce:	00 00 00 
  8027d1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027dc:	48 89 c6             	mov    %rax,%rsi
  8027df:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e4:	48 b8 18 4a 80 00 00 	movabs $0x804a18,%rax
  8027eb:	00 00 00 
  8027ee:	ff d0                	callq  *%rax
}
  8027f0:	c9                   	leaveq 
  8027f1:	c3                   	retq   

00000000008027f2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027f2:	55                   	push   %rbp
  8027f3:	48 89 e5             	mov    %rsp,%rbp
  8027f6:	48 83 ec 20          	sub    $0x20,%rsp
  8027fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027fe:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802805:	48 89 c7             	mov    %rax,%rdi
  802808:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
  802814:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802819:	7e 0a                	jle    802825 <open+0x33>
		return -E_BAD_PATH;
  80281b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802820:	e9 a5 00 00 00       	jmpq   8028ca <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802825:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802829:	48 89 c7             	mov    %rax,%rdi
  80282c:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802833:	00 00 00 
  802836:	ff d0                	callq  *%rax
  802838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283f:	79 08                	jns    802849 <open+0x57>
		return r;
  802841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802844:	e9 81 00 00 00       	jmpq   8028ca <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284d:	48 89 c6             	mov    %rax,%rsi
  802850:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802857:	00 00 00 
  80285a:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802866:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80286d:	00 00 00 
  802870:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802873:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287d:	48 89 c6             	mov    %rax,%rsi
  802880:	bf 01 00 00 00       	mov    $0x1,%edi
  802885:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax
  802891:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802894:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802898:	79 1d                	jns    8028b7 <open+0xc5>
		fd_close(fd, 0);
  80289a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289e:	be 00 00 00 00       	mov    $0x0,%esi
  8028a3:	48 89 c7             	mov    %rax,%rdi
  8028a6:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
		return r;
  8028b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b5:	eb 13                	jmp    8028ca <open+0xd8>
	}

	return fd2num(fd);
  8028b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bb:	48 89 c7             	mov    %rax,%rdi
  8028be:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax

}
  8028ca:	c9                   	leaveq 
  8028cb:	c3                   	retq   

00000000008028cc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028cc:	55                   	push   %rbp
  8028cd:	48 89 e5             	mov    %rsp,%rbp
  8028d0:	48 83 ec 10          	sub    $0x10,%rsp
  8028d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028dc:	8b 50 0c             	mov    0xc(%rax),%edx
  8028df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028e6:	00 00 00 
  8028e9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028eb:	be 00 00 00 00       	mov    $0x0,%esi
  8028f0:	bf 06 00 00 00       	mov    $0x6,%edi
  8028f5:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
}
  802901:	c9                   	leaveq 
  802902:	c3                   	retq   

0000000000802903 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802903:	55                   	push   %rbp
  802904:	48 89 e5             	mov    %rsp,%rbp
  802907:	48 83 ec 30          	sub    $0x30,%rsp
  80290b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80290f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802913:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291b:	8b 50 0c             	mov    0xc(%rax),%edx
  80291e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802925:	00 00 00 
  802928:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80292a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802931:	00 00 00 
  802934:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802938:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80293c:	be 00 00 00 00       	mov    $0x0,%esi
  802941:	bf 03 00 00 00       	mov    $0x3,%edi
  802946:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  80294d:	00 00 00 
  802950:	ff d0                	callq  *%rax
  802952:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802955:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802959:	79 08                	jns    802963 <devfile_read+0x60>
		return r;
  80295b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295e:	e9 a4 00 00 00       	jmpq   802a07 <devfile_read+0x104>
	assert(r <= n);
  802963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802966:	48 98                	cltq   
  802968:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80296c:	76 35                	jbe    8029a3 <devfile_read+0xa0>
  80296e:	48 b9 b6 54 80 00 00 	movabs $0x8054b6,%rcx
  802975:	00 00 00 
  802978:	48 ba bd 54 80 00 00 	movabs $0x8054bd,%rdx
  80297f:	00 00 00 
  802982:	be 86 00 00 00       	mov    $0x86,%esi
  802987:	48 bf d2 54 80 00 00 	movabs $0x8054d2,%rdi
  80298e:	00 00 00 
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  80299d:	00 00 00 
  8029a0:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8029a3:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8029aa:	7e 35                	jle    8029e1 <devfile_read+0xde>
  8029ac:	48 b9 dd 54 80 00 00 	movabs $0x8054dd,%rcx
  8029b3:	00 00 00 
  8029b6:	48 ba bd 54 80 00 00 	movabs $0x8054bd,%rdx
  8029bd:	00 00 00 
  8029c0:	be 87 00 00 00       	mov    $0x87,%esi
  8029c5:	48 bf d2 54 80 00 00 	movabs $0x8054d2,%rdi
  8029cc:	00 00 00 
  8029cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d4:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8029db:	00 00 00 
  8029de:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8029e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e4:	48 63 d0             	movslq %eax,%rdx
  8029e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029eb:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029f2:	00 00 00 
  8029f5:	48 89 c7             	mov    %rax,%rdi
  8029f8:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  8029ff:	00 00 00 
  802a02:	ff d0                	callq  *%rax
	return r;
  802a04:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802a07:	c9                   	leaveq 
  802a08:	c3                   	retq   

0000000000802a09 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a09:	55                   	push   %rbp
  802a0a:	48 89 e5             	mov    %rsp,%rbp
  802a0d:	48 83 ec 40          	sub    $0x40,%rsp
  802a11:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a19:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802a1d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a25:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802a2c:	00 
  802a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a31:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802a35:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802a3a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a42:	8b 50 0c             	mov    0xc(%rax),%edx
  802a45:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a4c:	00 00 00 
  802a4f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a51:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a58:	00 00 00 
  802a5b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a5f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a6b:	48 89 c6             	mov    %rax,%rsi
  802a6e:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802a75:	00 00 00 
  802a78:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a84:	be 00 00 00 00       	mov    $0x0,%esi
  802a89:	bf 04 00 00 00       	mov    $0x4,%edi
  802a8e:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
  802a9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802aa1:	79 05                	jns    802aa8 <devfile_write+0x9f>
		return r;
  802aa3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aa6:	eb 43                	jmp    802aeb <devfile_write+0xe2>
	assert(r <= n);
  802aa8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aab:	48 98                	cltq   
  802aad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ab1:	76 35                	jbe    802ae8 <devfile_write+0xdf>
  802ab3:	48 b9 b6 54 80 00 00 	movabs $0x8054b6,%rcx
  802aba:	00 00 00 
  802abd:	48 ba bd 54 80 00 00 	movabs $0x8054bd,%rdx
  802ac4:	00 00 00 
  802ac7:	be a2 00 00 00       	mov    $0xa2,%esi
  802acc:	48 bf d2 54 80 00 00 	movabs $0x8054d2,%rdi
  802ad3:	00 00 00 
  802ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  802adb:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  802ae2:	00 00 00 
  802ae5:	41 ff d0             	callq  *%r8
	return r;
  802ae8:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802aeb:	c9                   	leaveq 
  802aec:	c3                   	retq   

0000000000802aed <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802aed:	55                   	push   %rbp
  802aee:	48 89 e5             	mov    %rsp,%rbp
  802af1:	48 83 ec 20          	sub    $0x20,%rsp
  802af5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b01:	8b 50 0c             	mov    0xc(%rax),%edx
  802b04:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b0b:	00 00 00 
  802b0e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b10:	be 00 00 00 00       	mov    $0x0,%esi
  802b15:	bf 05 00 00 00       	mov    $0x5,%edi
  802b1a:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
  802b26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2d:	79 05                	jns    802b34 <devfile_stat+0x47>
		return r;
  802b2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b32:	eb 56                	jmp    802b8a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b38:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802b3f:	00 00 00 
  802b42:	48 89 c7             	mov    %rax,%rdi
  802b45:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b51:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b58:	00 00 00 
  802b5b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b65:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b6b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b72:	00 00 00 
  802b75:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b7f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b8a:	c9                   	leaveq 
  802b8b:	c3                   	retq   

0000000000802b8c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b8c:	55                   	push   %rbp
  802b8d:	48 89 e5             	mov    %rsp,%rbp
  802b90:	48 83 ec 10          	sub    $0x10,%rsp
  802b94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b98:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b9f:	8b 50 0c             	mov    0xc(%rax),%edx
  802ba2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ba9:	00 00 00 
  802bac:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bae:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bb5:	00 00 00 
  802bb8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bbb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bbe:	be 00 00 00 00       	mov    $0x0,%esi
  802bc3:	bf 02 00 00 00       	mov    $0x2,%edi
  802bc8:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
}
  802bd4:	c9                   	leaveq 
  802bd5:	c3                   	retq   

0000000000802bd6 <remove>:

// Delete a file
int
remove(const char *path)
{
  802bd6:	55                   	push   %rbp
  802bd7:	48 89 e5             	mov    %rsp,%rbp
  802bda:	48 83 ec 10          	sub    $0x10,%rsp
  802bde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be6:	48 89 c7             	mov    %rax,%rdi
  802be9:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bfa:	7e 07                	jle    802c03 <remove+0x2d>
		return -E_BAD_PATH;
  802bfc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c01:	eb 33                	jmp    802c36 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c07:	48 89 c6             	mov    %rax,%rsi
  802c0a:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802c11:	00 00 00 
  802c14:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c20:	be 00 00 00 00       	mov    $0x0,%esi
  802c25:	bf 07 00 00 00       	mov    $0x7,%edi
  802c2a:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
}
  802c36:	c9                   	leaveq 
  802c37:	c3                   	retq   

0000000000802c38 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c3c:	be 00 00 00 00       	mov    $0x0,%esi
  802c41:	bf 08 00 00 00       	mov    $0x8,%edi
  802c46:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
}
  802c52:	5d                   	pop    %rbp
  802c53:	c3                   	retq   

0000000000802c54 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c54:	55                   	push   %rbp
  802c55:	48 89 e5             	mov    %rsp,%rbp
  802c58:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c5f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c66:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c6d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c74:	be 00 00 00 00       	mov    $0x0,%esi
  802c79:	48 89 c7             	mov    %rax,%rdi
  802c7c:	48 b8 f2 27 80 00 00 	movabs $0x8027f2,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
  802c88:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8f:	79 28                	jns    802cb9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c94:	89 c6                	mov    %eax,%esi
  802c96:	48 bf e9 54 80 00 00 	movabs $0x8054e9,%rdi
  802c9d:	00 00 00 
  802ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca5:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802cac:	00 00 00 
  802caf:	ff d2                	callq  *%rdx
		return fd_src;
  802cb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb4:	e9 76 01 00 00       	jmpq   802e2f <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cb9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cc0:	be 01 01 00 00       	mov    $0x101,%esi
  802cc5:	48 89 c7             	mov    %rax,%rdi
  802cc8:	48 b8 f2 27 80 00 00 	movabs $0x8027f2,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802cd7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cdb:	0f 89 ad 00 00 00    	jns    802d8e <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ce1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce4:	89 c6                	mov    %eax,%esi
  802ce6:	48 bf ff 54 80 00 00 	movabs $0x8054ff,%rdi
  802ced:	00 00 00 
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802cfc:	00 00 00 
  802cff:	ff d2                	callq  *%rdx
		close(fd_src);
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d04:	89 c7                	mov    %eax,%edi
  802d06:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	callq  *%rax
		return fd_dest;
  802d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d15:	e9 15 01 00 00       	jmpq   802e2f <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802d1a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d1d:	48 63 d0             	movslq %eax,%rdx
  802d20:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d2a:	48 89 ce             	mov    %rcx,%rsi
  802d2d:	89 c7                	mov    %eax,%edi
  802d2f:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  802d36:	00 00 00 
  802d39:	ff d0                	callq  *%rax
  802d3b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d42:	79 4a                	jns    802d8e <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802d44:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d47:	89 c6                	mov    %eax,%esi
  802d49:	48 bf 19 55 80 00 00 	movabs $0x805519,%rdi
  802d50:	00 00 00 
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802d5f:	00 00 00 
  802d62:	ff d2                	callq  *%rdx
			close(fd_src);
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
			close(fd_dest);
  802d75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d78:	89 c7                	mov    %eax,%edi
  802d7a:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
			return write_size;
  802d86:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d89:	e9 a1 00 00 00       	jmpq   802e2f <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d8e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	ba 00 02 00 00       	mov    $0x200,%edx
  802d9d:	48 89 ce             	mov    %rcx,%rsi
  802da0:	89 c7                	mov    %eax,%edi
  802da2:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802db5:	0f 8f 5f ff ff ff    	jg     802d1a <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dbf:	79 47                	jns    802e08 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802dc1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dc4:	89 c6                	mov    %eax,%esi
  802dc6:	48 bf 2c 55 80 00 00 	movabs $0x80552c,%rdi
  802dcd:	00 00 00 
  802dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd5:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802ddc:	00 00 00 
  802ddf:	ff d2                	callq  *%rdx
		close(fd_src);
  802de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de4:	89 c7                	mov    %eax,%edi
  802de6:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
		close(fd_dest);
  802df2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802df5:	89 c7                	mov    %eax,%edi
  802df7:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
		return read_size;
  802e03:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e06:	eb 27                	jmp    802e2f <copy+0x1db>
	}
	close(fd_src);
  802e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0b:	89 c7                	mov    %eax,%edi
  802e0d:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	callq  *%rax
	close(fd_dest);
  802e19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e1c:	89 c7                	mov    %eax,%edi
  802e1e:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802e25:	00 00 00 
  802e28:	ff d0                	callq  *%rax
	return 0;
  802e2a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e2f:	c9                   	leaveq 
  802e30:	c3                   	retq   

0000000000802e31 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802e31:	55                   	push   %rbp
  802e32:	48 89 e5             	mov    %rsp,%rbp
  802e35:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802e3c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802e43:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802e4a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802e51:	be 00 00 00 00       	mov    $0x0,%esi
  802e56:	48 89 c7             	mov    %rax,%rdi
  802e59:	48 b8 f2 27 80 00 00 	movabs $0x8027f2,%rax
  802e60:	00 00 00 
  802e63:	ff d0                	callq  *%rax
  802e65:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e68:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e6c:	79 08                	jns    802e76 <spawn+0x45>
		return r;
  802e6e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e71:	e9 11 03 00 00       	jmpq   803187 <spawn+0x356>
	fd = r;
  802e76:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e79:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802e7c:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802e83:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802e87:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802e8e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e91:	ba 00 02 00 00       	mov    $0x200,%edx
  802e96:	48 89 ce             	mov    %rcx,%rsi
  802e99:	89 c7                	mov    %eax,%edi
  802e9b:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
  802ea7:	3d 00 02 00 00       	cmp    $0x200,%eax
  802eac:	75 0d                	jne    802ebb <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb2:	8b 00                	mov    (%rax),%eax
  802eb4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802eb9:	74 43                	je     802efe <spawn+0xcd>
		close(fd);
  802ebb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ebe:	89 c7                	mov    %eax,%edi
  802ec0:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed0:	8b 00                	mov    (%rax),%eax
  802ed2:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802ed7:	89 c6                	mov    %eax,%esi
  802ed9:	48 bf 48 55 80 00 00 	movabs $0x805548,%rdi
  802ee0:	00 00 00 
  802ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee8:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  802eef:	00 00 00 
  802ef2:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802ef4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ef9:	e9 89 02 00 00       	jmpq   803187 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802efe:	b8 07 00 00 00       	mov    $0x7,%eax
  802f03:	cd 30                	int    $0x30
  802f05:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802f08:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802f0b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f12:	79 08                	jns    802f1c <spawn+0xeb>
		return r;
  802f14:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f17:	e9 6b 02 00 00       	jmpq   803187 <spawn+0x356>
	child = r;
  802f1c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f1f:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802f22:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f25:	25 ff 03 00 00       	and    $0x3ff,%eax
  802f2a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802f31:	00 00 00 
  802f34:	48 98                	cltq   
  802f36:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802f3d:	48 01 c2             	add    %rax,%rdx
  802f40:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802f47:	48 89 d6             	mov    %rdx,%rsi
  802f4a:	ba 18 00 00 00       	mov    $0x18,%edx
  802f4f:	48 89 c7             	mov    %rax,%rdi
  802f52:	48 89 d1             	mov    %rdx,%rcx
  802f55:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802f58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f5c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f60:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802f67:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802f6e:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802f75:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802f7c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f7f:	48 89 ce             	mov    %rcx,%rsi
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	48 b8 eb 33 80 00 00 	movabs $0x8033eb,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
  802f90:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f93:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f97:	79 08                	jns    802fa1 <spawn+0x170>
		return r;
  802f99:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f9c:	e9 e6 01 00 00       	jmpq   803187 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa5:	48 8b 40 20          	mov    0x20(%rax),%rax
  802fa9:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802fb0:	48 01 d0             	add    %rdx,%rax
  802fb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802fb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fbe:	e9 80 00 00 00       	jmpq   803043 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  802fc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc7:	8b 00                	mov    (%rax),%eax
  802fc9:	83 f8 01             	cmp    $0x1,%eax
  802fcc:	75 6b                	jne    803039 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  802fce:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd9:	8b 40 04             	mov    0x4(%rax),%eax
  802fdc:	83 e0 02             	and    $0x2,%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 04                	je     802fe7 <spawn+0x1b6>
			perm |= PTE_W;
  802fe3:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802feb:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802fef:	41 89 c1             	mov    %eax,%r9d
  802ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff6:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffe:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803006:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80300a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80300d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803010:	48 83 ec 08          	sub    $0x8,%rsp
  803014:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803017:	57                   	push   %rdi
  803018:	89 c7                	mov    %eax,%edi
  80301a:	48 b8 97 36 80 00 00 	movabs $0x803697,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
  803026:	48 83 c4 10          	add    $0x10,%rsp
  80302a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80302d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803031:	0f 88 2a 01 00 00    	js     803161 <spawn+0x330>
  803037:	eb 01                	jmp    80303a <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803039:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80303a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80303e:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803043:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803047:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80304b:	0f b7 c0             	movzwl %ax,%eax
  80304e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803051:	0f 8f 6c ff ff ff    	jg     802fc3 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803057:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80305a:	89 c7                	mov    %eax,%edi
  80305c:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
	fd = -1;
  803068:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80306f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 83 38 80 00 00 	movabs $0x803883,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
  803080:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803083:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803087:	79 30                	jns    8030b9 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  803089:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80308c:	89 c1                	mov    %eax,%ecx
  80308e:	48 ba 62 55 80 00 00 	movabs $0x805562,%rdx
  803095:	00 00 00 
  803098:	be 86 00 00 00       	mov    $0x86,%esi
  80309d:	48 bf 78 55 80 00 00 	movabs $0x805578,%rdi
  8030a4:	00 00 00 
  8030a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ac:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8030b3:	00 00 00 
  8030b6:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8030b9:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8030c0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030c3:	48 89 d6             	mov    %rdx,%rsi
  8030c6:	89 c7                	mov    %eax,%edi
  8030c8:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8030d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8030db:	79 30                	jns    80310d <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  8030dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030e0:	89 c1                	mov    %eax,%ecx
  8030e2:	48 ba 84 55 80 00 00 	movabs $0x805584,%rdx
  8030e9:	00 00 00 
  8030ec:	be 8a 00 00 00       	mov    $0x8a,%esi
  8030f1:	48 bf 78 55 80 00 00 	movabs $0x805578,%rdi
  8030f8:	00 00 00 
  8030fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803100:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  803107:	00 00 00 
  80310a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80310d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803110:	be 02 00 00 00       	mov    $0x2,%esi
  803115:	89 c7                	mov    %eax,%edi
  803117:	48 b8 00 1b 80 00 00 	movabs $0x801b00,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803126:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80312a:	79 30                	jns    80315c <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  80312c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80312f:	89 c1                	mov    %eax,%ecx
  803131:	48 ba 9e 55 80 00 00 	movabs $0x80559e,%rdx
  803138:	00 00 00 
  80313b:	be 8d 00 00 00       	mov    $0x8d,%esi
  803140:	48 bf 78 55 80 00 00 	movabs $0x805578,%rdi
  803147:	00 00 00 
  80314a:	b8 00 00 00 00       	mov    $0x0,%eax
  80314f:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  803156:	00 00 00 
  803159:	41 ff d0             	callq  *%r8

	return child;
  80315c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80315f:	eb 26                	jmp    803187 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803161:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803162:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803165:	89 c7                	mov    %eax,%edi
  803167:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
	close(fd);
  803173:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803176:	89 c7                	mov    %eax,%edi
  803178:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
	return r;
  803184:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  803187:	c9                   	leaveq 
  803188:	c3                   	retq   

0000000000803189 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803189:	55                   	push   %rbp
  80318a:	48 89 e5             	mov    %rsp,%rbp
  80318d:	41 55                	push   %r13
  80318f:	41 54                	push   %r12
  803191:	53                   	push   %rbx
  803192:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803199:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8031a0:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  8031a7:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8031ae:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8031b5:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8031bc:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8031c3:	84 c0                	test   %al,%al
  8031c5:	74 26                	je     8031ed <spawnl+0x64>
  8031c7:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8031ce:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8031d5:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8031d9:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8031dd:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8031e1:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8031e5:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8031e9:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8031ed:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8031f4:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8031f7:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8031fe:	00 00 00 
  803201:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803208:	00 00 00 
  80320b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80320f:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803216:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80321d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803224:	eb 07                	jmp    80322d <spawnl+0xa4>
		argc++;
  803226:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80322d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803233:	83 f8 30             	cmp    $0x30,%eax
  803236:	73 23                	jae    80325b <spawnl+0xd2>
  803238:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80323f:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803245:	89 d2                	mov    %edx,%edx
  803247:	48 01 d0             	add    %rdx,%rax
  80324a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803250:	83 c2 08             	add    $0x8,%edx
  803253:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803259:	eb 12                	jmp    80326d <spawnl+0xe4>
  80325b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803262:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803266:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80326d:	48 8b 00             	mov    (%rax),%rax
  803270:	48 85 c0             	test   %rax,%rax
  803273:	75 b1                	jne    803226 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803275:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80327b:	83 c0 02             	add    $0x2,%eax
  80327e:	48 89 e2             	mov    %rsp,%rdx
  803281:	48 89 d3             	mov    %rdx,%rbx
  803284:	48 63 d0             	movslq %eax,%rdx
  803287:	48 83 ea 01          	sub    $0x1,%rdx
  80328b:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803292:	48 63 d0             	movslq %eax,%rdx
  803295:	49 89 d4             	mov    %rdx,%r12
  803298:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80329e:	48 63 d0             	movslq %eax,%rdx
  8032a1:	49 89 d2             	mov    %rdx,%r10
  8032a4:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8032aa:	48 98                	cltq   
  8032ac:	48 c1 e0 03          	shl    $0x3,%rax
  8032b0:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8032b4:	b8 10 00 00 00       	mov    $0x10,%eax
  8032b9:	48 83 e8 01          	sub    $0x1,%rax
  8032bd:	48 01 d0             	add    %rdx,%rax
  8032c0:	be 10 00 00 00       	mov    $0x10,%esi
  8032c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ca:	48 f7 f6             	div    %rsi
  8032cd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8032d1:	48 29 c4             	sub    %rax,%rsp
  8032d4:	48 89 e0             	mov    %rsp,%rax
  8032d7:	48 83 c0 07          	add    $0x7,%rax
  8032db:	48 c1 e8 03          	shr    $0x3,%rax
  8032df:	48 c1 e0 03          	shl    $0x3,%rax
  8032e3:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8032ea:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8032f1:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8032f8:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8032fb:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803301:	8d 50 01             	lea    0x1(%rax),%edx
  803304:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80330b:	48 63 d2             	movslq %edx,%rdx
  80330e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803315:	00 

	va_start(vl, arg0);
  803316:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80331d:	00 00 00 
  803320:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803327:	00 00 00 
  80332a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80332e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803335:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80333c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803343:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80334a:	00 00 00 
  80334d:	eb 60                	jmp    8033af <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  80334f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803355:	8d 48 01             	lea    0x1(%rax),%ecx
  803358:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80335e:	83 f8 30             	cmp    $0x30,%eax
  803361:	73 23                	jae    803386 <spawnl+0x1fd>
  803363:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80336a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803370:	89 d2                	mov    %edx,%edx
  803372:	48 01 d0             	add    %rdx,%rax
  803375:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80337b:	83 c2 08             	add    $0x8,%edx
  80337e:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803384:	eb 12                	jmp    803398 <spawnl+0x20f>
  803386:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80338d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803391:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803398:	48 8b 10             	mov    (%rax),%rdx
  80339b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8033a2:	89 c9                	mov    %ecx,%ecx
  8033a4:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8033a8:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8033af:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033b5:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  8033bb:	72 92                	jb     80334f <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8033bd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8033c4:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8033cb:	48 89 d6             	mov    %rdx,%rsi
  8033ce:	48 89 c7             	mov    %rax,%rdi
  8033d1:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
  8033dd:	48 89 dc             	mov    %rbx,%rsp
}
  8033e0:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8033e4:	5b                   	pop    %rbx
  8033e5:	41 5c                	pop    %r12
  8033e7:	41 5d                	pop    %r13
  8033e9:	5d                   	pop    %rbp
  8033ea:	c3                   	retq   

00000000008033eb <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 50          	sub    $0x50,%rsp
  8033f3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8033f6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8033fa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8033fe:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803405:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80340d:	eb 33                	jmp    803442 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80340f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803412:	48 98                	cltq   
  803414:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80341b:	00 
  80341c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803420:	48 01 d0             	add    %rdx,%rax
  803423:	48 8b 00             	mov    (%rax),%rax
  803426:	48 89 c7             	mov    %rax,%rdi
  803429:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	83 c0 01             	add    $0x1,%eax
  803438:	48 98                	cltq   
  80343a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80343e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803442:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803445:	48 98                	cltq   
  803447:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80344e:	00 
  80344f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803453:	48 01 d0             	add    %rdx,%rax
  803456:	48 8b 00             	mov    (%rax),%rax
  803459:	48 85 c0             	test   %rax,%rax
  80345c:	75 b1                	jne    80340f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80345e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803462:	48 f7 d8             	neg    %rax
  803465:	48 05 00 10 40 00    	add    $0x401000,%rax
  80346b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80346f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803473:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80347f:	48 89 c2             	mov    %rax,%rdx
  803482:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803485:	83 c0 01             	add    $0x1,%eax
  803488:	c1 e0 03             	shl    $0x3,%eax
  80348b:	48 98                	cltq   
  80348d:	48 f7 d8             	neg    %rax
  803490:	48 01 d0             	add    %rdx,%rax
  803493:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803497:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80349b:	48 83 e8 10          	sub    $0x10,%rax
  80349f:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8034a5:	77 0a                	ja     8034b1 <init_stack+0xc6>
		return -E_NO_MEM;
  8034a7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8034ac:	e9 e4 01 00 00       	jmpq   803695 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8034b1:	ba 07 00 00 00       	mov    $0x7,%edx
  8034b6:	be 00 00 40 00       	mov    $0x400000,%esi
  8034bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c0:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
  8034cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034d3:	79 08                	jns    8034dd <init_stack+0xf2>
		return r;
  8034d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d8:	e9 b8 01 00 00       	jmpq   803695 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8034dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8034e4:	e9 8a 00 00 00       	jmpq   803573 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  8034e9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034ec:	48 98                	cltq   
  8034ee:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034f5:	00 
  8034f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fa:	48 01 d0             	add    %rdx,%rax
  8034fd:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803502:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803506:	48 01 ca             	add    %rcx,%rdx
  803509:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803510:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803513:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803516:	48 98                	cltq   
  803518:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80351f:	00 
  803520:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803524:	48 01 d0             	add    %rdx,%rax
  803527:	48 8b 10             	mov    (%rax),%rdx
  80352a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80352e:	48 89 d6             	mov    %rdx,%rsi
  803531:	48 89 c7             	mov    %rax,%rdi
  803534:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  80353b:	00 00 00 
  80353e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803540:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803543:	48 98                	cltq   
  803545:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80354c:	00 
  80354d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803551:	48 01 d0             	add    %rdx,%rax
  803554:	48 8b 00             	mov    (%rax),%rax
  803557:	48 89 c7             	mov    %rax,%rdi
  80355a:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	83 c0 01             	add    $0x1,%eax
  803569:	48 98                	cltq   
  80356b:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80356f:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803573:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803576:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803579:	0f 8c 6a ff ff ff    	jl     8034e9 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80357f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803582:	48 98                	cltq   
  803584:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80358b:	00 
  80358c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803590:	48 01 d0             	add    %rdx,%rax
  803593:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80359a:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8035a1:	00 
  8035a2:	74 35                	je     8035d9 <init_stack+0x1ee>
  8035a4:	48 b9 b8 55 80 00 00 	movabs $0x8055b8,%rcx
  8035ab:	00 00 00 
  8035ae:	48 ba de 55 80 00 00 	movabs $0x8055de,%rdx
  8035b5:	00 00 00 
  8035b8:	be f6 00 00 00       	mov    $0xf6,%esi
  8035bd:	48 bf 78 55 80 00 00 	movabs $0x805578,%rdi
  8035c4:	00 00 00 
  8035c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cc:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8035d3:	00 00 00 
  8035d6:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8035d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035dd:	48 83 e8 08          	sub    $0x8,%rax
  8035e1:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8035e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8035ea:	48 01 ca             	add    %rcx,%rdx
  8035ed:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8035f4:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  8035f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035fb:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8035ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803602:	48 98                	cltq   
  803604:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803607:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80360c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803610:	48 01 d0             	add    %rdx,%rax
  803613:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803619:	48 89 c2             	mov    %rax,%rdx
  80361c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803620:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803623:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803626:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80362c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803631:	89 c2                	mov    %eax,%edx
  803633:	be 00 00 40 00       	mov    $0x400000,%esi
  803638:	bf 00 00 00 00       	mov    $0x0,%edi
  80363d:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80364c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803650:	78 26                	js     803678 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803652:	be 00 00 40 00       	mov    $0x400000,%esi
  803657:	bf 00 00 00 00       	mov    $0x0,%edi
  80365c:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
  803668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80366b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80366f:	78 0a                	js     80367b <init_stack+0x290>
		goto error;

	return 0;
  803671:	b8 00 00 00 00       	mov    $0x0,%eax
  803676:	eb 1d                	jmp    803695 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803678:	90                   	nop
  803679:	eb 01                	jmp    80367c <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  80367b:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80367c:	be 00 00 40 00       	mov    $0x400000,%esi
  803681:	bf 00 00 00 00       	mov    $0x0,%edi
  803686:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
	return r;
  803692:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803695:	c9                   	leaveq 
  803696:	c3                   	retq   

0000000000803697 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803697:	55                   	push   %rbp
  803698:	48 89 e5             	mov    %rsp,%rbp
  80369b:	48 83 ec 50          	sub    $0x50,%rsp
  80369f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8036a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036a6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8036aa:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8036ad:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8036b1:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8036b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8036be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c5:	74 21                	je     8036e8 <map_segment+0x51>
		va -= i;
  8036c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ca:	48 98                	cltq   
  8036cc:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8036d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d3:	48 98                	cltq   
  8036d5:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8036d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036dc:	48 98                	cltq   
  8036de:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8036e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e5:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8036e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036ef:	e9 79 01 00 00       	jmpq   80386d <map_segment+0x1d6>
		if (i >= filesz) {
  8036f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f7:	48 98                	cltq   
  8036f9:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8036fd:	72 3c                	jb     80373b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8036ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803702:	48 63 d0             	movslq %eax,%rdx
  803705:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803709:	48 01 d0             	add    %rdx,%rax
  80370c:	48 89 c1             	mov    %rax,%rcx
  80370f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803712:	8b 55 10             	mov    0x10(%rbp),%edx
  803715:	48 89 ce             	mov    %rcx,%rsi
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
  803726:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803729:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80372d:	0f 89 33 01 00 00    	jns    803866 <map_segment+0x1cf>
				return r;
  803733:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803736:	e9 46 01 00 00       	jmpq   803881 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80373b:	ba 07 00 00 00       	mov    $0x7,%edx
  803740:	be 00 00 40 00       	mov    $0x400000,%esi
  803745:	bf 00 00 00 00       	mov    $0x0,%edi
  80374a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803751:	00 00 00 
  803754:	ff d0                	callq  *%rax
  803756:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803759:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80375d:	79 08                	jns    803767 <map_segment+0xd0>
				return r;
  80375f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803762:	e9 1a 01 00 00       	jmpq   803881 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803767:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80376a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376d:	01 c2                	add    %eax,%edx
  80376f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803772:	89 d6                	mov    %edx,%esi
  803774:	89 c7                	mov    %eax,%edi
  803776:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  80377d:	00 00 00 
  803780:	ff d0                	callq  *%rax
  803782:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803785:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803789:	79 08                	jns    803793 <map_segment+0xfc>
				return r;
  80378b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80378e:	e9 ee 00 00 00       	jmpq   803881 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803793:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80379a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379d:	48 98                	cltq   
  80379f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8037a3:	48 29 c2             	sub    %rax,%rdx
  8037a6:	48 89 d0             	mov    %rdx,%rax
  8037a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8037ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037b0:	48 63 d0             	movslq %eax,%rdx
  8037b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b7:	48 39 c2             	cmp    %rax,%rdx
  8037ba:	48 0f 47 d0          	cmova  %rax,%rdx
  8037be:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8037c1:	be 00 00 40 00       	mov    $0x400000,%esi
  8037c6:	89 c7                	mov    %eax,%edi
  8037c8:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037db:	79 08                	jns    8037e5 <map_segment+0x14e>
				return r;
  8037dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037e0:	e9 9c 00 00 00       	jmpq   803881 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8037e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e8:	48 63 d0             	movslq %eax,%rdx
  8037eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ef:	48 01 d0             	add    %rdx,%rax
  8037f2:	48 89 c2             	mov    %rax,%rdx
  8037f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037f8:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8037fc:	48 89 d1             	mov    %rdx,%rcx
  8037ff:	89 c2                	mov    %eax,%edx
  803801:	be 00 00 40 00       	mov    $0x400000,%esi
  803806:	bf 00 00 00 00       	mov    $0x0,%edi
  80380b:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
  803817:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80381a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80381e:	79 30                	jns    803850 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803820:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803823:	89 c1                	mov    %eax,%ecx
  803825:	48 ba f3 55 80 00 00 	movabs $0x8055f3,%rdx
  80382c:	00 00 00 
  80382f:	be 29 01 00 00       	mov    $0x129,%esi
  803834:	48 bf 78 55 80 00 00 	movabs $0x805578,%rdi
  80383b:	00 00 00 
  80383e:	b8 00 00 00 00       	mov    $0x0,%eax
  803843:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  80384a:	00 00 00 
  80384d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803850:	be 00 00 40 00       	mov    $0x400000,%esi
  803855:	bf 00 00 00 00       	mov    $0x0,%edi
  80385a:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803866:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80386d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803870:	48 98                	cltq   
  803872:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803876:	0f 82 78 fe ff ff    	jb     8036f4 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80387c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803881:	c9                   	leaveq 
  803882:	c3                   	retq   

0000000000803883 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803883:	55                   	push   %rbp
  803884:	48 89 e5             	mov    %rsp,%rbp
  803887:	48 83 ec 30          	sub    $0x30,%rsp
  80388b:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80388e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803895:	00 
  803896:	e9 eb 00 00 00       	jmpq   803986 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  80389b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389f:	48 c1 f8 12          	sar    $0x12,%rax
  8038a3:	48 89 c2             	mov    %rax,%rdx
  8038a6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8038ad:	01 00 00 
  8038b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038b4:	83 e0 01             	and    $0x1,%eax
  8038b7:	48 85 c0             	test   %rax,%rax
  8038ba:	74 21                	je     8038dd <copy_shared_pages+0x5a>
  8038bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c0:	48 c1 f8 09          	sar    $0x9,%rax
  8038c4:	48 89 c2             	mov    %rax,%rdx
  8038c7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038ce:	01 00 00 
  8038d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038d5:	83 e0 01             	and    $0x1,%eax
  8038d8:	48 85 c0             	test   %rax,%rax
  8038db:	75 0d                	jne    8038ea <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  8038dd:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  8038e4:	00 
  8038e5:	e9 9c 00 00 00       	jmpq   803986 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  8038ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ee:	48 05 00 02 00 00    	add    $0x200,%rax
  8038f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  8038f8:	eb 7e                	jmp    803978 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  8038fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803901:	01 00 00 
  803904:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803908:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80390c:	25 01 04 00 00       	and    $0x401,%eax
  803911:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  803917:	75 5a                	jne    803973 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  803919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391d:	48 c1 e0 0c          	shl    $0xc,%rax
  803921:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  803925:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80392c:	01 00 00 
  80392f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803933:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803937:	25 07 0e 00 00       	and    $0xe07,%eax
  80393c:	89 c6                	mov    %eax,%esi
  80393e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803942:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803949:	41 89 f0             	mov    %esi,%r8d
  80394c:	48 89 c6             	mov    %rax,%rsi
  80394f:	bf 00 00 00 00       	mov    $0x0,%edi
  803954:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
  803960:	48 98                	cltq   
  803962:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  803966:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80396b:	79 06                	jns    803973 <copy_shared_pages+0xf0>
						return r;
  80396d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803971:	eb 28                	jmp    80399b <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803973:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803978:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803980:	0f 8c 74 ff ff ff    	jl     8038fa <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803986:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398a:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  803990:	0f 86 05 ff ff ff    	jbe    80389b <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803996:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80399b:	c9                   	leaveq 
  80399c:	c3                   	retq   

000000000080399d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80399d:	55                   	push   %rbp
  80399e:	48 89 e5             	mov    %rsp,%rbp
  8039a1:	48 83 ec 20          	sub    $0x20,%rsp
  8039a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8039a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039af:	48 89 d6             	mov    %rdx,%rsi
  8039b2:	89 c7                	mov    %eax,%edi
  8039b4:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
  8039c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c7:	79 05                	jns    8039ce <fd2sockid+0x31>
		return r;
  8039c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cc:	eb 24                	jmp    8039f2 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8039ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d2:	8b 10                	mov    (%rax),%edx
  8039d4:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8039db:	00 00 00 
  8039de:	8b 00                	mov    (%rax),%eax
  8039e0:	39 c2                	cmp    %eax,%edx
  8039e2:	74 07                	je     8039eb <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8039e4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8039e9:	eb 07                	jmp    8039f2 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8039eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ef:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8039f2:	c9                   	leaveq 
  8039f3:	c3                   	retq   

00000000008039f4 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8039f4:	55                   	push   %rbp
  8039f5:	48 89 e5             	mov    %rsp,%rbp
  8039f8:	48 83 ec 20          	sub    $0x20,%rsp
  8039fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8039ff:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a03:	48 89 c7             	mov    %rax,%rdi
  803a06:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  803a0d:	00 00 00 
  803a10:	ff d0                	callq  *%rax
  803a12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a19:	78 26                	js     803a41 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1f:	ba 07 04 00 00       	mov    $0x407,%edx
  803a24:	48 89 c6             	mov    %rax,%rsi
  803a27:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2c:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
  803a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3f:	79 16                	jns    803a57 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803a41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a44:	89 c7                	mov    %eax,%edi
  803a46:	48 b8 03 3f 80 00 00 	movabs $0x803f03,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
		return r;
  803a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a55:	eb 3a                	jmp    803a91 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803a57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5b:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803a62:	00 00 00 
  803a65:	8b 12                	mov    (%rdx),%edx
  803a67:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a6d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a78:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a7b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a82:	48 89 c7             	mov    %rax,%rdi
  803a85:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   

0000000000803a93 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a93:	55                   	push   %rbp
  803a94:	48 89 e5             	mov    %rsp,%rbp
  803a97:	48 83 ec 30          	sub    $0x30,%rsp
  803a9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803aa2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803aa6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aa9:	89 c7                	mov    %eax,%edi
  803aab:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
  803ab7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abe:	79 05                	jns    803ac5 <accept+0x32>
		return r;
  803ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac3:	eb 3b                	jmp    803b00 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803ac5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ac9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad0:	48 89 ce             	mov    %rcx,%rsi
  803ad3:	89 c7                	mov    %eax,%edi
  803ad5:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
  803ae1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae8:	79 05                	jns    803aef <accept+0x5c>
		return r;
  803aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aed:	eb 11                	jmp    803b00 <accept+0x6d>
	return alloc_sockfd(r);
  803aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af2:	89 c7                	mov    %eax,%edi
  803af4:	48 b8 f4 39 80 00 00 	movabs $0x8039f4,%rax
  803afb:	00 00 00 
  803afe:	ff d0                	callq  *%rax
}
  803b00:	c9                   	leaveq 
  803b01:	c3                   	retq   

0000000000803b02 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b02:	55                   	push   %rbp
  803b03:	48 89 e5             	mov    %rsp,%rbp
  803b06:	48 83 ec 20          	sub    $0x20,%rsp
  803b0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b11:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b17:	89 c7                	mov    %eax,%edi
  803b19:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  803b20:	00 00 00 
  803b23:	ff d0                	callq  *%rax
  803b25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b2c:	79 05                	jns    803b33 <bind+0x31>
		return r;
  803b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b31:	eb 1b                	jmp    803b4e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803b33:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b36:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3d:	48 89 ce             	mov    %rcx,%rsi
  803b40:	89 c7                	mov    %eax,%edi
  803b42:	48 b8 5f 3e 80 00 00 	movabs $0x803e5f,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
}
  803b4e:	c9                   	leaveq 
  803b4f:	c3                   	retq   

0000000000803b50 <shutdown>:

int
shutdown(int s, int how)
{
  803b50:	55                   	push   %rbp
  803b51:	48 89 e5             	mov    %rsp,%rbp
  803b54:	48 83 ec 20          	sub    $0x20,%rsp
  803b58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b5b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b61:	89 c7                	mov    %eax,%edi
  803b63:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
  803b6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b76:	79 05                	jns    803b7d <shutdown+0x2d>
		return r;
  803b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7b:	eb 16                	jmp    803b93 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803b7d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b83:	89 d6                	mov    %edx,%esi
  803b85:	89 c7                	mov    %eax,%edi
  803b87:	48 b8 c3 3e 80 00 00 	movabs $0x803ec3,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
}
  803b93:	c9                   	leaveq 
  803b94:	c3                   	retq   

0000000000803b95 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803b95:	55                   	push   %rbp
  803b96:	48 89 e5             	mov    %rsp,%rbp
  803b99:	48 83 ec 10          	sub    $0x10,%rsp
  803b9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803ba1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba5:	48 89 c7             	mov    %rax,%rdi
  803ba8:	48 b8 56 4d 80 00 00 	movabs $0x804d56,%rax
  803baf:	00 00 00 
  803bb2:	ff d0                	callq  *%rax
  803bb4:	83 f8 01             	cmp    $0x1,%eax
  803bb7:	75 17                	jne    803bd0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803bb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bbd:	8b 40 0c             	mov    0xc(%rax),%eax
  803bc0:	89 c7                	mov    %eax,%edi
  803bc2:	48 b8 03 3f 80 00 00 	movabs $0x803f03,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
  803bce:	eb 05                	jmp    803bd5 <devsock_close+0x40>
	else
		return 0;
  803bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bd5:	c9                   	leaveq 
  803bd6:	c3                   	retq   

0000000000803bd7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bd7:	55                   	push   %rbp
  803bd8:	48 89 e5             	mov    %rsp,%rbp
  803bdb:	48 83 ec 20          	sub    $0x20,%rsp
  803bdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803be2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803be6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803be9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bec:	89 c7                	mov    %eax,%edi
  803bee:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  803bf5:	00 00 00 
  803bf8:	ff d0                	callq  *%rax
  803bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c01:	79 05                	jns    803c08 <connect+0x31>
		return r;
  803c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c06:	eb 1b                	jmp    803c23 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803c08:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c0b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c12:	48 89 ce             	mov    %rcx,%rsi
  803c15:	89 c7                	mov    %eax,%edi
  803c17:	48 b8 30 3f 80 00 00 	movabs $0x803f30,%rax
  803c1e:	00 00 00 
  803c21:	ff d0                	callq  *%rax
}
  803c23:	c9                   	leaveq 
  803c24:	c3                   	retq   

0000000000803c25 <listen>:

int
listen(int s, int backlog)
{
  803c25:	55                   	push   %rbp
  803c26:	48 89 e5             	mov    %rsp,%rbp
  803c29:	48 83 ec 20          	sub    $0x20,%rsp
  803c2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c30:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c36:	89 c7                	mov    %eax,%edi
  803c38:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
  803c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c4b:	79 05                	jns    803c52 <listen+0x2d>
		return r;
  803c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c50:	eb 16                	jmp    803c68 <listen+0x43>
	return nsipc_listen(r, backlog);
  803c52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c58:	89 d6                	mov    %edx,%esi
  803c5a:	89 c7                	mov    %eax,%edi
  803c5c:	48 b8 94 3f 80 00 00 	movabs $0x803f94,%rax
  803c63:	00 00 00 
  803c66:	ff d0                	callq  *%rax
}
  803c68:	c9                   	leaveq 
  803c69:	c3                   	retq   

0000000000803c6a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c6a:	55                   	push   %rbp
  803c6b:	48 89 e5             	mov    %rsp,%rbp
  803c6e:	48 83 ec 20          	sub    $0x20,%rsp
  803c72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c82:	89 c2                	mov    %eax,%edx
  803c84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c88:	8b 40 0c             	mov    0xc(%rax),%eax
  803c8b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c94:	89 c7                	mov    %eax,%edi
  803c96:	48 b8 d4 3f 80 00 00 	movabs $0x803fd4,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
}
  803ca2:	c9                   	leaveq 
  803ca3:	c3                   	retq   

0000000000803ca4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 20          	sub    $0x20,%rsp
  803cac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cb4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cbc:	89 c2                	mov    %eax,%edx
  803cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc2:	8b 40 0c             	mov    0xc(%rax),%eax
  803cc5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803cc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  803cce:	89 c7                	mov    %eax,%edi
  803cd0:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  803cd7:	00 00 00 
  803cda:	ff d0                	callq  *%rax
}
  803cdc:	c9                   	leaveq 
  803cdd:	c3                   	retq   

0000000000803cde <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803cde:	55                   	push   %rbp
  803cdf:	48 89 e5             	mov    %rsp,%rbp
  803ce2:	48 83 ec 10          	sub    $0x10,%rsp
  803ce6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf2:	48 be 15 56 80 00 00 	movabs $0x805615,%rsi
  803cf9:	00 00 00 
  803cfc:	48 89 c7             	mov    %rax,%rdi
  803cff:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  803d06:	00 00 00 
  803d09:	ff d0                	callq  *%rax
	return 0;
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d10:	c9                   	leaveq 
  803d11:	c3                   	retq   

0000000000803d12 <socket>:

int
socket(int domain, int type, int protocol)
{
  803d12:	55                   	push   %rbp
  803d13:	48 89 e5             	mov    %rsp,%rbp
  803d16:	48 83 ec 20          	sub    $0x20,%rsp
  803d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d1d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d20:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803d23:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803d26:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2c:	89 ce                	mov    %ecx,%esi
  803d2e:	89 c7                	mov    %eax,%edi
  803d30:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
  803d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d43:	79 05                	jns    803d4a <socket+0x38>
		return r;
  803d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d48:	eb 11                	jmp    803d5b <socket+0x49>
	return alloc_sockfd(r);
  803d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4d:	89 c7                	mov    %eax,%edi
  803d4f:	48 b8 f4 39 80 00 00 	movabs $0x8039f4,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
}
  803d5b:	c9                   	leaveq 
  803d5c:	c3                   	retq   

0000000000803d5d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803d5d:	55                   	push   %rbp
  803d5e:	48 89 e5             	mov    %rsp,%rbp
  803d61:	48 83 ec 10          	sub    $0x10,%rsp
  803d65:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803d68:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d6f:	00 00 00 
  803d72:	8b 00                	mov    (%rax),%eax
  803d74:	85 c0                	test   %eax,%eax
  803d76:	75 1f                	jne    803d97 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803d78:	bf 02 00 00 00       	mov    $0x2,%edi
  803d7d:	48 b8 e5 4c 80 00 00 	movabs $0x804ce5,%rax
  803d84:	00 00 00 
  803d87:	ff d0                	callq  *%rax
  803d89:	89 c2                	mov    %eax,%edx
  803d8b:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d92:	00 00 00 
  803d95:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803d97:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d9e:	00 00 00 
  803da1:	8b 00                	mov    (%rax),%eax
  803da3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803da6:	b9 07 00 00 00       	mov    $0x7,%ecx
  803dab:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803db2:	00 00 00 
  803db5:	89 c7                	mov    %eax,%edi
  803db7:	48 b8 d9 4a 80 00 00 	movabs $0x804ad9,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  803dc8:	be 00 00 00 00       	mov    $0x0,%esi
  803dcd:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd2:	48 b8 18 4a 80 00 00 	movabs $0x804a18,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
}
  803dde:	c9                   	leaveq 
  803ddf:	c3                   	retq   

0000000000803de0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803de0:	55                   	push   %rbp
  803de1:	48 89 e5             	mov    %rsp,%rbp
  803de4:	48 83 ec 30          	sub    $0x30,%rsp
  803de8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803deb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803def:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803df3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfa:	00 00 00 
  803dfd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e00:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803e02:	bf 01 00 00 00       	mov    $0x1,%edi
  803e07:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
  803e13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1a:	78 3e                	js     803e5a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803e1c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e23:	00 00 00 
  803e26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2e:	8b 40 10             	mov    0x10(%rax),%eax
  803e31:	89 c2                	mov    %eax,%edx
  803e33:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803e37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e3b:	48 89 ce             	mov    %rcx,%rsi
  803e3e:	48 89 c7             	mov    %rax,%rdi
  803e41:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  803e48:	00 00 00 
  803e4b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e51:	8b 50 10             	mov    0x10(%rax),%edx
  803e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e58:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e5d:	c9                   	leaveq 
  803e5e:	c3                   	retq   

0000000000803e5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e5f:	55                   	push   %rbp
  803e60:	48 89 e5             	mov    %rsp,%rbp
  803e63:	48 83 ec 10          	sub    $0x10,%rsp
  803e67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e6e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803e71:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e78:	00 00 00 
  803e7b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e7e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e80:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e87:	48 89 c6             	mov    %rax,%rsi
  803e8a:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e91:	00 00 00 
  803e94:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  803e9b:	00 00 00 
  803e9e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ea0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ea7:	00 00 00 
  803eaa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ead:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803eb0:	bf 02 00 00 00       	mov    $0x2,%edi
  803eb5:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  803ebc:	00 00 00 
  803ebf:	ff d0                	callq  *%rax
}
  803ec1:	c9                   	leaveq 
  803ec2:	c3                   	retq   

0000000000803ec3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ec3:	55                   	push   %rbp
  803ec4:	48 89 e5             	mov    %rsp,%rbp
  803ec7:	48 83 ec 10          	sub    $0x10,%rsp
  803ecb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ece:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ed1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed8:	00 00 00 
  803edb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ede:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ee0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ee7:	00 00 00 
  803eea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803eed:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803ef0:	bf 03 00 00 00       	mov    $0x3,%edi
  803ef5:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  803efc:	00 00 00 
  803eff:	ff d0                	callq  *%rax
}
  803f01:	c9                   	leaveq 
  803f02:	c3                   	retq   

0000000000803f03 <nsipc_close>:

int
nsipc_close(int s)
{
  803f03:	55                   	push   %rbp
  803f04:	48 89 e5             	mov    %rsp,%rbp
  803f07:	48 83 ec 10          	sub    $0x10,%rsp
  803f0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803f0e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f15:	00 00 00 
  803f18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f1b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803f1d:	bf 04 00 00 00       	mov    $0x4,%edi
  803f22:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  803f29:	00 00 00 
  803f2c:	ff d0                	callq  *%rax
}
  803f2e:	c9                   	leaveq 
  803f2f:	c3                   	retq   

0000000000803f30 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803f30:	55                   	push   %rbp
  803f31:	48 89 e5             	mov    %rsp,%rbp
  803f34:	48 83 ec 10          	sub    $0x10,%rsp
  803f38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f3f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803f42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f49:	00 00 00 
  803f4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f4f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803f51:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f58:	48 89 c6             	mov    %rax,%rsi
  803f5b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803f62:	00 00 00 
  803f65:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  803f6c:	00 00 00 
  803f6f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803f71:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f78:	00 00 00 
  803f7b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f7e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803f81:	bf 05 00 00 00       	mov    $0x5,%edi
  803f86:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  803f8d:	00 00 00 
  803f90:	ff d0                	callq  *%rax
}
  803f92:	c9                   	leaveq 
  803f93:	c3                   	retq   

0000000000803f94 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803f94:	55                   	push   %rbp
  803f95:	48 89 e5             	mov    %rsp,%rbp
  803f98:	48 83 ec 10          	sub    $0x10,%rsp
  803f9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f9f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803fa2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa9:	00 00 00 
  803fac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803faf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803fb1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fb8:	00 00 00 
  803fbb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fbe:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803fc1:	bf 06 00 00 00       	mov    $0x6,%edi
  803fc6:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  803fcd:	00 00 00 
  803fd0:	ff d0                	callq  *%rax
}
  803fd2:	c9                   	leaveq 
  803fd3:	c3                   	retq   

0000000000803fd4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803fd4:	55                   	push   %rbp
  803fd5:	48 89 e5             	mov    %rsp,%rbp
  803fd8:	48 83 ec 30          	sub    $0x30,%rsp
  803fdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fe3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803fe6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803fe9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ff0:	00 00 00 
  803ff3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ff6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ff8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fff:	00 00 00 
  804002:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804005:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804008:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80400f:	00 00 00 
  804012:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804015:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804018:	bf 07 00 00 00       	mov    $0x7,%edi
  80401d:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  804024:	00 00 00 
  804027:	ff d0                	callq  *%rax
  804029:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80402c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804030:	78 69                	js     80409b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804032:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804039:	7f 08                	jg     804043 <nsipc_recv+0x6f>
  80403b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804041:	7e 35                	jle    804078 <nsipc_recv+0xa4>
  804043:	48 b9 1c 56 80 00 00 	movabs $0x80561c,%rcx
  80404a:	00 00 00 
  80404d:	48 ba 31 56 80 00 00 	movabs $0x805631,%rdx
  804054:	00 00 00 
  804057:	be 62 00 00 00       	mov    $0x62,%esi
  80405c:	48 bf 46 56 80 00 00 	movabs $0x805646,%rdi
  804063:	00 00 00 
  804066:	b8 00 00 00 00       	mov    $0x0,%eax
  80406b:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  804072:	00 00 00 
  804075:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80407b:	48 63 d0             	movslq %eax,%rdx
  80407e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804082:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804089:	00 00 00 
  80408c:	48 89 c7             	mov    %rax,%rdi
  80408f:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  804096:	00 00 00 
  804099:	ff d0                	callq  *%rax
	}

	return r;
  80409b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80409e:	c9                   	leaveq 
  80409f:	c3                   	retq   

00000000008040a0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8040a0:	55                   	push   %rbp
  8040a1:	48 89 e5             	mov    %rsp,%rbp
  8040a4:	48 83 ec 20          	sub    $0x20,%rsp
  8040a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040af:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8040b2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8040b5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040bc:	00 00 00 
  8040bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040c2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8040c4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8040cb:	7e 35                	jle    804102 <nsipc_send+0x62>
  8040cd:	48 b9 52 56 80 00 00 	movabs $0x805652,%rcx
  8040d4:	00 00 00 
  8040d7:	48 ba 31 56 80 00 00 	movabs $0x805631,%rdx
  8040de:	00 00 00 
  8040e1:	be 6d 00 00 00       	mov    $0x6d,%esi
  8040e6:	48 bf 46 56 80 00 00 	movabs $0x805646,%rdi
  8040ed:	00 00 00 
  8040f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f5:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8040fc:	00 00 00 
  8040ff:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804102:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804105:	48 63 d0             	movslq %eax,%rdx
  804108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410c:	48 89 c6             	mov    %rax,%rsi
  80410f:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804116:	00 00 00 
  804119:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  804120:	00 00 00 
  804123:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804125:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80412c:	00 00 00 
  80412f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804132:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804135:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80413c:	00 00 00 
  80413f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804142:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804145:	bf 08 00 00 00       	mov    $0x8,%edi
  80414a:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  804151:	00 00 00 
  804154:	ff d0                	callq  *%rax
}
  804156:	c9                   	leaveq 
  804157:	c3                   	retq   

0000000000804158 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804158:	55                   	push   %rbp
  804159:	48 89 e5             	mov    %rsp,%rbp
  80415c:	48 83 ec 10          	sub    $0x10,%rsp
  804160:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804163:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804166:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804169:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804170:	00 00 00 
  804173:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804176:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804178:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80417f:	00 00 00 
  804182:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804185:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804188:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80418f:	00 00 00 
  804192:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804195:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804198:	bf 09 00 00 00       	mov    $0x9,%edi
  80419d:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  8041a4:	00 00 00 
  8041a7:	ff d0                	callq  *%rax
}
  8041a9:	c9                   	leaveq 
  8041aa:	c3                   	retq   

00000000008041ab <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8041ab:	55                   	push   %rbp
  8041ac:	48 89 e5             	mov    %rsp,%rbp
  8041af:	53                   	push   %rbx
  8041b0:	48 83 ec 38          	sub    $0x38,%rsp
  8041b4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8041b8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8041bc:	48 89 c7             	mov    %rax,%rdi
  8041bf:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8041c6:	00 00 00 
  8041c9:	ff d0                	callq  *%rax
  8041cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041d2:	0f 88 bf 01 00 00    	js     804397 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8041e1:	48 89 c6             	mov    %rax,%rsi
  8041e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8041e9:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8041f0:	00 00 00 
  8041f3:	ff d0                	callq  *%rax
  8041f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041fc:	0f 88 95 01 00 00    	js     804397 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804202:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804206:	48 89 c7             	mov    %rax,%rdi
  804209:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  804210:	00 00 00 
  804213:	ff d0                	callq  *%rax
  804215:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804218:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80421c:	0f 88 5d 01 00 00    	js     80437f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804222:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804226:	ba 07 04 00 00       	mov    $0x407,%edx
  80422b:	48 89 c6             	mov    %rax,%rsi
  80422e:	bf 00 00 00 00       	mov    $0x0,%edi
  804233:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80423a:	00 00 00 
  80423d:	ff d0                	callq  *%rax
  80423f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804242:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804246:	0f 88 33 01 00 00    	js     80437f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80424c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804250:	48 89 c7             	mov    %rax,%rdi
  804253:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  80425a:	00 00 00 
  80425d:	ff d0                	callq  *%rax
  80425f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804267:	ba 07 04 00 00       	mov    $0x407,%edx
  80426c:	48 89 c6             	mov    %rax,%rsi
  80426f:	bf 00 00 00 00       	mov    $0x0,%edi
  804274:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80427b:	00 00 00 
  80427e:	ff d0                	callq  *%rax
  804280:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804283:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804287:	0f 88 d9 00 00 00    	js     804366 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80428d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804291:	48 89 c7             	mov    %rax,%rdi
  804294:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  80429b:	00 00 00 
  80429e:	ff d0                	callq  *%rax
  8042a0:	48 89 c2             	mov    %rax,%rdx
  8042a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8042ad:	48 89 d1             	mov    %rdx,%rcx
  8042b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8042b5:	48 89 c6             	mov    %rax,%rsi
  8042b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8042bd:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  8042c4:	00 00 00 
  8042c7:	ff d0                	callq  *%rax
  8042c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042d0:	78 79                	js     80434b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8042d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d6:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8042dd:	00 00 00 
  8042e0:	8b 12                	mov    (%rdx),%edx
  8042e2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8042e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8042ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042f3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8042fa:	00 00 00 
  8042fd:	8b 12                	mov    (%rdx),%edx
  8042ff:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804301:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804305:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80430c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804310:	48 89 c7             	mov    %rax,%rdi
  804313:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  80431a:	00 00 00 
  80431d:	ff d0                	callq  *%rax
  80431f:	89 c2                	mov    %eax,%edx
  804321:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804325:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804327:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80432b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80432f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804333:	48 89 c7             	mov    %rax,%rdi
  804336:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  80433d:	00 00 00 
  804340:	ff d0                	callq  *%rax
  804342:	89 03                	mov    %eax,(%rbx)
	return 0;
  804344:	b8 00 00 00 00       	mov    $0x0,%eax
  804349:	eb 4f                	jmp    80439a <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80434b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80434c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804350:	48 89 c6             	mov    %rax,%rsi
  804353:	bf 00 00 00 00       	mov    $0x0,%edi
  804358:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80435f:	00 00 00 
  804362:	ff d0                	callq  *%rax
  804364:	eb 01                	jmp    804367 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804366:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804367:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80436b:	48 89 c6             	mov    %rax,%rsi
  80436e:	bf 00 00 00 00       	mov    $0x0,%edi
  804373:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80437a:	00 00 00 
  80437d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80437f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804383:	48 89 c6             	mov    %rax,%rsi
  804386:	bf 00 00 00 00       	mov    $0x0,%edi
  80438b:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  804392:	00 00 00 
  804395:	ff d0                	callq  *%rax
err:
	return r;
  804397:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80439a:	48 83 c4 38          	add    $0x38,%rsp
  80439e:	5b                   	pop    %rbx
  80439f:	5d                   	pop    %rbp
  8043a0:	c3                   	retq   

00000000008043a1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8043a1:	55                   	push   %rbp
  8043a2:	48 89 e5             	mov    %rsp,%rbp
  8043a5:	53                   	push   %rbx
  8043a6:	48 83 ec 28          	sub    $0x28,%rsp
  8043aa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8043b2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8043b9:	00 00 00 
  8043bc:	48 8b 00             	mov    (%rax),%rax
  8043bf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8043c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8043c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043cc:	48 89 c7             	mov    %rax,%rdi
  8043cf:	48 b8 56 4d 80 00 00 	movabs $0x804d56,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
  8043db:	89 c3                	mov    %eax,%ebx
  8043dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043e1:	48 89 c7             	mov    %rax,%rdi
  8043e4:	48 b8 56 4d 80 00 00 	movabs $0x804d56,%rax
  8043eb:	00 00 00 
  8043ee:	ff d0                	callq  *%rax
  8043f0:	39 c3                	cmp    %eax,%ebx
  8043f2:	0f 94 c0             	sete   %al
  8043f5:	0f b6 c0             	movzbl %al,%eax
  8043f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8043fb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804402:	00 00 00 
  804405:	48 8b 00             	mov    (%rax),%rax
  804408:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80440e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804411:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804414:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804417:	75 05                	jne    80441e <_pipeisclosed+0x7d>
			return ret;
  804419:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80441c:	eb 4a                	jmp    804468 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80441e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804421:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804424:	74 8c                	je     8043b2 <_pipeisclosed+0x11>
  804426:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80442a:	75 86                	jne    8043b2 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80442c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804433:	00 00 00 
  804436:	48 8b 00             	mov    (%rax),%rax
  804439:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80443f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804442:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804445:	89 c6                	mov    %eax,%esi
  804447:	48 bf 63 56 80 00 00 	movabs $0x805663,%rdi
  80444e:	00 00 00 
  804451:	b8 00 00 00 00       	mov    $0x0,%eax
  804456:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  80445d:	00 00 00 
  804460:	41 ff d0             	callq  *%r8
	}
  804463:	e9 4a ff ff ff       	jmpq   8043b2 <_pipeisclosed+0x11>

}
  804468:	48 83 c4 28          	add    $0x28,%rsp
  80446c:	5b                   	pop    %rbx
  80446d:	5d                   	pop    %rbp
  80446e:	c3                   	retq   

000000000080446f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80446f:	55                   	push   %rbp
  804470:	48 89 e5             	mov    %rsp,%rbp
  804473:	48 83 ec 30          	sub    $0x30,%rsp
  804477:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80447a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80447e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804481:	48 89 d6             	mov    %rdx,%rsi
  804484:	89 c7                	mov    %eax,%edi
  804486:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  80448d:	00 00 00 
  804490:	ff d0                	callq  *%rax
  804492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804499:	79 05                	jns    8044a0 <pipeisclosed+0x31>
		return r;
  80449b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449e:	eb 31                	jmp    8044d1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8044a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a4:	48 89 c7             	mov    %rax,%rdi
  8044a7:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8044ae:	00 00 00 
  8044b1:	ff d0                	callq  *%rax
  8044b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8044b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044bf:	48 89 d6             	mov    %rdx,%rsi
  8044c2:	48 89 c7             	mov    %rax,%rdi
  8044c5:	48 b8 a1 43 80 00 00 	movabs $0x8043a1,%rax
  8044cc:	00 00 00 
  8044cf:	ff d0                	callq  *%rax
}
  8044d1:	c9                   	leaveq 
  8044d2:	c3                   	retq   

00000000008044d3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044d3:	55                   	push   %rbp
  8044d4:	48 89 e5             	mov    %rsp,%rbp
  8044d7:	48 83 ec 40          	sub    $0x40,%rsp
  8044db:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8044e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044eb:	48 89 c7             	mov    %rax,%rdi
  8044ee:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8044f5:	00 00 00 
  8044f8:	ff d0                	callq  *%rax
  8044fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8044fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804502:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804506:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80450d:	00 
  80450e:	e9 90 00 00 00       	jmpq   8045a3 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804513:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804518:	74 09                	je     804523 <devpipe_read+0x50>
				return i;
  80451a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80451e:	e9 8e 00 00 00       	jmpq   8045b1 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804523:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80452b:	48 89 d6             	mov    %rdx,%rsi
  80452e:	48 89 c7             	mov    %rax,%rdi
  804531:	48 b8 a1 43 80 00 00 	movabs $0x8043a1,%rax
  804538:	00 00 00 
  80453b:	ff d0                	callq  *%rax
  80453d:	85 c0                	test   %eax,%eax
  80453f:	74 07                	je     804548 <devpipe_read+0x75>
				return 0;
  804541:	b8 00 00 00 00       	mov    $0x0,%eax
  804546:	eb 69                	jmp    8045b1 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804548:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  80454f:	00 00 00 
  804552:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804558:	8b 10                	mov    (%rax),%edx
  80455a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455e:	8b 40 04             	mov    0x4(%rax),%eax
  804561:	39 c2                	cmp    %eax,%edx
  804563:	74 ae                	je     804513 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804565:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804575:	8b 00                	mov    (%rax),%eax
  804577:	99                   	cltd   
  804578:	c1 ea 1b             	shr    $0x1b,%edx
  80457b:	01 d0                	add    %edx,%eax
  80457d:	83 e0 1f             	and    $0x1f,%eax
  804580:	29 d0                	sub    %edx,%eax
  804582:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804586:	48 98                	cltq   
  804588:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80458d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80458f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804593:	8b 00                	mov    (%rax),%eax
  804595:	8d 50 01             	lea    0x1(%rax),%edx
  804598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80459c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80459e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8045ab:	72 a7                	jb     804554 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8045ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8045b1:	c9                   	leaveq 
  8045b2:	c3                   	retq   

00000000008045b3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045b3:	55                   	push   %rbp
  8045b4:	48 89 e5             	mov    %rsp,%rbp
  8045b7:	48 83 ec 40          	sub    $0x40,%rsp
  8045bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8045c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045cb:	48 89 c7             	mov    %rax,%rdi
  8045ce:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8045d5:	00 00 00 
  8045d8:	ff d0                	callq  *%rax
  8045da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8045e6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8045ed:	00 
  8045ee:	e9 8f 00 00 00       	jmpq   804682 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8045f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045fb:	48 89 d6             	mov    %rdx,%rsi
  8045fe:	48 89 c7             	mov    %rax,%rdi
  804601:	48 b8 a1 43 80 00 00 	movabs $0x8043a1,%rax
  804608:	00 00 00 
  80460b:	ff d0                	callq  *%rax
  80460d:	85 c0                	test   %eax,%eax
  80460f:	74 07                	je     804618 <devpipe_write+0x65>
				return 0;
  804611:	b8 00 00 00 00       	mov    $0x0,%eax
  804616:	eb 78                	jmp    804690 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804618:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  80461f:	00 00 00 
  804622:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804628:	8b 40 04             	mov    0x4(%rax),%eax
  80462b:	48 63 d0             	movslq %eax,%rdx
  80462e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804632:	8b 00                	mov    (%rax),%eax
  804634:	48 98                	cltq   
  804636:	48 83 c0 20          	add    $0x20,%rax
  80463a:	48 39 c2             	cmp    %rax,%rdx
  80463d:	73 b4                	jae    8045f3 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80463f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804643:	8b 40 04             	mov    0x4(%rax),%eax
  804646:	99                   	cltd   
  804647:	c1 ea 1b             	shr    $0x1b,%edx
  80464a:	01 d0                	add    %edx,%eax
  80464c:	83 e0 1f             	and    $0x1f,%eax
  80464f:	29 d0                	sub    %edx,%eax
  804651:	89 c6                	mov    %eax,%esi
  804653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80465b:	48 01 d0             	add    %rdx,%rax
  80465e:	0f b6 08             	movzbl (%rax),%ecx
  804661:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804665:	48 63 c6             	movslq %esi,%rax
  804668:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80466c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804670:	8b 40 04             	mov    0x4(%rax),%eax
  804673:	8d 50 01             	lea    0x1(%rax),%edx
  804676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80467d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804686:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80468a:	72 98                	jb     804624 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80468c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804690:	c9                   	leaveq 
  804691:	c3                   	retq   

0000000000804692 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804692:	55                   	push   %rbp
  804693:	48 89 e5             	mov    %rsp,%rbp
  804696:	48 83 ec 20          	sub    $0x20,%rsp
  80469a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80469e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8046a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046a6:	48 89 c7             	mov    %rax,%rdi
  8046a9:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8046b0:	00 00 00 
  8046b3:	ff d0                	callq  *%rax
  8046b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8046b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046bd:	48 be 76 56 80 00 00 	movabs $0x805676,%rsi
  8046c4:	00 00 00 
  8046c7:	48 89 c7             	mov    %rax,%rdi
  8046ca:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  8046d1:	00 00 00 
  8046d4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8046d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046da:	8b 50 04             	mov    0x4(%rax),%edx
  8046dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046e1:	8b 00                	mov    (%rax),%eax
  8046e3:	29 c2                	sub    %eax,%edx
  8046e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046e9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8046ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046f3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8046fa:	00 00 00 
	stat->st_dev = &devpipe;
  8046fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804701:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804708:	00 00 00 
  80470b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804717:	c9                   	leaveq 
  804718:	c3                   	retq   

0000000000804719 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804719:	55                   	push   %rbp
  80471a:	48 89 e5             	mov    %rsp,%rbp
  80471d:	48 83 ec 10          	sub    $0x10,%rsp
  804721:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804729:	48 89 c6             	mov    %rax,%rsi
  80472c:	bf 00 00 00 00       	mov    $0x0,%edi
  804731:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  804738:	00 00 00 
  80473b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80473d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804741:	48 89 c7             	mov    %rax,%rdi
  804744:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  80474b:	00 00 00 
  80474e:	ff d0                	callq  *%rax
  804750:	48 89 c6             	mov    %rax,%rsi
  804753:	bf 00 00 00 00       	mov    $0x0,%edi
  804758:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80475f:	00 00 00 
  804762:	ff d0                	callq  *%rax
}
  804764:	c9                   	leaveq 
  804765:	c3                   	retq   

0000000000804766 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804766:	55                   	push   %rbp
  804767:	48 89 e5             	mov    %rsp,%rbp
  80476a:	48 83 ec 20          	sub    $0x20,%rsp
  80476e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804771:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804774:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804777:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80477b:	be 01 00 00 00       	mov    $0x1,%esi
  804780:	48 89 c7             	mov    %rax,%rdi
  804783:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  80478a:	00 00 00 
  80478d:	ff d0                	callq  *%rax
}
  80478f:	90                   	nop
  804790:	c9                   	leaveq 
  804791:	c3                   	retq   

0000000000804792 <getchar>:

int
getchar(void)
{
  804792:	55                   	push   %rbp
  804793:	48 89 e5             	mov    %rsp,%rbp
  804796:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80479a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80479e:	ba 01 00 00 00       	mov    $0x1,%edx
  8047a3:	48 89 c6             	mov    %rax,%rsi
  8047a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ab:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  8047b2:	00 00 00 
  8047b5:	ff d0                	callq  *%rax
  8047b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8047ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047be:	79 05                	jns    8047c5 <getchar+0x33>
		return r;
  8047c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047c3:	eb 14                	jmp    8047d9 <getchar+0x47>
	if (r < 1)
  8047c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047c9:	7f 07                	jg     8047d2 <getchar+0x40>
		return -E_EOF;
  8047cb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8047d0:	eb 07                	jmp    8047d9 <getchar+0x47>
	return c;
  8047d2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8047d6:	0f b6 c0             	movzbl %al,%eax

}
  8047d9:	c9                   	leaveq 
  8047da:	c3                   	retq   

00000000008047db <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8047db:	55                   	push   %rbp
  8047dc:	48 89 e5             	mov    %rsp,%rbp
  8047df:	48 83 ec 20          	sub    $0x20,%rsp
  8047e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8047e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8047ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047ed:	48 89 d6             	mov    %rdx,%rsi
  8047f0:	89 c7                	mov    %eax,%edi
  8047f2:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  8047f9:	00 00 00 
  8047fc:	ff d0                	callq  *%rax
  8047fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804805:	79 05                	jns    80480c <iscons+0x31>
		return r;
  804807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80480a:	eb 1a                	jmp    804826 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80480c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804810:	8b 10                	mov    (%rax),%edx
  804812:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804819:	00 00 00 
  80481c:	8b 00                	mov    (%rax),%eax
  80481e:	39 c2                	cmp    %eax,%edx
  804820:	0f 94 c0             	sete   %al
  804823:	0f b6 c0             	movzbl %al,%eax
}
  804826:	c9                   	leaveq 
  804827:	c3                   	retq   

0000000000804828 <opencons>:

int
opencons(void)
{
  804828:	55                   	push   %rbp
  804829:	48 89 e5             	mov    %rsp,%rbp
  80482c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804830:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804834:	48 89 c7             	mov    %rax,%rdi
  804837:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80483e:	00 00 00 
  804841:	ff d0                	callq  *%rax
  804843:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80484a:	79 05                	jns    804851 <opencons+0x29>
		return r;
  80484c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484f:	eb 5b                	jmp    8048ac <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804851:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804855:	ba 07 04 00 00       	mov    $0x407,%edx
  80485a:	48 89 c6             	mov    %rax,%rsi
  80485d:	bf 00 00 00 00       	mov    $0x0,%edi
  804862:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  804869:	00 00 00 
  80486c:	ff d0                	callq  *%rax
  80486e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804871:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804875:	79 05                	jns    80487c <opencons+0x54>
		return r;
  804877:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80487a:	eb 30                	jmp    8048ac <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80487c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804880:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804887:	00 00 00 
  80488a:	8b 12                	mov    (%rdx),%edx
  80488c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80488e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804892:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80489d:	48 89 c7             	mov    %rax,%rdi
  8048a0:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  8048a7:	00 00 00 
  8048aa:	ff d0                	callq  *%rax
}
  8048ac:	c9                   	leaveq 
  8048ad:	c3                   	retq   

00000000008048ae <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048ae:	55                   	push   %rbp
  8048af:	48 89 e5             	mov    %rsp,%rbp
  8048b2:	48 83 ec 30          	sub    $0x30,%rsp
  8048b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8048c2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048c7:	75 13                	jne    8048dc <devcons_read+0x2e>
		return 0;
  8048c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ce:	eb 49                	jmp    804919 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8048d0:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  8048d7:	00 00 00 
  8048da:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8048dc:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  8048e3:	00 00 00 
  8048e6:	ff d0                	callq  *%rax
  8048e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ef:	74 df                	je     8048d0 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8048f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048f5:	79 05                	jns    8048fc <devcons_read+0x4e>
		return c;
  8048f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048fa:	eb 1d                	jmp    804919 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8048fc:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804900:	75 07                	jne    804909 <devcons_read+0x5b>
		return 0;
  804902:	b8 00 00 00 00       	mov    $0x0,%eax
  804907:	eb 10                	jmp    804919 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80490c:	89 c2                	mov    %eax,%edx
  80490e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804912:	88 10                	mov    %dl,(%rax)
	return 1;
  804914:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804919:	c9                   	leaveq 
  80491a:	c3                   	retq   

000000000080491b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80491b:	55                   	push   %rbp
  80491c:	48 89 e5             	mov    %rsp,%rbp
  80491f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804926:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80492d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804934:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80493b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804942:	eb 76                	jmp    8049ba <devcons_write+0x9f>
		m = n - tot;
  804944:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80494b:	89 c2                	mov    %eax,%edx
  80494d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804950:	29 c2                	sub    %eax,%edx
  804952:	89 d0                	mov    %edx,%eax
  804954:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804957:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80495a:	83 f8 7f             	cmp    $0x7f,%eax
  80495d:	76 07                	jbe    804966 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80495f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804966:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804969:	48 63 d0             	movslq %eax,%rdx
  80496c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80496f:	48 63 c8             	movslq %eax,%rcx
  804972:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804979:	48 01 c1             	add    %rax,%rcx
  80497c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804983:	48 89 ce             	mov    %rcx,%rsi
  804986:	48 89 c7             	mov    %rax,%rdi
  804989:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  804990:	00 00 00 
  804993:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804995:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804998:	48 63 d0             	movslq %eax,%rdx
  80499b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8049a2:	48 89 d6             	mov    %rdx,%rsi
  8049a5:	48 89 c7             	mov    %rax,%rdi
  8049a8:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  8049af:	00 00 00 
  8049b2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8049b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049b7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8049ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049bd:	48 98                	cltq   
  8049bf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8049c6:	0f 82 78 ff ff ff    	jb     804944 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8049cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8049cf:	c9                   	leaveq 
  8049d0:	c3                   	retq   

00000000008049d1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8049d1:	55                   	push   %rbp
  8049d2:	48 89 e5             	mov    %rsp,%rbp
  8049d5:	48 83 ec 08          	sub    $0x8,%rsp
  8049d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8049dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049e2:	c9                   	leaveq 
  8049e3:	c3                   	retq   

00000000008049e4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8049e4:	55                   	push   %rbp
  8049e5:	48 89 e5             	mov    %rsp,%rbp
  8049e8:	48 83 ec 10          	sub    $0x10,%rsp
  8049ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8049f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8049f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049f8:	48 be 82 56 80 00 00 	movabs $0x805682,%rsi
  8049ff:	00 00 00 
  804a02:	48 89 c7             	mov    %rax,%rdi
  804a05:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  804a0c:	00 00 00 
  804a0f:	ff d0                	callq  *%rax
	return 0;
  804a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a16:	c9                   	leaveq 
  804a17:	c3                   	retq   

0000000000804a18 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804a18:	55                   	push   %rbp
  804a19:	48 89 e5             	mov    %rsp,%rbp
  804a1c:	48 83 ec 30          	sub    $0x30,%rsp
  804a20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804a2c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a31:	75 0e                	jne    804a41 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804a33:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a3a:	00 00 00 
  804a3d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804a41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a45:	48 89 c7             	mov    %rax,%rdi
  804a48:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  804a4f:	00 00 00 
  804a52:	ff d0                	callq  *%rax
  804a54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a5b:	79 27                	jns    804a84 <ipc_recv+0x6c>
		if (from_env_store)
  804a5d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a62:	74 0a                	je     804a6e <ipc_recv+0x56>
			*from_env_store = 0;
  804a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a68:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804a6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a73:	74 0a                	je     804a7f <ipc_recv+0x67>
			*perm_store = 0;
  804a75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a79:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a82:	eb 53                	jmp    804ad7 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804a84:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a89:	74 19                	je     804aa4 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804a8b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a92:	00 00 00 
  804a95:	48 8b 00             	mov    (%rax),%rax
  804a98:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa2:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804aa4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804aa9:	74 19                	je     804ac4 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804aab:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ab2:	00 00 00 
  804ab5:	48 8b 00             	mov    (%rax),%rax
  804ab8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ac2:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804ac4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804acb:	00 00 00 
  804ace:	48 8b 00             	mov    (%rax),%rax
  804ad1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804ad7:	c9                   	leaveq 
  804ad8:	c3                   	retq   

0000000000804ad9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804ad9:	55                   	push   %rbp
  804ada:	48 89 e5             	mov    %rsp,%rbp
  804add:	48 83 ec 30          	sub    $0x30,%rsp
  804ae1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804ae4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804ae7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804aeb:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804aee:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804af3:	75 1c                	jne    804b11 <ipc_send+0x38>
		pg = (void*) UTOP;
  804af5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804afc:	00 00 00 
  804aff:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804b03:	eb 0c                	jmp    804b11 <ipc_send+0x38>
		sys_yield();
  804b05:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  804b0c:	00 00 00 
  804b0f:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804b11:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b14:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b17:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b1e:	89 c7                	mov    %eax,%edi
  804b20:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  804b27:	00 00 00 
  804b2a:	ff d0                	callq  *%rax
  804b2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b2f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b33:	74 d0                	je     804b05 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804b35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b39:	79 30                	jns    804b6b <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b3e:	89 c1                	mov    %eax,%ecx
  804b40:	48 ba 89 56 80 00 00 	movabs $0x805689,%rdx
  804b47:	00 00 00 
  804b4a:	be 47 00 00 00       	mov    $0x47,%esi
  804b4f:	48 bf 9f 56 80 00 00 	movabs $0x80569f,%rdi
  804b56:	00 00 00 
  804b59:	b8 00 00 00 00       	mov    $0x0,%eax
  804b5e:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  804b65:	00 00 00 
  804b68:	41 ff d0             	callq  *%r8

}
  804b6b:	90                   	nop
  804b6c:	c9                   	leaveq 
  804b6d:	c3                   	retq   

0000000000804b6e <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804b6e:	55                   	push   %rbp
  804b6f:	48 89 e5             	mov    %rsp,%rbp
  804b72:	53                   	push   %rbx
  804b73:	48 83 ec 28          	sub    $0x28,%rsp
  804b77:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804b7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804b82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804b89:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b8e:	75 0e                	jne    804b9e <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804b90:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b97:	00 00 00 
  804b9a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804b9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ba2:	ba 07 00 00 00       	mov    $0x7,%edx
  804ba7:	48 89 c6             	mov    %rax,%rsi
  804baa:	bf 00 00 00 00       	mov    $0x0,%edi
  804baf:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  804bb6:	00 00 00 
  804bb9:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804bbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bbf:	48 c1 e8 0c          	shr    $0xc,%rax
  804bc3:	48 89 c2             	mov    %rax,%rdx
  804bc6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804bcd:	01 00 00 
  804bd0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804bd4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804bda:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804bde:	b8 03 00 00 00       	mov    $0x3,%eax
  804be3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804be7:	48 89 d3             	mov    %rdx,%rbx
  804bea:	0f 01 c1             	vmcall 
  804bed:	89 f2                	mov    %esi,%edx
  804bef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804bf2:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804bf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bf9:	79 05                	jns    804c00 <ipc_host_recv+0x92>
		return r;
  804bfb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bfe:	eb 03                	jmp    804c03 <ipc_host_recv+0x95>
	}
	return val;
  804c00:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804c03:	48 83 c4 28          	add    $0x28,%rsp
  804c07:	5b                   	pop    %rbx
  804c08:	5d                   	pop    %rbp
  804c09:	c3                   	retq   

0000000000804c0a <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804c0a:	55                   	push   %rbp
  804c0b:	48 89 e5             	mov    %rsp,%rbp
  804c0e:	53                   	push   %rbx
  804c0f:	48 83 ec 38          	sub    $0x38,%rsp
  804c13:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804c16:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804c19:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804c1d:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804c20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804c27:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804c2c:	75 0e                	jne    804c3c <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804c2e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804c35:	00 00 00 
  804c38:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804c3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c40:	48 c1 e8 0c          	shr    $0xc,%rax
  804c44:	48 89 c2             	mov    %rax,%rdx
  804c47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c4e:	01 00 00 
  804c51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c55:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804c5b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804c5f:	b8 02 00 00 00       	mov    $0x2,%eax
  804c64:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804c67:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804c6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804c6e:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804c71:	89 fb                	mov    %edi,%ebx
  804c73:	0f 01 c1             	vmcall 
  804c76:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804c79:	eb 26                	jmp    804ca1 <ipc_host_send+0x97>
		sys_yield();
  804c7b:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  804c82:	00 00 00 
  804c85:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804c87:	b8 02 00 00 00       	mov    $0x2,%eax
  804c8c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804c8f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804c92:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804c96:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804c99:	89 fb                	mov    %edi,%ebx
  804c9b:	0f 01 c1             	vmcall 
  804c9e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804ca1:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804ca5:	74 d4                	je     804c7b <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804ca7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804cab:	79 30                	jns    804cdd <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804cad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804cb0:	89 c1                	mov    %eax,%ecx
  804cb2:	48 ba 89 56 80 00 00 	movabs $0x805689,%rdx
  804cb9:	00 00 00 
  804cbc:	be 79 00 00 00       	mov    $0x79,%esi
  804cc1:	48 bf 9f 56 80 00 00 	movabs $0x80569f,%rdi
  804cc8:	00 00 00 
  804ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  804cd0:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  804cd7:	00 00 00 
  804cda:	41 ff d0             	callq  *%r8

}
  804cdd:	90                   	nop
  804cde:	48 83 c4 38          	add    $0x38,%rsp
  804ce2:	5b                   	pop    %rbx
  804ce3:	5d                   	pop    %rbp
  804ce4:	c3                   	retq   

0000000000804ce5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804ce5:	55                   	push   %rbp
  804ce6:	48 89 e5             	mov    %rsp,%rbp
  804ce9:	48 83 ec 18          	sub    $0x18,%rsp
  804ced:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804cf7:	eb 4d                	jmp    804d46 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804cf9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804d00:	00 00 00 
  804d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d06:	48 98                	cltq   
  804d08:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804d0f:	48 01 d0             	add    %rdx,%rax
  804d12:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804d18:	8b 00                	mov    (%rax),%eax
  804d1a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804d1d:	75 23                	jne    804d42 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804d1f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804d26:	00 00 00 
  804d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d2c:	48 98                	cltq   
  804d2e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804d35:	48 01 d0             	add    %rdx,%rax
  804d38:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804d3e:	8b 00                	mov    (%rax),%eax
  804d40:	eb 12                	jmp    804d54 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804d42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804d46:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804d4d:	7e aa                	jle    804cf9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d54:	c9                   	leaveq 
  804d55:	c3                   	retq   

0000000000804d56 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804d56:	55                   	push   %rbp
  804d57:	48 89 e5             	mov    %rsp,%rbp
  804d5a:	48 83 ec 18          	sub    $0x18,%rsp
  804d5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d66:	48 c1 e8 15          	shr    $0x15,%rax
  804d6a:	48 89 c2             	mov    %rax,%rdx
  804d6d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804d74:	01 00 00 
  804d77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d7b:	83 e0 01             	and    $0x1,%eax
  804d7e:	48 85 c0             	test   %rax,%rax
  804d81:	75 07                	jne    804d8a <pageref+0x34>
		return 0;
  804d83:	b8 00 00 00 00       	mov    $0x0,%eax
  804d88:	eb 56                	jmp    804de0 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d8e:	48 c1 e8 0c          	shr    $0xc,%rax
  804d92:	48 89 c2             	mov    %rax,%rdx
  804d95:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d9c:	01 00 00 
  804d9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804da3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804da7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dab:	83 e0 01             	and    $0x1,%eax
  804dae:	48 85 c0             	test   %rax,%rax
  804db1:	75 07                	jne    804dba <pageref+0x64>
		return 0;
  804db3:	b8 00 00 00 00       	mov    $0x0,%eax
  804db8:	eb 26                	jmp    804de0 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dbe:	48 c1 e8 0c          	shr    $0xc,%rax
  804dc2:	48 89 c2             	mov    %rax,%rdx
  804dc5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804dcc:	00 00 00 
  804dcf:	48 c1 e2 04          	shl    $0x4,%rdx
  804dd3:	48 01 d0             	add    %rdx,%rax
  804dd6:	48 83 c0 08          	add    $0x8,%rax
  804dda:	0f b7 00             	movzwl (%rax),%eax
  804ddd:	0f b7 c0             	movzwl %ax,%eax
}
  804de0:	c9                   	leaveq 
  804de1:	c3                   	retq   
