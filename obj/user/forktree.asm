
obj/user/forktree:     file format elf64-x86-64


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
  80003c:	e8 2e 01 00 00       	callq  80016f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 67                	jg     8000d3 <forkchild+0x90>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 60 48 80 00 00 	movabs $0x804860,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 80 0d 80 00 00 	movabs $0x800d80,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 9c 20 80 00 00 	movabs $0x80209c,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 22                	jne    8000d4 <forkchild+0x91>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 f3 01 80 00 00 	movabs $0x8001f3,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
  8000d1:	eb 01                	jmp    8000d4 <forkchild+0x91>
forkchild(const char *cur, char branch)
{
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
		return;
  8000d3:	90                   	nop
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
	if (fork() == 0) {
		forktree(nxt);
		exit();
	}
}
  8000d4:	c9                   	leaveq 
  8000d5:	c3                   	retq   

00000000008000d6 <forktree>:

void
forktree(const char *cur)
{
  8000d6:	55                   	push   %rbp
  8000d7:	48 89 e5             	mov    %rsp,%rbp
  8000da:	48 83 ec 10          	sub    $0x10,%rsp
  8000de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000e2:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	89 c1                	mov    %eax,%ecx
  8000f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f4:	48 89 c2             	mov    %rax,%rdx
  8000f7:	89 ce                	mov    %ecx,%esi
  8000f9:	48 bf 65 48 80 00 00 	movabs $0x804865,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  80010f:	00 00 00 
  800112:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  800114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800118:	be 30 00 00 00       	mov    $0x30,%esi
  80011d:	48 89 c7             	mov    %rax,%rdi
  800120:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800127:	00 00 00 
  80012a:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  80012c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800130:	be 31 00 00 00       	mov    $0x31,%esi
  800135:	48 89 c7             	mov    %rax,%rdi
  800138:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80013f:	00 00 00 
  800142:	ff d0                	callq  *%rax
}
  800144:	90                   	nop
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <umain>:

void
umain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  800156:	48 bf 76 48 80 00 00 	movabs $0x804876,%rdi
  80015d:	00 00 00 
  800160:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  800167:	00 00 00 
  80016a:	ff d0                	callq  *%rax
}
  80016c:	90                   	nop
  80016d:	c9                   	leaveq 
  80016e:	c3                   	retq   

000000000080016f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016f:	55                   	push   %rbp
  800170:	48 89 e5             	mov    %rsp,%rbp
  800173:	48 83 ec 10          	sub    $0x10,%rsp
  800177:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80017a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  80017e:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  800185:	00 00 00 
  800188:	ff d0                	callq  *%rax
  80018a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80018f:	48 98                	cltq   
  800191:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800198:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80019f:	00 00 00 
  8001a2:	48 01 c2             	add    %rax,%rdx
  8001a5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8001ac:	00 00 00 
  8001af:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b6:	7e 14                	jle    8001cc <libmain+0x5d>
		binaryname = argv[0];
  8001b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bc:	48 8b 10             	mov    (%rax),%rdx
  8001bf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001c6:	00 00 00 
  8001c9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d3:	48 89 d6             	mov    %rdx,%rsi
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001e4:	48 b8 f3 01 80 00 00 	movabs $0x8001f3,%rax
  8001eb:	00 00 00 
  8001ee:	ff d0                	callq  *%rax
}
  8001f0:	90                   	nop
  8001f1:	c9                   	leaveq 
  8001f2:	c3                   	retq   

00000000008001f3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f3:	55                   	push   %rbp
  8001f4:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8001f7:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
  800208:	48 b8 44 17 80 00 00 	movabs $0x801744,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
}
  800214:	90                   	nop
  800215:	5d                   	pop    %rbp
  800216:	c3                   	retq   

0000000000800217 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800217:	55                   	push   %rbp
  800218:	48 89 e5             	mov    %rsp,%rbp
  80021b:	48 83 ec 10          	sub    $0x10,%rsp
  80021f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800222:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022a:	8b 00                	mov    (%rax),%eax
  80022c:	8d 48 01             	lea    0x1(%rax),%ecx
  80022f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800233:	89 0a                	mov    %ecx,(%rdx)
  800235:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800238:	89 d1                	mov    %edx,%ecx
  80023a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023e:	48 98                	cltq   
  800240:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800248:	8b 00                	mov    (%rax),%eax
  80024a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024f:	75 2c                	jne    80027d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800255:	8b 00                	mov    (%rax),%eax
  800257:	48 98                	cltq   
  800259:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80025d:	48 83 c2 08          	add    $0x8,%rdx
  800261:	48 89 c6             	mov    %rax,%rsi
  800264:	48 89 d7             	mov    %rdx,%rdi
  800267:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  80026e:	00 00 00 
  800271:	ff d0                	callq  *%rax
        b->idx = 0;
  800273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800277:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80027d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800281:	8b 40 04             	mov    0x4(%rax),%eax
  800284:	8d 50 01             	lea    0x1(%rax),%edx
  800287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80028b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028e:	90                   	nop
  80028f:	c9                   	leaveq 
  800290:	c3                   	retq   

0000000000800291 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800291:	55                   	push   %rbp
  800292:	48 89 e5             	mov    %rsp,%rbp
  800295:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80029c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002a3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002aa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002b1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b8:	48 8b 0a             	mov    (%rdx),%rcx
  8002bb:	48 89 08             	mov    %rcx,(%rax)
  8002be:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002c2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ca:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d5:	00 00 00 
    b.cnt = 0;
  8002d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002df:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002e2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f7:	48 89 c6             	mov    %rax,%rsi
  8002fa:	48 bf 17 02 80 00 00 	movabs $0x800217,%rdi
  800301:	00 00 00 
  800304:	48 b8 db 06 80 00 00 	movabs $0x8006db,%rax
  80030b:	00 00 00 
  80030e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800310:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800316:	48 98                	cltq   
  800318:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031f:	48 83 c2 08          	add    $0x8,%rdx
  800323:	48 89 c6             	mov    %rax,%rsi
  800326:	48 89 d7             	mov    %rdx,%rdi
  800329:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800335:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80033b:	c9                   	leaveq 
  80033c:	c3                   	retq   

000000000080033d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80033d:	55                   	push   %rbp
  80033e:	48 89 e5             	mov    %rsp,%rbp
  800341:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800348:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80034f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800356:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80035d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800364:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80036b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800372:	84 c0                	test   %al,%al
  800374:	74 20                	je     800396 <cprintf+0x59>
  800376:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80037a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80037e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800382:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800386:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80038a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80038e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800392:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800396:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80039d:	00 00 00 
  8003a0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a7:	00 00 00 
  8003aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003bc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003c3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003d1:	48 8b 0a             	mov    (%rdx),%rcx
  8003d4:	48 89 08             	mov    %rcx,(%rax)
  8003d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003e7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
  800407:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80040d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800413:	c9                   	leaveq 
  800414:	c3                   	retq   

0000000000800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
  800419:	48 83 ec 30          	sub    $0x30,%rsp
  80041d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800421:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800425:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800429:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80042c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800430:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800434:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800437:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80043b:	77 54                	ja     800491 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800440:	8d 78 ff             	lea    -0x1(%rax),%edi
  800443:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
  80044f:	48 f7 f6             	div    %rsi
  800452:	49 89 c2             	mov    %rax,%r10
  800455:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800458:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80045b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80045f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800463:	41 89 c9             	mov    %ecx,%r9d
  800466:	41 89 f8             	mov    %edi,%r8d
  800469:	89 d1                	mov    %edx,%ecx
  80046b:	4c 89 d2             	mov    %r10,%rdx
  80046e:	48 89 c7             	mov    %rax,%rdi
  800471:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  800478:	00 00 00 
  80047b:	ff d0                	callq  *%rax
  80047d:	eb 1c                	jmp    80049b <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800483:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80048a:	48 89 ce             	mov    %rcx,%rsi
  80048d:	89 d7                	mov    %edx,%edi
  80048f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800491:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800495:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800499:	7f e4                	jg     80047f <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80049e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a7:	48 f7 f1             	div    %rcx
  8004aa:	48 b8 90 4a 80 00 00 	movabs $0x804a90,%rax
  8004b1:	00 00 00 
  8004b4:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8004b8:	0f be d0             	movsbl %al,%edx
  8004bb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c3:	48 89 ce             	mov    %rcx,%rsi
  8004c6:	89 d7                	mov    %edx,%edi
  8004c8:	ff d0                	callq  *%rax
}
  8004ca:	90                   	nop
  8004cb:	c9                   	leaveq 
  8004cc:	c3                   	retq   

00000000008004cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cd:	55                   	push   %rbp
  8004ce:	48 89 e5             	mov    %rsp,%rbp
  8004d1:	48 83 ec 20          	sub    $0x20,%rsp
  8004d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004dc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004e0:	7e 4f                	jle    800531 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8004e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e6:	8b 00                	mov    (%rax),%eax
  8004e8:	83 f8 30             	cmp    $0x30,%eax
  8004eb:	73 24                	jae    800511 <getuint+0x44>
  8004ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f9:	8b 00                	mov    (%rax),%eax
  8004fb:	89 c0                	mov    %eax,%eax
  8004fd:	48 01 d0             	add    %rdx,%rax
  800500:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800504:	8b 12                	mov    (%rdx),%edx
  800506:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800509:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050d:	89 0a                	mov    %ecx,(%rdx)
  80050f:	eb 14                	jmp    800525 <getuint+0x58>
  800511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800515:	48 8b 40 08          	mov    0x8(%rax),%rax
  800519:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800525:	48 8b 00             	mov    (%rax),%rax
  800528:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052c:	e9 9d 00 00 00       	jmpq   8005ce <getuint+0x101>
	else if (lflag)
  800531:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800535:	74 4c                	je     800583 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053b:	8b 00                	mov    (%rax),%eax
  80053d:	83 f8 30             	cmp    $0x30,%eax
  800540:	73 24                	jae    800566 <getuint+0x99>
  800542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800546:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054e:	8b 00                	mov    (%rax),%eax
  800550:	89 c0                	mov    %eax,%eax
  800552:	48 01 d0             	add    %rdx,%rax
  800555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800559:	8b 12                	mov    (%rdx),%edx
  80055b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	89 0a                	mov    %ecx,(%rdx)
  800564:	eb 14                	jmp    80057a <getuint+0xad>
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80056e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800572:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800576:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057a:	48 8b 00             	mov    (%rax),%rax
  80057d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800581:	eb 4b                	jmp    8005ce <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800587:	8b 00                	mov    (%rax),%eax
  800589:	83 f8 30             	cmp    $0x30,%eax
  80058c:	73 24                	jae    8005b2 <getuint+0xe5>
  80058e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800592:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	8b 00                	mov    (%rax),%eax
  80059c:	89 c0                	mov    %eax,%eax
  80059e:	48 01 d0             	add    %rdx,%rax
  8005a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a5:	8b 12                	mov    (%rdx),%edx
  8005a7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	89 0a                	mov    %ecx,(%rdx)
  8005b0:	eb 14                	jmp    8005c6 <getuint+0xf9>
  8005b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005ba:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c6:	8b 00                	mov    (%rax),%eax
  8005c8:	89 c0                	mov    %eax,%eax
  8005ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005d2:	c9                   	leaveq 
  8005d3:	c3                   	retq   

00000000008005d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	48 83 ec 20          	sub    $0x20,%rsp
  8005dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e7:	7e 4f                	jle    800638 <getint+0x64>
		x=va_arg(*ap, long long);
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	83 f8 30             	cmp    $0x30,%eax
  8005f2:	73 24                	jae    800618 <getint+0x44>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	89 c0                	mov    %eax,%eax
  800604:	48 01 d0             	add    %rdx,%rax
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	8b 12                	mov    (%rdx),%edx
  80060d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	89 0a                	mov    %ecx,(%rdx)
  800616:	eb 14                	jmp    80062c <getint+0x58>
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800620:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800624:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800628:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062c:	48 8b 00             	mov    (%rax),%rax
  80062f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800633:	e9 9d 00 00 00       	jmpq   8006d5 <getint+0x101>
	else if (lflag)
  800638:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80063c:	74 4c                	je     80068a <getint+0xb6>
		x=va_arg(*ap, long);
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	83 f8 30             	cmp    $0x30,%eax
  800647:	73 24                	jae    80066d <getint+0x99>
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	8b 00                	mov    (%rax),%eax
  800657:	89 c0                	mov    %eax,%eax
  800659:	48 01 d0             	add    %rdx,%rax
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	8b 12                	mov    (%rdx),%edx
  800662:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800669:	89 0a                	mov    %ecx,(%rdx)
  80066b:	eb 14                	jmp    800681 <getint+0xad>
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 8b 40 08          	mov    0x8(%rax),%rax
  800675:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800679:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800681:	48 8b 00             	mov    (%rax),%rax
  800684:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800688:	eb 4b                	jmp    8006d5 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80068a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068e:	8b 00                	mov    (%rax),%eax
  800690:	83 f8 30             	cmp    $0x30,%eax
  800693:	73 24                	jae    8006b9 <getint+0xe5>
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a1:	8b 00                	mov    (%rax),%eax
  8006a3:	89 c0                	mov    %eax,%eax
  8006a5:	48 01 d0             	add    %rdx,%rax
  8006a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ac:	8b 12                	mov    (%rdx),%edx
  8006ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b5:	89 0a                	mov    %ecx,(%rdx)
  8006b7:	eb 14                	jmp    8006cd <getint+0xf9>
  8006b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006c1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cd:	8b 00                	mov    (%rax),%eax
  8006cf:	48 98                	cltq   
  8006d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d9:	c9                   	leaveq 
  8006da:	c3                   	retq   

00000000008006db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006db:	55                   	push   %rbp
  8006dc:	48 89 e5             	mov    %rsp,%rbp
  8006df:	41 54                	push   %r12
  8006e1:	53                   	push   %rbx
  8006e2:	48 83 ec 60          	sub    $0x60,%rsp
  8006e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006fe:	48 8b 0a             	mov    (%rdx),%rcx
  800701:	48 89 08             	mov    %rcx,(%rax)
  800704:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800708:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80070c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800710:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800714:	eb 17                	jmp    80072d <vprintfmt+0x52>
			if (ch == '\0')
  800716:	85 db                	test   %ebx,%ebx
  800718:	0f 84 b9 04 00 00    	je     800bd7 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80071e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800722:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800726:	48 89 d6             	mov    %rdx,%rsi
  800729:	89 df                	mov    %ebx,%edi
  80072b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800731:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800735:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800739:	0f b6 00             	movzbl (%rax),%eax
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d2                	jne    800716 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800748:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80074f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800756:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80075d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800768:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80076c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800770:	0f b6 00             	movzbl (%rax),%eax
  800773:	0f b6 d8             	movzbl %al,%ebx
  800776:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800779:	83 f8 55             	cmp    $0x55,%eax
  80077c:	0f 87 22 04 00 00    	ja     800ba4 <vprintfmt+0x4c9>
  800782:	89 c0                	mov    %eax,%eax
  800784:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80078b:	00 
  80078c:	48 b8 b8 4a 80 00 00 	movabs $0x804ab8,%rax
  800793:	00 00 00 
  800796:	48 01 d0             	add    %rdx,%rax
  800799:	48 8b 00             	mov    (%rax),%rax
  80079c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80079e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007a2:	eb c0                	jmp    800764 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a8:	eb ba                	jmp    800764 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007b1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 02             	shl    $0x2,%eax
  8007b9:	01 d0                	add    %edx,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	01 d8                	add    %ebx,%eax
  8007bf:	83 e8 30             	sub    $0x30,%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c9:	0f b6 00             	movzbl (%rax),%eax
  8007cc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007cf:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d2:	7e 60                	jle    800834 <vprintfmt+0x159>
  8007d4:	83 fb 39             	cmp    $0x39,%ebx
  8007d7:	7f 5b                	jg     800834 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007de:	eb d1                	jmp    8007b1 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8007e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e3:	83 f8 30             	cmp    $0x30,%eax
  8007e6:	73 17                	jae    8007ff <vprintfmt+0x124>
  8007e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007ec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ef:	89 d2                	mov    %edx,%edx
  8007f1:	48 01 d0             	add    %rdx,%rax
  8007f4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f7:	83 c2 08             	add    $0x8,%edx
  8007fa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007fd:	eb 0c                	jmp    80080b <vprintfmt+0x130>
  8007ff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800803:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800807:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80080b:	8b 00                	mov    (%rax),%eax
  80080d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800810:	eb 23                	jmp    800835 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800812:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800816:	0f 89 48 ff ff ff    	jns    800764 <vprintfmt+0x89>
				width = 0;
  80081c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800823:	e9 3c ff ff ff       	jmpq   800764 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800828:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80082f:	e9 30 ff ff ff       	jmpq   800764 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800839:	0f 89 25 ff ff ff    	jns    800764 <vprintfmt+0x89>
				width = precision, precision = -1;
  80083f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800842:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800845:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80084c:	e9 13 ff ff ff       	jmpq   800764 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800855:	e9 0a ff ff ff       	jmpq   800764 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80085a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085d:	83 f8 30             	cmp    $0x30,%eax
  800860:	73 17                	jae    800879 <vprintfmt+0x19e>
  800862:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800866:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800869:	89 d2                	mov    %edx,%edx
  80086b:	48 01 d0             	add    %rdx,%rax
  80086e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800871:	83 c2 08             	add    $0x8,%edx
  800874:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800877:	eb 0c                	jmp    800885 <vprintfmt+0x1aa>
  800879:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80087d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800881:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800885:	8b 10                	mov    (%rax),%edx
  800887:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80088b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088f:	48 89 ce             	mov    %rcx,%rsi
  800892:	89 d7                	mov    %edx,%edi
  800894:	ff d0                	callq  *%rax
			break;
  800896:	e9 37 03 00 00       	jmpq   800bd2 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80089b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089e:	83 f8 30             	cmp    $0x30,%eax
  8008a1:	73 17                	jae    8008ba <vprintfmt+0x1df>
  8008a3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008aa:	89 d2                	mov    %edx,%edx
  8008ac:	48 01 d0             	add    %rdx,%rax
  8008af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b2:	83 c2 08             	add    $0x8,%edx
  8008b5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b8:	eb 0c                	jmp    8008c6 <vprintfmt+0x1eb>
  8008ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008be:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008c2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c8:	85 db                	test   %ebx,%ebx
  8008ca:	79 02                	jns    8008ce <vprintfmt+0x1f3>
				err = -err;
  8008cc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ce:	83 fb 15             	cmp    $0x15,%ebx
  8008d1:	7f 16                	jg     8008e9 <vprintfmt+0x20e>
  8008d3:	48 b8 e0 49 80 00 00 	movabs $0x8049e0,%rax
  8008da:	00 00 00 
  8008dd:	48 63 d3             	movslq %ebx,%rdx
  8008e0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e4:	4d 85 e4             	test   %r12,%r12
  8008e7:	75 2e                	jne    800917 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8008e9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f1:	89 d9                	mov    %ebx,%ecx
  8008f3:	48 ba a1 4a 80 00 00 	movabs $0x804aa1,%rdx
  8008fa:	00 00 00 
  8008fd:	48 89 c7             	mov    %rax,%rdi
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
  800905:	49 b8 e1 0b 80 00 00 	movabs $0x800be1,%r8
  80090c:	00 00 00 
  80090f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800912:	e9 bb 02 00 00       	jmpq   800bd2 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800917:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091f:	4c 89 e1             	mov    %r12,%rcx
  800922:	48 ba aa 4a 80 00 00 	movabs $0x804aaa,%rdx
  800929:	00 00 00 
  80092c:	48 89 c7             	mov    %rax,%rdi
  80092f:	b8 00 00 00 00       	mov    $0x0,%eax
  800934:	49 b8 e1 0b 80 00 00 	movabs $0x800be1,%r8
  80093b:	00 00 00 
  80093e:	41 ff d0             	callq  *%r8
			break;
  800941:	e9 8c 02 00 00       	jmpq   800bd2 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800946:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800949:	83 f8 30             	cmp    $0x30,%eax
  80094c:	73 17                	jae    800965 <vprintfmt+0x28a>
  80094e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800952:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800955:	89 d2                	mov    %edx,%edx
  800957:	48 01 d0             	add    %rdx,%rax
  80095a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095d:	83 c2 08             	add    $0x8,%edx
  800960:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800963:	eb 0c                	jmp    800971 <vprintfmt+0x296>
  800965:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800969:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80096d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800971:	4c 8b 20             	mov    (%rax),%r12
  800974:	4d 85 e4             	test   %r12,%r12
  800977:	75 0a                	jne    800983 <vprintfmt+0x2a8>
				p = "(null)";
  800979:	49 bc ad 4a 80 00 00 	movabs $0x804aad,%r12
  800980:	00 00 00 
			if (width > 0 && padc != '-')
  800983:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800987:	7e 78                	jle    800a01 <vprintfmt+0x326>
  800989:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80098d:	74 72                	je     800a01 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80098f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800992:	48 98                	cltq   
  800994:	48 89 c6             	mov    %rax,%rsi
  800997:	4c 89 e7             	mov    %r12,%rdi
  80099a:	48 b8 8f 0e 80 00 00 	movabs $0x800e8f,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009a9:	eb 17                	jmp    8009c2 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8009ab:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009af:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b7:	48 89 ce             	mov    %rcx,%rsi
  8009ba:	89 d7                	mov    %edx,%edi
  8009bc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c6:	7f e3                	jg     8009ab <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c8:	eb 37                	jmp    800a01 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ce:	74 1e                	je     8009ee <vprintfmt+0x313>
  8009d0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d3:	7e 05                	jle    8009da <vprintfmt+0x2ff>
  8009d5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d8:	7e 14                	jle    8009ee <vprintfmt+0x313>
					putch('?', putdat);
  8009da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e2:	48 89 d6             	mov    %rdx,%rsi
  8009e5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009ea:	ff d0                	callq  *%rax
  8009ec:	eb 0f                	jmp    8009fd <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8009ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f6:	48 89 d6             	mov    %rdx,%rsi
  8009f9:	89 df                	mov    %ebx,%edi
  8009fb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a01:	4c 89 e0             	mov    %r12,%rax
  800a04:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a08:	0f b6 00             	movzbl (%rax),%eax
  800a0b:	0f be d8             	movsbl %al,%ebx
  800a0e:	85 db                	test   %ebx,%ebx
  800a10:	74 28                	je     800a3a <vprintfmt+0x35f>
  800a12:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a16:	78 b2                	js     8009ca <vprintfmt+0x2ef>
  800a18:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a1c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a20:	79 a8                	jns    8009ca <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x35f>
				putch(' ', putdat);
  800a24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2c:	48 89 d6             	mov    %rdx,%rsi
  800a2f:	bf 20 00 00 00       	mov    $0x20,%edi
  800a34:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a36:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800a40:	e9 8d 01 00 00       	jmpq   800bd2 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a45:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a49:	be 03 00 00 00       	mov    $0x3,%esi
  800a4e:	48 89 c7             	mov    %rax,%rdi
  800a51:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  800a58:	00 00 00 
  800a5b:	ff d0                	callq  *%rax
  800a5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	48 85 c0             	test   %rax,%rax
  800a68:	79 1d                	jns    800a87 <vprintfmt+0x3ac>
				putch('-', putdat);
  800a6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	48 89 d6             	mov    %rdx,%rsi
  800a75:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a7a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a80:	48 f7 d8             	neg    %rax
  800a83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a87:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8e:	e9 d2 00 00 00       	jmpq   800b65 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a97:	be 03 00 00 00       	mov    $0x3,%esi
  800a9c:	48 89 c7             	mov    %rax,%rdi
  800a9f:	48 b8 cd 04 80 00 00 	movabs $0x8004cd,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax
  800aab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800aaf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab6:	e9 aa 00 00 00       	jmpq   800b65 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800abb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abf:	be 03 00 00 00       	mov    $0x3,%esi
  800ac4:	48 89 c7             	mov    %rax,%rdi
  800ac7:	48 b8 cd 04 80 00 00 	movabs $0x8004cd,%rax
  800ace:	00 00 00 
  800ad1:	ff d0                	callq  *%rax
  800ad3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ad7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ade:	e9 82 00 00 00       	jmpq   800b65 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800ae3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aeb:	48 89 d6             	mov    %rdx,%rsi
  800aee:	bf 30 00 00 00       	mov    $0x30,%edi
  800af3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800af5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afd:	48 89 d6             	mov    %rdx,%rsi
  800b00:	bf 78 00 00 00       	mov    $0x78,%edi
  800b05:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0a:	83 f8 30             	cmp    $0x30,%eax
  800b0d:	73 17                	jae    800b26 <vprintfmt+0x44b>
  800b0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b16:	89 d2                	mov    %edx,%edx
  800b18:	48 01 d0             	add    %rdx,%rax
  800b1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b24:	eb 0c                	jmp    800b32 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800b26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b2a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b32:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b39:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b40:	eb 23                	jmp    800b65 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b46:	be 03 00 00 00       	mov    $0x3,%esi
  800b4b:	48 89 c7             	mov    %rax,%rdi
  800b4e:	48 b8 cd 04 80 00 00 	movabs $0x8004cd,%rax
  800b55:	00 00 00 
  800b58:	ff d0                	callq  *%rax
  800b5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b5e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b65:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b6a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b6d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7c:	45 89 c1             	mov    %r8d,%r9d
  800b7f:	41 89 f8             	mov    %edi,%r8d
  800b82:	48 89 c7             	mov    %rax,%rdi
  800b85:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
			break;
  800b91:	eb 3f                	jmp    800bd2 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9b:	48 89 d6             	mov    %rdx,%rsi
  800b9e:	89 df                	mov    %ebx,%edi
  800ba0:	ff d0                	callq  *%rax
			break;
  800ba2:	eb 2e                	jmp    800bd2 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bac:	48 89 d6             	mov    %rdx,%rsi
  800baf:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bbb:	eb 05                	jmp    800bc2 <vprintfmt+0x4e7>
  800bbd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bc6:	48 83 e8 01          	sub    $0x1,%rax
  800bca:	0f b6 00             	movzbl (%rax),%eax
  800bcd:	3c 25                	cmp    $0x25,%al
  800bcf:	75 ec                	jne    800bbd <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800bd1:	90                   	nop
		}
	}
  800bd2:	e9 3d fb ff ff       	jmpq   800714 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd7:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bd8:	48 83 c4 60          	add    $0x60,%rsp
  800bdc:	5b                   	pop    %rbx
  800bdd:	41 5c                	pop    %r12
  800bdf:	5d                   	pop    %rbp
  800be0:	c3                   	retq   

