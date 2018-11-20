
obj/user/testpteshare:     file format elf64-x86-64


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
  80003c:	e8 69 02 00 00       	callq  8002aa <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 76 02 80 00 00 	movabs $0x800276,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba be 55 80 00 00 	movabs $0x8055be,%rdx
  800094:	00 00 00 
  800097:	be 14 00 00 00       	mov    $0x14,%esi
  80009c:	48 bf d1 55 80 00 00 	movabs $0x8055d1,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 eb 22 80 00 00 	movabs $0x8022eb,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba e5 55 80 00 00 	movabs $0x8055e5,%rdx
  8000d9:	00 00 00 
  8000dc:	be 18 00 00 00       	mov    $0x18,%esi
  8000e1:	48 bf d1 55 80 00 00 	movabs $0x8055d1,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 ca 4e 80 00 00 	movabs $0x804eca,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 7e 12 80 00 00 	movabs $0x80127e,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 ee 55 80 00 00 	movabs $0x8055ee,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 f4 55 80 00 00 	movabs $0x8055f4,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf fa 55 80 00 00 	movabs $0x8055fa,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 15 56 80 00 00 	movabs $0x805615,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 19 56 80 00 00 	movabs $0x805619,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 26 56 80 00 00 	movabs $0x805626,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 ed 38 80 00 00 	movabs $0x8038ed,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 38 56 80 00 00 	movabs $0x805638,%rdx
  8001e4:	00 00 00 
  8001e7:	be 22 00 00 00       	mov    $0x22,%esi
  8001ec:	48 bf d1 55 80 00 00 	movabs $0x8055d1,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 ca 4e 80 00 00 	movabs $0x804eca,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 7e 12 80 00 00 	movabs $0x80127e,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 ee 55 80 00 00 	movabs $0x8055ee,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 f4 55 80 00 00 	movabs $0x8055f4,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 42 56 80 00 00 	movabs $0x805642,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	90                   	nop
  800274:	c9                   	leaveq 
  800275:	c3                   	retq   

0000000000800276 <childofspawn>:

void
childofspawn(void)
{
  800276:	55                   	push   %rbp
  800277:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  80027a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800281:	00 00 00 
  800284:	48 8b 00             	mov    (%rax),%rax
  800287:	48 89 c6             	mov    %rax,%rsi
  80028a:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028f:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
	exit();
  80029b:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	callq  *%rax
}
  8002a7:	90                   	nop
  8002a8:	5d                   	pop    %rbp
  8002a9:	c3                   	retq   

00000000008002aa <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 83 ec 10          	sub    $0x10,%rsp
  8002b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8002b9:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  8002c0:	00 00 00 
  8002c3:	ff d0                	callq  *%rax
  8002c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ca:	48 98                	cltq   
  8002cc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8002d3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002da:	00 00 00 
  8002dd:	48 01 c2             	add    %rax,%rdx
  8002e0:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8002e7:	00 00 00 
  8002ea:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f1:	7e 14                	jle    800307 <libmain+0x5d>
		binaryname = argv[0];
  8002f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f7:	48 8b 10             	mov    (%rax),%rdx
  8002fa:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800301:	00 00 00 
  800304:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800307:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030e:	48 89 d6             	mov    %rdx,%rsi
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80031f:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  800326:	00 00 00 
  800329:	ff d0                	callq  *%rax
}
  80032b:	90                   	nop
  80032c:	c9                   	leaveq 
  80032d:	c3                   	retq   

000000000080032e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80032e:	55                   	push   %rbp
  80032f:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800332:	48 b8 a5 28 80 00 00 	movabs $0x8028a5,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80033e:	bf 00 00 00 00       	mov    $0x0,%edi
  800343:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
}
  80034f:	90                   	nop
  800350:	5d                   	pop    %rbp
  800351:	c3                   	retq   

0000000000800352 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800352:	55                   	push   %rbp
  800353:	48 89 e5             	mov    %rsp,%rbp
  800356:	53                   	push   %rbx
  800357:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80035e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800365:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80036b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800372:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800379:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800380:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800387:	84 c0                	test   %al,%al
  800389:	74 23                	je     8003ae <_panic+0x5c>
  80038b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800392:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800396:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80039a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80039e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003a2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003aa:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003ae:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b5:	00 00 00 
  8003b8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003bf:	00 00 00 
  8003c2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003c6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003cd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003db:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8003e2:	00 00 00 
  8003e5:	48 8b 18             	mov    (%rax),%rbx
  8003e8:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
  8003f4:	89 c6                	mov    %eax,%esi
  8003f6:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8003fc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800403:	41 89 d0             	mov    %edx,%r8d
  800406:	48 89 c1             	mov    %rax,%rcx
  800409:	48 89 da             	mov    %rbx,%rdx
  80040c:	48 bf 68 56 80 00 00 	movabs $0x805668,%rdi
  800413:	00 00 00 
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
  80041b:	49 b9 8c 05 80 00 00 	movabs $0x80058c,%r9
  800422:	00 00 00 
  800425:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800428:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80042f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800436:	48 89 d6             	mov    %rdx,%rsi
  800439:	48 89 c7             	mov    %rax,%rdi
  80043c:	48 b8 e0 04 80 00 00 	movabs $0x8004e0,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
	cprintf("\n");
  800448:	48 bf 8b 56 80 00 00 	movabs $0x80568b,%rdi
  80044f:	00 00 00 
  800452:	b8 00 00 00 00       	mov    $0x0,%eax
  800457:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  80045e:	00 00 00 
  800461:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800463:	cc                   	int3   
  800464:	eb fd                	jmp    800463 <_panic+0x111>

0000000000800466 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800466:	55                   	push   %rbp
  800467:	48 89 e5             	mov    %rsp,%rbp
  80046a:	48 83 ec 10          	sub    $0x10,%rsp
  80046e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800471:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800479:	8b 00                	mov    (%rax),%eax
  80047b:	8d 48 01             	lea    0x1(%rax),%ecx
  80047e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800482:	89 0a                	mov    %ecx,(%rdx)
  800484:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800487:	89 d1                	mov    %edx,%ecx
  800489:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80048d:	48 98                	cltq   
  80048f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800497:	8b 00                	mov    (%rax),%eax
  800499:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049e:	75 2c                	jne    8004cc <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a4:	8b 00                	mov    (%rax),%eax
  8004a6:	48 98                	cltq   
  8004a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ac:	48 83 c2 08          	add    $0x8,%rdx
  8004b0:	48 89 c6             	mov    %rax,%rsi
  8004b3:	48 89 d7             	mov    %rdx,%rdi
  8004b6:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
        b->idx = 0;
  8004c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	8b 40 04             	mov    0x4(%rax),%eax
  8004d3:	8d 50 01             	lea    0x1(%rax),%edx
  8004d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004da:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004dd:	90                   	nop
  8004de:	c9                   	leaveq 
  8004df:	c3                   	retq   

00000000008004e0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004e0:	55                   	push   %rbp
  8004e1:	48 89 e5             	mov    %rsp,%rbp
  8004e4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004eb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004f2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004f9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800500:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800507:	48 8b 0a             	mov    (%rdx),%rcx
  80050a:	48 89 08             	mov    %rcx,(%rax)
  80050d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800511:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800515:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800519:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80051d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800524:	00 00 00 
    b.cnt = 0;
  800527:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80052e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800531:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800538:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80053f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800546:	48 89 c6             	mov    %rax,%rsi
  800549:	48 bf 66 04 80 00 00 	movabs $0x800466,%rdi
  800550:	00 00 00 
  800553:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  80055a:	00 00 00 
  80055d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80055f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800565:	48 98                	cltq   
  800567:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80056e:	48 83 c2 08          	add    $0x8,%rdx
  800572:	48 89 c6             	mov    %rax,%rsi
  800575:	48 89 d7             	mov    %rdx,%rdi
  800578:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800584:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80058a:	c9                   	leaveq 
  80058b:	c3                   	retq   

000000000080058c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80058c:	55                   	push   %rbp
  80058d:	48 89 e5             	mov    %rsp,%rbp
  800590:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800597:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80059e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005ac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005b3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005c1:	84 c0                	test   %al,%al
  8005c3:	74 20                	je     8005e5 <cprintf+0x59>
  8005c5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005c9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005cd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005d1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005d9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005dd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005e1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005e5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005ec:	00 00 00 
  8005ef:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f6:	00 00 00 
  8005f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005fd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800604:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80060b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800612:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800619:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800620:	48 8b 0a             	mov    (%rdx),%rcx
  800623:	48 89 08             	mov    %rcx,(%rax)
  800626:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80062e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800632:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800636:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80063d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800644:	48 89 d6             	mov    %rdx,%rsi
  800647:	48 89 c7             	mov    %rax,%rdi
  80064a:	48 b8 e0 04 80 00 00 	movabs $0x8004e0,%rax
  800651:	00 00 00 
  800654:	ff d0                	callq  *%rax
  800656:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80065c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800662:	c9                   	leaveq 
  800663:	c3                   	retq   

0000000000800664 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 83 ec 30          	sub    $0x30,%rsp
  80066c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800670:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800674:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800678:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80067b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80067f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800683:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800686:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80068a:	77 54                	ja     8006e0 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80068f:	8d 78 ff             	lea    -0x1(%rax),%edi
  800692:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
  80069e:	48 f7 f6             	div    %rsi
  8006a1:	49 89 c2             	mov    %rax,%r10
  8006a4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8006a7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006aa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006b2:	41 89 c9             	mov    %ecx,%r9d
  8006b5:	41 89 f8             	mov    %edi,%r8d
  8006b8:	89 d1                	mov    %edx,%ecx
  8006ba:	4c 89 d2             	mov    %r10,%rdx
  8006bd:	48 89 c7             	mov    %rax,%rdi
  8006c0:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  8006c7:	00 00 00 
  8006ca:	ff d0                	callq  *%rax
  8006cc:	eb 1c                	jmp    8006ea <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006ce:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006d2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8006d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006d9:	48 89 ce             	mov    %rcx,%rsi
  8006dc:	89 d7                	mov    %edx,%edi
  8006de:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e0:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8006e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8006e8:	7f e4                	jg     8006ce <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ea:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f6:	48 f7 f1             	div    %rcx
  8006f9:	48 b8 90 58 80 00 00 	movabs $0x805890,%rax
  800700:	00 00 00 
  800703:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800707:	0f be d0             	movsbl %al,%edx
  80070a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80070e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800712:	48 89 ce             	mov    %rcx,%rsi
  800715:	89 d7                	mov    %edx,%edi
  800717:	ff d0                	callq  *%rax
}
  800719:	90                   	nop
  80071a:	c9                   	leaveq 
  80071b:	c3                   	retq   

000000000080071c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071c:	55                   	push   %rbp
  80071d:	48 89 e5             	mov    %rsp,%rbp
  800720:	48 83 ec 20          	sub    $0x20,%rsp
  800724:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800728:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80072b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80072f:	7e 4f                	jle    800780 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800735:	8b 00                	mov    (%rax),%eax
  800737:	83 f8 30             	cmp    $0x30,%eax
  80073a:	73 24                	jae    800760 <getuint+0x44>
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800748:	8b 00                	mov    (%rax),%eax
  80074a:	89 c0                	mov    %eax,%eax
  80074c:	48 01 d0             	add    %rdx,%rax
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	8b 12                	mov    (%rdx),%edx
  800755:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800758:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075c:	89 0a                	mov    %ecx,(%rdx)
  80075e:	eb 14                	jmp    800774 <getuint+0x58>
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	48 8b 40 08          	mov    0x8(%rax),%rax
  800768:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800774:	48 8b 00             	mov    (%rax),%rax
  800777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077b:	e9 9d 00 00 00       	jmpq   80081d <getuint+0x101>
	else if (lflag)
  800780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800784:	74 4c                	je     8007d2 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	8b 00                	mov    (%rax),%eax
  80078c:	83 f8 30             	cmp    $0x30,%eax
  80078f:	73 24                	jae    8007b5 <getuint+0x99>
  800791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800795:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	8b 00                	mov    (%rax),%eax
  80079f:	89 c0                	mov    %eax,%eax
  8007a1:	48 01 d0             	add    %rdx,%rax
  8007a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a8:	8b 12                	mov    (%rdx),%edx
  8007aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	89 0a                	mov    %ecx,(%rdx)
  8007b3:	eb 14                	jmp    8007c9 <getuint+0xad>
  8007b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007bd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c9:	48 8b 00             	mov    (%rax),%rax
  8007cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d0:	eb 4b                	jmp    80081d <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	83 f8 30             	cmp    $0x30,%eax
  8007db:	73 24                	jae    800801 <getuint+0xe5>
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	8b 00                	mov    (%rax),%eax
  8007eb:	89 c0                	mov    %eax,%eax
  8007ed:	48 01 d0             	add    %rdx,%rax
  8007f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f4:	8b 12                	mov    (%rdx),%edx
  8007f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fd:	89 0a                	mov    %ecx,(%rdx)
  8007ff:	eb 14                	jmp    800815 <getuint+0xf9>
  800801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800805:	48 8b 40 08          	mov    0x8(%rax),%rax
  800809:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800815:	8b 00                	mov    (%rax),%eax
  800817:	89 c0                	mov    %eax,%eax
  800819:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80081d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800821:	c9                   	leaveq 
  800822:	c3                   	retq   

0000000000800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %rbp
  800824:	48 89 e5             	mov    %rsp,%rbp
  800827:	48 83 ec 20          	sub    $0x20,%rsp
  80082b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80082f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800832:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800836:	7e 4f                	jle    800887 <getint+0x64>
		x=va_arg(*ap, long long);
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	8b 00                	mov    (%rax),%eax
  80083e:	83 f8 30             	cmp    $0x30,%eax
  800841:	73 24                	jae    800867 <getint+0x44>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	8b 00                	mov    (%rax),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 01 d0             	add    %rdx,%rax
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	8b 12                	mov    (%rdx),%edx
  80085c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	89 0a                	mov    %ecx,(%rdx)
  800865:	eb 14                	jmp    80087b <getint+0x58>
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80086f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087b:	48 8b 00             	mov    (%rax),%rax
  80087e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800882:	e9 9d 00 00 00       	jmpq   800924 <getint+0x101>
	else if (lflag)
  800887:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80088b:	74 4c                	je     8008d9 <getint+0xb6>
		x=va_arg(*ap, long);
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	8b 00                	mov    (%rax),%eax
  800893:	83 f8 30             	cmp    $0x30,%eax
  800896:	73 24                	jae    8008bc <getint+0x99>
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	89 c0                	mov    %eax,%eax
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008af:	8b 12                	mov    (%rdx),%edx
  8008b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b8:	89 0a                	mov    %ecx,(%rdx)
  8008ba:	eb 14                	jmp    8008d0 <getint+0xad>
  8008bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008c4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d0:	48 8b 00             	mov    (%rax),%rax
  8008d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008d7:	eb 4b                	jmp    800924 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8008d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dd:	8b 00                	mov    (%rax),%eax
  8008df:	83 f8 30             	cmp    $0x30,%eax
  8008e2:	73 24                	jae    800908 <getint+0xe5>
  8008e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f0:	8b 00                	mov    (%rax),%eax
  8008f2:	89 c0                	mov    %eax,%eax
  8008f4:	48 01 d0             	add    %rdx,%rax
  8008f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fb:	8b 12                	mov    (%rdx),%edx
  8008fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800900:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800904:	89 0a                	mov    %ecx,(%rdx)
  800906:	eb 14                	jmp    80091c <getint+0xf9>
  800908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800910:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800914:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800918:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091c:	8b 00                	mov    (%rax),%eax
  80091e:	48 98                	cltq   
  800920:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800928:	c9                   	leaveq 
  800929:	c3                   	retq   

000000000080092a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092a:	55                   	push   %rbp
  80092b:	48 89 e5             	mov    %rsp,%rbp
  80092e:	41 54                	push   %r12
  800930:	53                   	push   %rbx
  800931:	48 83 ec 60          	sub    $0x60,%rsp
  800935:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800939:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80093d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800941:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800945:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800949:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80094d:	48 8b 0a             	mov    (%rdx),%rcx
  800950:	48 89 08             	mov    %rcx,(%rax)
  800953:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800957:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80095b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80095f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800963:	eb 17                	jmp    80097c <vprintfmt+0x52>
			if (ch == '\0')
  800965:	85 db                	test   %ebx,%ebx
  800967:	0f 84 b9 04 00 00    	je     800e26 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80096d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800971:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800975:	48 89 d6             	mov    %rdx,%rsi
  800978:	89 df                	mov    %ebx,%edi
  80097a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800980:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800984:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800988:	0f b6 00             	movzbl (%rax),%eax
  80098b:	0f b6 d8             	movzbl %al,%ebx
  80098e:	83 fb 25             	cmp    $0x25,%ebx
  800991:	75 d2                	jne    800965 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800993:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800997:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80099e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009ac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009bb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	0f b6 d8             	movzbl %al,%ebx
  8009c5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009c8:	83 f8 55             	cmp    $0x55,%eax
  8009cb:	0f 87 22 04 00 00    	ja     800df3 <vprintfmt+0x4c9>
  8009d1:	89 c0                	mov    %eax,%eax
  8009d3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009da:	00 
  8009db:	48 b8 b8 58 80 00 00 	movabs $0x8058b8,%rax
  8009e2:	00 00 00 
  8009e5:	48 01 d0             	add    %rdx,%rax
  8009e8:	48 8b 00             	mov    (%rax),%rax
  8009eb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009ed:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009f1:	eb c0                	jmp    8009b3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009f7:	eb ba                	jmp    8009b3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a00:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a03:	89 d0                	mov    %edx,%eax
  800a05:	c1 e0 02             	shl    $0x2,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d8                	add    %ebx,%eax
  800a0e:	83 e8 30             	sub    $0x30,%eax
  800a11:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a14:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a18:	0f b6 00             	movzbl (%rax),%eax
  800a1b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a21:	7e 60                	jle    800a83 <vprintfmt+0x159>
  800a23:	83 fb 39             	cmp    $0x39,%ebx
  800a26:	7f 5b                	jg     800a83 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a28:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a2d:	eb d1                	jmp    800a00 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a32:	83 f8 30             	cmp    $0x30,%eax
  800a35:	73 17                	jae    800a4e <vprintfmt+0x124>
  800a37:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a3b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3e:	89 d2                	mov    %edx,%edx
  800a40:	48 01 d0             	add    %rdx,%rax
  800a43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a46:	83 c2 08             	add    $0x8,%edx
  800a49:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a4c:	eb 0c                	jmp    800a5a <vprintfmt+0x130>
  800a4e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a52:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a56:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5a:	8b 00                	mov    (%rax),%eax
  800a5c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a5f:	eb 23                	jmp    800a84 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800a61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a65:	0f 89 48 ff ff ff    	jns    8009b3 <vprintfmt+0x89>
				width = 0;
  800a6b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a72:	e9 3c ff ff ff       	jmpq   8009b3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a77:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a7e:	e9 30 ff ff ff       	jmpq   8009b3 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a88:	0f 89 25 ff ff ff    	jns    8009b3 <vprintfmt+0x89>
				width = precision, precision = -1;
  800a8e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a91:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a94:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a9b:	e9 13 ff ff ff       	jmpq   8009b3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aa0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800aa4:	e9 0a ff ff ff       	jmpq   8009b3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aac:	83 f8 30             	cmp    $0x30,%eax
  800aaf:	73 17                	jae    800ac8 <vprintfmt+0x19e>
  800ab1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ab5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab8:	89 d2                	mov    %edx,%edx
  800aba:	48 01 d0             	add    %rdx,%rax
  800abd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac0:	83 c2 08             	add    $0x8,%edx
  800ac3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac6:	eb 0c                	jmp    800ad4 <vprintfmt+0x1aa>
  800ac8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800acc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ad0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad4:	8b 10                	mov    (%rax),%edx
  800ad6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ada:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ade:	48 89 ce             	mov    %rcx,%rsi
  800ae1:	89 d7                	mov    %edx,%edi
  800ae3:	ff d0                	callq  *%rax
			break;
  800ae5:	e9 37 03 00 00       	jmpq   800e21 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aed:	83 f8 30             	cmp    $0x30,%eax
  800af0:	73 17                	jae    800b09 <vprintfmt+0x1df>
  800af2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800af6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af9:	89 d2                	mov    %edx,%edx
  800afb:	48 01 d0             	add    %rdx,%rax
  800afe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b01:	83 c2 08             	add    $0x8,%edx
  800b04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b07:	eb 0c                	jmp    800b15 <vprintfmt+0x1eb>
  800b09:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b0d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b15:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	79 02                	jns    800b1d <vprintfmt+0x1f3>
				err = -err;
  800b1b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b1d:	83 fb 15             	cmp    $0x15,%ebx
  800b20:	7f 16                	jg     800b38 <vprintfmt+0x20e>
  800b22:	48 b8 e0 57 80 00 00 	movabs $0x8057e0,%rax
  800b29:	00 00 00 
  800b2c:	48 63 d3             	movslq %ebx,%rdx
  800b2f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b33:	4d 85 e4             	test   %r12,%r12
  800b36:	75 2e                	jne    800b66 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800b38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	89 d9                	mov    %ebx,%ecx
  800b42:	48 ba a1 58 80 00 00 	movabs $0x8058a1,%rdx
  800b49:	00 00 00 
  800b4c:	48 89 c7             	mov    %rax,%rdi
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	49 b8 30 0e 80 00 00 	movabs $0x800e30,%r8
  800b5b:	00 00 00 
  800b5e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b61:	e9 bb 02 00 00       	jmpq   800e21 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b66:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6e:	4c 89 e1             	mov    %r12,%rcx
  800b71:	48 ba aa 58 80 00 00 	movabs $0x8058aa,%rdx
  800b78:	00 00 00 
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b83:	49 b8 30 0e 80 00 00 	movabs $0x800e30,%r8
  800b8a:	00 00 00 
  800b8d:	41 ff d0             	callq  *%r8
			break;
  800b90:	e9 8c 02 00 00       	jmpq   800e21 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b98:	83 f8 30             	cmp    $0x30,%eax
  800b9b:	73 17                	jae    800bb4 <vprintfmt+0x28a>
  800b9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ba1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba4:	89 d2                	mov    %edx,%edx
  800ba6:	48 01 d0             	add    %rdx,%rax
  800ba9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bac:	83 c2 08             	add    $0x8,%edx
  800baf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb2:	eb 0c                	jmp    800bc0 <vprintfmt+0x296>
  800bb4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bb8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bbc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc0:	4c 8b 20             	mov    (%rax),%r12
  800bc3:	4d 85 e4             	test   %r12,%r12
  800bc6:	75 0a                	jne    800bd2 <vprintfmt+0x2a8>
				p = "(null)";
  800bc8:	49 bc ad 58 80 00 00 	movabs $0x8058ad,%r12
  800bcf:	00 00 00 
			if (width > 0 && padc != '-')
  800bd2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd6:	7e 78                	jle    800c50 <vprintfmt+0x326>
  800bd8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bdc:	74 72                	je     800c50 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bde:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800be1:	48 98                	cltq   
  800be3:	48 89 c6             	mov    %rax,%rsi
  800be6:	4c 89 e7             	mov    %r12,%rdi
  800be9:	48 b8 de 10 80 00 00 	movabs $0x8010de,%rax
  800bf0:	00 00 00 
  800bf3:	ff d0                	callq  *%rax
  800bf5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bf8:	eb 17                	jmp    800c11 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800bfa:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bfe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c06:	48 89 ce             	mov    %rcx,%rsi
  800c09:	89 d7                	mov    %edx,%edi
  800c0b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c15:	7f e3                	jg     800bfa <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c17:	eb 37                	jmp    800c50 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800c19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c1d:	74 1e                	je     800c3d <vprintfmt+0x313>
  800c1f:	83 fb 1f             	cmp    $0x1f,%ebx
  800c22:	7e 05                	jle    800c29 <vprintfmt+0x2ff>
  800c24:	83 fb 7e             	cmp    $0x7e,%ebx
  800c27:	7e 14                	jle    800c3d <vprintfmt+0x313>
					putch('?', putdat);
  800c29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c31:	48 89 d6             	mov    %rdx,%rsi
  800c34:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c39:	ff d0                	callq  *%rax
  800c3b:	eb 0f                	jmp    800c4c <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800c3d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c45:	48 89 d6             	mov    %rdx,%rsi
  800c48:	89 df                	mov    %ebx,%edi
  800c4a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c4c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c50:	4c 89 e0             	mov    %r12,%rax
  800c53:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c57:	0f b6 00             	movzbl (%rax),%eax
  800c5a:	0f be d8             	movsbl %al,%ebx
  800c5d:	85 db                	test   %ebx,%ebx
  800c5f:	74 28                	je     800c89 <vprintfmt+0x35f>
  800c61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c65:	78 b2                	js     800c19 <vprintfmt+0x2ef>
  800c67:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c6b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c6f:	79 a8                	jns    800c19 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c71:	eb 16                	jmp    800c89 <vprintfmt+0x35f>
				putch(' ', putdat);
  800c73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7b:	48 89 d6             	mov    %rdx,%rsi
  800c7e:	bf 20 00 00 00       	mov    $0x20,%edi
  800c83:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c89:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c8d:	7f e4                	jg     800c73 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800c8f:	e9 8d 01 00 00       	jmpq   800e21 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c98:	be 03 00 00 00       	mov    $0x3,%esi
  800c9d:	48 89 c7             	mov    %rax,%rdi
  800ca0:	48 b8 23 08 80 00 00 	movabs $0x800823,%rax
  800ca7:	00 00 00 
  800caa:	ff d0                	callq  *%rax
  800cac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb4:	48 85 c0             	test   %rax,%rax
  800cb7:	79 1d                	jns    800cd6 <vprintfmt+0x3ac>
				putch('-', putdat);
  800cb9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc1:	48 89 d6             	mov    %rdx,%rsi
  800cc4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cc9:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccf:	48 f7 d8             	neg    %rax
  800cd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cd6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cdd:	e9 d2 00 00 00       	jmpq   800db4 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ce2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce6:	be 03 00 00 00       	mov    $0x3,%esi
  800ceb:	48 89 c7             	mov    %rax,%rdi
  800cee:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800cf5:	00 00 00 
  800cf8:	ff d0                	callq  *%rax
  800cfa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cfe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d05:	e9 aa 00 00 00       	jmpq   800db4 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800d0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d0e:	be 03 00 00 00       	mov    $0x3,%esi
  800d13:	48 89 c7             	mov    %rax,%rdi
  800d16:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800d1d:	00 00 00 
  800d20:	ff d0                	callq  *%rax
  800d22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d26:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d2d:	e9 82 00 00 00       	jmpq   800db4 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800d32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	bf 30 00 00 00       	mov    $0x30,%edi
  800d42:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4c:	48 89 d6             	mov    %rdx,%rsi
  800d4f:	bf 78 00 00 00       	mov    $0x78,%edi
  800d54:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d59:	83 f8 30             	cmp    $0x30,%eax
  800d5c:	73 17                	jae    800d75 <vprintfmt+0x44b>
  800d5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d62:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d65:	89 d2                	mov    %edx,%edx
  800d67:	48 01 d0             	add    %rdx,%rax
  800d6a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6d:	83 c2 08             	add    $0x8,%edx
  800d70:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d73:	eb 0c                	jmp    800d81 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800d75:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d79:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d7d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d81:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d88:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d8f:	eb 23                	jmp    800db4 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d91:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d95:	be 03 00 00 00       	mov    $0x3,%esi
  800d9a:	48 89 c7             	mov    %rax,%rdi
  800d9d:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
  800da9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dad:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800db4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800db9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800dbc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dbf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcb:	45 89 c1             	mov    %r8d,%r9d
  800dce:	41 89 f8             	mov    %edi,%r8d
  800dd1:	48 89 c7             	mov    %rax,%rdi
  800dd4:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  800ddb:	00 00 00 
  800dde:	ff d0                	callq  *%rax
			break;
  800de0:	eb 3f                	jmp    800e21 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800de2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dea:	48 89 d6             	mov    %rdx,%rsi
  800ded:	89 df                	mov    %ebx,%edi
  800def:	ff d0                	callq  *%rax
			break;
  800df1:	eb 2e                	jmp    800e21 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800df3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfb:	48 89 d6             	mov    %rdx,%rsi
  800dfe:	bf 25 00 00 00       	mov    $0x25,%edi
  800e03:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e05:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e0a:	eb 05                	jmp    800e11 <vprintfmt+0x4e7>
  800e0c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e11:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e15:	48 83 e8 01          	sub    $0x1,%rax
  800e19:	0f b6 00             	movzbl (%rax),%eax
  800e1c:	3c 25                	cmp    $0x25,%al
  800e1e:	75 ec                	jne    800e0c <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800e20:	90                   	nop
		}
	}
  800e21:	e9 3d fb ff ff       	jmpq   800963 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e26:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e27:	48 83 c4 60          	add    $0x60,%rsp
  800e2b:	5b                   	pop    %rbx
  800e2c:	41 5c                	pop    %r12
  800e2e:	5d                   	pop    %rbp
  800e2f:	c3                   	retq   

