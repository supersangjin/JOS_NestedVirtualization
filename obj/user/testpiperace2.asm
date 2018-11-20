
obj/user/testpiperace2:     file format elf64-x86-64


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
  800052:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 1d 3e 80 00 00 	movabs $0x803e1d,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 42 4a 80 00 00 	movabs $0x804a42,%rdx
  800095:	00 00 00 
  800098:	be 0e 00 00 00       	mov    $0xe,%esi
  80009d:	48 bf 4b 4a 80 00 00 	movabs $0x804a4b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 65 23 80 00 00 	movabs $0x802365,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 60 4a 80 00 00 	movabs $0x804a60,%rdx
  8000da:	00 00 00 
  8000dd:	be 10 00 00 00       	mov    $0x10,%esi
  8000e2:	48 bf 4b 4a 80 00 00 	movabs $0x804a4b,%rdi
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
  80010d:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
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
  800151:	48 bf 69 4a 80 00 00 	movabs $0x804a69,%rdi
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
  800176:	48 b8 4e 29 80 00 00 	movabs $0x80294e,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
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
  8001f1:	48 b8 e1 40 80 00 00 	movabs $0x8040e1,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 38                	je     800239 <umain+0x1f6>
			cprintf("\nRACE: pipe appears closed\n");
  800201:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
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
  800248:	48 bf 89 4a 80 00 00 	movabs $0x804a89,%rdi
  80024f:	00 00 00 
  800252:	b8 00 00 00 00       	mov    $0x0,%eax
  800257:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  80025e:	00 00 00 
  800261:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800263:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 e1 40 80 00 00 	movabs $0x8040e1,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
  800274:	85 c0                	test   %eax,%eax
  800276:	74 2a                	je     8002a2 <umain+0x25f>
		panic("somehow the other end of p[0] got closed!");
  800278:	48 ba a0 4a 80 00 00 	movabs $0x804aa0,%rdx
  80027f:	00 00 00 
  800282:	be 41 00 00 00       	mov    $0x41,%esi
  800287:	48 bf 4b 4a 80 00 00 	movabs $0x804a4b,%rdi
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
  8002ae:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax
  8002ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c1:	79 30                	jns    8002f3 <umain+0x2b0>
		panic("cannot look up p[0]: %e", r);
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	89 c1                	mov    %eax,%ecx
  8002c8:	48 ba ca 4a 80 00 00 	movabs $0x804aca,%rdx
  8002cf:	00 00 00 
  8002d2:	be 43 00 00 00       	mov    $0x43,%esi
  8002d7:	48 bf 4b 4a 80 00 00 	movabs $0x804a4b,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8002ed:	00 00 00 
  8002f0:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002f7:	48 89 c7             	mov    %rax,%rdi
  8002fa:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800306:	48 bf e2 4a 80 00 00 	movabs $0x804ae2,%rdi
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
  8003ac:	48 b8 1f 29 80 00 00 	movabs $0x80291f,%rax
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
  800486:	48 bf 00 4b 80 00 00 	movabs $0x804b00,%rdi
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
  8004c2:	48 bf 23 4b 80 00 00 	movabs $0x804b23,%rdi
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
  800773:	48 b8 30 4d 80 00 00 	movabs $0x804d30,%rax
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
  800a55:	48 b8 58 4d 80 00 00 	movabs $0x804d58,%rax
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
  800b9c:	48 b8 80 4c 80 00 00 	movabs $0x804c80,%rax
  800ba3:	00 00 00 
  800ba6:	48 63 d3             	movslq %ebx,%rdx
  800ba9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bad:	4d 85 e4             	test   %r12,%r12
  800bb0:	75 2e                	jne    800be0 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800bb2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	89 d9                	mov    %ebx,%ecx
  800bbc:	48 ba 41 4d 80 00 00 	movabs $0x804d41,%rdx
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
  800beb:	48 ba 4a 4d 80 00 00 	movabs $0x804d4a,%rdx
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
  800c42:	49 bc 4d 4d 80 00 00 	movabs $0x804d4d,%r12
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
  80194e:	48 ba 08 50 80 00 00 	movabs $0x805008,%rdx
  801955:	00 00 00 
  801958:	be 24 00 00 00       	mov    $0x24,%esi
  80195d:	48 bf 25 50 80 00 00 	movabs $0x805025,%rdi
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

0000000000801ec8 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801ecc:	48 83 ec 08          	sub    $0x8,%rsp
  801ed0:	6a 00                	pushq  $0x0
  801ed2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee8:	be 00 00 00 00       	mov    $0x0,%esi
  801eed:	bf 13 00 00 00       	mov    $0x13,%edi
  801ef2:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
  801efe:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801f02:	90                   	nop
  801f03:	c9                   	leaveq 
  801f04:	c3                   	retq   

0000000000801f05 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801f05:	55                   	push   %rbp
  801f06:	48 89 e5             	mov    %rsp,%rbp
  801f09:	48 83 ec 10          	sub    $0x10,%rsp
  801f0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f13:	48 98                	cltq   
  801f15:	48 83 ec 08          	sub    $0x8,%rsp
  801f19:	6a 00                	pushq  $0x0
  801f1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f27:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f2c:	48 89 c2             	mov    %rax,%rdx
  801f2f:	be 00 00 00 00       	mov    $0x0,%esi
  801f34:	bf 14 00 00 00       	mov    $0x14,%edi
  801f39:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	callq  *%rax
  801f45:	48 83 c4 10          	add    $0x10,%rsp
}
  801f49:	c9                   	leaveq 
  801f4a:	c3                   	retq   

0000000000801f4b <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801f4b:	55                   	push   %rbp
  801f4c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f4f:	48 83 ec 08          	sub    $0x8,%rsp
  801f53:	6a 00                	pushq  $0x0
  801f55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f66:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6b:	be 00 00 00 00       	mov    $0x0,%esi
  801f70:	bf 15 00 00 00       	mov    $0x15,%edi
  801f75:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801f7c:	00 00 00 
  801f7f:	ff d0                	callq  *%rax
  801f81:	48 83 c4 10          	add    $0x10,%rsp
}
  801f85:	c9                   	leaveq 
  801f86:	c3                   	retq   

0000000000801f87 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f87:	55                   	push   %rbp
  801f88:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f8b:	48 83 ec 08          	sub    $0x8,%rsp
  801f8f:	6a 00                	pushq  $0x0
  801f91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa7:	be 00 00 00 00       	mov    $0x0,%esi
  801fac:	bf 16 00 00 00       	mov    $0x16,%edi
  801fb1:	48 b8 f6 18 80 00 00 	movabs $0x8018f6,%rax
  801fb8:	00 00 00 
  801fbb:	ff d0                	callq  *%rax
  801fbd:	48 83 c4 10          	add    $0x10,%rsp
}
  801fc1:	90                   	nop
  801fc2:	c9                   	leaveq 
  801fc3:	c3                   	retq   

0000000000801fc4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801fc4:	55                   	push   %rbp
  801fc5:	48 89 e5             	mov    %rsp,%rbp
  801fc8:	48 83 ec 30          	sub    $0x30,%rsp
  801fcc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801fd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd4:	48 8b 00             	mov    (%rax),%rax
  801fd7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801fdb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdf:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe9:	83 e0 02             	and    $0x2,%eax
  801fec:	85 c0                	test   %eax,%eax
  801fee:	75 40                	jne    802030 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff4:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801ffb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fff:	49 89 d0             	mov    %rdx,%r8
  802002:	48 89 c1             	mov    %rax,%rcx
  802005:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  80200c:	00 00 00 
  80200f:	be 1f 00 00 00       	mov    $0x1f,%esi
  802014:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  80201b:	00 00 00 
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	49 b9 cc 03 80 00 00 	movabs $0x8003cc,%r9
  80202a:	00 00 00 
  80202d:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802030:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802034:	48 c1 e8 0c          	shr    $0xc,%rax
  802038:	48 89 c2             	mov    %rax,%rdx
  80203b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802042:	01 00 00 
  802045:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802049:	25 07 08 00 00       	and    $0x807,%eax
  80204e:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802054:	74 4e                	je     8020a4 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  802056:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80205a:	48 c1 e8 0c          	shr    $0xc,%rax
  80205e:	48 89 c2             	mov    %rax,%rdx
  802061:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802068:	01 00 00 
  80206b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80206f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802073:	49 89 d0             	mov    %rdx,%r8
  802076:	48 89 c1             	mov    %rax,%rcx
  802079:	48 ba 60 50 80 00 00 	movabs $0x805060,%rdx
  802080:	00 00 00 
  802083:	be 22 00 00 00       	mov    $0x22,%esi
  802088:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  80208f:	00 00 00 
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	49 b9 cc 03 80 00 00 	movabs $0x8003cc,%r9
  80209e:	00 00 00 
  8020a1:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020a4:	ba 07 00 00 00       	mov    $0x7,%edx
  8020a9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b3:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8020ba:	00 00 00 
  8020bd:	ff d0                	callq  *%rax
  8020bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c6:	79 30                	jns    8020f8 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8020c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cb:	89 c1                	mov    %eax,%ecx
  8020cd:	48 ba 8b 50 80 00 00 	movabs $0x80508b,%rdx
  8020d4:	00 00 00 
  8020d7:	be 28 00 00 00       	mov    $0x28,%esi
  8020dc:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  8020e3:	00 00 00 
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8020f2:	00 00 00 
  8020f5:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8020f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802100:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802104:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80210a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80210f:	48 89 c6             	mov    %rax,%rsi
  802112:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802117:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802123:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802127:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80212b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802135:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80213b:	48 89 c1             	mov    %rax,%rcx
  80213e:	ba 00 00 00 00       	mov    $0x0,%edx
  802143:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802148:	bf 00 00 00 00       	mov    $0x0,%edi
  80214d:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
  802159:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80215c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802160:	79 30                	jns    802192 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802162:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802165:	89 c1                	mov    %eax,%ecx
  802167:	48 ba 9e 50 80 00 00 	movabs $0x80509e,%rdx
  80216e:	00 00 00 
  802171:	be 2d 00 00 00       	mov    $0x2d,%esi
  802176:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  80217d:	00 00 00 
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
  802185:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  80218c:	00 00 00 
  80218f:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802192:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802197:	bf 00 00 00 00       	mov    $0x0,%edi
  80219c:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8021a3:	00 00 00 
  8021a6:	ff d0                	callq  *%rax
  8021a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021af:	79 30                	jns    8021e1 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8021b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021b4:	89 c1                	mov    %eax,%ecx
  8021b6:	48 ba af 50 80 00 00 	movabs $0x8050af,%rdx
  8021bd:	00 00 00 
  8021c0:	be 31 00 00 00       	mov    $0x31,%esi
  8021c5:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  8021cc:	00 00 00 
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8021db:	00 00 00 
  8021de:	41 ff d0             	callq  *%r8

}
  8021e1:	90                   	nop
  8021e2:	c9                   	leaveq 
  8021e3:	c3                   	retq   

00000000008021e4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021e4:	55                   	push   %rbp
  8021e5:	48 89 e5             	mov    %rsp,%rbp
  8021e8:	48 83 ec 30          	sub    $0x30,%rsp
  8021ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021ef:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8021f2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8021f5:	c1 e0 0c             	shl    $0xc,%eax
  8021f8:	89 c0                	mov    %eax,%eax
  8021fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8021fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802205:	01 00 00 
  802208:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80220b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802217:	25 02 08 00 00       	and    $0x802,%eax
  80221c:	48 85 c0             	test   %rax,%rax
  80221f:	74 0e                	je     80222f <duppage+0x4b>
  802221:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802225:	25 00 04 00 00       	and    $0x400,%eax
  80222a:	48 85 c0             	test   %rax,%rax
  80222d:	74 70                	je     80229f <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80222f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802233:	25 07 0e 00 00       	and    $0xe07,%eax
  802238:	89 c6                	mov    %eax,%esi
  80223a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80223e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802245:	41 89 f0             	mov    %esi,%r8d
  802248:	48 89 c6             	mov    %rax,%rsi
  80224b:	bf 00 00 00 00       	mov    $0x0,%edi
  802250:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802257:	00 00 00 
  80225a:	ff d0                	callq  *%rax
  80225c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80225f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802263:	79 30                	jns    802295 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802265:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802268:	89 c1                	mov    %eax,%ecx
  80226a:	48 ba 9e 50 80 00 00 	movabs $0x80509e,%rdx
  802271:	00 00 00 
  802274:	be 50 00 00 00       	mov    $0x50,%esi
  802279:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  802280:	00 00 00 
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  80228f:	00 00 00 
  802292:	41 ff d0             	callq  *%r8
		return 0;
  802295:	b8 00 00 00 00       	mov    $0x0,%eax
  80229a:	e9 c4 00 00 00       	jmpq   802363 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80229f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8022a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022aa:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8022b0:	48 89 c6             	mov    %rax,%rsi
  8022b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b8:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8022bf:	00 00 00 
  8022c2:	ff d0                	callq  *%rax
  8022c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8022c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022cb:	79 30                	jns    8022fd <duppage+0x119>
		panic("sys_page_map: %e", r);
  8022cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d0:	89 c1                	mov    %eax,%ecx
  8022d2:	48 ba 9e 50 80 00 00 	movabs $0x80509e,%rdx
  8022d9:	00 00 00 
  8022dc:	be 64 00 00 00       	mov    $0x64,%esi
  8022e1:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  8022e8:	00 00 00 
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f0:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8022f7:	00 00 00 
  8022fa:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8022fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802305:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80230b:	48 89 d1             	mov    %rdx,%rcx
  80230e:	ba 00 00 00 00       	mov    $0x0,%edx
  802313:	48 89 c6             	mov    %rax,%rsi
  802316:	bf 00 00 00 00       	mov    $0x0,%edi
  80231b:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802322:	00 00 00 
  802325:	ff d0                	callq  *%rax
  802327:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80232a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80232e:	79 30                	jns    802360 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802330:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802333:	89 c1                	mov    %eax,%ecx
  802335:	48 ba 9e 50 80 00 00 	movabs $0x80509e,%rdx
  80233c:	00 00 00 
  80233f:	be 66 00 00 00       	mov    $0x66,%esi
  802344:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  80234b:	00 00 00 
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
  802353:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  80235a:	00 00 00 
  80235d:	41 ff d0             	callq  *%r8
	return r;
  802360:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802363:	c9                   	leaveq 
  802364:	c3                   	retq   

