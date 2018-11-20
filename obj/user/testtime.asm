
obj/user/testtime:     file format elf64-x86-64


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
  800084:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  80008b:	00 00 00 
  80008e:	be 0c 00 00 00       	mov    $0xc,%esi
  800093:	48 bf 72 41 80 00 00 	movabs $0x804172,%rdi
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
  8000b7:	48 ba 82 41 80 00 00 	movabs $0x804182,%rdx
  8000be:	00 00 00 
  8000c1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000c6:	48 bf 72 41 80 00 00 	movabs $0x804172,%rdi
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
  80012f:	48 bf 8e 41 80 00 00 	movabs $0x80418e,%rdi
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
  800158:	48 bf a4 41 80 00 00 	movabs $0x8041a4,%rdi
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
  80018e:	48 bf a8 41 80 00 00 	movabs $0x8041a8,%rdi
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
  800235:	48 b8 90 21 80 00 00 	movabs $0x802190,%rax
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
  80030f:	48 bf b8 41 80 00 00 	movabs $0x8041b8,%rdi
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
  80034b:	48 bf db 41 80 00 00 	movabs $0x8041db,%rdi
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
  8005fc:	48 b8 d0 43 80 00 00 	movabs $0x8043d0,%rax
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
  8008de:	48 b8 f8 43 80 00 00 	movabs $0x8043f8,%rax
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
  800a25:	48 b8 20 43 80 00 00 	movabs $0x804320,%rax
  800a2c:	00 00 00 
  800a2f:	48 63 d3             	movslq %ebx,%rdx
  800a32:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a36:	4d 85 e4             	test   %r12,%r12
  800a39:	75 2e                	jne    800a69 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a3b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a43:	89 d9                	mov    %ebx,%ecx
  800a45:	48 ba e1 43 80 00 00 	movabs $0x8043e1,%rdx
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
  800a74:	48 ba ea 43 80 00 00 	movabs $0x8043ea,%rdx
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
  800acb:	49 bc ed 43 80 00 00 	movabs $0x8043ed,%r12
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
  8017d7:	48 ba a8 46 80 00 00 	movabs $0x8046a8,%rdx
  8017de:	00 00 00 
  8017e1:	be 24 00 00 00       	mov    $0x24,%esi
  8017e6:	48 bf c5 46 80 00 00 	movabs $0x8046c5,%rdi
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

0000000000801d51 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801d55:	48 83 ec 08          	sub    $0x8,%rsp
  801d59:	6a 00                	pushq  $0x0
  801d5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d67:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	be 00 00 00 00       	mov    $0x0,%esi
  801d76:	bf 13 00 00 00       	mov    $0x13,%edi
  801d7b:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801d82:	00 00 00 
  801d85:	ff d0                	callq  *%rax
  801d87:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801d8b:	90                   	nop
  801d8c:	c9                   	leaveq 
  801d8d:	c3                   	retq   

0000000000801d8e <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801d8e:	55                   	push   %rbp
  801d8f:	48 89 e5             	mov    %rsp,%rbp
  801d92:	48 83 ec 10          	sub    $0x10,%rsp
  801d96:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9c:	48 98                	cltq   
  801d9e:	48 83 ec 08          	sub    $0x8,%rsp
  801da2:	6a 00                	pushq  $0x0
  801da4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db5:	48 89 c2             	mov    %rax,%rdx
  801db8:	be 00 00 00 00       	mov    $0x0,%esi
  801dbd:	bf 14 00 00 00       	mov    $0x14,%edi
  801dc2:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801dc9:	00 00 00 
  801dcc:	ff d0                	callq  *%rax
  801dce:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd2:	c9                   	leaveq 
  801dd3:	c3                   	retq   

0000000000801dd4 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801dd4:	55                   	push   %rbp
  801dd5:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801dd8:	48 83 ec 08          	sub    $0x8,%rsp
  801ddc:	6a 00                	pushq  $0x0
  801dde:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dea:	b9 00 00 00 00       	mov    $0x0,%ecx
  801def:	ba 00 00 00 00       	mov    $0x0,%edx
  801df4:	be 00 00 00 00       	mov    $0x0,%esi
  801df9:	bf 15 00 00 00       	mov    $0x15,%edi
  801dfe:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	callq  *%rax
  801e0a:	48 83 c4 10          	add    $0x10,%rsp
}
  801e0e:	c9                   	leaveq 
  801e0f:	c3                   	retq   

0000000000801e10 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e10:	55                   	push   %rbp
  801e11:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e14:	48 83 ec 08          	sub    $0x8,%rsp
  801e18:	6a 00                	pushq  $0x0
  801e1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e30:	be 00 00 00 00       	mov    $0x0,%esi
  801e35:	bf 16 00 00 00       	mov    $0x16,%edi
  801e3a:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801e41:	00 00 00 
  801e44:	ff d0                	callq  *%rax
  801e46:	48 83 c4 10          	add    $0x10,%rsp
}
  801e4a:	90                   	nop
  801e4b:	c9                   	leaveq 
  801e4c:	c3                   	retq   

0000000000801e4d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e4d:	55                   	push   %rbp
  801e4e:	48 89 e5             	mov    %rsp,%rbp
  801e51:	48 83 ec 08          	sub    $0x8,%rsp
  801e55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e5d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e64:	ff ff ff 
  801e67:	48 01 d0             	add    %rdx,%rax
  801e6a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 08          	sub    $0x8,%rsp
  801e78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e80:	48 89 c7             	mov    %rax,%rdi
  801e83:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	callq  *%rax
  801e8f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e95:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e99:	c9                   	leaveq 
  801e9a:	c3                   	retq   

0000000000801e9b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e9b:	55                   	push   %rbp
  801e9c:	48 89 e5             	mov    %rsp,%rbp
  801e9f:	48 83 ec 18          	sub    $0x18,%rsp
  801ea3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ea7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eae:	eb 6b                	jmp    801f1b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb3:	48 98                	cltq   
  801eb5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ebb:	48 c1 e0 0c          	shl    $0xc,%rax
  801ebf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec7:	48 c1 e8 15          	shr    $0x15,%rax
  801ecb:	48 89 c2             	mov    %rax,%rdx
  801ece:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ed5:	01 00 00 
  801ed8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801edc:	83 e0 01             	and    $0x1,%eax
  801edf:	48 85 c0             	test   %rax,%rax
  801ee2:	74 21                	je     801f05 <fd_alloc+0x6a>
  801ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee8:	48 c1 e8 0c          	shr    $0xc,%rax
  801eec:	48 89 c2             	mov    %rax,%rdx
  801eef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ef6:	01 00 00 
  801ef9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efd:	83 e0 01             	and    $0x1,%eax
  801f00:	48 85 c0             	test   %rax,%rax
  801f03:	75 12                	jne    801f17 <fd_alloc+0x7c>
			*fd_store = fd;
  801f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f0d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
  801f15:	eb 1a                	jmp    801f31 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f17:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f1b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f1f:	7e 8f                	jle    801eb0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f25:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f2c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f31:	c9                   	leaveq 
  801f32:	c3                   	retq   

0000000000801f33 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	48 83 ec 20          	sub    $0x20,%rsp
  801f3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f42:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f46:	78 06                	js     801f4e <fd_lookup+0x1b>
  801f48:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f4c:	7e 07                	jle    801f55 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f53:	eb 6c                	jmp    801fc1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f58:	48 98                	cltq   
  801f5a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f60:	48 c1 e0 0c          	shl    $0xc,%rax
  801f64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f6c:	48 c1 e8 15          	shr    $0x15,%rax
  801f70:	48 89 c2             	mov    %rax,%rdx
  801f73:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f7a:	01 00 00 
  801f7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f81:	83 e0 01             	and    $0x1,%eax
  801f84:	48 85 c0             	test   %rax,%rax
  801f87:	74 21                	je     801faa <fd_lookup+0x77>
  801f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8d:	48 c1 e8 0c          	shr    $0xc,%rax
  801f91:	48 89 c2             	mov    %rax,%rdx
  801f94:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f9b:	01 00 00 
  801f9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa2:	83 e0 01             	and    $0x1,%eax
  801fa5:	48 85 c0             	test   %rax,%rax
  801fa8:	75 07                	jne    801fb1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801faa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801faf:	eb 10                	jmp    801fc1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fb9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 30          	sub    $0x30,%rsp
  801fcb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fcf:	89 f0                	mov    %esi,%eax
  801fd1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd8:	48 89 c7             	mov    %rax,%rdi
  801fdb:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	callq  *%rax
  801fe7:	89 c2                	mov    %eax,%edx
  801fe9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801fed:	48 89 c6             	mov    %rax,%rsi
  801ff0:	89 d7                	mov    %edx,%edi
  801ff2:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802001:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802005:	78 0a                	js     802011 <fd_close+0x4e>
	    || fd != fd2)
  802007:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80200f:	74 12                	je     802023 <fd_close+0x60>
		return (must_exist ? r : 0);
  802011:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802015:	74 05                	je     80201c <fd_close+0x59>
  802017:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201a:	eb 70                	jmp    80208c <fd_close+0xc9>
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
  802021:	eb 69                	jmp    80208c <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802023:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802027:	8b 00                	mov    (%rax),%eax
  802029:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80202d:	48 89 d6             	mov    %rdx,%rsi
  802030:	89 c7                	mov    %eax,%edi
  802032:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802039:	00 00 00 
  80203c:	ff d0                	callq  *%rax
  80203e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802041:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802045:	78 2a                	js     802071 <fd_close+0xae>
		if (dev->dev_close)
  802047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80204f:	48 85 c0             	test   %rax,%rax
  802052:	74 16                	je     80206a <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802058:	48 8b 40 20          	mov    0x20(%rax),%rax
  80205c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802060:	48 89 d7             	mov    %rdx,%rdi
  802063:	ff d0                	callq  *%rax
  802065:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802068:	eb 07                	jmp    802071 <fd_close+0xae>
		else
			r = 0;
  80206a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802071:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802075:	48 89 c6             	mov    %rax,%rsi
  802078:	bf 00 00 00 00       	mov    $0x0,%edi
  80207d:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
	return r;
  802089:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80208c:	c9                   	leaveq 
  80208d:	c3                   	retq   