0000000000800e30 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e30:	55                   	push   %rbp
  800e31:	48 89 e5             	mov    %rsp,%rbp
  800e34:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e3b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e42:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e49:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800e50:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e57:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e65:	84 c0                	test   %al,%al
  800e67:	74 20                	je     800e89 <printfmt+0x59>
  800e69:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e71:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e75:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e79:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e81:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e85:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e89:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e90:	00 00 00 
  800e93:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e9a:	00 00 00 
  800e9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ea8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eaf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800eb6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ebd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ec4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ecb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ed2:	48 89 c7             	mov    %rax,%rdi
  800ed5:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  800edc:	00 00 00 
  800edf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ee1:	90                   	nop
  800ee2:	c9                   	leaveq 
  800ee3:	c3                   	retq   

0000000000800ee4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ee4:	55                   	push   %rbp
  800ee5:	48 89 e5             	mov    %rsp,%rbp
  800ee8:	48 83 ec 10          	sub    $0x10,%rsp
  800eec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef7:	8b 40 10             	mov    0x10(%rax),%eax
  800efa:	8d 50 01             	lea    0x1(%rax),%edx
  800efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f01:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f08:	48 8b 10             	mov    (%rax),%rdx
  800f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f0f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f13:	48 39 c2             	cmp    %rax,%rdx
  800f16:	73 17                	jae    800f2f <sprintputch+0x4b>
		*b->buf++ = ch;
  800f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1c:	48 8b 00             	mov    (%rax),%rax
  800f1f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f27:	48 89 0a             	mov    %rcx,(%rdx)
  800f2a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f2d:	88 10                	mov    %dl,(%rax)
}
  800f2f:	90                   	nop
  800f30:	c9                   	leaveq 
  800f31:	c3                   	retq   

0000000000800f32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f32:	55                   	push   %rbp
  800f33:	48 89 e5             	mov    %rsp,%rbp
  800f36:	48 83 ec 50          	sub    $0x50,%rsp
  800f3a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f3e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f41:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f45:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f49:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f4d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f51:	48 8b 0a             	mov    (%rdx),%rcx
  800f54:	48 89 08             	mov    %rcx,(%rax)
  800f57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f6b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f6f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f72:	48 98                	cltq   
  800f74:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f7c:	48 01 d0             	add    %rdx,%rax
  800f7f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f8a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f8f:	74 06                	je     800f97 <vsnprintf+0x65>
  800f91:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f95:	7f 07                	jg     800f9e <vsnprintf+0x6c>
		return -E_INVAL;
  800f97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f9c:	eb 2f                	jmp    800fcd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f9e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fa2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fa6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800faa:	48 89 c6             	mov    %rax,%rsi
  800fad:	48 bf e4 0e 80 00 00 	movabs $0x800ee4,%rdi
  800fb4:	00 00 00 
  800fb7:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  800fbe:	00 00 00 
  800fc1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fc7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fca:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fda:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fe1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fe7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800fee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ff5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ffc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801003:	84 c0                	test   %al,%al
  801005:	74 20                	je     801027 <snprintf+0x58>
  801007:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80100b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80100f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801013:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801017:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80101b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80101f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801023:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801027:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80102e:	00 00 00 
  801031:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801038:	00 00 00 
  80103b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80103f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801046:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80104d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801054:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80105b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801062:	48 8b 0a             	mov    (%rdx),%rcx
  801065:	48 89 08             	mov    %rcx,(%rax)
  801068:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80106c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801070:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801074:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801078:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80107f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801086:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80108c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801093:	48 89 c7             	mov    %rax,%rdi
  801096:	48 b8 32 0f 80 00 00 	movabs $0x800f32,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	callq  *%rax
  8010a2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010a8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010ae:	c9                   	leaveq 
  8010af:	c3                   	retq   

00000000008010b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010b0:	55                   	push   %rbp
  8010b1:	48 89 e5             	mov    %rsp,%rbp
  8010b4:	48 83 ec 18          	sub    $0x18,%rsp
  8010b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010c3:	eb 09                	jmp    8010ce <strlen+0x1e>
		n++;
  8010c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010c9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 ec                	jne    8010c5 <strlen+0x15>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010dc:	c9                   	leaveq 
  8010dd:	c3                   	retq   

00000000008010de <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010de:	55                   	push   %rbp
  8010df:	48 89 e5             	mov    %rsp,%rbp
  8010e2:	48 83 ec 20          	sub    $0x20,%rsp
  8010e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010f5:	eb 0e                	jmp    801105 <strnlen+0x27>
		n++;
  8010f7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801100:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801105:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80110a:	74 0b                	je     801117 <strnlen+0x39>
  80110c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801110:	0f b6 00             	movzbl (%rax),%eax
  801113:	84 c0                	test   %al,%al
  801115:	75 e0                	jne    8010f7 <strnlen+0x19>
		n++;
	return n;
  801117:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80111a:	c9                   	leaveq 
  80111b:	c3                   	retq   

000000000080111c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80111c:	55                   	push   %rbp
  80111d:	48 89 e5             	mov    %rsp,%rbp
  801120:	48 83 ec 20          	sub    $0x20,%rsp
  801124:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801128:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801134:	90                   	nop
  801135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801139:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801141:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801145:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801149:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80114d:	0f b6 12             	movzbl (%rdx),%edx
  801150:	88 10                	mov    %dl,(%rax)
  801152:	0f b6 00             	movzbl (%rax),%eax
  801155:	84 c0                	test   %al,%al
  801157:	75 dc                	jne    801135 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80115d:	c9                   	leaveq 
  80115e:	c3                   	retq   

000000000080115f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80115f:	55                   	push   %rbp
  801160:	48 89 e5             	mov    %rsp,%rbp
  801163:	48 83 ec 20          	sub    $0x20,%rsp
  801167:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801173:	48 89 c7             	mov    %rax,%rdi
  801176:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  80117d:	00 00 00 
  801180:	ff d0                	callq  *%rax
  801182:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801188:	48 63 d0             	movslq %eax,%rdx
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 01 c2             	add    %rax,%rdx
  801192:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801196:	48 89 c6             	mov    %rax,%rsi
  801199:	48 89 d7             	mov    %rdx,%rdi
  80119c:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  8011a3:	00 00 00 
  8011a6:	ff d0                	callq  *%rax
	return dst;
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011ac:	c9                   	leaveq 
  8011ad:	c3                   	retq   

00000000008011ae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011ae:	55                   	push   %rbp
  8011af:	48 89 e5             	mov    %rsp,%rbp
  8011b2:	48 83 ec 28          	sub    $0x28,%rsp
  8011b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011d1:	00 
  8011d2:	eb 2a                	jmp    8011fe <strncpy+0x50>
		*dst++ = *src;
  8011d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011e4:	0f b6 12             	movzbl (%rdx),%edx
  8011e7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ed:	0f b6 00             	movzbl (%rax),%eax
  8011f0:	84 c0                	test   %al,%al
  8011f2:	74 05                	je     8011f9 <strncpy+0x4b>
			src++;
  8011f4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801202:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801206:	72 cc                	jb     8011d4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80120c:	c9                   	leaveq 
  80120d:	c3                   	retq   

000000000080120e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80120e:	55                   	push   %rbp
  80120f:	48 89 e5             	mov    %rsp,%rbp
  801212:	48 83 ec 28          	sub    $0x28,%rsp
  801216:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801226:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80122a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80122f:	74 3d                	je     80126e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801231:	eb 1d                	jmp    801250 <strlcpy+0x42>
			*dst++ = *src++;
  801233:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801237:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80123b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801243:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801247:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80124b:	0f b6 12             	movzbl (%rdx),%edx
  80124e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801250:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801255:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80125a:	74 0b                	je     801267 <strlcpy+0x59>
  80125c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801260:	0f b6 00             	movzbl (%rax),%eax
  801263:	84 c0                	test   %al,%al
  801265:	75 cc                	jne    801233 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80126e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801276:	48 29 c2             	sub    %rax,%rdx
  801279:	48 89 d0             	mov    %rdx,%rax
}
  80127c:	c9                   	leaveq 
  80127d:	c3                   	retq   

000000000080127e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80127e:	55                   	push   %rbp
  80127f:	48 89 e5             	mov    %rsp,%rbp
  801282:	48 83 ec 10          	sub    $0x10,%rsp
  801286:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80128e:	eb 0a                	jmp    80129a <strcmp+0x1c>
		p++, q++;
  801290:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801295:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	0f b6 00             	movzbl (%rax),%eax
  8012a1:	84 c0                	test   %al,%al
  8012a3:	74 12                	je     8012b7 <strcmp+0x39>
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	0f b6 10             	movzbl (%rax),%edx
  8012ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b0:	0f b6 00             	movzbl (%rax),%eax
  8012b3:	38 c2                	cmp    %al,%dl
  8012b5:	74 d9                	je     801290 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	0f b6 d0             	movzbl %al,%edx
  8012c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c5:	0f b6 00             	movzbl (%rax),%eax
  8012c8:	0f b6 c0             	movzbl %al,%eax
  8012cb:	29 c2                	sub    %eax,%edx
  8012cd:	89 d0                	mov    %edx,%eax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	48 83 ec 18          	sub    $0x18,%rsp
  8012d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012e5:	eb 0f                	jmp    8012f6 <strncmp+0x25>
		n--, p++, q++;
  8012e7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fb:	74 1d                	je     80131a <strncmp+0x49>
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	0f b6 00             	movzbl (%rax),%eax
  801304:	84 c0                	test   %al,%al
  801306:	74 12                	je     80131a <strncmp+0x49>
  801308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130c:	0f b6 10             	movzbl (%rax),%edx
  80130f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	38 c2                	cmp    %al,%dl
  801318:	74 cd                	je     8012e7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80131a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131f:	75 07                	jne    801328 <strncmp+0x57>
		return 0;
  801321:	b8 00 00 00 00       	mov    $0x0,%eax
  801326:	eb 18                	jmp    801340 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	0f b6 00             	movzbl (%rax),%eax
  80132f:	0f b6 d0             	movzbl %al,%edx
  801332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801336:	0f b6 00             	movzbl (%rax),%eax
  801339:	0f b6 c0             	movzbl %al,%eax
  80133c:	29 c2                	sub    %eax,%edx
  80133e:	89 d0                	mov    %edx,%eax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 10          	sub    $0x10,%rsp
  80134a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134e:	89 f0                	mov    %esi,%eax
  801350:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801353:	eb 17                	jmp    80136c <strchr+0x2a>
		if (*s == c)
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80135f:	75 06                	jne    801367 <strchr+0x25>
			return (char *) s;
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	eb 15                	jmp    80137c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801367:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	84 c0                	test   %al,%al
  801375:	75 de                	jne    801355 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 10          	sub    $0x10,%rsp
  801386:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138a:	89 f0                	mov    %esi,%eax
  80138c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80138f:	eb 11                	jmp    8013a2 <strfind+0x24>
		if (*s == c)
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801395:	0f b6 00             	movzbl (%rax),%eax
  801398:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80139b:	74 12                	je     8013af <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80139d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	84 c0                	test   %al,%al
  8013ab:	75 e4                	jne    801391 <strfind+0x13>
  8013ad:	eb 01                	jmp    8013b0 <strfind+0x32>
		if (*s == c)
			break;
  8013af:	90                   	nop
	return (char *) s;
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b4:	c9                   	leaveq 
  8013b5:	c3                   	retq   

00000000008013b6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013b6:	55                   	push   %rbp
  8013b7:	48 89 e5             	mov    %rsp,%rbp
  8013ba:	48 83 ec 18          	sub    $0x18,%rsp
  8013be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ce:	75 06                	jne    8013d6 <memset+0x20>
		return v;
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d4:	eb 69                	jmp    80143f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	83 e0 03             	and    $0x3,%eax
  8013dd:	48 85 c0             	test   %rax,%rax
  8013e0:	75 48                	jne    80142a <memset+0x74>
  8013e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e6:	83 e0 03             	and    $0x3,%eax
  8013e9:	48 85 c0             	test   %rax,%rax
  8013ec:	75 3c                	jne    80142a <memset+0x74>
		c &= 0xFF;
  8013ee:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f8:	c1 e0 18             	shl    $0x18,%eax
  8013fb:	89 c2                	mov    %eax,%edx
  8013fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801400:	c1 e0 10             	shl    $0x10,%eax
  801403:	09 c2                	or     %eax,%edx
  801405:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801408:	c1 e0 08             	shl    $0x8,%eax
  80140b:	09 d0                	or     %edx,%eax
  80140d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801414:	48 c1 e8 02          	shr    $0x2,%rax
  801418:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80141b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801422:	48 89 d7             	mov    %rdx,%rdi
  801425:	fc                   	cld    
  801426:	f3 ab                	rep stos %eax,%es:(%rdi)
  801428:	eb 11                	jmp    80143b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80142a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801431:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801435:	48 89 d7             	mov    %rdx,%rdi
  801438:	fc                   	cld    
  801439:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80143f:	c9                   	leaveq 
  801440:	c3                   	retq   

0000000000801441 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801441:	55                   	push   %rbp
  801442:	48 89 e5             	mov    %rsp,%rbp
  801445:	48 83 ec 28          	sub    $0x28,%rsp
  801449:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801451:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801455:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801459:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80145d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801461:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801469:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80146d:	0f 83 88 00 00 00    	jae    8014fb <memmove+0xba>
  801473:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147b:	48 01 d0             	add    %rdx,%rax
  80147e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801482:	76 77                	jbe    8014fb <memmove+0xba>
		s += n;
  801484:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801488:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80148c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801490:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801498:	83 e0 03             	and    $0x3,%eax
  80149b:	48 85 c0             	test   %rax,%rax
  80149e:	75 3b                	jne    8014db <memmove+0x9a>
  8014a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a4:	83 e0 03             	and    $0x3,%eax
  8014a7:	48 85 c0             	test   %rax,%rax
  8014aa:	75 2f                	jne    8014db <memmove+0x9a>
  8014ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b0:	83 e0 03             	and    $0x3,%eax
  8014b3:	48 85 c0             	test   %rax,%rax
  8014b6:	75 23                	jne    8014db <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bc:	48 83 e8 04          	sub    $0x4,%rax
  8014c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c4:	48 83 ea 04          	sub    $0x4,%rdx
  8014c8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014cc:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014d0:	48 89 c7             	mov    %rax,%rdi
  8014d3:	48 89 d6             	mov    %rdx,%rsi
  8014d6:	fd                   	std    
  8014d7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014d9:	eb 1d                	jmp    8014f8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014df:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	48 89 d7             	mov    %rdx,%rdi
  8014f2:	48 89 c1             	mov    %rax,%rcx
  8014f5:	fd                   	std    
  8014f6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014f8:	fc                   	cld    
  8014f9:	eb 57                	jmp    801552 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	83 e0 03             	and    $0x3,%eax
  801502:	48 85 c0             	test   %rax,%rax
  801505:	75 36                	jne    80153d <memmove+0xfc>
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	83 e0 03             	and    $0x3,%eax
  80150e:	48 85 c0             	test   %rax,%rax
  801511:	75 2a                	jne    80153d <memmove+0xfc>
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	83 e0 03             	and    $0x3,%eax
  80151a:	48 85 c0             	test   %rax,%rax
  80151d:	75 1e                	jne    80153d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	48 c1 e8 02          	shr    $0x2,%rax
  801527:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80152a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801532:	48 89 c7             	mov    %rax,%rdi
  801535:	48 89 d6             	mov    %rdx,%rsi
  801538:	fc                   	cld    
  801539:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80153b:	eb 15                	jmp    801552 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80153d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801541:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801545:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801549:	48 89 c7             	mov    %rax,%rdi
  80154c:	48 89 d6             	mov    %rdx,%rsi
  80154f:	fc                   	cld    
  801550:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801556:	c9                   	leaveq 
  801557:	c3                   	retq   

0000000000801558 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801558:	55                   	push   %rbp
  801559:	48 89 e5             	mov    %rsp,%rbp
  80155c:	48 83 ec 18          	sub    $0x18,%rsp
  801560:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801564:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801568:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80156c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801570:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801578:	48 89 ce             	mov    %rcx,%rsi
  80157b:	48 89 c7             	mov    %rax,%rdi
  80157e:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  801585:	00 00 00 
  801588:	ff d0                	callq  *%rax
}
  80158a:	c9                   	leaveq 
  80158b:	c3                   	retq   

000000000080158c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80158c:	55                   	push   %rbp
  80158d:	48 89 e5             	mov    %rsp,%rbp
  801590:	48 83 ec 28          	sub    $0x28,%rsp
  801594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801598:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80159c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015b0:	eb 36                	jmp    8015e8 <memcmp+0x5c>
		if (*s1 != *s2)
  8015b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b6:	0f b6 10             	movzbl (%rax),%edx
  8015b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	38 c2                	cmp    %al,%dl
  8015c2:	74 1a                	je     8015de <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	0f b6 d0             	movzbl %al,%edx
  8015ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	0f b6 c0             	movzbl %al,%eax
  8015d8:	29 c2                	sub    %eax,%edx
  8015da:	89 d0                	mov    %edx,%eax
  8015dc:	eb 20                	jmp    8015fe <memcmp+0x72>
		s1++, s2++;
  8015de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ec:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015f4:	48 85 c0             	test   %rax,%rax
  8015f7:	75 b9                	jne    8015b2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fe:	c9                   	leaveq 
  8015ff:	c3                   	retq   

0000000000801600 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801600:	55                   	push   %rbp
  801601:	48 89 e5             	mov    %rsp,%rbp
  801604:	48 83 ec 28          	sub    $0x28,%rsp
  801608:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80160f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	48 01 d0             	add    %rdx,%rax
  80161e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801622:	eb 19                	jmp    80163d <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	0f b6 d0             	movzbl %al,%edx
  80162e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801631:	0f b6 c0             	movzbl %al,%eax
  801634:	39 c2                	cmp    %eax,%edx
  801636:	74 11                	je     801649 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801638:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80163d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801641:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801645:	72 dd                	jb     801624 <memfind+0x24>
  801647:	eb 01                	jmp    80164a <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801649:	90                   	nop
	return (void *) s;
  80164a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164e:	c9                   	leaveq 
  80164f:	c3                   	retq   

0000000000801650 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	48 83 ec 38          	sub    $0x38,%rsp
  801658:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80165c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801660:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801663:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80166a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801671:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801672:	eb 05                	jmp    801679 <strtol+0x29>
		s++;
  801674:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	3c 20                	cmp    $0x20,%al
  801682:	74 f0                	je     801674 <strtol+0x24>
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	3c 09                	cmp    $0x9,%al
  80168d:	74 e5                	je     801674 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80168f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801693:	0f b6 00             	movzbl (%rax),%eax
  801696:	3c 2b                	cmp    $0x2b,%al
  801698:	75 07                	jne    8016a1 <strtol+0x51>
		s++;
  80169a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169f:	eb 17                	jmp    8016b8 <strtol+0x68>
	else if (*s == '-')
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 2d                	cmp    $0x2d,%al
  8016aa:	75 0c                	jne    8016b8 <strtol+0x68>
		s++, neg = 1;
  8016ac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016bc:	74 06                	je     8016c4 <strtol+0x74>
  8016be:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016c2:	75 28                	jne    8016ec <strtol+0x9c>
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	0f b6 00             	movzbl (%rax),%eax
  8016cb:	3c 30                	cmp    $0x30,%al
  8016cd:	75 1d                	jne    8016ec <strtol+0x9c>
  8016cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d3:	48 83 c0 01          	add    $0x1,%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	3c 78                	cmp    $0x78,%al
  8016dc:	75 0e                	jne    8016ec <strtol+0x9c>
		s += 2, base = 16;
  8016de:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016e3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016ea:	eb 2c                	jmp    801718 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016f0:	75 19                	jne    80170b <strtol+0xbb>
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	3c 30                	cmp    $0x30,%al
  8016fb:	75 0e                	jne    80170b <strtol+0xbb>
		s++, base = 8;
  8016fd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801702:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801709:	eb 0d                	jmp    801718 <strtol+0xc8>
	else if (base == 0)
  80170b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80170f:	75 07                	jne    801718 <strtol+0xc8>
		base = 10;
  801711:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	3c 2f                	cmp    $0x2f,%al
  801721:	7e 1d                	jle    801740 <strtol+0xf0>
  801723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801727:	0f b6 00             	movzbl (%rax),%eax
  80172a:	3c 39                	cmp    $0x39,%al
  80172c:	7f 12                	jg     801740 <strtol+0xf0>
			dig = *s - '0';
  80172e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801732:	0f b6 00             	movzbl (%rax),%eax
  801735:	0f be c0             	movsbl %al,%eax
  801738:	83 e8 30             	sub    $0x30,%eax
  80173b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80173e:	eb 4e                	jmp    80178e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	3c 60                	cmp    $0x60,%al
  801749:	7e 1d                	jle    801768 <strtol+0x118>
  80174b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174f:	0f b6 00             	movzbl (%rax),%eax
  801752:	3c 7a                	cmp    $0x7a,%al
  801754:	7f 12                	jg     801768 <strtol+0x118>
			dig = *s - 'a' + 10;
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	0f be c0             	movsbl %al,%eax
  801760:	83 e8 57             	sub    $0x57,%eax
  801763:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801766:	eb 26                	jmp    80178e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	3c 40                	cmp    $0x40,%al
  801771:	7e 47                	jle    8017ba <strtol+0x16a>
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	0f b6 00             	movzbl (%rax),%eax
  80177a:	3c 5a                	cmp    $0x5a,%al
  80177c:	7f 3c                	jg     8017ba <strtol+0x16a>
			dig = *s - 'A' + 10;
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	0f be c0             	movsbl %al,%eax
  801788:	83 e8 37             	sub    $0x37,%eax
  80178b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80178e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801791:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801794:	7d 23                	jge    8017b9 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801796:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80179b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80179e:	48 98                	cltq   
  8017a0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017a5:	48 89 c2             	mov    %rax,%rdx
  8017a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ab:	48 98                	cltq   
  8017ad:	48 01 d0             	add    %rdx,%rax
  8017b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017b4:	e9 5f ff ff ff       	jmpq   801718 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017b9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017ba:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017bf:	74 0b                	je     8017cc <strtol+0x17c>
		*endptr = (char *) s;
  8017c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017c9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017d0:	74 09                	je     8017db <strtol+0x18b>
  8017d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d6:	48 f7 d8             	neg    %rax
  8017d9:	eb 04                	jmp    8017df <strtol+0x18f>
  8017db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017df:	c9                   	leaveq 
  8017e0:	c3                   	retq   

