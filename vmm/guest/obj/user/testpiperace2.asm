
vmm/guest/obj/user/testpiperace2:     file format elf64-x86-64


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
  80003c:	e8 e3 02 00 00       	callq  800324 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 21 3d 80 00 00 	movabs $0x803d21,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba c2 4a 80 00 00 	movabs $0x804ac2,%rdx
  800095:	00 00 00 
  800098:	be 0e 00 00 00       	mov    $0xe,%esi
  80009d:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba e0 4a 80 00 00 	movabs $0x804ae0,%rdx
  8000da:	00 00 00 
  8000dd:	be 10 00 00 00       	mov    $0x10,%esi
  8000e2:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf e9 4a 80 00 00 	movabs $0x804ae9,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 52 28 80 00 00 	movabs $0x802852,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 98                	cltq   
  8001d2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001e0:	00 00 00 
  8001e3:	48 01 d0             	add    %rdx,%rax
  8001e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001ea:	eb 4d                	jmp    800239 <umain+0x1f6>
		if (pipeisclosed(p[0]) != 0) {
  8001ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	48 b8 e5 3f 80 00 00 	movabs $0x803fe5,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 38                	je     800239 <umain+0x1f6>
			cprintf("\nRACE: pipe appears closed\n");
  800201:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  800208:	00 00 00 
  80020b:	b8 00 00 00 00       	mov    $0x0,%eax
  800210:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  800217:	00 00 00 
  80021a:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  80021c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80021f:	89 c7                	mov    %eax,%edi
  800221:	48 b8 0d 1a 80 00 00 	movabs $0x801a0d,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
			exit();
  80022d:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800243:	83 f8 02             	cmp    $0x2,%eax
  800246:	74 a4                	je     8001ec <umain+0x1a9>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800248:	48 bf 09 4b 80 00 00 	movabs $0x804b09,%rdi
  80024f:	00 00 00 
  800252:	b8 00 00 00 00       	mov    $0x0,%eax
  800257:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  80025e:	00 00 00 
  800261:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800263:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 e5 3f 80 00 00 	movabs $0x803fe5,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
  800274:	85 c0                	test   %eax,%eax
  800276:	74 2a                	je     8002a2 <umain+0x25f>
		panic("somehow the other end of p[0] got closed!");
  800278:	48 ba 20 4b 80 00 00 	movabs $0x804b20,%rdx
  80027f:	00 00 00 
  800282:	be 41 00 00 00       	mov    $0x41,%esi
  800287:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	48 b9 cc 03 80 00 00 	movabs $0x8003cc,%rcx
  80029d:	00 00 00 
  8002a0:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002a2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002a5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002a9:	48 89 d6             	mov    %rdx,%rsi
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax
  8002ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c1:	79 30                	jns    8002f3 <umain+0x2b0>
		panic("cannot look up p[0]: %e", r);
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	89 c1                	mov    %eax,%ecx
  8002c8:	48 ba 4a 4b 80 00 00 	movabs $0x804b4a,%rdx
  8002cf:	00 00 00 
  8002d2:	be 43 00 00 00       	mov    $0x43,%esi
  8002d7:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8002ed:	00 00 00 
  8002f0:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002f7:	48 89 c7             	mov    %rax,%rdi
  8002fa:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800306:	48 bf 62 4b 80 00 00 	movabs $0x804b62,%rdi
  80030d:	00 00 00 
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
  800315:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  80031c:	00 00 00 
  80031f:	ff d2                	callq  *%rdx
}
  800321:	90                   	nop
  800322:	c9                   	leaveq 
  800323:	c3                   	retq   

0000000000800324 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800324:	55                   	push   %rbp
  800325:	48 89 e5             	mov    %rsp,%rbp
  800328:	48 83 ec 10          	sub    $0x10,%rsp
  80032c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800333:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  80033a:	00 00 00 
  80033d:	ff d0                	callq  *%rax
  80033f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800344:	48 98                	cltq   
  800346:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80034d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800354:	00 00 00 
  800357:	48 01 c2             	add    %rax,%rdx
  80035a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800361:	00 00 00 
  800364:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80036b:	7e 14                	jle    800381 <libmain+0x5d>
		binaryname = argv[0];
  80036d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800371:	48 8b 10             	mov    (%rax),%rdx
  800374:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80037b:	00 00 00 
  80037e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800381:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800388:	48 89 d6             	mov    %rdx,%rsi
  80038b:	89 c7                	mov    %eax,%edi
  80038d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800399:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  8003a0:	00 00 00 
  8003a3:	ff d0                	callq  *%rax
}
  8003a5:	90                   	nop
  8003a6:	c9                   	leaveq 
  8003a7:	c3                   	retq   

00000000008003a8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a8:	55                   	push   %rbp
  8003a9:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003ac:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8003bd:	48 b8 0d 1a 80 00 00 	movabs $0x801a0d,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax
}
  8003c9:	90                   	nop
  8003ca:	5d                   	pop    %rbp
  8003cb:	c3                   	retq   

00000000008003cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003cc:	55                   	push   %rbp
  8003cd:	48 89 e5             	mov    %rsp,%rbp
  8003d0:	53                   	push   %rbx
  8003d1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003d8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003df:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003e5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8003ec:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003f3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003fa:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800401:	84 c0                	test   %al,%al
  800403:	74 23                	je     800428 <_panic+0x5c>
  800405:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80040c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800410:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800414:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800418:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80041c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800420:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800424:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800428:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80042f:	00 00 00 
  800432:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800439:	00 00 00 
  80043c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800440:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800447:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80044e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800455:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80045c:	00 00 00 
  80045f:	48 8b 18             	mov    (%rax),%rbx
  800462:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  800469:	00 00 00 
  80046c:	ff d0                	callq  *%rax
  80046e:	89 c6                	mov    %eax,%esi
  800470:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800476:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80047d:	41 89 d0             	mov    %edx,%r8d
  800480:	48 89 c1             	mov    %rax,%rcx
  800483:	48 89 da             	mov    %rbx,%rdx
  800486:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  80048d:	00 00 00 
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	49 b9 06 06 80 00 00 	movabs $0x800606,%r9
  80049c:	00 00 00 
  80049f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004a2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004a9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004b0:	48 89 d6             	mov    %rdx,%rsi
  8004b3:	48 89 c7             	mov    %rax,%rdi
  8004b6:	48 b8 5a 05 80 00 00 	movabs $0x80055a,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
	cprintf("\n");
  8004c2:	48 bf a3 4b 80 00 00 	movabs $0x804ba3,%rdi
  8004c9:	00 00 00 
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  8004d8:	00 00 00 
  8004db:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004dd:	cc                   	int3   
  8004de:	eb fd                	jmp    8004dd <_panic+0x111>

00000000008004e0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004e0:	55                   	push   %rbp
  8004e1:	48 89 e5             	mov    %rsp,%rbp
  8004e4:	48 83 ec 10          	sub    $0x10,%rsp
  8004e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f3:	8b 00                	mov    (%rax),%eax
  8004f5:	8d 48 01             	lea    0x1(%rax),%ecx
  8004f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fc:	89 0a                	mov    %ecx,(%rdx)
  8004fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800507:	48 98                	cltq   
  800509:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80050d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800511:	8b 00                	mov    (%rax),%eax
  800513:	3d ff 00 00 00       	cmp    $0xff,%eax
  800518:	75 2c                	jne    800546 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80051a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80051e:	8b 00                	mov    (%rax),%eax
  800520:	48 98                	cltq   
  800522:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800526:	48 83 c2 08          	add    $0x8,%rdx
  80052a:	48 89 c6             	mov    %rax,%rsi
  80052d:	48 89 d7             	mov    %rdx,%rdi
  800530:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  800537:	00 00 00 
  80053a:	ff d0                	callq  *%rax
        b->idx = 0;
  80053c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800540:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054a:	8b 40 04             	mov    0x4(%rax),%eax
  80054d:	8d 50 01             	lea    0x1(%rax),%edx
  800550:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800554:	89 50 04             	mov    %edx,0x4(%rax)
}
  800557:	90                   	nop
  800558:	c9                   	leaveq 
  800559:	c3                   	retq   

000000000080055a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80055a:	55                   	push   %rbp
  80055b:	48 89 e5             	mov    %rsp,%rbp
  80055e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800565:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80056c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800573:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80057a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800581:	48 8b 0a             	mov    (%rdx),%rcx
  800584:	48 89 08             	mov    %rcx,(%rax)
  800587:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80058b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80058f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800593:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800597:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80059e:	00 00 00 
    b.cnt = 0;
  8005a1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005a8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005ab:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005b2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005b9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005c0:	48 89 c6             	mov    %rax,%rsi
  8005c3:	48 bf e0 04 80 00 00 	movabs $0x8004e0,%rdi
  8005ca:	00 00 00 
  8005cd:	48 b8 a4 09 80 00 00 	movabs $0x8009a4,%rax
  8005d4:	00 00 00 
  8005d7:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005d9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005df:	48 98                	cltq   
  8005e1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005e8:	48 83 c2 08          	add    $0x8,%rdx
  8005ec:	48 89 c6             	mov    %rax,%rsi
  8005ef:	48 89 d7             	mov    %rdx,%rdi
  8005f2:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  8005f9:	00 00 00 
  8005fc:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800604:	c9                   	leaveq 
  800605:	c3                   	retq   

0000000000800606 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800606:	55                   	push   %rbp
  800607:	48 89 e5             	mov    %rsp,%rbp
  80060a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800611:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800618:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80061f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800626:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80062d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800634:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80063b:	84 c0                	test   %al,%al
  80063d:	74 20                	je     80065f <cprintf+0x59>
  80063f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800643:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800647:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80064b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80064f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800653:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800657:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80065b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80065f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800666:	00 00 00 
  800669:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800670:	00 00 00 
  800673:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800677:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80067e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800685:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80068c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800693:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80069a:	48 8b 0a             	mov    (%rdx),%rcx
  80069d:	48 89 08             	mov    %rcx,(%rax)
  8006a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006b0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006b7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006be:	48 89 d6             	mov    %rdx,%rsi
  8006c1:	48 89 c7             	mov    %rax,%rdi
  8006c4:	48 b8 5a 05 80 00 00 	movabs $0x80055a,%rax
  8006cb:	00 00 00 
  8006ce:	ff d0                	callq  *%rax
  8006d0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006d6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006dc:	c9                   	leaveq 
  8006dd:	c3                   	retq   

00000000008006de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006de:	55                   	push   %rbp
  8006df:	48 89 e5             	mov    %rsp,%rbp
  8006e2:	48 83 ec 30          	sub    $0x30,%rsp
  8006e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006f2:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006f5:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006f9:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800700:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800704:	77 54                	ja     80075a <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800706:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800709:	8d 78 ff             	lea    -0x1(%rax),%edi
  80070c:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	48 f7 f6             	div    %rsi
  80071b:	49 89 c2             	mov    %rax,%r10
  80071e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800721:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800724:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80072c:	41 89 c9             	mov    %ecx,%r9d
  80072f:	41 89 f8             	mov    %edi,%r8d
  800732:	89 d1                	mov    %edx,%ecx
  800734:	4c 89 d2             	mov    %r10,%rdx
  800737:	48 89 c7             	mov    %rax,%rdi
  80073a:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800741:	00 00 00 
  800744:	ff d0                	callq  *%rax
  800746:	eb 1c                	jmp    800764 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800748:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80074c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80074f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800753:	48 89 ce             	mov    %rcx,%rsi
  800756:	89 d7                	mov    %edx,%edi
  800758:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80075a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80075e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800762:	7f e4                	jg     800748 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800764:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	48 f7 f1             	div    %rcx
  800773:	48 b8 b0 4d 80 00 00 	movabs $0x804db0,%rax
  80077a:	00 00 00 
  80077d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800781:	0f be d0             	movsbl %al,%edx
  800784:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80078c:	48 89 ce             	mov    %rcx,%rsi
  80078f:	89 d7                	mov    %edx,%edi
  800791:	ff d0                	callq  *%rax
}
  800793:	90                   	nop
  800794:	c9                   	leaveq 
  800795:	c3                   	retq   

0000000000800796 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800796:	55                   	push   %rbp
  800797:	48 89 e5             	mov    %rsp,%rbp
  80079a:	48 83 ec 20          	sub    $0x20,%rsp
  80079e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007a2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007a5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007a9:	7e 4f                	jle    8007fa <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	8b 00                	mov    (%rax),%eax
  8007b1:	83 f8 30             	cmp    $0x30,%eax
  8007b4:	73 24                	jae    8007da <getuint+0x44>
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	8b 00                	mov    (%rax),%eax
  8007c4:	89 c0                	mov    %eax,%eax
  8007c6:	48 01 d0             	add    %rdx,%rax
  8007c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cd:	8b 12                	mov    (%rdx),%edx
  8007cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d6:	89 0a                	mov    %ecx,(%rdx)
  8007d8:	eb 14                	jmp    8007ee <getuint+0x58>
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ee:	48 8b 00             	mov    (%rax),%rax
  8007f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f5:	e9 9d 00 00 00       	jmpq   800897 <getuint+0x101>
	else if (lflag)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007fe:	74 4c                	je     80084c <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	83 f8 30             	cmp    $0x30,%eax
  800809:	73 24                	jae    80082f <getuint+0x99>
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	89 c0                	mov    %eax,%eax
  80081b:	48 01 d0             	add    %rdx,%rax
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	8b 12                	mov    (%rdx),%edx
  800824:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	89 0a                	mov    %ecx,(%rdx)
  80082d:	eb 14                	jmp    800843 <getuint+0xad>
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	48 8b 40 08          	mov    0x8(%rax),%rax
  800837:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800843:	48 8b 00             	mov    (%rax),%rax
  800846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084a:	eb 4b                	jmp    800897 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 24                	jae    80087b <getuint+0xe5>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	89 c0                	mov    %eax,%eax
  800867:	48 01 d0             	add    %rdx,%rax
  80086a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086e:	8b 12                	mov    (%rdx),%edx
  800870:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	89 0a                	mov    %ecx,(%rdx)
  800879:	eb 14                	jmp    80088f <getuint+0xf9>
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800883:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088f:	8b 00                	mov    (%rax),%eax
  800891:	89 c0                	mov    %eax,%eax
  800893:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800897:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80089b:	c9                   	leaveq 
  80089c:	c3                   	retq   

000000000080089d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80089d:	55                   	push   %rbp
  80089e:	48 89 e5             	mov    %rsp,%rbp
  8008a1:	48 83 ec 20          	sub    $0x20,%rsp
  8008a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008a9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008ac:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008b0:	7e 4f                	jle    800901 <getint+0x64>
		x=va_arg(*ap, long long);
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	83 f8 30             	cmp    $0x30,%eax
  8008bb:	73 24                	jae    8008e1 <getint+0x44>
  8008bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	8b 00                	mov    (%rax),%eax
  8008cb:	89 c0                	mov    %eax,%eax
  8008cd:	48 01 d0             	add    %rdx,%rax
  8008d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d4:	8b 12                	mov    (%rdx),%edx
  8008d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dd:	89 0a                	mov    %ecx,(%rdx)
  8008df:	eb 14                	jmp    8008f5 <getint+0x58>
  8008e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008e9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f5:	48 8b 00             	mov    (%rax),%rax
  8008f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008fc:	e9 9d 00 00 00       	jmpq   80099e <getint+0x101>
	else if (lflag)
  800901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800905:	74 4c                	je     800953 <getint+0xb6>
		x=va_arg(*ap, long);
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	8b 00                	mov    (%rax),%eax
  80090d:	83 f8 30             	cmp    $0x30,%eax
  800910:	73 24                	jae    800936 <getint+0x99>
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80091a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091e:	8b 00                	mov    (%rax),%eax
  800920:	89 c0                	mov    %eax,%eax
  800922:	48 01 d0             	add    %rdx,%rax
  800925:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800929:	8b 12                	mov    (%rdx),%edx
  80092b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800932:	89 0a                	mov    %ecx,(%rdx)
  800934:	eb 14                	jmp    80094a <getint+0xad>
  800936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80093e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80094a:	48 8b 00             	mov    (%rax),%rax
  80094d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800951:	eb 4b                	jmp    80099e <getint+0x101>
	else
		x=va_arg(*ap, int);
  800953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800957:	8b 00                	mov    (%rax),%eax
  800959:	83 f8 30             	cmp    $0x30,%eax
  80095c:	73 24                	jae    800982 <getint+0xe5>
  80095e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800962:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	8b 00                	mov    (%rax),%eax
  80096c:	89 c0                	mov    %eax,%eax
  80096e:	48 01 d0             	add    %rdx,%rax
  800971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800975:	8b 12                	mov    (%rdx),%edx
  800977:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097e:	89 0a                	mov    %ecx,(%rdx)
  800980:	eb 14                	jmp    800996 <getint+0xf9>
  800982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800986:	48 8b 40 08          	mov    0x8(%rax),%rax
  80098a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80098e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800992:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800996:	8b 00                	mov    (%rax),%eax
  800998:	48 98                	cltq   
  80099a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80099e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009a2:	c9                   	leaveq 
  8009a3:	c3                   	retq   

