
obj/user/writemotd:     file format elf64-x86-64


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
  80003c:	e8 37 03 00 00       	callq  800378 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 20 43 80 00 00 	movabs $0x804320,%rdi
  800067:	00 00 00 
  80006a:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 29 43 80 00 00 	movabs $0x804329,%rdx
  80008b:	00 00 00 
  80008e:	be 0c 00 00 00       	mov    $0xc,%esi
  800093:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf 4c 43 80 00 00 	movabs $0x80434c,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 52 43 80 00 00 	movabs $0x804352,%rdx
  8000df:	00 00 00 
  8000e2:	be 0e 00 00 00       	mov    $0xe,%esi
  8000e7:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf 61 43 80 00 00 	movabs $0x804361,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba 80 43 80 00 00 	movabs $0x804380,%rdx
  800135:	00 00 00 
  800138:	be 11 00 00 00       	mov    $0x11,%esi
  80013d:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 20 04 80 00 00 	movabs $0x800420,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf b2 43 80 00 00 	movabs $0x8043b2,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf c0 43 80 00 00 	movabs $0x8043c0,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 97 27 80 00 00 	movabs $0x802797,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba c5 43 80 00 00 	movabs $0x8043c5,%rdx
  800219:	00 00 00 
  80021c:	be 1a 00 00 00       	mov    $0x1a,%esi
  800221:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf d8 43 80 00 00 	movabs $0x8043d8,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba e6 43 80 00 00 	movabs $0x8043e6,%rdx
  8002b1:	00 00 00 
  8002b4:	be 20 00 00 00       	mov    $0x20,%esi
  8002b9:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf c0 43 80 00 00 	movabs $0x8043c0,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba f6 43 80 00 00 	movabs $0x8043f6,%rdx
  80032f:	00 00 00 
  800332:	be 25 00 00 00       	mov    $0x25,%esi
  800337:	48 bf 3b 43 80 00 00 	movabs $0x80433b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	90                   	nop
  800376:	c9                   	leaveq 
  800377:	c3                   	retq   

0000000000800378 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	48 83 ec 10          	sub    $0x10,%rsp
  800380:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800383:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800387:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  80038e:	00 00 00 
  800391:	ff d0                	callq  *%rax
  800393:	25 ff 03 00 00       	and    $0x3ff,%eax
  800398:	48 98                	cltq   
  80039a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8003a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003a8:	00 00 00 
  8003ab:	48 01 c2             	add    %rax,%rdx
  8003ae:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003b5:	00 00 00 
  8003b8:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003bf:	7e 14                	jle    8003d5 <libmain+0x5d>
		binaryname = argv[0];
  8003c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c5:	48 8b 10             	mov    (%rax),%rdx
  8003c8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003cf:	00 00 00 
  8003d2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003dc:	48 89 d6             	mov    %rdx,%rsi
  8003df:	89 c7                	mov    %eax,%edi
  8003e1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003e8:	00 00 00 
  8003eb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003ed:	48 b8 fc 03 80 00 00 	movabs $0x8003fc,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leaveq 
  8003fb:	c3                   	retq   

00000000008003fc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003fc:	55                   	push   %rbp
  8003fd:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800400:	48 b8 5b 23 80 00 00 	movabs $0x80235b,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80040c:	bf 00 00 00 00       	mov    $0x0,%edi
  800411:	48 b8 61 1a 80 00 00 	movabs $0x801a61,%rax
  800418:	00 00 00 
  80041b:	ff d0                	callq  *%rax
}
  80041d:	90                   	nop
  80041e:	5d                   	pop    %rbp
  80041f:	c3                   	retq   

0000000000800420 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	53                   	push   %rbx
  800425:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80042c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800433:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800439:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800440:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800447:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80044e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800455:	84 c0                	test   %al,%al
  800457:	74 23                	je     80047c <_panic+0x5c>
  800459:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800460:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800464:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800468:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80046c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800470:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800474:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800478:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80047c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800483:	00 00 00 
  800486:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80048d:	00 00 00 
  800490:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800494:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80049b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004a2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004a9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004b0:	00 00 00 
  8004b3:	48 8b 18             	mov    (%rax),%rbx
  8004b6:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	89 c6                	mov    %eax,%esi
  8004c4:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8004ca:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004d1:	41 89 d0             	mov    %edx,%r8d
  8004d4:	48 89 c1             	mov    %rax,%rcx
  8004d7:	48 89 da             	mov    %rbx,%rdx
  8004da:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  8004e1:	00 00 00 
  8004e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e9:	49 b9 5a 06 80 00 00 	movabs $0x80065a,%r9
  8004f0:	00 00 00 
  8004f3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004f6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004fd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800504:	48 89 d6             	mov    %rdx,%rsi
  800507:	48 89 c7             	mov    %rax,%rdi
  80050a:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  800511:	00 00 00 
  800514:	ff d0                	callq  *%rax
	cprintf("\n");
  800516:	48 bf 3b 44 80 00 00 	movabs $0x80443b,%rdi
  80051d:	00 00 00 
  800520:	b8 00 00 00 00       	mov    $0x0,%eax
  800525:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  80052c:	00 00 00 
  80052f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800531:	cc                   	int3   
  800532:	eb fd                	jmp    800531 <_panic+0x111>

0000000000800534 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800534:	55                   	push   %rbp
  800535:	48 89 e5             	mov    %rsp,%rbp
  800538:	48 83 ec 10          	sub    $0x10,%rsp
  80053c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80053f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800547:	8b 00                	mov    (%rax),%eax
  800549:	8d 48 01             	lea    0x1(%rax),%ecx
  80054c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800550:	89 0a                	mov    %ecx,(%rdx)
  800552:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800555:	89 d1                	mov    %edx,%ecx
  800557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055b:	48 98                	cltq   
  80055d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800565:	8b 00                	mov    (%rax),%eax
  800567:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056c:	75 2c                	jne    80059a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80056e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	48 98                	cltq   
  800576:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057a:	48 83 c2 08          	add    $0x8,%rdx
  80057e:	48 89 c6             	mov    %rax,%rsi
  800581:	48 89 d7             	mov    %rdx,%rdi
  800584:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  80058b:	00 00 00 
  80058e:	ff d0                	callq  *%rax
        b->idx = 0;
  800590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800594:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80059a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059e:	8b 40 04             	mov    0x4(%rax),%eax
  8005a1:	8d 50 01             	lea    0x1(%rax),%edx
  8005a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005ab:	90                   	nop
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005b9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005c0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005c7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ce:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005d5:	48 8b 0a             	mov    (%rdx),%rcx
  8005d8:	48 89 08             	mov    %rcx,(%rax)
  8005db:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005df:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005e3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005f2:	00 00 00 
    b.cnt = 0;
  8005f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005fc:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005ff:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800606:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80060d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800614:	48 89 c6             	mov    %rax,%rsi
  800617:	48 bf 34 05 80 00 00 	movabs $0x800534,%rdi
  80061e:	00 00 00 
  800621:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  800628:	00 00 00 
  80062b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80062d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800633:	48 98                	cltq   
  800635:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80063c:	48 83 c2 08          	add    $0x8,%rdx
  800640:	48 89 c6             	mov    %rax,%rsi
  800643:	48 89 d7             	mov    %rdx,%rdi
  800646:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  80064d:	00 00 00 
  800650:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800652:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800658:	c9                   	leaveq 
  800659:	c3                   	retq   

000000000080065a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80065a:	55                   	push   %rbp
  80065b:	48 89 e5             	mov    %rsp,%rbp
  80065e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800665:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80066c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800673:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800681:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800688:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80068f:	84 c0                	test   %al,%al
  800691:	74 20                	je     8006b3 <cprintf+0x59>
  800693:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800697:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80069f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006a7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006af:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006b3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006ba:	00 00 00 
  8006bd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006c4:	00 00 00 
  8006c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006cb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006d2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006d9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006e0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006e7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ee:	48 8b 0a             	mov    (%rdx),%rcx
  8006f1:	48 89 08             	mov    %rcx,(%rax)
  8006f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800700:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800704:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80070b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800712:	48 89 d6             	mov    %rdx,%rsi
  800715:	48 89 c7             	mov    %rax,%rdi
  800718:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  80071f:	00 00 00 
  800722:	ff d0                	callq  *%rax
  800724:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80072a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800730:	c9                   	leaveq 
  800731:	c3                   	retq   

0000000000800732 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800732:	55                   	push   %rbp
  800733:	48 89 e5             	mov    %rsp,%rbp
  800736:	48 83 ec 30          	sub    $0x30,%rsp
  80073a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80073e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800742:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800746:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800749:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80074d:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800751:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800754:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800758:	77 54                	ja     8007ae <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075a:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80075d:	8d 78 ff             	lea    -0x1(%rax),%edi
  800760:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
  80076c:	48 f7 f6             	div    %rsi
  80076f:	49 89 c2             	mov    %rax,%r10
  800772:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800775:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800778:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80077c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800780:	41 89 c9             	mov    %ecx,%r9d
  800783:	41 89 f8             	mov    %edi,%r8d
  800786:	89 d1                	mov    %edx,%ecx
  800788:	4c 89 d2             	mov    %r10,%rdx
  80078b:	48 89 c7             	mov    %rax,%rdi
  80078e:	48 b8 32 07 80 00 00 	movabs $0x800732,%rax
  800795:	00 00 00 
  800798:	ff d0                	callq  *%rax
  80079a:	eb 1c                	jmp    8007b8 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80079c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8007a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a7:	48 89 ce             	mov    %rcx,%rsi
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ae:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8007b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8007b6:	7f e4                	jg     80079c <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	48 f7 f1             	div    %rcx
  8007c7:	48 b8 30 46 80 00 00 	movabs $0x804630,%rax
  8007ce:	00 00 00 
  8007d1:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8007d5:	0f be d0             	movsbl %al,%edx
  8007d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007e0:	48 89 ce             	mov    %rcx,%rsi
  8007e3:	89 d7                	mov    %edx,%edi
  8007e5:	ff d0                	callq  *%rax
}
  8007e7:	90                   	nop
  8007e8:	c9                   	leaveq 
  8007e9:	c3                   	retq   

00000000008007ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ea:	55                   	push   %rbp
  8007eb:	48 89 e5             	mov    %rsp,%rbp
  8007ee:	48 83 ec 20          	sub    $0x20,%rsp
  8007f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007f9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007fd:	7e 4f                	jle    80084e <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	8b 00                	mov    (%rax),%eax
  800805:	83 f8 30             	cmp    $0x30,%eax
  800808:	73 24                	jae    80082e <getuint+0x44>
  80080a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800816:	8b 00                	mov    (%rax),%eax
  800818:	89 c0                	mov    %eax,%eax
  80081a:	48 01 d0             	add    %rdx,%rax
  80081d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800821:	8b 12                	mov    (%rdx),%edx
  800823:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082a:	89 0a                	mov    %ecx,(%rdx)
  80082c:	eb 14                	jmp    800842 <getuint+0x58>
  80082e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800832:	48 8b 40 08          	mov    0x8(%rax),%rax
  800836:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800842:	48 8b 00             	mov    (%rax),%rax
  800845:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800849:	e9 9d 00 00 00       	jmpq   8008eb <getuint+0x101>
	else if (lflag)
  80084e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800852:	74 4c                	je     8008a0 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800858:	8b 00                	mov    (%rax),%eax
  80085a:	83 f8 30             	cmp    $0x30,%eax
  80085d:	73 24                	jae    800883 <getuint+0x99>
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	8b 00                	mov    (%rax),%eax
  80086d:	89 c0                	mov    %eax,%eax
  80086f:	48 01 d0             	add    %rdx,%rax
  800872:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800876:	8b 12                	mov    (%rdx),%edx
  800878:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80087b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087f:	89 0a                	mov    %ecx,(%rdx)
  800881:	eb 14                	jmp    800897 <getuint+0xad>
  800883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800887:	48 8b 40 08          	mov    0x8(%rax),%rax
  80088b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800897:	48 8b 00             	mov    (%rax),%rax
  80089a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80089e:	eb 4b                	jmp    8008eb <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	83 f8 30             	cmp    $0x30,%eax
  8008a9:	73 24                	jae    8008cf <getuint+0xe5>
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 01 d0             	add    %rdx,%rax
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	8b 12                	mov    (%rdx),%edx
  8008c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cb:	89 0a                	mov    %ecx,(%rdx)
  8008cd:	eb 14                	jmp    8008e3 <getuint+0xf9>
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008d7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e3:	8b 00                	mov    (%rax),%eax
  8008e5:	89 c0                	mov    %eax,%eax
  8008e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ef:	c9                   	leaveq 
  8008f0:	c3                   	retq   

00000000008008f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f1:	55                   	push   %rbp
  8008f2:	48 89 e5             	mov    %rsp,%rbp
  8008f5:	48 83 ec 20          	sub    $0x20,%rsp
  8008f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008fd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800900:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800904:	7e 4f                	jle    800955 <getint+0x64>
		x=va_arg(*ap, long long);
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	83 f8 30             	cmp    $0x30,%eax
  80090f:	73 24                	jae    800935 <getint+0x44>
  800911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800915:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091d:	8b 00                	mov    (%rax),%eax
  80091f:	89 c0                	mov    %eax,%eax
  800921:	48 01 d0             	add    %rdx,%rax
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	8b 12                	mov    (%rdx),%edx
  80092a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800931:	89 0a                	mov    %ecx,(%rdx)
  800933:	eb 14                	jmp    800949 <getint+0x58>
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	48 8b 40 08          	mov    0x8(%rax),%rax
  80093d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800941:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800945:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800949:	48 8b 00             	mov    (%rax),%rax
  80094c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800950:	e9 9d 00 00 00       	jmpq   8009f2 <getint+0x101>
	else if (lflag)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800959:	74 4c                	je     8009a7 <getint+0xb6>
		x=va_arg(*ap, long);
  80095b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095f:	8b 00                	mov    (%rax),%eax
  800961:	83 f8 30             	cmp    $0x30,%eax
  800964:	73 24                	jae    80098a <getint+0x99>
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800972:	8b 00                	mov    (%rax),%eax
  800974:	89 c0                	mov    %eax,%eax
  800976:	48 01 d0             	add    %rdx,%rax
  800979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097d:	8b 12                	mov    (%rdx),%edx
  80097f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800982:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800986:	89 0a                	mov    %ecx,(%rdx)
  800988:	eb 14                	jmp    80099e <getint+0xad>
  80098a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800992:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800996:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099e:	48 8b 00             	mov    (%rax),%rax
  8009a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a5:	eb 4b                	jmp    8009f2 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	8b 00                	mov    (%rax),%eax
  8009ad:	83 f8 30             	cmp    $0x30,%eax
  8009b0:	73 24                	jae    8009d6 <getint+0xe5>
  8009b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	8b 00                	mov    (%rax),%eax
  8009c0:	89 c0                	mov    %eax,%eax
  8009c2:	48 01 d0             	add    %rdx,%rax
  8009c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c9:	8b 12                	mov    (%rdx),%edx
  8009cb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d2:	89 0a                	mov    %ecx,(%rdx)
  8009d4:	eb 14                	jmp    8009ea <getint+0xf9>
  8009d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009da:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009de:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	48 98                	cltq   
  8009ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f6:	c9                   	leaveq 
  8009f7:	c3                   	retq   