00000000008017e1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017e1:	55                   	push   %rbp
  8017e2:	48 89 e5             	mov    %rsp,%rbp
  8017e5:	48 83 ec 30          	sub    $0x30,%rsp
  8017e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017fd:	0f b6 00             	movzbl (%rax),%eax
  801800:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801803:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801807:	75 06                	jne    80180f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	eb 6b                	jmp    80187a <strstr+0x99>

	len = strlen(str);
  80180f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801813:	48 89 c7             	mov    %rax,%rdi
  801816:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  80181d:	00 00 00 
  801820:	ff d0                	callq  *%rax
  801822:	48 98                	cltq   
  801824:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801830:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801834:	0f b6 00             	movzbl (%rax),%eax
  801837:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80183a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80183e:	75 07                	jne    801847 <strstr+0x66>
				return (char *) 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb 33                	jmp    80187a <strstr+0x99>
		} while (sc != c);
  801847:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80184b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80184e:	75 d8                	jne    801828 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801850:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801854:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	48 89 ce             	mov    %rcx,%rsi
  80185f:	48 89 c7             	mov    %rax,%rdi
  801862:	48 b8 d1 12 80 00 00 	movabs $0x8012d1,%rax
  801869:	00 00 00 
  80186c:	ff d0                	callq  *%rax
  80186e:	85 c0                	test   %eax,%eax
  801870:	75 b6                	jne    801828 <strstr+0x47>

	return (char *) (in - 1);
  801872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801876:	48 83 e8 01          	sub    $0x1,%rax
}
  80187a:	c9                   	leaveq 
  80187b:	c3                   	retq   

000000000080187c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80187c:	55                   	push   %rbp
  80187d:	48 89 e5             	mov    %rsp,%rbp
  801880:	53                   	push   %rbx
  801881:	48 83 ec 48          	sub    $0x48,%rsp
  801885:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801888:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80188b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80188f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801893:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801897:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80189e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018a2:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018a6:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018aa:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018ae:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018b2:	4c 89 c3             	mov    %r8,%rbx
  8018b5:	cd 30                	int    $0x30
  8018b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018bf:	74 3e                	je     8018ff <syscall+0x83>
  8018c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018c6:	7e 37                	jle    8018ff <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018cf:	49 89 d0             	mov    %rdx,%r8
  8018d2:	89 c1                	mov    %eax,%ecx
  8018d4:	48 ba 68 5b 80 00 00 	movabs $0x805b68,%rdx
  8018db:	00 00 00 
  8018de:	be 24 00 00 00       	mov    $0x24,%esi
  8018e3:	48 bf 85 5b 80 00 00 	movabs $0x805b85,%rdi
  8018ea:	00 00 00 
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f2:	49 b9 52 03 80 00 00 	movabs $0x800352,%r9
  8018f9:	00 00 00 
  8018fc:	41 ff d1             	callq  *%r9

	return ret;
  8018ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801903:	48 83 c4 48          	add    $0x48,%rsp
  801907:	5b                   	pop    %rbx
  801908:	5d                   	pop    %rbp
  801909:	c3                   	retq   

000000000080190a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	48 83 ec 10          	sub    $0x10,%rsp
  801912:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801916:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801922:	48 83 ec 08          	sub    $0x8,%rsp
  801926:	6a 00                	pushq  $0x0
  801928:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801934:	48 89 d1             	mov    %rdx,%rcx
  801937:	48 89 c2             	mov    %rax,%rdx
  80193a:	be 00 00 00 00       	mov    $0x0,%esi
  80193f:	bf 00 00 00 00       	mov    $0x0,%edi
  801944:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	callq  *%rax
  801950:	48 83 c4 10          	add    $0x10,%rsp
}
  801954:	90                   	nop
  801955:	c9                   	leaveq 
  801956:	c3                   	retq   

0000000000801957 <sys_cgetc>:

int
sys_cgetc(void)
{
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80195b:	48 83 ec 08          	sub    $0x8,%rsp
  80195f:	6a 00                	pushq  $0x0
  801961:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801967:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801972:	ba 00 00 00 00       	mov    $0x0,%edx
  801977:	be 00 00 00 00       	mov    $0x0,%esi
  80197c:	bf 01 00 00 00       	mov    $0x1,%edi
  801981:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801988:	00 00 00 
  80198b:	ff d0                	callq  *%rax
  80198d:	48 83 c4 10          	add    $0x10,%rsp
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
  801997:	48 83 ec 10          	sub    $0x10,%rsp
  80199b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80199e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a1:	48 98                	cltq   
  8019a3:	48 83 ec 08          	sub    $0x8,%rsp
  8019a7:	6a 00                	pushq  $0x0
  8019a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ba:	48 89 c2             	mov    %rax,%rdx
  8019bd:	be 01 00 00 00       	mov    $0x1,%esi
  8019c2:	bf 03 00 00 00       	mov    $0x3,%edi
  8019c7:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	callq  *%rax
  8019d3:	48 83 c4 10          	add    $0x10,%rsp
}
  8019d7:	c9                   	leaveq 
  8019d8:	c3                   	retq   

00000000008019d9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019d9:	55                   	push   %rbp
  8019da:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019dd:	48 83 ec 08          	sub    $0x8,%rsp
  8019e1:	6a 00                	pushq  $0x0
  8019e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f9:	be 00 00 00 00       	mov    $0x0,%esi
  8019fe:	bf 02 00 00 00       	mov    $0x2,%edi
  801a03:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801a0a:	00 00 00 
  801a0d:	ff d0                	callq  *%rax
  801a0f:	48 83 c4 10          	add    $0x10,%rsp
}
  801a13:	c9                   	leaveq 
  801a14:	c3                   	retq   

0000000000801a15 <sys_yield>:


void
sys_yield(void)
{
  801a15:	55                   	push   %rbp
  801a16:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a19:	48 83 ec 08          	sub    $0x8,%rsp
  801a1d:	6a 00                	pushq  $0x0
  801a1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	be 00 00 00 00       	mov    $0x0,%esi
  801a3a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a3f:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801a46:	00 00 00 
  801a49:	ff d0                	callq  *%rax
  801a4b:	48 83 c4 10          	add    $0x10,%rsp
}
  801a4f:	90                   	nop
  801a50:	c9                   	leaveq 
  801a51:	c3                   	retq   

0000000000801a52 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a52:	55                   	push   %rbp
  801a53:	48 89 e5             	mov    %rsp,%rbp
  801a56:	48 83 ec 10          	sub    $0x10,%rsp
  801a5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a61:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a64:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a67:	48 63 c8             	movslq %eax,%rcx
  801a6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a71:	48 98                	cltq   
  801a73:	48 83 ec 08          	sub    $0x8,%rsp
  801a77:	6a 00                	pushq  $0x0
  801a79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7f:	49 89 c8             	mov    %rcx,%r8
  801a82:	48 89 d1             	mov    %rdx,%rcx
  801a85:	48 89 c2             	mov    %rax,%rdx
  801a88:	be 01 00 00 00       	mov    $0x1,%esi
  801a8d:	bf 04 00 00 00       	mov    $0x4,%edi
  801a92:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801a99:	00 00 00 
  801a9c:	ff d0                	callq  *%rax
  801a9e:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa2:	c9                   	leaveq 
  801aa3:	c3                   	retq   

0000000000801aa4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801aa4:	55                   	push   %rbp
  801aa5:	48 89 e5             	mov    %rsp,%rbp
  801aa8:	48 83 ec 20          	sub    $0x20,%rsp
  801aac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ab6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aba:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801abe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ac1:	48 63 c8             	movslq %eax,%rcx
  801ac4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ac8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801acb:	48 63 f0             	movslq %eax,%rsi
  801ace:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad5:	48 98                	cltq   
  801ad7:	48 83 ec 08          	sub    $0x8,%rsp
  801adb:	51                   	push   %rcx
  801adc:	49 89 f9             	mov    %rdi,%r9
  801adf:	49 89 f0             	mov    %rsi,%r8
  801ae2:	48 89 d1             	mov    %rdx,%rcx
  801ae5:	48 89 c2             	mov    %rax,%rdx
  801ae8:	be 01 00 00 00       	mov    $0x1,%esi
  801aed:	bf 05 00 00 00       	mov    $0x5,%edi
  801af2:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801af9:	00 00 00 
  801afc:	ff d0                	callq  *%rax
  801afe:	48 83 c4 10          	add    $0x10,%rsp
}
  801b02:	c9                   	leaveq 
  801b03:	c3                   	retq   

0000000000801b04 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b04:	55                   	push   %rbp
  801b05:	48 89 e5             	mov    %rsp,%rbp
  801b08:	48 83 ec 10          	sub    $0x10,%rsp
  801b0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1a:	48 98                	cltq   
  801b1c:	48 83 ec 08          	sub    $0x8,%rsp
  801b20:	6a 00                	pushq  $0x0
  801b22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2e:	48 89 d1             	mov    %rdx,%rcx
  801b31:	48 89 c2             	mov    %rax,%rdx
  801b34:	be 01 00 00 00       	mov    $0x1,%esi
  801b39:	bf 06 00 00 00       	mov    $0x6,%edi
  801b3e:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
  801b4a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b4e:	c9                   	leaveq 
  801b4f:	c3                   	retq   

0000000000801b50 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b50:	55                   	push   %rbp
  801b51:	48 89 e5             	mov    %rsp,%rbp
  801b54:	48 83 ec 10          	sub    $0x10,%rsp
  801b58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b61:	48 63 d0             	movslq %eax,%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 83 ec 08          	sub    $0x8,%rsp
  801b6d:	6a 00                	pushq  $0x0
  801b6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7b:	48 89 d1             	mov    %rdx,%rcx
  801b7e:	48 89 c2             	mov    %rax,%rdx
  801b81:	be 01 00 00 00       	mov    $0x1,%esi
  801b86:	bf 08 00 00 00       	mov    $0x8,%edi
  801b8b:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
  801b97:	48 83 c4 10          	add    $0x10,%rsp
}
  801b9b:	c9                   	leaveq 
  801b9c:	c3                   	retq   

0000000000801b9d <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b9d:	55                   	push   %rbp
  801b9e:	48 89 e5             	mov    %rsp,%rbp
  801ba1:	48 83 ec 10          	sub    $0x10,%rsp
  801ba5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb3:	48 98                	cltq   
  801bb5:	48 83 ec 08          	sub    $0x8,%rsp
  801bb9:	6a 00                	pushq  $0x0
  801bbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc7:	48 89 d1             	mov    %rdx,%rcx
  801bca:	48 89 c2             	mov    %rax,%rdx
  801bcd:	be 01 00 00 00       	mov    $0x1,%esi
  801bd2:	bf 09 00 00 00       	mov    $0x9,%edi
  801bd7:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	callq  *%rax
  801be3:	48 83 c4 10          	add    $0x10,%rsp
}
  801be7:	c9                   	leaveq 
  801be8:	c3                   	retq   

0000000000801be9 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801be9:	55                   	push   %rbp
  801bea:	48 89 e5             	mov    %rsp,%rbp
  801bed:	48 83 ec 10          	sub    $0x10,%rsp
  801bf1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bf8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bff:	48 98                	cltq   
  801c01:	48 83 ec 08          	sub    $0x8,%rsp
  801c05:	6a 00                	pushq  $0x0
  801c07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c13:	48 89 d1             	mov    %rdx,%rcx
  801c16:	48 89 c2             	mov    %rax,%rdx
  801c19:	be 01 00 00 00       	mov    $0x1,%esi
  801c1e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c23:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	callq  *%rax
  801c2f:	48 83 c4 10          	add    $0x10,%rsp
}
  801c33:	c9                   	leaveq 
  801c34:	c3                   	retq   

0000000000801c35 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	48 83 ec 20          	sub    $0x20,%rsp
  801c3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c44:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c48:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4e:	48 63 f0             	movslq %eax,%rsi
  801c51:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c58:	48 98                	cltq   
  801c5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5e:	48 83 ec 08          	sub    $0x8,%rsp
  801c62:	6a 00                	pushq  $0x0
  801c64:	49 89 f1             	mov    %rsi,%r9
  801c67:	49 89 c8             	mov    %rcx,%r8
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 00 00 00 00       	mov    $0x0,%esi
  801c75:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c7a:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
  801c86:	48 83 c4 10          	add    $0x10,%rsp
}
  801c8a:	c9                   	leaveq 
  801c8b:	c3                   	retq   

0000000000801c8c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c8c:	55                   	push   %rbp
  801c8d:	48 89 e5             	mov    %rsp,%rbp
  801c90:	48 83 ec 10          	sub    $0x10,%rsp
  801c94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9c:	48 83 ec 08          	sub    $0x8,%rsp
  801ca0:	6a 00                	pushq  $0x0
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb3:	48 89 c2             	mov    %rax,%rdx
  801cb6:	be 01 00 00 00       	mov    $0x1,%esi
  801cbb:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cc0:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801cc7:	00 00 00 
  801cca:	ff d0                	callq  *%rax
  801ccc:	48 83 c4 10          	add    $0x10,%rsp
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cd6:	48 83 ec 08          	sub    $0x8,%rsp
  801cda:	6a 00                	pushq  $0x0
  801cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ced:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf2:	be 00 00 00 00       	mov    $0x0,%esi
  801cf7:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cfc:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801d03:	00 00 00 
  801d06:	ff d0                	callq  *%rax
  801d08:	48 83 c4 10          	add    $0x10,%rsp
}
  801d0c:	c9                   	leaveq 
  801d0d:	c3                   	retq   

0000000000801d0e <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801d0e:	55                   	push   %rbp
  801d0f:	48 89 e5             	mov    %rsp,%rbp
  801d12:	48 83 ec 10          	sub    $0x10,%rsp
  801d16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801d1d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d24:	48 83 ec 08          	sub    $0x8,%rsp
  801d28:	6a 00                	pushq  $0x0
  801d2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d36:	48 89 d1             	mov    %rdx,%rcx
  801d39:	48 89 c2             	mov    %rax,%rdx
  801d3c:	be 00 00 00 00       	mov    $0x0,%esi
  801d41:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d46:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801d4d:	00 00 00 
  801d50:	ff d0                	callq  *%rax
  801d52:	48 83 c4 10          	add    $0x10,%rsp
}
  801d56:	c9                   	leaveq 
  801d57:	c3                   	retq   

0000000000801d58 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801d58:	55                   	push   %rbp
  801d59:	48 89 e5             	mov    %rsp,%rbp
  801d5c:	48 83 ec 10          	sub    $0x10,%rsp
  801d60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d64:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801d67:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6e:	48 83 ec 08          	sub    $0x8,%rsp
  801d72:	6a 00                	pushq  $0x0
  801d74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d80:	48 89 d1             	mov    %rdx,%rcx
  801d83:	48 89 c2             	mov    %rax,%rdx
  801d86:	be 00 00 00 00       	mov    $0x0,%esi
  801d8b:	bf 10 00 00 00       	mov    $0x10,%edi
  801d90:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	callq  *%rax
  801d9c:	48 83 c4 10          	add    $0x10,%rsp
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 20          	sub    $0x20,%rsp
  801daa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801db4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801db8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dbc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dbf:	48 63 c8             	movslq %eax,%rcx
  801dc2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc9:	48 63 f0             	movslq %eax,%rsi
  801dcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd3:	48 98                	cltq   
  801dd5:	48 83 ec 08          	sub    $0x8,%rsp
  801dd9:	51                   	push   %rcx
  801dda:	49 89 f9             	mov    %rdi,%r9
  801ddd:	49 89 f0             	mov    %rsi,%r8
  801de0:	48 89 d1             	mov    %rdx,%rcx
  801de3:	48 89 c2             	mov    %rax,%rdx
  801de6:	be 00 00 00 00       	mov    $0x0,%esi
  801deb:	bf 11 00 00 00       	mov    $0x11,%edi
  801df0:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801df7:	00 00 00 
  801dfa:	ff d0                	callq  *%rax
  801dfc:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e00:	c9                   	leaveq 
  801e01:	c3                   	retq   

0000000000801e02 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e02:	55                   	push   %rbp
  801e03:	48 89 e5             	mov    %rsp,%rbp
  801e06:	48 83 ec 10          	sub    $0x10,%rsp
  801e0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1a:	48 83 ec 08          	sub    $0x8,%rsp
  801e1e:	6a 00                	pushq  $0x0
  801e20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2c:	48 89 d1             	mov    %rdx,%rcx
  801e2f:	48 89 c2             	mov    %rax,%rdx
  801e32:	be 00 00 00 00       	mov    $0x0,%esi
  801e37:	bf 12 00 00 00       	mov    $0x12,%edi
  801e3c:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	callq  *%rax
  801e48:	48 83 c4 10          	add    $0x10,%rsp
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801e52:	48 83 ec 08          	sub    $0x8,%rsp
  801e56:	6a 00                	pushq  $0x0
  801e58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e64:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e69:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6e:	be 00 00 00 00       	mov    $0x0,%esi
  801e73:	bf 13 00 00 00       	mov    $0x13,%edi
  801e78:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801e7f:	00 00 00 
  801e82:	ff d0                	callq  *%rax
  801e84:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801e88:	90                   	nop
  801e89:	c9                   	leaveq 
  801e8a:	c3                   	retq   

0000000000801e8b <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e8b:	55                   	push   %rbp
  801e8c:	48 89 e5             	mov    %rsp,%rbp
  801e8f:	48 83 ec 10          	sub    $0x10,%rsp
  801e93:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e99:	48 98                	cltq   
  801e9b:	48 83 ec 08          	sub    $0x8,%rsp
  801e9f:	6a 00                	pushq  $0x0
  801ea1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ead:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eb2:	48 89 c2             	mov    %rax,%rdx
  801eb5:	be 00 00 00 00       	mov    $0x0,%esi
  801eba:	bf 14 00 00 00       	mov    $0x14,%edi
  801ebf:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	callq  *%rax
  801ecb:	48 83 c4 10          	add    $0x10,%rsp
}
  801ecf:	c9                   	leaveq 
  801ed0:	c3                   	retq   

0000000000801ed1 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801ed1:	55                   	push   %rbp
  801ed2:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801ed5:	48 83 ec 08          	sub    $0x8,%rsp
  801ed9:	6a 00                	pushq  $0x0
  801edb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eec:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef1:	be 00 00 00 00       	mov    $0x0,%esi
  801ef6:	bf 15 00 00 00       	mov    $0x15,%edi
  801efb:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	callq  *%rax
  801f07:	48 83 c4 10          	add    $0x10,%rsp
}
  801f0b:	c9                   	leaveq 
  801f0c:	c3                   	retq   

0000000000801f0d <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f11:	48 83 ec 08          	sub    $0x8,%rsp
  801f15:	6a 00                	pushq  $0x0
  801f17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f23:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f28:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2d:	be 00 00 00 00       	mov    $0x0,%esi
  801f32:	bf 16 00 00 00       	mov    $0x16,%edi
  801f37:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	callq  *%rax
  801f43:	48 83 c4 10          	add    $0x10,%rsp
}
  801f47:	90                   	nop
  801f48:	c9                   	leaveq 
  801f49:	c3                   	retq   

0000000000801f4a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f4a:	55                   	push   %rbp
  801f4b:	48 89 e5             	mov    %rsp,%rbp
  801f4e:	48 83 ec 30          	sub    $0x30,%rsp
  801f52:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f5a:	48 8b 00             	mov    (%rax),%rax
  801f5d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801f61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f65:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f69:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6f:	83 e0 02             	and    $0x2,%eax
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 40                	jne    801fb6 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801f76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f7a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801f81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f85:	49 89 d0             	mov    %rdx,%r8
  801f88:	48 89 c1             	mov    %rax,%rcx
  801f8b:	48 ba 98 5b 80 00 00 	movabs $0x805b98,%rdx
  801f92:	00 00 00 
  801f95:	be 1f 00 00 00       	mov    $0x1f,%esi
  801f9a:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  801fa1:	00 00 00 
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	49 b9 52 03 80 00 00 	movabs $0x800352,%r9
  801fb0:	00 00 00 
  801fb3:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801fb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fba:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbe:	48 89 c2             	mov    %rax,%rdx
  801fc1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc8:	01 00 00 
  801fcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcf:	25 07 08 00 00       	and    $0x807,%eax
  801fd4:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801fda:	74 4e                	je     80202a <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801fdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe0:	48 c1 e8 0c          	shr    $0xc,%rax
  801fe4:	48 89 c2             	mov    %rax,%rdx
  801fe7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fee:	01 00 00 
  801ff1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff9:	49 89 d0             	mov    %rdx,%r8
  801ffc:	48 89 c1             	mov    %rax,%rcx
  801fff:	48 ba c0 5b 80 00 00 	movabs $0x805bc0,%rdx
  802006:	00 00 00 
  802009:	be 22 00 00 00       	mov    $0x22,%esi
  80200e:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  802015:	00 00 00 
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	49 b9 52 03 80 00 00 	movabs $0x800352,%r9
  802024:	00 00 00 
  802027:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80202a:	ba 07 00 00 00       	mov    $0x7,%edx
  80202f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802034:	bf 00 00 00 00       	mov    $0x0,%edi
  802039:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802040:	00 00 00 
  802043:	ff d0                	callq  *%rax
  802045:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802048:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80204c:	79 30                	jns    80207e <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  80204e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802051:	89 c1                	mov    %eax,%ecx
  802053:	48 ba eb 5b 80 00 00 	movabs $0x805beb,%rdx
  80205a:	00 00 00 
  80205d:	be 28 00 00 00       	mov    $0x28,%esi
  802062:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  802069:	00 00 00 
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802078:	00 00 00 
  80207b:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80207e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802082:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802090:	ba 00 10 00 00       	mov    $0x1000,%edx
  802095:	48 89 c6             	mov    %rax,%rsi
  802098:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80209d:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8020a4:	00 00 00 
  8020a7:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8020a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8020bb:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020c1:	48 89 c1             	mov    %rax,%rcx
  8020c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d3:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
  8020df:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020e6:	79 30                	jns    802118 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8020e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020eb:	89 c1                	mov    %eax,%ecx
  8020ed:	48 ba fe 5b 80 00 00 	movabs $0x805bfe,%rdx
  8020f4:	00 00 00 
  8020f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8020fc:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  802103:	00 00 00 
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802112:	00 00 00 
  802115:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802118:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80211d:	bf 00 00 00 00       	mov    $0x0,%edi
  802122:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax
  80212e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802131:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802135:	79 30                	jns    802167 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802137:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80213a:	89 c1                	mov    %eax,%ecx
  80213c:	48 ba 0f 5c 80 00 00 	movabs $0x805c0f,%rdx
  802143:	00 00 00 
  802146:	be 31 00 00 00       	mov    $0x31,%esi
  80214b:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  802152:	00 00 00 
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
  80215a:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802161:	00 00 00 
  802164:	41 ff d0             	callq  *%r8

}
  802167:	90                   	nop
  802168:	c9                   	leaveq 
  802169:	c3                   	retq   