0000000000800be1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be1:	55                   	push   %rbp
  800be2:	48 89 e5             	mov    %rsp,%rbp
  800be5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bec:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bf3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bfa:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800c01:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c08:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c16:	84 c0                	test   %al,%al
  800c18:	74 20                	je     800c3a <printfmt+0x59>
  800c1a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c22:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c26:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c2a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c32:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c36:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c41:	00 00 00 
  800c44:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c4b:	00 00 00 
  800c4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c52:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c59:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c60:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c67:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c6e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c75:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c7c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c83:	48 89 c7             	mov    %rax,%rdi
  800c86:	48 b8 db 06 80 00 00 	movabs $0x8006db,%rax
  800c8d:	00 00 00 
  800c90:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c92:	90                   	nop
  800c93:	c9                   	leaveq 
  800c94:	c3                   	retq   

0000000000800c95 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 83 ec 10          	sub    $0x10,%rsp
  800c9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca8:	8b 40 10             	mov    0x10(%rax),%eax
  800cab:	8d 50 01             	lea    0x1(%rax),%edx
  800cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb9:	48 8b 10             	mov    (%rax),%rdx
  800cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc4:	48 39 c2             	cmp    %rax,%rdx
  800cc7:	73 17                	jae    800ce0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ccd:	48 8b 00             	mov    (%rax),%rax
  800cd0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cd8:	48 89 0a             	mov    %rcx,(%rdx)
  800cdb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cde:	88 10                	mov    %dl,(%rax)
}
  800ce0:	90                   	nop
  800ce1:	c9                   	leaveq 
  800ce2:	c3                   	retq   

0000000000800ce3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce3:	55                   	push   %rbp
  800ce4:	48 89 e5             	mov    %rsp,%rbp
  800ce7:	48 83 ec 50          	sub    $0x50,%rsp
  800ceb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cef:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cfa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cfe:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d02:	48 8b 0a             	mov    (%rdx),%rcx
  800d05:	48 89 08             	mov    %rcx,(%rax)
  800d08:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d0c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d10:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d14:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d20:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d23:	48 98                	cltq   
  800d25:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d29:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d2d:	48 01 d0             	add    %rdx,%rax
  800d30:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d34:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d3b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d40:	74 06                	je     800d48 <vsnprintf+0x65>
  800d42:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d46:	7f 07                	jg     800d4f <vsnprintf+0x6c>
		return -E_INVAL;
  800d48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d4d:	eb 2f                	jmp    800d7e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d4f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d53:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d57:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d5b:	48 89 c6             	mov    %rax,%rsi
  800d5e:	48 bf 95 0c 80 00 00 	movabs $0x800c95,%rdi
  800d65:	00 00 00 
  800d68:	48 b8 db 06 80 00 00 	movabs $0x8006db,%rax
  800d6f:	00 00 00 
  800d72:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d78:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d7b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d7e:	c9                   	leaveq 
  800d7f:	c3                   	retq   

0000000000800d80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d80:	55                   	push   %rbp
  800d81:	48 89 e5             	mov    %rsp,%rbp
  800d84:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d8b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d92:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d98:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d9f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db4:	84 c0                	test   %al,%al
  800db6:	74 20                	je     800dd8 <snprintf+0x58>
  800db8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dbc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dcc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dd8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ddf:	00 00 00 
  800de2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800de9:	00 00 00 
  800dec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800df7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dfe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e05:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e0c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e13:	48 8b 0a             	mov    (%rdx),%rcx
  800e16:	48 89 08             	mov    %rcx,(%rax)
  800e19:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e1d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e21:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e25:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e29:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e30:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e37:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e3d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e44:	48 89 c7             	mov    %rax,%rdi
  800e47:	48 b8 e3 0c 80 00 00 	movabs $0x800ce3,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	callq  *%rax
  800e53:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e59:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e5f:	c9                   	leaveq 
  800e60:	c3                   	retq   

0000000000800e61 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e61:	55                   	push   %rbp
  800e62:	48 89 e5             	mov    %rsp,%rbp
  800e65:	48 83 ec 18          	sub    $0x18,%rsp
  800e69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e74:	eb 09                	jmp    800e7f <strlen+0x1e>
		n++;
  800e76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e83:	0f b6 00             	movzbl (%rax),%eax
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ec                	jne    800e76 <strlen+0x15>
		n++;
	return n;
  800e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8d:	c9                   	leaveq 
  800e8e:	c3                   	retq   

0000000000800e8f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e8f:	55                   	push   %rbp
  800e90:	48 89 e5             	mov    %rsp,%rbp
  800e93:	48 83 ec 20          	sub    $0x20,%rsp
  800e97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea6:	eb 0e                	jmp    800eb6 <strnlen+0x27>
		n++;
  800ea8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ebb:	74 0b                	je     800ec8 <strnlen+0x39>
  800ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec1:	0f b6 00             	movzbl (%rax),%eax
  800ec4:	84 c0                	test   %al,%al
  800ec6:	75 e0                	jne    800ea8 <strnlen+0x19>
		n++;
	return n;
  800ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ecb:	c9                   	leaveq 
  800ecc:	c3                   	retq   

0000000000800ecd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecd:	55                   	push   %rbp
  800ece:	48 89 e5             	mov    %rsp,%rbp
  800ed1:	48 83 ec 20          	sub    $0x20,%rsp
  800ed5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee5:	90                   	nop
  800ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800efa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800efe:	0f b6 12             	movzbl (%rdx),%edx
  800f01:	88 10                	mov    %dl,(%rax)
  800f03:	0f b6 00             	movzbl (%rax),%eax
  800f06:	84 c0                	test   %al,%al
  800f08:	75 dc                	jne    800ee6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f0e:	c9                   	leaveq 
  800f0f:	c3                   	retq   

0000000000800f10 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f10:	55                   	push   %rbp
  800f11:	48 89 e5             	mov    %rsp,%rbp
  800f14:	48 83 ec 20          	sub    $0x20,%rsp
  800f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f24:	48 89 c7             	mov    %rax,%rdi
  800f27:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  800f2e:	00 00 00 
  800f31:	ff d0                	callq  *%rax
  800f33:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f39:	48 63 d0             	movslq %eax,%rdx
  800f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f40:	48 01 c2             	add    %rax,%rdx
  800f43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f47:	48 89 c6             	mov    %rax,%rsi
  800f4a:	48 89 d7             	mov    %rdx,%rdi
  800f4d:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  800f54:	00 00 00 
  800f57:	ff d0                	callq  *%rax
	return dst;
  800f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f5d:	c9                   	leaveq 
  800f5e:	c3                   	retq   

0000000000800f5f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f5f:	55                   	push   %rbp
  800f60:	48 89 e5             	mov    %rsp,%rbp
  800f63:	48 83 ec 28          	sub    $0x28,%rsp
  800f67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f6f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f7b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f82:	00 
  800f83:	eb 2a                	jmp    800faf <strncpy+0x50>
		*dst++ = *src;
  800f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f8d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f91:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f95:	0f b6 12             	movzbl (%rdx),%edx
  800f98:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f9e:	0f b6 00             	movzbl (%rax),%eax
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 05                	je     800faa <strncpy+0x4b>
			src++;
  800fa5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800faa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fb7:	72 cc                	jb     800f85 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fbd:	c9                   	leaveq 
  800fbe:	c3                   	retq   

0000000000800fbf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fbf:	55                   	push   %rbp
  800fc0:	48 89 e5             	mov    %rsp,%rbp
  800fc3:	48 83 ec 28          	sub    $0x28,%rsp
  800fc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fcf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fdb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe0:	74 3d                	je     80101f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fe2:	eb 1d                	jmp    801001 <strlcpy+0x42>
			*dst++ = *src++;
  800fe4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ff8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ffc:	0f b6 12             	movzbl (%rdx),%edx
  800fff:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801001:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801006:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80100b:	74 0b                	je     801018 <strlcpy+0x59>
  80100d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801011:	0f b6 00             	movzbl (%rax),%eax
  801014:	84 c0                	test   %al,%al
  801016:	75 cc                	jne    800fe4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80101f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801023:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801027:	48 29 c2             	sub    %rax,%rdx
  80102a:	48 89 d0             	mov    %rdx,%rax
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 10          	sub    $0x10,%rsp
  801037:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80103f:	eb 0a                	jmp    80104b <strcmp+0x1c>
		p++, q++;
  801041:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801046:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80104b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	84 c0                	test   %al,%al
  801054:	74 12                	je     801068 <strcmp+0x39>
  801056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105a:	0f b6 10             	movzbl (%rax),%edx
  80105d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801061:	0f b6 00             	movzbl (%rax),%eax
  801064:	38 c2                	cmp    %al,%dl
  801066:	74 d9                	je     801041 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106c:	0f b6 00             	movzbl (%rax),%eax
  80106f:	0f b6 d0             	movzbl %al,%edx
  801072:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801076:	0f b6 00             	movzbl (%rax),%eax
  801079:	0f b6 c0             	movzbl %al,%eax
  80107c:	29 c2                	sub    %eax,%edx
  80107e:	89 d0                	mov    %edx,%eax
}
  801080:	c9                   	leaveq 
  801081:	c3                   	retq   

0000000000801082 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801082:	55                   	push   %rbp
  801083:	48 89 e5             	mov    %rsp,%rbp
  801086:	48 83 ec 18          	sub    $0x18,%rsp
  80108a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80108e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801092:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801096:	eb 0f                	jmp    8010a7 <strncmp+0x25>
		n--, p++, q++;
  801098:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80109d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ac:	74 1d                	je     8010cb <strncmp+0x49>
  8010ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b2:	0f b6 00             	movzbl (%rax),%eax
  8010b5:	84 c0                	test   %al,%al
  8010b7:	74 12                	je     8010cb <strncmp+0x49>
  8010b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bd:	0f b6 10             	movzbl (%rax),%edx
  8010c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c4:	0f b6 00             	movzbl (%rax),%eax
  8010c7:	38 c2                	cmp    %al,%dl
  8010c9:	74 cd                	je     801098 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d0:	75 07                	jne    8010d9 <strncmp+0x57>
		return 0;
  8010d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d7:	eb 18                	jmp    8010f1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	0f b6 00             	movzbl (%rax),%eax
  8010e0:	0f b6 d0             	movzbl %al,%edx
  8010e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e7:	0f b6 00             	movzbl (%rax),%eax
  8010ea:	0f b6 c0             	movzbl %al,%eax
  8010ed:	29 c2                	sub    %eax,%edx
  8010ef:	89 d0                	mov    %edx,%eax
}
  8010f1:	c9                   	leaveq 
  8010f2:	c3                   	retq   

00000000008010f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f3:	55                   	push   %rbp
  8010f4:	48 89 e5             	mov    %rsp,%rbp
  8010f7:	48 83 ec 10          	sub    $0x10,%rsp
  8010fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ff:	89 f0                	mov    %esi,%eax
  801101:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801104:	eb 17                	jmp    80111d <strchr+0x2a>
		if (*s == c)
  801106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801110:	75 06                	jne    801118 <strchr+0x25>
			return (char *) s;
  801112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801116:	eb 15                	jmp    80112d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801118:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801121:	0f b6 00             	movzbl (%rax),%eax
  801124:	84 c0                	test   %al,%al
  801126:	75 de                	jne    801106 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 10          	sub    $0x10,%rsp
  801137:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113b:	89 f0                	mov    %esi,%eax
  80113d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801140:	eb 11                	jmp    801153 <strfind+0x24>
		if (*s == c)
  801142:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801146:	0f b6 00             	movzbl (%rax),%eax
  801149:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80114c:	74 12                	je     801160 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80114e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801157:	0f b6 00             	movzbl (%rax),%eax
  80115a:	84 c0                	test   %al,%al
  80115c:	75 e4                	jne    801142 <strfind+0x13>
  80115e:	eb 01                	jmp    801161 <strfind+0x32>
		if (*s == c)
			break;
  801160:	90                   	nop
	return (char *) s;
  801161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801165:	c9                   	leaveq 
  801166:	c3                   	retq   

0000000000801167 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801167:	55                   	push   %rbp
  801168:	48 89 e5             	mov    %rsp,%rbp
  80116b:	48 83 ec 18          	sub    $0x18,%rsp
  80116f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801173:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801176:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80117a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117f:	75 06                	jne    801187 <memset+0x20>
		return v;
  801181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801185:	eb 69                	jmp    8011f0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118b:	83 e0 03             	and    $0x3,%eax
  80118e:	48 85 c0             	test   %rax,%rax
  801191:	75 48                	jne    8011db <memset+0x74>
  801193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801197:	83 e0 03             	and    $0x3,%eax
  80119a:	48 85 c0             	test   %rax,%rax
  80119d:	75 3c                	jne    8011db <memset+0x74>
		c &= 0xFF;
  80119f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a9:	c1 e0 18             	shl    $0x18,%eax
  8011ac:	89 c2                	mov    %eax,%edx
  8011ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b1:	c1 e0 10             	shl    $0x10,%eax
  8011b4:	09 c2                	or     %eax,%edx
  8011b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b9:	c1 e0 08             	shl    $0x8,%eax
  8011bc:	09 d0                	or     %edx,%eax
  8011be:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c5:	48 c1 e8 02          	shr    $0x2,%rax
  8011c9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d3:	48 89 d7             	mov    %rdx,%rdi
  8011d6:	fc                   	cld    
  8011d7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011d9:	eb 11                	jmp    8011ec <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e6:	48 89 d7             	mov    %rdx,%rdi
  8011e9:	fc                   	cld    
  8011ea:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f0:	c9                   	leaveq 
  8011f1:	c3                   	retq   

00000000008011f2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f2:	55                   	push   %rbp
  8011f3:	48 89 e5             	mov    %rsp,%rbp
  8011f6:	48 83 ec 28          	sub    $0x28,%rsp
  8011fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801202:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801206:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80120e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801212:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80121e:	0f 83 88 00 00 00    	jae    8012ac <memmove+0xba>
  801224:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801228:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122c:	48 01 d0             	add    %rdx,%rax
  80122f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801233:	76 77                	jbe    8012ac <memmove+0xba>
		s += n;
  801235:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801239:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80123d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801241:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801249:	83 e0 03             	and    $0x3,%eax
  80124c:	48 85 c0             	test   %rax,%rax
  80124f:	75 3b                	jne    80128c <memmove+0x9a>
  801251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801255:	83 e0 03             	and    $0x3,%eax
  801258:	48 85 c0             	test   %rax,%rax
  80125b:	75 2f                	jne    80128c <memmove+0x9a>
  80125d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801261:	83 e0 03             	and    $0x3,%eax
  801264:	48 85 c0             	test   %rax,%rax
  801267:	75 23                	jne    80128c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126d:	48 83 e8 04          	sub    $0x4,%rax
  801271:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801275:	48 83 ea 04          	sub    $0x4,%rdx
  801279:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80127d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801281:	48 89 c7             	mov    %rax,%rdi
  801284:	48 89 d6             	mov    %rdx,%rsi
  801287:	fd                   	std    
  801288:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80128a:	eb 1d                	jmp    8012a9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80128c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801290:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80129c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a0:	48 89 d7             	mov    %rdx,%rdi
  8012a3:	48 89 c1             	mov    %rax,%rcx
  8012a6:	fd                   	std    
  8012a7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012a9:	fc                   	cld    
  8012aa:	eb 57                	jmp    801303 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b0:	83 e0 03             	and    $0x3,%eax
  8012b3:	48 85 c0             	test   %rax,%rax
  8012b6:	75 36                	jne    8012ee <memmove+0xfc>
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bc:	83 e0 03             	and    $0x3,%eax
  8012bf:	48 85 c0             	test   %rax,%rax
  8012c2:	75 2a                	jne    8012ee <memmove+0xfc>
  8012c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c8:	83 e0 03             	and    $0x3,%eax
  8012cb:	48 85 c0             	test   %rax,%rax
  8012ce:	75 1e                	jne    8012ee <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d4:	48 c1 e8 02          	shr    $0x2,%rax
  8012d8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e3:	48 89 c7             	mov    %rax,%rdi
  8012e6:	48 89 d6             	mov    %rdx,%rsi
  8012e9:	fc                   	cld    
  8012ea:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ec:	eb 15                	jmp    801303 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012fa:	48 89 c7             	mov    %rax,%rdi
  8012fd:	48 89 d6             	mov    %rdx,%rsi
  801300:	fc                   	cld    
  801301:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801307:	c9                   	leaveq 
  801308:	c3                   	retq   

