
obj/user/spawnhello:     file format elf64-x86-64


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
  80003c:	e8 a7 00 00 00       	callq  8000e8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 1e 4c 80 00 00 	movabs $0x804c1e,%rsi
  80008e:	00 00 00 
  800091:	48 bf 24 4c 80 00 00 	movabs $0x804c24,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 13 31 80 00 00 	movabs $0x803113,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba 2f 4c 80 00 00 	movabs $0x804c2f,%rdx
  8000c1:	00 00 00 
  8000c4:	be 0a 00 00 00       	mov    $0xa,%esi
  8000c9:	48 bf 47 4c 80 00 00 	movabs $0x804c47,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	90                   	nop
  8000e6:	c9                   	leaveq 
  8000e7:	c3                   	retq   

00000000008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %rbp
  8000e9:	48 89 e5             	mov    %rsp,%rbp
  8000ec:	48 83 ec 10          	sub    $0x10,%rsp
  8000f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8000f7:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  8000fe:	00 00 00 
  800101:	ff d0                	callq  *%rax
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	48 98                	cltq   
  80010a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800111:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800118:	00 00 00 
  80011b:	48 01 c2             	add    %rax,%rdx
  80011e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800125:	00 00 00 
  800128:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012f:	7e 14                	jle    800145 <libmain+0x5d>
		binaryname = argv[0];
  800131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800135:	48 8b 10             	mov    (%rax),%rdx
  800138:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80013f:	00 00 00 
  800142:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800145:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014c:	48 89 d6             	mov    %rdx,%rsi
  80014f:	89 c7                	mov    %eax,%edi
  800151:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80015d:	48 b8 6c 01 80 00 00 	movabs $0x80016c,%rax
  800164:	00 00 00 
  800167:	ff d0                	callq  *%rax
}
  800169:	90                   	nop
  80016a:	c9                   	leaveq 
  80016b:	c3                   	retq   

000000000080016c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016c:	55                   	push   %rbp
  80016d:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800170:	48 b8 cb 20 80 00 00 	movabs $0x8020cb,%rax
  800177:	00 00 00 
  80017a:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80017c:	bf 00 00 00 00       	mov    $0x0,%edi
  800181:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  800188:	00 00 00 
  80018b:	ff d0                	callq  *%rax
}
  80018d:	90                   	nop
  80018e:	5d                   	pop    %rbp
  80018f:	c3                   	retq   

0000000000800190 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
  800194:	53                   	push   %rbx
  800195:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80019c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001a3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001a9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8001b0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001b7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001be:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001c5:	84 c0                	test   %al,%al
  8001c7:	74 23                	je     8001ec <_panic+0x5c>
  8001c9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001d0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001d4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001d8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001dc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001e0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001e4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001e8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001ec:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001f3:	00 00 00 
  8001f6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8001fd:	00 00 00 
  800200:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800204:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80020b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800212:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800219:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800220:	00 00 00 
  800223:	48 8b 18             	mov    (%rax),%rbx
  800226:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
  800232:	89 c6                	mov    %eax,%esi
  800234:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80023a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800241:	41 89 d0             	mov    %edx,%r8d
  800244:	48 89 c1             	mov    %rax,%rcx
  800247:	48 89 da             	mov    %rbx,%rdx
  80024a:	48 bf 68 4c 80 00 00 	movabs $0x804c68,%rdi
  800251:	00 00 00 
  800254:	b8 00 00 00 00       	mov    $0x0,%eax
  800259:	49 b9 ca 03 80 00 00 	movabs $0x8003ca,%r9
  800260:	00 00 00 
  800263:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800266:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80026d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800274:	48 89 d6             	mov    %rdx,%rsi
  800277:	48 89 c7             	mov    %rax,%rdi
  80027a:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  800281:	00 00 00 
  800284:	ff d0                	callq  *%rax
	cprintf("\n");
  800286:	48 bf 8b 4c 80 00 00 	movabs $0x804c8b,%rdi
  80028d:	00 00 00 
  800290:	b8 00 00 00 00       	mov    $0x0,%eax
  800295:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80029c:	00 00 00 
  80029f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a1:	cc                   	int3   
  8002a2:	eb fd                	jmp    8002a1 <_panic+0x111>

00000000008002a4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a4:	55                   	push   %rbp
  8002a5:	48 89 e5             	mov    %rsp,%rbp
  8002a8:	48 83 ec 10          	sub    $0x10,%rsp
  8002ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b7:	8b 00                	mov    (%rax),%eax
  8002b9:	8d 48 01             	lea    0x1(%rax),%ecx
  8002bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c0:	89 0a                	mov    %ecx,(%rdx)
  8002c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002c5:	89 d1                	mov    %edx,%ecx
  8002c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002cb:	48 98                	cltq   
  8002cd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d5:	8b 00                	mov    (%rax),%eax
  8002d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dc:	75 2c                	jne    80030a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e2:	8b 00                	mov    (%rax),%eax
  8002e4:	48 98                	cltq   
  8002e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ea:	48 83 c2 08          	add    $0x8,%rdx
  8002ee:	48 89 c6             	mov    %rax,%rsi
  8002f1:	48 89 d7             	mov    %rdx,%rdi
  8002f4:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8002fb:	00 00 00 
  8002fe:	ff d0                	callq  *%rax
        b->idx = 0;
  800300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800304:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80030a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030e:	8b 40 04             	mov    0x4(%rax),%eax
  800311:	8d 50 01             	lea    0x1(%rax),%edx
  800314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800318:	89 50 04             	mov    %edx,0x4(%rax)
}
  80031b:	90                   	nop
  80031c:	c9                   	leaveq 
  80031d:	c3                   	retq   

000000000080031e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80031e:	55                   	push   %rbp
  80031f:	48 89 e5             	mov    %rsp,%rbp
  800322:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800329:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800330:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800337:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80033e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800345:	48 8b 0a             	mov    (%rdx),%rcx
  800348:	48 89 08             	mov    %rcx,(%rax)
  80034b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800353:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800357:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80035b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800362:	00 00 00 
    b.cnt = 0;
  800365:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80036c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80036f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800376:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80037d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800384:	48 89 c6             	mov    %rax,%rsi
  800387:	48 bf a4 02 80 00 00 	movabs $0x8002a4,%rdi
  80038e:	00 00 00 
  800391:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80039d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a3:	48 98                	cltq   
  8003a5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003ac:	48 83 c2 08          	add    $0x8,%rdx
  8003b0:	48 89 c6             	mov    %rax,%rsi
  8003b3:	48 89 d7             	mov    %rdx,%rdi
  8003b6:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003c8:	c9                   	leaveq 
  8003c9:	c3                   	retq   

00000000008003ca <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003ca:	55                   	push   %rbp
  8003cb:	48 89 e5             	mov    %rsp,%rbp
  8003ce:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8003dc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003ea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003f1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003ff:	84 c0                	test   %al,%al
  800401:	74 20                	je     800423 <cprintf+0x59>
  800403:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800407:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80040b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80040f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800413:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800417:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80041b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80041f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800423:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042a:	00 00 00 
  80042d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800434:	00 00 00 
  800437:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800442:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800449:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800450:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800457:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80045e:	48 8b 0a             	mov    (%rdx),%rcx
  800461:	48 89 08             	mov    %rcx,(%rax)
  800464:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800468:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80046c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800470:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800474:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80047b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800482:	48 89 d6             	mov    %rdx,%rsi
  800485:	48 89 c7             	mov    %rax,%rdi
  800488:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
  800494:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80049a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a0:	c9                   	leaveq 
  8004a1:	c3                   	retq   

00000000008004a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	48 83 ec 30          	sub    $0x30,%rsp
  8004aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004b6:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8004b9:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004bd:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004c4:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004c8:	77 54                	ja     80051e <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ca:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004cd:	8d 78 ff             	lea    -0x1(%rax),%edi
  8004d0:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8004d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dc:	48 f7 f6             	div    %rsi
  8004df:	49 89 c2             	mov    %rax,%r10
  8004e2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8004e5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004e8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8004ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f0:	41 89 c9             	mov    %ecx,%r9d
  8004f3:	41 89 f8             	mov    %edi,%r8d
  8004f6:	89 d1                	mov    %edx,%ecx
  8004f8:	4c 89 d2             	mov    %r10,%rdx
  8004fb:	48 89 c7             	mov    %rax,%rdi
  8004fe:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  800505:	00 00 00 
  800508:	ff d0                	callq  *%rax
  80050a:	eb 1c                	jmp    800528 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800510:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800517:	48 89 ce             	mov    %rcx,%rsi
  80051a:	89 d7                	mov    %edx,%edi
  80051c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800522:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800526:	7f e4                	jg     80050c <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800528:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80052b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
  800534:	48 f7 f1             	div    %rcx
  800537:	48 b8 90 4e 80 00 00 	movabs $0x804e90,%rax
  80053e:	00 00 00 
  800541:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800545:	0f be d0             	movsbl %al,%edx
  800548:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80054c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800550:	48 89 ce             	mov    %rcx,%rsi
  800553:	89 d7                	mov    %edx,%edi
  800555:	ff d0                	callq  *%rax
}
  800557:	90                   	nop
  800558:	c9                   	leaveq 
  800559:	c3                   	retq   

000000000080055a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80055a:	55                   	push   %rbp
  80055b:	48 89 e5             	mov    %rsp,%rbp
  80055e:	48 83 ec 20          	sub    $0x20,%rsp
  800562:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800566:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800569:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056d:	7e 4f                	jle    8005be <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	83 f8 30             	cmp    $0x30,%eax
  800578:	73 24                	jae    80059e <getuint+0x44>
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
  80059c:	eb 14                	jmp    8005b2 <getuint+0x58>
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005a6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b2:	48 8b 00             	mov    (%rax),%rax
  8005b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b9:	e9 9d 00 00 00       	jmpq   80065b <getuint+0x101>
	else if (lflag)
  8005be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c2:	74 4c                	je     800610 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	8b 00                	mov    (%rax),%eax
  8005ca:	83 f8 30             	cmp    $0x30,%eax
  8005cd:	73 24                	jae    8005f3 <getuint+0x99>
  8005cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	89 c0                	mov    %eax,%eax
  8005df:	48 01 d0             	add    %rdx,%rax
  8005e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e6:	8b 12                	mov    (%rdx),%edx
  8005e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ef:	89 0a                	mov    %ecx,(%rdx)
  8005f1:	eb 14                	jmp    800607 <getuint+0xad>
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005fb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800603:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800607:	48 8b 00             	mov    (%rax),%rax
  80060a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80060e:	eb 4b                	jmp    80065b <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800614:	8b 00                	mov    (%rax),%eax
  800616:	83 f8 30             	cmp    $0x30,%eax
  800619:	73 24                	jae    80063f <getuint+0xe5>
  80061b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800627:	8b 00                	mov    (%rax),%eax
  800629:	89 c0                	mov    %eax,%eax
  80062b:	48 01 d0             	add    %rdx,%rax
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	8b 12                	mov    (%rdx),%edx
  800634:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800637:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063b:	89 0a                	mov    %ecx,(%rdx)
  80063d:	eb 14                	jmp    800653 <getuint+0xf9>
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	48 8b 40 08          	mov    0x8(%rax),%rax
  800647:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80064b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800653:	8b 00                	mov    (%rax),%eax
  800655:	89 c0                	mov    %eax,%eax
  800657:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80065b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80065f:	c9                   	leaveq 
  800660:	c3                   	retq   

0000000000800661 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800661:	55                   	push   %rbp
  800662:	48 89 e5             	mov    %rsp,%rbp
  800665:	48 83 ec 20          	sub    $0x20,%rsp
  800669:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80066d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800670:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800674:	7e 4f                	jle    8006c5 <getint+0x64>
		x=va_arg(*ap, long long);
  800676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067a:	8b 00                	mov    (%rax),%eax
  80067c:	83 f8 30             	cmp    $0x30,%eax
  80067f:	73 24                	jae    8006a5 <getint+0x44>
  800681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800685:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	8b 00                	mov    (%rax),%eax
  80068f:	89 c0                	mov    %eax,%eax
  800691:	48 01 d0             	add    %rdx,%rax
  800694:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800698:	8b 12                	mov    (%rdx),%edx
  80069a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	89 0a                	mov    %ecx,(%rdx)
  8006a3:	eb 14                	jmp    8006b9 <getint+0x58>
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006ad:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b9:	48 8b 00             	mov    (%rax),%rax
  8006bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c0:	e9 9d 00 00 00       	jmpq   800762 <getint+0x101>
	else if (lflag)
  8006c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006c9:	74 4c                	je     800717 <getint+0xb6>
		x=va_arg(*ap, long);
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	8b 00                	mov    (%rax),%eax
  8006d1:	83 f8 30             	cmp    $0x30,%eax
  8006d4:	73 24                	jae    8006fa <getint+0x99>
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	8b 00                	mov    (%rax),%eax
  8006e4:	89 c0                	mov    %eax,%eax
  8006e6:	48 01 d0             	add    %rdx,%rax
  8006e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ed:	8b 12                	mov    (%rdx),%edx
  8006ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f6:	89 0a                	mov    %ecx,(%rdx)
  8006f8:	eb 14                	jmp    80070e <getint+0xad>
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	48 8b 40 08          	mov    0x8(%rax),%rax
  800702:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80070e:	48 8b 00             	mov    (%rax),%rax
  800711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800715:	eb 4b                	jmp    800762 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	83 f8 30             	cmp    $0x30,%eax
  800720:	73 24                	jae    800746 <getint+0xe5>
  800722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800726:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80072a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072e:	8b 00                	mov    (%rax),%eax
  800730:	89 c0                	mov    %eax,%eax
  800732:	48 01 d0             	add    %rdx,%rax
  800735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800739:	8b 12                	mov    (%rdx),%edx
  80073b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80073e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800742:	89 0a                	mov    %ecx,(%rdx)
  800744:	eb 14                	jmp    80075a <getint+0xf9>
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80074e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800752:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800756:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80075a:	8b 00                	mov    (%rax),%eax
  80075c:	48 98                	cltq   
  80075e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800762:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800766:	c9                   	leaveq 
  800767:	c3                   	retq   

0000000000800768 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800768:	55                   	push   %rbp
  800769:	48 89 e5             	mov    %rsp,%rbp
  80076c:	41 54                	push   %r12
  80076e:	53                   	push   %rbx
  80076f:	48 83 ec 60          	sub    $0x60,%rsp
  800773:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800777:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80077b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80077f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800783:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800787:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80078b:	48 8b 0a             	mov    (%rdx),%rcx
  80078e:	48 89 08             	mov    %rcx,(%rax)
  800791:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800795:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800799:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80079d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a1:	eb 17                	jmp    8007ba <vprintfmt+0x52>
			if (ch == '\0')
  8007a3:	85 db                	test   %ebx,%ebx
  8007a5:	0f 84 b9 04 00 00    	je     800c64 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8007ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007b3:	48 89 d6             	mov    %rdx,%rsi
  8007b6:	89 df                	mov    %ebx,%edi
  8007b8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007c2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007c6:	0f b6 00             	movzbl (%rax),%eax
  8007c9:	0f b6 d8             	movzbl %al,%ebx
  8007cc:	83 fb 25             	cmp    $0x25,%ebx
  8007cf:	75 d2                	jne    8007a3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007d5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007ea:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007f9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007fd:	0f b6 00             	movzbl (%rax),%eax
  800800:	0f b6 d8             	movzbl %al,%ebx
  800803:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800806:	83 f8 55             	cmp    $0x55,%eax
  800809:	0f 87 22 04 00 00    	ja     800c31 <vprintfmt+0x4c9>
  80080f:	89 c0                	mov    %eax,%eax
  800811:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800818:	00 
  800819:	48 b8 b8 4e 80 00 00 	movabs $0x804eb8,%rax
  800820:	00 00 00 
  800823:	48 01 d0             	add    %rdx,%rax
  800826:	48 8b 00             	mov    (%rax),%rax
  800829:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80082f:	eb c0                	jmp    8007f1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800835:	eb ba                	jmp    8007f1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800852:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800856:	0f b6 00             	movzbl (%rax),%eax
  800859:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085c:	83 fb 2f             	cmp    $0x2f,%ebx
  80085f:	7e 60                	jle    8008c1 <vprintfmt+0x159>
  800861:	83 fb 39             	cmp    $0x39,%ebx
  800864:	7f 5b                	jg     8008c1 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800866:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80086b:	eb d1                	jmp    80083e <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80086d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800870:	83 f8 30             	cmp    $0x30,%eax
  800873:	73 17                	jae    80088c <vprintfmt+0x124>
  800875:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800879:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80087c:	89 d2                	mov    %edx,%edx
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800884:	83 c2 08             	add    $0x8,%edx
  800887:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088a:	eb 0c                	jmp    800898 <vprintfmt+0x130>
  80088c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800890:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800894:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800898:	8b 00                	mov    (%rax),%eax
  80089a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80089d:	eb 23                	jmp    8008c2 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80089f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008a3:	0f 89 48 ff ff ff    	jns    8007f1 <vprintfmt+0x89>
				width = 0;
  8008a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008b0:	e9 3c ff ff ff       	jmpq   8007f1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008b5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008bc:	e9 30 ff ff ff       	jmpq   8007f1 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c6:	0f 89 25 ff ff ff    	jns    8007f1 <vprintfmt+0x89>
				width = precision, precision = -1;
  8008cc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008cf:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008d9:	e9 13 ff ff ff       	jmpq   8007f1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008de:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008e2:	e9 0a ff ff ff       	jmpq   8007f1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ea:	83 f8 30             	cmp    $0x30,%eax
  8008ed:	73 17                	jae    800906 <vprintfmt+0x19e>
  8008ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008f3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f6:	89 d2                	mov    %edx,%edx
  8008f8:	48 01 d0             	add    %rdx,%rax
  8008fb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800904:	eb 0c                	jmp    800912 <vprintfmt+0x1aa>
  800906:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80090a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80090e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800912:	8b 10                	mov    (%rax),%edx
  800914:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800918:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091c:	48 89 ce             	mov    %rcx,%rsi
  80091f:	89 d7                	mov    %edx,%edi
  800921:	ff d0                	callq  *%rax
			break;
  800923:	e9 37 03 00 00       	jmpq   800c5f <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800928:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092b:	83 f8 30             	cmp    $0x30,%eax
  80092e:	73 17                	jae    800947 <vprintfmt+0x1df>
  800930:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800934:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800937:	89 d2                	mov    %edx,%edx
  800939:	48 01 d0             	add    %rdx,%rax
  80093c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093f:	83 c2 08             	add    $0x8,%edx
  800942:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800945:	eb 0c                	jmp    800953 <vprintfmt+0x1eb>
  800947:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80094b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80094f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800953:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800955:	85 db                	test   %ebx,%ebx
  800957:	79 02                	jns    80095b <vprintfmt+0x1f3>
				err = -err;
  800959:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80095b:	83 fb 15             	cmp    $0x15,%ebx
  80095e:	7f 16                	jg     800976 <vprintfmt+0x20e>
  800960:	48 b8 e0 4d 80 00 00 	movabs $0x804de0,%rax
  800967:	00 00 00 
  80096a:	48 63 d3             	movslq %ebx,%rdx
  80096d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800971:	4d 85 e4             	test   %r12,%r12
  800974:	75 2e                	jne    8009a4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800976:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80097a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097e:	89 d9                	mov    %ebx,%ecx
  800980:	48 ba a1 4e 80 00 00 	movabs $0x804ea1,%rdx
  800987:	00 00 00 
  80098a:	48 89 c7             	mov    %rax,%rdi
  80098d:	b8 00 00 00 00       	mov    $0x0,%eax
  800992:	49 b8 6e 0c 80 00 00 	movabs $0x800c6e,%r8
  800999:	00 00 00 
  80099c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80099f:	e9 bb 02 00 00       	jmpq   800c5f <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ac:	4c 89 e1             	mov    %r12,%rcx
  8009af:	48 ba aa 4e 80 00 00 	movabs $0x804eaa,%rdx
  8009b6:	00 00 00 
  8009b9:	48 89 c7             	mov    %rax,%rdi
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c1:	49 b8 6e 0c 80 00 00 	movabs $0x800c6e,%r8
  8009c8:	00 00 00 
  8009cb:	41 ff d0             	callq  *%r8
			break;
  8009ce:	e9 8c 02 00 00       	jmpq   800c5f <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d6:	83 f8 30             	cmp    $0x30,%eax
  8009d9:	73 17                	jae    8009f2 <vprintfmt+0x28a>
  8009db:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009df:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e2:	89 d2                	mov    %edx,%edx
  8009e4:	48 01 d0             	add    %rdx,%rax
  8009e7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ea:	83 c2 08             	add    $0x8,%edx
  8009ed:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f0:	eb 0c                	jmp    8009fe <vprintfmt+0x296>
  8009f2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009f6:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009fa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009fe:	4c 8b 20             	mov    (%rax),%r12
  800a01:	4d 85 e4             	test   %r12,%r12
  800a04:	75 0a                	jne    800a10 <vprintfmt+0x2a8>
				p = "(null)";
  800a06:	49 bc ad 4e 80 00 00 	movabs $0x804ead,%r12
  800a0d:	00 00 00 
			if (width > 0 && padc != '-')
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a14:	7e 78                	jle    800a8e <vprintfmt+0x326>
  800a16:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a1a:	74 72                	je     800a8e <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a1c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a1f:	48 98                	cltq   
  800a21:	48 89 c6             	mov    %rax,%rsi
  800a24:	4c 89 e7             	mov    %r12,%rdi
  800a27:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800a2e:	00 00 00 
  800a31:	ff d0                	callq  *%rax
  800a33:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a36:	eb 17                	jmp    800a4f <vprintfmt+0x2e7>
					putch(padc, putdat);
  800a38:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a3c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a44:	48 89 ce             	mov    %rcx,%rsi
  800a47:	89 d7                	mov    %edx,%edi
  800a49:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a53:	7f e3                	jg     800a38 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a55:	eb 37                	jmp    800a8e <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800a57:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a5b:	74 1e                	je     800a7b <vprintfmt+0x313>
  800a5d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a60:	7e 05                	jle    800a67 <vprintfmt+0x2ff>
  800a62:	83 fb 7e             	cmp    $0x7e,%ebx
  800a65:	7e 14                	jle    800a7b <vprintfmt+0x313>
					putch('?', putdat);
  800a67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6f:	48 89 d6             	mov    %rdx,%rsi
  800a72:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a77:	ff d0                	callq  *%rax
  800a79:	eb 0f                	jmp    800a8a <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800a7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a83:	48 89 d6             	mov    %rdx,%rsi
  800a86:	89 df                	mov    %ebx,%edi
  800a88:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a8e:	4c 89 e0             	mov    %r12,%rax
  800a91:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a95:	0f b6 00             	movzbl (%rax),%eax
  800a98:	0f be d8             	movsbl %al,%ebx
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	74 28                	je     800ac7 <vprintfmt+0x35f>
  800a9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800aa3:	78 b2                	js     800a57 <vprintfmt+0x2ef>
  800aa5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800aa9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800aad:	79 a8                	jns    800a57 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aaf:	eb 16                	jmp    800ac7 <vprintfmt+0x35f>
				putch(' ', putdat);
  800ab1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab9:	48 89 d6             	mov    %rdx,%rsi
  800abc:	bf 20 00 00 00       	mov    $0x20,%edi
  800ac1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ac7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acb:	7f e4                	jg     800ab1 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800acd:	e9 8d 01 00 00       	jmpq   800c5f <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ad2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ad6:	be 03 00 00 00       	mov    $0x3,%esi
  800adb:	48 89 c7             	mov    %rax,%rdi
  800ade:	48 b8 61 06 80 00 00 	movabs $0x800661,%rax
  800ae5:	00 00 00 
  800ae8:	ff d0                	callq  *%rax
  800aea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	48 85 c0             	test   %rax,%rax
  800af5:	79 1d                	jns    800b14 <vprintfmt+0x3ac>
				putch('-', putdat);
  800af7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 d6             	mov    %rdx,%rsi
  800b02:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b07:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0d:	48 f7 d8             	neg    %rax
  800b10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b14:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b1b:	e9 d2 00 00 00       	jmpq   800bf2 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b24:	be 03 00 00 00       	mov    $0x3,%esi
  800b29:	48 89 c7             	mov    %rax,%rdi
  800b2c:	48 b8 5a 05 80 00 00 	movabs $0x80055a,%rax
  800b33:	00 00 00 
  800b36:	ff d0                	callq  *%rax
  800b38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b3c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b43:	e9 aa 00 00 00       	jmpq   800bf2 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800b48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4c:	be 03 00 00 00       	mov    $0x3,%esi
  800b51:	48 89 c7             	mov    %rax,%rdi
  800b54:	48 b8 5a 05 80 00 00 	movabs $0x80055a,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	callq  *%rax
  800b60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b64:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b6b:	e9 82 00 00 00       	jmpq   800bf2 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800b70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b78:	48 89 d6             	mov    %rdx,%rsi
  800b7b:	bf 30 00 00 00       	mov    $0x30,%edi
  800b80:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	48 89 d6             	mov    %rdx,%rsi
  800b8d:	bf 78 00 00 00       	mov    $0x78,%edi
  800b92:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b97:	83 f8 30             	cmp    $0x30,%eax
  800b9a:	73 17                	jae    800bb3 <vprintfmt+0x44b>
  800b9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ba0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba3:	89 d2                	mov    %edx,%edx
  800ba5:	48 01 d0             	add    %rdx,%rax
  800ba8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bab:	83 c2 08             	add    $0x8,%edx
  800bae:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb1:	eb 0c                	jmp    800bbf <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800bb3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bb7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bbb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbf:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bc6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bcd:	eb 23                	jmp    800bf2 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bcf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd3:	be 03 00 00 00       	mov    $0x3,%esi
  800bd8:	48 89 c7             	mov    %rax,%rdi
  800bdb:	48 b8 5a 05 80 00 00 	movabs $0x80055a,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	callq  *%rax
  800be7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800beb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bf7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bfa:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bfd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c01:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c09:	45 89 c1             	mov    %r8d,%r9d
  800c0c:	41 89 f8             	mov    %edi,%r8d
  800c0f:	48 89 c7             	mov    %rax,%rdi
  800c12:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	callq  *%rax
			break;
  800c1e:	eb 3f                	jmp    800c5f <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c28:	48 89 d6             	mov    %rdx,%rsi
  800c2b:	89 df                	mov    %ebx,%edi
  800c2d:	ff d0                	callq  *%rax
			break;
  800c2f:	eb 2e                	jmp    800c5f <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	48 89 d6             	mov    %rdx,%rsi
  800c3c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c41:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c43:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c48:	eb 05                	jmp    800c4f <vprintfmt+0x4e7>
  800c4a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c53:	48 83 e8 01          	sub    $0x1,%rax
  800c57:	0f b6 00             	movzbl (%rax),%eax
  800c5a:	3c 25                	cmp    $0x25,%al
  800c5c:	75 ec                	jne    800c4a <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800c5e:	90                   	nop
		}
	}
  800c5f:	e9 3d fb ff ff       	jmpq   8007a1 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c64:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c65:	48 83 c4 60          	add    $0x60,%rsp
  800c69:	5b                   	pop    %rbx
  800c6a:	41 5c                	pop    %r12
  800c6c:	5d                   	pop    %rbp
  800c6d:	c3                   	retq   

