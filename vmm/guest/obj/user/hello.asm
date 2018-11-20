
vmm/guest/obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5f 00 00 00       	callq  8000a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf ce 40 80 00 00 	movabs $0x8040ce,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	90                   	nop
  80009e:	c9                   	leaveq 
  80009f:	c3                   	retq   

00000000008000a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %rbp
  8000a1:	48 89 e5             	mov    %rsp,%rbp
  8000a4:	48 83 ec 10          	sub    $0x10,%rsp
  8000a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8000af:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c0:	48 98                	cltq   
  8000c2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8000c9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000d0:	00 00 00 
  8000d3:	48 01 c2             	add    %rax,%rdx
  8000d6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000dd:	00 00 00 
  8000e0:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e7:	7e 14                	jle    8000fd <libmain+0x5d>
		binaryname = argv[0];
  8000e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ed:	48 8b 10             	mov    (%rax),%rdx
  8000f0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000f7:	00 00 00 
  8000fa:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800104:	48 89 d6             	mov    %rdx,%rsi
  800107:	89 c7                	mov    %eax,%edi
  800109:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800110:	00 00 00 
  800113:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800115:	48 b8 24 01 80 00 00 	movabs $0x800124,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
}
  800121:	90                   	nop
  800122:	c9                   	leaveq 
  800123:	c3                   	retq   

0000000000800124 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800124:	55                   	push   %rbp
  800125:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800128:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  80012f:	00 00 00 
  800132:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800134:	bf 00 00 00 00       	mov    $0x0,%edi
  800139:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  800140:	00 00 00 
  800143:	ff d0                	callq  *%rax
}
  800145:	90                   	nop
  800146:	5d                   	pop    %rbp
  800147:	c3                   	retq   

0000000000800148 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 10          	sub    $0x10,%rsp
  800150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015b:	8b 00                	mov    (%rax),%eax
  80015d:	8d 48 01             	lea    0x1(%rax),%ecx
  800160:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800164:	89 0a                	mov    %ecx,(%rdx)
  800166:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800169:	89 d1                	mov    %edx,%ecx
  80016b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016f:	48 98                	cltq   
  800171:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800175:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800179:	8b 00                	mov    (%rax),%eax
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	75 2c                	jne    8001ae <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800186:	8b 00                	mov    (%rax),%eax
  800188:	48 98                	cltq   
  80018a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018e:	48 83 c2 08          	add    $0x8,%rdx
  800192:	48 89 c6             	mov    %rax,%rsi
  800195:	48 89 d7             	mov    %rdx,%rdi
  800198:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  80019f:	00 00 00 
  8001a2:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b2:	8b 40 04             	mov    0x4(%rax),%eax
  8001b5:	8d 50 01             	lea    0x1(%rax),%edx
  8001b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bc:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001bf:	90                   	nop
  8001c0:	c9                   	leaveq 
  8001c1:	c3                   	retq   

00000000008001c2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001c2:	55                   	push   %rbp
  8001c3:	48 89 e5             	mov    %rsp,%rbp
  8001c6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001cd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001db:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001e2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e9:	48 8b 0a             	mov    (%rdx),%rcx
  8001ec:	48 89 08             	mov    %rcx,(%rax)
  8001ef:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001f3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001f7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001fb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800206:	00 00 00 
    b.cnt = 0;
  800209:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800210:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800213:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80021a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800221:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800228:	48 89 c6             	mov    %rax,%rsi
  80022b:	48 bf 48 01 80 00 00 	movabs $0x800148,%rdi
  800232:	00 00 00 
  800235:	48 b8 0c 06 80 00 00 	movabs $0x80060c,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800241:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800247:	48 98                	cltq   
  800249:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800250:	48 83 c2 08          	add    $0x8,%rdx
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 89 d7             	mov    %rdx,%rdi
  80025a:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800266:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80026c:	c9                   	leaveq 
  80026d:	c3                   	retq   

000000000080026e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80026e:	55                   	push   %rbp
  80026f:	48 89 e5             	mov    %rsp,%rbp
  800272:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800279:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800280:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800287:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80028e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800295:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80029c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a3:	84 c0                	test   %al,%al
  8002a5:	74 20                	je     8002c7 <cprintf+0x59>
  8002a7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002ab:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002af:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002bb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002bf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002c7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002ce:	00 00 00 
  8002d1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002d8:	00 00 00 
  8002db:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002df:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002e6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002ed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002fb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800302:	48 8b 0a             	mov    (%rdx),%rcx
  800305:	48 89 08             	mov    %rcx,(%rax)
  800308:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80030c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800310:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800314:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800318:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80031f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800326:	48 89 d6             	mov    %rdx,%rsi
  800329:	48 89 c7             	mov    %rax,%rdi
  80032c:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
  800338:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80033e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800344:	c9                   	leaveq 
  800345:	c3                   	retq   

0000000000800346 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800346:	55                   	push   %rbp
  800347:	48 89 e5             	mov    %rsp,%rbp
  80034a:	48 83 ec 30          	sub    $0x30,%rsp
  80034e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800356:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80035a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80035d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800361:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800365:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800368:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80036c:	77 54                	ja     8003c2 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800371:	8d 78 ff             	lea    -0x1(%rax),%edi
  800374:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
  800380:	48 f7 f6             	div    %rsi
  800383:	49 89 c2             	mov    %rax,%r10
  800386:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800389:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80038c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800394:	41 89 c9             	mov    %ecx,%r9d
  800397:	41 89 f8             	mov    %edi,%r8d
  80039a:	89 d1                	mov    %edx,%ecx
  80039c:	4c 89 d2             	mov    %r10,%rdx
  80039f:	48 89 c7             	mov    %rax,%rdi
  8003a2:	48 b8 46 03 80 00 00 	movabs $0x800346,%rax
  8003a9:	00 00 00 
  8003ac:	ff d0                	callq  *%rax
  8003ae:	eb 1c                	jmp    8003cc <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8003b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003bb:	48 89 ce             	mov    %rcx,%rsi
  8003be:	89 d7                	mov    %edx,%edi
  8003c0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003ca:	7f e4                	jg     8003b0 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	48 f7 f1             	div    %rcx
  8003db:	48 b8 f0 42 80 00 00 	movabs $0x8042f0,%rax
  8003e2:	00 00 00 
  8003e5:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8003e9:	0f be d0             	movsbl %al,%edx
  8003ec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f4:	48 89 ce             	mov    %rcx,%rsi
  8003f7:	89 d7                	mov    %edx,%edi
  8003f9:	ff d0                	callq  *%rax
}
  8003fb:	90                   	nop
  8003fc:	c9                   	leaveq 
  8003fd:	c3                   	retq   

00000000008003fe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fe:	55                   	push   %rbp
  8003ff:	48 89 e5             	mov    %rsp,%rbp
  800402:	48 83 ec 20          	sub    $0x20,%rsp
  800406:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80040a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80040d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800411:	7e 4f                	jle    800462 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800417:	8b 00                	mov    (%rax),%eax
  800419:	83 f8 30             	cmp    $0x30,%eax
  80041c:	73 24                	jae    800442 <getuint+0x44>
  80041e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800422:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042a:	8b 00                	mov    (%rax),%eax
  80042c:	89 c0                	mov    %eax,%eax
  80042e:	48 01 d0             	add    %rdx,%rax
  800431:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800435:	8b 12                	mov    (%rdx),%edx
  800437:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80043a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043e:	89 0a                	mov    %ecx,(%rdx)
  800440:	eb 14                	jmp    800456 <getuint+0x58>
  800442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800446:	48 8b 40 08          	mov    0x8(%rax),%rax
  80044a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80044e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800452:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800456:	48 8b 00             	mov    (%rax),%rax
  800459:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80045d:	e9 9d 00 00 00       	jmpq   8004ff <getuint+0x101>
	else if (lflag)
  800462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800466:	74 4c                	je     8004b4 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046c:	8b 00                	mov    (%rax),%eax
  80046e:	83 f8 30             	cmp    $0x30,%eax
  800471:	73 24                	jae    800497 <getuint+0x99>
  800473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800477:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80047b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	89 c0                	mov    %eax,%eax
  800483:	48 01 d0             	add    %rdx,%rax
  800486:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048a:	8b 12                	mov    (%rdx),%edx
  80048c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80048f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800493:	89 0a                	mov    %ecx,(%rdx)
  800495:	eb 14                	jmp    8004ab <getuint+0xad>
  800497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80049f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ab:	48 8b 00             	mov    (%rax),%rax
  8004ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004b2:	eb 4b                	jmp    8004ff <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8004b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b8:	8b 00                	mov    (%rax),%eax
  8004ba:	83 f8 30             	cmp    $0x30,%eax
  8004bd:	73 24                	jae    8004e3 <getuint+0xe5>
  8004bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	89 c0                	mov    %eax,%eax
  8004cf:	48 01 d0             	add    %rdx,%rax
  8004d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d6:	8b 12                	mov    (%rdx),%edx
  8004d8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004df:	89 0a                	mov    %ecx,(%rdx)
  8004e1:	eb 14                	jmp    8004f7 <getuint+0xf9>
  8004e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004eb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f7:	8b 00                	mov    (%rax),%eax
  8004f9:	89 c0                	mov    %eax,%eax
  8004fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   

0000000000800505 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800505:	55                   	push   %rbp
  800506:	48 89 e5             	mov    %rsp,%rbp
  800509:	48 83 ec 20          	sub    $0x20,%rsp
  80050d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800511:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800514:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800518:	7e 4f                	jle    800569 <getint+0x64>
		x=va_arg(*ap, long long);
  80051a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051e:	8b 00                	mov    (%rax),%eax
  800520:	83 f8 30             	cmp    $0x30,%eax
  800523:	73 24                	jae    800549 <getint+0x44>
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	89 c0                	mov    %eax,%eax
  800535:	48 01 d0             	add    %rdx,%rax
  800538:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053c:	8b 12                	mov    (%rdx),%edx
  80053e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800541:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800545:	89 0a                	mov    %ecx,(%rdx)
  800547:	eb 14                	jmp    80055d <getint+0x58>
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800551:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800559:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80055d:	48 8b 00             	mov    (%rax),%rax
  800560:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800564:	e9 9d 00 00 00       	jmpq   800606 <getint+0x101>
	else if (lflag)
  800569:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80056d:	74 4c                	je     8005bb <getint+0xb6>
		x=va_arg(*ap, long);
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	83 f8 30             	cmp    $0x30,%eax
  800578:	73 24                	jae    80059e <getint+0x99>
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	89 c0                	mov    %eax,%eax
  80058a:	48 01 d0             	add    %rdx,%rax
  80058d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800591:	8b 12                	mov    (%rdx),%edx
  800593:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059a:	89 0a                	mov    %ecx,(%rdx)
  80059c:	eb 14                	jmp    8005b2 <getint+0xad>
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005a6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b2:	48 8b 00             	mov    (%rax),%rax
  8005b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b9:	eb 4b                	jmp    800606 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	8b 00                	mov    (%rax),%eax
  8005c1:	83 f8 30             	cmp    $0x30,%eax
  8005c4:	73 24                	jae    8005ea <getint+0xe5>
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d2:	8b 00                	mov    (%rax),%eax
  8005d4:	89 c0                	mov    %eax,%eax
  8005d6:	48 01 d0             	add    %rdx,%rax
  8005d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dd:	8b 12                	mov    (%rdx),%edx
  8005df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e6:	89 0a                	mov    %ecx,(%rdx)
  8005e8:	eb 14                	jmp    8005fe <getint+0xf9>
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005fe:	8b 00                	mov    (%rax),%eax
  800600:	48 98                	cltq   
  800602:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800606:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80060a:	c9                   	leaveq 
  80060b:	c3                   	retq   

000000000080060c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80060c:	55                   	push   %rbp
  80060d:	48 89 e5             	mov    %rsp,%rbp
  800610:	41 54                	push   %r12
  800612:	53                   	push   %rbx
  800613:	48 83 ec 60          	sub    $0x60,%rsp
  800617:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80061b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80061f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800623:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800627:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80062b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80062f:	48 8b 0a             	mov    (%rdx),%rcx
  800632:	48 89 08             	mov    %rcx,(%rax)
  800635:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800639:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80063d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800641:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800645:	eb 17                	jmp    80065e <vprintfmt+0x52>
			if (ch == '\0')
  800647:	85 db                	test   %ebx,%ebx
  800649:	0f 84 b9 04 00 00    	je     800b08 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80064f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800653:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800657:	48 89 d6             	mov    %rdx,%rsi
  80065a:	89 df                	mov    %ebx,%edi
  80065c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800662:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800666:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80066a:	0f b6 00             	movzbl (%rax),%eax
  80066d:	0f b6 d8             	movzbl %al,%ebx
  800670:	83 fb 25             	cmp    $0x25,%ebx
  800673:	75 d2                	jne    800647 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800675:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800679:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800680:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800687:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80068e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800695:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800699:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80069d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a1:	0f b6 00             	movzbl (%rax),%eax
  8006a4:	0f b6 d8             	movzbl %al,%ebx
  8006a7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006aa:	83 f8 55             	cmp    $0x55,%eax
  8006ad:	0f 87 22 04 00 00    	ja     800ad5 <vprintfmt+0x4c9>
  8006b3:	89 c0                	mov    %eax,%eax
  8006b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006bc:	00 
  8006bd:	48 b8 18 43 80 00 00 	movabs $0x804318,%rax
  8006c4:	00 00 00 
  8006c7:	48 01 d0             	add    %rdx,%rax
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006cf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006d3:	eb c0                	jmp    800695 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006d9:	eb ba                	jmp    800695 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006e2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006e5:	89 d0                	mov    %edx,%eax
  8006e7:	c1 e0 02             	shl    $0x2,%eax
  8006ea:	01 d0                	add    %edx,%eax
  8006ec:	01 c0                	add    %eax,%eax
  8006ee:	01 d8                	add    %ebx,%eax
  8006f0:	83 e8 30             	sub    $0x30,%eax
  8006f3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fa:	0f b6 00             	movzbl (%rax),%eax
  8006fd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800700:	83 fb 2f             	cmp    $0x2f,%ebx
  800703:	7e 60                	jle    800765 <vprintfmt+0x159>
  800705:	83 fb 39             	cmp    $0x39,%ebx
  800708:	7f 5b                	jg     800765 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80070a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80070f:	eb d1                	jmp    8006e2 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800711:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800714:	83 f8 30             	cmp    $0x30,%eax
  800717:	73 17                	jae    800730 <vprintfmt+0x124>
  800719:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80071d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800720:	89 d2                	mov    %edx,%edx
  800722:	48 01 d0             	add    %rdx,%rax
  800725:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800728:	83 c2 08             	add    $0x8,%edx
  80072b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80072e:	eb 0c                	jmp    80073c <vprintfmt+0x130>
  800730:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800734:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800738:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800741:	eb 23                	jmp    800766 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800743:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800747:	0f 89 48 ff ff ff    	jns    800695 <vprintfmt+0x89>
				width = 0;
  80074d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800754:	e9 3c ff ff ff       	jmpq   800695 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800759:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800760:	e9 30 ff ff ff       	jmpq   800695 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800765:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800766:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80076a:	0f 89 25 ff ff ff    	jns    800695 <vprintfmt+0x89>
				width = precision, precision = -1;
  800770:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800773:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800776:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80077d:	e9 13 ff ff ff       	jmpq   800695 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800782:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800786:	e9 0a ff ff ff       	jmpq   800695 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80078b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078e:	83 f8 30             	cmp    $0x30,%eax
  800791:	73 17                	jae    8007aa <vprintfmt+0x19e>
  800793:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800797:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80079a:	89 d2                	mov    %edx,%edx
  80079c:	48 01 d0             	add    %rdx,%rax
  80079f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a2:	83 c2 08             	add    $0x8,%edx
  8007a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007a8:	eb 0c                	jmp    8007b6 <vprintfmt+0x1aa>
  8007aa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007ae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007b2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007b6:	8b 10                	mov    (%rax),%edx
  8007b8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c0:	48 89 ce             	mov    %rcx,%rsi
  8007c3:	89 d7                	mov    %edx,%edi
  8007c5:	ff d0                	callq  *%rax
			break;
  8007c7:	e9 37 03 00 00       	jmpq   800b03 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cf:	83 f8 30             	cmp    $0x30,%eax
  8007d2:	73 17                	jae    8007eb <vprintfmt+0x1df>
  8007d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007d8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007db:	89 d2                	mov    %edx,%edx
  8007dd:	48 01 d0             	add    %rdx,%rax
  8007e0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e3:	83 c2 08             	add    $0x8,%edx
  8007e6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007e9:	eb 0c                	jmp    8007f7 <vprintfmt+0x1eb>
  8007eb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007ef:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007f3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007f7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007f9:	85 db                	test   %ebx,%ebx
  8007fb:	79 02                	jns    8007ff <vprintfmt+0x1f3>
				err = -err;
  8007fd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007ff:	83 fb 15             	cmp    $0x15,%ebx
  800802:	7f 16                	jg     80081a <vprintfmt+0x20e>
  800804:	48 b8 40 42 80 00 00 	movabs $0x804240,%rax
  80080b:	00 00 00 
  80080e:	48 63 d3             	movslq %ebx,%rdx
  800811:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800815:	4d 85 e4             	test   %r12,%r12
  800818:	75 2e                	jne    800848 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80081a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80081e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800822:	89 d9                	mov    %ebx,%ecx
  800824:	48 ba 01 43 80 00 00 	movabs $0x804301,%rdx
  80082b:	00 00 00 
  80082e:	48 89 c7             	mov    %rax,%rdi
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	49 b8 12 0b 80 00 00 	movabs $0x800b12,%r8
  80083d:	00 00 00 
  800840:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800843:	e9 bb 02 00 00       	jmpq   800b03 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800848:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80084c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800850:	4c 89 e1             	mov    %r12,%rcx
  800853:	48 ba 0a 43 80 00 00 	movabs $0x80430a,%rdx
  80085a:	00 00 00 
  80085d:	48 89 c7             	mov    %rax,%rdi
  800860:	b8 00 00 00 00       	mov    $0x0,%eax
  800865:	49 b8 12 0b 80 00 00 	movabs $0x800b12,%r8
  80086c:	00 00 00 
  80086f:	41 ff d0             	callq  *%r8
			break;
  800872:	e9 8c 02 00 00       	jmpq   800b03 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800877:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087a:	83 f8 30             	cmp    $0x30,%eax
  80087d:	73 17                	jae    800896 <vprintfmt+0x28a>
  80087f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800883:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800886:	89 d2                	mov    %edx,%edx
  800888:	48 01 d0             	add    %rdx,%rax
  80088b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088e:	83 c2 08             	add    $0x8,%edx
  800891:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800894:	eb 0c                	jmp    8008a2 <vprintfmt+0x296>
  800896:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80089a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80089e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a2:	4c 8b 20             	mov    (%rax),%r12
  8008a5:	4d 85 e4             	test   %r12,%r12
  8008a8:	75 0a                	jne    8008b4 <vprintfmt+0x2a8>
				p = "(null)";
  8008aa:	49 bc 0d 43 80 00 00 	movabs $0x80430d,%r12
  8008b1:	00 00 00 
			if (width > 0 && padc != '-')
  8008b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008b8:	7e 78                	jle    800932 <vprintfmt+0x326>
  8008ba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008be:	74 72                	je     800932 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008c3:	48 98                	cltq   
  8008c5:	48 89 c6             	mov    %rax,%rsi
  8008c8:	4c 89 e7             	mov    %r12,%rdi
  8008cb:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  8008d2:	00 00 00 
  8008d5:	ff d0                	callq  *%rax
  8008d7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008da:	eb 17                	jmp    8008f3 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8008dc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008e0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e8:	48 89 ce             	mov    %rcx,%rsi
  8008eb:	89 d7                	mov    %edx,%edi
  8008ed:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008f7:	7f e3                	jg     8008dc <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f9:	eb 37                	jmp    800932 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008ff:	74 1e                	je     80091f <vprintfmt+0x313>
  800901:	83 fb 1f             	cmp    $0x1f,%ebx
  800904:	7e 05                	jle    80090b <vprintfmt+0x2ff>
  800906:	83 fb 7e             	cmp    $0x7e,%ebx
  800909:	7e 14                	jle    80091f <vprintfmt+0x313>
					putch('?', putdat);
  80090b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80090f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800913:	48 89 d6             	mov    %rdx,%rsi
  800916:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80091b:	ff d0                	callq  *%rax
  80091d:	eb 0f                	jmp    80092e <vprintfmt+0x322>
				else
					putch(ch, putdat);
  80091f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800923:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800927:	48 89 d6             	mov    %rdx,%rsi
  80092a:	89 df                	mov    %ebx,%edi
  80092c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800932:	4c 89 e0             	mov    %r12,%rax
  800935:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800939:	0f b6 00             	movzbl (%rax),%eax
  80093c:	0f be d8             	movsbl %al,%ebx
  80093f:	85 db                	test   %ebx,%ebx
  800941:	74 28                	je     80096b <vprintfmt+0x35f>
  800943:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800947:	78 b2                	js     8008fb <vprintfmt+0x2ef>
  800949:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80094d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800951:	79 a8                	jns    8008fb <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800953:	eb 16                	jmp    80096b <vprintfmt+0x35f>
				putch(' ', putdat);
  800955:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800959:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80095d:	48 89 d6             	mov    %rdx,%rsi
  800960:	bf 20 00 00 00       	mov    $0x20,%edi
  800965:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800967:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80096b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096f:	7f e4                	jg     800955 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800971:	e9 8d 01 00 00       	jmpq   800b03 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800976:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80097a:	be 03 00 00 00       	mov    $0x3,%esi
  80097f:	48 89 c7             	mov    %rax,%rdi
  800982:	48 b8 05 05 80 00 00 	movabs $0x800505,%rax
  800989:	00 00 00 
  80098c:	ff d0                	callq  *%rax
  80098e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800996:	48 85 c0             	test   %rax,%rax
  800999:	79 1d                	jns    8009b8 <vprintfmt+0x3ac>
				putch('-', putdat);
  80099b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a3:	48 89 d6             	mov    %rdx,%rsi
  8009a6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009ab:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 f7 d8             	neg    %rax
  8009b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009b8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009bf:	e9 d2 00 00 00       	jmpq   800a96 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c8:	be 03 00 00 00       	mov    $0x3,%esi
  8009cd:	48 89 c7             	mov    %rax,%rdi
  8009d0:	48 b8 fe 03 80 00 00 	movabs $0x8003fe,%rax
  8009d7:	00 00 00 
  8009da:	ff d0                	callq  *%rax
  8009dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009e0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e7:	e9 aa 00 00 00       	jmpq   800a96 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8009ec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f0:	be 03 00 00 00       	mov    $0x3,%esi
  8009f5:	48 89 c7             	mov    %rax,%rdi
  8009f8:	48 b8 fe 03 80 00 00 	movabs $0x8003fe,%rax
  8009ff:	00 00 00 
  800a02:	ff d0                	callq  *%rax
  800a04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a08:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a0f:	e9 82 00 00 00       	jmpq   800a96 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800a14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1c:	48 89 d6             	mov    %rdx,%rsi
  800a1f:	bf 30 00 00 00       	mov    $0x30,%edi
  800a24:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2e:	48 89 d6             	mov    %rdx,%rsi
  800a31:	bf 78 00 00 00       	mov    $0x78,%edi
  800a36:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3b:	83 f8 30             	cmp    $0x30,%eax
  800a3e:	73 17                	jae    800a57 <vprintfmt+0x44b>
  800a40:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a47:	89 d2                	mov    %edx,%edx
  800a49:	48 01 d0             	add    %rdx,%rax
  800a4c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4f:	83 c2 08             	add    $0x8,%edx
  800a52:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a55:	eb 0c                	jmp    800a63 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800a57:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a5b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a5f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a63:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a6a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a71:	eb 23                	jmp    800a96 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a77:	be 03 00 00 00       	mov    $0x3,%esi
  800a7c:	48 89 c7             	mov    %rax,%rdi
  800a7f:	48 b8 fe 03 80 00 00 	movabs $0x8003fe,%rax
  800a86:	00 00 00 
  800a89:	ff d0                	callq  *%rax
  800a8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a8f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a96:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a9b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a9e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800aa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aad:	45 89 c1             	mov    %r8d,%r9d
  800ab0:	41 89 f8             	mov    %edi,%r8d
  800ab3:	48 89 c7             	mov    %rax,%rdi
  800ab6:	48 b8 46 03 80 00 00 	movabs $0x800346,%rax
  800abd:	00 00 00 
  800ac0:	ff d0                	callq  *%rax
			break;
  800ac2:	eb 3f                	jmp    800b03 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acc:	48 89 d6             	mov    %rdx,%rsi
  800acf:	89 df                	mov    %ebx,%edi
  800ad1:	ff d0                	callq  *%rax
			break;
  800ad3:	eb 2e                	jmp    800b03 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	48 89 d6             	mov    %rdx,%rsi
  800ae0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ae5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800aec:	eb 05                	jmp    800af3 <vprintfmt+0x4e7>
  800aee:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800af3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af7:	48 83 e8 01          	sub    $0x1,%rax
  800afb:	0f b6 00             	movzbl (%rax),%eax
  800afe:	3c 25                	cmp    $0x25,%al
  800b00:	75 ec                	jne    800aee <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800b02:	90                   	nop
		}
	}
  800b03:	e9 3d fb ff ff       	jmpq   800645 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b08:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b09:	48 83 c4 60          	add    $0x60,%rsp
  800b0d:	5b                   	pop    %rbx
  800b0e:	41 5c                	pop    %r12
  800b10:	5d                   	pop    %rbp
  800b11:	c3                   	retq   

