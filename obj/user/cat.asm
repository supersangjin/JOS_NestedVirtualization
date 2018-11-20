
obj/user/cat:     file format elf64-x86-64


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
  80003c:	e8 04 02 00 00       	callq  800245 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba 00 45 80 00 00 	movabs $0x804500,%rdx
  800098:	00 00 00 
  80009b:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a0:	48 bf 1b 45 80 00 00 	movabs $0x80451b,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 ed 02 80 00 00 	movabs $0x8002ed,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba 26 45 80 00 00 	movabs $0x804526,%rdx
  800109:	00 00 00 
  80010c:	be 10 00 00 00       	mov    $0x10,%esi
  800111:	48 bf 1b 45 80 00 00 	movabs $0x80451b,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 ed 02 80 00 00 	movabs $0x8002ed,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	90                   	nop
  80012e:	c9                   	leaveq 
  80012f:	c3                   	retq   

0000000000800130 <umain>:

void
umain(int argc, char **argv)
{
  800130:	55                   	push   %rbp
  800131:	48 89 e5             	mov    %rsp,%rbp
  800134:	48 83 ec 20          	sub    $0x20,%rsp
  800138:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80013b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800146:	00 00 00 
  800149:	48 b9 3b 45 80 00 00 	movabs $0x80453b,%rcx
  800150:	00 00 00 
  800153:	48 89 08             	mov    %rcx,(%rax)
	if (argc == 1)
  800156:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4c>
		cat(0, "<stdin>");
  80015c:	48 be 3f 45 80 00 00 	movabs $0x80453f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x112>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x106>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 d9 28 80 00 00 	movabs $0x8028d9,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  8001b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc6>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf 47 45 80 00 00 	movabs $0x804547,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 68 31 80 00 00 	movabs $0x803168,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x102>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800239:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x58>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	90                   	nop
  800243:	c9                   	leaveq 
  800244:	c3                   	retq   

0000000000800245 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
  800249:	48 83 ec 10          	sub    $0x10,%rsp
  80024d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800254:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	callq  *%rax
  800260:	25 ff 03 00 00       	and    $0x3ff,%eax
  800265:	48 98                	cltq   
  800267:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80026e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800275:	00 00 00 
  800278:	48 01 c2             	add    %rax,%rdx
  80027b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800282:	00 00 00 
  800285:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80028c:	7e 14                	jle    8002a2 <libmain+0x5d>
		binaryname = argv[0];
  80028e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800292:	48 8b 10             	mov    (%rax),%rdx
  800295:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80029c:	00 00 00 
  80029f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a9:	48 89 d6             	mov    %rdx,%rsi
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002ba:	48 b8 c9 02 80 00 00 	movabs $0x8002c9,%rax
  8002c1:	00 00 00 
  8002c4:	ff d0                	callq  *%rax
}
  8002c6:	90                   	nop
  8002c7:	c9                   	leaveq 
  8002c8:	c3                   	retq   

00000000008002c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002c9:	55                   	push   %rbp
  8002ca:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8002cd:	48 b8 28 22 80 00 00 	movabs $0x802228,%rax
  8002d4:	00 00 00 
  8002d7:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8002d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8002de:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
  8002e5:	00 00 00 
  8002e8:	ff d0                	callq  *%rax
}
  8002ea:	90                   	nop
  8002eb:	5d                   	pop    %rbp
  8002ec:	c3                   	retq   

00000000008002ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ed:	55                   	push   %rbp
  8002ee:	48 89 e5             	mov    %rsp,%rbp
  8002f1:	53                   	push   %rbx
  8002f2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002f9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800300:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800306:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80030d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800314:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80031b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800322:	84 c0                	test   %al,%al
  800324:	74 23                	je     800349 <_panic+0x5c>
  800326:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80032d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800331:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800335:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800339:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80033d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800341:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800345:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800349:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800350:	00 00 00 
  800353:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80035a:	00 00 00 
  80035d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800361:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800368:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80036f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800376:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80037d:	00 00 00 
  800380:	48 8b 18             	mov    (%rax),%rbx
  800383:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
  80038f:	89 c6                	mov    %eax,%esi
  800391:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800397:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80039e:	41 89 d0             	mov    %edx,%r8d
  8003a1:	48 89 c1             	mov    %rax,%rcx
  8003a4:	48 89 da             	mov    %rbx,%rdx
  8003a7:	48 bf 68 45 80 00 00 	movabs $0x804568,%rdi
  8003ae:	00 00 00 
  8003b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b6:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  8003bd:	00 00 00 
  8003c0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003ca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d1:	48 89 d6             	mov    %rdx,%rsi
  8003d4:	48 89 c7             	mov    %rax,%rdi
  8003d7:	48 b8 7b 04 80 00 00 	movabs $0x80047b,%rax
  8003de:	00 00 00 
  8003e1:	ff d0                	callq  *%rax
	cprintf("\n");
  8003e3:	48 bf 8b 45 80 00 00 	movabs $0x80458b,%rdi
  8003ea:	00 00 00 
  8003ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f2:	48 ba 27 05 80 00 00 	movabs $0x800527,%rdx
  8003f9:	00 00 00 
  8003fc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003fe:	cc                   	int3   
  8003ff:	eb fd                	jmp    8003fe <_panic+0x111>

0000000000800401 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800401:	55                   	push   %rbp
  800402:	48 89 e5             	mov    %rsp,%rbp
  800405:	48 83 ec 10          	sub    $0x10,%rsp
  800409:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800414:	8b 00                	mov    (%rax),%eax
  800416:	8d 48 01             	lea    0x1(%rax),%ecx
  800419:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80041d:	89 0a                	mov    %ecx,(%rdx)
  80041f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800422:	89 d1                	mov    %edx,%ecx
  800424:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800428:	48 98                	cltq   
  80042a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80042e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800432:	8b 00                	mov    (%rax),%eax
  800434:	3d ff 00 00 00       	cmp    $0xff,%eax
  800439:	75 2c                	jne    800467 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80043b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043f:	8b 00                	mov    (%rax),%eax
  800441:	48 98                	cltq   
  800443:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800447:	48 83 c2 08          	add    $0x8,%rdx
  80044b:	48 89 c6             	mov    %rax,%rsi
  80044e:	48 89 d7             	mov    %rdx,%rdi
  800451:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  800458:	00 00 00 
  80045b:	ff d0                	callq  *%rax
        b->idx = 0;
  80045d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800461:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046b:	8b 40 04             	mov    0x4(%rax),%eax
  80046e:	8d 50 01             	lea    0x1(%rax),%edx
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	89 50 04             	mov    %edx,0x4(%rax)
}
  800478:	90                   	nop
  800479:	c9                   	leaveq 
  80047a:	c3                   	retq   

000000000080047b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80047b:	55                   	push   %rbp
  80047c:	48 89 e5             	mov    %rsp,%rbp
  80047f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800486:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80048d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800494:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80049b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a2:	48 8b 0a             	mov    (%rdx),%rcx
  8004a5:	48 89 08             	mov    %rcx,(%rax)
  8004a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004bf:	00 00 00 
    b.cnt = 0;
  8004c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004c9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e1:	48 89 c6             	mov    %rax,%rsi
  8004e4:	48 bf 01 04 80 00 00 	movabs $0x800401,%rdi
  8004eb:	00 00 00 
  8004ee:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800500:	48 98                	cltq   
  800502:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800509:	48 83 c2 08          	add    $0x8,%rdx
  80050d:	48 89 c6             	mov    %rax,%rsi
  800510:	48 89 d7             	mov    %rdx,%rdi
  800513:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  80051a:	00 00 00 
  80051d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80051f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800525:	c9                   	leaveq 
  800526:	c3                   	retq   

0000000000800527 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800527:	55                   	push   %rbp
  800528:	48 89 e5             	mov    %rsp,%rbp
  80052b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800532:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800539:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800540:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800547:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80054e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800555:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80055c:	84 c0                	test   %al,%al
  80055e:	74 20                	je     800580 <cprintf+0x59>
  800560:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800564:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800568:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80056c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800570:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800574:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800578:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80057c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800580:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800587:	00 00 00 
  80058a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800591:	00 00 00 
  800594:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800598:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80059f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005bb:	48 8b 0a             	mov    (%rdx),%rcx
  8005be:	48 89 08             	mov    %rcx,(%rax)
  8005c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005df:	48 89 d6             	mov    %rdx,%rsi
  8005e2:	48 89 c7             	mov    %rax,%rdi
  8005e5:	48 b8 7b 04 80 00 00 	movabs $0x80047b,%rax
  8005ec:	00 00 00 
  8005ef:	ff d0                	callq  *%rax
  8005f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005fd:	c9                   	leaveq 
  8005fe:	c3                   	retq   

00000000008005ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ff:	55                   	push   %rbp
  800600:	48 89 e5             	mov    %rsp,%rbp
  800603:	48 83 ec 30          	sub    $0x30,%rsp
  800607:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80060b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80060f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800613:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800616:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80061a:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80061e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800621:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800625:	77 54                	ja     80067b <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800627:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80062a:	8d 78 ff             	lea    -0x1(%rax),%edi
  80062d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	ba 00 00 00 00       	mov    $0x0,%edx
  800639:	48 f7 f6             	div    %rsi
  80063c:	49 89 c2             	mov    %rax,%r10
  80063f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800642:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800645:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064d:	41 89 c9             	mov    %ecx,%r9d
  800650:	41 89 f8             	mov    %edi,%r8d
  800653:	89 d1                	mov    %edx,%ecx
  800655:	4c 89 d2             	mov    %r10,%rdx
  800658:	48 89 c7             	mov    %rax,%rdi
  80065b:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800662:	00 00 00 
  800665:	ff d0                	callq  *%rax
  800667:	eb 1c                	jmp    800685 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800669:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80066d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800674:	48 89 ce             	mov    %rcx,%rsi
  800677:	89 d7                	mov    %edx,%edi
  800679:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80067f:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800683:	7f e4                	jg     800669 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800685:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	48 f7 f1             	div    %rcx
  800694:	48 b8 90 47 80 00 00 	movabs $0x804790,%rax
  80069b:	00 00 00 
  80069e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8006a2:	0f be d0             	movsbl %al,%edx
  8006a5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ad:	48 89 ce             	mov    %rcx,%rsi
  8006b0:	89 d7                	mov    %edx,%edi
  8006b2:	ff d0                	callq  *%rax
}
  8006b4:	90                   	nop
  8006b5:	c9                   	leaveq 
  8006b6:	c3                   	retq   

00000000008006b7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b7:	55                   	push   %rbp
  8006b8:	48 89 e5             	mov    %rsp,%rbp
  8006bb:	48 83 ec 20          	sub    $0x20,%rsp
  8006bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006c6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006ca:	7e 4f                	jle    80071b <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	8b 00                	mov    (%rax),%eax
  8006d2:	83 f8 30             	cmp    $0x30,%eax
  8006d5:	73 24                	jae    8006fb <getuint+0x44>
  8006d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006db:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	89 c0                	mov    %eax,%eax
  8006e7:	48 01 d0             	add    %rdx,%rax
  8006ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ee:	8b 12                	mov    (%rdx),%edx
  8006f0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	89 0a                	mov    %ecx,(%rdx)
  8006f9:	eb 14                	jmp    80070f <getuint+0x58>
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	48 8b 40 08          	mov    0x8(%rax),%rax
  800703:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80070f:	48 8b 00             	mov    (%rax),%rax
  800712:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800716:	e9 9d 00 00 00       	jmpq   8007b8 <getuint+0x101>
	else if (lflag)
  80071b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80071f:	74 4c                	je     80076d <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800725:	8b 00                	mov    (%rax),%eax
  800727:	83 f8 30             	cmp    $0x30,%eax
  80072a:	73 24                	jae    800750 <getuint+0x99>
  80072c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800730:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800738:	8b 00                	mov    (%rax),%eax
  80073a:	89 c0                	mov    %eax,%eax
  80073c:	48 01 d0             	add    %rdx,%rax
  80073f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800743:	8b 12                	mov    (%rdx),%edx
  800745:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800748:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074c:	89 0a                	mov    %ecx,(%rdx)
  80074e:	eb 14                	jmp    800764 <getuint+0xad>
  800750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800754:	48 8b 40 08          	mov    0x8(%rax),%rax
  800758:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80075c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800760:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800764:	48 8b 00             	mov    (%rax),%rax
  800767:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80076b:	eb 4b                	jmp    8007b8 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	83 f8 30             	cmp    $0x30,%eax
  800776:	73 24                	jae    80079c <getuint+0xe5>
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	8b 00                	mov    (%rax),%eax
  800786:	89 c0                	mov    %eax,%eax
  800788:	48 01 d0             	add    %rdx,%rax
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	8b 12                	mov    (%rdx),%edx
  800791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800798:	89 0a                	mov    %ecx,(%rdx)
  80079a:	eb 14                	jmp    8007b0 <getuint+0xf9>
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007a4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	89 c0                	mov    %eax,%eax
  8007b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007bc:	c9                   	leaveq 
  8007bd:	c3                   	retq   

00000000008007be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007be:	55                   	push   %rbp
  8007bf:	48 89 e5             	mov    %rsp,%rbp
  8007c2:	48 83 ec 20          	sub    $0x20,%rsp
  8007c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007cd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007d1:	7e 4f                	jle    800822 <getint+0x64>
		x=va_arg(*ap, long long);
  8007d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d7:	8b 00                	mov    (%rax),%eax
  8007d9:	83 f8 30             	cmp    $0x30,%eax
  8007dc:	73 24                	jae    800802 <getint+0x44>
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	8b 00                	mov    (%rax),%eax
  8007ec:	89 c0                	mov    %eax,%eax
  8007ee:	48 01 d0             	add    %rdx,%rax
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	8b 12                	mov    (%rdx),%edx
  8007f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fe:	89 0a                	mov    %ecx,(%rdx)
  800800:	eb 14                	jmp    800816 <getint+0x58>
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	48 8b 40 08          	mov    0x8(%rax),%rax
  80080a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80080e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800812:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800816:	48 8b 00             	mov    (%rax),%rax
  800819:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80081d:	e9 9d 00 00 00       	jmpq   8008bf <getint+0x101>
	else if (lflag)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800826:	74 4c                	je     800874 <getint+0xb6>
		x=va_arg(*ap, long);
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	8b 00                	mov    (%rax),%eax
  80082e:	83 f8 30             	cmp    $0x30,%eax
  800831:	73 24                	jae    800857 <getint+0x99>
  800833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800837:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	8b 00                	mov    (%rax),%eax
  800841:	89 c0                	mov    %eax,%eax
  800843:	48 01 d0             	add    %rdx,%rax
  800846:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084a:	8b 12                	mov    (%rdx),%edx
  80084c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800853:	89 0a                	mov    %ecx,(%rdx)
  800855:	eb 14                	jmp    80086b <getint+0xad>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80085f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800867:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086b:	48 8b 00             	mov    (%rax),%rax
  80086e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800872:	eb 4b                	jmp    8008bf <getint+0x101>
	else
		x=va_arg(*ap, int);
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	83 f8 30             	cmp    $0x30,%eax
  80087d:	73 24                	jae    8008a3 <getint+0xe5>
  80087f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800883:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	8b 00                	mov    (%rax),%eax
  80088d:	89 c0                	mov    %eax,%eax
  80088f:	48 01 d0             	add    %rdx,%rax
  800892:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800896:	8b 12                	mov    (%rdx),%edx
  800898:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089f:	89 0a                	mov    %ecx,(%rdx)
  8008a1:	eb 14                	jmp    8008b7 <getint+0xf9>
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008ab:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	48 98                	cltq   
  8008bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c3:	c9                   	leaveq 
  8008c4:	c3                   	retq   