0000000000801309 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	48 83 ec 18          	sub    $0x18,%rsp
  801311:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801315:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801319:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80131d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801321:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801329:	48 89 ce             	mov    %rcx,%rsi
  80132c:	48 89 c7             	mov    %rax,%rdi
  80132f:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  801336:	00 00 00 
  801339:	ff d0                	callq  *%rax
}
  80133b:	c9                   	leaveq 
  80133c:	c3                   	retq   

000000000080133d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 28          	sub    $0x28,%rsp
  801345:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801349:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801355:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801361:	eb 36                	jmp    801399 <memcmp+0x5c>
		if (*s1 != *s2)
  801363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801367:	0f b6 10             	movzbl (%rax),%edx
  80136a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136e:	0f b6 00             	movzbl (%rax),%eax
  801371:	38 c2                	cmp    %al,%dl
  801373:	74 1a                	je     80138f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801375:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801379:	0f b6 00             	movzbl (%rax),%eax
  80137c:	0f b6 d0             	movzbl %al,%edx
  80137f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801383:	0f b6 00             	movzbl (%rax),%eax
  801386:	0f b6 c0             	movzbl %al,%eax
  801389:	29 c2                	sub    %eax,%edx
  80138b:	89 d0                	mov    %edx,%eax
  80138d:	eb 20                	jmp    8013af <memcmp+0x72>
		s1++, s2++;
  80138f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801394:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801399:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013a5:	48 85 c0             	test   %rax,%rax
  8013a8:	75 b9                	jne    801363 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013af:	c9                   	leaveq 
  8013b0:	c3                   	retq   

00000000008013b1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b1:	55                   	push   %rbp
  8013b2:	48 89 e5             	mov    %rsp,%rbp
  8013b5:	48 83 ec 28          	sub    $0x28,%rsp
  8013b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cc:	48 01 d0             	add    %rdx,%rax
  8013cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d3:	eb 19                	jmp    8013ee <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	0f b6 d0             	movzbl %al,%edx
  8013df:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e2:	0f b6 c0             	movzbl %al,%eax
  8013e5:	39 c2                	cmp    %eax,%edx
  8013e7:	74 11                	je     8013fa <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f6:	72 dd                	jb     8013d5 <memfind+0x24>
  8013f8:	eb 01                	jmp    8013fb <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013fa:	90                   	nop
	return (void *) s;
  8013fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 38          	sub    $0x38,%rsp
  801409:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80140d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801411:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80141b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801422:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801423:	eb 05                	jmp    80142a <strtol+0x29>
		s++;
  801425:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3c 20                	cmp    $0x20,%al
  801433:	74 f0                	je     801425 <strtol+0x24>
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	3c 09                	cmp    $0x9,%al
  80143e:	74 e5                	je     801425 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	3c 2b                	cmp    $0x2b,%al
  801449:	75 07                	jne    801452 <strtol+0x51>
		s++;
  80144b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801450:	eb 17                	jmp    801469 <strtol+0x68>
	else if (*s == '-')
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3c 2d                	cmp    $0x2d,%al
  80145b:	75 0c                	jne    801469 <strtol+0x68>
		s++, neg = 1;
  80145d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801462:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801469:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80146d:	74 06                	je     801475 <strtol+0x74>
  80146f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801473:	75 28                	jne    80149d <strtol+0x9c>
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	0f b6 00             	movzbl (%rax),%eax
  80147c:	3c 30                	cmp    $0x30,%al
  80147e:	75 1d                	jne    80149d <strtol+0x9c>
  801480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801484:	48 83 c0 01          	add    $0x1,%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	3c 78                	cmp    $0x78,%al
  80148d:	75 0e                	jne    80149d <strtol+0x9c>
		s += 2, base = 16;
  80148f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801494:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80149b:	eb 2c                	jmp    8014c9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80149d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a1:	75 19                	jne    8014bc <strtol+0xbb>
  8014a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	3c 30                	cmp    $0x30,%al
  8014ac:	75 0e                	jne    8014bc <strtol+0xbb>
		s++, base = 8;
  8014ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014ba:	eb 0d                	jmp    8014c9 <strtol+0xc8>
	else if (base == 0)
  8014bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c0:	75 07                	jne    8014c9 <strtol+0xc8>
		base = 10;
  8014c2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	3c 2f                	cmp    $0x2f,%al
  8014d2:	7e 1d                	jle    8014f1 <strtol+0xf0>
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	3c 39                	cmp    $0x39,%al
  8014dd:	7f 12                	jg     8014f1 <strtol+0xf0>
			dig = *s - '0';
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	0f be c0             	movsbl %al,%eax
  8014e9:	83 e8 30             	sub    $0x30,%eax
  8014ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ef:	eb 4e                	jmp    80153f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 1d                	jle    801519 <strtol+0x118>
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	3c 7a                	cmp    $0x7a,%al
  801505:	7f 12                	jg     801519 <strtol+0x118>
			dig = *s - 'a' + 10;
  801507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	0f be c0             	movsbl %al,%eax
  801511:	83 e8 57             	sub    $0x57,%eax
  801514:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801517:	eb 26                	jmp    80153f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151d:	0f b6 00             	movzbl (%rax),%eax
  801520:	3c 40                	cmp    $0x40,%al
  801522:	7e 47                	jle    80156b <strtol+0x16a>
  801524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801528:	0f b6 00             	movzbl (%rax),%eax
  80152b:	3c 5a                	cmp    $0x5a,%al
  80152d:	7f 3c                	jg     80156b <strtol+0x16a>
			dig = *s - 'A' + 10;
  80152f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801533:	0f b6 00             	movzbl (%rax),%eax
  801536:	0f be c0             	movsbl %al,%eax
  801539:	83 e8 37             	sub    $0x37,%eax
  80153c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80153f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801542:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801545:	7d 23                	jge    80156a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801547:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80154c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80154f:	48 98                	cltq   
  801551:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801556:	48 89 c2             	mov    %rax,%rdx
  801559:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80155c:	48 98                	cltq   
  80155e:	48 01 d0             	add    %rdx,%rax
  801561:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801565:	e9 5f ff ff ff       	jmpq   8014c9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80156a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80156b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801570:	74 0b                	je     80157d <strtol+0x17c>
		*endptr = (char *) s;
  801572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801576:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80157a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80157d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801581:	74 09                	je     80158c <strtol+0x18b>
  801583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801587:	48 f7 d8             	neg    %rax
  80158a:	eb 04                	jmp    801590 <strtol+0x18f>
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <strstr>:

char * strstr(const char *in, const char *str)
{
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 30          	sub    $0x30,%rsp
  80159a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015aa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015b4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b8:	75 06                	jne    8015c0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015be:	eb 6b                	jmp    80162b <strstr+0x99>

	len = strlen(str);
  8015c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c4:	48 89 c7             	mov    %rax,%rdi
  8015c7:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	callq  *%rax
  8015d3:	48 98                	cltq   
  8015d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e5:	0f b6 00             	movzbl (%rax),%eax
  8015e8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015ef:	75 07                	jne    8015f8 <strstr+0x66>
				return (char *) 0;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	eb 33                	jmp    80162b <strstr+0x99>
		} while (sc != c);
  8015f8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015fc:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015ff:	75 d8                	jne    8015d9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801601:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801605:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	48 89 ce             	mov    %rcx,%rsi
  801610:	48 89 c7             	mov    %rax,%rdi
  801613:	48 b8 82 10 80 00 00 	movabs $0x801082,%rax
  80161a:	00 00 00 
  80161d:	ff d0                	callq  *%rax
  80161f:	85 c0                	test   %eax,%eax
  801621:	75 b6                	jne    8015d9 <strstr+0x47>

	return (char *) (in - 1);
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	48 83 e8 01          	sub    $0x1,%rax
}
  80162b:	c9                   	leaveq 
  80162c:	c3                   	retq   

000000000080162d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80162d:	55                   	push   %rbp
  80162e:	48 89 e5             	mov    %rsp,%rbp
  801631:	53                   	push   %rbx
  801632:	48 83 ec 48          	sub    $0x48,%rsp
  801636:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801639:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80163c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801640:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801644:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801648:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80164c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801653:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801657:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80165b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801663:	4c 89 c3             	mov    %r8,%rbx
  801666:	cd 30                	int    $0x30
  801668:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80166c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801670:	74 3e                	je     8016b0 <syscall+0x83>
  801672:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801677:	7e 37                	jle    8016b0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801679:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801680:	49 89 d0             	mov    %rdx,%r8
  801683:	89 c1                	mov    %eax,%ecx
  801685:	48 ba 68 4d 80 00 00 	movabs $0x804d68,%rdx
  80168c:	00 00 00 
  80168f:	be 24 00 00 00       	mov    $0x24,%esi
  801694:	48 bf 85 4d 80 00 00 	movabs $0x804d85,%rdi
  80169b:	00 00 00 
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	49 b9 c1 43 80 00 00 	movabs $0x8043c1,%r9
  8016aa:	00 00 00 
  8016ad:	41 ff d1             	callq  *%r9

	return ret;
  8016b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b4:	48 83 c4 48          	add    $0x48,%rsp
  8016b8:	5b                   	pop    %rbx
  8016b9:	5d                   	pop    %rbp
  8016ba:	c3                   	retq   

00000000008016bb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
  8016bf:	48 83 ec 10          	sub    $0x10,%rsp
  8016c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d3:	48 83 ec 08          	sub    $0x8,%rsp
  8016d7:	6a 00                	pushq  $0x0
  8016d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e5:	48 89 d1             	mov    %rdx,%rcx
  8016e8:	48 89 c2             	mov    %rax,%rdx
  8016eb:	be 00 00 00 00       	mov    $0x0,%esi
  8016f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f5:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8016fc:	00 00 00 
  8016ff:	ff d0                	callq  *%rax
  801701:	48 83 c4 10          	add    $0x10,%rsp
}
  801705:	90                   	nop
  801706:	c9                   	leaveq 
  801707:	c3                   	retq   

0000000000801708 <sys_cgetc>:

int
sys_cgetc(void)
{
  801708:	55                   	push   %rbp
  801709:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80170c:	48 83 ec 08          	sub    $0x8,%rsp
  801710:	6a 00                	pushq  $0x0
  801712:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801718:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801723:	ba 00 00 00 00       	mov    $0x0,%edx
  801728:	be 00 00 00 00       	mov    $0x0,%esi
  80172d:	bf 01 00 00 00       	mov    $0x1,%edi
  801732:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801739:	00 00 00 
  80173c:	ff d0                	callq  *%rax
  80173e:	48 83 c4 10          	add    $0x10,%rsp
}
  801742:	c9                   	leaveq 
  801743:	c3                   	retq   

0000000000801744 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801744:	55                   	push   %rbp
  801745:	48 89 e5             	mov    %rsp,%rbp
  801748:	48 83 ec 10          	sub    $0x10,%rsp
  80174c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801752:	48 98                	cltq   
  801754:	48 83 ec 08          	sub    $0x8,%rsp
  801758:	6a 00                	pushq  $0x0
  80175a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801760:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801766:	b9 00 00 00 00       	mov    $0x0,%ecx
  80176b:	48 89 c2             	mov    %rax,%rdx
  80176e:	be 01 00 00 00       	mov    $0x1,%esi
  801773:	bf 03 00 00 00       	mov    $0x3,%edi
  801778:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  80177f:	00 00 00 
  801782:	ff d0                	callq  *%rax
  801784:	48 83 c4 10          	add    $0x10,%rsp
}
  801788:	c9                   	leaveq 
  801789:	c3                   	retq   

000000000080178a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80178a:	55                   	push   %rbp
  80178b:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178e:	48 83 ec 08          	sub    $0x8,%rsp
  801792:	6a 00                	pushq  $0x0
  801794:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	be 00 00 00 00       	mov    $0x0,%esi
  8017af:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b4:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	callq  *%rax
  8017c0:	48 83 c4 10          	add    $0x10,%rsp
}
  8017c4:	c9                   	leaveq 
  8017c5:	c3                   	retq   

00000000008017c6 <sys_yield>:


void
sys_yield(void)
{
  8017c6:	55                   	push   %rbp
  8017c7:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017ca:	48 83 ec 08          	sub    $0x8,%rsp
  8017ce:	6a 00                	pushq  $0x0
  8017d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e6:	be 00 00 00 00       	mov    $0x0,%esi
  8017eb:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f0:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
  8017fc:	48 83 c4 10          	add    $0x10,%rsp
}
  801800:	90                   	nop
  801801:	c9                   	leaveq 
  801802:	c3                   	retq   

0000000000801803 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801803:	55                   	push   %rbp
  801804:	48 89 e5             	mov    %rsp,%rbp
  801807:	48 83 ec 10          	sub    $0x10,%rsp
  80180b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801812:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801815:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801818:	48 63 c8             	movslq %eax,%rcx
  80181b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801822:	48 98                	cltq   
  801824:	48 83 ec 08          	sub    $0x8,%rsp
  801828:	6a 00                	pushq  $0x0
  80182a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801830:	49 89 c8             	mov    %rcx,%r8
  801833:	48 89 d1             	mov    %rdx,%rcx
  801836:	48 89 c2             	mov    %rax,%rdx
  801839:	be 01 00 00 00       	mov    $0x1,%esi
  80183e:	bf 04 00 00 00       	mov    $0x4,%edi
  801843:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  80184a:	00 00 00 
  80184d:	ff d0                	callq  *%rax
  80184f:	48 83 c4 10          	add    $0x10,%rsp
}
  801853:	c9                   	leaveq 
  801854:	c3                   	retq   

0000000000801855 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
  801859:	48 83 ec 20          	sub    $0x20,%rsp
  80185d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801860:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801864:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801867:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80186b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80186f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801872:	48 63 c8             	movslq %eax,%rcx
  801875:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801879:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187c:	48 63 f0             	movslq %eax,%rsi
  80187f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801883:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801886:	48 98                	cltq   
  801888:	48 83 ec 08          	sub    $0x8,%rsp
  80188c:	51                   	push   %rcx
  80188d:	49 89 f9             	mov    %rdi,%r9
  801890:	49 89 f0             	mov    %rsi,%r8
  801893:	48 89 d1             	mov    %rdx,%rcx
  801896:	48 89 c2             	mov    %rax,%rdx
  801899:	be 01 00 00 00       	mov    $0x1,%esi
  80189e:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a3:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8018aa:	00 00 00 
  8018ad:	ff d0                	callq  *%rax
  8018af:	48 83 c4 10          	add    $0x10,%rsp
}
  8018b3:	c9                   	leaveq 
  8018b4:	c3                   	retq   

00000000008018b5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018b5:	55                   	push   %rbp
  8018b6:	48 89 e5             	mov    %rsp,%rbp
  8018b9:	48 83 ec 10          	sub    $0x10,%rsp
  8018bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cb:	48 98                	cltq   
  8018cd:	48 83 ec 08          	sub    $0x8,%rsp
  8018d1:	6a 00                	pushq  $0x0
  8018d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018df:	48 89 d1             	mov    %rdx,%rcx
  8018e2:	48 89 c2             	mov    %rax,%rdx
  8018e5:	be 01 00 00 00       	mov    $0x1,%esi
  8018ea:	bf 06 00 00 00       	mov    $0x6,%edi
  8018ef:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
  8018fb:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ff:	c9                   	leaveq 
  801900:	c3                   	retq   

0000000000801901 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801901:	55                   	push   %rbp
  801902:	48 89 e5             	mov    %rsp,%rbp
  801905:	48 83 ec 10          	sub    $0x10,%rsp
  801909:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80190f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801912:	48 63 d0             	movslq %eax,%rdx
  801915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801918:	48 98                	cltq   
  80191a:	48 83 ec 08          	sub    $0x8,%rsp
  80191e:	6a 00                	pushq  $0x0
  801920:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801926:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192c:	48 89 d1             	mov    %rdx,%rcx
  80192f:	48 89 c2             	mov    %rax,%rdx
  801932:	be 01 00 00 00       	mov    $0x1,%esi
  801937:	bf 08 00 00 00       	mov    $0x8,%edi
  80193c:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
  801948:	48 83 c4 10          	add    $0x10,%rsp
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	48 83 ec 10          	sub    $0x10,%rsp
  801956:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801959:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80195d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801964:	48 98                	cltq   
  801966:	48 83 ec 08          	sub    $0x8,%rsp
  80196a:	6a 00                	pushq  $0x0
  80196c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801972:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801978:	48 89 d1             	mov    %rdx,%rcx
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	be 01 00 00 00       	mov    $0x1,%esi
  801983:	bf 09 00 00 00       	mov    $0x9,%edi
  801988:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  80198f:	00 00 00 
  801992:	ff d0                	callq  *%rax
  801994:	48 83 c4 10          	add    $0x10,%rsp
}
  801998:	c9                   	leaveq 
  801999:	c3                   	retq   

000000000080199a <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80199a:	55                   	push   %rbp
  80199b:	48 89 e5             	mov    %rsp,%rbp
  80199e:	48 83 ec 10          	sub    $0x10,%rsp
  8019a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b0:	48 98                	cltq   
  8019b2:	48 83 ec 08          	sub    $0x8,%rsp
  8019b6:	6a 00                	pushq  $0x0
  8019b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c4:	48 89 d1             	mov    %rdx,%rcx
  8019c7:	48 89 c2             	mov    %rax,%rdx
  8019ca:	be 01 00 00 00       	mov    $0x1,%esi
  8019cf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019d4:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8019db:	00 00 00 
  8019de:	ff d0                	callq  *%rax
  8019e0:	48 83 c4 10          	add    $0x10,%rsp
}
  8019e4:	c9                   	leaveq 
  8019e5:	c3                   	retq   

00000000008019e6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 20          	sub    $0x20,%rsp
  8019ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019f9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ff:	48 63 f0             	movslq %eax,%rsi
  801a02:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a09:	48 98                	cltq   
  801a0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0f:	48 83 ec 08          	sub    $0x8,%rsp
  801a13:	6a 00                	pushq  $0x0
  801a15:	49 89 f1             	mov    %rsi,%r9
  801a18:	49 89 c8             	mov    %rcx,%r8
  801a1b:	48 89 d1             	mov    %rdx,%rcx
  801a1e:	48 89 c2             	mov    %rax,%rdx
  801a21:	be 00 00 00 00       	mov    $0x0,%esi
  801a26:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a2b:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801a32:	00 00 00 
  801a35:	ff d0                	callq  *%rax
  801a37:	48 83 c4 10          	add    $0x10,%rsp
}
  801a3b:	c9                   	leaveq 
  801a3c:	c3                   	retq   

0000000000801a3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a3d:	55                   	push   %rbp
  801a3e:	48 89 e5             	mov    %rsp,%rbp
  801a41:	48 83 ec 10          	sub    $0x10,%rsp
  801a45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4d:	48 83 ec 08          	sub    $0x8,%rsp
  801a51:	6a 00                	pushq  $0x0
  801a53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a64:	48 89 c2             	mov    %rax,%rdx
  801a67:	be 01 00 00 00       	mov    $0x1,%esi
  801a6c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a71:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
  801a7d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a81:	c9                   	leaveq 
  801a82:	c3                   	retq   

