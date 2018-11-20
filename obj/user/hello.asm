
obj/user/hello:     file format elf64-x86-64


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
  800052:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
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
  800082:	48 bf 6e 40 80 00 00 	movabs $0x80406e,%rdi
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
  800128:	48 b8 6f 1f 80 00 00 	movabs $0x801f6f,%rax
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
  8003db:	48 b8 90 42 80 00 00 	movabs $0x804290,%rax
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
  8006bd:	48 b8 b8 42 80 00 00 	movabs $0x8042b8,%rax
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
  800804:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  80080b:	00 00 00 
  80080e:	48 63 d3             	movslq %ebx,%rdx
  800811:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800815:	4d 85 e4             	test   %r12,%r12
  800818:	75 2e                	jne    800848 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80081a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80081e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800822:	89 d9                	mov    %ebx,%ecx
  800824:	48 ba a1 42 80 00 00 	movabs $0x8042a1,%rdx
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
  800853:	48 ba aa 42 80 00 00 	movabs $0x8042aa,%rdx
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
  8008aa:	49 bc ad 42 80 00 00 	movabs $0x8042ad,%r12
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
  8015b6:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  8015bd:	00 00 00 
  8015c0:	be 24 00 00 00       	mov    $0x24,%esi
  8015c5:	48 bf 85 45 80 00 00 	movabs $0x804585,%rdi
  8015cc:	00 00 00 
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d4:	49 b9 da 3c 80 00 00 	movabs $0x803cda,%r9
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

0000000000801b30 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801b34:	48 83 ec 08          	sub    $0x8,%rsp
  801b38:	6a 00                	pushq  $0x0
  801b3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b50:	be 00 00 00 00       	mov    $0x0,%esi
  801b55:	bf 13 00 00 00       	mov    $0x13,%edi
  801b5a:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
  801b66:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 10          	sub    $0x10,%rsp
  801b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7b:	48 98                	cltq   
  801b7d:	48 83 ec 08          	sub    $0x8,%rsp
  801b81:	6a 00                	pushq  $0x0
  801b83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b94:	48 89 c2             	mov    %rax,%rdx
  801b97:	be 00 00 00 00       	mov    $0x0,%esi
  801b9c:	bf 14 00 00 00       	mov    $0x14,%edi
  801ba1:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
  801bad:	48 83 c4 10          	add    $0x10,%rsp
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801bb7:	48 83 ec 08          	sub    $0x8,%rsp
  801bbb:	6a 00                	pushq  $0x0
  801bbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bce:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd3:	be 00 00 00 00       	mov    $0x0,%esi
  801bd8:	bf 15 00 00 00       	mov    $0x15,%edi
  801bdd:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
  801be9:	48 83 c4 10          	add    $0x10,%rsp
}
  801bed:	c9                   	leaveq 
  801bee:	c3                   	retq   

0000000000801bef <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801bef:	55                   	push   %rbp
  801bf0:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801bf3:	48 83 ec 08          	sub    $0x8,%rsp
  801bf7:	6a 00                	pushq  $0x0
  801bf9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c05:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0f:	be 00 00 00 00       	mov    $0x0,%esi
  801c14:	bf 16 00 00 00       	mov    $0x16,%edi
  801c19:	48 b8 5e 15 80 00 00 	movabs $0x80155e,%rax
  801c20:	00 00 00 
  801c23:	ff d0                	callq  *%rax
  801c25:	48 83 c4 10          	add    $0x10,%rsp
}
  801c29:	90                   	nop
  801c2a:	c9                   	leaveq 
  801c2b:	c3                   	retq   

0000000000801c2c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c2c:	55                   	push   %rbp
  801c2d:	48 89 e5             	mov    %rsp,%rbp
  801c30:	48 83 ec 08          	sub    $0x8,%rsp
  801c34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c38:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c3c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c43:	ff ff ff 
  801c46:	48 01 d0             	add    %rdx,%rax
  801c49:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 08          	sub    $0x8,%rsp
  801c57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5f:	48 89 c7             	mov    %rax,%rdi
  801c62:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
  801c6e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c74:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 18          	sub    $0x18,%rsp
  801c82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c8d:	eb 6b                	jmp    801cfa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	48 98                	cltq   
  801c94:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c9a:	48 c1 e0 0c          	shl    $0xc,%rax
  801c9e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca6:	48 c1 e8 15          	shr    $0x15,%rax
  801caa:	48 89 c2             	mov    %rax,%rdx
  801cad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cb4:	01 00 00 
  801cb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cbb:	83 e0 01             	and    $0x1,%eax
  801cbe:	48 85 c0             	test   %rax,%rax
  801cc1:	74 21                	je     801ce4 <fd_alloc+0x6a>
  801cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc7:	48 c1 e8 0c          	shr    $0xc,%rax
  801ccb:	48 89 c2             	mov    %rax,%rdx
  801cce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cd5:	01 00 00 
  801cd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cdc:	83 e0 01             	and    $0x1,%eax
  801cdf:	48 85 c0             	test   %rax,%rax
  801ce2:	75 12                	jne    801cf6 <fd_alloc+0x7c>
			*fd_store = fd;
  801ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cec:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	eb 1a                	jmp    801d10 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cfa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cfe:	7e 8f                	jle    801c8f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d0b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 20          	sub    $0x20,%rsp
  801d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d25:	78 06                	js     801d2d <fd_lookup+0x1b>
  801d27:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d2b:	7e 07                	jle    801d34 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d32:	eb 6c                	jmp    801da0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	48 98                	cltq   
  801d39:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d3f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4b:	48 c1 e8 15          	shr    $0x15,%rax
  801d4f:	48 89 c2             	mov    %rax,%rdx
  801d52:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d59:	01 00 00 
  801d5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d60:	83 e0 01             	and    $0x1,%eax
  801d63:	48 85 c0             	test   %rax,%rax
  801d66:	74 21                	je     801d89 <fd_lookup+0x77>
  801d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d70:	48 89 c2             	mov    %rax,%rdx
  801d73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d7a:	01 00 00 
  801d7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d81:	83 e0 01             	and    $0x1,%eax
  801d84:	48 85 c0             	test   %rax,%rax
  801d87:	75 07                	jne    801d90 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d8e:	eb 10                	jmp    801da0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d98:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 30          	sub    $0x30,%rsp
  801daa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dae:	89 f0                	mov    %esi,%eax
  801db0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801db3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db7:	48 89 c7             	mov    %rax,%rdi
  801dba:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	89 c2                	mov    %eax,%edx
  801dc8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801dcc:	48 89 c6             	mov    %rax,%rsi
  801dcf:	89 d7                	mov    %edx,%edi
  801dd1:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
  801ddd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801de0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de4:	78 0a                	js     801df0 <fd_close+0x4e>
	    || fd != fd2)
  801de6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dea:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801dee:	74 12                	je     801e02 <fd_close+0x60>
		return (must_exist ? r : 0);
  801df0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801df4:	74 05                	je     801dfb <fd_close+0x59>
  801df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df9:	eb 70                	jmp    801e6b <fd_close+0xc9>
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801e00:	eb 69                	jmp    801e6b <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e06:	8b 00                	mov    (%rax),%eax
  801e08:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e0c:	48 89 d6             	mov    %rdx,%rsi
  801e0f:	89 c7                	mov    %eax,%edi
  801e11:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
  801e1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e24:	78 2a                	js     801e50 <fd_close+0xae>
		if (dev->dev_close)
  801e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e2e:	48 85 c0             	test   %rax,%rax
  801e31:	74 16                	je     801e49 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801e33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e37:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e3b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e3f:	48 89 d7             	mov    %rdx,%rdi
  801e42:	ff d0                	callq  *%rax
  801e44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e47:	eb 07                	jmp    801e50 <fd_close+0xae>
		else
			r = 0;
  801e49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e54:	48 89 c6             	mov    %rax,%rsi
  801e57:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5c:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	callq  *%rax
	return r;
  801e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e6b:	c9                   	leaveq 
  801e6c:	c3                   	retq   

0000000000801e6d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 20          	sub    $0x20,%rsp
  801e75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e83:	eb 41                	jmp    801ec6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e85:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e8c:	00 00 00 
  801e8f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e92:	48 63 d2             	movslq %edx,%rdx
  801e95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e99:	8b 00                	mov    (%rax),%eax
  801e9b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e9e:	75 22                	jne    801ec2 <dev_lookup+0x55>
			*dev = devtab[i];
  801ea0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ea7:	00 00 00 
  801eaa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ead:	48 63 d2             	movslq %edx,%rdx
  801eb0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801eb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	eb 60                	jmp    801f22 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ec2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ec6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ecd:	00 00 00 
  801ed0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ed3:	48 63 d2             	movslq %edx,%rdx
  801ed6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eda:	48 85 c0             	test   %rax,%rax
  801edd:	75 a6                	jne    801e85 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801edf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ee6:	00 00 00 
  801ee9:	48 8b 00             	mov    (%rax),%rax
  801eec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ef2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef5:	89 c6                	mov    %eax,%esi
  801ef7:	48 bf 98 45 80 00 00 	movabs $0x804598,%rdi
  801efe:	00 00 00 
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
  801f06:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  801f0d:	00 00 00 
  801f10:	ff d1                	callq  *%rcx
	*dev = 0;
  801f12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f16:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f22:	c9                   	leaveq 
  801f23:	c3                   	retq   

0000000000801f24 <close>:

int
close(int fdnum)
{
  801f24:	55                   	push   %rbp
  801f25:	48 89 e5             	mov    %rsp,%rbp
  801f28:	48 83 ec 20          	sub    $0x20,%rsp
  801f2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f2f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f36:	48 89 d6             	mov    %rdx,%rsi
  801f39:	89 c7                	mov    %eax,%edi
  801f3b:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801f42:	00 00 00 
  801f45:	ff d0                	callq  *%rax
  801f47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4e:	79 05                	jns    801f55 <close+0x31>
		return r;
  801f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f53:	eb 18                	jmp    801f6d <close+0x49>
	else
		return fd_close(fd, 1);
  801f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f59:	be 01 00 00 00       	mov    $0x1,%esi
  801f5e:	48 89 c7             	mov    %rax,%rdi
  801f61:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  801f68:	00 00 00 
  801f6b:	ff d0                	callq  *%rax
}
  801f6d:	c9                   	leaveq 
  801f6e:	c3                   	retq   

0000000000801f6f <close_all>:

void
close_all(void)
{
  801f6f:	55                   	push   %rbp
  801f70:	48 89 e5             	mov    %rsp,%rbp
  801f73:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f7e:	eb 15                	jmp    801f95 <close_all+0x26>
		close(i);
  801f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f83:	89 c7                	mov    %eax,%edi
  801f85:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  801f8c:	00 00 00 
  801f8f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f91:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f95:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f99:	7e e5                	jle    801f80 <close_all+0x11>
		close(i);
}
  801f9b:	90                   	nop
  801f9c:	c9                   	leaveq 
  801f9d:	c3                   	retq   

