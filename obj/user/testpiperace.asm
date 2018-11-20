
obj/user/testpiperace:     file format elf64-x86-64


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
  80003c:	e8 45 03 00 00       	callq  800386 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 80 4a 80 00 00 	movabs $0x804a80,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 d2 40 80 00 00 	movabs $0x8040d2,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 99 4a 80 00 00 	movabs $0x804a99,%rdx
  800095:	00 00 00 
  800098:	be 0e 00 00 00       	mov    $0xe,%esi
  80009d:	48 bf a2 4a 80 00 00 	movabs $0x804aa2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba b6 4a 80 00 00 	movabs $0x804ab6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 11 00 00 00       	mov    $0x11,%esi
  8000e9:	48 bf a2 4a 80 00 00 	movabs $0x804aa2,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 96 43 80 00 00 	movabs $0x804396,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf bf 4a 80 00 00 	movabs $0x804abf,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf da 4a 80 00 00 	movabs $0x804ada,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 98                	cltq   
  8001d0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001de:	00 00 00 
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f3:	00 00 00 
  8001f6:	48 29 c2             	sub    %rax,%rdx
  8001f9:	48 89 d0             	mov    %rdx,%rax
  8001fc:	48 c1 f8 03          	sar    $0x3,%rax
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	48 b8 a5 4f fa a4 4f 	movabs $0x4fa4fa4fa4fa4fa5,%rax
  80020a:	fa a4 4f 
  80020d:	48 0f af c2          	imul   %rdx,%rax
  800211:	48 89 c6             	mov    %rax,%rsi
  800214:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80025d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800261:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800267:	83 f8 02             	cmp    $0x2,%eax
  80026a:	74 db                	je     800247 <umain+0x204>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80026c:	48 bf f0 4a 80 00 00 	movabs $0x804af0,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 96 43 80 00 00 	movabs $0x804396,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba 08 4b 80 00 00 	movabs $0x804b08,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3b 00 00 00       	mov    $0x3b,%esi
  8002ab:	48 bf a2 4a 80 00 00 	movabs $0x804aa2,%rdi
  8002b2:	00 00 00 
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	48 b9 2e 04 80 00 00 	movabs $0x80042e,%rcx
  8002c1:	00 00 00 
  8002c4:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002c9:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002cd:	48 89 d6             	mov    %rdx,%rsi
  8002d0:	89 c7                	mov    %eax,%edi
  8002d2:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba 32 4b 80 00 00 	movabs $0x804b32,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3d 00 00 00       	mov    $0x3d,%esi
  8002fb:	48 bf a2 4a 80 00 00 	movabs $0x804aa2,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf 4a 4b 80 00 00 	movabs $0x804b4a,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80035c:	00 00 00 
  80035f:	ff d2                	callq  *%rdx
	else
		cprintf("\nrace didn't happen\n", max);
}
  800361:	eb 20                	jmp    800383 <umain+0x340>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
	if (pageref(va) != 3+1)
		cprintf("\nchild detected race\n");
	else
		cprintf("\nrace didn't happen\n", max);
  800363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 60 4b 80 00 00 	movabs $0x804b60,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
}
  800383:	90                   	nop
  800384:	c9                   	leaveq 
  800385:	c3                   	retq   

0000000000800386 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800386:	55                   	push   %rbp
  800387:	48 89 e5             	mov    %rsp,%rbp
  80038a:	48 83 ec 10          	sub    $0x10,%rsp
  80038e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800391:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800395:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	callq  *%rax
  8003a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003a6:	48 98                	cltq   
  8003a8:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8003af:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003b6:	00 00 00 
  8003b9:	48 01 c2             	add    %rax,%rdx
  8003bc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8003c3:	00 00 00 
  8003c6:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003cd:	7e 14                	jle    8003e3 <libmain+0x5d>
		binaryname = argv[0];
  8003cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d3:	48 8b 10             	mov    (%rax),%rdx
  8003d6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003dd:	00 00 00 
  8003e0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ea:	48 89 d6             	mov    %rdx,%rsi
  8003ed:	89 c7                	mov    %eax,%edi
  8003ef:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f6:	00 00 00 
  8003f9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003fb:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
}
  800407:	90                   	nop
  800408:	c9                   	leaveq 
  800409:	c3                   	retq   

000000000080040a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80040e:	48 b8 48 2b 80 00 00 	movabs $0x802b48,%rax
  800415:	00 00 00 
  800418:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80041a:	bf 00 00 00 00       	mov    $0x0,%edi
  80041f:	48 b8 6f 1a 80 00 00 	movabs $0x801a6f,%rax
  800426:	00 00 00 
  800429:	ff d0                	callq  *%rax
}
  80042b:	90                   	nop
  80042c:	5d                   	pop    %rbp
  80042d:	c3                   	retq   

000000000080042e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042e:	55                   	push   %rbp
  80042f:	48 89 e5             	mov    %rsp,%rbp
  800432:	53                   	push   %rbx
  800433:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80043a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800441:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800447:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80044e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800455:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80045c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800463:	84 c0                	test   %al,%al
  800465:	74 23                	je     80048a <_panic+0x5c>
  800467:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80046e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800472:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800476:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80047a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80047e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800482:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800486:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80048a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800491:	00 00 00 
  800494:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80049b:	00 00 00 
  80049e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004a2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8004be:	00 00 00 
  8004c1:	48 8b 18             	mov    (%rax),%rbx
  8004c4:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  8004cb:	00 00 00 
  8004ce:	ff d0                	callq  *%rax
  8004d0:	89 c6                	mov    %eax,%esi
  8004d2:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8004d8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004df:	41 89 d0             	mov    %edx,%r8d
  8004e2:	48 89 c1             	mov    %rax,%rcx
  8004e5:	48 89 da             	mov    %rbx,%rdx
  8004e8:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  8004ef:	00 00 00 
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	49 b9 68 06 80 00 00 	movabs $0x800668,%r9
  8004fe:	00 00 00 
  800501:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800504:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80050b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800512:	48 89 d6             	mov    %rdx,%rsi
  800515:	48 89 c7             	mov    %rax,%rdi
  800518:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  80051f:	00 00 00 
  800522:	ff d0                	callq  *%rax
	cprintf("\n");
  800524:	48 bf a3 4b 80 00 00 	movabs $0x804ba3,%rdi
  80052b:	00 00 00 
  80052e:	b8 00 00 00 00       	mov    $0x0,%eax
  800533:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80053a:	00 00 00 
  80053d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053f:	cc                   	int3   
  800540:	eb fd                	jmp    80053f <_panic+0x111>

0000000000800542 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800542:	55                   	push   %rbp
  800543:	48 89 e5             	mov    %rsp,%rbp
  800546:	48 83 ec 10          	sub    $0x10,%rsp
  80054a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800555:	8b 00                	mov    (%rax),%eax
  800557:	8d 48 01             	lea    0x1(%rax),%ecx
  80055a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055e:	89 0a                	mov    %ecx,(%rdx)
  800560:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800563:	89 d1                	mov    %edx,%ecx
  800565:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800569:	48 98                	cltq   
  80056b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80056f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	3d ff 00 00 00       	cmp    $0xff,%eax
  80057a:	75 2c                	jne    8005a8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80057c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	48 98                	cltq   
  800584:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800588:	48 83 c2 08          	add    $0x8,%rdx
  80058c:	48 89 c6             	mov    %rax,%rsi
  80058f:	48 89 d7             	mov    %rdx,%rdi
  800592:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  800599:	00 00 00 
  80059c:	ff d0                	callq  *%rax
        b->idx = 0;
  80059e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ac:	8b 40 04             	mov    0x4(%rax),%eax
  8005af:	8d 50 01             	lea    0x1(%rax),%edx
  8005b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b9:	90                   	nop
  8005ba:	c9                   	leaveq 
  8005bb:	c3                   	retq   

00000000008005bc <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005bc:	55                   	push   %rbp
  8005bd:	48 89 e5             	mov    %rsp,%rbp
  8005c0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005ce:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005d5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005dc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005e3:	48 8b 0a             	mov    (%rdx),%rcx
  8005e6:	48 89 08             	mov    %rcx,(%rax)
  8005e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800600:	00 00 00 
    b.cnt = 0;
  800603:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80060a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80060d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800614:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80061b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800622:	48 89 c6             	mov    %rax,%rsi
  800625:	48 bf 42 05 80 00 00 	movabs $0x800542,%rdi
  80062c:	00 00 00 
  80062f:	48 b8 06 0a 80 00 00 	movabs $0x800a06,%rax
  800636:	00 00 00 
  800639:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80063b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800641:	48 98                	cltq   
  800643:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80064a:	48 83 c2 08          	add    $0x8,%rdx
  80064e:	48 89 c6             	mov    %rax,%rsi
  800651:	48 89 d7             	mov    %rdx,%rdi
  800654:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80065b:	00 00 00 
  80065e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800660:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800666:	c9                   	leaveq 
  800667:	c3                   	retq   

0000000000800668 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800668:	55                   	push   %rbp
  800669:	48 89 e5             	mov    %rsp,%rbp
  80066c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800673:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80067a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800681:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800688:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80068f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800696:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80069d:	84 c0                	test   %al,%al
  80069f:	74 20                	je     8006c1 <cprintf+0x59>
  8006a1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006a5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006a9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006ad:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006b1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006b5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006b9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006bd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006c1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c8:	00 00 00 
  8006cb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006d2:	00 00 00 
  8006d5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006e0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ee:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006fc:	48 8b 0a             	mov    (%rdx),%rcx
  8006ff:	48 89 08             	mov    %rcx,(%rax)
  800702:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800706:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80070a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800712:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800719:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800720:	48 89 d6             	mov    %rdx,%rsi
  800723:	48 89 c7             	mov    %rax,%rdi
  800726:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  80072d:	00 00 00 
  800730:	ff d0                	callq  *%rax
  800732:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800738:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80073e:	c9                   	leaveq 
  80073f:	c3                   	retq   

0000000000800740 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800740:	55                   	push   %rbp
  800741:	48 89 e5             	mov    %rsp,%rbp
  800744:	48 83 ec 30          	sub    $0x30,%rsp
  800748:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80074c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800750:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800754:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800757:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80075b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800762:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800766:	77 54                	ja     8007bc <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800768:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80076b:	8d 78 ff             	lea    -0x1(%rax),%edi
  80076e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	48 f7 f6             	div    %rsi
  80077d:	49 89 c2             	mov    %rax,%r10
  800780:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800783:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800786:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80078a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80078e:	41 89 c9             	mov    %ecx,%r9d
  800791:	41 89 f8             	mov    %edi,%r8d
  800794:	89 d1                	mov    %edx,%ecx
  800796:	4c 89 d2             	mov    %r10,%rdx
  800799:	48 89 c7             	mov    %rax,%rdi
  80079c:	48 b8 40 07 80 00 00 	movabs $0x800740,%rax
  8007a3:	00 00 00 
  8007a6:	ff d0                	callq  *%rax
  8007a8:	eb 1c                	jmp    8007c6 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007aa:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007ae:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8007b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007b5:	48 89 ce             	mov    %rcx,%rsi
  8007b8:	89 d7                	mov    %edx,%edi
  8007ba:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007bc:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8007c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8007c4:	7f e4                	jg     8007aa <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007c6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	48 f7 f1             	div    %rcx
  8007d5:	48 b8 b0 4d 80 00 00 	movabs $0x804db0,%rax
  8007dc:	00 00 00 
  8007df:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8007e3:	0f be d0             	movsbl %al,%edx
  8007e6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007ee:	48 89 ce             	mov    %rcx,%rsi
  8007f1:	89 d7                	mov    %edx,%edi
  8007f3:	ff d0                	callq  *%rax
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leaveq 
  8007f7:	c3                   	retq   

00000000008007f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f8:	55                   	push   %rbp
  8007f9:	48 89 e5             	mov    %rsp,%rbp
  8007fc:	48 83 ec 20          	sub    $0x20,%rsp
  800800:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800804:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800807:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80080b:	7e 4f                	jle    80085c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	8b 00                	mov    (%rax),%eax
  800813:	83 f8 30             	cmp    $0x30,%eax
  800816:	73 24                	jae    80083c <getuint+0x44>
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800824:	8b 00                	mov    (%rax),%eax
  800826:	89 c0                	mov    %eax,%eax
  800828:	48 01 d0             	add    %rdx,%rax
  80082b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082f:	8b 12                	mov    (%rdx),%edx
  800831:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800834:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800838:	89 0a                	mov    %ecx,(%rdx)
  80083a:	eb 14                	jmp    800850 <getuint+0x58>
  80083c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800840:	48 8b 40 08          	mov    0x8(%rax),%rax
  800844:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800848:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800850:	48 8b 00             	mov    (%rax),%rax
  800853:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800857:	e9 9d 00 00 00       	jmpq   8008f9 <getuint+0x101>
	else if (lflag)
  80085c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800860:	74 4c                	je     8008ae <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800866:	8b 00                	mov    (%rax),%eax
  800868:	83 f8 30             	cmp    $0x30,%eax
  80086b:	73 24                	jae    800891 <getuint+0x99>
  80086d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800871:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	8b 00                	mov    (%rax),%eax
  80087b:	89 c0                	mov    %eax,%eax
  80087d:	48 01 d0             	add    %rdx,%rax
  800880:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800884:	8b 12                	mov    (%rdx),%edx
  800886:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800889:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088d:	89 0a                	mov    %ecx,(%rdx)
  80088f:	eb 14                	jmp    8008a5 <getuint+0xad>
  800891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800895:	48 8b 40 08          	mov    0x8(%rax),%rax
  800899:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80089d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a5:	48 8b 00             	mov    (%rax),%rax
  8008a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ac:	eb 4b                	jmp    8008f9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	83 f8 30             	cmp    $0x30,%eax
  8008b7:	73 24                	jae    8008dd <getuint+0xe5>
  8008b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c5:	8b 00                	mov    (%rax),%eax
  8008c7:	89 c0                	mov    %eax,%eax
  8008c9:	48 01 d0             	add    %rdx,%rax
  8008cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d0:	8b 12                	mov    (%rdx),%edx
  8008d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d9:	89 0a                	mov    %ecx,(%rdx)
  8008db:	eb 14                	jmp    8008f1 <getuint+0xf9>
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008e5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f1:	8b 00                	mov    (%rax),%eax
  8008f3:	89 c0                	mov    %eax,%eax
  8008f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008fd:	c9                   	leaveq 
  8008fe:	c3                   	retq   

00000000008008ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ff:	55                   	push   %rbp
  800900:	48 89 e5             	mov    %rsp,%rbp
  800903:	48 83 ec 20          	sub    $0x20,%rsp
  800907:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80090b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80090e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800912:	7e 4f                	jle    800963 <getint+0x64>
		x=va_arg(*ap, long long);
  800914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800918:	8b 00                	mov    (%rax),%eax
  80091a:	83 f8 30             	cmp    $0x30,%eax
  80091d:	73 24                	jae    800943 <getint+0x44>
  80091f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800923:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	8b 00                	mov    (%rax),%eax
  80092d:	89 c0                	mov    %eax,%eax
  80092f:	48 01 d0             	add    %rdx,%rax
  800932:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800936:	8b 12                	mov    (%rdx),%edx
  800938:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093f:	89 0a                	mov    %ecx,(%rdx)
  800941:	eb 14                	jmp    800957 <getint+0x58>
  800943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800947:	48 8b 40 08          	mov    0x8(%rax),%rax
  80094b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800957:	48 8b 00             	mov    (%rax),%rax
  80095a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80095e:	e9 9d 00 00 00       	jmpq   800a00 <getint+0x101>
	else if (lflag)
  800963:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800967:	74 4c                	je     8009b5 <getint+0xb6>
		x=va_arg(*ap, long);
  800969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096d:	8b 00                	mov    (%rax),%eax
  80096f:	83 f8 30             	cmp    $0x30,%eax
  800972:	73 24                	jae    800998 <getint+0x99>
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	8b 00                	mov    (%rax),%eax
  800982:	89 c0                	mov    %eax,%eax
  800984:	48 01 d0             	add    %rdx,%rax
  800987:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098b:	8b 12                	mov    (%rdx),%edx
  80098d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800990:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800994:	89 0a                	mov    %ecx,(%rdx)
  800996:	eb 14                	jmp    8009ac <getint+0xad>
  800998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009a0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ac:	48 8b 00             	mov    (%rax),%rax
  8009af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b3:	eb 4b                	jmp    800a00 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	83 f8 30             	cmp    $0x30,%eax
  8009be:	73 24                	jae    8009e4 <getint+0xe5>
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d7:	8b 12                	mov    (%rdx),%edx
  8009d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e0:	89 0a                	mov    %ecx,(%rdx)
  8009e2:	eb 14                	jmp    8009f8 <getint+0xf9>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009ec:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f8:	8b 00                	mov    (%rax),%eax
  8009fa:	48 98                	cltq   
  8009fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a04:	c9                   	leaveq 
  800a05:	c3                   	retq   

