
vmm/guest/obj/user/writemotd:     file format elf64-x86-64


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
  800060:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  800067:	00 00 00 
  80006a:	48 b8 10 29 80 00 00 	movabs $0x802910,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba a9 43 80 00 00 	movabs $0x8043a9,%rdx
  80008b:	00 00 00 
  80008e:	be 0c 00 00 00       	mov    $0xc,%esi
  800093:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf cc 43 80 00 00 	movabs $0x8043cc,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 10 29 80 00 00 	movabs $0x802910,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba d2 43 80 00 00 	movabs $0x8043d2,%rdx
  8000df:	00 00 00 
  8000e2:	be 0e 00 00 00       	mov    $0xe,%esi
  8000e7:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf e1 43 80 00 00 	movabs $0x8043e1,%rdi
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
  80012e:	48 ba 00 44 80 00 00 	movabs $0x804400,%rdx
  800135:	00 00 00 
  800138:	be 11 00 00 00       	mov    $0x11,%esi
  80013d:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 20 04 80 00 00 	movabs $0x800420,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 32 44 80 00 00 	movabs $0x804432,%rdi
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
  8001a8:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf 40 44 80 00 00 	movabs $0x804440,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 45 44 80 00 00 	movabs $0x804445,%rdx
  800219:	00 00 00 
  80021c:	be 1a 00 00 00       	mov    $0x1a,%esi
  800221:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
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
  80028e:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba 66 44 80 00 00 	movabs $0x804466,%rdx
  8002b1:	00 00 00 
  8002b4:	be 20 00 00 00       	mov    $0x20,%esi
  8002b9:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
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
  8002e9:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
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
  800302:	48 bf 40 44 80 00 00 	movabs $0x804440,%rdi
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
  800328:	48 ba 76 44 80 00 00 	movabs $0x804476,%rdx
  80032f:	00 00 00 
  800332:	be 25 00 00 00       	mov    $0x25,%esi
  800337:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
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
  800400:	48 b8 5f 22 80 00 00 	movabs $0x80225f,%rax
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
  8004da:	48 bf 98 44 80 00 00 	movabs $0x804498,%rdi
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
  800516:	48 bf bb 44 80 00 00 	movabs $0x8044bb,%rdi
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
  8007c7:	48 b8 b0 46 80 00 00 	movabs $0x8046b0,%rax
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
  800aa9:	48 b8 d8 46 80 00 00 	movabs $0x8046d8,%rax
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
  800bf0:	48 b8 00 46 80 00 00 	movabs $0x804600,%rax
  800bf7:	00 00 00 
  800bfa:	48 63 d3             	movslq %ebx,%rdx
  800bfd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c01:	4d 85 e4             	test   %r12,%r12
  800c04:	75 2e                	jne    800c34 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800c06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0e:	89 d9                	mov    %ebx,%ecx
  800c10:	48 ba c1 46 80 00 00 	movabs $0x8046c1,%rdx
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
  800c3f:	48 ba ca 46 80 00 00 	movabs $0x8046ca,%rdx
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
  800c96:	49 bc cd 46 80 00 00 	movabs $0x8046cd,%r12
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
  8019a2:	48 ba 88 49 80 00 00 	movabs $0x804988,%rdx
  8019a9:	00 00 00 
  8019ac:	be 24 00 00 00       	mov    $0x24,%esi
  8019b1:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
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

0000000000801f1c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f1c:	55                   	push   %rbp
  801f1d:	48 89 e5             	mov    %rsp,%rbp
  801f20:	48 83 ec 08          	sub    $0x8,%rsp
  801f24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f28:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f2c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f33:	ff ff ff 
  801f36:	48 01 d0             	add    %rdx,%rax
  801f39:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f3d:	c9                   	leaveq 
  801f3e:	c3                   	retq   

0000000000801f3f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f3f:	55                   	push   %rbp
  801f40:	48 89 e5             	mov    %rsp,%rbp
  801f43:	48 83 ec 08          	sub    $0x8,%rsp
  801f47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4f:	48 89 c7             	mov    %rax,%rdi
  801f52:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  801f59:	00 00 00 
  801f5c:	ff d0                	callq  *%rax
  801f5e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f64:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f68:	c9                   	leaveq 
  801f69:	c3                   	retq   

0000000000801f6a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f6a:	55                   	push   %rbp
  801f6b:	48 89 e5             	mov    %rsp,%rbp
  801f6e:	48 83 ec 18          	sub    $0x18,%rsp
  801f72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f7d:	eb 6b                	jmp    801fea <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f82:	48 98                	cltq   
  801f84:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f96:	48 c1 e8 15          	shr    $0x15,%rax
  801f9a:	48 89 c2             	mov    %rax,%rdx
  801f9d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa4:	01 00 00 
  801fa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fab:	83 e0 01             	and    $0x1,%eax
  801fae:	48 85 c0             	test   %rax,%rax
  801fb1:	74 21                	je     801fd4 <fd_alloc+0x6a>
  801fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb7:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbb:	48 89 c2             	mov    %rax,%rdx
  801fbe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc5:	01 00 00 
  801fc8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcc:	83 e0 01             	and    $0x1,%eax
  801fcf:	48 85 c0             	test   %rax,%rax
  801fd2:	75 12                	jne    801fe6 <fd_alloc+0x7c>
			*fd_store = fd;
  801fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fdc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	eb 1a                	jmp    802000 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fe6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fea:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fee:	7e 8f                	jle    801f7f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ffb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 20          	sub    $0x20,%rsp
  80200a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80200d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802011:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802015:	78 06                	js     80201d <fd_lookup+0x1b>
  802017:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80201b:	7e 07                	jle    802024 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80201d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802022:	eb 6c                	jmp    802090 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802024:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802027:	48 98                	cltq   
  802029:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80202f:	48 c1 e0 0c          	shl    $0xc,%rax
  802033:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80203b:	48 c1 e8 15          	shr    $0x15,%rax
  80203f:	48 89 c2             	mov    %rax,%rdx
  802042:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802049:	01 00 00 
  80204c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802050:	83 e0 01             	and    $0x1,%eax
  802053:	48 85 c0             	test   %rax,%rax
  802056:	74 21                	je     802079 <fd_lookup+0x77>
  802058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80205c:	48 c1 e8 0c          	shr    $0xc,%rax
  802060:	48 89 c2             	mov    %rax,%rdx
  802063:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80206a:	01 00 00 
  80206d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802071:	83 e0 01             	and    $0x1,%eax
  802074:	48 85 c0             	test   %rax,%rax
  802077:	75 07                	jne    802080 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80207e:	eb 10                	jmp    802090 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802080:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802084:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802088:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802090:	c9                   	leaveq 
  802091:	c3                   	retq   

0000000000802092 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802092:	55                   	push   %rbp
  802093:	48 89 e5             	mov    %rsp,%rbp
  802096:	48 83 ec 30          	sub    $0x30,%rsp
  80209a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80209e:	89 f0                	mov    %esi,%eax
  8020a0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8020a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a7:	48 89 c7             	mov    %rax,%rdi
  8020aa:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  8020b1:	00 00 00 
  8020b4:	ff d0                	callq  *%rax
  8020b6:	89 c2                	mov    %eax,%edx
  8020b8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8020bc:	48 89 c6             	mov    %rax,%rsi
  8020bf:	89 d7                	mov    %edx,%edi
  8020c1:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	callq  *%rax
  8020cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d4:	78 0a                	js     8020e0 <fd_close+0x4e>
	    || fd != fd2)
  8020d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020da:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020de:	74 12                	je     8020f2 <fd_close+0x60>
		return (must_exist ? r : 0);
  8020e0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020e4:	74 05                	je     8020eb <fd_close+0x59>
  8020e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e9:	eb 70                	jmp    80215b <fd_close+0xc9>
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	eb 69                	jmp    80215b <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f6:	8b 00                	mov    (%rax),%eax
  8020f8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020fc:	48 89 d6             	mov    %rdx,%rsi
  8020ff:	89 c7                	mov    %eax,%edi
  802101:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  802108:	00 00 00 
  80210b:	ff d0                	callq  *%rax
  80210d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802110:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802114:	78 2a                	js     802140 <fd_close+0xae>
		if (dev->dev_close)
  802116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80211e:	48 85 c0             	test   %rax,%rax
  802121:	74 16                	je     802139 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802127:	48 8b 40 20          	mov    0x20(%rax),%rax
  80212b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80212f:	48 89 d7             	mov    %rdx,%rdi
  802132:	ff d0                	callq  *%rax
  802134:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802137:	eb 07                	jmp    802140 <fd_close+0xae>
		else
			r = 0;
  802139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802140:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802144:	48 89 c6             	mov    %rax,%rsi
  802147:	bf 00 00 00 00       	mov    $0x0,%edi
  80214c:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802153:	00 00 00 
  802156:	ff d0                	callq  *%rax
	return r;
  802158:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80215b:	c9                   	leaveq 
  80215c:	c3                   	retq   

000000000080215d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80215d:	55                   	push   %rbp
  80215e:	48 89 e5             	mov    %rsp,%rbp
  802161:	48 83 ec 20          	sub    $0x20,%rsp
  802165:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802168:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80216c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802173:	eb 41                	jmp    8021b6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802175:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80217c:	00 00 00 
  80217f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802182:	48 63 d2             	movslq %edx,%rdx
  802185:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802189:	8b 00                	mov    (%rax),%eax
  80218b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80218e:	75 22                	jne    8021b2 <dev_lookup+0x55>
			*dev = devtab[i];
  802190:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802197:	00 00 00 
  80219a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80219d:	48 63 d2             	movslq %edx,%rdx
  8021a0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8021a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021a8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	eb 60                	jmp    802212 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8021b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021b6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021bd:	00 00 00 
  8021c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021c3:	48 63 d2             	movslq %edx,%rdx
  8021c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ca:	48 85 c0             	test   %rax,%rax
  8021cd:	75 a6                	jne    802175 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021cf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021d6:	00 00 00 
  8021d9:	48 8b 00             	mov    (%rax),%rax
  8021dc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021e2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021e5:	89 c6                	mov    %eax,%esi
  8021e7:	48 bf b8 49 80 00 00 	movabs $0x8049b8,%rdi
  8021ee:	00 00 00 
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f6:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  8021fd:	00 00 00 
  802200:	ff d1                	callq  *%rcx
	*dev = 0;
  802202:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802206:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80220d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802212:	c9                   	leaveq 
  802213:	c3                   	retq   

0000000000802214 <close>:

int
close(int fdnum)
{
  802214:	55                   	push   %rbp
  802215:	48 89 e5             	mov    %rsp,%rbp
  802218:	48 83 ec 20          	sub    $0x20,%rsp
  80221c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80221f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802223:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802226:	48 89 d6             	mov    %rdx,%rsi
  802229:	89 c7                	mov    %eax,%edi
  80222b:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802232:	00 00 00 
  802235:	ff d0                	callq  *%rax
  802237:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223e:	79 05                	jns    802245 <close+0x31>
		return r;
  802240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802243:	eb 18                	jmp    80225d <close+0x49>
	else
		return fd_close(fd, 1);
  802245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802249:	be 01 00 00 00       	mov    $0x1,%esi
  80224e:	48 89 c7             	mov    %rax,%rdi
  802251:	48 b8 92 20 80 00 00 	movabs $0x802092,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
}
  80225d:	c9                   	leaveq 
  80225e:	c3                   	retq   