0000000000801f9e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f9e:	55                   	push   %rbp
  801f9f:	48 89 e5             	mov    %rsp,%rbp
  801fa2:	48 83 ec 40          	sub    $0x40,%rsp
  801fa6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801fa9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fac:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fb0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fb3:	48 89 d6             	mov    %rdx,%rsi
  801fb6:	89 c7                	mov    %eax,%edi
  801fb8:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax
  801fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fcb:	79 08                	jns    801fd5 <dup+0x37>
		return r;
  801fcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd0:	e9 70 01 00 00       	jmpq   802145 <dup+0x1a7>
	close(newfdnum);
  801fd5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fd8:	89 c7                	mov    %eax,%edi
  801fda:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  801fe1:	00 00 00 
  801fe4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fe6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fe9:	48 98                	cltq   
  801feb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ff1:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ff9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffd:	48 89 c7             	mov    %rax,%rdi
  802000:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802007:	00 00 00 
  80200a:	ff d0                	callq  *%rax
  80200c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802014:	48 89 c7             	mov    %rax,%rdi
  802017:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
  802023:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80202b:	48 c1 e8 15          	shr    $0x15,%rax
  80202f:	48 89 c2             	mov    %rax,%rdx
  802032:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802039:	01 00 00 
  80203c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802040:	83 e0 01             	and    $0x1,%eax
  802043:	48 85 c0             	test   %rax,%rax
  802046:	74 71                	je     8020b9 <dup+0x11b>
  802048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204c:	48 c1 e8 0c          	shr    $0xc,%rax
  802050:	48 89 c2             	mov    %rax,%rdx
  802053:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80205a:	01 00 00 
  80205d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802061:	83 e0 01             	and    $0x1,%eax
  802064:	48 85 c0             	test   %rax,%rax
  802067:	74 50                	je     8020b9 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206d:	48 c1 e8 0c          	shr    $0xc,%rax
  802071:	48 89 c2             	mov    %rax,%rdx
  802074:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207b:	01 00 00 
  80207e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802082:	25 07 0e 00 00       	and    $0xe07,%eax
  802087:	89 c1                	mov    %eax,%ecx
  802089:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80208d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802091:	41 89 c8             	mov    %ecx,%r8d
  802094:	48 89 d1             	mov    %rdx,%rcx
  802097:	ba 00 00 00 00       	mov    $0x0,%edx
  80209c:	48 89 c6             	mov    %rax,%rsi
  80209f:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a4:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
  8020b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b7:	78 55                	js     80210e <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c1:	48 89 c2             	mov    %rax,%rdx
  8020c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020cb:	01 00 00 
  8020ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d7:	89 c1                	mov    %eax,%ecx
  8020d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e1:	41 89 c8             	mov    %ecx,%r8d
  8020e4:	48 89 d1             	mov    %rdx,%rcx
  8020e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ec:	48 89 c6             	mov    %rax,%rsi
  8020ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f4:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  8020fb:	00 00 00 
  8020fe:	ff d0                	callq  *%rax
  802100:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802103:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802107:	78 08                	js     802111 <dup+0x173>
		goto err;

	return newfdnum;
  802109:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80210c:	eb 37                	jmp    802145 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80210e:	90                   	nop
  80210f:	eb 01                	jmp    802112 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802111:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802116:	48 89 c6             	mov    %rax,%rsi
  802119:	bf 00 00 00 00       	mov    $0x0,%edi
  80211e:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  802125:	00 00 00 
  802128:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80212a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212e:	48 89 c6             	mov    %rax,%rsi
  802131:	bf 00 00 00 00       	mov    $0x0,%edi
  802136:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax
	return r;
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802145:	c9                   	leaveq 
  802146:	c3                   	retq   

0000000000802147 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802147:	55                   	push   %rbp
  802148:	48 89 e5             	mov    %rsp,%rbp
  80214b:	48 83 ec 40          	sub    $0x40,%rsp
  80214f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802152:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802156:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80215a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80215e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802161:	48 89 d6             	mov    %rdx,%rsi
  802164:	89 c7                	mov    %eax,%edi
  802166:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802175:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802179:	78 24                	js     80219f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80217b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217f:	8b 00                	mov    (%rax),%eax
  802181:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802185:	48 89 d6             	mov    %rdx,%rsi
  802188:	89 c7                	mov    %eax,%edi
  80218a:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219d:	79 05                	jns    8021a4 <read+0x5d>
		return r;
  80219f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a2:	eb 76                	jmp    80221a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	8b 40 08             	mov    0x8(%rax),%eax
  8021ab:	83 e0 03             	and    $0x3,%eax
  8021ae:	83 f8 01             	cmp    $0x1,%eax
  8021b1:	75 3a                	jne    8021ed <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021b3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021ba:	00 00 00 
  8021bd:	48 8b 00             	mov    (%rax),%rax
  8021c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021c9:	89 c6                	mov    %eax,%esi
  8021cb:	48 bf b7 45 80 00 00 	movabs $0x8045b7,%rdi
  8021d2:	00 00 00 
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  8021e1:	00 00 00 
  8021e4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021eb:	eb 2d                	jmp    80221a <read+0xd3>
	}
	if (!dev->dev_read)
  8021ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021f5:	48 85 c0             	test   %rax,%rax
  8021f8:	75 07                	jne    802201 <read+0xba>
		return -E_NOT_SUPP;
  8021fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021ff:	eb 19                	jmp    80221a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802205:	48 8b 40 10          	mov    0x10(%rax),%rax
  802209:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80220d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802211:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802215:	48 89 cf             	mov    %rcx,%rdi
  802218:	ff d0                	callq  *%rax
}
  80221a:	c9                   	leaveq 
  80221b:	c3                   	retq   

000000000080221c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80221c:	55                   	push   %rbp
  80221d:	48 89 e5             	mov    %rsp,%rbp
  802220:	48 83 ec 30          	sub    $0x30,%rsp
  802224:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802227:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80222b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80222f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802236:	eb 47                	jmp    80227f <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223b:	48 98                	cltq   
  80223d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802241:	48 29 c2             	sub    %rax,%rdx
  802244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802247:	48 63 c8             	movslq %eax,%rcx
  80224a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224e:	48 01 c1             	add    %rax,%rcx
  802251:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802254:	48 89 ce             	mov    %rcx,%rsi
  802257:	89 c7                	mov    %eax,%edi
  802259:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802260:	00 00 00 
  802263:	ff d0                	callq  *%rax
  802265:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802268:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80226c:	79 05                	jns    802273 <readn+0x57>
			return m;
  80226e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802271:	eb 1d                	jmp    802290 <readn+0x74>
		if (m == 0)
  802273:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802277:	74 13                	je     80228c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802279:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80227c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802282:	48 98                	cltq   
  802284:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802288:	72 ae                	jb     802238 <readn+0x1c>
  80228a:	eb 01                	jmp    80228d <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80228c:	90                   	nop
	}
	return tot;
  80228d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802290:	c9                   	leaveq 
  802291:	c3                   	retq   

0000000000802292 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802292:	55                   	push   %rbp
  802293:	48 89 e5             	mov    %rsp,%rbp
  802296:	48 83 ec 40          	sub    $0x40,%rsp
  80229a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80229d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ac:	48 89 d6             	mov    %rdx,%rsi
  8022af:	89 c7                	mov    %eax,%edi
  8022b1:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8022b8:	00 00 00 
  8022bb:	ff d0                	callq  *%rax
  8022bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c4:	78 24                	js     8022ea <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ca:	8b 00                	mov    (%rax),%eax
  8022cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d0:	48 89 d6             	mov    %rdx,%rsi
  8022d3:	89 c7                	mov    %eax,%edi
  8022d5:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8022dc:	00 00 00 
  8022df:	ff d0                	callq  *%rax
  8022e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e8:	79 05                	jns    8022ef <write+0x5d>
		return r;
  8022ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ed:	eb 75                	jmp    802364 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f3:	8b 40 08             	mov    0x8(%rax),%eax
  8022f6:	83 e0 03             	and    $0x3,%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	75 3a                	jne    802337 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022fd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802304:	00 00 00 
  802307:	48 8b 00             	mov    (%rax),%rax
  80230a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802310:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802313:	89 c6                	mov    %eax,%esi
  802315:	48 bf d3 45 80 00 00 	movabs $0x8045d3,%rdi
  80231c:	00 00 00 
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  80232b:	00 00 00 
  80232e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802330:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802335:	eb 2d                	jmp    802364 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80233f:	48 85 c0             	test   %rax,%rax
  802342:	75 07                	jne    80234b <write+0xb9>
		return -E_NOT_SUPP;
  802344:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802349:	eb 19                	jmp    802364 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80234b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802353:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802357:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80235b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80235f:	48 89 cf             	mov    %rcx,%rdi
  802362:	ff d0                	callq  *%rax
}
  802364:	c9                   	leaveq 
  802365:	c3                   	retq   

0000000000802366 <seek>:

int
seek(int fdnum, off_t offset)
{
  802366:	55                   	push   %rbp
  802367:	48 89 e5             	mov    %rsp,%rbp
  80236a:	48 83 ec 18          	sub    $0x18,%rsp
  80236e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802371:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802374:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802378:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80237b:	48 89 d6             	mov    %rdx,%rsi
  80237e:	89 c7                	mov    %eax,%edi
  802380:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
  80238c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802393:	79 05                	jns    80239a <seek+0x34>
		return r;
  802395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802398:	eb 0f                	jmp    8023a9 <seek+0x43>
	fd->fd_offset = offset;
  80239a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leaveq 
  8023aa:	c3                   	retq   

00000000008023ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
  8023af:	48 83 ec 30          	sub    $0x30,%rsp
  8023b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c0:	48 89 d6             	mov    %rdx,%rsi
  8023c3:	89 c7                	mov    %eax,%edi
  8023c5:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8023cc:	00 00 00 
  8023cf:	ff d0                	callq  *%rax
  8023d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d8:	78 24                	js     8023fe <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023de:	8b 00                	mov    (%rax),%eax
  8023e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e4:	48 89 d6             	mov    %rdx,%rsi
  8023e7:	89 c7                	mov    %eax,%edi
  8023e9:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
  8023f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fc:	79 05                	jns    802403 <ftruncate+0x58>
		return r;
  8023fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802401:	eb 72                	jmp    802475 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802407:	8b 40 08             	mov    0x8(%rax),%eax
  80240a:	83 e0 03             	and    $0x3,%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 3a                	jne    80244b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802411:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802418:	00 00 00 
  80241b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80241e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802424:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802427:	89 c6                	mov    %eax,%esi
  802429:	48 bf f0 45 80 00 00 	movabs $0x8045f0,%rdi
  802430:	00 00 00 
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  80243f:	00 00 00 
  802442:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802449:	eb 2a                	jmp    802475 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802453:	48 85 c0             	test   %rax,%rax
  802456:	75 07                	jne    80245f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802458:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80245d:	eb 16                	jmp    802475 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80245f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802463:	48 8b 40 30          	mov    0x30(%rax),%rax
  802467:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80246b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80246e:	89 ce                	mov    %ecx,%esi
  802470:	48 89 d7             	mov    %rdx,%rdi
  802473:	ff d0                	callq  *%rax
}
  802475:	c9                   	leaveq 
  802476:	c3                   	retq   