00000000008009f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f8:	55                   	push   %rbp
  8009f9:	48 89 e5             	mov    %rsp,%rbp
  8009fc:	41 54                	push   %r12
  8009fe:	53                   	push   %rbx
  8009ff:	48 83 ec 60          	sub    $0x60,%rsp
  800a03:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a07:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a0b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a13:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a17:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a1b:	48 8b 0a             	mov    (%rdx),%rcx
  800a1e:	48 89 08             	mov    %rcx,(%rax)
  800a21:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a25:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a29:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a2d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a31:	eb 17                	jmp    800a4a <vprintfmt+0x52>
			if (ch == '\0')
  800a33:	85 db                	test   %ebx,%ebx
  800a35:	0f 84 b9 04 00 00    	je     800ef4 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800a3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a43:	48 89 d6             	mov    %rdx,%rsi
  800a46:	89 df                	mov    %ebx,%edi
  800a48:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a4e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a52:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a56:	0f b6 00             	movzbl (%rax),%eax
  800a59:	0f b6 d8             	movzbl %al,%ebx
  800a5c:	83 fb 25             	cmp    $0x25,%ebx
  800a5f:	75 d2                	jne    800a33 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a61:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a65:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a6c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a7a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a81:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a85:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a89:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a8d:	0f b6 00             	movzbl (%rax),%eax
  800a90:	0f b6 d8             	movzbl %al,%ebx
  800a93:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a96:	83 f8 55             	cmp    $0x55,%eax
  800a99:	0f 87 22 04 00 00    	ja     800ec1 <vprintfmt+0x4c9>
  800a9f:	89 c0                	mov    %eax,%eax
  800aa1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aa8:	00 
  800aa9:	48 b8 58 46 80 00 00 	movabs $0x804658,%rax
  800ab0:	00 00 00 
  800ab3:	48 01 d0             	add    %rdx,%rax
  800ab6:	48 8b 00             	mov    (%rax),%rax
  800ab9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800abb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800abf:	eb c0                	jmp    800a81 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac5:	eb ba                	jmp    800a81 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ace:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad1:	89 d0                	mov    %edx,%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	01 d0                	add    %edx,%eax
  800ad8:	01 c0                	add    %eax,%eax
  800ada:	01 d8                	add    %ebx,%eax
  800adc:	83 e8 30             	sub    $0x30,%eax
  800adf:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae6:	0f b6 00             	movzbl (%rax),%eax
  800ae9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aec:	83 fb 2f             	cmp    $0x2f,%ebx
  800aef:	7e 60                	jle    800b51 <vprintfmt+0x159>
  800af1:	83 fb 39             	cmp    $0x39,%ebx
  800af4:	7f 5b                	jg     800b51 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afb:	eb d1                	jmp    800ace <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800afd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b00:	83 f8 30             	cmp    $0x30,%eax
  800b03:	73 17                	jae    800b1c <vprintfmt+0x124>
  800b05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0c:	89 d2                	mov    %edx,%edx
  800b0e:	48 01 d0             	add    %rdx,%rax
  800b11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b14:	83 c2 08             	add    $0x8,%edx
  800b17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1a:	eb 0c                	jmp    800b28 <vprintfmt+0x130>
  800b1c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b20:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b24:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b28:	8b 00                	mov    (%rax),%eax
  800b2a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b2d:	eb 23                	jmp    800b52 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800b2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b33:	0f 89 48 ff ff ff    	jns    800a81 <vprintfmt+0x89>
				width = 0;
  800b39:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b40:	e9 3c ff ff ff       	jmpq   800a81 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b45:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b4c:	e9 30 ff ff ff       	jmpq   800a81 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b51:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b52:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b56:	0f 89 25 ff ff ff    	jns    800a81 <vprintfmt+0x89>
				width = precision, precision = -1;
  800b5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b5f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b62:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b69:	e9 13 ff ff ff       	jmpq   800a81 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b6e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b72:	e9 0a ff ff ff       	jmpq   800a81 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7a:	83 f8 30             	cmp    $0x30,%eax
  800b7d:	73 17                	jae    800b96 <vprintfmt+0x19e>
  800b7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b86:	89 d2                	mov    %edx,%edx
  800b88:	48 01 d0             	add    %rdx,%rax
  800b8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8e:	83 c2 08             	add    $0x8,%edx
  800b91:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b94:	eb 0c                	jmp    800ba2 <vprintfmt+0x1aa>
  800b96:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b9a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b9e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba2:	8b 10                	mov    (%rax),%edx
  800ba4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ba8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bac:	48 89 ce             	mov    %rcx,%rsi
  800baf:	89 d7                	mov    %edx,%edi
  800bb1:	ff d0                	callq  *%rax
			break;
  800bb3:	e9 37 03 00 00       	jmpq   800eef <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbb:	83 f8 30             	cmp    $0x30,%eax
  800bbe:	73 17                	jae    800bd7 <vprintfmt+0x1df>
  800bc0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bc4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc7:	89 d2                	mov    %edx,%edx
  800bc9:	48 01 d0             	add    %rdx,%rax
  800bcc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcf:	83 c2 08             	add    $0x8,%edx
  800bd2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd5:	eb 0c                	jmp    800be3 <vprintfmt+0x1eb>
  800bd7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bdb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bdf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800be5:	85 db                	test   %ebx,%ebx
  800be7:	79 02                	jns    800beb <vprintfmt+0x1f3>
				err = -err;
  800be9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800beb:	83 fb 15             	cmp    $0x15,%ebx
  800bee:	7f 16                	jg     800c06 <vprintfmt+0x20e>
  800bf0:	48 b8 80 45 80 00 00 	movabs $0x804580,%rax
  800bf7:	00 00 00 
  800bfa:	48 63 d3             	movslq %ebx,%rdx
  800bfd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c01:	4d 85 e4             	test   %r12,%r12
  800c04:	75 2e                	jne    800c34 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800c06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0e:	89 d9                	mov    %ebx,%ecx
  800c10:	48 ba 41 46 80 00 00 	movabs $0x804641,%rdx
  800c17:	00 00 00 
  800c1a:	48 89 c7             	mov    %rax,%rdi
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	49 b8 fe 0e 80 00 00 	movabs $0x800efe,%r8
  800c29:	00 00 00 
  800c2c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c2f:	e9 bb 02 00 00       	jmpq   800eef <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3c:	4c 89 e1             	mov    %r12,%rcx
  800c3f:	48 ba 4a 46 80 00 00 	movabs $0x80464a,%rdx
  800c46:	00 00 00 
  800c49:	48 89 c7             	mov    %rax,%rdi
  800c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c51:	49 b8 fe 0e 80 00 00 	movabs $0x800efe,%r8
  800c58:	00 00 00 
  800c5b:	41 ff d0             	callq  *%r8
			break;
  800c5e:	e9 8c 02 00 00       	jmpq   800eef <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c66:	83 f8 30             	cmp    $0x30,%eax
  800c69:	73 17                	jae    800c82 <vprintfmt+0x28a>
  800c6b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c72:	89 d2                	mov    %edx,%edx
  800c74:	48 01 d0             	add    %rdx,%rax
  800c77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7a:	83 c2 08             	add    $0x8,%edx
  800c7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c80:	eb 0c                	jmp    800c8e <vprintfmt+0x296>
  800c82:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c86:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c8e:	4c 8b 20             	mov    (%rax),%r12
  800c91:	4d 85 e4             	test   %r12,%r12
  800c94:	75 0a                	jne    800ca0 <vprintfmt+0x2a8>
				p = "(null)";
  800c96:	49 bc 4d 46 80 00 00 	movabs $0x80464d,%r12
  800c9d:	00 00 00 
			if (width > 0 && padc != '-')
  800ca0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ca4:	7e 78                	jle    800d1e <vprintfmt+0x326>
  800ca6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800caa:	74 72                	je     800d1e <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800caf:	48 98                	cltq   
  800cb1:	48 89 c6             	mov    %rax,%rsi
  800cb4:	4c 89 e7             	mov    %r12,%rdi
  800cb7:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  800cbe:	00 00 00 
  800cc1:	ff d0                	callq  *%rax
  800cc3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cc6:	eb 17                	jmp    800cdf <vprintfmt+0x2e7>
					putch(padc, putdat);
  800cc8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ccc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd4:	48 89 ce             	mov    %rcx,%rsi
  800cd7:	89 d7                	mov    %edx,%edi
  800cd9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cdb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce3:	7f e3                	jg     800cc8 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ce5:	eb 37                	jmp    800d1e <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800ce7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ceb:	74 1e                	je     800d0b <vprintfmt+0x313>
  800ced:	83 fb 1f             	cmp    $0x1f,%ebx
  800cf0:	7e 05                	jle    800cf7 <vprintfmt+0x2ff>
  800cf2:	83 fb 7e             	cmp    $0x7e,%ebx
  800cf5:	7e 14                	jle    800d0b <vprintfmt+0x313>
					putch('?', putdat);
  800cf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cff:	48 89 d6             	mov    %rdx,%rsi
  800d02:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d07:	ff d0                	callq  *%rax
  800d09:	eb 0f                	jmp    800d1a <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800d0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	48 89 d6             	mov    %rdx,%rsi
  800d16:	89 df                	mov    %ebx,%edi
  800d18:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d1a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d1e:	4c 89 e0             	mov    %r12,%rax
  800d21:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d25:	0f b6 00             	movzbl (%rax),%eax
  800d28:	0f be d8             	movsbl %al,%ebx
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	74 28                	je     800d57 <vprintfmt+0x35f>
  800d2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d33:	78 b2                	js     800ce7 <vprintfmt+0x2ef>
  800d35:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d39:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d3d:	79 a8                	jns    800ce7 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d3f:	eb 16                	jmp    800d57 <vprintfmt+0x35f>
				putch(' ', putdat);
  800d41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d49:	48 89 d6             	mov    %rdx,%rsi
  800d4c:	bf 20 00 00 00       	mov    $0x20,%edi
  800d51:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d53:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d5b:	7f e4                	jg     800d41 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800d5d:	e9 8d 01 00 00       	jmpq   800eef <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d62:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d66:	be 03 00 00 00       	mov    $0x3,%esi
  800d6b:	48 89 c7             	mov    %rax,%rdi
  800d6e:	48 b8 f1 08 80 00 00 	movabs $0x8008f1,%rax
  800d75:	00 00 00 
  800d78:	ff d0                	callq  *%rax
  800d7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d82:	48 85 c0             	test   %rax,%rax
  800d85:	79 1d                	jns    800da4 <vprintfmt+0x3ac>
				putch('-', putdat);
  800d87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8f:	48 89 d6             	mov    %rdx,%rsi
  800d92:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d97:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9d:	48 f7 d8             	neg    %rax
  800da0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800da4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dab:	e9 d2 00 00 00       	jmpq   800e82 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800db0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db4:	be 03 00 00 00       	mov    $0x3,%esi
  800db9:	48 89 c7             	mov    %rax,%rdi
  800dbc:	48 b8 ea 07 80 00 00 	movabs $0x8007ea,%rax
  800dc3:	00 00 00 
  800dc6:	ff d0                	callq  *%rax
  800dc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dcc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd3:	e9 aa 00 00 00       	jmpq   800e82 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800dd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ddc:	be 03 00 00 00       	mov    $0x3,%esi
  800de1:	48 89 c7             	mov    %rax,%rdi
  800de4:	48 b8 ea 07 80 00 00 	movabs $0x8007ea,%rax
  800deb:	00 00 00 
  800dee:	ff d0                	callq  *%rax
  800df0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800df4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dfb:	e9 82 00 00 00       	jmpq   800e82 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800e00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e08:	48 89 d6             	mov    %rdx,%rsi
  800e0b:	bf 30 00 00 00       	mov    $0x30,%edi
  800e10:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1a:	48 89 d6             	mov    %rdx,%rsi
  800e1d:	bf 78 00 00 00       	mov    $0x78,%edi
  800e22:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e27:	83 f8 30             	cmp    $0x30,%eax
  800e2a:	73 17                	jae    800e43 <vprintfmt+0x44b>
  800e2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e33:	89 d2                	mov    %edx,%edx
  800e35:	48 01 d0             	add    %rdx,%rax
  800e38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e3b:	83 c2 08             	add    $0x8,%edx
  800e3e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e41:	eb 0c                	jmp    800e4f <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800e43:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e47:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e4f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e56:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e5d:	eb 23                	jmp    800e82 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e5f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e63:	be 03 00 00 00       	mov    $0x3,%esi
  800e68:	48 89 c7             	mov    %rax,%rdi
  800e6b:	48 b8 ea 07 80 00 00 	movabs $0x8007ea,%rax
  800e72:	00 00 00 
  800e75:	ff d0                	callq  *%rax
  800e77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e7b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e82:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e87:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e8a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e91:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e99:	45 89 c1             	mov    %r8d,%r9d
  800e9c:	41 89 f8             	mov    %edi,%r8d
  800e9f:	48 89 c7             	mov    %rax,%rdi
  800ea2:	48 b8 32 07 80 00 00 	movabs $0x800732,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	callq  *%rax
			break;
  800eae:	eb 3f                	jmp    800eef <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb8:	48 89 d6             	mov    %rdx,%rsi
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	ff d0                	callq  *%rax
			break;
  800ebf:	eb 2e                	jmp    800eef <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ec1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec9:	48 89 d6             	mov    %rdx,%rsi
  800ecc:	bf 25 00 00 00       	mov    $0x25,%edi
  800ed1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ed3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ed8:	eb 05                	jmp    800edf <vprintfmt+0x4e7>
  800eda:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800edf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ee3:	48 83 e8 01          	sub    $0x1,%rax
  800ee7:	0f b6 00             	movzbl (%rax),%eax
  800eea:	3c 25                	cmp    $0x25,%al
  800eec:	75 ec                	jne    800eda <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800eee:	90                   	nop
		}
	}
  800eef:	e9 3d fb ff ff       	jmpq   800a31 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef4:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ef5:	48 83 c4 60          	add    $0x60,%rsp
  800ef9:	5b                   	pop    %rbx
  800efa:	41 5c                	pop    %r12
  800efc:	5d                   	pop    %rbp
  800efd:	c3                   	retq   

0000000000800efe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800efe:	55                   	push   %rbp
  800eff:	48 89 e5             	mov    %rsp,%rbp
  800f02:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f09:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f10:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f17:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800f1e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f25:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f33:	84 c0                	test   %al,%al
  800f35:	74 20                	je     800f57 <printfmt+0x59>
  800f37:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f3b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f3f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f43:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f47:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f4b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f4f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f53:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f57:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f5e:	00 00 00 
  800f61:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f68:	00 00 00 
  800f6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f6f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f76:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f7d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f8b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f92:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f99:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fa0:	48 89 c7             	mov    %rax,%rdi
  800fa3:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  800faa:	00 00 00 
  800fad:	ff d0                	callq  *%rax
	va_end(ap);
}
  800faf:	90                   	nop
  800fb0:	c9                   	leaveq 
  800fb1:	c3                   	retq   

0000000000800fb2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fb2:	55                   	push   %rbp
  800fb3:	48 89 e5             	mov    %rsp,%rbp
  800fb6:	48 83 ec 10          	sub    $0x10,%rsp
  800fba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc5:	8b 40 10             	mov    0x10(%rax),%eax
  800fc8:	8d 50 01             	lea    0x1(%rax),%edx
  800fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd6:	48 8b 10             	mov    (%rax),%rdx
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fe1:	48 39 c2             	cmp    %rax,%rdx
  800fe4:	73 17                	jae    800ffd <sprintputch+0x4b>
		*b->buf++ = ch;
  800fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fea:	48 8b 00             	mov    (%rax),%rax
  800fed:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ff1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ff5:	48 89 0a             	mov    %rcx,(%rdx)
  800ff8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ffb:	88 10                	mov    %dl,(%rax)
}
  800ffd:	90                   	nop
  800ffe:	c9                   	leaveq 
  800fff:	c3                   	retq   

0000000000801000 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801000:	55                   	push   %rbp
  801001:	48 89 e5             	mov    %rsp,%rbp
  801004:	48 83 ec 50          	sub    $0x50,%rsp
  801008:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80100c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80100f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801013:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801017:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80101b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80101f:	48 8b 0a             	mov    (%rdx),%rcx
  801022:	48 89 08             	mov    %rcx,(%rax)
  801025:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801029:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80102d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801031:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801035:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801039:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80103d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801040:	48 98                	cltq   
  801042:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801046:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80104a:	48 01 d0             	add    %rdx,%rax
  80104d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801051:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801058:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80105d:	74 06                	je     801065 <vsnprintf+0x65>
  80105f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801063:	7f 07                	jg     80106c <vsnprintf+0x6c>
		return -E_INVAL;
  801065:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106a:	eb 2f                	jmp    80109b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80106c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801070:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801074:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801078:	48 89 c6             	mov    %rax,%rsi
  80107b:	48 bf b2 0f 80 00 00 	movabs $0x800fb2,%rdi
  801082:	00 00 00 
  801085:	48 b8 f8 09 80 00 00 	movabs $0x8009f8,%rax
  80108c:	00 00 00 
  80108f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801091:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801095:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801098:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80109b:	c9                   	leaveq 
  80109c:	c3                   	retq   

000000000080109d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
  8010a1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010a8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010af:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010b5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8010bc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010c3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ca:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d1:	84 c0                	test   %al,%al
  8010d3:	74 20                	je     8010f5 <snprintf+0x58>
  8010d5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010d9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010dd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010e5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010e9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010ed:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010f5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010fc:	00 00 00 
  8010ff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801106:	00 00 00 
  801109:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80110d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801114:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80111b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801122:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801129:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801130:	48 8b 0a             	mov    (%rdx),%rcx
  801133:	48 89 08             	mov    %rcx,(%rax)
  801136:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80113a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801142:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801146:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80114d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801154:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80115a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801161:	48 89 c7             	mov    %rax,%rdi
  801164:	48 b8 00 10 80 00 00 	movabs $0x801000,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	callq  *%rax
  801170:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801176:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 18          	sub    $0x18,%rsp
  801186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80118a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801191:	eb 09                	jmp    80119c <strlen+0x1e>
		n++;
  801193:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801197:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	0f b6 00             	movzbl (%rax),%eax
  8011a3:	84 c0                	test   %al,%al
  8011a5:	75 ec                	jne    801193 <strlen+0x15>
		n++;
	return n;
  8011a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011aa:	c9                   	leaveq 
  8011ab:	c3                   	retq   

00000000008011ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	48 83 ec 20          	sub    $0x20,%rsp
  8011b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c3:	eb 0e                	jmp    8011d3 <strnlen+0x27>
		n++;
  8011c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011c9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ce:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011d3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011d8:	74 0b                	je     8011e5 <strnlen+0x39>
  8011da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011de:	0f b6 00             	movzbl (%rax),%eax
  8011e1:	84 c0                	test   %al,%al
  8011e3:	75 e0                	jne    8011c5 <strnlen+0x19>
		n++;
	return n;
  8011e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011e8:	c9                   	leaveq 
  8011e9:	c3                   	retq   

00000000008011ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ea:	55                   	push   %rbp
  8011eb:	48 89 e5             	mov    %rsp,%rbp
  8011ee:	48 83 ec 20          	sub    $0x20,%rsp
  8011f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801202:	90                   	nop
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801207:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80120b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80120f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801213:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801217:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80121b:	0f b6 12             	movzbl (%rdx),%edx
  80121e:	88 10                	mov    %dl,(%rax)
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	84 c0                	test   %al,%al
  801225:	75 dc                	jne    801203 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80122b:	c9                   	leaveq 
  80122c:	c3                   	retq   

000000000080122d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80122d:	55                   	push   %rbp
  80122e:	48 89 e5             	mov    %rsp,%rbp
  801231:	48 83 ec 20          	sub    $0x20,%rsp
  801235:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801239:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80123d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801241:	48 89 c7             	mov    %rax,%rdi
  801244:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  80124b:	00 00 00 
  80124e:	ff d0                	callq  *%rax
  801250:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801256:	48 63 d0             	movslq %eax,%rdx
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125d:	48 01 c2             	add    %rax,%rdx
  801260:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801264:	48 89 c6             	mov    %rax,%rsi
  801267:	48 89 d7             	mov    %rdx,%rdi
  80126a:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  801271:	00 00 00 
  801274:	ff d0                	callq  *%rax
	return dst;
  801276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80127a:	c9                   	leaveq 
  80127b:	c3                   	retq   

000000000080127c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80127c:	55                   	push   %rbp
  80127d:	48 89 e5             	mov    %rsp,%rbp
  801280:	48 83 ec 28          	sub    $0x28,%rsp
  801284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80128c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801294:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801298:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80129f:	00 
  8012a0:	eb 2a                	jmp    8012cc <strncpy+0x50>
		*dst++ = *src;
  8012a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012b2:	0f b6 12             	movzbl (%rdx),%edx
  8012b5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	74 05                	je     8012c7 <strncpy+0x4b>
			src++;
  8012c2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012d4:	72 cc                	jb     8012a2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012da:	c9                   	leaveq 
  8012db:	c3                   	retq   