0000000000800a06 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a06:	55                   	push   %rbp
  800a07:	48 89 e5             	mov    %rsp,%rbp
  800a0a:	41 54                	push   %r12
  800a0c:	53                   	push   %rbx
  800a0d:	48 83 ec 60          	sub    $0x60,%rsp
  800a11:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a15:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a19:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a1d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a25:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a29:	48 8b 0a             	mov    (%rdx),%rcx
  800a2c:	48 89 08             	mov    %rcx,(%rax)
  800a2f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a33:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a37:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a3b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3f:	eb 17                	jmp    800a58 <vprintfmt+0x52>
			if (ch == '\0')
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	0f 84 b9 04 00 00    	je     800f02 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800a49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	89 df                	mov    %ebx,%edi
  800a56:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a58:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a5c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a60:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a64:	0f b6 00             	movzbl (%rax),%eax
  800a67:	0f b6 d8             	movzbl %al,%ebx
  800a6a:	83 fb 25             	cmp    $0x25,%ebx
  800a6d:	75 d2                	jne    800a41 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a6f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a73:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a7a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a81:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a88:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a8f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a93:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a97:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a9b:	0f b6 00             	movzbl (%rax),%eax
  800a9e:	0f b6 d8             	movzbl %al,%ebx
  800aa1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800aa4:	83 f8 55             	cmp    $0x55,%eax
  800aa7:	0f 87 22 04 00 00    	ja     800ecf <vprintfmt+0x4c9>
  800aad:	89 c0                	mov    %eax,%eax
  800aaf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ab6:	00 
  800ab7:	48 b8 d8 4d 80 00 00 	movabs $0x804dd8,%rax
  800abe:	00 00 00 
  800ac1:	48 01 d0             	add    %rdx,%rax
  800ac4:	48 8b 00             	mov    (%rax),%rax
  800ac7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ac9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800acd:	eb c0                	jmp    800a8f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800acf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ad3:	eb ba                	jmp    800a8f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800adc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800adf:	89 d0                	mov    %edx,%eax
  800ae1:	c1 e0 02             	shl    $0x2,%eax
  800ae4:	01 d0                	add    %edx,%eax
  800ae6:	01 c0                	add    %eax,%eax
  800ae8:	01 d8                	add    %ebx,%eax
  800aea:	83 e8 30             	sub    $0x30,%eax
  800aed:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800af0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af4:	0f b6 00             	movzbl (%rax),%eax
  800af7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800afa:	83 fb 2f             	cmp    $0x2f,%ebx
  800afd:	7e 60                	jle    800b5f <vprintfmt+0x159>
  800aff:	83 fb 39             	cmp    $0x39,%ebx
  800b02:	7f 5b                	jg     800b5f <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b04:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b09:	eb d1                	jmp    800adc <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0e:	83 f8 30             	cmp    $0x30,%eax
  800b11:	73 17                	jae    800b2a <vprintfmt+0x124>
  800b13:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1a:	89 d2                	mov    %edx,%edx
  800b1c:	48 01 d0             	add    %rdx,%rax
  800b1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b22:	83 c2 08             	add    $0x8,%edx
  800b25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b28:	eb 0c                	jmp    800b36 <vprintfmt+0x130>
  800b2a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b2e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b36:	8b 00                	mov    (%rax),%eax
  800b38:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b3b:	eb 23                	jmp    800b60 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800b3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b41:	0f 89 48 ff ff ff    	jns    800a8f <vprintfmt+0x89>
				width = 0;
  800b47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b4e:	e9 3c ff ff ff       	jmpq   800a8f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b53:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b5a:	e9 30 ff ff ff       	jmpq   800a8f <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b64:	0f 89 25 ff ff ff    	jns    800a8f <vprintfmt+0x89>
				width = precision, precision = -1;
  800b6a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b6d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b77:	e9 13 ff ff ff       	jmpq   800a8f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b7c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b80:	e9 0a ff ff ff       	jmpq   800a8f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b88:	83 f8 30             	cmp    $0x30,%eax
  800b8b:	73 17                	jae    800ba4 <vprintfmt+0x19e>
  800b8d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b94:	89 d2                	mov    %edx,%edx
  800b96:	48 01 d0             	add    %rdx,%rax
  800b99:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9c:	83 c2 08             	add    $0x8,%edx
  800b9f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ba2:	eb 0c                	jmp    800bb0 <vprintfmt+0x1aa>
  800ba4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ba8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb0:	8b 10                	mov    (%rax),%edx
  800bb2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	48 89 ce             	mov    %rcx,%rsi
  800bbd:	89 d7                	mov    %edx,%edi
  800bbf:	ff d0                	callq  *%rax
			break;
  800bc1:	e9 37 03 00 00       	jmpq   800efd <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc9:	83 f8 30             	cmp    $0x30,%eax
  800bcc:	73 17                	jae    800be5 <vprintfmt+0x1df>
  800bce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bd2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd5:	89 d2                	mov    %edx,%edx
  800bd7:	48 01 d0             	add    %rdx,%rax
  800bda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdd:	83 c2 08             	add    $0x8,%edx
  800be0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be3:	eb 0c                	jmp    800bf1 <vprintfmt+0x1eb>
  800be5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800be9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf3:	85 db                	test   %ebx,%ebx
  800bf5:	79 02                	jns    800bf9 <vprintfmt+0x1f3>
				err = -err;
  800bf7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf9:	83 fb 15             	cmp    $0x15,%ebx
  800bfc:	7f 16                	jg     800c14 <vprintfmt+0x20e>
  800bfe:	48 b8 00 4d 80 00 00 	movabs $0x804d00,%rax
  800c05:	00 00 00 
  800c08:	48 63 d3             	movslq %ebx,%rdx
  800c0b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c0f:	4d 85 e4             	test   %r12,%r12
  800c12:	75 2e                	jne    800c42 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800c14:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1c:	89 d9                	mov    %ebx,%ecx
  800c1e:	48 ba c1 4d 80 00 00 	movabs $0x804dc1,%rdx
  800c25:	00 00 00 
  800c28:	48 89 c7             	mov    %rax,%rdi
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	49 b8 0c 0f 80 00 00 	movabs $0x800f0c,%r8
  800c37:	00 00 00 
  800c3a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c3d:	e9 bb 02 00 00       	jmpq   800efd <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4a:	4c 89 e1             	mov    %r12,%rcx
  800c4d:	48 ba ca 4d 80 00 00 	movabs $0x804dca,%rdx
  800c54:	00 00 00 
  800c57:	48 89 c7             	mov    %rax,%rdi
  800c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5f:	49 b8 0c 0f 80 00 00 	movabs $0x800f0c,%r8
  800c66:	00 00 00 
  800c69:	41 ff d0             	callq  *%r8
			break;
  800c6c:	e9 8c 02 00 00       	jmpq   800efd <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c74:	83 f8 30             	cmp    $0x30,%eax
  800c77:	73 17                	jae    800c90 <vprintfmt+0x28a>
  800c79:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c80:	89 d2                	mov    %edx,%edx
  800c82:	48 01 d0             	add    %rdx,%rax
  800c85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c88:	83 c2 08             	add    $0x8,%edx
  800c8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c8e:	eb 0c                	jmp    800c9c <vprintfmt+0x296>
  800c90:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c94:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9c:	4c 8b 20             	mov    (%rax),%r12
  800c9f:	4d 85 e4             	test   %r12,%r12
  800ca2:	75 0a                	jne    800cae <vprintfmt+0x2a8>
				p = "(null)";
  800ca4:	49 bc cd 4d 80 00 00 	movabs $0x804dcd,%r12
  800cab:	00 00 00 
			if (width > 0 && padc != '-')
  800cae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb2:	7e 78                	jle    800d2c <vprintfmt+0x326>
  800cb4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb8:	74 72                	je     800d2c <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cbd:	48 98                	cltq   
  800cbf:	48 89 c6             	mov    %rax,%rsi
  800cc2:	4c 89 e7             	mov    %r12,%rdi
  800cc5:	48 b8 ba 11 80 00 00 	movabs $0x8011ba,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
  800cd1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd4:	eb 17                	jmp    800ced <vprintfmt+0x2e7>
					putch(padc, putdat);
  800cd6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cda:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce2:	48 89 ce             	mov    %rcx,%rsi
  800ce5:	89 d7                	mov    %edx,%edi
  800ce7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ced:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf1:	7f e3                	jg     800cd6 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf3:	eb 37                	jmp    800d2c <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cf9:	74 1e                	je     800d19 <vprintfmt+0x313>
  800cfb:	83 fb 1f             	cmp    $0x1f,%ebx
  800cfe:	7e 05                	jle    800d05 <vprintfmt+0x2ff>
  800d00:	83 fb 7e             	cmp    $0x7e,%ebx
  800d03:	7e 14                	jle    800d19 <vprintfmt+0x313>
					putch('?', putdat);
  800d05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0d:	48 89 d6             	mov    %rdx,%rsi
  800d10:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d15:	ff d0                	callq  *%rax
  800d17:	eb 0f                	jmp    800d28 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d2c:	4c 89 e0             	mov    %r12,%rax
  800d2f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d33:	0f b6 00             	movzbl (%rax),%eax
  800d36:	0f be d8             	movsbl %al,%ebx
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	74 28                	je     800d65 <vprintfmt+0x35f>
  800d3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d41:	78 b2                	js     800cf5 <vprintfmt+0x2ef>
  800d43:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4b:	79 a8                	jns    800cf5 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4d:	eb 16                	jmp    800d65 <vprintfmt+0x35f>
				putch(' ', putdat);
  800d4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d57:	48 89 d6             	mov    %rdx,%rsi
  800d5a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d5f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d61:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d69:	7f e4                	jg     800d4f <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800d6b:	e9 8d 01 00 00       	jmpq   800efd <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d74:	be 03 00 00 00       	mov    $0x3,%esi
  800d79:	48 89 c7             	mov    %rax,%rdi
  800d7c:	48 b8 ff 08 80 00 00 	movabs $0x8008ff,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	callq  *%rax
  800d88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d90:	48 85 c0             	test   %rax,%rax
  800d93:	79 1d                	jns    800db2 <vprintfmt+0x3ac>
				putch('-', putdat);
  800d95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9d:	48 89 d6             	mov    %rdx,%rsi
  800da0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dab:	48 f7 d8             	neg    %rax
  800dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db9:	e9 d2 00 00 00       	jmpq   800e90 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dbe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc2:	be 03 00 00 00       	mov    $0x3,%esi
  800dc7:	48 89 c7             	mov    %rax,%rdi
  800dca:	48 b8 f8 07 80 00 00 	movabs $0x8007f8,%rax
  800dd1:	00 00 00 
  800dd4:	ff d0                	callq  *%rax
  800dd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de1:	e9 aa 00 00 00       	jmpq   800e90 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800de6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dea:	be 03 00 00 00       	mov    $0x3,%esi
  800def:	48 89 c7             	mov    %rax,%rdi
  800df2:	48 b8 f8 07 80 00 00 	movabs $0x8007f8,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	callq  *%rax
  800dfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e02:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e09:	e9 82 00 00 00       	jmpq   800e90 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800e0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e16:	48 89 d6             	mov    %rdx,%rsi
  800e19:	bf 30 00 00 00       	mov    $0x30,%edi
  800e1e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e28:	48 89 d6             	mov    %rdx,%rsi
  800e2b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e30:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e35:	83 f8 30             	cmp    $0x30,%eax
  800e38:	73 17                	jae    800e51 <vprintfmt+0x44b>
  800e3a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e3e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e41:	89 d2                	mov    %edx,%edx
  800e43:	48 01 d0             	add    %rdx,%rax
  800e46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e49:	83 c2 08             	add    $0x8,%edx
  800e4c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4f:	eb 0c                	jmp    800e5d <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800e51:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e55:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e59:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e64:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e6b:	eb 23                	jmp    800e90 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e71:	be 03 00 00 00       	mov    $0x3,%esi
  800e76:	48 89 c7             	mov    %rax,%rdi
  800e79:	48 b8 f8 07 80 00 00 	movabs $0x8007f8,%rax
  800e80:	00 00 00 
  800e83:	ff d0                	callq  *%rax
  800e85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e89:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e90:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e95:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e98:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ea3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea7:	45 89 c1             	mov    %r8d,%r9d
  800eaa:	41 89 f8             	mov    %edi,%r8d
  800ead:	48 89 c7             	mov    %rax,%rdi
  800eb0:	48 b8 40 07 80 00 00 	movabs $0x800740,%rax
  800eb7:	00 00 00 
  800eba:	ff d0                	callq  *%rax
			break;
  800ebc:	eb 3f                	jmp    800efd <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ebe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec6:	48 89 d6             	mov    %rdx,%rsi
  800ec9:	89 df                	mov    %ebx,%edi
  800ecb:	ff d0                	callq  *%rax
			break;
  800ecd:	eb 2e                	jmp    800efd <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ecf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed7:	48 89 d6             	mov    %rdx,%rsi
  800eda:	bf 25 00 00 00       	mov    $0x25,%edi
  800edf:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee6:	eb 05                	jmp    800eed <vprintfmt+0x4e7>
  800ee8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eed:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef1:	48 83 e8 01          	sub    $0x1,%rax
  800ef5:	0f b6 00             	movzbl (%rax),%eax
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 ec                	jne    800ee8 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 3d fb ff ff       	jmpq   800a3f <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f03:	48 83 c4 60          	add    $0x60,%rsp
  800f07:	5b                   	pop    %rbx
  800f08:	41 5c                	pop    %r12
  800f0a:	5d                   	pop    %rbp
  800f0b:	c3                   	retq   

0000000000800f0c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0c:	55                   	push   %rbp
  800f0d:	48 89 e5             	mov    %rsp,%rbp
  800f10:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f17:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f1e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f25:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800f2c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f33:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f41:	84 c0                	test   %al,%al
  800f43:	74 20                	je     800f65 <printfmt+0x59>
  800f45:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f49:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f4d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f51:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f55:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f59:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f5d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f61:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f65:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f6c:	00 00 00 
  800f6f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f76:	00 00 00 
  800f79:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f7d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f84:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f92:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f99:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fa7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fae:	48 89 c7             	mov    %rax,%rdi
  800fb1:	48 b8 06 0a 80 00 00 	movabs $0x800a06,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fbd:	90                   	nop
  800fbe:	c9                   	leaveq 
  800fbf:	c3                   	retq   

0000000000800fc0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	48 83 ec 10          	sub    $0x10,%rsp
  800fc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd3:	8b 40 10             	mov    0x10(%rax),%eax
  800fd6:	8d 50 01             	lea    0x1(%rax),%edx
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe4:	48 8b 10             	mov    (%rax),%rdx
  800fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800feb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fef:	48 39 c2             	cmp    %rax,%rdx
  800ff2:	73 17                	jae    80100b <sprintputch+0x4b>
		*b->buf++ = ch;
  800ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff8:	48 8b 00             	mov    (%rax),%rax
  800ffb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801003:	48 89 0a             	mov    %rcx,(%rdx)
  801006:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801009:	88 10                	mov    %dl,(%rax)
}
  80100b:	90                   	nop
  80100c:	c9                   	leaveq 
  80100d:	c3                   	retq   

000000000080100e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 83 ec 50          	sub    $0x50,%rsp
  801016:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80101a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80101d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801021:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801025:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801029:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80102d:	48 8b 0a             	mov    (%rdx),%rcx
  801030:	48 89 08             	mov    %rcx,(%rax)
  801033:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801037:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80103b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801043:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801047:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80104b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80104e:	48 98                	cltq   
  801050:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801054:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801058:	48 01 d0             	add    %rdx,%rax
  80105b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80105f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801066:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80106b:	74 06                	je     801073 <vsnprintf+0x65>
  80106d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801071:	7f 07                	jg     80107a <vsnprintf+0x6c>
		return -E_INVAL;
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801078:	eb 2f                	jmp    8010a9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80107a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80107e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801082:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801086:	48 89 c6             	mov    %rax,%rsi
  801089:	48 bf c0 0f 80 00 00 	movabs $0x800fc0,%rdi
  801090:	00 00 00 
  801093:	48 b8 06 0a 80 00 00 	movabs $0x800a06,%rax
  80109a:	00 00 00 
  80109d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80109f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010a6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010bd:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010c3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8010ca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010d1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 20                	je     801103 <snprintf+0x58>
  8010e3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010e7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010eb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010ef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010f3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010f7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010fb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010ff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801103:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80110a:	00 00 00 
  80110d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801114:	00 00 00 
  801117:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80111b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801122:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801129:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801130:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801137:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80113e:	48 8b 0a             	mov    (%rdx),%rcx
  801141:	48 89 08             	mov    %rcx,(%rax)
  801144:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801148:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801150:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801154:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80115b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801162:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801168:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80116f:	48 89 c7             	mov    %rax,%rdi
  801172:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  801179:	00 00 00 
  80117c:	ff d0                	callq  *%rax
  80117e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801184:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80118a:	c9                   	leaveq 
  80118b:	c3                   	retq   

000000000080118c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80118c:	55                   	push   %rbp
  80118d:	48 89 e5             	mov    %rsp,%rbp
  801190:	48 83 ec 18          	sub    $0x18,%rsp
  801194:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801198:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80119f:	eb 09                	jmp    8011aa <strlen+0x1e>
		n++;
  8011a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	75 ec                	jne    8011a1 <strlen+0x15>
		n++;
	return n;
  8011b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 20          	sub    $0x20,%rsp
  8011c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d1:	eb 0e                	jmp    8011e1 <strnlen+0x27>
		n++;
  8011d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011dc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011e6:	74 0b                	je     8011f3 <strnlen+0x39>
  8011e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	84 c0                	test   %al,%al
  8011f1:	75 e0                	jne    8011d3 <strnlen+0x19>
		n++;
	return n;
  8011f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011f6:	c9                   	leaveq 
  8011f7:	c3                   	retq   

00000000008011f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f8:	55                   	push   %rbp
  8011f9:	48 89 e5             	mov    %rsp,%rbp
  8011fc:	48 83 ec 20          	sub    $0x20,%rsp
  801200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801204:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801210:	90                   	nop
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801219:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80121d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801221:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801225:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801229:	0f b6 12             	movzbl (%rdx),%edx
  80122c:	88 10                	mov    %dl,(%rax)
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	75 dc                	jne    801211 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801239:	c9                   	leaveq 
  80123a:	c3                   	retq   

000000000080123b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80123b:	55                   	push   %rbp
  80123c:	48 89 e5             	mov    %rsp,%rbp
  80123f:	48 83 ec 20          	sub    $0x20,%rsp
  801243:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801247:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80124b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124f:	48 89 c7             	mov    %rax,%rdi
  801252:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  801259:	00 00 00 
  80125c:	ff d0                	callq  *%rax
  80125e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801264:	48 63 d0             	movslq %eax,%rdx
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126b:	48 01 c2             	add    %rax,%rdx
  80126e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801272:	48 89 c6             	mov    %rax,%rsi
  801275:	48 89 d7             	mov    %rdx,%rdi
  801278:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  80127f:	00 00 00 
  801282:	ff d0                	callq  *%rax
	return dst;
  801284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   

000000000080128a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80128a:	55                   	push   %rbp
  80128b:	48 89 e5             	mov    %rsp,%rbp
  80128e:	48 83 ec 28          	sub    $0x28,%rsp
  801292:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801296:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012a6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012ad:	00 
  8012ae:	eb 2a                	jmp    8012da <strncpy+0x50>
		*dst++ = *src;
  8012b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012c0:	0f b6 12             	movzbl (%rdx),%edx
  8012c3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 05                	je     8012d5 <strncpy+0x4b>
			src++;
  8012d0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012e2:	72 cc                	jb     8012b0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	48 83 ec 28          	sub    $0x28,%rsp
  8012f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801306:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130b:	74 3d                	je     80134a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80130d:	eb 1d                	jmp    80132c <strlcpy+0x42>
			*dst++ = *src++;
  80130f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801313:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801317:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80131f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801323:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801327:	0f b6 12             	movzbl (%rdx),%edx
  80132a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801331:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801336:	74 0b                	je     801343 <strlcpy+0x59>
  801338:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133c:	0f b6 00             	movzbl (%rax),%eax
  80133f:	84 c0                	test   %al,%al
  801341:	75 cc                	jne    80130f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80134a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	48 29 c2             	sub    %rax,%rdx
  801355:	48 89 d0             	mov    %rdx,%rax
}
  801358:	c9                   	leaveq 
  801359:	c3                   	retq   

000000000080135a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80135a:	55                   	push   %rbp
  80135b:	48 89 e5             	mov    %rsp,%rbp
  80135e:	48 83 ec 10          	sub    $0x10,%rsp
  801362:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801366:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80136a:	eb 0a                	jmp    801376 <strcmp+0x1c>
		p++, q++;
  80136c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801371:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	84 c0                	test   %al,%al
  80137f:	74 12                	je     801393 <strcmp+0x39>
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801385:	0f b6 10             	movzbl (%rax),%edx
  801388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138c:	0f b6 00             	movzbl (%rax),%eax
  80138f:	38 c2                	cmp    %al,%dl
  801391:	74 d9                	je     80136c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801397:	0f b6 00             	movzbl (%rax),%eax
  80139a:	0f b6 d0             	movzbl %al,%edx
  80139d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	0f b6 c0             	movzbl %al,%eax
  8013a7:	29 c2                	sub    %eax,%edx
  8013a9:	89 d0                	mov    %edx,%eax
}
  8013ab:	c9                   	leaveq 
  8013ac:	c3                   	retq   

00000000008013ad <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ad:	55                   	push   %rbp
  8013ae:	48 89 e5             	mov    %rsp,%rbp
  8013b1:	48 83 ec 18          	sub    $0x18,%rsp
  8013b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013c1:	eb 0f                	jmp    8013d2 <strncmp+0x25>
		n--, p++, q++;
  8013c3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d7:	74 1d                	je     8013f6 <strncmp+0x49>
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 12                	je     8013f6 <strncmp+0x49>
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e8:	0f b6 10             	movzbl (%rax),%edx
  8013eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ef:	0f b6 00             	movzbl (%rax),%eax
  8013f2:	38 c2                	cmp    %al,%dl
  8013f4:	74 cd                	je     8013c3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013fb:	75 07                	jne    801404 <strncmp+0x57>
		return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb 18                	jmp    80141c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801408:	0f b6 00             	movzbl (%rax),%eax
  80140b:	0f b6 d0             	movzbl %al,%edx
  80140e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801412:	0f b6 00             	movzbl (%rax),%eax
  801415:	0f b6 c0             	movzbl %al,%eax
  801418:	29 c2                	sub    %eax,%edx
  80141a:	89 d0                	mov    %edx,%eax
}
  80141c:	c9                   	leaveq 
  80141d:	c3                   	retq   

000000000080141e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80141e:	55                   	push   %rbp
  80141f:	48 89 e5             	mov    %rsp,%rbp
  801422:	48 83 ec 10          	sub    $0x10,%rsp
  801426:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142a:	89 f0                	mov    %esi,%eax
  80142c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80142f:	eb 17                	jmp    801448 <strchr+0x2a>
		if (*s == c)
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80143b:	75 06                	jne    801443 <strchr+0x25>
			return (char *) s;
  80143d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801441:	eb 15                	jmp    801458 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801443:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	84 c0                	test   %al,%al
  801451:	75 de                	jne    801431 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801458:	c9                   	leaveq 
  801459:	c3                   	retq   

000000000080145a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	48 83 ec 10          	sub    $0x10,%rsp
  801462:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801466:	89 f0                	mov    %esi,%eax
  801468:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80146b:	eb 11                	jmp    80147e <strfind+0x24>
		if (*s == c)
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801477:	74 12                	je     80148b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801479:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	84 c0                	test   %al,%al
  801487:	75 e4                	jne    80146d <strfind+0x13>
  801489:	eb 01                	jmp    80148c <strfind+0x32>
		if (*s == c)
			break;
  80148b:	90                   	nop
	return (char *) s;
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801490:	c9                   	leaveq 
  801491:	c3                   	retq   

0000000000801492 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801492:	55                   	push   %rbp
  801493:	48 89 e5             	mov    %rsp,%rbp
  801496:	48 83 ec 18          	sub    $0x18,%rsp
  80149a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014aa:	75 06                	jne    8014b2 <memset+0x20>
		return v;
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	eb 69                	jmp    80151b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	83 e0 03             	and    $0x3,%eax
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	75 48                	jne    801506 <memset+0x74>
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c2:	83 e0 03             	and    $0x3,%eax
  8014c5:	48 85 c0             	test   %rax,%rax
  8014c8:	75 3c                	jne    801506 <memset+0x74>
		c &= 0xFF;
  8014ca:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d4:	c1 e0 18             	shl    $0x18,%eax
  8014d7:	89 c2                	mov    %eax,%edx
  8014d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dc:	c1 e0 10             	shl    $0x10,%eax
  8014df:	09 c2                	or     %eax,%edx
  8014e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e4:	c1 e0 08             	shl    $0x8,%eax
  8014e7:	09 d0                	or     %edx,%eax
  8014e9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f0:	48 c1 e8 02          	shr    $0x2,%rax
  8014f4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fe:	48 89 d7             	mov    %rdx,%rdi
  801501:	fc                   	cld    
  801502:	f3 ab                	rep stos %eax,%es:(%rdi)
  801504:	eb 11                	jmp    801517 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801506:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801511:	48 89 d7             	mov    %rdx,%rdi
  801514:	fc                   	cld    
  801515:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80151b:	c9                   	leaveq 
  80151c:	c3                   	retq   