00000000008008c5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008c5:	55                   	push   %rbp
  8008c6:	48 89 e5             	mov    %rsp,%rbp
  8008c9:	41 54                	push   %r12
  8008cb:	53                   	push   %rbx
  8008cc:	48 83 ec 60          	sub    $0x60,%rsp
  8008d0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008d4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008dc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008e0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008e4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008e8:	48 8b 0a             	mov    (%rdx),%rcx
  8008eb:	48 89 08             	mov    %rcx,(%rax)
  8008ee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008f2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008f6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008fa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fe:	eb 17                	jmp    800917 <vprintfmt+0x52>
			if (ch == '\0')
  800900:	85 db                	test   %ebx,%ebx
  800902:	0f 84 b9 04 00 00    	je     800dc1 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800908:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80090c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800910:	48 89 d6             	mov    %rdx,%rsi
  800913:	89 df                	mov    %ebx,%edi
  800915:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800917:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80091f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800923:	0f b6 00             	movzbl (%rax),%eax
  800926:	0f b6 d8             	movzbl %al,%ebx
  800929:	83 fb 25             	cmp    $0x25,%ebx
  80092c:	75 d2                	jne    800900 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80092e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800932:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800939:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800940:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800947:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800952:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800956:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80095a:	0f b6 00             	movzbl (%rax),%eax
  80095d:	0f b6 d8             	movzbl %al,%ebx
  800960:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800963:	83 f8 55             	cmp    $0x55,%eax
  800966:	0f 87 22 04 00 00    	ja     800d8e <vprintfmt+0x4c9>
  80096c:	89 c0                	mov    %eax,%eax
  80096e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800975:	00 
  800976:	48 b8 b8 47 80 00 00 	movabs $0x8047b8,%rax
  80097d:	00 00 00 
  800980:	48 01 d0             	add    %rdx,%rax
  800983:	48 8b 00             	mov    (%rax),%rax
  800986:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800988:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80098c:	eb c0                	jmp    80094e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800992:	eb ba                	jmp    80094e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800994:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80099b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80099e:	89 d0                	mov    %edx,%eax
  8009a0:	c1 e0 02             	shl    $0x2,%eax
  8009a3:	01 d0                	add    %edx,%eax
  8009a5:	01 c0                	add    %eax,%eax
  8009a7:	01 d8                	add    %ebx,%eax
  8009a9:	83 e8 30             	sub    $0x30,%eax
  8009ac:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009af:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b3:	0f b6 00             	movzbl (%rax),%eax
  8009b6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b9:	83 fb 2f             	cmp    $0x2f,%ebx
  8009bc:	7e 60                	jle    800a1e <vprintfmt+0x159>
  8009be:	83 fb 39             	cmp    $0x39,%ebx
  8009c1:	7f 5b                	jg     800a1e <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c8:	eb d1                	jmp    80099b <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cd:	83 f8 30             	cmp    $0x30,%eax
  8009d0:	73 17                	jae    8009e9 <vprintfmt+0x124>
  8009d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009d6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d9:	89 d2                	mov    %edx,%edx
  8009db:	48 01 d0             	add    %rdx,%rax
  8009de:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e1:	83 c2 08             	add    $0x8,%edx
  8009e4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e7:	eb 0c                	jmp    8009f5 <vprintfmt+0x130>
  8009e9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009ed:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009f1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f5:	8b 00                	mov    (%rax),%eax
  8009f7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009fa:	eb 23                	jmp    800a1f <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8009fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a00:	0f 89 48 ff ff ff    	jns    80094e <vprintfmt+0x89>
				width = 0;
  800a06:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a0d:	e9 3c ff ff ff       	jmpq   80094e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a12:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a19:	e9 30 ff ff ff       	jmpq   80094e <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a23:	0f 89 25 ff ff ff    	jns    80094e <vprintfmt+0x89>
				width = precision, precision = -1;
  800a29:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a2c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a2f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a36:	e9 13 ff ff ff       	jmpq   80094e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a3f:	e9 0a ff ff ff       	jmpq   80094e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a47:	83 f8 30             	cmp    $0x30,%eax
  800a4a:	73 17                	jae    800a63 <vprintfmt+0x19e>
  800a4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a53:	89 d2                	mov    %edx,%edx
  800a55:	48 01 d0             	add    %rdx,%rax
  800a58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5b:	83 c2 08             	add    $0x8,%edx
  800a5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a61:	eb 0c                	jmp    800a6f <vprintfmt+0x1aa>
  800a63:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a67:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6f:	8b 10                	mov    (%rax),%edx
  800a71:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a79:	48 89 ce             	mov    %rcx,%rsi
  800a7c:	89 d7                	mov    %edx,%edi
  800a7e:	ff d0                	callq  *%rax
			break;
  800a80:	e9 37 03 00 00       	jmpq   800dbc <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a88:	83 f8 30             	cmp    $0x30,%eax
  800a8b:	73 17                	jae    800aa4 <vprintfmt+0x1df>
  800a8d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a94:	89 d2                	mov    %edx,%edx
  800a96:	48 01 d0             	add    %rdx,%rax
  800a99:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9c:	83 c2 08             	add    $0x8,%edx
  800a9f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa2:	eb 0c                	jmp    800ab0 <vprintfmt+0x1eb>
  800aa4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800aa8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800aac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ab2:	85 db                	test   %ebx,%ebx
  800ab4:	79 02                	jns    800ab8 <vprintfmt+0x1f3>
				err = -err;
  800ab6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ab8:	83 fb 15             	cmp    $0x15,%ebx
  800abb:	7f 16                	jg     800ad3 <vprintfmt+0x20e>
  800abd:	48 b8 e0 46 80 00 00 	movabs $0x8046e0,%rax
  800ac4:	00 00 00 
  800ac7:	48 63 d3             	movslq %ebx,%rdx
  800aca:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ace:	4d 85 e4             	test   %r12,%r12
  800ad1:	75 2e                	jne    800b01 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ad3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	89 d9                	mov    %ebx,%ecx
  800add:	48 ba a1 47 80 00 00 	movabs $0x8047a1,%rdx
  800ae4:	00 00 00 
  800ae7:	48 89 c7             	mov    %rax,%rdi
  800aea:	b8 00 00 00 00       	mov    $0x0,%eax
  800aef:	49 b8 cb 0d 80 00 00 	movabs $0x800dcb,%r8
  800af6:	00 00 00 
  800af9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800afc:	e9 bb 02 00 00       	jmpq   800dbc <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b01:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b09:	4c 89 e1             	mov    %r12,%rcx
  800b0c:	48 ba aa 47 80 00 00 	movabs $0x8047aa,%rdx
  800b13:	00 00 00 
  800b16:	48 89 c7             	mov    %rax,%rdi
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1e:	49 b8 cb 0d 80 00 00 	movabs $0x800dcb,%r8
  800b25:	00 00 00 
  800b28:	41 ff d0             	callq  *%r8
			break;
  800b2b:	e9 8c 02 00 00       	jmpq   800dbc <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b33:	83 f8 30             	cmp    $0x30,%eax
  800b36:	73 17                	jae    800b4f <vprintfmt+0x28a>
  800b38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b3c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b3f:	89 d2                	mov    %edx,%edx
  800b41:	48 01 d0             	add    %rdx,%rax
  800b44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b47:	83 c2 08             	add    $0x8,%edx
  800b4a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4d:	eb 0c                	jmp    800b5b <vprintfmt+0x296>
  800b4f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b53:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5b:	4c 8b 20             	mov    (%rax),%r12
  800b5e:	4d 85 e4             	test   %r12,%r12
  800b61:	75 0a                	jne    800b6d <vprintfmt+0x2a8>
				p = "(null)";
  800b63:	49 bc ad 47 80 00 00 	movabs $0x8047ad,%r12
  800b6a:	00 00 00 
			if (width > 0 && padc != '-')
  800b6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b71:	7e 78                	jle    800beb <vprintfmt+0x326>
  800b73:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b77:	74 72                	je     800beb <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b79:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b7c:	48 98                	cltq   
  800b7e:	48 89 c6             	mov    %rax,%rsi
  800b81:	4c 89 e7             	mov    %r12,%rdi
  800b84:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  800b8b:	00 00 00 
  800b8e:	ff d0                	callq  *%rax
  800b90:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b93:	eb 17                	jmp    800bac <vprintfmt+0x2e7>
					putch(padc, putdat);
  800b95:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b99:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba1:	48 89 ce             	mov    %rcx,%rsi
  800ba4:	89 d7                	mov    %edx,%edi
  800ba6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb0:	7f e3                	jg     800b95 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb2:	eb 37                	jmp    800beb <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800bb4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bb8:	74 1e                	je     800bd8 <vprintfmt+0x313>
  800bba:	83 fb 1f             	cmp    $0x1f,%ebx
  800bbd:	7e 05                	jle    800bc4 <vprintfmt+0x2ff>
  800bbf:	83 fb 7e             	cmp    $0x7e,%ebx
  800bc2:	7e 14                	jle    800bd8 <vprintfmt+0x313>
					putch('?', putdat);
  800bc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcc:	48 89 d6             	mov    %rdx,%rsi
  800bcf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bd4:	ff d0                	callq  *%rax
  800bd6:	eb 0f                	jmp    800be7 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800bd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be0:	48 89 d6             	mov    %rdx,%rsi
  800be3:	89 df                	mov    %ebx,%edi
  800be5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800beb:	4c 89 e0             	mov    %r12,%rax
  800bee:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bf2:	0f b6 00             	movzbl (%rax),%eax
  800bf5:	0f be d8             	movsbl %al,%ebx
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	74 28                	je     800c24 <vprintfmt+0x35f>
  800bfc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c00:	78 b2                	js     800bb4 <vprintfmt+0x2ef>
  800c02:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c06:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c0a:	79 a8                	jns    800bb4 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0c:	eb 16                	jmp    800c24 <vprintfmt+0x35f>
				putch(' ', putdat);
  800c0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	48 89 d6             	mov    %rdx,%rsi
  800c19:	bf 20 00 00 00       	mov    $0x20,%edi
  800c1e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c28:	7f e4                	jg     800c0e <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800c2a:	e9 8d 01 00 00       	jmpq   800dbc <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c33:	be 03 00 00 00       	mov    $0x3,%esi
  800c38:	48 89 c7             	mov    %rax,%rdi
  800c3b:	48 b8 be 07 80 00 00 	movabs $0x8007be,%rax
  800c42:	00 00 00 
  800c45:	ff d0                	callq  *%rax
  800c47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4f:	48 85 c0             	test   %rax,%rax
  800c52:	79 1d                	jns    800c71 <vprintfmt+0x3ac>
				putch('-', putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c64:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6a:	48 f7 d8             	neg    %rax
  800c6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c71:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c78:	e9 d2 00 00 00       	jmpq   800d4f <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c81:	be 03 00 00 00       	mov    $0x3,%esi
  800c86:	48 89 c7             	mov    %rax,%rdi
  800c89:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c99:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca0:	e9 aa 00 00 00       	jmpq   800d4f <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800ca5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca9:	be 03 00 00 00       	mov    $0x3,%esi
  800cae:	48 89 c7             	mov    %rax,%rdi
  800cb1:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  800cb8:	00 00 00 
  800cbb:	ff d0                	callq  *%rax
  800cbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cc1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cc8:	e9 82 00 00 00       	jmpq   800d4f <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800ccd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd5:	48 89 d6             	mov    %rdx,%rsi
  800cd8:	bf 30 00 00 00       	mov    $0x30,%edi
  800cdd:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce7:	48 89 d6             	mov    %rdx,%rsi
  800cea:	bf 78 00 00 00       	mov    $0x78,%edi
  800cef:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cf1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf4:	83 f8 30             	cmp    $0x30,%eax
  800cf7:	73 17                	jae    800d10 <vprintfmt+0x44b>
  800cf9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cfd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d00:	89 d2                	mov    %edx,%edx
  800d02:	48 01 d0             	add    %rdx,%rax
  800d05:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d08:	83 c2 08             	add    $0x8,%edx
  800d0b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0e:	eb 0c                	jmp    800d1c <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800d10:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d14:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d1c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d23:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d2a:	eb 23                	jmp    800d4f <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d30:	be 03 00 00 00       	mov    $0x3,%esi
  800d35:	48 89 c7             	mov    %rax,%rdi
  800d38:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  800d3f:	00 00 00 
  800d42:	ff d0                	callq  *%rax
  800d44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d48:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d4f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d54:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d57:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d66:	45 89 c1             	mov    %r8d,%r9d
  800d69:	41 89 f8             	mov    %edi,%r8d
  800d6c:	48 89 c7             	mov    %rax,%rdi
  800d6f:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800d76:	00 00 00 
  800d79:	ff d0                	callq  *%rax
			break;
  800d7b:	eb 3f                	jmp    800dbc <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d85:	48 89 d6             	mov    %rdx,%rsi
  800d88:	89 df                	mov    %ebx,%edi
  800d8a:	ff d0                	callq  *%rax
			break;
  800d8c:	eb 2e                	jmp    800dbc <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d96:	48 89 d6             	mov    %rdx,%rsi
  800d99:	bf 25 00 00 00       	mov    $0x25,%edi
  800d9e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800da0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da5:	eb 05                	jmp    800dac <vprintfmt+0x4e7>
  800da7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800db0:	48 83 e8 01          	sub    $0x1,%rax
  800db4:	0f b6 00             	movzbl (%rax),%eax
  800db7:	3c 25                	cmp    $0x25,%al
  800db9:	75 ec                	jne    800da7 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800dbb:	90                   	nop
		}
	}
  800dbc:	e9 3d fb ff ff       	jmpq   8008fe <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dc1:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dc2:	48 83 c4 60          	add    $0x60,%rsp
  800dc6:	5b                   	pop    %rbx
  800dc7:	41 5c                	pop    %r12
  800dc9:	5d                   	pop    %rbp
  800dca:	c3                   	retq   

0000000000800dcb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dcb:	55                   	push   %rbp
  800dcc:	48 89 e5             	mov    %rsp,%rbp
  800dcf:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dd6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ddd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800de4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800deb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800df2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800df9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e00:	84 c0                	test   %al,%al
  800e02:	74 20                	je     800e24 <printfmt+0x59>
  800e04:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e08:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e0c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e10:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e14:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e18:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e1c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e20:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e24:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e2b:	00 00 00 
  800e2e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e35:	00 00 00 
  800e38:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e3c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e43:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e4a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e51:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e58:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e5f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e66:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e6d:	48 89 c7             	mov    %rax,%rdi
  800e70:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  800e77:	00 00 00 
  800e7a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e7c:	90                   	nop
  800e7d:	c9                   	leaveq 
  800e7e:	c3                   	retq   

0000000000800e7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e7f:	55                   	push   %rbp
  800e80:	48 89 e5             	mov    %rsp,%rbp
  800e83:	48 83 ec 10          	sub    $0x10,%rsp
  800e87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e92:	8b 40 10             	mov    0x10(%rax),%eax
  800e95:	8d 50 01             	lea    0x1(%rax),%edx
  800e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	48 8b 10             	mov    (%rax),%rdx
  800ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eaa:	48 8b 40 08          	mov    0x8(%rax),%rax
  800eae:	48 39 c2             	cmp    %rax,%rdx
  800eb1:	73 17                	jae    800eca <sprintputch+0x4b>
		*b->buf++ = ch;
  800eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb7:	48 8b 00             	mov    (%rax),%rax
  800eba:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ebe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ec2:	48 89 0a             	mov    %rcx,(%rdx)
  800ec5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ec8:	88 10                	mov    %dl,(%rax)
}
  800eca:	90                   	nop
  800ecb:	c9                   	leaveq 
  800ecc:	c3                   	retq   

0000000000800ecd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ecd:	55                   	push   %rbp
  800ece:	48 89 e5             	mov    %rsp,%rbp
  800ed1:	48 83 ec 50          	sub    $0x50,%rsp
  800ed5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ed9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800edc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ee0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ee4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ee8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eec:	48 8b 0a             	mov    (%rdx),%rcx
  800eef:	48 89 08             	mov    %rcx,(%rax)
  800ef2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800efa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800efe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f02:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f06:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f0a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f0d:	48 98                	cltq   
  800f0f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f13:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f17:	48 01 d0             	add    %rdx,%rax
  800f1a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f25:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f2a:	74 06                	je     800f32 <vsnprintf+0x65>
  800f2c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f30:	7f 07                	jg     800f39 <vsnprintf+0x6c>
		return -E_INVAL;
  800f32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f37:	eb 2f                	jmp    800f68 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f39:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f3d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f41:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f45:	48 89 c6             	mov    %rax,%rsi
  800f48:	48 bf 7f 0e 80 00 00 	movabs $0x800e7f,%rdi
  800f4f:	00 00 00 
  800f52:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  800f59:	00 00 00 
  800f5c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f62:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f65:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f68:	c9                   	leaveq 
  800f69:	c3                   	retq   

0000000000800f6a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f6a:	55                   	push   %rbp
  800f6b:	48 89 e5             	mov    %rsp,%rbp
  800f6e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f75:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f7c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f82:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800f89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f9e:	84 c0                	test   %al,%al
  800fa0:	74 20                	je     800fc2 <snprintf+0x58>
  800fa2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fa6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800faa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fbe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fc2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fc9:	00 00 00 
  800fcc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fd3:	00 00 00 
  800fd6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fda:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fe1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fef:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ff6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ffd:	48 8b 0a             	mov    (%rdx),%rcx
  801000:	48 89 08             	mov    %rcx,(%rax)
  801003:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801007:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80100b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80100f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801013:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80101a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801021:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801027:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80102e:	48 89 c7             	mov    %rax,%rdi
  801031:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  801038:	00 00 00 
  80103b:	ff d0                	callq  *%rax
  80103d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801043:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801049:	c9                   	leaveq 
  80104a:	c3                   	retq   

000000000080104b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80104b:	55                   	push   %rbp
  80104c:	48 89 e5             	mov    %rsp,%rbp
  80104f:	48 83 ec 18          	sub    $0x18,%rsp
  801053:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801057:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105e:	eb 09                	jmp    801069 <strlen+0x1e>
		n++;
  801060:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801064:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106d:	0f b6 00             	movzbl (%rax),%eax
  801070:	84 c0                	test   %al,%al
  801072:	75 ec                	jne    801060 <strlen+0x15>
		n++;
	return n;
  801074:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 83 ec 20          	sub    $0x20,%rsp
  801081:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801085:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801090:	eb 0e                	jmp    8010a0 <strnlen+0x27>
		n++;
  801092:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801096:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80109b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010a5:	74 0b                	je     8010b2 <strnlen+0x39>
  8010a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ab:	0f b6 00             	movzbl (%rax),%eax
  8010ae:	84 c0                	test   %al,%al
  8010b0:	75 e0                	jne    801092 <strnlen+0x19>
		n++;
	return n;
  8010b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010b5:	c9                   	leaveq 
  8010b6:	c3                   	retq   

00000000008010b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b7:	55                   	push   %rbp
  8010b8:	48 89 e5             	mov    %rsp,%rbp
  8010bb:	48 83 ec 20          	sub    $0x20,%rsp
  8010bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010cf:	90                   	nop
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010e4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010e8:	0f b6 12             	movzbl (%rdx),%edx
  8010eb:	88 10                	mov    %dl,(%rax)
  8010ed:	0f b6 00             	movzbl (%rax),%eax
  8010f0:	84 c0                	test   %al,%al
  8010f2:	75 dc                	jne    8010d0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f8:	c9                   	leaveq 
  8010f9:	c3                   	retq   

00000000008010fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 20          	sub    $0x20,%rsp
  801102:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801106:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80110a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110e:	48 89 c7             	mov    %rax,%rdi
  801111:	48 b8 4b 10 80 00 00 	movabs $0x80104b,%rax
  801118:	00 00 00 
  80111b:	ff d0                	callq  *%rax
  80111d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801120:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801123:	48 63 d0             	movslq %eax,%rdx
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	48 01 c2             	add    %rax,%rdx
  80112d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801131:	48 89 c6             	mov    %rax,%rsi
  801134:	48 89 d7             	mov    %rdx,%rdi
  801137:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  80113e:	00 00 00 
  801141:	ff d0                	callq  *%rax
	return dst;
  801143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 28          	sub    $0x28,%rsp
  801151:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801155:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801159:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80115d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801161:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801165:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80116c:	00 
  80116d:	eb 2a                	jmp    801199 <strncpy+0x50>
		*dst++ = *src;
  80116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801173:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801177:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80117b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80117f:	0f b6 12             	movzbl (%rdx),%edx
  801182:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801184:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801188:	0f b6 00             	movzbl (%rax),%eax
  80118b:	84 c0                	test   %al,%al
  80118d:	74 05                	je     801194 <strncpy+0x4b>
			src++;
  80118f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801194:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011a1:	72 cc                	jb     80116f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011a7:	c9                   	leaveq 
  8011a8:	c3                   	retq   

00000000008011a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011a9:	55                   	push   %rbp
  8011aa:	48 89 e5             	mov    %rsp,%rbp
  8011ad:	48 83 ec 28          	sub    $0x28,%rsp
  8011b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ca:	74 3d                	je     801209 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011cc:	eb 1d                	jmp    8011eb <strlcpy+0x42>
			*dst++ = *src++;
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011de:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011e2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011e6:	0f b6 12             	movzbl (%rdx),%edx
  8011e9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011eb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011f0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f5:	74 0b                	je     801202 <strlcpy+0x59>
  8011f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fb:	0f b6 00             	movzbl (%rax),%eax
  8011fe:	84 c0                	test   %al,%al
  801200:	75 cc                	jne    8011ce <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801209:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801211:	48 29 c2             	sub    %rax,%rdx
  801214:	48 89 d0             	mov    %rdx,%rax
}
  801217:	c9                   	leaveq 
  801218:	c3                   	retq   

0000000000801219 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	48 83 ec 10          	sub    $0x10,%rsp
  801221:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801225:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801229:	eb 0a                	jmp    801235 <strcmp+0x1c>
		p++, q++;
  80122b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801230:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	84 c0                	test   %al,%al
  80123e:	74 12                	je     801252 <strcmp+0x39>
  801240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801244:	0f b6 10             	movzbl (%rax),%edx
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	0f b6 00             	movzbl (%rax),%eax
  80124e:	38 c2                	cmp    %al,%dl
  801250:	74 d9                	je     80122b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801256:	0f b6 00             	movzbl (%rax),%eax
  801259:	0f b6 d0             	movzbl %al,%edx
  80125c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801260:	0f b6 00             	movzbl (%rax),%eax
  801263:	0f b6 c0             	movzbl %al,%eax
  801266:	29 c2                	sub    %eax,%edx
  801268:	89 d0                	mov    %edx,%eax
}
  80126a:	c9                   	leaveq 
  80126b:	c3                   	retq   

000000000080126c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80126c:	55                   	push   %rbp
  80126d:	48 89 e5             	mov    %rsp,%rbp
  801270:	48 83 ec 18          	sub    $0x18,%rsp
  801274:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801278:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80127c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801280:	eb 0f                	jmp    801291 <strncmp+0x25>
		n--, p++, q++;
  801282:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801287:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801291:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801296:	74 1d                	je     8012b5 <strncmp+0x49>
  801298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129c:	0f b6 00             	movzbl (%rax),%eax
  80129f:	84 c0                	test   %al,%al
  8012a1:	74 12                	je     8012b5 <strncmp+0x49>
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	0f b6 10             	movzbl (%rax),%edx
  8012aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	38 c2                	cmp    %al,%dl
  8012b3:	74 cd                	je     801282 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ba:	75 07                	jne    8012c3 <strncmp+0x57>
		return 0;
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	eb 18                	jmp    8012db <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	0f b6 d0             	movzbl %al,%edx
  8012cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	0f b6 c0             	movzbl %al,%eax
  8012d7:	29 c2                	sub    %eax,%edx
  8012d9:	89 d0                	mov    %edx,%eax
}
  8012db:	c9                   	leaveq 
  8012dc:	c3                   	retq   

