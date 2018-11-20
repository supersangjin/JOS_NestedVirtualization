
obj/user/primes:     file format elf64-x86-64


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
  80003c:	e8 8b 01 00 00       	callq  8001cc <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 84 24 80 00 00 	movabs $0x802484,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf c0 48 80 00 00 	movabs $0x8048c0,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 ae 04 80 00 00 	movabs $0x8004ae,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 0d 22 80 00 00 	movabs $0x80220d,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba cc 48 80 00 00 	movabs $0x8048cc,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1b 00 00 00       	mov    $0x1b,%esi
  8000c7:	48 bf d5 48 80 00 00 	movabs $0x8048d5,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 84 24 80 00 00 	movabs $0x802484,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 d3                	je     8000ee <primeproc+0xab>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 45 25 80 00 00 	movabs $0x802545,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>

000000000080013b <umain>:
}

void
umain(int argc, char **argv)
{
  80013b:	55                   	push   %rbp
  80013c:	48 89 e5             	mov    %rsp,%rbp
  80013f:	48 83 ec 20          	sub    $0x20,%rsp
  800143:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800146:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014a:	48 b8 0d 22 80 00 00 	movabs $0x80220d,%rax
  800151:	00 00 00 
  800154:	ff d0                	callq  *%rax
  800156:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800159:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015d:	79 30                	jns    80018f <umain+0x54>
		panic("fork: %e", id);
  80015f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	48 ba cc 48 80 00 00 	movabs $0x8048cc,%rdx
  80016b:	00 00 00 
  80016e:	be 2e 00 00 00       	mov    $0x2e,%esi
  800173:	48 bf d5 48 80 00 00 	movabs $0x8048d5,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  800189:	00 00 00 
  80018c:	41 ff d0             	callq  *%r8
	if (id == 0)
  80018f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800193:	75 0c                	jne    8001a1 <umain+0x66>
		primeproc();
  800195:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001a8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b8:	89 c7                	mov    %eax,%edi
  8001ba:	48 b8 45 25 80 00 00 	movabs $0x802545,%rax
  8001c1:	00 00 00 
  8001c4:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001ca:	eb dc                	jmp    8001a8 <umain+0x6d>

00000000008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 10          	sub    $0x10,%rsp
  8001d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8001db:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
  8001e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ec:	48 98                	cltq   
  8001ee:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001f5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fc:	00 00 00 
  8001ff:	48 01 c2             	add    %rax,%rdx
  800202:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800209:	00 00 00 
  80020c:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800213:	7e 14                	jle    800229 <libmain+0x5d>
		binaryname = argv[0];
  800215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800219:	48 8b 10             	mov    (%rax),%rdx
  80021c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800223:	00 00 00 
  800226:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800229:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800230:	48 89 d6             	mov    %rdx,%rsi
  800233:	89 c7                	mov    %eax,%edi
  800235:	48 b8 3b 01 80 00 00 	movabs $0x80013b,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800241:	48 b8 50 02 80 00 00 	movabs $0x800250,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
}
  80024d:	90                   	nop
  80024e:	c9                   	leaveq 
  80024f:	c3                   	retq   

0000000000800250 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800250:	55                   	push   %rbp
  800251:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800254:	48 b8 8e 29 80 00 00 	movabs $0x80298e,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800260:	bf 00 00 00 00       	mov    $0x0,%edi
  800265:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  80026c:	00 00 00 
  80026f:	ff d0                	callq  *%rax
}
  800271:	90                   	nop
  800272:	5d                   	pop    %rbp
  800273:	c3                   	retq   

0000000000800274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	53                   	push   %rbx
  800279:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800280:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800287:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80028d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800294:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80029b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a9:	84 c0                	test   %al,%al
  8002ab:	74 23                	je     8002d0 <_panic+0x5c>
  8002ad:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002bc:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002cc:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d7:	00 00 00 
  8002da:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e1:	00 00 00 
  8002e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ef:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800304:	00 00 00 
  800307:	48 8b 18             	mov    (%rax),%rbx
  80030a:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  800311:	00 00 00 
  800314:	ff d0                	callq  *%rax
  800316:	89 c6                	mov    %eax,%esi
  800318:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80031e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800325:	41 89 d0             	mov    %edx,%r8d
  800328:	48 89 c1             	mov    %rax,%rcx
  80032b:	48 89 da             	mov    %rbx,%rdx
  80032e:	48 bf f0 48 80 00 00 	movabs $0x8048f0,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	49 b9 ae 04 80 00 00 	movabs $0x8004ae,%r9
  800344:	00 00 00 
  800347:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800351:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800358:	48 89 d6             	mov    %rdx,%rsi
  80035b:	48 89 c7             	mov    %rax,%rdi
  80035e:	48 b8 02 04 80 00 00 	movabs $0x800402,%rax
  800365:	00 00 00 
  800368:	ff d0                	callq  *%rax
	cprintf("\n");
  80036a:	48 bf 13 49 80 00 00 	movabs $0x804913,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba ae 04 80 00 00 	movabs $0x8004ae,%rdx
  800380:	00 00 00 
  800383:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x111>

0000000000800388 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	48 83 ec 10          	sub    $0x10,%rsp
  800390:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800393:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039b:	8b 00                	mov    (%rax),%eax
  80039d:	8d 48 01             	lea    0x1(%rax),%ecx
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	89 0a                	mov    %ecx,(%rdx)
  8003a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a9:	89 d1                	mov    %edx,%ecx
  8003ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003af:	48 98                	cltq   
  8003b1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b9:	8b 00                	mov    (%rax),%eax
  8003bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c0:	75 2c                	jne    8003ee <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c6:	8b 00                	mov    (%rax),%eax
  8003c8:	48 98                	cltq   
  8003ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ce:	48 83 c2 08          	add    $0x8,%rdx
  8003d2:	48 89 c6             	mov    %rax,%rsi
  8003d5:	48 89 d7             	mov    %rdx,%rdi
  8003d8:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f2:	8b 40 04             	mov    0x4(%rax),%eax
  8003f5:	8d 50 01             	lea    0x1(%rax),%edx
  8003f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fc:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ff:	90                   	nop
  800400:	c9                   	leaveq 
  800401:	c3                   	retq   

0000000000800402 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800402:	55                   	push   %rbp
  800403:	48 89 e5             	mov    %rsp,%rbp
  800406:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80040d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800414:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80041b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800422:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800429:	48 8b 0a             	mov    (%rdx),%rcx
  80042c:	48 89 08             	mov    %rcx,(%rax)
  80042f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800433:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800437:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80043f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800446:	00 00 00 
    b.cnt = 0;
  800449:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800450:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800453:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80045a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800461:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800468:	48 89 c6             	mov    %rax,%rsi
  80046b:	48 bf 88 03 80 00 00 	movabs $0x800388,%rdi
  800472:	00 00 00 
  800475:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800481:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800487:	48 98                	cltq   
  800489:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800490:	48 83 c2 08          	add    $0x8,%rdx
  800494:	48 89 c6             	mov    %rax,%rsi
  800497:	48 89 d7             	mov    %rdx,%rdi
  80049a:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  8004a1:	00 00 00 
  8004a4:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004ac:	c9                   	leaveq 
  8004ad:	c3                   	retq   

00000000008004ae <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ae:	55                   	push   %rbp
  8004af:	48 89 e5             	mov    %rsp,%rbp
  8004b2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004b9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004c0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004d5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004dc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e3:	84 c0                	test   %al,%al
  8004e5:	74 20                	je     800507 <cprintf+0x59>
  8004e7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004eb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004fb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004ff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800503:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800507:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050e:	00 00 00 
  800511:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800518:	00 00 00 
  80051b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800526:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80052d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800534:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80053b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800542:	48 8b 0a             	mov    (%rdx),%rcx
  800545:	48 89 08             	mov    %rcx,(%rax)
  800548:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800550:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800554:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800558:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80055f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800566:	48 89 d6             	mov    %rdx,%rsi
  800569:	48 89 c7             	mov    %rax,%rdi
  80056c:	48 b8 02 04 80 00 00 	movabs $0x800402,%rax
  800573:	00 00 00 
  800576:	ff d0                	callq  *%rax
  800578:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80057e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800584:	c9                   	leaveq 
  800585:	c3                   	retq   

0000000000800586 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800586:	55                   	push   %rbp
  800587:	48 89 e5             	mov    %rsp,%rbp
  80058a:	48 83 ec 30          	sub    $0x30,%rsp
  80058e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800592:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800596:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80059a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80059d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005a1:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005a8:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005ac:	77 54                	ja     800602 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ae:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005b1:	8d 78 ff             	lea    -0x1(%rax),%edi
  8005b4:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	48 f7 f6             	div    %rsi
  8005c3:	49 89 c2             	mov    %rax,%r10
  8005c6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005c9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005cc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d4:	41 89 c9             	mov    %ecx,%r9d
  8005d7:	41 89 f8             	mov    %edi,%r8d
  8005da:	89 d1                	mov    %edx,%ecx
  8005dc:	4c 89 d2             	mov    %r10,%rdx
  8005df:	48 89 c7             	mov    %rax,%rdi
  8005e2:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  8005e9:	00 00 00 
  8005ec:	ff d0                	callq  *%rax
  8005ee:	eb 1c                	jmp    80060c <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005f4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005fb:	48 89 ce             	mov    %rcx,%rsi
  8005fe:	89 d7                	mov    %edx,%edi
  800600:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800602:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800606:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80060a:	7f e4                	jg     8005f0 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	48 f7 f1             	div    %rcx
  80061b:	48 b8 10 4b 80 00 00 	movabs $0x804b10,%rax
  800622:	00 00 00 
  800625:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800629:	0f be d0             	movsbl %al,%edx
  80062c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800634:	48 89 ce             	mov    %rcx,%rsi
  800637:	89 d7                	mov    %edx,%edi
  800639:	ff d0                	callq  *%rax
}
  80063b:	90                   	nop
  80063c:	c9                   	leaveq 
  80063d:	c3                   	retq   

000000000080063e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063e:	55                   	push   %rbp
  80063f:	48 89 e5             	mov    %rsp,%rbp
  800642:	48 83 ec 20          	sub    $0x20,%rsp
  800646:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80064a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80064d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800651:	7e 4f                	jle    8006a2 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	8b 00                	mov    (%rax),%eax
  800659:	83 f8 30             	cmp    $0x30,%eax
  80065c:	73 24                	jae    800682 <getuint+0x44>
  80065e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800662:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066a:	8b 00                	mov    (%rax),%eax
  80066c:	89 c0                	mov    %eax,%eax
  80066e:	48 01 d0             	add    %rdx,%rax
  800671:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800675:	8b 12                	mov    (%rdx),%edx
  800677:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067e:	89 0a                	mov    %ecx,(%rdx)
  800680:	eb 14                	jmp    800696 <getuint+0x58>
  800682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800686:	48 8b 40 08          	mov    0x8(%rax),%rax
  80068a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80068e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800692:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800696:	48 8b 00             	mov    (%rax),%rax
  800699:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069d:	e9 9d 00 00 00       	jmpq   80073f <getuint+0x101>
	else if (lflag)
  8006a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a6:	74 4c                	je     8006f4 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	8b 00                	mov    (%rax),%eax
  8006ae:	83 f8 30             	cmp    $0x30,%eax
  8006b1:	73 24                	jae    8006d7 <getuint+0x99>
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	89 c0                	mov    %eax,%eax
  8006c3:	48 01 d0             	add    %rdx,%rax
  8006c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ca:	8b 12                	mov    (%rdx),%edx
  8006cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	89 0a                	mov    %ecx,(%rdx)
  8006d5:	eb 14                	jmp    8006eb <getuint+0xad>
  8006d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006db:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006df:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006eb:	48 8b 00             	mov    (%rax),%rax
  8006ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f2:	eb 4b                	jmp    80073f <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	8b 00                	mov    (%rax),%eax
  8006fa:	83 f8 30             	cmp    $0x30,%eax
  8006fd:	73 24                	jae    800723 <getuint+0xe5>
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	8b 00                	mov    (%rax),%eax
  80070d:	89 c0                	mov    %eax,%eax
  80070f:	48 01 d0             	add    %rdx,%rax
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	8b 12                	mov    (%rdx),%edx
  800718:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	89 0a                	mov    %ecx,(%rdx)
  800721:	eb 14                	jmp    800737 <getuint+0xf9>
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	48 8b 40 08          	mov    0x8(%rax),%rax
  80072b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80072f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800733:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800737:	8b 00                	mov    (%rax),%eax
  800739:	89 c0                	mov    %eax,%eax
  80073b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800743:	c9                   	leaveq 
  800744:	c3                   	retq   

0000000000800745 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800745:	55                   	push   %rbp
  800746:	48 89 e5             	mov    %rsp,%rbp
  800749:	48 83 ec 20          	sub    $0x20,%rsp
  80074d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800751:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800754:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800758:	7e 4f                	jle    8007a9 <getint+0x64>
		x=va_arg(*ap, long long);
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	8b 00                	mov    (%rax),%eax
  800760:	83 f8 30             	cmp    $0x30,%eax
  800763:	73 24                	jae    800789 <getint+0x44>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	89 c0                	mov    %eax,%eax
  800775:	48 01 d0             	add    %rdx,%rax
  800778:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077c:	8b 12                	mov    (%rdx),%edx
  80077e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800785:	89 0a                	mov    %ecx,(%rdx)
  800787:	eb 14                	jmp    80079d <getint+0x58>
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800791:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800795:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800799:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079d:	48 8b 00             	mov    (%rax),%rax
  8007a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a4:	e9 9d 00 00 00       	jmpq   800846 <getint+0x101>
	else if (lflag)
  8007a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ad:	74 4c                	je     8007fb <getint+0xb6>
		x=va_arg(*ap, long);
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	8b 00                	mov    (%rax),%eax
  8007b5:	83 f8 30             	cmp    $0x30,%eax
  8007b8:	73 24                	jae    8007de <getint+0x99>
  8007ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	89 c0                	mov    %eax,%eax
  8007ca:	48 01 d0             	add    %rdx,%rax
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	8b 12                	mov    (%rdx),%edx
  8007d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007da:	89 0a                	mov    %ecx,(%rdx)
  8007dc:	eb 14                	jmp    8007f2 <getint+0xad>
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f2:	48 8b 00             	mov    (%rax),%rax
  8007f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f9:	eb 4b                	jmp    800846 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	83 f8 30             	cmp    $0x30,%eax
  800804:	73 24                	jae    80082a <getint+0xe5>
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	89 c0                	mov    %eax,%eax
  800816:	48 01 d0             	add    %rdx,%rax
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	8b 12                	mov    (%rdx),%edx
  80081f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	89 0a                	mov    %ecx,(%rdx)
  800828:	eb 14                	jmp    80083e <getint+0xf9>
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800832:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800836:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083e:	8b 00                	mov    (%rax),%eax
  800840:	48 98                	cltq   
  800842:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084a:	c9                   	leaveq 
  80084b:	c3                   	retq   