000000000080151d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80151d:	55                   	push   %rbp
  80151e:	48 89 e5             	mov    %rsp,%rbp
  801521:	48 83 ec 28          	sub    $0x28,%rsp
  801525:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801549:	0f 83 88 00 00 00    	jae    8015d7 <memmove+0xba>
  80154f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	48 01 d0             	add    %rdx,%rax
  80155a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155e:	76 77                	jbe    8015d7 <memmove+0xba>
		s += n;
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	83 e0 03             	and    $0x3,%eax
  801577:	48 85 c0             	test   %rax,%rax
  80157a:	75 3b                	jne    8015b7 <memmove+0x9a>
  80157c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801580:	83 e0 03             	and    $0x3,%eax
  801583:	48 85 c0             	test   %rax,%rax
  801586:	75 2f                	jne    8015b7 <memmove+0x9a>
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	83 e0 03             	and    $0x3,%eax
  80158f:	48 85 c0             	test   %rax,%rax
  801592:	75 23                	jne    8015b7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	48 83 e8 04          	sub    $0x4,%rax
  80159c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a0:	48 83 ea 04          	sub    $0x4,%rdx
  8015a4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ac:	48 89 c7             	mov    %rax,%rdi
  8015af:	48 89 d6             	mov    %rdx,%rsi
  8015b2:	fd                   	std    
  8015b3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b5:	eb 1d                	jmp    8015d4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	48 89 d7             	mov    %rdx,%rdi
  8015ce:	48 89 c1             	mov    %rax,%rcx
  8015d1:	fd                   	std    
  8015d2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015d4:	fc                   	cld    
  8015d5:	eb 57                	jmp    80162e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015db:	83 e0 03             	and    $0x3,%eax
  8015de:	48 85 c0             	test   %rax,%rax
  8015e1:	75 36                	jne    801619 <memmove+0xfc>
  8015e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e7:	83 e0 03             	and    $0x3,%eax
  8015ea:	48 85 c0             	test   %rax,%rax
  8015ed:	75 2a                	jne    801619 <memmove+0xfc>
  8015ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f3:	83 e0 03             	and    $0x3,%eax
  8015f6:	48 85 c0             	test   %rax,%rax
  8015f9:	75 1e                	jne    801619 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	48 c1 e8 02          	shr    $0x2,%rax
  801603:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	48 89 c7             	mov    %rax,%rdi
  801611:	48 89 d6             	mov    %rdx,%rsi
  801614:	fc                   	cld    
  801615:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801617:	eb 15                	jmp    80162e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801621:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 89 d6             	mov    %rdx,%rsi
  80162b:	fc                   	cld    
  80162c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80162e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801632:	c9                   	leaveq 
  801633:	c3                   	retq   

0000000000801634 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801634:	55                   	push   %rbp
  801635:	48 89 e5             	mov    %rsp,%rbp
  801638:	48 83 ec 18          	sub    $0x18,%rsp
  80163c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801640:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801644:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801648:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	48 89 ce             	mov    %rcx,%rsi
  801657:	48 89 c7             	mov    %rax,%rdi
  80165a:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  801661:	00 00 00 
  801664:	ff d0                	callq  *%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 28          	sub    $0x28,%rsp
  801670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801678:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801684:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801688:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80168c:	eb 36                	jmp    8016c4 <memcmp+0x5c>
		if (*s1 != *s2)
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	0f b6 10             	movzbl (%rax),%edx
  801695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	38 c2                	cmp    %al,%dl
  80169e:	74 1a                	je     8016ba <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	0f b6 d0             	movzbl %al,%edx
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	eb 20                	jmp    8016da <memcmp+0x72>
		s1++, s2++;
  8016ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016d0:	48 85 c0             	test   %rax,%rax
  8016d3:	75 b9                	jne    80168e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	48 83 ec 28          	sub    $0x28,%rsp
  8016e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	48 01 d0             	add    %rdx,%rax
  8016fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016fe:	eb 19                	jmp    801719 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801704:	0f b6 00             	movzbl (%rax),%eax
  801707:	0f b6 d0             	movzbl %al,%edx
  80170a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80170d:	0f b6 c0             	movzbl %al,%eax
  801710:	39 c2                	cmp    %eax,%edx
  801712:	74 11                	je     801725 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801714:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801721:	72 dd                	jb     801700 <memfind+0x24>
  801723:	eb 01                	jmp    801726 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801725:	90                   	nop
	return (void *) s;
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80172a:	c9                   	leaveq 
  80172b:	c3                   	retq   

000000000080172c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 38          	sub    $0x38,%rsp
  801734:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801738:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80173c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801746:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80174d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174e:	eb 05                	jmp    801755 <strtol+0x29>
		s++;
  801750:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	3c 20                	cmp    $0x20,%al
  80175e:	74 f0                	je     801750 <strtol+0x24>
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 09                	cmp    $0x9,%al
  801769:	74 e5                	je     801750 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 2b                	cmp    $0x2b,%al
  801774:	75 07                	jne    80177d <strtol+0x51>
		s++;
  801776:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80177b:	eb 17                	jmp    801794 <strtol+0x68>
	else if (*s == '-')
  80177d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801781:	0f b6 00             	movzbl (%rax),%eax
  801784:	3c 2d                	cmp    $0x2d,%al
  801786:	75 0c                	jne    801794 <strtol+0x68>
		s++, neg = 1;
  801788:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801794:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801798:	74 06                	je     8017a0 <strtol+0x74>
  80179a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80179e:	75 28                	jne    8017c8 <strtol+0x9c>
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	0f b6 00             	movzbl (%rax),%eax
  8017a7:	3c 30                	cmp    $0x30,%al
  8017a9:	75 1d                	jne    8017c8 <strtol+0x9c>
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	48 83 c0 01          	add    $0x1,%rax
  8017b3:	0f b6 00             	movzbl (%rax),%eax
  8017b6:	3c 78                	cmp    $0x78,%al
  8017b8:	75 0e                	jne    8017c8 <strtol+0x9c>
		s += 2, base = 16;
  8017ba:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017bf:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017c6:	eb 2c                	jmp    8017f4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017cc:	75 19                	jne    8017e7 <strtol+0xbb>
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	3c 30                	cmp    $0x30,%al
  8017d7:	75 0e                	jne    8017e7 <strtol+0xbb>
		s++, base = 8;
  8017d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017de:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017e5:	eb 0d                	jmp    8017f4 <strtol+0xc8>
	else if (base == 0)
  8017e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017eb:	75 07                	jne    8017f4 <strtol+0xc8>
		base = 10;
  8017ed:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	3c 2f                	cmp    $0x2f,%al
  8017fd:	7e 1d                	jle    80181c <strtol+0xf0>
  8017ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	3c 39                	cmp    $0x39,%al
  801808:	7f 12                	jg     80181c <strtol+0xf0>
			dig = *s - '0';
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	0f be c0             	movsbl %al,%eax
  801814:	83 e8 30             	sub    $0x30,%eax
  801817:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80181a:	eb 4e                	jmp    80186a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	0f b6 00             	movzbl (%rax),%eax
  801823:	3c 60                	cmp    $0x60,%al
  801825:	7e 1d                	jle    801844 <strtol+0x118>
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	3c 7a                	cmp    $0x7a,%al
  801830:	7f 12                	jg     801844 <strtol+0x118>
			dig = *s - 'a' + 10;
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	0f b6 00             	movzbl (%rax),%eax
  801839:	0f be c0             	movsbl %al,%eax
  80183c:	83 e8 57             	sub    $0x57,%eax
  80183f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801842:	eb 26                	jmp    80186a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801848:	0f b6 00             	movzbl (%rax),%eax
  80184b:	3c 40                	cmp    $0x40,%al
  80184d:	7e 47                	jle    801896 <strtol+0x16a>
  80184f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801853:	0f b6 00             	movzbl (%rax),%eax
  801856:	3c 5a                	cmp    $0x5a,%al
  801858:	7f 3c                	jg     801896 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	0f be c0             	movsbl %al,%eax
  801864:	83 e8 37             	sub    $0x37,%eax
  801867:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80186a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80186d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801870:	7d 23                	jge    801895 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801872:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801877:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80187a:	48 98                	cltq   
  80187c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801881:	48 89 c2             	mov    %rax,%rdx
  801884:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 01 d0             	add    %rdx,%rax
  80188c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801890:	e9 5f ff ff ff       	jmpq   8017f4 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801895:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801896:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80189b:	74 0b                	je     8018a8 <strtol+0x17c>
		*endptr = (char *) s;
  80189d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018a5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018ac:	74 09                	je     8018b7 <strtol+0x18b>
  8018ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b2:	48 f7 d8             	neg    %rax
  8018b5:	eb 04                	jmp    8018bb <strtol+0x18f>
  8018b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018bb:	c9                   	leaveq 
  8018bc:	c3                   	retq   

00000000008018bd <strstr>:

char * strstr(const char *in, const char *str)
{
  8018bd:	55                   	push   %rbp
  8018be:	48 89 e5             	mov    %rsp,%rbp
  8018c1:	48 83 ec 30          	sub    $0x30,%rsp
  8018c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018d5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d9:	0f b6 00             	movzbl (%rax),%eax
  8018dc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018df:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018e3:	75 06                	jne    8018eb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	eb 6b                	jmp    801956 <strstr+0x99>

	len = strlen(str);
  8018eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ef:	48 89 c7             	mov    %rax,%rdi
  8018f2:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  8018f9:	00 00 00 
  8018fc:	ff d0                	callq  *%rax
  8018fe:	48 98                	cltq   
  801900:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801908:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80190c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801910:	0f b6 00             	movzbl (%rax),%eax
  801913:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801916:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80191a:	75 07                	jne    801923 <strstr+0x66>
				return (char *) 0;
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	eb 33                	jmp    801956 <strstr+0x99>
		} while (sc != c);
  801923:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801927:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80192a:	75 d8                	jne    801904 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80192c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801930:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	48 89 ce             	mov    %rcx,%rsi
  80193b:	48 89 c7             	mov    %rax,%rdi
  80193e:	48 b8 ad 13 80 00 00 	movabs $0x8013ad,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
  80194a:	85 c0                	test   %eax,%eax
  80194c:	75 b6                	jne    801904 <strstr+0x47>

	return (char *) (in - 1);
  80194e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801952:	48 83 e8 01          	sub    $0x1,%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	53                   	push   %rbx
  80195d:	48 83 ec 48          	sub    $0x48,%rsp
  801961:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801964:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801967:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80196b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80196f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801973:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801977:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80197a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80197e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801982:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801986:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80198a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80198e:	4c 89 c3             	mov    %r8,%rbx
  801991:	cd 30                	int    $0x30
  801993:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801997:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80199b:	74 3e                	je     8019db <syscall+0x83>
  80199d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019a2:	7e 37                	jle    8019db <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019ab:	49 89 d0             	mov    %rdx,%r8
  8019ae:	89 c1                	mov    %eax,%ecx
  8019b0:	48 ba 88 50 80 00 00 	movabs $0x805088,%rdx
  8019b7:	00 00 00 
  8019ba:	be 24 00 00 00       	mov    $0x24,%esi
  8019bf:	48 bf a5 50 80 00 00 	movabs $0x8050a5,%rdi
  8019c6:	00 00 00 
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ce:	49 b9 2e 04 80 00 00 	movabs $0x80042e,%r9
  8019d5:	00 00 00 
  8019d8:	41 ff d1             	callq  *%r9

	return ret;
  8019db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019df:	48 83 c4 48          	add    $0x48,%rsp
  8019e3:	5b                   	pop    %rbx
  8019e4:	5d                   	pop    %rbp
  8019e5:	c3                   	retq   

00000000008019e6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 10          	sub    $0x10,%rsp
  8019ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fe:	48 83 ec 08          	sub    $0x8,%rsp
  801a02:	6a 00                	pushq  $0x0
  801a04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a10:	48 89 d1             	mov    %rdx,%rcx
  801a13:	48 89 c2             	mov    %rax,%rdx
  801a16:	be 00 00 00 00       	mov    $0x0,%esi
  801a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a20:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
  801a2c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a30:	90                   	nop
  801a31:	c9                   	leaveq 
  801a32:	c3                   	retq   

0000000000801a33 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a33:	55                   	push   %rbp
  801a34:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a37:	48 83 ec 08          	sub    $0x8,%rsp
  801a3b:	6a 00                	pushq  $0x0
  801a3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a53:	be 00 00 00 00       	mov    $0x0,%esi
  801a58:	bf 01 00 00 00       	mov    $0x1,%edi
  801a5d:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801a64:	00 00 00 
  801a67:	ff d0                	callq  *%rax
  801a69:	48 83 c4 10          	add    $0x10,%rsp
}
  801a6d:	c9                   	leaveq 
  801a6e:	c3                   	retq   

0000000000801a6f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a6f:	55                   	push   %rbp
  801a70:	48 89 e5             	mov    %rsp,%rbp
  801a73:	48 83 ec 10          	sub    $0x10,%rsp
  801a77:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7d:	48 98                	cltq   
  801a7f:	48 83 ec 08          	sub    $0x8,%rsp
  801a83:	6a 00                	pushq  $0x0
  801a85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a91:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a96:	48 89 c2             	mov    %rax,%rdx
  801a99:	be 01 00 00 00       	mov    $0x1,%esi
  801a9e:	bf 03 00 00 00       	mov    $0x3,%edi
  801aa3:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801aaa:	00 00 00 
  801aad:	ff d0                	callq  *%rax
  801aaf:	48 83 c4 10          	add    $0x10,%rsp
}
  801ab3:	c9                   	leaveq 
  801ab4:	c3                   	retq   

0000000000801ab5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ab5:	55                   	push   %rbp
  801ab6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ab9:	48 83 ec 08          	sub    $0x8,%rsp
  801abd:	6a 00                	pushq  $0x0
  801abf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801acb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad5:	be 00 00 00 00       	mov    $0x0,%esi
  801ada:	bf 02 00 00 00       	mov    $0x2,%edi
  801adf:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801ae6:	00 00 00 
  801ae9:	ff d0                	callq  *%rax
  801aeb:	48 83 c4 10          	add    $0x10,%rsp
}
  801aef:	c9                   	leaveq 
  801af0:	c3                   	retq   

0000000000801af1 <sys_yield>:


void
sys_yield(void)
{
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801af5:	48 83 ec 08          	sub    $0x8,%rsp
  801af9:	6a 00                	pushq  $0x0
  801afb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b11:	be 00 00 00 00       	mov    $0x0,%esi
  801b16:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b1b:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801b22:	00 00 00 
  801b25:	ff d0                	callq  *%rax
  801b27:	48 83 c4 10          	add    $0x10,%rsp
}
  801b2b:	90                   	nop
  801b2c:	c9                   	leaveq 
  801b2d:	c3                   	retq   

0000000000801b2e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b2e:	55                   	push   %rbp
  801b2f:	48 89 e5             	mov    %rsp,%rbp
  801b32:	48 83 ec 10          	sub    $0x10,%rsp
  801b36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b3d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b43:	48 63 c8             	movslq %eax,%rcx
  801b46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4d:	48 98                	cltq   
  801b4f:	48 83 ec 08          	sub    $0x8,%rsp
  801b53:	6a 00                	pushq  $0x0
  801b55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5b:	49 89 c8             	mov    %rcx,%r8
  801b5e:	48 89 d1             	mov    %rdx,%rcx
  801b61:	48 89 c2             	mov    %rax,%rdx
  801b64:	be 01 00 00 00       	mov    $0x1,%esi
  801b69:	bf 04 00 00 00       	mov    $0x4,%edi
  801b6e:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801b75:	00 00 00 
  801b78:	ff d0                	callq  *%rax
  801b7a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b7e:	c9                   	leaveq 
  801b7f:	c3                   	retq   

0000000000801b80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b80:	55                   	push   %rbp
  801b81:	48 89 e5             	mov    %rsp,%rbp
  801b84:	48 83 ec 20          	sub    $0x20,%rsp
  801b88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b8f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b92:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b96:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b9a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b9d:	48 63 c8             	movslq %eax,%rcx
  801ba0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ba4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba7:	48 63 f0             	movslq %eax,%rsi
  801baa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb1:	48 98                	cltq   
  801bb3:	48 83 ec 08          	sub    $0x8,%rsp
  801bb7:	51                   	push   %rcx
  801bb8:	49 89 f9             	mov    %rdi,%r9
  801bbb:	49 89 f0             	mov    %rsi,%r8
  801bbe:	48 89 d1             	mov    %rdx,%rcx
  801bc1:	48 89 c2             	mov    %rax,%rdx
  801bc4:	be 01 00 00 00       	mov    $0x1,%esi
  801bc9:	bf 05 00 00 00       	mov    $0x5,%edi
  801bce:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801bd5:	00 00 00 
  801bd8:	ff d0                	callq  *%rax
  801bda:	48 83 c4 10          	add    $0x10,%rsp
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 10          	sub    $0x10,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf6:	48 98                	cltq   
  801bf8:	48 83 ec 08          	sub    $0x8,%rsp
  801bfc:	6a 00                	pushq  $0x0
  801bfe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0a:	48 89 d1             	mov    %rdx,%rcx
  801c0d:	48 89 c2             	mov    %rax,%rdx
  801c10:	be 01 00 00 00       	mov    $0x1,%esi
  801c15:	bf 06 00 00 00       	mov    $0x6,%edi
  801c1a:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801c21:	00 00 00 
  801c24:	ff d0                	callq  *%rax
  801c26:	48 83 c4 10          	add    $0x10,%rsp
}
  801c2a:	c9                   	leaveq 
  801c2b:	c3                   	retq   

0000000000801c2c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c2c:	55                   	push   %rbp
  801c2d:	48 89 e5             	mov    %rsp,%rbp
  801c30:	48 83 ec 10          	sub    $0x10,%rsp
  801c34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c37:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c3d:	48 63 d0             	movslq %eax,%rdx
  801c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c43:	48 98                	cltq   
  801c45:	48 83 ec 08          	sub    $0x8,%rsp
  801c49:	6a 00                	pushq  $0x0
  801c4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c57:	48 89 d1             	mov    %rdx,%rcx
  801c5a:	48 89 c2             	mov    %rax,%rdx
  801c5d:	be 01 00 00 00       	mov    $0x1,%esi
  801c62:	bf 08 00 00 00       	mov    $0x8,%edi
  801c67:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	callq  *%rax
  801c73:	48 83 c4 10          	add    $0x10,%rsp
}
  801c77:	c9                   	leaveq 
  801c78:	c3                   	retq   

0000000000801c79 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c79:	55                   	push   %rbp
  801c7a:	48 89 e5             	mov    %rsp,%rbp
  801c7d:	48 83 ec 10          	sub    $0x10,%rsp
  801c81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8f:	48 98                	cltq   
  801c91:	48 83 ec 08          	sub    $0x8,%rsp
  801c95:	6a 00                	pushq  $0x0
  801c97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca3:	48 89 d1             	mov    %rdx,%rcx
  801ca6:	48 89 c2             	mov    %rax,%rdx
  801ca9:	be 01 00 00 00       	mov    $0x1,%esi
  801cae:	bf 09 00 00 00       	mov    $0x9,%edi
  801cb3:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	callq  *%rax
  801cbf:	48 83 c4 10          	add    $0x10,%rsp
}
  801cc3:	c9                   	leaveq 
  801cc4:	c3                   	retq   

0000000000801cc5 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cc5:	55                   	push   %rbp
  801cc6:	48 89 e5             	mov    %rsp,%rbp
  801cc9:	48 83 ec 10          	sub    $0x10,%rsp
  801ccd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdb:	48 98                	cltq   
  801cdd:	48 83 ec 08          	sub    $0x8,%rsp
  801ce1:	6a 00                	pushq  $0x0
  801ce3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cef:	48 89 d1             	mov    %rdx,%rcx
  801cf2:	48 89 c2             	mov    %rax,%rdx
  801cf5:	be 01 00 00 00       	mov    $0x1,%esi
  801cfa:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cff:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	callq  *%rax
  801d0b:	48 83 c4 10          	add    $0x10,%rsp
}
  801d0f:	c9                   	leaveq 
  801d10:	c3                   	retq   

0000000000801d11 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d11:	55                   	push   %rbp
  801d12:	48 89 e5             	mov    %rsp,%rbp
  801d15:	48 83 ec 20          	sub    $0x20,%rsp
  801d19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d20:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d24:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d2a:	48 63 f0             	movslq %eax,%rsi
  801d2d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d34:	48 98                	cltq   
  801d36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3a:	48 83 ec 08          	sub    $0x8,%rsp
  801d3e:	6a 00                	pushq  $0x0
  801d40:	49 89 f1             	mov    %rsi,%r9
  801d43:	49 89 c8             	mov    %rcx,%r8
  801d46:	48 89 d1             	mov    %rdx,%rcx
  801d49:	48 89 c2             	mov    %rax,%rdx
  801d4c:	be 00 00 00 00       	mov    $0x0,%esi
  801d51:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d56:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	callq  *%rax
  801d62:	48 83 c4 10          	add    $0x10,%rsp
}
  801d66:	c9                   	leaveq 
  801d67:	c3                   	retq   