00000000008012dc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	48 83 ec 28          	sub    $0x28,%rsp
  8012e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012fd:	74 3d                	je     80133c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012ff:	eb 1d                	jmp    80131e <strlcpy+0x42>
			*dst++ = *src++;
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801309:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80130d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801311:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801315:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801319:	0f b6 12             	movzbl (%rdx),%edx
  80131c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80131e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801323:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801328:	74 0b                	je     801335 <strlcpy+0x59>
  80132a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 cc                	jne    801301 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801339:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80133c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	48 29 c2             	sub    %rax,%rdx
  801347:	48 89 d0             	mov    %rdx,%rax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 10          	sub    $0x10,%rsp
  801354:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801358:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80135c:	eb 0a                	jmp    801368 <strcmp+0x1c>
		p++, q++;
  80135e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801363:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	0f b6 00             	movzbl (%rax),%eax
  80136f:	84 c0                	test   %al,%al
  801371:	74 12                	je     801385 <strcmp+0x39>
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 10             	movzbl (%rax),%edx
  80137a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137e:	0f b6 00             	movzbl (%rax),%eax
  801381:	38 c2                	cmp    %al,%dl
  801383:	74 d9                	je     80135e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	0f b6 c0             	movzbl %al,%eax
  801399:	29 c2                	sub    %eax,%edx
  80139b:	89 d0                	mov    %edx,%eax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 18          	sub    $0x18,%rsp
  8013a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013b3:	eb 0f                	jmp    8013c4 <strncmp+0x25>
		n--, p++, q++;
  8013b5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013c9:	74 1d                	je     8013e8 <strncmp+0x49>
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cf:	0f b6 00             	movzbl (%rax),%eax
  8013d2:	84 c0                	test   %al,%al
  8013d4:	74 12                	je     8013e8 <strncmp+0x49>
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	0f b6 10             	movzbl (%rax),%edx
  8013dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	38 c2                	cmp    %al,%dl
  8013e6:	74 cd                	je     8013b5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ed:	75 07                	jne    8013f6 <strncmp+0x57>
		return 0;
  8013ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f4:	eb 18                	jmp    80140e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f b6 d0             	movzbl %al,%edx
  801400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	0f b6 c0             	movzbl %al,%eax
  80140a:	29 c2                	sub    %eax,%edx
  80140c:	89 d0                	mov    %edx,%eax
}
  80140e:	c9                   	leaveq 
  80140f:	c3                   	retq   

0000000000801410 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801410:	55                   	push   %rbp
  801411:	48 89 e5             	mov    %rsp,%rbp
  801414:	48 83 ec 10          	sub    $0x10,%rsp
  801418:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141c:	89 f0                	mov    %esi,%eax
  80141e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801421:	eb 17                	jmp    80143a <strchr+0x2a>
		if (*s == c)
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80142d:	75 06                	jne    801435 <strchr+0x25>
			return (char *) s;
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	eb 15                	jmp    80144a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801435:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80143a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	84 c0                	test   %al,%al
  801443:	75 de                	jne    801423 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144a:	c9                   	leaveq 
  80144b:	c3                   	retq   

000000000080144c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80144c:	55                   	push   %rbp
  80144d:	48 89 e5             	mov    %rsp,%rbp
  801450:	48 83 ec 10          	sub    $0x10,%rsp
  801454:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801458:	89 f0                	mov    %esi,%eax
  80145a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80145d:	eb 11                	jmp    801470 <strfind+0x24>
		if (*s == c)
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801469:	74 12                	je     80147d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80146b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801474:	0f b6 00             	movzbl (%rax),%eax
  801477:	84 c0                	test   %al,%al
  801479:	75 e4                	jne    80145f <strfind+0x13>
  80147b:	eb 01                	jmp    80147e <strfind+0x32>
		if (*s == c)
			break;
  80147d:	90                   	nop
	return (char *) s;
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801482:	c9                   	leaveq 
  801483:	c3                   	retq   

0000000000801484 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801484:	55                   	push   %rbp
  801485:	48 89 e5             	mov    %rsp,%rbp
  801488:	48 83 ec 18          	sub    $0x18,%rsp
  80148c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801490:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801493:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801497:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80149c:	75 06                	jne    8014a4 <memset+0x20>
		return v;
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a2:	eb 69                	jmp    80150d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a8:	83 e0 03             	and    $0x3,%eax
  8014ab:	48 85 c0             	test   %rax,%rax
  8014ae:	75 48                	jne    8014f8 <memset+0x74>
  8014b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b4:	83 e0 03             	and    $0x3,%eax
  8014b7:	48 85 c0             	test   %rax,%rax
  8014ba:	75 3c                	jne    8014f8 <memset+0x74>
		c &= 0xFF;
  8014bc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c6:	c1 e0 18             	shl    $0x18,%eax
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ce:	c1 e0 10             	shl    $0x10,%eax
  8014d1:	09 c2                	or     %eax,%edx
  8014d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d6:	c1 e0 08             	shl    $0x8,%eax
  8014d9:	09 d0                	or     %edx,%eax
  8014db:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e2:	48 c1 e8 02          	shr    $0x2,%rax
  8014e6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f0:	48 89 d7             	mov    %rdx,%rdi
  8014f3:	fc                   	cld    
  8014f4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014f6:	eb 11                	jmp    801509 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801503:	48 89 d7             	mov    %rdx,%rdi
  801506:	fc                   	cld    
  801507:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80150d:	c9                   	leaveq 
  80150e:	c3                   	retq   

000000000080150f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80150f:	55                   	push   %rbp
  801510:	48 89 e5             	mov    %rsp,%rbp
  801513:	48 83 ec 28          	sub    $0x28,%rsp
  801517:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801523:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801527:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80152b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801537:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80153b:	0f 83 88 00 00 00    	jae    8015c9 <memmove+0xba>
  801541:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801549:	48 01 d0             	add    %rdx,%rax
  80154c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801550:	76 77                	jbe    8015c9 <memmove+0xba>
		s += n;
  801552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801556:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80155a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801566:	83 e0 03             	and    $0x3,%eax
  801569:	48 85 c0             	test   %rax,%rax
  80156c:	75 3b                	jne    8015a9 <memmove+0x9a>
  80156e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801572:	83 e0 03             	and    $0x3,%eax
  801575:	48 85 c0             	test   %rax,%rax
  801578:	75 2f                	jne    8015a9 <memmove+0x9a>
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	83 e0 03             	and    $0x3,%eax
  801581:	48 85 c0             	test   %rax,%rax
  801584:	75 23                	jne    8015a9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158a:	48 83 e8 04          	sub    $0x4,%rax
  80158e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801592:	48 83 ea 04          	sub    $0x4,%rdx
  801596:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80159a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80159e:	48 89 c7             	mov    %rax,%rdi
  8015a1:	48 89 d6             	mov    %rdx,%rsi
  8015a4:	fd                   	std    
  8015a5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015a7:	eb 1d                	jmp    8015c6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ad:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	48 89 d7             	mov    %rdx,%rdi
  8015c0:	48 89 c1             	mov    %rax,%rcx
  8015c3:	fd                   	std    
  8015c4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015c6:	fc                   	cld    
  8015c7:	eb 57                	jmp    801620 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cd:	83 e0 03             	and    $0x3,%eax
  8015d0:	48 85 c0             	test   %rax,%rax
  8015d3:	75 36                	jne    80160b <memmove+0xfc>
  8015d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d9:	83 e0 03             	and    $0x3,%eax
  8015dc:	48 85 c0             	test   %rax,%rax
  8015df:	75 2a                	jne    80160b <memmove+0xfc>
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	83 e0 03             	and    $0x3,%eax
  8015e8:	48 85 c0             	test   %rax,%rax
  8015eb:	75 1e                	jne    80160b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	48 c1 e8 02          	shr    $0x2,%rax
  8015f5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801600:	48 89 c7             	mov    %rax,%rdi
  801603:	48 89 d6             	mov    %rdx,%rsi
  801606:	fc                   	cld    
  801607:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801609:	eb 15                	jmp    801620 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80160b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801613:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801617:	48 89 c7             	mov    %rax,%rdi
  80161a:	48 89 d6             	mov    %rdx,%rsi
  80161d:	fc                   	cld    
  80161e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801624:	c9                   	leaveq 
  801625:	c3                   	retq   

0000000000801626 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801626:	55                   	push   %rbp
  801627:	48 89 e5             	mov    %rsp,%rbp
  80162a:	48 83 ec 18          	sub    $0x18,%rsp
  80162e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801632:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801636:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80163a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801646:	48 89 ce             	mov    %rcx,%rsi
  801649:	48 89 c7             	mov    %rax,%rdi
  80164c:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  801653:	00 00 00 
  801656:	ff d0                	callq  *%rax
}
  801658:	c9                   	leaveq 
  801659:	c3                   	retq   

000000000080165a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80165a:	55                   	push   %rbp
  80165b:	48 89 e5             	mov    %rsp,%rbp
  80165e:	48 83 ec 28          	sub    $0x28,%rsp
  801662:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801666:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80166a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80166e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801672:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801676:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80167a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80167e:	eb 36                	jmp    8016b6 <memcmp+0x5c>
		if (*s1 != *s2)
  801680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801684:	0f b6 10             	movzbl (%rax),%edx
  801687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168b:	0f b6 00             	movzbl (%rax),%eax
  80168e:	38 c2                	cmp    %al,%dl
  801690:	74 1a                	je     8016ac <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801692:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	0f b6 d0             	movzbl %al,%edx
  80169c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	29 c2                	sub    %eax,%edx
  8016a8:	89 d0                	mov    %edx,%eax
  8016aa:	eb 20                	jmp    8016cc <memcmp+0x72>
		s1++, s2++;
  8016ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016c2:	48 85 c0             	test   %rax,%rax
  8016c5:	75 b9                	jne    801680 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cc:	c9                   	leaveq 
  8016cd:	c3                   	retq   

00000000008016ce <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016ce:	55                   	push   %rbp
  8016cf:	48 89 e5             	mov    %rsp,%rbp
  8016d2:	48 83 ec 28          	sub    $0x28,%rsp
  8016d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016da:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	48 01 d0             	add    %rdx,%rax
  8016ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016f0:	eb 19                	jmp    80170b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	0f b6 d0             	movzbl %al,%edx
  8016fc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016ff:	0f b6 c0             	movzbl %al,%eax
  801702:	39 c2                	cmp    %eax,%edx
  801704:	74 11                	je     801717 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801706:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80170b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801713:	72 dd                	jb     8016f2 <memfind+0x24>
  801715:	eb 01                	jmp    801718 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801717:	90                   	nop
	return (void *) s;
  801718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
  801722:	48 83 ec 38          	sub    $0x38,%rsp
  801726:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80172a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80172e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801731:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801738:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80173f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801740:	eb 05                	jmp    801747 <strtol+0x29>
		s++;
  801742:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	0f b6 00             	movzbl (%rax),%eax
  80174e:	3c 20                	cmp    $0x20,%al
  801750:	74 f0                	je     801742 <strtol+0x24>
  801752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	3c 09                	cmp    $0x9,%al
  80175b:	74 e5                	je     801742 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	0f b6 00             	movzbl (%rax),%eax
  801764:	3c 2b                	cmp    $0x2b,%al
  801766:	75 07                	jne    80176f <strtol+0x51>
		s++;
  801768:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80176d:	eb 17                	jmp    801786 <strtol+0x68>
	else if (*s == '-')
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	3c 2d                	cmp    $0x2d,%al
  801778:	75 0c                	jne    801786 <strtol+0x68>
		s++, neg = 1;
  80177a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80177f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801786:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80178a:	74 06                	je     801792 <strtol+0x74>
  80178c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801790:	75 28                	jne    8017ba <strtol+0x9c>
  801792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	3c 30                	cmp    $0x30,%al
  80179b:	75 1d                	jne    8017ba <strtol+0x9c>
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	48 83 c0 01          	add    $0x1,%rax
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	3c 78                	cmp    $0x78,%al
  8017aa:	75 0e                	jne    8017ba <strtol+0x9c>
		s += 2, base = 16;
  8017ac:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017b1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017b8:	eb 2c                	jmp    8017e6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017be:	75 19                	jne    8017d9 <strtol+0xbb>
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	3c 30                	cmp    $0x30,%al
  8017c9:	75 0e                	jne    8017d9 <strtol+0xbb>
		s++, base = 8;
  8017cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017d7:	eb 0d                	jmp    8017e6 <strtol+0xc8>
	else if (base == 0)
  8017d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017dd:	75 07                	jne    8017e6 <strtol+0xc8>
		base = 10;
  8017df:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ea:	0f b6 00             	movzbl (%rax),%eax
  8017ed:	3c 2f                	cmp    $0x2f,%al
  8017ef:	7e 1d                	jle    80180e <strtol+0xf0>
  8017f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f5:	0f b6 00             	movzbl (%rax),%eax
  8017f8:	3c 39                	cmp    $0x39,%al
  8017fa:	7f 12                	jg     80180e <strtol+0xf0>
			dig = *s - '0';
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	0f b6 00             	movzbl (%rax),%eax
  801803:	0f be c0             	movsbl %al,%eax
  801806:	83 e8 30             	sub    $0x30,%eax
  801809:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80180c:	eb 4e                	jmp    80185c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80180e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801812:	0f b6 00             	movzbl (%rax),%eax
  801815:	3c 60                	cmp    $0x60,%al
  801817:	7e 1d                	jle    801836 <strtol+0x118>
  801819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181d:	0f b6 00             	movzbl (%rax),%eax
  801820:	3c 7a                	cmp    $0x7a,%al
  801822:	7f 12                	jg     801836 <strtol+0x118>
			dig = *s - 'a' + 10;
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	0f b6 00             	movzbl (%rax),%eax
  80182b:	0f be c0             	movsbl %al,%eax
  80182e:	83 e8 57             	sub    $0x57,%eax
  801831:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801834:	eb 26                	jmp    80185c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	3c 40                	cmp    $0x40,%al
  80183f:	7e 47                	jle    801888 <strtol+0x16a>
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	0f b6 00             	movzbl (%rax),%eax
  801848:	3c 5a                	cmp    $0x5a,%al
  80184a:	7f 3c                	jg     801888 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	0f be c0             	movsbl %al,%eax
  801856:	83 e8 37             	sub    $0x37,%eax
  801859:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80185c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80185f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801862:	7d 23                	jge    801887 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801864:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801869:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80186c:	48 98                	cltq   
  80186e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801873:	48 89 c2             	mov    %rax,%rdx
  801876:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801879:	48 98                	cltq   
  80187b:	48 01 d0             	add    %rdx,%rax
  80187e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801882:	e9 5f ff ff ff       	jmpq   8017e6 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801887:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801888:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80188d:	74 0b                	je     80189a <strtol+0x17c>
		*endptr = (char *) s;
  80188f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801893:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801897:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80189a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189e:	74 09                	je     8018a9 <strtol+0x18b>
  8018a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a4:	48 f7 d8             	neg    %rax
  8018a7:	eb 04                	jmp    8018ad <strtol+0x18f>
  8018a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018ad:	c9                   	leaveq 
  8018ae:	c3                   	retq   

00000000008018af <strstr>:

char * strstr(const char *in, const char *str)
{
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 30          	sub    $0x30,%rsp
  8018b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018c7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018cb:	0f b6 00             	movzbl (%rax),%eax
  8018ce:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018d1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018d5:	75 06                	jne    8018dd <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018db:	eb 6b                	jmp    801948 <strstr+0x99>

	len = strlen(str);
  8018dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e1:	48 89 c7             	mov    %rax,%rdi
  8018e4:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  8018eb:	00 00 00 
  8018ee:	ff d0                	callq  *%rax
  8018f0:	48 98                	cltq   
  8018f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801902:	0f b6 00             	movzbl (%rax),%eax
  801905:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801908:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80190c:	75 07                	jne    801915 <strstr+0x66>
				return (char *) 0;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	eb 33                	jmp    801948 <strstr+0x99>
		} while (sc != c);
  801915:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801919:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80191c:	75 d8                	jne    8018f6 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80191e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801922:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192a:	48 89 ce             	mov    %rcx,%rsi
  80192d:	48 89 c7             	mov    %rax,%rdi
  801930:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  801937:	00 00 00 
  80193a:	ff d0                	callq  *%rax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	75 b6                	jne    8018f6 <strstr+0x47>

	return (char *) (in - 1);
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	48 83 e8 01          	sub    $0x1,%rax
}
  801948:	c9                   	leaveq 
  801949:	c3                   	retq   

000000000080194a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	53                   	push   %rbx
  80194f:	48 83 ec 48          	sub    $0x48,%rsp
  801953:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801956:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801959:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80195d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801961:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801965:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801969:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80196c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801970:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801974:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801978:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80197c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801980:	4c 89 c3             	mov    %r8,%rbx
  801983:	cd 30                	int    $0x30
  801985:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801989:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80198d:	74 3e                	je     8019cd <syscall+0x83>
  80198f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801994:	7e 37                	jle    8019cd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801996:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80199a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80199d:	49 89 d0             	mov    %rdx,%r8
  8019a0:	89 c1                	mov    %eax,%ecx
  8019a2:	48 ba 08 49 80 00 00 	movabs $0x804908,%rdx
  8019a9:	00 00 00 
  8019ac:	be 24 00 00 00       	mov    $0x24,%esi
  8019b1:	48 bf 25 49 80 00 00 	movabs $0x804925,%rdi
  8019b8:	00 00 00 
  8019bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c0:	49 b9 20 04 80 00 00 	movabs $0x800420,%r9
  8019c7:	00 00 00 
  8019ca:	41 ff d1             	callq  *%r9

	return ret;
  8019cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d1:	48 83 c4 48          	add    $0x48,%rsp
  8019d5:	5b                   	pop    %rbx
  8019d6:	5d                   	pop    %rbp
  8019d7:	c3                   	retq   

00000000008019d8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019d8:	55                   	push   %rbp
  8019d9:	48 89 e5             	mov    %rsp,%rbp
  8019dc:	48 83 ec 10          	sub    $0x10,%rsp
  8019e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f0:	48 83 ec 08          	sub    $0x8,%rsp
  8019f4:	6a 00                	pushq  $0x0
  8019f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a02:	48 89 d1             	mov    %rdx,%rcx
  801a05:	48 89 c2             	mov    %rax,%rdx
  801a08:	be 00 00 00 00       	mov    $0x0,%esi
  801a0d:	bf 00 00 00 00       	mov    $0x0,%edi
  801a12:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
  801a1e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a22:	90                   	nop
  801a23:	c9                   	leaveq 
  801a24:	c3                   	retq   

0000000000801a25 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a25:	55                   	push   %rbp
  801a26:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a29:	48 83 ec 08          	sub    $0x8,%rsp
  801a2d:	6a 00                	pushq  $0x0
  801a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a40:	ba 00 00 00 00       	mov    $0x0,%edx
  801a45:	be 00 00 00 00       	mov    $0x0,%esi
  801a4a:	bf 01 00 00 00       	mov    $0x1,%edi
  801a4f:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
  801a5b:	48 83 c4 10          	add    $0x10,%rsp
}
  801a5f:	c9                   	leaveq 
  801a60:	c3                   	retq   

0000000000801a61 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a61:	55                   	push   %rbp
  801a62:	48 89 e5             	mov    %rsp,%rbp
  801a65:	48 83 ec 10          	sub    $0x10,%rsp
  801a69:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6f:	48 98                	cltq   
  801a71:	48 83 ec 08          	sub    $0x8,%rsp
  801a75:	6a 00                	pushq  $0x0
  801a77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a88:	48 89 c2             	mov    %rax,%rdx
  801a8b:	be 01 00 00 00       	mov    $0x1,%esi
  801a90:	bf 03 00 00 00       	mov    $0x3,%edi
  801a95:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
  801aa1:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa5:	c9                   	leaveq 
  801aa6:	c3                   	retq   

