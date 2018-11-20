
obj/user/num:     file format elf64-x86-64


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
  80003c:	e8 93 02 00 00       	callq  8002d4 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 80 45 80 00 00 	movabs $0x804580,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba f7 31 80 00 00 	movabs $0x8031f7,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 85 45 80 00 00 	movabs $0x804585,%rdx
  8000f5:	00 00 00 
  8000f8:	be 14 00 00 00       	mov    $0x14,%esi
  8000fd:	48 bf a0 45 80 00 00 	movabs $0x8045a0,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 7c 03 80 00 00 	movabs $0x80037c,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba ab 45 80 00 00 	movabs $0x8045ab,%rdx
  80017b:	00 00 00 
  80017e:	be 19 00 00 00       	mov    $0x19,%esi
  800183:	48 bf a0 45 80 00 00 	movabs $0x8045a0,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 7c 03 80 00 00 	movabs $0x80037c,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	90                   	nop
  8001a0:	c9                   	leaveq 
  8001a1:	c3                   	retq   

00000000008001a2 <umain>:

void
umain(int argc, char **argv)
{
  8001a2:	55                   	push   %rbp
  8001a3:	48 89 e5             	mov    %rsp,%rbp
  8001a6:	48 83 ec 20          	sub    $0x20,%rsp
  8001aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 b9 c0 45 80 00 00 	movabs $0x8045c0,%rcx
  8001c2:	00 00 00 
  8001c5:	48 89 08             	mov    %rcx,(%rax)
	if (argc == 1)
  8001c8:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4c>
		num(0, "<stdin>");
  8001ce:	48 be c4 45 80 00 00 	movabs $0x8045c4,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x123>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x117>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  800228:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd7>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba cc 45 80 00 00 	movabs $0x8045cc,%rdx
  800255:	00 00 00 
  800258:	be 28 00 00 00       	mov    $0x28,%esi
  80025d:	48 bf a0 45 80 00 00 	movabs $0x8045a0,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 7c 03 80 00 00 	movabs $0x80037c,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8002b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002bc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x58>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 58 03 80 00 00 	movabs $0x800358,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	90                   	nop
  8002d2:	c9                   	leaveq 
  8002d3:	c3                   	retq   

00000000008002d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d4:	55                   	push   %rbp
  8002d5:	48 89 e5             	mov    %rsp,%rbp
  8002d8:	48 83 ec 10          	sub    $0x10,%rsp
  8002dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8002e3:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  8002ea:	00 00 00 
  8002ed:	ff d0                	callq  *%rax
  8002ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f4:	48 98                	cltq   
  8002f6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8002fd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800304:	00 00 00 
  800307:	48 01 c2             	add    %rax,%rdx
  80030a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800311:	00 00 00 
  800314:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800317:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80031b:	7e 14                	jle    800331 <libmain+0x5d>
		binaryname = argv[0];
  80031d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800321:	48 8b 10             	mov    (%rax),%rdx
  800324:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80032b:	00 00 00 
  80032e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800331:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800338:	48 89 d6             	mov    %rdx,%rsi
  80033b:	89 c7                	mov    %eax,%edi
  80033d:	48 b8 a2 01 80 00 00 	movabs $0x8001a2,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800349:	48 b8 58 03 80 00 00 	movabs $0x800358,%rax
  800350:	00 00 00 
  800353:	ff d0                	callq  *%rax
}
  800355:	90                   	nop
  800356:	c9                   	leaveq 
  800357:	c3                   	retq   

0000000000800358 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800358:	55                   	push   %rbp
  800359:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80035c:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800368:	bf 00 00 00 00       	mov    $0x0,%edi
  80036d:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
}
  800379:	90                   	nop
  80037a:	5d                   	pop    %rbp
  80037b:	c3                   	retq   

000000000080037c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037c:	55                   	push   %rbp
  80037d:	48 89 e5             	mov    %rsp,%rbp
  800380:	53                   	push   %rbx
  800381:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800388:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80038f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800395:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80039c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003a3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003aa:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003b1:	84 c0                	test   %al,%al
  8003b3:	74 23                	je     8003d8 <_panic+0x5c>
  8003b5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003bc:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003c4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003c8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003cc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003d4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003d8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003df:	00 00 00 
  8003e2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003e9:	00 00 00 
  8003ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003f7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800405:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80040c:	00 00 00 
  80040f:	48 8b 18             	mov    (%rax),%rbx
  800412:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  800419:	00 00 00 
  80041c:	ff d0                	callq  *%rax
  80041e:	89 c6                	mov    %eax,%esi
  800420:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800426:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80042d:	41 89 d0             	mov    %edx,%r8d
  800430:	48 89 c1             	mov    %rax,%rcx
  800433:	48 89 da             	mov    %rbx,%rdx
  800436:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  80043d:	00 00 00 
  800440:	b8 00 00 00 00       	mov    $0x0,%eax
  800445:	49 b9 b6 05 80 00 00 	movabs $0x8005b6,%r9
  80044c:	00 00 00 
  80044f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800452:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800459:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800460:	48 89 d6             	mov    %rdx,%rsi
  800463:	48 89 c7             	mov    %rax,%rdi
  800466:	48 b8 0a 05 80 00 00 	movabs $0x80050a,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
	cprintf("\n");
  800472:	48 bf 0b 46 80 00 00 	movabs $0x80460b,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba b6 05 80 00 00 	movabs $0x8005b6,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80048d:	cc                   	int3   
  80048e:	eb fd                	jmp    80048d <_panic+0x111>

0000000000800490 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800490:	55                   	push   %rbp
  800491:	48 89 e5             	mov    %rsp,%rbp
  800494:	48 83 ec 10          	sub    $0x10,%rsp
  800498:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80049b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80049f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a3:	8b 00                	mov    (%rax),%eax
  8004a5:	8d 48 01             	lea    0x1(%rax),%ecx
  8004a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ac:	89 0a                	mov    %ecx,(%rdx)
  8004ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004b1:	89 d1                	mov    %edx,%ecx
  8004b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b7:	48 98                	cltq   
  8004b9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c1:	8b 00                	mov    (%rax),%eax
  8004c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c8:	75 2c                	jne    8004f6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ce:	8b 00                	mov    (%rax),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d6:	48 83 c2 08          	add    $0x8,%rdx
  8004da:	48 89 c6             	mov    %rax,%rsi
  8004dd:	48 89 d7             	mov    %rdx,%rdi
  8004e0:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  8004e7:	00 00 00 
  8004ea:	ff d0                	callq  *%rax
        b->idx = 0;
  8004ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fa:	8b 40 04             	mov    0x4(%rax),%eax
  8004fd:	8d 50 01             	lea    0x1(%rax),%edx
  800500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800504:	89 50 04             	mov    %edx,0x4(%rax)
}
  800507:	90                   	nop
  800508:	c9                   	leaveq 
  800509:	c3                   	retq   

000000000080050a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80050a:	55                   	push   %rbp
  80050b:	48 89 e5             	mov    %rsp,%rbp
  80050e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800515:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80051c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800523:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80052a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800531:	48 8b 0a             	mov    (%rdx),%rcx
  800534:	48 89 08             	mov    %rcx,(%rax)
  800537:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80053f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800543:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800547:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80054e:	00 00 00 
    b.cnt = 0;
  800551:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800558:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80055b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800562:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800569:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800570:	48 89 c6             	mov    %rax,%rsi
  800573:	48 bf 90 04 80 00 00 	movabs $0x800490,%rdi
  80057a:	00 00 00 
  80057d:	48 b8 54 09 80 00 00 	movabs $0x800954,%rax
  800584:	00 00 00 
  800587:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800589:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80058f:	48 98                	cltq   
  800591:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800598:	48 83 c2 08          	add    $0x8,%rdx
  80059c:	48 89 c6             	mov    %rax,%rsi
  80059f:	48 89 d7             	mov    %rdx,%rdi
  8005a2:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005b4:	c9                   	leaveq 
  8005b5:	c3                   	retq   

00000000008005b6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005b6:	55                   	push   %rbp
  8005b7:	48 89 e5             	mov    %rsp,%rbp
  8005ba:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005c1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8005c8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005cf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005eb:	84 c0                	test   %al,%al
  8005ed:	74 20                	je     80060f <cprintf+0x59>
  8005ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800603:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800607:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80060b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80060f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800616:	00 00 00 
  800619:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800620:	00 00 00 
  800623:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800627:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80062e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800635:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80063c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800643:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80064a:	48 8b 0a             	mov    (%rdx),%rcx
  80064d:	48 89 08             	mov    %rcx,(%rax)
  800650:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800654:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800658:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800660:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800667:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80066e:	48 89 d6             	mov    %rdx,%rsi
  800671:	48 89 c7             	mov    %rax,%rdi
  800674:	48 b8 0a 05 80 00 00 	movabs $0x80050a,%rax
  80067b:	00 00 00 
  80067e:	ff d0                	callq  *%rax
  800680:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800686:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80068c:	c9                   	leaveq 
  80068d:	c3                   	retq   

000000000080068e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068e:	55                   	push   %rbp
  80068f:	48 89 e5             	mov    %rsp,%rbp
  800692:	48 83 ec 30          	sub    $0x30,%rsp
  800696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80069a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80069e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006a2:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006a5:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006a9:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006b0:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006b4:	77 54                	ja     80070a <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b6:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006b9:	8d 78 ff             	lea    -0x1(%rax),%edi
  8006bc:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8006bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c8:	48 f7 f6             	div    %rsi
  8006cb:	49 89 c2             	mov    %rax,%r10
  8006ce:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8006d1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006d4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	41 89 c9             	mov    %ecx,%r9d
  8006df:	41 89 f8             	mov    %edi,%r8d
  8006e2:	89 d1                	mov    %edx,%ecx
  8006e4:	4c 89 d2             	mov    %r10,%rdx
  8006e7:	48 89 c7             	mov    %rax,%rdi
  8006ea:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  8006f1:	00 00 00 
  8006f4:	ff d0                	callq  *%rax
  8006f6:	eb 1c                	jmp    800714 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8006ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800703:	48 89 ce             	mov    %rcx,%rsi
  800706:	89 d7                	mov    %edx,%edi
  800708:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80070a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80070e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800712:	7f e4                	jg     8006f8 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800714:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	48 f7 f1             	div    %rcx
  800723:	48 b8 10 48 80 00 00 	movabs $0x804810,%rax
  80072a:	00 00 00 
  80072d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800731:	0f be d0             	movsbl %al,%edx
  800734:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80073c:	48 89 ce             	mov    %rcx,%rsi
  80073f:	89 d7                	mov    %edx,%edi
  800741:	ff d0                	callq  *%rax
}
  800743:	90                   	nop
  800744:	c9                   	leaveq 
  800745:	c3                   	retq   

0000000000800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %rbp
  800747:	48 89 e5             	mov    %rsp,%rbp
  80074a:	48 83 ec 20          	sub    $0x20,%rsp
  80074e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800752:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800755:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800759:	7e 4f                	jle    8007aa <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	8b 00                	mov    (%rax),%eax
  800761:	83 f8 30             	cmp    $0x30,%eax
  800764:	73 24                	jae    80078a <getuint+0x44>
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800772:	8b 00                	mov    (%rax),%eax
  800774:	89 c0                	mov    %eax,%eax
  800776:	48 01 d0             	add    %rdx,%rax
  800779:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077d:	8b 12                	mov    (%rdx),%edx
  80077f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800782:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800786:	89 0a                	mov    %ecx,(%rdx)
  800788:	eb 14                	jmp    80079e <getuint+0x58>
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800792:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800796:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079e:	48 8b 00             	mov    (%rax),%rax
  8007a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a5:	e9 9d 00 00 00       	jmpq   800847 <getuint+0x101>
	else if (lflag)
  8007aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ae:	74 4c                	je     8007fc <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	8b 00                	mov    (%rax),%eax
  8007b6:	83 f8 30             	cmp    $0x30,%eax
  8007b9:	73 24                	jae    8007df <getuint+0x99>
  8007bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	8b 00                	mov    (%rax),%eax
  8007c9:	89 c0                	mov    %eax,%eax
  8007cb:	48 01 d0             	add    %rdx,%rax
  8007ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d2:	8b 12                	mov    (%rdx),%edx
  8007d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007db:	89 0a                	mov    %ecx,(%rdx)
  8007dd:	eb 14                	jmp    8007f3 <getuint+0xad>
  8007df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f3:	48 8b 00             	mov    (%rax),%rax
  8007f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fa:	eb 4b                	jmp    800847 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	8b 00                	mov    (%rax),%eax
  800802:	83 f8 30             	cmp    $0x30,%eax
  800805:	73 24                	jae    80082b <getuint+0xe5>
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	8b 00                	mov    (%rax),%eax
  800815:	89 c0                	mov    %eax,%eax
  800817:	48 01 d0             	add    %rdx,%rax
  80081a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081e:	8b 12                	mov    (%rdx),%edx
  800820:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	89 0a                	mov    %ecx,(%rdx)
  800829:	eb 14                	jmp    80083f <getuint+0xf9>
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800833:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083f:	8b 00                	mov    (%rax),%eax
  800841:	89 c0                	mov    %eax,%eax
  800843:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800847:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084b:	c9                   	leaveq 
  80084c:	c3                   	retq   

000000000080084d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80084d:	55                   	push   %rbp
  80084e:	48 89 e5             	mov    %rsp,%rbp
  800851:	48 83 ec 20          	sub    $0x20,%rsp
  800855:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800859:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80085c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800860:	7e 4f                	jle    8008b1 <getint+0x64>
		x=va_arg(*ap, long long);
  800862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800866:	8b 00                	mov    (%rax),%eax
  800868:	83 f8 30             	cmp    $0x30,%eax
  80086b:	73 24                	jae    800891 <getint+0x44>
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
  80088f:	eb 14                	jmp    8008a5 <getint+0x58>
  800891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800895:	48 8b 40 08          	mov    0x8(%rax),%rax
  800899:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80089d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a5:	48 8b 00             	mov    (%rax),%rax
  8008a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ac:	e9 9d 00 00 00       	jmpq   80094e <getint+0x101>
	else if (lflag)
  8008b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008b5:	74 4c                	je     800903 <getint+0xb6>
		x=va_arg(*ap, long);
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	8b 00                	mov    (%rax),%eax
  8008bd:	83 f8 30             	cmp    $0x30,%eax
  8008c0:	73 24                	jae    8008e6 <getint+0x99>
  8008c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	8b 00                	mov    (%rax),%eax
  8008d0:	89 c0                	mov    %eax,%eax
  8008d2:	48 01 d0             	add    %rdx,%rax
  8008d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d9:	8b 12                	mov    (%rdx),%edx
  8008db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e2:	89 0a                	mov    %ecx,(%rdx)
  8008e4:	eb 14                	jmp    8008fa <getint+0xad>
  8008e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ea:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008ee:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008fa:	48 8b 00             	mov    (%rax),%rax
  8008fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800901:	eb 4b                	jmp    80094e <getint+0x101>
	else
		x=va_arg(*ap, int);
  800903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800907:	8b 00                	mov    (%rax),%eax
  800909:	83 f8 30             	cmp    $0x30,%eax
  80090c:	73 24                	jae    800932 <getint+0xe5>
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	89 c0                	mov    %eax,%eax
  80091e:	48 01 d0             	add    %rdx,%rax
  800921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800925:	8b 12                	mov    (%rdx),%edx
  800927:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092e:	89 0a                	mov    %ecx,(%rdx)
  800930:	eb 14                	jmp    800946 <getint+0xf9>
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	48 8b 40 08          	mov    0x8(%rax),%rax
  80093a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80093e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800942:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800946:	8b 00                	mov    (%rax),%eax
  800948:	48 98                	cltq   
  80094a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80094e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800952:	c9                   	leaveq 
  800953:	c3                   	retq   