0000000000801d68 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 10          	sub    $0x10,%rsp
  801d70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d78:	48 83 ec 08          	sub    $0x8,%rsp
  801d7c:	6a 00                	pushq  $0x0
  801d7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8f:	48 89 c2             	mov    %rax,%rdx
  801d92:	be 01 00 00 00       	mov    $0x1,%esi
  801d97:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d9c:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
  801da8:	48 83 c4 10          	add    $0x10,%rsp
}
  801dac:	c9                   	leaveq 
  801dad:	c3                   	retq   

0000000000801dae <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801dae:	55                   	push   %rbp
  801daf:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801db2:	48 83 ec 08          	sub    $0x8,%rsp
  801db6:	6a 00                	pushq  $0x0
  801db8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dce:	be 00 00 00 00       	mov    $0x0,%esi
  801dd3:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dd8:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801ddf:	00 00 00 
  801de2:	ff d0                	callq  *%rax
  801de4:	48 83 c4 10          	add    $0x10,%rsp
}
  801de8:	c9                   	leaveq 
  801de9:	c3                   	retq   

0000000000801dea <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	48 83 ec 10          	sub    $0x10,%rsp
  801df2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801df6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801df9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e00:	48 83 ec 08          	sub    $0x8,%rsp
  801e04:	6a 00                	pushq  $0x0
  801e06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e12:	48 89 d1             	mov    %rdx,%rcx
  801e15:	48 89 c2             	mov    %rax,%rdx
  801e18:	be 00 00 00 00       	mov    $0x0,%esi
  801e1d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e22:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	callq  *%rax
  801e2e:	48 83 c4 10          	add    $0x10,%rsp
}
  801e32:	c9                   	leaveq 
  801e33:	c3                   	retq   

0000000000801e34 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801e34:	55                   	push   %rbp
  801e35:	48 89 e5             	mov    %rsp,%rbp
  801e38:	48 83 ec 10          	sub    $0x10,%rsp
  801e3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e40:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801e43:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4a:	48 83 ec 08          	sub    $0x8,%rsp
  801e4e:	6a 00                	pushq  $0x0
  801e50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5c:	48 89 d1             	mov    %rdx,%rcx
  801e5f:	48 89 c2             	mov    %rax,%rdx
  801e62:	be 00 00 00 00       	mov    $0x0,%esi
  801e67:	bf 10 00 00 00       	mov    $0x10,%edi
  801e6c:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801e73:	00 00 00 
  801e76:	ff d0                	callq  *%rax
  801e78:	48 83 c4 10          	add    $0x10,%rsp
}
  801e7c:	c9                   	leaveq 
  801e7d:	c3                   	retq   

0000000000801e7e <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e7e:	55                   	push   %rbp
  801e7f:	48 89 e5             	mov    %rsp,%rbp
  801e82:	48 83 ec 20          	sub    $0x20,%rsp
  801e86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e8d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e90:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e94:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e98:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e9b:	48 63 c8             	movslq %eax,%rcx
  801e9e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ea2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ea5:	48 63 f0             	movslq %eax,%rsi
  801ea8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eaf:	48 98                	cltq   
  801eb1:	48 83 ec 08          	sub    $0x8,%rsp
  801eb5:	51                   	push   %rcx
  801eb6:	49 89 f9             	mov    %rdi,%r9
  801eb9:	49 89 f0             	mov    %rsi,%r8
  801ebc:	48 89 d1             	mov    %rdx,%rcx
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	be 00 00 00 00       	mov    $0x0,%esi
  801ec7:	bf 11 00 00 00       	mov    $0x11,%edi
  801ecc:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
  801ed8:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 10          	sub    $0x10,%rsp
  801ee6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801eee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef6:	48 83 ec 08          	sub    $0x8,%rsp
  801efa:	6a 00                	pushq  $0x0
  801efc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f08:	48 89 d1             	mov    %rdx,%rcx
  801f0b:	48 89 c2             	mov    %rax,%rdx
  801f0e:	be 00 00 00 00       	mov    $0x0,%esi
  801f13:	bf 12 00 00 00       	mov    $0x12,%edi
  801f18:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801f1f:	00 00 00 
  801f22:	ff d0                	callq  *%rax
  801f24:	48 83 c4 10          	add    $0x10,%rsp
}
  801f28:	c9                   	leaveq 
  801f29:	c3                   	retq   

0000000000801f2a <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801f2e:	48 83 ec 08          	sub    $0x8,%rsp
  801f32:	6a 00                	pushq  $0x0
  801f34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f40:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f45:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4a:	be 00 00 00 00       	mov    $0x0,%esi
  801f4f:	bf 13 00 00 00       	mov    $0x13,%edi
  801f54:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
  801f60:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801f64:	90                   	nop
  801f65:	c9                   	leaveq 
  801f66:	c3                   	retq   

0000000000801f67 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801f67:	55                   	push   %rbp
  801f68:	48 89 e5             	mov    %rsp,%rbp
  801f6b:	48 83 ec 10          	sub    $0x10,%rsp
  801f6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f75:	48 98                	cltq   
  801f77:	48 83 ec 08          	sub    $0x8,%rsp
  801f7b:	6a 00                	pushq  $0x0
  801f7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f8e:	48 89 c2             	mov    %rax,%rdx
  801f91:	be 00 00 00 00       	mov    $0x0,%esi
  801f96:	bf 14 00 00 00       	mov    $0x14,%edi
  801f9b:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801fa2:	00 00 00 
  801fa5:	ff d0                	callq  *%rax
  801fa7:	48 83 c4 10          	add    $0x10,%rsp
}
  801fab:	c9                   	leaveq 
  801fac:	c3                   	retq   

0000000000801fad <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fb1:	48 83 ec 08          	sub    $0x8,%rsp
  801fb5:	6a 00                	pushq  $0x0
  801fb7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcd:	be 00 00 00 00       	mov    $0x0,%esi
  801fd2:	bf 15 00 00 00       	mov    $0x15,%edi
  801fd7:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax
  801fe3:	48 83 c4 10          	add    $0x10,%rsp
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fed:	48 83 ec 08          	sub    $0x8,%rsp
  801ff1:	6a 00                	pushq  $0x0
  801ff3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ff9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fff:	b9 00 00 00 00       	mov    $0x0,%ecx
  802004:	ba 00 00 00 00       	mov    $0x0,%edx
  802009:	be 00 00 00 00       	mov    $0x0,%esi
  80200e:	bf 16 00 00 00       	mov    $0x16,%edi
  802013:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  80201a:	00 00 00 
  80201d:	ff d0                	callq  *%rax
  80201f:	48 83 c4 10          	add    $0x10,%rsp
}
  802023:	90                   	nop
  802024:	c9                   	leaveq 
  802025:	c3                   	retq   

0000000000802026 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802026:	55                   	push   %rbp
  802027:	48 89 e5             	mov    %rsp,%rbp
  80202a:	48 83 ec 30          	sub    $0x30,%rsp
  80202e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802032:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802036:	48 8b 00             	mov    (%rax),%rax
  802039:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  80203d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802041:	48 8b 40 08          	mov    0x8(%rax),%rax
  802045:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  802048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204b:	83 e0 02             	and    $0x2,%eax
  80204e:	85 c0                	test   %eax,%eax
  802050:	75 40                	jne    802092 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802052:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802056:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  80205d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802061:	49 89 d0             	mov    %rdx,%r8
  802064:	48 89 c1             	mov    %rax,%rcx
  802067:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  80206e:	00 00 00 
  802071:	be 1f 00 00 00       	mov    $0x1f,%esi
  802076:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  80207d:	00 00 00 
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
  802085:	49 b9 2e 04 80 00 00 	movabs $0x80042e,%r9
  80208c:	00 00 00 
  80208f:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802096:	48 c1 e8 0c          	shr    $0xc,%rax
  80209a:	48 89 c2             	mov    %rax,%rdx
  80209d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020a4:	01 00 00 
  8020a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ab:	25 07 08 00 00       	and    $0x807,%eax
  8020b0:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  8020b6:	74 4e                	je     802106 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  8020b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c0:	48 89 c2             	mov    %rax,%rdx
  8020c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ca:	01 00 00 
  8020cd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d5:	49 89 d0             	mov    %rdx,%r8
  8020d8:	48 89 c1             	mov    %rax,%rcx
  8020db:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  8020e2:	00 00 00 
  8020e5:	be 22 00 00 00       	mov    $0x22,%esi
  8020ea:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8020f1:	00 00 00 
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	49 b9 2e 04 80 00 00 	movabs $0x80042e,%r9
  802100:	00 00 00 
  802103:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802106:	ba 07 00 00 00       	mov    $0x7,%edx
  80210b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802110:	bf 00 00 00 00       	mov    $0x0,%edi
  802115:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80211c:	00 00 00 
  80211f:	ff d0                	callq  *%rax
  802121:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802124:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802128:	79 30                	jns    80215a <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  80212a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80212d:	89 c1                	mov    %eax,%ecx
  80212f:	48 ba 0b 51 80 00 00 	movabs $0x80510b,%rdx
  802136:	00 00 00 
  802139:	be 28 00 00 00       	mov    $0x28,%esi
  80213e:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  802145:	00 00 00 
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
  80214d:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802154:	00 00 00 
  802157:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80215a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80215e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802166:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80216c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802171:	48 89 c6             	mov    %rax,%rsi
  802174:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802179:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802180:	00 00 00 
  802183:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802189:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80218d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802191:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802197:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80219d:	48 89 c1             	mov    %rax,%rcx
  8021a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8021af:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	callq  *%rax
  8021bb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021be:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021c2:	79 30                	jns    8021f4 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8021c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021c7:	89 c1                	mov    %eax,%ecx
  8021c9:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  8021d0:	00 00 00 
  8021d3:	be 2d 00 00 00       	mov    $0x2d,%esi
  8021d8:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8021df:	00 00 00 
  8021e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e7:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8021ee:	00 00 00 
  8021f1:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8021f4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fe:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802205:	00 00 00 
  802208:	ff d0                	callq  *%rax
  80220a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80220d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802211:	79 30                	jns    802243 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802213:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802216:	89 c1                	mov    %eax,%ecx
  802218:	48 ba 2f 51 80 00 00 	movabs $0x80512f,%rdx
  80221f:	00 00 00 
  802222:	be 31 00 00 00       	mov    $0x31,%esi
  802227:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  80222e:	00 00 00 
  802231:	b8 00 00 00 00       	mov    $0x0,%eax
  802236:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80223d:	00 00 00 
  802240:	41 ff d0             	callq  *%r8

}
  802243:	90                   	nop
  802244:	c9                   	leaveq 
  802245:	c3                   	retq   

0000000000802246 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802246:	55                   	push   %rbp
  802247:	48 89 e5             	mov    %rsp,%rbp
  80224a:	48 83 ec 30          	sub    $0x30,%rsp
  80224e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802251:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802254:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802257:	c1 e0 0c             	shl    $0xc,%eax
  80225a:	89 c0                	mov    %eax,%eax
  80225c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802260:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802267:	01 00 00 
  80226a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80226d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802271:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802279:	25 02 08 00 00       	and    $0x802,%eax
  80227e:	48 85 c0             	test   %rax,%rax
  802281:	74 0e                	je     802291 <duppage+0x4b>
  802283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802287:	25 00 04 00 00       	and    $0x400,%eax
  80228c:	48 85 c0             	test   %rax,%rax
  80228f:	74 70                	je     802301 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802295:	25 07 0e 00 00       	and    $0xe07,%eax
  80229a:	89 c6                	mov    %eax,%esi
  80229c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8022a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a7:	41 89 f0             	mov    %esi,%r8d
  8022aa:	48 89 c6             	mov    %rax,%rsi
  8022ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b2:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	callq  *%rax
  8022be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8022c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022c5:	79 30                	jns    8022f7 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8022c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ca:	89 c1                	mov    %eax,%ecx
  8022cc:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  8022d3:	00 00 00 
  8022d6:	be 50 00 00 00       	mov    $0x50,%esi
  8022db:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8022e2:	00 00 00 
  8022e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ea:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8022f1:	00 00 00 
  8022f4:	41 ff d0             	callq  *%r8
		return 0;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	e9 c4 00 00 00       	jmpq   8023c5 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802301:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802305:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230c:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802312:	48 89 c6             	mov    %rax,%rsi
  802315:	bf 00 00 00 00       	mov    $0x0,%edi
  80231a:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802321:	00 00 00 
  802324:	ff d0                	callq  *%rax
  802326:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802329:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80232d:	79 30                	jns    80235f <duppage+0x119>
		panic("sys_page_map: %e", r);
  80232f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802332:	89 c1                	mov    %eax,%ecx
  802334:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  80233b:	00 00 00 
  80233e:	be 64 00 00 00       	mov    $0x64,%esi
  802343:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  80234a:	00 00 00 
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
  802352:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802359:	00 00 00 
  80235c:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80235f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802367:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80236d:	48 89 d1             	mov    %rdx,%rcx
  802370:	ba 00 00 00 00       	mov    $0x0,%edx
  802375:	48 89 c6             	mov    %rax,%rsi
  802378:	bf 00 00 00 00       	mov    $0x0,%edi
  80237d:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
  802389:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80238c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802390:	79 30                	jns    8023c2 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802392:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802395:	89 c1                	mov    %eax,%ecx
  802397:	48 ba 1e 51 80 00 00 	movabs $0x80511e,%rdx
  80239e:	00 00 00 
  8023a1:	be 66 00 00 00       	mov    $0x66,%esi
  8023a6:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8023ad:	00 00 00 
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8023bc:	00 00 00 
  8023bf:	41 ff d0             	callq  *%r8
	return r;
  8023c2:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8023c5:	c9                   	leaveq 
  8023c6:	c3                   	retq   

00000000008023c7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8023c7:	55                   	push   %rbp
  8023c8:	48 89 e5             	mov    %rsp,%rbp
  8023cb:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8023cf:	48 bf 26 20 80 00 00 	movabs $0x802026,%rdi
  8023d6:	00 00 00 
  8023d9:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  8023e0:	00 00 00 
  8023e3:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8023e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8023ea:	cd 30                	int    $0x30
  8023ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8023ef:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8023f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8023f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023f9:	79 08                	jns    802403 <fork+0x3c>
		return envid;
  8023fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fe:	e9 0b 02 00 00       	jmpq   80260e <fork+0x247>
	if (envid == 0) {
  802403:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802407:	75 3e                	jne    802447 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802409:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	25 ff 03 00 00       	and    $0x3ff,%eax
  80241a:	48 98                	cltq   
  80241c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802423:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80242a:	00 00 00 
  80242d:	48 01 c2             	add    %rax,%rdx
  802430:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802437:	00 00 00 
  80243a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
  802442:	e9 c7 01 00 00       	jmpq   80260e <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80244e:	e9 a6 00 00 00       	jmpq   8024f9 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802456:	c1 f8 12             	sar    $0x12,%eax
  802459:	89 c2                	mov    %eax,%edx
  80245b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802462:	01 00 00 
  802465:	48 63 d2             	movslq %edx,%rdx
  802468:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246c:	83 e0 01             	and    $0x1,%eax
  80246f:	48 85 c0             	test   %rax,%rax
  802472:	74 21                	je     802495 <fork+0xce>
  802474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802477:	c1 f8 09             	sar    $0x9,%eax
  80247a:	89 c2                	mov    %eax,%edx
  80247c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802483:	01 00 00 
  802486:	48 63 d2             	movslq %edx,%rdx
  802489:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80248d:	83 e0 01             	and    $0x1,%eax
  802490:	48 85 c0             	test   %rax,%rax
  802493:	75 09                	jne    80249e <fork+0xd7>
			pn += NPTENTRIES;
  802495:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80249c:	eb 5b                	jmp    8024f9 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80249e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a1:	05 00 02 00 00       	add    $0x200,%eax
  8024a6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8024a9:	eb 46                	jmp    8024f1 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8024ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b2:	01 00 00 
  8024b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b8:	48 63 d2             	movslq %edx,%rdx
  8024bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bf:	83 e0 05             	and    $0x5,%eax
  8024c2:	48 83 f8 05          	cmp    $0x5,%rax
  8024c6:	75 21                	jne    8024e9 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  8024c8:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8024cf:	74 1b                	je     8024ec <fork+0x125>
				continue;
			duppage(envid, pn);
  8024d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024d7:	89 d6                	mov    %edx,%esi
  8024d9:	89 c7                	mov    %eax,%edi
  8024db:	48 b8 46 22 80 00 00 	movabs $0x802246,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
  8024e7:	eb 04                	jmp    8024ed <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  8024e9:	90                   	nop
  8024ea:	eb 01                	jmp    8024ed <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  8024ec:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8024ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8024f7:	7c b2                	jl     8024ab <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8024f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fc:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802501:	0f 86 4c ff ff ff    	jbe    802453 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802507:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80250a:	ba 07 00 00 00       	mov    $0x7,%edx
  80250f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802514:	89 c7                	mov    %eax,%edi
  802516:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802525:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802529:	79 30                	jns    80255b <fork+0x194>
		panic("allocating exception stack: %e", r);
  80252b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80252e:	89 c1                	mov    %eax,%ecx
  802530:	48 ba 48 51 80 00 00 	movabs $0x805148,%rdx
  802537:	00 00 00 
  80253a:	be 9e 00 00 00       	mov    $0x9e,%esi
  80253f:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  802546:	00 00 00 
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802555:	00 00 00 
  802558:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80255b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802562:	00 00 00 
  802565:	48 8b 00             	mov    (%rax),%rax
  802568:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80256f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802572:	48 89 d6             	mov    %rdx,%rsi
  802575:	89 c7                	mov    %eax,%edi
  802577:	48 b8 c5 1c 80 00 00 	movabs $0x801cc5,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
  802583:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802586:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80258a:	79 30                	jns    8025bc <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80258c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80258f:	89 c1                	mov    %eax,%ecx
  802591:	48 ba 68 51 80 00 00 	movabs $0x805168,%rdx
  802598:	00 00 00 
  80259b:	be a2 00 00 00       	mov    $0xa2,%esi
  8025a0:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8025a7:	00 00 00 
  8025aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025af:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8025b6:	00 00 00 
  8025b9:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8025bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025bf:	be 02 00 00 00       	mov    $0x2,%esi
  8025c4:	89 c7                	mov    %eax,%edi
  8025c6:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
  8025d2:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8025d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8025d9:	79 30                	jns    80260b <fork+0x244>
		panic("sys_env_set_status: %e", r);
  8025db:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8025de:	89 c1                	mov    %eax,%ecx
  8025e0:	48 ba 87 51 80 00 00 	movabs $0x805187,%rdx
  8025e7:	00 00 00 
  8025ea:	be a7 00 00 00       	mov    $0xa7,%esi
  8025ef:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  8025f6:	00 00 00 
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fe:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802605:	00 00 00 
  802608:	41 ff d0             	callq  *%r8

	return envid;
  80260b:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  80260e:	c9                   	leaveq 
  80260f:	c3                   	retq   

0000000000802610 <sfork>:

// Challenge!
int
sfork(void)
{
  802610:	55                   	push   %rbp
  802611:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802614:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  80261b:	00 00 00 
  80261e:	be b1 00 00 00       	mov    $0xb1,%esi
  802623:	48 bf d1 50 80 00 00 	movabs $0x8050d1,%rdi
  80262a:	00 00 00 
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	48 b9 2e 04 80 00 00 	movabs $0x80042e,%rcx
  802639:	00 00 00 
  80263c:	ff d1                	callq  *%rcx

000000000080263e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80263e:	55                   	push   %rbp
  80263f:	48 89 e5             	mov    %rsp,%rbp
  802642:	48 83 ec 30          	sub    $0x30,%rsp
  802646:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80264a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80264e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802652:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802657:	75 0e                	jne    802667 <ipc_recv+0x29>
		pg = (void*) UTOP;
  802659:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802660:	00 00 00 
  802663:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80266b:	48 89 c7             	mov    %rax,%rdi
  80266e:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802681:	79 27                	jns    8026aa <ipc_recv+0x6c>
		if (from_env_store)
  802683:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802688:	74 0a                	je     802694 <ipc_recv+0x56>
			*from_env_store = 0;
  80268a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802694:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802699:	74 0a                	je     8026a5 <ipc_recv+0x67>
			*perm_store = 0;
  80269b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80269f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8026a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a8:	eb 53                	jmp    8026fd <ipc_recv+0xbf>
	}
	if (from_env_store)
  8026aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026af:	74 19                	je     8026ca <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8026b1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026b8:	00 00 00 
  8026bb:	48 8b 00             	mov    (%rax),%rax
  8026be:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8026c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c8:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8026ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026cf:	74 19                	je     8026ea <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8026d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026d8:	00 00 00 
  8026db:	48 8b 00             	mov    (%rax),%rax
  8026de:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8026e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e8:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8026ea:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026f1:	00 00 00 
  8026f4:	48 8b 00             	mov    (%rax),%rax
  8026f7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   

00000000008026ff <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 30          	sub    $0x30,%rsp
  802707:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80270a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80270d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802711:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802714:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802719:	75 1c                	jne    802737 <ipc_send+0x38>
		pg = (void*) UTOP;
  80271b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802722:	00 00 00 
  802725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802729:	eb 0c                	jmp    802737 <ipc_send+0x38>
		sys_yield();
  80272b:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  802732:	00 00 00 
  802735:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802737:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80273a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80273d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802741:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802744:	89 c7                	mov    %eax,%edi
  802746:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  80274d:	00 00 00 
  802750:	ff d0                	callq  *%rax
  802752:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802755:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802759:	74 d0                	je     80272b <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80275b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275f:	79 30                	jns    802791 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  802761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802764:	89 c1                	mov    %eax,%ecx
  802766:	48 ba b4 51 80 00 00 	movabs $0x8051b4,%rdx
  80276d:	00 00 00 
  802770:	be 47 00 00 00       	mov    $0x47,%esi
  802775:	48 bf ca 51 80 00 00 	movabs $0x8051ca,%rdi
  80277c:	00 00 00 
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80278b:	00 00 00 
  80278e:	41 ff d0             	callq  *%r8

}
  802791:	90                   	nop
  802792:	c9                   	leaveq 
  802793:	c3                   	retq   