0000000000801a83 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a87:	48 83 ec 08          	sub    $0x8,%rsp
  801a8b:	6a 00                	pushq  $0x0
  801a8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa3:	be 00 00 00 00       	mov    $0x0,%esi
  801aa8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801aad:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
  801ab9:	48 83 c4 10          	add    $0x10,%rsp
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 10          	sub    $0x10,%rsp
  801ac7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801acb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801ace:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ad1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad5:	48 83 ec 08          	sub    $0x8,%rsp
  801ad9:	6a 00                	pushq  $0x0
  801adb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae7:	48 89 d1             	mov    %rdx,%rcx
  801aea:	48 89 c2             	mov    %rax,%rdx
  801aed:	be 00 00 00 00       	mov    $0x0,%esi
  801af2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801af7:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801afe:	00 00 00 
  801b01:	ff d0                	callq  *%rax
  801b03:	48 83 c4 10          	add    $0x10,%rsp
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
  801b11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b15:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801b18:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1f:	48 83 ec 08          	sub    $0x8,%rsp
  801b23:	6a 00                	pushq  $0x0
  801b25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b31:	48 89 d1             	mov    %rdx,%rcx
  801b34:	48 89 c2             	mov    %rax,%rdx
  801b37:	be 00 00 00 00       	mov    $0x0,%esi
  801b3c:	bf 10 00 00 00       	mov    $0x10,%edi
  801b41:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
  801b4d:	48 83 c4 10          	add    $0x10,%rsp
}
  801b51:	c9                   	leaveq 
  801b52:	c3                   	retq   

0000000000801b53 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 20          	sub    $0x20,%rsp
  801b5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b62:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b65:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b69:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b6d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b70:	48 63 c8             	movslq %eax,%rcx
  801b73:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7a:	48 63 f0             	movslq %eax,%rsi
  801b7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b84:	48 98                	cltq   
  801b86:	48 83 ec 08          	sub    $0x8,%rsp
  801b8a:	51                   	push   %rcx
  801b8b:	49 89 f9             	mov    %rdi,%r9
  801b8e:	49 89 f0             	mov    %rsi,%r8
  801b91:	48 89 d1             	mov    %rdx,%rcx
  801b94:	48 89 c2             	mov    %rax,%rdx
  801b97:	be 00 00 00 00       	mov    $0x0,%esi
  801b9c:	bf 11 00 00 00       	mov    $0x11,%edi
  801ba1:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
  801bad:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
  801bb7:	48 83 ec 10          	sub    $0x10,%rsp
  801bbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801bc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcb:	48 83 ec 08          	sub    $0x8,%rsp
  801bcf:	6a 00                	pushq  $0x0
  801bd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdd:	48 89 d1             	mov    %rdx,%rcx
  801be0:	48 89 c2             	mov    %rax,%rdx
  801be3:	be 00 00 00 00       	mov    $0x0,%esi
  801be8:	bf 12 00 00 00       	mov    $0x12,%edi
  801bed:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801bf4:	00 00 00 
  801bf7:	ff d0                	callq  *%rax
  801bf9:	48 83 c4 10          	add    $0x10,%rsp
}
  801bfd:	c9                   	leaveq 
  801bfe:	c3                   	retq   

0000000000801bff <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801bff:	55                   	push   %rbp
  801c00:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801c03:	48 83 ec 08          	sub    $0x8,%rsp
  801c07:	6a 00                	pushq  $0x0
  801c09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c15:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1f:	be 00 00 00 00       	mov    $0x0,%esi
  801c24:	bf 13 00 00 00       	mov    $0x13,%edi
  801c29:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	callq  *%rax
  801c35:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801c39:	90                   	nop
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 10          	sub    $0x10,%rsp
  801c44:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4a:	48 98                	cltq   
  801c4c:	48 83 ec 08          	sub    $0x8,%rsp
  801c50:	6a 00                	pushq  $0x0
  801c52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	be 00 00 00 00       	mov    $0x0,%esi
  801c6b:	bf 14 00 00 00       	mov    $0x14,%edi
  801c70:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801c86:	48 83 ec 08          	sub    $0x8,%rsp
  801c8a:	6a 00                	pushq  $0x0
  801c8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca2:	be 00 00 00 00       	mov    $0x0,%esi
  801ca7:	bf 15 00 00 00       	mov    $0x15,%edi
  801cac:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
  801cb8:	48 83 c4 10          	add    $0x10,%rsp
}
  801cbc:	c9                   	leaveq 
  801cbd:	c3                   	retq   

0000000000801cbe <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801cc2:	48 83 ec 08          	sub    $0x8,%rsp
  801cc6:	6a 00                	pushq  $0x0
  801cc8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cde:	be 00 00 00 00       	mov    $0x0,%esi
  801ce3:	bf 16 00 00 00       	mov    $0x16,%edi
  801ce8:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	callq  *%rax
  801cf4:	48 83 c4 10          	add    $0x10,%rsp
}
  801cf8:	90                   	nop
  801cf9:	c9                   	leaveq 
  801cfa:	c3                   	retq   

0000000000801cfb <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 83 ec 30          	sub    $0x30,%rsp
  801d03:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0b:	48 8b 00             	mov    (%rax),%rax
  801d0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801d12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d16:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d1a:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d20:	83 e0 02             	and    $0x2,%eax
  801d23:	85 c0                	test   %eax,%eax
  801d25:	75 40                	jne    801d67 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801d27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d2b:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801d32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d36:	49 89 d0             	mov    %rdx,%r8
  801d39:	48 89 c1             	mov    %rax,%rcx
  801d3c:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  801d43:	00 00 00 
  801d46:	be 1f 00 00 00       	mov    $0x1f,%esi
  801d4b:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  801d52:	00 00 00 
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	49 b9 c1 43 80 00 00 	movabs $0x8043c1,%r9
  801d61:	00 00 00 
  801d64:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801d67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d6b:	48 c1 e8 0c          	shr    $0xc,%rax
  801d6f:	48 89 c2             	mov    %rax,%rdx
  801d72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d79:	01 00 00 
  801d7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d80:	25 07 08 00 00       	and    $0x807,%eax
  801d85:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801d8b:	74 4e                	je     801ddb <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801d8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d91:	48 c1 e8 0c          	shr    $0xc,%rax
  801d95:	48 89 c2             	mov    %rax,%rdx
  801d98:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d9f:	01 00 00 
  801da2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801da6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801daa:	49 89 d0             	mov    %rdx,%r8
  801dad:	48 89 c1             	mov    %rax,%rcx
  801db0:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  801db7:	00 00 00 
  801dba:	be 22 00 00 00       	mov    $0x22,%esi
  801dbf:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  801dc6:	00 00 00 
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	49 b9 c1 43 80 00 00 	movabs $0x8043c1,%r9
  801dd5:	00 00 00 
  801dd8:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ddb:	ba 07 00 00 00       	mov    $0x7,%edx
  801de0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801de5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dea:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  801df1:	00 00 00 
  801df4:	ff d0                	callq  *%rax
  801df6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801df9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801dfd:	79 30                	jns    801e2f <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801dff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e02:	89 c1                	mov    %eax,%ecx
  801e04:	48 ba eb 4d 80 00 00 	movabs $0x804deb,%rdx
  801e0b:	00 00 00 
  801e0e:	be 28 00 00 00       	mov    $0x28,%esi
  801e13:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  801e1a:	00 00 00 
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  801e29:	00 00 00 
  801e2c:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801e2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e33:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e41:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e46:	48 89 c6             	mov    %rax,%rsi
  801e49:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e4e:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801e5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e66:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e6c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e72:	48 89 c1             	mov    %rax,%rcx
  801e75:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e84:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	callq  *%rax
  801e90:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801e93:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e97:	79 30                	jns    801ec9 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801e99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e9c:	89 c1                	mov    %eax,%ecx
  801e9e:	48 ba fe 4d 80 00 00 	movabs $0x804dfe,%rdx
  801ea5:	00 00 00 
  801ea8:	be 2d 00 00 00       	mov    $0x2d,%esi
  801ead:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  801eb4:	00 00 00 
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  801ec3:	00 00 00 
  801ec6:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801ec9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ece:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed3:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  801eda:	00 00 00 
  801edd:	ff d0                	callq  *%rax
  801edf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801ee2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ee6:	79 30                	jns    801f18 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eeb:	89 c1                	mov    %eax,%ecx
  801eed:	48 ba 0f 4e 80 00 00 	movabs $0x804e0f,%rdx
  801ef4:	00 00 00 
  801ef7:	be 31 00 00 00       	mov    $0x31,%esi
  801efc:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  801f03:	00 00 00 
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0b:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  801f12:	00 00 00 
  801f15:	41 ff d0             	callq  *%r8

}
  801f18:	90                   	nop
  801f19:	c9                   	leaveq 
  801f1a:	c3                   	retq   

0000000000801f1b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f1b:	55                   	push   %rbp
  801f1c:	48 89 e5             	mov    %rsp,%rbp
  801f1f:	48 83 ec 30          	sub    $0x30,%rsp
  801f23:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f26:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801f29:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801f2c:	c1 e0 0c             	shl    $0xc,%eax
  801f2f:	89 c0                	mov    %eax,%eax
  801f31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801f35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f3c:	01 00 00 
  801f3f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801f42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4e:	25 02 08 00 00       	and    $0x802,%eax
  801f53:	48 85 c0             	test   %rax,%rax
  801f56:	74 0e                	je     801f66 <duppage+0x4b>
  801f58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5c:	25 00 04 00 00       	and    $0x400,%eax
  801f61:	48 85 c0             	test   %rax,%rax
  801f64:	74 70                	je     801fd6 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6a:	25 07 0e 00 00       	and    $0xe07,%eax
  801f6f:	89 c6                	mov    %eax,%esi
  801f71:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801f75:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7c:	41 89 f0             	mov    %esi,%r8d
  801f7f:	48 89 c6             	mov    %rax,%rsi
  801f82:	bf 00 00 00 00       	mov    $0x0,%edi
  801f87:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	callq  *%rax
  801f93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f9a:	79 30                	jns    801fcc <duppage+0xb1>
			panic("sys_page_map: %e", r);
  801f9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f9f:	89 c1                	mov    %eax,%ecx
  801fa1:	48 ba fe 4d 80 00 00 	movabs $0x804dfe,%rdx
  801fa8:	00 00 00 
  801fab:	be 50 00 00 00       	mov    $0x50,%esi
  801fb0:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  801fb7:	00 00 00 
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbf:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  801fc6:	00 00 00 
  801fc9:	41 ff d0             	callq  *%r8
		return 0;
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	e9 c4 00 00 00       	jmpq   80209a <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801fd6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801fda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe1:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801fe7:	48 89 c6             	mov    %rax,%rsi
  801fea:	bf 00 00 00 00       	mov    $0x0,%edi
  801fef:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
  801ffb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ffe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802002:	79 30                	jns    802034 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802004:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802007:	89 c1                	mov    %eax,%ecx
  802009:	48 ba fe 4d 80 00 00 	movabs $0x804dfe,%rdx
  802010:	00 00 00 
  802013:	be 64 00 00 00       	mov    $0x64,%esi
  802018:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  80201f:	00 00 00 
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  80202e:	00 00 00 
  802031:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802034:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802038:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80203c:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802042:	48 89 d1             	mov    %rdx,%rcx
  802045:	ba 00 00 00 00       	mov    $0x0,%edx
  80204a:	48 89 c6             	mov    %rax,%rsi
  80204d:	bf 00 00 00 00       	mov    $0x0,%edi
  802052:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  802059:	00 00 00 
  80205c:	ff d0                	callq  *%rax
  80205e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802061:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802065:	79 30                	jns    802097 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802067:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80206a:	89 c1                	mov    %eax,%ecx
  80206c:	48 ba fe 4d 80 00 00 	movabs $0x804dfe,%rdx
  802073:	00 00 00 
  802076:	be 66 00 00 00       	mov    $0x66,%esi
  80207b:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  802082:	00 00 00 
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  802091:	00 00 00 
  802094:	41 ff d0             	callq  *%r8
	return r;
  802097:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80209a:	c9                   	leaveq 
  80209b:	c3                   	retq   

000000000080209c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80209c:	55                   	push   %rbp
  80209d:	48 89 e5             	mov    %rsp,%rbp
  8020a0:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8020a4:	48 bf fb 1c 80 00 00 	movabs $0x801cfb,%rdi
  8020ab:	00 00 00 
  8020ae:	48 b8 d5 44 80 00 00 	movabs $0x8044d5,%rax
  8020b5:	00 00 00 
  8020b8:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020ba:	b8 07 00 00 00       	mov    $0x7,%eax
  8020bf:	cd 30                	int    $0x30
  8020c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020c4:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8020c7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8020ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020ce:	79 08                	jns    8020d8 <fork+0x3c>
		return envid;
  8020d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020d3:	e9 0b 02 00 00       	jmpq   8022e3 <fork+0x247>
	if (envid == 0) {
  8020d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020dc:	75 3e                	jne    80211c <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8020de:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  8020e5:	00 00 00 
  8020e8:	ff d0                	callq  *%rax
  8020ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020ef:	48 98                	cltq   
  8020f1:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8020f8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8020ff:	00 00 00 
  802102:	48 01 c2             	add    %rax,%rdx
  802105:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80210c:	00 00 00 
  80210f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	e9 c7 01 00 00       	jmpq   8022e3 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80211c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802123:	e9 a6 00 00 00       	jmpq   8021ce <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212b:	c1 f8 12             	sar    $0x12,%eax
  80212e:	89 c2                	mov    %eax,%edx
  802130:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802137:	01 00 00 
  80213a:	48 63 d2             	movslq %edx,%rdx
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	48 85 c0             	test   %rax,%rax
  802147:	74 21                	je     80216a <fork+0xce>
  802149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214c:	c1 f8 09             	sar    $0x9,%eax
  80214f:	89 c2                	mov    %eax,%edx
  802151:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802158:	01 00 00 
  80215b:	48 63 d2             	movslq %edx,%rdx
  80215e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802162:	83 e0 01             	and    $0x1,%eax
  802165:	48 85 c0             	test   %rax,%rax
  802168:	75 09                	jne    802173 <fork+0xd7>
			pn += NPTENTRIES;
  80216a:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802171:	eb 5b                	jmp    8021ce <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802176:	05 00 02 00 00       	add    $0x200,%eax
  80217b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80217e:	eb 46                	jmp    8021c6 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802180:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802187:	01 00 00 
  80218a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80218d:	48 63 d2             	movslq %edx,%rdx
  802190:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802194:	83 e0 05             	and    $0x5,%eax
  802197:	48 83 f8 05          	cmp    $0x5,%rax
  80219b:	75 21                	jne    8021be <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80219d:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8021a4:	74 1b                	je     8021c1 <fork+0x125>
				continue;
			duppage(envid, pn);
  8021a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021ac:	89 d6                	mov    %edx,%esi
  8021ae:	89 c7                	mov    %eax,%edi
  8021b0:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
  8021bc:	eb 04                	jmp    8021c2 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  8021be:	90                   	nop
  8021bf:	eb 01                	jmp    8021c2 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  8021c1:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8021c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c9:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8021cc:	7c b2                	jl     802180 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8021ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d1:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8021d6:	0f 86 4c ff ff ff    	jbe    802128 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8021dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021df:	ba 07 00 00 00       	mov    $0x7,%edx
  8021e4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8021e9:	89 c7                	mov    %eax,%edi
  8021eb:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	callq  *%rax
  8021f7:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8021fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8021fe:	79 30                	jns    802230 <fork+0x194>
		panic("allocating exception stack: %e", r);
  802200:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802203:	89 c1                	mov    %eax,%ecx
  802205:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  80220c:	00 00 00 
  80220f:	be 9e 00 00 00       	mov    $0x9e,%esi
  802214:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  80221b:	00 00 00 
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  80222a:	00 00 00 
  80222d:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802230:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802237:	00 00 00 
  80223a:	48 8b 00             	mov    (%rax),%rax
  80223d:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802244:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802247:	48 89 d6             	mov    %rdx,%rsi
  80224a:	89 c7                	mov    %eax,%edi
  80224c:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80225b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80225f:	79 30                	jns    802291 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802261:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802264:	89 c1                	mov    %eax,%ecx
  802266:	48 ba 48 4e 80 00 00 	movabs $0x804e48,%rdx
  80226d:	00 00 00 
  802270:	be a2 00 00 00       	mov    $0xa2,%esi
  802275:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  80227c:	00 00 00 
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
  802284:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  80228b:	00 00 00 
  80228e:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802291:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802294:	be 02 00 00 00       	mov    $0x2,%esi
  802299:	89 c7                	mov    %eax,%edi
  80229b:	48 b8 01 19 80 00 00 	movabs $0x801901,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax
  8022a7:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8022aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8022ae:	79 30                	jns    8022e0 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  8022b0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8022b3:	89 c1                	mov    %eax,%ecx
  8022b5:	48 ba 67 4e 80 00 00 	movabs $0x804e67,%rdx
  8022bc:	00 00 00 
  8022bf:	be a7 00 00 00       	mov    $0xa7,%esi
  8022c4:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  8022cb:	00 00 00 
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  8022da:	00 00 00 
  8022dd:	41 ff d0             	callq  *%r8

	return envid;
  8022e0:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <sfork>:

// Challenge!
int
sfork(void)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022e9:	48 ba 7e 4e 80 00 00 	movabs $0x804e7e,%rdx
  8022f0:	00 00 00 
  8022f3:	be b1 00 00 00       	mov    $0xb1,%esi
  8022f8:	48 bf b1 4d 80 00 00 	movabs $0x804db1,%rdi
  8022ff:	00 00 00 
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	48 b9 c1 43 80 00 00 	movabs $0x8043c1,%rcx
  80230e:	00 00 00 
  802311:	ff d1                	callq  *%rcx

0000000000802313 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802313:	55                   	push   %rbp
  802314:	48 89 e5             	mov    %rsp,%rbp
  802317:	48 83 ec 08          	sub    $0x8,%rsp
  80231b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80231f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802323:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80232a:	ff ff ff 
  80232d:	48 01 d0             	add    %rdx,%rax
  802330:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 08          	sub    $0x8,%rsp
  80233e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802346:	48 89 c7             	mov    %rax,%rdi
  802349:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802350:	00 00 00 
  802353:	ff d0                	callq  *%rax
  802355:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80235b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80235f:	c9                   	leaveq 
  802360:	c3                   	retq   

0000000000802361 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802361:	55                   	push   %rbp
  802362:	48 89 e5             	mov    %rsp,%rbp
  802365:	48 83 ec 18          	sub    $0x18,%rsp
  802369:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80236d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802374:	eb 6b                	jmp    8023e1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802379:	48 98                	cltq   
  80237b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802381:	48 c1 e0 0c          	shl    $0xc,%rax
  802385:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238d:	48 c1 e8 15          	shr    $0x15,%rax
  802391:	48 89 c2             	mov    %rax,%rdx
  802394:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80239b:	01 00 00 
  80239e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a2:	83 e0 01             	and    $0x1,%eax
  8023a5:	48 85 c0             	test   %rax,%rax
  8023a8:	74 21                	je     8023cb <fd_alloc+0x6a>
  8023aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8023b2:	48 89 c2             	mov    %rax,%rdx
  8023b5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023bc:	01 00 00 
  8023bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c3:	83 e0 01             	and    $0x1,%eax
  8023c6:	48 85 c0             	test   %rax,%rax
  8023c9:	75 12                	jne    8023dd <fd_alloc+0x7c>
			*fd_store = fd;
  8023cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023db:	eb 1a                	jmp    8023f7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023e1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023e5:	7e 8f                	jle    802376 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023f2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023f7:	c9                   	leaveq 
  8023f8:	c3                   	retq   

00000000008023f9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023f9:	55                   	push   %rbp
  8023fa:	48 89 e5             	mov    %rsp,%rbp
  8023fd:	48 83 ec 20          	sub    $0x20,%rsp
  802401:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802408:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80240c:	78 06                	js     802414 <fd_lookup+0x1b>
  80240e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802412:	7e 07                	jle    80241b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802419:	eb 6c                	jmp    802487 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80241b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80241e:	48 98                	cltq   
  802420:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802426:	48 c1 e0 0c          	shl    $0xc,%rax
  80242a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80242e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802432:	48 c1 e8 15          	shr    $0x15,%rax
  802436:	48 89 c2             	mov    %rax,%rdx
  802439:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802440:	01 00 00 
  802443:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802447:	83 e0 01             	and    $0x1,%eax
  80244a:	48 85 c0             	test   %rax,%rax
  80244d:	74 21                	je     802470 <fd_lookup+0x77>
  80244f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802453:	48 c1 e8 0c          	shr    $0xc,%rax
  802457:	48 89 c2             	mov    %rax,%rdx
  80245a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802461:	01 00 00 
  802464:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802468:	83 e0 01             	and    $0x1,%eax
  80246b:	48 85 c0             	test   %rax,%rax
  80246e:	75 07                	jne    802477 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802475:	eb 10                	jmp    802487 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	c9                   	leaveq 
  802488:	c3                   	retq   

0000000000802489 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802489:	55                   	push   %rbp
  80248a:	48 89 e5             	mov    %rsp,%rbp
  80248d:	48 83 ec 30          	sub    $0x30,%rsp
  802491:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802495:	89 f0                	mov    %esi,%eax
  802497:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80249a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80249e:	48 89 c7             	mov    %rax,%rdi
  8024a1:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	89 c2                	mov    %eax,%edx
  8024af:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024b3:	48 89 c6             	mov    %rax,%rsi
  8024b6:	89 d7                	mov    %edx,%edi
  8024b8:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	callq  *%rax
  8024c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cb:	78 0a                	js     8024d7 <fd_close+0x4e>
	    || fd != fd2)
  8024cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024d5:	74 12                	je     8024e9 <fd_close+0x60>
		return (must_exist ? r : 0);
  8024d7:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024db:	74 05                	je     8024e2 <fd_close+0x59>
  8024dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e0:	eb 70                	jmp    802552 <fd_close+0xc9>
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e7:	eb 69                	jmp    802552 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ed:	8b 00                	mov    (%rax),%eax
  8024ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f3:	48 89 d6             	mov    %rdx,%rsi
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	callq  *%rax
  802504:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802507:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250b:	78 2a                	js     802537 <fd_close+0xae>
		if (dev->dev_close)
  80250d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802511:	48 8b 40 20          	mov    0x20(%rax),%rax
  802515:	48 85 c0             	test   %rax,%rax
  802518:	74 16                	je     802530 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80251a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802522:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802526:	48 89 d7             	mov    %rdx,%rdi
  802529:	ff d0                	callq  *%rax
  80252b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252e:	eb 07                	jmp    802537 <fd_close+0xae>
		else
			r = 0;
  802530:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253b:	48 89 c6             	mov    %rax,%rsi
  80253e:	bf 00 00 00 00       	mov    $0x0,%edi
  802543:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  80254a:	00 00 00 
  80254d:	ff d0                	callq  *%rax
	return r;
  80254f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802552:	c9                   	leaveq 
  802553:	c3                   	retq   

