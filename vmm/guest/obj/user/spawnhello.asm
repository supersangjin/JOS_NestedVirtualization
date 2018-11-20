
vmm/guest/obj/user/spawnhello:     file format elf64-x86-64


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
  800067:	48 bf 80 4c 80 00 00 	movabs $0x804c80,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 9e 4c 80 00 00 	movabs $0x804c9e,%rsi
  80008e:	00 00 00 
  800091:	48 bf a4 4c 80 00 00 	movabs $0x804ca4,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 17 30 80 00 00 	movabs $0x803017,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba af 4c 80 00 00 	movabs $0x804caf,%rdx
  8000c1:	00 00 00 
  8000c4:	be 0a 00 00 00       	mov    $0xa,%esi
  8000c9:	48 bf c7 4c 80 00 00 	movabs $0x804cc7,%rdi
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
  800170:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
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
  80024a:	48 bf e8 4c 80 00 00 	movabs $0x804ce8,%rdi
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
  800286:	48 bf 0b 4d 80 00 00 	movabs $0x804d0b,%rdi
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
  800537:	48 b8 10 4f 80 00 00 	movabs $0x804f10,%rax
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
  800819:	48 b8 38 4f 80 00 00 	movabs $0x804f38,%rax
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
  800960:	48 b8 60 4e 80 00 00 	movabs $0x804e60,%rax
  800967:	00 00 00 
  80096a:	48 63 d3             	movslq %ebx,%rdx
  80096d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800971:	4d 85 e4             	test   %r12,%r12
  800974:	75 2e                	jne    8009a4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800976:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80097a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097e:	89 d9                	mov    %ebx,%ecx
  800980:	48 ba 21 4f 80 00 00 	movabs $0x804f21,%rdx
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
  8009af:	48 ba 2a 4f 80 00 00 	movabs $0x804f2a,%rdx
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
  800a06:	49 bc 2d 4f 80 00 00 	movabs $0x804f2d,%r12
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
  801712:	48 ba e8 51 80 00 00 	movabs $0x8051e8,%rdx
  801719:	00 00 00 
  80171c:	be 24 00 00 00       	mov    $0x24,%esi
  801721:	48 bf 05 52 80 00 00 	movabs $0x805205,%rdi
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

0000000000801c8c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c8c:	55                   	push   %rbp
  801c8d:	48 89 e5             	mov    %rsp,%rbp
  801c90:	48 83 ec 08          	sub    $0x8,%rsp
  801c94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c98:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c9c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ca3:	ff ff ff 
  801ca6:	48 01 d0             	add    %rdx,%rax
  801ca9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cad:	c9                   	leaveq 
  801cae:	c3                   	retq   

0000000000801caf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801caf:	55                   	push   %rbp
  801cb0:	48 89 e5             	mov    %rsp,%rbp
  801cb3:	48 83 ec 08          	sub    $0x8,%rsp
  801cb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbf:	48 89 c7             	mov    %rax,%rdi
  801cc2:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
  801cce:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cd4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 18          	sub    $0x18,%rsp
  801ce2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ce6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ced:	eb 6b                	jmp    801d5a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf2:	48 98                	cltq   
  801cf4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cfa:	48 c1 e0 0c          	shl    $0xc,%rax
  801cfe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d06:	48 c1 e8 15          	shr    $0x15,%rax
  801d0a:	48 89 c2             	mov    %rax,%rdx
  801d0d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d14:	01 00 00 
  801d17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d1b:	83 e0 01             	and    $0x1,%eax
  801d1e:	48 85 c0             	test   %rax,%rax
  801d21:	74 21                	je     801d44 <fd_alloc+0x6a>
  801d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d27:	48 c1 e8 0c          	shr    $0xc,%rax
  801d2b:	48 89 c2             	mov    %rax,%rdx
  801d2e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d35:	01 00 00 
  801d38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d3c:	83 e0 01             	and    $0x1,%eax
  801d3f:	48 85 c0             	test   %rax,%rax
  801d42:	75 12                	jne    801d56 <fd_alloc+0x7c>
			*fd_store = fd;
  801d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d54:	eb 1a                	jmp    801d70 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d56:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d5a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d5e:	7e 8f                	jle    801cef <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d64:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d6b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d70:	c9                   	leaveq 
  801d71:	c3                   	retq   

0000000000801d72 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d72:	55                   	push   %rbp
  801d73:	48 89 e5             	mov    %rsp,%rbp
  801d76:	48 83 ec 20          	sub    $0x20,%rsp
  801d7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d81:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d85:	78 06                	js     801d8d <fd_lookup+0x1b>
  801d87:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d8b:	7e 07                	jle    801d94 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d92:	eb 6c                	jmp    801e00 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d97:	48 98                	cltq   
  801d99:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d9f:	48 c1 e0 0c          	shl    $0xc,%rax
  801da3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801da7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dab:	48 c1 e8 15          	shr    $0x15,%rax
  801daf:	48 89 c2             	mov    %rax,%rdx
  801db2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801db9:	01 00 00 
  801dbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dc0:	83 e0 01             	and    $0x1,%eax
  801dc3:	48 85 c0             	test   %rax,%rax
  801dc6:	74 21                	je     801de9 <fd_lookup+0x77>
  801dc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcc:	48 c1 e8 0c          	shr    $0xc,%rax
  801dd0:	48 89 c2             	mov    %rax,%rdx
  801dd3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dda:	01 00 00 
  801ddd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de1:	83 e0 01             	and    $0x1,%eax
  801de4:	48 85 c0             	test   %rax,%rax
  801de7:	75 07                	jne    801df0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801de9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dee:	eb 10                	jmp    801e00 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801df0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801df4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801df8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e00:	c9                   	leaveq 
  801e01:	c3                   	retq   

0000000000801e02 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e02:	55                   	push   %rbp
  801e03:	48 89 e5             	mov    %rsp,%rbp
  801e06:	48 83 ec 30          	sub    $0x30,%rsp
  801e0a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e0e:	89 f0                	mov    %esi,%eax
  801e10:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e17:	48 89 c7             	mov    %rax,%rdi
  801e1a:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  801e21:	00 00 00 
  801e24:	ff d0                	callq  *%rax
  801e26:	89 c2                	mov    %eax,%edx
  801e28:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801e2c:	48 89 c6             	mov    %rax,%rsi
  801e2f:	89 d7                	mov    %edx,%edi
  801e31:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
  801e3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e44:	78 0a                	js     801e50 <fd_close+0x4e>
	    || fd != fd2)
  801e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e4e:	74 12                	je     801e62 <fd_close+0x60>
		return (must_exist ? r : 0);
  801e50:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e54:	74 05                	je     801e5b <fd_close+0x59>
  801e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e59:	eb 70                	jmp    801ecb <fd_close+0xc9>
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e60:	eb 69                	jmp    801ecb <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e66:	8b 00                	mov    (%rax),%eax
  801e68:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e6c:	48 89 d6             	mov    %rdx,%rsi
  801e6f:	89 c7                	mov    %eax,%edi
  801e71:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
  801e7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e84:	78 2a                	js     801eb0 <fd_close+0xae>
		if (dev->dev_close)
  801e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e8e:	48 85 c0             	test   %rax,%rax
  801e91:	74 16                	je     801ea9 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e97:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e9b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e9f:	48 89 d7             	mov    %rdx,%rdi
  801ea2:	ff d0                	callq  *%rax
  801ea4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea7:	eb 07                	jmp    801eb0 <fd_close+0xae>
		else
			r = 0;
  801ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801eb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb4:	48 89 c6             	mov    %rax,%rsi
  801eb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebc:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
	return r;
  801ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ecb:	c9                   	leaveq 
  801ecc:	c3                   	retq   

0000000000801ecd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	48 83 ec 20          	sub    $0x20,%rsp
  801ed5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801edc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ee3:	eb 41                	jmp    801f26 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ee5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801eec:	00 00 00 
  801eef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ef2:	48 63 d2             	movslq %edx,%rdx
  801ef5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef9:	8b 00                	mov    (%rax),%eax
  801efb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801efe:	75 22                	jne    801f22 <dev_lookup+0x55>
			*dev = devtab[i];
  801f00:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801f07:	00 00 00 
  801f0a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f0d:	48 63 d2             	movslq %edx,%rdx
  801f10:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f18:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	eb 60                	jmp    801f82 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f22:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f26:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801f2d:	00 00 00 
  801f30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f33:	48 63 d2             	movslq %edx,%rdx
  801f36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3a:	48 85 c0             	test   %rax,%rax
  801f3d:	75 a6                	jne    801ee5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f3f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  801f46:	00 00 00 
  801f49:	48 8b 00             	mov    (%rax),%rax
  801f4c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f52:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f55:	89 c6                	mov    %eax,%esi
  801f57:	48 bf 18 52 80 00 00 	movabs $0x805218,%rdi
  801f5e:	00 00 00 
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  801f6d:	00 00 00 
  801f70:	ff d1                	callq  *%rcx
	*dev = 0;
  801f72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f76:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f82:	c9                   	leaveq 
  801f83:	c3                   	retq   

0000000000801f84 <close>:

int
close(int fdnum)
{
  801f84:	55                   	push   %rbp
  801f85:	48 89 e5             	mov    %rsp,%rbp
  801f88:	48 83 ec 20          	sub    $0x20,%rsp
  801f8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f96:	48 89 d6             	mov    %rdx,%rsi
  801f99:	89 c7                	mov    %eax,%edi
  801f9b:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  801fa2:	00 00 00 
  801fa5:	ff d0                	callq  *%rax
  801fa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fae:	79 05                	jns    801fb5 <close+0x31>
		return r;
  801fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb3:	eb 18                	jmp    801fcd <close+0x49>
	else
		return fd_close(fd, 1);
  801fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb9:	be 01 00 00 00       	mov    $0x1,%esi
  801fbe:	48 89 c7             	mov    %rax,%rdi
  801fc1:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  801fc8:	00 00 00 
  801fcb:	ff d0                	callq  *%rax
}
  801fcd:	c9                   	leaveq 
  801fce:	c3                   	retq   

0000000000801fcf <close_all>:

void
close_all(void)
{
  801fcf:	55                   	push   %rbp
  801fd0:	48 89 e5             	mov    %rsp,%rbp
  801fd3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fde:	eb 15                	jmp    801ff5 <close_all+0x26>
		close(i);
  801fe0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe3:	89 c7                	mov    %eax,%edi
  801fe5:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  801fec:	00 00 00 
  801fef:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ff1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ff5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ff9:	7e e5                	jle    801fe0 <close_all+0x11>
		close(i);
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leaveq 
  801ffd:	c3                   	retq   

0000000000801ffe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ffe:	55                   	push   %rbp
  801fff:	48 89 e5             	mov    %rsp,%rbp
  802002:	48 83 ec 40          	sub    $0x40,%rsp
  802006:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802009:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80200c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802010:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802013:	48 89 d6             	mov    %rdx,%rsi
  802016:	89 c7                	mov    %eax,%edi
  802018:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  80201f:	00 00 00 
  802022:	ff d0                	callq  *%rax
  802024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202b:	79 08                	jns    802035 <dup+0x37>
		return r;
  80202d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802030:	e9 70 01 00 00       	jmpq   8021a5 <dup+0x1a7>
	close(newfdnum);
  802035:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802038:	89 c7                	mov    %eax,%edi
  80203a:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802046:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802049:	48 98                	cltq   
  80204b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802051:	48 c1 e0 0c          	shl    $0xc,%rax
  802055:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802059:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205d:	48 89 c7             	mov    %rax,%rdi
  802060:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  802067:	00 00 00 
  80206a:	ff d0                	callq  *%rax
  80206c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802074:	48 89 c7             	mov    %rax,%rdi
  802077:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  80207e:	00 00 00 
  802081:	ff d0                	callq  *%rax
  802083:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208b:	48 c1 e8 15          	shr    $0x15,%rax
  80208f:	48 89 c2             	mov    %rax,%rdx
  802092:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802099:	01 00 00 
  80209c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a0:	83 e0 01             	and    $0x1,%eax
  8020a3:	48 85 c0             	test   %rax,%rax
  8020a6:	74 71                	je     802119 <dup+0x11b>
  8020a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8020b0:	48 89 c2             	mov    %rax,%rdx
  8020b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ba:	01 00 00 
  8020bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c1:	83 e0 01             	and    $0x1,%eax
  8020c4:	48 85 c0             	test   %rax,%rax
  8020c7:	74 50                	je     802119 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d1:	48 89 c2             	mov    %rax,%rdx
  8020d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020db:	01 00 00 
  8020de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8020e7:	89 c1                	mov    %eax,%ecx
  8020e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f1:	41 89 c8             	mov    %ecx,%r8d
  8020f4:	48 89 d1             	mov    %rdx,%rcx
  8020f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fc:	48 89 c6             	mov    %rax,%rsi
  8020ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802104:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  80210b:	00 00 00 
  80210e:	ff d0                	callq  *%rax
  802110:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802113:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802117:	78 55                	js     80216e <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802119:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211d:	48 c1 e8 0c          	shr    $0xc,%rax
  802121:	48 89 c2             	mov    %rax,%rdx
  802124:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80212b:	01 00 00 
  80212e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802132:	25 07 0e 00 00       	and    $0xe07,%eax
  802137:	89 c1                	mov    %eax,%ecx
  802139:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802141:	41 89 c8             	mov    %ecx,%r8d
  802144:	48 89 d1             	mov    %rdx,%rcx
  802147:	ba 00 00 00 00       	mov    $0x0,%edx
  80214c:	48 89 c6             	mov    %rax,%rsi
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
  802154:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802163:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802167:	78 08                	js     802171 <dup+0x173>
		goto err;

	return newfdnum;
  802169:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80216c:	eb 37                	jmp    8021a5 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80216e:	90                   	nop
  80216f:	eb 01                	jmp    802172 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802171:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802176:	48 89 c6             	mov    %rax,%rsi
  802179:	bf 00 00 00 00       	mov    $0x0,%edi
  80217e:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  802185:	00 00 00 
  802188:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80218a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80218e:	48 89 c6             	mov    %rax,%rsi
  802191:	bf 00 00 00 00       	mov    $0x0,%edi
  802196:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	callq  *%rax
	return r;
  8021a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021a5:	c9                   	leaveq 
  8021a6:	c3                   	retq   

00000000008021a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021a7:	55                   	push   %rbp
  8021a8:	48 89 e5             	mov    %rsp,%rbp
  8021ab:	48 83 ec 40          	sub    $0x40,%rsp
  8021af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021c1:	48 89 d6             	mov    %rdx,%rsi
  8021c4:	89 c7                	mov    %eax,%edi
  8021c6:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
  8021d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d9:	78 24                	js     8021ff <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	8b 00                	mov    (%rax),%eax
  8021e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021e5:	48 89 d6             	mov    %rdx,%rsi
  8021e8:	89 c7                	mov    %eax,%edi
  8021ea:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
  8021f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fd:	79 05                	jns    802204 <read+0x5d>
		return r;
  8021ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802202:	eb 76                	jmp    80227a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802208:	8b 40 08             	mov    0x8(%rax),%eax
  80220b:	83 e0 03             	and    $0x3,%eax
  80220e:	83 f8 01             	cmp    $0x1,%eax
  802211:	75 3a                	jne    80224d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802213:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80221a:	00 00 00 
  80221d:	48 8b 00             	mov    (%rax),%rax
  802220:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802226:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802229:	89 c6                	mov    %eax,%esi
  80222b:	48 bf 37 52 80 00 00 	movabs $0x805237,%rdi
  802232:	00 00 00 
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802241:	00 00 00 
  802244:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802246:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80224b:	eb 2d                	jmp    80227a <read+0xd3>
	}
	if (!dev->dev_read)
  80224d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802251:	48 8b 40 10          	mov    0x10(%rax),%rax
  802255:	48 85 c0             	test   %rax,%rax
  802258:	75 07                	jne    802261 <read+0xba>
		return -E_NOT_SUPP;
  80225a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80225f:	eb 19                	jmp    80227a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802265:	48 8b 40 10          	mov    0x10(%rax),%rax
  802269:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80226d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802271:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802275:	48 89 cf             	mov    %rcx,%rdi
  802278:	ff d0                	callq  *%rax
}
  80227a:	c9                   	leaveq 
  80227b:	c3                   	retq   