0000000000801aa7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801aab:	48 83 ec 08          	sub    $0x8,%rsp
  801aaf:	6a 00                	pushq  $0x0
  801ab1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac7:	be 00 00 00 00       	mov    $0x0,%esi
  801acc:	bf 02 00 00 00       	mov    $0x2,%edi
  801ad1:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801ad8:	00 00 00 
  801adb:	ff d0                	callq  *%rax
  801add:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae1:	c9                   	leaveq 
  801ae2:	c3                   	retq   

0000000000801ae3 <sys_yield>:


void
sys_yield(void)
{
  801ae3:	55                   	push   %rbp
  801ae4:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ae7:	48 83 ec 08          	sub    $0x8,%rsp
  801aeb:	6a 00                	pushq  $0x0
  801aed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afe:	ba 00 00 00 00       	mov    $0x0,%edx
  801b03:	be 00 00 00 00       	mov    $0x0,%esi
  801b08:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b0d:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
  801b19:	48 83 c4 10          	add    $0x10,%rsp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	48 83 ec 10          	sub    $0x10,%rsp
  801b28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b35:	48 63 c8             	movslq %eax,%rcx
  801b38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3f:	48 98                	cltq   
  801b41:	48 83 ec 08          	sub    $0x8,%rsp
  801b45:	6a 00                	pushq  $0x0
  801b47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4d:	49 89 c8             	mov    %rcx,%r8
  801b50:	48 89 d1             	mov    %rdx,%rcx
  801b53:	48 89 c2             	mov    %rax,%rdx
  801b56:	be 01 00 00 00       	mov    $0x1,%esi
  801b5b:	bf 04 00 00 00       	mov    $0x4,%edi
  801b60:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	callq  *%rax
  801b6c:	48 83 c4 10          	add    $0x10,%rsp
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b81:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b84:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b88:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b8c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b8f:	48 63 c8             	movslq %eax,%rcx
  801b92:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b99:	48 63 f0             	movslq %eax,%rsi
  801b9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba3:	48 98                	cltq   
  801ba5:	48 83 ec 08          	sub    $0x8,%rsp
  801ba9:	51                   	push   %rcx
  801baa:	49 89 f9             	mov    %rdi,%r9
  801bad:	49 89 f0             	mov    %rsi,%r8
  801bb0:	48 89 d1             	mov    %rdx,%rcx
  801bb3:	48 89 c2             	mov    %rax,%rdx
  801bb6:	be 01 00 00 00       	mov    $0x1,%esi
  801bbb:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc0:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	48 83 c4 10          	add    $0x10,%rsp
}
  801bd0:	c9                   	leaveq 
  801bd1:	c3                   	retq   

0000000000801bd2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	48 83 ec 10          	sub    $0x10,%rsp
  801bda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801be1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be8:	48 98                	cltq   
  801bea:	48 83 ec 08          	sub    $0x8,%rsp
  801bee:	6a 00                	pushq  $0x0
  801bf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfc:	48 89 d1             	mov    %rdx,%rcx
  801bff:	48 89 c2             	mov    %rax,%rdx
  801c02:	be 01 00 00 00       	mov    $0x1,%esi
  801c07:	bf 06 00 00 00       	mov    $0x6,%edi
  801c0c:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	callq  *%rax
  801c18:	48 83 c4 10          	add    $0x10,%rsp
}
  801c1c:	c9                   	leaveq 
  801c1d:	c3                   	retq   

0000000000801c1e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c1e:	55                   	push   %rbp
  801c1f:	48 89 e5             	mov    %rsp,%rbp
  801c22:	48 83 ec 10          	sub    $0x10,%rsp
  801c26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c29:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2f:	48 63 d0             	movslq %eax,%rdx
  801c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c35:	48 98                	cltq   
  801c37:	48 83 ec 08          	sub    $0x8,%rsp
  801c3b:	6a 00                	pushq  $0x0
  801c3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c49:	48 89 d1             	mov    %rdx,%rcx
  801c4c:	48 89 c2             	mov    %rax,%rdx
  801c4f:	be 01 00 00 00       	mov    $0x1,%esi
  801c54:	bf 08 00 00 00       	mov    $0x8,%edi
  801c59:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801c60:	00 00 00 
  801c63:	ff d0                	callq  *%rax
  801c65:	48 83 c4 10          	add    $0x10,%rsp
}
  801c69:	c9                   	leaveq 
  801c6a:	c3                   	retq   

0000000000801c6b <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c6b:	55                   	push   %rbp
  801c6c:	48 89 e5             	mov    %rsp,%rbp
  801c6f:	48 83 ec 10          	sub    $0x10,%rsp
  801c73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c81:	48 98                	cltq   
  801c83:	48 83 ec 08          	sub    $0x8,%rsp
  801c87:	6a 00                	pushq  $0x0
  801c89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c95:	48 89 d1             	mov    %rdx,%rcx
  801c98:	48 89 c2             	mov    %rax,%rdx
  801c9b:	be 01 00 00 00       	mov    $0x1,%esi
  801ca0:	bf 09 00 00 00       	mov    $0x9,%edi
  801ca5:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801cac:	00 00 00 
  801caf:	ff d0                	callq  *%rax
  801cb1:	48 83 c4 10          	add    $0x10,%rsp
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 10          	sub    $0x10,%rsp
  801cbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccd:	48 98                	cltq   
  801ccf:	48 83 ec 08          	sub    $0x8,%rsp
  801cd3:	6a 00                	pushq  $0x0
  801cd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce1:	48 89 d1             	mov    %rdx,%rcx
  801ce4:	48 89 c2             	mov    %rax,%rdx
  801ce7:	be 01 00 00 00       	mov    $0x1,%esi
  801cec:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cf1:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
  801cfd:	48 83 c4 10          	add    $0x10,%rsp
}
  801d01:	c9                   	leaveq 
  801d02:	c3                   	retq   

0000000000801d03 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d03:	55                   	push   %rbp
  801d04:	48 89 e5             	mov    %rsp,%rbp
  801d07:	48 83 ec 20          	sub    $0x20,%rsp
  801d0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d12:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d16:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d1c:	48 63 f0             	movslq %eax,%rsi
  801d1f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d26:	48 98                	cltq   
  801d28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2c:	48 83 ec 08          	sub    $0x8,%rsp
  801d30:	6a 00                	pushq  $0x0
  801d32:	49 89 f1             	mov    %rsi,%r9
  801d35:	49 89 c8             	mov    %rcx,%r8
  801d38:	48 89 d1             	mov    %rdx,%rcx
  801d3b:	48 89 c2             	mov    %rax,%rdx
  801d3e:	be 00 00 00 00       	mov    $0x0,%esi
  801d43:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d48:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801d4f:	00 00 00 
  801d52:	ff d0                	callq  *%rax
  801d54:	48 83 c4 10          	add    $0x10,%rsp
}
  801d58:	c9                   	leaveq 
  801d59:	c3                   	retq   

0000000000801d5a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d5a:	55                   	push   %rbp
  801d5b:	48 89 e5             	mov    %rsp,%rbp
  801d5e:	48 83 ec 10          	sub    $0x10,%rsp
  801d62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6a:	48 83 ec 08          	sub    $0x8,%rsp
  801d6e:	6a 00                	pushq  $0x0
  801d70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d81:	48 89 c2             	mov    %rax,%rdx
  801d84:	be 01 00 00 00       	mov    $0x1,%esi
  801d89:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d8e:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
  801d9a:	48 83 c4 10          	add    $0x10,%rsp
}
  801d9e:	c9                   	leaveq 
  801d9f:	c3                   	retq   

0000000000801da0 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801da0:	55                   	push   %rbp
  801da1:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801da4:	48 83 ec 08          	sub    $0x8,%rsp
  801da8:	6a 00                	pushq  $0x0
  801daa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc0:	be 00 00 00 00       	mov    $0x0,%esi
  801dc5:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dca:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801dd1:	00 00 00 
  801dd4:	ff d0                	callq  *%rax
  801dd6:	48 83 c4 10          	add    $0x10,%rsp
}
  801dda:	c9                   	leaveq 
  801ddb:	c3                   	retq   

0000000000801ddc <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801ddc:	55                   	push   %rbp
  801ddd:	48 89 e5             	mov    %rsp,%rbp
  801de0:	48 83 ec 10          	sub    $0x10,%rsp
  801de4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801de8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801deb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df2:	48 83 ec 08          	sub    $0x8,%rsp
  801df6:	6a 00                	pushq  $0x0
  801df8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e04:	48 89 d1             	mov    %rdx,%rcx
  801e07:	48 89 c2             	mov    %rax,%rdx
  801e0a:	be 00 00 00 00       	mov    $0x0,%esi
  801e0f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e14:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	48 83 c4 10          	add    $0x10,%rsp
}
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	48 83 ec 10          	sub    $0x10,%rsp
  801e2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e32:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801e35:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e3c:	48 83 ec 08          	sub    $0x8,%rsp
  801e40:	6a 00                	pushq  $0x0
  801e42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4e:	48 89 d1             	mov    %rdx,%rcx
  801e51:	48 89 c2             	mov    %rax,%rdx
  801e54:	be 00 00 00 00       	mov    $0x0,%esi
  801e59:	bf 10 00 00 00       	mov    $0x10,%edi
  801e5e:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	callq  *%rax
  801e6a:	48 83 c4 10          	add    $0x10,%rsp
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 20          	sub    $0x20,%rsp
  801e78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e82:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e86:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e8d:	48 63 c8             	movslq %eax,%rcx
  801e90:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e97:	48 63 f0             	movslq %eax,%rsi
  801e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea1:	48 98                	cltq   
  801ea3:	48 83 ec 08          	sub    $0x8,%rsp
  801ea7:	51                   	push   %rcx
  801ea8:	49 89 f9             	mov    %rdi,%r9
  801eab:	49 89 f0             	mov    %rsi,%r8
  801eae:	48 89 d1             	mov    %rdx,%rcx
  801eb1:	48 89 c2             	mov    %rax,%rdx
  801eb4:	be 00 00 00 00       	mov    $0x0,%esi
  801eb9:	bf 11 00 00 00       	mov    $0x11,%edi
  801ebe:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
  801eca:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 10          	sub    $0x10,%rsp
  801ed8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801edc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ee0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee8:	48 83 ec 08          	sub    $0x8,%rsp
  801eec:	6a 00                	pushq  $0x0
  801eee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801efa:	48 89 d1             	mov    %rdx,%rcx
  801efd:	48 89 c2             	mov    %rax,%rdx
  801f00:	be 00 00 00 00       	mov    $0x0,%esi
  801f05:	bf 12 00 00 00       	mov    $0x12,%edi
  801f0a:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	48 83 c4 10          	add    $0x10,%rsp
}
  801f1a:	c9                   	leaveq 
  801f1b:	c3                   	retq   

0000000000801f1c <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801f1c:	55                   	push   %rbp
  801f1d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801f20:	48 83 ec 08          	sub    $0x8,%rsp
  801f24:	6a 00                	pushq  $0x0
  801f26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f32:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f37:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3c:	be 00 00 00 00       	mov    $0x0,%esi
  801f41:	bf 13 00 00 00       	mov    $0x13,%edi
  801f46:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801f4d:	00 00 00 
  801f50:	ff d0                	callq  *%rax
  801f52:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801f56:	90                   	nop
  801f57:	c9                   	leaveq 
  801f58:	c3                   	retq   

0000000000801f59 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801f59:	55                   	push   %rbp
  801f5a:	48 89 e5             	mov    %rsp,%rbp
  801f5d:	48 83 ec 10          	sub    $0x10,%rsp
  801f61:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f67:	48 98                	cltq   
  801f69:	48 83 ec 08          	sub    $0x8,%rsp
  801f6d:	6a 00                	pushq  $0x0
  801f6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f80:	48 89 c2             	mov    %rax,%rdx
  801f83:	be 00 00 00 00       	mov    $0x0,%esi
  801f88:	bf 14 00 00 00       	mov    $0x14,%edi
  801f8d:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801f94:	00 00 00 
  801f97:	ff d0                	callq  *%rax
  801f99:	48 83 c4 10          	add    $0x10,%rsp
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fa3:	48 83 ec 08          	sub    $0x8,%rsp
  801fa7:	6a 00                	pushq  $0x0
  801fa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801faf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbf:	be 00 00 00 00       	mov    $0x0,%esi
  801fc4:	bf 15 00 00 00       	mov    $0x15,%edi
  801fc9:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
  801fd5:	48 83 c4 10          	add    $0x10,%rsp
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fdf:	48 83 ec 08          	sub    $0x8,%rsp
  801fe3:	6a 00                	pushq  $0x0
  801fe5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801feb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ff6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffb:	be 00 00 00 00       	mov    $0x0,%esi
  802000:	bf 16 00 00 00       	mov    $0x16,%edi
  802005:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	48 83 c4 10          	add    $0x10,%rsp
}
  802015:	90                   	nop
  802016:	c9                   	leaveq 
  802017:	c3                   	retq   

0000000000802018 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802018:	55                   	push   %rbp
  802019:	48 89 e5             	mov    %rsp,%rbp
  80201c:	48 83 ec 08          	sub    $0x8,%rsp
  802020:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802024:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802028:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80202f:	ff ff ff 
  802032:	48 01 d0             	add    %rdx,%rax
  802035:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802039:	c9                   	leaveq 
  80203a:	c3                   	retq   

000000000080203b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80203b:	55                   	push   %rbp
  80203c:	48 89 e5             	mov    %rsp,%rbp
  80203f:	48 83 ec 08          	sub    $0x8,%rsp
  802043:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204b:	48 89 c7             	mov    %rax,%rdi
  80204e:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  802055:	00 00 00 
  802058:	ff d0                	callq  *%rax
  80205a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802060:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802064:	c9                   	leaveq 
  802065:	c3                   	retq   

0000000000802066 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802066:	55                   	push   %rbp
  802067:	48 89 e5             	mov    %rsp,%rbp
  80206a:	48 83 ec 18          	sub    $0x18,%rsp
  80206e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802079:	eb 6b                	jmp    8020e6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80207b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207e:	48 98                	cltq   
  802080:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802086:	48 c1 e0 0c          	shl    $0xc,%rax
  80208a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80208e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802092:	48 c1 e8 15          	shr    $0x15,%rax
  802096:	48 89 c2             	mov    %rax,%rdx
  802099:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a0:	01 00 00 
  8020a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a7:	83 e0 01             	and    $0x1,%eax
  8020aa:	48 85 c0             	test   %rax,%rax
  8020ad:	74 21                	je     8020d0 <fd_alloc+0x6a>
  8020af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8020b7:	48 89 c2             	mov    %rax,%rdx
  8020ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c1:	01 00 00 
  8020c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c8:	83 e0 01             	and    $0x1,%eax
  8020cb:	48 85 c0             	test   %rax,%rax
  8020ce:	75 12                	jne    8020e2 <fd_alloc+0x7c>
			*fd_store = fd;
  8020d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	eb 1a                	jmp    8020fc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020e2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020e6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020ea:	7e 8f                	jle    80207b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020f7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020fc:	c9                   	leaveq 
  8020fd:	c3                   	retq   

00000000008020fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	48 83 ec 20          	sub    $0x20,%rsp
  802106:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802109:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80210d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802111:	78 06                	js     802119 <fd_lookup+0x1b>
  802113:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802117:	7e 07                	jle    802120 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802119:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80211e:	eb 6c                	jmp    80218c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802120:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802123:	48 98                	cltq   
  802125:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80212b:	48 c1 e0 0c          	shl    $0xc,%rax
  80212f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802137:	48 c1 e8 15          	shr    $0x15,%rax
  80213b:	48 89 c2             	mov    %rax,%rdx
  80213e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802145:	01 00 00 
  802148:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214c:	83 e0 01             	and    $0x1,%eax
  80214f:	48 85 c0             	test   %rax,%rax
  802152:	74 21                	je     802175 <fd_lookup+0x77>
  802154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802158:	48 c1 e8 0c          	shr    $0xc,%rax
  80215c:	48 89 c2             	mov    %rax,%rdx
  80215f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802166:	01 00 00 
  802169:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80216d:	83 e0 01             	and    $0x1,%eax
  802170:	48 85 c0             	test   %rax,%rax
  802173:	75 07                	jne    80217c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802175:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80217a:	eb 10                	jmp    80218c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80217c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802180:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802184:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218c:	c9                   	leaveq 
  80218d:	c3                   	retq   

000000000080218e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80218e:	55                   	push   %rbp
  80218f:	48 89 e5             	mov    %rsp,%rbp
  802192:	48 83 ec 30          	sub    $0x30,%rsp
  802196:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80219a:	89 f0                	mov    %esi,%eax
  80219c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80219f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a3:	48 89 c7             	mov    %rax,%rdi
  8021a6:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
  8021b2:	89 c2                	mov    %eax,%edx
  8021b4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8021b8:	48 89 c6             	mov    %rax,%rsi
  8021bb:	89 d7                	mov    %edx,%edi
  8021bd:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d0:	78 0a                	js     8021dc <fd_close+0x4e>
	    || fd != fd2)
  8021d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021da:	74 12                	je     8021ee <fd_close+0x60>
		return (must_exist ? r : 0);
  8021dc:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021e0:	74 05                	je     8021e7 <fd_close+0x59>
  8021e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e5:	eb 70                	jmp    802257 <fd_close+0xc9>
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	eb 69                	jmp    802257 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f2:	8b 00                	mov    (%rax),%eax
  8021f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021f8:	48 89 d6             	mov    %rdx,%rsi
  8021fb:	89 c7                	mov    %eax,%edi
  8021fd:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  802204:	00 00 00 
  802207:	ff d0                	callq  *%rax
  802209:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802210:	78 2a                	js     80223c <fd_close+0xae>
		if (dev->dev_close)
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	48 8b 40 20          	mov    0x20(%rax),%rax
  80221a:	48 85 c0             	test   %rax,%rax
  80221d:	74 16                	je     802235 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	48 8b 40 20          	mov    0x20(%rax),%rax
  802227:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80222b:	48 89 d7             	mov    %rdx,%rdi
  80222e:	ff d0                	callq  *%rax
  802230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802233:	eb 07                	jmp    80223c <fd_close+0xae>
		else
			r = 0;
  802235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80223c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802240:	48 89 c6             	mov    %rax,%rsi
  802243:	bf 00 00 00 00       	mov    $0x0,%edi
  802248:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
	return r;
  802254:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802257:	c9                   	leaveq 
  802258:	c3                   	retq   