000000000080216a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80216a:	55                   	push   %rbp
  80216b:	48 89 e5             	mov    %rsp,%rbp
  80216e:	48 83 ec 30          	sub    $0x30,%rsp
  802172:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802175:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802178:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80217b:	c1 e0 0c             	shl    $0xc,%eax
  80217e:	89 c0                	mov    %eax,%eax
  802180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802184:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218b:	01 00 00 
  80218e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802191:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802195:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219d:	25 02 08 00 00       	and    $0x802,%eax
  8021a2:	48 85 c0             	test   %rax,%rax
  8021a5:	74 0e                	je     8021b5 <duppage+0x4b>
  8021a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ab:	25 00 04 00 00       	and    $0x400,%eax
  8021b0:	48 85 c0             	test   %rax,%rax
  8021b3:	74 70                	je     802225 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8021b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8021be:	89 c6                	mov    %eax,%esi
  8021c0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8021c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021cb:	41 89 f0             	mov    %esi,%r8d
  8021ce:	48 89 c6             	mov    %rax,%rsi
  8021d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d6:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021e9:	79 30                	jns    80221b <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8021eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021ee:	89 c1                	mov    %eax,%ecx
  8021f0:	48 ba fe 5b 80 00 00 	movabs $0x805bfe,%rdx
  8021f7:	00 00 00 
  8021fa:	be 50 00 00 00       	mov    $0x50,%esi
  8021ff:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  802206:	00 00 00 
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802215:	00 00 00 
  802218:	41 ff d0             	callq  *%r8
		return 0;
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
  802220:	e9 c4 00 00 00       	jmpq   8022e9 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802225:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802229:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80222c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802230:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802236:	48 89 c6             	mov    %rax,%rsi
  802239:	bf 00 00 00 00       	mov    $0x0,%edi
  80223e:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax
  80224a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80224d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802251:	79 30                	jns    802283 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802253:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802256:	89 c1                	mov    %eax,%ecx
  802258:	48 ba fe 5b 80 00 00 	movabs $0x805bfe,%rdx
  80225f:	00 00 00 
  802262:	be 64 00 00 00       	mov    $0x64,%esi
  802267:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  80226e:	00 00 00 
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
  802276:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80227d:	00 00 00 
  802280:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802283:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228b:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802291:	48 89 d1             	mov    %rdx,%rcx
  802294:	ba 00 00 00 00       	mov    $0x0,%edx
  802299:	48 89 c6             	mov    %rax,%rsi
  80229c:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a1:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8022b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022b4:	79 30                	jns    8022e6 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8022b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022b9:	89 c1                	mov    %eax,%ecx
  8022bb:	48 ba fe 5b 80 00 00 	movabs $0x805bfe,%rdx
  8022c2:	00 00 00 
  8022c5:	be 66 00 00 00       	mov    $0x66,%esi
  8022ca:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  8022d1:	00 00 00 
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8022e0:	00 00 00 
  8022e3:	41 ff d0             	callq  *%r8
	return r;
  8022e6:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8022e9:	c9                   	leaveq 
  8022ea:	c3                   	retq   

00000000008022eb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022eb:	55                   	push   %rbp
  8022ec:	48 89 e5             	mov    %rsp,%rbp
  8022ef:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8022f3:	48 bf 4a 1f 80 00 00 	movabs $0x801f4a,%rdi
  8022fa:	00 00 00 
  8022fd:	48 b8 12 52 80 00 00 	movabs $0x805212,%rax
  802304:	00 00 00 
  802307:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802309:	b8 07 00 00 00       	mov    $0x7,%eax
  80230e:	cd 30                	int    $0x30
  802310:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802313:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802316:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802319:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80231d:	79 08                	jns    802327 <fork+0x3c>
		return envid;
  80231f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802322:	e9 0b 02 00 00       	jmpq   802532 <fork+0x247>
	if (envid == 0) {
  802327:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80232b:	75 3e                	jne    80236b <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80232d:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  802334:	00 00 00 
  802337:	ff d0                	callq  *%rax
  802339:	25 ff 03 00 00       	and    $0x3ff,%eax
  80233e:	48 98                	cltq   
  802340:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802347:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80234e:	00 00 00 
  802351:	48 01 c2             	add    %rax,%rdx
  802354:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80235b:	00 00 00 
  80235e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
  802366:	e9 c7 01 00 00       	jmpq   802532 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80236b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802372:	e9 a6 00 00 00       	jmpq   80241d <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237a:	c1 f8 12             	sar    $0x12,%eax
  80237d:	89 c2                	mov    %eax,%edx
  80237f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802386:	01 00 00 
  802389:	48 63 d2             	movslq %edx,%rdx
  80238c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802390:	83 e0 01             	and    $0x1,%eax
  802393:	48 85 c0             	test   %rax,%rax
  802396:	74 21                	je     8023b9 <fork+0xce>
  802398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239b:	c1 f8 09             	sar    $0x9,%eax
  80239e:	89 c2                	mov    %eax,%edx
  8023a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023a7:	01 00 00 
  8023aa:	48 63 d2             	movslq %edx,%rdx
  8023ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b1:	83 e0 01             	and    $0x1,%eax
  8023b4:	48 85 c0             	test   %rax,%rax
  8023b7:	75 09                	jne    8023c2 <fork+0xd7>
			pn += NPTENTRIES;
  8023b9:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8023c0:	eb 5b                	jmp    80241d <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8023c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c5:	05 00 02 00 00       	add    $0x200,%eax
  8023ca:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023cd:	eb 46                	jmp    802415 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8023cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d6:	01 00 00 
  8023d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023dc:	48 63 d2             	movslq %edx,%rdx
  8023df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e3:	83 e0 05             	and    $0x5,%eax
  8023e6:	48 83 f8 05          	cmp    $0x5,%rax
  8023ea:	75 21                	jne    80240d <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  8023ec:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8023f3:	74 1b                	je     802410 <fork+0x125>
				continue;
			duppage(envid, pn);
  8023f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fb:	89 d6                	mov    %edx,%esi
  8023fd:	89 c7                	mov    %eax,%edi
  8023ff:	48 b8 6a 21 80 00 00 	movabs $0x80216a,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
  80240b:	eb 04                	jmp    802411 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80240d:	90                   	nop
  80240e:	eb 01                	jmp    802411 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802410:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802411:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802418:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80241b:	7c b2                	jl     8023cf <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80241d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802420:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802425:	0f 86 4c ff ff ff    	jbe    802377 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80242b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242e:	ba 07 00 00 00       	mov    $0x7,%edx
  802433:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802438:	89 c7                	mov    %eax,%edi
  80243a:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802441:	00 00 00 
  802444:	ff d0                	callq  *%rax
  802446:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802449:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80244d:	79 30                	jns    80247f <fork+0x194>
		panic("allocating exception stack: %e", r);
  80244f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802452:	89 c1                	mov    %eax,%ecx
  802454:	48 ba 28 5c 80 00 00 	movabs $0x805c28,%rdx
  80245b:	00 00 00 
  80245e:	be 9e 00 00 00       	mov    $0x9e,%esi
  802463:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  80246a:	00 00 00 
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
  802472:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802479:	00 00 00 
  80247c:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80247f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802486:	00 00 00 
  802489:	48 8b 00             	mov    (%rax),%rax
  80248c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802493:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802496:	48 89 d6             	mov    %rdx,%rsi
  802499:	89 c7                	mov    %eax,%edi
  80249b:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	callq  *%rax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024ae:	79 30                	jns    8024e0 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8024b0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024b3:	89 c1                	mov    %eax,%ecx
  8024b5:	48 ba 48 5c 80 00 00 	movabs $0x805c48,%rdx
  8024bc:	00 00 00 
  8024bf:	be a2 00 00 00       	mov    $0xa2,%esi
  8024c4:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  8024cb:	00 00 00 
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8024da:	00 00 00 
  8024dd:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8024e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e3:	be 02 00 00 00       	mov    $0x2,%esi
  8024e8:	89 c7                	mov    %eax,%edi
  8024ea:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	callq  *%rax
  8024f6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024fd:	79 30                	jns    80252f <fork+0x244>
		panic("sys_env_set_status: %e", r);
  8024ff:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802502:	89 c1                	mov    %eax,%ecx
  802504:	48 ba 67 5c 80 00 00 	movabs $0x805c67,%rdx
  80250b:	00 00 00 
  80250e:	be a7 00 00 00       	mov    $0xa7,%esi
  802513:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  80251a:	00 00 00 
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
  802522:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802529:	00 00 00 
  80252c:	41 ff d0             	callq  *%r8

	return envid;
  80252f:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802532:	c9                   	leaveq 
  802533:	c3                   	retq   

0000000000802534 <sfork>:

// Challenge!
int
sfork(void)
{
  802534:	55                   	push   %rbp
  802535:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802538:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  80253f:	00 00 00 
  802542:	be b1 00 00 00       	mov    $0xb1,%esi
  802547:	48 bf b1 5b 80 00 00 	movabs $0x805bb1,%rdi
  80254e:	00 00 00 
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
  802556:	48 b9 52 03 80 00 00 	movabs $0x800352,%rcx
  80255d:	00 00 00 
  802560:	ff d1                	callq  *%rcx

0000000000802562 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802562:	55                   	push   %rbp
  802563:	48 89 e5             	mov    %rsp,%rbp
  802566:	48 83 ec 08          	sub    $0x8,%rsp
  80256a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80256e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802572:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802579:	ff ff ff 
  80257c:	48 01 d0             	add    %rdx,%rax
  80257f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802583:	c9                   	leaveq 
  802584:	c3                   	retq   

0000000000802585 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802585:	55                   	push   %rbp
  802586:	48 89 e5             	mov    %rsp,%rbp
  802589:	48 83 ec 08          	sub    $0x8,%rsp
  80258d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802595:	48 89 c7             	mov    %rax,%rdi
  802598:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025aa:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025ae:	c9                   	leaveq 
  8025af:	c3                   	retq   

00000000008025b0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025b0:	55                   	push   %rbp
  8025b1:	48 89 e5             	mov    %rsp,%rbp
  8025b4:	48 83 ec 18          	sub    $0x18,%rsp
  8025b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025c3:	eb 6b                	jmp    802630 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c8:	48 98                	cltq   
  8025ca:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025d0:	48 c1 e0 0c          	shl    $0xc,%rax
  8025d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dc:	48 c1 e8 15          	shr    $0x15,%rax
  8025e0:	48 89 c2             	mov    %rax,%rdx
  8025e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025ea:	01 00 00 
  8025ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f1:	83 e0 01             	and    $0x1,%eax
  8025f4:	48 85 c0             	test   %rax,%rax
  8025f7:	74 21                	je     80261a <fd_alloc+0x6a>
  8025f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802601:	48 89 c2             	mov    %rax,%rdx
  802604:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80260b:	01 00 00 
  80260e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802612:	83 e0 01             	and    $0x1,%eax
  802615:	48 85 c0             	test   %rax,%rax
  802618:	75 12                	jne    80262c <fd_alloc+0x7c>
			*fd_store = fd;
  80261a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802622:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
  80262a:	eb 1a                	jmp    802646 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80262c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802630:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802634:	7e 8f                	jle    8025c5 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802641:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802646:	c9                   	leaveq 
  802647:	c3                   	retq   

0000000000802648 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802648:	55                   	push   %rbp
  802649:	48 89 e5             	mov    %rsp,%rbp
  80264c:	48 83 ec 20          	sub    $0x20,%rsp
  802650:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802653:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802657:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80265b:	78 06                	js     802663 <fd_lookup+0x1b>
  80265d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802661:	7e 07                	jle    80266a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802668:	eb 6c                	jmp    8026d6 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80266a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80266d:	48 98                	cltq   
  80266f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802675:	48 c1 e0 0c          	shl    $0xc,%rax
  802679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80267d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802681:	48 c1 e8 15          	shr    $0x15,%rax
  802685:	48 89 c2             	mov    %rax,%rdx
  802688:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80268f:	01 00 00 
  802692:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802696:	83 e0 01             	and    $0x1,%eax
  802699:	48 85 c0             	test   %rax,%rax
  80269c:	74 21                	je     8026bf <fd_lookup+0x77>
  80269e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a2:	48 c1 e8 0c          	shr    $0xc,%rax
  8026a6:	48 89 c2             	mov    %rax,%rdx
  8026a9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026b0:	01 00 00 
  8026b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b7:	83 e0 01             	and    $0x1,%eax
  8026ba:	48 85 c0             	test   %rax,%rax
  8026bd:	75 07                	jne    8026c6 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c4:	eb 10                	jmp    8026d6 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026ce:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d6:	c9                   	leaveq 
  8026d7:	c3                   	retq   

00000000008026d8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026d8:	55                   	push   %rbp
  8026d9:	48 89 e5             	mov    %rsp,%rbp
  8026dc:	48 83 ec 30          	sub    $0x30,%rsp
  8026e0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026e4:	89 f0                	mov    %esi,%eax
  8026e6:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ed:	48 89 c7             	mov    %rax,%rdi
  8026f0:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
  8026fc:	89 c2                	mov    %eax,%edx
  8026fe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802702:	48 89 c6             	mov    %rax,%rsi
  802705:	89 d7                	mov    %edx,%edi
  802707:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
  802713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271a:	78 0a                	js     802726 <fd_close+0x4e>
	    || fd != fd2)
  80271c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802720:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802724:	74 12                	je     802738 <fd_close+0x60>
		return (must_exist ? r : 0);
  802726:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80272a:	74 05                	je     802731 <fd_close+0x59>
  80272c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272f:	eb 70                	jmp    8027a1 <fd_close+0xc9>
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
  802736:	eb 69                	jmp    8027a1 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273c:	8b 00                	mov    (%rax),%eax
  80273e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802742:	48 89 d6             	mov    %rdx,%rsi
  802745:	89 c7                	mov    %eax,%edi
  802747:	48 b8 a3 27 80 00 00 	movabs $0x8027a3,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax
  802753:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802756:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275a:	78 2a                	js     802786 <fd_close+0xae>
		if (dev->dev_close)
  80275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802760:	48 8b 40 20          	mov    0x20(%rax),%rax
  802764:	48 85 c0             	test   %rax,%rax
  802767:	74 16                	je     80277f <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802771:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802775:	48 89 d7             	mov    %rdx,%rdi
  802778:	ff d0                	callq  *%rax
  80277a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277d:	eb 07                	jmp    802786 <fd_close+0xae>
		else
			r = 0;
  80277f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278a:	48 89 c6             	mov    %rax,%rsi
  80278d:	bf 00 00 00 00       	mov    $0x0,%edi
  802792:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  802799:	00 00 00 
  80279c:	ff d0                	callq  *%rax
	return r;
  80279e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027a1:	c9                   	leaveq 
  8027a2:	c3                   	retq   

00000000008027a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027a3:	55                   	push   %rbp
  8027a4:	48 89 e5             	mov    %rsp,%rbp
  8027a7:	48 83 ec 20          	sub    $0x20,%rsp
  8027ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027b9:	eb 41                	jmp    8027fc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8027bb:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8027c2:	00 00 00 
  8027c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027c8:	48 63 d2             	movslq %edx,%rdx
  8027cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027cf:	8b 00                	mov    (%rax),%eax
  8027d1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027d4:	75 22                	jne    8027f8 <dev_lookup+0x55>
			*dev = devtab[i];
  8027d6:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8027dd:	00 00 00 
  8027e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027e3:	48 63 d2             	movslq %edx,%rdx
  8027e6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	eb 60                	jmp    802858 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027fc:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802803:	00 00 00 
  802806:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802809:	48 63 d2             	movslq %edx,%rdx
  80280c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802810:	48 85 c0             	test   %rax,%rax
  802813:	75 a6                	jne    8027bb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802815:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80281c:	00 00 00 
  80281f:	48 8b 00             	mov    (%rax),%rax
  802822:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802828:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80282b:	89 c6                	mov    %eax,%esi
  80282d:	48 bf 98 5c 80 00 00 	movabs $0x805c98,%rdi
  802834:	00 00 00 
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
  80283c:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802843:	00 00 00 
  802846:	ff d1                	callq  *%rcx
	*dev = 0;
  802848:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802853:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802858:	c9                   	leaveq 
  802859:	c3                   	retq   

000000000080285a <close>:

int
close(int fdnum)
{
  80285a:	55                   	push   %rbp
  80285b:	48 89 e5             	mov    %rsp,%rbp
  80285e:	48 83 ec 20          	sub    $0x20,%rsp
  802862:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802865:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802869:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80286c:	48 89 d6             	mov    %rdx,%rsi
  80286f:	89 c7                	mov    %eax,%edi
  802871:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
  80287d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802884:	79 05                	jns    80288b <close+0x31>
		return r;
  802886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802889:	eb 18                	jmp    8028a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80288b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288f:	be 01 00 00 00       	mov    $0x1,%esi
  802894:	48 89 c7             	mov    %rax,%rdi
  802897:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
}
  8028a3:	c9                   	leaveq 
  8028a4:	c3                   	retq   

00000000008028a5 <close_all>:

void
close_all(void)
{
  8028a5:	55                   	push   %rbp
  8028a6:	48 89 e5             	mov    %rsp,%rbp
  8028a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028b4:	eb 15                	jmp    8028cb <close_all+0x26>
		close(i);
  8028b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b9:	89 c7                	mov    %eax,%edi
  8028bb:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028cf:	7e e5                	jle    8028b6 <close_all+0x11>
		close(i);
}
  8028d1:	90                   	nop
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 40          	sub    $0x40,%rsp
  8028dc:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028df:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028e2:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028e6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028e9:	48 89 d6             	mov    %rdx,%rsi
  8028ec:	89 c7                	mov    %eax,%edi
  8028ee:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
  8028fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802901:	79 08                	jns    80290b <dup+0x37>
		return r;
  802903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802906:	e9 70 01 00 00       	jmpq   802a7b <dup+0x1a7>
	close(newfdnum);
  80290b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80290e:	89 c7                	mov    %eax,%edi
  802910:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  802917:	00 00 00 
  80291a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80291c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80291f:	48 98                	cltq   
  802921:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802927:	48 c1 e0 0c          	shl    $0xc,%rax
  80292b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80292f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802933:	48 89 c7             	mov    %rax,%rdi
  802936:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  80293d:	00 00 00 
  802940:	ff d0                	callq  *%rax
  802942:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802946:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294a:	48 89 c7             	mov    %rax,%rdi
  80294d:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
  802959:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80295d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802961:	48 c1 e8 15          	shr    $0x15,%rax
  802965:	48 89 c2             	mov    %rax,%rdx
  802968:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80296f:	01 00 00 
  802972:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802976:	83 e0 01             	and    $0x1,%eax
  802979:	48 85 c0             	test   %rax,%rax
  80297c:	74 71                	je     8029ef <dup+0x11b>
  80297e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802982:	48 c1 e8 0c          	shr    $0xc,%rax
  802986:	48 89 c2             	mov    %rax,%rdx
  802989:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802990:	01 00 00 
  802993:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802997:	83 e0 01             	and    $0x1,%eax
  80299a:	48 85 c0             	test   %rax,%rax
  80299d:	74 50                	je     8029ef <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80299f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8029a7:	48 89 c2             	mov    %rax,%rdx
  8029aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029b1:	01 00 00 
  8029b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8029bd:	89 c1                	mov    %eax,%ecx
  8029bf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c7:	41 89 c8             	mov    %ecx,%r8d
  8029ca:	48 89 d1             	mov    %rdx,%rcx
  8029cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d2:	48 89 c6             	mov    %rax,%rsi
  8029d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029da:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8029e1:	00 00 00 
  8029e4:	ff d0                	callq  *%rax
  8029e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ed:	78 55                	js     802a44 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f7:	48 89 c2             	mov    %rax,%rdx
  8029fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a01:	01 00 00 
  802a04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a08:	25 07 0e 00 00       	and    $0xe07,%eax
  802a0d:	89 c1                	mov    %eax,%ecx
  802a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a17:	41 89 c8             	mov    %ecx,%r8d
  802a1a:	48 89 d1             	mov    %rdx,%rcx
  802a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a22:	48 89 c6             	mov    %rax,%rsi
  802a25:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2a:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3d:	78 08                	js     802a47 <dup+0x173>
		goto err;

	return newfdnum;
  802a3f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a42:	eb 37                	jmp    802a7b <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802a44:	90                   	nop
  802a45:	eb 01                	jmp    802a48 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802a47:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802a48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4c:	48 89 c6             	mov    %rax,%rsi
  802a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  802a54:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a64:	48 89 c6             	mov    %rax,%rsi
  802a67:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6c:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax
	return r;
  802a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a7b:	c9                   	leaveq 
  802a7c:	c3                   	retq   

0000000000802a7d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a7d:	55                   	push   %rbp
  802a7e:	48 89 e5             	mov    %rsp,%rbp
  802a81:	48 83 ec 40          	sub    $0x40,%rsp
  802a85:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a88:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a8c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a90:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a94:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a97:	48 89 d6             	mov    %rdx,%rsi
  802a9a:	89 c7                	mov    %eax,%edi
  802a9c:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
  802aa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aaf:	78 24                	js     802ad5 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab5:	8b 00                	mov    (%rax),%eax
  802ab7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802abb:	48 89 d6             	mov    %rdx,%rsi
  802abe:	89 c7                	mov    %eax,%edi
  802ac0:	48 b8 a3 27 80 00 00 	movabs $0x8027a3,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
  802acc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad3:	79 05                	jns    802ada <read+0x5d>
		return r;
  802ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad8:	eb 76                	jmp    802b50 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ade:	8b 40 08             	mov    0x8(%rax),%eax
  802ae1:	83 e0 03             	and    $0x3,%eax
  802ae4:	83 f8 01             	cmp    $0x1,%eax
  802ae7:	75 3a                	jne    802b23 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802ae9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802af0:	00 00 00 
  802af3:	48 8b 00             	mov    (%rax),%rax
  802af6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802afc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802aff:	89 c6                	mov    %eax,%esi
  802b01:	48 bf b7 5c 80 00 00 	movabs $0x805cb7,%rdi
  802b08:	00 00 00 
  802b0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b10:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802b17:	00 00 00 
  802b1a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b21:	eb 2d                	jmp    802b50 <read+0xd3>
	}
	if (!dev->dev_read)
  802b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b27:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b2b:	48 85 c0             	test   %rax,%rax
  802b2e:	75 07                	jne    802b37 <read+0xba>
		return -E_NOT_SUPP;
  802b30:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b35:	eb 19                	jmp    802b50 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b3f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b47:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b4b:	48 89 cf             	mov    %rcx,%rdi
  802b4e:	ff d0                	callq  *%rax
}
  802b50:	c9                   	leaveq 
  802b51:	c3                   	retq   

0000000000802b52 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b52:	55                   	push   %rbp
  802b53:	48 89 e5             	mov    %rsp,%rbp
  802b56:	48 83 ec 30          	sub    $0x30,%rsp
  802b5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b6c:	eb 47                	jmp    802bb5 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b71:	48 98                	cltq   
  802b73:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b77:	48 29 c2             	sub    %rax,%rdx
  802b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7d:	48 63 c8             	movslq %eax,%rcx
  802b80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b84:	48 01 c1             	add    %rax,%rcx
  802b87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8a:	48 89 ce             	mov    %rcx,%rsi
  802b8d:	89 c7                	mov    %eax,%edi
  802b8f:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
  802b9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b9e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ba2:	79 05                	jns    802ba9 <readn+0x57>
			return m;
  802ba4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba7:	eb 1d                	jmp    802bc6 <readn+0x74>
		if (m == 0)
  802ba9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bad:	74 13                	je     802bc2 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802baf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb2:	01 45 fc             	add    %eax,-0x4(%rbp)
  802bb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb8:	48 98                	cltq   
  802bba:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bbe:	72 ae                	jb     802b6e <readn+0x1c>
  802bc0:	eb 01                	jmp    802bc3 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802bc2:	90                   	nop
	}
	return tot;
  802bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bc6:	c9                   	leaveq 
  802bc7:	c3                   	retq   

0000000000802bc8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802bc8:	55                   	push   %rbp
  802bc9:	48 89 e5             	mov    %rsp,%rbp
  802bcc:	48 83 ec 40          	sub    $0x40,%rsp
  802bd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bd3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bd7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bdb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bdf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802be2:	48 89 d6             	mov    %rdx,%rsi
  802be5:	89 c7                	mov    %eax,%edi
  802be7:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802bee:	00 00 00 
  802bf1:	ff d0                	callq  *%rax
  802bf3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfa:	78 24                	js     802c20 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c00:	8b 00                	mov    (%rax),%eax
  802c02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c06:	48 89 d6             	mov    %rdx,%rsi
  802c09:	89 c7                	mov    %eax,%edi
  802c0b:	48 b8 a3 27 80 00 00 	movabs $0x8027a3,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1e:	79 05                	jns    802c25 <write+0x5d>
		return r;
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c23:	eb 75                	jmp    802c9a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c29:	8b 40 08             	mov    0x8(%rax),%eax
  802c2c:	83 e0 03             	and    $0x3,%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	75 3a                	jne    802c6d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c33:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802c3a:	00 00 00 
  802c3d:	48 8b 00             	mov    (%rax),%rax
  802c40:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c46:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c49:	89 c6                	mov    %eax,%esi
  802c4b:	48 bf d3 5c 80 00 00 	movabs $0x805cd3,%rdi
  802c52:	00 00 00 
  802c55:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5a:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802c61:	00 00 00 
  802c64:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c6b:	eb 2d                	jmp    802c9a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c71:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c75:	48 85 c0             	test   %rax,%rax
  802c78:	75 07                	jne    802c81 <write+0xb9>
		return -E_NOT_SUPP;
  802c7a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c7f:	eb 19                	jmp    802c9a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c85:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c89:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c91:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c95:	48 89 cf             	mov    %rcx,%rdi
  802c98:	ff d0                	callq  *%rax
}
  802c9a:	c9                   	leaveq 
  802c9b:	c3                   	retq   