0000000000800954 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800954:	55                   	push   %rbp
  800955:	48 89 e5             	mov    %rsp,%rbp
  800958:	41 54                	push   %r12
  80095a:	53                   	push   %rbx
  80095b:	48 83 ec 60          	sub    $0x60,%rsp
  80095f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800963:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800967:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80096b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80096f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800973:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800977:	48 8b 0a             	mov    (%rdx),%rcx
  80097a:	48 89 08             	mov    %rcx,(%rax)
  80097d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800981:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800985:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800989:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098d:	eb 17                	jmp    8009a6 <vprintfmt+0x52>
			if (ch == '\0')
  80098f:	85 db                	test   %ebx,%ebx
  800991:	0f 84 b9 04 00 00    	je     800e50 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800997:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099f:	48 89 d6             	mov    %rdx,%rsi
  8009a2:	89 df                	mov    %ebx,%edi
  8009a4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009ae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009b2:	0f b6 00             	movzbl (%rax),%eax
  8009b5:	0f b6 d8             	movzbl %al,%ebx
  8009b8:	83 fb 25             	cmp    $0x25,%ebx
  8009bb:	75 d2                	jne    80098f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bd:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009c1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009c8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009dd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e9:	0f b6 00             	movzbl (%rax),%eax
  8009ec:	0f b6 d8             	movzbl %al,%ebx
  8009ef:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009f2:	83 f8 55             	cmp    $0x55,%eax
  8009f5:	0f 87 22 04 00 00    	ja     800e1d <vprintfmt+0x4c9>
  8009fb:	89 c0                	mov    %eax,%eax
  8009fd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a04:	00 
  800a05:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
  800a0c:	00 00 00 
  800a0f:	48 01 d0             	add    %rdx,%rax
  800a12:	48 8b 00             	mov    (%rax),%rax
  800a15:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a17:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a1b:	eb c0                	jmp    8009dd <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a1d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a21:	eb ba                	jmp    8009dd <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a23:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a2a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	c1 e0 02             	shl    $0x2,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	01 d8                	add    %ebx,%eax
  800a38:	83 e8 30             	sub    $0x30,%eax
  800a3b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a42:	0f b6 00             	movzbl (%rax),%eax
  800a45:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a48:	83 fb 2f             	cmp    $0x2f,%ebx
  800a4b:	7e 60                	jle    800aad <vprintfmt+0x159>
  800a4d:	83 fb 39             	cmp    $0x39,%ebx
  800a50:	7f 5b                	jg     800aad <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a52:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a57:	eb d1                	jmp    800a2a <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5c:	83 f8 30             	cmp    $0x30,%eax
  800a5f:	73 17                	jae    800a78 <vprintfmt+0x124>
  800a61:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a68:	89 d2                	mov    %edx,%edx
  800a6a:	48 01 d0             	add    %rdx,%rax
  800a6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a70:	83 c2 08             	add    $0x8,%edx
  800a73:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a76:	eb 0c                	jmp    800a84 <vprintfmt+0x130>
  800a78:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a7c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a80:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a84:	8b 00                	mov    (%rax),%eax
  800a86:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a89:	eb 23                	jmp    800aae <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800a8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a8f:	0f 89 48 ff ff ff    	jns    8009dd <vprintfmt+0x89>
				width = 0;
  800a95:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a9c:	e9 3c ff ff ff       	jmpq   8009dd <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800aa1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800aa8:	e9 30 ff ff ff       	jmpq   8009dd <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aad:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab2:	0f 89 25 ff ff ff    	jns    8009dd <vprintfmt+0x89>
				width = precision, precision = -1;
  800ab8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800abb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800abe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ac5:	e9 13 ff ff ff       	jmpq   8009dd <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aca:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ace:	e9 0a ff ff ff       	jmpq   8009dd <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad6:	83 f8 30             	cmp    $0x30,%eax
  800ad9:	73 17                	jae    800af2 <vprintfmt+0x19e>
  800adb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800adf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae2:	89 d2                	mov    %edx,%edx
  800ae4:	48 01 d0             	add    %rdx,%rax
  800ae7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aea:	83 c2 08             	add    $0x8,%edx
  800aed:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af0:	eb 0c                	jmp    800afe <vprintfmt+0x1aa>
  800af2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800af6:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800afa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afe:	8b 10                	mov    (%rax),%edx
  800b00:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b08:	48 89 ce             	mov    %rcx,%rsi
  800b0b:	89 d7                	mov    %edx,%edi
  800b0d:	ff d0                	callq  *%rax
			break;
  800b0f:	e9 37 03 00 00       	jmpq   800e4b <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b17:	83 f8 30             	cmp    $0x30,%eax
  800b1a:	73 17                	jae    800b33 <vprintfmt+0x1df>
  800b1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b23:	89 d2                	mov    %edx,%edx
  800b25:	48 01 d0             	add    %rdx,%rax
  800b28:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2b:	83 c2 08             	add    $0x8,%edx
  800b2e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b31:	eb 0c                	jmp    800b3f <vprintfmt+0x1eb>
  800b33:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b37:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b3b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b41:	85 db                	test   %ebx,%ebx
  800b43:	79 02                	jns    800b47 <vprintfmt+0x1f3>
				err = -err;
  800b45:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b47:	83 fb 15             	cmp    $0x15,%ebx
  800b4a:	7f 16                	jg     800b62 <vprintfmt+0x20e>
  800b4c:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  800b53:	00 00 00 
  800b56:	48 63 d3             	movslq %ebx,%rdx
  800b59:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b5d:	4d 85 e4             	test   %r12,%r12
  800b60:	75 2e                	jne    800b90 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800b62:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6a:	89 d9                	mov    %ebx,%ecx
  800b6c:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
  800b73:	00 00 00 
  800b76:	48 89 c7             	mov    %rax,%rdi
  800b79:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7e:	49 b8 5a 0e 80 00 00 	movabs $0x800e5a,%r8
  800b85:	00 00 00 
  800b88:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b8b:	e9 bb 02 00 00       	jmpq   800e4b <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b90:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b98:	4c 89 e1             	mov    %r12,%rcx
  800b9b:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  800ba2:	00 00 00 
  800ba5:	48 89 c7             	mov    %rax,%rdi
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	49 b8 5a 0e 80 00 00 	movabs $0x800e5a,%r8
  800bb4:	00 00 00 
  800bb7:	41 ff d0             	callq  *%r8
			break;
  800bba:	e9 8c 02 00 00       	jmpq   800e4b <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc2:	83 f8 30             	cmp    $0x30,%eax
  800bc5:	73 17                	jae    800bde <vprintfmt+0x28a>
  800bc7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bcb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bce:	89 d2                	mov    %edx,%edx
  800bd0:	48 01 d0             	add    %rdx,%rax
  800bd3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd6:	83 c2 08             	add    $0x8,%edx
  800bd9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdc:	eb 0c                	jmp    800bea <vprintfmt+0x296>
  800bde:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800be2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800be6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bea:	4c 8b 20             	mov    (%rax),%r12
  800bed:	4d 85 e4             	test   %r12,%r12
  800bf0:	75 0a                	jne    800bfc <vprintfmt+0x2a8>
				p = "(null)";
  800bf2:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
  800bf9:	00 00 00 
			if (width > 0 && padc != '-')
  800bfc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c00:	7e 78                	jle    800c7a <vprintfmt+0x326>
  800c02:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c06:	74 72                	je     800c7a <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c08:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c0b:	48 98                	cltq   
  800c0d:	48 89 c6             	mov    %rax,%rsi
  800c10:	4c 89 e7             	mov    %r12,%rdi
  800c13:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  800c1a:	00 00 00 
  800c1d:	ff d0                	callq  *%rax
  800c1f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c22:	eb 17                	jmp    800c3b <vprintfmt+0x2e7>
					putch(padc, putdat);
  800c24:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c28:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c30:	48 89 ce             	mov    %rcx,%rsi
  800c33:	89 d7                	mov    %edx,%edi
  800c35:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c37:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3f:	7f e3                	jg     800c24 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c41:	eb 37                	jmp    800c7a <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800c43:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c47:	74 1e                	je     800c67 <vprintfmt+0x313>
  800c49:	83 fb 1f             	cmp    $0x1f,%ebx
  800c4c:	7e 05                	jle    800c53 <vprintfmt+0x2ff>
  800c4e:	83 fb 7e             	cmp    $0x7e,%ebx
  800c51:	7e 14                	jle    800c67 <vprintfmt+0x313>
					putch('?', putdat);
  800c53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5b:	48 89 d6             	mov    %rdx,%rsi
  800c5e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c63:	ff d0                	callq  *%rax
  800c65:	eb 0f                	jmp    800c76 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800c67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6f:	48 89 d6             	mov    %rdx,%rsi
  800c72:	89 df                	mov    %ebx,%edi
  800c74:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c76:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c7a:	4c 89 e0             	mov    %r12,%rax
  800c7d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c81:	0f b6 00             	movzbl (%rax),%eax
  800c84:	0f be d8             	movsbl %al,%ebx
  800c87:	85 db                	test   %ebx,%ebx
  800c89:	74 28                	je     800cb3 <vprintfmt+0x35f>
  800c8b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c8f:	78 b2                	js     800c43 <vprintfmt+0x2ef>
  800c91:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c95:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c99:	79 a8                	jns    800c43 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c9b:	eb 16                	jmp    800cb3 <vprintfmt+0x35f>
				putch(' ', putdat);
  800c9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca5:	48 89 d6             	mov    %rdx,%rsi
  800ca8:	bf 20 00 00 00       	mov    $0x20,%edi
  800cad:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800caf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb7:	7f e4                	jg     800c9d <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800cb9:	e9 8d 01 00 00       	jmpq   800e4b <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cbe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc2:	be 03 00 00 00       	mov    $0x3,%esi
  800cc7:	48 89 c7             	mov    %rax,%rdi
  800cca:	48 b8 4d 08 80 00 00 	movabs $0x80084d,%rax
  800cd1:	00 00 00 
  800cd4:	ff d0                	callq  *%rax
  800cd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cde:	48 85 c0             	test   %rax,%rax
  800ce1:	79 1d                	jns    800d00 <vprintfmt+0x3ac>
				putch('-', putdat);
  800ce3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cf3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf9:	48 f7 d8             	neg    %rax
  800cfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d00:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d07:	e9 d2 00 00 00       	jmpq   800dde <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d0c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d10:	be 03 00 00 00       	mov    $0x3,%esi
  800d15:	48 89 c7             	mov    %rax,%rdi
  800d18:	48 b8 46 07 80 00 00 	movabs $0x800746,%rax
  800d1f:	00 00 00 
  800d22:	ff d0                	callq  *%rax
  800d24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d28:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2f:	e9 aa 00 00 00       	jmpq   800dde <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800d34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d38:	be 03 00 00 00       	mov    $0x3,%esi
  800d3d:	48 89 c7             	mov    %rax,%rdi
  800d40:	48 b8 46 07 80 00 00 	movabs $0x800746,%rax
  800d47:	00 00 00 
  800d4a:	ff d0                	callq  *%rax
  800d4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d50:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d57:	e9 82 00 00 00       	jmpq   800dde <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800d5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d64:	48 89 d6             	mov    %rdx,%rsi
  800d67:	bf 30 00 00 00       	mov    $0x30,%edi
  800d6c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d76:	48 89 d6             	mov    %rdx,%rsi
  800d79:	bf 78 00 00 00       	mov    $0x78,%edi
  800d7e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d83:	83 f8 30             	cmp    $0x30,%eax
  800d86:	73 17                	jae    800d9f <vprintfmt+0x44b>
  800d88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d8c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8f:	89 d2                	mov    %edx,%edx
  800d91:	48 01 d0             	add    %rdx,%rax
  800d94:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d97:	83 c2 08             	add    $0x8,%edx
  800d9a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d9d:	eb 0c                	jmp    800dab <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800d9f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800da3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800da7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dab:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800db2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800db9:	eb 23                	jmp    800dde <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbf:	be 03 00 00 00       	mov    $0x3,%esi
  800dc4:	48 89 c7             	mov    %rax,%rdi
  800dc7:	48 b8 46 07 80 00 00 	movabs $0x800746,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	callq  *%rax
  800dd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dd7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dde:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800de3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800de6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800de9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ded:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df5:	45 89 c1             	mov    %r8d,%r9d
  800df8:	41 89 f8             	mov    %edi,%r8d
  800dfb:	48 89 c7             	mov    %rax,%rdi
  800dfe:	48 b8 8e 06 80 00 00 	movabs $0x80068e,%rax
  800e05:	00 00 00 
  800e08:	ff d0                	callq  *%rax
			break;
  800e0a:	eb 3f                	jmp    800e4b <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e14:	48 89 d6             	mov    %rdx,%rsi
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	ff d0                	callq  *%rax
			break;
  800e1b:	eb 2e                	jmp    800e4b <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	48 89 d6             	mov    %rdx,%rsi
  800e28:	bf 25 00 00 00       	mov    $0x25,%edi
  800e2d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e2f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e34:	eb 05                	jmp    800e3b <vprintfmt+0x4e7>
  800e36:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e3b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e3f:	48 83 e8 01          	sub    $0x1,%rax
  800e43:	0f b6 00             	movzbl (%rax),%eax
  800e46:	3c 25                	cmp    $0x25,%al
  800e48:	75 ec                	jne    800e36 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800e4a:	90                   	nop
		}
	}
  800e4b:	e9 3d fb ff ff       	jmpq   80098d <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e50:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e51:	48 83 c4 60          	add    $0x60,%rsp
  800e55:	5b                   	pop    %rbx
  800e56:	41 5c                	pop    %r12
  800e58:	5d                   	pop    %rbp
  800e59:	c3                   	retq   

0000000000800e5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e5a:	55                   	push   %rbp
  800e5b:	48 89 e5             	mov    %rsp,%rbp
  800e5e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e65:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e6c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e73:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800e7a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e81:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e88:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 20                	je     800eb3 <printfmt+0x59>
  800e93:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e97:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e9b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e9f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ea3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ea7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800eaf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eb3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eba:	00 00 00 
  800ebd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ec4:	00 00 00 
  800ec7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ecb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ed2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ee0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ee7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800eee:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ef5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800efc:	48 89 c7             	mov    %rax,%rdi
  800eff:	48 b8 54 09 80 00 00 	movabs $0x800954,%rax
  800f06:	00 00 00 
  800f09:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f0b:	90                   	nop
  800f0c:	c9                   	leaveq 
  800f0d:	c3                   	retq   

0000000000800f0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f0e:	55                   	push   %rbp
  800f0f:	48 89 e5             	mov    %rsp,%rbp
  800f12:	48 83 ec 10          	sub    $0x10,%rsp
  800f16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f21:	8b 40 10             	mov    0x10(%rax),%eax
  800f24:	8d 50 01             	lea    0x1(%rax),%edx
  800f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f32:	48 8b 10             	mov    (%rax),%rdx
  800f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f39:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f3d:	48 39 c2             	cmp    %rax,%rdx
  800f40:	73 17                	jae    800f59 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f46:	48 8b 00             	mov    (%rax),%rax
  800f49:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f51:	48 89 0a             	mov    %rcx,(%rdx)
  800f54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f57:	88 10                	mov    %dl,(%rax)
}
  800f59:	90                   	nop
  800f5a:	c9                   	leaveq 
  800f5b:	c3                   	retq   

0000000000800f5c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
  800f60:	48 83 ec 50          	sub    $0x50,%rsp
  800f64:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f68:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f6b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f6f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f73:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f77:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f7b:	48 8b 0a             	mov    (%rdx),%rcx
  800f7e:	48 89 08             	mov    %rcx,(%rax)
  800f81:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f85:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f89:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f8d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f91:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f95:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f99:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f9c:	48 98                	cltq   
  800f9e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fa2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa6:	48 01 d0             	add    %rdx,%rax
  800fa9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fb4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fb9:	74 06                	je     800fc1 <vsnprintf+0x65>
  800fbb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fbf:	7f 07                	jg     800fc8 <vsnprintf+0x6c>
		return -E_INVAL;
  800fc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc6:	eb 2f                	jmp    800ff7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fc8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fcc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fd0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fd4:	48 89 c6             	mov    %rax,%rsi
  800fd7:	48 bf 0e 0f 80 00 00 	movabs $0x800f0e,%rdi
  800fde:	00 00 00 
  800fe1:	48 b8 54 09 80 00 00 	movabs $0x800954,%rax
  800fe8:	00 00 00 
  800feb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ff1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ff4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ff7:	c9                   	leaveq 
  800ff8:	c3                   	retq   

0000000000800ff9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ff9:	55                   	push   %rbp
  800ffa:	48 89 e5             	mov    %rsp,%rbp
  800ffd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801004:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80100b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801011:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801018:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80101f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801026:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80102d:	84 c0                	test   %al,%al
  80102f:	74 20                	je     801051 <snprintf+0x58>
  801031:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801035:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801039:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80103d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801041:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801045:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801049:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80104d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801051:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801058:	00 00 00 
  80105b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801062:	00 00 00 
  801065:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801069:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801070:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801077:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80107e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801085:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80108c:	48 8b 0a             	mov    (%rdx),%rcx
  80108f:	48 89 08             	mov    %rcx,(%rax)
  801092:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801096:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80109a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80109e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010a2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010a9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010b0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010b6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010bd:	48 89 c7             	mov    %rax,%rdi
  8010c0:	48 b8 5c 0f 80 00 00 	movabs $0x800f5c,%rax
  8010c7:	00 00 00 
  8010ca:	ff d0                	callq  *%rax
  8010cc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 83 ec 18          	sub    $0x18,%rsp
  8010e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010ed:	eb 09                	jmp    8010f8 <strlen+0x1e>
		n++;
  8010ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fc:	0f b6 00             	movzbl (%rax),%eax
  8010ff:	84 c0                	test   %al,%al
  801101:	75 ec                	jne    8010ef <strlen+0x15>
		n++;
	return n;
  801103:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801106:	c9                   	leaveq 
  801107:	c3                   	retq   

0000000000801108 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801108:	55                   	push   %rbp
  801109:	48 89 e5             	mov    %rsp,%rbp
  80110c:	48 83 ec 20          	sub    $0x20,%rsp
  801110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80111f:	eb 0e                	jmp    80112f <strnlen+0x27>
		n++;
  801121:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801125:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80112a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80112f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801134:	74 0b                	je     801141 <strnlen+0x39>
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	0f b6 00             	movzbl (%rax),%eax
  80113d:	84 c0                	test   %al,%al
  80113f:	75 e0                	jne    801121 <strnlen+0x19>
		n++;
	return n;
  801141:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801144:	c9                   	leaveq 
  801145:	c3                   	retq   

0000000000801146 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
  80114a:	48 83 ec 20          	sub    $0x20,%rsp
  80114e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80115e:	90                   	nop
  80115f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801163:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801167:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80116b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801173:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801177:	0f b6 12             	movzbl (%rdx),%edx
  80117a:	88 10                	mov    %dl,(%rax)
  80117c:	0f b6 00             	movzbl (%rax),%eax
  80117f:	84 c0                	test   %al,%al
  801181:	75 dc                	jne    80115f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801187:	c9                   	leaveq 
  801188:	c3                   	retq   

0000000000801189 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	48 83 ec 20          	sub    $0x20,%rsp
  801191:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801195:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119d:	48 89 c7             	mov    %rax,%rdi
  8011a0:	48 b8 da 10 80 00 00 	movabs $0x8010da,%rax
  8011a7:	00 00 00 
  8011aa:	ff d0                	callq  *%rax
  8011ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b2:	48 63 d0             	movslq %eax,%rdx
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	48 01 c2             	add    %rax,%rdx
  8011bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c0:	48 89 c6             	mov    %rax,%rsi
  8011c3:	48 89 d7             	mov    %rdx,%rdi
  8011c6:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  8011cd:	00 00 00 
  8011d0:	ff d0                	callq  *%rax
	return dst;
  8011d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011d6:	c9                   	leaveq 
  8011d7:	c3                   	retq   

00000000008011d8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011d8:	55                   	push   %rbp
  8011d9:	48 89 e5             	mov    %rsp,%rbp
  8011dc:	48 83 ec 28          	sub    $0x28,%rsp
  8011e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011f4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011fb:	00 
  8011fc:	eb 2a                	jmp    801228 <strncpy+0x50>
		*dst++ = *src;
  8011fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801202:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801206:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80120a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120e:	0f b6 12             	movzbl (%rdx),%edx
  801211:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801217:	0f b6 00             	movzbl (%rax),%eax
  80121a:	84 c0                	test   %al,%al
  80121c:	74 05                	je     801223 <strncpy+0x4b>
			src++;
  80121e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801223:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801230:	72 cc                	jb     8011fe <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801236:	c9                   	leaveq 
  801237:	c3                   	retq   

0000000000801238 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801238:	55                   	push   %rbp
  801239:	48 89 e5             	mov    %rsp,%rbp
  80123c:	48 83 ec 28          	sub    $0x28,%rsp
  801240:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801244:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801248:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80124c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801250:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801254:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801259:	74 3d                	je     801298 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80125b:	eb 1d                	jmp    80127a <strlcpy+0x42>
			*dst++ = *src++;
  80125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801261:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801265:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801269:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801271:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801275:	0f b6 12             	movzbl (%rdx),%edx
  801278:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80127a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80127f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801284:	74 0b                	je     801291 <strlcpy+0x59>
  801286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128a:	0f b6 00             	movzbl (%rax),%eax
  80128d:	84 c0                	test   %al,%al
  80128f:	75 cc                	jne    80125d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801295:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801298:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a0:	48 29 c2             	sub    %rax,%rdx
  8012a3:	48 89 d0             	mov    %rdx,%rax
}
  8012a6:	c9                   	leaveq 
  8012a7:	c3                   	retq   

00000000008012a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012a8:	55                   	push   %rbp
  8012a9:	48 89 e5             	mov    %rsp,%rbp
  8012ac:	48 83 ec 10          	sub    $0x10,%rsp
  8012b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012b8:	eb 0a                	jmp    8012c4 <strcmp+0x1c>
		p++, q++;
  8012ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	74 12                	je     8012e1 <strcmp+0x39>
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	0f b6 10             	movzbl (%rax),%edx
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 d9                	je     8012ba <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e5:	0f b6 00             	movzbl (%rax),%eax
  8012e8:	0f b6 d0             	movzbl %al,%edx
  8012eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ef:	0f b6 00             	movzbl (%rax),%eax
  8012f2:	0f b6 c0             	movzbl %al,%eax
  8012f5:	29 c2                	sub    %eax,%edx
  8012f7:	89 d0                	mov    %edx,%eax
}
  8012f9:	c9                   	leaveq 
  8012fa:	c3                   	retq   

00000000008012fb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	48 83 ec 18          	sub    $0x18,%rsp
  801303:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801307:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80130b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80130f:	eb 0f                	jmp    801320 <strncmp+0x25>
		n--, p++, q++;
  801311:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801316:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80131b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801320:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801325:	74 1d                	je     801344 <strncmp+0x49>
  801327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132b:	0f b6 00             	movzbl (%rax),%eax
  80132e:	84 c0                	test   %al,%al
  801330:	74 12                	je     801344 <strncmp+0x49>
  801332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801336:	0f b6 10             	movzbl (%rax),%edx
  801339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133d:	0f b6 00             	movzbl (%rax),%eax
  801340:	38 c2                	cmp    %al,%dl
  801342:	74 cd                	je     801311 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801344:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801349:	75 07                	jne    801352 <strncmp+0x57>
		return 0;
  80134b:	b8 00 00 00 00       	mov    $0x0,%eax
  801350:	eb 18                	jmp    80136a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	0f b6 d0             	movzbl %al,%edx
  80135c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	0f b6 c0             	movzbl %al,%eax
  801366:	29 c2                	sub    %eax,%edx
  801368:	89 d0                	mov    %edx,%eax
}
  80136a:	c9                   	leaveq 
  80136b:	c3                   	retq   

000000000080136c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	48 83 ec 10          	sub    $0x10,%rsp
  801374:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801378:	89 f0                	mov    %esi,%eax
  80137a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80137d:	eb 17                	jmp    801396 <strchr+0x2a>
		if (*s == c)
  80137f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801383:	0f b6 00             	movzbl (%rax),%eax
  801386:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801389:	75 06                	jne    801391 <strchr+0x25>
			return (char *) s;
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	eb 15                	jmp    8013a6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801391:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	84 c0                	test   %al,%al
  80139f:	75 de                	jne    80137f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a6:	c9                   	leaveq 
  8013a7:	c3                   	retq   

