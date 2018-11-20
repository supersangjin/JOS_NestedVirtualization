
vmm/guest/obj/user/testpiperace:     file format elf64-x86-64


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
  800052:	48 bf 00 4b 80 00 00 	movabs $0x804b00,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 4d 41 80 00 00 	movabs $0x80414d,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 19 4b 80 00 00 	movabs $0x804b19,%rdx
  800095:	00 00 00 
  800098:	be 0e 00 00 00       	mov    $0xe,%esi
  80009d:	48 bf 22 4b 80 00 00 	movabs $0x804b22,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba 36 4b 80 00 00 	movabs $0x804b36,%rdx
  8000e1:	00 00 00 
  8000e4:	be 11 00 00 00       	mov    $0x11,%esi
  8000e9:	48 bf 22 4b 80 00 00 	movabs $0x804b22,%rdi
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
  800114:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
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
  80012e:	48 b8 11 44 80 00 00 	movabs $0x804411,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf 3f 4b 80 00 00 	movabs $0x804b3f,%rdi
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
  80018c:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 5a 4b 80 00 00 	movabs $0x804b5a,%rdi
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
  800214:	48 bf 65 4b 80 00 00 	movabs $0x804b65,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
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
  80026c:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 11 44 80 00 00 	movabs $0x804411,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba 88 4b 80 00 00 	movabs $0x804b88,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3b 00 00 00       	mov    $0x3b,%esi
  8002ab:	48 bf 22 4b 80 00 00 	movabs $0x804b22,%rdi
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
  8002d2:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba b2 4b 80 00 00 	movabs $0x804bb2,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3d 00 00 00       	mov    $0x3d,%esi
  8002fb:	48 bf 22 4b 80 00 00 	movabs $0x804b22,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 b3 38 80 00 00 	movabs $0x8038b3,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf ca 4b 80 00 00 	movabs $0x804bca,%rdi
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
  800368:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
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
  80040e:	48 b8 c3 2b 80 00 00 	movabs $0x802bc3,%rax
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
  8004e8:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
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
  800524:	48 bf 23 4c 80 00 00 	movabs $0x804c23,%rdi
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
  8007d5:	48 b8 30 4e 80 00 00 	movabs $0x804e30,%rax
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
  800ab7:	48 b8 58 4e 80 00 00 	movabs $0x804e58,%rax
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
  800bfe:	48 b8 80 4d 80 00 00 	movabs $0x804d80,%rax
  800c05:	00 00 00 
  800c08:	48 63 d3             	movslq %ebx,%rdx
  800c0b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c0f:	4d 85 e4             	test   %r12,%r12
  800c12:	75 2e                	jne    800c42 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800c14:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1c:	89 d9                	mov    %ebx,%ecx
  800c1e:	48 ba 41 4e 80 00 00 	movabs $0x804e41,%rdx
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
  800c4d:	48 ba 4a 4e 80 00 00 	movabs $0x804e4a,%rdx
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
  800ca4:	49 bc 4d 4e 80 00 00 	movabs $0x804e4d,%r12
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
  8019b0:	48 ba 08 51 80 00 00 	movabs $0x805108,%rdx
  8019b7:	00 00 00 
  8019ba:	be 24 00 00 00       	mov    $0x24,%esi
  8019bf:	48 bf 25 51 80 00 00 	movabs $0x805125,%rdi
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

0000000000801f2a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
  801f2e:	48 83 ec 30          	sub    $0x30,%rsp
  801f32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3a:	48 8b 00             	mov    (%rax),%rax
  801f3d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801f41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f45:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f49:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4f:	83 e0 02             	and    $0x2,%eax
  801f52:	85 c0                	test   %eax,%eax
  801f54:	75 40                	jne    801f96 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801f56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f5a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801f61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f65:	49 89 d0             	mov    %rdx,%r8
  801f68:	48 89 c1             	mov    %rax,%rcx
  801f6b:	48 ba 38 51 80 00 00 	movabs $0x805138,%rdx
  801f72:	00 00 00 
  801f75:	be 1f 00 00 00       	mov    $0x1f,%esi
  801f7a:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  801f81:	00 00 00 
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
  801f89:	49 b9 2e 04 80 00 00 	movabs $0x80042e,%r9
  801f90:	00 00 00 
  801f93:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801f96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9a:	48 c1 e8 0c          	shr    $0xc,%rax
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fa8:	01 00 00 
  801fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801faf:	25 07 08 00 00       	and    $0x807,%eax
  801fb4:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801fba:	74 4e                	je     80200a <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801fbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc0:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc4:	48 89 c2             	mov    %rax,%rdx
  801fc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fce:	01 00 00 
  801fd1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd9:	49 89 d0             	mov    %rdx,%r8
  801fdc:	48 89 c1             	mov    %rax,%rcx
  801fdf:	48 ba 60 51 80 00 00 	movabs $0x805160,%rdx
  801fe6:	00 00 00 
  801fe9:	be 22 00 00 00       	mov    $0x22,%esi
  801fee:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  801ff5:	00 00 00 
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	49 b9 2e 04 80 00 00 	movabs $0x80042e,%r9
  802004:	00 00 00 
  802007:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80200a:	ba 07 00 00 00       	mov    $0x7,%edx
  80200f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802014:	bf 00 00 00 00       	mov    $0x0,%edi
  802019:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax
  802025:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802028:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80202c:	79 30                	jns    80205e <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  80202e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802031:	89 c1                	mov    %eax,%ecx
  802033:	48 ba 8b 51 80 00 00 	movabs $0x80518b,%rdx
  80203a:	00 00 00 
  80203d:	be 28 00 00 00       	mov    $0x28,%esi
  802042:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802049:	00 00 00 
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
  802051:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802058:	00 00 00 
  80205b:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80205e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802062:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802066:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802070:	ba 00 10 00 00       	mov    $0x1000,%edx
  802075:	48 89 c6             	mov    %rax,%rsi
  802078:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80207d:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802089:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80208d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802095:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80209b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020a1:	48 89 c1             	mov    %rax,%rcx
  8020a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b3:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  8020ba:	00 00 00 
  8020bd:	ff d0                	callq  *%rax
  8020bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c6:	79 30                	jns    8020f8 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8020c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cb:	89 c1                	mov    %eax,%ecx
  8020cd:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  8020d4:	00 00 00 
  8020d7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8020dc:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8020e3:	00 00 00 
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8020f2:	00 00 00 
  8020f5:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8020f8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802102:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
  80210e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802111:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802115:	79 30                	jns    802147 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802117:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80211a:	89 c1                	mov    %eax,%ecx
  80211c:	48 ba af 51 80 00 00 	movabs $0x8051af,%rdx
  802123:	00 00 00 
  802126:	be 31 00 00 00       	mov    $0x31,%esi
  80212b:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802132:	00 00 00 
  802135:	b8 00 00 00 00       	mov    $0x0,%eax
  80213a:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802141:	00 00 00 
  802144:	41 ff d0             	callq  *%r8

}
  802147:	90                   	nop
  802148:	c9                   	leaveq 
  802149:	c3                   	retq   

000000000080214a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80214a:	55                   	push   %rbp
  80214b:	48 89 e5             	mov    %rsp,%rbp
  80214e:	48 83 ec 30          	sub    $0x30,%rsp
  802152:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802155:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802158:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80215b:	c1 e0 0c             	shl    $0xc,%eax
  80215e:	89 c0                	mov    %eax,%eax
  802160:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802164:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80216b:	01 00 00 
  80216e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802171:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802175:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217d:	25 02 08 00 00       	and    $0x802,%eax
  802182:	48 85 c0             	test   %rax,%rax
  802185:	74 0e                	je     802195 <duppage+0x4b>
  802187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80218b:	25 00 04 00 00       	and    $0x400,%eax
  802190:	48 85 c0             	test   %rax,%rax
  802193:	74 70                	je     802205 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802199:	25 07 0e 00 00       	and    $0xe07,%eax
  80219e:	89 c6                	mov    %eax,%esi
  8021a0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8021a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ab:	41 89 f0             	mov    %esi,%r8d
  8021ae:	48 89 c6             	mov    %rax,%rsi
  8021b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b6:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
  8021c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c9:	79 30                	jns    8021fb <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8021cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021ce:	89 c1                	mov    %eax,%ecx
  8021d0:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  8021d7:	00 00 00 
  8021da:	be 50 00 00 00       	mov    $0x50,%esi
  8021df:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8021e6:	00 00 00 
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ee:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8021f5:	00 00 00 
  8021f8:	41 ff d0             	callq  *%r8
		return 0;
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	e9 c4 00 00 00       	jmpq   8022c9 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802205:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802209:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80220c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802210:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802216:	48 89 c6             	mov    %rax,%rsi
  802219:	bf 00 00 00 00       	mov    $0x0,%edi
  80221e:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802225:	00 00 00 
  802228:	ff d0                	callq  *%rax
  80222a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80222d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802231:	79 30                	jns    802263 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802236:	89 c1                	mov    %eax,%ecx
  802238:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  80223f:	00 00 00 
  802242:	be 64 00 00 00       	mov    $0x64,%esi
  802247:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  80224e:	00 00 00 
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80225d:	00 00 00 
  802260:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802263:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80226b:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802271:	48 89 d1             	mov    %rdx,%rcx
  802274:	ba 00 00 00 00       	mov    $0x0,%edx
  802279:	48 89 c6             	mov    %rax,%rsi
  80227c:	bf 00 00 00 00       	mov    $0x0,%edi
  802281:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax
  80228d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802290:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802294:	79 30                	jns    8022c6 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802296:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802299:	89 c1                	mov    %eax,%ecx
  80229b:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  8022a2:	00 00 00 
  8022a5:	be 66 00 00 00       	mov    $0x66,%esi
  8022aa:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8022b1:	00 00 00 
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b9:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8022c0:	00 00 00 
  8022c3:	41 ff d0             	callq  *%r8
	return r;
  8022c6:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8022c9:	c9                   	leaveq 
  8022ca:	c3                   	retq   