000000000080208e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
  802092:	48 83 ec 20          	sub    $0x20,%rsp
  802096:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802099:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80209d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020a4:	eb 41                	jmp    8020e7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020a6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020ad:	00 00 00 
  8020b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020b3:	48 63 d2             	movslq %edx,%rdx
  8020b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ba:	8b 00                	mov    (%rax),%eax
  8020bc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020bf:	75 22                	jne    8020e3 <dev_lookup+0x55>
			*dev = devtab[i];
  8020c1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020c8:	00 00 00 
  8020cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020ce:	48 63 d2             	movslq %edx,%rdx
  8020d1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e1:	eb 60                	jmp    802143 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020e7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020ee:	00 00 00 
  8020f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f4:	48 63 d2             	movslq %edx,%rdx
  8020f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fb:	48 85 c0             	test   %rax,%rax
  8020fe:	75 a6                	jne    8020a6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802100:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802107:	00 00 00 
  80210a:	48 8b 00             	mov    (%rax),%rax
  80210d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802113:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802116:	89 c6                	mov    %eax,%esi
  802118:	48 bf d8 46 80 00 00 	movabs $0x8046d8,%rdi
  80211f:	00 00 00 
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  80212e:	00 00 00 
  802131:	ff d1                	callq  *%rcx
	*dev = 0;
  802133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802137:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80213e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802143:	c9                   	leaveq 
  802144:	c3                   	retq   

0000000000802145 <close>:

int
close(int fdnum)
{
  802145:	55                   	push   %rbp
  802146:	48 89 e5             	mov    %rsp,%rbp
  802149:	48 83 ec 20          	sub    $0x20,%rsp
  80214d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802150:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802154:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802157:	48 89 d6             	mov    %rdx,%rsi
  80215a:	89 c7                	mov    %eax,%edi
  80215c:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax
  802168:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80216b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216f:	79 05                	jns    802176 <close+0x31>
		return r;
  802171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802174:	eb 18                	jmp    80218e <close+0x49>
	else
		return fd_close(fd, 1);
  802176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217a:	be 01 00 00 00       	mov    $0x1,%esi
  80217f:	48 89 c7             	mov    %rax,%rdi
  802182:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
}
  80218e:	c9                   	leaveq 
  80218f:	c3                   	retq   

0000000000802190 <close_all>:

void
close_all(void)
{
  802190:	55                   	push   %rbp
  802191:	48 89 e5             	mov    %rsp,%rbp
  802194:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802198:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80219f:	eb 15                	jmp    8021b6 <close_all+0x26>
		close(i);
  8021a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a4:	89 c7                	mov    %eax,%edi
  8021a6:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021b6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021ba:	7e e5                	jle    8021a1 <close_all+0x11>
		close(i);
}
  8021bc:	90                   	nop
  8021bd:	c9                   	leaveq 
  8021be:	c3                   	retq   

00000000008021bf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021bf:	55                   	push   %rbp
  8021c0:	48 89 e5             	mov    %rsp,%rbp
  8021c3:	48 83 ec 40          	sub    $0x40,%rsp
  8021c7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021ca:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021cd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021d1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021d4:	48 89 d6             	mov    %rdx,%rsi
  8021d7:	89 c7                	mov    %eax,%edi
  8021d9:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	callq  *%rax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ec:	79 08                	jns    8021f6 <dup+0x37>
		return r;
  8021ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f1:	e9 70 01 00 00       	jmpq   802366 <dup+0x1a7>
	close(newfdnum);
  8021f6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021f9:	89 c7                	mov    %eax,%edi
  8021fb:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802202:	00 00 00 
  802205:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802207:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80220a:	48 98                	cltq   
  80220c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802212:	48 c1 e0 0c          	shl    $0xc,%rax
  802216:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80221a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80221e:	48 89 c7             	mov    %rax,%rdi
  802221:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  802228:	00 00 00 
  80222b:	ff d0                	callq  *%rax
  80222d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802235:	48 89 c7             	mov    %rax,%rdi
  802238:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  80223f:	00 00 00 
  802242:	ff d0                	callq  *%rax
  802244:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224c:	48 c1 e8 15          	shr    $0x15,%rax
  802250:	48 89 c2             	mov    %rax,%rdx
  802253:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80225a:	01 00 00 
  80225d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802261:	83 e0 01             	and    $0x1,%eax
  802264:	48 85 c0             	test   %rax,%rax
  802267:	74 71                	je     8022da <dup+0x11b>
  802269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226d:	48 c1 e8 0c          	shr    $0xc,%rax
  802271:	48 89 c2             	mov    %rax,%rdx
  802274:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227b:	01 00 00 
  80227e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802282:	83 e0 01             	and    $0x1,%eax
  802285:	48 85 c0             	test   %rax,%rax
  802288:	74 50                	je     8022da <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80228a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228e:	48 c1 e8 0c          	shr    $0xc,%rax
  802292:	48 89 c2             	mov    %rax,%rdx
  802295:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229c:	01 00 00 
  80229f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8022a8:	89 c1                	mov    %eax,%ecx
  8022aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b2:	41 89 c8             	mov    %ecx,%r8d
  8022b5:	48 89 d1             	mov    %rdx,%rcx
  8022b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bd:	48 89 c6             	mov    %rax,%rsi
  8022c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c5:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  8022cc:	00 00 00 
  8022cf:	ff d0                	callq  *%rax
  8022d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d8:	78 55                	js     80232f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022de:	48 c1 e8 0c          	shr    $0xc,%rax
  8022e2:	48 89 c2             	mov    %rax,%rdx
  8022e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ec:	01 00 00 
  8022ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8022f8:	89 c1                	mov    %eax,%ecx
  8022fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802302:	41 89 c8             	mov    %ecx,%r8d
  802305:	48 89 d1             	mov    %rdx,%rcx
  802308:	ba 00 00 00 00       	mov    $0x0,%edx
  80230d:	48 89 c6             	mov    %rax,%rsi
  802310:	bf 00 00 00 00       	mov    $0x0,%edi
  802315:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
  802321:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802324:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802328:	78 08                	js     802332 <dup+0x173>
		goto err;

	return newfdnum;
  80232a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80232d:	eb 37                	jmp    802366 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80232f:	90                   	nop
  802330:	eb 01                	jmp    802333 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802332:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802337:	48 89 c6             	mov    %rax,%rsi
  80233a:	bf 00 00 00 00       	mov    $0x0,%edi
  80233f:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  802346:	00 00 00 
  802349:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80234b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80234f:	48 89 c6             	mov    %rax,%rsi
  802352:	bf 00 00 00 00       	mov    $0x0,%edi
  802357:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  80235e:	00 00 00 
  802361:	ff d0                	callq  *%rax
	return r;
  802363:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802366:	c9                   	leaveq 
  802367:	c3                   	retq   

0000000000802368 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802368:	55                   	push   %rbp
  802369:	48 89 e5             	mov    %rsp,%rbp
  80236c:	48 83 ec 40          	sub    $0x40,%rsp
  802370:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802373:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802377:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80237b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80237f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802382:	48 89 d6             	mov    %rdx,%rsi
  802385:	89 c7                	mov    %eax,%edi
  802387:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
  802393:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802396:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239a:	78 24                	js     8023c0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80239c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a0:	8b 00                	mov    (%rax),%eax
  8023a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023a6:	48 89 d6             	mov    %rdx,%rsi
  8023a9:	89 c7                	mov    %eax,%edi
  8023ab:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8023b2:	00 00 00 
  8023b5:	ff d0                	callq  *%rax
  8023b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023be:	79 05                	jns    8023c5 <read+0x5d>
		return r;
  8023c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c3:	eb 76                	jmp    80243b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c9:	8b 40 08             	mov    0x8(%rax),%eax
  8023cc:	83 e0 03             	and    $0x3,%eax
  8023cf:	83 f8 01             	cmp    $0x1,%eax
  8023d2:	75 3a                	jne    80240e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023d4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023db:	00 00 00 
  8023de:	48 8b 00             	mov    (%rax),%rax
  8023e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023e7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023ea:	89 c6                	mov    %eax,%esi
  8023ec:	48 bf f7 46 80 00 00 	movabs $0x8046f7,%rdi
  8023f3:	00 00 00 
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fb:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  802402:	00 00 00 
  802405:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80240c:	eb 2d                	jmp    80243b <read+0xd3>
	}
	if (!dev->dev_read)
  80240e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802412:	48 8b 40 10          	mov    0x10(%rax),%rax
  802416:	48 85 c0             	test   %rax,%rax
  802419:	75 07                	jne    802422 <read+0xba>
		return -E_NOT_SUPP;
  80241b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802420:	eb 19                	jmp    80243b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802426:	48 8b 40 10          	mov    0x10(%rax),%rax
  80242a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80242e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802432:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802436:	48 89 cf             	mov    %rcx,%rdi
  802439:	ff d0                	callq  *%rax
}
  80243b:	c9                   	leaveq 
  80243c:	c3                   	retq   

000000000080243d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80243d:	55                   	push   %rbp
  80243e:	48 89 e5             	mov    %rsp,%rbp
  802441:	48 83 ec 30          	sub    $0x30,%rsp
  802445:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802448:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80244c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802457:	eb 47                	jmp    8024a0 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245c:	48 98                	cltq   
  80245e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802462:	48 29 c2             	sub    %rax,%rdx
  802465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802468:	48 63 c8             	movslq %eax,%rcx
  80246b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246f:	48 01 c1             	add    %rax,%rcx
  802472:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802475:	48 89 ce             	mov    %rcx,%rsi
  802478:	89 c7                	mov    %eax,%edi
  80247a:	48 b8 68 23 80 00 00 	movabs $0x802368,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax
  802486:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802489:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80248d:	79 05                	jns    802494 <readn+0x57>
			return m;
  80248f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802492:	eb 1d                	jmp    8024b1 <readn+0x74>
		if (m == 0)
  802494:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802498:	74 13                	je     8024ad <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80249a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80249d:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a3:	48 98                	cltq   
  8024a5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024a9:	72 ae                	jb     802459 <readn+0x1c>
  8024ab:	eb 01                	jmp    8024ae <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8024ad:	90                   	nop
	}
	return tot;
  8024ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024b1:	c9                   	leaveq 
  8024b2:	c3                   	retq   

00000000008024b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024b3:	55                   	push   %rbp
  8024b4:	48 89 e5             	mov    %rsp,%rbp
  8024b7:	48 83 ec 40          	sub    $0x40,%rsp
  8024bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024cd:	48 89 d6             	mov    %rdx,%rsi
  8024d0:	89 c7                	mov    %eax,%edi
  8024d2:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	callq  *%rax
  8024de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e5:	78 24                	js     80250b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024eb:	8b 00                	mov    (%rax),%eax
  8024ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f1:	48 89 d6             	mov    %rdx,%rsi
  8024f4:	89 c7                	mov    %eax,%edi
  8024f6:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
  802502:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802505:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802509:	79 05                	jns    802510 <write+0x5d>
		return r;
  80250b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250e:	eb 75                	jmp    802585 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802514:	8b 40 08             	mov    0x8(%rax),%eax
  802517:	83 e0 03             	and    $0x3,%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	75 3a                	jne    802558 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80251e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802525:	00 00 00 
  802528:	48 8b 00             	mov    (%rax),%rax
  80252b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802531:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802534:	89 c6                	mov    %eax,%esi
  802536:	48 bf 13 47 80 00 00 	movabs $0x804713,%rdi
  80253d:	00 00 00 
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  80254c:	00 00 00 
  80254f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802551:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802556:	eb 2d                	jmp    802585 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802560:	48 85 c0             	test   %rax,%rax
  802563:	75 07                	jne    80256c <write+0xb9>
		return -E_NOT_SUPP;
  802565:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80256a:	eb 19                	jmp    802585 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80256c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802570:	48 8b 40 18          	mov    0x18(%rax),%rax
  802574:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802578:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80257c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802580:	48 89 cf             	mov    %rcx,%rdi
  802583:	ff d0                	callq  *%rax
}
  802585:	c9                   	leaveq 
  802586:	c3                   	retq   