0000000000802c9c <seek>:

int
seek(int fdnum, off_t offset)
{
  802c9c:	55                   	push   %rbp
  802c9d:	48 89 e5             	mov    %rsp,%rbp
  802ca0:	48 83 ec 18          	sub    $0x18,%rsp
  802ca4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ca7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802caa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb1:	48 89 d6             	mov    %rdx,%rsi
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
  802cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc9:	79 05                	jns    802cd0 <seek+0x34>
		return r;
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	eb 0f                	jmp    802cdf <seek+0x43>
	fd->fd_offset = offset;
  802cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cdf:	c9                   	leaveq 
  802ce0:	c3                   	retq   

0000000000802ce1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ce1:	55                   	push   %rbp
  802ce2:	48 89 e5             	mov    %rsp,%rbp
  802ce5:	48 83 ec 30          	sub    $0x30,%rsp
  802ce9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cec:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cf3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf6:	48 89 d6             	mov    %rdx,%rsi
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
  802d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0e:	78 24                	js     802d34 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d14:	8b 00                	mov    (%rax),%eax
  802d16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d1a:	48 89 d6             	mov    %rdx,%rsi
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 a3 27 80 00 00 	movabs $0x8027a3,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d32:	79 05                	jns    802d39 <ftruncate+0x58>
		return r;
  802d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d37:	eb 72                	jmp    802dab <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3d:	8b 40 08             	mov    0x8(%rax),%eax
  802d40:	83 e0 03             	and    $0x3,%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	75 3a                	jne    802d81 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d47:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802d4e:	00 00 00 
  802d51:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d5d:	89 c6                	mov    %eax,%esi
  802d5f:	48 bf f0 5c 80 00 00 	movabs $0x805cf0,%rdi
  802d66:	00 00 00 
  802d69:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6e:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802d75:	00 00 00 
  802d78:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d7f:	eb 2a                	jmp    802dab <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d85:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d89:	48 85 c0             	test   %rax,%rax
  802d8c:	75 07                	jne    802d95 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d93:	eb 16                	jmp    802dab <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d99:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802da1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802da4:	89 ce                	mov    %ecx,%esi
  802da6:	48 89 d7             	mov    %rdx,%rdi
  802da9:	ff d0                	callq  *%rax
}
  802dab:	c9                   	leaveq 
  802dac:	c3                   	retq   

0000000000802dad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802dad:	55                   	push   %rbp
  802dae:	48 89 e5             	mov    %rsp,%rbp
  802db1:	48 83 ec 30          	sub    $0x30,%rsp
  802db5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802db8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dc3:	48 89 d6             	mov    %rdx,%rsi
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
  802dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddb:	78 24                	js     802e01 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ddd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de1:	8b 00                	mov    (%rax),%eax
  802de3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802de7:	48 89 d6             	mov    %rdx,%rsi
  802dea:	89 c7                	mov    %eax,%edi
  802dec:	48 b8 a3 27 80 00 00 	movabs $0x8027a3,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
  802df8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dff:	79 05                	jns    802e06 <fstat+0x59>
		return r;
  802e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e04:	eb 5e                	jmp    802e64 <fstat+0xb7>
	if (!dev->dev_stat)
  802e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e0e:	48 85 c0             	test   %rax,%rax
  802e11:	75 07                	jne    802e1a <fstat+0x6d>
		return -E_NOT_SUPP;
  802e13:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e18:	eb 4a                	jmp    802e64 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e1e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e25:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e2c:	00 00 00 
	stat->st_isdir = 0;
  802e2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e33:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e3a:	00 00 00 
	stat->st_dev = dev;
  802e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e45:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e50:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e58:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e5c:	48 89 ce             	mov    %rcx,%rsi
  802e5f:	48 89 d7             	mov    %rdx,%rdi
  802e62:	ff d0                	callq  *%rax
}
  802e64:	c9                   	leaveq 
  802e65:	c3                   	retq   

0000000000802e66 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e66:	55                   	push   %rbp
  802e67:	48 89 e5             	mov    %rsp,%rbp
  802e6a:	48 83 ec 20          	sub    $0x20,%rsp
  802e6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7a:	be 00 00 00 00       	mov    $0x0,%esi
  802e7f:	48 89 c7             	mov    %rax,%rdi
  802e82:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	callq  *%rax
  802e8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e95:	79 05                	jns    802e9c <stat+0x36>
		return fd;
  802e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9a:	eb 2f                	jmp    802ecb <stat+0x65>
	r = fstat(fd, stat);
  802e9c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea3:	48 89 d6             	mov    %rdx,%rsi
  802ea6:	89 c7                	mov    %eax,%edi
  802ea8:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
  802eb4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eba:	89 c7                	mov    %eax,%edi
  802ebc:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
	return r;
  802ec8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ecb:	c9                   	leaveq 
  802ecc:	c3                   	retq   

0000000000802ecd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ecd:	55                   	push   %rbp
  802ece:	48 89 e5             	mov    %rsp,%rbp
  802ed1:	48 83 ec 10          	sub    $0x10,%rsp
  802ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ed8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802edc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ee3:	00 00 00 
  802ee6:	8b 00                	mov    (%rax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	75 1f                	jne    802f0b <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802eec:	bf 01 00 00 00       	mov    $0x1,%edi
  802ef1:	48 b8 91 54 80 00 00 	movabs $0x805491,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
  802efd:	89 c2                	mov    %eax,%edx
  802eff:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f06:	00 00 00 
  802f09:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f0b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f12:	00 00 00 
  802f15:	8b 00                	mov    (%rax),%eax
  802f17:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f1a:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f1f:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802f26:	00 00 00 
  802f29:	89 c7                	mov    %eax,%edi
  802f2b:	48 b8 fc 53 80 00 00 	movabs $0x8053fc,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802f40:	48 89 c6             	mov    %rax,%rsi
  802f43:	bf 00 00 00 00       	mov    $0x0,%edi
  802f48:	48 b8 3b 53 80 00 00 	movabs $0x80533b,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
}
  802f54:	c9                   	leaveq 
  802f55:	c3                   	retq   

0000000000802f56 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f56:	55                   	push   %rbp
  802f57:	48 89 e5             	mov    %rsp,%rbp
  802f5a:	48 83 ec 20          	sub    $0x20,%rsp
  802f5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f62:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f69:	48 89 c7             	mov    %rax,%rdi
  802f6c:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	callq  *%rax
  802f78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f7d:	7e 0a                	jle    802f89 <open+0x33>
		return -E_BAD_PATH;
  802f7f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f84:	e9 a5 00 00 00       	jmpq   80302e <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802f89:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f8d:	48 89 c7             	mov    %rax,%rdi
  802f90:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
  802f9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa3:	79 08                	jns    802fad <open+0x57>
		return r;
  802fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa8:	e9 81 00 00 00       	jmpq   80302e <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb1:	48 89 c6             	mov    %rax,%rsi
  802fb4:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802fbb:	00 00 00 
  802fbe:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802fca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fd1:	00 00 00 
  802fd4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fd7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe1:	48 89 c6             	mov    %rax,%rsi
  802fe4:	bf 01 00 00 00       	mov    $0x1,%edi
  802fe9:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
  802ff5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffc:	79 1d                	jns    80301b <open+0xc5>
		fd_close(fd, 0);
  802ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803002:	be 00 00 00 00       	mov    $0x0,%esi
  803007:	48 89 c7             	mov    %rax,%rdi
  80300a:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
		return r;
  803016:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803019:	eb 13                	jmp    80302e <open+0xd8>
	}

	return fd2num(fd);
  80301b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301f:	48 89 c7             	mov    %rax,%rdi
  803022:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax

}
  80302e:	c9                   	leaveq 
  80302f:	c3                   	retq   

0000000000803030 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803030:	55                   	push   %rbp
  803031:	48 89 e5             	mov    %rsp,%rbp
  803034:	48 83 ec 10          	sub    $0x10,%rsp
  803038:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80303c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803040:	8b 50 0c             	mov    0xc(%rax),%edx
  803043:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80304a:	00 00 00 
  80304d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80304f:	be 00 00 00 00       	mov    $0x0,%esi
  803054:	bf 06 00 00 00       	mov    $0x6,%edi
  803059:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 30          	sub    $0x30,%rsp
  80306f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803073:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803077:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80307b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307f:	8b 50 0c             	mov    0xc(%rax),%edx
  803082:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803089:	00 00 00 
  80308c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80308e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803095:	00 00 00 
  803098:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80309c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8030a0:	be 00 00 00 00       	mov    $0x0,%esi
  8030a5:	bf 03 00 00 00       	mov    $0x3,%edi
  8030aa:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
  8030b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bd:	79 08                	jns    8030c7 <devfile_read+0x60>
		return r;
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	e9 a4 00 00 00       	jmpq   80316b <devfile_read+0x104>
	assert(r <= n);
  8030c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ca:	48 98                	cltq   
  8030cc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030d0:	76 35                	jbe    803107 <devfile_read+0xa0>
  8030d2:	48 b9 16 5d 80 00 00 	movabs $0x805d16,%rcx
  8030d9:	00 00 00 
  8030dc:	48 ba 1d 5d 80 00 00 	movabs $0x805d1d,%rdx
  8030e3:	00 00 00 
  8030e6:	be 86 00 00 00       	mov    $0x86,%esi
  8030eb:	48 bf 32 5d 80 00 00 	movabs $0x805d32,%rdi
  8030f2:	00 00 00 
  8030f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fa:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803101:	00 00 00 
  803104:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803107:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80310e:	7e 35                	jle    803145 <devfile_read+0xde>
  803110:	48 b9 3d 5d 80 00 00 	movabs $0x805d3d,%rcx
  803117:	00 00 00 
  80311a:	48 ba 1d 5d 80 00 00 	movabs $0x805d1d,%rdx
  803121:	00 00 00 
  803124:	be 87 00 00 00       	mov    $0x87,%esi
  803129:	48 bf 32 5d 80 00 00 	movabs $0x805d32,%rdi
  803130:	00 00 00 
  803133:	b8 00 00 00 00       	mov    $0x0,%eax
  803138:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80313f:	00 00 00 
  803142:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803145:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803148:	48 63 d0             	movslq %eax,%rdx
  80314b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803156:	00 00 00 
  803159:	48 89 c7             	mov    %rax,%rdi
  80315c:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
	return r;
  803168:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80316b:	c9                   	leaveq 
  80316c:	c3                   	retq   

000000000080316d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80316d:	55                   	push   %rbp
  80316e:	48 89 e5             	mov    %rsp,%rbp
  803171:	48 83 ec 40          	sub    $0x40,%rsp
  803175:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803179:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80317d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803181:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803185:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803189:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803190:	00 
  803191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803195:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803199:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80319e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031b0:	00 00 00 
  8031b3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8031b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bc:	00 00 00 
  8031bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031c3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8031c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031cf:	48 89 c6             	mov    %rax,%rsi
  8031d2:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  8031d9:	00 00 00 
  8031dc:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8031e8:	be 00 00 00 00       	mov    $0x0,%esi
  8031ed:	bf 04 00 00 00       	mov    $0x4,%edi
  8031f2:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
  8031fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803201:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803205:	79 05                	jns    80320c <devfile_write+0x9f>
		return r;
  803207:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320a:	eb 43                	jmp    80324f <devfile_write+0xe2>
	assert(r <= n);
  80320c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320f:	48 98                	cltq   
  803211:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803215:	76 35                	jbe    80324c <devfile_write+0xdf>
  803217:	48 b9 16 5d 80 00 00 	movabs $0x805d16,%rcx
  80321e:	00 00 00 
  803221:	48 ba 1d 5d 80 00 00 	movabs $0x805d1d,%rdx
  803228:	00 00 00 
  80322b:	be a2 00 00 00       	mov    $0xa2,%esi
  803230:	48 bf 32 5d 80 00 00 	movabs $0x805d32,%rdi
  803237:	00 00 00 
  80323a:	b8 00 00 00 00       	mov    $0x0,%eax
  80323f:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803246:	00 00 00 
  803249:	41 ff d0             	callq  *%r8
	return r;
  80324c:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80324f:	c9                   	leaveq 
  803250:	c3                   	retq   

0000000000803251 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803251:	55                   	push   %rbp
  803252:	48 89 e5             	mov    %rsp,%rbp
  803255:	48 83 ec 20          	sub    $0x20,%rsp
  803259:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80325d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803265:	8b 50 0c             	mov    0xc(%rax),%edx
  803268:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80326f:	00 00 00 
  803272:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803274:	be 00 00 00 00       	mov    $0x0,%esi
  803279:	bf 05 00 00 00       	mov    $0x5,%edi
  80327e:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  803285:	00 00 00 
  803288:	ff d0                	callq  *%rax
  80328a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803291:	79 05                	jns    803298 <devfile_stat+0x47>
		return r;
  803293:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803296:	eb 56                	jmp    8032ee <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803298:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329c:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8032a3:	00 00 00 
  8032a6:	48 89 c7             	mov    %rax,%rdi
  8032a9:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032bc:	00 00 00 
  8032bf:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d6:	00 00 00 
  8032d9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8032e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ee:	c9                   	leaveq 
  8032ef:	c3                   	retq   

00000000008032f0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8032f0:	55                   	push   %rbp
  8032f1:	48 89 e5             	mov    %rsp,%rbp
  8032f4:	48 83 ec 10          	sub    $0x10,%rsp
  8032f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032fc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8032ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803303:	8b 50 0c             	mov    0xc(%rax),%edx
  803306:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80330d:	00 00 00 
  803310:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803312:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803319:	00 00 00 
  80331c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803322:	be 00 00 00 00       	mov    $0x0,%esi
  803327:	bf 02 00 00 00       	mov    $0x2,%edi
  80332c:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  803333:	00 00 00 
  803336:	ff d0                	callq  *%rax
}
  803338:	c9                   	leaveq 
  803339:	c3                   	retq   

000000000080333a <remove>:

// Delete a file
int
remove(const char *path)
{
  80333a:	55                   	push   %rbp
  80333b:	48 89 e5             	mov    %rsp,%rbp
  80333e:	48 83 ec 10          	sub    $0x10,%rsp
  803342:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334a:	48 89 c7             	mov    %rax,%rdi
  80334d:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80335e:	7e 07                	jle    803367 <remove+0x2d>
		return -E_BAD_PATH;
  803360:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803365:	eb 33                	jmp    80339a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336b:	48 89 c6             	mov    %rax,%rsi
  80336e:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803375:	00 00 00 
  803378:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  80337f:	00 00 00 
  803382:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803384:	be 00 00 00 00       	mov    $0x0,%esi
  803389:	bf 07 00 00 00       	mov    $0x7,%edi
  80338e:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  803395:	00 00 00 
  803398:	ff d0                	callq  *%rax
}
  80339a:	c9                   	leaveq 
  80339b:	c3                   	retq   

000000000080339c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80339c:	55                   	push   %rbp
  80339d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033a0:	be 00 00 00 00       	mov    $0x0,%esi
  8033a5:	bf 08 00 00 00       	mov    $0x8,%edi
  8033aa:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
}
  8033b6:	5d                   	pop    %rbp
  8033b7:	c3                   	retq   

00000000008033b8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8033b8:	55                   	push   %rbp
  8033b9:	48 89 e5             	mov    %rsp,%rbp
  8033bc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8033c3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8033ca:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8033d1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8033d8:	be 00 00 00 00       	mov    $0x0,%esi
  8033dd:	48 89 c7             	mov    %rax,%rdi
  8033e0:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  8033e7:	00 00 00 
  8033ea:	ff d0                	callq  *%rax
  8033ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8033ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f3:	79 28                	jns    80341d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8033f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f8:	89 c6                	mov    %eax,%esi
  8033fa:	48 bf 49 5d 80 00 00 	movabs $0x805d49,%rdi
  803401:	00 00 00 
  803404:	b8 00 00 00 00       	mov    $0x0,%eax
  803409:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  803410:	00 00 00 
  803413:	ff d2                	callq  *%rdx
		return fd_src;
  803415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803418:	e9 76 01 00 00       	jmpq   803593 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80341d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803424:	be 01 01 00 00       	mov    $0x101,%esi
  803429:	48 89 c7             	mov    %rax,%rdi
  80342c:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
  803438:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80343b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80343f:	0f 89 ad 00 00 00    	jns    8034f2 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803445:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803448:	89 c6                	mov    %eax,%esi
  80344a:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  803451:	00 00 00 
  803454:	b8 00 00 00 00       	mov    $0x0,%eax
  803459:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  803460:	00 00 00 
  803463:	ff d2                	callq  *%rdx
		close(fd_src);
  803465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803468:	89 c7                	mov    %eax,%edi
  80346a:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803471:	00 00 00 
  803474:	ff d0                	callq  *%rax
		return fd_dest;
  803476:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803479:	e9 15 01 00 00       	jmpq   803593 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80347e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803481:	48 63 d0             	movslq %eax,%rdx
  803484:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80348b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80348e:	48 89 ce             	mov    %rcx,%rsi
  803491:	89 c7                	mov    %eax,%edi
  803493:	48 b8 c8 2b 80 00 00 	movabs $0x802bc8,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
  80349f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8034a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034a6:	79 4a                	jns    8034f2 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8034a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034ab:	89 c6                	mov    %eax,%esi
  8034ad:	48 bf 79 5d 80 00 00 	movabs $0x805d79,%rdi
  8034b4:	00 00 00 
  8034b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034bc:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  8034c3:	00 00 00 
  8034c6:	ff d2                	callq  *%rdx
			close(fd_src);
  8034c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
			close(fd_dest);
  8034d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034dc:	89 c7                	mov    %eax,%edi
  8034de:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  8034e5:	00 00 00 
  8034e8:	ff d0                	callq  *%rax
			return write_size;
  8034ea:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034ed:	e9 a1 00 00 00       	jmpq   803593 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8034f2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fc:	ba 00 02 00 00       	mov    $0x200,%edx
  803501:	48 89 ce             	mov    %rcx,%rsi
  803504:	89 c7                	mov    %eax,%edi
  803506:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803515:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803519:	0f 8f 5f ff ff ff    	jg     80347e <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80351f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803523:	79 47                	jns    80356c <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803525:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803528:	89 c6                	mov    %eax,%esi
  80352a:	48 bf 8c 5d 80 00 00 	movabs $0x805d8c,%rdi
  803531:	00 00 00 
  803534:	b8 00 00 00 00       	mov    $0x0,%eax
  803539:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  803540:	00 00 00 
  803543:	ff d2                	callq  *%rdx
		close(fd_src);
  803545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803548:	89 c7                	mov    %eax,%edi
  80354a:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
		close(fd_dest);
  803556:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803559:	89 c7                	mov    %eax,%edi
  80355b:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
		return read_size;
  803567:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80356a:	eb 27                	jmp    803593 <copy+0x1db>
	}
	close(fd_src);
  80356c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356f:	89 c7                	mov    %eax,%edi
  803571:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
	close(fd_dest);
  80357d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803580:	89 c7                	mov    %eax,%edi
  803582:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
	return 0;
  80358e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803593:	c9                   	leaveq 
  803594:	c3                   	retq   

0000000000803595 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803595:	55                   	push   %rbp
  803596:	48 89 e5             	mov    %rsp,%rbp
  803599:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  8035a0:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8035a7:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8035ae:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8035b5:	be 00 00 00 00       	mov    $0x0,%esi
  8035ba:	48 89 c7             	mov    %rax,%rdi
  8035bd:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  8035c4:	00 00 00 
  8035c7:	ff d0                	callq  *%rax
  8035c9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035d0:	79 08                	jns    8035da <spawn+0x45>
		return r;
  8035d2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035d5:	e9 11 03 00 00       	jmpq   8038eb <spawn+0x356>
	fd = r;
  8035da:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035dd:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8035e0:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8035e7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8035eb:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8035f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8035f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8035fa:	48 89 ce             	mov    %rcx,%rsi
  8035fd:	89 c7                	mov    %eax,%edi
  8035ff:	48 b8 52 2b 80 00 00 	movabs $0x802b52,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
  80360b:	3d 00 02 00 00       	cmp    $0x200,%eax
  803610:	75 0d                	jne    80361f <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803616:	8b 00                	mov    (%rax),%eax
  803618:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80361d:	74 43                	je     803662 <spawn+0xcd>
		close(fd);
  80361f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803622:	89 c7                	mov    %eax,%edi
  803624:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  80362b:	00 00 00 
  80362e:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803634:	8b 00                	mov    (%rax),%eax
  803636:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80363b:	89 c6                	mov    %eax,%esi
  80363d:	48 bf a8 5d 80 00 00 	movabs $0x805da8,%rdi
  803644:	00 00 00 
  803647:	b8 00 00 00 00       	mov    $0x0,%eax
  80364c:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  803653:	00 00 00 
  803656:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803658:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80365d:	e9 89 02 00 00       	jmpq   8038eb <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803662:	b8 07 00 00 00       	mov    $0x7,%eax
  803667:	cd 30                	int    $0x30
  803669:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80366c:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80366f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803672:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803676:	79 08                	jns    803680 <spawn+0xeb>
		return r;
  803678:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80367b:	e9 6b 02 00 00       	jmpq   8038eb <spawn+0x356>
	child = r;
  803680:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803683:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803686:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803689:	25 ff 03 00 00       	and    $0x3ff,%eax
  80368e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803695:	00 00 00 
  803698:	48 98                	cltq   
  80369a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8036a1:	48 01 c2             	add    %rax,%rdx
  8036a4:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8036ab:	48 89 d6             	mov    %rdx,%rsi
  8036ae:	ba 18 00 00 00       	mov    $0x18,%edx
  8036b3:	48 89 c7             	mov    %rax,%rdi
  8036b6:	48 89 d1             	mov    %rdx,%rcx
  8036b9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8036bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8036c4:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8036cb:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8036d2:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8036d9:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8036e0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036e3:	48 89 ce             	mov    %rcx,%rsi
  8036e6:	89 c7                	mov    %eax,%edi
  8036e8:	48 b8 4f 3b 80 00 00 	movabs $0x803b4f,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
  8036f4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8036f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8036fb:	79 08                	jns    803705 <spawn+0x170>
		return r;
  8036fd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803700:	e9 e6 01 00 00       	jmpq   8038eb <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803709:	48 8b 40 20          	mov    0x20(%rax),%rax
  80370d:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803714:	48 01 d0             	add    %rdx,%rax
  803717:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80371b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803722:	e9 80 00 00 00       	jmpq   8037a7 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  803727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372b:	8b 00                	mov    (%rax),%eax
  80372d:	83 f8 01             	cmp    $0x1,%eax
  803730:	75 6b                	jne    80379d <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  803732:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373d:	8b 40 04             	mov    0x4(%rax),%eax
  803740:	83 e0 02             	and    $0x2,%eax
  803743:	85 c0                	test   %eax,%eax
  803745:	74 04                	je     80374b <spawn+0x1b6>
			perm |= PTE_W;
  803747:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80374b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803753:	41 89 c1             	mov    %eax,%r9d
  803756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375a:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80375e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803762:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80376a:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80376e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803771:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803774:	48 83 ec 08          	sub    $0x8,%rsp
  803778:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80377b:	57                   	push   %rdi
  80377c:	89 c7                	mov    %eax,%edi
  80377e:	48 b8 fb 3d 80 00 00 	movabs $0x803dfb,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
  80378a:	48 83 c4 10          	add    $0x10,%rsp
  80378e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803791:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803795:	0f 88 2a 01 00 00    	js     8038c5 <spawn+0x330>
  80379b:	eb 01                	jmp    80379e <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  80379d:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80379e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8037a2:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8037a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ab:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8037af:	0f b7 c0             	movzwl %ax,%eax
  8037b2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8037b5:	0f 8f 6c ff ff ff    	jg     803727 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8037bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8037be:	89 c7                	mov    %eax,%edi
  8037c0:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
	fd = -1;
  8037cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8037d3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037d6:	89 c7                	mov    %eax,%edi
  8037d8:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
  8037e4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8037e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8037eb:	79 30                	jns    80381d <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  8037ed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037f0:	89 c1                	mov    %eax,%ecx
  8037f2:	48 ba c2 5d 80 00 00 	movabs $0x805dc2,%rdx
  8037f9:	00 00 00 
  8037fc:	be 86 00 00 00       	mov    $0x86,%esi
  803801:	48 bf d8 5d 80 00 00 	movabs $0x805dd8,%rdi
  803808:	00 00 00 
  80380b:	b8 00 00 00 00       	mov    $0x0,%eax
  803810:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803817:	00 00 00 
  80381a:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80381d:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803824:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803827:	48 89 d6             	mov    %rdx,%rsi
  80382a:	89 c7                	mov    %eax,%edi
  80382c:	48 b8 9d 1b 80 00 00 	movabs $0x801b9d,%rax
  803833:	00 00 00 
  803836:	ff d0                	callq  *%rax
  803838:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80383b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80383f:	79 30                	jns    803871 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  803841:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803844:	89 c1                	mov    %eax,%ecx
  803846:	48 ba e4 5d 80 00 00 	movabs $0x805de4,%rdx
  80384d:	00 00 00 
  803850:	be 8a 00 00 00       	mov    $0x8a,%esi
  803855:	48 bf d8 5d 80 00 00 	movabs $0x805dd8,%rdi
  80385c:	00 00 00 
  80385f:	b8 00 00 00 00       	mov    $0x0,%eax
  803864:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80386b:	00 00 00 
  80386e:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803871:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803874:	be 02 00 00 00       	mov    $0x2,%esi
  803879:	89 c7                	mov    %eax,%edi
  80387b:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
  803887:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80388a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80388e:	79 30                	jns    8038c0 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  803890:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803893:	89 c1                	mov    %eax,%ecx
  803895:	48 ba fe 5d 80 00 00 	movabs $0x805dfe,%rdx
  80389c:	00 00 00 
  80389f:	be 8d 00 00 00       	mov    $0x8d,%esi
  8038a4:	48 bf d8 5d 80 00 00 	movabs $0x805dd8,%rdi
  8038ab:	00 00 00 
  8038ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b3:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8038ba:	00 00 00 
  8038bd:	41 ff d0             	callq  *%r8

	return child;
  8038c0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038c3:	eb 26                	jmp    8038eb <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8038c5:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8038c6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038c9:	89 c7                	mov    %eax,%edi
  8038cb:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  8038d2:	00 00 00 
  8038d5:	ff d0                	callq  *%rax
	close(fd);
  8038d7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8038da:	89 c7                	mov    %eax,%edi
  8038dc:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
	return r;
  8038e8:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  8038eb:	c9                   	leaveq 
  8038ec:	c3                   	retq   

