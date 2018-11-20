
obj/user/icode:     file format elf64-x86-64


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
  800065:	48 b9 80 4d 80 00 00 	movabs $0x804d80,%rcx
  80006c:	00 00 00 
  80006f:	48 89 08             	mov    %rcx,(%rax)

	cprintf("icode startup\n");
  800072:	48 bf 86 4d 80 00 00 	movabs $0x804d86,%rdi
  800079:	00 00 00 
  80007c:	b8 00 00 00 00       	mov    $0x0,%eax
  800081:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800088:	00 00 00 
  80008b:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008d:	48 bf 95 4d 80 00 00 	movabs $0x804d95,%rdi
  800094:	00 00 00 
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  8000a3:	00 00 00 
  8000a6:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a8:	be 00 00 00 00       	mov    $0x0,%esi
  8000ad:	48 bf a8 4d 80 00 00 	movabs $0x804da8,%rdi
  8000b4:	00 00 00 
  8000b7:	48 b8 ee 28 80 00 00 	movabs $0x8028ee,%rax
  8000be:	00 00 00 
  8000c1:	ff d0                	callq  *%rax
  8000c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ca:	79 30                	jns    8000fc <umain+0xb9>
		panic("icode: open /motd: %e", fd);
  8000cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000cf:	89 c1                	mov    %eax,%ecx
  8000d1:	48 ba ae 4d 80 00 00 	movabs $0x804dae,%rdx
  8000d8:	00 00 00 
  8000db:	be 18 00 00 00       	mov    $0x18,%esi
  8000e0:	48 bf c4 4d 80 00 00 	movabs $0x804dc4,%rdi
  8000e7:	00 00 00 
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8000f6:	00 00 00 
  8000f9:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fc:	48 bf d1 4d 80 00 00 	movabs $0x804dd1,%rdi
  800103:	00 00 00 
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800112:	00 00 00 
  800115:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800117:	eb 3a                	jmp    800153 <umain+0x110>
		cprintf("Writing MOTD\n");
  800119:	48 bf e4 4d 80 00 00 	movabs $0x804de4,%rdi
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
  800167:	48 b8 15 24 80 00 00 	movabs $0x802415,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800176:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80017a:	7f 9d                	jg     800119 <umain+0xd6>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017c:	48 bf f2 4d 80 00 00 	movabs $0x804df2,%rdi
  800183:	00 00 00 
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  800192:	00 00 00 
  800195:	ff d2                	callq  *%rdx
	close(fd);
  800197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  8001a3:	00 00 00 
  8001a6:	ff d0                	callq  *%rax


	cprintf("icode: spawn /sbin/init\n");
  8001a8:	48 bf 06 4e 80 00 00 	movabs $0x804e06,%rdi
  8001af:	00 00 00 
  8001b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b7:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  8001be:	00 00 00 
  8001c1:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c9:	48 b9 1f 4e 80 00 00 	movabs $0x804e1f,%rcx
  8001d0:	00 00 00 
  8001d3:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  8001da:	00 00 00 
  8001dd:	48 be 31 4e 80 00 00 	movabs $0x804e31,%rsi
  8001e4:	00 00 00 
  8001e7:	48 bf 36 4e 80 00 00 	movabs $0x804e36,%rdi
  8001ee:	00 00 00 
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f6:	49 b9 85 32 80 00 00 	movabs $0x803285,%r9
  8001fd:	00 00 00 
  800200:	41 ff d1             	callq  *%r9
  800203:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800206:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80020a:	79 30                	jns    80023c <umain+0x1f9>
		panic("icode: spawn /sbin/init: %e", r);
  80020c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80020f:	89 c1                	mov    %eax,%ecx
  800211:	48 ba 41 4e 80 00 00 	movabs $0x804e41,%rdx
  800218:	00 00 00 
  80021b:	be 26 00 00 00       	mov    $0x26,%esi
  800220:	48 bf c4 4d 80 00 00 	movabs $0x804dc4,%rdi
  800227:	00 00 00 
  80022a:	b8 00 00 00 00       	mov    $0x0,%eax
  80022f:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  800236:	00 00 00 
  800239:	41 ff d0             	callq  *%r8

	cprintf("icode: exiting\n");
  80023c:	48 bf 5d 4e 80 00 00 	movabs $0x804e5d,%rdi
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
  8002e2:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
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
  8003bc:	48 bf 78 4e 80 00 00 	movabs $0x804e78,%rdi
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
  8003f8:	48 bf 9b 4e 80 00 00 	movabs $0x804e9b,%rdi
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
  8006a9:	48 b8 90 50 80 00 00 	movabs $0x805090,%rax
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
  80098b:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
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
  800ad2:	48 b8 e0 4f 80 00 00 	movabs $0x804fe0,%rax
  800ad9:	00 00 00 
  800adc:	48 63 d3             	movslq %ebx,%rdx
  800adf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ae3:	4d 85 e4             	test   %r12,%r12
  800ae6:	75 2e                	jne    800b16 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ae8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af0:	89 d9                	mov    %ebx,%ecx
  800af2:	48 ba a1 50 80 00 00 	movabs $0x8050a1,%rdx
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
  800b21:	48 ba aa 50 80 00 00 	movabs $0x8050aa,%rdx
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
  800b78:	49 bc ad 50 80 00 00 	movabs $0x8050ad,%r12
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
  801884:	48 ba 68 53 80 00 00 	movabs $0x805368,%rdx
  80188b:	00 00 00 
  80188e:	be 24 00 00 00       	mov    $0x24,%esi
  801893:	48 bf 85 53 80 00 00 	movabs $0x805385,%rdi
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

0000000000801dfe <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801e02:	48 83 ec 08          	sub    $0x8,%rsp
  801e06:	6a 00                	pushq  $0x0
  801e08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e19:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1e:	be 00 00 00 00       	mov    $0x0,%esi
  801e23:	bf 13 00 00 00       	mov    $0x13,%edi
  801e28:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	callq  *%rax
  801e34:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801e38:	90                   	nop
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 10          	sub    $0x10,%rsp
  801e43:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e49:	48 98                	cltq   
  801e4b:	48 83 ec 08          	sub    $0x8,%rsp
  801e4f:	6a 00                	pushq  $0x0
  801e51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e62:	48 89 c2             	mov    %rax,%rdx
  801e65:	be 00 00 00 00       	mov    $0x0,%esi
  801e6a:	bf 14 00 00 00       	mov    $0x14,%edi
  801e6f:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax
  801e7b:	48 83 c4 10          	add    $0x10,%rsp
}
  801e7f:	c9                   	leaveq 
  801e80:	c3                   	retq   

0000000000801e81 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801e81:	55                   	push   %rbp
  801e82:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e85:	48 83 ec 08          	sub    $0x8,%rsp
  801e89:	6a 00                	pushq  $0x0
  801e8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e97:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea1:	be 00 00 00 00       	mov    $0x0,%esi
  801ea6:	bf 15 00 00 00       	mov    $0x15,%edi
  801eab:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
  801eb7:	48 83 c4 10          	add    $0x10,%rsp
}
  801ebb:	c9                   	leaveq 
  801ebc:	c3                   	retq   

0000000000801ebd <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801ec1:	48 83 ec 08          	sub    $0x8,%rsp
  801ec5:	6a 00                	pushq  $0x0
  801ec7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ecd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ed8:	ba 00 00 00 00       	mov    $0x0,%edx
  801edd:	be 00 00 00 00       	mov    $0x0,%esi
  801ee2:	bf 16 00 00 00       	mov    $0x16,%edi
  801ee7:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  801eee:	00 00 00 
  801ef1:	ff d0                	callq  *%rax
  801ef3:	48 83 c4 10          	add    $0x10,%rsp
}
  801ef7:	90                   	nop
  801ef8:	c9                   	leaveq 
  801ef9:	c3                   	retq   

0000000000801efa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801efa:	55                   	push   %rbp
  801efb:	48 89 e5             	mov    %rsp,%rbp
  801efe:	48 83 ec 08          	sub    $0x8,%rsp
  801f02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f06:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f0a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f11:	ff ff ff 
  801f14:	48 01 d0             	add    %rdx,%rax
  801f17:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f1b:	c9                   	leaveq 
  801f1c:	c3                   	retq   

0000000000801f1d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f1d:	55                   	push   %rbp
  801f1e:	48 89 e5             	mov    %rsp,%rbp
  801f21:	48 83 ec 08          	sub    $0x8,%rsp
  801f25:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2d:	48 89 c7             	mov    %rax,%rdi
  801f30:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	callq  *%rax
  801f3c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f42:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f46:	c9                   	leaveq 
  801f47:	c3                   	retq   

0000000000801f48 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f48:	55                   	push   %rbp
  801f49:	48 89 e5             	mov    %rsp,%rbp
  801f4c:	48 83 ec 18          	sub    $0x18,%rsp
  801f50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f5b:	eb 6b                	jmp    801fc8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f60:	48 98                	cltq   
  801f62:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f68:	48 c1 e0 0c          	shl    $0xc,%rax
  801f6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f74:	48 c1 e8 15          	shr    $0x15,%rax
  801f78:	48 89 c2             	mov    %rax,%rdx
  801f7b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f82:	01 00 00 
  801f85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f89:	83 e0 01             	and    $0x1,%eax
  801f8c:	48 85 c0             	test   %rax,%rax
  801f8f:	74 21                	je     801fb2 <fd_alloc+0x6a>
  801f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f95:	48 c1 e8 0c          	shr    $0xc,%rax
  801f99:	48 89 c2             	mov    %rax,%rdx
  801f9c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fa3:	01 00 00 
  801fa6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801faa:	83 e0 01             	and    $0x1,%eax
  801fad:	48 85 c0             	test   %rax,%rax
  801fb0:	75 12                	jne    801fc4 <fd_alloc+0x7c>
			*fd_store = fd;
  801fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	eb 1a                	jmp    801fde <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fc4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fc8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fcc:	7e 8f                	jle    801f5d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fd9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fde:	c9                   	leaveq 
  801fdf:	c3                   	retq   

0000000000801fe0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fe0:	55                   	push   %rbp
  801fe1:	48 89 e5             	mov    %rsp,%rbp
  801fe4:	48 83 ec 20          	sub    $0x20,%rsp
  801fe8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ff3:	78 06                	js     801ffb <fd_lookup+0x1b>
  801ff5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ff9:	7e 07                	jle    802002 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ffb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802000:	eb 6c                	jmp    80206e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802002:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802005:	48 98                	cltq   
  802007:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80200d:	48 c1 e0 0c          	shl    $0xc,%rax
  802011:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802019:	48 c1 e8 15          	shr    $0x15,%rax
  80201d:	48 89 c2             	mov    %rax,%rdx
  802020:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802027:	01 00 00 
  80202a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202e:	83 e0 01             	and    $0x1,%eax
  802031:	48 85 c0             	test   %rax,%rax
  802034:	74 21                	je     802057 <fd_lookup+0x77>
  802036:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80203a:	48 c1 e8 0c          	shr    $0xc,%rax
  80203e:	48 89 c2             	mov    %rax,%rdx
  802041:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802048:	01 00 00 
  80204b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204f:	83 e0 01             	and    $0x1,%eax
  802052:	48 85 c0             	test   %rax,%rax
  802055:	75 07                	jne    80205e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80205c:	eb 10                	jmp    80206e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80205e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802062:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802066:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206e:	c9                   	leaveq 
  80206f:	c3                   	retq   

0000000000802070 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802070:	55                   	push   %rbp
  802071:	48 89 e5             	mov    %rsp,%rbp
  802074:	48 83 ec 30          	sub    $0x30,%rsp
  802078:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80207c:	89 f0                	mov    %esi,%eax
  80207e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802081:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802085:	48 89 c7             	mov    %rax,%rdi
  802088:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	89 c2                	mov    %eax,%edx
  802096:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80209a:	48 89 c6             	mov    %rax,%rsi
  80209d:	89 d7                	mov    %edx,%edi
  80209f:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  8020a6:	00 00 00 
  8020a9:	ff d0                	callq  *%rax
  8020ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b2:	78 0a                	js     8020be <fd_close+0x4e>
	    || fd != fd2)
  8020b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020bc:	74 12                	je     8020d0 <fd_close+0x60>
		return (must_exist ? r : 0);
  8020be:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020c2:	74 05                	je     8020c9 <fd_close+0x59>
  8020c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c7:	eb 70                	jmp    802139 <fd_close+0xc9>
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ce:	eb 69                	jmp    802139 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d4:	8b 00                	mov    (%rax),%eax
  8020d6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020da:	48 89 d6             	mov    %rdx,%rsi
  8020dd:	89 c7                	mov    %eax,%edi
  8020df:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	callq  *%rax
  8020eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020f2:	78 2a                	js     80211e <fd_close+0xae>
		if (dev->dev_close)
  8020f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020fc:	48 85 c0             	test   %rax,%rax
  8020ff:	74 16                	je     802117 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802105:	48 8b 40 20          	mov    0x20(%rax),%rax
  802109:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80210d:	48 89 d7             	mov    %rdx,%rdi
  802110:	ff d0                	callq  *%rax
  802112:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802115:	eb 07                	jmp    80211e <fd_close+0xae>
		else
			r = 0;
  802117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80211e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802122:	48 89 c6             	mov    %rax,%rsi
  802125:	bf 00 00 00 00       	mov    $0x0,%edi
  80212a:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  802131:	00 00 00 
  802134:	ff d0                	callq  *%rax
	return r;
  802136:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802139:	c9                   	leaveq 
  80213a:	c3                   	retq   

000000000080213b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80213b:	55                   	push   %rbp
  80213c:	48 89 e5             	mov    %rsp,%rbp
  80213f:	48 83 ec 20          	sub    $0x20,%rsp
  802143:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802146:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80214a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802151:	eb 41                	jmp    802194 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802153:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80215a:	00 00 00 
  80215d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802160:	48 63 d2             	movslq %edx,%rdx
  802163:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802167:	8b 00                	mov    (%rax),%eax
  802169:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80216c:	75 22                	jne    802190 <dev_lookup+0x55>
			*dev = devtab[i];
  80216e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802175:	00 00 00 
  802178:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80217b:	48 63 d2             	movslq %edx,%rdx
  80217e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802182:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802186:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	eb 60                	jmp    8021f0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802190:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802194:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80219b:	00 00 00 
  80219e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021a1:	48 63 d2             	movslq %edx,%rdx
  8021a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a8:	48 85 c0             	test   %rax,%rax
  8021ab:	75 a6                	jne    802153 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021ad:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8021b4:	00 00 00 
  8021b7:	48 8b 00             	mov    (%rax),%rax
  8021ba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021c0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021c3:	89 c6                	mov    %eax,%esi
  8021c5:	48 bf 98 53 80 00 00 	movabs $0x805398,%rdi
  8021cc:	00 00 00 
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  8021db:	00 00 00 
  8021de:	ff d1                	callq  *%rcx
	*dev = 0;
  8021e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021f0:	c9                   	leaveq 
  8021f1:	c3                   	retq   

00000000008021f2 <close>:

int
close(int fdnum)
{
  8021f2:	55                   	push   %rbp
  8021f3:	48 89 e5             	mov    %rsp,%rbp
  8021f6:	48 83 ec 20          	sub    $0x20,%rsp
  8021fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021fd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802201:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802204:	48 89 d6             	mov    %rdx,%rsi
  802207:	89 c7                	mov    %eax,%edi
  802209:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
  802215:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802218:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221c:	79 05                	jns    802223 <close+0x31>
		return r;
  80221e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802221:	eb 18                	jmp    80223b <close+0x49>
	else
		return fd_close(fd, 1);
  802223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802227:	be 01 00 00 00       	mov    $0x1,%esi
  80222c:	48 89 c7             	mov    %rax,%rdi
  80222f:	48 b8 70 20 80 00 00 	movabs $0x802070,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
}
  80223b:	c9                   	leaveq 
  80223c:	c3                   	retq   

000000000080223d <close_all>:

void
close_all(void)
{
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80224c:	eb 15                	jmp    802263 <close_all+0x26>
		close(i);
  80224e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802251:	89 c7                	mov    %eax,%edi
  802253:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80225f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802263:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802267:	7e e5                	jle    80224e <close_all+0x11>
		close(i);
}
  802269:	90                   	nop
  80226a:	c9                   	leaveq 
  80226b:	c3                   	retq   

000000000080226c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80226c:	55                   	push   %rbp
  80226d:	48 89 e5             	mov    %rsp,%rbp
  802270:	48 83 ec 40          	sub    $0x40,%rsp
  802274:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802277:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80227a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80227e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802281:	48 89 d6             	mov    %rdx,%rsi
  802284:	89 c7                	mov    %eax,%edi
  802286:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  80228d:	00 00 00 
  802290:	ff d0                	callq  *%rax
  802292:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802295:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802299:	79 08                	jns    8022a3 <dup+0x37>
		return r;
  80229b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229e:	e9 70 01 00 00       	jmpq   802413 <dup+0x1a7>
	close(newfdnum);
  8022a3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a6:	89 c7                	mov    %eax,%edi
  8022a8:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022b4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022b7:	48 98                	cltq   
  8022b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8022c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022cb:	48 89 c7             	mov    %rax,%rdi
  8022ce:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  8022d5:	00 00 00 
  8022d8:	ff d0                	callq  *%rax
  8022da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e2:	48 89 c7             	mov    %rax,%rdi
  8022e5:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	callq  *%rax
  8022f1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f9:	48 c1 e8 15          	shr    $0x15,%rax
  8022fd:	48 89 c2             	mov    %rax,%rdx
  802300:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802307:	01 00 00 
  80230a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80230e:	83 e0 01             	and    $0x1,%eax
  802311:	48 85 c0             	test   %rax,%rax
  802314:	74 71                	je     802387 <dup+0x11b>
  802316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231a:	48 c1 e8 0c          	shr    $0xc,%rax
  80231e:	48 89 c2             	mov    %rax,%rdx
  802321:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802328:	01 00 00 
  80232b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80232f:	83 e0 01             	and    $0x1,%eax
  802332:	48 85 c0             	test   %rax,%rax
  802335:	74 50                	je     802387 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233b:	48 c1 e8 0c          	shr    $0xc,%rax
  80233f:	48 89 c2             	mov    %rax,%rdx
  802342:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802349:	01 00 00 
  80234c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802350:	25 07 0e 00 00       	and    $0xe07,%eax
  802355:	89 c1                	mov    %eax,%ecx
  802357:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80235b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235f:	41 89 c8             	mov    %ecx,%r8d
  802362:	48 89 d1             	mov    %rdx,%rcx
  802365:	ba 00 00 00 00       	mov    $0x0,%edx
  80236a:	48 89 c6             	mov    %rax,%rsi
  80236d:	bf 00 00 00 00       	mov    $0x0,%edi
  802372:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
  80237e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802381:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802385:	78 55                	js     8023dc <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238b:	48 c1 e8 0c          	shr    $0xc,%rax
  80238f:	48 89 c2             	mov    %rax,%rdx
  802392:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802399:	01 00 00 
  80239c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8023a5:	89 c1                	mov    %eax,%ecx
  8023a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023af:	41 89 c8             	mov    %ecx,%r8d
  8023b2:	48 89 d1             	mov    %rdx,%rcx
  8023b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ba:	48 89 c6             	mov    %rax,%rsi
  8023bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c2:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	callq  *%rax
  8023ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d5:	78 08                	js     8023df <dup+0x173>
		goto err;

	return newfdnum;
  8023d7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023da:	eb 37                	jmp    802413 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8023dc:	90                   	nop
  8023dd:	eb 01                	jmp    8023e0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8023df:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8023e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e4:	48 89 c6             	mov    %rax,%rsi
  8023e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ec:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  8023f3:	00 00 00 
  8023f6:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023fc:	48 89 c6             	mov    %rax,%rsi
  8023ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802404:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
	return r;
  802410:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802413:	c9                   	leaveq 
  802414:	c3                   	retq   

0000000000802415 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802415:	55                   	push   %rbp
  802416:	48 89 e5             	mov    %rsp,%rbp
  802419:	48 83 ec 40          	sub    $0x40,%rsp
  80241d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802420:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802424:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802428:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80242f:	48 89 d6             	mov    %rdx,%rsi
  802432:	89 c7                	mov    %eax,%edi
  802434:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	callq  *%rax
  802440:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802443:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802447:	78 24                	js     80246d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244d:	8b 00                	mov    (%rax),%eax
  80244f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802453:	48 89 d6             	mov    %rdx,%rsi
  802456:	89 c7                	mov    %eax,%edi
  802458:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
  802464:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246b:	79 05                	jns    802472 <read+0x5d>
		return r;
  80246d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802470:	eb 76                	jmp    8024e8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802476:	8b 40 08             	mov    0x8(%rax),%eax
  802479:	83 e0 03             	and    $0x3,%eax
  80247c:	83 f8 01             	cmp    $0x1,%eax
  80247f:	75 3a                	jne    8024bb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802481:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802488:	00 00 00 
  80248b:	48 8b 00             	mov    (%rax),%rax
  80248e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802494:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802497:	89 c6                	mov    %eax,%esi
  802499:	48 bf b7 53 80 00 00 	movabs $0x8053b7,%rdi
  8024a0:	00 00 00 
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  8024af:	00 00 00 
  8024b2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b9:	eb 2d                	jmp    8024e8 <read+0xd3>
	}
	if (!dev->dev_read)
  8024bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024c3:	48 85 c0             	test   %rax,%rax
  8024c6:	75 07                	jne    8024cf <read+0xba>
		return -E_NOT_SUPP;
  8024c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024cd:	eb 19                	jmp    8024e8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024d7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024db:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024df:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024e3:	48 89 cf             	mov    %rcx,%rdi
  8024e6:	ff d0                	callq  *%rax
}
  8024e8:	c9                   	leaveq 
  8024e9:	c3                   	retq   

00000000008024ea <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024ea:	55                   	push   %rbp
  8024eb:	48 89 e5             	mov    %rsp,%rbp
  8024ee:	48 83 ec 30          	sub    $0x30,%rsp
  8024f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802504:	eb 47                	jmp    80254d <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802509:	48 98                	cltq   
  80250b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80250f:	48 29 c2             	sub    %rax,%rdx
  802512:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802515:	48 63 c8             	movslq %eax,%rcx
  802518:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251c:	48 01 c1             	add    %rax,%rcx
  80251f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802522:	48 89 ce             	mov    %rcx,%rsi
  802525:	89 c7                	mov    %eax,%edi
  802527:	48 b8 15 24 80 00 00 	movabs $0x802415,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax
  802533:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802536:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80253a:	79 05                	jns    802541 <readn+0x57>
			return m;
  80253c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80253f:	eb 1d                	jmp    80255e <readn+0x74>
		if (m == 0)
  802541:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802545:	74 13                	je     80255a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802547:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80254a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802550:	48 98                	cltq   
  802552:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802556:	72 ae                	jb     802506 <readn+0x1c>
  802558:	eb 01                	jmp    80255b <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80255a:	90                   	nop
	}
	return tot;
  80255b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80255e:	c9                   	leaveq 
  80255f:	c3                   	retq   

0000000000802560 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802560:	55                   	push   %rbp
  802561:	48 89 e5             	mov    %rsp,%rbp
  802564:	48 83 ec 40          	sub    $0x40,%rsp
  802568:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80256b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80256f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802573:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802577:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80257a:	48 89 d6             	mov    %rdx,%rsi
  80257d:	89 c7                	mov    %eax,%edi
  80257f:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
  80258b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802592:	78 24                	js     8025b8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802598:	8b 00                	mov    (%rax),%eax
  80259a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80259e:	48 89 d6             	mov    %rdx,%rsi
  8025a1:	89 c7                	mov    %eax,%edi
  8025a3:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  8025aa:	00 00 00 
  8025ad:	ff d0                	callq  *%rax
  8025af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b6:	79 05                	jns    8025bd <write+0x5d>
		return r;
  8025b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bb:	eb 75                	jmp    802632 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c1:	8b 40 08             	mov    0x8(%rax),%eax
  8025c4:	83 e0 03             	and    $0x3,%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	75 3a                	jne    802605 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025cb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025d2:	00 00 00 
  8025d5:	48 8b 00             	mov    (%rax),%rax
  8025d8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025de:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025e1:	89 c6                	mov    %eax,%esi
  8025e3:	48 bf d3 53 80 00 00 	movabs $0x8053d3,%rdi
  8025ea:	00 00 00 
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f2:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  8025f9:	00 00 00 
  8025fc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802603:	eb 2d                	jmp    802632 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802609:	48 8b 40 18          	mov    0x18(%rax),%rax
  80260d:	48 85 c0             	test   %rax,%rax
  802610:	75 07                	jne    802619 <write+0xb9>
		return -E_NOT_SUPP;
  802612:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802617:	eb 19                	jmp    802632 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802621:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802625:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802629:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80262d:	48 89 cf             	mov    %rcx,%rdi
  802630:	ff d0                	callq  *%rax
}
  802632:	c9                   	leaveq 
  802633:	c3                   	retq   

0000000000802634 <seek>:

int
seek(int fdnum, off_t offset)
{
  802634:	55                   	push   %rbp
  802635:	48 89 e5             	mov    %rsp,%rbp
  802638:	48 83 ec 18          	sub    $0x18,%rsp
  80263c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80263f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802642:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802646:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802649:	48 89 d6             	mov    %rdx,%rsi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
  80265a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802661:	79 05                	jns    802668 <seek+0x34>
		return r;
  802663:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802666:	eb 0f                	jmp    802677 <seek+0x43>
	fd->fd_offset = offset;
  802668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80266f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802677:	c9                   	leaveq 
  802678:	c3                   	retq   

0000000000802679 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802679:	55                   	push   %rbp
  80267a:	48 89 e5             	mov    %rsp,%rbp
  80267d:	48 83 ec 30          	sub    $0x30,%rsp
  802681:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802684:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802687:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80268b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80268e:	48 89 d6             	mov    %rdx,%rsi
  802691:	89 c7                	mov    %eax,%edi
  802693:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
  80269f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026a6:	78 24                	js     8026cc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ac:	8b 00                	mov    (%rax),%eax
  8026ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026b2:	48 89 d6             	mov    %rdx,%rsi
  8026b5:	89 c7                	mov    %eax,%edi
  8026b7:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  8026be:	00 00 00 
  8026c1:	ff d0                	callq  *%rax
  8026c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ca:	79 05                	jns    8026d1 <ftruncate+0x58>
		return r;
  8026cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cf:	eb 72                	jmp    802743 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d5:	8b 40 08             	mov    0x8(%rax),%eax
  8026d8:	83 e0 03             	and    $0x3,%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	75 3a                	jne    802719 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026df:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026e6:	00 00 00 
  8026e9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026ec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026f5:	89 c6                	mov    %eax,%esi
  8026f7:	48 bf f0 53 80 00 00 	movabs $0x8053f0,%rdi
  8026fe:	00 00 00 
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  80270d:	00 00 00 
  802710:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802712:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802717:	eb 2a                	jmp    802743 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802721:	48 85 c0             	test   %rax,%rax
  802724:	75 07                	jne    80272d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802726:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272b:	eb 16                	jmp    802743 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80272d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802731:	48 8b 40 30          	mov    0x30(%rax),%rax
  802735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802739:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80273c:	89 ce                	mov    %ecx,%esi
  80273e:	48 89 d7             	mov    %rdx,%rdi
  802741:	ff d0                	callq  *%rax
}
  802743:	c9                   	leaveq 
  802744:	c3                   	retq   

0000000000802745 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802745:	55                   	push   %rbp
  802746:	48 89 e5             	mov    %rsp,%rbp
  802749:	48 83 ec 30          	sub    $0x30,%rsp
  80274d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802750:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802754:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802758:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80275b:	48 89 d6             	mov    %rdx,%rsi
  80275e:	89 c7                	mov    %eax,%edi
  802760:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  802767:	00 00 00 
  80276a:	ff d0                	callq  *%rax
  80276c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802773:	78 24                	js     802799 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802779:	8b 00                	mov    (%rax),%eax
  80277b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80277f:	48 89 d6             	mov    %rdx,%rsi
  802782:	89 c7                	mov    %eax,%edi
  802784:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  80278b:	00 00 00 
  80278e:	ff d0                	callq  *%rax
  802790:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802793:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802797:	79 05                	jns    80279e <fstat+0x59>
		return r;
  802799:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279c:	eb 5e                	jmp    8027fc <fstat+0xb7>
	if (!dev->dev_stat)
  80279e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027a6:	48 85 c0             	test   %rax,%rax
  8027a9:	75 07                	jne    8027b2 <fstat+0x6d>
		return -E_NOT_SUPP;
  8027ab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027b0:	eb 4a                	jmp    8027fc <fstat+0xb7>
	stat->st_name[0] = 0;
  8027b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027b6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027bd:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027c4:	00 00 00 
	stat->st_isdir = 0;
  8027c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027cb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027d2:	00 00 00 
	stat->st_dev = dev;
  8027d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027dd:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027f0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027f4:	48 89 ce             	mov    %rcx,%rsi
  8027f7:	48 89 d7             	mov    %rdx,%rdi
  8027fa:	ff d0                	callq  *%rax
}
  8027fc:	c9                   	leaveq 
  8027fd:	c3                   	retq   

00000000008027fe <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027fe:	55                   	push   %rbp
  8027ff:	48 89 e5             	mov    %rsp,%rbp
  802802:	48 83 ec 20          	sub    $0x20,%rsp
  802806:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80280a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80280e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802812:	be 00 00 00 00       	mov    $0x0,%esi
  802817:	48 89 c7             	mov    %rax,%rdi
  80281a:	48 b8 ee 28 80 00 00 	movabs $0x8028ee,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
  802826:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802829:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282d:	79 05                	jns    802834 <stat+0x36>
		return fd;
  80282f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802832:	eb 2f                	jmp    802863 <stat+0x65>
	r = fstat(fd, stat);
  802834:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283b:	48 89 d6             	mov    %rdx,%rsi
  80283e:	89 c7                	mov    %eax,%edi
  802840:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
  80284c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80284f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802852:	89 c7                	mov    %eax,%edi
  802854:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
	return r;
  802860:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802863:	c9                   	leaveq 
  802864:	c3                   	retq   