000000000080227c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80227c:	55                   	push   %rbp
  80227d:	48 89 e5             	mov    %rsp,%rbp
  802280:	48 83 ec 30          	sub    $0x30,%rsp
  802284:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802287:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80228b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80228f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802296:	eb 47                	jmp    8022df <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802298:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229b:	48 98                	cltq   
  80229d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022a1:	48 29 c2             	sub    %rax,%rdx
  8022a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a7:	48 63 c8             	movslq %eax,%rcx
  8022aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ae:	48 01 c1             	add    %rax,%rcx
  8022b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022b4:	48 89 ce             	mov    %rcx,%rsi
  8022b7:	89 c7                	mov    %eax,%edi
  8022b9:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  8022c0:	00 00 00 
  8022c3:	ff d0                	callq  *%rax
  8022c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022cc:	79 05                	jns    8022d3 <readn+0x57>
			return m;
  8022ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022d1:	eb 1d                	jmp    8022f0 <readn+0x74>
		if (m == 0)
  8022d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022d7:	74 13                	je     8022ec <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022dc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e2:	48 98                	cltq   
  8022e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022e8:	72 ae                	jb     802298 <readn+0x1c>
  8022ea:	eb 01                	jmp    8022ed <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8022ec:	90                   	nop
	}
	return tot;
  8022ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f0:	c9                   	leaveq 
  8022f1:	c3                   	retq   

00000000008022f2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022f2:	55                   	push   %rbp
  8022f3:	48 89 e5             	mov    %rsp,%rbp
  8022f6:	48 83 ec 40          	sub    $0x40,%rsp
  8022fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802301:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802305:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802309:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80230c:	48 89 d6             	mov    %rdx,%rsi
  80230f:	89 c7                	mov    %eax,%edi
  802311:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
  80231d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802320:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802324:	78 24                	js     80234a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232a:	8b 00                	mov    (%rax),%eax
  80232c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802330:	48 89 d6             	mov    %rdx,%rsi
  802333:	89 c7                	mov    %eax,%edi
  802335:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	callq  *%rax
  802341:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802348:	79 05                	jns    80234f <write+0x5d>
		return r;
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	eb 75                	jmp    8023c4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80234f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802353:	8b 40 08             	mov    0x8(%rax),%eax
  802356:	83 e0 03             	and    $0x3,%eax
  802359:	85 c0                	test   %eax,%eax
  80235b:	75 3a                	jne    802397 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80235d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802364:	00 00 00 
  802367:	48 8b 00             	mov    (%rax),%rax
  80236a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802370:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802373:	89 c6                	mov    %eax,%esi
  802375:	48 bf 53 52 80 00 00 	movabs $0x805253,%rdi
  80237c:	00 00 00 
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
  802384:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80238b:	00 00 00 
  80238e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802390:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802395:	eb 2d                	jmp    8023c4 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80239f:	48 85 c0             	test   %rax,%rax
  8023a2:	75 07                	jne    8023ab <write+0xb9>
		return -E_NOT_SUPP;
  8023a4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023a9:	eb 19                	jmp    8023c4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023af:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023bb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023bf:	48 89 cf             	mov    %rcx,%rdi
  8023c2:	ff d0                	callq  *%rax
}
  8023c4:	c9                   	leaveq 
  8023c5:	c3                   	retq   

00000000008023c6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023c6:	55                   	push   %rbp
  8023c7:	48 89 e5             	mov    %rsp,%rbp
  8023ca:	48 83 ec 18          	sub    $0x18,%rsp
  8023ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023db:	48 89 d6             	mov    %rdx,%rsi
  8023de:	89 c7                	mov    %eax,%edi
  8023e0:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f3:	79 05                	jns    8023fa <seek+0x34>
		return r;
  8023f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f8:	eb 0f                	jmp    802409 <seek+0x43>
	fd->fd_offset = offset;
  8023fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802401:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802409:	c9                   	leaveq 
  80240a:	c3                   	retq   

000000000080240b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80240b:	55                   	push   %rbp
  80240c:	48 89 e5             	mov    %rsp,%rbp
  80240f:	48 83 ec 30          	sub    $0x30,%rsp
  802413:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802416:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802419:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80241d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802420:	48 89 d6             	mov    %rdx,%rsi
  802423:	89 c7                	mov    %eax,%edi
  802425:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  80242c:	00 00 00 
  80242f:	ff d0                	callq  *%rax
  802431:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802434:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802438:	78 24                	js     80245e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80243a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243e:	8b 00                	mov    (%rax),%eax
  802440:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802444:	48 89 d6             	mov    %rdx,%rsi
  802447:	89 c7                	mov    %eax,%edi
  802449:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  802450:	00 00 00 
  802453:	ff d0                	callq  *%rax
  802455:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245c:	79 05                	jns    802463 <ftruncate+0x58>
		return r;
  80245e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802461:	eb 72                	jmp    8024d5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802467:	8b 40 08             	mov    0x8(%rax),%eax
  80246a:	83 e0 03             	and    $0x3,%eax
  80246d:	85 c0                	test   %eax,%eax
  80246f:	75 3a                	jne    8024ab <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802471:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802478:	00 00 00 
  80247b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80247e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802484:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802487:	89 c6                	mov    %eax,%esi
  802489:	48 bf 70 52 80 00 00 	movabs $0x805270,%rdi
  802490:	00 00 00 
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
  802498:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80249f:	00 00 00 
  8024a2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a9:	eb 2a                	jmp    8024d5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024af:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024b3:	48 85 c0             	test   %rax,%rax
  8024b6:	75 07                	jne    8024bf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024bd:	eb 16                	jmp    8024d5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024cb:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024ce:	89 ce                	mov    %ecx,%esi
  8024d0:	48 89 d7             	mov    %rdx,%rdi
  8024d3:	ff d0                	callq  *%rax
}
  8024d5:	c9                   	leaveq 
  8024d6:	c3                   	retq   

00000000008024d7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024d7:	55                   	push   %rbp
  8024d8:	48 89 e5             	mov    %rsp,%rbp
  8024db:	48 83 ec 30          	sub    $0x30,%rsp
  8024df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ed:	48 89 d6             	mov    %rdx,%rsi
  8024f0:	89 c7                	mov    %eax,%edi
  8024f2:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax
  8024fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802501:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802505:	78 24                	js     80252b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250b:	8b 00                	mov    (%rax),%eax
  80250d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802511:	48 89 d6             	mov    %rdx,%rsi
  802514:	89 c7                	mov    %eax,%edi
  802516:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802525:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802529:	79 05                	jns    802530 <fstat+0x59>
		return r;
  80252b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252e:	eb 5e                	jmp    80258e <fstat+0xb7>
	if (!dev->dev_stat)
  802530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802534:	48 8b 40 28          	mov    0x28(%rax),%rax
  802538:	48 85 c0             	test   %rax,%rax
  80253b:	75 07                	jne    802544 <fstat+0x6d>
		return -E_NOT_SUPP;
  80253d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802542:	eb 4a                	jmp    80258e <fstat+0xb7>
	stat->st_name[0] = 0;
  802544:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802548:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80254b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80254f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802556:	00 00 00 
	stat->st_isdir = 0;
  802559:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80255d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802564:	00 00 00 
	stat->st_dev = dev;
  802567:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80256b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80256f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80257e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802582:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802586:	48 89 ce             	mov    %rcx,%rsi
  802589:	48 89 d7             	mov    %rdx,%rdi
  80258c:	ff d0                	callq  *%rax
}
  80258e:	c9                   	leaveq 
  80258f:	c3                   	retq   

0000000000802590 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	48 83 ec 20          	sub    $0x20,%rsp
  802598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80259c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a4:	be 00 00 00 00       	mov    $0x0,%esi
  8025a9:	48 89 c7             	mov    %rax,%rdi
  8025ac:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
  8025b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bf:	79 05                	jns    8025c6 <stat+0x36>
		return fd;
  8025c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c4:	eb 2f                	jmp    8025f5 <stat+0x65>
	r = fstat(fd, stat);
  8025c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025cd:	48 89 d6             	mov    %rdx,%rsi
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 d7 24 80 00 00 	movabs $0x8024d7,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e4:	89 c7                	mov    %eax,%edi
  8025e6:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
	return r;
  8025f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025f5:	c9                   	leaveq 
  8025f6:	c3                   	retq   

00000000008025f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025f7:	55                   	push   %rbp
  8025f8:	48 89 e5             	mov    %rsp,%rbp
  8025fb:	48 83 ec 10          	sub    $0x10,%rsp
  8025ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802602:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802606:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80260d:	00 00 00 
  802610:	8b 00                	mov    (%rax),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	75 1f                	jne    802635 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802616:	bf 01 00 00 00       	mov    $0x1,%edi
  80261b:	48 b8 73 4b 80 00 00 	movabs $0x804b73,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
  802627:	89 c2                	mov    %eax,%edx
  802629:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802630:	00 00 00 
  802633:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802635:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80263c:	00 00 00 
  80263f:	8b 00                	mov    (%rax),%eax
  802641:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802644:	b9 07 00 00 00       	mov    $0x7,%ecx
  802649:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802650:	00 00 00 
  802653:	89 c7                	mov    %eax,%edi
  802655:	48 b8 67 49 80 00 00 	movabs $0x804967,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802665:	ba 00 00 00 00       	mov    $0x0,%edx
  80266a:	48 89 c6             	mov    %rax,%rsi
  80266d:	bf 00 00 00 00       	mov    $0x0,%edi
  802672:	48 b8 a6 48 80 00 00 	movabs $0x8048a6,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
}
  80267e:	c9                   	leaveq 
  80267f:	c3                   	retq   

0000000000802680 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802680:	55                   	push   %rbp
  802681:	48 89 e5             	mov    %rsp,%rbp
  802684:	48 83 ec 20          	sub    $0x20,%rsp
  802688:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80268c:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80268f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802693:	48 89 c7             	mov    %rax,%rdi
  802696:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	callq  *%rax
  8026a2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026a7:	7e 0a                	jle    8026b3 <open+0x33>
		return -E_BAD_PATH;
  8026a9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026ae:	e9 a5 00 00 00       	jmpq   802758 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8026b3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026b7:	48 89 c7             	mov    %rax,%rdi
  8026ba:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	callq  *%rax
  8026c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cd:	79 08                	jns    8026d7 <open+0x57>
		return r;
  8026cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d2:	e9 81 00 00 00       	jmpq   802758 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8026d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026db:	48 89 c6             	mov    %rax,%rsi
  8026de:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8026e5:	00 00 00 
  8026e8:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8026f4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8026fb:	00 00 00 
  8026fe:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802701:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270b:	48 89 c6             	mov    %rax,%rsi
  80270e:	bf 01 00 00 00       	mov    $0x1,%edi
  802713:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	callq  *%rax
  80271f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802722:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802726:	79 1d                	jns    802745 <open+0xc5>
		fd_close(fd, 0);
  802728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272c:	be 00 00 00 00       	mov    $0x0,%esi
  802731:	48 89 c7             	mov    %rax,%rdi
  802734:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax
		return r;
  802740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802743:	eb 13                	jmp    802758 <open+0xd8>
	}

	return fd2num(fd);
  802745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802749:	48 89 c7             	mov    %rax,%rdi
  80274c:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  802753:	00 00 00 
  802756:	ff d0                	callq  *%rax

}
  802758:	c9                   	leaveq 
  802759:	c3                   	retq   

000000000080275a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80275a:	55                   	push   %rbp
  80275b:	48 89 e5             	mov    %rsp,%rbp
  80275e:	48 83 ec 10          	sub    $0x10,%rsp
  802762:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80276a:	8b 50 0c             	mov    0xc(%rax),%edx
  80276d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802774:	00 00 00 
  802777:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802779:	be 00 00 00 00       	mov    $0x0,%esi
  80277e:	bf 06 00 00 00       	mov    $0x6,%edi
  802783:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  80278a:	00 00 00 
  80278d:	ff d0                	callq  *%rax
}
  80278f:	c9                   	leaveq 
  802790:	c3                   	retq   