000000000080084c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80084c:	55                   	push   %rbp
  80084d:	48 89 e5             	mov    %rsp,%rbp
  800850:	41 54                	push   %r12
  800852:	53                   	push   %rbx
  800853:	48 83 ec 60          	sub    $0x60,%rsp
  800857:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80085b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80085f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800863:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800867:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80086b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80086f:	48 8b 0a             	mov    (%rdx),%rcx
  800872:	48 89 08             	mov    %rcx,(%rax)
  800875:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800879:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80087d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800881:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800885:	eb 17                	jmp    80089e <vprintfmt+0x52>
			if (ch == '\0')
  800887:	85 db                	test   %ebx,%ebx
  800889:	0f 84 b9 04 00 00    	je     800d48 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80088f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800893:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800897:	48 89 d6             	mov    %rdx,%rsi
  80089a:	89 df                	mov    %ebx,%edi
  80089c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008aa:	0f b6 00             	movzbl (%rax),%eax
  8008ad:	0f b6 d8             	movzbl %al,%ebx
  8008b0:	83 fb 25             	cmp    $0x25,%ebx
  8008b3:	75 d2                	jne    800887 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e1:	0f b6 00             	movzbl (%rax),%eax
  8008e4:	0f b6 d8             	movzbl %al,%ebx
  8008e7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ea:	83 f8 55             	cmp    $0x55,%eax
  8008ed:	0f 87 22 04 00 00    	ja     800d15 <vprintfmt+0x4c9>
  8008f3:	89 c0                	mov    %eax,%eax
  8008f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008fc:	00 
  8008fd:	48 b8 38 4b 80 00 00 	movabs $0x804b38,%rax
  800904:	00 00 00 
  800907:	48 01 d0             	add    %rdx,%rax
  80090a:	48 8b 00             	mov    (%rax),%rax
  80090d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80090f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800913:	eb c0                	jmp    8008d5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800915:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800919:	eb ba                	jmp    8008d5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800922:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800925:	89 d0                	mov    %edx,%eax
  800927:	c1 e0 02             	shl    $0x2,%eax
  80092a:	01 d0                	add    %edx,%eax
  80092c:	01 c0                	add    %eax,%eax
  80092e:	01 d8                	add    %ebx,%eax
  800930:	83 e8 30             	sub    $0x30,%eax
  800933:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800936:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093a:	0f b6 00             	movzbl (%rax),%eax
  80093d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800940:	83 fb 2f             	cmp    $0x2f,%ebx
  800943:	7e 60                	jle    8009a5 <vprintfmt+0x159>
  800945:	83 fb 39             	cmp    $0x39,%ebx
  800948:	7f 5b                	jg     8009a5 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094f:	eb d1                	jmp    800922 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800951:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800954:	83 f8 30             	cmp    $0x30,%eax
  800957:	73 17                	jae    800970 <vprintfmt+0x124>
  800959:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80095d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800960:	89 d2                	mov    %edx,%edx
  800962:	48 01 d0             	add    %rdx,%rax
  800965:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800968:	83 c2 08             	add    $0x8,%edx
  80096b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096e:	eb 0c                	jmp    80097c <vprintfmt+0x130>
  800970:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800974:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800978:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097c:	8b 00                	mov    (%rax),%eax
  80097e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800981:	eb 23                	jmp    8009a6 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800983:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800987:	0f 89 48 ff ff ff    	jns    8008d5 <vprintfmt+0x89>
				width = 0;
  80098d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800994:	e9 3c ff ff ff       	jmpq   8008d5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800999:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a0:	e9 30 ff ff ff       	jmpq   8008d5 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009a5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009aa:	0f 89 25 ff ff ff    	jns    8008d5 <vprintfmt+0x89>
				width = precision, precision = -1;
  8009b0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009bd:	e9 13 ff ff ff       	jmpq   8008d5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c2:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009c6:	e9 0a ff ff ff       	jmpq   8008d5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ce:	83 f8 30             	cmp    $0x30,%eax
  8009d1:	73 17                	jae    8009ea <vprintfmt+0x19e>
  8009d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009d7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009da:	89 d2                	mov    %edx,%edx
  8009dc:	48 01 d0             	add    %rdx,%rax
  8009df:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e2:	83 c2 08             	add    $0x8,%edx
  8009e5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e8:	eb 0c                	jmp    8009f6 <vprintfmt+0x1aa>
  8009ea:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009ee:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f6:	8b 10                	mov    (%rax),%edx
  8009f8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a00:	48 89 ce             	mov    %rcx,%rsi
  800a03:	89 d7                	mov    %edx,%edi
  800a05:	ff d0                	callq  *%rax
			break;
  800a07:	e9 37 03 00 00       	jmpq   800d43 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0f:	83 f8 30             	cmp    $0x30,%eax
  800a12:	73 17                	jae    800a2b <vprintfmt+0x1df>
  800a14:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1b:	89 d2                	mov    %edx,%edx
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a23:	83 c2 08             	add    $0x8,%edx
  800a26:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a29:	eb 0c                	jmp    800a37 <vprintfmt+0x1eb>
  800a2b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a2f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a37:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a39:	85 db                	test   %ebx,%ebx
  800a3b:	79 02                	jns    800a3f <vprintfmt+0x1f3>
				err = -err;
  800a3d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a3f:	83 fb 15             	cmp    $0x15,%ebx
  800a42:	7f 16                	jg     800a5a <vprintfmt+0x20e>
  800a44:	48 b8 60 4a 80 00 00 	movabs $0x804a60,%rax
  800a4b:	00 00 00 
  800a4e:	48 63 d3             	movslq %ebx,%rdx
  800a51:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a55:	4d 85 e4             	test   %r12,%r12
  800a58:	75 2e                	jne    800a88 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a5a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	89 d9                	mov    %ebx,%ecx
  800a64:	48 ba 21 4b 80 00 00 	movabs $0x804b21,%rdx
  800a6b:	00 00 00 
  800a6e:	48 89 c7             	mov    %rax,%rdi
  800a71:	b8 00 00 00 00       	mov    $0x0,%eax
  800a76:	49 b8 52 0d 80 00 00 	movabs $0x800d52,%r8
  800a7d:	00 00 00 
  800a80:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a83:	e9 bb 02 00 00       	jmpq   800d43 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a88:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a90:	4c 89 e1             	mov    %r12,%rcx
  800a93:	48 ba 2a 4b 80 00 00 	movabs $0x804b2a,%rdx
  800a9a:	00 00 00 
  800a9d:	48 89 c7             	mov    %rax,%rdi
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	49 b8 52 0d 80 00 00 	movabs $0x800d52,%r8
  800aac:	00 00 00 
  800aaf:	41 ff d0             	callq  *%r8
			break;
  800ab2:	e9 8c 02 00 00       	jmpq   800d43 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ab7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aba:	83 f8 30             	cmp    $0x30,%eax
  800abd:	73 17                	jae    800ad6 <vprintfmt+0x28a>
  800abf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ac3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac6:	89 d2                	mov    %edx,%edx
  800ac8:	48 01 d0             	add    %rdx,%rax
  800acb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ace:	83 c2 08             	add    $0x8,%edx
  800ad1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad4:	eb 0c                	jmp    800ae2 <vprintfmt+0x296>
  800ad6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ada:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ade:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae2:	4c 8b 20             	mov    (%rax),%r12
  800ae5:	4d 85 e4             	test   %r12,%r12
  800ae8:	75 0a                	jne    800af4 <vprintfmt+0x2a8>
				p = "(null)";
  800aea:	49 bc 2d 4b 80 00 00 	movabs $0x804b2d,%r12
  800af1:	00 00 00 
			if (width > 0 && padc != '-')
  800af4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af8:	7e 78                	jle    800b72 <vprintfmt+0x326>
  800afa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800afe:	74 72                	je     800b72 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b00:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b03:	48 98                	cltq   
  800b05:	48 89 c6             	mov    %rax,%rsi
  800b08:	4c 89 e7             	mov    %r12,%rdi
  800b0b:	48 b8 00 10 80 00 00 	movabs $0x801000,%rax
  800b12:	00 00 00 
  800b15:	ff d0                	callq  *%rax
  800b17:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b1a:	eb 17                	jmp    800b33 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800b1c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b20:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b28:	48 89 ce             	mov    %rcx,%rsi
  800b2b:	89 d7                	mov    %edx,%edi
  800b2d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b37:	7f e3                	jg     800b1c <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b39:	eb 37                	jmp    800b72 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b3f:	74 1e                	je     800b5f <vprintfmt+0x313>
  800b41:	83 fb 1f             	cmp    $0x1f,%ebx
  800b44:	7e 05                	jle    800b4b <vprintfmt+0x2ff>
  800b46:	83 fb 7e             	cmp    $0x7e,%ebx
  800b49:	7e 14                	jle    800b5f <vprintfmt+0x313>
					putch('?', putdat);
  800b4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b53:	48 89 d6             	mov    %rdx,%rsi
  800b56:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b5b:	ff d0                	callq  *%rax
  800b5d:	eb 0f                	jmp    800b6e <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b67:	48 89 d6             	mov    %rdx,%rsi
  800b6a:	89 df                	mov    %ebx,%edi
  800b6c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b72:	4c 89 e0             	mov    %r12,%rax
  800b75:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b79:	0f b6 00             	movzbl (%rax),%eax
  800b7c:	0f be d8             	movsbl %al,%ebx
  800b7f:	85 db                	test   %ebx,%ebx
  800b81:	74 28                	je     800bab <vprintfmt+0x35f>
  800b83:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b87:	78 b2                	js     800b3b <vprintfmt+0x2ef>
  800b89:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b8d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b91:	79 a8                	jns    800b3b <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b93:	eb 16                	jmp    800bab <vprintfmt+0x35f>
				putch(' ', putdat);
  800b95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9d:	48 89 d6             	mov    %rdx,%rsi
  800ba0:	bf 20 00 00 00       	mov    $0x20,%edi
  800ba5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800baf:	7f e4                	jg     800b95 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800bb1:	e9 8d 01 00 00       	jmpq   800d43 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bb6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bba:	be 03 00 00 00       	mov    $0x3,%esi
  800bbf:	48 89 c7             	mov    %rax,%rdi
  800bc2:	48 b8 45 07 80 00 00 	movabs $0x800745,%rax
  800bc9:	00 00 00 
  800bcc:	ff d0                	callq  *%rax
  800bce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd6:	48 85 c0             	test   %rax,%rax
  800bd9:	79 1d                	jns    800bf8 <vprintfmt+0x3ac>
				putch('-', putdat);
  800bdb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be3:	48 89 d6             	mov    %rdx,%rsi
  800be6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800beb:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf1:	48 f7 d8             	neg    %rax
  800bf4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bf8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bff:	e9 d2 00 00 00       	jmpq   800cd6 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c08:	be 03 00 00 00       	mov    $0x3,%esi
  800c0d:	48 89 c7             	mov    %rax,%rdi
  800c10:	48 b8 3e 06 80 00 00 	movabs $0x80063e,%rax
  800c17:	00 00 00 
  800c1a:	ff d0                	callq  *%rax
  800c1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c20:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c27:	e9 aa 00 00 00       	jmpq   800cd6 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800c2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c30:	be 03 00 00 00       	mov    $0x3,%esi
  800c35:	48 89 c7             	mov    %rax,%rdi
  800c38:	48 b8 3e 06 80 00 00 	movabs $0x80063e,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	callq  *%rax
  800c44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c48:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c4f:	e9 82 00 00 00       	jmpq   800cd6 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	bf 30 00 00 00       	mov    $0x30,%edi
  800c64:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6e:	48 89 d6             	mov    %rdx,%rsi
  800c71:	bf 78 00 00 00       	mov    $0x78,%edi
  800c76:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7b:	83 f8 30             	cmp    $0x30,%eax
  800c7e:	73 17                	jae    800c97 <vprintfmt+0x44b>
  800c80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c84:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c87:	89 d2                	mov    %edx,%edx
  800c89:	48 01 d0             	add    %rdx,%rax
  800c8c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8f:	83 c2 08             	add    $0x8,%edx
  800c92:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	eb 0c                	jmp    800ca3 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c97:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c9b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800caa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cb1:	eb 23                	jmp    800cd6 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb7:	be 03 00 00 00       	mov    $0x3,%esi
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 3e 06 80 00 00 	movabs $0x80063e,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ccf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cdb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cde:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ce1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ce9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ced:	45 89 c1             	mov    %r8d,%r9d
  800cf0:	41 89 f8             	mov    %edi,%r8d
  800cf3:	48 89 c7             	mov    %rax,%rdi
  800cf6:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
			break;
  800d02:	eb 3f                	jmp    800d43 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	48 89 d6             	mov    %rdx,%rsi
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	ff d0                	callq  *%rax
			break;
  800d13:	eb 2e                	jmp    800d43 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	bf 25 00 00 00       	mov    $0x25,%edi
  800d25:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d2c:	eb 05                	jmp    800d33 <vprintfmt+0x4e7>
  800d2e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d37:	48 83 e8 01          	sub    $0x1,%rax
  800d3b:	0f b6 00             	movzbl (%rax),%eax
  800d3e:	3c 25                	cmp    $0x25,%al
  800d40:	75 ec                	jne    800d2e <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d42:	90                   	nop
		}
	}
  800d43:	e9 3d fb ff ff       	jmpq   800885 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d48:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d49:	48 83 c4 60          	add    $0x60,%rsp
  800d4d:	5b                   	pop    %rbx
  800d4e:	41 5c                	pop    %r12
  800d50:	5d                   	pop    %rbp
  800d51:	c3                   	retq   

0000000000800d52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d52:	55                   	push   %rbp
  800d53:	48 89 e5             	mov    %rsp,%rbp
  800d56:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d5d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d64:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d6b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d87:	84 c0                	test   %al,%al
  800d89:	74 20                	je     800dab <printfmt+0x59>
  800d8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dab:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800db2:	00 00 00 
  800db5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dbc:	00 00 00 
  800dbf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ddf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800de6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ded:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800df4:	48 89 c7             	mov    %rax,%rdi
  800df7:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e03:	90                   	nop
  800e04:	c9                   	leaveq 
  800e05:	c3                   	retq   

0000000000800e06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e06:	55                   	push   %rbp
  800e07:	48 89 e5             	mov    %rsp,%rbp
  800e0a:	48 83 ec 10          	sub    $0x10,%rsp
  800e0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e19:	8b 40 10             	mov    0x10(%rax),%eax
  800e1c:	8d 50 01             	lea    0x1(%rax),%edx
  800e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e23:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2a:	48 8b 10             	mov    (%rax),%rdx
  800e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e31:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e35:	48 39 c2             	cmp    %rax,%rdx
  800e38:	73 17                	jae    800e51 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	48 8b 00             	mov    (%rax),%rax
  800e41:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e49:	48 89 0a             	mov    %rcx,(%rdx)
  800e4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e4f:	88 10                	mov    %dl,(%rax)
}
  800e51:	90                   	nop
  800e52:	c9                   	leaveq 
  800e53:	c3                   	retq   

0000000000800e54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e54:	55                   	push   %rbp
  800e55:	48 89 e5             	mov    %rsp,%rbp
  800e58:	48 83 ec 50          	sub    $0x50,%rsp
  800e5c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e60:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e63:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e67:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e6b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e6f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e73:	48 8b 0a             	mov    (%rdx),%rcx
  800e76:	48 89 08             	mov    %rcx,(%rax)
  800e79:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e7d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e81:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e85:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e8d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e91:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e94:	48 98                	cltq   
  800e96:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e9a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e9e:	48 01 d0             	add    %rdx,%rax
  800ea1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ea5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eac:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eb1:	74 06                	je     800eb9 <vsnprintf+0x65>
  800eb3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eb7:	7f 07                	jg     800ec0 <vsnprintf+0x6c>
		return -E_INVAL;
  800eb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebe:	eb 2f                	jmp    800eef <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ec0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ec4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ec8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ecc:	48 89 c6             	mov    %rax,%rsi
  800ecf:	48 bf 06 0e 80 00 00 	movabs $0x800e06,%rdi
  800ed6:	00 00 00 
  800ed9:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800ee0:	00 00 00 
  800ee3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ee5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ee9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eec:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eef:	c9                   	leaveq 
  800ef0:	c3                   	retq   

0000000000800ef1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef1:	55                   	push   %rbp
  800ef2:	48 89 e5             	mov    %rsp,%rbp
  800ef5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800efc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f03:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f09:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800f10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f25:	84 c0                	test   %al,%al
  800f27:	74 20                	je     800f49 <snprintf+0x58>
  800f29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f49:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f50:	00 00 00 
  800f53:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f5a:	00 00 00 
  800f5d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f61:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f68:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f6f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f76:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f7d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f84:	48 8b 0a             	mov    (%rdx),%rcx
  800f87:	48 89 08             	mov    %rcx,(%rax)
  800f8a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f8e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f92:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f96:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f9a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fa1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fa8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fae:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fb5:	48 89 c7             	mov    %rax,%rdi
  800fb8:	48 b8 54 0e 80 00 00 	movabs $0x800e54,%rax
  800fbf:	00 00 00 
  800fc2:	ff d0                	callq  *%rax
  800fc4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fca:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fd0:	c9                   	leaveq 
  800fd1:	c3                   	retq   

0000000000800fd2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fd2:	55                   	push   %rbp
  800fd3:	48 89 e5             	mov    %rsp,%rbp
  800fd6:	48 83 ec 18          	sub    $0x18,%rsp
  800fda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fe5:	eb 09                	jmp    800ff0 <strlen+0x1e>
		n++;
  800fe7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800feb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff4:	0f b6 00             	movzbl (%rax),%eax
  800ff7:	84 c0                	test   %al,%al
  800ff9:	75 ec                	jne    800fe7 <strlen+0x15>
		n++;
	return n;
  800ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ffe:	c9                   	leaveq 
  800fff:	c3                   	retq   

0000000000801000 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801000:	55                   	push   %rbp
  801001:	48 89 e5             	mov    %rsp,%rbp
  801004:	48 83 ec 20          	sub    $0x20,%rsp
  801008:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801010:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801017:	eb 0e                	jmp    801027 <strnlen+0x27>
		n++;
  801019:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801022:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801027:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80102c:	74 0b                	je     801039 <strnlen+0x39>
  80102e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801032:	0f b6 00             	movzbl (%rax),%eax
  801035:	84 c0                	test   %al,%al
  801037:	75 e0                	jne    801019 <strnlen+0x19>
		n++;
	return n;
  801039:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103c:	c9                   	leaveq 
  80103d:	c3                   	retq   

000000000080103e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	48 83 ec 20          	sub    $0x20,%rsp
  801046:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80104e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801052:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801056:	90                   	nop
  801057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801063:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801067:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80106b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80106f:	0f b6 12             	movzbl (%rdx),%edx
  801072:	88 10                	mov    %dl,(%rax)
  801074:	0f b6 00             	movzbl (%rax),%eax
  801077:	84 c0                	test   %al,%al
  801079:	75 dc                	jne    801057 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80107b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80107f:	c9                   	leaveq 
  801080:	c3                   	retq   

0000000000801081 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801081:	55                   	push   %rbp
  801082:	48 89 e5             	mov    %rsp,%rbp
  801085:	48 83 ec 20          	sub    $0x20,%rsp
  801089:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801095:	48 89 c7             	mov    %rax,%rdi
  801098:	48 b8 d2 0f 80 00 00 	movabs $0x800fd2,%rax
  80109f:	00 00 00 
  8010a2:	ff d0                	callq  *%rax
  8010a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010aa:	48 63 d0             	movslq %eax,%rdx
  8010ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b1:	48 01 c2             	add    %rax,%rdx
  8010b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010b8:	48 89 c6             	mov    %rax,%rsi
  8010bb:	48 89 d7             	mov    %rdx,%rdi
  8010be:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8010c5:	00 00 00 
  8010c8:	ff d0                	callq  *%rax
	return dst;
  8010ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	48 83 ec 28          	sub    $0x28,%rsp
  8010d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010f3:	00 
  8010f4:	eb 2a                	jmp    801120 <strncpy+0x50>
		*dst++ = *src;
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801102:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801106:	0f b6 12             	movzbl (%rdx),%edx
  801109:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80110b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110f:	0f b6 00             	movzbl (%rax),%eax
  801112:	84 c0                	test   %al,%al
  801114:	74 05                	je     80111b <strncpy+0x4b>
			src++;
  801116:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80111b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801124:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801128:	72 cc                	jb     8010f6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80112a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80112e:	c9                   	leaveq 
  80112f:	c3                   	retq   

0000000000801130 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801130:	55                   	push   %rbp
  801131:	48 89 e5             	mov    %rsp,%rbp
  801134:	48 83 ec 28          	sub    $0x28,%rsp
  801138:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801140:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801148:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80114c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801151:	74 3d                	je     801190 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801153:	eb 1d                	jmp    801172 <strlcpy+0x42>
			*dst++ = *src++;
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801161:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801165:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801169:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80116d:	0f b6 12             	movzbl (%rdx),%edx
  801170:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801172:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801177:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117c:	74 0b                	je     801189 <strlcpy+0x59>
  80117e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801182:	0f b6 00             	movzbl (%rax),%eax
  801185:	84 c0                	test   %al,%al
  801187:	75 cc                	jne    801155 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801190:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801198:	48 29 c2             	sub    %rax,%rdx
  80119b:	48 89 d0             	mov    %rdx,%rax
}
  80119e:	c9                   	leaveq 
  80119f:	c3                   	retq   

00000000008011a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011a0:	55                   	push   %rbp
  8011a1:	48 89 e5             	mov    %rsp,%rbp
  8011a4:	48 83 ec 10          	sub    $0x10,%rsp
  8011a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011b0:	eb 0a                	jmp    8011bc <strcmp+0x1c>
		p++, q++;
  8011b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c0:	0f b6 00             	movzbl (%rax),%eax
  8011c3:	84 c0                	test   %al,%al
  8011c5:	74 12                	je     8011d9 <strcmp+0x39>
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	0f b6 10             	movzbl (%rax),%edx
  8011ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d2:	0f b6 00             	movzbl (%rax),%eax
  8011d5:	38 c2                	cmp    %al,%dl
  8011d7:	74 d9                	je     8011b2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	0f b6 d0             	movzbl %al,%edx
  8011e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e7:	0f b6 00             	movzbl (%rax),%eax
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
}
  8011f1:	c9                   	leaveq 
  8011f2:	c3                   	retq   

00000000008011f3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f3:	55                   	push   %rbp
  8011f4:	48 89 e5             	mov    %rsp,%rbp
  8011f7:	48 83 ec 18          	sub    $0x18,%rsp
  8011fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801203:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801207:	eb 0f                	jmp    801218 <strncmp+0x25>
		n--, p++, q++;
  801209:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80120e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801213:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801218:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80121d:	74 1d                	je     80123c <strncmp+0x49>
  80121f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801223:	0f b6 00             	movzbl (%rax),%eax
  801226:	84 c0                	test   %al,%al
  801228:	74 12                	je     80123c <strncmp+0x49>
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	0f b6 10             	movzbl (%rax),%edx
  801231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801235:	0f b6 00             	movzbl (%rax),%eax
  801238:	38 c2                	cmp    %al,%dl
  80123a:	74 cd                	je     801209 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80123c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801241:	75 07                	jne    80124a <strncmp+0x57>
		return 0;
  801243:	b8 00 00 00 00       	mov    $0x0,%eax
  801248:	eb 18                	jmp    801262 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	0f b6 d0             	movzbl %al,%edx
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801258:	0f b6 00             	movzbl (%rax),%eax
  80125b:	0f b6 c0             	movzbl %al,%eax
  80125e:	29 c2                	sub    %eax,%edx
  801260:	89 d0                	mov    %edx,%eax
}
  801262:	c9                   	leaveq 
  801263:	c3                   	retq   

0000000000801264 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801264:	55                   	push   %rbp
  801265:	48 89 e5             	mov    %rsp,%rbp
  801268:	48 83 ec 10          	sub    $0x10,%rsp
  80126c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801270:	89 f0                	mov    %esi,%eax
  801272:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801275:	eb 17                	jmp    80128e <strchr+0x2a>
		if (*s == c)
  801277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127b:	0f b6 00             	movzbl (%rax),%eax
  80127e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801281:	75 06                	jne    801289 <strchr+0x25>
			return (char *) s;
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	eb 15                	jmp    80129e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801289:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801292:	0f b6 00             	movzbl (%rax),%eax
  801295:	84 c0                	test   %al,%al
  801297:	75 de                	jne    801277 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 10          	sub    $0x10,%rsp
  8012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ac:	89 f0                	mov    %esi,%eax
  8012ae:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b1:	eb 11                	jmp    8012c4 <strfind+0x24>
		if (*s == c)
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	0f b6 00             	movzbl (%rax),%eax
  8012ba:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012bd:	74 12                	je     8012d1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	75 e4                	jne    8012b3 <strfind+0x13>
  8012cf:	eb 01                	jmp    8012d2 <strfind+0x32>
		if (*s == c)
			break;
  8012d1:	90                   	nop
	return (char *) s;
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d6:	c9                   	leaveq 
  8012d7:	c3                   	retq   

00000000008012d8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012d8:	55                   	push   %rbp
  8012d9:	48 89 e5             	mov    %rsp,%rbp
  8012dc:	48 83 ec 18          	sub    $0x18,%rsp
  8012e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012f0:	75 06                	jne    8012f8 <memset+0x20>
		return v;
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	eb 69                	jmp    801361 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fc:	83 e0 03             	and    $0x3,%eax
  8012ff:	48 85 c0             	test   %rax,%rax
  801302:	75 48                	jne    80134c <memset+0x74>
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801308:	83 e0 03             	and    $0x3,%eax
  80130b:	48 85 c0             	test   %rax,%rax
  80130e:	75 3c                	jne    80134c <memset+0x74>
		c &= 0xFF;
  801310:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801317:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131a:	c1 e0 18             	shl    $0x18,%eax
  80131d:	89 c2                	mov    %eax,%edx
  80131f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801322:	c1 e0 10             	shl    $0x10,%eax
  801325:	09 c2                	or     %eax,%edx
  801327:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132a:	c1 e0 08             	shl    $0x8,%eax
  80132d:	09 d0                	or     %edx,%eax
  80132f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801336:	48 c1 e8 02          	shr    $0x2,%rax
  80133a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80133d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801341:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801344:	48 89 d7             	mov    %rdx,%rdi
  801347:	fc                   	cld    
  801348:	f3 ab                	rep stos %eax,%es:(%rdi)
  80134a:	eb 11                	jmp    80135d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80134c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801350:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801353:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801357:	48 89 d7             	mov    %rdx,%rdi
  80135a:	fc                   	cld    
  80135b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801361:	c9                   	leaveq 
  801362:	c3                   	retq   