0000000000802365 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802365:	55                   	push   %rbp
  802366:	48 89 e5             	mov    %rsp,%rbp
  802369:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  80236d:	48 bf c4 1f 80 00 00 	movabs $0x801fc4,%rdi
  802374:	00 00 00 
  802377:	48 b8 8a 46 80 00 00 	movabs $0x80468a,%rax
  80237e:	00 00 00 
  802381:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802383:	b8 07 00 00 00       	mov    $0x7,%eax
  802388:	cd 30                	int    $0x30
  80238a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80238d:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802390:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802393:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802397:	79 08                	jns    8023a1 <fork+0x3c>
		return envid;
  802399:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80239c:	e9 0b 02 00 00       	jmpq   8025ac <fork+0x247>
	if (envid == 0) {
  8023a1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023a5:	75 3e                	jne    8023e5 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8023a7:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8023ae:	00 00 00 
  8023b1:	ff d0                	callq  *%rax
  8023b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023b8:	48 98                	cltq   
  8023ba:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8023c1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023c8:	00 00 00 
  8023cb:	48 01 c2             	add    %rax,%rdx
  8023ce:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023d5:	00 00 00 
  8023d8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	e9 c7 01 00 00       	jmpq   8025ac <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8023e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023ec:	e9 a6 00 00 00       	jmpq   802497 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8023f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f4:	c1 f8 12             	sar    $0x12,%eax
  8023f7:	89 c2                	mov    %eax,%edx
  8023f9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802400:	01 00 00 
  802403:	48 63 d2             	movslq %edx,%rdx
  802406:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240a:	83 e0 01             	and    $0x1,%eax
  80240d:	48 85 c0             	test   %rax,%rax
  802410:	74 21                	je     802433 <fork+0xce>
  802412:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802415:	c1 f8 09             	sar    $0x9,%eax
  802418:	89 c2                	mov    %eax,%edx
  80241a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802421:	01 00 00 
  802424:	48 63 d2             	movslq %edx,%rdx
  802427:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242b:	83 e0 01             	and    $0x1,%eax
  80242e:	48 85 c0             	test   %rax,%rax
  802431:	75 09                	jne    80243c <fork+0xd7>
			pn += NPTENTRIES;
  802433:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80243a:	eb 5b                	jmp    802497 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80243c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243f:	05 00 02 00 00       	add    $0x200,%eax
  802444:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802447:	eb 46                	jmp    80248f <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802449:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802450:	01 00 00 
  802453:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802456:	48 63 d2             	movslq %edx,%rdx
  802459:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245d:	83 e0 05             	and    $0x5,%eax
  802460:	48 83 f8 05          	cmp    $0x5,%rax
  802464:	75 21                	jne    802487 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  802466:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  80246d:	74 1b                	je     80248a <fork+0x125>
				continue;
			duppage(envid, pn);
  80246f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802472:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802475:	89 d6                	mov    %edx,%esi
  802477:	89 c7                	mov    %eax,%edi
  802479:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  802480:	00 00 00 
  802483:	ff d0                	callq  *%rax
  802485:	eb 04                	jmp    80248b <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802487:	90                   	nop
  802488:	eb 01                	jmp    80248b <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80248a:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80248b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80248f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802492:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802495:	7c b2                	jl     802449 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249a:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  80249f:	0f 86 4c ff ff ff    	jbe    8023f1 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8024a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024a8:	ba 07 00 00 00       	mov    $0x7,%edx
  8024ad:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024b2:	89 c7                	mov    %eax,%edi
  8024b4:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
  8024c0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024c7:	79 30                	jns    8024f9 <fork+0x194>
		panic("allocating exception stack: %e", r);
  8024c9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024cc:	89 c1                	mov    %eax,%ecx
  8024ce:	48 ba c8 50 80 00 00 	movabs $0x8050c8,%rdx
  8024d5:	00 00 00 
  8024d8:	be 9e 00 00 00       	mov    $0x9e,%esi
  8024dd:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  8024e4:	00 00 00 
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ec:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8024f3:	00 00 00 
  8024f6:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8024f9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802500:	00 00 00 
  802503:	48 8b 00             	mov    (%rax),%rax
  802506:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80250d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802510:	48 89 d6             	mov    %rdx,%rsi
  802513:	89 c7                	mov    %eax,%edi
  802515:	48 b8 63 1c 80 00 00 	movabs $0x801c63,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	callq  *%rax
  802521:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802524:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802528:	79 30                	jns    80255a <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80252a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80252d:	89 c1                	mov    %eax,%ecx
  80252f:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  802536:	00 00 00 
  802539:	be a2 00 00 00       	mov    $0xa2,%esi
  80253e:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  802545:	00 00 00 
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  802554:	00 00 00 
  802557:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80255a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80255d:	be 02 00 00 00       	mov    $0x2,%esi
  802562:	89 c7                	mov    %eax,%edi
  802564:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  80256b:	00 00 00 
  80256e:	ff d0                	callq  *%rax
  802570:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802573:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802577:	79 30                	jns    8025a9 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802579:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80257c:	89 c1                	mov    %eax,%ecx
  80257e:	48 ba 07 51 80 00 00 	movabs $0x805107,%rdx
  802585:	00 00 00 
  802588:	be a7 00 00 00       	mov    $0xa7,%esi
  80258d:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  802594:	00 00 00 
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8025a3:	00 00 00 
  8025a6:	41 ff d0             	callq  *%r8

	return envid;
  8025a9:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8025ac:	c9                   	leaveq 
  8025ad:	c3                   	retq   

00000000008025ae <sfork>:

// Challenge!
int
sfork(void)
{
  8025ae:	55                   	push   %rbp
  8025af:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025b2:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  8025b9:	00 00 00 
  8025bc:	be b1 00 00 00       	mov    $0xb1,%esi
  8025c1:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  8025c8:	00 00 00 
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d0:	48 b9 cc 03 80 00 00 	movabs $0x8003cc,%rcx
  8025d7:	00 00 00 
  8025da:	ff d1                	callq  *%rcx

00000000008025dc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 08          	sub    $0x8,%rsp
  8025e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ec:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025f3:	ff ff ff 
  8025f6:	48 01 d0             	add    %rdx,%rax
  8025f9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025fd:	c9                   	leaveq 
  8025fe:	c3                   	retq   

00000000008025ff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025ff:	55                   	push   %rbp
  802600:	48 89 e5             	mov    %rsp,%rbp
  802603:	48 83 ec 08          	sub    $0x8,%rsp
  802607:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80260b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260f:	48 89 c7             	mov    %rax,%rdi
  802612:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802624:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802628:	c9                   	leaveq 
  802629:	c3                   	retq   

000000000080262a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80262a:	55                   	push   %rbp
  80262b:	48 89 e5             	mov    %rsp,%rbp
  80262e:	48 83 ec 18          	sub    $0x18,%rsp
  802632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802636:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80263d:	eb 6b                	jmp    8026aa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80263f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802642:	48 98                	cltq   
  802644:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80264a:	48 c1 e0 0c          	shl    $0xc,%rax
  80264e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802656:	48 c1 e8 15          	shr    $0x15,%rax
  80265a:	48 89 c2             	mov    %rax,%rdx
  80265d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802664:	01 00 00 
  802667:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266b:	83 e0 01             	and    $0x1,%eax
  80266e:	48 85 c0             	test   %rax,%rax
  802671:	74 21                	je     802694 <fd_alloc+0x6a>
  802673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802677:	48 c1 e8 0c          	shr    $0xc,%rax
  80267b:	48 89 c2             	mov    %rax,%rdx
  80267e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802685:	01 00 00 
  802688:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268c:	83 e0 01             	and    $0x1,%eax
  80268f:	48 85 c0             	test   %rax,%rax
  802692:	75 12                	jne    8026a6 <fd_alloc+0x7c>
			*fd_store = fd;
  802694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802698:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80269c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	eb 1a                	jmp    8026c0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026aa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026ae:	7e 8f                	jle    80263f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026bb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 20          	sub    $0x20,%rsp
  8026ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026d5:	78 06                	js     8026dd <fd_lookup+0x1b>
  8026d7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026db:	7e 07                	jle    8026e4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e2:	eb 6c                	jmp    802750 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e7:	48 98                	cltq   
  8026e9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8026f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fb:	48 c1 e8 15          	shr    $0x15,%rax
  8026ff:	48 89 c2             	mov    %rax,%rdx
  802702:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802709:	01 00 00 
  80270c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802710:	83 e0 01             	and    $0x1,%eax
  802713:	48 85 c0             	test   %rax,%rax
  802716:	74 21                	je     802739 <fd_lookup+0x77>
  802718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271c:	48 c1 e8 0c          	shr    $0xc,%rax
  802720:	48 89 c2             	mov    %rax,%rdx
  802723:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272a:	01 00 00 
  80272d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802731:	83 e0 01             	and    $0x1,%eax
  802734:	48 85 c0             	test   %rax,%rax
  802737:	75 07                	jne    802740 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802739:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80273e:	eb 10                	jmp    802750 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802744:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802748:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802750:	c9                   	leaveq 
  802751:	c3                   	retq   

0000000000802752 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802752:	55                   	push   %rbp
  802753:	48 89 e5             	mov    %rsp,%rbp
  802756:	48 83 ec 30          	sub    $0x30,%rsp
  80275a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80275e:	89 f0                	mov    %esi,%eax
  802760:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802767:	48 89 c7             	mov    %rax,%rdi
  80276a:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 c2                	mov    %eax,%edx
  802778:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80277c:	48 89 c6             	mov    %rax,%rsi
  80277f:	89 d7                	mov    %edx,%edi
  802781:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802788:	00 00 00 
  80278b:	ff d0                	callq  *%rax
  80278d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802790:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802794:	78 0a                	js     8027a0 <fd_close+0x4e>
	    || fd != fd2)
  802796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80279e:	74 12                	je     8027b2 <fd_close+0x60>
		return (must_exist ? r : 0);
  8027a0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027a4:	74 05                	je     8027ab <fd_close+0x59>
  8027a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a9:	eb 70                	jmp    80281b <fd_close+0xc9>
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	eb 69                	jmp    80281b <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b6:	8b 00                	mov    (%rax),%eax
  8027b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027bc:	48 89 d6             	mov    %rdx,%rsi
  8027bf:	89 c7                	mov    %eax,%edi
  8027c1:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
  8027cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d4:	78 2a                	js     802800 <fd_close+0xae>
		if (dev->dev_close)
  8027d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027da:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027de:	48 85 c0             	test   %rax,%rax
  8027e1:	74 16                	je     8027f9 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8027e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ef:	48 89 d7             	mov    %rdx,%rdi
  8027f2:	ff d0                	callq  *%rax
  8027f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f7:	eb 07                	jmp    802800 <fd_close+0xae>
		else
			r = 0;
  8027f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802804:	48 89 c6             	mov    %rax,%rsi
  802807:	bf 00 00 00 00       	mov    $0x0,%edi
  80280c:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
	return r;
  802818:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 20          	sub    $0x20,%rsp
  802825:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802828:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80282c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802833:	eb 41                	jmp    802876 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802835:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80283c:	00 00 00 
  80283f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802842:	48 63 d2             	movslq %edx,%rdx
  802845:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802849:	8b 00                	mov    (%rax),%eax
  80284b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80284e:	75 22                	jne    802872 <dev_lookup+0x55>
			*dev = devtab[i];
  802850:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802857:	00 00 00 
  80285a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80285d:	48 63 d2             	movslq %edx,%rdx
  802860:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802864:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802868:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	eb 60                	jmp    8028d2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802872:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802876:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80287d:	00 00 00 
  802880:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802883:	48 63 d2             	movslq %edx,%rdx
  802886:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80288a:	48 85 c0             	test   %rax,%rax
  80288d:	75 a6                	jne    802835 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80288f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802896:	00 00 00 
  802899:	48 8b 00             	mov    (%rax),%rax
  80289c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028a5:	89 c6                	mov    %eax,%esi
  8028a7:	48 bf 38 51 80 00 00 	movabs $0x805138,%rdi
  8028ae:	00 00 00 
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b6:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  8028bd:	00 00 00 
  8028c0:	ff d1                	callq  *%rcx
	*dev = 0;
  8028c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <close>:

int
close(int fdnum)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 20          	sub    $0x20,%rsp
  8028dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e6:	48 89 d6             	mov    %rdx,%rsi
  8028e9:	89 c7                	mov    %eax,%edi
  8028eb:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8028f2:	00 00 00 
  8028f5:	ff d0                	callq  *%rax
  8028f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fe:	79 05                	jns    802905 <close+0x31>
		return r;
  802900:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802903:	eb 18                	jmp    80291d <close+0x49>
	else
		return fd_close(fd, 1);
  802905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802909:	be 01 00 00 00       	mov    $0x1,%esi
  80290e:	48 89 c7             	mov    %rax,%rdi
  802911:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  802918:	00 00 00 
  80291b:	ff d0                	callq  *%rax
}
  80291d:	c9                   	leaveq 
  80291e:	c3                   	retq   