0000000000802865 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802865:	55                   	push   %rbp
  802866:	48 89 e5             	mov    %rsp,%rbp
  802869:	48 83 ec 10          	sub    $0x10,%rsp
  80286d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802870:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802874:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80287b:	00 00 00 
  80287e:	8b 00                	mov    (%rax),%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	75 1f                	jne    8028a3 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802884:	bf 01 00 00 00       	mov    $0x1,%edi
  802889:	48 b8 6a 4c 80 00 00 	movabs $0x804c6a,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
  802895:	89 c2                	mov    %eax,%edx
  802897:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80289e:	00 00 00 
  8028a1:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028a3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028aa:	00 00 00 
  8028ad:	8b 00                	mov    (%rax),%eax
  8028af:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028b2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028b7:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8028be:	00 00 00 
  8028c1:	89 c7                	mov    %eax,%edi
  8028c3:	48 b8 d5 4b 80 00 00 	movabs $0x804bd5,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d8:	48 89 c6             	mov    %rax,%rsi
  8028db:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e0:	48 b8 14 4b 80 00 00 	movabs $0x804b14,%rax
  8028e7:	00 00 00 
  8028ea:	ff d0                	callq  *%rax
}
  8028ec:	c9                   	leaveq 
  8028ed:	c3                   	retq   

00000000008028ee <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028ee:	55                   	push   %rbp
  8028ef:	48 89 e5             	mov    %rsp,%rbp
  8028f2:	48 83 ec 20          	sub    $0x20,%rsp
  8028f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8028fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802901:	48 89 c7             	mov    %rax,%rdi
  802904:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
  802910:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802915:	7e 0a                	jle    802921 <open+0x33>
		return -E_BAD_PATH;
  802917:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80291c:	e9 a5 00 00 00       	jmpq   8029c6 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802921:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802925:	48 89 c7             	mov    %rax,%rdi
  802928:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  80292f:	00 00 00 
  802932:	ff d0                	callq  *%rax
  802934:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802937:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293b:	79 08                	jns    802945 <open+0x57>
		return r;
  80293d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802940:	e9 81 00 00 00       	jmpq   8029c6 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802949:	48 89 c6             	mov    %rax,%rsi
  80294c:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802953:	00 00 00 
  802956:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  80295d:	00 00 00 
  802960:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802962:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802969:	00 00 00 
  80296c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80296f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802979:	48 89 c6             	mov    %rax,%rsi
  80297c:	bf 01 00 00 00       	mov    $0x1,%edi
  802981:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
  80298d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802990:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802994:	79 1d                	jns    8029b3 <open+0xc5>
		fd_close(fd, 0);
  802996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299a:	be 00 00 00 00       	mov    $0x0,%esi
  80299f:	48 89 c7             	mov    %rax,%rdi
  8029a2:	48 b8 70 20 80 00 00 	movabs $0x802070,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
		return r;
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b1:	eb 13                	jmp    8029c6 <open+0xd8>
	}

	return fd2num(fd);
  8029b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b7:	48 89 c7             	mov    %rax,%rdi
  8029ba:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  8029c1:	00 00 00 
  8029c4:	ff d0                	callq  *%rax

}
  8029c6:	c9                   	leaveq 
  8029c7:	c3                   	retq   

00000000008029c8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029c8:	55                   	push   %rbp
  8029c9:	48 89 e5             	mov    %rsp,%rbp
  8029cc:	48 83 ec 10          	sub    $0x10,%rsp
  8029d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8029db:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029e2:	00 00 00 
  8029e5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029e7:	be 00 00 00 00       	mov    $0x0,%esi
  8029ec:	bf 06 00 00 00       	mov    $0x6,%edi
  8029f1:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
}
  8029fd:	c9                   	leaveq 
  8029fe:	c3                   	retq   

00000000008029ff <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029ff:	55                   	push   %rbp
  802a00:	48 89 e5             	mov    %rsp,%rbp
  802a03:	48 83 ec 30          	sub    $0x30,%rsp
  802a07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 50 0c             	mov    0xc(%rax),%edx
  802a1a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a21:	00 00 00 
  802a24:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a26:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a2d:	00 00 00 
  802a30:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a34:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802a38:	be 00 00 00 00       	mov    $0x0,%esi
  802a3d:	bf 03 00 00 00       	mov    $0x3,%edi
  802a42:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802a49:	00 00 00 
  802a4c:	ff d0                	callq  *%rax
  802a4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a55:	79 08                	jns    802a5f <devfile_read+0x60>
		return r;
  802a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5a:	e9 a4 00 00 00       	jmpq   802b03 <devfile_read+0x104>
	assert(r <= n);
  802a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a62:	48 98                	cltq   
  802a64:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a68:	76 35                	jbe    802a9f <devfile_read+0xa0>
  802a6a:	48 b9 16 54 80 00 00 	movabs $0x805416,%rcx
  802a71:	00 00 00 
  802a74:	48 ba 1d 54 80 00 00 	movabs $0x80541d,%rdx
  802a7b:	00 00 00 
  802a7e:	be 86 00 00 00       	mov    $0x86,%esi
  802a83:	48 bf 32 54 80 00 00 	movabs $0x805432,%rdi
  802a8a:	00 00 00 
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a92:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  802a99:	00 00 00 
  802a9c:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802a9f:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802aa6:	7e 35                	jle    802add <devfile_read+0xde>
  802aa8:	48 b9 3d 54 80 00 00 	movabs $0x80543d,%rcx
  802aaf:	00 00 00 
  802ab2:	48 ba 1d 54 80 00 00 	movabs $0x80541d,%rdx
  802ab9:	00 00 00 
  802abc:	be 87 00 00 00       	mov    $0x87,%esi
  802ac1:	48 bf 32 54 80 00 00 	movabs $0x805432,%rdi
  802ac8:	00 00 00 
  802acb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad0:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  802ad7:	00 00 00 
  802ada:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae0:	48 63 d0             	movslq %eax,%rdx
  802ae3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae7:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802aee:	00 00 00 
  802af1:	48 89 c7             	mov    %rax,%rdi
  802af4:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
	return r;
  802b00:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802b03:	c9                   	leaveq 
  802b04:	c3                   	retq   

0000000000802b05 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
  802b09:	48 83 ec 40          	sub    $0x40,%rsp
  802b0d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b11:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b15:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802b19:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b21:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802b28:	00 
  802b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802b31:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802b36:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b3e:	8b 50 0c             	mov    0xc(%rax),%edx
  802b41:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b48:	00 00 00 
  802b4b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b4d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b54:	00 00 00 
  802b57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b5b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802b5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b67:	48 89 c6             	mov    %rax,%rsi
  802b6a:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802b71:	00 00 00 
  802b74:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b80:	be 00 00 00 00       	mov    $0x0,%esi
  802b85:	bf 04 00 00 00       	mov    $0x4,%edi
  802b8a:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	callq  *%rax
  802b96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b9d:	79 05                	jns    802ba4 <devfile_write+0x9f>
		return r;
  802b9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba2:	eb 43                	jmp    802be7 <devfile_write+0xe2>
	assert(r <= n);
  802ba4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba7:	48 98                	cltq   
  802ba9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802bad:	76 35                	jbe    802be4 <devfile_write+0xdf>
  802baf:	48 b9 16 54 80 00 00 	movabs $0x805416,%rcx
  802bb6:	00 00 00 
  802bb9:	48 ba 1d 54 80 00 00 	movabs $0x80541d,%rdx
  802bc0:	00 00 00 
  802bc3:	be a2 00 00 00       	mov    $0xa2,%esi
  802bc8:	48 bf 32 54 80 00 00 	movabs $0x805432,%rdi
  802bcf:	00 00 00 
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd7:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  802bde:	00 00 00 
  802be1:	41 ff d0             	callq  *%r8
	return r;
  802be4:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802be7:	c9                   	leaveq 
  802be8:	c3                   	retq   

0000000000802be9 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802be9:	55                   	push   %rbp
  802bea:	48 89 e5             	mov    %rsp,%rbp
  802bed:	48 83 ec 20          	sub    $0x20,%rsp
  802bf1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	8b 50 0c             	mov    0xc(%rax),%edx
  802c00:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c07:	00 00 00 
  802c0a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c0c:	be 00 00 00 00       	mov    $0x0,%esi
  802c11:	bf 05 00 00 00       	mov    $0x5,%edi
  802c16:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802c1d:	00 00 00 
  802c20:	ff d0                	callq  *%rax
  802c22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c29:	79 05                	jns    802c30 <devfile_stat+0x47>
		return r;
  802c2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2e:	eb 56                	jmp    802c86 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c34:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802c3b:	00 00 00 
  802c3e:	48 89 c7             	mov    %rax,%rdi
  802c41:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c4d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c54:	00 00 00 
  802c57:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c61:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c67:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c6e:	00 00 00 
  802c71:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c86:	c9                   	leaveq 
  802c87:	c3                   	retq   

0000000000802c88 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c88:	55                   	push   %rbp
  802c89:	48 89 e5             	mov    %rsp,%rbp
  802c8c:	48 83 ec 10          	sub    $0x10,%rsp
  802c90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c94:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9b:	8b 50 0c             	mov    0xc(%rax),%edx
  802c9e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ca5:	00 00 00 
  802ca8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802caa:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802cb1:	00 00 00 
  802cb4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802cb7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802cba:	be 00 00 00 00       	mov    $0x0,%esi
  802cbf:	bf 02 00 00 00       	mov    $0x2,%edi
  802cc4:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802ccb:	00 00 00 
  802cce:	ff d0                	callq  *%rax
}
  802cd0:	c9                   	leaveq 
  802cd1:	c3                   	retq   

0000000000802cd2 <remove>:

// Delete a file
int
remove(const char *path)
{
  802cd2:	55                   	push   %rbp
  802cd3:	48 89 e5             	mov    %rsp,%rbp
  802cd6:	48 83 ec 10          	sub    $0x10,%rsp
  802cda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802cde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce2:	48 89 c7             	mov    %rax,%rdi
  802ce5:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
  802cf1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cf6:	7e 07                	jle    802cff <remove+0x2d>
		return -E_BAD_PATH;
  802cf8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cfd:	eb 33                	jmp    802d32 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d03:	48 89 c6             	mov    %rax,%rsi
  802d06:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802d0d:	00 00 00 
  802d10:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d1c:	be 00 00 00 00       	mov    $0x0,%esi
  802d21:	bf 07 00 00 00       	mov    $0x7,%edi
  802d26:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802d2d:	00 00 00 
  802d30:	ff d0                	callq  *%rax
}
  802d32:	c9                   	leaveq 
  802d33:	c3                   	retq   

0000000000802d34 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d34:	55                   	push   %rbp
  802d35:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d38:	be 00 00 00 00       	mov    $0x0,%esi
  802d3d:	bf 08 00 00 00       	mov    $0x8,%edi
  802d42:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
}
  802d4e:	5d                   	pop    %rbp
  802d4f:	c3                   	retq   

0000000000802d50 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d50:	55                   	push   %rbp
  802d51:	48 89 e5             	mov    %rsp,%rbp
  802d54:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d5b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d62:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d69:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d70:	be 00 00 00 00       	mov    $0x0,%esi
  802d75:	48 89 c7             	mov    %rax,%rdi
  802d78:	48 b8 ee 28 80 00 00 	movabs $0x8028ee,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax
  802d84:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8b:	79 28                	jns    802db5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d90:	89 c6                	mov    %eax,%esi
  802d92:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  802d99:	00 00 00 
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802da1:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802da8:	00 00 00 
  802dab:	ff d2                	callq  *%rdx
		return fd_src;
  802dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db0:	e9 76 01 00 00       	jmpq   802f2b <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802db5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802dbc:	be 01 01 00 00       	mov    $0x101,%esi
  802dc1:	48 89 c7             	mov    %rax,%rdi
  802dc4:	48 b8 ee 28 80 00 00 	movabs $0x8028ee,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
  802dd0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802dd3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dd7:	0f 89 ad 00 00 00    	jns    802e8a <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ddd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de0:	89 c6                	mov    %eax,%esi
  802de2:	48 bf 5f 54 80 00 00 	movabs $0x80545f,%rdi
  802de9:	00 00 00 
  802dec:	b8 00 00 00 00       	mov    $0x0,%eax
  802df1:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802df8:	00 00 00 
  802dfb:	ff d2                	callq  *%rdx
		close(fd_src);
  802dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
		return fd_dest;
  802e0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e11:	e9 15 01 00 00       	jmpq   802f2b <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802e16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e19:	48 63 d0             	movslq %eax,%rdx
  802e1c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e26:	48 89 ce             	mov    %rcx,%rsi
  802e29:	89 c7                	mov    %eax,%edi
  802e2b:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e3e:	79 4a                	jns    802e8a <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802e40:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e43:	89 c6                	mov    %eax,%esi
  802e45:	48 bf 79 54 80 00 00 	movabs $0x805479,%rdi
  802e4c:	00 00 00 
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e54:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802e5b:	00 00 00 
  802e5e:	ff d2                	callq  *%rdx
			close(fd_src);
  802e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
			close(fd_dest);
  802e71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e74:	89 c7                	mov    %eax,%edi
  802e76:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
			return write_size;
  802e82:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e85:	e9 a1 00 00 00       	jmpq   802f2b <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e8a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	ba 00 02 00 00       	mov    $0x200,%edx
  802e99:	48 89 ce             	mov    %rcx,%rsi
  802e9c:	89 c7                	mov    %eax,%edi
  802e9e:	48 b8 15 24 80 00 00 	movabs $0x802415,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
  802eaa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802eb1:	0f 8f 5f ff ff ff    	jg     802e16 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ebb:	79 47                	jns    802f04 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802ebd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ec0:	89 c6                	mov    %eax,%esi
  802ec2:	48 bf 8c 54 80 00 00 	movabs $0x80548c,%rdi
  802ec9:	00 00 00 
  802ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed1:	48 ba 3c 05 80 00 00 	movabs $0x80053c,%rdx
  802ed8:	00 00 00 
  802edb:	ff d2                	callq  *%rdx
		close(fd_src);
  802edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee0:	89 c7                	mov    %eax,%edi
  802ee2:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
		close(fd_dest);
  802eee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef1:	89 c7                	mov    %eax,%edi
  802ef3:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	callq  *%rax
		return read_size;
  802eff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f02:	eb 27                	jmp    802f2b <copy+0x1db>
	}
	close(fd_src);
  802f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f07:	89 c7                	mov    %eax,%edi
  802f09:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802f10:	00 00 00 
  802f13:	ff d0                	callq  *%rax
	close(fd_dest);
  802f15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f18:	89 c7                	mov    %eax,%edi
  802f1a:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
	return 0;
  802f26:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f2b:	c9                   	leaveq 
  802f2c:	c3                   	retq   

