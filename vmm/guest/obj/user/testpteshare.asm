
vmm/guest/obj/user/testpteshare:     file format elf64-x86-64


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
  80008d:	48 ba 3e 56 80 00 00 	movabs $0x80563e,%rdx
  800094:	00 00 00 
  800097:	be 14 00 00 00       	mov    $0x14,%esi
  80009c:	48 bf 51 56 80 00 00 	movabs $0x805651,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 65 56 80 00 00 	movabs $0x805665,%rdx
  8000d9:	00 00 00 
  8000dc:	be 18 00 00 00       	mov    $0x18,%esi
  8000e1:	48 bf 51 56 80 00 00 	movabs $0x805651,%rdi
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
  800135:	48 b8 ce 4d 80 00 00 	movabs $0x804dce,%rax
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
  800166:	48 b8 6e 56 80 00 00 	movabs $0x80566e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 74 56 80 00 00 	movabs $0x805674,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 7a 56 80 00 00 	movabs $0x80567a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 95 56 80 00 00 	movabs $0x805695,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 99 56 80 00 00 	movabs $0x805699,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf a6 56 80 00 00 	movabs $0x8056a6,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 f1 37 80 00 00 	movabs $0x8037f1,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba b8 56 80 00 00 	movabs $0x8056b8,%rdx
  8001e4:	00 00 00 
  8001e7:	be 22 00 00 00       	mov    $0x22,%esi
  8001ec:	48 bf 51 56 80 00 00 	movabs $0x805651,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 ce 4d 80 00 00 	movabs $0x804dce,%rax
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
  80023e:	48 b8 6e 56 80 00 00 	movabs $0x80566e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 74 56 80 00 00 	movabs $0x805674,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf c2 56 80 00 00 	movabs $0x8056c2,%rdi
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
  800332:	48 b8 a9 27 80 00 00 	movabs $0x8027a9,%rax
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
  80040c:	48 bf e8 56 80 00 00 	movabs $0x8056e8,%rdi
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
  800448:	48 bf 0b 57 80 00 00 	movabs $0x80570b,%rdi
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
  8006f9:	48 b8 10 59 80 00 00 	movabs $0x805910,%rax
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
  8009db:	48 b8 38 59 80 00 00 	movabs $0x805938,%rax
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
  800b22:	48 b8 60 58 80 00 00 	movabs $0x805860,%rax
  800b29:	00 00 00 
  800b2c:	48 63 d3             	movslq %ebx,%rdx
  800b2f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b33:	4d 85 e4             	test   %r12,%r12
  800b36:	75 2e                	jne    800b66 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800b38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	89 d9                	mov    %ebx,%ecx
  800b42:	48 ba 21 59 80 00 00 	movabs $0x805921,%rdx
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
  800b71:	48 ba 2a 59 80 00 00 	movabs $0x80592a,%rdx
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
  800bc8:	49 bc 2d 59 80 00 00 	movabs $0x80592d,%r12
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
  8018d4:	48 ba e8 5b 80 00 00 	movabs $0x805be8,%rdx
  8018db:	00 00 00 
  8018de:	be 24 00 00 00       	mov    $0x24,%esi
  8018e3:	48 bf 05 5c 80 00 00 	movabs $0x805c05,%rdi
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

0000000000801e4e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 30          	sub    $0x30,%rsp
  801e56:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5e:	48 8b 00             	mov    (%rax),%rax
  801e61:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801e65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e69:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e6d:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e73:	83 e0 02             	and    $0x2,%eax
  801e76:	85 c0                	test   %eax,%eax
  801e78:	75 40                	jne    801eba <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801e7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7e:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801e85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e89:	49 89 d0             	mov    %rdx,%r8
  801e8c:	48 89 c1             	mov    %rax,%rcx
  801e8f:	48 ba 18 5c 80 00 00 	movabs $0x805c18,%rdx
  801e96:	00 00 00 
  801e99:	be 1f 00 00 00       	mov    $0x1f,%esi
  801e9e:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  801ea5:	00 00 00 
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	49 b9 52 03 80 00 00 	movabs $0x800352,%r9
  801eb4:	00 00 00 
  801eb7:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801eba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ebe:	48 c1 e8 0c          	shr    $0xc,%rax
  801ec2:	48 89 c2             	mov    %rax,%rdx
  801ec5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ecc:	01 00 00 
  801ecf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed3:	25 07 08 00 00       	and    $0x807,%eax
  801ed8:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801ede:	74 4e                	je     801f2e <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ee8:	48 89 c2             	mov    %rax,%rdx
  801eeb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ef2:	01 00 00 
  801ef5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ef9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801efd:	49 89 d0             	mov    %rdx,%r8
  801f00:	48 89 c1             	mov    %rax,%rcx
  801f03:	48 ba 40 5c 80 00 00 	movabs $0x805c40,%rdx
  801f0a:	00 00 00 
  801f0d:	be 22 00 00 00       	mov    $0x22,%esi
  801f12:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  801f19:	00 00 00 
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	49 b9 52 03 80 00 00 	movabs $0x800352,%r9
  801f28:	00 00 00 
  801f2b:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f2e:	ba 07 00 00 00       	mov    $0x7,%edx
  801f33:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f38:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3d:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
  801f49:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801f4c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f50:	79 30                	jns    801f82 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801f52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f55:	89 c1                	mov    %eax,%ecx
  801f57:	48 ba 6b 5c 80 00 00 	movabs $0x805c6b,%rdx
  801f5e:	00 00 00 
  801f61:	be 28 00 00 00       	mov    $0x28,%esi
  801f66:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  801f6d:	00 00 00 
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
  801f75:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  801f7c:	00 00 00 
  801f7f:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801f82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f94:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f99:	48 89 c6             	mov    %rax,%rsi
  801f9c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fa1:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801fad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fbf:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fc5:	48 89 c1             	mov    %rax,%rcx
  801fc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd7:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax
  801fe3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801fe6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801fea:	79 30                	jns    80201c <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801fec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fef:	89 c1                	mov    %eax,%ecx
  801ff1:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  801ff8:	00 00 00 
  801ffb:	be 2d 00 00 00       	mov    $0x2d,%esi
  802000:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802007:	00 00 00 
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
  80200f:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802016:	00 00 00 
  802019:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80201c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
  802032:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802035:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802039:	79 30                	jns    80206b <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  80203b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80203e:	89 c1                	mov    %eax,%ecx
  802040:	48 ba 8f 5c 80 00 00 	movabs $0x805c8f,%rdx
  802047:	00 00 00 
  80204a:	be 31 00 00 00       	mov    $0x31,%esi
  80204f:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802056:	00 00 00 
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802065:	00 00 00 
  802068:	41 ff d0             	callq  *%r8

}
  80206b:	90                   	nop
  80206c:	c9                   	leaveq 
  80206d:	c3                   	retq   

000000000080206e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80206e:	55                   	push   %rbp
  80206f:	48 89 e5             	mov    %rsp,%rbp
  802072:	48 83 ec 30          	sub    $0x30,%rsp
  802076:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802079:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80207c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80207f:	c1 e0 0c             	shl    $0xc,%eax
  802082:	89 c0                	mov    %eax,%eax
  802084:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802088:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80208f:	01 00 00 
  802092:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802095:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802099:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80209d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a1:	25 02 08 00 00       	and    $0x802,%eax
  8020a6:	48 85 c0             	test   %rax,%rax
  8020a9:	74 0e                	je     8020b9 <duppage+0x4b>
  8020ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020af:	25 00 04 00 00       	and    $0x400,%eax
  8020b4:	48 85 c0             	test   %rax,%rax
  8020b7:	74 70                	je     802129 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8020b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8020c2:	89 c6                	mov    %eax,%esi
  8020c4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8020c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cf:	41 89 f0             	mov    %esi,%r8d
  8020d2:	48 89 c6             	mov    %rax,%rsi
  8020d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020da:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	callq  *%rax
  8020e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020ed:	79 30                	jns    80211f <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8020ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f2:	89 c1                	mov    %eax,%ecx
  8020f4:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  8020fb:	00 00 00 
  8020fe:	be 50 00 00 00       	mov    $0x50,%esi
  802103:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  80210a:	00 00 00 
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802119:	00 00 00 
  80211c:	41 ff d0             	callq  *%r8
		return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	e9 c4 00 00 00       	jmpq   8021ed <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802129:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80212d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802134:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80213a:	48 89 c6             	mov    %rax,%rsi
  80213d:	bf 00 00 00 00       	mov    $0x0,%edi
  802142:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  802149:	00 00 00 
  80214c:	ff d0                	callq  *%rax
  80214e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802151:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802155:	79 30                	jns    802187 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802157:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80215a:	89 c1                	mov    %eax,%ecx
  80215c:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  802163:	00 00 00 
  802166:	be 64 00 00 00       	mov    $0x64,%esi
  80216b:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802172:	00 00 00 
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  802181:	00 00 00 
  802184:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802187:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80218b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218f:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802195:	48 89 d1             	mov    %rdx,%rcx
  802198:	ba 00 00 00 00       	mov    $0x0,%edx
  80219d:	48 89 c6             	mov    %rax,%rsi
  8021a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a5:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
  8021b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021b8:	79 30                	jns    8021ea <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8021ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021bd:	89 c1                	mov    %eax,%ecx
  8021bf:	48 ba 7e 5c 80 00 00 	movabs $0x805c7e,%rdx
  8021c6:	00 00 00 
  8021c9:	be 66 00 00 00       	mov    $0x66,%esi
  8021ce:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  8021d5:	00 00 00 
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dd:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8021e4:	00 00 00 
  8021e7:	41 ff d0             	callq  *%r8
	return r;
  8021ea:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8021ed:	c9                   	leaveq 
  8021ee:	c3                   	retq   

