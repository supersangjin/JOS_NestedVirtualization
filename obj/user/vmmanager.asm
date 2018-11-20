
obj/user/vmmanager:     file format elf64-x86-64


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
  80003c:	e8 e3 00 00 00       	callq  800124 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#ifndef VMM_GUEST
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *buf;
	sys_vmx_list_vms();
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	48 ba 12 1d 80 00 00 	movabs $0x801d12,%rdx
  80005e:	00 00 00 
  800061:	ff d2                	callq  *%rdx
	buf = readline("Please select a VM to resume: ");
  800063:	48 bf 40 45 80 00 00 	movabs $0x804540,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 16 0e 80 00 00 	movabs $0x800e16,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (!(strlen(buf) == 1
  80007d:	eb 36                	jmp    8000b5 <umain+0x72>
	
	if (sys_vmx_sel_resume(buf[0] - '1' + 1)) {
		cprintf("Press Enter to Continue\n");
	}
	else {		
		goto error;
  80007f:	90                   	nop
	sys_vmx_list_vms();
	buf = readline("Please select a VM to resume: ");
	while (!(strlen(buf) == 1
		&& buf[0] >= '1' 
		&& buf[0] <= '9')) {
error:		cprintf("Please enter a correct vm number\n");
  800080:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
  800087:	00 00 00 
  80008a:	b8 00 00 00 00       	mov    $0x0,%eax
  80008f:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  800096:	00 00 00 
  800099:	ff d2                	callq  *%rdx
		buf = readline("Please select a VM to resume: ");
  80009b:	48 bf 40 45 80 00 00 	movabs $0x804540,%rdi
  8000a2:	00 00 00 
  8000a5:	48 b8 16 0e 80 00 00 	movabs $0x800e16,%rax
  8000ac:	00 00 00 
  8000af:	ff d0                	callq  *%rax
  8000b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
umain(int argc, char **argv)
{
	char *buf;
	sys_vmx_list_vms();
	buf = readline("Please select a VM to resume: ");
	while (!(strlen(buf) == 1
  8000b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b9:	48 89 c7             	mov    %rax,%rdi
  8000bc:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  8000c3:	00 00 00 
  8000c6:	ff d0                	callq  *%rax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	75 b3                	jne    800080 <umain+0x3d>
		&& buf[0] >= '1' 
  8000cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000d1:	0f b6 00             	movzbl (%rax),%eax
  8000d4:	3c 30                	cmp    $0x30,%al
  8000d6:	7e a8                	jle    800080 <umain+0x3d>
		&& buf[0] <= '9')) {
  8000d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000dc:	0f b6 00             	movzbl (%rax),%eax
umain(int argc, char **argv)
{
	char *buf;
	sys_vmx_list_vms();
	buf = readline("Please select a VM to resume: ");
	while (!(strlen(buf) == 1
  8000df:	3c 39                	cmp    $0x39,%al
  8000e1:	7f 9d                	jg     800080 <umain+0x3d>
		&& buf[0] <= '9')) {
error:		cprintf("Please enter a correct vm number\n");
		buf = readline("Please select a VM to resume: ");
	}
	
	if (sys_vmx_sel_resume(buf[0] - '1' + 1)) {
  8000e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000e7:	0f b6 00             	movzbl (%rax),%eax
  8000ea:	0f be c0             	movsbl %al,%eax
  8000ed:	83 e8 30             	sub    $0x30,%eax
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	48 b8 4f 1d 80 00 00 	movabs $0x801d4f,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	85 c0                	test   %eax,%eax
  800100:	0f 84 79 ff ff ff    	je     80007f <umain+0x3c>
		cprintf("Press Enter to Continue\n");
  800106:	48 bf 82 45 80 00 00 	movabs $0x804582,%rdi
  80010d:	00 00 00 
  800110:	b8 00 00 00 00       	mov    $0x0,%eax
  800115:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  80011c:	00 00 00 
  80011f:	ff d2                	callq  *%rdx
	}
	else {		
		goto error;
	}
	
}
  800121:	90                   	nop
  800122:	c9                   	leaveq 
  800123:	c3                   	retq   

0000000000800124 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800124:	55                   	push   %rbp
  800125:	48 89 e5             	mov    %rsp,%rbp
  800128:	48 83 ec 10          	sub    $0x10,%rsp
  80012c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80012f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800133:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	48 98                	cltq   
  800146:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80014d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800154:	00 00 00 
  800157:	48 01 c2             	add    %rax,%rdx
  80015a:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  800161:	00 00 00 
  800164:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800167:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016b:	7e 14                	jle    800181 <libmain+0x5d>
		binaryname = argv[0];
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 8b 10             	mov    (%rax),%rdx
  800174:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80017b:	00 00 00 
  80017e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800181:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800188:	48 89 d6             	mov    %rdx,%rsi
  80018b:	89 c7                	mov    %eax,%edi
  80018d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800194:	00 00 00 
  800197:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800199:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  8001a0:	00 00 00 
  8001a3:	ff d0                	callq  *%rax
}
  8001a5:	90                   	nop
  8001a6:	c9                   	leaveq 
  8001a7:	c3                   	retq   

00000000008001a8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a8:	55                   	push   %rbp
  8001a9:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8001ac:	48 b8 51 21 80 00 00 	movabs $0x802151,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8001b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bd:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
}
  8001c9:	90                   	nop
  8001ca:	5d                   	pop    %rbp
  8001cb:	c3                   	retq   

00000000008001cc <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 10          	sub    $0x10,%rsp
  8001d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001df:	8b 00                	mov    (%rax),%eax
  8001e1:	8d 48 01             	lea    0x1(%rax),%ecx
  8001e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e8:	89 0a                	mov    %ecx,(%rdx)
  8001ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ed:	89 d1                	mov    %edx,%ecx
  8001ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f3:	48 98                	cltq   
  8001f5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fd:	8b 00                	mov    (%rax),%eax
  8001ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800204:	75 2c                	jne    800232 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	8b 00                	mov    (%rax),%eax
  80020c:	48 98                	cltq   
  80020e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800212:	48 83 c2 08          	add    $0x8,%rdx
  800216:	48 89 c6             	mov    %rax,%rsi
  800219:	48 89 d7             	mov    %rdx,%rdi
  80021c:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
        b->idx = 0;
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800236:	8b 40 04             	mov    0x4(%rax),%eax
  800239:	8d 50 01             	lea    0x1(%rax),%edx
  80023c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800240:	89 50 04             	mov    %edx,0x4(%rax)
}
  800243:	90                   	nop
  800244:	c9                   	leaveq 
  800245:	c3                   	retq   

0000000000800246 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800246:	55                   	push   %rbp
  800247:	48 89 e5             	mov    %rsp,%rbp
  80024a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800251:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800258:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80025f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800266:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80026d:	48 8b 0a             	mov    (%rdx),%rcx
  800270:	48 89 08             	mov    %rcx,(%rax)
  800273:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800277:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80027b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80027f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800283:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80028a:	00 00 00 
    b.cnt = 0;
  80028d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800294:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800297:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80029e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002a5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002ac:	48 89 c6             	mov    %rax,%rsi
  8002af:	48 bf cc 01 80 00 00 	movabs $0x8001cc,%rdi
  8002b6:	00 00 00 
  8002b9:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  8002c0:	00 00 00 
  8002c3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002c5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002cb:	48 98                	cltq   
  8002cd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d4:	48 83 c2 08          	add    $0x8,%rdx
  8002d8:	48 89 c6             	mov    %rax,%rsi
  8002db:	48 89 d7             	mov    %rdx,%rdi
  8002de:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8002e5:	00 00 00 
  8002e8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002f0:	c9                   	leaveq 
  8002f1:	c3                   	retq   

00000000008002f2 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002f2:	55                   	push   %rbp
  8002f3:	48 89 e5             	mov    %rsp,%rbp
  8002f6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002fd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800304:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80030b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800312:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800319:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800320:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800327:	84 c0                	test   %al,%al
  800329:	74 20                	je     80034b <cprintf+0x59>
  80032b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80032f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800333:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800337:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80033b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80033f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800343:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800347:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80034b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800352:	00 00 00 
  800355:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80035c:	00 00 00 
  80035f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800363:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80036a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800371:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800378:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80037f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800386:	48 8b 0a             	mov    (%rdx),%rcx
  800389:	48 89 08             	mov    %rcx,(%rax)
  80038c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800390:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800394:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800398:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80039c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003aa:	48 89 d6             	mov    %rdx,%rsi
  8003ad:	48 89 c7             	mov    %rax,%rdi
  8003b0:	48 b8 46 02 80 00 00 	movabs $0x800246,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
  8003bc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003c2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003c8:	c9                   	leaveq 
  8003c9:	c3                   	retq   

00000000008003ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ca:	55                   	push   %rbp
  8003cb:	48 89 e5             	mov    %rsp,%rbp
  8003ce:	48 83 ec 30          	sub    $0x30,%rsp
  8003d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003de:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8003e1:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8003e5:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003ec:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8003f0:	77 54                	ja     800446 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003f5:	8d 78 ff             	lea    -0x1(%rax),%edi
  8003f8:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8003fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800404:	48 f7 f6             	div    %rsi
  800407:	49 89 c2             	mov    %rax,%r10
  80040a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80040d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800410:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800418:	41 89 c9             	mov    %ecx,%r9d
  80041b:	41 89 f8             	mov    %edi,%r8d
  80041e:	89 d1                	mov    %edx,%ecx
  800420:	4c 89 d2             	mov    %r10,%rdx
  800423:	48 89 c7             	mov    %rax,%rdi
  800426:	48 b8 ca 03 80 00 00 	movabs $0x8003ca,%rax
  80042d:	00 00 00 
  800430:	ff d0                	callq  *%rax
  800432:	eb 1c                	jmp    800450 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800434:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800438:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80043b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80043f:	48 89 ce             	mov    %rcx,%rsi
  800442:	89 d7                	mov    %edx,%edi
  800444:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800446:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80044a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80044e:	7f e4                	jg     800434 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800450:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
  80045c:	48 f7 f1             	div    %rcx
  80045f:	48 b8 b0 47 80 00 00 	movabs $0x8047b0,%rax
  800466:	00 00 00 
  800469:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80046d:	0f be d0             	movsbl %al,%edx
  800470:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800474:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800478:	48 89 ce             	mov    %rcx,%rsi
  80047b:	89 d7                	mov    %edx,%edi
  80047d:	ff d0                	callq  *%rax
}
  80047f:	90                   	nop
  800480:	c9                   	leaveq 
  800481:	c3                   	retq   

0000000000800482 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800482:	55                   	push   %rbp
  800483:	48 89 e5             	mov    %rsp,%rbp
  800486:	48 83 ec 20          	sub    $0x20,%rsp
  80048a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80048e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800491:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800495:	7e 4f                	jle    8004e6 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049b:	8b 00                	mov    (%rax),%eax
  80049d:	83 f8 30             	cmp    $0x30,%eax
  8004a0:	73 24                	jae    8004c6 <getuint+0x44>
  8004a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	89 c0                	mov    %eax,%eax
  8004b2:	48 01 d0             	add    %rdx,%rax
  8004b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b9:	8b 12                	mov    (%rdx),%edx
  8004bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c2:	89 0a                	mov    %ecx,(%rdx)
  8004c4:	eb 14                	jmp    8004da <getuint+0x58>
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004ce:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004da:	48 8b 00             	mov    (%rax),%rax
  8004dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004e1:	e9 9d 00 00 00       	jmpq   800583 <getuint+0x101>
	else if (lflag)
  8004e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004ea:	74 4c                	je     800538 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8004ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f0:	8b 00                	mov    (%rax),%eax
  8004f2:	83 f8 30             	cmp    $0x30,%eax
  8004f5:	73 24                	jae    80051b <getuint+0x99>
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800503:	8b 00                	mov    (%rax),%eax
  800505:	89 c0                	mov    %eax,%eax
  800507:	48 01 d0             	add    %rdx,%rax
  80050a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050e:	8b 12                	mov    (%rdx),%edx
  800510:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800513:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800517:	89 0a                	mov    %ecx,(%rdx)
  800519:	eb 14                	jmp    80052f <getuint+0xad>
  80051b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800523:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800527:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80052f:	48 8b 00             	mov    (%rax),%rax
  800532:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800536:	eb 4b                	jmp    800583 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	8b 00                	mov    (%rax),%eax
  80053e:	83 f8 30             	cmp    $0x30,%eax
  800541:	73 24                	jae    800567 <getuint+0xe5>
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	8b 00                	mov    (%rax),%eax
  800551:	89 c0                	mov    %eax,%eax
  800553:	48 01 d0             	add    %rdx,%rax
  800556:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055a:	8b 12                	mov    (%rdx),%edx
  80055c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800563:	89 0a                	mov    %ecx,(%rdx)
  800565:	eb 14                	jmp    80057b <getuint+0xf9>
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80056f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800573:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800577:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057b:	8b 00                	mov    (%rax),%eax
  80057d:	89 c0                	mov    %eax,%eax
  80057f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800587:	c9                   	leaveq 
  800588:	c3                   	retq   

0000000000800589 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800589:	55                   	push   %rbp
  80058a:	48 89 e5             	mov    %rsp,%rbp
  80058d:	48 83 ec 20          	sub    $0x20,%rsp
  800591:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800595:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800598:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80059c:	7e 4f                	jle    8005ed <getint+0x64>
		x=va_arg(*ap, long long);
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	8b 00                	mov    (%rax),%eax
  8005a4:	83 f8 30             	cmp    $0x30,%eax
  8005a7:	73 24                	jae    8005cd <getint+0x44>
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	89 c0                	mov    %eax,%eax
  8005b9:	48 01 d0             	add    %rdx,%rax
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	8b 12                	mov    (%rdx),%edx
  8005c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c9:	89 0a                	mov    %ecx,(%rdx)
  8005cb:	eb 14                	jmp    8005e1 <getint+0x58>
  8005cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005d5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e1:	48 8b 00             	mov    (%rax),%rax
  8005e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e8:	e9 9d 00 00 00       	jmpq   80068a <getint+0x101>
	else if (lflag)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005f1:	74 4c                	je     80063f <getint+0xb6>
		x=va_arg(*ap, long);
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	8b 00                	mov    (%rax),%eax
  8005f9:	83 f8 30             	cmp    $0x30,%eax
  8005fc:	73 24                	jae    800622 <getint+0x99>
  8005fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800602:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	8b 00                	mov    (%rax),%eax
  80060c:	89 c0                	mov    %eax,%eax
  80060e:	48 01 d0             	add    %rdx,%rax
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	8b 12                	mov    (%rdx),%edx
  800617:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80061a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061e:	89 0a                	mov    %ecx,(%rdx)
  800620:	eb 14                	jmp    800636 <getint+0xad>
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	48 8b 40 08          	mov    0x8(%rax),%rax
  80062a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800636:	48 8b 00             	mov    (%rax),%rax
  800639:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063d:	eb 4b                	jmp    80068a <getint+0x101>
	else
		x=va_arg(*ap, int);
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	8b 00                	mov    (%rax),%eax
  800645:	83 f8 30             	cmp    $0x30,%eax
  800648:	73 24                	jae    80066e <getint+0xe5>
  80064a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800656:	8b 00                	mov    (%rax),%eax
  800658:	89 c0                	mov    %eax,%eax
  80065a:	48 01 d0             	add    %rdx,%rax
  80065d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800661:	8b 12                	mov    (%rdx),%edx
  800663:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066a:	89 0a                	mov    %ecx,(%rdx)
  80066c:	eb 14                	jmp    800682 <getint+0xf9>
  80066e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800672:	48 8b 40 08          	mov    0x8(%rax),%rax
  800676:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80067a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800682:	8b 00                	mov    (%rax),%eax
  800684:	48 98                	cltq   
  800686:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80068a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068e:	c9                   	leaveq 
  80068f:	c3                   	retq   

0000000000800690 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800690:	55                   	push   %rbp
  800691:	48 89 e5             	mov    %rsp,%rbp
  800694:	41 54                	push   %r12
  800696:	53                   	push   %rbx
  800697:	48 83 ec 60          	sub    $0x60,%rsp
  80069b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80069f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006af:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006b3:	48 8b 0a             	mov    (%rdx),%rcx
  8006b6:	48 89 08             	mov    %rcx,(%rax)
  8006b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c9:	eb 17                	jmp    8006e2 <vprintfmt+0x52>
			if (ch == '\0')
  8006cb:	85 db                	test   %ebx,%ebx
  8006cd:	0f 84 b9 04 00 00    	je     800b8c <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8006d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006db:	48 89 d6             	mov    %rdx,%rsi
  8006de:	89 df                	mov    %ebx,%edi
  8006e0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ea:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ee:	0f b6 00             	movzbl (%rax),%eax
  8006f1:	0f b6 d8             	movzbl %al,%ebx
  8006f4:	83 fb 25             	cmp    $0x25,%ebx
  8006f7:	75 d2                	jne    8006cb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006f9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006fd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800704:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80070b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800712:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800719:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80071d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800721:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800725:	0f b6 00             	movzbl (%rax),%eax
  800728:	0f b6 d8             	movzbl %al,%ebx
  80072b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80072e:	83 f8 55             	cmp    $0x55,%eax
  800731:	0f 87 22 04 00 00    	ja     800b59 <vprintfmt+0x4c9>
  800737:	89 c0                	mov    %eax,%eax
  800739:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800740:	00 
  800741:	48 b8 d8 47 80 00 00 	movabs $0x8047d8,%rax
  800748:	00 00 00 
  80074b:	48 01 d0             	add    %rdx,%rax
  80074e:	48 8b 00             	mov    (%rax),%rax
  800751:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800753:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800757:	eb c0                	jmp    800719 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800759:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80075d:	eb ba                	jmp    800719 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800766:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800769:	89 d0                	mov    %edx,%eax
  80076b:	c1 e0 02             	shl    $0x2,%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	01 c0                	add    %eax,%eax
  800772:	01 d8                	add    %ebx,%eax
  800774:	83 e8 30             	sub    $0x30,%eax
  800777:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80077a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80077e:	0f b6 00             	movzbl (%rax),%eax
  800781:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800784:	83 fb 2f             	cmp    $0x2f,%ebx
  800787:	7e 60                	jle    8007e9 <vprintfmt+0x159>
  800789:	83 fb 39             	cmp    $0x39,%ebx
  80078c:	7f 5b                	jg     8007e9 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800793:	eb d1                	jmp    800766 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800795:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800798:	83 f8 30             	cmp    $0x30,%eax
  80079b:	73 17                	jae    8007b4 <vprintfmt+0x124>
  80079d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a4:	89 d2                	mov    %edx,%edx
  8007a6:	48 01 d0             	add    %rdx,%rax
  8007a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ac:	83 c2 08             	add    $0x8,%edx
  8007af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b2:	eb 0c                	jmp    8007c0 <vprintfmt+0x130>
  8007b4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007b8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007bc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007c5:	eb 23                	jmp    8007ea <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8007c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007cb:	0f 89 48 ff ff ff    	jns    800719 <vprintfmt+0x89>
				width = 0;
  8007d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007d8:	e9 3c ff ff ff       	jmpq   800719 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007dd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007e4:	e9 30 ff ff ff       	jmpq   800719 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ee:	0f 89 25 ff ff ff    	jns    800719 <vprintfmt+0x89>
				width = precision, precision = -1;
  8007f4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800801:	e9 13 ff ff ff       	jmpq   800719 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800806:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80080a:	e9 0a ff ff ff       	jmpq   800719 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80080f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 17                	jae    80082e <vprintfmt+0x19e>
  800817:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80081b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80081e:	89 d2                	mov    %edx,%edx
  800820:	48 01 d0             	add    %rdx,%rax
  800823:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800826:	83 c2 08             	add    $0x8,%edx
  800829:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80082c:	eb 0c                	jmp    80083a <vprintfmt+0x1aa>
  80082e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800832:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800836:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80083a:	8b 10                	mov    (%rax),%edx
  80083c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800840:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800844:	48 89 ce             	mov    %rcx,%rsi
  800847:	89 d7                	mov    %edx,%edi
  800849:	ff d0                	callq  *%rax
			break;
  80084b:	e9 37 03 00 00       	jmpq   800b87 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800850:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800853:	83 f8 30             	cmp    $0x30,%eax
  800856:	73 17                	jae    80086f <vprintfmt+0x1df>
  800858:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80085c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80085f:	89 d2                	mov    %edx,%edx
  800861:	48 01 d0             	add    %rdx,%rax
  800864:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800867:	83 c2 08             	add    $0x8,%edx
  80086a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086d:	eb 0c                	jmp    80087b <vprintfmt+0x1eb>
  80086f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800873:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800877:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80087d:	85 db                	test   %ebx,%ebx
  80087f:	79 02                	jns    800883 <vprintfmt+0x1f3>
				err = -err;
  800881:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800883:	83 fb 15             	cmp    $0x15,%ebx
  800886:	7f 16                	jg     80089e <vprintfmt+0x20e>
  800888:	48 b8 00 47 80 00 00 	movabs $0x804700,%rax
  80088f:	00 00 00 
  800892:	48 63 d3             	movslq %ebx,%rdx
  800895:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800899:	4d 85 e4             	test   %r12,%r12
  80089c:	75 2e                	jne    8008cc <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80089e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008a2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a6:	89 d9                	mov    %ebx,%ecx
  8008a8:	48 ba c1 47 80 00 00 	movabs $0x8047c1,%rdx
  8008af:	00 00 00 
  8008b2:	48 89 c7             	mov    %rax,%rdi
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ba:	49 b8 96 0b 80 00 00 	movabs $0x800b96,%r8
  8008c1:	00 00 00 
  8008c4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008c7:	e9 bb 02 00 00       	jmpq   800b87 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d4:	4c 89 e1             	mov    %r12,%rcx
  8008d7:	48 ba ca 47 80 00 00 	movabs $0x8047ca,%rdx
  8008de:	00 00 00 
  8008e1:	48 89 c7             	mov    %rax,%rdi
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	49 b8 96 0b 80 00 00 	movabs $0x800b96,%r8
  8008f0:	00 00 00 
  8008f3:	41 ff d0             	callq  *%r8
			break;
  8008f6:	e9 8c 02 00 00       	jmpq   800b87 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fe:	83 f8 30             	cmp    $0x30,%eax
  800901:	73 17                	jae    80091a <vprintfmt+0x28a>
  800903:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800907:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80090a:	89 d2                	mov    %edx,%edx
  80090c:	48 01 d0             	add    %rdx,%rax
  80090f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800912:	83 c2 08             	add    $0x8,%edx
  800915:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800918:	eb 0c                	jmp    800926 <vprintfmt+0x296>
  80091a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80091e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800922:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800926:	4c 8b 20             	mov    (%rax),%r12
  800929:	4d 85 e4             	test   %r12,%r12
  80092c:	75 0a                	jne    800938 <vprintfmt+0x2a8>
				p = "(null)";
  80092e:	49 bc cd 47 80 00 00 	movabs $0x8047cd,%r12
  800935:	00 00 00 
			if (width > 0 && padc != '-')
  800938:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80093c:	7e 78                	jle    8009b6 <vprintfmt+0x326>
  80093e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800942:	74 72                	je     8009b6 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800944:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800947:	48 98                	cltq   
  800949:	48 89 c6             	mov    %rax,%rsi
  80094c:	4c 89 e7             	mov    %r12,%rdi
  80094f:	48 b8 a2 0f 80 00 00 	movabs $0x800fa2,%rax
  800956:	00 00 00 
  800959:	ff d0                	callq  *%rax
  80095b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80095e:	eb 17                	jmp    800977 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800960:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800964:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800968:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096c:	48 89 ce             	mov    %rcx,%rsi
  80096f:	89 d7                	mov    %edx,%edi
  800971:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800973:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800977:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097b:	7f e3                	jg     800960 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097d:	eb 37                	jmp    8009b6 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  80097f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800983:	74 1e                	je     8009a3 <vprintfmt+0x313>
  800985:	83 fb 1f             	cmp    $0x1f,%ebx
  800988:	7e 05                	jle    80098f <vprintfmt+0x2ff>
  80098a:	83 fb 7e             	cmp    $0x7e,%ebx
  80098d:	7e 14                	jle    8009a3 <vprintfmt+0x313>
					putch('?', putdat);
  80098f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800993:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800997:	48 89 d6             	mov    %rdx,%rsi
  80099a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80099f:	ff d0                	callq  *%rax
  8009a1:	eb 0f                	jmp    8009b2 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8009a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ab:	48 89 d6             	mov    %rdx,%rsi
  8009ae:	89 df                	mov    %ebx,%edi
  8009b0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009b6:	4c 89 e0             	mov    %r12,%rax
  8009b9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009bd:	0f b6 00             	movzbl (%rax),%eax
  8009c0:	0f be d8             	movsbl %al,%ebx
  8009c3:	85 db                	test   %ebx,%ebx
  8009c5:	74 28                	je     8009ef <vprintfmt+0x35f>
  8009c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009cb:	78 b2                	js     80097f <vprintfmt+0x2ef>
  8009cd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009d5:	79 a8                	jns    80097f <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d7:	eb 16                	jmp    8009ef <vprintfmt+0x35f>
				putch(' ', putdat);
  8009d9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e1:	48 89 d6             	mov    %rdx,%rsi
  8009e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8009e9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f3:	7f e4                	jg     8009d9 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  8009f5:	e9 8d 01 00 00       	jmpq   800b87 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009fa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009fe:	be 03 00 00 00       	mov    $0x3,%esi
  800a03:	48 89 c7             	mov    %rax,%rdi
  800a06:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  800a0d:	00 00 00 
  800a10:	ff d0                	callq  *%rax
  800a12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	48 85 c0             	test   %rax,%rax
  800a1d:	79 1d                	jns    800a3c <vprintfmt+0x3ac>
				putch('-', putdat);
  800a1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a27:	48 89 d6             	mov    %rdx,%rsi
  800a2a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a2f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	48 f7 d8             	neg    %rax
  800a38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a3c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a43:	e9 d2 00 00 00       	jmpq   800b1a <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4c:	be 03 00 00 00       	mov    $0x3,%esi
  800a51:	48 89 c7             	mov    %rax,%rdi
  800a54:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  800a5b:	00 00 00 
  800a5e:	ff d0                	callq  *%rax
  800a60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a64:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a6b:	e9 aa 00 00 00       	jmpq   800b1a <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800a70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a74:	be 03 00 00 00       	mov    $0x3,%esi
  800a79:	48 89 c7             	mov    %rax,%rdi
  800a7c:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  800a83:	00 00 00 
  800a86:	ff d0                	callq  *%rax
  800a88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a8c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a93:	e9 82 00 00 00       	jmpq   800b1a <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800a98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa0:	48 89 d6             	mov    %rdx,%rsi
  800aa3:	bf 30 00 00 00       	mov    $0x30,%edi
  800aa8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800aaa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab2:	48 89 d6             	mov    %rdx,%rsi
  800ab5:	bf 78 00 00 00       	mov    $0x78,%edi
  800aba:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800abc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abf:	83 f8 30             	cmp    $0x30,%eax
  800ac2:	73 17                	jae    800adb <vprintfmt+0x44b>
  800ac4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ac8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800acb:	89 d2                	mov    %edx,%edx
  800acd:	48 01 d0             	add    %rdx,%rax
  800ad0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad3:	83 c2 08             	add    $0x8,%edx
  800ad6:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad9:	eb 0c                	jmp    800ae7 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800adb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800adf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ae3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae7:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aee:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800af5:	eb 23                	jmp    800b1a <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800af7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afb:	be 03 00 00 00       	mov    $0x3,%esi
  800b00:	48 89 c7             	mov    %rax,%rdi
  800b03:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  800b0a:	00 00 00 
  800b0d:	ff d0                	callq  *%rax
  800b0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b13:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b1a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b1f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b22:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b29:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b31:	45 89 c1             	mov    %r8d,%r9d
  800b34:	41 89 f8             	mov    %edi,%r8d
  800b37:	48 89 c7             	mov    %rax,%rdi
  800b3a:	48 b8 ca 03 80 00 00 	movabs $0x8003ca,%rax
  800b41:	00 00 00 
  800b44:	ff d0                	callq  *%rax
			break;
  800b46:	eb 3f                	jmp    800b87 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	89 df                	mov    %ebx,%edi
  800b55:	ff d0                	callq  *%rax
			break;
  800b57:	eb 2e                	jmp    800b87 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b61:	48 89 d6             	mov    %rdx,%rsi
  800b64:	bf 25 00 00 00       	mov    $0x25,%edi
  800b69:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b70:	eb 05                	jmp    800b77 <vprintfmt+0x4e7>
  800b72:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b77:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b7b:	48 83 e8 01          	sub    $0x1,%rax
  800b7f:	0f b6 00             	movzbl (%rax),%eax
  800b82:	3c 25                	cmp    $0x25,%al
  800b84:	75 ec                	jne    800b72 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800b86:	90                   	nop
		}
	}
  800b87:	e9 3d fb ff ff       	jmpq   8006c9 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b8c:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b8d:	48 83 c4 60          	add    $0x60,%rsp
  800b91:	5b                   	pop    %rbx
  800b92:	41 5c                	pop    %r12
  800b94:	5d                   	pop    %rbp
  800b95:	c3                   	retq   