0000000000802587 <seek>:

int
seek(int fdnum, off_t offset)
{
  802587:	55                   	push   %rbp
  802588:	48 89 e5             	mov    %rsp,%rbp
  80258b:	48 83 ec 18          	sub    $0x18,%rsp
  80258f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802592:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802595:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802599:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80259c:	48 89 d6             	mov    %rdx,%rsi
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b4:	79 05                	jns    8025bb <seek+0x34>
		return r;
  8025b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b9:	eb 0f                	jmp    8025ca <seek+0x43>
	fd->fd_offset = offset;
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ca:	c9                   	leaveq 
  8025cb:	c3                   	retq   

00000000008025cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025cc:	55                   	push   %rbp
  8025cd:	48 89 e5             	mov    %rsp,%rbp
  8025d0:	48 83 ec 30          	sub    $0x30,%rsp
  8025d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025d7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025e1:	48 89 d6             	mov    %rdx,%rsi
  8025e4:	89 c7                	mov    %eax,%edi
  8025e6:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
  8025f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f9:	78 24                	js     80261f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ff:	8b 00                	mov    (%rax),%eax
  802601:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802605:	48 89 d6             	mov    %rdx,%rsi
  802608:	89 c7                	mov    %eax,%edi
  80260a:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802619:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261d:	79 05                	jns    802624 <ftruncate+0x58>
		return r;
  80261f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802622:	eb 72                	jmp    802696 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802628:	8b 40 08             	mov    0x8(%rax),%eax
  80262b:	83 e0 03             	and    $0x3,%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	75 3a                	jne    80266c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802632:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802639:	00 00 00 
  80263c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80263f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802645:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802648:	89 c6                	mov    %eax,%esi
  80264a:	48 bf 30 47 80 00 00 	movabs $0x804730,%rdi
  802651:	00 00 00 
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
  802659:	48 b9 8f 04 80 00 00 	movabs $0x80048f,%rcx
  802660:	00 00 00 
  802663:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80266a:	eb 2a                	jmp    802696 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80266c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802670:	48 8b 40 30          	mov    0x30(%rax),%rax
  802674:	48 85 c0             	test   %rax,%rax
  802677:	75 07                	jne    802680 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802679:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80267e:	eb 16                	jmp    802696 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802684:	48 8b 40 30          	mov    0x30(%rax),%rax
  802688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80268c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80268f:	89 ce                	mov    %ecx,%esi
  802691:	48 89 d7             	mov    %rdx,%rdi
  802694:	ff d0                	callq  *%rax
}
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	48 83 ec 30          	sub    $0x30,%rsp
  8026a0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026a7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026ae:	48 89 d6             	mov    %rdx,%rsi
  8026b1:	89 c7                	mov    %eax,%edi
  8026b3:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8026ba:	00 00 00 
  8026bd:	ff d0                	callq  *%rax
  8026bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c6:	78 24                	js     8026ec <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cc:	8b 00                	mov    (%rax),%eax
  8026ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d2:	48 89 d6             	mov    %rdx,%rsi
  8026d5:	89 c7                	mov    %eax,%edi
  8026d7:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ea:	79 05                	jns    8026f1 <fstat+0x59>
		return r;
  8026ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ef:	eb 5e                	jmp    80274f <fstat+0xb7>
	if (!dev->dev_stat)
  8026f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026f9:	48 85 c0             	test   %rax,%rax
  8026fc:	75 07                	jne    802705 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026fe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802703:	eb 4a                	jmp    80274f <fstat+0xb7>
	stat->st_name[0] = 0;
  802705:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802709:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80270c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802710:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802717:	00 00 00 
	stat->st_isdir = 0;
  80271a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80271e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802725:	00 00 00 
	stat->st_dev = dev;
  802728:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80272c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802730:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80273f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802743:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802747:	48 89 ce             	mov    %rcx,%rsi
  80274a:	48 89 d7             	mov    %rdx,%rdi
  80274d:	ff d0                	callq  *%rax
}
  80274f:	c9                   	leaveq 
  802750:	c3                   	retq   

0000000000802751 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802751:	55                   	push   %rbp
  802752:	48 89 e5             	mov    %rsp,%rbp
  802755:	48 83 ec 20          	sub    $0x20,%rsp
  802759:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80275d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802765:	be 00 00 00 00       	mov    $0x0,%esi
  80276a:	48 89 c7             	mov    %rax,%rdi
  80276d:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
  802779:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802780:	79 05                	jns    802787 <stat+0x36>
		return fd;
  802782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802785:	eb 2f                	jmp    8027b6 <stat+0x65>
	r = fstat(fd, stat);
  802787:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80278b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278e:	48 89 d6             	mov    %rdx,%rsi
  802791:	89 c7                	mov    %eax,%edi
  802793:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a5:	89 c7                	mov    %eax,%edi
  8027a7:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	callq  *%rax
	return r;
  8027b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027b6:	c9                   	leaveq 
  8027b7:	c3                   	retq   

00000000008027b8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027b8:	55                   	push   %rbp
  8027b9:	48 89 e5             	mov    %rsp,%rbp
  8027bc:	48 83 ec 10          	sub    $0x10,%rsp
  8027c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027ce:	00 00 00 
  8027d1:	8b 00                	mov    (%rax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	75 1f                	jne    8027f6 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8027dc:	48 b8 51 40 80 00 00 	movabs $0x804051,%rax
  8027e3:	00 00 00 
  8027e6:	ff d0                	callq  *%rax
  8027e8:	89 c2                	mov    %eax,%edx
  8027ea:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f1:	00 00 00 
  8027f4:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027f6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027fd:	00 00 00 
  802800:	8b 00                	mov    (%rax),%eax
  802802:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802805:	b9 07 00 00 00       	mov    $0x7,%ecx
  80280a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802811:	00 00 00 
  802814:	89 c7                	mov    %eax,%edi
  802816:	48 b8 bc 3f 80 00 00 	movabs $0x803fbc,%rax
  80281d:	00 00 00 
  802820:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802826:	ba 00 00 00 00       	mov    $0x0,%edx
  80282b:	48 89 c6             	mov    %rax,%rsi
  80282e:	bf 00 00 00 00       	mov    $0x0,%edi
  802833:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	callq  *%rax
}
  80283f:	c9                   	leaveq 
  802840:	c3                   	retq   

0000000000802841 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802841:	55                   	push   %rbp
  802842:	48 89 e5             	mov    %rsp,%rbp
  802845:	48 83 ec 20          	sub    $0x20,%rsp
  802849:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80284d:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802854:	48 89 c7             	mov    %rax,%rdi
  802857:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
  802863:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802868:	7e 0a                	jle    802874 <open+0x33>
		return -E_BAD_PATH;
  80286a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80286f:	e9 a5 00 00 00       	jmpq   802919 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802874:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802878:	48 89 c7             	mov    %rax,%rdi
  80287b:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288e:	79 08                	jns    802898 <open+0x57>
		return r;
  802890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802893:	e9 81 00 00 00       	jmpq   802919 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289c:	48 89 c6             	mov    %rax,%rsi
  80289f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028a6:	00 00 00 
  8028a9:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8028b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028bc:	00 00 00 
  8028bf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8028c2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cc:	48 89 c6             	mov    %rax,%rsi
  8028cf:	bf 01 00 00 00       	mov    $0x1,%edi
  8028d4:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
  8028e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e7:	79 1d                	jns    802906 <open+0xc5>
		fd_close(fd, 0);
  8028e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ed:	be 00 00 00 00       	mov    $0x0,%esi
  8028f2:	48 89 c7             	mov    %rax,%rdi
  8028f5:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
		return r;
  802901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802904:	eb 13                	jmp    802919 <open+0xd8>
	}

	return fd2num(fd);
  802906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290a:	48 89 c7             	mov    %rax,%rdi
  80290d:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax

}
  802919:	c9                   	leaveq 
  80291a:	c3                   	retq   

000000000080291b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80291b:	55                   	push   %rbp
  80291c:	48 89 e5             	mov    %rsp,%rbp
  80291f:	48 83 ec 10          	sub    $0x10,%rsp
  802923:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80292b:	8b 50 0c             	mov    0xc(%rax),%edx
  80292e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802935:	00 00 00 
  802938:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80293a:	be 00 00 00 00       	mov    $0x0,%esi
  80293f:	bf 06 00 00 00       	mov    $0x6,%edi
  802944:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
}
  802950:	c9                   	leaveq 
  802951:	c3                   	retq   

0000000000802952 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802952:	55                   	push   %rbp
  802953:	48 89 e5             	mov    %rsp,%rbp
  802956:	48 83 ec 30          	sub    $0x30,%rsp
  80295a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80295e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802962:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296a:	8b 50 0c             	mov    0xc(%rax),%edx
  80296d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802974:	00 00 00 
  802977:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802979:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802980:	00 00 00 
  802983:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802987:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80298b:	be 00 00 00 00       	mov    $0x0,%esi
  802990:	bf 03 00 00 00       	mov    $0x3,%edi
  802995:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	callq  *%rax
  8029a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a8:	79 08                	jns    8029b2 <devfile_read+0x60>
		return r;
  8029aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ad:	e9 a4 00 00 00       	jmpq   802a56 <devfile_read+0x104>
	assert(r <= n);
  8029b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b5:	48 98                	cltq   
  8029b7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029bb:	76 35                	jbe    8029f2 <devfile_read+0xa0>
  8029bd:	48 b9 56 47 80 00 00 	movabs $0x804756,%rcx
  8029c4:	00 00 00 
  8029c7:	48 ba 5d 47 80 00 00 	movabs $0x80475d,%rdx
  8029ce:	00 00 00 
  8029d1:	be 86 00 00 00       	mov    $0x86,%esi
  8029d6:	48 bf 72 47 80 00 00 	movabs $0x804772,%rdi
  8029dd:	00 00 00 
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  8029ec:	00 00 00 
  8029ef:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8029f2:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8029f9:	7e 35                	jle    802a30 <devfile_read+0xde>
  8029fb:	48 b9 7d 47 80 00 00 	movabs $0x80477d,%rcx
  802a02:	00 00 00 
  802a05:	48 ba 5d 47 80 00 00 	movabs $0x80475d,%rdx
  802a0c:	00 00 00 
  802a0f:	be 87 00 00 00       	mov    $0x87,%esi
  802a14:	48 bf 72 47 80 00 00 	movabs $0x804772,%rdi
  802a1b:	00 00 00 
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a23:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  802a2a:	00 00 00 
  802a2d:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a33:	48 63 d0             	movslq %eax,%rdx
  802a36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a41:	00 00 00 
  802a44:	48 89 c7             	mov    %rax,%rdi
  802a47:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  802a4e:	00 00 00 
  802a51:	ff d0                	callq  *%rax
	return r;
  802a53:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802a56:	c9                   	leaveq 
  802a57:	c3                   	retq   