00000000008022cb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022cb:	55                   	push   %rbp
  8022cc:	48 89 e5             	mov    %rsp,%rbp
  8022cf:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8022d3:	48 bf 2a 1f 80 00 00 	movabs $0x801f2a,%rdi
  8022da:	00 00 00 
  8022dd:	48 b8 ba 49 80 00 00 	movabs $0x8049ba,%rax
  8022e4:	00 00 00 
  8022e7:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8022e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8022ee:	cd 30                	int    $0x30
  8022f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022f3:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8022f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8022f9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022fd:	79 08                	jns    802307 <fork+0x3c>
		return envid;
  8022ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802302:	e9 0b 02 00 00       	jmpq   802512 <fork+0x247>
	if (envid == 0) {
  802307:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80230b:	75 3e                	jne    80234b <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80230d:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  802314:	00 00 00 
  802317:	ff d0                	callq  *%rax
  802319:	25 ff 03 00 00       	and    $0x3ff,%eax
  80231e:	48 98                	cltq   
  802320:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802327:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80232e:	00 00 00 
  802331:	48 01 c2             	add    %rax,%rdx
  802334:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80233b:	00 00 00 
  80233e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	e9 c7 01 00 00       	jmpq   802512 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80234b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802352:	e9 a6 00 00 00       	jmpq   8023fd <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235a:	c1 f8 12             	sar    $0x12,%eax
  80235d:	89 c2                	mov    %eax,%edx
  80235f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802366:	01 00 00 
  802369:	48 63 d2             	movslq %edx,%rdx
  80236c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802370:	83 e0 01             	and    $0x1,%eax
  802373:	48 85 c0             	test   %rax,%rax
  802376:	74 21                	je     802399 <fork+0xce>
  802378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237b:	c1 f8 09             	sar    $0x9,%eax
  80237e:	89 c2                	mov    %eax,%edx
  802380:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802387:	01 00 00 
  80238a:	48 63 d2             	movslq %edx,%rdx
  80238d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802391:	83 e0 01             	and    $0x1,%eax
  802394:	48 85 c0             	test   %rax,%rax
  802397:	75 09                	jne    8023a2 <fork+0xd7>
			pn += NPTENTRIES;
  802399:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8023a0:	eb 5b                	jmp    8023fd <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8023a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a5:	05 00 02 00 00       	add    $0x200,%eax
  8023aa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023ad:	eb 46                	jmp    8023f5 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8023af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b6:	01 00 00 
  8023b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023bc:	48 63 d2             	movslq %edx,%rdx
  8023bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c3:	83 e0 05             	and    $0x5,%eax
  8023c6:	48 83 f8 05          	cmp    $0x5,%rax
  8023ca:	75 21                	jne    8023ed <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  8023cc:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8023d3:	74 1b                	je     8023f0 <fork+0x125>
				continue;
			duppage(envid, pn);
  8023d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023db:	89 d6                	mov    %edx,%esi
  8023dd:	89 c7                	mov    %eax,%edi
  8023df:	48 b8 4a 21 80 00 00 	movabs $0x80214a,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
  8023eb:	eb 04                	jmp    8023f1 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  8023ed:	90                   	nop
  8023ee:	eb 01                	jmp    8023f1 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  8023f0:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8023f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8023fb:	7c b2                	jl     8023af <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8023fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802400:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802405:	0f 86 4c ff ff ff    	jbe    802357 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80240b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80240e:	ba 07 00 00 00       	mov    $0x7,%edx
  802413:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802418:	89 c7                	mov    %eax,%edi
  80241a:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  802421:	00 00 00 
  802424:	ff d0                	callq  *%rax
  802426:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802429:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80242d:	79 30                	jns    80245f <fork+0x194>
		panic("allocating exception stack: %e", r);
  80242f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802432:	89 c1                	mov    %eax,%ecx
  802434:	48 ba c8 51 80 00 00 	movabs $0x8051c8,%rdx
  80243b:	00 00 00 
  80243e:	be 9e 00 00 00       	mov    $0x9e,%esi
  802443:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  80244a:	00 00 00 
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802459:	00 00 00 
  80245c:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80245f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802466:	00 00 00 
  802469:	48 8b 00             	mov    (%rax),%rax
  80246c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802473:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802476:	48 89 d6             	mov    %rdx,%rsi
  802479:	89 c7                	mov    %eax,%edi
  80247b:	48 b8 c5 1c 80 00 00 	movabs $0x801cc5,%rax
  802482:	00 00 00 
  802485:	ff d0                	callq  *%rax
  802487:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80248a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80248e:	79 30                	jns    8024c0 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802490:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802493:	89 c1                	mov    %eax,%ecx
  802495:	48 ba e8 51 80 00 00 	movabs $0x8051e8,%rdx
  80249c:	00 00 00 
  80249f:	be a2 00 00 00       	mov    $0xa2,%esi
  8024a4:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8024ab:	00 00 00 
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  8024ba:	00 00 00 
  8024bd:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8024c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c3:	be 02 00 00 00       	mov    $0x2,%esi
  8024c8:	89 c7                	mov    %eax,%edi
  8024ca:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
  8024d6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024dd:	79 30                	jns    80250f <fork+0x244>
		panic("sys_env_set_status: %e", r);
  8024df:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024e2:	89 c1                	mov    %eax,%ecx
  8024e4:	48 ba 07 52 80 00 00 	movabs $0x805207,%rdx
  8024eb:	00 00 00 
  8024ee:	be a7 00 00 00       	mov    $0xa7,%esi
  8024f3:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8024fa:	00 00 00 
  8024fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802502:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802509:	00 00 00 
  80250c:	41 ff d0             	callq  *%r8

	return envid;
  80250f:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802512:	c9                   	leaveq 
  802513:	c3                   	retq   

0000000000802514 <sfork>:

// Challenge!
int
sfork(void)
{
  802514:	55                   	push   %rbp
  802515:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802518:	48 ba 1e 52 80 00 00 	movabs $0x80521e,%rdx
  80251f:	00 00 00 
  802522:	be b1 00 00 00       	mov    $0xb1,%esi
  802527:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  80252e:	00 00 00 
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
  802536:	48 b9 2e 04 80 00 00 	movabs $0x80042e,%rcx
  80253d:	00 00 00 
  802540:	ff d1                	callq  *%rcx

0000000000802542 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802542:	55                   	push   %rbp
  802543:	48 89 e5             	mov    %rsp,%rbp
  802546:	48 83 ec 30          	sub    $0x30,%rsp
  80254a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80254e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802552:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802556:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80255b:	75 0e                	jne    80256b <ipc_recv+0x29>
		pg = (void*) UTOP;
  80255d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802564:	00 00 00 
  802567:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80256b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256f:	48 89 c7             	mov    %rax,%rdi
  802572:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802579:	00 00 00 
  80257c:	ff d0                	callq  *%rax
  80257e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802581:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802585:	79 27                	jns    8025ae <ipc_recv+0x6c>
		if (from_env_store)
  802587:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80258c:	74 0a                	je     802598 <ipc_recv+0x56>
			*from_env_store = 0;
  80258e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802592:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802598:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80259d:	74 0a                	je     8025a9 <ipc_recv+0x67>
			*perm_store = 0;
  80259f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8025a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ac:	eb 53                	jmp    802601 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8025ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025b3:	74 19                	je     8025ce <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8025b5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025bc:	00 00 00 
  8025bf:	48 8b 00             	mov    (%rax),%rax
  8025c2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8025c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cc:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8025ce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025d3:	74 19                	je     8025ee <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8025d5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025dc:	00 00 00 
  8025df:	48 8b 00             	mov    (%rax),%rax
  8025e2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8025e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ec:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8025ee:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025f5:	00 00 00 
  8025f8:	48 8b 00             	mov    (%rax),%rax
  8025fb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802601:	c9                   	leaveq 
  802602:	c3                   	retq   

0000000000802603 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802603:	55                   	push   %rbp
  802604:	48 89 e5             	mov    %rsp,%rbp
  802607:	48 83 ec 30          	sub    $0x30,%rsp
  80260b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802611:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802615:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802618:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80261d:	75 1c                	jne    80263b <ipc_send+0x38>
		pg = (void*) UTOP;
  80261f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802626:	00 00 00 
  802629:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80262d:	eb 0c                	jmp    80263b <ipc_send+0x38>
		sys_yield();
  80262f:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  802636:	00 00 00 
  802639:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80263b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80263e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802641:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802648:	89 c7                	mov    %eax,%edi
  80264a:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802659:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80265d:	74 d0                	je     80262f <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80265f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802663:	79 30                	jns    802695 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  802665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802668:	89 c1                	mov    %eax,%ecx
  80266a:	48 ba 34 52 80 00 00 	movabs $0x805234,%rdx
  802671:	00 00 00 
  802674:	be 47 00 00 00       	mov    $0x47,%esi
  802679:	48 bf 4a 52 80 00 00 	movabs $0x80524a,%rdi
  802680:	00 00 00 
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80268f:	00 00 00 
  802692:	41 ff d0             	callq  *%r8

}
  802695:	90                   	nop
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	53                   	push   %rbx
  80269d:	48 83 ec 28          	sub    $0x28,%rsp
  8026a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8026a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8026ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8026b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026b8:	75 0e                	jne    8026c8 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8026ba:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8026c1:	00 00 00 
  8026c4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8026c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026cc:	ba 07 00 00 00       	mov    $0x7,%edx
  8026d1:	48 89 c6             	mov    %rax,%rsi
  8026d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d9:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8026e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e9:	48 c1 e8 0c          	shr    $0xc,%rax
  8026ed:	48 89 c2             	mov    %rax,%rdx
  8026f0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026f7:	01 00 00 
  8026fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026fe:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802704:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  802708:	b8 03 00 00 00       	mov    $0x3,%eax
  80270d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802711:	48 89 d3             	mov    %rdx,%rbx
  802714:	0f 01 c1             	vmcall 
  802717:	89 f2                	mov    %esi,%edx
  802719:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80271c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80271f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802723:	79 05                	jns    80272a <ipc_host_recv+0x92>
		return r;
  802725:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802728:	eb 03                	jmp    80272d <ipc_host_recv+0x95>
	}
	return val;
  80272a:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80272d:	48 83 c4 28          	add    $0x28,%rsp
  802731:	5b                   	pop    %rbx
  802732:	5d                   	pop    %rbp
  802733:	c3                   	retq   

0000000000802734 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802734:	55                   	push   %rbp
  802735:	48 89 e5             	mov    %rsp,%rbp
  802738:	53                   	push   %rbx
  802739:	48 83 ec 38          	sub    $0x38,%rsp
  80273d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802740:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802743:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802747:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80274a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802751:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802756:	75 0e                	jne    802766 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802758:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80275f:	00 00 00 
  802762:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80276a:	48 c1 e8 0c          	shr    $0xc,%rax
  80276e:	48 89 c2             	mov    %rax,%rdx
  802771:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802778:	01 00 00 
  80277b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802785:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802789:	b8 02 00 00 00       	mov    $0x2,%eax
  80278e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802791:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802794:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802798:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80279b:	89 fb                	mov    %edi,%ebx
  80279d:	0f 01 c1             	vmcall 
  8027a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8027a3:	eb 26                	jmp    8027cb <ipc_host_send+0x97>
		sys_yield();
  8027a5:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8027ac:	00 00 00 
  8027af:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8027b1:	b8 02 00 00 00       	mov    $0x2,%eax
  8027b6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8027b9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027c0:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8027c3:	89 fb                	mov    %edi,%ebx
  8027c5:	0f 01 c1             	vmcall 
  8027c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8027cb:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8027cf:	74 d4                	je     8027a5 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8027d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027d5:	79 30                	jns    802807 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8027d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027da:	89 c1                	mov    %eax,%ecx
  8027dc:	48 ba 34 52 80 00 00 	movabs $0x805234,%rdx
  8027e3:	00 00 00 
  8027e6:	be 79 00 00 00       	mov    $0x79,%esi
  8027eb:	48 bf 4a 52 80 00 00 	movabs $0x80524a,%rdi
  8027f2:	00 00 00 
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  802801:	00 00 00 
  802804:	41 ff d0             	callq  *%r8

}
  802807:	90                   	nop
  802808:	48 83 c4 38          	add    $0x38,%rsp
  80280c:	5b                   	pop    %rbx
  80280d:	5d                   	pop    %rbp
  80280e:	c3                   	retq   

000000000080280f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80280f:	55                   	push   %rbp
  802810:	48 89 e5             	mov    %rsp,%rbp
  802813:	48 83 ec 18          	sub    $0x18,%rsp
  802817:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80281a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802821:	eb 4d                	jmp    802870 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  802823:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80282a:	00 00 00 
  80282d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802830:	48 98                	cltq   
  802832:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802839:	48 01 d0             	add    %rdx,%rax
  80283c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802842:	8b 00                	mov    (%rax),%eax
  802844:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802847:	75 23                	jne    80286c <ipc_find_env+0x5d>
			return envs[i].env_id;
  802849:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802850:	00 00 00 
  802853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802856:	48 98                	cltq   
  802858:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80285f:	48 01 d0             	add    %rdx,%rax
  802862:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802868:	8b 00                	mov    (%rax),%eax
  80286a:	eb 12                	jmp    80287e <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80286c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802870:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802877:	7e aa                	jle    802823 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287e:	c9                   	leaveq 
  80287f:	c3                   	retq   

0000000000802880 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802880:	55                   	push   %rbp
  802881:	48 89 e5             	mov    %rsp,%rbp
  802884:	48 83 ec 08          	sub    $0x8,%rsp
  802888:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80288c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802890:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802897:	ff ff ff 
  80289a:	48 01 d0             	add    %rdx,%rax
  80289d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028a1:	c9                   	leaveq 
  8028a2:	c3                   	retq   

00000000008028a3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028a3:	55                   	push   %rbp
  8028a4:	48 89 e5             	mov    %rsp,%rbp
  8028a7:	48 83 ec 08          	sub    $0x8,%rsp
  8028ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b3:	48 89 c7             	mov    %rax,%rdi
  8028b6:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
  8028c2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028c8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028cc:	c9                   	leaveq 
  8028cd:	c3                   	retq   

00000000008028ce <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028ce:	55                   	push   %rbp
  8028cf:	48 89 e5             	mov    %rsp,%rbp
  8028d2:	48 83 ec 18          	sub    $0x18,%rsp
  8028d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028e1:	eb 6b                	jmp    80294e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e6:	48 98                	cltq   
  8028e8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028ee:	48 c1 e0 0c          	shl    $0xc,%rax
  8028f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8028f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fa:	48 c1 e8 15          	shr    $0x15,%rax
  8028fe:	48 89 c2             	mov    %rax,%rdx
  802901:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802908:	01 00 00 
  80290b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290f:	83 e0 01             	and    $0x1,%eax
  802912:	48 85 c0             	test   %rax,%rax
  802915:	74 21                	je     802938 <fd_alloc+0x6a>
  802917:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291b:	48 c1 e8 0c          	shr    $0xc,%rax
  80291f:	48 89 c2             	mov    %rax,%rdx
  802922:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802929:	01 00 00 
  80292c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802930:	83 e0 01             	and    $0x1,%eax
  802933:	48 85 c0             	test   %rax,%rax
  802936:	75 12                	jne    80294a <fd_alloc+0x7c>
			*fd_store = fd;
  802938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802940:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	eb 1a                	jmp    802964 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80294a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80294e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802952:	7e 8f                	jle    8028e3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802958:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80295f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802964:	c9                   	leaveq 
  802965:	c3                   	retq   

0000000000802966 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802966:	55                   	push   %rbp
  802967:	48 89 e5             	mov    %rsp,%rbp
  80296a:	48 83 ec 20          	sub    $0x20,%rsp
  80296e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802971:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802975:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802979:	78 06                	js     802981 <fd_lookup+0x1b>
  80297b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80297f:	7e 07                	jle    802988 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802981:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802986:	eb 6c                	jmp    8029f4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802988:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80298b:	48 98                	cltq   
  80298d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802993:	48 c1 e0 0c          	shl    $0xc,%rax
  802997:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80299b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299f:	48 c1 e8 15          	shr    $0x15,%rax
  8029a3:	48 89 c2             	mov    %rax,%rdx
  8029a6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029ad:	01 00 00 
  8029b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b4:	83 e0 01             	and    $0x1,%eax
  8029b7:	48 85 c0             	test   %rax,%rax
  8029ba:	74 21                	je     8029dd <fd_lookup+0x77>
  8029bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8029c4:	48 89 c2             	mov    %rax,%rdx
  8029c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ce:	01 00 00 
  8029d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d5:	83 e0 01             	and    $0x1,%eax
  8029d8:	48 85 c0             	test   %rax,%rax
  8029db:	75 07                	jne    8029e4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e2:	eb 10                	jmp    8029f4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8029e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029ec:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f4:	c9                   	leaveq 
  8029f5:	c3                   	retq   