0000000000800b96 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b96:	55                   	push   %rbp
  800b97:	48 89 e5             	mov    %rsp,%rbp
  800b9a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ba1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ba8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800baf:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800bb6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bbd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bc4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bcb:	84 c0                	test   %al,%al
  800bcd:	74 20                	je     800bef <printfmt+0x59>
  800bcf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bd3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bd7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bdb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bdf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800be3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800be7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800beb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bef:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bf6:	00 00 00 
  800bf9:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c00:	00 00 00 
  800c03:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c07:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c0e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c15:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c1c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c23:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c2a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c31:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c38:	48 89 c7             	mov    %rax,%rdi
  800c3b:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  800c42:	00 00 00 
  800c45:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c47:	90                   	nop
  800c48:	c9                   	leaveq 
  800c49:	c3                   	retq   

0000000000800c4a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4a:	55                   	push   %rbp
  800c4b:	48 89 e5             	mov    %rsp,%rbp
  800c4e:	48 83 ec 10          	sub    $0x10,%rsp
  800c52:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5d:	8b 40 10             	mov    0x10(%rax),%eax
  800c60:	8d 50 01             	lea    0x1(%rax),%edx
  800c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c67:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6e:	48 8b 10             	mov    (%rax),%rdx
  800c71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c75:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c79:	48 39 c2             	cmp    %rax,%rdx
  800c7c:	73 17                	jae    800c95 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c82:	48 8b 00             	mov    (%rax),%rax
  800c85:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c8d:	48 89 0a             	mov    %rcx,(%rdx)
  800c90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c93:	88 10                	mov    %dl,(%rax)
}
  800c95:	90                   	nop
  800c96:	c9                   	leaveq 
  800c97:	c3                   	retq   

0000000000800c98 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c98:	55                   	push   %rbp
  800c99:	48 89 e5             	mov    %rsp,%rbp
  800c9c:	48 83 ec 50          	sub    $0x50,%rsp
  800ca0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ca4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ca7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cab:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800caf:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cb3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cb7:	48 8b 0a             	mov    (%rdx),%rcx
  800cba:	48 89 08             	mov    %rcx,(%rax)
  800cbd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cc1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cc5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cc9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cd1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cd5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cd8:	48 98                	cltq   
  800cda:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cde:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce2:	48 01 d0             	add    %rdx,%rax
  800ce5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ce9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cf0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cf5:	74 06                	je     800cfd <vsnprintf+0x65>
  800cf7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cfb:	7f 07                	jg     800d04 <vsnprintf+0x6c>
		return -E_INVAL;
  800cfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d02:	eb 2f                	jmp    800d33 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d04:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d08:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d0c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d10:	48 89 c6             	mov    %rax,%rsi
  800d13:	48 bf 4a 0c 80 00 00 	movabs $0x800c4a,%rdi
  800d1a:	00 00 00 
  800d1d:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  800d24:	00 00 00 
  800d27:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d2d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d30:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d33:	c9                   	leaveq 
  800d34:	c3                   	retq   

0000000000800d35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d35:	55                   	push   %rbp
  800d36:	48 89 e5             	mov    %rsp,%rbp
  800d39:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d40:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d47:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d4d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d54:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d62:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d69:	84 c0                	test   %al,%al
  800d6b:	74 20                	je     800d8d <snprintf+0x58>
  800d6d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d71:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d75:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d79:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d81:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d85:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d89:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d8d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d94:	00 00 00 
  800d97:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d9e:	00 00 00 
  800da1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dba:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dc1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dc8:	48 8b 0a             	mov    (%rdx),%rcx
  800dcb:	48 89 08             	mov    %rcx,(%rax)
  800dce:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dd2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dd6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dda:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dde:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800de5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dec:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800df2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800df9:	48 89 c7             	mov    %rax,%rdi
  800dfc:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  800e03:	00 00 00 
  800e06:	ff d0                	callq  *%rax
  800e08:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e0e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e14:	c9                   	leaveq 
  800e15:	c3                   	retq   

0000000000800e16 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800e16:	55                   	push   %rbp
  800e17:	48 89 e5             	mov    %rsp,%rbp
  800e1a:	48 83 ec 20          	sub    $0x20,%rsp
  800e1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800e22:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800e27:	74 27                	je     800e50 <readline+0x3a>
		fprintf(1, "%s", prompt);
  800e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2d:	48 89 c2             	mov    %rax,%rdx
  800e30:	48 be 88 4a 80 00 00 	movabs $0x804a88,%rsi
  800e37:	00 00 00 
  800e3a:	bf 01 00 00 00       	mov    $0x1,%edi
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	48 b9 d9 2f 80 00 00 	movabs $0x802fd9,%rcx
  800e4b:	00 00 00 
  800e4e:	ff d1                	callq  *%rcx
#endif


	i = 0;
  800e50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  800e57:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5c:	48 b8 85 3f 80 00 00 	movabs $0x803f85,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
  800e68:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  800e6b:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  800e72:	00 00 00 
  800e75:	ff d0                	callq  *%rax
  800e77:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  800e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e7e:	79 30                	jns    800eb0 <readline+0x9a>

			if (c != -E_EOF)
  800e80:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  800e84:	74 20                	je     800ea6 <readline+0x90>
				cprintf("read error: %e\n", c);
  800e86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e89:	89 c6                	mov    %eax,%esi
  800e8b:	48 bf 8b 4a 80 00 00 	movabs $0x804a8b,%rdi
  800e92:	00 00 00 
  800e95:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9a:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  800ea1:	00 00 00 
  800ea4:	ff d2                	callq  *%rdx

			return NULL;
  800ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eab:	e9 c2 00 00 00       	jmpq   800f72 <readline+0x15c>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800eb0:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  800eb4:	74 06                	je     800ebc <readline+0xa6>
  800eb6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  800eba:	75 26                	jne    800ee2 <readline+0xcc>
  800ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ec0:	7e 20                	jle    800ee2 <readline+0xcc>
			if (echoing)
  800ec2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ec6:	74 11                	je     800ed9 <readline+0xc3>
				cputchar('\b');
  800ec8:	bf 08 00 00 00       	mov    $0x8,%edi
  800ecd:	48 b8 10 3f 80 00 00 	movabs $0x803f10,%rax
  800ed4:	00 00 00 
  800ed7:	ff d0                	callq  *%rax
			i--;
  800ed9:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800edd:	e9 8b 00 00 00       	jmpq   800f6d <readline+0x157>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ee2:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  800ee6:	7e 3f                	jle    800f27 <readline+0x111>
  800ee8:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  800eef:	7f 36                	jg     800f27 <readline+0x111>
			if (echoing)
  800ef1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ef5:	74 11                	je     800f08 <readline+0xf2>
				cputchar(c);
  800ef7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800efa:	89 c7                	mov    %eax,%edi
  800efc:	48 b8 10 3f 80 00 00 	movabs $0x803f10,%rax
  800f03:	00 00 00 
  800f06:	ff d0                	callq  *%rax
			buf[i++] = c;
  800f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f0b:	8d 50 01             	lea    0x1(%rax),%edx
  800f0e:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800f11:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800f14:	89 d1                	mov    %edx,%ecx
  800f16:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f1d:	00 00 00 
  800f20:	48 98                	cltq   
  800f22:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  800f25:	eb 46                	jmp    800f6d <readline+0x157>
		} else if (c == '\n' || c == '\r') {
  800f27:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  800f2b:	74 0a                	je     800f37 <readline+0x121>
  800f2d:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  800f31:	0f 85 34 ff ff ff    	jne    800e6b <readline+0x55>
			if (echoing)
  800f37:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800f3b:	74 11                	je     800f4e <readline+0x138>
				cputchar('\n');
  800f3d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f42:	48 b8 10 3f 80 00 00 	movabs $0x803f10,%rax
  800f49:	00 00 00 
  800f4c:	ff d0                	callq  *%rax
			buf[i] = 0;
  800f4e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f55:	00 00 00 
  800f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f5b:	48 98                	cltq   
  800f5d:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  800f61:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800f68:	00 00 00 
  800f6b:	eb 05                	jmp    800f72 <readline+0x15c>
		}
	}
  800f6d:	e9 f9 fe ff ff       	jmpq   800e6b <readline+0x55>
}
  800f72:	c9                   	leaveq 
  800f73:	c3                   	retq   

0000000000800f74 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f74:	55                   	push   %rbp
  800f75:	48 89 e5             	mov    %rsp,%rbp
  800f78:	48 83 ec 18          	sub    $0x18,%rsp
  800f7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f87:	eb 09                	jmp    800f92 <strlen+0x1e>
		n++;
  800f89:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f8d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f96:	0f b6 00             	movzbl (%rax),%eax
  800f99:	84 c0                	test   %al,%al
  800f9b:	75 ec                	jne    800f89 <strlen+0x15>
		n++;
	return n;
  800f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fa0:	c9                   	leaveq 
  800fa1:	c3                   	retq   

0000000000800fa2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fa2:	55                   	push   %rbp
  800fa3:	48 89 e5             	mov    %rsp,%rbp
  800fa6:	48 83 ec 20          	sub    $0x20,%rsp
  800faa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fb9:	eb 0e                	jmp    800fc9 <strnlen+0x27>
		n++;
  800fbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fbf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fc4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fc9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fce:	74 0b                	je     800fdb <strnlen+0x39>
  800fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd4:	0f b6 00             	movzbl (%rax),%eax
  800fd7:	84 c0                	test   %al,%al
  800fd9:	75 e0                	jne    800fbb <strnlen+0x19>
		n++;
	return n;
  800fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fde:	c9                   	leaveq 
  800fdf:	c3                   	retq   

0000000000800fe0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fe0:	55                   	push   %rbp
  800fe1:	48 89 e5             	mov    %rsp,%rbp
  800fe4:	48 83 ec 20          	sub    $0x20,%rsp
  800fe8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ff8:	90                   	nop
  800ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801001:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801005:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801009:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80100d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801011:	0f b6 12             	movzbl (%rdx),%edx
  801014:	88 10                	mov    %dl,(%rax)
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	84 c0                	test   %al,%al
  80101b:	75 dc                	jne    800ff9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80101d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801021:	c9                   	leaveq 
  801022:	c3                   	retq   

0000000000801023 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	48 83 ec 20          	sub    $0x20,%rsp
  80102b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801037:	48 89 c7             	mov    %rax,%rdi
  80103a:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80104c:	48 63 d0             	movslq %eax,%rdx
  80104f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801053:	48 01 c2             	add    %rax,%rdx
  801056:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80105a:	48 89 c6             	mov    %rax,%rsi
  80105d:	48 89 d7             	mov    %rdx,%rdi
  801060:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  801067:	00 00 00 
  80106a:	ff d0                	callq  *%rax
	return dst;
  80106c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   

0000000000801072 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801072:	55                   	push   %rbp
  801073:	48 89 e5             	mov    %rsp,%rbp
  801076:	48 83 ec 28          	sub    $0x28,%rsp
  80107a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801082:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80108e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801095:	00 
  801096:	eb 2a                	jmp    8010c2 <strncpy+0x50>
		*dst++ = *src;
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a8:	0f b6 12             	movzbl (%rdx),%edx
  8010ab:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010b1:	0f b6 00             	movzbl (%rax),%eax
  8010b4:	84 c0                	test   %al,%al
  8010b6:	74 05                	je     8010bd <strncpy+0x4b>
			src++;
  8010b8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010ca:	72 cc                	jb     801098 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010d0:	c9                   	leaveq 
  8010d1:	c3                   	retq   

00000000008010d2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010d2:	55                   	push   %rbp
  8010d3:	48 89 e5             	mov    %rsp,%rbp
  8010d6:	48 83 ec 28          	sub    $0x28,%rsp
  8010da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010f3:	74 3d                	je     801132 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010f5:	eb 1d                	jmp    801114 <strlcpy+0x42>
			*dst++ = *src++;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801103:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801107:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80110b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80110f:	0f b6 12             	movzbl (%rdx),%edx
  801112:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801114:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801119:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80111e:	74 0b                	je     80112b <strlcpy+0x59>
  801120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801124:	0f b6 00             	movzbl (%rax),%eax
  801127:	84 c0                	test   %al,%al
  801129:	75 cc                	jne    8010f7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80112b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801132:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113a:	48 29 c2             	sub    %rax,%rdx
  80113d:	48 89 d0             	mov    %rdx,%rax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 10          	sub    $0x10,%rsp
  80114a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801152:	eb 0a                	jmp    80115e <strcmp+0x1c>
		p++, q++;
  801154:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801159:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80115e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801162:	0f b6 00             	movzbl (%rax),%eax
  801165:	84 c0                	test   %al,%al
  801167:	74 12                	je     80117b <strcmp+0x39>
  801169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116d:	0f b6 10             	movzbl (%rax),%edx
  801170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801174:	0f b6 00             	movzbl (%rax),%eax
  801177:	38 c2                	cmp    %al,%dl
  801179:	74 d9                	je     801154 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	0f b6 00             	movzbl (%rax),%eax
  801182:	0f b6 d0             	movzbl %al,%edx
  801185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801189:	0f b6 00             	movzbl (%rax),%eax
  80118c:	0f b6 c0             	movzbl %al,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
}
  801193:	c9                   	leaveq 
  801194:	c3                   	retq   