0000000000802259 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802259:	55                   	push   %rbp
  80225a:	48 89 e5             	mov    %rsp,%rbp
  80225d:	48 83 ec 20          	sub    $0x20,%rsp
  802261:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802264:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80226f:	eb 41                	jmp    8022b2 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802271:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802278:	00 00 00 
  80227b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80227e:	48 63 d2             	movslq %edx,%rdx
  802281:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802285:	8b 00                	mov    (%rax),%eax
  802287:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80228a:	75 22                	jne    8022ae <dev_lookup+0x55>
			*dev = devtab[i];
  80228c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802293:	00 00 00 
  802296:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802299:	48 63 d2             	movslq %edx,%rdx
  80229c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8022a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ac:	eb 60                	jmp    80230e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8022ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022b2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8022b9:	00 00 00 
  8022bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022bf:	48 63 d2             	movslq %edx,%rdx
  8022c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c6:	48 85 c0             	test   %rax,%rax
  8022c9:	75 a6                	jne    802271 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022cb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022d2:	00 00 00 
  8022d5:	48 8b 00             	mov    (%rax),%rax
  8022d8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022de:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022e1:	89 c6                	mov    %eax,%esi
  8022e3:	48 bf 38 49 80 00 00 	movabs $0x804938,%rdi
  8022ea:	00 00 00 
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  8022f9:	00 00 00 
  8022fc:	ff d1                	callq  *%rcx
	*dev = 0;
  8022fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802302:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802309:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80230e:	c9                   	leaveq 
  80230f:	c3                   	retq   

0000000000802310 <close>:

int
close(int fdnum)
{
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	48 83 ec 20          	sub    $0x20,%rsp
  802318:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80231b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802322:	48 89 d6             	mov    %rdx,%rsi
  802325:	89 c7                	mov    %eax,%edi
  802327:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  80232e:	00 00 00 
  802331:	ff d0                	callq  *%rax
  802333:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802336:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233a:	79 05                	jns    802341 <close+0x31>
		return r;
  80233c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233f:	eb 18                	jmp    802359 <close+0x49>
	else
		return fd_close(fd, 1);
  802341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802345:	be 01 00 00 00       	mov    $0x1,%esi
  80234a:	48 89 c7             	mov    %rax,%rdi
  80234d:	48 b8 8e 21 80 00 00 	movabs $0x80218e,%rax
  802354:	00 00 00 
  802357:	ff d0                	callq  *%rax
}
  802359:	c9                   	leaveq 
  80235a:	c3                   	retq   

000000000080235b <close_all>:

void
close_all(void)
{
  80235b:	55                   	push   %rbp
  80235c:	48 89 e5             	mov    %rsp,%rbp
  80235f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80236a:	eb 15                	jmp    802381 <close_all+0x26>
		close(i);
  80236c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236f:	89 c7                	mov    %eax,%edi
  802371:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80237d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802381:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802385:	7e e5                	jle    80236c <close_all+0x11>
		close(i);
}
  802387:	90                   	nop
  802388:	c9                   	leaveq 
  802389:	c3                   	retq   

000000000080238a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80238a:	55                   	push   %rbp
  80238b:	48 89 e5             	mov    %rsp,%rbp
  80238e:	48 83 ec 40          	sub    $0x40,%rsp
  802392:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802395:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802398:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80239c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80239f:	48 89 d6             	mov    %rdx,%rsi
  8023a2:	89 c7                	mov    %eax,%edi
  8023a4:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	callq  *%rax
  8023b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b7:	79 08                	jns    8023c1 <dup+0x37>
		return r;
  8023b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bc:	e9 70 01 00 00       	jmpq   802531 <dup+0x1a7>
	close(newfdnum);
  8023c1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023c4:	89 c7                	mov    %eax,%edi
  8023c6:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  8023cd:	00 00 00 
  8023d0:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8023d2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023d5:	48 98                	cltq   
  8023d7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8023e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e9:	48 89 c7             	mov    %rax,%rdi
  8023ec:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  8023f3:	00 00 00 
  8023f6:	ff d0                	callq  *%rax
  8023f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802400:	48 89 c7             	mov    %rax,%rdi
  802403:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	callq  *%rax
  80240f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802417:	48 c1 e8 15          	shr    $0x15,%rax
  80241b:	48 89 c2             	mov    %rax,%rdx
  80241e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802425:	01 00 00 
  802428:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242c:	83 e0 01             	and    $0x1,%eax
  80242f:	48 85 c0             	test   %rax,%rax
  802432:	74 71                	je     8024a5 <dup+0x11b>
  802434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802438:	48 c1 e8 0c          	shr    $0xc,%rax
  80243c:	48 89 c2             	mov    %rax,%rdx
  80243f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802446:	01 00 00 
  802449:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244d:	83 e0 01             	and    $0x1,%eax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	74 50                	je     8024a5 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802459:	48 c1 e8 0c          	shr    $0xc,%rax
  80245d:	48 89 c2             	mov    %rax,%rdx
  802460:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802467:	01 00 00 
  80246a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246e:	25 07 0e 00 00       	and    $0xe07,%eax
  802473:	89 c1                	mov    %eax,%ecx
  802475:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247d:	41 89 c8             	mov    %ecx,%r8d
  802480:	48 89 d1             	mov    %rdx,%rcx
  802483:	ba 00 00 00 00       	mov    $0x0,%edx
  802488:	48 89 c6             	mov    %rax,%rsi
  80248b:	bf 00 00 00 00       	mov    $0x0,%edi
  802490:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802497:	00 00 00 
  80249a:	ff d0                	callq  *%rax
  80249c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a3:	78 55                	js     8024fa <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8024a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ad:	48 89 c2             	mov    %rax,%rdx
  8024b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b7:	01 00 00 
  8024ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024be:	25 07 0e 00 00       	and    $0xe07,%eax
  8024c3:	89 c1                	mov    %eax,%ecx
  8024c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024cd:	41 89 c8             	mov    %ecx,%r8d
  8024d0:	48 89 d1             	mov    %rdx,%rcx
  8024d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d8:	48 89 c6             	mov    %rax,%rsi
  8024db:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e0:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f3:	78 08                	js     8024fd <dup+0x173>
		goto err;

	return newfdnum;
  8024f5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024f8:	eb 37                	jmp    802531 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8024fa:	90                   	nop
  8024fb:	eb 01                	jmp    8024fe <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8024fd:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8024fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802502:	48 89 c6             	mov    %rax,%rsi
  802505:	bf 00 00 00 00       	mov    $0x0,%edi
  80250a:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802511:	00 00 00 
  802514:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802516:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251a:	48 89 c6             	mov    %rax,%rsi
  80251d:	bf 00 00 00 00       	mov    $0x0,%edi
  802522:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
	return r;
  80252e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802531:	c9                   	leaveq 
  802532:	c3                   	retq   

0000000000802533 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802533:	55                   	push   %rbp
  802534:	48 89 e5             	mov    %rsp,%rbp
  802537:	48 83 ec 40          	sub    $0x40,%rsp
  80253b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80253e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802542:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802546:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80254a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80254d:	48 89 d6             	mov    %rdx,%rsi
  802550:	89 c7                	mov    %eax,%edi
  802552:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  802559:	00 00 00 
  80255c:	ff d0                	callq  *%rax
  80255e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802565:	78 24                	js     80258b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256b:	8b 00                	mov    (%rax),%eax
  80256d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802571:	48 89 d6             	mov    %rdx,%rsi
  802574:	89 c7                	mov    %eax,%edi
  802576:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802585:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802589:	79 05                	jns    802590 <read+0x5d>
		return r;
  80258b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258e:	eb 76                	jmp    802606 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802594:	8b 40 08             	mov    0x8(%rax),%eax
  802597:	83 e0 03             	and    $0x3,%eax
  80259a:	83 f8 01             	cmp    $0x1,%eax
  80259d:	75 3a                	jne    8025d9 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80259f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025a6:	00 00 00 
  8025a9:	48 8b 00             	mov    (%rax),%rax
  8025ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025b5:	89 c6                	mov    %eax,%esi
  8025b7:	48 bf 57 49 80 00 00 	movabs $0x804957,%rdi
  8025be:	00 00 00 
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c6:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  8025cd:	00 00 00 
  8025d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025d7:	eb 2d                	jmp    802606 <read+0xd3>
	}
	if (!dev->dev_read)
  8025d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dd:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025e1:	48 85 c0             	test   %rax,%rax
  8025e4:	75 07                	jne    8025ed <read+0xba>
		return -E_NOT_SUPP;
  8025e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025eb:	eb 19                	jmp    802606 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802601:	48 89 cf             	mov    %rcx,%rdi
  802604:	ff d0                	callq  *%rax
}
  802606:	c9                   	leaveq 
  802607:	c3                   	retq   

0000000000802608 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802608:	55                   	push   %rbp
  802609:	48 89 e5             	mov    %rsp,%rbp
  80260c:	48 83 ec 30          	sub    $0x30,%rsp
  802610:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802613:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802617:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80261b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802622:	eb 47                	jmp    80266b <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802627:	48 98                	cltq   
  802629:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80262d:	48 29 c2             	sub    %rax,%rdx
  802630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802633:	48 63 c8             	movslq %eax,%rcx
  802636:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263a:	48 01 c1             	add    %rax,%rcx
  80263d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802640:	48 89 ce             	mov    %rcx,%rsi
  802643:	89 c7                	mov    %eax,%edi
  802645:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  80264c:	00 00 00 
  80264f:	ff d0                	callq  *%rax
  802651:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802654:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802658:	79 05                	jns    80265f <readn+0x57>
			return m;
  80265a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80265d:	eb 1d                	jmp    80267c <readn+0x74>
		if (m == 0)
  80265f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802663:	74 13                	je     802678 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802665:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802668:	01 45 fc             	add    %eax,-0x4(%rbp)
  80266b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266e:	48 98                	cltq   
  802670:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802674:	72 ae                	jb     802624 <readn+0x1c>
  802676:	eb 01                	jmp    802679 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802678:	90                   	nop
	}
	return tot;
  802679:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80267c:	c9                   	leaveq 
  80267d:	c3                   	retq   

000000000080267e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80267e:	55                   	push   %rbp
  80267f:	48 89 e5             	mov    %rsp,%rbp
  802682:	48 83 ec 40          	sub    $0x40,%rsp
  802686:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802689:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80268d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802691:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802695:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802698:	48 89 d6             	mov    %rdx,%rsi
  80269b:	89 c7                	mov    %eax,%edi
  80269d:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
  8026a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b0:	78 24                	js     8026d6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	8b 00                	mov    (%rax),%eax
  8026b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026bc:	48 89 d6             	mov    %rdx,%rsi
  8026bf:	89 c7                	mov    %eax,%edi
  8026c1:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d4:	79 05                	jns    8026db <write+0x5d>
		return r;
  8026d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d9:	eb 75                	jmp    802750 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	8b 40 08             	mov    0x8(%rax),%eax
  8026e2:	83 e0 03             	and    $0x3,%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	75 3a                	jne    802723 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026f0:	00 00 00 
  8026f3:	48 8b 00             	mov    (%rax),%rax
  8026f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ff:	89 c6                	mov    %eax,%esi
  802701:	48 bf 73 49 80 00 00 	movabs $0x804973,%rdi
  802708:	00 00 00 
  80270b:	b8 00 00 00 00       	mov    $0x0,%eax
  802710:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  802717:	00 00 00 
  80271a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80271c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802721:	eb 2d                	jmp    802750 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802727:	48 8b 40 18          	mov    0x18(%rax),%rax
  80272b:	48 85 c0             	test   %rax,%rax
  80272e:	75 07                	jne    802737 <write+0xb9>
		return -E_NOT_SUPP;
  802730:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802735:	eb 19                	jmp    802750 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80273f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802743:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802747:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80274b:	48 89 cf             	mov    %rcx,%rdi
  80274e:	ff d0                	callq  *%rax
}
  802750:	c9                   	leaveq 
  802751:	c3                   	retq   

0000000000802752 <seek>:

int
seek(int fdnum, off_t offset)
{
  802752:	55                   	push   %rbp
  802753:	48 89 e5             	mov    %rsp,%rbp
  802756:	48 83 ec 18          	sub    $0x18,%rsp
  80275a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80275d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802760:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802764:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802767:	48 89 d6             	mov    %rdx,%rsi
  80276a:	89 c7                	mov    %eax,%edi
  80276c:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  802773:	00 00 00 
  802776:	ff d0                	callq  *%rax
  802778:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277f:	79 05                	jns    802786 <seek+0x34>
		return r;
  802781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802784:	eb 0f                	jmp    802795 <seek+0x43>
	fd->fd_offset = offset;
  802786:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80278d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802795:	c9                   	leaveq 
  802796:	c3                   	retq   

0000000000802797 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802797:	55                   	push   %rbp
  802798:	48 89 e5             	mov    %rsp,%rbp
  80279b:	48 83 ec 30          	sub    $0x30,%rsp
  80279f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027ac:	48 89 d6             	mov    %rdx,%rsi
  8027af:	89 c7                	mov    %eax,%edi
  8027b1:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	callq  *%rax
  8027bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c4:	78 24                	js     8027ea <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ca:	8b 00                	mov    (%rax),%eax
  8027cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027d0:	48 89 d6             	mov    %rdx,%rsi
  8027d3:	89 c7                	mov    %eax,%edi
  8027d5:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e8:	79 05                	jns    8027ef <ftruncate+0x58>
		return r;
  8027ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ed:	eb 72                	jmp    802861 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f3:	8b 40 08             	mov    0x8(%rax),%eax
  8027f6:	83 e0 03             	and    $0x3,%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	75 3a                	jne    802837 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027fd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802804:	00 00 00 
  802807:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80280a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802810:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802813:	89 c6                	mov    %eax,%esi
  802815:	48 bf 90 49 80 00 00 	movabs $0x804990,%rdi
  80281c:	00 00 00 
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  80282b:	00 00 00 
  80282e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802830:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802835:	eb 2a                	jmp    802861 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802837:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80283f:	48 85 c0             	test   %rax,%rax
  802842:	75 07                	jne    80284b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802844:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802849:	eb 16                	jmp    802861 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80284b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802853:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802857:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80285a:	89 ce                	mov    %ecx,%esi
  80285c:	48 89 d7             	mov    %rdx,%rdi
  80285f:	ff d0                	callq  *%rax
}
  802861:	c9                   	leaveq 
  802862:	c3                   	retq   

0000000000802863 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802863:	55                   	push   %rbp
  802864:	48 89 e5             	mov    %rsp,%rbp
  802867:	48 83 ec 30          	sub    $0x30,%rsp
  80286b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80286e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802872:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802876:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802879:	48 89 d6             	mov    %rdx,%rsi
  80287c:	89 c7                	mov    %eax,%edi
  80287e:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802891:	78 24                	js     8028b7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802897:	8b 00                	mov    (%rax),%eax
  802899:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80289d:	48 89 d6             	mov    %rdx,%rsi
  8028a0:	89 c7                	mov    %eax,%edi
  8028a2:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  8028a9:	00 00 00 
  8028ac:	ff d0                	callq  *%rax
  8028ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b5:	79 05                	jns    8028bc <fstat+0x59>
		return r;
  8028b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ba:	eb 5e                	jmp    80291a <fstat+0xb7>
	if (!dev->dev_stat)
  8028bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028c4:	48 85 c0             	test   %rax,%rax
  8028c7:	75 07                	jne    8028d0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8028c9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028ce:	eb 4a                	jmp    80291a <fstat+0xb7>
	stat->st_name[0] = 0;
  8028d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028d4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8028d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028e2:	00 00 00 
	stat->st_isdir = 0;
  8028e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028e9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028f0:	00 00 00 
	stat->st_dev = dev;
  8028f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028fb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802902:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802906:	48 8b 40 28          	mov    0x28(%rax),%rax
  80290a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80290e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802912:	48 89 ce             	mov    %rcx,%rsi
  802915:	48 89 d7             	mov    %rdx,%rdi
  802918:	ff d0                	callq  *%rax
}
  80291a:	c9                   	leaveq 
  80291b:	c3                   	retq   

000000000080291c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80291c:	55                   	push   %rbp
  80291d:	48 89 e5             	mov    %rsp,%rbp
  802920:	48 83 ec 20          	sub    $0x20,%rsp
  802924:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802928:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80292c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802930:	be 00 00 00 00       	mov    $0x0,%esi
  802935:	48 89 c7             	mov    %rax,%rdi
  802938:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  80293f:	00 00 00 
  802942:	ff d0                	callq  *%rax
  802944:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802947:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294b:	79 05                	jns    802952 <stat+0x36>
		return fd;
  80294d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802950:	eb 2f                	jmp    802981 <stat+0x65>
	r = fstat(fd, stat);
  802952:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802959:	48 89 d6             	mov    %rdx,%rsi
  80295c:	89 c7                	mov    %eax,%edi
  80295e:	48 b8 63 28 80 00 00 	movabs $0x802863,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
  80296a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80296d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802970:	89 c7                	mov    %eax,%edi
  802972:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  802979:	00 00 00 
  80297c:	ff d0                	callq  *%rax
	return r;
  80297e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 83 ec 10          	sub    $0x10,%rsp
  80298b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80298e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802992:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802999:	00 00 00 
  80299c:	8b 00                	mov    (%rax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	75 1f                	jne    8029c1 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8029a2:	bf 01 00 00 00       	mov    $0x1,%edi
  8029a7:	48 b8 1c 42 80 00 00 	movabs $0x80421c,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
  8029b3:	89 c2                	mov    %eax,%edx
  8029b5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029bc:	00 00 00 
  8029bf:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8029c1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029c8:	00 00 00 
  8029cb:	8b 00                	mov    (%rax),%eax
  8029cd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8029d0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8029d5:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8029dc:	00 00 00 
  8029df:	89 c7                	mov    %eax,%edi
  8029e1:	48 b8 87 41 80 00 00 	movabs $0x804187,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f6:	48 89 c6             	mov    %rax,%rsi
  8029f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8029fe:	48 b8 c6 40 80 00 00 	movabs $0x8040c6,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
}
  802a0a:	c9                   	leaveq 
  802a0b:	c3                   	retq   