00000000008009a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009a4:	55                   	push   %rbp
  8009a5:	48 89 e5             	mov    %rsp,%rbp
  8009a8:	41 54                	push   %r12
  8009aa:	53                   	push   %rbx
  8009ab:	48 83 ec 60          	sub    $0x60,%rsp
  8009af:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009b3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009b7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009bb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009bf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009c7:	48 8b 0a             	mov    (%rdx),%rcx
  8009ca:	48 89 08             	mov    %rcx,(%rax)
  8009cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009dd:	eb 17                	jmp    8009f6 <vprintfmt+0x52>
			if (ch == '\0')
  8009df:	85 db                	test   %ebx,%ebx
  8009e1:	0f 84 b9 04 00 00    	je     800ea0 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8009e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ef:	48 89 d6             	mov    %rdx,%rsi
  8009f2:	89 df                	mov    %ebx,%edi
  8009f4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009fe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a02:	0f b6 00             	movzbl (%rax),%eax
  800a05:	0f b6 d8             	movzbl %al,%ebx
  800a08:	83 fb 25             	cmp    $0x25,%ebx
  800a0b:	75 d2                	jne    8009df <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a11:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a18:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a26:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a35:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a39:	0f b6 00             	movzbl (%rax),%eax
  800a3c:	0f b6 d8             	movzbl %al,%ebx
  800a3f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a42:	83 f8 55             	cmp    $0x55,%eax
  800a45:	0f 87 22 04 00 00    	ja     800e6d <vprintfmt+0x4c9>
  800a4b:	89 c0                	mov    %eax,%eax
  800a4d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a54:	00 
  800a55:	48 b8 d8 4d 80 00 00 	movabs $0x804dd8,%rax
  800a5c:	00 00 00 
  800a5f:	48 01 d0             	add    %rdx,%rax
  800a62:	48 8b 00             	mov    (%rax),%rax
  800a65:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a67:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a6b:	eb c0                	jmp    800a2d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a6d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a71:	eb ba                	jmp    800a2d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a73:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a7a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a7d:	89 d0                	mov    %edx,%eax
  800a7f:	c1 e0 02             	shl    $0x2,%eax
  800a82:	01 d0                	add    %edx,%eax
  800a84:	01 c0                	add    %eax,%eax
  800a86:	01 d8                	add    %ebx,%eax
  800a88:	83 e8 30             	sub    $0x30,%eax
  800a8b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a92:	0f b6 00             	movzbl (%rax),%eax
  800a95:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a98:	83 fb 2f             	cmp    $0x2f,%ebx
  800a9b:	7e 60                	jle    800afd <vprintfmt+0x159>
  800a9d:	83 fb 39             	cmp    $0x39,%ebx
  800aa0:	7f 5b                	jg     800afd <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800aa7:	eb d1                	jmp    800a7a <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aac:	83 f8 30             	cmp    $0x30,%eax
  800aaf:	73 17                	jae    800ac8 <vprintfmt+0x124>
  800ab1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ab5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab8:	89 d2                	mov    %edx,%edx
  800aba:	48 01 d0             	add    %rdx,%rax
  800abd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac0:	83 c2 08             	add    $0x8,%edx
  800ac3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac6:	eb 0c                	jmp    800ad4 <vprintfmt+0x130>
  800ac8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800acc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ad0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad4:	8b 00                	mov    (%rax),%eax
  800ad6:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ad9:	eb 23                	jmp    800afe <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800adb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800adf:	0f 89 48 ff ff ff    	jns    800a2d <vprintfmt+0x89>
				width = 0;
  800ae5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800aec:	e9 3c ff ff ff       	jmpq   800a2d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800af1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800af8:	e9 30 ff ff ff       	jmpq   800a2d <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800afd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800afe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b02:	0f 89 25 ff ff ff    	jns    800a2d <vprintfmt+0x89>
				width = precision, precision = -1;
  800b08:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b0b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b0e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b15:	e9 13 ff ff ff       	jmpq   800a2d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b1a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b1e:	e9 0a ff ff ff       	jmpq   800a2d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b26:	83 f8 30             	cmp    $0x30,%eax
  800b29:	73 17                	jae    800b42 <vprintfmt+0x19e>
  800b2b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b2f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b32:	89 d2                	mov    %edx,%edx
  800b34:	48 01 d0             	add    %rdx,%rax
  800b37:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b3a:	83 c2 08             	add    $0x8,%edx
  800b3d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b40:	eb 0c                	jmp    800b4e <vprintfmt+0x1aa>
  800b42:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b46:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b4a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4e:	8b 10                	mov    (%rax),%edx
  800b50:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b58:	48 89 ce             	mov    %rcx,%rsi
  800b5b:	89 d7                	mov    %edx,%edi
  800b5d:	ff d0                	callq  *%rax
			break;
  800b5f:	e9 37 03 00 00       	jmpq   800e9b <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b67:	83 f8 30             	cmp    $0x30,%eax
  800b6a:	73 17                	jae    800b83 <vprintfmt+0x1df>
  800b6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b70:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b73:	89 d2                	mov    %edx,%edx
  800b75:	48 01 d0             	add    %rdx,%rax
  800b78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b7b:	83 c2 08             	add    $0x8,%edx
  800b7e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b81:	eb 0c                	jmp    800b8f <vprintfmt+0x1eb>
  800b83:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b87:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b8b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b8f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	79 02                	jns    800b97 <vprintfmt+0x1f3>
				err = -err;
  800b95:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b97:	83 fb 15             	cmp    $0x15,%ebx
  800b9a:	7f 16                	jg     800bb2 <vprintfmt+0x20e>
  800b9c:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  800ba3:	00 00 00 
  800ba6:	48 63 d3             	movslq %ebx,%rdx
  800ba9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bad:	4d 85 e4             	test   %r12,%r12
  800bb0:	75 2e                	jne    800be0 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800bb2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	89 d9                	mov    %ebx,%ecx
  800bbc:	48 ba c1 4d 80 00 00 	movabs $0x804dc1,%rdx
  800bc3:	00 00 00 
  800bc6:	48 89 c7             	mov    %rax,%rdi
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bce:	49 b8 aa 0e 80 00 00 	movabs $0x800eaa,%r8
  800bd5:	00 00 00 
  800bd8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bdb:	e9 bb 02 00 00       	jmpq   800e9b <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800be0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be8:	4c 89 e1             	mov    %r12,%rcx
  800beb:	48 ba ca 4d 80 00 00 	movabs $0x804dca,%rdx
  800bf2:	00 00 00 
  800bf5:	48 89 c7             	mov    %rax,%rdi
  800bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfd:	49 b8 aa 0e 80 00 00 	movabs $0x800eaa,%r8
  800c04:	00 00 00 
  800c07:	41 ff d0             	callq  *%r8
			break;
  800c0a:	e9 8c 02 00 00       	jmpq   800e9b <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c12:	83 f8 30             	cmp    $0x30,%eax
  800c15:	73 17                	jae    800c2e <vprintfmt+0x28a>
  800c17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c1e:	89 d2                	mov    %edx,%edx
  800c20:	48 01 d0             	add    %rdx,%rax
  800c23:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c26:	83 c2 08             	add    $0x8,%edx
  800c29:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c2c:	eb 0c                	jmp    800c3a <vprintfmt+0x296>
  800c2e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c32:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c36:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c3a:	4c 8b 20             	mov    (%rax),%r12
  800c3d:	4d 85 e4             	test   %r12,%r12
  800c40:	75 0a                	jne    800c4c <vprintfmt+0x2a8>
				p = "(null)";
  800c42:	49 bc cd 4d 80 00 00 	movabs $0x804dcd,%r12
  800c49:	00 00 00 
			if (width > 0 && padc != '-')
  800c4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c50:	7e 78                	jle    800cca <vprintfmt+0x326>
  800c52:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c56:	74 72                	je     800cca <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c58:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c5b:	48 98                	cltq   
  800c5d:	48 89 c6             	mov    %rax,%rsi
  800c60:	4c 89 e7             	mov    %r12,%rdi
  800c63:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  800c6a:	00 00 00 
  800c6d:	ff d0                	callq  *%rax
  800c6f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c72:	eb 17                	jmp    800c8b <vprintfmt+0x2e7>
					putch(padc, putdat);
  800c74:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c78:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 ce             	mov    %rcx,%rsi
  800c83:	89 d7                	mov    %edx,%edi
  800c85:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c87:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c8f:	7f e3                	jg     800c74 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c91:	eb 37                	jmp    800cca <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800c93:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c97:	74 1e                	je     800cb7 <vprintfmt+0x313>
  800c99:	83 fb 1f             	cmp    $0x1f,%ebx
  800c9c:	7e 05                	jle    800ca3 <vprintfmt+0x2ff>
  800c9e:	83 fb 7e             	cmp    $0x7e,%ebx
  800ca1:	7e 14                	jle    800cb7 <vprintfmt+0x313>
					putch('?', putdat);
  800ca3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cab:	48 89 d6             	mov    %rdx,%rsi
  800cae:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cb3:	ff d0                	callq  *%rax
  800cb5:	eb 0f                	jmp    800cc6 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800cb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbf:	48 89 d6             	mov    %rdx,%rsi
  800cc2:	89 df                	mov    %ebx,%edi
  800cc4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cca:	4c 89 e0             	mov    %r12,%rax
  800ccd:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cd1:	0f b6 00             	movzbl (%rax),%eax
  800cd4:	0f be d8             	movsbl %al,%ebx
  800cd7:	85 db                	test   %ebx,%ebx
  800cd9:	74 28                	je     800d03 <vprintfmt+0x35f>
  800cdb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cdf:	78 b2                	js     800c93 <vprintfmt+0x2ef>
  800ce1:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ce5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ce9:	79 a8                	jns    800c93 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ceb:	eb 16                	jmp    800d03 <vprintfmt+0x35f>
				putch(' ', putdat);
  800ced:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf5:	48 89 d6             	mov    %rdx,%rsi
  800cf8:	bf 20 00 00 00       	mov    $0x20,%edi
  800cfd:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cff:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d03:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d07:	7f e4                	jg     800ced <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800d09:	e9 8d 01 00 00       	jmpq   800e9b <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d0e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d12:	be 03 00 00 00       	mov    $0x3,%esi
  800d17:	48 89 c7             	mov    %rax,%rdi
  800d1a:	48 b8 9d 08 80 00 00 	movabs $0x80089d,%rax
  800d21:	00 00 00 
  800d24:	ff d0                	callq  *%rax
  800d26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2e:	48 85 c0             	test   %rax,%rax
  800d31:	79 1d                	jns    800d50 <vprintfmt+0x3ac>
				putch('-', putdat);
  800d33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3b:	48 89 d6             	mov    %rdx,%rsi
  800d3e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d43:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d49:	48 f7 d8             	neg    %rax
  800d4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d50:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d57:	e9 d2 00 00 00       	jmpq   800e2e <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d60:	be 03 00 00 00       	mov    $0x3,%esi
  800d65:	48 89 c7             	mov    %rax,%rdi
  800d68:	48 b8 96 07 80 00 00 	movabs $0x800796,%rax
  800d6f:	00 00 00 
  800d72:	ff d0                	callq  *%rax
  800d74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d78:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d7f:	e9 aa 00 00 00       	jmpq   800e2e <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800d84:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d88:	be 03 00 00 00       	mov    $0x3,%esi
  800d8d:	48 89 c7             	mov    %rax,%rdi
  800d90:	48 b8 96 07 80 00 00 	movabs $0x800796,%rax
  800d97:	00 00 00 
  800d9a:	ff d0                	callq  *%rax
  800d9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800da0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800da7:	e9 82 00 00 00       	jmpq   800e2e <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800dac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db4:	48 89 d6             	mov    %rdx,%rsi
  800db7:	bf 30 00 00 00       	mov    $0x30,%edi
  800dbc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	48 89 d6             	mov    %rdx,%rsi
  800dc9:	bf 78 00 00 00       	mov    $0x78,%edi
  800dce:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dd0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd3:	83 f8 30             	cmp    $0x30,%eax
  800dd6:	73 17                	jae    800def <vprintfmt+0x44b>
  800dd8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ddf:	89 d2                	mov    %edx,%edx
  800de1:	48 01 d0             	add    %rdx,%rax
  800de4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800de7:	83 c2 08             	add    $0x8,%edx
  800dea:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ded:	eb 0c                	jmp    800dfb <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800def:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800df3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800df7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dfb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e02:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e09:	eb 23                	jmp    800e2e <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e0f:	be 03 00 00 00       	mov    $0x3,%esi
  800e14:	48 89 c7             	mov    %rax,%rdi
  800e17:	48 b8 96 07 80 00 00 	movabs $0x800796,%rax
  800e1e:	00 00 00 
  800e21:	ff d0                	callq  *%rax
  800e23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e27:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e2e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e33:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e36:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e3d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e45:	45 89 c1             	mov    %r8d,%r9d
  800e48:	41 89 f8             	mov    %edi,%r8d
  800e4b:	48 89 c7             	mov    %rax,%rdi
  800e4e:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	callq  *%rax
			break;
  800e5a:	eb 3f                	jmp    800e9b <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e64:	48 89 d6             	mov    %rdx,%rsi
  800e67:	89 df                	mov    %ebx,%edi
  800e69:	ff d0                	callq  *%rax
			break;
  800e6b:	eb 2e                	jmp    800e9b <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e75:	48 89 d6             	mov    %rdx,%rsi
  800e78:	bf 25 00 00 00       	mov    $0x25,%edi
  800e7d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e7f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e84:	eb 05                	jmp    800e8b <vprintfmt+0x4e7>
  800e86:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e8b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e8f:	48 83 e8 01          	sub    $0x1,%rax
  800e93:	0f b6 00             	movzbl (%rax),%eax
  800e96:	3c 25                	cmp    $0x25,%al
  800e98:	75 ec                	jne    800e86 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800e9a:	90                   	nop
		}
	}
  800e9b:	e9 3d fb ff ff       	jmpq   8009dd <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ea0:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ea1:	48 83 c4 60          	add    $0x60,%rsp
  800ea5:	5b                   	pop    %rbx
  800ea6:	41 5c                	pop    %r12
  800ea8:	5d                   	pop    %rbp
  800ea9:	c3                   	retq   

0000000000800eaa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eb5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ebc:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ec3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800eca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ed1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ed8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800edf:	84 c0                	test   %al,%al
  800ee1:	74 20                	je     800f03 <printfmt+0x59>
  800ee3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ee7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800eeb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ef3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ef7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800efb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800eff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f03:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f0a:	00 00 00 
  800f0d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f14:	00 00 00 
  800f17:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f1b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f22:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f29:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f30:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f37:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f3e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f45:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f4c:	48 89 c7             	mov    %rax,%rdi
  800f4f:	48 b8 a4 09 80 00 00 	movabs $0x8009a4,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f5b:	90                   	nop
  800f5c:	c9                   	leaveq 
  800f5d:	c3                   	retq   

0000000000800f5e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5e:	55                   	push   %rbp
  800f5f:	48 89 e5             	mov    %rsp,%rbp
  800f62:	48 83 ec 10          	sub    $0x10,%rsp
  800f66:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f71:	8b 40 10             	mov    0x10(%rax),%eax
  800f74:	8d 50 01             	lea    0x1(%rax),%edx
  800f77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f82:	48 8b 10             	mov    (%rax),%rdx
  800f85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f89:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f8d:	48 39 c2             	cmp    %rax,%rdx
  800f90:	73 17                	jae    800fa9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f96:	48 8b 00             	mov    (%rax),%rax
  800f99:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fa1:	48 89 0a             	mov    %rcx,(%rdx)
  800fa4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fa7:	88 10                	mov    %dl,(%rax)
}
  800fa9:	90                   	nop
  800faa:	c9                   	leaveq 
  800fab:	c3                   	retq   

0000000000800fac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fac:	55                   	push   %rbp
  800fad:	48 89 e5             	mov    %rsp,%rbp
  800fb0:	48 83 ec 50          	sub    $0x50,%rsp
  800fb4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fb8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fbb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fbf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fc3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fc7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fcb:	48 8b 0a             	mov    (%rdx),%rcx
  800fce:	48 89 08             	mov    %rcx,(%rax)
  800fd1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fdd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fe5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fe9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fec:	48 98                	cltq   
  800fee:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ff2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ff6:	48 01 d0             	add    %rdx,%rax
  800ff9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ffd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801004:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801009:	74 06                	je     801011 <vsnprintf+0x65>
  80100b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80100f:	7f 07                	jg     801018 <vsnprintf+0x6c>
		return -E_INVAL;
  801011:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801016:	eb 2f                	jmp    801047 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801018:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80101c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801020:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801024:	48 89 c6             	mov    %rax,%rsi
  801027:	48 bf 5e 0f 80 00 00 	movabs $0x800f5e,%rdi
  80102e:	00 00 00 
  801031:	48 b8 a4 09 80 00 00 	movabs $0x8009a4,%rax
  801038:	00 00 00 
  80103b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80103d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801041:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801044:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801047:	c9                   	leaveq 
  801048:	c3                   	retq   

0000000000801049 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801049:	55                   	push   %rbp
  80104a:	48 89 e5             	mov    %rsp,%rbp
  80104d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801054:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80105b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801061:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801068:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80106f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801076:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80107d:	84 c0                	test   %al,%al
  80107f:	74 20                	je     8010a1 <snprintf+0x58>
  801081:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801085:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801089:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80108d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801091:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801095:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801099:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80109d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010a1:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010a8:	00 00 00 
  8010ab:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010b2:	00 00 00 
  8010b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010b9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010c7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ce:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010d5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010dc:	48 8b 0a             	mov    (%rdx),%rcx
  8010df:	48 89 08             	mov    %rcx,(%rax)
  8010e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010f2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010f9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801100:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801106:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80110d:	48 89 c7             	mov    %rax,%rdi
  801110:	48 b8 ac 0f 80 00 00 	movabs $0x800fac,%rax
  801117:	00 00 00 
  80111a:	ff d0                	callq  *%rax
  80111c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801122:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801128:	c9                   	leaveq 
  801129:	c3                   	retq   

000000000080112a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80112a:	55                   	push   %rbp
  80112b:	48 89 e5             	mov    %rsp,%rbp
  80112e:	48 83 ec 18          	sub    $0x18,%rsp
  801132:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80113d:	eb 09                	jmp    801148 <strlen+0x1e>
		n++;
  80113f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801143:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114c:	0f b6 00             	movzbl (%rax),%eax
  80114f:	84 c0                	test   %al,%al
  801151:	75 ec                	jne    80113f <strlen+0x15>
		n++;
	return n;
  801153:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 20          	sub    $0x20,%rsp
  801160:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801164:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801168:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80116f:	eb 0e                	jmp    80117f <strnlen+0x27>
		n++;
  801171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801175:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80117a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80117f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801184:	74 0b                	je     801191 <strnlen+0x39>
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	0f b6 00             	movzbl (%rax),%eax
  80118d:	84 c0                	test   %al,%al
  80118f:	75 e0                	jne    801171 <strnlen+0x19>
		n++;
	return n;
  801191:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801194:	c9                   	leaveq 
  801195:	c3                   	retq   

0000000000801196 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801196:	55                   	push   %rbp
  801197:	48 89 e5             	mov    %rsp,%rbp
  80119a:	48 83 ec 20          	sub    $0x20,%rsp
  80119e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011ae:	90                   	nop
  8011af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011bf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011c3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011c7:	0f b6 12             	movzbl (%rdx),%edx
  8011ca:	88 10                	mov    %dl,(%rax)
  8011cc:	0f b6 00             	movzbl (%rax),%eax
  8011cf:	84 c0                	test   %al,%al
  8011d1:	75 dc                	jne    8011af <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d7:	c9                   	leaveq 
  8011d8:	c3                   	retq   

00000000008011d9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	48 83 ec 20          	sub    $0x20,%rsp
  8011e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	48 89 c7             	mov    %rax,%rdi
  8011f0:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	callq  *%rax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801202:	48 63 d0             	movslq %eax,%rdx
  801205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801209:	48 01 c2             	add    %rax,%rdx
  80120c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801210:	48 89 c6             	mov    %rax,%rsi
  801213:	48 89 d7             	mov    %rdx,%rdi
  801216:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  80121d:	00 00 00 
  801220:	ff d0                	callq  *%rax
	return dst;
  801222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801226:	c9                   	leaveq 
  801227:	c3                   	retq   

0000000000801228 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	48 83 ec 28          	sub    $0x28,%rsp
  801230:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801234:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801238:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801244:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80124b:	00 
  80124c:	eb 2a                	jmp    801278 <strncpy+0x50>
		*dst++ = *src;
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801252:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801256:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80125a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80125e:	0f b6 12             	movzbl (%rdx),%edx
  801261:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801267:	0f b6 00             	movzbl (%rax),%eax
  80126a:	84 c0                	test   %al,%al
  80126c:	74 05                	je     801273 <strncpy+0x4b>
			src++;
  80126e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801273:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801280:	72 cc                	jb     80124e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801286:	c9                   	leaveq 
  801287:	c3                   	retq   

0000000000801288 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801288:	55                   	push   %rbp
  801289:	48 89 e5             	mov    %rsp,%rbp
  80128c:	48 83 ec 28          	sub    $0x28,%rsp
  801290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801294:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801298:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012a4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012a9:	74 3d                	je     8012e8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012ab:	eb 1d                	jmp    8012ca <strlcpy+0x42>
			*dst++ = *src++;
  8012ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012bd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012c1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012c5:	0f b6 12             	movzbl (%rdx),%edx
  8012c8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012ca:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012d4:	74 0b                	je     8012e1 <strlcpy+0x59>
  8012d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	84 c0                	test   %al,%al
  8012df:	75 cc                	jne    8012ad <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f0:	48 29 c2             	sub    %rax,%rdx
  8012f3:	48 89 d0             	mov    %rdx,%rax
}
  8012f6:	c9                   	leaveq 
  8012f7:	c3                   	retq   

00000000008012f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012f8:	55                   	push   %rbp
  8012f9:	48 89 e5             	mov    %rsp,%rbp
  8012fc:	48 83 ec 10          	sub    $0x10,%rsp
  801300:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801304:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801308:	eb 0a                	jmp    801314 <strcmp+0x1c>
		p++, q++;
  80130a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	84 c0                	test   %al,%al
  80131d:	74 12                	je     801331 <strcmp+0x39>
  80131f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801323:	0f b6 10             	movzbl (%rax),%edx
  801326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132a:	0f b6 00             	movzbl (%rax),%eax
  80132d:	38 c2                	cmp    %al,%dl
  80132f:	74 d9                	je     80130a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801335:	0f b6 00             	movzbl (%rax),%eax
  801338:	0f b6 d0             	movzbl %al,%edx
  80133b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133f:	0f b6 00             	movzbl (%rax),%eax
  801342:	0f b6 c0             	movzbl %al,%eax
  801345:	29 c2                	sub    %eax,%edx
  801347:	89 d0                	mov    %edx,%eax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 18          	sub    $0x18,%rsp
  801353:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801357:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80135b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80135f:	eb 0f                	jmp    801370 <strncmp+0x25>
		n--, p++, q++;
  801361:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801366:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801370:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801375:	74 1d                	je     801394 <strncmp+0x49>
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	84 c0                	test   %al,%al
  801380:	74 12                	je     801394 <strncmp+0x49>
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	0f b6 10             	movzbl (%rax),%edx
  801389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	38 c2                	cmp    %al,%dl
  801392:	74 cd                	je     801361 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801394:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801399:	75 07                	jne    8013a2 <strncmp+0x57>
		return 0;
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a0:	eb 18                	jmp    8013ba <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	0f b6 d0             	movzbl %al,%edx
  8013ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b0:	0f b6 00             	movzbl (%rax),%eax
  8013b3:	0f b6 c0             	movzbl %al,%eax
  8013b6:	29 c2                	sub    %eax,%edx
  8013b8:	89 d0                	mov    %edx,%eax
}
  8013ba:	c9                   	leaveq 
  8013bb:	c3                   	retq   

00000000008013bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bc:	55                   	push   %rbp
  8013bd:	48 89 e5             	mov    %rsp,%rbp
  8013c0:	48 83 ec 10          	sub    $0x10,%rsp
  8013c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c8:	89 f0                	mov    %esi,%eax
  8013ca:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013cd:	eb 17                	jmp    8013e6 <strchr+0x2a>
		if (*s == c)
  8013cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d3:	0f b6 00             	movzbl (%rax),%eax
  8013d6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013d9:	75 06                	jne    8013e1 <strchr+0x25>
			return (char *) s;
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	eb 15                	jmp    8013f6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	84 c0                	test   %al,%al
  8013ef:	75 de                	jne    8013cf <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f6:	c9                   	leaveq 
  8013f7:	c3                   	retq   

00000000008013f8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	48 83 ec 10          	sub    $0x10,%rsp
  801400:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801404:	89 f0                	mov    %esi,%eax
  801406:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801409:	eb 11                	jmp    80141c <strfind+0x24>
		if (*s == c)
  80140b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801415:	74 12                	je     801429 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801417:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	84 c0                	test   %al,%al
  801425:	75 e4                	jne    80140b <strfind+0x13>
  801427:	eb 01                	jmp    80142a <strfind+0x32>
		if (*s == c)
			break;
  801429:	90                   	nop
	return (char *) s;
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80142e:	c9                   	leaveq 
  80142f:	c3                   	retq   