000000000080225f <close_all>:

void
close_all(void)
{
  80225f:	55                   	push   %rbp
  802260:	48 89 e5             	mov    %rsp,%rbp
  802263:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80226e:	eb 15                	jmp    802285 <close_all+0x26>
		close(i);
  802270:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802273:	89 c7                	mov    %eax,%edi
  802275:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802281:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802285:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802289:	7e e5                	jle    802270 <close_all+0x11>
		close(i);
}
  80228b:	90                   	nop
  80228c:	c9                   	leaveq 
  80228d:	c3                   	retq   

000000000080228e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	48 83 ec 40          	sub    $0x40,%rsp
  802296:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802299:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80229c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8022a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8022a3:	48 89 d6             	mov    %rdx,%rsi
  8022a6:	89 c7                	mov    %eax,%edi
  8022a8:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	callq  *%rax
  8022b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bb:	79 08                	jns    8022c5 <dup+0x37>
		return r;
  8022bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c0:	e9 70 01 00 00       	jmpq   802435 <dup+0x1a7>
	close(newfdnum);
  8022c5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022c8:	89 c7                	mov    %eax,%edi
  8022ca:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  8022d1:	00 00 00 
  8022d4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022d9:	48 98                	cltq   
  8022db:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022e1:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ed:	48 89 c7             	mov    %rax,%rdi
  8022f0:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802304:	48 89 c7             	mov    %rax,%rdi
  802307:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  80230e:	00 00 00 
  802311:	ff d0                	callq  *%rax
  802313:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	48 c1 e8 15          	shr    $0x15,%rax
  80231f:	48 89 c2             	mov    %rax,%rdx
  802322:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802329:	01 00 00 
  80232c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802330:	83 e0 01             	and    $0x1,%eax
  802333:	48 85 c0             	test   %rax,%rax
  802336:	74 71                	je     8023a9 <dup+0x11b>
  802338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233c:	48 c1 e8 0c          	shr    $0xc,%rax
  802340:	48 89 c2             	mov    %rax,%rdx
  802343:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80234a:	01 00 00 
  80234d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802351:	83 e0 01             	and    $0x1,%eax
  802354:	48 85 c0             	test   %rax,%rax
  802357:	74 50                	je     8023a9 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235d:	48 c1 e8 0c          	shr    $0xc,%rax
  802361:	48 89 c2             	mov    %rax,%rdx
  802364:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80236b:	01 00 00 
  80236e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802372:	25 07 0e 00 00       	and    $0xe07,%eax
  802377:	89 c1                	mov    %eax,%ecx
  802379:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80237d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802381:	41 89 c8             	mov    %ecx,%r8d
  802384:	48 89 d1             	mov    %rdx,%rcx
  802387:	ba 00 00 00 00       	mov    $0x0,%edx
  80238c:	48 89 c6             	mov    %rax,%rsi
  80238f:	bf 00 00 00 00       	mov    $0x0,%edi
  802394:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  80239b:	00 00 00 
  80239e:	ff d0                	callq  *%rax
  8023a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a7:	78 55                	js     8023fe <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8023a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8023b1:	48 89 c2             	mov    %rax,%rdx
  8023b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023bb:	01 00 00 
  8023be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8023c7:	89 c1                	mov    %eax,%ecx
  8023c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d1:	41 89 c8             	mov    %ecx,%r8d
  8023d4:	48 89 d1             	mov    %rdx,%rcx
  8023d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023dc:	48 89 c6             	mov    %rax,%rsi
  8023df:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e4:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8023eb:	00 00 00 
  8023ee:	ff d0                	callq  *%rax
  8023f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f7:	78 08                	js     802401 <dup+0x173>
		goto err;

	return newfdnum;
  8023f9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023fc:	eb 37                	jmp    802435 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8023fe:	90                   	nop
  8023ff:	eb 01                	jmp    802402 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802401:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802406:	48 89 c6             	mov    %rax,%rsi
  802409:	bf 00 00 00 00       	mov    $0x0,%edi
  80240e:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  802415:	00 00 00 
  802418:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80241a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80241e:	48 89 c6             	mov    %rax,%rsi
  802421:	bf 00 00 00 00       	mov    $0x0,%edi
  802426:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80242d:	00 00 00 
  802430:	ff d0                	callq  *%rax
	return r;
  802432:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802435:	c9                   	leaveq 
  802436:	c3                   	retq   

0000000000802437 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	48 83 ec 40          	sub    $0x40,%rsp
  80243f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802442:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802446:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80244a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80244e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802451:	48 89 d6             	mov    %rdx,%rsi
  802454:	89 c7                	mov    %eax,%edi
  802456:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  80245d:	00 00 00 
  802460:	ff d0                	callq  *%rax
  802462:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802465:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802469:	78 24                	js     80248f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80246b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246f:	8b 00                	mov    (%rax),%eax
  802471:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802475:	48 89 d6             	mov    %rdx,%rsi
  802478:	89 c7                	mov    %eax,%edi
  80247a:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax
  802486:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80248d:	79 05                	jns    802494 <read+0x5d>
		return r;
  80248f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802492:	eb 76                	jmp    80250a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802498:	8b 40 08             	mov    0x8(%rax),%eax
  80249b:	83 e0 03             	and    $0x3,%eax
  80249e:	83 f8 01             	cmp    $0x1,%eax
  8024a1:	75 3a                	jne    8024dd <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024aa:	00 00 00 
  8024ad:	48 8b 00             	mov    (%rax),%rax
  8024b0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024b6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024b9:	89 c6                	mov    %eax,%esi
  8024bb:	48 bf d7 49 80 00 00 	movabs $0x8049d7,%rdi
  8024c2:	00 00 00 
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  8024d1:	00 00 00 
  8024d4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024db:	eb 2d                	jmp    80250a <read+0xd3>
	}
	if (!dev->dev_read)
  8024dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024e5:	48 85 c0             	test   %rax,%rax
  8024e8:	75 07                	jne    8024f1 <read+0xba>
		return -E_NOT_SUPP;
  8024ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024ef:	eb 19                	jmp    80250a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802501:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802505:	48 89 cf             	mov    %rcx,%rdi
  802508:	ff d0                	callq  *%rax
}
  80250a:	c9                   	leaveq 
  80250b:	c3                   	retq   

000000000080250c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80250c:	55                   	push   %rbp
  80250d:	48 89 e5             	mov    %rsp,%rbp
  802510:	48 83 ec 30          	sub    $0x30,%rsp
  802514:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802517:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80251b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80251f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802526:	eb 47                	jmp    80256f <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802528:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252b:	48 98                	cltq   
  80252d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802531:	48 29 c2             	sub    %rax,%rdx
  802534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802537:	48 63 c8             	movslq %eax,%rcx
  80253a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80253e:	48 01 c1             	add    %rax,%rcx
  802541:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802544:	48 89 ce             	mov    %rcx,%rsi
  802547:	89 c7                	mov    %eax,%edi
  802549:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
  802555:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802558:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80255c:	79 05                	jns    802563 <readn+0x57>
			return m;
  80255e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802561:	eb 1d                	jmp    802580 <readn+0x74>
		if (m == 0)
  802563:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802567:	74 13                	je     80257c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802569:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80256c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80256f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802572:	48 98                	cltq   
  802574:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802578:	72 ae                	jb     802528 <readn+0x1c>
  80257a:	eb 01                	jmp    80257d <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80257c:	90                   	nop
	}
	return tot;
  80257d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802580:	c9                   	leaveq 
  802581:	c3                   	retq   

0000000000802582 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802582:	55                   	push   %rbp
  802583:	48 89 e5             	mov    %rsp,%rbp
  802586:	48 83 ec 40          	sub    $0x40,%rsp
  80258a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80258d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802591:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802595:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802599:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80259c:	48 89 d6             	mov    %rdx,%rsi
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b4:	78 24                	js     8025da <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ba:	8b 00                	mov    (%rax),%eax
  8025bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c0:	48 89 d6             	mov    %rdx,%rsi
  8025c3:	89 c7                	mov    %eax,%edi
  8025c5:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	callq  *%rax
  8025d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d8:	79 05                	jns    8025df <write+0x5d>
		return r;
  8025da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dd:	eb 75                	jmp    802654 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e3:	8b 40 08             	mov    0x8(%rax),%eax
  8025e6:	83 e0 03             	and    $0x3,%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	75 3a                	jne    802627 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025f4:	00 00 00 
  8025f7:	48 8b 00             	mov    (%rax),%rax
  8025fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802600:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802603:	89 c6                	mov    %eax,%esi
  802605:	48 bf f3 49 80 00 00 	movabs $0x8049f3,%rdi
  80260c:	00 00 00 
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  80261b:	00 00 00 
  80261e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802620:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802625:	eb 2d                	jmp    802654 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80262f:	48 85 c0             	test   %rax,%rax
  802632:	75 07                	jne    80263b <write+0xb9>
		return -E_NOT_SUPP;
  802634:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802639:	eb 19                	jmp    802654 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80263b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802643:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802647:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80264b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80264f:	48 89 cf             	mov    %rcx,%rdi
  802652:	ff d0                	callq  *%rax
}
  802654:	c9                   	leaveq 
  802655:	c3                   	retq   

0000000000802656 <seek>:

int
seek(int fdnum, off_t offset)
{
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	48 83 ec 18          	sub    $0x18,%rsp
  80265e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802661:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802664:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802668:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80266b:	48 89 d6             	mov    %rdx,%rsi
  80266e:	89 c7                	mov    %eax,%edi
  802670:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802677:	00 00 00 
  80267a:	ff d0                	callq  *%rax
  80267c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802683:	79 05                	jns    80268a <seek+0x34>
		return r;
  802685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802688:	eb 0f                	jmp    802699 <seek+0x43>
	fd->fd_offset = offset;
  80268a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802691:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802699:	c9                   	leaveq 
  80269a:	c3                   	retq   

000000000080269b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80269b:	55                   	push   %rbp
  80269c:	48 89 e5             	mov    %rsp,%rbp
  80269f:	48 83 ec 30          	sub    $0x30,%rsp
  8026a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026b0:	48 89 d6             	mov    %rdx,%rsi
  8026b3:	89 c7                	mov    %eax,%edi
  8026b5:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8026bc:	00 00 00 
  8026bf:	ff d0                	callq  *%rax
  8026c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c8:	78 24                	js     8026ee <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ce:	8b 00                	mov    (%rax),%eax
  8026d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d4:	48 89 d6             	mov    %rdx,%rsi
  8026d7:	89 c7                	mov    %eax,%edi
  8026d9:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ec:	79 05                	jns    8026f3 <ftruncate+0x58>
		return r;
  8026ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f1:	eb 72                	jmp    802765 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f7:	8b 40 08             	mov    0x8(%rax),%eax
  8026fa:	83 e0 03             	and    $0x3,%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	75 3a                	jne    80273b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802701:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802708:	00 00 00 
  80270b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80270e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802714:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802717:	89 c6                	mov    %eax,%esi
  802719:	48 bf 10 4a 80 00 00 	movabs $0x804a10,%rdi
  802720:	00 00 00 
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
  802728:	48 b9 5a 06 80 00 00 	movabs $0x80065a,%rcx
  80272f:	00 00 00 
  802732:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802734:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802739:	eb 2a                	jmp    802765 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80273b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802743:	48 85 c0             	test   %rax,%rax
  802746:	75 07                	jne    80274f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802748:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80274d:	eb 16                	jmp    802765 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80274f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802753:	48 8b 40 30          	mov    0x30(%rax),%rax
  802757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80275b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80275e:	89 ce                	mov    %ecx,%esi
  802760:	48 89 d7             	mov    %rdx,%rdi
  802763:	ff d0                	callq  *%rax
}
  802765:	c9                   	leaveq 
  802766:	c3                   	retq   