0000000000802477 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802477:	55                   	push   %rbp
  802478:	48 89 e5             	mov    %rsp,%rbp
  80247b:	48 83 ec 30          	sub    $0x30,%rsp
  80247f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802482:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802486:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80248a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80248d:	48 89 d6             	mov    %rdx,%rsi
  802490:	89 c7                	mov    %eax,%edi
  802492:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802499:	00 00 00 
  80249c:	ff d0                	callq  *%rax
  80249e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a5:	78 24                	js     8024cb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ab:	8b 00                	mov    (%rax),%eax
  8024ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b1:	48 89 d6             	mov    %rdx,%rsi
  8024b4:	89 c7                	mov    %eax,%edi
  8024b6:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8024bd:	00 00 00 
  8024c0:	ff d0                	callq  *%rax
  8024c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c9:	79 05                	jns    8024d0 <fstat+0x59>
		return r;
  8024cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ce:	eb 5e                	jmp    80252e <fstat+0xb7>
	if (!dev->dev_stat)
  8024d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024d8:	48 85 c0             	test   %rax,%rax
  8024db:	75 07                	jne    8024e4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e2:	eb 4a                	jmp    80252e <fstat+0xb7>
	stat->st_name[0] = 0;
  8024e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ef:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024f6:	00 00 00 
	stat->st_isdir = 0;
  8024f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024fd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802504:	00 00 00 
	stat->st_dev = dev;
  802507:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80250b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80250f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80251e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802522:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802526:	48 89 ce             	mov    %rcx,%rsi
  802529:	48 89 d7             	mov    %rdx,%rdi
  80252c:	ff d0                	callq  *%rax
}
  80252e:	c9                   	leaveq 
  80252f:	c3                   	retq   

0000000000802530 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802530:	55                   	push   %rbp
  802531:	48 89 e5             	mov    %rsp,%rbp
  802534:	48 83 ec 20          	sub    $0x20,%rsp
  802538:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80253c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802544:	be 00 00 00 00       	mov    $0x0,%esi
  802549:	48 89 c7             	mov    %rax,%rdi
  80254c:	48 b8 20 26 80 00 00 	movabs $0x802620,%rax
  802553:	00 00 00 
  802556:	ff d0                	callq  *%rax
  802558:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255f:	79 05                	jns    802566 <stat+0x36>
		return fd;
  802561:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802564:	eb 2f                	jmp    802595 <stat+0x65>
	r = fstat(fd, stat);
  802566:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80256a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256d:	48 89 d6             	mov    %rdx,%rsi
  802570:	89 c7                	mov    %eax,%edi
  802572:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  802579:	00 00 00 
  80257c:	ff d0                	callq  *%rax
  80257e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802584:	89 c7                	mov    %eax,%edi
  802586:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  80258d:	00 00 00 
  802590:	ff d0                	callq  *%rax
	return r;
  802592:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802595:	c9                   	leaveq 
  802596:	c3                   	retq   

0000000000802597 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802597:	55                   	push   %rbp
  802598:	48 89 e5             	mov    %rsp,%rbp
  80259b:	48 83 ec 10          	sub    $0x10,%rsp
  80259f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025a6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025ad:	00 00 00 
  8025b0:	8b 00                	mov    (%rax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	75 1f                	jne    8025d5 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8025bb:	48 b8 44 3f 80 00 00 	movabs $0x803f44,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	callq  *%rax
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025d0:	00 00 00 
  8025d3:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025dc:	00 00 00 
  8025df:	8b 00                	mov    (%rax),%eax
  8025e1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025e4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025e9:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8025f0:	00 00 00 
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 af 3e 80 00 00 	movabs $0x803eaf,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802605:	ba 00 00 00 00       	mov    $0x0,%edx
  80260a:	48 89 c6             	mov    %rax,%rsi
  80260d:	bf 00 00 00 00       	mov    $0x0,%edi
  802612:	48 b8 ee 3d 80 00 00 	movabs $0x803dee,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
}
  80261e:	c9                   	leaveq 
  80261f:	c3                   	retq   

0000000000802620 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802620:	55                   	push   %rbp
  802621:	48 89 e5             	mov    %rsp,%rbp
  802624:	48 83 ec 20          	sub    $0x20,%rsp
  802628:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80262c:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80262f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802633:	48 89 c7             	mov    %rax,%rdi
  802636:	48 b8 92 0d 80 00 00 	movabs $0x800d92,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax
  802642:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802647:	7e 0a                	jle    802653 <open+0x33>
		return -E_BAD_PATH;
  802649:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80264e:	e9 a5 00 00 00       	jmpq   8026f8 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802653:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802657:	48 89 c7             	mov    %rax,%rdi
  80265a:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax
  802666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266d:	79 08                	jns    802677 <open+0x57>
		return r;
  80266f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802672:	e9 81 00 00 00       	jmpq   8026f8 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267b:	48 89 c6             	mov    %rax,%rsi
  80267e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802685:	00 00 00 
  802688:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802694:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80269b:	00 00 00 
  80269e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026a1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8026a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ab:	48 89 c6             	mov    %rax,%rsi
  8026ae:	bf 01 00 00 00       	mov    $0x1,%edi
  8026b3:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  8026ba:	00 00 00 
  8026bd:	ff d0                	callq  *%rax
  8026bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c6:	79 1d                	jns    8026e5 <open+0xc5>
		fd_close(fd, 0);
  8026c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cc:	be 00 00 00 00       	mov    $0x0,%esi
  8026d1:	48 89 c7             	mov    %rax,%rdi
  8026d4:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
		return r;
  8026e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e3:	eb 13                	jmp    8026f8 <open+0xd8>
	}

	return fd2num(fd);
  8026e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e9:	48 89 c7             	mov    %rax,%rdi
  8026ec:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax

}
  8026f8:	c9                   	leaveq 
  8026f9:	c3                   	retq   

00000000008026fa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026fa:	55                   	push   %rbp
  8026fb:	48 89 e5             	mov    %rsp,%rbp
  8026fe:	48 83 ec 10          	sub    $0x10,%rsp
  802702:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80270a:	8b 50 0c             	mov    0xc(%rax),%edx
  80270d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802714:	00 00 00 
  802717:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802719:	be 00 00 00 00       	mov    $0x0,%esi
  80271e:	bf 06 00 00 00       	mov    $0x6,%edi
  802723:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	callq  *%rax
}
  80272f:	c9                   	leaveq 
  802730:	c3                   	retq   

0000000000802731 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
  802735:	48 83 ec 30          	sub    $0x30,%rsp
  802739:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80273d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802741:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802749:	8b 50 0c             	mov    0xc(%rax),%edx
  80274c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802753:	00 00 00 
  802756:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802758:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80275f:	00 00 00 
  802762:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802766:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80276a:	be 00 00 00 00       	mov    $0x0,%esi
  80276f:	bf 03 00 00 00       	mov    $0x3,%edi
  802774:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	callq  *%rax
  802780:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802783:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802787:	79 08                	jns    802791 <devfile_read+0x60>
		return r;
  802789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278c:	e9 a4 00 00 00       	jmpq   802835 <devfile_read+0x104>
	assert(r <= n);
  802791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802794:	48 98                	cltq   
  802796:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80279a:	76 35                	jbe    8027d1 <devfile_read+0xa0>
  80279c:	48 b9 16 46 80 00 00 	movabs $0x804616,%rcx
  8027a3:	00 00 00 
  8027a6:	48 ba 1d 46 80 00 00 	movabs $0x80461d,%rdx
  8027ad:	00 00 00 
  8027b0:	be 86 00 00 00       	mov    $0x86,%esi
  8027b5:	48 bf 32 46 80 00 00 	movabs $0x804632,%rdi
  8027bc:	00 00 00 
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	49 b8 da 3c 80 00 00 	movabs $0x803cda,%r8
  8027cb:	00 00 00 
  8027ce:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8027d1:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8027d8:	7e 35                	jle    80280f <devfile_read+0xde>
  8027da:	48 b9 3d 46 80 00 00 	movabs $0x80463d,%rcx
  8027e1:	00 00 00 
  8027e4:	48 ba 1d 46 80 00 00 	movabs $0x80461d,%rdx
  8027eb:	00 00 00 
  8027ee:	be 87 00 00 00       	mov    $0x87,%esi
  8027f3:	48 bf 32 46 80 00 00 	movabs $0x804632,%rdi
  8027fa:	00 00 00 
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	49 b8 da 3c 80 00 00 	movabs $0x803cda,%r8
  802809:	00 00 00 
  80280c:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80280f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802812:	48 63 d0             	movslq %eax,%rdx
  802815:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802819:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802820:	00 00 00 
  802823:	48 89 c7             	mov    %rax,%rdi
  802826:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  80282d:	00 00 00 
  802830:	ff d0                	callq  *%rax
	return r;
  802832:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802835:	c9                   	leaveq 
  802836:	c3                   	retq   

0000000000802837 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802837:	55                   	push   %rbp
  802838:	48 89 e5             	mov    %rsp,%rbp
  80283b:	48 83 ec 40          	sub    $0x40,%rsp
  80283f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802843:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802847:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80284b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80284f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802853:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80285a:	00 
  80285b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802863:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802868:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80286c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802870:	8b 50 0c             	mov    0xc(%rax),%edx
  802873:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80287a:	00 00 00 
  80287d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80287f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802886:	00 00 00 
  802889:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80288d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802891:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802895:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802899:	48 89 c6             	mov    %rax,%rsi
  80289c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8028a3:	00 00 00 
  8028a6:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8028b2:	be 00 00 00 00       	mov    $0x0,%esi
  8028b7:	bf 04 00 00 00       	mov    $0x4,%edi
  8028bc:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
  8028c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028cf:	79 05                	jns    8028d6 <devfile_write+0x9f>
		return r;
  8028d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d4:	eb 43                	jmp    802919 <devfile_write+0xe2>
	assert(r <= n);
  8028d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d9:	48 98                	cltq   
  8028db:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8028df:	76 35                	jbe    802916 <devfile_write+0xdf>
  8028e1:	48 b9 16 46 80 00 00 	movabs $0x804616,%rcx
  8028e8:	00 00 00 
  8028eb:	48 ba 1d 46 80 00 00 	movabs $0x80461d,%rdx
  8028f2:	00 00 00 
  8028f5:	be a2 00 00 00       	mov    $0xa2,%esi
  8028fa:	48 bf 32 46 80 00 00 	movabs $0x804632,%rdi
  802901:	00 00 00 
  802904:	b8 00 00 00 00       	mov    $0x0,%eax
  802909:	49 b8 da 3c 80 00 00 	movabs $0x803cda,%r8
  802910:	00 00 00 
  802913:	41 ff d0             	callq  *%r8
	return r;
  802916:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802919:	c9                   	leaveq 
  80291a:	c3                   	retq   