0000000000801430 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801430:	55                   	push   %rbp
  801431:	48 89 e5             	mov    %rsp,%rbp
  801434:	48 83 ec 18          	sub    $0x18,%rsp
  801438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80143f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801443:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801448:	75 06                	jne    801450 <memset+0x20>
		return v;
  80144a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144e:	eb 69                	jmp    8014b9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801454:	83 e0 03             	and    $0x3,%eax
  801457:	48 85 c0             	test   %rax,%rax
  80145a:	75 48                	jne    8014a4 <memset+0x74>
  80145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801460:	83 e0 03             	and    $0x3,%eax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 3c                	jne    8014a4 <memset+0x74>
		c &= 0xFF;
  801468:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80146f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801472:	c1 e0 18             	shl    $0x18,%eax
  801475:	89 c2                	mov    %eax,%edx
  801477:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80147a:	c1 e0 10             	shl    $0x10,%eax
  80147d:	09 c2                	or     %eax,%edx
  80147f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801482:	c1 e0 08             	shl    $0x8,%eax
  801485:	09 d0                	or     %edx,%eax
  801487:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148e:	48 c1 e8 02          	shr    $0x2,%rax
  801492:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801495:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801499:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80149c:	48 89 d7             	mov    %rdx,%rdi
  80149f:	fc                   	cld    
  8014a0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014a2:	eb 11                	jmp    8014b5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014af:	48 89 d7             	mov    %rdx,%rdi
  8014b2:	fc                   	cld    
  8014b3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014b9:	c9                   	leaveq 
  8014ba:	c3                   	retq   

00000000008014bb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014bb:	55                   	push   %rbp
  8014bc:	48 89 e5             	mov    %rsp,%rbp
  8014bf:	48 83 ec 28          	sub    $0x28,%rsp
  8014c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e7:	0f 83 88 00 00 00    	jae    801575 <memmove+0xba>
  8014ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	48 01 d0             	add    %rdx,%rax
  8014f8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014fc:	76 77                	jbe    801575 <memmove+0xba>
		s += n;
  8014fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801502:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80150e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801512:	83 e0 03             	and    $0x3,%eax
  801515:	48 85 c0             	test   %rax,%rax
  801518:	75 3b                	jne    801555 <memmove+0x9a>
  80151a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151e:	83 e0 03             	and    $0x3,%eax
  801521:	48 85 c0             	test   %rax,%rax
  801524:	75 2f                	jne    801555 <memmove+0x9a>
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	83 e0 03             	and    $0x3,%eax
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	75 23                	jne    801555 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801536:	48 83 e8 04          	sub    $0x4,%rax
  80153a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153e:	48 83 ea 04          	sub    $0x4,%rdx
  801542:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801546:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80154a:	48 89 c7             	mov    %rax,%rdi
  80154d:	48 89 d6             	mov    %rdx,%rsi
  801550:	fd                   	std    
  801551:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801553:	eb 1d                	jmp    801572 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801559:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80155d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801561:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 89 d7             	mov    %rdx,%rdi
  80156c:	48 89 c1             	mov    %rax,%rcx
  80156f:	fd                   	std    
  801570:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801572:	fc                   	cld    
  801573:	eb 57                	jmp    8015cc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801579:	83 e0 03             	and    $0x3,%eax
  80157c:	48 85 c0             	test   %rax,%rax
  80157f:	75 36                	jne    8015b7 <memmove+0xfc>
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	83 e0 03             	and    $0x3,%eax
  801588:	48 85 c0             	test   %rax,%rax
  80158b:	75 2a                	jne    8015b7 <memmove+0xfc>
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	83 e0 03             	and    $0x3,%eax
  801594:	48 85 c0             	test   %rax,%rax
  801597:	75 1e                	jne    8015b7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159d:	48 c1 e8 02          	shr    $0x2,%rax
  8015a1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ac:	48 89 c7             	mov    %rax,%rdi
  8015af:	48 89 d6             	mov    %rdx,%rsi
  8015b2:	fc                   	cld    
  8015b3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b5:	eb 15                	jmp    8015cc <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015bf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c3:	48 89 c7             	mov    %rax,%rdi
  8015c6:	48 89 d6             	mov    %rdx,%rsi
  8015c9:	fc                   	cld    
  8015ca:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d0:	c9                   	leaveq 
  8015d1:	c3                   	retq   

00000000008015d2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015d2:	55                   	push   %rbp
  8015d3:	48 89 e5             	mov    %rsp,%rbp
  8015d6:	48 83 ec 18          	sub    $0x18,%rsp
  8015da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ea:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f2:	48 89 ce             	mov    %rcx,%rsi
  8015f5:	48 89 c7             	mov    %rax,%rdi
  8015f8:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  8015ff:	00 00 00 
  801602:	ff d0                	callq  *%rax
}
  801604:	c9                   	leaveq 
  801605:	c3                   	retq   

0000000000801606 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801606:	55                   	push   %rbp
  801607:	48 89 e5             	mov    %rsp,%rbp
  80160a:	48 83 ec 28          	sub    $0x28,%rsp
  80160e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801612:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801616:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801622:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801626:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80162a:	eb 36                	jmp    801662 <memcmp+0x5c>
		if (*s1 != *s2)
  80162c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801630:	0f b6 10             	movzbl (%rax),%edx
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	38 c2                	cmp    %al,%dl
  80163c:	74 1a                	je     801658 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80163e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	0f b6 d0             	movzbl %al,%edx
  801648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	0f b6 c0             	movzbl %al,%eax
  801652:	29 c2                	sub    %eax,%edx
  801654:	89 d0                	mov    %edx,%eax
  801656:	eb 20                	jmp    801678 <memcmp+0x72>
		s1++, s2++;
  801658:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80165d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80166a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80166e:	48 85 c0             	test   %rax,%rax
  801671:	75 b9                	jne    80162c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 28          	sub    $0x28,%rsp
  801682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801686:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801689:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80168d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	48 01 d0             	add    %rdx,%rax
  801698:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80169c:	eb 19                	jmp    8016b7 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80169e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	0f b6 d0             	movzbl %al,%edx
  8016a8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016ab:	0f b6 c0             	movzbl %al,%eax
  8016ae:	39 c2                	cmp    %eax,%edx
  8016b0:	74 11                	je     8016c3 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016b2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016bf:	72 dd                	jb     80169e <memfind+0x24>
  8016c1:	eb 01                	jmp    8016c4 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016c3:	90                   	nop
	return (void *) s;
  8016c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c8:	c9                   	leaveq 
  8016c9:	c3                   	retq   

00000000008016ca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016ca:	55                   	push   %rbp
  8016cb:	48 89 e5             	mov    %rsp,%rbp
  8016ce:	48 83 ec 38          	sub    $0x38,%rsp
  8016d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016da:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016e4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016eb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ec:	eb 05                	jmp    8016f3 <strtol+0x29>
		s++;
  8016ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	3c 20                	cmp    $0x20,%al
  8016fc:	74 f0                	je     8016ee <strtol+0x24>
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	3c 09                	cmp    $0x9,%al
  801707:	74 e5                	je     8016ee <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170d:	0f b6 00             	movzbl (%rax),%eax
  801710:	3c 2b                	cmp    $0x2b,%al
  801712:	75 07                	jne    80171b <strtol+0x51>
		s++;
  801714:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801719:	eb 17                	jmp    801732 <strtol+0x68>
	else if (*s == '-')
  80171b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171f:	0f b6 00             	movzbl (%rax),%eax
  801722:	3c 2d                	cmp    $0x2d,%al
  801724:	75 0c                	jne    801732 <strtol+0x68>
		s++, neg = 1;
  801726:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80172b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801732:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801736:	74 06                	je     80173e <strtol+0x74>
  801738:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80173c:	75 28                	jne    801766 <strtol+0x9c>
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	0f b6 00             	movzbl (%rax),%eax
  801745:	3c 30                	cmp    $0x30,%al
  801747:	75 1d                	jne    801766 <strtol+0x9c>
  801749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174d:	48 83 c0 01          	add    $0x1,%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 78                	cmp    $0x78,%al
  801756:	75 0e                	jne    801766 <strtol+0x9c>
		s += 2, base = 16;
  801758:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80175d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801764:	eb 2c                	jmp    801792 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801766:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80176a:	75 19                	jne    801785 <strtol+0xbb>
  80176c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801770:	0f b6 00             	movzbl (%rax),%eax
  801773:	3c 30                	cmp    $0x30,%al
  801775:	75 0e                	jne    801785 <strtol+0xbb>
		s++, base = 8;
  801777:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80177c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801783:	eb 0d                	jmp    801792 <strtol+0xc8>
	else if (base == 0)
  801785:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801789:	75 07                	jne    801792 <strtol+0xc8>
		base = 10;
  80178b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	3c 2f                	cmp    $0x2f,%al
  80179b:	7e 1d                	jle    8017ba <strtol+0xf0>
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	3c 39                	cmp    $0x39,%al
  8017a6:	7f 12                	jg     8017ba <strtol+0xf0>
			dig = *s - '0';
  8017a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	0f be c0             	movsbl %al,%eax
  8017b2:	83 e8 30             	sub    $0x30,%eax
  8017b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017b8:	eb 4e                	jmp    801808 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017be:	0f b6 00             	movzbl (%rax),%eax
  8017c1:	3c 60                	cmp    $0x60,%al
  8017c3:	7e 1d                	jle    8017e2 <strtol+0x118>
  8017c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c9:	0f b6 00             	movzbl (%rax),%eax
  8017cc:	3c 7a                	cmp    $0x7a,%al
  8017ce:	7f 12                	jg     8017e2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	0f b6 00             	movzbl (%rax),%eax
  8017d7:	0f be c0             	movsbl %al,%eax
  8017da:	83 e8 57             	sub    $0x57,%eax
  8017dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017e0:	eb 26                	jmp    801808 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	0f b6 00             	movzbl (%rax),%eax
  8017e9:	3c 40                	cmp    $0x40,%al
  8017eb:	7e 47                	jle    801834 <strtol+0x16a>
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	0f b6 00             	movzbl (%rax),%eax
  8017f4:	3c 5a                	cmp    $0x5a,%al
  8017f6:	7f 3c                	jg     801834 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fc:	0f b6 00             	movzbl (%rax),%eax
  8017ff:	0f be c0             	movsbl %al,%eax
  801802:	83 e8 37             	sub    $0x37,%eax
  801805:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801808:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80180b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80180e:	7d 23                	jge    801833 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801810:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801815:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801818:	48 98                	cltq   
  80181a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80181f:	48 89 c2             	mov    %rax,%rdx
  801822:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801825:	48 98                	cltq   
  801827:	48 01 d0             	add    %rdx,%rax
  80182a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80182e:	e9 5f ff ff ff       	jmpq   801792 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801833:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801834:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801839:	74 0b                	je     801846 <strtol+0x17c>
		*endptr = (char *) s;
  80183b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801843:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80184a:	74 09                	je     801855 <strtol+0x18b>
  80184c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801850:	48 f7 d8             	neg    %rax
  801853:	eb 04                	jmp    801859 <strtol+0x18f>
  801855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801859:	c9                   	leaveq 
  80185a:	c3                   	retq   

000000000080185b <strstr>:

char * strstr(const char *in, const char *str)
{
  80185b:	55                   	push   %rbp
  80185c:	48 89 e5             	mov    %rsp,%rbp
  80185f:	48 83 ec 30          	sub    $0x30,%rsp
  801863:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801867:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80186b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801873:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801877:	0f b6 00             	movzbl (%rax),%eax
  80187a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80187d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801881:	75 06                	jne    801889 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	eb 6b                	jmp    8018f4 <strstr+0x99>

	len = strlen(str);
  801889:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80188d:	48 89 c7             	mov    %rax,%rdi
  801890:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  801897:	00 00 00 
  80189a:	ff d0                	callq  *%rax
  80189c:	48 98                	cltq   
  80189e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018ae:	0f b6 00             	movzbl (%rax),%eax
  8018b1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018b4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018b8:	75 07                	jne    8018c1 <strstr+0x66>
				return (char *) 0;
  8018ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bf:	eb 33                	jmp    8018f4 <strstr+0x99>
		} while (sc != c);
  8018c1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018c5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018c8:	75 d8                	jne    8018a2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d6:	48 89 ce             	mov    %rcx,%rsi
  8018d9:	48 89 c7             	mov    %rax,%rdi
  8018dc:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  8018e3:	00 00 00 
  8018e6:	ff d0                	callq  *%rax
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	75 b6                	jne    8018a2 <strstr+0x47>

	return (char *) (in - 1);
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	48 83 e8 01          	sub    $0x1,%rax
}
  8018f4:	c9                   	leaveq 
  8018f5:	c3                   	retq   

00000000008018f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018f6:	55                   	push   %rbp
  8018f7:	48 89 e5             	mov    %rsp,%rbp
  8018fa:	53                   	push   %rbx
  8018fb:	48 83 ec 48          	sub    $0x48,%rsp
  8018ff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801902:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801905:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801909:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80190d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801911:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801915:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801918:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80191c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801920:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801924:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801928:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80192c:	4c 89 c3             	mov    %r8,%rbx
  80192f:	cd 30                	int    $0x30
  801931:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801935:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801939:	74 3e                	je     801979 <syscall+0x83>
  80193b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801940:	7e 37                	jle    801979 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801946:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801949:	49 89 d0             	mov    %rdx,%r8
  80194c:	89 c1                	mov    %eax,%ecx
  80194e:	48 ba 88 50 80 00 00 	movabs $0x805088,%rdx
  801955:	00 00 00 
  801958:	be 24 00 00 00       	mov    $0x24,%esi
  80195d:	48 bf a5 50 80 00 00 	movabs $0x8050a5,%rdi
  801964:	00 00 00 
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
  80196c:	49 b9 cc 03 80 00 00 	movabs $0x8003cc,%r9
  801973:	00 00 00 
  801976:	41 ff d1             	callq  *%r9

	return ret;
  801979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80197d:	48 83 c4 48          	add    $0x48,%rsp
  801981:	5b                   	pop    %rbx
  801982:	5d                   	pop    %rbp
  801983:	c3                   	retq   

0000000000801984 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801984:	55                   	push   %rbp
  801985:	48 89 e5             	mov    %rsp,%rbp
  801988:	48 83 ec 10          	sub    $0x10,%rsp
  80198c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801990:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	48 83 ec 08          	sub    $0x8,%rsp
  8019a0:	6a 00                	pushq  $0x0
  8019a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ae:	48 89 d1             	mov    %rdx,%rcx
  8019b1:	48 89 c2             	mov    %rax,%rdx
  8019b4:	be 00 00 00 00       	mov    $0x0,%esi
  8019b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8019be:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  8019c5:	00 00 00 
  8019c8:	ff d0                	callq  *%rax
  8019ca:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ce:	90                   	nop
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019d5:	48 83 ec 08          	sub    $0x8,%rsp
  8019d9:	6a 00                	pushq  $0x0
  8019db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f1:	be 00 00 00 00       	mov    $0x0,%esi
  8019f6:	bf 01 00 00 00       	mov    $0x1,%edi
  8019fb:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
  801a07:	48 83 c4 10          	add    $0x10,%rsp
}
  801a0b:	c9                   	leaveq 
  801a0c:	c3                   	retq   

0000000000801a0d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a0d:	55                   	push   %rbp
  801a0e:	48 89 e5             	mov    %rsp,%rbp
  801a11:	48 83 ec 10          	sub    $0x10,%rsp
  801a15:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1b:	48 98                	cltq   
  801a1d:	48 83 ec 08          	sub    $0x8,%rsp
  801a21:	6a 00                	pushq  $0x0
  801a23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a34:	48 89 c2             	mov    %rax,%rdx
  801a37:	be 01 00 00 00       	mov    $0x1,%esi
  801a3c:	bf 03 00 00 00       	mov    $0x3,%edi
  801a41:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	callq  *%rax
  801a4d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a57:	48 83 ec 08          	sub    $0x8,%rsp
  801a5b:	6a 00                	pushq  $0x0
  801a5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a73:	be 00 00 00 00       	mov    $0x0,%esi
  801a78:	bf 02 00 00 00       	mov    $0x2,%edi
  801a7d:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801a84:	00 00 00 
  801a87:	ff d0                	callq  *%rax
  801a89:	48 83 c4 10          	add    $0x10,%rsp
}
  801a8d:	c9                   	leaveq 
  801a8e:	c3                   	retq   

0000000000801a8f <sys_yield>:


void
sys_yield(void)
{
  801a8f:	55                   	push   %rbp
  801a90:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a93:	48 83 ec 08          	sub    $0x8,%rsp
  801a97:	6a 00                	pushq  $0x0
  801a99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaf:	be 00 00 00 00       	mov    $0x0,%esi
  801ab4:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ab9:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801ac0:	00 00 00 
  801ac3:	ff d0                	callq  *%rax
  801ac5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ac9:	90                   	nop
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 10          	sub    $0x10,%rsp
  801ad4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801adb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ade:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae1:	48 63 c8             	movslq %eax,%rcx
  801ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aeb:	48 98                	cltq   
  801aed:	48 83 ec 08          	sub    $0x8,%rsp
  801af1:	6a 00                	pushq  $0x0
  801af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af9:	49 89 c8             	mov    %rcx,%r8
  801afc:	48 89 d1             	mov    %rdx,%rcx
  801aff:	48 89 c2             	mov    %rax,%rdx
  801b02:	be 01 00 00 00       	mov    $0x1,%esi
  801b07:	bf 04 00 00 00       	mov    $0x4,%edi
  801b0c:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
  801b18:	48 83 c4 10          	add    $0x10,%rsp
}
  801b1c:	c9                   	leaveq 
  801b1d:	c3                   	retq   

0000000000801b1e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b1e:	55                   	push   %rbp
  801b1f:	48 89 e5             	mov    %rsp,%rbp
  801b22:	48 83 ec 20          	sub    $0x20,%rsp
  801b26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b2d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b30:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b34:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b38:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b3b:	48 63 c8             	movslq %eax,%rcx
  801b3e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b45:	48 63 f0             	movslq %eax,%rsi
  801b48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4f:	48 98                	cltq   
  801b51:	48 83 ec 08          	sub    $0x8,%rsp
  801b55:	51                   	push   %rcx
  801b56:	49 89 f9             	mov    %rdi,%r9
  801b59:	49 89 f0             	mov    %rsi,%r8
  801b5c:	48 89 d1             	mov    %rdx,%rcx
  801b5f:	48 89 c2             	mov    %rax,%rdx
  801b62:	be 01 00 00 00       	mov    $0x1,%esi
  801b67:	bf 05 00 00 00       	mov    $0x5,%edi
  801b6c:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801b73:	00 00 00 
  801b76:	ff d0                	callq  *%rax
  801b78:	48 83 c4 10          	add    $0x10,%rsp
}
  801b7c:	c9                   	leaveq 
  801b7d:	c3                   	retq   

0000000000801b7e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b7e:	55                   	push   %rbp
  801b7f:	48 89 e5             	mov    %rsp,%rbp
  801b82:	48 83 ec 10          	sub    $0x10,%rsp
  801b86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b94:	48 98                	cltq   
  801b96:	48 83 ec 08          	sub    $0x8,%rsp
  801b9a:	6a 00                	pushq  $0x0
  801b9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba8:	48 89 d1             	mov    %rdx,%rcx
  801bab:	48 89 c2             	mov    %rax,%rdx
  801bae:	be 01 00 00 00       	mov    $0x1,%esi
  801bb3:	bf 06 00 00 00       	mov    $0x6,%edi
  801bb8:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
  801bc4:	48 83 c4 10          	add    $0x10,%rsp
}
  801bc8:	c9                   	leaveq 
  801bc9:	c3                   	retq   

0000000000801bca <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	48 83 ec 10          	sub    $0x10,%rsp
  801bd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bdb:	48 63 d0             	movslq %eax,%rdx
  801bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be1:	48 98                	cltq   
  801be3:	48 83 ec 08          	sub    $0x8,%rsp
  801be7:	6a 00                	pushq  $0x0
  801be9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf5:	48 89 d1             	mov    %rdx,%rcx
  801bf8:	48 89 c2             	mov    %rax,%rdx
  801bfb:	be 01 00 00 00       	mov    $0x1,%esi
  801c00:	bf 08 00 00 00       	mov    $0x8,%edi
  801c05:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801c0c:	00 00 00 
  801c0f:	ff d0                	callq  *%rax
  801c11:	48 83 c4 10          	add    $0x10,%rsp
}
  801c15:	c9                   	leaveq 
  801c16:	c3                   	retq   