0000000000802554 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802554:	55                   	push   %rbp
  802555:	48 89 e5             	mov    %rsp,%rbp
  802558:	48 83 ec 20          	sub    $0x20,%rsp
  80255c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80255f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802563:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80256a:	eb 41                	jmp    8025ad <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80256c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802573:	00 00 00 
  802576:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802579:	48 63 d2             	movslq %edx,%rdx
  80257c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802580:	8b 00                	mov    (%rax),%eax
  802582:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802585:	75 22                	jne    8025a9 <dev_lookup+0x55>
			*dev = devtab[i];
  802587:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80258e:	00 00 00 
  802591:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802594:	48 63 d2             	movslq %edx,%rdx
  802597:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80259b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a7:	eb 60                	jmp    802609 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025ad:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025b4:	00 00 00 
  8025b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ba:	48 63 d2             	movslq %edx,%rdx
  8025bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c1:	48 85 c0             	test   %rax,%rax
  8025c4:	75 a6                	jne    80256c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025c6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025cd:	00 00 00 
  8025d0:	48 8b 00             	mov    (%rax),%rax
  8025d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025d9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025dc:	89 c6                	mov    %eax,%esi
  8025de:	48 bf 98 4e 80 00 00 	movabs $0x804e98,%rdi
  8025e5:	00 00 00 
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ed:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  8025f4:	00 00 00 
  8025f7:	ff d1                	callq  *%rcx
	*dev = 0;
  8025f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025fd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802604:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802609:	c9                   	leaveq 
  80260a:	c3                   	retq   

000000000080260b <close>:

int
close(int fdnum)
{
  80260b:	55                   	push   %rbp
  80260c:	48 89 e5             	mov    %rsp,%rbp
  80260f:	48 83 ec 20          	sub    $0x20,%rsp
  802613:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802616:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261d:	48 89 d6             	mov    %rdx,%rsi
  802620:	89 c7                	mov    %eax,%edi
  802622:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
  80262e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802631:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802635:	79 05                	jns    80263c <close+0x31>
		return r;
  802637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263a:	eb 18                	jmp    802654 <close+0x49>
	else
		return fd_close(fd, 1);
  80263c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802640:	be 01 00 00 00       	mov    $0x1,%esi
  802645:	48 89 c7             	mov    %rax,%rdi
  802648:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
}
  802654:	c9                   	leaveq 
  802655:	c3                   	retq   

0000000000802656 <close_all>:

void
close_all(void)
{
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80265e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802665:	eb 15                	jmp    80267c <close_all+0x26>
		close(i);
  802667:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266a:	89 c7                	mov    %eax,%edi
  80266c:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  802673:	00 00 00 
  802676:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802678:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80267c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802680:	7e e5                	jle    802667 <close_all+0x11>
		close(i);
}
  802682:	90                   	nop
  802683:	c9                   	leaveq 
  802684:	c3                   	retq   

0000000000802685 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802685:	55                   	push   %rbp
  802686:	48 89 e5             	mov    %rsp,%rbp
  802689:	48 83 ec 40          	sub    $0x40,%rsp
  80268d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802690:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802693:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802697:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80269a:	48 89 d6             	mov    %rdx,%rsi
  80269d:	89 c7                	mov    %eax,%edi
  80269f:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	callq  *%rax
  8026ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b2:	79 08                	jns    8026bc <dup+0x37>
		return r;
  8026b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b7:	e9 70 01 00 00       	jmpq   80282c <dup+0x1a7>
	close(newfdnum);
  8026bc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026bf:	89 c7                	mov    %eax,%edi
  8026c1:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026d0:	48 98                	cltq   
  8026d2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026d8:	48 c1 e0 0c          	shl    $0xc,%rax
  8026dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e4:	48 89 c7             	mov    %rax,%rdi
  8026e7:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8026ee:	00 00 00 
  8026f1:	ff d0                	callq  *%rax
  8026f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fb:	48 89 c7             	mov    %rax,%rdi
  8026fe:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  802705:	00 00 00 
  802708:	ff d0                	callq  *%rax
  80270a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80270e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802712:	48 c1 e8 15          	shr    $0x15,%rax
  802716:	48 89 c2             	mov    %rax,%rdx
  802719:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802720:	01 00 00 
  802723:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802727:	83 e0 01             	and    $0x1,%eax
  80272a:	48 85 c0             	test   %rax,%rax
  80272d:	74 71                	je     8027a0 <dup+0x11b>
  80272f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802733:	48 c1 e8 0c          	shr    $0xc,%rax
  802737:	48 89 c2             	mov    %rax,%rdx
  80273a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802741:	01 00 00 
  802744:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802748:	83 e0 01             	and    $0x1,%eax
  80274b:	48 85 c0             	test   %rax,%rax
  80274e:	74 50                	je     8027a0 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802754:	48 c1 e8 0c          	shr    $0xc,%rax
  802758:	48 89 c2             	mov    %rax,%rdx
  80275b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802762:	01 00 00 
  802765:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802769:	25 07 0e 00 00       	and    $0xe07,%eax
  80276e:	89 c1                	mov    %eax,%ecx
  802770:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802778:	41 89 c8             	mov    %ecx,%r8d
  80277b:	48 89 d1             	mov    %rdx,%rcx
  80277e:	ba 00 00 00 00       	mov    $0x0,%edx
  802783:	48 89 c6             	mov    %rax,%rsi
  802786:	bf 00 00 00 00       	mov    $0x0,%edi
  80278b:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
  802797:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279e:	78 55                	js     8027f5 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8027a8:	48 89 c2             	mov    %rax,%rdx
  8027ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027b2:	01 00 00 
  8027b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8027be:	89 c1                	mov    %eax,%ecx
  8027c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027c8:	41 89 c8             	mov    %ecx,%r8d
  8027cb:	48 89 d1             	mov    %rdx,%rcx
  8027ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d3:	48 89 c6             	mov    %rax,%rsi
  8027d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027db:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  8027e2:	00 00 00 
  8027e5:	ff d0                	callq  *%rax
  8027e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ee:	78 08                	js     8027f8 <dup+0x173>
		goto err;

	return newfdnum;
  8027f0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027f3:	eb 37                	jmp    80282c <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8027f5:	90                   	nop
  8027f6:	eb 01                	jmp    8027f9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8027f8:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8027f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fd:	48 89 c6             	mov    %rax,%rsi
  802800:	bf 00 00 00 00       	mov    $0x0,%edi
  802805:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802811:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802815:	48 89 c6             	mov    %rax,%rsi
  802818:	bf 00 00 00 00       	mov    $0x0,%edi
  80281d:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  802824:	00 00 00 
  802827:	ff d0                	callq  *%rax
	return r;
  802829:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80282c:	c9                   	leaveq 
  80282d:	c3                   	retq   

000000000080282e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80282e:	55                   	push   %rbp
  80282f:	48 89 e5             	mov    %rsp,%rbp
  802832:	48 83 ec 40          	sub    $0x40,%rsp
  802836:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802839:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80283d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802841:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802845:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802848:	48 89 d6             	mov    %rdx,%rsi
  80284b:	89 c7                	mov    %eax,%edi
  80284d:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802854:	00 00 00 
  802857:	ff d0                	callq  *%rax
  802859:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802860:	78 24                	js     802886 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802866:	8b 00                	mov    (%rax),%eax
  802868:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80286c:	48 89 d6             	mov    %rdx,%rsi
  80286f:	89 c7                	mov    %eax,%edi
  802871:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
  80287d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802884:	79 05                	jns    80288b <read+0x5d>
		return r;
  802886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802889:	eb 76                	jmp    802901 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80288b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288f:	8b 40 08             	mov    0x8(%rax),%eax
  802892:	83 e0 03             	and    $0x3,%eax
  802895:	83 f8 01             	cmp    $0x1,%eax
  802898:	75 3a                	jne    8028d4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80289a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8028a1:	00 00 00 
  8028a4:	48 8b 00             	mov    (%rax),%rax
  8028a7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028ad:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028b0:	89 c6                	mov    %eax,%esi
  8028b2:	48 bf b7 4e 80 00 00 	movabs $0x804eb7,%rdi
  8028b9:	00 00 00 
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c1:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  8028c8:	00 00 00 
  8028cb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d2:	eb 2d                	jmp    802901 <read+0xd3>
	}
	if (!dev->dev_read)
  8028d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028dc:	48 85 c0             	test   %rax,%rax
  8028df:	75 07                	jne    8028e8 <read+0xba>
		return -E_NOT_SUPP;
  8028e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028e6:	eb 19                	jmp    802901 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028f8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028fc:	48 89 cf             	mov    %rcx,%rdi
  8028ff:	ff d0                	callq  *%rax
}
  802901:	c9                   	leaveq 
  802902:	c3                   	retq   

0000000000802903 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802903:	55                   	push   %rbp
  802904:	48 89 e5             	mov    %rsp,%rbp
  802907:	48 83 ec 30          	sub    $0x30,%rsp
  80290b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80290e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802912:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802916:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80291d:	eb 47                	jmp    802966 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80291f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802922:	48 98                	cltq   
  802924:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802928:	48 29 c2             	sub    %rax,%rdx
  80292b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292e:	48 63 c8             	movslq %eax,%rcx
  802931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802935:	48 01 c1             	add    %rax,%rcx
  802938:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80293b:	48 89 ce             	mov    %rcx,%rsi
  80293e:	89 c7                	mov    %eax,%edi
  802940:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802947:	00 00 00 
  80294a:	ff d0                	callq  *%rax
  80294c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80294f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802953:	79 05                	jns    80295a <readn+0x57>
			return m;
  802955:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802958:	eb 1d                	jmp    802977 <readn+0x74>
		if (m == 0)
  80295a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80295e:	74 13                	je     802973 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802960:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802963:	01 45 fc             	add    %eax,-0x4(%rbp)
  802966:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802969:	48 98                	cltq   
  80296b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80296f:	72 ae                	jb     80291f <readn+0x1c>
  802971:	eb 01                	jmp    802974 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802973:	90                   	nop
	}
	return tot;
  802974:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802977:	c9                   	leaveq 
  802978:	c3                   	retq   

0000000000802979 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802979:	55                   	push   %rbp
  80297a:	48 89 e5             	mov    %rsp,%rbp
  80297d:	48 83 ec 40          	sub    $0x40,%rsp
  802981:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802984:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802988:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80298c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802990:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802993:	48 89 d6             	mov    %rdx,%rsi
  802996:	89 c7                	mov    %eax,%edi
  802998:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
  8029a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ab:	78 24                	js     8029d1 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b1:	8b 00                	mov    (%rax),%eax
  8029b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b7:	48 89 d6             	mov    %rdx,%rsi
  8029ba:	89 c7                	mov    %eax,%edi
  8029bc:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax
  8029c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cf:	79 05                	jns    8029d6 <write+0x5d>
		return r;
  8029d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d4:	eb 75                	jmp    802a4b <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029da:	8b 40 08             	mov    0x8(%rax),%eax
  8029dd:	83 e0 03             	and    $0x3,%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	75 3a                	jne    802a1e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029e4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029eb:	00 00 00 
  8029ee:	48 8b 00             	mov    (%rax),%rax
  8029f1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029fa:	89 c6                	mov    %eax,%esi
  8029fc:	48 bf d3 4e 80 00 00 	movabs $0x804ed3,%rdi
  802a03:	00 00 00 
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  802a12:	00 00 00 
  802a15:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a1c:	eb 2d                	jmp    802a4b <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a22:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a26:	48 85 c0             	test   %rax,%rax
  802a29:	75 07                	jne    802a32 <write+0xb9>
		return -E_NOT_SUPP;
  802a2b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a30:	eb 19                	jmp    802a4b <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a36:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a3e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a42:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a46:	48 89 cf             	mov    %rcx,%rdi
  802a49:	ff d0                	callq  *%rax
}
  802a4b:	c9                   	leaveq 
  802a4c:	c3                   	retq   

0000000000802a4d <seek>:

int
seek(int fdnum, off_t offset)
{
  802a4d:	55                   	push   %rbp
  802a4e:	48 89 e5             	mov    %rsp,%rbp
  802a51:	48 83 ec 18          	sub    $0x18,%rsp
  802a55:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a58:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a5b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a62:	48 89 d6             	mov    %rdx,%rsi
  802a65:	89 c7                	mov    %eax,%edi
  802a67:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	callq  *%rax
  802a73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7a:	79 05                	jns    802a81 <seek+0x34>
		return r;
  802a7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7f:	eb 0f                	jmp    802a90 <seek+0x43>
	fd->fd_offset = offset;
  802a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a85:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a90:	c9                   	leaveq 
  802a91:	c3                   	retq   

0000000000802a92 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a92:	55                   	push   %rbp
  802a93:	48 89 e5             	mov    %rsp,%rbp
  802a96:	48 83 ec 30          	sub    $0x30,%rsp
  802a9a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a9d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aa4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aa7:	48 89 d6             	mov    %rdx,%rsi
  802aaa:	89 c7                	mov    %eax,%edi
  802aac:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802ab3:	00 00 00 
  802ab6:	ff d0                	callq  *%rax
  802ab8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802abb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abf:	78 24                	js     802ae5 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac5:	8b 00                	mov    (%rax),%eax
  802ac7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802acb:	48 89 d6             	mov    %rdx,%rsi
  802ace:	89 c7                	mov    %eax,%edi
  802ad0:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
  802adc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae3:	79 05                	jns    802aea <ftruncate+0x58>
		return r;
  802ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae8:	eb 72                	jmp    802b5c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aee:	8b 40 08             	mov    0x8(%rax),%eax
  802af1:	83 e0 03             	and    $0x3,%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	75 3a                	jne    802b32 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802af8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802aff:	00 00 00 
  802b02:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b05:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b0b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b0e:	89 c6                	mov    %eax,%esi
  802b10:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  802b17:	00 00 00 
  802b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1f:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  802b26:	00 00 00 
  802b29:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b30:	eb 2a                	jmp    802b5c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b36:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b3a:	48 85 c0             	test   %rax,%rax
  802b3d:	75 07                	jne    802b46 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b3f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b44:	eb 16                	jmp    802b5c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b52:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b55:	89 ce                	mov    %ecx,%esi
  802b57:	48 89 d7             	mov    %rdx,%rdi
  802b5a:	ff d0                	callq  *%rax
}
  802b5c:	c9                   	leaveq 
  802b5d:	c3                   	retq   

0000000000802b5e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b5e:	55                   	push   %rbp
  802b5f:	48 89 e5             	mov    %rsp,%rbp
  802b62:	48 83 ec 30          	sub    $0x30,%rsp
  802b66:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b69:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b74:	48 89 d6             	mov    %rdx,%rsi
  802b77:	89 c7                	mov    %eax,%edi
  802b79:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
  802b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8c:	78 24                	js     802bb2 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b92:	8b 00                	mov    (%rax),%eax
  802b94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b98:	48 89 d6             	mov    %rdx,%rsi
  802b9b:	89 c7                	mov    %eax,%edi
  802b9d:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
  802ba9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb0:	79 05                	jns    802bb7 <fstat+0x59>
		return r;
  802bb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb5:	eb 5e                	jmp    802c15 <fstat+0xb7>
	if (!dev->dev_stat)
  802bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbb:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bbf:	48 85 c0             	test   %rax,%rax
  802bc2:	75 07                	jne    802bcb <fstat+0x6d>
		return -E_NOT_SUPP;
  802bc4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc9:	eb 4a                	jmp    802c15 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bcf:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd6:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bdd:	00 00 00 
	stat->st_isdir = 0;
  802be0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802beb:	00 00 00 
	stat->st_dev = dev;
  802bee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bf2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c01:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c09:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c0d:	48 89 ce             	mov    %rcx,%rsi
  802c10:	48 89 d7             	mov    %rdx,%rdi
  802c13:	ff d0                	callq  *%rax
}
  802c15:	c9                   	leaveq 
  802c16:	c3                   	retq   

0000000000802c17 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c17:	55                   	push   %rbp
  802c18:	48 89 e5             	mov    %rsp,%rbp
  802c1b:	48 83 ec 20          	sub    $0x20,%rsp
  802c1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2b:	be 00 00 00 00       	mov    $0x0,%esi
  802c30:	48 89 c7             	mov    %rax,%rdi
  802c33:	48 b8 07 2d 80 00 00 	movabs $0x802d07,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax
  802c3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c46:	79 05                	jns    802c4d <stat+0x36>
		return fd;
  802c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4b:	eb 2f                	jmp    802c7c <stat+0x65>
	r = fstat(fd, stat);
  802c4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c54:	48 89 d6             	mov    %rdx,%rsi
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 5e 2b 80 00 00 	movabs $0x802b5e,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6b:	89 c7                	mov    %eax,%edi
  802c6d:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
	return r;
  802c79:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c7c:	c9                   	leaveq 
  802c7d:	c3                   	retq   

0000000000802c7e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c7e:	55                   	push   %rbp
  802c7f:	48 89 e5             	mov    %rsp,%rbp
  802c82:	48 83 ec 10          	sub    $0x10,%rsp
  802c86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c8d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c94:	00 00 00 
  802c97:	8b 00                	mov    (%rax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	75 1f                	jne    802cbc <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c9d:	bf 01 00 00 00       	mov    $0x1,%edi
  802ca2:	48 b8 54 47 80 00 00 	movabs $0x804754,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
  802cae:	89 c2                	mov    %eax,%edx
  802cb0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cb7:	00 00 00 
  802cba:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cbc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cc3:	00 00 00 
  802cc6:	8b 00                	mov    (%rax),%eax
  802cc8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ccb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cd0:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802cd7:	00 00 00 
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 bf 46 80 00 00 	movabs $0x8046bf,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ce8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cec:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf1:	48 89 c6             	mov    %rax,%rsi
  802cf4:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf9:	48 b8 fe 45 80 00 00 	movabs $0x8045fe,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
}
  802d05:	c9                   	leaveq 
  802d06:	c3                   	retq   

0000000000802d07 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d07:	55                   	push   %rbp
  802d08:	48 89 e5             	mov    %rsp,%rbp
  802d0b:	48 83 ec 20          	sub    $0x20,%rsp
  802d0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d13:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1a:	48 89 c7             	mov    %rax,%rdi
  802d1d:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
  802d29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d2e:	7e 0a                	jle    802d3a <open+0x33>
		return -E_BAD_PATH;
  802d30:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d35:	e9 a5 00 00 00       	jmpq   802ddf <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802d3a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d3e:	48 89 c7             	mov    %rax,%rdi
  802d41:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
  802d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d54:	79 08                	jns    802d5e <open+0x57>
		return r;
  802d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d59:	e9 81 00 00 00       	jmpq   802ddf <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d62:	48 89 c6             	mov    %rax,%rsi
  802d65:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802d6c:	00 00 00 
  802d6f:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802d7b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d82:	00 00 00 
  802d85:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d88:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d92:	48 89 c6             	mov    %rax,%rsi
  802d95:	bf 01 00 00 00       	mov    $0x1,%edi
  802d9a:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dad:	79 1d                	jns    802dcc <open+0xc5>
		fd_close(fd, 0);
  802daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db3:	be 00 00 00 00       	mov    $0x0,%esi
  802db8:	48 89 c7             	mov    %rax,%rdi
  802dbb:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
		return r;
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	eb 13                	jmp    802ddf <open+0xd8>
	}

	return fd2num(fd);
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	48 89 c7             	mov    %rax,%rdi
  802dd3:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax

}
  802ddf:	c9                   	leaveq 
  802de0:	c3                   	retq   