0000000000801363 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801363:	55                   	push   %rbp
  801364:	48 89 e5             	mov    %rsp,%rbp
  801367:	48 83 ec 28          	sub    $0x28,%rsp
  80136b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801373:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801377:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80137f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801383:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80138f:	0f 83 88 00 00 00    	jae    80141d <memmove+0xba>
  801395:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801399:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139d:	48 01 d0             	add    %rdx,%rax
  8013a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a4:	76 77                	jbe    80141d <memmove+0xba>
		s += n;
  8013a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013aa:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ba:	83 e0 03             	and    $0x3,%eax
  8013bd:	48 85 c0             	test   %rax,%rax
  8013c0:	75 3b                	jne    8013fd <memmove+0x9a>
  8013c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c6:	83 e0 03             	and    $0x3,%eax
  8013c9:	48 85 c0             	test   %rax,%rax
  8013cc:	75 2f                	jne    8013fd <memmove+0x9a>
  8013ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d2:	83 e0 03             	and    $0x3,%eax
  8013d5:	48 85 c0             	test   %rax,%rax
  8013d8:	75 23                	jne    8013fd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013de:	48 83 e8 04          	sub    $0x4,%rax
  8013e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e6:	48 83 ea 04          	sub    $0x4,%rdx
  8013ea:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ee:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013f2:	48 89 c7             	mov    %rax,%rdi
  8013f5:	48 89 d6             	mov    %rdx,%rsi
  8013f8:	fd                   	std    
  8013f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013fb:	eb 1d                	jmp    80141a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801401:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	48 89 d7             	mov    %rdx,%rdi
  801414:	48 89 c1             	mov    %rax,%rcx
  801417:	fd                   	std    
  801418:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80141a:	fc                   	cld    
  80141b:	eb 57                	jmp    801474 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80141d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801421:	83 e0 03             	and    $0x3,%eax
  801424:	48 85 c0             	test   %rax,%rax
  801427:	75 36                	jne    80145f <memmove+0xfc>
  801429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142d:	83 e0 03             	and    $0x3,%eax
  801430:	48 85 c0             	test   %rax,%rax
  801433:	75 2a                	jne    80145f <memmove+0xfc>
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	83 e0 03             	and    $0x3,%eax
  80143c:	48 85 c0             	test   %rax,%rax
  80143f:	75 1e                	jne    80145f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801441:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801445:	48 c1 e8 02          	shr    $0x2,%rax
  801449:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80144c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801450:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801454:	48 89 c7             	mov    %rax,%rdi
  801457:	48 89 d6             	mov    %rdx,%rsi
  80145a:	fc                   	cld    
  80145b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145d:	eb 15                	jmp    801474 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80145f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801463:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801467:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80146b:	48 89 c7             	mov    %rax,%rdi
  80146e:	48 89 d6             	mov    %rdx,%rsi
  801471:	fc                   	cld    
  801472:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801478:	c9                   	leaveq 
  801479:	c3                   	retq   

000000000080147a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80147a:	55                   	push   %rbp
  80147b:	48 89 e5             	mov    %rsp,%rbp
  80147e:	48 83 ec 18          	sub    $0x18,%rsp
  801482:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801486:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80148a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80148e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801492:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	48 89 ce             	mov    %rcx,%rsi
  80149d:	48 89 c7             	mov    %rax,%rdi
  8014a0:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  8014a7:	00 00 00 
  8014aa:	ff d0                	callq  *%rax
}
  8014ac:	c9                   	leaveq 
  8014ad:	c3                   	retq   

00000000008014ae <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ae:	55                   	push   %rbp
  8014af:	48 89 e5             	mov    %rsp,%rbp
  8014b2:	48 83 ec 28          	sub    $0x28,%rsp
  8014b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014d2:	eb 36                	jmp    80150a <memcmp+0x5c>
		if (*s1 != *s2)
  8014d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d8:	0f b6 10             	movzbl (%rax),%edx
  8014db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	38 c2                	cmp    %al,%dl
  8014e4:	74 1a                	je     801500 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	0f b6 d0             	movzbl %al,%edx
  8014f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	0f b6 c0             	movzbl %al,%eax
  8014fa:	29 c2                	sub    %eax,%edx
  8014fc:	89 d0                	mov    %edx,%eax
  8014fe:	eb 20                	jmp    801520 <memcmp+0x72>
		s1++, s2++;
  801500:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801505:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80150a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801512:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801516:	48 85 c0             	test   %rax,%rax
  801519:	75 b9                	jne    8014d4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801520:	c9                   	leaveq 
  801521:	c3                   	retq   

0000000000801522 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801522:	55                   	push   %rbp
  801523:	48 89 e5             	mov    %rsp,%rbp
  801526:	48 83 ec 28          	sub    $0x28,%rsp
  80152a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801531:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801535:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	48 01 d0             	add    %rdx,%rax
  801540:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801544:	eb 19                	jmp    80155f <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154a:	0f b6 00             	movzbl (%rax),%eax
  80154d:	0f b6 d0             	movzbl %al,%edx
  801550:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801553:	0f b6 c0             	movzbl %al,%eax
  801556:	39 c2                	cmp    %eax,%edx
  801558:	74 11                	je     80156b <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80155a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801563:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801567:	72 dd                	jb     801546 <memfind+0x24>
  801569:	eb 01                	jmp    80156c <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80156b:	90                   	nop
	return (void *) s;
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	48 83 ec 38          	sub    $0x38,%rsp
  80157a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80157e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801582:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801585:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80158c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801593:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801594:	eb 05                	jmp    80159b <strtol+0x29>
		s++;
  801596:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	3c 20                	cmp    $0x20,%al
  8015a4:	74 f0                	je     801596 <strtol+0x24>
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 09                	cmp    $0x9,%al
  8015af:	74 e5                	je     801596 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 2b                	cmp    $0x2b,%al
  8015ba:	75 07                	jne    8015c3 <strtol+0x51>
		s++;
  8015bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c1:	eb 17                	jmp    8015da <strtol+0x68>
	else if (*s == '-')
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	3c 2d                	cmp    $0x2d,%al
  8015cc:	75 0c                	jne    8015da <strtol+0x68>
		s++, neg = 1;
  8015ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015da:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015de:	74 06                	je     8015e6 <strtol+0x74>
  8015e0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015e4:	75 28                	jne    80160e <strtol+0x9c>
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	3c 30                	cmp    $0x30,%al
  8015ef:	75 1d                	jne    80160e <strtol+0x9c>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	48 83 c0 01          	add    $0x1,%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3c 78                	cmp    $0x78,%al
  8015fe:	75 0e                	jne    80160e <strtol+0x9c>
		s += 2, base = 16;
  801600:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801605:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80160c:	eb 2c                	jmp    80163a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80160e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801612:	75 19                	jne    80162d <strtol+0xbb>
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 30                	cmp    $0x30,%al
  80161d:	75 0e                	jne    80162d <strtol+0xbb>
		s++, base = 8;
  80161f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801624:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80162b:	eb 0d                	jmp    80163a <strtol+0xc8>
	else if (base == 0)
  80162d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801631:	75 07                	jne    80163a <strtol+0xc8>
		base = 10;
  801633:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	3c 2f                	cmp    $0x2f,%al
  801643:	7e 1d                	jle    801662 <strtol+0xf0>
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 39                	cmp    $0x39,%al
  80164e:	7f 12                	jg     801662 <strtol+0xf0>
			dig = *s - '0';
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	0f be c0             	movsbl %al,%eax
  80165a:	83 e8 30             	sub    $0x30,%eax
  80165d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801660:	eb 4e                	jmp    8016b0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 1d                	jle    80168a <strtol+0x118>
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 7a                	cmp    $0x7a,%al
  801676:	7f 12                	jg     80168a <strtol+0x118>
			dig = *s - 'a' + 10;
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	0f be c0             	movsbl %al,%eax
  801682:	83 e8 57             	sub    $0x57,%eax
  801685:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801688:	eb 26                	jmp    8016b0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80168a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168e:	0f b6 00             	movzbl (%rax),%eax
  801691:	3c 40                	cmp    $0x40,%al
  801693:	7e 47                	jle    8016dc <strtol+0x16a>
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 5a                	cmp    $0x5a,%al
  80169e:	7f 3c                	jg     8016dc <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	0f be c0             	movsbl %al,%eax
  8016aa:	83 e8 37             	sub    $0x37,%eax
  8016ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b6:	7d 23                	jge    8016db <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016b8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016c0:	48 98                	cltq   
  8016c2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016c7:	48 89 c2             	mov    %rax,%rdx
  8016ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016cd:	48 98                	cltq   
  8016cf:	48 01 d0             	add    %rdx,%rax
  8016d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016d6:	e9 5f ff ff ff       	jmpq   80163a <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016db:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016dc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016e1:	74 0b                	je     8016ee <strtol+0x17c>
		*endptr = (char *) s;
  8016e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016eb:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f2:	74 09                	je     8016fd <strtol+0x18b>
  8016f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f8:	48 f7 d8             	neg    %rax
  8016fb:	eb 04                	jmp    801701 <strtol+0x18f>
  8016fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <strstr>:

char * strstr(const char *in, const char *str)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 30          	sub    $0x30,%rsp
  80170b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801713:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801717:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80171b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80171f:	0f b6 00             	movzbl (%rax),%eax
  801722:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801725:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801729:	75 06                	jne    801731 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80172b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172f:	eb 6b                	jmp    80179c <strstr+0x99>

	len = strlen(str);
  801731:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801735:	48 89 c7             	mov    %rax,%rdi
  801738:	48 b8 d2 0f 80 00 00 	movabs $0x800fd2,%rax
  80173f:	00 00 00 
  801742:	ff d0                	callq  *%rax
  801744:	48 98                	cltq   
  801746:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801752:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80175c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801760:	75 07                	jne    801769 <strstr+0x66>
				return (char *) 0;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
  801767:	eb 33                	jmp    80179c <strstr+0x99>
		} while (sc != c);
  801769:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80176d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801770:	75 d8                	jne    80174a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801772:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801776:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	48 89 ce             	mov    %rcx,%rsi
  801781:	48 89 c7             	mov    %rax,%rdi
  801784:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  80178b:	00 00 00 
  80178e:	ff d0                	callq  *%rax
  801790:	85 c0                	test   %eax,%eax
  801792:	75 b6                	jne    80174a <strstr+0x47>

	return (char *) (in - 1);
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	48 83 e8 01          	sub    $0x1,%rax
}
  80179c:	c9                   	leaveq 
  80179d:	c3                   	retq   

000000000080179e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80179e:	55                   	push   %rbp
  80179f:	48 89 e5             	mov    %rsp,%rbp
  8017a2:	53                   	push   %rbx
  8017a3:	48 83 ec 48          	sub    $0x48,%rsp
  8017a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017aa:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017ad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017b5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017b9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017c8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017cc:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017d0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d4:	4c 89 c3             	mov    %r8,%rbx
  8017d7:	cd 30                	int    $0x30
  8017d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017e1:	74 3e                	je     801821 <syscall+0x83>
  8017e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017e8:	7e 37                	jle    801821 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f1:	49 89 d0             	mov    %rdx,%r8
  8017f4:	89 c1                	mov    %eax,%ecx
  8017f6:	48 ba e8 4d 80 00 00 	movabs $0x804de8,%rdx
  8017fd:	00 00 00 
  801800:	be 24 00 00 00       	mov    $0x24,%esi
  801805:	48 bf 05 4e 80 00 00 	movabs $0x804e05,%rdi
  80180c:	00 00 00 
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
  801814:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  80181b:	00 00 00 
  80181e:	41 ff d1             	callq  *%r9

	return ret;
  801821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801825:	48 83 c4 48          	add    $0x48,%rsp
  801829:	5b                   	pop    %rbx
  80182a:	5d                   	pop    %rbp
  80182b:	c3                   	retq   

000000000080182c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	48 83 ec 10          	sub    $0x10,%rsp
  801834:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801838:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80183c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801840:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801844:	48 83 ec 08          	sub    $0x8,%rsp
  801848:	6a 00                	pushq  $0x0
  80184a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801850:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801856:	48 89 d1             	mov    %rdx,%rcx
  801859:	48 89 c2             	mov    %rax,%rdx
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	bf 00 00 00 00       	mov    $0x0,%edi
  801866:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  80186d:	00 00 00 
  801870:	ff d0                	callq  *%rax
  801872:	48 83 c4 10          	add    $0x10,%rsp
}
  801876:	90                   	nop
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_cgetc>:

int
sys_cgetc(void)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80187d:	48 83 ec 08          	sub    $0x8,%rsp
  801881:	6a 00                	pushq  $0x0
  801883:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801889:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801894:	ba 00 00 00 00       	mov    $0x0,%edx
  801899:	be 00 00 00 00       	mov    $0x0,%esi
  80189e:	bf 01 00 00 00       	mov    $0x1,%edi
  8018a3:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  8018aa:	00 00 00 
  8018ad:	ff d0                	callq  *%rax
  8018af:	48 83 c4 10          	add    $0x10,%rsp
}
  8018b3:	c9                   	leaveq 
  8018b4:	c3                   	retq   

00000000008018b5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b5:	55                   	push   %rbp
  8018b6:	48 89 e5             	mov    %rsp,%rbp
  8018b9:	48 83 ec 10          	sub    $0x10,%rsp
  8018bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c3:	48 98                	cltq   
  8018c5:	48 83 ec 08          	sub    $0x8,%rsp
  8018c9:	6a 00                	pushq  $0x0
  8018cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018dc:	48 89 c2             	mov    %rax,%rdx
  8018df:	be 01 00 00 00       	mov    $0x1,%esi
  8018e4:	bf 03 00 00 00       	mov    $0x3,%edi
  8018e9:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  8018f0:	00 00 00 
  8018f3:	ff d0                	callq  *%rax
  8018f5:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f9:	c9                   	leaveq 
  8018fa:	c3                   	retq   

00000000008018fb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018fb:	55                   	push   %rbp
  8018fc:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ff:	48 83 ec 08          	sub    $0x8,%rsp
  801903:	6a 00                	pushq  $0x0
  801905:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801911:	b9 00 00 00 00       	mov    $0x0,%ecx
  801916:	ba 00 00 00 00       	mov    $0x0,%edx
  80191b:	be 00 00 00 00       	mov    $0x0,%esi
  801920:	bf 02 00 00 00       	mov    $0x2,%edi
  801925:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  80192c:	00 00 00 
  80192f:	ff d0                	callq  *%rax
  801931:	48 83 c4 10          	add    $0x10,%rsp
}
  801935:	c9                   	leaveq 
  801936:	c3                   	retq   

0000000000801937 <sys_yield>:


void
sys_yield(void)
{
  801937:	55                   	push   %rbp
  801938:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80193b:	48 83 ec 08          	sub    $0x8,%rsp
  80193f:	6a 00                	pushq  $0x0
  801941:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801947:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	be 00 00 00 00       	mov    $0x0,%esi
  80195c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801961:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801968:	00 00 00 
  80196b:	ff d0                	callq  *%rax
  80196d:	48 83 c4 10          	add    $0x10,%rsp
}
  801971:	90                   	nop
  801972:	c9                   	leaveq 
  801973:	c3                   	retq   

0000000000801974 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801974:	55                   	push   %rbp
  801975:	48 89 e5             	mov    %rsp,%rbp
  801978:	48 83 ec 10          	sub    $0x10,%rsp
  80197c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801983:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801986:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801989:	48 63 c8             	movslq %eax,%rcx
  80198c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801993:	48 98                	cltq   
  801995:	48 83 ec 08          	sub    $0x8,%rsp
  801999:	6a 00                	pushq  $0x0
  80199b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a1:	49 89 c8             	mov    %rcx,%r8
  8019a4:	48 89 d1             	mov    %rdx,%rcx
  8019a7:	48 89 c2             	mov    %rax,%rdx
  8019aa:	be 01 00 00 00       	mov    $0x1,%esi
  8019af:	bf 04 00 00 00       	mov    $0x4,%edi
  8019b4:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	callq  *%rax
  8019c0:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c4:	c9                   	leaveq 
  8019c5:	c3                   	retq   

00000000008019c6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019c6:	55                   	push   %rbp
  8019c7:	48 89 e5             	mov    %rsp,%rbp
  8019ca:	48 83 ec 20          	sub    $0x20,%rsp
  8019ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019d8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019dc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019e0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019e3:	48 63 c8             	movslq %eax,%rcx
  8019e6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ed:	48 63 f0             	movslq %eax,%rsi
  8019f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f7:	48 98                	cltq   
  8019f9:	48 83 ec 08          	sub    $0x8,%rsp
  8019fd:	51                   	push   %rcx
  8019fe:	49 89 f9             	mov    %rdi,%r9
  801a01:	49 89 f0             	mov    %rsi,%r8
  801a04:	48 89 d1             	mov    %rdx,%rcx
  801a07:	48 89 c2             	mov    %rax,%rdx
  801a0a:	be 01 00 00 00       	mov    $0x1,%esi
  801a0f:	bf 05 00 00 00       	mov    $0x5,%edi
  801a14:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801a1b:	00 00 00 
  801a1e:	ff d0                	callq  *%rax
  801a20:	48 83 c4 10          	add    $0x10,%rsp
}
  801a24:	c9                   	leaveq 
  801a25:	c3                   	retq   

0000000000801a26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a26:	55                   	push   %rbp
  801a27:	48 89 e5             	mov    %rsp,%rbp
  801a2a:	48 83 ec 10          	sub    $0x10,%rsp
  801a2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3c:	48 98                	cltq   
  801a3e:	48 83 ec 08          	sub    $0x8,%rsp
  801a42:	6a 00                	pushq  $0x0
  801a44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a50:	48 89 d1             	mov    %rdx,%rcx
  801a53:	48 89 c2             	mov    %rax,%rdx
  801a56:	be 01 00 00 00       	mov    $0x1,%esi
  801a5b:	bf 06 00 00 00       	mov    $0x6,%edi
  801a60:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	callq  *%rax
  801a6c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a70:	c9                   	leaveq 
  801a71:	c3                   	retq   

0000000000801a72 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a72:	55                   	push   %rbp
  801a73:	48 89 e5             	mov    %rsp,%rbp
  801a76:	48 83 ec 10          	sub    $0x10,%rsp
  801a7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a83:	48 63 d0             	movslq %eax,%rdx
  801a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a89:	48 98                	cltq   
  801a8b:	48 83 ec 08          	sub    $0x8,%rsp
  801a8f:	6a 00                	pushq  $0x0
  801a91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9d:	48 89 d1             	mov    %rdx,%rcx
  801aa0:	48 89 c2             	mov    %rax,%rdx
  801aa3:	be 01 00 00 00       	mov    $0x1,%esi
  801aa8:	bf 08 00 00 00       	mov    $0x8,%edi
  801aad:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
  801ab9:	48 83 c4 10          	add    $0x10,%rsp
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 10          	sub    $0x10,%rsp
  801ac7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ace:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad5:	48 98                	cltq   
  801ad7:	48 83 ec 08          	sub    $0x8,%rsp
  801adb:	6a 00                	pushq  $0x0
  801add:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae9:	48 89 d1             	mov    %rdx,%rcx
  801aec:	48 89 c2             	mov    %rax,%rdx
  801aef:	be 01 00 00 00       	mov    $0x1,%esi
  801af4:	bf 09 00 00 00       	mov    $0x9,%edi
  801af9:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	callq  *%rax
  801b05:	48 83 c4 10          	add    $0x10,%rsp
}
  801b09:	c9                   	leaveq 
  801b0a:	c3                   	retq   

0000000000801b0b <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b0b:	55                   	push   %rbp
  801b0c:	48 89 e5             	mov    %rsp,%rbp
  801b0f:	48 83 ec 10          	sub    $0x10,%rsp
  801b13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b21:	48 98                	cltq   
  801b23:	48 83 ec 08          	sub    $0x8,%rsp
  801b27:	6a 00                	pushq  $0x0
  801b29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b35:	48 89 d1             	mov    %rdx,%rcx
  801b38:	48 89 c2             	mov    %rax,%rdx
  801b3b:	be 01 00 00 00       	mov    $0x1,%esi
  801b40:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b45:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801b4c:	00 00 00 
  801b4f:	ff d0                	callq  *%rax
  801b51:	48 83 c4 10          	add    $0x10,%rsp
}
  801b55:	c9                   	leaveq 
  801b56:	c3                   	retq   

0000000000801b57 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b57:	55                   	push   %rbp
  801b58:	48 89 e5             	mov    %rsp,%rbp
  801b5b:	48 83 ec 20          	sub    $0x20,%rsp
  801b5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b6a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b70:	48 63 f0             	movslq %eax,%rsi
  801b73:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7a:	48 98                	cltq   
  801b7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b80:	48 83 ec 08          	sub    $0x8,%rsp
  801b84:	6a 00                	pushq  $0x0
  801b86:	49 89 f1             	mov    %rsi,%r9
  801b89:	49 89 c8             	mov    %rcx,%r8
  801b8c:	48 89 d1             	mov    %rdx,%rcx
  801b8f:	48 89 c2             	mov    %rax,%rdx
  801b92:	be 00 00 00 00       	mov    $0x0,%esi
  801b97:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b9c:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	callq  *%rax
  801ba8:	48 83 c4 10          	add    $0x10,%rsp
}
  801bac:	c9                   	leaveq 
  801bad:	c3                   	retq   

0000000000801bae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bae:	55                   	push   %rbp
  801baf:	48 89 e5             	mov    %rsp,%rbp
  801bb2:	48 83 ec 10          	sub    $0x10,%rsp
  801bb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbe:	48 83 ec 08          	sub    $0x8,%rsp
  801bc2:	6a 00                	pushq  $0x0
  801bc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd5:	48 89 c2             	mov    %rax,%rdx
  801bd8:	be 01 00 00 00       	mov    $0x1,%esi
  801bdd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801be2:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	callq  *%rax
  801bee:	48 83 c4 10          	add    $0x10,%rsp
}
  801bf2:	c9                   	leaveq 
  801bf3:	c3                   	retq   