0000000000802791 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802791:	55                   	push   %rbp
  802792:	48 89 e5             	mov    %rsp,%rbp
  802795:	48 83 ec 30          	sub    $0x30,%rsp
  802799:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80279d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8027ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027b3:	00 00 00 
  8027b6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027b8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027bf:	00 00 00 
  8027c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8027ca:	be 00 00 00 00       	mov    $0x0,%esi
  8027cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8027d4:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
  8027e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e7:	79 08                	jns    8027f1 <devfile_read+0x60>
		return r;
  8027e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ec:	e9 a4 00 00 00       	jmpq   802895 <devfile_read+0x104>
	assert(r <= n);
  8027f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f4:	48 98                	cltq   
  8027f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027fa:	76 35                	jbe    802831 <devfile_read+0xa0>
  8027fc:	48 b9 96 52 80 00 00 	movabs $0x805296,%rcx
  802803:	00 00 00 
  802806:	48 ba 9d 52 80 00 00 	movabs $0x80529d,%rdx
  80280d:	00 00 00 
  802810:	be 86 00 00 00       	mov    $0x86,%esi
  802815:	48 bf b2 52 80 00 00 	movabs $0x8052b2,%rdi
  80281c:	00 00 00 
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  80282b:	00 00 00 
  80282e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802831:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802838:	7e 35                	jle    80286f <devfile_read+0xde>
  80283a:	48 b9 bd 52 80 00 00 	movabs $0x8052bd,%rcx
  802841:	00 00 00 
  802844:	48 ba 9d 52 80 00 00 	movabs $0x80529d,%rdx
  80284b:	00 00 00 
  80284e:	be 87 00 00 00       	mov    $0x87,%esi
  802853:	48 bf b2 52 80 00 00 	movabs $0x8052b2,%rdi
  80285a:	00 00 00 
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
  802862:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802869:	00 00 00 
  80286c:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80286f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802872:	48 63 d0             	movslq %eax,%rdx
  802875:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802879:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802880:	00 00 00 
  802883:	48 89 c7             	mov    %rax,%rdi
  802886:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  80288d:	00 00 00 
  802890:	ff d0                	callq  *%rax
	return r;
  802892:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802895:	c9                   	leaveq 
  802896:	c3                   	retq   

0000000000802897 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802897:	55                   	push   %rbp
  802898:	48 89 e5             	mov    %rsp,%rbp
  80289b:	48 83 ec 40          	sub    $0x40,%rsp
  80289f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8028ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8028b3:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8028ba:	00 
  8028bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bf:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8028c3:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8028c8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028da:	00 00 00 
  8028dd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028e6:	00 00 00 
  8028e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028ed:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8028f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028f9:	48 89 c6             	mov    %rax,%rsi
  8028fc:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802903:	00 00 00 
  802906:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802912:	be 00 00 00 00       	mov    $0x0,%esi
  802917:	bf 04 00 00 00       	mov    $0x4,%edi
  80291c:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
  802928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80292b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80292f:	79 05                	jns    802936 <devfile_write+0x9f>
		return r;
  802931:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802934:	eb 43                	jmp    802979 <devfile_write+0xe2>
	assert(r <= n);
  802936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802939:	48 98                	cltq   
  80293b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80293f:	76 35                	jbe    802976 <devfile_write+0xdf>
  802941:	48 b9 96 52 80 00 00 	movabs $0x805296,%rcx
  802948:	00 00 00 
  80294b:	48 ba 9d 52 80 00 00 	movabs $0x80529d,%rdx
  802952:	00 00 00 
  802955:	be a2 00 00 00       	mov    $0xa2,%esi
  80295a:	48 bf b2 52 80 00 00 	movabs $0x8052b2,%rdi
  802961:	00 00 00 
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
  802969:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802970:	00 00 00 
  802973:	41 ff d0             	callq  *%r8
	return r;
  802976:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802979:	c9                   	leaveq 
  80297a:	c3                   	retq   

000000000080297b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80297b:	55                   	push   %rbp
  80297c:	48 89 e5             	mov    %rsp,%rbp
  80297f:	48 83 ec 20          	sub    $0x20,%rsp
  802983:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802987:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80298b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298f:	8b 50 0c             	mov    0xc(%rax),%edx
  802992:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802999:	00 00 00 
  80299c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80299e:	be 00 00 00 00       	mov    $0x0,%esi
  8029a3:	bf 05 00 00 00       	mov    $0x5,%edi
  8029a8:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bb:	79 05                	jns    8029c2 <devfile_stat+0x47>
		return r;
  8029bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c0:	eb 56                	jmp    802a18 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029cd:	00 00 00 
  8029d0:	48 89 c7             	mov    %rax,%rdi
  8029d3:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029e6:	00 00 00 
  8029e9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029f9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a00:	00 00 00 
  802a03:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a0d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a18:	c9                   	leaveq 
  802a19:	c3                   	retq   

0000000000802a1a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a1a:	55                   	push   %rbp
  802a1b:	48 89 e5             	mov    %rsp,%rbp
  802a1e:	48 83 ec 10          	sub    $0x10,%rsp
  802a22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a26:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a2d:	8b 50 0c             	mov    0xc(%rax),%edx
  802a30:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a37:	00 00 00 
  802a3a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a3c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a43:	00 00 00 
  802a46:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a4c:	be 00 00 00 00       	mov    $0x0,%esi
  802a51:	bf 02 00 00 00       	mov    $0x2,%edi
  802a56:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  802a5d:	00 00 00 
  802a60:	ff d0                	callq  *%rax
}
  802a62:	c9                   	leaveq 
  802a63:	c3                   	retq   

0000000000802a64 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a64:	55                   	push   %rbp
  802a65:	48 89 e5             	mov    %rsp,%rbp
  802a68:	48 83 ec 10          	sub    $0x10,%rsp
  802a6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a74:	48 89 c7             	mov    %rax,%rdi
  802a77:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	callq  *%rax
  802a83:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a88:	7e 07                	jle    802a91 <remove+0x2d>
		return -E_BAD_PATH;
  802a8a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a8f:	eb 33                	jmp    802ac4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a95:	48 89 c6             	mov    %rax,%rsi
  802a98:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802a9f:	00 00 00 
  802aa2:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aae:	be 00 00 00 00       	mov    $0x0,%esi
  802ab3:	bf 07 00 00 00       	mov    $0x7,%edi
  802ab8:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  802abf:	00 00 00 
  802ac2:	ff d0                	callq  *%rax
}
  802ac4:	c9                   	leaveq 
  802ac5:	c3                   	retq   

0000000000802ac6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ac6:	55                   	push   %rbp
  802ac7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802aca:	be 00 00 00 00       	mov    $0x0,%esi
  802acf:	bf 08 00 00 00       	mov    $0x8,%edi
  802ad4:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
}
  802ae0:	5d                   	pop    %rbp
  802ae1:	c3                   	retq   

0000000000802ae2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ae2:	55                   	push   %rbp
  802ae3:	48 89 e5             	mov    %rsp,%rbp
  802ae6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802aed:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802af4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802afb:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b02:	be 00 00 00 00       	mov    $0x0,%esi
  802b07:	48 89 c7             	mov    %rax,%rdi
  802b0a:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802b11:	00 00 00 
  802b14:	ff d0                	callq  *%rax
  802b16:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1d:	79 28                	jns    802b47 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b22:	89 c6                	mov    %eax,%esi
  802b24:	48 bf c9 52 80 00 00 	movabs $0x8052c9,%rdi
  802b2b:	00 00 00 
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802b3a:	00 00 00 
  802b3d:	ff d2                	callq  *%rdx
		return fd_src;
  802b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b42:	e9 76 01 00 00       	jmpq   802cbd <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b47:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b4e:	be 01 01 00 00       	mov    $0x101,%esi
  802b53:	48 89 c7             	mov    %rax,%rdi
  802b56:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b65:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b69:	0f 89 ad 00 00 00    	jns    802c1c <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b72:	89 c6                	mov    %eax,%esi
  802b74:	48 bf df 52 80 00 00 	movabs $0x8052df,%rdi
  802b7b:	00 00 00 
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b83:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802b8a:	00 00 00 
  802b8d:	ff d2                	callq  *%rdx
		close(fd_src);
  802b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
		return fd_dest;
  802ba0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba3:	e9 15 01 00 00       	jmpq   802cbd <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802ba8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bab:	48 63 d0             	movslq %eax,%rdx
  802bae:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb8:	48 89 ce             	mov    %rcx,%rsi
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 f2 22 80 00 00 	movabs $0x8022f2,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802bcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bd0:	79 4a                	jns    802c1c <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802bd2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bd5:	89 c6                	mov    %eax,%esi
  802bd7:	48 bf f9 52 80 00 00 	movabs $0x8052f9,%rdi
  802bde:	00 00 00 
  802be1:	b8 00 00 00 00       	mov    $0x0,%eax
  802be6:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802bed:	00 00 00 
  802bf0:	ff d2                	callq  *%rdx
			close(fd_src);
  802bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf5:	89 c7                	mov    %eax,%edi
  802bf7:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
			close(fd_dest);
  802c03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c06:	89 c7                	mov    %eax,%edi
  802c08:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
			return write_size;
  802c14:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c17:	e9 a1 00 00 00       	jmpq   802cbd <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c1c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c26:	ba 00 02 00 00       	mov    $0x200,%edx
  802c2b:	48 89 ce             	mov    %rcx,%rsi
  802c2e:	89 c7                	mov    %eax,%edi
  802c30:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802c37:	00 00 00 
  802c3a:	ff d0                	callq  *%rax
  802c3c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c43:	0f 8f 5f ff ff ff    	jg     802ba8 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c4d:	79 47                	jns    802c96 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802c4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c52:	89 c6                	mov    %eax,%esi
  802c54:	48 bf 0c 53 80 00 00 	movabs $0x80530c,%rdi
  802c5b:	00 00 00 
  802c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c63:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  802c6a:	00 00 00 
  802c6d:	ff d2                	callq  *%rdx
		close(fd_src);
  802c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c72:	89 c7                	mov    %eax,%edi
  802c74:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
		close(fd_dest);
  802c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
		return read_size;
  802c91:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c94:	eb 27                	jmp    802cbd <copy+0x1db>
	}
	close(fd_src);
  802c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c99:	89 c7                	mov    %eax,%edi
  802c9b:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802ca2:	00 00 00 
  802ca5:	ff d0                	callq  *%rax
	close(fd_dest);
  802ca7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802caa:	89 c7                	mov    %eax,%edi
  802cac:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802cb3:	00 00 00 
  802cb6:	ff d0                	callq  *%rax
	return 0;
  802cb8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802cbd:	c9                   	leaveq 
  802cbe:	c3                   	retq   

0000000000802cbf <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802cbf:	55                   	push   %rbp
  802cc0:	48 89 e5             	mov    %rsp,%rbp
  802cc3:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802cca:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802cd1:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802cd8:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802cdf:	be 00 00 00 00       	mov    $0x0,%esi
  802ce4:	48 89 c7             	mov    %rax,%rdi
  802ce7:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
  802cf3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cf6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cfa:	79 08                	jns    802d04 <spawn+0x45>
		return r;
  802cfc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cff:	e9 11 03 00 00       	jmpq   803015 <spawn+0x356>
	fd = r;
  802d04:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d07:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802d0a:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802d11:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802d15:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802d1c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d1f:	ba 00 02 00 00       	mov    $0x200,%edx
  802d24:	48 89 ce             	mov    %rcx,%rsi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	3d 00 02 00 00       	cmp    $0x200,%eax
  802d3a:	75 0d                	jne    802d49 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802d3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d40:	8b 00                	mov    (%rax),%eax
  802d42:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802d47:	74 43                	je     802d8c <spawn+0xcd>
		close(fd);
  802d49:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802d5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d5e:	8b 00                	mov    (%rax),%eax
  802d60:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802d65:	89 c6                	mov    %eax,%esi
  802d67:	48 bf 28 53 80 00 00 	movabs $0x805328,%rdi
  802d6e:	00 00 00 
  802d71:	b8 00 00 00 00       	mov    $0x0,%eax
  802d76:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802d7d:	00 00 00 
  802d80:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802d82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802d87:	e9 89 02 00 00       	jmpq   803015 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802d8c:	b8 07 00 00 00       	mov    $0x7,%eax
  802d91:	cd 30                	int    $0x30
  802d93:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802d96:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802d99:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802da0:	79 08                	jns    802daa <spawn+0xeb>
		return r;
  802da2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802da5:	e9 6b 02 00 00       	jmpq   803015 <spawn+0x356>
	child = r;
  802daa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dad:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802db0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802db3:	25 ff 03 00 00       	and    $0x3ff,%eax
  802db8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802dbf:	00 00 00 
  802dc2:	48 98                	cltq   
  802dc4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802dcb:	48 01 c2             	add    %rax,%rdx
  802dce:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802dd5:	48 89 d6             	mov    %rdx,%rsi
  802dd8:	ba 18 00 00 00       	mov    $0x18,%edx
  802ddd:	48 89 c7             	mov    %rax,%rdi
  802de0:	48 89 d1             	mov    %rdx,%rcx
  802de3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802de6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dea:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dee:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802df5:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802dfc:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802e03:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802e0a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e0d:	48 89 ce             	mov    %rcx,%rsi
  802e10:	89 c7                	mov    %eax,%edi
  802e12:	48 b8 79 32 80 00 00 	movabs $0x803279,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
  802e1e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e21:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e25:	79 08                	jns    802e2f <spawn+0x170>
		return r;
  802e27:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e2a:	e9 e6 01 00 00       	jmpq   803015 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802e2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e33:	48 8b 40 20          	mov    0x20(%rax),%rax
  802e37:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802e3e:	48 01 d0             	add    %rdx,%rax
  802e41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e4c:	e9 80 00 00 00       	jmpq   802ed1 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  802e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e55:	8b 00                	mov    (%rax),%eax
  802e57:	83 f8 01             	cmp    $0x1,%eax
  802e5a:	75 6b                	jne    802ec7 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  802e5c:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e67:	8b 40 04             	mov    0x4(%rax),%eax
  802e6a:	83 e0 02             	and    $0x2,%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 04                	je     802e75 <spawn+0x1b6>
			perm |= PTE_W;
  802e71:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e79:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e7d:	41 89 c1             	mov    %eax,%r9d
  802e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e84:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e8c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e94:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802e98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802e9b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e9e:	48 83 ec 08          	sub    $0x8,%rsp
  802ea2:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802ea5:	57                   	push   %rdi
  802ea6:	89 c7                	mov    %eax,%edi
  802ea8:	48 b8 25 35 80 00 00 	movabs $0x803525,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
  802eb4:	48 83 c4 10          	add    $0x10,%rsp
  802eb8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ebb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ebf:	0f 88 2a 01 00 00    	js     802fef <spawn+0x330>
  802ec5:	eb 01                	jmp    802ec8 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  802ec7:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ec8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ecc:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed5:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802ed9:	0f b7 c0             	movzwl %ax,%eax
  802edc:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802edf:	0f 8f 6c ff ff ff    	jg     802e51 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802ee5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ee8:	89 c7                	mov    %eax,%edi
  802eea:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  802ef1:	00 00 00 
  802ef4:	ff d0                	callq  *%rax
	fd = -1;
  802ef6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802efd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f00:	89 c7                	mov    %eax,%edi
  802f02:	48 b8 11 37 80 00 00 	movabs $0x803711,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
  802f0e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f11:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f15:	79 30                	jns    802f47 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  802f17:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f1a:	89 c1                	mov    %eax,%ecx
  802f1c:	48 ba 42 53 80 00 00 	movabs $0x805342,%rdx
  802f23:	00 00 00 
  802f26:	be 86 00 00 00       	mov    $0x86,%esi
  802f2b:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  802f32:	00 00 00 
  802f35:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3a:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802f41:	00 00 00 
  802f44:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f47:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802f4e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f51:	48 89 d6             	mov    %rdx,%rsi
  802f54:	89 c7                	mov    %eax,%edi
  802f56:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
  802f62:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f65:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f69:	79 30                	jns    802f9b <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  802f6b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f6e:	89 c1                	mov    %eax,%ecx
  802f70:	48 ba 64 53 80 00 00 	movabs $0x805364,%rdx
  802f77:	00 00 00 
  802f7a:	be 8a 00 00 00       	mov    $0x8a,%esi
  802f7f:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  802f86:	00 00 00 
  802f89:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8e:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802f95:	00 00 00 
  802f98:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f9b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f9e:	be 02 00 00 00       	mov    $0x2,%esi
  802fa3:	89 c7                	mov    %eax,%edi
  802fa5:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
  802fb1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fb4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fb8:	79 30                	jns    802fea <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  802fba:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fbd:	89 c1                	mov    %eax,%ecx
  802fbf:	48 ba 7e 53 80 00 00 	movabs $0x80537e,%rdx
  802fc6:	00 00 00 
  802fc9:	be 8d 00 00 00       	mov    $0x8d,%esi
  802fce:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  802fd5:	00 00 00 
  802fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdd:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  802fe4:	00 00 00 
  802fe7:	41 ff d0             	callq  *%r8

	return child;
  802fea:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802fed:	eb 26                	jmp    803015 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802fef:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802ff0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ff3:	89 c7                	mov    %eax,%edi
  802ff5:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  802ffc:	00 00 00 
  802fff:	ff d0                	callq  *%rax
	close(fd);
  803001:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803004:	89 c7                	mov    %eax,%edi
  803006:	48 b8 84 1f 80 00 00 	movabs $0x801f84,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
	return r;
  803012:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  803015:	c9                   	leaveq 
  803016:	c3                   	retq   