0000000000801c17 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c17:	55                   	push   %rbp
  801c18:	48 89 e5             	mov    %rsp,%rbp
  801c1b:	48 83 ec 10          	sub    $0x10,%rsp
  801c1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2d:	48 98                	cltq   
  801c2f:	48 83 ec 08          	sub    $0x8,%rsp
  801c33:	6a 00                	pushq  $0x0
  801c35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c41:	48 89 d1             	mov    %rdx,%rcx
  801c44:	48 89 c2             	mov    %rax,%rdx
  801c47:	be 01 00 00 00       	mov    $0x1,%esi
  801c4c:	bf 09 00 00 00       	mov    $0x9,%edi
  801c51:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
  801c5d:	48 83 c4 10          	add    $0x10,%rsp
}
  801c61:	c9                   	leaveq 
  801c62:	c3                   	retq   

0000000000801c63 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c63:	55                   	push   %rbp
  801c64:	48 89 e5             	mov    %rsp,%rbp
  801c67:	48 83 ec 10          	sub    $0x10,%rsp
  801c6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c79:	48 98                	cltq   
  801c7b:	48 83 ec 08          	sub    $0x8,%rsp
  801c7f:	6a 00                	pushq  $0x0
  801c81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8d:	48 89 d1             	mov    %rdx,%rcx
  801c90:	48 89 c2             	mov    %rax,%rdx
  801c93:	be 01 00 00 00       	mov    $0x1,%esi
  801c98:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c9d:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	callq  *%rax
  801ca9:	48 83 c4 10          	add    $0x10,%rsp
}
  801cad:	c9                   	leaveq 
  801cae:	c3                   	retq   

0000000000801caf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801caf:	55                   	push   %rbp
  801cb0:	48 89 e5             	mov    %rsp,%rbp
  801cb3:	48 83 ec 20          	sub    $0x20,%rsp
  801cb7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cbe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cc2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cc8:	48 63 f0             	movslq %eax,%rsi
  801ccb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ccf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd2:	48 98                	cltq   
  801cd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd8:	48 83 ec 08          	sub    $0x8,%rsp
  801cdc:	6a 00                	pushq  $0x0
  801cde:	49 89 f1             	mov    %rsi,%r9
  801ce1:	49 89 c8             	mov    %rcx,%r8
  801ce4:	48 89 d1             	mov    %rdx,%rcx
  801ce7:	48 89 c2             	mov    %rax,%rdx
  801cea:	be 00 00 00 00       	mov    $0x0,%esi
  801cef:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cf4:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
  801d00:	48 83 c4 10          	add    $0x10,%rsp
}
  801d04:	c9                   	leaveq 
  801d05:	c3                   	retq   

0000000000801d06 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d06:	55                   	push   %rbp
  801d07:	48 89 e5             	mov    %rsp,%rbp
  801d0a:	48 83 ec 10          	sub    $0x10,%rsp
  801d0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d16:	48 83 ec 08          	sub    $0x8,%rsp
  801d1a:	6a 00                	pushq  $0x0
  801d1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d2d:	48 89 c2             	mov    %rax,%rdx
  801d30:	be 01 00 00 00       	mov    $0x1,%esi
  801d35:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d3a:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801d41:	00 00 00 
  801d44:	ff d0                	callq  *%rax
  801d46:	48 83 c4 10          	add    $0x10,%rsp
}
  801d4a:	c9                   	leaveq 
  801d4b:	c3                   	retq   

0000000000801d4c <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d4c:	55                   	push   %rbp
  801d4d:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d50:	48 83 ec 08          	sub    $0x8,%rsp
  801d54:	6a 00                	pushq  $0x0
  801d56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d62:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d67:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6c:	be 00 00 00 00       	mov    $0x0,%esi
  801d71:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d76:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
  801d82:	48 83 c4 10          	add    $0x10,%rsp
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 10          	sub    $0x10,%rsp
  801d90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d94:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801d97:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9e:	48 83 ec 08          	sub    $0x8,%rsp
  801da2:	6a 00                	pushq  $0x0
  801da4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db0:	48 89 d1             	mov    %rdx,%rcx
  801db3:	48 89 c2             	mov    %rax,%rdx
  801db6:	be 00 00 00 00       	mov    $0x0,%esi
  801dbb:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dc0:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	callq  *%rax
  801dcc:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd0:	c9                   	leaveq 
  801dd1:	c3                   	retq   

0000000000801dd2 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801dd2:	55                   	push   %rbp
  801dd3:	48 89 e5             	mov    %rsp,%rbp
  801dd6:	48 83 ec 10          	sub    $0x10,%rsp
  801dda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dde:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801de1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801de4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de8:	48 83 ec 08          	sub    $0x8,%rsp
  801dec:	6a 00                	pushq  $0x0
  801dee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfa:	48 89 d1             	mov    %rdx,%rcx
  801dfd:	48 89 c2             	mov    %rax,%rdx
  801e00:	be 00 00 00 00       	mov    $0x0,%esi
  801e05:	bf 10 00 00 00       	mov    $0x10,%edi
  801e0a:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	callq  *%rax
  801e16:	48 83 c4 10          	add    $0x10,%rsp
}
  801e1a:	c9                   	leaveq 
  801e1b:	c3                   	retq   

0000000000801e1c <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e1c:	55                   	push   %rbp
  801e1d:	48 89 e5             	mov    %rsp,%rbp
  801e20:	48 83 ec 20          	sub    $0x20,%rsp
  801e24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e2b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e2e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e32:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e36:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e39:	48 63 c8             	movslq %eax,%rcx
  801e3c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e43:	48 63 f0             	movslq %eax,%rsi
  801e46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4d:	48 98                	cltq   
  801e4f:	48 83 ec 08          	sub    $0x8,%rsp
  801e53:	51                   	push   %rcx
  801e54:	49 89 f9             	mov    %rdi,%r9
  801e57:	49 89 f0             	mov    %rsi,%r8
  801e5a:	48 89 d1             	mov    %rdx,%rcx
  801e5d:	48 89 c2             	mov    %rax,%rdx
  801e60:	be 00 00 00 00       	mov    $0x0,%esi
  801e65:	bf 11 00 00 00       	mov    $0x11,%edi
  801e6a:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
  801e76:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e7a:	c9                   	leaveq 
  801e7b:	c3                   	retq   

0000000000801e7c <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e7c:	55                   	push   %rbp
  801e7d:	48 89 e5             	mov    %rsp,%rbp
  801e80:	48 83 ec 10          	sub    $0x10,%rsp
  801e84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e94:	48 83 ec 08          	sub    $0x8,%rsp
  801e98:	6a 00                	pushq  $0x0
  801e9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea6:	48 89 d1             	mov    %rdx,%rcx
  801ea9:	48 89 c2             	mov    %rax,%rdx
  801eac:	be 00 00 00 00       	mov    $0x0,%esi
  801eb1:	bf 12 00 00 00       	mov    $0x12,%edi
  801eb6:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
  801ec2:	48 83 c4 10          	add    $0x10,%rsp
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 30          	sub    $0x30,%rsp
  801ed0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ed4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed8:	48 8b 00             	mov    (%rax),%rax
  801edb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801edf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee3:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eed:	83 e0 02             	and    $0x2,%eax
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	75 40                	jne    801f34 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801ef4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef8:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801eff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f03:	49 89 d0             	mov    %rdx,%r8
  801f06:	48 89 c1             	mov    %rax,%rcx
  801f09:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  801f10:	00 00 00 
  801f13:	be 1f 00 00 00       	mov    $0x1f,%esi
  801f18:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  801f1f:	00 00 00 
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	49 b9 cc 03 80 00 00 	movabs $0x8003cc,%r9
  801f2e:	00 00 00 
  801f31:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801f34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f38:	48 c1 e8 0c          	shr    $0xc,%rax
  801f3c:	48 89 c2             	mov    %rax,%rdx
  801f3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f46:	01 00 00 
  801f49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4d:	25 07 08 00 00       	and    $0x807,%eax
  801f52:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801f58:	74 4e                	je     801fa8 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801f5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f5e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6c:	01 00 00 
  801f6f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f77:	49 89 d0             	mov    %rdx,%r8
  801f7a:	48 89 c1             	mov    %rax,%rcx
  801f7d:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801f84:	00 00 00 
  801f87:	be 22 00 00 00       	mov    $0x22,%esi
  801f8c:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  801f93:	00 00 00 
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	49 b9 cc 03 80 00 00 	movabs $0x8003cc,%r9
  801fa2:	00 00 00 
  801fa5:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fa8:	ba 07 00 00 00       	mov    $0x7,%edx
  801fad:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb7:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  801fbe:	00 00 00 
  801fc1:	ff d0                	callq  *%rax
  801fc3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801fc6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801fca:	79 30                	jns    801ffc <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801fcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	48 ba 0b 51 80 00 00 	movabs $0x80510b,%rdx
  801fd8:	00 00 00 
  801fdb:	be 28 00 00 00       	mov    $0x28,%esi
  801fe0:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  801fe7:	00 00 00 
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  801ff6:	00 00 00 
  801ff9:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801ffc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802000:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802008:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80200e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802013:	48 89 c6             	mov    %rax,%rsi
  802016:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80201b:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  802022:	00 00 00 
  802025:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802027:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80202f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802033:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802039:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80203f:	48 89 c1             	mov    %rax,%rcx
  802042:	ba 00 00 00 00       	mov    $0x0,%edx
  802047:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80204c:	bf 00 00 00 00       	mov    $0x0,%edi
  802051:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
  80205d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802060:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802064:	79 30                	jns    802096 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802066:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802069:	89 c1                	mov    %eax,%ecx
  80206b:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  802072:	00 00 00 
  802075:	be 2d 00 00 00       	mov    $0x2d,%esi
  80207a:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  802081:	00 00 00 
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
  802089:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  802090:	00 00 00 
  802093:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802096:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80209b:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a0:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8020a7:	00 00 00 
  8020aa:	ff d0                	callq  *%rax
  8020ac:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020b3:	79 30                	jns    8020e5 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8020b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020b8:	89 c1                	mov    %eax,%ecx
  8020ba:	48 ba 2f 51 80 00 00 	movabs $0x80512f,%rdx
  8020c1:	00 00 00 
  8020c4:	be 31 00 00 00       	mov    $0x31,%esi
  8020c9:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8020d0:	00 00 00 
  8020d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d8:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8020df:	00 00 00 
  8020e2:	41 ff d0             	callq  *%r8

}
  8020e5:	90                   	nop
  8020e6:	c9                   	leaveq 
  8020e7:	c3                   	retq   

00000000008020e8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020e8:	55                   	push   %rbp
  8020e9:	48 89 e5             	mov    %rsp,%rbp
  8020ec:	48 83 ec 30          	sub    $0x30,%rsp
  8020f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020f3:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8020f6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8020f9:	c1 e0 0c             	shl    $0xc,%eax
  8020fc:	89 c0                	mov    %eax,%eax
  8020fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802102:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802109:	01 00 00 
  80210c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80210f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802113:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80211b:	25 02 08 00 00       	and    $0x802,%eax
  802120:	48 85 c0             	test   %rax,%rax
  802123:	74 0e                	je     802133 <duppage+0x4b>
  802125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802129:	25 00 04 00 00       	and    $0x400,%eax
  80212e:	48 85 c0             	test   %rax,%rax
  802131:	74 70                	je     8021a3 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802137:	25 07 0e 00 00       	and    $0xe07,%eax
  80213c:	89 c6                	mov    %eax,%esi
  80213e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802142:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802149:	41 89 f0             	mov    %esi,%r8d
  80214c:	48 89 c6             	mov    %rax,%rsi
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
  802154:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802163:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802167:	79 30                	jns    802199 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802169:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80216c:	89 c1                	mov    %eax,%ecx
  80216e:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  802175:	00 00 00 
  802178:	be 50 00 00 00       	mov    $0x50,%esi
  80217d:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  802184:	00 00 00 
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  802193:	00 00 00 
  802196:	41 ff d0             	callq  *%r8
		return 0;
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	e9 c4 00 00 00       	jmpq   802267 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8021a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8021a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ae:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8021b4:	48 89 c6             	mov    %rax,%rsi
  8021b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bc:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8021c3:	00 00 00 
  8021c6:	ff d0                	callq  *%rax
  8021c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021cf:	79 30                	jns    802201 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8021d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d4:	89 c1                	mov    %eax,%ecx
  8021d6:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  8021dd:	00 00 00 
  8021e0:	be 64 00 00 00       	mov    $0x64,%esi
  8021e5:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8021ec:	00 00 00 
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8021fb:	00 00 00 
  8021fe:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802201:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802209:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80220f:	48 89 d1             	mov    %rdx,%rcx
  802212:	ba 00 00 00 00       	mov    $0x0,%edx
  802217:	48 89 c6             	mov    %rax,%rsi
  80221a:	bf 00 00 00 00       	mov    $0x0,%edi
  80221f:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
  80222b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80222e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802232:	79 30                	jns    802264 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802234:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802237:	89 c1                	mov    %eax,%ecx
  802239:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  802240:	00 00 00 
  802243:	be 66 00 00 00       	mov    $0x66,%esi
  802248:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  80224f:	00 00 00 
  802252:	b8 00 00 00 00       	mov    $0x0,%eax
  802257:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  80225e:	00 00 00 
  802261:	41 ff d0             	callq  *%r8
	return r;
  802264:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802267:	c9                   	leaveq 
  802268:	c3                   	retq   