00000000008029f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8029f6:	55                   	push   %rbp
  8029f7:	48 89 e5             	mov    %rsp,%rbp
  8029fa:	48 83 ec 30          	sub    $0x30,%rsp
  8029fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a02:	89 f0                	mov    %esi,%eax
  802a04:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a0b:	48 89 c7             	mov    %rax,%rdi
  802a0e:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax
  802a1a:	89 c2                	mov    %eax,%edx
  802a1c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a20:	48 89 c6             	mov    %rax,%rsi
  802a23:	89 d7                	mov    %edx,%edi
  802a25:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a38:	78 0a                	js     802a44 <fd_close+0x4e>
	    || fd != fd2)
  802a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a42:	74 12                	je     802a56 <fd_close+0x60>
		return (must_exist ? r : 0);
  802a44:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a48:	74 05                	je     802a4f <fd_close+0x59>
  802a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4d:	eb 70                	jmp    802abf <fd_close+0xc9>
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	eb 69                	jmp    802abf <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a5a:	8b 00                	mov    (%rax),%eax
  802a5c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a60:	48 89 d6             	mov    %rdx,%rsi
  802a63:	89 c7                	mov    %eax,%edi
  802a65:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	callq  *%rax
  802a71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a78:	78 2a                	js     802aa4 <fd_close+0xae>
		if (dev->dev_close)
  802a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a82:	48 85 c0             	test   %rax,%rax
  802a85:	74 16                	je     802a9d <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8b:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a8f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a93:	48 89 d7             	mov    %rdx,%rdi
  802a96:	ff d0                	callq  *%rax
  802a98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9b:	eb 07                	jmp    802aa4 <fd_close+0xae>
		else
			r = 0;
  802a9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa8:	48 89 c6             	mov    %rax,%rsi
  802aab:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab0:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	callq  *%rax
	return r;
  802abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802abf:	c9                   	leaveq 
  802ac0:	c3                   	retq   

0000000000802ac1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ac1:	55                   	push   %rbp
  802ac2:	48 89 e5             	mov    %rsp,%rbp
  802ac5:	48 83 ec 20          	sub    $0x20,%rsp
  802ac9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802acc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802ad0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ad7:	eb 41                	jmp    802b1a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802ad9:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802ae0:	00 00 00 
  802ae3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ae6:	48 63 d2             	movslq %edx,%rdx
  802ae9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aed:	8b 00                	mov    (%rax),%eax
  802aef:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802af2:	75 22                	jne    802b16 <dev_lookup+0x55>
			*dev = devtab[i];
  802af4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802afb:	00 00 00 
  802afe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b01:	48 63 d2             	movslq %edx,%rdx
  802b04:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b14:	eb 60                	jmp    802b76 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b16:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b1a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802b21:	00 00 00 
  802b24:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b27:	48 63 d2             	movslq %edx,%rdx
  802b2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b2e:	48 85 c0             	test   %rax,%rax
  802b31:	75 a6                	jne    802ad9 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b33:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b3a:	00 00 00 
  802b3d:	48 8b 00             	mov    (%rax),%rax
  802b40:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b46:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b49:	89 c6                	mov    %eax,%esi
  802b4b:	48 bf 58 52 80 00 00 	movabs $0x805258,%rdi
  802b52:	00 00 00 
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5a:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  802b61:	00 00 00 
  802b64:	ff d1                	callq  *%rcx
	*dev = 0;
  802b66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b76:	c9                   	leaveq 
  802b77:	c3                   	retq   

0000000000802b78 <close>:

int
close(int fdnum)
{
  802b78:	55                   	push   %rbp
  802b79:	48 89 e5             	mov    %rsp,%rbp
  802b7c:	48 83 ec 20          	sub    $0x20,%rsp
  802b80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b83:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8a:	48 89 d6             	mov    %rdx,%rsi
  802b8d:	89 c7                	mov    %eax,%edi
  802b8f:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
  802b9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba2:	79 05                	jns    802ba9 <close+0x31>
		return r;
  802ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba7:	eb 18                	jmp    802bc1 <close+0x49>
	else
		return fd_close(fd, 1);
  802ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bad:	be 01 00 00 00       	mov    $0x1,%esi
  802bb2:	48 89 c7             	mov    %rax,%rdi
  802bb5:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
}
  802bc1:	c9                   	leaveq 
  802bc2:	c3                   	retq   

0000000000802bc3 <close_all>:

void
close_all(void)
{
  802bc3:	55                   	push   %rbp
  802bc4:	48 89 e5             	mov    %rsp,%rbp
  802bc7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bd2:	eb 15                	jmp    802be9 <close_all+0x26>
		close(i);
  802bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd7:	89 c7                	mov    %eax,%edi
  802bd9:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802be5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802be9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802bed:	7e e5                	jle    802bd4 <close_all+0x11>
		close(i);
}
  802bef:	90                   	nop
  802bf0:	c9                   	leaveq 
  802bf1:	c3                   	retq   

0000000000802bf2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802bf2:	55                   	push   %rbp
  802bf3:	48 89 e5             	mov    %rsp,%rbp
  802bf6:	48 83 ec 40          	sub    $0x40,%rsp
  802bfa:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802bfd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c00:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c04:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c07:	48 89 d6             	mov    %rdx,%rsi
  802c0a:	89 c7                	mov    %eax,%edi
  802c0c:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
  802c18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1f:	79 08                	jns    802c29 <dup+0x37>
		return r;
  802c21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c24:	e9 70 01 00 00       	jmpq   802d99 <dup+0x1a7>
	close(newfdnum);
  802c29:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c2c:	89 c7                	mov    %eax,%edi
  802c2e:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  802c35:	00 00 00 
  802c38:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c3a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c3d:	48 98                	cltq   
  802c3f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c45:	48 c1 e0 0c          	shl    $0xc,%rax
  802c49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c51:	48 89 c7             	mov    %rax,%rdi
  802c54:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
  802c60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7f:	48 c1 e8 15          	shr    $0x15,%rax
  802c83:	48 89 c2             	mov    %rax,%rdx
  802c86:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c8d:	01 00 00 
  802c90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c94:	83 e0 01             	and    $0x1,%eax
  802c97:	48 85 c0             	test   %rax,%rax
  802c9a:	74 71                	je     802d0d <dup+0x11b>
  802c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ca4:	48 89 c2             	mov    %rax,%rdx
  802ca7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cae:	01 00 00 
  802cb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cb5:	83 e0 01             	and    $0x1,%eax
  802cb8:	48 85 c0             	test   %rax,%rax
  802cbb:	74 50                	je     802d0d <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc1:	48 c1 e8 0c          	shr    $0xc,%rax
  802cc5:	48 89 c2             	mov    %rax,%rdx
  802cc8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ccf:	01 00 00 
  802cd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cd6:	25 07 0e 00 00       	and    $0xe07,%eax
  802cdb:	89 c1                	mov    %eax,%ecx
  802cdd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce5:	41 89 c8             	mov    %ecx,%r8d
  802ce8:	48 89 d1             	mov    %rdx,%rcx
  802ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf0:	48 89 c6             	mov    %rax,%rsi
  802cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf8:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802cff:	00 00 00 
  802d02:	ff d0                	callq  *%rax
  802d04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0b:	78 55                	js     802d62 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d11:	48 c1 e8 0c          	shr    $0xc,%rax
  802d15:	48 89 c2             	mov    %rax,%rdx
  802d18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d1f:	01 00 00 
  802d22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d26:	25 07 0e 00 00       	and    $0xe07,%eax
  802d2b:	89 c1                	mov    %eax,%ecx
  802d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d35:	41 89 c8             	mov    %ecx,%r8d
  802d38:	48 89 d1             	mov    %rdx,%rcx
  802d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d40:	48 89 c6             	mov    %rax,%rsi
  802d43:	bf 00 00 00 00       	mov    $0x0,%edi
  802d48:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5b:	78 08                	js     802d65 <dup+0x173>
		goto err;

	return newfdnum;
  802d5d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d60:	eb 37                	jmp    802d99 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802d62:	90                   	nop
  802d63:	eb 01                	jmp    802d66 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802d65:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6a:	48 89 c6             	mov    %rax,%rsi
  802d6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d72:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802d79:	00 00 00 
  802d7c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d82:	48 89 c6             	mov    %rax,%rsi
  802d85:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8a:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
	return r;
  802d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d99:	c9                   	leaveq 
  802d9a:	c3                   	retq   

0000000000802d9b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d9b:	55                   	push   %rbp
  802d9c:	48 89 e5             	mov    %rsp,%rbp
  802d9f:	48 83 ec 40          	sub    $0x40,%rsp
  802da3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802da6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802daa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802db2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802db5:	48 89 d6             	mov    %rdx,%rsi
  802db8:	89 c7                	mov    %eax,%edi
  802dba:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
  802dc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcd:	78 24                	js     802df3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd3:	8b 00                	mov    (%rax),%eax
  802dd5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dd9:	48 89 d6             	mov    %rdx,%rsi
  802ddc:	89 c7                	mov    %eax,%edi
  802dde:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802de5:	00 00 00 
  802de8:	ff d0                	callq  *%rax
  802dea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ded:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df1:	79 05                	jns    802df8 <read+0x5d>
		return r;
  802df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df6:	eb 76                	jmp    802e6e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfc:	8b 40 08             	mov    0x8(%rax),%eax
  802dff:	83 e0 03             	and    $0x3,%eax
  802e02:	83 f8 01             	cmp    $0x1,%eax
  802e05:	75 3a                	jne    802e41 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e07:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e0e:	00 00 00 
  802e11:	48 8b 00             	mov    (%rax),%rax
  802e14:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e1a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e1d:	89 c6                	mov    %eax,%esi
  802e1f:	48 bf 77 52 80 00 00 	movabs $0x805277,%rdi
  802e26:	00 00 00 
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  802e35:	00 00 00 
  802e38:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e3f:	eb 2d                	jmp    802e6e <read+0xd3>
	}
	if (!dev->dev_read)
  802e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e45:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e49:	48 85 c0             	test   %rax,%rax
  802e4c:	75 07                	jne    802e55 <read+0xba>
		return -E_NOT_SUPP;
  802e4e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e53:	eb 19                	jmp    802e6e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e59:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e5d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e65:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e69:	48 89 cf             	mov    %rcx,%rdi
  802e6c:	ff d0                	callq  *%rax
}
  802e6e:	c9                   	leaveq 
  802e6f:	c3                   	retq   

0000000000802e70 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
  802e74:	48 83 ec 30          	sub    $0x30,%rsp
  802e78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e8a:	eb 47                	jmp    802ed3 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8f:	48 98                	cltq   
  802e91:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e95:	48 29 c2             	sub    %rax,%rdx
  802e98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9b:	48 63 c8             	movslq %eax,%rcx
  802e9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea2:	48 01 c1             	add    %rax,%rcx
  802ea5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea8:	48 89 ce             	mov    %rcx,%rsi
  802eab:	89 c7                	mov    %eax,%edi
  802ead:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
  802eb9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ebc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ec0:	79 05                	jns    802ec7 <readn+0x57>
			return m;
  802ec2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ec5:	eb 1d                	jmp    802ee4 <readn+0x74>
		if (m == 0)
  802ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ecb:	74 13                	je     802ee0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ecd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ed0:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed6:	48 98                	cltq   
  802ed8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802edc:	72 ae                	jb     802e8c <readn+0x1c>
  802ede:	eb 01                	jmp    802ee1 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802ee0:	90                   	nop
	}
	return tot;
  802ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ee4:	c9                   	leaveq 
  802ee5:	c3                   	retq   

0000000000802ee6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ee6:	55                   	push   %rbp
  802ee7:	48 89 e5             	mov    %rsp,%rbp
  802eea:	48 83 ec 40          	sub    $0x40,%rsp
  802eee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ef1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ef5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ef9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802efd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f00:	48 89 d6             	mov    %rdx,%rsi
  802f03:	89 c7                	mov    %eax,%edi
  802f05:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f18:	78 24                	js     802f3e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1e:	8b 00                	mov    (%rax),%eax
  802f20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f24:	48 89 d6             	mov    %rdx,%rsi
  802f27:	89 c7                	mov    %eax,%edi
  802f29:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
  802f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3c:	79 05                	jns    802f43 <write+0x5d>
		return r;
  802f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f41:	eb 75                	jmp    802fb8 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	8b 40 08             	mov    0x8(%rax),%eax
  802f4a:	83 e0 03             	and    $0x3,%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	75 3a                	jne    802f8b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f51:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802f58:	00 00 00 
  802f5b:	48 8b 00             	mov    (%rax),%rax
  802f5e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f64:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f67:	89 c6                	mov    %eax,%esi
  802f69:	48 bf 93 52 80 00 00 	movabs $0x805293,%rdi
  802f70:	00 00 00 
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
  802f78:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  802f7f:	00 00 00 
  802f82:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f89:	eb 2d                	jmp    802fb8 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f93:	48 85 c0             	test   %rax,%rax
  802f96:	75 07                	jne    802f9f <write+0xb9>
		return -E_NOT_SUPP;
  802f98:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f9d:	eb 19                	jmp    802fb8 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fa7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802faf:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fb3:	48 89 cf             	mov    %rcx,%rdi
  802fb6:	ff d0                	callq  *%rax
}
  802fb8:	c9                   	leaveq 
  802fb9:	c3                   	retq   

0000000000802fba <seek>:

int
seek(int fdnum, off_t offset)
{
  802fba:	55                   	push   %rbp
  802fbb:	48 89 e5             	mov    %rsp,%rbp
  802fbe:	48 83 ec 18          	sub    $0x18,%rsp
  802fc2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fc5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fcf:	48 89 d6             	mov    %rdx,%rsi
  802fd2:	89 c7                	mov    %eax,%edi
  802fd4:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe7:	79 05                	jns    802fee <seek+0x34>
		return r;
  802fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fec:	eb 0f                	jmp    802ffd <seek+0x43>
	fd->fd_offset = offset;
  802fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ff5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ffd:	c9                   	leaveq 
  802ffe:	c3                   	retq   

0000000000802fff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802fff:	55                   	push   %rbp
  803000:	48 89 e5             	mov    %rsp,%rbp
  803003:	48 83 ec 30          	sub    $0x30,%rsp
  803007:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80300a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80300d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803011:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803014:	48 89 d6             	mov    %rdx,%rsi
  803017:	89 c7                	mov    %eax,%edi
  803019:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302c:	78 24                	js     803052 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80302e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803032:	8b 00                	mov    (%rax),%eax
  803034:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803038:	48 89 d6             	mov    %rdx,%rsi
  80303b:	89 c7                	mov    %eax,%edi
  80303d:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
  803049:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803050:	79 05                	jns    803057 <ftruncate+0x58>
		return r;
  803052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803055:	eb 72                	jmp    8030c9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305b:	8b 40 08             	mov    0x8(%rax),%eax
  80305e:	83 e0 03             	and    $0x3,%eax
  803061:	85 c0                	test   %eax,%eax
  803063:	75 3a                	jne    80309f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803065:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80306c:	00 00 00 
  80306f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803072:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803078:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80307b:	89 c6                	mov    %eax,%esi
  80307d:	48 bf b0 52 80 00 00 	movabs $0x8052b0,%rdi
  803084:	00 00 00 
  803087:	b8 00 00 00 00       	mov    $0x0,%eax
  80308c:	48 b9 68 06 80 00 00 	movabs $0x800668,%rcx
  803093:	00 00 00 
  803096:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80309d:	eb 2a                	jmp    8030c9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80309f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030a7:	48 85 c0             	test   %rax,%rax
  8030aa:	75 07                	jne    8030b3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030b1:	eb 16                	jmp    8030c9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030bf:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030c2:	89 ce                	mov    %ecx,%esi
  8030c4:	48 89 d7             	mov    %rdx,%rdi
  8030c7:	ff d0                	callq  *%rax
}
  8030c9:	c9                   	leaveq 
  8030ca:	c3                   	retq   

00000000008030cb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030cb:	55                   	push   %rbp
  8030cc:	48 89 e5             	mov    %rsp,%rbp
  8030cf:	48 83 ec 30          	sub    $0x30,%rsp
  8030d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030e1:	48 89 d6             	mov    %rdx,%rsi
  8030e4:	89 c7                	mov    %eax,%edi
  8030e6:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
  8030f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f9:	78 24                	js     80311f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ff:	8b 00                	mov    (%rax),%eax
  803101:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803105:	48 89 d6             	mov    %rdx,%rsi
  803108:	89 c7                	mov    %eax,%edi
  80310a:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
  803116:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803119:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311d:	79 05                	jns    803124 <fstat+0x59>
		return r;
  80311f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803122:	eb 5e                	jmp    803182 <fstat+0xb7>
	if (!dev->dev_stat)
  803124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803128:	48 8b 40 28          	mov    0x28(%rax),%rax
  80312c:	48 85 c0             	test   %rax,%rax
  80312f:	75 07                	jne    803138 <fstat+0x6d>
		return -E_NOT_SUPP;
  803131:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803136:	eb 4a                	jmp    803182 <fstat+0xb7>
	stat->st_name[0] = 0;
  803138:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80313c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80313f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803143:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80314a:	00 00 00 
	stat->st_isdir = 0;
  80314d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803151:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803158:	00 00 00 
	stat->st_dev = dev;
  80315b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80315f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803163:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80316a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316e:	48 8b 40 28          	mov    0x28(%rax),%rax
  803172:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803176:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80317a:	48 89 ce             	mov    %rcx,%rsi
  80317d:	48 89 d7             	mov    %rdx,%rdi
  803180:	ff d0                	callq  *%rax
}
  803182:	c9                   	leaveq 
  803183:	c3                   	retq   

0000000000803184 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803184:	55                   	push   %rbp
  803185:	48 89 e5             	mov    %rsp,%rbp
  803188:	48 83 ec 20          	sub    $0x20,%rsp
  80318c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803190:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803198:	be 00 00 00 00       	mov    $0x0,%esi
  80319d:	48 89 c7             	mov    %rax,%rdi
  8031a0:	48 b8 74 32 80 00 00 	movabs $0x803274,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
  8031ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b3:	79 05                	jns    8031ba <stat+0x36>
		return fd;
  8031b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b8:	eb 2f                	jmp    8031e9 <stat+0x65>
	r = fstat(fd, stat);
  8031ba:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c1:	48 89 d6             	mov    %rdx,%rsi
  8031c4:	89 c7                	mov    %eax,%edi
  8031c6:	48 b8 cb 30 80 00 00 	movabs $0x8030cb,%rax
  8031cd:	00 00 00 
  8031d0:	ff d0                	callq  *%rax
  8031d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d8:	89 c7                	mov    %eax,%edi
  8031da:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
	return r;
  8031e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8031e9:	c9                   	leaveq 
  8031ea:	c3                   	retq   

00000000008031eb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8031eb:	55                   	push   %rbp
  8031ec:	48 89 e5             	mov    %rsp,%rbp
  8031ef:	48 83 ec 10          	sub    $0x10,%rsp
  8031f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8031fa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803201:	00 00 00 
  803204:	8b 00                	mov    (%rax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	75 1f                	jne    803229 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80320a:	bf 01 00 00 00       	mov    $0x1,%edi
  80320f:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  803216:	00 00 00 
  803219:	ff d0                	callq  *%rax
  80321b:	89 c2                	mov    %eax,%edx
  80321d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803224:	00 00 00 
  803227:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803229:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803230:	00 00 00 
  803233:	8b 00                	mov    (%rax),%eax
  803235:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803238:	b9 07 00 00 00       	mov    $0x7,%ecx
  80323d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803244:	00 00 00 
  803247:	89 c7                	mov    %eax,%edi
  803249:	48 b8 03 26 80 00 00 	movabs $0x802603,%rax
  803250:	00 00 00 
  803253:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803259:	ba 00 00 00 00       	mov    $0x0,%edx
  80325e:	48 89 c6             	mov    %rax,%rsi
  803261:	bf 00 00 00 00       	mov    $0x0,%edi
  803266:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	48 83 ec 20          	sub    $0x20,%rsp
  80327c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803280:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803287:	48 89 c7             	mov    %rax,%rdi
  80328a:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  803291:	00 00 00 
  803294:	ff d0                	callq  *%rax
  803296:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80329b:	7e 0a                	jle    8032a7 <open+0x33>
		return -E_BAD_PATH;
  80329d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032a2:	e9 a5 00 00 00       	jmpq   80334c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8032a7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032ab:	48 89 c7             	mov    %rax,%rdi
  8032ae:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
  8032ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c1:	79 08                	jns    8032cb <open+0x57>
		return r;
  8032c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c6:	e9 81 00 00 00       	jmpq   80334c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8032cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032cf:	48 89 c6             	mov    %rax,%rsi
  8032d2:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032d9:	00 00 00 
  8032dc:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8032e8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ef:	00 00 00 
  8032f2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032f5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8032fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ff:	48 89 c6             	mov    %rax,%rsi
  803302:	bf 01 00 00 00       	mov    $0x1,%edi
  803307:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  80330e:	00 00 00 
  803311:	ff d0                	callq  *%rax
  803313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331a:	79 1d                	jns    803339 <open+0xc5>
		fd_close(fd, 0);
  80331c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803320:	be 00 00 00 00       	mov    $0x0,%esi
  803325:	48 89 c7             	mov    %rax,%rdi
  803328:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
		return r;
  803334:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803337:	eb 13                	jmp    80334c <open+0xd8>
	}

	return fd2num(fd);
  803339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333d:	48 89 c7             	mov    %rax,%rdi
  803340:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax

}
  80334c:	c9                   	leaveq 
  80334d:	c3                   	retq   

000000000080334e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80334e:	55                   	push   %rbp
  80334f:	48 89 e5             	mov    %rsp,%rbp
  803352:	48 83 ec 10          	sub    $0x10,%rsp
  803356:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80335a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80335e:	8b 50 0c             	mov    0xc(%rax),%edx
  803361:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803368:	00 00 00 
  80336b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80336d:	be 00 00 00 00       	mov    $0x0,%esi
  803372:	bf 06 00 00 00       	mov    $0x6,%edi
  803377:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
}
  803383:	c9                   	leaveq 
  803384:	c3                   	retq   

0000000000803385 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803385:	55                   	push   %rbp
  803386:	48 89 e5             	mov    %rsp,%rbp
  803389:	48 83 ec 30          	sub    $0x30,%rsp
  80338d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803391:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803395:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339d:	8b 50 0c             	mov    0xc(%rax),%edx
  8033a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a7:	00 00 00 
  8033aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033b3:	00 00 00 
  8033b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033ba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8033be:	be 00 00 00 00       	mov    $0x0,%esi
  8033c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8033c8:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033db:	79 08                	jns    8033e5 <devfile_read+0x60>
		return r;
  8033dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e0:	e9 a4 00 00 00       	jmpq   803489 <devfile_read+0x104>
	assert(r <= n);
  8033e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e8:	48 98                	cltq   
  8033ea:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8033ee:	76 35                	jbe    803425 <devfile_read+0xa0>
  8033f0:	48 b9 d6 52 80 00 00 	movabs $0x8052d6,%rcx
  8033f7:	00 00 00 
  8033fa:	48 ba dd 52 80 00 00 	movabs $0x8052dd,%rdx
  803401:	00 00 00 
  803404:	be 86 00 00 00       	mov    $0x86,%esi
  803409:	48 bf f2 52 80 00 00 	movabs $0x8052f2,%rdi
  803410:	00 00 00 
  803413:	b8 00 00 00 00       	mov    $0x0,%eax
  803418:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80341f:	00 00 00 
  803422:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803425:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80342c:	7e 35                	jle    803463 <devfile_read+0xde>
  80342e:	48 b9 fd 52 80 00 00 	movabs $0x8052fd,%rcx
  803435:	00 00 00 
  803438:	48 ba dd 52 80 00 00 	movabs $0x8052dd,%rdx
  80343f:	00 00 00 
  803442:	be 87 00 00 00       	mov    $0x87,%esi
  803447:	48 bf f2 52 80 00 00 	movabs $0x8052f2,%rdi
  80344e:	00 00 00 
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
  803456:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80345d:	00 00 00 
  803460:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803466:	48 63 d0             	movslq %eax,%rdx
  803469:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803474:	00 00 00 
  803477:	48 89 c7             	mov    %rax,%rdi
  80347a:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
	return r;
  803486:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803489:	c9                   	leaveq 
  80348a:	c3                   	retq   

000000000080348b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80348b:	55                   	push   %rbp
  80348c:	48 89 e5             	mov    %rsp,%rbp
  80348f:	48 83 ec 40          	sub    $0x40,%rsp
  803493:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803497:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80349b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80349f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8034a7:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8034ae:	00 
  8034af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8034b7:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8034bc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034ce:	00 00 00 
  8034d1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8034d3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034da:	00 00 00 
  8034dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8034e1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8034e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8034e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ed:	48 89 c6             	mov    %rax,%rsi
  8034f0:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8034f7:	00 00 00 
  8034fa:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803506:	be 00 00 00 00       	mov    $0x0,%esi
  80350b:	bf 04 00 00 00       	mov    $0x4,%edi
  803510:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  803517:	00 00 00 
  80351a:	ff d0                	callq  *%rax
  80351c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80351f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803523:	79 05                	jns    80352a <devfile_write+0x9f>
		return r;
  803525:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803528:	eb 43                	jmp    80356d <devfile_write+0xe2>
	assert(r <= n);
  80352a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352d:	48 98                	cltq   
  80352f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803533:	76 35                	jbe    80356a <devfile_write+0xdf>
  803535:	48 b9 d6 52 80 00 00 	movabs $0x8052d6,%rcx
  80353c:	00 00 00 
  80353f:	48 ba dd 52 80 00 00 	movabs $0x8052dd,%rdx
  803546:	00 00 00 
  803549:	be a2 00 00 00       	mov    $0xa2,%esi
  80354e:	48 bf f2 52 80 00 00 	movabs $0x8052f2,%rdi
  803555:	00 00 00 
  803558:	b8 00 00 00 00       	mov    $0x0,%eax
  80355d:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  803564:	00 00 00 
  803567:	41 ff d0             	callq  *%r8
	return r;
  80356a:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80356d:	c9                   	leaveq 
  80356e:	c3                   	retq   

000000000080356f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80356f:	55                   	push   %rbp
  803570:	48 89 e5             	mov    %rsp,%rbp
  803573:	48 83 ec 20          	sub    $0x20,%rsp
  803577:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80357b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80357f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803583:	8b 50 0c             	mov    0xc(%rax),%edx
  803586:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80358d:	00 00 00 
  803590:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803592:	be 00 00 00 00       	mov    $0x0,%esi
  803597:	bf 05 00 00 00       	mov    $0x5,%edi
  80359c:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  8035a3:	00 00 00 
  8035a6:	ff d0                	callq  *%rax
  8035a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035af:	79 05                	jns    8035b6 <devfile_stat+0x47>
		return r;
  8035b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b4:	eb 56                	jmp    80360c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ba:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8035c1:	00 00 00 
  8035c4:	48 89 c7             	mov    %rax,%rdi
  8035c7:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8035d3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035da:	00 00 00 
  8035dd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8035e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8035ed:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035f4:	00 00 00 
  8035f7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8035fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803601:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803607:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80360c:	c9                   	leaveq 
  80360d:	c3                   	retq   