0000000000802f2d <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802f2d:	55                   	push   %rbp
  802f2e:	48 89 e5             	mov    %rsp,%rbp
  802f31:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802f38:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802f3f:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802f46:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802f4d:	be 00 00 00 00       	mov    $0x0,%esi
  802f52:	48 89 c7             	mov    %rax,%rdi
  802f55:	48 b8 ee 28 80 00 00 	movabs $0x8028ee,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f64:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f68:	79 08                	jns    802f72 <spawn+0x45>
		return r;
  802f6a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f6d:	e9 11 03 00 00       	jmpq   803283 <spawn+0x356>
	fd = r;
  802f72:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f75:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802f78:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802f7f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802f83:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802f8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f8d:	ba 00 02 00 00       	mov    $0x200,%edx
  802f92:	48 89 ce             	mov    %rcx,%rsi
  802f95:	89 c7                	mov    %eax,%edi
  802f97:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
  802fa3:	3d 00 02 00 00       	cmp    $0x200,%eax
  802fa8:	75 0d                	jne    802fb7 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802faa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fae:	8b 00                	mov    (%rax),%eax
  802fb0:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802fb5:	74 43                	je     802ffa <spawn+0xcd>
		close(fd);
  802fb7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802fba:	89 c7                	mov    %eax,%edi
  802fbc:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802fc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcc:	8b 00                	mov    (%rax),%eax
  802fce:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802fd3:	89 c6                	mov    %eax,%esi
  802fd5:	48 bf a8 54 80 00 00 	movabs $0x8054a8,%rdi
  802fdc:	00 00 00 
  802fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe4:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  802feb:	00 00 00 
  802fee:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802ff0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ff5:	e9 89 02 00 00       	jmpq   803283 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802ffa:	b8 07 00 00 00       	mov    $0x7,%eax
  802fff:	cd 30                	int    $0x30
  803001:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803004:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803007:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80300a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80300e:	79 08                	jns    803018 <spawn+0xeb>
		return r;
  803010:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803013:	e9 6b 02 00 00       	jmpq   803283 <spawn+0x356>
	child = r;
  803018:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80301b:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80301e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803021:	25 ff 03 00 00       	and    $0x3ff,%eax
  803026:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80302d:	00 00 00 
  803030:	48 98                	cltq   
  803032:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803039:	48 01 c2             	add    %rax,%rdx
  80303c:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803043:	48 89 d6             	mov    %rdx,%rsi
  803046:	ba 18 00 00 00       	mov    $0x18,%edx
  80304b:	48 89 c7             	mov    %rax,%rdi
  80304e:	48 89 d1             	mov    %rdx,%rcx
  803051:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803054:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803058:	48 8b 40 18          	mov    0x18(%rax),%rax
  80305c:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803063:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80306a:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803071:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803078:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80307b:	48 89 ce             	mov    %rcx,%rsi
  80307e:	89 c7                	mov    %eax,%edi
  803080:	48 b8 e7 34 80 00 00 	movabs $0x8034e7,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
  80308c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80308f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803093:	79 08                	jns    80309d <spawn+0x170>
		return r;
  803095:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803098:	e9 e6 01 00 00       	jmpq   803283 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80309d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8030a5:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8030ac:	48 01 d0             	add    %rdx,%rax
  8030af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8030b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030ba:	e9 80 00 00 00       	jmpq   80313f <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  8030bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c3:	8b 00                	mov    (%rax),%eax
  8030c5:	83 f8 01             	cmp    $0x1,%eax
  8030c8:	75 6b                	jne    803135 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  8030ca:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8030d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d5:	8b 40 04             	mov    0x4(%rax),%eax
  8030d8:	83 e0 02             	and    $0x2,%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	74 04                	je     8030e3 <spawn+0x1b6>
			perm |= PTE_W;
  8030df:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8030e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e7:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8030eb:	41 89 c1             	mov    %eax,%r9d
  8030ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f2:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8030f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fa:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8030fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803102:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803106:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803109:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80310c:	48 83 ec 08          	sub    $0x8,%rsp
  803110:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803113:	57                   	push   %rdi
  803114:	89 c7                	mov    %eax,%edi
  803116:	48 b8 93 37 80 00 00 	movabs $0x803793,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
  803122:	48 83 c4 10          	add    $0x10,%rsp
  803126:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803129:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80312d:	0f 88 2a 01 00 00    	js     80325d <spawn+0x330>
  803133:	eb 01                	jmp    803136 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803135:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803136:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80313a:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80313f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803143:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803147:	0f b7 c0             	movzwl %ax,%eax
  80314a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80314d:	0f 8f 6c ff ff ff    	jg     8030bf <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803153:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803156:	89 c7                	mov    %eax,%edi
  803158:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
	fd = -1;
  803164:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80316b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80316e:	89 c7                	mov    %eax,%edi
  803170:	48 b8 7f 39 80 00 00 	movabs $0x80397f,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
  80317c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80317f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803183:	79 30                	jns    8031b5 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  803185:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803188:	89 c1                	mov    %eax,%ecx
  80318a:	48 ba c2 54 80 00 00 	movabs $0x8054c2,%rdx
  803191:	00 00 00 
  803194:	be 86 00 00 00       	mov    $0x86,%esi
  803199:	48 bf d8 54 80 00 00 	movabs $0x8054d8,%rdi
  8031a0:	00 00 00 
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a8:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8031af:	00 00 00 
  8031b2:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8031b5:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8031bc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8031bf:	48 89 d6             	mov    %rdx,%rsi
  8031c2:	89 c7                	mov    %eax,%edi
  8031c4:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
  8031d0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031d7:	79 30                	jns    803209 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  8031d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031dc:	89 c1                	mov    %eax,%ecx
  8031de:	48 ba e4 54 80 00 00 	movabs $0x8054e4,%rdx
  8031e5:	00 00 00 
  8031e8:	be 8a 00 00 00       	mov    $0x8a,%esi
  8031ed:	48 bf d8 54 80 00 00 	movabs $0x8054d8,%rdi
  8031f4:	00 00 00 
  8031f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fc:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  803203:	00 00 00 
  803206:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803209:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80320c:	be 02 00 00 00       	mov    $0x2,%esi
  803211:	89 c7                	mov    %eax,%edi
  803213:	48 b8 00 1b 80 00 00 	movabs $0x801b00,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
  80321f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803222:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803226:	79 30                	jns    803258 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  803228:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80322b:	89 c1                	mov    %eax,%ecx
  80322d:	48 ba fe 54 80 00 00 	movabs $0x8054fe,%rdx
  803234:	00 00 00 
  803237:	be 8d 00 00 00       	mov    $0x8d,%esi
  80323c:	48 bf d8 54 80 00 00 	movabs $0x8054d8,%rdi
  803243:	00 00 00 
  803246:	b8 00 00 00 00       	mov    $0x0,%eax
  80324b:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  803252:	00 00 00 
  803255:	41 ff d0             	callq  *%r8

	return child;
  803258:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80325b:	eb 26                	jmp    803283 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80325d:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80325e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803261:	89 c7                	mov    %eax,%edi
  803263:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
	close(fd);
  80326f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803272:	89 c7                	mov    %eax,%edi
  803274:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
	return r;
  803280:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  803283:	c9                   	leaveq 
  803284:	c3                   	retq   

0000000000803285 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803285:	55                   	push   %rbp
  803286:	48 89 e5             	mov    %rsp,%rbp
  803289:	41 55                	push   %r13
  80328b:	41 54                	push   %r12
  80328d:	53                   	push   %rbx
  80328e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803295:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  80329c:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  8032a3:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8032aa:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8032b1:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8032b8:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8032bf:	84 c0                	test   %al,%al
  8032c1:	74 26                	je     8032e9 <spawnl+0x64>
  8032c3:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8032ca:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8032d1:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8032d5:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8032d9:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8032dd:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8032e1:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8032e5:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8032e9:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8032f0:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8032f3:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8032fa:	00 00 00 
  8032fd:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803304:	00 00 00 
  803307:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80330b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803312:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803319:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803320:	eb 07                	jmp    803329 <spawnl+0xa4>
		argc++;
  803322:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803329:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80332f:	83 f8 30             	cmp    $0x30,%eax
  803332:	73 23                	jae    803357 <spawnl+0xd2>
  803334:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80333b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803341:	89 d2                	mov    %edx,%edx
  803343:	48 01 d0             	add    %rdx,%rax
  803346:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80334c:	83 c2 08             	add    $0x8,%edx
  80334f:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803355:	eb 12                	jmp    803369 <spawnl+0xe4>
  803357:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80335e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803362:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803369:	48 8b 00             	mov    (%rax),%rax
  80336c:	48 85 c0             	test   %rax,%rax
  80336f:	75 b1                	jne    803322 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803371:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803377:	83 c0 02             	add    $0x2,%eax
  80337a:	48 89 e2             	mov    %rsp,%rdx
  80337d:	48 89 d3             	mov    %rdx,%rbx
  803380:	48 63 d0             	movslq %eax,%rdx
  803383:	48 83 ea 01          	sub    $0x1,%rdx
  803387:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80338e:	48 63 d0             	movslq %eax,%rdx
  803391:	49 89 d4             	mov    %rdx,%r12
  803394:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80339a:	48 63 d0             	movslq %eax,%rdx
  80339d:	49 89 d2             	mov    %rdx,%r10
  8033a0:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8033a6:	48 98                	cltq   
  8033a8:	48 c1 e0 03          	shl    $0x3,%rax
  8033ac:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8033b0:	b8 10 00 00 00       	mov    $0x10,%eax
  8033b5:	48 83 e8 01          	sub    $0x1,%rax
  8033b9:	48 01 d0             	add    %rdx,%rax
  8033bc:	be 10 00 00 00       	mov    $0x10,%esi
  8033c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c6:	48 f7 f6             	div    %rsi
  8033c9:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8033cd:	48 29 c4             	sub    %rax,%rsp
  8033d0:	48 89 e0             	mov    %rsp,%rax
  8033d3:	48 83 c0 07          	add    $0x7,%rax
  8033d7:	48 c1 e8 03          	shr    $0x3,%rax
  8033db:	48 c1 e0 03          	shl    $0x3,%rax
  8033df:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8033e6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8033ed:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8033f4:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8033f7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033fd:	8d 50 01             	lea    0x1(%rax),%edx
  803400:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803407:	48 63 d2             	movslq %edx,%rdx
  80340a:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803411:	00 

	va_start(vl, arg0);
  803412:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803419:	00 00 00 
  80341c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803423:	00 00 00 
  803426:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80342a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803431:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803438:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80343f:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803446:	00 00 00 
  803449:	eb 60                	jmp    8034ab <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  80344b:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803451:	8d 48 01             	lea    0x1(%rax),%ecx
  803454:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80345a:	83 f8 30             	cmp    $0x30,%eax
  80345d:	73 23                	jae    803482 <spawnl+0x1fd>
  80345f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  803466:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80346c:	89 d2                	mov    %edx,%edx
  80346e:	48 01 d0             	add    %rdx,%rax
  803471:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803477:	83 c2 08             	add    $0x8,%edx
  80347a:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803480:	eb 12                	jmp    803494 <spawnl+0x20f>
  803482:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803489:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80348d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803494:	48 8b 10             	mov    (%rax),%rdx
  803497:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80349e:	89 c9                	mov    %ecx,%ecx
  8034a0:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8034a4:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8034ab:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8034b1:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  8034b7:	72 92                	jb     80344b <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8034b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8034c0:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8034c7:	48 89 d6             	mov    %rdx,%rsi
  8034ca:	48 89 c7             	mov    %rax,%rdi
  8034cd:	48 b8 2d 2f 80 00 00 	movabs $0x802f2d,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	48 89 dc             	mov    %rbx,%rsp
}
  8034dc:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8034e0:	5b                   	pop    %rbx
  8034e1:	41 5c                	pop    %r12
  8034e3:	41 5d                	pop    %r13
  8034e5:	5d                   	pop    %rbp
  8034e6:	c3                   	retq   

00000000008034e7 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 50          	sub    $0x50,%rsp
  8034ef:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8034f2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8034f6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8034fa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803501:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803509:	eb 33                	jmp    80353e <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80350b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80350e:	48 98                	cltq   
  803510:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803517:	00 
  803518:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80351c:	48 01 d0             	add    %rdx,%rax
  80351f:	48 8b 00             	mov    (%rax),%rax
  803522:	48 89 c7             	mov    %rax,%rdi
  803525:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	callq  *%rax
  803531:	83 c0 01             	add    $0x1,%eax
  803534:	48 98                	cltq   
  803536:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80353a:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80353e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803541:	48 98                	cltq   
  803543:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80354a:	00 
  80354b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80354f:	48 01 d0             	add    %rdx,%rax
  803552:	48 8b 00             	mov    (%rax),%rax
  803555:	48 85 c0             	test   %rax,%rax
  803558:	75 b1                	jne    80350b <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80355a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355e:	48 f7 d8             	neg    %rax
  803561:	48 05 00 10 40 00    	add    $0x401000,%rax
  803567:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80356b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803577:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80357b:	48 89 c2             	mov    %rax,%rdx
  80357e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803581:	83 c0 01             	add    $0x1,%eax
  803584:	c1 e0 03             	shl    $0x3,%eax
  803587:	48 98                	cltq   
  803589:	48 f7 d8             	neg    %rax
  80358c:	48 01 d0             	add    %rdx,%rax
  80358f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803593:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803597:	48 83 e8 10          	sub    $0x10,%rax
  80359b:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8035a1:	77 0a                	ja     8035ad <init_stack+0xc6>
		return -E_NO_MEM;
  8035a3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8035a8:	e9 e4 01 00 00       	jmpq   803791 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8035ad:	ba 07 00 00 00       	mov    $0x7,%edx
  8035b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8035b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035bc:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
  8035c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035cf:	79 08                	jns    8035d9 <init_stack+0xf2>
		return r;
  8035d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d4:	e9 b8 01 00 00       	jmpq   803791 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8035d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8035e0:	e9 8a 00 00 00       	jmpq   80366f <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  8035e5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035e8:	48 98                	cltq   
  8035ea:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035f1:	00 
  8035f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f6:	48 01 d0             	add    %rdx,%rax
  8035f9:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8035fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803602:	48 01 ca             	add    %rcx,%rdx
  803605:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80360c:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  80360f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803612:	48 98                	cltq   
  803614:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80361b:	00 
  80361c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803620:	48 01 d0             	add    %rdx,%rax
  803623:	48 8b 10             	mov    (%rax),%rdx
  803626:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80362a:	48 89 d6             	mov    %rdx,%rsi
  80362d:	48 89 c7             	mov    %rax,%rdi
  803630:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80363c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80363f:	48 98                	cltq   
  803641:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803648:	00 
  803649:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80364d:	48 01 d0             	add    %rdx,%rax
  803650:	48 8b 00             	mov    (%rax),%rax
  803653:	48 89 c7             	mov    %rax,%rdi
  803656:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  80365d:	00 00 00 
  803660:	ff d0                	callq  *%rax
  803662:	83 c0 01             	add    $0x1,%eax
  803665:	48 98                	cltq   
  803667:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80366b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80366f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803672:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803675:	0f 8c 6a ff ff ff    	jl     8035e5 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80367b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80367e:	48 98                	cltq   
  803680:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803687:	00 
  803688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368c:	48 01 d0             	add    %rdx,%rax
  80368f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803696:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80369d:	00 
  80369e:	74 35                	je     8036d5 <init_stack+0x1ee>
  8036a0:	48 b9 18 55 80 00 00 	movabs $0x805518,%rcx
  8036a7:	00 00 00 
  8036aa:	48 ba 3e 55 80 00 00 	movabs $0x80553e,%rdx
  8036b1:	00 00 00 
  8036b4:	be f6 00 00 00       	mov    $0xf6,%esi
  8036b9:	48 bf d8 54 80 00 00 	movabs $0x8054d8,%rdi
  8036c0:	00 00 00 
  8036c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c8:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8036cf:	00 00 00 
  8036d2:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8036d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d9:	48 83 e8 08          	sub    $0x8,%rax
  8036dd:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8036e2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8036e6:	48 01 ca             	add    %rcx,%rdx
  8036e9:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8036f0:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  8036f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f7:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8036fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036fe:	48 98                	cltq   
  803700:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803703:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370c:	48 01 d0             	add    %rdx,%rax
  80370f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803715:	48 89 c2             	mov    %rax,%rdx
  803718:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80371c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80371f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803722:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803728:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80372d:	89 c2                	mov    %eax,%edx
  80372f:	be 00 00 40 00       	mov    $0x400000,%esi
  803734:	bf 00 00 00 00       	mov    $0x0,%edi
  803739:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  803740:	00 00 00 
  803743:	ff d0                	callq  *%rax
  803745:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803748:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80374c:	78 26                	js     803774 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80374e:	be 00 00 40 00       	mov    $0x400000,%esi
  803753:	bf 00 00 00 00       	mov    $0x0,%edi
  803758:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
  803764:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803767:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80376b:	78 0a                	js     803777 <init_stack+0x290>
		goto error;

	return 0;
  80376d:	b8 00 00 00 00       	mov    $0x0,%eax
  803772:	eb 1d                	jmp    803791 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803774:	90                   	nop
  803775:	eb 01                	jmp    803778 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803777:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803778:	be 00 00 40 00       	mov    $0x400000,%esi
  80377d:	bf 00 00 00 00       	mov    $0x0,%edi
  803782:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
	return r;
  80378e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803791:	c9                   	leaveq 
  803792:	c3                   	retq   