00000000008013a8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a8:	55                   	push   %rbp
  8013a9:	48 89 e5             	mov    %rsp,%rbp
  8013ac:	48 83 ec 10          	sub    $0x10,%rsp
  8013b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b4:	89 f0                	mov    %esi,%eax
  8013b6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b9:	eb 11                	jmp    8013cc <strfind+0x24>
		if (*s == c)
  8013bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bf:	0f b6 00             	movzbl (%rax),%eax
  8013c2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c5:	74 12                	je     8013d9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d0:	0f b6 00             	movzbl (%rax),%eax
  8013d3:	84 c0                	test   %al,%al
  8013d5:	75 e4                	jne    8013bb <strfind+0x13>
  8013d7:	eb 01                	jmp    8013da <strfind+0x32>
		if (*s == c)
			break;
  8013d9:	90                   	nop
	return (char *) s;
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013de:	c9                   	leaveq 
  8013df:	c3                   	retq   

00000000008013e0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	48 83 ec 18          	sub    $0x18,%rsp
  8013e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ec:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f8:	75 06                	jne    801400 <memset+0x20>
		return v;
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	eb 69                	jmp    801469 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	83 e0 03             	and    $0x3,%eax
  801407:	48 85 c0             	test   %rax,%rax
  80140a:	75 48                	jne    801454 <memset+0x74>
  80140c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801410:	83 e0 03             	and    $0x3,%eax
  801413:	48 85 c0             	test   %rax,%rax
  801416:	75 3c                	jne    801454 <memset+0x74>
		c &= 0xFF;
  801418:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80141f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801422:	c1 e0 18             	shl    $0x18,%eax
  801425:	89 c2                	mov    %eax,%edx
  801427:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142a:	c1 e0 10             	shl    $0x10,%eax
  80142d:	09 c2                	or     %eax,%edx
  80142f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801432:	c1 e0 08             	shl    $0x8,%eax
  801435:	09 d0                	or     %edx,%eax
  801437:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80143a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143e:	48 c1 e8 02          	shr    $0x2,%rax
  801442:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801445:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801449:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144c:	48 89 d7             	mov    %rdx,%rdi
  80144f:	fc                   	cld    
  801450:	f3 ab                	rep stos %eax,%es:(%rdi)
  801452:	eb 11                	jmp    801465 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801454:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801458:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80145f:	48 89 d7             	mov    %rdx,%rdi
  801462:	fc                   	cld    
  801463:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801469:	c9                   	leaveq 
  80146a:	c3                   	retq   

000000000080146b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80146b:	55                   	push   %rbp
  80146c:	48 89 e5             	mov    %rsp,%rbp
  80146f:	48 83 ec 28          	sub    $0x28,%rsp
  801473:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801477:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80147b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80147f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801483:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801497:	0f 83 88 00 00 00    	jae    801525 <memmove+0xba>
  80149d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a5:	48 01 d0             	add    %rdx,%rax
  8014a8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014ac:	76 77                	jbe    801525 <memmove+0xba>
		s += n;
  8014ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ba:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	83 e0 03             	and    $0x3,%eax
  8014c5:	48 85 c0             	test   %rax,%rax
  8014c8:	75 3b                	jne    801505 <memmove+0x9a>
  8014ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ce:	83 e0 03             	and    $0x3,%eax
  8014d1:	48 85 c0             	test   %rax,%rax
  8014d4:	75 2f                	jne    801505 <memmove+0x9a>
  8014d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014da:	83 e0 03             	and    $0x3,%eax
  8014dd:	48 85 c0             	test   %rax,%rax
  8014e0:	75 23                	jne    801505 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e6:	48 83 e8 04          	sub    $0x4,%rax
  8014ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ee:	48 83 ea 04          	sub    $0x4,%rdx
  8014f2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014fa:	48 89 c7             	mov    %rax,%rdi
  8014fd:	48 89 d6             	mov    %rdx,%rsi
  801500:	fd                   	std    
  801501:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801503:	eb 1d                	jmp    801522 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801519:	48 89 d7             	mov    %rdx,%rdi
  80151c:	48 89 c1             	mov    %rax,%rcx
  80151f:	fd                   	std    
  801520:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801522:	fc                   	cld    
  801523:	eb 57                	jmp    80157c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801529:	83 e0 03             	and    $0x3,%eax
  80152c:	48 85 c0             	test   %rax,%rax
  80152f:	75 36                	jne    801567 <memmove+0xfc>
  801531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801535:	83 e0 03             	and    $0x3,%eax
  801538:	48 85 c0             	test   %rax,%rax
  80153b:	75 2a                	jne    801567 <memmove+0xfc>
  80153d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801541:	83 e0 03             	and    $0x3,%eax
  801544:	48 85 c0             	test   %rax,%rax
  801547:	75 1e                	jne    801567 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	48 c1 e8 02          	shr    $0x2,%rax
  801551:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801558:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 89 d6             	mov    %rdx,%rsi
  801562:	fc                   	cld    
  801563:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801565:	eb 15                	jmp    80157c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801567:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801573:	48 89 c7             	mov    %rax,%rdi
  801576:	48 89 d6             	mov    %rdx,%rsi
  801579:	fc                   	cld    
  80157a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80157c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801580:	c9                   	leaveq 
  801581:	c3                   	retq   

0000000000801582 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801582:	55                   	push   %rbp
  801583:	48 89 e5             	mov    %rsp,%rbp
  801586:	48 83 ec 18          	sub    $0x18,%rsp
  80158a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801592:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80159a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80159e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a2:	48 89 ce             	mov    %rcx,%rsi
  8015a5:	48 89 c7             	mov    %rax,%rdi
  8015a8:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  8015af:	00 00 00 
  8015b2:	ff d0                	callq  *%rax
}
  8015b4:	c9                   	leaveq 
  8015b5:	c3                   	retq   

00000000008015b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015b6:	55                   	push   %rbp
  8015b7:	48 89 e5             	mov    %rsp,%rbp
  8015ba:	48 83 ec 28          	sub    $0x28,%rsp
  8015be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015da:	eb 36                	jmp    801612 <memcmp+0x5c>
		if (*s1 != *s2)
  8015dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e0:	0f b6 10             	movzbl (%rax),%edx
  8015e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	38 c2                	cmp    %al,%dl
  8015ec:	74 1a                	je     801608 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	0f b6 d0             	movzbl %al,%edx
  8015f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	0f b6 c0             	movzbl %al,%eax
  801602:	29 c2                	sub    %eax,%edx
  801604:	89 d0                	mov    %edx,%eax
  801606:	eb 20                	jmp    801628 <memcmp+0x72>
		s1++, s2++;
  801608:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801616:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80161a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80161e:	48 85 c0             	test   %rax,%rax
  801621:	75 b9                	jne    8015dc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 28          	sub    $0x28,%rsp
  801632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801636:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801639:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80163d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	48 01 d0             	add    %rdx,%rax
  801648:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80164c:	eb 19                	jmp    801667 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	0f b6 d0             	movzbl %al,%edx
  801658:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80165b:	0f b6 c0             	movzbl %al,%eax
  80165e:	39 c2                	cmp    %eax,%edx
  801660:	74 11                	je     801673 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801662:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80166f:	72 dd                	jb     80164e <memfind+0x24>
  801671:	eb 01                	jmp    801674 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801673:	90                   	nop
	return (void *) s;
  801674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 38          	sub    $0x38,%rsp
  801682:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801686:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80168a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80168d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801694:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80169b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80169c:	eb 05                	jmp    8016a3 <strtol+0x29>
		s++;
  80169e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3c 20                	cmp    $0x20,%al
  8016ac:	74 f0                	je     80169e <strtol+0x24>
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	3c 09                	cmp    $0x9,%al
  8016b7:	74 e5                	je     80169e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	3c 2b                	cmp    $0x2b,%al
  8016c2:	75 07                	jne    8016cb <strtol+0x51>
		s++;
  8016c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c9:	eb 17                	jmp    8016e2 <strtol+0x68>
	else if (*s == '-')
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	3c 2d                	cmp    $0x2d,%al
  8016d4:	75 0c                	jne    8016e2 <strtol+0x68>
		s++, neg = 1;
  8016d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016db:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e6:	74 06                	je     8016ee <strtol+0x74>
  8016e8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016ec:	75 28                	jne    801716 <strtol+0x9c>
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	3c 30                	cmp    $0x30,%al
  8016f7:	75 1d                	jne    801716 <strtol+0x9c>
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	48 83 c0 01          	add    $0x1,%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 78                	cmp    $0x78,%al
  801706:	75 0e                	jne    801716 <strtol+0x9c>
		s += 2, base = 16;
  801708:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80170d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801714:	eb 2c                	jmp    801742 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801716:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80171a:	75 19                	jne    801735 <strtol+0xbb>
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	3c 30                	cmp    $0x30,%al
  801725:	75 0e                	jne    801735 <strtol+0xbb>
		s++, base = 8;
  801727:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80172c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801733:	eb 0d                	jmp    801742 <strtol+0xc8>
	else if (base == 0)
  801735:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801739:	75 07                	jne    801742 <strtol+0xc8>
		base = 10;
  80173b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 2f                	cmp    $0x2f,%al
  80174b:	7e 1d                	jle    80176a <strtol+0xf0>
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 39                	cmp    $0x39,%al
  801756:	7f 12                	jg     80176a <strtol+0xf0>
			dig = *s - '0';
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	0f be c0             	movsbl %al,%eax
  801762:	83 e8 30             	sub    $0x30,%eax
  801765:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801768:	eb 4e                	jmp    8017b8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	0f b6 00             	movzbl (%rax),%eax
  801771:	3c 60                	cmp    $0x60,%al
  801773:	7e 1d                	jle    801792 <strtol+0x118>
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	3c 7a                	cmp    $0x7a,%al
  80177e:	7f 12                	jg     801792 <strtol+0x118>
			dig = *s - 'a' + 10;
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	0f be c0             	movsbl %al,%eax
  80178a:	83 e8 57             	sub    $0x57,%eax
  80178d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801790:	eb 26                	jmp    8017b8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	3c 40                	cmp    $0x40,%al
  80179b:	7e 47                	jle    8017e4 <strtol+0x16a>
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	3c 5a                	cmp    $0x5a,%al
  8017a6:	7f 3c                	jg     8017e4 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8017a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	0f be c0             	movsbl %al,%eax
  8017b2:	83 e8 37             	sub    $0x37,%eax
  8017b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017bb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017be:	7d 23                	jge    8017e3 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8017c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017c5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017c8:	48 98                	cltq   
  8017ca:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017cf:	48 89 c2             	mov    %rax,%rdx
  8017d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017d5:	48 98                	cltq   
  8017d7:	48 01 d0             	add    %rdx,%rax
  8017da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017de:	e9 5f ff ff ff       	jmpq   801742 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017e9:	74 0b                	je     8017f6 <strtol+0x17c>
		*endptr = (char *) s;
  8017eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017f3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017fa:	74 09                	je     801805 <strtol+0x18b>
  8017fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801800:	48 f7 d8             	neg    %rax
  801803:	eb 04                	jmp    801809 <strtol+0x18f>
  801805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801809:	c9                   	leaveq 
  80180a:	c3                   	retq   

000000000080180b <strstr>:

char * strstr(const char *in, const char *str)
{
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
  80180f:	48 83 ec 30          	sub    $0x30,%rsp
  801813:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801817:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80181b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801823:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801827:	0f b6 00             	movzbl (%rax),%eax
  80182a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80182d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801831:	75 06                	jne    801839 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801837:	eb 6b                	jmp    8018a4 <strstr+0x99>

	len = strlen(str);
  801839:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183d:	48 89 c7             	mov    %rax,%rdi
  801840:	48 b8 da 10 80 00 00 	movabs $0x8010da,%rax
  801847:	00 00 00 
  80184a:	ff d0                	callq  *%rax
  80184c:	48 98                	cltq   
  80184e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80185a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801864:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801868:	75 07                	jne    801871 <strstr+0x66>
				return (char *) 0;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
  80186f:	eb 33                	jmp    8018a4 <strstr+0x99>
		} while (sc != c);
  801871:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801875:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801878:	75 d8                	jne    801852 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80187a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	48 89 ce             	mov    %rcx,%rsi
  801889:	48 89 c7             	mov    %rax,%rdi
  80188c:	48 b8 fb 12 80 00 00 	movabs $0x8012fb,%rax
  801893:	00 00 00 
  801896:	ff d0                	callq  *%rax
  801898:	85 c0                	test   %eax,%eax
  80189a:	75 b6                	jne    801852 <strstr+0x47>

	return (char *) (in - 1);
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	48 83 e8 01          	sub    $0x1,%rax
}
  8018a4:	c9                   	leaveq 
  8018a5:	c3                   	retq   

00000000008018a6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018a6:	55                   	push   %rbp
  8018a7:	48 89 e5             	mov    %rsp,%rbp
  8018aa:	53                   	push   %rbx
  8018ab:	48 83 ec 48          	sub    $0x48,%rsp
  8018af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018b2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018b5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018bd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018c1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018c8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018cc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018d0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018d4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018d8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018dc:	4c 89 c3             	mov    %r8,%rbx
  8018df:	cd 30                	int    $0x30
  8018e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018e9:	74 3e                	je     801929 <syscall+0x83>
  8018eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018f0:	7e 37                	jle    801929 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f9:	49 89 d0             	mov    %rdx,%r8
  8018fc:	89 c1                	mov    %eax,%ecx
  8018fe:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  801905:	00 00 00 
  801908:	be 24 00 00 00       	mov    $0x24,%esi
  80190d:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  801914:	00 00 00 
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
  80191c:	49 b9 7c 03 80 00 00 	movabs $0x80037c,%r9
  801923:	00 00 00 
  801926:	41 ff d1             	callq  *%r9

	return ret;
  801929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80192d:	48 83 c4 48          	add    $0x48,%rsp
  801931:	5b                   	pop    %rbx
  801932:	5d                   	pop    %rbp
  801933:	c3                   	retq   

0000000000801934 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	48 83 ec 10          	sub    $0x10,%rsp
  80193c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801940:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801944:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801948:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194c:	48 83 ec 08          	sub    $0x8,%rsp
  801950:	6a 00                	pushq  $0x0
  801952:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801958:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195e:	48 89 d1             	mov    %rdx,%rcx
  801961:	48 89 c2             	mov    %rax,%rdx
  801964:	be 00 00 00 00       	mov    $0x0,%esi
  801969:	bf 00 00 00 00       	mov    $0x0,%edi
  80196e:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801975:	00 00 00 
  801978:	ff d0                	callq  *%rax
  80197a:	48 83 c4 10          	add    $0x10,%rsp
}
  80197e:	90                   	nop
  80197f:	c9                   	leaveq 
  801980:	c3                   	retq   

0000000000801981 <sys_cgetc>:

int
sys_cgetc(void)
{
  801981:	55                   	push   %rbp
  801982:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801985:	48 83 ec 08          	sub    $0x8,%rsp
  801989:	6a 00                	pushq  $0x0
  80198b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801991:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801997:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199c:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a1:	be 00 00 00 00       	mov    $0x0,%esi
  8019a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ab:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  8019b2:	00 00 00 
  8019b5:	ff d0                	callq  *%rax
  8019b7:	48 83 c4 10          	add    $0x10,%rsp
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 10          	sub    $0x10,%rsp
  8019c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cb:	48 98                	cltq   
  8019cd:	48 83 ec 08          	sub    $0x8,%rsp
  8019d1:	6a 00                	pushq  $0x0
  8019d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e4:	48 89 c2             	mov    %rax,%rdx
  8019e7:	be 01 00 00 00       	mov    $0x1,%esi
  8019ec:	bf 03 00 00 00       	mov    $0x3,%edi
  8019f1:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  8019f8:	00 00 00 
  8019fb:	ff d0                	callq  *%rax
  8019fd:	48 83 c4 10          	add    $0x10,%rsp
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a07:	48 83 ec 08          	sub    $0x8,%rsp
  801a0b:	6a 00                	pushq  $0x0
  801a0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a19:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a23:	be 00 00 00 00       	mov    $0x0,%esi
  801a28:	bf 02 00 00 00       	mov    $0x2,%edi
  801a2d:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801a34:	00 00 00 
  801a37:	ff d0                	callq  *%rax
  801a39:	48 83 c4 10          	add    $0x10,%rsp
}
  801a3d:	c9                   	leaveq 
  801a3e:	c3                   	retq   

0000000000801a3f <sys_yield>:


void
sys_yield(void)
{
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a43:	48 83 ec 08          	sub    $0x8,%rsp
  801a47:	6a 00                	pushq  $0x0
  801a49:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a55:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5f:	be 00 00 00 00       	mov    $0x0,%esi
  801a64:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a69:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801a70:	00 00 00 
  801a73:	ff d0                	callq  *%rax
  801a75:	48 83 c4 10          	add    $0x10,%rsp
}
  801a79:	90                   	nop
  801a7a:	c9                   	leaveq 
  801a7b:	c3                   	retq   

0000000000801a7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	48 83 ec 10          	sub    $0x10,%rsp
  801a84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a8b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a91:	48 63 c8             	movslq %eax,%rcx
  801a94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9b:	48 98                	cltq   
  801a9d:	48 83 ec 08          	sub    $0x8,%rsp
  801aa1:	6a 00                	pushq  $0x0
  801aa3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa9:	49 89 c8             	mov    %rcx,%r8
  801aac:	48 89 d1             	mov    %rdx,%rcx
  801aaf:	48 89 c2             	mov    %rax,%rdx
  801ab2:	be 01 00 00 00       	mov    $0x1,%esi
  801ab7:	bf 04 00 00 00       	mov    $0x4,%edi
  801abc:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801ac3:	00 00 00 
  801ac6:	ff d0                	callq  *%rax
  801ac8:	48 83 c4 10          	add    $0x10,%rsp
}
  801acc:	c9                   	leaveq 
  801acd:	c3                   	retq   

0000000000801ace <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ace:	55                   	push   %rbp
  801acf:	48 89 e5             	mov    %rsp,%rbp
  801ad2:	48 83 ec 20          	sub    $0x20,%rsp
  801ad6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801add:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ae0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ae4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ae8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aeb:	48 63 c8             	movslq %eax,%rcx
  801aee:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801af2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801af5:	48 63 f0             	movslq %eax,%rsi
  801af8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801afc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aff:	48 98                	cltq   
  801b01:	48 83 ec 08          	sub    $0x8,%rsp
  801b05:	51                   	push   %rcx
  801b06:	49 89 f9             	mov    %rdi,%r9
  801b09:	49 89 f0             	mov    %rsi,%r8
  801b0c:	48 89 d1             	mov    %rdx,%rcx
  801b0f:	48 89 c2             	mov    %rax,%rdx
  801b12:	be 01 00 00 00       	mov    $0x1,%esi
  801b17:	bf 05 00 00 00       	mov    $0x5,%edi
  801b1c:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801b23:	00 00 00 
  801b26:	ff d0                	callq  *%rax
  801b28:	48 83 c4 10          	add    $0x10,%rsp
}
  801b2c:	c9                   	leaveq 
  801b2d:	c3                   	retq   

0000000000801b2e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b2e:	55                   	push   %rbp
  801b2f:	48 89 e5             	mov    %rsp,%rbp
  801b32:	48 83 ec 10          	sub    $0x10,%rsp
  801b36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b44:	48 98                	cltq   
  801b46:	48 83 ec 08          	sub    $0x8,%rsp
  801b4a:	6a 00                	pushq  $0x0
  801b4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b58:	48 89 d1             	mov    %rdx,%rcx
  801b5b:	48 89 c2             	mov    %rax,%rdx
  801b5e:	be 01 00 00 00       	mov    $0x1,%esi
  801b63:	bf 06 00 00 00       	mov    $0x6,%edi
  801b68:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
  801b74:	48 83 c4 10          	add    $0x10,%rsp
}
  801b78:	c9                   	leaveq 
  801b79:	c3                   	retq   