0000000000801195 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801195:	55                   	push   %rbp
  801196:	48 89 e5             	mov    %rsp,%rbp
  801199:	48 83 ec 18          	sub    $0x18,%rsp
  80119d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011a9:	eb 0f                	jmp    8011ba <strncmp+0x25>
		n--, p++, q++;
  8011ab:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011bf:	74 1d                	je     8011de <strncmp+0x49>
  8011c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c5:	0f b6 00             	movzbl (%rax),%eax
  8011c8:	84 c0                	test   %al,%al
  8011ca:	74 12                	je     8011de <strncmp+0x49>
  8011cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d0:	0f b6 10             	movzbl (%rax),%edx
  8011d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	38 c2                	cmp    %al,%dl
  8011dc:	74 cd                	je     8011ab <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011e3:	75 07                	jne    8011ec <strncmp+0x57>
		return 0;
  8011e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ea:	eb 18                	jmp    801204 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	0f b6 d0             	movzbl %al,%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 10          	sub    $0x10,%rsp
  80120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801212:	89 f0                	mov    %esi,%eax
  801214:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801217:	eb 17                	jmp    801230 <strchr+0x2a>
		if (*s == c)
  801219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121d:	0f b6 00             	movzbl (%rax),%eax
  801220:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801223:	75 06                	jne    80122b <strchr+0x25>
			return (char *) s;
  801225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801229:	eb 15                	jmp    801240 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80122b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801234:	0f b6 00             	movzbl (%rax),%eax
  801237:	84 c0                	test   %al,%al
  801239:	75 de                	jne    801219 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801240:	c9                   	leaveq 
  801241:	c3                   	retq   

0000000000801242 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801242:	55                   	push   %rbp
  801243:	48 89 e5             	mov    %rsp,%rbp
  801246:	48 83 ec 10          	sub    $0x10,%rsp
  80124a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124e:	89 f0                	mov    %esi,%eax
  801250:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801253:	eb 11                	jmp    801266 <strfind+0x24>
		if (*s == c)
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80125f:	74 12                	je     801273 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801261:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	0f b6 00             	movzbl (%rax),%eax
  80126d:	84 c0                	test   %al,%al
  80126f:	75 e4                	jne    801255 <strfind+0x13>
  801271:	eb 01                	jmp    801274 <strfind+0x32>
		if (*s == c)
			break;
  801273:	90                   	nop
	return (char *) s;
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801278:	c9                   	leaveq 
  801279:	c3                   	retq   

000000000080127a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80127a:	55                   	push   %rbp
  80127b:	48 89 e5             	mov    %rsp,%rbp
  80127e:	48 83 ec 18          	sub    $0x18,%rsp
  801282:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801286:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801289:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80128d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801292:	75 06                	jne    80129a <memset+0x20>
		return v;
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	eb 69                	jmp    801303 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	83 e0 03             	and    $0x3,%eax
  8012a1:	48 85 c0             	test   %rax,%rax
  8012a4:	75 48                	jne    8012ee <memset+0x74>
  8012a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012aa:	83 e0 03             	and    $0x3,%eax
  8012ad:	48 85 c0             	test   %rax,%rax
  8012b0:	75 3c                	jne    8012ee <memset+0x74>
		c &= 0xFF;
  8012b2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012bc:	c1 e0 18             	shl    $0x18,%eax
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012c4:	c1 e0 10             	shl    $0x10,%eax
  8012c7:	09 c2                	or     %eax,%edx
  8012c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012cc:	c1 e0 08             	shl    $0x8,%eax
  8012cf:	09 d0                	or     %edx,%eax
  8012d1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d8:	48 c1 e8 02          	shr    $0x2,%rax
  8012dc:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e6:	48 89 d7             	mov    %rdx,%rdi
  8012e9:	fc                   	cld    
  8012ea:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012ec:	eb 11                	jmp    8012ff <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012f9:	48 89 d7             	mov    %rdx,%rdi
  8012fc:	fc                   	cld    
  8012fd:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801303:	c9                   	leaveq 
  801304:	c3                   	retq   

0000000000801305 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801305:	55                   	push   %rbp
  801306:	48 89 e5             	mov    %rsp,%rbp
  801309:	48 83 ec 28          	sub    $0x28,%rsp
  80130d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801311:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801315:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801331:	0f 83 88 00 00 00    	jae    8013bf <memmove+0xba>
  801337:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133f:	48 01 d0             	add    %rdx,%rax
  801342:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801346:	76 77                	jbe    8013bf <memmove+0xba>
		s += n;
  801348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801354:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135c:	83 e0 03             	and    $0x3,%eax
  80135f:	48 85 c0             	test   %rax,%rax
  801362:	75 3b                	jne    80139f <memmove+0x9a>
  801364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801368:	83 e0 03             	and    $0x3,%eax
  80136b:	48 85 c0             	test   %rax,%rax
  80136e:	75 2f                	jne    80139f <memmove+0x9a>
  801370:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801374:	83 e0 03             	and    $0x3,%eax
  801377:	48 85 c0             	test   %rax,%rax
  80137a:	75 23                	jne    80139f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80137c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801380:	48 83 e8 04          	sub    $0x4,%rax
  801384:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801388:	48 83 ea 04          	sub    $0x4,%rdx
  80138c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801390:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801394:	48 89 c7             	mov    %rax,%rdi
  801397:	48 89 d6             	mov    %rdx,%rsi
  80139a:	fd                   	std    
  80139b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80139d:	eb 1d                	jmp    8013bc <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80139f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ab:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b3:	48 89 d7             	mov    %rdx,%rdi
  8013b6:	48 89 c1             	mov    %rax,%rcx
  8013b9:	fd                   	std    
  8013ba:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013bc:	fc                   	cld    
  8013bd:	eb 57                	jmp    801416 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	83 e0 03             	and    $0x3,%eax
  8013c6:	48 85 c0             	test   %rax,%rax
  8013c9:	75 36                	jne    801401 <memmove+0xfc>
  8013cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cf:	83 e0 03             	and    $0x3,%eax
  8013d2:	48 85 c0             	test   %rax,%rax
  8013d5:	75 2a                	jne    801401 <memmove+0xfc>
  8013d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013db:	83 e0 03             	and    $0x3,%eax
  8013de:	48 85 c0             	test   %rax,%rax
  8013e1:	75 1e                	jne    801401 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e7:	48 c1 e8 02          	shr    $0x2,%rax
  8013eb:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f6:	48 89 c7             	mov    %rax,%rdi
  8013f9:	48 89 d6             	mov    %rdx,%rsi
  8013fc:	fc                   	cld    
  8013fd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013ff:	eb 15                	jmp    801416 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801405:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801409:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80140d:	48 89 c7             	mov    %rax,%rdi
  801410:	48 89 d6             	mov    %rdx,%rsi
  801413:	fc                   	cld    
  801414:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80141a:	c9                   	leaveq 
  80141b:	c3                   	retq   

000000000080141c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80141c:	55                   	push   %rbp
  80141d:	48 89 e5             	mov    %rsp,%rbp
  801420:	48 83 ec 18          	sub    $0x18,%rsp
  801424:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801428:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80142c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801430:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801434:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143c:	48 89 ce             	mov    %rcx,%rsi
  80143f:	48 89 c7             	mov    %rax,%rdi
  801442:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  801449:	00 00 00 
  80144c:	ff d0                	callq  *%rax
}
  80144e:	c9                   	leaveq 
  80144f:	c3                   	retq   

0000000000801450 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801450:	55                   	push   %rbp
  801451:	48 89 e5             	mov    %rsp,%rbp
  801454:	48 83 ec 28          	sub    $0x28,%rsp
  801458:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80145c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801460:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80146c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801470:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801474:	eb 36                	jmp    8014ac <memcmp+0x5c>
		if (*s1 != *s2)
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	0f b6 10             	movzbl (%rax),%edx
  80147d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	38 c2                	cmp    %al,%dl
  801486:	74 1a                	je     8014a2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	0f b6 d0             	movzbl %al,%edx
  801492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	0f b6 c0             	movzbl %al,%eax
  80149c:	29 c2                	sub    %eax,%edx
  80149e:	89 d0                	mov    %edx,%eax
  8014a0:	eb 20                	jmp    8014c2 <memcmp+0x72>
		s1++, s2++;
  8014a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014b8:	48 85 c0             	test   %rax,%rax
  8014bb:	75 b9                	jne    801476 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c2:	c9                   	leaveq 
  8014c3:	c3                   	retq   

00000000008014c4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014c4:	55                   	push   %rbp
  8014c5:	48 89 e5             	mov    %rsp,%rbp
  8014c8:	48 83 ec 28          	sub    $0x28,%rsp
  8014cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	48 01 d0             	add    %rdx,%rax
  8014e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014e6:	eb 19                	jmp    801501 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	0f b6 d0             	movzbl %al,%edx
  8014f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014f5:	0f b6 c0             	movzbl %al,%eax
  8014f8:	39 c2                	cmp    %eax,%edx
  8014fa:	74 11                	je     80150d <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801505:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801509:	72 dd                	jb     8014e8 <memfind+0x24>
  80150b:	eb 01                	jmp    80150e <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80150d:	90                   	nop
	return (void *) s;
  80150e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801512:	c9                   	leaveq 
  801513:	c3                   	retq   

0000000000801514 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801514:	55                   	push   %rbp
  801515:	48 89 e5             	mov    %rsp,%rbp
  801518:	48 83 ec 38          	sub    $0x38,%rsp
  80151c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801520:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801524:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801527:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80152e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801535:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801536:	eb 05                	jmp    80153d <strtol+0x29>
		s++;
  801538:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80153d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801541:	0f b6 00             	movzbl (%rax),%eax
  801544:	3c 20                	cmp    $0x20,%al
  801546:	74 f0                	je     801538 <strtol+0x24>
  801548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	3c 09                	cmp    $0x9,%al
  801551:	74 e5                	je     801538 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	0f b6 00             	movzbl (%rax),%eax
  80155a:	3c 2b                	cmp    $0x2b,%al
  80155c:	75 07                	jne    801565 <strtol+0x51>
		s++;
  80155e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801563:	eb 17                	jmp    80157c <strtol+0x68>
	else if (*s == '-')
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	0f b6 00             	movzbl (%rax),%eax
  80156c:	3c 2d                	cmp    $0x2d,%al
  80156e:	75 0c                	jne    80157c <strtol+0x68>
		s++, neg = 1;
  801570:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801575:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80157c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801580:	74 06                	je     801588 <strtol+0x74>
  801582:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801586:	75 28                	jne    8015b0 <strtol+0x9c>
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	0f b6 00             	movzbl (%rax),%eax
  80158f:	3c 30                	cmp    $0x30,%al
  801591:	75 1d                	jne    8015b0 <strtol+0x9c>
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 83 c0 01          	add    $0x1,%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	3c 78                	cmp    $0x78,%al
  8015a0:	75 0e                	jne    8015b0 <strtol+0x9c>
		s += 2, base = 16;
  8015a2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015a7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015ae:	eb 2c                	jmp    8015dc <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015b4:	75 19                	jne    8015cf <strtol+0xbb>
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	3c 30                	cmp    $0x30,%al
  8015bf:	75 0e                	jne    8015cf <strtol+0xbb>
		s++, base = 8;
  8015c1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015cd:	eb 0d                	jmp    8015dc <strtol+0xc8>
	else if (base == 0)
  8015cf:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015d3:	75 07                	jne    8015dc <strtol+0xc8>
		base = 10;
  8015d5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	3c 2f                	cmp    $0x2f,%al
  8015e5:	7e 1d                	jle    801604 <strtol+0xf0>
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	3c 39                	cmp    $0x39,%al
  8015f0:	7f 12                	jg     801604 <strtol+0xf0>
			dig = *s - '0';
  8015f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f6:	0f b6 00             	movzbl (%rax),%eax
  8015f9:	0f be c0             	movsbl %al,%eax
  8015fc:	83 e8 30             	sub    $0x30,%eax
  8015ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801602:	eb 4e                	jmp    801652 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 60                	cmp    $0x60,%al
  80160d:	7e 1d                	jle    80162c <strtol+0x118>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 7a                	cmp    $0x7a,%al
  801618:	7f 12                	jg     80162c <strtol+0x118>
			dig = *s - 'a' + 10;
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	0f be c0             	movsbl %al,%eax
  801624:	83 e8 57             	sub    $0x57,%eax
  801627:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80162a:	eb 26                	jmp    801652 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	3c 40                	cmp    $0x40,%al
  801635:	7e 47                	jle    80167e <strtol+0x16a>
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	0f b6 00             	movzbl (%rax),%eax
  80163e:	3c 5a                	cmp    $0x5a,%al
  801640:	7f 3c                	jg     80167e <strtol+0x16a>
			dig = *s - 'A' + 10;
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	0f be c0             	movsbl %al,%eax
  80164c:	83 e8 37             	sub    $0x37,%eax
  80164f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801652:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801655:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801658:	7d 23                	jge    80167d <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80165a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80165f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801662:	48 98                	cltq   
  801664:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801669:	48 89 c2             	mov    %rax,%rdx
  80166c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80166f:	48 98                	cltq   
  801671:	48 01 d0             	add    %rdx,%rax
  801674:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801678:	e9 5f ff ff ff       	jmpq   8015dc <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80167d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80167e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801683:	74 0b                	je     801690 <strtol+0x17c>
		*endptr = (char *) s;
  801685:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801689:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80168d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801690:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801694:	74 09                	je     80169f <strtol+0x18b>
  801696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169a:	48 f7 d8             	neg    %rax
  80169d:	eb 04                	jmp    8016a3 <strtol+0x18f>
  80169f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016a3:	c9                   	leaveq 
  8016a4:	c3                   	retq   

00000000008016a5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016a5:	55                   	push   %rbp
  8016a6:	48 89 e5             	mov    %rsp,%rbp
  8016a9:	48 83 ec 30          	sub    $0x30,%rsp
  8016ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016bd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016c1:	0f b6 00             	movzbl (%rax),%eax
  8016c4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016c7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016cb:	75 06                	jne    8016d3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	eb 6b                	jmp    80173e <strstr+0x99>

	len = strlen(str);
  8016d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d7:	48 89 c7             	mov    %rax,%rdi
  8016da:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  8016e1:	00 00 00 
  8016e4:	ff d0                	callq  *%rax
  8016e6:	48 98                	cltq   
  8016e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016f8:	0f b6 00             	movzbl (%rax),%eax
  8016fb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8016fe:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801702:	75 07                	jne    80170b <strstr+0x66>
				return (char *) 0;
  801704:	b8 00 00 00 00       	mov    $0x0,%eax
  801709:	eb 33                	jmp    80173e <strstr+0x99>
		} while (sc != c);
  80170b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80170f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801712:	75 d8                	jne    8016ec <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801714:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801718:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	48 89 ce             	mov    %rcx,%rsi
  801723:	48 89 c7             	mov    %rax,%rdi
  801726:	48 b8 95 11 80 00 00 	movabs $0x801195,%rax
  80172d:	00 00 00 
  801730:	ff d0                	callq  *%rax
  801732:	85 c0                	test   %eax,%eax
  801734:	75 b6                	jne    8016ec <strstr+0x47>

	return (char *) (in - 1);
  801736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173a:	48 83 e8 01          	sub    $0x1,%rax
}
  80173e:	c9                   	leaveq 
  80173f:	c3                   	retq   

0000000000801740 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801740:	55                   	push   %rbp
  801741:	48 89 e5             	mov    %rsp,%rbp
  801744:	53                   	push   %rbx
  801745:	48 83 ec 48          	sub    $0x48,%rsp
  801749:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80174c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80174f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801753:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801757:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80175b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80175f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801762:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801766:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80176a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80176e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801772:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801776:	4c 89 c3             	mov    %r8,%rbx
  801779:	cd 30                	int    $0x30
  80177b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80177f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801783:	74 3e                	je     8017c3 <syscall+0x83>
  801785:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80178a:	7e 37                	jle    8017c3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80178c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801790:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801793:	49 89 d0             	mov    %rdx,%r8
  801796:	89 c1                	mov    %eax,%ecx
  801798:	48 ba 9b 4a 80 00 00 	movabs $0x804a9b,%rdx
  80179f:	00 00 00 
  8017a2:	be 24 00 00 00       	mov    $0x24,%esi
  8017a7:	48 bf b8 4a 80 00 00 	movabs $0x804ab8,%rdi
  8017ae:	00 00 00 
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b6:	49 b9 c2 41 80 00 00 	movabs $0x8041c2,%r9
  8017bd:	00 00 00 
  8017c0:	41 ff d1             	callq  *%r9

	return ret;
  8017c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017c7:	48 83 c4 48          	add    $0x48,%rsp
  8017cb:	5b                   	pop    %rbx
  8017cc:	5d                   	pop    %rbp
  8017cd:	c3                   	retq   

00000000008017ce <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017ce:	55                   	push   %rbp
  8017cf:	48 89 e5             	mov    %rsp,%rbp
  8017d2:	48 83 ec 10          	sub    $0x10,%rsp
  8017d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e6:	48 83 ec 08          	sub    $0x8,%rsp
  8017ea:	6a 00                	pushq  $0x0
  8017ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f8:	48 89 d1             	mov    %rdx,%rcx
  8017fb:	48 89 c2             	mov    %rax,%rdx
  8017fe:	be 00 00 00 00       	mov    $0x0,%esi
  801803:	bf 00 00 00 00       	mov    $0x0,%edi
  801808:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  80180f:	00 00 00 
  801812:	ff d0                	callq  *%rax
  801814:	48 83 c4 10          	add    $0x10,%rsp
}
  801818:	90                   	nop
  801819:	c9                   	leaveq 
  80181a:	c3                   	retq   

000000000080181b <sys_cgetc>:

int
sys_cgetc(void)
{
  80181b:	55                   	push   %rbp
  80181c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80181f:	48 83 ec 08          	sub    $0x8,%rsp
  801823:	6a 00                	pushq  $0x0
  801825:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801831:	b9 00 00 00 00       	mov    $0x0,%ecx
  801836:	ba 00 00 00 00       	mov    $0x0,%edx
  80183b:	be 00 00 00 00       	mov    $0x0,%esi
  801840:	bf 01 00 00 00       	mov    $0x1,%edi
  801845:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	callq  *%rax
  801851:	48 83 c4 10          	add    $0x10,%rsp
}
  801855:	c9                   	leaveq 
  801856:	c3                   	retq   

0000000000801857 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801857:	55                   	push   %rbp
  801858:	48 89 e5             	mov    %rsp,%rbp
  80185b:	48 83 ec 10          	sub    $0x10,%rsp
  80185f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801862:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801865:	48 98                	cltq   
  801867:	48 83 ec 08          	sub    $0x8,%rsp
  80186b:	6a 00                	pushq  $0x0
  80186d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801873:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801879:	b9 00 00 00 00       	mov    $0x0,%ecx
  80187e:	48 89 c2             	mov    %rax,%rdx
  801881:	be 01 00 00 00       	mov    $0x1,%esi
  801886:	bf 03 00 00 00       	mov    $0x3,%edi
  80188b:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801892:	00 00 00 
  801895:	ff d0                	callq  *%rax
  801897:	48 83 c4 10          	add    $0x10,%rsp
}
  80189b:	c9                   	leaveq 
  80189c:	c3                   	retq   

000000000080189d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018a1:	48 83 ec 08          	sub    $0x8,%rsp
  8018a5:	6a 00                	pushq  $0x0
  8018a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bd:	be 00 00 00 00       	mov    $0x0,%esi
  8018c2:	bf 02 00 00 00       	mov    $0x2,%edi
  8018c7:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
  8018d3:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <sys_yield>:


void
sys_yield(void)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018dd:	48 83 ec 08          	sub    $0x8,%rsp
  8018e1:	6a 00                	pushq  $0x0
  8018e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	be 00 00 00 00       	mov    $0x0,%esi
  8018fe:	bf 0b 00 00 00       	mov    $0xb,%edi
  801903:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
  80190f:	48 83 c4 10          	add    $0x10,%rsp
}
  801913:	90                   	nop
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 10          	sub    $0x10,%rsp
  80191e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801921:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801925:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801928:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80192b:	48 63 c8             	movslq %eax,%rcx
  80192e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801935:	48 98                	cltq   
  801937:	48 83 ec 08          	sub    $0x8,%rsp
  80193b:	6a 00                	pushq  $0x0
  80193d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801943:	49 89 c8             	mov    %rcx,%r8
  801946:	48 89 d1             	mov    %rdx,%rcx
  801949:	48 89 c2             	mov    %rax,%rdx
  80194c:	be 01 00 00 00       	mov    $0x1,%esi
  801951:	bf 04 00 00 00       	mov    $0x4,%edi
  801956:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
  801962:	48 83 c4 10          	add    $0x10,%rsp
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 20          	sub    $0x20,%rsp
  801970:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801973:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801977:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80197a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80197e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801982:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801985:	48 63 c8             	movslq %eax,%rcx
  801988:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80198c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80198f:	48 63 f0             	movslq %eax,%rsi
  801992:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801996:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801999:	48 98                	cltq   
  80199b:	48 83 ec 08          	sub    $0x8,%rsp
  80199f:	51                   	push   %rcx
  8019a0:	49 89 f9             	mov    %rdi,%r9
  8019a3:	49 89 f0             	mov    %rsi,%r8
  8019a6:	48 89 d1             	mov    %rdx,%rcx
  8019a9:	48 89 c2             	mov    %rax,%rdx
  8019ac:	be 01 00 00 00       	mov    $0x1,%esi
  8019b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8019b6:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
  8019c2:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c6:	c9                   	leaveq 
  8019c7:	c3                   	retq   

00000000008019c8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	48 83 ec 10          	sub    $0x10,%rsp
  8019d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019de:	48 98                	cltq   
  8019e0:	48 83 ec 08          	sub    $0x8,%rsp
  8019e4:	6a 00                	pushq  $0x0
  8019e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f2:	48 89 d1             	mov    %rdx,%rcx
  8019f5:	48 89 c2             	mov    %rax,%rdx
  8019f8:	be 01 00 00 00       	mov    $0x1,%esi
  8019fd:	bf 06 00 00 00       	mov    $0x6,%edi
  801a02:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801a09:	00 00 00 
  801a0c:	ff d0                	callq  *%rax
  801a0e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a12:	c9                   	leaveq 
  801a13:	c3                   	retq   

0000000000801a14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a14:	55                   	push   %rbp
  801a15:	48 89 e5             	mov    %rsp,%rbp
  801a18:	48 83 ec 10          	sub    $0x10,%rsp
  801a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a25:	48 63 d0             	movslq %eax,%rdx
  801a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2b:	48 98                	cltq   
  801a2d:	48 83 ec 08          	sub    $0x8,%rsp
  801a31:	6a 00                	pushq  $0x0
  801a33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3f:	48 89 d1             	mov    %rdx,%rcx
  801a42:	48 89 c2             	mov    %rax,%rdx
  801a45:	be 01 00 00 00       	mov    $0x1,%esi
  801a4a:	bf 08 00 00 00       	mov    $0x8,%edi
  801a4f:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
  801a5b:	48 83 c4 10          	add    $0x10,%rsp
}
  801a5f:	c9                   	leaveq 
  801a60:	c3                   	retq   

0000000000801a61 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a61:	55                   	push   %rbp
  801a62:	48 89 e5             	mov    %rsp,%rbp
  801a65:	48 83 ec 10          	sub    $0x10,%rsp
  801a69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 83 ec 08          	sub    $0x8,%rsp
  801a7d:	6a 00                	pushq  $0x0
  801a7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8b:	48 89 d1             	mov    %rdx,%rcx
  801a8e:	48 89 c2             	mov    %rax,%rdx
  801a91:	be 01 00 00 00       	mov    $0x1,%esi
  801a96:	bf 09 00 00 00       	mov    $0x9,%edi
  801a9b:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801aa2:	00 00 00 
  801aa5:	ff d0                	callq  *%rax
  801aa7:	48 83 c4 10          	add    $0x10,%rsp
}
  801aab:	c9                   	leaveq 
  801aac:	c3                   	retq   

0000000000801aad <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aad:	55                   	push   %rbp
  801aae:	48 89 e5             	mov    %rsp,%rbp
  801ab1:	48 83 ec 10          	sub    $0x10,%rsp
  801ab5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801abc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac3:	48 98                	cltq   
  801ac5:	48 83 ec 08          	sub    $0x8,%rsp
  801ac9:	6a 00                	pushq  $0x0
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ae7:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
  801af3:	48 83 c4 10          	add    $0x10,%rsp
}
  801af7:	c9                   	leaveq 
  801af8:	c3                   	retq   

0000000000801af9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801af9:	55                   	push   %rbp
  801afa:	48 89 e5             	mov    %rsp,%rbp
  801afd:	48 83 ec 20          	sub    $0x20,%rsp
  801b01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b08:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b0c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b12:	48 63 f0             	movslq %eax,%rsi
  801b15:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1c:	48 98                	cltq   
  801b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b22:	48 83 ec 08          	sub    $0x8,%rsp
  801b26:	6a 00                	pushq  $0x0
  801b28:	49 89 f1             	mov    %rsi,%r9
  801b2b:	49 89 c8             	mov    %rcx,%r8
  801b2e:	48 89 d1             	mov    %rdx,%rcx
  801b31:	48 89 c2             	mov    %rax,%rdx
  801b34:	be 00 00 00 00       	mov    $0x0,%esi
  801b39:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b3e:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
  801b4a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b4e:	c9                   	leaveq 
  801b4f:	c3                   	retq   

0000000000801b50 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b50:	55                   	push   %rbp
  801b51:	48 89 e5             	mov    %rsp,%rbp
  801b54:	48 83 ec 10          	sub    $0x10,%rsp
  801b58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b60:	48 83 ec 08          	sub    $0x8,%rsp
  801b64:	6a 00                	pushq  $0x0
  801b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b72:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b77:	48 89 c2             	mov    %rax,%rdx
  801b7a:	be 01 00 00 00       	mov    $0x1,%esi
  801b7f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b84:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801b8b:	00 00 00 
  801b8e:	ff d0                	callq  *%rax
  801b90:	48 83 c4 10          	add    $0x10,%rsp
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b9a:	48 83 ec 08          	sub    $0x8,%rsp
  801b9e:	6a 00                	pushq  $0x0
  801ba0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb6:	be 00 00 00 00       	mov    $0x0,%esi
  801bbb:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bc0:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	48 83 c4 10          	add    $0x10,%rsp
}
  801bd0:	c9                   	leaveq 
  801bd1:	c3                   	retq   

0000000000801bd2 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	48 83 ec 10          	sub    $0x10,%rsp
  801bda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bde:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801be1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be8:	48 83 ec 08          	sub    $0x8,%rsp
  801bec:	6a 00                	pushq  $0x0
  801bee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfa:	48 89 d1             	mov    %rdx,%rcx
  801bfd:	48 89 c2             	mov    %rax,%rdx
  801c00:	be 00 00 00 00       	mov    $0x0,%esi
  801c05:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c0a:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	callq  *%rax
  801c16:	48 83 c4 10          	add    $0x10,%rsp
}
  801c1a:	c9                   	leaveq 
  801c1b:	c3                   	retq   

0000000000801c1c <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	48 83 ec 10          	sub    $0x10,%rsp
  801c24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c28:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801c2b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c32:	48 83 ec 08          	sub    $0x8,%rsp
  801c36:	6a 00                	pushq  $0x0
  801c38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c44:	48 89 d1             	mov    %rdx,%rcx
  801c47:	48 89 c2             	mov    %rax,%rdx
  801c4a:	be 00 00 00 00       	mov    $0x0,%esi
  801c4f:	bf 10 00 00 00       	mov    $0x10,%edi
  801c54:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801c5b:	00 00 00 
  801c5e:	ff d0                	callq  *%rax
  801c60:	48 83 c4 10          	add    $0x10,%rsp
}
  801c64:	c9                   	leaveq 
  801c65:	c3                   	retq   

0000000000801c66 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c66:	55                   	push   %rbp
  801c67:	48 89 e5             	mov    %rsp,%rbp
  801c6a:	48 83 ec 20          	sub    $0x20,%rsp
  801c6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c75:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c78:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c7c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c80:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c83:	48 63 c8             	movslq %eax,%rcx
  801c86:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c8d:	48 63 f0             	movslq %eax,%rsi
  801c90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c97:	48 98                	cltq   
  801c99:	48 83 ec 08          	sub    $0x8,%rsp
  801c9d:	51                   	push   %rcx
  801c9e:	49 89 f9             	mov    %rdi,%r9
  801ca1:	49 89 f0             	mov    %rsi,%r8
  801ca4:	48 89 d1             	mov    %rdx,%rcx
  801ca7:	48 89 c2             	mov    %rax,%rdx
  801caa:	be 00 00 00 00       	mov    $0x0,%esi
  801caf:	bf 11 00 00 00       	mov    $0x11,%edi
  801cb4:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	callq  *%rax
  801cc0:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801cc4:	c9                   	leaveq 
  801cc5:	c3                   	retq   

0000000000801cc6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801cc6:	55                   	push   %rbp
  801cc7:	48 89 e5             	mov    %rsp,%rbp
  801cca:	48 83 ec 10          	sub    $0x10,%rsp
  801cce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801cd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cde:	48 83 ec 08          	sub    $0x8,%rsp
  801ce2:	6a 00                	pushq  $0x0
  801ce4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf0:	48 89 d1             	mov    %rdx,%rcx
  801cf3:	48 89 c2             	mov    %rax,%rdx
  801cf6:	be 00 00 00 00       	mov    $0x0,%esi
  801cfb:	bf 12 00 00 00       	mov    $0x12,%edi
  801d00:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801d07:	00 00 00 
  801d0a:	ff d0                	callq  *%rax
  801d0c:	48 83 c4 10          	add    $0x10,%rsp
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801d16:	48 83 ec 08          	sub    $0x8,%rsp
  801d1a:	6a 00                	pushq  $0x0
  801d1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d32:	be 00 00 00 00       	mov    $0x0,%esi
  801d37:	bf 13 00 00 00       	mov    $0x13,%edi
  801d3c:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	callq  *%rax
  801d48:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801d4c:	90                   	nop
  801d4d:	c9                   	leaveq 
  801d4e:	c3                   	retq   

0000000000801d4f <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	48 83 ec 10          	sub    $0x10,%rsp
  801d57:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5d:	48 98                	cltq   
  801d5f:	48 83 ec 08          	sub    $0x8,%rsp
  801d63:	6a 00                	pushq  $0x0
  801d65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d71:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d76:	48 89 c2             	mov    %rax,%rdx
  801d79:	be 00 00 00 00       	mov    $0x0,%esi
  801d7e:	bf 14 00 00 00       	mov    $0x14,%edi
  801d83:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	48 83 c4 10          	add    $0x10,%rsp
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d99:	48 83 ec 08          	sub    $0x8,%rsp
  801d9d:	6a 00                	pushq  $0x0
  801d9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db0:	ba 00 00 00 00       	mov    $0x0,%edx
  801db5:	be 00 00 00 00       	mov    $0x0,%esi
  801dba:	bf 15 00 00 00       	mov    $0x15,%edi
  801dbf:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801dc6:	00 00 00 
  801dc9:	ff d0                	callq  *%rax
  801dcb:	48 83 c4 10          	add    $0x10,%rsp
}
  801dcf:	c9                   	leaveq 
  801dd0:	c3                   	retq   

0000000000801dd1 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801dd1:	55                   	push   %rbp
  801dd2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801dd5:	48 83 ec 08          	sub    $0x8,%rsp
  801dd9:	6a 00                	pushq  $0x0
  801ddb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dec:	ba 00 00 00 00       	mov    $0x0,%edx
  801df1:	be 00 00 00 00       	mov    $0x0,%esi
  801df6:	bf 16 00 00 00       	mov    $0x16,%edi
  801dfb:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	callq  *%rax
  801e07:	48 83 c4 10          	add    $0x10,%rsp
}
  801e0b:	90                   	nop
  801e0c:	c9                   	leaveq 
  801e0d:	c3                   	retq   

0000000000801e0e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e0e:	55                   	push   %rbp
  801e0f:	48 89 e5             	mov    %rsp,%rbp
  801e12:	48 83 ec 08          	sub    $0x8,%rsp
  801e16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e25:	ff ff ff 
  801e28:	48 01 d0             	add    %rdx,%rax
  801e2b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e2f:	c9                   	leaveq 
  801e30:	c3                   	retq   

0000000000801e31 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e31:	55                   	push   %rbp
  801e32:	48 89 e5             	mov    %rsp,%rbp
  801e35:	48 83 ec 08          	sub    $0x8,%rsp
  801e39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e41:	48 89 c7             	mov    %rax,%rdi
  801e44:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
  801e50:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e56:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e5a:	c9                   	leaveq 
  801e5b:	c3                   	retq   

0000000000801e5c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
  801e60:	48 83 ec 18          	sub    $0x18,%rsp
  801e64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e6f:	eb 6b                	jmp    801edc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e74:	48 98                	cltq   
  801e76:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e7c:	48 c1 e0 0c          	shl    $0xc,%rax
  801e80:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e88:	48 c1 e8 15          	shr    $0x15,%rax
  801e8c:	48 89 c2             	mov    %rax,%rdx
  801e8f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e96:	01 00 00 
  801e99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9d:	83 e0 01             	and    $0x1,%eax
  801ea0:	48 85 c0             	test   %rax,%rax
  801ea3:	74 21                	je     801ec6 <fd_alloc+0x6a>
  801ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea9:	48 c1 e8 0c          	shr    $0xc,%rax
  801ead:	48 89 c2             	mov    %rax,%rdx
  801eb0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb7:	01 00 00 
  801eba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebe:	83 e0 01             	and    $0x1,%eax
  801ec1:	48 85 c0             	test   %rax,%rax
  801ec4:	75 12                	jne    801ed8 <fd_alloc+0x7c>
			*fd_store = fd;
  801ec6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ece:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	eb 1a                	jmp    801ef2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801edc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ee0:	7e 8f                	jle    801e71 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801eed:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ef2:	c9                   	leaveq 
  801ef3:	c3                   	retq   

0000000000801ef4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ef4:	55                   	push   %rbp
  801ef5:	48 89 e5             	mov    %rsp,%rbp
  801ef8:	48 83 ec 20          	sub    $0x20,%rsp
  801efc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f07:	78 06                	js     801f0f <fd_lookup+0x1b>
  801f09:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f0d:	7e 07                	jle    801f16 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f14:	eb 6c                	jmp    801f82 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f19:	48 98                	cltq   
  801f1b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f21:	48 c1 e0 0c          	shl    $0xc,%rax
  801f25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2d:	48 c1 e8 15          	shr    $0x15,%rax
  801f31:	48 89 c2             	mov    %rax,%rdx
  801f34:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f3b:	01 00 00 
  801f3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f42:	83 e0 01             	and    $0x1,%eax
  801f45:	48 85 c0             	test   %rax,%rax
  801f48:	74 21                	je     801f6b <fd_lookup+0x77>
  801f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f52:	48 89 c2             	mov    %rax,%rdx
  801f55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5c:	01 00 00 
  801f5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f63:	83 e0 01             	and    $0x1,%eax
  801f66:	48 85 c0             	test   %rax,%rax
  801f69:	75 07                	jne    801f72 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f70:	eb 10                	jmp    801f82 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f76:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f7a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f82:	c9                   	leaveq 
  801f83:	c3                   	retq   

0000000000801f84 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f84:	55                   	push   %rbp
  801f85:	48 89 e5             	mov    %rsp,%rbp
  801f88:	48 83 ec 30          	sub    $0x30,%rsp
  801f8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f90:	89 f0                	mov    %esi,%eax
  801f92:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f99:	48 89 c7             	mov    %rax,%rdi
  801f9c:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  801fa3:	00 00 00 
  801fa6:	ff d0                	callq  *%rax
  801fa8:	89 c2                	mov    %eax,%edx
  801faa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801fae:	48 89 c6             	mov    %rax,%rsi
  801fb1:	89 d7                	mov    %edx,%edi
  801fb3:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  801fba:	00 00 00 
  801fbd:	ff d0                	callq  *%rax
  801fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc6:	78 0a                	js     801fd2 <fd_close+0x4e>
	    || fd != fd2)
  801fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fcc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fd0:	74 12                	je     801fe4 <fd_close+0x60>
		return (must_exist ? r : 0);
  801fd2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fd6:	74 05                	je     801fdd <fd_close+0x59>
  801fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fdb:	eb 70                	jmp    80204d <fd_close+0xc9>
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe2:	eb 69                	jmp    80204d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe8:	8b 00                	mov    (%rax),%eax
  801fea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fee:	48 89 d6             	mov    %rdx,%rsi
  801ff1:	89 c7                	mov    %eax,%edi
  801ff3:	48 b8 4f 20 80 00 00 	movabs $0x80204f,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax
  801fff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802002:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802006:	78 2a                	js     802032 <fd_close+0xae>
		if (dev->dev_close)
  802008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802010:	48 85 c0             	test   %rax,%rax
  802013:	74 16                	je     80202b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802019:	48 8b 40 20          	mov    0x20(%rax),%rax
  80201d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802021:	48 89 d7             	mov    %rdx,%rdi
  802024:	ff d0                	callq  *%rax
  802026:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802029:	eb 07                	jmp    802032 <fd_close+0xae>
		else
			r = 0;
  80202b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802032:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802036:	48 89 c6             	mov    %rax,%rsi
  802039:	bf 00 00 00 00       	mov    $0x0,%edi
  80203e:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802045:	00 00 00 
  802048:	ff d0                	callq  *%rax
	return r;
  80204a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80204d:	c9                   	leaveq 
  80204e:	c3                   	retq   

000000000080204f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80204f:	55                   	push   %rbp
  802050:	48 89 e5             	mov    %rsp,%rbp
  802053:	48 83 ec 20          	sub    $0x20,%rsp
  802057:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80205a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80205e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802065:	eb 41                	jmp    8020a8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802067:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80206e:	00 00 00 
  802071:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802074:	48 63 d2             	movslq %edx,%rdx
  802077:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80207b:	8b 00                	mov    (%rax),%eax
  80207d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802080:	75 22                	jne    8020a4 <dev_lookup+0x55>
			*dev = devtab[i];
  802082:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802089:	00 00 00 
  80208c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80208f:	48 63 d2             	movslq %edx,%rdx
  802092:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802096:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80209a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	eb 60                	jmp    802104 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020a4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020a8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020af:	00 00 00 
  8020b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020b5:	48 63 d2             	movslq %edx,%rdx
  8020b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020bc:	48 85 c0             	test   %rax,%rax
  8020bf:	75 a6                	jne    802067 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020c1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8020c8:	00 00 00 
  8020cb:	48 8b 00             	mov    (%rax),%rax
  8020ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020d4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020d7:	89 c6                	mov    %eax,%esi
  8020d9:	48 bf c8 4a 80 00 00 	movabs $0x804ac8,%rdi
  8020e0:	00 00 00 
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	48 b9 f2 02 80 00 00 	movabs $0x8002f2,%rcx
  8020ef:	00 00 00 
  8020f2:	ff d1                	callq  *%rcx
	*dev = 0;
  8020f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802104:	c9                   	leaveq 
  802105:	c3                   	retq   

0000000000802106 <close>:

int
close(int fdnum)
{
  802106:	55                   	push   %rbp
  802107:	48 89 e5             	mov    %rsp,%rbp
  80210a:	48 83 ec 20          	sub    $0x20,%rsp
  80210e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802111:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802115:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802118:	48 89 d6             	mov    %rdx,%rsi
  80211b:	89 c7                	mov    %eax,%edi
  80211d:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
  802129:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80212c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802130:	79 05                	jns    802137 <close+0x31>
		return r;
  802132:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802135:	eb 18                	jmp    80214f <close+0x49>
	else
		return fd_close(fd, 1);
  802137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213b:	be 01 00 00 00       	mov    $0x1,%esi
  802140:	48 89 c7             	mov    %rax,%rdi
  802143:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
}
  80214f:	c9                   	leaveq 
  802150:	c3                   	retq   

0000000000802151 <close_all>:

void
close_all(void)
{
  802151:	55                   	push   %rbp
  802152:	48 89 e5             	mov    %rsp,%rbp
  802155:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802160:	eb 15                	jmp    802177 <close_all+0x26>
		close(i);
  802162:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802165:	89 c7                	mov    %eax,%edi
  802167:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802173:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802177:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80217b:	7e e5                	jle    802162 <close_all+0x11>
		close(i);
}
  80217d:	90                   	nop
  80217e:	c9                   	leaveq 
  80217f:	c3                   	retq   