0000000000800b12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b12:	55                   	push   %rbp
  800b13:	48 89 e5             	mov    %rsp,%rbp
  800b16:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b1d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b24:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b2b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b32:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b39:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b40:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b47:	84 c0                	test   %al,%al
  800b49:	74 20                	je     800b6b <printfmt+0x59>
  800b4b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b4f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b53:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b57:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b5b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b5f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b63:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b67:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b6b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b72:	00 00 00 
  800b75:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b7c:	00 00 00 
  800b7f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b83:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b8a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b91:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b98:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b9f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ba6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bad:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bb4:	48 89 c7             	mov    %rax,%rdi
  800bb7:	48 b8 0c 06 80 00 00 	movabs $0x80060c,%rax
  800bbe:	00 00 00 
  800bc1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bc3:	90                   	nop
  800bc4:	c9                   	leaveq 
  800bc5:	c3                   	retq   

0000000000800bc6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc6:	55                   	push   %rbp
  800bc7:	48 89 e5             	mov    %rsp,%rbp
  800bca:	48 83 ec 10          	sub    $0x10,%rsp
  800bce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd9:	8b 40 10             	mov    0x10(%rax),%eax
  800bdc:	8d 50 01             	lea    0x1(%rax),%edx
  800bdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bea:	48 8b 10             	mov    (%rax),%rdx
  800bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bf5:	48 39 c2             	cmp    %rax,%rdx
  800bf8:	73 17                	jae    800c11 <sprintputch+0x4b>
		*b->buf++ = ch;
  800bfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfe:	48 8b 00             	mov    (%rax),%rax
  800c01:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c09:	48 89 0a             	mov    %rcx,(%rdx)
  800c0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c0f:	88 10                	mov    %dl,(%rax)
}
  800c11:	90                   	nop
  800c12:	c9                   	leaveq 
  800c13:	c3                   	retq   

0000000000800c14 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c14:	55                   	push   %rbp
  800c15:	48 89 e5             	mov    %rsp,%rbp
  800c18:	48 83 ec 50          	sub    $0x50,%rsp
  800c1c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c20:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c23:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c27:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c2b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c2f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c33:	48 8b 0a             	mov    (%rdx),%rcx
  800c36:	48 89 08             	mov    %rcx,(%rax)
  800c39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c4d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c51:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c54:	48 98                	cltq   
  800c56:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c5e:	48 01 d0             	add    %rdx,%rax
  800c61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c6c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c71:	74 06                	je     800c79 <vsnprintf+0x65>
  800c73:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c77:	7f 07                	jg     800c80 <vsnprintf+0x6c>
		return -E_INVAL;
  800c79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c7e:	eb 2f                	jmp    800caf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c80:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c84:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c8c:	48 89 c6             	mov    %rax,%rsi
  800c8f:	48 bf c6 0b 80 00 00 	movabs $0x800bc6,%rdi
  800c96:	00 00 00 
  800c99:	48 b8 0c 06 80 00 00 	movabs $0x80060c,%rax
  800ca0:	00 00 00 
  800ca3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ca5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ca9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cac:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800caf:	c9                   	leaveq 
  800cb0:	c3                   	retq   

0000000000800cb1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb1:	55                   	push   %rbp
  800cb2:	48 89 e5             	mov    %rsp,%rbp
  800cb5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cbc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cc3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cc9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800cd0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cd7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cde:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ce5:	84 c0                	test   %al,%al
  800ce7:	74 20                	je     800d09 <snprintf+0x58>
  800ce9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ced:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cf1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cf5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cf9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cfd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d01:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d05:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d09:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d10:	00 00 00 
  800d13:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d1a:	00 00 00 
  800d1d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d21:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d28:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d2f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d36:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d3d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d44:	48 8b 0a             	mov    (%rdx),%rcx
  800d47:	48 89 08             	mov    %rcx,(%rax)
  800d4a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d4e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d52:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d56:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d5a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d61:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d68:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d6e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d75:	48 89 c7             	mov    %rax,%rdi
  800d78:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  800d7f:	00 00 00 
  800d82:	ff d0                	callq  *%rax
  800d84:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d8a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d90:	c9                   	leaveq 
  800d91:	c3                   	retq   

0000000000800d92 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d92:	55                   	push   %rbp
  800d93:	48 89 e5             	mov    %rsp,%rbp
  800d96:	48 83 ec 18          	sub    $0x18,%rsp
  800d9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800da5:	eb 09                	jmp    800db0 <strlen+0x1e>
		n++;
  800da7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db4:	0f b6 00             	movzbl (%rax),%eax
  800db7:	84 c0                	test   %al,%al
  800db9:	75 ec                	jne    800da7 <strlen+0x15>
		n++;
	return n;
  800dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 20          	sub    $0x20,%rsp
  800dc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dd7:	eb 0e                	jmp    800de7 <strnlen+0x27>
		n++;
  800dd9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ddd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800de2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800de7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dec:	74 0b                	je     800df9 <strnlen+0x39>
  800dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df2:	0f b6 00             	movzbl (%rax),%eax
  800df5:	84 c0                	test   %al,%al
  800df7:	75 e0                	jne    800dd9 <strnlen+0x19>
		n++;
	return n;
  800df9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dfc:	c9                   	leaveq 
  800dfd:	c3                   	retq   

0000000000800dfe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dfe:	55                   	push   %rbp
  800dff:	48 89 e5             	mov    %rsp,%rbp
  800e02:	48 83 ec 20          	sub    $0x20,%rsp
  800e06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e0a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e16:	90                   	nop
  800e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e1f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e23:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e27:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e2b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e2f:	0f b6 12             	movzbl (%rdx),%edx
  800e32:	88 10                	mov    %dl,(%rax)
  800e34:	0f b6 00             	movzbl (%rax),%eax
  800e37:	84 c0                	test   %al,%al
  800e39:	75 dc                	jne    800e17 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e3f:	c9                   	leaveq 
  800e40:	c3                   	retq   

0000000000800e41 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
  800e45:	48 83 ec 20          	sub    $0x20,%rsp
  800e49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e55:	48 89 c7             	mov    %rax,%rdi
  800e58:	48 b8 92 0d 80 00 00 	movabs $0x800d92,%rax
  800e5f:	00 00 00 
  800e62:	ff d0                	callq  *%rax
  800e64:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e6a:	48 63 d0             	movslq %eax,%rdx
  800e6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e71:	48 01 c2             	add    %rax,%rdx
  800e74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e78:	48 89 c6             	mov    %rax,%rsi
  800e7b:	48 89 d7             	mov    %rdx,%rdi
  800e7e:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  800e85:	00 00 00 
  800e88:	ff d0                	callq  *%rax
	return dst;
  800e8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e8e:	c9                   	leaveq 
  800e8f:	c3                   	retq   

0000000000800e90 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e90:	55                   	push   %rbp
  800e91:	48 89 e5             	mov    %rsp,%rbp
  800e94:	48 83 ec 28          	sub    $0x28,%rsp
  800e98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ea0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800eac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800eb3:	00 
  800eb4:	eb 2a                	jmp    800ee0 <strncpy+0x50>
		*dst++ = *src;
  800eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ebe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ec2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec6:	0f b6 12             	movzbl (%rdx),%edx
  800ec9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ecb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ecf:	0f b6 00             	movzbl (%rax),%eax
  800ed2:	84 c0                	test   %al,%al
  800ed4:	74 05                	je     800edb <strncpy+0x4b>
			src++;
  800ed6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ee4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ee8:	72 cc                	jb     800eb6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800eee:	c9                   	leaveq 
  800eef:	c3                   	retq   

0000000000800ef0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ef0:	55                   	push   %rbp
  800ef1:	48 89 e5             	mov    %rsp,%rbp
  800ef4:	48 83 ec 28          	sub    $0x28,%rsp
  800ef8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f0c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f11:	74 3d                	je     800f50 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f13:	eb 1d                	jmp    800f32 <strlcpy+0x42>
			*dst++ = *src++;
  800f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f19:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f21:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f25:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f29:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f2d:	0f b6 12             	movzbl (%rdx),%edx
  800f30:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f32:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f37:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f3c:	74 0b                	je     800f49 <strlcpy+0x59>
  800f3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f42:	0f b6 00             	movzbl (%rax),%eax
  800f45:	84 c0                	test   %al,%al
  800f47:	75 cc                	jne    800f15 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f58:	48 29 c2             	sub    %rax,%rdx
  800f5b:	48 89 d0             	mov    %rdx,%rax
}
  800f5e:	c9                   	leaveq 
  800f5f:	c3                   	retq   

0000000000800f60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f60:	55                   	push   %rbp
  800f61:	48 89 e5             	mov    %rsp,%rbp
  800f64:	48 83 ec 10          	sub    $0x10,%rsp
  800f68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f70:	eb 0a                	jmp    800f7c <strcmp+0x1c>
		p++, q++;
  800f72:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f77:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f80:	0f b6 00             	movzbl (%rax),%eax
  800f83:	84 c0                	test   %al,%al
  800f85:	74 12                	je     800f99 <strcmp+0x39>
  800f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8b:	0f b6 10             	movzbl (%rax),%edx
  800f8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f92:	0f b6 00             	movzbl (%rax),%eax
  800f95:	38 c2                	cmp    %al,%dl
  800f97:	74 d9                	je     800f72 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9d:	0f b6 00             	movzbl (%rax),%eax
  800fa0:	0f b6 d0             	movzbl %al,%edx
  800fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa7:	0f b6 00             	movzbl (%rax),%eax
  800faa:	0f b6 c0             	movzbl %al,%eax
  800fad:	29 c2                	sub    %eax,%edx
  800faf:	89 d0                	mov    %edx,%eax
}
  800fb1:	c9                   	leaveq 
  800fb2:	c3                   	retq   

0000000000800fb3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fb3:	55                   	push   %rbp
  800fb4:	48 89 e5             	mov    %rsp,%rbp
  800fb7:	48 83 ec 18          	sub    $0x18,%rsp
  800fbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fc3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 0f                	jmp    800fd8 <strncmp+0x25>
		n--, p++, q++;
  800fc9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fd3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fd8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fdd:	74 1d                	je     800ffc <strncmp+0x49>
  800fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe3:	0f b6 00             	movzbl (%rax),%eax
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 12                	je     800ffc <strncmp+0x49>
  800fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fee:	0f b6 10             	movzbl (%rax),%edx
  800ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff5:	0f b6 00             	movzbl (%rax),%eax
  800ff8:	38 c2                	cmp    %al,%dl
  800ffa:	74 cd                	je     800fc9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800ffc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801001:	75 07                	jne    80100a <strncmp+0x57>
		return 0;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
  801008:	eb 18                	jmp    801022 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80100a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100e:	0f b6 00             	movzbl (%rax),%eax
  801011:	0f b6 d0             	movzbl %al,%edx
  801014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801018:	0f b6 00             	movzbl (%rax),%eax
  80101b:	0f b6 c0             	movzbl %al,%eax
  80101e:	29 c2                	sub    %eax,%edx
  801020:	89 d0                	mov    %edx,%eax
}
  801022:	c9                   	leaveq 
  801023:	c3                   	retq   

0000000000801024 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801024:	55                   	push   %rbp
  801025:	48 89 e5             	mov    %rsp,%rbp
  801028:	48 83 ec 10          	sub    $0x10,%rsp
  80102c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801030:	89 f0                	mov    %esi,%eax
  801032:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801035:	eb 17                	jmp    80104e <strchr+0x2a>
		if (*s == c)
  801037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103b:	0f b6 00             	movzbl (%rax),%eax
  80103e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801041:	75 06                	jne    801049 <strchr+0x25>
			return (char *) s;
  801043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801047:	eb 15                	jmp    80105e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801049:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80104e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	84 c0                	test   %al,%al
  801057:	75 de                	jne    801037 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 10          	sub    $0x10,%rsp
  801068:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80106c:	89 f0                	mov    %esi,%eax
  80106e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801071:	eb 11                	jmp    801084 <strfind+0x24>
		if (*s == c)
  801073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801077:	0f b6 00             	movzbl (%rax),%eax
  80107a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80107d:	74 12                	je     801091 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80107f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strfind+0x13>
  80108f:	eb 01                	jmp    801092 <strfind+0x32>
		if (*s == c)
			break;
  801091:	90                   	nop
	return (char *) s;
  801092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801096:	c9                   	leaveq 
  801097:	c3                   	retq   

