
vmm/guest/obj/user/testtime:     file format elf64-x86-64


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
  80003c:	e8 6c 01 00 00       	callq  8001ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004e:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  800055:	00 00 00 
  800058:	ff d0                	callq  *%rax
  80005a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800060:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800066:	89 c2                	mov    %eax,%edx
  800068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  800070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800073:	85 c0                	test   %eax,%eax
  800075:	79 38                	jns    8000af <sleep+0x6c>
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	83 f8 eb             	cmp    $0xffffffeb,%eax
  80007d:	7c 30                	jl     8000af <sleep+0x6c>
		panic("sys_time_msec: %e", (int)now);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba e0 41 80 00 00 	movabs $0x8041e0,%rdx
  80008b:	00 00 00 
  80008e:	be 0c 00 00 00       	mov    $0xc,%esi
  800093:	48 bf f2 41 80 00 00 	movabs $0x8041f2,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if (end < now)
  8000af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b5:	73 36                	jae    8000ed <sleep+0xaa>
		panic("sleep: wrap");
  8000b7:	48 ba 02 42 80 00 00 	movabs $0x804202,%rdx
  8000be:	00 00 00 
  8000c1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000c6:	48 bf f2 41 80 00 00 	movabs $0x8041f2,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 55 02 80 00 00 	movabs $0x800255,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
		sys_yield();
  8000e1:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000ed:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax
  8000f9:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fc:	72 e3                	jb     8000e1 <sleep+0x9e>
		sys_yield();
}
  8000fe:	90                   	nop
  8000ff:	c9                   	leaveq 
  800100:	c3                   	retq   

0000000000800101 <umain>:

void
umain(int argc, char **argv)
{
  800101:	55                   	push   %rbp
  800102:	48 89 e5             	mov    %rsp,%rbp
  800105:	48 83 ec 20          	sub    $0x20,%rsp
  800109:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800117:	eb 10                	jmp    800129 <umain+0x28>
		sys_yield();
  800119:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800125:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800129:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012d:	7e ea                	jle    800119 <umain+0x18>
		sys_yield();

	cprintf("starting count down: ");
  80012f:	48 bf 0e 42 80 00 00 	movabs $0x80420e,%rdi
  800136:	00 00 00 
  800139:	b8 00 00 00 00       	mov    $0x0,%eax
  80013e:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  800145:	00 00 00 
  800148:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  80014a:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800151:	eb 35                	jmp    800188 <umain+0x87>
		cprintf("%d ", i);
  800153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800156:	89 c6                	mov    %eax,%esi
  800158:	48 bf 24 42 80 00 00 	movabs $0x804224,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
		sleep(1);
  800173:	bf 01 00 00 00       	mov    $0x1,%edi
  800178:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80017f:	00 00 00 
  800182:	ff d0                	callq  *%rax
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  800184:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800188:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018c:	79 c5                	jns    800153 <umain+0x52>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  80018e:	48 bf 28 42 80 00 00 	movabs $0x804228,%rdi
  800195:	00 00 00 
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  8001a4:	00 00 00 
  8001a7:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001a9:	cc                   	int3   
	breakpoint();
}
  8001aa:	90                   	nop
  8001ab:	c9                   	leaveq 
  8001ac:	c3                   	retq   

00000000008001ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8001bc:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cd:	48 98                	cltq   
  8001cf:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001dd:	00 00 00 
  8001e0:	48 01 c2             	add    %rax,%rdx
  8001e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ea:	00 00 00 
  8001ed:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001f4:	7e 14                	jle    80020a <libmain+0x5d>
		binaryname = argv[0];
  8001f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fa:	48 8b 10             	mov    (%rax),%rdx
  8001fd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800204:	00 00 00 
  800207:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80020a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80020e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800211:	48 89 d6             	mov    %rdx,%rsi
  800214:	89 c7                	mov    %eax,%edi
  800216:	48 b8 01 01 80 00 00 	movabs $0x800101,%rax
  80021d:	00 00 00 
  800220:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800222:	48 b8 31 02 80 00 00 	movabs $0x800231,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
}
  80022e:	90                   	nop
  80022f:	c9                   	leaveq 
  800230:	c3                   	retq   

0000000000800231 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800231:	55                   	push   %rbp
  800232:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800235:	48 b8 94 20 80 00 00 	movabs $0x802094,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800241:	bf 00 00 00 00       	mov    $0x0,%edi
  800246:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
}
  800252:	90                   	nop
  800253:	5d                   	pop    %rbp
  800254:	c3                   	retq   

0000000000800255 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800255:	55                   	push   %rbp
  800256:	48 89 e5             	mov    %rsp,%rbp
  800259:	53                   	push   %rbx
  80025a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800261:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800268:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80026e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800275:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80027c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800283:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80028a:	84 c0                	test   %al,%al
  80028c:	74 23                	je     8002b1 <_panic+0x5c>
  80028e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800295:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800299:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80029d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002a9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ad:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002b1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002b8:	00 00 00 
  8002bb:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c2:	00 00 00 
  8002c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c9:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002d0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002de:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002e5:	00 00 00 
  8002e8:	48 8b 18             	mov    (%rax),%rbx
  8002eb:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
  8002f2:	00 00 00 
  8002f5:	ff d0                	callq  *%rax
  8002f7:	89 c6                	mov    %eax,%esi
  8002f9:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8002ff:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800306:	41 89 d0             	mov    %edx,%r8d
  800309:	48 89 c1             	mov    %rax,%rcx
  80030c:	48 89 da             	mov    %rbx,%rdx
  80030f:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  800316:	00 00 00 
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
  80031e:	49 b9 8f 04 80 00 00 	movabs $0x80048f,%r9
  800325:	00 00 00 
  800328:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80032b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800332:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800339:	48 89 d6             	mov    %rdx,%rsi
  80033c:	48 89 c7             	mov    %rax,%rdi
  80033f:	48 b8 e3 03 80 00 00 	movabs $0x8003e3,%rax
  800346:	00 00 00 
  800349:	ff d0                	callq  *%rax
	cprintf("\n");
  80034b:	48 bf 5b 42 80 00 00 	movabs $0x80425b,%rdi
  800352:	00 00 00 
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  800361:	00 00 00 
  800364:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800366:	cc                   	int3   
  800367:	eb fd                	jmp    800366 <_panic+0x111>

0000000000800369 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
  80036d:	48 83 ec 10          	sub    $0x10,%rsp
  800371:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800374:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037c:	8b 00                	mov    (%rax),%eax
  80037e:	8d 48 01             	lea    0x1(%rax),%ecx
  800381:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800385:	89 0a                	mov    %ecx,(%rdx)
  800387:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80038a:	89 d1                	mov    %edx,%ecx
  80038c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800390:	48 98                	cltq   
  800392:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039a:	8b 00                	mov    (%rax),%eax
  80039c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a1:	75 2c                	jne    8003cf <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a7:	8b 00                	mov    (%rax),%eax
  8003a9:	48 98                	cltq   
  8003ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003af:	48 83 c2 08          	add    $0x8,%rdx
  8003b3:	48 89 c6             	mov    %rax,%rsi
  8003b6:	48 89 d7             	mov    %rdx,%rdi
  8003b9:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  8003c0:	00 00 00 
  8003c3:	ff d0                	callq  *%rax
        b->idx = 0;
  8003c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d3:	8b 40 04             	mov    0x4(%rax),%eax
  8003d6:	8d 50 01             	lea    0x1(%rax),%edx
  8003d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003dd:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e0:	90                   	nop
  8003e1:	c9                   	leaveq 
  8003e2:	c3                   	retq   

00000000008003e3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e3:	55                   	push   %rbp
  8003e4:	48 89 e5             	mov    %rsp,%rbp
  8003e7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003ee:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003f5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003fc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800403:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80040a:	48 8b 0a             	mov    (%rdx),%rcx
  80040d:	48 89 08             	mov    %rcx,(%rax)
  800410:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800414:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800418:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80041c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800420:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800427:	00 00 00 
    b.cnt = 0;
  80042a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800431:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800434:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80043b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800442:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800449:	48 89 c6             	mov    %rax,%rsi
  80044c:	48 bf 69 03 80 00 00 	movabs $0x800369,%rdi
  800453:	00 00 00 
  800456:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  80045d:	00 00 00 
  800460:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800462:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800468:	48 98                	cltq   
  80046a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800471:	48 83 c2 08          	add    $0x8,%rdx
  800475:	48 89 c6             	mov    %rax,%rsi
  800478:	48 89 d7             	mov    %rdx,%rdi
  80047b:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  800482:	00 00 00 
  800485:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800487:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80048d:	c9                   	leaveq 
  80048e:	c3                   	retq   

000000000080048f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80048f:	55                   	push   %rbp
  800490:	48 89 e5             	mov    %rsp,%rbp
  800493:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80049a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004a1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004af:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004bd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c4:	84 c0                	test   %al,%al
  8004c6:	74 20                	je     8004e8 <cprintf+0x59>
  8004c8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004cc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004dc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004e8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004ef:	00 00 00 
  8004f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f9:	00 00 00 
  8004fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800500:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800507:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80050e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800515:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80051c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800523:	48 8b 0a             	mov    (%rdx),%rcx
  800526:	48 89 08             	mov    %rcx,(%rax)
  800529:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80052d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800531:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800535:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800539:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800540:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800547:	48 89 d6             	mov    %rdx,%rsi
  80054a:	48 89 c7             	mov    %rax,%rdi
  80054d:	48 b8 e3 03 80 00 00 	movabs $0x8003e3,%rax
  800554:	00 00 00 
  800557:	ff d0                	callq  *%rax
  800559:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80055f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800565:	c9                   	leaveq 
  800566:	c3                   	retq   

0000000000800567 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800567:	55                   	push   %rbp
  800568:	48 89 e5             	mov    %rsp,%rbp
  80056b:	48 83 ec 30          	sub    $0x30,%rsp
  80056f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800573:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800577:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80057b:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80057e:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800582:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800586:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800589:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80058d:	77 54                	ja     8005e3 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80058f:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800592:	8d 78 ff             	lea    -0x1(%rax),%edi
  800595:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a1:	48 f7 f6             	div    %rsi
  8005a4:	49 89 c2             	mov    %rax,%r10
  8005a7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005aa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005ad:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b5:	41 89 c9             	mov    %ecx,%r9d
  8005b8:	41 89 f8             	mov    %edi,%r8d
  8005bb:	89 d1                	mov    %edx,%ecx
  8005bd:	4c 89 d2             	mov    %r10,%rdx
  8005c0:	48 89 c7             	mov    %rax,%rdi
  8005c3:	48 b8 67 05 80 00 00 	movabs $0x800567,%rax
  8005ca:	00 00 00 
  8005cd:	ff d0                	callq  *%rax
  8005cf:	eb 1c                	jmp    8005ed <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005d5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005dc:	48 89 ce             	mov    %rcx,%rsi
  8005df:	89 d7                	mov    %edx,%edi
  8005e1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e3:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005eb:	7f e4                	jg     8005d1 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ed:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f9:	48 f7 f1             	div    %rcx
  8005fc:	48 b8 50 44 80 00 00 	movabs $0x804450,%rax
  800603:	00 00 00 
  800606:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80060a:	0f be d0             	movsbl %al,%edx
  80060d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800615:	48 89 ce             	mov    %rcx,%rsi
  800618:	89 d7                	mov    %edx,%edi
  80061a:	ff d0                	callq  *%rax
}
  80061c:	90                   	nop
  80061d:	c9                   	leaveq 
  80061e:	c3                   	retq   

000000000080061f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061f:	55                   	push   %rbp
  800620:	48 89 e5             	mov    %rsp,%rbp
  800623:	48 83 ec 20          	sub    $0x20,%rsp
  800627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80062b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80062e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800632:	7e 4f                	jle    800683 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	83 f8 30             	cmp    $0x30,%eax
  80063d:	73 24                	jae    800663 <getuint+0x44>
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064b:	8b 00                	mov    (%rax),%eax
  80064d:	89 c0                	mov    %eax,%eax
  80064f:	48 01 d0             	add    %rdx,%rax
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	8b 12                	mov    (%rdx),%edx
  800658:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	89 0a                	mov    %ecx,(%rdx)
  800661:	eb 14                	jmp    800677 <getuint+0x58>
  800663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800667:	48 8b 40 08          	mov    0x8(%rax),%rax
  80066b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80066f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800673:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800677:	48 8b 00             	mov    (%rax),%rax
  80067a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067e:	e9 9d 00 00 00       	jmpq   800720 <getuint+0x101>
	else if (lflag)
  800683:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800687:	74 4c                	je     8006d5 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	8b 00                	mov    (%rax),%eax
  80068f:	83 f8 30             	cmp    $0x30,%eax
  800692:	73 24                	jae    8006b8 <getuint+0x99>
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	89 c0                	mov    %eax,%eax
  8006a4:	48 01 d0             	add    %rdx,%rax
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	8b 12                	mov    (%rdx),%edx
  8006ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b4:	89 0a                	mov    %ecx,(%rdx)
  8006b6:	eb 14                	jmp    8006cc <getuint+0xad>
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006c0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cc:	48 8b 00             	mov    (%rax),%rax
  8006cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d3:	eb 4b                	jmp    800720 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d9:	8b 00                	mov    (%rax),%eax
  8006db:	83 f8 30             	cmp    $0x30,%eax
  8006de:	73 24                	jae    800704 <getuint+0xe5>
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	8b 00                	mov    (%rax),%eax
  8006ee:	89 c0                	mov    %eax,%eax
  8006f0:	48 01 d0             	add    %rdx,%rax
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	8b 12                	mov    (%rdx),%edx
  8006f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800700:	89 0a                	mov    %ecx,(%rdx)
  800702:	eb 14                	jmp    800718 <getuint+0xf9>
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	48 8b 40 08          	mov    0x8(%rax),%rax
  80070c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800710:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800714:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800718:	8b 00                	mov    (%rax),%eax
  80071a:	89 c0                	mov    %eax,%eax
  80071c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800724:	c9                   	leaveq 
  800725:	c3                   	retq   

0000000000800726 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800726:	55                   	push   %rbp
  800727:	48 89 e5             	mov    %rsp,%rbp
  80072a:	48 83 ec 20          	sub    $0x20,%rsp
  80072e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800732:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800735:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800739:	7e 4f                	jle    80078a <getint+0x64>
		x=va_arg(*ap, long long);
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	8b 00                	mov    (%rax),%eax
  800741:	83 f8 30             	cmp    $0x30,%eax
  800744:	73 24                	jae    80076a <getint+0x44>
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	8b 00                	mov    (%rax),%eax
  800754:	89 c0                	mov    %eax,%eax
  800756:	48 01 d0             	add    %rdx,%rax
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	8b 12                	mov    (%rdx),%edx
  80075f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800766:	89 0a                	mov    %ecx,(%rdx)
  800768:	eb 14                	jmp    80077e <getint+0x58>
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800772:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077e:	48 8b 00             	mov    (%rax),%rax
  800781:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800785:	e9 9d 00 00 00       	jmpq   800827 <getint+0x101>
	else if (lflag)
  80078a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078e:	74 4c                	je     8007dc <getint+0xb6>
		x=va_arg(*ap, long);
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 24                	jae    8007bf <getint+0x99>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	8b 00                	mov    (%rax),%eax
  8007a9:	89 c0                	mov    %eax,%eax
  8007ab:	48 01 d0             	add    %rdx,%rax
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	8b 12                	mov    (%rdx),%edx
  8007b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	89 0a                	mov    %ecx,(%rdx)
  8007bd:	eb 14                	jmp    8007d3 <getint+0xad>
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007c7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d3:	48 8b 00             	mov    (%rax),%rax
  8007d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007da:	eb 4b                	jmp    800827 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e0:	8b 00                	mov    (%rax),%eax
  8007e2:	83 f8 30             	cmp    $0x30,%eax
  8007e5:	73 24                	jae    80080b <getint+0xe5>
  8007e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007eb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	8b 00                	mov    (%rax),%eax
  8007f5:	89 c0                	mov    %eax,%eax
  8007f7:	48 01 d0             	add    %rdx,%rax
  8007fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fe:	8b 12                	mov    (%rdx),%edx
  800800:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	89 0a                	mov    %ecx,(%rdx)
  800809:	eb 14                	jmp    80081f <getint+0xf9>
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800813:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800817:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081f:	8b 00                	mov    (%rax),%eax
  800821:	48 98                	cltq   
  800823:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80082b:	c9                   	leaveq 
  80082c:	c3                   	retq   