0000000000801bf4 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801bf4:	55                   	push   %rbp
  801bf5:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bf8:	48 83 ec 08          	sub    $0x8,%rsp
  801bfc:	6a 00                	pushq  $0x0
  801bfe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c14:	be 00 00 00 00       	mov    $0x0,%esi
  801c19:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c1e:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801c25:	00 00 00 
  801c28:	ff d0                	callq  *%rax
  801c2a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c2e:	c9                   	leaveq 
  801c2f:	c3                   	retq   

0000000000801c30 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	48 83 ec 10          	sub    $0x10,%rsp
  801c38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c3c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801c3f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c46:	48 83 ec 08          	sub    $0x8,%rsp
  801c4a:	6a 00                	pushq  $0x0
  801c4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c58:	48 89 d1             	mov    %rdx,%rcx
  801c5b:	48 89 c2             	mov    %rax,%rdx
  801c5e:	be 00 00 00 00       	mov    $0x0,%esi
  801c63:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c68:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	callq  *%rax
  801c74:	48 83 c4 10          	add    $0x10,%rsp
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 10          	sub    $0x10,%rsp
  801c82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c86:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801c89:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c90:	48 83 ec 08          	sub    $0x8,%rsp
  801c94:	6a 00                	pushq  $0x0
  801c96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca2:	48 89 d1             	mov    %rdx,%rcx
  801ca5:	48 89 c2             	mov    %rax,%rdx
  801ca8:	be 00 00 00 00       	mov    $0x0,%esi
  801cad:	bf 10 00 00 00       	mov    $0x10,%edi
  801cb2:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801cb9:	00 00 00 
  801cbc:	ff d0                	callq  *%rax
  801cbe:	48 83 c4 10          	add    $0x10,%rsp
}
  801cc2:	c9                   	leaveq 
  801cc3:	c3                   	retq   

0000000000801cc4 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	48 83 ec 20          	sub    $0x20,%rsp
  801ccc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ccf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cd6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cda:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cde:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ce1:	48 63 c8             	movslq %eax,%rcx
  801ce4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ce8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ceb:	48 63 f0             	movslq %eax,%rsi
  801cee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf5:	48 98                	cltq   
  801cf7:	48 83 ec 08          	sub    $0x8,%rsp
  801cfb:	51                   	push   %rcx
  801cfc:	49 89 f9             	mov    %rdi,%r9
  801cff:	49 89 f0             	mov    %rsi,%r8
  801d02:	48 89 d1             	mov    %rdx,%rcx
  801d05:	48 89 c2             	mov    %rax,%rdx
  801d08:	be 00 00 00 00       	mov    $0x0,%esi
  801d0d:	bf 11 00 00 00       	mov    $0x11,%edi
  801d12:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
  801d1e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d22:	c9                   	leaveq 
  801d23:	c3                   	retq   

0000000000801d24 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 83 ec 10          	sub    $0x10,%rsp
  801d2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3c:	48 83 ec 08          	sub    $0x8,%rsp
  801d40:	6a 00                	pushq  $0x0
  801d42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4e:	48 89 d1             	mov    %rdx,%rcx
  801d51:	48 89 c2             	mov    %rax,%rdx
  801d54:	be 00 00 00 00       	mov    $0x0,%esi
  801d59:	bf 12 00 00 00       	mov    $0x12,%edi
  801d5e:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	callq  *%rax
  801d6a:	48 83 c4 10          	add    $0x10,%rsp
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801d74:	48 83 ec 08          	sub    $0x8,%rsp
  801d78:	6a 00                	pushq  $0x0
  801d7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d86:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d90:	be 00 00 00 00       	mov    $0x0,%esi
  801d95:	bf 13 00 00 00       	mov    $0x13,%edi
  801d9a:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax
  801da6:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801daa:	90                   	nop
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 10          	sub    $0x10,%rsp
  801db5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbb:	48 98                	cltq   
  801dbd:	48 83 ec 08          	sub    $0x8,%rsp
  801dc1:	6a 00                	pushq  $0x0
  801dc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd4:	48 89 c2             	mov    %rax,%rdx
  801dd7:	be 00 00 00 00       	mov    $0x0,%esi
  801ddc:	bf 14 00 00 00       	mov    $0x14,%edi
  801de1:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	callq  *%rax
  801ded:	48 83 c4 10          	add    $0x10,%rsp
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801df7:	48 83 ec 08          	sub    $0x8,%rsp
  801dfb:	6a 00                	pushq  $0x0
  801dfd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	be 00 00 00 00       	mov    $0x0,%esi
  801e18:	bf 15 00 00 00       	mov    $0x15,%edi
  801e1d:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801e24:	00 00 00 
  801e27:	ff d0                	callq  *%rax
  801e29:	48 83 c4 10          	add    $0x10,%rsp
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e33:	48 83 ec 08          	sub    $0x8,%rsp
  801e37:	6a 00                	pushq  $0x0
  801e39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4f:	be 00 00 00 00       	mov    $0x0,%esi
  801e54:	bf 16 00 00 00       	mov    $0x16,%edi
  801e59:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  801e60:	00 00 00 
  801e63:	ff d0                	callq  *%rax
  801e65:	48 83 c4 10          	add    $0x10,%rsp
}
  801e69:	90                   	nop
  801e6a:	c9                   	leaveq 
  801e6b:	c3                   	retq   

0000000000801e6c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e6c:	55                   	push   %rbp
  801e6d:	48 89 e5             	mov    %rsp,%rbp
  801e70:	48 83 ec 30          	sub    $0x30,%rsp
  801e74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7c:	48 8b 00             	mov    (%rax),%rax
  801e7f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801e83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e87:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e8b:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e91:	83 e0 02             	and    $0x2,%eax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	75 40                	jne    801ed8 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9c:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801ea3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ea7:	49 89 d0             	mov    %rdx,%r8
  801eaa:	48 89 c1             	mov    %rax,%rcx
  801ead:	48 ba 18 4e 80 00 00 	movabs $0x804e18,%rdx
  801eb4:	00 00 00 
  801eb7:	be 1f 00 00 00       	mov    $0x1f,%esi
  801ebc:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  801ec3:	00 00 00 
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  801ed2:	00 00 00 
  801ed5:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801ed8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801edc:	48 c1 e8 0c          	shr    $0xc,%rax
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eea:	01 00 00 
  801eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef1:	25 07 08 00 00       	and    $0x807,%eax
  801ef6:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801efc:	74 4e                	je     801f4c <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f02:	48 c1 e8 0c          	shr    $0xc,%rax
  801f06:	48 89 c2             	mov    %rax,%rdx
  801f09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f10:	01 00 00 
  801f13:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f1b:	49 89 d0             	mov    %rdx,%r8
  801f1e:	48 89 c1             	mov    %rax,%rcx
  801f21:	48 ba 40 4e 80 00 00 	movabs $0x804e40,%rdx
  801f28:	00 00 00 
  801f2b:	be 22 00 00 00       	mov    $0x22,%esi
  801f30:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  801f37:	00 00 00 
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3f:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  801f46:	00 00 00 
  801f49:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f4c:	ba 07 00 00 00       	mov    $0x7,%edx
  801f51:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f56:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5b:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
  801f67:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801f6a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f6e:	79 30                	jns    801fa0 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801f70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f73:	89 c1                	mov    %eax,%ecx
  801f75:	48 ba 6b 4e 80 00 00 	movabs $0x804e6b,%rdx
  801f7c:	00 00 00 
  801f7f:	be 28 00 00 00       	mov    $0x28,%esi
  801f84:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  801f8b:	00 00 00 
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  801f9a:	00 00 00 
  801f9d:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801fa0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fac:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fb2:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fb7:	48 89 c6             	mov    %rax,%rsi
  801fba:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fbf:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801fcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fcf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fdd:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fe3:	48 89 c1             	mov    %rax,%rcx
  801fe6:	ba 00 00 00 00       	mov    $0x0,%edx
  801feb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ff0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff5:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  801ffc:	00 00 00 
  801fff:	ff d0                	callq  *%rax
  802001:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802004:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802008:	79 30                	jns    80203a <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80200a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80200d:	89 c1                	mov    %eax,%ecx
  80200f:	48 ba 7e 4e 80 00 00 	movabs $0x804e7e,%rdx
  802016:	00 00 00 
  802019:	be 2d 00 00 00       	mov    $0x2d,%esi
  80201e:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  802025:	00 00 00 
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802034:	00 00 00 
  802037:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80203a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80203f:	bf 00 00 00 00       	mov    $0x0,%edi
  802044:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	callq  *%rax
  802050:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802053:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802057:	79 30                	jns    802089 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802059:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80205c:	89 c1                	mov    %eax,%ecx
  80205e:	48 ba 8f 4e 80 00 00 	movabs $0x804e8f,%rdx
  802065:	00 00 00 
  802068:	be 31 00 00 00       	mov    $0x31,%esi
  80206d:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  802074:	00 00 00 
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
  80207c:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802083:	00 00 00 
  802086:	41 ff d0             	callq  *%r8

}
  802089:	90                   	nop
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 30          	sub    $0x30,%rsp
  802094:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802097:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80209a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80209d:	c1 e0 0c             	shl    $0xc,%eax
  8020a0:	89 c0                	mov    %eax,%eax
  8020a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8020a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ad:	01 00 00 
  8020b0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  8020bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bf:	25 02 08 00 00       	and    $0x802,%eax
  8020c4:	48 85 c0             	test   %rax,%rax
  8020c7:	74 0e                	je     8020d7 <duppage+0x4b>
  8020c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020cd:	25 00 04 00 00       	and    $0x400,%eax
  8020d2:	48 85 c0             	test   %rax,%rax
  8020d5:	74 70                	je     802147 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8020d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020db:	25 07 0e 00 00       	and    $0xe07,%eax
  8020e0:	89 c6                	mov    %eax,%esi
  8020e2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8020e6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ed:	41 89 f0             	mov    %esi,%r8d
  8020f0:	48 89 c6             	mov    %rax,%rsi
  8020f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f8:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  8020ff:	00 00 00 
  802102:	ff d0                	callq  *%rax
  802104:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802107:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80210b:	79 30                	jns    80213d <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80210d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802110:	89 c1                	mov    %eax,%ecx
  802112:	48 ba 7e 4e 80 00 00 	movabs $0x804e7e,%rdx
  802119:	00 00 00 
  80211c:	be 50 00 00 00       	mov    $0x50,%esi
  802121:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  802128:	00 00 00 
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
  802130:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802137:	00 00 00 
  80213a:	41 ff d0             	callq  *%r8
		return 0;
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
  802142:	e9 c4 00 00 00       	jmpq   80220b <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802147:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80214b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80214e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802152:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802158:	48 89 c6             	mov    %rax,%rsi
  80215b:	bf 00 00 00 00       	mov    $0x0,%edi
  802160:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  802167:	00 00 00 
  80216a:	ff d0                	callq  *%rax
  80216c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80216f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802173:	79 30                	jns    8021a5 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802175:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802178:	89 c1                	mov    %eax,%ecx
  80217a:	48 ba 7e 4e 80 00 00 	movabs $0x804e7e,%rdx
  802181:	00 00 00 
  802184:	be 64 00 00 00       	mov    $0x64,%esi
  802189:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  802190:	00 00 00 
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80219f:	00 00 00 
  8021a2:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8021a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ad:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8021b3:	48 89 d1             	mov    %rdx,%rcx
  8021b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bb:	48 89 c6             	mov    %rax,%rsi
  8021be:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c3:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  8021ca:	00 00 00 
  8021cd:	ff d0                	callq  *%rax
  8021cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021d6:	79 30                	jns    802208 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8021d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021db:	89 c1                	mov    %eax,%ecx
  8021dd:	48 ba 7e 4e 80 00 00 	movabs $0x804e7e,%rdx
  8021e4:	00 00 00 
  8021e7:	be 66 00 00 00       	mov    $0x66,%esi
  8021ec:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  8021f3:	00 00 00 
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fb:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  802202:	00 00 00 
  802205:	41 ff d0             	callq  *%r8
	return r;
  802208:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80220b:	c9                   	leaveq 
  80220c:	c3                   	retq   

000000000080220d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80220d:	55                   	push   %rbp
  80220e:	48 89 e5             	mov    %rsp,%rbp
  802211:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802215:	48 bf 6c 1e 80 00 00 	movabs $0x801e6c,%rdi
  80221c:	00 00 00 
  80221f:	48 b8 f9 46 80 00 00 	movabs $0x8046f9,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80222b:	b8 07 00 00 00       	mov    $0x7,%eax
  802230:	cd 30                	int    $0x30
  802232:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802235:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802238:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80223b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80223f:	79 08                	jns    802249 <fork+0x3c>
		return envid;
  802241:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802244:	e9 0b 02 00 00       	jmpq   802454 <fork+0x247>
	if (envid == 0) {
  802249:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80224d:	75 3e                	jne    80228d <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80224f:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  802256:	00 00 00 
  802259:	ff d0                	callq  *%rax
  80225b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802260:	48 98                	cltq   
  802262:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802269:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802270:	00 00 00 
  802273:	48 01 c2             	add    %rax,%rdx
  802276:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80227d:	00 00 00 
  802280:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	e9 c7 01 00 00       	jmpq   802454 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80228d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802294:	e9 a6 00 00 00       	jmpq   80233f <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229c:	c1 f8 12             	sar    $0x12,%eax
  80229f:	89 c2                	mov    %eax,%edx
  8022a1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022a8:	01 00 00 
  8022ab:	48 63 d2             	movslq %edx,%rdx
  8022ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b2:	83 e0 01             	and    $0x1,%eax
  8022b5:	48 85 c0             	test   %rax,%rax
  8022b8:	74 21                	je     8022db <fork+0xce>
  8022ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bd:	c1 f8 09             	sar    $0x9,%eax
  8022c0:	89 c2                	mov    %eax,%edx
  8022c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022c9:	01 00 00 
  8022cc:	48 63 d2             	movslq %edx,%rdx
  8022cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d3:	83 e0 01             	and    $0x1,%eax
  8022d6:	48 85 c0             	test   %rax,%rax
  8022d9:	75 09                	jne    8022e4 <fork+0xd7>
			pn += NPTENTRIES;
  8022db:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8022e2:	eb 5b                	jmp    80233f <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8022e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e7:	05 00 02 00 00       	add    $0x200,%eax
  8022ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8022ef:	eb 46                	jmp    802337 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8022f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f8:	01 00 00 
  8022fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022fe:	48 63 d2             	movslq %edx,%rdx
  802301:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802305:	83 e0 05             	and    $0x5,%eax
  802308:	48 83 f8 05          	cmp    $0x5,%rax
  80230c:	75 21                	jne    80232f <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80230e:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802315:	74 1b                	je     802332 <fork+0x125>
				continue;
			duppage(envid, pn);
  802317:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80231a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80231d:	89 d6                	mov    %edx,%esi
  80231f:	89 c7                	mov    %eax,%edi
  802321:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  802328:	00 00 00 
  80232b:	ff d0                	callq  *%rax
  80232d:	eb 04                	jmp    802333 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80232f:	90                   	nop
  802330:	eb 01                	jmp    802333 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802332:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802333:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80233d:	7c b2                	jl     8022f1 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80233f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802342:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802347:	0f 86 4c ff ff ff    	jbe    802299 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80234d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802350:	ba 07 00 00 00       	mov    $0x7,%edx
  802355:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80235a:	89 c7                	mov    %eax,%edi
  80235c:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  802363:	00 00 00 
  802366:	ff d0                	callq  *%rax
  802368:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80236b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80236f:	79 30                	jns    8023a1 <fork+0x194>
		panic("allocating exception stack: %e", r);
  802371:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802374:	89 c1                	mov    %eax,%ecx
  802376:	48 ba a8 4e 80 00 00 	movabs $0x804ea8,%rdx
  80237d:	00 00 00 
  802380:	be 9e 00 00 00       	mov    $0x9e,%esi
  802385:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  80238c:	00 00 00 
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80239b:	00 00 00 
  80239e:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8023a1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023a8:	00 00 00 
  8023ab:	48 8b 00             	mov    (%rax),%rax
  8023ae:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8023b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b8:	48 89 d6             	mov    %rdx,%rsi
  8023bb:	89 c7                	mov    %eax,%edi
  8023bd:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	callq  *%rax
  8023c9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023d0:	79 30                	jns    802402 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8023d2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  8023de:	00 00 00 
  8023e1:	be a2 00 00 00       	mov    $0xa2,%esi
  8023e6:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  8023ed:	00 00 00 
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f5:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8023fc:	00 00 00 
  8023ff:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802402:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802405:	be 02 00 00 00       	mov    $0x2,%esi
  80240a:	89 c7                	mov    %eax,%edi
  80240c:	48 b8 72 1a 80 00 00 	movabs $0x801a72,%rax
  802413:	00 00 00 
  802416:	ff d0                	callq  *%rax
  802418:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80241b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80241f:	79 30                	jns    802451 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802421:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802424:	89 c1                	mov    %eax,%ecx
  802426:	48 ba e7 4e 80 00 00 	movabs $0x804ee7,%rdx
  80242d:	00 00 00 
  802430:	be a7 00 00 00       	mov    $0xa7,%esi
  802435:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  80243c:	00 00 00 
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
  802444:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80244b:	00 00 00 
  80244e:	41 ff d0             	callq  *%r8

	return envid;
  802451:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802454:	c9                   	leaveq 
  802455:	c3                   	retq   

0000000000802456 <sfork>:

// Challenge!
int
sfork(void)
{
  802456:	55                   	push   %rbp
  802457:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80245a:	48 ba fe 4e 80 00 00 	movabs $0x804efe,%rdx
  802461:	00 00 00 
  802464:	be b1 00 00 00       	mov    $0xb1,%esi
  802469:	48 bf 31 4e 80 00 00 	movabs $0x804e31,%rdi
  802470:	00 00 00 
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  80247f:	00 00 00 
  802482:	ff d1                	callq  *%rcx

0000000000802484 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802484:	55                   	push   %rbp
  802485:	48 89 e5             	mov    %rsp,%rbp
  802488:	48 83 ec 30          	sub    $0x30,%rsp
  80248c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802490:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802494:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802498:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80249d:	75 0e                	jne    8024ad <ipc_recv+0x29>
		pg = (void*) UTOP;
  80249f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024a6:	00 00 00 
  8024a9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8024ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b1:	48 89 c7             	mov    %rax,%rdi
  8024b4:	48 b8 ae 1b 80 00 00 	movabs $0x801bae,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
  8024c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c7:	79 27                	jns    8024f0 <ipc_recv+0x6c>
		if (from_env_store)
  8024c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8024ce:	74 0a                	je     8024da <ipc_recv+0x56>
			*from_env_store = 0;
  8024d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8024da:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8024df:	74 0a                	je     8024eb <ipc_recv+0x67>
			*perm_store = 0;
  8024e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8024eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ee:	eb 53                	jmp    802543 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8024f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8024f5:	74 19                	je     802510 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8024f7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024fe:	00 00 00 
  802501:	48 8b 00             	mov    (%rax),%rax
  802504:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80250a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250e:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  802510:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802515:	74 19                	je     802530 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  802517:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80251e:	00 00 00 
  802521:	48 8b 00             	mov    (%rax),%rax
  802524:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80252a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252e:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802530:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802537:	00 00 00 
  80253a:	48 8b 00             	mov    (%rax),%rax
  80253d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802543:	c9                   	leaveq 
  802544:	c3                   	retq   

0000000000802545 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802545:	55                   	push   %rbp
  802546:	48 89 e5             	mov    %rsp,%rbp
  802549:	48 83 ec 30          	sub    $0x30,%rsp
  80254d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802550:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802553:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802557:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80255a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80255f:	75 1c                	jne    80257d <ipc_send+0x38>
		pg = (void*) UTOP;
  802561:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802568:	00 00 00 
  80256b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80256f:	eb 0c                	jmp    80257d <ipc_send+0x38>
		sys_yield();
  802571:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80257d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802580:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802583:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802587:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80258a:	89 c7                	mov    %eax,%edi
  80258c:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
  802598:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80259f:	74 d0                	je     802571 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8025a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a5:	79 30                	jns    8025d7 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8025a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025aa:	89 c1                	mov    %eax,%ecx
  8025ac:	48 ba 14 4f 80 00 00 	movabs $0x804f14,%rdx
  8025b3:	00 00 00 
  8025b6:	be 47 00 00 00       	mov    $0x47,%esi
  8025bb:	48 bf 2a 4f 80 00 00 	movabs $0x804f2a,%rdi
  8025c2:	00 00 00 
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ca:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8025d1:	00 00 00 
  8025d4:	41 ff d0             	callq  *%r8

}
  8025d7:	90                   	nop
  8025d8:	c9                   	leaveq 
  8025d9:	c3                   	retq   

00000000008025da <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025da:	55                   	push   %rbp
  8025db:	48 89 e5             	mov    %rsp,%rbp
  8025de:	48 83 ec 18          	sub    $0x18,%rsp
  8025e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8025e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025ec:	eb 4d                	jmp    80263b <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8025ee:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8025f5:	00 00 00 
  8025f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fb:	48 98                	cltq   
  8025fd:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802604:	48 01 d0             	add    %rdx,%rax
  802607:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80260d:	8b 00                	mov    (%rax),%eax
  80260f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802612:	75 23                	jne    802637 <ipc_find_env+0x5d>
			return envs[i].env_id;
  802614:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80261b:	00 00 00 
  80261e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802621:	48 98                	cltq   
  802623:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80262a:	48 01 d0             	add    %rdx,%rax
  80262d:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802633:	8b 00                	mov    (%rax),%eax
  802635:	eb 12                	jmp    802649 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802637:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80263b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802642:	7e aa                	jle    8025ee <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802649:	c9                   	leaveq 
  80264a:	c3                   	retq   

000000000080264b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80264b:	55                   	push   %rbp
  80264c:	48 89 e5             	mov    %rsp,%rbp
  80264f:	48 83 ec 08          	sub    $0x8,%rsp
  802653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802657:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80265b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802662:	ff ff ff 
  802665:	48 01 d0             	add    %rdx,%rax
  802668:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80266c:	c9                   	leaveq 
  80266d:	c3                   	retq   

000000000080266e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80266e:	55                   	push   %rbp
  80266f:	48 89 e5             	mov    %rsp,%rbp
  802672:	48 83 ec 08          	sub    $0x8,%rsp
  802676:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80267a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80267e:	48 89 c7             	mov    %rax,%rdi
  802681:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  802688:	00 00 00 
  80268b:	ff d0                	callq  *%rax
  80268d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802693:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802697:	c9                   	leaveq 
  802698:	c3                   	retq   

0000000000802699 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802699:	55                   	push   %rbp
  80269a:	48 89 e5             	mov    %rsp,%rbp
  80269d:	48 83 ec 18          	sub    $0x18,%rsp
  8026a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ac:	eb 6b                	jmp    802719 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b1:	48 98                	cltq   
  8026b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8026bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c5:	48 c1 e8 15          	shr    $0x15,%rax
  8026c9:	48 89 c2             	mov    %rax,%rdx
  8026cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026d3:	01 00 00 
  8026d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026da:	83 e0 01             	and    $0x1,%eax
  8026dd:	48 85 c0             	test   %rax,%rax
  8026e0:	74 21                	je     802703 <fd_alloc+0x6a>
  8026e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8026ea:	48 89 c2             	mov    %rax,%rdx
  8026ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026f4:	01 00 00 
  8026f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026fb:	83 e0 01             	and    $0x1,%eax
  8026fe:	48 85 c0             	test   %rax,%rax
  802701:	75 12                	jne    802715 <fd_alloc+0x7c>
			*fd_store = fd;
  802703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80270b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80270e:	b8 00 00 00 00       	mov    $0x0,%eax
  802713:	eb 1a                	jmp    80272f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802715:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802719:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80271d:	7e 8f                	jle    8026ae <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80271f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802723:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80272a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80272f:	c9                   	leaveq 
  802730:	c3                   	retq   

0000000000802731 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
  802735:	48 83 ec 20          	sub    $0x20,%rsp
  802739:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80273c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802740:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802744:	78 06                	js     80274c <fd_lookup+0x1b>
  802746:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80274a:	7e 07                	jle    802753 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80274c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802751:	eb 6c                	jmp    8027bf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802753:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802756:	48 98                	cltq   
  802758:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80275e:	48 c1 e0 0c          	shl    $0xc,%rax
  802762:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80276a:	48 c1 e8 15          	shr    $0x15,%rax
  80276e:	48 89 c2             	mov    %rax,%rdx
  802771:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802778:	01 00 00 
  80277b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277f:	83 e0 01             	and    $0x1,%eax
  802782:	48 85 c0             	test   %rax,%rax
  802785:	74 21                	je     8027a8 <fd_lookup+0x77>
  802787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80278b:	48 c1 e8 0c          	shr    $0xc,%rax
  80278f:	48 89 c2             	mov    %rax,%rdx
  802792:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802799:	01 00 00 
  80279c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a0:	83 e0 01             	and    $0x1,%eax
  8027a3:	48 85 c0             	test   %rax,%rax
  8027a6:	75 07                	jne    8027af <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ad:	eb 10                	jmp    8027bf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027b7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bf:	c9                   	leaveq 
  8027c0:	c3                   	retq   

00000000008027c1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027c1:	55                   	push   %rbp
  8027c2:	48 89 e5             	mov    %rsp,%rbp
  8027c5:	48 83 ec 30          	sub    $0x30,%rsp
  8027c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027cd:	89 f0                	mov    %esi,%eax
  8027cf:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d6:	48 89 c7             	mov    %rax,%rdi
  8027d9:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 c2                	mov    %eax,%edx
  8027e7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027eb:	48 89 c6             	mov    %rax,%rsi
  8027ee:	89 d7                	mov    %edx,%edi
  8027f0:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802803:	78 0a                	js     80280f <fd_close+0x4e>
	    || fd != fd2)
  802805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802809:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80280d:	74 12                	je     802821 <fd_close+0x60>
		return (must_exist ? r : 0);
  80280f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802813:	74 05                	je     80281a <fd_close+0x59>
  802815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802818:	eb 70                	jmp    80288a <fd_close+0xc9>
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	eb 69                	jmp    80288a <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802821:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802825:	8b 00                	mov    (%rax),%eax
  802827:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80282b:	48 89 d6             	mov    %rdx,%rsi
  80282e:	89 c7                	mov    %eax,%edi
  802830:	48 b8 8c 28 80 00 00 	movabs $0x80288c,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802843:	78 2a                	js     80286f <fd_close+0xae>
		if (dev->dev_close)
  802845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802849:	48 8b 40 20          	mov    0x20(%rax),%rax
  80284d:	48 85 c0             	test   %rax,%rax
  802850:	74 16                	je     802868 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802856:	48 8b 40 20          	mov    0x20(%rax),%rax
  80285a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80285e:	48 89 d7             	mov    %rdx,%rdi
  802861:	ff d0                	callq  *%rax
  802863:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802866:	eb 07                	jmp    80286f <fd_close+0xae>
		else
			r = 0;
  802868:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80286f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802873:	48 89 c6             	mov    %rax,%rsi
  802876:	bf 00 00 00 00       	mov    $0x0,%edi
  80287b:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
	return r;
  802887:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80288a:	c9                   	leaveq 
  80288b:	c3                   	retq   