00000000008012dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	48 83 ec 10          	sub    $0x10,%rsp
  8012e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e9:	89 f0                	mov    %esi,%eax
  8012eb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ee:	eb 17                	jmp    801307 <strchr+0x2a>
		if (*s == c)
  8012f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f4:	0f b6 00             	movzbl (%rax),%eax
  8012f7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012fa:	75 06                	jne    801302 <strchr+0x25>
			return (char *) s;
  8012fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801300:	eb 15                	jmp    801317 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801302:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	84 c0                	test   %al,%al
  801310:	75 de                	jne    8012f0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	48 83 ec 10          	sub    $0x10,%rsp
  801321:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801325:	89 f0                	mov    %esi,%eax
  801327:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80132a:	eb 11                	jmp    80133d <strfind+0x24>
		if (*s == c)
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801330:	0f b6 00             	movzbl (%rax),%eax
  801333:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801336:	74 12                	je     80134a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801338:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80133d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801341:	0f b6 00             	movzbl (%rax),%eax
  801344:	84 c0                	test   %al,%al
  801346:	75 e4                	jne    80132c <strfind+0x13>
  801348:	eb 01                	jmp    80134b <strfind+0x32>
		if (*s == c)
			break;
  80134a:	90                   	nop
	return (char *) s;
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80134f:	c9                   	leaveq 
  801350:	c3                   	retq   

0000000000801351 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801351:	55                   	push   %rbp
  801352:	48 89 e5             	mov    %rsp,%rbp
  801355:	48 83 ec 18          	sub    $0x18,%rsp
  801359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801360:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801364:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801369:	75 06                	jne    801371 <memset+0x20>
		return v;
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	eb 69                	jmp    8013da <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801375:	83 e0 03             	and    $0x3,%eax
  801378:	48 85 c0             	test   %rax,%rax
  80137b:	75 48                	jne    8013c5 <memset+0x74>
  80137d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801381:	83 e0 03             	and    $0x3,%eax
  801384:	48 85 c0             	test   %rax,%rax
  801387:	75 3c                	jne    8013c5 <memset+0x74>
		c &= 0xFF;
  801389:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801390:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801393:	c1 e0 18             	shl    $0x18,%eax
  801396:	89 c2                	mov    %eax,%edx
  801398:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139b:	c1 e0 10             	shl    $0x10,%eax
  80139e:	09 c2                	or     %eax,%edx
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	c1 e0 08             	shl    $0x8,%eax
  8013a6:	09 d0                	or     %edx,%eax
  8013a8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013af:	48 c1 e8 02          	shr    $0x2,%rax
  8013b3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013bd:	48 89 d7             	mov    %rdx,%rdi
  8013c0:	fc                   	cld    
  8013c1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013c3:	eb 11                	jmp    8013d6 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013cc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013d0:	48 89 d7             	mov    %rdx,%rdi
  8013d3:	fc                   	cld    
  8013d4:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013da:	c9                   	leaveq 
  8013db:	c3                   	retq   

00000000008013dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013dc:	55                   	push   %rbp
  8013dd:	48 89 e5             	mov    %rsp,%rbp
  8013e0:	48 83 ec 28          	sub    $0x28,%rsp
  8013e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801408:	0f 83 88 00 00 00    	jae    801496 <memmove+0xba>
  80140e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	48 01 d0             	add    %rdx,%rax
  801419:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80141d:	76 77                	jbe    801496 <memmove+0xba>
		s += n;
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801427:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	83 e0 03             	and    $0x3,%eax
  801436:	48 85 c0             	test   %rax,%rax
  801439:	75 3b                	jne    801476 <memmove+0x9a>
  80143b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 2f                	jne    801476 <memmove+0x9a>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 23                	jne    801476 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801457:	48 83 e8 04          	sub    $0x4,%rax
  80145b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145f:	48 83 ea 04          	sub    $0x4,%rdx
  801463:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801467:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80146b:	48 89 c7             	mov    %rax,%rdi
  80146e:	48 89 d6             	mov    %rdx,%rsi
  801471:	fd                   	std    
  801472:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801474:	eb 1d                	jmp    801493 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	48 89 d7             	mov    %rdx,%rdi
  80148d:	48 89 c1             	mov    %rax,%rcx
  801490:	fd                   	std    
  801491:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801493:	fc                   	cld    
  801494:	eb 57                	jmp    8014ed <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	83 e0 03             	and    $0x3,%eax
  80149d:	48 85 c0             	test   %rax,%rax
  8014a0:	75 36                	jne    8014d8 <memmove+0xfc>
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	83 e0 03             	and    $0x3,%eax
  8014a9:	48 85 c0             	test   %rax,%rax
  8014ac:	75 2a                	jne    8014d8 <memmove+0xfc>
  8014ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b2:	83 e0 03             	and    $0x3,%eax
  8014b5:	48 85 c0             	test   %rax,%rax
  8014b8:	75 1e                	jne    8014d8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014be:	48 c1 e8 02          	shr    $0x2,%rax
  8014c2:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014cd:	48 89 c7             	mov    %rax,%rdi
  8014d0:	48 89 d6             	mov    %rdx,%rsi
  8014d3:	fc                   	cld    
  8014d4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014d6:	eb 15                	jmp    8014ed <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014e4:	48 89 c7             	mov    %rax,%rdi
  8014e7:	48 89 d6             	mov    %rdx,%rsi
  8014ea:	fc                   	cld    
  8014eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f1:	c9                   	leaveq 
  8014f2:	c3                   	retq   

00000000008014f3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014f3:	55                   	push   %rbp
  8014f4:	48 89 e5             	mov    %rsp,%rbp
  8014f7:	48 83 ec 18          	sub    $0x18,%rsp
  8014fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801503:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80150b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	48 89 ce             	mov    %rcx,%rsi
  801516:	48 89 c7             	mov    %rax,%rdi
  801519:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  801520:	00 00 00 
  801523:	ff d0                	callq  *%rax
}
  801525:	c9                   	leaveq 
  801526:	c3                   	retq   

0000000000801527 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	48 83 ec 28          	sub    $0x28,%rsp
  80152f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801533:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801537:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801547:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80154b:	eb 36                	jmp    801583 <memcmp+0x5c>
		if (*s1 != *s2)
  80154d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801551:	0f b6 10             	movzbl (%rax),%edx
  801554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	38 c2                	cmp    %al,%dl
  80155d:	74 1a                	je     801579 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80155f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	0f b6 d0             	movzbl %al,%edx
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	0f b6 c0             	movzbl %al,%eax
  801573:	29 c2                	sub    %eax,%edx
  801575:	89 d0                	mov    %edx,%eax
  801577:	eb 20                	jmp    801599 <memcmp+0x72>
		s1++, s2++;
  801579:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80157e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80158b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80158f:	48 85 c0             	test   %rax,%rax
  801592:	75 b9                	jne    80154d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leaveq 
  80159a:	c3                   	retq   

000000000080159b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80159b:	55                   	push   %rbp
  80159c:	48 89 e5             	mov    %rsp,%rbp
  80159f:	48 83 ec 28          	sub    $0x28,%rsp
  8015a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b6:	48 01 d0             	add    %rdx,%rax
  8015b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015bd:	eb 19                	jmp    8015d8 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	0f b6 d0             	movzbl %al,%edx
  8015c9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015cc:	0f b6 c0             	movzbl %al,%eax
  8015cf:	39 c2                	cmp    %eax,%edx
  8015d1:	74 11                	je     8015e4 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015dc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015e0:	72 dd                	jb     8015bf <memfind+0x24>
  8015e2:	eb 01                	jmp    8015e5 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015e4:	90                   	nop
	return (void *) s;
  8015e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e9:	c9                   	leaveq 
  8015ea:	c3                   	retq   

00000000008015eb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015eb:	55                   	push   %rbp
  8015ec:	48 89 e5             	mov    %rsp,%rbp
  8015ef:	48 83 ec 38          	sub    $0x38,%rsp
  8015f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015fb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801605:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80160c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80160d:	eb 05                	jmp    801614 <strtol+0x29>
		s++;
  80160f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 20                	cmp    $0x20,%al
  80161d:	74 f0                	je     80160f <strtol+0x24>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 09                	cmp    $0x9,%al
  801628:	74 e5                	je     80160f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	3c 2b                	cmp    $0x2b,%al
  801633:	75 07                	jne    80163c <strtol+0x51>
		s++;
  801635:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163a:	eb 17                	jmp    801653 <strtol+0x68>
	else if (*s == '-')
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	0f b6 00             	movzbl (%rax),%eax
  801643:	3c 2d                	cmp    $0x2d,%al
  801645:	75 0c                	jne    801653 <strtol+0x68>
		s++, neg = 1;
  801647:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80164c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801653:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801657:	74 06                	je     80165f <strtol+0x74>
  801659:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80165d:	75 28                	jne    801687 <strtol+0x9c>
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	0f b6 00             	movzbl (%rax),%eax
  801666:	3c 30                	cmp    $0x30,%al
  801668:	75 1d                	jne    801687 <strtol+0x9c>
  80166a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166e:	48 83 c0 01          	add    $0x1,%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 78                	cmp    $0x78,%al
  801677:	75 0e                	jne    801687 <strtol+0x9c>
		s += 2, base = 16;
  801679:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80167e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801685:	eb 2c                	jmp    8016b3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801687:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168b:	75 19                	jne    8016a6 <strtol+0xbb>
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 30                	cmp    $0x30,%al
  801696:	75 0e                	jne    8016a6 <strtol+0xbb>
		s++, base = 8;
  801698:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016a4:	eb 0d                	jmp    8016b3 <strtol+0xc8>
	else if (base == 0)
  8016a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016aa:	75 07                	jne    8016b3 <strtol+0xc8>
		base = 10;
  8016ac:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 2f                	cmp    $0x2f,%al
  8016bc:	7e 1d                	jle    8016db <strtol+0xf0>
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 39                	cmp    $0x39,%al
  8016c7:	7f 12                	jg     8016db <strtol+0xf0>
			dig = *s - '0';
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	0f be c0             	movsbl %al,%eax
  8016d3:	83 e8 30             	sub    $0x30,%eax
  8016d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d9:	eb 4e                	jmp    801729 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	0f b6 00             	movzbl (%rax),%eax
  8016e2:	3c 60                	cmp    $0x60,%al
  8016e4:	7e 1d                	jle    801703 <strtol+0x118>
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 7a                	cmp    $0x7a,%al
  8016ef:	7f 12                	jg     801703 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	0f be c0             	movsbl %al,%eax
  8016fb:	83 e8 57             	sub    $0x57,%eax
  8016fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801701:	eb 26                	jmp    801729 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801703:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801707:	0f b6 00             	movzbl (%rax),%eax
  80170a:	3c 40                	cmp    $0x40,%al
  80170c:	7e 47                	jle    801755 <strtol+0x16a>
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	0f b6 00             	movzbl (%rax),%eax
  801715:	3c 5a                	cmp    $0x5a,%al
  801717:	7f 3c                	jg     801755 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171d:	0f b6 00             	movzbl (%rax),%eax
  801720:	0f be c0             	movsbl %al,%eax
  801723:	83 e8 37             	sub    $0x37,%eax
  801726:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801729:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80172c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80172f:	7d 23                	jge    801754 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801731:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801736:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801739:	48 98                	cltq   
  80173b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801740:	48 89 c2             	mov    %rax,%rdx
  801743:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801746:	48 98                	cltq   
  801748:	48 01 d0             	add    %rdx,%rax
  80174b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80174f:	e9 5f ff ff ff       	jmpq   8016b3 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801754:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801755:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80175a:	74 0b                	je     801767 <strtol+0x17c>
		*endptr = (char *) s;
  80175c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801760:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801764:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801767:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80176b:	74 09                	je     801776 <strtol+0x18b>
  80176d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801771:	48 f7 d8             	neg    %rax
  801774:	eb 04                	jmp    80177a <strtol+0x18f>
  801776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80177a:	c9                   	leaveq 
  80177b:	c3                   	retq   

000000000080177c <strstr>:

char * strstr(const char *in, const char *str)
{
  80177c:	55                   	push   %rbp
  80177d:	48 89 e5             	mov    %rsp,%rbp
  801780:	48 83 ec 30          	sub    $0x30,%rsp
  801784:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801788:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80178c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801790:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801794:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801798:	0f b6 00             	movzbl (%rax),%eax
  80179b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80179e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017a2:	75 06                	jne    8017aa <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	eb 6b                	jmp    801815 <strstr+0x99>

	len = strlen(str);
  8017aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ae:	48 89 c7             	mov    %rax,%rdi
  8017b1:	48 b8 4b 10 80 00 00 	movabs $0x80104b,%rax
  8017b8:	00 00 00 
  8017bb:	ff d0                	callq  *%rax
  8017bd:	48 98                	cltq   
  8017bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017d9:	75 07                	jne    8017e2 <strstr+0x66>
				return (char *) 0;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e0:	eb 33                	jmp    801815 <strstr+0x99>
		} while (sc != c);
  8017e2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017e6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017e9:	75 d8                	jne    8017c3 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ef:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	48 89 ce             	mov    %rcx,%rsi
  8017fa:	48 89 c7             	mov    %rax,%rdi
  8017fd:	48 b8 6c 12 80 00 00 	movabs $0x80126c,%rax
  801804:	00 00 00 
  801807:	ff d0                	callq  *%rax
  801809:	85 c0                	test   %eax,%eax
  80180b:	75 b6                	jne    8017c3 <strstr+0x47>

	return (char *) (in - 1);
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	48 83 e8 01          	sub    $0x1,%rax
}
  801815:	c9                   	leaveq 
  801816:	c3                   	retq   

0000000000801817 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
  80181b:	53                   	push   %rbx
  80181c:	48 83 ec 48          	sub    $0x48,%rsp
  801820:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801823:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801826:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80182a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80182e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801832:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801836:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801839:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80183d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801841:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801845:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801849:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80184d:	4c 89 c3             	mov    %r8,%rbx
  801850:	cd 30                	int    $0x30
  801852:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801856:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80185a:	74 3e                	je     80189a <syscall+0x83>
  80185c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801861:	7e 37                	jle    80189a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801867:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80186a:	49 89 d0             	mov    %rdx,%r8
  80186d:	89 c1                	mov    %eax,%ecx
  80186f:	48 ba 68 4a 80 00 00 	movabs $0x804a68,%rdx
  801876:	00 00 00 
  801879:	be 24 00 00 00       	mov    $0x24,%esi
  80187e:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801885:	00 00 00 
  801888:	b8 00 00 00 00       	mov    $0x0,%eax
  80188d:	49 b9 ed 02 80 00 00 	movabs $0x8002ed,%r9
  801894:	00 00 00 
  801897:	41 ff d1             	callq  *%r9

	return ret;
  80189a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80189e:	48 83 c4 48          	add    $0x48,%rsp
  8018a2:	5b                   	pop    %rbx
  8018a3:	5d                   	pop    %rbp
  8018a4:	c3                   	retq   

00000000008018a5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 10          	sub    $0x10,%rsp
  8018ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bd:	48 83 ec 08          	sub    $0x8,%rsp
  8018c1:	6a 00                	pushq  $0x0
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	48 89 d1             	mov    %rdx,%rcx
  8018d2:	48 89 c2             	mov    %rax,%rdx
  8018d5:	be 00 00 00 00       	mov    $0x0,%esi
  8018da:	bf 00 00 00 00       	mov    $0x0,%edi
  8018df:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	callq  *%rax
  8018eb:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ef:	90                   	nop
  8018f0:	c9                   	leaveq 
  8018f1:	c3                   	retq   

00000000008018f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f2:	55                   	push   %rbp
  8018f3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018f6:	48 83 ec 08          	sub    $0x8,%rsp
  8018fa:	6a 00                	pushq  $0x0
  8018fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801902:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801908:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190d:	ba 00 00 00 00       	mov    $0x0,%edx
  801912:	be 00 00 00 00       	mov    $0x0,%esi
  801917:	bf 01 00 00 00       	mov    $0x1,%edi
  80191c:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
  801928:	48 83 c4 10          	add    $0x10,%rsp
}
  80192c:	c9                   	leaveq 
  80192d:	c3                   	retq   

000000000080192e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80192e:	55                   	push   %rbp
  80192f:	48 89 e5             	mov    %rsp,%rbp
  801932:	48 83 ec 10          	sub    $0x10,%rsp
  801936:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193c:	48 98                	cltq   
  80193e:	48 83 ec 08          	sub    $0x8,%rsp
  801942:	6a 00                	pushq  $0x0
  801944:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801950:	b9 00 00 00 00       	mov    $0x0,%ecx
  801955:	48 89 c2             	mov    %rax,%rdx
  801958:	be 01 00 00 00       	mov    $0x1,%esi
  80195d:	bf 03 00 00 00       	mov    $0x3,%edi
  801962:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801969:	00 00 00 
  80196c:	ff d0                	callq  *%rax
  80196e:	48 83 c4 10          	add    $0x10,%rsp
}
  801972:	c9                   	leaveq 
  801973:	c3                   	retq   

0000000000801974 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801974:	55                   	push   %rbp
  801975:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801978:	48 83 ec 08          	sub    $0x8,%rsp
  80197c:	6a 00                	pushq  $0x0
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	be 00 00 00 00       	mov    $0x0,%esi
  801999:	bf 02 00 00 00       	mov    $0x2,%edi
  80199e:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
  8019aa:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <sys_yield>:


void
sys_yield(void)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019b4:	48 83 ec 08          	sub    $0x8,%rsp
  8019b8:	6a 00                	pushq  $0x0
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	be 00 00 00 00       	mov    $0x0,%esi
  8019d5:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019da:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	callq  *%rax
  8019e6:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ea:	90                   	nop
  8019eb:	c9                   	leaveq 
  8019ec:	c3                   	retq   

00000000008019ed <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	48 83 ec 10          	sub    $0x10,%rsp
  8019f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019fc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a02:	48 63 c8             	movslq %eax,%rcx
  801a05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0c:	48 98                	cltq   
  801a0e:	48 83 ec 08          	sub    $0x8,%rsp
  801a12:	6a 00                	pushq  $0x0
  801a14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1a:	49 89 c8             	mov    %rcx,%r8
  801a1d:	48 89 d1             	mov    %rdx,%rcx
  801a20:	48 89 c2             	mov    %rax,%rdx
  801a23:	be 01 00 00 00       	mov    $0x1,%esi
  801a28:	bf 04 00 00 00       	mov    $0x4,%edi
  801a2d:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801a34:	00 00 00 
  801a37:	ff d0                	callq  *%rax
  801a39:	48 83 c4 10          	add    $0x10,%rsp
}
  801a3d:	c9                   	leaveq 
  801a3e:	c3                   	retq   

0000000000801a3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
  801a43:	48 83 ec 20          	sub    $0x20,%rsp
  801a47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a4e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a51:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a55:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a59:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a5c:	48 63 c8             	movslq %eax,%rcx
  801a5f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a66:	48 63 f0             	movslq %eax,%rsi
  801a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a70:	48 98                	cltq   
  801a72:	48 83 ec 08          	sub    $0x8,%rsp
  801a76:	51                   	push   %rcx
  801a77:	49 89 f9             	mov    %rdi,%r9
  801a7a:	49 89 f0             	mov    %rsi,%r8
  801a7d:	48 89 d1             	mov    %rdx,%rcx
  801a80:	48 89 c2             	mov    %rax,%rdx
  801a83:	be 01 00 00 00       	mov    $0x1,%esi
  801a88:	bf 05 00 00 00       	mov    $0x5,%edi
  801a8d:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
  801a99:	48 83 c4 10          	add    $0x10,%rsp
}
  801a9d:	c9                   	leaveq 
  801a9e:	c3                   	retq   