0000000000803017 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803017:	55                   	push   %rbp
  803018:	48 89 e5             	mov    %rsp,%rbp
  80301b:	41 55                	push   %r13
  80301d:	41 54                	push   %r12
  80301f:	53                   	push   %rbx
  803020:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803027:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  80302e:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  803035:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80303c:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803043:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80304a:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803051:	84 c0                	test   %al,%al
  803053:	74 26                	je     80307b <spawnl+0x64>
  803055:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80305c:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803063:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803067:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80306b:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80306f:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803073:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803077:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80307b:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803082:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803085:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80308c:	00 00 00 
  80308f:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803096:	00 00 00 
  803099:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309d:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030a4:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8030ab:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8030b2:	eb 07                	jmp    8030bb <spawnl+0xa4>
		argc++;
  8030b4:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8030bb:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8030c1:	83 f8 30             	cmp    $0x30,%eax
  8030c4:	73 23                	jae    8030e9 <spawnl+0xd2>
  8030c6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8030cd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030d3:	89 d2                	mov    %edx,%edx
  8030d5:	48 01 d0             	add    %rdx,%rax
  8030d8:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030de:	83 c2 08             	add    $0x8,%edx
  8030e1:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8030e7:	eb 12                	jmp    8030fb <spawnl+0xe4>
  8030e9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8030f0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8030f4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8030fb:	48 8b 00             	mov    (%rax),%rax
  8030fe:	48 85 c0             	test   %rax,%rax
  803101:	75 b1                	jne    8030b4 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803103:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803109:	83 c0 02             	add    $0x2,%eax
  80310c:	48 89 e2             	mov    %rsp,%rdx
  80310f:	48 89 d3             	mov    %rdx,%rbx
  803112:	48 63 d0             	movslq %eax,%rdx
  803115:	48 83 ea 01          	sub    $0x1,%rdx
  803119:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803120:	48 63 d0             	movslq %eax,%rdx
  803123:	49 89 d4             	mov    %rdx,%r12
  803126:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80312c:	48 63 d0             	movslq %eax,%rdx
  80312f:	49 89 d2             	mov    %rdx,%r10
  803132:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803138:	48 98                	cltq   
  80313a:	48 c1 e0 03          	shl    $0x3,%rax
  80313e:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803142:	b8 10 00 00 00       	mov    $0x10,%eax
  803147:	48 83 e8 01          	sub    $0x1,%rax
  80314b:	48 01 d0             	add    %rdx,%rax
  80314e:	be 10 00 00 00       	mov    $0x10,%esi
  803153:	ba 00 00 00 00       	mov    $0x0,%edx
  803158:	48 f7 f6             	div    %rsi
  80315b:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80315f:	48 29 c4             	sub    %rax,%rsp
  803162:	48 89 e0             	mov    %rsp,%rax
  803165:	48 83 c0 07          	add    $0x7,%rax
  803169:	48 c1 e8 03          	shr    $0x3,%rax
  80316d:	48 c1 e0 03          	shl    $0x3,%rax
  803171:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803178:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80317f:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803186:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803189:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80318f:	8d 50 01             	lea    0x1(%rax),%edx
  803192:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803199:	48 63 d2             	movslq %edx,%rdx
  80319c:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8031a3:	00 

	va_start(vl, arg0);
  8031a4:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8031ab:	00 00 00 
  8031ae:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8031b5:	00 00 00 
  8031b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031bc:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8031c3:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8031ca:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8031d1:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8031d8:	00 00 00 
  8031db:	eb 60                	jmp    80323d <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8031dd:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8031e3:	8d 48 01             	lea    0x1(%rax),%ecx
  8031e6:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8031ec:	83 f8 30             	cmp    $0x30,%eax
  8031ef:	73 23                	jae    803214 <spawnl+0x1fd>
  8031f1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8031f8:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8031fe:	89 d2                	mov    %edx,%edx
  803200:	48 01 d0             	add    %rdx,%rax
  803203:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803209:	83 c2 08             	add    $0x8,%edx
  80320c:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803212:	eb 12                	jmp    803226 <spawnl+0x20f>
  803214:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80321b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80321f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803226:	48 8b 10             	mov    (%rax),%rdx
  803229:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803230:	89 c9                	mov    %ecx,%ecx
  803232:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803236:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80323d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803243:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  803249:	72 92                	jb     8031dd <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80324b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803252:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803259:	48 89 d6             	mov    %rdx,%rsi
  80325c:	48 89 c7             	mov    %rax,%rdi
  80325f:	48 b8 bf 2c 80 00 00 	movabs $0x802cbf,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
  80326b:	48 89 dc             	mov    %rbx,%rsp
}
  80326e:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803272:	5b                   	pop    %rbx
  803273:	41 5c                	pop    %r12
  803275:	41 5d                	pop    %r13
  803277:	5d                   	pop    %rbp
  803278:	c3                   	retq   

0000000000803279 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803279:	55                   	push   %rbp
  80327a:	48 89 e5             	mov    %rsp,%rbp
  80327d:	48 83 ec 50          	sub    $0x50,%rsp
  803281:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803284:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803288:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80328c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803293:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803294:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80329b:	eb 33                	jmp    8032d0 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80329d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032a0:	48 98                	cltq   
  8032a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032a9:	00 
  8032aa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032ae:	48 01 d0             	add    %rdx,%rax
  8032b1:	48 8b 00             	mov    (%rax),%rax
  8032b4:	48 89 c7             	mov    %rax,%rdi
  8032b7:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	83 c0 01             	add    $0x1,%eax
  8032c6:	48 98                	cltq   
  8032c8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8032cc:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8032d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032d3:	48 98                	cltq   
  8032d5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032dc:	00 
  8032dd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032e1:	48 01 d0             	add    %rdx,%rax
  8032e4:	48 8b 00             	mov    (%rax),%rax
  8032e7:	48 85 c0             	test   %rax,%rax
  8032ea:	75 b1                	jne    80329d <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8032ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f0:	48 f7 d8             	neg    %rax
  8032f3:	48 05 00 10 40 00    	add    $0x401000,%rax
  8032f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8032fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803301:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803305:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803309:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80330d:	48 89 c2             	mov    %rax,%rdx
  803310:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803313:	83 c0 01             	add    $0x1,%eax
  803316:	c1 e0 03             	shl    $0x3,%eax
  803319:	48 98                	cltq   
  80331b:	48 f7 d8             	neg    %rax
  80331e:	48 01 d0             	add    %rdx,%rax
  803321:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803325:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803329:	48 83 e8 10          	sub    $0x10,%rax
  80332d:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803333:	77 0a                	ja     80333f <init_stack+0xc6>
		return -E_NO_MEM;
  803335:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80333a:	e9 e4 01 00 00       	jmpq   803523 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80333f:	ba 07 00 00 00       	mov    $0x7,%edx
  803344:	be 00 00 40 00       	mov    $0x400000,%esi
  803349:	bf 00 00 00 00       	mov    $0x0,%edi
  80334e:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
  80335a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803361:	79 08                	jns    80336b <init_stack+0xf2>
		return r;
  803363:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803366:	e9 b8 01 00 00       	jmpq   803523 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80336b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803372:	e9 8a 00 00 00       	jmpq   803401 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  803377:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80337a:	48 98                	cltq   
  80337c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803383:	00 
  803384:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803388:	48 01 d0             	add    %rdx,%rax
  80338b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803390:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803394:	48 01 ca             	add    %rcx,%rdx
  803397:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80339e:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  8033a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a4:	48 98                	cltq   
  8033a6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033ad:	00 
  8033ae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033b2:	48 01 d0             	add    %rdx,%rax
  8033b5:	48 8b 10             	mov    (%rax),%rdx
  8033b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033bc:	48 89 d6             	mov    %rdx,%rsi
  8033bf:	48 89 c7             	mov    %rax,%rdi
  8033c2:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8033ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033d1:	48 98                	cltq   
  8033d3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033da:	00 
  8033db:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033df:	48 01 d0             	add    %rdx,%rax
  8033e2:	48 8b 00             	mov    (%rax),%rax
  8033e5:	48 89 c7             	mov    %rax,%rdi
  8033e8:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	83 c0 01             	add    $0x1,%eax
  8033f7:	48 98                	cltq   
  8033f9:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8033fd:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803401:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803404:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803407:	0f 8c 6a ff ff ff    	jl     803377 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80340d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803410:	48 98                	cltq   
  803412:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803419:	00 
  80341a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80341e:	48 01 d0             	add    %rdx,%rax
  803421:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803428:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80342f:	00 
  803430:	74 35                	je     803467 <init_stack+0x1ee>
  803432:	48 b9 98 53 80 00 00 	movabs $0x805398,%rcx
  803439:	00 00 00 
  80343c:	48 ba be 53 80 00 00 	movabs $0x8053be,%rdx
  803443:	00 00 00 
  803446:	be f6 00 00 00       	mov    $0xf6,%esi
  80344b:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  803452:	00 00 00 
  803455:	b8 00 00 00 00       	mov    $0x0,%eax
  80345a:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  803461:	00 00 00 
  803464:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803467:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346b:	48 83 e8 08          	sub    $0x8,%rax
  80346f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803474:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803478:	48 01 ca             	add    %rcx,%rdx
  80347b:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803482:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  803485:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803489:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80348d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803490:	48 98                	cltq   
  803492:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803495:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80349a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80349e:	48 01 d0             	add    %rdx,%rax
  8034a1:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8034a7:	48 89 c2             	mov    %rax,%rdx
  8034aa:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8034ae:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8034b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8034b4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8034ba:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8034bf:	89 c2                	mov    %eax,%edx
  8034c1:	be 00 00 40 00       	mov    $0x400000,%esi
  8034c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8034cb:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
  8034d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034da:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034de:	78 26                	js     803506 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8034e0:	be 00 00 40 00       	mov    $0x400000,%esi
  8034e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ea:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034fd:	78 0a                	js     803509 <init_stack+0x290>
		goto error;

	return 0;
  8034ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803504:	eb 1d                	jmp    803523 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803506:	90                   	nop
  803507:	eb 01                	jmp    80350a <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803509:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80350a:	be 00 00 40 00       	mov    $0x400000,%esi
  80350f:	bf 00 00 00 00       	mov    $0x0,%edi
  803514:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
	return r;
  803520:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803523:	c9                   	leaveq 
  803524:	c3                   	retq   