0000000000802180 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802180:	55                   	push   %rbp
  802181:	48 89 e5             	mov    %rsp,%rbp
  802184:	48 83 ec 40          	sub    $0x40,%rsp
  802188:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80218b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80218e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802192:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802195:	48 89 d6             	mov    %rdx,%rsi
  802198:	89 c7                	mov    %eax,%edi
  80219a:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
  8021a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ad:	79 08                	jns    8021b7 <dup+0x37>
		return r;
  8021af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b2:	e9 70 01 00 00       	jmpq   802327 <dup+0x1a7>
	close(newfdnum);
  8021b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021ba:	89 c7                	mov    %eax,%edi
  8021bc:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8021c3:	00 00 00 
  8021c6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021c8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021cb:	48 98                	cltq   
  8021cd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021d3:	48 c1 e0 0c          	shl    $0xc,%rax
  8021d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021df:	48 89 c7             	mov    %rax,%rdi
  8021e2:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
  8021ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f6:	48 89 c7             	mov    %rax,%rdi
  8021f9:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  802200:	00 00 00 
  802203:	ff d0                	callq  *%rax
  802205:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220d:	48 c1 e8 15          	shr    $0x15,%rax
  802211:	48 89 c2             	mov    %rax,%rdx
  802214:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80221b:	01 00 00 
  80221e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802222:	83 e0 01             	and    $0x1,%eax
  802225:	48 85 c0             	test   %rax,%rax
  802228:	74 71                	je     80229b <dup+0x11b>
  80222a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222e:	48 c1 e8 0c          	shr    $0xc,%rax
  802232:	48 89 c2             	mov    %rax,%rdx
  802235:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80223c:	01 00 00 
  80223f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802243:	83 e0 01             	and    $0x1,%eax
  802246:	48 85 c0             	test   %rax,%rax
  802249:	74 50                	je     80229b <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80224b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224f:	48 c1 e8 0c          	shr    $0xc,%rax
  802253:	48 89 c2             	mov    %rax,%rdx
  802256:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80225d:	01 00 00 
  802260:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802264:	25 07 0e 00 00       	and    $0xe07,%eax
  802269:	89 c1                	mov    %eax,%ecx
  80226b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80226f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802273:	41 89 c8             	mov    %ecx,%r8d
  802276:	48 89 d1             	mov    %rdx,%rcx
  802279:	ba 00 00 00 00       	mov    $0x0,%edx
  80227e:	48 89 c6             	mov    %rax,%rsi
  802281:	bf 00 00 00 00       	mov    $0x0,%edi
  802286:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  80228d:	00 00 00 
  802290:	ff d0                	callq  *%rax
  802292:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802295:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802299:	78 55                	js     8022f0 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80229b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80229f:	48 c1 e8 0c          	shr    $0xc,%rax
  8022a3:	48 89 c2             	mov    %rax,%rdx
  8022a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ad:	01 00 00 
  8022b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8022b9:	89 c1                	mov    %eax,%ecx
  8022bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c3:	41 89 c8             	mov    %ecx,%r8d
  8022c6:	48 89 d1             	mov    %rdx,%rcx
  8022c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ce:	48 89 c6             	mov    %rax,%rsi
  8022d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d6:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  8022dd:	00 00 00 
  8022e0:	ff d0                	callq  *%rax
  8022e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e9:	78 08                	js     8022f3 <dup+0x173>
		goto err;

	return newfdnum;
  8022eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022ee:	eb 37                	jmp    802327 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022f0:	90                   	nop
  8022f1:	eb 01                	jmp    8022f4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8022f3:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f8:	48 89 c6             	mov    %rax,%rsi
  8022fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802300:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802307:	00 00 00 
  80230a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80230c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802310:	48 89 c6             	mov    %rax,%rsi
  802313:	bf 00 00 00 00       	mov    $0x0,%edi
  802318:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  80231f:	00 00 00 
  802322:	ff d0                	callq  *%rax
	return r;
  802324:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802327:	c9                   	leaveq 
  802328:	c3                   	retq   

0000000000802329 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802329:	55                   	push   %rbp
  80232a:	48 89 e5             	mov    %rsp,%rbp
  80232d:	48 83 ec 40          	sub    $0x40,%rsp
  802331:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802334:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802338:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80233c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802340:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802343:	48 89 d6             	mov    %rdx,%rsi
  802346:	89 c7                	mov    %eax,%edi
  802348:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  80234f:	00 00 00 
  802352:	ff d0                	callq  *%rax
  802354:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802357:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235b:	78 24                	js     802381 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80235d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802361:	8b 00                	mov    (%rax),%eax
  802363:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802367:	48 89 d6             	mov    %rdx,%rsi
  80236a:	89 c7                	mov    %eax,%edi
  80236c:	48 b8 4f 20 80 00 00 	movabs $0x80204f,%rax
  802373:	00 00 00 
  802376:	ff d0                	callq  *%rax
  802378:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237f:	79 05                	jns    802386 <read+0x5d>
		return r;
  802381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802384:	eb 76                	jmp    8023fc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238a:	8b 40 08             	mov    0x8(%rax),%eax
  80238d:	83 e0 03             	and    $0x3,%eax
  802390:	83 f8 01             	cmp    $0x1,%eax
  802393:	75 3a                	jne    8023cf <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802395:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80239c:	00 00 00 
  80239f:	48 8b 00             	mov    (%rax),%rax
  8023a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023ab:	89 c6                	mov    %eax,%esi
  8023ad:	48 bf e7 4a 80 00 00 	movabs $0x804ae7,%rdi
  8023b4:	00 00 00 
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bc:	48 b9 f2 02 80 00 00 	movabs $0x8002f2,%rcx
  8023c3:	00 00 00 
  8023c6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023cd:	eb 2d                	jmp    8023fc <read+0xd3>
	}
	if (!dev->dev_read)
  8023cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023d7:	48 85 c0             	test   %rax,%rax
  8023da:	75 07                	jne    8023e3 <read+0xba>
		return -E_NOT_SUPP;
  8023dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023e1:	eb 19                	jmp    8023fc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023f3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023f7:	48 89 cf             	mov    %rcx,%rdi
  8023fa:	ff d0                	callq  *%rax
}
  8023fc:	c9                   	leaveq 
  8023fd:	c3                   	retq   

00000000008023fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	48 83 ec 30          	sub    $0x30,%rsp
  802406:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802409:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80240d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802411:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802418:	eb 47                	jmp    802461 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80241a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241d:	48 98                	cltq   
  80241f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802423:	48 29 c2             	sub    %rax,%rdx
  802426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802429:	48 63 c8             	movslq %eax,%rcx
  80242c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802430:	48 01 c1             	add    %rax,%rcx
  802433:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802436:	48 89 ce             	mov    %rcx,%rsi
  802439:	89 c7                	mov    %eax,%edi
  80243b:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
  802447:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80244a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80244e:	79 05                	jns    802455 <readn+0x57>
			return m;
  802450:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802453:	eb 1d                	jmp    802472 <readn+0x74>
		if (m == 0)
  802455:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802459:	74 13                	je     80246e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80245b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802461:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802464:	48 98                	cltq   
  802466:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80246a:	72 ae                	jb     80241a <readn+0x1c>
  80246c:	eb 01                	jmp    80246f <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80246e:	90                   	nop
	}
	return tot;
  80246f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802472:	c9                   	leaveq 
  802473:	c3                   	retq   

0000000000802474 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802474:	55                   	push   %rbp
  802475:	48 89 e5             	mov    %rsp,%rbp
  802478:	48 83 ec 40          	sub    $0x40,%rsp
  80247c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802483:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802487:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80248b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80248e:	48 89 d6             	mov    %rdx,%rsi
  802491:	89 c7                	mov    %eax,%edi
  802493:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  80249a:	00 00 00 
  80249d:	ff d0                	callq  *%rax
  80249f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a6:	78 24                	js     8024cc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ac:	8b 00                	mov    (%rax),%eax
  8024ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b2:	48 89 d6             	mov    %rdx,%rsi
  8024b5:	89 c7                	mov    %eax,%edi
  8024b7:	48 b8 4f 20 80 00 00 	movabs $0x80204f,%rax
  8024be:	00 00 00 
  8024c1:	ff d0                	callq  *%rax
  8024c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ca:	79 05                	jns    8024d1 <write+0x5d>
		return r;
  8024cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cf:	eb 75                	jmp    802546 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d5:	8b 40 08             	mov    0x8(%rax),%eax
  8024d8:	83 e0 03             	and    $0x3,%eax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	75 3a                	jne    802519 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024df:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8024e6:	00 00 00 
  8024e9:	48 8b 00             	mov    (%rax),%rax
  8024ec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024f5:	89 c6                	mov    %eax,%esi
  8024f7:	48 bf 03 4b 80 00 00 	movabs $0x804b03,%rdi
  8024fe:	00 00 00 
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
  802506:	48 b9 f2 02 80 00 00 	movabs $0x8002f2,%rcx
  80250d:	00 00 00 
  802510:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802517:	eb 2d                	jmp    802546 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802521:	48 85 c0             	test   %rax,%rax
  802524:	75 07                	jne    80252d <write+0xb9>
		return -E_NOT_SUPP;
  802526:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80252b:	eb 19                	jmp    802546 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80252d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802531:	48 8b 40 18          	mov    0x18(%rax),%rax
  802535:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802539:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80253d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802541:	48 89 cf             	mov    %rcx,%rdi
  802544:	ff d0                	callq  *%rax
}
  802546:	c9                   	leaveq 
  802547:	c3                   	retq   

0000000000802548 <seek>:

int
seek(int fdnum, off_t offset)
{
  802548:	55                   	push   %rbp
  802549:	48 89 e5             	mov    %rsp,%rbp
  80254c:	48 83 ec 18          	sub    $0x18,%rsp
  802550:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802553:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802556:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80255a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80255d:	48 89 d6             	mov    %rdx,%rsi
  802560:	89 c7                	mov    %eax,%edi
  802562:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  802569:	00 00 00 
  80256c:	ff d0                	callq  *%rax
  80256e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802571:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802575:	79 05                	jns    80257c <seek+0x34>
		return r;
  802577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257a:	eb 0f                	jmp    80258b <seek+0x43>
	fd->fd_offset = offset;
  80257c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802580:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802583:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258b:	c9                   	leaveq 
  80258c:	c3                   	retq   

000000000080258d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80258d:	55                   	push   %rbp
  80258e:	48 89 e5             	mov    %rsp,%rbp
  802591:	48 83 ec 30          	sub    $0x30,%rsp
  802595:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802598:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80259b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80259f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a2:	48 89 d6             	mov    %rdx,%rsi
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax
  8025b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ba:	78 24                	js     8025e0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c0:	8b 00                	mov    (%rax),%eax
  8025c2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c6:	48 89 d6             	mov    %rdx,%rsi
  8025c9:	89 c7                	mov    %eax,%edi
  8025cb:	48 b8 4f 20 80 00 00 	movabs $0x80204f,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	79 05                	jns    8025e5 <ftruncate+0x58>
		return r;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	eb 72                	jmp    802657 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e9:	8b 40 08             	mov    0x8(%rax),%eax
  8025ec:	83 e0 03             	and    $0x3,%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	75 3a                	jne    80262d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025f3:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8025fa:	00 00 00 
  8025fd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802600:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802606:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802609:	89 c6                	mov    %eax,%esi
  80260b:	48 bf 20 4b 80 00 00 	movabs $0x804b20,%rdi
  802612:	00 00 00 
  802615:	b8 00 00 00 00       	mov    $0x0,%eax
  80261a:	48 b9 f2 02 80 00 00 	movabs $0x8002f2,%rcx
  802621:	00 00 00 
  802624:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802626:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80262b:	eb 2a                	jmp    802657 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80262d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802631:	48 8b 40 30          	mov    0x30(%rax),%rax
  802635:	48 85 c0             	test   %rax,%rax
  802638:	75 07                	jne    802641 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80263a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80263f:	eb 16                	jmp    802657 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802645:	48 8b 40 30          	mov    0x30(%rax),%rax
  802649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80264d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802650:	89 ce                	mov    %ecx,%esi
  802652:	48 89 d7             	mov    %rdx,%rdi
  802655:	ff d0                	callq  *%rax
}
  802657:	c9                   	leaveq 
  802658:	c3                   	retq   

0000000000802659 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802659:	55                   	push   %rbp
  80265a:	48 89 e5             	mov    %rsp,%rbp
  80265d:	48 83 ec 30          	sub    $0x30,%rsp
  802661:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802664:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802668:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80266c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80266f:	48 89 d6             	mov    %rdx,%rsi
  802672:	89 c7                	mov    %eax,%edi
  802674:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
  802680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802687:	78 24                	js     8026ad <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268d:	8b 00                	mov    (%rax),%eax
  80268f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802693:	48 89 d6             	mov    %rdx,%rsi
  802696:	89 c7                	mov    %eax,%edi
  802698:	48 b8 4f 20 80 00 00 	movabs $0x80204f,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	callq  *%rax
  8026a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ab:	79 05                	jns    8026b2 <fstat+0x59>
		return r;
  8026ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b0:	eb 5e                	jmp    802710 <fstat+0xb7>
	if (!dev->dev_stat)
  8026b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026ba:	48 85 c0             	test   %rax,%rax
  8026bd:	75 07                	jne    8026c6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026bf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026c4:	eb 4a                	jmp    802710 <fstat+0xb7>
	stat->st_name[0] = 0;
  8026c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ca:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026d1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026d8:	00 00 00 
	stat->st_isdir = 0;
  8026db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026df:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026e6:	00 00 00 
	stat->st_dev = dev;
  8026e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026f1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fc:	48 8b 40 28          	mov    0x28(%rax),%rax
  802700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802704:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802708:	48 89 ce             	mov    %rcx,%rsi
  80270b:	48 89 d7             	mov    %rdx,%rdi
  80270e:	ff d0                	callq  *%rax
}
  802710:	c9                   	leaveq 
  802711:	c3                   	retq   

0000000000802712 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802712:	55                   	push   %rbp
  802713:	48 89 e5             	mov    %rsp,%rbp
  802716:	48 83 ec 20          	sub    $0x20,%rsp
  80271a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80271e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802726:	be 00 00 00 00       	mov    $0x0,%esi
  80272b:	48 89 c7             	mov    %rax,%rdi
  80272e:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax
  80273a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802741:	79 05                	jns    802748 <stat+0x36>
		return fd;
  802743:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802746:	eb 2f                	jmp    802777 <stat+0x65>
	r = fstat(fd, stat);
  802748:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80274c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274f:	48 89 d6             	mov    %rdx,%rsi
  802752:	89 c7                	mov    %eax,%edi
  802754:	48 b8 59 26 80 00 00 	movabs $0x802659,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax
  802760:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802763:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802766:	89 c7                	mov    %eax,%edi
  802768:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  80276f:	00 00 00 
  802772:	ff d0                	callq  *%rax
	return r;
  802774:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802777:	c9                   	leaveq 
  802778:	c3                   	retq   

0000000000802779 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802779:	55                   	push   %rbp
  80277a:	48 89 e5             	mov    %rsp,%rbp
  80277d:	48 83 ec 10          	sub    $0x10,%rsp
  802781:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802784:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802788:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  80278f:	00 00 00 
  802792:	8b 00                	mov    (%rax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	75 1f                	jne    8027b7 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802798:	bf 01 00 00 00       	mov    $0x1,%edi
  80279d:	48 b8 2c 44 80 00 00 	movabs $0x80442c,%rax
  8027a4:	00 00 00 
  8027a7:	ff d0                	callq  *%rax
  8027a9:	89 c2                	mov    %eax,%edx
  8027ab:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  8027b2:	00 00 00 
  8027b5:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027b7:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  8027be:	00 00 00 
  8027c1:	8b 00                	mov    (%rax),%eax
  8027c3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027c6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027cb:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027d2:	00 00 00 
  8027d5:	89 c7                	mov    %eax,%edi
  8027d7:	48 b8 97 43 80 00 00 	movabs $0x804397,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ec:	48 89 c6             	mov    %rax,%rsi
  8027ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f4:	48 b8 d6 42 80 00 00 	movabs $0x8042d6,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
}
  802800:	c9                   	leaveq 
  802801:	c3                   	retq   

0000000000802802 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802802:	55                   	push   %rbp
  802803:	48 89 e5             	mov    %rsp,%rbp
  802806:	48 83 ec 20          	sub    $0x20,%rsp
  80280a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80280e:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802815:	48 89 c7             	mov    %rax,%rdi
  802818:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
  802824:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802829:	7e 0a                	jle    802835 <open+0x33>
		return -E_BAD_PATH;
  80282b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802830:	e9 a5 00 00 00       	jmpq   8028da <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802835:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802839:	48 89 c7             	mov    %rax,%rdi
  80283c:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
  802848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284f:	79 08                	jns    802859 <open+0x57>
		return r;
  802851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802854:	e9 81 00 00 00       	jmpq   8028da <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285d:	48 89 c6             	mov    %rax,%rsi
  802860:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802867:	00 00 00 
  80286a:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  802871:	00 00 00 
  802874:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802876:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80287d:	00 00 00 
  802880:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802883:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802889:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288d:	48 89 c6             	mov    %rax,%rsi
  802890:	bf 01 00 00 00       	mov    $0x1,%edi
  802895:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	callq  *%rax
  8028a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a8:	79 1d                	jns    8028c7 <open+0xc5>
		fd_close(fd, 0);
  8028aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ae:	be 00 00 00 00       	mov    $0x0,%esi
  8028b3:	48 89 c7             	mov    %rax,%rdi
  8028b6:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
		return r;
  8028c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c5:	eb 13                	jmp    8028da <open+0xd8>
	}

	return fd2num(fd);
  8028c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cb:	48 89 c7             	mov    %rax,%rdi
  8028ce:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  8028d5:	00 00 00 
  8028d8:	ff d0                	callq  *%rax

}
  8028da:	c9                   	leaveq 
  8028db:	c3                   	retq   

00000000008028dc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028dc:	55                   	push   %rbp
  8028dd:	48 89 e5             	mov    %rsp,%rbp
  8028e0:	48 83 ec 10          	sub    $0x10,%rsp
  8028e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028f6:	00 00 00 
  8028f9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028fb:	be 00 00 00 00       	mov    $0x0,%esi
  802900:	bf 06 00 00 00       	mov    $0x6,%edi
  802905:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	callq  *%rax
}
  802911:	c9                   	leaveq 
  802912:	c3                   	retq   

0000000000802913 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802913:	55                   	push   %rbp
  802914:	48 89 e5             	mov    %rsp,%rbp
  802917:	48 83 ec 30          	sub    $0x30,%rsp
  80291b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80291f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802923:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292b:	8b 50 0c             	mov    0xc(%rax),%edx
  80292e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802935:	00 00 00 
  802938:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80293a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802941:	00 00 00 
  802944:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802948:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80294c:	be 00 00 00 00       	mov    $0x0,%esi
  802951:	bf 03 00 00 00       	mov    $0x3,%edi
  802956:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  80295d:	00 00 00 
  802960:	ff d0                	callq  *%rax
  802962:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802965:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802969:	79 08                	jns    802973 <devfile_read+0x60>
		return r;
  80296b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296e:	e9 a4 00 00 00       	jmpq   802a17 <devfile_read+0x104>
	assert(r <= n);
  802973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802976:	48 98                	cltq   
  802978:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80297c:	76 35                	jbe    8029b3 <devfile_read+0xa0>
  80297e:	48 b9 46 4b 80 00 00 	movabs $0x804b46,%rcx
  802985:	00 00 00 
  802988:	48 ba 4d 4b 80 00 00 	movabs $0x804b4d,%rdx
  80298f:	00 00 00 
  802992:	be 86 00 00 00       	mov    $0x86,%esi
  802997:	48 bf 62 4b 80 00 00 	movabs $0x804b62,%rdi
  80299e:	00 00 00 
  8029a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a6:	49 b8 c2 41 80 00 00 	movabs $0x8041c2,%r8
  8029ad:	00 00 00 
  8029b0:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8029b3:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8029ba:	7e 35                	jle    8029f1 <devfile_read+0xde>
  8029bc:	48 b9 6d 4b 80 00 00 	movabs $0x804b6d,%rcx
  8029c3:	00 00 00 
  8029c6:	48 ba 4d 4b 80 00 00 	movabs $0x804b4d,%rdx
  8029cd:	00 00 00 
  8029d0:	be 87 00 00 00       	mov    $0x87,%esi
  8029d5:	48 bf 62 4b 80 00 00 	movabs $0x804b62,%rdi
  8029dc:	00 00 00 
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e4:	49 b8 c2 41 80 00 00 	movabs $0x8041c2,%r8
  8029eb:	00 00 00 
  8029ee:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8029f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f4:	48 63 d0             	movslq %eax,%rdx
  8029f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a02:	00 00 00 
  802a05:	48 89 c7             	mov    %rax,%rdi
  802a08:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
	return r;
  802a14:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802a17:	c9                   	leaveq 
  802a18:	c3                   	retq   