000000000080288c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80288c:	55                   	push   %rbp
  80288d:	48 89 e5             	mov    %rsp,%rbp
  802890:	48 83 ec 20          	sub    $0x20,%rsp
  802894:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802897:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80289b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028a2:	eb 41                	jmp    8028e5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028a4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028ab:	00 00 00 
  8028ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028b1:	48 63 d2             	movslq %edx,%rdx
  8028b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b8:	8b 00                	mov    (%rax),%eax
  8028ba:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028bd:	75 22                	jne    8028e1 <dev_lookup+0x55>
			*dev = devtab[i];
  8028bf:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028c6:	00 00 00 
  8028c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028cc:	48 63 d2             	movslq %edx,%rdx
  8028cf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
  8028df:	eb 60                	jmp    802941 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8028e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028e5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028ec:	00 00 00 
  8028ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028f2:	48 63 d2             	movslq %edx,%rdx
  8028f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f9:	48 85 c0             	test   %rax,%rax
  8028fc:	75 a6                	jne    8028a4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028fe:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802905:	00 00 00 
  802908:	48 8b 00             	mov    (%rax),%rax
  80290b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802911:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802914:	89 c6                	mov    %eax,%esi
  802916:	48 bf 38 4f 80 00 00 	movabs $0x804f38,%rdi
  80291d:	00 00 00 
  802920:	b8 00 00 00 00       	mov    $0x0,%eax
  802925:	48 b9 ae 04 80 00 00 	movabs $0x8004ae,%rcx
  80292c:	00 00 00 
  80292f:	ff d1                	callq  *%rcx
	*dev = 0;
  802931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802935:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80293c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <close>:

int
close(int fdnum)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 20          	sub    $0x20,%rsp
  80294b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80294e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802952:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802955:	48 89 d6             	mov    %rdx,%rsi
  802958:	89 c7                	mov    %eax,%edi
  80295a:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
  802966:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802969:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296d:	79 05                	jns    802974 <close+0x31>
		return r;
  80296f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802972:	eb 18                	jmp    80298c <close+0x49>
	else
		return fd_close(fd, 1);
  802974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802978:	be 01 00 00 00       	mov    $0x1,%esi
  80297d:	48 89 c7             	mov    %rax,%rdi
  802980:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
}
  80298c:	c9                   	leaveq 
  80298d:	c3                   	retq   

000000000080298e <close_all>:

void
close_all(void)
{
  80298e:	55                   	push   %rbp
  80298f:	48 89 e5             	mov    %rsp,%rbp
  802992:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802996:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80299d:	eb 15                	jmp    8029b4 <close_all+0x26>
		close(i);
  80299f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a2:	89 c7                	mov    %eax,%edi
  8029a4:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  8029ab:	00 00 00 
  8029ae:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029b8:	7e e5                	jle    80299f <close_all+0x11>
		close(i);
}
  8029ba:	90                   	nop
  8029bb:	c9                   	leaveq 
  8029bc:	c3                   	retq   

00000000008029bd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 83 ec 40          	sub    $0x40,%rsp
  8029c5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029c8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029cb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029cf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029d2:	48 89 d6             	mov    %rdx,%rsi
  8029d5:	89 c7                	mov    %eax,%edi
  8029d7:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
  8029e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ea:	79 08                	jns    8029f4 <dup+0x37>
		return r;
  8029ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ef:	e9 70 01 00 00       	jmpq   802b64 <dup+0x1a7>
	close(newfdnum);
  8029f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029f7:	89 c7                	mov    %eax,%edi
  8029f9:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a05:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a08:	48 98                	cltq   
  802a0a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a10:	48 c1 e0 0c          	shl    $0xc,%rax
  802a14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a1c:	48 89 c7             	mov    %rax,%rdi
  802a1f:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
  802a2b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a33:	48 89 c7             	mov    %rax,%rdi
  802a36:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  802a3d:	00 00 00 
  802a40:	ff d0                	callq  *%rax
  802a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4a:	48 c1 e8 15          	shr    $0x15,%rax
  802a4e:	48 89 c2             	mov    %rax,%rdx
  802a51:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a58:	01 00 00 
  802a5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a5f:	83 e0 01             	and    $0x1,%eax
  802a62:	48 85 c0             	test   %rax,%rax
  802a65:	74 71                	je     802ad8 <dup+0x11b>
  802a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6b:	48 c1 e8 0c          	shr    $0xc,%rax
  802a6f:	48 89 c2             	mov    %rax,%rdx
  802a72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a79:	01 00 00 
  802a7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a80:	83 e0 01             	and    $0x1,%eax
  802a83:	48 85 c0             	test   %rax,%rax
  802a86:	74 50                	je     802ad8 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8c:	48 c1 e8 0c          	shr    $0xc,%rax
  802a90:	48 89 c2             	mov    %rax,%rdx
  802a93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a9a:	01 00 00 
  802a9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aa1:	25 07 0e 00 00       	and    $0xe07,%eax
  802aa6:	89 c1                	mov    %eax,%ecx
  802aa8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab0:	41 89 c8             	mov    %ecx,%r8d
  802ab3:	48 89 d1             	mov    %rdx,%rcx
  802ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  802abb:	48 89 c6             	mov    %rax,%rsi
  802abe:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac3:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
  802acf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad6:	78 55                	js     802b2d <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802adc:	48 c1 e8 0c          	shr    $0xc,%rax
  802ae0:	48 89 c2             	mov    %rax,%rdx
  802ae3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aea:	01 00 00 
  802aed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af1:	25 07 0e 00 00       	and    $0xe07,%eax
  802af6:	89 c1                	mov    %eax,%ecx
  802af8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802afc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b00:	41 89 c8             	mov    %ecx,%r8d
  802b03:	48 89 d1             	mov    %rdx,%rcx
  802b06:	ba 00 00 00 00       	mov    $0x0,%edx
  802b0b:	48 89 c6             	mov    %rax,%rsi
  802b0e:	bf 00 00 00 00       	mov    $0x0,%edi
  802b13:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
  802b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b26:	78 08                	js     802b30 <dup+0x173>
		goto err;

	return newfdnum;
  802b28:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b2b:	eb 37                	jmp    802b64 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802b2d:	90                   	nop
  802b2e:	eb 01                	jmp    802b31 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802b30:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802b31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b35:	48 89 c6             	mov    %rax,%rsi
  802b38:	bf 00 00 00 00       	mov    $0x0,%edi
  802b3d:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b4d:	48 89 c6             	mov    %rax,%rsi
  802b50:	bf 00 00 00 00       	mov    $0x0,%edi
  802b55:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
	return r;
  802b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b64:	c9                   	leaveq 
  802b65:	c3                   	retq   

0000000000802b66 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b66:	55                   	push   %rbp
  802b67:	48 89 e5             	mov    %rsp,%rbp
  802b6a:	48 83 ec 40          	sub    $0x40,%rsp
  802b6e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b71:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b75:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b79:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b7d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b80:	48 89 d6             	mov    %rdx,%rsi
  802b83:	89 c7                	mov    %eax,%edi
  802b85:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
  802b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b98:	78 24                	js     802bbe <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9e:	8b 00                	mov    (%rax),%eax
  802ba0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba4:	48 89 d6             	mov    %rdx,%rsi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 8c 28 80 00 00 	movabs $0x80288c,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	79 05                	jns    802bc3 <read+0x5d>
		return r;
  802bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc1:	eb 76                	jmp    802c39 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802bc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc7:	8b 40 08             	mov    0x8(%rax),%eax
  802bca:	83 e0 03             	and    $0x3,%eax
  802bcd:	83 f8 01             	cmp    $0x1,%eax
  802bd0:	75 3a                	jne    802c0c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bd2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802bd9:	00 00 00 
  802bdc:	48 8b 00             	mov    (%rax),%rax
  802bdf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802be5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802be8:	89 c6                	mov    %eax,%esi
  802bea:	48 bf 57 4f 80 00 00 	movabs $0x804f57,%rdi
  802bf1:	00 00 00 
  802bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf9:	48 b9 ae 04 80 00 00 	movabs $0x8004ae,%rcx
  802c00:	00 00 00 
  802c03:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c0a:	eb 2d                	jmp    802c39 <read+0xd3>
	}
	if (!dev->dev_read)
  802c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c10:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c14:	48 85 c0             	test   %rax,%rax
  802c17:	75 07                	jne    802c20 <read+0xba>
		return -E_NOT_SUPP;
  802c19:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c1e:	eb 19                	jmp    802c39 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c24:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c2c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c30:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c34:	48 89 cf             	mov    %rcx,%rdi
  802c37:	ff d0                	callq  *%rax
}
  802c39:	c9                   	leaveq 
  802c3a:	c3                   	retq   

0000000000802c3b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c3b:	55                   	push   %rbp
  802c3c:	48 89 e5             	mov    %rsp,%rbp
  802c3f:	48 83 ec 30          	sub    $0x30,%rsp
  802c43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c55:	eb 47                	jmp    802c9e <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5a:	48 98                	cltq   
  802c5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c60:	48 29 c2             	sub    %rax,%rdx
  802c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c66:	48 63 c8             	movslq %eax,%rcx
  802c69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6d:	48 01 c1             	add    %rax,%rcx
  802c70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c73:	48 89 ce             	mov    %rcx,%rsi
  802c76:	89 c7                	mov    %eax,%edi
  802c78:	48 b8 66 2b 80 00 00 	movabs $0x802b66,%rax
  802c7f:	00 00 00 
  802c82:	ff d0                	callq  *%rax
  802c84:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c87:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c8b:	79 05                	jns    802c92 <readn+0x57>
			return m;
  802c8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c90:	eb 1d                	jmp    802caf <readn+0x74>
		if (m == 0)
  802c92:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c96:	74 13                	je     802cab <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c9b:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca1:	48 98                	cltq   
  802ca3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ca7:	72 ae                	jb     802c57 <readn+0x1c>
  802ca9:	eb 01                	jmp    802cac <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802cab:	90                   	nop
	}
	return tot;
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802caf:	c9                   	leaveq 
  802cb0:	c3                   	retq   

0000000000802cb1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cb1:	55                   	push   %rbp
  802cb2:	48 89 e5             	mov    %rsp,%rbp
  802cb5:	48 83 ec 40          	sub    $0x40,%rsp
  802cb9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cc0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ccb:	48 89 d6             	mov    %rdx,%rsi
  802cce:	89 c7                	mov    %eax,%edi
  802cd0:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
  802cdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce3:	78 24                	js     802d09 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce9:	8b 00                	mov    (%rax),%eax
  802ceb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cef:	48 89 d6             	mov    %rdx,%rsi
  802cf2:	89 c7                	mov    %eax,%edi
  802cf4:	48 b8 8c 28 80 00 00 	movabs $0x80288c,%rax
  802cfb:	00 00 00 
  802cfe:	ff d0                	callq  *%rax
  802d00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d07:	79 05                	jns    802d0e <write+0x5d>
		return r;
  802d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0c:	eb 75                	jmp    802d83 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d12:	8b 40 08             	mov    0x8(%rax),%eax
  802d15:	83 e0 03             	and    $0x3,%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	75 3a                	jne    802d56 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d1c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d23:	00 00 00 
  802d26:	48 8b 00             	mov    (%rax),%rax
  802d29:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d32:	89 c6                	mov    %eax,%esi
  802d34:	48 bf 73 4f 80 00 00 	movabs $0x804f73,%rdi
  802d3b:	00 00 00 
  802d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d43:	48 b9 ae 04 80 00 00 	movabs $0x8004ae,%rcx
  802d4a:	00 00 00 
  802d4d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d54:	eb 2d                	jmp    802d83 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d5e:	48 85 c0             	test   %rax,%rax
  802d61:	75 07                	jne    802d6a <write+0xb9>
		return -E_NOT_SUPP;
  802d63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d68:	eb 19                	jmp    802d83 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d72:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d7a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d7e:	48 89 cf             	mov    %rcx,%rdi
  802d81:	ff d0                	callq  *%rax
}
  802d83:	c9                   	leaveq 
  802d84:	c3                   	retq   

0000000000802d85 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d85:	55                   	push   %rbp
  802d86:	48 89 e5             	mov    %rsp,%rbp
  802d89:	48 83 ec 18          	sub    $0x18,%rsp
  802d8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d90:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d93:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d9a:	48 89 d6             	mov    %rdx,%rsi
  802d9d:	89 c7                	mov    %eax,%edi
  802d9f:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
  802dab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db2:	79 05                	jns    802db9 <seek+0x34>
		return r;
  802db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db7:	eb 0f                	jmp    802dc8 <seek+0x43>
	fd->fd_offset = offset;
  802db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802dc0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc8:	c9                   	leaveq 
  802dc9:	c3                   	retq   

0000000000802dca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802dca:	55                   	push   %rbp
  802dcb:	48 89 e5             	mov    %rsp,%rbp
  802dce:	48 83 ec 30          	sub    $0x30,%rsp
  802dd2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dd5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dd8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ddc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ddf:	48 89 d6             	mov    %rdx,%rsi
  802de2:	89 c7                	mov    %eax,%edi
  802de4:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
  802df0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df7:	78 24                	js     802e1d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802df9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfd:	8b 00                	mov    (%rax),%eax
  802dff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e03:	48 89 d6             	mov    %rdx,%rsi
  802e06:	89 c7                	mov    %eax,%edi
  802e08:	48 b8 8c 28 80 00 00 	movabs $0x80288c,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
  802e14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1b:	79 05                	jns    802e22 <ftruncate+0x58>
		return r;
  802e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e20:	eb 72                	jmp    802e94 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e26:	8b 40 08             	mov    0x8(%rax),%eax
  802e29:	83 e0 03             	and    $0x3,%eax
  802e2c:	85 c0                	test   %eax,%eax
  802e2e:	75 3a                	jne    802e6a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e30:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e37:	00 00 00 
  802e3a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e3d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e43:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e46:	89 c6                	mov    %eax,%esi
  802e48:	48 bf 90 4f 80 00 00 	movabs $0x804f90,%rdi
  802e4f:	00 00 00 
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
  802e57:	48 b9 ae 04 80 00 00 	movabs $0x8004ae,%rcx
  802e5e:	00 00 00 
  802e61:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e68:	eb 2a                	jmp    802e94 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e72:	48 85 c0             	test   %rax,%rax
  802e75:	75 07                	jne    802e7e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e77:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e7c:	eb 16                	jmp    802e94 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e82:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e8a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e8d:	89 ce                	mov    %ecx,%esi
  802e8f:	48 89 d7             	mov    %rdx,%rdi
  802e92:	ff d0                	callq  *%rax
}
  802e94:	c9                   	leaveq 
  802e95:	c3                   	retq   