0000000000803525 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803525:	55                   	push   %rbp
  803526:	48 89 e5             	mov    %rsp,%rbp
  803529:	48 83 ec 50          	sub    $0x50,%rsp
  80352d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803530:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803534:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803538:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80353b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80353f:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803543:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803547:	25 ff 0f 00 00       	and    $0xfff,%eax
  80354c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803553:	74 21                	je     803576 <map_segment+0x51>
		va -= i;
  803555:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803558:	48 98                	cltq   
  80355a:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80355e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803561:	48 98                	cltq   
  803563:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356a:	48 98                	cltq   
  80356c:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803573:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803576:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80357d:	e9 79 01 00 00       	jmpq   8036fb <map_segment+0x1d6>
		if (i >= filesz) {
  803582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803585:	48 98                	cltq   
  803587:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80358b:	72 3c                	jb     8035c9 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80358d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803590:	48 63 d0             	movslq %eax,%rdx
  803593:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803597:	48 01 d0             	add    %rdx,%rax
  80359a:	48 89 c1             	mov    %rax,%rcx
  80359d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035a0:	8b 55 10             	mov    0x10(%rbp),%edx
  8035a3:	48 89 ce             	mov    %rcx,%rsi
  8035a6:	89 c7                	mov    %eax,%edi
  8035a8:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8035af:	00 00 00 
  8035b2:	ff d0                	callq  *%rax
  8035b4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035bb:	0f 89 33 01 00 00    	jns    8036f4 <map_segment+0x1cf>
				return r;
  8035c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c4:	e9 46 01 00 00       	jmpq   80370f <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8035c9:	ba 07 00 00 00       	mov    $0x7,%edx
  8035ce:	be 00 00 40 00       	mov    $0x400000,%esi
  8035d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d8:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8035df:	00 00 00 
  8035e2:	ff d0                	callq  *%rax
  8035e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035eb:	79 08                	jns    8035f5 <map_segment+0xd0>
				return r;
  8035ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f0:	e9 1a 01 00 00       	jmpq   80370f <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8035f5:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8035f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fb:	01 c2                	add    %eax,%edx
  8035fd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803600:	89 d6                	mov    %edx,%esi
  803602:	89 c7                	mov    %eax,%edi
  803604:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
  803610:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803613:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803617:	79 08                	jns    803621 <map_segment+0xfc>
				return r;
  803619:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80361c:	e9 ee 00 00 00       	jmpq   80370f <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803621:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362b:	48 98                	cltq   
  80362d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803631:	48 29 c2             	sub    %rax,%rdx
  803634:	48 89 d0             	mov    %rdx,%rax
  803637:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80363b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80363e:	48 63 d0             	movslq %eax,%rdx
  803641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803645:	48 39 c2             	cmp    %rax,%rdx
  803648:	48 0f 47 d0          	cmova  %rax,%rdx
  80364c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80364f:	be 00 00 40 00       	mov    $0x400000,%esi
  803654:	89 c7                	mov    %eax,%edi
  803656:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  80365d:	00 00 00 
  803660:	ff d0                	callq  *%rax
  803662:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803665:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803669:	79 08                	jns    803673 <map_segment+0x14e>
				return r;
  80366b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80366e:	e9 9c 00 00 00       	jmpq   80370f <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803676:	48 63 d0             	movslq %eax,%rdx
  803679:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367d:	48 01 d0             	add    %rdx,%rax
  803680:	48 89 c2             	mov    %rax,%rdx
  803683:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803686:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80368a:	48 89 d1             	mov    %rdx,%rcx
  80368d:	89 c2                	mov    %eax,%edx
  80368f:	be 00 00 40 00       	mov    $0x400000,%esi
  803694:	bf 00 00 00 00       	mov    $0x0,%edi
  803699:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036ac:	79 30                	jns    8036de <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8036ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b1:	89 c1                	mov    %eax,%ecx
  8036b3:	48 ba d3 53 80 00 00 	movabs $0x8053d3,%rdx
  8036ba:	00 00 00 
  8036bd:	be 29 01 00 00       	mov    $0x129,%esi
  8036c2:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  8036c9:	00 00 00 
  8036cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d1:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  8036d8:	00 00 00 
  8036db:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8036de:	be 00 00 40 00       	mov    $0x400000,%esi
  8036e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e8:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8036f4:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8036fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fe:	48 98                	cltq   
  803700:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803704:	0f 82 78 fe ff ff    	jb     803582 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80370a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80370f:	c9                   	leaveq 
  803710:	c3                   	retq   

0000000000803711 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803711:	55                   	push   %rbp
  803712:	48 89 e5             	mov    %rsp,%rbp
  803715:	48 83 ec 30          	sub    $0x30,%rsp
  803719:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80371c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803723:	00 
  803724:	e9 eb 00 00 00       	jmpq   803814 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372d:	48 c1 f8 12          	sar    $0x12,%rax
  803731:	48 89 c2             	mov    %rax,%rdx
  803734:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80373b:	01 00 00 
  80373e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803742:	83 e0 01             	and    $0x1,%eax
  803745:	48 85 c0             	test   %rax,%rax
  803748:	74 21                	je     80376b <copy_shared_pages+0x5a>
  80374a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374e:	48 c1 f8 09          	sar    $0x9,%rax
  803752:	48 89 c2             	mov    %rax,%rdx
  803755:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80375c:	01 00 00 
  80375f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803763:	83 e0 01             	and    $0x1,%eax
  803766:	48 85 c0             	test   %rax,%rax
  803769:	75 0d                	jne    803778 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  80376b:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  803772:	00 
  803773:	e9 9c 00 00 00       	jmpq   803814 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  803778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377c:	48 05 00 02 00 00    	add    $0x200,%rax
  803782:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  803786:	eb 7e                	jmp    803806 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  803788:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80378f:	01 00 00 
  803792:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803796:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80379a:	25 01 04 00 00       	and    $0x401,%eax
  80379f:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  8037a5:	75 5a                	jne    803801 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  8037a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8037af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  8037b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037ba:	01 00 00 
  8037bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8037ca:	89 c6                	mov    %eax,%esi
  8037cc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8037d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d7:	41 89 f0             	mov    %esi,%r8d
  8037da:	48 89 c6             	mov    %rax,%rsi
  8037dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e2:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8037e9:	00 00 00 
  8037ec:	ff d0                	callq  *%rax
  8037ee:	48 98                	cltq   
  8037f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8037f4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8037f9:	79 06                	jns    803801 <copy_shared_pages+0xf0>
						return r;
  8037fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ff:	eb 28                	jmp    803829 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803801:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803806:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80380e:	0f 8c 74 ff ff ff    	jl     803788 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803818:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  80381e:	0f 86 05 ff ff ff    	jbe    803729 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803829:	c9                   	leaveq 
  80382a:	c3                   	retq   

000000000080382b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80382b:	55                   	push   %rbp
  80382c:	48 89 e5             	mov    %rsp,%rbp
  80382f:	48 83 ec 20          	sub    $0x20,%rsp
  803833:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803836:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80383a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80383d:	48 89 d6             	mov    %rdx,%rsi
  803840:	89 c7                	mov    %eax,%edi
  803842:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  803849:	00 00 00 
  80384c:	ff d0                	callq  *%rax
  80384e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803851:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803855:	79 05                	jns    80385c <fd2sockid+0x31>
		return r;
  803857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385a:	eb 24                	jmp    803880 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80385c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803860:	8b 10                	mov    (%rax),%edx
  803862:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803869:	00 00 00 
  80386c:	8b 00                	mov    (%rax),%eax
  80386e:	39 c2                	cmp    %eax,%edx
  803870:	74 07                	je     803879 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803872:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803877:	eb 07                	jmp    803880 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803880:	c9                   	leaveq 
  803881:	c3                   	retq   

0000000000803882 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803882:	55                   	push   %rbp
  803883:	48 89 e5             	mov    %rsp,%rbp
  803886:	48 83 ec 20          	sub    $0x20,%rsp
  80388a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80388d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803891:	48 89 c7             	mov    %rax,%rdi
  803894:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80389b:	00 00 00 
  80389e:	ff d0                	callq  *%rax
  8038a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a7:	78 26                	js     8038cf <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8038a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ad:	ba 07 04 00 00       	mov    $0x407,%edx
  8038b2:	48 89 c6             	mov    %rax,%rsi
  8038b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ba:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8038c1:	00 00 00 
  8038c4:	ff d0                	callq  *%rax
  8038c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038cd:	79 16                	jns    8038e5 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8038cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038d2:	89 c7                	mov    %eax,%edi
  8038d4:	48 b8 91 3d 80 00 00 	movabs $0x803d91,%rax
  8038db:	00 00 00 
  8038de:	ff d0                	callq  *%rax
		return r;
  8038e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e3:	eb 3a                	jmp    80391f <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8038e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e9:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8038f0:	00 00 00 
  8038f3:	8b 12                	mov    (%rdx),%edx
  8038f5:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8038f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803902:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803906:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803909:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80390c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803910:	48 89 c7             	mov    %rax,%rdi
  803913:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  80391a:	00 00 00 
  80391d:	ff d0                	callq  *%rax
}
  80391f:	c9                   	leaveq 
  803920:	c3                   	retq   

0000000000803921 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803921:	55                   	push   %rbp
  803922:	48 89 e5             	mov    %rsp,%rbp
  803925:	48 83 ec 30          	sub    $0x30,%rsp
  803929:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80392c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803930:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803934:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803937:	89 c7                	mov    %eax,%edi
  803939:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  803940:	00 00 00 
  803943:	ff d0                	callq  *%rax
  803945:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803948:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394c:	79 05                	jns    803953 <accept+0x32>
		return r;
  80394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803951:	eb 3b                	jmp    80398e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803953:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803957:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80395b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395e:	48 89 ce             	mov    %rcx,%rsi
  803961:	89 c7                	mov    %eax,%edi
  803963:	48 b8 6e 3c 80 00 00 	movabs $0x803c6e,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
  80396f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803976:	79 05                	jns    80397d <accept+0x5c>
		return r;
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	eb 11                	jmp    80398e <accept+0x6d>
	return alloc_sockfd(r);
  80397d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803980:	89 c7                	mov    %eax,%edi
  803982:	48 b8 82 38 80 00 00 	movabs $0x803882,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
}
  80398e:	c9                   	leaveq 
  80398f:	c3                   	retq   

0000000000803990 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803990:	55                   	push   %rbp
  803991:	48 89 e5             	mov    %rsp,%rbp
  803994:	48 83 ec 20          	sub    $0x20,%rsp
  803998:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80399b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80399f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039a5:	89 c7                	mov    %eax,%edi
  8039a7:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  8039ae:	00 00 00 
  8039b1:	ff d0                	callq  *%rax
  8039b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ba:	79 05                	jns    8039c1 <bind+0x31>
		return r;
  8039bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bf:	eb 1b                	jmp    8039dc <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8039c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039c4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cb:	48 89 ce             	mov    %rcx,%rsi
  8039ce:	89 c7                	mov    %eax,%edi
  8039d0:	48 b8 ed 3c 80 00 00 	movabs $0x803ced,%rax
  8039d7:	00 00 00 
  8039da:	ff d0                	callq  *%rax
}
  8039dc:	c9                   	leaveq 
  8039dd:	c3                   	retq   

00000000008039de <shutdown>:

int
shutdown(int s, int how)
{
  8039de:	55                   	push   %rbp
  8039df:	48 89 e5             	mov    %rsp,%rbp
  8039e2:	48 83 ec 20          	sub    $0x20,%rsp
  8039e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ef:	89 c7                	mov    %eax,%edi
  8039f1:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
  8039fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a04:	79 05                	jns    803a0b <shutdown+0x2d>
		return r;
  803a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a09:	eb 16                	jmp    803a21 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803a0b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a11:	89 d6                	mov    %edx,%esi
  803a13:	89 c7                	mov    %eax,%edi
  803a15:	48 b8 51 3d 80 00 00 	movabs $0x803d51,%rax
  803a1c:	00 00 00 
  803a1f:	ff d0                	callq  *%rax
}
  803a21:	c9                   	leaveq 
  803a22:	c3                   	retq   

0000000000803a23 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803a23:	55                   	push   %rbp
  803a24:	48 89 e5             	mov    %rsp,%rbp
  803a27:	48 83 ec 10          	sub    $0x10,%rsp
  803a2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803a2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a33:	48 89 c7             	mov    %rax,%rdi
  803a36:	48 b8 e4 4b 80 00 00 	movabs $0x804be4,%rax
  803a3d:	00 00 00 
  803a40:	ff d0                	callq  *%rax
  803a42:	83 f8 01             	cmp    $0x1,%eax
  803a45:	75 17                	jne    803a5e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803a47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4b:	8b 40 0c             	mov    0xc(%rax),%eax
  803a4e:	89 c7                	mov    %eax,%edi
  803a50:	48 b8 91 3d 80 00 00 	movabs $0x803d91,%rax
  803a57:	00 00 00 
  803a5a:	ff d0                	callq  *%rax
  803a5c:	eb 05                	jmp    803a63 <devsock_close+0x40>
	else
		return 0;
  803a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a63:	c9                   	leaveq 
  803a64:	c3                   	retq   

0000000000803a65 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a65:	55                   	push   %rbp
  803a66:	48 89 e5             	mov    %rsp,%rbp
  803a69:	48 83 ec 20          	sub    $0x20,%rsp
  803a6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a74:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7a:	89 c7                	mov    %eax,%edi
  803a7c:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  803a83:	00 00 00 
  803a86:	ff d0                	callq  *%rax
  803a88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a8f:	79 05                	jns    803a96 <connect+0x31>
		return r;
  803a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a94:	eb 1b                	jmp    803ab1 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a96:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a99:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa0:	48 89 ce             	mov    %rcx,%rsi
  803aa3:	89 c7                	mov    %eax,%edi
  803aa5:	48 b8 be 3d 80 00 00 	movabs $0x803dbe,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
}
  803ab1:	c9                   	leaveq 
  803ab2:	c3                   	retq   

0000000000803ab3 <listen>:

int
listen(int s, int backlog)
{
  803ab3:	55                   	push   %rbp
  803ab4:	48 89 e5             	mov    %rsp,%rbp
  803ab7:	48 83 ec 20          	sub    $0x20,%rsp
  803abb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803abe:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ac1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac4:	89 c7                	mov    %eax,%edi
  803ac6:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  803acd:	00 00 00 
  803ad0:	ff d0                	callq  *%rax
  803ad2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad9:	79 05                	jns    803ae0 <listen+0x2d>
		return r;
  803adb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ade:	eb 16                	jmp    803af6 <listen+0x43>
	return nsipc_listen(r, backlog);
  803ae0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae6:	89 d6                	mov    %edx,%esi
  803ae8:	89 c7                	mov    %eax,%edi
  803aea:	48 b8 22 3e 80 00 00 	movabs $0x803e22,%rax
  803af1:	00 00 00 
  803af4:	ff d0                	callq  *%rax
}
  803af6:	c9                   	leaveq 
  803af7:	c3                   	retq   

0000000000803af8 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803af8:	55                   	push   %rbp
  803af9:	48 89 e5             	mov    %rsp,%rbp
  803afc:	48 83 ec 20          	sub    $0x20,%rsp
  803b00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b08:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b10:	89 c2                	mov    %eax,%edx
  803b12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b16:	8b 40 0c             	mov    0xc(%rax),%eax
  803b19:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803b1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b22:	89 c7                	mov    %eax,%edi
  803b24:	48 b8 62 3e 80 00 00 	movabs $0x803e62,%rax
  803b2b:	00 00 00 
  803b2e:	ff d0                	callq  *%rax
}
  803b30:	c9                   	leaveq 
  803b31:	c3                   	retq   

0000000000803b32 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803b32:	55                   	push   %rbp
  803b33:	48 89 e5             	mov    %rsp,%rbp
  803b36:	48 83 ec 20          	sub    $0x20,%rsp
  803b3a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b42:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b4a:	89 c2                	mov    %eax,%edx
  803b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b50:	8b 40 0c             	mov    0xc(%rax),%eax
  803b53:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803b57:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b5c:	89 c7                	mov    %eax,%edi
  803b5e:	48 b8 2e 3f 80 00 00 	movabs $0x803f2e,%rax
  803b65:	00 00 00 
  803b68:	ff d0                	callq  *%rax
}
  803b6a:	c9                   	leaveq 
  803b6b:	c3                   	retq   