000000000080082d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082d:	55                   	push   %rbp
  80082e:	48 89 e5             	mov    %rsp,%rbp
  800831:	41 54                	push   %r12
  800833:	53                   	push   %rbx
  800834:	48 83 ec 60          	sub    $0x60,%rsp
  800838:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80083c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800840:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800844:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800848:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80084c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800850:	48 8b 0a             	mov    (%rdx),%rcx
  800853:	48 89 08             	mov    %rcx,(%rax)
  800856:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80085e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800862:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800866:	eb 17                	jmp    80087f <vprintfmt+0x52>
			if (ch == '\0')
  800868:	85 db                	test   %ebx,%ebx
  80086a:	0f 84 b9 04 00 00    	je     800d29 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800870:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800874:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800878:	48 89 d6             	mov    %rdx,%rsi
  80087b:	89 df                	mov    %ebx,%edi
  80087d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800883:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800887:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088b:	0f b6 00             	movzbl (%rax),%eax
  80088e:	0f b6 d8             	movzbl %al,%ebx
  800891:	83 fb 25             	cmp    $0x25,%ebx
  800894:	75 d2                	jne    800868 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800896:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80089a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008be:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f b6 d8             	movzbl %al,%ebx
  8008c8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008cb:	83 f8 55             	cmp    $0x55,%eax
  8008ce:	0f 87 22 04 00 00    	ja     800cf6 <vprintfmt+0x4c9>
  8008d4:	89 c0                	mov    %eax,%eax
  8008d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008dd:	00 
  8008de:	48 b8 78 44 80 00 00 	movabs $0x804478,%rax
  8008e5:	00 00 00 
  8008e8:	48 01 d0             	add    %rdx,%rax
  8008eb:	48 8b 00             	mov    (%rax),%rax
  8008ee:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008f0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008f4:	eb c0                	jmp    8008b6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008fa:	eb ba                	jmp    8008b6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800903:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800906:	89 d0                	mov    %edx,%eax
  800908:	c1 e0 02             	shl    $0x2,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d8                	add    %ebx,%eax
  800911:	83 e8 30             	sub    $0x30,%eax
  800914:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800917:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800921:	83 fb 2f             	cmp    $0x2f,%ebx
  800924:	7e 60                	jle    800986 <vprintfmt+0x159>
  800926:	83 fb 39             	cmp    $0x39,%ebx
  800929:	7f 5b                	jg     800986 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800930:	eb d1                	jmp    800903 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800932:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800935:	83 f8 30             	cmp    $0x30,%eax
  800938:	73 17                	jae    800951 <vprintfmt+0x124>
  80093a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80093e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800941:	89 d2                	mov    %edx,%edx
  800943:	48 01 d0             	add    %rdx,%rax
  800946:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800949:	83 c2 08             	add    $0x8,%edx
  80094c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80094f:	eb 0c                	jmp    80095d <vprintfmt+0x130>
  800951:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800955:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800959:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80095d:	8b 00                	mov    (%rax),%eax
  80095f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800962:	eb 23                	jmp    800987 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800964:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800968:	0f 89 48 ff ff ff    	jns    8008b6 <vprintfmt+0x89>
				width = 0;
  80096e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800975:	e9 3c ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80097a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800981:	e9 30 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800986:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800987:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098b:	0f 89 25 ff ff ff    	jns    8008b6 <vprintfmt+0x89>
				width = precision, precision = -1;
  800991:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800994:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800997:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80099e:	e9 13 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009a7:	e9 0a ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009af:	83 f8 30             	cmp    $0x30,%eax
  8009b2:	73 17                	jae    8009cb <vprintfmt+0x19e>
  8009b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009b8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bb:	89 d2                	mov    %edx,%edx
  8009bd:	48 01 d0             	add    %rdx,%rax
  8009c0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c3:	83 c2 08             	add    $0x8,%edx
  8009c6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c9:	eb 0c                	jmp    8009d7 <vprintfmt+0x1aa>
  8009cb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009cf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009d3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d7:	8b 10                	mov    (%rax),%edx
  8009d9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e1:	48 89 ce             	mov    %rcx,%rsi
  8009e4:	89 d7                	mov    %edx,%edi
  8009e6:	ff d0                	callq  *%rax
			break;
  8009e8:	e9 37 03 00 00       	jmpq   800d24 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f0:	83 f8 30             	cmp    $0x30,%eax
  8009f3:	73 17                	jae    800a0c <vprintfmt+0x1df>
  8009f5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009f9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fc:	89 d2                	mov    %edx,%edx
  8009fe:	48 01 d0             	add    %rdx,%rax
  800a01:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a04:	83 c2 08             	add    $0x8,%edx
  800a07:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0a:	eb 0c                	jmp    800a18 <vprintfmt+0x1eb>
  800a0c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a10:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a18:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a1a:	85 db                	test   %ebx,%ebx
  800a1c:	79 02                	jns    800a20 <vprintfmt+0x1f3>
				err = -err;
  800a1e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a20:	83 fb 15             	cmp    $0x15,%ebx
  800a23:	7f 16                	jg     800a3b <vprintfmt+0x20e>
  800a25:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  800a2c:	00 00 00 
  800a2f:	48 63 d3             	movslq %ebx,%rdx
  800a32:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a36:	4d 85 e4             	test   %r12,%r12
  800a39:	75 2e                	jne    800a69 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a3b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a43:	89 d9                	mov    %ebx,%ecx
  800a45:	48 ba 61 44 80 00 00 	movabs $0x804461,%rdx
  800a4c:	00 00 00 
  800a4f:	48 89 c7             	mov    %rax,%rdi
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
  800a57:	49 b8 33 0d 80 00 00 	movabs $0x800d33,%r8
  800a5e:	00 00 00 
  800a61:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a64:	e9 bb 02 00 00       	jmpq   800d24 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a71:	4c 89 e1             	mov    %r12,%rcx
  800a74:	48 ba 6a 44 80 00 00 	movabs $0x80446a,%rdx
  800a7b:	00 00 00 
  800a7e:	48 89 c7             	mov    %rax,%rdi
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	49 b8 33 0d 80 00 00 	movabs $0x800d33,%r8
  800a8d:	00 00 00 
  800a90:	41 ff d0             	callq  *%r8
			break;
  800a93:	e9 8c 02 00 00       	jmpq   800d24 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9b:	83 f8 30             	cmp    $0x30,%eax
  800a9e:	73 17                	jae    800ab7 <vprintfmt+0x28a>
  800aa0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aa4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa7:	89 d2                	mov    %edx,%edx
  800aa9:	48 01 d0             	add    %rdx,%rax
  800aac:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aaf:	83 c2 08             	add    $0x8,%edx
  800ab2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab5:	eb 0c                	jmp    800ac3 <vprintfmt+0x296>
  800ab7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800abb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800abf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac3:	4c 8b 20             	mov    (%rax),%r12
  800ac6:	4d 85 e4             	test   %r12,%r12
  800ac9:	75 0a                	jne    800ad5 <vprintfmt+0x2a8>
				p = "(null)";
  800acb:	49 bc 6d 44 80 00 00 	movabs $0x80446d,%r12
  800ad2:	00 00 00 
			if (width > 0 && padc != '-')
  800ad5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad9:	7e 78                	jle    800b53 <vprintfmt+0x326>
  800adb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800adf:	74 72                	je     800b53 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae4:	48 98                	cltq   
  800ae6:	48 89 c6             	mov    %rax,%rsi
  800ae9:	4c 89 e7             	mov    %r12,%rdi
  800aec:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  800af3:	00 00 00 
  800af6:	ff d0                	callq  *%rax
  800af8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800afb:	eb 17                	jmp    800b14 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800afd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b01:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b09:	48 89 ce             	mov    %rcx,%rsi
  800b0c:	89 d7                	mov    %edx,%edi
  800b0e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b10:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b18:	7f e3                	jg     800afd <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1a:	eb 37                	jmp    800b53 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b20:	74 1e                	je     800b40 <vprintfmt+0x313>
  800b22:	83 fb 1f             	cmp    $0x1f,%ebx
  800b25:	7e 05                	jle    800b2c <vprintfmt+0x2ff>
  800b27:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2a:	7e 14                	jle    800b40 <vprintfmt+0x313>
					putch('?', putdat);
  800b2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b34:	48 89 d6             	mov    %rdx,%rsi
  800b37:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b3c:	ff d0                	callq  *%rax
  800b3e:	eb 0f                	jmp    800b4f <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b48:	48 89 d6             	mov    %rdx,%rsi
  800b4b:	89 df                	mov    %ebx,%edi
  800b4d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b53:	4c 89 e0             	mov    %r12,%rax
  800b56:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b5a:	0f b6 00             	movzbl (%rax),%eax
  800b5d:	0f be d8             	movsbl %al,%ebx
  800b60:	85 db                	test   %ebx,%ebx
  800b62:	74 28                	je     800b8c <vprintfmt+0x35f>
  800b64:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b68:	78 b2                	js     800b1c <vprintfmt+0x2ef>
  800b6a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b72:	79 a8                	jns    800b1c <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b74:	eb 16                	jmp    800b8c <vprintfmt+0x35f>
				putch(' ', putdat);
  800b76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7e:	48 89 d6             	mov    %rdx,%rsi
  800b81:	bf 20 00 00 00       	mov    $0x20,%edi
  800b86:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b88:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b90:	7f e4                	jg     800b76 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800b92:	e9 8d 01 00 00       	jmpq   800d24 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9b:	be 03 00 00 00       	mov    $0x3,%esi
  800ba0:	48 89 c7             	mov    %rax,%rdi
  800ba3:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  800baa:	00 00 00 
  800bad:	ff d0                	callq  *%rax
  800baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb7:	48 85 c0             	test   %rax,%rax
  800bba:	79 1d                	jns    800bd9 <vprintfmt+0x3ac>
				putch('-', putdat);
  800bbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc4:	48 89 d6             	mov    %rdx,%rsi
  800bc7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bcc:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd2:	48 f7 d8             	neg    %rax
  800bd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bd9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be0:	e9 d2 00 00 00       	jmpq   800cb7 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800be5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be9:	be 03 00 00 00       	mov    $0x3,%esi
  800bee:	48 89 c7             	mov    %rax,%rdi
  800bf1:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	callq  *%rax
  800bfd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c01:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c08:	e9 aa 00 00 00       	jmpq   800cb7 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800c0d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c11:	be 03 00 00 00       	mov    $0x3,%esi
  800c16:	48 89 c7             	mov    %rax,%rdi
  800c19:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	callq  *%rax
  800c25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c29:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c30:	e9 82 00 00 00       	jmpq   800cb7 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800c35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3d:	48 89 d6             	mov    %rdx,%rsi
  800c40:	bf 30 00 00 00       	mov    $0x30,%edi
  800c45:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4f:	48 89 d6             	mov    %rdx,%rsi
  800c52:	bf 78 00 00 00       	mov    $0x78,%edi
  800c57:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5c:	83 f8 30             	cmp    $0x30,%eax
  800c5f:	73 17                	jae    800c78 <vprintfmt+0x44b>
  800c61:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c68:	89 d2                	mov    %edx,%edx
  800c6a:	48 01 d0             	add    %rdx,%rax
  800c6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c70:	83 c2 08             	add    $0x8,%edx
  800c73:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c76:	eb 0c                	jmp    800c84 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c78:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c7c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c80:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c84:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c8b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c92:	eb 23                	jmp    800cb7 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c98:	be 03 00 00 00       	mov    $0x3,%esi
  800c9d:	48 89 c7             	mov    %rax,%rdi
  800ca0:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800ca7:	00 00 00 
  800caa:	ff d0                	callq  *%rax
  800cac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cb0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cbc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cbf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cce:	45 89 c1             	mov    %r8d,%r9d
  800cd1:	41 89 f8             	mov    %edi,%r8d
  800cd4:	48 89 c7             	mov    %rax,%rdi
  800cd7:	48 b8 67 05 80 00 00 	movabs $0x800567,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	callq  *%rax
			break;
  800ce3:	eb 3f                	jmp    800d24 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ced:	48 89 d6             	mov    %rdx,%rsi
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	ff d0                	callq  *%rax
			break;
  800cf4:	eb 2e                	jmp    800d24 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfe:	48 89 d6             	mov    %rdx,%rsi
  800d01:	bf 25 00 00 00       	mov    $0x25,%edi
  800d06:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d08:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d0d:	eb 05                	jmp    800d14 <vprintfmt+0x4e7>
  800d0f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d14:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d18:	48 83 e8 01          	sub    $0x1,%rax
  800d1c:	0f b6 00             	movzbl (%rax),%eax
  800d1f:	3c 25                	cmp    $0x25,%al
  800d21:	75 ec                	jne    800d0f <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d23:	90                   	nop
		}
	}
  800d24:	e9 3d fb ff ff       	jmpq   800866 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d29:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d2a:	48 83 c4 60          	add    $0x60,%rsp
  800d2e:	5b                   	pop    %rbx
  800d2f:	41 5c                	pop    %r12
  800d31:	5d                   	pop    %rbp
  800d32:	c3                   	retq   

0000000000800d33 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d33:	55                   	push   %rbp
  800d34:	48 89 e5             	mov    %rsp,%rbp
  800d37:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d3e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d45:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d4c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d53:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d61:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d68:	84 c0                	test   %al,%al
  800d6a:	74 20                	je     800d8c <printfmt+0x59>
  800d6c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d70:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d74:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d78:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d80:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d84:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d88:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d8c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d93:	00 00 00 
  800d96:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d9d:	00 00 00 
  800da0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dab:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800db9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dc0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dc7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dce:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd5:	48 89 c7             	mov    %rax,%rdi
  800dd8:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de4:	90                   	nop
  800de5:	c9                   	leaveq 
  800de6:	c3                   	retq   

0000000000800de7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de7:	55                   	push   %rbp
  800de8:	48 89 e5             	mov    %rsp,%rbp
  800deb:	48 83 ec 10          	sub    $0x10,%rsp
  800def:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfa:	8b 40 10             	mov    0x10(%rax),%eax
  800dfd:	8d 50 01             	lea    0x1(%rax),%edx
  800e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e04:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0b:	48 8b 10             	mov    (%rax),%rdx
  800e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e12:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e16:	48 39 c2             	cmp    %rax,%rdx
  800e19:	73 17                	jae    800e32 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1f:	48 8b 00             	mov    (%rax),%rax
  800e22:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e2a:	48 89 0a             	mov    %rcx,(%rdx)
  800e2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e30:	88 10                	mov    %dl,(%rax)
}
  800e32:	90                   	nop
  800e33:	c9                   	leaveq 
  800e34:	c3                   	retq   

0000000000800e35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e35:	55                   	push   %rbp
  800e36:	48 89 e5             	mov    %rsp,%rbp
  800e39:	48 83 ec 50          	sub    $0x50,%rsp
  800e3d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e41:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e44:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e48:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e4c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e50:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e54:	48 8b 0a             	mov    (%rdx),%rcx
  800e57:	48 89 08             	mov    %rcx,(%rax)
  800e5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e6e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e72:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e75:	48 98                	cltq   
  800e77:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e7f:	48 01 d0             	add    %rdx,%rax
  800e82:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e8d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e92:	74 06                	je     800e9a <vsnprintf+0x65>
  800e94:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e98:	7f 07                	jg     800ea1 <vsnprintf+0x6c>
		return -E_INVAL;
  800e9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9f:	eb 2f                	jmp    800ed0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ea1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ea9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ead:	48 89 c6             	mov    %rax,%rsi
  800eb0:	48 bf e7 0d 80 00 00 	movabs $0x800de7,%rdi
  800eb7:	00 00 00 
  800eba:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eca:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ecd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ed0:	c9                   	leaveq 
  800ed1:	c3                   	retq   

0000000000800ed2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed2:	55                   	push   %rbp
  800ed3:	48 89 e5             	mov    %rsp,%rbp
  800ed6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800edd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eea:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800ef1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ef8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f06:	84 c0                	test   %al,%al
  800f08:	74 20                	je     800f2a <snprintf+0x58>
  800f0a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f0e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f12:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f16:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f1a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f1e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f22:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f26:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f2a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f31:	00 00 00 
  800f34:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f3b:	00 00 00 
  800f3e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f42:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f49:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f50:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f57:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f5e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f65:	48 8b 0a             	mov    (%rdx),%rcx
  800f68:	48 89 08             	mov    %rcx,(%rax)
  800f6b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f6f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f73:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f77:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f7b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f82:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f89:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f8f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f96:	48 89 c7             	mov    %rax,%rdi
  800f99:	48 b8 35 0e 80 00 00 	movabs $0x800e35,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	callq  *%rax
  800fa5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fab:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fb1:	c9                   	leaveq 
  800fb2:	c3                   	retq   

0000000000800fb3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb3:	55                   	push   %rbp
  800fb4:	48 89 e5             	mov    %rsp,%rbp
  800fb7:	48 83 ec 18          	sub    $0x18,%rsp
  800fbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc6:	eb 09                	jmp    800fd1 <strlen+0x1e>
		n++;
  800fc8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fcc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	84 c0                	test   %al,%al
  800fda:	75 ec                	jne    800fc8 <strlen+0x15>
		n++;
	return n;
  800fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fdf:	c9                   	leaveq 
  800fe0:	c3                   	retq   

0000000000800fe1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe1:	55                   	push   %rbp
  800fe2:	48 89 e5             	mov    %rsp,%rbp
  800fe5:	48 83 ec 20          	sub    $0x20,%rsp
  800fe9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff8:	eb 0e                	jmp    801008 <strnlen+0x27>
		n++;
  800ffa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801003:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801008:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80100d:	74 0b                	je     80101a <strnlen+0x39>
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	84 c0                	test   %al,%al
  801018:	75 e0                	jne    800ffa <strnlen+0x19>
		n++;
	return n;
  80101a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 83 ec 20          	sub    $0x20,%rsp
  801027:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80102f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801033:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801037:	90                   	nop
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801040:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801044:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801048:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801050:	0f b6 12             	movzbl (%rdx),%edx
  801053:	88 10                	mov    %dl,(%rax)
  801055:	0f b6 00             	movzbl (%rax),%eax
  801058:	84 c0                	test   %al,%al
  80105a:	75 dc                	jne    801038 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80105c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801060:	c9                   	leaveq 
  801061:	c3                   	retq   

0000000000801062 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	48 83 ec 20          	sub    $0x20,%rsp
  80106a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	48 89 c7             	mov    %rax,%rdi
  801079:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  801080:	00 00 00 
  801083:	ff d0                	callq  *%rax
  801085:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108b:	48 63 d0             	movslq %eax,%rdx
  80108e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801092:	48 01 c2             	add    %rax,%rdx
  801095:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801099:	48 89 c6             	mov    %rax,%rsi
  80109c:	48 89 d7             	mov    %rdx,%rdi
  80109f:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8010a6:	00 00 00 
  8010a9:	ff d0                	callq  *%rax
	return dst;
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010af:	c9                   	leaveq 
  8010b0:	c3                   	retq   

00000000008010b1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010b1:	55                   	push   %rbp
  8010b2:	48 89 e5             	mov    %rsp,%rbp
  8010b5:	48 83 ec 28          	sub    $0x28,%rsp
  8010b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010cd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d4:	00 
  8010d5:	eb 2a                	jmp    801101 <strncpy+0x50>
		*dst++ = *src;
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e7:	0f b6 12             	movzbl (%rdx),%edx
  8010ea:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f0:	0f b6 00             	movzbl (%rax),%eax
  8010f3:	84 c0                	test   %al,%al
  8010f5:	74 05                	je     8010fc <strncpy+0x4b>
			src++;
  8010f7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801105:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801109:	72 cc                	jb     8010d7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80110f:	c9                   	leaveq 
  801110:	c3                   	retq   

0000000000801111 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801111:	55                   	push   %rbp
  801112:	48 89 e5             	mov    %rsp,%rbp
  801115:	48 83 ec 28          	sub    $0x28,%rsp
  801119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801121:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801129:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80112d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801132:	74 3d                	je     801171 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801134:	eb 1d                	jmp    801153 <strlcpy+0x42>
			*dst++ = *src++;
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801142:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801146:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80114a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80114e:	0f b6 12             	movzbl (%rdx),%edx
  801151:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801153:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801158:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115d:	74 0b                	je     80116a <strlcpy+0x59>
  80115f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801163:	0f b6 00             	movzbl (%rax),%eax
  801166:	84 c0                	test   %al,%al
  801168:	75 cc                	jne    801136 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80116a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801179:	48 29 c2             	sub    %rax,%rdx
  80117c:	48 89 d0             	mov    %rdx,%rax
}
  80117f:	c9                   	leaveq 
  801180:	c3                   	retq   