0000000000801b7a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b7a:	55                   	push   %rbp
  801b7b:	48 89 e5             	mov    %rsp,%rbp
  801b7e:	48 83 ec 10          	sub    $0x10,%rsp
  801b82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b85:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b8b:	48 63 d0             	movslq %eax,%rdx
  801b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b91:	48 98                	cltq   
  801b93:	48 83 ec 08          	sub    $0x8,%rsp
  801b97:	6a 00                	pushq  $0x0
  801b99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba5:	48 89 d1             	mov    %rdx,%rcx
  801ba8:	48 89 c2             	mov    %rax,%rdx
  801bab:	be 01 00 00 00       	mov    $0x1,%esi
  801bb0:	bf 08 00 00 00       	mov    $0x8,%edi
  801bb5:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801bbc:	00 00 00 
  801bbf:	ff d0                	callq  *%rax
  801bc1:	48 83 c4 10          	add    $0x10,%rsp
}
  801bc5:	c9                   	leaveq 
  801bc6:	c3                   	retq   

0000000000801bc7 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bc7:	55                   	push   %rbp
  801bc8:	48 89 e5             	mov    %rsp,%rbp
  801bcb:	48 83 ec 10          	sub    $0x10,%rsp
  801bcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdd:	48 98                	cltq   
  801bdf:	48 83 ec 08          	sub    $0x8,%rsp
  801be3:	6a 00                	pushq  $0x0
  801be5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801beb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf1:	48 89 d1             	mov    %rdx,%rcx
  801bf4:	48 89 c2             	mov    %rax,%rdx
  801bf7:	be 01 00 00 00       	mov    $0x1,%esi
  801bfc:	bf 09 00 00 00       	mov    $0x9,%edi
  801c01:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	callq  *%rax
  801c0d:	48 83 c4 10          	add    $0x10,%rsp
}
  801c11:	c9                   	leaveq 
  801c12:	c3                   	retq   

0000000000801c13 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c13:	55                   	push   %rbp
  801c14:	48 89 e5             	mov    %rsp,%rbp
  801c17:	48 83 ec 10          	sub    $0x10,%rsp
  801c1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c29:	48 98                	cltq   
  801c2b:	48 83 ec 08          	sub    $0x8,%rsp
  801c2f:	6a 00                	pushq  $0x0
  801c31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3d:	48 89 d1             	mov    %rdx,%rcx
  801c40:	48 89 c2             	mov    %rax,%rdx
  801c43:	be 01 00 00 00       	mov    $0x1,%esi
  801c48:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c4d:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
  801c59:	48 83 c4 10          	add    $0x10,%rsp
}
  801c5d:	c9                   	leaveq 
  801c5e:	c3                   	retq   

0000000000801c5f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c5f:	55                   	push   %rbp
  801c60:	48 89 e5             	mov    %rsp,%rbp
  801c63:	48 83 ec 20          	sub    $0x20,%rsp
  801c67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c6e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c72:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c78:	48 63 f0             	movslq %eax,%rsi
  801c7b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c82:	48 98                	cltq   
  801c84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c88:	48 83 ec 08          	sub    $0x8,%rsp
  801c8c:	6a 00                	pushq  $0x0
  801c8e:	49 89 f1             	mov    %rsi,%r9
  801c91:	49 89 c8             	mov    %rcx,%r8
  801c94:	48 89 d1             	mov    %rdx,%rcx
  801c97:	48 89 c2             	mov    %rax,%rdx
  801c9a:	be 00 00 00 00       	mov    $0x0,%esi
  801c9f:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ca4:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	callq  *%rax
  801cb0:	48 83 c4 10          	add    $0x10,%rsp
}
  801cb4:	c9                   	leaveq 
  801cb5:	c3                   	retq   

0000000000801cb6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cb6:	55                   	push   %rbp
  801cb7:	48 89 e5             	mov    %rsp,%rbp
  801cba:	48 83 ec 10          	sub    $0x10,%rsp
  801cbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc6:	48 83 ec 08          	sub    $0x8,%rsp
  801cca:	6a 00                	pushq  $0x0
  801ccc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cdd:	48 89 c2             	mov    %rax,%rdx
  801ce0:	be 01 00 00 00       	mov    $0x1,%esi
  801ce5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cea:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801cf1:	00 00 00 
  801cf4:	ff d0                	callq  *%rax
  801cf6:	48 83 c4 10          	add    $0x10,%rsp
}
  801cfa:	c9                   	leaveq 
  801cfb:	c3                   	retq   

0000000000801cfc <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801cfc:	55                   	push   %rbp
  801cfd:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d00:	48 83 ec 08          	sub    $0x8,%rsp
  801d04:	6a 00                	pushq  $0x0
  801d06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	be 00 00 00 00       	mov    $0x0,%esi
  801d21:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d26:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	callq  *%rax
  801d32:	48 83 c4 10          	add    $0x10,%rsp
}
  801d36:	c9                   	leaveq 
  801d37:	c3                   	retq   

0000000000801d38 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801d38:	55                   	push   %rbp
  801d39:	48 89 e5             	mov    %rsp,%rbp
  801d3c:	48 83 ec 10          	sub    $0x10,%rsp
  801d40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d44:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801d47:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4e:	48 83 ec 08          	sub    $0x8,%rsp
  801d52:	6a 00                	pushq  $0x0
  801d54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d60:	48 89 d1             	mov    %rdx,%rcx
  801d63:	48 89 c2             	mov    %rax,%rdx
  801d66:	be 00 00 00 00       	mov    $0x0,%esi
  801d6b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d70:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801d77:	00 00 00 
  801d7a:	ff d0                	callq  *%rax
  801d7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801d80:	c9                   	leaveq 
  801d81:	c3                   	retq   

0000000000801d82 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801d82:	55                   	push   %rbp
  801d83:	48 89 e5             	mov    %rsp,%rbp
  801d86:	48 83 ec 10          	sub    $0x10,%rsp
  801d8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d8e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d91:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d98:	48 83 ec 08          	sub    $0x8,%rsp
  801d9c:	6a 00                	pushq  $0x0
  801d9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801daa:	48 89 d1             	mov    %rdx,%rcx
  801dad:	48 89 c2             	mov    %rax,%rdx
  801db0:	be 00 00 00 00       	mov    $0x0,%esi
  801db5:	bf 10 00 00 00       	mov    $0x10,%edi
  801dba:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	48 83 c4 10          	add    $0x10,%rsp
}
  801dca:	c9                   	leaveq 
  801dcb:	c3                   	retq   

0000000000801dcc <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801dcc:	55                   	push   %rbp
  801dcd:	48 89 e5             	mov    %rsp,%rbp
  801dd0:	48 83 ec 20          	sub    $0x20,%rsp
  801dd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ddb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dde:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801de2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801de6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de9:	48 63 c8             	movslq %eax,%rcx
  801dec:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801df0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df3:	48 63 f0             	movslq %eax,%rsi
  801df6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfd:	48 98                	cltq   
  801dff:	48 83 ec 08          	sub    $0x8,%rsp
  801e03:	51                   	push   %rcx
  801e04:	49 89 f9             	mov    %rdi,%r9
  801e07:	49 89 f0             	mov    %rsi,%r8
  801e0a:	48 89 d1             	mov    %rdx,%rcx
  801e0d:	48 89 c2             	mov    %rax,%rdx
  801e10:	be 00 00 00 00       	mov    $0x0,%esi
  801e15:	bf 11 00 00 00       	mov    $0x11,%edi
  801e1a:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801e21:	00 00 00 
  801e24:	ff d0                	callq  *%rax
  801e26:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e2a:	c9                   	leaveq 
  801e2b:	c3                   	retq   

0000000000801e2c <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e2c:	55                   	push   %rbp
  801e2d:	48 89 e5             	mov    %rsp,%rbp
  801e30:	48 83 ec 10          	sub    $0x10,%rsp
  801e34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e44:	48 83 ec 08          	sub    $0x8,%rsp
  801e48:	6a 00                	pushq  $0x0
  801e4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e56:	48 89 d1             	mov    %rdx,%rcx
  801e59:	48 89 c2             	mov    %rax,%rdx
  801e5c:	be 00 00 00 00       	mov    $0x0,%esi
  801e61:	bf 12 00 00 00       	mov    $0x12,%edi
  801e66:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801e6d:	00 00 00 
  801e70:	ff d0                	callq  *%rax
  801e72:	48 83 c4 10          	add    $0x10,%rsp
}
  801e76:	c9                   	leaveq 
  801e77:	c3                   	retq   

0000000000801e78 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801e7c:	48 83 ec 08          	sub    $0x8,%rsp
  801e80:	6a 00                	pushq  $0x0
  801e82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e93:	ba 00 00 00 00       	mov    $0x0,%edx
  801e98:	be 00 00 00 00       	mov    $0x0,%esi
  801e9d:	bf 13 00 00 00       	mov    $0x13,%edi
  801ea2:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	callq  *%rax
  801eae:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801eb2:	90                   	nop
  801eb3:	c9                   	leaveq 
  801eb4:	c3                   	retq   

0000000000801eb5 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801eb5:	55                   	push   %rbp
  801eb6:	48 89 e5             	mov    %rsp,%rbp
  801eb9:	48 83 ec 10          	sub    $0x10,%rsp
  801ebd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec3:	48 98                	cltq   
  801ec5:	48 83 ec 08          	sub    $0x8,%rsp
  801ec9:	6a 00                	pushq  $0x0
  801ecb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801edc:	48 89 c2             	mov    %rax,%rdx
  801edf:	be 00 00 00 00       	mov    $0x0,%esi
  801ee4:	bf 14 00 00 00       	mov    $0x14,%edi
  801ee9:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
  801ef5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ef9:	c9                   	leaveq 
  801efa:	c3                   	retq   

0000000000801efb <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801efb:	55                   	push   %rbp
  801efc:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801eff:	48 83 ec 08          	sub    $0x8,%rsp
  801f03:	6a 00                	pushq  $0x0
  801f05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f16:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1b:	be 00 00 00 00       	mov    $0x0,%esi
  801f20:	bf 15 00 00 00       	mov    $0x15,%edi
  801f25:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
  801f31:	48 83 c4 10          	add    $0x10,%rsp
}
  801f35:	c9                   	leaveq 
  801f36:	c3                   	retq   

0000000000801f37 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f37:	55                   	push   %rbp
  801f38:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f3b:	48 83 ec 08          	sub    $0x8,%rsp
  801f3f:	6a 00                	pushq  $0x0
  801f41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f52:	ba 00 00 00 00       	mov    $0x0,%edx
  801f57:	be 00 00 00 00       	mov    $0x0,%esi
  801f5c:	bf 16 00 00 00       	mov    $0x16,%edi
  801f61:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  801f68:	00 00 00 
  801f6b:	ff d0                	callq  *%rax
  801f6d:	48 83 c4 10          	add    $0x10,%rsp
}
  801f71:	90                   	nop
  801f72:	c9                   	leaveq 
  801f73:	c3                   	retq   

0000000000801f74 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f74:	55                   	push   %rbp
  801f75:	48 89 e5             	mov    %rsp,%rbp
  801f78:	48 83 ec 08          	sub    $0x8,%rsp
  801f7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f80:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f84:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f8b:	ff ff ff 
  801f8e:	48 01 d0             	add    %rdx,%rax
  801f91:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f95:	c9                   	leaveq 
  801f96:	c3                   	retq   

0000000000801f97 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f97:	55                   	push   %rbp
  801f98:	48 89 e5             	mov    %rsp,%rbp
  801f9b:	48 83 ec 08          	sub    $0x8,%rsp
  801f9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa7:	48 89 c7             	mov    %rax,%rdi
  801faa:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	callq  *%rax
  801fb6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801fbc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801fc0:	c9                   	leaveq 
  801fc1:	c3                   	retq   

0000000000801fc2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801fc2:	55                   	push   %rbp
  801fc3:	48 89 e5             	mov    %rsp,%rbp
  801fc6:	48 83 ec 18          	sub    $0x18,%rsp
  801fca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fd5:	eb 6b                	jmp    802042 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fda:	48 98                	cltq   
  801fdc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fe2:	48 c1 e0 0c          	shl    $0xc,%rax
  801fe6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fee:	48 c1 e8 15          	shr    $0x15,%rax
  801ff2:	48 89 c2             	mov    %rax,%rdx
  801ff5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ffc:	01 00 00 
  801fff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802003:	83 e0 01             	and    $0x1,%eax
  802006:	48 85 c0             	test   %rax,%rax
  802009:	74 21                	je     80202c <fd_alloc+0x6a>
  80200b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200f:	48 c1 e8 0c          	shr    $0xc,%rax
  802013:	48 89 c2             	mov    %rax,%rdx
  802016:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80201d:	01 00 00 
  802020:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802024:	83 e0 01             	and    $0x1,%eax
  802027:	48 85 c0             	test   %rax,%rax
  80202a:	75 12                	jne    80203e <fd_alloc+0x7c>
			*fd_store = fd;
  80202c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802030:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802034:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	eb 1a                	jmp    802058 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80203e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802042:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802046:	7e 8f                	jle    801fd7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802053:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802058:	c9                   	leaveq 
  802059:	c3                   	retq   

000000000080205a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80205a:	55                   	push   %rbp
  80205b:	48 89 e5             	mov    %rsp,%rbp
  80205e:	48 83 ec 20          	sub    $0x20,%rsp
  802062:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802065:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802069:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80206d:	78 06                	js     802075 <fd_lookup+0x1b>
  80206f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802073:	7e 07                	jle    80207c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802075:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80207a:	eb 6c                	jmp    8020e8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80207c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80207f:	48 98                	cltq   
  802081:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802087:	48 c1 e0 0c          	shl    $0xc,%rax
  80208b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80208f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802093:	48 c1 e8 15          	shr    $0x15,%rax
  802097:	48 89 c2             	mov    %rax,%rdx
  80209a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a1:	01 00 00 
  8020a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a8:	83 e0 01             	and    $0x1,%eax
  8020ab:	48 85 c0             	test   %rax,%rax
  8020ae:	74 21                	je     8020d1 <fd_lookup+0x77>
  8020b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8020b8:	48 89 c2             	mov    %rax,%rdx
  8020bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c2:	01 00 00 
  8020c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c9:	83 e0 01             	and    $0x1,%eax
  8020cc:	48 85 c0             	test   %rax,%rax
  8020cf:	75 07                	jne    8020d8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020d6:	eb 10                	jmp    8020e8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8020d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020e0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e8:	c9                   	leaveq 
  8020e9:	c3                   	retq   

00000000008020ea <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8020ea:	55                   	push   %rbp
  8020eb:	48 89 e5             	mov    %rsp,%rbp
  8020ee:	48 83 ec 30          	sub    $0x30,%rsp
  8020f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8020f6:	89 f0                	mov    %esi,%eax
  8020f8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8020fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ff:	48 89 c7             	mov    %rax,%rdi
  802102:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
  80210e:	89 c2                	mov    %eax,%edx
  802110:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802114:	48 89 c6             	mov    %rax,%rsi
  802117:	89 d7                	mov    %edx,%edi
  802119:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212c:	78 0a                	js     802138 <fd_close+0x4e>
	    || fd != fd2)
  80212e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802132:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802136:	74 12                	je     80214a <fd_close+0x60>
		return (must_exist ? r : 0);
  802138:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80213c:	74 05                	je     802143 <fd_close+0x59>
  80213e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802141:	eb 70                	jmp    8021b3 <fd_close+0xc9>
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	eb 69                	jmp    8021b3 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80214a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214e:	8b 00                	mov    (%rax),%eax
  802150:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802154:	48 89 d6             	mov    %rdx,%rsi
  802157:	89 c7                	mov    %eax,%edi
  802159:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax
  802165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216c:	78 2a                	js     802198 <fd_close+0xae>
		if (dev->dev_close)
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	48 8b 40 20          	mov    0x20(%rax),%rax
  802176:	48 85 c0             	test   %rax,%rax
  802179:	74 16                	je     802191 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80217b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802183:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802187:	48 89 d7             	mov    %rdx,%rdi
  80218a:	ff d0                	callq  *%rax
  80218c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218f:	eb 07                	jmp    802198 <fd_close+0xae>
		else
			r = 0;
  802191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802198:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219c:	48 89 c6             	mov    %rax,%rsi
  80219f:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a4:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  8021ab:	00 00 00 
  8021ae:	ff d0                	callq  *%rax
	return r;
  8021b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021b3:	c9                   	leaveq 
  8021b4:	c3                   	retq   

00000000008021b5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021b5:	55                   	push   %rbp
  8021b6:	48 89 e5             	mov    %rsp,%rbp
  8021b9:	48 83 ec 20          	sub    $0x20,%rsp
  8021bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8021c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021cb:	eb 41                	jmp    80220e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8021cd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021d4:	00 00 00 
  8021d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021da:	48 63 d2             	movslq %edx,%rdx
  8021dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e1:	8b 00                	mov    (%rax),%eax
  8021e3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8021e6:	75 22                	jne    80220a <dev_lookup+0x55>
			*dev = devtab[i];
  8021e8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021ef:	00 00 00 
  8021f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021f5:	48 63 d2             	movslq %edx,%rdx
  8021f8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8021fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802200:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	eb 60                	jmp    80226a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80220a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80220e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802215:	00 00 00 
  802218:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80221b:	48 63 d2             	movslq %edx,%rdx
  80221e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802222:	48 85 c0             	test   %rax,%rax
  802225:	75 a6                	jne    8021cd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802227:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80222e:	00 00 00 
  802231:	48 8b 00             	mov    (%rax),%rax
  802234:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80223a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80223d:	89 c6                	mov    %eax,%esi
  80223f:	48 bf 18 4b 80 00 00 	movabs $0x804b18,%rdi
  802246:	00 00 00 
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	48 b9 b6 05 80 00 00 	movabs $0x8005b6,%rcx
  802255:	00 00 00 
  802258:	ff d1                	callq  *%rcx
	*dev = 0;
  80225a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80225e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80226a:	c9                   	leaveq 
  80226b:	c3                   	retq   

000000000080226c <close>:

int
close(int fdnum)
{
  80226c:	55                   	push   %rbp
  80226d:	48 89 e5             	mov    %rsp,%rbp
  802270:	48 83 ec 20          	sub    $0x20,%rsp
  802274:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802277:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80227b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80227e:	48 89 d6             	mov    %rdx,%rsi
  802281:	89 c7                	mov    %eax,%edi
  802283:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	callq  *%rax
  80228f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802296:	79 05                	jns    80229d <close+0x31>
		return r;
  802298:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229b:	eb 18                	jmp    8022b5 <close+0x49>
	else
		return fd_close(fd, 1);
  80229d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a1:	be 01 00 00 00       	mov    $0x1,%esi
  8022a6:	48 89 c7             	mov    %rax,%rdi
  8022a9:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  8022b0:	00 00 00 
  8022b3:	ff d0                	callq  *%rax
}
  8022b5:	c9                   	leaveq 
  8022b6:	c3                   	retq   

00000000008022b7 <close_all>:

void
close_all(void)
{
  8022b7:	55                   	push   %rbp
  8022b8:	48 89 e5             	mov    %rsp,%rbp
  8022bb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022c6:	eb 15                	jmp    8022dd <close_all+0x26>
		close(i);
  8022c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8022d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022dd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022e1:	7e e5                	jle    8022c8 <close_all+0x11>
		close(i);
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leaveq 
  8022e5:	c3                   	retq   

00000000008022e6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8022e6:	55                   	push   %rbp
  8022e7:	48 89 e5             	mov    %rsp,%rbp
  8022ea:	48 83 ec 40          	sub    $0x40,%rsp
  8022ee:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8022f1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8022f4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8022f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8022fb:	48 89 d6             	mov    %rdx,%rsi
  8022fe:	89 c7                	mov    %eax,%edi
  802300:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802307:	00 00 00 
  80230a:	ff d0                	callq  *%rax
  80230c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802313:	79 08                	jns    80231d <dup+0x37>
		return r;
  802315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802318:	e9 70 01 00 00       	jmpq   80248d <dup+0x1a7>
	close(newfdnum);
  80231d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802320:	89 c7                	mov    %eax,%edi
  802322:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80232e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802331:	48 98                	cltq   
  802333:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802339:	48 c1 e0 0c          	shl    $0xc,%rax
  80233d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802341:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802345:	48 89 c7             	mov    %rax,%rdi
  802348:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  80234f:	00 00 00 
  802352:	ff d0                	callq  *%rax
  802354:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	48 89 c7             	mov    %rax,%rdi
  80235f:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  802366:	00 00 00 
  802369:	ff d0                	callq  *%rax
  80236b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80236f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802373:	48 c1 e8 15          	shr    $0x15,%rax
  802377:	48 89 c2             	mov    %rax,%rdx
  80237a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802381:	01 00 00 
  802384:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802388:	83 e0 01             	and    $0x1,%eax
  80238b:	48 85 c0             	test   %rax,%rax
  80238e:	74 71                	je     802401 <dup+0x11b>
  802390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802394:	48 c1 e8 0c          	shr    $0xc,%rax
  802398:	48 89 c2             	mov    %rax,%rdx
  80239b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023a2:	01 00 00 
  8023a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a9:	83 e0 01             	and    $0x1,%eax
  8023ac:	48 85 c0             	test   %rax,%rax
  8023af:	74 50                	je     802401 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8023b9:	48 89 c2             	mov    %rax,%rdx
  8023bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023c3:	01 00 00 
  8023c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d9:	41 89 c8             	mov    %ecx,%r8d
  8023dc:	48 89 d1             	mov    %rdx,%rcx
  8023df:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e4:	48 89 c6             	mov    %rax,%rsi
  8023e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ec:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  8023f3:	00 00 00 
  8023f6:	ff d0                	callq  *%rax
  8023f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ff:	78 55                	js     802456 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802405:	48 c1 e8 0c          	shr    $0xc,%rax
  802409:	48 89 c2             	mov    %rax,%rdx
  80240c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802413:	01 00 00 
  802416:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241a:	25 07 0e 00 00       	and    $0xe07,%eax
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802425:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802429:	41 89 c8             	mov    %ecx,%r8d
  80242c:	48 89 d1             	mov    %rdx,%rcx
  80242f:	ba 00 00 00 00       	mov    $0x0,%edx
  802434:	48 89 c6             	mov    %rax,%rsi
  802437:	bf 00 00 00 00       	mov    $0x0,%edi
  80243c:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  802443:	00 00 00 
  802446:	ff d0                	callq  *%rax
  802448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244f:	78 08                	js     802459 <dup+0x173>
		goto err;

	return newfdnum;
  802451:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802454:	eb 37                	jmp    80248d <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802456:	90                   	nop
  802457:	eb 01                	jmp    80245a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802459:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80245a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245e:	48 89 c6             	mov    %rax,%rsi
  802461:	bf 00 00 00 00       	mov    $0x0,%edi
  802466:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802472:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802476:	48 89 c6             	mov    %rax,%rsi
  802479:	bf 00 00 00 00       	mov    $0x0,%edi
  80247e:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
	return r;
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80248d:	c9                   	leaveq 
  80248e:	c3                   	retq   

000000000080248f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80248f:	55                   	push   %rbp
  802490:	48 89 e5             	mov    %rsp,%rbp
  802493:	48 83 ec 40          	sub    $0x40,%rsp
  802497:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80249a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80249e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024a2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024a9:	48 89 d6             	mov    %rdx,%rsi
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8024b5:	00 00 00 
  8024b8:	ff d0                	callq  *%rax
  8024ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c1:	78 24                	js     8024e7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c7:	8b 00                	mov    (%rax),%eax
  8024c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024cd:	48 89 d6             	mov    %rdx,%rsi
  8024d0:	89 c7                	mov    %eax,%edi
  8024d2:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	callq  *%rax
  8024de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e5:	79 05                	jns    8024ec <read+0x5d>
		return r;
  8024e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ea:	eb 76                	jmp    802562 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8024ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f0:	8b 40 08             	mov    0x8(%rax),%eax
  8024f3:	83 e0 03             	and    $0x3,%eax
  8024f6:	83 f8 01             	cmp    $0x1,%eax
  8024f9:	75 3a                	jne    802535 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024fb:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802502:	00 00 00 
  802505:	48 8b 00             	mov    (%rax),%rax
  802508:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80250e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802511:	89 c6                	mov    %eax,%esi
  802513:	48 bf 37 4b 80 00 00 	movabs $0x804b37,%rdi
  80251a:	00 00 00 
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
  802522:	48 b9 b6 05 80 00 00 	movabs $0x8005b6,%rcx
  802529:	00 00 00 
  80252c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80252e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802533:	eb 2d                	jmp    802562 <read+0xd3>
	}
	if (!dev->dev_read)
  802535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802539:	48 8b 40 10          	mov    0x10(%rax),%rax
  80253d:	48 85 c0             	test   %rax,%rax
  802540:	75 07                	jne    802549 <read+0xba>
		return -E_NOT_SUPP;
  802542:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802547:	eb 19                	jmp    802562 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802551:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802555:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802559:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80255d:	48 89 cf             	mov    %rcx,%rdi
  802560:	ff d0                	callq  *%rax
}
  802562:	c9                   	leaveq 
  802563:	c3                   	retq   

0000000000802564 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802564:	55                   	push   %rbp
  802565:	48 89 e5             	mov    %rsp,%rbp
  802568:	48 83 ec 30          	sub    $0x30,%rsp
  80256c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80256f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802573:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80257e:	eb 47                	jmp    8025c7 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802583:	48 98                	cltq   
  802585:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802589:	48 29 c2             	sub    %rax,%rdx
  80258c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258f:	48 63 c8             	movslq %eax,%rcx
  802592:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802596:	48 01 c1             	add    %rax,%rcx
  802599:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80259c:	48 89 ce             	mov    %rcx,%rsi
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025b4:	79 05                	jns    8025bb <readn+0x57>
			return m;
  8025b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025b9:	eb 1d                	jmp    8025d8 <readn+0x74>
		if (m == 0)
  8025bb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025bf:	74 13                	je     8025d4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025c4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8025c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ca:	48 98                	cltq   
  8025cc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8025d0:	72 ae                	jb     802580 <readn+0x1c>
  8025d2:	eb 01                	jmp    8025d5 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8025d4:	90                   	nop
	}
	return tot;
  8025d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025d8:	c9                   	leaveq 
  8025d9:	c3                   	retq   

00000000008025da <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8025da:	55                   	push   %rbp
  8025db:	48 89 e5             	mov    %rsp,%rbp
  8025de:	48 83 ec 40          	sub    $0x40,%rsp
  8025e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f4:	48 89 d6             	mov    %rdx,%rsi
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802608:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260c:	78 24                	js     802632 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802612:	8b 00                	mov    (%rax),%eax
  802614:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802618:	48 89 d6             	mov    %rdx,%rsi
  80261b:	89 c7                	mov    %eax,%edi
  80261d:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802624:	00 00 00 
  802627:	ff d0                	callq  *%rax
  802629:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802630:	79 05                	jns    802637 <write+0x5d>
		return r;
  802632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802635:	eb 75                	jmp    8026ac <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263b:	8b 40 08             	mov    0x8(%rax),%eax
  80263e:	83 e0 03             	and    $0x3,%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	75 3a                	jne    80267f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802645:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80264c:	00 00 00 
  80264f:	48 8b 00             	mov    (%rax),%rax
  802652:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802658:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80265b:	89 c6                	mov    %eax,%esi
  80265d:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  802664:	00 00 00 
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	48 b9 b6 05 80 00 00 	movabs $0x8005b6,%rcx
  802673:	00 00 00 
  802676:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802678:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80267d:	eb 2d                	jmp    8026ac <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 8b 40 18          	mov    0x18(%rax),%rax
  802687:	48 85 c0             	test   %rax,%rax
  80268a:	75 07                	jne    802693 <write+0xb9>
		return -E_NOT_SUPP;
  80268c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802691:	eb 19                	jmp    8026ac <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802697:	48 8b 40 18          	mov    0x18(%rax),%rax
  80269b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80269f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026a3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026a7:	48 89 cf             	mov    %rcx,%rdi
  8026aa:	ff d0                	callq  *%rax
}
  8026ac:	c9                   	leaveq 
  8026ad:	c3                   	retq   

00000000008026ae <seek>:

int
seek(int fdnum, off_t offset)
{
  8026ae:	55                   	push   %rbp
  8026af:	48 89 e5             	mov    %rsp,%rbp
  8026b2:	48 83 ec 18          	sub    $0x18,%rsp
  8026b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026c3:	48 89 d6             	mov    %rdx,%rsi
  8026c6:	89 c7                	mov    %eax,%edi
  8026c8:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	callq  *%rax
  8026d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026db:	79 05                	jns    8026e2 <seek+0x34>
		return r;
  8026dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e0:	eb 0f                	jmp    8026f1 <seek+0x43>
	fd->fd_offset = offset;
  8026e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f1:	c9                   	leaveq 
  8026f2:	c3                   	retq   

00000000008026f3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8026f3:	55                   	push   %rbp
  8026f4:	48 89 e5             	mov    %rsp,%rbp
  8026f7:	48 83 ec 30          	sub    $0x30,%rsp
  8026fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026fe:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802701:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802705:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802708:	48 89 d6             	mov    %rdx,%rsi
  80270b:	89 c7                	mov    %eax,%edi
  80270d:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802714:	00 00 00 
  802717:	ff d0                	callq  *%rax
  802719:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802720:	78 24                	js     802746 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802726:	8b 00                	mov    (%rax),%eax
  802728:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80272c:	48 89 d6             	mov    %rdx,%rsi
  80272f:	89 c7                	mov    %eax,%edi
  802731:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802738:	00 00 00 
  80273b:	ff d0                	callq  *%rax
  80273d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802740:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802744:	79 05                	jns    80274b <ftruncate+0x58>
		return r;
  802746:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802749:	eb 72                	jmp    8027bd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80274b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274f:	8b 40 08             	mov    0x8(%rax),%eax
  802752:	83 e0 03             	and    $0x3,%eax
  802755:	85 c0                	test   %eax,%eax
  802757:	75 3a                	jne    802793 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802759:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802760:	00 00 00 
  802763:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802766:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80276c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80276f:	89 c6                	mov    %eax,%esi
  802771:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  802778:	00 00 00 
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	48 b9 b6 05 80 00 00 	movabs $0x8005b6,%rcx
  802787:	00 00 00 
  80278a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80278c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802791:	eb 2a                	jmp    8027bd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802793:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802797:	48 8b 40 30          	mov    0x30(%rax),%rax
  80279b:	48 85 c0             	test   %rax,%rax
  80279e:	75 07                	jne    8027a7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8027a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a5:	eb 16                	jmp    8027bd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8027a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ab:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027b3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027b6:	89 ce                	mov    %ecx,%esi
  8027b8:	48 89 d7             	mov    %rdx,%rdi
  8027bb:	ff d0                	callq  *%rax
}
  8027bd:	c9                   	leaveq 
  8027be:	c3                   	retq   

00000000008027bf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	48 83 ec 30          	sub    $0x30,%rsp
  8027c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027ce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027d5:	48 89 d6             	mov    %rdx,%rsi
  8027d8:	89 c7                	mov    %eax,%edi
  8027da:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
  8027e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ed:	78 24                	js     802813 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f3:	8b 00                	mov    (%rax),%eax
  8027f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027f9:	48 89 d6             	mov    %rdx,%rsi
  8027fc:	89 c7                	mov    %eax,%edi
  8027fe:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802805:	00 00 00 
  802808:	ff d0                	callq  *%rax
  80280a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802811:	79 05                	jns    802818 <fstat+0x59>
		return r;
  802813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802816:	eb 5e                	jmp    802876 <fstat+0xb7>
	if (!dev->dev_stat)
  802818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802820:	48 85 c0             	test   %rax,%rax
  802823:	75 07                	jne    80282c <fstat+0x6d>
		return -E_NOT_SUPP;
  802825:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80282a:	eb 4a                	jmp    802876 <fstat+0xb7>
	stat->st_name[0] = 0;
  80282c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802830:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802833:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802837:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80283e:	00 00 00 
	stat->st_isdir = 0;
  802841:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802845:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80284c:	00 00 00 
	stat->st_dev = dev;
  80284f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802853:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802857:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80285e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802862:	48 8b 40 28          	mov    0x28(%rax),%rax
  802866:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80286a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80286e:	48 89 ce             	mov    %rcx,%rsi
  802871:	48 89 d7             	mov    %rdx,%rdi
  802874:	ff d0                	callq  *%rax
}
  802876:	c9                   	leaveq 
  802877:	c3                   	retq   

0000000000802878 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802878:	55                   	push   %rbp
  802879:	48 89 e5             	mov    %rsp,%rbp
  80287c:	48 83 ec 20          	sub    $0x20,%rsp
  802880:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802884:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288c:	be 00 00 00 00       	mov    $0x0,%esi
  802891:	48 89 c7             	mov    %rax,%rdi
  802894:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  80289b:	00 00 00 
  80289e:	ff d0                	callq  *%rax
  8028a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a7:	79 05                	jns    8028ae <stat+0x36>
		return fd;
  8028a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ac:	eb 2f                	jmp    8028dd <stat+0x65>
	r = fstat(fd, stat);
  8028ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b5:	48 89 d6             	mov    %rdx,%rsi
  8028b8:	89 c7                	mov    %eax,%edi
  8028ba:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  8028c1:	00 00 00 
  8028c4:	ff d0                	callq  *%rax
  8028c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8028c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cc:	89 c7                	mov    %eax,%edi
  8028ce:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  8028d5:	00 00 00 
  8028d8:	ff d0                	callq  *%rax
	return r;
  8028da:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8028dd:	c9                   	leaveq 
  8028de:	c3                   	retq   

00000000008028df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	48 83 ec 10          	sub    $0x10,%rsp
  8028e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8028ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8028ee:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8028f5:	00 00 00 
  8028f8:	8b 00                	mov    (%rax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	75 1f                	jne    80291d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8028fe:	bf 01 00 00 00       	mov    $0x1,%edi
  802903:	48 b8 7e 44 80 00 00 	movabs $0x80447e,%rax
  80290a:	00 00 00 
  80290d:	ff d0                	callq  *%rax
  80290f:	89 c2                	mov    %eax,%edx
  802911:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802918:	00 00 00 
  80291b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80291d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802924:	00 00 00 
  802927:	8b 00                	mov    (%rax),%eax
  802929:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80292c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802931:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802938:	00 00 00 
  80293b:	89 c7                	mov    %eax,%edi
  80293d:	48 b8 e9 43 80 00 00 	movabs $0x8043e9,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802949:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294d:	ba 00 00 00 00       	mov    $0x0,%edx
  802952:	48 89 c6             	mov    %rax,%rsi
  802955:	bf 00 00 00 00       	mov    $0x0,%edi
  80295a:	48 b8 28 43 80 00 00 	movabs $0x804328,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
}
  802966:	c9                   	leaveq 
  802967:	c3                   	retq   

0000000000802968 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802968:	55                   	push   %rbp
  802969:	48 89 e5             	mov    %rsp,%rbp
  80296c:	48 83 ec 20          	sub    $0x20,%rsp
  802970:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802974:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297b:	48 89 c7             	mov    %rax,%rdi
  80297e:	48 b8 da 10 80 00 00 	movabs $0x8010da,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
  80298a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80298f:	7e 0a                	jle    80299b <open+0x33>
		return -E_BAD_PATH;
  802991:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802996:	e9 a5 00 00 00       	jmpq   802a40 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80299b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80299f:	48 89 c7             	mov    %rax,%rdi
  8029a2:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
  8029ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b5:	79 08                	jns    8029bf <open+0x57>
		return r;
  8029b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ba:	e9 81 00 00 00       	jmpq   802a40 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8029bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c3:	48 89 c6             	mov    %rax,%rsi
  8029c6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8029cd:	00 00 00 
  8029d0:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8029dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e3:	00 00 00 
  8029e6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8029e9:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8029ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f3:	48 89 c6             	mov    %rax,%rsi
  8029f6:	bf 01 00 00 00       	mov    $0x1,%edi
  8029fb:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	callq  *%rax
  802a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0e:	79 1d                	jns    802a2d <open+0xc5>
		fd_close(fd, 0);
  802a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a14:	be 00 00 00 00       	mov    $0x0,%esi
  802a19:	48 89 c7             	mov    %rax,%rdi
  802a1c:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax
		return r;
  802a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2b:	eb 13                	jmp    802a40 <open+0xd8>
	}

	return fd2num(fd);
  802a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a31:	48 89 c7             	mov    %rax,%rdi
  802a34:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax

}
  802a40:	c9                   	leaveq 
  802a41:	c3                   	retq   

0000000000802a42 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a42:	55                   	push   %rbp
  802a43:	48 89 e5             	mov    %rsp,%rbp
  802a46:	48 83 ec 10          	sub    $0x10,%rsp
  802a4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a52:	8b 50 0c             	mov    0xc(%rax),%edx
  802a55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a5c:	00 00 00 
  802a5f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a61:	be 00 00 00 00       	mov    $0x0,%esi
  802a66:	bf 06 00 00 00       	mov    $0x6,%edi
  802a6b:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
}
  802a77:	c9                   	leaveq 
  802a78:	c3                   	retq   

0000000000802a79 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a79:	55                   	push   %rbp
  802a7a:	48 89 e5             	mov    %rsp,%rbp
  802a7d:	48 83 ec 30          	sub    $0x30,%rsp
  802a81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a89:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a91:	8b 50 0c             	mov    0xc(%rax),%edx
  802a94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a9b:	00 00 00 
  802a9e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802aa0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa7:	00 00 00 
  802aaa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aae:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802ab2:	be 00 00 00 00       	mov    $0x0,%esi
  802ab7:	bf 03 00 00 00       	mov    $0x3,%edi
  802abc:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acf:	79 08                	jns    802ad9 <devfile_read+0x60>
		return r;
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	e9 a4 00 00 00       	jmpq   802b7d <devfile_read+0x104>
	assert(r <= n);
  802ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adc:	48 98                	cltq   
  802ade:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ae2:	76 35                	jbe    802b19 <devfile_read+0xa0>
  802ae4:	48 b9 96 4b 80 00 00 	movabs $0x804b96,%rcx
  802aeb:	00 00 00 
  802aee:	48 ba 9d 4b 80 00 00 	movabs $0x804b9d,%rdx
  802af5:	00 00 00 
  802af8:	be 86 00 00 00       	mov    $0x86,%esi
  802afd:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802b04:	00 00 00 
  802b07:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0c:	49 b8 7c 03 80 00 00 	movabs $0x80037c,%r8
  802b13:	00 00 00 
  802b16:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802b19:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802b20:	7e 35                	jle    802b57 <devfile_read+0xde>
  802b22:	48 b9 bd 4b 80 00 00 	movabs $0x804bbd,%rcx
  802b29:	00 00 00 
  802b2c:	48 ba 9d 4b 80 00 00 	movabs $0x804b9d,%rdx
  802b33:	00 00 00 
  802b36:	be 87 00 00 00       	mov    $0x87,%esi
  802b3b:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802b42:	00 00 00 
  802b45:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4a:	49 b8 7c 03 80 00 00 	movabs $0x80037c,%r8
  802b51:	00 00 00 
  802b54:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5a:	48 63 d0             	movslq %eax,%rdx
  802b5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b61:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b68:	00 00 00 
  802b6b:	48 89 c7             	mov    %rax,%rdi
  802b6e:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  802b75:	00 00 00 
  802b78:	ff d0                	callq  *%rax
	return r;
  802b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802b7d:	c9                   	leaveq 
  802b7e:	c3                   	retq   