000000000080291f <close_all>:

void
close_all(void)
{
  80291f:	55                   	push   %rbp
  802920:	48 89 e5             	mov    %rsp,%rbp
  802923:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80292e:	eb 15                	jmp    802945 <close_all+0x26>
		close(i);
  802930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802933:	89 c7                	mov    %eax,%edi
  802935:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802941:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802945:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802949:	7e e5                	jle    802930 <close_all+0x11>
		close(i);
}
  80294b:	90                   	nop
  80294c:	c9                   	leaveq 
  80294d:	c3                   	retq   

000000000080294e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80294e:	55                   	push   %rbp
  80294f:	48 89 e5             	mov    %rsp,%rbp
  802952:	48 83 ec 40          	sub    $0x40,%rsp
  802956:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802959:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80295c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802960:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802963:	48 89 d6             	mov    %rdx,%rsi
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
  802974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297b:	79 08                	jns    802985 <dup+0x37>
		return r;
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802980:	e9 70 01 00 00       	jmpq   802af5 <dup+0x1a7>
	close(newfdnum);
  802985:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802988:	89 c7                	mov    %eax,%edi
  80298a:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  802991:	00 00 00 
  802994:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802996:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802999:	48 98                	cltq   
  80299b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029a1:	48 c1 e0 0c          	shl    $0xc,%rax
  8029a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ad:	48 89 c7             	mov    %rax,%rdi
  8029b0:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8029b7:	00 00 00 
  8029ba:	ff d0                	callq  *%rax
  8029bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c4:	48 89 c7             	mov    %rax,%rdi
  8029c7:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8029ce:	00 00 00 
  8029d1:	ff d0                	callq  *%rax
  8029d3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029db:	48 c1 e8 15          	shr    $0x15,%rax
  8029df:	48 89 c2             	mov    %rax,%rdx
  8029e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029e9:	01 00 00 
  8029ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f0:	83 e0 01             	and    $0x1,%eax
  8029f3:	48 85 c0             	test   %rax,%rax
  8029f6:	74 71                	je     802a69 <dup+0x11b>
  8029f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802a00:	48 89 c2             	mov    %rax,%rdx
  802a03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a0a:	01 00 00 
  802a0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a11:	83 e0 01             	and    $0x1,%eax
  802a14:	48 85 c0             	test   %rax,%rax
  802a17:	74 50                	je     802a69 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1d:	48 c1 e8 0c          	shr    $0xc,%rax
  802a21:	48 89 c2             	mov    %rax,%rdx
  802a24:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a2b:	01 00 00 
  802a2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a32:	25 07 0e 00 00       	and    $0xe07,%eax
  802a37:	89 c1                	mov    %eax,%ecx
  802a39:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a41:	41 89 c8             	mov    %ecx,%r8d
  802a44:	48 89 d1             	mov    %rdx,%rcx
  802a47:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4c:	48 89 c6             	mov    %rax,%rsi
  802a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  802a54:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
  802a60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a67:	78 55                	js     802abe <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a6d:	48 c1 e8 0c          	shr    $0xc,%rax
  802a71:	48 89 c2             	mov    %rax,%rdx
  802a74:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a7b:	01 00 00 
  802a7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a82:	25 07 0e 00 00       	and    $0xe07,%eax
  802a87:	89 c1                	mov    %eax,%ecx
  802a89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a91:	41 89 c8             	mov    %ecx,%r8d
  802a94:	48 89 d1             	mov    %rdx,%rcx
  802a97:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9c:	48 89 c6             	mov    %rax,%rsi
  802a9f:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa4:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802aab:	00 00 00 
  802aae:	ff d0                	callq  *%rax
  802ab0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab7:	78 08                	js     802ac1 <dup+0x173>
		goto err;

	return newfdnum;
  802ab9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802abc:	eb 37                	jmp    802af5 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802abe:	90                   	nop
  802abf:	eb 01                	jmp    802ac2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ac1:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ac2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac6:	48 89 c6             	mov    %rax,%rsi
  802ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ace:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  802ad5:	00 00 00 
  802ad8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ada:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ade:	48 89 c6             	mov    %rax,%rsi
  802ae1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae6:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
	return r;
  802af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802af5:	c9                   	leaveq 
  802af6:	c3                   	retq   

0000000000802af7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802af7:	55                   	push   %rbp
  802af8:	48 89 e5             	mov    %rsp,%rbp
  802afb:	48 83 ec 40          	sub    $0x40,%rsp
  802aff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b06:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b0a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b0e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b11:	48 89 d6             	mov    %rdx,%rsi
  802b14:	89 c7                	mov    %eax,%edi
  802b16:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
  802b22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b29:	78 24                	js     802b4f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2f:	8b 00                	mov    (%rax),%eax
  802b31:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b35:	48 89 d6             	mov    %rdx,%rsi
  802b38:	89 c7                	mov    %eax,%edi
  802b3a:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	callq  *%rax
  802b46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4d:	79 05                	jns    802b54 <read+0x5d>
		return r;
  802b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b52:	eb 76                	jmp    802bca <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b58:	8b 40 08             	mov    0x8(%rax),%eax
  802b5b:	83 e0 03             	and    $0x3,%eax
  802b5e:	83 f8 01             	cmp    $0x1,%eax
  802b61:	75 3a                	jne    802b9d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b63:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b6a:	00 00 00 
  802b6d:	48 8b 00             	mov    (%rax),%rax
  802b70:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b76:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b79:	89 c6                	mov    %eax,%esi
  802b7b:	48 bf 57 51 80 00 00 	movabs $0x805157,%rdi
  802b82:	00 00 00 
  802b85:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8a:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  802b91:	00 00 00 
  802b94:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b9b:	eb 2d                	jmp    802bca <read+0xd3>
	}
	if (!dev->dev_read)
  802b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba1:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ba5:	48 85 c0             	test   %rax,%rax
  802ba8:	75 07                	jne    802bb1 <read+0xba>
		return -E_NOT_SUPP;
  802baa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802baf:	eb 19                	jmp    802bca <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb5:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bb9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bbd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bc1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bc5:	48 89 cf             	mov    %rcx,%rdi
  802bc8:	ff d0                	callq  *%rax
}
  802bca:	c9                   	leaveq 
  802bcb:	c3                   	retq   

0000000000802bcc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bcc:	55                   	push   %rbp
  802bcd:	48 89 e5             	mov    %rsp,%rbp
  802bd0:	48 83 ec 30          	sub    $0x30,%rsp
  802bd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bdb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802be6:	eb 47                	jmp    802c2f <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	48 98                	cltq   
  802bed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bf1:	48 29 c2             	sub    %rax,%rdx
  802bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf7:	48 63 c8             	movslq %eax,%rcx
  802bfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bfe:	48 01 c1             	add    %rax,%rcx
  802c01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c04:	48 89 ce             	mov    %rcx,%rsi
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
  802c15:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c18:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c1c:	79 05                	jns    802c23 <readn+0x57>
			return m;
  802c1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c21:	eb 1d                	jmp    802c40 <readn+0x74>
		if (m == 0)
  802c23:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c27:	74 13                	je     802c3c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	48 98                	cltq   
  802c34:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c38:	72 ae                	jb     802be8 <readn+0x1c>
  802c3a:	eb 01                	jmp    802c3d <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c3c:	90                   	nop
	}
	return tot;
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 40          	sub    $0x40,%rsp
  802c4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c55:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c5c:	48 89 d6             	mov    %rdx,%rsi
  802c5f:	89 c7                	mov    %eax,%edi
  802c61:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c74:	78 24                	js     802c9a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7a:	8b 00                	mov    (%rax),%eax
  802c7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c80:	48 89 d6             	mov    %rdx,%rsi
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
  802c91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c98:	79 05                	jns    802c9f <write+0x5d>
		return r;
  802c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9d:	eb 75                	jmp    802d14 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca3:	8b 40 08             	mov    0x8(%rax),%eax
  802ca6:	83 e0 03             	and    $0x3,%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	75 3a                	jne    802ce7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802cad:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802cb4:	00 00 00 
  802cb7:	48 8b 00             	mov    (%rax),%rax
  802cba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cc0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cc3:	89 c6                	mov    %eax,%esi
  802cc5:	48 bf 73 51 80 00 00 	movabs $0x805173,%rdi
  802ccc:	00 00 00 
  802ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd4:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  802cdb:	00 00 00 
  802cde:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ce0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ce5:	eb 2d                	jmp    802d14 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ceb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cef:	48 85 c0             	test   %rax,%rax
  802cf2:	75 07                	jne    802cfb <write+0xb9>
		return -E_NOT_SUPP;
  802cf4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf9:	eb 19                	jmp    802d14 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cff:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d03:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d07:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d0b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d0f:	48 89 cf             	mov    %rcx,%rdi
  802d12:	ff d0                	callq  *%rax
}
  802d14:	c9                   	leaveq 
  802d15:	c3                   	retq   

0000000000802d16 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d16:	55                   	push   %rbp
  802d17:	48 89 e5             	mov    %rsp,%rbp
  802d1a:	48 83 ec 18          	sub    $0x18,%rsp
  802d1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d21:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d24:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d2b:	48 89 d6             	mov    %rdx,%rsi
  802d2e:	89 c7                	mov    %eax,%edi
  802d30:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
  802d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d43:	79 05                	jns    802d4a <seek+0x34>
		return r;
  802d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d48:	eb 0f                	jmp    802d59 <seek+0x43>
	fd->fd_offset = offset;
  802d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d51:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d59:	c9                   	leaveq 
  802d5a:	c3                   	retq   

0000000000802d5b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d5b:	55                   	push   %rbp
  802d5c:	48 89 e5             	mov    %rsp,%rbp
  802d5f:	48 83 ec 30          	sub    $0x30,%rsp
  802d63:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d66:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d69:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d6d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d70:	48 89 d6             	mov    %rdx,%rsi
  802d73:	89 c7                	mov    %eax,%edi
  802d75:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
  802d81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d88:	78 24                	js     802dae <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8e:	8b 00                	mov    (%rax),%eax
  802d90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d94:	48 89 d6             	mov    %rdx,%rsi
  802d97:	89 c7                	mov    %eax,%edi
  802d99:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax
  802da5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dac:	79 05                	jns    802db3 <ftruncate+0x58>
		return r;
  802dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db1:	eb 72                	jmp    802e25 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802db3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db7:	8b 40 08             	mov    0x8(%rax),%eax
  802dba:	83 e0 03             	and    $0x3,%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	75 3a                	jne    802dfb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802dc1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802dc8:	00 00 00 
  802dcb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dd4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dd7:	89 c6                	mov    %eax,%esi
  802dd9:	48 bf 90 51 80 00 00 	movabs $0x805190,%rdi
  802de0:	00 00 00 
  802de3:	b8 00 00 00 00       	mov    $0x0,%eax
  802de8:	48 b9 06 06 80 00 00 	movabs $0x800606,%rcx
  802def:	00 00 00 
  802df2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802df4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802df9:	eb 2a                	jmp    802e25 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dff:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e03:	48 85 c0             	test   %rax,%rax
  802e06:	75 07                	jne    802e0f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e08:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e0d:	eb 16                	jmp    802e25 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e13:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e1b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e1e:	89 ce                	mov    %ecx,%esi
  802e20:	48 89 d7             	mov    %rdx,%rdi
  802e23:	ff d0                	callq  *%rax
}
  802e25:	c9                   	leaveq 
  802e26:	c3                   	retq   