00000000008021ef <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8021ef:	55                   	push   %rbp
  8021f0:	48 89 e5             	mov    %rsp,%rbp
  8021f3:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8021f7:	48 bf 4e 1e 80 00 00 	movabs $0x801e4e,%rdi
  8021fe:	00 00 00 
  802201:	48 b8 16 51 80 00 00 	movabs $0x805116,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80220d:	b8 07 00 00 00       	mov    $0x7,%eax
  802212:	cd 30                	int    $0x30
  802214:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802217:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  80221a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80221d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802221:	79 08                	jns    80222b <fork+0x3c>
		return envid;
  802223:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802226:	e9 0b 02 00 00       	jmpq   802436 <fork+0x247>
	if (envid == 0) {
  80222b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80222f:	75 3e                	jne    80226f <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802231:	48 b8 d9 19 80 00 00 	movabs $0x8019d9,%rax
  802238:	00 00 00 
  80223b:	ff d0                	callq  *%rax
  80223d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802242:	48 98                	cltq   
  802244:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80224b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802252:	00 00 00 
  802255:	48 01 c2             	add    %rax,%rdx
  802258:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80225f:	00 00 00 
  802262:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
  80226a:	e9 c7 01 00 00       	jmpq   802436 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80226f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802276:	e9 a6 00 00 00       	jmpq   802321 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  80227b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227e:	c1 f8 12             	sar    $0x12,%eax
  802281:	89 c2                	mov    %eax,%edx
  802283:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80228a:	01 00 00 
  80228d:	48 63 d2             	movslq %edx,%rdx
  802290:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802294:	83 e0 01             	and    $0x1,%eax
  802297:	48 85 c0             	test   %rax,%rax
  80229a:	74 21                	je     8022bd <fork+0xce>
  80229c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229f:	c1 f8 09             	sar    $0x9,%eax
  8022a2:	89 c2                	mov    %eax,%edx
  8022a4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ab:	01 00 00 
  8022ae:	48 63 d2             	movslq %edx,%rdx
  8022b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b5:	83 e0 01             	and    $0x1,%eax
  8022b8:	48 85 c0             	test   %rax,%rax
  8022bb:	75 09                	jne    8022c6 <fork+0xd7>
			pn += NPTENTRIES;
  8022bd:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8022c4:	eb 5b                	jmp    802321 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8022c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c9:	05 00 02 00 00       	add    $0x200,%eax
  8022ce:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8022d1:	eb 46                	jmp    802319 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8022d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022da:	01 00 00 
  8022dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022e0:	48 63 d2             	movslq %edx,%rdx
  8022e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e7:	83 e0 05             	and    $0x5,%eax
  8022ea:	48 83 f8 05          	cmp    $0x5,%rax
  8022ee:	75 21                	jne    802311 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  8022f0:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8022f7:	74 1b                	je     802314 <fork+0x125>
				continue;
			duppage(envid, pn);
  8022f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c7                	mov    %eax,%edi
  802303:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  80230a:	00 00 00 
  80230d:	ff d0                	callq  *%rax
  80230f:	eb 04                	jmp    802315 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802311:	90                   	nop
  802312:	eb 01                	jmp    802315 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802314:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802315:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80231f:	7c b2                	jl     8022d3 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802324:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802329:	0f 86 4c ff ff ff    	jbe    80227b <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80232f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802332:	ba 07 00 00 00       	mov    $0x7,%edx
  802337:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80233c:	89 c7                	mov    %eax,%edi
  80233e:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
  80234a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80234d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802351:	79 30                	jns    802383 <fork+0x194>
		panic("allocating exception stack: %e", r);
  802353:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802356:	89 c1                	mov    %eax,%ecx
  802358:	48 ba a8 5c 80 00 00 	movabs $0x805ca8,%rdx
  80235f:	00 00 00 
  802362:	be 9e 00 00 00       	mov    $0x9e,%esi
  802367:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  80236e:	00 00 00 
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
  802376:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80237d:	00 00 00 
  802380:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802383:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80238a:	00 00 00 
  80238d:	48 8b 00             	mov    (%rax),%rax
  802390:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802397:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80239a:	48 89 d6             	mov    %rdx,%rsi
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
  8023ab:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023b2:	79 30                	jns    8023e4 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8023b4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023b7:	89 c1                	mov    %eax,%ecx
  8023b9:	48 ba c8 5c 80 00 00 	movabs $0x805cc8,%rdx
  8023c0:	00 00 00 
  8023c3:	be a2 00 00 00       	mov    $0xa2,%esi
  8023c8:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  8023cf:	00 00 00 
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d7:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8023de:	00 00 00 
  8023e1:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8023e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e7:	be 02 00 00 00       	mov    $0x2,%esi
  8023ec:	89 c7                	mov    %eax,%edi
  8023ee:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	callq  *%rax
  8023fa:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802401:	79 30                	jns    802433 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802403:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802406:	89 c1                	mov    %eax,%ecx
  802408:	48 ba e7 5c 80 00 00 	movabs $0x805ce7,%rdx
  80240f:	00 00 00 
  802412:	be a7 00 00 00       	mov    $0xa7,%esi
  802417:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  80241e:	00 00 00 
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80242d:	00 00 00 
  802430:	41 ff d0             	callq  *%r8

	return envid;
  802433:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802436:	c9                   	leaveq 
  802437:	c3                   	retq   

0000000000802438 <sfork>:

// Challenge!
int
sfork(void)
{
  802438:	55                   	push   %rbp
  802439:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80243c:	48 ba fe 5c 80 00 00 	movabs $0x805cfe,%rdx
  802443:	00 00 00 
  802446:	be b1 00 00 00       	mov    $0xb1,%esi
  80244b:	48 bf 31 5c 80 00 00 	movabs $0x805c31,%rdi
  802452:	00 00 00 
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	48 b9 52 03 80 00 00 	movabs $0x800352,%rcx
  802461:	00 00 00 
  802464:	ff d1                	callq  *%rcx

0000000000802466 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	48 83 ec 08          	sub    $0x8,%rsp
  80246e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802472:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802476:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80247d:	ff ff ff 
  802480:	48 01 d0             	add    %rdx,%rax
  802483:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802487:	c9                   	leaveq 
  802488:	c3                   	retq   

0000000000802489 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802489:	55                   	push   %rbp
  80248a:	48 89 e5             	mov    %rsp,%rbp
  80248d:	48 83 ec 08          	sub    $0x8,%rsp
  802491:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802499:	48 89 c7             	mov    %rax,%rdi
  80249c:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	callq  *%rax
  8024a8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024ae:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024b2:	c9                   	leaveq 
  8024b3:	c3                   	retq   

00000000008024b4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024b4:	55                   	push   %rbp
  8024b5:	48 89 e5             	mov    %rsp,%rbp
  8024b8:	48 83 ec 18          	sub    $0x18,%rsp
  8024bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024c7:	eb 6b                	jmp    802534 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cc:	48 98                	cltq   
  8024ce:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024d4:	48 c1 e0 0c          	shl    $0xc,%rax
  8024d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e0:	48 c1 e8 15          	shr    $0x15,%rax
  8024e4:	48 89 c2             	mov    %rax,%rdx
  8024e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024ee:	01 00 00 
  8024f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f5:	83 e0 01             	and    $0x1,%eax
  8024f8:	48 85 c0             	test   %rax,%rax
  8024fb:	74 21                	je     80251e <fd_alloc+0x6a>
  8024fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802501:	48 c1 e8 0c          	shr    $0xc,%rax
  802505:	48 89 c2             	mov    %rax,%rdx
  802508:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80250f:	01 00 00 
  802512:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802516:	83 e0 01             	and    $0x1,%eax
  802519:	48 85 c0             	test   %rax,%rax
  80251c:	75 12                	jne    802530 <fd_alloc+0x7c>
			*fd_store = fd;
  80251e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802522:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802526:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802529:	b8 00 00 00 00       	mov    $0x0,%eax
  80252e:	eb 1a                	jmp    80254a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802530:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802534:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802538:	7e 8f                	jle    8024c9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80253a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802545:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80254a:	c9                   	leaveq 
  80254b:	c3                   	retq   

000000000080254c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80254c:	55                   	push   %rbp
  80254d:	48 89 e5             	mov    %rsp,%rbp
  802550:	48 83 ec 20          	sub    $0x20,%rsp
  802554:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802557:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80255b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80255f:	78 06                	js     802567 <fd_lookup+0x1b>
  802561:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802565:	7e 07                	jle    80256e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80256c:	eb 6c                	jmp    8025da <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80256e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802571:	48 98                	cltq   
  802573:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802579:	48 c1 e0 0c          	shl    $0xc,%rax
  80257d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802581:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802585:	48 c1 e8 15          	shr    $0x15,%rax
  802589:	48 89 c2             	mov    %rax,%rdx
  80258c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802593:	01 00 00 
  802596:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259a:	83 e0 01             	and    $0x1,%eax
  80259d:	48 85 c0             	test   %rax,%rax
  8025a0:	74 21                	je     8025c3 <fd_lookup+0x77>
  8025a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8025aa:	48 89 c2             	mov    %rax,%rdx
  8025ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025b4:	01 00 00 
  8025b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025bb:	83 e0 01             	and    $0x1,%eax
  8025be:	48 85 c0             	test   %rax,%rax
  8025c1:	75 07                	jne    8025ca <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c8:	eb 10                	jmp    8025da <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 30          	sub    $0x30,%rsp
  8025e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025e8:	89 f0                	mov    %esi,%eax
  8025ea:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f1:	48 89 c7             	mov    %rax,%rdi
  8025f4:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	89 c2                	mov    %eax,%edx
  802602:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802606:	48 89 c6             	mov    %rax,%rsi
  802609:	89 d7                	mov    %edx,%edi
  80260b:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  802612:	00 00 00 
  802615:	ff d0                	callq  *%rax
  802617:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261e:	78 0a                	js     80262a <fd_close+0x4e>
	    || fd != fd2)
  802620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802624:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802628:	74 12                	je     80263c <fd_close+0x60>
		return (must_exist ? r : 0);
  80262a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80262e:	74 05                	je     802635 <fd_close+0x59>
  802630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802633:	eb 70                	jmp    8026a5 <fd_close+0xc9>
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
  80263a:	eb 69                	jmp    8026a5 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80263c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802640:	8b 00                	mov    (%rax),%eax
  802642:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802646:	48 89 d6             	mov    %rdx,%rsi
  802649:	89 c7                	mov    %eax,%edi
  80264b:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	78 2a                	js     80268a <fd_close+0xae>
		if (dev->dev_close)
  802660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802664:	48 8b 40 20          	mov    0x20(%rax),%rax
  802668:	48 85 c0             	test   %rax,%rax
  80266b:	74 16                	je     802683 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80266d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802671:	48 8b 40 20          	mov    0x20(%rax),%rax
  802675:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802679:	48 89 d7             	mov    %rdx,%rdi
  80267c:	ff d0                	callq  *%rax
  80267e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802681:	eb 07                	jmp    80268a <fd_close+0xae>
		else
			r = 0;
  802683:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80268a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80268e:	48 89 c6             	mov    %rax,%rsi
  802691:	bf 00 00 00 00       	mov    $0x0,%edi
  802696:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	callq  *%rax
	return r;
  8026a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026a5:	c9                   	leaveq 
  8026a6:	c3                   	retq   

00000000008026a7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026a7:	55                   	push   %rbp
  8026a8:	48 89 e5             	mov    %rsp,%rbp
  8026ab:	48 83 ec 20          	sub    $0x20,%rsp
  8026af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026bd:	eb 41                	jmp    802700 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026bf:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026c6:	00 00 00 
  8026c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026cc:	48 63 d2             	movslq %edx,%rdx
  8026cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d3:	8b 00                	mov    (%rax),%eax
  8026d5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026d8:	75 22                	jne    8026fc <dev_lookup+0x55>
			*dev = devtab[i];
  8026da:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026e1:	00 00 00 
  8026e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026e7:	48 63 d2             	movslq %edx,%rdx
  8026ea:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fa:	eb 60                	jmp    80275c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026fc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802700:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802707:	00 00 00 
  80270a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80270d:	48 63 d2             	movslq %edx,%rdx
  802710:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802714:	48 85 c0             	test   %rax,%rax
  802717:	75 a6                	jne    8026bf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802719:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802720:	00 00 00 
  802723:	48 8b 00             	mov    (%rax),%rax
  802726:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80272c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80272f:	89 c6                	mov    %eax,%esi
  802731:	48 bf 18 5d 80 00 00 	movabs $0x805d18,%rdi
  802738:	00 00 00 
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
  802740:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802747:	00 00 00 
  80274a:	ff d1                	callq  *%rcx
	*dev = 0;
  80274c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802750:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80275c:	c9                   	leaveq 
  80275d:	c3                   	retq   

000000000080275e <close>:

int
close(int fdnum)
{
  80275e:	55                   	push   %rbp
  80275f:	48 89 e5             	mov    %rsp,%rbp
  802762:	48 83 ec 20          	sub    $0x20,%rsp
  802766:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802769:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80276d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802770:	48 89 d6             	mov    %rdx,%rsi
  802773:	89 c7                	mov    %eax,%edi
  802775:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802784:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802788:	79 05                	jns    80278f <close+0x31>
		return r;
  80278a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278d:	eb 18                	jmp    8027a7 <close+0x49>
	else
		return fd_close(fd, 1);
  80278f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802793:	be 01 00 00 00       	mov    $0x1,%esi
  802798:	48 89 c7             	mov    %rax,%rdi
  80279b:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8027a2:	00 00 00 
  8027a5:	ff d0                	callq  *%rax
}
  8027a7:	c9                   	leaveq 
  8027a8:	c3                   	retq   

00000000008027a9 <close_all>:

void
close_all(void)
{
  8027a9:	55                   	push   %rbp
  8027aa:	48 89 e5             	mov    %rsp,%rbp
  8027ad:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027b8:	eb 15                	jmp    8027cf <close_all+0x26>
		close(i);
  8027ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bd:	89 c7                	mov    %eax,%edi
  8027bf:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027cf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027d3:	7e e5                	jle    8027ba <close_all+0x11>
		close(i);
}
  8027d5:	90                   	nop
  8027d6:	c9                   	leaveq 
  8027d7:	c3                   	retq   

00000000008027d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027d8:	55                   	push   %rbp
  8027d9:	48 89 e5             	mov    %rsp,%rbp
  8027dc:	48 83 ec 40          	sub    $0x40,%rsp
  8027e0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027e3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027e6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027ed:	48 89 d6             	mov    %rdx,%rsi
  8027f0:	89 c7                	mov    %eax,%edi
  8027f2:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802805:	79 08                	jns    80280f <dup+0x37>
		return r;
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280a:	e9 70 01 00 00       	jmpq   80297f <dup+0x1a7>
	close(newfdnum);
  80280f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802812:	89 c7                	mov    %eax,%edi
  802814:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802820:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802823:	48 98                	cltq   
  802825:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80282b:	48 c1 e0 0c          	shl    $0xc,%rax
  80282f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802837:	48 89 c7             	mov    %rax,%rdi
  80283a:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
  802846:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	48 89 c7             	mov    %rax,%rdi
  802851:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
  80285d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802865:	48 c1 e8 15          	shr    $0x15,%rax
  802869:	48 89 c2             	mov    %rax,%rdx
  80286c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802873:	01 00 00 
  802876:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287a:	83 e0 01             	and    $0x1,%eax
  80287d:	48 85 c0             	test   %rax,%rax
  802880:	74 71                	je     8028f3 <dup+0x11b>
  802882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802886:	48 c1 e8 0c          	shr    $0xc,%rax
  80288a:	48 89 c2             	mov    %rax,%rdx
  80288d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802894:	01 00 00 
  802897:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289b:	83 e0 01             	and    $0x1,%eax
  80289e:	48 85 c0             	test   %rax,%rax
  8028a1:	74 50                	je     8028f3 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ab:	48 89 c2             	mov    %rax,%rdx
  8028ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028b5:	01 00 00 
  8028b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8028c1:	89 c1                	mov    %eax,%ecx
  8028c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cb:	41 89 c8             	mov    %ecx,%r8d
  8028ce:	48 89 d1             	mov    %rdx,%rcx
  8028d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d6:	48 89 c6             	mov    %rax,%rsi
  8028d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028de:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
  8028ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f1:	78 55                	js     802948 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8028fb:	48 89 c2             	mov    %rax,%rdx
  8028fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802905:	01 00 00 
  802908:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290c:	25 07 0e 00 00       	and    $0xe07,%eax
  802911:	89 c1                	mov    %eax,%ecx
  802913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802917:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80291b:	41 89 c8             	mov    %ecx,%r8d
  80291e:	48 89 d1             	mov    %rdx,%rcx
  802921:	ba 00 00 00 00       	mov    $0x0,%edx
  802926:	48 89 c6             	mov    %rax,%rsi
  802929:	bf 00 00 00 00       	mov    $0x0,%edi
  80292e:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  802935:	00 00 00 
  802938:	ff d0                	callq  *%rax
  80293a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802941:	78 08                	js     80294b <dup+0x173>
		goto err;

	return newfdnum;
  802943:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802946:	eb 37                	jmp    80297f <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802948:	90                   	nop
  802949:	eb 01                	jmp    80294c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80294b:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802950:	48 89 c6             	mov    %rax,%rsi
  802953:	bf 00 00 00 00       	mov    $0x0,%edi
  802958:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802968:	48 89 c6             	mov    %rax,%rsi
  80296b:	bf 00 00 00 00       	mov    $0x0,%edi
  802970:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
	return r;
  80297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80297f:	c9                   	leaveq 
  802980:	c3                   	retq   

0000000000802981 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802981:	55                   	push   %rbp
  802982:	48 89 e5             	mov    %rsp,%rbp
  802985:	48 83 ec 40          	sub    $0x40,%rsp
  802989:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802990:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802994:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802998:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80299b:	48 89 d6             	mov    %rdx,%rsi
  80299e:	89 c7                	mov    %eax,%edi
  8029a0:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
  8029ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b3:	78 24                	js     8029d9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b9:	8b 00                	mov    (%rax),%eax
  8029bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029bf:	48 89 d6             	mov    %rdx,%rsi
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
  8029d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d7:	79 05                	jns    8029de <read+0x5d>
		return r;
  8029d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dc:	eb 76                	jmp    802a54 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e2:	8b 40 08             	mov    0x8(%rax),%eax
  8029e5:	83 e0 03             	and    $0x3,%eax
  8029e8:	83 f8 01             	cmp    $0x1,%eax
  8029eb:	75 3a                	jne    802a27 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029ed:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8029f4:	00 00 00 
  8029f7:	48 8b 00             	mov    (%rax),%rax
  8029fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a03:	89 c6                	mov    %eax,%esi
  802a05:	48 bf 37 5d 80 00 00 	movabs $0x805d37,%rdi
  802a0c:	00 00 00 
  802a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a14:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802a1b:	00 00 00 
  802a1e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a25:	eb 2d                	jmp    802a54 <read+0xd3>
	}
	if (!dev->dev_read)
  802a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a2f:	48 85 c0             	test   %rax,%rax
  802a32:	75 07                	jne    802a3b <read+0xba>
		return -E_NOT_SUPP;
  802a34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a39:	eb 19                	jmp    802a54 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a4b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a4f:	48 89 cf             	mov    %rcx,%rdi
  802a52:	ff d0                	callq  *%rax
}
  802a54:	c9                   	leaveq 
  802a55:	c3                   	retq   

0000000000802a56 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a56:	55                   	push   %rbp
  802a57:	48 89 e5             	mov    %rsp,%rbp
  802a5a:	48 83 ec 30          	sub    $0x30,%rsp
  802a5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a70:	eb 47                	jmp    802ab9 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	48 98                	cltq   
  802a77:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a7b:	48 29 c2             	sub    %rax,%rdx
  802a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a81:	48 63 c8             	movslq %eax,%rcx
  802a84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a88:	48 01 c1             	add    %rax,%rcx
  802a8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a8e:	48 89 ce             	mov    %rcx,%rsi
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	48 b8 81 29 80 00 00 	movabs $0x802981,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802aa2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aa6:	79 05                	jns    802aad <readn+0x57>
			return m;
  802aa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aab:	eb 1d                	jmp    802aca <readn+0x74>
		if (m == 0)
  802aad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ab1:	74 13                	je     802ac6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ab3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab6:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ab9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abc:	48 98                	cltq   
  802abe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ac2:	72 ae                	jb     802a72 <readn+0x1c>
  802ac4:	eb 01                	jmp    802ac7 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802ac6:	90                   	nop
	}
	return tot;
  802ac7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aca:	c9                   	leaveq 
  802acb:	c3                   	retq   

0000000000802acc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802acc:	55                   	push   %rbp
  802acd:	48 89 e5             	mov    %rsp,%rbp
  802ad0:	48 83 ec 40          	sub    $0x40,%rsp
  802ad4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802adb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802adf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae6:	48 89 d6             	mov    %rdx,%rsi
  802ae9:	89 c7                	mov    %eax,%edi
  802aeb:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afe:	78 24                	js     802b24 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b04:	8b 00                	mov    (%rax),%eax
  802b06:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0a:	48 89 d6             	mov    %rdx,%rsi
  802b0d:	89 c7                	mov    %eax,%edi
  802b0f:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b22:	79 05                	jns    802b29 <write+0x5d>
		return r;
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b27:	eb 75                	jmp    802b9e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2d:	8b 40 08             	mov    0x8(%rax),%eax
  802b30:	83 e0 03             	and    $0x3,%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	75 3a                	jne    802b71 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b37:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802b3e:	00 00 00 
  802b41:	48 8b 00             	mov    (%rax),%rax
  802b44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b4a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b4d:	89 c6                	mov    %eax,%esi
  802b4f:	48 bf 53 5d 80 00 00 	movabs $0x805d53,%rdi
  802b56:	00 00 00 
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5e:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802b65:	00 00 00 
  802b68:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6f:	eb 2d                	jmp    802b9e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b75:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b79:	48 85 c0             	test   %rax,%rax
  802b7c:	75 07                	jne    802b85 <write+0xb9>
		return -E_NOT_SUPP;
  802b7e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b83:	eb 19                	jmp    802b9e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b89:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b8d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b91:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b95:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b99:	48 89 cf             	mov    %rcx,%rdi
  802b9c:	ff d0                	callq  *%rax
}
  802b9e:	c9                   	leaveq 
  802b9f:	c3                   	retq   

0000000000802ba0 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ba0:	55                   	push   %rbp
  802ba1:	48 89 e5             	mov    %rsp,%rbp
  802ba4:	48 83 ec 18          	sub    $0x18,%rsp
  802ba8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bab:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb5:	48 89 d6             	mov    %rdx,%rsi
  802bb8:	89 c7                	mov    %eax,%edi
  802bba:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
  802bc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bcd:	79 05                	jns    802bd4 <seek+0x34>
		return r;
  802bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd2:	eb 0f                	jmp    802be3 <seek+0x43>
	fd->fd_offset = offset;
  802bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bdb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be3:	c9                   	leaveq 
  802be4:	c3                   	retq   

0000000000802be5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802be5:	55                   	push   %rbp
  802be6:	48 89 e5             	mov    %rsp,%rbp
  802be9:	48 83 ec 30          	sub    $0x30,%rsp
  802bed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf0:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bfa:	48 89 d6             	mov    %rdx,%rsi
  802bfd:	89 c7                	mov    %eax,%edi
  802bff:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  802c06:	00 00 00 
  802c09:	ff d0                	callq  *%rax
  802c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c12:	78 24                	js     802c38 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c18:	8b 00                	mov    (%rax),%eax
  802c1a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c1e:	48 89 d6             	mov    %rdx,%rsi
  802c21:	89 c7                	mov    %eax,%edi
  802c23:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	callq  *%rax
  802c2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c36:	79 05                	jns    802c3d <ftruncate+0x58>
		return r;
  802c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3b:	eb 72                	jmp    802caf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c41:	8b 40 08             	mov    0x8(%rax),%eax
  802c44:	83 e0 03             	and    $0x3,%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	75 3a                	jne    802c85 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c4b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802c52:	00 00 00 
  802c55:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c58:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c5e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c61:	89 c6                	mov    %eax,%esi
  802c63:	48 bf 70 5d 80 00 00 	movabs $0x805d70,%rdi
  802c6a:	00 00 00 
  802c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c72:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  802c79:	00 00 00 
  802c7c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c83:	eb 2a                	jmp    802caf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c8d:	48 85 c0             	test   %rax,%rax
  802c90:	75 07                	jne    802c99 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c92:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c97:	eb 16                	jmp    802caf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ca1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ca8:	89 ce                	mov    %ecx,%esi
  802caa:	48 89 d7             	mov    %rdx,%rdi
  802cad:	ff d0                	callq  *%rax
}
  802caf:	c9                   	leaveq 
  802cb0:	c3                   	retq   