0000000000802a0c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a0c:	55                   	push   %rbp
  802a0d:	48 89 e5             	mov    %rsp,%rbp
  802a10:	48 83 ec 20          	sub    $0x20,%rsp
  802a14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a18:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1f:	48 89 c7             	mov    %rax,%rdi
  802a22:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a33:	7e 0a                	jle    802a3f <open+0x33>
		return -E_BAD_PATH;
  802a35:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a3a:	e9 a5 00 00 00       	jmpq   802ae4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802a3f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a43:	48 89 c7             	mov    %rax,%rdi
  802a46:	48 b8 66 20 80 00 00 	movabs $0x802066,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
  802a52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a59:	79 08                	jns    802a63 <open+0x57>
		return r;
  802a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5e:	e9 81 00 00 00       	jmpq   802ae4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a67:	48 89 c6             	mov    %rax,%rsi
  802a6a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a71:	00 00 00 
  802a74:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802a80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a87:	00 00 00 
  802a8a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a8d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a97:	48 89 c6             	mov    %rax,%rsi
  802a9a:	bf 01 00 00 00       	mov    $0x1,%edi
  802a9f:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
  802aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab2:	79 1d                	jns    802ad1 <open+0xc5>
		fd_close(fd, 0);
  802ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab8:	be 00 00 00 00       	mov    $0x0,%esi
  802abd:	48 89 c7             	mov    %rax,%rdi
  802ac0:	48 b8 8e 21 80 00 00 	movabs $0x80218e,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
		return r;
  802acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acf:	eb 13                	jmp    802ae4 <open+0xd8>
	}

	return fd2num(fd);
  802ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad5:	48 89 c7             	mov    %rax,%rdi
  802ad8:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax

}
  802ae4:	c9                   	leaveq 
  802ae5:	c3                   	retq   

0000000000802ae6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	48 83 ec 10          	sub    $0x10,%rsp
  802aee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802af2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af6:	8b 50 0c             	mov    0xc(%rax),%edx
  802af9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b00:	00 00 00 
  802b03:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b05:	be 00 00 00 00       	mov    $0x0,%esi
  802b0a:	bf 06 00 00 00       	mov    $0x6,%edi
  802b0f:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
}
  802b1b:	c9                   	leaveq 
  802b1c:	c3                   	retq   

0000000000802b1d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b1d:	55                   	push   %rbp
  802b1e:	48 89 e5             	mov    %rsp,%rbp
  802b21:	48 83 ec 30          	sub    $0x30,%rsp
  802b25:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b29:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b2d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b35:	8b 50 0c             	mov    0xc(%rax),%edx
  802b38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b3f:	00 00 00 
  802b42:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802b44:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4b:	00 00 00 
  802b4e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b52:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802b56:	be 00 00 00 00       	mov    $0x0,%esi
  802b5b:	bf 03 00 00 00       	mov    $0x3,%edi
  802b60:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
  802b6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b73:	79 08                	jns    802b7d <devfile_read+0x60>
		return r;
  802b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b78:	e9 a4 00 00 00       	jmpq   802c21 <devfile_read+0x104>
	assert(r <= n);
  802b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b80:	48 98                	cltq   
  802b82:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b86:	76 35                	jbe    802bbd <devfile_read+0xa0>
  802b88:	48 b9 b6 49 80 00 00 	movabs $0x8049b6,%rcx
  802b8f:	00 00 00 
  802b92:	48 ba bd 49 80 00 00 	movabs $0x8049bd,%rdx
  802b99:	00 00 00 
  802b9c:	be 86 00 00 00       	mov    $0x86,%esi
  802ba1:	48 bf d2 49 80 00 00 	movabs $0x8049d2,%rdi
  802ba8:	00 00 00 
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb0:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  802bb7:	00 00 00 
  802bba:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802bbd:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802bc4:	7e 35                	jle    802bfb <devfile_read+0xde>
  802bc6:	48 b9 dd 49 80 00 00 	movabs $0x8049dd,%rcx
  802bcd:	00 00 00 
  802bd0:	48 ba bd 49 80 00 00 	movabs $0x8049bd,%rdx
  802bd7:	00 00 00 
  802bda:	be 87 00 00 00       	mov    $0x87,%esi
  802bdf:	48 bf d2 49 80 00 00 	movabs $0x8049d2,%rdi
  802be6:	00 00 00 
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bee:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  802bf5:	00 00 00 
  802bf8:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfe:	48 63 d0             	movslq %eax,%rdx
  802c01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c05:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c0c:	00 00 00 
  802c0f:	48 89 c7             	mov    %rax,%rdi
  802c12:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
	return r;
  802c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802c21:	c9                   	leaveq 
  802c22:	c3                   	retq   

0000000000802c23 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c23:	55                   	push   %rbp
  802c24:	48 89 e5             	mov    %rsp,%rbp
  802c27:	48 83 ec 40          	sub    $0x40,%rsp
  802c2b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c2f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c33:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802c37:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c3f:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802c46:	00 
  802c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802c4f:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802c54:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5c:	8b 50 0c             	mov    0xc(%rax),%edx
  802c5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c66:	00 00 00 
  802c69:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802c6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c72:	00 00 00 
  802c75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c79:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802c7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c85:	48 89 c6             	mov    %rax,%rsi
  802c88:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802c8f:	00 00 00 
  802c92:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802c9e:	be 00 00 00 00       	mov    $0x0,%esi
  802ca3:	bf 04 00 00 00       	mov    $0x4,%edi
  802ca8:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
  802cb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cbb:	79 05                	jns    802cc2 <devfile_write+0x9f>
		return r;
  802cbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc0:	eb 43                	jmp    802d05 <devfile_write+0xe2>
	assert(r <= n);
  802cc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc5:	48 98                	cltq   
  802cc7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ccb:	76 35                	jbe    802d02 <devfile_write+0xdf>
  802ccd:	48 b9 b6 49 80 00 00 	movabs $0x8049b6,%rcx
  802cd4:	00 00 00 
  802cd7:	48 ba bd 49 80 00 00 	movabs $0x8049bd,%rdx
  802cde:	00 00 00 
  802ce1:	be a2 00 00 00       	mov    $0xa2,%esi
  802ce6:	48 bf d2 49 80 00 00 	movabs $0x8049d2,%rdi
  802ced:	00 00 00 
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  802cfc:	00 00 00 
  802cff:	41 ff d0             	callq  *%r8
	return r;
  802d02:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802d05:	c9                   	leaveq 
  802d06:	c3                   	retq   

0000000000802d07 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d07:	55                   	push   %rbp
  802d08:	48 89 e5             	mov    %rsp,%rbp
  802d0b:	48 83 ec 20          	sub    $0x20,%rsp
  802d0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d25:	00 00 00 
  802d28:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d2a:	be 00 00 00 00       	mov    $0x0,%esi
  802d2f:	bf 05 00 00 00       	mov    $0x5,%edi
  802d34:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802d3b:	00 00 00 
  802d3e:	ff d0                	callq  *%rax
  802d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d47:	79 05                	jns    802d4e <devfile_stat+0x47>
		return r;
  802d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4c:	eb 56                	jmp    802da4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d52:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d59:	00 00 00 
  802d5c:	48 89 c7             	mov    %rax,%rdi
  802d5f:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d72:	00 00 00 
  802d75:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d85:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d8c:	00 00 00 
  802d8f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d99:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da4:	c9                   	leaveq 
  802da5:	c3                   	retq   

0000000000802da6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802da6:	55                   	push   %rbp
  802da7:	48 89 e5             	mov    %rsp,%rbp
  802daa:	48 83 ec 10          	sub    $0x10,%rsp
  802dae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802db2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db9:	8b 50 0c             	mov    0xc(%rax),%edx
  802dbc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc3:	00 00 00 
  802dc6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802dc8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dcf:	00 00 00 
  802dd2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802dd5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802dd8:	be 00 00 00 00       	mov    $0x0,%esi
  802ddd:	bf 02 00 00 00       	mov    $0x2,%edi
  802de2:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
}
  802dee:	c9                   	leaveq 
  802def:	c3                   	retq   

0000000000802df0 <remove>:

// Delete a file
int
remove(const char *path)
{
  802df0:	55                   	push   %rbp
  802df1:	48 89 e5             	mov    %rsp,%rbp
  802df4:	48 83 ec 10          	sub    $0x10,%rsp
  802df8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e00:	48 89 c7             	mov    %rax,%rdi
  802e03:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
  802e0f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e14:	7e 07                	jle    802e1d <remove+0x2d>
		return -E_BAD_PATH;
  802e16:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e1b:	eb 33                	jmp    802e50 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e21:	48 89 c6             	mov    %rax,%rsi
  802e24:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e2b:	00 00 00 
  802e2e:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802e35:	00 00 00 
  802e38:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e3a:	be 00 00 00 00       	mov    $0x0,%esi
  802e3f:	bf 07 00 00 00       	mov    $0x7,%edi
  802e44:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802e56:	be 00 00 00 00       	mov    $0x0,%esi
  802e5b:	bf 08 00 00 00       	mov    $0x8,%edi
  802e60:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802e67:	00 00 00 
  802e6a:	ff d0                	callq  *%rax
}
  802e6c:	5d                   	pop    %rbp
  802e6d:	c3                   	retq   

0000000000802e6e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e79:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e80:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e87:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802e8e:	be 00 00 00 00       	mov    $0x0,%esi
  802e93:	48 89 c7             	mov    %rax,%rdi
  802e96:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
  802ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea9:	79 28                	jns    802ed3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	89 c6                	mov    %eax,%esi
  802eb0:	48 bf e9 49 80 00 00 	movabs $0x8049e9,%rdi
  802eb7:	00 00 00 
  802eba:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebf:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802ec6:	00 00 00 
  802ec9:	ff d2                	callq  *%rdx
		return fd_src;
  802ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ece:	e9 76 01 00 00       	jmpq   803049 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ed3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802eda:	be 01 01 00 00       	mov    $0x101,%esi
  802edf:	48 89 c7             	mov    %rax,%rdi
  802ee2:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
  802eee:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ef1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ef5:	0f 89 ad 00 00 00    	jns    802fa8 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802efb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802efe:	89 c6                	mov    %eax,%esi
  802f00:	48 bf ff 49 80 00 00 	movabs $0x8049ff,%rdi
  802f07:	00 00 00 
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802f16:	00 00 00 
  802f19:	ff d2                	callq  *%rdx
		close(fd_src);
  802f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1e:	89 c7                	mov    %eax,%edi
  802f20:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  802f27:	00 00 00 
  802f2a:	ff d0                	callq  *%rax
		return fd_dest;
  802f2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f2f:	e9 15 01 00 00       	jmpq   803049 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802f34:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f37:	48 63 d0             	movslq %eax,%rdx
  802f3a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f44:	48 89 ce             	mov    %rcx,%rsi
  802f47:	89 c7                	mov    %eax,%edi
  802f49:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
  802f55:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802f58:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f5c:	79 4a                	jns    802fa8 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802f5e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f61:	89 c6                	mov    %eax,%esi
  802f63:	48 bf 19 4a 80 00 00 	movabs $0x804a19,%rdi
  802f6a:	00 00 00 
  802f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f72:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802f79:	00 00 00 
  802f7c:	ff d2                	callq  *%rdx
			close(fd_src);
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f81:	89 c7                	mov    %eax,%edi
  802f83:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
			close(fd_dest);
  802f8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f92:	89 c7                	mov    %eax,%edi
  802f94:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
			return write_size;
  802fa0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fa3:	e9 a1 00 00 00       	jmpq   803049 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fa8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb2:	ba 00 02 00 00       	mov    $0x200,%edx
  802fb7:	48 89 ce             	mov    %rcx,%rsi
  802fba:	89 c7                	mov    %eax,%edi
  802fbc:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
  802fc8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fcf:	0f 8f 5f ff ff ff    	jg     802f34 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802fd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fd9:	79 47                	jns    803022 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802fdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fde:	89 c6                	mov    %eax,%esi
  802fe0:	48 bf 2c 4a 80 00 00 	movabs $0x804a2c,%rdi
  802fe7:	00 00 00 
  802fea:	b8 00 00 00 00       	mov    $0x0,%eax
  802fef:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802ff6:	00 00 00 
  802ff9:	ff d2                	callq  *%rdx
		close(fd_src);
  802ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffe:	89 c7                	mov    %eax,%edi
  803000:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
		close(fd_dest);
  80300c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
		return read_size;
  80301d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803020:	eb 27                	jmp    803049 <copy+0x1db>
	}
	close(fd_src);
  803022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803025:	89 c7                	mov    %eax,%edi
  803027:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
	close(fd_dest);
  803033:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803036:	89 c7                	mov    %eax,%edi
  803038:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
	return 0;
  803044:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803049:	c9                   	leaveq 
  80304a:	c3                   	retq   

000000000080304b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80304b:	55                   	push   %rbp
  80304c:	48 89 e5             	mov    %rsp,%rbp
  80304f:	48 83 ec 20          	sub    $0x20,%rsp
  803053:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803056:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80305a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305d:	48 89 d6             	mov    %rdx,%rsi
  803060:	89 c7                	mov    %eax,%edi
  803062:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803075:	79 05                	jns    80307c <fd2sockid+0x31>
		return r;
  803077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307a:	eb 24                	jmp    8030a0 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80307c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803080:	8b 10                	mov    (%rax),%edx
  803082:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803089:	00 00 00 
  80308c:	8b 00                	mov    (%rax),%eax
  80308e:	39 c2                	cmp    %eax,%edx
  803090:	74 07                	je     803099 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803092:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803097:	eb 07                	jmp    8030a0 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
  8030a6:	48 83 ec 20          	sub    $0x20,%rsp
  8030aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030ad:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 66 20 80 00 00 	movabs $0x802066,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c7:	78 26                	js     8030ef <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8030c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8030d2:	48 89 c6             	mov    %rax,%rsi
  8030d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030da:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ed:	79 16                	jns    803105 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8030ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f2:	89 c7                	mov    %eax,%edi
  8030f4:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  8030fb:	00 00 00 
  8030fe:	ff d0                	callq  *%rax
		return r;
  803100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803103:	eb 3a                	jmp    80313f <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803109:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803110:	00 00 00 
  803113:	8b 12                	mov    (%rdx),%edx
  803115:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803126:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803129:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80312c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803130:	48 89 c7             	mov    %rax,%rdi
  803133:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
}
  80313f:	c9                   	leaveq 
  803140:	c3                   	retq   

0000000000803141 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803141:	55                   	push   %rbp
  803142:	48 89 e5             	mov    %rsp,%rbp
  803145:	48 83 ec 30          	sub    $0x30,%rsp
  803149:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80314c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803150:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803154:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803157:	89 c7                	mov    %eax,%edi
  803159:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316c:	79 05                	jns    803173 <accept+0x32>
		return r;
  80316e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803171:	eb 3b                	jmp    8031ae <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803173:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803177:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80317b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317e:	48 89 ce             	mov    %rcx,%rsi
  803181:	89 c7                	mov    %eax,%edi
  803183:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
  80318f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803196:	79 05                	jns    80319d <accept+0x5c>
		return r;
  803198:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319b:	eb 11                	jmp    8031ae <accept+0x6d>
	return alloc_sockfd(r);
  80319d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a0:	89 c7                	mov    %eax,%edi
  8031a2:	48 b8 a2 30 80 00 00 	movabs $0x8030a2,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 20          	sub    $0x20,%rsp
  8031b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031bf:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c5:	89 c7                	mov    %eax,%edi
  8031c7:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
  8031d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031da:	79 05                	jns    8031e1 <bind+0x31>
		return r;
  8031dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031df:	eb 1b                	jmp    8031fc <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8031e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031e4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031eb:	48 89 ce             	mov    %rcx,%rsi
  8031ee:	89 c7                	mov    %eax,%edi
  8031f0:	48 b8 0d 35 80 00 00 	movabs $0x80350d,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
}
  8031fc:	c9                   	leaveq 
  8031fd:	c3                   	retq   

00000000008031fe <shutdown>:

int
shutdown(int s, int how)
{
  8031fe:	55                   	push   %rbp
  8031ff:	48 89 e5             	mov    %rsp,%rbp
  803202:	48 83 ec 20          	sub    $0x20,%rsp
  803206:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803209:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80320c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320f:	89 c7                	mov    %eax,%edi
  803211:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  803218:	00 00 00 
  80321b:	ff d0                	callq  *%rax
  80321d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803220:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803224:	79 05                	jns    80322b <shutdown+0x2d>
		return r;
  803226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803229:	eb 16                	jmp    803241 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80322b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80322e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803231:	89 d6                	mov    %edx,%esi
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 71 35 80 00 00 	movabs $0x803571,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
}
  803241:	c9                   	leaveq 
  803242:	c3                   	retq   

0000000000803243 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803243:	55                   	push   %rbp
  803244:	48 89 e5             	mov    %rsp,%rbp
  803247:	48 83 ec 10          	sub    $0x10,%rsp
  80324b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80324f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 8d 42 80 00 00 	movabs $0x80428d,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
  803262:	83 f8 01             	cmp    $0x1,%eax
  803265:	75 17                	jne    80327e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326b:	8b 40 0c             	mov    0xc(%rax),%eax
  80326e:	89 c7                	mov    %eax,%edi
  803270:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	eb 05                	jmp    803283 <devsock_close+0x40>
	else
		return 0;
  80327e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803283:	c9                   	leaveq 
  803284:	c3                   	retq   

0000000000803285 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803285:	55                   	push   %rbp
  803286:	48 89 e5             	mov    %rsp,%rbp
  803289:	48 83 ec 20          	sub    $0x20,%rsp
  80328d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803290:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803294:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803297:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329a:	89 c7                	mov    %eax,%edi
  80329c:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
  8032a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032af:	79 05                	jns    8032b6 <connect+0x31>
		return r;
  8032b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b4:	eb 1b                	jmp    8032d1 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8032b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032b9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c0:	48 89 ce             	mov    %rcx,%rsi
  8032c3:	89 c7                	mov    %eax,%edi
  8032c5:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax
}
  8032d1:	c9                   	leaveq 
  8032d2:	c3                   	retq   

00000000008032d3 <listen>:

int
listen(int s, int backlog)
{
  8032d3:	55                   	push   %rbp
  8032d4:	48 89 e5             	mov    %rsp,%rbp
  8032d7:	48 83 ec 20          	sub    $0x20,%rsp
  8032db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032de:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e4:	89 c7                	mov    %eax,%edi
  8032e6:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f9:	79 05                	jns    803300 <listen+0x2d>
		return r;
  8032fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fe:	eb 16                	jmp    803316 <listen+0x43>
	return nsipc_listen(r, backlog);
  803300:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803306:	89 d6                	mov    %edx,%esi
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 42 36 80 00 00 	movabs $0x803642,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
}
  803316:	c9                   	leaveq 
  803317:	c3                   	retq   