000000000080291b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80291b:	55                   	push   %rbp
  80291c:	48 89 e5             	mov    %rsp,%rbp
  80291f:	48 83 ec 20          	sub    $0x20,%rsp
  802923:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802927:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80292b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292f:	8b 50 0c             	mov    0xc(%rax),%edx
  802932:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802939:	00 00 00 
  80293c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80293e:	be 00 00 00 00       	mov    $0x0,%esi
  802943:	bf 05 00 00 00       	mov    $0x5,%edi
  802948:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
  802954:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802957:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295b:	79 05                	jns    802962 <devfile_stat+0x47>
		return r;
  80295d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802960:	eb 56                	jmp    8029b8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802962:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802966:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80296d:	00 00 00 
  802970:	48 89 c7             	mov    %rax,%rdi
  802973:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80297f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802986:	00 00 00 
  802989:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80298f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802993:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802999:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a0:	00 00 00 
  8029a3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ad:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b8:	c9                   	leaveq 
  8029b9:	c3                   	retq   

00000000008029ba <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029ba:	55                   	push   %rbp
  8029bb:	48 89 e5             	mov    %rsp,%rbp
  8029be:	48 83 ec 10          	sub    $0x10,%rsp
  8029c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029c6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029cd:	8b 50 0c             	mov    0xc(%rax),%edx
  8029d0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d7:	00 00 00 
  8029da:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e3:	00 00 00 
  8029e6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029e9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029ec:	be 00 00 00 00       	mov    $0x0,%esi
  8029f1:	bf 02 00 00 00       	mov    $0x2,%edi
  8029f6:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
}
  802a02:	c9                   	leaveq 
  802a03:	c3                   	retq   

0000000000802a04 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
  802a08:	48 83 ec 10          	sub    $0x10,%rsp
  802a0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a14:	48 89 c7             	mov    %rax,%rdi
  802a17:	48 b8 92 0d 80 00 00 	movabs $0x800d92,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
  802a23:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a28:	7e 07                	jle    802a31 <remove+0x2d>
		return -E_BAD_PATH;
  802a2a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a2f:	eb 33                	jmp    802a64 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a35:	48 89 c6             	mov    %rax,%rsi
  802a38:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a3f:	00 00 00 
  802a42:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  802a49:	00 00 00 
  802a4c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a4e:	be 00 00 00 00       	mov    $0x0,%esi
  802a53:	bf 07 00 00 00       	mov    $0x7,%edi
  802a58:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
}
  802a64:	c9                   	leaveq 
  802a65:	c3                   	retq   

0000000000802a66 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a66:	55                   	push   %rbp
  802a67:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a6a:	be 00 00 00 00       	mov    $0x0,%esi
  802a6f:	bf 08 00 00 00       	mov    $0x8,%edi
  802a74:	48 b8 97 25 80 00 00 	movabs $0x802597,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
}
  802a80:	5d                   	pop    %rbp
  802a81:	c3                   	retq   

0000000000802a82 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a82:	55                   	push   %rbp
  802a83:	48 89 e5             	mov    %rsp,%rbp
  802a86:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a8d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a94:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a9b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802aa2:	be 00 00 00 00       	mov    $0x0,%esi
  802aa7:	48 89 c7             	mov    %rax,%rdi
  802aaa:	48 b8 20 26 80 00 00 	movabs $0x802620,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
  802ab6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ab9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abd:	79 28                	jns    802ae7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802abf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac2:	89 c6                	mov    %eax,%esi
  802ac4:	48 bf 49 46 80 00 00 	movabs $0x804649,%rdi
  802acb:	00 00 00 
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad3:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802ada:	00 00 00 
  802add:	ff d2                	callq  *%rdx
		return fd_src;
  802adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae2:	e9 76 01 00 00       	jmpq   802c5d <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ae7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802aee:	be 01 01 00 00       	mov    $0x101,%esi
  802af3:	48 89 c7             	mov    %rax,%rdi
  802af6:	48 b8 20 26 80 00 00 	movabs $0x802620,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
  802b02:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b05:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b09:	0f 89 ad 00 00 00    	jns    802bbc <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b12:	89 c6                	mov    %eax,%esi
  802b14:	48 bf 5f 46 80 00 00 	movabs $0x80465f,%rdi
  802b1b:	00 00 00 
  802b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b23:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802b2a:	00 00 00 
  802b2d:	ff d2                	callq  *%rdx
		close(fd_src);
  802b2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b32:	89 c7                	mov    %eax,%edi
  802b34:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
		return fd_dest;
  802b40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b43:	e9 15 01 00 00       	jmpq   802c5d <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802b48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b4b:	48 63 d0             	movslq %eax,%rdx
  802b4e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b58:	48 89 ce             	mov    %rcx,%rsi
  802b5b:	89 c7                	mov    %eax,%edi
  802b5d:	48 b8 92 22 80 00 00 	movabs $0x802292,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
  802b69:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b70:	79 4a                	jns    802bbc <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802b72:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b75:	89 c6                	mov    %eax,%esi
  802b77:	48 bf 79 46 80 00 00 	movabs $0x804679,%rdi
  802b7e:	00 00 00 
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
  802b86:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802b8d:	00 00 00 
  802b90:	ff d2                	callq  *%rdx
			close(fd_src);
  802b92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b95:	89 c7                	mov    %eax,%edi
  802b97:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	callq  *%rax
			close(fd_dest);
  802ba3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba6:	89 c7                	mov    %eax,%edi
  802ba8:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802baf:	00 00 00 
  802bb2:	ff d0                	callq  *%rax
			return write_size;
  802bb4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bb7:	e9 a1 00 00 00       	jmpq   802c5d <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bbc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc6:	ba 00 02 00 00       	mov    $0x200,%edx
  802bcb:	48 89 ce             	mov    %rcx,%rsi
  802bce:	89 c7                	mov    %eax,%edi
  802bd0:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
  802bdc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802be3:	0f 8f 5f ff ff ff    	jg     802b48 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802be9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bed:	79 47                	jns    802c36 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802bef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bf2:	89 c6                	mov    %eax,%esi
  802bf4:	48 bf 8c 46 80 00 00 	movabs $0x80468c,%rdi
  802bfb:	00 00 00 
  802bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802c03:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802c0a:	00 00 00 
  802c0d:	ff d2                	callq  *%rdx
		close(fd_src);
  802c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c12:	89 c7                	mov    %eax,%edi
  802c14:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
		close(fd_dest);
  802c20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
		return read_size;
  802c31:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c34:	eb 27                	jmp    802c5d <copy+0x1db>
	}
	close(fd_src);
  802c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c39:	89 c7                	mov    %eax,%edi
  802c3b:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
	close(fd_dest);
  802c47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4a:	89 c7                	mov    %eax,%edi
  802c4c:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
	return 0;
  802c58:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 20          	sub    $0x20,%rsp
  802c67:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802c6a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c71:	48 89 d6             	mov    %rdx,%rsi
  802c74:	89 c7                	mov    %eax,%edi
  802c76:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c89:	79 05                	jns    802c90 <fd2sockid+0x31>
		return r;
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	eb 24                	jmp    802cb4 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c94:	8b 10                	mov    (%rax),%edx
  802c96:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802c9d:	00 00 00 
  802ca0:	8b 00                	mov    (%rax),%eax
  802ca2:	39 c2                	cmp    %eax,%edx
  802ca4:	74 07                	je     802cad <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802ca6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cab:	eb 07                	jmp    802cb4 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb1:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802cb4:	c9                   	leaveq 
  802cb5:	c3                   	retq   

0000000000802cb6 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802cb6:	55                   	push   %rbp
  802cb7:	48 89 e5             	mov    %rsp,%rbp
  802cba:	48 83 ec 20          	sub    $0x20,%rsp
  802cbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802cc1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802cc5:	48 89 c7             	mov    %rax,%rdi
  802cc8:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdb:	78 26                	js     802d03 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce1:	ba 07 04 00 00       	mov    $0x407,%edx
  802ce6:	48 89 c6             	mov    %rax,%rsi
  802ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  802cee:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  802cf5:	00 00 00 
  802cf8:	ff d0                	callq  *%rax
  802cfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d01:	79 16                	jns    802d19 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802d03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d06:	89 c7                	mov    %eax,%edi
  802d08:	48 b8 c5 31 80 00 00 	movabs $0x8031c5,%rax
  802d0f:	00 00 00 
  802d12:	ff d0                	callq  *%rax
		return r;
  802d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d17:	eb 3a                	jmp    802d53 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1d:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802d24:	00 00 00 
  802d27:	8b 12                	mov    (%rdx),%edx
  802d29:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802d2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d3d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d44:	48 89 c7             	mov    %rax,%rdi
  802d47:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	callq  *%rax
}
  802d53:	c9                   	leaveq 
  802d54:	c3                   	retq   

0000000000802d55 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802d55:	55                   	push   %rbp
  802d56:	48 89 e5             	mov    %rsp,%rbp
  802d59:	48 83 ec 30          	sub    $0x30,%rsp
  802d5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d68:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d6b:	89 c7                	mov    %eax,%edi
  802d6d:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d80:	79 05                	jns    802d87 <accept+0x32>
		return r;
  802d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d85:	eb 3b                	jmp    802dc2 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802d87:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d8b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	48 89 ce             	mov    %rcx,%rsi
  802d95:	89 c7                	mov    %eax,%edi
  802d97:	48 b8 a2 30 80 00 00 	movabs $0x8030a2,%rax
  802d9e:	00 00 00 
  802da1:	ff d0                	callq  *%rax
  802da3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802daa:	79 05                	jns    802db1 <accept+0x5c>
		return r;
  802dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802daf:	eb 11                	jmp    802dc2 <accept+0x6d>
	return alloc_sockfd(r);
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	89 c7                	mov    %eax,%edi
  802db6:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
}
  802dc2:	c9                   	leaveq 
  802dc3:	c3                   	retq   

0000000000802dc4 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802dc4:	55                   	push   %rbp
  802dc5:	48 89 e5             	mov    %rsp,%rbp
  802dc8:	48 83 ec 20          	sub    $0x20,%rsp
  802dcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dcf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802dd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd9:	89 c7                	mov    %eax,%edi
  802ddb:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802de2:	00 00 00 
  802de5:	ff d0                	callq  *%rax
  802de7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dee:	79 05                	jns    802df5 <bind+0x31>
		return r;
  802df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df3:	eb 1b                	jmp    802e10 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802df5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802df8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dff:	48 89 ce             	mov    %rcx,%rsi
  802e02:	89 c7                	mov    %eax,%edi
  802e04:	48 b8 21 31 80 00 00 	movabs $0x803121,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
}
  802e10:	c9                   	leaveq 
  802e11:	c3                   	retq   