000000000080360e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80360e:	55                   	push   %rbp
  80360f:	48 89 e5             	mov    %rsp,%rbp
  803612:	48 83 ec 10          	sub    $0x10,%rsp
  803616:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80361a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80361d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803621:	8b 50 0c             	mov    0xc(%rax),%edx
  803624:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80362b:	00 00 00 
  80362e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803630:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803637:	00 00 00 
  80363a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80363d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803640:	be 00 00 00 00       	mov    $0x0,%esi
  803645:	bf 02 00 00 00       	mov    $0x2,%edi
  80364a:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
}
  803656:	c9                   	leaveq 
  803657:	c3                   	retq   

0000000000803658 <remove>:

// Delete a file
int
remove(const char *path)
{
  803658:	55                   	push   %rbp
  803659:	48 89 e5             	mov    %rsp,%rbp
  80365c:	48 83 ec 10          	sub    $0x10,%rsp
  803660:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803668:	48 89 c7             	mov    %rax,%rdi
  80366b:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
  803677:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80367c:	7e 07                	jle    803685 <remove+0x2d>
		return -E_BAD_PATH;
  80367e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803683:	eb 33                	jmp    8036b8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803689:	48 89 c6             	mov    %rax,%rsi
  80368c:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803693:	00 00 00 
  803696:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8036a2:	be 00 00 00 00       	mov    $0x0,%esi
  8036a7:	bf 07 00 00 00       	mov    $0x7,%edi
  8036ac:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
}
  8036b8:	c9                   	leaveq 
  8036b9:	c3                   	retq   

00000000008036ba <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8036ba:	55                   	push   %rbp
  8036bb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036be:	be 00 00 00 00       	mov    $0x0,%esi
  8036c3:	bf 08 00 00 00       	mov    $0x8,%edi
  8036c8:	48 b8 eb 31 80 00 00 	movabs $0x8031eb,%rax
  8036cf:	00 00 00 
  8036d2:	ff d0                	callq  *%rax
}
  8036d4:	5d                   	pop    %rbp
  8036d5:	c3                   	retq   

00000000008036d6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8036d6:	55                   	push   %rbp
  8036d7:	48 89 e5             	mov    %rsp,%rbp
  8036da:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8036e1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8036e8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8036ef:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8036f6:	be 00 00 00 00       	mov    $0x0,%esi
  8036fb:	48 89 c7             	mov    %rax,%rdi
  8036fe:	48 b8 74 32 80 00 00 	movabs $0x803274,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
  80370a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80370d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803711:	79 28                	jns    80373b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803716:	89 c6                	mov    %eax,%esi
  803718:	48 bf 09 53 80 00 00 	movabs $0x805309,%rdi
  80371f:	00 00 00 
  803722:	b8 00 00 00 00       	mov    $0x0,%eax
  803727:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80372e:	00 00 00 
  803731:	ff d2                	callq  *%rdx
		return fd_src;
  803733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803736:	e9 76 01 00 00       	jmpq   8038b1 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80373b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803742:	be 01 01 00 00       	mov    $0x101,%esi
  803747:	48 89 c7             	mov    %rax,%rdi
  80374a:	48 b8 74 32 80 00 00 	movabs $0x803274,%rax
  803751:	00 00 00 
  803754:	ff d0                	callq  *%rax
  803756:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803759:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80375d:	0f 89 ad 00 00 00    	jns    803810 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803763:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803766:	89 c6                	mov    %eax,%esi
  803768:	48 bf 1f 53 80 00 00 	movabs $0x80531f,%rdi
  80376f:	00 00 00 
  803772:	b8 00 00 00 00       	mov    $0x0,%eax
  803777:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80377e:	00 00 00 
  803781:	ff d2                	callq  *%rdx
		close(fd_src);
  803783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803786:	89 c7                	mov    %eax,%edi
  803788:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
		return fd_dest;
  803794:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803797:	e9 15 01 00 00       	jmpq   8038b1 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80379c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80379f:	48 63 d0             	movslq %eax,%rdx
  8037a2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8037a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037ac:	48 89 ce             	mov    %rcx,%rsi
  8037af:	89 c7                	mov    %eax,%edi
  8037b1:	48 b8 e6 2e 80 00 00 	movabs $0x802ee6,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
  8037bd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8037c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8037c4:	79 4a                	jns    803810 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8037c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8037c9:	89 c6                	mov    %eax,%esi
  8037cb:	48 bf 39 53 80 00 00 	movabs $0x805339,%rdi
  8037d2:	00 00 00 
  8037d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037da:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  8037e1:	00 00 00 
  8037e4:	ff d2                	callq  *%rdx
			close(fd_src);
  8037e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e9:	89 c7                	mov    %eax,%edi
  8037eb:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
			close(fd_dest);
  8037f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037fa:	89 c7                	mov    %eax,%edi
  8037fc:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  803803:	00 00 00 
  803806:	ff d0                	callq  *%rax
			return write_size;
  803808:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80380b:	e9 a1 00 00 00       	jmpq   8038b1 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803810:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381a:	ba 00 02 00 00       	mov    $0x200,%edx
  80381f:	48 89 ce             	mov    %rcx,%rsi
  803822:	89 c7                	mov    %eax,%edi
  803824:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
  803830:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803833:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803837:	0f 8f 5f ff ff ff    	jg     80379c <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80383d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803841:	79 47                	jns    80388a <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803843:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803846:	89 c6                	mov    %eax,%esi
  803848:	48 bf 4c 53 80 00 00 	movabs $0x80534c,%rdi
  80384f:	00 00 00 
  803852:	b8 00 00 00 00       	mov    $0x0,%eax
  803857:	48 ba 68 06 80 00 00 	movabs $0x800668,%rdx
  80385e:	00 00 00 
  803861:	ff d2                	callq  *%rdx
		close(fd_src);
  803863:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803866:	89 c7                	mov    %eax,%edi
  803868:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  80386f:	00 00 00 
  803872:	ff d0                	callq  *%rax
		close(fd_dest);
  803874:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803877:	89 c7                	mov    %eax,%edi
  803879:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  803880:	00 00 00 
  803883:	ff d0                	callq  *%rax
		return read_size;
  803885:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803888:	eb 27                	jmp    8038b1 <copy+0x1db>
	}
	close(fd_src);
  80388a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388d:	89 c7                	mov    %eax,%edi
  80388f:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
	close(fd_dest);
  80389b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80389e:	89 c7                	mov    %eax,%edi
  8038a0:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  8038a7:	00 00 00 
  8038aa:	ff d0                	callq  *%rax
	return 0;
  8038ac:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8038b1:	c9                   	leaveq 
  8038b2:	c3                   	retq   

00000000008038b3 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8038b3:	55                   	push   %rbp
  8038b4:	48 89 e5             	mov    %rsp,%rbp
  8038b7:	48 83 ec 18          	sub    $0x18,%rsp
  8038bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8038bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c3:	48 c1 e8 15          	shr    $0x15,%rax
  8038c7:	48 89 c2             	mov    %rax,%rdx
  8038ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038d1:	01 00 00 
  8038d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038d8:	83 e0 01             	and    $0x1,%eax
  8038db:	48 85 c0             	test   %rax,%rax
  8038de:	75 07                	jne    8038e7 <pageref+0x34>
		return 0;
  8038e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e5:	eb 56                	jmp    80393d <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8038e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038eb:	48 c1 e8 0c          	shr    $0xc,%rax
  8038ef:	48 89 c2             	mov    %rax,%rdx
  8038f2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038f9:	01 00 00 
  8038fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803900:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803904:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803908:	83 e0 01             	and    $0x1,%eax
  80390b:	48 85 c0             	test   %rax,%rax
  80390e:	75 07                	jne    803917 <pageref+0x64>
		return 0;
  803910:	b8 00 00 00 00       	mov    $0x0,%eax
  803915:	eb 26                	jmp    80393d <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  803917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391b:	48 c1 e8 0c          	shr    $0xc,%rax
  80391f:	48 89 c2             	mov    %rax,%rdx
  803922:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803929:	00 00 00 
  80392c:	48 c1 e2 04          	shl    $0x4,%rdx
  803930:	48 01 d0             	add    %rdx,%rax
  803933:	48 83 c0 08          	add    $0x8,%rax
  803937:	0f b7 00             	movzwl (%rax),%eax
  80393a:	0f b7 c0             	movzwl %ax,%eax
}
  80393d:	c9                   	leaveq 
  80393e:	c3                   	retq   

000000000080393f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80393f:	55                   	push   %rbp
  803940:	48 89 e5             	mov    %rsp,%rbp
  803943:	48 83 ec 20          	sub    $0x20,%rsp
  803947:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80394a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80394e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803951:	48 89 d6             	mov    %rdx,%rsi
  803954:	89 c7                	mov    %eax,%edi
  803956:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  80395d:	00 00 00 
  803960:	ff d0                	callq  *%rax
  803962:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803965:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803969:	79 05                	jns    803970 <fd2sockid+0x31>
		return r;
  80396b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396e:	eb 24                	jmp    803994 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803974:	8b 10                	mov    (%rax),%edx
  803976:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80397d:	00 00 00 
  803980:	8b 00                	mov    (%rax),%eax
  803982:	39 c2                	cmp    %eax,%edx
  803984:	74 07                	je     80398d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803986:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80398b:	eb 07                	jmp    803994 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80398d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803991:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803994:	c9                   	leaveq 
  803995:	c3                   	retq   

0000000000803996 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803996:	55                   	push   %rbp
  803997:	48 89 e5             	mov    %rsp,%rbp
  80399a:	48 83 ec 20          	sub    $0x20,%rsp
  80399e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8039a1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
  8039b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039bb:	78 26                	js     8039e3 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8039bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c1:	ba 07 04 00 00       	mov    $0x407,%edx
  8039c6:	48 89 c6             	mov    %rax,%rsi
  8039c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ce:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
  8039da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e1:	79 16                	jns    8039f9 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8039e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e6:	89 c7                	mov    %eax,%edi
  8039e8:	48 b8 a5 3e 80 00 00 	movabs $0x803ea5,%rax
  8039ef:	00 00 00 
  8039f2:	ff d0                	callq  *%rax
		return r;
  8039f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f7:	eb 3a                	jmp    803a33 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8039f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039fd:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803a04:	00 00 00 
  803a07:	8b 12                	mov    (%rdx),%edx
  803a09:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a1d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a24:	48 89 c7             	mov    %rax,%rdi
  803a27:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  803a2e:	00 00 00 
  803a31:	ff d0                	callq  *%rax
}
  803a33:	c9                   	leaveq 
  803a34:	c3                   	retq   

0000000000803a35 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a35:	55                   	push   %rbp
  803a36:	48 89 e5             	mov    %rsp,%rbp
  803a39:	48 83 ec 30          	sub    $0x30,%rsp
  803a3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a44:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a4b:	89 c7                	mov    %eax,%edi
  803a4d:	48 b8 3f 39 80 00 00 	movabs $0x80393f,%rax
  803a54:	00 00 00 
  803a57:	ff d0                	callq  *%rax
  803a59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a60:	79 05                	jns    803a67 <accept+0x32>
		return r;
  803a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a65:	eb 3b                	jmp    803aa2 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803a67:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a6b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a72:	48 89 ce             	mov    %rcx,%rsi
  803a75:	89 c7                	mov    %eax,%edi
  803a77:	48 b8 82 3d 80 00 00 	movabs $0x803d82,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
  803a83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a8a:	79 05                	jns    803a91 <accept+0x5c>
		return r;
  803a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8f:	eb 11                	jmp    803aa2 <accept+0x6d>
	return alloc_sockfd(r);
  803a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a94:	89 c7                	mov    %eax,%edi
  803a96:	48 b8 96 39 80 00 00 	movabs $0x803996,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
}
  803aa2:	c9                   	leaveq 
  803aa3:	c3                   	retq   

0000000000803aa4 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803aa4:	55                   	push   %rbp
  803aa5:	48 89 e5             	mov    %rsp,%rbp
  803aa8:	48 83 ec 20          	sub    $0x20,%rsp
  803aac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aaf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ab3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ab6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ab9:	89 c7                	mov    %eax,%edi
  803abb:	48 b8 3f 39 80 00 00 	movabs $0x80393f,%rax
  803ac2:	00 00 00 
  803ac5:	ff d0                	callq  *%rax
  803ac7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ace:	79 05                	jns    803ad5 <bind+0x31>
		return r;
  803ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad3:	eb 1b                	jmp    803af0 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803ad5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ad8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803adf:	48 89 ce             	mov    %rcx,%rsi
  803ae2:	89 c7                	mov    %eax,%edi
  803ae4:	48 b8 01 3e 80 00 00 	movabs $0x803e01,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
}
  803af0:	c9                   	leaveq 
  803af1:	c3                   	retq   

0000000000803af2 <shutdown>:

int
shutdown(int s, int how)
{
  803af2:	55                   	push   %rbp
  803af3:	48 89 e5             	mov    %rsp,%rbp
  803af6:	48 83 ec 20          	sub    $0x20,%rsp
  803afa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803afd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b03:	89 c7                	mov    %eax,%edi
  803b05:	48 b8 3f 39 80 00 00 	movabs $0x80393f,%rax
  803b0c:	00 00 00 
  803b0f:	ff d0                	callq  *%rax
  803b11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b18:	79 05                	jns    803b1f <shutdown+0x2d>
		return r;
  803b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b1d:	eb 16                	jmp    803b35 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803b1f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b25:	89 d6                	mov    %edx,%esi
  803b27:	89 c7                	mov    %eax,%edi
  803b29:	48 b8 65 3e 80 00 00 	movabs $0x803e65,%rax
  803b30:	00 00 00 
  803b33:	ff d0                	callq  *%rax
}
  803b35:	c9                   	leaveq 
  803b36:	c3                   	retq   