0000000000803318 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803318:	55                   	push   %rbp
  803319:	48 89 e5             	mov    %rsp,%rbp
  80331c:	48 83 ec 20          	sub    $0x20,%rsp
  803320:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803328:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80332c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803330:	89 c2                	mov    %eax,%edx
  803332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803336:	8b 40 0c             	mov    0xc(%rax),%eax
  803339:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80333d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803342:	89 c7                	mov    %eax,%edi
  803344:	48 b8 82 36 80 00 00 	movabs $0x803682,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
}
  803350:	c9                   	leaveq 
  803351:	c3                   	retq   

0000000000803352 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803352:	55                   	push   %rbp
  803353:	48 89 e5             	mov    %rsp,%rbp
  803356:	48 83 ec 20          	sub    $0x20,%rsp
  80335a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80335e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803362:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80336a:	89 c2                	mov    %eax,%edx
  80336c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803370:	8b 40 0c             	mov    0xc(%rax),%eax
  803373:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803377:	b9 00 00 00 00       	mov    $0x0,%ecx
  80337c:	89 c7                	mov    %eax,%edi
  80337e:	48 b8 4e 37 80 00 00 	movabs $0x80374e,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
}
  80338a:	c9                   	leaveq 
  80338b:	c3                   	retq   

000000000080338c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80338c:	55                   	push   %rbp
  80338d:	48 89 e5             	mov    %rsp,%rbp
  803390:	48 83 ec 10          	sub    $0x10,%rsp
  803394:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80339c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a0:	48 be 47 4a 80 00 00 	movabs $0x804a47,%rsi
  8033a7:	00 00 00 
  8033aa:	48 89 c7             	mov    %rax,%rdi
  8033ad:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
	return 0;
  8033b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033be:	c9                   	leaveq 
  8033bf:	c3                   	retq   

00000000008033c0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	48 83 ec 20          	sub    $0x20,%rsp
  8033c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033ce:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033d1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033d4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033da:	89 ce                	mov    %ecx,%esi
  8033dc:	89 c7                	mov    %eax,%edi
  8033de:	48 b8 06 38 80 00 00 	movabs $0x803806,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f1:	79 05                	jns    8033f8 <socket+0x38>
		return r;
  8033f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f6:	eb 11                	jmp    803409 <socket+0x49>
	return alloc_sockfd(r);
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	89 c7                	mov    %eax,%edi
  8033fd:	48 b8 a2 30 80 00 00 	movabs $0x8030a2,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
}
  803409:	c9                   	leaveq 
  80340a:	c3                   	retq   

000000000080340b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80340b:	55                   	push   %rbp
  80340c:	48 89 e5             	mov    %rsp,%rbp
  80340f:	48 83 ec 10          	sub    $0x10,%rsp
  803413:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803416:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80341d:	00 00 00 
  803420:	8b 00                	mov    (%rax),%eax
  803422:	85 c0                	test   %eax,%eax
  803424:	75 1f                	jne    803445 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803426:	bf 02 00 00 00       	mov    $0x2,%edi
  80342b:	48 b8 1c 42 80 00 00 	movabs $0x80421c,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
  803437:	89 c2                	mov    %eax,%edx
  803439:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803440:	00 00 00 
  803443:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803445:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80344c:	00 00 00 
  80344f:	8b 00                	mov    (%rax),%eax
  803451:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803454:	b9 07 00 00 00       	mov    $0x7,%ecx
  803459:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803460:	00 00 00 
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 87 41 80 00 00 	movabs $0x804187,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803471:	ba 00 00 00 00       	mov    $0x0,%edx
  803476:	be 00 00 00 00       	mov    $0x0,%esi
  80347b:	bf 00 00 00 00       	mov    $0x0,%edi
  803480:	48 b8 c6 40 80 00 00 	movabs $0x8040c6,%rax
  803487:	00 00 00 
  80348a:	ff d0                	callq  *%rax
}
  80348c:	c9                   	leaveq 
  80348d:	c3                   	retq   

000000000080348e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80348e:	55                   	push   %rbp
  80348f:	48 89 e5             	mov    %rsp,%rbp
  803492:	48 83 ec 30          	sub    $0x30,%rsp
  803496:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803499:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80349d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8034a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a8:	00 00 00 
  8034ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ae:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8034b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8034b5:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
  8034c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c8:	78 3e                	js     803508 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8034ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d1:	00 00 00 
  8034d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034dc:	8b 40 10             	mov    0x10(%rax),%eax
  8034df:	89 c2                	mov    %eax,%edx
  8034e1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e9:	48 89 ce             	mov    %rcx,%rsi
  8034ec:	48 89 c7             	mov    %rax,%rdi
  8034ef:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8034fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ff:	8b 50 10             	mov    0x10(%rax),%edx
  803502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803506:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803508:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80350b:	c9                   	leaveq 
  80350c:	c3                   	retq   

000000000080350d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80350d:	55                   	push   %rbp
  80350e:	48 89 e5             	mov    %rsp,%rbp
  803511:	48 83 ec 10          	sub    $0x10,%rsp
  803515:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803518:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80351c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80351f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803526:	00 00 00 
  803529:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80352c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80352e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803535:	48 89 c6             	mov    %rax,%rsi
  803538:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80353f:	00 00 00 
  803542:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  803549:	00 00 00 
  80354c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80354e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803555:	00 00 00 
  803558:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80355b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80355e:	bf 02 00 00 00       	mov    $0x2,%edi
  803563:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
}
  80356f:	c9                   	leaveq 
  803570:	c3                   	retq   

0000000000803571 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803571:	55                   	push   %rbp
  803572:	48 89 e5             	mov    %rsp,%rbp
  803575:	48 83 ec 10          	sub    $0x10,%rsp
  803579:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80357c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80357f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803586:	00 00 00 
  803589:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80358c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80358e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803595:	00 00 00 
  803598:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80359e:	bf 03 00 00 00       	mov    $0x3,%edi
  8035a3:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
}
  8035af:	c9                   	leaveq 
  8035b0:	c3                   	retq   

00000000008035b1 <nsipc_close>:

int
nsipc_close(int s)
{
  8035b1:	55                   	push   %rbp
  8035b2:	48 89 e5             	mov    %rsp,%rbp
  8035b5:	48 83 ec 10          	sub    $0x10,%rsp
  8035b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8035bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035c3:	00 00 00 
  8035c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035c9:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8035cb:	bf 04 00 00 00       	mov    $0x4,%edi
  8035d0:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
}
  8035dc:	c9                   	leaveq 
  8035dd:	c3                   	retq   

00000000008035de <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035de:	55                   	push   %rbp
  8035df:	48 89 e5             	mov    %rsp,%rbp
  8035e2:	48 83 ec 10          	sub    $0x10,%rsp
  8035e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ed:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8035f0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f7:	00 00 00 
  8035fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035fd:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8035ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803606:	48 89 c6             	mov    %rax,%rsi
  803609:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803610:	00 00 00 
  803613:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  80361a:	00 00 00 
  80361d:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80361f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803626:	00 00 00 
  803629:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80362c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80362f:	bf 05 00 00 00       	mov    $0x5,%edi
  803634:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  80363b:	00 00 00 
  80363e:	ff d0                	callq  *%rax
}
  803640:	c9                   	leaveq 
  803641:	c3                   	retq   

0000000000803642 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803642:	55                   	push   %rbp
  803643:	48 89 e5             	mov    %rsp,%rbp
  803646:	48 83 ec 10          	sub    $0x10,%rsp
  80364a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80364d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803650:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803657:	00 00 00 
  80365a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80365d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80365f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803666:	00 00 00 
  803669:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80366c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80366f:	bf 06 00 00 00       	mov    $0x6,%edi
  803674:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
}
  803680:	c9                   	leaveq 
  803681:	c3                   	retq   

0000000000803682 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803682:	55                   	push   %rbp
  803683:	48 89 e5             	mov    %rsp,%rbp
  803686:	48 83 ec 30          	sub    $0x30,%rsp
  80368a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803691:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803694:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803697:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80369e:	00 00 00 
  8036a1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036a4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8036a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ad:	00 00 00 
  8036b0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036b3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8036b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bd:	00 00 00 
  8036c0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8036c3:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8036c6:	bf 07 00 00 00       	mov    $0x7,%edi
  8036cb:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
  8036d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036de:	78 69                	js     803749 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8036e0:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8036e7:	7f 08                	jg     8036f1 <nsipc_recv+0x6f>
  8036e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ec:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8036ef:	7e 35                	jle    803726 <nsipc_recv+0xa4>
  8036f1:	48 b9 4e 4a 80 00 00 	movabs $0x804a4e,%rcx
  8036f8:	00 00 00 
  8036fb:	48 ba 63 4a 80 00 00 	movabs $0x804a63,%rdx
  803702:	00 00 00 
  803705:	be 62 00 00 00       	mov    $0x62,%esi
  80370a:	48 bf 78 4a 80 00 00 	movabs $0x804a78,%rdi
  803711:	00 00 00 
  803714:	b8 00 00 00 00       	mov    $0x0,%eax
  803719:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  803720:	00 00 00 
  803723:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803729:	48 63 d0             	movslq %eax,%rdx
  80372c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803730:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803737:	00 00 00 
  80373a:	48 89 c7             	mov    %rax,%rdi
  80373d:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
	}

	return r;
  803749:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80374c:	c9                   	leaveq 
  80374d:	c3                   	retq   

000000000080374e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80374e:	55                   	push   %rbp
  80374f:	48 89 e5             	mov    %rsp,%rbp
  803752:	48 83 ec 20          	sub    $0x20,%rsp
  803756:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803759:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80375d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803760:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803763:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376a:	00 00 00 
  80376d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803770:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803772:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803779:	7e 35                	jle    8037b0 <nsipc_send+0x62>
  80377b:	48 b9 84 4a 80 00 00 	movabs $0x804a84,%rcx
  803782:	00 00 00 
  803785:	48 ba 63 4a 80 00 00 	movabs $0x804a63,%rdx
  80378c:	00 00 00 
  80378f:	be 6d 00 00 00       	mov    $0x6d,%esi
  803794:	48 bf 78 4a 80 00 00 	movabs $0x804a78,%rdi
  80379b:	00 00 00 
  80379e:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a3:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8037aa:	00 00 00 
  8037ad:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8037b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037b3:	48 63 d0             	movslq %eax,%rdx
  8037b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ba:	48 89 c6             	mov    %rax,%rsi
  8037bd:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8037c4:	00 00 00 
  8037c7:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8037d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037da:	00 00 00 
  8037dd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037e0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8037e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ea:	00 00 00 
  8037ed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037f0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8037f3:	bf 08 00 00 00       	mov    $0x8,%edi
  8037f8:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
}
  803804:	c9                   	leaveq 
  803805:	c3                   	retq   

0000000000803806 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803806:	55                   	push   %rbp
  803807:	48 89 e5             	mov    %rsp,%rbp
  80380a:	48 83 ec 10          	sub    $0x10,%rsp
  80380e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803811:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803814:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803817:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80381e:	00 00 00 
  803821:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803824:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803826:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382d:	00 00 00 
  803830:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803833:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803836:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80383d:	00 00 00 
  803840:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803843:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803846:	bf 09 00 00 00       	mov    $0x9,%edi
  80384b:	48 b8 0b 34 80 00 00 	movabs $0x80340b,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
}
  803857:	c9                   	leaveq 
  803858:	c3                   	retq   

0000000000803859 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803859:	55                   	push   %rbp
  80385a:	48 89 e5             	mov    %rsp,%rbp
  80385d:	53                   	push   %rbx
  80385e:	48 83 ec 38          	sub    $0x38,%rsp
  803862:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803866:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80386a:	48 89 c7             	mov    %rax,%rdi
  80386d:	48 b8 66 20 80 00 00 	movabs $0x802066,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
  803879:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80387c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803880:	0f 88 bf 01 00 00    	js     803a45 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388a:	ba 07 04 00 00       	mov    $0x407,%edx
  80388f:	48 89 c6             	mov    %rax,%rsi
  803892:	bf 00 00 00 00       	mov    $0x0,%edi
  803897:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  80389e:	00 00 00 
  8038a1:	ff d0                	callq  *%rax
  8038a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038aa:	0f 88 95 01 00 00    	js     803a45 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038b4:	48 89 c7             	mov    %rax,%rdi
  8038b7:	48 b8 66 20 80 00 00 	movabs $0x802066,%rax
  8038be:	00 00 00 
  8038c1:	ff d0                	callq  *%rax
  8038c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038ca:	0f 88 5d 01 00 00    	js     803a2d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d4:	ba 07 04 00 00       	mov    $0x407,%edx
  8038d9:	48 89 c6             	mov    %rax,%rsi
  8038dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e1:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  8038e8:	00 00 00 
  8038eb:	ff d0                	callq  *%rax
  8038ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038f4:	0f 88 33 01 00 00    	js     803a2d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038fe:	48 89 c7             	mov    %rax,%rdi
  803901:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803908:	00 00 00 
  80390b:	ff d0                	callq  *%rax
  80390d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803911:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803915:	ba 07 04 00 00       	mov    $0x407,%edx
  80391a:	48 89 c6             	mov    %rax,%rsi
  80391d:	bf 00 00 00 00       	mov    $0x0,%edi
  803922:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803931:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803935:	0f 88 d9 00 00 00    	js     803a14 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80393b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393f:	48 89 c7             	mov    %rax,%rdi
  803942:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
  80394e:	48 89 c2             	mov    %rax,%rdx
  803951:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803955:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80395b:	48 89 d1             	mov    %rdx,%rcx
  80395e:	ba 00 00 00 00       	mov    $0x0,%edx
  803963:	48 89 c6             	mov    %rax,%rsi
  803966:	bf 00 00 00 00       	mov    $0x0,%edi
  80396b:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80397a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80397e:	78 79                	js     8039f9 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803984:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80398b:	00 00 00 
  80398e:	8b 12                	mov    (%rdx),%edx
  803990:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803996:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80399d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039a8:	00 00 00 
  8039ab:	8b 12                	mov    (%rdx),%edx
  8039ad:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039be:	48 89 c7             	mov    %rax,%rdi
  8039c1:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  8039c8:	00 00 00 
  8039cb:	ff d0                	callq  *%rax
  8039cd:	89 c2                	mov    %eax,%edx
  8039cf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039d3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039d9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e1:	48 89 c7             	mov    %rax,%rdi
  8039e4:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
  8039f0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8039f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f7:	eb 4f                	jmp    803a48 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8039f9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8039fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039fe:	48 89 c6             	mov    %rax,%rsi
  803a01:	bf 00 00 00 00       	mov    $0x0,%edi
  803a06:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803a0d:	00 00 00 
  803a10:	ff d0                	callq  *%rax
  803a12:	eb 01                	jmp    803a15 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803a14:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a19:	48 89 c6             	mov    %rax,%rsi
  803a1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803a21:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803a28:	00 00 00 
  803a2b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a31:	48 89 c6             	mov    %rax,%rsi
  803a34:	bf 00 00 00 00       	mov    $0x0,%edi
  803a39:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
err:
	return r;
  803a45:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a48:	48 83 c4 38          	add    $0x38,%rsp
  803a4c:	5b                   	pop    %rbx
  803a4d:	5d                   	pop    %rbp
  803a4e:	c3                   	retq   

0000000000803a4f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a4f:	55                   	push   %rbp
  803a50:	48 89 e5             	mov    %rsp,%rbp
  803a53:	53                   	push   %rbx
  803a54:	48 83 ec 28          	sub    $0x28,%rsp
  803a58:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a5c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a60:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a67:	00 00 00 
  803a6a:	48 8b 00             	mov    (%rax),%rax
  803a6d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a73:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a7a:	48 89 c7             	mov    %rax,%rdi
  803a7d:	48 b8 8d 42 80 00 00 	movabs $0x80428d,%rax
  803a84:	00 00 00 
  803a87:	ff d0                	callq  *%rax
  803a89:	89 c3                	mov    %eax,%ebx
  803a8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8f:	48 89 c7             	mov    %rax,%rdi
  803a92:	48 b8 8d 42 80 00 00 	movabs $0x80428d,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
  803a9e:	39 c3                	cmp    %eax,%ebx
  803aa0:	0f 94 c0             	sete   %al
  803aa3:	0f b6 c0             	movzbl %al,%eax
  803aa6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803aa9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ab0:	00 00 00 
  803ab3:	48 8b 00             	mov    (%rax),%rax
  803ab6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803abc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803abf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ac5:	75 05                	jne    803acc <_pipeisclosed+0x7d>
			return ret;
  803ac7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803aca:	eb 4a                	jmp    803b16 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803acc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803acf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ad2:	74 8c                	je     803a60 <_pipeisclosed+0x11>
  803ad4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ad8:	75 86                	jne    803a60 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ada:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ae1:	00 00 00 
  803ae4:	48 8b 00             	mov    (%rax),%rax
  803ae7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803aed:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803af0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af3:	89 c6                	mov    %eax,%esi
  803af5:	48 bf 95 4a 80 00 00 	movabs $0x804a95,%rdi
  803afc:	00 00 00 
  803aff:	b8 00 00 00 00       	mov    $0x0,%eax
  803b04:	49 b8 5a 06 80 00 00 	movabs $0x80065a,%r8
  803b0b:	00 00 00 
  803b0e:	41 ff d0             	callq  *%r8
	}
  803b11:	e9 4a ff ff ff       	jmpq   803a60 <_pipeisclosed+0x11>

}
  803b16:	48 83 c4 28          	add    $0x28,%rsp
  803b1a:	5b                   	pop    %rbx
  803b1b:	5d                   	pop    %rbp
  803b1c:	c3                   	retq   

0000000000803b1d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b1d:	55                   	push   %rbp
  803b1e:	48 89 e5             	mov    %rsp,%rbp
  803b21:	48 83 ec 30          	sub    $0x30,%rsp
  803b25:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b2f:	48 89 d6             	mov    %rdx,%rsi
  803b32:	89 c7                	mov    %eax,%edi
  803b34:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
  803b40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b47:	79 05                	jns    803b4e <pipeisclosed+0x31>
		return r;
  803b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4c:	eb 31                	jmp    803b7f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b52:	48 89 c7             	mov    %rax,%rdi
  803b55:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
  803b61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b6d:	48 89 d6             	mov    %rdx,%rsi
  803b70:	48 89 c7             	mov    %rax,%rdi
  803b73:	48 b8 4f 3a 80 00 00 	movabs $0x803a4f,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax
}
  803b7f:	c9                   	leaveq 
  803b80:	c3                   	retq   