0000000000802767 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802767:	55                   	push   %rbp
  802768:	48 89 e5             	mov    %rsp,%rbp
  80276b:	48 83 ec 30          	sub    $0x30,%rsp
  80276f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802772:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802776:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80277a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80277d:	48 89 d6             	mov    %rdx,%rsi
  802780:	89 c7                	mov    %eax,%edi
  802782:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802791:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802795:	78 24                	js     8027bb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	8b 00                	mov    (%rax),%eax
  80279d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a1:	48 89 d6             	mov    %rdx,%rsi
  8027a4:	89 c7                	mov    %eax,%edi
  8027a6:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
  8027b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b9:	79 05                	jns    8027c0 <fstat+0x59>
		return r;
  8027bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027be:	eb 5e                	jmp    80281e <fstat+0xb7>
	if (!dev->dev_stat)
  8027c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027c8:	48 85 c0             	test   %rax,%rax
  8027cb:	75 07                	jne    8027d4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8027cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027d2:	eb 4a                	jmp    80281e <fstat+0xb7>
	stat->st_name[0] = 0;
  8027d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027d8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027df:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027e6:	00 00 00 
	stat->st_isdir = 0;
  8027e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ed:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027f4:	00 00 00 
	stat->st_dev = dev;
  8027f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ff:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80280e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802812:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802816:	48 89 ce             	mov    %rcx,%rsi
  802819:	48 89 d7             	mov    %rdx,%rdi
  80281c:	ff d0                	callq  *%rax
}
  80281e:	c9                   	leaveq 
  80281f:	c3                   	retq   

0000000000802820 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 83 ec 20          	sub    $0x20,%rsp
  802828:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80282c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802834:	be 00 00 00 00       	mov    $0x0,%esi
  802839:	48 89 c7             	mov    %rax,%rdi
  80283c:	48 b8 10 29 80 00 00 	movabs $0x802910,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
  802848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284f:	79 05                	jns    802856 <stat+0x36>
		return fd;
  802851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802854:	eb 2f                	jmp    802885 <stat+0x65>
	r = fstat(fd, stat);
  802856:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80285a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285d:	48 89 d6             	mov    %rdx,%rsi
  802860:	89 c7                	mov    %eax,%edi
  802862:	48 b8 67 27 80 00 00 	movabs $0x802767,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
  80286e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802874:	89 c7                	mov    %eax,%edi
  802876:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  80287d:	00 00 00 
  802880:	ff d0                	callq  *%rax
	return r;
  802882:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802885:	c9                   	leaveq 
  802886:	c3                   	retq   

0000000000802887 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802887:	55                   	push   %rbp
  802888:	48 89 e5             	mov    %rsp,%rbp
  80288b:	48 83 ec 10          	sub    $0x10,%rsp
  80288f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802892:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802896:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80289d:	00 00 00 
  8028a0:	8b 00                	mov    (%rax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	75 1f                	jne    8028c5 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8028a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8028ab:	48 b8 97 42 80 00 00 	movabs $0x804297,%rax
  8028b2:	00 00 00 
  8028b5:	ff d0                	callq  *%rax
  8028b7:	89 c2                	mov    %eax,%edx
  8028b9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028c0:	00 00 00 
  8028c3:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028c5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028cc:	00 00 00 
  8028cf:	8b 00                	mov    (%rax),%eax
  8028d1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028d4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028d9:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8028e0:	00 00 00 
  8028e3:	89 c7                	mov    %eax,%edi
  8028e5:	48 b8 8b 40 80 00 00 	movabs $0x80408b,%rax
  8028ec:	00 00 00 
  8028ef:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fa:	48 89 c6             	mov    %rax,%rsi
  8028fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802902:	48 b8 ca 3f 80 00 00 	movabs $0x803fca,%rax
  802909:	00 00 00 
  80290c:	ff d0                	callq  *%rax
}
  80290e:	c9                   	leaveq 
  80290f:	c3                   	retq   

0000000000802910 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802910:	55                   	push   %rbp
  802911:	48 89 e5             	mov    %rsp,%rbp
  802914:	48 83 ec 20          	sub    $0x20,%rsp
  802918:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80291c:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80291f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802923:	48 89 c7             	mov    %rax,%rdi
  802926:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  80292d:	00 00 00 
  802930:	ff d0                	callq  *%rax
  802932:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802937:	7e 0a                	jle    802943 <open+0x33>
		return -E_BAD_PATH;
  802939:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80293e:	e9 a5 00 00 00       	jmpq   8029e8 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802943:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802947:	48 89 c7             	mov    %rax,%rdi
  80294a:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  802951:	00 00 00 
  802954:	ff d0                	callq  *%rax
  802956:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802959:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295d:	79 08                	jns    802967 <open+0x57>
		return r;
  80295f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802962:	e9 81 00 00 00       	jmpq   8029e8 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296b:	48 89 c6             	mov    %rax,%rsi
  80296e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802975:	00 00 00 
  802978:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802984:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80298b:	00 00 00 
  80298e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802991:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802997:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299b:	48 89 c6             	mov    %rax,%rsi
  80299e:	bf 01 00 00 00       	mov    $0x1,%edi
  8029a3:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	callq  *%rax
  8029af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b6:	79 1d                	jns    8029d5 <open+0xc5>
		fd_close(fd, 0);
  8029b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bc:	be 00 00 00 00       	mov    $0x0,%esi
  8029c1:	48 89 c7             	mov    %rax,%rdi
  8029c4:	48 b8 92 20 80 00 00 	movabs $0x802092,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
		return r;
  8029d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d3:	eb 13                	jmp    8029e8 <open+0xd8>
	}

	return fd2num(fd);
  8029d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d9:	48 89 c7             	mov    %rax,%rdi
  8029dc:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  8029e3:	00 00 00 
  8029e6:	ff d0                	callq  *%rax

}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	48 83 ec 10          	sub    $0x10,%rsp
  8029f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029fa:	8b 50 0c             	mov    0xc(%rax),%edx
  8029fd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a04:	00 00 00 
  802a07:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a09:	be 00 00 00 00       	mov    $0x0,%esi
  802a0e:	bf 06 00 00 00       	mov    $0x6,%edi
  802a13:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802a1a:	00 00 00 
  802a1d:	ff d0                	callq  *%rax
}
  802a1f:	c9                   	leaveq 
  802a20:	c3                   	retq   

0000000000802a21 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a21:	55                   	push   %rbp
  802a22:	48 89 e5             	mov    %rsp,%rbp
  802a25:	48 83 ec 30          	sub    $0x30,%rsp
  802a29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a31:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a39:	8b 50 0c             	mov    0xc(%rax),%edx
  802a3c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a43:	00 00 00 
  802a46:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4f:	00 00 00 
  802a52:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a56:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802a5a:	be 00 00 00 00       	mov    $0x0,%esi
  802a5f:	bf 03 00 00 00       	mov    $0x3,%edi
  802a64:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802a6b:	00 00 00 
  802a6e:	ff d0                	callq  *%rax
  802a70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a77:	79 08                	jns    802a81 <devfile_read+0x60>
		return r;
  802a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7c:	e9 a4 00 00 00       	jmpq   802b25 <devfile_read+0x104>
	assert(r <= n);
  802a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a84:	48 98                	cltq   
  802a86:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a8a:	76 35                	jbe    802ac1 <devfile_read+0xa0>
  802a8c:	48 b9 36 4a 80 00 00 	movabs $0x804a36,%rcx
  802a93:	00 00 00 
  802a96:	48 ba 3d 4a 80 00 00 	movabs $0x804a3d,%rdx
  802a9d:	00 00 00 
  802aa0:	be 86 00 00 00       	mov    $0x86,%esi
  802aa5:	48 bf 52 4a 80 00 00 	movabs $0x804a52,%rdi
  802aac:	00 00 00 
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab4:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  802abb:	00 00 00 
  802abe:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802ac1:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802ac8:	7e 35                	jle    802aff <devfile_read+0xde>
  802aca:	48 b9 5d 4a 80 00 00 	movabs $0x804a5d,%rcx
  802ad1:	00 00 00 
  802ad4:	48 ba 3d 4a 80 00 00 	movabs $0x804a3d,%rdx
  802adb:	00 00 00 
  802ade:	be 87 00 00 00       	mov    $0x87,%esi
  802ae3:	48 bf 52 4a 80 00 00 	movabs $0x804a52,%rdi
  802aea:	00 00 00 
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  802af9:	00 00 00 
  802afc:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b02:	48 63 d0             	movslq %eax,%rdx
  802b05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b09:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b10:	00 00 00 
  802b13:	48 89 c7             	mov    %rax,%rdi
  802b16:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
	return r;
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802b25:	c9                   	leaveq 
  802b26:	c3                   	retq   

0000000000802b27 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	48 83 ec 40          	sub    $0x40,%rsp
  802b2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b37:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802b3b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b43:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802b4a:	00 
  802b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802b53:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802b58:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b60:	8b 50 0c             	mov    0xc(%rax),%edx
  802b63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b6a:	00 00 00 
  802b6d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b76:	00 00 00 
  802b79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b7d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802b81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b89:	48 89 c6             	mov    %rax,%rsi
  802b8c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802b93:	00 00 00 
  802b96:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802ba2:	be 00 00 00 00       	mov    $0x0,%esi
  802ba7:	bf 04 00 00 00       	mov    $0x4,%edi
  802bac:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
  802bb8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bbb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bbf:	79 05                	jns    802bc6 <devfile_write+0x9f>
		return r;
  802bc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc4:	eb 43                	jmp    802c09 <devfile_write+0xe2>
	assert(r <= n);
  802bc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc9:	48 98                	cltq   
  802bcb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802bcf:	76 35                	jbe    802c06 <devfile_write+0xdf>
  802bd1:	48 b9 36 4a 80 00 00 	movabs $0x804a36,%rcx
  802bd8:	00 00 00 
  802bdb:	48 ba 3d 4a 80 00 00 	movabs $0x804a3d,%rdx
  802be2:	00 00 00 
  802be5:	be a2 00 00 00       	mov    $0xa2,%esi
  802bea:	48 bf 52 4a 80 00 00 	movabs $0x804a52,%rdi
  802bf1:	00 00 00 
  802bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf9:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  802c00:	00 00 00 
  802c03:	41 ff d0             	callq  *%r8
	return r;
  802c06:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802c09:	c9                   	leaveq 
  802c0a:	c3                   	retq   