0000000000802794 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802794:	55                   	push   %rbp
  802795:	48 89 e5             	mov    %rsp,%rbp
  802798:	48 83 ec 18          	sub    $0x18,%rsp
  80279c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80279f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027a6:	eb 4d                	jmp    8027f5 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8027a8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8027af:	00 00 00 
  8027b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b5:	48 98                	cltq   
  8027b7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8027be:	48 01 d0             	add    %rdx,%rax
  8027c1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8027c7:	8b 00                	mov    (%rax),%eax
  8027c9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027cc:	75 23                	jne    8027f1 <ipc_find_env+0x5d>
			return envs[i].env_id;
  8027ce:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8027d5:	00 00 00 
  8027d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027db:	48 98                	cltq   
  8027dd:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8027e4:	48 01 d0             	add    %rdx,%rax
  8027e7:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8027ed:	8b 00                	mov    (%rax),%eax
  8027ef:	eb 12                	jmp    802803 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8027f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027f5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8027fc:	7e aa                	jle    8027a8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802803:	c9                   	leaveq 
  802804:	c3                   	retq   

0000000000802805 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802805:	55                   	push   %rbp
  802806:	48 89 e5             	mov    %rsp,%rbp
  802809:	48 83 ec 08          	sub    $0x8,%rsp
  80280d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802811:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802815:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80281c:	ff ff ff 
  80281f:	48 01 d0             	add    %rdx,%rax
  802822:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802826:	c9                   	leaveq 
  802827:	c3                   	retq   

0000000000802828 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802828:	55                   	push   %rbp
  802829:	48 89 e5             	mov    %rsp,%rbp
  80282c:	48 83 ec 08          	sub    $0x8,%rsp
  802830:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802834:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802838:	48 89 c7             	mov    %rax,%rdi
  80283b:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
  802847:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80284d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802851:	c9                   	leaveq 
  802852:	c3                   	retq   

0000000000802853 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802853:	55                   	push   %rbp
  802854:	48 89 e5             	mov    %rsp,%rbp
  802857:	48 83 ec 18          	sub    $0x18,%rsp
  80285b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80285f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802866:	eb 6b                	jmp    8028d3 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802868:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286b:	48 98                	cltq   
  80286d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802873:	48 c1 e0 0c          	shl    $0xc,%rax
  802877:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80287b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287f:	48 c1 e8 15          	shr    $0x15,%rax
  802883:	48 89 c2             	mov    %rax,%rdx
  802886:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80288d:	01 00 00 
  802890:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802894:	83 e0 01             	and    $0x1,%eax
  802897:	48 85 c0             	test   %rax,%rax
  80289a:	74 21                	je     8028bd <fd_alloc+0x6a>
  80289c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8028a4:	48 89 c2             	mov    %rax,%rdx
  8028a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ae:	01 00 00 
  8028b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b5:	83 e0 01             	and    $0x1,%eax
  8028b8:	48 85 c0             	test   %rax,%rax
  8028bb:	75 12                	jne    8028cf <fd_alloc+0x7c>
			*fd_store = fd;
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028c5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	eb 1a                	jmp    8028e9 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028d3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028d7:	7e 8f                	jle    802868 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028e4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028e9:	c9                   	leaveq 
  8028ea:	c3                   	retq   

00000000008028eb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	48 83 ec 20          	sub    $0x20,%rsp
  8028f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028fe:	78 06                	js     802906 <fd_lookup+0x1b>
  802900:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802904:	7e 07                	jle    80290d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802906:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80290b:	eb 6c                	jmp    802979 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80290d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802910:	48 98                	cltq   
  802912:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802918:	48 c1 e0 0c          	shl    $0xc,%rax
  80291c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802924:	48 c1 e8 15          	shr    $0x15,%rax
  802928:	48 89 c2             	mov    %rax,%rdx
  80292b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802932:	01 00 00 
  802935:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802939:	83 e0 01             	and    $0x1,%eax
  80293c:	48 85 c0             	test   %rax,%rax
  80293f:	74 21                	je     802962 <fd_lookup+0x77>
  802941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802945:	48 c1 e8 0c          	shr    $0xc,%rax
  802949:	48 89 c2             	mov    %rax,%rdx
  80294c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802953:	01 00 00 
  802956:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80295a:	83 e0 01             	and    $0x1,%eax
  80295d:	48 85 c0             	test   %rax,%rax
  802960:	75 07                	jne    802969 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802962:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802967:	eb 10                	jmp    802979 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802971:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802979:	c9                   	leaveq 
  80297a:	c3                   	retq   

000000000080297b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80297b:	55                   	push   %rbp
  80297c:	48 89 e5             	mov    %rsp,%rbp
  80297f:	48 83 ec 30          	sub    $0x30,%rsp
  802983:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802987:	89 f0                	mov    %esi,%eax
  802989:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80298c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802990:	48 89 c7             	mov    %rax,%rdi
  802993:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	callq  *%rax
  80299f:	89 c2                	mov    %eax,%edx
  8029a1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029a5:	48 89 c6             	mov    %rax,%rsi
  8029a8:	89 d7                	mov    %edx,%edi
  8029aa:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	callq  *%rax
  8029b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bd:	78 0a                	js     8029c9 <fd_close+0x4e>
	    || fd != fd2)
  8029bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c3:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8029c7:	74 12                	je     8029db <fd_close+0x60>
		return (must_exist ? r : 0);
  8029c9:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8029cd:	74 05                	je     8029d4 <fd_close+0x59>
  8029cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d2:	eb 70                	jmp    802a44 <fd_close+0xc9>
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d9:	eb 69                	jmp    802a44 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029df:	8b 00                	mov    (%rax),%eax
  8029e1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029e5:	48 89 d6             	mov    %rdx,%rsi
  8029e8:	89 c7                	mov    %eax,%edi
  8029ea:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
  8029f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fd:	78 2a                	js     802a29 <fd_close+0xae>
		if (dev->dev_close)
  8029ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a03:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a07:	48 85 c0             	test   %rax,%rax
  802a0a:	74 16                	je     802a22 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a10:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a14:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a18:	48 89 d7             	mov    %rdx,%rdi
  802a1b:	ff d0                	callq  *%rax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a20:	eb 07                	jmp    802a29 <fd_close+0xae>
		else
			r = 0;
  802a22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a2d:	48 89 c6             	mov    %rax,%rsi
  802a30:	bf 00 00 00 00       	mov    $0x0,%edi
  802a35:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	callq  *%rax
	return r;
  802a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a44:	c9                   	leaveq 
  802a45:	c3                   	retq   

0000000000802a46 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a46:	55                   	push   %rbp
  802a47:	48 89 e5             	mov    %rsp,%rbp
  802a4a:	48 83 ec 20          	sub    $0x20,%rsp
  802a4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a5c:	eb 41                	jmp    802a9f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a5e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a65:	00 00 00 
  802a68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a6b:	48 63 d2             	movslq %edx,%rdx
  802a6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a72:	8b 00                	mov    (%rax),%eax
  802a74:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a77:	75 22                	jne    802a9b <dev_lookup+0x55>
			*dev = devtab[i];
  802a79:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a80:	00 00 00 
  802a83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a86:	48 63 d2             	movslq %edx,%rdx
  802a89:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a91:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	eb 60                	jmp    802afb <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a9f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802aa6:	00 00 00 
  802aa9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802aac:	48 63 d2             	movslq %edx,%rdx
  802aaf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ab3:	48 85 c0             	test   %rax,%rax
  802ab6:	75 a6                	jne    802a5e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ab8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802abf:	00 00 00 
  802ac2:	48 8b 00             	mov    (%rax),%rax
  802ac5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802acb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ace:	89 c6                	mov    %eax,%esi
  802ad0:	48 bf d8 51 80 00 00 	movabs $0x8051d8,%rdi
  802ad7:	00 00 00 
  802ada:	b8 00 00 00 00       	mov    $0x0,%eax
  802adf:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  802ae6:	00 00 00 
  802ae9:	ff d1                	callq  *%rcx
	*dev = 0;
  802aeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aef:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802af6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802afb:	c9                   	leaveq 
  802afc:	c3                   	retq   

0000000000802afd <close>:

int
close(int fdnum)
{
  802afd:	55                   	push   %rbp
  802afe:	48 89 e5             	mov    %rsp,%rbp
  802b01:	48 83 ec 20          	sub    $0x20,%rsp
  802b05:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b08:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b0f:	48 89 d6             	mov    %rdx,%rsi
  802b12:	89 c7                	mov    %eax,%edi
  802b14:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
  802b20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b27:	79 05                	jns    802b2e <close+0x31>
		return r;
  802b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2c:	eb 18                	jmp    802b46 <close+0x49>
	else
		return fd_close(fd, 1);
  802b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b32:	be 01 00 00 00       	mov    $0x1,%esi
  802b37:	48 89 c7             	mov    %rax,%rdi
  802b3a:	48 b8 7b 29 80 00 00 	movabs $0x80297b,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	callq  *%rax
}
  802b46:	c9                   	leaveq 
  802b47:	c3                   	retq   

0000000000802b48 <close_all>:

void
close_all(void)
{
  802b48:	55                   	push   %rbp
  802b49:	48 89 e5             	mov    %rsp,%rbp
  802b4c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b57:	eb 15                	jmp    802b6e <close_all+0x26>
		close(i);
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	89 c7                	mov    %eax,%edi
  802b5e:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b6a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b6e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b72:	7e e5                	jle    802b59 <close_all+0x11>
		close(i);
}
  802b74:	90                   	nop
  802b75:	c9                   	leaveq 
  802b76:	c3                   	retq   

0000000000802b77 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b77:	55                   	push   %rbp
  802b78:	48 89 e5             	mov    %rsp,%rbp
  802b7b:	48 83 ec 40          	sub    $0x40,%rsp
  802b7f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b82:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b85:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b89:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b8c:	48 89 d6             	mov    %rdx,%rsi
  802b8f:	89 c7                	mov    %eax,%edi
  802b91:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
  802b9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba4:	79 08                	jns    802bae <dup+0x37>
		return r;
  802ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba9:	e9 70 01 00 00       	jmpq   802d1e <dup+0x1a7>
	close(newfdnum);
  802bae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802bbf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bc2:	48 98                	cltq   
  802bc4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bca:	48 c1 e0 0c          	shl    $0xc,%rax
  802bce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802bd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd6:	48 89 c7             	mov    %rax,%rdi
  802bd9:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
  802be5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bed:	48 89 c7             	mov    %rax,%rdi
  802bf0:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
  802bfc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c04:	48 c1 e8 15          	shr    $0x15,%rax
  802c08:	48 89 c2             	mov    %rax,%rdx
  802c0b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c12:	01 00 00 
  802c15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c19:	83 e0 01             	and    $0x1,%eax
  802c1c:	48 85 c0             	test   %rax,%rax
  802c1f:	74 71                	je     802c92 <dup+0x11b>
  802c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c25:	48 c1 e8 0c          	shr    $0xc,%rax
  802c29:	48 89 c2             	mov    %rax,%rdx
  802c2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c33:	01 00 00 
  802c36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c3a:	83 e0 01             	and    $0x1,%eax
  802c3d:	48 85 c0             	test   %rax,%rax
  802c40:	74 50                	je     802c92 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c46:	48 c1 e8 0c          	shr    $0xc,%rax
  802c4a:	48 89 c2             	mov    %rax,%rdx
  802c4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c54:	01 00 00 
  802c57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c5b:	25 07 0e 00 00       	and    $0xe07,%eax
  802c60:	89 c1                	mov    %eax,%ecx
  802c62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6a:	41 89 c8             	mov    %ecx,%r8d
  802c6d:	48 89 d1             	mov    %rdx,%rcx
  802c70:	ba 00 00 00 00       	mov    $0x0,%edx
  802c75:	48 89 c6             	mov    %rax,%rsi
  802c78:	bf 00 00 00 00       	mov    $0x0,%edi
  802c7d:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802c84:	00 00 00 
  802c87:	ff d0                	callq  *%rax
  802c89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c90:	78 55                	js     802ce7 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c96:	48 c1 e8 0c          	shr    $0xc,%rax
  802c9a:	48 89 c2             	mov    %rax,%rdx
  802c9d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ca4:	01 00 00 
  802ca7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cab:	25 07 0e 00 00       	and    $0xe07,%eax
  802cb0:	89 c1                	mov    %eax,%ecx
  802cb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cba:	41 89 c8             	mov    %ecx,%r8d
  802cbd:	48 89 d1             	mov    %rdx,%rcx
  802cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc5:	48 89 c6             	mov    %rax,%rsi
  802cc8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ccd:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
  802cd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce0:	78 08                	js     802cea <dup+0x173>
		goto err;

	return newfdnum;
  802ce2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ce5:	eb 37                	jmp    802d1e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ce7:	90                   	nop
  802ce8:	eb 01                	jmp    802ceb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802cea:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ceb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cef:	48 89 c6             	mov    %rax,%rsi
  802cf2:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf7:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d07:	48 89 c6             	mov    %rax,%rsi
  802d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d0f:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
	return r;
  802d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d1e:	c9                   	leaveq 
  802d1f:	c3                   	retq   

0000000000802d20 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d20:	55                   	push   %rbp
  802d21:	48 89 e5             	mov    %rsp,%rbp
  802d24:	48 83 ec 40          	sub    $0x40,%rsp
  802d28:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d2f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d33:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d3a:	48 89 d6             	mov    %rdx,%rsi
  802d3d:	89 c7                	mov    %eax,%edi
  802d3f:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d52:	78 24                	js     802d78 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d58:	8b 00                	mov    (%rax),%eax
  802d5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d5e:	48 89 d6             	mov    %rdx,%rsi
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d76:	79 05                	jns    802d7d <read+0x5d>
		return r;
  802d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7b:	eb 76                	jmp    802df3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d81:	8b 40 08             	mov    0x8(%rax),%eax
  802d84:	83 e0 03             	and    $0x3,%eax
  802d87:	83 f8 01             	cmp    $0x1,%eax
  802d8a:	75 3a                	jne    802dc6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d8c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d93:	00 00 00 
  802d96:	48 8b 00             	mov    (%rax),%rax
  802d99:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d9f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da2:	89 c6                	mov    %eax,%esi
  802da4:	48 bf f7 51 80 00 00 	movabs $0x8051f7,%rdi
  802dab:	00 00 00 
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  802dba:	00 00 00 
  802dbd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dc4:	eb 2d                	jmp    802df3 <read+0xd3>
	}
	if (!dev->dev_read)
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dce:	48 85 c0             	test   %rax,%rax
  802dd1:	75 07                	jne    802dda <read+0xba>
		return -E_NOT_SUPP;
  802dd3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dd8:	eb 19                	jmp    802df3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dde:	48 8b 40 10          	mov    0x10(%rax),%rax
  802de2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802de6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802dee:	48 89 cf             	mov    %rcx,%rdi
  802df1:	ff d0                	callq  *%rax
}
  802df3:	c9                   	leaveq 
  802df4:	c3                   	retq   

0000000000802df5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	48 83 ec 30          	sub    $0x30,%rsp
  802dfd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e0f:	eb 47                	jmp    802e58 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e14:	48 98                	cltq   
  802e16:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e1a:	48 29 c2             	sub    %rax,%rdx
  802e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e20:	48 63 c8             	movslq %eax,%rcx
  802e23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e27:	48 01 c1             	add    %rax,%rcx
  802e2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e2d:	48 89 ce             	mov    %rcx,%rsi
  802e30:	89 c7                	mov    %eax,%edi
  802e32:	48 b8 20 2d 80 00 00 	movabs $0x802d20,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
  802e3e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e41:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e45:	79 05                	jns    802e4c <readn+0x57>
			return m;
  802e47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e4a:	eb 1d                	jmp    802e69 <readn+0x74>
		if (m == 0)
  802e4c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e50:	74 13                	je     802e65 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e55:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5b:	48 98                	cltq   
  802e5d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e61:	72 ae                	jb     802e11 <readn+0x1c>
  802e63:	eb 01                	jmp    802e66 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802e65:	90                   	nop
	}
	return tot;
  802e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e69:	c9                   	leaveq 
  802e6a:	c3                   	retq   

0000000000802e6b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e6b:	55                   	push   %rbp
  802e6c:	48 89 e5             	mov    %rsp,%rbp
  802e6f:	48 83 ec 40          	sub    $0x40,%rsp
  802e73:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e7a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e7e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e82:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e85:	48 89 d6             	mov    %rdx,%rsi
  802e88:	89 c7                	mov    %eax,%edi
  802e8a:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
  802e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9d:	78 24                	js     802ec3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea3:	8b 00                	mov    (%rax),%eax
  802ea5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ea9:	48 89 d6             	mov    %rdx,%rsi
  802eac:	89 c7                	mov    %eax,%edi
  802eae:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec1:	79 05                	jns    802ec8 <write+0x5d>
		return r;
  802ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec6:	eb 75                	jmp    802f3d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ec8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecc:	8b 40 08             	mov    0x8(%rax),%eax
  802ecf:	83 e0 03             	and    $0x3,%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	75 3a                	jne    802f10 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ed6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802edd:	00 00 00 
  802ee0:	48 8b 00             	mov    (%rax),%rax
  802ee3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ee9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802eec:	89 c6                	mov    %eax,%esi
  802eee:	48 bf 13 52 80 00 00 	movabs $0x805213,%rdi
  802ef5:	00 00 00 
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  802efd:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  802f04:	00 00 00 
  802f07:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f0e:	eb 2d                	jmp    802f3d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f14:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f18:	48 85 c0             	test   %rax,%rax
  802f1b:	75 07                	jne    802f24 <write+0xb9>
		return -E_NOT_SUPP;
  802f1d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f22:	eb 19                	jmp    802f3d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802f24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f28:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f2c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f30:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f34:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f38:	48 89 cf             	mov    %rcx,%rdi
  802f3b:	ff d0                	callq  *%rax
}
  802f3d:	c9                   	leaveq 
  802f3e:	c3                   	retq   

0000000000802f3f <seek>:

int
seek(int fdnum, off_t offset)
{
  802f3f:	55                   	push   %rbp
  802f40:	48 89 e5             	mov    %rsp,%rbp
  802f43:	48 83 ec 18          	sub    $0x18,%rsp
  802f47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f4a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f4d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f54:	48 89 d6             	mov    %rdx,%rsi
  802f57:	89 c7                	mov    %eax,%edi
  802f59:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
  802f65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6c:	79 05                	jns    802f73 <seek+0x34>
		return r;
  802f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f71:	eb 0f                	jmp    802f82 <seek+0x43>
	fd->fd_offset = offset;
  802f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f77:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f82:	c9                   	leaveq 
  802f83:	c3                   	retq   

0000000000802f84 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f84:	55                   	push   %rbp
  802f85:	48 89 e5             	mov    %rsp,%rbp
  802f88:	48 83 ec 30          	sub    $0x30,%rsp
  802f8c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f8f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f92:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f96:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f99:	48 89 d6             	mov    %rdx,%rsi
  802f9c:	89 c7                	mov    %eax,%edi
  802f9e:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
  802faa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb1:	78 24                	js     802fd7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb7:	8b 00                	mov    (%rax),%eax
  802fb9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fbd:	48 89 d6             	mov    %rdx,%rsi
  802fc0:	89 c7                	mov    %eax,%edi
  802fc2:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
  802fce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd5:	79 05                	jns    802fdc <ftruncate+0x58>
		return r;
  802fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fda:	eb 72                	jmp    80304e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe0:	8b 40 08             	mov    0x8(%rax),%eax
  802fe3:	83 e0 03             	and    $0x3,%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	75 3a                	jne    803024 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802fea:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ff1:	00 00 00 
  802ff4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ff7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ffd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803000:	89 c6                	mov    %eax,%esi
  803002:	48 bf 30 52 80 00 00 	movabs $0x805230,%rdi
  803009:	00 00 00 
  80300c:	b8 00 00 00 00       	mov    $0x0,%eax
  803011:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  803018:	00 00 00 
  80301b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80301d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803022:	eb 2a                	jmp    80304e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803028:	48 8b 40 30          	mov    0x30(%rax),%rax
  80302c:	48 85 c0             	test   %rax,%rax
  80302f:	75 07                	jne    803038 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803031:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803036:	eb 16                	jmp    80304e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303c:	48 8b 40 30          	mov    0x30(%rax),%rax
  803040:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803044:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803047:	89 ce                	mov    %ecx,%esi
  803049:	48 89 d7             	mov    %rdx,%rdi
  80304c:	ff d0                	callq  *%rax
}
  80304e:	c9                   	leaveq 
  80304f:	c3                   	retq   