0000000000802e27 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e27:	55                   	push   %rbp
  802e28:	48 89 e5             	mov    %rsp,%rbp
  802e2b:	48 83 ec 30          	sub    $0x30,%rsp
  802e2f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e32:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e36:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e3d:	48 89 d6             	mov    %rdx,%rsi
  802e40:	89 c7                	mov    %eax,%edi
  802e42:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
  802e4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e55:	78 24                	js     802e7b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5b:	8b 00                	mov    (%rax),%eax
  802e5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e61:	48 89 d6             	mov    %rdx,%rsi
  802e64:	89 c7                	mov    %eax,%edi
  802e66:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e79:	79 05                	jns    802e80 <fstat+0x59>
		return r;
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7e:	eb 5e                	jmp    802ede <fstat+0xb7>
	if (!dev->dev_stat)
  802e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e84:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e88:	48 85 c0             	test   %rax,%rax
  802e8b:	75 07                	jne    802e94 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e8d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e92:	eb 4a                	jmp    802ede <fstat+0xb7>
	stat->st_name[0] = 0;
  802e94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e98:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e9f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ea6:	00 00 00 
	stat->st_isdir = 0;
  802ea9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ead:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802eb4:	00 00 00 
	stat->st_dev = dev;
  802eb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ebb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ebf:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ec6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eca:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ece:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ed2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ed6:	48 89 ce             	mov    %rcx,%rsi
  802ed9:	48 89 d7             	mov    %rdx,%rdi
  802edc:	ff d0                	callq  *%rax
}
  802ede:	c9                   	leaveq 
  802edf:	c3                   	retq   

0000000000802ee0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ee0:	55                   	push   %rbp
  802ee1:	48 89 e5             	mov    %rsp,%rbp
  802ee4:	48 83 ec 20          	sub    $0x20,%rsp
  802ee8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ef0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef4:	be 00 00 00 00       	mov    $0x0,%esi
  802ef9:	48 89 c7             	mov    %rax,%rdi
  802efc:	48 b8 d0 2f 80 00 00 	movabs $0x802fd0,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
  802f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0f:	79 05                	jns    802f16 <stat+0x36>
		return fd;
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	eb 2f                	jmp    802f45 <stat+0x65>
	r = fstat(fd, stat);
  802f16:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1d:	48 89 d6             	mov    %rdx,%rsi
  802f20:	89 c7                	mov    %eax,%edi
  802f22:	48 b8 27 2e 80 00 00 	movabs $0x802e27,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f34:	89 c7                	mov    %eax,%edi
  802f36:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
	return r;
  802f42:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f45:	c9                   	leaveq 
  802f46:	c3                   	retq   

0000000000802f47 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f47:	55                   	push   %rbp
  802f48:	48 89 e5             	mov    %rsp,%rbp
  802f4b:	48 83 ec 10          	sub    $0x10,%rsp
  802f4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f56:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5d:	00 00 00 
  802f60:	8b 00                	mov    (%rax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	75 1f                	jne    802f85 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f66:	bf 01 00 00 00       	mov    $0x1,%edi
  802f6b:	48 b8 09 49 80 00 00 	movabs $0x804909,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
  802f77:	89 c2                	mov    %eax,%edx
  802f79:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f80:	00 00 00 
  802f83:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f85:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8c:	00 00 00 
  802f8f:	8b 00                	mov    (%rax),%eax
  802f91:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f94:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f99:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802fa0:	00 00 00 
  802fa3:	89 c7                	mov    %eax,%edi
  802fa5:	48 b8 74 48 80 00 00 	movabs $0x804874,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802fba:	48 89 c6             	mov    %rax,%rsi
  802fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc2:	48 b8 b3 47 80 00 00 	movabs $0x8047b3,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
}
  802fce:	c9                   	leaveq 
  802fcf:	c3                   	retq   

0000000000802fd0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fd0:	55                   	push   %rbp
  802fd1:	48 89 e5             	mov    %rsp,%rbp
  802fd4:	48 83 ec 20          	sub    $0x20,%rsp
  802fd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fdc:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe3:	48 89 c7             	mov    %rax,%rdi
  802fe6:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  802fed:	00 00 00 
  802ff0:	ff d0                	callq  *%rax
  802ff2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ff7:	7e 0a                	jle    803003 <open+0x33>
		return -E_BAD_PATH;
  802ff9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ffe:	e9 a5 00 00 00       	jmpq   8030a8 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803003:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803007:	48 89 c7             	mov    %rax,%rdi
  80300a:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
  803016:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301d:	79 08                	jns    803027 <open+0x57>
		return r;
  80301f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803022:	e9 81 00 00 00       	jmpq   8030a8 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302b:	48 89 c6             	mov    %rax,%rsi
  80302e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803035:	00 00 00 
  803038:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803044:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80304b:	00 00 00 
  80304e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803051:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305b:	48 89 c6             	mov    %rax,%rsi
  80305e:	bf 01 00 00 00       	mov    $0x1,%edi
  803063:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  80306a:	00 00 00 
  80306d:	ff d0                	callq  *%rax
  80306f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803072:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803076:	79 1d                	jns    803095 <open+0xc5>
		fd_close(fd, 0);
  803078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307c:	be 00 00 00 00       	mov    $0x0,%esi
  803081:	48 89 c7             	mov    %rax,%rdi
  803084:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  80308b:	00 00 00 
  80308e:	ff d0                	callq  *%rax
		return r;
  803090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803093:	eb 13                	jmp    8030a8 <open+0xd8>
	}

	return fd2num(fd);
  803095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803099:	48 89 c7             	mov    %rax,%rdi
  80309c:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8030a3:	00 00 00 
  8030a6:	ff d0                	callq  *%rax

}
  8030a8:	c9                   	leaveq 
  8030a9:	c3                   	retq   

00000000008030aa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030aa:	55                   	push   %rbp
  8030ab:	48 89 e5             	mov    %rsp,%rbp
  8030ae:	48 83 ec 10          	sub    $0x10,%rsp
  8030b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ba:	8b 50 0c             	mov    0xc(%rax),%edx
  8030bd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030c4:	00 00 00 
  8030c7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030c9:	be 00 00 00 00       	mov    $0x0,%esi
  8030ce:	bf 06 00 00 00       	mov    $0x6,%edi
  8030d3:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  8030da:	00 00 00 
  8030dd:	ff d0                	callq  *%rax
}
  8030df:	c9                   	leaveq 
  8030e0:	c3                   	retq   

00000000008030e1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030e1:	55                   	push   %rbp
  8030e2:	48 89 e5             	mov    %rsp,%rbp
  8030e5:	48 83 ec 30          	sub    $0x30,%rsp
  8030e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f9:	8b 50 0c             	mov    0xc(%rax),%edx
  8030fc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803103:	00 00 00 
  803106:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803108:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80310f:	00 00 00 
  803112:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803116:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80311a:	be 00 00 00 00       	mov    $0x0,%esi
  80311f:	bf 03 00 00 00       	mov    $0x3,%edi
  803124:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
  803130:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803137:	79 08                	jns    803141 <devfile_read+0x60>
		return r;
  803139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313c:	e9 a4 00 00 00       	jmpq   8031e5 <devfile_read+0x104>
	assert(r <= n);
  803141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803144:	48 98                	cltq   
  803146:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80314a:	76 35                	jbe    803181 <devfile_read+0xa0>
  80314c:	48 b9 b6 51 80 00 00 	movabs $0x8051b6,%rcx
  803153:	00 00 00 
  803156:	48 ba bd 51 80 00 00 	movabs $0x8051bd,%rdx
  80315d:	00 00 00 
  803160:	be 86 00 00 00       	mov    $0x86,%esi
  803165:	48 bf d2 51 80 00 00 	movabs $0x8051d2,%rdi
  80316c:	00 00 00 
  80316f:	b8 00 00 00 00       	mov    $0x0,%eax
  803174:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  80317b:	00 00 00 
  80317e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803181:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803188:	7e 35                	jle    8031bf <devfile_read+0xde>
  80318a:	48 b9 dd 51 80 00 00 	movabs $0x8051dd,%rcx
  803191:	00 00 00 
  803194:	48 ba bd 51 80 00 00 	movabs $0x8051bd,%rdx
  80319b:	00 00 00 
  80319e:	be 87 00 00 00       	mov    $0x87,%esi
  8031a3:	48 bf d2 51 80 00 00 	movabs $0x8051d2,%rdi
  8031aa:	00 00 00 
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b2:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8031b9:	00 00 00 
  8031bc:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8031bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c2:	48 63 d0             	movslq %eax,%rdx
  8031c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c9:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031d0:	00 00 00 
  8031d3:	48 89 c7             	mov    %rax,%rdi
  8031d6:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
	return r;
  8031e2:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8031e5:	c9                   	leaveq 
  8031e6:	c3                   	retq   

00000000008031e7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031e7:	55                   	push   %rbp
  8031e8:	48 89 e5             	mov    %rsp,%rbp
  8031eb:	48 83 ec 40          	sub    $0x40,%rsp
  8031ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8031fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803203:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80320a:	00 
  80320b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803213:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803218:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80321c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803220:	8b 50 0c             	mov    0xc(%rax),%edx
  803223:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80322a:	00 00 00 
  80322d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80322f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803236:	00 00 00 
  803239:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80323d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803241:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803245:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803249:	48 89 c6             	mov    %rax,%rsi
  80324c:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803253:	00 00 00 
  803256:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803262:	be 00 00 00 00       	mov    $0x0,%esi
  803267:	bf 04 00 00 00       	mov    $0x4,%edi
  80326c:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
  803278:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80327b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80327f:	79 05                	jns    803286 <devfile_write+0x9f>
		return r;
  803281:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803284:	eb 43                	jmp    8032c9 <devfile_write+0xe2>
	assert(r <= n);
  803286:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803289:	48 98                	cltq   
  80328b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80328f:	76 35                	jbe    8032c6 <devfile_write+0xdf>
  803291:	48 b9 b6 51 80 00 00 	movabs $0x8051b6,%rcx
  803298:	00 00 00 
  80329b:	48 ba bd 51 80 00 00 	movabs $0x8051bd,%rdx
  8032a2:	00 00 00 
  8032a5:	be a2 00 00 00       	mov    $0xa2,%esi
  8032aa:	48 bf d2 51 80 00 00 	movabs $0x8051d2,%rdi
  8032b1:	00 00 00 
  8032b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b9:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8032c0:	00 00 00 
  8032c3:	41 ff d0             	callq  *%r8
	return r;
  8032c6:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8032c9:	c9                   	leaveq 
  8032ca:	c3                   	retq   

00000000008032cb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032cb:	55                   	push   %rbp
  8032cc:	48 89 e5             	mov    %rsp,%rbp
  8032cf:	48 83 ec 20          	sub    $0x20,%rsp
  8032d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032df:	8b 50 0c             	mov    0xc(%rax),%edx
  8032e2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032e9:	00 00 00 
  8032ec:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032ee:	be 00 00 00 00       	mov    $0x0,%esi
  8032f3:	bf 05 00 00 00       	mov    $0x5,%edi
  8032f8:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
  803304:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803307:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330b:	79 05                	jns    803312 <devfile_stat+0x47>
		return r;
  80330d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803310:	eb 56                	jmp    803368 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803312:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803316:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80331d:	00 00 00 
  803320:	48 89 c7             	mov    %rax,%rdi
  803323:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80332f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803336:	00 00 00 
  803339:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80333f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803343:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803349:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803350:	00 00 00 
  803353:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803363:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803368:	c9                   	leaveq 
  803369:	c3                   	retq   

000000000080336a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80336a:	55                   	push   %rbp
  80336b:	48 89 e5             	mov    %rsp,%rbp
  80336e:	48 83 ec 10          	sub    $0x10,%rsp
  803372:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803376:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337d:	8b 50 0c             	mov    0xc(%rax),%edx
  803380:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803387:	00 00 00 
  80338a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80338c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803393:	00 00 00 
  803396:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803399:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80339c:	be 00 00 00 00       	mov    $0x0,%esi
  8033a1:	bf 02 00 00 00       	mov    $0x2,%edi
  8033a6:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
}
  8033b2:	c9                   	leaveq 
  8033b3:	c3                   	retq   

00000000008033b4 <remove>:

// Delete a file
int
remove(const char *path)
{
  8033b4:	55                   	push   %rbp
  8033b5:	48 89 e5             	mov    %rsp,%rbp
  8033b8:	48 83 ec 10          	sub    $0x10,%rsp
  8033bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c4:	48 89 c7             	mov    %rax,%rdi
  8033c7:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
  8033d3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033d8:	7e 07                	jle    8033e1 <remove+0x2d>
		return -E_BAD_PATH;
  8033da:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033df:	eb 33                	jmp    803414 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e5:	48 89 c6             	mov    %rax,%rsi
  8033e8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8033ef:	00 00 00 
  8033f2:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033fe:	be 00 00 00 00       	mov    $0x0,%esi
  803403:	bf 07 00 00 00       	mov    $0x7,%edi
  803408:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  80340f:	00 00 00 
  803412:	ff d0                	callq  *%rax
}
  803414:	c9                   	leaveq 
  803415:	c3                   	retq   

0000000000803416 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803416:	55                   	push   %rbp
  803417:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80341a:	be 00 00 00 00       	mov    $0x0,%esi
  80341f:	bf 08 00 00 00       	mov    $0x8,%edi
  803424:	48 b8 47 2f 80 00 00 	movabs $0x802f47,%rax
  80342b:	00 00 00 
  80342e:	ff d0                	callq  *%rax
}
  803430:	5d                   	pop    %rbp
  803431:	c3                   	retq   