0000000000802e96 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e96:	55                   	push   %rbp
  802e97:	48 89 e5             	mov    %rsp,%rbp
  802e9a:	48 83 ec 30          	sub    $0x30,%rsp
  802e9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ea1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ea5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ea9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802eac:	48 89 d6             	mov    %rdx,%rsi
  802eaf:	89 c7                	mov    %eax,%edi
  802eb1:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
  802ebd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec4:	78 24                	js     802eea <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ec6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eca:	8b 00                	mov    (%rax),%eax
  802ecc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ed0:	48 89 d6             	mov    %rdx,%rsi
  802ed3:	89 c7                	mov    %eax,%edi
  802ed5:	48 b8 8c 28 80 00 00 	movabs $0x80288c,%rax
  802edc:	00 00 00 
  802edf:	ff d0                	callq  *%rax
  802ee1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee8:	79 05                	jns    802eef <fstat+0x59>
		return r;
  802eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eed:	eb 5e                	jmp    802f4d <fstat+0xb7>
	if (!dev->dev_stat)
  802eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ef7:	48 85 c0             	test   %rax,%rax
  802efa:	75 07                	jne    802f03 <fstat+0x6d>
		return -E_NOT_SUPP;
  802efc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f01:	eb 4a                	jmp    802f4d <fstat+0xb7>
	stat->st_name[0] = 0;
  802f03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f07:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f0e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f15:	00 00 00 
	stat->st_isdir = 0;
  802f18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f1c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f23:	00 00 00 
	stat->st_dev = dev;
  802f26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f2e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f39:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f41:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f45:	48 89 ce             	mov    %rcx,%rsi
  802f48:	48 89 d7             	mov    %rdx,%rdi
  802f4b:	ff d0                	callq  *%rax
}
  802f4d:	c9                   	leaveq 
  802f4e:	c3                   	retq   

0000000000802f4f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f4f:	55                   	push   %rbp
  802f50:	48 89 e5             	mov    %rsp,%rbp
  802f53:	48 83 ec 20          	sub    $0x20,%rsp
  802f57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f63:	be 00 00 00 00       	mov    $0x0,%esi
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	48 b8 3f 30 80 00 00 	movabs $0x80303f,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
  802f77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7e:	79 05                	jns    802f85 <stat+0x36>
		return fd;
  802f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f83:	eb 2f                	jmp    802fb4 <stat+0x65>
	r = fstat(fd, stat);
  802f85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8c:	48 89 d6             	mov    %rdx,%rsi
  802f8f:	89 c7                	mov    %eax,%edi
  802f91:	48 b8 96 2e 80 00 00 	movabs $0x802e96,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
  802f9d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa3:	89 c7                	mov    %eax,%edi
  802fa5:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
	return r;
  802fb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fb4:	c9                   	leaveq 
  802fb5:	c3                   	retq   

0000000000802fb6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fb6:	55                   	push   %rbp
  802fb7:	48 89 e5             	mov    %rsp,%rbp
  802fba:	48 83 ec 10          	sub    $0x10,%rsp
  802fbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802fc5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fcc:	00 00 00 
  802fcf:	8b 00                	mov    (%rax),%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	75 1f                	jne    802ff4 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802fd5:	bf 01 00 00 00       	mov    $0x1,%edi
  802fda:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
  802fe6:	89 c2                	mov    %eax,%edx
  802fe8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fef:	00 00 00 
  802ff2:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ff4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ffb:	00 00 00 
  802ffe:	8b 00                	mov    (%rax),%eax
  803000:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803003:	b9 07 00 00 00       	mov    $0x7,%ecx
  803008:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80300f:	00 00 00 
  803012:	89 c7                	mov    %eax,%edi
  803014:	48 b8 45 25 80 00 00 	movabs $0x802545,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803024:	ba 00 00 00 00       	mov    $0x0,%edx
  803029:	48 89 c6             	mov    %rax,%rsi
  80302c:	bf 00 00 00 00       	mov    $0x0,%edi
  803031:	48 b8 84 24 80 00 00 	movabs $0x802484,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
}
  80303d:	c9                   	leaveq 
  80303e:	c3                   	retq   

000000000080303f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80303f:	55                   	push   %rbp
  803040:	48 89 e5             	mov    %rsp,%rbp
  803043:	48 83 ec 20          	sub    $0x20,%rsp
  803047:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80304b:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80304e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803052:	48 89 c7             	mov    %rax,%rdi
  803055:	48 b8 d2 0f 80 00 00 	movabs $0x800fd2,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803066:	7e 0a                	jle    803072 <open+0x33>
		return -E_BAD_PATH;
  803068:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80306d:	e9 a5 00 00 00       	jmpq   803117 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803072:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803076:	48 89 c7             	mov    %rax,%rdi
  803079:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
  803085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308c:	79 08                	jns    803096 <open+0x57>
		return r;
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	e9 81 00 00 00       	jmpq   803117 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309a:	48 89 c6             	mov    %rax,%rsi
  80309d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8030a4:	00 00 00 
  8030a7:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8030b3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030ba:	00 00 00 
  8030bd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030c0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8030c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ca:	48 89 c6             	mov    %rax,%rsi
  8030cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8030d2:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  8030d9:	00 00 00 
  8030dc:	ff d0                	callq  *%rax
  8030de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e5:	79 1d                	jns    803104 <open+0xc5>
		fd_close(fd, 0);
  8030e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030eb:	be 00 00 00 00       	mov    $0x0,%esi
  8030f0:	48 89 c7             	mov    %rax,%rdi
  8030f3:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
		return r;
  8030ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803102:	eb 13                	jmp    803117 <open+0xd8>
	}

	return fd2num(fd);
  803104:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803108:	48 89 c7             	mov    %rax,%rdi
  80310b:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  803112:	00 00 00 
  803115:	ff d0                	callq  *%rax

}
  803117:	c9                   	leaveq 
  803118:	c3                   	retq   

0000000000803119 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803119:	55                   	push   %rbp
  80311a:	48 89 e5             	mov    %rsp,%rbp
  80311d:	48 83 ec 10          	sub    $0x10,%rsp
  803121:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803129:	8b 50 0c             	mov    0xc(%rax),%edx
  80312c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803133:	00 00 00 
  803136:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803138:	be 00 00 00 00       	mov    $0x0,%esi
  80313d:	bf 06 00 00 00       	mov    $0x6,%edi
  803142:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  803149:	00 00 00 
  80314c:	ff d0                	callq  *%rax
}
  80314e:	c9                   	leaveq 
  80314f:	c3                   	retq   

0000000000803150 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803150:	55                   	push   %rbp
  803151:	48 89 e5             	mov    %rsp,%rbp
  803154:	48 83 ec 30          	sub    $0x30,%rsp
  803158:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80315c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803160:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803168:	8b 50 0c             	mov    0xc(%rax),%edx
  80316b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803172:	00 00 00 
  803175:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803177:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80317e:	00 00 00 
  803181:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803185:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803189:	be 00 00 00 00       	mov    $0x0,%esi
  80318e:	bf 03 00 00 00       	mov    $0x3,%edi
  803193:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
  80319f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a6:	79 08                	jns    8031b0 <devfile_read+0x60>
		return r;
  8031a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ab:	e9 a4 00 00 00       	jmpq   803254 <devfile_read+0x104>
	assert(r <= n);
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b3:	48 98                	cltq   
  8031b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8031b9:	76 35                	jbe    8031f0 <devfile_read+0xa0>
  8031bb:	48 b9 b6 4f 80 00 00 	movabs $0x804fb6,%rcx
  8031c2:	00 00 00 
  8031c5:	48 ba bd 4f 80 00 00 	movabs $0x804fbd,%rdx
  8031cc:	00 00 00 
  8031cf:	be 86 00 00 00       	mov    $0x86,%esi
  8031d4:	48 bf d2 4f 80 00 00 	movabs $0x804fd2,%rdi
  8031db:	00 00 00 
  8031de:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e3:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8031ea:	00 00 00 
  8031ed:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8031f0:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8031f7:	7e 35                	jle    80322e <devfile_read+0xde>
  8031f9:	48 b9 dd 4f 80 00 00 	movabs $0x804fdd,%rcx
  803200:	00 00 00 
  803203:	48 ba bd 4f 80 00 00 	movabs $0x804fbd,%rdx
  80320a:	00 00 00 
  80320d:	be 87 00 00 00       	mov    $0x87,%esi
  803212:	48 bf d2 4f 80 00 00 	movabs $0x804fd2,%rdi
  803219:	00 00 00 
  80321c:	b8 00 00 00 00       	mov    $0x0,%eax
  803221:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  803228:	00 00 00 
  80322b:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80322e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803231:	48 63 d0             	movslq %eax,%rdx
  803234:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803238:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80323f:	00 00 00 
  803242:	48 89 c7             	mov    %rax,%rdi
  803245:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
	return r;
  803251:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803254:	c9                   	leaveq 
  803255:	c3                   	retq   

0000000000803256 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803256:	55                   	push   %rbp
  803257:	48 89 e5             	mov    %rsp,%rbp
  80325a:	48 83 ec 40          	sub    $0x40,%rsp
  80325e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803262:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803266:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80326a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80326e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803272:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803279:	00 
  80327a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803282:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803287:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80328b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80328f:	8b 50 0c             	mov    0xc(%rax),%edx
  803292:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803299:	00 00 00 
  80329c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80329e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a5:	00 00 00 
  8032a8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8032ac:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8032b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8032b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b8:	48 89 c6             	mov    %rax,%rsi
  8032bb:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8032c2:	00 00 00 
  8032c5:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8032d1:	be 00 00 00 00       	mov    $0x0,%esi
  8032d6:	bf 04 00 00 00       	mov    $0x4,%edi
  8032db:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ee:	79 05                	jns    8032f5 <devfile_write+0x9f>
		return r;
  8032f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032f3:	eb 43                	jmp    803338 <devfile_write+0xe2>
	assert(r <= n);
  8032f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032f8:	48 98                	cltq   
  8032fa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032fe:	76 35                	jbe    803335 <devfile_write+0xdf>
  803300:	48 b9 b6 4f 80 00 00 	movabs $0x804fb6,%rcx
  803307:	00 00 00 
  80330a:	48 ba bd 4f 80 00 00 	movabs $0x804fbd,%rdx
  803311:	00 00 00 
  803314:	be a2 00 00 00       	mov    $0xa2,%esi
  803319:	48 bf d2 4f 80 00 00 	movabs $0x804fd2,%rdi
  803320:	00 00 00 
  803323:	b8 00 00 00 00       	mov    $0x0,%eax
  803328:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  80332f:	00 00 00 
  803332:	41 ff d0             	callq  *%r8
	return r;
  803335:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803338:	c9                   	leaveq 
  803339:	c3                   	retq   

000000000080333a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80333a:	55                   	push   %rbp
  80333b:	48 89 e5             	mov    %rsp,%rbp
  80333e:	48 83 ec 20          	sub    $0x20,%rsp
  803342:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	8b 50 0c             	mov    0xc(%rax),%edx
  803351:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803358:	00 00 00 
  80335b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80335d:	be 00 00 00 00       	mov    $0x0,%esi
  803362:	bf 05 00 00 00       	mov    $0x5,%edi
  803367:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337a:	79 05                	jns    803381 <devfile_stat+0x47>
		return r;
  80337c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337f:	eb 56                	jmp    8033d7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803385:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80338c:	00 00 00 
  80338f:	48 89 c7             	mov    %rax,%rdi
  803392:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80339e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a5:	00 00 00 
  8033a8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033b8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033bf:	00 00 00 
  8033c2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033cc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d7:	c9                   	leaveq 
  8033d8:	c3                   	retq   

00000000008033d9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033d9:	55                   	push   %rbp
  8033da:	48 89 e5             	mov    %rsp,%rbp
  8033dd:	48 83 ec 10          	sub    $0x10,%rsp
  8033e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033e5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033f6:	00 00 00 
  8033f9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8033fb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803402:	00 00 00 
  803405:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80340b:	be 00 00 00 00       	mov    $0x0,%esi
  803410:	bf 02 00 00 00       	mov    $0x2,%edi
  803415:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
}
  803421:	c9                   	leaveq 
  803422:	c3                   	retq   

0000000000803423 <remove>:

// Delete a file
int
remove(const char *path)
{
  803423:	55                   	push   %rbp
  803424:	48 89 e5             	mov    %rsp,%rbp
  803427:	48 83 ec 10          	sub    $0x10,%rsp
  80342b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80342f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 d2 0f 80 00 00 	movabs $0x800fd2,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803447:	7e 07                	jle    803450 <remove+0x2d>
		return -E_BAD_PATH;
  803449:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80344e:	eb 33                	jmp    803483 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803454:	48 89 c6             	mov    %rax,%rsi
  803457:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80345e:	00 00 00 
  803461:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  803468:	00 00 00 
  80346b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80346d:	be 00 00 00 00       	mov    $0x0,%esi
  803472:	bf 07 00 00 00       	mov    $0x7,%edi
  803477:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
}
  803483:	c9                   	leaveq 
  803484:	c3                   	retq   

0000000000803485 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803485:	55                   	push   %rbp
  803486:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803489:	be 00 00 00 00       	mov    $0x0,%esi
  80348e:	bf 08 00 00 00       	mov    $0x8,%edi
  803493:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
}
  80349f:	5d                   	pop    %rbp
  8034a0:	c3                   	retq   

00000000008034a1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8034ac:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8034b3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8034ba:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8034c1:	be 00 00 00 00       	mov    $0x0,%esi
  8034c6:	48 89 c7             	mov    %rax,%rdi
  8034c9:	48 b8 3f 30 80 00 00 	movabs $0x80303f,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
  8034d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8034d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034dc:	79 28                	jns    803506 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8034de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e1:	89 c6                	mov    %eax,%esi
  8034e3:	48 bf e9 4f 80 00 00 	movabs $0x804fe9,%rdi
  8034ea:	00 00 00 
  8034ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f2:	48 ba ae 04 80 00 00 	movabs $0x8004ae,%rdx
  8034f9:	00 00 00 
  8034fc:	ff d2                	callq  *%rdx
		return fd_src;
  8034fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803501:	e9 76 01 00 00       	jmpq   80367c <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803506:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80350d:	be 01 01 00 00       	mov    $0x101,%esi
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 3f 30 80 00 00 	movabs $0x80303f,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
  803521:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803524:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803528:	0f 89 ad 00 00 00    	jns    8035db <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80352e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803531:	89 c6                	mov    %eax,%esi
  803533:	48 bf ff 4f 80 00 00 	movabs $0x804fff,%rdi
  80353a:	00 00 00 
  80353d:	b8 00 00 00 00       	mov    $0x0,%eax
  803542:	48 ba ae 04 80 00 00 	movabs $0x8004ae,%rdx
  803549:	00 00 00 
  80354c:	ff d2                	callq  *%rdx
		close(fd_src);
  80354e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803551:	89 c7                	mov    %eax,%edi
  803553:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
		return fd_dest;
  80355f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803562:	e9 15 01 00 00       	jmpq   80367c <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803567:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80356a:	48 63 d0             	movslq %eax,%rdx
  80356d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803574:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803577:	48 89 ce             	mov    %rcx,%rsi
  80357a:	89 c7                	mov    %eax,%edi
  80357c:	48 b8 b1 2c 80 00 00 	movabs $0x802cb1,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
  803588:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80358b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80358f:	79 4a                	jns    8035db <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803591:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803594:	89 c6                	mov    %eax,%esi
  803596:	48 bf 19 50 80 00 00 	movabs $0x805019,%rdi
  80359d:	00 00 00 
  8035a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a5:	48 ba ae 04 80 00 00 	movabs $0x8004ae,%rdx
  8035ac:	00 00 00 
  8035af:	ff d2                	callq  *%rdx
			close(fd_src);
  8035b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b4:	89 c7                	mov    %eax,%edi
  8035b6:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
			close(fd_dest);
  8035c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c5:	89 c7                	mov    %eax,%edi
  8035c7:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
			return write_size;
  8035d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035d6:	e9 a1 00 00 00       	jmpq   80367c <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035db:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e5:	ba 00 02 00 00       	mov    $0x200,%edx
  8035ea:	48 89 ce             	mov    %rcx,%rsi
  8035ed:	89 c7                	mov    %eax,%edi
  8035ef:	48 b8 66 2b 80 00 00 	movabs $0x802b66,%rax
  8035f6:	00 00 00 
  8035f9:	ff d0                	callq  *%rax
  8035fb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803602:	0f 8f 5f ff ff ff    	jg     803567 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803608:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80360c:	79 47                	jns    803655 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80360e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803611:	89 c6                	mov    %eax,%esi
  803613:	48 bf 2c 50 80 00 00 	movabs $0x80502c,%rdi
  80361a:	00 00 00 
  80361d:	b8 00 00 00 00       	mov    $0x0,%eax
  803622:	48 ba ae 04 80 00 00 	movabs $0x8004ae,%rdx
  803629:	00 00 00 
  80362c:	ff d2                	callq  *%rdx
		close(fd_src);
  80362e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803631:	89 c7                	mov    %eax,%edi
  803633:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  80363a:	00 00 00 
  80363d:	ff d0                	callq  *%rax
		close(fd_dest);
  80363f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803642:	89 c7                	mov    %eax,%edi
  803644:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  80364b:	00 00 00 
  80364e:	ff d0                	callq  *%rax
		return read_size;
  803650:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803653:	eb 27                	jmp    80367c <copy+0x1db>
	}
	close(fd_src);
  803655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803658:	89 c7                	mov    %eax,%edi
  80365a:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
	close(fd_dest);
  803666:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803669:	89 c7                	mov    %eax,%edi
  80366b:	48 b8 43 29 80 00 00 	movabs $0x802943,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
	return 0;
  803677:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80367c:	c9                   	leaveq 
  80367d:	c3                   	retq   

000000000080367e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80367e:	55                   	push   %rbp
  80367f:	48 89 e5             	mov    %rsp,%rbp
  803682:	48 83 ec 20          	sub    $0x20,%rsp
  803686:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803689:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80368d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803690:	48 89 d6             	mov    %rdx,%rsi
  803693:	89 c7                	mov    %eax,%edi
  803695:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
  8036a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a8:	79 05                	jns    8036af <fd2sockid+0x31>
		return r;
  8036aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ad:	eb 24                	jmp    8036d3 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b3:	8b 10                	mov    (%rax),%edx
  8036b5:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8036bc:	00 00 00 
  8036bf:	8b 00                	mov    (%rax),%eax
  8036c1:	39 c2                	cmp    %eax,%edx
  8036c3:	74 07                	je     8036cc <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8036c5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036ca:	eb 07                	jmp    8036d3 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8036cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d0:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8036d3:	c9                   	leaveq 
  8036d4:	c3                   	retq   

00000000008036d5 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8036d5:	55                   	push   %rbp
  8036d6:	48 89 e5             	mov    %rsp,%rbp
  8036d9:	48 83 ec 20          	sub    $0x20,%rsp
  8036dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036e0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036e4:	48 89 c7             	mov    %rax,%rdi
  8036e7:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
  8036f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036fa:	78 26                	js     803722 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803700:	ba 07 04 00 00       	mov    $0x407,%edx
  803705:	48 89 c6             	mov    %rax,%rsi
  803708:	bf 00 00 00 00       	mov    $0x0,%edi
  80370d:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
  803719:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803720:	79 16                	jns    803738 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803722:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803725:	89 c7                	mov    %eax,%edi
  803727:	48 b8 e4 3b 80 00 00 	movabs $0x803be4,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
		return r;
  803733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803736:	eb 3a                	jmp    803772 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373c:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803743:	00 00 00 
  803746:	8b 12                	mov    (%rdx),%edx
  803748:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80374a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803759:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80375c:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80375f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803763:	48 89 c7             	mov    %rax,%rdi
  803766:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
}
  803772:	c9                   	leaveq 
  803773:	c3                   	retq   

0000000000803774 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803774:	55                   	push   %rbp
  803775:	48 89 e5             	mov    %rsp,%rbp
  803778:	48 83 ec 30          	sub    $0x30,%rsp
  80377c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80377f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803783:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803787:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80378a:	89 c7                	mov    %eax,%edi
  80378c:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
  803798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379f:	79 05                	jns    8037a6 <accept+0x32>
		return r;
  8037a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a4:	eb 3b                	jmp    8037e1 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b1:	48 89 ce             	mov    %rcx,%rsi
  8037b4:	89 c7                	mov    %eax,%edi
  8037b6:	48 b8 c1 3a 80 00 00 	movabs $0x803ac1,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
  8037c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c9:	79 05                	jns    8037d0 <accept+0x5c>
		return r;
  8037cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ce:	eb 11                	jmp    8037e1 <accept+0x6d>
	return alloc_sockfd(r);
  8037d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d3:	89 c7                	mov    %eax,%edi
  8037d5:	48 b8 d5 36 80 00 00 	movabs $0x8036d5,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
}
  8037e1:	c9                   	leaveq 
  8037e2:	c3                   	retq   