0000000000801a9f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a9f:	55                   	push   %rbp
  801aa0:	48 89 e5             	mov    %rsp,%rbp
  801aa3:	48 83 ec 10          	sub    $0x10,%rsp
  801aa7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aaa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab5:	48 98                	cltq   
  801ab7:	48 83 ec 08          	sub    $0x8,%rsp
  801abb:	6a 00                	pushq  $0x0
  801abd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac9:	48 89 d1             	mov    %rdx,%rcx
  801acc:	48 89 c2             	mov    %rax,%rdx
  801acf:	be 01 00 00 00       	mov    $0x1,%esi
  801ad4:	bf 06 00 00 00       	mov    $0x6,%edi
  801ad9:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801ae0:	00 00 00 
  801ae3:	ff d0                	callq  *%rax
  801ae5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae9:	c9                   	leaveq 
  801aea:	c3                   	retq   

0000000000801aeb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aeb:	55                   	push   %rbp
  801aec:	48 89 e5             	mov    %rsp,%rbp
  801aef:	48 83 ec 10          	sub    $0x10,%rsp
  801af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801af9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801afc:	48 63 d0             	movslq %eax,%rdx
  801aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b02:	48 98                	cltq   
  801b04:	48 83 ec 08          	sub    $0x8,%rsp
  801b08:	6a 00                	pushq  $0x0
  801b0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b16:	48 89 d1             	mov    %rdx,%rcx
  801b19:	48 89 c2             	mov    %rax,%rdx
  801b1c:	be 01 00 00 00       	mov    $0x1,%esi
  801b21:	bf 08 00 00 00       	mov    $0x8,%edi
  801b26:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	callq  *%rax
  801b32:	48 83 c4 10          	add    $0x10,%rsp
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 10          	sub    $0x10,%rsp
  801b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4e:	48 98                	cltq   
  801b50:	48 83 ec 08          	sub    $0x8,%rsp
  801b54:	6a 00                	pushq  $0x0
  801b56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b62:	48 89 d1             	mov    %rdx,%rcx
  801b65:	48 89 c2             	mov    %rax,%rdx
  801b68:	be 01 00 00 00       	mov    $0x1,%esi
  801b6d:	bf 09 00 00 00       	mov    $0x9,%edi
  801b72:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	callq  *%rax
  801b7e:	48 83 c4 10          	add    $0x10,%rsp
}
  801b82:	c9                   	leaveq 
  801b83:	c3                   	retq   

0000000000801b84 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b84:	55                   	push   %rbp
  801b85:	48 89 e5             	mov    %rsp,%rbp
  801b88:	48 83 ec 10          	sub    $0x10,%rsp
  801b8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9a:	48 98                	cltq   
  801b9c:	48 83 ec 08          	sub    $0x8,%rsp
  801ba0:	6a 00                	pushq  $0x0
  801ba2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bae:	48 89 d1             	mov    %rdx,%rcx
  801bb1:	48 89 c2             	mov    %rax,%rdx
  801bb4:	be 01 00 00 00       	mov    $0x1,%esi
  801bb9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bbe:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	callq  *%rax
  801bca:	48 83 c4 10          	add    $0x10,%rsp
}
  801bce:	c9                   	leaveq 
  801bcf:	c3                   	retq   

0000000000801bd0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bd0:	55                   	push   %rbp
  801bd1:	48 89 e5             	mov    %rsp,%rbp
  801bd4:	48 83 ec 20          	sub    $0x20,%rsp
  801bd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bdf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801be3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801be6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be9:	48 63 f0             	movslq %eax,%rsi
  801bec:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf3:	48 98                	cltq   
  801bf5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf9:	48 83 ec 08          	sub    $0x8,%rsp
  801bfd:	6a 00                	pushq  $0x0
  801bff:	49 89 f1             	mov    %rsi,%r9
  801c02:	49 89 c8             	mov    %rcx,%r8
  801c05:	48 89 d1             	mov    %rdx,%rcx
  801c08:	48 89 c2             	mov    %rax,%rdx
  801c0b:	be 00 00 00 00       	mov    $0x0,%esi
  801c10:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c15:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	callq  *%rax
  801c21:	48 83 c4 10          	add    $0x10,%rsp
}
  801c25:	c9                   	leaveq 
  801c26:	c3                   	retq   

0000000000801c27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c27:	55                   	push   %rbp
  801c28:	48 89 e5             	mov    %rsp,%rbp
  801c2b:	48 83 ec 10          	sub    $0x10,%rsp
  801c2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c37:	48 83 ec 08          	sub    $0x8,%rsp
  801c3b:	6a 00                	pushq  $0x0
  801c3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4e:	48 89 c2             	mov    %rax,%rdx
  801c51:	be 01 00 00 00       	mov    $0x1,%esi
  801c56:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c5b:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801c62:	00 00 00 
  801c65:	ff d0                	callq  *%rax
  801c67:	48 83 c4 10          	add    $0x10,%rsp
}
  801c6b:	c9                   	leaveq 
  801c6c:	c3                   	retq   

0000000000801c6d <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c6d:	55                   	push   %rbp
  801c6e:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c71:	48 83 ec 08          	sub    $0x8,%rsp
  801c75:	6a 00                	pushq  $0x0
  801c77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c88:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8d:	be 00 00 00 00       	mov    $0x0,%esi
  801c92:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c97:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
  801ca3:	48 83 c4 10          	add    $0x10,%rsp
}
  801ca7:	c9                   	leaveq 
  801ca8:	c3                   	retq   

0000000000801ca9 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801ca9:	55                   	push   %rbp
  801caa:	48 89 e5             	mov    %rsp,%rbp
  801cad:	48 83 ec 10          	sub    $0x10,%rsp
  801cb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cb5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801cb8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbf:	48 83 ec 08          	sub    $0x8,%rsp
  801cc3:	6a 00                	pushq  $0x0
  801cc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ccb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd1:	48 89 d1             	mov    %rdx,%rcx
  801cd4:	48 89 c2             	mov    %rax,%rdx
  801cd7:	be 00 00 00 00       	mov    $0x0,%esi
  801cdc:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ce1:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801ce8:	00 00 00 
  801ceb:	ff d0                	callq  *%rax
  801ced:	48 83 c4 10          	add    $0x10,%rsp
}
  801cf1:	c9                   	leaveq 
  801cf2:	c3                   	retq   

0000000000801cf3 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801cf3:	55                   	push   %rbp
  801cf4:	48 89 e5             	mov    %rsp,%rbp
  801cf7:	48 83 ec 10          	sub    $0x10,%rsp
  801cfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cff:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d02:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d09:	48 83 ec 08          	sub    $0x8,%rsp
  801d0d:	6a 00                	pushq  $0x0
  801d0f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d15:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1b:	48 89 d1             	mov    %rdx,%rcx
  801d1e:	48 89 c2             	mov    %rax,%rdx
  801d21:	be 00 00 00 00       	mov    $0x0,%esi
  801d26:	bf 10 00 00 00       	mov    $0x10,%edi
  801d2b:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	callq  *%rax
  801d37:	48 83 c4 10          	add    $0x10,%rsp
}
  801d3b:	c9                   	leaveq 
  801d3c:	c3                   	retq   

0000000000801d3d <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d3d:	55                   	push   %rbp
  801d3e:	48 89 e5             	mov    %rsp,%rbp
  801d41:	48 83 ec 20          	sub    $0x20,%rsp
  801d45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d4c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d4f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d53:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d5a:	48 63 c8             	movslq %eax,%rcx
  801d5d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d64:	48 63 f0             	movslq %eax,%rsi
  801d67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6e:	48 98                	cltq   
  801d70:	48 83 ec 08          	sub    $0x8,%rsp
  801d74:	51                   	push   %rcx
  801d75:	49 89 f9             	mov    %rdi,%r9
  801d78:	49 89 f0             	mov    %rsi,%r8
  801d7b:	48 89 d1             	mov    %rdx,%rcx
  801d7e:	48 89 c2             	mov    %rax,%rdx
  801d81:	be 00 00 00 00       	mov    $0x0,%esi
  801d86:	bf 11 00 00 00       	mov    $0x11,%edi
  801d8b:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801d92:	00 00 00 
  801d95:	ff d0                	callq  *%rax
  801d97:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d9b:	c9                   	leaveq 
  801d9c:	c3                   	retq   

0000000000801d9d <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d9d:	55                   	push   %rbp
  801d9e:	48 89 e5             	mov    %rsp,%rbp
  801da1:	48 83 ec 10          	sub    $0x10,%rsp
  801da5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801da9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db5:	48 83 ec 08          	sub    $0x8,%rsp
  801db9:	6a 00                	pushq  $0x0
  801dbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc7:	48 89 d1             	mov    %rdx,%rcx
  801dca:	48 89 c2             	mov    %rax,%rdx
  801dcd:	be 00 00 00 00       	mov    $0x0,%esi
  801dd2:	bf 12 00 00 00       	mov    $0x12,%edi
  801dd7:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	callq  *%rax
  801de3:	48 83 c4 10          	add    $0x10,%rsp
}
  801de7:	c9                   	leaveq 
  801de8:	c3                   	retq   

0000000000801de9 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801de9:	55                   	push   %rbp
  801dea:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801ded:	48 83 ec 08          	sub    $0x8,%rsp
  801df1:	6a 00                	pushq  $0x0
  801df3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e04:	ba 00 00 00 00       	mov    $0x0,%edx
  801e09:	be 00 00 00 00       	mov    $0x0,%esi
  801e0e:	bf 13 00 00 00       	mov    $0x13,%edi
  801e13:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	callq  *%rax
  801e1f:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801e23:	90                   	nop
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	48 83 ec 10          	sub    $0x10,%rsp
  801e2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e34:	48 98                	cltq   
  801e36:	48 83 ec 08          	sub    $0x8,%rsp
  801e3a:	6a 00                	pushq  $0x0
  801e3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e48:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e4d:	48 89 c2             	mov    %rax,%rdx
  801e50:	be 00 00 00 00       	mov    $0x0,%esi
  801e55:	bf 14 00 00 00       	mov    $0x14,%edi
  801e5a:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	callq  *%rax
  801e66:	48 83 c4 10          	add    $0x10,%rsp
}
  801e6a:	c9                   	leaveq 
  801e6b:	c3                   	retq   

0000000000801e6c <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801e6c:	55                   	push   %rbp
  801e6d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e70:	48 83 ec 08          	sub    $0x8,%rsp
  801e74:	6a 00                	pushq  $0x0
  801e76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e82:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e87:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8c:	be 00 00 00 00       	mov    $0x0,%esi
  801e91:	bf 15 00 00 00       	mov    $0x15,%edi
  801e96:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801e9d:	00 00 00 
  801ea0:	ff d0                	callq  *%rax
  801ea2:	48 83 c4 10          	add    $0x10,%rsp
}
  801ea6:	c9                   	leaveq 
  801ea7:	c3                   	retq   

0000000000801ea8 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801eac:	48 83 ec 08          	sub    $0x8,%rsp
  801eb0:	6a 00                	pushq  $0x0
  801eb2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ec3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec8:	be 00 00 00 00       	mov    $0x0,%esi
  801ecd:	bf 16 00 00 00       	mov    $0x16,%edi
  801ed2:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801ed9:	00 00 00 
  801edc:	ff d0                	callq  *%rax
  801ede:	48 83 c4 10          	add    $0x10,%rsp
}
  801ee2:	90                   	nop
  801ee3:	c9                   	leaveq 
  801ee4:	c3                   	retq   

0000000000801ee5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ee5:	55                   	push   %rbp
  801ee6:	48 89 e5             	mov    %rsp,%rbp
  801ee9:	48 83 ec 08          	sub    $0x8,%rsp
  801eed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ef1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801efc:	ff ff ff 
  801eff:	48 01 d0             	add    %rdx,%rax
  801f02:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 08          	sub    $0x8,%rsp
  801f10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f18:	48 89 c7             	mov    %rax,%rdi
  801f1b:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
  801f27:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f2d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f31:	c9                   	leaveq 
  801f32:	c3                   	retq   

0000000000801f33 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	48 83 ec 18          	sub    $0x18,%rsp
  801f3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f46:	eb 6b                	jmp    801fb3 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4b:	48 98                	cltq   
  801f4d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f53:	48 c1 e0 0c          	shl    $0xc,%rax
  801f57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5f:	48 c1 e8 15          	shr    $0x15,%rax
  801f63:	48 89 c2             	mov    %rax,%rdx
  801f66:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f6d:	01 00 00 
  801f70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f74:	83 e0 01             	and    $0x1,%eax
  801f77:	48 85 c0             	test   %rax,%rax
  801f7a:	74 21                	je     801f9d <fd_alloc+0x6a>
  801f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f80:	48 c1 e8 0c          	shr    $0xc,%rax
  801f84:	48 89 c2             	mov    %rax,%rdx
  801f87:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f8e:	01 00 00 
  801f91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f95:	83 e0 01             	and    $0x1,%eax
  801f98:	48 85 c0             	test   %rax,%rax
  801f9b:	75 12                	jne    801faf <fd_alloc+0x7c>
			*fd_store = fd;
  801f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fad:	eb 1a                	jmp    801fc9 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801faf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fb3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fb7:	7e 8f                	jle    801f48 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fc4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fc9:	c9                   	leaveq 
  801fca:	c3                   	retq   

0000000000801fcb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fcb:	55                   	push   %rbp
  801fcc:	48 89 e5             	mov    %rsp,%rbp
  801fcf:	48 83 ec 20          	sub    $0x20,%rsp
  801fd3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fda:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fde:	78 06                	js     801fe6 <fd_lookup+0x1b>
  801fe0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fe4:	7e 07                	jle    801fed <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fe6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801feb:	eb 6c                	jmp    802059 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff0:	48 98                	cltq   
  801ff2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ff8:	48 c1 e0 0c          	shl    $0xc,%rax
  801ffc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802004:	48 c1 e8 15          	shr    $0x15,%rax
  802008:	48 89 c2             	mov    %rax,%rdx
  80200b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802012:	01 00 00 
  802015:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802019:	83 e0 01             	and    $0x1,%eax
  80201c:	48 85 c0             	test   %rax,%rax
  80201f:	74 21                	je     802042 <fd_lookup+0x77>
  802021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802025:	48 c1 e8 0c          	shr    $0xc,%rax
  802029:	48 89 c2             	mov    %rax,%rdx
  80202c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802033:	01 00 00 
  802036:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203a:	83 e0 01             	and    $0x1,%eax
  80203d:	48 85 c0             	test   %rax,%rax
  802040:	75 07                	jne    802049 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802042:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802047:	eb 10                	jmp    802059 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802049:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802051:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802059:	c9                   	leaveq 
  80205a:	c3                   	retq   

000000000080205b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80205b:	55                   	push   %rbp
  80205c:	48 89 e5             	mov    %rsp,%rbp
  80205f:	48 83 ec 30          	sub    $0x30,%rsp
  802063:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802067:	89 f0                	mov    %esi,%eax
  802069:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80206c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802070:	48 89 c7             	mov    %rax,%rdi
  802073:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	callq  *%rax
  80207f:	89 c2                	mov    %eax,%edx
  802081:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802085:	48 89 c6             	mov    %rax,%rsi
  802088:	89 d7                	mov    %edx,%edi
  80208a:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802091:	00 00 00 
  802094:	ff d0                	callq  *%rax
  802096:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802099:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80209d:	78 0a                	js     8020a9 <fd_close+0x4e>
	    || fd != fd2)
  80209f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a3:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020a7:	74 12                	je     8020bb <fd_close+0x60>
		return (must_exist ? r : 0);
  8020a9:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020ad:	74 05                	je     8020b4 <fd_close+0x59>
  8020af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b2:	eb 70                	jmp    802124 <fd_close+0xc9>
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	eb 69                	jmp    802124 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bf:	8b 00                	mov    (%rax),%eax
  8020c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020c5:	48 89 d6             	mov    %rdx,%rsi
  8020c8:	89 c7                	mov    %eax,%edi
  8020ca:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	callq  *%rax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020dd:	78 2a                	js     802109 <fd_close+0xae>
		if (dev->dev_close)
  8020df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020e7:	48 85 c0             	test   %rax,%rax
  8020ea:	74 16                	je     802102 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8020ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020f4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020f8:	48 89 d7             	mov    %rdx,%rdi
  8020fb:	ff d0                	callq  *%rax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802100:	eb 07                	jmp    802109 <fd_close+0xae>
		else
			r = 0;
  802102:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802109:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210d:	48 89 c6             	mov    %rax,%rsi
  802110:	bf 00 00 00 00       	mov    $0x0,%edi
  802115:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  80211c:	00 00 00 
  80211f:	ff d0                	callq  *%rax
	return r;
  802121:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802124:	c9                   	leaveq 
  802125:	c3                   	retq   

0000000000802126 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	48 83 ec 20          	sub    $0x20,%rsp
  80212e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802131:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80213c:	eb 41                	jmp    80217f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80213e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802145:	00 00 00 
  802148:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80214b:	48 63 d2             	movslq %edx,%rdx
  80214e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802152:	8b 00                	mov    (%rax),%eax
  802154:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802157:	75 22                	jne    80217b <dev_lookup+0x55>
			*dev = devtab[i];
  802159:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802160:	00 00 00 
  802163:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802166:	48 63 d2             	movslq %edx,%rdx
  802169:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80216d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802171:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	eb 60                	jmp    8021db <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80217b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80217f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802186:	00 00 00 
  802189:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80218c:	48 63 d2             	movslq %edx,%rdx
  80218f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802193:	48 85 c0             	test   %rax,%rax
  802196:	75 a6                	jne    80213e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802198:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80219f:	00 00 00 
  8021a2:	48 8b 00             	mov    (%rax),%rax
  8021a5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021ae:	89 c6                	mov    %eax,%esi
  8021b0:	48 bf 98 4a 80 00 00 	movabs $0x804a98,%rdi
  8021b7:	00 00 00 
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bf:	48 b9 27 05 80 00 00 	movabs $0x800527,%rcx
  8021c6:	00 00 00 
  8021c9:	ff d1                	callq  *%rcx
	*dev = 0;
  8021cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021cf:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021db:	c9                   	leaveq 
  8021dc:	c3                   	retq   

00000000008021dd <close>:

int
close(int fdnum)
{
  8021dd:	55                   	push   %rbp
  8021de:	48 89 e5             	mov    %rsp,%rbp
  8021e1:	48 83 ec 20          	sub    $0x20,%rsp
  8021e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021ef:	48 89 d6             	mov    %rdx,%rsi
  8021f2:	89 c7                	mov    %eax,%edi
  8021f4:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  8021fb:	00 00 00 
  8021fe:	ff d0                	callq  *%rax
  802200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802207:	79 05                	jns    80220e <close+0x31>
		return r;
  802209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220c:	eb 18                	jmp    802226 <close+0x49>
	else
		return fd_close(fd, 1);
  80220e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802212:	be 01 00 00 00       	mov    $0x1,%esi
  802217:	48 89 c7             	mov    %rax,%rdi
  80221a:	48 b8 5b 20 80 00 00 	movabs $0x80205b,%rax
  802221:	00 00 00 
  802224:	ff d0                	callq  *%rax
}
  802226:	c9                   	leaveq 
  802227:	c3                   	retq   

0000000000802228 <close_all>:

void
close_all(void)
{
  802228:	55                   	push   %rbp
  802229:	48 89 e5             	mov    %rsp,%rbp
  80222c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802237:	eb 15                	jmp    80224e <close_all+0x26>
		close(i);
  802239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223c:	89 c7                	mov    %eax,%edi
  80223e:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80224a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80224e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802252:	7e e5                	jle    802239 <close_all+0x11>
		close(i);
}
  802254:	90                   	nop
  802255:	c9                   	leaveq 
  802256:	c3                   	retq   