0000000000801181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801181:	55                   	push   %rbp
  801182:	48 89 e5             	mov    %rsp,%rbp
  801185:	48 83 ec 10          	sub    $0x10,%rsp
  801189:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801191:	eb 0a                	jmp    80119d <strcmp+0x1c>
		p++, q++;
  801193:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801198:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 12                	je     8011ba <strcmp+0x39>
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ac:	0f b6 10             	movzbl (%rax),%edx
  8011af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	38 c2                	cmp    %al,%dl
  8011b8:	74 d9                	je     801193 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	0f b6 d0             	movzbl %al,%edx
  8011c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c8:	0f b6 00             	movzbl (%rax),%eax
  8011cb:	0f b6 c0             	movzbl %al,%eax
  8011ce:	29 c2                	sub    %eax,%edx
  8011d0:	89 d0                	mov    %edx,%eax
}
  8011d2:	c9                   	leaveq 
  8011d3:	c3                   	retq   

00000000008011d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	48 83 ec 18          	sub    $0x18,%rsp
  8011dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011e8:	eb 0f                	jmp    8011f9 <strncmp+0x25>
		n--, p++, q++;
  8011ea:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011fe:	74 1d                	je     80121d <strncmp+0x49>
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	84 c0                	test   %al,%al
  801209:	74 12                	je     80121d <strncmp+0x49>
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	0f b6 10             	movzbl (%rax),%edx
  801212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801216:	0f b6 00             	movzbl (%rax),%eax
  801219:	38 c2                	cmp    %al,%dl
  80121b:	74 cd                	je     8011ea <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80121d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801222:	75 07                	jne    80122b <strncmp+0x57>
		return 0;
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	eb 18                	jmp    801243 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	0f b6 d0             	movzbl %al,%edx
  801235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	0f b6 c0             	movzbl %al,%eax
  80123f:	29 c2                	sub    %eax,%edx
  801241:	89 d0                	mov    %edx,%eax
}
  801243:	c9                   	leaveq 
  801244:	c3                   	retq   

0000000000801245 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	48 83 ec 10          	sub    $0x10,%rsp
  80124d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801251:	89 f0                	mov    %esi,%eax
  801253:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801256:	eb 17                	jmp    80126f <strchr+0x2a>
		if (*s == c)
  801258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125c:	0f b6 00             	movzbl (%rax),%eax
  80125f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801262:	75 06                	jne    80126a <strchr+0x25>
			return (char *) s;
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	eb 15                	jmp    80127f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80126a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801273:	0f b6 00             	movzbl (%rax),%eax
  801276:	84 c0                	test   %al,%al
  801278:	75 de                	jne    801258 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127f:	c9                   	leaveq 
  801280:	c3                   	retq   

0000000000801281 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	48 83 ec 10          	sub    $0x10,%rsp
  801289:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128d:	89 f0                	mov    %esi,%eax
  80128f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801292:	eb 11                	jmp    8012a5 <strfind+0x24>
		if (*s == c)
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80129e:	74 12                	je     8012b2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	0f b6 00             	movzbl (%rax),%eax
  8012ac:	84 c0                	test   %al,%al
  8012ae:	75 e4                	jne    801294 <strfind+0x13>
  8012b0:	eb 01                	jmp    8012b3 <strfind+0x32>
		if (*s == c)
			break;
  8012b2:	90                   	nop
	return (char *) s;
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 18          	sub    $0x18,%rsp
  8012c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c5:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d1:	75 06                	jne    8012d9 <memset+0x20>
		return v;
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	eb 69                	jmp    801342 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dd:	83 e0 03             	and    $0x3,%eax
  8012e0:	48 85 c0             	test   %rax,%rax
  8012e3:	75 48                	jne    80132d <memset+0x74>
  8012e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e9:	83 e0 03             	and    $0x3,%eax
  8012ec:	48 85 c0             	test   %rax,%rax
  8012ef:	75 3c                	jne    80132d <memset+0x74>
		c &= 0xFF;
  8012f1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012fb:	c1 e0 18             	shl    $0x18,%eax
  8012fe:	89 c2                	mov    %eax,%edx
  801300:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801303:	c1 e0 10             	shl    $0x10,%eax
  801306:	09 c2                	or     %eax,%edx
  801308:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130b:	c1 e0 08             	shl    $0x8,%eax
  80130e:	09 d0                	or     %edx,%eax
  801310:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801317:	48 c1 e8 02          	shr    $0x2,%rax
  80131b:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80131e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801322:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801325:	48 89 d7             	mov    %rdx,%rdi
  801328:	fc                   	cld    
  801329:	f3 ab                	rep stos %eax,%es:(%rdi)
  80132b:	eb 11                	jmp    80133e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801338:	48 89 d7             	mov    %rdx,%rdi
  80133b:	fc                   	cld    
  80133c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80133e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801342:	c9                   	leaveq 
  801343:	c3                   	retq   

0000000000801344 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801344:	55                   	push   %rbp
  801345:	48 89 e5             	mov    %rsp,%rbp
  801348:	48 83 ec 28          	sub    $0x28,%rsp
  80134c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801350:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801354:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801358:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801370:	0f 83 88 00 00 00    	jae    8013fe <memmove+0xba>
  801376:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137e:	48 01 d0             	add    %rdx,%rax
  801381:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801385:	76 77                	jbe    8013fe <memmove+0xba>
		s += n;
  801387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80138f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801393:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139b:	83 e0 03             	and    $0x3,%eax
  80139e:	48 85 c0             	test   %rax,%rax
  8013a1:	75 3b                	jne    8013de <memmove+0x9a>
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	83 e0 03             	and    $0x3,%eax
  8013aa:	48 85 c0             	test   %rax,%rax
  8013ad:	75 2f                	jne    8013de <memmove+0x9a>
  8013af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b3:	83 e0 03             	and    $0x3,%eax
  8013b6:	48 85 c0             	test   %rax,%rax
  8013b9:	75 23                	jne    8013de <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bf:	48 83 e8 04          	sub    $0x4,%rax
  8013c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c7:	48 83 ea 04          	sub    $0x4,%rdx
  8013cb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013cf:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013d3:	48 89 c7             	mov    %rax,%rdi
  8013d6:	48 89 d6             	mov    %rdx,%rsi
  8013d9:	fd                   	std    
  8013da:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013dc:	eb 1d                	jmp    8013fb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f2:	48 89 d7             	mov    %rdx,%rdi
  8013f5:	48 89 c1             	mov    %rax,%rcx
  8013f8:	fd                   	std    
  8013f9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013fb:	fc                   	cld    
  8013fc:	eb 57                	jmp    801455 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801402:	83 e0 03             	and    $0x3,%eax
  801405:	48 85 c0             	test   %rax,%rax
  801408:	75 36                	jne    801440 <memmove+0xfc>
  80140a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140e:	83 e0 03             	and    $0x3,%eax
  801411:	48 85 c0             	test   %rax,%rax
  801414:	75 2a                	jne    801440 <memmove+0xfc>
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	83 e0 03             	and    $0x3,%eax
  80141d:	48 85 c0             	test   %rax,%rax
  801420:	75 1e                	jne    801440 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801426:	48 c1 e8 02          	shr    $0x2,%rax
  80142a:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80142d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801431:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801435:	48 89 c7             	mov    %rax,%rdi
  801438:	48 89 d6             	mov    %rdx,%rsi
  80143b:	fc                   	cld    
  80143c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143e:	eb 15                	jmp    801455 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801444:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801448:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144c:	48 89 c7             	mov    %rax,%rdi
  80144f:	48 89 d6             	mov    %rdx,%rsi
  801452:	fc                   	cld    
  801453:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801459:	c9                   	leaveq 
  80145a:	c3                   	retq   

000000000080145b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 83 ec 18          	sub    $0x18,%rsp
  801463:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801467:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80146b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80146f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801473:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	48 89 ce             	mov    %rcx,%rsi
  80147e:	48 89 c7             	mov    %rax,%rdi
  801481:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  801488:	00 00 00 
  80148b:	ff d0                	callq  *%rax
}
  80148d:	c9                   	leaveq 
  80148e:	c3                   	retq   

000000000080148f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80148f:	55                   	push   %rbp
  801490:	48 89 e5             	mov    %rsp,%rbp
  801493:	48 83 ec 28          	sub    $0x28,%rsp
  801497:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80149f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014b3:	eb 36                	jmp    8014eb <memcmp+0x5c>
		if (*s1 != *s2)
  8014b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b9:	0f b6 10             	movzbl (%rax),%edx
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	38 c2                	cmp    %al,%dl
  8014c5:	74 1a                	je     8014e1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cb:	0f b6 00             	movzbl (%rax),%eax
  8014ce:	0f b6 d0             	movzbl %al,%edx
  8014d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	0f b6 c0             	movzbl %al,%eax
  8014db:	29 c2                	sub    %eax,%edx
  8014dd:	89 d0                	mov    %edx,%eax
  8014df:	eb 20                	jmp    801501 <memcmp+0x72>
		s1++, s2++;
  8014e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f7:	48 85 c0             	test   %rax,%rax
  8014fa:	75 b9                	jne    8014b5 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 28          	sub    $0x28,%rsp
  80150b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801512:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151e:	48 01 d0             	add    %rdx,%rax
  801521:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801525:	eb 19                	jmp    801540 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	0f b6 d0             	movzbl %al,%edx
  801531:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801534:	0f b6 c0             	movzbl %al,%eax
  801537:	39 c2                	cmp    %eax,%edx
  801539:	74 11                	je     80154c <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80153b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801544:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801548:	72 dd                	jb     801527 <memfind+0x24>
  80154a:	eb 01                	jmp    80154d <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80154c:	90                   	nop
	return (void *) s;
  80154d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801551:	c9                   	leaveq 
  801552:	c3                   	retq   

0000000000801553 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	48 83 ec 38          	sub    $0x38,%rsp
  80155b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80155f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801563:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801566:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80156d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801574:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801575:	eb 05                	jmp    80157c <strtol+0x29>
		s++;
  801577:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	3c 20                	cmp    $0x20,%al
  801585:	74 f0                	je     801577 <strtol+0x24>
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	0f b6 00             	movzbl (%rax),%eax
  80158e:	3c 09                	cmp    $0x9,%al
  801590:	74 e5                	je     801577 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	3c 2b                	cmp    $0x2b,%al
  80159b:	75 07                	jne    8015a4 <strtol+0x51>
		s++;
  80159d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a2:	eb 17                	jmp    8015bb <strtol+0x68>
	else if (*s == '-')
  8015a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	3c 2d                	cmp    $0x2d,%al
  8015ad:	75 0c                	jne    8015bb <strtol+0x68>
		s++, neg = 1;
  8015af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015bf:	74 06                	je     8015c7 <strtol+0x74>
  8015c1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015c5:	75 28                	jne    8015ef <strtol+0x9c>
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3c 30                	cmp    $0x30,%al
  8015d0:	75 1d                	jne    8015ef <strtol+0x9c>
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	48 83 c0 01          	add    $0x1,%rax
  8015da:	0f b6 00             	movzbl (%rax),%eax
  8015dd:	3c 78                	cmp    $0x78,%al
  8015df:	75 0e                	jne    8015ef <strtol+0x9c>
		s += 2, base = 16;
  8015e1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015ed:	eb 2c                	jmp    80161b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f3:	75 19                	jne    80160e <strtol+0xbb>
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3c 30                	cmp    $0x30,%al
  8015fe:	75 0e                	jne    80160e <strtol+0xbb>
		s++, base = 8;
  801600:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801605:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80160c:	eb 0d                	jmp    80161b <strtol+0xc8>
	else if (base == 0)
  80160e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801612:	75 07                	jne    80161b <strtol+0xc8>
		base = 10;
  801614:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 2f                	cmp    $0x2f,%al
  801624:	7e 1d                	jle    801643 <strtol+0xf0>
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 39                	cmp    $0x39,%al
  80162f:	7f 12                	jg     801643 <strtol+0xf0>
			dig = *s - '0';
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	0f be c0             	movsbl %al,%eax
  80163b:	83 e8 30             	sub    $0x30,%eax
  80163e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801641:	eb 4e                	jmp    801691 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 60                	cmp    $0x60,%al
  80164c:	7e 1d                	jle    80166b <strtol+0x118>
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	3c 7a                	cmp    $0x7a,%al
  801657:	7f 12                	jg     80166b <strtol+0x118>
			dig = *s - 'a' + 10;
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	0f be c0             	movsbl %al,%eax
  801663:	83 e8 57             	sub    $0x57,%eax
  801666:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801669:	eb 26                	jmp    801691 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 47                	jle    8016bd <strtol+0x16a>
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	3c 5a                	cmp    $0x5a,%al
  80167f:	7f 3c                	jg     8016bd <strtol+0x16a>
			dig = *s - 'A' + 10;
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	0f be c0             	movsbl %al,%eax
  80168b:	83 e8 37             	sub    $0x37,%eax
  80168e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801691:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801694:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801697:	7d 23                	jge    8016bc <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801699:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016a1:	48 98                	cltq   
  8016a3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016a8:	48 89 c2             	mov    %rax,%rdx
  8016ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ae:	48 98                	cltq   
  8016b0:	48 01 d0             	add    %rdx,%rax
  8016b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b7:	e9 5f ff ff ff       	jmpq   80161b <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016bc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016bd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016c2:	74 0b                	je     8016cf <strtol+0x17c>
		*endptr = (char *) s;
  8016c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016cc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d3:	74 09                	je     8016de <strtol+0x18b>
  8016d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d9:	48 f7 d8             	neg    %rax
  8016dc:	eb 04                	jmp    8016e2 <strtol+0x18f>
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016e2:	c9                   	leaveq 
  8016e3:	c3                   	retq   

00000000008016e4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016e4:	55                   	push   %rbp
  8016e5:	48 89 e5             	mov    %rsp,%rbp
  8016e8:	48 83 ec 30          	sub    $0x30,%rsp
  8016ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016fc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801706:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80170a:	75 06                	jne    801712 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	eb 6b                	jmp    80177d <strstr+0x99>

	len = strlen(str);
  801712:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801716:	48 89 c7             	mov    %rax,%rdi
  801719:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  801720:	00 00 00 
  801723:	ff d0                	callq  *%rax
  801725:	48 98                	cltq   
  801727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80172b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801733:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80173d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801741:	75 07                	jne    80174a <strstr+0x66>
				return (char *) 0;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	eb 33                	jmp    80177d <strstr+0x99>
		} while (sc != c);
  80174a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80174e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801751:	75 d8                	jne    80172b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801753:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801757:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	48 89 ce             	mov    %rcx,%rsi
  801762:	48 89 c7             	mov    %rax,%rdi
  801765:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  80176c:	00 00 00 
  80176f:	ff d0                	callq  *%rax
  801771:	85 c0                	test   %eax,%eax
  801773:	75 b6                	jne    80172b <strstr+0x47>

	return (char *) (in - 1);
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	48 83 e8 01          	sub    $0x1,%rax
}
  80177d:	c9                   	leaveq 
  80177e:	c3                   	retq   

000000000080177f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80177f:	55                   	push   %rbp
  801780:	48 89 e5             	mov    %rsp,%rbp
  801783:	53                   	push   %rbx
  801784:	48 83 ec 48          	sub    $0x48,%rsp
  801788:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80178b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80178e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801792:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801796:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80179a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017a1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017a9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017ad:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017b1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b5:	4c 89 c3             	mov    %r8,%rbx
  8017b8:	cd 30                	int    $0x30
  8017ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017be:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017c2:	74 3e                	je     801802 <syscall+0x83>
  8017c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017c9:	7e 37                	jle    801802 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d2:	49 89 d0             	mov    %rdx,%r8
  8017d5:	89 c1                	mov    %eax,%ecx
  8017d7:	48 ba 28 47 80 00 00 	movabs $0x804728,%rdx
  8017de:	00 00 00 
  8017e1:	be 24 00 00 00       	mov    $0x24,%esi
  8017e6:	48 bf 45 47 80 00 00 	movabs $0x804745,%rdi
  8017ed:	00 00 00 
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	49 b9 55 02 80 00 00 	movabs $0x800255,%r9
  8017fc:	00 00 00 
  8017ff:	41 ff d1             	callq  *%r9

	return ret;
  801802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801806:	48 83 c4 48          	add    $0x48,%rsp
  80180a:	5b                   	pop    %rbx
  80180b:	5d                   	pop    %rbp
  80180c:	c3                   	retq   

000000000080180d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80180d:	55                   	push   %rbp
  80180e:	48 89 e5             	mov    %rsp,%rbp
  801811:	48 83 ec 10          	sub    $0x10,%rsp
  801815:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801819:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80181d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801821:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801825:	48 83 ec 08          	sub    $0x8,%rsp
  801829:	6a 00                	pushq  $0x0
  80182b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801831:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801837:	48 89 d1             	mov    %rdx,%rcx
  80183a:	48 89 c2             	mov    %rax,%rdx
  80183d:	be 00 00 00 00       	mov    $0x0,%esi
  801842:	bf 00 00 00 00       	mov    $0x0,%edi
  801847:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  80184e:	00 00 00 
  801851:	ff d0                	callq  *%rax
  801853:	48 83 c4 10          	add    $0x10,%rsp
}
  801857:	90                   	nop
  801858:	c9                   	leaveq 
  801859:	c3                   	retq   

000000000080185a <sys_cgetc>:

int
sys_cgetc(void)
{
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80185e:	48 83 ec 08          	sub    $0x8,%rsp
  801862:	6a 00                	pushq  $0x0
  801864:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801870:	b9 00 00 00 00       	mov    $0x0,%ecx
  801875:	ba 00 00 00 00       	mov    $0x0,%edx
  80187a:	be 00 00 00 00       	mov    $0x0,%esi
  80187f:	bf 01 00 00 00       	mov    $0x1,%edi
  801884:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  80188b:	00 00 00 
  80188e:	ff d0                	callq  *%rax
  801890:	48 83 c4 10          	add    $0x10,%rsp
}
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 10          	sub    $0x10,%rsp
  80189e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a4:	48 98                	cltq   
  8018a6:	48 83 ec 08          	sub    $0x8,%rsp
  8018aa:	6a 00                	pushq  $0x0
  8018ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018bd:	48 89 c2             	mov    %rax,%rdx
  8018c0:	be 01 00 00 00       	mov    $0x1,%esi
  8018c5:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ca:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  8018d1:	00 00 00 
  8018d4:	ff d0                	callq  *%rax
  8018d6:	48 83 c4 10          	add    $0x10,%rsp
}
  8018da:	c9                   	leaveq 
  8018db:	c3                   	retq   

00000000008018dc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018dc:	55                   	push   %rbp
  8018dd:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018e0:	48 83 ec 08          	sub    $0x8,%rsp
  8018e4:	6a 00                	pushq  $0x0
  8018e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fc:	be 00 00 00 00       	mov    $0x0,%esi
  801901:	bf 02 00 00 00       	mov    $0x2,%edi
  801906:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  80190d:	00 00 00 
  801910:	ff d0                	callq  *%rax
  801912:	48 83 c4 10          	add    $0x10,%rsp
}
  801916:	c9                   	leaveq 
  801917:	c3                   	retq   

0000000000801918 <sys_yield>:


void
sys_yield(void)
{
  801918:	55                   	push   %rbp
  801919:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80191c:	48 83 ec 08          	sub    $0x8,%rsp
  801920:	6a 00                	pushq  $0x0
  801922:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801928:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801933:	ba 00 00 00 00       	mov    $0x0,%edx
  801938:	be 00 00 00 00       	mov    $0x0,%esi
  80193d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801942:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801949:	00 00 00 
  80194c:	ff d0                	callq  *%rax
  80194e:	48 83 c4 10          	add    $0x10,%rsp
}
  801952:	90                   	nop
  801953:	c9                   	leaveq 
  801954:	c3                   	retq   

0000000000801955 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	48 83 ec 10          	sub    $0x10,%rsp
  80195d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801960:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801964:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801967:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80196a:	48 63 c8             	movslq %eax,%rcx
  80196d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801974:	48 98                	cltq   
  801976:	48 83 ec 08          	sub    $0x8,%rsp
  80197a:	6a 00                	pushq  $0x0
  80197c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801982:	49 89 c8             	mov    %rcx,%r8
  801985:	48 89 d1             	mov    %rdx,%rcx
  801988:	48 89 c2             	mov    %rax,%rdx
  80198b:	be 01 00 00 00       	mov    $0x1,%esi
  801990:	bf 04 00 00 00       	mov    $0x4,%edi
  801995:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  80199c:	00 00 00 
  80199f:	ff d0                	callq  *%rax
  8019a1:	48 83 c4 10          	add    $0x10,%rsp
}
  8019a5:	c9                   	leaveq 
  8019a6:	c3                   	retq   

00000000008019a7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a7:	55                   	push   %rbp
  8019a8:	48 89 e5             	mov    %rsp,%rbp
  8019ab:	48 83 ec 20          	sub    $0x20,%rsp
  8019af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019bd:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019c1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019c4:	48 63 c8             	movslq %eax,%rcx
  8019c7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ce:	48 63 f0             	movslq %eax,%rsi
  8019d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d8:	48 98                	cltq   
  8019da:	48 83 ec 08          	sub    $0x8,%rsp
  8019de:	51                   	push   %rcx
  8019df:	49 89 f9             	mov    %rdi,%r9
  8019e2:	49 89 f0             	mov    %rsi,%r8
  8019e5:	48 89 d1             	mov    %rdx,%rcx
  8019e8:	48 89 c2             	mov    %rax,%rdx
  8019eb:	be 01 00 00 00       	mov    $0x1,%esi
  8019f0:	bf 05 00 00 00       	mov    $0x5,%edi
  8019f5:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
  801a01:	48 83 c4 10          	add    $0x10,%rsp
}
  801a05:	c9                   	leaveq 
  801a06:	c3                   	retq   

0000000000801a07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a07:	55                   	push   %rbp
  801a08:	48 89 e5             	mov    %rsp,%rbp
  801a0b:	48 83 ec 10          	sub    $0x10,%rsp
  801a0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1d:	48 98                	cltq   
  801a1f:	48 83 ec 08          	sub    $0x8,%rsp
  801a23:	6a 00                	pushq  $0x0
  801a25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a31:	48 89 d1             	mov    %rdx,%rcx
  801a34:	48 89 c2             	mov    %rax,%rdx
  801a37:	be 01 00 00 00       	mov    $0x1,%esi
  801a3c:	bf 06 00 00 00       	mov    $0x6,%edi
  801a41:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	callq  *%rax
  801a4d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
  801a57:	48 83 ec 10          	sub    $0x10,%rsp
  801a5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a64:	48 63 d0             	movslq %eax,%rdx
  801a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6a:	48 98                	cltq   
  801a6c:	48 83 ec 08          	sub    $0x8,%rsp
  801a70:	6a 00                	pushq  $0x0
  801a72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7e:	48 89 d1             	mov    %rdx,%rcx
  801a81:	48 89 c2             	mov    %rax,%rdx
  801a84:	be 01 00 00 00       	mov    $0x1,%esi
  801a89:	bf 08 00 00 00       	mov    $0x8,%edi
  801a8e:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801a95:	00 00 00 
  801a98:	ff d0                	callq  *%rax
  801a9a:	48 83 c4 10          	add    $0x10,%rsp
}
  801a9e:	c9                   	leaveq 
  801a9f:	c3                   	retq   

0000000000801aa0 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801aa0:	55                   	push   %rbp
  801aa1:	48 89 e5             	mov    %rsp,%rbp
  801aa4:	48 83 ec 10          	sub    $0x10,%rsp
  801aa8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aaf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab6:	48 98                	cltq   
  801ab8:	48 83 ec 08          	sub    $0x8,%rsp
  801abc:	6a 00                	pushq  $0x0
  801abe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aca:	48 89 d1             	mov    %rdx,%rcx
  801acd:	48 89 c2             	mov    %rax,%rdx
  801ad0:	be 01 00 00 00       	mov    $0x1,%esi
  801ad5:	bf 09 00 00 00       	mov    $0x9,%edi
  801ada:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	callq  *%rax
  801ae6:	48 83 c4 10          	add    $0x10,%rsp
}
  801aea:	c9                   	leaveq 
  801aeb:	c3                   	retq   

0000000000801aec <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aec:	55                   	push   %rbp
  801aed:	48 89 e5             	mov    %rsp,%rbp
  801af0:	48 83 ec 10          	sub    $0x10,%rsp
  801af4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801afb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b02:	48 98                	cltq   
  801b04:	48 83 ec 08          	sub    $0x8,%rsp
  801b08:	6a 00                	pushq  $0x0
  801b0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b16:	48 89 d1             	mov    %rdx,%rcx
  801b19:	48 89 c2             	mov    %rax,%rdx
  801b1c:	be 01 00 00 00       	mov    $0x1,%esi
  801b21:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b26:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	callq  *%rax
  801b32:	48 83 c4 10          	add    $0x10,%rsp
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 20          	sub    $0x20,%rsp
  801b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b4b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b51:	48 63 f0             	movslq %eax,%rsi
  801b54:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5b:	48 98                	cltq   
  801b5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b61:	48 83 ec 08          	sub    $0x8,%rsp
  801b65:	6a 00                	pushq  $0x0
  801b67:	49 89 f1             	mov    %rsi,%r9
  801b6a:	49 89 c8             	mov    %rcx,%r8
  801b6d:	48 89 d1             	mov    %rdx,%rcx
  801b70:	48 89 c2             	mov    %rax,%rdx
  801b73:	be 00 00 00 00       	mov    $0x0,%esi
  801b78:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b7d:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	callq  *%rax
  801b89:	48 83 c4 10          	add    $0x10,%rsp
}
  801b8d:	c9                   	leaveq 
  801b8e:	c3                   	retq   

0000000000801b8f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b8f:	55                   	push   %rbp
  801b90:	48 89 e5             	mov    %rsp,%rbp
  801b93:	48 83 ec 10          	sub    $0x10,%rsp
  801b97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9f:	48 83 ec 08          	sub    $0x8,%rsp
  801ba3:	6a 00                	pushq  $0x0
  801ba5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb6:	48 89 c2             	mov    %rax,%rdx
  801bb9:	be 01 00 00 00       	mov    $0x1,%esi
  801bbe:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bc3:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801bca:	00 00 00 
  801bcd:	ff d0                	callq  *%rax
  801bcf:	48 83 c4 10          	add    $0x10,%rsp
}
  801bd3:	c9                   	leaveq 
  801bd4:	c3                   	retq   

0000000000801bd5 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801bd5:	55                   	push   %rbp
  801bd6:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bd9:	48 83 ec 08          	sub    $0x8,%rsp
  801bdd:	6a 00                	pushq  $0x0
  801bdf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801beb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf5:	be 00 00 00 00       	mov    $0x0,%esi
  801bfa:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bff:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801c06:	00 00 00 
  801c09:	ff d0                	callq  *%rax
  801c0b:	48 83 c4 10          	add    $0x10,%rsp
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 10          	sub    $0x10,%rsp
  801c19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c1d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801c20:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c27:	48 83 ec 08          	sub    $0x8,%rsp
  801c2b:	6a 00                	pushq  $0x0
  801c2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c39:	48 89 d1             	mov    %rdx,%rcx
  801c3c:	48 89 c2             	mov    %rax,%rdx
  801c3f:	be 00 00 00 00       	mov    $0x0,%esi
  801c44:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c49:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801c50:	00 00 00 
  801c53:	ff d0                	callq  *%rax
  801c55:	48 83 c4 10          	add    $0x10,%rsp
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 10          	sub    $0x10,%rsp
  801c63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c67:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801c6a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c71:	48 83 ec 08          	sub    $0x8,%rsp
  801c75:	6a 00                	pushq  $0x0
  801c77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c83:	48 89 d1             	mov    %rdx,%rcx
  801c86:	48 89 c2             	mov    %rax,%rdx
  801c89:	be 00 00 00 00       	mov    $0x0,%esi
  801c8e:	bf 10 00 00 00       	mov    $0x10,%edi
  801c93:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	callq  *%rax
  801c9f:	48 83 c4 10          	add    $0x10,%rsp
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 20          	sub    $0x20,%rsp
  801cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cb4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cb7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cbb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cbf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cc2:	48 63 c8             	movslq %eax,%rcx
  801cc5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ccc:	48 63 f0             	movslq %eax,%rsi
  801ccf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd6:	48 98                	cltq   
  801cd8:	48 83 ec 08          	sub    $0x8,%rsp
  801cdc:	51                   	push   %rcx
  801cdd:	49 89 f9             	mov    %rdi,%r9
  801ce0:	49 89 f0             	mov    %rsi,%r8
  801ce3:	48 89 d1             	mov    %rdx,%rcx
  801ce6:	48 89 c2             	mov    %rax,%rdx
  801ce9:	be 00 00 00 00       	mov    $0x0,%esi
  801cee:	bf 11 00 00 00       	mov    $0x11,%edi
  801cf3:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801cfa:	00 00 00 
  801cfd:	ff d0                	callq  *%rax
  801cff:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d03:	c9                   	leaveq 
  801d04:	c3                   	retq   

0000000000801d05 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	48 83 ec 10          	sub    $0x10,%rsp
  801d0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1d:	48 83 ec 08          	sub    $0x8,%rsp
  801d21:	6a 00                	pushq  $0x0
  801d23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2f:	48 89 d1             	mov    %rdx,%rcx
  801d32:	48 89 c2             	mov    %rax,%rdx
  801d35:	be 00 00 00 00       	mov    $0x0,%esi
  801d3a:	bf 12 00 00 00       	mov    $0x12,%edi
  801d3f:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
  801d4b:	48 83 c4 10          	add    $0x10,%rsp
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 08          	sub    $0x8,%rsp
  801d59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d5d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d61:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d68:	ff ff ff 
  801d6b:	48 01 d0             	add    %rdx,%rax
  801d6e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d72:	c9                   	leaveq 
  801d73:	c3                   	retq   

0000000000801d74 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d74:	55                   	push   %rbp
  801d75:	48 89 e5             	mov    %rsp,%rbp
  801d78:	48 83 ec 08          	sub    $0x8,%rsp
  801d7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d84:	48 89 c7             	mov    %rax,%rdi
  801d87:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
  801d93:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d99:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d9d:	c9                   	leaveq 
  801d9e:	c3                   	retq   

0000000000801d9f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d9f:	55                   	push   %rbp
  801da0:	48 89 e5             	mov    %rsp,%rbp
  801da3:	48 83 ec 18          	sub    $0x18,%rsp
  801da7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801db2:	eb 6b                	jmp    801e1f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db7:	48 98                	cltq   
  801db9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dbf:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dcb:	48 c1 e8 15          	shr    $0x15,%rax
  801dcf:	48 89 c2             	mov    %rax,%rdx
  801dd2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dd9:	01 00 00 
  801ddc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de0:	83 e0 01             	and    $0x1,%eax
  801de3:	48 85 c0             	test   %rax,%rax
  801de6:	74 21                	je     801e09 <fd_alloc+0x6a>
  801de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dec:	48 c1 e8 0c          	shr    $0xc,%rax
  801df0:	48 89 c2             	mov    %rax,%rdx
  801df3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dfa:	01 00 00 
  801dfd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e01:	83 e0 01             	and    $0x1,%eax
  801e04:	48 85 c0             	test   %rax,%rax
  801e07:	75 12                	jne    801e1b <fd_alloc+0x7c>
			*fd_store = fd;
  801e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e11:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	eb 1a                	jmp    801e35 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e1b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e1f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e23:	7e 8f                	jle    801db4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e29:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e30:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e35:	c9                   	leaveq 
  801e36:	c3                   	retq   

0000000000801e37 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e37:	55                   	push   %rbp
  801e38:	48 89 e5             	mov    %rsp,%rbp
  801e3b:	48 83 ec 20          	sub    $0x20,%rsp
  801e3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e46:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e4a:	78 06                	js     801e52 <fd_lookup+0x1b>
  801e4c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e50:	7e 07                	jle    801e59 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e57:	eb 6c                	jmp    801ec5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e5c:	48 98                	cltq   
  801e5e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e64:	48 c1 e0 0c          	shl    $0xc,%rax
  801e68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e70:	48 c1 e8 15          	shr    $0x15,%rax
  801e74:	48 89 c2             	mov    %rax,%rdx
  801e77:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e7e:	01 00 00 
  801e81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e85:	83 e0 01             	and    $0x1,%eax
  801e88:	48 85 c0             	test   %rax,%rax
  801e8b:	74 21                	je     801eae <fd_lookup+0x77>
  801e8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e91:	48 c1 e8 0c          	shr    $0xc,%rax
  801e95:	48 89 c2             	mov    %rax,%rdx
  801e98:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e9f:	01 00 00 
  801ea2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea6:	83 e0 01             	and    $0x1,%eax
  801ea9:	48 85 c0             	test   %rax,%rax
  801eac:	75 07                	jne    801eb5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb3:	eb 10                	jmp    801ec5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801eb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ebd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec5:	c9                   	leaveq 
  801ec6:	c3                   	retq   

0000000000801ec7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	48 83 ec 30          	sub    $0x30,%rsp
  801ecf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ed3:	89 f0                	mov    %esi,%eax
  801ed5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ed8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edc:	48 89 c7             	mov    %rax,%rdi
  801edf:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  801ee6:	00 00 00 
  801ee9:	ff d0                	callq  *%rax
  801eeb:	89 c2                	mov    %eax,%edx
  801eed:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ef1:	48 89 c6             	mov    %rax,%rsi
  801ef4:	89 d7                	mov    %edx,%edi
  801ef6:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f09:	78 0a                	js     801f15 <fd_close+0x4e>
	    || fd != fd2)
  801f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f13:	74 12                	je     801f27 <fd_close+0x60>
		return (must_exist ? r : 0);
  801f15:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f19:	74 05                	je     801f20 <fd_close+0x59>
  801f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1e:	eb 70                	jmp    801f90 <fd_close+0xc9>
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	eb 69                	jmp    801f90 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f2b:	8b 00                	mov    (%rax),%eax
  801f2d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f31:	48 89 d6             	mov    %rdx,%rsi
  801f34:	89 c7                	mov    %eax,%edi
  801f36:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  801f3d:	00 00 00 
  801f40:	ff d0                	callq  *%rax
  801f42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f49:	78 2a                	js     801f75 <fd_close+0xae>
		if (dev->dev_close)
  801f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f53:	48 85 c0             	test   %rax,%rax
  801f56:	74 16                	je     801f6e <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f5c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f64:	48 89 d7             	mov    %rdx,%rdi
  801f67:	ff d0                	callq  *%rax
  801f69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f6c:	eb 07                	jmp    801f75 <fd_close+0xae>
		else
			r = 0;
  801f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f79:	48 89 c6             	mov    %rax,%rsi
  801f7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f81:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  801f88:	00 00 00 
  801f8b:	ff d0                	callq  *%rax
	return r;
  801f8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f90:	c9                   	leaveq 
  801f91:	c3                   	retq   

0000000000801f92 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f92:	55                   	push   %rbp
  801f93:	48 89 e5             	mov    %rsp,%rbp
  801f96:	48 83 ec 20          	sub    $0x20,%rsp
  801f9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fa8:	eb 41                	jmp    801feb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801faa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fb1:	00 00 00 
  801fb4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb7:	48 63 d2             	movslq %edx,%rdx
  801fba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbe:	8b 00                	mov    (%rax),%eax
  801fc0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fc3:	75 22                	jne    801fe7 <dev_lookup+0x55>
			*dev = devtab[i];
  801fc5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fcc:	00 00 00 
  801fcf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fd2:	48 63 d2             	movslq %edx,%rdx
  801fd5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe5:	eb 60                	jmp    802047 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fe7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801feb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ff2:	00 00 00 
  801ff5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff8:	48 63 d2             	movslq %edx,%rdx
  801ffb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fff:	48 85 c0             	test   %rax,%rax
  802002:	75 a6                	jne    801faa <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802004:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80200b:	00 00 00 
  80200e:	48 8b 00             	mov    (%rax),%rax
  802011:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802017:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80201a:	89 c6                	mov    %eax,%esi
  80201c:	48 bf 58 47 80 00 00 	movabs $0x804758,%rdi
  802023:	00 00 00 
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
  80202b:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  802032:	00 00 00 
  802035:	ff d1                	callq  *%rcx
	*dev = 0;
  802037:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80203b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802042:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802047:	c9                   	leaveq 
  802048:	c3                   	retq   

0000000000802049 <close>:

int
close(int fdnum)
{
  802049:	55                   	push   %rbp
  80204a:	48 89 e5             	mov    %rsp,%rbp
  80204d:	48 83 ec 20          	sub    $0x20,%rsp
  802051:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802054:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802058:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80205b:	48 89 d6             	mov    %rdx,%rsi
  80205e:	89 c7                	mov    %eax,%edi
  802060:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  802067:	00 00 00 
  80206a:	ff d0                	callq  *%rax
  80206c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802073:	79 05                	jns    80207a <close+0x31>
		return r;
  802075:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802078:	eb 18                	jmp    802092 <close+0x49>
	else
		return fd_close(fd, 1);
  80207a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207e:	be 01 00 00 00       	mov    $0x1,%esi
  802083:	48 89 c7             	mov    %rax,%rdi
  802086:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  80208d:	00 00 00 
  802090:	ff d0                	callq  *%rax
}
  802092:	c9                   	leaveq 
  802093:	c3                   	retq   

0000000000802094 <close_all>:

void
close_all(void)
{
  802094:	55                   	push   %rbp
  802095:	48 89 e5             	mov    %rsp,%rbp
  802098:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80209c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020a3:	eb 15                	jmp    8020ba <close_all+0x26>
		close(i);
  8020a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a8:	89 c7                	mov    %eax,%edi
  8020aa:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8020b1:	00 00 00 
  8020b4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020ba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020be:	7e e5                	jle    8020a5 <close_all+0x11>
		close(i);
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leaveq 
  8020c2:	c3                   	retq   

00000000008020c3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020c3:	55                   	push   %rbp
  8020c4:	48 89 e5             	mov    %rsp,%rbp
  8020c7:	48 83 ec 40          	sub    $0x40,%rsp
  8020cb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020ce:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020d1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020d5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020d8:	48 89 d6             	mov    %rdx,%rsi
  8020db:	89 c7                	mov    %eax,%edi
  8020dd:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	callq  *%rax
  8020e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020f0:	79 08                	jns    8020fa <dup+0x37>
		return r;
  8020f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f5:	e9 70 01 00 00       	jmpq   80226a <dup+0x1a7>
	close(newfdnum);
  8020fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020fd:	89 c7                	mov    %eax,%edi
  8020ff:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80210b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80210e:	48 98                	cltq   
  802110:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802116:	48 c1 e0 0c          	shl    $0xc,%rax
  80211a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80211e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802122:	48 89 c7             	mov    %rax,%rdi
  802125:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	callq  *%rax
  802131:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802135:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802139:	48 89 c7             	mov    %rax,%rdi
  80213c:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  802143:	00 00 00 
  802146:	ff d0                	callq  *%rax
  802148:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802150:	48 c1 e8 15          	shr    $0x15,%rax
  802154:	48 89 c2             	mov    %rax,%rdx
  802157:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80215e:	01 00 00 
  802161:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802165:	83 e0 01             	and    $0x1,%eax
  802168:	48 85 c0             	test   %rax,%rax
  80216b:	74 71                	je     8021de <dup+0x11b>
  80216d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802171:	48 c1 e8 0c          	shr    $0xc,%rax
  802175:	48 89 c2             	mov    %rax,%rdx
  802178:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80217f:	01 00 00 
  802182:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802186:	83 e0 01             	and    $0x1,%eax
  802189:	48 85 c0             	test   %rax,%rax
  80218c:	74 50                	je     8021de <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80218e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802192:	48 c1 e8 0c          	shr    $0xc,%rax
  802196:	48 89 c2             	mov    %rax,%rdx
  802199:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a0:	01 00 00 
  8021a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8021ac:	89 c1                	mov    %eax,%ecx
  8021ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b6:	41 89 c8             	mov    %ecx,%r8d
  8021b9:	48 89 d1             	mov    %rdx,%rcx
  8021bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c1:	48 89 c6             	mov    %rax,%rsi
  8021c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c9:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	callq  *%rax
  8021d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021dc:	78 55                	js     802233 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e2:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e6:	48 89 c2             	mov    %rax,%rdx
  8021e9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021f0:	01 00 00 
  8021f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8021fc:	89 c1                	mov    %eax,%ecx
  8021fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802202:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802206:	41 89 c8             	mov    %ecx,%r8d
  802209:	48 89 d1             	mov    %rdx,%rcx
  80220c:	ba 00 00 00 00       	mov    $0x0,%edx
  802211:	48 89 c6             	mov    %rax,%rsi
  802214:	bf 00 00 00 00       	mov    $0x0,%edi
  802219:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  802220:	00 00 00 
  802223:	ff d0                	callq  *%rax
  802225:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802228:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222c:	78 08                	js     802236 <dup+0x173>
		goto err;

	return newfdnum;
  80222e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802231:	eb 37                	jmp    80226a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802233:	90                   	nop
  802234:	eb 01                	jmp    802237 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802236:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223b:	48 89 c6             	mov    %rax,%rsi
  80223e:	bf 00 00 00 00       	mov    $0x0,%edi
  802243:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80224f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802253:	48 89 c6             	mov    %rax,%rsi
  802256:	bf 00 00 00 00       	mov    $0x0,%edi
  80225b:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
	return r;
  802267:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80226a:	c9                   	leaveq 
  80226b:	c3                   	retq   

000000000080226c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80226c:	55                   	push   %rbp
  80226d:	48 89 e5             	mov    %rsp,%rbp
  802270:	48 83 ec 40          	sub    $0x40,%rsp
  802274:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802277:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80227b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80227f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802283:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802286:	48 89 d6             	mov    %rdx,%rsi
  802289:	89 c7                	mov    %eax,%edi
  80228b:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  802292:	00 00 00 
  802295:	ff d0                	callq  *%rax
  802297:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229e:	78 24                	js     8022c4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a4:	8b 00                	mov    (%rax),%eax
  8022a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022aa:	48 89 d6             	mov    %rdx,%rsi
  8022ad:	89 c7                	mov    %eax,%edi
  8022af:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	callq  *%rax
  8022bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c2:	79 05                	jns    8022c9 <read+0x5d>
		return r;
  8022c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c7:	eb 76                	jmp    80233f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	8b 40 08             	mov    0x8(%rax),%eax
  8022d0:	83 e0 03             	and    $0x3,%eax
  8022d3:	83 f8 01             	cmp    $0x1,%eax
  8022d6:	75 3a                	jne    802312 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022d8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022df:	00 00 00 
  8022e2:	48 8b 00             	mov    (%rax),%rax
  8022e5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022eb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022ee:	89 c6                	mov    %eax,%esi
  8022f0:	48 bf 77 47 80 00 00 	movabs $0x804777,%rdi
  8022f7:	00 00 00 
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  802306:	00 00 00 
  802309:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80230b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802310:	eb 2d                	jmp    80233f <read+0xd3>
	}
	if (!dev->dev_read)
  802312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802316:	48 8b 40 10          	mov    0x10(%rax),%rax
  80231a:	48 85 c0             	test   %rax,%rax
  80231d:	75 07                	jne    802326 <read+0xba>
		return -E_NOT_SUPP;
  80231f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802324:	eb 19                	jmp    80233f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80232e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802332:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802336:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80233a:	48 89 cf             	mov    %rcx,%rdi
  80233d:	ff d0                	callq  *%rax
}
  80233f:	c9                   	leaveq 
  802340:	c3                   	retq   

0000000000802341 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802341:	55                   	push   %rbp
  802342:	48 89 e5             	mov    %rsp,%rbp
  802345:	48 83 ec 30          	sub    $0x30,%rsp
  802349:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80234c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802350:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80235b:	eb 47                	jmp    8023a4 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80235d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802360:	48 98                	cltq   
  802362:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802366:	48 29 c2             	sub    %rax,%rdx
  802369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236c:	48 63 c8             	movslq %eax,%rcx
  80236f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802373:	48 01 c1             	add    %rax,%rcx
  802376:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802379:	48 89 ce             	mov    %rcx,%rsi
  80237c:	89 c7                	mov    %eax,%edi
  80237e:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802385:	00 00 00 
  802388:	ff d0                	callq  *%rax
  80238a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80238d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802391:	79 05                	jns    802398 <readn+0x57>
			return m;
  802393:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802396:	eb 1d                	jmp    8023b5 <readn+0x74>
		if (m == 0)
  802398:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80239c:	74 13                	je     8023b1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80239e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023a1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a7:	48 98                	cltq   
  8023a9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023ad:	72 ae                	jb     80235d <readn+0x1c>
  8023af:	eb 01                	jmp    8023b2 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023b1:	90                   	nop
	}
	return tot;
  8023b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023b5:	c9                   	leaveq 
  8023b6:	c3                   	retq   

00000000008023b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023b7:	55                   	push   %rbp
  8023b8:	48 89 e5             	mov    %rsp,%rbp
  8023bb:	48 83 ec 40          	sub    $0x40,%rsp
  8023bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	78 24                	js     80240f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ef:	8b 00                	mov    (%rax),%eax
  8023f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f5:	48 89 d6             	mov    %rdx,%rsi
  8023f8:	89 c7                	mov    %eax,%edi
  8023fa:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  802401:	00 00 00 
  802404:	ff d0                	callq  *%rax
  802406:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802409:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240d:	79 05                	jns    802414 <write+0x5d>
		return r;
  80240f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802412:	eb 75                	jmp    802489 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802418:	8b 40 08             	mov    0x8(%rax),%eax
  80241b:	83 e0 03             	and    $0x3,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	75 3a                	jne    80245c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802422:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802429:	00 00 00 
  80242c:	48 8b 00             	mov    (%rax),%rax
  80242f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802435:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802438:	89 c6                	mov    %eax,%esi
  80243a:	48 bf 93 47 80 00 00 	movabs $0x804793,%rdi
  802441:	00 00 00 
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
  802449:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  802450:	00 00 00 
  802453:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80245a:	eb 2d                	jmp    802489 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80245c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802460:	48 8b 40 18          	mov    0x18(%rax),%rax
  802464:	48 85 c0             	test   %rax,%rax
  802467:	75 07                	jne    802470 <write+0xb9>
		return -E_NOT_SUPP;
  802469:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80246e:	eb 19                	jmp    802489 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802474:	48 8b 40 18          	mov    0x18(%rax),%rax
  802478:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80247c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802480:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802484:	48 89 cf             	mov    %rcx,%rdi
  802487:	ff d0                	callq  *%rax
}
  802489:	c9                   	leaveq 
  80248a:	c3                   	retq   

000000000080248b <seek>:

int
seek(int fdnum, off_t offset)
{
  80248b:	55                   	push   %rbp
  80248c:	48 89 e5             	mov    %rsp,%rbp
  80248f:	48 83 ec 18          	sub    $0x18,%rsp
  802493:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802496:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802499:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80249d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a0:	48 89 d6             	mov    %rdx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b8:	79 05                	jns    8024bf <seek+0x34>
		return r;
  8024ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bd:	eb 0f                	jmp    8024ce <seek+0x43>
	fd->fd_offset = offset;
  8024bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024c6:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ce:	c9                   	leaveq 
  8024cf:	c3                   	retq   

00000000008024d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024d0:	55                   	push   %rbp
  8024d1:	48 89 e5             	mov    %rsp,%rbp
  8024d4:	48 83 ec 30          	sub    $0x30,%rsp
  8024d8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024db:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024e5:	48 89 d6             	mov    %rdx,%rsi
  8024e8:	89 c7                	mov    %eax,%edi
  8024ea:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	callq  *%rax
  8024f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fd:	78 24                	js     802523 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802503:	8b 00                	mov    (%rax),%eax
  802505:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802509:	48 89 d6             	mov    %rdx,%rsi
  80250c:	89 c7                	mov    %eax,%edi
  80250e:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  802515:	00 00 00 
  802518:	ff d0                	callq  *%rax
  80251a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802521:	79 05                	jns    802528 <ftruncate+0x58>
		return r;
  802523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802526:	eb 72                	jmp    80259a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252c:	8b 40 08             	mov    0x8(%rax),%eax
  80252f:	83 e0 03             	and    $0x3,%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	75 3a                	jne    802570 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802536:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80253d:	00 00 00 
  802540:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802543:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802549:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80254c:	89 c6                	mov    %eax,%esi
  80254e:	48 bf b0 47 80 00 00 	movabs $0x8047b0,%rdi
  802555:	00 00 00 
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  802564:	00 00 00 
  802567:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802569:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80256e:	eb 2a                	jmp    80259a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802574:	48 8b 40 30          	mov    0x30(%rax),%rax
  802578:	48 85 c0             	test   %rax,%rax
  80257b:	75 07                	jne    802584 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80257d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802582:	eb 16                	jmp    80259a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802588:	48 8b 40 30          	mov    0x30(%rax),%rax
  80258c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802590:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802593:	89 ce                	mov    %ecx,%esi
  802595:	48 89 d7             	mov    %rdx,%rdi
  802598:	ff d0                	callq  *%rax
}
  80259a:	c9                   	leaveq 
  80259b:	c3                   	retq   

000000000080259c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80259c:	55                   	push   %rbp
  80259d:	48 89 e5             	mov    %rsp,%rbp
  8025a0:	48 83 ec 30          	sub    $0x30,%rsp
  8025a4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025b2:	48 89 d6             	mov    %rdx,%rsi
  8025b5:	89 c7                	mov    %eax,%edi
  8025b7:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
  8025c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ca:	78 24                	js     8025f0 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d0:	8b 00                	mov    (%rax),%eax
  8025d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025d6:	48 89 d6             	mov    %rdx,%rsi
  8025d9:	89 c7                	mov    %eax,%edi
  8025db:	48 b8 92 1f 80 00 00 	movabs $0x801f92,%rax
  8025e2:	00 00 00 
  8025e5:	ff d0                	callq  *%rax
  8025e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ee:	79 05                	jns    8025f5 <fstat+0x59>
		return r;
  8025f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f3:	eb 5e                	jmp    802653 <fstat+0xb7>
	if (!dev->dev_stat)
  8025f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025fd:	48 85 c0             	test   %rax,%rax
  802600:	75 07                	jne    802609 <fstat+0x6d>
		return -E_NOT_SUPP;
  802602:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802607:	eb 4a                	jmp    802653 <fstat+0xb7>
	stat->st_name[0] = 0;
  802609:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80260d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802610:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802614:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80261b:	00 00 00 
	stat->st_isdir = 0;
  80261e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802622:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802629:	00 00 00 
	stat->st_dev = dev;
  80262c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802630:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802634:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80263b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802647:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80264b:	48 89 ce             	mov    %rcx,%rsi
  80264e:	48 89 d7             	mov    %rdx,%rdi
  802651:	ff d0                	callq  *%rax
}
  802653:	c9                   	leaveq 
  802654:	c3                   	retq   

0000000000802655 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802655:	55                   	push   %rbp
  802656:	48 89 e5             	mov    %rsp,%rbp
  802659:	48 83 ec 20          	sub    $0x20,%rsp
  80265d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802661:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802669:	be 00 00 00 00       	mov    $0x0,%esi
  80266e:	48 89 c7             	mov    %rax,%rdi
  802671:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  802678:	00 00 00 
  80267b:	ff d0                	callq  *%rax
  80267d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802680:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802684:	79 05                	jns    80268b <stat+0x36>
		return fd;
  802686:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802689:	eb 2f                	jmp    8026ba <stat+0x65>
	r = fstat(fd, stat);
  80268b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80268f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802692:	48 89 d6             	mov    %rdx,%rsi
  802695:	89 c7                	mov    %eax,%edi
  802697:	48 b8 9c 25 80 00 00 	movabs $0x80259c,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
  8026a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a9:	89 c7                	mov    %eax,%edi
  8026ab:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
	return r;
  8026b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026ba:	c9                   	leaveq 
  8026bb:	c3                   	retq   

00000000008026bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026bc:	55                   	push   %rbp
  8026bd:	48 89 e5             	mov    %rsp,%rbp
  8026c0:	48 83 ec 10          	sub    $0x10,%rsp
  8026c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026cb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026d2:	00 00 00 
  8026d5:	8b 00                	mov    (%rax),%eax
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	75 1f                	jne    8026fa <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026db:	bf 01 00 00 00       	mov    $0x1,%edi
  8026e0:	48 b8 cc 40 80 00 00 	movabs $0x8040cc,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	89 c2                	mov    %eax,%edx
  8026ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f5:	00 00 00 
  8026f8:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026fa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802701:	00 00 00 
  802704:	8b 00                	mov    (%rax),%eax
  802706:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802709:	b9 07 00 00 00       	mov    $0x7,%ecx
  80270e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802715:	00 00 00 
  802718:	89 c7                	mov    %eax,%edi
  80271a:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272a:	ba 00 00 00 00       	mov    $0x0,%edx
  80272f:	48 89 c6             	mov    %rax,%rsi
  802732:	bf 00 00 00 00       	mov    $0x0,%edi
  802737:	48 b8 ff 3d 80 00 00 	movabs $0x803dff,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
}
  802743:	c9                   	leaveq 
  802744:	c3                   	retq   

0000000000802745 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802745:	55                   	push   %rbp
  802746:	48 89 e5             	mov    %rsp,%rbp
  802749:	48 83 ec 20          	sub    $0x20,%rsp
  80274d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802751:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802758:	48 89 c7             	mov    %rax,%rdi
  80275b:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax
  802767:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80276c:	7e 0a                	jle    802778 <open+0x33>
		return -E_BAD_PATH;
  80276e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802773:	e9 a5 00 00 00       	jmpq   80281d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802778:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80277c:	48 89 c7             	mov    %rax,%rdi
  80277f:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
  80278b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802792:	79 08                	jns    80279c <open+0x57>
		return r;
  802794:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802797:	e9 81 00 00 00       	jmpq   80281d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	48 89 c6             	mov    %rax,%rsi
  8027a3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027aa:	00 00 00 
  8027ad:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8027b4:	00 00 00 
  8027b7:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8027b9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027c0:	00 00 00 
  8027c3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027c6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8027cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d0:	48 89 c6             	mov    %rax,%rsi
  8027d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8027d8:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	callq  *%rax
  8027e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027eb:	79 1d                	jns    80280a <open+0xc5>
		fd_close(fd, 0);
  8027ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f1:	be 00 00 00 00       	mov    $0x0,%esi
  8027f6:	48 89 c7             	mov    %rax,%rdi
  8027f9:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
		return r;
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802808:	eb 13                	jmp    80281d <open+0xd8>
	}

	return fd2num(fd);
  80280a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280e:	48 89 c7             	mov    %rax,%rdi
  802811:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  802818:	00 00 00 
  80281b:	ff d0                	callq  *%rax

}
  80281d:	c9                   	leaveq 
  80281e:	c3                   	retq   

000000000080281f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80281f:	55                   	push   %rbp
  802820:	48 89 e5             	mov    %rsp,%rbp
  802823:	48 83 ec 10          	sub    $0x10,%rsp
  802827:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80282b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282f:	8b 50 0c             	mov    0xc(%rax),%edx
  802832:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802839:	00 00 00 
  80283c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80283e:	be 00 00 00 00       	mov    $0x0,%esi
  802843:	bf 06 00 00 00       	mov    $0x6,%edi
  802848:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
}
  802854:	c9                   	leaveq 
  802855:	c3                   	retq   