0000000000803432 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803432:	55                   	push   %rbp
  803433:	48 89 e5             	mov    %rsp,%rbp
  803436:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80343d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803444:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80344b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803452:	be 00 00 00 00       	mov    $0x0,%esi
  803457:	48 89 c7             	mov    %rax,%rdi
  80345a:	48 b8 d0 2f 80 00 00 	movabs $0x802fd0,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346d:	79 28                	jns    803497 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80346f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803472:	89 c6                	mov    %eax,%esi
  803474:	48 bf e9 51 80 00 00 	movabs $0x8051e9,%rdi
  80347b:	00 00 00 
  80347e:	b8 00 00 00 00       	mov    $0x0,%eax
  803483:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  80348a:	00 00 00 
  80348d:	ff d2                	callq  *%rdx
		return fd_src;
  80348f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803492:	e9 76 01 00 00       	jmpq   80360d <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803497:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80349e:	be 01 01 00 00       	mov    $0x101,%esi
  8034a3:	48 89 c7             	mov    %rax,%rdi
  8034a6:	48 b8 d0 2f 80 00 00 	movabs $0x802fd0,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
  8034b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8034b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034b9:	0f 89 ad 00 00 00    	jns    80356c <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8034bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c2:	89 c6                	mov    %eax,%esi
  8034c4:	48 bf ff 51 80 00 00 	movabs $0x8051ff,%rdi
  8034cb:	00 00 00 
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d3:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  8034da:	00 00 00 
  8034dd:	ff d2                	callq  *%rdx
		close(fd_src);
  8034df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e2:	89 c7                	mov    %eax,%edi
  8034e4:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
		return fd_dest;
  8034f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034f3:	e9 15 01 00 00       	jmpq   80360d <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8034f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034fb:	48 63 d0             	movslq %eax,%rdx
  8034fe:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803505:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803508:	48 89 ce             	mov    %rcx,%rsi
  80350b:	89 c7                	mov    %eax,%edi
  80350d:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
  803519:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80351c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803520:	79 4a                	jns    80356c <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803522:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803525:	89 c6                	mov    %eax,%esi
  803527:	48 bf 19 52 80 00 00 	movabs $0x805219,%rdi
  80352e:	00 00 00 
  803531:	b8 00 00 00 00       	mov    $0x0,%eax
  803536:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  80353d:	00 00 00 
  803540:	ff d2                	callq  *%rdx
			close(fd_src);
  803542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803545:	89 c7                	mov    %eax,%edi
  803547:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
			close(fd_dest);
  803553:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803556:	89 c7                	mov    %eax,%edi
  803558:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
			return write_size;
  803564:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803567:	e9 a1 00 00 00       	jmpq   80360d <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80356c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803576:	ba 00 02 00 00       	mov    $0x200,%edx
  80357b:	48 89 ce             	mov    %rcx,%rsi
  80357e:	89 c7                	mov    %eax,%edi
  803580:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
  80358c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80358f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803593:	0f 8f 5f ff ff ff    	jg     8034f8 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803599:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80359d:	79 47                	jns    8035e6 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80359f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035a2:	89 c6                	mov    %eax,%esi
  8035a4:	48 bf 2c 52 80 00 00 	movabs $0x80522c,%rdi
  8035ab:	00 00 00 
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b3:	48 ba 06 06 80 00 00 	movabs $0x800606,%rdx
  8035ba:	00 00 00 
  8035bd:	ff d2                	callq  *%rdx
		close(fd_src);
  8035bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c2:	89 c7                	mov    %eax,%edi
  8035c4:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
		close(fd_dest);
  8035d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035d3:	89 c7                	mov    %eax,%edi
  8035d5:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8035dc:	00 00 00 
  8035df:	ff d0                	callq  *%rax
		return read_size;
  8035e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035e4:	eb 27                	jmp    80360d <copy+0x1db>
	}
	close(fd_src);
  8035e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e9:	89 c7                	mov    %eax,%edi
  8035eb:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
	close(fd_dest);
  8035f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035fa:	89 c7                	mov    %eax,%edi
  8035fc:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
	return 0;
  803608:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80360d:	c9                   	leaveq 
  80360e:	c3                   	retq   

000000000080360f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80360f:	55                   	push   %rbp
  803610:	48 89 e5             	mov    %rsp,%rbp
  803613:	48 83 ec 20          	sub    $0x20,%rsp
  803617:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80361a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80361e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803621:	48 89 d6             	mov    %rdx,%rsi
  803624:	89 c7                	mov    %eax,%edi
  803626:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
  803632:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803639:	79 05                	jns    803640 <fd2sockid+0x31>
		return r;
  80363b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363e:	eb 24                	jmp    803664 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803644:	8b 10                	mov    (%rax),%edx
  803646:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80364d:	00 00 00 
  803650:	8b 00                	mov    (%rax),%eax
  803652:	39 c2                	cmp    %eax,%edx
  803654:	74 07                	je     80365d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803656:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80365b:	eb 07                	jmp    803664 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80365d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803661:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803664:	c9                   	leaveq 
  803665:	c3                   	retq   

0000000000803666 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803666:	55                   	push   %rbp
  803667:	48 89 e5             	mov    %rsp,%rbp
  80366a:	48 83 ec 20          	sub    $0x20,%rsp
  80366e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803671:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803687:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368b:	78 26                	js     8036b3 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80368d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803691:	ba 07 04 00 00       	mov    $0x407,%edx
  803696:	48 89 c6             	mov    %rax,%rsi
  803699:	bf 00 00 00 00       	mov    $0x0,%edi
  80369e:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
  8036aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b1:	79 16                	jns    8036c9 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8036b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 75 3b 80 00 00 	movabs $0x803b75,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
		return r;
  8036c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c7:	eb 3a                	jmp    803703 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036cd:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8036d4:	00 00 00 
  8036d7:	8b 12                	mov    (%rdx),%edx
  8036d9:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8036db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036df:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036ed:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8036f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f4:	48 89 c7             	mov    %rax,%rdi
  8036f7:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8036fe:	00 00 00 
  803701:	ff d0                	callq  *%rax
}
  803703:	c9                   	leaveq 
  803704:	c3                   	retq   

0000000000803705 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803705:	55                   	push   %rbp
  803706:	48 89 e5             	mov    %rsp,%rbp
  803709:	48 83 ec 30          	sub    $0x30,%rsp
  80370d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803710:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803714:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803718:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371b:	89 c7                	mov    %eax,%edi
  80371d:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803730:	79 05                	jns    803737 <accept+0x32>
		return r;
  803732:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803735:	eb 3b                	jmp    803772 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803737:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80373b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80373f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803742:	48 89 ce             	mov    %rcx,%rsi
  803745:	89 c7                	mov    %eax,%edi
  803747:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
  803753:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803756:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375a:	79 05                	jns    803761 <accept+0x5c>
		return r;
  80375c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375f:	eb 11                	jmp    803772 <accept+0x6d>
	return alloc_sockfd(r);
  803761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803764:	89 c7                	mov    %eax,%edi
  803766:	48 b8 66 36 80 00 00 	movabs $0x803666,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
}
  803772:	c9                   	leaveq 
  803773:	c3                   	retq   

0000000000803774 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803774:	55                   	push   %rbp
  803775:	48 89 e5             	mov    %rsp,%rbp
  803778:	48 83 ec 20          	sub    $0x20,%rsp
  80377c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80377f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803783:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803786:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803789:	89 c7                	mov    %eax,%edi
  80378b:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  803792:	00 00 00 
  803795:	ff d0                	callq  *%rax
  803797:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379e:	79 05                	jns    8037a5 <bind+0x31>
		return r;
  8037a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a3:	eb 1b                	jmp    8037c0 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8037a5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037af:	48 89 ce             	mov    %rcx,%rsi
  8037b2:	89 c7                	mov    %eax,%edi
  8037b4:	48 b8 d1 3a 80 00 00 	movabs $0x803ad1,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
}
  8037c0:	c9                   	leaveq 
  8037c1:	c3                   	retq   

00000000008037c2 <shutdown>:

int
shutdown(int s, int how)
{
  8037c2:	55                   	push   %rbp
  8037c3:	48 89 e5             	mov    %rsp,%rbp
  8037c6:	48 83 ec 20          	sub    $0x20,%rsp
  8037ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037cd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037d3:	89 c7                	mov    %eax,%edi
  8037d5:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
  8037e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e8:	79 05                	jns    8037ef <shutdown+0x2d>
		return r;
  8037ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ed:	eb 16                	jmp    803805 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8037ef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f5:	89 d6                	mov    %edx,%esi
  8037f7:	89 c7                	mov    %eax,%edi
  8037f9:	48 b8 35 3b 80 00 00 	movabs $0x803b35,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
}
  803805:	c9                   	leaveq 
  803806:	c3                   	retq   

0000000000803807 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803807:	55                   	push   %rbp
  803808:	48 89 e5             	mov    %rsp,%rbp
  80380b:	48 83 ec 10          	sub    $0x10,%rsp
  80380f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803817:	48 89 c7             	mov    %rax,%rdi
  80381a:	48 b8 7a 49 80 00 00 	movabs $0x80497a,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
  803826:	83 f8 01             	cmp    $0x1,%eax
  803829:	75 17                	jne    803842 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80382b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382f:	8b 40 0c             	mov    0xc(%rax),%eax
  803832:	89 c7                	mov    %eax,%edi
  803834:	48 b8 75 3b 80 00 00 	movabs $0x803b75,%rax
  80383b:	00 00 00 
  80383e:	ff d0                	callq  *%rax
  803840:	eb 05                	jmp    803847 <devsock_close+0x40>
	else
		return 0;
  803842:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803847:	c9                   	leaveq 
  803848:	c3                   	retq   

0000000000803849 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803849:	55                   	push   %rbp
  80384a:	48 89 e5             	mov    %rsp,%rbp
  80384d:	48 83 ec 20          	sub    $0x20,%rsp
  803851:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803854:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803858:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80385b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385e:	89 c7                	mov    %eax,%edi
  803860:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803873:	79 05                	jns    80387a <connect+0x31>
		return r;
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	eb 1b                	jmp    803895 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80387a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80387d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803884:	48 89 ce             	mov    %rcx,%rsi
  803887:	89 c7                	mov    %eax,%edi
  803889:	48 b8 a2 3b 80 00 00 	movabs $0x803ba2,%rax
  803890:	00 00 00 
  803893:	ff d0                	callq  *%rax
}
  803895:	c9                   	leaveq 
  803896:	c3                   	retq   

0000000000803897 <listen>:

int
listen(int s, int backlog)
{
  803897:	55                   	push   %rbp
  803898:	48 89 e5             	mov    %rsp,%rbp
  80389b:	48 83 ec 20          	sub    $0x20,%rsp
  80389f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a8:	89 c7                	mov    %eax,%edi
  8038aa:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
  8038b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038bd:	79 05                	jns    8038c4 <listen+0x2d>
		return r;
  8038bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c2:	eb 16                	jmp    8038da <listen+0x43>
	return nsipc_listen(r, backlog);
  8038c4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ca:	89 d6                	mov    %edx,%esi
  8038cc:	89 c7                	mov    %eax,%edi
  8038ce:	48 b8 06 3c 80 00 00 	movabs $0x803c06,%rax
  8038d5:	00 00 00 
  8038d8:	ff d0                	callq  *%rax
}
  8038da:	c9                   	leaveq 
  8038db:	c3                   	retq   

00000000008038dc <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038dc:	55                   	push   %rbp
  8038dd:	48 89 e5             	mov    %rsp,%rbp
  8038e0:	48 83 ec 20          	sub    $0x20,%rsp
  8038e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f4:	89 c2                	mov    %eax,%edx
  8038f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fa:	8b 40 0c             	mov    0xc(%rax),%eax
  8038fd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803901:	b9 00 00 00 00       	mov    $0x0,%ecx
  803906:	89 c7                	mov    %eax,%edi
  803908:	48 b8 46 3c 80 00 00 	movabs $0x803c46,%rax
  80390f:	00 00 00 
  803912:	ff d0                	callq  *%rax
}
  803914:	c9                   	leaveq 
  803915:	c3                   	retq   

0000000000803916 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803916:	55                   	push   %rbp
  803917:	48 89 e5             	mov    %rsp,%rbp
  80391a:	48 83 ec 20          	sub    $0x20,%rsp
  80391e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803922:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803926:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80392a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392e:	89 c2                	mov    %eax,%edx
  803930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803934:	8b 40 0c             	mov    0xc(%rax),%eax
  803937:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80393b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803940:	89 c7                	mov    %eax,%edi
  803942:	48 b8 12 3d 80 00 00 	movabs $0x803d12,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
}
  80394e:	c9                   	leaveq 
  80394f:	c3                   	retq   

0000000000803950 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803950:	55                   	push   %rbp
  803951:	48 89 e5             	mov    %rsp,%rbp
  803954:	48 83 ec 10          	sub    $0x10,%rsp
  803958:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80395c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803964:	48 be 47 52 80 00 00 	movabs $0x805247,%rsi
  80396b:	00 00 00 
  80396e:	48 89 c7             	mov    %rax,%rdi
  803971:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  803978:	00 00 00 
  80397b:	ff d0                	callq  *%rax
	return 0;
  80397d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803982:	c9                   	leaveq 
  803983:	c3                   	retq   

0000000000803984 <socket>:

int
socket(int domain, int type, int protocol)
{
  803984:	55                   	push   %rbp
  803985:	48 89 e5             	mov    %rsp,%rbp
  803988:	48 83 ec 20          	sub    $0x20,%rsp
  80398c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803992:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803995:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803998:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80399b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80399e:	89 ce                	mov    %ecx,%esi
  8039a0:	89 c7                	mov    %eax,%edi
  8039a2:	48 b8 ca 3d 80 00 00 	movabs $0x803dca,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
  8039ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b5:	79 05                	jns    8039bc <socket+0x38>
		return r;
  8039b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ba:	eb 11                	jmp    8039cd <socket+0x49>
	return alloc_sockfd(r);
  8039bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bf:	89 c7                	mov    %eax,%edi
  8039c1:	48 b8 66 36 80 00 00 	movabs $0x803666,%rax
  8039c8:	00 00 00 
  8039cb:	ff d0                	callq  *%rax
}
  8039cd:	c9                   	leaveq 
  8039ce:	c3                   	retq   

00000000008039cf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039cf:	55                   	push   %rbp
  8039d0:	48 89 e5             	mov    %rsp,%rbp
  8039d3:	48 83 ec 10          	sub    $0x10,%rsp
  8039d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8039da:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039e1:	00 00 00 
  8039e4:	8b 00                	mov    (%rax),%eax
  8039e6:	85 c0                	test   %eax,%eax
  8039e8:	75 1f                	jne    803a09 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039ea:	bf 02 00 00 00       	mov    $0x2,%edi
  8039ef:	48 b8 09 49 80 00 00 	movabs $0x804909,%rax
  8039f6:	00 00 00 
  8039f9:	ff d0                	callq  *%rax
  8039fb:	89 c2                	mov    %eax,%edx
  8039fd:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a04:	00 00 00 
  803a07:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a09:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a10:	00 00 00 
  803a13:	8b 00                	mov    (%rax),%eax
  803a15:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a18:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a1d:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a24:	00 00 00 
  803a27:	89 c7                	mov    %eax,%edi
  803a29:	48 b8 74 48 80 00 00 	movabs $0x804874,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a35:	ba 00 00 00 00       	mov    $0x0,%edx
  803a3a:	be 00 00 00 00       	mov    $0x0,%esi
  803a3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803a44:	48 b8 b3 47 80 00 00 	movabs $0x8047b3,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
}
  803a50:	c9                   	leaveq 
  803a51:	c3                   	retq   

0000000000803a52 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a52:	55                   	push   %rbp
  803a53:	48 89 e5             	mov    %rsp,%rbp
  803a56:	48 83 ec 30          	sub    $0x30,%rsp
  803a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a65:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a6c:	00 00 00 
  803a6f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a72:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a74:	bf 01 00 00 00       	mov    $0x1,%edi
  803a79:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
  803a85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a8c:	78 3e                	js     803acc <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a95:	00 00 00 
  803a98:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa0:	8b 40 10             	mov    0x10(%rax),%eax
  803aa3:	89 c2                	mov    %eax,%edx
  803aa5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803aa9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aad:	48 89 ce             	mov    %rcx,%rsi
  803ab0:	48 89 c7             	mov    %rax,%rdi
  803ab3:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803aba:	00 00 00 
  803abd:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803abf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac3:	8b 50 10             	mov    0x10(%rax),%edx
  803ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aca:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803acf:	c9                   	leaveq 
  803ad0:	c3                   	retq   

0000000000803ad1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ad1:	55                   	push   %rbp
  803ad2:	48 89 e5             	mov    %rsp,%rbp
  803ad5:	48 83 ec 10          	sub    $0x10,%rsp
  803ad9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803adc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ae0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803ae3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aea:	00 00 00 
  803aed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803af2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af9:	48 89 c6             	mov    %rax,%rsi
  803afc:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b03:	00 00 00 
  803b06:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803b0d:	00 00 00 
  803b10:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b12:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b19:	00 00 00 
  803b1c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b1f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b22:	bf 02 00 00 00       	mov    $0x2,%edi
  803b27:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
}
  803b33:	c9                   	leaveq 
  803b34:	c3                   	retq   

0000000000803b35 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b35:	55                   	push   %rbp
  803b36:	48 89 e5             	mov    %rsp,%rbp
  803b39:	48 83 ec 10          	sub    $0x10,%rsp
  803b3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b40:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b43:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b4a:	00 00 00 
  803b4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b50:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b52:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b59:	00 00 00 
  803b5c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b5f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b62:	bf 03 00 00 00       	mov    $0x3,%edi
  803b67:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803b6e:	00 00 00 
  803b71:	ff d0                	callq  *%rax
}
  803b73:	c9                   	leaveq 
  803b74:	c3                   	retq   

0000000000803b75 <nsipc_close>:

int
nsipc_close(int s)
{
  803b75:	55                   	push   %rbp
  803b76:	48 89 e5             	mov    %rsp,%rbp
  803b79:	48 83 ec 10          	sub    $0x10,%rsp
  803b7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b80:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b87:	00 00 00 
  803b8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b8d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b8f:	bf 04 00 00 00       	mov    $0x4,%edi
  803b94:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
}
  803ba0:	c9                   	leaveq 
  803ba1:	c3                   	retq   

0000000000803ba2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ba2:	55                   	push   %rbp
  803ba3:	48 89 e5             	mov    %rsp,%rbp
  803ba6:	48 83 ec 10          	sub    $0x10,%rsp
  803baa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bb1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803bb4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bbb:	00 00 00 
  803bbe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bc1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bc3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bca:	48 89 c6             	mov    %rax,%rsi
  803bcd:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bd4:	00 00 00 
  803bd7:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803bde:	00 00 00 
  803be1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803be3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bea:	00 00 00 
  803bed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bf0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803bf3:	bf 05 00 00 00       	mov    $0x5,%edi
  803bf8:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803bff:	00 00 00 
  803c02:	ff d0                	callq  *%rax
}
  803c04:	c9                   	leaveq 
  803c05:	c3                   	retq   

0000000000803c06 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c06:	55                   	push   %rbp
  803c07:	48 89 e5             	mov    %rsp,%rbp
  803c0a:	48 83 ec 10          	sub    $0x10,%rsp
  803c0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c11:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c14:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c1b:	00 00 00 
  803c1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c21:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c2a:	00 00 00 
  803c2d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c30:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c33:	bf 06 00 00 00       	mov    $0x6,%edi
  803c38:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
}
  803c44:	c9                   	leaveq 
  803c45:	c3                   	retq   

0000000000803c46 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c46:	55                   	push   %rbp
  803c47:	48 89 e5             	mov    %rsp,%rbp
  803c4a:	48 83 ec 30          	sub    $0x30,%rsp
  803c4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c55:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c58:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c5b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c62:	00 00 00 
  803c65:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c68:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c6a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c71:	00 00 00 
  803c74:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c77:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c7a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c81:	00 00 00 
  803c84:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c87:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c8a:	bf 07 00 00 00       	mov    $0x7,%edi
  803c8f:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
  803c9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca2:	78 69                	js     803d0d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803ca4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803cab:	7f 08                	jg     803cb5 <nsipc_recv+0x6f>
  803cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803cb3:	7e 35                	jle    803cea <nsipc_recv+0xa4>
  803cb5:	48 b9 4e 52 80 00 00 	movabs $0x80524e,%rcx
  803cbc:	00 00 00 
  803cbf:	48 ba 63 52 80 00 00 	movabs $0x805263,%rdx
  803cc6:	00 00 00 
  803cc9:	be 62 00 00 00       	mov    $0x62,%esi
  803cce:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  803cd5:	00 00 00 
  803cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  803cdd:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  803ce4:	00 00 00 
  803ce7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ced:	48 63 d0             	movslq %eax,%rdx
  803cf0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf4:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803cfb:	00 00 00 
  803cfe:	48 89 c7             	mov    %rax,%rdi
  803d01:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
	}

	return r;
  803d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d10:	c9                   	leaveq 
  803d11:	c3                   	retq   

0000000000803d12 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d12:	55                   	push   %rbp
  803d13:	48 89 e5             	mov    %rsp,%rbp
  803d16:	48 83 ec 20          	sub    $0x20,%rsp
  803d1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d21:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d24:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d27:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d2e:	00 00 00 
  803d31:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d34:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d36:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d3d:	7e 35                	jle    803d74 <nsipc_send+0x62>
  803d3f:	48 b9 84 52 80 00 00 	movabs $0x805284,%rcx
  803d46:	00 00 00 
  803d49:	48 ba 63 52 80 00 00 	movabs $0x805263,%rdx
  803d50:	00 00 00 
  803d53:	be 6d 00 00 00       	mov    $0x6d,%esi
  803d58:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  803d5f:	00 00 00 
  803d62:	b8 00 00 00 00       	mov    $0x0,%eax
  803d67:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  803d6e:	00 00 00 
  803d71:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d77:	48 63 d0             	movslq %eax,%rdx
  803d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7e:	48 89 c6             	mov    %rax,%rsi
  803d81:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d88:	00 00 00 
  803d8b:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  803d92:	00 00 00 
  803d95:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d97:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9e:	00 00 00 
  803da1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803da4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803da7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dae:	00 00 00 
  803db1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803db4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803db7:	bf 08 00 00 00       	mov    $0x8,%edi
  803dbc:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803dc3:	00 00 00 
  803dc6:	ff d0                	callq  *%rax
}
  803dc8:	c9                   	leaveq 
  803dc9:	c3                   	retq   

0000000000803dca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803dca:	55                   	push   %rbp
  803dcb:	48 89 e5             	mov    %rsp,%rbp
  803dce:	48 83 ec 10          	sub    $0x10,%rsp
  803dd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dd5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803dd8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ddb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803de2:	00 00 00 
  803de5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803de8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803dea:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df1:	00 00 00 
  803df4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803df7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803dfa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e01:	00 00 00 
  803e04:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e07:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e0a:	bf 09 00 00 00       	mov    $0x9,%edi
  803e0f:	48 b8 cf 39 80 00 00 	movabs $0x8039cf,%rax
  803e16:	00 00 00 
  803e19:	ff d0                	callq  *%rax
}
  803e1b:	c9                   	leaveq 
  803e1c:	c3                   	retq   

0000000000803e1d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e1d:	55                   	push   %rbp
  803e1e:	48 89 e5             	mov    %rsp,%rbp
  803e21:	53                   	push   %rbx
  803e22:	48 83 ec 38          	sub    $0x38,%rsp
  803e26:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e2a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e2e:	48 89 c7             	mov    %rax,%rdi
  803e31:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
  803e3d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e40:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e44:	0f 88 bf 01 00 00    	js     804009 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e4e:	ba 07 04 00 00       	mov    $0x407,%edx
  803e53:	48 89 c6             	mov    %rax,%rsi
  803e56:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5b:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
  803e67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e6e:	0f 88 95 01 00 00    	js     804009 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e74:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
  803e87:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e8e:	0f 88 5d 01 00 00    	js     803ff1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e98:	ba 07 04 00 00       	mov    $0x407,%edx
  803e9d:	48 89 c6             	mov    %rax,%rsi
  803ea0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea5:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803eac:	00 00 00 
  803eaf:	ff d0                	callq  *%rax
  803eb1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb8:	0f 88 33 01 00 00    	js     803ff1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ebe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec2:	48 89 c7             	mov    %rax,%rdi
  803ec5:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803ecc:	00 00 00 
  803ecf:	ff d0                	callq  *%rax
  803ed1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ed5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed9:	ba 07 04 00 00       	mov    $0x407,%edx
  803ede:	48 89 c6             	mov    %rax,%rsi
  803ee1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee6:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803eed:	00 00 00 
  803ef0:	ff d0                	callq  *%rax
  803ef2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ef9:	0f 88 d9 00 00 00    	js     803fd8 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f03:	48 89 c7             	mov    %rax,%rdi
  803f06:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803f0d:	00 00 00 
  803f10:	ff d0                	callq  *%rax
  803f12:	48 89 c2             	mov    %rax,%rdx
  803f15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f19:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f1f:	48 89 d1             	mov    %rdx,%rcx
  803f22:	ba 00 00 00 00       	mov    $0x0,%edx
  803f27:	48 89 c6             	mov    %rax,%rsi
  803f2a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f2f:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803f36:	00 00 00 
  803f39:	ff d0                	callq  *%rax
  803f3b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f42:	78 79                	js     803fbd <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f48:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f4f:	00 00 00 
  803f52:	8b 12                	mov    (%rdx),%edx
  803f54:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f65:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f6c:	00 00 00 
  803f6f:	8b 12                	mov    (%rdx),%edx
  803f71:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f82:	48 89 c7             	mov    %rax,%rdi
  803f85:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803f8c:	00 00 00 
  803f8f:	ff d0                	callq  *%rax
  803f91:	89 c2                	mov    %eax,%edx
  803f93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f97:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f9d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fa5:	48 89 c7             	mov    %rax,%rdi
  803fa8:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803faf:	00 00 00 
  803fb2:	ff d0                	callq  *%rax
  803fb4:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbb:	eb 4f                	jmp    80400c <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803fbd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fc2:	48 89 c6             	mov    %rax,%rsi
  803fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fca:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  803fd1:	00 00 00 
  803fd4:	ff d0                	callq  *%rax
  803fd6:	eb 01                	jmp    803fd9 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803fd8:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803fd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fdd:	48 89 c6             	mov    %rax,%rsi
  803fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  803fe5:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  803fec:	00 00 00 
  803fef:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ff1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff5:	48 89 c6             	mov    %rax,%rsi
  803ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ffd:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  804004:	00 00 00 
  804007:	ff d0                	callq  *%rax