0000000000802269 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802269:	55                   	push   %rbp
  80226a:	48 89 e5             	mov    %rsp,%rbp
  80226d:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802271:	48 bf c8 1e 80 00 00 	movabs $0x801ec8,%rdi
  802278:	00 00 00 
  80227b:	48 b8 8e 45 80 00 00 	movabs $0x80458e,%rax
  802282:	00 00 00 
  802285:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802287:	b8 07 00 00 00       	mov    $0x7,%eax
  80228c:	cd 30                	int    $0x30
  80228e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802291:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802294:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802297:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80229b:	79 08                	jns    8022a5 <fork+0x3c>
		return envid;
  80229d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022a0:	e9 0b 02 00 00       	jmpq   8024b0 <fork+0x247>
	if (envid == 0) {
  8022a5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022a9:	75 3e                	jne    8022e9 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8022ab:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
  8022b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022bc:	48 98                	cltq   
  8022be:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8022c5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022cc:	00 00 00 
  8022cf:	48 01 c2             	add    %rax,%rdx
  8022d2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022d9:	00 00 00 
  8022dc:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	e9 c7 01 00 00       	jmpq   8024b0 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8022e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022f0:	e9 a6 00 00 00       	jmpq   80239b <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8022f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f8:	c1 f8 12             	sar    $0x12,%eax
  8022fb:	89 c2                	mov    %eax,%edx
  8022fd:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802304:	01 00 00 
  802307:	48 63 d2             	movslq %edx,%rdx
  80230a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80230e:	83 e0 01             	and    $0x1,%eax
  802311:	48 85 c0             	test   %rax,%rax
  802314:	74 21                	je     802337 <fork+0xce>
  802316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802319:	c1 f8 09             	sar    $0x9,%eax
  80231c:	89 c2                	mov    %eax,%edx
  80231e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802325:	01 00 00 
  802328:	48 63 d2             	movslq %edx,%rdx
  80232b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80232f:	83 e0 01             	and    $0x1,%eax
  802332:	48 85 c0             	test   %rax,%rax
  802335:	75 09                	jne    802340 <fork+0xd7>
			pn += NPTENTRIES;
  802337:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80233e:	eb 5b                	jmp    80239b <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802343:	05 00 02 00 00       	add    $0x200,%eax
  802348:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80234b:	eb 46                	jmp    802393 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80234d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802354:	01 00 00 
  802357:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80235a:	48 63 d2             	movslq %edx,%rdx
  80235d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802361:	83 e0 05             	and    $0x5,%eax
  802364:	48 83 f8 05          	cmp    $0x5,%rax
  802368:	75 21                	jne    80238b <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80236a:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802371:	74 1b                	je     80238e <fork+0x125>
				continue;
			duppage(envid, pn);
  802373:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802376:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802379:	89 d6                	mov    %edx,%esi
  80237b:	89 c7                	mov    %eax,%edi
  80237d:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
  802389:	eb 04                	jmp    80238f <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80238b:	90                   	nop
  80238c:	eb 01                	jmp    80238f <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80238e:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80238f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802396:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802399:	7c b2                	jl     80234d <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80239b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239e:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8023a3:	0f 86 4c ff ff ff    	jbe    8022f5 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8023a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ac:	ba 07 00 00 00       	mov    $0x7,%edx
  8023b1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023b6:	89 c7                	mov    %eax,%edi
  8023b8:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8023bf:	00 00 00 
  8023c2:	ff d0                	callq  *%rax
  8023c4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023cb:	79 30                	jns    8023fd <fork+0x194>
		panic("allocating exception stack: %e", r);
  8023cd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023d0:	89 c1                	mov    %eax,%ecx
  8023d2:	48 ba 48 51 80 00 00 	movabs $0x805148,%rdx
  8023d9:	00 00 00 
  8023dc:	be 9e 00 00 00       	mov    $0x9e,%esi
  8023e1:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8023e8:	00 00 00 
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f0:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8023f7:	00 00 00 
  8023fa:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8023fd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802404:	00 00 00 
  802407:	48 8b 00             	mov    (%rax),%rax
  80240a:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802411:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802414:	48 89 d6             	mov    %rdx,%rsi
  802417:	89 c7                	mov    %eax,%edi
  802419:	48 b8 63 1c 80 00 00 	movabs $0x801c63,%rax
  802420:	00 00 00 
  802423:	ff d0                	callq  *%rax
  802425:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802428:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80242c:	79 30                	jns    80245e <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80242e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802431:	89 c1                	mov    %eax,%ecx
  802433:	48 ba 68 51 80 00 00 	movabs $0x805168,%rdx
  80243a:	00 00 00 
  80243d:	be a2 00 00 00       	mov    $0xa2,%esi
  802442:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  802449:	00 00 00 
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  802458:	00 00 00 
  80245b:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80245e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802461:	be 02 00 00 00       	mov    $0x2,%esi
  802466:	89 c7                	mov    %eax,%edi
  802468:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  80246f:	00 00 00 
  802472:	ff d0                	callq  *%rax
  802474:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802477:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80247b:	79 30                	jns    8024ad <fork+0x244>
		panic("sys_env_set_status: %e", r);
  80247d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802480:	89 c1                	mov    %eax,%ecx
  802482:	48 ba 87 51 80 00 00 	movabs $0x805187,%rdx
  802489:	00 00 00 
  80248c:	be a7 00 00 00       	mov    $0xa7,%esi
  802491:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  802498:	00 00 00 
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8024a7:	00 00 00 
  8024aa:	41 ff d0             	callq  *%r8

	return envid;
  8024ad:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8024b0:	c9                   	leaveq 
  8024b1:	c3                   	retq   

00000000008024b2 <sfork>:

// Challenge!
int
sfork(void)
{
  8024b2:	55                   	push   %rbp
  8024b3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8024b6:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  8024bd:	00 00 00 
  8024c0:	be b1 00 00 00       	mov    $0xb1,%esi
  8024c5:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8024cc:	00 00 00 
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	48 b9 cc 03 80 00 00 	movabs $0x8003cc,%rcx
  8024db:	00 00 00 
  8024de:	ff d1                	callq  *%rcx

00000000008024e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024e0:	55                   	push   %rbp
  8024e1:	48 89 e5             	mov    %rsp,%rbp
  8024e4:	48 83 ec 08          	sub    $0x8,%rsp
  8024e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024f0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024f7:	ff ff ff 
  8024fa:	48 01 d0             	add    %rdx,%rax
  8024fd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802501:	c9                   	leaveq 
  802502:	c3                   	retq   

0000000000802503 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	48 83 ec 08          	sub    $0x8,%rsp
  80250b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80250f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802513:	48 89 c7             	mov    %rax,%rdi
  802516:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802528:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 18          	sub    $0x18,%rsp
  802536:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80253a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802541:	eb 6b                	jmp    8025ae <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802546:	48 98                	cltq   
  802548:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80254e:	48 c1 e0 0c          	shl    $0xc,%rax
  802552:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255a:	48 c1 e8 15          	shr    $0x15,%rax
  80255e:	48 89 c2             	mov    %rax,%rdx
  802561:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802568:	01 00 00 
  80256b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256f:	83 e0 01             	and    $0x1,%eax
  802572:	48 85 c0             	test   %rax,%rax
  802575:	74 21                	je     802598 <fd_alloc+0x6a>
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	48 c1 e8 0c          	shr    $0xc,%rax
  80257f:	48 89 c2             	mov    %rax,%rdx
  802582:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802589:	01 00 00 
  80258c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802590:	83 e0 01             	and    $0x1,%eax
  802593:	48 85 c0             	test   %rax,%rax
  802596:	75 12                	jne    8025aa <fd_alloc+0x7c>
			*fd_store = fd;
  802598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a8:	eb 1a                	jmp    8025c4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025ae:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025b2:	7e 8f                	jle    802543 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025bf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025c4:	c9                   	leaveq 
  8025c5:	c3                   	retq   

00000000008025c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025c6:	55                   	push   %rbp
  8025c7:	48 89 e5             	mov    %rsp,%rbp
  8025ca:	48 83 ec 20          	sub    $0x20,%rsp
  8025ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025d9:	78 06                	js     8025e1 <fd_lookup+0x1b>
  8025db:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025df:	7e 07                	jle    8025e8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e6:	eb 6c                	jmp    802654 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025eb:	48 98                	cltq   
  8025ed:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025f3:	48 c1 e0 0c          	shl    $0xc,%rax
  8025f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ff:	48 c1 e8 15          	shr    $0x15,%rax
  802603:	48 89 c2             	mov    %rax,%rdx
  802606:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80260d:	01 00 00 
  802610:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802614:	83 e0 01             	and    $0x1,%eax
  802617:	48 85 c0             	test   %rax,%rax
  80261a:	74 21                	je     80263d <fd_lookup+0x77>
  80261c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802620:	48 c1 e8 0c          	shr    $0xc,%rax
  802624:	48 89 c2             	mov    %rax,%rdx
  802627:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80262e:	01 00 00 
  802631:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802635:	83 e0 01             	and    $0x1,%eax
  802638:	48 85 c0             	test   %rax,%rax
  80263b:	75 07                	jne    802644 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80263d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802642:	eb 10                	jmp    802654 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802644:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802648:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80264c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802654:	c9                   	leaveq 
  802655:	c3                   	retq   

0000000000802656 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	48 83 ec 30          	sub    $0x30,%rsp
  80265e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802662:	89 f0                	mov    %esi,%eax
  802664:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266b:	48 89 c7             	mov    %rax,%rdi
  80266e:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	89 c2                	mov    %eax,%edx
  80267c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802680:	48 89 c6             	mov    %rax,%rsi
  802683:	89 d7                	mov    %edx,%edi
  802685:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	78 0a                	js     8026a4 <fd_close+0x4e>
	    || fd != fd2)
  80269a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026a2:	74 12                	je     8026b6 <fd_close+0x60>
		return (must_exist ? r : 0);
  8026a4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026a8:	74 05                	je     8026af <fd_close+0x59>
  8026aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ad:	eb 70                	jmp    80271f <fd_close+0xc9>
  8026af:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b4:	eb 69                	jmp    80271f <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ba:	8b 00                	mov    (%rax),%eax
  8026bc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026c0:	48 89 d6             	mov    %rdx,%rsi
  8026c3:	89 c7                	mov    %eax,%edi
  8026c5:	48 b8 21 27 80 00 00 	movabs $0x802721,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	callq  *%rax
  8026d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d8:	78 2a                	js     802704 <fd_close+0xae>
		if (dev->dev_close)
  8026da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026de:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026e2:	48 85 c0             	test   %rax,%rax
  8026e5:	74 16                	je     8026fd <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8026e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026eb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f3:	48 89 d7             	mov    %rdx,%rdi
  8026f6:	ff d0                	callq  *%rax
  8026f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fb:	eb 07                	jmp    802704 <fd_close+0xae>
		else
			r = 0;
  8026fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802708:	48 89 c6             	mov    %rax,%rsi
  80270b:	bf 00 00 00 00       	mov    $0x0,%edi
  802710:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
	return r;
  80271c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80271f:	c9                   	leaveq 
  802720:	c3                   	retq   

0000000000802721 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802721:	55                   	push   %rbp
  802722:	48 89 e5             	mov    %rsp,%rbp
  802725:	48 83 ec 20          	sub    $0x20,%rsp
  802729:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80272c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802730:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802737:	eb 41                	jmp    80277a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802739:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802740:	00 00 00 
  802743:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802746:	48 63 d2             	movslq %edx,%rdx
  802749:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274d:	8b 00                	mov    (%rax),%eax
  80274f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802752:	75 22                	jne    802776 <dev_lookup+0x55>
			*dev = devtab[i];
  802754:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80275b:	00 00 00 
  80275e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802761:	48 63 d2             	movslq %edx,%rdx
  802764:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802768:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80276c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	eb 60                	jmp    8027d6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802776:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80277a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802781:	00 00 00 
  802784:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802787:	48 63 d2             	movslq %edx,%rdx
  80278a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278e:	48 85 c0             	test   %rax,%rax
  802791:	75 a6                	jne    802739 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802793:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80279a:	00 00 00 
  80279d:	48 8b 00             	mov    (%rax),%rax
  8027a0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027a9:	89 c6                	mov    %eax,%esi
  8027ab:	48 bf b8 51 80 00 00 	movabs $0x8051b8,%rdi
  8027b2:	00 00 00 
  8027b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ba:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  8027c1:	00 00 00 
  8027c4:	ff d1                	callq  *%rcx
	*dev = 0;
  8027c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ca:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027d6:	c9                   	leaveq 
  8027d7:	c3                   	retq   

00000000008027d8 <close>:

int
close(int fdnum)
{
  8027d8:	55                   	push   %rbp
  8027d9:	48 89 e5             	mov    %rsp,%rbp
  8027dc:	48 83 ec 20          	sub    $0x20,%rsp
  8027e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ea:	48 89 d6             	mov    %rdx,%rsi
  8027ed:	89 c7                	mov    %eax,%edi
  8027ef:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
  8027fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802802:	79 05                	jns    802809 <close+0x31>
		return r;
  802804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802807:	eb 18                	jmp    802821 <close+0x49>
	else
		return fd_close(fd, 1);
  802809:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280d:	be 01 00 00 00       	mov    $0x1,%esi
  802812:	48 89 c7             	mov    %rax,%rdi
  802815:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	callq  *%rax
}
  802821:	c9                   	leaveq 
  802822:	c3                   	retq   

0000000000802823 <close_all>:

void
close_all(void)
{
  802823:	55                   	push   %rbp
  802824:	48 89 e5             	mov    %rsp,%rbp
  802827:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80282b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802832:	eb 15                	jmp    802849 <close_all+0x26>
		close(i);
  802834:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802837:	89 c7                	mov    %eax,%edi
  802839:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  802840:	00 00 00 
  802843:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802845:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802849:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80284d:	7e e5                	jle    802834 <close_all+0x11>
		close(i);
}
  80284f:	90                   	nop
  802850:	c9                   	leaveq 
  802851:	c3                   	retq   

0000000000802852 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802852:	55                   	push   %rbp
  802853:	48 89 e5             	mov    %rsp,%rbp
  802856:	48 83 ec 40          	sub    $0x40,%rsp
  80285a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80285d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802860:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802864:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802867:	48 89 d6             	mov    %rdx,%rsi
  80286a:	89 c7                	mov    %eax,%edi
  80286c:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802873:	00 00 00 
  802876:	ff d0                	callq  *%rax
  802878:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287f:	79 08                	jns    802889 <dup+0x37>
		return r;
  802881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802884:	e9 70 01 00 00       	jmpq   8029f9 <dup+0x1a7>
	close(newfdnum);
  802889:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80288c:	89 c7                	mov    %eax,%edi
  80288e:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80289a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80289d:	48 98                	cltq   
  80289f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028a5:	48 c1 e0 0c          	shl    $0xc,%rax
  8028a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b1:	48 89 c7             	mov    %rax,%rdi
  8028b4:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
  8028c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c8:	48 89 c7             	mov    %rax,%rdi
  8028cb:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
  8028d7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028df:	48 c1 e8 15          	shr    $0x15,%rax
  8028e3:	48 89 c2             	mov    %rax,%rdx
  8028e6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028ed:	01 00 00 
  8028f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f4:	83 e0 01             	and    $0x1,%eax
  8028f7:	48 85 c0             	test   %rax,%rax
  8028fa:	74 71                	je     80296d <dup+0x11b>
  8028fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802900:	48 c1 e8 0c          	shr    $0xc,%rax
  802904:	48 89 c2             	mov    %rax,%rdx
  802907:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290e:	01 00 00 
  802911:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802915:	83 e0 01             	and    $0x1,%eax
  802918:	48 85 c0             	test   %rax,%rax
  80291b:	74 50                	je     80296d <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80291d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802921:	48 c1 e8 0c          	shr    $0xc,%rax
  802925:	48 89 c2             	mov    %rax,%rdx
  802928:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80292f:	01 00 00 
  802932:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802936:	25 07 0e 00 00       	and    $0xe07,%eax
  80293b:	89 c1                	mov    %eax,%ecx
  80293d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802945:	41 89 c8             	mov    %ecx,%r8d
  802948:	48 89 d1             	mov    %rdx,%rcx
  80294b:	ba 00 00 00 00       	mov    $0x0,%edx
  802950:	48 89 c6             	mov    %rax,%rsi
  802953:	bf 00 00 00 00       	mov    $0x0,%edi
  802958:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296b:	78 55                	js     8029c2 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80296d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802971:	48 c1 e8 0c          	shr    $0xc,%rax
  802975:	48 89 c2             	mov    %rax,%rdx
  802978:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80297f:	01 00 00 
  802982:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802986:	25 07 0e 00 00       	and    $0xe07,%eax
  80298b:	89 c1                	mov    %eax,%ecx
  80298d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802991:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802995:	41 89 c8             	mov    %ecx,%r8d
  802998:	48 89 d1             	mov    %rdx,%rcx
  80299b:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a0:	48 89 c6             	mov    %rax,%rsi
  8029a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a8:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bb:	78 08                	js     8029c5 <dup+0x173>
		goto err;

	return newfdnum;
  8029bd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029c0:	eb 37                	jmp    8029f9 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8029c2:	90                   	nop
  8029c3:	eb 01                	jmp    8029c6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8029c5:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8029c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ca:	48 89 c6             	mov    %rax,%rsi
  8029cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d2:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e2:	48 89 c6             	mov    %rax,%rsi
  8029e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ea:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
	return r;
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029f9:	c9                   	leaveq 
  8029fa:	c3                   	retq   

00000000008029fb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	48 83 ec 40          	sub    $0x40,%rsp
  802a03:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a0a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a0e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a12:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a15:	48 89 d6             	mov    %rdx,%rsi
  802a18:	89 c7                	mov    %eax,%edi
  802a1a:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2d:	78 24                	js     802a53 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a33:	8b 00                	mov    (%rax),%eax
  802a35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a39:	48 89 d6             	mov    %rdx,%rsi
  802a3c:	89 c7                	mov    %eax,%edi
  802a3e:	48 b8 21 27 80 00 00 	movabs $0x802721,%rax
  802a45:	00 00 00 
  802a48:	ff d0                	callq  *%rax
  802a4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a51:	79 05                	jns    802a58 <read+0x5d>
		return r;
  802a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a56:	eb 76                	jmp    802ace <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5c:	8b 40 08             	mov    0x8(%rax),%eax
  802a5f:	83 e0 03             	and    $0x3,%eax
  802a62:	83 f8 01             	cmp    $0x1,%eax
  802a65:	75 3a                	jne    802aa1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a67:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a6e:	00 00 00 
  802a71:	48 8b 00             	mov    (%rax),%rax
  802a74:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a7d:	89 c6                	mov    %eax,%esi
  802a7f:	48 bf d7 51 80 00 00 	movabs $0x8051d7,%rdi
  802a86:	00 00 00 
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8e:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  802a95:	00 00 00 
  802a98:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a9f:	eb 2d                	jmp    802ace <read+0xd3>
	}
	if (!dev->dev_read)
  802aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa5:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aa9:	48 85 c0             	test   %rax,%rax
  802aac:	75 07                	jne    802ab5 <read+0xba>
		return -E_NOT_SUPP;
  802aae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab3:	eb 19                	jmp    802ace <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab9:	48 8b 40 10          	mov    0x10(%rax),%rax
  802abd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ac1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ac5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ac9:	48 89 cf             	mov    %rcx,%rdi
  802acc:	ff d0                	callq  *%rax
}
  802ace:	c9                   	leaveq 
  802acf:	c3                   	retq   

0000000000802ad0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	48 83 ec 30          	sub    $0x30,%rsp
  802ad8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802adb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802adf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aea:	eb 47                	jmp    802b33 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aef:	48 98                	cltq   
  802af1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af5:	48 29 c2             	sub    %rax,%rdx
  802af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afb:	48 63 c8             	movslq %eax,%rcx
  802afe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b02:	48 01 c1             	add    %rax,%rcx
  802b05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b08:	48 89 ce             	mov    %rcx,%rsi
  802b0b:	89 c7                	mov    %eax,%edi
  802b0d:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	callq  *%rax
  802b19:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b1c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b20:	79 05                	jns    802b27 <readn+0x57>
			return m;
  802b22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b25:	eb 1d                	jmp    802b44 <readn+0x74>
		if (m == 0)
  802b27:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b2b:	74 13                	je     802b40 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b30:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b36:	48 98                	cltq   
  802b38:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b3c:	72 ae                	jb     802aec <readn+0x1c>
  802b3e:	eb 01                	jmp    802b41 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802b40:	90                   	nop
	}
	return tot;
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b44:	c9                   	leaveq 
  802b45:	c3                   	retq   

0000000000802b46 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b46:	55                   	push   %rbp
  802b47:	48 89 e5             	mov    %rsp,%rbp
  802b4a:	48 83 ec 40          	sub    $0x40,%rsp
  802b4e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b51:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b55:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b60:	48 89 d6             	mov    %rdx,%rsi
  802b63:	89 c7                	mov    %eax,%edi
  802b65:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b78:	78 24                	js     802b9e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7e:	8b 00                	mov    (%rax),%eax
  802b80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b84:	48 89 d6             	mov    %rdx,%rsi
  802b87:	89 c7                	mov    %eax,%edi
  802b89:	48 b8 21 27 80 00 00 	movabs $0x802721,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 05                	jns    802ba3 <write+0x5d>
		return r;
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	eb 75                	jmp    802c18 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba7:	8b 40 08             	mov    0x8(%rax),%eax
  802baa:	83 e0 03             	and    $0x3,%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	75 3a                	jne    802beb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bb1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802bb8:	00 00 00 
  802bbb:	48 8b 00             	mov    (%rax),%rax
  802bbe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bc4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bc7:	89 c6                	mov    %eax,%esi
  802bc9:	48 bf f3 51 80 00 00 	movabs $0x8051f3,%rdi
  802bd0:	00 00 00 
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd8:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  802bdf:	00 00 00 
  802be2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802be4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802be9:	eb 2d                	jmp    802c18 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bef:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bf3:	48 85 c0             	test   %rax,%rax
  802bf6:	75 07                	jne    802bff <write+0xb9>
		return -E_NOT_SUPP;
  802bf8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bfd:	eb 19                	jmp    802c18 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c03:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c07:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c0f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c13:	48 89 cf             	mov    %rcx,%rdi
  802c16:	ff d0                	callq  *%rax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <seek>:

int
seek(int fdnum, off_t offset)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 18          	sub    $0x18,%rsp
  802c22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c25:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c2f:	48 89 d6             	mov    %rdx,%rsi
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	79 05                	jns    802c4e <seek+0x34>
		return r;
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4c:	eb 0f                	jmp    802c5d <seek+0x43>
	fd->fd_offset = offset;
  802c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 30          	sub    $0x30,%rsp
  802c67:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c6a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c74:	48 89 d6             	mov    %rdx,%rsi
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8c:	78 24                	js     802cb2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c92:	8b 00                	mov    (%rax),%eax
  802c94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c98:	48 89 d6             	mov    %rdx,%rsi
  802c9b:	89 c7                	mov    %eax,%edi
  802c9d:	48 b8 21 27 80 00 00 	movabs $0x802721,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
  802ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb0:	79 05                	jns    802cb7 <ftruncate+0x58>
		return r;
  802cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb5:	eb 72                	jmp    802d29 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbb:	8b 40 08             	mov    0x8(%rax),%eax
  802cbe:	83 e0 03             	and    $0x3,%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	75 3a                	jne    802cff <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cc5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ccc:	00 00 00 
  802ccf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cdb:	89 c6                	mov    %eax,%esi
  802cdd:	48 bf 10 52 80 00 00 	movabs $0x805210,%rdi
  802ce4:	00 00 00 
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cec:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  802cf3:	00 00 00 
  802cf6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cf8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cfd:	eb 2a                	jmp    802d29 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d03:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d07:	48 85 c0             	test   %rax,%rax
  802d0a:	75 07                	jne    802d13 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d11:	eb 16                	jmp    802d29 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d17:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d1f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d22:	89 ce                	mov    %ecx,%esi
  802d24:	48 89 d7             	mov    %rdx,%rdi
  802d27:	ff d0                	callq  *%rax
}
  802d29:	c9                   	leaveq 
  802d2a:	c3                   	retq   

0000000000802d2b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d2b:	55                   	push   %rbp
  802d2c:	48 89 e5             	mov    %rsp,%rbp
  802d2f:	48 83 ec 30          	sub    $0x30,%rsp
  802d33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d41:	48 89 d6             	mov    %rdx,%rsi
  802d44:	89 c7                	mov    %eax,%edi
  802d46:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d59:	78 24                	js     802d7f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5f:	8b 00                	mov    (%rax),%eax
  802d61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d65:	48 89 d6             	mov    %rdx,%rsi
  802d68:	89 c7                	mov    %eax,%edi
  802d6a:	48 b8 21 27 80 00 00 	movabs $0x802721,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
  802d76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7d:	79 05                	jns    802d84 <fstat+0x59>
		return r;
  802d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d82:	eb 5e                	jmp    802de2 <fstat+0xb7>
	if (!dev->dev_stat)
  802d84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d88:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d8c:	48 85 c0             	test   %rax,%rax
  802d8f:	75 07                	jne    802d98 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d96:	eb 4a                	jmp    802de2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d9c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802daa:	00 00 00 
	stat->st_isdir = 0;
  802dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802db8:	00 00 00 
	stat->st_dev = dev;
  802dbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dce:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dd6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802dda:	48 89 ce             	mov    %rcx,%rsi
  802ddd:	48 89 d7             	mov    %rdx,%rdi
  802de0:	ff d0                	callq  *%rax
}
  802de2:	c9                   	leaveq 
  802de3:	c3                   	retq   

0000000000802de4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802de4:	55                   	push   %rbp
  802de5:	48 89 e5             	mov    %rsp,%rbp
  802de8:	48 83 ec 20          	sub    $0x20,%rsp
  802dec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df8:	be 00 00 00 00       	mov    $0x0,%esi
  802dfd:	48 89 c7             	mov    %rax,%rdi
  802e00:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  802e07:	00 00 00 
  802e0a:	ff d0                	callq  *%rax
  802e0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e13:	79 05                	jns    802e1a <stat+0x36>
		return fd;
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	eb 2f                	jmp    802e49 <stat+0x65>
	r = fstat(fd, stat);
  802e1a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e21:	48 89 d6             	mov    %rdx,%rsi
  802e24:	89 c7                	mov    %eax,%edi
  802e26:	48 b8 2b 2d 80 00 00 	movabs $0x802d2b,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e38:	89 c7                	mov    %eax,%edi
  802e3a:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
	return r;
  802e46:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e49:	c9                   	leaveq 
  802e4a:	c3                   	retq   

0000000000802e4b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 83 ec 10          	sub    $0x10,%rsp
  802e53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e5a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e61:	00 00 00 
  802e64:	8b 00                	mov    (%rax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	75 1f                	jne    802e89 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e6a:	bf 01 00 00 00       	mov    $0x1,%edi
  802e6f:	48 b8 84 49 80 00 00 	movabs $0x804984,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	89 c2                	mov    %eax,%edx
  802e7d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e84:	00 00 00 
  802e87:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e90:	00 00 00 
  802e93:	8b 00                	mov    (%rax),%eax
  802e95:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e98:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e9d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ea4:	00 00 00 
  802ea7:	89 c7                	mov    %eax,%edi
  802ea9:	48 b8 78 47 80 00 00 	movabs $0x804778,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebe:	48 89 c6             	mov    %rax,%rsi
  802ec1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec6:	48 b8 b7 46 80 00 00 	movabs $0x8046b7,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 20          	sub    $0x20,%rsp
  802edc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ee0:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee7:	48 89 c7             	mov    %rax,%rdi
  802eea:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  802ef1:	00 00 00 
  802ef4:	ff d0                	callq  *%rax
  802ef6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802efb:	7e 0a                	jle    802f07 <open+0x33>
		return -E_BAD_PATH;
  802efd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f02:	e9 a5 00 00 00       	jmpq   802fac <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802f07:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f0b:	48 89 c7             	mov    %rax,%rdi
  802f0e:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f21:	79 08                	jns    802f2b <open+0x57>
		return r;
  802f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f26:	e9 81 00 00 00       	jmpq   802fac <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2f:	48 89 c6             	mov    %rax,%rsi
  802f32:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f39:	00 00 00 
  802f3c:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  802f43:	00 00 00 
  802f46:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802f48:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f4f:	00 00 00 
  802f52:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f55:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5f:	48 89 c6             	mov    %rax,%rsi
  802f62:	bf 01 00 00 00       	mov    $0x1,%edi
  802f67:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
  802f73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7a:	79 1d                	jns    802f99 <open+0xc5>
		fd_close(fd, 0);
  802f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f80:	be 00 00 00 00       	mov    $0x0,%esi
  802f85:	48 89 c7             	mov    %rax,%rdi
  802f88:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
		return r;
  802f94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f97:	eb 13                	jmp    802fac <open+0xd8>
	}

	return fd2num(fd);
  802f99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9d:	48 89 c7             	mov    %rax,%rdi
  802fa0:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax

}
  802fac:	c9                   	leaveq 
  802fad:	c3                   	retq   