0000000000803793 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803793:	55                   	push   %rbp
  803794:	48 89 e5             	mov    %rsp,%rbp
  803797:	48 83 ec 50          	sub    $0x50,%rsp
  80379b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80379e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8037a6:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8037a9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8037ad:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8037b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037b5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8037ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c1:	74 21                	je     8037e4 <map_segment+0x51>
		va -= i;
  8037c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c6:	48 98                	cltq   
  8037c8:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8037cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037cf:	48 98                	cltq   
  8037d1:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8037d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d8:	48 98                	cltq   
  8037da:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8037de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e1:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8037e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037eb:	e9 79 01 00 00       	jmpq   803969 <map_segment+0x1d6>
		if (i >= filesz) {
  8037f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f3:	48 98                	cltq   
  8037f5:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8037f9:	72 3c                	jb     803837 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8037fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037fe:	48 63 d0             	movslq %eax,%rdx
  803801:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803805:	48 01 d0             	add    %rdx,%rax
  803808:	48 89 c1             	mov    %rax,%rcx
  80380b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80380e:	8b 55 10             	mov    0x10(%rbp),%edx
  803811:	48 89 ce             	mov    %rcx,%rsi
  803814:	89 c7                	mov    %eax,%edi
  803816:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80381d:	00 00 00 
  803820:	ff d0                	callq  *%rax
  803822:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803825:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803829:	0f 89 33 01 00 00    	jns    803962 <map_segment+0x1cf>
				return r;
  80382f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803832:	e9 46 01 00 00       	jmpq   80397d <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803837:	ba 07 00 00 00       	mov    $0x7,%edx
  80383c:	be 00 00 40 00       	mov    $0x400000,%esi
  803841:	bf 00 00 00 00       	mov    $0x0,%edi
  803846:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
  803852:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803855:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803859:	79 08                	jns    803863 <map_segment+0xd0>
				return r;
  80385b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80385e:	e9 1a 01 00 00       	jmpq   80397d <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803863:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803869:	01 c2                	add    %eax,%edx
  80386b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80386e:	89 d6                	mov    %edx,%esi
  803870:	89 c7                	mov    %eax,%edi
  803872:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  803879:	00 00 00 
  80387c:	ff d0                	callq  *%rax
  80387e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803881:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803885:	79 08                	jns    80388f <map_segment+0xfc>
				return r;
  803887:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80388a:	e9 ee 00 00 00       	jmpq   80397d <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80388f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803896:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803899:	48 98                	cltq   
  80389b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80389f:	48 29 c2             	sub    %rax,%rdx
  8038a2:	48 89 d0             	mov    %rdx,%rax
  8038a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8038a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038ac:	48 63 d0             	movslq %eax,%rdx
  8038af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b3:	48 39 c2             	cmp    %rax,%rdx
  8038b6:	48 0f 47 d0          	cmova  %rax,%rdx
  8038ba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8038bd:	be 00 00 40 00       	mov    $0x400000,%esi
  8038c2:	89 c7                	mov    %eax,%edi
  8038c4:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8038cb:	00 00 00 
  8038ce:	ff d0                	callq  *%rax
  8038d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8038d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038d7:	79 08                	jns    8038e1 <map_segment+0x14e>
				return r;
  8038d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038dc:	e9 9c 00 00 00       	jmpq   80397d <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8038e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e4:	48 63 d0             	movslq %eax,%rdx
  8038e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038eb:	48 01 d0             	add    %rdx,%rax
  8038ee:	48 89 c2             	mov    %rax,%rdx
  8038f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038f4:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8038f8:	48 89 d1             	mov    %rdx,%rcx
  8038fb:	89 c2                	mov    %eax,%edx
  8038fd:	be 00 00 40 00       	mov    $0x400000,%esi
  803902:	bf 00 00 00 00       	mov    $0x0,%edi
  803907:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
  803913:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803916:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80391a:	79 30                	jns    80394c <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80391c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80391f:	89 c1                	mov    %eax,%ecx
  803921:	48 ba 53 55 80 00 00 	movabs $0x805553,%rdx
  803928:	00 00 00 
  80392b:	be 29 01 00 00       	mov    $0x129,%esi
  803930:	48 bf d8 54 80 00 00 	movabs $0x8054d8,%rdi
  803937:	00 00 00 
  80393a:	b8 00 00 00 00       	mov    $0x0,%eax
  80393f:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  803946:	00 00 00 
  803949:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80394c:	be 00 00 40 00       	mov    $0x400000,%esi
  803951:	bf 00 00 00 00       	mov    $0x0,%edi
  803956:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80395d:	00 00 00 
  803960:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803962:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396c:	48 98                	cltq   
  80396e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803972:	0f 82 78 fe ff ff    	jb     8037f0 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803978:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80397d:	c9                   	leaveq 
  80397e:	c3                   	retq   

000000000080397f <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80397f:	55                   	push   %rbp
  803980:	48 89 e5             	mov    %rsp,%rbp
  803983:	48 83 ec 30          	sub    $0x30,%rsp
  803987:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80398a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803991:	00 
  803992:	e9 eb 00 00 00       	jmpq   803a82 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399b:	48 c1 f8 12          	sar    $0x12,%rax
  80399f:	48 89 c2             	mov    %rax,%rdx
  8039a2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8039a9:	01 00 00 
  8039ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039b0:	83 e0 01             	and    $0x1,%eax
  8039b3:	48 85 c0             	test   %rax,%rax
  8039b6:	74 21                	je     8039d9 <copy_shared_pages+0x5a>
  8039b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039bc:	48 c1 f8 09          	sar    $0x9,%rax
  8039c0:	48 89 c2             	mov    %rax,%rdx
  8039c3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039ca:	01 00 00 
  8039cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039d1:	83 e0 01             	and    $0x1,%eax
  8039d4:	48 85 c0             	test   %rax,%rax
  8039d7:	75 0d                	jne    8039e6 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  8039d9:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  8039e0:	00 
  8039e1:	e9 9c 00 00 00       	jmpq   803a82 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  8039e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ea:	48 05 00 02 00 00    	add    $0x200,%rax
  8039f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  8039f4:	eb 7e                	jmp    803a74 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  8039f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039fd:	01 00 00 
  803a00:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a08:	25 01 04 00 00       	and    $0x401,%eax
  803a0d:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  803a13:	75 5a                	jne    803a6f <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  803a15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a19:	48 c1 e0 0c          	shl    $0xc,%rax
  803a1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  803a21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a28:	01 00 00 
  803a2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a33:	25 07 0e 00 00       	and    $0xe07,%eax
  803a38:	89 c6                	mov    %eax,%esi
  803a3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a3e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a45:	41 89 f0             	mov    %esi,%r8d
  803a48:	48 89 c6             	mov    %rax,%rsi
  803a4b:	bf 00 00 00 00       	mov    $0x0,%edi
  803a50:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  803a57:	00 00 00 
  803a5a:	ff d0                	callq  *%rax
  803a5c:	48 98                	cltq   
  803a5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  803a62:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a67:	79 06                	jns    803a6f <copy_shared_pages+0xf0>
						return r;
  803a69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6d:	eb 28                	jmp    803a97 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803a6f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a78:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803a7c:	0f 8c 74 ff ff ff    	jl     8039f6 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803a82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a86:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  803a8c:	0f 86 05 ff ff ff    	jbe    803997 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a97:	c9                   	leaveq 
  803a98:	c3                   	retq   

0000000000803a99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803a99:	55                   	push   %rbp
  803a9a:	48 89 e5             	mov    %rsp,%rbp
  803a9d:	48 83 ec 20          	sub    $0x20,%rsp
  803aa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803aa4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803aa8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aab:	48 89 d6             	mov    %rdx,%rsi
  803aae:	89 c7                	mov    %eax,%edi
  803ab0:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  803ab7:	00 00 00 
  803aba:	ff d0                	callq  *%rax
  803abc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac3:	79 05                	jns    803aca <fd2sockid+0x31>
		return r;
  803ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac8:	eb 24                	jmp    803aee <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ace:	8b 10                	mov    (%rax),%edx
  803ad0:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803ad7:	00 00 00 
  803ada:	8b 00                	mov    (%rax),%eax
  803adc:	39 c2                	cmp    %eax,%edx
  803ade:	74 07                	je     803ae7 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803ae0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803ae5:	eb 07                	jmp    803aee <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803ae7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aeb:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803aee:	c9                   	leaveq 
  803aef:	c3                   	retq   

0000000000803af0 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803af0:	55                   	push   %rbp
  803af1:	48 89 e5             	mov    %rsp,%rbp
  803af4:	48 83 ec 20          	sub    $0x20,%rsp
  803af8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803afb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803aff:	48 89 c7             	mov    %rax,%rdi
  803b02:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
  803b0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b15:	78 26                	js     803b3d <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803b17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1b:	ba 07 04 00 00       	mov    $0x407,%edx
  803b20:	48 89 c6             	mov    %rax,%rsi
  803b23:	bf 00 00 00 00       	mov    $0x0,%edi
  803b28:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3b:	79 16                	jns    803b53 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803b3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b40:	89 c7                	mov    %eax,%edi
  803b42:	48 b8 ff 3f 80 00 00 	movabs $0x803fff,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
		return r;
  803b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b51:	eb 3a                	jmp    803b8d <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b57:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803b5e:	00 00 00 
  803b61:	8b 12                	mov    (%rdx),%edx
  803b63:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803b65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b69:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b74:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b77:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7e:	48 89 c7             	mov    %rax,%rdi
  803b81:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
}
  803b8d:	c9                   	leaveq 
  803b8e:	c3                   	retq   

0000000000803b8f <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b8f:	55                   	push   %rbp
  803b90:	48 89 e5             	mov    %rsp,%rbp
  803b93:	48 83 ec 30          	sub    $0x30,%rsp
  803b97:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b9e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ba2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba5:	89 c7                	mov    %eax,%edi
  803ba7:	48 b8 99 3a 80 00 00 	movabs $0x803a99,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
  803bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bba:	79 05                	jns    803bc1 <accept+0x32>
		return r;
  803bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbf:	eb 3b                	jmp    803bfc <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803bc1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bc5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcc:	48 89 ce             	mov    %rcx,%rsi
  803bcf:	89 c7                	mov    %eax,%edi
  803bd1:	48 b8 dc 3e 80 00 00 	movabs $0x803edc,%rax
  803bd8:	00 00 00 
  803bdb:	ff d0                	callq  *%rax
  803bdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be4:	79 05                	jns    803beb <accept+0x5c>
		return r;
  803be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be9:	eb 11                	jmp    803bfc <accept+0x6d>
	return alloc_sockfd(r);
  803beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bee:	89 c7                	mov    %eax,%edi
  803bf0:	48 b8 f0 3a 80 00 00 	movabs $0x803af0,%rax
  803bf7:	00 00 00 
  803bfa:	ff d0                	callq  *%rax
}
  803bfc:	c9                   	leaveq 
  803bfd:	c3                   	retq   

0000000000803bfe <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bfe:	55                   	push   %rbp
  803bff:	48 89 e5             	mov    %rsp,%rbp
  803c02:	48 83 ec 20          	sub    $0x20,%rsp
  803c06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c0d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c13:	89 c7                	mov    %eax,%edi
  803c15:	48 b8 99 3a 80 00 00 	movabs $0x803a99,%rax
  803c1c:	00 00 00 
  803c1f:	ff d0                	callq  *%rax
  803c21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c28:	79 05                	jns    803c2f <bind+0x31>
		return r;
  803c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c2d:	eb 1b                	jmp    803c4a <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803c2f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c32:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c39:	48 89 ce             	mov    %rcx,%rsi
  803c3c:	89 c7                	mov    %eax,%edi
  803c3e:	48 b8 5b 3f 80 00 00 	movabs $0x803f5b,%rax
  803c45:	00 00 00 
  803c48:	ff d0                	callq  *%rax
}
  803c4a:	c9                   	leaveq 
  803c4b:	c3                   	retq   

0000000000803c4c <shutdown>:

int
shutdown(int s, int how)
{
  803c4c:	55                   	push   %rbp
  803c4d:	48 89 e5             	mov    %rsp,%rbp
  803c50:	48 83 ec 20          	sub    $0x20,%rsp
  803c54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c57:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c5d:	89 c7                	mov    %eax,%edi
  803c5f:	48 b8 99 3a 80 00 00 	movabs $0x803a99,%rax
  803c66:	00 00 00 
  803c69:	ff d0                	callq  *%rax
  803c6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c72:	79 05                	jns    803c79 <shutdown+0x2d>
		return r;
  803c74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c77:	eb 16                	jmp    803c8f <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803c79:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7f:	89 d6                	mov    %edx,%esi
  803c81:	89 c7                	mov    %eax,%edi
  803c83:	48 b8 bf 3f 80 00 00 	movabs $0x803fbf,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
}
  803c8f:	c9                   	leaveq 
  803c90:	c3                   	retq   