err:
	return r;
  804009:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80400c:	48 83 c4 38          	add    $0x38,%rsp
  804010:	5b                   	pop    %rbx
  804011:	5d                   	pop    %rbp
  804012:	c3                   	retq   

0000000000804013 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804013:	55                   	push   %rbp
  804014:	48 89 e5             	mov    %rsp,%rbp
  804017:	53                   	push   %rbx
  804018:	48 83 ec 28          	sub    $0x28,%rsp
  80401c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804020:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804024:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80402b:	00 00 00 
  80402e:	48 8b 00             	mov    (%rax),%rax
  804031:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804037:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80403a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403e:	48 89 c7             	mov    %rax,%rdi
  804041:	48 b8 7a 49 80 00 00 	movabs $0x80497a,%rax
  804048:	00 00 00 
  80404b:	ff d0                	callq  *%rax
  80404d:	89 c3                	mov    %eax,%ebx
  80404f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804053:	48 89 c7             	mov    %rax,%rdi
  804056:	48 b8 7a 49 80 00 00 	movabs $0x80497a,%rax
  80405d:	00 00 00 
  804060:	ff d0                	callq  *%rax
  804062:	39 c3                	cmp    %eax,%ebx
  804064:	0f 94 c0             	sete   %al
  804067:	0f b6 c0             	movzbl %al,%eax
  80406a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80406d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804074:	00 00 00 
  804077:	48 8b 00             	mov    (%rax),%rax
  80407a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804080:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804083:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804086:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804089:	75 05                	jne    804090 <_pipeisclosed+0x7d>
			return ret;
  80408b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80408e:	eb 4a                	jmp    8040da <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804090:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804093:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804096:	74 8c                	je     804024 <_pipeisclosed+0x11>
  804098:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80409c:	75 86                	jne    804024 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80409e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8040a5:	00 00 00 
  8040a8:	48 8b 00             	mov    (%rax),%rax
  8040ab:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040b1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040b7:	89 c6                	mov    %eax,%esi
  8040b9:	48 bf 95 52 80 00 00 	movabs $0x805295,%rdi
  8040c0:	00 00 00 
  8040c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c8:	49 b8 06 06 80 00 00 	movabs $0x800606,%r8
  8040cf:	00 00 00 
  8040d2:	41 ff d0             	callq  *%r8
	}
  8040d5:	e9 4a ff ff ff       	jmpq   804024 <_pipeisclosed+0x11>

}
  8040da:	48 83 c4 28          	add    $0x28,%rsp
  8040de:	5b                   	pop    %rbx
  8040df:	5d                   	pop    %rbp
  8040e0:	c3                   	retq   

00000000008040e1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8040e1:	55                   	push   %rbp
  8040e2:	48 89 e5             	mov    %rsp,%rbp
  8040e5:	48 83 ec 30          	sub    $0x30,%rsp
  8040e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040f3:	48 89 d6             	mov    %rdx,%rsi
  8040f6:	89 c7                	mov    %eax,%edi
  8040f8:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8040ff:	00 00 00 
  804102:	ff d0                	callq  *%rax
  804104:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804107:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80410b:	79 05                	jns    804112 <pipeisclosed+0x31>
		return r;
  80410d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804110:	eb 31                	jmp    804143 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804116:	48 89 c7             	mov    %rax,%rdi
  804119:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804120:	00 00 00 
  804123:	ff d0                	callq  *%rax
  804125:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804131:	48 89 d6             	mov    %rdx,%rsi
  804134:	48 89 c7             	mov    %rax,%rdi
  804137:	48 b8 13 40 80 00 00 	movabs $0x804013,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
}
  804143:	c9                   	leaveq 
  804144:	c3                   	retq   

0000000000804145 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804145:	55                   	push   %rbp
  804146:	48 89 e5             	mov    %rsp,%rbp
  804149:	48 83 ec 40          	sub    $0x40,%rsp
  80414d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804151:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804155:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80415d:	48 89 c7             	mov    %rax,%rdi
  804160:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804167:	00 00 00 
  80416a:	ff d0                	callq  *%rax
  80416c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804170:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804174:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804178:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80417f:	00 
  804180:	e9 90 00 00 00       	jmpq   804215 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804185:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80418a:	74 09                	je     804195 <devpipe_read+0x50>
				return i;
  80418c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804190:	e9 8e 00 00 00       	jmpq   804223 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804195:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419d:	48 89 d6             	mov    %rdx,%rsi
  8041a0:	48 89 c7             	mov    %rax,%rdi
  8041a3:	48 b8 13 40 80 00 00 	movabs $0x804013,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
  8041af:	85 c0                	test   %eax,%eax
  8041b1:	74 07                	je     8041ba <devpipe_read+0x75>
				return 0;
  8041b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b8:	eb 69                	jmp    804223 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041ba:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  8041c1:	00 00 00 
  8041c4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ca:	8b 10                	mov    (%rax),%edx
  8041cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d0:	8b 40 04             	mov    0x4(%rax),%eax
  8041d3:	39 c2                	cmp    %eax,%edx
  8041d5:	74 ae                	je     804185 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041df:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e7:	8b 00                	mov    (%rax),%eax
  8041e9:	99                   	cltd   
  8041ea:	c1 ea 1b             	shr    $0x1b,%edx
  8041ed:	01 d0                	add    %edx,%eax
  8041ef:	83 e0 1f             	and    $0x1f,%eax
  8041f2:	29 d0                	sub    %edx,%eax
  8041f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041f8:	48 98                	cltq   
  8041fa:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041ff:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804205:	8b 00                	mov    (%rax),%eax
  804207:	8d 50 01             	lea    0x1(%rax),%edx
  80420a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804210:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804219:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80421d:	72 a7                	jb     8041c6 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80421f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804223:	c9                   	leaveq 
  804224:	c3                   	retq   

0000000000804225 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804225:	55                   	push   %rbp
  804226:	48 89 e5             	mov    %rsp,%rbp
  804229:	48 83 ec 40          	sub    $0x40,%rsp
  80422d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804231:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804235:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80423d:	48 89 c7             	mov    %rax,%rdi
  804240:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804247:	00 00 00 
  80424a:	ff d0                	callq  *%rax
  80424c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804250:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804254:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804258:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80425f:	00 
  804260:	e9 8f 00 00 00       	jmpq   8042f4 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804265:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80426d:	48 89 d6             	mov    %rdx,%rsi
  804270:	48 89 c7             	mov    %rax,%rdi
  804273:	48 b8 13 40 80 00 00 	movabs $0x804013,%rax
  80427a:	00 00 00 
  80427d:	ff d0                	callq  *%rax
  80427f:	85 c0                	test   %eax,%eax
  804281:	74 07                	je     80428a <devpipe_write+0x65>
				return 0;
  804283:	b8 00 00 00 00       	mov    $0x0,%eax
  804288:	eb 78                	jmp    804302 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80428a:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  804291:	00 00 00 
  804294:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804296:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429a:	8b 40 04             	mov    0x4(%rax),%eax
  80429d:	48 63 d0             	movslq %eax,%rdx
  8042a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a4:	8b 00                	mov    (%rax),%eax
  8042a6:	48 98                	cltq   
  8042a8:	48 83 c0 20          	add    $0x20,%rax
  8042ac:	48 39 c2             	cmp    %rax,%rdx
  8042af:	73 b4                	jae    804265 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b5:	8b 40 04             	mov    0x4(%rax),%eax
  8042b8:	99                   	cltd   
  8042b9:	c1 ea 1b             	shr    $0x1b,%edx
  8042bc:	01 d0                	add    %edx,%eax
  8042be:	83 e0 1f             	and    $0x1f,%eax
  8042c1:	29 d0                	sub    %edx,%eax
  8042c3:	89 c6                	mov    %eax,%esi
  8042c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042cd:	48 01 d0             	add    %rdx,%rax
  8042d0:	0f b6 08             	movzbl (%rax),%ecx
  8042d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042d7:	48 63 c6             	movslq %esi,%rax
  8042da:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e2:	8b 40 04             	mov    0x4(%rax),%eax
  8042e5:	8d 50 01             	lea    0x1(%rax),%edx
  8042e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ec:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042fc:	72 98                	jb     804296 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804302:	c9                   	leaveq 
  804303:	c3                   	retq   

0000000000804304 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804304:	55                   	push   %rbp
  804305:	48 89 e5             	mov    %rsp,%rbp
  804308:	48 83 ec 20          	sub    $0x20,%rsp
  80430c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804310:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804318:	48 89 c7             	mov    %rax,%rdi
  80431b:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804322:	00 00 00 
  804325:	ff d0                	callq  *%rax
  804327:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80432b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80432f:	48 be a8 52 80 00 00 	movabs $0x8052a8,%rsi
  804336:	00 00 00 
  804339:	48 89 c7             	mov    %rax,%rdi
  80433c:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  804343:	00 00 00 
  804346:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80434c:	8b 50 04             	mov    0x4(%rax),%edx
  80434f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804353:	8b 00                	mov    (%rax),%eax
  804355:	29 c2                	sub    %eax,%edx
  804357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80435b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804365:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80436c:	00 00 00 
	stat->st_dev = &devpipe;
  80436f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804373:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80437a:	00 00 00 
  80437d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804384:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804389:	c9                   	leaveq 
  80438a:	c3                   	retq   

000000000080438b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80438b:	55                   	push   %rbp
  80438c:	48 89 e5             	mov    %rsp,%rbp
  80438f:	48 83 ec 10          	sub    $0x10,%rsp
  804393:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80439b:	48 89 c6             	mov    %rax,%rsi
  80439e:	bf 00 00 00 00       	mov    $0x0,%edi
  8043a3:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8043aa:	00 00 00 
  8043ad:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8043af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b3:	48 89 c7             	mov    %rax,%rdi
  8043b6:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8043bd:	00 00 00 
  8043c0:	ff d0                	callq  *%rax
  8043c2:	48 89 c6             	mov    %rax,%rsi
  8043c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ca:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8043d1:	00 00 00 
  8043d4:	ff d0                	callq  *%rax
}
  8043d6:	c9                   	leaveq 
  8043d7:	c3                   	retq   

00000000008043d8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043d8:	55                   	push   %rbp
  8043d9:	48 89 e5             	mov    %rsp,%rbp
  8043dc:	48 83 ec 20          	sub    $0x20,%rsp
  8043e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043e6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043e9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043ed:	be 01 00 00 00       	mov    $0x1,%esi
  8043f2:	48 89 c7             	mov    %rax,%rdi
  8043f5:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  8043fc:	00 00 00 
  8043ff:	ff d0                	callq  *%rax
}
  804401:	90                   	nop
  804402:	c9                   	leaveq 
  804403:	c3                   	retq   

0000000000804404 <getchar>:

int
getchar(void)
{
  804404:	55                   	push   %rbp
  804405:	48 89 e5             	mov    %rsp,%rbp
  804408:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80440c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804410:	ba 01 00 00 00       	mov    $0x1,%edx
  804415:	48 89 c6             	mov    %rax,%rsi
  804418:	bf 00 00 00 00       	mov    $0x0,%edi
  80441d:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  804424:	00 00 00 
  804427:	ff d0                	callq  *%rax
  804429:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80442c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804430:	79 05                	jns    804437 <getchar+0x33>
		return r;
  804432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804435:	eb 14                	jmp    80444b <getchar+0x47>
	if (r < 1)
  804437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80443b:	7f 07                	jg     804444 <getchar+0x40>
		return -E_EOF;
  80443d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804442:	eb 07                	jmp    80444b <getchar+0x47>
	return c;
  804444:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804448:	0f b6 c0             	movzbl %al,%eax

}
  80444b:	c9                   	leaveq 
  80444c:	c3                   	retq   

000000000080444d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80444d:	55                   	push   %rbp
  80444e:	48 89 e5             	mov    %rsp,%rbp
  804451:	48 83 ec 20          	sub    $0x20,%rsp
  804455:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804458:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80445c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80445f:	48 89 d6             	mov    %rdx,%rsi
  804462:	89 c7                	mov    %eax,%edi
  804464:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  80446b:	00 00 00 
  80446e:	ff d0                	callq  *%rax
  804470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804477:	79 05                	jns    80447e <iscons+0x31>
		return r;
  804479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447c:	eb 1a                	jmp    804498 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80447e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804482:	8b 10                	mov    (%rax),%edx
  804484:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80448b:	00 00 00 
  80448e:	8b 00                	mov    (%rax),%eax
  804490:	39 c2                	cmp    %eax,%edx
  804492:	0f 94 c0             	sete   %al
  804495:	0f b6 c0             	movzbl %al,%eax
}
  804498:	c9                   	leaveq 
  804499:	c3                   	retq   