0000000000802fae <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fae:	55                   	push   %rbp
  802faf:	48 89 e5             	mov    %rsp,%rbp
  802fb2:	48 83 ec 10          	sub    $0x10,%rsp
  802fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbe:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc8:	00 00 00 
  802fcb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fcd:	be 00 00 00 00       	mov    $0x0,%esi
  802fd2:	bf 06 00 00 00       	mov    $0x6,%edi
  802fd7:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
}
  802fe3:	c9                   	leaveq 
  802fe4:	c3                   	retq   

0000000000802fe5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fe5:	55                   	push   %rbp
  802fe6:	48 89 e5             	mov    %rsp,%rbp
  802fe9:	48 83 ec 30          	sub    $0x30,%rsp
  802fed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ff1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffd:	8b 50 0c             	mov    0xc(%rax),%edx
  803000:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803007:	00 00 00 
  80300a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80300c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803013:	00 00 00 
  803016:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80301a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80301e:	be 00 00 00 00       	mov    $0x0,%esi
  803023:	bf 03 00 00 00       	mov    $0x3,%edi
  803028:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303b:	79 08                	jns    803045 <devfile_read+0x60>
		return r;
  80303d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803040:	e9 a4 00 00 00       	jmpq   8030e9 <devfile_read+0x104>
	assert(r <= n);
  803045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803048:	48 98                	cltq   
  80304a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80304e:	76 35                	jbe    803085 <devfile_read+0xa0>
  803050:	48 b9 36 52 80 00 00 	movabs $0x805236,%rcx
  803057:	00 00 00 
  80305a:	48 ba 3d 52 80 00 00 	movabs $0x80523d,%rdx
  803061:	00 00 00 
  803064:	be 86 00 00 00       	mov    $0x86,%esi
  803069:	48 bf 52 52 80 00 00 	movabs $0x805252,%rdi
  803070:	00 00 00 
  803073:	b8 00 00 00 00       	mov    $0x0,%eax
  803078:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  80307f:	00 00 00 
  803082:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803085:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80308c:	7e 35                	jle    8030c3 <devfile_read+0xde>
  80308e:	48 b9 5d 52 80 00 00 	movabs $0x80525d,%rcx
  803095:	00 00 00 
  803098:	48 ba 3d 52 80 00 00 	movabs $0x80523d,%rdx
  80309f:	00 00 00 
  8030a2:	be 87 00 00 00       	mov    $0x87,%esi
  8030a7:	48 bf 52 52 80 00 00 	movabs $0x805252,%rdi
  8030ae:	00 00 00 
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b6:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8030bd:	00 00 00 
  8030c0:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8030c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c6:	48 63 d0             	movslq %eax,%rdx
  8030c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030cd:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030d4:	00 00 00 
  8030d7:	48 89 c7             	mov    %rax,%rdi
  8030da:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
	return r;
  8030e6:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8030e9:	c9                   	leaveq 
  8030ea:	c3                   	retq   

00000000008030eb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030eb:	55                   	push   %rbp
  8030ec:	48 89 e5             	mov    %rsp,%rbp
  8030ef:	48 83 ec 40          	sub    $0x40,%rsp
  8030f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8030ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803103:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803107:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80310e:	00 
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803117:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80311c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803120:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803124:	8b 50 0c             	mov    0xc(%rax),%edx
  803127:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80312e:	00 00 00 
  803131:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803133:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80313a:	00 00 00 
  80313d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803141:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803145:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803149:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314d:	48 89 c6             	mov    %rax,%rsi
  803150:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803157:	00 00 00 
  80315a:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803166:	be 00 00 00 00       	mov    $0x0,%esi
  80316b:	bf 04 00 00 00       	mov    $0x4,%edi
  803170:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
  80317c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80317f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803183:	79 05                	jns    80318a <devfile_write+0x9f>
		return r;
  803185:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803188:	eb 43                	jmp    8031cd <devfile_write+0xe2>
	assert(r <= n);
  80318a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318d:	48 98                	cltq   
  80318f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803193:	76 35                	jbe    8031ca <devfile_write+0xdf>
  803195:	48 b9 36 52 80 00 00 	movabs $0x805236,%rcx
  80319c:	00 00 00 
  80319f:	48 ba 3d 52 80 00 00 	movabs $0x80523d,%rdx
  8031a6:	00 00 00 
  8031a9:	be a2 00 00 00       	mov    $0xa2,%esi
  8031ae:	48 bf 52 52 80 00 00 	movabs $0x805252,%rdi
  8031b5:	00 00 00 
  8031b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bd:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8031c4:	00 00 00 
  8031c7:	41 ff d0             	callq  *%r8
	return r;
  8031ca:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8031cd:	c9                   	leaveq 
  8031ce:	c3                   	retq   

00000000008031cf <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031cf:	55                   	push   %rbp
  8031d0:	48 89 e5             	mov    %rsp,%rbp
  8031d3:	48 83 ec 20          	sub    $0x20,%rsp
  8031d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031ed:	00 00 00 
  8031f0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031f2:	be 00 00 00 00       	mov    $0x0,%esi
  8031f7:	bf 05 00 00 00       	mov    $0x5,%edi
  8031fc:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
  803208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80320b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80320f:	79 05                	jns    803216 <devfile_stat+0x47>
		return r;
  803211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803214:	eb 56                	jmp    80326c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803221:	00 00 00 
  803224:	48 89 c7             	mov    %rax,%rdi
  803227:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803233:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80323a:	00 00 00 
  80323d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803247:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80324d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803254:	00 00 00 
  803257:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80325d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803261:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326c:	c9                   	leaveq 
  80326d:	c3                   	retq   

000000000080326e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80326e:	55                   	push   %rbp
  80326f:	48 89 e5             	mov    %rsp,%rbp
  803272:	48 83 ec 10          	sub    $0x10,%rsp
  803276:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80327a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80327d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803281:	8b 50 0c             	mov    0xc(%rax),%edx
  803284:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80328b:	00 00 00 
  80328e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803290:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803297:	00 00 00 
  80329a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80329d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8032a0:	be 00 00 00 00       	mov    $0x0,%esi
  8032a5:	bf 02 00 00 00       	mov    $0x2,%edi
  8032aa:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  8032b1:	00 00 00 
  8032b4:	ff d0                	callq  *%rax
}
  8032b6:	c9                   	leaveq 
  8032b7:	c3                   	retq   

00000000008032b8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8032b8:	55                   	push   %rbp
  8032b9:	48 89 e5             	mov    %rsp,%rbp
  8032bc:	48 83 ec 10          	sub    $0x10,%rsp
  8032c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8032c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c8:	48 89 c7             	mov    %rax,%rdi
  8032cb:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
  8032d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032dc:	7e 07                	jle    8032e5 <remove+0x2d>
		return -E_BAD_PATH;
  8032de:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032e3:	eb 33                	jmp    803318 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032e9:	48 89 c6             	mov    %rax,%rsi
  8032ec:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032f3:	00 00 00 
  8032f6:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  8032fd:	00 00 00 
  803300:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803302:	be 00 00 00 00       	mov    $0x0,%esi
  803307:	bf 07 00 00 00       	mov    $0x7,%edi
  80330c:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
}
  803318:	c9                   	leaveq 
  803319:	c3                   	retq   

000000000080331a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80331a:	55                   	push   %rbp
  80331b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80331e:	be 00 00 00 00       	mov    $0x0,%esi
  803323:	bf 08 00 00 00       	mov    $0x8,%edi
  803328:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
}
  803334:	5d                   	pop    %rbp
  803335:	c3                   	retq   

0000000000803336 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803336:	55                   	push   %rbp
  803337:	48 89 e5             	mov    %rsp,%rbp
  80333a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803341:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803348:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80334f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803356:	be 00 00 00 00       	mov    $0x0,%esi
  80335b:	48 89 c7             	mov    %rax,%rdi
  80335e:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80336d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803371:	79 28                	jns    80339b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803376:	89 c6                	mov    %eax,%esi
  803378:	48 bf 69 52 80 00 00 	movabs $0x805269,%rdi
  80337f:	00 00 00 
  803382:	b8 00 00 00 00       	mov    $0x0,%eax
  803387:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  80338e:	00 00 00 
  803391:	ff d2                	callq  *%rdx
		return fd_src;
  803393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803396:	e9 76 01 00 00       	jmpq   803511 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80339b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8033a2:	be 01 01 00 00       	mov    $0x101,%esi
  8033a7:	48 89 c7             	mov    %rax,%rdi
  8033aa:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
  8033b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8033b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033bd:	0f 89 ad 00 00 00    	jns    803470 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8033c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c6:	89 c6                	mov    %eax,%esi
  8033c8:	48 bf 7f 52 80 00 00 	movabs $0x80527f,%rdi
  8033cf:	00 00 00 
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  8033de:	00 00 00 
  8033e1:	ff d2                	callq  *%rdx
		close(fd_src);
  8033e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
		return fd_dest;
  8033f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033f7:	e9 15 01 00 00       	jmpq   803511 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8033fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033ff:	48 63 d0             	movslq %eax,%rdx
  803402:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803409:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80340c:	48 89 ce             	mov    %rcx,%rsi
  80340f:	89 c7                	mov    %eax,%edi
  803411:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
  80341d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803420:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803424:	79 4a                	jns    803470 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803426:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803429:	89 c6                	mov    %eax,%esi
  80342b:	48 bf 99 52 80 00 00 	movabs $0x805299,%rdi
  803432:	00 00 00 
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
  80343a:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  803441:	00 00 00 
  803444:	ff d2                	callq  *%rdx
			close(fd_src);
  803446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803449:	89 c7                	mov    %eax,%edi
  80344b:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
			close(fd_dest);
  803457:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80345a:	89 c7                	mov    %eax,%edi
  80345c:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  803463:	00 00 00 
  803466:	ff d0                	callq  *%rax
			return write_size;
  803468:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80346b:	e9 a1 00 00 00       	jmpq   803511 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803470:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803477:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347a:	ba 00 02 00 00       	mov    $0x200,%edx
  80347f:	48 89 ce             	mov    %rcx,%rsi
  803482:	89 c7                	mov    %eax,%edi
  803484:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  80348b:	00 00 00 
  80348e:	ff d0                	callq  *%rax
  803490:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803497:	0f 8f 5f ff ff ff    	jg     8033fc <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80349d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034a1:	79 47                	jns    8034ea <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8034a3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a6:	89 c6                	mov    %eax,%esi
  8034a8:	48 bf ac 52 80 00 00 	movabs $0x8052ac,%rdi
  8034af:	00 00 00 
  8034b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b7:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  8034be:	00 00 00 
  8034c1:	ff d2                	callq  *%rdx
		close(fd_src);
  8034c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c6:	89 c7                	mov    %eax,%edi
  8034c8:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
		close(fd_dest);
  8034d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034d7:	89 c7                	mov    %eax,%edi
  8034d9:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
		return read_size;
  8034e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034e8:	eb 27                	jmp    803511 <copy+0x1db>
	}
	close(fd_src);
  8034ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ed:	89 c7                	mov    %eax,%edi
  8034ef:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
	close(fd_dest);
  8034fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034fe:	89 c7                	mov    %eax,%edi
  803500:	48 b8 d8 27 80 00 00 	movabs $0x8027d8,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
	return 0;
  80350c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803511:	c9                   	leaveq 
  803512:	c3                   	retq   

0000000000803513 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 20          	sub    $0x20,%rsp
  80351b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80351e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803522:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803525:	48 89 d6             	mov    %rdx,%rsi
  803528:	89 c7                	mov    %eax,%edi
  80352a:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
  803536:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353d:	79 05                	jns    803544 <fd2sockid+0x31>
		return r;
  80353f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803542:	eb 24                	jmp    803568 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803548:	8b 10                	mov    (%rax),%edx
  80354a:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803551:	00 00 00 
  803554:	8b 00                	mov    (%rax),%eax
  803556:	39 c2                	cmp    %eax,%edx
  803558:	74 07                	je     803561 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80355a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80355f:	eb 07                	jmp    803568 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803565:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803568:	c9                   	leaveq 
  803569:	c3                   	retq   

000000000080356a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80356a:	55                   	push   %rbp
  80356b:	48 89 e5             	mov    %rsp,%rbp
  80356e:	48 83 ec 20          	sub    $0x20,%rsp
  803572:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803575:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803579:	48 89 c7             	mov    %rax,%rdi
  80357c:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
  803588:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80358f:	78 26                	js     8035b7 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803595:	ba 07 04 00 00       	mov    $0x407,%edx
  80359a:	48 89 c6             	mov    %rax,%rsi
  80359d:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a2:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
  8035ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b5:	79 16                	jns    8035cd <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ba:	89 c7                	mov    %eax,%edi
  8035bc:	48 b8 79 3a 80 00 00 	movabs $0x803a79,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
		return r;
  8035c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cb:	eb 3a                	jmp    803607 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d1:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8035d8:	00 00 00 
  8035db:	8b 12                	mov    (%rdx),%edx
  8035dd:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8035df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8035ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035f1:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8035f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f8:	48 89 c7             	mov    %rax,%rdi
  8035fb:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
}
  803607:	c9                   	leaveq 
  803608:	c3                   	retq   

0000000000803609 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803609:	55                   	push   %rbp
  80360a:	48 89 e5             	mov    %rsp,%rbp
  80360d:	48 83 ec 30          	sub    $0x30,%rsp
  803611:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803614:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803618:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80361c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361f:	89 c7                	mov    %eax,%edi
  803621:	48 b8 13 35 80 00 00 	movabs $0x803513,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
  80362d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803634:	79 05                	jns    80363b <accept+0x32>
		return r;
  803636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803639:	eb 3b                	jmp    803676 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80363b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80363f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803646:	48 89 ce             	mov    %rcx,%rsi
  803649:	89 c7                	mov    %eax,%edi
  80364b:	48 b8 56 39 80 00 00 	movabs $0x803956,%rax
  803652:	00 00 00 
  803655:	ff d0                	callq  *%rax
  803657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80365a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365e:	79 05                	jns    803665 <accept+0x5c>
		return r;
  803660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803663:	eb 11                	jmp    803676 <accept+0x6d>
	return alloc_sockfd(r);
  803665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803668:	89 c7                	mov    %eax,%edi
  80366a:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  803671:	00 00 00 
  803674:	ff d0                	callq  *%rax
}
  803676:	c9                   	leaveq 
  803677:	c3                   	retq   

0000000000803678 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803678:	55                   	push   %rbp
  803679:	48 89 e5             	mov    %rsp,%rbp
  80367c:	48 83 ec 20          	sub    $0x20,%rsp
  803680:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803683:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803687:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80368a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368d:	89 c7                	mov    %eax,%edi
  80368f:	48 b8 13 35 80 00 00 	movabs $0x803513,%rax
  803696:	00 00 00 
  803699:	ff d0                	callq  *%rax
  80369b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a2:	79 05                	jns    8036a9 <bind+0x31>
		return r;
  8036a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a7:	eb 1b                	jmp    8036c4 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036a9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036ac:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b3:	48 89 ce             	mov    %rcx,%rsi
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 d5 39 80 00 00 	movabs $0x8039d5,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
}
  8036c4:	c9                   	leaveq 
  8036c5:	c3                   	retq   

00000000008036c6 <shutdown>:

int
shutdown(int s, int how)
{
  8036c6:	55                   	push   %rbp
  8036c7:	48 89 e5             	mov    %rsp,%rbp
  8036ca:	48 83 ec 20          	sub    $0x20,%rsp
  8036ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036d1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d7:	89 c7                	mov    %eax,%edi
  8036d9:	48 b8 13 35 80 00 00 	movabs $0x803513,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
  8036e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ec:	79 05                	jns    8036f3 <shutdown+0x2d>
		return r;
  8036ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f1:	eb 16                	jmp    803709 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036f3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f9:	89 d6                	mov    %edx,%esi
  8036fb:	89 c7                	mov    %eax,%edi
  8036fd:	48 b8 39 3a 80 00 00 	movabs $0x803a39,%rax
  803704:	00 00 00 
  803707:	ff d0                	callq  *%rax
}
  803709:	c9                   	leaveq 
  80370a:	c3                   	retq   

000000000080370b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80370b:	55                   	push   %rbp
  80370c:	48 89 e5             	mov    %rsp,%rbp
  80370f:	48 83 ec 10          	sub    $0x10,%rsp
  803713:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371b:	48 89 c7             	mov    %rax,%rdi
  80371e:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  803725:	00 00 00 
  803728:	ff d0                	callq  *%rax
  80372a:	83 f8 01             	cmp    $0x1,%eax
  80372d:	75 17                	jne    803746 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80372f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803733:	8b 40 0c             	mov    0xc(%rax),%eax
  803736:	89 c7                	mov    %eax,%edi
  803738:	48 b8 79 3a 80 00 00 	movabs $0x803a79,%rax
  80373f:	00 00 00 
  803742:	ff d0                	callq  *%rax
  803744:	eb 05                	jmp    80374b <devsock_close+0x40>
	else
		return 0;
  803746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80374b:	c9                   	leaveq 
  80374c:	c3                   	retq   

000000000080374d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80374d:	55                   	push   %rbp
  80374e:	48 89 e5             	mov    %rsp,%rbp
  803751:	48 83 ec 20          	sub    $0x20,%rsp
  803755:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80375c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80375f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803762:	89 c7                	mov    %eax,%edi
  803764:	48 b8 13 35 80 00 00 	movabs $0x803513,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
  803770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803773:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803777:	79 05                	jns    80377e <connect+0x31>
		return r;
  803779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377c:	eb 1b                	jmp    803799 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80377e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803781:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803788:	48 89 ce             	mov    %rcx,%rsi
  80378b:	89 c7                	mov    %eax,%edi
  80378d:	48 b8 a6 3a 80 00 00 	movabs $0x803aa6,%rax
  803794:	00 00 00 
  803797:	ff d0                	callq  *%rax
}
  803799:	c9                   	leaveq 
  80379a:	c3                   	retq   

000000000080379b <listen>:

int
listen(int s, int backlog)
{
  80379b:	55                   	push   %rbp
  80379c:	48 89 e5             	mov    %rsp,%rbp
  80379f:	48 83 ec 20          	sub    $0x20,%rsp
  8037a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ac:	89 c7                	mov    %eax,%edi
  8037ae:	48 b8 13 35 80 00 00 	movabs $0x803513,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
  8037ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c1:	79 05                	jns    8037c8 <listen+0x2d>
		return r;
  8037c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c6:	eb 16                	jmp    8037de <listen+0x43>
	return nsipc_listen(r, backlog);
  8037c8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ce:	89 d6                	mov    %edx,%esi
  8037d0:	89 c7                	mov    %eax,%edi
  8037d2:	48 b8 0a 3b 80 00 00 	movabs $0x803b0a,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
}
  8037de:	c9                   	leaveq 
  8037df:	c3                   	retq   

00000000008037e0 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037e0:	55                   	push   %rbp
  8037e1:	48 89 e5             	mov    %rsp,%rbp
  8037e4:	48 83 ec 20          	sub    $0x20,%rsp
  8037e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f8:	89 c2                	mov    %eax,%edx
  8037fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fe:	8b 40 0c             	mov    0xc(%rax),%eax
  803801:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803805:	b9 00 00 00 00       	mov    $0x0,%ecx
  80380a:	89 c7                	mov    %eax,%edi
  80380c:	48 b8 4a 3b 80 00 00 	movabs $0x803b4a,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
}
  803818:	c9                   	leaveq 
  803819:	c3                   	retq   

000000000080381a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80381a:	55                   	push   %rbp
  80381b:	48 89 e5             	mov    %rsp,%rbp
  80381e:	48 83 ec 20          	sub    $0x20,%rsp
  803822:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803826:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80382a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80382e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803832:	89 c2                	mov    %eax,%edx
  803834:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803838:	8b 40 0c             	mov    0xc(%rax),%eax
  80383b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80383f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803844:	89 c7                	mov    %eax,%edi
  803846:	48 b8 16 3c 80 00 00 	movabs $0x803c16,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
}
  803852:	c9                   	leaveq 
  803853:	c3                   	retq   

0000000000803854 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803854:	55                   	push   %rbp
  803855:	48 89 e5             	mov    %rsp,%rbp
  803858:	48 83 ec 10          	sub    $0x10,%rsp
  80385c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803860:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803868:	48 be c7 52 80 00 00 	movabs $0x8052c7,%rsi
  80386f:	00 00 00 
  803872:	48 89 c7             	mov    %rax,%rdi
  803875:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
	return 0;
  803881:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803886:	c9                   	leaveq 
  803887:	c3                   	retq   

0000000000803888 <socket>:

int
socket(int domain, int type, int protocol)
{
  803888:	55                   	push   %rbp
  803889:	48 89 e5             	mov    %rsp,%rbp
  80388c:	48 83 ec 20          	sub    $0x20,%rsp
  803890:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803893:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803896:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803899:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80389c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80389f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a2:	89 ce                	mov    %ecx,%esi
  8038a4:	89 c7                	mov    %eax,%edi
  8038a6:	48 b8 ce 3c 80 00 00 	movabs $0x803cce,%rax
  8038ad:	00 00 00 
  8038b0:	ff d0                	callq  *%rax
  8038b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b9:	79 05                	jns    8038c0 <socket+0x38>
		return r;
  8038bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038be:	eb 11                	jmp    8038d1 <socket+0x49>
	return alloc_sockfd(r);
  8038c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c3:	89 c7                	mov    %eax,%edi
  8038c5:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  8038cc:	00 00 00 
  8038cf:	ff d0                	callq  *%rax
}
  8038d1:	c9                   	leaveq 
  8038d2:	c3                   	retq   