0000000000800c6e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c6e:	55                   	push   %rbp
  800c6f:	48 89 e5             	mov    %rsp,%rbp
  800c72:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c79:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c80:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c87:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800c8e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c95:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c9c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ca3:	84 c0                	test   %al,%al
  800ca5:	74 20                	je     800cc7 <printfmt+0x59>
  800ca7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cab:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800caf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cb3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cb7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cbb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cbf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cc3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cc7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cce:	00 00 00 
  800cd1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cd8:	00 00 00 
  800cdb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cdf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ce6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ced:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800cfb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d02:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d09:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d10:	48 89 c7             	mov    %rax,%rdi
  800d13:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  800d1a:	00 00 00 
  800d1d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d1f:	90                   	nop
  800d20:	c9                   	leaveq 
  800d21:	c3                   	retq   

0000000000800d22 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d22:	55                   	push   %rbp
  800d23:	48 89 e5             	mov    %rsp,%rbp
  800d26:	48 83 ec 10          	sub    $0x10,%rsp
  800d2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d35:	8b 40 10             	mov    0x10(%rax),%eax
  800d38:	8d 50 01             	lea    0x1(%rax),%edx
  800d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d46:	48 8b 10             	mov    (%rax),%rdx
  800d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d4d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d51:	48 39 c2             	cmp    %rax,%rdx
  800d54:	73 17                	jae    800d6d <sprintputch+0x4b>
		*b->buf++ = ch;
  800d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5a:	48 8b 00             	mov    (%rax),%rax
  800d5d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d65:	48 89 0a             	mov    %rcx,(%rdx)
  800d68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d6b:	88 10                	mov    %dl,(%rax)
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leaveq 
  800d6f:	c3                   	retq   

0000000000800d70 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d70:	55                   	push   %rbp
  800d71:	48 89 e5             	mov    %rsp,%rbp
  800d74:	48 83 ec 50          	sub    $0x50,%rsp
  800d78:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d7c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d7f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d83:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d87:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d8b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d8f:	48 8b 0a             	mov    (%rdx),%rcx
  800d92:	48 89 08             	mov    %rcx,(%rax)
  800d95:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d99:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d9d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800da1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800da9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dad:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800db0:	48 98                	cltq   
  800db2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800db6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dba:	48 01 d0             	add    %rdx,%rax
  800dbd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dc1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dc8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dcd:	74 06                	je     800dd5 <vsnprintf+0x65>
  800dcf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dd3:	7f 07                	jg     800ddc <vsnprintf+0x6c>
		return -E_INVAL;
  800dd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dda:	eb 2f                	jmp    800e0b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ddc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800de0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800de4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800de8:	48 89 c6             	mov    %rax,%rsi
  800deb:	48 bf 22 0d 80 00 00 	movabs $0x800d22,%rdi
  800df2:	00 00 00 
  800df5:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  800dfc:	00 00 00 
  800dff:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e05:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e08:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e0b:	c9                   	leaveq 
  800e0c:	c3                   	retq   

0000000000800e0d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e18:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e1f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e25:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800e2c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e33:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e41:	84 c0                	test   %al,%al
  800e43:	74 20                	je     800e65 <snprintf+0x58>
  800e45:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e49:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e4d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e51:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e55:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e59:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e5d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e61:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e65:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e6c:	00 00 00 
  800e6f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e76:	00 00 00 
  800e79:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e7d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e84:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e8b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e92:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e99:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ea0:	48 8b 0a             	mov    (%rdx),%rcx
  800ea3:	48 89 08             	mov    %rcx,(%rax)
  800ea6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eaa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800eb6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ebd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ec4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ed1:	48 89 c7             	mov    %rax,%rdi
  800ed4:	48 b8 70 0d 80 00 00 	movabs $0x800d70,%rax
  800edb:	00 00 00 
  800ede:	ff d0                	callq  *%rax
  800ee0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ee6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 18          	sub    $0x18,%rsp
  800ef6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800efa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f01:	eb 09                	jmp    800f0c <strlen+0x1e>
		n++;
  800f03:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f07:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f10:	0f b6 00             	movzbl (%rax),%eax
  800f13:	84 c0                	test   %al,%al
  800f15:	75 ec                	jne    800f03 <strlen+0x15>
		n++;
	return n;
  800f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f1a:	c9                   	leaveq 
  800f1b:	c3                   	retq   

0000000000800f1c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
  800f20:	48 83 ec 20          	sub    $0x20,%rsp
  800f24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f33:	eb 0e                	jmp    800f43 <strnlen+0x27>
		n++;
  800f35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f3e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f43:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f48:	74 0b                	je     800f55 <strnlen+0x39>
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	0f b6 00             	movzbl (%rax),%eax
  800f51:	84 c0                	test   %al,%al
  800f53:	75 e0                	jne    800f35 <strnlen+0x19>
		n++;
	return n;
  800f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 20          	sub    $0x20,%rsp
  800f62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f72:	90                   	nop
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f7b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f83:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f87:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f8b:	0f b6 12             	movzbl (%rdx),%edx
  800f8e:	88 10                	mov    %dl,(%rax)
  800f90:	0f b6 00             	movzbl (%rax),%eax
  800f93:	84 c0                	test   %al,%al
  800f95:	75 dc                	jne    800f73 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f9b:	c9                   	leaveq 
  800f9c:	c3                   	retq   

0000000000800f9d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f9d:	55                   	push   %rbp
  800f9e:	48 89 e5             	mov    %rsp,%rbp
  800fa1:	48 83 ec 20          	sub    $0x20,%rsp
  800fa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb1:	48 89 c7             	mov    %rax,%rdi
  800fb4:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  800fbb:	00 00 00 
  800fbe:	ff d0                	callq  *%rax
  800fc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc6:	48 63 d0             	movslq %eax,%rdx
  800fc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcd:	48 01 c2             	add    %rax,%rdx
  800fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd4:	48 89 c6             	mov    %rax,%rsi
  800fd7:	48 89 d7             	mov    %rdx,%rdi
  800fda:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	callq  *%rax
	return dst;
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fea:	c9                   	leaveq 
  800feb:	c3                   	retq   

0000000000800fec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fec:	55                   	push   %rbp
  800fed:	48 89 e5             	mov    %rsp,%rbp
  800ff0:	48 83 ec 28          	sub    $0x28,%rsp
  800ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ffc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801004:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801008:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80100f:	00 
  801010:	eb 2a                	jmp    80103c <strncpy+0x50>
		*dst++ = *src;
  801012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801016:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80101a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80101e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801022:	0f b6 12             	movzbl (%rdx),%edx
  801025:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801027:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80102b:	0f b6 00             	movzbl (%rax),%eax
  80102e:	84 c0                	test   %al,%al
  801030:	74 05                	je     801037 <strncpy+0x4b>
			src++;
  801032:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801037:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80103c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801040:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801044:	72 cc                	jb     801012 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801046:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 28          	sub    $0x28,%rsp
  801054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801058:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80105c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801060:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801064:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801068:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80106d:	74 3d                	je     8010ac <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80106f:	eb 1d                	jmp    80108e <strlcpy+0x42>
			*dst++ = *src++;
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801079:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80107d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801081:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801085:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801089:	0f b6 12             	movzbl (%rdx),%edx
  80108c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80108e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801093:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801098:	74 0b                	je     8010a5 <strlcpy+0x59>
  80109a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	84 c0                	test   %al,%al
  8010a3:	75 cc                	jne    801071 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b4:	48 29 c2             	sub    %rax,%rdx
  8010b7:	48 89 d0             	mov    %rdx,%rax
}
  8010ba:	c9                   	leaveq 
  8010bb:	c3                   	retq   

00000000008010bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010bc:	55                   	push   %rbp
  8010bd:	48 89 e5             	mov    %rsp,%rbp
  8010c0:	48 83 ec 10          	sub    $0x10,%rsp
  8010c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010cc:	eb 0a                	jmp    8010d8 <strcmp+0x1c>
		p++, q++;
  8010ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 12                	je     8010f5 <strcmp+0x39>
  8010e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e7:	0f b6 10             	movzbl (%rax),%edx
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	38 c2                	cmp    %al,%dl
  8010f3:	74 d9                	je     8010ce <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f9:	0f b6 00             	movzbl (%rax),%eax
  8010fc:	0f b6 d0             	movzbl %al,%edx
  8010ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801103:	0f b6 00             	movzbl (%rax),%eax
  801106:	0f b6 c0             	movzbl %al,%eax
  801109:	29 c2                	sub    %eax,%edx
  80110b:	89 d0                	mov    %edx,%eax
}
  80110d:	c9                   	leaveq 
  80110e:	c3                   	retq   

000000000080110f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80110f:	55                   	push   %rbp
  801110:	48 89 e5             	mov    %rsp,%rbp
  801113:	48 83 ec 18          	sub    $0x18,%rsp
  801117:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80111f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801123:	eb 0f                	jmp    801134 <strncmp+0x25>
		n--, p++, q++;
  801125:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80112a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801134:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801139:	74 1d                	je     801158 <strncmp+0x49>
  80113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113f:	0f b6 00             	movzbl (%rax),%eax
  801142:	84 c0                	test   %al,%al
  801144:	74 12                	je     801158 <strncmp+0x49>
  801146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114a:	0f b6 10             	movzbl (%rax),%edx
  80114d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801151:	0f b6 00             	movzbl (%rax),%eax
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 cd                	je     801125 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801158:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115d:	75 07                	jne    801166 <strncmp+0x57>
		return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	eb 18                	jmp    80117e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116a:	0f b6 00             	movzbl (%rax),%eax
  80116d:	0f b6 d0             	movzbl %al,%edx
  801170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801174:	0f b6 00             	movzbl (%rax),%eax
  801177:	0f b6 c0             	movzbl %al,%eax
  80117a:	29 c2                	sub    %eax,%edx
  80117c:	89 d0                	mov    %edx,%eax
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 10          	sub    $0x10,%rsp
  801188:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118c:	89 f0                	mov    %esi,%eax
  80118e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801191:	eb 17                	jmp    8011aa <strchr+0x2a>
		if (*s == c)
  801193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801197:	0f b6 00             	movzbl (%rax),%eax
  80119a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80119d:	75 06                	jne    8011a5 <strchr+0x25>
			return (char *) s;
  80119f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a3:	eb 15                	jmp    8011ba <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	75 de                	jne    801193 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ba:	c9                   	leaveq 
  8011bb:	c3                   	retq   

00000000008011bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011bc:	55                   	push   %rbp
  8011bd:	48 89 e5             	mov    %rsp,%rbp
  8011c0:	48 83 ec 10          	sub    $0x10,%rsp
  8011c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c8:	89 f0                	mov    %esi,%eax
  8011ca:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011cd:	eb 11                	jmp    8011e0 <strfind+0x24>
		if (*s == c)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011d9:	74 12                	je     8011ed <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 e4                	jne    8011cf <strfind+0x13>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x32>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f2:	c9                   	leaveq 
  8011f3:	c3                   	retq   

00000000008011f4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	48 83 ec 18          	sub    $0x18,%rsp
  8011fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801200:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801203:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801207:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80120c:	75 06                	jne    801214 <memset+0x20>
		return v;
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	eb 69                	jmp    80127d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801218:	83 e0 03             	and    $0x3,%eax
  80121b:	48 85 c0             	test   %rax,%rax
  80121e:	75 48                	jne    801268 <memset+0x74>
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	83 e0 03             	and    $0x3,%eax
  801227:	48 85 c0             	test   %rax,%rax
  80122a:	75 3c                	jne    801268 <memset+0x74>
		c &= 0xFF;
  80122c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801233:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801236:	c1 e0 18             	shl    $0x18,%eax
  801239:	89 c2                	mov    %eax,%edx
  80123b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80123e:	c1 e0 10             	shl    $0x10,%eax
  801241:	09 c2                	or     %eax,%edx
  801243:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801246:	c1 e0 08             	shl    $0x8,%eax
  801249:	09 d0                	or     %edx,%eax
  80124b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801252:	48 c1 e8 02          	shr    $0x2,%rax
  801256:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801259:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801260:	48 89 d7             	mov    %rdx,%rdi
  801263:	fc                   	cld    
  801264:	f3 ab                	rep stos %eax,%es:(%rdi)
  801266:	eb 11                	jmp    801279 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801268:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80126c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801273:	48 89 d7             	mov    %rdx,%rdi
  801276:	fc                   	cld    
  801277:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80127d:	c9                   	leaveq 
  80127e:	c3                   	retq   

000000000080127f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80127f:	55                   	push   %rbp
  801280:	48 89 e5             	mov    %rsp,%rbp
  801283:	48 83 ec 28          	sub    $0x28,%rsp
  801287:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80128f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801297:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80129b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012ab:	0f 83 88 00 00 00    	jae    801339 <memmove+0xba>
  8012b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b9:	48 01 d0             	add    %rdx,%rax
  8012bc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012c0:	76 77                	jbe    801339 <memmove+0xba>
		s += n;
  8012c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ce:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	83 e0 03             	and    $0x3,%eax
  8012d9:	48 85 c0             	test   %rax,%rax
  8012dc:	75 3b                	jne    801319 <memmove+0x9a>
  8012de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e2:	83 e0 03             	and    $0x3,%eax
  8012e5:	48 85 c0             	test   %rax,%rax
  8012e8:	75 2f                	jne    801319 <memmove+0x9a>
  8012ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ee:	83 e0 03             	and    $0x3,%eax
  8012f1:	48 85 c0             	test   %rax,%rax
  8012f4:	75 23                	jne    801319 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fa:	48 83 e8 04          	sub    $0x4,%rax
  8012fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801302:	48 83 ea 04          	sub    $0x4,%rdx
  801306:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80130a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80130e:	48 89 c7             	mov    %rax,%rdi
  801311:	48 89 d6             	mov    %rdx,%rsi
  801314:	fd                   	std    
  801315:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801317:	eb 1d                	jmp    801336 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801325:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801329:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132d:	48 89 d7             	mov    %rdx,%rdi
  801330:	48 89 c1             	mov    %rax,%rcx
  801333:	fd                   	std    
  801334:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801336:	fc                   	cld    
  801337:	eb 57                	jmp    801390 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133d:	83 e0 03             	and    $0x3,%eax
  801340:	48 85 c0             	test   %rax,%rax
  801343:	75 36                	jne    80137b <memmove+0xfc>
  801345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801349:	83 e0 03             	and    $0x3,%eax
  80134c:	48 85 c0             	test   %rax,%rax
  80134f:	75 2a                	jne    80137b <memmove+0xfc>
  801351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801355:	83 e0 03             	and    $0x3,%eax
  801358:	48 85 c0             	test   %rax,%rax
  80135b:	75 1e                	jne    80137b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80135d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801361:	48 c1 e8 02          	shr    $0x2,%rax
  801365:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801368:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801370:	48 89 c7             	mov    %rax,%rdi
  801373:	48 89 d6             	mov    %rdx,%rsi
  801376:	fc                   	cld    
  801377:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801379:	eb 15                	jmp    801390 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80137b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801383:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801387:	48 89 c7             	mov    %rax,%rdi
  80138a:	48 89 d6             	mov    %rdx,%rsi
  80138d:	fc                   	cld    
  80138e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801394:	c9                   	leaveq 
  801395:	c3                   	retq   

0000000000801396 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	48 83 ec 18          	sub    $0x18,%rsp
  80139e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	48 89 ce             	mov    %rcx,%rsi
  8013b9:	48 89 c7             	mov    %rax,%rdi
  8013bc:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  8013c3:	00 00 00 
  8013c6:	ff d0                	callq  *%rax
}
  8013c8:	c9                   	leaveq 
  8013c9:	c3                   	retq   

00000000008013ca <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ca:	55                   	push   %rbp
  8013cb:	48 89 e5             	mov    %rsp,%rbp
  8013ce:	48 83 ec 28          	sub    $0x28,%rsp
  8013d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013ee:	eb 36                	jmp    801426 <memcmp+0x5c>
		if (*s1 != *s2)
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f4:	0f b6 10             	movzbl (%rax),%edx
  8013f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fb:	0f b6 00             	movzbl (%rax),%eax
  8013fe:	38 c2                	cmp    %al,%dl
  801400:	74 1a                	je     80141c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	0f b6 d0             	movzbl %al,%edx
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	0f b6 c0             	movzbl %al,%eax
  801416:	29 c2                	sub    %eax,%edx
  801418:	89 d0                	mov    %edx,%eax
  80141a:	eb 20                	jmp    80143c <memcmp+0x72>
		s1++, s2++;
  80141c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801421:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80142e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801432:	48 85 c0             	test   %rax,%rax
  801435:	75 b9                	jne    8013f0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143c:	c9                   	leaveq 
  80143d:	c3                   	retq   