0000000000802257 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802257:	55                   	push   %rbp
  802258:	48 89 e5             	mov    %rsp,%rbp
  80225b:	48 83 ec 40          	sub    $0x40,%rsp
  80225f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802262:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802265:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802269:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80226c:	48 89 d6             	mov    %rdx,%rsi
  80226f:	89 c7                	mov    %eax,%edi
  802271:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802278:	00 00 00 
  80227b:	ff d0                	callq  *%rax
  80227d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802280:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802284:	79 08                	jns    80228e <dup+0x37>
		return r;
  802286:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802289:	e9 70 01 00 00       	jmpq   8023fe <dup+0x1a7>
	close(newfdnum);
  80228e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802291:	89 c7                	mov    %eax,%edi
  802293:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80229f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a2:	48 98                	cltq   
  8022a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b6:	48 89 c7             	mov    %rax,%rdi
  8022b9:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8022c0:	00 00 00 
  8022c3:	ff d0                	callq  *%rax
  8022c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cd:	48 89 c7             	mov    %rax,%rdi
  8022d0:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	callq  *%rax
  8022dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e4:	48 c1 e8 15          	shr    $0x15,%rax
  8022e8:	48 89 c2             	mov    %rax,%rdx
  8022eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022f2:	01 00 00 
  8022f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f9:	83 e0 01             	and    $0x1,%eax
  8022fc:	48 85 c0             	test   %rax,%rax
  8022ff:	74 71                	je     802372 <dup+0x11b>
  802301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802305:	48 c1 e8 0c          	shr    $0xc,%rax
  802309:	48 89 c2             	mov    %rax,%rdx
  80230c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802313:	01 00 00 
  802316:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231a:	83 e0 01             	and    $0x1,%eax
  80231d:	48 85 c0             	test   %rax,%rax
  802320:	74 50                	je     802372 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802326:	48 c1 e8 0c          	shr    $0xc,%rax
  80232a:	48 89 c2             	mov    %rax,%rdx
  80232d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802334:	01 00 00 
  802337:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233b:	25 07 0e 00 00       	and    $0xe07,%eax
  802340:	89 c1                	mov    %eax,%ecx
  802342:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802346:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234a:	41 89 c8             	mov    %ecx,%r8d
  80234d:	48 89 d1             	mov    %rdx,%rcx
  802350:	ba 00 00 00 00       	mov    $0x0,%edx
  802355:	48 89 c6             	mov    %rax,%rsi
  802358:	bf 00 00 00 00       	mov    $0x0,%edi
  80235d:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  802364:	00 00 00 
  802367:	ff d0                	callq  *%rax
  802369:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802370:	78 55                	js     8023c7 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802376:	48 c1 e8 0c          	shr    $0xc,%rax
  80237a:	48 89 c2             	mov    %rax,%rdx
  80237d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802384:	01 00 00 
  802387:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238b:	25 07 0e 00 00       	and    $0xe07,%eax
  802390:	89 c1                	mov    %eax,%ecx
  802392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802396:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80239a:	41 89 c8             	mov    %ecx,%r8d
  80239d:	48 89 d1             	mov    %rdx,%rcx
  8023a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a5:	48 89 c6             	mov    %rax,%rsi
  8023a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ad:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	callq  *%rax
  8023b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c0:	78 08                	js     8023ca <dup+0x173>
		goto err;

	return newfdnum;
  8023c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023c5:	eb 37                	jmp    8023fe <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8023c7:	90                   	nop
  8023c8:	eb 01                	jmp    8023cb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8023ca:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8023cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023cf:	48 89 c6             	mov    %rax,%rsi
  8023d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d7:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  8023de:	00 00 00 
  8023e1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e7:	48 89 c6             	mov    %rax,%rsi
  8023ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ef:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
	return r;
  8023fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023fe:	c9                   	leaveq 
  8023ff:	c3                   	retq   

0000000000802400 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802400:	55                   	push   %rbp
  802401:	48 89 e5             	mov    %rsp,%rbp
  802404:	48 83 ec 40          	sub    $0x40,%rsp
  802408:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80240f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802413:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802417:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80241a:	48 89 d6             	mov    %rdx,%rsi
  80241d:	89 c7                	mov    %eax,%edi
  80241f:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802426:	00 00 00 
  802429:	ff d0                	callq  *%rax
  80242b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802432:	78 24                	js     802458 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802438:	8b 00                	mov    (%rax),%eax
  80243a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243e:	48 89 d6             	mov    %rdx,%rsi
  802441:	89 c7                	mov    %eax,%edi
  802443:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  80244a:	00 00 00 
  80244d:	ff d0                	callq  *%rax
  80244f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802452:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802456:	79 05                	jns    80245d <read+0x5d>
		return r;
  802458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245b:	eb 76                	jmp    8024d3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80245d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802461:	8b 40 08             	mov    0x8(%rax),%eax
  802464:	83 e0 03             	and    $0x3,%eax
  802467:	83 f8 01             	cmp    $0x1,%eax
  80246a:	75 3a                	jne    8024a6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80246c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802473:	00 00 00 
  802476:	48 8b 00             	mov    (%rax),%rax
  802479:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80247f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802482:	89 c6                	mov    %eax,%esi
  802484:	48 bf b7 4a 80 00 00 	movabs $0x804ab7,%rdi
  80248b:	00 00 00 
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
  802493:	48 b9 27 05 80 00 00 	movabs $0x800527,%rcx
  80249a:	00 00 00 
  80249d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80249f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a4:	eb 2d                	jmp    8024d3 <read+0xd3>
	}
	if (!dev->dev_read)
  8024a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024aa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024ae:	48 85 c0             	test   %rax,%rax
  8024b1:	75 07                	jne    8024ba <read+0xba>
		return -E_NOT_SUPP;
  8024b3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b8:	eb 19                	jmp    8024d3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024c6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024ce:	48 89 cf             	mov    %rcx,%rdi
  8024d1:	ff d0                	callq  *%rax
}
  8024d3:	c9                   	leaveq 
  8024d4:	c3                   	retq   

00000000008024d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024d5:	55                   	push   %rbp
  8024d6:	48 89 e5             	mov    %rsp,%rbp
  8024d9:	48 83 ec 30          	sub    $0x30,%rsp
  8024dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024ef:	eb 47                	jmp    802538 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f4:	48 98                	cltq   
  8024f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024fa:	48 29 c2             	sub    %rax,%rdx
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	48 63 c8             	movslq %eax,%rcx
  802503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802507:	48 01 c1             	add    %rax,%rcx
  80250a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250d:	48 89 ce             	mov    %rcx,%rsi
  802510:	89 c7                	mov    %eax,%edi
  802512:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  802519:	00 00 00 
  80251c:	ff d0                	callq  *%rax
  80251e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802521:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802525:	79 05                	jns    80252c <readn+0x57>
			return m;
  802527:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80252a:	eb 1d                	jmp    802549 <readn+0x74>
		if (m == 0)
  80252c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802530:	74 13                	je     802545 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802532:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802535:	01 45 fc             	add    %eax,-0x4(%rbp)
  802538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253b:	48 98                	cltq   
  80253d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802541:	72 ae                	jb     8024f1 <readn+0x1c>
  802543:	eb 01                	jmp    802546 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802545:	90                   	nop
	}
	return tot;
  802546:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802549:	c9                   	leaveq 
  80254a:	c3                   	retq   

000000000080254b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80254b:	55                   	push   %rbp
  80254c:	48 89 e5             	mov    %rsp,%rbp
  80254f:	48 83 ec 40          	sub    $0x40,%rsp
  802553:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802556:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80255a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80255e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802562:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802565:	48 89 d6             	mov    %rdx,%rsi
  802568:	89 c7                	mov    %eax,%edi
  80256a:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax
  802576:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257d:	78 24                	js     8025a3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	8b 00                	mov    (%rax),%eax
  802585:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802589:	48 89 d6             	mov    %rdx,%rsi
  80258c:	89 c7                	mov    %eax,%edi
  80258e:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
  80259a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a1:	79 05                	jns    8025a8 <write+0x5d>
		return r;
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	eb 75                	jmp    80261d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ac:	8b 40 08             	mov    0x8(%rax),%eax
  8025af:	83 e0 03             	and    $0x3,%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	75 3a                	jne    8025f0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025b6:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8025bd:	00 00 00 
  8025c0:	48 8b 00             	mov    (%rax),%rax
  8025c3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025cc:	89 c6                	mov    %eax,%esi
  8025ce:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
  8025d5:	00 00 00 
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	48 b9 27 05 80 00 00 	movabs $0x800527,%rcx
  8025e4:	00 00 00 
  8025e7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ee:	eb 2d                	jmp    80261d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025f8:	48 85 c0             	test   %rax,%rax
  8025fb:	75 07                	jne    802604 <write+0xb9>
		return -E_NOT_SUPP;
  8025fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802602:	eb 19                	jmp    80261d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802608:	48 8b 40 18          	mov    0x18(%rax),%rax
  80260c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802610:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802614:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802618:	48 89 cf             	mov    %rcx,%rdi
  80261b:	ff d0                	callq  *%rax
}
  80261d:	c9                   	leaveq 
  80261e:	c3                   	retq   

000000000080261f <seek>:

int
seek(int fdnum, off_t offset)
{
  80261f:	55                   	push   %rbp
  802620:	48 89 e5             	mov    %rsp,%rbp
  802623:	48 83 ec 18          	sub    $0x18,%rsp
  802627:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80262a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80262d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802631:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802634:	48 89 d6             	mov    %rdx,%rsi
  802637:	89 c7                	mov    %eax,%edi
  802639:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802640:	00 00 00 
  802643:	ff d0                	callq  *%rax
  802645:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802648:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264c:	79 05                	jns    802653 <seek+0x34>
		return r;
  80264e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802651:	eb 0f                	jmp    802662 <seek+0x43>
	fd->fd_offset = offset;
  802653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802657:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80265a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802662:	c9                   	leaveq 
  802663:	c3                   	retq   

0000000000802664 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802664:	55                   	push   %rbp
  802665:	48 89 e5             	mov    %rsp,%rbp
  802668:	48 83 ec 30          	sub    $0x30,%rsp
  80266c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80266f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802672:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802676:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802679:	48 89 d6             	mov    %rdx,%rsi
  80267c:	89 c7                	mov    %eax,%edi
  80267e:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802691:	78 24                	js     8026b7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802697:	8b 00                	mov    (%rax),%eax
  802699:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80269d:	48 89 d6             	mov    %rdx,%rsi
  8026a0:	89 c7                	mov    %eax,%edi
  8026a2:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
  8026ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b5:	79 05                	jns    8026bc <ftruncate+0x58>
		return r;
  8026b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ba:	eb 72                	jmp    80272e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c0:	8b 40 08             	mov    0x8(%rax),%eax
  8026c3:	83 e0 03             	and    $0x3,%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	75 3a                	jne    802704 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026ca:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8026d1:	00 00 00 
  8026d4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026d7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026dd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026e0:	89 c6                	mov    %eax,%esi
  8026e2:	48 bf f0 4a 80 00 00 	movabs $0x804af0,%rdi
  8026e9:	00 00 00 
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f1:	48 b9 27 05 80 00 00 	movabs $0x800527,%rcx
  8026f8:	00 00 00 
  8026fb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802702:	eb 2a                	jmp    80272e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802708:	48 8b 40 30          	mov    0x30(%rax),%rax
  80270c:	48 85 c0             	test   %rax,%rax
  80270f:	75 07                	jne    802718 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802711:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802716:	eb 16                	jmp    80272e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802720:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802724:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802727:	89 ce                	mov    %ecx,%esi
  802729:	48 89 d7             	mov    %rdx,%rdi
  80272c:	ff d0                	callq  *%rax
}
  80272e:	c9                   	leaveq 
  80272f:	c3                   	retq   

0000000000802730 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802730:	55                   	push   %rbp
  802731:	48 89 e5             	mov    %rsp,%rbp
  802734:	48 83 ec 30          	sub    $0x30,%rsp
  802738:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80273b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80273f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802743:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802746:	48 89 d6             	mov    %rdx,%rsi
  802749:	89 c7                	mov    %eax,%edi
  80274b:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802752:	00 00 00 
  802755:	ff d0                	callq  *%rax
  802757:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80275a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275e:	78 24                	js     802784 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802764:	8b 00                	mov    (%rax),%eax
  802766:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80276a:	48 89 d6             	mov    %rdx,%rsi
  80276d:	89 c7                	mov    %eax,%edi
  80276f:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802782:	79 05                	jns    802789 <fstat+0x59>
		return r;
  802784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802787:	eb 5e                	jmp    8027e7 <fstat+0xb7>
	if (!dev->dev_stat)
  802789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802791:	48 85 c0             	test   %rax,%rax
  802794:	75 07                	jne    80279d <fstat+0x6d>
		return -E_NOT_SUPP;
  802796:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80279b:	eb 4a                	jmp    8027e7 <fstat+0xb7>
	stat->st_name[0] = 0;
  80279d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027a1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027a8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027af:	00 00 00 
	stat->st_isdir = 0;
  8027b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027b6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027bd:	00 00 00 
	stat->st_dev = dev;
  8027c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027df:	48 89 ce             	mov    %rcx,%rsi
  8027e2:	48 89 d7             	mov    %rdx,%rdi
  8027e5:	ff d0                	callq  *%rax
}
  8027e7:	c9                   	leaveq 
  8027e8:	c3                   	retq   

00000000008027e9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027e9:	55                   	push   %rbp
  8027ea:	48 89 e5             	mov    %rsp,%rbp
  8027ed:	48 83 ec 20          	sub    $0x20,%rsp
  8027f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fd:	be 00 00 00 00       	mov    $0x0,%esi
  802802:	48 89 c7             	mov    %rax,%rdi
  802805:	48 b8 d9 28 80 00 00 	movabs $0x8028d9,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
  802811:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802814:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802818:	79 05                	jns    80281f <stat+0x36>
		return fd;
  80281a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281d:	eb 2f                	jmp    80284e <stat+0x65>
	r = fstat(fd, stat);
  80281f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802826:	48 89 d6             	mov    %rdx,%rsi
  802829:	89 c7                	mov    %eax,%edi
  80282b:	48 b8 30 27 80 00 00 	movabs $0x802730,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
  802837:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80283a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283d:	89 c7                	mov    %eax,%edi
  80283f:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
	return r;
  80284b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80284e:	c9                   	leaveq 
  80284f:	c3                   	retq   

0000000000802850 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802850:	55                   	push   %rbp
  802851:	48 89 e5             	mov    %rsp,%rbp
  802854:	48 83 ec 10          	sub    $0x10,%rsp
  802858:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80285b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80285f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802866:	00 00 00 
  802869:	8b 00                	mov    (%rax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	75 1f                	jne    80288e <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80286f:	bf 01 00 00 00       	mov    $0x1,%edi
  802874:	48 b8 ef 43 80 00 00 	movabs $0x8043ef,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	callq  *%rax
  802880:	89 c2                	mov    %eax,%edx
  802882:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802889:	00 00 00 
  80288c:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80288e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802895:	00 00 00 
  802898:	8b 00                	mov    (%rax),%eax
  80289a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80289d:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028a2:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8028a9:	00 00 00 
  8028ac:	89 c7                	mov    %eax,%edi
  8028ae:	48 b8 5a 43 80 00 00 	movabs $0x80435a,%rax
  8028b5:	00 00 00 
  8028b8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028be:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c3:	48 89 c6             	mov    %rax,%rsi
  8028c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028cb:	48 b8 99 42 80 00 00 	movabs $0x804299,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
}
  8028d7:	c9                   	leaveq 
  8028d8:	c3                   	retq   

00000000008028d9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028d9:	55                   	push   %rbp
  8028da:	48 89 e5             	mov    %rsp,%rbp
  8028dd:	48 83 ec 20          	sub    $0x20,%rsp
  8028e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028e5:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8028e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ec:	48 89 c7             	mov    %rax,%rdi
  8028ef:	48 b8 4b 10 80 00 00 	movabs $0x80104b,%rax
  8028f6:	00 00 00 
  8028f9:	ff d0                	callq  *%rax
  8028fb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802900:	7e 0a                	jle    80290c <open+0x33>
		return -E_BAD_PATH;
  802902:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802907:	e9 a5 00 00 00       	jmpq   8029b1 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80290c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802910:	48 89 c7             	mov    %rax,%rdi
  802913:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	callq  *%rax
  80291f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802926:	79 08                	jns    802930 <open+0x57>
		return r;
  802928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292b:	e9 81 00 00 00       	jmpq   8029b1 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	48 89 c6             	mov    %rax,%rsi
  802937:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80293e:	00 00 00 
  802941:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  802948:	00 00 00 
  80294b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80294d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802954:	00 00 00 
  802957:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80295a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802964:	48 89 c6             	mov    %rax,%rsi
  802967:	bf 01 00 00 00       	mov    $0x1,%edi
  80296c:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802973:	00 00 00 
  802976:	ff d0                	callq  *%rax
  802978:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297f:	79 1d                	jns    80299e <open+0xc5>
		fd_close(fd, 0);
  802981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802985:	be 00 00 00 00       	mov    $0x0,%esi
  80298a:	48 89 c7             	mov    %rax,%rdi
  80298d:	48 b8 5b 20 80 00 00 	movabs $0x80205b,%rax
  802994:	00 00 00 
  802997:	ff d0                	callq  *%rax
		return r;
  802999:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299c:	eb 13                	jmp    8029b1 <open+0xd8>
	}

	return fd2num(fd);
  80299e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a2:	48 89 c7             	mov    %rax,%rdi
  8029a5:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax

}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 10          	sub    $0x10,%rsp
  8029bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c3:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8029cd:	00 00 00 
  8029d0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029d2:	be 00 00 00 00       	mov    $0x0,%esi
  8029d7:	bf 06 00 00 00       	mov    $0x6,%edi
  8029dc:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  8029e3:	00 00 00 
  8029e6:	ff d0                	callq  *%rax
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	48 83 ec 30          	sub    $0x30,%rsp
  8029f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a02:	8b 50 0c             	mov    0xc(%rax),%edx
  802a05:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a0c:	00 00 00 
  802a0f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a11:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a18:	00 00 00 
  802a1b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a1f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802a23:	be 00 00 00 00       	mov    $0x0,%esi
  802a28:	bf 03 00 00 00       	mov    $0x3,%edi
  802a2d:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802a34:	00 00 00 
  802a37:	ff d0                	callq  *%rax
  802a39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a40:	79 08                	jns    802a4a <devfile_read+0x60>
		return r;
  802a42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a45:	e9 a4 00 00 00       	jmpq   802aee <devfile_read+0x104>
	assert(r <= n);
  802a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4d:	48 98                	cltq   
  802a4f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a53:	76 35                	jbe    802a8a <devfile_read+0xa0>
  802a55:	48 b9 16 4b 80 00 00 	movabs $0x804b16,%rcx
  802a5c:	00 00 00 
  802a5f:	48 ba 1d 4b 80 00 00 	movabs $0x804b1d,%rdx
  802a66:	00 00 00 
  802a69:	be 86 00 00 00       	mov    $0x86,%esi
  802a6e:	48 bf 32 4b 80 00 00 	movabs $0x804b32,%rdi
  802a75:	00 00 00 
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7d:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  802a84:	00 00 00 
  802a87:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802a8a:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802a91:	7e 35                	jle    802ac8 <devfile_read+0xde>
  802a93:	48 b9 3d 4b 80 00 00 	movabs $0x804b3d,%rcx
  802a9a:	00 00 00 
  802a9d:	48 ba 1d 4b 80 00 00 	movabs $0x804b1d,%rdx
  802aa4:	00 00 00 
  802aa7:	be 87 00 00 00       	mov    $0x87,%esi
  802aac:	48 bf 32 4b 80 00 00 	movabs $0x804b32,%rdi
  802ab3:	00 00 00 
  802ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  802abb:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  802ac2:	00 00 00 
  802ac5:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acb:	48 63 d0             	movslq %eax,%rdx
  802ace:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad2:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802ad9:	00 00 00 
  802adc:	48 89 c7             	mov    %rax,%rdi
  802adf:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
	return r;
  802aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802aee:	c9                   	leaveq 
  802aef:	c3                   	retq   