0000000000802c0b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c0b:	55                   	push   %rbp
  802c0c:	48 89 e5             	mov    %rsp,%rbp
  802c0f:	48 83 ec 20          	sub    $0x20,%rsp
  802c13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1f:	8b 50 0c             	mov    0xc(%rax),%edx
  802c22:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c29:	00 00 00 
  802c2c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c2e:	be 00 00 00 00       	mov    $0x0,%esi
  802c33:	bf 05 00 00 00       	mov    $0x5,%edi
  802c38:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
  802c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4b:	79 05                	jns    802c52 <devfile_stat+0x47>
		return r;
  802c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c50:	eb 56                	jmp    802ca8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c56:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c5d:	00 00 00 
  802c60:	48 89 c7             	mov    %rax,%rdi
  802c63:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c76:	00 00 00 
  802c79:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c83:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c90:	00 00 00 
  802c93:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca8:	c9                   	leaveq 
  802ca9:	c3                   	retq   

0000000000802caa <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802caa:	55                   	push   %rbp
  802cab:	48 89 e5             	mov    %rsp,%rbp
  802cae:	48 83 ec 10          	sub    $0x10,%rsp
  802cb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cb6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cbd:	8b 50 0c             	mov    0xc(%rax),%edx
  802cc0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cc7:	00 00 00 
  802cca:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ccc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd3:	00 00 00 
  802cd6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802cd9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802cdc:	be 00 00 00 00       	mov    $0x0,%esi
  802ce1:	bf 02 00 00 00       	mov    $0x2,%edi
  802ce6:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802ced:	00 00 00 
  802cf0:	ff d0                	callq  *%rax
}
  802cf2:	c9                   	leaveq 
  802cf3:	c3                   	retq   

0000000000802cf4 <remove>:

// Delete a file
int
remove(const char *path)
{
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	48 83 ec 10          	sub    $0x10,%rsp
  802cfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d04:	48 89 c7             	mov    %rax,%rdi
  802d07:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
  802d13:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d18:	7e 07                	jle    802d21 <remove+0x2d>
		return -E_BAD_PATH;
  802d1a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d1f:	eb 33                	jmp    802d54 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d25:	48 89 c6             	mov    %rax,%rsi
  802d28:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d2f:	00 00 00 
  802d32:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802d39:	00 00 00 
  802d3c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d3e:	be 00 00 00 00       	mov    $0x0,%esi
  802d43:	bf 07 00 00 00       	mov    $0x7,%edi
  802d48:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
}
  802d54:	c9                   	leaveq 
  802d55:	c3                   	retq   

0000000000802d56 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d56:	55                   	push   %rbp
  802d57:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d5a:	be 00 00 00 00       	mov    $0x0,%esi
  802d5f:	bf 08 00 00 00       	mov    $0x8,%edi
  802d64:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
}
  802d70:	5d                   	pop    %rbp
  802d71:	c3                   	retq   

0000000000802d72 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d72:	55                   	push   %rbp
  802d73:	48 89 e5             	mov    %rsp,%rbp
  802d76:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d7d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d84:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d8b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d92:	be 00 00 00 00       	mov    $0x0,%esi
  802d97:	48 89 c7             	mov    %rax,%rdi
  802d9a:	48 b8 10 29 80 00 00 	movabs $0x802910,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dad:	79 28                	jns    802dd7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db2:	89 c6                	mov    %eax,%esi
  802db4:	48 bf 69 4a 80 00 00 	movabs $0x804a69,%rdi
  802dbb:	00 00 00 
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc3:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802dca:	00 00 00 
  802dcd:	ff d2                	callq  *%rdx
		return fd_src;
  802dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd2:	e9 76 01 00 00       	jmpq   802f4d <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802dd7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802dde:	be 01 01 00 00       	mov    $0x101,%esi
  802de3:	48 89 c7             	mov    %rax,%rdi
  802de6:	48 b8 10 29 80 00 00 	movabs $0x802910,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
  802df2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802df5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802df9:	0f 89 ad 00 00 00    	jns    802eac <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802dff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e02:	89 c6                	mov    %eax,%esi
  802e04:	48 bf 7f 4a 80 00 00 	movabs $0x804a7f,%rdi
  802e0b:	00 00 00 
  802e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e13:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802e1a:	00 00 00 
  802e1d:	ff d2                	callq  *%rdx
		close(fd_src);
  802e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
		return fd_dest;
  802e30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e33:	e9 15 01 00 00       	jmpq   802f4d <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802e38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e3b:	48 63 d0             	movslq %eax,%rdx
  802e3e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e48:	48 89 ce             	mov    %rcx,%rsi
  802e4b:	89 c7                	mov    %eax,%edi
  802e4d:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
  802e59:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e60:	79 4a                	jns    802eac <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802e62:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e65:	89 c6                	mov    %eax,%esi
  802e67:	48 bf 99 4a 80 00 00 	movabs $0x804a99,%rdi
  802e6e:	00 00 00 
  802e71:	b8 00 00 00 00       	mov    $0x0,%eax
  802e76:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802e7d:	00 00 00 
  802e80:	ff d2                	callq  *%rdx
			close(fd_src);
  802e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e85:	89 c7                	mov    %eax,%edi
  802e87:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
			close(fd_dest);
  802e93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e96:	89 c7                	mov    %eax,%edi
  802e98:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
			return write_size;
  802ea4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ea7:	e9 a1 00 00 00       	jmpq   802f4d <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802eac:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802eb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb6:	ba 00 02 00 00       	mov    $0x200,%edx
  802ebb:	48 89 ce             	mov    %rcx,%rsi
  802ebe:	89 c7                	mov    %eax,%edi
  802ec0:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ed3:	0f 8f 5f ff ff ff    	jg     802e38 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802edd:	79 47                	jns    802f26 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802edf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ee2:	89 c6                	mov    %eax,%esi
  802ee4:	48 bf ac 4a 80 00 00 	movabs $0x804aac,%rdi
  802eeb:	00 00 00 
  802eee:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef3:	48 ba 5a 06 80 00 00 	movabs $0x80065a,%rdx
  802efa:	00 00 00 
  802efd:	ff d2                	callq  *%rdx
		close(fd_src);
  802eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f02:	89 c7                	mov    %eax,%edi
  802f04:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
		close(fd_dest);
  802f10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f13:	89 c7                	mov    %eax,%edi
  802f15:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802f1c:	00 00 00 
  802f1f:	ff d0                	callq  *%rax
		return read_size;
  802f21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f24:	eb 27                	jmp    802f4d <copy+0x1db>
	}
	close(fd_src);
  802f26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f29:	89 c7                	mov    %eax,%edi
  802f2b:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
	close(fd_dest);
  802f37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f3a:	89 c7                	mov    %eax,%edi
  802f3c:	48 b8 14 22 80 00 00 	movabs $0x802214,%rax
  802f43:	00 00 00 
  802f46:	ff d0                	callq  *%rax
	return 0;
  802f48:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f4d:	c9                   	leaveq 
  802f4e:	c3                   	retq   

0000000000802f4f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802f4f:	55                   	push   %rbp
  802f50:	48 89 e5             	mov    %rsp,%rbp
  802f53:	48 83 ec 20          	sub    $0x20,%rsp
  802f57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802f5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f61:	48 89 d6             	mov    %rdx,%rsi
  802f64:	89 c7                	mov    %eax,%edi
  802f66:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
  802f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f79:	79 05                	jns    802f80 <fd2sockid+0x31>
		return r;
  802f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7e:	eb 24                	jmp    802fa4 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f84:	8b 10                	mov    (%rax),%edx
  802f86:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f8d:	00 00 00 
  802f90:	8b 00                	mov    (%rax),%eax
  802f92:	39 c2                	cmp    %eax,%edx
  802f94:	74 07                	je     802f9d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f96:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f9b:	eb 07                	jmp    802fa4 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa1:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802fa4:	c9                   	leaveq 
  802fa5:	c3                   	retq   

0000000000802fa6 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
  802faa:	48 83 ec 20          	sub    $0x20,%rsp
  802fae:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802fb1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fb5:	48 89 c7             	mov    %rax,%rdi
  802fb8:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
  802fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcb:	78 26                	js     802ff3 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd1:	ba 07 04 00 00       	mov    $0x407,%edx
  802fd6:	48 89 c6             	mov    %rax,%rsi
  802fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  802fde:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
  802fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff1:	79 16                	jns    803009 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802ff3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff6:	89 c7                	mov    %eax,%edi
  802ff8:	48 b8 b5 34 80 00 00 	movabs $0x8034b5,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
		return r;
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	eb 3a                	jmp    803043 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300d:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803014:	00 00 00 
  803017:	8b 12                	mov    (%rdx),%edx
  803019:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80301b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803026:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80302d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803030:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803034:	48 89 c7             	mov    %rax,%rdi
  803037:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
}
  803043:	c9                   	leaveq 
  803044:	c3                   	retq   

0000000000803045 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803045:	55                   	push   %rbp
  803046:	48 89 e5             	mov    %rsp,%rbp
  803049:	48 83 ec 30          	sub    $0x30,%rsp
  80304d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803050:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803054:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803058:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305b:	89 c7                	mov    %eax,%edi
  80305d:	48 b8 4f 2f 80 00 00 	movabs $0x802f4f,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
  803069:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803070:	79 05                	jns    803077 <accept+0x32>
		return r;
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803075:	eb 3b                	jmp    8030b2 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803077:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80307b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80307f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803082:	48 89 ce             	mov    %rcx,%rsi
  803085:	89 c7                	mov    %eax,%edi
  803087:	48 b8 92 33 80 00 00 	movabs $0x803392,%rax
  80308e:	00 00 00 
  803091:	ff d0                	callq  *%rax
  803093:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803096:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80309a:	79 05                	jns    8030a1 <accept+0x5c>
		return r;
  80309c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309f:	eb 11                	jmp    8030b2 <accept+0x6d>
	return alloc_sockfd(r);
  8030a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a4:	89 c7                	mov    %eax,%edi
  8030a6:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
}
  8030b2:	c9                   	leaveq 
  8030b3:	c3                   	retq   

00000000008030b4 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8030b4:	55                   	push   %rbp
  8030b5:	48 89 e5             	mov    %rsp,%rbp
  8030b8:	48 83 ec 20          	sub    $0x20,%rsp
  8030bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030c9:	89 c7                	mov    %eax,%edi
  8030cb:	48 b8 4f 2f 80 00 00 	movabs $0x802f4f,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
  8030d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030de:	79 05                	jns    8030e5 <bind+0x31>
		return r;
  8030e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e3:	eb 1b                	jmp    803100 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8030e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ef:	48 89 ce             	mov    %rcx,%rsi
  8030f2:	89 c7                	mov    %eax,%edi
  8030f4:	48 b8 11 34 80 00 00 	movabs $0x803411,%rax
  8030fb:	00 00 00 
  8030fe:	ff d0                	callq  *%rax
}
  803100:	c9                   	leaveq 
  803101:	c3                   	retq   

0000000000803102 <shutdown>:

int
shutdown(int s, int how)
{
  803102:	55                   	push   %rbp
  803103:	48 89 e5             	mov    %rsp,%rbp
  803106:	48 83 ec 20          	sub    $0x20,%rsp
  80310a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80310d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803110:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803113:	89 c7                	mov    %eax,%edi
  803115:	48 b8 4f 2f 80 00 00 	movabs $0x802f4f,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
  803121:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803128:	79 05                	jns    80312f <shutdown+0x2d>
		return r;
  80312a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312d:	eb 16                	jmp    803145 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80312f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803132:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803135:	89 d6                	mov    %edx,%esi
  803137:	89 c7                	mov    %eax,%edi
  803139:	48 b8 75 34 80 00 00 	movabs $0x803475,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
}
  803145:	c9                   	leaveq 
  803146:	c3                   	retq   

0000000000803147 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803147:	55                   	push   %rbp
  803148:	48 89 e5             	mov    %rsp,%rbp
  80314b:	48 83 ec 10          	sub    $0x10,%rsp
  80314f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803157:	48 89 c7             	mov    %rax,%rdi
  80315a:	48 b8 08 43 80 00 00 	movabs $0x804308,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
  803166:	83 f8 01             	cmp    $0x1,%eax
  803169:	75 17                	jne    803182 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80316b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80316f:	8b 40 0c             	mov    0xc(%rax),%eax
  803172:	89 c7                	mov    %eax,%edi
  803174:	48 b8 b5 34 80 00 00 	movabs $0x8034b5,%rax
  80317b:	00 00 00 
  80317e:	ff d0                	callq  *%rax
  803180:	eb 05                	jmp    803187 <devsock_close+0x40>
	else
		return 0;
  803182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803187:	c9                   	leaveq 
  803188:	c3                   	retq   

0000000000803189 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803189:	55                   	push   %rbp
  80318a:	48 89 e5             	mov    %rsp,%rbp
  80318d:	48 83 ec 20          	sub    $0x20,%rsp
  803191:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803194:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803198:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80319b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80319e:	89 c7                	mov    %eax,%edi
  8031a0:	48 b8 4f 2f 80 00 00 	movabs $0x802f4f,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
  8031ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b3:	79 05                	jns    8031ba <connect+0x31>
		return r;
  8031b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b8:	eb 1b                	jmp    8031d5 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8031ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c4:	48 89 ce             	mov    %rcx,%rsi
  8031c7:	89 c7                	mov    %eax,%edi
  8031c9:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
}
  8031d5:	c9                   	leaveq 
  8031d6:	c3                   	retq   

00000000008031d7 <listen>:

int
listen(int s, int backlog)
{
  8031d7:	55                   	push   %rbp
  8031d8:	48 89 e5             	mov    %rsp,%rbp
  8031db:	48 83 ec 20          	sub    $0x20,%rsp
  8031df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e8:	89 c7                	mov    %eax,%edi
  8031ea:	48 b8 4f 2f 80 00 00 	movabs $0x802f4f,%rax
  8031f1:	00 00 00 
  8031f4:	ff d0                	callq  *%rax
  8031f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fd:	79 05                	jns    803204 <listen+0x2d>
		return r;
  8031ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803202:	eb 16                	jmp    80321a <listen+0x43>
	return nsipc_listen(r, backlog);
  803204:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803207:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320a:	89 d6                	mov    %edx,%esi
  80320c:	89 c7                	mov    %eax,%edi
  80320e:	48 b8 46 35 80 00 00 	movabs $0x803546,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
}
  80321a:	c9                   	leaveq 
  80321b:	c3                   	retq   

000000000080321c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80321c:	55                   	push   %rbp
  80321d:	48 89 e5             	mov    %rsp,%rbp
  803220:	48 83 ec 20          	sub    $0x20,%rsp
  803224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803228:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80322c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803234:	89 c2                	mov    %eax,%edx
  803236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323a:	8b 40 0c             	mov    0xc(%rax),%eax
  80323d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803241:	b9 00 00 00 00       	mov    $0x0,%ecx
  803246:	89 c7                	mov    %eax,%edi
  803248:	48 b8 86 35 80 00 00 	movabs $0x803586,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
}
  803254:	c9                   	leaveq 
  803255:	c3                   	retq   

0000000000803256 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803256:	55                   	push   %rbp
  803257:	48 89 e5             	mov    %rsp,%rbp
  80325a:	48 83 ec 20          	sub    $0x20,%rsp
  80325e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803262:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803266:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80326a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80326e:	89 c2                	mov    %eax,%edx
  803270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803274:	8b 40 0c             	mov    0xc(%rax),%eax
  803277:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80327b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803280:	89 c7                	mov    %eax,%edi
  803282:	48 b8 52 36 80 00 00 	movabs $0x803652,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
}
  80328e:	c9                   	leaveq 
  80328f:	c3                   	retq   

0000000000803290 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803290:	55                   	push   %rbp
  803291:	48 89 e5             	mov    %rsp,%rbp
  803294:	48 83 ec 10          	sub    $0x10,%rsp
  803298:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80329c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8032a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a4:	48 be c7 4a 80 00 00 	movabs $0x804ac7,%rsi
  8032ab:	00 00 00 
  8032ae:	48 89 c7             	mov    %rax,%rdi
  8032b1:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
	return 0;
  8032bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032c2:	c9                   	leaveq 
  8032c3:	c3                   	retq   

00000000008032c4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8032c4:	55                   	push   %rbp
  8032c5:	48 89 e5             	mov    %rsp,%rbp
  8032c8:	48 83 ec 20          	sub    $0x20,%rsp
  8032cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032cf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8032d2:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032d8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032de:	89 ce                	mov    %ecx,%esi
  8032e0:	89 c7                	mov    %eax,%edi
  8032e2:	48 b8 0a 37 80 00 00 	movabs $0x80370a,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
  8032ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f5:	79 05                	jns    8032fc <socket+0x38>
		return r;
  8032f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fa:	eb 11                	jmp    80330d <socket+0x49>
	return alloc_sockfd(r);
  8032fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ff:	89 c7                	mov    %eax,%edi
  803301:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
}
  80330d:	c9                   	leaveq 
  80330e:	c3                   	retq   

000000000080330f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80330f:	55                   	push   %rbp
  803310:	48 89 e5             	mov    %rsp,%rbp
  803313:	48 83 ec 10          	sub    $0x10,%rsp
  803317:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80331a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803321:	00 00 00 
  803324:	8b 00                	mov    (%rax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	75 1f                	jne    803349 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80332a:	bf 02 00 00 00       	mov    $0x2,%edi
  80332f:	48 b8 97 42 80 00 00 	movabs $0x804297,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
  80333b:	89 c2                	mov    %eax,%edx
  80333d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803344:	00 00 00 
  803347:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803349:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803350:	00 00 00 
  803353:	8b 00                	mov    (%rax),%eax
  803355:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803358:	b9 07 00 00 00       	mov    $0x7,%ecx
  80335d:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803364:	00 00 00 
  803367:	89 c7                	mov    %eax,%edi
  803369:	48 b8 8b 40 80 00 00 	movabs $0x80408b,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803375:	ba 00 00 00 00       	mov    $0x0,%edx
  80337a:	be 00 00 00 00       	mov    $0x0,%esi
  80337f:	bf 00 00 00 00       	mov    $0x0,%edi
  803384:	48 b8 ca 3f 80 00 00 	movabs $0x803fca,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
}
  803390:	c9                   	leaveq 
  803391:	c3                   	retq   

0000000000803392 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803392:	55                   	push   %rbp
  803393:	48 89 e5             	mov    %rsp,%rbp
  803396:	48 83 ec 30          	sub    $0x30,%rsp
  80339a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80339d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8033a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ac:	00 00 00 
  8033af:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033b2:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8033b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8033b9:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
  8033c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cc:	78 3e                	js     80340c <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8033ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d5:	00 00 00 
  8033d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8033dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e0:	8b 40 10             	mov    0x10(%rax),%eax
  8033e3:	89 c2                	mov    %eax,%edx
  8033e5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8033e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ed:	48 89 ce             	mov    %rcx,%rsi
  8033f0:	48 89 c7             	mov    %rax,%rdi
  8033f3:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8033ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803403:	8b 50 10             	mov    0x10(%rax),%edx
  803406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340a:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80340c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80340f:	c9                   	leaveq 
  803410:	c3                   	retq   

0000000000803411 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803411:	55                   	push   %rbp
  803412:	48 89 e5             	mov    %rsp,%rbp
  803415:	48 83 ec 10          	sub    $0x10,%rsp
  803419:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80341c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803420:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803423:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342a:	00 00 00 
  80342d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803430:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803432:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	48 89 c6             	mov    %rax,%rsi
  80343c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803443:	00 00 00 
  803446:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  80344d:	00 00 00 
  803450:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803452:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803459:	00 00 00 
  80345c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80345f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803462:	bf 02 00 00 00       	mov    $0x2,%edi
  803467:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
}
  803473:	c9                   	leaveq 
  803474:	c3                   	retq   

0000000000803475 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803475:	55                   	push   %rbp
  803476:	48 89 e5             	mov    %rsp,%rbp
  803479:	48 83 ec 10          	sub    $0x10,%rsp
  80347d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803480:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803483:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348a:	00 00 00 
  80348d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803490:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803492:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803499:	00 00 00 
  80349c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80349f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8034a2:	bf 03 00 00 00       	mov    $0x3,%edi
  8034a7:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
}
  8034b3:	c9                   	leaveq 
  8034b4:	c3                   	retq   

00000000008034b5 <nsipc_close>:

int
nsipc_close(int s)
{
  8034b5:	55                   	push   %rbp
  8034b6:	48 89 e5             	mov    %rsp,%rbp
  8034b9:	48 83 ec 10          	sub    $0x10,%rsp
  8034bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8034c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034c7:	00 00 00 
  8034ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034cd:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8034cf:	bf 04 00 00 00       	mov    $0x4,%edi
  8034d4:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
}
  8034e0:	c9                   	leaveq 
  8034e1:	c3                   	retq   

00000000008034e2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034e2:	55                   	push   %rbp
  8034e3:	48 89 e5             	mov    %rsp,%rbp
  8034e6:	48 83 ec 10          	sub    $0x10,%rsp
  8034ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034f1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8034f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fb:	00 00 00 
  8034fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803501:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803503:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350a:	48 89 c6             	mov    %rax,%rsi
  80350d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803514:	00 00 00 
  803517:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  80351e:	00 00 00 
  803521:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803523:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80352a:	00 00 00 
  80352d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803530:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803533:	bf 05 00 00 00       	mov    $0x5,%edi
  803538:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
}
  803544:	c9                   	leaveq 
  803545:	c3                   	retq   

0000000000803546 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803546:	55                   	push   %rbp
  803547:	48 89 e5             	mov    %rsp,%rbp
  80354a:	48 83 ec 10          	sub    $0x10,%rsp
  80354e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803551:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803554:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355b:	00 00 00 
  80355e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803561:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803563:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80356a:	00 00 00 
  80356d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803573:	bf 06 00 00 00       	mov    $0x6,%edi
  803578:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
}
  803584:	c9                   	leaveq 
  803585:	c3                   	retq   