000000000080143e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80143e:	55                   	push   %rbp
  80143f:	48 89 e5             	mov    %rsp,%rbp
  801442:	48 83 ec 28          	sub    $0x28,%rsp
  801446:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80144d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801451:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	48 01 d0             	add    %rdx,%rax
  80145c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801460:	eb 19                	jmp    80147b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	0f b6 d0             	movzbl %al,%edx
  80146c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80146f:	0f b6 c0             	movzbl %al,%eax
  801472:	39 c2                	cmp    %eax,%edx
  801474:	74 11                	je     801487 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801476:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80147b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801483:	72 dd                	jb     801462 <memfind+0x24>
  801485:	eb 01                	jmp    801488 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801487:	90                   	nop
	return (void *) s;
  801488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148c:	c9                   	leaveq 
  80148d:	c3                   	retq   

000000000080148e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80148e:	55                   	push   %rbp
  80148f:	48 89 e5             	mov    %rsp,%rbp
  801492:	48 83 ec 38          	sub    $0x38,%rsp
  801496:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80149a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80149e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014a8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014af:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014b0:	eb 05                	jmp    8014b7 <strtol+0x29>
		s++;
  8014b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	3c 20                	cmp    $0x20,%al
  8014c0:	74 f0                	je     8014b2 <strtol+0x24>
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 09                	cmp    $0x9,%al
  8014cb:	74 e5                	je     8014b2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	3c 2b                	cmp    $0x2b,%al
  8014d6:	75 07                	jne    8014df <strtol+0x51>
		s++;
  8014d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014dd:	eb 17                	jmp    8014f6 <strtol+0x68>
	else if (*s == '-')
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	3c 2d                	cmp    $0x2d,%al
  8014e8:	75 0c                	jne    8014f6 <strtol+0x68>
		s++, neg = 1;
  8014ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014fa:	74 06                	je     801502 <strtol+0x74>
  8014fc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801500:	75 28                	jne    80152a <strtol+0x9c>
  801502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	3c 30                	cmp    $0x30,%al
  80150b:	75 1d                	jne    80152a <strtol+0x9c>
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	48 83 c0 01          	add    $0x1,%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	3c 78                	cmp    $0x78,%al
  80151a:	75 0e                	jne    80152a <strtol+0x9c>
		s += 2, base = 16;
  80151c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801521:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801528:	eb 2c                	jmp    801556 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80152a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80152e:	75 19                	jne    801549 <strtol+0xbb>
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	3c 30                	cmp    $0x30,%al
  801539:	75 0e                	jne    801549 <strtol+0xbb>
		s++, base = 8;
  80153b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801540:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801547:	eb 0d                	jmp    801556 <strtol+0xc8>
	else if (base == 0)
  801549:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80154d:	75 07                	jne    801556 <strtol+0xc8>
		base = 10;
  80154f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155a:	0f b6 00             	movzbl (%rax),%eax
  80155d:	3c 2f                	cmp    $0x2f,%al
  80155f:	7e 1d                	jle    80157e <strtol+0xf0>
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	3c 39                	cmp    $0x39,%al
  80156a:	7f 12                	jg     80157e <strtol+0xf0>
			dig = *s - '0';
  80156c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801570:	0f b6 00             	movzbl (%rax),%eax
  801573:	0f be c0             	movsbl %al,%eax
  801576:	83 e8 30             	sub    $0x30,%eax
  801579:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80157c:	eb 4e                	jmp    8015cc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80157e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	3c 60                	cmp    $0x60,%al
  801587:	7e 1d                	jle    8015a6 <strtol+0x118>
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 7a                	cmp    $0x7a,%al
  801592:	7f 12                	jg     8015a6 <strtol+0x118>
			dig = *s - 'a' + 10;
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	0f be c0             	movsbl %al,%eax
  80159e:	83 e8 57             	sub    $0x57,%eax
  8015a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015a4:	eb 26                	jmp    8015cc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 40                	cmp    $0x40,%al
  8015af:	7e 47                	jle    8015f8 <strtol+0x16a>
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 5a                	cmp    $0x5a,%al
  8015ba:	7f 3c                	jg     8015f8 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	0f be c0             	movsbl %al,%eax
  8015c6:	83 e8 37             	sub    $0x37,%eax
  8015c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015cf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015d2:	7d 23                	jge    8015f7 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8015d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015dc:	48 98                	cltq   
  8015de:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015e3:	48 89 c2             	mov    %rax,%rdx
  8015e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015e9:	48 98                	cltq   
  8015eb:	48 01 d0             	add    %rdx,%rax
  8015ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015f2:	e9 5f ff ff ff       	jmpq   801556 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015f7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015f8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015fd:	74 0b                	je     80160a <strtol+0x17c>
		*endptr = (char *) s;
  8015ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801603:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801607:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80160a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80160e:	74 09                	je     801619 <strtol+0x18b>
  801610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801614:	48 f7 d8             	neg    %rax
  801617:	eb 04                	jmp    80161d <strtol+0x18f>
  801619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80161d:	c9                   	leaveq 
  80161e:	c3                   	retq   

000000000080161f <strstr>:

char * strstr(const char *in, const char *str)
{
  80161f:	55                   	push   %rbp
  801620:	48 89 e5             	mov    %rsp,%rbp
  801623:	48 83 ec 30          	sub    $0x30,%rsp
  801627:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80162b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80162f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801633:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801637:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80163b:	0f b6 00             	movzbl (%rax),%eax
  80163e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801641:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801645:	75 06                	jne    80164d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	eb 6b                	jmp    8016b8 <strstr+0x99>

	len = strlen(str);
  80164d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801651:	48 89 c7             	mov    %rax,%rdi
  801654:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80165b:	00 00 00 
  80165e:	ff d0                	callq  *%rax
  801660:	48 98                	cltq   
  801662:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80166e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801678:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80167c:	75 07                	jne    801685 <strstr+0x66>
				return (char *) 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
  801683:	eb 33                	jmp    8016b8 <strstr+0x99>
		} while (sc != c);
  801685:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801689:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80168c:	75 d8                	jne    801666 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80168e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801692:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	48 89 ce             	mov    %rcx,%rsi
  80169d:	48 89 c7             	mov    %rax,%rdi
  8016a0:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	75 b6                	jne    801666 <strstr+0x47>

	return (char *) (in - 1);
  8016b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b4:	48 83 e8 01          	sub    $0x1,%rax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	53                   	push   %rbx
  8016bf:	48 83 ec 48          	sub    $0x48,%rsp
  8016c3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016c6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016c9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016cd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016d1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016d5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016dc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016e0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016e4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016e8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016ec:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016f0:	4c 89 c3             	mov    %r8,%rbx
  8016f3:	cd 30                	int    $0x30
  8016f5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016fd:	74 3e                	je     80173d <syscall+0x83>
  8016ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801704:	7e 37                	jle    80173d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80170d:	49 89 d0             	mov    %rdx,%r8
  801710:	89 c1                	mov    %eax,%ecx
  801712:	48 ba 68 51 80 00 00 	movabs $0x805168,%rdx
  801719:	00 00 00 
  80171c:	be 24 00 00 00       	mov    $0x24,%esi
  801721:	48 bf 85 51 80 00 00 	movabs $0x805185,%rdi
  801728:	00 00 00 
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax
  801730:	49 b9 90 01 80 00 00 	movabs $0x800190,%r9
  801737:	00 00 00 
  80173a:	41 ff d1             	callq  *%r9

	return ret;
  80173d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801741:	48 83 c4 48          	add    $0x48,%rsp
  801745:	5b                   	pop    %rbx
  801746:	5d                   	pop    %rbp
  801747:	c3                   	retq   

0000000000801748 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801748:	55                   	push   %rbp
  801749:	48 89 e5             	mov    %rsp,%rbp
  80174c:	48 83 ec 10          	sub    $0x10,%rsp
  801750:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801754:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801760:	48 83 ec 08          	sub    $0x8,%rsp
  801764:	6a 00                	pushq  $0x0
  801766:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801772:	48 89 d1             	mov    %rdx,%rcx
  801775:	48 89 c2             	mov    %rax,%rdx
  801778:	be 00 00 00 00       	mov    $0x0,%esi
  80177d:	bf 00 00 00 00       	mov    $0x0,%edi
  801782:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801789:	00 00 00 
  80178c:	ff d0                	callq  *%rax
  80178e:	48 83 c4 10          	add    $0x10,%rsp
}
  801792:	90                   	nop
  801793:	c9                   	leaveq 
  801794:	c3                   	retq   

0000000000801795 <sys_cgetc>:

int
sys_cgetc(void)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801799:	48 83 ec 08          	sub    $0x8,%rsp
  80179d:	6a 00                	pushq  $0x0
  80179f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	be 00 00 00 00       	mov    $0x0,%esi
  8017ba:	bf 01 00 00 00       	mov    $0x1,%edi
  8017bf:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
  8017cb:	48 83 c4 10          	add    $0x10,%rsp
}
  8017cf:	c9                   	leaveq 
  8017d0:	c3                   	retq   

00000000008017d1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017d1:	55                   	push   %rbp
  8017d2:	48 89 e5             	mov    %rsp,%rbp
  8017d5:	48 83 ec 10          	sub    $0x10,%rsp
  8017d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017df:	48 98                	cltq   
  8017e1:	48 83 ec 08          	sub    $0x8,%rsp
  8017e5:	6a 00                	pushq  $0x0
  8017e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f8:	48 89 c2             	mov    %rax,%rdx
  8017fb:	be 01 00 00 00       	mov    $0x1,%esi
  801800:	bf 03 00 00 00       	mov    $0x3,%edi
  801805:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  80180c:	00 00 00 
  80180f:	ff d0                	callq  *%rax
  801811:	48 83 c4 10          	add    $0x10,%rsp
}
  801815:	c9                   	leaveq 
  801816:	c3                   	retq   

0000000000801817 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80181b:	48 83 ec 08          	sub    $0x8,%rsp
  80181f:	6a 00                	pushq  $0x0
  801821:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801827:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	be 00 00 00 00       	mov    $0x0,%esi
  80183c:	bf 02 00 00 00       	mov    $0x2,%edi
  801841:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
  80184d:	48 83 c4 10          	add    $0x10,%rsp
}
  801851:	c9                   	leaveq 
  801852:	c3                   	retq   

0000000000801853 <sys_yield>:


void
sys_yield(void)
{
  801853:	55                   	push   %rbp
  801854:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801857:	48 83 ec 08          	sub    $0x8,%rsp
  80185b:	6a 00                	pushq  $0x0
  80185d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801863:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801869:	b9 00 00 00 00       	mov    $0x0,%ecx
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	be 00 00 00 00       	mov    $0x0,%esi
  801878:	bf 0b 00 00 00       	mov    $0xb,%edi
  80187d:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801884:	00 00 00 
  801887:	ff d0                	callq  *%rax
  801889:	48 83 c4 10          	add    $0x10,%rsp
}
  80188d:	90                   	nop
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 10          	sub    $0x10,%rsp
  801898:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80189b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80189f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a5:	48 63 c8             	movslq %eax,%rcx
  8018a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018af:	48 98                	cltq   
  8018b1:	48 83 ec 08          	sub    $0x8,%rsp
  8018b5:	6a 00                	pushq  $0x0
  8018b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bd:	49 89 c8             	mov    %rcx,%r8
  8018c0:	48 89 d1             	mov    %rdx,%rcx
  8018c3:	48 89 c2             	mov    %rax,%rdx
  8018c6:	be 01 00 00 00       	mov    $0x1,%esi
  8018cb:	bf 04 00 00 00       	mov    $0x4,%edi
  8018d0:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	callq  *%rax
  8018dc:	48 83 c4 10          	add    $0x10,%rsp
}
  8018e0:	c9                   	leaveq 
  8018e1:	c3                   	retq   

00000000008018e2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	48 83 ec 20          	sub    $0x20,%rsp
  8018ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018f1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018f4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018f8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018fc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018ff:	48 63 c8             	movslq %eax,%rcx
  801902:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801906:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801909:	48 63 f0             	movslq %eax,%rsi
  80190c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801913:	48 98                	cltq   
  801915:	48 83 ec 08          	sub    $0x8,%rsp
  801919:	51                   	push   %rcx
  80191a:	49 89 f9             	mov    %rdi,%r9
  80191d:	49 89 f0             	mov    %rsi,%r8
  801920:	48 89 d1             	mov    %rdx,%rcx
  801923:	48 89 c2             	mov    %rax,%rdx
  801926:	be 01 00 00 00       	mov    $0x1,%esi
  80192b:	bf 05 00 00 00       	mov    $0x5,%edi
  801930:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801937:	00 00 00 
  80193a:	ff d0                	callq  *%rax
  80193c:	48 83 c4 10          	add    $0x10,%rsp
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 10          	sub    $0x10,%rsp
  80194a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801951:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801958:	48 98                	cltq   
  80195a:	48 83 ec 08          	sub    $0x8,%rsp
  80195e:	6a 00                	pushq  $0x0
  801960:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801966:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196c:	48 89 d1             	mov    %rdx,%rcx
  80196f:	48 89 c2             	mov    %rax,%rdx
  801972:	be 01 00 00 00       	mov    $0x1,%esi
  801977:	bf 06 00 00 00       	mov    $0x6,%edi
  80197c:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801983:	00 00 00 
  801986:	ff d0                	callq  *%rax
  801988:	48 83 c4 10          	add    $0x10,%rsp
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 10          	sub    $0x10,%rsp
  801996:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801999:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80199c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199f:	48 63 d0             	movslq %eax,%rdx
  8019a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a5:	48 98                	cltq   
  8019a7:	48 83 ec 08          	sub    $0x8,%rsp
  8019ab:	6a 00                	pushq  $0x0
  8019ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b9:	48 89 d1             	mov    %rdx,%rcx
  8019bc:	48 89 c2             	mov    %rax,%rdx
  8019bf:	be 01 00 00 00       	mov    $0x1,%esi
  8019c4:	bf 08 00 00 00       	mov    $0x8,%edi
  8019c9:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
  8019d5:	48 83 c4 10          	add    $0x10,%rsp
}
  8019d9:	c9                   	leaveq 
  8019da:	c3                   	retq   

00000000008019db <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019db:	55                   	push   %rbp
  8019dc:	48 89 e5             	mov    %rsp,%rbp
  8019df:	48 83 ec 10          	sub    $0x10,%rsp
  8019e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f1:	48 98                	cltq   
  8019f3:	48 83 ec 08          	sub    $0x8,%rsp
  8019f7:	6a 00                	pushq  $0x0
  8019f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a05:	48 89 d1             	mov    %rdx,%rcx
  801a08:	48 89 c2             	mov    %rax,%rdx
  801a0b:	be 01 00 00 00       	mov    $0x1,%esi
  801a10:	bf 09 00 00 00       	mov    $0x9,%edi
  801a15:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	callq  *%rax
  801a21:	48 83 c4 10          	add    $0x10,%rsp
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 10          	sub    $0x10,%rsp
  801a2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3d:	48 98                	cltq   
  801a3f:	48 83 ec 08          	sub    $0x8,%rsp
  801a43:	6a 00                	pushq  $0x0
  801a45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a51:	48 89 d1             	mov    %rdx,%rcx
  801a54:	48 89 c2             	mov    %rax,%rdx
  801a57:	be 01 00 00 00       	mov    $0x1,%esi
  801a5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a61:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801a68:	00 00 00 
  801a6b:	ff d0                	callq  *%rax
  801a6d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 20          	sub    $0x20,%rsp
  801a7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a82:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a86:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8c:	48 63 f0             	movslq %eax,%rsi
  801a8f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a96:	48 98                	cltq   
  801a98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9c:	48 83 ec 08          	sub    $0x8,%rsp
  801aa0:	6a 00                	pushq  $0x0
  801aa2:	49 89 f1             	mov    %rsi,%r9
  801aa5:	49 89 c8             	mov    %rcx,%r8
  801aa8:	48 89 d1             	mov    %rdx,%rcx
  801aab:	48 89 c2             	mov    %rax,%rdx
  801aae:	be 00 00 00 00       	mov    $0x0,%esi
  801ab3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ab8:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
  801ac4:	48 83 c4 10          	add    $0x10,%rsp
}
  801ac8:	c9                   	leaveq 
  801ac9:	c3                   	retq   

0000000000801aca <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801aca:	55                   	push   %rbp
  801acb:	48 89 e5             	mov    %rsp,%rbp
  801ace:	48 83 ec 10          	sub    $0x10,%rsp
  801ad2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ada:	48 83 ec 08          	sub    $0x8,%rsp
  801ade:	6a 00                	pushq  $0x0
  801ae0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af1:	48 89 c2             	mov    %rax,%rdx
  801af4:	be 01 00 00 00       	mov    $0x1,%esi
  801af9:	bf 0d 00 00 00       	mov    $0xd,%edi
  801afe:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
  801b0a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b14:	48 83 ec 08          	sub    $0x8,%rsp
  801b18:	6a 00                	pushq  $0x0
  801b1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	be 00 00 00 00       	mov    $0x0,%esi
  801b35:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b3a:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801b41:	00 00 00 
  801b44:	ff d0                	callq  *%rax
  801b46:	48 83 c4 10          	add    $0x10,%rsp
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 10          	sub    $0x10,%rsp
  801b54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b58:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801b5b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b62:	48 83 ec 08          	sub    $0x8,%rsp
  801b66:	6a 00                	pushq  $0x0
  801b68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b74:	48 89 d1             	mov    %rdx,%rcx
  801b77:	48 89 c2             	mov    %rax,%rdx
  801b7a:	be 00 00 00 00       	mov    $0x0,%esi
  801b7f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b84:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801b8b:	00 00 00 
  801b8e:	ff d0                	callq  *%rax
  801b90:	48 83 c4 10          	add    $0x10,%rsp
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 10          	sub    $0x10,%rsp
  801b9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ba2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801ba5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bac:	48 83 ec 08          	sub    $0x8,%rsp
  801bb0:	6a 00                	pushq  $0x0
  801bb2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbe:	48 89 d1             	mov    %rdx,%rcx
  801bc1:	48 89 c2             	mov    %rax,%rdx
  801bc4:	be 00 00 00 00       	mov    $0x0,%esi
  801bc9:	bf 10 00 00 00       	mov    $0x10,%edi
  801bce:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801bd5:	00 00 00 
  801bd8:	ff d0                	callq  *%rax
  801bda:	48 83 c4 10          	add    $0x10,%rsp
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 20          	sub    $0x20,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bef:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bf2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bf6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801bfa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bfd:	48 63 c8             	movslq %eax,%rcx
  801c00:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c07:	48 63 f0             	movslq %eax,%rsi
  801c0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c11:	48 98                	cltq   
  801c13:	48 83 ec 08          	sub    $0x8,%rsp
  801c17:	51                   	push   %rcx
  801c18:	49 89 f9             	mov    %rdi,%r9
  801c1b:	49 89 f0             	mov    %rsi,%r8
  801c1e:	48 89 d1             	mov    %rdx,%rcx
  801c21:	48 89 c2             	mov    %rax,%rdx
  801c24:	be 00 00 00 00       	mov    $0x0,%esi
  801c29:	bf 11 00 00 00       	mov    $0x11,%edi
  801c2e:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
  801c3a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c3e:	c9                   	leaveq 
  801c3f:	c3                   	retq   

0000000000801c40 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	48 83 ec 10          	sub    $0x10,%rsp
  801c48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c58:	48 83 ec 08          	sub    $0x8,%rsp
  801c5c:	6a 00                	pushq  $0x0
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 00 00 00 00       	mov    $0x0,%esi
  801c75:	bf 12 00 00 00       	mov    $0x12,%edi
  801c7a:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
  801c86:	48 83 c4 10          	add    $0x10,%rsp
}
  801c8a:	c9                   	leaveq 
  801c8b:	c3                   	retq   

0000000000801c8c <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801c8c:	55                   	push   %rbp
  801c8d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801c90:	48 83 ec 08          	sub    $0x8,%rsp
  801c94:	6a 00                	pushq  $0x0
  801c96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cac:	be 00 00 00 00       	mov    $0x0,%esi
  801cb1:	bf 13 00 00 00       	mov    $0x13,%edi
  801cb6:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
  801cc2:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801cc6:	90                   	nop
  801cc7:	c9                   	leaveq 
  801cc8:	c3                   	retq   

0000000000801cc9 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801cc9:	55                   	push   %rbp
  801cca:	48 89 e5             	mov    %rsp,%rbp
  801ccd:	48 83 ec 10          	sub    $0x10,%rsp
  801cd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd7:	48 98                	cltq   
  801cd9:	48 83 ec 08          	sub    $0x8,%rsp
  801cdd:	6a 00                	pushq  $0x0
  801cdf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf0:	48 89 c2             	mov    %rax,%rdx
  801cf3:	be 00 00 00 00       	mov    $0x0,%esi
  801cf8:	bf 14 00 00 00       	mov    $0x14,%edi
  801cfd:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801d04:	00 00 00 
  801d07:	ff d0                	callq  *%rax
  801d09:	48 83 c4 10          	add    $0x10,%rsp
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   

0000000000801d0f <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d13:	48 83 ec 08          	sub    $0x8,%rsp
  801d17:	6a 00                	pushq  $0x0
  801d19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d25:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2f:	be 00 00 00 00       	mov    $0x0,%esi
  801d34:	bf 15 00 00 00       	mov    $0x15,%edi
  801d39:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801d40:	00 00 00 
  801d43:	ff d0                	callq  *%rax
  801d45:	48 83 c4 10          	add    $0x10,%rsp
}
  801d49:	c9                   	leaveq 
  801d4a:	c3                   	retq   