00000000008038ed <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8038ed:	55                   	push   %rbp
  8038ee:	48 89 e5             	mov    %rsp,%rbp
  8038f1:	41 55                	push   %r13
  8038f3:	41 54                	push   %r12
  8038f5:	53                   	push   %rbx
  8038f6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8038fd:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803904:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  80390b:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803912:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803919:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803920:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803927:	84 c0                	test   %al,%al
  803929:	74 26                	je     803951 <spawnl+0x64>
  80392b:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803932:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803939:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  80393d:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803941:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803945:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803949:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  80394d:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803951:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803958:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80395b:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803962:	00 00 00 
  803965:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80396c:	00 00 00 
  80396f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803973:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80397a:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803981:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803988:	eb 07                	jmp    803991 <spawnl+0xa4>
		argc++;
  80398a:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803991:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803997:	83 f8 30             	cmp    $0x30,%eax
  80399a:	73 23                	jae    8039bf <spawnl+0xd2>
  80399c:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8039a3:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8039a9:	89 d2                	mov    %edx,%edx
  8039ab:	48 01 d0             	add    %rdx,%rax
  8039ae:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8039b4:	83 c2 08             	add    $0x8,%edx
  8039b7:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8039bd:	eb 12                	jmp    8039d1 <spawnl+0xe4>
  8039bf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039c6:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8039ca:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8039d1:	48 8b 00             	mov    (%rax),%rax
  8039d4:	48 85 c0             	test   %rax,%rax
  8039d7:	75 b1                	jne    80398a <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8039d9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8039df:	83 c0 02             	add    $0x2,%eax
  8039e2:	48 89 e2             	mov    %rsp,%rdx
  8039e5:	48 89 d3             	mov    %rdx,%rbx
  8039e8:	48 63 d0             	movslq %eax,%rdx
  8039eb:	48 83 ea 01          	sub    $0x1,%rdx
  8039ef:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8039f6:	48 63 d0             	movslq %eax,%rdx
  8039f9:	49 89 d4             	mov    %rdx,%r12
  8039fc:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803a02:	48 63 d0             	movslq %eax,%rdx
  803a05:	49 89 d2             	mov    %rdx,%r10
  803a08:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803a0e:	48 98                	cltq   
  803a10:	48 c1 e0 03          	shl    $0x3,%rax
  803a14:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803a18:	b8 10 00 00 00       	mov    $0x10,%eax
  803a1d:	48 83 e8 01          	sub    $0x1,%rax
  803a21:	48 01 d0             	add    %rdx,%rax
  803a24:	be 10 00 00 00       	mov    $0x10,%esi
  803a29:	ba 00 00 00 00       	mov    $0x0,%edx
  803a2e:	48 f7 f6             	div    %rsi
  803a31:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803a35:	48 29 c4             	sub    %rax,%rsp
  803a38:	48 89 e0             	mov    %rsp,%rax
  803a3b:	48 83 c0 07          	add    $0x7,%rax
  803a3f:	48 c1 e8 03          	shr    $0x3,%rax
  803a43:	48 c1 e0 03          	shl    $0x3,%rax
  803a47:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803a4e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803a55:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803a5c:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803a5f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803a65:	8d 50 01             	lea    0x1(%rax),%edx
  803a68:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803a6f:	48 63 d2             	movslq %edx,%rdx
  803a72:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803a79:	00 

	va_start(vl, arg0);
  803a7a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803a81:	00 00 00 
  803a84:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803a8b:	00 00 00 
  803a8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a92:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803a99:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803aa0:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803aa7:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803aae:	00 00 00 
  803ab1:	eb 60                	jmp    803b13 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  803ab3:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803ab9:	8d 48 01             	lea    0x1(%rax),%ecx
  803abc:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ac2:	83 f8 30             	cmp    $0x30,%eax
  803ac5:	73 23                	jae    803aea <spawnl+0x1fd>
  803ac7:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  803ace:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803ad4:	89 d2                	mov    %edx,%edx
  803ad6:	48 01 d0             	add    %rdx,%rax
  803ad9:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803adf:	83 c2 08             	add    $0x8,%edx
  803ae2:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803ae8:	eb 12                	jmp    803afc <spawnl+0x20f>
  803aea:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803af1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803af5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803afc:	48 8b 10             	mov    (%rax),%rdx
  803aff:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803b06:	89 c9                	mov    %ecx,%ecx
  803b08:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803b0c:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803b13:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803b19:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  803b1f:	72 92                	jb     803ab3 <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803b21:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b28:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803b2f:	48 89 d6             	mov    %rdx,%rsi
  803b32:	48 89 c7             	mov    %rax,%rdi
  803b35:	48 b8 95 35 80 00 00 	movabs $0x803595,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	48 89 dc             	mov    %rbx,%rsp
}
  803b44:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803b48:	5b                   	pop    %rbx
  803b49:	41 5c                	pop    %r12
  803b4b:	41 5d                	pop    %r13
  803b4d:	5d                   	pop    %rbp
  803b4e:	c3                   	retq   

0000000000803b4f <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803b4f:	55                   	push   %rbp
  803b50:	48 89 e5             	mov    %rsp,%rbp
  803b53:	48 83 ec 50          	sub    $0x50,%rsp
  803b57:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803b5a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803b5e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803b62:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b69:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803b71:	eb 33                	jmp    803ba6 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803b73:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b76:	48 98                	cltq   
  803b78:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b7f:	00 
  803b80:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b84:	48 01 d0             	add    %rdx,%rax
  803b87:	48 8b 00             	mov    (%rax),%rax
  803b8a:	48 89 c7             	mov    %rax,%rdi
  803b8d:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803b94:	00 00 00 
  803b97:	ff d0                	callq  *%rax
  803b99:	83 c0 01             	add    $0x1,%eax
  803b9c:	48 98                	cltq   
  803b9e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803ba2:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803ba6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ba9:	48 98                	cltq   
  803bab:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bb2:	00 
  803bb3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803bb7:	48 01 d0             	add    %rdx,%rax
  803bba:	48 8b 00             	mov    (%rax),%rax
  803bbd:	48 85 c0             	test   %rax,%rax
  803bc0:	75 b1                	jne    803b73 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc6:	48 f7 d8             	neg    %rax
  803bc9:	48 05 00 10 40 00    	add    $0x401000,%rax
  803bcf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803bd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803bdb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bdf:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803be3:	48 89 c2             	mov    %rax,%rdx
  803be6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803be9:	83 c0 01             	add    $0x1,%eax
  803bec:	c1 e0 03             	shl    $0x3,%eax
  803bef:	48 98                	cltq   
  803bf1:	48 f7 d8             	neg    %rax
  803bf4:	48 01 d0             	add    %rdx,%rax
  803bf7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803bfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bff:	48 83 e8 10          	sub    $0x10,%rax
  803c03:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803c09:	77 0a                	ja     803c15 <init_stack+0xc6>
		return -E_NO_MEM;
  803c0b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803c10:	e9 e4 01 00 00       	jmpq   803df9 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803c15:	ba 07 00 00 00       	mov    $0x7,%edx
  803c1a:	be 00 00 40 00       	mov    $0x400000,%esi
  803c1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c24:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
  803c30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c33:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c37:	79 08                	jns    803c41 <init_stack+0xf2>
		return r;
  803c39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c3c:	e9 b8 01 00 00       	jmpq   803df9 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803c41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803c48:	e9 8a 00 00 00       	jmpq   803cd7 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  803c4d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803c50:	48 98                	cltq   
  803c52:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803c59:	00 
  803c5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c5e:	48 01 d0             	add    %rdx,%rax
  803c61:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c66:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c6a:	48 01 ca             	add    %rcx,%rdx
  803c6d:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803c74:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803c77:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803c7a:	48 98                	cltq   
  803c7c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803c83:	00 
  803c84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803c88:	48 01 d0             	add    %rdx,%rax
  803c8b:	48 8b 10             	mov    (%rax),%rdx
  803c8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c92:	48 89 d6             	mov    %rdx,%rsi
  803c95:	48 89 c7             	mov    %rax,%rdi
  803c98:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803ca4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ca7:	48 98                	cltq   
  803ca9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803cb0:	00 
  803cb1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803cb5:	48 01 d0             	add    %rdx,%rax
  803cb8:	48 8b 00             	mov    (%rax),%rax
  803cbb:	48 89 c7             	mov    %rax,%rdi
  803cbe:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803cc5:	00 00 00 
  803cc8:	ff d0                	callq  *%rax
  803cca:	83 c0 01             	add    $0x1,%eax
  803ccd:	48 98                	cltq   
  803ccf:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803cd3:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803cd7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803cda:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803cdd:	0f 8c 6a ff ff ff    	jl     803c4d <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803ce3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ce6:	48 98                	cltq   
  803ce8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803cef:	00 
  803cf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf4:	48 01 d0             	add    %rdx,%rax
  803cf7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803cfe:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803d05:	00 
  803d06:	74 35                	je     803d3d <init_stack+0x1ee>
  803d08:	48 b9 18 5e 80 00 00 	movabs $0x805e18,%rcx
  803d0f:	00 00 00 
  803d12:	48 ba 3e 5e 80 00 00 	movabs $0x805e3e,%rdx
  803d19:	00 00 00 
  803d1c:	be f6 00 00 00       	mov    $0xf6,%esi
  803d21:	48 bf d8 5d 80 00 00 	movabs $0x805dd8,%rdi
  803d28:	00 00 00 
  803d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d30:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803d37:	00 00 00 
  803d3a:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803d3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d41:	48 83 e8 08          	sub    $0x8,%rax
  803d45:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803d4a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803d4e:	48 01 ca             	add    %rcx,%rdx
  803d51:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803d58:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  803d5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d5f:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803d63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d66:	48 98                	cltq   
  803d68:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803d6b:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803d70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d74:	48 01 d0             	add    %rdx,%rax
  803d77:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803d7d:	48 89 c2             	mov    %rax,%rdx
  803d80:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803d84:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803d87:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803d8a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803d90:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803d95:	89 c2                	mov    %eax,%edx
  803d97:	be 00 00 40 00       	mov    $0x400000,%esi
  803d9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803da1:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	callq  *%rax
  803dad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db4:	78 26                	js     803ddc <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803db6:	be 00 00 40 00       	mov    $0x400000,%esi
  803dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc0:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803dc7:	00 00 00 
  803dca:	ff d0                	callq  *%rax
  803dcc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd3:	78 0a                	js     803ddf <init_stack+0x290>
		goto error;

	return 0;
  803dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dda:	eb 1d                	jmp    803df9 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803ddc:	90                   	nop
  803ddd:	eb 01                	jmp    803de0 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803ddf:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803de0:	be 00 00 40 00       	mov    $0x400000,%esi
  803de5:	bf 00 00 00 00       	mov    $0x0,%edi
  803dea:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
	return r;
  803df6:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803df9:	c9                   	leaveq 
  803dfa:	c3                   	retq   

0000000000803dfb <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803dfb:	55                   	push   %rbp
  803dfc:	48 89 e5             	mov    %rsp,%rbp
  803dff:	48 83 ec 50          	sub    $0x50,%rsp
  803e03:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803e06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e0a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803e0e:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803e11:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803e15:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803e19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1d:	25 ff 0f 00 00       	and    $0xfff,%eax
  803e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e29:	74 21                	je     803e4c <map_segment+0x51>
		va -= i;
  803e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2e:	48 98                	cltq   
  803e30:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e37:	48 98                	cltq   
  803e39:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e40:	48 98                	cltq   
  803e42:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e49:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e53:	e9 79 01 00 00       	jmpq   803fd1 <map_segment+0x1d6>
		if (i >= filesz) {
  803e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5b:	48 98                	cltq   
  803e5d:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803e61:	72 3c                	jb     803e9f <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e66:	48 63 d0             	movslq %eax,%rdx
  803e69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e6d:	48 01 d0             	add    %rdx,%rax
  803e70:	48 89 c1             	mov    %rax,%rcx
  803e73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e76:	8b 55 10             	mov    0x10(%rbp),%edx
  803e79:	48 89 ce             	mov    %rcx,%rsi
  803e7c:	89 c7                	mov    %eax,%edi
  803e7e:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803e85:	00 00 00 
  803e88:	ff d0                	callq  *%rax
  803e8a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e8d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e91:	0f 89 33 01 00 00    	jns    803fca <map_segment+0x1cf>
				return r;
  803e97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e9a:	e9 46 01 00 00       	jmpq   803fe5 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803e9f:	ba 07 00 00 00       	mov    $0x7,%edx
  803ea4:	be 00 00 40 00       	mov    $0x400000,%esi
  803ea9:	bf 00 00 00 00       	mov    $0x0,%edi
  803eae:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803eb5:	00 00 00 
  803eb8:	ff d0                	callq  *%rax
  803eba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ebd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ec1:	79 08                	jns    803ecb <map_segment+0xd0>
				return r;
  803ec3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec6:	e9 1a 01 00 00       	jmpq   803fe5 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803ecb:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed1:	01 c2                	add    %eax,%edx
  803ed3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803ed6:	89 d6                	mov    %edx,%esi
  803ed8:	89 c7                	mov    %eax,%edi
  803eda:	48 b8 9c 2c 80 00 00 	movabs $0x802c9c,%rax
  803ee1:	00 00 00 
  803ee4:	ff d0                	callq  *%rax
  803ee6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ee9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803eed:	79 08                	jns    803ef7 <map_segment+0xfc>
				return r;
  803eef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ef2:	e9 ee 00 00 00       	jmpq   803fe5 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803ef7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f01:	48 98                	cltq   
  803f03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803f07:	48 29 c2             	sub    %rax,%rdx
  803f0a:	48 89 d0             	mov    %rdx,%rax
  803f0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803f11:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f14:	48 63 d0             	movslq %eax,%rdx
  803f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f1b:	48 39 c2             	cmp    %rax,%rdx
  803f1e:	48 0f 47 d0          	cmova  %rax,%rdx
  803f22:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803f25:	be 00 00 40 00       	mov    $0x400000,%esi
  803f2a:	89 c7                	mov    %eax,%edi
  803f2c:	48 b8 52 2b 80 00 00 	movabs $0x802b52,%rax
  803f33:	00 00 00 
  803f36:	ff d0                	callq  *%rax
  803f38:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803f3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803f3f:	79 08                	jns    803f49 <map_segment+0x14e>
				return r;
  803f41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f44:	e9 9c 00 00 00       	jmpq   803fe5 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f4c:	48 63 d0             	movslq %eax,%rdx
  803f4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f53:	48 01 d0             	add    %rdx,%rax
  803f56:	48 89 c2             	mov    %rax,%rdx
  803f59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f5c:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803f60:	48 89 d1             	mov    %rdx,%rcx
  803f63:	89 c2                	mov    %eax,%edx
  803f65:	be 00 00 40 00       	mov    $0x400000,%esi
  803f6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6f:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
  803f7b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803f7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803f82:	79 30                	jns    803fb4 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803f84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f87:	89 c1                	mov    %eax,%ecx
  803f89:	48 ba 53 5e 80 00 00 	movabs $0x805e53,%rdx
  803f90:	00 00 00 
  803f93:	be 29 01 00 00       	mov    $0x129,%esi
  803f98:	48 bf d8 5d 80 00 00 	movabs $0x805dd8,%rdi
  803f9f:	00 00 00 
  803fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa7:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803fae:	00 00 00 
  803fb1:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803fb4:	be 00 00 40 00       	mov    $0x400000,%esi
  803fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  803fbe:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803fc5:	00 00 00 
  803fc8:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803fca:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd4:	48 98                	cltq   
  803fd6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fda:	0f 82 78 fe ff ff    	jb     803e58 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fe5:	c9                   	leaveq 
  803fe6:	c3                   	retq   

0000000000803fe7 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	48 83 ec 30          	sub    $0x30,%rsp
  803fef:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803ff2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ff9:	00 
  803ffa:	e9 eb 00 00 00       	jmpq   8040ea <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804003:	48 c1 f8 12          	sar    $0x12,%rax
  804007:	48 89 c2             	mov    %rax,%rdx
  80400a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804011:	01 00 00 
  804014:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804018:	83 e0 01             	and    $0x1,%eax
  80401b:	48 85 c0             	test   %rax,%rax
  80401e:	74 21                	je     804041 <copy_shared_pages+0x5a>
  804020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804024:	48 c1 f8 09          	sar    $0x9,%rax
  804028:	48 89 c2             	mov    %rax,%rdx
  80402b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804032:	01 00 00 
  804035:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804039:	83 e0 01             	and    $0x1,%eax
  80403c:	48 85 c0             	test   %rax,%rax
  80403f:	75 0d                	jne    80404e <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  804041:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  804048:	00 
  804049:	e9 9c 00 00 00       	jmpq   8040ea <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  80404e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804052:	48 05 00 02 00 00    	add    $0x200,%rax
  804058:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  80405c:	eb 7e                	jmp    8040dc <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  80405e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804065:	01 00 00 
  804068:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80406c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804070:	25 01 04 00 00       	and    $0x401,%eax
  804075:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  80407b:	75 5a                	jne    8040d7 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  80407d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804081:	48 c1 e0 0c          	shl    $0xc,%rax
  804085:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  804089:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804090:	01 00 00 
  804093:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804097:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80409b:	25 07 0e 00 00       	and    $0xe07,%eax
  8040a0:	89 c6                	mov    %eax,%esi
  8040a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8040a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ad:	41 89 f0             	mov    %esi,%r8d
  8040b0:	48 89 c6             	mov    %rax,%rsi
  8040b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8040b8:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
  8040c4:	48 98                	cltq   
  8040c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8040ca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040cf:	79 06                	jns    8040d7 <copy_shared_pages+0xf0>
						return r;
  8040d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040d5:	eb 28                	jmp    8040ff <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  8040d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8040e4:	0f 8c 74 ff ff ff    	jl     80405e <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  8040ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ee:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  8040f4:	0f 86 05 ff ff ff    	jbe    803fff <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  8040fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040ff:	c9                   	leaveq 
  804100:	c3                   	retq   

0000000000804101 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  804101:	55                   	push   %rbp
  804102:	48 89 e5             	mov    %rsp,%rbp
  804105:	48 83 ec 20          	sub    $0x20,%rsp
  804109:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80410c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804110:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804113:	48 89 d6             	mov    %rdx,%rsi
  804116:	89 c7                	mov    %eax,%edi
  804118:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  80411f:	00 00 00 
  804122:	ff d0                	callq  *%rax
  804124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80412b:	79 05                	jns    804132 <fd2sockid+0x31>
		return r;
  80412d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804130:	eb 24                	jmp    804156 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  804132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804136:	8b 10                	mov    (%rax),%edx
  804138:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  80413f:	00 00 00 
  804142:	8b 00                	mov    (%rax),%eax
  804144:	39 c2                	cmp    %eax,%edx
  804146:	74 07                	je     80414f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  804148:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80414d:	eb 07                	jmp    804156 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80414f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804153:	8b 40 0c             	mov    0xc(%rax),%eax
}
  804156:	c9                   	leaveq 
  804157:	c3                   	retq   

0000000000804158 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  804158:	55                   	push   %rbp
  804159:	48 89 e5             	mov    %rsp,%rbp
  80415c:	48 83 ec 20          	sub    $0x20,%rsp
  804160:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  804163:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804167:	48 89 c7             	mov    %rax,%rdi
  80416a:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  804171:	00 00 00 
  804174:	ff d0                	callq  *%rax
  804176:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804179:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80417d:	78 26                	js     8041a5 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80417f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804183:	ba 07 04 00 00       	mov    $0x407,%edx
  804188:	48 89 c6             	mov    %rax,%rsi
  80418b:	bf 00 00 00 00       	mov    $0x0,%edi
  804190:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  804197:	00 00 00 
  80419a:	ff d0                	callq  *%rax
  80419c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80419f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041a3:	79 16                	jns    8041bb <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8041a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041a8:	89 c7                	mov    %eax,%edi
  8041aa:	48 b8 67 46 80 00 00 	movabs $0x804667,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
		return r;
  8041b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b9:	eb 3a                	jmp    8041f5 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8041bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041bf:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  8041c6:	00 00 00 
  8041c9:	8b 12                	mov    (%rdx),%edx
  8041cb:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8041cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8041d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041dc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8041df:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8041e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e6:	48 89 c7             	mov    %rax,%rdi
  8041e9:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  8041f0:	00 00 00 
  8041f3:	ff d0                	callq  *%rax
}
  8041f5:	c9                   	leaveq 
  8041f6:	c3                   	retq   

00000000008041f7 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8041f7:	55                   	push   %rbp
  8041f8:	48 89 e5             	mov    %rsp,%rbp
  8041fb:	48 83 ec 30          	sub    $0x30,%rsp
  8041ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804206:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80420a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80420d:	89 c7                	mov    %eax,%edi
  80420f:	48 b8 01 41 80 00 00 	movabs $0x804101,%rax
  804216:	00 00 00 
  804219:	ff d0                	callq  *%rax
  80421b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80421e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804222:	79 05                	jns    804229 <accept+0x32>
		return r;
  804224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804227:	eb 3b                	jmp    804264 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804229:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80422d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804234:	48 89 ce             	mov    %rcx,%rsi
  804237:	89 c7                	mov    %eax,%edi
  804239:	48 b8 44 45 80 00 00 	movabs $0x804544,%rax
  804240:	00 00 00 
  804243:	ff d0                	callq  *%rax
  804245:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804248:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80424c:	79 05                	jns    804253 <accept+0x5c>
		return r;
  80424e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804251:	eb 11                	jmp    804264 <accept+0x6d>
	return alloc_sockfd(r);
  804253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804256:	89 c7                	mov    %eax,%edi
  804258:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
}
  804264:	c9                   	leaveq 
  804265:	c3                   	retq   

0000000000804266 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804266:	55                   	push   %rbp
  804267:	48 89 e5             	mov    %rsp,%rbp
  80426a:	48 83 ec 20          	sub    $0x20,%rsp
  80426e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804271:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804275:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804278:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80427b:	89 c7                	mov    %eax,%edi
  80427d:	48 b8 01 41 80 00 00 	movabs $0x804101,%rax
  804284:	00 00 00 
  804287:	ff d0                	callq  *%rax
  804289:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80428c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804290:	79 05                	jns    804297 <bind+0x31>
		return r;
  804292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804295:	eb 1b                	jmp    8042b2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804297:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80429a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80429e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a1:	48 89 ce             	mov    %rcx,%rsi
  8042a4:	89 c7                	mov    %eax,%edi
  8042a6:	48 b8 c3 45 80 00 00 	movabs $0x8045c3,%rax
  8042ad:	00 00 00 
  8042b0:	ff d0                	callq  *%rax
}
  8042b2:	c9                   	leaveq 
  8042b3:	c3                   	retq   