0000000000803050 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803050:	55                   	push   %rbp
  803051:	48 89 e5             	mov    %rsp,%rbp
  803054:	48 83 ec 30          	sub    $0x30,%rsp
  803058:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80305b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80305f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803063:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803066:	48 89 d6             	mov    %rdx,%rsi
  803069:	89 c7                	mov    %eax,%edi
  80306b:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
  803077:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307e:	78 24                	js     8030a4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803084:	8b 00                	mov    (%rax),%eax
  803086:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80308a:	48 89 d6             	mov    %rdx,%rsi
  80308d:	89 c7                	mov    %eax,%edi
  80308f:	48 b8 46 2a 80 00 00 	movabs $0x802a46,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a2:	79 05                	jns    8030a9 <fstat+0x59>
		return r;
  8030a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a7:	eb 5e                	jmp    803107 <fstat+0xb7>
	if (!dev->dev_stat)
  8030a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ad:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030b1:	48 85 c0             	test   %rax,%rax
  8030b4:	75 07                	jne    8030bd <fstat+0x6d>
		return -E_NOT_SUPP;
  8030b6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030bb:	eb 4a                	jmp    803107 <fstat+0xb7>
	stat->st_name[0] = 0;
  8030bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8030c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8030cf:	00 00 00 
	stat->st_isdir = 0;
  8030d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030d6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030dd:	00 00 00 
	stat->st_dev = dev;
  8030e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030fb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030ff:	48 89 ce             	mov    %rcx,%rsi
  803102:	48 89 d7             	mov    %rdx,%rdi
  803105:	ff d0                	callq  *%rax
}
  803107:	c9                   	leaveq 
  803108:	c3                   	retq   

0000000000803109 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803109:	55                   	push   %rbp
  80310a:	48 89 e5             	mov    %rsp,%rbp
  80310d:	48 83 ec 20          	sub    $0x20,%rsp
  803111:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803115:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311d:	be 00 00 00 00       	mov    $0x0,%esi
  803122:	48 89 c7             	mov    %rax,%rdi
  803125:	48 b8 f9 31 80 00 00 	movabs $0x8031f9,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	79 05                	jns    80313f <stat+0x36>
		return fd;
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	eb 2f                	jmp    80316e <stat+0x65>
	r = fstat(fd, stat);
  80313f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803143:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803146:	48 89 d6             	mov    %rdx,%rsi
  803149:	89 c7                	mov    %eax,%edi
  80314b:	48 b8 50 30 80 00 00 	movabs $0x803050,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80315a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315d:	89 c7                	mov    %eax,%edi
  80315f:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  803166:	00 00 00 
  803169:	ff d0                	callq  *%rax
	return r;
  80316b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80316e:	c9                   	leaveq 
  80316f:	c3                   	retq   

0000000000803170 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803170:	55                   	push   %rbp
  803171:	48 89 e5             	mov    %rsp,%rbp
  803174:	48 83 ec 10          	sub    $0x10,%rsp
  803178:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80317b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80317f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803186:	00 00 00 
  803189:	8b 00                	mov    (%rax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	75 1f                	jne    8031ae <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80318f:	bf 01 00 00 00       	mov    $0x1,%edi
  803194:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  80319b:	00 00 00 
  80319e:	ff d0                	callq  *%rax
  8031a0:	89 c2                	mov    %eax,%edx
  8031a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031a9:	00 00 00 
  8031ac:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8031ae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031b5:	00 00 00 
  8031b8:	8b 00                	mov    (%rax),%eax
  8031ba:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031bd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031c2:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8031c9:	00 00 00 
  8031cc:	89 c7                	mov    %eax,%edi
  8031ce:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8031da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031de:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e3:	48 89 c6             	mov    %rax,%rsi
  8031e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8031eb:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
}
  8031f7:	c9                   	leaveq 
  8031f8:	c3                   	retq   

00000000008031f9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8031f9:	55                   	push   %rbp
  8031fa:	48 89 e5             	mov    %rsp,%rbp
  8031fd:	48 83 ec 20          	sub    $0x20,%rsp
  803201:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803205:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320c:	48 89 c7             	mov    %rax,%rdi
  80320f:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  803216:	00 00 00 
  803219:	ff d0                	callq  *%rax
  80321b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803220:	7e 0a                	jle    80322c <open+0x33>
		return -E_BAD_PATH;
  803222:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803227:	e9 a5 00 00 00       	jmpq   8032d1 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80322c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803230:	48 89 c7             	mov    %rax,%rdi
  803233:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
  80323f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803246:	79 08                	jns    803250 <open+0x57>
		return r;
  803248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324b:	e9 81 00 00 00       	jmpq   8032d1 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803250:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803254:	48 89 c6             	mov    %rax,%rsi
  803257:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80325e:	00 00 00 
  803261:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80326d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803274:	00 00 00 
  803277:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80327a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803284:	48 89 c6             	mov    %rax,%rsi
  803287:	bf 01 00 00 00       	mov    $0x1,%edi
  80328c:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80329b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329f:	79 1d                	jns    8032be <open+0xc5>
		fd_close(fd, 0);
  8032a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a5:	be 00 00 00 00       	mov    $0x0,%esi
  8032aa:	48 89 c7             	mov    %rax,%rdi
  8032ad:	48 b8 7b 29 80 00 00 	movabs $0x80297b,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
		return r;
  8032b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bc:	eb 13                	jmp    8032d1 <open+0xd8>
	}

	return fd2num(fd);
  8032be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c2:	48 89 c7             	mov    %rax,%rdi
  8032c5:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax

}
  8032d1:	c9                   	leaveq 
  8032d2:	c3                   	retq   

00000000008032d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8032d3:	55                   	push   %rbp
  8032d4:	48 89 e5             	mov    %rsp,%rbp
  8032d7:	48 83 ec 10          	sub    $0x10,%rsp
  8032db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8032e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ed:	00 00 00 
  8032f0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032f2:	be 00 00 00 00       	mov    $0x0,%esi
  8032f7:	bf 06 00 00 00       	mov    $0x6,%edi
  8032fc:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
}
  803308:	c9                   	leaveq 
  803309:	c3                   	retq   

000000000080330a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80330a:	55                   	push   %rbp
  80330b:	48 89 e5             	mov    %rsp,%rbp
  80330e:	48 83 ec 30          	sub    $0x30,%rsp
  803312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803316:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80331a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80331e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803322:	8b 50 0c             	mov    0xc(%rax),%edx
  803325:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80332c:	00 00 00 
  80332f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803331:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803338:	00 00 00 
  80333b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80333f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803343:	be 00 00 00 00       	mov    $0x0,%esi
  803348:	bf 03 00 00 00       	mov    $0x3,%edi
  80334d:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803360:	79 08                	jns    80336a <devfile_read+0x60>
		return r;
  803362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803365:	e9 a4 00 00 00       	jmpq   80340e <devfile_read+0x104>
	assert(r <= n);
  80336a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336d:	48 98                	cltq   
  80336f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803373:	76 35                	jbe    8033aa <devfile_read+0xa0>
  803375:	48 b9 56 52 80 00 00 	movabs $0x805256,%rcx
  80337c:	00 00 00 
  80337f:	48 ba 5d 52 80 00 00 	movabs $0x80525d,%rdx
  803386:	00 00 00 
  803389:	be 86 00 00 00       	mov    $0x86,%esi
  80338e:	48 bf 72 52 80 00 00 	movabs $0x805272,%rdi
  803395:	00 00 00 
  803398:	b8 00 00 00 00       	mov    $0x0,%eax
  80339d:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8033a4:	00 00 00 
  8033a7:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8033aa:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8033b1:	7e 35                	jle    8033e8 <devfile_read+0xde>
  8033b3:	48 b9 7d 52 80 00 00 	movabs $0x80527d,%rcx
  8033ba:	00 00 00 
  8033bd:	48 ba 5d 52 80 00 00 	movabs $0x80525d,%rdx
  8033c4:	00 00 00 
  8033c7:	be 87 00 00 00       	mov    $0x87,%esi
  8033cc:	48 bf 72 52 80 00 00 	movabs $0x805272,%rdi
  8033d3:	00 00 00 
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033db:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8033e2:	00 00 00 
  8033e5:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8033e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033eb:	48 63 d0             	movslq %eax,%rdx
  8033ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f2:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033f9:	00 00 00 
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
	return r;
  80340b:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80340e:	c9                   	leaveq 
  80340f:	c3                   	retq   

0000000000803410 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803410:	55                   	push   %rbp
  803411:	48 89 e5             	mov    %rsp,%rbp
  803414:	48 83 ec 40          	sub    $0x40,%rsp
  803418:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80341c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803420:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803424:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803428:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80342c:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803433:	00 
  803434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803438:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80343c:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803441:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803449:	8b 50 0c             	mov    0xc(%rax),%edx
  80344c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803453:	00 00 00 
  803456:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803458:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80345f:	00 00 00 
  803462:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803466:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80346a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80346e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803472:	48 89 c6             	mov    %rax,%rsi
  803475:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80347c:	00 00 00 
  80347f:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80348b:	be 00 00 00 00       	mov    $0x0,%esi
  803490:	bf 04 00 00 00       	mov    $0x4,%edi
  803495:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
  8034a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034a8:	79 05                	jns    8034af <devfile_write+0x9f>
		return r;
  8034aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ad:	eb 43                	jmp    8034f2 <devfile_write+0xe2>
	assert(r <= n);
  8034af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b2:	48 98                	cltq   
  8034b4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034b8:	76 35                	jbe    8034ef <devfile_write+0xdf>
  8034ba:	48 b9 56 52 80 00 00 	movabs $0x805256,%rcx
  8034c1:	00 00 00 
  8034c4:	48 ba 5d 52 80 00 00 	movabs $0x80525d,%rdx
  8034cb:	00 00 00 
  8034ce:	be a2 00 00 00       	mov    $0xa2,%esi
  8034d3:	48 bf 72 52 80 00 00 	movabs $0x805272,%rdi
  8034da:	00 00 00 
  8034dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e2:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8034e9:	00 00 00 
  8034ec:	41 ff d0             	callq  *%r8
	return r;
  8034ef:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8034f2:	c9                   	leaveq 
  8034f3:	c3                   	retq   

00000000008034f4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8034f4:	55                   	push   %rbp
  8034f5:	48 89 e5             	mov    %rsp,%rbp
  8034f8:	48 83 ec 20          	sub    $0x20,%rsp
  8034fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803508:	8b 50 0c             	mov    0xc(%rax),%edx
  80350b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803512:	00 00 00 
  803515:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803517:	be 00 00 00 00       	mov    $0x0,%esi
  80351c:	bf 05 00 00 00       	mov    $0x5,%edi
  803521:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
  80352d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803534:	79 05                	jns    80353b <devfile_stat+0x47>
		return r;
  803536:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803539:	eb 56                	jmp    803591 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80353b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803546:	00 00 00 
  803549:	48 89 c7             	mov    %rax,%rdi
  80354c:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803553:	00 00 00 
  803556:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803558:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80355f:	00 00 00 
  803562:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803572:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803579:	00 00 00 
  80357c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803582:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803586:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80358c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803591:	c9                   	leaveq 
  803592:	c3                   	retq   

0000000000803593 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803593:	55                   	push   %rbp
  803594:	48 89 e5             	mov    %rsp,%rbp
  803597:	48 83 ec 10          	sub    $0x10,%rsp
  80359b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80359f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8035a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8035a9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035b0:	00 00 00 
  8035b3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8035b5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035bc:	00 00 00 
  8035bf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035c2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8035c5:	be 00 00 00 00       	mov    $0x0,%esi
  8035ca:	bf 02 00 00 00       	mov    $0x2,%edi
  8035cf:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
}
  8035db:	c9                   	leaveq 
  8035dc:	c3                   	retq   

00000000008035dd <remove>:

// Delete a file
int
remove(const char *path)
{
  8035dd:	55                   	push   %rbp
  8035de:	48 89 e5             	mov    %rsp,%rbp
  8035e1:	48 83 ec 10          	sub    $0x10,%rsp
  8035e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8035e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ed:	48 89 c7             	mov    %rax,%rdi
  8035f0:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803601:	7e 07                	jle    80360a <remove+0x2d>
		return -E_BAD_PATH;
  803603:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803608:	eb 33                	jmp    80363d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80360a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360e:	48 89 c6             	mov    %rax,%rsi
  803611:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803618:	00 00 00 
  80361b:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803627:	be 00 00 00 00       	mov    $0x0,%esi
  80362c:	bf 07 00 00 00       	mov    $0x7,%edi
  803631:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
}
  80363d:	c9                   	leaveq 
  80363e:	c3                   	retq   

000000000080363f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80363f:	55                   	push   %rbp
  803640:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803643:	be 00 00 00 00       	mov    $0x0,%esi
  803648:	bf 08 00 00 00       	mov    $0x8,%edi
  80364d:	48 b8 70 31 80 00 00 	movabs $0x803170,%rax
  803654:	00 00 00 
  803657:	ff d0                	callq  *%rax
}
  803659:	5d                   	pop    %rbp
  80365a:	c3                   	retq   

000000000080365b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80365b:	55                   	push   %rbp
  80365c:	48 89 e5             	mov    %rsp,%rbp
  80365f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803666:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80366d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803674:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80367b:	be 00 00 00 00       	mov    $0x0,%esi
  803680:	48 89 c7             	mov    %rax,%rdi
  803683:	48 b8 f9 31 80 00 00 	movabs $0x8031f9,%rax
  80368a:	00 00 00 
  80368d:	ff d0                	callq  *%rax
  80368f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803692:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803696:	79 28                	jns    8036c0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369b:	89 c6                	mov    %eax,%esi
  80369d:	48 bf 89 52 80 00 00 	movabs $0x805289,%rdi
  8036a4:	00 00 00 
  8036a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ac:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  8036b3:	00 00 00 
  8036b6:	ff d2                	callq  *%rdx
		return fd_src;
  8036b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bb:	e9 76 01 00 00       	jmpq   803836 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8036c0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8036c7:	be 01 01 00 00       	mov    $0x101,%esi
  8036cc:	48 89 c7             	mov    %rax,%rdi
  8036cf:	48 b8 f9 31 80 00 00 	movabs $0x8031f9,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
  8036db:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8036de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036e2:	0f 89 ad 00 00 00    	jns    803795 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8036e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036eb:	89 c6                	mov    %eax,%esi
  8036ed:	48 bf 9f 52 80 00 00 	movabs $0x80529f,%rdi
  8036f4:	00 00 00 
  8036f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fc:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  803703:	00 00 00 
  803706:	ff d2                	callq  *%rdx
		close(fd_src);
  803708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370b:	89 c7                	mov    %eax,%edi
  80370d:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
		return fd_dest;
  803719:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80371c:	e9 15 01 00 00       	jmpq   803836 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803721:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803724:	48 63 d0             	movslq %eax,%rdx
  803727:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80372e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803731:	48 89 ce             	mov    %rcx,%rsi
  803734:	89 c7                	mov    %eax,%edi
  803736:	48 b8 6b 2e 80 00 00 	movabs $0x802e6b,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
  803742:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803745:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803749:	79 4a                	jns    803795 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  80374b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80374e:	89 c6                	mov    %eax,%esi
  803750:	48 bf b9 52 80 00 00 	movabs $0x8052b9,%rdi
  803757:	00 00 00 
  80375a:	b8 00 00 00 00       	mov    $0x0,%eax
  80375f:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  803766:	00 00 00 
  803769:	ff d2                	callq  *%rdx
			close(fd_src);
  80376b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376e:	89 c7                	mov    %eax,%edi
  803770:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
			close(fd_dest);
  80377c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80377f:	89 c7                	mov    %eax,%edi
  803781:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
			return write_size;
  80378d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803790:	e9 a1 00 00 00       	jmpq   803836 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803795:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80379c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379f:	ba 00 02 00 00       	mov    $0x200,%edx
  8037a4:	48 89 ce             	mov    %rcx,%rsi
  8037a7:	89 c7                	mov    %eax,%edi
  8037a9:	48 b8 20 2d 80 00 00 	movabs $0x802d20,%rax
  8037b0:	00 00 00 
  8037b3:	ff d0                	callq  *%rax
  8037b5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8037b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037bc:	0f 8f 5f ff ff ff    	jg     803721 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8037c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037c6:	79 47                	jns    80380f <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8037c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037cb:	89 c6                	mov    %eax,%esi
  8037cd:	48 bf cc 52 80 00 00 	movabs $0x8052cc,%rdi
  8037d4:	00 00 00 
  8037d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dc:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  8037e3:	00 00 00 
  8037e6:	ff d2                	callq  *%rdx
		close(fd_src);
  8037e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037eb:	89 c7                	mov    %eax,%edi
  8037ed:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
		close(fd_dest);
  8037f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037fc:	89 c7                	mov    %eax,%edi
  8037fe:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
		return read_size;
  80380a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80380d:	eb 27                	jmp    803836 <copy+0x1db>
	}
	close(fd_src);
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	89 c7                	mov    %eax,%edi
  803814:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  80381b:	00 00 00 
  80381e:	ff d0                	callq  *%rax
	close(fd_dest);
  803820:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803823:	89 c7                	mov    %eax,%edi
  803825:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  80382c:	00 00 00 
  80382f:	ff d0                	callq  *%rax
	return 0;
  803831:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803836:	c9                   	leaveq 
  803837:	c3                   	retq   

0000000000803838 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  803838:	55                   	push   %rbp
  803839:	48 89 e5             	mov    %rsp,%rbp
  80383c:	48 83 ec 18          	sub    $0x18,%rsp
  803840:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803844:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803848:	48 c1 e8 15          	shr    $0x15,%rax
  80384c:	48 89 c2             	mov    %rax,%rdx
  80384f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803856:	01 00 00 
  803859:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80385d:	83 e0 01             	and    $0x1,%eax
  803860:	48 85 c0             	test   %rax,%rax
  803863:	75 07                	jne    80386c <pageref+0x34>
		return 0;
  803865:	b8 00 00 00 00       	mov    $0x0,%eax
  80386a:	eb 56                	jmp    8038c2 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  80386c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803870:	48 c1 e8 0c          	shr    $0xc,%rax
  803874:	48 89 c2             	mov    %rax,%rdx
  803877:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80387e:	01 00 00 
  803881:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803885:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388d:	83 e0 01             	and    $0x1,%eax
  803890:	48 85 c0             	test   %rax,%rax
  803893:	75 07                	jne    80389c <pageref+0x64>
		return 0;
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	eb 26                	jmp    8038c2 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  80389c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8038a4:	48 89 c2             	mov    %rax,%rdx
  8038a7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8038ae:	00 00 00 
  8038b1:	48 c1 e2 04          	shl    $0x4,%rdx
  8038b5:	48 01 d0             	add    %rdx,%rax
  8038b8:	48 83 c0 08          	add    $0x8,%rax
  8038bc:	0f b7 00             	movzwl (%rax),%eax
  8038bf:	0f b7 c0             	movzwl %ax,%eax
}
  8038c2:	c9                   	leaveq 
  8038c3:	c3                   	retq   

00000000008038c4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8038c4:	55                   	push   %rbp
  8038c5:	48 89 e5             	mov    %rsp,%rbp
  8038c8:	48 83 ec 20          	sub    $0x20,%rsp
  8038cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8038cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038d6:	48 89 d6             	mov    %rdx,%rsi
  8038d9:	89 c7                	mov    %eax,%edi
  8038db:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  8038e2:	00 00 00 
  8038e5:	ff d0                	callq  *%rax
  8038e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ee:	79 05                	jns    8038f5 <fd2sockid+0x31>
		return r;
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f3:	eb 24                	jmp    803919 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8038f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f9:	8b 10                	mov    (%rax),%edx
  8038fb:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803902:	00 00 00 
  803905:	8b 00                	mov    (%rax),%eax
  803907:	39 c2                	cmp    %eax,%edx
  803909:	74 07                	je     803912 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80390b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803910:	eb 07                	jmp    803919 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803916:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803919:	c9                   	leaveq 
  80391a:	c3                   	retq   

000000000080391b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80391b:	55                   	push   %rbp
  80391c:	48 89 e5             	mov    %rsp,%rbp
  80391f:	48 83 ec 20          	sub    $0x20,%rsp
  803923:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803926:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80392a:	48 89 c7             	mov    %rax,%rdi
  80392d:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
  803939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803940:	78 26                	js     803968 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803946:	ba 07 04 00 00       	mov    $0x407,%edx
  80394b:	48 89 c6             	mov    %rax,%rsi
  80394e:	bf 00 00 00 00       	mov    $0x0,%edi
  803953:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80395a:	00 00 00 
  80395d:	ff d0                	callq  *%rax
  80395f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803962:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803966:	79 16                	jns    80397e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803968:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80396b:	89 c7                	mov    %eax,%edi
  80396d:	48 b8 2a 3e 80 00 00 	movabs $0x803e2a,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
		return r;
  803979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397c:	eb 3a                	jmp    8039b8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80397e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803982:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803989:	00 00 00 
  80398c:	8b 12                	mov    (%rdx),%edx
  80398e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803990:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803994:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80399b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039a2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8039a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a9:	48 89 c7             	mov    %rax,%rdi
  8039ac:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  8039b3:	00 00 00 
  8039b6:	ff d0                	callq  *%rax
}
  8039b8:	c9                   	leaveq 
  8039b9:	c3                   	retq   