0000000000801d4b <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801d4b:	55                   	push   %rbp
  801d4c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d4f:	48 83 ec 08          	sub    $0x8,%rsp
  801d53:	6a 00                	pushq  $0x0
  801d55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d66:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6b:	be 00 00 00 00       	mov    $0x0,%esi
  801d70:	bf 16 00 00 00       	mov    $0x16,%edi
  801d75:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	callq  *%rax
  801d81:	48 83 c4 10          	add    $0x10,%rsp
}
  801d85:	90                   	nop
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 08          	sub    $0x8,%rsp
  801d90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d98:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d9f:	ff ff ff 
  801da2:	48 01 d0             	add    %rdx,%rax
  801da5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 08          	sub    $0x8,%rsp
  801db3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbb:	48 89 c7             	mov    %rax,%rdi
  801dbe:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  801dc5:	00 00 00 
  801dc8:	ff d0                	callq  *%rax
  801dca:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dd0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dd4:	c9                   	leaveq 
  801dd5:	c3                   	retq   

0000000000801dd6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	48 83 ec 18          	sub    $0x18,%rsp
  801dde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801de2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801de9:	eb 6b                	jmp    801e56 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dee:	48 98                	cltq   
  801df0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801df6:	48 c1 e0 0c          	shl    $0xc,%rax
  801dfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e02:	48 c1 e8 15          	shr    $0x15,%rax
  801e06:	48 89 c2             	mov    %rax,%rdx
  801e09:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e10:	01 00 00 
  801e13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e17:	83 e0 01             	and    $0x1,%eax
  801e1a:	48 85 c0             	test   %rax,%rax
  801e1d:	74 21                	je     801e40 <fd_alloc+0x6a>
  801e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e23:	48 c1 e8 0c          	shr    $0xc,%rax
  801e27:	48 89 c2             	mov    %rax,%rdx
  801e2a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e31:	01 00 00 
  801e34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e38:	83 e0 01             	and    $0x1,%eax
  801e3b:	48 85 c0             	test   %rax,%rax
  801e3e:	75 12                	jne    801e52 <fd_alloc+0x7c>
			*fd_store = fd;
  801e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e48:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	eb 1a                	jmp    801e6c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e52:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e56:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e5a:	7e 8f                	jle    801deb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e60:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e67:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 20          	sub    $0x20,%rsp
  801e76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e81:	78 06                	js     801e89 <fd_lookup+0x1b>
  801e83:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e87:	7e 07                	jle    801e90 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8e:	eb 6c                	jmp    801efc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e93:	48 98                	cltq   
  801e95:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e9b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea7:	48 c1 e8 15          	shr    $0x15,%rax
  801eab:	48 89 c2             	mov    %rax,%rdx
  801eae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eb5:	01 00 00 
  801eb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebc:	83 e0 01             	and    $0x1,%eax
  801ebf:	48 85 c0             	test   %rax,%rax
  801ec2:	74 21                	je     801ee5 <fd_lookup+0x77>
  801ec4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec8:	48 c1 e8 0c          	shr    $0xc,%rax
  801ecc:	48 89 c2             	mov    %rax,%rdx
  801ecf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ed6:	01 00 00 
  801ed9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801edd:	83 e0 01             	and    $0x1,%eax
  801ee0:	48 85 c0             	test   %rax,%rax
  801ee3:	75 07                	jne    801eec <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ee5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eea:	eb 10                	jmp    801efc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ef0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efc:	c9                   	leaveq 
  801efd:	c3                   	retq   

0000000000801efe <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801efe:	55                   	push   %rbp
  801eff:	48 89 e5             	mov    %rsp,%rbp
  801f02:	48 83 ec 30          	sub    $0x30,%rsp
  801f06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f0a:	89 f0                	mov    %esi,%eax
  801f0c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f13:	48 89 c7             	mov    %rax,%rdi
  801f16:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
  801f22:	89 c2                	mov    %eax,%edx
  801f24:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f28:	48 89 c6             	mov    %rax,%rsi
  801f2b:	89 d7                	mov    %edx,%edi
  801f2d:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  801f34:	00 00 00 
  801f37:	ff d0                	callq  *%rax
  801f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f40:	78 0a                	js     801f4c <fd_close+0x4e>
	    || fd != fd2)
  801f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f46:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f4a:	74 12                	je     801f5e <fd_close+0x60>
		return (must_exist ? r : 0);
  801f4c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f50:	74 05                	je     801f57 <fd_close+0x59>
  801f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f55:	eb 70                	jmp    801fc7 <fd_close+0xc9>
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5c:	eb 69                	jmp    801fc7 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f62:	8b 00                	mov    (%rax),%eax
  801f64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f68:	48 89 d6             	mov    %rdx,%rsi
  801f6b:	89 c7                	mov    %eax,%edi
  801f6d:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	callq  *%rax
  801f79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f80:	78 2a                	js     801fac <fd_close+0xae>
		if (dev->dev_close)
  801f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f86:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f8a:	48 85 c0             	test   %rax,%rax
  801f8d:	74 16                	je     801fa5 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f93:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f97:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f9b:	48 89 d7             	mov    %rdx,%rdi
  801f9e:	ff d0                	callq  *%rax
  801fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa3:	eb 07                	jmp    801fac <fd_close+0xae>
		else
			r = 0;
  801fa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb0:	48 89 c6             	mov    %rax,%rsi
  801fb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb8:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax
	return r;
  801fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fc7:	c9                   	leaveq 
  801fc8:	c3                   	retq   

0000000000801fc9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fc9:	55                   	push   %rbp
  801fca:	48 89 e5             	mov    %rsp,%rbp
  801fcd:	48 83 ec 20          	sub    $0x20,%rsp
  801fd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fdf:	eb 41                	jmp    802022 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fe1:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fe8:	00 00 00 
  801feb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fee:	48 63 d2             	movslq %edx,%rdx
  801ff1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff5:	8b 00                	mov    (%rax),%eax
  801ff7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ffa:	75 22                	jne    80201e <dev_lookup+0x55>
			*dev = devtab[i];
  801ffc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802003:	00 00 00 
  802006:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802009:	48 63 d2             	movslq %edx,%rdx
  80200c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802010:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802014:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	eb 60                	jmp    80207e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80201e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802022:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802029:	00 00 00 
  80202c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202f:	48 63 d2             	movslq %edx,%rdx
  802032:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802036:	48 85 c0             	test   %rax,%rax
  802039:	75 a6                	jne    801fe1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80203b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802042:	00 00 00 
  802045:	48 8b 00             	mov    (%rax),%rax
  802048:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80204e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802051:	89 c6                	mov    %eax,%esi
  802053:	48 bf 98 51 80 00 00 	movabs $0x805198,%rdi
  80205a:	00 00 00 
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
  802062:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802069:	00 00 00 
  80206c:	ff d1                	callq  *%rcx
	*dev = 0;
  80206e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802072:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80207e:	c9                   	leaveq 
  80207f:	c3                   	retq   

0000000000802080 <close>:

int
close(int fdnum)
{
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	48 83 ec 20          	sub    $0x20,%rsp
  802088:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80208f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802092:	48 89 d6             	mov    %rdx,%rsi
  802095:	89 c7                	mov    %eax,%edi
  802097:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
  8020a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020aa:	79 05                	jns    8020b1 <close+0x31>
		return r;
  8020ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020af:	eb 18                	jmp    8020c9 <close+0x49>
	else
		return fd_close(fd, 1);
  8020b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b5:	be 01 00 00 00       	mov    $0x1,%esi
  8020ba:	48 89 c7             	mov    %rax,%rdi
  8020bd:	48 b8 fe 1e 80 00 00 	movabs $0x801efe,%rax
  8020c4:	00 00 00 
  8020c7:	ff d0                	callq  *%rax
}
  8020c9:	c9                   	leaveq 
  8020ca:	c3                   	retq   

00000000008020cb <close_all>:

void
close_all(void)
{
  8020cb:	55                   	push   %rbp
  8020cc:	48 89 e5             	mov    %rsp,%rbp
  8020cf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020da:	eb 15                	jmp    8020f1 <close_all+0x26>
		close(i);
  8020dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020df:	89 c7                	mov    %eax,%edi
  8020e1:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020f1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020f5:	7e e5                	jle    8020dc <close_all+0x11>
		close(i);
}
  8020f7:	90                   	nop
  8020f8:	c9                   	leaveq 
  8020f9:	c3                   	retq   

00000000008020fa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020fa:	55                   	push   %rbp
  8020fb:	48 89 e5             	mov    %rsp,%rbp
  8020fe:	48 83 ec 40          	sub    $0x40,%rsp
  802102:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802105:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802108:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80210c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80210f:	48 89 d6             	mov    %rdx,%rsi
  802112:	89 c7                	mov    %eax,%edi
  802114:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	callq  *%rax
  802120:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802123:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802127:	79 08                	jns    802131 <dup+0x37>
		return r;
  802129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212c:	e9 70 01 00 00       	jmpq   8022a1 <dup+0x1a7>
	close(newfdnum);
  802131:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802134:	89 c7                	mov    %eax,%edi
  802136:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802142:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802145:	48 98                	cltq   
  802147:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80214d:	48 c1 e0 0c          	shl    $0xc,%rax
  802151:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802159:	48 89 c7             	mov    %rax,%rdi
  80215c:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax
  802168:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80216c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802170:	48 89 c7             	mov    %rax,%rdi
  802173:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
  80217f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802187:	48 c1 e8 15          	shr    $0x15,%rax
  80218b:	48 89 c2             	mov    %rax,%rdx
  80218e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802195:	01 00 00 
  802198:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219c:	83 e0 01             	and    $0x1,%eax
  80219f:	48 85 c0             	test   %rax,%rax
  8021a2:	74 71                	je     802215 <dup+0x11b>
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8021ac:	48 89 c2             	mov    %rax,%rdx
  8021af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b6:	01 00 00 
  8021b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021bd:	83 e0 01             	and    $0x1,%eax
  8021c0:	48 85 c0             	test   %rax,%rax
  8021c3:	74 50                	je     802215 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8021cd:	48 89 c2             	mov    %rax,%rdx
  8021d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021d7:	01 00 00 
  8021da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021de:	25 07 0e 00 00       	and    $0xe07,%eax
  8021e3:	89 c1                	mov    %eax,%ecx
  8021e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ed:	41 89 c8             	mov    %ecx,%r8d
  8021f0:	48 89 d1             	mov    %rdx,%rcx
  8021f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f8:	48 89 c6             	mov    %rax,%rsi
  8021fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802200:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
  80220c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802213:	78 55                	js     80226a <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802219:	48 c1 e8 0c          	shr    $0xc,%rax
  80221d:	48 89 c2             	mov    %rax,%rdx
  802220:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802227:	01 00 00 
  80222a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222e:	25 07 0e 00 00       	and    $0xe07,%eax
  802233:	89 c1                	mov    %eax,%ecx
  802235:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802239:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223d:	41 89 c8             	mov    %ecx,%r8d
  802240:	48 89 d1             	mov    %rdx,%rcx
  802243:	ba 00 00 00 00       	mov    $0x0,%edx
  802248:	48 89 c6             	mov    %rax,%rsi
  80224b:	bf 00 00 00 00       	mov    $0x0,%edi
  802250:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  802257:	00 00 00 
  80225a:	ff d0                	callq  *%rax
  80225c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802263:	78 08                	js     80226d <dup+0x173>
		goto err;

	return newfdnum;
  802265:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802268:	eb 37                	jmp    8022a1 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80226a:	90                   	nop
  80226b:	eb 01                	jmp    80226e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80226d:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80226e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802272:	48 89 c6             	mov    %rax,%rsi
  802275:	bf 00 00 00 00       	mov    $0x0,%edi
  80227a:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  802281:	00 00 00 
  802284:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80228a:	48 89 c6             	mov    %rax,%rsi
  80228d:	bf 00 00 00 00       	mov    $0x0,%edi
  802292:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
	return r;
  80229e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022a1:	c9                   	leaveq 
  8022a2:	c3                   	retq   

00000000008022a3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	48 83 ec 40          	sub    $0x40,%rsp
  8022ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022b2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022b6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022bd:	48 89 d6             	mov    %rdx,%rsi
  8022c0:	89 c7                	mov    %eax,%edi
  8022c2:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8022c9:	00 00 00 
  8022cc:	ff d0                	callq  *%rax
  8022ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d5:	78 24                	js     8022fb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022db:	8b 00                	mov    (%rax),%eax
  8022dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022e1:	48 89 d6             	mov    %rdx,%rsi
  8022e4:	89 c7                	mov    %eax,%edi
  8022e6:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
  8022f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f9:	79 05                	jns    802300 <read+0x5d>
		return r;
  8022fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fe:	eb 76                	jmp    802376 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802304:	8b 40 08             	mov    0x8(%rax),%eax
  802307:	83 e0 03             	and    $0x3,%eax
  80230a:	83 f8 01             	cmp    $0x1,%eax
  80230d:	75 3a                	jne    802349 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80230f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802316:	00 00 00 
  802319:	48 8b 00             	mov    (%rax),%rax
  80231c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802322:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802325:	89 c6                	mov    %eax,%esi
  802327:	48 bf b7 51 80 00 00 	movabs $0x8051b7,%rdi
  80232e:	00 00 00 
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
  802336:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80233d:	00 00 00 
  802340:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802342:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802347:	eb 2d                	jmp    802376 <read+0xd3>
	}
	if (!dev->dev_read)
  802349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802351:	48 85 c0             	test   %rax,%rax
  802354:	75 07                	jne    80235d <read+0xba>
		return -E_NOT_SUPP;
  802356:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80235b:	eb 19                	jmp    802376 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80235d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802361:	48 8b 40 10          	mov    0x10(%rax),%rax
  802365:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802369:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80236d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802371:	48 89 cf             	mov    %rcx,%rdi
  802374:	ff d0                	callq  *%rax
}
  802376:	c9                   	leaveq 
  802377:	c3                   	retq   

0000000000802378 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802378:	55                   	push   %rbp
  802379:	48 89 e5             	mov    %rsp,%rbp
  80237c:	48 83 ec 30          	sub    $0x30,%rsp
  802380:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802383:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802387:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80238b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802392:	eb 47                	jmp    8023db <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802397:	48 98                	cltq   
  802399:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80239d:	48 29 c2             	sub    %rax,%rdx
  8023a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a3:	48 63 c8             	movslq %eax,%rcx
  8023a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023aa:	48 01 c1             	add    %rax,%rcx
  8023ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023b0:	48 89 ce             	mov    %rcx,%rsi
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023c8:	79 05                	jns    8023cf <readn+0x57>
			return m;
  8023ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023cd:	eb 1d                	jmp    8023ec <readn+0x74>
		if (m == 0)
  8023cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d3:	74 13                	je     8023e8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023d8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023de:	48 98                	cltq   
  8023e0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023e4:	72 ae                	jb     802394 <readn+0x1c>
  8023e6:	eb 01                	jmp    8023e9 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023e8:	90                   	nop
	}
	return tot;
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023ec:	c9                   	leaveq 
  8023ed:	c3                   	retq   

00000000008023ee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	48 83 ec 40          	sub    $0x40,%rsp
  8023f6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023fd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802401:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802405:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802408:	48 89 d6             	mov    %rdx,%rsi
  80240b:	89 c7                	mov    %eax,%edi
  80240d:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802414:	00 00 00 
  802417:	ff d0                	callq  *%rax
  802419:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80241c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802420:	78 24                	js     802446 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802426:	8b 00                	mov    (%rax),%eax
  802428:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80242c:	48 89 d6             	mov    %rdx,%rsi
  80242f:	89 c7                	mov    %eax,%edi
  802431:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
  80243d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802440:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802444:	79 05                	jns    80244b <write+0x5d>
		return r;
  802446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802449:	eb 75                	jmp    8024c0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80244b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244f:	8b 40 08             	mov    0x8(%rax),%eax
  802452:	83 e0 03             	and    $0x3,%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	75 3a                	jne    802493 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802459:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802460:	00 00 00 
  802463:	48 8b 00             	mov    (%rax),%rax
  802466:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80246c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80246f:	89 c6                	mov    %eax,%esi
  802471:	48 bf d3 51 80 00 00 	movabs $0x8051d3,%rdi
  802478:	00 00 00 
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802487:	00 00 00 
  80248a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80248c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802491:	eb 2d                	jmp    8024c0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802497:	48 8b 40 18          	mov    0x18(%rax),%rax
  80249b:	48 85 c0             	test   %rax,%rax
  80249e:	75 07                	jne    8024a7 <write+0xb9>
		return -E_NOT_SUPP;
  8024a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024a5:	eb 19                	jmp    8024c0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ab:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024af:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024b7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024bb:	48 89 cf             	mov    %rcx,%rdi
  8024be:	ff d0                	callq  *%rax
}
  8024c0:	c9                   	leaveq 
  8024c1:	c3                   	retq   

00000000008024c2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024c2:	55                   	push   %rbp
  8024c3:	48 89 e5             	mov    %rsp,%rbp
  8024c6:	48 83 ec 18          	sub    $0x18,%rsp
  8024ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024cd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d7:	48 89 d6             	mov    %rdx,%rsi
  8024da:	89 c7                	mov    %eax,%edi
  8024dc:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8024e3:	00 00 00 
  8024e6:	ff d0                	callq  *%rax
  8024e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ef:	79 05                	jns    8024f6 <seek+0x34>
		return r;
  8024f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f4:	eb 0f                	jmp    802505 <seek+0x43>
	fd->fd_offset = offset;
  8024f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024fd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802505:	c9                   	leaveq 
  802506:	c3                   	retq   

0000000000802507 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802507:	55                   	push   %rbp
  802508:	48 89 e5             	mov    %rsp,%rbp
  80250b:	48 83 ec 30          	sub    $0x30,%rsp
  80250f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802512:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802515:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802519:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80251c:	48 89 d6             	mov    %rdx,%rsi
  80251f:	89 c7                	mov    %eax,%edi
  802521:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax
  80252d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802534:	78 24                	js     80255a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253a:	8b 00                	mov    (%rax),%eax
  80253c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802540:	48 89 d6             	mov    %rdx,%rsi
  802543:	89 c7                	mov    %eax,%edi
  802545:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  80254c:	00 00 00 
  80254f:	ff d0                	callq  *%rax
  802551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802558:	79 05                	jns    80255f <ftruncate+0x58>
		return r;
  80255a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255d:	eb 72                	jmp    8025d1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80255f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802563:	8b 40 08             	mov    0x8(%rax),%eax
  802566:	83 e0 03             	and    $0x3,%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 3a                	jne    8025a7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80256d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802574:	00 00 00 
  802577:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80257a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802580:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802583:	89 c6                	mov    %eax,%esi
  802585:	48 bf f0 51 80 00 00 	movabs $0x8051f0,%rdi
  80258c:	00 00 00 
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80259b:	00 00 00 
  80259e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a5:	eb 2a                	jmp    8025d1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ab:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025af:	48 85 c0             	test   %rax,%rax
  8025b2:	75 07                	jne    8025bb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025b4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025b9:	eb 16                	jmp    8025d1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025c7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025ca:	89 ce                	mov    %ecx,%esi
  8025cc:	48 89 d7             	mov    %rdx,%rdi
  8025cf:	ff d0                	callq  *%rax
}
  8025d1:	c9                   	leaveq 
  8025d2:	c3                   	retq   

00000000008025d3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025d3:	55                   	push   %rbp
  8025d4:	48 89 e5             	mov    %rsp,%rbp
  8025d7:	48 83 ec 30          	sub    $0x30,%rsp
  8025db:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025e2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025e9:	48 89 d6             	mov    %rdx,%rsi
  8025ec:	89 c7                	mov    %eax,%edi
  8025ee:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	callq  *%rax
  8025fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802601:	78 24                	js     802627 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802607:	8b 00                	mov    (%rax),%eax
  802609:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80260d:	48 89 d6             	mov    %rdx,%rsi
  802610:	89 c7                	mov    %eax,%edi
  802612:	48 b8 c9 1f 80 00 00 	movabs $0x801fc9,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802625:	79 05                	jns    80262c <fstat+0x59>
		return r;
  802627:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262a:	eb 5e                	jmp    80268a <fstat+0xb7>
	if (!dev->dev_stat)
  80262c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802630:	48 8b 40 28          	mov    0x28(%rax),%rax
  802634:	48 85 c0             	test   %rax,%rax
  802637:	75 07                	jne    802640 <fstat+0x6d>
		return -E_NOT_SUPP;
  802639:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80263e:	eb 4a                	jmp    80268a <fstat+0xb7>
	stat->st_name[0] = 0;
  802640:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802644:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802647:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80264b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802652:	00 00 00 
	stat->st_isdir = 0;
  802655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802659:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802660:	00 00 00 
	stat->st_dev = dev;
  802663:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802667:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80266b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802676:	48 8b 40 28          	mov    0x28(%rax),%rax
  80267a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80267e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802682:	48 89 ce             	mov    %rcx,%rsi
  802685:	48 89 d7             	mov    %rdx,%rdi
  802688:	ff d0                	callq  *%rax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 20          	sub    $0x20,%rsp
  802694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802698:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80269c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a0:	be 00 00 00 00       	mov    $0x0,%esi
  8026a5:	48 89 c7             	mov    %rax,%rdi
  8026a8:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	callq  *%rax
  8026b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bb:	79 05                	jns    8026c2 <stat+0x36>
		return fd;
  8026bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c0:	eb 2f                	jmp    8026f1 <stat+0x65>
	r = fstat(fd, stat);
  8026c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c9:	48 89 d6             	mov    %rdx,%rsi
  8026cc:	89 c7                	mov    %eax,%edi
  8026ce:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
  8026da:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e0:	89 c7                	mov    %eax,%edi
  8026e2:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  8026e9:	00 00 00 
  8026ec:	ff d0                	callq  *%rax
	return r;
  8026ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026f1:	c9                   	leaveq 
  8026f2:	c3                   	retq   