00000000008038d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038d3:	55                   	push   %rbp
  8038d4:	48 89 e5             	mov    %rsp,%rbp
  8038d7:	48 83 ec 10          	sub    $0x10,%rsp
  8038db:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038de:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038e5:	00 00 00 
  8038e8:	8b 00                	mov    (%rax),%eax
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	75 1f                	jne    80390d <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038ee:	bf 02 00 00 00       	mov    $0x2,%edi
  8038f3:	48 b8 84 49 80 00 00 	movabs $0x804984,%rax
  8038fa:	00 00 00 
  8038fd:	ff d0                	callq  *%rax
  8038ff:	89 c2                	mov    %eax,%edx
  803901:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803908:	00 00 00 
  80390b:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80390d:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803914:	00 00 00 
  803917:	8b 00                	mov    (%rax),%eax
  803919:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80391c:	b9 07 00 00 00       	mov    $0x7,%ecx
  803921:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803928:	00 00 00 
  80392b:	89 c7                	mov    %eax,%edi
  80392d:	48 b8 78 47 80 00 00 	movabs $0x804778,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803939:	ba 00 00 00 00       	mov    $0x0,%edx
  80393e:	be 00 00 00 00       	mov    $0x0,%esi
  803943:	bf 00 00 00 00       	mov    $0x0,%edi
  803948:	48 b8 b7 46 80 00 00 	movabs $0x8046b7,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
}
  803954:	c9                   	leaveq 
  803955:	c3                   	retq   

0000000000803956 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803956:	55                   	push   %rbp
  803957:	48 89 e5             	mov    %rsp,%rbp
  80395a:	48 83 ec 30          	sub    $0x30,%rsp
  80395e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803961:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803965:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803969:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803970:	00 00 00 
  803973:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803976:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803978:	bf 01 00 00 00       	mov    $0x1,%edi
  80397d:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
  803989:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80398c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803990:	78 3e                	js     8039d0 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803992:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803999:	00 00 00 
  80399c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a4:	8b 40 10             	mov    0x10(%rax),%eax
  8039a7:	89 c2                	mov    %eax,%edx
  8039a9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b1:	48 89 ce             	mov    %rcx,%rsi
  8039b4:	48 89 c7             	mov    %rax,%rdi
  8039b7:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  8039be:	00 00 00 
  8039c1:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c7:	8b 50 10             	mov    0x10(%rax),%edx
  8039ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ce:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039d3:	c9                   	leaveq 
  8039d4:	c3                   	retq   

00000000008039d5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039d5:	55                   	push   %rbp
  8039d6:	48 89 e5             	mov    %rsp,%rbp
  8039d9:	48 83 ec 10          	sub    $0x10,%rsp
  8039dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8039e7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039ee:	00 00 00 
  8039f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039f4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039f6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039fd:	48 89 c6             	mov    %rax,%rsi
  803a00:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a07:	00 00 00 
  803a0a:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803a11:	00 00 00 
  803a14:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a16:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a1d:	00 00 00 
  803a20:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a23:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a26:	bf 02 00 00 00       	mov    $0x2,%edi
  803a2b:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
}
  803a37:	c9                   	leaveq 
  803a38:	c3                   	retq   

0000000000803a39 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a39:	55                   	push   %rbp
  803a3a:	48 89 e5             	mov    %rsp,%rbp
  803a3d:	48 83 ec 10          	sub    $0x10,%rsp
  803a41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a44:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a47:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a4e:	00 00 00 
  803a51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a54:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a56:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a5d:	00 00 00 
  803a60:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a63:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a66:	bf 03 00 00 00       	mov    $0x3,%edi
  803a6b:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803a72:	00 00 00 
  803a75:	ff d0                	callq  *%rax
}
  803a77:	c9                   	leaveq 
  803a78:	c3                   	retq   

0000000000803a79 <nsipc_close>:

int
nsipc_close(int s)
{
  803a79:	55                   	push   %rbp
  803a7a:	48 89 e5             	mov    %rsp,%rbp
  803a7d:	48 83 ec 10          	sub    $0x10,%rsp
  803a81:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a84:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a8b:	00 00 00 
  803a8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a91:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a93:	bf 04 00 00 00       	mov    $0x4,%edi
  803a98:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
}
  803aa4:	c9                   	leaveq 
  803aa5:	c3                   	retq   

0000000000803aa6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803aa6:	55                   	push   %rbp
  803aa7:	48 89 e5             	mov    %rsp,%rbp
  803aaa:	48 83 ec 10          	sub    $0x10,%rsp
  803aae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ab1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ab5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ab8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803abf:	00 00 00 
  803ac2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ac5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ac7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ace:	48 89 c6             	mov    %rax,%rsi
  803ad1:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ad8:	00 00 00 
  803adb:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803ae2:	00 00 00 
  803ae5:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803ae7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aee:	00 00 00 
  803af1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803af4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803af7:	bf 05 00 00 00       	mov    $0x5,%edi
  803afc:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax
}
  803b08:	c9                   	leaveq 
  803b09:	c3                   	retq   

0000000000803b0a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b0a:	55                   	push   %rbp
  803b0b:	48 89 e5             	mov    %rsp,%rbp
  803b0e:	48 83 ec 10          	sub    $0x10,%rsp
  803b12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b15:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b18:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b1f:	00 00 00 
  803b22:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b25:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b27:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b2e:	00 00 00 
  803b31:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b34:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b37:	bf 06 00 00 00       	mov    $0x6,%edi
  803b3c:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803b43:	00 00 00 
  803b46:	ff d0                	callq  *%rax
}
  803b48:	c9                   	leaveq 
  803b49:	c3                   	retq   

0000000000803b4a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b4a:	55                   	push   %rbp
  803b4b:	48 89 e5             	mov    %rsp,%rbp
  803b4e:	48 83 ec 30          	sub    $0x30,%rsp
  803b52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b59:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b5c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b5f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b66:	00 00 00 
  803b69:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b6c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b75:	00 00 00 
  803b78:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b7b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b7e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b85:	00 00 00 
  803b88:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b8b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b8e:	bf 07 00 00 00       	mov    $0x7,%edi
  803b93:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803b9a:	00 00 00 
  803b9d:	ff d0                	callq  *%rax
  803b9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba6:	78 69                	js     803c11 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803ba8:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803baf:	7f 08                	jg     803bb9 <nsipc_recv+0x6f>
  803bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb4:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bb7:	7e 35                	jle    803bee <nsipc_recv+0xa4>
  803bb9:	48 b9 ce 52 80 00 00 	movabs $0x8052ce,%rcx
  803bc0:	00 00 00 
  803bc3:	48 ba e3 52 80 00 00 	movabs $0x8052e3,%rdx
  803bca:	00 00 00 
  803bcd:	be 62 00 00 00       	mov    $0x62,%esi
  803bd2:	48 bf f8 52 80 00 00 	movabs $0x8052f8,%rdi
  803bd9:	00 00 00 
  803bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803be1:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  803be8:	00 00 00 
  803beb:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf1:	48 63 d0             	movslq %eax,%rdx
  803bf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf8:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803bff:	00 00 00 
  803c02:	48 89 c7             	mov    %rax,%rdi
  803c05:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
	}

	return r;
  803c11:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c14:	c9                   	leaveq 
  803c15:	c3                   	retq   

0000000000803c16 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c16:	55                   	push   %rbp
  803c17:	48 89 e5             	mov    %rsp,%rbp
  803c1a:	48 83 ec 20          	sub    $0x20,%rsp
  803c1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c25:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c28:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c2b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c32:	00 00 00 
  803c35:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c38:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c3a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c41:	7e 35                	jle    803c78 <nsipc_send+0x62>
  803c43:	48 b9 04 53 80 00 00 	movabs $0x805304,%rcx
  803c4a:	00 00 00 
  803c4d:	48 ba e3 52 80 00 00 	movabs $0x8052e3,%rdx
  803c54:	00 00 00 
  803c57:	be 6d 00 00 00       	mov    $0x6d,%esi
  803c5c:	48 bf f8 52 80 00 00 	movabs $0x8052f8,%rdi
  803c63:	00 00 00 
  803c66:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6b:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  803c72:	00 00 00 
  803c75:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c7b:	48 63 d0             	movslq %eax,%rdx
  803c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c82:	48 89 c6             	mov    %rax,%rsi
  803c85:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c8c:	00 00 00 
  803c8f:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c9b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca2:	00 00 00 
  803ca5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ca8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cab:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb2:	00 00 00 
  803cb5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cb8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803cbb:	bf 08 00 00 00       	mov    $0x8,%edi
  803cc0:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
}
  803ccc:	c9                   	leaveq 
  803ccd:	c3                   	retq   

0000000000803cce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803cce:	55                   	push   %rbp
  803ccf:	48 89 e5             	mov    %rsp,%rbp
  803cd2:	48 83 ec 10          	sub    $0x10,%rsp
  803cd6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cd9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803cdc:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803cdf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce6:	00 00 00 
  803ce9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cec:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803cee:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf5:	00 00 00 
  803cf8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cfb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803cfe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d05:	00 00 00 
  803d08:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d0b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d0e:	bf 09 00 00 00       	mov    $0x9,%edi
  803d13:	48 b8 d3 38 80 00 00 	movabs $0x8038d3,%rax
  803d1a:	00 00 00 
  803d1d:	ff d0                	callq  *%rax
}
  803d1f:	c9                   	leaveq 
  803d20:	c3                   	retq   

0000000000803d21 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d21:	55                   	push   %rbp
  803d22:	48 89 e5             	mov    %rsp,%rbp
  803d25:	53                   	push   %rbx
  803d26:	48 83 ec 38          	sub    $0x38,%rsp
  803d2a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d2e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d32:	48 89 c7             	mov    %rax,%rdi
  803d35:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
  803d41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d48:	0f 88 bf 01 00 00    	js     803f0d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d52:	ba 07 04 00 00       	mov    $0x407,%edx
  803d57:	48 89 c6             	mov    %rax,%rsi
  803d5a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d5f:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
  803d6b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d72:	0f 88 95 01 00 00    	js     803f0d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d78:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d7c:	48 89 c7             	mov    %rax,%rdi
  803d7f:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d92:	0f 88 5d 01 00 00    	js     803ef5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d9c:	ba 07 04 00 00       	mov    $0x407,%edx
  803da1:	48 89 c6             	mov    %rax,%rsi
  803da4:	bf 00 00 00 00       	mov    $0x0,%edi
  803da9:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803db0:	00 00 00 
  803db3:	ff d0                	callq  *%rax
  803db5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dbc:	0f 88 33 01 00 00    	js     803ef5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803dc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc6:	48 89 c7             	mov    %rax,%rdi
  803dc9:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
  803dd5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ddd:	ba 07 04 00 00       	mov    $0x407,%edx
  803de2:	48 89 c6             	mov    %rax,%rsi
  803de5:	bf 00 00 00 00       	mov    $0x0,%edi
  803dea:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
  803df6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803df9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dfd:	0f 88 d9 00 00 00    	js     803edc <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e07:	48 89 c7             	mov    %rax,%rdi
  803e0a:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
  803e16:	48 89 c2             	mov    %rax,%rdx
  803e19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e1d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e23:	48 89 d1             	mov    %rdx,%rcx
  803e26:	ba 00 00 00 00       	mov    $0x0,%edx
  803e2b:	48 89 c6             	mov    %rax,%rsi
  803e2e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e33:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
  803e3f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e46:	78 79                	js     803ec1 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e4c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e53:	00 00 00 
  803e56:	8b 12                	mov    (%rdx),%edx
  803e58:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e69:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e70:	00 00 00 
  803e73:	8b 12                	mov    (%rdx),%edx
  803e75:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e7b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e86:	48 89 c7             	mov    %rax,%rdi
  803e89:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  803e90:	00 00 00 
  803e93:	ff d0                	callq  *%rax
  803e95:	89 c2                	mov    %eax,%edx
  803e97:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e9b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ea1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ea5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea9:	48 89 c7             	mov    %rax,%rdi
  803eac:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  803eb3:	00 00 00 
  803eb6:	ff d0                	callq  *%rax
  803eb8:	89 03                	mov    %eax,(%rbx)
	return 0;
  803eba:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebf:	eb 4f                	jmp    803f10 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ec1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803ec2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec6:	48 89 c6             	mov    %rax,%rsi
  803ec9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ece:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
  803eda:	eb 01                	jmp    803edd <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803edc:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803edd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ee1:	48 89 c6             	mov    %rax,%rsi
  803ee4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee9:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  803ef0:	00 00 00 
  803ef3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ef5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef9:	48 89 c6             	mov    %rax,%rsi
  803efc:	bf 00 00 00 00       	mov    $0x0,%edi
  803f01:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  803f08:	00 00 00 
  803f0b:	ff d0                	callq  *%rax
err:
	return r;
  803f0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f10:	48 83 c4 38          	add    $0x38,%rsp
  803f14:	5b                   	pop    %rbx
  803f15:	5d                   	pop    %rbp
  803f16:	c3                   	retq   

0000000000803f17 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f17:	55                   	push   %rbp
  803f18:	48 89 e5             	mov    %rsp,%rbp
  803f1b:	53                   	push   %rbx
  803f1c:	48 83 ec 28          	sub    $0x28,%rsp
  803f20:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f24:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f28:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f2f:	00 00 00 
  803f32:	48 8b 00             	mov    (%rax),%rax
  803f35:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f3b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f42:	48 89 c7             	mov    %rax,%rdi
  803f45:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
  803f51:	89 c3                	mov    %eax,%ebx
  803f53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f57:	48 89 c7             	mov    %rax,%rdi
  803f5a:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
  803f66:	39 c3                	cmp    %eax,%ebx
  803f68:	0f 94 c0             	sete   %al
  803f6b:	0f b6 c0             	movzbl %al,%eax
  803f6e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f71:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f78:	00 00 00 
  803f7b:	48 8b 00             	mov    (%rax),%rax
  803f7e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f84:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f8d:	75 05                	jne    803f94 <_pipeisclosed+0x7d>
			return ret;
  803f8f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f92:	eb 4a                	jmp    803fde <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803f94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f97:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f9a:	74 8c                	je     803f28 <_pipeisclosed+0x11>
  803f9c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fa0:	75 86                	jne    803f28 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fa2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fa9:	00 00 00 
  803fac:	48 8b 00             	mov    (%rax),%rax
  803faf:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fb5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fbb:	89 c6                	mov    %eax,%esi
  803fbd:	48 bf 15 53 80 00 00 	movabs $0x805315,%rdi
  803fc4:	00 00 00 
  803fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcc:	49 b8 06 06 80 00 00 	movabs $0x800606,%r8
  803fd3:	00 00 00 
  803fd6:	41 ff d0             	callq  *%r8
	}
  803fd9:	e9 4a ff ff ff       	jmpq   803f28 <_pipeisclosed+0x11>

}
  803fde:	48 83 c4 28          	add    $0x28,%rsp
  803fe2:	5b                   	pop    %rbx
  803fe3:	5d                   	pop    %rbp
  803fe4:	c3                   	retq   

0000000000803fe5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803fe5:	55                   	push   %rbp
  803fe6:	48 89 e5             	mov    %rsp,%rbp
  803fe9:	48 83 ec 30          	sub    $0x30,%rsp
  803fed:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ff0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ff4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ff7:	48 89 d6             	mov    %rdx,%rsi
  803ffa:	89 c7                	mov    %eax,%edi
  803ffc:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  804003:	00 00 00 
  804006:	ff d0                	callq  *%rax
  804008:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80400b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400f:	79 05                	jns    804016 <pipeisclosed+0x31>
		return r;
  804011:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804014:	eb 31                	jmp    804047 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401a:	48 89 c7             	mov    %rax,%rdi
  80401d:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  804024:	00 00 00 
  804027:	ff d0                	callq  *%rax
  804029:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80402d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804031:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804035:	48 89 d6             	mov    %rdx,%rsi
  804038:	48 89 c7             	mov    %rax,%rdi
  80403b:	48 b8 17 3f 80 00 00 	movabs $0x803f17,%rax
  804042:	00 00 00 
  804045:	ff d0                	callq  *%rax
}
  804047:	c9                   	leaveq 
  804048:	c3                   	retq   

0000000000804049 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804049:	55                   	push   %rbp
  80404a:	48 89 e5             	mov    %rsp,%rbp
  80404d:	48 83 ec 40          	sub    $0x40,%rsp
  804051:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804055:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804059:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80405d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804061:	48 89 c7             	mov    %rax,%rdi
  804064:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  80406b:	00 00 00 
  80406e:	ff d0                	callq  *%rax
  804070:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804074:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804078:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80407c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804083:	00 
  804084:	e9 90 00 00 00       	jmpq   804119 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804089:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80408e:	74 09                	je     804099 <devpipe_read+0x50>
				return i;
  804090:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804094:	e9 8e 00 00 00       	jmpq   804127 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804099:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80409d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a1:	48 89 d6             	mov    %rdx,%rsi
  8040a4:	48 89 c7             	mov    %rax,%rdi
  8040a7:	48 b8 17 3f 80 00 00 	movabs $0x803f17,%rax
  8040ae:	00 00 00 
  8040b1:	ff d0                	callq  *%rax
  8040b3:	85 c0                	test   %eax,%eax
  8040b5:	74 07                	je     8040be <devpipe_read+0x75>
				return 0;
  8040b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bc:	eb 69                	jmp    804127 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040be:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  8040c5:	00 00 00 
  8040c8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ce:	8b 10                	mov    (%rax),%edx
  8040d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d4:	8b 40 04             	mov    0x4(%rax),%eax
  8040d7:	39 c2                	cmp    %eax,%edx
  8040d9:	74 ae                	je     804089 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040eb:	8b 00                	mov    (%rax),%eax
  8040ed:	99                   	cltd   
  8040ee:	c1 ea 1b             	shr    $0x1b,%edx
  8040f1:	01 d0                	add    %edx,%eax
  8040f3:	83 e0 1f             	and    $0x1f,%eax
  8040f6:	29 d0                	sub    %edx,%eax
  8040f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040fc:	48 98                	cltq   
  8040fe:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804103:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804109:	8b 00                	mov    (%rax),%eax
  80410b:	8d 50 01             	lea    0x1(%rax),%edx
  80410e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804112:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804114:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804121:	72 a7                	jb     8040ca <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804123:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804127:	c9                   	leaveq 
  804128:	c3                   	retq   

0000000000804129 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804129:	55                   	push   %rbp
  80412a:	48 89 e5             	mov    %rsp,%rbp
  80412d:	48 83 ec 40          	sub    $0x40,%rsp
  804131:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804135:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804139:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80413d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804141:	48 89 c7             	mov    %rax,%rdi
  804144:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  80414b:	00 00 00 
  80414e:	ff d0                	callq  *%rax
  804150:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804154:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804158:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80415c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804163:	00 
  804164:	e9 8f 00 00 00       	jmpq   8041f8 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804169:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80416d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804171:	48 89 d6             	mov    %rdx,%rsi
  804174:	48 89 c7             	mov    %rax,%rdi
  804177:	48 b8 17 3f 80 00 00 	movabs $0x803f17,%rax
  80417e:	00 00 00 
  804181:	ff d0                	callq  *%rax
  804183:	85 c0                	test   %eax,%eax
  804185:	74 07                	je     80418e <devpipe_write+0x65>
				return 0;
  804187:	b8 00 00 00 00       	mov    $0x0,%eax
  80418c:	eb 78                	jmp    804206 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80418e:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  804195:	00 00 00 
  804198:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80419a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80419e:	8b 40 04             	mov    0x4(%rax),%eax
  8041a1:	48 63 d0             	movslq %eax,%rdx
  8041a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a8:	8b 00                	mov    (%rax),%eax
  8041aa:	48 98                	cltq   
  8041ac:	48 83 c0 20          	add    $0x20,%rax
  8041b0:	48 39 c2             	cmp    %rax,%rdx
  8041b3:	73 b4                	jae    804169 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b9:	8b 40 04             	mov    0x4(%rax),%eax
  8041bc:	99                   	cltd   
  8041bd:	c1 ea 1b             	shr    $0x1b,%edx
  8041c0:	01 d0                	add    %edx,%eax
  8041c2:	83 e0 1f             	and    $0x1f,%eax
  8041c5:	29 d0                	sub    %edx,%eax
  8041c7:	89 c6                	mov    %eax,%esi
  8041c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d1:	48 01 d0             	add    %rdx,%rax
  8041d4:	0f b6 08             	movzbl (%rax),%ecx
  8041d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041db:	48 63 c6             	movslq %esi,%rax
  8041de:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e6:	8b 40 04             	mov    0x4(%rax),%eax
  8041e9:	8d 50 01             	lea    0x1(%rax),%edx
  8041ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804200:	72 98                	jb     80419a <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804206:	c9                   	leaveq 
  804207:	c3                   	retq   