00000000008039ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039ba:	55                   	push   %rbp
  8039bb:	48 89 e5             	mov    %rsp,%rbp
  8039be:	48 83 ec 30          	sub    $0x30,%rsp
  8039c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039d0:	89 c7                	mov    %eax,%edi
  8039d2:	48 b8 c4 38 80 00 00 	movabs $0x8038c4,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
  8039de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e5:	79 05                	jns    8039ec <accept+0x32>
		return r;
  8039e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ea:	eb 3b                	jmp    803a27 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8039ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8039f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f7:	48 89 ce             	mov    %rcx,%rsi
  8039fa:	89 c7                	mov    %eax,%edi
  8039fc:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  803a03:	00 00 00 
  803a06:	ff d0                	callq  *%rax
  803a08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a0f:	79 05                	jns    803a16 <accept+0x5c>
		return r;
  803a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a14:	eb 11                	jmp    803a27 <accept+0x6d>
	return alloc_sockfd(r);
  803a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a19:	89 c7                	mov    %eax,%edi
  803a1b:	48 b8 1b 39 80 00 00 	movabs $0x80391b,%rax
  803a22:	00 00 00 
  803a25:	ff d0                	callq  *%rax
}
  803a27:	c9                   	leaveq 
  803a28:	c3                   	retq   

0000000000803a29 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a29:	55                   	push   %rbp
  803a2a:	48 89 e5             	mov    %rsp,%rbp
  803a2d:	48 83 ec 20          	sub    $0x20,%rsp
  803a31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a38:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a3e:	89 c7                	mov    %eax,%edi
  803a40:	48 b8 c4 38 80 00 00 	movabs $0x8038c4,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a53:	79 05                	jns    803a5a <bind+0x31>
		return r;
  803a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a58:	eb 1b                	jmp    803a75 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803a5a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a5d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a64:	48 89 ce             	mov    %rcx,%rsi
  803a67:	89 c7                	mov    %eax,%edi
  803a69:	48 b8 86 3d 80 00 00 	movabs $0x803d86,%rax
  803a70:	00 00 00 
  803a73:	ff d0                	callq  *%rax
}
  803a75:	c9                   	leaveq 
  803a76:	c3                   	retq   

0000000000803a77 <shutdown>:

int
shutdown(int s, int how)
{
  803a77:	55                   	push   %rbp
  803a78:	48 89 e5             	mov    %rsp,%rbp
  803a7b:	48 83 ec 20          	sub    $0x20,%rsp
  803a7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a82:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a88:	89 c7                	mov    %eax,%edi
  803a8a:	48 b8 c4 38 80 00 00 	movabs $0x8038c4,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a9d:	79 05                	jns    803aa4 <shutdown+0x2d>
		return r;
  803a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa2:	eb 16                	jmp    803aba <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803aa4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aaa:	89 d6                	mov    %edx,%esi
  803aac:	89 c7                	mov    %eax,%edi
  803aae:	48 b8 ea 3d 80 00 00 	movabs $0x803dea,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
}
  803aba:	c9                   	leaveq 
  803abb:	c3                   	retq   

0000000000803abc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803abc:	55                   	push   %rbp
  803abd:	48 89 e5             	mov    %rsp,%rbp
  803ac0:	48 83 ec 10          	sub    $0x10,%rsp
  803ac4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803ac8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803acc:	48 89 c7             	mov    %rax,%rdi
  803acf:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
  803adb:	83 f8 01             	cmp    $0x1,%eax
  803ade:	75 17                	jne    803af7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae4:	8b 40 0c             	mov    0xc(%rax),%eax
  803ae7:	89 c7                	mov    %eax,%edi
  803ae9:	48 b8 2a 3e 80 00 00 	movabs $0x803e2a,%rax
  803af0:	00 00 00 
  803af3:	ff d0                	callq  *%rax
  803af5:	eb 05                	jmp    803afc <devsock_close+0x40>
	else
		return 0;
  803af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803afc:	c9                   	leaveq 
  803afd:	c3                   	retq   

0000000000803afe <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803afe:	55                   	push   %rbp
  803aff:	48 89 e5             	mov    %rsp,%rbp
  803b02:	48 83 ec 20          	sub    $0x20,%rsp
  803b06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b0d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b13:	89 c7                	mov    %eax,%edi
  803b15:	48 b8 c4 38 80 00 00 	movabs $0x8038c4,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b28:	79 05                	jns    803b2f <connect+0x31>
		return r;
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	eb 1b                	jmp    803b4a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803b2f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b32:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b39:	48 89 ce             	mov    %rcx,%rsi
  803b3c:	89 c7                	mov    %eax,%edi
  803b3e:	48 b8 57 3e 80 00 00 	movabs $0x803e57,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
}
  803b4a:	c9                   	leaveq 
  803b4b:	c3                   	retq   

0000000000803b4c <listen>:

int
listen(int s, int backlog)
{
  803b4c:	55                   	push   %rbp
  803b4d:	48 89 e5             	mov    %rsp,%rbp
  803b50:	48 83 ec 20          	sub    $0x20,%rsp
  803b54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b57:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b5d:	89 c7                	mov    %eax,%edi
  803b5f:	48 b8 c4 38 80 00 00 	movabs $0x8038c4,%rax
  803b66:	00 00 00 
  803b69:	ff d0                	callq  *%rax
  803b6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b72:	79 05                	jns    803b79 <listen+0x2d>
		return r;
  803b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b77:	eb 16                	jmp    803b8f <listen+0x43>
	return nsipc_listen(r, backlog);
  803b79:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7f:	89 d6                	mov    %edx,%esi
  803b81:	89 c7                	mov    %eax,%edi
  803b83:	48 b8 bb 3e 80 00 00 	movabs $0x803ebb,%rax
  803b8a:	00 00 00 
  803b8d:	ff d0                	callq  *%rax
}
  803b8f:	c9                   	leaveq 
  803b90:	c3                   	retq   

0000000000803b91 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803b91:	55                   	push   %rbp
  803b92:	48 89 e5             	mov    %rsp,%rbp
  803b95:	48 83 ec 20          	sub    $0x20,%rsp
  803b99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ba1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba9:	89 c2                	mov    %eax,%edx
  803bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803baf:	8b 40 0c             	mov    0xc(%rax),%eax
  803bb2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803bb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  803bbb:	89 c7                	mov    %eax,%edi
  803bbd:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  803bc4:	00 00 00 
  803bc7:	ff d0                	callq  *%rax
}
  803bc9:	c9                   	leaveq 
  803bca:	c3                   	retq   

0000000000803bcb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803bcb:	55                   	push   %rbp
  803bcc:	48 89 e5             	mov    %rsp,%rbp
  803bcf:	48 83 ec 20          	sub    $0x20,%rsp
  803bd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803bd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bdb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803bdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be3:	89 c2                	mov    %eax,%edx
  803be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be9:	8b 40 0c             	mov    0xc(%rax),%eax
  803bec:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803bf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  803bf5:	89 c7                	mov    %eax,%edi
  803bf7:	48 b8 c7 3f 80 00 00 	movabs $0x803fc7,%rax
  803bfe:	00 00 00 
  803c01:	ff d0                	callq  *%rax
}
  803c03:	c9                   	leaveq 
  803c04:	c3                   	retq   

0000000000803c05 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c05:	55                   	push   %rbp
  803c06:	48 89 e5             	mov    %rsp,%rbp
  803c09:	48 83 ec 10          	sub    $0x10,%rsp
  803c0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c19:	48 be e7 52 80 00 00 	movabs $0x8052e7,%rsi
  803c20:	00 00 00 
  803c23:	48 89 c7             	mov    %rax,%rdi
  803c26:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803c2d:	00 00 00 
  803c30:	ff d0                	callq  *%rax
	return 0;
  803c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c37:	c9                   	leaveq 
  803c38:	c3                   	retq   

0000000000803c39 <socket>:

int
socket(int domain, int type, int protocol)
{
  803c39:	55                   	push   %rbp
  803c3a:	48 89 e5             	mov    %rsp,%rbp
  803c3d:	48 83 ec 20          	sub    $0x20,%rsp
  803c41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c44:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c47:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803c4a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803c4d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c53:	89 ce                	mov    %ecx,%esi
  803c55:	89 c7                	mov    %eax,%edi
  803c57:	48 b8 7f 40 80 00 00 	movabs $0x80407f,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
  803c63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6a:	79 05                	jns    803c71 <socket+0x38>
		return r;
  803c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6f:	eb 11                	jmp    803c82 <socket+0x49>
	return alloc_sockfd(r);
  803c71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c74:	89 c7                	mov    %eax,%edi
  803c76:	48 b8 1b 39 80 00 00 	movabs $0x80391b,%rax
  803c7d:	00 00 00 
  803c80:	ff d0                	callq  *%rax
}
  803c82:	c9                   	leaveq 
  803c83:	c3                   	retq   

0000000000803c84 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803c84:	55                   	push   %rbp
  803c85:	48 89 e5             	mov    %rsp,%rbp
  803c88:	48 83 ec 10          	sub    $0x10,%rsp
  803c8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803c8f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803c96:	00 00 00 
  803c99:	8b 00                	mov    (%rax),%eax
  803c9b:	85 c0                	test   %eax,%eax
  803c9d:	75 1f                	jne    803cbe <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803c9f:	bf 02 00 00 00       	mov    $0x2,%edi
  803ca4:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  803cab:	00 00 00 
  803cae:	ff d0                	callq  *%rax
  803cb0:	89 c2                	mov    %eax,%edx
  803cb2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803cb9:	00 00 00 
  803cbc:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803cbe:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803cc5:	00 00 00 
  803cc8:	8b 00                	mov    (%rax),%eax
  803cca:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ccd:	b9 07 00 00 00       	mov    $0x7,%ecx
  803cd2:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803cd9:	00 00 00 
  803cdc:	89 c7                	mov    %eax,%edi
  803cde:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803cea:	ba 00 00 00 00       	mov    $0x0,%edx
  803cef:	be 00 00 00 00       	mov    $0x0,%esi
  803cf4:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf9:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  803d00:	00 00 00 
  803d03:	ff d0                	callq  *%rax
}
  803d05:	c9                   	leaveq 
  803d06:	c3                   	retq   

0000000000803d07 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d07:	55                   	push   %rbp
  803d08:	48 89 e5             	mov    %rsp,%rbp
  803d0b:	48 83 ec 30          	sub    $0x30,%rsp
  803d0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d16:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803d1a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d21:	00 00 00 
  803d24:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d27:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803d29:	bf 01 00 00 00       	mov    $0x1,%edi
  803d2e:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
  803d3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d41:	78 3e                	js     803d81 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803d43:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4a:	00 00 00 
  803d4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803d51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d55:	8b 40 10             	mov    0x10(%rax),%eax
  803d58:	89 c2                	mov    %eax,%edx
  803d5a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803d5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d62:	48 89 ce             	mov    %rcx,%rsi
  803d65:	48 89 c7             	mov    %rax,%rdi
  803d68:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d78:	8b 50 10             	mov    0x10(%rax),%edx
  803d7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d84:	c9                   	leaveq 
  803d85:	c3                   	retq   

0000000000803d86 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803d86:	55                   	push   %rbp
  803d87:	48 89 e5             	mov    %rsp,%rbp
  803d8a:	48 83 ec 10          	sub    $0x10,%rsp
  803d8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d95:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803d98:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9f:	00 00 00 
  803da2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803da5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803da7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dae:	48 89 c6             	mov    %rax,%rsi
  803db1:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803db8:	00 00 00 
  803dbb:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803dc7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dce:	00 00 00 
  803dd1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dd4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803dd7:	bf 02 00 00 00       	mov    $0x2,%edi
  803ddc:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803de3:	00 00 00 
  803de6:	ff d0                	callq  *%rax
}
  803de8:	c9                   	leaveq 
  803de9:	c3                   	retq   

0000000000803dea <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803dea:	55                   	push   %rbp
  803deb:	48 89 e5             	mov    %rsp,%rbp
  803dee:	48 83 ec 10          	sub    $0x10,%rsp
  803df2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803df5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803df8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dff:	00 00 00 
  803e02:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e05:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803e07:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0e:	00 00 00 
  803e11:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e14:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803e17:	bf 03 00 00 00       	mov    $0x3,%edi
  803e1c:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803e23:	00 00 00 
  803e26:	ff d0                	callq  *%rax
}
  803e28:	c9                   	leaveq 
  803e29:	c3                   	retq   

0000000000803e2a <nsipc_close>:

int
nsipc_close(int s)
{
  803e2a:	55                   	push   %rbp
  803e2b:	48 89 e5             	mov    %rsp,%rbp
  803e2e:	48 83 ec 10          	sub    $0x10,%rsp
  803e32:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803e35:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e3c:	00 00 00 
  803e3f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e42:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803e44:	bf 04 00 00 00       	mov    $0x4,%edi
  803e49:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803e50:	00 00 00 
  803e53:	ff d0                	callq  *%rax
}
  803e55:	c9                   	leaveq 
  803e56:	c3                   	retq   

0000000000803e57 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803e57:	55                   	push   %rbp
  803e58:	48 89 e5             	mov    %rsp,%rbp
  803e5b:	48 83 ec 10          	sub    $0x10,%rsp
  803e5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e66:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803e69:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e70:	00 00 00 
  803e73:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e76:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803e78:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7f:	48 89 c6             	mov    %rax,%rsi
  803e82:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e89:	00 00 00 
  803e8c:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803e93:	00 00 00 
  803e96:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803e98:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e9f:	00 00 00 
  803ea2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ea5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803ea8:	bf 05 00 00 00       	mov    $0x5,%edi
  803ead:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
}
  803eb9:	c9                   	leaveq 
  803eba:	c3                   	retq   

0000000000803ebb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ebb:	55                   	push   %rbp
  803ebc:	48 89 e5             	mov    %rsp,%rbp
  803ebf:	48 83 ec 10          	sub    $0x10,%rsp
  803ec3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ec6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ec9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed0:	00 00 00 
  803ed3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ed6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803ed8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803edf:	00 00 00 
  803ee2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ee5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ee8:	bf 06 00 00 00       	mov    $0x6,%edi
  803eed:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803ef4:	00 00 00 
  803ef7:	ff d0                	callq  *%rax
}
  803ef9:	c9                   	leaveq 
  803efa:	c3                   	retq   

0000000000803efb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803efb:	55                   	push   %rbp
  803efc:	48 89 e5             	mov    %rsp,%rbp
  803eff:	48 83 ec 30          	sub    $0x30,%rsp
  803f03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f0a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803f0d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803f10:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f17:	00 00 00 
  803f1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f1d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803f1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f26:	00 00 00 
  803f29:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f2c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803f2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f36:	00 00 00 
  803f39:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f3c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803f3f:	bf 07 00 00 00       	mov    $0x7,%edi
  803f44:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
  803f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f57:	78 69                	js     803fc2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803f59:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803f60:	7f 08                	jg     803f6a <nsipc_recv+0x6f>
  803f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f65:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803f68:	7e 35                	jle    803f9f <nsipc_recv+0xa4>
  803f6a:	48 b9 ee 52 80 00 00 	movabs $0x8052ee,%rcx
  803f71:	00 00 00 
  803f74:	48 ba 03 53 80 00 00 	movabs $0x805303,%rdx
  803f7b:	00 00 00 
  803f7e:	be 62 00 00 00       	mov    $0x62,%esi
  803f83:	48 bf 18 53 80 00 00 	movabs $0x805318,%rdi
  803f8a:	00 00 00 
  803f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f92:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  803f99:	00 00 00 
  803f9c:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa2:	48 63 d0             	movslq %eax,%rdx
  803fa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fa9:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803fb0:	00 00 00 
  803fb3:	48 89 c7             	mov    %rax,%rdi
  803fb6:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803fbd:	00 00 00 
  803fc0:	ff d0                	callq  *%rax
	}

	return r;
  803fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fc5:	c9                   	leaveq 
  803fc6:	c3                   	retq   

0000000000803fc7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803fc7:	55                   	push   %rbp
  803fc8:	48 89 e5             	mov    %rsp,%rbp
  803fcb:	48 83 ec 20          	sub    $0x20,%rsp
  803fcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fd6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803fd9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803fdc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fe3:	00 00 00 
  803fe6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fe9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803feb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ff2:	7e 35                	jle    804029 <nsipc_send+0x62>
  803ff4:	48 b9 24 53 80 00 00 	movabs $0x805324,%rcx
  803ffb:	00 00 00 
  803ffe:	48 ba 03 53 80 00 00 	movabs $0x805303,%rdx
  804005:	00 00 00 
  804008:	be 6d 00 00 00       	mov    $0x6d,%esi
  80400d:	48 bf 18 53 80 00 00 	movabs $0x805318,%rdi
  804014:	00 00 00 
  804017:	b8 00 00 00 00       	mov    $0x0,%eax
  80401c:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  804023:	00 00 00 
  804026:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804029:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80402c:	48 63 d0             	movslq %eax,%rdx
  80402f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804033:	48 89 c6             	mov    %rax,%rsi
  804036:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  80403d:	00 00 00 
  804040:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  804047:	00 00 00 
  80404a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80404c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804053:	00 00 00 
  804056:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804059:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80405c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804063:	00 00 00 
  804066:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804069:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80406c:	bf 08 00 00 00       	mov    $0x8,%edi
  804071:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  804078:	00 00 00 
  80407b:	ff d0                	callq  *%rax
}
  80407d:	c9                   	leaveq 
  80407e:	c3                   	retq   

000000000080407f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80407f:	55                   	push   %rbp
  804080:	48 89 e5             	mov    %rsp,%rbp
  804083:	48 83 ec 10          	sub    $0x10,%rsp
  804087:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80408a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80408d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804090:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804097:	00 00 00 
  80409a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80409d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80409f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a6:	00 00 00 
  8040a9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040ac:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8040af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040b6:	00 00 00 
  8040b9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8040bc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8040bf:	bf 09 00 00 00       	mov    $0x9,%edi
  8040c4:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  8040cb:	00 00 00 
  8040ce:	ff d0                	callq  *%rax
}
  8040d0:	c9                   	leaveq 
  8040d1:	c3                   	retq   

00000000008040d2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8040d2:	55                   	push   %rbp
  8040d3:	48 89 e5             	mov    %rsp,%rbp
  8040d6:	53                   	push   %rbx
  8040d7:	48 83 ec 38          	sub    $0x38,%rsp
  8040db:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8040df:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8040e3:	48 89 c7             	mov    %rax,%rdi
  8040e6:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
  8040f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040f9:	0f 88 bf 01 00 00    	js     8042be <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804103:	ba 07 04 00 00       	mov    $0x407,%edx
  804108:	48 89 c6             	mov    %rax,%rsi
  80410b:	bf 00 00 00 00       	mov    $0x0,%edi
  804110:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  804117:	00 00 00 
  80411a:	ff d0                	callq  *%rax
  80411c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80411f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804123:	0f 88 95 01 00 00    	js     8042be <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804129:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80412d:	48 89 c7             	mov    %rax,%rdi
  804130:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  804137:	00 00 00 
  80413a:	ff d0                	callq  *%rax
  80413c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80413f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804143:	0f 88 5d 01 00 00    	js     8042a6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804149:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80414d:	ba 07 04 00 00       	mov    $0x407,%edx
  804152:	48 89 c6             	mov    %rax,%rsi
  804155:	bf 00 00 00 00       	mov    $0x0,%edi
  80415a:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
  804166:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804169:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80416d:	0f 88 33 01 00 00    	js     8042a6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804173:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804177:	48 89 c7             	mov    %rax,%rdi
  80417a:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  804181:	00 00 00 
  804184:	ff d0                	callq  *%rax
  804186:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80418a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80418e:	ba 07 04 00 00       	mov    $0x407,%edx
  804193:	48 89 c6             	mov    %rax,%rsi
  804196:	bf 00 00 00 00       	mov    $0x0,%edi
  80419b:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8041a2:	00 00 00 
  8041a5:	ff d0                	callq  *%rax
  8041a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041ae:	0f 88 d9 00 00 00    	js     80428d <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b8:	48 89 c7             	mov    %rax,%rdi
  8041bb:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  8041c2:	00 00 00 
  8041c5:	ff d0                	callq  *%rax
  8041c7:	48 89 c2             	mov    %rax,%rdx
  8041ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ce:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8041d4:	48 89 d1             	mov    %rdx,%rcx
  8041d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8041dc:	48 89 c6             	mov    %rax,%rsi
  8041df:	bf 00 00 00 00       	mov    $0x0,%edi
  8041e4:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  8041eb:	00 00 00 
  8041ee:	ff d0                	callq  *%rax
  8041f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041f7:	78 79                	js     804272 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8041f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041fd:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804204:	00 00 00 
  804207:	8b 12                	mov    (%rdx),%edx
  804209:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80420b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80420f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804216:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80421a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804221:	00 00 00 
  804224:	8b 12                	mov    (%rdx),%edx
  804226:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804228:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80422c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804237:	48 89 c7             	mov    %rax,%rdi
  80423a:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  804241:	00 00 00 
  804244:	ff d0                	callq  *%rax
  804246:	89 c2                	mov    %eax,%edx
  804248:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80424c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80424e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804252:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804256:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80425a:	48 89 c7             	mov    %rax,%rdi
  80425d:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  804264:	00 00 00 
  804267:	ff d0                	callq  *%rax
  804269:	89 03                	mov    %eax,(%rbx)
	return 0;
  80426b:	b8 00 00 00 00       	mov    $0x0,%eax
  804270:	eb 4f                	jmp    8042c1 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804272:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804277:	48 89 c6             	mov    %rax,%rsi
  80427a:	bf 00 00 00 00       	mov    $0x0,%edi
  80427f:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
  80428b:	eb 01                	jmp    80428e <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80428d:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80428e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804292:	48 89 c6             	mov    %rax,%rsi
  804295:	bf 00 00 00 00       	mov    $0x0,%edi
  80429a:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8042a1:	00 00 00 
  8042a4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8042a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042aa:	48 89 c6             	mov    %rax,%rsi
  8042ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8042b2:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8042b9:	00 00 00 
  8042bc:	ff d0                	callq  *%rax