0000000000802856 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802856:	55                   	push   %rbp
  802857:	48 89 e5             	mov    %rsp,%rbp
  80285a:	48 83 ec 30          	sub    $0x30,%rsp
  80285e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802862:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802866:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80286a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286e:	8b 50 0c             	mov    0xc(%rax),%edx
  802871:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802878:	00 00 00 
  80287b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80287d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802884:	00 00 00 
  802887:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80288b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80288f:	be 00 00 00 00       	mov    $0x0,%esi
  802894:	bf 03 00 00 00       	mov    $0x3,%edi
  802899:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	callq  *%rax
  8028a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ac:	79 08                	jns    8028b6 <devfile_read+0x60>
		return r;
  8028ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b1:	e9 a4 00 00 00       	jmpq   80295a <devfile_read+0x104>
	assert(r <= n);
  8028b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b9:	48 98                	cltq   
  8028bb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028bf:	76 35                	jbe    8028f6 <devfile_read+0xa0>
  8028c1:	48 b9 d6 47 80 00 00 	movabs $0x8047d6,%rcx
  8028c8:	00 00 00 
  8028cb:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  8028d2:	00 00 00 
  8028d5:	be 86 00 00 00       	mov    $0x86,%esi
  8028da:	48 bf f2 47 80 00 00 	movabs $0x8047f2,%rdi
  8028e1:	00 00 00 
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e9:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  8028f0:	00 00 00 
  8028f3:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8028f6:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8028fd:	7e 35                	jle    802934 <devfile_read+0xde>
  8028ff:	48 b9 fd 47 80 00 00 	movabs $0x8047fd,%rcx
  802906:	00 00 00 
  802909:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  802910:	00 00 00 
  802913:	be 87 00 00 00       	mov    $0x87,%esi
  802918:	48 bf f2 47 80 00 00 	movabs $0x8047f2,%rdi
  80291f:	00 00 00 
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  80292e:	00 00 00 
  802931:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802937:	48 63 d0             	movslq %eax,%rdx
  80293a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80293e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802945:	00 00 00 
  802948:	48 89 c7             	mov    %rax,%rdi
  80294b:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  802952:	00 00 00 
  802955:	ff d0                	callq  *%rax
	return r;
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80295a:	c9                   	leaveq 
  80295b:	c3                   	retq   

000000000080295c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80295c:	55                   	push   %rbp
  80295d:	48 89 e5             	mov    %rsp,%rbp
  802960:	48 83 ec 40          	sub    $0x40,%rsp
  802964:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802968:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80296c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802970:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802974:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802978:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80297f:	00 
  802980:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802984:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802988:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80298d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802995:	8b 50 0c             	mov    0xc(%rax),%edx
  802998:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80299f:	00 00 00 
  8029a2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8029a4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ab:	00 00 00 
  8029ae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029b2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8029b6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029be:	48 89 c6             	mov    %rax,%rsi
  8029c1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029c8:	00 00 00 
  8029cb:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  8029d2:	00 00 00 
  8029d5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8029d7:	be 00 00 00 00       	mov    $0x0,%esi
  8029dc:	bf 04 00 00 00       	mov    $0x4,%edi
  8029e1:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
  8029ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029f4:	79 05                	jns    8029fb <devfile_write+0x9f>
		return r;
  8029f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029f9:	eb 43                	jmp    802a3e <devfile_write+0xe2>
	assert(r <= n);
  8029fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029fe:	48 98                	cltq   
  802a00:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a04:	76 35                	jbe    802a3b <devfile_write+0xdf>
  802a06:	48 b9 d6 47 80 00 00 	movabs $0x8047d6,%rcx
  802a0d:	00 00 00 
  802a10:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  802a17:	00 00 00 
  802a1a:	be a2 00 00 00       	mov    $0xa2,%esi
  802a1f:	48 bf f2 47 80 00 00 	movabs $0x8047f2,%rdi
  802a26:	00 00 00 
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  802a35:	00 00 00 
  802a38:	41 ff d0             	callq  *%r8
	return r;
  802a3b:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802a3e:	c9                   	leaveq 
  802a3f:	c3                   	retq   

0000000000802a40 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a40:	55                   	push   %rbp
  802a41:	48 89 e5             	mov    %rsp,%rbp
  802a44:	48 83 ec 20          	sub    $0x20,%rsp
  802a48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a54:	8b 50 0c             	mov    0xc(%rax),%edx
  802a57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a5e:	00 00 00 
  802a61:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a63:	be 00 00 00 00       	mov    $0x0,%esi
  802a68:	bf 05 00 00 00       	mov    $0x5,%edi
  802a6d:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
  802a79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a80:	79 05                	jns    802a87 <devfile_stat+0x47>
		return r;
  802a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a85:	eb 56                	jmp    802add <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a92:	00 00 00 
  802a95:	48 89 c7             	mov    %rax,%rdi
  802a98:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802aa4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aab:	00 00 00 
  802aae:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ab4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802abe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac5:	00 00 00 
  802ac8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ace:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802add:	c9                   	leaveq 
  802ade:	c3                   	retq   

0000000000802adf <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802adf:	55                   	push   %rbp
  802ae0:	48 89 e5             	mov    %rsp,%rbp
  802ae3:	48 83 ec 10          	sub    $0x10,%rsp
  802ae7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aeb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af2:	8b 50 0c             	mov    0xc(%rax),%edx
  802af5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802afc:	00 00 00 
  802aff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b08:	00 00 00 
  802b0b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b0e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b11:	be 00 00 00 00       	mov    $0x0,%esi
  802b16:	bf 02 00 00 00       	mov    $0x2,%edi
  802b1b:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  802b22:	00 00 00 
  802b25:	ff d0                	callq  *%rax
}
  802b27:	c9                   	leaveq 
  802b28:	c3                   	retq   

0000000000802b29 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b29:	55                   	push   %rbp
  802b2a:	48 89 e5             	mov    %rsp,%rbp
  802b2d:	48 83 ec 10          	sub    $0x10,%rsp
  802b31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b39:	48 89 c7             	mov    %rax,%rdi
  802b3c:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	callq  *%rax
  802b48:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b4d:	7e 07                	jle    802b56 <remove+0x2d>
		return -E_BAD_PATH;
  802b4f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b54:	eb 33                	jmp    802b89 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b5a:	48 89 c6             	mov    %rax,%rsi
  802b5d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b64:	00 00 00 
  802b67:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802b6e:	00 00 00 
  802b71:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b73:	be 00 00 00 00       	mov    $0x0,%esi
  802b78:	bf 07 00 00 00       	mov    $0x7,%edi
  802b7d:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
}
  802b89:	c9                   	leaveq 
  802b8a:	c3                   	retq   

0000000000802b8b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b8b:	55                   	push   %rbp
  802b8c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b8f:	be 00 00 00 00       	mov    $0x0,%esi
  802b94:	bf 08 00 00 00       	mov    $0x8,%edi
  802b99:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
}
  802ba5:	5d                   	pop    %rbp
  802ba6:	c3                   	retq   

0000000000802ba7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
  802bab:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802bb2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802bb9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802bc0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802bc7:	be 00 00 00 00       	mov    $0x0,%esi
  802bcc:	48 89 c7             	mov    %rax,%rdi
  802bcf:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
  802bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be2:	79 28                	jns    802c0c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be7:	89 c6                	mov    %eax,%esi
  802be9:	48 bf 09 48 80 00 00 	movabs $0x804809,%rdi
  802bf0:	00 00 00 
  802bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf8:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802bff:	00 00 00 
  802c02:	ff d2                	callq  *%rdx
		return fd_src;
  802c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c07:	e9 76 01 00 00       	jmpq   802d82 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c0c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c13:	be 01 01 00 00       	mov    $0x101,%esi
  802c18:	48 89 c7             	mov    %rax,%rdi
  802c1b:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c2a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c2e:	0f 89 ad 00 00 00    	jns    802ce1 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c37:	89 c6                	mov    %eax,%esi
  802c39:	48 bf 1f 48 80 00 00 	movabs $0x80481f,%rdi
  802c40:	00 00 00 
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
  802c48:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802c4f:	00 00 00 
  802c52:	ff d2                	callq  *%rdx
		close(fd_src);
  802c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
		return fd_dest;
  802c65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c68:	e9 15 01 00 00       	jmpq   802d82 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802c6d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c70:	48 63 d0             	movslq %eax,%rdx
  802c73:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c7d:	48 89 ce             	mov    %rcx,%rsi
  802c80:	89 c7                	mov    %eax,%edi
  802c82:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  802c89:	00 00 00 
  802c8c:	ff d0                	callq  *%rax
  802c8e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c91:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c95:	79 4a                	jns    802ce1 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802c97:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c9a:	89 c6                	mov    %eax,%esi
  802c9c:	48 bf 39 48 80 00 00 	movabs $0x804839,%rdi
  802ca3:	00 00 00 
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cab:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802cb2:	00 00 00 
  802cb5:	ff d2                	callq  *%rdx
			close(fd_src);
  802cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cba:	89 c7                	mov    %eax,%edi
  802cbc:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
			close(fd_dest);
  802cc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ccb:	89 c7                	mov    %eax,%edi
  802ccd:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
			return write_size;
  802cd9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cdc:	e9 a1 00 00 00       	jmpq   802d82 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ce1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ceb:	ba 00 02 00 00       	mov    $0x200,%edx
  802cf0:	48 89 ce             	mov    %rcx,%rsi
  802cf3:	89 c7                	mov    %eax,%edi
  802cf5:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
  802d01:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d08:	0f 8f 5f ff ff ff    	jg     802c6d <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d12:	79 47                	jns    802d5b <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802d14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d17:	89 c6                	mov    %eax,%esi
  802d19:	48 bf 4c 48 80 00 00 	movabs $0x80484c,%rdi
  802d20:	00 00 00 
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
  802d28:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802d2f:	00 00 00 
  802d32:	ff d2                	callq  *%rdx
		close(fd_src);
  802d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d37:	89 c7                	mov    %eax,%edi
  802d39:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
		close(fd_dest);
  802d45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d48:	89 c7                	mov    %eax,%edi
  802d4a:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
		return read_size;
  802d56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d59:	eb 27                	jmp    802d82 <copy+0x1db>
	}
	close(fd_src);
  802d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5e:	89 c7                	mov    %eax,%edi
  802d60:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802d67:	00 00 00 
  802d6a:	ff d0                	callq  *%rax
	close(fd_dest);
  802d6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d6f:	89 c7                	mov    %eax,%edi
  802d71:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  802d78:	00 00 00 
  802d7b:	ff d0                	callq  *%rax
	return 0;
  802d7d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d82:	c9                   	leaveq 
  802d83:	c3                   	retq   

0000000000802d84 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d84:	55                   	push   %rbp
  802d85:	48 89 e5             	mov    %rsp,%rbp
  802d88:	48 83 ec 20          	sub    $0x20,%rsp
  802d8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d96:	48 89 d6             	mov    %rdx,%rsi
  802d99:	89 c7                	mov    %eax,%edi
  802d9b:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
  802da7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dae:	79 05                	jns    802db5 <fd2sockid+0x31>
		return r;
  802db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db3:	eb 24                	jmp    802dd9 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db9:	8b 10                	mov    (%rax),%edx
  802dbb:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802dc2:	00 00 00 
  802dc5:	8b 00                	mov    (%rax),%eax
  802dc7:	39 c2                	cmp    %eax,%edx
  802dc9:	74 07                	je     802dd2 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802dcb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dd0:	eb 07                	jmp    802dd9 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802dd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd6:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802dd9:	c9                   	leaveq 
  802dda:	c3                   	retq   

0000000000802ddb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ddb:	55                   	push   %rbp
  802ddc:	48 89 e5             	mov    %rsp,%rbp
  802ddf:	48 83 ec 20          	sub    $0x20,%rsp
  802de3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802de6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dea:	48 89 c7             	mov    %rax,%rdi
  802ded:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
  802df9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e00:	78 26                	js     802e28 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e06:	ba 07 04 00 00       	mov    $0x407,%edx
  802e0b:	48 89 c6             	mov    %rax,%rsi
  802e0e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e13:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
  802e1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e26:	79 16                	jns    802e3e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e2b:	89 c7                	mov    %eax,%edi
  802e2d:	48 b8 ea 32 80 00 00 	movabs $0x8032ea,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
		return r;
  802e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3c:	eb 3a                	jmp    802e78 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e42:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e49:	00 00 00 
  802e4c:	8b 12                	mov    (%rdx),%edx
  802e4e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e54:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e62:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e69:	48 89 c7             	mov    %rax,%rdi
  802e6c:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
}
  802e78:	c9                   	leaveq 
  802e79:	c3                   	retq   

0000000000802e7a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e7a:	55                   	push   %rbp
  802e7b:	48 89 e5             	mov    %rsp,%rbp
  802e7e:	48 83 ec 30          	sub    $0x30,%rsp
  802e82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e89:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e90:	89 c7                	mov    %eax,%edi
  802e92:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  802e99:	00 00 00 
  802e9c:	ff d0                	callq  *%rax
  802e9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea5:	79 05                	jns    802eac <accept+0x32>
		return r;
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	eb 3b                	jmp    802ee7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802eac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eb0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb7:	48 89 ce             	mov    %rcx,%rsi
  802eba:	89 c7                	mov    %eax,%edi
  802ebc:	48 b8 c7 31 80 00 00 	movabs $0x8031c7,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecf:	79 05                	jns    802ed6 <accept+0x5c>
		return r;
  802ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed4:	eb 11                	jmp    802ee7 <accept+0x6d>
	return alloc_sockfd(r);
  802ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed9:	89 c7                	mov    %eax,%edi
  802edb:	48 b8 db 2d 80 00 00 	movabs $0x802ddb,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
}
  802ee7:	c9                   	leaveq 
  802ee8:	c3                   	retq   

0000000000802ee9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ee9:	55                   	push   %rbp
  802eea:	48 89 e5             	mov    %rsp,%rbp
  802eed:	48 83 ec 20          	sub    $0x20,%rsp
  802ef1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ef4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ef8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802efb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802efe:	89 c7                	mov    %eax,%edi
  802f00:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
  802f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f13:	79 05                	jns    802f1a <bind+0x31>
		return r;
  802f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f18:	eb 1b                	jmp    802f35 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f1a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f1d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f24:	48 89 ce             	mov    %rcx,%rsi
  802f27:	89 c7                	mov    %eax,%edi
  802f29:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
}
  802f35:	c9                   	leaveq 
  802f36:	c3                   	retq   

0000000000802f37 <shutdown>:

int
shutdown(int s, int how)
{
  802f37:	55                   	push   %rbp
  802f38:	48 89 e5             	mov    %rsp,%rbp
  802f3b:	48 83 ec 20          	sub    $0x20,%rsp
  802f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f42:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f48:	89 c7                	mov    %eax,%edi
  802f4a:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5d:	79 05                	jns    802f64 <shutdown+0x2d>
		return r;
  802f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f62:	eb 16                	jmp    802f7a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f64:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6a:	89 d6                	mov    %edx,%esi
  802f6c:	89 c7                	mov    %eax,%edi
  802f6e:	48 b8 aa 32 80 00 00 	movabs $0x8032aa,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
}
  802f7a:	c9                   	leaveq 
  802f7b:	c3                   	retq   

0000000000802f7c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f7c:	55                   	push   %rbp
  802f7d:	48 89 e5             	mov    %rsp,%rbp
  802f80:	48 83 ec 10          	sub    $0x10,%rsp
  802f84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8c:	48 89 c7             	mov    %rax,%rdi
  802f8f:	48 b8 3d 41 80 00 00 	movabs $0x80413d,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
  802f9b:	83 f8 01             	cmp    $0x1,%eax
  802f9e:	75 17                	jne    802fb7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802fa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa4:	8b 40 0c             	mov    0xc(%rax),%eax
  802fa7:	89 c7                	mov    %eax,%edi
  802fa9:	48 b8 ea 32 80 00 00 	movabs $0x8032ea,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
  802fb5:	eb 05                	jmp    802fbc <devsock_close+0x40>
	else
		return 0;
  802fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fbc:	c9                   	leaveq 
  802fbd:	c3                   	retq   

0000000000802fbe <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fbe:	55                   	push   %rbp
  802fbf:	48 89 e5             	mov    %rsp,%rbp
  802fc2:	48 83 ec 20          	sub    $0x20,%rsp
  802fc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fc9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fcd:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fd3:	89 c7                	mov    %eax,%edi
  802fd5:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  802fdc:	00 00 00 
  802fdf:	ff d0                	callq  *%rax
  802fe1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe8:	79 05                	jns    802fef <connect+0x31>
		return r;
  802fea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fed:	eb 1b                	jmp    80300a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802fef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ff2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff9:	48 89 ce             	mov    %rcx,%rsi
  802ffc:	89 c7                	mov    %eax,%edi
  802ffe:	48 b8 17 33 80 00 00 	movabs $0x803317,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
}
  80300a:	c9                   	leaveq 
  80300b:	c3                   	retq   

000000000080300c <listen>:

int
listen(int s, int backlog)
{
  80300c:	55                   	push   %rbp
  80300d:	48 89 e5             	mov    %rsp,%rbp
  803010:	48 83 ec 20          	sub    $0x20,%rsp
  803014:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803017:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80301a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
  80302b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80302e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803032:	79 05                	jns    803039 <listen+0x2d>
		return r;
  803034:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803037:	eb 16                	jmp    80304f <listen+0x43>
	return nsipc_listen(r, backlog);
  803039:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80303c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303f:	89 d6                	mov    %edx,%esi
  803041:	89 c7                	mov    %eax,%edi
  803043:	48 b8 7b 33 80 00 00 	movabs $0x80337b,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
}
  80304f:	c9                   	leaveq 
  803050:	c3                   	retq   

0000000000803051 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803051:	55                   	push   %rbp
  803052:	48 89 e5             	mov    %rsp,%rbp
  803055:	48 83 ec 20          	sub    $0x20,%rsp
  803059:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803061:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803069:	89 c2                	mov    %eax,%edx
  80306b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306f:	8b 40 0c             	mov    0xc(%rax),%eax
  803072:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803076:	b9 00 00 00 00       	mov    $0x0,%ecx
  80307b:	89 c7                	mov    %eax,%edi
  80307d:	48 b8 bb 33 80 00 00 	movabs $0x8033bb,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
}
  803089:	c9                   	leaveq 
  80308a:	c3                   	retq   

000000000080308b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80308b:	55                   	push   %rbp
  80308c:	48 89 e5             	mov    %rsp,%rbp
  80308f:	48 83 ec 20          	sub    $0x20,%rsp
  803093:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803097:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80309b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80309f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a3:	89 c2                	mov    %eax,%edx
  8030a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a9:	8b 40 0c             	mov    0xc(%rax),%eax
  8030ac:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030b5:	89 c7                	mov    %eax,%edi
  8030b7:	48 b8 87 34 80 00 00 	movabs $0x803487,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
}
  8030c3:	c9                   	leaveq 
  8030c4:	c3                   	retq   

00000000008030c5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030c5:	55                   	push   %rbp
  8030c6:	48 89 e5             	mov    %rsp,%rbp
  8030c9:	48 83 ec 10          	sub    $0x10,%rsp
  8030cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d9:	48 be 67 48 80 00 00 	movabs $0x804867,%rsi
  8030e0:	00 00 00 
  8030e3:	48 89 c7             	mov    %rax,%rdi
  8030e6:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
	return 0;
  8030f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f7:	c9                   	leaveq 
  8030f8:	c3                   	retq   