0000000000803b6c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803b6c:	55                   	push   %rbp
  803b6d:	48 89 e5             	mov    %rsp,%rbp
  803b70:	48 83 ec 10          	sub    $0x10,%rsp
  803b74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803b7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b80:	48 be f5 53 80 00 00 	movabs $0x8053f5,%rsi
  803b87:	00 00 00 
  803b8a:	48 89 c7             	mov    %rax,%rdi
  803b8d:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  803b94:	00 00 00 
  803b97:	ff d0                	callq  *%rax
	return 0;
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b9e:	c9                   	leaveq 
  803b9f:	c3                   	retq   

0000000000803ba0 <socket>:

int
socket(int domain, int type, int protocol)
{
  803ba0:	55                   	push   %rbp
  803ba1:	48 89 e5             	mov    %rsp,%rbp
  803ba4:	48 83 ec 20          	sub    $0x20,%rsp
  803ba8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bab:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803bae:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803bb1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803bb4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803bb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bba:	89 ce                	mov    %ecx,%esi
  803bbc:	89 c7                	mov    %eax,%edi
  803bbe:	48 b8 e6 3f 80 00 00 	movabs $0x803fe6,%rax
  803bc5:	00 00 00 
  803bc8:	ff d0                	callq  *%rax
  803bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd1:	79 05                	jns    803bd8 <socket+0x38>
		return r;
  803bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd6:	eb 11                	jmp    803be9 <socket+0x49>
	return alloc_sockfd(r);
  803bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bdb:	89 c7                	mov    %eax,%edi
  803bdd:	48 b8 82 38 80 00 00 	movabs $0x803882,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
}
  803be9:	c9                   	leaveq 
  803bea:	c3                   	retq   

0000000000803beb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803beb:	55                   	push   %rbp
  803bec:	48 89 e5             	mov    %rsp,%rbp
  803bef:	48 83 ec 10          	sub    $0x10,%rsp
  803bf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803bf6:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803bfd:	00 00 00 
  803c00:	8b 00                	mov    (%rax),%eax
  803c02:	85 c0                	test   %eax,%eax
  803c04:	75 1f                	jne    803c25 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803c06:	bf 02 00 00 00       	mov    $0x2,%edi
  803c0b:	48 b8 73 4b 80 00 00 	movabs $0x804b73,%rax
  803c12:	00 00 00 
  803c15:	ff d0                	callq  *%rax
  803c17:	89 c2                	mov    %eax,%edx
  803c19:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803c20:	00 00 00 
  803c23:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803c25:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803c2c:	00 00 00 
  803c2f:	8b 00                	mov    (%rax),%eax
  803c31:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803c34:	b9 07 00 00 00       	mov    $0x7,%ecx
  803c39:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803c40:	00 00 00 
  803c43:	89 c7                	mov    %eax,%edi
  803c45:	48 b8 67 49 80 00 00 	movabs $0x804967,%rax
  803c4c:	00 00 00 
  803c4f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803c51:	ba 00 00 00 00       	mov    $0x0,%edx
  803c56:	be 00 00 00 00       	mov    $0x0,%esi
  803c5b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c60:	48 b8 a6 48 80 00 00 	movabs $0x8048a6,%rax
  803c67:	00 00 00 
  803c6a:	ff d0                	callq  *%rax
}
  803c6c:	c9                   	leaveq 
  803c6d:	c3                   	retq   

0000000000803c6e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c6e:	55                   	push   %rbp
  803c6f:	48 89 e5             	mov    %rsp,%rbp
  803c72:	48 83 ec 30          	sub    $0x30,%rsp
  803c76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c7d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803c81:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c88:	00 00 00 
  803c8b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c8e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c90:	bf 01 00 00 00       	mov    $0x1,%edi
  803c95:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803c9c:	00 00 00 
  803c9f:	ff d0                	callq  *%rax
  803ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca8:	78 3e                	js     803ce8 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803caa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb1:	00 00 00 
  803cb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbc:	8b 40 10             	mov    0x10(%rax),%eax
  803cbf:	89 c2                	mov    %eax,%edx
  803cc1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803cc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cc9:	48 89 ce             	mov    %rcx,%rsi
  803ccc:	48 89 c7             	mov    %rax,%rdi
  803ccf:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803cd6:	00 00 00 
  803cd9:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdf:	8b 50 10             	mov    0x10(%rax),%edx
  803ce2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce6:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ceb:	c9                   	leaveq 
  803cec:	c3                   	retq   

0000000000803ced <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ced:	55                   	push   %rbp
  803cee:	48 89 e5             	mov    %rsp,%rbp
  803cf1:	48 83 ec 10          	sub    $0x10,%rsp
  803cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cfc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803cff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d06:	00 00 00 
  803d09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d0c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803d0e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d15:	48 89 c6             	mov    %rax,%rsi
  803d18:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d1f:	00 00 00 
  803d22:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803d2e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d35:	00 00 00 
  803d38:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d3b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803d3e:	bf 02 00 00 00       	mov    $0x2,%edi
  803d43:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803d4a:	00 00 00 
  803d4d:	ff d0                	callq  *%rax
}
  803d4f:	c9                   	leaveq 
  803d50:	c3                   	retq   

0000000000803d51 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803d51:	55                   	push   %rbp
  803d52:	48 89 e5             	mov    %rsp,%rbp
  803d55:	48 83 ec 10          	sub    $0x10,%rsp
  803d59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d5c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803d5f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d66:	00 00 00 
  803d69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d6c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803d6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d75:	00 00 00 
  803d78:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d7b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803d7e:	bf 03 00 00 00       	mov    $0x3,%edi
  803d83:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
}
  803d8f:	c9                   	leaveq 
  803d90:	c3                   	retq   

0000000000803d91 <nsipc_close>:

int
nsipc_close(int s)
{
  803d91:	55                   	push   %rbp
  803d92:	48 89 e5             	mov    %rsp,%rbp
  803d95:	48 83 ec 10          	sub    $0x10,%rsp
  803d99:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d9c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da3:	00 00 00 
  803da6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803da9:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803dab:	bf 04 00 00 00       	mov    $0x4,%edi
  803db0:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803db7:	00 00 00 
  803dba:	ff d0                	callq  *%rax
}
  803dbc:	c9                   	leaveq 
  803dbd:	c3                   	retq   

0000000000803dbe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803dbe:	55                   	push   %rbp
  803dbf:	48 89 e5             	mov    %rsp,%rbp
  803dc2:	48 83 ec 10          	sub    $0x10,%rsp
  803dc6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dc9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803dcd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803dd0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dd7:	00 00 00 
  803dda:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ddd:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ddf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de6:	48 89 c6             	mov    %rax,%rsi
  803de9:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803df0:	00 00 00 
  803df3:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803dfa:	00 00 00 
  803dfd:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803dff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e06:	00 00 00 
  803e09:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e0c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803e0f:	bf 05 00 00 00       	mov    $0x5,%edi
  803e14:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803e1b:	00 00 00 
  803e1e:	ff d0                	callq  *%rax
}
  803e20:	c9                   	leaveq 
  803e21:	c3                   	retq   

0000000000803e22 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803e22:	55                   	push   %rbp
  803e23:	48 89 e5             	mov    %rsp,%rbp
  803e26:	48 83 ec 10          	sub    $0x10,%rsp
  803e2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e2d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803e30:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e37:	00 00 00 
  803e3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e3d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803e3f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e46:	00 00 00 
  803e49:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e4c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803e4f:	bf 06 00 00 00       	mov    $0x6,%edi
  803e54:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
}
  803e60:	c9                   	leaveq 
  803e61:	c3                   	retq   

0000000000803e62 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803e62:	55                   	push   %rbp
  803e63:	48 89 e5             	mov    %rsp,%rbp
  803e66:	48 83 ec 30          	sub    $0x30,%rsp
  803e6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e71:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803e74:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803e77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e7e:	00 00 00 
  803e81:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e84:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803e86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e8d:	00 00 00 
  803e90:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e93:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e96:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e9d:	00 00 00 
  803ea0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ea3:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ea6:	bf 07 00 00 00       	mov    $0x7,%edi
  803eab:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803eb2:	00 00 00 
  803eb5:	ff d0                	callq  *%rax
  803eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebe:	78 69                	js     803f29 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803ec0:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ec7:	7f 08                	jg     803ed1 <nsipc_recv+0x6f>
  803ec9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ecc:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803ecf:	7e 35                	jle    803f06 <nsipc_recv+0xa4>
  803ed1:	48 b9 fc 53 80 00 00 	movabs $0x8053fc,%rcx
  803ed8:	00 00 00 
  803edb:	48 ba 11 54 80 00 00 	movabs $0x805411,%rdx
  803ee2:	00 00 00 
  803ee5:	be 62 00 00 00       	mov    $0x62,%esi
  803eea:	48 bf 26 54 80 00 00 	movabs $0x805426,%rdi
  803ef1:	00 00 00 
  803ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef9:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  803f00:	00 00 00 
  803f03:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803f06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f09:	48 63 d0             	movslq %eax,%rdx
  803f0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f10:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803f17:	00 00 00 
  803f1a:	48 89 c7             	mov    %rax,%rdi
  803f1d:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803f24:	00 00 00 
  803f27:	ff d0                	callq  *%rax
	}

	return r;
  803f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f2c:	c9                   	leaveq 
  803f2d:	c3                   	retq   

0000000000803f2e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803f2e:	55                   	push   %rbp
  803f2f:	48 89 e5             	mov    %rsp,%rbp
  803f32:	48 83 ec 20          	sub    $0x20,%rsp
  803f36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f3d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803f40:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803f43:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f4a:	00 00 00 
  803f4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f50:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803f52:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803f59:	7e 35                	jle    803f90 <nsipc_send+0x62>
  803f5b:	48 b9 32 54 80 00 00 	movabs $0x805432,%rcx
  803f62:	00 00 00 
  803f65:	48 ba 11 54 80 00 00 	movabs $0x805411,%rdx
  803f6c:	00 00 00 
  803f6f:	be 6d 00 00 00       	mov    $0x6d,%esi
  803f74:	48 bf 26 54 80 00 00 	movabs $0x805426,%rdi
  803f7b:	00 00 00 
  803f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f83:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  803f8a:	00 00 00 
  803f8d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f93:	48 63 d0             	movslq %eax,%rdx
  803f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f9a:	48 89 c6             	mov    %rax,%rsi
  803f9d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803fa4:	00 00 00 
  803fa7:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  803fae:	00 00 00 
  803fb1:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803fb3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fba:	00 00 00 
  803fbd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fc0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803fc3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fca:	00 00 00 
  803fcd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fd0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803fd3:	bf 08 00 00 00       	mov    $0x8,%edi
  803fd8:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  803fdf:	00 00 00 
  803fe2:	ff d0                	callq  *%rax
}
  803fe4:	c9                   	leaveq 
  803fe5:	c3                   	retq   

0000000000803fe6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803fe6:	55                   	push   %rbp
  803fe7:	48 89 e5             	mov    %rsp,%rbp
  803fea:	48 83 ec 10          	sub    $0x10,%rsp
  803fee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ff1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ff4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ff7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ffe:	00 00 00 
  804001:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804004:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804006:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80400d:	00 00 00 
  804010:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804013:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804016:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80401d:	00 00 00 
  804020:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804023:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804026:	bf 09 00 00 00       	mov    $0x9,%edi
  80402b:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  804032:	00 00 00 
  804035:	ff d0                	callq  *%rax
}
  804037:	c9                   	leaveq 
  804038:	c3                   	retq   

0000000000804039 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804039:	55                   	push   %rbp
  80403a:	48 89 e5             	mov    %rsp,%rbp
  80403d:	53                   	push   %rbx
  80403e:	48 83 ec 38          	sub    $0x38,%rsp
  804042:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804046:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80404a:	48 89 c7             	mov    %rax,%rdi
  80404d:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  804054:	00 00 00 
  804057:	ff d0                	callq  *%rax
  804059:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80405c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804060:	0f 88 bf 01 00 00    	js     804225 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804066:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80406a:	ba 07 04 00 00       	mov    $0x407,%edx
  80406f:	48 89 c6             	mov    %rax,%rsi
  804072:	bf 00 00 00 00       	mov    $0x0,%edi
  804077:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  80407e:	00 00 00 
  804081:	ff d0                	callq  *%rax
  804083:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804086:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80408a:	0f 88 95 01 00 00    	js     804225 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804090:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804094:	48 89 c7             	mov    %rax,%rdi
  804097:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80409e:	00 00 00 
  8040a1:	ff d0                	callq  *%rax
  8040a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040aa:	0f 88 5d 01 00 00    	js     80420d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8040b9:	48 89 c6             	mov    %rax,%rsi
  8040bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c1:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040d4:	0f 88 33 01 00 00    	js     80420d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8040da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040de:	48 89 c7             	mov    %rax,%rdi
  8040e1:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
  8040ed:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040f5:	ba 07 04 00 00       	mov    $0x407,%edx
  8040fa:	48 89 c6             	mov    %rax,%rsi
  8040fd:	bf 00 00 00 00       	mov    $0x0,%edi
  804102:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  804109:	00 00 00 
  80410c:	ff d0                	callq  *%rax
  80410e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804111:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804115:	0f 88 d9 00 00 00    	js     8041f4 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80411b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80411f:	48 89 c7             	mov    %rax,%rdi
  804122:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  804129:	00 00 00 
  80412c:	ff d0                	callq  *%rax
  80412e:	48 89 c2             	mov    %rax,%rdx
  804131:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804135:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80413b:	48 89 d1             	mov    %rdx,%rcx
  80413e:	ba 00 00 00 00       	mov    $0x0,%edx
  804143:	48 89 c6             	mov    %rax,%rsi
  804146:	bf 00 00 00 00       	mov    $0x0,%edi
  80414b:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  804152:	00 00 00 
  804155:	ff d0                	callq  *%rax
  804157:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80415a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80415e:	78 79                	js     8041d9 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804164:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80416b:	00 00 00 
  80416e:	8b 12                	mov    (%rdx),%edx
  804170:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804176:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80417d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804181:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804188:	00 00 00 
  80418b:	8b 12                	mov    (%rdx),%edx
  80418d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80418f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804193:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80419a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419e:	48 89 c7             	mov    %rax,%rdi
  8041a1:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  8041a8:	00 00 00 
  8041ab:	ff d0                	callq  *%rax
  8041ad:	89 c2                	mov    %eax,%edx
  8041af:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041b3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8041b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041b9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8041bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041c1:	48 89 c7             	mov    %rax,%rdi
  8041c4:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  8041cb:	00 00 00 
  8041ce:	ff d0                	callq  *%rax
  8041d0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8041d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d7:	eb 4f                	jmp    804228 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8041d9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8041da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041de:	48 89 c6             	mov    %rax,%rsi
  8041e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8041e6:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8041ed:	00 00 00 
  8041f0:	ff d0                	callq  *%rax
  8041f2:	eb 01                	jmp    8041f5 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8041f4:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8041f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041f9:	48 89 c6             	mov    %rax,%rsi
  8041fc:	bf 00 00 00 00       	mov    $0x0,%edi
  804201:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  804208:	00 00 00 
  80420b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80420d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804211:	48 89 c6             	mov    %rax,%rsi
  804214:	bf 00 00 00 00       	mov    $0x0,%edi
  804219:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  804220:	00 00 00 
  804223:	ff d0                	callq  *%rax