0000000000802a19 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a19:	55                   	push   %rbp
  802a1a:	48 89 e5             	mov    %rsp,%rbp
  802a1d:	48 83 ec 40          	sub    $0x40,%rsp
  802a21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a29:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802a2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a35:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802a3c:	00 
  802a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a41:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802a45:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802a4a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a52:	8b 50 0c             	mov    0xc(%rax),%edx
  802a55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a5c:	00 00 00 
  802a5f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a68:	00 00 00 
  802a6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a73:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7b:	48 89 c6             	mov    %rax,%rsi
  802a7e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a85:	00 00 00 
  802a88:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  802a8f:	00 00 00 
  802a92:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a94:	be 00 00 00 00       	mov    $0x0,%esi
  802a99:	bf 04 00 00 00       	mov    $0x4,%edi
  802a9e:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802aad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ab1:	79 05                	jns    802ab8 <devfile_write+0x9f>
		return r;
  802ab3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ab6:	eb 43                	jmp    802afb <devfile_write+0xe2>
	assert(r <= n);
  802ab8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802abb:	48 98                	cltq   
  802abd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ac1:	76 35                	jbe    802af8 <devfile_write+0xdf>
  802ac3:	48 b9 46 4b 80 00 00 	movabs $0x804b46,%rcx
  802aca:	00 00 00 
  802acd:	48 ba 4d 4b 80 00 00 	movabs $0x804b4d,%rdx
  802ad4:	00 00 00 
  802ad7:	be a2 00 00 00       	mov    $0xa2,%esi
  802adc:	48 bf 62 4b 80 00 00 	movabs $0x804b62,%rdi
  802ae3:	00 00 00 
  802ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aeb:	49 b8 c2 41 80 00 00 	movabs $0x8041c2,%r8
  802af2:	00 00 00 
  802af5:	41 ff d0             	callq  *%r8
	return r;
  802af8:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802afb:	c9                   	leaveq 
  802afc:	c3                   	retq   

0000000000802afd <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802afd:	55                   	push   %rbp
  802afe:	48 89 e5             	mov    %rsp,%rbp
  802b01:	48 83 ec 20          	sub    $0x20,%rsp
  802b05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b11:	8b 50 0c             	mov    0xc(%rax),%edx
  802b14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b1b:	00 00 00 
  802b1e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b20:	be 00 00 00 00       	mov    $0x0,%esi
  802b25:	bf 05 00 00 00       	mov    $0x5,%edi
  802b2a:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
  802b36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3d:	79 05                	jns    802b44 <devfile_stat+0x47>
		return r;
  802b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b42:	eb 56                	jmp    802b9a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b48:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b4f:	00 00 00 
  802b52:	48 89 c7             	mov    %rax,%rdi
  802b55:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b68:	00 00 00 
  802b6b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b75:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b82:	00 00 00 
  802b85:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b8f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b9a:	c9                   	leaveq 
  802b9b:	c3                   	retq   

0000000000802b9c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b9c:	55                   	push   %rbp
  802b9d:	48 89 e5             	mov    %rsp,%rbp
  802ba0:	48 83 ec 10          	sub    $0x10,%rsp
  802ba4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ba8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802baf:	8b 50 0c             	mov    0xc(%rax),%edx
  802bb2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bb9:	00 00 00 
  802bbc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bbe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bc5:	00 00 00 
  802bc8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bce:	be 00 00 00 00       	mov    $0x0,%esi
  802bd3:	bf 02 00 00 00       	mov    $0x2,%edi
  802bd8:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  802bdf:	00 00 00 
  802be2:	ff d0                	callq  *%rax
}
  802be4:	c9                   	leaveq 
  802be5:	c3                   	retq   

0000000000802be6 <remove>:

// Delete a file
int
remove(const char *path)
{
  802be6:	55                   	push   %rbp
  802be7:	48 89 e5             	mov    %rsp,%rbp
  802bea:	48 83 ec 10          	sub    $0x10,%rsp
  802bee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf6:	48 89 c7             	mov    %rax,%rdi
  802bf9:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
  802c05:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c0a:	7e 07                	jle    802c13 <remove+0x2d>
		return -E_BAD_PATH;
  802c0c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c11:	eb 33                	jmp    802c46 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c17:	48 89 c6             	mov    %rax,%rsi
  802c1a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c21:	00 00 00 
  802c24:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c30:	be 00 00 00 00       	mov    $0x0,%esi
  802c35:	bf 07 00 00 00       	mov    $0x7,%edi
  802c3a:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  802c41:	00 00 00 
  802c44:	ff d0                	callq  *%rax
}
  802c46:	c9                   	leaveq 
  802c47:	c3                   	retq   

0000000000802c48 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c48:	55                   	push   %rbp
  802c49:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c4c:	be 00 00 00 00       	mov    $0x0,%esi
  802c51:	bf 08 00 00 00       	mov    $0x8,%edi
  802c56:	48 b8 79 27 80 00 00 	movabs $0x802779,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
}
  802c62:	5d                   	pop    %rbp
  802c63:	c3                   	retq   

0000000000802c64 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c64:	55                   	push   %rbp
  802c65:	48 89 e5             	mov    %rsp,%rbp
  802c68:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c6f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c76:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c7d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c84:	be 00 00 00 00       	mov    $0x0,%esi
  802c89:	48 89 c7             	mov    %rax,%rdi
  802c8c:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802c93:	00 00 00 
  802c96:	ff d0                	callq  *%rax
  802c98:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9f:	79 28                	jns    802cc9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ca1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca4:	89 c6                	mov    %eax,%esi
  802ca6:	48 bf 79 4b 80 00 00 	movabs $0x804b79,%rdi
  802cad:	00 00 00 
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb5:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  802cbc:	00 00 00 
  802cbf:	ff d2                	callq  *%rdx
		return fd_src;
  802cc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc4:	e9 76 01 00 00       	jmpq   802e3f <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cc9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cd0:	be 01 01 00 00       	mov    $0x101,%esi
  802cd5:	48 89 c7             	mov    %rax,%rdi
  802cd8:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
  802ce4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ce7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ceb:	0f 89 ad 00 00 00    	jns    802d9e <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cf1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf4:	89 c6                	mov    %eax,%esi
  802cf6:	48 bf 8f 4b 80 00 00 	movabs $0x804b8f,%rdi
  802cfd:	00 00 00 
  802d00:	b8 00 00 00 00       	mov    $0x0,%eax
  802d05:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  802d0c:	00 00 00 
  802d0f:	ff d2                	callq  *%rdx
		close(fd_src);
  802d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d14:	89 c7                	mov    %eax,%edi
  802d16:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
		return fd_dest;
  802d22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d25:	e9 15 01 00 00       	jmpq   802e3f <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802d2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d2d:	48 63 d0             	movslq %eax,%rdx
  802d30:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3a:	48 89 ce             	mov    %rcx,%rsi
  802d3d:	89 c7                	mov    %eax,%edi
  802d3f:	48 b8 74 24 80 00 00 	movabs $0x802474,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d52:	79 4a                	jns    802d9e <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802d54:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d57:	89 c6                	mov    %eax,%esi
  802d59:	48 bf a9 4b 80 00 00 	movabs $0x804ba9,%rdi
  802d60:	00 00 00 
  802d63:	b8 00 00 00 00       	mov    $0x0,%eax
  802d68:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  802d6f:	00 00 00 
  802d72:	ff d2                	callq  *%rdx
			close(fd_src);
  802d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d77:	89 c7                	mov    %eax,%edi
  802d79:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
			close(fd_dest);
  802d85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d88:	89 c7                	mov    %eax,%edi
  802d8a:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
			return write_size;
  802d96:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d99:	e9 a1 00 00 00       	jmpq   802e3f <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d9e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da8:	ba 00 02 00 00       	mov    $0x200,%edx
  802dad:	48 89 ce             	mov    %rcx,%rsi
  802db0:	89 c7                	mov    %eax,%edi
  802db2:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  802db9:	00 00 00 
  802dbc:	ff d0                	callq  *%rax
  802dbe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dc5:	0f 8f 5f ff ff ff    	jg     802d2a <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802dcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dcf:	79 47                	jns    802e18 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802dd1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dd4:	89 c6                	mov    %eax,%esi
  802dd6:	48 bf bc 4b 80 00 00 	movabs $0x804bbc,%rdi
  802ddd:	00 00 00 
  802de0:	b8 00 00 00 00       	mov    $0x0,%eax
  802de5:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  802dec:	00 00 00 
  802def:	ff d2                	callq  *%rdx
		close(fd_src);
  802df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df4:	89 c7                	mov    %eax,%edi
  802df6:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
		close(fd_dest);
  802e02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e05:	89 c7                	mov    %eax,%edi
  802e07:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
		return read_size;
  802e13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e16:	eb 27                	jmp    802e3f <copy+0x1db>
	}
	close(fd_src);
  802e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1b:	89 c7                	mov    %eax,%edi
  802e1d:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802e24:	00 00 00 
  802e27:	ff d0                	callq  *%rax
	close(fd_dest);
  802e29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e2c:	89 c7                	mov    %eax,%edi
  802e2e:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802e35:	00 00 00 
  802e38:	ff d0                	callq  *%rax
	return 0;
  802e3a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e3f:	c9                   	leaveq 
  802e40:	c3                   	retq   

0000000000802e41 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e41:	55                   	push   %rbp
  802e42:	48 89 e5             	mov    %rsp,%rbp
  802e45:	48 83 ec 20          	sub    $0x20,%rsp
  802e49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e51:	8b 40 0c             	mov    0xc(%rax),%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	7e 67                	jle    802ebf <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802e58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5c:	8b 40 04             	mov    0x4(%rax),%eax
  802e5f:	48 63 d0             	movslq %eax,%rdx
  802e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e66:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6e:	8b 00                	mov    (%rax),%eax
  802e70:	48 89 ce             	mov    %rcx,%rsi
  802e73:	89 c7                	mov    %eax,%edi
  802e75:	48 b8 74 24 80 00 00 	movabs $0x802474,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	callq  *%rax
  802e81:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e88:	7e 13                	jle    802e9d <writebuf+0x5c>
			b->result += result;
  802e8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8e:	8b 50 08             	mov    0x8(%rax),%edx
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	01 c2                	add    %eax,%edx
  802e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9a:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea1:	8b 40 04             	mov    0x4(%rax),%eax
  802ea4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ea7:	74 16                	je     802ebf <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb2:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802eb6:	89 c2                	mov    %eax,%edx
  802eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebc:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ebf:	90                   	nop
  802ec0:	c9                   	leaveq 
  802ec1:	c3                   	retq   

0000000000802ec2 <putch>:

static void
putch(int ch, void *thunk)
{
  802ec2:	55                   	push   %rbp
  802ec3:	48 89 e5             	mov    %rsp,%rbp
  802ec6:	48 83 ec 20          	sub    $0x20,%rsp
  802eca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ecd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802ed1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802ed9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edd:	8b 40 04             	mov    0x4(%rax),%eax
  802ee0:	8d 48 01             	lea    0x1(%rax),%ecx
  802ee3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ee7:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802eea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802eed:	89 d1                	mov    %edx,%ecx
  802eef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ef3:	48 98                	cltq   
  802ef5:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802ef9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efd:	8b 40 04             	mov    0x4(%rax),%eax
  802f00:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f05:	75 1e                	jne    802f25 <putch+0x63>
		writebuf(b);
  802f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0b:	48 89 c7             	mov    %rax,%rdi
  802f0e:	48 b8 41 2e 80 00 00 	movabs $0x802e41,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
		b->idx = 0;
  802f1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f25:	90                   	nop
  802f26:	c9                   	leaveq 
  802f27:	c3                   	retq   

0000000000802f28 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f28:	55                   	push   %rbp
  802f29:	48 89 e5             	mov    %rsp,%rbp
  802f2c:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f33:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f39:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f40:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f47:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802f53:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f5a:	00 00 00 
	b.result = 0;
  802f5d:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f64:	00 00 00 
	b.error = 1;
  802f67:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f6e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f71:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f78:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f7f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f86:	48 89 c6             	mov    %rax,%rsi
  802f89:	48 bf c2 2e 80 00 00 	movabs $0x802ec2,%rdi
  802f90:	00 00 00 
  802f93:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  802f9a:	00 00 00 
  802f9d:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	7e 16                	jle    802fbf <vfprintf+0x97>
		writebuf(&b);
  802fa9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fb0:	48 89 c7             	mov    %rax,%rdi
  802fb3:	48 b8 41 2e 80 00 00 	movabs $0x802e41,%rax
  802fba:	00 00 00 
  802fbd:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802fbf:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 08                	je     802fd1 <vfprintf+0xa9>
  802fc9:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802fcf:	eb 06                	jmp    802fd7 <vfprintf+0xaf>
  802fd1:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802fd7:	c9                   	leaveq 
  802fd8:	c3                   	retq   

0000000000802fd9 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802fd9:	55                   	push   %rbp
  802fda:	48 89 e5             	mov    %rsp,%rbp
  802fdd:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fe4:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802fea:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802ff1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802ff8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803006:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80300d:	84 c0                	test   %al,%al
  80300f:	74 20                	je     803031 <fprintf+0x58>
  803011:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803015:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803019:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80301d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803021:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803025:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803029:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80302d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803031:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803038:	00 00 00 
  80303b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803042:	00 00 00 
  803045:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803049:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803050:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803057:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80305e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803065:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80306c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803072:	48 89 ce             	mov    %rcx,%rsi
  803075:	89 c7                	mov    %eax,%edi
  803077:	48 b8 28 2f 80 00 00 	movabs $0x802f28,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803089:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80308f:	c9                   	leaveq 
  803090:	c3                   	retq   

0000000000803091 <printf>:

int
printf(const char *fmt, ...)
{
  803091:	55                   	push   %rbp
  803092:	48 89 e5             	mov    %rsp,%rbp
  803095:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80309c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8030a3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8030aa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8030b1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030b8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030bf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030c6:	84 c0                	test   %al,%al
  8030c8:	74 20                	je     8030ea <printf+0x59>
  8030ca:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030ce:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030d2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030d6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030da:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030de:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030e2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030e6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030ea:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030f1:	00 00 00 
  8030f4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030fb:	00 00 00 
  8030fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803102:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803109:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803110:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  803117:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80311e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803125:	48 89 c6             	mov    %rax,%rsi
  803128:	bf 01 00 00 00       	mov    $0x1,%edi
  80312d:	48 b8 28 2f 80 00 00 	movabs $0x802f28,%rax
  803134:	00 00 00 
  803137:	ff d0                	callq  *%rax
  803139:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  80313f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803145:	c9                   	leaveq 
  803146:	c3                   	retq   

0000000000803147 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803147:	55                   	push   %rbp
  803148:	48 89 e5             	mov    %rsp,%rbp
  80314b:	48 83 ec 20          	sub    $0x20,%rsp
  80314f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803152:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803156:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803159:	48 89 d6             	mov    %rdx,%rsi
  80315c:	89 c7                	mov    %eax,%edi
  80315e:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
  80316a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803171:	79 05                	jns    803178 <fd2sockid+0x31>
		return r;
  803173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803176:	eb 24                	jmp    80319c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803178:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317c:	8b 10                	mov    (%rax),%edx
  80317e:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803185:	00 00 00 
  803188:	8b 00                	mov    (%rax),%eax
  80318a:	39 c2                	cmp    %eax,%edx
  80318c:	74 07                	je     803195 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80318e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803193:	eb 07                	jmp    80319c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803199:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80319c:	c9                   	leaveq 
  80319d:	c3                   	retq   

000000000080319e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80319e:	55                   	push   %rbp
  80319f:	48 89 e5             	mov    %rsp,%rbp
  8031a2:	48 83 ec 20          	sub    $0x20,%rsp
  8031a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8031a9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031ad:	48 89 c7             	mov    %rax,%rdi
  8031b0:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
  8031bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c3:	78 26                	js     8031eb <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8031c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c9:	ba 07 04 00 00       	mov    $0x407,%edx
  8031ce:	48 89 c6             	mov    %rax,%rsi
  8031d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d6:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
  8031e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e9:	79 16                	jns    803201 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8031eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ee:	89 c7                	mov    %eax,%edi
  8031f0:	48 b8 ad 36 80 00 00 	movabs $0x8036ad,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
		return r;
  8031fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ff:	eb 3a                	jmp    80323b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803205:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80320c:	00 00 00 
  80320f:	8b 12                	mov    (%rdx),%edx
  803211:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803217:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80321e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803222:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803225:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322c:	48 89 c7             	mov    %rax,%rdi
  80322f:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
}
  80323b:	c9                   	leaveq 
  80323c:	c3                   	retq   

000000000080323d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80323d:	55                   	push   %rbp
  80323e:	48 89 e5             	mov    %rsp,%rbp
  803241:	48 83 ec 30          	sub    $0x30,%rsp
  803245:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803248:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80324c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803250:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803253:	89 c7                	mov    %eax,%edi
  803255:	48 b8 47 31 80 00 00 	movabs $0x803147,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
  803261:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803264:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803268:	79 05                	jns    80326f <accept+0x32>
		return r;
  80326a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326d:	eb 3b                	jmp    8032aa <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80326f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803273:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327a:	48 89 ce             	mov    %rcx,%rsi
  80327d:	89 c7                	mov    %eax,%edi
  80327f:	48 b8 8a 35 80 00 00 	movabs $0x80358a,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
  80328b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803292:	79 05                	jns    803299 <accept+0x5c>
		return r;
  803294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803297:	eb 11                	jmp    8032aa <accept+0x6d>
	return alloc_sockfd(r);
  803299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329c:	89 c7                	mov    %eax,%edi
  80329e:	48 b8 9e 31 80 00 00 	movabs $0x80319e,%rax
  8032a5:	00 00 00 
  8032a8:	ff d0                	callq  *%rax
}
  8032aa:	c9                   	leaveq 
  8032ab:	c3                   	retq   

00000000008032ac <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032ac:	55                   	push   %rbp
  8032ad:	48 89 e5             	mov    %rsp,%rbp
  8032b0:	48 83 ec 20          	sub    $0x20,%rsp
  8032b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032bb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032c1:	89 c7                	mov    %eax,%edi
  8032c3:	48 b8 47 31 80 00 00 	movabs $0x803147,%rax
  8032ca:	00 00 00 
  8032cd:	ff d0                	callq  *%rax
  8032cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d6:	79 05                	jns    8032dd <bind+0x31>
		return r;
  8032d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032db:	eb 1b                	jmp    8032f8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8032dd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e7:	48 89 ce             	mov    %rcx,%rsi
  8032ea:	89 c7                	mov    %eax,%edi
  8032ec:	48 b8 09 36 80 00 00 	movabs $0x803609,%rax
  8032f3:	00 00 00 
  8032f6:	ff d0                	callq  *%rax
}
  8032f8:	c9                   	leaveq 
  8032f9:	c3                   	retq   

00000000008032fa <shutdown>:

int
shutdown(int s, int how)
{
  8032fa:	55                   	push   %rbp
  8032fb:	48 89 e5             	mov    %rsp,%rbp
  8032fe:	48 83 ec 20          	sub    $0x20,%rsp
  803302:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803305:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803308:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80330b:	89 c7                	mov    %eax,%edi
  80330d:	48 b8 47 31 80 00 00 	movabs $0x803147,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
  803319:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803320:	79 05                	jns    803327 <shutdown+0x2d>
		return r;
  803322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803325:	eb 16                	jmp    80333d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803327:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80332a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332d:	89 d6                	mov    %edx,%esi
  80332f:	89 c7                	mov    %eax,%edi
  803331:	48 b8 6d 36 80 00 00 	movabs $0x80366d,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
}
  80333d:	c9                   	leaveq 
  80333e:	c3                   	retq   

000000000080333f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80333f:	55                   	push   %rbp
  803340:	48 89 e5             	mov    %rsp,%rbp
  803343:	48 83 ec 10          	sub    $0x10,%rsp
  803347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80334b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334f:	48 89 c7             	mov    %rax,%rdi
  803352:	48 b8 9d 44 80 00 00 	movabs $0x80449d,%rax
  803359:	00 00 00 
  80335c:	ff d0                	callq  *%rax
  80335e:	83 f8 01             	cmp    $0x1,%eax
  803361:	75 17                	jne    80337a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803367:	8b 40 0c             	mov    0xc(%rax),%eax
  80336a:	89 c7                	mov    %eax,%edi
  80336c:	48 b8 ad 36 80 00 00 	movabs $0x8036ad,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	eb 05                	jmp    80337f <devsock_close+0x40>
	else
		return 0;
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80337f:	c9                   	leaveq 
  803380:	c3                   	retq   

0000000000803381 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803381:	55                   	push   %rbp
  803382:	48 89 e5             	mov    %rsp,%rbp
  803385:	48 83 ec 20          	sub    $0x20,%rsp
  803389:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80338c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803390:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803393:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803396:	89 c7                	mov    %eax,%edi
  803398:	48 b8 47 31 80 00 00 	movabs $0x803147,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ab:	79 05                	jns    8033b2 <connect+0x31>
		return r;
  8033ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b0:	eb 1b                	jmp    8033cd <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8033b2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033bc:	48 89 ce             	mov    %rcx,%rsi
  8033bf:	89 c7                	mov    %eax,%edi
  8033c1:	48 b8 da 36 80 00 00 	movabs $0x8036da,%rax
  8033c8:	00 00 00 
  8033cb:	ff d0                	callq  *%rax
}
  8033cd:	c9                   	leaveq 
  8033ce:	c3                   	retq   