00000000008030f9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8030f9:	55                   	push   %rbp
  8030fa:	48 89 e5             	mov    %rsp,%rbp
  8030fd:	48 83 ec 20          	sub    $0x20,%rsp
  803101:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803104:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803107:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80310a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80310d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803110:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803113:	89 ce                	mov    %ecx,%esi
  803115:	89 c7                	mov    %eax,%edi
  803117:	48 b8 3f 35 80 00 00 	movabs $0x80353f,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803126:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312a:	79 05                	jns    803131 <socket+0x38>
		return r;
  80312c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312f:	eb 11                	jmp    803142 <socket+0x49>
	return alloc_sockfd(r);
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	89 c7                	mov    %eax,%edi
  803136:	48 b8 db 2d 80 00 00 	movabs $0x802ddb,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
}
  803142:	c9                   	leaveq 
  803143:	c3                   	retq   

0000000000803144 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 83 ec 10          	sub    $0x10,%rsp
  80314c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80314f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803156:	00 00 00 
  803159:	8b 00                	mov    (%rax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	75 1f                	jne    80317e <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80315f:	bf 02 00 00 00       	mov    $0x2,%edi
  803164:	48 b8 cc 40 80 00 00 	movabs $0x8040cc,%rax
  80316b:	00 00 00 
  80316e:	ff d0                	callq  *%rax
  803170:	89 c2                	mov    %eax,%edx
  803172:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803179:	00 00 00 
  80317c:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80317e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803185:	00 00 00 
  803188:	8b 00                	mov    (%rax),%eax
  80318a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80318d:	b9 07 00 00 00       	mov    $0x7,%ecx
  803192:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803199:	00 00 00 
  80319c:	89 c7                	mov    %eax,%edi
  80319e:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8031aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8031af:	be 00 00 00 00       	mov    $0x0,%esi
  8031b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b9:	48 b8 ff 3d 80 00 00 	movabs $0x803dff,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
}
  8031c5:	c9                   	leaveq 
  8031c6:	c3                   	retq   

00000000008031c7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031c7:	55                   	push   %rbp
  8031c8:	48 89 e5             	mov    %rsp,%rbp
  8031cb:	48 83 ec 30          	sub    $0x30,%rsp
  8031cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e1:	00 00 00 
  8031e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031e7:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8031ee:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
  8031fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803201:	78 3e                	js     803241 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803203:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80320a:	00 00 00 
  80320d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	8b 40 10             	mov    0x10(%rax),%eax
  803218:	89 c2                	mov    %eax,%edx
  80321a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80321e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803222:	48 89 ce             	mov    %rcx,%rsi
  803225:	48 89 c7             	mov    %rax,%rdi
  803228:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803238:	8b 50 10             	mov    0x10(%rax),%edx
  80323b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803241:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803244:	c9                   	leaveq 
  803245:	c3                   	retq   

0000000000803246 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	48 83 ec 10          	sub    $0x10,%rsp
  80324e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803251:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803255:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803258:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80325f:	00 00 00 
  803262:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803265:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803267:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80326a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326e:	48 89 c6             	mov    %rax,%rsi
  803271:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803278:	00 00 00 
  80327b:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803282:	00 00 00 
  803285:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803287:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328e:	00 00 00 
  803291:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803294:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803297:	bf 02 00 00 00       	mov    $0x2,%edi
  80329c:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
}
  8032a8:	c9                   	leaveq 
  8032a9:	c3                   	retq   

00000000008032aa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8032aa:	55                   	push   %rbp
  8032ab:	48 89 e5             	mov    %rsp,%rbp
  8032ae:	48 83 ec 10          	sub    $0x10,%rsp
  8032b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032b5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8032b8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032bf:	00 00 00 
  8032c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8032c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032ce:	00 00 00 
  8032d1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032d4:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8032dc:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <nsipc_close>:

int
nsipc_close(int s)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	48 83 ec 10          	sub    $0x10,%rsp
  8032f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8032f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032fc:	00 00 00 
  8032ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803302:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803304:	bf 04 00 00 00       	mov    $0x4,%edi
  803309:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  803310:	00 00 00 
  803313:	ff d0                	callq  *%rax
}
  803315:	c9                   	leaveq 
  803316:	c3                   	retq   

0000000000803317 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803317:	55                   	push   %rbp
  803318:	48 89 e5             	mov    %rsp,%rbp
  80331b:	48 83 ec 10          	sub    $0x10,%rsp
  80331f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803322:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803326:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803329:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803330:	00 00 00 
  803333:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803336:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803338:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80333b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333f:	48 89 c6             	mov    %rax,%rsi
  803342:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803349:	00 00 00 
  80334c:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803353:	00 00 00 
  803356:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803358:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335f:	00 00 00 
  803362:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803365:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803368:	bf 05 00 00 00       	mov    $0x5,%edi
  80336d:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
}
  803379:	c9                   	leaveq 
  80337a:	c3                   	retq   

000000000080337b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80337b:	55                   	push   %rbp
  80337c:	48 89 e5             	mov    %rsp,%rbp
  80337f:	48 83 ec 10          	sub    $0x10,%rsp
  803383:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803386:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803389:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803390:	00 00 00 
  803393:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803396:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803398:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339f:	00 00 00 
  8033a2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033a5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8033a8:	bf 06 00 00 00       	mov    $0x6,%edi
  8033ad:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
}
  8033b9:	c9                   	leaveq 
  8033ba:	c3                   	retq   

00000000008033bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033bb:	55                   	push   %rbp
  8033bc:	48 89 e5             	mov    %rsp,%rbp
  8033bf:	48 83 ec 30          	sub    $0x30,%rsp
  8033c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ca:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8033cd:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8033d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d7:	00 00 00 
  8033da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033dd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033e6:	00 00 00 
  8033e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033ec:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8033ef:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f6:	00 00 00 
  8033f9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033fc:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033ff:	bf 07 00 00 00       	mov    $0x7,%edi
  803404:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  80340b:	00 00 00 
  80340e:	ff d0                	callq  *%rax
  803410:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803417:	78 69                	js     803482 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803419:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803420:	7f 08                	jg     80342a <nsipc_recv+0x6f>
  803422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803425:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803428:	7e 35                	jle    80345f <nsipc_recv+0xa4>
  80342a:	48 b9 6e 48 80 00 00 	movabs $0x80486e,%rcx
  803431:	00 00 00 
  803434:	48 ba 83 48 80 00 00 	movabs $0x804883,%rdx
  80343b:	00 00 00 
  80343e:	be 62 00 00 00       	mov    $0x62,%esi
  803443:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
  80344a:	00 00 00 
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  803459:	00 00 00 
  80345c:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80345f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803462:	48 63 d0             	movslq %eax,%rdx
  803465:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803469:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803470:	00 00 00 
  803473:	48 89 c7             	mov    %rax,%rdi
  803476:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
	}

	return r;
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803485:	c9                   	leaveq 
  803486:	c3                   	retq   

0000000000803487 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803487:	55                   	push   %rbp
  803488:	48 89 e5             	mov    %rsp,%rbp
  80348b:	48 83 ec 20          	sub    $0x20,%rsp
  80348f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803492:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803496:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803499:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80349c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a3:	00 00 00 
  8034a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034a9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8034ab:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8034b2:	7e 35                	jle    8034e9 <nsipc_send+0x62>
  8034b4:	48 b9 a4 48 80 00 00 	movabs $0x8048a4,%rcx
  8034bb:	00 00 00 
  8034be:	48 ba 83 48 80 00 00 	movabs $0x804883,%rdx
  8034c5:	00 00 00 
  8034c8:	be 6d 00 00 00       	mov    $0x6d,%esi
  8034cd:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
  8034d4:	00 00 00 
  8034d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dc:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  8034e3:	00 00 00 
  8034e6:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ec:	48 63 d0             	movslq %eax,%rdx
  8034ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f3:	48 89 c6             	mov    %rax,%rsi
  8034f6:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8034fd:	00 00 00 
  803500:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80350c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803513:	00 00 00 
  803516:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803519:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80351c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803523:	00 00 00 
  803526:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803529:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80352c:	bf 08 00 00 00       	mov    $0x8,%edi
  803531:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  803538:	00 00 00 
  80353b:	ff d0                	callq  *%rax
}
  80353d:	c9                   	leaveq 
  80353e:	c3                   	retq   

000000000080353f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80353f:	55                   	push   %rbp
  803540:	48 89 e5             	mov    %rsp,%rbp
  803543:	48 83 ec 10          	sub    $0x10,%rsp
  803547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80354a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80354d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803550:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803557:	00 00 00 
  80355a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80355d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80355f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803566:	00 00 00 
  803569:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80356f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803576:	00 00 00 
  803579:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80357c:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80357f:	bf 09 00 00 00       	mov    $0x9,%edi
  803584:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
}
  803590:	c9                   	leaveq 
  803591:	c3                   	retq   

0000000000803592 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803592:	55                   	push   %rbp
  803593:	48 89 e5             	mov    %rsp,%rbp
  803596:	53                   	push   %rbx
  803597:	48 83 ec 38          	sub    $0x38,%rsp
  80359b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80359f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035a3:	48 89 c7             	mov    %rax,%rdi
  8035a6:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  8035ad:	00 00 00 
  8035b0:	ff d0                	callq  *%rax
  8035b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b9:	0f 88 bf 01 00 00    	js     80377e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c3:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c8:	48 89 c6             	mov    %rax,%rsi
  8035cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d0:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
  8035dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035e3:	0f 88 95 01 00 00    	js     80377e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035e9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035ed:	48 89 c7             	mov    %rax,%rdi
  8035f0:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803603:	0f 88 5d 01 00 00    	js     803766 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803609:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360d:	ba 07 04 00 00       	mov    $0x407,%edx
  803612:	48 89 c6             	mov    %rax,%rsi
  803615:	bf 00 00 00 00       	mov    $0x0,%edi
  80361a:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
  803626:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803629:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80362d:	0f 88 33 01 00 00    	js     803766 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803637:	48 89 c7             	mov    %rax,%rdi
  80363a:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
  803646:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80364a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80364e:	ba 07 04 00 00       	mov    $0x407,%edx
  803653:	48 89 c6             	mov    %rax,%rsi
  803656:	bf 00 00 00 00       	mov    $0x0,%edi
  80365b:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803662:	00 00 00 
  803665:	ff d0                	callq  *%rax
  803667:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80366a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80366e:	0f 88 d9 00 00 00    	js     80374d <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803678:	48 89 c7             	mov    %rax,%rdi
  80367b:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
  803687:	48 89 c2             	mov    %rax,%rdx
  80368a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80368e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803694:	48 89 d1             	mov    %rdx,%rcx
  803697:	ba 00 00 00 00       	mov    $0x0,%edx
  80369c:	48 89 c6             	mov    %rax,%rsi
  80369f:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a4:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  8036ab:	00 00 00 
  8036ae:	ff d0                	callq  *%rax
  8036b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b7:	78 79                	js     803732 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bd:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036c4:	00 00 00 
  8036c7:	8b 12                	mov    (%rdx),%edx
  8036c9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036da:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036e1:	00 00 00 
  8036e4:	8b 12                	mov    (%rdx),%edx
  8036e6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f7:	48 89 c7             	mov    %rax,%rdi
  8036fa:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	89 c2                	mov    %eax,%edx
  803708:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80370c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80370e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803712:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803716:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80371a:	48 89 c7             	mov    %rax,%rdi
  80371d:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 03                	mov    %eax,(%rbx)
	return 0;
  80372b:	b8 00 00 00 00       	mov    $0x0,%eax
  803730:	eb 4f                	jmp    803781 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803732:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803737:	48 89 c6             	mov    %rax,%rsi
  80373a:	bf 00 00 00 00       	mov    $0x0,%edi
  80373f:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
  80374b:	eb 01                	jmp    80374e <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80374d:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80374e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803752:	48 89 c6             	mov    %rax,%rsi
  803755:	bf 00 00 00 00       	mov    $0x0,%edi
  80375a:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803761:	00 00 00 
  803764:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376a:	48 89 c6             	mov    %rax,%rsi
  80376d:	bf 00 00 00 00       	mov    $0x0,%edi
  803772:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
err:
	return r;
  80377e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803781:	48 83 c4 38          	add    $0x38,%rsp
  803785:	5b                   	pop    %rbx
  803786:	5d                   	pop    %rbp
  803787:	c3                   	retq   

0000000000803788 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803788:	55                   	push   %rbp
  803789:	48 89 e5             	mov    %rsp,%rbp
  80378c:	53                   	push   %rbx
  80378d:	48 83 ec 28          	sub    $0x28,%rsp
  803791:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803795:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803799:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037a0:	00 00 00 
  8037a3:	48 8b 00             	mov    (%rax),%rax
  8037a6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b3:	48 89 c7             	mov    %rax,%rdi
  8037b6:	48 b8 3d 41 80 00 00 	movabs $0x80413d,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
  8037c2:	89 c3                	mov    %eax,%ebx
  8037c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c8:	48 89 c7             	mov    %rax,%rdi
  8037cb:	48 b8 3d 41 80 00 00 	movabs $0x80413d,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
  8037d7:	39 c3                	cmp    %eax,%ebx
  8037d9:	0f 94 c0             	sete   %al
  8037dc:	0f b6 c0             	movzbl %al,%eax
  8037df:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037e2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037e9:	00 00 00 
  8037ec:	48 8b 00             	mov    (%rax),%rax
  8037ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037f5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037fe:	75 05                	jne    803805 <_pipeisclosed+0x7d>
			return ret;
  803800:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803803:	eb 4a                	jmp    80384f <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803805:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803808:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80380b:	74 8c                	je     803799 <_pipeisclosed+0x11>
  80380d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803811:	75 86                	jne    803799 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803813:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80381a:	00 00 00 
  80381d:	48 8b 00             	mov    (%rax),%rax
  803820:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803826:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803829:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80382c:	89 c6                	mov    %eax,%esi
  80382e:	48 bf b5 48 80 00 00 	movabs $0x8048b5,%rdi
  803835:	00 00 00 
  803838:	b8 00 00 00 00       	mov    $0x0,%eax
  80383d:	49 b8 8f 04 80 00 00 	movabs $0x80048f,%r8
  803844:	00 00 00 
  803847:	41 ff d0             	callq  *%r8
	}
  80384a:	e9 4a ff ff ff       	jmpq   803799 <_pipeisclosed+0x11>

}
  80384f:	48 83 c4 28          	add    $0x28,%rsp
  803853:	5b                   	pop    %rbx
  803854:	5d                   	pop    %rbp
  803855:	c3                   	retq   

0000000000803856 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803856:	55                   	push   %rbp
  803857:	48 89 e5             	mov    %rsp,%rbp
  80385a:	48 83 ec 30          	sub    $0x30,%rsp
  80385e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803861:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803865:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803868:	48 89 d6             	mov    %rdx,%rsi
  80386b:	89 c7                	mov    %eax,%edi
  80386d:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
  803879:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803880:	79 05                	jns    803887 <pipeisclosed+0x31>
		return r;
  803882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803885:	eb 31                	jmp    8038b8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80388b:	48 89 c7             	mov    %rax,%rdi
  80388e:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803895:	00 00 00 
  803898:	ff d0                	callq  *%rax
  80389a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80389e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a6:	48 89 d6             	mov    %rdx,%rsi
  8038a9:	48 89 c7             	mov    %rax,%rdi
  8038ac:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  8038b3:	00 00 00 
  8038b6:	ff d0                	callq  *%rax
}
  8038b8:	c9                   	leaveq 
  8038b9:	c3                   	retq   

00000000008038ba <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038ba:	55                   	push   %rbp
  8038bb:	48 89 e5             	mov    %rsp,%rbp
  8038be:	48 83 ec 40          	sub    $0x40,%rsp
  8038c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038ca:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d2:	48 89 c7             	mov    %rax,%rdi
  8038d5:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
  8038e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038ed:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038f4:	00 
  8038f5:	e9 90 00 00 00       	jmpq   80398a <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038fa:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038ff:	74 09                	je     80390a <devpipe_read+0x50>
				return i;
  803901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803905:	e9 8e 00 00 00       	jmpq   803998 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80390a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80390e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803912:	48 89 d6             	mov    %rdx,%rsi
  803915:	48 89 c7             	mov    %rax,%rdi
  803918:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
  803924:	85 c0                	test   %eax,%eax
  803926:	74 07                	je     80392f <devpipe_read+0x75>
				return 0;
  803928:	b8 00 00 00 00       	mov    $0x0,%eax
  80392d:	eb 69                	jmp    803998 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80392f:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803936:	00 00 00 
  803939:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80393b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393f:	8b 10                	mov    (%rax),%edx
  803941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803945:	8b 40 04             	mov    0x4(%rax),%eax
  803948:	39 c2                	cmp    %eax,%edx
  80394a:	74 ae                	je     8038fa <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80394c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803950:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803954:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	8b 00                	mov    (%rax),%eax
  80395e:	99                   	cltd   
  80395f:	c1 ea 1b             	shr    $0x1b,%edx
  803962:	01 d0                	add    %edx,%eax
  803964:	83 e0 1f             	and    $0x1f,%eax
  803967:	29 d0                	sub    %edx,%eax
  803969:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80396d:	48 98                	cltq   
  80396f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803974:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397a:	8b 00                	mov    (%rax),%eax
  80397c:	8d 50 01             	lea    0x1(%rax),%edx
  80397f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803983:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803985:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80398a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803992:	72 a7                	jb     80393b <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803998:	c9                   	leaveq 
  803999:	c3                   	retq   

000000000080399a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80399a:	55                   	push   %rbp
  80399b:	48 89 e5             	mov    %rsp,%rbp
  80399e:	48 83 ec 40          	sub    $0x40,%rsp
  8039a2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039a6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039aa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039cd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039d4:	00 
  8039d5:	e9 8f 00 00 00       	jmpq   803a69 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e2:	48 89 d6             	mov    %rdx,%rsi
  8039e5:	48 89 c7             	mov    %rax,%rdi
  8039e8:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  8039ef:	00 00 00 
  8039f2:	ff d0                	callq  *%rax
  8039f4:	85 c0                	test   %eax,%eax
  8039f6:	74 07                	je     8039ff <devpipe_write+0x65>
				return 0;
  8039f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fd:	eb 78                	jmp    803a77 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039ff:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803a06:	00 00 00 
  803a09:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0f:	8b 40 04             	mov    0x4(%rax),%eax
  803a12:	48 63 d0             	movslq %eax,%rdx
  803a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a19:	8b 00                	mov    (%rax),%eax
  803a1b:	48 98                	cltq   
  803a1d:	48 83 c0 20          	add    $0x20,%rax
  803a21:	48 39 c2             	cmp    %rax,%rdx
  803a24:	73 b4                	jae    8039da <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2a:	8b 40 04             	mov    0x4(%rax),%eax
  803a2d:	99                   	cltd   
  803a2e:	c1 ea 1b             	shr    $0x1b,%edx
  803a31:	01 d0                	add    %edx,%eax
  803a33:	83 e0 1f             	and    $0x1f,%eax
  803a36:	29 d0                	sub    %edx,%eax
  803a38:	89 c6                	mov    %eax,%esi
  803a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a42:	48 01 d0             	add    %rdx,%rax
  803a45:	0f b6 08             	movzbl (%rax),%ecx
  803a48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a4c:	48 63 c6             	movslq %esi,%rax
  803a4f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a57:	8b 40 04             	mov    0x4(%rax),%eax
  803a5a:	8d 50 01             	lea    0x1(%rax),%edx
  803a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a61:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a64:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a71:	72 98                	jb     803a0b <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803a77:	c9                   	leaveq 
  803a78:	c3                   	retq   