err:
	return r;
  804225:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804228:	48 83 c4 38          	add    $0x38,%rsp
  80422c:	5b                   	pop    %rbx
  80422d:	5d                   	pop    %rbp
  80422e:	c3                   	retq   

000000000080422f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80422f:	55                   	push   %rbp
  804230:	48 89 e5             	mov    %rsp,%rbp
  804233:	53                   	push   %rbx
  804234:	48 83 ec 28          	sub    $0x28,%rsp
  804238:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80423c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804240:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804247:	00 00 00 
  80424a:	48 8b 00             	mov    (%rax),%rax
  80424d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804253:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804256:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80425a:	48 89 c7             	mov    %rax,%rdi
  80425d:	48 b8 e4 4b 80 00 00 	movabs $0x804be4,%rax
  804264:	00 00 00 
  804267:	ff d0                	callq  *%rax
  804269:	89 c3                	mov    %eax,%ebx
  80426b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80426f:	48 89 c7             	mov    %rax,%rdi
  804272:	48 b8 e4 4b 80 00 00 	movabs $0x804be4,%rax
  804279:	00 00 00 
  80427c:	ff d0                	callq  *%rax
  80427e:	39 c3                	cmp    %eax,%ebx
  804280:	0f 94 c0             	sete   %al
  804283:	0f b6 c0             	movzbl %al,%eax
  804286:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804289:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804290:	00 00 00 
  804293:	48 8b 00             	mov    (%rax),%rax
  804296:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80429c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80429f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042a2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8042a5:	75 05                	jne    8042ac <_pipeisclosed+0x7d>
			return ret;
  8042a7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8042aa:	eb 4a                	jmp    8042f6 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8042ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042af:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8042b2:	74 8c                	je     804240 <_pipeisclosed+0x11>
  8042b4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8042b8:	75 86                	jne    804240 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8042ba:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8042c1:	00 00 00 
  8042c4:	48 8b 00             	mov    (%rax),%rax
  8042c7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8042cd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8042d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042d3:	89 c6                	mov    %eax,%esi
  8042d5:	48 bf 43 54 80 00 00 	movabs $0x805443,%rdi
  8042dc:	00 00 00 
  8042df:	b8 00 00 00 00       	mov    $0x0,%eax
  8042e4:	49 b8 ca 03 80 00 00 	movabs $0x8003ca,%r8
  8042eb:	00 00 00 
  8042ee:	41 ff d0             	callq  *%r8
	}
  8042f1:	e9 4a ff ff ff       	jmpq   804240 <_pipeisclosed+0x11>

}
  8042f6:	48 83 c4 28          	add    $0x28,%rsp
  8042fa:	5b                   	pop    %rbx
  8042fb:	5d                   	pop    %rbp
  8042fc:	c3                   	retq   

00000000008042fd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8042fd:	55                   	push   %rbp
  8042fe:	48 89 e5             	mov    %rsp,%rbp
  804301:	48 83 ec 30          	sub    $0x30,%rsp
  804305:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804308:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80430c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80430f:	48 89 d6             	mov    %rdx,%rsi
  804312:	89 c7                	mov    %eax,%edi
  804314:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  80431b:	00 00 00 
  80431e:	ff d0                	callq  *%rax
  804320:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804327:	79 05                	jns    80432e <pipeisclosed+0x31>
		return r;
  804329:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432c:	eb 31                	jmp    80435f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80432e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804332:	48 89 c7             	mov    %rax,%rdi
  804335:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  80433c:	00 00 00 
  80433f:	ff d0                	callq  *%rax
  804341:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804349:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80434d:	48 89 d6             	mov    %rdx,%rsi
  804350:	48 89 c7             	mov    %rax,%rdi
  804353:	48 b8 2f 42 80 00 00 	movabs $0x80422f,%rax
  80435a:	00 00 00 
  80435d:	ff d0                	callq  *%rax
}
  80435f:	c9                   	leaveq 
  804360:	c3                   	retq   

0000000000804361 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804361:	55                   	push   %rbp
  804362:	48 89 e5             	mov    %rsp,%rbp
  804365:	48 83 ec 40          	sub    $0x40,%rsp
  804369:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80436d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804371:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804379:	48 89 c7             	mov    %rax,%rdi
  80437c:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  804383:	00 00 00 
  804386:	ff d0                	callq  *%rax
  804388:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80438c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804390:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804394:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80439b:	00 
  80439c:	e9 90 00 00 00       	jmpq   804431 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8043a1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8043a6:	74 09                	je     8043b1 <devpipe_read+0x50>
				return i;
  8043a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ac:	e9 8e 00 00 00       	jmpq   80443f <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8043b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043b9:	48 89 d6             	mov    %rdx,%rsi
  8043bc:	48 89 c7             	mov    %rax,%rdi
  8043bf:	48 b8 2f 42 80 00 00 	movabs $0x80422f,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
  8043cb:	85 c0                	test   %eax,%eax
  8043cd:	74 07                	je     8043d6 <devpipe_read+0x75>
				return 0;
  8043cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d4:	eb 69                	jmp    80443f <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8043d6:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  8043dd:	00 00 00 
  8043e0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8043e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e6:	8b 10                	mov    (%rax),%edx
  8043e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ec:	8b 40 04             	mov    0x4(%rax),%eax
  8043ef:	39 c2                	cmp    %eax,%edx
  8043f1:	74 ae                	je     8043a1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8043f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043fb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8043ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804403:	8b 00                	mov    (%rax),%eax
  804405:	99                   	cltd   
  804406:	c1 ea 1b             	shr    $0x1b,%edx
  804409:	01 d0                	add    %edx,%eax
  80440b:	83 e0 1f             	and    $0x1f,%eax
  80440e:	29 d0                	sub    %edx,%eax
  804410:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804414:	48 98                	cltq   
  804416:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80441b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80441d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804421:	8b 00                	mov    (%rax),%eax
  804423:	8d 50 01             	lea    0x1(%rax),%edx
  804426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80442c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804435:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804439:	72 a7                	jb     8043e2 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80443b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80443f:	c9                   	leaveq 
  804440:	c3                   	retq   

0000000000804441 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804441:	55                   	push   %rbp
  804442:	48 89 e5             	mov    %rsp,%rbp
  804445:	48 83 ec 40          	sub    $0x40,%rsp
  804449:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80444d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804451:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804459:	48 89 c7             	mov    %rax,%rdi
  80445c:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  804463:	00 00 00 
  804466:	ff d0                	callq  *%rax
  804468:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80446c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804470:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804474:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80447b:	00 
  80447c:	e9 8f 00 00 00       	jmpq   804510 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804481:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804489:	48 89 d6             	mov    %rdx,%rsi
  80448c:	48 89 c7             	mov    %rax,%rdi
  80448f:	48 b8 2f 42 80 00 00 	movabs $0x80422f,%rax
  804496:	00 00 00 
  804499:	ff d0                	callq  *%rax
  80449b:	85 c0                	test   %eax,%eax
  80449d:	74 07                	je     8044a6 <devpipe_write+0x65>
				return 0;
  80449f:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a4:	eb 78                	jmp    80451e <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8044a6:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  8044ad:	00 00 00 
  8044b0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8044b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b6:	8b 40 04             	mov    0x4(%rax),%eax
  8044b9:	48 63 d0             	movslq %eax,%rdx
  8044bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c0:	8b 00                	mov    (%rax),%eax
  8044c2:	48 98                	cltq   
  8044c4:	48 83 c0 20          	add    $0x20,%rax
  8044c8:	48 39 c2             	cmp    %rax,%rdx
  8044cb:	73 b4                	jae    804481 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8044cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d1:	8b 40 04             	mov    0x4(%rax),%eax
  8044d4:	99                   	cltd   
  8044d5:	c1 ea 1b             	shr    $0x1b,%edx
  8044d8:	01 d0                	add    %edx,%eax
  8044da:	83 e0 1f             	and    $0x1f,%eax
  8044dd:	29 d0                	sub    %edx,%eax
  8044df:	89 c6                	mov    %eax,%esi
  8044e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044e9:	48 01 d0             	add    %rdx,%rax
  8044ec:	0f b6 08             	movzbl (%rax),%ecx
  8044ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044f3:	48 63 c6             	movslq %esi,%rax
  8044f6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8044fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fe:	8b 40 04             	mov    0x4(%rax),%eax
  804501:	8d 50 01             	lea    0x1(%rax),%edx
  804504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804508:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80450b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804514:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804518:	72 98                	jb     8044b2 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80451a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80451e:	c9                   	leaveq 
  80451f:	c3                   	retq   

0000000000804520 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804520:	55                   	push   %rbp
  804521:	48 89 e5             	mov    %rsp,%rbp
  804524:	48 83 ec 20          	sub    $0x20,%rsp
  804528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80452c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804534:	48 89 c7             	mov    %rax,%rdi
  804537:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  80453e:	00 00 00 
  804541:	ff d0                	callq  *%rax
  804543:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804547:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80454b:	48 be 56 54 80 00 00 	movabs $0x805456,%rsi
  804552:	00 00 00 
  804555:	48 89 c7             	mov    %rax,%rdi
  804558:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  80455f:	00 00 00 
  804562:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804568:	8b 50 04             	mov    0x4(%rax),%edx
  80456b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456f:	8b 00                	mov    (%rax),%eax
  804571:	29 c2                	sub    %eax,%edx
  804573:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804577:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80457d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804581:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804588:	00 00 00 
	stat->st_dev = &devpipe;
  80458b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80458f:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804596:	00 00 00 
  804599:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8045a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045a5:	c9                   	leaveq 
  8045a6:	c3                   	retq   

00000000008045a7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8045a7:	55                   	push   %rbp
  8045a8:	48 89 e5             	mov    %rsp,%rbp
  8045ab:	48 83 ec 10          	sub    $0x10,%rsp
  8045af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8045b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045b7:	48 89 c6             	mov    %rax,%rsi
  8045ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8045bf:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8045c6:	00 00 00 
  8045c9:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8045cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045cf:	48 89 c7             	mov    %rax,%rdi
  8045d2:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  8045d9:	00 00 00 
  8045dc:	ff d0                	callq  *%rax
  8045de:	48 89 c6             	mov    %rax,%rsi
  8045e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8045e6:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8045ed:	00 00 00 
  8045f0:	ff d0                	callq  *%rax
}
  8045f2:	c9                   	leaveq 
  8045f3:	c3                   	retq   

00000000008045f4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8045f4:	55                   	push   %rbp
  8045f5:	48 89 e5             	mov    %rsp,%rbp
  8045f8:	48 83 ec 20          	sub    $0x20,%rsp
  8045fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8045ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804602:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804605:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804609:	be 01 00 00 00       	mov    $0x1,%esi
  80460e:	48 89 c7             	mov    %rax,%rdi
  804611:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  804618:	00 00 00 
  80461b:	ff d0                	callq  *%rax
}
  80461d:	90                   	nop
  80461e:	c9                   	leaveq 
  80461f:	c3                   	retq   

0000000000804620 <getchar>:

int
getchar(void)
{
  804620:	55                   	push   %rbp
  804621:	48 89 e5             	mov    %rsp,%rbp
  804624:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804628:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80462c:	ba 01 00 00 00       	mov    $0x1,%edx
  804631:	48 89 c6             	mov    %rax,%rsi
  804634:	bf 00 00 00 00       	mov    $0x0,%edi
  804639:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  804640:	00 00 00 
  804643:	ff d0                	callq  *%rax
  804645:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804648:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80464c:	79 05                	jns    804653 <getchar+0x33>
		return r;
  80464e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804651:	eb 14                	jmp    804667 <getchar+0x47>
	if (r < 1)
  804653:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804657:	7f 07                	jg     804660 <getchar+0x40>
		return -E_EOF;
  804659:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80465e:	eb 07                	jmp    804667 <getchar+0x47>
	return c;
  804660:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804664:	0f b6 c0             	movzbl %al,%eax

}
  804667:	c9                   	leaveq 
  804668:	c3                   	retq   

0000000000804669 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804669:	55                   	push   %rbp
  80466a:	48 89 e5             	mov    %rsp,%rbp
  80466d:	48 83 ec 20          	sub    $0x20,%rsp
  804671:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804674:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804678:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80467b:	48 89 d6             	mov    %rdx,%rsi
  80467e:	89 c7                	mov    %eax,%edi
  804680:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  804687:	00 00 00 
  80468a:	ff d0                	callq  *%rax
  80468c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80468f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804693:	79 05                	jns    80469a <iscons+0x31>
		return r;
  804695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804698:	eb 1a                	jmp    8046b4 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80469a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80469e:	8b 10                	mov    (%rax),%edx
  8046a0:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8046a7:	00 00 00 
  8046aa:	8b 00                	mov    (%rax),%eax
  8046ac:	39 c2                	cmp    %eax,%edx
  8046ae:	0f 94 c0             	sete   %al
  8046b1:	0f b6 c0             	movzbl %al,%eax
}
  8046b4:	c9                   	leaveq 
  8046b5:	c3                   	retq   

00000000008046b6 <opencons>:

int
opencons(void)
{
  8046b6:	55                   	push   %rbp
  8046b7:	48 89 e5             	mov    %rsp,%rbp
  8046ba:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8046be:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8046c2:	48 89 c7             	mov    %rax,%rdi
  8046c5:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  8046cc:	00 00 00 
  8046cf:	ff d0                	callq  *%rax
  8046d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d8:	79 05                	jns    8046df <opencons+0x29>
		return r;
  8046da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046dd:	eb 5b                	jmp    80473a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8046df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8046e8:	48 89 c6             	mov    %rax,%rsi
  8046eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8046f0:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  8046f7:	00 00 00 
  8046fa:	ff d0                	callq  *%rax
  8046fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804703:	79 05                	jns    80470a <opencons+0x54>
		return r;
  804705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804708:	eb 30                	jmp    80473a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80470a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80470e:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804715:	00 00 00 
  804718:	8b 12                	mov    (%rdx),%edx
  80471a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80471c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804720:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472b:	48 89 c7             	mov    %rax,%rdi
  80472e:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  804735:	00 00 00 
  804738:	ff d0                	callq  *%rax
}
  80473a:	c9                   	leaveq 
  80473b:	c3                   	retq   

000000000080473c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80473c:	55                   	push   %rbp
  80473d:	48 89 e5             	mov    %rsp,%rbp
  804740:	48 83 ec 30          	sub    $0x30,%rsp
  804744:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804748:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80474c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804750:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804755:	75 13                	jne    80476a <devcons_read+0x2e>
		return 0;
  804757:	b8 00 00 00 00       	mov    $0x0,%eax
  80475c:	eb 49                	jmp    8047a7 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80475e:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  804765:	00 00 00 
  804768:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80476a:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  804771:	00 00 00 
  804774:	ff d0                	callq  *%rax
  804776:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804779:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80477d:	74 df                	je     80475e <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80477f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804783:	79 05                	jns    80478a <devcons_read+0x4e>
		return c;
  804785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804788:	eb 1d                	jmp    8047a7 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80478a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80478e:	75 07                	jne    804797 <devcons_read+0x5b>
		return 0;
  804790:	b8 00 00 00 00       	mov    $0x0,%eax
  804795:	eb 10                	jmp    8047a7 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804797:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80479a:	89 c2                	mov    %eax,%edx
  80479c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047a0:	88 10                	mov    %dl,(%rax)
	return 1;
  8047a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8047a7:	c9                   	leaveq 
  8047a8:	c3                   	retq   

00000000008047a9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8047a9:	55                   	push   %rbp
  8047aa:	48 89 e5             	mov    %rsp,%rbp
  8047ad:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8047b4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8047bb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8047c2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8047c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8047d0:	eb 76                	jmp    804848 <devcons_write+0x9f>
		m = n - tot;
  8047d2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8047d9:	89 c2                	mov    %eax,%edx
  8047db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047de:	29 c2                	sub    %eax,%edx
  8047e0:	89 d0                	mov    %edx,%eax
  8047e2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8047e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047e8:	83 f8 7f             	cmp    $0x7f,%eax
  8047eb:	76 07                	jbe    8047f4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8047ed:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8047f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047f7:	48 63 d0             	movslq %eax,%rdx
  8047fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047fd:	48 63 c8             	movslq %eax,%rcx
  804800:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804807:	48 01 c1             	add    %rax,%rcx
  80480a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804811:	48 89 ce             	mov    %rcx,%rsi
  804814:	48 89 c7             	mov    %rax,%rdi
  804817:	48 b8 7f 12 80 00 00 	movabs $0x80127f,%rax
  80481e:	00 00 00 
  804821:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804823:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804826:	48 63 d0             	movslq %eax,%rdx
  804829:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804830:	48 89 d6             	mov    %rdx,%rsi
  804833:	48 89 c7             	mov    %rax,%rdi
  804836:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  80483d:	00 00 00 
  804840:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804842:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804845:	01 45 fc             	add    %eax,-0x4(%rbp)
  804848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484b:	48 98                	cltq   
  80484d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804854:	0f 82 78 ff ff ff    	jb     8047d2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80485a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80485d:	c9                   	leaveq 
  80485e:	c3                   	retq   

000000000080485f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80485f:	55                   	push   %rbp
  804860:	48 89 e5             	mov    %rsp,%rbp
  804863:	48 83 ec 08          	sub    $0x8,%rsp
  804867:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80486b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804870:	c9                   	leaveq 
  804871:	c3                   	retq   

0000000000804872 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804872:	55                   	push   %rbp
  804873:	48 89 e5             	mov    %rsp,%rbp
  804876:	48 83 ec 10          	sub    $0x10,%rsp
  80487a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80487e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804886:	48 be 62 54 80 00 00 	movabs $0x805462,%rsi
  80488d:	00 00 00 
  804890:	48 89 c7             	mov    %rax,%rdi
  804893:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  80489a:	00 00 00 
  80489d:	ff d0                	callq  *%rax
	return 0;
  80489f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048a4:	c9                   	leaveq 
  8048a5:	c3                   	retq   

00000000008048a6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8048a6:	55                   	push   %rbp
  8048a7:	48 89 e5             	mov    %rsp,%rbp
  8048aa:	48 83 ec 30          	sub    $0x30,%rsp
  8048ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8048ba:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8048bf:	75 0e                	jne    8048cf <ipc_recv+0x29>
		pg = (void*) UTOP;
  8048c1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048c8:	00 00 00 
  8048cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8048cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048d3:	48 89 c7             	mov    %rax,%rdi
  8048d6:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  8048dd:	00 00 00 
  8048e0:	ff d0                	callq  *%rax
  8048e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048e9:	79 27                	jns    804912 <ipc_recv+0x6c>
		if (from_env_store)
  8048eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8048f0:	74 0a                	je     8048fc <ipc_recv+0x56>
			*from_env_store = 0;
  8048f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048f6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8048fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804901:	74 0a                	je     80490d <ipc_recv+0x67>
			*perm_store = 0;
  804903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804907:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80490d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804910:	eb 53                	jmp    804965 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804912:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804917:	74 19                	je     804932 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804919:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804920:	00 00 00 
  804923:	48 8b 00             	mov    (%rax),%rax
  804926:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80492c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804930:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804932:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804937:	74 19                	je     804952 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804939:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804940:	00 00 00 
  804943:	48 8b 00             	mov    (%rax),%rax
  804946:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80494c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804950:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804952:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804959:	00 00 00 
  80495c:	48 8b 00             	mov    (%rax),%rax
  80495f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804965:	c9                   	leaveq 
  804966:	c3                   	retq   

0000000000804967 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804967:	55                   	push   %rbp
  804968:	48 89 e5             	mov    %rsp,%rbp
  80496b:	48 83 ec 30          	sub    $0x30,%rsp
  80496f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804972:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804975:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804979:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80497c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804981:	75 1c                	jne    80499f <ipc_send+0x38>
		pg = (void*) UTOP;
  804983:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80498a:	00 00 00 
  80498d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804991:	eb 0c                	jmp    80499f <ipc_send+0x38>
		sys_yield();
  804993:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  80499a:	00 00 00 
  80499d:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80499f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8049a2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8049a5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049ac:	89 c7                	mov    %eax,%edi
  8049ae:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  8049b5:	00 00 00 
  8049b8:	ff d0                	callq  *%rax
  8049ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049bd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8049c1:	74 d0                	je     804993 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8049c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049c7:	79 30                	jns    8049f9 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8049c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049cc:	89 c1                	mov    %eax,%ecx
  8049ce:	48 ba 69 54 80 00 00 	movabs $0x805469,%rdx
  8049d5:	00 00 00 
  8049d8:	be 47 00 00 00       	mov    $0x47,%esi
  8049dd:	48 bf 7f 54 80 00 00 	movabs $0x80547f,%rdi
  8049e4:	00 00 00 
  8049e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ec:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  8049f3:	00 00 00 
  8049f6:	41 ff d0             	callq  *%r8

}
  8049f9:	90                   	nop
  8049fa:	c9                   	leaveq 
  8049fb:	c3                   	retq   

00000000008049fc <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8049fc:	55                   	push   %rbp
  8049fd:	48 89 e5             	mov    %rsp,%rbp
  804a00:	53                   	push   %rbx
  804a01:	48 83 ec 28          	sub    $0x28,%rsp
  804a05:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804a09:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804a10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804a17:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a1c:	75 0e                	jne    804a2c <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804a1e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a25:	00 00 00 
  804a28:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804a2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a30:	ba 07 00 00 00       	mov    $0x7,%edx
  804a35:	48 89 c6             	mov    %rax,%rsi
  804a38:	bf 00 00 00 00       	mov    $0x0,%edi
  804a3d:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  804a44:	00 00 00 
  804a47:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804a49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a4d:	48 c1 e8 0c          	shr    $0xc,%rax
  804a51:	48 89 c2             	mov    %rax,%rdx
  804a54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804a5b:	01 00 00 
  804a5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a62:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804a68:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804a6c:	b8 03 00 00 00       	mov    $0x3,%eax
  804a71:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a75:	48 89 d3             	mov    %rdx,%rbx
  804a78:	0f 01 c1             	vmcall 
  804a7b:	89 f2                	mov    %esi,%edx
  804a7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804a80:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804a87:	79 05                	jns    804a8e <ipc_host_recv+0x92>
		return r;
  804a89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a8c:	eb 03                	jmp    804a91 <ipc_host_recv+0x95>
	}
	return val;
  804a8e:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804a91:	48 83 c4 28          	add    $0x28,%rsp
  804a95:	5b                   	pop    %rbx
  804a96:	5d                   	pop    %rbp
  804a97:	c3                   	retq   

0000000000804a98 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804a98:	55                   	push   %rbp
  804a99:	48 89 e5             	mov    %rsp,%rbp
  804a9c:	53                   	push   %rbx
  804a9d:	48 83 ec 38          	sub    $0x38,%rsp
  804aa1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804aa4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804aa7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804aab:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804aae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804ab5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804aba:	75 0e                	jne    804aca <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804abc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804ac3:	00 00 00 
  804ac6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804aca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ace:	48 c1 e8 0c          	shr    $0xc,%rax
  804ad2:	48 89 c2             	mov    %rax,%rdx
  804ad5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804adc:	01 00 00 
  804adf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ae3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804ae9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804aed:	b8 02 00 00 00       	mov    $0x2,%eax
  804af2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804af5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804af8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804afc:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804aff:	89 fb                	mov    %edi,%ebx
  804b01:	0f 01 c1             	vmcall 
  804b04:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804b07:	eb 26                	jmp    804b2f <ipc_host_send+0x97>
		sys_yield();
  804b09:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  804b10:	00 00 00 
  804b13:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804b15:	b8 02 00 00 00       	mov    $0x2,%eax
  804b1a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804b1d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804b20:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b24:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804b27:	89 fb                	mov    %edi,%ebx
  804b29:	0f 01 c1             	vmcall 
  804b2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804b2f:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804b33:	74 d4                	je     804b09 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804b35:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b39:	79 30                	jns    804b6b <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804b3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b3e:	89 c1                	mov    %eax,%ecx
  804b40:	48 ba 69 54 80 00 00 	movabs $0x805469,%rdx
  804b47:	00 00 00 
  804b4a:	be 79 00 00 00       	mov    $0x79,%esi
  804b4f:	48 bf 7f 54 80 00 00 	movabs $0x80547f,%rdi
  804b56:	00 00 00 
  804b59:	b8 00 00 00 00       	mov    $0x0,%eax
  804b5e:	49 b8 90 01 80 00 00 	movabs $0x800190,%r8
  804b65:	00 00 00 
  804b68:	41 ff d0             	callq  *%r8

}
  804b6b:	90                   	nop
  804b6c:	48 83 c4 38          	add    $0x38,%rsp
  804b70:	5b                   	pop    %rbx
  804b71:	5d                   	pop    %rbp
  804b72:	c3                   	retq   

0000000000804b73 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804b73:	55                   	push   %rbp
  804b74:	48 89 e5             	mov    %rsp,%rbp
  804b77:	48 83 ec 18          	sub    $0x18,%rsp
  804b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804b7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804b85:	eb 4d                	jmp    804bd4 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804b87:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804b8e:	00 00 00 
  804b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b94:	48 98                	cltq   
  804b96:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804b9d:	48 01 d0             	add    %rdx,%rax
  804ba0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804ba6:	8b 00                	mov    (%rax),%eax
  804ba8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804bab:	75 23                	jne    804bd0 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804bad:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804bb4:	00 00 00 
  804bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bba:	48 98                	cltq   
  804bbc:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804bc3:	48 01 d0             	add    %rdx,%rax
  804bc6:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804bcc:	8b 00                	mov    (%rax),%eax
  804bce:	eb 12                	jmp    804be2 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804bd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804bd4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804bdb:	7e aa                	jle    804b87 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804be2:	c9                   	leaveq 
  804be3:	c3                   	retq   

0000000000804be4 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804be4:	55                   	push   %rbp
  804be5:	48 89 e5             	mov    %rsp,%rbp
  804be8:	48 83 ec 18          	sub    $0x18,%rsp
  804bec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bf4:	48 c1 e8 15          	shr    $0x15,%rax
  804bf8:	48 89 c2             	mov    %rax,%rdx
  804bfb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c02:	01 00 00 
  804c05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c09:	83 e0 01             	and    $0x1,%eax
  804c0c:	48 85 c0             	test   %rax,%rax
  804c0f:	75 07                	jne    804c18 <pageref+0x34>
		return 0;
  804c11:	b8 00 00 00 00       	mov    $0x0,%eax
  804c16:	eb 56                	jmp    804c6e <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c1c:	48 c1 e8 0c          	shr    $0xc,%rax
  804c20:	48 89 c2             	mov    %rax,%rdx
  804c23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c2a:	01 00 00 
  804c2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c39:	83 e0 01             	and    $0x1,%eax
  804c3c:	48 85 c0             	test   %rax,%rax
  804c3f:	75 07                	jne    804c48 <pageref+0x64>
		return 0;
  804c41:	b8 00 00 00 00       	mov    $0x0,%eax
  804c46:	eb 26                	jmp    804c6e <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c4c:	48 c1 e8 0c          	shr    $0xc,%rax
  804c50:	48 89 c2             	mov    %rax,%rdx
  804c53:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c5a:	00 00 00 
  804c5d:	48 c1 e2 04          	shl    $0x4,%rdx
  804c61:	48 01 d0             	add    %rdx,%rax
  804c64:	48 83 c0 08          	add    $0x8,%rax
  804c68:	0f b7 00             	movzwl (%rax),%eax
  804c6b:	0f b7 c0             	movzwl %ax,%eax
}
  804c6e:	c9                   	leaveq 
  804c6f:	c3                   	retq   