00000000008033cf <listen>:

int
listen(int s, int backlog)
{
  8033cf:	55                   	push   %rbp
  8033d0:	48 89 e5             	mov    %rsp,%rbp
  8033d3:	48 83 ec 20          	sub    $0x20,%rsp
  8033d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033da:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e0:	89 c7                	mov    %eax,%edi
  8033e2:	48 b8 47 31 80 00 00 	movabs $0x803147,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
  8033ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f5:	79 05                	jns    8033fc <listen+0x2d>
		return r;
  8033f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fa:	eb 16                	jmp    803412 <listen+0x43>
	return nsipc_listen(r, backlog);
  8033fc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803402:	89 d6                	mov    %edx,%esi
  803404:	89 c7                	mov    %eax,%edi
  803406:	48 b8 3e 37 80 00 00 	movabs $0x80373e,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
}
  803412:	c9                   	leaveq 
  803413:	c3                   	retq   

0000000000803414 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803414:	55                   	push   %rbp
  803415:	48 89 e5             	mov    %rsp,%rbp
  803418:	48 83 ec 20          	sub    $0x20,%rsp
  80341c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803420:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803424:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342c:	89 c2                	mov    %eax,%edx
  80342e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803432:	8b 40 0c             	mov    0xc(%rax),%eax
  803435:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803439:	b9 00 00 00 00       	mov    $0x0,%ecx
  80343e:	89 c7                	mov    %eax,%edi
  803440:	48 b8 7e 37 80 00 00 	movabs $0x80377e,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
}
  80344c:	c9                   	leaveq 
  80344d:	c3                   	retq   

000000000080344e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	48 83 ec 20          	sub    $0x20,%rsp
  803456:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80345a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80345e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803466:	89 c2                	mov    %eax,%edx
  803468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346c:	8b 40 0c             	mov    0xc(%rax),%eax
  80346f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803473:	b9 00 00 00 00       	mov    $0x0,%ecx
  803478:	89 c7                	mov    %eax,%edi
  80347a:	48 b8 4a 38 80 00 00 	movabs $0x80384a,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
}
  803486:	c9                   	leaveq 
  803487:	c3                   	retq   

0000000000803488 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803488:	55                   	push   %rbp
  803489:	48 89 e5             	mov    %rsp,%rbp
  80348c:	48 83 ec 10          	sub    $0x10,%rsp
  803490:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803494:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349c:	48 be d7 4b 80 00 00 	movabs $0x804bd7,%rsi
  8034a3:	00 00 00 
  8034a6:	48 89 c7             	mov    %rax,%rdi
  8034a9:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
	return 0;
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ba:	c9                   	leaveq 
  8034bb:	c3                   	retq   

00000000008034bc <socket>:

int
socket(int domain, int type, int protocol)
{
  8034bc:	55                   	push   %rbp
  8034bd:	48 89 e5             	mov    %rsp,%rbp
  8034c0:	48 83 ec 20          	sub    $0x20,%rsp
  8034c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034ca:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8034cd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034d0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d6:	89 ce                	mov    %ecx,%esi
  8034d8:	89 c7                	mov    %eax,%edi
  8034da:	48 b8 02 39 80 00 00 	movabs $0x803902,%rax
  8034e1:	00 00 00 
  8034e4:	ff d0                	callq  *%rax
  8034e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ed:	79 05                	jns    8034f4 <socket+0x38>
		return r;
  8034ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f2:	eb 11                	jmp    803505 <socket+0x49>
	return alloc_sockfd(r);
  8034f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f7:	89 c7                	mov    %eax,%edi
  8034f9:	48 b8 9e 31 80 00 00 	movabs $0x80319e,%rax
  803500:	00 00 00 
  803503:	ff d0                	callq  *%rax
}
  803505:	c9                   	leaveq 
  803506:	c3                   	retq   

0000000000803507 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803507:	55                   	push   %rbp
  803508:	48 89 e5             	mov    %rsp,%rbp
  80350b:	48 83 ec 10          	sub    $0x10,%rsp
  80350f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803512:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  803519:	00 00 00 
  80351c:	8b 00                	mov    (%rax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	75 1f                	jne    803541 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803522:	bf 02 00 00 00       	mov    $0x2,%edi
  803527:	48 b8 2c 44 80 00 00 	movabs $0x80442c,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
  803533:	89 c2                	mov    %eax,%edx
  803535:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  80353c:	00 00 00 
  80353f:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803541:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  803548:	00 00 00 
  80354b:	8b 00                	mov    (%rax),%eax
  80354d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803550:	b9 07 00 00 00       	mov    $0x7,%ecx
  803555:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80355c:	00 00 00 
  80355f:	89 c7                	mov    %eax,%edi
  803561:	48 b8 97 43 80 00 00 	movabs $0x804397,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80356d:	ba 00 00 00 00       	mov    $0x0,%edx
  803572:	be 00 00 00 00       	mov    $0x0,%esi
  803577:	bf 00 00 00 00       	mov    $0x0,%edi
  80357c:	48 b8 d6 42 80 00 00 	movabs $0x8042d6,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
}
  803588:	c9                   	leaveq 
  803589:	c3                   	retq   

000000000080358a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80358a:	55                   	push   %rbp
  80358b:	48 89 e5             	mov    %rsp,%rbp
  80358e:	48 83 ec 30          	sub    $0x30,%rsp
  803592:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803595:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803599:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80359d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a4:	00 00 00 
  8035a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035aa:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8035ac:	bf 01 00 00 00       	mov    $0x1,%edi
  8035b1:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  8035b8:	00 00 00 
  8035bb:	ff d0                	callq  *%rax
  8035bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c4:	78 3e                	js     803604 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8035c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035cd:	00 00 00 
  8035d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8035d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d8:	8b 40 10             	mov    0x10(%rax),%eax
  8035db:	89 c2                	mov    %eax,%edx
  8035dd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8035e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e5:	48 89 ce             	mov    %rcx,%rsi
  8035e8:	48 89 c7             	mov    %rax,%rdi
  8035eb:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8035f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fb:	8b 50 10             	mov    0x10(%rax),%edx
  8035fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803602:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803604:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803607:	c9                   	leaveq 
  803608:	c3                   	retq   

0000000000803609 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803609:	55                   	push   %rbp
  80360a:	48 89 e5             	mov    %rsp,%rbp
  80360d:	48 83 ec 10          	sub    $0x10,%rsp
  803611:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803614:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803618:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80361b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803622:	00 00 00 
  803625:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803628:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80362a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80362d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803631:	48 89 c6             	mov    %rax,%rsi
  803634:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80363b:	00 00 00 
  80363e:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80364a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803651:	00 00 00 
  803654:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803657:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80365a:	bf 02 00 00 00       	mov    $0x2,%edi
  80365f:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
}
  80366b:	c9                   	leaveq 
  80366c:	c3                   	retq   

000000000080366d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80366d:	55                   	push   %rbp
  80366e:	48 89 e5             	mov    %rsp,%rbp
  803671:	48 83 ec 10          	sub    $0x10,%rsp
  803675:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803678:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80367b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803682:	00 00 00 
  803685:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803688:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80368a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803691:	00 00 00 
  803694:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803697:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80369a:	bf 03 00 00 00       	mov    $0x3,%edi
  80369f:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
}
  8036ab:	c9                   	leaveq 
  8036ac:	c3                   	retq   

00000000008036ad <nsipc_close>:

int
nsipc_close(int s)
{
  8036ad:	55                   	push   %rbp
  8036ae:	48 89 e5             	mov    %rsp,%rbp
  8036b1:	48 83 ec 10          	sub    $0x10,%rsp
  8036b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8036b8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bf:	00 00 00 
  8036c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036c5:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8036c7:	bf 04 00 00 00       	mov    $0x4,%edi
  8036cc:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
}
  8036d8:	c9                   	leaveq 
  8036d9:	c3                   	retq   

00000000008036da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036da:	55                   	push   %rbp
  8036db:	48 89 e5             	mov    %rsp,%rbp
  8036de:	48 83 ec 10          	sub    $0x10,%rsp
  8036e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036e9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8036ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036f3:	00 00 00 
  8036f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036f9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036fb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803702:	48 89 c6             	mov    %rax,%rsi
  803705:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80370c:	00 00 00 
  80370f:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80371b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803722:	00 00 00 
  803725:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803728:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80372b:	bf 05 00 00 00       	mov    $0x5,%edi
  803730:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
}
  80373c:	c9                   	leaveq 
  80373d:	c3                   	retq   

000000000080373e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80373e:	55                   	push   %rbp
  80373f:	48 89 e5             	mov    %rsp,%rbp
  803742:	48 83 ec 10          	sub    $0x10,%rsp
  803746:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803749:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80374c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803753:	00 00 00 
  803756:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803759:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80375b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803762:	00 00 00 
  803765:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803768:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80376b:	bf 06 00 00 00       	mov    $0x6,%edi
  803770:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
}
  80377c:	c9                   	leaveq 
  80377d:	c3                   	retq   

000000000080377e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80377e:	55                   	push   %rbp
  80377f:	48 89 e5             	mov    %rsp,%rbp
  803782:	48 83 ec 30          	sub    $0x30,%rsp
  803786:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803789:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80378d:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803790:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803793:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379a:	00 00 00 
  80379d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037a0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8037a2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a9:	00 00 00 
  8037ac:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037af:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8037b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b9:	00 00 00 
  8037bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8037bf:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8037c2:	bf 07 00 00 00       	mov    $0x7,%edi
  8037c7:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
  8037d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037da:	78 69                	js     803845 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8037dc:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8037e3:	7f 08                	jg     8037ed <nsipc_recv+0x6f>
  8037e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8037eb:	7e 35                	jle    803822 <nsipc_recv+0xa4>
  8037ed:	48 b9 de 4b 80 00 00 	movabs $0x804bde,%rcx
  8037f4:	00 00 00 
  8037f7:	48 ba f3 4b 80 00 00 	movabs $0x804bf3,%rdx
  8037fe:	00 00 00 
  803801:	be 62 00 00 00       	mov    $0x62,%esi
  803806:	48 bf 08 4c 80 00 00 	movabs $0x804c08,%rdi
  80380d:	00 00 00 
  803810:	b8 00 00 00 00       	mov    $0x0,%eax
  803815:	49 b8 c2 41 80 00 00 	movabs $0x8041c2,%r8
  80381c:	00 00 00 
  80381f:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803822:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803825:	48 63 d0             	movslq %eax,%rdx
  803828:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80382c:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803833:	00 00 00 
  803836:	48 89 c7             	mov    %rax,%rdi
  803839:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
	}

	return r;
  803845:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803848:	c9                   	leaveq 
  803849:	c3                   	retq   

000000000080384a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80384a:	55                   	push   %rbp
  80384b:	48 89 e5             	mov    %rsp,%rbp
  80384e:	48 83 ec 20          	sub    $0x20,%rsp
  803852:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803855:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803859:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80385c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80385f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803866:	00 00 00 
  803869:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80386c:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80386e:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803875:	7e 35                	jle    8038ac <nsipc_send+0x62>
  803877:	48 b9 14 4c 80 00 00 	movabs $0x804c14,%rcx
  80387e:	00 00 00 
  803881:	48 ba f3 4b 80 00 00 	movabs $0x804bf3,%rdx
  803888:	00 00 00 
  80388b:	be 6d 00 00 00       	mov    $0x6d,%esi
  803890:	48 bf 08 4c 80 00 00 	movabs $0x804c08,%rdi
  803897:	00 00 00 
  80389a:	b8 00 00 00 00       	mov    $0x0,%eax
  80389f:	49 b8 c2 41 80 00 00 	movabs $0x8041c2,%r8
  8038a6:	00 00 00 
  8038a9:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038af:	48 63 d0             	movslq %eax,%rdx
  8038b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b6:	48 89 c6             	mov    %rax,%rsi
  8038b9:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8038c0:	00 00 00 
  8038c3:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8038cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d6:	00 00 00 
  8038d9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038dc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8038df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e6:	00 00 00 
  8038e9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038ec:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8038ef:	bf 08 00 00 00       	mov    $0x8,%edi
  8038f4:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  8038fb:	00 00 00 
  8038fe:	ff d0                	callq  *%rax
}
  803900:	c9                   	leaveq 
  803901:	c3                   	retq   

0000000000803902 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803902:	55                   	push   %rbp
  803903:	48 89 e5             	mov    %rsp,%rbp
  803906:	48 83 ec 10          	sub    $0x10,%rsp
  80390a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80390d:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803910:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803913:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80391a:	00 00 00 
  80391d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803920:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803922:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803929:	00 00 00 
  80392c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803932:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803939:	00 00 00 
  80393c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80393f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803942:	bf 09 00 00 00       	mov    $0x9,%edi
  803947:	48 b8 07 35 80 00 00 	movabs $0x803507,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
}
  803953:	c9                   	leaveq 
  803954:	c3                   	retq   

0000000000803955 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803955:	55                   	push   %rbp
  803956:	48 89 e5             	mov    %rsp,%rbp
  803959:	53                   	push   %rbx
  80395a:	48 83 ec 38          	sub    $0x38,%rsp
  80395e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803962:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803966:	48 89 c7             	mov    %rax,%rdi
  803969:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
  803975:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803978:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80397c:	0f 88 bf 01 00 00    	js     803b41 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803982:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803986:	ba 07 04 00 00       	mov    $0x407,%edx
  80398b:	48 89 c6             	mov    %rax,%rsi
  80398e:	bf 00 00 00 00       	mov    $0x0,%edi
  803993:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  80399a:	00 00 00 
  80399d:	ff d0                	callq  *%rax
  80399f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a6:	0f 88 95 01 00 00    	js     803b41 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039ac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039b0:	48 89 c7             	mov    %rax,%rdi
  8039b3:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  8039ba:	00 00 00 
  8039bd:	ff d0                	callq  *%rax
  8039bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039c6:	0f 88 5d 01 00 00    	js     803b29 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d0:	ba 07 04 00 00       	mov    $0x407,%edx
  8039d5:	48 89 c6             	mov    %rax,%rsi
  8039d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039dd:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  8039e4:	00 00 00 
  8039e7:	ff d0                	callq  *%rax
  8039e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f0:	0f 88 33 01 00 00    	js     803b29 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8039f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039fa:	48 89 c7             	mov    %rax,%rdi
  8039fd:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803a04:	00 00 00 
  803a07:	ff d0                	callq  *%rax
  803a09:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a11:	ba 07 04 00 00       	mov    $0x407,%edx
  803a16:	48 89 c6             	mov    %rax,%rsi
  803a19:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1e:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  803a25:	00 00 00 
  803a28:	ff d0                	callq  *%rax
  803a2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a31:	0f 88 d9 00 00 00    	js     803b10 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a3b:	48 89 c7             	mov    %rax,%rdi
  803a3e:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	48 89 c2             	mov    %rax,%rdx
  803a4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a51:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a57:	48 89 d1             	mov    %rdx,%rcx
  803a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  803a5f:	48 89 c6             	mov    %rax,%rsi
  803a62:	bf 00 00 00 00       	mov    $0x0,%edi
  803a67:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
  803a73:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a76:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7a:	78 79                	js     803af5 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a80:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a87:	00 00 00 
  803a8a:	8b 12                	mov    (%rdx),%edx
  803a8c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a9d:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803aa4:	00 00 00 
  803aa7:	8b 12                	mov    (%rdx),%edx
  803aa9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803aab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aaf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ab6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aba:	48 89 c7             	mov    %rax,%rdi
  803abd:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  803ac4:	00 00 00 
  803ac7:	ff d0                	callq  *%rax
  803ac9:	89 c2                	mov    %eax,%edx
  803acb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803acf:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ad1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ad5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ad9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803add:	48 89 c7             	mov    %rax,%rdi
  803ae0:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  803ae7:	00 00 00 
  803aea:	ff d0                	callq  *%rax
  803aec:	89 03                	mov    %eax,(%rbx)
	return 0;
  803aee:	b8 00 00 00 00       	mov    $0x0,%eax
  803af3:	eb 4f                	jmp    803b44 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803af5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803af6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afa:	48 89 c6             	mov    %rax,%rsi
  803afd:	bf 00 00 00 00       	mov    $0x0,%edi
  803b02:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
  803b0e:	eb 01                	jmp    803b11 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803b10:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b15:	48 89 c6             	mov    %rax,%rsi
  803b18:	bf 00 00 00 00       	mov    $0x0,%edi
  803b1d:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  803b24:	00 00 00 
  803b27:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b2d:	48 89 c6             	mov    %rax,%rsi
  803b30:	bf 00 00 00 00       	mov    $0x0,%edi
  803b35:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
err:
	return r;
  803b41:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b44:	48 83 c4 38          	add    $0x38,%rsp
  803b48:	5b                   	pop    %rbx
  803b49:	5d                   	pop    %rbp
  803b4a:	c3                   	retq   

0000000000803b4b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b4b:	55                   	push   %rbp
  803b4c:	48 89 e5             	mov    %rsp,%rbp
  803b4f:	53                   	push   %rbx
  803b50:	48 83 ec 28          	sub    $0x28,%rsp
  803b54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b58:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b5c:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803b63:	00 00 00 
  803b66:	48 8b 00             	mov    (%rax),%rax
  803b69:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b76:	48 89 c7             	mov    %rax,%rdi
  803b79:	48 b8 9d 44 80 00 00 	movabs $0x80449d,%rax
  803b80:	00 00 00 
  803b83:	ff d0                	callq  *%rax
  803b85:	89 c3                	mov    %eax,%ebx
  803b87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b8b:	48 89 c7             	mov    %rax,%rdi
  803b8e:	48 b8 9d 44 80 00 00 	movabs $0x80449d,%rax
  803b95:	00 00 00 
  803b98:	ff d0                	callq  *%rax
  803b9a:	39 c3                	cmp    %eax,%ebx
  803b9c:	0f 94 c0             	sete   %al
  803b9f:	0f b6 c0             	movzbl %al,%eax
  803ba2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ba5:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803bac:	00 00 00 
  803baf:	48 8b 00             	mov    (%rax),%rax
  803bb2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bb8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803bbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bbe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bc1:	75 05                	jne    803bc8 <_pipeisclosed+0x7d>
			return ret;
  803bc3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803bc6:	eb 4a                	jmp    803c12 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803bc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bcb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bce:	74 8c                	je     803b5c <_pipeisclosed+0x11>
  803bd0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803bd4:	75 86                	jne    803b5c <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803bd6:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803bdd:	00 00 00 
  803be0:	48 8b 00             	mov    (%rax),%rax
  803be3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803be9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803bec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bef:	89 c6                	mov    %eax,%esi
  803bf1:	48 bf 25 4c 80 00 00 	movabs $0x804c25,%rdi
  803bf8:	00 00 00 
  803bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803c00:	49 b8 f2 02 80 00 00 	movabs $0x8002f2,%r8
  803c07:	00 00 00 
  803c0a:	41 ff d0             	callq  *%r8
	}
  803c0d:	e9 4a ff ff ff       	jmpq   803b5c <_pipeisclosed+0x11>

}
  803c12:	48 83 c4 28          	add    $0x28,%rsp
  803c16:	5b                   	pop    %rbx
  803c17:	5d                   	pop    %rbp
  803c18:	c3                   	retq   

0000000000803c19 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c19:	55                   	push   %rbp
  803c1a:	48 89 e5             	mov    %rsp,%rbp
  803c1d:	48 83 ec 30          	sub    $0x30,%rsp
  803c21:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c24:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c28:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c2b:	48 89 d6             	mov    %rdx,%rsi
  803c2e:	89 c7                	mov    %eax,%edi
  803c30:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
  803c3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c43:	79 05                	jns    803c4a <pipeisclosed+0x31>
		return r;
  803c45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c48:	eb 31                	jmp    803c7b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4e:	48 89 c7             	mov    %rax,%rdi
  803c51:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803c58:	00 00 00 
  803c5b:	ff d0                	callq  *%rax
  803c5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c69:	48 89 d6             	mov    %rdx,%rsi
  803c6c:	48 89 c7             	mov    %rax,%rdi
  803c6f:	48 b8 4b 3b 80 00 00 	movabs $0x803b4b,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
}
  803c7b:	c9                   	leaveq 
  803c7c:	c3                   	retq   