0000000000803b37 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803b37:	55                   	push   %rbp
  803b38:	48 89 e5             	mov    %rsp,%rbp
  803b3b:	48 83 ec 10          	sub    $0x10,%rsp
  803b3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803b43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b47:	48 89 c7             	mov    %rax,%rdi
  803b4a:	48 b8 b3 38 80 00 00 	movabs $0x8038b3,%rax
  803b51:	00 00 00 
  803b54:	ff d0                	callq  *%rax
  803b56:	83 f8 01             	cmp    $0x1,%eax
  803b59:	75 17                	jne    803b72 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b5f:	8b 40 0c             	mov    0xc(%rax),%eax
  803b62:	89 c7                	mov    %eax,%edi
  803b64:	48 b8 a5 3e 80 00 00 	movabs $0x803ea5,%rax
  803b6b:	00 00 00 
  803b6e:	ff d0                	callq  *%rax
  803b70:	eb 05                	jmp    803b77 <devsock_close+0x40>
	else
		return 0;
  803b72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b77:	c9                   	leaveq 
  803b78:	c3                   	retq   

0000000000803b79 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b79:	55                   	push   %rbp
  803b7a:	48 89 e5             	mov    %rsp,%rbp
  803b7d:	48 83 ec 20          	sub    $0x20,%rsp
  803b81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b88:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b8e:	89 c7                	mov    %eax,%edi
  803b90:	48 b8 3f 39 80 00 00 	movabs $0x80393f,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
  803b9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba3:	79 05                	jns    803baa <connect+0x31>
		return r;
  803ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba8:	eb 1b                	jmp    803bc5 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803baa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb4:	48 89 ce             	mov    %rcx,%rsi
  803bb7:	89 c7                	mov    %eax,%edi
  803bb9:	48 b8 d2 3e 80 00 00 	movabs $0x803ed2,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
}
  803bc5:	c9                   	leaveq 
  803bc6:	c3                   	retq   

0000000000803bc7 <listen>:

int
listen(int s, int backlog)
{
  803bc7:	55                   	push   %rbp
  803bc8:	48 89 e5             	mov    %rsp,%rbp
  803bcb:	48 83 ec 20          	sub    $0x20,%rsp
  803bcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bd2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bd5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd8:	89 c7                	mov    %eax,%edi
  803bda:	48 b8 3f 39 80 00 00 	movabs $0x80393f,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
  803be6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bed:	79 05                	jns    803bf4 <listen+0x2d>
		return r;
  803bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf2:	eb 16                	jmp    803c0a <listen+0x43>
	return nsipc_listen(r, backlog);
  803bf4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfa:	89 d6                	mov    %edx,%esi
  803bfc:	89 c7                	mov    %eax,%edi
  803bfe:	48 b8 36 3f 80 00 00 	movabs $0x803f36,%rax
  803c05:	00 00 00 
  803c08:	ff d0                	callq  *%rax
}
  803c0a:	c9                   	leaveq 
  803c0b:	c3                   	retq   

0000000000803c0c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c0c:	55                   	push   %rbp
  803c0d:	48 89 e5             	mov    %rsp,%rbp
  803c10:	48 83 ec 20          	sub    $0x20,%rsp
  803c14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c1c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c24:	89 c2                	mov    %eax,%edx
  803c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2a:	8b 40 0c             	mov    0xc(%rax),%eax
  803c2d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c31:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c36:	89 c7                	mov    %eax,%edi
  803c38:	48 b8 76 3f 80 00 00 	movabs $0x803f76,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
}
  803c44:	c9                   	leaveq 
  803c45:	c3                   	retq   

0000000000803c46 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c46:	55                   	push   %rbp
  803c47:	48 89 e5             	mov    %rsp,%rbp
  803c4a:	48 83 ec 20          	sub    $0x20,%rsp
  803c4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c56:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c5e:	89 c2                	mov    %eax,%edx
  803c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c64:	8b 40 0c             	mov    0xc(%rax),%eax
  803c67:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c70:	89 c7                	mov    %eax,%edi
  803c72:	48 b8 42 40 80 00 00 	movabs $0x804042,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
}
  803c7e:	c9                   	leaveq 
  803c7f:	c3                   	retq   

0000000000803c80 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c80:	55                   	push   %rbp
  803c81:	48 89 e5             	mov    %rsp,%rbp
  803c84:	48 83 ec 10          	sub    $0x10,%rsp
  803c88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c94:	48 be 67 53 80 00 00 	movabs $0x805367,%rsi
  803c9b:	00 00 00 
  803c9e:	48 89 c7             	mov    %rax,%rdi
  803ca1:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  803ca8:	00 00 00 
  803cab:	ff d0                	callq  *%rax
	return 0;
  803cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cb2:	c9                   	leaveq 
  803cb3:	c3                   	retq   

0000000000803cb4 <socket>:

int
socket(int domain, int type, int protocol)
{
  803cb4:	55                   	push   %rbp
  803cb5:	48 89 e5             	mov    %rsp,%rbp
  803cb8:	48 83 ec 20          	sub    $0x20,%rsp
  803cbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cbf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cc2:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803cc5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803cc8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ccb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cce:	89 ce                	mov    %ecx,%esi
  803cd0:	89 c7                	mov    %eax,%edi
  803cd2:	48 b8 fa 40 80 00 00 	movabs $0x8040fa,%rax
  803cd9:	00 00 00 
  803cdc:	ff d0                	callq  *%rax
  803cde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce5:	79 05                	jns    803cec <socket+0x38>
		return r;
  803ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cea:	eb 11                	jmp    803cfd <socket+0x49>
	return alloc_sockfd(r);
  803cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cef:	89 c7                	mov    %eax,%edi
  803cf1:	48 b8 96 39 80 00 00 	movabs $0x803996,%rax
  803cf8:	00 00 00 
  803cfb:	ff d0                	callq  *%rax
}
  803cfd:	c9                   	leaveq 
  803cfe:	c3                   	retq   

0000000000803cff <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803cff:	55                   	push   %rbp
  803d00:	48 89 e5             	mov    %rsp,%rbp
  803d03:	48 83 ec 10          	sub    $0x10,%rsp
  803d07:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803d0a:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d11:	00 00 00 
  803d14:	8b 00                	mov    (%rax),%eax
  803d16:	85 c0                	test   %eax,%eax
  803d18:	75 1f                	jne    803d39 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803d1a:	bf 02 00 00 00       	mov    $0x2,%edi
  803d1f:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  803d26:	00 00 00 
  803d29:	ff d0                	callq  *%rax
  803d2b:	89 c2                	mov    %eax,%edx
  803d2d:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d34:	00 00 00 
  803d37:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803d39:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d40:	00 00 00 
  803d43:	8b 00                	mov    (%rax),%eax
  803d45:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803d48:	b9 07 00 00 00       	mov    $0x7,%ecx
  803d4d:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803d54:	00 00 00 
  803d57:	89 c7                	mov    %eax,%edi
  803d59:	48 b8 03 26 80 00 00 	movabs $0x802603,%rax
  803d60:	00 00 00 
  803d63:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803d65:	ba 00 00 00 00       	mov    $0x0,%edx
  803d6a:	be 00 00 00 00       	mov    $0x0,%esi
  803d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d74:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
}
  803d80:	c9                   	leaveq 
  803d81:	c3                   	retq   

0000000000803d82 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d82:	55                   	push   %rbp
  803d83:	48 89 e5             	mov    %rsp,%rbp
  803d86:	48 83 ec 30          	sub    $0x30,%rsp
  803d8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803d95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9c:	00 00 00 
  803d9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803da2:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803da4:	bf 01 00 00 00       	mov    $0x1,%edi
  803da9:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803db0:	00 00 00 
  803db3:	ff d0                	callq  *%rax
  803db5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dbc:	78 3e                	js     803dfc <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803dbe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dc5:	00 00 00 
  803dc8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd0:	8b 40 10             	mov    0x10(%rax),%eax
  803dd3:	89 c2                	mov    %eax,%edx
  803dd5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ddd:	48 89 ce             	mov    %rcx,%rsi
  803de0:	48 89 c7             	mov    %rax,%rdi
  803de3:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803dea:	00 00 00 
  803ded:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df3:	8b 50 10             	mov    0x10(%rax),%edx
  803df6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfa:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dff:	c9                   	leaveq 
  803e00:	c3                   	retq   

0000000000803e01 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e01:	55                   	push   %rbp
  803e02:	48 89 e5             	mov    %rsp,%rbp
  803e05:	48 83 ec 10          	sub    $0x10,%rsp
  803e09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e10:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803e13:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e1a:	00 00 00 
  803e1d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e20:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e22:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e29:	48 89 c6             	mov    %rax,%rsi
  803e2c:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e33:	00 00 00 
  803e36:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803e3d:	00 00 00 
  803e40:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803e42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e49:	00 00 00 
  803e4c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e4f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803e52:	bf 02 00 00 00       	mov    $0x2,%edi
  803e57:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803e5e:	00 00 00 
  803e61:	ff d0                	callq  *%rax
}
  803e63:	c9                   	leaveq 
  803e64:	c3                   	retq   

0000000000803e65 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803e65:	55                   	push   %rbp
  803e66:	48 89 e5             	mov    %rsp,%rbp
  803e69:	48 83 ec 10          	sub    $0x10,%rsp
  803e6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e70:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803e73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e7a:	00 00 00 
  803e7d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e80:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803e82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e89:	00 00 00 
  803e8c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e8f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803e92:	bf 03 00 00 00       	mov    $0x3,%edi
  803e97:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803e9e:	00 00 00 
  803ea1:	ff d0                	callq  *%rax
}
  803ea3:	c9                   	leaveq 
  803ea4:	c3                   	retq   

0000000000803ea5 <nsipc_close>:

int
nsipc_close(int s)
{
  803ea5:	55                   	push   %rbp
  803ea6:	48 89 e5             	mov    %rsp,%rbp
  803ea9:	48 83 ec 10          	sub    $0x10,%rsp
  803ead:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803eb0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eb7:	00 00 00 
  803eba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ebd:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803ebf:	bf 04 00 00 00       	mov    $0x4,%edi
  803ec4:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803ecb:	00 00 00 
  803ece:	ff d0                	callq  *%rax
}
  803ed0:	c9                   	leaveq 
  803ed1:	c3                   	retq   

0000000000803ed2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ed2:	55                   	push   %rbp
  803ed3:	48 89 e5             	mov    %rsp,%rbp
  803ed6:	48 83 ec 10          	sub    $0x10,%rsp
  803eda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803edd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ee1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ee4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eeb:	00 00 00 
  803eee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ef1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ef3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efa:	48 89 c6             	mov    %rax,%rsi
  803efd:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803f04:	00 00 00 
  803f07:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803f0e:	00 00 00 
  803f11:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803f13:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f1a:	00 00 00 
  803f1d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f20:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803f23:	bf 05 00 00 00       	mov    $0x5,%edi
  803f28:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803f2f:	00 00 00 
  803f32:	ff d0                	callq  *%rax
}
  803f34:	c9                   	leaveq 
  803f35:	c3                   	retq   

0000000000803f36 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803f36:	55                   	push   %rbp
  803f37:	48 89 e5             	mov    %rsp,%rbp
  803f3a:	48 83 ec 10          	sub    $0x10,%rsp
  803f3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f41:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803f44:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f4b:	00 00 00 
  803f4e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f51:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803f53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f5a:	00 00 00 
  803f5d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f60:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803f63:	bf 06 00 00 00       	mov    $0x6,%edi
  803f68:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803f6f:	00 00 00 
  803f72:	ff d0                	callq  *%rax
}
  803f74:	c9                   	leaveq 
  803f75:	c3                   	retq   

0000000000803f76 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803f76:	55                   	push   %rbp
  803f77:	48 89 e5             	mov    %rsp,%rbp
  803f7a:	48 83 ec 30          	sub    $0x30,%rsp
  803f7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f85:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803f88:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803f8b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f92:	00 00 00 
  803f95:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f98:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803f9a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa1:	00 00 00 
  803fa4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803fa7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803faa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fb1:	00 00 00 
  803fb4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803fb7:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803fba:	bf 07 00 00 00       	mov    $0x7,%edi
  803fbf:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803fc6:	00 00 00 
  803fc9:	ff d0                	callq  *%rax
  803fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd2:	78 69                	js     80403d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803fd4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803fdb:	7f 08                	jg     803fe5 <nsipc_recv+0x6f>
  803fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803fe3:	7e 35                	jle    80401a <nsipc_recv+0xa4>
  803fe5:	48 b9 6e 53 80 00 00 	movabs $0x80536e,%rcx
  803fec:	00 00 00 
  803fef:	48 ba 83 53 80 00 00 	movabs $0x805383,%rdx
  803ff6:	00 00 00 
  803ff9:	be 62 00 00 00       	mov    $0x62,%esi
  803ffe:	48 bf 98 53 80 00 00 	movabs $0x805398,%rdi
  804005:	00 00 00 
  804008:	b8 00 00 00 00       	mov    $0x0,%eax
  80400d:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  804014:	00 00 00 
  804017:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80401a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401d:	48 63 d0             	movslq %eax,%rdx
  804020:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804024:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80402b:	00 00 00 
  80402e:	48 89 c7             	mov    %rax,%rdi
  804031:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  804038:	00 00 00 
  80403b:	ff d0                	callq  *%rax
	}

	return r;
  80403d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804040:	c9                   	leaveq 
  804041:	c3                   	retq   