0000000000802b7f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b7f:	55                   	push   %rbp
  802b80:	48 89 e5             	mov    %rsp,%rbp
  802b83:	48 83 ec 40          	sub    $0x40,%rsp
  802b87:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b8b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b8f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802b93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b9b:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802ba2:	00 
  802ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802bab:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802bb0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802bb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bb8:	8b 50 0c             	mov    0xc(%rax),%edx
  802bbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bc2:	00 00 00 
  802bc5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802bc7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bce:	00 00 00 
  802bd1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bd5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802bd9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bdd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be1:	48 89 c6             	mov    %rax,%rsi
  802be4:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802beb:	00 00 00 
  802bee:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  802bf5:	00 00 00 
  802bf8:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802bfa:	be 00 00 00 00       	mov    $0x0,%esi
  802bff:	bf 04 00 00 00       	mov    $0x4,%edi
  802c04:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c13:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c17:	79 05                	jns    802c1e <devfile_write+0x9f>
		return r;
  802c19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c1c:	eb 43                	jmp    802c61 <devfile_write+0xe2>
	assert(r <= n);
  802c1e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c21:	48 98                	cltq   
  802c23:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802c27:	76 35                	jbe    802c5e <devfile_write+0xdf>
  802c29:	48 b9 96 4b 80 00 00 	movabs $0x804b96,%rcx
  802c30:	00 00 00 
  802c33:	48 ba 9d 4b 80 00 00 	movabs $0x804b9d,%rdx
  802c3a:	00 00 00 
  802c3d:	be a2 00 00 00       	mov    $0xa2,%esi
  802c42:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802c49:	00 00 00 
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	49 b8 7c 03 80 00 00 	movabs $0x80037c,%r8
  802c58:	00 00 00 
  802c5b:	41 ff d0             	callq  *%r8
	return r;
  802c5e:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802c61:	c9                   	leaveq 
  802c62:	c3                   	retq   

0000000000802c63 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c63:	55                   	push   %rbp
  802c64:	48 89 e5             	mov    %rsp,%rbp
  802c67:	48 83 ec 20          	sub    $0x20,%rsp
  802c6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c77:	8b 50 0c             	mov    0xc(%rax),%edx
  802c7a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c81:	00 00 00 
  802c84:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c86:	be 00 00 00 00       	mov    $0x0,%esi
  802c8b:	bf 05 00 00 00       	mov    $0x5,%edi
  802c90:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca3:	79 05                	jns    802caa <devfile_stat+0x47>
		return r;
  802ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca8:	eb 56                	jmp    802d00 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802caa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cae:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802cb5:	00 00 00 
  802cb8:	48 89 c7             	mov    %rax,%rdi
  802cbb:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802cc7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cce:	00 00 00 
  802cd1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802cd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cdb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ce1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ce8:	00 00 00 
  802ceb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802cf1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d00:	c9                   	leaveq 
  802d01:	c3                   	retq   

0000000000802d02 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d02:	55                   	push   %rbp
  802d03:	48 89 e5             	mov    %rsp,%rbp
  802d06:	48 83 ec 10          	sub    $0x10,%rsp
  802d0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d0e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d15:	8b 50 0c             	mov    0xc(%rax),%edx
  802d18:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d1f:	00 00 00 
  802d22:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802d24:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d2b:	00 00 00 
  802d2e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802d31:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d34:	be 00 00 00 00       	mov    $0x0,%esi
  802d39:	bf 02 00 00 00       	mov    $0x2,%edi
  802d3e:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
}
  802d4a:	c9                   	leaveq 
  802d4b:	c3                   	retq   

0000000000802d4c <remove>:

// Delete a file
int
remove(const char *path)
{
  802d4c:	55                   	push   %rbp
  802d4d:	48 89 e5             	mov    %rsp,%rbp
  802d50:	48 83 ec 10          	sub    $0x10,%rsp
  802d54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d5c:	48 89 c7             	mov    %rax,%rdi
  802d5f:	48 b8 da 10 80 00 00 	movabs $0x8010da,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
  802d6b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d70:	7e 07                	jle    802d79 <remove+0x2d>
		return -E_BAD_PATH;
  802d72:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d77:	eb 33                	jmp    802dac <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7d:	48 89 c6             	mov    %rax,%rsi
  802d80:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d87:	00 00 00 
  802d8a:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d96:	be 00 00 00 00       	mov    $0x0,%esi
  802d9b:	bf 07 00 00 00       	mov    $0x7,%edi
  802da0:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802da7:	00 00 00 
  802daa:	ff d0                	callq  *%rax
}
  802dac:	c9                   	leaveq 
  802dad:	c3                   	retq   

0000000000802dae <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802dae:	55                   	push   %rbp
  802daf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802db2:	be 00 00 00 00       	mov    $0x0,%esi
  802db7:	bf 08 00 00 00       	mov    $0x8,%edi
  802dbc:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  802dc3:	00 00 00 
  802dc6:	ff d0                	callq  *%rax
}
  802dc8:	5d                   	pop    %rbp
  802dc9:	c3                   	retq   

0000000000802dca <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802dca:	55                   	push   %rbp
  802dcb:	48 89 e5             	mov    %rsp,%rbp
  802dce:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802dd5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ddc:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802de3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802dea:	be 00 00 00 00       	mov    $0x0,%esi
  802def:	48 89 c7             	mov    %rax,%rdi
  802df2:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  802df9:	00 00 00 
  802dfc:	ff d0                	callq  *%rax
  802dfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802e01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e05:	79 28                	jns    802e2f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0a:	89 c6                	mov    %eax,%esi
  802e0c:	48 bf c9 4b 80 00 00 	movabs $0x804bc9,%rdi
  802e13:	00 00 00 
  802e16:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1b:	48 ba b6 05 80 00 00 	movabs $0x8005b6,%rdx
  802e22:	00 00 00 
  802e25:	ff d2                	callq  *%rdx
		return fd_src;
  802e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2a:	e9 76 01 00 00       	jmpq   802fa5 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802e2f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802e36:	be 01 01 00 00       	mov    $0x101,%esi
  802e3b:	48 89 c7             	mov    %rax,%rdi
  802e3e:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax
  802e4a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e4d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e51:	0f 89 ad 00 00 00    	jns    802f04 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e5a:	89 c6                	mov    %eax,%esi
  802e5c:	48 bf df 4b 80 00 00 	movabs $0x804bdf,%rdi
  802e63:	00 00 00 
  802e66:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6b:	48 ba b6 05 80 00 00 	movabs $0x8005b6,%rdx
  802e72:	00 00 00 
  802e75:	ff d2                	callq  *%rdx
		close(fd_src);
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7a:	89 c7                	mov    %eax,%edi
  802e7c:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802e83:	00 00 00 
  802e86:	ff d0                	callq  *%rax
		return fd_dest;
  802e88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e8b:	e9 15 01 00 00       	jmpq   802fa5 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802e90:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e93:	48 63 d0             	movslq %eax,%rdx
  802e96:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea0:	48 89 ce             	mov    %rcx,%rsi
  802ea3:	89 c7                	mov    %eax,%edi
  802ea5:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
  802eb1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802eb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802eb8:	79 4a                	jns    802f04 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802eba:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ebd:	89 c6                	mov    %eax,%esi
  802ebf:	48 bf f9 4b 80 00 00 	movabs $0x804bf9,%rdi
  802ec6:	00 00 00 
  802ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ece:	48 ba b6 05 80 00 00 	movabs $0x8005b6,%rdx
  802ed5:	00 00 00 
  802ed8:	ff d2                	callq  *%rdx
			close(fd_src);
  802eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edd:	89 c7                	mov    %eax,%edi
  802edf:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
			close(fd_dest);
  802eeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
			return write_size;
  802efc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802eff:	e9 a1 00 00 00       	jmpq   802fa5 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f04:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0e:	ba 00 02 00 00       	mov    $0x200,%edx
  802f13:	48 89 ce             	mov    %rcx,%rsi
  802f16:	89 c7                	mov    %eax,%edi
  802f18:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	callq  *%rax
  802f24:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f2b:	0f 8f 5f ff ff ff    	jg     802e90 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f35:	79 47                	jns    802f7e <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802f37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f3a:	89 c6                	mov    %eax,%esi
  802f3c:	48 bf 0c 4c 80 00 00 	movabs $0x804c0c,%rdi
  802f43:	00 00 00 
  802f46:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4b:	48 ba b6 05 80 00 00 	movabs $0x8005b6,%rdx
  802f52:	00 00 00 
  802f55:	ff d2                	callq  *%rdx
		close(fd_src);
  802f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5a:	89 c7                	mov    %eax,%edi
  802f5c:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
		close(fd_dest);
  802f68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f6b:	89 c7                	mov    %eax,%edi
  802f6d:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
		return read_size;
  802f79:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f7c:	eb 27                	jmp    802fa5 <copy+0x1db>
	}
	close(fd_src);
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f81:	89 c7                	mov    %eax,%edi
  802f83:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
	close(fd_dest);
  802f8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f92:	89 c7                	mov    %eax,%edi
  802f94:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
	return 0;
  802fa0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802fa5:	c9                   	leaveq 
  802fa6:	c3                   	retq   

0000000000802fa7 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802fa7:	55                   	push   %rbp
  802fa8:	48 89 e5             	mov    %rsp,%rbp
  802fab:	48 83 ec 20          	sub    $0x20,%rsp
  802faf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb7:	8b 40 0c             	mov    0xc(%rax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	7e 67                	jle    803025 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc2:	8b 40 04             	mov    0x4(%rax),%eax
  802fc5:	48 63 d0             	movslq %eax,%rdx
  802fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcc:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd4:	8b 00                	mov    (%rax),%eax
  802fd6:	48 89 ce             	mov    %rcx,%rsi
  802fd9:	89 c7                	mov    %eax,%edi
  802fdb:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fee:	7e 13                	jle    803003 <writebuf+0x5c>
			b->result += result;
  802ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff4:	8b 50 08             	mov    0x8(%rax),%edx
  802ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffa:	01 c2                	add    %eax,%edx
  802ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803000:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803007:	8b 40 04             	mov    0x4(%rax),%eax
  80300a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80300d:	74 16                	je     803025 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80300f:	b8 00 00 00 00       	mov    $0x0,%eax
  803014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803018:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80301c:	89 c2                	mov    %eax,%edx
  80301e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803022:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803025:	90                   	nop
  803026:	c9                   	leaveq 
  803027:	c3                   	retq   

0000000000803028 <putch>:

static void
putch(int ch, void *thunk)
{
  803028:	55                   	push   %rbp
  803029:	48 89 e5             	mov    %rsp,%rbp
  80302c:	48 83 ec 20          	sub    $0x20,%rsp
  803030:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803033:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803037:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80303f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803043:	8b 40 04             	mov    0x4(%rax),%eax
  803046:	8d 48 01             	lea    0x1(%rax),%ecx
  803049:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80304d:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803050:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803053:	89 d1                	mov    %edx,%ecx
  803055:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803059:	48 98                	cltq   
  80305b:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80305f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803063:	8b 40 04             	mov    0x4(%rax),%eax
  803066:	3d 00 01 00 00       	cmp    $0x100,%eax
  80306b:	75 1e                	jne    80308b <putch+0x63>
		writebuf(b);
  80306d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803071:	48 89 c7             	mov    %rax,%rdi
  803074:	48 b8 a7 2f 80 00 00 	movabs $0x802fa7,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
		b->idx = 0;
  803080:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80308b:	90                   	nop
  80308c:	c9                   	leaveq 
  80308d:	c3                   	retq   

000000000080308e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80308e:	55                   	push   %rbp
  80308f:	48 89 e5             	mov    %rsp,%rbp
  803092:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803099:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80309f:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8030a6:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8030ad:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8030b3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8030b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8030c0:	00 00 00 
	b.result = 0;
  8030c3:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8030ca:	00 00 00 
	b.error = 1;
  8030cd:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8030d4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8030d7:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8030de:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8030e5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030ec:	48 89 c6             	mov    %rax,%rsi
  8030ef:	48 bf 28 30 80 00 00 	movabs $0x803028,%rdi
  8030f6:	00 00 00 
  8030f9:	48 b8 54 09 80 00 00 	movabs $0x800954,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803105:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	7e 16                	jle    803125 <vfprintf+0x97>
		writebuf(&b);
  80310f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803116:	48 89 c7             	mov    %rax,%rdi
  803119:	48 b8 a7 2f 80 00 00 	movabs $0x802fa7,%rax
  803120:	00 00 00 
  803123:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803125:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	74 08                	je     803137 <vfprintf+0xa9>
  80312f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803135:	eb 06                	jmp    80313d <vfprintf+0xaf>
  803137:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80313d:	c9                   	leaveq 
  80313e:	c3                   	retq   

000000000080313f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80313f:	55                   	push   %rbp
  803140:	48 89 e5             	mov    %rsp,%rbp
  803143:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80314a:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803150:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803157:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80315e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803165:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80316c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803173:	84 c0                	test   %al,%al
  803175:	74 20                	je     803197 <fprintf+0x58>
  803177:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80317b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80317f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803183:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803187:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80318b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80318f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803193:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803197:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80319e:	00 00 00 
  8031a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8031a8:	00 00 00 
  8031ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8031b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8031bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8031c4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031cb:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8031d2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8031d8:	48 89 ce             	mov    %rcx,%rsi
  8031db:	89 c7                	mov    %eax,%edi
  8031dd:	48 b8 8e 30 80 00 00 	movabs $0x80308e,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
  8031e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8031ef:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031f5:	c9                   	leaveq 
  8031f6:	c3                   	retq   

00000000008031f7 <printf>:

int
printf(const char *fmt, ...)
{
  8031f7:	55                   	push   %rbp
  8031f8:	48 89 e5             	mov    %rsp,%rbp
  8031fb:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803202:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803209:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803210:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803217:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80321e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803225:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80322c:	84 c0                	test   %al,%al
  80322e:	74 20                	je     803250 <printf+0x59>
  803230:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803234:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803238:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80323c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803240:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803244:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803248:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80324c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803250:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803257:	00 00 00 
  80325a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803261:	00 00 00 
  803264:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803268:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80326f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803276:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  80327d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803284:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80328b:	48 89 c6             	mov    %rax,%rsi
  80328e:	bf 01 00 00 00       	mov    $0x1,%edi
  803293:	48 b8 8e 30 80 00 00 	movabs $0x80308e,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
  80329f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  8032a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8032ab:	c9                   	leaveq 
  8032ac:	c3                   	retq   

00000000008032ad <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8032ad:	55                   	push   %rbp
  8032ae:	48 89 e5             	mov    %rsp,%rbp
  8032b1:	48 83 ec 20          	sub    $0x20,%rsp
  8032b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8032b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032bf:	48 89 d6             	mov    %rdx,%rsi
  8032c2:	89 c7                	mov    %eax,%edi
  8032c4:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
  8032d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d7:	79 05                	jns    8032de <fd2sockid+0x31>
		return r;
  8032d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dc:	eb 24                	jmp    803302 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8032de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e2:	8b 10                	mov    (%rax),%edx
  8032e4:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8032eb:	00 00 00 
  8032ee:	8b 00                	mov    (%rax),%eax
  8032f0:	39 c2                	cmp    %eax,%edx
  8032f2:	74 07                	je     8032fb <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8032f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032f9:	eb 07                	jmp    803302 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8032fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ff:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803302:	c9                   	leaveq 
  803303:	c3                   	retq   

0000000000803304 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803304:	55                   	push   %rbp
  803305:	48 89 e5             	mov    %rsp,%rbp
  803308:	48 83 ec 20          	sub    $0x20,%rsp
  80330c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80330f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803313:	48 89 c7             	mov    %rax,%rdi
  803316:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
  803322:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803325:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803329:	78 26                	js     803351 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80332b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332f:	ba 07 04 00 00       	mov    $0x407,%edx
  803334:	48 89 c6             	mov    %rax,%rsi
  803337:	bf 00 00 00 00       	mov    $0x0,%edi
  80333c:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334f:	79 16                	jns    803367 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803351:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803354:	89 c7                	mov    %eax,%edi
  803356:	48 b8 13 38 80 00 00 	movabs $0x803813,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
		return r;
  803362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803365:	eb 3a                	jmp    8033a1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336b:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803372:	00 00 00 
  803375:	8b 12                	mov    (%rdx),%edx
  803377:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803388:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80338b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80338e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803392:	48 89 c7             	mov    %rax,%rdi
  803395:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 30          	sub    $0x30,%rsp
  8033ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b9:	89 c7                	mov    %eax,%edi
  8033bb:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
  8033c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ce:	79 05                	jns    8033d5 <accept+0x32>
		return r;
  8033d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d3:	eb 3b                	jmp    803410 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8033d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033d9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e0:	48 89 ce             	mov    %rcx,%rsi
  8033e3:	89 c7                	mov    %eax,%edi
  8033e5:	48 b8 f0 36 80 00 00 	movabs $0x8036f0,%rax
  8033ec:	00 00 00 
  8033ef:	ff d0                	callq  *%rax
  8033f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f8:	79 05                	jns    8033ff <accept+0x5c>
		return r;
  8033fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fd:	eb 11                	jmp    803410 <accept+0x6d>
	return alloc_sockfd(r);
  8033ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803402:	89 c7                	mov    %eax,%edi
  803404:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  80340b:	00 00 00 
  80340e:	ff d0                	callq  *%rax
}
  803410:	c9                   	leaveq 
  803411:	c3                   	retq   

0000000000803412 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803412:	55                   	push   %rbp
  803413:	48 89 e5             	mov    %rsp,%rbp
  803416:	48 83 ec 20          	sub    $0x20,%rsp
  80341a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80341d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803421:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803427:	89 c7                	mov    %eax,%edi
  803429:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803438:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343c:	79 05                	jns    803443 <bind+0x31>
		return r;
  80343e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803441:	eb 1b                	jmp    80345e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803443:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803446:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80344a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344d:	48 89 ce             	mov    %rcx,%rsi
  803450:	89 c7                	mov    %eax,%edi
  803452:	48 b8 6f 37 80 00 00 	movabs $0x80376f,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
}
  80345e:	c9                   	leaveq 
  80345f:	c3                   	retq   

0000000000803460 <shutdown>:

int
shutdown(int s, int how)
{
  803460:	55                   	push   %rbp
  803461:	48 89 e5             	mov    %rsp,%rbp
  803464:	48 83 ec 20          	sub    $0x20,%rsp
  803468:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80346b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80346e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803471:	89 c7                	mov    %eax,%edi
  803473:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  80347a:	00 00 00 
  80347d:	ff d0                	callq  *%rax
  80347f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803486:	79 05                	jns    80348d <shutdown+0x2d>
		return r;
  803488:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348b:	eb 16                	jmp    8034a3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80348d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803493:	89 d6                	mov    %edx,%esi
  803495:	89 c7                	mov    %eax,%edi
  803497:	48 b8 d3 37 80 00 00 	movabs $0x8037d3,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
}
  8034a3:	c9                   	leaveq 
  8034a4:	c3                   	retq   

00000000008034a5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8034a5:	55                   	push   %rbp
  8034a6:	48 89 e5             	mov    %rsp,%rbp
  8034a9:	48 83 ec 10          	sub    $0x10,%rsp
  8034ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8034b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b5:	48 89 c7             	mov    %rax,%rdi
  8034b8:	48 b8 ef 44 80 00 00 	movabs $0x8044ef,%rax
  8034bf:	00 00 00 
  8034c2:	ff d0                	callq  *%rax
  8034c4:	83 f8 01             	cmp    $0x1,%eax
  8034c7:	75 17                	jne    8034e0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8034c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034cd:	8b 40 0c             	mov    0xc(%rax),%eax
  8034d0:	89 c7                	mov    %eax,%edi
  8034d2:	48 b8 13 38 80 00 00 	movabs $0x803813,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
  8034de:	eb 05                	jmp    8034e5 <devsock_close+0x40>
	else
		return 0;
  8034e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   

00000000008034e7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 20          	sub    $0x20,%rsp
  8034ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034f6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034fc:	89 c7                	mov    %eax,%edi
  8034fe:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  803505:	00 00 00 
  803508:	ff d0                	callq  *%rax
  80350a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803511:	79 05                	jns    803518 <connect+0x31>
		return r;
  803513:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803516:	eb 1b                	jmp    803533 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803518:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80351b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80351f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803522:	48 89 ce             	mov    %rcx,%rsi
  803525:	89 c7                	mov    %eax,%edi
  803527:	48 b8 40 38 80 00 00 	movabs $0x803840,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
}
  803533:	c9                   	leaveq 
  803534:	c3                   	retq   

0000000000803535 <listen>:

int
listen(int s, int backlog)
{
  803535:	55                   	push   %rbp
  803536:	48 89 e5             	mov    %rsp,%rbp
  803539:	48 83 ec 20          	sub    $0x20,%rsp
  80353d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803540:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803543:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803546:	89 c7                	mov    %eax,%edi
  803548:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  80354f:	00 00 00 
  803552:	ff d0                	callq  *%rax
  803554:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803557:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355b:	79 05                	jns    803562 <listen+0x2d>
		return r;
  80355d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803560:	eb 16                	jmp    803578 <listen+0x43>
	return nsipc_listen(r, backlog);
  803562:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803568:	89 d6                	mov    %edx,%esi
  80356a:	89 c7                	mov    %eax,%edi
  80356c:	48 b8 a4 38 80 00 00 	movabs $0x8038a4,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
}
  803578:	c9                   	leaveq 
  803579:	c3                   	retq   

000000000080357a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80357a:	55                   	push   %rbp
  80357b:	48 89 e5             	mov    %rsp,%rbp
  80357e:	48 83 ec 20          	sub    $0x20,%rsp
  803582:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803586:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80358a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80358e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803592:	89 c2                	mov    %eax,%edx
  803594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803598:	8b 40 0c             	mov    0xc(%rax),%eax
  80359b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80359f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035a4:	89 c7                	mov    %eax,%edi
  8035a6:	48 b8 e4 38 80 00 00 	movabs $0x8038e4,%rax
  8035ad:	00 00 00 
  8035b0:	ff d0                	callq  *%rax
}
  8035b2:	c9                   	leaveq 
  8035b3:	c3                   	retq   

00000000008035b4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8035b4:	55                   	push   %rbp
  8035b5:	48 89 e5             	mov    %rsp,%rbp
  8035b8:	48 83 ec 20          	sub    $0x20,%rsp
  8035bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8035c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035cc:	89 c2                	mov    %eax,%edx
  8035ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d2:	8b 40 0c             	mov    0xc(%rax),%eax
  8035d5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035de:	89 c7                	mov    %eax,%edi
  8035e0:	48 b8 b0 39 80 00 00 	movabs $0x8039b0,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
}
  8035ec:	c9                   	leaveq 
  8035ed:	c3                   	retq   

00000000008035ee <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035ee:	55                   	push   %rbp
  8035ef:	48 89 e5             	mov    %rsp,%rbp
  8035f2:	48 83 ec 10          	sub    $0x10,%rsp
  8035f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8035fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803602:	48 be 27 4c 80 00 00 	movabs $0x804c27,%rsi
  803609:	00 00 00 
  80360c:	48 89 c7             	mov    %rax,%rdi
  80360f:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
	return 0;
  80361b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803620:	c9                   	leaveq 
  803621:	c3                   	retq   

0000000000803622 <socket>:

int
socket(int domain, int type, int protocol)
{
  803622:	55                   	push   %rbp
  803623:	48 89 e5             	mov    %rsp,%rbp
  803626:	48 83 ec 20          	sub    $0x20,%rsp
  80362a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80362d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803630:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803633:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803636:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803639:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80363c:	89 ce                	mov    %ecx,%esi
  80363e:	89 c7                	mov    %eax,%edi
  803640:	48 b8 68 3a 80 00 00 	movabs $0x803a68,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
  80364c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803653:	79 05                	jns    80365a <socket+0x38>
		return r;
  803655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803658:	eb 11                	jmp    80366b <socket+0x49>
	return alloc_sockfd(r);
  80365a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365d:	89 c7                	mov    %eax,%edi
  80365f:	48 b8 04 33 80 00 00 	movabs $0x803304,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
}
  80366b:	c9                   	leaveq 
  80366c:	c3                   	retq   

000000000080366d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80366d:	55                   	push   %rbp
  80366e:	48 89 e5             	mov    %rsp,%rbp
  803671:	48 83 ec 10          	sub    $0x10,%rsp
  803675:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803678:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80367f:	00 00 00 
  803682:	8b 00                	mov    (%rax),%eax
  803684:	85 c0                	test   %eax,%eax
  803686:	75 1f                	jne    8036a7 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803688:	bf 02 00 00 00       	mov    $0x2,%edi
  80368d:	48 b8 7e 44 80 00 00 	movabs $0x80447e,%rax
  803694:	00 00 00 
  803697:	ff d0                	callq  *%rax
  803699:	89 c2                	mov    %eax,%edx
  80369b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036a2:	00 00 00 
  8036a5:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8036a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036ae:	00 00 00 
  8036b1:	8b 00                	mov    (%rax),%eax
  8036b3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8036b6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036bb:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8036c2:	00 00 00 
  8036c5:	89 c7                	mov    %eax,%edi
  8036c7:	48 b8 e9 43 80 00 00 	movabs $0x8043e9,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8036d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8036d8:	be 00 00 00 00       	mov    $0x0,%esi
  8036dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e2:	48 b8 28 43 80 00 00 	movabs $0x804328,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
}
  8036ee:	c9                   	leaveq 
  8036ef:	c3                   	retq   

00000000008036f0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036f0:	55                   	push   %rbp
  8036f1:	48 89 e5             	mov    %rsp,%rbp
  8036f4:	48 83 ec 30          	sub    $0x30,%rsp
  8036f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803703:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370a:	00 00 00 
  80370d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803710:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803712:	bf 01 00 00 00       	mov    $0x1,%edi
  803717:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  80371e:	00 00 00 
  803721:	ff d0                	callq  *%rax
  803723:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803726:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372a:	78 3e                	js     80376a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80372c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803733:	00 00 00 
  803736:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80373a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373e:	8b 40 10             	mov    0x10(%rax),%eax
  803741:	89 c2                	mov    %eax,%edx
  803743:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803747:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80374b:	48 89 ce             	mov    %rcx,%rsi
  80374e:	48 89 c7             	mov    %rax,%rdi
  803751:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80375d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803761:	8b 50 10             	mov    0x10(%rax),%edx
  803764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803768:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80376a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80376d:	c9                   	leaveq 
  80376e:	c3                   	retq   

000000000080376f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80376f:	55                   	push   %rbp
  803770:	48 89 e5             	mov    %rsp,%rbp
  803773:	48 83 ec 10          	sub    $0x10,%rsp
  803777:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80377a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80377e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803781:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803788:	00 00 00 
  80378b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80378e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803790:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803793:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803797:	48 89 c6             	mov    %rax,%rsi
  80379a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037a1:	00 00 00 
  8037a4:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8037b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b7:	00 00 00 
  8037ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037bd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8037c0:	bf 02 00 00 00       	mov    $0x2,%edi
  8037c5:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  8037cc:	00 00 00 
  8037cf:	ff d0                	callq  *%rax
}
  8037d1:	c9                   	leaveq 
  8037d2:	c3                   	retq   

00000000008037d3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8037d3:	55                   	push   %rbp
  8037d4:	48 89 e5             	mov    %rsp,%rbp
  8037d7:	48 83 ec 10          	sub    $0x10,%rsp
  8037db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037de:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8037e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e8:	00 00 00 
  8037eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037ee:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8037f0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037f7:	00 00 00 
  8037fa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037fd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803800:	bf 03 00 00 00       	mov    $0x3,%edi
  803805:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  80380c:	00 00 00 
  80380f:	ff d0                	callq  *%rax
}
  803811:	c9                   	leaveq 
  803812:	c3                   	retq   

0000000000803813 <nsipc_close>:

int
nsipc_close(int s)
{
  803813:	55                   	push   %rbp
  803814:	48 89 e5             	mov    %rsp,%rbp
  803817:	48 83 ec 10          	sub    $0x10,%rsp
  80381b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80381e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803825:	00 00 00 
  803828:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80382b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80382d:	bf 04 00 00 00       	mov    $0x4,%edi
  803832:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
}
  80383e:	c9                   	leaveq 
  80383f:	c3                   	retq   

0000000000803840 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803840:	55                   	push   %rbp
  803841:	48 89 e5             	mov    %rsp,%rbp
  803844:	48 83 ec 10          	sub    $0x10,%rsp
  803848:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80384b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80384f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803852:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803859:	00 00 00 
  80385c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80385f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803861:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803868:	48 89 c6             	mov    %rax,%rsi
  80386b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803872:	00 00 00 
  803875:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803881:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803888:	00 00 00 
  80388b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80388e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803891:	bf 05 00 00 00       	mov    $0x5,%edi
  803896:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
}
  8038a2:	c9                   	leaveq 
  8038a3:	c3                   	retq   

00000000008038a4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8038a4:	55                   	push   %rbp
  8038a5:	48 89 e5             	mov    %rsp,%rbp
  8038a8:	48 83 ec 10          	sub    $0x10,%rsp
  8038ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038af:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8038b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b9:	00 00 00 
  8038bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038bf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8038c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c8:	00 00 00 
  8038cb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038ce:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8038d1:	bf 06 00 00 00       	mov    $0x6,%edi
  8038d6:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  8038dd:	00 00 00 
  8038e0:	ff d0                	callq  *%rax
}
  8038e2:	c9                   	leaveq 
  8038e3:	c3                   	retq   

00000000008038e4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038e4:	55                   	push   %rbp
  8038e5:	48 89 e5             	mov    %rsp,%rbp
  8038e8:	48 83 ec 30          	sub    $0x30,%rsp
  8038ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038f3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8038f6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8038f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803900:	00 00 00 
  803903:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803906:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803908:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80390f:	00 00 00 
  803912:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803915:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803918:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80391f:	00 00 00 
  803922:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803925:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803928:	bf 07 00 00 00       	mov    $0x7,%edi
  80392d:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
  803939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803940:	78 69                	js     8039ab <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803942:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803949:	7f 08                	jg     803953 <nsipc_recv+0x6f>
  80394b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803951:	7e 35                	jle    803988 <nsipc_recv+0xa4>
  803953:	48 b9 2e 4c 80 00 00 	movabs $0x804c2e,%rcx
  80395a:	00 00 00 
  80395d:	48 ba 43 4c 80 00 00 	movabs $0x804c43,%rdx
  803964:	00 00 00 
  803967:	be 62 00 00 00       	mov    $0x62,%esi
  80396c:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  803973:	00 00 00 
  803976:	b8 00 00 00 00       	mov    $0x0,%eax
  80397b:	49 b8 7c 03 80 00 00 	movabs $0x80037c,%r8
  803982:	00 00 00 
  803985:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398b:	48 63 d0             	movslq %eax,%rdx
  80398e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803992:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803999:	00 00 00 
  80399c:	48 89 c7             	mov    %rax,%rdi
  80399f:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
	}

	return r;
  8039ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039ae:	c9                   	leaveq 
  8039af:	c3                   	retq   

00000000008039b0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039b0:	55                   	push   %rbp
  8039b1:	48 89 e5             	mov    %rsp,%rbp
  8039b4:	48 83 ec 20          	sub    $0x20,%rsp
  8039b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039bf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8039c2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8039c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039cc:	00 00 00 
  8039cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039d2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8039d4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8039db:	7e 35                	jle    803a12 <nsipc_send+0x62>
  8039dd:	48 b9 64 4c 80 00 00 	movabs $0x804c64,%rcx
  8039e4:	00 00 00 
  8039e7:	48 ba 43 4c 80 00 00 	movabs $0x804c43,%rdx
  8039ee:	00 00 00 
  8039f1:	be 6d 00 00 00       	mov    $0x6d,%esi
  8039f6:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  8039fd:	00 00 00 
  803a00:	b8 00 00 00 00       	mov    $0x0,%eax
  803a05:	49 b8 7c 03 80 00 00 	movabs $0x80037c,%r8
  803a0c:	00 00 00 
  803a0f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a15:	48 63 d0             	movslq %eax,%rdx
  803a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1c:	48 89 c6             	mov    %rax,%rsi
  803a1f:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a26:	00 00 00 
  803a29:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3c:	00 00 00 
  803a3f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a42:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803a45:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a4c:	00 00 00 
  803a4f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a52:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803a55:	bf 08 00 00 00       	mov    $0x8,%edi
  803a5a:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
}
  803a66:	c9                   	leaveq 
  803a67:	c3                   	retq   

0000000000803a68 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a68:	55                   	push   %rbp
  803a69:	48 89 e5             	mov    %rsp,%rbp
  803a6c:	48 83 ec 10          	sub    $0x10,%rsp
  803a70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a73:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a76:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a79:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a80:	00 00 00 
  803a83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a86:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a88:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a8f:	00 00 00 
  803a92:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a95:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a98:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a9f:	00 00 00 
  803aa2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803aa5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803aa8:	bf 09 00 00 00       	mov    $0x9,%edi
  803aad:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  803ab4:	00 00 00 
  803ab7:	ff d0                	callq  *%rax
}
  803ab9:	c9                   	leaveq 
  803aba:	c3                   	retq   

0000000000803abb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803abb:	55                   	push   %rbp
  803abc:	48 89 e5             	mov    %rsp,%rbp
  803abf:	53                   	push   %rbx
  803ac0:	48 83 ec 38          	sub    $0x38,%rsp
  803ac4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ac8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803acc:	48 89 c7             	mov    %rax,%rdi
  803acf:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
  803adb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ade:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ae2:	0f 88 bf 01 00 00    	js     803ca7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ae8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aec:	ba 07 04 00 00       	mov    $0x407,%edx
  803af1:	48 89 c6             	mov    %rax,%rsi
  803af4:	bf 00 00 00 00       	mov    $0x0,%edi
  803af9:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
  803b05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b0c:	0f 88 95 01 00 00    	js     803ca7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b12:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b16:	48 89 c7             	mov    %rax,%rdi
  803b19:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  803b20:	00 00 00 
  803b23:	ff d0                	callq  *%rax
  803b25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b2c:	0f 88 5d 01 00 00    	js     803c8f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b36:	ba 07 04 00 00       	mov    $0x407,%edx
  803b3b:	48 89 c6             	mov    %rax,%rsi
  803b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b43:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803b4a:	00 00 00 
  803b4d:	ff d0                	callq  *%rax
  803b4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b56:	0f 88 33 01 00 00    	js     803c8f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b60:	48 89 c7             	mov    %rax,%rdi
  803b63:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
  803b6f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b77:	ba 07 04 00 00       	mov    $0x407,%edx
  803b7c:	48 89 c6             	mov    %rax,%rsi
  803b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b84:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803b8b:	00 00 00 
  803b8e:	ff d0                	callq  *%rax
  803b90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b97:	0f 88 d9 00 00 00    	js     803c76 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba1:	48 89 c7             	mov    %rax,%rdi
  803ba4:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  803bab:	00 00 00 
  803bae:	ff d0                	callq  *%rax
  803bb0:	48 89 c2             	mov    %rax,%rdx
  803bb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bb7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803bbd:	48 89 d1             	mov    %rdx,%rcx
  803bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc5:	48 89 c6             	mov    %rax,%rsi
  803bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bcd:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
  803bd9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bdc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803be0:	78 79                	js     803c5b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803be2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bed:	00 00 00 
  803bf0:	8b 12                	mov    (%rdx),%edx
  803bf2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803bf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bf8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803bff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c03:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c0a:	00 00 00 
  803c0d:	8b 12                	mov    (%rdx),%edx
  803c0f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c15:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c20:	48 89 c7             	mov    %rax,%rdi
  803c23:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  803c2a:	00 00 00 
  803c2d:	ff d0                	callq  *%rax
  803c2f:	89 c2                	mov    %eax,%edx
  803c31:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c35:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c37:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c3b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c43:	48 89 c7             	mov    %rax,%rdi
  803c46:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
  803c52:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c54:	b8 00 00 00 00       	mov    $0x0,%eax
  803c59:	eb 4f                	jmp    803caa <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803c5b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803c5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c60:	48 89 c6             	mov    %rax,%rsi
  803c63:	bf 00 00 00 00       	mov    $0x0,%edi
  803c68:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  803c6f:	00 00 00 
  803c72:	ff d0                	callq  *%rax
  803c74:	eb 01                	jmp    803c77 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803c76:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803c77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7b:	48 89 c6             	mov    %rax,%rsi
  803c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c83:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c93:	48 89 c6             	mov    %rax,%rsi
  803c96:	bf 00 00 00 00       	mov    $0x0,%edi
  803c9b:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  803ca2:	00 00 00 
  803ca5:	ff d0                	callq  *%rax
err:
	return r;
  803ca7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803caa:	48 83 c4 38          	add    $0x38,%rsp
  803cae:	5b                   	pop    %rbx
  803caf:	5d                   	pop    %rbp
  803cb0:	c3                   	retq   

0000000000803cb1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803cb1:	55                   	push   %rbp
  803cb2:	48 89 e5             	mov    %rsp,%rbp
  803cb5:	53                   	push   %rbx
  803cb6:	48 83 ec 28          	sub    $0x28,%rsp
  803cba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cbe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803cc2:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803cc9:	00 00 00 
  803ccc:	48 8b 00             	mov    (%rax),%rax
  803ccf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cd5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803cd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cdc:	48 89 c7             	mov    %rax,%rdi
  803cdf:	48 b8 ef 44 80 00 00 	movabs $0x8044ef,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
  803ceb:	89 c3                	mov    %eax,%ebx
  803ced:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf1:	48 89 c7             	mov    %rax,%rdi
  803cf4:	48 b8 ef 44 80 00 00 	movabs $0x8044ef,%rax
  803cfb:	00 00 00 
  803cfe:	ff d0                	callq  *%rax
  803d00:	39 c3                	cmp    %eax,%ebx
  803d02:	0f 94 c0             	sete   %al
  803d05:	0f b6 c0             	movzbl %al,%eax
  803d08:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803d0b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803d12:	00 00 00 
  803d15:	48 8b 00             	mov    (%rax),%rax
  803d18:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d1e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d24:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d27:	75 05                	jne    803d2e <_pipeisclosed+0x7d>
			return ret;
  803d29:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d2c:	eb 4a                	jmp    803d78 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803d2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d31:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d34:	74 8c                	je     803cc2 <_pipeisclosed+0x11>
  803d36:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d3a:	75 86                	jne    803cc2 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d3c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803d43:	00 00 00 
  803d46:	48 8b 00             	mov    (%rax),%rax
  803d49:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d4f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d55:	89 c6                	mov    %eax,%esi
  803d57:	48 bf 75 4c 80 00 00 	movabs $0x804c75,%rdi
  803d5e:	00 00 00 
  803d61:	b8 00 00 00 00       	mov    $0x0,%eax
  803d66:	49 b8 b6 05 80 00 00 	movabs $0x8005b6,%r8
  803d6d:	00 00 00 
  803d70:	41 ff d0             	callq  *%r8
	}
  803d73:	e9 4a ff ff ff       	jmpq   803cc2 <_pipeisclosed+0x11>

}
  803d78:	48 83 c4 28          	add    $0x28,%rsp
  803d7c:	5b                   	pop    %rbx
  803d7d:	5d                   	pop    %rbp
  803d7e:	c3                   	retq   

0000000000803d7f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803d7f:	55                   	push   %rbp
  803d80:	48 89 e5             	mov    %rsp,%rbp
  803d83:	48 83 ec 30          	sub    $0x30,%rsp
  803d87:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d8a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d8e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d91:	48 89 d6             	mov    %rdx,%rsi
  803d94:	89 c7                	mov    %eax,%edi
  803d96:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  803d9d:	00 00 00 
  803da0:	ff d0                	callq  *%rax
  803da2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da9:	79 05                	jns    803db0 <pipeisclosed+0x31>
		return r;
  803dab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dae:	eb 31                	jmp    803de1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db4:	48 89 c7             	mov    %rax,%rdi
  803db7:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
  803dc3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dcf:	48 89 d6             	mov    %rdx,%rsi
  803dd2:	48 89 c7             	mov    %rax,%rdi
  803dd5:	48 b8 b1 3c 80 00 00 	movabs $0x803cb1,%rax
  803ddc:	00 00 00 
  803ddf:	ff d0                	callq  *%rax
}
  803de1:	c9                   	leaveq 
  803de2:	c3                   	retq   