00000000008037e3 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	48 83 ec 20          	sub    $0x20,%rsp
  8037eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f2:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f8:	89 c7                	mov    %eax,%edi
  8037fa:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
  803806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803809:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380d:	79 05                	jns    803814 <bind+0x31>
		return r;
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	eb 1b                	jmp    80382f <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803814:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803817:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80381b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381e:	48 89 ce             	mov    %rcx,%rsi
  803821:	89 c7                	mov    %eax,%edi
  803823:	48 b8 40 3b 80 00 00 	movabs $0x803b40,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
}
  80382f:	c9                   	leaveq 
  803830:	c3                   	retq   

0000000000803831 <shutdown>:

int
shutdown(int s, int how)
{
  803831:	55                   	push   %rbp
  803832:	48 89 e5             	mov    %rsp,%rbp
  803835:	48 83 ec 20          	sub    $0x20,%rsp
  803839:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80383c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80383f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803842:	89 c7                	mov    %eax,%edi
  803844:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  80384b:	00 00 00 
  80384e:	ff d0                	callq  *%rax
  803850:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803853:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803857:	79 05                	jns    80385e <shutdown+0x2d>
		return r;
  803859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385c:	eb 16                	jmp    803874 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80385e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803864:	89 d6                	mov    %edx,%esi
  803866:	89 c7                	mov    %eax,%edi
  803868:	48 b8 a4 3b 80 00 00 	movabs $0x803ba4,%rax
  80386f:	00 00 00 
  803872:	ff d0                	callq  *%rax
}
  803874:	c9                   	leaveq 
  803875:	c3                   	retq   

0000000000803876 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803876:	55                   	push   %rbp
  803877:	48 89 e5             	mov    %rsp,%rbp
  80387a:	48 83 ec 10          	sub    $0x10,%rsp
  80387e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803886:	48 89 c7             	mov    %rax,%rdi
  803889:	48 b8 22 48 80 00 00 	movabs $0x804822,%rax
  803890:	00 00 00 
  803893:	ff d0                	callq  *%rax
  803895:	83 f8 01             	cmp    $0x1,%eax
  803898:	75 17                	jne    8038b1 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80389a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389e:	8b 40 0c             	mov    0xc(%rax),%eax
  8038a1:	89 c7                	mov    %eax,%edi
  8038a3:	48 b8 e4 3b 80 00 00 	movabs $0x803be4,%rax
  8038aa:	00 00 00 
  8038ad:	ff d0                	callq  *%rax
  8038af:	eb 05                	jmp    8038b6 <devsock_close+0x40>
	else
		return 0;
  8038b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038b6:	c9                   	leaveq 
  8038b7:	c3                   	retq   

00000000008038b8 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038b8:	55                   	push   %rbp
  8038b9:	48 89 e5             	mov    %rsp,%rbp
  8038bc:	48 83 ec 20          	sub    $0x20,%rsp
  8038c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038cd:	89 c7                	mov    %eax,%edi
  8038cf:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e2:	79 05                	jns    8038e9 <connect+0x31>
		return r;
  8038e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e7:	eb 1b                	jmp    803904 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038ec:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f3:	48 89 ce             	mov    %rcx,%rsi
  8038f6:	89 c7                	mov    %eax,%edi
  8038f8:	48 b8 11 3c 80 00 00 	movabs $0x803c11,%rax
  8038ff:	00 00 00 
  803902:	ff d0                	callq  *%rax
}
  803904:	c9                   	leaveq 
  803905:	c3                   	retq   

0000000000803906 <listen>:

int
listen(int s, int backlog)
{
  803906:	55                   	push   %rbp
  803907:	48 89 e5             	mov    %rsp,%rbp
  80390a:	48 83 ec 20          	sub    $0x20,%rsp
  80390e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803911:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803914:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803917:	89 c7                	mov    %eax,%edi
  803919:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
  803925:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803928:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392c:	79 05                	jns    803933 <listen+0x2d>
		return r;
  80392e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803931:	eb 16                	jmp    803949 <listen+0x43>
	return nsipc_listen(r, backlog);
  803933:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803939:	89 d6                	mov    %edx,%esi
  80393b:	89 c7                	mov    %eax,%edi
  80393d:	48 b8 75 3c 80 00 00 	movabs $0x803c75,%rax
  803944:	00 00 00 
  803947:	ff d0                	callq  *%rax
}
  803949:	c9                   	leaveq 
  80394a:	c3                   	retq   

000000000080394b <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80394b:	55                   	push   %rbp
  80394c:	48 89 e5             	mov    %rsp,%rbp
  80394f:	48 83 ec 20          	sub    $0x20,%rsp
  803953:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803957:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80395b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80395f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803963:	89 c2                	mov    %eax,%edx
  803965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803969:	8b 40 0c             	mov    0xc(%rax),%eax
  80396c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803970:	b9 00 00 00 00       	mov    $0x0,%ecx
  803975:	89 c7                	mov    %eax,%edi
  803977:	48 b8 b5 3c 80 00 00 	movabs $0x803cb5,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
}
  803983:	c9                   	leaveq 
  803984:	c3                   	retq   

0000000000803985 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803985:	55                   	push   %rbp
  803986:	48 89 e5             	mov    %rsp,%rbp
  803989:	48 83 ec 20          	sub    $0x20,%rsp
  80398d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803991:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803995:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399d:	89 c2                	mov    %eax,%edx
  80399f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a3:	8b 40 0c             	mov    0xc(%rax),%eax
  8039a6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039af:	89 c7                	mov    %eax,%edi
  8039b1:	48 b8 81 3d 80 00 00 	movabs $0x803d81,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
}
  8039bd:	c9                   	leaveq 
  8039be:	c3                   	retq   

00000000008039bf <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039bf:	55                   	push   %rbp
  8039c0:	48 89 e5             	mov    %rsp,%rbp
  8039c3:	48 83 ec 10          	sub    $0x10,%rsp
  8039c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8039cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d3:	48 be 47 50 80 00 00 	movabs $0x805047,%rsi
  8039da:	00 00 00 
  8039dd:	48 89 c7             	mov    %rax,%rdi
  8039e0:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8039e7:	00 00 00 
  8039ea:	ff d0                	callq  *%rax
	return 0;
  8039ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f1:	c9                   	leaveq 
  8039f2:	c3                   	retq   

00000000008039f3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8039f3:	55                   	push   %rbp
  8039f4:	48 89 e5             	mov    %rsp,%rbp
  8039f7:	48 83 ec 20          	sub    $0x20,%rsp
  8039fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039fe:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a01:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a04:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a07:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a0d:	89 ce                	mov    %ecx,%esi
  803a0f:	89 c7                	mov    %eax,%edi
  803a11:	48 b8 39 3e 80 00 00 	movabs $0x803e39,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a24:	79 05                	jns    803a2b <socket+0x38>
		return r;
  803a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a29:	eb 11                	jmp    803a3c <socket+0x49>
	return alloc_sockfd(r);
  803a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2e:	89 c7                	mov    %eax,%edi
  803a30:	48 b8 d5 36 80 00 00 	movabs $0x8036d5,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
}
  803a3c:	c9                   	leaveq 
  803a3d:	c3                   	retq   

0000000000803a3e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a3e:	55                   	push   %rbp
  803a3f:	48 89 e5             	mov    %rsp,%rbp
  803a42:	48 83 ec 10          	sub    $0x10,%rsp
  803a46:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a49:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a50:	00 00 00 
  803a53:	8b 00                	mov    (%rax),%eax
  803a55:	85 c0                	test   %eax,%eax
  803a57:	75 1f                	jne    803a78 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a59:	bf 02 00 00 00       	mov    $0x2,%edi
  803a5e:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
  803a6a:	89 c2                	mov    %eax,%edx
  803a6c:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a73:	00 00 00 
  803a76:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a78:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a7f:	00 00 00 
  803a82:	8b 00                	mov    (%rax),%eax
  803a84:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a87:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a8c:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a93:	00 00 00 
  803a96:	89 c7                	mov    %eax,%edi
  803a98:	48 b8 45 25 80 00 00 	movabs $0x802545,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803aa4:	ba 00 00 00 00       	mov    $0x0,%edx
  803aa9:	be 00 00 00 00       	mov    $0x0,%esi
  803aae:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab3:	48 b8 84 24 80 00 00 	movabs $0x802484,%rax
  803aba:	00 00 00 
  803abd:	ff d0                	callq  *%rax
}
  803abf:	c9                   	leaveq 
  803ac0:	c3                   	retq   

0000000000803ac1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ac1:	55                   	push   %rbp
  803ac2:	48 89 e5             	mov    %rsp,%rbp
  803ac5:	48 83 ec 30          	sub    $0x30,%rsp
  803ac9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803acc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ad0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ad4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803adb:	00 00 00 
  803ade:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ae1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ae3:	bf 01 00 00 00       	mov    $0x1,%edi
  803ae8:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803aef:	00 00 00 
  803af2:	ff d0                	callq  *%rax
  803af4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803afb:	78 3e                	js     803b3b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803afd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b04:	00 00 00 
  803b07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0f:	8b 40 10             	mov    0x10(%rax),%eax
  803b12:	89 c2                	mov    %eax,%edx
  803b14:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1c:	48 89 ce             	mov    %rcx,%rsi
  803b1f:	48 89 c7             	mov    %rax,%rdi
  803b22:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b32:	8b 50 10             	mov    0x10(%rax),%edx
  803b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b39:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b3e:	c9                   	leaveq 
  803b3f:	c3                   	retq   

0000000000803b40 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b40:	55                   	push   %rbp
  803b41:	48 89 e5             	mov    %rsp,%rbp
  803b44:	48 83 ec 10          	sub    $0x10,%rsp
  803b48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b4f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b52:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b59:	00 00 00 
  803b5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b5f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b61:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b68:	48 89 c6             	mov    %rax,%rsi
  803b6b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b72:	00 00 00 
  803b75:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  803b7c:	00 00 00 
  803b7f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b81:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b88:	00 00 00 
  803b8b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b8e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b91:	bf 02 00 00 00       	mov    $0x2,%edi
  803b96:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803b9d:	00 00 00 
  803ba0:	ff d0                	callq  *%rax
}
  803ba2:	c9                   	leaveq 
  803ba3:	c3                   	retq   

0000000000803ba4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ba4:	55                   	push   %rbp
  803ba5:	48 89 e5             	mov    %rsp,%rbp
  803ba8:	48 83 ec 10          	sub    $0x10,%rsp
  803bac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803baf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803bb2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb9:	00 00 00 
  803bbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bbf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803bc1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc8:	00 00 00 
  803bcb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bce:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803bd1:	bf 03 00 00 00       	mov    $0x3,%edi
  803bd6:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803bdd:	00 00 00 
  803be0:	ff d0                	callq  *%rax
}
  803be2:	c9                   	leaveq 
  803be3:	c3                   	retq   

0000000000803be4 <nsipc_close>:

int
nsipc_close(int s)
{
  803be4:	55                   	push   %rbp
  803be5:	48 89 e5             	mov    %rsp,%rbp
  803be8:	48 83 ec 10          	sub    $0x10,%rsp
  803bec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803bef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf6:	00 00 00 
  803bf9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bfc:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803bfe:	bf 04 00 00 00       	mov    $0x4,%edi
  803c03:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803c0a:	00 00 00 
  803c0d:	ff d0                	callq  *%rax
}
  803c0f:	c9                   	leaveq 
  803c10:	c3                   	retq   

0000000000803c11 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c11:	55                   	push   %rbp
  803c12:	48 89 e5             	mov    %rsp,%rbp
  803c15:	48 83 ec 10          	sub    $0x10,%rsp
  803c19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c20:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c2a:	00 00 00 
  803c2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c30:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c32:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c39:	48 89 c6             	mov    %rax,%rsi
  803c3c:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c43:	00 00 00 
  803c46:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c52:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c59:	00 00 00 
  803c5c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c5f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c62:	bf 05 00 00 00       	mov    $0x5,%edi
  803c67:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
}
  803c73:	c9                   	leaveq 
  803c74:	c3                   	retq   

0000000000803c75 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c75:	55                   	push   %rbp
  803c76:	48 89 e5             	mov    %rsp,%rbp
  803c79:	48 83 ec 10          	sub    $0x10,%rsp
  803c7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c80:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c83:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c8a:	00 00 00 
  803c8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c90:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c99:	00 00 00 
  803c9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c9f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ca2:	bf 06 00 00 00       	mov    $0x6,%edi
  803ca7:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803cae:	00 00 00 
  803cb1:	ff d0                	callq  *%rax
}
  803cb3:	c9                   	leaveq 
  803cb4:	c3                   	retq   

0000000000803cb5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cb5:	55                   	push   %rbp
  803cb6:	48 89 e5             	mov    %rsp,%rbp
  803cb9:	48 83 ec 30          	sub    $0x30,%rsp
  803cbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cc4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803cc7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803cca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cd1:	00 00 00 
  803cd4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cd7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803cd9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce0:	00 00 00 
  803ce3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ce6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ce9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf0:	00 00 00 
  803cf3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803cf6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803cf9:	bf 07 00 00 00       	mov    $0x7,%edi
  803cfe:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d11:	78 69                	js     803d7c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d13:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d1a:	7f 08                	jg     803d24 <nsipc_recv+0x6f>
  803d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d22:	7e 35                	jle    803d59 <nsipc_recv+0xa4>
  803d24:	48 b9 4e 50 80 00 00 	movabs $0x80504e,%rcx
  803d2b:	00 00 00 
  803d2e:	48 ba 63 50 80 00 00 	movabs $0x805063,%rdx
  803d35:	00 00 00 
  803d38:	be 62 00 00 00       	mov    $0x62,%esi
  803d3d:	48 bf 78 50 80 00 00 	movabs $0x805078,%rdi
  803d44:	00 00 00 
  803d47:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4c:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  803d53:	00 00 00 
  803d56:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5c:	48 63 d0             	movslq %eax,%rdx
  803d5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d63:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d6a:	00 00 00 
  803d6d:	48 89 c7             	mov    %rax,%rdi
  803d70:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  803d77:	00 00 00 
  803d7a:	ff d0                	callq  *%rax
	}

	return r;
  803d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d7f:	c9                   	leaveq 
  803d80:	c3                   	retq   

0000000000803d81 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d81:	55                   	push   %rbp
  803d82:	48 89 e5             	mov    %rsp,%rbp
  803d85:	48 83 ec 20          	sub    $0x20,%rsp
  803d89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d90:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d93:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d96:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9d:	00 00 00 
  803da0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803da3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803da5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803dac:	7e 35                	jle    803de3 <nsipc_send+0x62>
  803dae:	48 b9 84 50 80 00 00 	movabs $0x805084,%rcx
  803db5:	00 00 00 
  803db8:	48 ba 63 50 80 00 00 	movabs $0x805063,%rdx
  803dbf:	00 00 00 
  803dc2:	be 6d 00 00 00       	mov    $0x6d,%esi
  803dc7:	48 bf 78 50 80 00 00 	movabs $0x805078,%rdi
  803dce:	00 00 00 
  803dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd6:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  803ddd:	00 00 00 
  803de0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803de3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de6:	48 63 d0             	movslq %eax,%rdx
  803de9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ded:	48 89 c6             	mov    %rax,%rsi
  803df0:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803df7:	00 00 00 
  803dfa:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0d:	00 00 00 
  803e10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e13:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e16:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e1d:	00 00 00 
  803e20:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e23:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e26:	bf 08 00 00 00       	mov    $0x8,%edi
  803e2b:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803e32:	00 00 00 
  803e35:	ff d0                	callq  *%rax
}
  803e37:	c9                   	leaveq 
  803e38:	c3                   	retq   

0000000000803e39 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e39:	55                   	push   %rbp
  803e3a:	48 89 e5             	mov    %rsp,%rbp
  803e3d:	48 83 ec 10          	sub    $0x10,%rsp
  803e41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e44:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e47:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e4a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e51:	00 00 00 
  803e54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e57:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e59:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e60:	00 00 00 
  803e63:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e66:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e69:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e70:	00 00 00 
  803e73:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e76:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e79:	bf 09 00 00 00       	mov    $0x9,%edi
  803e7e:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803e85:	00 00 00 
  803e88:	ff d0                	callq  *%rax
}
  803e8a:	c9                   	leaveq 
  803e8b:	c3                   	retq   

0000000000803e8c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e8c:	55                   	push   %rbp
  803e8d:	48 89 e5             	mov    %rsp,%rbp
  803e90:	53                   	push   %rbx
  803e91:	48 83 ec 38          	sub    $0x38,%rsp
  803e95:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e99:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e9d:	48 89 c7             	mov    %rax,%rdi
  803ea0:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb3:	0f 88 bf 01 00 00    	js     804078 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ebd:	ba 07 04 00 00       	mov    $0x407,%edx
  803ec2:	48 89 c6             	mov    %rax,%rsi
  803ec5:	bf 00 00 00 00       	mov    $0x0,%edi
  803eca:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803ed1:	00 00 00 
  803ed4:	ff d0                	callq  *%rax
  803ed6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ed9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803edd:	0f 88 95 01 00 00    	js     804078 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803ee3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ee7:	48 89 c7             	mov    %rax,%rdi
  803eea:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  803ef1:	00 00 00 
  803ef4:	ff d0                	callq  *%rax
  803ef6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803efd:	0f 88 5d 01 00 00    	js     804060 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f07:	ba 07 04 00 00       	mov    $0x407,%edx
  803f0c:	48 89 c6             	mov    %rax,%rsi
  803f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f14:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803f1b:	00 00 00 
  803f1e:	ff d0                	callq  *%rax
  803f20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f27:	0f 88 33 01 00 00    	js     804060 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f31:	48 89 c7             	mov    %rax,%rdi
  803f34:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  803f3b:	00 00 00 
  803f3e:	ff d0                	callq  *%rax
  803f40:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f48:	ba 07 04 00 00       	mov    $0x407,%edx
  803f4d:	48 89 c6             	mov    %rax,%rsi
  803f50:	bf 00 00 00 00       	mov    $0x0,%edi
  803f55:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803f5c:	00 00 00 
  803f5f:	ff d0                	callq  *%rax
  803f61:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f64:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f68:	0f 88 d9 00 00 00    	js     804047 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f72:	48 89 c7             	mov    %rax,%rdi
  803f75:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  803f7c:	00 00 00 
  803f7f:	ff d0                	callq  *%rax
  803f81:	48 89 c2             	mov    %rax,%rdx
  803f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f88:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f8e:	48 89 d1             	mov    %rdx,%rcx
  803f91:	ba 00 00 00 00       	mov    $0x0,%edx
  803f96:	48 89 c6             	mov    %rax,%rsi
  803f99:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9e:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  803fa5:	00 00 00 
  803fa8:	ff d0                	callq  *%rax
  803faa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fb1:	78 79                	js     80402c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803fb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb7:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fbe:	00 00 00 
  803fc1:	8b 12                	mov    (%rdx),%edx
  803fc3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803fc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd4:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fdb:	00 00 00 
  803fde:	8b 12                	mov    (%rdx),%edx
  803fe0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803fe2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff1:	48 89 c7             	mov    %rax,%rdi
  803ff4:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  803ffb:	00 00 00 
  803ffe:	ff d0                	callq  *%rax
  804000:	89 c2                	mov    %eax,%edx
  804002:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804006:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804008:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80400c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804010:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804014:	48 89 c7             	mov    %rax,%rdi
  804017:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  80401e:	00 00 00 
  804021:	ff d0                	callq  *%rax
  804023:	89 03                	mov    %eax,(%rbx)
	return 0;
  804025:	b8 00 00 00 00       	mov    $0x0,%eax
  80402a:	eb 4f                	jmp    80407b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80402c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80402d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804031:	48 89 c6             	mov    %rax,%rsi
  804034:	bf 00 00 00 00       	mov    $0x0,%edi
  804039:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	eb 01                	jmp    804048 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804047:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804048:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404c:	48 89 c6             	mov    %rax,%rsi
  80404f:	bf 00 00 00 00       	mov    $0x0,%edi
  804054:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  80405b:	00 00 00 
  80405e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804060:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804064:	48 89 c6             	mov    %rax,%rsi
  804067:	bf 00 00 00 00       	mov    $0x0,%edi
  80406c:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  804073:	00 00 00 
  804076:	ff d0                	callq  *%rax
err:
	return r;
  804078:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80407b:	48 83 c4 38          	add    $0x38,%rsp
  80407f:	5b                   	pop    %rbx
  804080:	5d                   	pop    %rbp
  804081:	c3                   	retq   