0000000000802de1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802de1:	55                   	push   %rbp
  802de2:	48 89 e5             	mov    %rsp,%rbp
  802de5:	48 83 ec 10          	sub    $0x10,%rsp
  802de9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df1:	8b 50 0c             	mov    0xc(%rax),%edx
  802df4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802dfb:	00 00 00 
  802dfe:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e00:	be 00 00 00 00       	mov    $0x0,%esi
  802e05:	bf 06 00 00 00       	mov    $0x6,%edi
  802e0a:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 30          	sub    $0x30,%rsp
  802e20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e30:	8b 50 0c             	mov    0xc(%rax),%edx
  802e33:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e3a:	00 00 00 
  802e3d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e3f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e46:	00 00 00 
  802e49:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e51:	be 00 00 00 00       	mov    $0x0,%esi
  802e56:	bf 03 00 00 00       	mov    $0x3,%edi
  802e5b:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6e:	79 08                	jns    802e78 <devfile_read+0x60>
		return r;
  802e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e73:	e9 a4 00 00 00       	jmpq   802f1c <devfile_read+0x104>
	assert(r <= n);
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	48 98                	cltq   
  802e7d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e81:	76 35                	jbe    802eb8 <devfile_read+0xa0>
  802e83:	48 b9 16 4f 80 00 00 	movabs $0x804f16,%rcx
  802e8a:	00 00 00 
  802e8d:	48 ba 1d 4f 80 00 00 	movabs $0x804f1d,%rdx
  802e94:	00 00 00 
  802e97:	be 86 00 00 00       	mov    $0x86,%esi
  802e9c:	48 bf 32 4f 80 00 00 	movabs $0x804f32,%rdi
  802ea3:	00 00 00 
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eab:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  802eb2:	00 00 00 
  802eb5:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802eb8:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802ebf:	7e 35                	jle    802ef6 <devfile_read+0xde>
  802ec1:	48 b9 3d 4f 80 00 00 	movabs $0x804f3d,%rcx
  802ec8:	00 00 00 
  802ecb:	48 ba 1d 4f 80 00 00 	movabs $0x804f1d,%rdx
  802ed2:	00 00 00 
  802ed5:	be 87 00 00 00       	mov    $0x87,%esi
  802eda:	48 bf 32 4f 80 00 00 	movabs $0x804f32,%rdi
  802ee1:	00 00 00 
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee9:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  802ef0:	00 00 00 
  802ef3:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef9:	48 63 d0             	movslq %eax,%rdx
  802efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f00:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802f07:	00 00 00 
  802f0a:	48 89 c7             	mov    %rax,%rdi
  802f0d:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
	return r;
  802f19:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802f1c:	c9                   	leaveq 
  802f1d:	c3                   	retq   

0000000000802f1e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f1e:	55                   	push   %rbp
  802f1f:	48 89 e5             	mov    %rsp,%rbp
  802f22:	48 83 ec 40          	sub    $0x40,%rsp
  802f26:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f2a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f2e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802f32:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802f3a:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802f41:	00 
  802f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f46:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802f4a:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802f4f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f57:	8b 50 0c             	mov    0xc(%rax),%edx
  802f5a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f61:	00 00 00 
  802f64:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f66:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f6d:	00 00 00 
  802f70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f74:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802f78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f80:	48 89 c6             	mov    %rax,%rsi
  802f83:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802f8a:	00 00 00 
  802f8d:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802f99:	be 00 00 00 00       	mov    $0x0,%esi
  802f9e:	bf 04 00 00 00       	mov    $0x4,%edi
  802fa3:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  802faa:	00 00 00 
  802fad:	ff d0                	callq  *%rax
  802faf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fb2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fb6:	79 05                	jns    802fbd <devfile_write+0x9f>
		return r;
  802fb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fbb:	eb 43                	jmp    803000 <devfile_write+0xe2>
	assert(r <= n);
  802fbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc0:	48 98                	cltq   
  802fc2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802fc6:	76 35                	jbe    802ffd <devfile_write+0xdf>
  802fc8:	48 b9 16 4f 80 00 00 	movabs $0x804f16,%rcx
  802fcf:	00 00 00 
  802fd2:	48 ba 1d 4f 80 00 00 	movabs $0x804f1d,%rdx
  802fd9:	00 00 00 
  802fdc:	be a2 00 00 00       	mov    $0xa2,%esi
  802fe1:	48 bf 32 4f 80 00 00 	movabs $0x804f32,%rdi
  802fe8:	00 00 00 
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff0:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  802ff7:	00 00 00 
  802ffa:	41 ff d0             	callq  *%r8
	return r;
  802ffd:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803000:	c9                   	leaveq 
  803001:	c3                   	retq   

0000000000803002 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803002:	55                   	push   %rbp
  803003:	48 89 e5             	mov    %rsp,%rbp
  803006:	48 83 ec 20          	sub    $0x20,%rsp
  80300a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80300e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803016:	8b 50 0c             	mov    0xc(%rax),%edx
  803019:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803020:	00 00 00 
  803023:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803025:	be 00 00 00 00       	mov    $0x0,%esi
  80302a:	bf 05 00 00 00       	mov    $0x5,%edi
  80302f:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
  80303b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803042:	79 05                	jns    803049 <devfile_stat+0x47>
		return r;
  803044:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803047:	eb 56                	jmp    80309f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803049:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80304d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803054:	00 00 00 
  803057:	48 89 c7             	mov    %rax,%rdi
  80305a:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803066:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80306d:	00 00 00 
  803070:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803076:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80307a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803080:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803087:	00 00 00 
  80308a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803090:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803094:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80309a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309f:	c9                   	leaveq 
  8030a0:	c3                   	retq   

00000000008030a1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030a1:	55                   	push   %rbp
  8030a2:	48 89 e5             	mov    %rsp,%rbp
  8030a5:	48 83 ec 10          	sub    $0x10,%rsp
  8030a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030ad:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030be:	00 00 00 
  8030c1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030c3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030ca:	00 00 00 
  8030cd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030d3:	be 00 00 00 00       	mov    $0x0,%esi
  8030d8:	bf 02 00 00 00       	mov    $0x2,%edi
  8030dd:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
}
  8030e9:	c9                   	leaveq 
  8030ea:	c3                   	retq   

00000000008030eb <remove>:

// Delete a file
int
remove(const char *path)
{
  8030eb:	55                   	push   %rbp
  8030ec:	48 89 e5             	mov    %rsp,%rbp
  8030ef:	48 83 ec 10          	sub    $0x10,%rsp
  8030f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fb:	48 89 c7             	mov    %rax,%rdi
  8030fe:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80310f:	7e 07                	jle    803118 <remove+0x2d>
		return -E_BAD_PATH;
  803111:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803116:	eb 33                	jmp    80314b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80311c:	48 89 c6             	mov    %rax,%rsi
  80311f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803126:	00 00 00 
  803129:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  803130:	00 00 00 
  803133:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803135:	be 00 00 00 00       	mov    $0x0,%esi
  80313a:	bf 07 00 00 00       	mov    $0x7,%edi
  80313f:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803151:	be 00 00 00 00       	mov    $0x0,%esi
  803156:	bf 08 00 00 00       	mov    $0x8,%edi
  80315b:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
}
  803167:	5d                   	pop    %rbp
  803168:	c3                   	retq   

0000000000803169 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803174:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80317b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803182:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803189:	be 00 00 00 00       	mov    $0x0,%esi
  80318e:	48 89 c7             	mov    %rax,%rdi
  803191:	48 b8 07 2d 80 00 00 	movabs $0x802d07,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
  80319d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8031a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a4:	79 28                	jns    8031ce <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8031a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a9:	89 c6                	mov    %eax,%esi
  8031ab:	48 bf 49 4f 80 00 00 	movabs $0x804f49,%rdi
  8031b2:	00 00 00 
  8031b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ba:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  8031c1:	00 00 00 
  8031c4:	ff d2                	callq  *%rdx
		return fd_src;
  8031c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c9:	e9 76 01 00 00       	jmpq   803344 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8031ce:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8031d5:	be 01 01 00 00       	mov    $0x101,%esi
  8031da:	48 89 c7             	mov    %rax,%rdi
  8031dd:	48 b8 07 2d 80 00 00 	movabs $0x802d07,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
  8031e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031f0:	0f 89 ad 00 00 00    	jns    8032a3 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8031f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031f9:	89 c6                	mov    %eax,%esi
  8031fb:	48 bf 5f 4f 80 00 00 	movabs $0x804f5f,%rdi
  803202:	00 00 00 
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  803211:	00 00 00 
  803214:	ff d2                	callq  *%rdx
		close(fd_src);
  803216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803219:	89 c7                	mov    %eax,%edi
  80321b:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
		return fd_dest;
  803227:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80322a:	e9 15 01 00 00       	jmpq   803344 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80322f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803232:	48 63 d0             	movslq %eax,%rdx
  803235:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80323c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80323f:	48 89 ce             	mov    %rcx,%rsi
  803242:	89 c7                	mov    %eax,%edi
  803244:	48 b8 79 29 80 00 00 	movabs $0x802979,%rax
  80324b:	00 00 00 
  80324e:	ff d0                	callq  *%rax
  803250:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803253:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803257:	79 4a                	jns    8032a3 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803259:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80325c:	89 c6                	mov    %eax,%esi
  80325e:	48 bf 79 4f 80 00 00 	movabs $0x804f79,%rdi
  803265:	00 00 00 
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  803274:	00 00 00 
  803277:	ff d2                	callq  *%rdx
			close(fd_src);
  803279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327c:	89 c7                	mov    %eax,%edi
  80327e:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803285:	00 00 00 
  803288:	ff d0                	callq  *%rax
			close(fd_dest);
  80328a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80328d:	89 c7                	mov    %eax,%edi
  80328f:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
			return write_size;
  80329b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80329e:	e9 a1 00 00 00       	jmpq   803344 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032a3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ad:	ba 00 02 00 00       	mov    $0x200,%edx
  8032b2:	48 89 ce             	mov    %rcx,%rsi
  8032b5:	89 c7                	mov    %eax,%edi
  8032b7:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032ca:	0f 8f 5f ff ff ff    	jg     80322f <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8032d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032d4:	79 47                	jns    80331d <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8032d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032d9:	89 c6                	mov    %eax,%esi
  8032db:	48 bf 8c 4f 80 00 00 	movabs $0x804f8c,%rdi
  8032e2:	00 00 00 
  8032e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ea:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  8032f1:	00 00 00 
  8032f4:	ff d2                	callq  *%rdx
		close(fd_src);
  8032f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f9:	89 c7                	mov    %eax,%edi
  8032fb:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
		close(fd_dest);
  803307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80330a:	89 c7                	mov    %eax,%edi
  80330c:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
		return read_size;
  803318:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80331b:	eb 27                	jmp    803344 <copy+0x1db>
	}
	close(fd_src);
  80331d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803320:	89 c7                	mov    %eax,%edi
  803322:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  803329:	00 00 00 
  80332c:	ff d0                	callq  *%rax
	close(fd_dest);
  80332e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803331:	89 c7                	mov    %eax,%edi
  803333:	48 b8 0b 26 80 00 00 	movabs $0x80260b,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
	return 0;
  80333f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803344:	c9                   	leaveq 
  803345:	c3                   	retq   

0000000000803346 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803346:	55                   	push   %rbp
  803347:	48 89 e5             	mov    %rsp,%rbp
  80334a:	48 83 ec 20          	sub    $0x20,%rsp
  80334e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803351:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803355:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803358:	48 89 d6             	mov    %rdx,%rsi
  80335b:	89 c7                	mov    %eax,%edi
  80335d:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
  803369:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803370:	79 05                	jns    803377 <fd2sockid+0x31>
		return r;
  803372:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803375:	eb 24                	jmp    80339b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	8b 10                	mov    (%rax),%edx
  80337d:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803384:	00 00 00 
  803387:	8b 00                	mov    (%rax),%eax
  803389:	39 c2                	cmp    %eax,%edx
  80338b:	74 07                	je     803394 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80338d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803392:	eb 07                	jmp    80339b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803398:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 20          	sub    $0x20,%rsp
  8033a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8033a8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033ac:	48 89 c7             	mov    %rax,%rdi
  8033af:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c2:	78 26                	js     8033ea <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8033c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c8:	ba 07 04 00 00       	mov    $0x407,%edx
  8033cd:	48 89 c6             	mov    %rax,%rsi
  8033d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d5:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  8033dc:	00 00 00 
  8033df:	ff d0                	callq  *%rax
  8033e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e8:	79 16                	jns    803400 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8033ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ed:	89 c7                	mov    %eax,%edi
  8033ef:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
		return r;
  8033fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fe:	eb 3a                	jmp    80343a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803404:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80340b:	00 00 00 
  80340e:	8b 12                	mov    (%rdx),%edx
  803410:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803416:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80341d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803421:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803424:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803427:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342b:	48 89 c7             	mov    %rax,%rdi
  80342e:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  803435:	00 00 00 
  803438:	ff d0                	callq  *%rax
}
  80343a:	c9                   	leaveq 
  80343b:	c3                   	retq   

000000000080343c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80343c:	55                   	push   %rbp
  80343d:	48 89 e5             	mov    %rsp,%rbp
  803440:	48 83 ec 30          	sub    $0x30,%rsp
  803444:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803447:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80344b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80344f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803452:	89 c7                	mov    %eax,%edi
  803454:	48 b8 46 33 80 00 00 	movabs $0x803346,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
  803460:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803463:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803467:	79 05                	jns    80346e <accept+0x32>
		return r;
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346c:	eb 3b                	jmp    8034a9 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80346e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803472:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803479:	48 89 ce             	mov    %rcx,%rsi
  80347c:	89 c7                	mov    %eax,%edi
  80347e:	48 b8 89 37 80 00 00 	movabs $0x803789,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
  80348a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80348d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803491:	79 05                	jns    803498 <accept+0x5c>
		return r;
  803493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803496:	eb 11                	jmp    8034a9 <accept+0x6d>
	return alloc_sockfd(r);
  803498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349b:	89 c7                	mov    %eax,%edi
  80349d:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax
}
  8034a9:	c9                   	leaveq 
  8034aa:	c3                   	retq   

00000000008034ab <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034ab:	55                   	push   %rbp
  8034ac:	48 89 e5             	mov    %rsp,%rbp
  8034af:	48 83 ec 20          	sub    $0x20,%rsp
  8034b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034ba:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c0:	89 c7                	mov    %eax,%edi
  8034c2:	48 b8 46 33 80 00 00 	movabs $0x803346,%rax
  8034c9:	00 00 00 
  8034cc:	ff d0                	callq  *%rax
  8034ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d5:	79 05                	jns    8034dc <bind+0x31>
		return r;
  8034d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034da:	eb 1b                	jmp    8034f7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034dc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034df:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e6:	48 89 ce             	mov    %rcx,%rsi
  8034e9:	89 c7                	mov    %eax,%edi
  8034eb:	48 b8 08 38 80 00 00 	movabs $0x803808,%rax
  8034f2:	00 00 00 
  8034f5:	ff d0                	callq  *%rax
}
  8034f7:	c9                   	leaveq 
  8034f8:	c3                   	retq   

00000000008034f9 <shutdown>:

int
shutdown(int s, int how)
{
  8034f9:	55                   	push   %rbp
  8034fa:	48 89 e5             	mov    %rsp,%rbp
  8034fd:	48 83 ec 20          	sub    $0x20,%rsp
  803501:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803504:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803507:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80350a:	89 c7                	mov    %eax,%edi
  80350c:	48 b8 46 33 80 00 00 	movabs $0x803346,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
  803518:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80351b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351f:	79 05                	jns    803526 <shutdown+0x2d>
		return r;
  803521:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803524:	eb 16                	jmp    80353c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803526:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352c:	89 d6                	mov    %edx,%esi
  80352e:	89 c7                	mov    %eax,%edi
  803530:	48 b8 6c 38 80 00 00 	movabs $0x80386c,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
}
  80353c:	c9                   	leaveq 
  80353d:	c3                   	retq   

000000000080353e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80353e:	55                   	push   %rbp
  80353f:	48 89 e5             	mov    %rsp,%rbp
  803542:	48 83 ec 10          	sub    $0x10,%rsp
  803546:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80354a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354e:	48 89 c7             	mov    %rax,%rdi
  803551:	48 b8 c5 47 80 00 00 	movabs $0x8047c5,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
  80355d:	83 f8 01             	cmp    $0x1,%eax
  803560:	75 17                	jne    803579 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803566:	8b 40 0c             	mov    0xc(%rax),%eax
  803569:	89 c7                	mov    %eax,%edi
  80356b:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
  803577:	eb 05                	jmp    80357e <devsock_close+0x40>
	else
		return 0;
  803579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357e:	c9                   	leaveq 
  80357f:	c3                   	retq   

0000000000803580 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803580:	55                   	push   %rbp
  803581:	48 89 e5             	mov    %rsp,%rbp
  803584:	48 83 ec 20          	sub    $0x20,%rsp
  803588:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80358b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80358f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803592:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803595:	89 c7                	mov    %eax,%edi
  803597:	48 b8 46 33 80 00 00 	movabs $0x803346,%rax
  80359e:	00 00 00 
  8035a1:	ff d0                	callq  *%rax
  8035a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035aa:	79 05                	jns    8035b1 <connect+0x31>
		return r;
  8035ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035af:	eb 1b                	jmp    8035cc <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8035b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035b4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bb:	48 89 ce             	mov    %rcx,%rsi
  8035be:	89 c7                	mov    %eax,%edi
  8035c0:	48 b8 d9 38 80 00 00 	movabs $0x8038d9,%rax
  8035c7:	00 00 00 
  8035ca:	ff d0                	callq  *%rax
}
  8035cc:	c9                   	leaveq 
  8035cd:	c3                   	retq   

00000000008035ce <listen>:

int
listen(int s, int backlog)
{
  8035ce:	55                   	push   %rbp
  8035cf:	48 89 e5             	mov    %rsp,%rbp
  8035d2:	48 83 ec 20          	sub    $0x20,%rsp
  8035d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035d9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035df:	89 c7                	mov    %eax,%edi
  8035e1:	48 b8 46 33 80 00 00 	movabs $0x803346,%rax
  8035e8:	00 00 00 
  8035eb:	ff d0                	callq  *%rax
  8035ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f4:	79 05                	jns    8035fb <listen+0x2d>
		return r;
  8035f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f9:	eb 16                	jmp    803611 <listen+0x43>
	return nsipc_listen(r, backlog);
  8035fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803601:	89 d6                	mov    %edx,%esi
  803603:	89 c7                	mov    %eax,%edi
  803605:	48 b8 3d 39 80 00 00 	movabs $0x80393d,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
}
  803611:	c9                   	leaveq 
  803612:	c3                   	retq   

0000000000803613 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803613:	55                   	push   %rbp
  803614:	48 89 e5             	mov    %rsp,%rbp
  803617:	48 83 ec 20          	sub    $0x20,%rsp
  80361b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80361f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803623:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362b:	89 c2                	mov    %eax,%edx
  80362d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803631:	8b 40 0c             	mov    0xc(%rax),%eax
  803634:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80363d:	89 c7                	mov    %eax,%edi
  80363f:	48 b8 7d 39 80 00 00 	movabs $0x80397d,%rax
  803646:	00 00 00 
  803649:	ff d0                	callq  *%rax
}
  80364b:	c9                   	leaveq 
  80364c:	c3                   	retq   

000000000080364d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80364d:	55                   	push   %rbp
  80364e:	48 89 e5             	mov    %rsp,%rbp
  803651:	48 83 ec 20          	sub    $0x20,%rsp
  803655:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803659:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80365d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803665:	89 c2                	mov    %eax,%edx
  803667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80366b:	8b 40 0c             	mov    0xc(%rax),%eax
  80366e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803672:	b9 00 00 00 00       	mov    $0x0,%ecx
  803677:	89 c7                	mov    %eax,%edi
  803679:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  803680:	00 00 00 
  803683:	ff d0                	callq  *%rax
}
  803685:	c9                   	leaveq 
  803686:	c3                   	retq   