err:
	return r;
  8042be:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8042c1:	48 83 c4 38          	add    $0x38,%rsp
  8042c5:	5b                   	pop    %rbx
  8042c6:	5d                   	pop    %rbp
  8042c7:	c3                   	retq   

00000000008042c8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8042c8:	55                   	push   %rbp
  8042c9:	48 89 e5             	mov    %rsp,%rbp
  8042cc:	53                   	push   %rbx
  8042cd:	48 83 ec 28          	sub    $0x28,%rsp
  8042d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8042d9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8042e0:	00 00 00 
  8042e3:	48 8b 00             	mov    (%rax),%rax
  8042e6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8042ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8042ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f3:	48 89 c7             	mov    %rax,%rdi
  8042f6:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  8042fd:	00 00 00 
  804300:	ff d0                	callq  *%rax
  804302:	89 c3                	mov    %eax,%ebx
  804304:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804308:	48 89 c7             	mov    %rax,%rdi
  80430b:	48 b8 38 38 80 00 00 	movabs $0x803838,%rax
  804312:	00 00 00 
  804315:	ff d0                	callq  *%rax
  804317:	39 c3                	cmp    %eax,%ebx
  804319:	0f 94 c0             	sete   %al
  80431c:	0f b6 c0             	movzbl %al,%eax
  80431f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804322:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804329:	00 00 00 
  80432c:	48 8b 00             	mov    (%rax),%rax
  80432f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804335:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804338:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80433e:	75 05                	jne    804345 <_pipeisclosed+0x7d>
			return ret;
  804340:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804343:	eb 4a                	jmp    80438f <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804345:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804348:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80434b:	74 8c                	je     8042d9 <_pipeisclosed+0x11>
  80434d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804351:	75 86                	jne    8042d9 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804353:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80435a:	00 00 00 
  80435d:	48 8b 00             	mov    (%rax),%rax
  804360:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804366:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804369:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80436c:	89 c6                	mov    %eax,%esi
  80436e:	48 bf 35 53 80 00 00 	movabs $0x805335,%rdi
  804375:	00 00 00 
  804378:	b8 00 00 00 00       	mov    $0x0,%eax
  80437d:	49 b8 68 06 80 00 00 	movabs $0x800668,%r8
  804384:	00 00 00 
  804387:	41 ff d0             	callq  *%r8
	}
  80438a:	e9 4a ff ff ff       	jmpq   8042d9 <_pipeisclosed+0x11>

}
  80438f:	48 83 c4 28          	add    $0x28,%rsp
  804393:	5b                   	pop    %rbx
  804394:	5d                   	pop    %rbp
  804395:	c3                   	retq   

0000000000804396 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804396:	55                   	push   %rbp
  804397:	48 89 e5             	mov    %rsp,%rbp
  80439a:	48 83 ec 30          	sub    $0x30,%rsp
  80439e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8043a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8043a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043a8:	48 89 d6             	mov    %rdx,%rsi
  8043ab:	89 c7                	mov    %eax,%edi
  8043ad:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
  8043b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043c0:	79 05                	jns    8043c7 <pipeisclosed+0x31>
		return r;
  8043c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c5:	eb 31                	jmp    8043f8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8043c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043cb:	48 89 c7             	mov    %rax,%rdi
  8043ce:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  8043d5:	00 00 00 
  8043d8:	ff d0                	callq  *%rax
  8043da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8043de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043e6:	48 89 d6             	mov    %rdx,%rsi
  8043e9:	48 89 c7             	mov    %rax,%rdi
  8043ec:	48 b8 c8 42 80 00 00 	movabs $0x8042c8,%rax
  8043f3:	00 00 00 
  8043f6:	ff d0                	callq  *%rax
}
  8043f8:	c9                   	leaveq 
  8043f9:	c3                   	retq   

00000000008043fa <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043fa:	55                   	push   %rbp
  8043fb:	48 89 e5             	mov    %rsp,%rbp
  8043fe:	48 83 ec 40          	sub    $0x40,%rsp
  804402:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804406:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80440a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80440e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804412:	48 89 c7             	mov    %rax,%rdi
  804415:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  80441c:	00 00 00 
  80441f:	ff d0                	callq  *%rax
  804421:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804429:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80442d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804434:	00 
  804435:	e9 90 00 00 00       	jmpq   8044ca <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80443a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80443f:	74 09                	je     80444a <devpipe_read+0x50>
				return i;
  804441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804445:	e9 8e 00 00 00       	jmpq   8044d8 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80444a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80444e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804452:	48 89 d6             	mov    %rdx,%rsi
  804455:	48 89 c7             	mov    %rax,%rdi
  804458:	48 b8 c8 42 80 00 00 	movabs $0x8042c8,%rax
  80445f:	00 00 00 
  804462:	ff d0                	callq  *%rax
  804464:	85 c0                	test   %eax,%eax
  804466:	74 07                	je     80446f <devpipe_read+0x75>
				return 0;
  804468:	b8 00 00 00 00       	mov    $0x0,%eax
  80446d:	eb 69                	jmp    8044d8 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80446f:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80447b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447f:	8b 10                	mov    (%rax),%edx
  804481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804485:	8b 40 04             	mov    0x4(%rax),%eax
  804488:	39 c2                	cmp    %eax,%edx
  80448a:	74 ae                	je     80443a <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80448c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804494:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80449c:	8b 00                	mov    (%rax),%eax
  80449e:	99                   	cltd   
  80449f:	c1 ea 1b             	shr    $0x1b,%edx
  8044a2:	01 d0                	add    %edx,%eax
  8044a4:	83 e0 1f             	and    $0x1f,%eax
  8044a7:	29 d0                	sub    %edx,%eax
  8044a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044ad:	48 98                	cltq   
  8044af:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8044b4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8044b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ba:	8b 00                	mov    (%rax),%eax
  8044bc:	8d 50 01             	lea    0x1(%rax),%edx
  8044bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8044c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8044d2:	72 a7                	jb     80447b <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8044d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8044d8:	c9                   	leaveq 
  8044d9:	c3                   	retq   

00000000008044da <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044da:	55                   	push   %rbp
  8044db:	48 89 e5             	mov    %rsp,%rbp
  8044de:	48 83 ec 40          	sub    $0x40,%rsp
  8044e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8044ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044f2:	48 89 c7             	mov    %rax,%rdi
  8044f5:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  8044fc:	00 00 00 
  8044ff:	ff d0                	callq  *%rax
  804501:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804505:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804509:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80450d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804514:	00 
  804515:	e9 8f 00 00 00       	jmpq   8045a9 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80451a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80451e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804522:	48 89 d6             	mov    %rdx,%rsi
  804525:	48 89 c7             	mov    %rax,%rdi
  804528:	48 b8 c8 42 80 00 00 	movabs $0x8042c8,%rax
  80452f:	00 00 00 
  804532:	ff d0                	callq  *%rax
  804534:	85 c0                	test   %eax,%eax
  804536:	74 07                	je     80453f <devpipe_write+0x65>
				return 0;
  804538:	b8 00 00 00 00       	mov    $0x0,%eax
  80453d:	eb 78                	jmp    8045b7 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80453f:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  804546:	00 00 00 
  804549:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80454b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454f:	8b 40 04             	mov    0x4(%rax),%eax
  804552:	48 63 d0             	movslq %eax,%rdx
  804555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804559:	8b 00                	mov    (%rax),%eax
  80455b:	48 98                	cltq   
  80455d:	48 83 c0 20          	add    $0x20,%rax
  804561:	48 39 c2             	cmp    %rax,%rdx
  804564:	73 b4                	jae    80451a <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456a:	8b 40 04             	mov    0x4(%rax),%eax
  80456d:	99                   	cltd   
  80456e:	c1 ea 1b             	shr    $0x1b,%edx
  804571:	01 d0                	add    %edx,%eax
  804573:	83 e0 1f             	and    $0x1f,%eax
  804576:	29 d0                	sub    %edx,%eax
  804578:	89 c6                	mov    %eax,%esi
  80457a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80457e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804582:	48 01 d0             	add    %rdx,%rax
  804585:	0f b6 08             	movzbl (%rax),%ecx
  804588:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80458c:	48 63 c6             	movslq %esi,%rax
  80458f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804597:	8b 40 04             	mov    0x4(%rax),%eax
  80459a:	8d 50 01             	lea    0x1(%rax),%edx
  80459d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045a1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8045a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8045b1:	72 98                	jb     80454b <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8045b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8045b7:	c9                   	leaveq 
  8045b8:	c3                   	retq   

00000000008045b9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8045b9:	55                   	push   %rbp
  8045ba:	48 89 e5             	mov    %rsp,%rbp
  8045bd:	48 83 ec 20          	sub    $0x20,%rsp
  8045c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8045c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045cd:	48 89 c7             	mov    %rax,%rdi
  8045d0:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  8045d7:	00 00 00 
  8045da:	ff d0                	callq  *%rax
  8045dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8045e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045e4:	48 be 48 53 80 00 00 	movabs $0x805348,%rsi
  8045eb:	00 00 00 
  8045ee:	48 89 c7             	mov    %rax,%rdi
  8045f1:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  8045f8:	00 00 00 
  8045fb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8045fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804601:	8b 50 04             	mov    0x4(%rax),%edx
  804604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804608:	8b 00                	mov    (%rax),%eax
  80460a:	29 c2                	sub    %eax,%edx
  80460c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804610:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80461a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804621:	00 00 00 
	stat->st_dev = &devpipe;
  804624:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804628:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80462f:	00 00 00 
  804632:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80463e:	c9                   	leaveq 
  80463f:	c3                   	retq   

0000000000804640 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804640:	55                   	push   %rbp
  804641:	48 89 e5             	mov    %rsp,%rbp
  804644:	48 83 ec 10          	sub    $0x10,%rsp
  804648:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80464c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804650:	48 89 c6             	mov    %rax,%rsi
  804653:	bf 00 00 00 00       	mov    $0x0,%edi
  804658:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  80465f:	00 00 00 
  804662:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804668:	48 89 c7             	mov    %rax,%rdi
  80466b:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  804672:	00 00 00 
  804675:	ff d0                	callq  *%rax
  804677:	48 89 c6             	mov    %rax,%rsi
  80467a:	bf 00 00 00 00       	mov    $0x0,%edi
  80467f:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  804686:	00 00 00 
  804689:	ff d0                	callq  *%rax
}
  80468b:	c9                   	leaveq 
  80468c:	c3                   	retq   

000000000080468d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80468d:	55                   	push   %rbp
  80468e:	48 89 e5             	mov    %rsp,%rbp
  804691:	48 83 ec 20          	sub    $0x20,%rsp
  804695:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804698:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80469b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80469e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8046a2:	be 01 00 00 00       	mov    $0x1,%esi
  8046a7:	48 89 c7             	mov    %rax,%rdi
  8046aa:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  8046b1:	00 00 00 
  8046b4:	ff d0                	callq  *%rax
}
  8046b6:	90                   	nop
  8046b7:	c9                   	leaveq 
  8046b8:	c3                   	retq   

00000000008046b9 <getchar>:

int
getchar(void)
{
  8046b9:	55                   	push   %rbp
  8046ba:	48 89 e5             	mov    %rsp,%rbp
  8046bd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8046c1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8046c5:	ba 01 00 00 00       	mov    $0x1,%edx
  8046ca:	48 89 c6             	mov    %rax,%rsi
  8046cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8046d2:	48 b8 20 2d 80 00 00 	movabs $0x802d20,%rax
  8046d9:	00 00 00 
  8046dc:	ff d0                	callq  *%rax
  8046de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8046e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046e5:	79 05                	jns    8046ec <getchar+0x33>
		return r;
  8046e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ea:	eb 14                	jmp    804700 <getchar+0x47>
	if (r < 1)
  8046ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046f0:	7f 07                	jg     8046f9 <getchar+0x40>
		return -E_EOF;
  8046f2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8046f7:	eb 07                	jmp    804700 <getchar+0x47>
	return c;
  8046f9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8046fd:	0f b6 c0             	movzbl %al,%eax

}
  804700:	c9                   	leaveq 
  804701:	c3                   	retq   

0000000000804702 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804702:	55                   	push   %rbp
  804703:	48 89 e5             	mov    %rsp,%rbp
  804706:	48 83 ec 20          	sub    $0x20,%rsp
  80470a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80470d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804711:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804714:	48 89 d6             	mov    %rdx,%rsi
  804717:	89 c7                	mov    %eax,%edi
  804719:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  804720:	00 00 00 
  804723:	ff d0                	callq  *%rax
  804725:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804728:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472c:	79 05                	jns    804733 <iscons+0x31>
		return r;
  80472e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804731:	eb 1a                	jmp    80474d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804737:	8b 10                	mov    (%rax),%edx
  804739:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804740:	00 00 00 
  804743:	8b 00                	mov    (%rax),%eax
  804745:	39 c2                	cmp    %eax,%edx
  804747:	0f 94 c0             	sete   %al
  80474a:	0f b6 c0             	movzbl %al,%eax
}
  80474d:	c9                   	leaveq 
  80474e:	c3                   	retq   

000000000080474f <opencons>:

int
opencons(void)
{
  80474f:	55                   	push   %rbp
  804750:	48 89 e5             	mov    %rsp,%rbp
  804753:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804757:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80475b:	48 89 c7             	mov    %rax,%rdi
  80475e:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  804765:	00 00 00 
  804768:	ff d0                	callq  *%rax
  80476a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80476d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804771:	79 05                	jns    804778 <opencons+0x29>
		return r;
  804773:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804776:	eb 5b                	jmp    8047d3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80477c:	ba 07 04 00 00       	mov    $0x407,%edx
  804781:	48 89 c6             	mov    %rax,%rsi
  804784:	bf 00 00 00 00       	mov    $0x0,%edi
  804789:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  804790:	00 00 00 
  804793:	ff d0                	callq  *%rax
  804795:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804798:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479c:	79 05                	jns    8047a3 <opencons+0x54>
		return r;
  80479e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a1:	eb 30                	jmp    8047d3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8047a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a7:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8047ae:	00 00 00 
  8047b1:	8b 12                	mov    (%rdx),%edx
  8047b3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8047b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8047c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047c4:	48 89 c7             	mov    %rax,%rdi
  8047c7:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  8047ce:	00 00 00 
  8047d1:	ff d0                	callq  *%rax
}
  8047d3:	c9                   	leaveq 
  8047d4:	c3                   	retq   

00000000008047d5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8047d5:	55                   	push   %rbp
  8047d6:	48 89 e5             	mov    %rsp,%rbp
  8047d9:	48 83 ec 30          	sub    $0x30,%rsp
  8047dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8047e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047ee:	75 13                	jne    804803 <devcons_read+0x2e>
		return 0;
  8047f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8047f5:	eb 49                	jmp    804840 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8047f7:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8047fe:	00 00 00 
  804801:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804803:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  80480a:	00 00 00 
  80480d:	ff d0                	callq  *%rax
  80480f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804812:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804816:	74 df                	je     8047f7 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80481c:	79 05                	jns    804823 <devcons_read+0x4e>
		return c;
  80481e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804821:	eb 1d                	jmp    804840 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804823:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804827:	75 07                	jne    804830 <devcons_read+0x5b>
		return 0;
  804829:	b8 00 00 00 00       	mov    $0x0,%eax
  80482e:	eb 10                	jmp    804840 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804830:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804833:	89 c2                	mov    %eax,%edx
  804835:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804839:	88 10                	mov    %dl,(%rax)
	return 1;
  80483b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804840:	c9                   	leaveq 
  804841:	c3                   	retq   

0000000000804842 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804842:	55                   	push   %rbp
  804843:	48 89 e5             	mov    %rsp,%rbp
  804846:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80484d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804854:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80485b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804862:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804869:	eb 76                	jmp    8048e1 <devcons_write+0x9f>
		m = n - tot;
  80486b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804872:	89 c2                	mov    %eax,%edx
  804874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804877:	29 c2                	sub    %eax,%edx
  804879:	89 d0                	mov    %edx,%eax
  80487b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80487e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804881:	83 f8 7f             	cmp    $0x7f,%eax
  804884:	76 07                	jbe    80488d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804886:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80488d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804890:	48 63 d0             	movslq %eax,%rdx
  804893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804896:	48 63 c8             	movslq %eax,%rcx
  804899:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8048a0:	48 01 c1             	add    %rax,%rcx
  8048a3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8048aa:	48 89 ce             	mov    %rcx,%rsi
  8048ad:	48 89 c7             	mov    %rax,%rdi
  8048b0:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8048b7:	00 00 00 
  8048ba:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8048bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048bf:	48 63 d0             	movslq %eax,%rdx
  8048c2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8048c9:	48 89 d6             	mov    %rdx,%rsi
  8048cc:	48 89 c7             	mov    %rax,%rdi
  8048cf:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  8048d6:	00 00 00 
  8048d9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8048db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048de:	01 45 fc             	add    %eax,-0x4(%rbp)
  8048e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048e4:	48 98                	cltq   
  8048e6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8048ed:	0f 82 78 ff ff ff    	jb     80486b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8048f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8048f6:	c9                   	leaveq 
  8048f7:	c3                   	retq   

00000000008048f8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8048f8:	55                   	push   %rbp
  8048f9:	48 89 e5             	mov    %rsp,%rbp
  8048fc:	48 83 ec 08          	sub    $0x8,%rsp
  804900:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804909:	c9                   	leaveq 
  80490a:	c3                   	retq   

000000000080490b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80490b:	55                   	push   %rbp
  80490c:	48 89 e5             	mov    %rsp,%rbp
  80490f:	48 83 ec 10          	sub    $0x10,%rsp
  804913:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804917:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80491b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80491f:	48 be 54 53 80 00 00 	movabs $0x805354,%rsi
  804926:	00 00 00 
  804929:	48 89 c7             	mov    %rax,%rdi
  80492c:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  804933:	00 00 00 
  804936:	ff d0                	callq  *%rax
	return 0;
  804938:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80493d:	c9                   	leaveq 
  80493e:	c3                   	retq   

000000000080493f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80493f:	55                   	push   %rbp
  804940:	48 89 e5             	mov    %rsp,%rbp
  804943:	48 83 ec 20          	sub    $0x20,%rsp
  804947:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80494b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804952:	00 00 00 
  804955:	48 8b 00             	mov    (%rax),%rax
  804958:	48 85 c0             	test   %rax,%rax
  80495b:	75 6f                	jne    8049cc <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80495d:	ba 07 00 00 00       	mov    $0x7,%edx
  804962:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804967:	bf 00 00 00 00       	mov    $0x0,%edi
  80496c:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  804973:	00 00 00 
  804976:	ff d0                	callq  *%rax
  804978:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80497b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80497f:	79 30                	jns    8049b1 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804984:	89 c1                	mov    %eax,%ecx
  804986:	48 ba 60 53 80 00 00 	movabs $0x805360,%rdx
  80498d:	00 00 00 
  804990:	be 22 00 00 00       	mov    $0x22,%esi
  804995:	48 bf 7f 53 80 00 00 	movabs $0x80537f,%rdi
  80499c:	00 00 00 
  80499f:	b8 00 00 00 00       	mov    $0x0,%eax
  8049a4:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8049ab:	00 00 00 
  8049ae:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8049b1:	48 be e0 49 80 00 00 	movabs $0x8049e0,%rsi
  8049b8:	00 00 00 
  8049bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8049c0:	48 b8 c5 1c 80 00 00 	movabs $0x801cc5,%rax
  8049c7:	00 00 00 
  8049ca:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8049cc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049d3:	00 00 00 
  8049d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049da:	48 89 10             	mov    %rdx,(%rax)
}
  8049dd:	90                   	nop
  8049de:	c9                   	leaveq 
  8049df:	c3                   	retq   

00000000008049e0 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8049e0:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8049e3:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8049ea:	00 00 00 
call *%rax
  8049ed:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8049ef:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8049f6:	00 08 
    movq 152(%rsp), %rax
  8049f8:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8049ff:	00 
    movq 136(%rsp), %rbx
  804a00:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804a07:	00 
movq %rbx, (%rax)
  804a08:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804a0b:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804a0f:	4c 8b 3c 24          	mov    (%rsp),%r15
  804a13:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804a18:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804a1d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804a22:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804a27:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804a2c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804a31:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804a36:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804a3b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804a40:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804a45:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804a4a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804a4f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804a54:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804a59:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804a5d:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804a61:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804a62:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804a67:	c3                   	retq   