00000000008026f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026f3:	55                   	push   %rbp
  8026f4:	48 89 e5             	mov    %rsp,%rbp
  8026f7:	48 83 ec 10          	sub    $0x10,%rsp
  8026fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802702:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802709:	00 00 00 
  80270c:	8b 00                	mov    (%rax),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	75 1f                	jne    802731 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802712:	bf 01 00 00 00       	mov    $0x1,%edi
  802717:	48 b8 f8 4a 80 00 00 	movabs $0x804af8,%rax
  80271e:	00 00 00 
  802721:	ff d0                	callq  *%rax
  802723:	89 c2                	mov    %eax,%edx
  802725:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80272c:	00 00 00 
  80272f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802731:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802738:	00 00 00 
  80273b:	8b 00                	mov    (%rax),%eax
  80273d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802740:	b9 07 00 00 00       	mov    $0x7,%ecx
  802745:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80274c:	00 00 00 
  80274f:	89 c7                	mov    %eax,%edi
  802751:	48 b8 63 4a 80 00 00 	movabs $0x804a63,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80275d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802761:	ba 00 00 00 00       	mov    $0x0,%edx
  802766:	48 89 c6             	mov    %rax,%rsi
  802769:	bf 00 00 00 00       	mov    $0x0,%edi
  80276e:	48 b8 a2 49 80 00 00 	movabs $0x8049a2,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
}
  80277a:	c9                   	leaveq 
  80277b:	c3                   	retq   

000000000080277c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80277c:	55                   	push   %rbp
  80277d:	48 89 e5             	mov    %rsp,%rbp
  802780:	48 83 ec 20          	sub    $0x20,%rsp
  802784:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802788:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80278b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278f:	48 89 c7             	mov    %rax,%rdi
  802792:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  802799:	00 00 00 
  80279c:	ff d0                	callq  *%rax
  80279e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027a3:	7e 0a                	jle    8027af <open+0x33>
		return -E_BAD_PATH;
  8027a5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027aa:	e9 a5 00 00 00       	jmpq   802854 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8027af:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027b3:	48 89 c7             	mov    %rax,%rdi
  8027b6:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
  8027c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c9:	79 08                	jns    8027d3 <open+0x57>
		return r;
  8027cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ce:	e9 81 00 00 00       	jmpq   802854 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8027d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d7:	48 89 c6             	mov    %rax,%rsi
  8027da:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8027e1:	00 00 00 
  8027e4:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8027eb:	00 00 00 
  8027ee:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8027f0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027f7:	00 00 00 
  8027fa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027fd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802807:	48 89 c6             	mov    %rax,%rsi
  80280a:	bf 01 00 00 00       	mov    $0x1,%edi
  80280f:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802816:	00 00 00 
  802819:	ff d0                	callq  *%rax
  80281b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802822:	79 1d                	jns    802841 <open+0xc5>
		fd_close(fd, 0);
  802824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802828:	be 00 00 00 00       	mov    $0x0,%esi
  80282d:	48 89 c7             	mov    %rax,%rdi
  802830:	48 b8 fe 1e 80 00 00 	movabs $0x801efe,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
		return r;
  80283c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283f:	eb 13                	jmp    802854 <open+0xd8>
	}

	return fd2num(fd);
  802841:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802845:	48 89 c7             	mov    %rax,%rdi
  802848:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax

}
  802854:	c9                   	leaveq 
  802855:	c3                   	retq   

0000000000802856 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802856:	55                   	push   %rbp
  802857:	48 89 e5             	mov    %rsp,%rbp
  80285a:	48 83 ec 10          	sub    $0x10,%rsp
  80285e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802866:	8b 50 0c             	mov    0xc(%rax),%edx
  802869:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802870:	00 00 00 
  802873:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802875:	be 00 00 00 00       	mov    $0x0,%esi
  80287a:	bf 06 00 00 00       	mov    $0x6,%edi
  80287f:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
}
  80288b:	c9                   	leaveq 
  80288c:	c3                   	retq   

000000000080288d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80288d:	55                   	push   %rbp
  80288e:	48 89 e5             	mov    %rsp,%rbp
  802891:	48 83 ec 30          	sub    $0x30,%rsp
  802895:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802899:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80289d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a5:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028af:	00 00 00 
  8028b2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028b4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028bb:	00 00 00 
  8028be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028c6:	be 00 00 00 00       	mov    $0x0,%esi
  8028cb:	bf 03 00 00 00       	mov    $0x3,%edi
  8028d0:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
  8028dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e3:	79 08                	jns    8028ed <devfile_read+0x60>
		return r;
  8028e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e8:	e9 a4 00 00 00       	jmpq   802991 <devfile_read+0x104>
	assert(r <= n);
  8028ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f0:	48 98                	cltq   
  8028f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028f6:	76 35                	jbe    80292d <devfile_read+0xa0>
  8028f8:	48 b9 16 52 80 00 00 	movabs $0x805216,%rcx
  8028ff:	00 00 00 
  802902:	48 ba 1d 52 80 00 00 	movabs $0x80521d,%rdx
  802909:	00 00 00 
  80290c:	be 86 00 00 00       	mov    $0x86,%esi
  802911:	48 bf 32 52 80 00 00 	movabs $0x805232,%rdi
  802918:	00 00 00 
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
  802920:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802927:	00 00 00 
  80292a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80292d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802934:	7e 35                	jle    80296b <devfile_read+0xde>
  802936:	48 b9 3d 52 80 00 00 	movabs $0x80523d,%rcx
  80293d:	00 00 00 
  802940:	48 ba 1d 52 80 00 00 	movabs $0x80521d,%rdx
  802947:	00 00 00 
  80294a:	be 87 00 00 00       	mov    $0x87,%esi
  80294f:	48 bf 32 52 80 00 00 	movabs $0x805232,%rdi
  802956:	00 00 00 
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802965:	00 00 00 
  802968:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80296b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296e:	48 63 d0             	movslq %eax,%rdx
  802971:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802975:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80297c:	00 00 00 
  80297f:	48 89 c7             	mov    %rax,%rdi
  802982:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  802989:	00 00 00 
  80298c:	ff d0                	callq  *%rax
	return r;
  80298e:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802991:	c9                   	leaveq 
  802992:	c3                   	retq   

0000000000802993 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802993:	55                   	push   %rbp
  802994:	48 89 e5             	mov    %rsp,%rbp
  802997:	48 83 ec 40          	sub    $0x40,%rsp
  80299b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80299f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029a3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8029a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029af:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8029b6:	00 
  8029b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8029bf:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8029c4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029cf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029d6:	00 00 00 
  8029d9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8029db:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029e2:	00 00 00 
  8029e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029e9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8029ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f5:	48 89 c6             	mov    %rax,%rsi
  8029f8:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8029ff:	00 00 00 
  802a02:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a0e:	be 00 00 00 00       	mov    $0x0,%esi
  802a13:	bf 04 00 00 00       	mov    $0x4,%edi
  802a18:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802a1f:	00 00 00 
  802a22:	ff d0                	callq  *%rax
  802a24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a2b:	79 05                	jns    802a32 <devfile_write+0x9f>
		return r;
  802a2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a30:	eb 43                	jmp    802a75 <devfile_write+0xe2>
	assert(r <= n);
  802a32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a35:	48 98                	cltq   
  802a37:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a3b:	76 35                	jbe    802a72 <devfile_write+0xdf>
  802a3d:	48 b9 16 52 80 00 00 	movabs $0x805216,%rcx
  802a44:	00 00 00 
  802a47:	48 ba 1d 52 80 00 00 	movabs $0x80521d,%rdx
  802a4e:	00 00 00 
  802a51:	be a2 00 00 00       	mov    $0xa2,%esi
  802a56:	48 bf 32 52 80 00 00 	movabs $0x805232,%rdi
  802a5d:	00 00 00 
  802a60:	b8 00 00 00 00       	mov    $0x0,%eax
  802a65:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802a6c:	00 00 00 
  802a6f:	41 ff d0             	callq  *%r8
	return r;
  802a72:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802a75:	c9                   	leaveq 
  802a76:	c3                   	retq   

0000000000802a77 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a77:	55                   	push   %rbp
  802a78:	48 89 e5             	mov    %rsp,%rbp
  802a7b:	48 83 ec 20          	sub    $0x20,%rsp
  802a7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8b:	8b 50 0c             	mov    0xc(%rax),%edx
  802a8e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a95:	00 00 00 
  802a98:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a9a:	be 00 00 00 00       	mov    $0x0,%esi
  802a9f:	bf 05 00 00 00       	mov    $0x5,%edi
  802aa4:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802aab:	00 00 00 
  802aae:	ff d0                	callq  *%rax
  802ab0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab7:	79 05                	jns    802abe <devfile_stat+0x47>
		return r;
  802ab9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abc:	eb 56                	jmp    802b14 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802abe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac2:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802ac9:	00 00 00 
  802acc:	48 89 c7             	mov    %rax,%rdi
  802acf:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802adb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ae2:	00 00 00 
  802ae5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802aeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aef:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802af5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802afc:	00 00 00 
  802aff:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b09:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b14:	c9                   	leaveq 
  802b15:	c3                   	retq   

0000000000802b16 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b16:	55                   	push   %rbp
  802b17:	48 89 e5             	mov    %rsp,%rbp
  802b1a:	48 83 ec 10          	sub    $0x10,%rsp
  802b1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b22:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b29:	8b 50 0c             	mov    0xc(%rax),%edx
  802b2c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b33:	00 00 00 
  802b36:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b38:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b3f:	00 00 00 
  802b42:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b45:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b48:	be 00 00 00 00       	mov    $0x0,%esi
  802b4d:	bf 02 00 00 00       	mov    $0x2,%edi
  802b52:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
}
  802b5e:	c9                   	leaveq 
  802b5f:	c3                   	retq   

0000000000802b60 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b60:	55                   	push   %rbp
  802b61:	48 89 e5             	mov    %rsp,%rbp
  802b64:	48 83 ec 10          	sub    $0x10,%rsp
  802b68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b70:	48 89 c7             	mov    %rax,%rdi
  802b73:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  802b7a:	00 00 00 
  802b7d:	ff d0                	callq  *%rax
  802b7f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b84:	7e 07                	jle    802b8d <remove+0x2d>
		return -E_BAD_PATH;
  802b86:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b8b:	eb 33                	jmp    802bc0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b91:	48 89 c6             	mov    %rax,%rsi
  802b94:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802b9b:	00 00 00 
  802b9e:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802baa:	be 00 00 00 00       	mov    $0x0,%esi
  802baf:	bf 07 00 00 00       	mov    $0x7,%edi
  802bb4:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802bbb:	00 00 00 
  802bbe:	ff d0                	callq  *%rax
}
  802bc0:	c9                   	leaveq 
  802bc1:	c3                   	retq   

0000000000802bc2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bc2:	55                   	push   %rbp
  802bc3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bc6:	be 00 00 00 00       	mov    $0x0,%esi
  802bcb:	bf 08 00 00 00       	mov    $0x8,%edi
  802bd0:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
}
  802bdc:	5d                   	pop    %rbp
  802bdd:	c3                   	retq   

0000000000802bde <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802bde:	55                   	push   %rbp
  802bdf:	48 89 e5             	mov    %rsp,%rbp
  802be2:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802be9:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802bf0:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802bf7:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802bfe:	be 00 00 00 00       	mov    $0x0,%esi
  802c03:	48 89 c7             	mov    %rax,%rdi
  802c06:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  802c0d:	00 00 00 
  802c10:	ff d0                	callq  *%rax
  802c12:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c19:	79 28                	jns    802c43 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1e:	89 c6                	mov    %eax,%esi
  802c20:	48 bf 49 52 80 00 00 	movabs $0x805249,%rdi
  802c27:	00 00 00 
  802c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2f:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802c36:	00 00 00 
  802c39:	ff d2                	callq  *%rdx
		return fd_src;
  802c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3e:	e9 76 01 00 00       	jmpq   802db9 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c43:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c4a:	be 01 01 00 00       	mov    $0x101,%esi
  802c4f:	48 89 c7             	mov    %rax,%rdi
  802c52:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  802c59:	00 00 00 
  802c5c:	ff d0                	callq  *%rax
  802c5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c61:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c65:	0f 89 ad 00 00 00    	jns    802d18 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c6e:	89 c6                	mov    %eax,%esi
  802c70:	48 bf 5f 52 80 00 00 	movabs $0x80525f,%rdi
  802c77:	00 00 00 
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7f:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802c86:	00 00 00 
  802c89:	ff d2                	callq  *%rdx
		close(fd_src);
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	89 c7                	mov    %eax,%edi
  802c90:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
		return fd_dest;
  802c9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c9f:	e9 15 01 00 00       	jmpq   802db9 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802ca4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ca7:	48 63 d0             	movslq %eax,%rdx
  802caa:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb4:	48 89 ce             	mov    %rcx,%rsi
  802cb7:	89 c7                	mov    %eax,%edi
  802cb9:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	callq  *%rax
  802cc5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802ccc:	79 4a                	jns    802d18 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802cce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cd1:	89 c6                	mov    %eax,%esi
  802cd3:	48 bf 79 52 80 00 00 	movabs $0x805279,%rdi
  802cda:	00 00 00 
  802cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce2:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802ce9:	00 00 00 
  802cec:	ff d2                	callq  *%rdx
			close(fd_src);
  802cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf1:	89 c7                	mov    %eax,%edi
  802cf3:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
			close(fd_dest);
  802cff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d02:	89 c7                	mov    %eax,%edi
  802d04:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802d0b:	00 00 00 
  802d0e:	ff d0                	callq  *%rax
			return write_size;
  802d10:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d13:	e9 a1 00 00 00       	jmpq   802db9 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d18:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d22:	ba 00 02 00 00       	mov    $0x200,%edx
  802d27:	48 89 ce             	mov    %rcx,%rsi
  802d2a:	89 c7                	mov    %eax,%edi
  802d2c:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	callq  *%rax
  802d38:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d3f:	0f 8f 5f ff ff ff    	jg     802ca4 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d49:	79 47                	jns    802d92 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802d4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d4e:	89 c6                	mov    %eax,%esi
  802d50:	48 bf 8c 52 80 00 00 	movabs $0x80528c,%rdi
  802d57:	00 00 00 
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5f:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802d66:	00 00 00 
  802d69:	ff d2                	callq  *%rdx
		close(fd_src);
  802d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6e:	89 c7                	mov    %eax,%edi
  802d70:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
		close(fd_dest);
  802d7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d7f:	89 c7                	mov    %eax,%edi
  802d81:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802d88:	00 00 00 
  802d8b:	ff d0                	callq  *%rax
		return read_size;
  802d8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d90:	eb 27                	jmp    802db9 <copy+0x1db>
	}
	close(fd_src);
  802d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d95:	89 c7                	mov    %eax,%edi
  802d97:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802d9e:	00 00 00 
  802da1:	ff d0                	callq  *%rax
	close(fd_dest);
  802da3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da6:	89 c7                	mov    %eax,%edi
  802da8:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
	return 0;
  802db4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802db9:	c9                   	leaveq 
  802dba:	c3                   	retq   

0000000000802dbb <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802dbb:	55                   	push   %rbp
  802dbc:	48 89 e5             	mov    %rsp,%rbp
  802dbf:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802dc6:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802dcd:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802dd4:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802df2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802df6:	79 08                	jns    802e00 <spawn+0x45>
		return r;
  802df8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dfb:	e9 11 03 00 00       	jmpq   803111 <spawn+0x356>
	fd = r;
  802e00:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e03:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802e06:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802e0d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802e11:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802e18:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e1b:	ba 00 02 00 00       	mov    $0x200,%edx
  802e20:	48 89 ce             	mov    %rcx,%rsi
  802e23:	89 c7                	mov    %eax,%edi
  802e25:	48 b8 78 23 80 00 00 	movabs $0x802378,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	3d 00 02 00 00       	cmp    $0x200,%eax
  802e36:	75 0d                	jne    802e45 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802e38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e3c:	8b 00                	mov    (%rax),%eax
  802e3e:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802e43:	74 43                	je     802e88 <spawn+0xcd>
		close(fd);
  802e45:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e48:	89 c7                	mov    %eax,%edi
  802e4a:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e5a:	8b 00                	mov    (%rax),%eax
  802e5c:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802e61:	89 c6                	mov    %eax,%esi
  802e63:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  802e6a:	00 00 00 
  802e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e72:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802e79:	00 00 00 
  802e7c:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802e7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e83:	e9 89 02 00 00       	jmpq   803111 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802e88:	b8 07 00 00 00       	mov    $0x7,%eax
  802e8d:	cd 30                	int    $0x30
  802e8f:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802e92:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802e95:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e98:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e9c:	79 08                	jns    802ea6 <spawn+0xeb>
		return r;
  802e9e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ea1:	e9 6b 02 00 00       	jmpq   803111 <spawn+0x356>
	child = r;
  802ea6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ea9:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802eac:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eaf:	25 ff 03 00 00       	and    $0x3ff,%eax
  802eb4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802ebb:	00 00 00 
  802ebe:	48 98                	cltq   
  802ec0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802ec7:	48 01 c2             	add    %rax,%rdx
  802eca:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802ed1:	48 89 d6             	mov    %rdx,%rsi
  802ed4:	ba 18 00 00 00       	mov    $0x18,%edx
  802ed9:	48 89 c7             	mov    %rax,%rdi
  802edc:	48 89 d1             	mov    %rdx,%rcx
  802edf:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802ee2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802eea:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802ef1:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802ef8:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802eff:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802f06:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f09:	48 89 ce             	mov    %rcx,%rsi
  802f0c:	89 c7                	mov    %eax,%edi
  802f0e:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f21:	79 08                	jns    802f2b <spawn+0x170>
		return r;
  802f23:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f26:	e9 e6 01 00 00       	jmpq   803111 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802f2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802f33:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802f3a:	48 01 d0             	add    %rdx,%rax
  802f3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802f41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f48:	e9 80 00 00 00       	jmpq   802fcd <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  802f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f51:	8b 00                	mov    (%rax),%eax
  802f53:	83 f8 01             	cmp    $0x1,%eax
  802f56:	75 6b                	jne    802fc3 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  802f58:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f63:	8b 40 04             	mov    0x4(%rax),%eax
  802f66:	83 e0 02             	and    $0x2,%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 04                	je     802f71 <spawn+0x1b6>
			perm |= PTE_W;
  802f6d:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f75:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802f79:	41 89 c1             	mov    %eax,%r9d
  802f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f80:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802f84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f88:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f90:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802f94:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f97:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f9a:	48 83 ec 08          	sub    $0x8,%rsp
  802f9e:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802fa1:	57                   	push   %rdi
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 21 36 80 00 00 	movabs $0x803621,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
  802fb0:	48 83 c4 10          	add    $0x10,%rsp
  802fb4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fbb:	0f 88 2a 01 00 00    	js     8030eb <spawn+0x330>
  802fc1:	eb 01                	jmp    802fc4 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  802fc3:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802fc4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802fc8:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802fcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd1:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802fd5:	0f b7 c0             	movzwl %ax,%eax
  802fd8:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802fdb:	0f 8f 6c ff ff ff    	jg     802f4d <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802fe1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802fe4:	89 c7                	mov    %eax,%edi
  802fe6:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802fed:	00 00 00 
  802ff0:	ff d0                	callq  *%rax
	fd = -1;
  802ff2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802ff9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ffc:	89 c7                	mov    %eax,%edi
  802ffe:	48 b8 0d 38 80 00 00 	movabs $0x80380d,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
  80300a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80300d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803011:	79 30                	jns    803043 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  803013:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803016:	89 c1                	mov    %eax,%ecx
  803018:	48 ba c2 52 80 00 00 	movabs $0x8052c2,%rdx
  80301f:	00 00 00 
  803022:	be 86 00 00 00       	mov    $0x86,%esi
  803027:	48 bf d8 52 80 00 00 	movabs $0x8052d8,%rdi
  80302e:	00 00 00 
  803031:	b8 00 00 00 00       	mov    $0x0,%eax
  803036:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  80303d:	00 00 00 
  803040:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803043:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80304a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80304d:	48 89 d6             	mov    %rdx,%rsi
  803050:	89 c7                	mov    %eax,%edi
  803052:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax
  80305e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803061:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803065:	79 30                	jns    803097 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  803067:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80306a:	89 c1                	mov    %eax,%ecx
  80306c:	48 ba e4 52 80 00 00 	movabs $0x8052e4,%rdx
  803073:	00 00 00 
  803076:	be 8a 00 00 00       	mov    $0x8a,%esi
  80307b:	48 bf d8 52 80 00 00 	movabs $0x8052d8,%rdi
  803082:	00 00 00 
  803085:	b8 00 00 00 00       	mov    $0x0,%eax
  80308a:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  803091:	00 00 00 
  803094:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803097:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80309a:	be 02 00 00 00       	mov    $0x2,%esi
  80309f:	89 c7                	mov    %eax,%edi
  8030a1:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8030b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8030b4:	79 30                	jns    8030e6 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  8030b6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030b9:	89 c1                	mov    %eax,%ecx
  8030bb:	48 ba fe 52 80 00 00 	movabs $0x8052fe,%rdx
  8030c2:	00 00 00 
  8030c5:	be 8d 00 00 00       	mov    $0x8d,%esi
  8030ca:	48 bf d8 52 80 00 00 	movabs $0x8052d8,%rdi
  8030d1:	00 00 00 
  8030d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d9:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  8030e0:	00 00 00 
  8030e3:	41 ff d0             	callq  *%r8

	return child;
  8030e6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030e9:	eb 26                	jmp    803111 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8030eb:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8030ec:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030ef:	89 c7                	mov    %eax,%edi
  8030f1:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
	close(fd);
  8030fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
	return r;
  80310e:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  803111:	c9                   	leaveq 
  803112:	c3                   	retq   