0000000000802e12 <shutdown>:

int
shutdown(int s, int how)
{
  802e12:	55                   	push   %rbp
  802e13:	48 89 e5             	mov    %rsp,%rbp
  802e16:	48 83 ec 20          	sub    $0x20,%rsp
  802e1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e1d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e23:	89 c7                	mov    %eax,%edi
  802e25:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e38:	79 05                	jns    802e3f <shutdown+0x2d>
		return r;
  802e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3d:	eb 16                	jmp    802e55 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802e3f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e45:	89 d6                	mov    %edx,%esi
  802e47:	89 c7                	mov    %eax,%edi
  802e49:	48 b8 85 31 80 00 00 	movabs $0x803185,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
}
  802e55:	c9                   	leaveq 
  802e56:	c3                   	retq   

0000000000802e57 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802e57:	55                   	push   %rbp
  802e58:	48 89 e5             	mov    %rsp,%rbp
  802e5b:	48 83 ec 10          	sub    $0x10,%rsp
  802e5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e67:	48 89 c7             	mov    %rax,%rdi
  802e6a:	48 b8 b5 3f 80 00 00 	movabs $0x803fb5,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
  802e76:	83 f8 01             	cmp    $0x1,%eax
  802e79:	75 17                	jne    802e92 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7f:	8b 40 0c             	mov    0xc(%rax),%eax
  802e82:	89 c7                	mov    %eax,%edi
  802e84:	48 b8 c5 31 80 00 00 	movabs $0x8031c5,%rax
  802e8b:	00 00 00 
  802e8e:	ff d0                	callq  *%rax
  802e90:	eb 05                	jmp    802e97 <devsock_close+0x40>
	else
		return 0;
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e97:	c9                   	leaveq 
  802e98:	c3                   	retq   

0000000000802e99 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802e99:	55                   	push   %rbp
  802e9a:	48 89 e5             	mov    %rsp,%rbp
  802e9d:	48 83 ec 20          	sub    $0x20,%rsp
  802ea1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ea4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ea8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802eab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eae:	89 c7                	mov    %eax,%edi
  802eb0:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
  802ebc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec3:	79 05                	jns    802eca <connect+0x31>
		return r;
  802ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec8:	eb 1b                	jmp    802ee5 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802eca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ecd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed4:	48 89 ce             	mov    %rcx,%rsi
  802ed7:	89 c7                	mov    %eax,%edi
  802ed9:	48 b8 f2 31 80 00 00 	movabs $0x8031f2,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
}
  802ee5:	c9                   	leaveq 
  802ee6:	c3                   	retq   

0000000000802ee7 <listen>:

int
listen(int s, int backlog)
{
  802ee7:	55                   	push   %rbp
  802ee8:	48 89 e5             	mov    %rsp,%rbp
  802eeb:	48 83 ec 20          	sub    $0x20,%rsp
  802eef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ef2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ef5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef8:	89 c7                	mov    %eax,%edi
  802efa:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802f01:	00 00 00 
  802f04:	ff d0                	callq  *%rax
  802f06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0d:	79 05                	jns    802f14 <listen+0x2d>
		return r;
  802f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f12:	eb 16                	jmp    802f2a <listen+0x43>
	return nsipc_listen(r, backlog);
  802f14:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1a:	89 d6                	mov    %edx,%esi
  802f1c:	89 c7                	mov    %eax,%edi
  802f1e:	48 b8 56 32 80 00 00 	movabs $0x803256,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
}
  802f2a:	c9                   	leaveq 
  802f2b:	c3                   	retq   

0000000000802f2c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802f2c:	55                   	push   %rbp
  802f2d:	48 89 e5             	mov    %rsp,%rbp
  802f30:	48 83 ec 20          	sub    $0x20,%rsp
  802f34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f3c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f44:	89 c2                	mov    %eax,%edx
  802f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4a:	8b 40 0c             	mov    0xc(%rax),%eax
  802f4d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802f51:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f56:	89 c7                	mov    %eax,%edi
  802f58:	48 b8 96 32 80 00 00 	movabs $0x803296,%rax
  802f5f:	00 00 00 
  802f62:	ff d0                	callq  *%rax
}
  802f64:	c9                   	leaveq 
  802f65:	c3                   	retq   

0000000000802f66 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802f66:	55                   	push   %rbp
  802f67:	48 89 e5             	mov    %rsp,%rbp
  802f6a:	48 83 ec 20          	sub    $0x20,%rsp
  802f6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f76:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802f7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7e:	89 c2                	mov    %eax,%edx
  802f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f84:	8b 40 0c             	mov    0xc(%rax),%eax
  802f87:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802f8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f90:	89 c7                	mov    %eax,%edi
  802f92:	48 b8 62 33 80 00 00 	movabs $0x803362,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
}
  802f9e:	c9                   	leaveq 
  802f9f:	c3                   	retq   

0000000000802fa0 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802fa0:	55                   	push   %rbp
  802fa1:	48 89 e5             	mov    %rsp,%rbp
  802fa4:	48 83 ec 10          	sub    $0x10,%rsp
  802fa8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802fb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb4:	48 be a7 46 80 00 00 	movabs $0x8046a7,%rsi
  802fbb:	00 00 00 
  802fbe:	48 89 c7             	mov    %rax,%rdi
  802fc1:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
	return 0;
  802fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fd2:	c9                   	leaveq 
  802fd3:	c3                   	retq   

0000000000802fd4 <socket>:

int
socket(int domain, int type, int protocol)
{
  802fd4:	55                   	push   %rbp
  802fd5:	48 89 e5             	mov    %rsp,%rbp
  802fd8:	48 83 ec 20          	sub    $0x20,%rsp
  802fdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fdf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802fe2:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802fe5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fe8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802feb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fee:	89 ce                	mov    %ecx,%esi
  802ff0:	89 c7                	mov    %eax,%edi
  802ff2:	48 b8 1a 34 80 00 00 	movabs $0x80341a,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
  802ffe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803001:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803005:	79 05                	jns    80300c <socket+0x38>
		return r;
  803007:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300a:	eb 11                	jmp    80301d <socket+0x49>
	return alloc_sockfd(r);
  80300c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
}
  80301d:	c9                   	leaveq 
  80301e:	c3                   	retq   

000000000080301f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80301f:	55                   	push   %rbp
  803020:	48 89 e5             	mov    %rsp,%rbp
  803023:	48 83 ec 10          	sub    $0x10,%rsp
  803027:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80302a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803031:	00 00 00 
  803034:	8b 00                	mov    (%rax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	75 1f                	jne    803059 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80303a:	bf 02 00 00 00       	mov    $0x2,%edi
  80303f:	48 b8 44 3f 80 00 00 	movabs $0x803f44,%rax
  803046:	00 00 00 
  803049:	ff d0                	callq  *%rax
  80304b:	89 c2                	mov    %eax,%edx
  80304d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803054:	00 00 00 
  803057:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803059:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803060:	00 00 00 
  803063:	8b 00                	mov    (%rax),%eax
  803065:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803068:	b9 07 00 00 00       	mov    $0x7,%ecx
  80306d:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803074:	00 00 00 
  803077:	89 c7                	mov    %eax,%edi
  803079:	48 b8 af 3e 80 00 00 	movabs $0x803eaf,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803085:	ba 00 00 00 00       	mov    $0x0,%edx
  80308a:	be 00 00 00 00       	mov    $0x0,%esi
  80308f:	bf 00 00 00 00       	mov    $0x0,%edi
  803094:	48 b8 ee 3d 80 00 00 	movabs $0x803dee,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
  8030a6:	48 83 ec 30          	sub    $0x30,%rsp
  8030aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8030b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030bc:	00 00 00 
  8030bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030c2:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8030c4:	bf 01 00 00 00       	mov    $0x1,%edi
  8030c9:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  8030d0:	00 00 00 
  8030d3:	ff d0                	callq  *%rax
  8030d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030dc:	78 3e                	js     80311c <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8030de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030e5:	00 00 00 
  8030e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8030ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f0:	8b 40 10             	mov    0x10(%rax),%eax
  8030f3:	89 c2                	mov    %eax,%edx
  8030f5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030fd:	48 89 ce             	mov    %rcx,%rsi
  803100:	48 89 c7             	mov    %rax,%rdi
  803103:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	8b 50 10             	mov    0x10(%rax),%edx
  803116:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311a:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80311c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80311f:	c9                   	leaveq 
  803120:	c3                   	retq   

0000000000803121 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803121:	55                   	push   %rbp
  803122:	48 89 e5             	mov    %rsp,%rbp
  803125:	48 83 ec 10          	sub    $0x10,%rsp
  803129:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80312c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803130:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803133:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80313a:	00 00 00 
  80313d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803140:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803142:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803149:	48 89 c6             	mov    %rax,%rsi
  80314c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803153:	00 00 00 
  803156:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803162:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803169:	00 00 00 
  80316c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80316f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803172:	bf 02 00 00 00       	mov    $0x2,%edi
  803177:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  80317e:	00 00 00 
  803181:	ff d0                	callq  *%rax
}
  803183:	c9                   	leaveq 
  803184:	c3                   	retq   

0000000000803185 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803185:	55                   	push   %rbp
  803186:	48 89 e5             	mov    %rsp,%rbp
  803189:	48 83 ec 10          	sub    $0x10,%rsp
  80318d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803190:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803193:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80319a:	00 00 00 
  80319d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031a0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8031a2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031a9:	00 00 00 
  8031ac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8031b2:	bf 03 00 00 00       	mov    $0x3,%edi
  8031b7:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
}
  8031c3:	c9                   	leaveq 
  8031c4:	c3                   	retq   

00000000008031c5 <nsipc_close>:

int
nsipc_close(int s)
{
  8031c5:	55                   	push   %rbp
  8031c6:	48 89 e5             	mov    %rsp,%rbp
  8031c9:	48 83 ec 10          	sub    $0x10,%rsp
  8031cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8031d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d7:	00 00 00 
  8031da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031dd:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8031df:	bf 04 00 00 00       	mov    $0x4,%edi
  8031e4:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	callq  *%rax
}
  8031f0:	c9                   	leaveq 
  8031f1:	c3                   	retq   

00000000008031f2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8031f2:	55                   	push   %rbp
  8031f3:	48 89 e5             	mov    %rsp,%rbp
  8031f6:	48 83 ec 10          	sub    $0x10,%rsp
  8031fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803201:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803204:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80320b:	00 00 00 
  80320e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803211:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803213:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321a:	48 89 c6             	mov    %rax,%rsi
  80321d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803224:	00 00 00 
  803227:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803233:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80323a:	00 00 00 
  80323d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803240:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803243:	bf 05 00 00 00       	mov    $0x5,%edi
  803248:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
}
  803254:	c9                   	leaveq 
  803255:	c3                   	retq   