0000000000802a58 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a58:	55                   	push   %rbp
  802a59:	48 89 e5             	mov    %rsp,%rbp
  802a5c:	48 83 ec 40          	sub    $0x40,%rsp
  802a60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a68:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802a6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a74:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802a7b:	00 
  802a7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a80:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802a84:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802a89:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a91:	8b 50 0c             	mov    0xc(%rax),%edx
  802a94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a9b:	00 00 00 
  802a9e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802aa0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa7:	00 00 00 
  802aaa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aae:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802ab2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ab6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aba:	48 89 c6             	mov    %rax,%rsi
  802abd:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ac4:	00 00 00 
  802ac7:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802ad3:	be 00 00 00 00       	mov    $0x0,%esi
  802ad8:	bf 04 00 00 00       	mov    $0x4,%edi
  802add:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
  802ae9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802af0:	79 05                	jns    802af7 <devfile_write+0x9f>
		return r;
  802af2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802af5:	eb 43                	jmp    802b3a <devfile_write+0xe2>
	assert(r <= n);
  802af7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802afa:	48 98                	cltq   
  802afc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802b00:	76 35                	jbe    802b37 <devfile_write+0xdf>
  802b02:	48 b9 56 47 80 00 00 	movabs $0x804756,%rcx
  802b09:	00 00 00 
  802b0c:	48 ba 5d 47 80 00 00 	movabs $0x80475d,%rdx
  802b13:	00 00 00 
  802b16:	be a2 00 00 00       	mov    $0xa2,%esi
  802b1b:	48 bf 72 47 80 00 00 	movabs $0x804772,%rdi
  802b22:	00 00 00 
  802b25:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2a:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  802b31:	00 00 00 
  802b34:	41 ff d0             	callq  *%r8
	return r;
  802b37:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802b3a:	c9                   	leaveq 
  802b3b:	c3                   	retq   

0000000000802b3c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b3c:	55                   	push   %rbp
  802b3d:	48 89 e5             	mov    %rsp,%rbp
  802b40:	48 83 ec 20          	sub    $0x20,%rsp
  802b44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b50:	8b 50 0c             	mov    0xc(%rax),%edx
  802b53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b5a:	00 00 00 
  802b5d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b5f:	be 00 00 00 00       	mov    $0x0,%esi
  802b64:	bf 05 00 00 00       	mov    $0x5,%edi
  802b69:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7c:	79 05                	jns    802b83 <devfile_stat+0x47>
		return r;
  802b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b81:	eb 56                	jmp    802bd9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b87:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b8e:	00 00 00 
  802b91:	48 89 c7             	mov    %rax,%rdi
  802b94:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ba0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba7:	00 00 00 
  802baa:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bc1:	00 00 00 
  802bc4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bce:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
  802bdf:	48 83 ec 10          	sub    $0x10,%rsp
  802be3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802be7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bee:	8b 50 0c             	mov    0xc(%rax),%edx
  802bf1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf8:	00 00 00 
  802bfb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bfd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c04:	00 00 00 
  802c07:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c0a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c0d:	be 00 00 00 00       	mov    $0x0,%esi
  802c12:	bf 02 00 00 00       	mov    $0x2,%edi
  802c17:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
}
  802c23:	c9                   	leaveq 
  802c24:	c3                   	retq   

0000000000802c25 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	48 83 ec 10          	sub    $0x10,%rsp
  802c2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c35:	48 89 c7             	mov    %rax,%rdi
  802c38:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
  802c44:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c49:	7e 07                	jle    802c52 <remove+0x2d>
		return -E_BAD_PATH;
  802c4b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c50:	eb 33                	jmp    802c85 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c56:	48 89 c6             	mov    %rax,%rsi
  802c59:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c60:	00 00 00 
  802c63:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c6f:	be 00 00 00 00       	mov    $0x0,%esi
  802c74:	bf 07 00 00 00       	mov    $0x7,%edi
  802c79:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
}
  802c85:	c9                   	leaveq 
  802c86:	c3                   	retq   

0000000000802c87 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c87:	55                   	push   %rbp
  802c88:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c8b:	be 00 00 00 00       	mov    $0x0,%esi
  802c90:	bf 08 00 00 00       	mov    $0x8,%edi
  802c95:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
}
  802ca1:	5d                   	pop    %rbp
  802ca2:	c3                   	retq   

0000000000802ca3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ca3:	55                   	push   %rbp
  802ca4:	48 89 e5             	mov    %rsp,%rbp
  802ca7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cae:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cb5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cbc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cc3:	be 00 00 00 00       	mov    $0x0,%esi
  802cc8:	48 89 c7             	mov    %rax,%rdi
  802ccb:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
  802cd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cde:	79 28                	jns    802d08 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce3:	89 c6                	mov    %eax,%esi
  802ce5:	48 bf 89 47 80 00 00 	movabs $0x804789,%rdi
  802cec:	00 00 00 
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf4:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802cfb:	00 00 00 
  802cfe:	ff d2                	callq  *%rdx
		return fd_src;
  802d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d03:	e9 76 01 00 00       	jmpq   802e7e <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d08:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d0f:	be 01 01 00 00       	mov    $0x101,%esi
  802d14:	48 89 c7             	mov    %rax,%rdi
  802d17:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
  802d23:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d26:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d2a:	0f 89 ad 00 00 00    	jns    802ddd <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d33:	89 c6                	mov    %eax,%esi
  802d35:	48 bf 9f 47 80 00 00 	movabs $0x80479f,%rdi
  802d3c:	00 00 00 
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d44:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802d4b:	00 00 00 
  802d4e:	ff d2                	callq  *%rdx
		close(fd_src);
  802d50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d53:	89 c7                	mov    %eax,%edi
  802d55:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	callq  *%rax
		return fd_dest;
  802d61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d64:	e9 15 01 00 00       	jmpq   802e7e <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802d69:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d6c:	48 63 d0             	movslq %eax,%rdx
  802d6f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d79:	48 89 ce             	mov    %rcx,%rsi
  802d7c:	89 c7                	mov    %eax,%edi
  802d7e:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
  802d8a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d91:	79 4a                	jns    802ddd <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802d93:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d96:	89 c6                	mov    %eax,%esi
  802d98:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  802d9f:	00 00 00 
  802da2:	b8 00 00 00 00       	mov    $0x0,%eax
  802da7:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802dae:	00 00 00 
  802db1:	ff d2                	callq  *%rdx
			close(fd_src);
  802db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db6:	89 c7                	mov    %eax,%edi
  802db8:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
			close(fd_dest);
  802dc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc7:	89 c7                	mov    %eax,%edi
  802dc9:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
			return write_size;
  802dd5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dd8:	e9 a1 00 00 00       	jmpq   802e7e <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ddd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de7:	ba 00 02 00 00       	mov    $0x200,%edx
  802dec:	48 89 ce             	mov    %rcx,%rsi
  802def:	89 c7                	mov    %eax,%edi
  802df1:	48 b8 68 23 80 00 00 	movabs $0x802368,%rax
  802df8:	00 00 00 
  802dfb:	ff d0                	callq  *%rax
  802dfd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e04:	0f 8f 5f ff ff ff    	jg     802d69 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e0e:	79 47                	jns    802e57 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802e10:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e13:	89 c6                	mov    %eax,%esi
  802e15:	48 bf cc 47 80 00 00 	movabs $0x8047cc,%rdi
  802e1c:	00 00 00 
  802e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e24:	48 ba 8f 04 80 00 00 	movabs $0x80048f,%rdx
  802e2b:	00 00 00 
  802e2e:	ff d2                	callq  *%rdx
		close(fd_src);
  802e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e33:	89 c7                	mov    %eax,%edi
  802e35:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802e3c:	00 00 00 
  802e3f:	ff d0                	callq  *%rax
		close(fd_dest);
  802e41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
		return read_size;
  802e52:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e55:	eb 27                	jmp    802e7e <copy+0x1db>
	}
	close(fd_src);
  802e57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5a:	89 c7                	mov    %eax,%edi
  802e5c:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
	close(fd_dest);
  802e68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e6b:	89 c7                	mov    %eax,%edi
  802e6d:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  802e74:	00 00 00 
  802e77:	ff d0                	callq  *%rax
	return 0;
  802e79:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e7e:	c9                   	leaveq 
  802e7f:	c3                   	retq   

0000000000802e80 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e80:	55                   	push   %rbp
  802e81:	48 89 e5             	mov    %rsp,%rbp
  802e84:	48 83 ec 20          	sub    $0x20,%rsp
  802e88:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e92:	48 89 d6             	mov    %rdx,%rsi
  802e95:	89 c7                	mov    %eax,%edi
  802e97:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eaa:	79 05                	jns    802eb1 <fd2sockid+0x31>
		return r;
  802eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaf:	eb 24                	jmp    802ed5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb5:	8b 10                	mov    (%rax),%edx
  802eb7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ebe:	00 00 00 
  802ec1:	8b 00                	mov    (%rax),%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	74 07                	je     802ece <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802ec7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ecc:	eb 07                	jmp    802ed5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ed5:	c9                   	leaveq 
  802ed6:	c3                   	retq   

0000000000802ed7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ed7:	55                   	push   %rbp
  802ed8:	48 89 e5             	mov    %rsp,%rbp
  802edb:	48 83 ec 20          	sub    $0x20,%rsp
  802edf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ee2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ee6:	48 89 c7             	mov    %rax,%rdi
  802ee9:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  802ef0:	00 00 00 
  802ef3:	ff d0                	callq  *%rax
  802ef5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802efc:	78 26                	js     802f24 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f02:	ba 07 04 00 00       	mov    $0x407,%edx
  802f07:	48 89 c6             	mov    %rax,%rsi
  802f0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0f:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	callq  *%rax
  802f1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f22:	79 16                	jns    802f3a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f27:	89 c7                	mov    %eax,%edi
  802f29:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
		return r;
  802f35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f38:	eb 3a                	jmp    802f74 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f45:	00 00 00 
  802f48:	8b 12                	mov    (%rdx),%edx
  802f4a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f50:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f5e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f65:	48 89 c7             	mov    %rax,%rdi
  802f68:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  802f6f:	00 00 00 
  802f72:	ff d0                	callq  *%rax
}
  802f74:	c9                   	leaveq 
  802f75:	c3                   	retq   