0000000000802af0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802af0:	55                   	push   %rbp
  802af1:	48 89 e5             	mov    %rsp,%rbp
  802af4:	48 83 ec 40          	sub    $0x40,%rsp
  802af8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802afc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b00:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802b04:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b0c:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802b13:	00 
  802b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b18:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802b1c:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802b21:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b29:	8b 50 0c             	mov    0xc(%rax),%edx
  802b2c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b33:	00 00 00 
  802b36:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b38:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b3f:	00 00 00 
  802b42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b46:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802b4a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b52:	48 89 c6             	mov    %rax,%rsi
  802b55:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802b5c:	00 00 00 
  802b5f:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b6b:	be 00 00 00 00       	mov    $0x0,%esi
  802b70:	bf 04 00 00 00       	mov    $0x4,%edi
  802b75:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b84:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b88:	79 05                	jns    802b8f <devfile_write+0x9f>
		return r;
  802b8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8d:	eb 43                	jmp    802bd2 <devfile_write+0xe2>
	assert(r <= n);
  802b8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b92:	48 98                	cltq   
  802b94:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802b98:	76 35                	jbe    802bcf <devfile_write+0xdf>
  802b9a:	48 b9 16 4b 80 00 00 	movabs $0x804b16,%rcx
  802ba1:	00 00 00 
  802ba4:	48 ba 1d 4b 80 00 00 	movabs $0x804b1d,%rdx
  802bab:	00 00 00 
  802bae:	be a2 00 00 00       	mov    $0xa2,%esi
  802bb3:	48 bf 32 4b 80 00 00 	movabs $0x804b32,%rdi
  802bba:	00 00 00 
  802bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc2:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  802bc9:	00 00 00 
  802bcc:	41 ff d0             	callq  *%r8
	return r;
  802bcf:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802bd2:	c9                   	leaveq 
  802bd3:	c3                   	retq   

0000000000802bd4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802bd4:	55                   	push   %rbp
  802bd5:	48 89 e5             	mov    %rsp,%rbp
  802bd8:	48 83 ec 20          	sub    $0x20,%rsp
  802bdc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be8:	8b 50 0c             	mov    0xc(%rax),%edx
  802beb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802bf2:	00 00 00 
  802bf5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bf7:	be 00 00 00 00       	mov    $0x0,%esi
  802bfc:	bf 05 00 00 00       	mov    $0x5,%edi
  802c01:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c14:	79 05                	jns    802c1b <devfile_stat+0x47>
		return r;
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c19:	eb 56                	jmp    802c71 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c1f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802c26:	00 00 00 
  802c29:	48 89 c7             	mov    %rax,%rdi
  802c2c:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c38:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c3f:	00 00 00 
  802c42:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c4c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c52:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c59:	00 00 00 
  802c5c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c66:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c71:	c9                   	leaveq 
  802c72:	c3                   	retq   

0000000000802c73 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c73:	55                   	push   %rbp
  802c74:	48 89 e5             	mov    %rsp,%rbp
  802c77:	48 83 ec 10          	sub    $0x10,%rsp
  802c7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c7f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c86:	8b 50 0c             	mov    0xc(%rax),%edx
  802c89:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c90:	00 00 00 
  802c93:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c95:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c9c:	00 00 00 
  802c9f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ca2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ca5:	be 00 00 00 00       	mov    $0x0,%esi
  802caa:	bf 02 00 00 00       	mov    $0x2,%edi
  802caf:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
}
  802cbb:	c9                   	leaveq 
  802cbc:	c3                   	retq   

0000000000802cbd <remove>:

// Delete a file
int
remove(const char *path)
{
  802cbd:	55                   	push   %rbp
  802cbe:	48 89 e5             	mov    %rsp,%rbp
  802cc1:	48 83 ec 10          	sub    $0x10,%rsp
  802cc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ccd:	48 89 c7             	mov    %rax,%rdi
  802cd0:	48 b8 4b 10 80 00 00 	movabs $0x80104b,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
  802cdc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ce1:	7e 07                	jle    802cea <remove+0x2d>
		return -E_BAD_PATH;
  802ce3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ce8:	eb 33                	jmp    802d1d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cee:	48 89 c6             	mov    %rax,%rsi
  802cf1:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802cf8:	00 00 00 
  802cfb:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d07:	be 00 00 00 00       	mov    $0x0,%esi
  802d0c:	bf 07 00 00 00       	mov    $0x7,%edi
  802d11:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
}
  802d1d:	c9                   	leaveq 
  802d1e:	c3                   	retq   

0000000000802d1f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d1f:	55                   	push   %rbp
  802d20:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d23:	be 00 00 00 00       	mov    $0x0,%esi
  802d28:	bf 08 00 00 00       	mov    $0x8,%edi
  802d2d:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
}
  802d39:	5d                   	pop    %rbp
  802d3a:	c3                   	retq   

0000000000802d3b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d3b:	55                   	push   %rbp
  802d3c:	48 89 e5             	mov    %rsp,%rbp
  802d3f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d46:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d4d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d54:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d5b:	be 00 00 00 00       	mov    $0x0,%esi
  802d60:	48 89 c7             	mov    %rax,%rdi
  802d63:	48 b8 d9 28 80 00 00 	movabs $0x8028d9,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d76:	79 28                	jns    802da0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7b:	89 c6                	mov    %eax,%esi
  802d7d:	48 bf 49 4b 80 00 00 	movabs $0x804b49,%rdi
  802d84:	00 00 00 
  802d87:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8c:	48 ba 27 05 80 00 00 	movabs $0x800527,%rdx
  802d93:	00 00 00 
  802d96:	ff d2                	callq  *%rdx
		return fd_src;
  802d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9b:	e9 76 01 00 00       	jmpq   802f16 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802da0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802da7:	be 01 01 00 00       	mov    $0x101,%esi
  802dac:	48 89 c7             	mov    %rax,%rdi
  802daf:	48 b8 d9 28 80 00 00 	movabs $0x8028d9,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	callq  *%rax
  802dbb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802dbe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dc2:	0f 89 ad 00 00 00    	jns    802e75 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802dc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dcb:	89 c6                	mov    %eax,%esi
  802dcd:	48 bf 5f 4b 80 00 00 	movabs $0x804b5f,%rdi
  802dd4:	00 00 00 
  802dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddc:	48 ba 27 05 80 00 00 	movabs $0x800527,%rdx
  802de3:	00 00 00 
  802de6:	ff d2                	callq  *%rdx
		close(fd_src);
  802de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802deb:	89 c7                	mov    %eax,%edi
  802ded:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
		return fd_dest;
  802df9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dfc:	e9 15 01 00 00       	jmpq   802f16 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802e01:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e04:	48 63 d0             	movslq %eax,%rdx
  802e07:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e11:	48 89 ce             	mov    %rcx,%rsi
  802e14:	89 c7                	mov    %eax,%edi
  802e16:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  802e1d:	00 00 00 
  802e20:	ff d0                	callq  *%rax
  802e22:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e29:	79 4a                	jns    802e75 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802e2b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e2e:	89 c6                	mov    %eax,%esi
  802e30:	48 bf 79 4b 80 00 00 	movabs $0x804b79,%rdi
  802e37:	00 00 00 
  802e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3f:	48 ba 27 05 80 00 00 	movabs $0x800527,%rdx
  802e46:	00 00 00 
  802e49:	ff d2                	callq  *%rdx
			close(fd_src);
  802e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4e:	89 c7                	mov    %eax,%edi
  802e50:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
			close(fd_dest);
  802e5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e5f:	89 c7                	mov    %eax,%edi
  802e61:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	callq  *%rax
			return write_size;
  802e6d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e70:	e9 a1 00 00 00       	jmpq   802f16 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e75:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7f:	ba 00 02 00 00       	mov    $0x200,%edx
  802e84:	48 89 ce             	mov    %rcx,%rsi
  802e87:	89 c7                	mov    %eax,%edi
  802e89:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	callq  *%rax
  802e95:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e9c:	0f 8f 5f ff ff ff    	jg     802e01 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ea6:	79 47                	jns    802eef <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eab:	89 c6                	mov    %eax,%esi
  802ead:	48 bf 8c 4b 80 00 00 	movabs $0x804b8c,%rdi
  802eb4:	00 00 00 
  802eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebc:	48 ba 27 05 80 00 00 	movabs $0x800527,%rdx
  802ec3:	00 00 00 
  802ec6:	ff d2                	callq  *%rdx
		close(fd_src);
  802ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecb:	89 c7                	mov    %eax,%edi
  802ecd:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802ed4:	00 00 00 
  802ed7:	ff d0                	callq  *%rax
		close(fd_dest);
  802ed9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802edc:	89 c7                	mov    %eax,%edi
  802ede:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
		return read_size;
  802eea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eed:	eb 27                	jmp    802f16 <copy+0x1db>
	}
	close(fd_src);
  802eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef2:	89 c7                	mov    %eax,%edi
  802ef4:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
	close(fd_dest);
  802f00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f03:	89 c7                	mov    %eax,%edi
  802f05:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
	return 0;
  802f11:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f16:	c9                   	leaveq 
  802f17:	c3                   	retq   

0000000000802f18 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802f18:	55                   	push   %rbp
  802f19:	48 89 e5             	mov    %rsp,%rbp
  802f1c:	48 83 ec 20          	sub    $0x20,%rsp
  802f20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f28:	8b 40 0c             	mov    0xc(%rax),%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	7e 67                	jle    802f96 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f33:	8b 40 04             	mov    0x4(%rax),%eax
  802f36:	48 63 d0             	movslq %eax,%rdx
  802f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802f41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f45:	8b 00                	mov    (%rax),%eax
  802f47:	48 89 ce             	mov    %rcx,%rsi
  802f4a:	89 c7                	mov    %eax,%edi
  802f4c:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  802f53:	00 00 00 
  802f56:	ff d0                	callq  *%rax
  802f58:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802f5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5f:	7e 13                	jle    802f74 <writebuf+0x5c>
			b->result += result;
  802f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f65:	8b 50 08             	mov    0x8(%rax),%edx
  802f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6b:	01 c2                	add    %eax,%edx
  802f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f71:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f78:	8b 40 04             	mov    0x4(%rax),%eax
  802f7b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f7e:	74 16                	je     802f96 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802f80:	b8 00 00 00 00       	mov    $0x0,%eax
  802f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f89:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f8d:	89 c2                	mov    %eax,%edx
  802f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f93:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f96:	90                   	nop
  802f97:	c9                   	leaveq 
  802f98:	c3                   	retq   

0000000000802f99 <putch>:

static void
putch(int ch, void *thunk)
{
  802f99:	55                   	push   %rbp
  802f9a:	48 89 e5             	mov    %rsp,%rbp
  802f9d:	48 83 ec 20          	sub    $0x20,%rsp
  802fa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802fa8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb4:	8b 40 04             	mov    0x4(%rax),%eax
  802fb7:	8d 48 01             	lea    0x1(%rax),%ecx
  802fba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fbe:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802fc1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fc4:	89 d1                	mov    %edx,%ecx
  802fc6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fca:	48 98                	cltq   
  802fcc:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd4:	8b 40 04             	mov    0x4(%rax),%eax
  802fd7:	3d 00 01 00 00       	cmp    $0x100,%eax
  802fdc:	75 1e                	jne    802ffc <putch+0x63>
		writebuf(b);
  802fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe2:	48 89 c7             	mov    %rax,%rdi
  802fe5:	48 b8 18 2f 80 00 00 	movabs $0x802f18,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
		b->idx = 0;
  802ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802ffc:	90                   	nop
  802ffd:	c9                   	leaveq 
  802ffe:	c3                   	retq   

0000000000802fff <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802fff:	55                   	push   %rbp
  803000:	48 89 e5             	mov    %rsp,%rbp
  803003:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80300a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803010:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803017:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80301e:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803024:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80302a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803031:	00 00 00 
	b.result = 0;
  803034:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  80303b:	00 00 00 
	b.error = 1;
  80303e:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  803045:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803048:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80304f:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803056:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80305d:	48 89 c6             	mov    %rax,%rsi
  803060:	48 bf 99 2f 80 00 00 	movabs $0x802f99,%rdi
  803067:	00 00 00 
  80306a:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803076:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	7e 16                	jle    803096 <vfprintf+0x97>
		writebuf(&b);
  803080:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803087:	48 89 c7             	mov    %rax,%rdi
  80308a:	48 b8 18 2f 80 00 00 	movabs $0x802f18,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803096:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 08                	je     8030a8 <vfprintf+0xa9>
  8030a0:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8030a6:	eb 06                	jmp    8030ae <vfprintf+0xaf>
  8030a8:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8030ae:	c9                   	leaveq 
  8030af:	c3                   	retq   

00000000008030b0 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8030b0:	55                   	push   %rbp
  8030b1:	48 89 e5             	mov    %rsp,%rbp
  8030b4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030bb:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8030c1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8030c8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8030cf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030d6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030dd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030e4:	84 c0                	test   %al,%al
  8030e6:	74 20                	je     803108 <fprintf+0x58>
  8030e8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030ec:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030f0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030f4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030f8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030fc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803100:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803104:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803108:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80310f:	00 00 00 
  803112:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803119:	00 00 00 
  80311c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803120:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803127:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80312e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803135:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80313c:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803143:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803149:	48 89 ce             	mov    %rcx,%rsi
  80314c:	89 c7                	mov    %eax,%edi
  80314e:	48 b8 ff 2f 80 00 00 	movabs $0x802fff,%rax
  803155:	00 00 00 
  803158:	ff d0                	callq  *%rax
  80315a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803160:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803166:	c9                   	leaveq 
  803167:	c3                   	retq   

0000000000803168 <printf>:

int
printf(const char *fmt, ...)
{
  803168:	55                   	push   %rbp
  803169:	48 89 e5             	mov    %rsp,%rbp
  80316c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803173:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80317a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803181:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803188:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80318f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803196:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80319d:	84 c0                	test   %al,%al
  80319f:	74 20                	je     8031c1 <printf+0x59>
  8031a1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031a5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031a9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8031ad:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8031b1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8031b5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8031b9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8031bd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8031c1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8031c8:	00 00 00 
  8031cb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8031d2:	00 00 00 
  8031d5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031d9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8031e0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8031e7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  8031ee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031f5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8031fc:	48 89 c6             	mov    %rax,%rsi
  8031ff:	bf 01 00 00 00       	mov    $0x1,%edi
  803204:	48 b8 ff 2f 80 00 00 	movabs $0x802fff,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  803216:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80321c:	c9                   	leaveq 
  80321d:	c3                   	retq   

000000000080321e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80321e:	55                   	push   %rbp
  80321f:	48 89 e5             	mov    %rsp,%rbp
  803222:	48 83 ec 20          	sub    $0x20,%rsp
  803226:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803229:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80322d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803230:	48 89 d6             	mov    %rdx,%rsi
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
  803241:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803244:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803248:	79 05                	jns    80324f <fd2sockid+0x31>
		return r;
  80324a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324d:	eb 24                	jmp    803273 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80324f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803253:	8b 10                	mov    (%rax),%edx
  803255:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80325c:	00 00 00 
  80325f:	8b 00                	mov    (%rax),%eax
  803261:	39 c2                	cmp    %eax,%edx
  803263:	74 07                	je     80326c <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803265:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80326a:	eb 07                	jmp    803273 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80326c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803270:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803273:	c9                   	leaveq 
  803274:	c3                   	retq   

0000000000803275 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803275:	55                   	push   %rbp
  803276:	48 89 e5             	mov    %rsp,%rbp
  803279:	48 83 ec 20          	sub    $0x20,%rsp
  80327d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803280:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803284:	48 89 c7             	mov    %rax,%rdi
  803287:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803296:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329a:	78 26                	js     8032c2 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80329c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a0:	ba 07 04 00 00       	mov    $0x407,%edx
  8032a5:	48 89 c6             	mov    %rax,%rsi
  8032a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ad:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
  8032b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c0:	79 16                	jns    8032d8 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032c5:	89 c7                	mov    %eax,%edi
  8032c7:	48 b8 84 37 80 00 00 	movabs $0x803784,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
		return r;
  8032d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d6:	eb 3a                	jmp    803312 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032dc:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032e3:	00 00 00 
  8032e6:	8b 12                	mov    (%rdx),%edx
  8032e8:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032fc:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803303:	48 89 c7             	mov    %rax,%rdi
  803306:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  80330d:	00 00 00 
  803310:	ff d0                	callq  *%rax
}
  803312:	c9                   	leaveq 
  803313:	c3                   	retq   

0000000000803314 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803314:	55                   	push   %rbp
  803315:	48 89 e5             	mov    %rsp,%rbp
  803318:	48 83 ec 30          	sub    $0x30,%rsp
  80331c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80331f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803323:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803327:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80332a:	89 c7                	mov    %eax,%edi
  80332c:	48 b8 1e 32 80 00 00 	movabs $0x80321e,%rax
  803333:	00 00 00 
  803336:	ff d0                	callq  *%rax
  803338:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333f:	79 05                	jns    803346 <accept+0x32>
		return r;
  803341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803344:	eb 3b                	jmp    803381 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803346:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80334a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80334e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803351:	48 89 ce             	mov    %rcx,%rsi
  803354:	89 c7                	mov    %eax,%edi
  803356:	48 b8 61 36 80 00 00 	movabs $0x803661,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
  803362:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803369:	79 05                	jns    803370 <accept+0x5c>
		return r;
  80336b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336e:	eb 11                	jmp    803381 <accept+0x6d>
	return alloc_sockfd(r);
  803370:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803373:	89 c7                	mov    %eax,%edi
  803375:	48 b8 75 32 80 00 00 	movabs $0x803275,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
}
  803381:	c9                   	leaveq 
  803382:	c3                   	retq   

0000000000803383 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803383:	55                   	push   %rbp
  803384:	48 89 e5             	mov    %rsp,%rbp
  803387:	48 83 ec 20          	sub    $0x20,%rsp
  80338b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80338e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803392:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803395:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803398:	89 c7                	mov    %eax,%edi
  80339a:	48 b8 1e 32 80 00 00 	movabs $0x80321e,%rax
  8033a1:	00 00 00 
  8033a4:	ff d0                	callq  *%rax
  8033a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ad:	79 05                	jns    8033b4 <bind+0x31>
		return r;
  8033af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b2:	eb 1b                	jmp    8033cf <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033be:	48 89 ce             	mov    %rcx,%rsi
  8033c1:	89 c7                	mov    %eax,%edi
  8033c3:	48 b8 e0 36 80 00 00 	movabs $0x8036e0,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
}
  8033cf:	c9                   	leaveq 
  8033d0:	c3                   	retq   

00000000008033d1 <shutdown>:

int
shutdown(int s, int how)
{
  8033d1:	55                   	push   %rbp
  8033d2:	48 89 e5             	mov    %rsp,%rbp
  8033d5:	48 83 ec 20          	sub    $0x20,%rsp
  8033d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033dc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e2:	89 c7                	mov    %eax,%edi
  8033e4:	48 b8 1e 32 80 00 00 	movabs $0x80321e,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
  8033f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f7:	79 05                	jns    8033fe <shutdown+0x2d>
		return r;
  8033f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fc:	eb 16                	jmp    803414 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803404:	89 d6                	mov    %edx,%esi
  803406:	89 c7                	mov    %eax,%edi
  803408:	48 b8 44 37 80 00 00 	movabs $0x803744,%rax
  80340f:	00 00 00 
  803412:	ff d0                	callq  *%rax
}
  803414:	c9                   	leaveq 
  803415:	c3                   	retq   

0000000000803416 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803416:	55                   	push   %rbp
  803417:	48 89 e5             	mov    %rsp,%rbp
  80341a:	48 83 ec 10          	sub    $0x10,%rsp
  80341e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803426:	48 89 c7             	mov    %rax,%rdi
  803429:	48 b8 60 44 80 00 00 	movabs $0x804460,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	83 f8 01             	cmp    $0x1,%eax
  803438:	75 17                	jne    803451 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80343a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343e:	8b 40 0c             	mov    0xc(%rax),%eax
  803441:	89 c7                	mov    %eax,%edi
  803443:	48 b8 84 37 80 00 00 	movabs $0x803784,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
  80344f:	eb 05                	jmp    803456 <devsock_close+0x40>
	else
		return 0;
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803456:	c9                   	leaveq 
  803457:	c3                   	retq   