0000000000802cb1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cb1:	55                   	push   %rbp
  802cb2:	48 89 e5             	mov    %rsp,%rbp
  802cb5:	48 83 ec 30          	sub    $0x30,%rsp
  802cb9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cc7:	48 89 d6             	mov    %rdx,%rsi
  802cca:	89 c7                	mov    %eax,%edi
  802ccc:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdf:	78 24                	js     802d05 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce5:	8b 00                	mov    (%rax),%eax
  802ce7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ceb:	48 89 d6             	mov    %rdx,%rsi
  802cee:	89 c7                	mov    %eax,%edi
  802cf0:	48 b8 a7 26 80 00 00 	movabs $0x8026a7,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	callq  *%rax
  802cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d03:	79 05                	jns    802d0a <fstat+0x59>
		return r;
  802d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d08:	eb 5e                	jmp    802d68 <fstat+0xb7>
	if (!dev->dev_stat)
  802d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d12:	48 85 c0             	test   %rax,%rax
  802d15:	75 07                	jne    802d1e <fstat+0x6d>
		return -E_NOT_SUPP;
  802d17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d1c:	eb 4a                	jmp    802d68 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d22:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d29:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d30:	00 00 00 
	stat->st_isdir = 0;
  802d33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d37:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d3e:	00 00 00 
	stat->st_dev = dev;
  802d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d49:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d54:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d5c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d60:	48 89 ce             	mov    %rcx,%rsi
  802d63:	48 89 d7             	mov    %rdx,%rdi
  802d66:	ff d0                	callq  *%rax
}
  802d68:	c9                   	leaveq 
  802d69:	c3                   	retq   

0000000000802d6a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d6a:	55                   	push   %rbp
  802d6b:	48 89 e5             	mov    %rsp,%rbp
  802d6e:	48 83 ec 20          	sub    $0x20,%rsp
  802d72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7e:	be 00 00 00 00       	mov    $0x0,%esi
  802d83:	48 89 c7             	mov    %rax,%rdi
  802d86:	48 b8 5a 2e 80 00 00 	movabs $0x802e5a,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
  802d92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d99:	79 05                	jns    802da0 <stat+0x36>
		return fd;
  802d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9e:	eb 2f                	jmp    802dcf <stat+0x65>
	r = fstat(fd, stat);
  802da0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da7:	48 89 d6             	mov    %rdx,%rsi
  802daa:	89 c7                	mov    %eax,%edi
  802dac:	48 b8 b1 2c 80 00 00 	movabs $0x802cb1,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
  802db8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbe:	89 c7                	mov    %eax,%edi
  802dc0:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802dc7:	00 00 00 
  802dca:	ff d0                	callq  *%rax
	return r;
  802dcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dcf:	c9                   	leaveq 
  802dd0:	c3                   	retq   

0000000000802dd1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dd1:	55                   	push   %rbp
  802dd2:	48 89 e5             	mov    %rsp,%rbp
  802dd5:	48 83 ec 10          	sub    $0x10,%rsp
  802dd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ddc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802de0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802de7:	00 00 00 
  802dea:	8b 00                	mov    (%rax),%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	75 1f                	jne    802e0f <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802df0:	bf 01 00 00 00       	mov    $0x1,%edi
  802df5:	48 b8 0c 55 80 00 00 	movabs $0x80550c,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
  802e01:	89 c2                	mov    %eax,%edx
  802e03:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e0a:	00 00 00 
  802e0d:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e0f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e16:	00 00 00 
  802e19:	8b 00                	mov    (%rax),%eax
  802e1b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e1e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e23:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802e2a:	00 00 00 
  802e2d:	89 c7                	mov    %eax,%edi
  802e2f:	48 b8 00 53 80 00 00 	movabs $0x805300,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802e44:	48 89 c6             	mov    %rax,%rsi
  802e47:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4c:	48 b8 3f 52 80 00 00 	movabs $0x80523f,%rax
  802e53:	00 00 00 
  802e56:	ff d0                	callq  *%rax
}
  802e58:	c9                   	leaveq 
  802e59:	c3                   	retq   

0000000000802e5a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e5a:	55                   	push   %rbp
  802e5b:	48 89 e5             	mov    %rsp,%rbp
  802e5e:	48 83 ec 20          	sub    $0x20,%rsp
  802e62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e66:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6d:	48 89 c7             	mov    %rax,%rdi
  802e70:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
  802e7c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e81:	7e 0a                	jle    802e8d <open+0x33>
		return -E_BAD_PATH;
  802e83:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e88:	e9 a5 00 00 00       	jmpq   802f32 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e8d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e91:	48 89 c7             	mov    %rax,%rdi
  802e94:	48 b8 b4 24 80 00 00 	movabs $0x8024b4,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea7:	79 08                	jns    802eb1 <open+0x57>
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	e9 81 00 00 00       	jmpq   802f32 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb5:	48 89 c6             	mov    %rax,%rsi
  802eb8:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802ebf:	00 00 00 
  802ec2:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ece:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ed5:	00 00 00 
  802ed8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802edb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee5:	48 89 c6             	mov    %rax,%rsi
  802ee8:	bf 01 00 00 00       	mov    $0x1,%edi
  802eed:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
  802ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f00:	79 1d                	jns    802f1f <open+0xc5>
		fd_close(fd, 0);
  802f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f06:	be 00 00 00 00       	mov    $0x0,%esi
  802f0b:	48 89 c7             	mov    %rax,%rdi
  802f0e:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
		return r;
  802f1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1d:	eb 13                	jmp    802f32 <open+0xd8>
	}

	return fd2num(fd);
  802f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f23:	48 89 c7             	mov    %rax,%rdi
  802f26:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax

}
  802f32:	c9                   	leaveq 
  802f33:	c3                   	retq   

0000000000802f34 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f34:	55                   	push   %rbp
  802f35:	48 89 e5             	mov    %rsp,%rbp
  802f38:	48 83 ec 10          	sub    $0x10,%rsp
  802f3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f44:	8b 50 0c             	mov    0xc(%rax),%edx
  802f47:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f4e:	00 00 00 
  802f51:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f53:	be 00 00 00 00       	mov    $0x0,%esi
  802f58:	bf 06 00 00 00       	mov    $0x6,%edi
  802f5d:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
}
  802f69:	c9                   	leaveq 
  802f6a:	c3                   	retq   

0000000000802f6b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f6b:	55                   	push   %rbp
  802f6c:	48 89 e5             	mov    %rsp,%rbp
  802f6f:	48 83 ec 30          	sub    $0x30,%rsp
  802f73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f83:	8b 50 0c             	mov    0xc(%rax),%edx
  802f86:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f8d:	00 00 00 
  802f90:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f99:	00 00 00 
  802f9c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fa0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802fa4:	be 00 00 00 00       	mov    $0x0,%esi
  802fa9:	bf 03 00 00 00       	mov    $0x3,%edi
  802fae:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	callq  *%rax
  802fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc1:	79 08                	jns    802fcb <devfile_read+0x60>
		return r;
  802fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc6:	e9 a4 00 00 00       	jmpq   80306f <devfile_read+0x104>
	assert(r <= n);
  802fcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fce:	48 98                	cltq   
  802fd0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fd4:	76 35                	jbe    80300b <devfile_read+0xa0>
  802fd6:	48 b9 96 5d 80 00 00 	movabs $0x805d96,%rcx
  802fdd:	00 00 00 
  802fe0:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  802fe7:	00 00 00 
  802fea:	be 86 00 00 00       	mov    $0x86,%esi
  802fef:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  802ff6:	00 00 00 
  802ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffe:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803005:	00 00 00 
  803008:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80300b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803012:	7e 35                	jle    803049 <devfile_read+0xde>
  803014:	48 b9 bd 5d 80 00 00 	movabs $0x805dbd,%rcx
  80301b:	00 00 00 
  80301e:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  803025:	00 00 00 
  803028:	be 87 00 00 00       	mov    $0x87,%esi
  80302d:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  803034:	00 00 00 
  803037:	b8 00 00 00 00       	mov    $0x0,%eax
  80303c:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803043:	00 00 00 
  803046:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304c:	48 63 d0             	movslq %eax,%rdx
  80304f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803053:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80305a:	00 00 00 
  80305d:	48 89 c7             	mov    %rax,%rdi
  803060:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  803067:	00 00 00 
  80306a:	ff d0                	callq  *%rax
	return r;
  80306c:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80306f:	c9                   	leaveq 
  803070:	c3                   	retq   

0000000000803071 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803071:	55                   	push   %rbp
  803072:	48 89 e5             	mov    %rsp,%rbp
  803075:	48 83 ec 40          	sub    $0x40,%rsp
  803079:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80307d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803081:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803085:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803089:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80308d:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803094:	00 
  803095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803099:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80309d:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8030a2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030aa:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030b4:	00 00 00 
  8030b7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8030b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030c0:	00 00 00 
  8030c3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030c7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8030cb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030d3:	48 89 c6             	mov    %rax,%rsi
  8030d6:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  8030dd:	00 00 00 
  8030e0:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8030e7:	00 00 00 
  8030ea:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8030ec:	be 00 00 00 00       	mov    $0x0,%esi
  8030f1:	bf 04 00 00 00       	mov    $0x4,%edi
  8030f6:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  8030fd:	00 00 00 
  803100:	ff d0                	callq  *%rax
  803102:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803105:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803109:	79 05                	jns    803110 <devfile_write+0x9f>
		return r;
  80310b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80310e:	eb 43                	jmp    803153 <devfile_write+0xe2>
	assert(r <= n);
  803110:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803113:	48 98                	cltq   
  803115:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803119:	76 35                	jbe    803150 <devfile_write+0xdf>
  80311b:	48 b9 96 5d 80 00 00 	movabs $0x805d96,%rcx
  803122:	00 00 00 
  803125:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  80312c:	00 00 00 
  80312f:	be a2 00 00 00       	mov    $0xa2,%esi
  803134:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  80313b:	00 00 00 
  80313e:	b8 00 00 00 00       	mov    $0x0,%eax
  803143:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80314a:	00 00 00 
  80314d:	41 ff d0             	callq  *%r8
	return r;
  803150:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803153:	c9                   	leaveq 
  803154:	c3                   	retq   

0000000000803155 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803155:	55                   	push   %rbp
  803156:	48 89 e5             	mov    %rsp,%rbp
  803159:	48 83 ec 20          	sub    $0x20,%rsp
  80315d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803161:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803165:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803169:	8b 50 0c             	mov    0xc(%rax),%edx
  80316c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803173:	00 00 00 
  803176:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803178:	be 00 00 00 00       	mov    $0x0,%esi
  80317d:	bf 05 00 00 00       	mov    $0x5,%edi
  803182:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  803189:	00 00 00 
  80318c:	ff d0                	callq  *%rax
  80318e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803191:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803195:	79 05                	jns    80319c <devfile_stat+0x47>
		return r;
  803197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319a:	eb 56                	jmp    8031f2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80319c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a0:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8031a7:	00 00 00 
  8031aa:	48 89 c7             	mov    %rax,%rdi
  8031ad:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  8031b4:	00 00 00 
  8031b7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031c0:	00 00 00 
  8031c3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031da:	00 00 00 
  8031dd:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f2:	c9                   	leaveq 
  8031f3:	c3                   	retq   

00000000008031f4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031f4:	55                   	push   %rbp
  8031f5:	48 89 e5             	mov    %rsp,%rbp
  8031f8:	48 83 ec 10          	sub    $0x10,%rsp
  8031fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803200:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803207:	8b 50 0c             	mov    0xc(%rax),%edx
  80320a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803211:	00 00 00 
  803214:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803216:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80321d:	00 00 00 
  803220:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803223:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803226:	be 00 00 00 00       	mov    $0x0,%esi
  80322b:	bf 02 00 00 00       	mov    $0x2,%edi
  803230:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  803237:	00 00 00 
  80323a:	ff d0                	callq  *%rax
}
  80323c:	c9                   	leaveq 
  80323d:	c3                   	retq   

000000000080323e <remove>:

// Delete a file
int
remove(const char *path)
{
  80323e:	55                   	push   %rbp
  80323f:	48 89 e5             	mov    %rsp,%rbp
  803242:	48 83 ec 10          	sub    $0x10,%rsp
  803246:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80324a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324e:	48 89 c7             	mov    %rax,%rdi
  803251:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
  80325d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803262:	7e 07                	jle    80326b <remove+0x2d>
		return -E_BAD_PATH;
  803264:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803269:	eb 33                	jmp    80329e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80326b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326f:	48 89 c6             	mov    %rax,%rsi
  803272:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803279:	00 00 00 
  80327c:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803288:	be 00 00 00 00       	mov    $0x0,%esi
  80328d:	bf 07 00 00 00       	mov    $0x7,%edi
  803292:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
}
  80329e:	c9                   	leaveq 
  80329f:	c3                   	retq   

00000000008032a0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032a0:	55                   	push   %rbp
  8032a1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032a4:	be 00 00 00 00       	mov    $0x0,%esi
  8032a9:	bf 08 00 00 00       	mov    $0x8,%edi
  8032ae:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
}
  8032ba:	5d                   	pop    %rbp
  8032bb:	c3                   	retq   

00000000008032bc <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032c7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032ce:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032d5:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032dc:	be 00 00 00 00       	mov    $0x0,%esi
  8032e1:	48 89 c7             	mov    %rax,%rdi
  8032e4:	48 b8 5a 2e 80 00 00 	movabs $0x802e5a,%rax
  8032eb:	00 00 00 
  8032ee:	ff d0                	callq  *%rax
  8032f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f7:	79 28                	jns    803321 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fc:	89 c6                	mov    %eax,%esi
  8032fe:	48 bf c9 5d 80 00 00 	movabs $0x805dc9,%rdi
  803305:	00 00 00 
  803308:	b8 00 00 00 00       	mov    $0x0,%eax
  80330d:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  803314:	00 00 00 
  803317:	ff d2                	callq  *%rdx
		return fd_src;
  803319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331c:	e9 76 01 00 00       	jmpq   803497 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803321:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803328:	be 01 01 00 00       	mov    $0x101,%esi
  80332d:	48 89 c7             	mov    %rax,%rdi
  803330:	48 b8 5a 2e 80 00 00 	movabs $0x802e5a,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80333f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803343:	0f 89 ad 00 00 00    	jns    8033f6 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803349:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80334c:	89 c6                	mov    %eax,%esi
  80334e:	48 bf df 5d 80 00 00 	movabs $0x805ddf,%rdi
  803355:	00 00 00 
  803358:	b8 00 00 00 00       	mov    $0x0,%eax
  80335d:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  803364:	00 00 00 
  803367:	ff d2                	callq  *%rdx
		close(fd_src);
  803369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336c:	89 c7                	mov    %eax,%edi
  80336e:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
		return fd_dest;
  80337a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337d:	e9 15 01 00 00       	jmpq   803497 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803382:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803385:	48 63 d0             	movslq %eax,%rdx
  803388:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80338f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803392:	48 89 ce             	mov    %rcx,%rsi
  803395:	89 c7                	mov    %eax,%edi
  803397:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
  8033a3:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033aa:	79 4a                	jns    8033f6 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8033ac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033af:	89 c6                	mov    %eax,%esi
  8033b1:	48 bf f9 5d 80 00 00 	movabs $0x805df9,%rdi
  8033b8:	00 00 00 
  8033bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c0:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  8033c7:	00 00 00 
  8033ca:	ff d2                	callq  *%rdx
			close(fd_src);
  8033cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cf:	89 c7                	mov    %eax,%edi
  8033d1:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
			close(fd_dest);
  8033dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033e0:	89 c7                	mov    %eax,%edi
  8033e2:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
			return write_size;
  8033ee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033f1:	e9 a1 00 00 00       	jmpq   803497 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033f6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	ba 00 02 00 00       	mov    $0x200,%edx
  803405:	48 89 ce             	mov    %rcx,%rsi
  803408:	89 c7                	mov    %eax,%edi
  80340a:	48 b8 81 29 80 00 00 	movabs $0x802981,%rax
  803411:	00 00 00 
  803414:	ff d0                	callq  *%rax
  803416:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80341d:	0f 8f 5f ff ff ff    	jg     803382 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803423:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803427:	79 47                	jns    803470 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803429:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80342c:	89 c6                	mov    %eax,%esi
  80342e:	48 bf 0c 5e 80 00 00 	movabs $0x805e0c,%rdi
  803435:	00 00 00 
  803438:	b8 00 00 00 00       	mov    $0x0,%eax
  80343d:	48 ba 8c 05 80 00 00 	movabs $0x80058c,%rdx
  803444:	00 00 00 
  803447:	ff d2                	callq  *%rdx
		close(fd_src);
  803449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
		close(fd_dest);
  80345a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80345d:	89 c7                	mov    %eax,%edi
  80345f:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
		return read_size;
  80346b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80346e:	eb 27                	jmp    803497 <copy+0x1db>
	}
	close(fd_src);
  803470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
	close(fd_dest);
  803481:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803484:	89 c7                	mov    %eax,%edi
  803486:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
	return 0;
  803492:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803497:	c9                   	leaveq 
  803498:	c3                   	retq   