0000000000803586 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803586:	55                   	push   %rbp
  803587:	48 89 e5             	mov    %rsp,%rbp
  80358a:	48 83 ec 30          	sub    $0x30,%rsp
  80358e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803591:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803595:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803598:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80359b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a2:	00 00 00 
  8035a5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035a8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8035aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b1:	00 00 00 
  8035b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035b7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8035ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035c1:	00 00 00 
  8035c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8035c7:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8035ca:	bf 07 00 00 00       	mov    $0x7,%edi
  8035cf:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
  8035db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e2:	78 69                	js     80364d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8035e4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8035eb:	7f 08                	jg     8035f5 <nsipc_recv+0x6f>
  8035ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8035f3:	7e 35                	jle    80362a <nsipc_recv+0xa4>
  8035f5:	48 b9 ce 4a 80 00 00 	movabs $0x804ace,%rcx
  8035fc:	00 00 00 
  8035ff:	48 ba e3 4a 80 00 00 	movabs $0x804ae3,%rdx
  803606:	00 00 00 
  803609:	be 62 00 00 00       	mov    $0x62,%esi
  80360e:	48 bf f8 4a 80 00 00 	movabs $0x804af8,%rdi
  803615:	00 00 00 
  803618:	b8 00 00 00 00       	mov    $0x0,%eax
  80361d:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  803624:	00 00 00 
  803627:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80362a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362d:	48 63 d0             	movslq %eax,%rdx
  803630:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803634:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80363b:	00 00 00 
  80363e:	48 89 c7             	mov    %rax,%rdi
  803641:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
	}

	return r;
  80364d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803650:	c9                   	leaveq 
  803651:	c3                   	retq   

0000000000803652 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803652:	55                   	push   %rbp
  803653:	48 89 e5             	mov    %rsp,%rbp
  803656:	48 83 ec 20          	sub    $0x20,%rsp
  80365a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80365d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803661:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803664:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803667:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366e:	00 00 00 
  803671:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803674:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803676:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80367d:	7e 35                	jle    8036b4 <nsipc_send+0x62>
  80367f:	48 b9 04 4b 80 00 00 	movabs $0x804b04,%rcx
  803686:	00 00 00 
  803689:	48 ba e3 4a 80 00 00 	movabs $0x804ae3,%rdx
  803690:	00 00 00 
  803693:	be 6d 00 00 00       	mov    $0x6d,%esi
  803698:	48 bf f8 4a 80 00 00 	movabs $0x804af8,%rdi
  80369f:	00 00 00 
  8036a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a7:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  8036ae:	00 00 00 
  8036b1:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8036b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b7:	48 63 d0             	movslq %eax,%rdx
  8036ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036be:	48 89 c6             	mov    %rax,%rsi
  8036c1:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8036c8:	00 00 00 
  8036cb:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8036d7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036de:	00 00 00 
  8036e1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8036e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ee:	00 00 00 
  8036f1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036f4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8036f7:	bf 08 00 00 00       	mov    $0x8,%edi
  8036fc:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
}
  803708:	c9                   	leaveq 
  803709:	c3                   	retq   

000000000080370a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80370a:	55                   	push   %rbp
  80370b:	48 89 e5             	mov    %rsp,%rbp
  80370e:	48 83 ec 10          	sub    $0x10,%rsp
  803712:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803715:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803718:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80371b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803722:	00 00 00 
  803725:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803728:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80372a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803731:	00 00 00 
  803734:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803737:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80373a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803741:	00 00 00 
  803744:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803747:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80374a:	bf 09 00 00 00       	mov    $0x9,%edi
  80374f:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  803756:	00 00 00 
  803759:	ff d0                	callq  *%rax
}
  80375b:	c9                   	leaveq 
  80375c:	c3                   	retq   

000000000080375d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80375d:	55                   	push   %rbp
  80375e:	48 89 e5             	mov    %rsp,%rbp
  803761:	53                   	push   %rbx
  803762:	48 83 ec 38          	sub    $0x38,%rsp
  803766:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80376a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80376e:	48 89 c7             	mov    %rax,%rdi
  803771:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
  80377d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803780:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803784:	0f 88 bf 01 00 00    	js     803949 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80378a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378e:	ba 07 04 00 00       	mov    $0x407,%edx
  803793:	48 89 c6             	mov    %rax,%rsi
  803796:	bf 00 00 00 00       	mov    $0x0,%edi
  80379b:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  8037a2:	00 00 00 
  8037a5:	ff d0                	callq  *%rax
  8037a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037ae:	0f 88 95 01 00 00    	js     803949 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037b4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037b8:	48 89 c7             	mov    %rax,%rdi
  8037bb:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
  8037c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037ce:	0f 88 5d 01 00 00    	js     803931 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d8:	ba 07 04 00 00       	mov    $0x407,%edx
  8037dd:	48 89 c6             	mov    %rax,%rsi
  8037e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e5:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  8037ec:	00 00 00 
  8037ef:	ff d0                	callq  *%rax
  8037f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037f8:	0f 88 33 01 00 00    	js     803931 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803802:	48 89 c7             	mov    %rax,%rdi
  803805:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  80380c:	00 00 00 
  80380f:	ff d0                	callq  *%rax
  803811:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803815:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803819:	ba 07 04 00 00       	mov    $0x407,%edx
  80381e:	48 89 c6             	mov    %rax,%rsi
  803821:	bf 00 00 00 00       	mov    $0x0,%edi
  803826:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  80382d:	00 00 00 
  803830:	ff d0                	callq  *%rax
  803832:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803835:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803839:	0f 88 d9 00 00 00    	js     803918 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80383f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803843:	48 89 c7             	mov    %rax,%rdi
  803846:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
  803852:	48 89 c2             	mov    %rax,%rdx
  803855:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803859:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80385f:	48 89 d1             	mov    %rdx,%rcx
  803862:	ba 00 00 00 00       	mov    $0x0,%edx
  803867:	48 89 c6             	mov    %rax,%rsi
  80386a:	bf 00 00 00 00       	mov    $0x0,%edi
  80386f:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80387e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803882:	78 79                	js     8038fd <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803888:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80388f:	00 00 00 
  803892:	8b 12                	mov    (%rdx),%edx
  803894:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038ac:	00 00 00 
  8038af:	8b 12                	mov    (%rdx),%edx
  8038b1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c2:	48 89 c7             	mov    %rax,%rdi
  8038c5:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  8038cc:	00 00 00 
  8038cf:	ff d0                	callq  *%rax
  8038d1:	89 c2                	mov    %eax,%edx
  8038d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038d7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8038d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038dd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8038e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e5:	48 89 c7             	mov    %rax,%rdi
  8038e8:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax
  8038f4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fb:	eb 4f                	jmp    80394c <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8038fd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803902:	48 89 c6             	mov    %rax,%rsi
  803905:	bf 00 00 00 00       	mov    $0x0,%edi
  80390a:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
  803916:	eb 01                	jmp    803919 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803918:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803919:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80391d:	48 89 c6             	mov    %rax,%rsi
  803920:	bf 00 00 00 00       	mov    $0x0,%edi
  803925:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803935:	48 89 c6             	mov    %rax,%rsi
  803938:	bf 00 00 00 00       	mov    $0x0,%edi
  80393d:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803944:	00 00 00 
  803947:	ff d0                	callq  *%rax
err:
	return r;
  803949:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80394c:	48 83 c4 38          	add    $0x38,%rsp
  803950:	5b                   	pop    %rbx
  803951:	5d                   	pop    %rbp
  803952:	c3                   	retq   

0000000000803953 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803953:	55                   	push   %rbp
  803954:	48 89 e5             	mov    %rsp,%rbp
  803957:	53                   	push   %rbx
  803958:	48 83 ec 28          	sub    $0x28,%rsp
  80395c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803960:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803964:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80396b:	00 00 00 
  80396e:	48 8b 00             	mov    (%rax),%rax
  803971:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803977:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80397a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80397e:	48 89 c7             	mov    %rax,%rdi
  803981:	48 b8 08 43 80 00 00 	movabs $0x804308,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
  80398d:	89 c3                	mov    %eax,%ebx
  80398f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803993:	48 89 c7             	mov    %rax,%rdi
  803996:	48 b8 08 43 80 00 00 	movabs $0x804308,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	39 c3                	cmp    %eax,%ebx
  8039a4:	0f 94 c0             	sete   %al
  8039a7:	0f b6 c0             	movzbl %al,%eax
  8039aa:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039b4:	00 00 00 
  8039b7:	48 8b 00             	mov    (%rax),%rax
  8039ba:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039c0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039c9:	75 05                	jne    8039d0 <_pipeisclosed+0x7d>
			return ret;
  8039cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039ce:	eb 4a                	jmp    803a1a <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8039d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039d3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039d6:	74 8c                	je     803964 <_pipeisclosed+0x11>
  8039d8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039dc:	75 86                	jne    803964 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039de:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039e5:	00 00 00 
  8039e8:	48 8b 00             	mov    (%rax),%rax
  8039eb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8039f1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f7:	89 c6                	mov    %eax,%esi
  8039f9:	48 bf 15 4b 80 00 00 	movabs $0x804b15,%rdi
  803a00:	00 00 00 
  803a03:	b8 00 00 00 00       	mov    $0x0,%eax
  803a08:	49 b8 5a 06 80 00 00 	movabs $0x80065a,%r8
  803a0f:	00 00 00 
  803a12:	41 ff d0             	callq  *%r8
	}
  803a15:	e9 4a ff ff ff       	jmpq   803964 <_pipeisclosed+0x11>

}
  803a1a:	48 83 c4 28          	add    $0x28,%rsp
  803a1e:	5b                   	pop    %rbx
  803a1f:	5d                   	pop    %rbp
  803a20:	c3                   	retq   

0000000000803a21 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a21:	55                   	push   %rbp
  803a22:	48 89 e5             	mov    %rsp,%rbp
  803a25:	48 83 ec 30          	sub    $0x30,%rsp
  803a29:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a2c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a30:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a33:	48 89 d6             	mov    %rdx,%rsi
  803a36:	89 c7                	mov    %eax,%edi
  803a38:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  803a3f:	00 00 00 
  803a42:	ff d0                	callq  *%rax
  803a44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a4b:	79 05                	jns    803a52 <pipeisclosed+0x31>
		return r;
  803a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a50:	eb 31                	jmp    803a83 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a56:	48 89 c7             	mov    %rax,%rdi
  803a59:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  803a60:	00 00 00 
  803a63:	ff d0                	callq  *%rax
  803a65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a71:	48 89 d6             	mov    %rdx,%rsi
  803a74:	48 89 c7             	mov    %rax,%rdi
  803a77:	48 b8 53 39 80 00 00 	movabs $0x803953,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
}
  803a83:	c9                   	leaveq 
  803a84:	c3                   	retq   