0000000000803458 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803458:	55                   	push   %rbp
  803459:	48 89 e5             	mov    %rsp,%rbp
  80345c:	48 83 ec 20          	sub    $0x20,%rsp
  803460:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803463:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803467:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80346a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80346d:	89 c7                	mov    %eax,%edi
  80346f:	48 b8 1e 32 80 00 00 	movabs $0x80321e,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803482:	79 05                	jns    803489 <connect+0x31>
		return r;
  803484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803487:	eb 1b                	jmp    8034a4 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803489:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80348c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803493:	48 89 ce             	mov    %rcx,%rsi
  803496:	89 c7                	mov    %eax,%edi
  803498:	48 b8 b1 37 80 00 00 	movabs $0x8037b1,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
}
  8034a4:	c9                   	leaveq 
  8034a5:	c3                   	retq   

00000000008034a6 <listen>:

int
listen(int s, int backlog)
{
  8034a6:	55                   	push   %rbp
  8034a7:	48 89 e5             	mov    %rsp,%rbp
  8034aa:	48 83 ec 20          	sub    $0x20,%rsp
  8034ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b7:	89 c7                	mov    %eax,%edi
  8034b9:	48 b8 1e 32 80 00 00 	movabs $0x80321e,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
  8034c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034cc:	79 05                	jns    8034d3 <listen+0x2d>
		return r;
  8034ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d1:	eb 16                	jmp    8034e9 <listen+0x43>
	return nsipc_listen(r, backlog);
  8034d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d9:	89 d6                	mov    %edx,%esi
  8034db:	89 c7                	mov    %eax,%edi
  8034dd:	48 b8 15 38 80 00 00 	movabs $0x803815,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
}
  8034e9:	c9                   	leaveq 
  8034ea:	c3                   	retq   

00000000008034eb <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034eb:	55                   	push   %rbp
  8034ec:	48 89 e5             	mov    %rsp,%rbp
  8034ef:	48 83 ec 20          	sub    $0x20,%rsp
  8034f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803503:	89 c2                	mov    %eax,%edx
  803505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803509:	8b 40 0c             	mov    0xc(%rax),%eax
  80350c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803510:	b9 00 00 00 00       	mov    $0x0,%ecx
  803515:	89 c7                	mov    %eax,%edi
  803517:	48 b8 55 38 80 00 00 	movabs $0x803855,%rax
  80351e:	00 00 00 
  803521:	ff d0                	callq  *%rax
}
  803523:	c9                   	leaveq 
  803524:	c3                   	retq   

0000000000803525 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803525:	55                   	push   %rbp
  803526:	48 89 e5             	mov    %rsp,%rbp
  803529:	48 83 ec 20          	sub    $0x20,%rsp
  80352d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803531:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803535:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353d:	89 c2                	mov    %eax,%edx
  80353f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803543:	8b 40 0c             	mov    0xc(%rax),%eax
  803546:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80354a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80354f:	89 c7                	mov    %eax,%edi
  803551:	48 b8 21 39 80 00 00 	movabs $0x803921,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
}
  80355d:	c9                   	leaveq 
  80355e:	c3                   	retq   

000000000080355f <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80355f:	55                   	push   %rbp
  803560:	48 89 e5             	mov    %rsp,%rbp
  803563:	48 83 ec 10          	sub    $0x10,%rsp
  803567:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80356b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80356f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803573:	48 be a7 4b 80 00 00 	movabs $0x804ba7,%rsi
  80357a:	00 00 00 
  80357d:	48 89 c7             	mov    %rax,%rdi
  803580:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
	return 0;
  80358c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803591:	c9                   	leaveq 
  803592:	c3                   	retq   

0000000000803593 <socket>:

int
socket(int domain, int type, int protocol)
{
  803593:	55                   	push   %rbp
  803594:	48 89 e5             	mov    %rsp,%rbp
  803597:	48 83 ec 20          	sub    $0x20,%rsp
  80359b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035a1:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035a4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035a7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ad:	89 ce                	mov    %ecx,%esi
  8035af:	89 c7                	mov    %eax,%edi
  8035b1:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  8035b8:	00 00 00 
  8035bb:	ff d0                	callq  *%rax
  8035bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c4:	79 05                	jns    8035cb <socket+0x38>
		return r;
  8035c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c9:	eb 11                	jmp    8035dc <socket+0x49>
	return alloc_sockfd(r);
  8035cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ce:	89 c7                	mov    %eax,%edi
  8035d0:	48 b8 75 32 80 00 00 	movabs $0x803275,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
}
  8035dc:	c9                   	leaveq 
  8035dd:	c3                   	retq   

00000000008035de <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035de:	55                   	push   %rbp
  8035df:	48 89 e5             	mov    %rsp,%rbp
  8035e2:	48 83 ec 10          	sub    $0x10,%rsp
  8035e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035e9:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035f0:	00 00 00 
  8035f3:	8b 00                	mov    (%rax),%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	75 1f                	jne    803618 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035f9:	bf 02 00 00 00       	mov    $0x2,%edi
  8035fe:	48 b8 ef 43 80 00 00 	movabs $0x8043ef,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
  80360a:	89 c2                	mov    %eax,%edx
  80360c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803613:	00 00 00 
  803616:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803618:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80361f:	00 00 00 
  803622:	8b 00                	mov    (%rax),%eax
  803624:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803627:	b9 07 00 00 00       	mov    $0x7,%ecx
  80362c:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  803633:	00 00 00 
  803636:	89 c7                	mov    %eax,%edi
  803638:	48 b8 5a 43 80 00 00 	movabs $0x80435a,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803644:	ba 00 00 00 00       	mov    $0x0,%edx
  803649:	be 00 00 00 00       	mov    $0x0,%esi
  80364e:	bf 00 00 00 00       	mov    $0x0,%edi
  803653:	48 b8 99 42 80 00 00 	movabs $0x804299,%rax
  80365a:	00 00 00 
  80365d:	ff d0                	callq  *%rax
}
  80365f:	c9                   	leaveq 
  803660:	c3                   	retq   

0000000000803661 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803661:	55                   	push   %rbp
  803662:	48 89 e5             	mov    %rsp,%rbp
  803665:	48 83 ec 30          	sub    $0x30,%rsp
  803669:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80366c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803670:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803674:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80367b:	00 00 00 
  80367e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803681:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803683:	bf 01 00 00 00       	mov    $0x1,%edi
  803688:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
  803694:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803697:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369b:	78 3e                	js     8036db <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80369d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036a4:	00 00 00 
  8036a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036af:	8b 40 10             	mov    0x10(%rax),%eax
  8036b2:	89 c2                	mov    %eax,%edx
  8036b4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036bc:	48 89 ce             	mov    %rcx,%rsi
  8036bf:	48 89 c7             	mov    %rax,%rdi
  8036c2:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d2:	8b 50 10             	mov    0x10(%rax),%edx
  8036d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036de:	c9                   	leaveq 
  8036df:	c3                   	retq   

00000000008036e0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036e0:	55                   	push   %rbp
  8036e1:	48 89 e5             	mov    %rsp,%rbp
  8036e4:	48 83 ec 10          	sub    $0x10,%rsp
  8036e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036ef:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036f2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036f9:	00 00 00 
  8036fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036ff:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803701:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803708:	48 89 c6             	mov    %rax,%rsi
  80370b:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803712:	00 00 00 
  803715:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803721:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803728:	00 00 00 
  80372b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80372e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803731:	bf 02 00 00 00       	mov    $0x2,%edi
  803736:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
}
  803742:	c9                   	leaveq 
  803743:	c3                   	retq   

0000000000803744 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803744:	55                   	push   %rbp
  803745:	48 89 e5             	mov    %rsp,%rbp
  803748:	48 83 ec 10          	sub    $0x10,%rsp
  80374c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80374f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803752:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803759:	00 00 00 
  80375c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80375f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803761:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803768:	00 00 00 
  80376b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80376e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803771:	bf 03 00 00 00       	mov    $0x3,%edi
  803776:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  80377d:	00 00 00 
  803780:	ff d0                	callq  *%rax
}
  803782:	c9                   	leaveq 
  803783:	c3                   	retq   

0000000000803784 <nsipc_close>:

int
nsipc_close(int s)
{
  803784:	55                   	push   %rbp
  803785:	48 89 e5             	mov    %rsp,%rbp
  803788:	48 83 ec 10          	sub    $0x10,%rsp
  80378c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80378f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803796:	00 00 00 
  803799:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80379c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80379e:	bf 04 00 00 00       	mov    $0x4,%edi
  8037a3:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  8037aa:	00 00 00 
  8037ad:	ff d0                	callq  *%rax
}
  8037af:	c9                   	leaveq 
  8037b0:	c3                   	retq   

00000000008037b1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037b1:	55                   	push   %rbp
  8037b2:	48 89 e5             	mov    %rsp,%rbp
  8037b5:	48 83 ec 10          	sub    $0x10,%rsp
  8037b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037c0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037c3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8037ca:	00 00 00 
  8037cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037d0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d9:	48 89 c6             	mov    %rax,%rsi
  8037dc:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8037e3:	00 00 00 
  8037e6:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8037ed:	00 00 00 
  8037f0:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037f2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8037f9:	00 00 00 
  8037fc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037ff:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803802:	bf 05 00 00 00       	mov    $0x5,%edi
  803807:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
}
  803813:	c9                   	leaveq 
  803814:	c3                   	retq   

0000000000803815 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803815:	55                   	push   %rbp
  803816:	48 89 e5             	mov    %rsp,%rbp
  803819:	48 83 ec 10          	sub    $0x10,%rsp
  80381d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803820:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803823:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80382a:	00 00 00 
  80382d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803830:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803832:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803839:	00 00 00 
  80383c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80383f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803842:	bf 06 00 00 00       	mov    $0x6,%edi
  803847:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
}
  803853:	c9                   	leaveq 
  803854:	c3                   	retq   

0000000000803855 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803855:	55                   	push   %rbp
  803856:	48 89 e5             	mov    %rsp,%rbp
  803859:	48 83 ec 30          	sub    $0x30,%rsp
  80385d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803860:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803864:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803867:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80386a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803871:	00 00 00 
  803874:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803877:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803879:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803880:	00 00 00 
  803883:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803886:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803889:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803890:	00 00 00 
  803893:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803896:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803899:	bf 07 00 00 00       	mov    $0x7,%edi
  80389e:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  8038a5:	00 00 00 
  8038a8:	ff d0                	callq  *%rax
  8038aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b1:	78 69                	js     80391c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038b3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038ba:	7f 08                	jg     8038c4 <nsipc_recv+0x6f>
  8038bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bf:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038c2:	7e 35                	jle    8038f9 <nsipc_recv+0xa4>
  8038c4:	48 b9 ae 4b 80 00 00 	movabs $0x804bae,%rcx
  8038cb:	00 00 00 
  8038ce:	48 ba c3 4b 80 00 00 	movabs $0x804bc3,%rdx
  8038d5:	00 00 00 
  8038d8:	be 62 00 00 00       	mov    $0x62,%esi
  8038dd:	48 bf d8 4b 80 00 00 	movabs $0x804bd8,%rdi
  8038e4:	00 00 00 
  8038e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ec:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  8038f3:	00 00 00 
  8038f6:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038fc:	48 63 d0             	movslq %eax,%rdx
  8038ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803903:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  80390a:	00 00 00 
  80390d:	48 89 c7             	mov    %rax,%rdi
  803910:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  803917:	00 00 00 
  80391a:	ff d0                	callq  *%rax
	}

	return r;
  80391c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80391f:	c9                   	leaveq 
  803920:	c3                   	retq   

0000000000803921 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803921:	55                   	push   %rbp
  803922:	48 89 e5             	mov    %rsp,%rbp
  803925:	48 83 ec 20          	sub    $0x20,%rsp
  803929:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80392c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803930:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803933:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803936:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80393d:	00 00 00 
  803940:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803943:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803945:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80394c:	7e 35                	jle    803983 <nsipc_send+0x62>
  80394e:	48 b9 e4 4b 80 00 00 	movabs $0x804be4,%rcx
  803955:	00 00 00 
  803958:	48 ba c3 4b 80 00 00 	movabs $0x804bc3,%rdx
  80395f:	00 00 00 
  803962:	be 6d 00 00 00       	mov    $0x6d,%esi
  803967:	48 bf d8 4b 80 00 00 	movabs $0x804bd8,%rdi
  80396e:	00 00 00 
  803971:	b8 00 00 00 00       	mov    $0x0,%eax
  803976:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  80397d:	00 00 00 
  803980:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803983:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803986:	48 63 d0             	movslq %eax,%rdx
  803989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398d:	48 89 c6             	mov    %rax,%rsi
  803990:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  803997:	00 00 00 
  80399a:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8039a1:	00 00 00 
  8039a4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8039a6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8039ad:	00 00 00 
  8039b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039b3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039b6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8039bd:	00 00 00 
  8039c0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039c3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039c6:	bf 08 00 00 00       	mov    $0x8,%edi
  8039cb:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
}
  8039d7:	c9                   	leaveq 
  8039d8:	c3                   	retq   

00000000008039d9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039d9:	55                   	push   %rbp
  8039da:	48 89 e5             	mov    %rsp,%rbp
  8039dd:	48 83 ec 10          	sub    $0x10,%rsp
  8039e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039e4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039e7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039ea:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8039f1:	00 00 00 
  8039f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039f7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039f9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803a00:	00 00 00 
  803a03:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a06:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a09:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803a10:	00 00 00 
  803a13:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a16:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a19:	bf 09 00 00 00       	mov    $0x9,%edi
  803a1e:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  803a25:	00 00 00 
  803a28:	ff d0                	callq  *%rax
}
  803a2a:	c9                   	leaveq 
  803a2b:	c3                   	retq   

0000000000803a2c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a2c:	55                   	push   %rbp
  803a2d:	48 89 e5             	mov    %rsp,%rbp
  803a30:	53                   	push   %rbx
  803a31:	48 83 ec 38          	sub    $0x38,%rsp
  803a35:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a39:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a3d:	48 89 c7             	mov    %rax,%rdi
  803a40:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a53:	0f 88 bf 01 00 00    	js     803c18 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5d:	ba 07 04 00 00       	mov    $0x407,%edx
  803a62:	48 89 c6             	mov    %rax,%rsi
  803a65:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6a:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
  803a76:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7d:	0f 88 95 01 00 00    	js     803c18 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a83:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a87:	48 89 c7             	mov    %rax,%rdi
  803a8a:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a9d:	0f 88 5d 01 00 00    	js     803c00 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aa7:	ba 07 04 00 00       	mov    $0x407,%edx
  803aac:	48 89 c6             	mov    %rax,%rsi
  803aaf:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab4:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
  803ac0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ac7:	0f 88 33 01 00 00    	js     803c00 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad1:	48 89 c7             	mov    %rax,%rdi
  803ad4:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803adb:	00 00 00 
  803ade:	ff d0                	callq  *%rax
  803ae0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ae4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae8:	ba 07 04 00 00       	mov    $0x407,%edx
  803aed:	48 89 c6             	mov    %rax,%rsi
  803af0:	bf 00 00 00 00       	mov    $0x0,%edi
  803af5:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
  803b01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b08:	0f 88 d9 00 00 00    	js     803be7 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b12:	48 89 c7             	mov    %rax,%rdi
  803b15:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	48 89 c2             	mov    %rax,%rdx
  803b24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b28:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b2e:	48 89 d1             	mov    %rdx,%rcx
  803b31:	ba 00 00 00 00       	mov    $0x0,%edx
  803b36:	48 89 c6             	mov    %rax,%rsi
  803b39:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3e:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
  803b4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b51:	78 79                	js     803bcc <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b57:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b5e:	00 00 00 
  803b61:	8b 12                	mov    (%rdx),%edx
  803b63:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b74:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b7b:	00 00 00 
  803b7e:	8b 12                	mov    (%rdx),%edx
  803b80:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b86:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b91:	48 89 c7             	mov    %rax,%rdi
  803b94:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
  803ba0:	89 c2                	mov    %eax,%edx
  803ba2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ba6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ba8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bac:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803bb0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb4:	48 89 c7             	mov    %rax,%rdi
  803bb7:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  803bbe:	00 00 00 
  803bc1:	ff d0                	callq  *%rax
  803bc3:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bca:	eb 4f                	jmp    803c1b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803bcc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803bcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd1:	48 89 c6             	mov    %rax,%rsi
  803bd4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd9:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
  803be5:	eb 01                	jmp    803be8 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803be7:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803be8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bec:	48 89 c6             	mov    %rax,%rsi
  803bef:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf4:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  803bfb:	00 00 00 
  803bfe:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c04:	48 89 c6             	mov    %rax,%rsi
  803c07:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0c:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  803c13:	00 00 00 
  803c16:	ff d0                	callq  *%rax
err:
	return r;
  803c18:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c1b:	48 83 c4 38          	add    $0x38,%rsp
  803c1f:	5b                   	pop    %rbx
  803c20:	5d                   	pop    %rbp
  803c21:	c3                   	retq   

0000000000803c22 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c22:	55                   	push   %rbp
  803c23:	48 89 e5             	mov    %rsp,%rbp
  803c26:	53                   	push   %rbx
  803c27:	48 83 ec 28          	sub    $0x28,%rsp
  803c2b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c2f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c33:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803c3a:	00 00 00 
  803c3d:	48 8b 00             	mov    (%rax),%rax
  803c40:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c46:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4d:	48 89 c7             	mov    %rax,%rdi
  803c50:	48 b8 60 44 80 00 00 	movabs $0x804460,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
  803c5c:	89 c3                	mov    %eax,%ebx
  803c5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c62:	48 89 c7             	mov    %rax,%rdi
  803c65:	48 b8 60 44 80 00 00 	movabs $0x804460,%rax
  803c6c:	00 00 00 
  803c6f:	ff d0                	callq  *%rax
  803c71:	39 c3                	cmp    %eax,%ebx
  803c73:	0f 94 c0             	sete   %al
  803c76:	0f b6 c0             	movzbl %al,%eax
  803c79:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c7c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803c83:	00 00 00 
  803c86:	48 8b 00             	mov    (%rax),%rax
  803c89:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c8f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c95:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c98:	75 05                	jne    803c9f <_pipeisclosed+0x7d>
			return ret;
  803c9a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c9d:	eb 4a                	jmp    803ce9 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803c9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ca2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ca5:	74 8c                	je     803c33 <_pipeisclosed+0x11>
  803ca7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cab:	75 86                	jne    803c33 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cad:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803cb4:	00 00 00 
  803cb7:	48 8b 00             	mov    (%rax),%rax
  803cba:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803cc0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803cc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc6:	89 c6                	mov    %eax,%esi
  803cc8:	48 bf f5 4b 80 00 00 	movabs $0x804bf5,%rdi
  803ccf:	00 00 00 
  803cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd7:	49 b8 27 05 80 00 00 	movabs $0x800527,%r8
  803cde:	00 00 00 
  803ce1:	41 ff d0             	callq  *%r8
	}
  803ce4:	e9 4a ff ff ff       	jmpq   803c33 <_pipeisclosed+0x11>

}
  803ce9:	48 83 c4 28          	add    $0x28,%rsp
  803ced:	5b                   	pop    %rbx
  803cee:	5d                   	pop    %rbp
  803cef:	c3                   	retq   