0000000000804082 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804082:	55                   	push   %rbp
  804083:	48 89 e5             	mov    %rsp,%rbp
  804086:	53                   	push   %rbx
  804087:	48 83 ec 28          	sub    $0x28,%rsp
  80408b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80408f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804093:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80409a:	00 00 00 
  80409d:	48 8b 00             	mov    (%rax),%rax
  8040a0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8040a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040ad:	48 89 c7             	mov    %rax,%rdi
  8040b0:	48 b8 22 48 80 00 00 	movabs $0x804822,%rax
  8040b7:	00 00 00 
  8040ba:	ff d0                	callq  *%rax
  8040bc:	89 c3                	mov    %eax,%ebx
  8040be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c2:	48 89 c7             	mov    %rax,%rdi
  8040c5:	48 b8 22 48 80 00 00 	movabs $0x804822,%rax
  8040cc:	00 00 00 
  8040cf:	ff d0                	callq  *%rax
  8040d1:	39 c3                	cmp    %eax,%ebx
  8040d3:	0f 94 c0             	sete   %al
  8040d6:	0f b6 c0             	movzbl %al,%eax
  8040d9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040dc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8040e3:	00 00 00 
  8040e6:	48 8b 00             	mov    (%rax),%rax
  8040e9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040ef:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040f5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040f8:	75 05                	jne    8040ff <_pipeisclosed+0x7d>
			return ret;
  8040fa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040fd:	eb 4a                	jmp    804149 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8040ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804102:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804105:	74 8c                	je     804093 <_pipeisclosed+0x11>
  804107:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80410b:	75 86                	jne    804093 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80410d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804114:	00 00 00 
  804117:	48 8b 00             	mov    (%rax),%rax
  80411a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804120:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804123:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804126:	89 c6                	mov    %eax,%esi
  804128:	48 bf 95 50 80 00 00 	movabs $0x805095,%rdi
  80412f:	00 00 00 
  804132:	b8 00 00 00 00       	mov    $0x0,%eax
  804137:	49 b8 ae 04 80 00 00 	movabs $0x8004ae,%r8
  80413e:	00 00 00 
  804141:	41 ff d0             	callq  *%r8
	}
  804144:	e9 4a ff ff ff       	jmpq   804093 <_pipeisclosed+0x11>

}
  804149:	48 83 c4 28          	add    $0x28,%rsp
  80414d:	5b                   	pop    %rbx
  80414e:	5d                   	pop    %rbp
  80414f:	c3                   	retq   

0000000000804150 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804150:	55                   	push   %rbp
  804151:	48 89 e5             	mov    %rsp,%rbp
  804154:	48 83 ec 30          	sub    $0x30,%rsp
  804158:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80415b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80415f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804162:	48 89 d6             	mov    %rdx,%rsi
  804165:	89 c7                	mov    %eax,%edi
  804167:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  80416e:	00 00 00 
  804171:	ff d0                	callq  *%rax
  804173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80417a:	79 05                	jns    804181 <pipeisclosed+0x31>
		return r;
  80417c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417f:	eb 31                	jmp    8041b2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804185:	48 89 c7             	mov    %rax,%rdi
  804188:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  80418f:	00 00 00 
  804192:	ff d0                	callq  *%rax
  804194:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041a0:	48 89 d6             	mov    %rdx,%rsi
  8041a3:	48 89 c7             	mov    %rax,%rdi
  8041a6:	48 b8 82 40 80 00 00 	movabs $0x804082,%rax
  8041ad:	00 00 00 
  8041b0:	ff d0                	callq  *%rax
}
  8041b2:	c9                   	leaveq 
  8041b3:	c3                   	retq   

00000000008041b4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041b4:	55                   	push   %rbp
  8041b5:	48 89 e5             	mov    %rsp,%rbp
  8041b8:	48 83 ec 40          	sub    $0x40,%rsp
  8041bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041c4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8041c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cc:	48 89 c7             	mov    %rax,%rdi
  8041cf:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  8041d6:	00 00 00 
  8041d9:	ff d0                	callq  *%rax
  8041db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041e7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041ee:	00 
  8041ef:	e9 90 00 00 00       	jmpq   804284 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041f4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041f9:	74 09                	je     804204 <devpipe_read+0x50>
				return i;
  8041fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ff:	e9 8e 00 00 00       	jmpq   804292 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804204:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80420c:	48 89 d6             	mov    %rdx,%rsi
  80420f:	48 89 c7             	mov    %rax,%rdi
  804212:	48 b8 82 40 80 00 00 	movabs $0x804082,%rax
  804219:	00 00 00 
  80421c:	ff d0                	callq  *%rax
  80421e:	85 c0                	test   %eax,%eax
  804220:	74 07                	je     804229 <devpipe_read+0x75>
				return 0;
  804222:	b8 00 00 00 00       	mov    $0x0,%eax
  804227:	eb 69                	jmp    804292 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804229:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  804230:	00 00 00 
  804233:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804239:	8b 10                	mov    (%rax),%edx
  80423b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423f:	8b 40 04             	mov    0x4(%rax),%eax
  804242:	39 c2                	cmp    %eax,%edx
  804244:	74 ae                	je     8041f4 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804246:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80424a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804256:	8b 00                	mov    (%rax),%eax
  804258:	99                   	cltd   
  804259:	c1 ea 1b             	shr    $0x1b,%edx
  80425c:	01 d0                	add    %edx,%eax
  80425e:	83 e0 1f             	and    $0x1f,%eax
  804261:	29 d0                	sub    %edx,%eax
  804263:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804267:	48 98                	cltq   
  804269:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80426e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804274:	8b 00                	mov    (%rax),%eax
  804276:	8d 50 01             	lea    0x1(%rax),%edx
  804279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80427d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80427f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804288:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80428c:	72 a7                	jb     804235 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80428e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804292:	c9                   	leaveq 
  804293:	c3                   	retq   

0000000000804294 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804294:	55                   	push   %rbp
  804295:	48 89 e5             	mov    %rsp,%rbp
  804298:	48 83 ec 40          	sub    $0x40,%rsp
  80429c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8042a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042ac:	48 89 c7             	mov    %rax,%rdi
  8042af:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  8042b6:	00 00 00 
  8042b9:	ff d0                	callq  *%rax
  8042bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042ce:	00 
  8042cf:	e9 8f 00 00 00       	jmpq   804363 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042dc:	48 89 d6             	mov    %rdx,%rsi
  8042df:	48 89 c7             	mov    %rax,%rdi
  8042e2:	48 b8 82 40 80 00 00 	movabs $0x804082,%rax
  8042e9:	00 00 00 
  8042ec:	ff d0                	callq  *%rax
  8042ee:	85 c0                	test   %eax,%eax
  8042f0:	74 07                	je     8042f9 <devpipe_write+0x65>
				return 0;
  8042f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f7:	eb 78                	jmp    804371 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8042f9:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  804300:	00 00 00 
  804303:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804309:	8b 40 04             	mov    0x4(%rax),%eax
  80430c:	48 63 d0             	movslq %eax,%rdx
  80430f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804313:	8b 00                	mov    (%rax),%eax
  804315:	48 98                	cltq   
  804317:	48 83 c0 20          	add    $0x20,%rax
  80431b:	48 39 c2             	cmp    %rax,%rdx
  80431e:	73 b4                	jae    8042d4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804324:	8b 40 04             	mov    0x4(%rax),%eax
  804327:	99                   	cltd   
  804328:	c1 ea 1b             	shr    $0x1b,%edx
  80432b:	01 d0                	add    %edx,%eax
  80432d:	83 e0 1f             	and    $0x1f,%eax
  804330:	29 d0                	sub    %edx,%eax
  804332:	89 c6                	mov    %eax,%esi
  804334:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80433c:	48 01 d0             	add    %rdx,%rax
  80433f:	0f b6 08             	movzbl (%rax),%ecx
  804342:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804346:	48 63 c6             	movslq %esi,%rax
  804349:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80434d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804351:	8b 40 04             	mov    0x4(%rax),%eax
  804354:	8d 50 01             	lea    0x1(%rax),%edx
  804357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80435b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80435e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804367:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80436b:	72 98                	jb     804305 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80436d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804371:	c9                   	leaveq 
  804372:	c3                   	retq   

0000000000804373 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804373:	55                   	push   %rbp
  804374:	48 89 e5             	mov    %rsp,%rbp
  804377:	48 83 ec 20          	sub    $0x20,%rsp
  80437b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80437f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804387:	48 89 c7             	mov    %rax,%rdi
  80438a:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  804391:	00 00 00 
  804394:	ff d0                	callq  *%rax
  804396:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80439a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80439e:	48 be a8 50 80 00 00 	movabs $0x8050a8,%rsi
  8043a5:	00 00 00 
  8043a8:	48 89 c7             	mov    %rax,%rdi
  8043ab:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8043b2:	00 00 00 
  8043b5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8043b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043bb:	8b 50 04             	mov    0x4(%rax),%edx
  8043be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c2:	8b 00                	mov    (%rax),%eax
  8043c4:	29 c2                	sub    %eax,%edx
  8043c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ca:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043db:	00 00 00 
	stat->st_dev = &devpipe;
  8043de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e2:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8043e9:	00 00 00 
  8043ec:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8043f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043f8:	c9                   	leaveq 
  8043f9:	c3                   	retq   

00000000008043fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8043fa:	55                   	push   %rbp
  8043fb:	48 89 e5             	mov    %rsp,%rbp
  8043fe:	48 83 ec 10          	sub    $0x10,%rsp
  804402:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80440a:	48 89 c6             	mov    %rax,%rsi
  80440d:	bf 00 00 00 00       	mov    $0x0,%edi
  804412:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  804419:	00 00 00 
  80441c:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80441e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804422:	48 89 c7             	mov    %rax,%rdi
  804425:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  80442c:	00 00 00 
  80442f:	ff d0                	callq  *%rax
  804431:	48 89 c6             	mov    %rax,%rsi
  804434:	bf 00 00 00 00       	mov    $0x0,%edi
  804439:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  804440:	00 00 00 
  804443:	ff d0                	callq  *%rax
}
  804445:	c9                   	leaveq 
  804446:	c3                   	retq   

0000000000804447 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804447:	55                   	push   %rbp
  804448:	48 89 e5             	mov    %rsp,%rbp
  80444b:	48 83 ec 20          	sub    $0x20,%rsp
  80444f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804452:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804455:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804458:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80445c:	be 01 00 00 00       	mov    $0x1,%esi
  804461:	48 89 c7             	mov    %rax,%rdi
  804464:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  80446b:	00 00 00 
  80446e:	ff d0                	callq  *%rax
}
  804470:	90                   	nop
  804471:	c9                   	leaveq 
  804472:	c3                   	retq   

0000000000804473 <getchar>:

int
getchar(void)
{
  804473:	55                   	push   %rbp
  804474:	48 89 e5             	mov    %rsp,%rbp
  804477:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80447b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80447f:	ba 01 00 00 00       	mov    $0x1,%edx
  804484:	48 89 c6             	mov    %rax,%rsi
  804487:	bf 00 00 00 00       	mov    $0x0,%edi
  80448c:	48 b8 66 2b 80 00 00 	movabs $0x802b66,%rax
  804493:	00 00 00 
  804496:	ff d0                	callq  *%rax
  804498:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80449b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80449f:	79 05                	jns    8044a6 <getchar+0x33>
		return r;
  8044a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a4:	eb 14                	jmp    8044ba <getchar+0x47>
	if (r < 1)
  8044a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044aa:	7f 07                	jg     8044b3 <getchar+0x40>
		return -E_EOF;
  8044ac:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8044b1:	eb 07                	jmp    8044ba <getchar+0x47>
	return c;
  8044b3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8044b7:	0f b6 c0             	movzbl %al,%eax

}
  8044ba:	c9                   	leaveq 
  8044bb:	c3                   	retq   

00000000008044bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8044bc:	55                   	push   %rbp
  8044bd:	48 89 e5             	mov    %rsp,%rbp
  8044c0:	48 83 ec 20          	sub    $0x20,%rsp
  8044c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8044cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044ce:	48 89 d6             	mov    %rdx,%rsi
  8044d1:	89 c7                	mov    %eax,%edi
  8044d3:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  8044da:	00 00 00 
  8044dd:	ff d0                	callq  *%rax
  8044df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e6:	79 05                	jns    8044ed <iscons+0x31>
		return r;
  8044e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044eb:	eb 1a                	jmp    804507 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f1:	8b 10                	mov    (%rax),%edx
  8044f3:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8044fa:	00 00 00 
  8044fd:	8b 00                	mov    (%rax),%eax
  8044ff:	39 c2                	cmp    %eax,%edx
  804501:	0f 94 c0             	sete   %al
  804504:	0f b6 c0             	movzbl %al,%eax
}
  804507:	c9                   	leaveq 
  804508:	c3                   	retq   

0000000000804509 <opencons>:

int
opencons(void)
{
  804509:	55                   	push   %rbp
  80450a:	48 89 e5             	mov    %rsp,%rbp
  80450d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804511:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804515:	48 89 c7             	mov    %rax,%rdi
  804518:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  80451f:	00 00 00 
  804522:	ff d0                	callq  *%rax
  804524:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80452b:	79 05                	jns    804532 <opencons+0x29>
		return r;
  80452d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804530:	eb 5b                	jmp    80458d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804536:	ba 07 04 00 00       	mov    $0x407,%edx
  80453b:	48 89 c6             	mov    %rax,%rsi
  80453e:	bf 00 00 00 00       	mov    $0x0,%edi
  804543:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  80454a:	00 00 00 
  80454d:	ff d0                	callq  *%rax
  80454f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804552:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804556:	79 05                	jns    80455d <opencons+0x54>
		return r;
  804558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455b:	eb 30                	jmp    80458d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80455d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804561:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804568:	00 00 00 
  80456b:	8b 12                	mov    (%rdx),%edx
  80456d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80456f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804573:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80457a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80457e:	48 89 c7             	mov    %rax,%rdi
  804581:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  804588:	00 00 00 
  80458b:	ff d0                	callq  *%rax
}
  80458d:	c9                   	leaveq 
  80458e:	c3                   	retq   

000000000080458f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80458f:	55                   	push   %rbp
  804590:	48 89 e5             	mov    %rsp,%rbp
  804593:	48 83 ec 30          	sub    $0x30,%rsp
  804597:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80459b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80459f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045a3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045a8:	75 13                	jne    8045bd <devcons_read+0x2e>
		return 0;
  8045aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8045af:	eb 49                	jmp    8045fa <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8045b1:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  8045b8:	00 00 00 
  8045bb:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8045bd:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8045c4:	00 00 00 
  8045c7:	ff d0                	callq  *%rax
  8045c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d0:	74 df                	je     8045b1 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8045d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d6:	79 05                	jns    8045dd <devcons_read+0x4e>
		return c;
  8045d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045db:	eb 1d                	jmp    8045fa <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8045dd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045e1:	75 07                	jne    8045ea <devcons_read+0x5b>
		return 0;
  8045e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8045e8:	eb 10                	jmp    8045fa <devcons_read+0x6b>
	*(char*)vbuf = c;
  8045ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ed:	89 c2                	mov    %eax,%edx
  8045ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045f3:	88 10                	mov    %dl,(%rax)
	return 1;
  8045f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045fa:	c9                   	leaveq 
  8045fb:	c3                   	retq   

00000000008045fc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045fc:	55                   	push   %rbp
  8045fd:	48 89 e5             	mov    %rsp,%rbp
  804600:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804607:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80460e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804615:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80461c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804623:	eb 76                	jmp    80469b <devcons_write+0x9f>
		m = n - tot;
  804625:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80462c:	89 c2                	mov    %eax,%edx
  80462e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804631:	29 c2                	sub    %eax,%edx
  804633:	89 d0                	mov    %edx,%eax
  804635:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804638:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80463b:	83 f8 7f             	cmp    $0x7f,%eax
  80463e:	76 07                	jbe    804647 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804640:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804647:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80464a:	48 63 d0             	movslq %eax,%rdx
  80464d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804650:	48 63 c8             	movslq %eax,%rcx
  804653:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80465a:	48 01 c1             	add    %rax,%rcx
  80465d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804664:	48 89 ce             	mov    %rcx,%rsi
  804667:	48 89 c7             	mov    %rax,%rdi
  80466a:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  804671:	00 00 00 
  804674:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804676:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804679:	48 63 d0             	movslq %eax,%rdx
  80467c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804683:	48 89 d6             	mov    %rdx,%rsi
  804686:	48 89 c7             	mov    %rax,%rdi
  804689:	48 b8 2c 18 80 00 00 	movabs $0x80182c,%rax
  804690:	00 00 00 
  804693:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804695:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804698:	01 45 fc             	add    %eax,-0x4(%rbp)
  80469b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80469e:	48 98                	cltq   
  8046a0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046a7:	0f 82 78 ff ff ff    	jb     804625 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8046ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046b0:	c9                   	leaveq 
  8046b1:	c3                   	retq   

00000000008046b2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8046b2:	55                   	push   %rbp
  8046b3:	48 89 e5             	mov    %rsp,%rbp
  8046b6:	48 83 ec 08          	sub    $0x8,%rsp
  8046ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8046be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046c3:	c9                   	leaveq 
  8046c4:	c3                   	retq   

00000000008046c5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046c5:	55                   	push   %rbp
  8046c6:	48 89 e5             	mov    %rsp,%rbp
  8046c9:	48 83 ec 10          	sub    $0x10,%rsp
  8046cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d9:	48 be b4 50 80 00 00 	movabs $0x8050b4,%rsi
  8046e0:	00 00 00 
  8046e3:	48 89 c7             	mov    %rax,%rdi
  8046e6:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8046ed:	00 00 00 
  8046f0:	ff d0                	callq  *%rax
	return 0;
  8046f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046f7:	c9                   	leaveq 
  8046f8:	c3                   	retq   

00000000008046f9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8046f9:	55                   	push   %rbp
  8046fa:	48 89 e5             	mov    %rsp,%rbp
  8046fd:	48 83 ec 20          	sub    $0x20,%rsp
  804701:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804705:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80470c:	00 00 00 
  80470f:	48 8b 00             	mov    (%rax),%rax
  804712:	48 85 c0             	test   %rax,%rax
  804715:	75 6f                	jne    804786 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804717:	ba 07 00 00 00       	mov    $0x7,%edx
  80471c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804721:	bf 00 00 00 00       	mov    $0x0,%edi
  804726:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  80472d:	00 00 00 
  804730:	ff d0                	callq  *%rax
  804732:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804735:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804739:	79 30                	jns    80476b <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  80473b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80473e:	89 c1                	mov    %eax,%ecx
  804740:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  804747:	00 00 00 
  80474a:	be 22 00 00 00       	mov    $0x22,%esi
  80474f:	48 bf df 50 80 00 00 	movabs $0x8050df,%rdi
  804756:	00 00 00 
  804759:	b8 00 00 00 00       	mov    $0x0,%eax
  80475e:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  804765:	00 00 00 
  804768:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80476b:	48 be 9a 47 80 00 00 	movabs $0x80479a,%rsi
  804772:	00 00 00 
  804775:	bf 00 00 00 00       	mov    $0x0,%edi
  80477a:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  804781:	00 00 00 
  804784:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804786:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80478d:	00 00 00 
  804790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804794:	48 89 10             	mov    %rdx,(%rax)
}
  804797:	90                   	nop
  804798:	c9                   	leaveq 
  804799:	c3                   	retq   

000000000080479a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80479a:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80479d:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8047a4:	00 00 00 
call *%rax
  8047a7:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8047a9:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8047b0:	00 08 
    movq 152(%rsp), %rax
  8047b2:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8047b9:	00 
    movq 136(%rsp), %rbx
  8047ba:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8047c1:	00 
movq %rbx, (%rax)
  8047c2:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8047c5:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8047c9:	4c 8b 3c 24          	mov    (%rsp),%r15
  8047cd:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8047d2:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8047d7:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8047dc:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8047e1:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8047e6:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8047eb:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8047f0:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8047f5:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8047fa:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8047ff:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804804:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804809:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80480e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804813:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804817:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  80481b:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80481c:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804821:	c3                   	retq   

0000000000804822 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804822:	55                   	push   %rbp
  804823:	48 89 e5             	mov    %rsp,%rbp
  804826:	48 83 ec 18          	sub    $0x18,%rsp
  80482a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80482e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804832:	48 c1 e8 15          	shr    $0x15,%rax
  804836:	48 89 c2             	mov    %rax,%rdx
  804839:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804840:	01 00 00 
  804843:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804847:	83 e0 01             	and    $0x1,%eax
  80484a:	48 85 c0             	test   %rax,%rax
  80484d:	75 07                	jne    804856 <pageref+0x34>
		return 0;
  80484f:	b8 00 00 00 00       	mov    $0x0,%eax
  804854:	eb 56                	jmp    8048ac <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80485a:	48 c1 e8 0c          	shr    $0xc,%rax
  80485e:	48 89 c2             	mov    %rax,%rdx
  804861:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804868:	01 00 00 
  80486b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80486f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804873:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804877:	83 e0 01             	and    $0x1,%eax
  80487a:	48 85 c0             	test   %rax,%rax
  80487d:	75 07                	jne    804886 <pageref+0x64>
		return 0;
  80487f:	b8 00 00 00 00       	mov    $0x0,%eax
  804884:	eb 26                	jmp    8048ac <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80488a:	48 c1 e8 0c          	shr    $0xc,%rax
  80488e:	48 89 c2             	mov    %rax,%rdx
  804891:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804898:	00 00 00 
  80489b:	48 c1 e2 04          	shl    $0x4,%rdx
  80489f:	48 01 d0             	add    %rdx,%rax
  8048a2:	48 83 c0 08          	add    $0x8,%rax
  8048a6:	0f b7 00             	movzwl (%rax),%eax
  8048a9:	0f b7 c0             	movzwl %ax,%eax
}
  8048ac:	c9                   	leaveq 
  8048ad:	c3                   	retq   