0000000000804208 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804208:	55                   	push   %rbp
  804209:	48 89 e5             	mov    %rsp,%rbp
  80420c:	48 83 ec 20          	sub    $0x20,%rsp
  804210:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804214:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80421c:	48 89 c7             	mov    %rax,%rdi
  80421f:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  804226:	00 00 00 
  804229:	ff d0                	callq  *%rax
  80422b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80422f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804233:	48 be 28 53 80 00 00 	movabs $0x805328,%rsi
  80423a:	00 00 00 
  80423d:	48 89 c7             	mov    %rax,%rdi
  804240:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  804247:	00 00 00 
  80424a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80424c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804250:	8b 50 04             	mov    0x4(%rax),%edx
  804253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804257:	8b 00                	mov    (%rax),%eax
  804259:	29 c2                	sub    %eax,%edx
  80425b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80425f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804269:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804270:	00 00 00 
	stat->st_dev = &devpipe;
  804273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804277:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80427e:	00 00 00 
  804281:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80428d:	c9                   	leaveq 
  80428e:	c3                   	retq   

000000000080428f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80428f:	55                   	push   %rbp
  804290:	48 89 e5             	mov    %rsp,%rbp
  804293:	48 83 ec 10          	sub    $0x10,%rsp
  804297:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80429b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429f:	48 89 c6             	mov    %rax,%rsi
  8042a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8042a7:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8042ae:	00 00 00 
  8042b1:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8042b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b7:	48 89 c7             	mov    %rax,%rdi
  8042ba:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8042c1:	00 00 00 
  8042c4:	ff d0                	callq  *%rax
  8042c6:	48 89 c6             	mov    %rax,%rsi
  8042c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8042ce:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8042d5:	00 00 00 
  8042d8:	ff d0                	callq  *%rax
}
  8042da:	c9                   	leaveq 
  8042db:	c3                   	retq   

00000000008042dc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8042dc:	55                   	push   %rbp
  8042dd:	48 89 e5             	mov    %rsp,%rbp
  8042e0:	48 83 ec 20          	sub    $0x20,%rsp
  8042e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8042e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ea:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8042ed:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8042f1:	be 01 00 00 00       	mov    $0x1,%esi
  8042f6:	48 89 c7             	mov    %rax,%rdi
  8042f9:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  804300:	00 00 00 
  804303:	ff d0                	callq  *%rax
}
  804305:	90                   	nop
  804306:	c9                   	leaveq 
  804307:	c3                   	retq   

0000000000804308 <getchar>:

int
getchar(void)
{
  804308:	55                   	push   %rbp
  804309:	48 89 e5             	mov    %rsp,%rbp
  80430c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804310:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804314:	ba 01 00 00 00       	mov    $0x1,%edx
  804319:	48 89 c6             	mov    %rax,%rsi
  80431c:	bf 00 00 00 00       	mov    $0x0,%edi
  804321:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  804328:	00 00 00 
  80432b:	ff d0                	callq  *%rax
  80432d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804330:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804334:	79 05                	jns    80433b <getchar+0x33>
		return r;
  804336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804339:	eb 14                	jmp    80434f <getchar+0x47>
	if (r < 1)
  80433b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80433f:	7f 07                	jg     804348 <getchar+0x40>
		return -E_EOF;
  804341:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804346:	eb 07                	jmp    80434f <getchar+0x47>
	return c;
  804348:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80434c:	0f b6 c0             	movzbl %al,%eax

}
  80434f:	c9                   	leaveq 
  804350:	c3                   	retq   

0000000000804351 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804351:	55                   	push   %rbp
  804352:	48 89 e5             	mov    %rsp,%rbp
  804355:	48 83 ec 20          	sub    $0x20,%rsp
  804359:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80435c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804360:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804363:	48 89 d6             	mov    %rdx,%rsi
  804366:	89 c7                	mov    %eax,%edi
  804368:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  80436f:	00 00 00 
  804372:	ff d0                	callq  *%rax
  804374:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80437b:	79 05                	jns    804382 <iscons+0x31>
		return r;
  80437d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804380:	eb 1a                	jmp    80439c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804386:	8b 10                	mov    (%rax),%edx
  804388:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80438f:	00 00 00 
  804392:	8b 00                	mov    (%rax),%eax
  804394:	39 c2                	cmp    %eax,%edx
  804396:	0f 94 c0             	sete   %al
  804399:	0f b6 c0             	movzbl %al,%eax
}
  80439c:	c9                   	leaveq 
  80439d:	c3                   	retq   

000000000080439e <opencons>:

int
opencons(void)
{
  80439e:	55                   	push   %rbp
  80439f:	48 89 e5             	mov    %rsp,%rbp
  8043a2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8043a6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043aa:	48 89 c7             	mov    %rax,%rdi
  8043ad:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
  8043b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043c0:	79 05                	jns    8043c7 <opencons+0x29>
		return r;
  8043c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c5:	eb 5b                	jmp    804422 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8043c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8043d0:	48 89 c6             	mov    %rax,%rsi
  8043d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d8:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8043df:	00 00 00 
  8043e2:	ff d0                	callq  *%rax
  8043e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043eb:	79 05                	jns    8043f2 <opencons+0x54>
		return r;
  8043ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f0:	eb 30                	jmp    804422 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8043f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f6:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8043fd:	00 00 00 
  804400:	8b 12                	mov    (%rdx),%edx
  804402:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804408:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80440f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804413:	48 89 c7             	mov    %rax,%rdi
  804416:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  80441d:	00 00 00 
  804420:	ff d0                	callq  *%rax
}
  804422:	c9                   	leaveq 
  804423:	c3                   	retq   

0000000000804424 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804424:	55                   	push   %rbp
  804425:	48 89 e5             	mov    %rsp,%rbp
  804428:	48 83 ec 30          	sub    $0x30,%rsp
  80442c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804430:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804434:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804438:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80443d:	75 13                	jne    804452 <devcons_read+0x2e>
		return 0;
  80443f:	b8 00 00 00 00       	mov    $0x0,%eax
  804444:	eb 49                	jmp    80448f <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804446:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  80444d:	00 00 00 
  804450:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804452:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  804459:	00 00 00 
  80445c:	ff d0                	callq  *%rax
  80445e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804461:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804465:	74 df                	je     804446 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446b:	79 05                	jns    804472 <devcons_read+0x4e>
		return c;
  80446d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804470:	eb 1d                	jmp    80448f <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804472:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804476:	75 07                	jne    80447f <devcons_read+0x5b>
		return 0;
  804478:	b8 00 00 00 00       	mov    $0x0,%eax
  80447d:	eb 10                	jmp    80448f <devcons_read+0x6b>
	*(char*)vbuf = c;
  80447f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804482:	89 c2                	mov    %eax,%edx
  804484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804488:	88 10                	mov    %dl,(%rax)
	return 1;
  80448a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80448f:	c9                   	leaveq 
  804490:	c3                   	retq   

0000000000804491 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804491:	55                   	push   %rbp
  804492:	48 89 e5             	mov    %rsp,%rbp
  804495:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80449c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8044a3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8044aa:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044b8:	eb 76                	jmp    804530 <devcons_write+0x9f>
		m = n - tot;
  8044ba:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8044c1:	89 c2                	mov    %eax,%edx
  8044c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c6:	29 c2                	sub    %eax,%edx
  8044c8:	89 d0                	mov    %edx,%eax
  8044ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8044cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044d0:	83 f8 7f             	cmp    $0x7f,%eax
  8044d3:	76 07                	jbe    8044dc <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8044d5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8044dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044df:	48 63 d0             	movslq %eax,%rdx
  8044e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e5:	48 63 c8             	movslq %eax,%rcx
  8044e8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8044ef:	48 01 c1             	add    %rax,%rcx
  8044f2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044f9:	48 89 ce             	mov    %rcx,%rsi
  8044fc:	48 89 c7             	mov    %rax,%rdi
  8044ff:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  804506:	00 00 00 
  804509:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80450b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80450e:	48 63 d0             	movslq %eax,%rdx
  804511:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804518:	48 89 d6             	mov    %rdx,%rsi
  80451b:	48 89 c7             	mov    %rax,%rdi
  80451e:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  804525:	00 00 00 
  804528:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80452a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80452d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804533:	48 98                	cltq   
  804535:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80453c:	0f 82 78 ff ff ff    	jb     8044ba <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804542:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804545:	c9                   	leaveq 
  804546:	c3                   	retq   

0000000000804547 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804547:	55                   	push   %rbp
  804548:	48 89 e5             	mov    %rsp,%rbp
  80454b:	48 83 ec 08          	sub    $0x8,%rsp
  80454f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804558:	c9                   	leaveq 
  804559:	c3                   	retq   

000000000080455a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80455a:	55                   	push   %rbp
  80455b:	48 89 e5             	mov    %rsp,%rbp
  80455e:	48 83 ec 10          	sub    $0x10,%rsp
  804562:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804566:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80456a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456e:	48 be 34 53 80 00 00 	movabs $0x805334,%rsi
  804575:	00 00 00 
  804578:	48 89 c7             	mov    %rax,%rdi
  80457b:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  804582:	00 00 00 
  804585:	ff d0                	callq  *%rax
	return 0;
  804587:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80458c:	c9                   	leaveq 
  80458d:	c3                   	retq   

000000000080458e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80458e:	55                   	push   %rbp
  80458f:	48 89 e5             	mov    %rsp,%rbp
  804592:	48 83 ec 20          	sub    $0x20,%rsp
  804596:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80459a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045a1:	00 00 00 
  8045a4:	48 8b 00             	mov    (%rax),%rax
  8045a7:	48 85 c0             	test   %rax,%rax
  8045aa:	75 6f                	jne    80461b <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8045ac:	ba 07 00 00 00       	mov    $0x7,%edx
  8045b1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8045b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8045bb:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
  8045c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ce:	79 30                	jns    804600 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8045d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d3:	89 c1                	mov    %eax,%ecx
  8045d5:	48 ba 40 53 80 00 00 	movabs $0x805340,%rdx
  8045dc:	00 00 00 
  8045df:	be 22 00 00 00       	mov    $0x22,%esi
  8045e4:	48 bf 5f 53 80 00 00 	movabs $0x80535f,%rdi
  8045eb:	00 00 00 
  8045ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8045f3:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8045fa:	00 00 00 
  8045fd:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804600:	48 be 2f 46 80 00 00 	movabs $0x80462f,%rsi
  804607:	00 00 00 
  80460a:	bf 00 00 00 00       	mov    $0x0,%edi
  80460f:	48 b8 63 1c 80 00 00 	movabs $0x801c63,%rax
  804616:	00 00 00 
  804619:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80461b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804622:	00 00 00 
  804625:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804629:	48 89 10             	mov    %rdx,(%rax)
}
  80462c:	90                   	nop
  80462d:	c9                   	leaveq 
  80462e:	c3                   	retq   

000000000080462f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80462f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804632:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804639:	00 00 00 
call *%rax
  80463c:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  80463e:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804645:	00 08 
    movq 152(%rsp), %rax
  804647:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  80464e:	00 
    movq 136(%rsp), %rbx
  80464f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804656:	00 
movq %rbx, (%rax)
  804657:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  80465a:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80465e:	4c 8b 3c 24          	mov    (%rsp),%r15
  804662:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804667:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80466c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804671:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804676:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80467b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804680:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804685:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80468a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80468f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804694:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804699:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80469e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8046a3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8046a8:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  8046ac:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8046b0:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8046b1:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8046b6:	c3                   	retq   

00000000008046b7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8046b7:	55                   	push   %rbp
  8046b8:	48 89 e5             	mov    %rsp,%rbp
  8046bb:	48 83 ec 30          	sub    $0x30,%rsp
  8046bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8046cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046d0:	75 0e                	jne    8046e0 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8046d2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8046d9:	00 00 00 
  8046dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8046e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046e4:	48 89 c7             	mov    %rax,%rdi
  8046e7:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  8046ee:	00 00 00 
  8046f1:	ff d0                	callq  *%rax
  8046f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046fa:	79 27                	jns    804723 <ipc_recv+0x6c>
		if (from_env_store)
  8046fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804701:	74 0a                	je     80470d <ipc_recv+0x56>
			*from_env_store = 0;
  804703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804707:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80470d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804712:	74 0a                	je     80471e <ipc_recv+0x67>
			*perm_store = 0;
  804714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804718:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80471e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804721:	eb 53                	jmp    804776 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804723:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804728:	74 19                	je     804743 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80472a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804731:	00 00 00 
  804734:	48 8b 00             	mov    (%rax),%rax
  804737:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80473d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804741:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804743:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804748:	74 19                	je     804763 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80474a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804751:	00 00 00 
  804754:	48 8b 00             	mov    (%rax),%rax
  804757:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80475d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804761:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804763:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80476a:	00 00 00 
  80476d:	48 8b 00             	mov    (%rax),%rax
  804770:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804776:	c9                   	leaveq 
  804777:	c3                   	retq   

0000000000804778 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804778:	55                   	push   %rbp
  804779:	48 89 e5             	mov    %rsp,%rbp
  80477c:	48 83 ec 30          	sub    $0x30,%rsp
  804780:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804783:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804786:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80478a:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80478d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804792:	75 1c                	jne    8047b0 <ipc_send+0x38>
		pg = (void*) UTOP;
  804794:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80479b:	00 00 00 
  80479e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8047a2:	eb 0c                	jmp    8047b0 <ipc_send+0x38>
		sys_yield();
  8047a4:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  8047ab:	00 00 00 
  8047ae:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8047b0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047b3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8047b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8047ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047bd:	89 c7                	mov    %eax,%edi
  8047bf:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  8047c6:	00 00 00 
  8047c9:	ff d0                	callq  *%rax
  8047cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047ce:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047d2:	74 d0                	je     8047a4 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8047d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d8:	79 30                	jns    80480a <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8047da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047dd:	89 c1                	mov    %eax,%ecx
  8047df:	48 ba 6d 53 80 00 00 	movabs $0x80536d,%rdx
  8047e6:	00 00 00 
  8047e9:	be 47 00 00 00       	mov    $0x47,%esi
  8047ee:	48 bf 83 53 80 00 00 	movabs $0x805383,%rdi
  8047f5:	00 00 00 
  8047f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8047fd:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  804804:	00 00 00 
  804807:	41 ff d0             	callq  *%r8

}
  80480a:	90                   	nop
  80480b:	c9                   	leaveq 
  80480c:	c3                   	retq   

000000000080480d <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80480d:	55                   	push   %rbp
  80480e:	48 89 e5             	mov    %rsp,%rbp
  804811:	53                   	push   %rbx
  804812:	48 83 ec 28          	sub    $0x28,%rsp
  804816:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  80481a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804821:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804828:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80482d:	75 0e                	jne    80483d <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  80482f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804836:	00 00 00 
  804839:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  80483d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804841:	ba 07 00 00 00       	mov    $0x7,%edx
  804846:	48 89 c6             	mov    %rax,%rsi
  804849:	bf 00 00 00 00       	mov    $0x0,%edi
  80484e:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  804855:	00 00 00 
  804858:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80485a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80485e:	48 c1 e8 0c          	shr    $0xc,%rax
  804862:	48 89 c2             	mov    %rax,%rdx
  804865:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80486c:	01 00 00 
  80486f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804873:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804879:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  80487d:	b8 03 00 00 00       	mov    $0x3,%eax
  804882:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804886:	48 89 d3             	mov    %rdx,%rbx
  804889:	0f 01 c1             	vmcall 
  80488c:	89 f2                	mov    %esi,%edx
  80488e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804891:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804894:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804898:	79 05                	jns    80489f <ipc_host_recv+0x92>
		return r;
  80489a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80489d:	eb 03                	jmp    8048a2 <ipc_host_recv+0x95>
	}
	return val;
  80489f:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  8048a2:	48 83 c4 28          	add    $0x28,%rsp
  8048a6:	5b                   	pop    %rbx
  8048a7:	5d                   	pop    %rbp
  8048a8:	c3                   	retq   

00000000008048a9 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8048a9:	55                   	push   %rbp
  8048aa:	48 89 e5             	mov    %rsp,%rbp
  8048ad:	53                   	push   %rbx
  8048ae:	48 83 ec 38          	sub    $0x38,%rsp
  8048b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8048b5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8048b8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8048bc:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  8048bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  8048c6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8048cb:	75 0e                	jne    8048db <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8048cd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048d4:	00 00 00 
  8048d7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8048db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048df:	48 c1 e8 0c          	shr    $0xc,%rax
  8048e3:	48 89 c2             	mov    %rax,%rdx
  8048e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048ed:	01 00 00 
  8048f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048f4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8048fa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8048fe:	b8 02 00 00 00       	mov    $0x2,%eax
  804903:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804906:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804909:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80490d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804910:	89 fb                	mov    %edi,%ebx
  804912:	0f 01 c1             	vmcall 
  804915:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804918:	eb 26                	jmp    804940 <ipc_host_send+0x97>
		sys_yield();
  80491a:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  804921:	00 00 00 
  804924:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804926:	b8 02 00 00 00       	mov    $0x2,%eax
  80492b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80492e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804931:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804935:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804938:	89 fb                	mov    %edi,%ebx
  80493a:	0f 01 c1             	vmcall 
  80493d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804940:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804944:	74 d4                	je     80491a <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804946:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80494a:	79 30                	jns    80497c <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  80494c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80494f:	89 c1                	mov    %eax,%ecx
  804951:	48 ba 6d 53 80 00 00 	movabs $0x80536d,%rdx
  804958:	00 00 00 
  80495b:	be 79 00 00 00       	mov    $0x79,%esi
  804960:	48 bf 83 53 80 00 00 	movabs $0x805383,%rdi
  804967:	00 00 00 
  80496a:	b8 00 00 00 00       	mov    $0x0,%eax
  80496f:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  804976:	00 00 00 
  804979:	41 ff d0             	callq  *%r8

}
  80497c:	90                   	nop
  80497d:	48 83 c4 38          	add    $0x38,%rsp
  804981:	5b                   	pop    %rbx
  804982:	5d                   	pop    %rbp
  804983:	c3                   	retq   

0000000000804984 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804984:	55                   	push   %rbp
  804985:	48 89 e5             	mov    %rsp,%rbp
  804988:	48 83 ec 18          	sub    $0x18,%rsp
  80498c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80498f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804996:	eb 4d                	jmp    8049e5 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804998:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80499f:	00 00 00 
  8049a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a5:	48 98                	cltq   
  8049a7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8049ae:	48 01 d0             	add    %rdx,%rax
  8049b1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8049b7:	8b 00                	mov    (%rax),%eax
  8049b9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8049bc:	75 23                	jne    8049e1 <ipc_find_env+0x5d>
			return envs[i].env_id;
  8049be:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8049c5:	00 00 00 
  8049c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049cb:	48 98                	cltq   
  8049cd:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8049d4:	48 01 d0             	add    %rdx,%rax
  8049d7:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8049dd:	8b 00                	mov    (%rax),%eax
  8049df:	eb 12                	jmp    8049f3 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8049e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8049e5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8049ec:	7e aa                	jle    804998 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8049ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049f3:	c9                   	leaveq 
  8049f4:	c3                   	retq   

00000000008049f5 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8049f5:	55                   	push   %rbp
  8049f6:	48 89 e5             	mov    %rsp,%rbp
  8049f9:	48 83 ec 18          	sub    $0x18,%rsp
  8049fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a05:	48 c1 e8 15          	shr    $0x15,%rax
  804a09:	48 89 c2             	mov    %rax,%rdx
  804a0c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804a13:	01 00 00 
  804a16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a1a:	83 e0 01             	and    $0x1,%eax
  804a1d:	48 85 c0             	test   %rax,%rax
  804a20:	75 07                	jne    804a29 <pageref+0x34>
		return 0;
  804a22:	b8 00 00 00 00       	mov    $0x0,%eax
  804a27:	eb 56                	jmp    804a7f <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a2d:	48 c1 e8 0c          	shr    $0xc,%rax
  804a31:	48 89 c2             	mov    %rax,%rdx
  804a34:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804a3b:	01 00 00 
  804a3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a4a:	83 e0 01             	and    $0x1,%eax
  804a4d:	48 85 c0             	test   %rax,%rax
  804a50:	75 07                	jne    804a59 <pageref+0x64>
		return 0;
  804a52:	b8 00 00 00 00       	mov    $0x0,%eax
  804a57:	eb 26                	jmp    804a7f <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804a59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a5d:	48 c1 e8 0c          	shr    $0xc,%rax
  804a61:	48 89 c2             	mov    %rax,%rdx
  804a64:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a6b:	00 00 00 
  804a6e:	48 c1 e2 04          	shl    $0x4,%rdx
  804a72:	48 01 d0             	add    %rdx,%rax
  804a75:	48 83 c0 08          	add    $0x8,%rax
  804a79:	0f b7 00             	movzwl (%rax),%eax
  804a7c:	0f b7 c0             	movzwl %ax,%eax
}
  804a7f:	c9                   	leaveq 
  804a80:	c3                   	retq   