00000000008042b4 <shutdown>:

int
shutdown(int s, int how)
{
  8042b4:	55                   	push   %rbp
  8042b5:	48 89 e5             	mov    %rsp,%rbp
  8042b8:	48 83 ec 20          	sub    $0x20,%rsp
  8042bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042bf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8042c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042c5:	89 c7                	mov    %eax,%edi
  8042c7:	48 b8 01 41 80 00 00 	movabs $0x804101,%rax
  8042ce:	00 00 00 
  8042d1:	ff d0                	callq  *%rax
  8042d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042da:	79 05                	jns    8042e1 <shutdown+0x2d>
		return r;
  8042dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042df:	eb 16                	jmp    8042f7 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8042e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8042e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e7:	89 d6                	mov    %edx,%esi
  8042e9:	89 c7                	mov    %eax,%edi
  8042eb:	48 b8 27 46 80 00 00 	movabs $0x804627,%rax
  8042f2:	00 00 00 
  8042f5:	ff d0                	callq  *%rax
}
  8042f7:	c9                   	leaveq 
  8042f8:	c3                   	retq   

00000000008042f9 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8042f9:	55                   	push   %rbp
  8042fa:	48 89 e5             	mov    %rsp,%rbp
  8042fd:	48 83 ec 10          	sub    $0x10,%rsp
  804301:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804309:	48 89 c7             	mov    %rax,%rdi
  80430c:	48 b8 02 55 80 00 00 	movabs $0x805502,%rax
  804313:	00 00 00 
  804316:	ff d0                	callq  *%rax
  804318:	83 f8 01             	cmp    $0x1,%eax
  80431b:	75 17                	jne    804334 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80431d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804321:	8b 40 0c             	mov    0xc(%rax),%eax
  804324:	89 c7                	mov    %eax,%edi
  804326:	48 b8 67 46 80 00 00 	movabs $0x804667,%rax
  80432d:	00 00 00 
  804330:	ff d0                	callq  *%rax
  804332:	eb 05                	jmp    804339 <devsock_close+0x40>
	else
		return 0;
  804334:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804339:	c9                   	leaveq 
  80433a:	c3                   	retq   

000000000080433b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80433b:	55                   	push   %rbp
  80433c:	48 89 e5             	mov    %rsp,%rbp
  80433f:	48 83 ec 20          	sub    $0x20,%rsp
  804343:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80434a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80434d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804350:	89 c7                	mov    %eax,%edi
  804352:	48 b8 01 41 80 00 00 	movabs $0x804101,%rax
  804359:	00 00 00 
  80435c:	ff d0                	callq  *%rax
  80435e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804361:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804365:	79 05                	jns    80436c <connect+0x31>
		return r;
  804367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80436a:	eb 1b                	jmp    804387 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80436c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80436f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804376:	48 89 ce             	mov    %rcx,%rsi
  804379:	89 c7                	mov    %eax,%edi
  80437b:	48 b8 94 46 80 00 00 	movabs $0x804694,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
}
  804387:	c9                   	leaveq 
  804388:	c3                   	retq   

0000000000804389 <listen>:

int
listen(int s, int backlog)
{
  804389:	55                   	push   %rbp
  80438a:	48 89 e5             	mov    %rsp,%rbp
  80438d:	48 83 ec 20          	sub    $0x20,%rsp
  804391:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804394:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804397:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80439a:	89 c7                	mov    %eax,%edi
  80439c:	48 b8 01 41 80 00 00 	movabs $0x804101,%rax
  8043a3:	00 00 00 
  8043a6:	ff d0                	callq  *%rax
  8043a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043af:	79 05                	jns    8043b6 <listen+0x2d>
		return r;
  8043b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b4:	eb 16                	jmp    8043cc <listen+0x43>
	return nsipc_listen(r, backlog);
  8043b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8043b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043bc:	89 d6                	mov    %edx,%esi
  8043be:	89 c7                	mov    %eax,%edi
  8043c0:	48 b8 f8 46 80 00 00 	movabs $0x8046f8,%rax
  8043c7:	00 00 00 
  8043ca:	ff d0                	callq  *%rax
}
  8043cc:	c9                   	leaveq 
  8043cd:	c3                   	retq   

00000000008043ce <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8043ce:	55                   	push   %rbp
  8043cf:	48 89 e5             	mov    %rsp,%rbp
  8043d2:	48 83 ec 20          	sub    $0x20,%rsp
  8043d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8043de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8043e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043e6:	89 c2                	mov    %eax,%edx
  8043e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ec:	8b 40 0c             	mov    0xc(%rax),%eax
  8043ef:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8043f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8043f8:	89 c7                	mov    %eax,%edi
  8043fa:	48 b8 38 47 80 00 00 	movabs $0x804738,%rax
  804401:	00 00 00 
  804404:	ff d0                	callq  *%rax
}
  804406:	c9                   	leaveq 
  804407:	c3                   	retq   

0000000000804408 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804408:	55                   	push   %rbp
  804409:	48 89 e5             	mov    %rsp,%rbp
  80440c:	48 83 ec 20          	sub    $0x20,%rsp
  804410:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804414:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804418:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80441c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804420:	89 c2                	mov    %eax,%edx
  804422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804426:	8b 40 0c             	mov    0xc(%rax),%eax
  804429:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80442d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804432:	89 c7                	mov    %eax,%edi
  804434:	48 b8 04 48 80 00 00 	movabs $0x804804,%rax
  80443b:	00 00 00 
  80443e:	ff d0                	callq  *%rax
}
  804440:	c9                   	leaveq 
  804441:	c3                   	retq   

0000000000804442 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804442:	55                   	push   %rbp
  804443:	48 89 e5             	mov    %rsp,%rbp
  804446:	48 83 ec 10          	sub    $0x10,%rsp
  80444a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80444e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  804452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804456:	48 be 75 5e 80 00 00 	movabs $0x805e75,%rsi
  80445d:	00 00 00 
  804460:	48 89 c7             	mov    %rax,%rdi
  804463:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  80446a:	00 00 00 
  80446d:	ff d0                	callq  *%rax
	return 0;
  80446f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804474:	c9                   	leaveq 
  804475:	c3                   	retq   

0000000000804476 <socket>:

int
socket(int domain, int type, int protocol)
{
  804476:	55                   	push   %rbp
  804477:	48 89 e5             	mov    %rsp,%rbp
  80447a:	48 83 ec 20          	sub    $0x20,%rsp
  80447e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804481:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804484:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804487:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80448a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80448d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804490:	89 ce                	mov    %ecx,%esi
  804492:	89 c7                	mov    %eax,%edi
  804494:	48 b8 bc 48 80 00 00 	movabs $0x8048bc,%rax
  80449b:	00 00 00 
  80449e:	ff d0                	callq  *%rax
  8044a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044a7:	79 05                	jns    8044ae <socket+0x38>
		return r;
  8044a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ac:	eb 11                	jmp    8044bf <socket+0x49>
	return alloc_sockfd(r);
  8044ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b1:	89 c7                	mov    %eax,%edi
  8044b3:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  8044ba:	00 00 00 
  8044bd:	ff d0                	callq  *%rax
}
  8044bf:	c9                   	leaveq 
  8044c0:	c3                   	retq   

00000000008044c1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8044c1:	55                   	push   %rbp
  8044c2:	48 89 e5             	mov    %rsp,%rbp
  8044c5:	48 83 ec 10          	sub    $0x10,%rsp
  8044c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8044cc:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8044d3:	00 00 00 
  8044d6:	8b 00                	mov    (%rax),%eax
  8044d8:	85 c0                	test   %eax,%eax
  8044da:	75 1f                	jne    8044fb <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8044dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8044e1:	48 b8 91 54 80 00 00 	movabs $0x805491,%rax
  8044e8:	00 00 00 
  8044eb:	ff d0                	callq  *%rax
  8044ed:	89 c2                	mov    %eax,%edx
  8044ef:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8044f6:	00 00 00 
  8044f9:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8044fb:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804502:	00 00 00 
  804505:	8b 00                	mov    (%rax),%eax
  804507:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80450a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80450f:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804516:	00 00 00 
  804519:	89 c7                	mov    %eax,%edi
  80451b:	48 b8 fc 53 80 00 00 	movabs $0x8053fc,%rax
  804522:	00 00 00 
  804525:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804527:	ba 00 00 00 00       	mov    $0x0,%edx
  80452c:	be 00 00 00 00       	mov    $0x0,%esi
  804531:	bf 00 00 00 00       	mov    $0x0,%edi
  804536:	48 b8 3b 53 80 00 00 	movabs $0x80533b,%rax
  80453d:	00 00 00 
  804540:	ff d0                	callq  *%rax
}
  804542:	c9                   	leaveq 
  804543:	c3                   	retq   

0000000000804544 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804544:	55                   	push   %rbp
  804545:	48 89 e5             	mov    %rsp,%rbp
  804548:	48 83 ec 30          	sub    $0x30,%rsp
  80454c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80454f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804553:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804557:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80455e:	00 00 00 
  804561:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804564:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804566:	bf 01 00 00 00       	mov    $0x1,%edi
  80456b:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  804572:	00 00 00 
  804575:	ff d0                	callq  *%rax
  804577:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80457a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80457e:	78 3e                	js     8045be <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804580:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804587:	00 00 00 
  80458a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80458e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804592:	8b 40 10             	mov    0x10(%rax),%eax
  804595:	89 c2                	mov    %eax,%edx
  804597:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80459b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80459f:	48 89 ce             	mov    %rcx,%rsi
  8045a2:	48 89 c7             	mov    %rax,%rdi
  8045a5:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8045ac:	00 00 00 
  8045af:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8045b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b5:	8b 50 10             	mov    0x10(%rax),%edx
  8045b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045bc:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8045be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045c1:	c9                   	leaveq 
  8045c2:	c3                   	retq   

00000000008045c3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8045c3:	55                   	push   %rbp
  8045c4:	48 89 e5             	mov    %rsp,%rbp
  8045c7:	48 83 ec 10          	sub    $0x10,%rsp
  8045cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8045d2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8045d5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045dc:	00 00 00 
  8045df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8045e2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8045e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045eb:	48 89 c6             	mov    %rax,%rsi
  8045ee:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8045f5:	00 00 00 
  8045f8:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8045ff:	00 00 00 
  804602:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804604:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80460b:	00 00 00 
  80460e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804611:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804614:	bf 02 00 00 00       	mov    $0x2,%edi
  804619:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  804620:	00 00 00 
  804623:	ff d0                	callq  *%rax
}
  804625:	c9                   	leaveq 
  804626:	c3                   	retq   

0000000000804627 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804627:	55                   	push   %rbp
  804628:	48 89 e5             	mov    %rsp,%rbp
  80462b:	48 83 ec 10          	sub    $0x10,%rsp
  80462f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804632:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804635:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80463c:	00 00 00 
  80463f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804642:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804644:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80464b:	00 00 00 
  80464e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804651:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804654:	bf 03 00 00 00       	mov    $0x3,%edi
  804659:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  804660:	00 00 00 
  804663:	ff d0                	callq  *%rax
}
  804665:	c9                   	leaveq 
  804666:	c3                   	retq   

0000000000804667 <nsipc_close>:

int
nsipc_close(int s)
{
  804667:	55                   	push   %rbp
  804668:	48 89 e5             	mov    %rsp,%rbp
  80466b:	48 83 ec 10          	sub    $0x10,%rsp
  80466f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804672:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804679:	00 00 00 
  80467c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80467f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804681:	bf 04 00 00 00       	mov    $0x4,%edi
  804686:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  80468d:	00 00 00 
  804690:	ff d0                	callq  *%rax
}
  804692:	c9                   	leaveq 
  804693:	c3                   	retq   

0000000000804694 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804694:	55                   	push   %rbp
  804695:	48 89 e5             	mov    %rsp,%rbp
  804698:	48 83 ec 10          	sub    $0x10,%rsp
  80469c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80469f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8046a3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8046a6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046ad:	00 00 00 
  8046b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8046b3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8046b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8046b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046bc:	48 89 c6             	mov    %rax,%rsi
  8046bf:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8046c6:	00 00 00 
  8046c9:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8046d0:	00 00 00 
  8046d3:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8046d5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046dc:	00 00 00 
  8046df:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8046e2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8046e5:	bf 05 00 00 00       	mov    $0x5,%edi
  8046ea:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  8046f1:	00 00 00 
  8046f4:	ff d0                	callq  *%rax
}
  8046f6:	c9                   	leaveq 
  8046f7:	c3                   	retq   

00000000008046f8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8046f8:	55                   	push   %rbp
  8046f9:	48 89 e5             	mov    %rsp,%rbp
  8046fc:	48 83 ec 10          	sub    $0x10,%rsp
  804700:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804703:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804706:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80470d:	00 00 00 
  804710:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804713:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804715:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80471c:	00 00 00 
  80471f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804722:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804725:	bf 06 00 00 00       	mov    $0x6,%edi
  80472a:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  804731:	00 00 00 
  804734:	ff d0                	callq  *%rax
}
  804736:	c9                   	leaveq 
  804737:	c3                   	retq   

0000000000804738 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804738:	55                   	push   %rbp
  804739:	48 89 e5             	mov    %rsp,%rbp
  80473c:	48 83 ec 30          	sub    $0x30,%rsp
  804740:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804743:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804747:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80474a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80474d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804754:	00 00 00 
  804757:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80475a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80475c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804763:	00 00 00 
  804766:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804769:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80476c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804773:	00 00 00 
  804776:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804779:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80477c:	bf 07 00 00 00       	mov    $0x7,%edi
  804781:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  804788:	00 00 00 
  80478b:	ff d0                	callq  *%rax
  80478d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804790:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804794:	78 69                	js     8047ff <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804796:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80479d:	7f 08                	jg     8047a7 <nsipc_recv+0x6f>
  80479f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a2:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8047a5:	7e 35                	jle    8047dc <nsipc_recv+0xa4>
  8047a7:	48 b9 7c 5e 80 00 00 	movabs $0x805e7c,%rcx
  8047ae:	00 00 00 
  8047b1:	48 ba 91 5e 80 00 00 	movabs $0x805e91,%rdx
  8047b8:	00 00 00 
  8047bb:	be 62 00 00 00       	mov    $0x62,%esi
  8047c0:	48 bf a6 5e 80 00 00 	movabs $0x805ea6,%rdi
  8047c7:	00 00 00 
  8047ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8047cf:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8047d6:	00 00 00 
  8047d9:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8047dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047df:	48 63 d0             	movslq %eax,%rdx
  8047e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e6:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  8047ed:	00 00 00 
  8047f0:	48 89 c7             	mov    %rax,%rdi
  8047f3:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8047fa:	00 00 00 
  8047fd:	ff d0                	callq  *%rax
	}

	return r;
  8047ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804802:	c9                   	leaveq 
  804803:	c3                   	retq   

0000000000804804 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804804:	55                   	push   %rbp
  804805:	48 89 e5             	mov    %rsp,%rbp
  804808:	48 83 ec 20          	sub    $0x20,%rsp
  80480c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80480f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804813:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804816:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804819:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804820:	00 00 00 
  804823:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804826:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804828:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80482f:	7e 35                	jle    804866 <nsipc_send+0x62>
  804831:	48 b9 b2 5e 80 00 00 	movabs $0x805eb2,%rcx
  804838:	00 00 00 
  80483b:	48 ba 91 5e 80 00 00 	movabs $0x805e91,%rdx
  804842:	00 00 00 
  804845:	be 6d 00 00 00       	mov    $0x6d,%esi
  80484a:	48 bf a6 5e 80 00 00 	movabs $0x805ea6,%rdi
  804851:	00 00 00 
  804854:	b8 00 00 00 00       	mov    $0x0,%eax
  804859:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  804860:	00 00 00 
  804863:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804866:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804869:	48 63 d0             	movslq %eax,%rdx
  80486c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804870:	48 89 c6             	mov    %rax,%rsi
  804873:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  80487a:	00 00 00 
  80487d:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  804884:	00 00 00 
  804887:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804889:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804890:	00 00 00 
  804893:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804896:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804899:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048a0:	00 00 00 
  8048a3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8048a6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8048a9:	bf 08 00 00 00       	mov    $0x8,%edi
  8048ae:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  8048b5:	00 00 00 
  8048b8:	ff d0                	callq  *%rax
}
  8048ba:	c9                   	leaveq 
  8048bb:	c3                   	retq   

00000000008048bc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8048bc:	55                   	push   %rbp
  8048bd:	48 89 e5             	mov    %rsp,%rbp
  8048c0:	48 83 ec 10          	sub    $0x10,%rsp
  8048c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048c7:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8048ca:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8048cd:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048d4:	00 00 00 
  8048d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8048da:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8048dc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048e3:	00 00 00 
  8048e6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8048e9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8048ec:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048f3:	00 00 00 
  8048f6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8048f9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8048fc:	bf 09 00 00 00       	mov    $0x9,%edi
  804901:	48 b8 c1 44 80 00 00 	movabs $0x8044c1,%rax
  804908:	00 00 00 
  80490b:	ff d0                	callq  *%rax
}
  80490d:	c9                   	leaveq 
  80490e:	c3                   	retq   

000000000080490f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80490f:	55                   	push   %rbp
  804910:	48 89 e5             	mov    %rsp,%rbp
  804913:	53                   	push   %rbx
  804914:	48 83 ec 38          	sub    $0x38,%rsp
  804918:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80491c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804920:	48 89 c7             	mov    %rax,%rdi
  804923:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  80492a:	00 00 00 
  80492d:	ff d0                	callq  *%rax
  80492f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804932:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804936:	0f 88 bf 01 00 00    	js     804afb <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80493c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804940:	ba 07 04 00 00       	mov    $0x407,%edx
  804945:	48 89 c6             	mov    %rax,%rsi
  804948:	bf 00 00 00 00       	mov    $0x0,%edi
  80494d:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  804954:	00 00 00 
  804957:	ff d0                	callq  *%rax
  804959:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80495c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804960:	0f 88 95 01 00 00    	js     804afb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804966:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80496a:	48 89 c7             	mov    %rax,%rdi
  80496d:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  804974:	00 00 00 
  804977:	ff d0                	callq  *%rax
  804979:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80497c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804980:	0f 88 5d 01 00 00    	js     804ae3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804986:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80498a:	ba 07 04 00 00       	mov    $0x407,%edx
  80498f:	48 89 c6             	mov    %rax,%rsi
  804992:	bf 00 00 00 00       	mov    $0x0,%edi
  804997:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  80499e:	00 00 00 
  8049a1:	ff d0                	callq  *%rax
  8049a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8049a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8049aa:	0f 88 33 01 00 00    	js     804ae3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8049b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049b4:	48 89 c7             	mov    %rax,%rdi
  8049b7:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  8049be:	00 00 00 
  8049c1:	ff d0                	callq  *%rax
  8049c3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8049c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8049d0:	48 89 c6             	mov    %rax,%rsi
  8049d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8049d8:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  8049df:	00 00 00 
  8049e2:	ff d0                	callq  *%rax
  8049e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8049e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8049eb:	0f 88 d9 00 00 00    	js     804aca <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8049f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049f5:	48 89 c7             	mov    %rax,%rdi
  8049f8:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  8049ff:	00 00 00 
  804a02:	ff d0                	callq  *%rax
  804a04:	48 89 c2             	mov    %rax,%rdx
  804a07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a0b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804a11:	48 89 d1             	mov    %rdx,%rcx
  804a14:	ba 00 00 00 00       	mov    $0x0,%edx
  804a19:	48 89 c6             	mov    %rax,%rsi
  804a1c:	bf 00 00 00 00       	mov    $0x0,%edi
  804a21:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  804a28:	00 00 00 
  804a2b:	ff d0                	callq  *%rax
  804a2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804a30:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804a34:	78 79                	js     804aaf <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804a36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a3a:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  804a41:	00 00 00 
  804a44:	8b 12                	mov    (%rdx),%edx
  804a46:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804a53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a57:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  804a5e:	00 00 00 
  804a61:	8b 12                	mov    (%rdx),%edx
  804a63:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804a65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a69:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a74:	48 89 c7             	mov    %rax,%rdi
  804a77:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  804a7e:	00 00 00 
  804a81:	ff d0                	callq  *%rax
  804a83:	89 c2                	mov    %eax,%edx
  804a85:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804a89:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804a8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804a8f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804a93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a97:	48 89 c7             	mov    %rax,%rdi
  804a9a:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  804aa1:	00 00 00 
  804aa4:	ff d0                	callq  *%rax
  804aa6:	89 03                	mov    %eax,(%rbx)
	return 0;
  804aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  804aad:	eb 4f                	jmp    804afe <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804aaf:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804ab0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ab4:	48 89 c6             	mov    %rax,%rsi
  804ab7:	bf 00 00 00 00       	mov    $0x0,%edi
  804abc:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804ac3:	00 00 00 
  804ac6:	ff d0                	callq  *%rax
  804ac8:	eb 01                	jmp    804acb <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804aca:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804acb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804acf:	48 89 c6             	mov    %rax,%rsi
  804ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  804ad7:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804ade:	00 00 00 
  804ae1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804ae3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ae7:	48 89 c6             	mov    %rax,%rsi
  804aea:	bf 00 00 00 00       	mov    $0x0,%edi
  804aef:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804af6:	00 00 00 
  804af9:	ff d0                	callq  *%rax
err:
	return r;
  804afb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804afe:	48 83 c4 38          	add    $0x38,%rsp
  804b02:	5b                   	pop    %rbx
  804b03:	5d                   	pop    %rbp
  804b04:	c3                   	retq   

0000000000804b05 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804b05:	55                   	push   %rbp
  804b06:	48 89 e5             	mov    %rsp,%rbp
  804b09:	53                   	push   %rbx
  804b0a:	48 83 ec 28          	sub    $0x28,%rsp
  804b0e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b12:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804b16:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804b1d:	00 00 00 
  804b20:	48 8b 00             	mov    (%rax),%rax
  804b23:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804b29:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804b2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b30:	48 89 c7             	mov    %rax,%rdi
  804b33:	48 b8 02 55 80 00 00 	movabs $0x805502,%rax
  804b3a:	00 00 00 
  804b3d:	ff d0                	callq  *%rax
  804b3f:	89 c3                	mov    %eax,%ebx
  804b41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b45:	48 89 c7             	mov    %rax,%rdi
  804b48:	48 b8 02 55 80 00 00 	movabs $0x805502,%rax
  804b4f:	00 00 00 
  804b52:	ff d0                	callq  *%rax
  804b54:	39 c3                	cmp    %eax,%ebx
  804b56:	0f 94 c0             	sete   %al
  804b59:	0f b6 c0             	movzbl %al,%eax
  804b5c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804b5f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804b66:	00 00 00 
  804b69:	48 8b 00             	mov    (%rax),%rax
  804b6c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804b72:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804b75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b78:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804b7b:	75 05                	jne    804b82 <_pipeisclosed+0x7d>
			return ret;
  804b7d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b80:	eb 4a                	jmp    804bcc <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804b82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b85:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804b88:	74 8c                	je     804b16 <_pipeisclosed+0x11>
  804b8a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804b8e:	75 86                	jne    804b16 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804b90:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804b97:	00 00 00 
  804b9a:	48 8b 00             	mov    (%rax),%rax
  804b9d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804ba3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804ba6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ba9:	89 c6                	mov    %eax,%esi
  804bab:	48 bf c3 5e 80 00 00 	movabs $0x805ec3,%rdi
  804bb2:	00 00 00 
  804bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  804bba:	49 b8 8c 05 80 00 00 	movabs $0x80058c,%r8
  804bc1:	00 00 00 
  804bc4:	41 ff d0             	callq  *%r8
	}
  804bc7:	e9 4a ff ff ff       	jmpq   804b16 <_pipeisclosed+0x11>

}
  804bcc:	48 83 c4 28          	add    $0x28,%rsp
  804bd0:	5b                   	pop    %rbx
  804bd1:	5d                   	pop    %rbp
  804bd2:	c3                   	retq   

0000000000804bd3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804bd3:	55                   	push   %rbp
  804bd4:	48 89 e5             	mov    %rsp,%rbp
  804bd7:	48 83 ec 30          	sub    $0x30,%rsp
  804bdb:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804bde:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804be2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804be5:	48 89 d6             	mov    %rdx,%rsi
  804be8:	89 c7                	mov    %eax,%edi
  804bea:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  804bf1:	00 00 00 
  804bf4:	ff d0                	callq  *%rax
  804bf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804bf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bfd:	79 05                	jns    804c04 <pipeisclosed+0x31>
		return r;
  804bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c02:	eb 31                	jmp    804c35 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804c04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c08:	48 89 c7             	mov    %rax,%rdi
  804c0b:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  804c12:	00 00 00 
  804c15:	ff d0                	callq  *%rax
  804c17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c23:	48 89 d6             	mov    %rdx,%rsi
  804c26:	48 89 c7             	mov    %rax,%rdi
  804c29:	48 b8 05 4b 80 00 00 	movabs $0x804b05,%rax
  804c30:	00 00 00 
  804c33:	ff d0                	callq  *%rax
}
  804c35:	c9                   	leaveq 
  804c36:	c3                   	retq   