0000000000801098 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	48 83 ec 18          	sub    $0x18,%rsp
  8010a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b0:	75 06                	jne    8010b8 <memset+0x20>
		return v;
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b6:	eb 69                	jmp    801121 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bc:	83 e0 03             	and    $0x3,%eax
  8010bf:	48 85 c0             	test   %rax,%rax
  8010c2:	75 48                	jne    80110c <memset+0x74>
  8010c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c8:	83 e0 03             	and    $0x3,%eax
  8010cb:	48 85 c0             	test   %rax,%rax
  8010ce:	75 3c                	jne    80110c <memset+0x74>
		c &= 0xFF;
  8010d0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010da:	c1 e0 18             	shl    $0x18,%eax
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e2:	c1 e0 10             	shl    $0x10,%eax
  8010e5:	09 c2                	or     %eax,%edx
  8010e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010ea:	c1 e0 08             	shl    $0x8,%eax
  8010ed:	09 d0                	or     %edx,%eax
  8010ef:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f6:	48 c1 e8 02          	shr    $0x2,%rax
  8010fa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801101:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801104:	48 89 d7             	mov    %rdx,%rdi
  801107:	fc                   	cld    
  801108:	f3 ab                	rep stos %eax,%es:(%rdi)
  80110a:	eb 11                	jmp    80111d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80110c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801110:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801113:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801117:	48 89 d7             	mov    %rdx,%rdi
  80111a:	fc                   	cld    
  80111b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80111d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801121:	c9                   	leaveq 
  801122:	c3                   	retq   

0000000000801123 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801123:	55                   	push   %rbp
  801124:	48 89 e5             	mov    %rsp,%rbp
  801127:	48 83 ec 28          	sub    $0x28,%rsp
  80112b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801133:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801137:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80113f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801143:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80114f:	0f 83 88 00 00 00    	jae    8011dd <memmove+0xba>
  801155:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80115d:	48 01 d0             	add    %rdx,%rax
  801160:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801164:	76 77                	jbe    8011dd <memmove+0xba>
		s += n;
  801166:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80116e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801172:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117a:	83 e0 03             	and    $0x3,%eax
  80117d:	48 85 c0             	test   %rax,%rax
  801180:	75 3b                	jne    8011bd <memmove+0x9a>
  801182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801186:	83 e0 03             	and    $0x3,%eax
  801189:	48 85 c0             	test   %rax,%rax
  80118c:	75 2f                	jne    8011bd <memmove+0x9a>
  80118e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801192:	83 e0 03             	and    $0x3,%eax
  801195:	48 85 c0             	test   %rax,%rax
  801198:	75 23                	jne    8011bd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80119a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119e:	48 83 e8 04          	sub    $0x4,%rax
  8011a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a6:	48 83 ea 04          	sub    $0x4,%rdx
  8011aa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011ae:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011b2:	48 89 c7             	mov    %rax,%rdi
  8011b5:	48 89 d6             	mov    %rdx,%rsi
  8011b8:	fd                   	std    
  8011b9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011bb:	eb 1d                	jmp    8011da <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d1:	48 89 d7             	mov    %rdx,%rdi
  8011d4:	48 89 c1             	mov    %rax,%rcx
  8011d7:	fd                   	std    
  8011d8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011da:	fc                   	cld    
  8011db:	eb 57                	jmp    801234 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e1:	83 e0 03             	and    $0x3,%eax
  8011e4:	48 85 c0             	test   %rax,%rax
  8011e7:	75 36                	jne    80121f <memmove+0xfc>
  8011e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ed:	83 e0 03             	and    $0x3,%eax
  8011f0:	48 85 c0             	test   %rax,%rax
  8011f3:	75 2a                	jne    80121f <memmove+0xfc>
  8011f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	48 85 c0             	test   %rax,%rax
  8011ff:	75 1e                	jne    80121f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801205:	48 c1 e8 02          	shr    $0x2,%rax
  801209:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80120c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801210:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801214:	48 89 c7             	mov    %rax,%rdi
  801217:	48 89 d6             	mov    %rdx,%rsi
  80121a:	fc                   	cld    
  80121b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80121d:	eb 15                	jmp    801234 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80121f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801223:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801227:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80122b:	48 89 c7             	mov    %rax,%rdi
  80122e:	48 89 d6             	mov    %rdx,%rsi
  801231:	fc                   	cld    
  801232:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801234:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801238:	c9                   	leaveq 
  801239:	c3                   	retq   

000000000080123a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80123a:	55                   	push   %rbp
  80123b:	48 89 e5             	mov    %rsp,%rbp
  80123e:	48 83 ec 18          	sub    $0x18,%rsp
  801242:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801246:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80124a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80124e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801252:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125a:	48 89 ce             	mov    %rcx,%rsi
  80125d:	48 89 c7             	mov    %rax,%rdi
  801260:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  801267:	00 00 00 
  80126a:	ff d0                	callq  *%rax
}
  80126c:	c9                   	leaveq 
  80126d:	c3                   	retq   

000000000080126e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80126e:	55                   	push   %rbp
  80126f:	48 89 e5             	mov    %rsp,%rbp
  801272:	48 83 ec 28          	sub    $0x28,%rsp
  801276:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80128a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801292:	eb 36                	jmp    8012ca <memcmp+0x5c>
		if (*s1 != *s2)
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	0f b6 10             	movzbl (%rax),%edx
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	38 c2                	cmp    %al,%dl
  8012a4:	74 1a                	je     8012c0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012aa:	0f b6 00             	movzbl (%rax),%eax
  8012ad:	0f b6 d0             	movzbl %al,%edx
  8012b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b4:	0f b6 00             	movzbl (%rax),%eax
  8012b7:	0f b6 c0             	movzbl %al,%eax
  8012ba:	29 c2                	sub    %eax,%edx
  8012bc:	89 d0                	mov    %edx,%eax
  8012be:	eb 20                	jmp    8012e0 <memcmp+0x72>
		s1++, s2++;
  8012c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ce:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012d6:	48 85 c0             	test   %rax,%rax
  8012d9:	75 b9                	jne    801294 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 28          	sub    $0x28,%rsp
  8012ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ee:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fd:	48 01 d0             	add    %rdx,%rax
  801300:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801304:	eb 19                	jmp    80131f <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130a:	0f b6 00             	movzbl (%rax),%eax
  80130d:	0f b6 d0             	movzbl %al,%edx
  801310:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801313:	0f b6 c0             	movzbl %al,%eax
  801316:	39 c2                	cmp    %eax,%edx
  801318:	74 11                	je     80132b <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80131a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801327:	72 dd                	jb     801306 <memfind+0x24>
  801329:	eb 01                	jmp    80132c <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80132b:	90                   	nop
	return (void *) s;
  80132c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 38          	sub    $0x38,%rsp
  80133a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80133e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801342:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80134c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801353:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801354:	eb 05                	jmp    80135b <strtol+0x29>
		s++;
  801356:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135f:	0f b6 00             	movzbl (%rax),%eax
  801362:	3c 20                	cmp    $0x20,%al
  801364:	74 f0                	je     801356 <strtol+0x24>
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	3c 09                	cmp    $0x9,%al
  80136f:	74 e5                	je     801356 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	3c 2b                	cmp    $0x2b,%al
  80137a:	75 07                	jne    801383 <strtol+0x51>
		s++;
  80137c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801381:	eb 17                	jmp    80139a <strtol+0x68>
	else if (*s == '-')
  801383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	3c 2d                	cmp    $0x2d,%al
  80138c:	75 0c                	jne    80139a <strtol+0x68>
		s++, neg = 1;
  80138e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801393:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80139a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80139e:	74 06                	je     8013a6 <strtol+0x74>
  8013a0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013a4:	75 28                	jne    8013ce <strtol+0x9c>
  8013a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	3c 30                	cmp    $0x30,%al
  8013af:	75 1d                	jne    8013ce <strtol+0x9c>
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	48 83 c0 01          	add    $0x1,%rax
  8013b9:	0f b6 00             	movzbl (%rax),%eax
  8013bc:	3c 78                	cmp    $0x78,%al
  8013be:	75 0e                	jne    8013ce <strtol+0x9c>
		s += 2, base = 16;
  8013c0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013c5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013cc:	eb 2c                	jmp    8013fa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013d2:	75 19                	jne    8013ed <strtol+0xbb>
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	3c 30                	cmp    $0x30,%al
  8013dd:	75 0e                	jne    8013ed <strtol+0xbb>
		s++, base = 8;
  8013df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013eb:	eb 0d                	jmp    8013fa <strtol+0xc8>
	else if (base == 0)
  8013ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f1:	75 07                	jne    8013fa <strtol+0xc8>
		base = 10;
  8013f3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fe:	0f b6 00             	movzbl (%rax),%eax
  801401:	3c 2f                	cmp    $0x2f,%al
  801403:	7e 1d                	jle    801422 <strtol+0xf0>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	3c 39                	cmp    $0x39,%al
  80140e:	7f 12                	jg     801422 <strtol+0xf0>
			dig = *s - '0';
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	0f be c0             	movsbl %al,%eax
  80141a:	83 e8 30             	sub    $0x30,%eax
  80141d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801420:	eb 4e                	jmp    801470 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	3c 60                	cmp    $0x60,%al
  80142b:	7e 1d                	jle    80144a <strtol+0x118>
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	3c 7a                	cmp    $0x7a,%al
  801436:	7f 12                	jg     80144a <strtol+0x118>
			dig = *s - 'a' + 10;
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	0f be c0             	movsbl %al,%eax
  801442:	83 e8 57             	sub    $0x57,%eax
  801445:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801448:	eb 26                	jmp    801470 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	3c 40                	cmp    $0x40,%al
  801453:	7e 47                	jle    80149c <strtol+0x16a>
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	3c 5a                	cmp    $0x5a,%al
  80145e:	7f 3c                	jg     80149c <strtol+0x16a>
			dig = *s - 'A' + 10;
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	0f b6 00             	movzbl (%rax),%eax
  801467:	0f be c0             	movsbl %al,%eax
  80146a:	83 e8 37             	sub    $0x37,%eax
  80146d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801470:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801473:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801476:	7d 23                	jge    80149b <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801478:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801480:	48 98                	cltq   
  801482:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801487:	48 89 c2             	mov    %rax,%rdx
  80148a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80148d:	48 98                	cltq   
  80148f:	48 01 d0             	add    %rdx,%rax
  801492:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801496:	e9 5f ff ff ff       	jmpq   8013fa <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014a1:	74 0b                	je     8014ae <strtol+0x17c>
		*endptr = (char *) s;
  8014a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014a7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014ab:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014b2:	74 09                	je     8014bd <strtol+0x18b>
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	48 f7 d8             	neg    %rax
  8014bb:	eb 04                	jmp    8014c1 <strtol+0x18f>
  8014bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014c1:	c9                   	leaveq 
  8014c2:	c3                   	retq   

00000000008014c3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	48 83 ec 30          	sub    $0x30,%rsp
  8014cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014db:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014e5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014e9:	75 06                	jne    8014f1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	eb 6b                	jmp    80155c <strstr+0x99>

	len = strlen(str);
  8014f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f5:	48 89 c7             	mov    %rax,%rdi
  8014f8:	48 b8 92 0d 80 00 00 	movabs $0x800d92,%rax
  8014ff:	00 00 00 
  801502:	ff d0                	callq  *%rax
  801504:	48 98                	cltq   
  801506:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80150a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801512:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801516:	0f b6 00             	movzbl (%rax),%eax
  801519:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80151c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801520:	75 07                	jne    801529 <strstr+0x66>
				return (char *) 0;
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
  801527:	eb 33                	jmp    80155c <strstr+0x99>
		} while (sc != c);
  801529:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80152d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801530:	75 d8                	jne    80150a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801532:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801536:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	48 89 ce             	mov    %rcx,%rsi
  801541:	48 89 c7             	mov    %rax,%rdi
  801544:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  80154b:	00 00 00 
  80154e:	ff d0                	callq  *%rax
  801550:	85 c0                	test   %eax,%eax
  801552:	75 b6                	jne    80150a <strstr+0x47>

	return (char *) (in - 1);
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	48 83 e8 01          	sub    $0x1,%rax
}
  80155c:	c9                   	leaveq 
  80155d:	c3                   	retq   

000000000080155e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80155e:	55                   	push   %rbp
  80155f:	48 89 e5             	mov    %rsp,%rbp
  801562:	53                   	push   %rbx
  801563:	48 83 ec 48          	sub    $0x48,%rsp
  801567:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80156a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80156d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801571:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801575:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801579:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801580:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801584:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801588:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80158c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801590:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801594:	4c 89 c3             	mov    %r8,%rbx
  801597:	cd 30                	int    $0x30
  801599:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80159d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015a1:	74 3e                	je     8015e1 <syscall+0x83>
  8015a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a8:	7e 37                	jle    8015e1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015b1:	49 89 d0             	mov    %rdx,%r8
  8015b4:	89 c1                	mov    %eax,%ecx
  8015b6:	48 ba c8 45 80 00 00 	movabs $0x8045c8,%rdx
  8015bd:	00 00 00 
  8015c0:	be 24 00 00 00       	mov    $0x24,%esi
  8015c5:	48 bf e5 45 80 00 00 	movabs $0x8045e5,%rdi
  8015cc:	00 00 00 
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d4:	49 b9 de 3b 80 00 00 	movabs $0x803bde,%r9
  8015db:	00 00 00 
  8015de:	41 ff d1             	callq  *%r9

	return ret;
  8015e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e5:	48 83 c4 48          	add    $0x48,%rsp
  8015e9:	5b                   	pop    %rbx
  8015ea:	5d                   	pop    %rbp
  8015eb:	c3                   	retq   

00000000008015ec <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015ec:	55                   	push   %rbp
  8015ed:	48 89 e5             	mov    %rsp,%rbp
  8015f0:	48 83 ec 10          	sub    $0x10,%rsp
  8015f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801604:	48 83 ec 08          	sub    $0x8,%rsp
  801608:	6a 00                	pushq  $0x0
  80160a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801610:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801616:	48 89 d1             	mov    %rdx,%rcx
  801619:	48 89 c2             	mov    %rax,%rdx
  80161c:	be 00 00 00 00       	mov    $0x0,%esi
  801621:	bf 00 00 00 00       	mov    $0x0,%edi
  801626:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  80162d:	00 00 00 
  801630:	ff d0                	callq  *%rax
  801632:	48 83 c4 10          	add    $0x10,%rsp
}
  801636:	90                   	nop
  801637:	c9                   	leaveq 
  801638:	c3                   	retq   

0000000000801639 <sys_cgetc>:

int
sys_cgetc(void)
{
  801639:	55                   	push   %rbp
  80163a:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80163d:	48 83 ec 08          	sub    $0x8,%rsp
  801641:	6a 00                	pushq  $0x0
  801643:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801649:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80164f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801654:	ba 00 00 00 00       	mov    $0x0,%edx
  801659:	be 00 00 00 00       	mov    $0x0,%esi
  80165e:	bf 01 00 00 00       	mov    $0x1,%edi
  801663:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  80166a:	00 00 00 
  80166d:	ff d0                	callq  *%rax
  80166f:	48 83 c4 10          	add    $0x10,%rsp
}
  801673:	c9                   	leaveq 
  801674:	c3                   	retq   

0000000000801675 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	48 83 ec 10          	sub    $0x10,%rsp
  80167d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801683:	48 98                	cltq   
  801685:	48 83 ec 08          	sub    $0x8,%rsp
  801689:	6a 00                	pushq  $0x0
  80168b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801691:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169c:	48 89 c2             	mov    %rax,%rdx
  80169f:	be 01 00 00 00       	mov    $0x1,%esi
  8016a4:	bf 03 00 00 00       	mov    $0x3,%edi
  8016a9:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  8016b0:	00 00 00 
  8016b3:	ff d0                	callq  *%rax
  8016b5:	48 83 c4 10          	add    $0x10,%rsp
}
  8016b9:	c9                   	leaveq 
  8016ba:	c3                   	retq   

00000000008016bb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016bf:	48 83 ec 08          	sub    $0x8,%rsp
  8016c3:	6a 00                	pushq  $0x0
  8016c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016db:	be 00 00 00 00       	mov    $0x0,%esi
  8016e0:	bf 02 00 00 00       	mov    $0x2,%edi
  8016e5:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  8016ec:	00 00 00 
  8016ef:	ff d0                	callq  *%rax
  8016f1:	48 83 c4 10          	add    $0x10,%rsp
}
  8016f5:	c9                   	leaveq 
  8016f6:	c3                   	retq   

00000000008016f7 <sys_yield>:


void
sys_yield(void)
{
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8016fb:	48 83 ec 08          	sub    $0x8,%rsp
  8016ff:	6a 00                	pushq  $0x0
  801701:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801707:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80170d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	be 00 00 00 00       	mov    $0x0,%esi
  80171c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801721:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801728:	00 00 00 
  80172b:	ff d0                	callq  *%rax
  80172d:	48 83 c4 10          	add    $0x10,%rsp
}
  801731:	90                   	nop
  801732:	c9                   	leaveq 
  801733:	c3                   	retq   

0000000000801734 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801734:	55                   	push   %rbp
  801735:	48 89 e5             	mov    %rsp,%rbp
  801738:	48 83 ec 10          	sub    $0x10,%rsp
  80173c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80173f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801743:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801746:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801749:	48 63 c8             	movslq %eax,%rcx
  80174c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801753:	48 98                	cltq   
  801755:	48 83 ec 08          	sub    $0x8,%rsp
  801759:	6a 00                	pushq  $0x0
  80175b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801761:	49 89 c8             	mov    %rcx,%r8
  801764:	48 89 d1             	mov    %rdx,%rcx
  801767:	48 89 c2             	mov    %rax,%rdx
  80176a:	be 01 00 00 00       	mov    $0x1,%esi
  80176f:	bf 04 00 00 00       	mov    $0x4,%edi
  801774:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
  801780:	48 83 c4 10          	add    $0x10,%rsp
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	48 83 ec 20          	sub    $0x20,%rsp
  80178e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801791:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801795:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801798:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80179c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017a0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017a3:	48 63 c8             	movslq %eax,%rcx
  8017a6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ad:	48 63 f0             	movslq %eax,%rsi
  8017b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b7:	48 98                	cltq   
  8017b9:	48 83 ec 08          	sub    $0x8,%rsp
  8017bd:	51                   	push   %rcx
  8017be:	49 89 f9             	mov    %rdi,%r9
  8017c1:	49 89 f0             	mov    %rsi,%r8
  8017c4:	48 89 d1             	mov    %rdx,%rcx
  8017c7:	48 89 c2             	mov    %rax,%rdx
  8017ca:	be 01 00 00 00       	mov    $0x1,%esi
  8017cf:	bf 05 00 00 00       	mov    $0x5,%edi
  8017d4:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	callq  *%rax
  8017e0:	48 83 c4 10          	add    $0x10,%rsp
}
  8017e4:	c9                   	leaveq 
  8017e5:	c3                   	retq   