0000000000803687 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803687:	55                   	push   %rbp
  803688:	48 89 e5             	mov    %rsp,%rbp
  80368b:	48 83 ec 10          	sub    $0x10,%rsp
  80368f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803693:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369b:	48 be a7 4f 80 00 00 	movabs $0x804fa7,%rsi
  8036a2:	00 00 00 
  8036a5:	48 89 c7             	mov    %rax,%rdi
  8036a8:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
	return 0;
  8036b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036b9:	c9                   	leaveq 
  8036ba:	c3                   	retq   

00000000008036bb <socket>:

int
socket(int domain, int type, int protocol)
{
  8036bb:	55                   	push   %rbp
  8036bc:	48 89 e5             	mov    %rsp,%rbp
  8036bf:	48 83 ec 20          	sub    $0x20,%rsp
  8036c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036c6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036c9:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8036cc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8036cf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d5:	89 ce                	mov    %ecx,%esi
  8036d7:	89 c7                	mov    %eax,%edi
  8036d9:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
  8036e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ec:	79 05                	jns    8036f3 <socket+0x38>
		return r;
  8036ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f1:	eb 11                	jmp    803704 <socket+0x49>
	return alloc_sockfd(r);
  8036f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f6:	89 c7                	mov    %eax,%edi
  8036f8:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
}
  803704:	c9                   	leaveq 
  803705:	c3                   	retq   

0000000000803706 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803706:	55                   	push   %rbp
  803707:	48 89 e5             	mov    %rsp,%rbp
  80370a:	48 83 ec 10          	sub    $0x10,%rsp
  80370e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803711:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803718:	00 00 00 
  80371b:	8b 00                	mov    (%rax),%eax
  80371d:	85 c0                	test   %eax,%eax
  80371f:	75 1f                	jne    803740 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803721:	bf 02 00 00 00       	mov    $0x2,%edi
  803726:	48 b8 54 47 80 00 00 	movabs $0x804754,%rax
  80372d:	00 00 00 
  803730:	ff d0                	callq  *%rax
  803732:	89 c2                	mov    %eax,%edx
  803734:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80373b:	00 00 00 
  80373e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803740:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803747:	00 00 00 
  80374a:	8b 00                	mov    (%rax),%eax
  80374c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80374f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803754:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80375b:	00 00 00 
  80375e:	89 c7                	mov    %eax,%edi
  803760:	48 b8 bf 46 80 00 00 	movabs $0x8046bf,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80376c:	ba 00 00 00 00       	mov    $0x0,%edx
  803771:	be 00 00 00 00       	mov    $0x0,%esi
  803776:	bf 00 00 00 00       	mov    $0x0,%edi
  80377b:	48 b8 fe 45 80 00 00 	movabs $0x8045fe,%rax
  803782:	00 00 00 
  803785:	ff d0                	callq  *%rax
}
  803787:	c9                   	leaveq 
  803788:	c3                   	retq   

0000000000803789 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803789:	55                   	push   %rbp
  80378a:	48 89 e5             	mov    %rsp,%rbp
  80378d:	48 83 ec 30          	sub    $0x30,%rsp
  803791:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803794:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803798:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80379c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037a3:	00 00 00 
  8037a6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037a9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8037b0:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  8037b7:	00 00 00 
  8037ba:	ff d0                	callq  *%rax
  8037bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c3:	78 3e                	js     803803 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8037c5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037cc:	00 00 00 
  8037cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d7:	8b 40 10             	mov    0x10(%rax),%eax
  8037da:	89 c2                	mov    %eax,%edx
  8037dc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8037e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e4:	48 89 ce             	mov    %rcx,%rsi
  8037e7:	48 89 c7             	mov    %rax,%rdi
  8037ea:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8037f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fa:	8b 50 10             	mov    0x10(%rax),%edx
  8037fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803801:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803803:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803806:	c9                   	leaveq 
  803807:	c3                   	retq   

0000000000803808 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803808:	55                   	push   %rbp
  803809:	48 89 e5             	mov    %rsp,%rbp
  80380c:	48 83 ec 10          	sub    $0x10,%rsp
  803810:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803813:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803817:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80381a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803821:	00 00 00 
  803824:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803827:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803829:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80382c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803830:	48 89 c6             	mov    %rax,%rsi
  803833:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80383a:	00 00 00 
  80383d:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803849:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803850:	00 00 00 
  803853:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803856:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803859:	bf 02 00 00 00       	mov    $0x2,%edi
  80385e:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
}
  80386a:	c9                   	leaveq 
  80386b:	c3                   	retq   

000000000080386c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80386c:	55                   	push   %rbp
  80386d:	48 89 e5             	mov    %rsp,%rbp
  803870:	48 83 ec 10          	sub    $0x10,%rsp
  803874:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803877:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80387a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803881:	00 00 00 
  803884:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803887:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803889:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803890:	00 00 00 
  803893:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803896:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803899:	bf 03 00 00 00       	mov    $0x3,%edi
  80389e:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  8038a5:	00 00 00 
  8038a8:	ff d0                	callq  *%rax
}
  8038aa:	c9                   	leaveq 
  8038ab:	c3                   	retq   

00000000008038ac <nsipc_close>:

int
nsipc_close(int s)
{
  8038ac:	55                   	push   %rbp
  8038ad:	48 89 e5             	mov    %rsp,%rbp
  8038b0:	48 83 ec 10          	sub    $0x10,%rsp
  8038b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8038b7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038be:	00 00 00 
  8038c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038c4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8038c6:	bf 04 00 00 00       	mov    $0x4,%edi
  8038cb:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  8038d2:	00 00 00 
  8038d5:	ff d0                	callq  *%rax
}
  8038d7:	c9                   	leaveq 
  8038d8:	c3                   	retq   

00000000008038d9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038d9:	55                   	push   %rbp
  8038da:	48 89 e5             	mov    %rsp,%rbp
  8038dd:	48 83 ec 10          	sub    $0x10,%rsp
  8038e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8038eb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038f2:	00 00 00 
  8038f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8038fa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803901:	48 89 c6             	mov    %rax,%rsi
  803904:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80390b:	00 00 00 
  80390e:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  803915:	00 00 00 
  803918:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80391a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803921:	00 00 00 
  803924:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803927:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80392a:	bf 05 00 00 00       	mov    $0x5,%edi
  80392f:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  803936:	00 00 00 
  803939:	ff d0                	callq  *%rax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 83 ec 10          	sub    $0x10,%rsp
  803945:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803948:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80394b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803952:	00 00 00 
  803955:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803958:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80395a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803961:	00 00 00 
  803964:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803967:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80396a:	bf 06 00 00 00       	mov    $0x6,%edi
  80396f:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
}
  80397b:	c9                   	leaveq 
  80397c:	c3                   	retq   

000000000080397d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80397d:	55                   	push   %rbp
  80397e:	48 89 e5             	mov    %rsp,%rbp
  803981:	48 83 ec 30          	sub    $0x30,%rsp
  803985:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803988:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80398c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80398f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803992:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803999:	00 00 00 
  80399c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80399f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8039a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a8:	00 00 00 
  8039ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039ae:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8039b1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039b8:	00 00 00 
  8039bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039be:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039c1:	bf 07 00 00 00       	mov    $0x7,%edi
  8039c6:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
  8039d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d9:	78 69                	js     803a44 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8039db:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8039e2:	7f 08                	jg     8039ec <nsipc_recv+0x6f>
  8039e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8039ea:	7e 35                	jle    803a21 <nsipc_recv+0xa4>
  8039ec:	48 b9 ae 4f 80 00 00 	movabs $0x804fae,%rcx
  8039f3:	00 00 00 
  8039f6:	48 ba c3 4f 80 00 00 	movabs $0x804fc3,%rdx
  8039fd:	00 00 00 
  803a00:	be 62 00 00 00       	mov    $0x62,%esi
  803a05:	48 bf d8 4f 80 00 00 	movabs $0x804fd8,%rdi
  803a0c:	00 00 00 
  803a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a14:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  803a1b:	00 00 00 
  803a1e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a24:	48 63 d0             	movslq %eax,%rdx
  803a27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a2b:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803a32:	00 00 00 
  803a35:	48 89 c7             	mov    %rax,%rdi
  803a38:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  803a3f:	00 00 00 
  803a42:	ff d0                	callq  *%rax
	}

	return r;
  803a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a47:	c9                   	leaveq 
  803a48:	c3                   	retq   

0000000000803a49 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a49:	55                   	push   %rbp
  803a4a:	48 89 e5             	mov    %rsp,%rbp
  803a4d:	48 83 ec 20          	sub    $0x20,%rsp
  803a51:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a58:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a5b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a65:	00 00 00 
  803a68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a6b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a6d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a74:	7e 35                	jle    803aab <nsipc_send+0x62>
  803a76:	48 b9 e4 4f 80 00 00 	movabs $0x804fe4,%rcx
  803a7d:	00 00 00 
  803a80:	48 ba c3 4f 80 00 00 	movabs $0x804fc3,%rdx
  803a87:	00 00 00 
  803a8a:	be 6d 00 00 00       	mov    $0x6d,%esi
  803a8f:	48 bf d8 4f 80 00 00 	movabs $0x804fd8,%rdi
  803a96:	00 00 00 
  803a99:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9e:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  803aa5:	00 00 00 
  803aa8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803aab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aae:	48 63 d0             	movslq %eax,%rdx
  803ab1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab5:	48 89 c6             	mov    %rax,%rsi
  803ab8:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803abf:	00 00 00 
  803ac2:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ace:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad5:	00 00 00 
  803ad8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803adb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803ade:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae5:	00 00 00 
  803ae8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803aeb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803aee:	bf 08 00 00 00       	mov    $0x8,%edi
  803af3:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
}
  803aff:	c9                   	leaveq 
  803b00:	c3                   	retq   

0000000000803b01 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b01:	55                   	push   %rbp
  803b02:	48 89 e5             	mov    %rsp,%rbp
  803b05:	48 83 ec 10          	sub    $0x10,%rsp
  803b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b0f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b12:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b19:	00 00 00 
  803b1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b1f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803b21:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b28:	00 00 00 
  803b2b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b2e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803b31:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b38:	00 00 00 
  803b3b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b3e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b41:	bf 09 00 00 00       	mov    $0x9,%edi
  803b46:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  803b4d:	00 00 00 
  803b50:	ff d0                	callq  *%rax
}
  803b52:	c9                   	leaveq 
  803b53:	c3                   	retq   

0000000000803b54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b54:	55                   	push   %rbp
  803b55:	48 89 e5             	mov    %rsp,%rbp
  803b58:	53                   	push   %rbx
  803b59:	48 83 ec 38          	sub    $0x38,%rsp
  803b5d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b61:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b65:	48 89 c7             	mov    %rax,%rdi
  803b68:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
  803b74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b7b:	0f 88 bf 01 00 00    	js     803d40 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b85:	ba 07 04 00 00       	mov    $0x407,%edx
  803b8a:	48 89 c6             	mov    %rax,%rsi
  803b8d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b92:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
  803b9e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ba1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ba5:	0f 88 95 01 00 00    	js     803d40 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803bab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803baf:	48 89 c7             	mov    %rax,%rdi
  803bb2:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
  803bbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bc5:	0f 88 5d 01 00 00    	js     803d28 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bcf:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd4:	48 89 c6             	mov    %rax,%rsi
  803bd7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdc:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803be3:	00 00 00 
  803be6:	ff d0                	callq  *%rax
  803be8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803beb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bef:	0f 88 33 01 00 00    	js     803d28 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803bf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bf9:	48 89 c7             	mov    %rax,%rdi
  803bfc:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
  803c08:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c10:	ba 07 04 00 00       	mov    $0x407,%edx
  803c15:	48 89 c6             	mov    %rax,%rsi
  803c18:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1d:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803c24:	00 00 00 
  803c27:	ff d0                	callq  *%rax
  803c29:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c30:	0f 88 d9 00 00 00    	js     803d0f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c3a:	48 89 c7             	mov    %rax,%rdi
  803c3d:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803c44:	00 00 00 
  803c47:	ff d0                	callq  *%rax
  803c49:	48 89 c2             	mov    %rax,%rdx
  803c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c50:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c56:	48 89 d1             	mov    %rdx,%rcx
  803c59:	ba 00 00 00 00       	mov    $0x0,%edx
  803c5e:	48 89 c6             	mov    %rax,%rsi
  803c61:	bf 00 00 00 00       	mov    $0x0,%edi
  803c66:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  803c6d:	00 00 00 
  803c70:	ff d0                	callq  *%rax
  803c72:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c75:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c79:	78 79                	js     803cf4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c7f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803c86:	00 00 00 
  803c89:	8b 12                	mov    (%rdx),%edx
  803c8b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c9c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803ca3:	00 00 00 
  803ca6:	8b 12                	mov    (%rdx),%edx
  803ca8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803caa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803cb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb9:	48 89 c7             	mov    %rax,%rdi
  803cbc:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  803cc3:	00 00 00 
  803cc6:	ff d0                	callq  *%rax
  803cc8:	89 c2                	mov    %eax,%edx
  803cca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cce:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803cd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cd4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803cd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cdc:	48 89 c7             	mov    %rax,%rdi
  803cdf:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
  803ceb:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ced:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf2:	eb 4f                	jmp    803d43 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803cf4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803cf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf9:	48 89 c6             	mov    %rax,%rsi
  803cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  803d01:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
  803d0d:	eb 01                	jmp    803d10 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803d0f:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d14:	48 89 c6             	mov    %rax,%rsi
  803d17:	bf 00 00 00 00       	mov    $0x0,%edi
  803d1c:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803d28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d2c:	48 89 c6             	mov    %rax,%rsi
  803d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d34:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
err:
	return r;
  803d40:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d43:	48 83 c4 38          	add    $0x38,%rsp
  803d47:	5b                   	pop    %rbx
  803d48:	5d                   	pop    %rbp
  803d49:	c3                   	retq   

0000000000803d4a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d4a:	55                   	push   %rbp
  803d4b:	48 89 e5             	mov    %rsp,%rbp
  803d4e:	53                   	push   %rbx
  803d4f:	48 83 ec 28          	sub    $0x28,%rsp
  803d53:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d57:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d5b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d62:	00 00 00 
  803d65:	48 8b 00             	mov    (%rax),%rax
  803d68:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d6e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 c5 47 80 00 00 	movabs $0x8047c5,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	89 c3                	mov    %eax,%ebx
  803d86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d8a:	48 89 c7             	mov    %rax,%rdi
  803d8d:	48 b8 c5 47 80 00 00 	movabs $0x8047c5,%rax
  803d94:	00 00 00 
  803d97:	ff d0                	callq  *%rax
  803d99:	39 c3                	cmp    %eax,%ebx
  803d9b:	0f 94 c0             	sete   %al
  803d9e:	0f b6 c0             	movzbl %al,%eax
  803da1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803da4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803dab:	00 00 00 
  803dae:	48 8b 00             	mov    (%rax),%rax
  803db1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803db7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803dba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dbd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dc0:	75 05                	jne    803dc7 <_pipeisclosed+0x7d>
			return ret;
  803dc2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dc5:	eb 4a                	jmp    803e11 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803dc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dca:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dcd:	74 8c                	je     803d5b <_pipeisclosed+0x11>
  803dcf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803dd3:	75 86                	jne    803d5b <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803dd5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ddc:	00 00 00 
  803ddf:	48 8b 00             	mov    (%rax),%rax
  803de2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803de8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803deb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dee:	89 c6                	mov    %eax,%esi
  803df0:	48 bf f5 4f 80 00 00 	movabs $0x804ff5,%rdi
  803df7:	00 00 00 
  803dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  803dff:	49 b8 3d 03 80 00 00 	movabs $0x80033d,%r8
  803e06:	00 00 00 
  803e09:	41 ff d0             	callq  *%r8
	}
  803e0c:	e9 4a ff ff ff       	jmpq   803d5b <_pipeisclosed+0x11>

}
  803e11:	48 83 c4 28          	add    $0x28,%rsp
  803e15:	5b                   	pop    %rbx
  803e16:	5d                   	pop    %rbp
  803e17:	c3                   	retq   

0000000000803e18 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803e18:	55                   	push   %rbp
  803e19:	48 89 e5             	mov    %rsp,%rbp
  803e1c:	48 83 ec 30          	sub    $0x30,%rsp
  803e20:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e23:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e2a:	48 89 d6             	mov    %rdx,%rsi
  803e2d:	89 c7                	mov    %eax,%edi
  803e2f:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803e36:	00 00 00 
  803e39:	ff d0                	callq  *%rax
  803e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e42:	79 05                	jns    803e49 <pipeisclosed+0x31>
		return r;
  803e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e47:	eb 31                	jmp    803e7a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4d:	48 89 c7             	mov    %rax,%rdi
  803e50:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803e57:	00 00 00 
  803e5a:	ff d0                	callq  *%rax
  803e5c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e68:	48 89 d6             	mov    %rdx,%rsi
  803e6b:	48 89 c7             	mov    %rax,%rdi
  803e6e:	48 b8 4a 3d 80 00 00 	movabs $0x803d4a,%rax
  803e75:	00 00 00 
  803e78:	ff d0                	callq  *%rax
}
  803e7a:	c9                   	leaveq 
  803e7b:	c3                   	retq   

0000000000803e7c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e7c:	55                   	push   %rbp
  803e7d:	48 89 e5             	mov    %rsp,%rbp
  803e80:	48 83 ec 40          	sub    $0x40,%rsp
  803e84:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e88:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e8c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e94:	48 89 c7             	mov    %rax,%rdi
  803e97:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803e9e:	00 00 00 
  803ea1:	ff d0                	callq  *%rax
  803ea3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ea7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803eaf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803eb6:	00 
  803eb7:	e9 90 00 00 00       	jmpq   803f4c <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ebc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ec1:	74 09                	je     803ecc <devpipe_read+0x50>
				return i;
  803ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec7:	e9 8e 00 00 00       	jmpq   803f5a <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ecc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ed0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed4:	48 89 d6             	mov    %rdx,%rsi
  803ed7:	48 89 c7             	mov    %rax,%rdi
  803eda:	48 b8 4a 3d 80 00 00 	movabs $0x803d4a,%rax
  803ee1:	00 00 00 
  803ee4:	ff d0                	callq  *%rax
  803ee6:	85 c0                	test   %eax,%eax
  803ee8:	74 07                	je     803ef1 <devpipe_read+0x75>
				return 0;
  803eea:	b8 00 00 00 00       	mov    $0x0,%eax
  803eef:	eb 69                	jmp    803f5a <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803ef1:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  803ef8:	00 00 00 
  803efb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f01:	8b 10                	mov    (%rax),%edx
  803f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f07:	8b 40 04             	mov    0x4(%rax),%eax
  803f0a:	39 c2                	cmp    %eax,%edx
  803f0c:	74 ae                	je     803ebc <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f16:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1e:	8b 00                	mov    (%rax),%eax
  803f20:	99                   	cltd   
  803f21:	c1 ea 1b             	shr    $0x1b,%edx
  803f24:	01 d0                	add    %edx,%eax
  803f26:	83 e0 1f             	and    $0x1f,%eax
  803f29:	29 d0                	sub    %edx,%eax
  803f2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f2f:	48 98                	cltq   
  803f31:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f36:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f3c:	8b 00                	mov    (%rax),%eax
  803f3e:	8d 50 01             	lea    0x1(%rax),%edx
  803f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f45:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f47:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f50:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f54:	72 a7                	jb     803efd <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803f5a:	c9                   	leaveq 
  803f5b:	c3                   	retq   

0000000000803f5c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f5c:	55                   	push   %rbp
  803f5d:	48 89 e5             	mov    %rsp,%rbp
  803f60:	48 83 ec 40          	sub    $0x40,%rsp
  803f64:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f68:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f6c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f74:	48 89 c7             	mov    %rax,%rdi
  803f77:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803f7e:	00 00 00 
  803f81:	ff d0                	callq  *%rax
  803f83:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f8f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f96:	00 
  803f97:	e9 8f 00 00 00       	jmpq   80402b <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa4:	48 89 d6             	mov    %rdx,%rsi
  803fa7:	48 89 c7             	mov    %rax,%rdi
  803faa:	48 b8 4a 3d 80 00 00 	movabs $0x803d4a,%rax
  803fb1:	00 00 00 
  803fb4:	ff d0                	callq  *%rax
  803fb6:	85 c0                	test   %eax,%eax
  803fb8:	74 07                	je     803fc1 <devpipe_write+0x65>
				return 0;
  803fba:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbf:	eb 78                	jmp    804039 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803fc1:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  803fc8:	00 00 00 
  803fcb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd1:	8b 40 04             	mov    0x4(%rax),%eax
  803fd4:	48 63 d0             	movslq %eax,%rdx
  803fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fdb:	8b 00                	mov    (%rax),%eax
  803fdd:	48 98                	cltq   
  803fdf:	48 83 c0 20          	add    $0x20,%rax
  803fe3:	48 39 c2             	cmp    %rax,%rdx
  803fe6:	73 b4                	jae    803f9c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fec:	8b 40 04             	mov    0x4(%rax),%eax
  803fef:	99                   	cltd   
  803ff0:	c1 ea 1b             	shr    $0x1b,%edx
  803ff3:	01 d0                	add    %edx,%eax
  803ff5:	83 e0 1f             	and    $0x1f,%eax
  803ff8:	29 d0                	sub    %edx,%eax
  803ffa:	89 c6                	mov    %eax,%esi
  803ffc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804004:	48 01 d0             	add    %rdx,%rax
  804007:	0f b6 08             	movzbl (%rax),%ecx
  80400a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80400e:	48 63 c6             	movslq %esi,%rax
  804011:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804019:	8b 40 04             	mov    0x4(%rax),%eax
  80401c:	8d 50 01             	lea    0x1(%rax),%edx
  80401f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804023:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804026:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80402b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804033:	72 98                	jb     803fcd <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804039:	c9                   	leaveq 
  80403a:	c3                   	retq   