0000000000804042 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804042:	55                   	push   %rbp
  804043:	48 89 e5             	mov    %rsp,%rbp
  804046:	48 83 ec 20          	sub    $0x20,%rsp
  80404a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80404d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804051:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804054:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804057:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80405e:	00 00 00 
  804061:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804064:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804066:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80406d:	7e 35                	jle    8040a4 <nsipc_send+0x62>
  80406f:	48 b9 a4 53 80 00 00 	movabs $0x8053a4,%rcx
  804076:	00 00 00 
  804079:	48 ba 83 53 80 00 00 	movabs $0x805383,%rdx
  804080:	00 00 00 
  804083:	be 6d 00 00 00       	mov    $0x6d,%esi
  804088:	48 bf 98 53 80 00 00 	movabs $0x805398,%rdi
  80408f:	00 00 00 
  804092:	b8 00 00 00 00       	mov    $0x0,%eax
  804097:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  80409e:	00 00 00 
  8040a1:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8040a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040a7:	48 63 d0             	movslq %eax,%rdx
  8040aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ae:	48 89 c6             	mov    %rax,%rsi
  8040b1:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8040b8:	00 00 00 
  8040bb:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8040c7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040ce:	00 00 00 
  8040d1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040d4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8040d7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040de:	00 00 00 
  8040e1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040e4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8040e7:	bf 08 00 00 00       	mov    $0x8,%edi
  8040ec:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  8040f3:	00 00 00 
  8040f6:	ff d0                	callq  *%rax
}
  8040f8:	c9                   	leaveq 
  8040f9:	c3                   	retq   

00000000008040fa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8040fa:	55                   	push   %rbp
  8040fb:	48 89 e5             	mov    %rsp,%rbp
  8040fe:	48 83 ec 10          	sub    $0x10,%rsp
  804102:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804105:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804108:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80410b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804112:	00 00 00 
  804115:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804118:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80411a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804121:	00 00 00 
  804124:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804127:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80412a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804131:	00 00 00 
  804134:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804137:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80413a:	bf 09 00 00 00       	mov    $0x9,%edi
  80413f:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  804146:	00 00 00 
  804149:	ff d0                	callq  *%rax
}
  80414b:	c9                   	leaveq 
  80414c:	c3                   	retq   

000000000080414d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80414d:	55                   	push   %rbp
  80414e:	48 89 e5             	mov    %rsp,%rbp
  804151:	53                   	push   %rbx
  804152:	48 83 ec 38          	sub    $0x38,%rsp
  804156:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80415a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80415e:	48 89 c7             	mov    %rax,%rdi
  804161:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  804168:	00 00 00 
  80416b:	ff d0                	callq  *%rax
  80416d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804170:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804174:	0f 88 bf 01 00 00    	js     804339 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80417a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80417e:	ba 07 04 00 00       	mov    $0x407,%edx
  804183:	48 89 c6             	mov    %rax,%rsi
  804186:	bf 00 00 00 00       	mov    $0x0,%edi
  80418b:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  804192:	00 00 00 
  804195:	ff d0                	callq  *%rax
  804197:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80419a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80419e:	0f 88 95 01 00 00    	js     804339 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8041a4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8041a8:	48 89 c7             	mov    %rax,%rdi
  8041ab:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  8041b2:	00 00 00 
  8041b5:	ff d0                	callq  *%rax
  8041b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041be:	0f 88 5d 01 00 00    	js     804321 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041c8:	ba 07 04 00 00       	mov    $0x407,%edx
  8041cd:	48 89 c6             	mov    %rax,%rsi
  8041d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d5:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8041dc:	00 00 00 
  8041df:	ff d0                	callq  *%rax
  8041e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041e8:	0f 88 33 01 00 00    	js     804321 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8041ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041f2:	48 89 c7             	mov    %rax,%rdi
  8041f5:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  8041fc:	00 00 00 
  8041ff:	ff d0                	callq  *%rax
  804201:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804209:	ba 07 04 00 00       	mov    $0x407,%edx
  80420e:	48 89 c6             	mov    %rax,%rsi
  804211:	bf 00 00 00 00       	mov    $0x0,%edi
  804216:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80421d:	00 00 00 
  804220:	ff d0                	callq  *%rax
  804222:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804225:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804229:	0f 88 d9 00 00 00    	js     804308 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80422f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804233:	48 89 c7             	mov    %rax,%rdi
  804236:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
  804242:	48 89 c2             	mov    %rax,%rdx
  804245:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804249:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80424f:	48 89 d1             	mov    %rdx,%rcx
  804252:	ba 00 00 00 00       	mov    $0x0,%edx
  804257:	48 89 c6             	mov    %rax,%rsi
  80425a:	bf 00 00 00 00       	mov    $0x0,%edi
  80425f:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  804266:	00 00 00 
  804269:	ff d0                	callq  *%rax
  80426b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80426e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804272:	78 79                	js     8042ed <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804278:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80427f:	00 00 00 
  804282:	8b 12                	mov    (%rdx),%edx
  804284:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804286:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80428a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804291:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804295:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80429c:	00 00 00 
  80429f:	8b 12                	mov    (%rdx),%edx
  8042a1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8042a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8042ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b2:	48 89 c7             	mov    %rax,%rdi
  8042b5:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  8042bc:	00 00 00 
  8042bf:	ff d0                	callq  *%rax
  8042c1:	89 c2                	mov    %eax,%edx
  8042c3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042c7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8042c9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042cd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8042d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042d5:	48 89 c7             	mov    %rax,%rdi
  8042d8:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  8042df:	00 00 00 
  8042e2:	ff d0                	callq  *%rax
  8042e4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8042e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042eb:	eb 4f                	jmp    80433c <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8042ed:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8042ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042f2:	48 89 c6             	mov    %rax,%rsi
  8042f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8042fa:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  804301:	00 00 00 
  804304:	ff d0                	callq  *%rax
  804306:	eb 01                	jmp    804309 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804308:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804309:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80430d:	48 89 c6             	mov    %rax,%rsi
  804310:	bf 00 00 00 00       	mov    $0x0,%edi
  804315:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  80431c:	00 00 00 
  80431f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804325:	48 89 c6             	mov    %rax,%rsi
  804328:	bf 00 00 00 00       	mov    $0x0,%edi
  80432d:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
err:
	return r;
  804339:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80433c:	48 83 c4 38          	add    $0x38,%rsp
  804340:	5b                   	pop    %rbx
  804341:	5d                   	pop    %rbp
  804342:	c3                   	retq   

0000000000804343 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804343:	55                   	push   %rbp
  804344:	48 89 e5             	mov    %rsp,%rbp
  804347:	53                   	push   %rbx
  804348:	48 83 ec 28          	sub    $0x28,%rsp
  80434c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804350:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804354:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80435b:	00 00 00 
  80435e:	48 8b 00             	mov    (%rax),%rax
  804361:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804367:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80436a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80436e:	48 89 c7             	mov    %rax,%rdi
  804371:	48 b8 b3 38 80 00 00 	movabs $0x8038b3,%rax
  804378:	00 00 00 
  80437b:	ff d0                	callq  *%rax
  80437d:	89 c3                	mov    %eax,%ebx
  80437f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804383:	48 89 c7             	mov    %rax,%rdi
  804386:	48 b8 b3 38 80 00 00 	movabs $0x8038b3,%rax
  80438d:	00 00 00 
  804390:	ff d0                	callq  *%rax
  804392:	39 c3                	cmp    %eax,%ebx
  804394:	0f 94 c0             	sete   %al
  804397:	0f b6 c0             	movzbl %al,%eax
  80439a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80439d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8043a4:	00 00 00 
  8043a7:	48 8b 00             	mov    (%rax),%rax
  8043aa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8043b0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8043b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043b6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8043b9:	75 05                	jne    8043c0 <_pipeisclosed+0x7d>
			return ret;
  8043bb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8043be:	eb 4a                	jmp    80440a <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8043c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043c3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8043c6:	74 8c                	je     804354 <_pipeisclosed+0x11>
  8043c8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8043cc:	75 86                	jne    804354 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8043ce:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8043d5:	00 00 00 
  8043d8:	48 8b 00             	mov    (%rax),%rax
  8043db:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8043e1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8043e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043e7:	89 c6                	mov    %eax,%esi
  8043e9:	48 bf b5 53 80 00 00 	movabs $0x8053b5,%rdi
  8043f0:	00 00 00 
  8043f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f8:	49 b8 68 06 80 00 00 	movabs $0x800668,%r8
  8043ff:	00 00 00 
  804402:	41 ff d0             	callq  *%r8
	}
  804405:	e9 4a ff ff ff       	jmpq   804354 <_pipeisclosed+0x11>

}
  80440a:	48 83 c4 28          	add    $0x28,%rsp
  80440e:	5b                   	pop    %rbx
  80440f:	5d                   	pop    %rbp
  804410:	c3                   	retq   

0000000000804411 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804411:	55                   	push   %rbp
  804412:	48 89 e5             	mov    %rsp,%rbp
  804415:	48 83 ec 30          	sub    $0x30,%rsp
  804419:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80441c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804420:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804423:	48 89 d6             	mov    %rdx,%rsi
  804426:	89 c7                	mov    %eax,%edi
  804428:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  80442f:	00 00 00 
  804432:	ff d0                	callq  *%rax
  804434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80443b:	79 05                	jns    804442 <pipeisclosed+0x31>
		return r;
  80443d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804440:	eb 31                	jmp    804473 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804446:	48 89 c7             	mov    %rax,%rdi
  804449:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  804450:	00 00 00 
  804453:	ff d0                	callq  *%rax
  804455:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80445d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804461:	48 89 d6             	mov    %rdx,%rsi
  804464:	48 89 c7             	mov    %rax,%rdi
  804467:	48 b8 43 43 80 00 00 	movabs $0x804343,%rax
  80446e:	00 00 00 
  804471:	ff d0                	callq  *%rax
}
  804473:	c9                   	leaveq 
  804474:	c3                   	retq   

0000000000804475 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804475:	55                   	push   %rbp
  804476:	48 89 e5             	mov    %rsp,%rbp
  804479:	48 83 ec 40          	sub    $0x40,%rsp
  80447d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804481:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804485:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804489:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80448d:	48 89 c7             	mov    %rax,%rdi
  804490:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  804497:	00 00 00 
  80449a:	ff d0                	callq  *%rax
  80449c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8044a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8044a8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8044af:	00 
  8044b0:	e9 90 00 00 00       	jmpq   804545 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8044b5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8044ba:	74 09                	je     8044c5 <devpipe_read+0x50>
				return i;
  8044bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c0:	e9 8e 00 00 00       	jmpq   804553 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8044c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044cd:	48 89 d6             	mov    %rdx,%rsi
  8044d0:	48 89 c7             	mov    %rax,%rdi
  8044d3:	48 b8 43 43 80 00 00 	movabs $0x804343,%rax
  8044da:	00 00 00 
  8044dd:	ff d0                	callq  *%rax
  8044df:	85 c0                	test   %eax,%eax
  8044e1:	74 07                	je     8044ea <devpipe_read+0x75>
				return 0;
  8044e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e8:	eb 69                	jmp    804553 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8044ea:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8044f1:	00 00 00 
  8044f4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8044f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fa:	8b 10                	mov    (%rax),%edx
  8044fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804500:	8b 40 04             	mov    0x4(%rax),%eax
  804503:	39 c2                	cmp    %eax,%edx
  804505:	74 ae                	je     8044b5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80450b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804517:	8b 00                	mov    (%rax),%eax
  804519:	99                   	cltd   
  80451a:	c1 ea 1b             	shr    $0x1b,%edx
  80451d:	01 d0                	add    %edx,%eax
  80451f:	83 e0 1f             	and    $0x1f,%eax
  804522:	29 d0                	sub    %edx,%eax
  804524:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804528:	48 98                	cltq   
  80452a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80452f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804535:	8b 00                	mov    (%rax),%eax
  804537:	8d 50 01             	lea    0x1(%rax),%edx
  80453a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80453e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804540:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804549:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80454d:	72 a7                	jb     8044f6 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80454f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804553:	c9                   	leaveq 
  804554:	c3                   	retq   