0000000000803a85 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a85:	55                   	push   %rbp
  803a86:	48 89 e5             	mov    %rsp,%rbp
  803a89:	48 83 ec 40          	sub    $0x40,%rsp
  803a8d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a91:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a95:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9d:	48 89 c7             	mov    %rax,%rdi
  803aa0:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
  803aac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ab0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ab8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803abf:	00 
  803ac0:	e9 90 00 00 00       	jmpq   803b55 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ac5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803aca:	74 09                	je     803ad5 <devpipe_read+0x50>
				return i;
  803acc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ad0:	e9 8e 00 00 00       	jmpq   803b63 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ad5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803add:	48 89 d6             	mov    %rdx,%rsi
  803ae0:	48 89 c7             	mov    %rax,%rdi
  803ae3:	48 b8 53 39 80 00 00 	movabs $0x803953,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
  803aef:	85 c0                	test   %eax,%eax
  803af1:	74 07                	je     803afa <devpipe_read+0x75>
				return 0;
  803af3:	b8 00 00 00 00       	mov    $0x0,%eax
  803af8:	eb 69                	jmp    803b63 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803afa:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803b01:	00 00 00 
  803b04:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0a:	8b 10                	mov    (%rax),%edx
  803b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b10:	8b 40 04             	mov    0x4(%rax),%eax
  803b13:	39 c2                	cmp    %eax,%edx
  803b15:	74 ae                	je     803ac5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b1f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b27:	8b 00                	mov    (%rax),%eax
  803b29:	99                   	cltd   
  803b2a:	c1 ea 1b             	shr    $0x1b,%edx
  803b2d:	01 d0                	add    %edx,%eax
  803b2f:	83 e0 1f             	and    $0x1f,%eax
  803b32:	29 d0                	sub    %edx,%eax
  803b34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b38:	48 98                	cltq   
  803b3a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b3f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b45:	8b 00                	mov    (%rax),%eax
  803b47:	8d 50 01             	lea    0x1(%rax),%edx
  803b4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b50:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b59:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b5d:	72 a7                	jb     803b06 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803b63:	c9                   	leaveq 
  803b64:	c3                   	retq   

0000000000803b65 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b65:	55                   	push   %rbp
  803b66:	48 89 e5             	mov    %rsp,%rbp
  803b69:	48 83 ec 40          	sub    $0x40,%rsp
  803b6d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b71:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b75:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b7d:	48 89 c7             	mov    %rax,%rdi
  803b80:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  803b87:	00 00 00 
  803b8a:	ff d0                	callq  *%rax
  803b8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b98:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b9f:	00 
  803ba0:	e9 8f 00 00 00       	jmpq   803c34 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ba5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ba9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bad:	48 89 d6             	mov    %rdx,%rsi
  803bb0:	48 89 c7             	mov    %rax,%rdi
  803bb3:	48 b8 53 39 80 00 00 	movabs $0x803953,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
  803bbf:	85 c0                	test   %eax,%eax
  803bc1:	74 07                	je     803bca <devpipe_write+0x65>
				return 0;
  803bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc8:	eb 78                	jmp    803c42 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803bca:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bda:	8b 40 04             	mov    0x4(%rax),%eax
  803bdd:	48 63 d0             	movslq %eax,%rdx
  803be0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be4:	8b 00                	mov    (%rax),%eax
  803be6:	48 98                	cltq   
  803be8:	48 83 c0 20          	add    $0x20,%rax
  803bec:	48 39 c2             	cmp    %rax,%rdx
  803bef:	73 b4                	jae    803ba5 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf5:	8b 40 04             	mov    0x4(%rax),%eax
  803bf8:	99                   	cltd   
  803bf9:	c1 ea 1b             	shr    $0x1b,%edx
  803bfc:	01 d0                	add    %edx,%eax
  803bfe:	83 e0 1f             	and    $0x1f,%eax
  803c01:	29 d0                	sub    %edx,%eax
  803c03:	89 c6                	mov    %eax,%esi
  803c05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0d:	48 01 d0             	add    %rdx,%rax
  803c10:	0f b6 08             	movzbl (%rax),%ecx
  803c13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c17:	48 63 c6             	movslq %esi,%rax
  803c1a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c22:	8b 40 04             	mov    0x4(%rax),%eax
  803c25:	8d 50 01             	lea    0x1(%rax),%edx
  803c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c2f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c38:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c3c:	72 98                	jb     803bd6 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803c42:	c9                   	leaveq 
  803c43:	c3                   	retq   

0000000000803c44 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c44:	55                   	push   %rbp
  803c45:	48 89 e5             	mov    %rsp,%rbp
  803c48:	48 83 ec 20          	sub    $0x20,%rsp
  803c4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c58:	48 89 c7             	mov    %rax,%rdi
  803c5b:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  803c62:	00 00 00 
  803c65:	ff d0                	callq  *%rax
  803c67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c6f:	48 be 28 4b 80 00 00 	movabs $0x804b28,%rsi
  803c76:	00 00 00 
  803c79:	48 89 c7             	mov    %rax,%rdi
  803c7c:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  803c83:	00 00 00 
  803c86:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c8c:	8b 50 04             	mov    0x4(%rax),%edx
  803c8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c93:	8b 00                	mov    (%rax),%eax
  803c95:	29 c2                	sub    %eax,%edx
  803c97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c9b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ca1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ca5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803cac:	00 00 00 
	stat->st_dev = &devpipe;
  803caf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cb3:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803cba:	00 00 00 
  803cbd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cc9:	c9                   	leaveq 
  803cca:	c3                   	retq   

0000000000803ccb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ccb:	55                   	push   %rbp
  803ccc:	48 89 e5             	mov    %rsp,%rbp
  803ccf:	48 83 ec 10          	sub    $0x10,%rsp
  803cd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803cd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cdb:	48 89 c6             	mov    %rax,%rsi
  803cde:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce3:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803cea:	00 00 00 
  803ced:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf3:	48 89 c7             	mov    %rax,%rdi
  803cf6:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
  803d02:	48 89 c6             	mov    %rax,%rsi
  803d05:	bf 00 00 00 00       	mov    $0x0,%edi
  803d0a:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
}
  803d16:	c9                   	leaveq 
  803d17:	c3                   	retq   

0000000000803d18 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d18:	55                   	push   %rbp
  803d19:	48 89 e5             	mov    %rsp,%rbp
  803d1c:	48 83 ec 20          	sub    $0x20,%rsp
  803d20:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d26:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d29:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d2d:	be 01 00 00 00       	mov    $0x1,%esi
  803d32:	48 89 c7             	mov    %rax,%rdi
  803d35:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
}
  803d41:	90                   	nop
  803d42:	c9                   	leaveq 
  803d43:	c3                   	retq   

0000000000803d44 <getchar>:

int
getchar(void)
{
  803d44:	55                   	push   %rbp
  803d45:	48 89 e5             	mov    %rsp,%rbp
  803d48:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d4c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d50:	ba 01 00 00 00       	mov    $0x1,%edx
  803d55:	48 89 c6             	mov    %rax,%rsi
  803d58:	bf 00 00 00 00       	mov    $0x0,%edi
  803d5d:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  803d64:	00 00 00 
  803d67:	ff d0                	callq  *%rax
  803d69:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d70:	79 05                	jns    803d77 <getchar+0x33>
		return r;
  803d72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d75:	eb 14                	jmp    803d8b <getchar+0x47>
	if (r < 1)
  803d77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d7b:	7f 07                	jg     803d84 <getchar+0x40>
		return -E_EOF;
  803d7d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d82:	eb 07                	jmp    803d8b <getchar+0x47>
	return c;
  803d84:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d88:	0f b6 c0             	movzbl %al,%eax

}
  803d8b:	c9                   	leaveq 
  803d8c:	c3                   	retq   

0000000000803d8d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d8d:	55                   	push   %rbp
  803d8e:	48 89 e5             	mov    %rsp,%rbp
  803d91:	48 83 ec 20          	sub    $0x20,%rsp
  803d95:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d98:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d9f:	48 89 d6             	mov    %rdx,%rsi
  803da2:	89 c7                	mov    %eax,%edi
  803da4:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  803dab:	00 00 00 
  803dae:	ff d0                	callq  *%rax
  803db0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db7:	79 05                	jns    803dbe <iscons+0x31>
		return r;
  803db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbc:	eb 1a                	jmp    803dd8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc2:	8b 10                	mov    (%rax),%edx
  803dc4:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803dcb:	00 00 00 
  803dce:	8b 00                	mov    (%rax),%eax
  803dd0:	39 c2                	cmp    %eax,%edx
  803dd2:	0f 94 c0             	sete   %al
  803dd5:	0f b6 c0             	movzbl %al,%eax
}
  803dd8:	c9                   	leaveq 
  803dd9:	c3                   	retq   

0000000000803dda <opencons>:

int
opencons(void)
{
  803dda:	55                   	push   %rbp
  803ddb:	48 89 e5             	mov    %rsp,%rbp
  803dde:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803de2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803de6:	48 89 c7             	mov    %rax,%rdi
  803de9:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  803df0:	00 00 00 
  803df3:	ff d0                	callq  *%rax
  803df5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dfc:	79 05                	jns    803e03 <opencons+0x29>
		return r;
  803dfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e01:	eb 5b                	jmp    803e5e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e07:	ba 07 04 00 00       	mov    $0x407,%edx
  803e0c:	48 89 c6             	mov    %rax,%rsi
  803e0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803e14:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  803e1b:	00 00 00 
  803e1e:	ff d0                	callq  *%rax
  803e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e27:	79 05                	jns    803e2e <opencons+0x54>
		return r;
  803e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2c:	eb 30                	jmp    803e5e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e32:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e39:	00 00 00 
  803e3c:	8b 12                	mov    (%rdx),%edx
  803e3e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e44:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4f:	48 89 c7             	mov    %rax,%rdi
  803e52:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  803e59:	00 00 00 
  803e5c:	ff d0                	callq  *%rax
}
  803e5e:	c9                   	leaveq 
  803e5f:	c3                   	retq   

0000000000803e60 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e60:	55                   	push   %rbp
  803e61:	48 89 e5             	mov    %rsp,%rbp
  803e64:	48 83 ec 30          	sub    $0x30,%rsp
  803e68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e70:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e74:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e79:	75 13                	jne    803e8e <devcons_read+0x2e>
		return 0;
  803e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e80:	eb 49                	jmp    803ecb <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e82:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e8e:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  803e95:	00 00 00 
  803e98:	ff d0                	callq  *%rax
  803e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea1:	74 df                	je     803e82 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea7:	79 05                	jns    803eae <devcons_read+0x4e>
		return c;
  803ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eac:	eb 1d                	jmp    803ecb <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803eae:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803eb2:	75 07                	jne    803ebb <devcons_read+0x5b>
		return 0;
  803eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb9:	eb 10                	jmp    803ecb <devcons_read+0x6b>
	*(char*)vbuf = c;
  803ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebe:	89 c2                	mov    %eax,%edx
  803ec0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec4:	88 10                	mov    %dl,(%rax)
	return 1;
  803ec6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ecb:	c9                   	leaveq 
  803ecc:	c3                   	retq   

0000000000803ecd <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ecd:	55                   	push   %rbp
  803ece:	48 89 e5             	mov    %rsp,%rbp
  803ed1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ed8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803edf:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ee6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803eed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ef4:	eb 76                	jmp    803f6c <devcons_write+0x9f>
		m = n - tot;
  803ef6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803efd:	89 c2                	mov    %eax,%edx
  803eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f02:	29 c2                	sub    %eax,%edx
  803f04:	89 d0                	mov    %edx,%eax
  803f06:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f0c:	83 f8 7f             	cmp    $0x7f,%eax
  803f0f:	76 07                	jbe    803f18 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f11:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f1b:	48 63 d0             	movslq %eax,%rdx
  803f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f21:	48 63 c8             	movslq %eax,%rcx
  803f24:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f2b:	48 01 c1             	add    %rax,%rcx
  803f2e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f35:	48 89 ce             	mov    %rcx,%rsi
  803f38:	48 89 c7             	mov    %rax,%rdi
  803f3b:	48 b8 0f 15 80 00 00 	movabs $0x80150f,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f4a:	48 63 d0             	movslq %eax,%rdx
  803f4d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f54:	48 89 d6             	mov    %rdx,%rsi
  803f57:	48 89 c7             	mov    %rax,%rdi
  803f5a:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f69:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6f:	48 98                	cltq   
  803f71:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f78:	0f 82 78 ff ff ff    	jb     803ef6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f81:	c9                   	leaveq 
  803f82:	c3                   	retq   