0000000000803256 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803256:	55                   	push   %rbp
  803257:	48 89 e5             	mov    %rsp,%rbp
  80325a:	48 83 ec 10          	sub    $0x10,%rsp
  80325e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803261:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803264:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80326b:	00 00 00 
  80326e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803271:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803273:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80327a:	00 00 00 
  80327d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803280:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803283:	bf 06 00 00 00       	mov    $0x6,%edi
  803288:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  80328f:	00 00 00 
  803292:	ff d0                	callq  *%rax
}
  803294:	c9                   	leaveq 
  803295:	c3                   	retq   

0000000000803296 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803296:	55                   	push   %rbp
  803297:	48 89 e5             	mov    %rsp,%rbp
  80329a:	48 83 ec 30          	sub    $0x30,%rsp
  80329e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032a5:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8032a8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8032ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b2:	00 00 00 
  8032b5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8032ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032c1:	00 00 00 
  8032c4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8032ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d1:	00 00 00 
  8032d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032d7:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8032da:	bf 07 00 00 00       	mov    $0x7,%edi
  8032df:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
  8032eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f2:	78 69                	js     80335d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8032f4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8032fb:	7f 08                	jg     803305 <nsipc_recv+0x6f>
  8032fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803300:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803303:	7e 35                	jle    80333a <nsipc_recv+0xa4>
  803305:	48 b9 ae 46 80 00 00 	movabs $0x8046ae,%rcx
  80330c:	00 00 00 
  80330f:	48 ba c3 46 80 00 00 	movabs $0x8046c3,%rdx
  803316:	00 00 00 
  803319:	be 62 00 00 00       	mov    $0x62,%esi
  80331e:	48 bf d8 46 80 00 00 	movabs $0x8046d8,%rdi
  803325:	00 00 00 
  803328:	b8 00 00 00 00       	mov    $0x0,%eax
  80332d:	49 b8 da 3c 80 00 00 	movabs $0x803cda,%r8
  803334:	00 00 00 
  803337:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80333a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333d:	48 63 d0             	movslq %eax,%rdx
  803340:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803344:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80334b:	00 00 00 
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
	}

	return r;
  80335d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803360:	c9                   	leaveq 
  803361:	c3                   	retq   

0000000000803362 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803362:	55                   	push   %rbp
  803363:	48 89 e5             	mov    %rsp,%rbp
  803366:	48 83 ec 20          	sub    $0x20,%rsp
  80336a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80336d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803371:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803374:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803377:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80337e:	00 00 00 
  803381:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803384:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803386:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80338d:	7e 35                	jle    8033c4 <nsipc_send+0x62>
  80338f:	48 b9 e4 46 80 00 00 	movabs $0x8046e4,%rcx
  803396:	00 00 00 
  803399:	48 ba c3 46 80 00 00 	movabs $0x8046c3,%rdx
  8033a0:	00 00 00 
  8033a3:	be 6d 00 00 00       	mov    $0x6d,%esi
  8033a8:	48 bf d8 46 80 00 00 	movabs $0x8046d8,%rdi
  8033af:	00 00 00 
  8033b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b7:	49 b8 da 3c 80 00 00 	movabs $0x803cda,%r8
  8033be:	00 00 00 
  8033c1:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8033c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c7:	48 63 d0             	movslq %eax,%rdx
  8033ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ce:	48 89 c6             	mov    %rax,%rsi
  8033d1:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8033d8:	00 00 00 
  8033db:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8033e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ee:	00 00 00 
  8033f1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8033f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033fe:	00 00 00 
  803401:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803404:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803407:	bf 08 00 00 00       	mov    $0x8,%edi
  80340c:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  803413:	00 00 00 
  803416:	ff d0                	callq  *%rax
}
  803418:	c9                   	leaveq 
  803419:	c3                   	retq   

000000000080341a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80341a:	55                   	push   %rbp
  80341b:	48 89 e5             	mov    %rsp,%rbp
  80341e:	48 83 ec 10          	sub    $0x10,%rsp
  803422:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803425:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803428:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80342b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803432:	00 00 00 
  803435:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803438:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80343a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803441:	00 00 00 
  803444:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803447:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80344a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803451:	00 00 00 
  803454:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803457:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80345a:	bf 09 00 00 00       	mov    $0x9,%edi
  80345f:	48 b8 1f 30 80 00 00 	movabs $0x80301f,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
}
  80346b:	c9                   	leaveq 
  80346c:	c3                   	retq   

000000000080346d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80346d:	55                   	push   %rbp
  80346e:	48 89 e5             	mov    %rsp,%rbp
  803471:	53                   	push   %rbx
  803472:	48 83 ec 38          	sub    $0x38,%rsp
  803476:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80347a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80347e:	48 89 c7             	mov    %rax,%rdi
  803481:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  803488:	00 00 00 
  80348b:	ff d0                	callq  *%rax
  80348d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803490:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803494:	0f 88 bf 01 00 00    	js     803659 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80349a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349e:	ba 07 04 00 00       	mov    $0x407,%edx
  8034a3:	48 89 c6             	mov    %rax,%rsi
  8034a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ab:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034be:	0f 88 95 01 00 00    	js     803659 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8034c4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034c8:	48 89 c7             	mov    %rax,%rdi
  8034cb:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
  8034d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034da:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034de:	0f 88 5d 01 00 00    	js     803641 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8034ed:	48 89 c6             	mov    %rax,%rsi
  8034f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f5:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
  803501:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803504:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803508:	0f 88 33 01 00 00    	js     803641 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80350e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
  803521:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803525:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803529:	ba 07 04 00 00       	mov    $0x407,%edx
  80352e:	48 89 c6             	mov    %rax,%rsi
  803531:	bf 00 00 00 00       	mov    $0x0,%edi
  803536:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803545:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803549:	0f 88 d9 00 00 00    	js     803628 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80354f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803553:	48 89 c7             	mov    %rax,%rdi
  803556:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  80355d:	00 00 00 
  803560:	ff d0                	callq  *%rax
  803562:	48 89 c2             	mov    %rax,%rdx
  803565:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803569:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80356f:	48 89 d1             	mov    %rdx,%rcx
  803572:	ba 00 00 00 00       	mov    $0x0,%edx
  803577:	48 89 c6             	mov    %rax,%rsi
  80357a:	bf 00 00 00 00       	mov    $0x0,%edi
  80357f:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80358e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803592:	78 79                	js     80360d <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803598:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80359f:	00 00 00 
  8035a2:	8b 12                	mov    (%rdx),%edx
  8035a4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8035a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8035b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035bc:	00 00 00 
  8035bf:	8b 12                	mov    (%rdx),%edx
  8035c1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8035c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8035ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d2:	48 89 c7             	mov    %rax,%rdi
  8035d5:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  8035dc:	00 00 00 
  8035df:	ff d0                	callq  *%rax
  8035e1:	89 c2                	mov    %eax,%edx
  8035e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035e7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8035e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035ed:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8035f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f5:	48 89 c7             	mov    %rax,%rdi
  8035f8:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
  803604:	89 03                	mov    %eax,(%rbx)
	return 0;
  803606:	b8 00 00 00 00       	mov    $0x0,%eax
  80360b:	eb 4f                	jmp    80365c <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80360d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80360e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803612:	48 89 c6             	mov    %rax,%rsi
  803615:	bf 00 00 00 00       	mov    $0x0,%edi
  80361a:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
  803626:	eb 01                	jmp    803629 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803628:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803629:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80362d:	48 89 c6             	mov    %rax,%rsi
  803630:	bf 00 00 00 00       	mov    $0x0,%edi
  803635:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803645:	48 89 c6             	mov    %rax,%rsi
  803648:	bf 00 00 00 00       	mov    $0x0,%edi
  80364d:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803654:	00 00 00 
  803657:	ff d0                	callq  *%rax
err:
	return r;
  803659:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80365c:	48 83 c4 38          	add    $0x38,%rsp
  803660:	5b                   	pop    %rbx
  803661:	5d                   	pop    %rbp
  803662:	c3                   	retq   

0000000000803663 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803663:	55                   	push   %rbp
  803664:	48 89 e5             	mov    %rsp,%rbp
  803667:	53                   	push   %rbx
  803668:	48 83 ec 28          	sub    $0x28,%rsp
  80366c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803670:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803674:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80367b:	00 00 00 
  80367e:	48 8b 00             	mov    (%rax),%rax
  803681:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803687:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80368a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368e:	48 89 c7             	mov    %rax,%rdi
  803691:	48 b8 b5 3f 80 00 00 	movabs $0x803fb5,%rax
  803698:	00 00 00 
  80369b:	ff d0                	callq  *%rax
  80369d:	89 c3                	mov    %eax,%ebx
  80369f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036a3:	48 89 c7             	mov    %rax,%rdi
  8036a6:	48 b8 b5 3f 80 00 00 	movabs $0x803fb5,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
  8036b2:	39 c3                	cmp    %eax,%ebx
  8036b4:	0f 94 c0             	sete   %al
  8036b7:	0f b6 c0             	movzbl %al,%eax
  8036ba:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8036bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036c4:	00 00 00 
  8036c7:	48 8b 00             	mov    (%rax),%rax
  8036ca:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036d0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8036d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036d9:	75 05                	jne    8036e0 <_pipeisclosed+0x7d>
			return ret;
  8036db:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036de:	eb 4a                	jmp    80372a <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8036e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036e6:	74 8c                	je     803674 <_pipeisclosed+0x11>
  8036e8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8036ec:	75 86                	jne    803674 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8036ee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036f5:	00 00 00 
  8036f8:	48 8b 00             	mov    (%rax),%rax
  8036fb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803701:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803704:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803707:	89 c6                	mov    %eax,%esi
  803709:	48 bf f5 46 80 00 00 	movabs $0x8046f5,%rdi
  803710:	00 00 00 
  803713:	b8 00 00 00 00       	mov    $0x0,%eax
  803718:	49 b8 6e 02 80 00 00 	movabs $0x80026e,%r8
  80371f:	00 00 00 
  803722:	41 ff d0             	callq  *%r8
	}
  803725:	e9 4a ff ff ff       	jmpq   803674 <_pipeisclosed+0x11>

}
  80372a:	48 83 c4 28          	add    $0x28,%rsp
  80372e:	5b                   	pop    %rbx
  80372f:	5d                   	pop    %rbp
  803730:	c3                   	retq   