0000000000804555 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804555:	55                   	push   %rbp
  804556:	48 89 e5             	mov    %rsp,%rbp
  804559:	48 83 ec 40          	sub    $0x40,%rsp
  80455d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804561:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804565:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80456d:	48 89 c7             	mov    %rax,%rdi
  804570:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  804577:	00 00 00 
  80457a:	ff d0                	callq  *%rax
  80457c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804580:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804584:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804588:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80458f:	00 
  804590:	e9 8f 00 00 00       	jmpq   804624 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804595:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80459d:	48 89 d6             	mov    %rdx,%rsi
  8045a0:	48 89 c7             	mov    %rax,%rdi
  8045a3:	48 b8 43 43 80 00 00 	movabs $0x804343,%rax
  8045aa:	00 00 00 
  8045ad:	ff d0                	callq  *%rax
  8045af:	85 c0                	test   %eax,%eax
  8045b1:	74 07                	je     8045ba <devpipe_write+0x65>
				return 0;
  8045b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b8:	eb 78                	jmp    804632 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8045ba:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8045c1:	00 00 00 
  8045c4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8045c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ca:	8b 40 04             	mov    0x4(%rax),%eax
  8045cd:	48 63 d0             	movslq %eax,%rdx
  8045d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045d4:	8b 00                	mov    (%rax),%eax
  8045d6:	48 98                	cltq   
  8045d8:	48 83 c0 20          	add    $0x20,%rax
  8045dc:	48 39 c2             	cmp    %rax,%rdx
  8045df:	73 b4                	jae    804595 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8045e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e5:	8b 40 04             	mov    0x4(%rax),%eax
  8045e8:	99                   	cltd   
  8045e9:	c1 ea 1b             	shr    $0x1b,%edx
  8045ec:	01 d0                	add    %edx,%eax
  8045ee:	83 e0 1f             	and    $0x1f,%eax
  8045f1:	29 d0                	sub    %edx,%eax
  8045f3:	89 c6                	mov    %eax,%esi
  8045f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8045f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045fd:	48 01 d0             	add    %rdx,%rax
  804600:	0f b6 08             	movzbl (%rax),%ecx
  804603:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804607:	48 63 c6             	movslq %esi,%rax
  80460a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80460e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804612:	8b 40 04             	mov    0x4(%rax),%eax
  804615:	8d 50 01             	lea    0x1(%rax),%edx
  804618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80461c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80461f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804628:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80462c:	72 98                	jb     8045c6 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80462e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804632:	c9                   	leaveq 
  804633:	c3                   	retq   

0000000000804634 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804634:	55                   	push   %rbp
  804635:	48 89 e5             	mov    %rsp,%rbp
  804638:	48 83 ec 20          	sub    $0x20,%rsp
  80463c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804640:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804648:	48 89 c7             	mov    %rax,%rdi
  80464b:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  804652:	00 00 00 
  804655:	ff d0                	callq  *%rax
  804657:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80465b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80465f:	48 be c8 53 80 00 00 	movabs $0x8053c8,%rsi
  804666:	00 00 00 
  804669:	48 89 c7             	mov    %rax,%rdi
  80466c:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  804673:	00 00 00 
  804676:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80467c:	8b 50 04             	mov    0x4(%rax),%edx
  80467f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804683:	8b 00                	mov    (%rax),%eax
  804685:	29 c2                	sub    %eax,%edx
  804687:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80468b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804691:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804695:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80469c:	00 00 00 
	stat->st_dev = &devpipe;
  80469f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046a3:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8046aa:	00 00 00 
  8046ad:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8046b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046b9:	c9                   	leaveq 
  8046ba:	c3                   	retq   

00000000008046bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8046bb:	55                   	push   %rbp
  8046bc:	48 89 e5             	mov    %rsp,%rbp
  8046bf:	48 83 ec 10          	sub    $0x10,%rsp
  8046c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8046c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046cb:	48 89 c6             	mov    %rax,%rsi
  8046ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8046d3:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8046da:	00 00 00 
  8046dd:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8046df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046e3:	48 89 c7             	mov    %rax,%rdi
  8046e6:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  8046ed:	00 00 00 
  8046f0:	ff d0                	callq  *%rax
  8046f2:	48 89 c6             	mov    %rax,%rsi
  8046f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8046fa:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  804701:	00 00 00 
  804704:	ff d0                	callq  *%rax
}
  804706:	c9                   	leaveq 
  804707:	c3                   	retq   

0000000000804708 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804708:	55                   	push   %rbp
  804709:	48 89 e5             	mov    %rsp,%rbp
  80470c:	48 83 ec 20          	sub    $0x20,%rsp
  804710:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804713:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804716:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804719:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80471d:	be 01 00 00 00       	mov    $0x1,%esi
  804722:	48 89 c7             	mov    %rax,%rdi
  804725:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80472c:	00 00 00 
  80472f:	ff d0                	callq  *%rax
}
  804731:	90                   	nop
  804732:	c9                   	leaveq 
  804733:	c3                   	retq   

0000000000804734 <getchar>:

int
getchar(void)
{
  804734:	55                   	push   %rbp
  804735:	48 89 e5             	mov    %rsp,%rbp
  804738:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80473c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804740:	ba 01 00 00 00       	mov    $0x1,%edx
  804745:	48 89 c6             	mov    %rax,%rsi
  804748:	bf 00 00 00 00       	mov    $0x0,%edi
  80474d:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  804754:	00 00 00 
  804757:	ff d0                	callq  *%rax
  804759:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80475c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804760:	79 05                	jns    804767 <getchar+0x33>
		return r;
  804762:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804765:	eb 14                	jmp    80477b <getchar+0x47>
	if (r < 1)
  804767:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80476b:	7f 07                	jg     804774 <getchar+0x40>
		return -E_EOF;
  80476d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804772:	eb 07                	jmp    80477b <getchar+0x47>
	return c;
  804774:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804778:	0f b6 c0             	movzbl %al,%eax

}
  80477b:	c9                   	leaveq 
  80477c:	c3                   	retq   

000000000080477d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80477d:	55                   	push   %rbp
  80477e:	48 89 e5             	mov    %rsp,%rbp
  804781:	48 83 ec 20          	sub    $0x20,%rsp
  804785:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804788:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80478c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80478f:	48 89 d6             	mov    %rdx,%rsi
  804792:	89 c7                	mov    %eax,%edi
  804794:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  80479b:	00 00 00 
  80479e:	ff d0                	callq  *%rax
  8047a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047a7:	79 05                	jns    8047ae <iscons+0x31>
		return r;
  8047a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047ac:	eb 1a                	jmp    8047c8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8047ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047b2:	8b 10                	mov    (%rax),%edx
  8047b4:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8047bb:	00 00 00 
  8047be:	8b 00                	mov    (%rax),%eax
  8047c0:	39 c2                	cmp    %eax,%edx
  8047c2:	0f 94 c0             	sete   %al
  8047c5:	0f b6 c0             	movzbl %al,%eax
}
  8047c8:	c9                   	leaveq 
  8047c9:	c3                   	retq   

00000000008047ca <opencons>:

int
opencons(void)
{
  8047ca:	55                   	push   %rbp
  8047cb:	48 89 e5             	mov    %rsp,%rbp
  8047ce:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8047d2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8047d6:	48 89 c7             	mov    %rax,%rdi
  8047d9:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  8047e0:	00 00 00 
  8047e3:	ff d0                	callq  *%rax
  8047e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ec:	79 05                	jns    8047f3 <opencons+0x29>
		return r;
  8047ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f1:	eb 5b                	jmp    80484e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8047f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047f7:	ba 07 04 00 00       	mov    $0x407,%edx
  8047fc:	48 89 c6             	mov    %rax,%rsi
  8047ff:	bf 00 00 00 00       	mov    $0x0,%edi
  804804:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80480b:	00 00 00 
  80480e:	ff d0                	callq  *%rax
  804810:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804813:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804817:	79 05                	jns    80481e <opencons+0x54>
		return r;
  804819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481c:	eb 30                	jmp    80484e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80481e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804822:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804829:	00 00 00 
  80482c:	8b 12                	mov    (%rdx),%edx
  80482e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804834:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80483b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80483f:	48 89 c7             	mov    %rax,%rdi
  804842:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  804849:	00 00 00 
  80484c:	ff d0                	callq  *%rax
}
  80484e:	c9                   	leaveq 
  80484f:	c3                   	retq   

0000000000804850 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804850:	55                   	push   %rbp
  804851:	48 89 e5             	mov    %rsp,%rbp
  804854:	48 83 ec 30          	sub    $0x30,%rsp
  804858:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80485c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804860:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804864:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804869:	75 13                	jne    80487e <devcons_read+0x2e>
		return 0;
  80486b:	b8 00 00 00 00       	mov    $0x0,%eax
  804870:	eb 49                	jmp    8048bb <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804872:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  804879:	00 00 00 
  80487c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80487e:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  804885:	00 00 00 
  804888:	ff d0                	callq  *%rax
  80488a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80488d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804891:	74 df                	je     804872 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804893:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804897:	79 05                	jns    80489e <devcons_read+0x4e>
		return c;
  804899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489c:	eb 1d                	jmp    8048bb <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80489e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8048a2:	75 07                	jne    8048ab <devcons_read+0x5b>
		return 0;
  8048a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a9:	eb 10                	jmp    8048bb <devcons_read+0x6b>
	*(char*)vbuf = c;
  8048ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048ae:	89 c2                	mov    %eax,%edx
  8048b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048b4:	88 10                	mov    %dl,(%rax)
	return 1;
  8048b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8048bb:	c9                   	leaveq 
  8048bc:	c3                   	retq   

00000000008048bd <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8048bd:	55                   	push   %rbp
  8048be:	48 89 e5             	mov    %rsp,%rbp
  8048c1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8048c8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8048cf:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8048d6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8048dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048e4:	eb 76                	jmp    80495c <devcons_write+0x9f>
		m = n - tot;
  8048e6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8048ed:	89 c2                	mov    %eax,%edx
  8048ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f2:	29 c2                	sub    %eax,%edx
  8048f4:	89 d0                	mov    %edx,%eax
  8048f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8048f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048fc:	83 f8 7f             	cmp    $0x7f,%eax
  8048ff:	76 07                	jbe    804908 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804901:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804908:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80490b:	48 63 d0             	movslq %eax,%rdx
  80490e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804911:	48 63 c8             	movslq %eax,%rcx
  804914:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80491b:	48 01 c1             	add    %rax,%rcx
  80491e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804925:	48 89 ce             	mov    %rcx,%rsi
  804928:	48 89 c7             	mov    %rax,%rdi
  80492b:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  804932:	00 00 00 
  804935:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804937:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80493a:	48 63 d0             	movslq %eax,%rdx
  80493d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804944:	48 89 d6             	mov    %rdx,%rsi
  804947:	48 89 c7             	mov    %rax,%rdi
  80494a:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  804951:	00 00 00 
  804954:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804956:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804959:	01 45 fc             	add    %eax,-0x4(%rbp)
  80495c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80495f:	48 98                	cltq   
  804961:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804968:	0f 82 78 ff ff ff    	jb     8048e6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80496e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804971:	c9                   	leaveq 
  804972:	c3                   	retq   

0000000000804973 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804973:	55                   	push   %rbp
  804974:	48 89 e5             	mov    %rsp,%rbp
  804977:	48 83 ec 08          	sub    $0x8,%rsp
  80497b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80497f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804984:	c9                   	leaveq 
  804985:	c3                   	retq   

0000000000804986 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804986:	55                   	push   %rbp
  804987:	48 89 e5             	mov    %rsp,%rbp
  80498a:	48 83 ec 10          	sub    $0x10,%rsp
  80498e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804992:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80499a:	48 be d4 53 80 00 00 	movabs $0x8053d4,%rsi
  8049a1:	00 00 00 
  8049a4:	48 89 c7             	mov    %rax,%rdi
  8049a7:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  8049ae:	00 00 00 
  8049b1:	ff d0                	callq  *%rax
	return 0;
  8049b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049b8:	c9                   	leaveq 
  8049b9:	c3                   	retq   

00000000008049ba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8049ba:	55                   	push   %rbp
  8049bb:	48 89 e5             	mov    %rsp,%rbp
  8049be:	48 83 ec 20          	sub    $0x20,%rsp
  8049c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8049c6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049cd:	00 00 00 
  8049d0:	48 8b 00             	mov    (%rax),%rax
  8049d3:	48 85 c0             	test   %rax,%rax
  8049d6:	75 6f                	jne    804a47 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8049d8:	ba 07 00 00 00       	mov    $0x7,%edx
  8049dd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8049e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8049e7:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8049ee:	00 00 00 
  8049f1:	ff d0                	callq  *%rax
  8049f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049fa:	79 30                	jns    804a2c <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8049fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049ff:	89 c1                	mov    %eax,%ecx
  804a01:	48 ba e0 53 80 00 00 	movabs $0x8053e0,%rdx
  804a08:	00 00 00 
  804a0b:	be 22 00 00 00       	mov    $0x22,%esi
  804a10:	48 bf ff 53 80 00 00 	movabs $0x8053ff,%rdi
  804a17:	00 00 00 
  804a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  804a1f:	49 b8 2e 04 80 00 00 	movabs $0x80042e,%r8
  804a26:	00 00 00 
  804a29:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804a2c:	48 be 5b 4a 80 00 00 	movabs $0x804a5b,%rsi
  804a33:	00 00 00 
  804a36:	bf 00 00 00 00       	mov    $0x0,%edi
  804a3b:	48 b8 c5 1c 80 00 00 	movabs $0x801cc5,%rax
  804a42:	00 00 00 
  804a45:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804a47:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a4e:	00 00 00 
  804a51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a55:	48 89 10             	mov    %rdx,(%rax)
}
  804a58:	90                   	nop
  804a59:	c9                   	leaveq 
  804a5a:	c3                   	retq   

0000000000804a5b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804a5b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804a5e:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804a65:	00 00 00 
call *%rax
  804a68:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804a6a:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804a71:	00 08 
    movq 152(%rsp), %rax
  804a73:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804a7a:	00 
    movq 136(%rsp), %rbx
  804a7b:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804a82:	00 
movq %rbx, (%rax)
  804a83:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804a86:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804a8a:	4c 8b 3c 24          	mov    (%rsp),%r15
  804a8e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804a93:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804a98:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804a9d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804aa2:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804aa7:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804aac:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804ab1:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804ab6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804abb:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804ac0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804ac5:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804aca:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804acf:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804ad4:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804ad8:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804adc:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804add:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804ae2:	c3                   	retq   