0000000000804c37 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804c37:	55                   	push   %rbp
  804c38:	48 89 e5             	mov    %rsp,%rbp
  804c3b:	48 83 ec 40          	sub    $0x40,%rsp
  804c3f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804c43:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804c47:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804c4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c4f:	48 89 c7             	mov    %rax,%rdi
  804c52:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  804c59:	00 00 00 
  804c5c:	ff d0                	callq  *%rax
  804c5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804c62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804c6a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804c71:	00 
  804c72:	e9 90 00 00 00       	jmpq   804d07 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804c77:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804c7c:	74 09                	je     804c87 <devpipe_read+0x50>
				return i;
  804c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c82:	e9 8e 00 00 00       	jmpq   804d15 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804c87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c8f:	48 89 d6             	mov    %rdx,%rsi
  804c92:	48 89 c7             	mov    %rax,%rdi
  804c95:	48 b8 05 4b 80 00 00 	movabs $0x804b05,%rax
  804c9c:	00 00 00 
  804c9f:	ff d0                	callq  *%rax
  804ca1:	85 c0                	test   %eax,%eax
  804ca3:	74 07                	je     804cac <devpipe_read+0x75>
				return 0;
  804ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  804caa:	eb 69                	jmp    804d15 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804cac:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804cb3:	00 00 00 
  804cb6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cbc:	8b 10                	mov    (%rax),%edx
  804cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cc2:	8b 40 04             	mov    0x4(%rax),%eax
  804cc5:	39 c2                	cmp    %eax,%edx
  804cc7:	74 ae                	je     804c77 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804cc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cd1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cd9:	8b 00                	mov    (%rax),%eax
  804cdb:	99                   	cltd   
  804cdc:	c1 ea 1b             	shr    $0x1b,%edx
  804cdf:	01 d0                	add    %edx,%eax
  804ce1:	83 e0 1f             	and    $0x1f,%eax
  804ce4:	29 d0                	sub    %edx,%eax
  804ce6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cea:	48 98                	cltq   
  804cec:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804cf1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cf7:	8b 00                	mov    (%rax),%eax
  804cf9:	8d 50 01             	lea    0x1(%rax),%edx
  804cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d00:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804d02:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804d07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d0b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804d0f:	72 a7                	jb     804cb8 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804d15:	c9                   	leaveq 
  804d16:	c3                   	retq   

0000000000804d17 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804d17:	55                   	push   %rbp
  804d18:	48 89 e5             	mov    %rsp,%rbp
  804d1b:	48 83 ec 40          	sub    $0x40,%rsp
  804d1f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804d23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804d27:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804d2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d2f:	48 89 c7             	mov    %rax,%rdi
  804d32:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  804d39:	00 00 00 
  804d3c:	ff d0                	callq  *%rax
  804d3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804d42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804d46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804d4a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804d51:	00 
  804d52:	e9 8f 00 00 00       	jmpq   804de6 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804d57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d5f:	48 89 d6             	mov    %rdx,%rsi
  804d62:	48 89 c7             	mov    %rax,%rdi
  804d65:	48 b8 05 4b 80 00 00 	movabs $0x804b05,%rax
  804d6c:	00 00 00 
  804d6f:	ff d0                	callq  *%rax
  804d71:	85 c0                	test   %eax,%eax
  804d73:	74 07                	je     804d7c <devpipe_write+0x65>
				return 0;
  804d75:	b8 00 00 00 00       	mov    $0x0,%eax
  804d7a:	eb 78                	jmp    804df4 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804d7c:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804d83:	00 00 00 
  804d86:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d8c:	8b 40 04             	mov    0x4(%rax),%eax
  804d8f:	48 63 d0             	movslq %eax,%rdx
  804d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d96:	8b 00                	mov    (%rax),%eax
  804d98:	48 98                	cltq   
  804d9a:	48 83 c0 20          	add    $0x20,%rax
  804d9e:	48 39 c2             	cmp    %rax,%rdx
  804da1:	73 b4                	jae    804d57 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804da7:	8b 40 04             	mov    0x4(%rax),%eax
  804daa:	99                   	cltd   
  804dab:	c1 ea 1b             	shr    $0x1b,%edx
  804dae:	01 d0                	add    %edx,%eax
  804db0:	83 e0 1f             	and    $0x1f,%eax
  804db3:	29 d0                	sub    %edx,%eax
  804db5:	89 c6                	mov    %eax,%esi
  804db7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dbf:	48 01 d0             	add    %rdx,%rax
  804dc2:	0f b6 08             	movzbl (%rax),%ecx
  804dc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804dc9:	48 63 c6             	movslq %esi,%rax
  804dcc:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dd4:	8b 40 04             	mov    0x4(%rax),%eax
  804dd7:	8d 50 01             	lea    0x1(%rax),%edx
  804dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dde:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804de1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804de6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dea:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804dee:	72 98                	jb     804d88 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804df4:	c9                   	leaveq 
  804df5:	c3                   	retq   

0000000000804df6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804df6:	55                   	push   %rbp
  804df7:	48 89 e5             	mov    %rsp,%rbp
  804dfa:	48 83 ec 20          	sub    $0x20,%rsp
  804dfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804e02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e0a:	48 89 c7             	mov    %rax,%rdi
  804e0d:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  804e14:	00 00 00 
  804e17:	ff d0                	callq  *%rax
  804e19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804e1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e21:	48 be d6 5e 80 00 00 	movabs $0x805ed6,%rsi
  804e28:	00 00 00 
  804e2b:	48 89 c7             	mov    %rax,%rdi
  804e2e:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  804e35:	00 00 00 
  804e38:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e3e:	8b 50 04             	mov    0x4(%rax),%edx
  804e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e45:	8b 00                	mov    (%rax),%eax
  804e47:	29 c2                	sub    %eax,%edx
  804e49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e4d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804e53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e57:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804e5e:	00 00 00 
	stat->st_dev = &devpipe;
  804e61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e65:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804e6c:	00 00 00 
  804e6f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e7b:	c9                   	leaveq 
  804e7c:	c3                   	retq   

0000000000804e7d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804e7d:	55                   	push   %rbp
  804e7e:	48 89 e5             	mov    %rsp,%rbp
  804e81:	48 83 ec 10          	sub    $0x10,%rsp
  804e85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e8d:	48 89 c6             	mov    %rax,%rsi
  804e90:	bf 00 00 00 00       	mov    $0x0,%edi
  804e95:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804e9c:	00 00 00 
  804e9f:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ea5:	48 89 c7             	mov    %rax,%rdi
  804ea8:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  804eaf:	00 00 00 
  804eb2:	ff d0                	callq  *%rax
  804eb4:	48 89 c6             	mov    %rax,%rsi
  804eb7:	bf 00 00 00 00       	mov    $0x0,%edi
  804ebc:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804ec3:	00 00 00 
  804ec6:	ff d0                	callq  *%rax
}
  804ec8:	c9                   	leaveq 
  804ec9:	c3                   	retq   

0000000000804eca <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804eca:	55                   	push   %rbp
  804ecb:	48 89 e5             	mov    %rsp,%rbp
  804ece:	48 83 ec 20          	sub    $0x20,%rsp
  804ed2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804ed5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ed9:	75 35                	jne    804f10 <wait+0x46>
  804edb:	48 b9 dd 5e 80 00 00 	movabs $0x805edd,%rcx
  804ee2:	00 00 00 
  804ee5:	48 ba e8 5e 80 00 00 	movabs $0x805ee8,%rdx
  804eec:	00 00 00 
  804eef:	be 0a 00 00 00       	mov    $0xa,%esi
  804ef4:	48 bf fd 5e 80 00 00 	movabs $0x805efd,%rdi
  804efb:	00 00 00 
  804efe:	b8 00 00 00 00       	mov    $0x0,%eax
  804f03:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  804f0a:	00 00 00 
  804f0d:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804f10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f13:	25 ff 03 00 00       	and    $0x3ff,%eax
  804f18:	48 98                	cltq   
  804f1a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804f21:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804f28:	00 00 00 
  804f2b:	48 01 d0             	add    %rdx,%rax
  804f2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804f32:	eb 0c                	jmp    804f40 <wait+0x76>
		sys_yield();
  804f34:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804f3b:	00 00 00 
  804f3e:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804f4a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804f4d:	75 0e                	jne    804f5d <wait+0x93>
  804f4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f53:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804f59:	85 c0                	test   %eax,%eax
  804f5b:	75 d7                	jne    804f34 <wait+0x6a>
		sys_yield();
}
  804f5d:	90                   	nop
  804f5e:	c9                   	leaveq 
  804f5f:	c3                   	retq   

0000000000804f60 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804f60:	55                   	push   %rbp
  804f61:	48 89 e5             	mov    %rsp,%rbp
  804f64:	48 83 ec 20          	sub    $0x20,%rsp
  804f68:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804f6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f6e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804f71:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804f75:	be 01 00 00 00       	mov    $0x1,%esi
  804f7a:	48 89 c7             	mov    %rax,%rdi
  804f7d:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  804f84:	00 00 00 
  804f87:	ff d0                	callq  *%rax
}
  804f89:	90                   	nop
  804f8a:	c9                   	leaveq 
  804f8b:	c3                   	retq   

0000000000804f8c <getchar>:

int
getchar(void)
{
  804f8c:	55                   	push   %rbp
  804f8d:	48 89 e5             	mov    %rsp,%rbp
  804f90:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804f94:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804f98:	ba 01 00 00 00       	mov    $0x1,%edx
  804f9d:	48 89 c6             	mov    %rax,%rsi
  804fa0:	bf 00 00 00 00       	mov    $0x0,%edi
  804fa5:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  804fac:	00 00 00 
  804faf:	ff d0                	callq  *%rax
  804fb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804fb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fb8:	79 05                	jns    804fbf <getchar+0x33>
		return r;
  804fba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fbd:	eb 14                	jmp    804fd3 <getchar+0x47>
	if (r < 1)
  804fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fc3:	7f 07                	jg     804fcc <getchar+0x40>
		return -E_EOF;
  804fc5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804fca:	eb 07                	jmp    804fd3 <getchar+0x47>
	return c;
  804fcc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804fd0:	0f b6 c0             	movzbl %al,%eax

}
  804fd3:	c9                   	leaveq 
  804fd4:	c3                   	retq   

0000000000804fd5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804fd5:	55                   	push   %rbp
  804fd6:	48 89 e5             	mov    %rsp,%rbp
  804fd9:	48 83 ec 20          	sub    $0x20,%rsp
  804fdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804fe0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fe7:	48 89 d6             	mov    %rdx,%rsi
  804fea:	89 c7                	mov    %eax,%edi
  804fec:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  804ff3:	00 00 00 
  804ff6:	ff d0                	callq  *%rax
  804ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fff:	79 05                	jns    805006 <iscons+0x31>
		return r;
  805001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805004:	eb 1a                	jmp    805020 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  805006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80500a:	8b 10                	mov    (%rax),%edx
  80500c:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  805013:	00 00 00 
  805016:	8b 00                	mov    (%rax),%eax
  805018:	39 c2                	cmp    %eax,%edx
  80501a:	0f 94 c0             	sete   %al
  80501d:	0f b6 c0             	movzbl %al,%eax
}
  805020:	c9                   	leaveq 
  805021:	c3                   	retq   

0000000000805022 <opencons>:

int
opencons(void)
{
  805022:	55                   	push   %rbp
  805023:	48 89 e5             	mov    %rsp,%rbp
  805026:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80502a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80502e:	48 89 c7             	mov    %rax,%rdi
  805031:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  805038:	00 00 00 
  80503b:	ff d0                	callq  *%rax
  80503d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805040:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805044:	79 05                	jns    80504b <opencons+0x29>
		return r;
  805046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805049:	eb 5b                	jmp    8050a6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80504b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80504f:	ba 07 04 00 00       	mov    $0x407,%edx
  805054:	48 89 c6             	mov    %rax,%rsi
  805057:	bf 00 00 00 00       	mov    $0x0,%edi
  80505c:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  805063:	00 00 00 
  805066:	ff d0                	callq  *%rax
  805068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80506b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80506f:	79 05                	jns    805076 <opencons+0x54>
		return r;
  805071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805074:	eb 30                	jmp    8050a6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  805076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80507a:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  805081:	00 00 00 
  805084:	8b 12                	mov    (%rdx),%edx
  805086:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  805088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80508c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  805093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805097:	48 89 c7             	mov    %rax,%rdi
  80509a:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  8050a1:	00 00 00 
  8050a4:	ff d0                	callq  *%rax
}
  8050a6:	c9                   	leaveq 
  8050a7:	c3                   	retq   

00000000008050a8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8050a8:	55                   	push   %rbp
  8050a9:	48 89 e5             	mov    %rsp,%rbp
  8050ac:	48 83 ec 30          	sub    $0x30,%rsp
  8050b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8050b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8050b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8050bc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8050c1:	75 13                	jne    8050d6 <devcons_read+0x2e>
		return 0;
  8050c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8050c8:	eb 49                	jmp    805113 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8050ca:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  8050d1:	00 00 00 
  8050d4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8050d6:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  8050dd:	00 00 00 
  8050e0:	ff d0                	callq  *%rax
  8050e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050e9:	74 df                	je     8050ca <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8050eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050ef:	79 05                	jns    8050f6 <devcons_read+0x4e>
		return c;
  8050f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050f4:	eb 1d                	jmp    805113 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8050f6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8050fa:	75 07                	jne    805103 <devcons_read+0x5b>
		return 0;
  8050fc:	b8 00 00 00 00       	mov    $0x0,%eax
  805101:	eb 10                	jmp    805113 <devcons_read+0x6b>
	*(char*)vbuf = c;
  805103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805106:	89 c2                	mov    %eax,%edx
  805108:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80510c:	88 10                	mov    %dl,(%rax)
	return 1;
  80510e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805113:	c9                   	leaveq 
  805114:	c3                   	retq   

0000000000805115 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805115:	55                   	push   %rbp
  805116:	48 89 e5             	mov    %rsp,%rbp
  805119:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  805120:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  805127:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80512e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  805135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80513c:	eb 76                	jmp    8051b4 <devcons_write+0x9f>
		m = n - tot;
  80513e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  805145:	89 c2                	mov    %eax,%edx
  805147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80514a:	29 c2                	sub    %eax,%edx
  80514c:	89 d0                	mov    %edx,%eax
  80514e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  805151:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805154:	83 f8 7f             	cmp    $0x7f,%eax
  805157:	76 07                	jbe    805160 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  805159:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  805160:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805163:	48 63 d0             	movslq %eax,%rdx
  805166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805169:	48 63 c8             	movslq %eax,%rcx
  80516c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  805173:	48 01 c1             	add    %rax,%rcx
  805176:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80517d:	48 89 ce             	mov    %rcx,%rsi
  805180:	48 89 c7             	mov    %rax,%rdi
  805183:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  80518a:	00 00 00 
  80518d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80518f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805192:	48 63 d0             	movslq %eax,%rdx
  805195:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80519c:	48 89 d6             	mov    %rdx,%rsi
  80519f:	48 89 c7             	mov    %rax,%rdi
  8051a2:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  8051a9:	00 00 00 
  8051ac:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8051ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8051b1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8051b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051b7:	48 98                	cltq   
  8051b9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8051c0:	0f 82 78 ff ff ff    	jb     80513e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8051c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8051c9:	c9                   	leaveq 
  8051ca:	c3                   	retq   

00000000008051cb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8051cb:	55                   	push   %rbp
  8051cc:	48 89 e5             	mov    %rsp,%rbp
  8051cf:	48 83 ec 08          	sub    $0x8,%rsp
  8051d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8051d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051dc:	c9                   	leaveq 
  8051dd:	c3                   	retq   

00000000008051de <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8051de:	55                   	push   %rbp
  8051df:	48 89 e5             	mov    %rsp,%rbp
  8051e2:	48 83 ec 10          	sub    $0x10,%rsp
  8051e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8051ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8051ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051f2:	48 be 0d 5f 80 00 00 	movabs $0x805f0d,%rsi
  8051f9:	00 00 00 
  8051fc:	48 89 c7             	mov    %rax,%rdi
  8051ff:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  805206:	00 00 00 
  805209:	ff d0                	callq  *%rax
	return 0;
  80520b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805210:	c9                   	leaveq 
  805211:	c3                   	retq   

0000000000805212 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805212:	55                   	push   %rbp
  805213:	48 89 e5             	mov    %rsp,%rbp
  805216:	48 83 ec 20          	sub    $0x20,%rsp
  80521a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80521e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805225:	00 00 00 
  805228:	48 8b 00             	mov    (%rax),%rax
  80522b:	48 85 c0             	test   %rax,%rax
  80522e:	75 6f                	jne    80529f <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  805230:	ba 07 00 00 00       	mov    $0x7,%edx
  805235:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80523a:	bf 00 00 00 00       	mov    $0x0,%edi
  80523f:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  805246:	00 00 00 
  805249:	ff d0                	callq  *%rax
  80524b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80524e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805252:	79 30                	jns    805284 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805257:	89 c1                	mov    %eax,%ecx
  805259:	48 ba 18 5f 80 00 00 	movabs $0x805f18,%rdx
  805260:	00 00 00 
  805263:	be 22 00 00 00       	mov    $0x22,%esi
  805268:	48 bf 37 5f 80 00 00 	movabs $0x805f37,%rdi
  80526f:	00 00 00 
  805272:	b8 00 00 00 00       	mov    $0x0,%eax
  805277:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80527e:	00 00 00 
  805281:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  805284:	48 be b3 52 80 00 00 	movabs $0x8052b3,%rsi
  80528b:	00 00 00 
  80528e:	bf 00 00 00 00       	mov    $0x0,%edi
  805293:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  80529a:	00 00 00 
  80529d:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80529f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8052a6:	00 00 00 
  8052a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8052ad:	48 89 10             	mov    %rdx,(%rax)
}
  8052b0:	90                   	nop
  8052b1:	c9                   	leaveq 
  8052b2:	c3                   	retq   

00000000008052b3 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8052b3:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8052b6:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  8052bd:	00 00 00 
call *%rax
  8052c0:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8052c2:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8052c9:	00 08 
    movq 152(%rsp), %rax
  8052cb:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8052d2:	00 
    movq 136(%rsp), %rbx
  8052d3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8052da:	00 
movq %rbx, (%rax)
  8052db:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8052de:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8052e2:	4c 8b 3c 24          	mov    (%rsp),%r15
  8052e6:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8052eb:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8052f0:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8052f5:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8052fa:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8052ff:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805304:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805309:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80530e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805313:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805318:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80531d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805322:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805327:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80532c:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  805330:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805334:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805335:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80533a:	c3                   	retq   

000000000080533b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80533b:	55                   	push   %rbp
  80533c:	48 89 e5             	mov    %rsp,%rbp
  80533f:	48 83 ec 30          	sub    $0x30,%rsp
  805343:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80534b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80534f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805354:	75 0e                	jne    805364 <ipc_recv+0x29>
		pg = (void*) UTOP;
  805356:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80535d:	00 00 00 
  805360:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  805364:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805368:	48 89 c7             	mov    %rax,%rdi
  80536b:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  805372:	00 00 00 
  805375:	ff d0                	callq  *%rax
  805377:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80537a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80537e:	79 27                	jns    8053a7 <ipc_recv+0x6c>
		if (from_env_store)
  805380:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805385:	74 0a                	je     805391 <ipc_recv+0x56>
			*from_env_store = 0;
  805387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80538b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  805391:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805396:	74 0a                	je     8053a2 <ipc_recv+0x67>
			*perm_store = 0;
  805398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80539c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8053a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053a5:	eb 53                	jmp    8053fa <ipc_recv+0xbf>
	}
	if (from_env_store)
  8053a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8053ac:	74 19                	je     8053c7 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8053ae:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8053b5:	00 00 00 
  8053b8:	48 8b 00             	mov    (%rax),%rax
  8053bb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8053c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053c5:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8053c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8053cc:	74 19                	je     8053e7 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8053ce:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8053d5:	00 00 00 
  8053d8:	48 8b 00             	mov    (%rax),%rax
  8053db:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8053e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053e5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8053e7:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8053ee:	00 00 00 
  8053f1:	48 8b 00             	mov    (%rax),%rax
  8053f4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8053fa:	c9                   	leaveq 
  8053fb:	c3                   	retq   

00000000008053fc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8053fc:	55                   	push   %rbp
  8053fd:	48 89 e5             	mov    %rsp,%rbp
  805400:	48 83 ec 30          	sub    $0x30,%rsp
  805404:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805407:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80540a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80540e:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  805411:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805416:	75 1c                	jne    805434 <ipc_send+0x38>
		pg = (void*) UTOP;
  805418:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80541f:	00 00 00 
  805422:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805426:	eb 0c                	jmp    805434 <ipc_send+0x38>
		sys_yield();
  805428:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  80542f:	00 00 00 
  805432:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805434:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805437:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80543a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80543e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805441:	89 c7                	mov    %eax,%edi
  805443:	48 b8 35 1c 80 00 00 	movabs $0x801c35,%rax
  80544a:	00 00 00 
  80544d:	ff d0                	callq  *%rax
  80544f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805452:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805456:	74 d0                	je     805428 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  805458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80545c:	79 30                	jns    80548e <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80545e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805461:	89 c1                	mov    %eax,%ecx
  805463:	48 ba 45 5f 80 00 00 	movabs $0x805f45,%rdx
  80546a:	00 00 00 
  80546d:	be 47 00 00 00       	mov    $0x47,%esi
  805472:	48 bf 5b 5f 80 00 00 	movabs $0x805f5b,%rdi
  805479:	00 00 00 
  80547c:	b8 00 00 00 00       	mov    $0x0,%eax
  805481:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  805488:	00 00 00 
  80548b:	41 ff d0             	callq  *%r8

}
  80548e:	90                   	nop
  80548f:	c9                   	leaveq 
  805490:	c3                   	retq   

0000000000805491 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805491:	55                   	push   %rbp
  805492:	48 89 e5             	mov    %rsp,%rbp
  805495:	48 83 ec 18          	sub    $0x18,%rsp
  805499:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80549c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054a3:	eb 4d                	jmp    8054f2 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8054a5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8054ac:	00 00 00 
  8054af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054b2:	48 98                	cltq   
  8054b4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8054bb:	48 01 d0             	add    %rdx,%rax
  8054be:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8054c4:	8b 00                	mov    (%rax),%eax
  8054c6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8054c9:	75 23                	jne    8054ee <ipc_find_env+0x5d>
			return envs[i].env_id;
  8054cb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8054d2:	00 00 00 
  8054d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054d8:	48 98                	cltq   
  8054da:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8054e1:	48 01 d0             	add    %rdx,%rax
  8054e4:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8054ea:	8b 00                	mov    (%rax),%eax
  8054ec:	eb 12                	jmp    805500 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8054ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8054f2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8054f9:	7e aa                	jle    8054a5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8054fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805500:	c9                   	leaveq 
  805501:	c3                   	retq   

0000000000805502 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  805502:	55                   	push   %rbp
  805503:	48 89 e5             	mov    %rsp,%rbp
  805506:	48 83 ec 18          	sub    $0x18,%rsp
  80550a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80550e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805512:	48 c1 e8 15          	shr    $0x15,%rax
  805516:	48 89 c2             	mov    %rax,%rdx
  805519:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805520:	01 00 00 
  805523:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805527:	83 e0 01             	and    $0x1,%eax
  80552a:	48 85 c0             	test   %rax,%rax
  80552d:	75 07                	jne    805536 <pageref+0x34>
		return 0;
  80552f:	b8 00 00 00 00       	mov    $0x0,%eax
  805534:	eb 56                	jmp    80558c <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  805536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80553a:	48 c1 e8 0c          	shr    $0xc,%rax
  80553e:	48 89 c2             	mov    %rax,%rdx
  805541:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805548:	01 00 00 
  80554b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80554f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805557:	83 e0 01             	and    $0x1,%eax
  80555a:	48 85 c0             	test   %rax,%rax
  80555d:	75 07                	jne    805566 <pageref+0x64>
		return 0;
  80555f:	b8 00 00 00 00       	mov    $0x0,%eax
  805564:	eb 26                	jmp    80558c <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  805566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80556a:	48 c1 e8 0c          	shr    $0xc,%rax
  80556e:	48 89 c2             	mov    %rax,%rdx
  805571:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805578:	00 00 00 
  80557b:	48 c1 e2 04          	shl    $0x4,%rdx
  80557f:	48 01 d0             	add    %rdx,%rax
  805582:	48 83 c0 08          	add    $0x8,%rax
  805586:	0f b7 00             	movzwl (%rax),%eax
  805589:	0f b7 c0             	movzwl %ax,%eax
}
  80558c:	c9                   	leaveq 
  80558d:	c3                   	retq   