0000000000803499 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803499:	55                   	push   %rbp
  80349a:	48 89 e5             	mov    %rsp,%rbp
  80349d:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  8034a4:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8034ab:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8034b2:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8034b9:	be 00 00 00 00       	mov    $0x0,%esi
  8034be:	48 89 c7             	mov    %rax,%rdi
  8034c1:	48 b8 5a 2e 80 00 00 	movabs $0x802e5a,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
  8034cd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034d4:	79 08                	jns    8034de <spawn+0x45>
		return r;
  8034d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034d9:	e9 11 03 00 00       	jmpq   8037ef <spawn+0x356>
	fd = r;
  8034de:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034e1:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8034e4:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8034eb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8034ef:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8034f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034f9:	ba 00 02 00 00       	mov    $0x200,%edx
  8034fe:	48 89 ce             	mov    %rcx,%rsi
  803501:	89 c7                	mov    %eax,%edi
  803503:	48 b8 56 2a 80 00 00 	movabs $0x802a56,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
  80350f:	3d 00 02 00 00       	cmp    $0x200,%eax
  803514:	75 0d                	jne    803523 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80351a:	8b 00                	mov    (%rax),%eax
  80351c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803521:	74 43                	je     803566 <spawn+0xcd>
		close(fd);
  803523:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803526:	89 c7                	mov    %eax,%edi
  803528:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80352f:	00 00 00 
  803532:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803538:	8b 00                	mov    (%rax),%eax
  80353a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80353f:	89 c6                	mov    %eax,%esi
  803541:	48 bf 28 5e 80 00 00 	movabs $0x805e28,%rdi
  803548:	00 00 00 
  80354b:	b8 00 00 00 00       	mov    $0x0,%eax
  803550:	48 b9 8c 05 80 00 00 	movabs $0x80058c,%rcx
  803557:	00 00 00 
  80355a:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80355c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803561:	e9 89 02 00 00       	jmpq   8037ef <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803566:	b8 07 00 00 00       	mov    $0x7,%eax
  80356b:	cd 30                	int    $0x30
  80356d:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803570:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803573:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803576:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80357a:	79 08                	jns    803584 <spawn+0xeb>
		return r;
  80357c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80357f:	e9 6b 02 00 00       	jmpq   8037ef <spawn+0x356>
	child = r;
  803584:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803587:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80358a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80358d:	25 ff 03 00 00       	and    $0x3ff,%eax
  803592:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803599:	00 00 00 
  80359c:	48 98                	cltq   
  80359e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8035a5:	48 01 c2             	add    %rax,%rdx
  8035a8:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8035af:	48 89 d6             	mov    %rdx,%rsi
  8035b2:	ba 18 00 00 00       	mov    $0x18,%edx
  8035b7:	48 89 c7             	mov    %rax,%rdi
  8035ba:	48 89 d1             	mov    %rdx,%rcx
  8035bd:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8035c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8035c8:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8035cf:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8035d6:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8035dd:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8035e4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035e7:	48 89 ce             	mov    %rcx,%rsi
  8035ea:	89 c7                	mov    %eax,%edi
  8035ec:	48 b8 53 3a 80 00 00 	movabs $0x803a53,%rax
  8035f3:	00 00 00 
  8035f6:	ff d0                	callq  *%rax
  8035f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035ff:	79 08                	jns    803609 <spawn+0x170>
		return r;
  803601:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803604:	e9 e6 01 00 00       	jmpq   8037ef <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360d:	48 8b 40 20          	mov    0x20(%rax),%rax
  803611:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803618:	48 01 d0             	add    %rdx,%rax
  80361b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80361f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803626:	e9 80 00 00 00       	jmpq   8036ab <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  80362b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362f:	8b 00                	mov    (%rax),%eax
  803631:	83 f8 01             	cmp    $0x1,%eax
  803634:	75 6b                	jne    8036a1 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  803636:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80363d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803641:	8b 40 04             	mov    0x4(%rax),%eax
  803644:	83 e0 02             	and    $0x2,%eax
  803647:	85 c0                	test   %eax,%eax
  803649:	74 04                	je     80364f <spawn+0x1b6>
			perm |= PTE_W;
  80364b:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80364f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803653:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803657:	41 89 c1             	mov    %eax,%r9d
  80365a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365e:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803666:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80366a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366e:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803672:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803675:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803678:	48 83 ec 08          	sub    $0x8,%rsp
  80367c:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80367f:	57                   	push   %rdi
  803680:	89 c7                	mov    %eax,%edi
  803682:	48 b8 ff 3c 80 00 00 	movabs $0x803cff,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
  80368e:	48 83 c4 10          	add    $0x10,%rsp
  803692:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803695:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803699:	0f 88 2a 01 00 00    	js     8037c9 <spawn+0x330>
  80369f:	eb 01                	jmp    8036a2 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  8036a1:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8036a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036a6:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8036ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036af:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8036b3:	0f b7 c0             	movzwl %ax,%eax
  8036b6:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8036b9:	0f 8f 6c ff ff ff    	jg     80362b <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8036bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036c2:	89 c7                	mov    %eax,%edi
  8036c4:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
	fd = -1;
  8036d0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8036d7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036da:	89 c7                	mov    %eax,%edi
  8036dc:	48 b8 eb 3e 80 00 00 	movabs $0x803eeb,%rax
  8036e3:	00 00 00 
  8036e6:	ff d0                	callq  *%rax
  8036e8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8036eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8036ef:	79 30                	jns    803721 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  8036f1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036f4:	89 c1                	mov    %eax,%ecx
  8036f6:	48 ba 42 5e 80 00 00 	movabs $0x805e42,%rdx
  8036fd:	00 00 00 
  803700:	be 86 00 00 00       	mov    $0x86,%esi
  803705:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  80370c:	00 00 00 
  80370f:	b8 00 00 00 00       	mov    $0x0,%eax
  803714:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80371b:	00 00 00 
  80371e:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803721:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803728:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80372b:	48 89 d6             	mov    %rdx,%rsi
  80372e:	89 c7                	mov    %eax,%edi
  803730:	48 b8 9d 1b 80 00 00 	movabs $0x801b9d,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
  80373c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80373f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803743:	79 30                	jns    803775 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  803745:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803748:	89 c1                	mov    %eax,%ecx
  80374a:	48 ba 64 5e 80 00 00 	movabs $0x805e64,%rdx
  803751:	00 00 00 
  803754:	be 8a 00 00 00       	mov    $0x8a,%esi
  803759:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803760:	00 00 00 
  803763:	b8 00 00 00 00       	mov    $0x0,%eax
  803768:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80376f:	00 00 00 
  803772:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803775:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803778:	be 02 00 00 00       	mov    $0x2,%esi
  80377d:	89 c7                	mov    %eax,%edi
  80377f:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
  80378b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80378e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803792:	79 30                	jns    8037c4 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  803794:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803797:	89 c1                	mov    %eax,%ecx
  803799:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  8037a0:	00 00 00 
  8037a3:	be 8d 00 00 00       	mov    $0x8d,%esi
  8037a8:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  8037af:	00 00 00 
  8037b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b7:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8037be:	00 00 00 
  8037c1:	41 ff d0             	callq  *%r8

	return child;
  8037c4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037c7:	eb 26                	jmp    8037ef <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8037c9:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8037ca:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037cd:	89 c7                	mov    %eax,%edi
  8037cf:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
	close(fd);
  8037db:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8037de:	89 c7                	mov    %eax,%edi
  8037e0:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  8037e7:	00 00 00 
  8037ea:	ff d0                	callq  *%rax
	return r;
  8037ec:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  8037ef:	c9                   	leaveq 
  8037f0:	c3                   	retq   

00000000008037f1 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8037f1:	55                   	push   %rbp
  8037f2:	48 89 e5             	mov    %rsp,%rbp
  8037f5:	41 55                	push   %r13
  8037f7:	41 54                	push   %r12
  8037f9:	53                   	push   %rbx
  8037fa:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803801:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803808:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  80380f:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803816:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  80381d:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803824:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80382b:	84 c0                	test   %al,%al
  80382d:	74 26                	je     803855 <spawnl+0x64>
  80382f:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803836:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  80383d:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803841:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803845:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803849:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  80384d:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803851:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803855:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80385c:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80385f:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803866:	00 00 00 
  803869:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803870:	00 00 00 
  803873:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803877:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80387e:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803885:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80388c:	eb 07                	jmp    803895 <spawnl+0xa4>
		argc++;
  80388e:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803895:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80389b:	83 f8 30             	cmp    $0x30,%eax
  80389e:	73 23                	jae    8038c3 <spawnl+0xd2>
  8038a0:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8038a7:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8038ad:	89 d2                	mov    %edx,%edx
  8038af:	48 01 d0             	add    %rdx,%rax
  8038b2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8038b8:	83 c2 08             	add    $0x8,%edx
  8038bb:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8038c1:	eb 12                	jmp    8038d5 <spawnl+0xe4>
  8038c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8038ca:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8038ce:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8038d5:	48 8b 00             	mov    (%rax),%rax
  8038d8:	48 85 c0             	test   %rax,%rax
  8038db:	75 b1                	jne    80388e <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8038dd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8038e3:	83 c0 02             	add    $0x2,%eax
  8038e6:	48 89 e2             	mov    %rsp,%rdx
  8038e9:	48 89 d3             	mov    %rdx,%rbx
  8038ec:	48 63 d0             	movslq %eax,%rdx
  8038ef:	48 83 ea 01          	sub    $0x1,%rdx
  8038f3:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8038fa:	48 63 d0             	movslq %eax,%rdx
  8038fd:	49 89 d4             	mov    %rdx,%r12
  803900:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803906:	48 63 d0             	movslq %eax,%rdx
  803909:	49 89 d2             	mov    %rdx,%r10
  80390c:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803912:	48 98                	cltq   
  803914:	48 c1 e0 03          	shl    $0x3,%rax
  803918:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80391c:	b8 10 00 00 00       	mov    $0x10,%eax
  803921:	48 83 e8 01          	sub    $0x1,%rax
  803925:	48 01 d0             	add    %rdx,%rax
  803928:	be 10 00 00 00       	mov    $0x10,%esi
  80392d:	ba 00 00 00 00       	mov    $0x0,%edx
  803932:	48 f7 f6             	div    %rsi
  803935:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803939:	48 29 c4             	sub    %rax,%rsp
  80393c:	48 89 e0             	mov    %rsp,%rax
  80393f:	48 83 c0 07          	add    $0x7,%rax
  803943:	48 c1 e8 03          	shr    $0x3,%rax
  803947:	48 c1 e0 03          	shl    $0x3,%rax
  80394b:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803952:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803959:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803960:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803963:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803969:	8d 50 01             	lea    0x1(%rax),%edx
  80396c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803973:	48 63 d2             	movslq %edx,%rdx
  803976:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80397d:	00 

	va_start(vl, arg0);
  80397e:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803985:	00 00 00 
  803988:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80398f:	00 00 00 
  803992:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803996:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80399d:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8039a4:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8039ab:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8039b2:	00 00 00 
  8039b5:	eb 60                	jmp    803a17 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8039b7:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8039bd:	8d 48 01             	lea    0x1(%rax),%ecx
  8039c0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8039c6:	83 f8 30             	cmp    $0x30,%eax
  8039c9:	73 23                	jae    8039ee <spawnl+0x1fd>
  8039cb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8039d2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8039d8:	89 d2                	mov    %edx,%edx
  8039da:	48 01 d0             	add    %rdx,%rax
  8039dd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8039e3:	83 c2 08             	add    $0x8,%edx
  8039e6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8039ec:	eb 12                	jmp    803a00 <spawnl+0x20f>
  8039ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039f5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8039f9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803a00:	48 8b 10             	mov    (%rax),%rdx
  803a03:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803a0a:	89 c9                	mov    %ecx,%ecx
  803a0c:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803a10:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803a17:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803a1d:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  803a23:	72 92                	jb     8039b7 <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803a25:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a2c:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803a33:	48 89 d6             	mov    %rdx,%rsi
  803a36:	48 89 c7             	mov    %rax,%rdi
  803a39:	48 b8 99 34 80 00 00 	movabs $0x803499,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
  803a45:	48 89 dc             	mov    %rbx,%rsp
}
  803a48:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803a4c:	5b                   	pop    %rbx
  803a4d:	41 5c                	pop    %r12
  803a4f:	41 5d                	pop    %r13
  803a51:	5d                   	pop    %rbp
  803a52:	c3                   	retq   

0000000000803a53 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803a53:	55                   	push   %rbp
  803a54:	48 89 e5             	mov    %rsp,%rbp
  803a57:	48 83 ec 50          	sub    $0x50,%rsp
  803a5b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803a5e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803a62:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803a66:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a6d:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803a6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803a75:	eb 33                	jmp    803aaa <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803a77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a7a:	48 98                	cltq   
  803a7c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a83:	00 
  803a84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a88:	48 01 d0             	add    %rdx,%rax
  803a8b:	48 8b 00             	mov    (%rax),%rax
  803a8e:	48 89 c7             	mov    %rax,%rdi
  803a91:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803a98:	00 00 00 
  803a9b:	ff d0                	callq  *%rax
  803a9d:	83 c0 01             	add    $0x1,%eax
  803aa0:	48 98                	cltq   
  803aa2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803aa6:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803aaa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803aad:	48 98                	cltq   
  803aaf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ab6:	00 
  803ab7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803abb:	48 01 d0             	add    %rdx,%rax
  803abe:	48 8b 00             	mov    (%rax),%rax
  803ac1:	48 85 c0             	test   %rax,%rax
  803ac4:	75 b1                	jne    803a77 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803ac6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aca:	48 f7 d8             	neg    %rax
  803acd:	48 05 00 10 40 00    	add    $0x401000,%rax
  803ad3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803ad7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803adb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803adf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae3:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803ae7:	48 89 c2             	mov    %rax,%rdx
  803aea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803aed:	83 c0 01             	add    $0x1,%eax
  803af0:	c1 e0 03             	shl    $0x3,%eax
  803af3:	48 98                	cltq   
  803af5:	48 f7 d8             	neg    %rax
  803af8:	48 01 d0             	add    %rdx,%rax
  803afb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803aff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b03:	48 83 e8 10          	sub    $0x10,%rax
  803b07:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803b0d:	77 0a                	ja     803b19 <init_stack+0xc6>
		return -E_NO_MEM;
  803b0f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803b14:	e9 e4 01 00 00       	jmpq   803cfd <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803b19:	ba 07 00 00 00       	mov    $0x7,%edx
  803b1e:	be 00 00 40 00       	mov    $0x400000,%esi
  803b23:	bf 00 00 00 00       	mov    $0x0,%edi
  803b28:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b37:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b3b:	79 08                	jns    803b45 <init_stack+0xf2>
		return r;
  803b3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b40:	e9 b8 01 00 00       	jmpq   803cfd <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803b45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803b4c:	e9 8a 00 00 00       	jmpq   803bdb <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  803b51:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b54:	48 98                	cltq   
  803b56:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b5d:	00 
  803b5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b62:	48 01 d0             	add    %rdx,%rax
  803b65:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b6e:	48 01 ca             	add    %rcx,%rdx
  803b71:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803b78:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803b7b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b7e:	48 98                	cltq   
  803b80:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b87:	00 
  803b88:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b8c:	48 01 d0             	add    %rdx,%rax
  803b8f:	48 8b 10             	mov    (%rax),%rdx
  803b92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b96:	48 89 d6             	mov    %rdx,%rsi
  803b99:	48 89 c7             	mov    %rax,%rdi
  803b9c:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803ba8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bab:	48 98                	cltq   
  803bad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bb4:	00 
  803bb5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803bb9:	48 01 d0             	add    %rdx,%rax
  803bbc:	48 8b 00             	mov    (%rax),%rax
  803bbf:	48 89 c7             	mov    %rax,%rdi
  803bc2:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
  803bce:	83 c0 01             	add    $0x1,%eax
  803bd1:	48 98                	cltq   
  803bd3:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803bd7:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803bdb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bde:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803be1:	0f 8c 6a ff ff ff    	jl     803b51 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803be7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bea:	48 98                	cltq   
  803bec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bf3:	00 
  803bf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf8:	48 01 d0             	add    %rdx,%rax
  803bfb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803c02:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803c09:	00 
  803c0a:	74 35                	je     803c41 <init_stack+0x1ee>
  803c0c:	48 b9 98 5e 80 00 00 	movabs $0x805e98,%rcx
  803c13:	00 00 00 
  803c16:	48 ba be 5e 80 00 00 	movabs $0x805ebe,%rdx
  803c1d:	00 00 00 
  803c20:	be f6 00 00 00       	mov    $0xf6,%esi
  803c25:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803c2c:	00 00 00 
  803c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c34:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803c3b:	00 00 00 
  803c3e:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803c41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c45:	48 83 e8 08          	sub    $0x8,%rax
  803c49:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c4e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803c52:	48 01 ca             	add    %rcx,%rdx
  803c55:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803c5c:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  803c5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c63:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803c67:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c6a:	48 98                	cltq   
  803c6c:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803c6f:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803c74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c78:	48 01 d0             	add    %rdx,%rax
  803c7b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c81:	48 89 c2             	mov    %rax,%rdx
  803c84:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803c88:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803c8b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803c8e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803c94:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c99:	89 c2                	mov    %eax,%edx
  803c9b:	be 00 00 40 00       	mov    $0x400000,%esi
  803ca0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca5:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
  803cb1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb8:	78 26                	js     803ce0 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803cba:	be 00 00 40 00       	mov    $0x400000,%esi
  803cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc4:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
  803cd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd7:	78 0a                	js     803ce3 <init_stack+0x290>
		goto error;

	return 0;
  803cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cde:	eb 1d                	jmp    803cfd <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803ce0:	90                   	nop
  803ce1:	eb 01                	jmp    803ce4 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803ce3:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803ce4:	be 00 00 40 00       	mov    $0x400000,%esi
  803ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cee:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
	return r;
  803cfa:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803cfd:	c9                   	leaveq 
  803cfe:	c3                   	retq   