000000000080449a <opencons>:

int
opencons(void)
{
  80449a:	55                   	push   %rbp
  80449b:	48 89 e5             	mov    %rsp,%rbp
  80449e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044a6:	48 89 c7             	mov    %rax,%rdi
  8044a9:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  8044b0:	00 00 00 
  8044b3:	ff d0                	callq  *%rax
  8044b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044bc:	79 05                	jns    8044c3 <opencons+0x29>
		return r;
  8044be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c1:	eb 5b                	jmp    80451e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c7:	ba 07 04 00 00       	mov    $0x407,%edx
  8044cc:	48 89 c6             	mov    %rax,%rsi
  8044cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8044d4:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8044db:	00 00 00 
  8044de:	ff d0                	callq  *%rax
  8044e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e7:	79 05                	jns    8044ee <opencons+0x54>
		return r;
  8044e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ec:	eb 30                	jmp    80451e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f2:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044f9:	00 00 00 
  8044fc:	8b 12                	mov    (%rdx),%edx
  8044fe:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804504:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80450b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450f:	48 89 c7             	mov    %rax,%rdi
  804512:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  804519:	00 00 00 
  80451c:	ff d0                	callq  *%rax
}
  80451e:	c9                   	leaveq 
  80451f:	c3                   	retq   

0000000000804520 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804520:	55                   	push   %rbp
  804521:	48 89 e5             	mov    %rsp,%rbp
  804524:	48 83 ec 30          	sub    $0x30,%rsp
  804528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80452c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804534:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804539:	75 13                	jne    80454e <devcons_read+0x2e>
		return 0;
  80453b:	b8 00 00 00 00       	mov    $0x0,%eax
  804540:	eb 49                	jmp    80458b <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804542:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  804549:	00 00 00 
  80454c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80454e:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  804555:	00 00 00 
  804558:	ff d0                	callq  *%rax
  80455a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80455d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804561:	74 df                	je     804542 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804563:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804567:	79 05                	jns    80456e <devcons_read+0x4e>
		return c;
  804569:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80456c:	eb 1d                	jmp    80458b <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80456e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804572:	75 07                	jne    80457b <devcons_read+0x5b>
		return 0;
  804574:	b8 00 00 00 00       	mov    $0x0,%eax
  804579:	eb 10                	jmp    80458b <devcons_read+0x6b>
	*(char*)vbuf = c;
  80457b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457e:	89 c2                	mov    %eax,%edx
  804580:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804584:	88 10                	mov    %dl,(%rax)
	return 1;
  804586:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80458b:	c9                   	leaveq 
  80458c:	c3                   	retq   

000000000080458d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80458d:	55                   	push   %rbp
  80458e:	48 89 e5             	mov    %rsp,%rbp
  804591:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804598:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80459f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045a6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045b4:	eb 76                	jmp    80462c <devcons_write+0x9f>
		m = n - tot;
  8045b6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045bd:	89 c2                	mov    %eax,%edx
  8045bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c2:	29 c2                	sub    %eax,%edx
  8045c4:	89 d0                	mov    %edx,%eax
  8045c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8045c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045cc:	83 f8 7f             	cmp    $0x7f,%eax
  8045cf:	76 07                	jbe    8045d8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8045d1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045db:	48 63 d0             	movslq %eax,%rdx
  8045de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e1:	48 63 c8             	movslq %eax,%rcx
  8045e4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045eb:	48 01 c1             	add    %rax,%rcx
  8045ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045f5:	48 89 ce             	mov    %rcx,%rsi
  8045f8:	48 89 c7             	mov    %rax,%rdi
  8045fb:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  804602:	00 00 00 
  804605:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804607:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80460a:	48 63 d0             	movslq %eax,%rdx
  80460d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804614:	48 89 d6             	mov    %rdx,%rsi
  804617:	48 89 c7             	mov    %rax,%rdi
  80461a:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  804621:	00 00 00 
  804624:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804626:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804629:	01 45 fc             	add    %eax,-0x4(%rbp)
  80462c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462f:	48 98                	cltq   
  804631:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804638:	0f 82 78 ff ff ff    	jb     8045b6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80463e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804641:	c9                   	leaveq 
  804642:	c3                   	retq   

0000000000804643 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804643:	55                   	push   %rbp
  804644:	48 89 e5             	mov    %rsp,%rbp
  804647:	48 83 ec 08          	sub    $0x8,%rsp
  80464b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80464f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804654:	c9                   	leaveq 
  804655:	c3                   	retq   

0000000000804656 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804656:	55                   	push   %rbp
  804657:	48 89 e5             	mov    %rsp,%rbp
  80465a:	48 83 ec 10          	sub    $0x10,%rsp
  80465e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804662:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80466a:	48 be b4 52 80 00 00 	movabs $0x8052b4,%rsi
  804671:	00 00 00 
  804674:	48 89 c7             	mov    %rax,%rdi
  804677:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  80467e:	00 00 00 
  804681:	ff d0                	callq  *%rax
	return 0;
  804683:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804688:	c9                   	leaveq 
  804689:	c3                   	retq   

000000000080468a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80468a:	55                   	push   %rbp
  80468b:	48 89 e5             	mov    %rsp,%rbp
  80468e:	48 83 ec 20          	sub    $0x20,%rsp
  804692:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804696:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80469d:	00 00 00 
  8046a0:	48 8b 00             	mov    (%rax),%rax
  8046a3:	48 85 c0             	test   %rax,%rax
  8046a6:	75 6f                	jne    804717 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8046a8:	ba 07 00 00 00       	mov    $0x7,%edx
  8046ad:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8046b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8046b7:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8046be:	00 00 00 
  8046c1:	ff d0                	callq  *%rax
  8046c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ca:	79 30                	jns    8046fc <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8046cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046cf:	89 c1                	mov    %eax,%ecx
  8046d1:	48 ba c0 52 80 00 00 	movabs $0x8052c0,%rdx
  8046d8:	00 00 00 
  8046db:	be 22 00 00 00       	mov    $0x22,%esi
  8046e0:	48 bf df 52 80 00 00 	movabs $0x8052df,%rdi
  8046e7:	00 00 00 
  8046ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ef:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  8046f6:	00 00 00 
  8046f9:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8046fc:	48 be 2b 47 80 00 00 	movabs $0x80472b,%rsi
  804703:	00 00 00 
  804706:	bf 00 00 00 00       	mov    $0x0,%edi
  80470b:	48 b8 63 1c 80 00 00 	movabs $0x801c63,%rax
  804712:	00 00 00 
  804715:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804717:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80471e:	00 00 00 
  804721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804725:	48 89 10             	mov    %rdx,(%rax)
}
  804728:	90                   	nop
  804729:	c9                   	leaveq 
  80472a:	c3                   	retq   

000000000080472b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80472b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80472e:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804735:	00 00 00 
call *%rax
  804738:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  80473a:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804741:	00 08 
    movq 152(%rsp), %rax
  804743:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  80474a:	00 
    movq 136(%rsp), %rbx
  80474b:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804752:	00 
movq %rbx, (%rax)
  804753:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804756:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80475a:	4c 8b 3c 24          	mov    (%rsp),%r15
  80475e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804763:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804768:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80476d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804772:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804777:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80477c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804781:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804786:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80478b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804790:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804795:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80479a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80479f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8047a4:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  8047a8:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8047ac:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8047ad:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8047b2:	c3                   	retq   

00000000008047b3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8047b3:	55                   	push   %rbp
  8047b4:	48 89 e5             	mov    %rsp,%rbp
  8047b7:	48 83 ec 30          	sub    $0x30,%rsp
  8047bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8047c7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047cc:	75 0e                	jne    8047dc <ipc_recv+0x29>
		pg = (void*) UTOP;
  8047ce:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047d5:	00 00 00 
  8047d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8047dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e0:	48 89 c7             	mov    %rax,%rdi
  8047e3:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  8047ea:	00 00 00 
  8047ed:	ff d0                	callq  *%rax
  8047ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047f6:	79 27                	jns    80481f <ipc_recv+0x6c>
		if (from_env_store)
  8047f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047fd:	74 0a                	je     804809 <ipc_recv+0x56>
			*from_env_store = 0;
  8047ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804803:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804809:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80480e:	74 0a                	je     80481a <ipc_recv+0x67>
			*perm_store = 0;
  804810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804814:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80481a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481d:	eb 53                	jmp    804872 <ipc_recv+0xbf>
	}
	if (from_env_store)
  80481f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804824:	74 19                	je     80483f <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804826:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80482d:	00 00 00 
  804830:	48 8b 00             	mov    (%rax),%rax
  804833:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80483d:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80483f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804844:	74 19                	je     80485f <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804846:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80484d:	00 00 00 
  804850:	48 8b 00             	mov    (%rax),%rax
  804853:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80485d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80485f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804866:	00 00 00 
  804869:	48 8b 00             	mov    (%rax),%rax
  80486c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804872:	c9                   	leaveq 
  804873:	c3                   	retq   

0000000000804874 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804874:	55                   	push   %rbp
  804875:	48 89 e5             	mov    %rsp,%rbp
  804878:	48 83 ec 30          	sub    $0x30,%rsp
  80487c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80487f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804882:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804886:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804889:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80488e:	75 1c                	jne    8048ac <ipc_send+0x38>
		pg = (void*) UTOP;
  804890:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804897:	00 00 00 
  80489a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80489e:	eb 0c                	jmp    8048ac <ipc_send+0x38>
		sys_yield();
  8048a0:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  8048a7:	00 00 00 
  8048aa:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8048ac:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048af:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8048b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8048b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048b9:	89 c7                	mov    %eax,%edi
  8048bb:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  8048c2:	00 00 00 
  8048c5:	ff d0                	callq  *%rax
  8048c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048ca:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048ce:	74 d0                	je     8048a0 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8048d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048d4:	79 30                	jns    804906 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8048d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d9:	89 c1                	mov    %eax,%ecx
  8048db:	48 ba ed 52 80 00 00 	movabs $0x8052ed,%rdx
  8048e2:	00 00 00 
  8048e5:	be 47 00 00 00       	mov    $0x47,%esi
  8048ea:	48 bf 03 53 80 00 00 	movabs $0x805303,%rdi
  8048f1:	00 00 00 
  8048f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f9:	49 b8 cc 03 80 00 00 	movabs $0x8003cc,%r8
  804900:	00 00 00 
  804903:	41 ff d0             	callq  *%r8

}
  804906:	90                   	nop
  804907:	c9                   	leaveq 
  804908:	c3                   	retq   

0000000000804909 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804909:	55                   	push   %rbp
  80490a:	48 89 e5             	mov    %rsp,%rbp
  80490d:	48 83 ec 18          	sub    $0x18,%rsp
  804911:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804914:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80491b:	eb 4d                	jmp    80496a <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80491d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804924:	00 00 00 
  804927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492a:	48 98                	cltq   
  80492c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804933:	48 01 d0             	add    %rdx,%rax
  804936:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80493c:	8b 00                	mov    (%rax),%eax
  80493e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804941:	75 23                	jne    804966 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804943:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80494a:	00 00 00 
  80494d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804950:	48 98                	cltq   
  804952:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804959:	48 01 d0             	add    %rdx,%rax
  80495c:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804962:	8b 00                	mov    (%rax),%eax
  804964:	eb 12                	jmp    804978 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804966:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80496a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804971:	7e aa                	jle    80491d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804973:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804978:	c9                   	leaveq 
  804979:	c3                   	retq   

000000000080497a <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80497a:	55                   	push   %rbp
  80497b:	48 89 e5             	mov    %rsp,%rbp
  80497e:	48 83 ec 18          	sub    $0x18,%rsp
  804982:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80498a:	48 c1 e8 15          	shr    $0x15,%rax
  80498e:	48 89 c2             	mov    %rax,%rdx
  804991:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804998:	01 00 00 
  80499b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80499f:	83 e0 01             	and    $0x1,%eax
  8049a2:	48 85 c0             	test   %rax,%rax
  8049a5:	75 07                	jne    8049ae <pageref+0x34>
		return 0;
  8049a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ac:	eb 56                	jmp    804a04 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8049ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049b2:	48 c1 e8 0c          	shr    $0xc,%rax
  8049b6:	48 89 c2             	mov    %rax,%rdx
  8049b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049c0:	01 00 00 
  8049c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8049cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049cf:	83 e0 01             	and    $0x1,%eax
  8049d2:	48 85 c0             	test   %rax,%rax
  8049d5:	75 07                	jne    8049de <pageref+0x64>
		return 0;
  8049d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8049dc:	eb 26                	jmp    804a04 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8049de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049e2:	48 c1 e8 0c          	shr    $0xc,%rax
  8049e6:	48 89 c2             	mov    %rax,%rdx
  8049e9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049f0:	00 00 00 
  8049f3:	48 c1 e2 04          	shl    $0x4,%rdx
  8049f7:	48 01 d0             	add    %rdx,%rax
  8049fa:	48 83 c0 08          	add    $0x8,%rax
  8049fe:	0f b7 00             	movzwl (%rax),%eax
  804a01:	0f b7 c0             	movzwl %ax,%eax
}
  804a04:	c9                   	leaveq 
  804a05:	c3                   	retq   