0000000000803731 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803731:	55                   	push   %rbp
  803732:	48 89 e5             	mov    %rsp,%rbp
  803735:	48 83 ec 30          	sub    $0x30,%rsp
  803739:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80373c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803740:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803743:	48 89 d6             	mov    %rdx,%rsi
  803746:	89 c7                	mov    %eax,%edi
  803748:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803757:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375b:	79 05                	jns    803762 <pipeisclosed+0x31>
		return r;
  80375d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803760:	eb 31                	jmp    803793 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803766:	48 89 c7             	mov    %rax,%rdi
  803769:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
  803775:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803781:	48 89 d6             	mov    %rdx,%rsi
  803784:	48 89 c7             	mov    %rax,%rdi
  803787:	48 b8 63 36 80 00 00 	movabs $0x803663,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
}
  803793:	c9                   	leaveq 
  803794:	c3                   	retq   

0000000000803795 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803795:	55                   	push   %rbp
  803796:	48 89 e5             	mov    %rsp,%rbp
  803799:	48 83 ec 40          	sub    $0x40,%rsp
  80379d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ad:	48 89 c7             	mov    %rax,%rdi
  8037b0:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  8037b7:	00 00 00 
  8037ba:	ff d0                	callq  *%rax
  8037bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037c8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037cf:	00 
  8037d0:	e9 90 00 00 00       	jmpq   803865 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8037d5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8037da:	74 09                	je     8037e5 <devpipe_read+0x50>
				return i;
  8037dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e0:	e9 8e 00 00 00       	jmpq   803873 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8037e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ed:	48 89 d6             	mov    %rdx,%rsi
  8037f0:	48 89 c7             	mov    %rax,%rdi
  8037f3:	48 b8 63 36 80 00 00 	movabs $0x803663,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 07                	je     80380a <devpipe_read+0x75>
				return 0;
  803803:	b8 00 00 00 00       	mov    $0x0,%eax
  803808:	eb 69                	jmp    803873 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80380a:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803816:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381a:	8b 10                	mov    (%rax),%edx
  80381c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803820:	8b 40 04             	mov    0x4(%rax),%eax
  803823:	39 c2                	cmp    %eax,%edx
  803825:	74 ae                	je     8037d5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80382b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803837:	8b 00                	mov    (%rax),%eax
  803839:	99                   	cltd   
  80383a:	c1 ea 1b             	shr    $0x1b,%edx
  80383d:	01 d0                	add    %edx,%eax
  80383f:	83 e0 1f             	and    $0x1f,%eax
  803842:	29 d0                	sub    %edx,%eax
  803844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803848:	48 98                	cltq   
  80384a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80384f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803851:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803855:	8b 00                	mov    (%rax),%eax
  803857:	8d 50 01             	lea    0x1(%rax),%edx
  80385a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803860:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803869:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80386d:	72 a7                	jb     803816 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80386f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803873:	c9                   	leaveq 
  803874:	c3                   	retq   

0000000000803875 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 83 ec 40          	sub    $0x40,%rsp
  80387d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803881:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803885:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388d:	48 89 c7             	mov    %rax,%rdi
  803890:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
  80389c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038a8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038af:	00 
  8038b0:	e9 8f 00 00 00       	jmpq   803944 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8038b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bd:	48 89 d6             	mov    %rdx,%rsi
  8038c0:	48 89 c7             	mov    %rax,%rdi
  8038c3:	48 b8 63 36 80 00 00 	movabs $0x803663,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	74 07                	je     8038da <devpipe_write+0x65>
				return 0;
  8038d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d8:	eb 78                	jmp    803952 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8038da:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ea:	8b 40 04             	mov    0x4(%rax),%eax
  8038ed:	48 63 d0             	movslq %eax,%rdx
  8038f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f4:	8b 00                	mov    (%rax),%eax
  8038f6:	48 98                	cltq   
  8038f8:	48 83 c0 20          	add    $0x20,%rax
  8038fc:	48 39 c2             	cmp    %rax,%rdx
  8038ff:	73 b4                	jae    8038b5 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803905:	8b 40 04             	mov    0x4(%rax),%eax
  803908:	99                   	cltd   
  803909:	c1 ea 1b             	shr    $0x1b,%edx
  80390c:	01 d0                	add    %edx,%eax
  80390e:	83 e0 1f             	and    $0x1f,%eax
  803911:	29 d0                	sub    %edx,%eax
  803913:	89 c6                	mov    %eax,%esi
  803915:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391d:	48 01 d0             	add    %rdx,%rax
  803920:	0f b6 08             	movzbl (%rax),%ecx
  803923:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803927:	48 63 c6             	movslq %esi,%rax
  80392a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80392e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803932:	8b 40 04             	mov    0x4(%rax),%eax
  803935:	8d 50 01             	lea    0x1(%rax),%edx
  803938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80393f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803944:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803948:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80394c:	72 98                	jb     8038e6 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80394e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803952:	c9                   	leaveq 
  803953:	c3                   	retq   

0000000000803954 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803954:	55                   	push   %rbp
  803955:	48 89 e5             	mov    %rsp,%rbp
  803958:	48 83 ec 20          	sub    $0x20,%rsp
  80395c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803960:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803968:	48 89 c7             	mov    %rax,%rdi
  80396b:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80397b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397f:	48 be 08 47 80 00 00 	movabs $0x804708,%rsi
  803986:	00 00 00 
  803989:	48 89 c7             	mov    %rax,%rdi
  80398c:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399c:	8b 50 04             	mov    0x4(%rax),%edx
  80399f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a3:	8b 00                	mov    (%rax),%eax
  8039a5:	29 c2                	sub    %eax,%edx
  8039a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ab:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8039b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8039bc:	00 00 00 
	stat->st_dev = &devpipe;
  8039bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c3:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8039ca:	00 00 00 
  8039cd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8039d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039d9:	c9                   	leaveq 
  8039da:	c3                   	retq   

00000000008039db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8039db:	55                   	push   %rbp
  8039dc:	48 89 e5             	mov    %rsp,%rbp
  8039df:	48 83 ec 10          	sub    $0x10,%rsp
  8039e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8039e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039eb:	48 89 c6             	mov    %rax,%rsi
  8039ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f3:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8039ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a03:	48 89 c7             	mov    %rax,%rdi
  803a06:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  803a0d:	00 00 00 
  803a10:	ff d0                	callq  *%rax
  803a12:	48 89 c6             	mov    %rax,%rsi
  803a15:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1a:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  803a21:	00 00 00 
  803a24:	ff d0                	callq  *%rax
}
  803a26:	c9                   	leaveq 
  803a27:	c3                   	retq   

0000000000803a28 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a28:	55                   	push   %rbp
  803a29:	48 89 e5             	mov    %rsp,%rbp
  803a2c:	48 83 ec 20          	sub    $0x20,%rsp
  803a30:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a36:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a39:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a3d:	be 01 00 00 00       	mov    $0x1,%esi
  803a42:	48 89 c7             	mov    %rax,%rdi
  803a45:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  803a4c:	00 00 00 
  803a4f:	ff d0                	callq  *%rax
}
  803a51:	90                   	nop
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   

0000000000803a54 <getchar>:

int
getchar(void)
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a5c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a60:	ba 01 00 00 00       	mov    $0x1,%edx
  803a65:	48 89 c6             	mov    %rax,%rsi
  803a68:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6d:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
  803a79:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a80:	79 05                	jns    803a87 <getchar+0x33>
		return r;
  803a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a85:	eb 14                	jmp    803a9b <getchar+0x47>
	if (r < 1)
  803a87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a8b:	7f 07                	jg     803a94 <getchar+0x40>
		return -E_EOF;
  803a8d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803a92:	eb 07                	jmp    803a9b <getchar+0x47>
	return c;
  803a94:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803a98:	0f b6 c0             	movzbl %al,%eax

}
  803a9b:	c9                   	leaveq 
  803a9c:	c3                   	retq   

0000000000803a9d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803a9d:	55                   	push   %rbp
  803a9e:	48 89 e5             	mov    %rsp,%rbp
  803aa1:	48 83 ec 20          	sub    $0x20,%rsp
  803aa5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803aa8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803aac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aaf:	48 89 d6             	mov    %rdx,%rsi
  803ab2:	89 c7                	mov    %eax,%edi
  803ab4:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
  803ac0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac7:	79 05                	jns    803ace <iscons+0x31>
		return r;
  803ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803acc:	eb 1a                	jmp    803ae8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ace:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad2:	8b 10                	mov    (%rax),%edx
  803ad4:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803adb:	00 00 00 
  803ade:	8b 00                	mov    (%rax),%eax
  803ae0:	39 c2                	cmp    %eax,%edx
  803ae2:	0f 94 c0             	sete   %al
  803ae5:	0f b6 c0             	movzbl %al,%eax
}
  803ae8:	c9                   	leaveq 
  803ae9:	c3                   	retq   

0000000000803aea <opencons>:

int
opencons(void)
{
  803aea:	55                   	push   %rbp
  803aeb:	48 89 e5             	mov    %rsp,%rbp
  803aee:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803af2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803af6:	48 89 c7             	mov    %rax,%rdi
  803af9:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
  803b05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b0c:	79 05                	jns    803b13 <opencons+0x29>
		return r;
  803b0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b11:	eb 5b                	jmp    803b6e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b17:	ba 07 04 00 00       	mov    $0x407,%edx
  803b1c:	48 89 c6             	mov    %rax,%rsi
  803b1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b24:	48 b8 34 17 80 00 00 	movabs $0x801734,%rax
  803b2b:	00 00 00 
  803b2e:	ff d0                	callq  *%rax
  803b30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b37:	79 05                	jns    803b3e <opencons+0x54>
		return r;
  803b39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3c:	eb 30                	jmp    803b6e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b42:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803b49:	00 00 00 
  803b4c:	8b 12                	mov    (%rdx),%edx
  803b4e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b54:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5f:	48 89 c7             	mov    %rax,%rdi
  803b62:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  803b69:	00 00 00 
  803b6c:	ff d0                	callq  *%rax
}
  803b6e:	c9                   	leaveq 
  803b6f:	c3                   	retq   

0000000000803b70 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b70:	55                   	push   %rbp
  803b71:	48 89 e5             	mov    %rsp,%rbp
  803b74:	48 83 ec 30          	sub    $0x30,%rsp
  803b78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803b84:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b89:	75 13                	jne    803b9e <devcons_read+0x2e>
		return 0;
  803b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b90:	eb 49                	jmp    803bdb <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803b92:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b9e:	48 b8 39 16 80 00 00 	movabs $0x801639,%rax
  803ba5:	00 00 00 
  803ba8:	ff d0                	callq  *%rax
  803baa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb1:	74 df                	je     803b92 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803bb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb7:	79 05                	jns    803bbe <devcons_read+0x4e>
		return c;
  803bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbc:	eb 1d                	jmp    803bdb <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803bbe:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803bc2:	75 07                	jne    803bcb <devcons_read+0x5b>
		return 0;
  803bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc9:	eb 10                	jmp    803bdb <devcons_read+0x6b>
	*(char*)vbuf = c;
  803bcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bce:	89 c2                	mov    %eax,%edx
  803bd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd4:	88 10                	mov    %dl,(%rax)
	return 1;
  803bd6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803bdb:	c9                   	leaveq 
  803bdc:	c3                   	retq   