0000000000803cff <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803cff:	55                   	push   %rbp
  803d00:	48 89 e5             	mov    %rsp,%rbp
  803d03:	48 83 ec 50          	sub    $0x50,%rsp
  803d07:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d0e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803d12:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803d15:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803d19:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803d1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d21:	25 ff 0f 00 00       	and    $0xfff,%eax
  803d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2d:	74 21                	je     803d50 <map_segment+0x51>
		va -= i;
  803d2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d32:	48 98                	cltq   
  803d34:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3b:	48 98                	cltq   
  803d3d:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803d41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d44:	48 98                	cltq   
  803d46:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4d:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803d50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d57:	e9 79 01 00 00       	jmpq   803ed5 <map_segment+0x1d6>
		if (i >= filesz) {
  803d5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5f:	48 98                	cltq   
  803d61:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803d65:	72 3c                	jb     803da3 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6a:	48 63 d0             	movslq %eax,%rdx
  803d6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d71:	48 01 d0             	add    %rdx,%rax
  803d74:	48 89 c1             	mov    %rax,%rcx
  803d77:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d7a:	8b 55 10             	mov    0x10(%rbp),%edx
  803d7d:	48 89 ce             	mov    %rcx,%rsi
  803d80:	89 c7                	mov    %eax,%edi
  803d82:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
  803d8e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d91:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d95:	0f 89 33 01 00 00    	jns    803ece <map_segment+0x1cf>
				return r;
  803d9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d9e:	e9 46 01 00 00       	jmpq   803ee9 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803da3:	ba 07 00 00 00       	mov    $0x7,%edx
  803da8:	be 00 00 40 00       	mov    $0x400000,%esi
  803dad:	bf 00 00 00 00       	mov    $0x0,%edi
  803db2:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	callq  *%rax
  803dbe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803dc1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803dc5:	79 08                	jns    803dcf <map_segment+0xd0>
				return r;
  803dc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dca:	e9 1a 01 00 00       	jmpq   803ee9 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803dcf:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd5:	01 c2                	add    %eax,%edx
  803dd7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803dda:	89 d6                	mov    %edx,%esi
  803ddc:	89 c7                	mov    %eax,%edi
  803dde:	48 b8 a0 2b 80 00 00 	movabs $0x802ba0,%rax
  803de5:	00 00 00 
  803de8:	ff d0                	callq  *%rax
  803dea:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ded:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803df1:	79 08                	jns    803dfb <map_segment+0xfc>
				return r;
  803df3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df6:	e9 ee 00 00 00       	jmpq   803ee9 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803dfb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e05:	48 98                	cltq   
  803e07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803e0b:	48 29 c2             	sub    %rax,%rdx
  803e0e:	48 89 d0             	mov    %rdx,%rax
  803e11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803e15:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e18:	48 63 d0             	movslq %eax,%rdx
  803e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e1f:	48 39 c2             	cmp    %rax,%rdx
  803e22:	48 0f 47 d0          	cmova  %rax,%rdx
  803e26:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803e29:	be 00 00 40 00       	mov    $0x400000,%esi
  803e2e:	89 c7                	mov    %eax,%edi
  803e30:	48 b8 56 2a 80 00 00 	movabs $0x802a56,%rax
  803e37:	00 00 00 
  803e3a:	ff d0                	callq  *%rax
  803e3c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e3f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e43:	79 08                	jns    803e4d <map_segment+0x14e>
				return r;
  803e45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e48:	e9 9c 00 00 00       	jmpq   803ee9 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803e4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e50:	48 63 d0             	movslq %eax,%rdx
  803e53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e57:	48 01 d0             	add    %rdx,%rax
  803e5a:	48 89 c2             	mov    %rax,%rdx
  803e5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e60:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803e64:	48 89 d1             	mov    %rdx,%rcx
  803e67:	89 c2                	mov    %eax,%edx
  803e69:	be 00 00 40 00       	mov    $0x400000,%esi
  803e6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e73:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803e7a:	00 00 00 
  803e7d:	ff d0                	callq  *%rax
  803e7f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e82:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e86:	79 30                	jns    803eb8 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803e88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e8b:	89 c1                	mov    %eax,%ecx
  803e8d:	48 ba d3 5e 80 00 00 	movabs $0x805ed3,%rdx
  803e94:	00 00 00 
  803e97:	be 29 01 00 00       	mov    $0x129,%esi
  803e9c:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803ea3:	00 00 00 
  803ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  803eab:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  803eb2:	00 00 00 
  803eb5:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803eb8:	be 00 00 40 00       	mov    $0x400000,%esi
  803ebd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec2:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803ec9:	00 00 00 
  803ecc:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803ece:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803ed5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed8:	48 98                	cltq   
  803eda:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ede:	0f 82 78 fe ff ff    	jb     803d5c <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ee9:	c9                   	leaveq 
  803eea:	c3                   	retq   

0000000000803eeb <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803eeb:	55                   	push   %rbp
  803eec:	48 89 e5             	mov    %rsp,%rbp
  803eef:	48 83 ec 30          	sub    $0x30,%rsp
  803ef3:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803ef6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803efd:	00 
  803efe:	e9 eb 00 00 00       	jmpq   803fee <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f07:	48 c1 f8 12          	sar    $0x12,%rax
  803f0b:	48 89 c2             	mov    %rax,%rdx
  803f0e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803f15:	01 00 00 
  803f18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f1c:	83 e0 01             	and    $0x1,%eax
  803f1f:	48 85 c0             	test   %rax,%rax
  803f22:	74 21                	je     803f45 <copy_shared_pages+0x5a>
  803f24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f28:	48 c1 f8 09          	sar    $0x9,%rax
  803f2c:	48 89 c2             	mov    %rax,%rdx
  803f2f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f36:	01 00 00 
  803f39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f3d:	83 e0 01             	and    $0x1,%eax
  803f40:	48 85 c0             	test   %rax,%rax
  803f43:	75 0d                	jne    803f52 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  803f45:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  803f4c:	00 
  803f4d:	e9 9c 00 00 00       	jmpq   803fee <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  803f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f56:	48 05 00 02 00 00    	add    $0x200,%rax
  803f5c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  803f60:	eb 7e                	jmp    803fe0 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  803f62:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f69:	01 00 00 
  803f6c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f74:	25 01 04 00 00       	and    $0x401,%eax
  803f79:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  803f7f:	75 5a                	jne    803fdb <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  803f81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f85:	48 c1 e0 0c          	shl    $0xc,%rax
  803f89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  803f8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f94:	01 00 00 
  803f97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f9f:	25 07 0e 00 00       	and    $0xe07,%eax
  803fa4:	89 c6                	mov    %eax,%esi
  803fa6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803faa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb1:	41 89 f0             	mov    %esi,%r8d
  803fb4:	48 89 c6             	mov    %rax,%rsi
  803fb7:	bf 00 00 00 00       	mov    $0x0,%edi
  803fbc:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803fc3:	00 00 00 
  803fc6:	ff d0                	callq  *%rax
  803fc8:	48 98                	cltq   
  803fca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  803fce:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fd3:	79 06                	jns    803fdb <copy_shared_pages+0xf0>
						return r;
  803fd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fd9:	eb 28                	jmp    804003 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803fdb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803fe8:	0f 8c 74 ff ff ff    	jl     803f62 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff2:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  803ff8:	0f 86 05 ff ff ff    	jbe    803f03 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804003:	c9                   	leaveq 
  804004:	c3                   	retq   

0000000000804005 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  804005:	55                   	push   %rbp
  804006:	48 89 e5             	mov    %rsp,%rbp
  804009:	48 83 ec 20          	sub    $0x20,%rsp
  80400d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804010:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804014:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804017:	48 89 d6             	mov    %rdx,%rsi
  80401a:	89 c7                	mov    %eax,%edi
  80401c:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  804023:	00 00 00 
  804026:	ff d0                	callq  *%rax
  804028:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80402b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402f:	79 05                	jns    804036 <fd2sockid+0x31>
		return r;
  804031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804034:	eb 24                	jmp    80405a <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  804036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403a:	8b 10                	mov    (%rax),%edx
  80403c:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  804043:	00 00 00 
  804046:	8b 00                	mov    (%rax),%eax
  804048:	39 c2                	cmp    %eax,%edx
  80404a:	74 07                	je     804053 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80404c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804051:	eb 07                	jmp    80405a <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  804053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804057:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80405a:	c9                   	leaveq 
  80405b:	c3                   	retq   

000000000080405c <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80405c:	55                   	push   %rbp
  80405d:	48 89 e5             	mov    %rsp,%rbp
  804060:	48 83 ec 20          	sub    $0x20,%rsp
  804064:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  804067:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80406b:	48 89 c7             	mov    %rax,%rdi
  80406e:	48 b8 b4 24 80 00 00 	movabs $0x8024b4,%rax
  804075:	00 00 00 
  804078:	ff d0                	callq  *%rax
  80407a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80407d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804081:	78 26                	js     8040a9 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  804083:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804087:	ba 07 04 00 00       	mov    $0x407,%edx
  80408c:	48 89 c6             	mov    %rax,%rsi
  80408f:	bf 00 00 00 00       	mov    $0x0,%edi
  804094:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  80409b:	00 00 00 
  80409e:	ff d0                	callq  *%rax
  8040a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a7:	79 16                	jns    8040bf <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8040a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ac:	89 c7                	mov    %eax,%edi
  8040ae:	48 b8 6b 45 80 00 00 	movabs $0x80456b,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
		return r;
  8040ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bd:	eb 3a                	jmp    8040f9 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8040bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c3:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  8040ca:	00 00 00 
  8040cd:	8b 12                	mov    (%rdx),%edx
  8040cf:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8040d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8040dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040e3:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8040e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ea:	48 89 c7             	mov    %rax,%rdi
  8040ed:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  8040f4:	00 00 00 
  8040f7:	ff d0                	callq  *%rax
}
  8040f9:	c9                   	leaveq 
  8040fa:	c3                   	retq   

00000000008040fb <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8040fb:	55                   	push   %rbp
  8040fc:	48 89 e5             	mov    %rsp,%rbp
  8040ff:	48 83 ec 30          	sub    $0x30,%rsp
  804103:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804106:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80410a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80410e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804111:	89 c7                	mov    %eax,%edi
  804113:	48 b8 05 40 80 00 00 	movabs $0x804005,%rax
  80411a:	00 00 00 
  80411d:	ff d0                	callq  *%rax
  80411f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804122:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804126:	79 05                	jns    80412d <accept+0x32>
		return r;
  804128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80412b:	eb 3b                	jmp    804168 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80412d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804131:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804138:	48 89 ce             	mov    %rcx,%rsi
  80413b:	89 c7                	mov    %eax,%edi
  80413d:	48 b8 48 44 80 00 00 	movabs $0x804448,%rax
  804144:	00 00 00 
  804147:	ff d0                	callq  *%rax
  804149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80414c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804150:	79 05                	jns    804157 <accept+0x5c>
		return r;
  804152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804155:	eb 11                	jmp    804168 <accept+0x6d>
	return alloc_sockfd(r);
  804157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415a:	89 c7                	mov    %eax,%edi
  80415c:	48 b8 5c 40 80 00 00 	movabs $0x80405c,%rax
  804163:	00 00 00 
  804166:	ff d0                	callq  *%rax
}
  804168:	c9                   	leaveq 
  804169:	c3                   	retq   

000000000080416a <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80416a:	55                   	push   %rbp
  80416b:	48 89 e5             	mov    %rsp,%rbp
  80416e:	48 83 ec 20          	sub    $0x20,%rsp
  804172:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804175:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804179:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80417c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80417f:	89 c7                	mov    %eax,%edi
  804181:	48 b8 05 40 80 00 00 	movabs $0x804005,%rax
  804188:	00 00 00 
  80418b:	ff d0                	callq  *%rax
  80418d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804194:	79 05                	jns    80419b <bind+0x31>
		return r;
  804196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804199:	eb 1b                	jmp    8041b6 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80419b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80419e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8041a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a5:	48 89 ce             	mov    %rcx,%rsi
  8041a8:	89 c7                	mov    %eax,%edi
  8041aa:	48 b8 c7 44 80 00 00 	movabs $0x8044c7,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
}
  8041b6:	c9                   	leaveq 
  8041b7:	c3                   	retq   

00000000008041b8 <shutdown>:

int
shutdown(int s, int how)
{
  8041b8:	55                   	push   %rbp
  8041b9:	48 89 e5             	mov    %rsp,%rbp
  8041bc:	48 83 ec 20          	sub    $0x20,%rsp
  8041c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041c3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c9:	89 c7                	mov    %eax,%edi
  8041cb:	48 b8 05 40 80 00 00 	movabs $0x804005,%rax
  8041d2:	00 00 00 
  8041d5:	ff d0                	callq  *%rax
  8041d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041de:	79 05                	jns    8041e5 <shutdown+0x2d>
		return r;
  8041e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e3:	eb 16                	jmp    8041fb <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8041e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041eb:	89 d6                	mov    %edx,%esi
  8041ed:	89 c7                	mov    %eax,%edi
  8041ef:	48 b8 2b 45 80 00 00 	movabs $0x80452b,%rax
  8041f6:	00 00 00 
  8041f9:	ff d0                	callq  *%rax
}
  8041fb:	c9                   	leaveq 
  8041fc:	c3                   	retq   

00000000008041fd <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8041fd:	55                   	push   %rbp
  8041fe:	48 89 e5             	mov    %rsp,%rbp
  804201:	48 83 ec 10          	sub    $0x10,%rsp
  804205:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420d:	48 89 c7             	mov    %rax,%rdi
  804210:	48 b8 7d 55 80 00 00 	movabs $0x80557d,%rax
  804217:	00 00 00 
  80421a:	ff d0                	callq  *%rax
  80421c:	83 f8 01             	cmp    $0x1,%eax
  80421f:	75 17                	jne    804238 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804225:	8b 40 0c             	mov    0xc(%rax),%eax
  804228:	89 c7                	mov    %eax,%edi
  80422a:	48 b8 6b 45 80 00 00 	movabs $0x80456b,%rax
  804231:	00 00 00 
  804234:	ff d0                	callq  *%rax
  804236:	eb 05                	jmp    80423d <devsock_close+0x40>
	else
		return 0;
  804238:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80423d:	c9                   	leaveq 
  80423e:	c3                   	retq   

000000000080423f <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80423f:	55                   	push   %rbp
  804240:	48 89 e5             	mov    %rsp,%rbp
  804243:	48 83 ec 20          	sub    $0x20,%rsp
  804247:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80424a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80424e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804251:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804254:	89 c7                	mov    %eax,%edi
  804256:	48 b8 05 40 80 00 00 	movabs $0x804005,%rax
  80425d:	00 00 00 
  804260:	ff d0                	callq  *%rax
  804262:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804265:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804269:	79 05                	jns    804270 <connect+0x31>
		return r;
  80426b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80426e:	eb 1b                	jmp    80428b <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804270:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804273:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427a:	48 89 ce             	mov    %rcx,%rsi
  80427d:	89 c7                	mov    %eax,%edi
  80427f:	48 b8 98 45 80 00 00 	movabs $0x804598,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
}
  80428b:	c9                   	leaveq 
  80428c:	c3                   	retq   