0000000000803113 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803113:	55                   	push   %rbp
  803114:	48 89 e5             	mov    %rsp,%rbp
  803117:	41 55                	push   %r13
  803119:	41 54                	push   %r12
  80311b:	53                   	push   %rbx
  80311c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803123:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  80312a:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  803131:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803138:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  80313f:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803146:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80314d:	84 c0                	test   %al,%al
  80314f:	74 26                	je     803177 <spawnl+0x64>
  803151:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803158:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  80315f:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803163:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803167:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80316b:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  80316f:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803173:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803177:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80317e:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803181:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803188:	00 00 00 
  80318b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803192:	00 00 00 
  803195:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803199:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8031a0:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8031a7:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8031ae:	eb 07                	jmp    8031b7 <spawnl+0xa4>
		argc++;
  8031b0:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8031b7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8031bd:	83 f8 30             	cmp    $0x30,%eax
  8031c0:	73 23                	jae    8031e5 <spawnl+0xd2>
  8031c2:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8031c9:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8031cf:	89 d2                	mov    %edx,%edx
  8031d1:	48 01 d0             	add    %rdx,%rax
  8031d4:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8031da:	83 c2 08             	add    $0x8,%edx
  8031dd:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8031e3:	eb 12                	jmp    8031f7 <spawnl+0xe4>
  8031e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8031ec:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8031f0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8031f7:	48 8b 00             	mov    (%rax),%rax
  8031fa:	48 85 c0             	test   %rax,%rax
  8031fd:	75 b1                	jne    8031b0 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8031ff:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803205:	83 c0 02             	add    $0x2,%eax
  803208:	48 89 e2             	mov    %rsp,%rdx
  80320b:	48 89 d3             	mov    %rdx,%rbx
  80320e:	48 63 d0             	movslq %eax,%rdx
  803211:	48 83 ea 01          	sub    $0x1,%rdx
  803215:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80321c:	48 63 d0             	movslq %eax,%rdx
  80321f:	49 89 d4             	mov    %rdx,%r12
  803222:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803228:	48 63 d0             	movslq %eax,%rdx
  80322b:	49 89 d2             	mov    %rdx,%r10
  80322e:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803234:	48 98                	cltq   
  803236:	48 c1 e0 03          	shl    $0x3,%rax
  80323a:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80323e:	b8 10 00 00 00       	mov    $0x10,%eax
  803243:	48 83 e8 01          	sub    $0x1,%rax
  803247:	48 01 d0             	add    %rdx,%rax
  80324a:	be 10 00 00 00       	mov    $0x10,%esi
  80324f:	ba 00 00 00 00       	mov    $0x0,%edx
  803254:	48 f7 f6             	div    %rsi
  803257:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80325b:	48 29 c4             	sub    %rax,%rsp
  80325e:	48 89 e0             	mov    %rsp,%rax
  803261:	48 83 c0 07          	add    $0x7,%rax
  803265:	48 c1 e8 03          	shr    $0x3,%rax
  803269:	48 c1 e0 03          	shl    $0x3,%rax
  80326d:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803274:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80327b:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803282:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803285:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80328b:	8d 50 01             	lea    0x1(%rax),%edx
  80328e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803295:	48 63 d2             	movslq %edx,%rdx
  803298:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80329f:	00 

	va_start(vl, arg0);
  8032a0:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8032a7:	00 00 00 
  8032aa:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8032b1:	00 00 00 
  8032b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032b8:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8032bf:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8032c6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8032cd:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8032d4:	00 00 00 
  8032d7:	eb 60                	jmp    803339 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8032d9:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8032df:	8d 48 01             	lea    0x1(%rax),%ecx
  8032e2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8032e8:	83 f8 30             	cmp    $0x30,%eax
  8032eb:	73 23                	jae    803310 <spawnl+0x1fd>
  8032ed:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8032f4:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8032fa:	89 d2                	mov    %edx,%edx
  8032fc:	48 01 d0             	add    %rdx,%rax
  8032ff:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803305:	83 c2 08             	add    $0x8,%edx
  803308:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80330e:	eb 12                	jmp    803322 <spawnl+0x20f>
  803310:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803317:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80331b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803322:	48 8b 10             	mov    (%rax),%rdx
  803325:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80332c:	89 c9                	mov    %ecx,%ecx
  80332e:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803332:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803339:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80333f:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  803345:	72 92                	jb     8032d9 <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803347:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80334e:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803355:	48 89 d6             	mov    %rdx,%rsi
  803358:	48 89 c7             	mov    %rax,%rdi
  80335b:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803362:	00 00 00 
  803365:	ff d0                	callq  *%rax
  803367:	48 89 dc             	mov    %rbx,%rsp
}
  80336a:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80336e:	5b                   	pop    %rbx
  80336f:	41 5c                	pop    %r12
  803371:	41 5d                	pop    %r13
  803373:	5d                   	pop    %rbp
  803374:	c3                   	retq   

0000000000803375 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803375:	55                   	push   %rbp
  803376:	48 89 e5             	mov    %rsp,%rbp
  803379:	48 83 ec 50          	sub    $0x50,%rsp
  80337d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803380:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803384:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803388:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80338f:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803397:	eb 33                	jmp    8033cc <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803399:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80339c:	48 98                	cltq   
  80339e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033a5:	00 
  8033a6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033aa:	48 01 d0             	add    %rdx,%rax
  8033ad:	48 8b 00             	mov    (%rax),%rax
  8033b0:	48 89 c7             	mov    %rax,%rdi
  8033b3:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8033ba:	00 00 00 
  8033bd:	ff d0                	callq  *%rax
  8033bf:	83 c0 01             	add    $0x1,%eax
  8033c2:	48 98                	cltq   
  8033c4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8033c8:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8033cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033cf:	48 98                	cltq   
  8033d1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033d8:	00 
  8033d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033dd:	48 01 d0             	add    %rdx,%rax
  8033e0:	48 8b 00             	mov    (%rax),%rax
  8033e3:	48 85 c0             	test   %rax,%rax
  8033e6:	75 b1                	jne    803399 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8033e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ec:	48 f7 d8             	neg    %rax
  8033ef:	48 05 00 10 40 00    	add    $0x401000,%rax
  8033f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8033f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033fd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803405:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803409:	48 89 c2             	mov    %rax,%rdx
  80340c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80340f:	83 c0 01             	add    $0x1,%eax
  803412:	c1 e0 03             	shl    $0x3,%eax
  803415:	48 98                	cltq   
  803417:	48 f7 d8             	neg    %rax
  80341a:	48 01 d0             	add    %rdx,%rax
  80341d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803421:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803425:	48 83 e8 10          	sub    $0x10,%rax
  803429:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80342f:	77 0a                	ja     80343b <init_stack+0xc6>
		return -E_NO_MEM;
  803431:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803436:	e9 e4 01 00 00       	jmpq   80361f <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80343b:	ba 07 00 00 00       	mov    $0x7,%edx
  803440:	be 00 00 40 00       	mov    $0x400000,%esi
  803445:	bf 00 00 00 00       	mov    $0x0,%edi
  80344a:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
  803456:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803459:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80345d:	79 08                	jns    803467 <init_stack+0xf2>
		return r;
  80345f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803462:	e9 b8 01 00 00       	jmpq   80361f <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80346e:	e9 8a 00 00 00       	jmpq   8034fd <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  803473:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803476:	48 98                	cltq   
  803478:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80347f:	00 
  803480:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803484:	48 01 d0             	add    %rdx,%rax
  803487:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80348c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803490:	48 01 ca             	add    %rcx,%rdx
  803493:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80349a:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  80349d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034a0:	48 98                	cltq   
  8034a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034a9:	00 
  8034aa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8034ae:	48 01 d0             	add    %rdx,%rax
  8034b1:	48 8b 10             	mov    (%rax),%rdx
  8034b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b8:	48 89 d6             	mov    %rdx,%rsi
  8034bb:	48 89 c7             	mov    %rax,%rdi
  8034be:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8034ca:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034cd:	48 98                	cltq   
  8034cf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034d6:	00 
  8034d7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8034db:	48 01 d0             	add    %rdx,%rax
  8034de:	48 8b 00             	mov    (%rax),%rax
  8034e1:	48 89 c7             	mov    %rax,%rdi
  8034e4:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
  8034f0:	83 c0 01             	add    $0x1,%eax
  8034f3:	48 98                	cltq   
  8034f5:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8034f9:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8034fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803500:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803503:	0f 8c 6a ff ff ff    	jl     803473 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803509:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80350c:	48 98                	cltq   
  80350e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803515:	00 
  803516:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351a:	48 01 d0             	add    %rdx,%rax
  80351d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803524:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80352b:	00 
  80352c:	74 35                	je     803563 <init_stack+0x1ee>
  80352e:	48 b9 18 53 80 00 00 	movabs $0x805318,%rcx
  803535:	00 00 00 
  803538:	48 ba 3e 53 80 00 00 	movabs $0x80533e,%rdx
  80353f:	00 00 00 
  803542:	be f6 00 00 00       	mov    $0xf6,%esi
  803547:	48 bf d8 52 80 00 00 	movabs $0x8052d8,%rdi
  80354e:	00 00 00 
  803551:	b8 00 00 00 00       	mov    $0x0,%eax
  803556:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  80355d:	00 00 00 
  803560:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803563:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803567:	48 83 e8 08          	sub    $0x8,%rax
  80356b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803570:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803574:	48 01 ca             	add    %rcx,%rdx
  803577:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80357e:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  803581:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803585:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803589:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80358c:	48 98                	cltq   
  80358e:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803591:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803596:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359a:	48 01 d0             	add    %rdx,%rax
  80359d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8035a3:	48 89 c2             	mov    %rax,%rdx
  8035a6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8035aa:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8035ad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8035b0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8035b6:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8035bb:	89 c2                	mov    %eax,%edx
  8035bd:	be 00 00 40 00       	mov    $0x400000,%esi
  8035c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c7:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
  8035d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035da:	78 26                	js     803602 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8035dc:	be 00 00 40 00       	mov    $0x400000,%esi
  8035e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e6:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f9:	78 0a                	js     803605 <init_stack+0x290>
		goto error;

	return 0;
  8035fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803600:	eb 1d                	jmp    80361f <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803602:	90                   	nop
  803603:	eb 01                	jmp    803606 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803605:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803606:	be 00 00 40 00       	mov    $0x400000,%esi
  80360b:	bf 00 00 00 00       	mov    $0x0,%edi
  803610:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
	return r;
  80361c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80361f:	c9                   	leaveq 
  803620:	c3                   	retq   

0000000000803621 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803621:	55                   	push   %rbp
  803622:	48 89 e5             	mov    %rsp,%rbp
  803625:	48 83 ec 50          	sub    $0x50,%rsp
  803629:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80362c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803630:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803634:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803637:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80363b:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80363f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803643:	25 ff 0f 00 00       	and    $0xfff,%eax
  803648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364f:	74 21                	je     803672 <map_segment+0x51>
		va -= i;
  803651:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803654:	48 98                	cltq   
  803656:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80365a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365d:	48 98                	cltq   
  80365f:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803663:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803666:	48 98                	cltq   
  803668:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80366c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366f:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803672:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803679:	e9 79 01 00 00       	jmpq   8037f7 <map_segment+0x1d6>
		if (i >= filesz) {
  80367e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803681:	48 98                	cltq   
  803683:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803687:	72 3c                	jb     8036c5 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368c:	48 63 d0             	movslq %eax,%rdx
  80368f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803693:	48 01 d0             	add    %rdx,%rax
  803696:	48 89 c1             	mov    %rax,%rcx
  803699:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80369c:	8b 55 10             	mov    0x10(%rbp),%edx
  80369f:	48 89 ce             	mov    %rcx,%rsi
  8036a2:	89 c7                	mov    %eax,%edi
  8036a4:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8036ab:	00 00 00 
  8036ae:	ff d0                	callq  *%rax
  8036b0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036b7:	0f 89 33 01 00 00    	jns    8037f0 <map_segment+0x1cf>
				return r;
  8036bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c0:	e9 46 01 00 00       	jmpq   80380b <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8036c5:	ba 07 00 00 00       	mov    $0x7,%edx
  8036ca:	be 00 00 40 00       	mov    $0x400000,%esi
  8036cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d4:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
  8036e0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036e7:	79 08                	jns    8036f1 <map_segment+0xd0>
				return r;
  8036e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ec:	e9 1a 01 00 00       	jmpq   80380b <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8036f1:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8036f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f7:	01 c2                	add    %eax,%edx
  8036f9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036fc:	89 d6                	mov    %edx,%esi
  8036fe:	89 c7                	mov    %eax,%edi
  803700:	48 b8 c2 24 80 00 00 	movabs $0x8024c2,%rax
  803707:	00 00 00 
  80370a:	ff d0                	callq  *%rax
  80370c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80370f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803713:	79 08                	jns    80371d <map_segment+0xfc>
				return r;
  803715:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803718:	e9 ee 00 00 00       	jmpq   80380b <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80371d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803727:	48 98                	cltq   
  803729:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80372d:	48 29 c2             	sub    %rax,%rdx
  803730:	48 89 d0             	mov    %rdx,%rax
  803733:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803737:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80373a:	48 63 d0             	movslq %eax,%rdx
  80373d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803741:	48 39 c2             	cmp    %rax,%rdx
  803744:	48 0f 47 d0          	cmova  %rax,%rdx
  803748:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80374b:	be 00 00 40 00       	mov    $0x400000,%esi
  803750:	89 c7                	mov    %eax,%edi
  803752:	48 b8 78 23 80 00 00 	movabs $0x802378,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803761:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803765:	79 08                	jns    80376f <map_segment+0x14e>
				return r;
  803767:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80376a:	e9 9c 00 00 00       	jmpq   80380b <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80376f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803772:	48 63 d0             	movslq %eax,%rdx
  803775:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803779:	48 01 d0             	add    %rdx,%rax
  80377c:	48 89 c2             	mov    %rax,%rdx
  80377f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803782:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803786:	48 89 d1             	mov    %rdx,%rcx
  803789:	89 c2                	mov    %eax,%edx
  80378b:	be 00 00 40 00       	mov    $0x400000,%esi
  803790:	bf 00 00 00 00       	mov    $0x0,%edi
  803795:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037a4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037a8:	79 30                	jns    8037da <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8037aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037ad:	89 c1                	mov    %eax,%ecx
  8037af:	48 ba 53 53 80 00 00 	movabs $0x805353,%rdx
  8037b6:	00 00 00 
  8037b9:	be 29 01 00 00       	mov    $0x129,%esi
  8037be:	48 bf d8 52 80 00 00 	movabs $0x8052d8,%rdi
  8037c5:	00 00 00 
  8037c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cd:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  8037d4:	00 00 00 
  8037d7:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8037da:	be 00 00 40 00       	mov    $0x400000,%esi
  8037df:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e4:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8037f0:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8037f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037fa:	48 98                	cltq   
  8037fc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803800:	0f 82 78 fe ff ff    	jb     80367e <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80380b:	c9                   	leaveq 
  80380c:	c3                   	retq   

000000000080380d <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80380d:	55                   	push   %rbp
  80380e:	48 89 e5             	mov    %rsp,%rbp
  803811:	48 83 ec 30          	sub    $0x30,%rsp
  803815:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803818:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80381f:	00 
  803820:	e9 eb 00 00 00       	jmpq   803910 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803829:	48 c1 f8 12          	sar    $0x12,%rax
  80382d:	48 89 c2             	mov    %rax,%rdx
  803830:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803837:	01 00 00 
  80383a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80383e:	83 e0 01             	and    $0x1,%eax
  803841:	48 85 c0             	test   %rax,%rax
  803844:	74 21                	je     803867 <copy_shared_pages+0x5a>
  803846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384a:	48 c1 f8 09          	sar    $0x9,%rax
  80384e:	48 89 c2             	mov    %rax,%rdx
  803851:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803858:	01 00 00 
  80385b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80385f:	83 e0 01             	and    $0x1,%eax
  803862:	48 85 c0             	test   %rax,%rax
  803865:	75 0d                	jne    803874 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  803867:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  80386e:	00 
  80386f:	e9 9c 00 00 00       	jmpq   803910 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  803874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803878:	48 05 00 02 00 00    	add    $0x200,%rax
  80387e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  803882:	eb 7e                	jmp    803902 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  803884:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80388b:	01 00 00 
  80388e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803892:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803896:	25 01 04 00 00       	and    $0x401,%eax
  80389b:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  8038a1:	75 5a                	jne    8038fd <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  8038a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a7:	48 c1 e0 0c          	shl    $0xc,%rax
  8038ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  8038af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038b6:	01 00 00 
  8038b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038c1:	25 07 0e 00 00       	and    $0xe07,%eax
  8038c6:	89 c6                	mov    %eax,%esi
  8038c8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8038cc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8038cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d3:	41 89 f0             	mov    %esi,%r8d
  8038d6:	48 89 c6             	mov    %rax,%rsi
  8038d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038de:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8038e5:	00 00 00 
  8038e8:	ff d0                	callq  *%rax
  8038ea:	48 98                	cltq   
  8038ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8038f0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038f5:	79 06                	jns    8038fd <copy_shared_pages+0xf0>
						return r;
  8038f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038fb:	eb 28                	jmp    803925 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  8038fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803902:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803906:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80390a:	0f 8c 74 ff ff ff    	jl     803884 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803910:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803914:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  80391a:	0f 86 05 ff ff ff    	jbe    803825 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803920:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803925:	c9                   	leaveq 
  803926:	c3                   	retq   

0000000000803927 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803927:	55                   	push   %rbp
  803928:	48 89 e5             	mov    %rsp,%rbp
  80392b:	48 83 ec 20          	sub    $0x20,%rsp
  80392f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803932:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803939:	48 89 d6             	mov    %rdx,%rsi
  80393c:	89 c7                	mov    %eax,%edi
  80393e:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  803945:	00 00 00 
  803948:	ff d0                	callq  *%rax
  80394a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80394d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803951:	79 05                	jns    803958 <fd2sockid+0x31>
		return r;
  803953:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803956:	eb 24                	jmp    80397c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	8b 10                	mov    (%rax),%edx
  80395e:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803965:	00 00 00 
  803968:	8b 00                	mov    (%rax),%eax
  80396a:	39 c2                	cmp    %eax,%edx
  80396c:	74 07                	je     803975 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80396e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803973:	eb 07                	jmp    80397c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803979:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80397c:	c9                   	leaveq 
  80397d:	c3                   	retq   

000000000080397e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80397e:	55                   	push   %rbp
  80397f:	48 89 e5             	mov    %rsp,%rbp
  803982:	48 83 ec 20          	sub    $0x20,%rsp
  803986:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803989:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80398d:	48 89 c7             	mov    %rax,%rdi
  803990:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  803997:	00 00 00 
  80399a:	ff d0                	callq  *%rax
  80399c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a3:	78 26                	js     8039cb <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8039a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8039ae:	48 89 c6             	mov    %rax,%rsi
  8039b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b6:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c9:	79 16                	jns    8039e1 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8039cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ce:	89 c7                	mov    %eax,%edi
  8039d0:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  8039d7:	00 00 00 
  8039da:	ff d0                	callq  *%rax
		return r;
  8039dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039df:	eb 3a                	jmp    803a1b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8039e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e5:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8039ec:	00 00 00 
  8039ef:	8b 12                	mov    (%rdx),%edx
  8039f1:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8039f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8039fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a02:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a05:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803a08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0c:	48 89 c7             	mov    %rax,%rdi
  803a0f:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  803a16:	00 00 00 
  803a19:	ff d0                	callq  *%rax
}
  803a1b:	c9                   	leaveq 
  803a1c:	c3                   	retq   

0000000000803a1d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a1d:	55                   	push   %rbp
  803a1e:	48 89 e5             	mov    %rsp,%rbp
  803a21:	48 83 ec 30          	sub    $0x30,%rsp
  803a25:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a30:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a33:	89 c7                	mov    %eax,%edi
  803a35:	48 b8 27 39 80 00 00 	movabs $0x803927,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
  803a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a48:	79 05                	jns    803a4f <accept+0x32>
		return r;
  803a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4d:	eb 3b                	jmp    803a8a <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803a4f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a53:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5a:	48 89 ce             	mov    %rcx,%rsi
  803a5d:	89 c7                	mov    %eax,%edi
  803a5f:	48 b8 6a 3d 80 00 00 	movabs $0x803d6a,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
  803a6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a72:	79 05                	jns    803a79 <accept+0x5c>
		return r;
  803a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a77:	eb 11                	jmp    803a8a <accept+0x6d>
	return alloc_sockfd(r);
  803a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7c:	89 c7                	mov    %eax,%edi
  803a7e:	48 b8 7e 39 80 00 00 	movabs $0x80397e,%rax
  803a85:	00 00 00 
  803a88:	ff d0                	callq  *%rax
}
  803a8a:	c9                   	leaveq 
  803a8b:	c3                   	retq   

0000000000803a8c <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a8c:	55                   	push   %rbp
  803a8d:	48 89 e5             	mov    %rsp,%rbp
  803a90:	48 83 ec 20          	sub    $0x20,%rsp
  803a94:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a9b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aa1:	89 c7                	mov    %eax,%edi
  803aa3:	48 b8 27 39 80 00 00 	movabs $0x803927,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
  803aaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab6:	79 05                	jns    803abd <bind+0x31>
		return r;
  803ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abb:	eb 1b                	jmp    803ad8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803abd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ac0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac7:	48 89 ce             	mov    %rcx,%rsi
  803aca:	89 c7                	mov    %eax,%edi
  803acc:	48 b8 e9 3d 80 00 00 	movabs $0x803de9,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
}
  803ad8:	c9                   	leaveq 
  803ad9:	c3                   	retq   

0000000000803ada <shutdown>:

int
shutdown(int s, int how)
{
  803ada:	55                   	push   %rbp
  803adb:	48 89 e5             	mov    %rsp,%rbp
  803ade:	48 83 ec 20          	sub    $0x20,%rsp
  803ae2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ae5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ae8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aeb:	89 c7                	mov    %eax,%edi
  803aed:	48 b8 27 39 80 00 00 	movabs $0x803927,%rax
  803af4:	00 00 00 
  803af7:	ff d0                	callq  *%rax
  803af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b00:	79 05                	jns    803b07 <shutdown+0x2d>
		return r;
  803b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b05:	eb 16                	jmp    803b1d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803b07:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0d:	89 d6                	mov    %edx,%esi
  803b0f:	89 c7                	mov    %eax,%edi
  803b11:	48 b8 4d 3e 80 00 00 	movabs $0x803e4d,%rax
  803b18:	00 00 00 
  803b1b:	ff d0                	callq  *%rax
}
  803b1d:	c9                   	leaveq 
  803b1e:	c3                   	retq   

0000000000803b1f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803b1f:	55                   	push   %rbp
  803b20:	48 89 e5             	mov    %rsp,%rbp
  803b23:	48 83 ec 10          	sub    $0x10,%rsp
  803b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2f:	48 89 c7             	mov    %rax,%rdi
  803b32:	48 b8 69 4b 80 00 00 	movabs $0x804b69,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	83 f8 01             	cmp    $0x1,%eax
  803b41:	75 17                	jne    803b5a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803b43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b47:	8b 40 0c             	mov    0xc(%rax),%eax
  803b4a:	89 c7                	mov    %eax,%edi
  803b4c:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  803b53:	00 00 00 
  803b56:	ff d0                	callq  *%rax
  803b58:	eb 05                	jmp    803b5f <devsock_close+0x40>
	else
		return 0;
  803b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b5f:	c9                   	leaveq 
  803b60:	c3                   	retq   

0000000000803b61 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b61:	55                   	push   %rbp
  803b62:	48 89 e5             	mov    %rsp,%rbp
  803b65:	48 83 ec 20          	sub    $0x20,%rsp
  803b69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b70:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b76:	89 c7                	mov    %eax,%edi
  803b78:	48 b8 27 39 80 00 00 	movabs $0x803927,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	callq  *%rax
  803b84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8b:	79 05                	jns    803b92 <connect+0x31>
		return r;
  803b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b90:	eb 1b                	jmp    803bad <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803b92:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b95:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9c:	48 89 ce             	mov    %rcx,%rsi
  803b9f:	89 c7                	mov    %eax,%edi
  803ba1:	48 b8 ba 3e 80 00 00 	movabs $0x803eba,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
}
  803bad:	c9                   	leaveq 
  803bae:	c3                   	retq   

0000000000803baf <listen>:

int
listen(int s, int backlog)
{
  803baf:	55                   	push   %rbp
  803bb0:	48 89 e5             	mov    %rsp,%rbp
  803bb3:	48 83 ec 20          	sub    $0x20,%rsp
  803bb7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bba:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc0:	89 c7                	mov    %eax,%edi
  803bc2:	48 b8 27 39 80 00 00 	movabs $0x803927,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
  803bce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd5:	79 05                	jns    803bdc <listen+0x2d>
		return r;
  803bd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bda:	eb 16                	jmp    803bf2 <listen+0x43>
	return nsipc_listen(r, backlog);
  803bdc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be2:	89 d6                	mov    %edx,%esi
  803be4:	89 c7                	mov    %eax,%edi
  803be6:	48 b8 1e 3f 80 00 00 	movabs $0x803f1e,%rax
  803bed:	00 00 00 
  803bf0:	ff d0                	callq  *%rax
}
  803bf2:	c9                   	leaveq 
  803bf3:	c3                   	retq   

0000000000803bf4 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803bf4:	55                   	push   %rbp
  803bf5:	48 89 e5             	mov    %rsp,%rbp
  803bf8:	48 83 ec 20          	sub    $0x20,%rsp
  803bfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c0c:	89 c2                	mov    %eax,%edx
  803c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c12:	8b 40 0c             	mov    0xc(%rax),%eax
  803c15:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c19:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c1e:	89 c7                	mov    %eax,%edi
  803c20:	48 b8 5e 3f 80 00 00 	movabs $0x803f5e,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
}
  803c2c:	c9                   	leaveq 
  803c2d:	c3                   	retq   

0000000000803c2e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c2e:	55                   	push   %rbp
  803c2f:	48 89 e5             	mov    %rsp,%rbp
  803c32:	48 83 ec 20          	sub    $0x20,%rsp
  803c36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c46:	89 c2                	mov    %eax,%edx
  803c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c4c:	8b 40 0c             	mov    0xc(%rax),%eax
  803c4f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c53:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c58:	89 c7                	mov    %eax,%edi
  803c5a:	48 b8 2a 40 80 00 00 	movabs $0x80402a,%rax
  803c61:	00 00 00 
  803c64:	ff d0                	callq  *%rax
}
  803c66:	c9                   	leaveq 
  803c67:	c3                   	retq   

0000000000803c68 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c68:	55                   	push   %rbp
  803c69:	48 89 e5             	mov    %rsp,%rbp
  803c6c:	48 83 ec 10          	sub    $0x10,%rsp
  803c70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803c78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7c:	48 be 75 53 80 00 00 	movabs $0x805375,%rsi
  803c83:	00 00 00 
  803c86:	48 89 c7             	mov    %rax,%rdi
  803c89:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
	return 0;
  803c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c9a:	c9                   	leaveq 
  803c9b:	c3                   	retq   

0000000000803c9c <socket>:

int
socket(int domain, int type, int protocol)
{
  803c9c:	55                   	push   %rbp
  803c9d:	48 89 e5             	mov    %rsp,%rbp
  803ca0:	48 83 ec 20          	sub    $0x20,%rsp
  803ca4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ca7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803caa:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803cad:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803cb0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803cb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb6:	89 ce                	mov    %ecx,%esi
  803cb8:	89 c7                	mov    %eax,%edi
  803cba:	48 b8 e2 40 80 00 00 	movabs $0x8040e2,%rax
  803cc1:	00 00 00 
  803cc4:	ff d0                	callq  *%rax
  803cc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ccd:	79 05                	jns    803cd4 <socket+0x38>
		return r;
  803ccf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd2:	eb 11                	jmp    803ce5 <socket+0x49>
	return alloc_sockfd(r);
  803cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd7:	89 c7                	mov    %eax,%edi
  803cd9:	48 b8 7e 39 80 00 00 	movabs $0x80397e,%rax
  803ce0:	00 00 00 
  803ce3:	ff d0                	callq  *%rax
}
  803ce5:	c9                   	leaveq 
  803ce6:	c3                   	retq   

0000000000803ce7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ce7:	55                   	push   %rbp
  803ce8:	48 89 e5             	mov    %rsp,%rbp
  803ceb:	48 83 ec 10          	sub    $0x10,%rsp
  803cef:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803cf2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803cf9:	00 00 00 
  803cfc:	8b 00                	mov    (%rax),%eax
  803cfe:	85 c0                	test   %eax,%eax
  803d00:	75 1f                	jne    803d21 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803d02:	bf 02 00 00 00       	mov    $0x2,%edi
  803d07:	48 b8 f8 4a 80 00 00 	movabs $0x804af8,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
  803d13:	89 c2                	mov    %eax,%edx
  803d15:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d1c:	00 00 00 
  803d1f:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803d21:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803d28:	00 00 00 
  803d2b:	8b 00                	mov    (%rax),%eax
  803d2d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803d30:	b9 07 00 00 00       	mov    $0x7,%ecx
  803d35:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803d3c:	00 00 00 
  803d3f:	89 c7                	mov    %eax,%edi
  803d41:	48 b8 63 4a 80 00 00 	movabs $0x804a63,%rax
  803d48:	00 00 00 
  803d4b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803d52:	be 00 00 00 00       	mov    $0x0,%esi
  803d57:	bf 00 00 00 00       	mov    $0x0,%edi
  803d5c:	48 b8 a2 49 80 00 00 	movabs $0x8049a2,%rax
  803d63:	00 00 00 
  803d66:	ff d0                	callq  *%rax
}
  803d68:	c9                   	leaveq 
  803d69:	c3                   	retq   

0000000000803d6a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d6a:	55                   	push   %rbp
  803d6b:	48 89 e5             	mov    %rsp,%rbp
  803d6e:	48 83 ec 30          	sub    $0x30,%rsp
  803d72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d79:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803d7d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d84:	00 00 00 
  803d87:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d8a:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803d8c:	bf 01 00 00 00       	mov    $0x1,%edi
  803d91:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803d98:	00 00 00 
  803d9b:	ff d0                	callq  *%rax
  803d9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da4:	78 3e                	js     803de4 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803da6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dad:	00 00 00 
  803db0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db8:	8b 40 10             	mov    0x10(%rax),%eax
  803dbb:	89 c2                	mov    %eax,%edx
  803dbd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803dc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc5:	48 89 ce             	mov    %rcx,%rsi
  803dc8:	48 89 c7             	mov    %rax,%rdi
  803dcb:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803dd2:	00 00 00 
  803dd5:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddb:	8b 50 10             	mov    0x10(%rax),%edx
  803dde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de2:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803de7:	c9                   	leaveq 
  803de8:	c3                   	retq   

0000000000803de9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803de9:	55                   	push   %rbp
  803dea:	48 89 e5             	mov    %rsp,%rbp
  803ded:	48 83 ec 10          	sub    $0x10,%rsp
  803df1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803df4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803df8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803dfb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e02:	00 00 00 
  803e05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e08:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e0a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e11:	48 89 c6             	mov    %rax,%rsi
  803e14:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e1b:	00 00 00 
  803e1e:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803e2a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e31:	00 00 00 
  803e34:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e37:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803e3a:	bf 02 00 00 00       	mov    $0x2,%edi
  803e3f:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803e46:	00 00 00 
  803e49:	ff d0                	callq  *%rax
}
  803e4b:	c9                   	leaveq 
  803e4c:	c3                   	retq   

0000000000803e4d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803e4d:	55                   	push   %rbp
  803e4e:	48 89 e5             	mov    %rsp,%rbp
  803e51:	48 83 ec 10          	sub    $0x10,%rsp
  803e55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803e5b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e62:	00 00 00 
  803e65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e68:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803e6a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e71:	00 00 00 
  803e74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e77:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803e7a:	bf 03 00 00 00       	mov    $0x3,%edi
  803e7f:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
}
  803e8b:	c9                   	leaveq 
  803e8c:	c3                   	retq   

0000000000803e8d <nsipc_close>:

int
nsipc_close(int s)
{
  803e8d:	55                   	push   %rbp
  803e8e:	48 89 e5             	mov    %rsp,%rbp
  803e91:	48 83 ec 10          	sub    $0x10,%rsp
  803e95:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803e98:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e9f:	00 00 00 
  803ea2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ea5:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803ea7:	bf 04 00 00 00       	mov    $0x4,%edi
  803eac:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803eb3:	00 00 00 
  803eb6:	ff d0                	callq  *%rax
}
  803eb8:	c9                   	leaveq 
  803eb9:	c3                   	retq   

0000000000803eba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803eba:	55                   	push   %rbp
  803ebb:	48 89 e5             	mov    %rsp,%rbp
  803ebe:	48 83 ec 10          	sub    $0x10,%rsp
  803ec2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ec5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ec9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ecc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed3:	00 00 00 
  803ed6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ed9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803edb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee2:	48 89 c6             	mov    %rax,%rsi
  803ee5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803eec:	00 00 00 
  803eef:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803ef6:	00 00 00 
  803ef9:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803efb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f02:	00 00 00 
  803f05:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f08:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803f0b:	bf 05 00 00 00       	mov    $0x5,%edi
  803f10:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
}
  803f1c:	c9                   	leaveq 
  803f1d:	c3                   	retq   

0000000000803f1e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803f1e:	55                   	push   %rbp
  803f1f:	48 89 e5             	mov    %rsp,%rbp
  803f22:	48 83 ec 10          	sub    $0x10,%rsp
  803f26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f29:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803f2c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f33:	00 00 00 
  803f36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f39:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803f3b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f42:	00 00 00 
  803f45:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f48:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803f4b:	bf 06 00 00 00       	mov    $0x6,%edi
  803f50:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803f57:	00 00 00 
  803f5a:	ff d0                	callq  *%rax
}
  803f5c:	c9                   	leaveq 
  803f5d:	c3                   	retq   

0000000000803f5e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803f5e:	55                   	push   %rbp
  803f5f:	48 89 e5             	mov    %rsp,%rbp
  803f62:	48 83 ec 30          	sub    $0x30,%rsp
  803f66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f6d:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803f70:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803f73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f7a:	00 00 00 
  803f7d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f80:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803f82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f89:	00 00 00 
  803f8c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f8f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803f92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f99:	00 00 00 
  803f9c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f9f:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803fa2:	bf 07 00 00 00       	mov    $0x7,%edi
  803fa7:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  803fae:	00 00 00 
  803fb1:	ff d0                	callq  *%rax
  803fb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fba:	78 69                	js     804025 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803fbc:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803fc3:	7f 08                	jg     803fcd <nsipc_recv+0x6f>
  803fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803fcb:	7e 35                	jle    804002 <nsipc_recv+0xa4>
  803fcd:	48 b9 7c 53 80 00 00 	movabs $0x80537c,%rcx
  803fd4:	00 00 00 
  803fd7:	48 ba 91 53 80 00 00 	movabs $0x805391,%rdx
  803fde:	00 00 00 
  803fe1:	be 62 00 00 00       	mov    $0x62,%esi
  803fe6:	48 bf a6 53 80 00 00 	movabs $0x8053a6,%rdi
  803fed:	00 00 00 
  803ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff5:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  803ffc:	00 00 00 
  803fff:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804005:	48 63 d0             	movslq %eax,%rdx
  804008:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400c:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804013:	00 00 00 
  804016:	48 89 c7             	mov    %rax,%rdi
  804019:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
	}

	return r;
  804025:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804028:	c9                   	leaveq 
  804029:	c3                   	retq   

000000000080402a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80402a:	55                   	push   %rbp
  80402b:	48 89 e5             	mov    %rsp,%rbp
  80402e:	48 83 ec 20          	sub    $0x20,%rsp
  804032:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804035:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804039:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80403c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80403f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804046:	00 00 00 
  804049:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80404c:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80404e:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804055:	7e 35                	jle    80408c <nsipc_send+0x62>
  804057:	48 b9 b2 53 80 00 00 	movabs $0x8053b2,%rcx
  80405e:	00 00 00 
  804061:	48 ba 91 53 80 00 00 	movabs $0x805391,%rdx
  804068:	00 00 00 
  80406b:	be 6d 00 00 00       	mov    $0x6d,%esi
  804070:	48 bf a6 53 80 00 00 	movabs $0x8053a6,%rdi
  804077:	00 00 00 
  80407a:	b8 00 00 00 00       	mov    $0x0,%eax
  80407f:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  804086:	00 00 00 
  804089:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80408c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80408f:	48 63 d0             	movslq %eax,%rdx
  804092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804096:	48 89 c6             	mov    %rax,%rsi
  804099:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8040a0:	00 00 00 
  8040a3:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8040af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040b6:	00 00 00 
  8040b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040bc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8040bf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040c6:	00 00 00 
  8040c9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040cc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8040cf:	bf 08 00 00 00       	mov    $0x8,%edi
  8040d4:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  8040db:	00 00 00 
  8040de:	ff d0                	callq  *%rax
}
  8040e0:	c9                   	leaveq 
  8040e1:	c3                   	retq   

00000000008040e2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8040e2:	55                   	push   %rbp
  8040e3:	48 89 e5             	mov    %rsp,%rbp
  8040e6:	48 83 ec 10          	sub    $0x10,%rsp
  8040ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040ed:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8040f0:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8040f3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040fa:	00 00 00 
  8040fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804100:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804102:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804109:	00 00 00 
  80410c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80410f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804112:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804119:	00 00 00 
  80411c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80411f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804122:	bf 09 00 00 00       	mov    $0x9,%edi
  804127:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  80412e:	00 00 00 
  804131:	ff d0                	callq  *%rax
}
  804133:	c9                   	leaveq 
  804134:	c3                   	retq   

0000000000804135 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804135:	55                   	push   %rbp
  804136:	48 89 e5             	mov    %rsp,%rbp
  804139:	53                   	push   %rbx
  80413a:	48 83 ec 38          	sub    $0x38,%rsp
  80413e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804142:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804146:	48 89 c7             	mov    %rax,%rdi
  804149:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  804150:	00 00 00 
  804153:	ff d0                	callq  *%rax
  804155:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804158:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80415c:	0f 88 bf 01 00 00    	js     804321 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804162:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804166:	ba 07 04 00 00       	mov    $0x407,%edx
  80416b:	48 89 c6             	mov    %rax,%rsi
  80416e:	bf 00 00 00 00       	mov    $0x0,%edi
  804173:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  80417a:	00 00 00 
  80417d:	ff d0                	callq  *%rax
  80417f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804182:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804186:	0f 88 95 01 00 00    	js     804321 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80418c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804190:	48 89 c7             	mov    %rax,%rdi
  804193:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  80419a:	00 00 00 
  80419d:	ff d0                	callq  *%rax
  80419f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041a6:	0f 88 5d 01 00 00    	js     804309 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b0:	ba 07 04 00 00       	mov    $0x407,%edx
  8041b5:	48 89 c6             	mov    %rax,%rsi
  8041b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8041bd:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8041c4:	00 00 00 
  8041c7:	ff d0                	callq  *%rax
  8041c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041d0:	0f 88 33 01 00 00    	js     804309 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8041d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041da:	48 89 c7             	mov    %rax,%rdi
  8041dd:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8041e4:	00 00 00 
  8041e7:	ff d0                	callq  *%rax
  8041e9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f1:	ba 07 04 00 00       	mov    $0x407,%edx
  8041f6:	48 89 c6             	mov    %rax,%rsi
  8041f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8041fe:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  804205:	00 00 00 
  804208:	ff d0                	callq  *%rax
  80420a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80420d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804211:	0f 88 d9 00 00 00    	js     8042f0 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804217:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80421b:	48 89 c7             	mov    %rax,%rdi
  80421e:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  804225:	00 00 00 
  804228:	ff d0                	callq  *%rax
  80422a:	48 89 c2             	mov    %rax,%rdx
  80422d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804231:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804237:	48 89 d1             	mov    %rdx,%rcx
  80423a:	ba 00 00 00 00       	mov    $0x0,%edx
  80423f:	48 89 c6             	mov    %rax,%rsi
  804242:	bf 00 00 00 00       	mov    $0x0,%edi
  804247:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  80424e:	00 00 00 
  804251:	ff d0                	callq  *%rax
  804253:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804256:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80425a:	78 79                	js     8042d5 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80425c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804260:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804267:	00 00 00 
  80426a:	8b 12                	mov    (%rdx),%edx
  80426c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80426e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804272:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804279:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80427d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804284:	00 00 00 
  804287:	8b 12                	mov    (%rdx),%edx
  804289:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80428b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80428f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804296:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80429a:	48 89 c7             	mov    %rax,%rdi
  80429d:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8042a4:	00 00 00 
  8042a7:	ff d0                	callq  *%rax
  8042a9:	89 c2                	mov    %eax,%edx
  8042ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042af:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8042b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042b5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8042b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042bd:	48 89 c7             	mov    %rax,%rdi
  8042c0:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8042c7:	00 00 00 
  8042ca:	ff d0                	callq  *%rax
  8042cc:	89 03                	mov    %eax,(%rbx)
	return 0;
  8042ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8042d3:	eb 4f                	jmp    804324 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8042d5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8042d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042da:	48 89 c6             	mov    %rax,%rsi
  8042dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e2:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8042e9:	00 00 00 
  8042ec:	ff d0                	callq  *%rax
  8042ee:	eb 01                	jmp    8042f1 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8042f0:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8042f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042f5:	48 89 c6             	mov    %rax,%rsi
  8042f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8042fd:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  804304:	00 00 00 
  804307:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804309:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80430d:	48 89 c6             	mov    %rax,%rsi
  804310:	bf 00 00 00 00       	mov    $0x0,%edi
  804315:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80431c:	00 00 00 
  80431f:	ff d0                	callq  *%rax
err:
	return r;
  804321:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804324:	48 83 c4 38          	add    $0x38,%rsp
  804328:	5b                   	pop    %rbx
  804329:	5d                   	pop    %rbp
  80432a:	c3                   	retq   

000000000080432b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80432b:	55                   	push   %rbp
  80432c:	48 89 e5             	mov    %rsp,%rbp
  80432f:	53                   	push   %rbx
  804330:	48 83 ec 28          	sub    $0x28,%rsp
  804334:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804338:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80433c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804343:	00 00 00 
  804346:	48 8b 00             	mov    (%rax),%rax
  804349:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80434f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804352:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804356:	48 89 c7             	mov    %rax,%rdi
  804359:	48 b8 69 4b 80 00 00 	movabs $0x804b69,%rax
  804360:	00 00 00 
  804363:	ff d0                	callq  *%rax
  804365:	89 c3                	mov    %eax,%ebx
  804367:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80436b:	48 89 c7             	mov    %rax,%rdi
  80436e:	48 b8 69 4b 80 00 00 	movabs $0x804b69,%rax
  804375:	00 00 00 
  804378:	ff d0                	callq  *%rax
  80437a:	39 c3                	cmp    %eax,%ebx
  80437c:	0f 94 c0             	sete   %al
  80437f:	0f b6 c0             	movzbl %al,%eax
  804382:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804385:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80438c:	00 00 00 
  80438f:	48 8b 00             	mov    (%rax),%rax
  804392:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804398:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80439b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80439e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8043a1:	75 05                	jne    8043a8 <_pipeisclosed+0x7d>
			return ret;
  8043a3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8043a6:	eb 4a                	jmp    8043f2 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8043a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ab:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8043ae:	74 8c                	je     80433c <_pipeisclosed+0x11>
  8043b0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8043b4:	75 86                	jne    80433c <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8043b6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8043bd:	00 00 00 
  8043c0:	48 8b 00             	mov    (%rax),%rax
  8043c3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8043c9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8043cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043cf:	89 c6                	mov    %eax,%esi
  8043d1:	48 bf c3 53 80 00 00 	movabs $0x8053c3,%rdi
  8043d8:	00 00 00 
  8043db:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e0:	49 b8 ca 03 80 00 00 	movabs $0x8003ca,%r8
  8043e7:	00 00 00 
  8043ea:	41 ff d0             	callq  *%r8
	}
  8043ed:	e9 4a ff ff ff       	jmpq   80433c <_pipeisclosed+0x11>

}
  8043f2:	48 83 c4 28          	add    $0x28,%rsp
  8043f6:	5b                   	pop    %rbx
  8043f7:	5d                   	pop    %rbp
  8043f8:	c3                   	retq   