0000000000803c91 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803c91:	55                   	push   %rbp
  803c92:	48 89 e5             	mov    %rsp,%rbp
  803c95:	48 83 ec 10          	sub    $0x10,%rsp
  803c99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca1:	48 89 c7             	mov    %rax,%rdi
  803ca4:	48 b8 db 4c 80 00 00 	movabs $0x804cdb,%rax
  803cab:	00 00 00 
  803cae:	ff d0                	callq  *%rax
  803cb0:	83 f8 01             	cmp    $0x1,%eax
  803cb3:	75 17                	jne    803ccc <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb9:	8b 40 0c             	mov    0xc(%rax),%eax
  803cbc:	89 c7                	mov    %eax,%edi
  803cbe:	48 b8 ff 3f 80 00 00 	movabs $0x803fff,%rax
  803cc5:	00 00 00 
  803cc8:	ff d0                	callq  *%rax
  803cca:	eb 05                	jmp    803cd1 <devsock_close+0x40>
	else
		return 0;
  803ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cd1:	c9                   	leaveq 
  803cd2:	c3                   	retq   

0000000000803cd3 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803cd3:	55                   	push   %rbp
  803cd4:	48 89 e5             	mov    %rsp,%rbp
  803cd7:	48 83 ec 20          	sub    $0x20,%rsp
  803cdb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cde:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ce2:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ce5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ce8:	89 c7                	mov    %eax,%edi
  803cea:	48 b8 99 3a 80 00 00 	movabs $0x803a99,%rax
  803cf1:	00 00 00 
  803cf4:	ff d0                	callq  *%rax
  803cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfd:	79 05                	jns    803d04 <connect+0x31>
		return r;
  803cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d02:	eb 1b                	jmp    803d1f <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803d04:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d07:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0e:	48 89 ce             	mov    %rcx,%rsi
  803d11:	89 c7                	mov    %eax,%edi
  803d13:	48 b8 2c 40 80 00 00 	movabs $0x80402c,%rax
  803d1a:	00 00 00 
  803d1d:	ff d0                	callq  *%rax
}
  803d1f:	c9                   	leaveq 
  803d20:	c3                   	retq   

0000000000803d21 <listen>:

int
listen(int s, int backlog)
{
  803d21:	55                   	push   %rbp
  803d22:	48 89 e5             	mov    %rsp,%rbp
  803d25:	48 83 ec 20          	sub    $0x20,%rsp
  803d29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d2c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d32:	89 c7                	mov    %eax,%edi
  803d34:	48 b8 99 3a 80 00 00 	movabs $0x803a99,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
  803d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d47:	79 05                	jns    803d4e <listen+0x2d>
		return r;
  803d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4c:	eb 16                	jmp    803d64 <listen+0x43>
	return nsipc_listen(r, backlog);
  803d4e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d54:	89 d6                	mov    %edx,%esi
  803d56:	89 c7                	mov    %eax,%edi
  803d58:	48 b8 90 40 80 00 00 	movabs $0x804090,%rax
  803d5f:	00 00 00 
  803d62:	ff d0                	callq  *%rax
}
  803d64:	c9                   	leaveq 
  803d65:	c3                   	retq   

0000000000803d66 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803d66:	55                   	push   %rbp
  803d67:	48 89 e5             	mov    %rsp,%rbp
  803d6a:	48 83 ec 20          	sub    $0x20,%rsp
  803d6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d76:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d7e:	89 c2                	mov    %eax,%edx
  803d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d84:	8b 40 0c             	mov    0xc(%rax),%eax
  803d87:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d90:	89 c7                	mov    %eax,%edi
  803d92:	48 b8 d0 40 80 00 00 	movabs $0x8040d0,%rax
  803d99:	00 00 00 
  803d9c:	ff d0                	callq  *%rax
}
  803d9e:	c9                   	leaveq 
  803d9f:	c3                   	retq   

0000000000803da0 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803da0:	55                   	push   %rbp
  803da1:	48 89 e5             	mov    %rsp,%rbp
  803da4:	48 83 ec 20          	sub    $0x20,%rsp
  803da8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803db0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db8:	89 c2                	mov    %eax,%edx
  803dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dbe:	8b 40 0c             	mov    0xc(%rax),%eax
  803dc1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803dc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  803dca:	89 c7                	mov    %eax,%edi
  803dcc:	48 b8 9c 41 80 00 00 	movabs $0x80419c,%rax
  803dd3:	00 00 00 
  803dd6:	ff d0                	callq  *%rax
}
  803dd8:	c9                   	leaveq 
  803dd9:	c3                   	retq   

0000000000803dda <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803dda:	55                   	push   %rbp
  803ddb:	48 89 e5             	mov    %rsp,%rbp
  803dde:	48 83 ec 10          	sub    $0x10,%rsp
  803de2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803de6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dee:	48 be 75 55 80 00 00 	movabs $0x805575,%rsi
  803df5:	00 00 00 
  803df8:	48 89 c7             	mov    %rax,%rdi
  803dfb:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  803e02:	00 00 00 
  803e05:	ff d0                	callq  *%rax
	return 0;
  803e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e0c:	c9                   	leaveq 
  803e0d:	c3                   	retq   

0000000000803e0e <socket>:

int
socket(int domain, int type, int protocol)
{
  803e0e:	55                   	push   %rbp
  803e0f:	48 89 e5             	mov    %rsp,%rbp
  803e12:	48 83 ec 20          	sub    $0x20,%rsp
  803e16:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e19:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e1c:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e1f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803e22:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e28:	89 ce                	mov    %ecx,%esi
  803e2a:	89 c7                	mov    %eax,%edi
  803e2c:	48 b8 54 42 80 00 00 	movabs $0x804254,%rax
  803e33:	00 00 00 
  803e36:	ff d0                	callq  *%rax
  803e38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e3f:	79 05                	jns    803e46 <socket+0x38>
		return r;
  803e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e44:	eb 11                	jmp    803e57 <socket+0x49>
	return alloc_sockfd(r);
  803e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e49:	89 c7                	mov    %eax,%edi
  803e4b:	48 b8 f0 3a 80 00 00 	movabs $0x803af0,%rax
  803e52:	00 00 00 
  803e55:	ff d0                	callq  *%rax
}
  803e57:	c9                   	leaveq 
  803e58:	c3                   	retq   

0000000000803e59 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e59:	55                   	push   %rbp
  803e5a:	48 89 e5             	mov    %rsp,%rbp
  803e5d:	48 83 ec 10          	sub    $0x10,%rsp
  803e61:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803e64:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803e6b:	00 00 00 
  803e6e:	8b 00                	mov    (%rax),%eax
  803e70:	85 c0                	test   %eax,%eax
  803e72:	75 1f                	jne    803e93 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803e74:	bf 02 00 00 00       	mov    $0x2,%edi
  803e79:	48 b8 6a 4c 80 00 00 	movabs $0x804c6a,%rax
  803e80:	00 00 00 
  803e83:	ff d0                	callq  *%rax
  803e85:	89 c2                	mov    %eax,%edx
  803e87:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803e8e:	00 00 00 
  803e91:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803e93:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803e9a:	00 00 00 
  803e9d:	8b 00                	mov    (%rax),%eax
  803e9f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ea2:	b9 07 00 00 00       	mov    $0x7,%ecx
  803ea7:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803eae:	00 00 00 
  803eb1:	89 c7                	mov    %eax,%edi
  803eb3:	48 b8 d5 4b 80 00 00 	movabs $0x804bd5,%rax
  803eba:	00 00 00 
  803ebd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  803ec4:	be 00 00 00 00       	mov    $0x0,%esi
  803ec9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ece:	48 b8 14 4b 80 00 00 	movabs $0x804b14,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
}
  803eda:	c9                   	leaveq 
  803edb:	c3                   	retq   

0000000000803edc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803edc:	55                   	push   %rbp
  803edd:	48 89 e5             	mov    %rsp,%rbp
  803ee0:	48 83 ec 30          	sub    $0x30,%rsp
  803ee4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ee7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803eeb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803eef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ef6:	00 00 00 
  803ef9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803efc:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803efe:	bf 01 00 00 00       	mov    $0x1,%edi
  803f03:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  803f0a:	00 00 00 
  803f0d:	ff d0                	callq  *%rax
  803f0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f16:	78 3e                	js     803f56 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803f18:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f1f:	00 00 00 
  803f22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f2a:	8b 40 10             	mov    0x10(%rax),%eax
  803f2d:	89 c2                	mov    %eax,%edx
  803f2f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803f33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f37:	48 89 ce             	mov    %rcx,%rsi
  803f3a:	48 89 c7             	mov    %rax,%rdi
  803f3d:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  803f44:	00 00 00 
  803f47:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f4d:	8b 50 10             	mov    0x10(%rax),%edx
  803f50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f54:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f59:	c9                   	leaveq 
  803f5a:	c3                   	retq   

0000000000803f5b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f5b:	55                   	push   %rbp
  803f5c:	48 89 e5             	mov    %rsp,%rbp
  803f5f:	48 83 ec 10          	sub    $0x10,%rsp
  803f63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f6a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803f6d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f74:	00 00 00 
  803f77:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f7a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f7c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f83:	48 89 c6             	mov    %rax,%rsi
  803f86:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803f8d:	00 00 00 
  803f90:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  803f97:	00 00 00 
  803f9a:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803f9c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa3:	00 00 00 
  803fa6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fa9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803fac:	bf 02 00 00 00       	mov    $0x2,%edi
  803fb1:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  803fb8:	00 00 00 
  803fbb:	ff d0                	callq  *%rax
}
  803fbd:	c9                   	leaveq 
  803fbe:	c3                   	retq   

0000000000803fbf <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803fbf:	55                   	push   %rbp
  803fc0:	48 89 e5             	mov    %rsp,%rbp
  803fc3:	48 83 ec 10          	sub    $0x10,%rsp
  803fc7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fca:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803fcd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fd4:	00 00 00 
  803fd7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fda:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803fdc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fe3:	00 00 00 
  803fe6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fe9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803fec:	bf 03 00 00 00       	mov    $0x3,%edi
  803ff1:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  803ff8:	00 00 00 
  803ffb:	ff d0                	callq  *%rax
}
  803ffd:	c9                   	leaveq 
  803ffe:	c3                   	retq   

0000000000803fff <nsipc_close>:

int
nsipc_close(int s)
{
  803fff:	55                   	push   %rbp
  804000:	48 89 e5             	mov    %rsp,%rbp
  804003:	48 83 ec 10          	sub    $0x10,%rsp
  804007:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80400a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804011:	00 00 00 
  804014:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804017:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804019:	bf 04 00 00 00       	mov    $0x4,%edi
  80401e:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  804025:	00 00 00 
  804028:	ff d0                	callq  *%rax
}
  80402a:	c9                   	leaveq 
  80402b:	c3                   	retq   

000000000080402c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80402c:	55                   	push   %rbp
  80402d:	48 89 e5             	mov    %rsp,%rbp
  804030:	48 83 ec 10          	sub    $0x10,%rsp
  804034:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804037:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80403b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80403e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804045:	00 00 00 
  804048:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80404b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80404d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804054:	48 89 c6             	mov    %rax,%rsi
  804057:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80405e:	00 00 00 
  804061:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  804068:	00 00 00 
  80406b:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80406d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804074:	00 00 00 
  804077:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80407a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80407d:	bf 05 00 00 00       	mov    $0x5,%edi
  804082:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
}
  80408e:	c9                   	leaveq 
  80408f:	c3                   	retq   

0000000000804090 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804090:	55                   	push   %rbp
  804091:	48 89 e5             	mov    %rsp,%rbp
  804094:	48 83 ec 10          	sub    $0x10,%rsp
  804098:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80409b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80409e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a5:	00 00 00 
  8040a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8040ad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040b4:	00 00 00 
  8040b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040ba:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8040bd:	bf 06 00 00 00       	mov    $0x6,%edi
  8040c2:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  8040c9:	00 00 00 
  8040cc:	ff d0                	callq  *%rax
}
  8040ce:	c9                   	leaveq 
  8040cf:	c3                   	retq   

00000000008040d0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8040d0:	55                   	push   %rbp
  8040d1:	48 89 e5             	mov    %rsp,%rbp
  8040d4:	48 83 ec 30          	sub    $0x30,%rsp
  8040d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040df:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8040e2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8040e5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040ec:	00 00 00 
  8040ef:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040f2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8040f4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040fb:	00 00 00 
  8040fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804101:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804104:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80410b:	00 00 00 
  80410e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804111:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804114:	bf 07 00 00 00       	mov    $0x7,%edi
  804119:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  804120:	00 00 00 
  804123:	ff d0                	callq  *%rax
  804125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80412c:	78 69                	js     804197 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80412e:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804135:	7f 08                	jg     80413f <nsipc_recv+0x6f>
  804137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413a:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80413d:	7e 35                	jle    804174 <nsipc_recv+0xa4>
  80413f:	48 b9 7c 55 80 00 00 	movabs $0x80557c,%rcx
  804146:	00 00 00 
  804149:	48 ba 91 55 80 00 00 	movabs $0x805591,%rdx
  804150:	00 00 00 
  804153:	be 62 00 00 00       	mov    $0x62,%esi
  804158:	48 bf a6 55 80 00 00 	movabs $0x8055a6,%rdi
  80415f:	00 00 00 
  804162:	b8 00 00 00 00       	mov    $0x0,%eax
  804167:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  80416e:	00 00 00 
  804171:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804177:	48 63 d0             	movslq %eax,%rdx
  80417a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80417e:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804185:	00 00 00 
  804188:	48 89 c7             	mov    %rax,%rdi
  80418b:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  804192:	00 00 00 
  804195:	ff d0                	callq  *%rax
	}

	return r;
  804197:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80419a:	c9                   	leaveq 
  80419b:	c3                   	retq   

000000000080419c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80419c:	55                   	push   %rbp
  80419d:	48 89 e5             	mov    %rsp,%rbp
  8041a0:	48 83 ec 20          	sub    $0x20,%rsp
  8041a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041ab:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8041ae:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8041b1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041b8:	00 00 00 
  8041bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041be:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8041c0:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8041c7:	7e 35                	jle    8041fe <nsipc_send+0x62>
  8041c9:	48 b9 b2 55 80 00 00 	movabs $0x8055b2,%rcx
  8041d0:	00 00 00 
  8041d3:	48 ba 91 55 80 00 00 	movabs $0x805591,%rdx
  8041da:	00 00 00 
  8041dd:	be 6d 00 00 00       	mov    $0x6d,%esi
  8041e2:	48 bf a6 55 80 00 00 	movabs $0x8055a6,%rdi
  8041e9:	00 00 00 
  8041ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f1:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  8041f8:	00 00 00 
  8041fb:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8041fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804201:	48 63 d0             	movslq %eax,%rdx
  804204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804208:	48 89 c6             	mov    %rax,%rsi
  80420b:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804212:	00 00 00 
  804215:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  80421c:	00 00 00 
  80421f:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804221:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804228:	00 00 00 
  80422b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80422e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804231:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804238:	00 00 00 
  80423b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80423e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804241:	bf 08 00 00 00       	mov    $0x8,%edi
  804246:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  80424d:	00 00 00 
  804250:	ff d0                	callq  *%rax
}
  804252:	c9                   	leaveq 
  804253:	c3                   	retq   