0000000000802f76 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f76:	55                   	push   %rbp
  802f77:	48 89 e5             	mov    %rsp,%rbp
  802f7a:	48 83 ec 30          	sub    $0x30,%rsp
  802f7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f85:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f8c:	89 c7                	mov    %eax,%edi
  802f8e:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
  802f9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa1:	79 05                	jns    802fa8 <accept+0x32>
		return r;
  802fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa6:	eb 3b                	jmp    802fe3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802fa8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fac:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb3:	48 89 ce             	mov    %rcx,%rsi
  802fb6:	89 c7                	mov    %eax,%edi
  802fb8:	48 b8 c3 32 80 00 00 	movabs $0x8032c3,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
  802fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcb:	79 05                	jns    802fd2 <accept+0x5c>
		return r;
  802fcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd0:	eb 11                	jmp    802fe3 <accept+0x6d>
	return alloc_sockfd(r);
  802fd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd5:	89 c7                	mov    %eax,%edi
  802fd7:	48 b8 d7 2e 80 00 00 	movabs $0x802ed7,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
}
  802fe3:	c9                   	leaveq 
  802fe4:	c3                   	retq   

0000000000802fe5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fe5:	55                   	push   %rbp
  802fe6:	48 89 e5             	mov    %rsp,%rbp
  802fe9:	48 83 ec 20          	sub    $0x20,%rsp
  802fed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ff0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ff7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ffa:	89 c7                	mov    %eax,%edi
  802ffc:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  803003:	00 00 00 
  803006:	ff d0                	callq  *%rax
  803008:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300f:	79 05                	jns    803016 <bind+0x31>
		return r;
  803011:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803014:	eb 1b                	jmp    803031 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803016:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803019:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80301d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803020:	48 89 ce             	mov    %rcx,%rsi
  803023:	89 c7                	mov    %eax,%edi
  803025:	48 b8 42 33 80 00 00 	movabs $0x803342,%rax
  80302c:	00 00 00 
  80302f:	ff d0                	callq  *%rax
}
  803031:	c9                   	leaveq 
  803032:	c3                   	retq   

0000000000803033 <shutdown>:

int
shutdown(int s, int how)
{
  803033:	55                   	push   %rbp
  803034:	48 89 e5             	mov    %rsp,%rbp
  803037:	48 83 ec 20          	sub    $0x20,%rsp
  80303b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80303e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803041:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803044:	89 c7                	mov    %eax,%edi
  803046:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803055:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803059:	79 05                	jns    803060 <shutdown+0x2d>
		return r;
  80305b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305e:	eb 16                	jmp    803076 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803060:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803066:	89 d6                	mov    %edx,%esi
  803068:	89 c7                	mov    %eax,%edi
  80306a:	48 b8 a6 33 80 00 00 	movabs $0x8033a6,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
}
  803076:	c9                   	leaveq 
  803077:	c3                   	retq   

0000000000803078 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803078:	55                   	push   %rbp
  803079:	48 89 e5             	mov    %rsp,%rbp
  80307c:	48 83 ec 10          	sub    $0x10,%rsp
  803080:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803088:	48 89 c7             	mov    %rax,%rdi
  80308b:	48 b8 c2 40 80 00 00 	movabs $0x8040c2,%rax
  803092:	00 00 00 
  803095:	ff d0                	callq  *%rax
  803097:	83 f8 01             	cmp    $0x1,%eax
  80309a:	75 17                	jne    8030b3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80309c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a0:	8b 40 0c             	mov    0xc(%rax),%eax
  8030a3:	89 c7                	mov    %eax,%edi
  8030a5:	48 b8 e6 33 80 00 00 	movabs $0x8033e6,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
  8030b1:	eb 05                	jmp    8030b8 <devsock_close+0x40>
	else
		return 0;
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b8:	c9                   	leaveq 
  8030b9:	c3                   	retq   

00000000008030ba <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030ba:	55                   	push   %rbp
  8030bb:	48 89 e5             	mov    %rsp,%rbp
  8030be:	48 83 ec 20          	sub    $0x20,%rsp
  8030c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030cf:	89 c7                	mov    %eax,%edi
  8030d1:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
  8030dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e4:	79 05                	jns    8030eb <connect+0x31>
		return r;
  8030e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e9:	eb 1b                	jmp    803106 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8030eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f5:	48 89 ce             	mov    %rcx,%rsi
  8030f8:	89 c7                	mov    %eax,%edi
  8030fa:	48 b8 13 34 80 00 00 	movabs $0x803413,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
}
  803106:	c9                   	leaveq 
  803107:	c3                   	retq   

0000000000803108 <listen>:

int
listen(int s, int backlog)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 83 ec 20          	sub    $0x20,%rsp
  803110:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803113:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803116:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803119:	89 c7                	mov    %eax,%edi
  80311b:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
  803127:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312e:	79 05                	jns    803135 <listen+0x2d>
		return r;
  803130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803133:	eb 16                	jmp    80314b <listen+0x43>
	return nsipc_listen(r, backlog);
  803135:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313b:	89 d6                	mov    %edx,%esi
  80313d:	89 c7                	mov    %eax,%edi
  80313f:	48 b8 77 34 80 00 00 	movabs $0x803477,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 20          	sub    $0x20,%rsp
  803155:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803159:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80315d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803165:	89 c2                	mov    %eax,%edx
  803167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80316b:	8b 40 0c             	mov    0xc(%rax),%eax
  80316e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803172:	b9 00 00 00 00       	mov    $0x0,%ecx
  803177:	89 c7                	mov    %eax,%edi
  803179:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
}
  803185:	c9                   	leaveq 
  803186:	c3                   	retq   

0000000000803187 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803187:	55                   	push   %rbp
  803188:	48 89 e5             	mov    %rsp,%rbp
  80318b:	48 83 ec 20          	sub    $0x20,%rsp
  80318f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803193:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803197:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80319b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319f:	89 c2                	mov    %eax,%edx
  8031a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a5:	8b 40 0c             	mov    0xc(%rax),%eax
  8031a8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031b1:	89 c7                	mov    %eax,%edi
  8031b3:	48 b8 83 35 80 00 00 	movabs $0x803583,%rax
  8031ba:	00 00 00 
  8031bd:	ff d0                	callq  *%rax
}
  8031bf:	c9                   	leaveq 
  8031c0:	c3                   	retq   

00000000008031c1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8031c1:	55                   	push   %rbp
  8031c2:	48 89 e5             	mov    %rsp,%rbp
  8031c5:	48 83 ec 10          	sub    $0x10,%rsp
  8031c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d5:	48 be e7 47 80 00 00 	movabs $0x8047e7,%rsi
  8031dc:	00 00 00 
  8031df:	48 89 c7             	mov    %rax,%rdi
  8031e2:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8031e9:	00 00 00 
  8031ec:	ff d0                	callq  *%rax
	return 0;
  8031ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f3:	c9                   	leaveq 
  8031f4:	c3                   	retq   

00000000008031f5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8031f5:	55                   	push   %rbp
  8031f6:	48 89 e5             	mov    %rsp,%rbp
  8031f9:	48 83 ec 20          	sub    $0x20,%rsp
  8031fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803200:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803203:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803206:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803209:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80320c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320f:	89 ce                	mov    %ecx,%esi
  803211:	89 c7                	mov    %eax,%edi
  803213:	48 b8 3b 36 80 00 00 	movabs $0x80363b,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
  80321f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803226:	79 05                	jns    80322d <socket+0x38>
		return r;
  803228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322b:	eb 11                	jmp    80323e <socket+0x49>
	return alloc_sockfd(r);
  80322d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803230:	89 c7                	mov    %eax,%edi
  803232:	48 b8 d7 2e 80 00 00 	movabs $0x802ed7,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
}
  80323e:	c9                   	leaveq 
  80323f:	c3                   	retq   

0000000000803240 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803240:	55                   	push   %rbp
  803241:	48 89 e5             	mov    %rsp,%rbp
  803244:	48 83 ec 10          	sub    $0x10,%rsp
  803248:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80324b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803252:	00 00 00 
  803255:	8b 00                	mov    (%rax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	75 1f                	jne    80327a <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80325b:	bf 02 00 00 00       	mov    $0x2,%edi
  803260:	48 b8 51 40 80 00 00 	movabs $0x804051,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
  80326c:	89 c2                	mov    %eax,%edx
  80326e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803275:	00 00 00 
  803278:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80327a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803281:	00 00 00 
  803284:	8b 00                	mov    (%rax),%eax
  803286:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803289:	b9 07 00 00 00       	mov    $0x7,%ecx
  80328e:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803295:	00 00 00 
  803298:	89 c7                	mov    %eax,%edi
  80329a:	48 b8 bc 3f 80 00 00 	movabs $0x803fbc,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8032a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ab:	be 00 00 00 00       	mov    $0x0,%esi
  8032b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b5:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  8032bc:	00 00 00 
  8032bf:	ff d0                	callq  *%rax
}
  8032c1:	c9                   	leaveq 
  8032c2:	c3                   	retq   

00000000008032c3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032c3:	55                   	push   %rbp
  8032c4:	48 89 e5             	mov    %rsp,%rbp
  8032c7:	48 83 ec 30          	sub    $0x30,%rsp
  8032cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032d6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032dd:	00 00 00 
  8032e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032e3:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8032ea:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  8032f1:	00 00 00 
  8032f4:	ff d0                	callq  *%rax
  8032f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fd:	78 3e                	js     80333d <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8032ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803306:	00 00 00 
  803309:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80330d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803311:	8b 40 10             	mov    0x10(%rax),%eax
  803314:	89 c2                	mov    %eax,%edx
  803316:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80331a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331e:	48 89 ce             	mov    %rcx,%rsi
  803321:	48 89 c7             	mov    %rax,%rdi
  803324:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803334:	8b 50 10             	mov    0x10(%rax),%edx
  803337:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80333b:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80333d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803340:	c9                   	leaveq 
  803341:	c3                   	retq   

0000000000803342 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803342:	55                   	push   %rbp
  803343:	48 89 e5             	mov    %rsp,%rbp
  803346:	48 83 ec 10          	sub    $0x10,%rsp
  80334a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80334d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803351:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803354:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335b:	00 00 00 
  80335e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803361:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803363:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336a:	48 89 c6             	mov    %rax,%rsi
  80336d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803374:	00 00 00 
  803377:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803383:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80338a:	00 00 00 
  80338d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803390:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803393:	bf 02 00 00 00       	mov    $0x2,%edi
  803398:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
}
  8033a4:	c9                   	leaveq 
  8033a5:	c3                   	retq   