00000000008017e6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	48 83 ec 10          	sub    $0x10,%rsp
  8017ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fc:	48 98                	cltq   
  8017fe:	48 83 ec 08          	sub    $0x8,%rsp
  801802:	6a 00                	pushq  $0x0
  801804:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801810:	48 89 d1             	mov    %rdx,%rcx
  801813:	48 89 c2             	mov    %rax,%rdx
  801816:	be 01 00 00 00       	mov    $0x1,%esi
  80181b:	bf 06 00 00 00       	mov    $0x6,%edi
  801820:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801827:	00 00 00 
  80182a:	ff d0                	callq  *%rax
  80182c:	48 83 c4 10          	add    $0x10,%rsp
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 10          	sub    $0x10,%rsp
  80183a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801840:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801843:	48 63 d0             	movslq %eax,%rdx
  801846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801849:	48 98                	cltq   
  80184b:	48 83 ec 08          	sub    $0x8,%rsp
  80184f:	6a 00                	pushq  $0x0
  801851:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801857:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185d:	48 89 d1             	mov    %rdx,%rcx
  801860:	48 89 c2             	mov    %rax,%rdx
  801863:	be 01 00 00 00       	mov    $0x1,%esi
  801868:	bf 08 00 00 00       	mov    $0x8,%edi
  80186d:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801874:	00 00 00 
  801877:	ff d0                	callq  *%rax
  801879:	48 83 c4 10          	add    $0x10,%rsp
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 83 ec 10          	sub    $0x10,%rsp
  801887:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80188e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801892:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801895:	48 98                	cltq   
  801897:	48 83 ec 08          	sub    $0x8,%rsp
  80189b:	6a 00                	pushq  $0x0
  80189d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a9:	48 89 d1             	mov    %rdx,%rcx
  8018ac:	48 89 c2             	mov    %rax,%rdx
  8018af:	be 01 00 00 00       	mov    $0x1,%esi
  8018b4:	bf 09 00 00 00       	mov    $0x9,%edi
  8018b9:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
  8018c5:	48 83 c4 10          	add    $0x10,%rsp
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 10          	sub    $0x10,%rsp
  8018d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e1:	48 98                	cltq   
  8018e3:	48 83 ec 08          	sub    $0x8,%rsp
  8018e7:	6a 00                	pushq  $0x0
  8018e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f5:	48 89 d1             	mov    %rdx,%rcx
  8018f8:	48 89 c2             	mov    %rax,%rdx
  8018fb:	be 01 00 00 00       	mov    $0x1,%esi
  801900:	bf 0a 00 00 00       	mov    $0xa,%edi
  801905:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  80190c:	00 00 00 
  80190f:	ff d0                	callq  *%rax
  801911:	48 83 c4 10          	add    $0x10,%rsp
}
  801915:	c9                   	leaveq 
  801916:	c3                   	retq   

0000000000801917 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801917:	55                   	push   %rbp
  801918:	48 89 e5             	mov    %rsp,%rbp
  80191b:	48 83 ec 20          	sub    $0x20,%rsp
  80191f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801922:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801926:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80192a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80192d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801930:	48 63 f0             	movslq %eax,%rsi
  801933:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193a:	48 98                	cltq   
  80193c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801940:	48 83 ec 08          	sub    $0x8,%rsp
  801944:	6a 00                	pushq  $0x0
  801946:	49 89 f1             	mov    %rsi,%r9
  801949:	49 89 c8             	mov    %rcx,%r8
  80194c:	48 89 d1             	mov    %rdx,%rcx
  80194f:	48 89 c2             	mov    %rax,%rdx
  801952:	be 00 00 00 00       	mov    $0x0,%esi
  801957:	bf 0c 00 00 00       	mov    $0xc,%edi
  80195c:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801963:	00 00 00 
  801966:	ff d0                	callq  *%rax
  801968:	48 83 c4 10          	add    $0x10,%rsp
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 10          	sub    $0x10,%rsp
  801976:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80197a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197e:	48 83 ec 08          	sub    $0x8,%rsp
  801982:	6a 00                	pushq  $0x0
  801984:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801990:	b9 00 00 00 00       	mov    $0x0,%ecx
  801995:	48 89 c2             	mov    %rax,%rdx
  801998:	be 01 00 00 00       	mov    $0x1,%esi
  80199d:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019a2:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  8019a9:	00 00 00 
  8019ac:	ff d0                	callq  *%rax
  8019ae:	48 83 c4 10          	add    $0x10,%rsp
}
  8019b2:	c9                   	leaveq 
  8019b3:	c3                   	retq   

00000000008019b4 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8019b8:	48 83 ec 08          	sub    $0x8,%rsp
  8019bc:	6a 00                	pushq  $0x0
  8019be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d4:	be 00 00 00 00       	mov    $0x0,%esi
  8019d9:	bf 0e 00 00 00       	mov    $0xe,%edi
  8019de:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  8019e5:	00 00 00 
  8019e8:	ff d0                	callq  *%rax
  8019ea:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ee:	c9                   	leaveq 
  8019ef:	c3                   	retq   

00000000008019f0 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8019f0:	55                   	push   %rbp
  8019f1:	48 89 e5             	mov    %rsp,%rbp
  8019f4:	48 83 ec 10          	sub    $0x10,%rsp
  8019f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019fc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8019ff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a06:	48 83 ec 08          	sub    $0x8,%rsp
  801a0a:	6a 00                	pushq  $0x0
  801a0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a18:	48 89 d1             	mov    %rdx,%rcx
  801a1b:	48 89 c2             	mov    %rax,%rdx
  801a1e:	be 00 00 00 00       	mov    $0x0,%esi
  801a23:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a28:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	callq  *%rax
  801a34:	48 83 c4 10          	add    $0x10,%rsp
}
  801a38:	c9                   	leaveq 
  801a39:	c3                   	retq   

0000000000801a3a <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801a3a:	55                   	push   %rbp
  801a3b:	48 89 e5             	mov    %rsp,%rbp
  801a3e:	48 83 ec 10          	sub    $0x10,%rsp
  801a42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a46:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801a49:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a50:	48 83 ec 08          	sub    $0x8,%rsp
  801a54:	6a 00                	pushq  $0x0
  801a56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a62:	48 89 d1             	mov    %rdx,%rcx
  801a65:	48 89 c2             	mov    %rax,%rdx
  801a68:	be 00 00 00 00       	mov    $0x0,%esi
  801a6d:	bf 10 00 00 00       	mov    $0x10,%edi
  801a72:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801a79:	00 00 00 
  801a7c:	ff d0                	callq  *%rax
  801a7e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a82:	c9                   	leaveq 
  801a83:	c3                   	retq   

0000000000801a84 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801a84:	55                   	push   %rbp
  801a85:	48 89 e5             	mov    %rsp,%rbp
  801a88:	48 83 ec 20          	sub    $0x20,%rsp
  801a8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a93:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a96:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a9a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801a9e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aa1:	48 63 c8             	movslq %eax,%rcx
  801aa4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aab:	48 63 f0             	movslq %eax,%rsi
  801aae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab5:	48 98                	cltq   
  801ab7:	48 83 ec 08          	sub    $0x8,%rsp
  801abb:	51                   	push   %rcx
  801abc:	49 89 f9             	mov    %rdi,%r9
  801abf:	49 89 f0             	mov    %rsi,%r8
  801ac2:	48 89 d1             	mov    %rdx,%rcx
  801ac5:	48 89 c2             	mov    %rax,%rdx
  801ac8:	be 00 00 00 00       	mov    $0x0,%esi
  801acd:	bf 11 00 00 00       	mov    $0x11,%edi
  801ad2:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801ad9:	00 00 00 
  801adc:	ff d0                	callq  *%rax
  801ade:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ae2:	c9                   	leaveq 
  801ae3:	c3                   	retq   

0000000000801ae4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ae4:	55                   	push   %rbp
  801ae5:	48 89 e5             	mov    %rsp,%rbp
  801ae8:	48 83 ec 10          	sub    $0x10,%rsp
  801aec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801af0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801af4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afc:	48 83 ec 08          	sub    $0x8,%rsp
  801b00:	6a 00                	pushq  $0x0
  801b02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0e:	48 89 d1             	mov    %rdx,%rcx
  801b11:	48 89 c2             	mov    %rax,%rdx
  801b14:	be 00 00 00 00       	mov    $0x0,%esi
  801b19:	bf 12 00 00 00       	mov    $0x12,%edi
  801b1e:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	callq  *%rax
  801b2a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b2e:	c9                   	leaveq 
  801b2f:	c3                   	retq   

0000000000801b30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
  801b34:	48 83 ec 08          	sub    $0x8,%rsp
  801b38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b40:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b47:	ff ff ff 
  801b4a:	48 01 d0             	add    %rdx,%rax
  801b4d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b51:	c9                   	leaveq 
  801b52:	c3                   	retq   

0000000000801b53 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 08          	sub    $0x8,%rsp
  801b5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b63:	48 89 c7             	mov    %rax,%rdi
  801b66:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  801b6d:	00 00 00 
  801b70:	ff d0                	callq  *%rax
  801b72:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b78:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b7c:	c9                   	leaveq 
  801b7d:	c3                   	retq   

0000000000801b7e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b7e:	55                   	push   %rbp
  801b7f:	48 89 e5             	mov    %rsp,%rbp
  801b82:	48 83 ec 18          	sub    $0x18,%rsp
  801b86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b91:	eb 6b                	jmp    801bfe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b96:	48 98                	cltq   
  801b98:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b9e:	48 c1 e0 0c          	shl    $0xc,%rax
  801ba2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801baa:	48 c1 e8 15          	shr    $0x15,%rax
  801bae:	48 89 c2             	mov    %rax,%rdx
  801bb1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bb8:	01 00 00 
  801bbb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bbf:	83 e0 01             	and    $0x1,%eax
  801bc2:	48 85 c0             	test   %rax,%rax
  801bc5:	74 21                	je     801be8 <fd_alloc+0x6a>
  801bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bcb:	48 c1 e8 0c          	shr    $0xc,%rax
  801bcf:	48 89 c2             	mov    %rax,%rdx
  801bd2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bd9:	01 00 00 
  801bdc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801be0:	83 e0 01             	and    $0x1,%eax
  801be3:	48 85 c0             	test   %rax,%rax
  801be6:	75 12                	jne    801bfa <fd_alloc+0x7c>
			*fd_store = fd;
  801be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	eb 1a                	jmp    801c14 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bfa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bfe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801c02:	7e 8f                	jle    801b93 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c08:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c0f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c14:	c9                   	leaveq 
  801c15:	c3                   	retq   

0000000000801c16 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c16:	55                   	push   %rbp
  801c17:	48 89 e5             	mov    %rsp,%rbp
  801c1a:	48 83 ec 20          	sub    $0x20,%rsp
  801c1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c25:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c29:	78 06                	js     801c31 <fd_lookup+0x1b>
  801c2b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c2f:	7e 07                	jle    801c38 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c36:	eb 6c                	jmp    801ca4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c3b:	48 98                	cltq   
  801c3d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c43:	48 c1 e0 0c          	shl    $0xc,%rax
  801c47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4f:	48 c1 e8 15          	shr    $0x15,%rax
  801c53:	48 89 c2             	mov    %rax,%rdx
  801c56:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c5d:	01 00 00 
  801c60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c64:	83 e0 01             	and    $0x1,%eax
  801c67:	48 85 c0             	test   %rax,%rax
  801c6a:	74 21                	je     801c8d <fd_lookup+0x77>
  801c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c70:	48 c1 e8 0c          	shr    $0xc,%rax
  801c74:	48 89 c2             	mov    %rax,%rdx
  801c77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c7e:	01 00 00 
  801c81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c85:	83 e0 01             	and    $0x1,%eax
  801c88:	48 85 c0             	test   %rax,%rax
  801c8b:	75 07                	jne    801c94 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c92:	eb 10                	jmp    801ca4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c98:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c9c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca4:	c9                   	leaveq 
  801ca5:	c3                   	retq   

0000000000801ca6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ca6:	55                   	push   %rbp
  801ca7:	48 89 e5             	mov    %rsp,%rbp
  801caa:	48 83 ec 30          	sub    $0x30,%rsp
  801cae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cb2:	89 f0                	mov    %esi,%eax
  801cb4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbb:	48 89 c7             	mov    %rax,%rdi
  801cbe:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
  801cca:	89 c2                	mov    %eax,%edx
  801ccc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801cd0:	48 89 c6             	mov    %rax,%rsi
  801cd3:	89 d7                	mov    %edx,%edi
  801cd5:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
  801ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce8:	78 0a                	js     801cf4 <fd_close+0x4e>
	    || fd != fd2)
  801cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cee:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cf2:	74 12                	je     801d06 <fd_close+0x60>
		return (must_exist ? r : 0);
  801cf4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cf8:	74 05                	je     801cff <fd_close+0x59>
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	eb 70                	jmp    801d6f <fd_close+0xc9>
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	eb 69                	jmp    801d6f <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0a:	8b 00                	mov    (%rax),%eax
  801d0c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d10:	48 89 d6             	mov    %rdx,%rsi
  801d13:	89 c7                	mov    %eax,%edi
  801d15:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  801d1c:	00 00 00 
  801d1f:	ff d0                	callq  *%rax
  801d21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d28:	78 2a                	js     801d54 <fd_close+0xae>
		if (dev->dev_close)
  801d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2e:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d32:	48 85 c0             	test   %rax,%rax
  801d35:	74 16                	je     801d4d <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801d37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d3f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d43:	48 89 d7             	mov    %rdx,%rdi
  801d46:	ff d0                	callq  *%rax
  801d48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d4b:	eb 07                	jmp    801d54 <fd_close+0xae>
		else
			r = 0;
  801d4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d58:	48 89 c6             	mov    %rax,%rsi
  801d5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d60:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax
	return r;
  801d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 20          	sub    $0x20,%rsp
  801d79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d87:	eb 41                	jmp    801dca <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d89:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d90:	00 00 00 
  801d93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d96:	48 63 d2             	movslq %edx,%rdx
  801d99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9d:	8b 00                	mov    (%rax),%eax
  801d9f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801da2:	75 22                	jne    801dc6 <dev_lookup+0x55>
			*dev = devtab[i];
  801da4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801dab:	00 00 00 
  801dae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801db1:	48 63 d2             	movslq %edx,%rdx
  801db4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801db8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dbc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	eb 60                	jmp    801e26 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801dc6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dca:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801dd1:	00 00 00 
  801dd4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dd7:	48 63 d2             	movslq %edx,%rdx
  801dda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dde:	48 85 c0             	test   %rax,%rax
  801de1:	75 a6                	jne    801d89 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801de3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801dea:	00 00 00 
  801ded:	48 8b 00             	mov    (%rax),%rax
  801df0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801df6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801df9:	89 c6                	mov    %eax,%esi
  801dfb:	48 bf f8 45 80 00 00 	movabs $0x8045f8,%rdi
  801e02:	00 00 00 
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0a:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  801e11:	00 00 00 
  801e14:	ff d1                	callq  *%rcx
	*dev = 0;
  801e16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e1a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e26:	c9                   	leaveq 
  801e27:	c3                   	retq   

0000000000801e28 <close>:

int
close(int fdnum)
{
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	48 83 ec 20          	sub    $0x20,%rsp
  801e30:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e33:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e3a:	48 89 d6             	mov    %rdx,%rsi
  801e3d:	89 c7                	mov    %eax,%edi
  801e3f:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  801e46:	00 00 00 
  801e49:	ff d0                	callq  *%rax
  801e4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e52:	79 05                	jns    801e59 <close+0x31>
		return r;
  801e54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e57:	eb 18                	jmp    801e71 <close+0x49>
	else
		return fd_close(fd, 1);
  801e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5d:	be 01 00 00 00       	mov    $0x1,%esi
  801e62:	48 89 c7             	mov    %rax,%rdi
  801e65:	48 b8 a6 1c 80 00 00 	movabs $0x801ca6,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
}
  801e71:	c9                   	leaveq 
  801e72:	c3                   	retq   

0000000000801e73 <close_all>:

void
close_all(void)
{
  801e73:	55                   	push   %rbp
  801e74:	48 89 e5             	mov    %rsp,%rbp
  801e77:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e82:	eb 15                	jmp    801e99 <close_all+0x26>
		close(i);
  801e84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e87:	89 c7                	mov    %eax,%edi
  801e89:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  801e90:	00 00 00 
  801e93:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e95:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e99:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e9d:	7e e5                	jle    801e84 <close_all+0x11>
		close(i);
}
  801e9f:	90                   	nop
  801ea0:	c9                   	leaveq 
  801ea1:	c3                   	retq   