000000000080428d <listen>:

int
listen(int s, int backlog)
{
  80428d:	55                   	push   %rbp
  80428e:	48 89 e5             	mov    %rsp,%rbp
  804291:	48 83 ec 20          	sub    $0x20,%rsp
  804295:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804298:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80429b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80429e:	89 c7                	mov    %eax,%edi
  8042a0:	48 b8 05 40 80 00 00 	movabs $0x804005,%rax
  8042a7:	00 00 00 
  8042aa:	ff d0                	callq  *%rax
  8042ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b3:	79 05                	jns    8042ba <listen+0x2d>
		return r;
  8042b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b8:	eb 16                	jmp    8042d0 <listen+0x43>
	return nsipc_listen(r, backlog);
  8042ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8042bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c0:	89 d6                	mov    %edx,%esi
  8042c2:	89 c7                	mov    %eax,%edi
  8042c4:	48 b8 fc 45 80 00 00 	movabs $0x8045fc,%rax
  8042cb:	00 00 00 
  8042ce:	ff d0                	callq  *%rax
}
  8042d0:	c9                   	leaveq 
  8042d1:	c3                   	retq   

00000000008042d2 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8042d2:	55                   	push   %rbp
  8042d3:	48 89 e5             	mov    %rsp,%rbp
  8042d6:	48 83 ec 20          	sub    $0x20,%rsp
  8042da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8042e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ea:	89 c2                	mov    %eax,%edx
  8042ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f0:	8b 40 0c             	mov    0xc(%rax),%eax
  8042f3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8042f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8042fc:	89 c7                	mov    %eax,%edi
  8042fe:	48 b8 3c 46 80 00 00 	movabs $0x80463c,%rax
  804305:	00 00 00 
  804308:	ff d0                	callq  *%rax
}
  80430a:	c9                   	leaveq 
  80430b:	c3                   	retq   

000000000080430c <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80430c:	55                   	push   %rbp
  80430d:	48 89 e5             	mov    %rsp,%rbp
  804310:	48 83 ec 20          	sub    $0x20,%rsp
  804314:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804318:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80431c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804324:	89 c2                	mov    %eax,%edx
  804326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80432a:	8b 40 0c             	mov    0xc(%rax),%eax
  80432d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804331:	b9 00 00 00 00       	mov    $0x0,%ecx
  804336:	89 c7                	mov    %eax,%edi
  804338:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  80433f:	00 00 00 
  804342:	ff d0                	callq  *%rax
}
  804344:	c9                   	leaveq 
  804345:	c3                   	retq   

0000000000804346 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804346:	55                   	push   %rbp
  804347:	48 89 e5             	mov    %rsp,%rbp
  80434a:	48 83 ec 10          	sub    $0x10,%rsp
  80434e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  804356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80435a:	48 be f5 5e 80 00 00 	movabs $0x805ef5,%rsi
  804361:	00 00 00 
  804364:	48 89 c7             	mov    %rax,%rdi
  804367:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  80436e:	00 00 00 
  804371:	ff d0                	callq  *%rax
	return 0;
  804373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804378:	c9                   	leaveq 
  804379:	c3                   	retq   

000000000080437a <socket>:

int
socket(int domain, int type, int protocol)
{
  80437a:	55                   	push   %rbp
  80437b:	48 89 e5             	mov    %rsp,%rbp
  80437e:	48 83 ec 20          	sub    $0x20,%rsp
  804382:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804385:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804388:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80438b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80438e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804391:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804394:	89 ce                	mov    %ecx,%esi
  804396:	89 c7                	mov    %eax,%edi
  804398:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  80439f:	00 00 00 
  8043a2:	ff d0                	callq  *%rax
  8043a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ab:	79 05                	jns    8043b2 <socket+0x38>
		return r;
  8043ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b0:	eb 11                	jmp    8043c3 <socket+0x49>
	return alloc_sockfd(r);
  8043b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b5:	89 c7                	mov    %eax,%edi
  8043b7:	48 b8 5c 40 80 00 00 	movabs $0x80405c,%rax
  8043be:	00 00 00 
  8043c1:	ff d0                	callq  *%rax
}
  8043c3:	c9                   	leaveq 
  8043c4:	c3                   	retq   

00000000008043c5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8043c5:	55                   	push   %rbp
  8043c6:	48 89 e5             	mov    %rsp,%rbp
  8043c9:	48 83 ec 10          	sub    $0x10,%rsp
  8043cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8043d0:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8043d7:	00 00 00 
  8043da:	8b 00                	mov    (%rax),%eax
  8043dc:	85 c0                	test   %eax,%eax
  8043de:	75 1f                	jne    8043ff <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8043e0:	bf 02 00 00 00       	mov    $0x2,%edi
  8043e5:	48 b8 0c 55 80 00 00 	movabs $0x80550c,%rax
  8043ec:	00 00 00 
  8043ef:	ff d0                	callq  *%rax
  8043f1:	89 c2                	mov    %eax,%edx
  8043f3:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8043fa:	00 00 00 
  8043fd:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8043ff:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804406:	00 00 00 
  804409:	8b 00                	mov    (%rax),%eax
  80440b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80440e:	b9 07 00 00 00       	mov    $0x7,%ecx
  804413:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80441a:	00 00 00 
  80441d:	89 c7                	mov    %eax,%edi
  80441f:	48 b8 00 53 80 00 00 	movabs $0x805300,%rax
  804426:	00 00 00 
  804429:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80442b:	ba 00 00 00 00       	mov    $0x0,%edx
  804430:	be 00 00 00 00       	mov    $0x0,%esi
  804435:	bf 00 00 00 00       	mov    $0x0,%edi
  80443a:	48 b8 3f 52 80 00 00 	movabs $0x80523f,%rax
  804441:	00 00 00 
  804444:	ff d0                	callq  *%rax
}
  804446:	c9                   	leaveq 
  804447:	c3                   	retq   

0000000000804448 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804448:	55                   	push   %rbp
  804449:	48 89 e5             	mov    %rsp,%rbp
  80444c:	48 83 ec 30          	sub    $0x30,%rsp
  804450:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804453:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804457:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80445b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804462:	00 00 00 
  804465:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804468:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80446a:	bf 01 00 00 00       	mov    $0x1,%edi
  80446f:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
  80447b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80447e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804482:	78 3e                	js     8044c2 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804484:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80448b:	00 00 00 
  80448e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804496:	8b 40 10             	mov    0x10(%rax),%eax
  804499:	89 c2                	mov    %eax,%edx
  80449b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80449f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a3:	48 89 ce             	mov    %rcx,%rsi
  8044a6:	48 89 c7             	mov    %rax,%rdi
  8044a9:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8044b0:	00 00 00 
  8044b3:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8044b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b9:	8b 50 10             	mov    0x10(%rax),%edx
  8044bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c0:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8044c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044c5:	c9                   	leaveq 
  8044c6:	c3                   	retq   

00000000008044c7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8044c7:	55                   	push   %rbp
  8044c8:	48 89 e5             	mov    %rsp,%rbp
  8044cb:	48 83 ec 10          	sub    $0x10,%rsp
  8044cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044d6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8044d9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044e0:	00 00 00 
  8044e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044e6:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8044e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ef:	48 89 c6             	mov    %rax,%rsi
  8044f2:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8044f9:	00 00 00 
  8044fc:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  804503:	00 00 00 
  804506:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804508:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80450f:	00 00 00 
  804512:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804515:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804518:	bf 02 00 00 00       	mov    $0x2,%edi
  80451d:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  804524:	00 00 00 
  804527:	ff d0                	callq  *%rax
}
  804529:	c9                   	leaveq 
  80452a:	c3                   	retq   

000000000080452b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80452b:	55                   	push   %rbp
  80452c:	48 89 e5             	mov    %rsp,%rbp
  80452f:	48 83 ec 10          	sub    $0x10,%rsp
  804533:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804536:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804539:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804540:	00 00 00 
  804543:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804546:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804548:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80454f:	00 00 00 
  804552:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804555:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804558:	bf 03 00 00 00       	mov    $0x3,%edi
  80455d:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  804564:	00 00 00 
  804567:	ff d0                	callq  *%rax
}
  804569:	c9                   	leaveq 
  80456a:	c3                   	retq   

000000000080456b <nsipc_close>:

int
nsipc_close(int s)
{
  80456b:	55                   	push   %rbp
  80456c:	48 89 e5             	mov    %rsp,%rbp
  80456f:	48 83 ec 10          	sub    $0x10,%rsp
  804573:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804576:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80457d:	00 00 00 
  804580:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804583:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804585:	bf 04 00 00 00       	mov    $0x4,%edi
  80458a:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  804591:	00 00 00 
  804594:	ff d0                	callq  *%rax
}
  804596:	c9                   	leaveq 
  804597:	c3                   	retq   

0000000000804598 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804598:	55                   	push   %rbp
  804599:	48 89 e5             	mov    %rsp,%rbp
  80459c:	48 83 ec 10          	sub    $0x10,%rsp
  8045a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8045a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8045aa:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045b1:	00 00 00 
  8045b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8045b7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8045b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c0:	48 89 c6             	mov    %rax,%rsi
  8045c3:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8045ca:	00 00 00 
  8045cd:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8045d4:	00 00 00 
  8045d7:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8045d9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045e0:	00 00 00 
  8045e3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045e6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8045e9:	bf 05 00 00 00       	mov    $0x5,%edi
  8045ee:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  8045f5:	00 00 00 
  8045f8:	ff d0                	callq  *%rax
}
  8045fa:	c9                   	leaveq 
  8045fb:	c3                   	retq   

00000000008045fc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8045fc:	55                   	push   %rbp
  8045fd:	48 89 e5             	mov    %rsp,%rbp
  804600:	48 83 ec 10          	sub    $0x10,%rsp
  804604:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804607:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80460a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804611:	00 00 00 
  804614:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804617:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804619:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804620:	00 00 00 
  804623:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804626:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804629:	bf 06 00 00 00       	mov    $0x6,%edi
  80462e:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  804635:	00 00 00 
  804638:	ff d0                	callq  *%rax
}
  80463a:	c9                   	leaveq 
  80463b:	c3                   	retq   

000000000080463c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80463c:	55                   	push   %rbp
  80463d:	48 89 e5             	mov    %rsp,%rbp
  804640:	48 83 ec 30          	sub    $0x30,%rsp
  804644:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804647:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80464b:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80464e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804651:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804658:	00 00 00 
  80465b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80465e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804660:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804667:	00 00 00 
  80466a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80466d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804670:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804677:	00 00 00 
  80467a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80467d:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804680:	bf 07 00 00 00       	mov    $0x7,%edi
  804685:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  80468c:	00 00 00 
  80468f:	ff d0                	callq  *%rax
  804691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804698:	78 69                	js     804703 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80469a:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8046a1:	7f 08                	jg     8046ab <nsipc_recv+0x6f>
  8046a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a6:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8046a9:	7e 35                	jle    8046e0 <nsipc_recv+0xa4>
  8046ab:	48 b9 fc 5e 80 00 00 	movabs $0x805efc,%rcx
  8046b2:	00 00 00 
  8046b5:	48 ba 11 5f 80 00 00 	movabs $0x805f11,%rdx
  8046bc:	00 00 00 
  8046bf:	be 62 00 00 00       	mov    $0x62,%esi
  8046c4:	48 bf 26 5f 80 00 00 	movabs $0x805f26,%rdi
  8046cb:	00 00 00 
  8046ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d3:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8046da:	00 00 00 
  8046dd:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8046e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046e3:	48 63 d0             	movslq %eax,%rdx
  8046e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046ea:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  8046f1:	00 00 00 
  8046f4:	48 89 c7             	mov    %rax,%rdi
  8046f7:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  8046fe:	00 00 00 
  804701:	ff d0                	callq  *%rax
	}

	return r;
  804703:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804706:	c9                   	leaveq 
  804707:	c3                   	retq   

0000000000804708 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804708:	55                   	push   %rbp
  804709:	48 89 e5             	mov    %rsp,%rbp
  80470c:	48 83 ec 20          	sub    $0x20,%rsp
  804710:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804713:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804717:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80471a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80471d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804724:	00 00 00 
  804727:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80472a:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80472c:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804733:	7e 35                	jle    80476a <nsipc_send+0x62>
  804735:	48 b9 32 5f 80 00 00 	movabs $0x805f32,%rcx
  80473c:	00 00 00 
  80473f:	48 ba 11 5f 80 00 00 	movabs $0x805f11,%rdx
  804746:	00 00 00 
  804749:	be 6d 00 00 00       	mov    $0x6d,%esi
  80474e:	48 bf 26 5f 80 00 00 	movabs $0x805f26,%rdi
  804755:	00 00 00 
  804758:	b8 00 00 00 00       	mov    $0x0,%eax
  80475d:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  804764:	00 00 00 
  804767:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80476a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80476d:	48 63 d0             	movslq %eax,%rdx
  804770:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804774:	48 89 c6             	mov    %rax,%rsi
  804777:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  80477e:	00 00 00 
  804781:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  804788:	00 00 00 
  80478b:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80478d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804794:	00 00 00 
  804797:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80479a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80479d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047a4:	00 00 00 
  8047a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8047aa:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8047ad:	bf 08 00 00 00       	mov    $0x8,%edi
  8047b2:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  8047b9:	00 00 00 
  8047bc:	ff d0                	callq  *%rax
}
  8047be:	c9                   	leaveq 
  8047bf:	c3                   	retq   

00000000008047c0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8047c0:	55                   	push   %rbp
  8047c1:	48 89 e5             	mov    %rsp,%rbp
  8047c4:	48 83 ec 10          	sub    $0x10,%rsp
  8047c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8047cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8047ce:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8047d1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047d8:	00 00 00 
  8047db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8047de:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8047e0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047e7:	00 00 00 
  8047ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8047ed:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8047f0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047f7:	00 00 00 
  8047fa:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8047fd:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804800:	bf 09 00 00 00       	mov    $0x9,%edi
  804805:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  80480c:	00 00 00 
  80480f:	ff d0                	callq  *%rax
}
  804811:	c9                   	leaveq 
  804812:	c3                   	retq   

0000000000804813 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804813:	55                   	push   %rbp
  804814:	48 89 e5             	mov    %rsp,%rbp
  804817:	53                   	push   %rbx
  804818:	48 83 ec 38          	sub    $0x38,%rsp
  80481c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804820:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804824:	48 89 c7             	mov    %rax,%rdi
  804827:	48 b8 b4 24 80 00 00 	movabs $0x8024b4,%rax
  80482e:	00 00 00 
  804831:	ff d0                	callq  *%rax
  804833:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804836:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80483a:	0f 88 bf 01 00 00    	js     8049ff <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804844:	ba 07 04 00 00       	mov    $0x407,%edx
  804849:	48 89 c6             	mov    %rax,%rsi
  80484c:	bf 00 00 00 00       	mov    $0x0,%edi
  804851:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  804858:	00 00 00 
  80485b:	ff d0                	callq  *%rax
  80485d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804860:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804864:	0f 88 95 01 00 00    	js     8049ff <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80486a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80486e:	48 89 c7             	mov    %rax,%rdi
  804871:	48 b8 b4 24 80 00 00 	movabs $0x8024b4,%rax
  804878:	00 00 00 
  80487b:	ff d0                	callq  *%rax
  80487d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804880:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804884:	0f 88 5d 01 00 00    	js     8049e7 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80488a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80488e:	ba 07 04 00 00       	mov    $0x407,%edx
  804893:	48 89 c6             	mov    %rax,%rsi
  804896:	bf 00 00 00 00       	mov    $0x0,%edi
  80489b:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  8048a2:	00 00 00 
  8048a5:	ff d0                	callq  *%rax
  8048a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048ae:	0f 88 33 01 00 00    	js     8049e7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8048b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048b8:	48 89 c7             	mov    %rax,%rdi
  8048bb:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  8048c2:	00 00 00 
  8048c5:	ff d0                	callq  *%rax
  8048c7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8048cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048cf:	ba 07 04 00 00       	mov    $0x407,%edx
  8048d4:	48 89 c6             	mov    %rax,%rsi
  8048d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8048dc:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  8048e3:	00 00 00 
  8048e6:	ff d0                	callq  *%rax
  8048e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048ef:	0f 88 d9 00 00 00    	js     8049ce <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8048f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048f9:	48 89 c7             	mov    %rax,%rdi
  8048fc:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  804903:	00 00 00 
  804906:	ff d0                	callq  *%rax
  804908:	48 89 c2             	mov    %rax,%rdx
  80490b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80490f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804915:	48 89 d1             	mov    %rdx,%rcx
  804918:	ba 00 00 00 00       	mov    $0x0,%edx
  80491d:	48 89 c6             	mov    %rax,%rsi
  804920:	bf 00 00 00 00       	mov    $0x0,%edi
  804925:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  80492c:	00 00 00 
  80492f:	ff d0                	callq  *%rax
  804931:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804934:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804938:	78 79                	js     8049b3 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80493a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80493e:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  804945:	00 00 00 
  804948:	8b 12                	mov    (%rdx),%edx
  80494a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80494c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804950:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804957:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80495b:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  804962:	00 00 00 
  804965:	8b 12                	mov    (%rdx),%edx
  804967:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804969:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80496d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804974:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804978:	48 89 c7             	mov    %rax,%rdi
  80497b:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  804982:	00 00 00 
  804985:	ff d0                	callq  *%rax
  804987:	89 c2                	mov    %eax,%edx
  804989:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80498d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80498f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804993:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804997:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80499b:	48 89 c7             	mov    %rax,%rdi
  80499e:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  8049a5:	00 00 00 
  8049a8:	ff d0                	callq  *%rax
  8049aa:	89 03                	mov    %eax,(%rbx)
	return 0;
  8049ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8049b1:	eb 4f                	jmp    804a02 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8049b3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8049b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049b8:	48 89 c6             	mov    %rax,%rsi
  8049bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8049c0:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  8049c7:	00 00 00 
  8049ca:	ff d0                	callq  *%rax
  8049cc:	eb 01                	jmp    8049cf <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8049ce:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8049cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049d3:	48 89 c6             	mov    %rax,%rsi
  8049d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8049db:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  8049e2:	00 00 00 
  8049e5:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8049e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049eb:	48 89 c6             	mov    %rax,%rsi
  8049ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8049f3:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  8049fa:	00 00 00 
  8049fd:	ff d0                	callq  *%rax