0000000000803b81 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b81:	55                   	push   %rbp
  803b82:	48 89 e5             	mov    %rsp,%rbp
  803b85:	48 83 ec 40          	sub    $0x40,%rsp
  803b89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b99:	48 89 c7             	mov    %rax,%rdi
  803b9c:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
  803ba8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bb4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bbb:	00 
  803bbc:	e9 90 00 00 00       	jmpq   803c51 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bc1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bc6:	74 09                	je     803bd1 <devpipe_read+0x50>
				return i;
  803bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcc:	e9 8e 00 00 00       	jmpq   803c5f <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803bd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd9:	48 89 d6             	mov    %rdx,%rsi
  803bdc:	48 89 c7             	mov    %rax,%rdi
  803bdf:	48 b8 4f 3a 80 00 00 	movabs $0x803a4f,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
  803beb:	85 c0                	test   %eax,%eax
  803bed:	74 07                	je     803bf6 <devpipe_read+0x75>
				return 0;
  803bef:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf4:	eb 69                	jmp    803c5f <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803bf6:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803bfd:	00 00 00 
  803c00:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c06:	8b 10                	mov    (%rax),%edx
  803c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0c:	8b 40 04             	mov    0x4(%rax),%eax
  803c0f:	39 c2                	cmp    %eax,%edx
  803c11:	74 ae                	je     803bc1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c23:	8b 00                	mov    (%rax),%eax
  803c25:	99                   	cltd   
  803c26:	c1 ea 1b             	shr    $0x1b,%edx
  803c29:	01 d0                	add    %edx,%eax
  803c2b:	83 e0 1f             	and    $0x1f,%eax
  803c2e:	29 d0                	sub    %edx,%eax
  803c30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c34:	48 98                	cltq   
  803c36:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c3b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c41:	8b 00                	mov    (%rax),%eax
  803c43:	8d 50 01             	lea    0x1(%rax),%edx
  803c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c4c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c55:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c59:	72 a7                	jb     803c02 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803c5f:	c9                   	leaveq 
  803c60:	c3                   	retq   

0000000000803c61 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c61:	55                   	push   %rbp
  803c62:	48 89 e5             	mov    %rsp,%rbp
  803c65:	48 83 ec 40          	sub    $0x40,%rsp
  803c69:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c71:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c79:	48 89 c7             	mov    %rax,%rdi
  803c7c:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803c83:	00 00 00 
  803c86:	ff d0                	callq  *%rax
  803c88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c94:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c9b:	00 
  803c9c:	e9 8f 00 00 00       	jmpq   803d30 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ca1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ca5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca9:	48 89 d6             	mov    %rdx,%rsi
  803cac:	48 89 c7             	mov    %rax,%rdi
  803caf:	48 b8 4f 3a 80 00 00 	movabs $0x803a4f,%rax
  803cb6:	00 00 00 
  803cb9:	ff d0                	callq  *%rax
  803cbb:	85 c0                	test   %eax,%eax
  803cbd:	74 07                	je     803cc6 <devpipe_write+0x65>
				return 0;
  803cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc4:	eb 78                	jmp    803d3e <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cc6:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803ccd:	00 00 00 
  803cd0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd6:	8b 40 04             	mov    0x4(%rax),%eax
  803cd9:	48 63 d0             	movslq %eax,%rdx
  803cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce0:	8b 00                	mov    (%rax),%eax
  803ce2:	48 98                	cltq   
  803ce4:	48 83 c0 20          	add    $0x20,%rax
  803ce8:	48 39 c2             	cmp    %rax,%rdx
  803ceb:	73 b4                	jae    803ca1 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf1:	8b 40 04             	mov    0x4(%rax),%eax
  803cf4:	99                   	cltd   
  803cf5:	c1 ea 1b             	shr    $0x1b,%edx
  803cf8:	01 d0                	add    %edx,%eax
  803cfa:	83 e0 1f             	and    $0x1f,%eax
  803cfd:	29 d0                	sub    %edx,%eax
  803cff:	89 c6                	mov    %eax,%esi
  803d01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d09:	48 01 d0             	add    %rdx,%rax
  803d0c:	0f b6 08             	movzbl (%rax),%ecx
  803d0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d13:	48 63 c6             	movslq %esi,%rax
  803d16:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1e:	8b 40 04             	mov    0x4(%rax),%eax
  803d21:	8d 50 01             	lea    0x1(%rax),%edx
  803d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d28:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d2b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d34:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d38:	72 98                	jb     803cd2 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803d3e:	c9                   	leaveq 
  803d3f:	c3                   	retq   

0000000000803d40 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d40:	55                   	push   %rbp
  803d41:	48 89 e5             	mov    %rsp,%rbp
  803d44:	48 83 ec 20          	sub    $0x20,%rsp
  803d48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d54:	48 89 c7             	mov    %rax,%rdi
  803d57:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803d5e:	00 00 00 
  803d61:	ff d0                	callq  *%rax
  803d63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d6b:	48 be a8 4a 80 00 00 	movabs $0x804aa8,%rsi
  803d72:	00 00 00 
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d88:	8b 50 04             	mov    0x4(%rax),%edx
  803d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d8f:	8b 00                	mov    (%rax),%eax
  803d91:	29 c2                	sub    %eax,%edx
  803d93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d97:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803da8:	00 00 00 
	stat->st_dev = &devpipe;
  803dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803daf:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803db6:	00 00 00 
  803db9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dc5:	c9                   	leaveq 
  803dc6:	c3                   	retq   

0000000000803dc7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803dc7:	55                   	push   %rbp
  803dc8:	48 89 e5             	mov    %rsp,%rbp
  803dcb:	48 83 ec 10          	sub    $0x10,%rsp
  803dcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803dd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd7:	48 89 c6             	mov    %rax,%rsi
  803dda:	bf 00 00 00 00       	mov    $0x0,%edi
  803ddf:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803de6:	00 00 00 
  803de9:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803def:	48 89 c7             	mov    %rax,%rdi
  803df2:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  803df9:	00 00 00 
  803dfc:	ff d0                	callq  *%rax
  803dfe:	48 89 c6             	mov    %rax,%rsi
  803e01:	bf 00 00 00 00       	mov    $0x0,%edi
  803e06:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803e0d:	00 00 00 
  803e10:	ff d0                	callq  *%rax
}
  803e12:	c9                   	leaveq 
  803e13:	c3                   	retq   

0000000000803e14 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e14:	55                   	push   %rbp
  803e15:	48 89 e5             	mov    %rsp,%rbp
  803e18:	48 83 ec 20          	sub    $0x20,%rsp
  803e1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e22:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e25:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e29:	be 01 00 00 00       	mov    $0x1,%esi
  803e2e:	48 89 c7             	mov    %rax,%rdi
  803e31:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
}
  803e3d:	90                   	nop
  803e3e:	c9                   	leaveq 
  803e3f:	c3                   	retq   

0000000000803e40 <getchar>:

int
getchar(void)
{
  803e40:	55                   	push   %rbp
  803e41:	48 89 e5             	mov    %rsp,%rbp
  803e44:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e48:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e4c:	ba 01 00 00 00       	mov    $0x1,%edx
  803e51:	48 89 c6             	mov    %rax,%rsi
  803e54:	bf 00 00 00 00       	mov    $0x0,%edi
  803e59:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  803e60:	00 00 00 
  803e63:	ff d0                	callq  *%rax
  803e65:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e6c:	79 05                	jns    803e73 <getchar+0x33>
		return r;
  803e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e71:	eb 14                	jmp    803e87 <getchar+0x47>
	if (r < 1)
  803e73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e77:	7f 07                	jg     803e80 <getchar+0x40>
		return -E_EOF;
  803e79:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e7e:	eb 07                	jmp    803e87 <getchar+0x47>
	return c;
  803e80:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e84:	0f b6 c0             	movzbl %al,%eax

}
  803e87:	c9                   	leaveq 
  803e88:	c3                   	retq   

0000000000803e89 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e89:	55                   	push   %rbp
  803e8a:	48 89 e5             	mov    %rsp,%rbp
  803e8d:	48 83 ec 20          	sub    $0x20,%rsp
  803e91:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e9b:	48 89 d6             	mov    %rdx,%rsi
  803e9e:	89 c7                	mov    %eax,%edi
  803ea0:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb3:	79 05                	jns    803eba <iscons+0x31>
		return r;
  803eb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb8:	eb 1a                	jmp    803ed4 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebe:	8b 10                	mov    (%rax),%edx
  803ec0:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ec7:	00 00 00 
  803eca:	8b 00                	mov    (%rax),%eax
  803ecc:	39 c2                	cmp    %eax,%edx
  803ece:	0f 94 c0             	sete   %al
  803ed1:	0f b6 c0             	movzbl %al,%eax
}
  803ed4:	c9                   	leaveq 
  803ed5:	c3                   	retq   

0000000000803ed6 <opencons>:

int
opencons(void)
{
  803ed6:	55                   	push   %rbp
  803ed7:	48 89 e5             	mov    %rsp,%rbp
  803eda:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ede:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ee2:	48 89 c7             	mov    %rax,%rdi
  803ee5:	48 b8 66 20 80 00 00 	movabs $0x802066,%rax
  803eec:	00 00 00 
  803eef:	ff d0                	callq  *%rax
  803ef1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ef4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef8:	79 05                	jns    803eff <opencons+0x29>
		return r;
  803efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efd:	eb 5b                	jmp    803f5a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f03:	ba 07 04 00 00       	mov    $0x407,%edx
  803f08:	48 89 c6             	mov    %rax,%rsi
  803f0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f10:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f23:	79 05                	jns    803f2a <opencons+0x54>
		return r;
  803f25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f28:	eb 30                	jmp    803f5a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f2e:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f35:	00 00 00 
  803f38:	8b 12                	mov    (%rdx),%edx
  803f3a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f40:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f4b:	48 89 c7             	mov    %rax,%rdi
  803f4e:	48 b8 18 20 80 00 00 	movabs $0x802018,%rax
  803f55:	00 00 00 
  803f58:	ff d0                	callq  *%rax
}
  803f5a:	c9                   	leaveq 
  803f5b:	c3                   	retq   

0000000000803f5c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f5c:	55                   	push   %rbp
  803f5d:	48 89 e5             	mov    %rsp,%rbp
  803f60:	48 83 ec 30          	sub    $0x30,%rsp
  803f64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f6c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f70:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f75:	75 13                	jne    803f8a <devcons_read+0x2e>
		return 0;
  803f77:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7c:	eb 49                	jmp    803fc7 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803f7e:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803f85:	00 00 00 
  803f88:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f8a:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803f91:	00 00 00 
  803f94:	ff d0                	callq  *%rax
  803f96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9d:	74 df                	je     803f7e <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803f9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fa3:	79 05                	jns    803faa <devcons_read+0x4e>
		return c;
  803fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa8:	eb 1d                	jmp    803fc7 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803faa:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fae:	75 07                	jne    803fb7 <devcons_read+0x5b>
		return 0;
  803fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb5:	eb 10                	jmp    803fc7 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fba:	89 c2                	mov    %eax,%edx
  803fbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fc0:	88 10                	mov    %dl,(%rax)
	return 1;
  803fc2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803fc7:	c9                   	leaveq 
  803fc8:	c3                   	retq   

0000000000803fc9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fc9:	55                   	push   %rbp
  803fca:	48 89 e5             	mov    %rsp,%rbp
  803fcd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803fd4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803fdb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fe2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fe9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ff0:	eb 76                	jmp    804068 <devcons_write+0x9f>
		m = n - tot;
  803ff2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ff9:	89 c2                	mov    %eax,%edx
  803ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ffe:	29 c2                	sub    %eax,%edx
  804000:	89 d0                	mov    %edx,%eax
  804002:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804005:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804008:	83 f8 7f             	cmp    $0x7f,%eax
  80400b:	76 07                	jbe    804014 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80400d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804014:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804017:	48 63 d0             	movslq %eax,%rdx
  80401a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401d:	48 63 c8             	movslq %eax,%rcx
  804020:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804027:	48 01 c1             	add    %rax,%rcx
  80402a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804031:	48 89 ce             	mov    %rcx,%rsi
  804034:	48 89 c7             	mov    %rax,%rdi
  804037:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  80403e:	00 00 00 
  804041:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804043:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804046:	48 63 d0             	movslq %eax,%rdx
  804049:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804050:	48 89 d6             	mov    %rdx,%rsi
  804053:	48 89 c7             	mov    %rax,%rdi
  804056:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  80405d:	00 00 00 
  804060:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804062:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804065:	01 45 fc             	add    %eax,-0x4(%rbp)
  804068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406b:	48 98                	cltq   
  80406d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804074:	0f 82 78 ff ff ff    	jb     803ff2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80407a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80407d:	c9                   	leaveq 
  80407e:	c3                   	retq   

000000000080407f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80407f:	55                   	push   %rbp
  804080:	48 89 e5             	mov    %rsp,%rbp
  804083:	48 83 ec 08          	sub    $0x8,%rsp
  804087:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80408b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804090:	c9                   	leaveq 
  804091:	c3                   	retq   

0000000000804092 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804092:	55                   	push   %rbp
  804093:	48 89 e5             	mov    %rsp,%rbp
  804096:	48 83 ec 10          	sub    $0x10,%rsp
  80409a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80409e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a6:	48 be b4 4a 80 00 00 	movabs $0x804ab4,%rsi
  8040ad:	00 00 00 
  8040b0:	48 89 c7             	mov    %rax,%rdi
  8040b3:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  8040ba:	00 00 00 
  8040bd:	ff d0                	callq  *%rax
	return 0;
  8040bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c4:	c9                   	leaveq 
  8040c5:	c3                   	retq   

00000000008040c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8040c6:	55                   	push   %rbp
  8040c7:	48 89 e5             	mov    %rsp,%rbp
  8040ca:	48 83 ec 30          	sub    $0x30,%rsp
  8040ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8040da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040df:	75 0e                	jne    8040ef <ipc_recv+0x29>
		pg = (void*) UTOP;
  8040e1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040e8:	00 00 00 
  8040eb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8040ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040f3:	48 89 c7             	mov    %rax,%rdi
  8040f6:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
  804102:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804105:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804109:	79 27                	jns    804132 <ipc_recv+0x6c>
		if (from_env_store)
  80410b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804110:	74 0a                	je     80411c <ipc_recv+0x56>
			*from_env_store = 0;
  804112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804116:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80411c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804121:	74 0a                	je     80412d <ipc_recv+0x67>
			*perm_store = 0;
  804123:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804127:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80412d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804130:	eb 53                	jmp    804185 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804132:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804137:	74 19                	je     804152 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804139:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804140:	00 00 00 
  804143:	48 8b 00             	mov    (%rax),%rax
  804146:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80414c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804150:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804152:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804157:	74 19                	je     804172 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804159:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804160:	00 00 00 
  804163:	48 8b 00             	mov    (%rax),%rax
  804166:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80416c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804170:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804172:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804179:	00 00 00 
  80417c:	48 8b 00             	mov    (%rax),%rax
  80417f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804185:	c9                   	leaveq 
  804186:	c3                   	retq   

0000000000804187 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804187:	55                   	push   %rbp
  804188:	48 89 e5             	mov    %rsp,%rbp
  80418b:	48 83 ec 30          	sub    $0x30,%rsp
  80418f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804192:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804195:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804199:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80419c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041a1:	75 1c                	jne    8041bf <ipc_send+0x38>
		pg = (void*) UTOP;
  8041a3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041aa:	00 00 00 
  8041ad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8041b1:	eb 0c                	jmp    8041bf <ipc_send+0x38>
		sys_yield();
  8041b3:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8041ba:	00 00 00 
  8041bd:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8041bf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8041c2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8041c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041cc:	89 c7                	mov    %eax,%edi
  8041ce:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  8041d5:	00 00 00 
  8041d8:	ff d0                	callq  *%rax
  8041da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041dd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041e1:	74 d0                	je     8041b3 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8041e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041e7:	79 30                	jns    804219 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8041e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ec:	89 c1                	mov    %eax,%ecx
  8041ee:	48 ba bb 4a 80 00 00 	movabs $0x804abb,%rdx
  8041f5:	00 00 00 
  8041f8:	be 47 00 00 00       	mov    $0x47,%esi
  8041fd:	48 bf d1 4a 80 00 00 	movabs $0x804ad1,%rdi
  804204:	00 00 00 
  804207:	b8 00 00 00 00       	mov    $0x0,%eax
  80420c:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  804213:	00 00 00 
  804216:	41 ff d0             	callq  *%r8

}
  804219:	90                   	nop
  80421a:	c9                   	leaveq 
  80421b:	c3                   	retq   

000000000080421c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80421c:	55                   	push   %rbp
  80421d:	48 89 e5             	mov    %rsp,%rbp
  804220:	48 83 ec 18          	sub    $0x18,%rsp
  804224:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80422e:	eb 4d                	jmp    80427d <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804230:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804237:	00 00 00 
  80423a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423d:	48 98                	cltq   
  80423f:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804246:	48 01 d0             	add    %rdx,%rax
  804249:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80424f:	8b 00                	mov    (%rax),%eax
  804251:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804254:	75 23                	jne    804279 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804256:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80425d:	00 00 00 
  804260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804263:	48 98                	cltq   
  804265:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80426c:	48 01 d0             	add    %rdx,%rax
  80426f:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804275:	8b 00                	mov    (%rax),%eax
  804277:	eb 12                	jmp    80428b <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804279:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80427d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804284:	7e aa                	jle    804230 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80428b:	c9                   	leaveq 
  80428c:	c3                   	retq   

000000000080428d <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80428d:	55                   	push   %rbp
  80428e:	48 89 e5             	mov    %rsp,%rbp
  804291:	48 83 ec 18          	sub    $0x18,%rsp
  804295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80429d:	48 c1 e8 15          	shr    $0x15,%rax
  8042a1:	48 89 c2             	mov    %rax,%rdx
  8042a4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042ab:	01 00 00 
  8042ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042b2:	83 e0 01             	and    $0x1,%eax
  8042b5:	48 85 c0             	test   %rax,%rax
  8042b8:	75 07                	jne    8042c1 <pageref+0x34>
		return 0;
  8042ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8042bf:	eb 56                	jmp    804317 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8042c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8042c9:	48 89 c2             	mov    %rax,%rdx
  8042cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042d3:	01 00 00 
  8042d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e2:	83 e0 01             	and    $0x1,%eax
  8042e5:	48 85 c0             	test   %rax,%rax
  8042e8:	75 07                	jne    8042f1 <pageref+0x64>
		return 0;
  8042ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ef:	eb 26                	jmp    804317 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8042f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8042f9:	48 89 c2             	mov    %rax,%rdx
  8042fc:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804303:	00 00 00 
  804306:	48 c1 e2 04          	shl    $0x4,%rdx
  80430a:	48 01 d0             	add    %rdx,%rax
  80430d:	48 83 c0 08          	add    $0x8,%rax
  804311:	0f b7 00             	movzwl (%rax),%eax
  804314:	0f b7 c0             	movzwl %ax,%eax
}
  804317:	c9                   	leaveq 
  804318:	c3                   	retq   