00000000008033a6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033a6:	55                   	push   %rbp
  8033a7:	48 89 e5             	mov    %rsp,%rbp
  8033aa:	48 83 ec 10          	sub    $0x10,%rsp
  8033ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033b1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8033b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033bb:	00 00 00 
  8033be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033c1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8033c3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ca:	00 00 00 
  8033cd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033d0:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033d3:	bf 03 00 00 00       	mov    $0x3,%edi
  8033d8:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
}
  8033e4:	c9                   	leaveq 
  8033e5:	c3                   	retq   

00000000008033e6 <nsipc_close>:

int
nsipc_close(int s)
{
  8033e6:	55                   	push   %rbp
  8033e7:	48 89 e5             	mov    %rsp,%rbp
  8033ea:	48 83 ec 10          	sub    $0x10,%rsp
  8033ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8033f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f8:	00 00 00 
  8033fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033fe:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803400:	bf 04 00 00 00       	mov    $0x4,%edi
  803405:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
}
  803411:	c9                   	leaveq 
  803412:	c3                   	retq   

0000000000803413 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803413:	55                   	push   %rbp
  803414:	48 89 e5             	mov    %rsp,%rbp
  803417:	48 83 ec 10          	sub    $0x10,%rsp
  80341b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80341e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803422:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803425:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342c:	00 00 00 
  80342f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803432:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803434:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343b:	48 89 c6             	mov    %rax,%rsi
  80343e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803445:	00 00 00 
  803448:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803454:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80345b:	00 00 00 
  80345e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803461:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803464:	bf 05 00 00 00       	mov    $0x5,%edi
  803469:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  803470:	00 00 00 
  803473:	ff d0                	callq  *%rax
}
  803475:	c9                   	leaveq 
  803476:	c3                   	retq   

0000000000803477 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803477:	55                   	push   %rbp
  803478:	48 89 e5             	mov    %rsp,%rbp
  80347b:	48 83 ec 10          	sub    $0x10,%rsp
  80347f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803482:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803485:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348c:	00 00 00 
  80348f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803492:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803494:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80349b:	00 00 00 
  80349e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8034a4:	bf 06 00 00 00       	mov    $0x6,%edi
  8034a9:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
}
  8034b5:	c9                   	leaveq 
  8034b6:	c3                   	retq   

00000000008034b7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8034b7:	55                   	push   %rbp
  8034b8:	48 89 e5             	mov    %rsp,%rbp
  8034bb:	48 83 ec 30          	sub    $0x30,%rsp
  8034bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c6:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8034c9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8034cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d3:	00 00 00 
  8034d6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034d9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e2:	00 00 00 
  8034e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034e8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8034eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034f2:	00 00 00 
  8034f5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034f8:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034fb:	bf 07 00 00 00       	mov    $0x7,%edi
  803500:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
  80350c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803513:	78 69                	js     80357e <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803515:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80351c:	7f 08                	jg     803526 <nsipc_recv+0x6f>
  80351e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803521:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803524:	7e 35                	jle    80355b <nsipc_recv+0xa4>
  803526:	48 b9 ee 47 80 00 00 	movabs $0x8047ee,%rcx
  80352d:	00 00 00 
  803530:	48 ba 03 48 80 00 00 	movabs $0x804803,%rdx
  803537:	00 00 00 
  80353a:	be 62 00 00 00       	mov    $0x62,%esi
  80353f:	48 bf 18 48 80 00 00 	movabs $0x804818,%rdi
  803546:	00 00 00 
  803549:	b8 00 00 00 00       	mov    $0x0,%eax
  80354e:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  803555:	00 00 00 
  803558:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80355b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355e:	48 63 d0             	movslq %eax,%rdx
  803561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803565:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80356c:	00 00 00 
  80356f:	48 89 c7             	mov    %rax,%rdi
  803572:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
	}

	return r;
  80357e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803581:	c9                   	leaveq 
  803582:	c3                   	retq   

0000000000803583 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803583:	55                   	push   %rbp
  803584:	48 89 e5             	mov    %rsp,%rbp
  803587:	48 83 ec 20          	sub    $0x20,%rsp
  80358b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80358e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803592:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803595:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803598:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359f:	00 00 00 
  8035a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035a5:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8035a7:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8035ae:	7e 35                	jle    8035e5 <nsipc_send+0x62>
  8035b0:	48 b9 24 48 80 00 00 	movabs $0x804824,%rcx
  8035b7:	00 00 00 
  8035ba:	48 ba 03 48 80 00 00 	movabs $0x804803,%rdx
  8035c1:	00 00 00 
  8035c4:	be 6d 00 00 00       	mov    $0x6d,%esi
  8035c9:	48 bf 18 48 80 00 00 	movabs $0x804818,%rdi
  8035d0:	00 00 00 
  8035d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d8:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  8035df:	00 00 00 
  8035e2:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e8:	48 63 d0             	movslq %eax,%rdx
  8035eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ef:	48 89 c6             	mov    %rax,%rsi
  8035f2:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8035f9:	00 00 00 
  8035fc:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803608:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360f:	00 00 00 
  803612:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803615:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803618:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361f:	00 00 00 
  803622:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803625:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803628:	bf 08 00 00 00       	mov    $0x8,%edi
  80362d:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
}
  803639:	c9                   	leaveq 
  80363a:	c3                   	retq   

000000000080363b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80363b:	55                   	push   %rbp
  80363c:	48 89 e5             	mov    %rsp,%rbp
  80363f:	48 83 ec 10          	sub    $0x10,%rsp
  803643:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803646:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803649:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80364c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803653:	00 00 00 
  803656:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803659:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80365b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803662:	00 00 00 
  803665:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803668:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80366b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803672:	00 00 00 
  803675:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803678:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80367b:	bf 09 00 00 00       	mov    $0x9,%edi
  803680:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
}
  80368c:	c9                   	leaveq 
  80368d:	c3                   	retq   

000000000080368e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80368e:	55                   	push   %rbp
  80368f:	48 89 e5             	mov    %rsp,%rbp
  803692:	53                   	push   %rbx
  803693:	48 83 ec 38          	sub    $0x38,%rsp
  803697:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80369b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80369f:	48 89 c7             	mov    %rax,%rdi
  8036a2:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
  8036ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b5:	0f 88 bf 01 00 00    	js     80387a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bf:	ba 07 04 00 00       	mov    $0x407,%edx
  8036c4:	48 89 c6             	mov    %rax,%rsi
  8036c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036cc:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
  8036d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036df:	0f 88 95 01 00 00    	js     80387a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036e5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036e9:	48 89 c7             	mov    %rax,%rdi
  8036ec:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ff:	0f 88 5d 01 00 00    	js     803862 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803705:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803709:	ba 07 04 00 00       	mov    $0x407,%edx
  80370e:	48 89 c6             	mov    %rax,%rsi
  803711:	bf 00 00 00 00       	mov    $0x0,%edi
  803716:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  80371d:	00 00 00 
  803720:	ff d0                	callq  *%rax
  803722:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803725:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803729:	0f 88 33 01 00 00    	js     803862 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80372f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803733:	48 89 c7             	mov    %rax,%rdi
  803736:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
  803742:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803746:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80374a:	ba 07 04 00 00       	mov    $0x407,%edx
  80374f:	48 89 c6             	mov    %rax,%rsi
  803752:	bf 00 00 00 00       	mov    $0x0,%edi
  803757:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  80375e:	00 00 00 
  803761:	ff d0                	callq  *%rax
  803763:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803766:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80376a:	0f 88 d9 00 00 00    	js     803849 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803774:	48 89 c7             	mov    %rax,%rdi
  803777:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  80377e:	00 00 00 
  803781:	ff d0                	callq  *%rax
  803783:	48 89 c2             	mov    %rax,%rdx
  803786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80378a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803790:	48 89 d1             	mov    %rdx,%rcx
  803793:	ba 00 00 00 00       	mov    $0x0,%edx
  803798:	48 89 c6             	mov    %rax,%rsi
  80379b:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a0:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  8037a7:	00 00 00 
  8037aa:	ff d0                	callq  *%rax
  8037ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b3:	78 79                	js     80382e <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b9:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037c0:	00 00 00 
  8037c3:	8b 12                	mov    (%rdx),%edx
  8037c5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037dd:	00 00 00 
  8037e0:	8b 12                	mov    (%rdx),%edx
  8037e2:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8037ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f3:	48 89 c7             	mov    %rax,%rdi
  8037f6:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
  803802:	89 c2                	mov    %eax,%edx
  803804:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803808:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80380a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80380e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803812:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803816:	48 89 c7             	mov    %rax,%rdi
  803819:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
  803825:	89 03                	mov    %eax,(%rbx)
	return 0;
  803827:	b8 00 00 00 00       	mov    $0x0,%eax
  80382c:	eb 4f                	jmp    80387d <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80382e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80382f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803833:	48 89 c6             	mov    %rax,%rsi
  803836:	bf 00 00 00 00       	mov    $0x0,%edi
  80383b:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803842:	00 00 00 
  803845:	ff d0                	callq  *%rax
  803847:	eb 01                	jmp    80384a <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803849:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80384a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80384e:	48 89 c6             	mov    %rax,%rsi
  803851:	bf 00 00 00 00       	mov    $0x0,%edi
  803856:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  80385d:	00 00 00 
  803860:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803866:	48 89 c6             	mov    %rax,%rsi
  803869:	bf 00 00 00 00       	mov    $0x0,%edi
  80386e:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803875:	00 00 00 
  803878:	ff d0                	callq  *%rax
err:
	return r;
  80387a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80387d:	48 83 c4 38          	add    $0x38,%rsp
  803881:	5b                   	pop    %rbx
  803882:	5d                   	pop    %rbp
  803883:	c3                   	retq   

0000000000803884 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803884:	55                   	push   %rbp
  803885:	48 89 e5             	mov    %rsp,%rbp
  803888:	53                   	push   %rbx
  803889:	48 83 ec 28          	sub    $0x28,%rsp
  80388d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803891:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803895:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80389c:	00 00 00 
  80389f:	48 8b 00             	mov    (%rax),%rax
  8038a2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038af:	48 89 c7             	mov    %rax,%rdi
  8038b2:	48 b8 c2 40 80 00 00 	movabs $0x8040c2,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
  8038be:	89 c3                	mov    %eax,%ebx
  8038c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c4:	48 89 c7             	mov    %rax,%rdi
  8038c7:	48 b8 c2 40 80 00 00 	movabs $0x8040c2,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
  8038d3:	39 c3                	cmp    %eax,%ebx
  8038d5:	0f 94 c0             	sete   %al
  8038d8:	0f b6 c0             	movzbl %al,%eax
  8038db:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038de:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038e5:	00 00 00 
  8038e8:	48 8b 00             	mov    (%rax),%rax
  8038eb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038f1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038fa:	75 05                	jne    803901 <_pipeisclosed+0x7d>
			return ret;
  8038fc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038ff:	eb 4a                	jmp    80394b <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803901:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803904:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803907:	74 8c                	je     803895 <_pipeisclosed+0x11>
  803909:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80390d:	75 86                	jne    803895 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80390f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803916:	00 00 00 
  803919:	48 8b 00             	mov    (%rax),%rax
  80391c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803922:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803925:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803928:	89 c6                	mov    %eax,%esi
  80392a:	48 bf 35 48 80 00 00 	movabs $0x804835,%rdi
  803931:	00 00 00 
  803934:	b8 00 00 00 00       	mov    $0x0,%eax
  803939:	49 b8 8f 04 80 00 00 	movabs $0x80048f,%r8
  803940:	00 00 00 
  803943:	41 ff d0             	callq  *%r8
	}
  803946:	e9 4a ff ff ff       	jmpq   803895 <_pipeisclosed+0x11>

}
  80394b:	48 83 c4 28          	add    $0x28,%rsp
  80394f:	5b                   	pop    %rbx
  803950:	5d                   	pop    %rbp
  803951:	c3                   	retq   