0000000000804254 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804254:	55                   	push   %rbp
  804255:	48 89 e5             	mov    %rsp,%rbp
  804258:	48 83 ec 10          	sub    $0x10,%rsp
  80425c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80425f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804262:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804265:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80426c:	00 00 00 
  80426f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804272:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804274:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80427b:	00 00 00 
  80427e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804281:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804284:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80428b:	00 00 00 
  80428e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804291:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804294:	bf 09 00 00 00       	mov    $0x9,%edi
  804299:	48 b8 59 3e 80 00 00 	movabs $0x803e59,%rax
  8042a0:	00 00 00 
  8042a3:	ff d0                	callq  *%rax
}
  8042a5:	c9                   	leaveq 
  8042a6:	c3                   	retq   

00000000008042a7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8042a7:	55                   	push   %rbp
  8042a8:	48 89 e5             	mov    %rsp,%rbp
  8042ab:	53                   	push   %rbx
  8042ac:	48 83 ec 38          	sub    $0x38,%rsp
  8042b0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8042b4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8042b8:	48 89 c7             	mov    %rax,%rdi
  8042bb:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  8042c2:	00 00 00 
  8042c5:	ff d0                	callq  *%rax
  8042c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042ce:	0f 88 bf 01 00 00    	js     804493 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d8:	ba 07 04 00 00       	mov    $0x407,%edx
  8042dd:	48 89 c6             	mov    %rax,%rsi
  8042e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e5:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8042ec:	00 00 00 
  8042ef:	ff d0                	callq  *%rax
  8042f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042f8:	0f 88 95 01 00 00    	js     804493 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8042fe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804302:	48 89 c7             	mov    %rax,%rdi
  804305:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  80430c:	00 00 00 
  80430f:	ff d0                	callq  *%rax
  804311:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804314:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804318:	0f 88 5d 01 00 00    	js     80447b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80431e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804322:	ba 07 04 00 00       	mov    $0x407,%edx
  804327:	48 89 c6             	mov    %rax,%rsi
  80432a:	bf 00 00 00 00       	mov    $0x0,%edi
  80432f:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  804336:	00 00 00 
  804339:	ff d0                	callq  *%rax
  80433b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80433e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804342:	0f 88 33 01 00 00    	js     80447b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80434c:	48 89 c7             	mov    %rax,%rdi
  80434f:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  804356:	00 00 00 
  804359:	ff d0                	callq  *%rax
  80435b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80435f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804363:	ba 07 04 00 00       	mov    $0x407,%edx
  804368:	48 89 c6             	mov    %rax,%rsi
  80436b:	bf 00 00 00 00       	mov    $0x0,%edi
  804370:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  804377:	00 00 00 
  80437a:	ff d0                	callq  *%rax
  80437c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80437f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804383:	0f 88 d9 00 00 00    	js     804462 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804389:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80438d:	48 89 c7             	mov    %rax,%rdi
  804390:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  804397:	00 00 00 
  80439a:	ff d0                	callq  *%rax
  80439c:	48 89 c2             	mov    %rax,%rdx
  80439f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a3:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8043a9:	48 89 d1             	mov    %rdx,%rcx
  8043ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8043b1:	48 89 c6             	mov    %rax,%rsi
  8043b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8043b9:	48 b8 54 1a 80 00 00 	movabs $0x801a54,%rax
  8043c0:	00 00 00 
  8043c3:	ff d0                	callq  *%rax
  8043c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043cc:	78 79                	js     804447 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8043ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d2:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043d9:	00 00 00 
  8043dc:	8b 12                	mov    (%rdx),%edx
  8043de:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8043e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8043eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ef:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043f6:	00 00 00 
  8043f9:	8b 12                	mov    (%rdx),%edx
  8043fb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8043fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804401:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440c:	48 89 c7             	mov    %rax,%rdi
  80440f:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  804416:	00 00 00 
  804419:	ff d0                	callq  *%rax
  80441b:	89 c2                	mov    %eax,%edx
  80441d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804421:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804423:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804427:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80442b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80442f:	48 89 c7             	mov    %rax,%rdi
  804432:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  804439:	00 00 00 
  80443c:	ff d0                	callq  *%rax
  80443e:	89 03                	mov    %eax,(%rbx)
	return 0;
  804440:	b8 00 00 00 00       	mov    $0x0,%eax
  804445:	eb 4f                	jmp    804496 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804447:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444c:	48 89 c6             	mov    %rax,%rsi
  80444f:	bf 00 00 00 00       	mov    $0x0,%edi
  804454:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80445b:	00 00 00 
  80445e:	ff d0                	callq  *%rax
  804460:	eb 01                	jmp    804463 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804462:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804463:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804467:	48 89 c6             	mov    %rax,%rsi
  80446a:	bf 00 00 00 00       	mov    $0x0,%edi
  80446f:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80447b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80447f:	48 89 c6             	mov    %rax,%rsi
  804482:	bf 00 00 00 00       	mov    $0x0,%edi
  804487:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80448e:	00 00 00 
  804491:	ff d0                	callq  *%rax
err:
	return r;
  804493:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804496:	48 83 c4 38          	add    $0x38,%rsp
  80449a:	5b                   	pop    %rbx
  80449b:	5d                   	pop    %rbp
  80449c:	c3                   	retq   

000000000080449d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80449d:	55                   	push   %rbp
  80449e:	48 89 e5             	mov    %rsp,%rbp
  8044a1:	53                   	push   %rbx
  8044a2:	48 83 ec 28          	sub    $0x28,%rsp
  8044a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8044ae:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8044b5:	00 00 00 
  8044b8:	48 8b 00             	mov    (%rax),%rax
  8044bb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8044c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c8:	48 89 c7             	mov    %rax,%rdi
  8044cb:	48 b8 db 4c 80 00 00 	movabs $0x804cdb,%rax
  8044d2:	00 00 00 
  8044d5:	ff d0                	callq  *%rax
  8044d7:	89 c3                	mov    %eax,%ebx
  8044d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044dd:	48 89 c7             	mov    %rax,%rdi
  8044e0:	48 b8 db 4c 80 00 00 	movabs $0x804cdb,%rax
  8044e7:	00 00 00 
  8044ea:	ff d0                	callq  *%rax
  8044ec:	39 c3                	cmp    %eax,%ebx
  8044ee:	0f 94 c0             	sete   %al
  8044f1:	0f b6 c0             	movzbl %al,%eax
  8044f4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8044f7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8044fe:	00 00 00 
  804501:	48 8b 00             	mov    (%rax),%rax
  804504:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80450a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80450d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804510:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804513:	75 05                	jne    80451a <_pipeisclosed+0x7d>
			return ret;
  804515:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804518:	eb 4a                	jmp    804564 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80451a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80451d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804520:	74 8c                	je     8044ae <_pipeisclosed+0x11>
  804522:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804526:	75 86                	jne    8044ae <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804528:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80452f:	00 00 00 
  804532:	48 8b 00             	mov    (%rax),%rax
  804535:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80453b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80453e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804541:	89 c6                	mov    %eax,%esi
  804543:	48 bf c3 55 80 00 00 	movabs $0x8055c3,%rdi
  80454a:	00 00 00 
  80454d:	b8 00 00 00 00       	mov    $0x0,%eax
  804552:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  804559:	00 00 00 
  80455c:	41 ff d0             	callq  *%r8
	}
  80455f:	e9 4a ff ff ff       	jmpq   8044ae <_pipeisclosed+0x11>

}
  804564:	48 83 c4 28          	add    $0x28,%rsp
  804568:	5b                   	pop    %rbx
  804569:	5d                   	pop    %rbp
  80456a:	c3                   	retq   

000000000080456b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80456b:	55                   	push   %rbp
  80456c:	48 89 e5             	mov    %rsp,%rbp
  80456f:	48 83 ec 30          	sub    $0x30,%rsp
  804573:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804576:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80457a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80457d:	48 89 d6             	mov    %rdx,%rsi
  804580:	89 c7                	mov    %eax,%edi
  804582:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  804589:	00 00 00 
  80458c:	ff d0                	callq  *%rax
  80458e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804595:	79 05                	jns    80459c <pipeisclosed+0x31>
		return r;
  804597:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80459a:	eb 31                	jmp    8045cd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80459c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045a0:	48 89 c7             	mov    %rax,%rdi
  8045a3:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  8045aa:	00 00 00 
  8045ad:	ff d0                	callq  *%rax
  8045af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8045b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045bb:	48 89 d6             	mov    %rdx,%rsi
  8045be:	48 89 c7             	mov    %rax,%rdi
  8045c1:	48 b8 9d 44 80 00 00 	movabs $0x80449d,%rax
  8045c8:	00 00 00 
  8045cb:	ff d0                	callq  *%rax
}
  8045cd:	c9                   	leaveq 
  8045ce:	c3                   	retq   

00000000008045cf <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045cf:	55                   	push   %rbp
  8045d0:	48 89 e5             	mov    %rsp,%rbp
  8045d3:	48 83 ec 40          	sub    $0x40,%rsp
  8045d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045df:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8045e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045e7:	48 89 c7             	mov    %rax,%rdi
  8045ea:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  8045f1:	00 00 00 
  8045f4:	ff d0                	callq  *%rax
  8045f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804602:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804609:	00 
  80460a:	e9 90 00 00 00       	jmpq   80469f <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80460f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804614:	74 09                	je     80461f <devpipe_read+0x50>
				return i;
  804616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80461a:	e9 8e 00 00 00       	jmpq   8046ad <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80461f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804627:	48 89 d6             	mov    %rdx,%rsi
  80462a:	48 89 c7             	mov    %rax,%rdi
  80462d:	48 b8 9d 44 80 00 00 	movabs $0x80449d,%rax
  804634:	00 00 00 
  804637:	ff d0                	callq  *%rax
  804639:	85 c0                	test   %eax,%eax
  80463b:	74 07                	je     804644 <devpipe_read+0x75>
				return 0;
  80463d:	b8 00 00 00 00       	mov    $0x0,%eax
  804642:	eb 69                	jmp    8046ad <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804644:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  80464b:	00 00 00 
  80464e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804654:	8b 10                	mov    (%rax),%edx
  804656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80465a:	8b 40 04             	mov    0x4(%rax),%eax
  80465d:	39 c2                	cmp    %eax,%edx
  80465f:	74 ae                	je     80460f <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804669:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80466d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804671:	8b 00                	mov    (%rax),%eax
  804673:	99                   	cltd   
  804674:	c1 ea 1b             	shr    $0x1b,%edx
  804677:	01 d0                	add    %edx,%eax
  804679:	83 e0 1f             	and    $0x1f,%eax
  80467c:	29 d0                	sub    %edx,%eax
  80467e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804682:	48 98                	cltq   
  804684:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804689:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80468b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468f:	8b 00                	mov    (%rax),%eax
  804691:	8d 50 01             	lea    0x1(%rax),%edx
  804694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804698:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80469a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80469f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046a7:	72 a7                	jb     804650 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8046a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8046ad:	c9                   	leaveq 
  8046ae:	c3                   	retq   

00000000008046af <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046af:	55                   	push   %rbp
  8046b0:	48 89 e5             	mov    %rsp,%rbp
  8046b3:	48 83 ec 40          	sub    $0x40,%rsp
  8046b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046bf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8046c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046c7:	48 89 c7             	mov    %rax,%rdi
  8046ca:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  8046d1:	00 00 00 
  8046d4:	ff d0                	callq  *%rax
  8046d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8046da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046e2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046e9:	00 
  8046ea:	e9 8f 00 00 00       	jmpq   80477e <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8046ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f7:	48 89 d6             	mov    %rdx,%rsi
  8046fa:	48 89 c7             	mov    %rax,%rdi
  8046fd:	48 b8 9d 44 80 00 00 	movabs $0x80449d,%rax
  804704:	00 00 00 
  804707:	ff d0                	callq  *%rax
  804709:	85 c0                	test   %eax,%eax
  80470b:	74 07                	je     804714 <devpipe_write+0x65>
				return 0;
  80470d:	b8 00 00 00 00       	mov    $0x0,%eax
  804712:	eb 78                	jmp    80478c <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804714:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  80471b:	00 00 00 
  80471e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804724:	8b 40 04             	mov    0x4(%rax),%eax
  804727:	48 63 d0             	movslq %eax,%rdx
  80472a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472e:	8b 00                	mov    (%rax),%eax
  804730:	48 98                	cltq   
  804732:	48 83 c0 20          	add    $0x20,%rax
  804736:	48 39 c2             	cmp    %rax,%rdx
  804739:	73 b4                	jae    8046ef <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80473b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80473f:	8b 40 04             	mov    0x4(%rax),%eax
  804742:	99                   	cltd   
  804743:	c1 ea 1b             	shr    $0x1b,%edx
  804746:	01 d0                	add    %edx,%eax
  804748:	83 e0 1f             	and    $0x1f,%eax
  80474b:	29 d0                	sub    %edx,%eax
  80474d:	89 c6                	mov    %eax,%esi
  80474f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804753:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804757:	48 01 d0             	add    %rdx,%rax
  80475a:	0f b6 08             	movzbl (%rax),%ecx
  80475d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804761:	48 63 c6             	movslq %esi,%rax
  804764:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80476c:	8b 40 04             	mov    0x4(%rax),%eax
  80476f:	8d 50 01             	lea    0x1(%rax),%edx
  804772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804776:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804779:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80477e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804782:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804786:	72 98                	jb     804720 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80478c:	c9                   	leaveq 
  80478d:	c3                   	retq   

000000000080478e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80478e:	55                   	push   %rbp
  80478f:	48 89 e5             	mov    %rsp,%rbp
  804792:	48 83 ec 20          	sub    $0x20,%rsp
  804796:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80479a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80479e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a2:	48 89 c7             	mov    %rax,%rdi
  8047a5:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  8047ac:	00 00 00 
  8047af:	ff d0                	callq  *%rax
  8047b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047b9:	48 be d6 55 80 00 00 	movabs $0x8055d6,%rsi
  8047c0:	00 00 00 
  8047c3:	48 89 c7             	mov    %rax,%rdi
  8047c6:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  8047cd:	00 00 00 
  8047d0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8047d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047d6:	8b 50 04             	mov    0x4(%rax),%edx
  8047d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047dd:	8b 00                	mov    (%rax),%eax
  8047df:	29 c2                	sub    %eax,%edx
  8047e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8047eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047ef:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8047f6:	00 00 00 
	stat->st_dev = &devpipe;
  8047f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047fd:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804804:	00 00 00 
  804807:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80480e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804813:	c9                   	leaveq 
  804814:	c3                   	retq   