err:
	return r;
  8049ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804a02:	48 83 c4 38          	add    $0x38,%rsp
  804a06:	5b                   	pop    %rbx
  804a07:	5d                   	pop    %rbp
  804a08:	c3                   	retq   

0000000000804a09 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804a09:	55                   	push   %rbp
  804a0a:	48 89 e5             	mov    %rsp,%rbp
  804a0d:	53                   	push   %rbx
  804a0e:	48 83 ec 28          	sub    $0x28,%rsp
  804a12:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a16:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804a1a:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804a21:	00 00 00 
  804a24:	48 8b 00             	mov    (%rax),%rax
  804a27:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804a30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a34:	48 89 c7             	mov    %rax,%rdi
  804a37:	48 b8 7d 55 80 00 00 	movabs $0x80557d,%rax
  804a3e:	00 00 00 
  804a41:	ff d0                	callq  *%rax
  804a43:	89 c3                	mov    %eax,%ebx
  804a45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a49:	48 89 c7             	mov    %rax,%rdi
  804a4c:	48 b8 7d 55 80 00 00 	movabs $0x80557d,%rax
  804a53:	00 00 00 
  804a56:	ff d0                	callq  *%rax
  804a58:	39 c3                	cmp    %eax,%ebx
  804a5a:	0f 94 c0             	sete   %al
  804a5d:	0f b6 c0             	movzbl %al,%eax
  804a60:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804a63:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804a6a:	00 00 00 
  804a6d:	48 8b 00             	mov    (%rax),%rax
  804a70:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a76:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804a79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a7c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a7f:	75 05                	jne    804a86 <_pipeisclosed+0x7d>
			return ret;
  804a81:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a84:	eb 4a                	jmp    804ad0 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804a86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a89:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a8c:	74 8c                	je     804a1a <_pipeisclosed+0x11>
  804a8e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804a92:	75 86                	jne    804a1a <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804a94:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804a9b:	00 00 00 
  804a9e:	48 8b 00             	mov    (%rax),%rax
  804aa1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804aa7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804aaa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804aad:	89 c6                	mov    %eax,%esi
  804aaf:	48 bf 43 5f 80 00 00 	movabs $0x805f43,%rdi
  804ab6:	00 00 00 
  804ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  804abe:	49 b8 8c 05 80 00 00 	movabs $0x80058c,%r8
  804ac5:	00 00 00 
  804ac8:	41 ff d0             	callq  *%r8
	}
  804acb:	e9 4a ff ff ff       	jmpq   804a1a <_pipeisclosed+0x11>

}
  804ad0:	48 83 c4 28          	add    $0x28,%rsp
  804ad4:	5b                   	pop    %rbx
  804ad5:	5d                   	pop    %rbp
  804ad6:	c3                   	retq   

0000000000804ad7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804ad7:	55                   	push   %rbp
  804ad8:	48 89 e5             	mov    %rsp,%rbp
  804adb:	48 83 ec 30          	sub    $0x30,%rsp
  804adf:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804ae2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804ae6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804ae9:	48 89 d6             	mov    %rdx,%rsi
  804aec:	89 c7                	mov    %eax,%edi
  804aee:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  804af5:	00 00 00 
  804af8:	ff d0                	callq  *%rax
  804afa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804afd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b01:	79 05                	jns    804b08 <pipeisclosed+0x31>
		return r;
  804b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b06:	eb 31                	jmp    804b39 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b0c:	48 89 c7             	mov    %rax,%rdi
  804b0f:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  804b16:	00 00 00 
  804b19:	ff d0                	callq  *%rax
  804b1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b27:	48 89 d6             	mov    %rdx,%rsi
  804b2a:	48 89 c7             	mov    %rax,%rdi
  804b2d:	48 b8 09 4a 80 00 00 	movabs $0x804a09,%rax
  804b34:	00 00 00 
  804b37:	ff d0                	callq  *%rax
}
  804b39:	c9                   	leaveq 
  804b3a:	c3                   	retq   

0000000000804b3b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804b3b:	55                   	push   %rbp
  804b3c:	48 89 e5             	mov    %rsp,%rbp
  804b3f:	48 83 ec 40          	sub    $0x40,%rsp
  804b43:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b47:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804b4b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b53:	48 89 c7             	mov    %rax,%rdi
  804b56:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  804b5d:	00 00 00 
  804b60:	ff d0                	callq  *%rax
  804b62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b6e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b75:	00 
  804b76:	e9 90 00 00 00       	jmpq   804c0b <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804b7b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804b80:	74 09                	je     804b8b <devpipe_read+0x50>
				return i;
  804b82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b86:	e9 8e 00 00 00       	jmpq   804c19 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804b8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b93:	48 89 d6             	mov    %rdx,%rsi
  804b96:	48 89 c7             	mov    %rax,%rdi
  804b99:	48 b8 09 4a 80 00 00 	movabs $0x804a09,%rax
  804ba0:	00 00 00 
  804ba3:	ff d0                	callq  *%rax
  804ba5:	85 c0                	test   %eax,%eax
  804ba7:	74 07                	je     804bb0 <devpipe_read+0x75>
				return 0;
  804ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  804bae:	eb 69                	jmp    804c19 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804bb0:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804bb7:	00 00 00 
  804bba:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bc0:	8b 10                	mov    (%rax),%edx
  804bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bc6:	8b 40 04             	mov    0x4(%rax),%eax
  804bc9:	39 c2                	cmp    %eax,%edx
  804bcb:	74 ae                	je     804b7b <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804bcd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804bd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bd5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bdd:	8b 00                	mov    (%rax),%eax
  804bdf:	99                   	cltd   
  804be0:	c1 ea 1b             	shr    $0x1b,%edx
  804be3:	01 d0                	add    %edx,%eax
  804be5:	83 e0 1f             	and    $0x1f,%eax
  804be8:	29 d0                	sub    %edx,%eax
  804bea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bee:	48 98                	cltq   
  804bf0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804bf5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804bf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bfb:	8b 00                	mov    (%rax),%eax
  804bfd:	8d 50 01             	lea    0x1(%rax),%edx
  804c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c04:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804c06:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c0f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c13:	72 a7                	jb     804bbc <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804c15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804c19:	c9                   	leaveq 
  804c1a:	c3                   	retq   

0000000000804c1b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804c1b:	55                   	push   %rbp
  804c1c:	48 89 e5             	mov    %rsp,%rbp
  804c1f:	48 83 ec 40          	sub    $0x40,%rsp
  804c23:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804c27:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804c2b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804c2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c33:	48 89 c7             	mov    %rax,%rdi
  804c36:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  804c3d:	00 00 00 
  804c40:	ff d0                	callq  *%rax
  804c42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804c46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804c4e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804c55:	00 
  804c56:	e9 8f 00 00 00       	jmpq   804cea <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804c5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c63:	48 89 d6             	mov    %rdx,%rsi
  804c66:	48 89 c7             	mov    %rax,%rdi
  804c69:	48 b8 09 4a 80 00 00 	movabs $0x804a09,%rax
  804c70:	00 00 00 
  804c73:	ff d0                	callq  *%rax
  804c75:	85 c0                	test   %eax,%eax
  804c77:	74 07                	je     804c80 <devpipe_write+0x65>
				return 0;
  804c79:	b8 00 00 00 00       	mov    $0x0,%eax
  804c7e:	eb 78                	jmp    804cf8 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804c80:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804c87:	00 00 00 
  804c8a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c90:	8b 40 04             	mov    0x4(%rax),%eax
  804c93:	48 63 d0             	movslq %eax,%rdx
  804c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c9a:	8b 00                	mov    (%rax),%eax
  804c9c:	48 98                	cltq   
  804c9e:	48 83 c0 20          	add    $0x20,%rax
  804ca2:	48 39 c2             	cmp    %rax,%rdx
  804ca5:	73 b4                	jae    804c5b <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cab:	8b 40 04             	mov    0x4(%rax),%eax
  804cae:	99                   	cltd   
  804caf:	c1 ea 1b             	shr    $0x1b,%edx
  804cb2:	01 d0                	add    %edx,%eax
  804cb4:	83 e0 1f             	and    $0x1f,%eax
  804cb7:	29 d0                	sub    %edx,%eax
  804cb9:	89 c6                	mov    %eax,%esi
  804cbb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804cbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cc3:	48 01 d0             	add    %rdx,%rax
  804cc6:	0f b6 08             	movzbl (%rax),%ecx
  804cc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ccd:	48 63 c6             	movslq %esi,%rax
  804cd0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cd8:	8b 40 04             	mov    0x4(%rax),%eax
  804cdb:	8d 50 01             	lea    0x1(%rax),%edx
  804cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ce2:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804ce5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cee:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804cf2:	72 98                	jb     804c8c <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804cf8:	c9                   	leaveq 
  804cf9:	c3                   	retq   

0000000000804cfa <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804cfa:	55                   	push   %rbp
  804cfb:	48 89 e5             	mov    %rsp,%rbp
  804cfe:	48 83 ec 20          	sub    $0x20,%rsp
  804d02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d0e:	48 89 c7             	mov    %rax,%rdi
  804d11:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  804d18:	00 00 00 
  804d1b:	ff d0                	callq  *%rax
  804d1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804d21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d25:	48 be 56 5f 80 00 00 	movabs $0x805f56,%rsi
  804d2c:	00 00 00 
  804d2f:	48 89 c7             	mov    %rax,%rdi
  804d32:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  804d39:	00 00 00 
  804d3c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804d3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d42:	8b 50 04             	mov    0x4(%rax),%edx
  804d45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d49:	8b 00                	mov    (%rax),%eax
  804d4b:	29 c2                	sub    %eax,%edx
  804d4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d51:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804d57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d5b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804d62:	00 00 00 
	stat->st_dev = &devpipe;
  804d65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d69:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804d70:	00 00 00 
  804d73:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d7f:	c9                   	leaveq 
  804d80:	c3                   	retq   

0000000000804d81 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804d81:	55                   	push   %rbp
  804d82:	48 89 e5             	mov    %rsp,%rbp
  804d85:	48 83 ec 10          	sub    $0x10,%rsp
  804d89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d91:	48 89 c6             	mov    %rax,%rsi
  804d94:	bf 00 00 00 00       	mov    $0x0,%edi
  804d99:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804da0:	00 00 00 
  804da3:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804da9:	48 89 c7             	mov    %rax,%rdi
  804dac:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  804db3:	00 00 00 
  804db6:	ff d0                	callq  *%rax
  804db8:	48 89 c6             	mov    %rax,%rsi
  804dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  804dc0:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804dc7:	00 00 00 
  804dca:	ff d0                	callq  *%rax
}
  804dcc:	c9                   	leaveq 
  804dcd:	c3                   	retq   

0000000000804dce <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804dce:	55                   	push   %rbp
  804dcf:	48 89 e5             	mov    %rsp,%rbp
  804dd2:	48 83 ec 20          	sub    $0x20,%rsp
  804dd6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804dd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ddd:	75 35                	jne    804e14 <wait+0x46>
  804ddf:	48 b9 5d 5f 80 00 00 	movabs $0x805f5d,%rcx
  804de6:	00 00 00 
  804de9:	48 ba 68 5f 80 00 00 	movabs $0x805f68,%rdx
  804df0:	00 00 00 
  804df3:	be 0a 00 00 00       	mov    $0xa,%esi
  804df8:	48 bf 7d 5f 80 00 00 	movabs $0x805f7d,%rdi
  804dff:	00 00 00 
  804e02:	b8 00 00 00 00       	mov    $0x0,%eax
  804e07:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  804e0e:	00 00 00 
  804e11:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804e14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e17:	25 ff 03 00 00       	and    $0x3ff,%eax
  804e1c:	48 98                	cltq   
  804e1e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804e25:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e2c:	00 00 00 
  804e2f:	48 01 d0             	add    %rdx,%rax
  804e32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e36:	eb 0c                	jmp    804e44 <wait+0x76>
		sys_yield();
  804e38:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804e3f:	00 00 00 
  804e42:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e48:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804e4e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e51:	75 0e                	jne    804e61 <wait+0x93>
  804e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e57:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804e5d:	85 c0                	test   %eax,%eax
  804e5f:	75 d7                	jne    804e38 <wait+0x6a>
		sys_yield();
}
  804e61:	90                   	nop
  804e62:	c9                   	leaveq 
  804e63:	c3                   	retq   

0000000000804e64 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804e64:	55                   	push   %rbp
  804e65:	48 89 e5             	mov    %rsp,%rbp
  804e68:	48 83 ec 20          	sub    $0x20,%rsp
  804e6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804e6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e72:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804e75:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804e79:	be 01 00 00 00       	mov    $0x1,%esi
  804e7e:	48 89 c7             	mov    %rax,%rdi
  804e81:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  804e88:	00 00 00 
  804e8b:	ff d0                	callq  *%rax
}
  804e8d:	90                   	nop
  804e8e:	c9                   	leaveq 
  804e8f:	c3                   	retq   

0000000000804e90 <getchar>:

int
getchar(void)
{
  804e90:	55                   	push   %rbp
  804e91:	48 89 e5             	mov    %rsp,%rbp
  804e94:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804e98:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804e9c:	ba 01 00 00 00       	mov    $0x1,%edx
  804ea1:	48 89 c6             	mov    %rax,%rsi
  804ea4:	bf 00 00 00 00       	mov    $0x0,%edi
  804ea9:	48 b8 81 29 80 00 00 	movabs $0x802981,%rax
  804eb0:	00 00 00 
  804eb3:	ff d0                	callq  *%rax
  804eb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804eb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ebc:	79 05                	jns    804ec3 <getchar+0x33>
		return r;
  804ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ec1:	eb 14                	jmp    804ed7 <getchar+0x47>
	if (r < 1)
  804ec3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ec7:	7f 07                	jg     804ed0 <getchar+0x40>
		return -E_EOF;
  804ec9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804ece:	eb 07                	jmp    804ed7 <getchar+0x47>
	return c;
  804ed0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804ed4:	0f b6 c0             	movzbl %al,%eax

}
  804ed7:	c9                   	leaveq 
  804ed8:	c3                   	retq   

0000000000804ed9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804ed9:	55                   	push   %rbp
  804eda:	48 89 e5             	mov    %rsp,%rbp
  804edd:	48 83 ec 20          	sub    $0x20,%rsp
  804ee1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804ee4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804ee8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804eeb:	48 89 d6             	mov    %rdx,%rsi
  804eee:	89 c7                	mov    %eax,%edi
  804ef0:	48 b8 4c 25 80 00 00 	movabs $0x80254c,%rax
  804ef7:	00 00 00 
  804efa:	ff d0                	callq  *%rax
  804efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f03:	79 05                	jns    804f0a <iscons+0x31>
		return r;
  804f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f08:	eb 1a                	jmp    804f24 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f0e:	8b 10                	mov    (%rax),%edx
  804f10:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804f17:	00 00 00 
  804f1a:	8b 00                	mov    (%rax),%eax
  804f1c:	39 c2                	cmp    %eax,%edx
  804f1e:	0f 94 c0             	sete   %al
  804f21:	0f b6 c0             	movzbl %al,%eax
}
  804f24:	c9                   	leaveq 
  804f25:	c3                   	retq   

0000000000804f26 <opencons>:

int
opencons(void)
{
  804f26:	55                   	push   %rbp
  804f27:	48 89 e5             	mov    %rsp,%rbp
  804f2a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804f2e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804f32:	48 89 c7             	mov    %rax,%rdi
  804f35:	48 b8 b4 24 80 00 00 	movabs $0x8024b4,%rax
  804f3c:	00 00 00 
  804f3f:	ff d0                	callq  *%rax
  804f41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f48:	79 05                	jns    804f4f <opencons+0x29>
		return r;
  804f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f4d:	eb 5b                	jmp    804faa <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804f4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f53:	ba 07 04 00 00       	mov    $0x407,%edx
  804f58:	48 89 c6             	mov    %rax,%rsi
  804f5b:	bf 00 00 00 00       	mov    $0x0,%edi
  804f60:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  804f67:	00 00 00 
  804f6a:	ff d0                	callq  *%rax
  804f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f73:	79 05                	jns    804f7a <opencons+0x54>
		return r;
  804f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f78:	eb 30                	jmp    804faa <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f7e:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  804f85:	00 00 00 
  804f88:	8b 12                	mov    (%rdx),%edx
  804f8a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f90:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f9b:	48 89 c7             	mov    %rax,%rdi
  804f9e:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  804fa5:	00 00 00 
  804fa8:	ff d0                	callq  *%rax
}
  804faa:	c9                   	leaveq 
  804fab:	c3                   	retq   

0000000000804fac <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804fac:	55                   	push   %rbp
  804fad:	48 89 e5             	mov    %rsp,%rbp
  804fb0:	48 83 ec 30          	sub    $0x30,%rsp
  804fb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804fb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804fbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804fc0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804fc5:	75 13                	jne    804fda <devcons_read+0x2e>
		return 0;
  804fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  804fcc:	eb 49                	jmp    805017 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804fce:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  804fd5:	00 00 00 
  804fd8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804fda:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  804fe1:	00 00 00 
  804fe4:	ff d0                	callq  *%rax
  804fe6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fe9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fed:	74 df                	je     804fce <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804fef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ff3:	79 05                	jns    804ffa <devcons_read+0x4e>
		return c;
  804ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ff8:	eb 1d                	jmp    805017 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804ffa:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804ffe:	75 07                	jne    805007 <devcons_read+0x5b>
		return 0;
  805000:	b8 00 00 00 00       	mov    $0x0,%eax
  805005:	eb 10                	jmp    805017 <devcons_read+0x6b>
	*(char*)vbuf = c;
  805007:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80500a:	89 c2                	mov    %eax,%edx
  80500c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805010:	88 10                	mov    %dl,(%rax)
	return 1;
  805012:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805017:	c9                   	leaveq 
  805018:	c3                   	retq   

0000000000805019 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805019:	55                   	push   %rbp
  80501a:	48 89 e5             	mov    %rsp,%rbp
  80501d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  805024:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80502b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  805032:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  805039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805040:	eb 76                	jmp    8050b8 <devcons_write+0x9f>
		m = n - tot;
  805042:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  805049:	89 c2                	mov    %eax,%edx
  80504b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80504e:	29 c2                	sub    %eax,%edx
  805050:	89 d0                	mov    %edx,%eax
  805052:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  805055:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805058:	83 f8 7f             	cmp    $0x7f,%eax
  80505b:	76 07                	jbe    805064 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80505d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  805064:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805067:	48 63 d0             	movslq %eax,%rdx
  80506a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80506d:	48 63 c8             	movslq %eax,%rcx
  805070:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  805077:	48 01 c1             	add    %rax,%rcx
  80507a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  805081:	48 89 ce             	mov    %rcx,%rsi
  805084:	48 89 c7             	mov    %rax,%rdi
  805087:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  80508e:	00 00 00 
  805091:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  805093:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805096:	48 63 d0             	movslq %eax,%rdx
  805099:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8050a0:	48 89 d6             	mov    %rdx,%rsi
  8050a3:	48 89 c7             	mov    %rax,%rdi
  8050a6:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  8050ad:	00 00 00 
  8050b0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8050b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050b5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8050b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050bb:	48 98                	cltq   
  8050bd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8050c4:	0f 82 78 ff ff ff    	jb     805042 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8050ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8050cd:	c9                   	leaveq 
  8050ce:	c3                   	retq   

00000000008050cf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8050cf:	55                   	push   %rbp
  8050d0:	48 89 e5             	mov    %rsp,%rbp
  8050d3:	48 83 ec 08          	sub    $0x8,%rsp
  8050d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8050db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8050e0:	c9                   	leaveq 
  8050e1:	c3                   	retq   

00000000008050e2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8050e2:	55                   	push   %rbp
  8050e3:	48 89 e5             	mov    %rsp,%rbp
  8050e6:	48 83 ec 10          	sub    $0x10,%rsp
  8050ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8050ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8050f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050f6:	48 be 8d 5f 80 00 00 	movabs $0x805f8d,%rsi
  8050fd:	00 00 00 
  805100:	48 89 c7             	mov    %rax,%rdi
  805103:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  80510a:	00 00 00 
  80510d:	ff d0                	callq  *%rax
	return 0;
  80510f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805114:	c9                   	leaveq 
  805115:	c3                   	retq   

0000000000805116 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805116:	55                   	push   %rbp
  805117:	48 89 e5             	mov    %rsp,%rbp
  80511a:	48 83 ec 20          	sub    $0x20,%rsp
  80511e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  805122:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805129:	00 00 00 
  80512c:	48 8b 00             	mov    (%rax),%rax
  80512f:	48 85 c0             	test   %rax,%rax
  805132:	75 6f                	jne    8051a3 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  805134:	ba 07 00 00 00       	mov    $0x7,%edx
  805139:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80513e:	bf 00 00 00 00       	mov    $0x0,%edi
  805143:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  80514a:	00 00 00 
  80514d:	ff d0                	callq  *%rax
  80514f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805156:	79 30                	jns    805188 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80515b:	89 c1                	mov    %eax,%ecx
  80515d:	48 ba 98 5f 80 00 00 	movabs $0x805f98,%rdx
  805164:	00 00 00 
  805167:	be 22 00 00 00       	mov    $0x22,%esi
  80516c:	48 bf b7 5f 80 00 00 	movabs $0x805fb7,%rdi
  805173:	00 00 00 
  805176:	b8 00 00 00 00       	mov    $0x0,%eax
  80517b:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  805182:	00 00 00 
  805185:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  805188:	48 be b7 51 80 00 00 	movabs $0x8051b7,%rsi
  80518f:	00 00 00 
  805192:	bf 00 00 00 00       	mov    $0x0,%edi
  805197:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  80519e:	00 00 00 
  8051a1:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8051a3:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8051aa:	00 00 00 
  8051ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8051b1:	48 89 10             	mov    %rdx,(%rax)
}
  8051b4:	90                   	nop
  8051b5:	c9                   	leaveq 
  8051b6:	c3                   	retq   

00000000008051b7 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8051b7:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8051ba:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  8051c1:	00 00 00 
call *%rax
  8051c4:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8051c6:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8051cd:	00 08 
    movq 152(%rsp), %rax
  8051cf:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8051d6:	00 
    movq 136(%rsp), %rbx
  8051d7:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8051de:	00 
movq %rbx, (%rax)
  8051df:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8051e2:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8051e6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8051ea:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8051ef:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8051f4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8051f9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8051fe:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805203:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805208:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80520d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805212:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805217:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80521c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805221:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805226:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80522b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805230:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  805234:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805238:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805239:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80523e:	c3                   	retq   

000000000080523f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80523f:	55                   	push   %rbp
  805240:	48 89 e5             	mov    %rsp,%rbp
  805243:	48 83 ec 30          	sub    $0x30,%rsp
  805247:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80524b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80524f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  805253:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805258:	75 0e                	jne    805268 <ipc_recv+0x29>
		pg = (void*) UTOP;
  80525a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805261:	00 00 00 
  805264:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  805268:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80526c:	48 89 c7             	mov    %rax,%rdi
  80526f:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  805276:	00 00 00 
  805279:	ff d0                	callq  *%rax
  80527b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80527e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805282:	79 27                	jns    8052ab <ipc_recv+0x6c>
		if (from_env_store)
  805284:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805289:	74 0a                	je     805295 <ipc_recv+0x56>
			*from_env_store = 0;
  80528b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80528f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  805295:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80529a:	74 0a                	je     8052a6 <ipc_recv+0x67>
			*perm_store = 0;
  80529c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8052a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052a9:	eb 53                	jmp    8052fe <ipc_recv+0xbf>
	}
	if (from_env_store)
  8052ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8052b0:	74 19                	je     8052cb <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8052b2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8052b9:	00 00 00 
  8052bc:	48 8b 00             	mov    (%rax),%rax
  8052bf:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8052c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052c9:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8052cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8052d0:	74 19                	je     8052eb <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8052d2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8052d9:	00 00 00 
  8052dc:	48 8b 00             	mov    (%rax),%rax
  8052df:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8052e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052e9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8052eb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8052f2:	00 00 00 
  8052f5:	48 8b 00             	mov    (%rax),%rax
  8052f8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8052fe:	c9                   	leaveq 
  8052ff:	c3                   	retq   

0000000000805300 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805300:	55                   	push   %rbp
  805301:	48 89 e5             	mov    %rsp,%rbp
  805304:	48 83 ec 30          	sub    $0x30,%rsp
  805308:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80530b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80530e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805312:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  805315:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80531a:	75 1c                	jne    805338 <ipc_send+0x38>
		pg = (void*) UTOP;
  80531c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805323:	00 00 00 
  805326:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80532a:	eb 0c                	jmp    805338 <ipc_send+0x38>
		sys_yield();
  80532c:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  805333:	00 00 00 
  805336:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805338:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80533b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80533e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805342:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805345:	89 c7                	mov    %eax,%edi
  805347:	48 b8 35 1c 80 00 00 	movabs $0x801c35,%rax
  80534e:	00 00 00 
  805351:	ff d0                	callq  *%rax
  805353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805356:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80535a:	74 d0                	je     80532c <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80535c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805360:	79 30                	jns    805392 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  805362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805365:	89 c1                	mov    %eax,%ecx
  805367:	48 ba c5 5f 80 00 00 	movabs $0x805fc5,%rdx
  80536e:	00 00 00 
  805371:	be 47 00 00 00       	mov    $0x47,%esi
  805376:	48 bf db 5f 80 00 00 	movabs $0x805fdb,%rdi
  80537d:	00 00 00 
  805380:	b8 00 00 00 00       	mov    $0x0,%eax
  805385:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  80538c:	00 00 00 
  80538f:	41 ff d0             	callq  *%r8

}
  805392:	90                   	nop
  805393:	c9                   	leaveq 
  805394:	c3                   	retq   

0000000000805395 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  805395:	55                   	push   %rbp
  805396:	48 89 e5             	mov    %rsp,%rbp
  805399:	53                   	push   %rbx
  80539a:	48 83 ec 28          	sub    $0x28,%rsp
  80539e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8053a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8053a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8053b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8053b5:	75 0e                	jne    8053c5 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8053b7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8053be:	00 00 00 
  8053c1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8053c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053c9:	ba 07 00 00 00       	mov    $0x7,%edx
  8053ce:	48 89 c6             	mov    %rax,%rsi
  8053d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8053d6:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  8053dd:	00 00 00 
  8053e0:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8053e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8053ea:	48 89 c2             	mov    %rax,%rdx
  8053ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053f4:	01 00 00 
  8053f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053fb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805401:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  805405:	b8 03 00 00 00       	mov    $0x3,%eax
  80540a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80540e:	48 89 d3             	mov    %rdx,%rbx
  805411:	0f 01 c1             	vmcall 
  805414:	89 f2                	mov    %esi,%edx
  805416:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805419:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80541c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805420:	79 05                	jns    805427 <ipc_host_recv+0x92>
		return r;
  805422:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805425:	eb 03                	jmp    80542a <ipc_host_recv+0x95>
	}
	return val;
  805427:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80542a:	48 83 c4 28          	add    $0x28,%rsp
  80542e:	5b                   	pop    %rbx
  80542f:	5d                   	pop    %rbp
  805430:	c3                   	retq   

0000000000805431 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805431:	55                   	push   %rbp
  805432:	48 89 e5             	mov    %rsp,%rbp
  805435:	53                   	push   %rbx
  805436:	48 83 ec 38          	sub    $0x38,%rsp
  80543a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80543d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  805440:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  805444:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  805447:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80544e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  805453:	75 0e                	jne    805463 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  805455:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80545c:	00 00 00 
  80545f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  805463:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805467:	48 c1 e8 0c          	shr    $0xc,%rax
  80546b:	48 89 c2             	mov    %rax,%rdx
  80546e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805475:	01 00 00 
  805478:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80547c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805482:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  805486:	b8 02 00 00 00       	mov    $0x2,%eax
  80548b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80548e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805491:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805495:	8b 75 cc             	mov    -0x34(%rbp),%esi
  805498:	89 fb                	mov    %edi,%ebx
  80549a:	0f 01 c1             	vmcall 
  80549d:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8054a0:	eb 26                	jmp    8054c8 <ipc_host_send+0x97>
		sys_yield();
  8054a2:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  8054a9:	00 00 00 
  8054ac:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8054ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8054b3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8054b6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8054b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8054bd:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8054c0:	89 fb                	mov    %edi,%ebx
  8054c2:	0f 01 c1             	vmcall 
  8054c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8054c8:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8054cc:	74 d4                	je     8054a2 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8054ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8054d2:	79 30                	jns    805504 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8054d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8054d7:	89 c1                	mov    %eax,%ecx
  8054d9:	48 ba c5 5f 80 00 00 	movabs $0x805fc5,%rdx
  8054e0:	00 00 00 
  8054e3:	be 79 00 00 00       	mov    $0x79,%esi
  8054e8:	48 bf db 5f 80 00 00 	movabs $0x805fdb,%rdi
  8054ef:	00 00 00 
  8054f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8054f7:	49 b8 52 03 80 00 00 	movabs $0x800352,%r8
  8054fe:	00 00 00 
  805501:	41 ff d0             	callq  *%r8

}
  805504:	90                   	nop
  805505:	48 83 c4 38          	add    $0x38,%rsp
  805509:	5b                   	pop    %rbx
  80550a:	5d                   	pop    %rbp
  80550b:	c3                   	retq   

000000000080550c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80550c:	55                   	push   %rbp
  80550d:	48 89 e5             	mov    %rsp,%rbp
  805510:	48 83 ec 18          	sub    $0x18,%rsp
  805514:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805517:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80551e:	eb 4d                	jmp    80556d <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  805520:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805527:	00 00 00 
  80552a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80552d:	48 98                	cltq   
  80552f:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805536:	48 01 d0             	add    %rdx,%rax
  805539:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80553f:	8b 00                	mov    (%rax),%eax
  805541:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805544:	75 23                	jne    805569 <ipc_find_env+0x5d>
			return envs[i].env_id;
  805546:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80554d:	00 00 00 
  805550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805553:	48 98                	cltq   
  805555:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80555c:	48 01 d0             	add    %rdx,%rax
  80555f:	48 05 c8 00 00 00    	add    $0xc8,%rax
  805565:	8b 00                	mov    (%rax),%eax
  805567:	eb 12                	jmp    80557b <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805569:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80556d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805574:	7e aa                	jle    805520 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80557b:	c9                   	leaveq 
  80557c:	c3                   	retq   

000000000080557d <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80557d:	55                   	push   %rbp
  80557e:	48 89 e5             	mov    %rsp,%rbp
  805581:	48 83 ec 18          	sub    $0x18,%rsp
  805585:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80558d:	48 c1 e8 15          	shr    $0x15,%rax
  805591:	48 89 c2             	mov    %rax,%rdx
  805594:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80559b:	01 00 00 
  80559e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055a2:	83 e0 01             	and    $0x1,%eax
  8055a5:	48 85 c0             	test   %rax,%rax
  8055a8:	75 07                	jne    8055b1 <pageref+0x34>
		return 0;
  8055aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8055af:	eb 56                	jmp    805607 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8055b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8055b9:	48 89 c2             	mov    %rax,%rdx
  8055bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055c3:	01 00 00 
  8055c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8055ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055d2:	83 e0 01             	and    $0x1,%eax
  8055d5:	48 85 c0             	test   %rax,%rax
  8055d8:	75 07                	jne    8055e1 <pageref+0x64>
		return 0;
  8055da:	b8 00 00 00 00       	mov    $0x0,%eax
  8055df:	eb 26                	jmp    805607 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8055e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8055e9:	48 89 c2             	mov    %rax,%rdx
  8055ec:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8055f3:	00 00 00 
  8055f6:	48 c1 e2 04          	shl    $0x4,%rdx
  8055fa:	48 01 d0             	add    %rdx,%rax
  8055fd:	48 83 c0 08          	add    $0x8,%rax
  805601:	0f b7 00             	movzwl (%rax),%eax
  805604:	0f b7 c0             	movzwl %ax,%eax
}
  805607:	c9                   	leaveq 
  805608:	c3                   	retq   