000000000080403b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80403b:	55                   	push   %rbp
  80403c:	48 89 e5             	mov    %rsp,%rbp
  80403f:	48 83 ec 20          	sub    $0x20,%rsp
  804043:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804047:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80404b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80404f:	48 89 c7             	mov    %rax,%rdi
  804052:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  804059:	00 00 00 
  80405c:	ff d0                	callq  *%rax
  80405e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804066:	48 be 08 50 80 00 00 	movabs $0x805008,%rsi
  80406d:	00 00 00 
  804070:	48 89 c7             	mov    %rax,%rdi
  804073:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  80407a:	00 00 00 
  80407d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80407f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804083:	8b 50 04             	mov    0x4(%rax),%edx
  804086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80408a:	8b 00                	mov    (%rax),%eax
  80408c:	29 c2                	sub    %eax,%edx
  80408e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804092:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804098:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80409c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8040a3:	00 00 00 
	stat->st_dev = &devpipe;
  8040a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040aa:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8040b1:	00 00 00 
  8040b4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c0:	c9                   	leaveq 
  8040c1:	c3                   	retq   

00000000008040c2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8040c2:	55                   	push   %rbp
  8040c3:	48 89 e5             	mov    %rsp,%rbp
  8040c6:	48 83 ec 10          	sub    $0x10,%rsp
  8040ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8040ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d2:	48 89 c6             	mov    %rax,%rsi
  8040d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8040da:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  8040e1:	00 00 00 
  8040e4:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8040e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ea:	48 89 c7             	mov    %rax,%rdi
  8040ed:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8040f4:	00 00 00 
  8040f7:	ff d0                	callq  *%rax
  8040f9:	48 89 c6             	mov    %rax,%rsi
  8040fc:	bf 00 00 00 00       	mov    $0x0,%edi
  804101:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  804108:	00 00 00 
  80410b:	ff d0                	callq  *%rax
}
  80410d:	c9                   	leaveq 
  80410e:	c3                   	retq   

000000000080410f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80410f:	55                   	push   %rbp
  804110:	48 89 e5             	mov    %rsp,%rbp
  804113:	48 83 ec 20          	sub    $0x20,%rsp
  804117:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80411a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80411d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804120:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804124:	be 01 00 00 00       	mov    $0x1,%esi
  804129:	48 89 c7             	mov    %rax,%rdi
  80412c:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  804133:	00 00 00 
  804136:	ff d0                	callq  *%rax
}
  804138:	90                   	nop
  804139:	c9                   	leaveq 
  80413a:	c3                   	retq   

000000000080413b <getchar>:

int
getchar(void)
{
  80413b:	55                   	push   %rbp
  80413c:	48 89 e5             	mov    %rsp,%rbp
  80413f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804143:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804147:	ba 01 00 00 00       	mov    $0x1,%edx
  80414c:	48 89 c6             	mov    %rax,%rsi
  80414f:	bf 00 00 00 00       	mov    $0x0,%edi
  804154:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  80415b:	00 00 00 
  80415e:	ff d0                	callq  *%rax
  804160:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804163:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804167:	79 05                	jns    80416e <getchar+0x33>
		return r;
  804169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416c:	eb 14                	jmp    804182 <getchar+0x47>
	if (r < 1)
  80416e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804172:	7f 07                	jg     80417b <getchar+0x40>
		return -E_EOF;
  804174:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804179:	eb 07                	jmp    804182 <getchar+0x47>
	return c;
  80417b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80417f:	0f b6 c0             	movzbl %al,%eax

}
  804182:	c9                   	leaveq 
  804183:	c3                   	retq   

0000000000804184 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804184:	55                   	push   %rbp
  804185:	48 89 e5             	mov    %rsp,%rbp
  804188:	48 83 ec 20          	sub    $0x20,%rsp
  80418c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80418f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804193:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804196:	48 89 d6             	mov    %rdx,%rsi
  804199:	89 c7                	mov    %eax,%edi
  80419b:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8041a2:	00 00 00 
  8041a5:	ff d0                	callq  *%rax
  8041a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ae:	79 05                	jns    8041b5 <iscons+0x31>
		return r;
  8041b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b3:	eb 1a                	jmp    8041cf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8041b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b9:	8b 10                	mov    (%rax),%edx
  8041bb:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8041c2:	00 00 00 
  8041c5:	8b 00                	mov    (%rax),%eax
  8041c7:	39 c2                	cmp    %eax,%edx
  8041c9:	0f 94 c0             	sete   %al
  8041cc:	0f b6 c0             	movzbl %al,%eax
}
  8041cf:	c9                   	leaveq 
  8041d0:	c3                   	retq   

00000000008041d1 <opencons>:

int
opencons(void)
{
  8041d1:	55                   	push   %rbp
  8041d2:	48 89 e5             	mov    %rsp,%rbp
  8041d5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041d9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041dd:	48 89 c7             	mov    %rax,%rdi
  8041e0:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  8041e7:	00 00 00 
  8041ea:	ff d0                	callq  *%rax
  8041ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f3:	79 05                	jns    8041fa <opencons+0x29>
		return r;
  8041f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f8:	eb 5b                	jmp    804255 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fe:	ba 07 04 00 00       	mov    $0x407,%edx
  804203:	48 89 c6             	mov    %rax,%rsi
  804206:	bf 00 00 00 00       	mov    $0x0,%edi
  80420b:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
  804217:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80421a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80421e:	79 05                	jns    804225 <opencons+0x54>
		return r;
  804220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804223:	eb 30                	jmp    804255 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804229:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804230:	00 00 00 
  804233:	8b 12                	mov    (%rdx),%edx
  804235:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804246:	48 89 c7             	mov    %rax,%rdi
  804249:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  804250:	00 00 00 
  804253:	ff d0                	callq  *%rax
}
  804255:	c9                   	leaveq 
  804256:	c3                   	retq   

0000000000804257 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804257:	55                   	push   %rbp
  804258:	48 89 e5             	mov    %rsp,%rbp
  80425b:	48 83 ec 30          	sub    $0x30,%rsp
  80425f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804263:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804267:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80426b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804270:	75 13                	jne    804285 <devcons_read+0x2e>
		return 0;
  804272:	b8 00 00 00 00       	mov    $0x0,%eax
  804277:	eb 49                	jmp    8042c2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804279:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  804280:	00 00 00 
  804283:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804285:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  80428c:	00 00 00 
  80428f:	ff d0                	callq  *%rax
  804291:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804298:	74 df                	je     804279 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80429a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80429e:	79 05                	jns    8042a5 <devcons_read+0x4e>
		return c;
  8042a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a3:	eb 1d                	jmp    8042c2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8042a5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8042a9:	75 07                	jne    8042b2 <devcons_read+0x5b>
		return 0;
  8042ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8042b0:	eb 10                	jmp    8042c2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8042b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b5:	89 c2                	mov    %eax,%edx
  8042b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042bb:	88 10                	mov    %dl,(%rax)
	return 1;
  8042bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8042c2:	c9                   	leaveq 
  8042c3:	c3                   	retq   

00000000008042c4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042c4:	55                   	push   %rbp
  8042c5:	48 89 e5             	mov    %rsp,%rbp
  8042c8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8042cf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042d6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042dd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042eb:	eb 76                	jmp    804363 <devcons_write+0x9f>
		m = n - tot;
  8042ed:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8042f4:	89 c2                	mov    %eax,%edx
  8042f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f9:	29 c2                	sub    %eax,%edx
  8042fb:	89 d0                	mov    %edx,%eax
  8042fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804300:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804303:	83 f8 7f             	cmp    $0x7f,%eax
  804306:	76 07                	jbe    80430f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804308:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80430f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804312:	48 63 d0             	movslq %eax,%rdx
  804315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804318:	48 63 c8             	movslq %eax,%rcx
  80431b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804322:	48 01 c1             	add    %rax,%rcx
  804325:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80432c:	48 89 ce             	mov    %rcx,%rsi
  80432f:	48 89 c7             	mov    %rax,%rdi
  804332:	48 b8 f2 11 80 00 00 	movabs $0x8011f2,%rax
  804339:	00 00 00 
  80433c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80433e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804341:	48 63 d0             	movslq %eax,%rdx
  804344:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80434b:	48 89 d6             	mov    %rdx,%rsi
  80434e:	48 89 c7             	mov    %rax,%rdi
  804351:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  804358:	00 00 00 
  80435b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80435d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804360:	01 45 fc             	add    %eax,-0x4(%rbp)
  804363:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804366:	48 98                	cltq   
  804368:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80436f:	0f 82 78 ff ff ff    	jb     8042ed <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804375:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804378:	c9                   	leaveq 
  804379:	c3                   	retq   

000000000080437a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80437a:	55                   	push   %rbp
  80437b:	48 89 e5             	mov    %rsp,%rbp
  80437e:	48 83 ec 08          	sub    $0x8,%rsp
  804382:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804386:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80438b:	c9                   	leaveq 
  80438c:	c3                   	retq   

000000000080438d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80438d:	55                   	push   %rbp
  80438e:	48 89 e5             	mov    %rsp,%rbp
  804391:	48 83 ec 10          	sub    $0x10,%rsp
  804395:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804399:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80439d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a1:	48 be 14 50 80 00 00 	movabs $0x805014,%rsi
  8043a8:	00 00 00 
  8043ab:	48 89 c7             	mov    %rax,%rdi
  8043ae:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  8043b5:	00 00 00 
  8043b8:	ff d0                	callq  *%rax
	return 0;
  8043ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043bf:	c9                   	leaveq 
  8043c0:	c3                   	retq   

00000000008043c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8043c1:	55                   	push   %rbp
  8043c2:	48 89 e5             	mov    %rsp,%rbp
  8043c5:	53                   	push   %rbx
  8043c6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8043cd:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8043d4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8043da:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8043e1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8043e8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8043ef:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8043f6:	84 c0                	test   %al,%al
  8043f8:	74 23                	je     80441d <_panic+0x5c>
  8043fa:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804401:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804405:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804409:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80440d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804411:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804415:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804419:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80441d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804424:	00 00 00 
  804427:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80442e:	00 00 00 
  804431:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804435:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80443c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804443:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80444a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  804451:	00 00 00 
  804454:	48 8b 18             	mov    (%rax),%rbx
  804457:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  80445e:	00 00 00 
  804461:	ff d0                	callq  *%rax
  804463:	89 c6                	mov    %eax,%esi
  804465:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80446b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804472:	41 89 d0             	mov    %edx,%r8d
  804475:	48 89 c1             	mov    %rax,%rcx
  804478:	48 89 da             	mov    %rbx,%rdx
  80447b:	48 bf 20 50 80 00 00 	movabs $0x805020,%rdi
  804482:	00 00 00 
  804485:	b8 00 00 00 00       	mov    $0x0,%eax
  80448a:	49 b9 3d 03 80 00 00 	movabs $0x80033d,%r9
  804491:	00 00 00 
  804494:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804497:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80449e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8044a5:	48 89 d6             	mov    %rdx,%rsi
  8044a8:	48 89 c7             	mov    %rax,%rdi
  8044ab:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  8044b2:	00 00 00 
  8044b5:	ff d0                	callq  *%rax
	cprintf("\n");
  8044b7:	48 bf 43 50 80 00 00 	movabs $0x805043,%rdi
  8044be:	00 00 00 
  8044c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c6:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  8044cd:	00 00 00 
  8044d0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8044d2:	cc                   	int3   
  8044d3:	eb fd                	jmp    8044d2 <_panic+0x111>

00000000008044d5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8044d5:	55                   	push   %rbp
  8044d6:	48 89 e5             	mov    %rsp,%rbp
  8044d9:	48 83 ec 20          	sub    $0x20,%rsp
  8044dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8044e1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044e8:	00 00 00 
  8044eb:	48 8b 00             	mov    (%rax),%rax
  8044ee:	48 85 c0             	test   %rax,%rax
  8044f1:	75 6f                	jne    804562 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8044f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8044f8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8044fd:	bf 00 00 00 00       	mov    $0x0,%edi
  804502:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  804509:	00 00 00 
  80450c:	ff d0                	callq  *%rax
  80450e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804515:	79 30                	jns    804547 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80451a:	89 c1                	mov    %eax,%ecx
  80451c:	48 ba 48 50 80 00 00 	movabs $0x805048,%rdx
  804523:	00 00 00 
  804526:	be 22 00 00 00       	mov    $0x22,%esi
  80452b:	48 bf 67 50 80 00 00 	movabs $0x805067,%rdi
  804532:	00 00 00 
  804535:	b8 00 00 00 00       	mov    $0x0,%eax
  80453a:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  804541:	00 00 00 
  804544:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804547:	48 be 76 45 80 00 00 	movabs $0x804576,%rsi
  80454e:	00 00 00 
  804551:	bf 00 00 00 00       	mov    $0x0,%edi
  804556:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  80455d:	00 00 00 
  804560:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804562:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804569:	00 00 00 
  80456c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804570:	48 89 10             	mov    %rdx,(%rax)
}
  804573:	90                   	nop
  804574:	c9                   	leaveq 
  804575:	c3                   	retq   

0000000000804576 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804576:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804579:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804580:	00 00 00 
call *%rax
  804583:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804585:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80458c:	00 08 
    movq 152(%rsp), %rax
  80458e:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804595:	00 
    movq 136(%rsp), %rbx
  804596:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80459d:	00 
movq %rbx, (%rax)
  80459e:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8045a1:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8045a5:	4c 8b 3c 24          	mov    (%rsp),%r15
  8045a9:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8045ae:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8045b3:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8045b8:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8045bd:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8045c2:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8045c7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8045cc:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8045d1:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8045d6:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8045db:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8045e0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8045e5:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8045ea:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8045ef:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  8045f3:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8045f7:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8045f8:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8045fd:	c3                   	retq   

00000000008045fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8045fe:	55                   	push   %rbp
  8045ff:	48 89 e5             	mov    %rsp,%rbp
  804602:	48 83 ec 30          	sub    $0x30,%rsp
  804606:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80460a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80460e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804612:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804617:	75 0e                	jne    804627 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804619:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804620:	00 00 00 
  804623:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804627:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80462b:	48 89 c7             	mov    %rax,%rdi
  80462e:	48 b8 3d 1a 80 00 00 	movabs $0x801a3d,%rax
  804635:	00 00 00 
  804638:	ff d0                	callq  *%rax
  80463a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80463d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804641:	79 27                	jns    80466a <ipc_recv+0x6c>
		if (from_env_store)
  804643:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804648:	74 0a                	je     804654 <ipc_recv+0x56>
			*from_env_store = 0;
  80464a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80464e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804654:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804659:	74 0a                	je     804665 <ipc_recv+0x67>
			*perm_store = 0;
  80465b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80465f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804668:	eb 53                	jmp    8046bd <ipc_recv+0xbf>
	}
	if (from_env_store)
  80466a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80466f:	74 19                	je     80468a <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804671:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804678:	00 00 00 
  80467b:	48 8b 00             	mov    (%rax),%rax
  80467e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804688:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80468a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80468f:	74 19                	je     8046aa <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804691:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804698:	00 00 00 
  80469b:	48 8b 00             	mov    (%rax),%rax
  80469e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8046a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a8:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8046aa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046b1:	00 00 00 
  8046b4:	48 8b 00             	mov    (%rax),%rax
  8046b7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8046bd:	c9                   	leaveq 
  8046be:	c3                   	retq   

00000000008046bf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8046bf:	55                   	push   %rbp
  8046c0:	48 89 e5             	mov    %rsp,%rbp
  8046c3:	48 83 ec 30          	sub    $0x30,%rsp
  8046c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8046cd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8046d1:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8046d4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046d9:	75 1c                	jne    8046f7 <ipc_send+0x38>
		pg = (void*) UTOP;
  8046db:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8046e2:	00 00 00 
  8046e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8046e9:	eb 0c                	jmp    8046f7 <ipc_send+0x38>
		sys_yield();
  8046eb:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8046f2:	00 00 00 
  8046f5:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8046f7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8046fa:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8046fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804701:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804704:	89 c7                	mov    %eax,%edi
  804706:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80470d:	00 00 00 
  804710:	ff d0                	callq  *%rax
  804712:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804715:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804719:	74 d0                	je     8046eb <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80471b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80471f:	79 30                	jns    804751 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804724:	89 c1                	mov    %eax,%ecx
  804726:	48 ba 75 50 80 00 00 	movabs $0x805075,%rdx
  80472d:	00 00 00 
  804730:	be 47 00 00 00       	mov    $0x47,%esi
  804735:	48 bf 8b 50 80 00 00 	movabs $0x80508b,%rdi
  80473c:	00 00 00 
  80473f:	b8 00 00 00 00       	mov    $0x0,%eax
  804744:	49 b8 c1 43 80 00 00 	movabs $0x8043c1,%r8
  80474b:	00 00 00 
  80474e:	41 ff d0             	callq  *%r8

}
  804751:	90                   	nop
  804752:	c9                   	leaveq 
  804753:	c3                   	retq   

0000000000804754 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804754:	55                   	push   %rbp
  804755:	48 89 e5             	mov    %rsp,%rbp
  804758:	48 83 ec 18          	sub    $0x18,%rsp
  80475c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80475f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804766:	eb 4d                	jmp    8047b5 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804768:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80476f:	00 00 00 
  804772:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804775:	48 98                	cltq   
  804777:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80477e:	48 01 d0             	add    %rdx,%rax
  804781:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804787:	8b 00                	mov    (%rax),%eax
  804789:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80478c:	75 23                	jne    8047b1 <ipc_find_env+0x5d>
			return envs[i].env_id;
  80478e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804795:	00 00 00 
  804798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80479b:	48 98                	cltq   
  80479d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8047a4:	48 01 d0             	add    %rdx,%rax
  8047a7:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8047ad:	8b 00                	mov    (%rax),%eax
  8047af:	eb 12                	jmp    8047c3 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8047b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8047b5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8047bc:	7e aa                	jle    804768 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8047be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047c3:	c9                   	leaveq 
  8047c4:	c3                   	retq   

00000000008047c5 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8047c5:	55                   	push   %rbp
  8047c6:	48 89 e5             	mov    %rsp,%rbp
  8047c9:	48 83 ec 18          	sub    $0x18,%rsp
  8047cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8047d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d5:	48 c1 e8 15          	shr    $0x15,%rax
  8047d9:	48 89 c2             	mov    %rax,%rdx
  8047dc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8047e3:	01 00 00 
  8047e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8047ea:	83 e0 01             	and    $0x1,%eax
  8047ed:	48 85 c0             	test   %rax,%rax
  8047f0:	75 07                	jne    8047f9 <pageref+0x34>
		return 0;
  8047f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8047f7:	eb 56                	jmp    80484f <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8047f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047fd:	48 c1 e8 0c          	shr    $0xc,%rax
  804801:	48 89 c2             	mov    %rax,%rdx
  804804:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80480b:	01 00 00 
  80480e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804812:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80481a:	83 e0 01             	and    $0x1,%eax
  80481d:	48 85 c0             	test   %rax,%rax
  804820:	75 07                	jne    804829 <pageref+0x64>
		return 0;
  804822:	b8 00 00 00 00       	mov    $0x0,%eax
  804827:	eb 26                	jmp    80484f <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804829:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80482d:	48 c1 e8 0c          	shr    $0xc,%rax
  804831:	48 89 c2             	mov    %rax,%rdx
  804834:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80483b:	00 00 00 
  80483e:	48 c1 e2 04          	shl    $0x4,%rdx
  804842:	48 01 d0             	add    %rdx,%rax
  804845:	48 83 c0 08          	add    $0x8,%rax
  804849:	0f b7 00             	movzwl (%rax),%eax
  80484c:	0f b7 c0             	movzwl %ax,%eax
}
  80484f:	c9                   	leaveq 
  804850:	c3                   	retq   