0000000000803f83 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f83:	55                   	push   %rbp
  803f84:	48 89 e5             	mov    %rsp,%rbp
  803f87:	48 83 ec 08          	sub    $0x8,%rsp
  803f8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f94:	c9                   	leaveq 
  803f95:	c3                   	retq   

0000000000803f96 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f96:	55                   	push   %rbp
  803f97:	48 89 e5             	mov    %rsp,%rbp
  803f9a:	48 83 ec 10          	sub    $0x10,%rsp
  803f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fa2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803faa:	48 be 34 4b 80 00 00 	movabs $0x804b34,%rsi
  803fb1:	00 00 00 
  803fb4:	48 89 c7             	mov    %rax,%rdi
  803fb7:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  803fbe:	00 00 00 
  803fc1:	ff d0                	callq  *%rax
	return 0;
  803fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc8:	c9                   	leaveq 
  803fc9:	c3                   	retq   

0000000000803fca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803fca:	55                   	push   %rbp
  803fcb:	48 89 e5             	mov    %rsp,%rbp
  803fce:	48 83 ec 30          	sub    $0x30,%rsp
  803fd2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fd6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fda:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803fde:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fe3:	75 0e                	jne    803ff3 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803fe5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fec:	00 00 00 
  803fef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803ff3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff7:	48 89 c7             	mov    %rax,%rdi
  803ffa:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
  804006:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804009:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400d:	79 27                	jns    804036 <ipc_recv+0x6c>
		if (from_env_store)
  80400f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804014:	74 0a                	je     804020 <ipc_recv+0x56>
			*from_env_store = 0;
  804016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804020:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804025:	74 0a                	je     804031 <ipc_recv+0x67>
			*perm_store = 0;
  804027:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804034:	eb 53                	jmp    804089 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804036:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80403b:	74 19                	je     804056 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80403d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804044:	00 00 00 
  804047:	48 8b 00             	mov    (%rax),%rax
  80404a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804054:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804056:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80405b:	74 19                	je     804076 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80405d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804064:	00 00 00 
  804067:	48 8b 00             	mov    (%rax),%rax
  80406a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804070:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804074:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804076:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80407d:	00 00 00 
  804080:	48 8b 00             	mov    (%rax),%rax
  804083:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804089:	c9                   	leaveq 
  80408a:	c3                   	retq   

000000000080408b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80408b:	55                   	push   %rbp
  80408c:	48 89 e5             	mov    %rsp,%rbp
  80408f:	48 83 ec 30          	sub    $0x30,%rsp
  804093:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804096:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804099:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80409d:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8040a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040a5:	75 1c                	jne    8040c3 <ipc_send+0x38>
		pg = (void*) UTOP;
  8040a7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040ae:	00 00 00 
  8040b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8040b5:	eb 0c                	jmp    8040c3 <ipc_send+0x38>
		sys_yield();
  8040b7:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8040be:	00 00 00 
  8040c1:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8040c3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8040c6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8040c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040d0:	89 c7                	mov    %eax,%edi
  8040d2:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  8040d9:	00 00 00 
  8040dc:	ff d0                	callq  *%rax
  8040de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040e5:	74 d0                	je     8040b7 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8040e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040eb:	79 30                	jns    80411d <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8040ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f0:	89 c1                	mov    %eax,%ecx
  8040f2:	48 ba 3b 4b 80 00 00 	movabs $0x804b3b,%rdx
  8040f9:	00 00 00 
  8040fc:	be 47 00 00 00       	mov    $0x47,%esi
  804101:	48 bf 51 4b 80 00 00 	movabs $0x804b51,%rdi
  804108:	00 00 00 
  80410b:	b8 00 00 00 00       	mov    $0x0,%eax
  804110:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  804117:	00 00 00 
  80411a:	41 ff d0             	callq  *%r8

}
  80411d:	90                   	nop
  80411e:	c9                   	leaveq 
  80411f:	c3                   	retq   

0000000000804120 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804120:	55                   	push   %rbp
  804121:	48 89 e5             	mov    %rsp,%rbp
  804124:	53                   	push   %rbx
  804125:	48 83 ec 28          	sub    $0x28,%rsp
  804129:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  80412d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804134:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  80413b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804140:	75 0e                	jne    804150 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804142:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804149:	00 00 00 
  80414c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804154:	ba 07 00 00 00       	mov    $0x7,%edx
  804159:	48 89 c6             	mov    %rax,%rsi
  80415c:	bf 00 00 00 00       	mov    $0x0,%edi
  804161:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  804168:	00 00 00 
  80416b:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80416d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804171:	48 c1 e8 0c          	shr    $0xc,%rax
  804175:	48 89 c2             	mov    %rax,%rdx
  804178:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80417f:	01 00 00 
  804182:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804186:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80418c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804190:	b8 03 00 00 00       	mov    $0x3,%eax
  804195:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804199:	48 89 d3             	mov    %rdx,%rbx
  80419c:	0f 01 c1             	vmcall 
  80419f:	89 f2                	mov    %esi,%edx
  8041a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041a4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  8041a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041ab:	79 05                	jns    8041b2 <ipc_host_recv+0x92>
		return r;
  8041ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b0:	eb 03                	jmp    8041b5 <ipc_host_recv+0x95>
	}
	return val;
  8041b2:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  8041b5:	48 83 c4 28          	add    $0x28,%rsp
  8041b9:	5b                   	pop    %rbx
  8041ba:	5d                   	pop    %rbp
  8041bb:	c3                   	retq   

00000000008041bc <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8041bc:	55                   	push   %rbp
  8041bd:	48 89 e5             	mov    %rsp,%rbp
  8041c0:	53                   	push   %rbx
  8041c1:	48 83 ec 38          	sub    $0x38,%rsp
  8041c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8041c8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8041cb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8041cf:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  8041d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  8041d9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8041de:	75 0e                	jne    8041ee <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8041e0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041e7:	00 00 00 
  8041ea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8041ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041f2:	48 c1 e8 0c          	shr    $0xc,%rax
  8041f6:	48 89 c2             	mov    %rax,%rdx
  8041f9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804200:	01 00 00 
  804203:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804207:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80420d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804211:	b8 02 00 00 00       	mov    $0x2,%eax
  804216:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804219:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80421c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804220:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804223:	89 fb                	mov    %edi,%ebx
  804225:	0f 01 c1             	vmcall 
  804228:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  80422b:	eb 26                	jmp    804253 <ipc_host_send+0x97>
		sys_yield();
  80422d:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  804234:	00 00 00 
  804237:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804239:	b8 02 00 00 00       	mov    $0x2,%eax
  80423e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804241:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804244:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804248:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80424b:	89 fb                	mov    %edi,%ebx
  80424d:	0f 01 c1             	vmcall 
  804250:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804253:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804257:	74 d4                	je     80422d <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80425d:	79 30                	jns    80428f <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  80425f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804262:	89 c1                	mov    %eax,%ecx
  804264:	48 ba 3b 4b 80 00 00 	movabs $0x804b3b,%rdx
  80426b:	00 00 00 
  80426e:	be 79 00 00 00       	mov    $0x79,%esi
  804273:	48 bf 51 4b 80 00 00 	movabs $0x804b51,%rdi
  80427a:	00 00 00 
  80427d:	b8 00 00 00 00       	mov    $0x0,%eax
  804282:	49 b8 20 04 80 00 00 	movabs $0x800420,%r8
  804289:	00 00 00 
  80428c:	41 ff d0             	callq  *%r8

}
  80428f:	90                   	nop
  804290:	48 83 c4 38          	add    $0x38,%rsp
  804294:	5b                   	pop    %rbx
  804295:	5d                   	pop    %rbp
  804296:	c3                   	retq   

0000000000804297 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804297:	55                   	push   %rbp
  804298:	48 89 e5             	mov    %rsp,%rbp
  80429b:	48 83 ec 18          	sub    $0x18,%rsp
  80429f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8042a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042a9:	eb 4d                	jmp    8042f8 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8042ab:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8042b2:	00 00 00 
  8042b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b8:	48 98                	cltq   
  8042ba:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8042c1:	48 01 d0             	add    %rdx,%rax
  8042c4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8042ca:	8b 00                	mov    (%rax),%eax
  8042cc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8042cf:	75 23                	jne    8042f4 <ipc_find_env+0x5d>
			return envs[i].env_id;
  8042d1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8042d8:	00 00 00 
  8042db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042de:	48 98                	cltq   
  8042e0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8042e7:	48 01 d0             	add    %rdx,%rax
  8042ea:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8042f0:	8b 00                	mov    (%rax),%eax
  8042f2:	eb 12                	jmp    804306 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8042f4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8042f8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8042ff:	7e aa                	jle    8042ab <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804301:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804306:	c9                   	leaveq 
  804307:	c3                   	retq   

0000000000804308 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804308:	55                   	push   %rbp
  804309:	48 89 e5             	mov    %rsp,%rbp
  80430c:	48 83 ec 18          	sub    $0x18,%rsp
  804310:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804318:	48 c1 e8 15          	shr    $0x15,%rax
  80431c:	48 89 c2             	mov    %rax,%rdx
  80431f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804326:	01 00 00 
  804329:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80432d:	83 e0 01             	and    $0x1,%eax
  804330:	48 85 c0             	test   %rax,%rax
  804333:	75 07                	jne    80433c <pageref+0x34>
		return 0;
  804335:	b8 00 00 00 00       	mov    $0x0,%eax
  80433a:	eb 56                	jmp    804392 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  80433c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804340:	48 c1 e8 0c          	shr    $0xc,%rax
  804344:	48 89 c2             	mov    %rax,%rdx
  804347:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80434e:	01 00 00 
  804351:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804355:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80435d:	83 e0 01             	and    $0x1,%eax
  804360:	48 85 c0             	test   %rax,%rax
  804363:	75 07                	jne    80436c <pageref+0x64>
		return 0;
  804365:	b8 00 00 00 00       	mov    $0x0,%eax
  80436a:	eb 26                	jmp    804392 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  80436c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804370:	48 c1 e8 0c          	shr    $0xc,%rax
  804374:	48 89 c2             	mov    %rax,%rdx
  804377:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80437e:	00 00 00 
  804381:	48 c1 e2 04          	shl    $0x4,%rdx
  804385:	48 01 d0             	add    %rdx,%rax
  804388:	48 83 c0 08          	add    $0x8,%rax
  80438c:	0f b7 00             	movzwl (%rax),%eax
  80438f:	0f b7 c0             	movzwl %ax,%eax
}
  804392:	c9                   	leaveq 
  804393:	c3                   	retq   