0000000000803bdd <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bdd:	55                   	push   %rbp
  803bde:	48 89 e5             	mov    %rsp,%rbp
  803be1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803be8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803bef:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803bf6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c04:	eb 76                	jmp    803c7c <devcons_write+0x9f>
		m = n - tot;
  803c06:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c0d:	89 c2                	mov    %eax,%edx
  803c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c12:	29 c2                	sub    %eax,%edx
  803c14:	89 d0                	mov    %edx,%eax
  803c16:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c1c:	83 f8 7f             	cmp    $0x7f,%eax
  803c1f:	76 07                	jbe    803c28 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c21:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c2b:	48 63 d0             	movslq %eax,%rdx
  803c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c31:	48 63 c8             	movslq %eax,%rcx
  803c34:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c3b:	48 01 c1             	add    %rax,%rcx
  803c3e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c45:	48 89 ce             	mov    %rcx,%rsi
  803c48:	48 89 c7             	mov    %rax,%rdi
  803c4b:	48 b8 23 11 80 00 00 	movabs $0x801123,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5a:	48 63 d0             	movslq %eax,%rdx
  803c5d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c64:	48 89 d6             	mov    %rdx,%rsi
  803c67:	48 89 c7             	mov    %rax,%rdi
  803c6a:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  803c71:	00 00 00 
  803c74:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c79:	01 45 fc             	add    %eax,-0x4(%rbp)
  803c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7f:	48 98                	cltq   
  803c81:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803c88:	0f 82 78 ff ff ff    	jb     803c06 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c91:	c9                   	leaveq 
  803c92:	c3                   	retq   

0000000000803c93 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803c93:	55                   	push   %rbp
  803c94:	48 89 e5             	mov    %rsp,%rbp
  803c97:	48 83 ec 08          	sub    $0x8,%rsp
  803c9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ca4:	c9                   	leaveq 
  803ca5:	c3                   	retq   

0000000000803ca6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ca6:	55                   	push   %rbp
  803ca7:	48 89 e5             	mov    %rsp,%rbp
  803caa:	48 83 ec 10          	sub    $0x10,%rsp
  803cae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cb2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cba:	48 be 14 47 80 00 00 	movabs $0x804714,%rsi
  803cc1:	00 00 00 
  803cc4:	48 89 c7             	mov    %rax,%rdi
  803cc7:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  803cce:	00 00 00 
  803cd1:	ff d0                	callq  *%rax
	return 0;
  803cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cd8:	c9                   	leaveq 
  803cd9:	c3                   	retq   

0000000000803cda <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803cda:	55                   	push   %rbp
  803cdb:	48 89 e5             	mov    %rsp,%rbp
  803cde:	53                   	push   %rbx
  803cdf:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ce6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ced:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803cf3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803cfa:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803d01:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803d08:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803d0f:	84 c0                	test   %al,%al
  803d11:	74 23                	je     803d36 <_panic+0x5c>
  803d13:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803d1a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803d1e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803d22:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803d26:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803d2a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803d2e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803d32:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803d36:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803d3d:	00 00 00 
  803d40:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803d47:	00 00 00 
  803d4a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803d4e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803d55:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803d5c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803d63:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803d6a:	00 00 00 
  803d6d:	48 8b 18             	mov    (%rax),%rbx
  803d70:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  803d77:	00 00 00 
  803d7a:	ff d0                	callq  *%rax
  803d7c:	89 c6                	mov    %eax,%esi
  803d7e:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803d84:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803d8b:	41 89 d0             	mov    %edx,%r8d
  803d8e:	48 89 c1             	mov    %rax,%rcx
  803d91:	48 89 da             	mov    %rbx,%rdx
  803d94:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  803d9b:	00 00 00 
  803d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803da3:	49 b9 6e 02 80 00 00 	movabs $0x80026e,%r9
  803daa:	00 00 00 
  803dad:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803db0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803db7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803dbe:	48 89 d6             	mov    %rdx,%rsi
  803dc1:	48 89 c7             	mov    %rax,%rdi
  803dc4:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  803dcb:	00 00 00 
  803dce:	ff d0                	callq  *%rax
	cprintf("\n");
  803dd0:	48 bf 43 47 80 00 00 	movabs $0x804743,%rdi
  803dd7:	00 00 00 
  803dda:	b8 00 00 00 00       	mov    $0x0,%eax
  803ddf:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  803de6:	00 00 00 
  803de9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803deb:	cc                   	int3   
  803dec:	eb fd                	jmp    803deb <_panic+0x111>

0000000000803dee <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803dee:	55                   	push   %rbp
  803def:	48 89 e5             	mov    %rsp,%rbp
  803df2:	48 83 ec 30          	sub    $0x30,%rsp
  803df6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803dfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dfe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803e02:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e07:	75 0e                	jne    803e17 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803e09:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e10:	00 00 00 
  803e13:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803e17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e1b:	48 89 c7             	mov    %rax,%rdi
  803e1e:	48 b8 6e 19 80 00 00 	movabs $0x80196e,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
  803e2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e31:	79 27                	jns    803e5a <ipc_recv+0x6c>
		if (from_env_store)
  803e33:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e38:	74 0a                	je     803e44 <ipc_recv+0x56>
			*from_env_store = 0;
  803e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e3e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803e44:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e49:	74 0a                	je     803e55 <ipc_recv+0x67>
			*perm_store = 0;
  803e4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e4f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e58:	eb 53                	jmp    803ead <ipc_recv+0xbf>
	}
	if (from_env_store)
  803e5a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e5f:	74 19                	je     803e7a <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803e61:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e68:	00 00 00 
  803e6b:	48 8b 00             	mov    (%rax),%rax
  803e6e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e78:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803e7a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e7f:	74 19                	je     803e9a <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803e81:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e88:	00 00 00 
  803e8b:	48 8b 00             	mov    (%rax),%rax
  803e8e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e98:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803e9a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ea1:	00 00 00 
  803ea4:	48 8b 00             	mov    (%rax),%rax
  803ea7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803ead:	c9                   	leaveq 
  803eae:	c3                   	retq   

0000000000803eaf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803eaf:	55                   	push   %rbp
  803eb0:	48 89 e5             	mov    %rsp,%rbp
  803eb3:	48 83 ec 30          	sub    $0x30,%rsp
  803eb7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803eba:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ebd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ec1:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803ec4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ec9:	75 1c                	jne    803ee7 <ipc_send+0x38>
		pg = (void*) UTOP;
  803ecb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ed2:	00 00 00 
  803ed5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803ed9:	eb 0c                	jmp    803ee7 <ipc_send+0x38>
		sys_yield();
  803edb:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  803ee2:	00 00 00 
  803ee5:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803ee7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803eea:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803eed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ef1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ef4:	89 c7                	mov    %eax,%edi
  803ef6:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  803efd:	00 00 00 
  803f00:	ff d0                	callq  *%rax
  803f02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f05:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f09:	74 d0                	je     803edb <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  803f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0f:	79 30                	jns    803f41 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  803f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f14:	89 c1                	mov    %eax,%ecx
  803f16:	48 ba 45 47 80 00 00 	movabs $0x804745,%rdx
  803f1d:	00 00 00 
  803f20:	be 47 00 00 00       	mov    $0x47,%esi
  803f25:	48 bf 5b 47 80 00 00 	movabs $0x80475b,%rdi
  803f2c:	00 00 00 
  803f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f34:	49 b8 da 3c 80 00 00 	movabs $0x803cda,%r8
  803f3b:	00 00 00 
  803f3e:	41 ff d0             	callq  *%r8

}
  803f41:	90                   	nop
  803f42:	c9                   	leaveq 
  803f43:	c3                   	retq   

0000000000803f44 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f44:	55                   	push   %rbp
  803f45:	48 89 e5             	mov    %rsp,%rbp
  803f48:	48 83 ec 18          	sub    $0x18,%rsp
  803f4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f56:	eb 4d                	jmp    803fa5 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  803f58:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f5f:	00 00 00 
  803f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f65:	48 98                	cltq   
  803f67:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f6e:	48 01 d0             	add    %rdx,%rax
  803f71:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f77:	8b 00                	mov    (%rax),%eax
  803f79:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f7c:	75 23                	jne    803fa1 <ipc_find_env+0x5d>
			return envs[i].env_id;
  803f7e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f85:	00 00 00 
  803f88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f8b:	48 98                	cltq   
  803f8d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f94:	48 01 d0             	add    %rdx,%rax
  803f97:	48 05 c8 00 00 00    	add    $0xc8,%rax
  803f9d:	8b 00                	mov    (%rax),%eax
  803f9f:	eb 12                	jmp    803fb3 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803fa1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803fa5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803fac:	7e aa                	jle    803f58 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fb3:	c9                   	leaveq 
  803fb4:	c3                   	retq   

0000000000803fb5 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  803fb5:	55                   	push   %rbp
  803fb6:	48 89 e5             	mov    %rsp,%rbp
  803fb9:	48 83 ec 18          	sub    $0x18,%rsp
  803fbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fc5:	48 c1 e8 15          	shr    $0x15,%rax
  803fc9:	48 89 c2             	mov    %rax,%rdx
  803fcc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803fd3:	01 00 00 
  803fd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fda:	83 e0 01             	and    $0x1,%eax
  803fdd:	48 85 c0             	test   %rax,%rax
  803fe0:	75 07                	jne    803fe9 <pageref+0x34>
		return 0;
  803fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe7:	eb 56                	jmp    80403f <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  803fe9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fed:	48 c1 e8 0c          	shr    $0xc,%rax
  803ff1:	48 89 c2             	mov    %rax,%rdx
  803ff4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ffb:	01 00 00 
  803ffe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804002:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804006:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80400a:	83 e0 01             	and    $0x1,%eax
  80400d:	48 85 c0             	test   %rax,%rax
  804010:	75 07                	jne    804019 <pageref+0x64>
		return 0;
  804012:	b8 00 00 00 00       	mov    $0x0,%eax
  804017:	eb 26                	jmp    80403f <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804019:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80401d:	48 c1 e8 0c          	shr    $0xc,%rax
  804021:	48 89 c2             	mov    %rax,%rdx
  804024:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80402b:	00 00 00 
  80402e:	48 c1 e2 04          	shl    $0x4,%rdx
  804032:	48 01 d0             	add    %rdx,%rax
  804035:	48 83 c0 08          	add    $0x8,%rax
  804039:	0f b7 00             	movzwl (%rax),%eax
  80403c:	0f b7 c0             	movzwl %ax,%eax
}
  80403f:	c9                   	leaveq 
  804040:	c3                   	retq   