00000000008043f9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8043f9:	55                   	push   %rbp
  8043fa:	48 89 e5             	mov    %rsp,%rbp
  8043fd:	48 83 ec 30          	sub    $0x30,%rsp
  804401:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804404:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804408:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80440b:	48 89 d6             	mov    %rdx,%rsi
  80440e:	89 c7                	mov    %eax,%edi
  804410:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  804417:	00 00 00 
  80441a:	ff d0                	callq  *%rax
  80441c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80441f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804423:	79 05                	jns    80442a <pipeisclosed+0x31>
		return r;
  804425:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804428:	eb 31                	jmp    80445b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80442a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80442e:	48 89 c7             	mov    %rax,%rdi
  804431:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  804438:	00 00 00 
  80443b:	ff d0                	callq  *%rax
  80443d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804445:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804449:	48 89 d6             	mov    %rdx,%rsi
  80444c:	48 89 c7             	mov    %rax,%rdi
  80444f:	48 b8 2b 43 80 00 00 	movabs $0x80432b,%rax
  804456:	00 00 00 
  804459:	ff d0                	callq  *%rax
}
  80445b:	c9                   	leaveq 
  80445c:	c3                   	retq   

000000000080445d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80445d:	55                   	push   %rbp
  80445e:	48 89 e5             	mov    %rsp,%rbp
  804461:	48 83 ec 40          	sub    $0x40,%rsp
  804465:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804469:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80446d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804475:	48 89 c7             	mov    %rax,%rdi
  804478:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  80447f:	00 00 00 
  804482:	ff d0                	callq  *%rax
  804484:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804488:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80448c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804490:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804497:	00 
  804498:	e9 90 00 00 00       	jmpq   80452d <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80449d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8044a2:	74 09                	je     8044ad <devpipe_read+0x50>
				return i;
  8044a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a8:	e9 8e 00 00 00       	jmpq   80453b <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8044ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b5:	48 89 d6             	mov    %rdx,%rsi
  8044b8:	48 89 c7             	mov    %rax,%rdi
  8044bb:	48 b8 2b 43 80 00 00 	movabs $0x80432b,%rax
  8044c2:	00 00 00 
  8044c5:	ff d0                	callq  *%rax
  8044c7:	85 c0                	test   %eax,%eax
  8044c9:	74 07                	je     8044d2 <devpipe_read+0x75>
				return 0;
  8044cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8044d0:	eb 69                	jmp    80453b <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8044d2:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  8044d9:	00 00 00 
  8044dc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8044de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044e2:	8b 10                	mov    (%rax),%edx
  8044e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044e8:	8b 40 04             	mov    0x4(%rax),%eax
  8044eb:	39 c2                	cmp    %eax,%edx
  8044ed:	74 ae                	je     80449d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8044ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8044fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ff:	8b 00                	mov    (%rax),%eax
  804501:	99                   	cltd   
  804502:	c1 ea 1b             	shr    $0x1b,%edx
  804505:	01 d0                	add    %edx,%eax
  804507:	83 e0 1f             	and    $0x1f,%eax
  80450a:	29 d0                	sub    %edx,%eax
  80450c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804510:	48 98                	cltq   
  804512:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804517:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80451d:	8b 00                	mov    (%rax),%eax
  80451f:	8d 50 01             	lea    0x1(%rax),%edx
  804522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804526:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804528:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80452d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804531:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804535:	72 a7                	jb     8044de <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80453b:	c9                   	leaveq 
  80453c:	c3                   	retq   

000000000080453d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80453d:	55                   	push   %rbp
  80453e:	48 89 e5             	mov    %rsp,%rbp
  804541:	48 83 ec 40          	sub    $0x40,%rsp
  804545:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804549:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80454d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804555:	48 89 c7             	mov    %rax,%rdi
  804558:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  80455f:	00 00 00 
  804562:	ff d0                	callq  *%rax
  804564:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804568:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80456c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804570:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804577:	00 
  804578:	e9 8f 00 00 00       	jmpq   80460c <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80457d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804585:	48 89 d6             	mov    %rdx,%rsi
  804588:	48 89 c7             	mov    %rax,%rdi
  80458b:	48 b8 2b 43 80 00 00 	movabs $0x80432b,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
  804597:	85 c0                	test   %eax,%eax
  804599:	74 07                	je     8045a2 <devpipe_write+0x65>
				return 0;
  80459b:	b8 00 00 00 00       	mov    $0x0,%eax
  8045a0:	eb 78                	jmp    80461a <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8045a2:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  8045a9:	00 00 00 
  8045ac:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8045ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b2:	8b 40 04             	mov    0x4(%rax),%eax
  8045b5:	48 63 d0             	movslq %eax,%rdx
  8045b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045bc:	8b 00                	mov    (%rax),%eax
  8045be:	48 98                	cltq   
  8045c0:	48 83 c0 20          	add    $0x20,%rax
  8045c4:	48 39 c2             	cmp    %rax,%rdx
  8045c7:	73 b4                	jae    80457d <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8045c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045cd:	8b 40 04             	mov    0x4(%rax),%eax
  8045d0:	99                   	cltd   
  8045d1:	c1 ea 1b             	shr    $0x1b,%edx
  8045d4:	01 d0                	add    %edx,%eax
  8045d6:	83 e0 1f             	and    $0x1f,%eax
  8045d9:	29 d0                	sub    %edx,%eax
  8045db:	89 c6                	mov    %eax,%esi
  8045dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8045e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045e5:	48 01 d0             	add    %rdx,%rax
  8045e8:	0f b6 08             	movzbl (%rax),%ecx
  8045eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045ef:	48 63 c6             	movslq %esi,%rax
  8045f2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8045f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045fa:	8b 40 04             	mov    0x4(%rax),%eax
  8045fd:	8d 50 01             	lea    0x1(%rax),%edx
  804600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804604:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804607:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80460c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804610:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804614:	72 98                	jb     8045ae <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80461a:	c9                   	leaveq 
  80461b:	c3                   	retq   

000000000080461c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80461c:	55                   	push   %rbp
  80461d:	48 89 e5             	mov    %rsp,%rbp
  804620:	48 83 ec 20          	sub    $0x20,%rsp
  804624:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804628:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80462c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804630:	48 89 c7             	mov    %rax,%rdi
  804633:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  80463a:	00 00 00 
  80463d:	ff d0                	callq  *%rax
  80463f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804643:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804647:	48 be d6 53 80 00 00 	movabs $0x8053d6,%rsi
  80464e:	00 00 00 
  804651:	48 89 c7             	mov    %rax,%rdi
  804654:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  80465b:	00 00 00 
  80465e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804664:	8b 50 04             	mov    0x4(%rax),%edx
  804667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80466b:	8b 00                	mov    (%rax),%eax
  80466d:	29 c2                	sub    %eax,%edx
  80466f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804673:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804679:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80467d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804684:	00 00 00 
	stat->st_dev = &devpipe;
  804687:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80468b:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804692:	00 00 00 
  804695:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80469c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046a1:	c9                   	leaveq 
  8046a2:	c3                   	retq   

00000000008046a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8046a3:	55                   	push   %rbp
  8046a4:	48 89 e5             	mov    %rsp,%rbp
  8046a7:	48 83 ec 10          	sub    $0x10,%rsp
  8046ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8046af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046b3:	48 89 c6             	mov    %rax,%rsi
  8046b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8046bb:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8046c2:	00 00 00 
  8046c5:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8046c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046cb:	48 89 c7             	mov    %rax,%rdi
  8046ce:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8046d5:	00 00 00 
  8046d8:	ff d0                	callq  *%rax
  8046da:	48 89 c6             	mov    %rax,%rsi
  8046dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8046e2:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8046e9:	00 00 00 
  8046ec:	ff d0                	callq  *%rax
}
  8046ee:	c9                   	leaveq 
  8046ef:	c3                   	retq   

00000000008046f0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8046f0:	55                   	push   %rbp
  8046f1:	48 89 e5             	mov    %rsp,%rbp
  8046f4:	48 83 ec 20          	sub    $0x20,%rsp
  8046f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8046fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046fe:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804701:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804705:	be 01 00 00 00       	mov    $0x1,%esi
  80470a:	48 89 c7             	mov    %rax,%rdi
  80470d:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  804714:	00 00 00 
  804717:	ff d0                	callq  *%rax
}
  804719:	90                   	nop
  80471a:	c9                   	leaveq 
  80471b:	c3                   	retq   

000000000080471c <getchar>:

int
getchar(void)
{
  80471c:	55                   	push   %rbp
  80471d:	48 89 e5             	mov    %rsp,%rbp
  804720:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804724:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804728:	ba 01 00 00 00       	mov    $0x1,%edx
  80472d:	48 89 c6             	mov    %rax,%rsi
  804730:	bf 00 00 00 00       	mov    $0x0,%edi
  804735:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  80473c:	00 00 00 
  80473f:	ff d0                	callq  *%rax
  804741:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804744:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804748:	79 05                	jns    80474f <getchar+0x33>
		return r;
  80474a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80474d:	eb 14                	jmp    804763 <getchar+0x47>
	if (r < 1)
  80474f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804753:	7f 07                	jg     80475c <getchar+0x40>
		return -E_EOF;
  804755:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80475a:	eb 07                	jmp    804763 <getchar+0x47>
	return c;
  80475c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804760:	0f b6 c0             	movzbl %al,%eax

}
  804763:	c9                   	leaveq 
  804764:	c3                   	retq   

0000000000804765 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804765:	55                   	push   %rbp
  804766:	48 89 e5             	mov    %rsp,%rbp
  804769:	48 83 ec 20          	sub    $0x20,%rsp
  80476d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804770:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804774:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804777:	48 89 d6             	mov    %rdx,%rsi
  80477a:	89 c7                	mov    %eax,%edi
  80477c:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  804783:	00 00 00 
  804786:	ff d0                	callq  *%rax
  804788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80478b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80478f:	79 05                	jns    804796 <iscons+0x31>
		return r;
  804791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804794:	eb 1a                	jmp    8047b0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80479a:	8b 10                	mov    (%rax),%edx
  80479c:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8047a3:	00 00 00 
  8047a6:	8b 00                	mov    (%rax),%eax
  8047a8:	39 c2                	cmp    %eax,%edx
  8047aa:	0f 94 c0             	sete   %al
  8047ad:	0f b6 c0             	movzbl %al,%eax
}
  8047b0:	c9                   	leaveq 
  8047b1:	c3                   	retq   

00000000008047b2 <opencons>:

int
opencons(void)
{
  8047b2:	55                   	push   %rbp
  8047b3:	48 89 e5             	mov    %rsp,%rbp
  8047b6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8047ba:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8047be:	48 89 c7             	mov    %rax,%rdi
  8047c1:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  8047c8:	00 00 00 
  8047cb:	ff d0                	callq  *%rax
  8047cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d4:	79 05                	jns    8047db <opencons+0x29>
		return r;
  8047d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047d9:	eb 5b                	jmp    804836 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8047db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047df:	ba 07 04 00 00       	mov    $0x407,%edx
  8047e4:	48 89 c6             	mov    %rax,%rsi
  8047e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ec:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8047f3:	00 00 00 
  8047f6:	ff d0                	callq  *%rax
  8047f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ff:	79 05                	jns    804806 <opencons+0x54>
		return r;
  804801:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804804:	eb 30                	jmp    804836 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80480a:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804811:	00 00 00 
  804814:	8b 12                	mov    (%rdx),%edx
  804816:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80481c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804827:	48 89 c7             	mov    %rax,%rdi
  80482a:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  804831:	00 00 00 
  804834:	ff d0                	callq  *%rax
}
  804836:	c9                   	leaveq 
  804837:	c3                   	retq   

0000000000804838 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804838:	55                   	push   %rbp
  804839:	48 89 e5             	mov    %rsp,%rbp
  80483c:	48 83 ec 30          	sub    $0x30,%rsp
  804840:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804844:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804848:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80484c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804851:	75 13                	jne    804866 <devcons_read+0x2e>
		return 0;
  804853:	b8 00 00 00 00       	mov    $0x0,%eax
  804858:	eb 49                	jmp    8048a3 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80485a:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  804861:	00 00 00 
  804864:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804866:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  80486d:	00 00 00 
  804870:	ff d0                	callq  *%rax
  804872:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804879:	74 df                	je     80485a <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80487b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80487f:	79 05                	jns    804886 <devcons_read+0x4e>
		return c;
  804881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804884:	eb 1d                	jmp    8048a3 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804886:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80488a:	75 07                	jne    804893 <devcons_read+0x5b>
		return 0;
  80488c:	b8 00 00 00 00       	mov    $0x0,%eax
  804891:	eb 10                	jmp    8048a3 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804896:	89 c2                	mov    %eax,%edx
  804898:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80489c:	88 10                	mov    %dl,(%rax)
	return 1;
  80489e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8048a3:	c9                   	leaveq 
  8048a4:	c3                   	retq   

00000000008048a5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8048a5:	55                   	push   %rbp
  8048a6:	48 89 e5             	mov    %rsp,%rbp
  8048a9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8048b0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8048b7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8048be:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8048c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048cc:	eb 76                	jmp    804944 <devcons_write+0x9f>
		m = n - tot;
  8048ce:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8048d5:	89 c2                	mov    %eax,%edx
  8048d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048da:	29 c2                	sub    %eax,%edx
  8048dc:	89 d0                	mov    %edx,%eax
  8048de:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8048e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048e4:	83 f8 7f             	cmp    $0x7f,%eax
  8048e7:	76 07                	jbe    8048f0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8048e9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8048f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048f3:	48 63 d0             	movslq %eax,%rdx
  8048f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f9:	48 63 c8             	movslq %eax,%rcx
  8048fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804903:	48 01 c1             	add    %rax,%rcx
  804906:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80490d:	48 89 ce             	mov    %rcx,%rsi
  804910:	48 89 c7             	mov    %rax,%rdi
  804913:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  80491a:	00 00 00 
  80491d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80491f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804922:	48 63 d0             	movslq %eax,%rdx
  804925:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80492c:	48 89 d6             	mov    %rdx,%rsi
  80492f:	48 89 c7             	mov    %rax,%rdi
  804932:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  804939:	00 00 00 
  80493c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80493e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804941:	01 45 fc             	add    %eax,-0x4(%rbp)
  804944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804947:	48 98                	cltq   
  804949:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804950:	0f 82 78 ff ff ff    	jb     8048ce <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804956:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804959:	c9                   	leaveq 
  80495a:	c3                   	retq   

000000000080495b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80495b:	55                   	push   %rbp
  80495c:	48 89 e5             	mov    %rsp,%rbp
  80495f:	48 83 ec 08          	sub    $0x8,%rsp
  804963:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80496c:	c9                   	leaveq 
  80496d:	c3                   	retq   

000000000080496e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80496e:	55                   	push   %rbp
  80496f:	48 89 e5             	mov    %rsp,%rbp
  804972:	48 83 ec 10          	sub    $0x10,%rsp
  804976:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80497a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80497e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804982:	48 be e2 53 80 00 00 	movabs $0x8053e2,%rsi
  804989:	00 00 00 
  80498c:	48 89 c7             	mov    %rax,%rdi
  80498f:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  804996:	00 00 00 
  804999:	ff d0                	callq  *%rax
	return 0;
  80499b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049a0:	c9                   	leaveq 
  8049a1:	c3                   	retq   

00000000008049a2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8049a2:	55                   	push   %rbp
  8049a3:	48 89 e5             	mov    %rsp,%rbp
  8049a6:	48 83 ec 30          	sub    $0x30,%rsp
  8049aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8049b6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8049bb:	75 0e                	jne    8049cb <ipc_recv+0x29>
		pg = (void*) UTOP;
  8049bd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8049c4:	00 00 00 
  8049c7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8049cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049cf:	48 89 c7             	mov    %rax,%rdi
  8049d2:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  8049d9:	00 00 00 
  8049dc:	ff d0                	callq  *%rax
  8049de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049e5:	79 27                	jns    804a0e <ipc_recv+0x6c>
		if (from_env_store)
  8049e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8049ec:	74 0a                	je     8049f8 <ipc_recv+0x56>
			*from_env_store = 0;
  8049ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8049f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049fd:	74 0a                	je     804a09 <ipc_recv+0x67>
			*perm_store = 0;
  8049ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a03:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a0c:	eb 53                	jmp    804a61 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804a0e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a13:	74 19                	je     804a2e <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804a15:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a1c:	00 00 00 
  804a1f:	48 8b 00             	mov    (%rax),%rax
  804a22:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804a28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a2c:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804a2e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a33:	74 19                	je     804a4e <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804a35:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a3c:	00 00 00 
  804a3f:	48 8b 00             	mov    (%rax),%rax
  804a42:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a4c:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804a4e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a55:	00 00 00 
  804a58:	48 8b 00             	mov    (%rax),%rax
  804a5b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804a61:	c9                   	leaveq 
  804a62:	c3                   	retq   

0000000000804a63 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804a63:	55                   	push   %rbp
  804a64:	48 89 e5             	mov    %rsp,%rbp
  804a67:	48 83 ec 30          	sub    $0x30,%rsp
  804a6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804a6e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804a71:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804a75:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804a78:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a7d:	75 1c                	jne    804a9b <ipc_send+0x38>
		pg = (void*) UTOP;
  804a7f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a86:	00 00 00 
  804a89:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804a8d:	eb 0c                	jmp    804a9b <ipc_send+0x38>
		sys_yield();
  804a8f:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  804a96:	00 00 00 
  804a99:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804a9b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a9e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804aa1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804aa5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804aa8:	89 c7                	mov    %eax,%edi
  804aaa:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804ab1:	00 00 00 
  804ab4:	ff d0                	callq  *%rax
  804ab6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ab9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804abd:	74 d0                	je     804a8f <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ac3:	79 30                	jns    804af5 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ac8:	89 c1                	mov    %eax,%ecx
  804aca:	48 ba e9 53 80 00 00 	movabs $0x8053e9,%rdx
  804ad1:	00 00 00 
  804ad4:	be 47 00 00 00       	mov    $0x47,%esi
  804ad9:	48 bf ff 53 80 00 00 	movabs $0x8053ff,%rdi
  804ae0:	00 00 00 
  804ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  804ae8:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  804aef:	00 00 00 
  804af2:	41 ff d0             	callq  *%r8

}
  804af5:	90                   	nop
  804af6:	c9                   	leaveq 
  804af7:	c3                   	retq   

0000000000804af8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804af8:	55                   	push   %rbp
  804af9:	48 89 e5             	mov    %rsp,%rbp
  804afc:	48 83 ec 18          	sub    $0x18,%rsp
  804b00:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804b03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804b0a:	eb 4d                	jmp    804b59 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804b0c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804b13:	00 00 00 
  804b16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b19:	48 98                	cltq   
  804b1b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804b22:	48 01 d0             	add    %rdx,%rax
  804b25:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804b2b:	8b 00                	mov    (%rax),%eax
  804b2d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804b30:	75 23                	jne    804b55 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804b32:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804b39:	00 00 00 
  804b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b3f:	48 98                	cltq   
  804b41:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804b48:	48 01 d0             	add    %rdx,%rax
  804b4b:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804b51:	8b 00                	mov    (%rax),%eax
  804b53:	eb 12                	jmp    804b67 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804b55:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804b59:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804b60:	7e aa                	jle    804b0c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b67:	c9                   	leaveq 
  804b68:	c3                   	retq   

0000000000804b69 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804b69:	55                   	push   %rbp
  804b6a:	48 89 e5             	mov    %rsp,%rbp
  804b6d:	48 83 ec 18          	sub    $0x18,%rsp
  804b71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b79:	48 c1 e8 15          	shr    $0x15,%rax
  804b7d:	48 89 c2             	mov    %rax,%rdx
  804b80:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b87:	01 00 00 
  804b8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b8e:	83 e0 01             	and    $0x1,%eax
  804b91:	48 85 c0             	test   %rax,%rax
  804b94:	75 07                	jne    804b9d <pageref+0x34>
		return 0;
  804b96:	b8 00 00 00 00       	mov    $0x0,%eax
  804b9b:	eb 56                	jmp    804bf3 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ba1:	48 c1 e8 0c          	shr    $0xc,%rax
  804ba5:	48 89 c2             	mov    %rax,%rdx
  804ba8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804baf:	01 00 00 
  804bb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804bb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bbe:	83 e0 01             	and    $0x1,%eax
  804bc1:	48 85 c0             	test   %rax,%rax
  804bc4:	75 07                	jne    804bcd <pageref+0x64>
		return 0;
  804bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  804bcb:	eb 26                	jmp    804bf3 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bd1:	48 c1 e8 0c          	shr    $0xc,%rax
  804bd5:	48 89 c2             	mov    %rax,%rdx
  804bd8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804bdf:	00 00 00 
  804be2:	48 c1 e2 04          	shl    $0x4,%rdx
  804be6:	48 01 d0             	add    %rdx,%rax
  804be9:	48 83 c0 08          	add    $0x8,%rax
  804bed:	0f b7 00             	movzwl (%rax),%eax
  804bf0:	0f b7 c0             	movzwl %ax,%eax
}
  804bf3:	c9                   	leaveq 
  804bf4:	c3                   	retq   