0000000000801ea2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ea2:	55                   	push   %rbp
  801ea3:	48 89 e5             	mov    %rsp,%rbp
  801ea6:	48 83 ec 40          	sub    $0x40,%rsp
  801eaa:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ead:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801eb0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801eb4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801eb7:	48 89 d6             	mov    %rdx,%rsi
  801eba:	89 c7                	mov    %eax,%edi
  801ebc:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
  801ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ecf:	79 08                	jns    801ed9 <dup+0x37>
		return r;
  801ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed4:	e9 70 01 00 00       	jmpq   802049 <dup+0x1a7>
	close(newfdnum);
  801ed9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801edc:	89 c7                	mov    %eax,%edi
  801ede:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801eea:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801eed:	48 98                	cltq   
  801eef:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ef5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f01:	48 89 c7             	mov    %rax,%rdi
  801f04:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	callq  *%rax
  801f10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f18:	48 89 c7             	mov    %rax,%rdi
  801f1b:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
  801f27:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2f:	48 c1 e8 15          	shr    $0x15,%rax
  801f33:	48 89 c2             	mov    %rax,%rdx
  801f36:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f3d:	01 00 00 
  801f40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f44:	83 e0 01             	and    $0x1,%eax
  801f47:	48 85 c0             	test   %rax,%rax
  801f4a:	74 71                	je     801fbd <dup+0x11b>
  801f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f50:	48 c1 e8 0c          	shr    $0xc,%rax
  801f54:	48 89 c2             	mov    %rax,%rdx
  801f57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5e:	01 00 00 
  801f61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f65:	83 e0 01             	and    $0x1,%eax
  801f68:	48 85 c0             	test   %rax,%rax
  801f6b:	74 50                	je     801fbd <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f71:	48 c1 e8 0c          	shr    $0xc,%rax
  801f75:	48 89 c2             	mov    %rax,%rdx
  801f78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f7f:	01 00 00 
  801f82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f86:	25 07 0e 00 00       	and    $0xe07,%eax
  801f8b:	89 c1                	mov    %eax,%ecx
  801f8d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f95:	41 89 c8             	mov    %ecx,%r8d
  801f98:	48 89 d1             	mov    %rdx,%rcx
  801f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa0:	48 89 c6             	mov    %rax,%rsi
  801fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa8:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	callq  *%rax
  801fb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbb:	78 55                	js     802012 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc1:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc5:	48 89 c2             	mov    %rax,%rdx
  801fc8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fcf:	01 00 00 
  801fd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd6:	25 07 0e 00 00       	and    $0xe07,%eax
  801fdb:	89 c1                	mov    %eax,%ecx
  801fdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe5:	41 89 c8             	mov    %ecx,%r8d
  801fe8:	48 89 d1             	mov    %rdx,%rcx
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	48 89 c6             	mov    %rax,%rsi
  801ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff8:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
  802004:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80200b:	78 08                	js     802015 <dup+0x173>
		goto err;

	return newfdnum;
  80200d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802010:	eb 37                	jmp    802049 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802012:	90                   	nop
  802013:	eb 01                	jmp    802016 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802015:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201a:	48 89 c6             	mov    %rax,%rsi
  80201d:	bf 00 00 00 00       	mov    $0x0,%edi
  802022:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  802029:	00 00 00 
  80202c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80202e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802032:	48 89 c6             	mov    %rax,%rsi
  802035:	bf 00 00 00 00       	mov    $0x0,%edi
  80203a:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
	return r;
  802046:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 83 ec 40          	sub    $0x40,%rsp
  802053:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802056:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80205a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80205e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802062:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802065:	48 89 d6             	mov    %rdx,%rsi
  802068:	89 c7                	mov    %eax,%edi
  80206a:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  802071:	00 00 00 
  802074:	ff d0                	callq  *%rax
  802076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80207d:	78 24                	js     8020a3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80207f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802083:	8b 00                	mov    (%rax),%eax
  802085:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802089:	48 89 d6             	mov    %rdx,%rsi
  80208c:	89 c7                	mov    %eax,%edi
  80208e:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  802095:	00 00 00 
  802098:	ff d0                	callq  *%rax
  80209a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80209d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a1:	79 05                	jns    8020a8 <read+0x5d>
		return r;
  8020a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a6:	eb 76                	jmp    80211e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ac:	8b 40 08             	mov    0x8(%rax),%eax
  8020af:	83 e0 03             	and    $0x3,%eax
  8020b2:	83 f8 01             	cmp    $0x1,%eax
  8020b5:	75 3a                	jne    8020f1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020be:	00 00 00 
  8020c1:	48 8b 00             	mov    (%rax),%rax
  8020c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020ca:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020cd:	89 c6                	mov    %eax,%esi
  8020cf:	48 bf 17 46 80 00 00 	movabs $0x804617,%rdi
  8020d6:	00 00 00 
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  8020e5:	00 00 00 
  8020e8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ef:	eb 2d                	jmp    80211e <read+0xd3>
	}
	if (!dev->dev_read)
  8020f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020f9:	48 85 c0             	test   %rax,%rax
  8020fc:	75 07                	jne    802105 <read+0xba>
		return -E_NOT_SUPP;
  8020fe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802103:	eb 19                	jmp    80211e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802109:	48 8b 40 10          	mov    0x10(%rax),%rax
  80210d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802111:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802115:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802119:	48 89 cf             	mov    %rcx,%rdi
  80211c:	ff d0                	callq  *%rax
}
  80211e:	c9                   	leaveq 
  80211f:	c3                   	retq   

0000000000802120 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802120:	55                   	push   %rbp
  802121:	48 89 e5             	mov    %rsp,%rbp
  802124:	48 83 ec 30          	sub    $0x30,%rsp
  802128:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80212b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80212f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80213a:	eb 47                	jmp    802183 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80213c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213f:	48 98                	cltq   
  802141:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802145:	48 29 c2             	sub    %rax,%rdx
  802148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214b:	48 63 c8             	movslq %eax,%rcx
  80214e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802152:	48 01 c1             	add    %rax,%rcx
  802155:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802158:	48 89 ce             	mov    %rcx,%rsi
  80215b:	89 c7                	mov    %eax,%edi
  80215d:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  802164:	00 00 00 
  802167:	ff d0                	callq  *%rax
  802169:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80216c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802170:	79 05                	jns    802177 <readn+0x57>
			return m;
  802172:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802175:	eb 1d                	jmp    802194 <readn+0x74>
		if (m == 0)
  802177:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80217b:	74 13                	je     802190 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80217d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802180:	01 45 fc             	add    %eax,-0x4(%rbp)
  802183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802186:	48 98                	cltq   
  802188:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80218c:	72 ae                	jb     80213c <readn+0x1c>
  80218e:	eb 01                	jmp    802191 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802190:	90                   	nop
	}
	return tot;
  802191:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802194:	c9                   	leaveq 
  802195:	c3                   	retq   

0000000000802196 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802196:	55                   	push   %rbp
  802197:	48 89 e5             	mov    %rsp,%rbp
  80219a:	48 83 ec 40          	sub    $0x40,%rsp
  80219e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b0:	48 89 d6             	mov    %rdx,%rsi
  8021b3:	89 c7                	mov    %eax,%edi
  8021b5:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
  8021c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c8:	78 24                	js     8021ee <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ce:	8b 00                	mov    (%rax),%eax
  8021d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d4:	48 89 d6             	mov    %rdx,%rsi
  8021d7:	89 c7                	mov    %eax,%edi
  8021d9:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	callq  *%rax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ec:	79 05                	jns    8021f3 <write+0x5d>
		return r;
  8021ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f1:	eb 75                	jmp    802268 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f7:	8b 40 08             	mov    0x8(%rax),%eax
  8021fa:	83 e0 03             	and    $0x3,%eax
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	75 3a                	jne    80223b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802201:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802208:	00 00 00 
  80220b:	48 8b 00             	mov    (%rax),%rax
  80220e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802214:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802217:	89 c6                	mov    %eax,%esi
  802219:	48 bf 33 46 80 00 00 	movabs $0x804633,%rdi
  802220:	00 00 00 
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  80222f:	00 00 00 
  802232:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802234:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802239:	eb 2d                	jmp    802268 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80223b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802243:	48 85 c0             	test   %rax,%rax
  802246:	75 07                	jne    80224f <write+0xb9>
		return -E_NOT_SUPP;
  802248:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80224d:	eb 19                	jmp    802268 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80224f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802253:	48 8b 40 18          	mov    0x18(%rax),%rax
  802257:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80225b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80225f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802263:	48 89 cf             	mov    %rcx,%rdi
  802266:	ff d0                	callq  *%rax
}
  802268:	c9                   	leaveq 
  802269:	c3                   	retq   

000000000080226a <seek>:

int
seek(int fdnum, off_t offset)
{
  80226a:	55                   	push   %rbp
  80226b:	48 89 e5             	mov    %rsp,%rbp
  80226e:	48 83 ec 18          	sub    $0x18,%rsp
  802272:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802275:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802278:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80227c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80227f:	48 89 d6             	mov    %rdx,%rsi
  802282:	89 c7                	mov    %eax,%edi
  802284:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax
  802290:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802297:	79 05                	jns    80229e <seek+0x34>
		return r;
  802299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229c:	eb 0f                	jmp    8022ad <seek+0x43>
	fd->fd_offset = offset;
  80229e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022a5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8022a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ad:	c9                   	leaveq 
  8022ae:	c3                   	retq   

00000000008022af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022af:	55                   	push   %rbp
  8022b0:	48 89 e5             	mov    %rsp,%rbp
  8022b3:	48 83 ec 30          	sub    $0x30,%rsp
  8022b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ba:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022bd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c4:	48 89 d6             	mov    %rdx,%rsi
  8022c7:	89 c7                	mov    %eax,%edi
  8022c9:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022dc:	78 24                	js     802302 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e2:	8b 00                	mov    (%rax),%eax
  8022e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022e8:	48 89 d6             	mov    %rdx,%rsi
  8022eb:	89 c7                	mov    %eax,%edi
  8022ed:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
  8022f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802300:	79 05                	jns    802307 <ftruncate+0x58>
		return r;
  802302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802305:	eb 72                	jmp    802379 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230b:	8b 40 08             	mov    0x8(%rax),%eax
  80230e:	83 e0 03             	and    $0x3,%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	75 3a                	jne    80234f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802315:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80231c:	00 00 00 
  80231f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802322:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802328:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80232b:	89 c6                	mov    %eax,%esi
  80232d:	48 bf 50 46 80 00 00 	movabs $0x804650,%rdi
  802334:	00 00 00 
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
  80233c:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  802343:	00 00 00 
  802346:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802348:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80234d:	eb 2a                	jmp    802379 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80234f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802353:	48 8b 40 30          	mov    0x30(%rax),%rax
  802357:	48 85 c0             	test   %rax,%rax
  80235a:	75 07                	jne    802363 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80235c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802361:	eb 16                	jmp    802379 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802367:	48 8b 40 30          	mov    0x30(%rax),%rax
  80236b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80236f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802372:	89 ce                	mov    %ecx,%esi
  802374:	48 89 d7             	mov    %rdx,%rdi
  802377:	ff d0                	callq  *%rax
}
  802379:	c9                   	leaveq 
  80237a:	c3                   	retq   

000000000080237b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80237b:	55                   	push   %rbp
  80237c:	48 89 e5             	mov    %rsp,%rbp
  80237f:	48 83 ec 30          	sub    $0x30,%rsp
  802383:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802386:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80238e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802391:	48 89 d6             	mov    %rdx,%rsi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	78 24                	js     8023cf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023af:	8b 00                	mov    (%rax),%eax
  8023b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b5:	48 89 d6             	mov    %rdx,%rsi
  8023b8:	89 c7                	mov    %eax,%edi
  8023ba:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
  8023c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cd:	79 05                	jns    8023d4 <fstat+0x59>
		return r;
  8023cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d2:	eb 5e                	jmp    802432 <fstat+0xb7>
	if (!dev->dev_stat)
  8023d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023dc:	48 85 c0             	test   %rax,%rax
  8023df:	75 07                	jne    8023e8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023e6:	eb 4a                	jmp    802432 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023ec:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023fa:	00 00 00 
	stat->st_isdir = 0;
  8023fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802401:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802408:	00 00 00 
	stat->st_dev = dev;
  80240b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80240f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802413:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80241a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802422:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802426:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80242a:	48 89 ce             	mov    %rcx,%rsi
  80242d:	48 89 d7             	mov    %rdx,%rdi
  802430:	ff d0                	callq  *%rax
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 20          	sub    $0x20,%rsp
  80243c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802440:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802448:	be 00 00 00 00       	mov    $0x0,%esi
  80244d:	48 89 c7             	mov    %rax,%rdi
  802450:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
  80245c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802463:	79 05                	jns    80246a <stat+0x36>
		return fd;
  802465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802468:	eb 2f                	jmp    802499 <stat+0x65>
	r = fstat(fd, stat);
  80246a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80246e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802471:	48 89 d6             	mov    %rdx,%rsi
  802474:	89 c7                	mov    %eax,%edi
  802476:	48 b8 7b 23 80 00 00 	movabs $0x80237b,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802488:	89 c7                	mov    %eax,%edi
  80248a:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax
	return r;
  802496:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802499:	c9                   	leaveq 
  80249a:	c3                   	retq   

000000000080249b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80249b:	55                   	push   %rbp
  80249c:	48 89 e5             	mov    %rsp,%rbp
  80249f:	48 83 ec 10          	sub    $0x10,%rsp
  8024a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024aa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024b1:	00 00 00 
  8024b4:	8b 00                	mov    (%rax),%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	75 1f                	jne    8024d9 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024ba:	bf 01 00 00 00       	mov    $0x1,%edi
  8024bf:	48 b8 bf 3f 80 00 00 	movabs $0x803fbf,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
  8024cb:	89 c2                	mov    %eax,%edx
  8024cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024d4:	00 00 00 
  8024d7:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024d9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024e0:	00 00 00 
  8024e3:	8b 00                	mov    (%rax),%eax
  8024e5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024e8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024ed:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024f4:	00 00 00 
  8024f7:	89 c7                	mov    %eax,%edi
  8024f9:	48 b8 b3 3d 80 00 00 	movabs $0x803db3,%rax
  802500:	00 00 00 
  802503:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802509:	ba 00 00 00 00       	mov    $0x0,%edx
  80250e:	48 89 c6             	mov    %rax,%rsi
  802511:	bf 00 00 00 00       	mov    $0x0,%edi
  802516:	48 b8 f2 3c 80 00 00 	movabs $0x803cf2,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
}
  802522:	c9                   	leaveq 
  802523:	c3                   	retq   

0000000000802524 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802524:	55                   	push   %rbp
  802525:	48 89 e5             	mov    %rsp,%rbp
  802528:	48 83 ec 20          	sub    $0x20,%rsp
  80252c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802530:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802537:	48 89 c7             	mov    %rax,%rdi
  80253a:	48 b8 92 0d 80 00 00 	movabs $0x800d92,%rax
  802541:	00 00 00 
  802544:	ff d0                	callq  *%rax
  802546:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80254b:	7e 0a                	jle    802557 <open+0x33>
		return -E_BAD_PATH;
  80254d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802552:	e9 a5 00 00 00       	jmpq   8025fc <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802557:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80255b:	48 89 c7             	mov    %rax,%rdi
  80255e:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  802565:	00 00 00 
  802568:	ff d0                	callq  *%rax
  80256a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802571:	79 08                	jns    80257b <open+0x57>
		return r;
  802573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802576:	e9 81 00 00 00       	jmpq   8025fc <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80257b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257f:	48 89 c6             	mov    %rax,%rsi
  802582:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802589:	00 00 00 
  80258c:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802598:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80259f:	00 00 00 
  8025a2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8025a5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025af:	48 89 c6             	mov    %rax,%rsi
  8025b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b7:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
  8025c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ca:	79 1d                	jns    8025e9 <open+0xc5>
		fd_close(fd, 0);
  8025cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d0:	be 00 00 00 00       	mov    $0x0,%esi
  8025d5:	48 89 c7             	mov    %rax,%rdi
  8025d8:	48 b8 a6 1c 80 00 00 	movabs $0x801ca6,%rax
  8025df:	00 00 00 
  8025e2:	ff d0                	callq  *%rax
		return r;
  8025e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e7:	eb 13                	jmp    8025fc <open+0xd8>
	}

	return fd2num(fd);
  8025e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ed:	48 89 c7             	mov    %rax,%rdi
  8025f0:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	callq  *%rax

}
  8025fc:	c9                   	leaveq 
  8025fd:	c3                   	retq   

00000000008025fe <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025fe:	55                   	push   %rbp
  8025ff:	48 89 e5             	mov    %rsp,%rbp
  802602:	48 83 ec 10          	sub    $0x10,%rsp
  802606:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80260a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260e:	8b 50 0c             	mov    0xc(%rax),%edx
  802611:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802618:	00 00 00 
  80261b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80261d:	be 00 00 00 00       	mov    $0x0,%esi
  802622:	bf 06 00 00 00       	mov    $0x6,%edi
  802627:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
}
  802633:	c9                   	leaveq 
  802634:	c3                   	retq   

0000000000802635 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802635:	55                   	push   %rbp
  802636:	48 89 e5             	mov    %rsp,%rbp
  802639:	48 83 ec 30          	sub    $0x30,%rsp
  80263d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802641:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802645:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264d:	8b 50 0c             	mov    0xc(%rax),%edx
  802650:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802657:	00 00 00 
  80265a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80265c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802663:	00 00 00 
  802666:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80266a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80266e:	be 00 00 00 00       	mov    $0x0,%esi
  802673:	bf 03 00 00 00       	mov    $0x3,%edi
  802678:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  80267f:	00 00 00 
  802682:	ff d0                	callq  *%rax
  802684:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802687:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268b:	79 08                	jns    802695 <devfile_read+0x60>
		return r;
  80268d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802690:	e9 a4 00 00 00       	jmpq   802739 <devfile_read+0x104>
	assert(r <= n);
  802695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802698:	48 98                	cltq   
  80269a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80269e:	76 35                	jbe    8026d5 <devfile_read+0xa0>
  8026a0:	48 b9 76 46 80 00 00 	movabs $0x804676,%rcx
  8026a7:	00 00 00 
  8026aa:	48 ba 7d 46 80 00 00 	movabs $0x80467d,%rdx
  8026b1:	00 00 00 
  8026b4:	be 86 00 00 00       	mov    $0x86,%esi
  8026b9:	48 bf 92 46 80 00 00 	movabs $0x804692,%rdi
  8026c0:	00 00 00 
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  8026cf:	00 00 00 
  8026d2:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8026d5:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8026dc:	7e 35                	jle    802713 <devfile_read+0xde>
  8026de:	48 b9 9d 46 80 00 00 	movabs $0x80469d,%rcx
  8026e5:	00 00 00 
  8026e8:	48 ba 7d 46 80 00 00 	movabs $0x80467d,%rdx
  8026ef:	00 00 00 
  8026f2:	be 87 00 00 00       	mov    $0x87,%esi
  8026f7:	48 bf 92 46 80 00 00 	movabs $0x804692,%rdi
  8026fe:	00 00 00 
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  80270d:	00 00 00 
  802710:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802716:	48 63 d0             	movslq %eax,%rdx
  802719:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80271d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802724:	00 00 00 
  802727:	48 89 c7             	mov    %rax,%rdi
  80272a:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  802731:	00 00 00 
  802734:	ff d0                	callq  *%rax
	return r;
  802736:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802739:	c9                   	leaveq 
  80273a:	c3                   	retq   

000000000080273b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80273b:	55                   	push   %rbp
  80273c:	48 89 e5             	mov    %rsp,%rbp
  80273f:	48 83 ec 40          	sub    $0x40,%rsp
  802743:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802747:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80274b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80274f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802753:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802757:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80275e:	00 
  80275f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802763:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802767:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80276c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802774:	8b 50 0c             	mov    0xc(%rax),%edx
  802777:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80277e:	00 00 00 
  802781:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802783:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80278a:	00 00 00 
  80278d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802791:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802795:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802799:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80279d:	48 89 c6             	mov    %rax,%rsi
  8027a0:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8027a7:	00 00 00 
  8027aa:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8027b6:	be 00 00 00 00       	mov    $0x0,%esi
  8027bb:	bf 04 00 00 00       	mov    $0x4,%edi
  8027c0:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	callq  *%rax
  8027cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027d3:	79 05                	jns    8027da <devfile_write+0x9f>
		return r;
  8027d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d8:	eb 43                	jmp    80281d <devfile_write+0xe2>
	assert(r <= n);
  8027da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027dd:	48 98                	cltq   
  8027df:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8027e3:	76 35                	jbe    80281a <devfile_write+0xdf>
  8027e5:	48 b9 76 46 80 00 00 	movabs $0x804676,%rcx
  8027ec:	00 00 00 
  8027ef:	48 ba 7d 46 80 00 00 	movabs $0x80467d,%rdx
  8027f6:	00 00 00 
  8027f9:	be a2 00 00 00       	mov    $0xa2,%esi
  8027fe:	48 bf 92 46 80 00 00 	movabs $0x804692,%rdi
  802805:	00 00 00 
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  802814:	00 00 00 
  802817:	41 ff d0             	callq  *%r8
	return r;
  80281a:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80281d:	c9                   	leaveq 
  80281e:	c3                   	retq   