0000000000803c7d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c7d:	55                   	push   %rbp
  803c7e:	48 89 e5             	mov    %rsp,%rbp
  803c81:	48 83 ec 40          	sub    $0x40,%rsp
  803c85:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c89:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c8d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c95:	48 89 c7             	mov    %rax,%rdi
  803c98:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ca8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803cb0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cb7:	00 
  803cb8:	e9 90 00 00 00       	jmpq   803d4d <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803cbd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803cc2:	74 09                	je     803ccd <devpipe_read+0x50>
				return i;
  803cc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc8:	e9 8e 00 00 00       	jmpq   803d5b <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ccd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd5:	48 89 d6             	mov    %rdx,%rsi
  803cd8:	48 89 c7             	mov    %rax,%rdi
  803cdb:	48 b8 4b 3b 80 00 00 	movabs $0x803b4b,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
  803ce7:	85 c0                	test   %eax,%eax
  803ce9:	74 07                	je     803cf2 <devpipe_read+0x75>
				return 0;
  803ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf0:	eb 69                	jmp    803d5b <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803cf2:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  803cf9:	00 00 00 
  803cfc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d02:	8b 10                	mov    (%rax),%edx
  803d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d08:	8b 40 04             	mov    0x4(%rax),%eax
  803d0b:	39 c2                	cmp    %eax,%edx
  803d0d:	74 ae                	je     803cbd <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d17:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1f:	8b 00                	mov    (%rax),%eax
  803d21:	99                   	cltd   
  803d22:	c1 ea 1b             	shr    $0x1b,%edx
  803d25:	01 d0                	add    %edx,%eax
  803d27:	83 e0 1f             	and    $0x1f,%eax
  803d2a:	29 d0                	sub    %edx,%eax
  803d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d30:	48 98                	cltq   
  803d32:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d37:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3d:	8b 00                	mov    (%rax),%eax
  803d3f:	8d 50 01             	lea    0x1(%rax),%edx
  803d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d46:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d48:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d51:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d55:	72 a7                	jb     803cfe <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803d5b:	c9                   	leaveq 
  803d5c:	c3                   	retq   

0000000000803d5d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d5d:	55                   	push   %rbp
  803d5e:	48 89 e5             	mov    %rsp,%rbp
  803d61:	48 83 ec 40          	sub    $0x40,%rsp
  803d65:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d69:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d6d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d90:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d97:	00 
  803d98:	e9 8f 00 00 00       	jmpq   803e2c <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803da1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803da5:	48 89 d6             	mov    %rdx,%rsi
  803da8:	48 89 c7             	mov    %rax,%rdi
  803dab:	48 b8 4b 3b 80 00 00 	movabs $0x803b4b,%rax
  803db2:	00 00 00 
  803db5:	ff d0                	callq  *%rax
  803db7:	85 c0                	test   %eax,%eax
  803db9:	74 07                	je     803dc2 <devpipe_write+0x65>
				return 0;
  803dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc0:	eb 78                	jmp    803e3a <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803dc2:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  803dc9:	00 00 00 
  803dcc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803dce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd2:	8b 40 04             	mov    0x4(%rax),%eax
  803dd5:	48 63 d0             	movslq %eax,%rdx
  803dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddc:	8b 00                	mov    (%rax),%eax
  803dde:	48 98                	cltq   
  803de0:	48 83 c0 20          	add    $0x20,%rax
  803de4:	48 39 c2             	cmp    %rax,%rdx
  803de7:	73 b4                	jae    803d9d <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803de9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ded:	8b 40 04             	mov    0x4(%rax),%eax
  803df0:	99                   	cltd   
  803df1:	c1 ea 1b             	shr    $0x1b,%edx
  803df4:	01 d0                	add    %edx,%eax
  803df6:	83 e0 1f             	and    $0x1f,%eax
  803df9:	29 d0                	sub    %edx,%eax
  803dfb:	89 c6                	mov    %eax,%esi
  803dfd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e05:	48 01 d0             	add    %rdx,%rax
  803e08:	0f b6 08             	movzbl (%rax),%ecx
  803e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e0f:	48 63 c6             	movslq %esi,%rax
  803e12:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1a:	8b 40 04             	mov    0x4(%rax),%eax
  803e1d:	8d 50 01             	lea    0x1(%rax),%edx
  803e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e24:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e27:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e30:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e34:	72 98                	jb     803dce <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803e3a:	c9                   	leaveq 
  803e3b:	c3                   	retq   

0000000000803e3c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e3c:	55                   	push   %rbp
  803e3d:	48 89 e5             	mov    %rsp,%rbp
  803e40:	48 83 ec 20          	sub    $0x20,%rsp
  803e44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e50:	48 89 c7             	mov    %rax,%rdi
  803e53:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803e5a:	00 00 00 
  803e5d:	ff d0                	callq  *%rax
  803e5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e67:	48 be 38 4c 80 00 00 	movabs $0x804c38,%rsi
  803e6e:	00 00 00 
  803e71:	48 89 c7             	mov    %rax,%rdi
  803e74:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  803e7b:	00 00 00 
  803e7e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e84:	8b 50 04             	mov    0x4(%rax),%edx
  803e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e8b:	8b 00                	mov    (%rax),%eax
  803e8d:	29 c2                	sub    %eax,%edx
  803e8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e93:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e9d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ea4:	00 00 00 
	stat->st_dev = &devpipe;
  803ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eab:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803eb2:	00 00 00 
  803eb5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec1:	c9                   	leaveq 
  803ec2:	c3                   	retq   

0000000000803ec3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ec3:	55                   	push   %rbp
  803ec4:	48 89 e5             	mov    %rsp,%rbp
  803ec7:	48 83 ec 10          	sub    $0x10,%rsp
  803ecb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed3:	48 89 c6             	mov    %rax,%rsi
  803ed6:	bf 00 00 00 00       	mov    $0x0,%edi
  803edb:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  803ee2:	00 00 00 
  803ee5:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803ee7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eeb:	48 89 c7             	mov    %rax,%rdi
  803eee:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
  803efa:	48 89 c6             	mov    %rax,%rsi
  803efd:	bf 00 00 00 00       	mov    $0x0,%edi
  803f02:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  803f09:	00 00 00 
  803f0c:	ff d0                	callq  *%rax
}
  803f0e:	c9                   	leaveq 
  803f0f:	c3                   	retq   

0000000000803f10 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f10:	55                   	push   %rbp
  803f11:	48 89 e5             	mov    %rsp,%rbp
  803f14:	48 83 ec 20          	sub    $0x20,%rsp
  803f18:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f1e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f21:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f25:	be 01 00 00 00       	mov    $0x1,%esi
  803f2a:	48 89 c7             	mov    %rax,%rdi
  803f2d:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  803f34:	00 00 00 
  803f37:	ff d0                	callq  *%rax
}
  803f39:	90                   	nop
  803f3a:	c9                   	leaveq 
  803f3b:	c3                   	retq   

0000000000803f3c <getchar>:

int
getchar(void)
{
  803f3c:	55                   	push   %rbp
  803f3d:	48 89 e5             	mov    %rsp,%rbp
  803f40:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f44:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803f48:	ba 01 00 00 00       	mov    $0x1,%edx
  803f4d:	48 89 c6             	mov    %rax,%rsi
  803f50:	bf 00 00 00 00       	mov    $0x0,%edi
  803f55:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  803f5c:	00 00 00 
  803f5f:	ff d0                	callq  *%rax
  803f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f68:	79 05                	jns    803f6f <getchar+0x33>
		return r;
  803f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6d:	eb 14                	jmp    803f83 <getchar+0x47>
	if (r < 1)
  803f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f73:	7f 07                	jg     803f7c <getchar+0x40>
		return -E_EOF;
  803f75:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f7a:	eb 07                	jmp    803f83 <getchar+0x47>
	return c;
  803f7c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f80:	0f b6 c0             	movzbl %al,%eax

}
  803f83:	c9                   	leaveq 
  803f84:	c3                   	retq   

0000000000803f85 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f85:	55                   	push   %rbp
  803f86:	48 89 e5             	mov    %rsp,%rbp
  803f89:	48 83 ec 20          	sub    $0x20,%rsp
  803f8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f97:	48 89 d6             	mov    %rdx,%rsi
  803f9a:	89 c7                	mov    %eax,%edi
  803f9c:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  803fa3:	00 00 00 
  803fa6:	ff d0                	callq  *%rax
  803fa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803faf:	79 05                	jns    803fb6 <iscons+0x31>
		return r;
  803fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb4:	eb 1a                	jmp    803fd0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fba:	8b 10                	mov    (%rax),%edx
  803fbc:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803fc3:	00 00 00 
  803fc6:	8b 00                	mov    (%rax),%eax
  803fc8:	39 c2                	cmp    %eax,%edx
  803fca:	0f 94 c0             	sete   %al
  803fcd:	0f b6 c0             	movzbl %al,%eax
}
  803fd0:	c9                   	leaveq 
  803fd1:	c3                   	retq   

0000000000803fd2 <opencons>:

int
opencons(void)
{
  803fd2:	55                   	push   %rbp
  803fd3:	48 89 e5             	mov    %rsp,%rbp
  803fd6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803fda:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803fde:	48 89 c7             	mov    %rax,%rdi
  803fe1:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  803fe8:	00 00 00 
  803feb:	ff d0                	callq  *%rax
  803fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ff4:	79 05                	jns    803ffb <opencons+0x29>
		return r;
  803ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff9:	eb 5b                	jmp    804056 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fff:	ba 07 04 00 00       	mov    $0x407,%edx
  804004:	48 89 c6             	mov    %rax,%rsi
  804007:	bf 00 00 00 00       	mov    $0x0,%edi
  80400c:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80401b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401f:	79 05                	jns    804026 <opencons+0x54>
		return r;
  804021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804024:	eb 30                	jmp    804056 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804026:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80402a:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804031:	00 00 00 
  804034:	8b 12                	mov    (%rdx),%edx
  804036:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804047:	48 89 c7             	mov    %rax,%rdi
  80404a:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  804051:	00 00 00 
  804054:	ff d0                	callq  *%rax
}
  804056:	c9                   	leaveq 
  804057:	c3                   	retq   

0000000000804058 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804058:	55                   	push   %rbp
  804059:	48 89 e5             	mov    %rsp,%rbp
  80405c:	48 83 ec 30          	sub    $0x30,%rsp
  804060:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804064:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804068:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80406c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804071:	75 13                	jne    804086 <devcons_read+0x2e>
		return 0;
  804073:	b8 00 00 00 00       	mov    $0x0,%eax
  804078:	eb 49                	jmp    8040c3 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80407a:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804086:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  80408d:	00 00 00 
  804090:	ff d0                	callq  *%rax
  804092:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804099:	74 df                	je     80407a <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80409b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409f:	79 05                	jns    8040a6 <devcons_read+0x4e>
		return c;
  8040a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a4:	eb 1d                	jmp    8040c3 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8040a6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8040aa:	75 07                	jne    8040b3 <devcons_read+0x5b>
		return 0;
  8040ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b1:	eb 10                	jmp    8040c3 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8040b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b6:	89 c2                	mov    %eax,%edx
  8040b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040bc:	88 10                	mov    %dl,(%rax)
	return 1;
  8040be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8040c3:	c9                   	leaveq 
  8040c4:	c3                   	retq   

00000000008040c5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040c5:	55                   	push   %rbp
  8040c6:	48 89 e5             	mov    %rsp,%rbp
  8040c9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8040d0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8040d7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8040de:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040ec:	eb 76                	jmp    804164 <devcons_write+0x9f>
		m = n - tot;
  8040ee:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8040f5:	89 c2                	mov    %eax,%edx
  8040f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040fa:	29 c2                	sub    %eax,%edx
  8040fc:	89 d0                	mov    %edx,%eax
  8040fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804101:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804104:	83 f8 7f             	cmp    $0x7f,%eax
  804107:	76 07                	jbe    804110 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804109:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804110:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804113:	48 63 d0             	movslq %eax,%rdx
  804116:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804119:	48 63 c8             	movslq %eax,%rcx
  80411c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804123:	48 01 c1             	add    %rax,%rcx
  804126:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80412d:	48 89 ce             	mov    %rcx,%rsi
  804130:	48 89 c7             	mov    %rax,%rdi
  804133:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80413f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804142:	48 63 d0             	movslq %eax,%rdx
  804145:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80414c:	48 89 d6             	mov    %rdx,%rsi
  80414f:	48 89 c7             	mov    %rax,%rdi
  804152:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  804159:	00 00 00 
  80415c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80415e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804161:	01 45 fc             	add    %eax,-0x4(%rbp)
  804164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804167:	48 98                	cltq   
  804169:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804170:	0f 82 78 ff ff ff    	jb     8040ee <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804176:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804179:	c9                   	leaveq 
  80417a:	c3                   	retq   

000000000080417b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80417b:	55                   	push   %rbp
  80417c:	48 89 e5             	mov    %rsp,%rbp
  80417f:	48 83 ec 08          	sub    $0x8,%rsp
  804183:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804187:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80418c:	c9                   	leaveq 
  80418d:	c3                   	retq   

000000000080418e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80418e:	55                   	push   %rbp
  80418f:	48 89 e5             	mov    %rsp,%rbp
  804192:	48 83 ec 10          	sub    $0x10,%rsp
  804196:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80419a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80419e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a2:	48 be 44 4c 80 00 00 	movabs $0x804c44,%rsi
  8041a9:	00 00 00 
  8041ac:	48 89 c7             	mov    %rax,%rdi
  8041af:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  8041b6:	00 00 00 
  8041b9:	ff d0                	callq  *%rax
	return 0;
  8041bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041c0:	c9                   	leaveq 
  8041c1:	c3                   	retq   

00000000008041c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8041c2:	55                   	push   %rbp
  8041c3:	48 89 e5             	mov    %rsp,%rbp
  8041c6:	53                   	push   %rbx
  8041c7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8041ce:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8041d5:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8041db:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8041e2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8041e9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8041f0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8041f7:	84 c0                	test   %al,%al
  8041f9:	74 23                	je     80421e <_panic+0x5c>
  8041fb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804202:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804206:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80420a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80420e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804212:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804216:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80421a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80421e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804225:	00 00 00 
  804228:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80422f:	00 00 00 
  804232:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804236:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80423d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804244:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80424b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804252:	00 00 00 
  804255:	48 8b 18             	mov    (%rax),%rbx
  804258:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
  804264:	89 c6                	mov    %eax,%esi
  804266:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80426c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804273:	41 89 d0             	mov    %edx,%r8d
  804276:	48 89 c1             	mov    %rax,%rcx
  804279:	48 89 da             	mov    %rbx,%rdx
  80427c:	48 bf 50 4c 80 00 00 	movabs $0x804c50,%rdi
  804283:	00 00 00 
  804286:	b8 00 00 00 00       	mov    $0x0,%eax
  80428b:	49 b9 f2 02 80 00 00 	movabs $0x8002f2,%r9
  804292:	00 00 00 
  804295:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804298:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80429f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8042a6:	48 89 d6             	mov    %rdx,%rsi
  8042a9:	48 89 c7             	mov    %rax,%rdi
  8042ac:	48 b8 46 02 80 00 00 	movabs $0x800246,%rax
  8042b3:	00 00 00 
  8042b6:	ff d0                	callq  *%rax
	cprintf("\n");
  8042b8:	48 bf 73 4c 80 00 00 	movabs $0x804c73,%rdi
  8042bf:	00 00 00 
  8042c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c7:	48 ba f2 02 80 00 00 	movabs $0x8002f2,%rdx
  8042ce:	00 00 00 
  8042d1:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8042d3:	cc                   	int3   
  8042d4:	eb fd                	jmp    8042d3 <_panic+0x111>

00000000008042d6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8042d6:	55                   	push   %rbp
  8042d7:	48 89 e5             	mov    %rsp,%rbp
  8042da:	48 83 ec 30          	sub    $0x30,%rsp
  8042de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8042ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042ef:	75 0e                	jne    8042ff <ipc_recv+0x29>
		pg = (void*) UTOP;
  8042f1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8042f8:	00 00 00 
  8042fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8042ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804303:	48 89 c7             	mov    %rax,%rdi
  804306:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  80430d:	00 00 00 
  804310:	ff d0                	callq  *%rax
  804312:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804315:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804319:	79 27                	jns    804342 <ipc_recv+0x6c>
		if (from_env_store)
  80431b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804320:	74 0a                	je     80432c <ipc_recv+0x56>
			*from_env_store = 0;
  804322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804326:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80432c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804331:	74 0a                	je     80433d <ipc_recv+0x67>
			*perm_store = 0;
  804333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804337:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80433d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804340:	eb 53                	jmp    804395 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804342:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804347:	74 19                	je     804362 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804349:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804350:	00 00 00 
  804353:	48 8b 00             	mov    (%rax),%rax
  804356:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80435c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804360:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804362:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804367:	74 19                	je     804382 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804369:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804370:	00 00 00 
  804373:	48 8b 00             	mov    (%rax),%rax
  804376:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80437c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804380:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804382:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804389:	00 00 00 
  80438c:	48 8b 00             	mov    (%rax),%rax
  80438f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804395:	c9                   	leaveq 
  804396:	c3                   	retq   

0000000000804397 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804397:	55                   	push   %rbp
  804398:	48 89 e5             	mov    %rsp,%rbp
  80439b:	48 83 ec 30          	sub    $0x30,%rsp
  80439f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8043a5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8043a9:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8043ac:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043b1:	75 1c                	jne    8043cf <ipc_send+0x38>
		pg = (void*) UTOP;
  8043b3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043ba:	00 00 00 
  8043bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8043c1:	eb 0c                	jmp    8043cf <ipc_send+0x38>
		sys_yield();
  8043c3:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  8043ca:	00 00 00 
  8043cd:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8043cf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8043d2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8043d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8043d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043dc:	89 c7                	mov    %eax,%edi
  8043de:	48 b8 f9 1a 80 00 00 	movabs $0x801af9,%rax
  8043e5:	00 00 00 
  8043e8:	ff d0                	callq  *%rax
  8043ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ed:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8043f1:	74 d0                	je     8043c3 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8043f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f7:	79 30                	jns    804429 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8043f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043fc:	89 c1                	mov    %eax,%ecx
  8043fe:	48 ba 75 4c 80 00 00 	movabs $0x804c75,%rdx
  804405:	00 00 00 
  804408:	be 47 00 00 00       	mov    $0x47,%esi
  80440d:	48 bf 8b 4c 80 00 00 	movabs $0x804c8b,%rdi
  804414:	00 00 00 
  804417:	b8 00 00 00 00       	mov    $0x0,%eax
  80441c:	49 b8 c2 41 80 00 00 	movabs $0x8041c2,%r8
  804423:	00 00 00 
  804426:	41 ff d0             	callq  *%r8

}
  804429:	90                   	nop
  80442a:	c9                   	leaveq 
  80442b:	c3                   	retq   

000000000080442c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80442c:	55                   	push   %rbp
  80442d:	48 89 e5             	mov    %rsp,%rbp
  804430:	48 83 ec 18          	sub    $0x18,%rsp
  804434:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80443e:	eb 4d                	jmp    80448d <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804440:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804447:	00 00 00 
  80444a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80444d:	48 98                	cltq   
  80444f:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804456:	48 01 d0             	add    %rdx,%rax
  804459:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80445f:	8b 00                	mov    (%rax),%eax
  804461:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804464:	75 23                	jne    804489 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804466:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80446d:	00 00 00 
  804470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804473:	48 98                	cltq   
  804475:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80447c:	48 01 d0             	add    %rdx,%rax
  80447f:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804485:	8b 00                	mov    (%rax),%eax
  804487:	eb 12                	jmp    80449b <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804489:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80448d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804494:	7e aa                	jle    804440 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80449b:	c9                   	leaveq 
  80449c:	c3                   	retq   

000000000080449d <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80449d:	55                   	push   %rbp
  80449e:	48 89 e5             	mov    %rsp,%rbp
  8044a1:	48 83 ec 18          	sub    $0x18,%rsp
  8044a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8044a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ad:	48 c1 e8 15          	shr    $0x15,%rax
  8044b1:	48 89 c2             	mov    %rax,%rdx
  8044b4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044bb:	01 00 00 
  8044be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044c2:	83 e0 01             	and    $0x1,%eax
  8044c5:	48 85 c0             	test   %rax,%rax
  8044c8:	75 07                	jne    8044d1 <pageref+0x34>
		return 0;
  8044ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8044cf:	eb 56                	jmp    804527 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8044d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d5:	48 c1 e8 0c          	shr    $0xc,%rax
  8044d9:	48 89 c2             	mov    %rax,%rdx
  8044dc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044e3:	01 00 00 
  8044e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f2:	83 e0 01             	and    $0x1,%eax
  8044f5:	48 85 c0             	test   %rax,%rax
  8044f8:	75 07                	jne    804501 <pageref+0x64>
		return 0;
  8044fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ff:	eb 26                	jmp    804527 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804501:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804505:	48 c1 e8 0c          	shr    $0xc,%rax
  804509:	48 89 c2             	mov    %rax,%rdx
  80450c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804513:	00 00 00 
  804516:	48 c1 e2 04          	shl    $0x4,%rdx
  80451a:	48 01 d0             	add    %rdx,%rax
  80451d:	48 83 c0 08          	add    $0x8,%rax
  804521:	0f b7 00             	movzwl (%rax),%eax
  804524:	0f b7 c0             	movzwl %ax,%eax
}
  804527:	c9                   	leaveq 
  804528:	c3                   	retq   