0000000000803a79 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a79:	55                   	push   %rbp
  803a7a:	48 89 e5             	mov    %rsp,%rbp
  803a7d:	48 83 ec 20          	sub    $0x20,%rsp
  803a81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a8d:	48 89 c7             	mov    %rax,%rdi
  803a90:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803a97:	00 00 00 
  803a9a:	ff d0                	callq  *%rax
  803a9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803aa0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa4:	48 be c8 48 80 00 00 	movabs $0x8048c8,%rsi
  803aab:	00 00 00 
  803aae:	48 89 c7             	mov    %rax,%rdi
  803ab1:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803abd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac1:	8b 50 04             	mov    0x4(%rax),%edx
  803ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac8:	8b 00                	mov    (%rax),%eax
  803aca:	29 c2                	sub    %eax,%edx
  803acc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ad6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ada:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ae1:	00 00 00 
	stat->st_dev = &devpipe;
  803ae4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae8:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803aef:	00 00 00 
  803af2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803afe:	c9                   	leaveq 
  803aff:	c3                   	retq   

0000000000803b00 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b00:	55                   	push   %rbp
  803b01:	48 89 e5             	mov    %rsp,%rbp
  803b04:	48 83 ec 10          	sub    $0x10,%rsp
  803b08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803b0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b10:	48 89 c6             	mov    %rax,%rsi
  803b13:	bf 00 00 00 00       	mov    $0x0,%edi
  803b18:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b28:	48 89 c7             	mov    %rax,%rdi
  803b2b:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
  803b37:	48 89 c6             	mov    %rax,%rsi
  803b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3f:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803b46:	00 00 00 
  803b49:	ff d0                	callq  *%rax
}
  803b4b:	c9                   	leaveq 
  803b4c:	c3                   	retq   

0000000000803b4d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b4d:	55                   	push   %rbp
  803b4e:	48 89 e5             	mov    %rsp,%rbp
  803b51:	48 83 ec 20          	sub    $0x20,%rsp
  803b55:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b5b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b5e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b62:	be 01 00 00 00       	mov    $0x1,%esi
  803b67:	48 89 c7             	mov    %rax,%rdi
  803b6a:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  803b71:	00 00 00 
  803b74:	ff d0                	callq  *%rax
}
  803b76:	90                   	nop
  803b77:	c9                   	leaveq 
  803b78:	c3                   	retq   

0000000000803b79 <getchar>:

int
getchar(void)
{
  803b79:	55                   	push   %rbp
  803b7a:	48 89 e5             	mov    %rsp,%rbp
  803b7d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b81:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b85:	ba 01 00 00 00       	mov    $0x1,%edx
  803b8a:	48 89 c6             	mov    %rax,%rsi
  803b8d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b92:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
  803b9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ba1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba5:	79 05                	jns    803bac <getchar+0x33>
		return r;
  803ba7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803baa:	eb 14                	jmp    803bc0 <getchar+0x47>
	if (r < 1)
  803bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb0:	7f 07                	jg     803bb9 <getchar+0x40>
		return -E_EOF;
  803bb2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bb7:	eb 07                	jmp    803bc0 <getchar+0x47>
	return c;
  803bb9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bbd:	0f b6 c0             	movzbl %al,%eax

}
  803bc0:	c9                   	leaveq 
  803bc1:	c3                   	retq   

0000000000803bc2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803bc2:	55                   	push   %rbp
  803bc3:	48 89 e5             	mov    %rsp,%rbp
  803bc6:	48 83 ec 20          	sub    $0x20,%rsp
  803bca:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bcd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd4:	48 89 d6             	mov    %rdx,%rsi
  803bd7:	89 c7                	mov    %eax,%edi
  803bd9:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
  803be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bec:	79 05                	jns    803bf3 <iscons+0x31>
		return r;
  803bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf1:	eb 1a                	jmp    803c0d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf7:	8b 10                	mov    (%rax),%edx
  803bf9:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c00:	00 00 00 
  803c03:	8b 00                	mov    (%rax),%eax
  803c05:	39 c2                	cmp    %eax,%edx
  803c07:	0f 94 c0             	sete   %al
  803c0a:	0f b6 c0             	movzbl %al,%eax
}
  803c0d:	c9                   	leaveq 
  803c0e:	c3                   	retq   

0000000000803c0f <opencons>:

int
opencons(void)
{
  803c0f:	55                   	push   %rbp
  803c10:	48 89 e5             	mov    %rsp,%rbp
  803c13:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c17:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c1b:	48 89 c7             	mov    %rax,%rdi
  803c1e:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
  803c2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c31:	79 05                	jns    803c38 <opencons+0x29>
		return r;
  803c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c36:	eb 5b                	jmp    803c93 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3c:	ba 07 04 00 00       	mov    $0x407,%edx
  803c41:	48 89 c6             	mov    %rax,%rsi
  803c44:	bf 00 00 00 00       	mov    $0x0,%edi
  803c49:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5c:	79 05                	jns    803c63 <opencons+0x54>
		return r;
  803c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c61:	eb 30                	jmp    803c93 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c67:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c6e:	00 00 00 
  803c71:	8b 12                	mov    (%rdx),%edx
  803c73:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c79:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c84:	48 89 c7             	mov    %rax,%rdi
  803c87:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803c8e:	00 00 00 
  803c91:	ff d0                	callq  *%rax
}
  803c93:	c9                   	leaveq 
  803c94:	c3                   	retq   

0000000000803c95 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c95:	55                   	push   %rbp
  803c96:	48 89 e5             	mov    %rsp,%rbp
  803c99:	48 83 ec 30          	sub    $0x30,%rsp
  803c9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ca1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ca5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ca9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cae:	75 13                	jne    803cc3 <devcons_read+0x2e>
		return 0;
  803cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb5:	eb 49                	jmp    803d00 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803cb7:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803cbe:	00 00 00 
  803cc1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cc3:	48 b8 5a 18 80 00 00 	movabs $0x80185a,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
  803ccf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd6:	74 df                	je     803cb7 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803cd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cdc:	79 05                	jns    803ce3 <devcons_read+0x4e>
		return c;
  803cde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce1:	eb 1d                	jmp    803d00 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ce3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ce7:	75 07                	jne    803cf0 <devcons_read+0x5b>
		return 0;
  803ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cee:	eb 10                	jmp    803d00 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf3:	89 c2                	mov    %eax,%edx
  803cf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf9:	88 10                	mov    %dl,(%rax)
	return 1;
  803cfb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d00:	c9                   	leaveq 
  803d01:	c3                   	retq   

0000000000803d02 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d02:	55                   	push   %rbp
  803d03:	48 89 e5             	mov    %rsp,%rbp
  803d06:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d0d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d14:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d1b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d29:	eb 76                	jmp    803da1 <devcons_write+0x9f>
		m = n - tot;
  803d2b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d32:	89 c2                	mov    %eax,%edx
  803d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d37:	29 c2                	sub    %eax,%edx
  803d39:	89 d0                	mov    %edx,%eax
  803d3b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d41:	83 f8 7f             	cmp    $0x7f,%eax
  803d44:	76 07                	jbe    803d4d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d46:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d50:	48 63 d0             	movslq %eax,%rdx
  803d53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d56:	48 63 c8             	movslq %eax,%rcx
  803d59:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d60:	48 01 c1             	add    %rax,%rcx
  803d63:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d6a:	48 89 ce             	mov    %rcx,%rsi
  803d6d:	48 89 c7             	mov    %rax,%rdi
  803d70:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803d77:	00 00 00 
  803d7a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d7f:	48 63 d0             	movslq %eax,%rdx
  803d82:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d89:	48 89 d6             	mov    %rdx,%rsi
  803d8c:	48 89 c7             	mov    %rax,%rdi
  803d8f:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  803d96:	00 00 00 
  803d99:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d9e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803da1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da4:	48 98                	cltq   
  803da6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dad:	0f 82 78 ff ff ff    	jb     803d2b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803db6:	c9                   	leaveq 
  803db7:	c3                   	retq   

0000000000803db8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803db8:	55                   	push   %rbp
  803db9:	48 89 e5             	mov    %rsp,%rbp
  803dbc:	48 83 ec 08          	sub    $0x8,%rsp
  803dc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dc9:	c9                   	leaveq 
  803dca:	c3                   	retq   

0000000000803dcb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803dcb:	55                   	push   %rbp
  803dcc:	48 89 e5             	mov    %rsp,%rbp
  803dcf:	48 83 ec 10          	sub    $0x10,%rsp
  803dd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddf:	48 be d4 48 80 00 00 	movabs $0x8048d4,%rsi
  803de6:	00 00 00 
  803de9:	48 89 c7             	mov    %rax,%rdi
  803dec:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  803df3:	00 00 00 
  803df6:	ff d0                	callq  *%rax
	return 0;
  803df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dfd:	c9                   	leaveq 
  803dfe:	c3                   	retq   

0000000000803dff <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803dff:	55                   	push   %rbp
  803e00:	48 89 e5             	mov    %rsp,%rbp
  803e03:	48 83 ec 30          	sub    $0x30,%rsp
  803e07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803e13:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e18:	75 0e                	jne    803e28 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803e1a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e21:	00 00 00 
  803e24:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803e28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e2c:	48 89 c7             	mov    %rax,%rdi
  803e2f:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  803e36:	00 00 00 
  803e39:	ff d0                	callq  *%rax
  803e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e42:	79 27                	jns    803e6b <ipc_recv+0x6c>
		if (from_env_store)
  803e44:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e49:	74 0a                	je     803e55 <ipc_recv+0x56>
			*from_env_store = 0;
  803e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803e55:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e5a:	74 0a                	je     803e66 <ipc_recv+0x67>
			*perm_store = 0;
  803e5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e60:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e69:	eb 53                	jmp    803ebe <ipc_recv+0xbf>
	}
	if (from_env_store)
  803e6b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e70:	74 19                	je     803e8b <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803e72:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e79:	00 00 00 
  803e7c:	48 8b 00             	mov    (%rax),%rax
  803e7f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e89:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803e8b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e90:	74 19                	je     803eab <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803e92:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e99:	00 00 00 
  803e9c:	48 8b 00             	mov    (%rax),%rax
  803e9f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ea5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803eab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eb2:	00 00 00 
  803eb5:	48 8b 00             	mov    (%rax),%rax
  803eb8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803ebe:	c9                   	leaveq 
  803ebf:	c3                   	retq   

0000000000803ec0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	48 83 ec 30          	sub    $0x30,%rsp
  803ec8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ecb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ece:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ed2:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803ed5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eda:	75 1c                	jne    803ef8 <ipc_send+0x38>
		pg = (void*) UTOP;
  803edc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ee3:	00 00 00 
  803ee6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803eea:	eb 0c                	jmp    803ef8 <ipc_send+0x38>
		sys_yield();
  803eec:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803ef8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803efb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803efe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f05:	89 c7                	mov    %eax,%edi
  803f07:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803f0e:	00 00 00 
  803f11:	ff d0                	callq  *%rax
  803f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f16:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f1a:	74 d0                	je     803eec <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  803f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f20:	79 30                	jns    803f52 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  803f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f25:	89 c1                	mov    %eax,%ecx
  803f27:	48 ba db 48 80 00 00 	movabs $0x8048db,%rdx
  803f2e:	00 00 00 
  803f31:	be 47 00 00 00       	mov    $0x47,%esi
  803f36:	48 bf f1 48 80 00 00 	movabs $0x8048f1,%rdi
  803f3d:	00 00 00 
  803f40:	b8 00 00 00 00       	mov    $0x0,%eax
  803f45:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  803f4c:	00 00 00 
  803f4f:	41 ff d0             	callq  *%r8

}
  803f52:	90                   	nop
  803f53:	c9                   	leaveq 
  803f54:	c3                   	retq   

0000000000803f55 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803f55:	55                   	push   %rbp
  803f56:	48 89 e5             	mov    %rsp,%rbp
  803f59:	53                   	push   %rbx
  803f5a:	48 83 ec 28          	sub    $0x28,%rsp
  803f5e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  803f62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  803f69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  803f70:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f75:	75 0e                	jne    803f85 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  803f77:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f7e:	00 00 00 
  803f81:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  803f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f89:	ba 07 00 00 00       	mov    $0x7,%edx
  803f8e:	48 89 c6             	mov    %rax,%rsi
  803f91:	bf 00 00 00 00       	mov    $0x0,%edi
  803f96:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803f9d:	00 00 00 
  803fa0:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  803fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa6:	48 c1 e8 0c          	shr    $0xc,%rax
  803faa:	48 89 c2             	mov    %rax,%rdx
  803fad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fb4:	01 00 00 
  803fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fbb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803fc1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  803fc5:	b8 03 00 00 00       	mov    $0x3,%eax
  803fca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fce:	48 89 d3             	mov    %rdx,%rbx
  803fd1:	0f 01 c1             	vmcall 
  803fd4:	89 f2                	mov    %esi,%edx
  803fd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fd9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  803fdc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fe0:	79 05                	jns    803fe7 <ipc_host_recv+0x92>
		return r;
  803fe2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe5:	eb 03                	jmp    803fea <ipc_host_recv+0x95>
	}
	return val;
  803fe7:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  803fea:	48 83 c4 28          	add    $0x28,%rsp
  803fee:	5b                   	pop    %rbx
  803fef:	5d                   	pop    %rbp
  803ff0:	c3                   	retq   

0000000000803ff1 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ff1:	55                   	push   %rbp
  803ff2:	48 89 e5             	mov    %rsp,%rbp
  803ff5:	53                   	push   %rbx
  803ff6:	48 83 ec 38          	sub    $0x38,%rsp
  803ffa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803ffd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804000:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804004:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804007:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80400e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804013:	75 0e                	jne    804023 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804015:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80401c:	00 00 00 
  80401f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804023:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804027:	48 c1 e8 0c          	shr    $0xc,%rax
  80402b:	48 89 c2             	mov    %rax,%rdx
  80402e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804035:	01 00 00 
  804038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80403c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804042:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804046:	b8 02 00 00 00       	mov    $0x2,%eax
  80404b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80404e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804051:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804055:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804058:	89 fb                	mov    %edi,%ebx
  80405a:	0f 01 c1             	vmcall 
  80405d:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804060:	eb 26                	jmp    804088 <ipc_host_send+0x97>
		sys_yield();
  804062:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  804069:	00 00 00 
  80406c:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80406e:	b8 02 00 00 00       	mov    $0x2,%eax
  804073:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804076:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804079:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80407d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804080:	89 fb                	mov    %edi,%ebx
  804082:	0f 01 c1             	vmcall 
  804085:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804088:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  80408c:	74 d4                	je     804062 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  80408e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804092:	79 30                	jns    8040c4 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804094:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804097:	89 c1                	mov    %eax,%ecx
  804099:	48 ba db 48 80 00 00 	movabs $0x8048db,%rdx
  8040a0:	00 00 00 
  8040a3:	be 79 00 00 00       	mov    $0x79,%esi
  8040a8:	48 bf f1 48 80 00 00 	movabs $0x8048f1,%rdi
  8040af:	00 00 00 
  8040b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b7:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  8040be:	00 00 00 
  8040c1:	41 ff d0             	callq  *%r8

}
  8040c4:	90                   	nop
  8040c5:	48 83 c4 38          	add    $0x38,%rsp
  8040c9:	5b                   	pop    %rbx
  8040ca:	5d                   	pop    %rbp
  8040cb:	c3                   	retq   

00000000008040cc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8040cc:	55                   	push   %rbp
  8040cd:	48 89 e5             	mov    %rsp,%rbp
  8040d0:	48 83 ec 18          	sub    $0x18,%rsp
  8040d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8040d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040de:	eb 4d                	jmp    80412d <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8040e0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8040e7:	00 00 00 
  8040ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ed:	48 98                	cltq   
  8040ef:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8040f6:	48 01 d0             	add    %rdx,%rax
  8040f9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8040ff:	8b 00                	mov    (%rax),%eax
  804101:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804104:	75 23                	jne    804129 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804106:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80410d:	00 00 00 
  804110:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804113:	48 98                	cltq   
  804115:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80411c:	48 01 d0             	add    %rdx,%rax
  80411f:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804125:	8b 00                	mov    (%rax),%eax
  804127:	eb 12                	jmp    80413b <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804129:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80412d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804134:	7e aa                	jle    8040e0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804136:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80413b:	c9                   	leaveq 
  80413c:	c3                   	retq   

000000000080413d <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80413d:	55                   	push   %rbp
  80413e:	48 89 e5             	mov    %rsp,%rbp
  804141:	48 83 ec 18          	sub    $0x18,%rsp
  804145:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80414d:	48 c1 e8 15          	shr    $0x15,%rax
  804151:	48 89 c2             	mov    %rax,%rdx
  804154:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80415b:	01 00 00 
  80415e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804162:	83 e0 01             	and    $0x1,%eax
  804165:	48 85 c0             	test   %rax,%rax
  804168:	75 07                	jne    804171 <pageref+0x34>
		return 0;
  80416a:	b8 00 00 00 00       	mov    $0x0,%eax
  80416f:	eb 56                	jmp    8041c7 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804175:	48 c1 e8 0c          	shr    $0xc,%rax
  804179:	48 89 c2             	mov    %rax,%rdx
  80417c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804183:	01 00 00 
  804186:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80418a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80418e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804192:	83 e0 01             	and    $0x1,%eax
  804195:	48 85 c0             	test   %rax,%rax
  804198:	75 07                	jne    8041a1 <pageref+0x64>
		return 0;
  80419a:	b8 00 00 00 00       	mov    $0x0,%eax
  80419f:	eb 26                	jmp    8041c7 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8041a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8041a9:	48 89 c2             	mov    %rax,%rdx
  8041ac:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8041b3:	00 00 00 
  8041b6:	48 c1 e2 04          	shl    $0x4,%rdx
  8041ba:	48 01 d0             	add    %rdx,%rax
  8041bd:	48 83 c0 08          	add    $0x8,%rax
  8041c1:	0f b7 00             	movzwl (%rax),%eax
  8041c4:	0f b7 c0             	movzwl %ax,%eax
}
  8041c7:	c9                   	leaveq 
  8041c8:	c3                   	retq   