000000000080281f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80281f:	55                   	push   %rbp
  802820:	48 89 e5             	mov    %rsp,%rbp
  802823:	48 83 ec 20          	sub    $0x20,%rsp
  802827:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80282b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80282f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802833:	8b 50 0c             	mov    0xc(%rax),%edx
  802836:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80283d:	00 00 00 
  802840:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802842:	be 00 00 00 00       	mov    $0x0,%esi
  802847:	bf 05 00 00 00       	mov    $0x5,%edi
  80284c:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  802853:	00 00 00 
  802856:	ff d0                	callq  *%rax
  802858:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285f:	79 05                	jns    802866 <devfile_stat+0x47>
		return r;
  802861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802864:	eb 56                	jmp    8028bc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80286a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802871:	00 00 00 
  802874:	48 89 c7             	mov    %rax,%rdi
  802877:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802883:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80288a:	00 00 00 
  80288d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802893:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802897:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80289d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028a4:	00 00 00 
  8028a7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028bc:	c9                   	leaveq 
  8028bd:	c3                   	retq   

00000000008028be <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028be:	55                   	push   %rbp
  8028bf:	48 89 e5             	mov    %rsp,%rbp
  8028c2:	48 83 ec 10          	sub    $0x10,%rsp
  8028c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d1:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028db:	00 00 00 
  8028de:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028e0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e7:	00 00 00 
  8028ea:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028ed:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028f0:	be 00 00 00 00       	mov    $0x0,%esi
  8028f5:	bf 02 00 00 00       	mov    $0x2,%edi
  8028fa:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  802901:	00 00 00 
  802904:	ff d0                	callq  *%rax
}
  802906:	c9                   	leaveq 
  802907:	c3                   	retq   

0000000000802908 <remove>:

// Delete a file
int
remove(const char *path)
{
  802908:	55                   	push   %rbp
  802909:	48 89 e5             	mov    %rsp,%rbp
  80290c:	48 83 ec 10          	sub    $0x10,%rsp
  802910:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802918:	48 89 c7             	mov    %rax,%rdi
  80291b:	48 b8 92 0d 80 00 00 	movabs $0x800d92,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
  802927:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80292c:	7e 07                	jle    802935 <remove+0x2d>
		return -E_BAD_PATH;
  80292e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802933:	eb 33                	jmp    802968 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802935:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802939:	48 89 c6             	mov    %rax,%rsi
  80293c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802943:	00 00 00 
  802946:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  80294d:	00 00 00 
  802950:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802952:	be 00 00 00 00       	mov    $0x0,%esi
  802957:	bf 07 00 00 00       	mov    $0x7,%edi
  80295c:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  802963:	00 00 00 
  802966:	ff d0                	callq  *%rax
}
  802968:	c9                   	leaveq 
  802969:	c3                   	retq   

000000000080296a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80296a:	55                   	push   %rbp
  80296b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80296e:	be 00 00 00 00       	mov    $0x0,%esi
  802973:	bf 08 00 00 00       	mov    $0x8,%edi
  802978:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
}
  802984:	5d                   	pop    %rbp
  802985:	c3                   	retq   

0000000000802986 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802986:	55                   	push   %rbp
  802987:	48 89 e5             	mov    %rsp,%rbp
  80298a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802991:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802998:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80299f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029a6:	be 00 00 00 00       	mov    $0x0,%esi
  8029ab:	48 89 c7             	mov    %rax,%rdi
  8029ae:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8029bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c1:	79 28                	jns    8029eb <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8029c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c6:	89 c6                	mov    %eax,%esi
  8029c8:	48 bf a9 46 80 00 00 	movabs $0x8046a9,%rdi
  8029cf:	00 00 00 
  8029d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d7:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  8029de:	00 00 00 
  8029e1:	ff d2                	callq  *%rdx
		return fd_src;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e6:	e9 76 01 00 00       	jmpq   802b61 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8029eb:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8029f2:	be 01 01 00 00       	mov    $0x101,%esi
  8029f7:	48 89 c7             	mov    %rax,%rdi
  8029fa:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  802a01:	00 00 00 
  802a04:	ff d0                	callq  *%rax
  802a06:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a09:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a0d:	0f 89 ad 00 00 00    	jns    802ac0 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a16:	89 c6                	mov    %eax,%esi
  802a18:	48 bf bf 46 80 00 00 	movabs $0x8046bf,%rdi
  802a1f:	00 00 00 
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802a2e:	00 00 00 
  802a31:	ff d2                	callq  *%rdx
		close(fd_src);
  802a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a36:	89 c7                	mov    %eax,%edi
  802a38:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	callq  *%rax
		return fd_dest;
  802a44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a47:	e9 15 01 00 00       	jmpq   802b61 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802a4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a4f:	48 63 d0             	movslq %eax,%rdx
  802a52:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a5c:	48 89 ce             	mov    %rcx,%rsi
  802a5f:	89 c7                	mov    %eax,%edi
  802a61:	48 b8 96 21 80 00 00 	movabs $0x802196,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
  802a6d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a70:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a74:	79 4a                	jns    802ac0 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802a76:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a79:	89 c6                	mov    %eax,%esi
  802a7b:	48 bf d9 46 80 00 00 	movabs $0x8046d9,%rdi
  802a82:	00 00 00 
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802a91:	00 00 00 
  802a94:	ff d2                	callq  *%rdx
			close(fd_src);
  802a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a99:	89 c7                	mov    %eax,%edi
  802a9b:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802aa2:	00 00 00 
  802aa5:	ff d0                	callq  *%rax
			close(fd_dest);
  802aa7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aaa:	89 c7                	mov    %eax,%edi
  802aac:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802ab3:	00 00 00 
  802ab6:	ff d0                	callq  *%rax
			return write_size;
  802ab8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802abb:	e9 a1 00 00 00       	jmpq   802b61 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ac0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ac7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aca:	ba 00 02 00 00       	mov    $0x200,%edx
  802acf:	48 89 ce             	mov    %rcx,%rsi
  802ad2:	89 c7                	mov    %eax,%edi
  802ad4:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
  802ae0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ae7:	0f 8f 5f ff ff ff    	jg     802a4c <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802af1:	79 47                	jns    802b3a <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802af3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802af6:	89 c6                	mov    %eax,%esi
  802af8:	48 bf ec 46 80 00 00 	movabs $0x8046ec,%rdi
  802aff:	00 00 00 
  802b02:	b8 00 00 00 00       	mov    $0x0,%eax
  802b07:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802b0e:	00 00 00 
  802b11:	ff d2                	callq  *%rdx
		close(fd_src);
  802b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b16:	89 c7                	mov    %eax,%edi
  802b18:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802b1f:	00 00 00 
  802b22:	ff d0                	callq  *%rax
		close(fd_dest);
  802b24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b27:	89 c7                	mov    %eax,%edi
  802b29:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802b30:	00 00 00 
  802b33:	ff d0                	callq  *%rax
		return read_size;
  802b35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b38:	eb 27                	jmp    802b61 <copy+0x1db>
	}
	close(fd_src);
  802b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3d:	89 c7                	mov    %eax,%edi
  802b3f:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax
	close(fd_dest);
  802b4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b4e:	89 c7                	mov    %eax,%edi
  802b50:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
	return 0;
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b61:	c9                   	leaveq 
  802b62:	c3                   	retq   

0000000000802b63 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802b63:	55                   	push   %rbp
  802b64:	48 89 e5             	mov    %rsp,%rbp
  802b67:	48 83 ec 20          	sub    $0x20,%rsp
  802b6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802b6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b75:	48 89 d6             	mov    %rdx,%rsi
  802b78:	89 c7                	mov    %eax,%edi
  802b7a:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	callq  *%rax
  802b86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8d:	79 05                	jns    802b94 <fd2sockid+0x31>
		return r;
  802b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b92:	eb 24                	jmp    802bb8 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b98:	8b 10                	mov    (%rax),%edx
  802b9a:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ba1:	00 00 00 
  802ba4:	8b 00                	mov    (%rax),%eax
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	74 07                	je     802bb1 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802baa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802baf:	eb 07                	jmp    802bb8 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb5:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802bb8:	c9                   	leaveq 
  802bb9:	c3                   	retq   

0000000000802bba <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802bba:	55                   	push   %rbp
  802bbb:	48 89 e5             	mov    %rsp,%rbp
  802bbe:	48 83 ec 20          	sub    $0x20,%rsp
  802bc2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802bc5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802bc9:	48 89 c7             	mov    %rax,%rdi
  802bcc:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
  802bd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdf:	78 26                	js     802c07 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802be1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be5:	ba 07 04 00 00       	mov    $0x407,%edx
  802bea:	48 89 c6             	mov    %rax,%rsi
  802bed:	bf 00 00 00 00       	mov    $0x0,%edi
  802bf2:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	callq  *%rax
  802bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c05:	79 16                	jns    802c1d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802c07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c0a:	89 c7                	mov    %eax,%edi
  802c0c:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
		return r;
  802c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1b:	eb 3a                	jmp    802c57 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c21:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802c28:	00 00 00 
  802c2b:	8b 12                	mov    (%rdx),%edx
  802c2d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802c2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802c3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c41:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c48:	48 89 c7             	mov    %rax,%rdi
  802c4b:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  802c52:	00 00 00 
  802c55:	ff d0                	callq  *%rax
}
  802c57:	c9                   	leaveq 
  802c58:	c3                   	retq   

0000000000802c59 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c59:	55                   	push   %rbp
  802c5a:	48 89 e5             	mov    %rsp,%rbp
  802c5d:	48 83 ec 30          	sub    $0x30,%rsp
  802c61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c6f:	89 c7                	mov    %eax,%edi
  802c71:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  802c78:	00 00 00 
  802c7b:	ff d0                	callq  *%rax
  802c7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c84:	79 05                	jns    802c8b <accept+0x32>
		return r;
  802c86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c89:	eb 3b                	jmp    802cc6 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c8b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c8f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c96:	48 89 ce             	mov    %rcx,%rsi
  802c99:	89 c7                	mov    %eax,%edi
  802c9b:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  802ca2:	00 00 00 
  802ca5:	ff d0                	callq  *%rax
  802ca7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802caa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cae:	79 05                	jns    802cb5 <accept+0x5c>
		return r;
  802cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb3:	eb 11                	jmp    802cc6 <accept+0x6d>
	return alloc_sockfd(r);
  802cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb8:	89 c7                	mov    %eax,%edi
  802cba:	48 b8 ba 2b 80 00 00 	movabs $0x802bba,%rax
  802cc1:	00 00 00 
  802cc4:	ff d0                	callq  *%rax
}
  802cc6:	c9                   	leaveq 
  802cc7:	c3                   	retq   

0000000000802cc8 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 20          	sub    $0x20,%rsp
  802cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cdd:	89 c7                	mov    %eax,%edi
  802cdf:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
  802ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf2:	79 05                	jns    802cf9 <bind+0x31>
		return r;
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	eb 1b                	jmp    802d14 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802cf9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cfc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d03:	48 89 ce             	mov    %rcx,%rsi
  802d06:	89 c7                	mov    %eax,%edi
  802d08:	48 b8 25 30 80 00 00 	movabs $0x803025,%rax
  802d0f:	00 00 00 
  802d12:	ff d0                	callq  *%rax
}
  802d14:	c9                   	leaveq 
  802d15:	c3                   	retq   

0000000000802d16 <shutdown>:

int
shutdown(int s, int how)
{
  802d16:	55                   	push   %rbp
  802d17:	48 89 e5             	mov    %rsp,%rbp
  802d1a:	48 83 ec 20          	sub    $0x20,%rsp
  802d1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d21:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3c:	79 05                	jns    802d43 <shutdown+0x2d>
		return r;
  802d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d41:	eb 16                	jmp    802d59 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802d43:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d49:	89 d6                	mov    %edx,%esi
  802d4b:	89 c7                	mov    %eax,%edi
  802d4d:	48 b8 89 30 80 00 00 	movabs $0x803089,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
}
  802d59:	c9                   	leaveq 
  802d5a:	c3                   	retq   

0000000000802d5b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802d5b:	55                   	push   %rbp
  802d5c:	48 89 e5             	mov    %rsp,%rbp
  802d5f:	48 83 ec 10          	sub    $0x10,%rsp
  802d63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d6b:	48 89 c7             	mov    %rax,%rdi
  802d6e:	48 b8 30 40 80 00 00 	movabs $0x804030,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	callq  *%rax
  802d7a:	83 f8 01             	cmp    $0x1,%eax
  802d7d:	75 17                	jne    802d96 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d83:	8b 40 0c             	mov    0xc(%rax),%eax
  802d86:	89 c7                	mov    %eax,%edi
  802d88:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  802d8f:	00 00 00 
  802d92:	ff d0                	callq  *%rax
  802d94:	eb 05                	jmp    802d9b <devsock_close+0x40>
	else
		return 0;
  802d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9b:	c9                   	leaveq 
  802d9c:	c3                   	retq   

0000000000802d9d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d9d:	55                   	push   %rbp
  802d9e:	48 89 e5             	mov    %rsp,%rbp
  802da1:	48 83 ec 20          	sub    $0x20,%rsp
  802da5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802da8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dac:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802daf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802db2:	89 c7                	mov    %eax,%edi
  802db4:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
  802dc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc7:	79 05                	jns    802dce <connect+0x31>
		return r;
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	eb 1b                	jmp    802de9 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802dce:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802dd1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd8:	48 89 ce             	mov    %rcx,%rsi
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 f6 30 80 00 00 	movabs $0x8030f6,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
}
  802de9:	c9                   	leaveq 
  802dea:	c3                   	retq   

0000000000802deb <listen>:

int
listen(int s, int backlog)
{
  802deb:	55                   	push   %rbp
  802dec:	48 89 e5             	mov    %rsp,%rbp
  802def:	48 83 ec 20          	sub    $0x20,%rsp
  802df3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802df6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802df9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
  802e0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e11:	79 05                	jns    802e18 <listen+0x2d>
		return r;
  802e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e16:	eb 16                	jmp    802e2e <listen+0x43>
	return nsipc_listen(r, backlog);
  802e18:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1e:	89 d6                	mov    %edx,%esi
  802e20:	89 c7                	mov    %eax,%edi
  802e22:	48 b8 5a 31 80 00 00 	movabs $0x80315a,%rax
  802e29:	00 00 00 
  802e2c:	ff d0                	callq  *%rax
}
  802e2e:	c9                   	leaveq 
  802e2f:	c3                   	retq   

0000000000802e30 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802e30:	55                   	push   %rbp
  802e31:	48 89 e5             	mov    %rsp,%rbp
  802e34:	48 83 ec 20          	sub    $0x20,%rsp
  802e38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e40:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e48:	89 c2                	mov    %eax,%edx
  802e4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4e:	8b 40 0c             	mov    0xc(%rax),%eax
  802e51:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e55:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e5a:	89 c7                	mov    %eax,%edi
  802e5c:	48 b8 9a 31 80 00 00 	movabs $0x80319a,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
}
  802e68:	c9                   	leaveq 
  802e69:	c3                   	retq   

0000000000802e6a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802e6a:	55                   	push   %rbp
  802e6b:	48 89 e5             	mov    %rsp,%rbp
  802e6e:	48 83 ec 20          	sub    $0x20,%rsp
  802e72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	89 c2                	mov    %eax,%edx
  802e84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e88:	8b 40 0c             	mov    0xc(%rax),%eax
  802e8b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e94:	89 c7                	mov    %eax,%edi
  802e96:	48 b8 66 32 80 00 00 	movabs $0x803266,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
}
  802ea2:	c9                   	leaveq 
  802ea3:	c3                   	retq   

0000000000802ea4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802ea4:	55                   	push   %rbp
  802ea5:	48 89 e5             	mov    %rsp,%rbp
  802ea8:	48 83 ec 10          	sub    $0x10,%rsp
  802eac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb8:	48 be 07 47 80 00 00 	movabs $0x804707,%rsi
  802ebf:	00 00 00 
  802ec2:	48 89 c7             	mov    %rax,%rdi
  802ec5:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
	return 0;
  802ed1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed6:	c9                   	leaveq 
  802ed7:	c3                   	retq   

0000000000802ed8 <socket>:

int
socket(int domain, int type, int protocol)
{
  802ed8:	55                   	push   %rbp
  802ed9:	48 89 e5             	mov    %rsp,%rbp
  802edc:	48 83 ec 20          	sub    $0x20,%rsp
  802ee0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802ee6:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802ee9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802eec:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802eef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef2:	89 ce                	mov    %ecx,%esi
  802ef4:	89 c7                	mov    %eax,%edi
  802ef6:	48 b8 1e 33 80 00 00 	movabs $0x80331e,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
  802f02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f09:	79 05                	jns    802f10 <socket+0x38>
		return r;
  802f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0e:	eb 11                	jmp    802f21 <socket+0x49>
	return alloc_sockfd(r);
  802f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f13:	89 c7                	mov    %eax,%edi
  802f15:	48 b8 ba 2b 80 00 00 	movabs $0x802bba,%rax
  802f1c:	00 00 00 
  802f1f:	ff d0                	callq  *%rax
}
  802f21:	c9                   	leaveq 
  802f22:	c3                   	retq   

0000000000802f23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802f23:	55                   	push   %rbp
  802f24:	48 89 e5             	mov    %rsp,%rbp
  802f27:	48 83 ec 10          	sub    $0x10,%rsp
  802f2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802f2e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f35:	00 00 00 
  802f38:	8b 00                	mov    (%rax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	75 1f                	jne    802f5d <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802f3e:	bf 02 00 00 00       	mov    $0x2,%edi
  802f43:	48 b8 bf 3f 80 00 00 	movabs $0x803fbf,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	89 c2                	mov    %eax,%edx
  802f51:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f58:	00 00 00 
  802f5b:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802f5d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802f64:	00 00 00 
  802f67:	8b 00                	mov    (%rax),%eax
  802f69:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f6c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f71:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802f78:	00 00 00 
  802f7b:	89 c7                	mov    %eax,%edi
  802f7d:	48 b8 b3 3d 80 00 00 	movabs $0x803db3,%rax
  802f84:	00 00 00 
  802f87:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802f89:	ba 00 00 00 00       	mov    $0x0,%edx
  802f8e:	be 00 00 00 00       	mov    $0x0,%esi
  802f93:	bf 00 00 00 00       	mov    $0x0,%edi
  802f98:	48 b8 f2 3c 80 00 00 	movabs $0x803cf2,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
}
  802fa4:	c9                   	leaveq 
  802fa5:	c3                   	retq   

0000000000802fa6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
  802faa:	48 83 ec 30          	sub    $0x30,%rsp
  802fae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802fb9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fc0:	00 00 00 
  802fc3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fc6:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802fc8:	bf 01 00 00 00       	mov    $0x1,%edi
  802fcd:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
  802fd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe0:	78 3e                	js     803020 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802fe2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fe9:	00 00 00 
  802fec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff4:	8b 40 10             	mov    0x10(%rax),%eax
  802ff7:	89 c2                	mov    %eax,%edx
  802ff9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802ffd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803001:	48 89 ce             	mov    %rcx,%rsi
  803004:	48 89 c7             	mov    %rax,%rdi
  803007:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803017:	8b 50 10             	mov    0x10(%rax),%edx
  80301a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80301e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803020:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803023:	c9                   	leaveq 
  803024:	c3                   	retq   