0000000000803cf0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803cf0:	55                   	push   %rbp
  803cf1:	48 89 e5             	mov    %rsp,%rbp
  803cf4:	48 83 ec 30          	sub    $0x30,%rsp
  803cf8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d02:	48 89 d6             	mov    %rdx,%rsi
  803d05:	89 c7                	mov    %eax,%edi
  803d07:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
  803d13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1a:	79 05                	jns    803d21 <pipeisclosed+0x31>
		return r;
  803d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1f:	eb 31                	jmp    803d52 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d25:	48 89 c7             	mov    %rax,%rdi
  803d28:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
  803d34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d40:	48 89 d6             	mov    %rdx,%rsi
  803d43:	48 89 c7             	mov    %rax,%rdi
  803d46:	48 b8 22 3c 80 00 00 	movabs $0x803c22,%rax
  803d4d:	00 00 00 
  803d50:	ff d0                	callq  *%rax
}
  803d52:	c9                   	leaveq 
  803d53:	c3                   	retq   

0000000000803d54 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d54:	55                   	push   %rbp
  803d55:	48 89 e5             	mov    %rsp,%rbp
  803d58:	48 83 ec 40          	sub    $0x40,%rsp
  803d5c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d6c:	48 89 c7             	mov    %rax,%rdi
  803d6f:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
  803d7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d87:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d8e:	00 
  803d8f:	e9 90 00 00 00       	jmpq   803e24 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d94:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d99:	74 09                	je     803da4 <devpipe_read+0x50>
				return i;
  803d9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9f:	e9 8e 00 00 00       	jmpq   803e32 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803da4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dac:	48 89 d6             	mov    %rdx,%rsi
  803daf:	48 89 c7             	mov    %rax,%rdi
  803db2:	48 b8 22 3c 80 00 00 	movabs $0x803c22,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	callq  *%rax
  803dbe:	85 c0                	test   %eax,%eax
  803dc0:	74 07                	je     803dc9 <devpipe_read+0x75>
				return 0;
  803dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc7:	eb 69                	jmp    803e32 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803dc9:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd9:	8b 10                	mov    (%rax),%edx
  803ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddf:	8b 40 04             	mov    0x4(%rax),%eax
  803de2:	39 c2                	cmp    %eax,%edx
  803de4:	74 ae                	je     803d94 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803de6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dee:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df6:	8b 00                	mov    (%rax),%eax
  803df8:	99                   	cltd   
  803df9:	c1 ea 1b             	shr    $0x1b,%edx
  803dfc:	01 d0                	add    %edx,%eax
  803dfe:	83 e0 1f             	and    $0x1f,%eax
  803e01:	29 d0                	sub    %edx,%eax
  803e03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e07:	48 98                	cltq   
  803e09:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e0e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e14:	8b 00                	mov    (%rax),%eax
  803e16:	8d 50 01             	lea    0x1(%rax),%edx
  803e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e1f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e28:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e2c:	72 a7                	jb     803dd5 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803e32:	c9                   	leaveq 
  803e33:	c3                   	retq   

0000000000803e34 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e34:	55                   	push   %rbp
  803e35:	48 89 e5             	mov    %rsp,%rbp
  803e38:	48 83 ec 40          	sub    $0x40,%rsp
  803e3c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e40:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e44:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e4c:	48 89 c7             	mov    %rax,%rdi
  803e4f:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
  803e5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e67:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e6e:	00 
  803e6f:	e9 8f 00 00 00       	jmpq   803f03 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7c:	48 89 d6             	mov    %rdx,%rsi
  803e7f:	48 89 c7             	mov    %rax,%rdi
  803e82:	48 b8 22 3c 80 00 00 	movabs $0x803c22,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
  803e8e:	85 c0                	test   %eax,%eax
  803e90:	74 07                	je     803e99 <devpipe_write+0x65>
				return 0;
  803e92:	b8 00 00 00 00       	mov    $0x0,%eax
  803e97:	eb 78                	jmp    803f11 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e99:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803ea0:	00 00 00 
  803ea3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea9:	8b 40 04             	mov    0x4(%rax),%eax
  803eac:	48 63 d0             	movslq %eax,%rdx
  803eaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb3:	8b 00                	mov    (%rax),%eax
  803eb5:	48 98                	cltq   
  803eb7:	48 83 c0 20          	add    $0x20,%rax
  803ebb:	48 39 c2             	cmp    %rax,%rdx
  803ebe:	73 b4                	jae    803e74 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ec0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec4:	8b 40 04             	mov    0x4(%rax),%eax
  803ec7:	99                   	cltd   
  803ec8:	c1 ea 1b             	shr    $0x1b,%edx
  803ecb:	01 d0                	add    %edx,%eax
  803ecd:	83 e0 1f             	and    $0x1f,%eax
  803ed0:	29 d0                	sub    %edx,%eax
  803ed2:	89 c6                	mov    %eax,%esi
  803ed4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803edc:	48 01 d0             	add    %rdx,%rax
  803edf:	0f b6 08             	movzbl (%rax),%ecx
  803ee2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ee6:	48 63 c6             	movslq %esi,%rax
  803ee9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef1:	8b 40 04             	mov    0x4(%rax),%eax
  803ef4:	8d 50 01             	lea    0x1(%rax),%edx
  803ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803efe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f07:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f0b:	72 98                	jb     803ea5 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803f11:	c9                   	leaveq 
  803f12:	c3                   	retq   

0000000000803f13 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f13:	55                   	push   %rbp
  803f14:	48 89 e5             	mov    %rsp,%rbp
  803f17:	48 83 ec 20          	sub    $0x20,%rsp
  803f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f27:	48 89 c7             	mov    %rax,%rdi
  803f2a:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803f31:	00 00 00 
  803f34:	ff d0                	callq  *%rax
  803f36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f3e:	48 be 08 4c 80 00 00 	movabs $0x804c08,%rsi
  803f45:	00 00 00 
  803f48:	48 89 c7             	mov    %rax,%rdi
  803f4b:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  803f52:	00 00 00 
  803f55:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5b:	8b 50 04             	mov    0x4(%rax),%edx
  803f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f62:	8b 00                	mov    (%rax),%eax
  803f64:	29 c2                	sub    %eax,%edx
  803f66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f6a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f74:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f7b:	00 00 00 
	stat->st_dev = &devpipe;
  803f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f82:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f89:	00 00 00 
  803f8c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f98:	c9                   	leaveq 
  803f99:	c3                   	retq   

0000000000803f9a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f9a:	55                   	push   %rbp
  803f9b:	48 89 e5             	mov    %rsp,%rbp
  803f9e:	48 83 ec 10          	sub    $0x10,%rsp
  803fa2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803faa:	48 89 c6             	mov    %rax,%rsi
  803fad:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb2:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  803fb9:	00 00 00 
  803fbc:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc2:	48 89 c7             	mov    %rax,%rdi
  803fc5:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803fcc:	00 00 00 
  803fcf:	ff d0                	callq  *%rax
  803fd1:	48 89 c6             	mov    %rax,%rsi
  803fd4:	bf 00 00 00 00       	mov    $0x0,%edi
  803fd9:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  803fe0:	00 00 00 
  803fe3:	ff d0                	callq  *%rax
}
  803fe5:	c9                   	leaveq 
  803fe6:	c3                   	retq   

0000000000803fe7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	48 83 ec 20          	sub    $0x20,%rsp
  803fef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ff2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff5:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ff8:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ffc:	be 01 00 00 00       	mov    $0x1,%esi
  804001:	48 89 c7             	mov    %rax,%rdi
  804004:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  80400b:	00 00 00 
  80400e:	ff d0                	callq  *%rax
}
  804010:	90                   	nop
  804011:	c9                   	leaveq 
  804012:	c3                   	retq   

0000000000804013 <getchar>:

int
getchar(void)
{
  804013:	55                   	push   %rbp
  804014:	48 89 e5             	mov    %rsp,%rbp
  804017:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80401b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80401f:	ba 01 00 00 00       	mov    $0x1,%edx
  804024:	48 89 c6             	mov    %rax,%rsi
  804027:	bf 00 00 00 00       	mov    $0x0,%edi
  80402c:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  804033:	00 00 00 
  804036:	ff d0                	callq  *%rax
  804038:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80403b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403f:	79 05                	jns    804046 <getchar+0x33>
		return r;
  804041:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804044:	eb 14                	jmp    80405a <getchar+0x47>
	if (r < 1)
  804046:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80404a:	7f 07                	jg     804053 <getchar+0x40>
		return -E_EOF;
  80404c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804051:	eb 07                	jmp    80405a <getchar+0x47>
	return c;
  804053:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804057:	0f b6 c0             	movzbl %al,%eax

}
  80405a:	c9                   	leaveq 
  80405b:	c3                   	retq   

000000000080405c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80405c:	55                   	push   %rbp
  80405d:	48 89 e5             	mov    %rsp,%rbp
  804060:	48 83 ec 20          	sub    $0x20,%rsp
  804064:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804067:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80406b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80406e:	48 89 d6             	mov    %rdx,%rsi
  804071:	89 c7                	mov    %eax,%edi
  804073:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  80407a:	00 00 00 
  80407d:	ff d0                	callq  *%rax
  80407f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804086:	79 05                	jns    80408d <iscons+0x31>
		return r;
  804088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80408b:	eb 1a                	jmp    8040a7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80408d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804091:	8b 10                	mov    (%rax),%edx
  804093:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80409a:	00 00 00 
  80409d:	8b 00                	mov    (%rax),%eax
  80409f:	39 c2                	cmp    %eax,%edx
  8040a1:	0f 94 c0             	sete   %al
  8040a4:	0f b6 c0             	movzbl %al,%eax
}
  8040a7:	c9                   	leaveq 
  8040a8:	c3                   	retq   

00000000008040a9 <opencons>:

int
opencons(void)
{
  8040a9:	55                   	push   %rbp
  8040aa:	48 89 e5             	mov    %rsp,%rbp
  8040ad:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8040b1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040b5:	48 89 c7             	mov    %rax,%rdi
  8040b8:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
  8040c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040cb:	79 05                	jns    8040d2 <opencons+0x29>
		return r;
  8040cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d0:	eb 5b                	jmp    80412d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d6:	ba 07 04 00 00       	mov    $0x407,%edx
  8040db:	48 89 c6             	mov    %rax,%rsi
  8040de:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e3:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  8040ea:	00 00 00 
  8040ed:	ff d0                	callq  *%rax
  8040ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f6:	79 05                	jns    8040fd <opencons+0x54>
		return r;
  8040f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040fb:	eb 30                	jmp    80412d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804101:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804108:	00 00 00 
  80410b:	8b 12                	mov    (%rdx),%edx
  80410d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80410f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804113:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80411a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411e:	48 89 c7             	mov    %rax,%rdi
  804121:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  804128:	00 00 00 
  80412b:	ff d0                	callq  *%rax
}
  80412d:	c9                   	leaveq 
  80412e:	c3                   	retq   

000000000080412f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80412f:	55                   	push   %rbp
  804130:	48 89 e5             	mov    %rsp,%rbp
  804133:	48 83 ec 30          	sub    $0x30,%rsp
  804137:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80413b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80413f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804143:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804148:	75 13                	jne    80415d <devcons_read+0x2e>
		return 0;
  80414a:	b8 00 00 00 00       	mov    $0x0,%eax
  80414f:	eb 49                	jmp    80419a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804151:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  804158:	00 00 00 
  80415b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80415d:	48 b8 f2 18 80 00 00 	movabs $0x8018f2,%rax
  804164:	00 00 00 
  804167:	ff d0                	callq  *%rax
  804169:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80416c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804170:	74 df                	je     804151 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804176:	79 05                	jns    80417d <devcons_read+0x4e>
		return c;
  804178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417b:	eb 1d                	jmp    80419a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80417d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804181:	75 07                	jne    80418a <devcons_read+0x5b>
		return 0;
  804183:	b8 00 00 00 00       	mov    $0x0,%eax
  804188:	eb 10                	jmp    80419a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80418a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418d:	89 c2                	mov    %eax,%edx
  80418f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804193:	88 10                	mov    %dl,(%rax)
	return 1;
  804195:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80419a:	c9                   	leaveq 
  80419b:	c3                   	retq   

000000000080419c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80419c:	55                   	push   %rbp
  80419d:	48 89 e5             	mov    %rsp,%rbp
  8041a0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8041a7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8041ae:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8041b5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041c3:	eb 76                	jmp    80423b <devcons_write+0x9f>
		m = n - tot;
  8041c5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041cc:	89 c2                	mov    %eax,%edx
  8041ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d1:	29 c2                	sub    %eax,%edx
  8041d3:	89 d0                	mov    %edx,%eax
  8041d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041db:	83 f8 7f             	cmp    $0x7f,%eax
  8041de:	76 07                	jbe    8041e7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8041e0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041ea:	48 63 d0             	movslq %eax,%rdx
  8041ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f0:	48 63 c8             	movslq %eax,%rcx
  8041f3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8041fa:	48 01 c1             	add    %rax,%rcx
  8041fd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804204:	48 89 ce             	mov    %rcx,%rsi
  804207:	48 89 c7             	mov    %rax,%rdi
  80420a:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  804211:	00 00 00 
  804214:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804216:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804219:	48 63 d0             	movslq %eax,%rdx
  80421c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804223:	48 89 d6             	mov    %rdx,%rsi
  804226:	48 89 c7             	mov    %rax,%rdi
  804229:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  804230:	00 00 00 
  804233:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804235:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804238:	01 45 fc             	add    %eax,-0x4(%rbp)
  80423b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423e:	48 98                	cltq   
  804240:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804247:	0f 82 78 ff ff ff    	jb     8041c5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80424d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804250:	c9                   	leaveq 
  804251:	c3                   	retq   

0000000000804252 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804252:	55                   	push   %rbp
  804253:	48 89 e5             	mov    %rsp,%rbp
  804256:	48 83 ec 08          	sub    $0x8,%rsp
  80425a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80425e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804263:	c9                   	leaveq 
  804264:	c3                   	retq   

0000000000804265 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804265:	55                   	push   %rbp
  804266:	48 89 e5             	mov    %rsp,%rbp
  804269:	48 83 ec 10          	sub    $0x10,%rsp
  80426d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804271:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804279:	48 be 14 4c 80 00 00 	movabs $0x804c14,%rsi
  804280:	00 00 00 
  804283:	48 89 c7             	mov    %rax,%rdi
  804286:	48 b8 b7 10 80 00 00 	movabs $0x8010b7,%rax
  80428d:	00 00 00 
  804290:	ff d0                	callq  *%rax
	return 0;
  804292:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804297:	c9                   	leaveq 
  804298:	c3                   	retq   

0000000000804299 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804299:	55                   	push   %rbp
  80429a:	48 89 e5             	mov    %rsp,%rbp
  80429d:	48 83 ec 30          	sub    $0x30,%rsp
  8042a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8042ad:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042b2:	75 0e                	jne    8042c2 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8042b4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8042bb:	00 00 00 
  8042be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8042c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042c6:	48 89 c7             	mov    %rax,%rdi
  8042c9:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8042d0:	00 00 00 
  8042d3:	ff d0                	callq  *%rax
  8042d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042dc:	79 27                	jns    804305 <ipc_recv+0x6c>
		if (from_env_store)
  8042de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042e3:	74 0a                	je     8042ef <ipc_recv+0x56>
			*from_env_store = 0;
  8042e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8042ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042f4:	74 0a                	je     804300 <ipc_recv+0x67>
			*perm_store = 0;
  8042f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804303:	eb 53                	jmp    804358 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804305:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80430a:	74 19                	je     804325 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80430c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804313:	00 00 00 
  804316:	48 8b 00             	mov    (%rax),%rax
  804319:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80431f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804323:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804325:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80432a:	74 19                	je     804345 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80432c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804333:	00 00 00 
  804336:	48 8b 00             	mov    (%rax),%rax
  804339:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80433f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804343:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804345:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80434c:	00 00 00 
  80434f:	48 8b 00             	mov    (%rax),%rax
  804352:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804358:	c9                   	leaveq 
  804359:	c3                   	retq   

000000000080435a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80435a:	55                   	push   %rbp
  80435b:	48 89 e5             	mov    %rsp,%rbp
  80435e:	48 83 ec 30          	sub    $0x30,%rsp
  804362:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804365:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804368:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80436c:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80436f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804374:	75 1c                	jne    804392 <ipc_send+0x38>
		pg = (void*) UTOP;
  804376:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80437d:	00 00 00 
  804380:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804384:	eb 0c                	jmp    804392 <ipc_send+0x38>
		sys_yield();
  804386:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80438d:	00 00 00 
  804390:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804392:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804395:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804398:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80439c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80439f:	89 c7                	mov    %eax,%edi
  8043a1:	48 b8 d0 1b 80 00 00 	movabs $0x801bd0,%rax
  8043a8:	00 00 00 
  8043ab:	ff d0                	callq  *%rax
  8043ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043b0:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8043b4:	74 d0                	je     804386 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8043b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ba:	79 30                	jns    8043ec <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8043bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043bf:	89 c1                	mov    %eax,%ecx
  8043c1:	48 ba 1b 4c 80 00 00 	movabs $0x804c1b,%rdx
  8043c8:	00 00 00 
  8043cb:	be 47 00 00 00       	mov    $0x47,%esi
  8043d0:	48 bf 31 4c 80 00 00 	movabs $0x804c31,%rdi
  8043d7:	00 00 00 
  8043da:	b8 00 00 00 00       	mov    $0x0,%eax
  8043df:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  8043e6:	00 00 00 
  8043e9:	41 ff d0             	callq  *%r8

}
  8043ec:	90                   	nop
  8043ed:	c9                   	leaveq 
  8043ee:	c3                   	retq   

00000000008043ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8043ef:	55                   	push   %rbp
  8043f0:	48 89 e5             	mov    %rsp,%rbp
  8043f3:	48 83 ec 18          	sub    $0x18,%rsp
  8043f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8043fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804401:	eb 4d                	jmp    804450 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804403:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80440a:	00 00 00 
  80440d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804410:	48 98                	cltq   
  804412:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804419:	48 01 d0             	add    %rdx,%rax
  80441c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804422:	8b 00                	mov    (%rax),%eax
  804424:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804427:	75 23                	jne    80444c <ipc_find_env+0x5d>
			return envs[i].env_id;
  804429:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804430:	00 00 00 
  804433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804436:	48 98                	cltq   
  804438:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80443f:	48 01 d0             	add    %rdx,%rax
  804442:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804448:	8b 00                	mov    (%rax),%eax
  80444a:	eb 12                	jmp    80445e <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80444c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804450:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804457:	7e aa                	jle    804403 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80445e:	c9                   	leaveq 
  80445f:	c3                   	retq   

0000000000804460 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804460:	55                   	push   %rbp
  804461:	48 89 e5             	mov    %rsp,%rbp
  804464:	48 83 ec 18          	sub    $0x18,%rsp
  804468:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80446c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804470:	48 c1 e8 15          	shr    $0x15,%rax
  804474:	48 89 c2             	mov    %rax,%rdx
  804477:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80447e:	01 00 00 
  804481:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804485:	83 e0 01             	and    $0x1,%eax
  804488:	48 85 c0             	test   %rax,%rax
  80448b:	75 07                	jne    804494 <pageref+0x34>
		return 0;
  80448d:	b8 00 00 00 00       	mov    $0x0,%eax
  804492:	eb 56                	jmp    8044ea <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804498:	48 c1 e8 0c          	shr    $0xc,%rax
  80449c:	48 89 c2             	mov    %rax,%rdx
  80449f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044a6:	01 00 00 
  8044a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b5:	83 e0 01             	and    $0x1,%eax
  8044b8:	48 85 c0             	test   %rax,%rax
  8044bb:	75 07                	jne    8044c4 <pageref+0x64>
		return 0;
  8044bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c2:	eb 26                	jmp    8044ea <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8044c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8044cc:	48 89 c2             	mov    %rax,%rdx
  8044cf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044d6:	00 00 00 
  8044d9:	48 c1 e2 04          	shl    $0x4,%rdx
  8044dd:	48 01 d0             	add    %rdx,%rax
  8044e0:	48 83 c0 08          	add    $0x8,%rax
  8044e4:	0f b7 00             	movzwl (%rax),%eax
  8044e7:	0f b7 c0             	movzwl %ax,%eax
}
  8044ea:	c9                   	leaveq 
  8044eb:	c3                   	retq   