0000000000804815 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804815:	55                   	push   %rbp
  804816:	48 89 e5             	mov    %rsp,%rbp
  804819:	48 83 ec 10          	sub    $0x10,%rsp
  80481d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804821:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804825:	48 89 c6             	mov    %rax,%rsi
  804828:	bf 00 00 00 00       	mov    $0x0,%edi
  80482d:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  804834:	00 00 00 
  804837:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80483d:	48 89 c7             	mov    %rax,%rdi
  804840:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  804847:	00 00 00 
  80484a:	ff d0                	callq  *%rax
  80484c:	48 89 c6             	mov    %rax,%rsi
  80484f:	bf 00 00 00 00       	mov    $0x0,%edi
  804854:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  80485b:	00 00 00 
  80485e:	ff d0                	callq  *%rax
}
  804860:	c9                   	leaveq 
  804861:	c3                   	retq   

0000000000804862 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804862:	55                   	push   %rbp
  804863:	48 89 e5             	mov    %rsp,%rbp
  804866:	48 83 ec 20          	sub    $0x20,%rsp
  80486a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80486d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804870:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804873:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804877:	be 01 00 00 00       	mov    $0x1,%esi
  80487c:	48 89 c7             	mov    %rax,%rdi
  80487f:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  804886:	00 00 00 
  804889:	ff d0                	callq  *%rax
}
  80488b:	90                   	nop
  80488c:	c9                   	leaveq 
  80488d:	c3                   	retq   

000000000080488e <getchar>:

int
getchar(void)
{
  80488e:	55                   	push   %rbp
  80488f:	48 89 e5             	mov    %rsp,%rbp
  804892:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804896:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80489a:	ba 01 00 00 00       	mov    $0x1,%edx
  80489f:	48 89 c6             	mov    %rax,%rsi
  8048a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8048a7:	48 b8 15 24 80 00 00 	movabs $0x802415,%rax
  8048ae:	00 00 00 
  8048b1:	ff d0                	callq  *%rax
  8048b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8048b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ba:	79 05                	jns    8048c1 <getchar+0x33>
		return r;
  8048bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048bf:	eb 14                	jmp    8048d5 <getchar+0x47>
	if (r < 1)
  8048c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048c5:	7f 07                	jg     8048ce <getchar+0x40>
		return -E_EOF;
  8048c7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8048cc:	eb 07                	jmp    8048d5 <getchar+0x47>
	return c;
  8048ce:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8048d2:	0f b6 c0             	movzbl %al,%eax

}
  8048d5:	c9                   	leaveq 
  8048d6:	c3                   	retq   

00000000008048d7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8048d7:	55                   	push   %rbp
  8048d8:	48 89 e5             	mov    %rsp,%rbp
  8048db:	48 83 ec 20          	sub    $0x20,%rsp
  8048df:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8048e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8048e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048e9:	48 89 d6             	mov    %rdx,%rsi
  8048ec:	89 c7                	mov    %eax,%edi
  8048ee:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  8048f5:	00 00 00 
  8048f8:	ff d0                	callq  *%rax
  8048fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804901:	79 05                	jns    804908 <iscons+0x31>
		return r;
  804903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804906:	eb 1a                	jmp    804922 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804908:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80490c:	8b 10                	mov    (%rax),%edx
  80490e:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804915:	00 00 00 
  804918:	8b 00                	mov    (%rax),%eax
  80491a:	39 c2                	cmp    %eax,%edx
  80491c:	0f 94 c0             	sete   %al
  80491f:	0f b6 c0             	movzbl %al,%eax
}
  804922:	c9                   	leaveq 
  804923:	c3                   	retq   

0000000000804924 <opencons>:

int
opencons(void)
{
  804924:	55                   	push   %rbp
  804925:	48 89 e5             	mov    %rsp,%rbp
  804928:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80492c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804930:	48 89 c7             	mov    %rax,%rdi
  804933:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  80493a:	00 00 00 
  80493d:	ff d0                	callq  *%rax
  80493f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804942:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804946:	79 05                	jns    80494d <opencons+0x29>
		return r;
  804948:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80494b:	eb 5b                	jmp    8049a8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80494d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804951:	ba 07 04 00 00       	mov    $0x407,%edx
  804956:	48 89 c6             	mov    %rax,%rsi
  804959:	bf 00 00 00 00       	mov    $0x0,%edi
  80495e:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  804965:	00 00 00 
  804968:	ff d0                	callq  *%rax
  80496a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80496d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804971:	79 05                	jns    804978 <opencons+0x54>
		return r;
  804973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804976:	eb 30                	jmp    8049a8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80497c:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804983:	00 00 00 
  804986:	8b 12                	mov    (%rdx),%edx
  804988:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80498a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80498e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804995:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804999:	48 89 c7             	mov    %rax,%rdi
  80499c:	48 b8 fa 1e 80 00 00 	movabs $0x801efa,%rax
  8049a3:	00 00 00 
  8049a6:	ff d0                	callq  *%rax
}
  8049a8:	c9                   	leaveq 
  8049a9:	c3                   	retq   

00000000008049aa <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8049aa:	55                   	push   %rbp
  8049ab:	48 89 e5             	mov    %rsp,%rbp
  8049ae:	48 83 ec 30          	sub    $0x30,%rsp
  8049b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8049be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049c3:	75 13                	jne    8049d8 <devcons_read+0x2e>
		return 0;
  8049c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ca:	eb 49                	jmp    804a15 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8049cc:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  8049d3:	00 00 00 
  8049d6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8049d8:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  8049df:	00 00 00 
  8049e2:	ff d0                	callq  *%rax
  8049e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049eb:	74 df                	je     8049cc <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8049ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049f1:	79 05                	jns    8049f8 <devcons_read+0x4e>
		return c;
  8049f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049f6:	eb 1d                	jmp    804a15 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8049f8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8049fc:	75 07                	jne    804a05 <devcons_read+0x5b>
		return 0;
  8049fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804a03:	eb 10                	jmp    804a15 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a08:	89 c2                	mov    %eax,%edx
  804a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a0e:	88 10                	mov    %dl,(%rax)
	return 1;
  804a10:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804a15:	c9                   	leaveq 
  804a16:	c3                   	retq   

0000000000804a17 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a17:	55                   	push   %rbp
  804a18:	48 89 e5             	mov    %rsp,%rbp
  804a1b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804a22:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804a29:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804a30:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804a37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a3e:	eb 76                	jmp    804ab6 <devcons_write+0x9f>
		m = n - tot;
  804a40:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804a47:	89 c2                	mov    %eax,%edx
  804a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a4c:	29 c2                	sub    %eax,%edx
  804a4e:	89 d0                	mov    %edx,%eax
  804a50:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804a53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a56:	83 f8 7f             	cmp    $0x7f,%eax
  804a59:	76 07                	jbe    804a62 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804a5b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804a62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a65:	48 63 d0             	movslq %eax,%rdx
  804a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a6b:	48 63 c8             	movslq %eax,%rcx
  804a6e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804a75:	48 01 c1             	add    %rax,%rcx
  804a78:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804a7f:	48 89 ce             	mov    %rcx,%rsi
  804a82:	48 89 c7             	mov    %rax,%rdi
  804a85:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  804a8c:	00 00 00 
  804a8f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804a91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a94:	48 63 d0             	movslq %eax,%rdx
  804a97:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804a9e:	48 89 d6             	mov    %rdx,%rsi
  804aa1:	48 89 c7             	mov    %rax,%rdi
  804aa4:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  804aab:	00 00 00 
  804aae:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804ab0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ab3:	01 45 fc             	add    %eax,-0x4(%rbp)
  804ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ab9:	48 98                	cltq   
  804abb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804ac2:	0f 82 78 ff ff ff    	jb     804a40 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804acb:	c9                   	leaveq 
  804acc:	c3                   	retq   

0000000000804acd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804acd:	55                   	push   %rbp
  804ace:	48 89 e5             	mov    %rsp,%rbp
  804ad1:	48 83 ec 08          	sub    $0x8,%rsp
  804ad5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ade:	c9                   	leaveq 
  804adf:	c3                   	retq   

0000000000804ae0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804ae0:	55                   	push   %rbp
  804ae1:	48 89 e5             	mov    %rsp,%rbp
  804ae4:	48 83 ec 10          	sub    $0x10,%rsp
  804ae8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804aec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804af4:	48 be e2 55 80 00 00 	movabs $0x8055e2,%rsi
  804afb:	00 00 00 
  804afe:	48 89 c7             	mov    %rax,%rdi
  804b01:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  804b08:	00 00 00 
  804b0b:	ff d0                	callq  *%rax
	return 0;
  804b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b12:	c9                   	leaveq 
  804b13:	c3                   	retq   

0000000000804b14 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804b14:	55                   	push   %rbp
  804b15:	48 89 e5             	mov    %rsp,%rbp
  804b18:	48 83 ec 30          	sub    $0x30,%rsp
  804b1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804b20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b24:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804b28:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b2d:	75 0e                	jne    804b3d <ipc_recv+0x29>
		pg = (void*) UTOP;
  804b2f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b36:	00 00 00 
  804b39:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804b3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b41:	48 89 c7             	mov    %rax,%rdi
  804b44:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  804b4b:	00 00 00 
  804b4e:	ff d0                	callq  *%rax
  804b50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b57:	79 27                	jns    804b80 <ipc_recv+0x6c>
		if (from_env_store)
  804b59:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804b5e:	74 0a                	je     804b6a <ipc_recv+0x56>
			*from_env_store = 0;
  804b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b64:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804b6a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b6f:	74 0a                	je     804b7b <ipc_recv+0x67>
			*perm_store = 0;
  804b71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b75:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b7e:	eb 53                	jmp    804bd3 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804b80:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804b85:	74 19                	je     804ba0 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804b87:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b8e:	00 00 00 
  804b91:	48 8b 00             	mov    (%rax),%rax
  804b94:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b9e:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804ba0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ba5:	74 19                	je     804bc0 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804ba7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804bae:	00 00 00 
  804bb1:	48 8b 00             	mov    (%rax),%rax
  804bb4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804bba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bbe:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804bc0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804bc7:	00 00 00 
  804bca:	48 8b 00             	mov    (%rax),%rax
  804bcd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804bd3:	c9                   	leaveq 
  804bd4:	c3                   	retq   

0000000000804bd5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804bd5:	55                   	push   %rbp
  804bd6:	48 89 e5             	mov    %rsp,%rbp
  804bd9:	48 83 ec 30          	sub    $0x30,%rsp
  804bdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804be0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804be3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804be7:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804bea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804bef:	75 1c                	jne    804c0d <ipc_send+0x38>
		pg = (void*) UTOP;
  804bf1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804bf8:	00 00 00 
  804bfb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804bff:	eb 0c                	jmp    804c0d <ipc_send+0x38>
		sys_yield();
  804c01:	48 b8 c5 19 80 00 00 	movabs $0x8019c5,%rax
  804c08:	00 00 00 
  804c0b:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804c0d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804c10:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804c13:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804c17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c1a:	89 c7                	mov    %eax,%edi
  804c1c:	48 b8 e5 1b 80 00 00 	movabs $0x801be5,%rax
  804c23:	00 00 00 
  804c26:	ff d0                	callq  *%rax
  804c28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c2b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804c2f:	74 d0                	je     804c01 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804c31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c35:	79 30                	jns    804c67 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c3a:	89 c1                	mov    %eax,%ecx
  804c3c:	48 ba e9 55 80 00 00 	movabs $0x8055e9,%rdx
  804c43:	00 00 00 
  804c46:	be 47 00 00 00       	mov    $0x47,%esi
  804c4b:	48 bf ff 55 80 00 00 	movabs $0x8055ff,%rdi
  804c52:	00 00 00 
  804c55:	b8 00 00 00 00       	mov    $0x0,%eax
  804c5a:	49 b8 02 03 80 00 00 	movabs $0x800302,%r8
  804c61:	00 00 00 
  804c64:	41 ff d0             	callq  *%r8

}
  804c67:	90                   	nop
  804c68:	c9                   	leaveq 
  804c69:	c3                   	retq   

0000000000804c6a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804c6a:	55                   	push   %rbp
  804c6b:	48 89 e5             	mov    %rsp,%rbp
  804c6e:	48 83 ec 18          	sub    $0x18,%rsp
  804c72:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c7c:	eb 4d                	jmp    804ccb <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804c7e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c85:	00 00 00 
  804c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c8b:	48 98                	cltq   
  804c8d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804c94:	48 01 d0             	add    %rdx,%rax
  804c97:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804c9d:	8b 00                	mov    (%rax),%eax
  804c9f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ca2:	75 23                	jne    804cc7 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804ca4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804cab:	00 00 00 
  804cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cb1:	48 98                	cltq   
  804cb3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804cba:	48 01 d0             	add    %rdx,%rax
  804cbd:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804cc3:	8b 00                	mov    (%rax),%eax
  804cc5:	eb 12                	jmp    804cd9 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804cc7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ccb:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804cd2:	7e aa                	jle    804c7e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804cd9:	c9                   	leaveq 
  804cda:	c3                   	retq   

0000000000804cdb <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804cdb:	55                   	push   %rbp
  804cdc:	48 89 e5             	mov    %rsp,%rbp
  804cdf:	48 83 ec 18          	sub    $0x18,%rsp
  804ce3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ceb:	48 c1 e8 15          	shr    $0x15,%rax
  804cef:	48 89 c2             	mov    %rax,%rdx
  804cf2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804cf9:	01 00 00 
  804cfc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d00:	83 e0 01             	and    $0x1,%eax
  804d03:	48 85 c0             	test   %rax,%rax
  804d06:	75 07                	jne    804d0f <pageref+0x34>
		return 0;
  804d08:	b8 00 00 00 00       	mov    $0x0,%eax
  804d0d:	eb 56                	jmp    804d65 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d13:	48 c1 e8 0c          	shr    $0xc,%rax
  804d17:	48 89 c2             	mov    %rax,%rdx
  804d1a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d21:	01 00 00 
  804d24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d28:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d30:	83 e0 01             	and    $0x1,%eax
  804d33:	48 85 c0             	test   %rax,%rax
  804d36:	75 07                	jne    804d3f <pageref+0x64>
		return 0;
  804d38:	b8 00 00 00 00       	mov    $0x0,%eax
  804d3d:	eb 26                	jmp    804d65 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d43:	48 c1 e8 0c          	shr    $0xc,%rax
  804d47:	48 89 c2             	mov    %rax,%rdx
  804d4a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804d51:	00 00 00 
  804d54:	48 c1 e2 04          	shl    $0x4,%rdx
  804d58:	48 01 d0             	add    %rdx,%rax
  804d5b:	48 83 c0 08          	add    $0x8,%rax
  804d5f:	0f b7 00             	movzwl (%rax),%eax
  804d62:	0f b7 c0             	movzwl %ax,%eax
}
  804d65:	c9                   	leaveq 
  804d66:	c3                   	retq   