0000000000803025 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803025:	55                   	push   %rbp
  803026:	48 89 e5             	mov    %rsp,%rbp
  803029:	48 83 ec 10          	sub    $0x10,%rsp
  80302d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803030:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803034:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803037:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80303e:	00 00 00 
  803041:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803044:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803046:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803049:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304d:	48 89 c6             	mov    %rax,%rsi
  803050:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803057:	00 00 00 
  80305a:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803066:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80306d:	00 00 00 
  803070:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803073:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803076:	bf 02 00 00 00       	mov    $0x2,%edi
  80307b:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
}
  803087:	c9                   	leaveq 
  803088:	c3                   	retq   

0000000000803089 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803089:	55                   	push   %rbp
  80308a:	48 89 e5             	mov    %rsp,%rbp
  80308d:	48 83 ec 10          	sub    $0x10,%rsp
  803091:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803094:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803097:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80309e:	00 00 00 
  8030a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030a4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8030a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030ad:	00 00 00 
  8030b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030b3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8030b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8030bb:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
}
  8030c7:	c9                   	leaveq 
  8030c8:	c3                   	retq   

00000000008030c9 <nsipc_close>:

int
nsipc_close(int s)
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	48 83 ec 10          	sub    $0x10,%rsp
  8030d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8030d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030db:	00 00 00 
  8030de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030e1:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8030e3:	bf 04 00 00 00       	mov    $0x4,%edi
  8030e8:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
}
  8030f4:	c9                   	leaveq 
  8030f5:	c3                   	retq   

00000000008030f6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030f6:	55                   	push   %rbp
  8030f7:	48 89 e5             	mov    %rsp,%rbp
  8030fa:	48 83 ec 10          	sub    $0x10,%rsp
  8030fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803101:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803105:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803108:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80310f:	00 00 00 
  803112:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803115:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803117:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80311a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311e:	48 89 c6             	mov    %rax,%rsi
  803121:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803128:	00 00 00 
  80312b:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803137:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80313e:	00 00 00 
  803141:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803144:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803147:	bf 05 00 00 00       	mov    $0x5,%edi
  80314c:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  803153:	00 00 00 
  803156:	ff d0                	callq  *%rax
}
  803158:	c9                   	leaveq 
  803159:	c3                   	retq   

000000000080315a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80315a:	55                   	push   %rbp
  80315b:	48 89 e5             	mov    %rsp,%rbp
  80315e:	48 83 ec 10          	sub    $0x10,%rsp
  803162:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803165:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803168:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80316f:	00 00 00 
  803172:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803175:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803177:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80317e:	00 00 00 
  803181:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803184:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803187:	bf 06 00 00 00       	mov    $0x6,%edi
  80318c:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  803193:	00 00 00 
  803196:	ff d0                	callq  *%rax
}
  803198:	c9                   	leaveq 
  803199:	c3                   	retq   

000000000080319a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80319a:	55                   	push   %rbp
  80319b:	48 89 e5             	mov    %rsp,%rbp
  80319e:	48 83 ec 30          	sub    $0x30,%rsp
  8031a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031a9:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8031ac:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8031af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031b6:	00 00 00 
  8031b9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031bc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8031be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031c5:	00 00 00 
  8031c8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8031ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d5:	00 00 00 
  8031d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031db:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8031de:	bf 07 00 00 00       	mov    $0x7,%edi
  8031e3:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
  8031ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f6:	78 69                	js     803261 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8031f8:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8031ff:	7f 08                	jg     803209 <nsipc_recv+0x6f>
  803201:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803204:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803207:	7e 35                	jle    80323e <nsipc_recv+0xa4>
  803209:	48 b9 0e 47 80 00 00 	movabs $0x80470e,%rcx
  803210:	00 00 00 
  803213:	48 ba 23 47 80 00 00 	movabs $0x804723,%rdx
  80321a:	00 00 00 
  80321d:	be 62 00 00 00       	mov    $0x62,%esi
  803222:	48 bf 38 47 80 00 00 	movabs $0x804738,%rdi
  803229:	00 00 00 
  80322c:	b8 00 00 00 00       	mov    $0x0,%eax
  803231:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  803238:	00 00 00 
  80323b:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80323e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803241:	48 63 d0             	movslq %eax,%rdx
  803244:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803248:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80324f:	00 00 00 
  803252:	48 89 c7             	mov    %rax,%rdi
  803255:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
	}

	return r;
  803261:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803264:	c9                   	leaveq 
  803265:	c3                   	retq   

0000000000803266 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803266:	55                   	push   %rbp
  803267:	48 89 e5             	mov    %rsp,%rbp
  80326a:	48 83 ec 20          	sub    $0x20,%rsp
  80326e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803271:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803275:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803278:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80327b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803282:	00 00 00 
  803285:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803288:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80328a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803291:	7e 35                	jle    8032c8 <nsipc_send+0x62>
  803293:	48 b9 44 47 80 00 00 	movabs $0x804744,%rcx
  80329a:	00 00 00 
  80329d:	48 ba 23 47 80 00 00 	movabs $0x804723,%rdx
  8032a4:	00 00 00 
  8032a7:	be 6d 00 00 00       	mov    $0x6d,%esi
  8032ac:	48 bf 38 47 80 00 00 	movabs $0x804738,%rdi
  8032b3:	00 00 00 
  8032b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bb:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  8032c2:	00 00 00 
  8032c5:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8032c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032cb:	48 63 d0             	movslq %eax,%rdx
  8032ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d2:	48 89 c6             	mov    %rax,%rsi
  8032d5:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8032dc:	00 00 00 
  8032df:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8032eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f2:	00 00 00 
  8032f5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032f8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8032fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803302:	00 00 00 
  803305:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803308:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80330b:	bf 08 00 00 00       	mov    $0x8,%edi
  803310:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
}
  80331c:	c9                   	leaveq 
  80331d:	c3                   	retq   

000000000080331e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80331e:	55                   	push   %rbp
  80331f:	48 89 e5             	mov    %rsp,%rbp
  803322:	48 83 ec 10          	sub    $0x10,%rsp
  803326:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803329:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80332c:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80332f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803336:	00 00 00 
  803339:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80333c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80333e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803345:	00 00 00 
  803348:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80334b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80334e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803355:	00 00 00 
  803358:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80335b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80335e:	bf 09 00 00 00       	mov    $0x9,%edi
  803363:	48 b8 23 2f 80 00 00 	movabs $0x802f23,%rax
  80336a:	00 00 00 
  80336d:	ff d0                	callq  *%rax
}
  80336f:	c9                   	leaveq 
  803370:	c3                   	retq   

0000000000803371 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803371:	55                   	push   %rbp
  803372:	48 89 e5             	mov    %rsp,%rbp
  803375:	53                   	push   %rbx
  803376:	48 83 ec 38          	sub    $0x38,%rsp
  80337a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80337e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803382:	48 89 c7             	mov    %rax,%rdi
  803385:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
  803391:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803394:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803398:	0f 88 bf 01 00 00    	js     80355d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80339e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8033a7:	48 89 c6             	mov    %rax,%rsi
  8033aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8033af:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033c2:	0f 88 95 01 00 00    	js     80355d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8033c8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033cc:	48 89 c7             	mov    %rax,%rdi
  8033cf:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033e2:	0f 88 5d 01 00 00    	js     803545 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ec:	ba 07 04 00 00       	mov    $0x407,%edx
  8033f1:	48 89 c6             	mov    %rax,%rsi
  8033f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f9:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
  803405:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803408:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80340c:	0f 88 33 01 00 00    	js     803545 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803416:	48 89 c7             	mov    %rax,%rdi
  803419:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
  803425:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803429:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80342d:	ba 07 04 00 00       	mov    $0x407,%edx
  803432:	48 89 c6             	mov    %rax,%rsi
  803435:	bf 00 00 00 00       	mov    $0x0,%edi
  80343a:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  803441:	00 00 00 
  803444:	ff d0                	callq  *%rax
  803446:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803449:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80344d:	0f 88 d9 00 00 00    	js     80352c <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803453:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803457:	48 89 c7             	mov    %rax,%rdi
  80345a:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	48 89 c2             	mov    %rax,%rdx
  803469:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803473:	48 89 d1             	mov    %rdx,%rcx
  803476:	ba 00 00 00 00       	mov    $0x0,%edx
  80347b:	48 89 c6             	mov    %rax,%rsi
  80347e:	bf 00 00 00 00       	mov    $0x0,%edi
  803483:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
  80348f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803492:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803496:	78 79                	js     803511 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8034a3:	00 00 00 
  8034a6:	8b 12                	mov    (%rdx),%edx
  8034a8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8034aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8034b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b9:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8034c0:	00 00 00 
  8034c3:	8b 12                	mov    (%rdx),%edx
  8034c5:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8034c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8034d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034d6:	48 89 c7             	mov    %rax,%rdi
  8034d9:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
  8034e5:	89 c2                	mov    %eax,%edx
  8034e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034eb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034f1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8034f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034f9:	48 89 c7             	mov    %rax,%rdi
  8034fc:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
  803508:	89 03                	mov    %eax,(%rbx)
	return 0;
  80350a:	b8 00 00 00 00       	mov    $0x0,%eax
  80350f:	eb 4f                	jmp    803560 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803511:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803512:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803516:	48 89 c6             	mov    %rax,%rsi
  803519:	bf 00 00 00 00       	mov    $0x0,%edi
  80351e:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803525:	00 00 00 
  803528:	ff d0                	callq  *%rax
  80352a:	eb 01                	jmp    80352d <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80352c:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80352d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803531:	48 89 c6             	mov    %rax,%rsi
  803534:	bf 00 00 00 00       	mov    $0x0,%edi
  803539:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803549:	48 89 c6             	mov    %rax,%rsi
  80354c:	bf 00 00 00 00       	mov    $0x0,%edi
  803551:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
err:
	return r;
  80355d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803560:	48 83 c4 38          	add    $0x38,%rsp
  803564:	5b                   	pop    %rbx
  803565:	5d                   	pop    %rbp
  803566:	c3                   	retq   

0000000000803567 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803567:	55                   	push   %rbp
  803568:	48 89 e5             	mov    %rsp,%rbp
  80356b:	53                   	push   %rbx
  80356c:	48 83 ec 28          	sub    $0x28,%rsp
  803570:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803574:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803578:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80357f:	00 00 00 
  803582:	48 8b 00             	mov    (%rax),%rax
  803585:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80358b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80358e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803592:	48 89 c7             	mov    %rax,%rdi
  803595:	48 b8 30 40 80 00 00 	movabs $0x804030,%rax
  80359c:	00 00 00 
  80359f:	ff d0                	callq  *%rax
  8035a1:	89 c3                	mov    %eax,%ebx
  8035a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a7:	48 89 c7             	mov    %rax,%rdi
  8035aa:	48 b8 30 40 80 00 00 	movabs $0x804030,%rax
  8035b1:	00 00 00 
  8035b4:	ff d0                	callq  *%rax
  8035b6:	39 c3                	cmp    %eax,%ebx
  8035b8:	0f 94 c0             	sete   %al
  8035bb:	0f b6 c0             	movzbl %al,%eax
  8035be:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8035c1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8035c8:	00 00 00 
  8035cb:	48 8b 00             	mov    (%rax),%rax
  8035ce:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035d4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8035d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035da:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035dd:	75 05                	jne    8035e4 <_pipeisclosed+0x7d>
			return ret;
  8035df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035e2:	eb 4a                	jmp    80362e <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8035e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035ea:	74 8c                	je     803578 <_pipeisclosed+0x11>
  8035ec:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8035f0:	75 86                	jne    803578 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8035f9:	00 00 00 
  8035fc:	48 8b 00             	mov    (%rax),%rax
  8035ff:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803605:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803608:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80360b:	89 c6                	mov    %eax,%esi
  80360d:	48 bf 55 47 80 00 00 	movabs $0x804755,%rdi
  803614:	00 00 00 
  803617:	b8 00 00 00 00       	mov    $0x0,%eax
  80361c:	49 b8 6e 02 80 00 00 	movabs $0x80026e,%r8
  803623:	00 00 00 
  803626:	41 ff d0             	callq  *%r8
	}
  803629:	e9 4a ff ff ff       	jmpq   803578 <_pipeisclosed+0x11>

}
  80362e:	48 83 c4 28          	add    $0x28,%rsp
  803632:	5b                   	pop    %rbx
  803633:	5d                   	pop    %rbp
  803634:	c3                   	retq   

0000000000803635 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803635:	55                   	push   %rbp
  803636:	48 89 e5             	mov    %rsp,%rbp
  803639:	48 83 ec 30          	sub    $0x30,%rsp
  80363d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803640:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803644:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803647:	48 89 d6             	mov    %rdx,%rsi
  80364a:	89 c7                	mov    %eax,%edi
  80364c:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
  803658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80365b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365f:	79 05                	jns    803666 <pipeisclosed+0x31>
		return r;
  803661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803664:	eb 31                	jmp    803697 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366a:	48 89 c7             	mov    %rax,%rdi
  80366d:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803674:	00 00 00 
  803677:	ff d0                	callq  *%rax
  803679:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80367d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803681:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803685:	48 89 d6             	mov    %rdx,%rsi
  803688:	48 89 c7             	mov    %rax,%rdi
  80368b:	48 b8 67 35 80 00 00 	movabs $0x803567,%rax
  803692:	00 00 00 
  803695:	ff d0                	callq  *%rax
}
  803697:	c9                   	leaveq 
  803698:	c3                   	retq   

0000000000803699 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803699:	55                   	push   %rbp
  80369a:	48 89 e5             	mov    %rsp,%rbp
  80369d:	48 83 ec 40          	sub    $0x40,%rsp
  8036a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036a9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b1:	48 89 c7             	mov    %rax,%rdi
  8036b4:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
  8036c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036cc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036d3:	00 
  8036d4:	e9 90 00 00 00       	jmpq   803769 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8036d9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8036de:	74 09                	je     8036e9 <devpipe_read+0x50>
				return i;
  8036e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e4:	e9 8e 00 00 00       	jmpq   803777 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f1:	48 89 d6             	mov    %rdx,%rsi
  8036f4:	48 89 c7             	mov    %rax,%rdi
  8036f7:	48 b8 67 35 80 00 00 	movabs $0x803567,%rax
  8036fe:	00 00 00 
  803701:	ff d0                	callq  *%rax
  803703:	85 c0                	test   %eax,%eax
  803705:	74 07                	je     80370e <devpipe_read+0x75>
				return 0;
  803707:	b8 00 00 00 00       	mov    $0x0,%eax
  80370c:	eb 69                	jmp    803777 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80370e:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803715:	00 00 00 
  803718:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80371a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371e:	8b 10                	mov    (%rax),%edx
  803720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803724:	8b 40 04             	mov    0x4(%rax),%eax
  803727:	39 c2                	cmp    %eax,%edx
  803729:	74 ae                	je     8036d9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80372b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80372f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803733:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373b:	8b 00                	mov    (%rax),%eax
  80373d:	99                   	cltd   
  80373e:	c1 ea 1b             	shr    $0x1b,%edx
  803741:	01 d0                	add    %edx,%eax
  803743:	83 e0 1f             	and    $0x1f,%eax
  803746:	29 d0                	sub    %edx,%eax
  803748:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80374c:	48 98                	cltq   
  80374e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803753:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803759:	8b 00                	mov    (%rax),%eax
  80375b:	8d 50 01             	lea    0x1(%rax),%edx
  80375e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803762:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803764:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803771:	72 a7                	jb     80371a <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803777:	c9                   	leaveq 
  803778:	c3                   	retq   

0000000000803779 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803779:	55                   	push   %rbp
  80377a:	48 89 e5             	mov    %rsp,%rbp
  80377d:	48 83 ec 40          	sub    $0x40,%rsp
  803781:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803785:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803789:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80378d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803791:	48 89 c7             	mov    %rax,%rdi
  803794:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  80379b:	00 00 00 
  80379e:	ff d0                	callq  *%rax
  8037a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037b3:	00 
  8037b4:	e9 8f 00 00 00       	jmpq   803848 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8037b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c1:	48 89 d6             	mov    %rdx,%rsi
  8037c4:	48 89 c7             	mov    %rax,%rdi
  8037c7:	48 b8 67 35 80 00 00 	movabs $0x803567,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 07                	je     8037de <devpipe_write+0x65>
				return 0;
  8037d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dc:	eb 78                	jmp    803856 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8037de:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  8037e5:	00 00 00 
  8037e8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ee:	8b 40 04             	mov    0x4(%rax),%eax
  8037f1:	48 63 d0             	movslq %eax,%rdx
  8037f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f8:	8b 00                	mov    (%rax),%eax
  8037fa:	48 98                	cltq   
  8037fc:	48 83 c0 20          	add    $0x20,%rax
  803800:	48 39 c2             	cmp    %rax,%rdx
  803803:	73 b4                	jae    8037b9 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803809:	8b 40 04             	mov    0x4(%rax),%eax
  80380c:	99                   	cltd   
  80380d:	c1 ea 1b             	shr    $0x1b,%edx
  803810:	01 d0                	add    %edx,%eax
  803812:	83 e0 1f             	and    $0x1f,%eax
  803815:	29 d0                	sub    %edx,%eax
  803817:	89 c6                	mov    %eax,%esi
  803819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80381d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803821:	48 01 d0             	add    %rdx,%rax
  803824:	0f b6 08             	movzbl (%rax),%ecx
  803827:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80382b:	48 63 c6             	movslq %esi,%rax
  80382e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803832:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803836:	8b 40 04             	mov    0x4(%rax),%eax
  803839:	8d 50 01             	lea    0x1(%rax),%edx
  80383c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803840:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803843:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803850:	72 98                	jb     8037ea <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803852:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803856:	c9                   	leaveq 
  803857:	c3                   	retq   

0000000000803858 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803858:	55                   	push   %rbp
  803859:	48 89 e5             	mov    %rsp,%rbp
  80385c:	48 83 ec 20          	sub    $0x20,%rsp
  803860:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803864:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386c:	48 89 c7             	mov    %rax,%rdi
  80386f:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80387f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803883:	48 be 68 47 80 00 00 	movabs $0x804768,%rsi
  80388a:	00 00 00 
  80388d:	48 89 c7             	mov    %rax,%rdi
  803890:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80389c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a0:	8b 50 04             	mov    0x4(%rax),%edx
  8038a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a7:	8b 00                	mov    (%rax),%eax
  8038a9:	29 c2                	sub    %eax,%edx
  8038ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038af:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8038b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8038c0:	00 00 00 
	stat->st_dev = &devpipe;
  8038c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038c7:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8038ce:	00 00 00 
  8038d1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8038d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038dd:	c9                   	leaveq 
  8038de:	c3                   	retq   

00000000008038df <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8038df:	55                   	push   %rbp
  8038e0:	48 89 e5             	mov    %rsp,%rbp
  8038e3:	48 83 ec 10          	sub    $0x10,%rsp
  8038e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8038eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ef:	48 89 c6             	mov    %rax,%rsi
  8038f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f7:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803907:	48 89 c7             	mov    %rax,%rdi
  80390a:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
  803916:	48 89 c6             	mov    %rax,%rsi
  803919:	bf 00 00 00 00       	mov    $0x0,%edi
  80391e:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
}
  80392a:	c9                   	leaveq 
  80392b:	c3                   	retq   