0000000000803de3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803de3:	55                   	push   %rbp
  803de4:	48 89 e5             	mov    %rsp,%rbp
  803de7:	48 83 ec 40          	sub    $0x40,%rsp
  803deb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803def:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803df3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803df7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfb:	48 89 c7             	mov    %rax,%rdi
  803dfe:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  803e05:	00 00 00 
  803e08:	ff d0                	callq  *%rax
  803e0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e16:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e1d:	00 
  803e1e:	e9 90 00 00 00       	jmpq   803eb3 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e23:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e28:	74 09                	je     803e33 <devpipe_read+0x50>
				return i;
  803e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e2e:	e9 8e 00 00 00       	jmpq   803ec1 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3b:	48 89 d6             	mov    %rdx,%rsi
  803e3e:	48 89 c7             	mov    %rax,%rdi
  803e41:	48 b8 b1 3c 80 00 00 	movabs $0x803cb1,%rax
  803e48:	00 00 00 
  803e4b:	ff d0                	callq  *%rax
  803e4d:	85 c0                	test   %eax,%eax
  803e4f:	74 07                	je     803e58 <devpipe_read+0x75>
				return 0;
  803e51:	b8 00 00 00 00       	mov    $0x0,%eax
  803e56:	eb 69                	jmp    803ec1 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e58:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  803e5f:	00 00 00 
  803e62:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e68:	8b 10                	mov    (%rax),%edx
  803e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6e:	8b 40 04             	mov    0x4(%rax),%eax
  803e71:	39 c2                	cmp    %eax,%edx
  803e73:	74 ae                	je     803e23 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e7d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e85:	8b 00                	mov    (%rax),%eax
  803e87:	99                   	cltd   
  803e88:	c1 ea 1b             	shr    $0x1b,%edx
  803e8b:	01 d0                	add    %edx,%eax
  803e8d:	83 e0 1f             	and    $0x1f,%eax
  803e90:	29 d0                	sub    %edx,%eax
  803e92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e96:	48 98                	cltq   
  803e98:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e9d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea3:	8b 00                	mov    (%rax),%eax
  803ea5:	8d 50 01             	lea    0x1(%rax),%edx
  803ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eac:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803eae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803eb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eb7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ebb:	72 a7                	jb     803e64 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803ec1:	c9                   	leaveq 
  803ec2:	c3                   	retq   

0000000000803ec3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ec3:	55                   	push   %rbp
  803ec4:	48 89 e5             	mov    %rsp,%rbp
  803ec7:	48 83 ec 40          	sub    $0x40,%rsp
  803ecb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ecf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ed3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ed7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803edb:	48 89 c7             	mov    %rax,%rdi
  803ede:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  803ee5:	00 00 00 
  803ee8:	ff d0                	callq  *%rax
  803eea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803eee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ef2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ef6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803efd:	00 
  803efe:	e9 8f 00 00 00       	jmpq   803f92 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f0b:	48 89 d6             	mov    %rdx,%rsi
  803f0e:	48 89 c7             	mov    %rax,%rdi
  803f11:	48 b8 b1 3c 80 00 00 	movabs $0x803cb1,%rax
  803f18:	00 00 00 
  803f1b:	ff d0                	callq  *%rax
  803f1d:	85 c0                	test   %eax,%eax
  803f1f:	74 07                	je     803f28 <devpipe_write+0x65>
				return 0;
  803f21:	b8 00 00 00 00       	mov    $0x0,%eax
  803f26:	eb 78                	jmp    803fa0 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f28:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  803f2f:	00 00 00 
  803f32:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f38:	8b 40 04             	mov    0x4(%rax),%eax
  803f3b:	48 63 d0             	movslq %eax,%rdx
  803f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f42:	8b 00                	mov    (%rax),%eax
  803f44:	48 98                	cltq   
  803f46:	48 83 c0 20          	add    $0x20,%rax
  803f4a:	48 39 c2             	cmp    %rax,%rdx
  803f4d:	73 b4                	jae    803f03 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f53:	8b 40 04             	mov    0x4(%rax),%eax
  803f56:	99                   	cltd   
  803f57:	c1 ea 1b             	shr    $0x1b,%edx
  803f5a:	01 d0                	add    %edx,%eax
  803f5c:	83 e0 1f             	and    $0x1f,%eax
  803f5f:	29 d0                	sub    %edx,%eax
  803f61:	89 c6                	mov    %eax,%esi
  803f63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6b:	48 01 d0             	add    %rdx,%rax
  803f6e:	0f b6 08             	movzbl (%rax),%ecx
  803f71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f75:	48 63 c6             	movslq %esi,%rax
  803f78:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f80:	8b 40 04             	mov    0x4(%rax),%eax
  803f83:	8d 50 01             	lea    0x1(%rax),%edx
  803f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f8a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f8d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f96:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f9a:	72 98                	jb     803f34 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803fa0:	c9                   	leaveq 
  803fa1:	c3                   	retq   

0000000000803fa2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803fa2:	55                   	push   %rbp
  803fa3:	48 89 e5             	mov    %rsp,%rbp
  803fa6:	48 83 ec 20          	sub    $0x20,%rsp
  803faa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb6:	48 89 c7             	mov    %rax,%rdi
  803fb9:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  803fc0:	00 00 00 
  803fc3:	ff d0                	callq  *%rax
  803fc5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803fc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fcd:	48 be 88 4c 80 00 00 	movabs $0x804c88,%rsi
  803fd4:	00 00 00 
  803fd7:	48 89 c7             	mov    %rax,%rdi
  803fda:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fea:	8b 50 04             	mov    0x4(%rax),%edx
  803fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff1:	8b 00                	mov    (%rax),%eax
  803ff3:	29 c2                	sub    %eax,%edx
  803ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803fff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804003:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80400a:	00 00 00 
	stat->st_dev = &devpipe;
  80400d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804011:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  804018:	00 00 00 
  80401b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804022:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804027:	c9                   	leaveq 
  804028:	c3                   	retq   

0000000000804029 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804029:	55                   	push   %rbp
  80402a:	48 89 e5             	mov    %rsp,%rbp
  80402d:	48 83 ec 10          	sub    $0x10,%rsp
  804031:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804039:	48 89 c6             	mov    %rax,%rsi
  80403c:	bf 00 00 00 00       	mov    $0x0,%edi
  804041:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  804048:	00 00 00 
  80404b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80404d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804051:	48 89 c7             	mov    %rax,%rdi
  804054:	48 b8 97 1f 80 00 00 	movabs $0x801f97,%rax
  80405b:	00 00 00 
  80405e:	ff d0                	callq  *%rax
  804060:	48 89 c6             	mov    %rax,%rsi
  804063:	bf 00 00 00 00       	mov    $0x0,%edi
  804068:	48 b8 2e 1b 80 00 00 	movabs $0x801b2e,%rax
  80406f:	00 00 00 
  804072:	ff d0                	callq  *%rax
}
  804074:	c9                   	leaveq 
  804075:	c3                   	retq   

0000000000804076 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804076:	55                   	push   %rbp
  804077:	48 89 e5             	mov    %rsp,%rbp
  80407a:	48 83 ec 20          	sub    $0x20,%rsp
  80407e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804081:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804084:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804087:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80408b:	be 01 00 00 00       	mov    $0x1,%esi
  804090:	48 89 c7             	mov    %rax,%rdi
  804093:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  80409a:	00 00 00 
  80409d:	ff d0                	callq  *%rax
}
  80409f:	90                   	nop
  8040a0:	c9                   	leaveq 
  8040a1:	c3                   	retq   

00000000008040a2 <getchar>:

int
getchar(void)
{
  8040a2:	55                   	push   %rbp
  8040a3:	48 89 e5             	mov    %rsp,%rbp
  8040a6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040aa:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8040ae:	ba 01 00 00 00       	mov    $0x1,%edx
  8040b3:	48 89 c6             	mov    %rax,%rsi
  8040b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8040bb:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
  8040c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8040ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ce:	79 05                	jns    8040d5 <getchar+0x33>
		return r;
  8040d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d3:	eb 14                	jmp    8040e9 <getchar+0x47>
	if (r < 1)
  8040d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d9:	7f 07                	jg     8040e2 <getchar+0x40>
		return -E_EOF;
  8040db:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8040e0:	eb 07                	jmp    8040e9 <getchar+0x47>
	return c;
  8040e2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8040e6:	0f b6 c0             	movzbl %al,%eax

}
  8040e9:	c9                   	leaveq 
  8040ea:	c3                   	retq   

00000000008040eb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8040eb:	55                   	push   %rbp
  8040ec:	48 89 e5             	mov    %rsp,%rbp
  8040ef:	48 83 ec 20          	sub    $0x20,%rsp
  8040f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040fd:	48 89 d6             	mov    %rdx,%rsi
  804100:	89 c7                	mov    %eax,%edi
  804102:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  804109:	00 00 00 
  80410c:	ff d0                	callq  *%rax
  80410e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804111:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804115:	79 05                	jns    80411c <iscons+0x31>
		return r;
  804117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80411a:	eb 1a                	jmp    804136 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80411c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804120:	8b 10                	mov    (%rax),%edx
  804122:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804129:	00 00 00 
  80412c:	8b 00                	mov    (%rax),%eax
  80412e:	39 c2                	cmp    %eax,%edx
  804130:	0f 94 c0             	sete   %al
  804133:	0f b6 c0             	movzbl %al,%eax
}
  804136:	c9                   	leaveq 
  804137:	c3                   	retq   

0000000000804138 <opencons>:

int
opencons(void)
{
  804138:	55                   	push   %rbp
  804139:	48 89 e5             	mov    %rsp,%rbp
  80413c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804140:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804144:	48 89 c7             	mov    %rax,%rdi
  804147:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  80414e:	00 00 00 
  804151:	ff d0                	callq  *%rax
  804153:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80415a:	79 05                	jns    804161 <opencons+0x29>
		return r;
  80415c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415f:	eb 5b                	jmp    8041bc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804165:	ba 07 04 00 00       	mov    $0x407,%edx
  80416a:	48 89 c6             	mov    %rax,%rsi
  80416d:	bf 00 00 00 00       	mov    $0x0,%edi
  804172:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  804179:	00 00 00 
  80417c:	ff d0                	callq  *%rax
  80417e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804181:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804185:	79 05                	jns    80418c <opencons+0x54>
		return r;
  804187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418a:	eb 30                	jmp    8041bc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80418c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804190:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804197:	00 00 00 
  80419a:	8b 12                	mov    (%rdx),%edx
  80419c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80419e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ad:	48 89 c7             	mov    %rax,%rdi
  8041b0:	48 b8 74 1f 80 00 00 	movabs $0x801f74,%rax
  8041b7:	00 00 00 
  8041ba:	ff d0                	callq  *%rax
}
  8041bc:	c9                   	leaveq 
  8041bd:	c3                   	retq   

00000000008041be <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041be:	55                   	push   %rbp
  8041bf:	48 89 e5             	mov    %rsp,%rbp
  8041c2:	48 83 ec 30          	sub    $0x30,%rsp
  8041c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8041d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041d7:	75 13                	jne    8041ec <devcons_read+0x2e>
		return 0;
  8041d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8041de:	eb 49                	jmp    804229 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8041e0:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  8041e7:	00 00 00 
  8041ea:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8041ec:	48 b8 81 19 80 00 00 	movabs $0x801981,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
  8041f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ff:	74 df                	je     8041e0 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804201:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804205:	79 05                	jns    80420c <devcons_read+0x4e>
		return c;
  804207:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80420a:	eb 1d                	jmp    804229 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80420c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804210:	75 07                	jne    804219 <devcons_read+0x5b>
		return 0;
  804212:	b8 00 00 00 00       	mov    $0x0,%eax
  804217:	eb 10                	jmp    804229 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421c:	89 c2                	mov    %eax,%edx
  80421e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804222:	88 10                	mov    %dl,(%rax)
	return 1;
  804224:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804229:	c9                   	leaveq 
  80422a:	c3                   	retq   

000000000080422b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80422b:	55                   	push   %rbp
  80422c:	48 89 e5             	mov    %rsp,%rbp
  80422f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804236:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80423d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804244:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80424b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804252:	eb 76                	jmp    8042ca <devcons_write+0x9f>
		m = n - tot;
  804254:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80425b:	89 c2                	mov    %eax,%edx
  80425d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804260:	29 c2                	sub    %eax,%edx
  804262:	89 d0                	mov    %edx,%eax
  804264:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804267:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80426a:	83 f8 7f             	cmp    $0x7f,%eax
  80426d:	76 07                	jbe    804276 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80426f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804276:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804279:	48 63 d0             	movslq %eax,%rdx
  80427c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427f:	48 63 c8             	movslq %eax,%rcx
  804282:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804289:	48 01 c1             	add    %rax,%rcx
  80428c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804293:	48 89 ce             	mov    %rcx,%rsi
  804296:	48 89 c7             	mov    %rax,%rdi
  804299:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  8042a0:	00 00 00 
  8042a3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042a8:	48 63 d0             	movslq %eax,%rdx
  8042ab:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042b2:	48 89 d6             	mov    %rdx,%rsi
  8042b5:	48 89 c7             	mov    %rax,%rdi
  8042b8:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  8042bf:	00 00 00 
  8042c2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042c7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8042ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cd:	48 98                	cltq   
  8042cf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8042d6:	0f 82 78 ff ff ff    	jb     804254 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8042dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042df:	c9                   	leaveq 
  8042e0:	c3                   	retq   

00000000008042e1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8042e1:	55                   	push   %rbp
  8042e2:	48 89 e5             	mov    %rsp,%rbp
  8042e5:	48 83 ec 08          	sub    $0x8,%rsp
  8042e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8042ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042f2:	c9                   	leaveq 
  8042f3:	c3                   	retq   

00000000008042f4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8042f4:	55                   	push   %rbp
  8042f5:	48 89 e5             	mov    %rsp,%rbp
  8042f8:	48 83 ec 10          	sub    $0x10,%rsp
  8042fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804300:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804308:	48 be 94 4c 80 00 00 	movabs $0x804c94,%rsi
  80430f:	00 00 00 
  804312:	48 89 c7             	mov    %rax,%rdi
  804315:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  80431c:	00 00 00 
  80431f:	ff d0                	callq  *%rax
	return 0;
  804321:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804326:	c9                   	leaveq 
  804327:	c3                   	retq   

0000000000804328 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804328:	55                   	push   %rbp
  804329:	48 89 e5             	mov    %rsp,%rbp
  80432c:	48 83 ec 30          	sub    $0x30,%rsp
  804330:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804334:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804338:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80433c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804341:	75 0e                	jne    804351 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804343:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80434a:	00 00 00 
  80434d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804351:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804355:	48 89 c7             	mov    %rax,%rdi
  804358:	48 b8 b6 1c 80 00 00 	movabs $0x801cb6,%rax
  80435f:	00 00 00 
  804362:	ff d0                	callq  *%rax
  804364:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80436b:	79 27                	jns    804394 <ipc_recv+0x6c>
		if (from_env_store)
  80436d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804372:	74 0a                	je     80437e <ipc_recv+0x56>
			*from_env_store = 0;
  804374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804378:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80437e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804383:	74 0a                	je     80438f <ipc_recv+0x67>
			*perm_store = 0;
  804385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804389:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80438f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804392:	eb 53                	jmp    8043e7 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804394:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804399:	74 19                	je     8043b4 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80439b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8043a2:	00 00 00 
  8043a5:	48 8b 00             	mov    (%rax),%rax
  8043a8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8043ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043b2:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8043b4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043b9:	74 19                	je     8043d4 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8043bb:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8043c2:	00 00 00 
  8043c5:	48 8b 00             	mov    (%rax),%rax
  8043c8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8043ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d2:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8043d4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8043db:	00 00 00 
  8043de:	48 8b 00             	mov    (%rax),%rax
  8043e1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8043e7:	c9                   	leaveq 
  8043e8:	c3                   	retq   

00000000008043e9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8043e9:	55                   	push   %rbp
  8043ea:	48 89 e5             	mov    %rsp,%rbp
  8043ed:	48 83 ec 30          	sub    $0x30,%rsp
  8043f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8043f7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8043fb:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8043fe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804403:	75 1c                	jne    804421 <ipc_send+0x38>
		pg = (void*) UTOP;
  804405:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80440c:	00 00 00 
  80440f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804413:	eb 0c                	jmp    804421 <ipc_send+0x38>
		sys_yield();
  804415:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  80441c:	00 00 00 
  80441f:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804421:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804424:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804427:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80442b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80442e:	89 c7                	mov    %eax,%edi
  804430:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  804437:	00 00 00 
  80443a:	ff d0                	callq  *%rax
  80443c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80443f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804443:	74 d0                	je     804415 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804445:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804449:	79 30                	jns    80447b <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80444b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80444e:	89 c1                	mov    %eax,%ecx
  804450:	48 ba 9b 4c 80 00 00 	movabs $0x804c9b,%rdx
  804457:	00 00 00 
  80445a:	be 47 00 00 00       	mov    $0x47,%esi
  80445f:	48 bf b1 4c 80 00 00 	movabs $0x804cb1,%rdi
  804466:	00 00 00 
  804469:	b8 00 00 00 00       	mov    $0x0,%eax
  80446e:	49 b8 7c 03 80 00 00 	movabs $0x80037c,%r8
  804475:	00 00 00 
  804478:	41 ff d0             	callq  *%r8

}
  80447b:	90                   	nop
  80447c:	c9                   	leaveq 
  80447d:	c3                   	retq   

000000000080447e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80447e:	55                   	push   %rbp
  80447f:	48 89 e5             	mov    %rsp,%rbp
  804482:	48 83 ec 18          	sub    $0x18,%rsp
  804486:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804489:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804490:	eb 4d                	jmp    8044df <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804492:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804499:	00 00 00 
  80449c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449f:	48 98                	cltq   
  8044a1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8044a8:	48 01 d0             	add    %rdx,%rax
  8044ab:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8044b1:	8b 00                	mov    (%rax),%eax
  8044b3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8044b6:	75 23                	jne    8044db <ipc_find_env+0x5d>
			return envs[i].env_id;
  8044b8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8044bf:	00 00 00 
  8044c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c5:	48 98                	cltq   
  8044c7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8044ce:	48 01 d0             	add    %rdx,%rax
  8044d1:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8044d7:	8b 00                	mov    (%rax),%eax
  8044d9:	eb 12                	jmp    8044ed <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8044db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8044df:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8044e6:	7e aa                	jle    804492 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8044e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044ed:	c9                   	leaveq 
  8044ee:	c3                   	retq   

00000000008044ef <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8044ef:	55                   	push   %rbp
  8044f0:	48 89 e5             	mov    %rsp,%rbp
  8044f3:	48 83 ec 18          	sub    $0x18,%rsp
  8044f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8044fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ff:	48 c1 e8 15          	shr    $0x15,%rax
  804503:	48 89 c2             	mov    %rax,%rdx
  804506:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80450d:	01 00 00 
  804510:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804514:	83 e0 01             	and    $0x1,%eax
  804517:	48 85 c0             	test   %rax,%rax
  80451a:	75 07                	jne    804523 <pageref+0x34>
		return 0;
  80451c:	b8 00 00 00 00       	mov    $0x0,%eax
  804521:	eb 56                	jmp    804579 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804527:	48 c1 e8 0c          	shr    $0xc,%rax
  80452b:	48 89 c2             	mov    %rax,%rdx
  80452e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804535:	01 00 00 
  804538:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80453c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804544:	83 e0 01             	and    $0x1,%eax
  804547:	48 85 c0             	test   %rax,%rax
  80454a:	75 07                	jne    804553 <pageref+0x64>
		return 0;
  80454c:	b8 00 00 00 00       	mov    $0x0,%eax
  804551:	eb 26                	jmp    804579 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804557:	48 c1 e8 0c          	shr    $0xc,%rax
  80455b:	48 89 c2             	mov    %rax,%rdx
  80455e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804565:	00 00 00 
  804568:	48 c1 e2 04          	shl    $0x4,%rdx
  80456c:	48 01 d0             	add    %rdx,%rax
  80456f:	48 83 c0 08          	add    $0x8,%rax
  804573:	0f b7 00             	movzwl (%rax),%eax
  804576:	0f b7 c0             	movzwl %ax,%eax
}
  804579:	c9                   	leaveq 
  80457a:	c3                   	retq   