0000000000803952 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803952:	55                   	push   %rbp
  803953:	48 89 e5             	mov    %rsp,%rbp
  803956:	48 83 ec 30          	sub    $0x30,%rsp
  80395a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80395d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803961:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803964:	48 89 d6             	mov    %rdx,%rsi
  803967:	89 c7                	mov    %eax,%edi
  803969:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
  803975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803978:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397c:	79 05                	jns    803983 <pipeisclosed+0x31>
		return r;
  80397e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803981:	eb 31                	jmp    8039b4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803987:	48 89 c7             	mov    %rax,%rdi
  80398a:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80399a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a2:	48 89 d6             	mov    %rdx,%rsi
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
}
  8039b4:	c9                   	leaveq 
  8039b5:	c3                   	retq   

00000000008039b6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039b6:	55                   	push   %rbp
  8039b7:	48 89 e5             	mov    %rsp,%rbp
  8039ba:	48 83 ec 40          	sub    $0x40,%rsp
  8039be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ce:	48 89 c7             	mov    %rax,%rdi
  8039d1:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
  8039dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039e9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039f0:	00 
  8039f1:	e9 90 00 00 00       	jmpq   803a86 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039f6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039fb:	74 09                	je     803a06 <devpipe_read+0x50>
				return i;
  8039fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a01:	e9 8e 00 00 00       	jmpq   803a94 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0e:	48 89 d6             	mov    %rdx,%rsi
  803a11:	48 89 c7             	mov    %rax,%rdi
  803a14:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
  803a20:	85 c0                	test   %eax,%eax
  803a22:	74 07                	je     803a2b <devpipe_read+0x75>
				return 0;
  803a24:	b8 00 00 00 00       	mov    $0x0,%eax
  803a29:	eb 69                	jmp    803a94 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a2b:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3b:	8b 10                	mov    (%rax),%edx
  803a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a41:	8b 40 04             	mov    0x4(%rax),%eax
  803a44:	39 c2                	cmp    %eax,%edx
  803a46:	74 ae                	je     8039f6 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a50:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a58:	8b 00                	mov    (%rax),%eax
  803a5a:	99                   	cltd   
  803a5b:	c1 ea 1b             	shr    $0x1b,%edx
  803a5e:	01 d0                	add    %edx,%eax
  803a60:	83 e0 1f             	and    $0x1f,%eax
  803a63:	29 d0                	sub    %edx,%eax
  803a65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a69:	48 98                	cltq   
  803a6b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a70:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a76:	8b 00                	mov    (%rax),%eax
  803a78:	8d 50 01             	lea    0x1(%rax),%edx
  803a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a81:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a8e:	72 a7                	jb     803a37 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803a94:	c9                   	leaveq 
  803a95:	c3                   	retq   

0000000000803a96 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a96:	55                   	push   %rbp
  803a97:	48 89 e5             	mov    %rsp,%rbp
  803a9a:	48 83 ec 40          	sub    $0x40,%rsp
  803a9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aa2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aa6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aae:	48 89 c7             	mov    %rax,%rdi
  803ab1:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
  803abd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ac1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ac9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ad0:	00 
  803ad1:	e9 8f 00 00 00       	jmpq   803b65 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ad6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ada:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ade:	48 89 d6             	mov    %rdx,%rsi
  803ae1:	48 89 c7             	mov    %rax,%rdi
  803ae4:	48 b8 84 38 80 00 00 	movabs $0x803884,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
  803af0:	85 c0                	test   %eax,%eax
  803af2:	74 07                	je     803afb <devpipe_write+0x65>
				return 0;
  803af4:	b8 00 00 00 00       	mov    $0x0,%eax
  803af9:	eb 78                	jmp    803b73 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803afb:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803b02:	00 00 00 
  803b05:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0b:	8b 40 04             	mov    0x4(%rax),%eax
  803b0e:	48 63 d0             	movslq %eax,%rdx
  803b11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b15:	8b 00                	mov    (%rax),%eax
  803b17:	48 98                	cltq   
  803b19:	48 83 c0 20          	add    $0x20,%rax
  803b1d:	48 39 c2             	cmp    %rax,%rdx
  803b20:	73 b4                	jae    803ad6 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b26:	8b 40 04             	mov    0x4(%rax),%eax
  803b29:	99                   	cltd   
  803b2a:	c1 ea 1b             	shr    $0x1b,%edx
  803b2d:	01 d0                	add    %edx,%eax
  803b2f:	83 e0 1f             	and    $0x1f,%eax
  803b32:	29 d0                	sub    %edx,%eax
  803b34:	89 c6                	mov    %eax,%esi
  803b36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3e:	48 01 d0             	add    %rdx,%rax
  803b41:	0f b6 08             	movzbl (%rax),%ecx
  803b44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b48:	48 63 c6             	movslq %esi,%rax
  803b4b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b53:	8b 40 04             	mov    0x4(%rax),%eax
  803b56:	8d 50 01             	lea    0x1(%rax),%edx
  803b59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b60:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b69:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b6d:	72 98                	jb     803b07 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803b73:	c9                   	leaveq 
  803b74:	c3                   	retq   

0000000000803b75 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b75:	55                   	push   %rbp
  803b76:	48 89 e5             	mov    %rsp,%rbp
  803b79:	48 83 ec 20          	sub    $0x20,%rsp
  803b7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b89:	48 89 c7             	mov    %rax,%rdi
  803b8c:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803b93:	00 00 00 
  803b96:	ff d0                	callq  *%rax
  803b98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba0:	48 be 48 48 80 00 00 	movabs $0x804848,%rsi
  803ba7:	00 00 00 
  803baa:	48 89 c7             	mov    %rax,%rdi
  803bad:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  803bb4:	00 00 00 
  803bb7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bbd:	8b 50 04             	mov    0x4(%rax),%edx
  803bc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc4:	8b 00                	mov    (%rax),%eax
  803bc6:	29 c2                	sub    %eax,%edx
  803bc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bcc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803bdd:	00 00 00 
	stat->st_dev = &devpipe;
  803be0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803be4:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803beb:	00 00 00 
  803bee:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bfa:	c9                   	leaveq 
  803bfb:	c3                   	retq   

0000000000803bfc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803bfc:	55                   	push   %rbp
  803bfd:	48 89 e5             	mov    %rsp,%rbp
  803c00:	48 83 ec 10          	sub    $0x10,%rsp
  803c04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0c:	48 89 c6             	mov    %rax,%rsi
  803c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c14:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c24:	48 89 c7             	mov    %rax,%rdi
  803c27:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax
  803c33:	48 89 c6             	mov    %rax,%rsi
  803c36:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3b:	48 b8 07 1a 80 00 00 	movabs $0x801a07,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
}
  803c47:	c9                   	leaveq 
  803c48:	c3                   	retq   

0000000000803c49 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c49:	55                   	push   %rbp
  803c4a:	48 89 e5             	mov    %rsp,%rbp
  803c4d:	48 83 ec 20          	sub    $0x20,%rsp
  803c51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c57:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c5a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c5e:	be 01 00 00 00       	mov    $0x1,%esi
  803c63:	48 89 c7             	mov    %rax,%rdi
  803c66:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  803c6d:	00 00 00 
  803c70:	ff d0                	callq  *%rax
}
  803c72:	90                   	nop
  803c73:	c9                   	leaveq 
  803c74:	c3                   	retq   

0000000000803c75 <getchar>:

int
getchar(void)
{
  803c75:	55                   	push   %rbp
  803c76:	48 89 e5             	mov    %rsp,%rbp
  803c79:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c7d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c81:	ba 01 00 00 00       	mov    $0x1,%edx
  803c86:	48 89 c6             	mov    %rax,%rsi
  803c89:	bf 00 00 00 00       	mov    $0x0,%edi
  803c8e:	48 b8 68 23 80 00 00 	movabs $0x802368,%rax
  803c95:	00 00 00 
  803c98:	ff d0                	callq  *%rax
  803c9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca1:	79 05                	jns    803ca8 <getchar+0x33>
		return r;
  803ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca6:	eb 14                	jmp    803cbc <getchar+0x47>
	if (r < 1)
  803ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cac:	7f 07                	jg     803cb5 <getchar+0x40>
		return -E_EOF;
  803cae:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cb3:	eb 07                	jmp    803cbc <getchar+0x47>
	return c;
  803cb5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cb9:	0f b6 c0             	movzbl %al,%eax

}
  803cbc:	c9                   	leaveq 
  803cbd:	c3                   	retq   

0000000000803cbe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cbe:	55                   	push   %rbp
  803cbf:	48 89 e5             	mov    %rsp,%rbp
  803cc2:	48 83 ec 20          	sub    $0x20,%rsp
  803cc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cc9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ccd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd0:	48 89 d6             	mov    %rdx,%rsi
  803cd3:	89 c7                	mov    %eax,%edi
  803cd5:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  803cdc:	00 00 00 
  803cdf:	ff d0                	callq  *%rax
  803ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce8:	79 05                	jns    803cef <iscons+0x31>
		return r;
  803cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ced:	eb 1a                	jmp    803d09 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf3:	8b 10                	mov    (%rax),%edx
  803cf5:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803cfc:	00 00 00 
  803cff:	8b 00                	mov    (%rax),%eax
  803d01:	39 c2                	cmp    %eax,%edx
  803d03:	0f 94 c0             	sete   %al
  803d06:	0f b6 c0             	movzbl %al,%eax
}
  803d09:	c9                   	leaveq 
  803d0a:	c3                   	retq   

0000000000803d0b <opencons>:

int
opencons(void)
{
  803d0b:	55                   	push   %rbp
  803d0c:	48 89 e5             	mov    %rsp,%rbp
  803d0f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d13:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d17:	48 89 c7             	mov    %rax,%rdi
  803d1a:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803d21:	00 00 00 
  803d24:	ff d0                	callq  *%rax
  803d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2d:	79 05                	jns    803d34 <opencons+0x29>
		return r;
  803d2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d32:	eb 5b                	jmp    803d8f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d38:	ba 07 04 00 00       	mov    $0x407,%edx
  803d3d:	48 89 c6             	mov    %rax,%rsi
  803d40:	bf 00 00 00 00       	mov    $0x0,%edi
  803d45:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803d4c:	00 00 00 
  803d4f:	ff d0                	callq  *%rax
  803d51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d58:	79 05                	jns    803d5f <opencons+0x54>
		return r;
  803d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5d:	eb 30                	jmp    803d8f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d63:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d6a:	00 00 00 
  803d6d:	8b 12                	mov    (%rdx),%edx
  803d6f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d75:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d80:	48 89 c7             	mov    %rax,%rdi
  803d83:	48 b8 4d 1e 80 00 00 	movabs $0x801e4d,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
}
  803d8f:	c9                   	leaveq 
  803d90:	c3                   	retq   

0000000000803d91 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d91:	55                   	push   %rbp
  803d92:	48 89 e5             	mov    %rsp,%rbp
  803d95:	48 83 ec 30          	sub    $0x30,%rsp
  803d99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803da5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803daa:	75 13                	jne    803dbf <devcons_read+0x2e>
		return 0;
  803dac:	b8 00 00 00 00       	mov    $0x0,%eax
  803db1:	eb 49                	jmp    803dfc <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803db3:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803dba:	00 00 00 
  803dbd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dbf:	48 b8 5a 18 80 00 00 	movabs $0x80185a,%rax
  803dc6:	00 00 00 
  803dc9:	ff d0                	callq  *%rax
  803dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd2:	74 df                	je     803db3 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803dd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd8:	79 05                	jns    803ddf <devcons_read+0x4e>
		return c;
  803dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddd:	eb 1d                	jmp    803dfc <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ddf:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803de3:	75 07                	jne    803dec <devcons_read+0x5b>
		return 0;
  803de5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dea:	eb 10                	jmp    803dfc <devcons_read+0x6b>
	*(char*)vbuf = c;
  803dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803def:	89 c2                	mov    %eax,%edx
  803df1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df5:	88 10                	mov    %dl,(%rax)
	return 1;
  803df7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803dfc:	c9                   	leaveq 
  803dfd:	c3                   	retq   

0000000000803dfe <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dfe:	55                   	push   %rbp
  803dff:	48 89 e5             	mov    %rsp,%rbp
  803e02:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e09:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e10:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e17:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e25:	eb 76                	jmp    803e9d <devcons_write+0x9f>
		m = n - tot;
  803e27:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e2e:	89 c2                	mov    %eax,%edx
  803e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e33:	29 c2                	sub    %eax,%edx
  803e35:	89 d0                	mov    %edx,%eax
  803e37:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e3d:	83 f8 7f             	cmp    $0x7f,%eax
  803e40:	76 07                	jbe    803e49 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e42:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e4c:	48 63 d0             	movslq %eax,%rdx
  803e4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e52:	48 63 c8             	movslq %eax,%rcx
  803e55:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e5c:	48 01 c1             	add    %rax,%rcx
  803e5f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e66:	48 89 ce             	mov    %rcx,%rsi
  803e69:	48 89 c7             	mov    %rax,%rdi
  803e6c:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  803e73:	00 00 00 
  803e76:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e7b:	48 63 d0             	movslq %eax,%rdx
  803e7e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e85:	48 89 d6             	mov    %rdx,%rsi
  803e88:	48 89 c7             	mov    %rax,%rdi
  803e8b:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  803e92:	00 00 00 
  803e95:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e9a:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea0:	48 98                	cltq   
  803ea2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ea9:	0f 82 78 ff ff ff    	jb     803e27 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803eb2:	c9                   	leaveq 
  803eb3:	c3                   	retq   

0000000000803eb4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803eb4:	55                   	push   %rbp
  803eb5:	48 89 e5             	mov    %rsp,%rbp
  803eb8:	48 83 ec 08          	sub    $0x8,%rsp
  803ebc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec5:	c9                   	leaveq 
  803ec6:	c3                   	retq   

0000000000803ec7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ec7:	55                   	push   %rbp
  803ec8:	48 89 e5             	mov    %rsp,%rbp
  803ecb:	48 83 ec 10          	sub    $0x10,%rsp
  803ecf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ed3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edb:	48 be 54 48 80 00 00 	movabs $0x804854,%rsi
  803ee2:	00 00 00 
  803ee5:	48 89 c7             	mov    %rax,%rdi
  803ee8:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  803eef:	00 00 00 
  803ef2:	ff d0                	callq  *%rax
	return 0;
  803ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ef9:	c9                   	leaveq 
  803efa:	c3                   	retq   

0000000000803efb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803efb:	55                   	push   %rbp
  803efc:	48 89 e5             	mov    %rsp,%rbp
  803eff:	48 83 ec 30          	sub    $0x30,%rsp
  803f03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803f0f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f14:	75 0e                	jne    803f24 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803f16:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f1d:	00 00 00 
  803f20:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803f24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f28:	48 89 c7             	mov    %rax,%rdi
  803f2b:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  803f32:	00 00 00 
  803f35:	ff d0                	callq  *%rax
  803f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3e:	79 27                	jns    803f67 <ipc_recv+0x6c>
		if (from_env_store)
  803f40:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f45:	74 0a                	je     803f51 <ipc_recv+0x56>
			*from_env_store = 0;
  803f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f4b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803f51:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f56:	74 0a                	je     803f62 <ipc_recv+0x67>
			*perm_store = 0;
  803f58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f65:	eb 53                	jmp    803fba <ipc_recv+0xbf>
	}
	if (from_env_store)
  803f67:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f6c:	74 19                	je     803f87 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803f6e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f75:	00 00 00 
  803f78:	48 8b 00             	mov    (%rax),%rax
  803f7b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f85:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803f87:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f8c:	74 19                	je     803fa7 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803f8e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f95:	00 00 00 
  803f98:	48 8b 00             	mov    (%rax),%rax
  803f9b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803fa7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fae:	00 00 00 
  803fb1:	48 8b 00             	mov    (%rax),%rax
  803fb4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803fba:	c9                   	leaveq 
  803fbb:	c3                   	retq   

0000000000803fbc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fbc:	55                   	push   %rbp
  803fbd:	48 89 e5             	mov    %rsp,%rbp
  803fc0:	48 83 ec 30          	sub    $0x30,%rsp
  803fc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fc7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fca:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fce:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803fd1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fd6:	75 1c                	jne    803ff4 <ipc_send+0x38>
		pg = (void*) UTOP;
  803fd8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fdf:	00 00 00 
  803fe2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803fe6:	eb 0c                	jmp    803ff4 <ipc_send+0x38>
		sys_yield();
  803fe8:	48 b8 18 19 80 00 00 	movabs $0x801918,%rax
  803fef:	00 00 00 
  803ff2:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803ff4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ff7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ffa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ffe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804001:	89 c7                	mov    %eax,%edi
  804003:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  80400a:	00 00 00 
  80400d:	ff d0                	callq  *%rax
  80400f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804012:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804016:	74 d0                	je     803fe8 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804018:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401c:	79 30                	jns    80404e <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80401e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804021:	89 c1                	mov    %eax,%ecx
  804023:	48 ba 5b 48 80 00 00 	movabs $0x80485b,%rdx
  80402a:	00 00 00 
  80402d:	be 47 00 00 00       	mov    $0x47,%esi
  804032:	48 bf 71 48 80 00 00 	movabs $0x804871,%rdi
  804039:	00 00 00 
  80403c:	b8 00 00 00 00       	mov    $0x0,%eax
  804041:	49 b8 55 02 80 00 00 	movabs $0x800255,%r8
  804048:	00 00 00 
  80404b:	41 ff d0             	callq  *%r8

}
  80404e:	90                   	nop
  80404f:	c9                   	leaveq 
  804050:	c3                   	retq   

0000000000804051 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804051:	55                   	push   %rbp
  804052:	48 89 e5             	mov    %rsp,%rbp
  804055:	48 83 ec 18          	sub    $0x18,%rsp
  804059:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80405c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804063:	eb 4d                	jmp    8040b2 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804065:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80406c:	00 00 00 
  80406f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804072:	48 98                	cltq   
  804074:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80407b:	48 01 d0             	add    %rdx,%rax
  80407e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804084:	8b 00                	mov    (%rax),%eax
  804086:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804089:	75 23                	jne    8040ae <ipc_find_env+0x5d>
			return envs[i].env_id;
  80408b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804092:	00 00 00 
  804095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804098:	48 98                	cltq   
  80409a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8040a1:	48 01 d0             	add    %rdx,%rax
  8040a4:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8040aa:	8b 00                	mov    (%rax),%eax
  8040ac:	eb 12                	jmp    8040c0 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040b2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040b9:	7e aa                	jle    804065 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c0:	c9                   	leaveq 
  8040c1:	c3                   	retq   

00000000008040c2 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8040c2:	55                   	push   %rbp
  8040c3:	48 89 e5             	mov    %rsp,%rbp
  8040c6:	48 83 ec 18          	sub    $0x18,%rsp
  8040ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d2:	48 c1 e8 15          	shr    $0x15,%rax
  8040d6:	48 89 c2             	mov    %rax,%rdx
  8040d9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040e0:	01 00 00 
  8040e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040e7:	83 e0 01             	and    $0x1,%eax
  8040ea:	48 85 c0             	test   %rax,%rax
  8040ed:	75 07                	jne    8040f6 <pageref+0x34>
		return 0;
  8040ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f4:	eb 56                	jmp    80414c <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8040f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8040fe:	48 89 c2             	mov    %rax,%rdx
  804101:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804108:	01 00 00 
  80410b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80410f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804117:	83 e0 01             	and    $0x1,%eax
  80411a:	48 85 c0             	test   %rax,%rax
  80411d:	75 07                	jne    804126 <pageref+0x64>
		return 0;
  80411f:	b8 00 00 00 00       	mov    $0x0,%eax
  804124:	eb 26                	jmp    80414c <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412a:	48 c1 e8 0c          	shr    $0xc,%rax
  80412e:	48 89 c2             	mov    %rax,%rdx
  804131:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804138:	00 00 00 
  80413b:	48 c1 e2 04          	shl    $0x4,%rdx
  80413f:	48 01 d0             	add    %rdx,%rax
  804142:	48 83 c0 08          	add    $0x8,%rax
  804146:	0f b7 00             	movzwl (%rax),%eax
  804149:	0f b7 c0             	movzwl %ax,%eax
}
  80414c:	c9                   	leaveq 
  80414d:	c3                   	retq   