000000000080392c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80392c:	55                   	push   %rbp
  80392d:	48 89 e5             	mov    %rsp,%rbp
  803930:	48 83 ec 20          	sub    $0x20,%rsp
  803934:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803937:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80393a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80393d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803941:	be 01 00 00 00       	mov    $0x1,%esi
  803946:	48 89 c7             	mov    %rax,%rdi
  803949:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  803950:	00 00 00 
  803953:	ff d0                	callq  *%rax
}
  803955:	90                   	nop
  803956:	c9                   	leaveq 
  803957:	c3                   	retq   

0000000000803958 <getchar>:

int
getchar(void)
{
  803958:	55                   	push   %rbp
  803959:	48 89 e5             	mov    %rsp,%rbp
  80395c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803960:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803964:	ba 01 00 00 00       	mov    $0x1,%edx
  803969:	48 89 c6             	mov    %rax,%rsi
  80396c:	bf 00 00 00 00       	mov    $0x0,%edi
  803971:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  803978:	00 00 00 
  80397b:	ff d0                	callq  *%rax
  80397d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803984:	79 05                	jns    80398b <getchar+0x33>
		return r;
  803986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803989:	eb 14                	jmp    80399f <getchar+0x47>
	if (r < 1)
  80398b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80398f:	7f 07                	jg     803998 <getchar+0x40>
		return -E_EOF;
  803991:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803996:	eb 07                	jmp    80399f <getchar+0x47>
	return c;
  803998:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80399c:	0f b6 c0             	movzbl %al,%eax

}
  80399f:	c9                   	leaveq 
  8039a0:	c3                   	retq   

00000000008039a1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8039a1:	55                   	push   %rbp
  8039a2:	48 89 e5             	mov    %rsp,%rbp
  8039a5:	48 83 ec 20          	sub    $0x20,%rsp
  8039a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b3:	48 89 d6             	mov    %rdx,%rsi
  8039b6:	89 c7                	mov    %eax,%edi
  8039b8:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cb:	79 05                	jns    8039d2 <iscons+0x31>
		return r;
  8039cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d0:	eb 1a                	jmp    8039ec <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8039d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d6:	8b 10                	mov    (%rax),%edx
  8039d8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8039df:	00 00 00 
  8039e2:	8b 00                	mov    (%rax),%eax
  8039e4:	39 c2                	cmp    %eax,%edx
  8039e6:	0f 94 c0             	sete   %al
  8039e9:	0f b6 c0             	movzbl %al,%eax
}
  8039ec:	c9                   	leaveq 
  8039ed:	c3                   	retq   

00000000008039ee <opencons>:

int
opencons(void)
{
  8039ee:	55                   	push   %rbp
  8039ef:	48 89 e5             	mov    %rsp,%rbp
  8039f2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039f6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039fa:	48 89 c7             	mov    %rax,%rdi
  8039fd:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  803a04:	00 00 00 
  803a07:	ff d0                	callq  *%rax
  803a09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a10:	79 05                	jns    803a17 <opencons+0x29>
		return r;
  803a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a15:	eb 5b                	jmp    803a72 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1b:	ba 07 04 00 00       	mov    $0x407,%edx
  803a20:	48 89 c6             	mov    %rax,%rsi
  803a23:	bf 00 00 00 00       	mov    $0x0,%edi
  803a28:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  803a2f:	00 00 00 
  803a32:	ff d0                	callq  *%rax
  803a34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3b:	79 05                	jns    803a42 <opencons+0x54>
		return r;
  803a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a40:	eb 30                	jmp    803a72 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803a42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a46:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803a4d:	00 00 00 
  803a50:	8b 12                	mov    (%rdx),%edx
  803a52:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a58:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a63:	48 89 c7             	mov    %rax,%rdi
  803a66:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
}
  803a72:	c9                   	leaveq 
  803a73:	c3                   	retq   

0000000000803a74 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a74:	55                   	push   %rbp
  803a75:	48 89 e5             	mov    %rsp,%rbp
  803a78:	48 83 ec 30          	sub    $0x30,%rsp
  803a7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a88:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a8d:	75 13                	jne    803aa2 <devcons_read+0x2e>
		return 0;
  803a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a94:	eb 49                	jmp    803adf <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803a96:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803aa2:	48 b8 39 16 80 00 00 	movabs $0x801639,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
  803aae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab5:	74 df                	je     803a96 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abb:	79 05                	jns    803ac2 <devcons_read+0x4e>
		return c;
  803abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac0:	eb 1d                	jmp    803adf <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ac2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ac6:	75 07                	jne    803acf <devcons_read+0x5b>
		return 0;
  803ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  803acd:	eb 10                	jmp    803adf <devcons_read+0x6b>
	*(char*)vbuf = c;
  803acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad2:	89 c2                	mov    %eax,%edx
  803ad4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad8:	88 10                	mov    %dl,(%rax)
	return 1;
  803ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803adf:	c9                   	leaveq 
  803ae0:	c3                   	retq   

0000000000803ae1 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ae1:	55                   	push   %rbp
  803ae2:	48 89 e5             	mov    %rsp,%rbp
  803ae5:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803aec:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803af3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803afa:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b08:	eb 76                	jmp    803b80 <devcons_write+0x9f>
		m = n - tot;
  803b0a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803b11:	89 c2                	mov    %eax,%edx
  803b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b16:	29 c2                	sub    %eax,%edx
  803b18:	89 d0                	mov    %edx,%eax
  803b1a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803b1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b20:	83 f8 7f             	cmp    $0x7f,%eax
  803b23:	76 07                	jbe    803b2c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803b25:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803b2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b2f:	48 63 d0             	movslq %eax,%rdx
  803b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b35:	48 63 c8             	movslq %eax,%rcx
  803b38:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803b3f:	48 01 c1             	add    %rax,%rcx
  803b42:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b49:	48 89 ce             	mov    %rcx,%rsi
  803b4c:	48 89 c7             	mov    %rax,%rdi
  803b4f:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b5e:	48 63 d0             	movslq %eax,%rdx
  803b61:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b68:	48 89 d6             	mov    %rdx,%rsi
  803b6b:	48 89 c7             	mov    %rax,%rdi
  803b6e:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b83:	48 98                	cltq   
  803b85:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b8c:	0f 82 78 ff ff ff    	jb     803b0a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b92:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b95:	c9                   	leaveq 
  803b96:	c3                   	retq   

0000000000803b97 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b97:	55                   	push   %rbp
  803b98:	48 89 e5             	mov    %rsp,%rbp
  803b9b:	48 83 ec 08          	sub    $0x8,%rsp
  803b9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ba8:	c9                   	leaveq 
  803ba9:	c3                   	retq   

0000000000803baa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803baa:	55                   	push   %rbp
  803bab:	48 89 e5             	mov    %rsp,%rbp
  803bae:	48 83 ec 10          	sub    $0x10,%rsp
  803bb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803bb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbe:	48 be 74 47 80 00 00 	movabs $0x804774,%rsi
  803bc5:	00 00 00 
  803bc8:	48 89 c7             	mov    %rax,%rdi
  803bcb:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  803bd2:	00 00 00 
  803bd5:	ff d0                	callq  *%rax
	return 0;
  803bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   

0000000000803bde <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803bde:	55                   	push   %rbp
  803bdf:	48 89 e5             	mov    %rsp,%rbp
  803be2:	53                   	push   %rbx
  803be3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803bea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803bf1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803bf7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803bfe:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803c05:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803c0c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803c13:	84 c0                	test   %al,%al
  803c15:	74 23                	je     803c3a <_panic+0x5c>
  803c17:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803c1e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803c22:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803c26:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803c2a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803c2e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803c32:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803c36:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803c3a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803c41:	00 00 00 
  803c44:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803c4b:	00 00 00 
  803c4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c52:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803c59:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803c60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803c67:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803c6e:	00 00 00 
  803c71:	48 8b 18             	mov    (%rax),%rbx
  803c74:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  803c7b:	00 00 00 
  803c7e:	ff d0                	callq  *%rax
  803c80:	89 c6                	mov    %eax,%esi
  803c82:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803c88:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c8f:	41 89 d0             	mov    %edx,%r8d
  803c92:	48 89 c1             	mov    %rax,%rcx
  803c95:	48 89 da             	mov    %rbx,%rdx
  803c98:	48 bf 80 47 80 00 00 	movabs $0x804780,%rdi
  803c9f:	00 00 00 
  803ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca7:	49 b9 6e 02 80 00 00 	movabs $0x80026e,%r9
  803cae:	00 00 00 
  803cb1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803cb4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803cbb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803cc2:	48 89 d6             	mov    %rdx,%rsi
  803cc5:	48 89 c7             	mov    %rax,%rdi
  803cc8:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
	cprintf("\n");
  803cd4:	48 bf a3 47 80 00 00 	movabs $0x8047a3,%rdi
  803cdb:	00 00 00 
  803cde:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce3:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  803cea:	00 00 00 
  803ced:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803cef:	cc                   	int3   
  803cf0:	eb fd                	jmp    803cef <_panic+0x111>

0000000000803cf2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803cf2:	55                   	push   %rbp
  803cf3:	48 89 e5             	mov    %rsp,%rbp
  803cf6:	48 83 ec 30          	sub    $0x30,%rsp
  803cfa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cfe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d02:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803d06:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d0b:	75 0e                	jne    803d1b <ipc_recv+0x29>
		pg = (void*) UTOP;
  803d0d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d14:	00 00 00 
  803d17:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803d1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d1f:	48 89 c7             	mov    %rax,%rdi
  803d22:	48 b8 6e 19 80 00 00 	movabs $0x80196e,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
  803d2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d35:	79 27                	jns    803d5e <ipc_recv+0x6c>
		if (from_env_store)
  803d37:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d3c:	74 0a                	je     803d48 <ipc_recv+0x56>
			*from_env_store = 0;
  803d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d42:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803d48:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d4d:	74 0a                	je     803d59 <ipc_recv+0x67>
			*perm_store = 0;
  803d4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d53:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5c:	eb 53                	jmp    803db1 <ipc_recv+0xbf>
	}
	if (from_env_store)
  803d5e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d63:	74 19                	je     803d7e <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803d65:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d6c:	00 00 00 
  803d6f:	48 8b 00             	mov    (%rax),%rax
  803d72:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d7c:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803d7e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d83:	74 19                	je     803d9e <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803d85:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d8c:	00 00 00 
  803d8f:	48 8b 00             	mov    (%rax),%rax
  803d92:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d9c:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803d9e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803da5:	00 00 00 
  803da8:	48 8b 00             	mov    (%rax),%rax
  803dab:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803db1:	c9                   	leaveq 
  803db2:	c3                   	retq   

0000000000803db3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803db3:	55                   	push   %rbp
  803db4:	48 89 e5             	mov    %rsp,%rbp
  803db7:	48 83 ec 30          	sub    $0x30,%rsp
  803dbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dbe:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803dc1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803dc5:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803dc8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803dcd:	75 1c                	jne    803deb <ipc_send+0x38>
		pg = (void*) UTOP;
  803dcf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803dd6:	00 00 00 
  803dd9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803ddd:	eb 0c                	jmp    803deb <ipc_send+0x38>
		sys_yield();
  803ddf:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803de6:	00 00 00 
  803de9:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803deb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803dee:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803df1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803df5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803df8:	89 c7                	mov    %eax,%edi
  803dfa:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
  803e06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e09:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e0d:	74 d0                	je     803ddf <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  803e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e13:	79 30                	jns    803e45 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  803e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e18:	89 c1                	mov    %eax,%ecx
  803e1a:	48 ba a5 47 80 00 00 	movabs $0x8047a5,%rdx
  803e21:	00 00 00 
  803e24:	be 47 00 00 00       	mov    $0x47,%esi
  803e29:	48 bf bb 47 80 00 00 	movabs $0x8047bb,%rdi
  803e30:	00 00 00 
  803e33:	b8 00 00 00 00       	mov    $0x0,%eax
  803e38:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  803e3f:	00 00 00 
  803e42:	41 ff d0             	callq  *%r8

}
  803e45:	90                   	nop
  803e46:	c9                   	leaveq 
  803e47:	c3                   	retq   

0000000000803e48 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803e48:	55                   	push   %rbp
  803e49:	48 89 e5             	mov    %rsp,%rbp
  803e4c:	53                   	push   %rbx
  803e4d:	48 83 ec 28          	sub    $0x28,%rsp
  803e51:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  803e55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  803e5c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  803e63:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e68:	75 0e                	jne    803e78 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  803e6a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e71:	00 00 00 
  803e74:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  803e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7c:	ba 07 00 00 00       	mov    $0x7,%edx
  803e81:	48 89 c6             	mov    %rax,%rsi
  803e84:	bf 00 00 00 00       	mov    $0x0,%edi
  803e89:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  803e90:	00 00 00 
  803e93:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  803e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e99:	48 c1 e8 0c          	shr    $0xc,%rax
  803e9d:	48 89 c2             	mov    %rax,%rdx
  803ea0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ea7:	01 00 00 
  803eaa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803eae:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803eb4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  803eb8:	b8 03 00 00 00       	mov    $0x3,%eax
  803ebd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ec1:	48 89 d3             	mov    %rdx,%rbx
  803ec4:	0f 01 c1             	vmcall 
  803ec7:	89 f2                	mov    %esi,%edx
  803ec9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ecc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  803ecf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ed3:	79 05                	jns    803eda <ipc_host_recv+0x92>
		return r;
  803ed5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ed8:	eb 03                	jmp    803edd <ipc_host_recv+0x95>
	}
	return val;
  803eda:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  803edd:	48 83 c4 28          	add    $0x28,%rsp
  803ee1:	5b                   	pop    %rbx
  803ee2:	5d                   	pop    %rbp
  803ee3:	c3                   	retq   

0000000000803ee4 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ee4:	55                   	push   %rbp
  803ee5:	48 89 e5             	mov    %rsp,%rbp
  803ee8:	53                   	push   %rbx
  803ee9:	48 83 ec 38          	sub    $0x38,%rsp
  803eed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803ef0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  803ef3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803ef7:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  803efa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  803f01:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803f06:	75 0e                	jne    803f16 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  803f08:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f0f:	00 00 00 
  803f12:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  803f16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f1a:	48 c1 e8 0c          	shr    $0xc,%rax
  803f1e:	48 89 c2             	mov    %rax,%rdx
  803f21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f28:	01 00 00 
  803f2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f2f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803f35:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  803f39:	b8 02 00 00 00       	mov    $0x2,%eax
  803f3e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803f41:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803f44:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f48:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803f4b:	89 fb                	mov    %edi,%ebx
  803f4d:	0f 01 c1             	vmcall 
  803f50:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  803f53:	eb 26                	jmp    803f7b <ipc_host_send+0x97>
		sys_yield();
  803f55:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803f5c:	00 00 00 
  803f5f:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  803f61:	b8 02 00 00 00       	mov    $0x2,%eax
  803f66:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803f69:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803f6c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f70:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803f73:	89 fb                	mov    %edi,%ebx
  803f75:	0f 01 c1             	vmcall 
  803f78:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  803f7b:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  803f7f:	74 d4                	je     803f55 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  803f81:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f85:	79 30                	jns    803fb7 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  803f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8a:	89 c1                	mov    %eax,%ecx
  803f8c:	48 ba a5 47 80 00 00 	movabs $0x8047a5,%rdx
  803f93:	00 00 00 
  803f96:	be 79 00 00 00       	mov    $0x79,%esi
  803f9b:	48 bf bb 47 80 00 00 	movabs $0x8047bb,%rdi
  803fa2:	00 00 00 
  803fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  803faa:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  803fb1:	00 00 00 
  803fb4:	41 ff d0             	callq  *%r8

}
  803fb7:	90                   	nop
  803fb8:	48 83 c4 38          	add    $0x38,%rsp
  803fbc:	5b                   	pop    %rbx
  803fbd:	5d                   	pop    %rbp
  803fbe:	c3                   	retq   

0000000000803fbf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fbf:	55                   	push   %rbp
  803fc0:	48 89 e5             	mov    %rsp,%rbp
  803fc3:	48 83 ec 18          	sub    $0x18,%rsp
  803fc7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fd1:	eb 4d                	jmp    804020 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  803fd3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803fda:	00 00 00 
  803fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe0:	48 98                	cltq   
  803fe2:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803fe9:	48 01 d0             	add    %rdx,%rax
  803fec:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ff2:	8b 00                	mov    (%rax),%eax
  803ff4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ff7:	75 23                	jne    80401c <ipc_find_env+0x5d>
			return envs[i].env_id;
  803ff9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804000:	00 00 00 
  804003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804006:	48 98                	cltq   
  804008:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80400f:	48 01 d0             	add    %rdx,%rax
  804012:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804018:	8b 00                	mov    (%rax),%eax
  80401a:	eb 12                	jmp    80402e <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80401c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804020:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804027:	7e aa                	jle    803fd3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804029:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80402e:	c9                   	leaveq 
  80402f:	c3                   	retq   

0000000000804030 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804030:	55                   	push   %rbp
  804031:	48 89 e5             	mov    %rsp,%rbp
  804034:	48 83 ec 18          	sub    $0x18,%rsp
  804038:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80403c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804040:	48 c1 e8 15          	shr    $0x15,%rax
  804044:	48 89 c2             	mov    %rax,%rdx
  804047:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80404e:	01 00 00 
  804051:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804055:	83 e0 01             	and    $0x1,%eax
  804058:	48 85 c0             	test   %rax,%rax
  80405b:	75 07                	jne    804064 <pageref+0x34>
		return 0;
  80405d:	b8 00 00 00 00       	mov    $0x0,%eax
  804062:	eb 56                	jmp    8040ba <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804068:	48 c1 e8 0c          	shr    $0xc,%rax
  80406c:	48 89 c2             	mov    %rax,%rdx
  80406f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804076:	01 00 00 
  804079:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80407d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804085:	83 e0 01             	and    $0x1,%eax
  804088:	48 85 c0             	test   %rax,%rax
  80408b:	75 07                	jne    804094 <pageref+0x64>
		return 0;
  80408d:	b8 00 00 00 00       	mov    $0x0,%eax
  804092:	eb 26                	jmp    8040ba <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804098:	48 c1 e8 0c          	shr    $0xc,%rax
  80409c:	48 89 c2             	mov    %rax,%rdx
  80409f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040a6:	00 00 00 
  8040a9:	48 c1 e2 04          	shl    $0x4,%rdx
  8040ad:	48 01 d0             	add    %rdx,%rax
  8040b0:	48 83 c0 08          	add    $0x8,%rax
  8040b4:	0f b7 00             	movzwl (%rax),%eax
  8040b7:	0f b7 c0             	movzwl %ax,%eax
}
  8040ba:	c9                   	leaveq 
  8040bb:	c3                   	retq   
