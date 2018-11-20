
vmm/guest/obj/user/testfdsharing:     file format elf64-x86-64


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
  80003c:	e8 fb 02 00 00       	callq  80033c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf 40 4b 80 00 00 	movabs $0x804b40,%rdi
  80005e:	00 00 00 
  800061:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba 45 4b 80 00 00 	movabs $0x804b45,%rdx
  800082:	00 00 00 
  800085:	be 0d 00 00 00       	mov    $0xd,%esi
  80008a:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 82 80 00 00 	movabs $0x808220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba 68 4b 80 00 00 	movabs $0x804b68,%rdx
  8000f1:	00 00 00 
  8000f4:	be 10 00 00 00       	mov    $0x10,%esi
  8000f9:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 81 22 80 00 00 	movabs $0x802281,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba 72 4b 80 00 00 	movabs $0x804b72,%rdx
  800136:	00 00 00 
  800139:	be 13 00 00 00       	mov    $0x13,%esi
  80013e:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  8001d2:	00 00 00 
  8001d5:	be 18 00 00 00       	mov    $0x18,%esi
  8001da:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 82 80 00 00 	movabs $0x808220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba f8 4b 80 00 00 	movabs $0x804bf8,%rdx
  800229:	00 00 00 
  80022c:	be 1a 00 00 00       	mov    $0x1a,%esi
  800231:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e4 03 80 00 00 	movabs $0x8003e4,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf 2e 4c 80 00 00 	movabs $0x804c2e,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 f4 42 80 00 00 	movabs $0x8042f4,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba 48 4c 80 00 00 	movabs $0x804c48,%rdx
  8002e8:	00 00 00 
  8002eb:	be 22 00 00 00       	mov    $0x22,%esi
  8002f0:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf 6b 4c 80 00 00 	movabs $0x804c6b,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   


	breakpoint();
}
  800339:	90                   	nop
  80033a:	c9                   	leaveq 
  80033b:	c3                   	retq   

000000000080033c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
  800340:	48 83 ec 10          	sub    $0x10,%rsp
  800344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800347:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  80034b:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  800352:	00 00 00 
  800355:	ff d0                	callq  *%rax
  800357:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035c:	48 98                	cltq   
  80035e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800365:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80036c:	00 00 00 
  80036f:	48 01 c2             	add    %rax,%rdx
  800372:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  800379:	00 00 00 
  80037c:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800383:	7e 14                	jle    800399 <libmain+0x5d>
		binaryname = argv[0];
  800385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800389:	48 8b 10             	mov    (%rax),%rdx
  80038c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800393:	00 00 00 
  800396:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800399:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a0:	48 89 d6             	mov    %rdx,%rsi
  8003a3:	89 c7                	mov    %eax,%edi
  8003a5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003b1:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  8003b8:	00 00 00 
  8003bb:	ff d0                	callq  *%rax
}
  8003bd:	90                   	nop
  8003be:	c9                   	leaveq 
  8003bf:	c3                   	retq   

00000000008003c0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003c4:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  8003cb:	00 00 00 
  8003ce:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d5:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  8003dc:	00 00 00 
  8003df:	ff d0                	callq  *%rax
}
  8003e1:	90                   	nop
  8003e2:	5d                   	pop    %rbp
  8003e3:	c3                   	retq   

00000000008003e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
  8003e8:	53                   	push   %rbx
  8003e9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003f0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003f7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003fd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800404:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80040b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800412:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800419:	84 c0                	test   %al,%al
  80041b:	74 23                	je     800440 <_panic+0x5c>
  80041d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800424:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800428:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80042c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800430:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800434:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800438:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80043c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800440:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800447:	00 00 00 
  80044a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800451:	00 00 00 
  800454:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800458:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80045f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800466:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80046d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800474:	00 00 00 
  800477:	48 8b 18             	mov    (%rax),%rbx
  80047a:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	89 c6                	mov    %eax,%esi
  800488:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80048e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800495:	41 89 d0             	mov    %edx,%r8d
  800498:	48 89 c1             	mov    %rax,%rcx
  80049b:	48 89 da             	mov    %rbx,%rdx
  80049e:	48 bf 90 4c 80 00 00 	movabs $0x804c90,%rdi
  8004a5:	00 00 00 
  8004a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ad:	49 b9 1e 06 80 00 00 	movabs $0x80061e,%r9
  8004b4:	00 00 00 
  8004b7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004ba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004c1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004c8:	48 89 d6             	mov    %rdx,%rsi
  8004cb:	48 89 c7             	mov    %rax,%rdi
  8004ce:	48 b8 72 05 80 00 00 	movabs $0x800572,%rax
  8004d5:	00 00 00 
  8004d8:	ff d0                	callq  *%rax
	cprintf("\n");
  8004da:	48 bf b3 4c 80 00 00 	movabs $0x804cb3,%rdi
  8004e1:	00 00 00 
  8004e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e9:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8004f0:	00 00 00 
  8004f3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004f5:	cc                   	int3   
  8004f6:	eb fd                	jmp    8004f5 <_panic+0x111>

00000000008004f8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004f8:	55                   	push   %rbp
  8004f9:	48 89 e5             	mov    %rsp,%rbp
  8004fc:	48 83 ec 10          	sub    $0x10,%rsp
  800500:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800503:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050b:	8b 00                	mov    (%rax),%eax
  80050d:	8d 48 01             	lea    0x1(%rax),%ecx
  800510:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800514:	89 0a                	mov    %ecx,(%rdx)
  800516:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800519:	89 d1                	mov    %edx,%ecx
  80051b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051f:	48 98                	cltq   
  800521:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800529:	8b 00                	mov    (%rax),%eax
  80052b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800530:	75 2c                	jne    80055e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800536:	8b 00                	mov    (%rax),%eax
  800538:	48 98                	cltq   
  80053a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053e:	48 83 c2 08          	add    $0x8,%rdx
  800542:	48 89 c6             	mov    %rax,%rsi
  800545:	48 89 d7             	mov    %rdx,%rdi
  800548:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  80054f:	00 00 00 
  800552:	ff d0                	callq  *%rax
        b->idx = 0;
  800554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800558:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 40 04             	mov    0x4(%rax),%eax
  800565:	8d 50 01             	lea    0x1(%rax),%edx
  800568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80056f:	90                   	nop
  800570:	c9                   	leaveq 
  800571:	c3                   	retq   

0000000000800572 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800572:	55                   	push   %rbp
  800573:	48 89 e5             	mov    %rsp,%rbp
  800576:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80057d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800584:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80058b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800592:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800599:	48 8b 0a             	mov    (%rdx),%rcx
  80059c:	48 89 08             	mov    %rcx,(%rax)
  80059f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ab:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005b6:	00 00 00 
    b.cnt = 0;
  8005b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005c0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005c3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ca:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005d1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005d8:	48 89 c6             	mov    %rax,%rsi
  8005db:	48 bf f8 04 80 00 00 	movabs $0x8004f8,%rdi
  8005e2:	00 00 00 
  8005e5:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  8005ec:	00 00 00 
  8005ef:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005f1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005f7:	48 98                	cltq   
  8005f9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800600:	48 83 c2 08          	add    $0x8,%rdx
  800604:	48 89 c6             	mov    %rax,%rsi
  800607:	48 89 d7             	mov    %rdx,%rdi
  80060a:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  800611:	00 00 00 
  800614:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80061c:	c9                   	leaveq 
  80061d:	c3                   	retq   

000000000080061e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80061e:	55                   	push   %rbp
  80061f:	48 89 e5             	mov    %rsp,%rbp
  800622:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800629:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800630:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800637:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80063e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800645:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80064c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800653:	84 c0                	test   %al,%al
  800655:	74 20                	je     800677 <cprintf+0x59>
  800657:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80065b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80065f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800663:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800667:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80066b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80066f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800673:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800677:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80067e:	00 00 00 
  800681:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800688:	00 00 00 
  80068b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80068f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800696:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80069d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006a4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006ab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006b2:	48 8b 0a             	mov    (%rdx),%rcx
  8006b5:	48 89 08             	mov    %rcx,(%rax)
  8006b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006c8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006cf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d6:	48 89 d6             	mov    %rdx,%rsi
  8006d9:	48 89 c7             	mov    %rax,%rdi
  8006dc:	48 b8 72 05 80 00 00 	movabs $0x800572,%rax
  8006e3:	00 00 00 
  8006e6:	ff d0                	callq  *%rax
  8006e8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006ee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006f4:	c9                   	leaveq 
  8006f5:	c3                   	retq   

00000000008006f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f6:	55                   	push   %rbp
  8006f7:	48 89 e5             	mov    %rsp,%rbp
  8006fa:	48 83 ec 30          	sub    $0x30,%rsp
  8006fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800702:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800706:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80070a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80070d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800711:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800715:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800718:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80071c:	77 54                	ja     800772 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800721:	8d 78 ff             	lea    -0x1(%rax),%edi
  800724:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	48 f7 f6             	div    %rsi
  800733:	49 89 c2             	mov    %rax,%r10
  800736:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800739:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80073c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800744:	41 89 c9             	mov    %ecx,%r9d
  800747:	41 89 f8             	mov    %edi,%r8d
  80074a:	89 d1                	mov    %edx,%ecx
  80074c:	4c 89 d2             	mov    %r10,%rdx
  80074f:	48 89 c7             	mov    %rax,%rdi
  800752:	48 b8 f6 06 80 00 00 	movabs $0x8006f6,%rax
  800759:	00 00 00 
  80075c:	ff d0                	callq  *%rax
  80075e:	eb 1c                	jmp    80077c <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800760:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800764:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80076b:	48 89 ce             	mov    %rcx,%rsi
  80076e:	89 d7                	mov    %edx,%edi
  800770:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800772:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800776:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80077a:	7f e4                	jg     800760 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	48 f7 f1             	div    %rcx
  80078b:	48 b8 b0 4e 80 00 00 	movabs $0x804eb0,%rax
  800792:	00 00 00 
  800795:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800799:	0f be d0             	movsbl %al,%edx
  80079c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a4:	48 89 ce             	mov    %rcx,%rsi
  8007a7:	89 d7                	mov    %edx,%edi
  8007a9:	ff d0                	callq  *%rax
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leaveq 
  8007ad:	c3                   	retq   

00000000008007ae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ae:	55                   	push   %rbp
  8007af:	48 89 e5             	mov    %rsp,%rbp
  8007b2:	48 83 ec 20          	sub    $0x20,%rsp
  8007b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007ba:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007bd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c1:	7e 4f                	jle    800812 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	8b 00                	mov    (%rax),%eax
  8007c9:	83 f8 30             	cmp    $0x30,%eax
  8007cc:	73 24                	jae    8007f2 <getuint+0x44>
  8007ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	8b 00                	mov    (%rax),%eax
  8007dc:	89 c0                	mov    %eax,%eax
  8007de:	48 01 d0             	add    %rdx,%rax
  8007e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e5:	8b 12                	mov    (%rdx),%edx
  8007e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	89 0a                	mov    %ecx,(%rdx)
  8007f0:	eb 14                	jmp    800806 <getuint+0x58>
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007fa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800806:	48 8b 00             	mov    (%rax),%rax
  800809:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080d:	e9 9d 00 00 00       	jmpq   8008af <getuint+0x101>
	else if (lflag)
  800812:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800816:	74 4c                	je     800864 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	8b 00                	mov    (%rax),%eax
  80081e:	83 f8 30             	cmp    $0x30,%eax
  800821:	73 24                	jae    800847 <getuint+0x99>
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	8b 00                	mov    (%rax),%eax
  800831:	89 c0                	mov    %eax,%eax
  800833:	48 01 d0             	add    %rdx,%rax
  800836:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083a:	8b 12                	mov    (%rdx),%edx
  80083c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	89 0a                	mov    %ecx,(%rdx)
  800845:	eb 14                	jmp    80085b <getuint+0xad>
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80084f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800853:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800857:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085b:	48 8b 00             	mov    (%rax),%rax
  80085e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800862:	eb 4b                	jmp    8008af <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	83 f8 30             	cmp    $0x30,%eax
  80086d:	73 24                	jae    800893 <getuint+0xe5>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	89 c0                	mov    %eax,%eax
  80087f:	48 01 d0             	add    %rdx,%rax
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	8b 12                	mov    (%rdx),%edx
  800888:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	89 0a                	mov    %ecx,(%rdx)
  800891:	eb 14                	jmp    8008a7 <getuint+0xf9>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 40 08          	mov    0x8(%rax),%rax
  80089b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80089f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	89 c0                	mov    %eax,%eax
  8008ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b3:	c9                   	leaveq 
  8008b4:	c3                   	retq   

00000000008008b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b5:	55                   	push   %rbp
  8008b6:	48 89 e5             	mov    %rsp,%rbp
  8008b9:	48 83 ec 20          	sub    $0x20,%rsp
  8008bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008c4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008c8:	7e 4f                	jle    800919 <getint+0x64>
		x=va_arg(*ap, long long);
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	8b 00                	mov    (%rax),%eax
  8008d0:	83 f8 30             	cmp    $0x30,%eax
  8008d3:	73 24                	jae    8008f9 <getint+0x44>
  8008d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	8b 00                	mov    (%rax),%eax
  8008e3:	89 c0                	mov    %eax,%eax
  8008e5:	48 01 d0             	add    %rdx,%rax
  8008e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ec:	8b 12                	mov    (%rdx),%edx
  8008ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	89 0a                	mov    %ecx,(%rdx)
  8008f7:	eb 14                	jmp    80090d <getint+0x58>
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 40 08          	mov    0x8(%rax),%rax
  800901:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800905:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800909:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800914:	e9 9d 00 00 00       	jmpq   8009b6 <getint+0x101>
	else if (lflag)
  800919:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80091d:	74 4c                	je     80096b <getint+0xb6>
		x=va_arg(*ap, long);
  80091f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800923:	8b 00                	mov    (%rax),%eax
  800925:	83 f8 30             	cmp    $0x30,%eax
  800928:	73 24                	jae    80094e <getint+0x99>
  80092a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	8b 00                	mov    (%rax),%eax
  800938:	89 c0                	mov    %eax,%eax
  80093a:	48 01 d0             	add    %rdx,%rax
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	8b 12                	mov    (%rdx),%edx
  800943:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800946:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094a:	89 0a                	mov    %ecx,(%rdx)
  80094c:	eb 14                	jmp    800962 <getint+0xad>
  80094e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800952:	48 8b 40 08          	mov    0x8(%rax),%rax
  800956:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80095a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800962:	48 8b 00             	mov    (%rax),%rax
  800965:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800969:	eb 4b                	jmp    8009b6 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80096b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096f:	8b 00                	mov    (%rax),%eax
  800971:	83 f8 30             	cmp    $0x30,%eax
  800974:	73 24                	jae    80099a <getint+0xe5>
  800976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	8b 00                	mov    (%rax),%eax
  800984:	89 c0                	mov    %eax,%eax
  800986:	48 01 d0             	add    %rdx,%rax
  800989:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098d:	8b 12                	mov    (%rdx),%edx
  80098f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	89 0a                	mov    %ecx,(%rdx)
  800998:	eb 14                	jmp    8009ae <getint+0xf9>
  80099a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ae:	8b 00                	mov    (%rax),%eax
  8009b0:	48 98                	cltq   
  8009b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ba:	c9                   	leaveq 
  8009bb:	c3                   	retq   

00000000008009bc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009bc:	55                   	push   %rbp
  8009bd:	48 89 e5             	mov    %rsp,%rbp
  8009c0:	41 54                	push   %r12
  8009c2:	53                   	push   %rbx
  8009c3:	48 83 ec 60          	sub    $0x60,%rsp
  8009c7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009cb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009cf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009d7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009db:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009df:	48 8b 0a             	mov    (%rdx),%rcx
  8009e2:	48 89 08             	mov    %rcx,(%rax)
  8009e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f5:	eb 17                	jmp    800a0e <vprintfmt+0x52>
			if (ch == '\0')
  8009f7:	85 db                	test   %ebx,%ebx
  8009f9:	0f 84 b9 04 00 00    	je     800eb8 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8009ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a07:	48 89 d6             	mov    %rdx,%rsi
  800a0a:	89 df                	mov    %ebx,%edi
  800a0c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a12:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a16:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a1a:	0f b6 00             	movzbl (%rax),%eax
  800a1d:	0f b6 d8             	movzbl %al,%ebx
  800a20:	83 fb 25             	cmp    $0x25,%ebx
  800a23:	75 d2                	jne    8009f7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a25:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a29:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a3e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a45:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a49:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a4d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a51:	0f b6 00             	movzbl (%rax),%eax
  800a54:	0f b6 d8             	movzbl %al,%ebx
  800a57:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a5a:	83 f8 55             	cmp    $0x55,%eax
  800a5d:	0f 87 22 04 00 00    	ja     800e85 <vprintfmt+0x4c9>
  800a63:	89 c0                	mov    %eax,%eax
  800a65:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a6c:	00 
  800a6d:	48 b8 d8 4e 80 00 00 	movabs $0x804ed8,%rax
  800a74:	00 00 00 
  800a77:	48 01 d0             	add    %rdx,%rax
  800a7a:	48 8b 00             	mov    (%rax),%rax
  800a7d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a7f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a83:	eb c0                	jmp    800a45 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a85:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a89:	eb ba                	jmp    800a45 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a8b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a92:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a95:	89 d0                	mov    %edx,%eax
  800a97:	c1 e0 02             	shl    $0x2,%eax
  800a9a:	01 d0                	add    %edx,%eax
  800a9c:	01 c0                	add    %eax,%eax
  800a9e:	01 d8                	add    %ebx,%eax
  800aa0:	83 e8 30             	sub    $0x30,%eax
  800aa3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800aa6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aaa:	0f b6 00             	movzbl (%rax),%eax
  800aad:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ab0:	83 fb 2f             	cmp    $0x2f,%ebx
  800ab3:	7e 60                	jle    800b15 <vprintfmt+0x159>
  800ab5:	83 fb 39             	cmp    $0x39,%ebx
  800ab8:	7f 5b                	jg     800b15 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aba:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800abf:	eb d1                	jmp    800a92 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ac1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac4:	83 f8 30             	cmp    $0x30,%eax
  800ac7:	73 17                	jae    800ae0 <vprintfmt+0x124>
  800ac9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800acd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad0:	89 d2                	mov    %edx,%edx
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad8:	83 c2 08             	add    $0x8,%edx
  800adb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ade:	eb 0c                	jmp    800aec <vprintfmt+0x130>
  800ae0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ae4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ae8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aec:	8b 00                	mov    (%rax),%eax
  800aee:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800af1:	eb 23                	jmp    800b16 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af7:	0f 89 48 ff ff ff    	jns    800a45 <vprintfmt+0x89>
				width = 0;
  800afd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b04:	e9 3c ff ff ff       	jmpq   800a45 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b09:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b10:	e9 30 ff ff ff       	jmpq   800a45 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b15:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1a:	0f 89 25 ff ff ff    	jns    800a45 <vprintfmt+0x89>
				width = precision, precision = -1;
  800b20:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b23:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b26:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b2d:	e9 13 ff ff ff       	jmpq   800a45 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b32:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b36:	e9 0a ff ff ff       	jmpq   800a45 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	83 f8 30             	cmp    $0x30,%eax
  800b41:	73 17                	jae    800b5a <vprintfmt+0x19e>
  800b43:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4a:	89 d2                	mov    %edx,%edx
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b52:	83 c2 08             	add    $0x8,%edx
  800b55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b58:	eb 0c                	jmp    800b66 <vprintfmt+0x1aa>
  800b5a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b5e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b62:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b66:	8b 10                	mov    (%rax),%edx
  800b68:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b70:	48 89 ce             	mov    %rcx,%rsi
  800b73:	89 d7                	mov    %edx,%edi
  800b75:	ff d0                	callq  *%rax
			break;
  800b77:	e9 37 03 00 00       	jmpq   800eb3 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7f:	83 f8 30             	cmp    $0x30,%eax
  800b82:	73 17                	jae    800b9b <vprintfmt+0x1df>
  800b84:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8b:	89 d2                	mov    %edx,%edx
  800b8d:	48 01 d0             	add    %rdx,%rax
  800b90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b93:	83 c2 08             	add    $0x8,%edx
  800b96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b99:	eb 0c                	jmp    800ba7 <vprintfmt+0x1eb>
  800b9b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b9f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ba3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ba9:	85 db                	test   %ebx,%ebx
  800bab:	79 02                	jns    800baf <vprintfmt+0x1f3>
				err = -err;
  800bad:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800baf:	83 fb 15             	cmp    $0x15,%ebx
  800bb2:	7f 16                	jg     800bca <vprintfmt+0x20e>
  800bb4:	48 b8 00 4e 80 00 00 	movabs $0x804e00,%rax
  800bbb:	00 00 00 
  800bbe:	48 63 d3             	movslq %ebx,%rdx
  800bc1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bc5:	4d 85 e4             	test   %r12,%r12
  800bc8:	75 2e                	jne    800bf8 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800bca:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd2:	89 d9                	mov    %ebx,%ecx
  800bd4:	48 ba c1 4e 80 00 00 	movabs $0x804ec1,%rdx
  800bdb:	00 00 00 
  800bde:	48 89 c7             	mov    %rax,%rdi
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	49 b8 c2 0e 80 00 00 	movabs $0x800ec2,%r8
  800bed:	00 00 00 
  800bf0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bf3:	e9 bb 02 00 00       	jmpq   800eb3 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bf8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	4c 89 e1             	mov    %r12,%rcx
  800c03:	48 ba ca 4e 80 00 00 	movabs $0x804eca,%rdx
  800c0a:	00 00 00 
  800c0d:	48 89 c7             	mov    %rax,%rdi
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
  800c15:	49 b8 c2 0e 80 00 00 	movabs $0x800ec2,%r8
  800c1c:	00 00 00 
  800c1f:	41 ff d0             	callq  *%r8
			break;
  800c22:	e9 8c 02 00 00       	jmpq   800eb3 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2a:	83 f8 30             	cmp    $0x30,%eax
  800c2d:	73 17                	jae    800c46 <vprintfmt+0x28a>
  800c2f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c33:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c36:	89 d2                	mov    %edx,%edx
  800c38:	48 01 d0             	add    %rdx,%rax
  800c3b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c3e:	83 c2 08             	add    $0x8,%edx
  800c41:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c44:	eb 0c                	jmp    800c52 <vprintfmt+0x296>
  800c46:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c4a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c4e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c52:	4c 8b 20             	mov    (%rax),%r12
  800c55:	4d 85 e4             	test   %r12,%r12
  800c58:	75 0a                	jne    800c64 <vprintfmt+0x2a8>
				p = "(null)";
  800c5a:	49 bc cd 4e 80 00 00 	movabs $0x804ecd,%r12
  800c61:	00 00 00 
			if (width > 0 && padc != '-')
  800c64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c68:	7e 78                	jle    800ce2 <vprintfmt+0x326>
  800c6a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c6e:	74 72                	je     800ce2 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c70:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c73:	48 98                	cltq   
  800c75:	48 89 c6             	mov    %rax,%rsi
  800c78:	4c 89 e7             	mov    %r12,%rdi
  800c7b:	48 b8 70 11 80 00 00 	movabs $0x801170,%rax
  800c82:	00 00 00 
  800c85:	ff d0                	callq  *%rax
  800c87:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c8a:	eb 17                	jmp    800ca3 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800c8c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c90:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c98:	48 89 ce             	mov    %rcx,%rsi
  800c9b:	89 d7                	mov    %edx,%edi
  800c9d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c9f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ca3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ca7:	7f e3                	jg     800c8c <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca9:	eb 37                	jmp    800ce2 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800cab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800caf:	74 1e                	je     800ccf <vprintfmt+0x313>
  800cb1:	83 fb 1f             	cmp    $0x1f,%ebx
  800cb4:	7e 05                	jle    800cbb <vprintfmt+0x2ff>
  800cb6:	83 fb 7e             	cmp    $0x7e,%ebx
  800cb9:	7e 14                	jle    800ccf <vprintfmt+0x313>
					putch('?', putdat);
  800cbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc3:	48 89 d6             	mov    %rdx,%rsi
  800cc6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ccb:	ff d0                	callq  *%rax
  800ccd:	eb 0f                	jmp    800cde <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800ccf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd7:	48 89 d6             	mov    %rdx,%rsi
  800cda:	89 df                	mov    %ebx,%edi
  800cdc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cde:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce2:	4c 89 e0             	mov    %r12,%rax
  800ce5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ce9:	0f b6 00             	movzbl (%rax),%eax
  800cec:	0f be d8             	movsbl %al,%ebx
  800cef:	85 db                	test   %ebx,%ebx
  800cf1:	74 28                	je     800d1b <vprintfmt+0x35f>
  800cf3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cf7:	78 b2                	js     800cab <vprintfmt+0x2ef>
  800cf9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cfd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d01:	79 a8                	jns    800cab <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d03:	eb 16                	jmp    800d1b <vprintfmt+0x35f>
				putch(' ', putdat);
  800d05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0d:	48 89 d6             	mov    %rdx,%rsi
  800d10:	bf 20 00 00 00       	mov    $0x20,%edi
  800d15:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d17:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1f:	7f e4                	jg     800d05 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800d21:	e9 8d 01 00 00       	jmpq   800eb3 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d2a:	be 03 00 00 00       	mov    $0x3,%esi
  800d2f:	48 89 c7             	mov    %rax,%rdi
  800d32:	48 b8 b5 08 80 00 00 	movabs $0x8008b5,%rax
  800d39:	00 00 00 
  800d3c:	ff d0                	callq  *%rax
  800d3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d46:	48 85 c0             	test   %rax,%rax
  800d49:	79 1d                	jns    800d68 <vprintfmt+0x3ac>
				putch('-', putdat);
  800d4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d53:	48 89 d6             	mov    %rdx,%rsi
  800d56:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d5b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d61:	48 f7 d8             	neg    %rax
  800d64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d68:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d6f:	e9 d2 00 00 00       	jmpq   800e46 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d74:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d78:	be 03 00 00 00       	mov    $0x3,%esi
  800d7d:	48 89 c7             	mov    %rax,%rdi
  800d80:	48 b8 ae 07 80 00 00 	movabs $0x8007ae,%rax
  800d87:	00 00 00 
  800d8a:	ff d0                	callq  *%rax
  800d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d90:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d97:	e9 aa 00 00 00       	jmpq   800e46 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800d9c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da0:	be 03 00 00 00       	mov    $0x3,%esi
  800da5:	48 89 c7             	mov    %rax,%rdi
  800da8:	48 b8 ae 07 80 00 00 	movabs $0x8007ae,%rax
  800daf:	00 00 00 
  800db2:	ff d0                	callq  *%rax
  800db4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800db8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dbf:	e9 82 00 00 00       	jmpq   800e46 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800dc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcc:	48 89 d6             	mov    %rdx,%rsi
  800dcf:	bf 30 00 00 00       	mov    $0x30,%edi
  800dd4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dd6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dde:	48 89 d6             	mov    %rdx,%rsi
  800de1:	bf 78 00 00 00       	mov    $0x78,%edi
  800de6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800de8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800deb:	83 f8 30             	cmp    $0x30,%eax
  800dee:	73 17                	jae    800e07 <vprintfmt+0x44b>
  800df0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800df4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800df7:	89 d2                	mov    %edx,%edx
  800df9:	48 01 d0             	add    %rdx,%rax
  800dfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dff:	83 c2 08             	add    $0x8,%edx
  800e02:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e05:	eb 0c                	jmp    800e13 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800e07:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e0b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e13:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e1a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e21:	eb 23                	jmp    800e46 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e23:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e27:	be 03 00 00 00       	mov    $0x3,%esi
  800e2c:	48 89 c7             	mov    %rax,%rdi
  800e2f:	48 b8 ae 07 80 00 00 	movabs $0x8007ae,%rax
  800e36:	00 00 00 
  800e39:	ff d0                	callq  *%rax
  800e3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e3f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e46:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e4b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e4e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e55:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5d:	45 89 c1             	mov    %r8d,%r9d
  800e60:	41 89 f8             	mov    %edi,%r8d
  800e63:	48 89 c7             	mov    %rax,%rdi
  800e66:	48 b8 f6 06 80 00 00 	movabs $0x8006f6,%rax
  800e6d:	00 00 00 
  800e70:	ff d0                	callq  *%rax
			break;
  800e72:	eb 3f                	jmp    800eb3 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7c:	48 89 d6             	mov    %rdx,%rsi
  800e7f:	89 df                	mov    %ebx,%edi
  800e81:	ff d0                	callq  *%rax
			break;
  800e83:	eb 2e                	jmp    800eb3 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8d:	48 89 d6             	mov    %rdx,%rsi
  800e90:	bf 25 00 00 00       	mov    $0x25,%edi
  800e95:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e97:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e9c:	eb 05                	jmp    800ea3 <vprintfmt+0x4e7>
  800e9e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ea3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ea7:	48 83 e8 01          	sub    $0x1,%rax
  800eab:	0f b6 00             	movzbl (%rax),%eax
  800eae:	3c 25                	cmp    $0x25,%al
  800eb0:	75 ec                	jne    800e9e <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800eb2:	90                   	nop
		}
	}
  800eb3:	e9 3d fb ff ff       	jmpq   8009f5 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800eb8:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800eb9:	48 83 c4 60          	add    $0x60,%rsp
  800ebd:	5b                   	pop    %rbx
  800ebe:	41 5c                	pop    %r12
  800ec0:	5d                   	pop    %rbp
  800ec1:	c3                   	retq   

0000000000800ec2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ec2:	55                   	push   %rbp
  800ec3:	48 89 e5             	mov    %rsp,%rbp
  800ec6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ecd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ed4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800edb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800ee2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ee9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ef0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ef7:	84 c0                	test   %al,%al
  800ef9:	74 20                	je     800f1b <printfmt+0x59>
  800efb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f03:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f07:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f0b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f0f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f13:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f17:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f1b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f22:	00 00 00 
  800f25:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f2c:	00 00 00 
  800f2f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f33:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f3a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f41:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f48:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f4f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f56:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f5d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f64:	48 89 c7             	mov    %rax,%rdi
  800f67:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  800f6e:	00 00 00 
  800f71:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f73:	90                   	nop
  800f74:	c9                   	leaveq 
  800f75:	c3                   	retq   

0000000000800f76 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f76:	55                   	push   %rbp
  800f77:	48 89 e5             	mov    %rsp,%rbp
  800f7a:	48 83 ec 10          	sub    $0x10,%rsp
  800f7e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f89:	8b 40 10             	mov    0x10(%rax),%eax
  800f8c:	8d 50 01             	lea    0x1(%rax),%edx
  800f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f93:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9a:	48 8b 10             	mov    (%rax),%rdx
  800f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fa5:	48 39 c2             	cmp    %rax,%rdx
  800fa8:	73 17                	jae    800fc1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fae:	48 8b 00             	mov    (%rax),%rax
  800fb1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fb9:	48 89 0a             	mov    %rcx,(%rdx)
  800fbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fbf:	88 10                	mov    %dl,(%rax)
}
  800fc1:	90                   	nop
  800fc2:	c9                   	leaveq 
  800fc3:	c3                   	retq   

0000000000800fc4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc4:	55                   	push   %rbp
  800fc5:	48 89 e5             	mov    %rsp,%rbp
  800fc8:	48 83 ec 50          	sub    $0x50,%rsp
  800fcc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fd0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fd3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fd7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fdb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fdf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fe3:	48 8b 0a             	mov    (%rdx),%rcx
  800fe6:	48 89 08             	mov    %rcx,(%rax)
  800fe9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ff9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ffd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801001:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801004:	48 98                	cltq   
  801006:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80100a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80100e:	48 01 d0             	add    %rdx,%rax
  801011:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801015:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80101c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801021:	74 06                	je     801029 <vsnprintf+0x65>
  801023:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801027:	7f 07                	jg     801030 <vsnprintf+0x6c>
		return -E_INVAL;
  801029:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102e:	eb 2f                	jmp    80105f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801030:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801034:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801038:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80103c:	48 89 c6             	mov    %rax,%rsi
  80103f:	48 bf 76 0f 80 00 00 	movabs $0x800f76,%rdi
  801046:	00 00 00 
  801049:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  801050:	00 00 00 
  801053:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801055:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801059:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80105c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80105f:	c9                   	leaveq 
  801060:	c3                   	retq   

0000000000801061 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801061:	55                   	push   %rbp
  801062:	48 89 e5             	mov    %rsp,%rbp
  801065:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80106c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801073:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801079:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801080:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801087:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80108e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801095:	84 c0                	test   %al,%al
  801097:	74 20                	je     8010b9 <snprintf+0x58>
  801099:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80109d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010b9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010c0:	00 00 00 
  8010c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010ca:	00 00 00 
  8010cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010e6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010ed:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010f4:	48 8b 0a             	mov    (%rdx),%rcx
  8010f7:	48 89 08             	mov    %rcx,(%rax)
  8010fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801102:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801106:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80110a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801111:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801118:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80111e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801125:	48 89 c7             	mov    %rax,%rdi
  801128:	48 b8 c4 0f 80 00 00 	movabs $0x800fc4,%rax
  80112f:	00 00 00 
  801132:	ff d0                	callq  *%rax
  801134:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80113a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 18          	sub    $0x18,%rsp
  80114a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80114e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801155:	eb 09                	jmp    801160 <strlen+0x1e>
		n++;
  801157:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80115b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801164:	0f b6 00             	movzbl (%rax),%eax
  801167:	84 c0                	test   %al,%al
  801169:	75 ec                	jne    801157 <strlen+0x15>
		n++;
	return n;
  80116b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80116e:	c9                   	leaveq 
  80116f:	c3                   	retq   

0000000000801170 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801170:	55                   	push   %rbp
  801171:	48 89 e5             	mov    %rsp,%rbp
  801174:	48 83 ec 20          	sub    $0x20,%rsp
  801178:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801187:	eb 0e                	jmp    801197 <strnlen+0x27>
		n++;
  801189:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80118d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801192:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801197:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80119c:	74 0b                	je     8011a9 <strnlen+0x39>
  80119e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a2:	0f b6 00             	movzbl (%rax),%eax
  8011a5:	84 c0                	test   %al,%al
  8011a7:	75 e0                	jne    801189 <strnlen+0x19>
		n++;
	return n;
  8011a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011ac:	c9                   	leaveq 
  8011ad:	c3                   	retq   

00000000008011ae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ae:	55                   	push   %rbp
  8011af:	48 89 e5             	mov    %rsp,%rbp
  8011b2:	48 83 ec 20          	sub    $0x20,%rsp
  8011b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011c6:	90                   	nop
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011d7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011db:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011df:	0f b6 12             	movzbl (%rdx),%edx
  8011e2:	88 10                	mov    %dl,(%rax)
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 dc                	jne    8011c7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ef:	c9                   	leaveq 
  8011f0:	c3                   	retq   

00000000008011f1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	48 83 ec 20          	sub    $0x20,%rsp
  8011f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801205:	48 89 c7             	mov    %rax,%rdi
  801208:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  80120f:	00 00 00 
  801212:	ff d0                	callq  *%rax
  801214:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80121a:	48 63 d0             	movslq %eax,%rdx
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801221:	48 01 c2             	add    %rax,%rdx
  801224:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801228:	48 89 c6             	mov    %rax,%rsi
  80122b:	48 89 d7             	mov    %rdx,%rdi
  80122e:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  801235:	00 00 00 
  801238:	ff d0                	callq  *%rax
	return dst;
  80123a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80123e:	c9                   	leaveq 
  80123f:	c3                   	retq   

0000000000801240 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801240:	55                   	push   %rbp
  801241:	48 89 e5             	mov    %rsp,%rbp
  801244:	48 83 ec 28          	sub    $0x28,%rsp
  801248:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801250:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801258:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80125c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801263:	00 
  801264:	eb 2a                	jmp    801290 <strncpy+0x50>
		*dst++ = *src;
  801266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80126e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801272:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801276:	0f b6 12             	movzbl (%rdx),%edx
  801279:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80127b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	84 c0                	test   %al,%al
  801284:	74 05                	je     80128b <strncpy+0x4b>
			src++;
  801286:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80128b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801298:	72 cc                	jb     801266 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80129a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 28          	sub    $0x28,%rsp
  8012a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012bc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012c1:	74 3d                	je     801300 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012c3:	eb 1d                	jmp    8012e2 <strlcpy+0x42>
			*dst++ = *src++;
  8012c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012d9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012dd:	0f b6 12             	movzbl (%rdx),%edx
  8012e0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012e2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012e7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012ec:	74 0b                	je     8012f9 <strlcpy+0x59>
  8012ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	84 c0                	test   %al,%al
  8012f7:	75 cc                	jne    8012c5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801300:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	48 29 c2             	sub    %rax,%rdx
  80130b:	48 89 d0             	mov    %rdx,%rax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 10          	sub    $0x10,%rsp
  801318:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801320:	eb 0a                	jmp    80132c <strcmp+0x1c>
		p++, q++;
  801322:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801327:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801330:	0f b6 00             	movzbl (%rax),%eax
  801333:	84 c0                	test   %al,%al
  801335:	74 12                	je     801349 <strcmp+0x39>
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133b:	0f b6 10             	movzbl (%rax),%edx
  80133e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	38 c2                	cmp    %al,%dl
  801347:	74 d9                	je     801322 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	0f b6 00             	movzbl (%rax),%eax
  801350:	0f b6 d0             	movzbl %al,%edx
  801353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801357:	0f b6 00             	movzbl (%rax),%eax
  80135a:	0f b6 c0             	movzbl %al,%eax
  80135d:	29 c2                	sub    %eax,%edx
  80135f:	89 d0                	mov    %edx,%eax
}
  801361:	c9                   	leaveq 
  801362:	c3                   	retq   

0000000000801363 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801363:	55                   	push   %rbp
  801364:	48 89 e5             	mov    %rsp,%rbp
  801367:	48 83 ec 18          	sub    $0x18,%rsp
  80136b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801373:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801377:	eb 0f                	jmp    801388 <strncmp+0x25>
		n--, p++, q++;
  801379:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80137e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801383:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801388:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80138d:	74 1d                	je     8013ac <strncmp+0x49>
  80138f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	84 c0                	test   %al,%al
  801398:	74 12                	je     8013ac <strncmp+0x49>
  80139a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139e:	0f b6 10             	movzbl (%rax),%edx
  8013a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	38 c2                	cmp    %al,%dl
  8013aa:	74 cd                	je     801379 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013b1:	75 07                	jne    8013ba <strncmp+0x57>
		return 0;
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	eb 18                	jmp    8013d2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	0f b6 d0             	movzbl %al,%edx
  8013c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	c9                   	leaveq 
  8013d3:	c3                   	retq   

00000000008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %rbp
  8013d5:	48 89 e5             	mov    %rsp,%rbp
  8013d8:	48 83 ec 10          	sub    $0x10,%rsp
  8013dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e0:	89 f0                	mov    %esi,%eax
  8013e2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013e5:	eb 17                	jmp    8013fe <strchr+0x2a>
		if (*s == c)
  8013e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f1:	75 06                	jne    8013f9 <strchr+0x25>
			return (char *) s;
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	eb 15                	jmp    80140e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	84 c0                	test   %al,%al
  801407:	75 de                	jne    8013e7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140e:	c9                   	leaveq 
  80140f:	c3                   	retq   

0000000000801410 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801410:	55                   	push   %rbp
  801411:	48 89 e5             	mov    %rsp,%rbp
  801414:	48 83 ec 10          	sub    $0x10,%rsp
  801418:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141c:	89 f0                	mov    %esi,%eax
  80141e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801421:	eb 11                	jmp    801434 <strfind+0x24>
		if (*s == c)
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80142d:	74 12                	je     801441 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80142f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	84 c0                	test   %al,%al
  80143d:	75 e4                	jne    801423 <strfind+0x13>
  80143f:	eb 01                	jmp    801442 <strfind+0x32>
		if (*s == c)
			break;
  801441:	90                   	nop
	return (char *) s;
  801442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801446:	c9                   	leaveq 
  801447:	c3                   	retq   

0000000000801448 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801448:	55                   	push   %rbp
  801449:	48 89 e5             	mov    %rsp,%rbp
  80144c:	48 83 ec 18          	sub    $0x18,%rsp
  801450:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801454:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801457:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80145b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801460:	75 06                	jne    801468 <memset+0x20>
		return v;
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	eb 69                	jmp    8014d1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146c:	83 e0 03             	and    $0x3,%eax
  80146f:	48 85 c0             	test   %rax,%rax
  801472:	75 48                	jne    8014bc <memset+0x74>
  801474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	48 85 c0             	test   %rax,%rax
  80147e:	75 3c                	jne    8014bc <memset+0x74>
		c &= 0xFF;
  801480:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801487:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80148a:	c1 e0 18             	shl    $0x18,%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801492:	c1 e0 10             	shl    $0x10,%eax
  801495:	09 c2                	or     %eax,%edx
  801497:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80149a:	c1 e0 08             	shl    $0x8,%eax
  80149d:	09 d0                	or     %edx,%eax
  80149f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a6:	48 c1 e8 02          	shr    $0x2,%rax
  8014aa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b4:	48 89 d7             	mov    %rdx,%rdi
  8014b7:	fc                   	cld    
  8014b8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014ba:	eb 11                	jmp    8014cd <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014c7:	48 89 d7             	mov    %rdx,%rdi
  8014ca:	fc                   	cld    
  8014cb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014d1:	c9                   	leaveq 
  8014d2:	c3                   	retq   

00000000008014d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014d3:	55                   	push   %rbp
  8014d4:	48 89 e5             	mov    %rsp,%rbp
  8014d7:	48 83 ec 28          	sub    $0x28,%rsp
  8014db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014ff:	0f 83 88 00 00 00    	jae    80158d <memmove+0xba>
  801505:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	48 01 d0             	add    %rdx,%rax
  801510:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801514:	76 77                	jbe    80158d <memmove+0xba>
		s += n;
  801516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801526:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152a:	83 e0 03             	and    $0x3,%eax
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	75 3b                	jne    80156d <memmove+0x9a>
  801532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801536:	83 e0 03             	and    $0x3,%eax
  801539:	48 85 c0             	test   %rax,%rax
  80153c:	75 2f                	jne    80156d <memmove+0x9a>
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	83 e0 03             	and    $0x3,%eax
  801545:	48 85 c0             	test   %rax,%rax
  801548:	75 23                	jne    80156d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	48 83 e8 04          	sub    $0x4,%rax
  801552:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801556:	48 83 ea 04          	sub    $0x4,%rdx
  80155a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80155e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801562:	48 89 c7             	mov    %rax,%rdi
  801565:	48 89 d6             	mov    %rdx,%rsi
  801568:	fd                   	std    
  801569:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80156b:	eb 1d                	jmp    80158a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80156d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801571:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801579:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80157d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801581:	48 89 d7             	mov    %rdx,%rdi
  801584:	48 89 c1             	mov    %rax,%rcx
  801587:	fd                   	std    
  801588:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80158a:	fc                   	cld    
  80158b:	eb 57                	jmp    8015e4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80158d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801591:	83 e0 03             	and    $0x3,%eax
  801594:	48 85 c0             	test   %rax,%rax
  801597:	75 36                	jne    8015cf <memmove+0xfc>
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	83 e0 03             	and    $0x3,%eax
  8015a0:	48 85 c0             	test   %rax,%rax
  8015a3:	75 2a                	jne    8015cf <memmove+0xfc>
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	83 e0 03             	and    $0x3,%eax
  8015ac:	48 85 c0             	test   %rax,%rax
  8015af:	75 1e                	jne    8015cf <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	48 c1 e8 02          	shr    $0x2,%rax
  8015b9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c4:	48 89 c7             	mov    %rax,%rdi
  8015c7:	48 89 d6             	mov    %rdx,%rsi
  8015ca:	fc                   	cld    
  8015cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015cd:	eb 15                	jmp    8015e4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015db:	48 89 c7             	mov    %rax,%rdi
  8015de:	48 89 d6             	mov    %rdx,%rsi
  8015e1:	fc                   	cld    
  8015e2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e8:	c9                   	leaveq 
  8015e9:	c3                   	retq   

00000000008015ea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015ea:	55                   	push   %rbp
  8015eb:	48 89 e5             	mov    %rsp,%rbp
  8015ee:	48 83 ec 18          	sub    $0x18,%rsp
  8015f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801602:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801606:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160a:	48 89 ce             	mov    %rcx,%rsi
  80160d:	48 89 c7             	mov    %rax,%rdi
  801610:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  801617:	00 00 00 
  80161a:	ff d0                	callq  *%rax
}
  80161c:	c9                   	leaveq 
  80161d:	c3                   	retq   

000000000080161e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80161e:	55                   	push   %rbp
  80161f:	48 89 e5             	mov    %rsp,%rbp
  801622:	48 83 ec 28          	sub    $0x28,%rsp
  801626:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801636:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80163a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80163e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801642:	eb 36                	jmp    80167a <memcmp+0x5c>
		if (*s1 != *s2)
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	0f b6 10             	movzbl (%rax),%edx
  80164b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	38 c2                	cmp    %al,%dl
  801654:	74 1a                	je     801670 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801656:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	0f b6 d0             	movzbl %al,%edx
  801660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
  80166e:	eb 20                	jmp    801690 <memcmp+0x72>
		s1++, s2++;
  801670:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801675:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801682:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801686:	48 85 c0             	test   %rax,%rax
  801689:	75 b9                	jne    801644 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801690:	c9                   	leaveq 
  801691:	c3                   	retq   

0000000000801692 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801692:	55                   	push   %rbp
  801693:	48 89 e5             	mov    %rsp,%rbp
  801696:	48 83 ec 28          	sub    $0x28,%rsp
  80169a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80169e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	48 01 d0             	add    %rdx,%rax
  8016b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016b4:	eb 19                	jmp    8016cf <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	0f b6 d0             	movzbl %al,%edx
  8016c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016c3:	0f b6 c0             	movzbl %al,%eax
  8016c6:	39 c2                	cmp    %eax,%edx
  8016c8:	74 11                	je     8016db <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016d7:	72 dd                	jb     8016b6 <memfind+0x24>
  8016d9:	eb 01                	jmp    8016dc <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016db:	90                   	nop
	return (void *) s;
  8016dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e0:	c9                   	leaveq 
  8016e1:	c3                   	retq   

00000000008016e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016e2:	55                   	push   %rbp
  8016e3:	48 89 e5             	mov    %rsp,%rbp
  8016e6:	48 83 ec 38          	sub    $0x38,%rsp
  8016ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016f2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016fc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801703:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801704:	eb 05                	jmp    80170b <strtol+0x29>
		s++;
  801706:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	3c 20                	cmp    $0x20,%al
  801714:	74 f0                	je     801706 <strtol+0x24>
  801716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	3c 09                	cmp    $0x9,%al
  80171f:	74 e5                	je     801706 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	3c 2b                	cmp    $0x2b,%al
  80172a:	75 07                	jne    801733 <strtol+0x51>
		s++;
  80172c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801731:	eb 17                	jmp    80174a <strtol+0x68>
	else if (*s == '-')
  801733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	3c 2d                	cmp    $0x2d,%al
  80173c:	75 0c                	jne    80174a <strtol+0x68>
		s++, neg = 1;
  80173e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801743:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80174a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80174e:	74 06                	je     801756 <strtol+0x74>
  801750:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801754:	75 28                	jne    80177e <strtol+0x9c>
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	3c 30                	cmp    $0x30,%al
  80175f:	75 1d                	jne    80177e <strtol+0x9c>
  801761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801765:	48 83 c0 01          	add    $0x1,%rax
  801769:	0f b6 00             	movzbl (%rax),%eax
  80176c:	3c 78                	cmp    $0x78,%al
  80176e:	75 0e                	jne    80177e <strtol+0x9c>
		s += 2, base = 16;
  801770:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801775:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80177c:	eb 2c                	jmp    8017aa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80177e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801782:	75 19                	jne    80179d <strtol+0xbb>
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 30                	cmp    $0x30,%al
  80178d:	75 0e                	jne    80179d <strtol+0xbb>
		s++, base = 8;
  80178f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801794:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80179b:	eb 0d                	jmp    8017aa <strtol+0xc8>
	else if (base == 0)
  80179d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a1:	75 07                	jne    8017aa <strtol+0xc8>
		base = 10;
  8017a3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ae:	0f b6 00             	movzbl (%rax),%eax
  8017b1:	3c 2f                	cmp    $0x2f,%al
  8017b3:	7e 1d                	jle    8017d2 <strtol+0xf0>
  8017b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b9:	0f b6 00             	movzbl (%rax),%eax
  8017bc:	3c 39                	cmp    $0x39,%al
  8017be:	7f 12                	jg     8017d2 <strtol+0xf0>
			dig = *s - '0';
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	0f be c0             	movsbl %al,%eax
  8017ca:	83 e8 30             	sub    $0x30,%eax
  8017cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017d0:	eb 4e                	jmp    801820 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d6:	0f b6 00             	movzbl (%rax),%eax
  8017d9:	3c 60                	cmp    $0x60,%al
  8017db:	7e 1d                	jle    8017fa <strtol+0x118>
  8017dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e1:	0f b6 00             	movzbl (%rax),%eax
  8017e4:	3c 7a                	cmp    $0x7a,%al
  8017e6:	7f 12                	jg     8017fa <strtol+0x118>
			dig = *s - 'a' + 10;
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	0f be c0             	movsbl %al,%eax
  8017f2:	83 e8 57             	sub    $0x57,%eax
  8017f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017f8:	eb 26                	jmp    801820 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fe:	0f b6 00             	movzbl (%rax),%eax
  801801:	3c 40                	cmp    $0x40,%al
  801803:	7e 47                	jle    80184c <strtol+0x16a>
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	0f b6 00             	movzbl (%rax),%eax
  80180c:	3c 5a                	cmp    $0x5a,%al
  80180e:	7f 3c                	jg     80184c <strtol+0x16a>
			dig = *s - 'A' + 10;
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	0f be c0             	movsbl %al,%eax
  80181a:	83 e8 37             	sub    $0x37,%eax
  80181d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801820:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801823:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801826:	7d 23                	jge    80184b <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801828:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80182d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801830:	48 98                	cltq   
  801832:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801837:	48 89 c2             	mov    %rax,%rdx
  80183a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80183d:	48 98                	cltq   
  80183f:	48 01 d0             	add    %rdx,%rax
  801842:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801846:	e9 5f ff ff ff       	jmpq   8017aa <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80184b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80184c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801851:	74 0b                	je     80185e <strtol+0x17c>
		*endptr = (char *) s;
  801853:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801857:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80185b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80185e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801862:	74 09                	je     80186d <strtol+0x18b>
  801864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801868:	48 f7 d8             	neg    %rax
  80186b:	eb 04                	jmp    801871 <strtol+0x18f>
  80186d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801871:	c9                   	leaveq 
  801872:	c3                   	retq   

0000000000801873 <strstr>:

char * strstr(const char *in, const char *str)
{
  801873:	55                   	push   %rbp
  801874:	48 89 e5             	mov    %rsp,%rbp
  801877:	48 83 ec 30          	sub    $0x30,%rsp
  80187b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80187f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801883:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801887:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80188b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80188f:	0f b6 00             	movzbl (%rax),%eax
  801892:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801895:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801899:	75 06                	jne    8018a1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80189b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189f:	eb 6b                	jmp    80190c <strstr+0x99>

	len = strlen(str);
  8018a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a5:	48 89 c7             	mov    %rax,%rdi
  8018a8:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  8018af:	00 00 00 
  8018b2:	ff d0                	callq  *%rax
  8018b4:	48 98                	cltq   
  8018b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018c6:	0f b6 00             	movzbl (%rax),%eax
  8018c9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018cc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018d0:	75 07                	jne    8018d9 <strstr+0x66>
				return (char *) 0;
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	eb 33                	jmp    80190c <strstr+0x99>
		} while (sc != c);
  8018d9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018dd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018e0:	75 d8                	jne    8018ba <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ee:	48 89 ce             	mov    %rcx,%rsi
  8018f1:	48 89 c7             	mov    %rax,%rdi
  8018f4:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
  801900:	85 c0                	test   %eax,%eax
  801902:	75 b6                	jne    8018ba <strstr+0x47>

	return (char *) (in - 1);
  801904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801908:	48 83 e8 01          	sub    $0x1,%rax
}
  80190c:	c9                   	leaveq 
  80190d:	c3                   	retq   

000000000080190e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80190e:	55                   	push   %rbp
  80190f:	48 89 e5             	mov    %rsp,%rbp
  801912:	53                   	push   %rbx
  801913:	48 83 ec 48          	sub    $0x48,%rsp
  801917:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80191a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80191d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801921:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801925:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801929:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801930:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801934:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801938:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80193c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801940:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801944:	4c 89 c3             	mov    %r8,%rbx
  801947:	cd 30                	int    $0x30
  801949:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80194d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801951:	74 3e                	je     801991 <syscall+0x83>
  801953:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801958:	7e 37                	jle    801991 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80195a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80195e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801961:	49 89 d0             	mov    %rdx,%r8
  801964:	89 c1                	mov    %eax,%ecx
  801966:	48 ba 88 51 80 00 00 	movabs $0x805188,%rdx
  80196d:	00 00 00 
  801970:	be 24 00 00 00       	mov    $0x24,%esi
  801975:	48 bf a5 51 80 00 00 	movabs $0x8051a5,%rdi
  80197c:	00 00 00 
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
  801984:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  80198b:	00 00 00 
  80198e:	41 ff d1             	callq  *%r9

	return ret;
  801991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801995:	48 83 c4 48          	add    $0x48,%rsp
  801999:	5b                   	pop    %rbx
  80199a:	5d                   	pop    %rbp
  80199b:	c3                   	retq   

000000000080199c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	48 83 ec 10          	sub    $0x10,%rsp
  8019a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b4:	48 83 ec 08          	sub    $0x8,%rsp
  8019b8:	6a 00                	pushq  $0x0
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c6:	48 89 d1             	mov    %rdx,%rcx
  8019c9:	48 89 c2             	mov    %rax,%rdx
  8019cc:	be 00 00 00 00       	mov    $0x0,%esi
  8019d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d6:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	callq  *%rax
  8019e2:	48 83 c4 10          	add    $0x10,%rsp
}
  8019e6:	90                   	nop
  8019e7:	c9                   	leaveq 
  8019e8:	c3                   	retq   

00000000008019e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e9:	55                   	push   %rbp
  8019ea:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019ed:	48 83 ec 08          	sub    $0x8,%rsp
  8019f1:	6a 00                	pushq  $0x0
  8019f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a04:	ba 00 00 00 00       	mov    $0x0,%edx
  801a09:	be 00 00 00 00       	mov    $0x0,%esi
  801a0e:	bf 01 00 00 00       	mov    $0x1,%edi
  801a13:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	callq  *%rax
  801a1f:	48 83 c4 10          	add    $0x10,%rsp
}
  801a23:	c9                   	leaveq 
  801a24:	c3                   	retq   

0000000000801a25 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a25:	55                   	push   %rbp
  801a26:	48 89 e5             	mov    %rsp,%rbp
  801a29:	48 83 ec 10          	sub    $0x10,%rsp
  801a2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 83 ec 08          	sub    $0x8,%rsp
  801a39:	6a 00                	pushq  $0x0
  801a3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a47:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4c:	48 89 c2             	mov    %rax,%rdx
  801a4f:	be 01 00 00 00       	mov    $0x1,%esi
  801a54:	bf 03 00 00 00       	mov    $0x3,%edi
  801a59:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801a60:	00 00 00 
  801a63:	ff d0                	callq  *%rax
  801a65:	48 83 c4 10          	add    $0x10,%rsp
}
  801a69:	c9                   	leaveq 
  801a6a:	c3                   	retq   

0000000000801a6b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a6b:	55                   	push   %rbp
  801a6c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a6f:	48 83 ec 08          	sub    $0x8,%rsp
  801a73:	6a 00                	pushq  $0x0
  801a75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a86:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8b:	be 00 00 00 00       	mov    $0x0,%esi
  801a90:	bf 02 00 00 00       	mov    $0x2,%edi
  801a95:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
  801aa1:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa5:	c9                   	leaveq 
  801aa6:	c3                   	retq   

0000000000801aa7 <sys_yield>:


void
sys_yield(void)
{
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801aab:	48 83 ec 08          	sub    $0x8,%rsp
  801aaf:	6a 00                	pushq  $0x0
  801ab1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac7:	be 00 00 00 00       	mov    $0x0,%esi
  801acc:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ad1:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801ad8:	00 00 00 
  801adb:	ff d0                	callq  *%rax
  801add:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leaveq 
  801ae3:	c3                   	retq   

0000000000801ae4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ae4:	55                   	push   %rbp
  801ae5:	48 89 e5             	mov    %rsp,%rbp
  801ae8:	48 83 ec 10          	sub    $0x10,%rsp
  801aec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801af6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801af9:	48 63 c8             	movslq %eax,%rcx
  801afc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b03:	48 98                	cltq   
  801b05:	48 83 ec 08          	sub    $0x8,%rsp
  801b09:	6a 00                	pushq  $0x0
  801b0b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b11:	49 89 c8             	mov    %rcx,%r8
  801b14:	48 89 d1             	mov    %rdx,%rcx
  801b17:	48 89 c2             	mov    %rax,%rdx
  801b1a:	be 01 00 00 00       	mov    $0x1,%esi
  801b1f:	bf 04 00 00 00       	mov    $0x4,%edi
  801b24:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801b2b:	00 00 00 
  801b2e:	ff d0                	callq  *%rax
  801b30:	48 83 c4 10          	add    $0x10,%rsp
}
  801b34:	c9                   	leaveq 
  801b35:	c3                   	retq   

0000000000801b36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b36:	55                   	push   %rbp
  801b37:	48 89 e5             	mov    %rsp,%rbp
  801b3a:	48 83 ec 20          	sub    $0x20,%rsp
  801b3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b45:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b48:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b4c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b50:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b53:	48 63 c8             	movslq %eax,%rcx
  801b56:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5d:	48 63 f0             	movslq %eax,%rsi
  801b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 83 ec 08          	sub    $0x8,%rsp
  801b6d:	51                   	push   %rcx
  801b6e:	49 89 f9             	mov    %rdi,%r9
  801b71:	49 89 f0             	mov    %rsi,%r8
  801b74:	48 89 d1             	mov    %rdx,%rcx
  801b77:	48 89 c2             	mov    %rax,%rdx
  801b7a:	be 01 00 00 00       	mov    $0x1,%esi
  801b7f:	bf 05 00 00 00       	mov    $0x5,%edi
  801b84:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801b8b:	00 00 00 
  801b8e:	ff d0                	callq  *%rax
  801b90:	48 83 c4 10          	add    $0x10,%rsp
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 10          	sub    $0x10,%rsp
  801b9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ba5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bac:	48 98                	cltq   
  801bae:	48 83 ec 08          	sub    $0x8,%rsp
  801bb2:	6a 00                	pushq  $0x0
  801bb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc0:	48 89 d1             	mov    %rdx,%rcx
  801bc3:	48 89 c2             	mov    %rax,%rdx
  801bc6:	be 01 00 00 00       	mov    $0x1,%esi
  801bcb:	bf 06 00 00 00       	mov    $0x6,%edi
  801bd0:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801bd7:	00 00 00 
  801bda:	ff d0                	callq  *%rax
  801bdc:	48 83 c4 10          	add    $0x10,%rsp
}
  801be0:	c9                   	leaveq 
  801be1:	c3                   	retq   

0000000000801be2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801be2:	55                   	push   %rbp
  801be3:	48 89 e5             	mov    %rsp,%rbp
  801be6:	48 83 ec 10          	sub    $0x10,%rsp
  801bea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bed:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf3:	48 63 d0             	movslq %eax,%rdx
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	48 98                	cltq   
  801bfb:	48 83 ec 08          	sub    $0x8,%rsp
  801bff:	6a 00                	pushq  $0x0
  801c01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0d:	48 89 d1             	mov    %rdx,%rcx
  801c10:	48 89 c2             	mov    %rax,%rdx
  801c13:	be 01 00 00 00       	mov    $0x1,%esi
  801c18:	bf 08 00 00 00       	mov    $0x8,%edi
  801c1d:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801c24:	00 00 00 
  801c27:	ff d0                	callq  *%rax
  801c29:	48 83 c4 10          	add    $0x10,%rsp
}
  801c2d:	c9                   	leaveq 
  801c2e:	c3                   	retq   

0000000000801c2f <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 10          	sub    $0x10,%rsp
  801c37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c45:	48 98                	cltq   
  801c47:	48 83 ec 08          	sub    $0x8,%rsp
  801c4b:	6a 00                	pushq  $0x0
  801c4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c59:	48 89 d1             	mov    %rdx,%rcx
  801c5c:	48 89 c2             	mov    %rax,%rdx
  801c5f:	be 01 00 00 00       	mov    $0x1,%esi
  801c64:	bf 09 00 00 00       	mov    $0x9,%edi
  801c69:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801c70:	00 00 00 
  801c73:	ff d0                	callq  *%rax
  801c75:	48 83 c4 10          	add    $0x10,%rsp
}
  801c79:	c9                   	leaveq 
  801c7a:	c3                   	retq   

0000000000801c7b <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c7b:	55                   	push   %rbp
  801c7c:	48 89 e5             	mov    %rsp,%rbp
  801c7f:	48 83 ec 10          	sub    $0x10,%rsp
  801c83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c91:	48 98                	cltq   
  801c93:	48 83 ec 08          	sub    $0x8,%rsp
  801c97:	6a 00                	pushq  $0x0
  801c99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca5:	48 89 d1             	mov    %rdx,%rcx
  801ca8:	48 89 c2             	mov    %rax,%rdx
  801cab:	be 01 00 00 00       	mov    $0x1,%esi
  801cb0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cb5:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	callq  *%rax
  801cc1:	48 83 c4 10          	add    $0x10,%rsp
}
  801cc5:	c9                   	leaveq 
  801cc6:	c3                   	retq   

0000000000801cc7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cc7:	55                   	push   %rbp
  801cc8:	48 89 e5             	mov    %rsp,%rbp
  801ccb:	48 83 ec 20          	sub    $0x20,%rsp
  801ccf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cda:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cdd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce0:	48 63 f0             	movslq %eax,%rsi
  801ce3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cea:	48 98                	cltq   
  801cec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf0:	48 83 ec 08          	sub    $0x8,%rsp
  801cf4:	6a 00                	pushq  $0x0
  801cf6:	49 89 f1             	mov    %rsi,%r9
  801cf9:	49 89 c8             	mov    %rcx,%r8
  801cfc:	48 89 d1             	mov    %rdx,%rcx
  801cff:	48 89 c2             	mov    %rax,%rdx
  801d02:	be 00 00 00 00       	mov    $0x0,%esi
  801d07:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d0c:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	callq  *%rax
  801d18:	48 83 c4 10          	add    $0x10,%rsp
}
  801d1c:	c9                   	leaveq 
  801d1d:	c3                   	retq   

0000000000801d1e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	48 83 ec 10          	sub    $0x10,%rsp
  801d26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2e:	48 83 ec 08          	sub    $0x8,%rsp
  801d32:	6a 00                	pushq  $0x0
  801d34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d40:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d45:	48 89 c2             	mov    %rax,%rdx
  801d48:	be 01 00 00 00       	mov    $0x1,%esi
  801d4d:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d52:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801d59:	00 00 00 
  801d5c:	ff d0                	callq  *%rax
  801d5e:	48 83 c4 10          	add    $0x10,%rsp
}
  801d62:	c9                   	leaveq 
  801d63:	c3                   	retq   

0000000000801d64 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d64:	55                   	push   %rbp
  801d65:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d68:	48 83 ec 08          	sub    $0x8,%rsp
  801d6c:	6a 00                	pushq  $0x0
  801d6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d84:	be 00 00 00 00       	mov    $0x0,%esi
  801d89:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d8e:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
  801d9a:	48 83 c4 10          	add    $0x10,%rsp
}
  801d9e:	c9                   	leaveq 
  801d9f:	c3                   	retq   

0000000000801da0 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801da0:	55                   	push   %rbp
  801da1:	48 89 e5             	mov    %rsp,%rbp
  801da4:	48 83 ec 10          	sub    $0x10,%rsp
  801da8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dac:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801daf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db6:	48 83 ec 08          	sub    $0x8,%rsp
  801dba:	6a 00                	pushq  $0x0
  801dbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc8:	48 89 d1             	mov    %rdx,%rcx
  801dcb:	48 89 c2             	mov    %rax,%rdx
  801dce:	be 00 00 00 00       	mov    $0x0,%esi
  801dd3:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dd8:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801ddf:	00 00 00 
  801de2:	ff d0                	callq  *%rax
  801de4:	48 83 c4 10          	add    $0x10,%rsp
}
  801de8:	c9                   	leaveq 
  801de9:	c3                   	retq   

0000000000801dea <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	48 83 ec 10          	sub    $0x10,%rsp
  801df2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801df6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801df9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e00:	48 83 ec 08          	sub    $0x8,%rsp
  801e04:	6a 00                	pushq  $0x0
  801e06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e12:	48 89 d1             	mov    %rdx,%rcx
  801e15:	48 89 c2             	mov    %rax,%rdx
  801e18:	be 00 00 00 00       	mov    $0x0,%esi
  801e1d:	bf 10 00 00 00       	mov    $0x10,%edi
  801e22:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	callq  *%rax
  801e2e:	48 83 c4 10          	add    $0x10,%rsp
}
  801e32:	c9                   	leaveq 
  801e33:	c3                   	retq   

0000000000801e34 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e34:	55                   	push   %rbp
  801e35:	48 89 e5             	mov    %rsp,%rbp
  801e38:	48 83 ec 20          	sub    $0x20,%rsp
  801e3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e43:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e46:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e4a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e4e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e51:	48 63 c8             	movslq %eax,%rcx
  801e54:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e5b:	48 63 f0             	movslq %eax,%rsi
  801e5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e65:	48 98                	cltq   
  801e67:	48 83 ec 08          	sub    $0x8,%rsp
  801e6b:	51                   	push   %rcx
  801e6c:	49 89 f9             	mov    %rdi,%r9
  801e6f:	49 89 f0             	mov    %rsi,%r8
  801e72:	48 89 d1             	mov    %rdx,%rcx
  801e75:	48 89 c2             	mov    %rax,%rdx
  801e78:	be 00 00 00 00       	mov    $0x0,%esi
  801e7d:	bf 11 00 00 00       	mov    $0x11,%edi
  801e82:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	callq  *%rax
  801e8e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e92:	c9                   	leaveq 
  801e93:	c3                   	retq   

0000000000801e94 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	48 83 ec 10          	sub    $0x10,%rsp
  801e9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ea0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ea4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eac:	48 83 ec 08          	sub    $0x8,%rsp
  801eb0:	6a 00                	pushq  $0x0
  801eb2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebe:	48 89 d1             	mov    %rdx,%rcx
  801ec1:	48 89 c2             	mov    %rax,%rdx
  801ec4:	be 00 00 00 00       	mov    $0x0,%esi
  801ec9:	bf 12 00 00 00       	mov    $0x12,%edi
  801ece:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801ed5:	00 00 00 
  801ed8:	ff d0                	callq  *%rax
  801eda:	48 83 c4 10          	add    $0x10,%rsp
}
  801ede:	c9                   	leaveq 
  801edf:	c3                   	retq   

0000000000801ee0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ee0:	55                   	push   %rbp
  801ee1:	48 89 e5             	mov    %rsp,%rbp
  801ee4:	48 83 ec 30          	sub    $0x30,%rsp
  801ee8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801eec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef0:	48 8b 00             	mov    (%rax),%rax
  801ef3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801ef7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efb:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eff:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f05:	83 e0 02             	and    $0x2,%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	75 40                	jne    801f4c <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801f0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f10:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801f17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f1b:	49 89 d0             	mov    %rdx,%r8
  801f1e:	48 89 c1             	mov    %rax,%rcx
  801f21:	48 ba b8 51 80 00 00 	movabs $0x8051b8,%rdx
  801f28:	00 00 00 
  801f2b:	be 1f 00 00 00       	mov    $0x1f,%esi
  801f30:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  801f37:	00 00 00 
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3f:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  801f46:	00 00 00 
  801f49:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801f4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f50:	48 c1 e8 0c          	shr    $0xc,%rax
  801f54:	48 89 c2             	mov    %rax,%rdx
  801f57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5e:	01 00 00 
  801f61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f65:	25 07 08 00 00       	and    $0x807,%eax
  801f6a:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801f70:	74 4e                	je     801fc0 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801f72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f76:	48 c1 e8 0c          	shr    $0xc,%rax
  801f7a:	48 89 c2             	mov    %rax,%rdx
  801f7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f84:	01 00 00 
  801f87:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f8f:	49 89 d0             	mov    %rdx,%r8
  801f92:	48 89 c1             	mov    %rax,%rcx
  801f95:	48 ba e0 51 80 00 00 	movabs $0x8051e0,%rdx
  801f9c:	00 00 00 
  801f9f:	be 22 00 00 00       	mov    $0x22,%esi
  801fa4:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  801fab:	00 00 00 
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  801fba:	00 00 00 
  801fbd:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fc0:	ba 07 00 00 00       	mov    $0x7,%edx
  801fc5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fca:	bf 00 00 00 00       	mov    $0x0,%edi
  801fcf:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  801fd6:	00 00 00 
  801fd9:	ff d0                	callq  *%rax
  801fdb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801fde:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801fe2:	79 30                	jns    802014 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801fe4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fe7:	89 c1                	mov    %eax,%ecx
  801fe9:	48 ba 0b 52 80 00 00 	movabs $0x80520b,%rdx
  801ff0:	00 00 00 
  801ff3:	be 28 00 00 00       	mov    $0x28,%esi
  801ff8:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  801fff:	00 00 00 
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
  802007:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80200e:	00 00 00 
  802011:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802014:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802018:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80201c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802020:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802026:	ba 00 10 00 00       	mov    $0x1000,%edx
  80202b:	48 89 c6             	mov    %rax,%rsi
  80202e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802033:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80203f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802043:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802051:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802057:	48 89 c1             	mov    %rax,%rcx
  80205a:	ba 00 00 00 00       	mov    $0x0,%edx
  80205f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802064:	bf 00 00 00 00       	mov    $0x0,%edi
  802069:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802070:	00 00 00 
  802073:	ff d0                	callq  *%rax
  802075:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802078:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80207c:	79 30                	jns    8020ae <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80207e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802081:	89 c1                	mov    %eax,%ecx
  802083:	48 ba 1e 52 80 00 00 	movabs $0x80521e,%rdx
  80208a:	00 00 00 
  80208d:	be 2d 00 00 00       	mov    $0x2d,%esi
  802092:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  802099:	00 00 00 
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a1:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8020a8:	00 00 00 
  8020ab:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8020ae:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b8:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8020bf:	00 00 00 
  8020c2:	ff d0                	callq  *%rax
  8020c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020cb:	79 30                	jns    8020fd <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8020cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020d0:	89 c1                	mov    %eax,%ecx
  8020d2:	48 ba 2f 52 80 00 00 	movabs $0x80522f,%rdx
  8020d9:	00 00 00 
  8020dc:	be 31 00 00 00       	mov    $0x31,%esi
  8020e1:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  8020e8:	00 00 00 
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8020f7:	00 00 00 
  8020fa:	41 ff d0             	callq  *%r8

}
  8020fd:	90                   	nop
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 30          	sub    $0x30,%rsp
  802108:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80210b:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80210e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802111:	c1 e0 0c             	shl    $0xc,%eax
  802114:	89 c0                	mov    %eax,%eax
  802116:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  80211a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802121:	01 00 00 
  802124:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802127:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80212f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802133:	25 02 08 00 00       	and    $0x802,%eax
  802138:	48 85 c0             	test   %rax,%rax
  80213b:	74 0e                	je     80214b <duppage+0x4b>
  80213d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802141:	25 00 04 00 00       	and    $0x400,%eax
  802146:	48 85 c0             	test   %rax,%rax
  802149:	74 70                	je     8021bb <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80214b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214f:	25 07 0e 00 00       	and    $0xe07,%eax
  802154:	89 c6                	mov    %eax,%esi
  802156:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80215a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80215d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802161:	41 89 f0             	mov    %esi,%r8d
  802164:	48 89 c6             	mov    %rax,%rsi
  802167:	bf 00 00 00 00       	mov    $0x0,%edi
  80216c:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802173:	00 00 00 
  802176:	ff d0                	callq  *%rax
  802178:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80217b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80217f:	79 30                	jns    8021b1 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802181:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802184:	89 c1                	mov    %eax,%ecx
  802186:	48 ba 1e 52 80 00 00 	movabs $0x80521e,%rdx
  80218d:	00 00 00 
  802190:	be 50 00 00 00       	mov    $0x50,%esi
  802195:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  80219c:	00 00 00 
  80219f:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a4:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8021ab:	00 00 00 
  8021ae:	41 ff d0             	callq  *%r8
		return 0;
  8021b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b6:	e9 c4 00 00 00       	jmpq   80227f <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8021bb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8021bf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c6:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8021cc:	48 89 c6             	mov    %rax,%rsi
  8021cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d4:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
  8021e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8021e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021e7:	79 30                	jns    802219 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8021e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021ec:	89 c1                	mov    %eax,%ecx
  8021ee:	48 ba 1e 52 80 00 00 	movabs $0x80521e,%rdx
  8021f5:	00 00 00 
  8021f8:	be 64 00 00 00       	mov    $0x64,%esi
  8021fd:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  802204:	00 00 00 
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
  80220c:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  802213:	00 00 00 
  802216:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802219:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80221d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802221:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802227:	48 89 d1             	mov    %rdx,%rcx
  80222a:	ba 00 00 00 00       	mov    $0x0,%edx
  80222f:	48 89 c6             	mov    %rax,%rsi
  802232:	bf 00 00 00 00       	mov    $0x0,%edi
  802237:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80223e:	00 00 00 
  802241:	ff d0                	callq  *%rax
  802243:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802246:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80224a:	79 30                	jns    80227c <duppage+0x17c>
		panic("sys_page_map: %e", r);
  80224c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	48 ba 1e 52 80 00 00 	movabs $0x80521e,%rdx
  802258:	00 00 00 
  80225b:	be 66 00 00 00       	mov    $0x66,%esi
  802260:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  802267:	00 00 00 
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  802276:	00 00 00 
  802279:	41 ff d0             	callq  *%r8
	return r;
  80227c:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80227f:	c9                   	leaveq 
  802280:	c3                   	retq   

0000000000802281 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802281:	55                   	push   %rbp
  802282:	48 89 e5             	mov    %rsp,%rbp
  802285:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802289:	48 bf e0 1e 80 00 00 	movabs $0x801ee0,%rdi
  802290:	00 00 00 
  802293:	48 b8 3c 46 80 00 00 	movabs $0x80463c,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80229f:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a4:	cd 30                	int    $0x30
  8022a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022a9:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8022ac:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8022af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022b3:	79 08                	jns    8022bd <fork+0x3c>
		return envid;
  8022b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022b8:	e9 0b 02 00 00       	jmpq   8024c8 <fork+0x247>
	if (envid == 0) {
  8022bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022c1:	75 3e                	jne    802301 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8022c3:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	callq  *%rax
  8022cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022d4:	48 98                	cltq   
  8022d6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8022dd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022e4:	00 00 00 
  8022e7:	48 01 c2             	add    %rax,%rdx
  8022ea:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8022f1:	00 00 00 
  8022f4:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	e9 c7 01 00 00       	jmpq   8024c8 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802308:	e9 a6 00 00 00       	jmpq   8023b3 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  80230d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802310:	c1 f8 12             	sar    $0x12,%eax
  802313:	89 c2                	mov    %eax,%edx
  802315:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80231c:	01 00 00 
  80231f:	48 63 d2             	movslq %edx,%rdx
  802322:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802326:	83 e0 01             	and    $0x1,%eax
  802329:	48 85 c0             	test   %rax,%rax
  80232c:	74 21                	je     80234f <fork+0xce>
  80232e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802331:	c1 f8 09             	sar    $0x9,%eax
  802334:	89 c2                	mov    %eax,%edx
  802336:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80233d:	01 00 00 
  802340:	48 63 d2             	movslq %edx,%rdx
  802343:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802347:	83 e0 01             	and    $0x1,%eax
  80234a:	48 85 c0             	test   %rax,%rax
  80234d:	75 09                	jne    802358 <fork+0xd7>
			pn += NPTENTRIES;
  80234f:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802356:	eb 5b                	jmp    8023b3 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235b:	05 00 02 00 00       	add    $0x200,%eax
  802360:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802363:	eb 46                	jmp    8023ab <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802365:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80236c:	01 00 00 
  80236f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802372:	48 63 d2             	movslq %edx,%rdx
  802375:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802379:	83 e0 05             	and    $0x5,%eax
  80237c:	48 83 f8 05          	cmp    $0x5,%rax
  802380:	75 21                	jne    8023a3 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  802382:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802389:	74 1b                	je     8023a6 <fork+0x125>
				continue;
			duppage(envid, pn);
  80238b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80238e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802391:	89 d6                	mov    %edx,%esi
  802393:	89 c7                	mov    %eax,%edi
  802395:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
  8023a1:	eb 04                	jmp    8023a7 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  8023a3:	90                   	nop
  8023a4:	eb 01                	jmp    8023a7 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  8023a6:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8023a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8023b1:	7c b2                	jl     802365 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8023b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b6:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8023bb:	0f 86 4c ff ff ff    	jbe    80230d <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8023c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023c4:	ba 07 00 00 00       	mov    $0x7,%edx
  8023c9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023ce:	89 c7                	mov    %eax,%edi
  8023d0:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  8023d7:	00 00 00 
  8023da:	ff d0                	callq  *%rax
  8023dc:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023df:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023e3:	79 30                	jns    802415 <fork+0x194>
		panic("allocating exception stack: %e", r);
  8023e5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023e8:	89 c1                	mov    %eax,%ecx
  8023ea:	48 ba 48 52 80 00 00 	movabs $0x805248,%rdx
  8023f1:	00 00 00 
  8023f4:	be 9e 00 00 00       	mov    $0x9e,%esi
  8023f9:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  802400:	00 00 00 
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80240f:	00 00 00 
  802412:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802415:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80241c:	00 00 00 
  80241f:	48 8b 00             	mov    (%rax),%rax
  802422:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802429:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242c:	48 89 d6             	mov    %rdx,%rsi
  80242f:	89 c7                	mov    %eax,%edi
  802431:	48 b8 7b 1c 80 00 00 	movabs $0x801c7b,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
  80243d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802440:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802444:	79 30                	jns    802476 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802446:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802449:	89 c1                	mov    %eax,%ecx
  80244b:	48 ba 68 52 80 00 00 	movabs $0x805268,%rdx
  802452:	00 00 00 
  802455:	be a2 00 00 00       	mov    $0xa2,%esi
  80245a:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  802461:	00 00 00 
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
  802469:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  802470:	00 00 00 
  802473:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802476:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802479:	be 02 00 00 00       	mov    $0x2,%esi
  80247e:	89 c7                	mov    %eax,%edi
  802480:	48 b8 e2 1b 80 00 00 	movabs $0x801be2,%rax
  802487:	00 00 00 
  80248a:	ff d0                	callq  *%rax
  80248c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80248f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802493:	79 30                	jns    8024c5 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802495:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802498:	89 c1                	mov    %eax,%ecx
  80249a:	48 ba 87 52 80 00 00 	movabs $0x805287,%rdx
  8024a1:	00 00 00 
  8024a4:	be a7 00 00 00       	mov    $0xa7,%esi
  8024a9:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  8024b0:	00 00 00 
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b8:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8024bf:	00 00 00 
  8024c2:	41 ff d0             	callq  *%r8

	return envid;
  8024c5:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8024c8:	c9                   	leaveq 
  8024c9:	c3                   	retq   

00000000008024ca <sfork>:

// Challenge!
int
sfork(void)
{
  8024ca:	55                   	push   %rbp
  8024cb:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8024ce:	48 ba 9e 52 80 00 00 	movabs $0x80529e,%rdx
  8024d5:	00 00 00 
  8024d8:	be b1 00 00 00       	mov    $0xb1,%esi
  8024dd:	48 bf d1 51 80 00 00 	movabs $0x8051d1,%rdi
  8024e4:	00 00 00 
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ec:	48 b9 e4 03 80 00 00 	movabs $0x8003e4,%rcx
  8024f3:	00 00 00 
  8024f6:	ff d1                	callq  *%rcx

00000000008024f8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024f8:	55                   	push   %rbp
  8024f9:	48 89 e5             	mov    %rsp,%rbp
  8024fc:	48 83 ec 08          	sub    $0x8,%rsp
  802500:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802504:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802508:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80250f:	ff ff ff 
  802512:	48 01 d0             	add    %rdx,%rax
  802515:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802519:	c9                   	leaveq 
  80251a:	c3                   	retq   

000000000080251b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80251b:	55                   	push   %rbp
  80251c:	48 89 e5             	mov    %rsp,%rbp
  80251f:	48 83 ec 08          	sub    $0x8,%rsp
  802523:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80252b:	48 89 c7             	mov    %rax,%rdi
  80252e:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  802535:	00 00 00 
  802538:	ff d0                	callq  *%rax
  80253a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802540:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802544:	c9                   	leaveq 
  802545:	c3                   	retq   

0000000000802546 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802546:	55                   	push   %rbp
  802547:	48 89 e5             	mov    %rsp,%rbp
  80254a:	48 83 ec 18          	sub    $0x18,%rsp
  80254e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802552:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802559:	eb 6b                	jmp    8025c6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80255b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255e:	48 98                	cltq   
  802560:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802566:	48 c1 e0 0c          	shl    $0xc,%rax
  80256a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80256e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802572:	48 c1 e8 15          	shr    $0x15,%rax
  802576:	48 89 c2             	mov    %rax,%rdx
  802579:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802580:	01 00 00 
  802583:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802587:	83 e0 01             	and    $0x1,%eax
  80258a:	48 85 c0             	test   %rax,%rax
  80258d:	74 21                	je     8025b0 <fd_alloc+0x6a>
  80258f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802593:	48 c1 e8 0c          	shr    $0xc,%rax
  802597:	48 89 c2             	mov    %rax,%rdx
  80259a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025a1:	01 00 00 
  8025a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a8:	83 e0 01             	and    $0x1,%eax
  8025ab:	48 85 c0             	test   %rax,%rax
  8025ae:	75 12                	jne    8025c2 <fd_alloc+0x7c>
			*fd_store = fd;
  8025b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025b8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c0:	eb 1a                	jmp    8025dc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025c6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025ca:	7e 8f                	jle    80255b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025d7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025dc:	c9                   	leaveq 
  8025dd:	c3                   	retq   

00000000008025de <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 20          	sub    $0x20,%rsp
  8025e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025f1:	78 06                	js     8025f9 <fd_lookup+0x1b>
  8025f3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025f7:	7e 07                	jle    802600 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025fe:	eb 6c                	jmp    80266c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802600:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802603:	48 98                	cltq   
  802605:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80260b:	48 c1 e0 0c          	shl    $0xc,%rax
  80260f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802617:	48 c1 e8 15          	shr    $0x15,%rax
  80261b:	48 89 c2             	mov    %rax,%rdx
  80261e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802625:	01 00 00 
  802628:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80262c:	83 e0 01             	and    $0x1,%eax
  80262f:	48 85 c0             	test   %rax,%rax
  802632:	74 21                	je     802655 <fd_lookup+0x77>
  802634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802638:	48 c1 e8 0c          	shr    $0xc,%rax
  80263c:	48 89 c2             	mov    %rax,%rdx
  80263f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802646:	01 00 00 
  802649:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264d:	83 e0 01             	and    $0x1,%eax
  802650:	48 85 c0             	test   %rax,%rax
  802653:	75 07                	jne    80265c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802655:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80265a:	eb 10                	jmp    80266c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80265c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802660:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802664:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266c:	c9                   	leaveq 
  80266d:	c3                   	retq   

000000000080266e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80266e:	55                   	push   %rbp
  80266f:	48 89 e5             	mov    %rsp,%rbp
  802672:	48 83 ec 30          	sub    $0x30,%rsp
  802676:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80267a:	89 f0                	mov    %esi,%eax
  80267c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80267f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802683:	48 89 c7             	mov    %rax,%rdi
  802686:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
  802692:	89 c2                	mov    %eax,%edx
  802694:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802698:	48 89 c6             	mov    %rax,%rsi
  80269b:	89 d7                	mov    %edx,%edi
  80269d:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
  8026a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b0:	78 0a                	js     8026bc <fd_close+0x4e>
	    || fd != fd2)
  8026b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026ba:	74 12                	je     8026ce <fd_close+0x60>
		return (must_exist ? r : 0);
  8026bc:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026c0:	74 05                	je     8026c7 <fd_close+0x59>
  8026c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c5:	eb 70                	jmp    802737 <fd_close+0xc9>
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	eb 69                	jmp    802737 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d2:	8b 00                	mov    (%rax),%eax
  8026d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	78 2a                	js     80271c <fd_close+0xae>
		if (dev->dev_close)
  8026f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026fa:	48 85 c0             	test   %rax,%rax
  8026fd:	74 16                	je     802715 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8026ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802703:	48 8b 40 20          	mov    0x20(%rax),%rax
  802707:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80270b:	48 89 d7             	mov    %rdx,%rdi
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802713:	eb 07                	jmp    80271c <fd_close+0xae>
		else
			r = 0;
  802715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80271c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802720:	48 89 c6             	mov    %rax,%rsi
  802723:	bf 00 00 00 00       	mov    $0x0,%edi
  802728:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
	return r;
  802734:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802737:	c9                   	leaveq 
  802738:	c3                   	retq   

0000000000802739 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802739:	55                   	push   %rbp
  80273a:	48 89 e5             	mov    %rsp,%rbp
  80273d:	48 83 ec 20          	sub    $0x20,%rsp
  802741:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802744:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802748:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80274f:	eb 41                	jmp    802792 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802751:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802758:	00 00 00 
  80275b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80275e:	48 63 d2             	movslq %edx,%rdx
  802761:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802765:	8b 00                	mov    (%rax),%eax
  802767:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80276a:	75 22                	jne    80278e <dev_lookup+0x55>
			*dev = devtab[i];
  80276c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802773:	00 00 00 
  802776:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802779:	48 63 d2             	movslq %edx,%rdx
  80277c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802784:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	eb 60                	jmp    8027ee <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80278e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802792:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802799:	00 00 00 
  80279c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80279f:	48 63 d2             	movslq %edx,%rdx
  8027a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a6:	48 85 c0             	test   %rax,%rax
  8027a9:	75 a6                	jne    802751 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027ab:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8027b2:	00 00 00 
  8027b5:	48 8b 00             	mov    (%rax),%rax
  8027b8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027c1:	89 c6                	mov    %eax,%esi
  8027c3:	48 bf b8 52 80 00 00 	movabs $0x8052b8,%rdi
  8027ca:	00 00 00 
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  8027d9:	00 00 00 
  8027dc:	ff d1                	callq  *%rcx
	*dev = 0;
  8027de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027ee:	c9                   	leaveq 
  8027ef:	c3                   	retq   

00000000008027f0 <close>:

int
close(int fdnum)
{
  8027f0:	55                   	push   %rbp
  8027f1:	48 89 e5             	mov    %rsp,%rbp
  8027f4:	48 83 ec 20          	sub    $0x20,%rsp
  8027f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802802:	48 89 d6             	mov    %rdx,%rsi
  802805:	89 c7                	mov    %eax,%edi
  802807:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
  802813:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802816:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281a:	79 05                	jns    802821 <close+0x31>
		return r;
  80281c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281f:	eb 18                	jmp    802839 <close+0x49>
	else
		return fd_close(fd, 1);
  802821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802825:	be 01 00 00 00       	mov    $0x1,%esi
  80282a:	48 89 c7             	mov    %rax,%rdi
  80282d:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <close_all>:

void
close_all(void)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802843:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80284a:	eb 15                	jmp    802861 <close_all+0x26>
		close(i);
  80284c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284f:	89 c7                	mov    %eax,%edi
  802851:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80285d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802861:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802865:	7e e5                	jle    80284c <close_all+0x11>
		close(i);
}
  802867:	90                   	nop
  802868:	c9                   	leaveq 
  802869:	c3                   	retq   

000000000080286a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80286a:	55                   	push   %rbp
  80286b:	48 89 e5             	mov    %rsp,%rbp
  80286e:	48 83 ec 40          	sub    $0x40,%rsp
  802872:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802875:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802878:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80287c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80287f:	48 89 d6             	mov    %rdx,%rsi
  802882:	89 c7                	mov    %eax,%edi
  802884:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80288b:	00 00 00 
  80288e:	ff d0                	callq  *%rax
  802890:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802893:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802897:	79 08                	jns    8028a1 <dup+0x37>
		return r;
  802899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289c:	e9 70 01 00 00       	jmpq   802a11 <dup+0x1a7>
	close(newfdnum);
  8028a1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028a4:	89 c7                	mov    %eax,%edi
  8028a6:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028b2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028b5:	48 98                	cltq   
  8028b7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028bd:	48 c1 e0 0c          	shl    $0xc,%rax
  8028c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c9:	48 89 c7             	mov    %rax,%rdi
  8028cc:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  8028d3:	00 00 00 
  8028d6:	ff d0                	callq  *%rax
  8028d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e0:	48 89 c7             	mov    %rax,%rdi
  8028e3:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
  8028ef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f7:	48 c1 e8 15          	shr    $0x15,%rax
  8028fb:	48 89 c2             	mov    %rax,%rdx
  8028fe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802905:	01 00 00 
  802908:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290c:	83 e0 01             	and    $0x1,%eax
  80290f:	48 85 c0             	test   %rax,%rax
  802912:	74 71                	je     802985 <dup+0x11b>
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	48 c1 e8 0c          	shr    $0xc,%rax
  80291c:	48 89 c2             	mov    %rax,%rdx
  80291f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802926:	01 00 00 
  802929:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292d:	83 e0 01             	and    $0x1,%eax
  802930:	48 85 c0             	test   %rax,%rax
  802933:	74 50                	je     802985 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802939:	48 c1 e8 0c          	shr    $0xc,%rax
  80293d:	48 89 c2             	mov    %rax,%rdx
  802940:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802947:	01 00 00 
  80294a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294e:	25 07 0e 00 00       	and    $0xe07,%eax
  802953:	89 c1                	mov    %eax,%ecx
  802955:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295d:	41 89 c8             	mov    %ecx,%r8d
  802960:	48 89 d1             	mov    %rdx,%rcx
  802963:	ba 00 00 00 00       	mov    $0x0,%edx
  802968:	48 89 c6             	mov    %rax,%rsi
  80296b:	bf 00 00 00 00       	mov    $0x0,%edi
  802970:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802983:	78 55                	js     8029da <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802989:	48 c1 e8 0c          	shr    $0xc,%rax
  80298d:	48 89 c2             	mov    %rax,%rdx
  802990:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802997:	01 00 00 
  80299a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80299e:	25 07 0e 00 00       	and    $0xe07,%eax
  8029a3:	89 c1                	mov    %eax,%ecx
  8029a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029ad:	41 89 c8             	mov    %ecx,%r8d
  8029b0:	48 89 d1             	mov    %rdx,%rcx
  8029b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b8:	48 89 c6             	mov    %rax,%rsi
  8029bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c0:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8029c7:	00 00 00 
  8029ca:	ff d0                	callq  *%rax
  8029cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d3:	78 08                	js     8029dd <dup+0x173>
		goto err;

	return newfdnum;
  8029d5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029d8:	eb 37                	jmp    802a11 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8029da:	90                   	nop
  8029db:	eb 01                	jmp    8029de <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8029dd:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	48 89 c6             	mov    %rax,%rsi
  8029e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ea:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fa:	48 89 c6             	mov    %rax,%rsi
  8029fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802a02:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
	return r;
  802a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a11:	c9                   	leaveq 
  802a12:	c3                   	retq   

0000000000802a13 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a13:	55                   	push   %rbp
  802a14:	48 89 e5             	mov    %rsp,%rbp
  802a17:	48 83 ec 40          	sub    $0x40,%rsp
  802a1b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a1e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a22:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a26:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a2a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a2d:	48 89 d6             	mov    %rdx,%rsi
  802a30:	89 c7                	mov    %eax,%edi
  802a32:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax
  802a3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a45:	78 24                	js     802a6b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4b:	8b 00                	mov    (%rax),%eax
  802a4d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a51:	48 89 d6             	mov    %rdx,%rsi
  802a54:	89 c7                	mov    %eax,%edi
  802a56:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802a5d:	00 00 00 
  802a60:	ff d0                	callq  *%rax
  802a62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a69:	79 05                	jns    802a70 <read+0x5d>
		return r;
  802a6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6e:	eb 76                	jmp    802ae6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a74:	8b 40 08             	mov    0x8(%rax),%eax
  802a77:	83 e0 03             	and    $0x3,%eax
  802a7a:	83 f8 01             	cmp    $0x1,%eax
  802a7d:	75 3a                	jne    802ab9 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a7f:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802a86:	00 00 00 
  802a89:	48 8b 00             	mov    (%rax),%rax
  802a8c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a92:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a95:	89 c6                	mov    %eax,%esi
  802a97:	48 bf d7 52 80 00 00 	movabs $0x8052d7,%rdi
  802a9e:	00 00 00 
  802aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa6:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  802aad:	00 00 00 
  802ab0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ab2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ab7:	eb 2d                	jmp    802ae6 <read+0xd3>
	}
	if (!dev->dev_read)
  802ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abd:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ac1:	48 85 c0             	test   %rax,%rax
  802ac4:	75 07                	jne    802acd <read+0xba>
		return -E_NOT_SUPP;
  802ac6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802acb:	eb 19                	jmp    802ae6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802acd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad1:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ad5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ad9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802add:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ae1:	48 89 cf             	mov    %rcx,%rdi
  802ae4:	ff d0                	callq  *%rax
}
  802ae6:	c9                   	leaveq 
  802ae7:	c3                   	retq   

0000000000802ae8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ae8:	55                   	push   %rbp
  802ae9:	48 89 e5             	mov    %rsp,%rbp
  802aec:	48 83 ec 30          	sub    $0x30,%rsp
  802af0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802af3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802af7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802afb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b02:	eb 47                	jmp    802b4b <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	48 98                	cltq   
  802b09:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b0d:	48 29 c2             	sub    %rax,%rdx
  802b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b13:	48 63 c8             	movslq %eax,%rcx
  802b16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b1a:	48 01 c1             	add    %rax,%rcx
  802b1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b20:	48 89 ce             	mov    %rcx,%rsi
  802b23:	89 c7                	mov    %eax,%edi
  802b25:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
  802b31:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b34:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b38:	79 05                	jns    802b3f <readn+0x57>
			return m;
  802b3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b3d:	eb 1d                	jmp    802b5c <readn+0x74>
		if (m == 0)
  802b3f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b43:	74 13                	je     802b58 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b48:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4e:	48 98                	cltq   
  802b50:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b54:	72 ae                	jb     802b04 <readn+0x1c>
  802b56:	eb 01                	jmp    802b59 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802b58:	90                   	nop
	}
	return tot;
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b5c:	c9                   	leaveq 
  802b5d:	c3                   	retq   

0000000000802b5e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b5e:	55                   	push   %rbp
  802b5f:	48 89 e5             	mov    %rsp,%rbp
  802b62:	48 83 ec 40          	sub    $0x40,%rsp
  802b66:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b69:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b6d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b71:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b75:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b78:	48 89 d6             	mov    %rdx,%rsi
  802b7b:	89 c7                	mov    %eax,%edi
  802b7d:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
  802b89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b90:	78 24                	js     802bb6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b96:	8b 00                	mov    (%rax),%eax
  802b98:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b9c:	48 89 d6             	mov    %rdx,%rsi
  802b9f:	89 c7                	mov    %eax,%edi
  802ba1:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
  802bad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb4:	79 05                	jns    802bbb <write+0x5d>
		return r;
  802bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb9:	eb 75                	jmp    802c30 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbf:	8b 40 08             	mov    0x8(%rax),%eax
  802bc2:	83 e0 03             	and    $0x3,%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	75 3a                	jne    802c03 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bc9:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802bd0:	00 00 00 
  802bd3:	48 8b 00             	mov    (%rax),%rax
  802bd6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bdc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bdf:	89 c6                	mov    %eax,%esi
  802be1:	48 bf f3 52 80 00 00 	movabs $0x8052f3,%rdi
  802be8:	00 00 00 
  802beb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf0:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  802bf7:	00 00 00 
  802bfa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bfc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c01:	eb 2d                	jmp    802c30 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c07:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c0b:	48 85 c0             	test   %rax,%rax
  802c0e:	75 07                	jne    802c17 <write+0xb9>
		return -E_NOT_SUPP;
  802c10:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c15:	eb 19                	jmp    802c30 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c1f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c23:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c27:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c2b:	48 89 cf             	mov    %rcx,%rdi
  802c2e:	ff d0                	callq  *%rax
}
  802c30:	c9                   	leaveq 
  802c31:	c3                   	retq   

0000000000802c32 <seek>:

int
seek(int fdnum, off_t offset)
{
  802c32:	55                   	push   %rbp
  802c33:	48 89 e5             	mov    %rsp,%rbp
  802c36:	48 83 ec 18          	sub    $0x18,%rsp
  802c3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c3d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c47:	48 89 d6             	mov    %rdx,%rsi
  802c4a:	89 c7                	mov    %eax,%edi
  802c4c:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5f:	79 05                	jns    802c66 <seek+0x34>
		return r;
  802c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c64:	eb 0f                	jmp    802c75 <seek+0x43>
	fd->fd_offset = offset;
  802c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c6d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c75:	c9                   	leaveq 
  802c76:	c3                   	retq   

0000000000802c77 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c77:	55                   	push   %rbp
  802c78:	48 89 e5             	mov    %rsp,%rbp
  802c7b:	48 83 ec 30          	sub    $0x30,%rsp
  802c7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c82:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c85:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c8c:	48 89 d6             	mov    %rdx,%rsi
  802c8f:	89 c7                	mov    %eax,%edi
  802c91:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	78 24                	js     802cca <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caa:	8b 00                	mov    (%rax),%eax
  802cac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cb0:	48 89 d6             	mov    %rdx,%rsi
  802cb3:	89 c7                	mov    %eax,%edi
  802cb5:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802cbc:	00 00 00 
  802cbf:	ff d0                	callq  *%rax
  802cc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc8:	79 05                	jns    802ccf <ftruncate+0x58>
		return r;
  802cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccd:	eb 72                	jmp    802d41 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd3:	8b 40 08             	mov    0x8(%rax),%eax
  802cd6:	83 e0 03             	and    $0x3,%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	75 3a                	jne    802d17 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cdd:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802ce4:	00 00 00 
  802ce7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cf0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cf3:	89 c6                	mov    %eax,%esi
  802cf5:	48 bf 10 53 80 00 00 	movabs $0x805310,%rdi
  802cfc:	00 00 00 
  802cff:	b8 00 00 00 00       	mov    $0x0,%eax
  802d04:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  802d0b:	00 00 00 
  802d0e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d15:	eb 2a                	jmp    802d41 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d1f:	48 85 c0             	test   %rax,%rax
  802d22:	75 07                	jne    802d2b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d24:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d29:	eb 16                	jmp    802d41 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d37:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d3a:	89 ce                	mov    %ecx,%esi
  802d3c:	48 89 d7             	mov    %rdx,%rdi
  802d3f:	ff d0                	callq  *%rax
}
  802d41:	c9                   	leaveq 
  802d42:	c3                   	retq   

0000000000802d43 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d43:	55                   	push   %rbp
  802d44:	48 89 e5             	mov    %rsp,%rbp
  802d47:	48 83 ec 30          	sub    $0x30,%rsp
  802d4b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d4e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d52:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d56:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d59:	48 89 d6             	mov    %rdx,%rsi
  802d5c:	89 c7                	mov    %eax,%edi
  802d5e:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802d65:	00 00 00 
  802d68:	ff d0                	callq  *%rax
  802d6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d71:	78 24                	js     802d97 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d77:	8b 00                	mov    (%rax),%eax
  802d79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d7d:	48 89 d6             	mov    %rdx,%rsi
  802d80:	89 c7                	mov    %eax,%edi
  802d82:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802d89:	00 00 00 
  802d8c:	ff d0                	callq  *%rax
  802d8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d95:	79 05                	jns    802d9c <fstat+0x59>
		return r;
  802d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9a:	eb 5e                	jmp    802dfa <fstat+0xb7>
	if (!dev->dev_stat)
  802d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da0:	48 8b 40 28          	mov    0x28(%rax),%rax
  802da4:	48 85 c0             	test   %rax,%rax
  802da7:	75 07                	jne    802db0 <fstat+0x6d>
		return -E_NOT_SUPP;
  802da9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dae:	eb 4a                	jmp    802dfa <fstat+0xb7>
	stat->st_name[0] = 0;
  802db0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802db7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802dc2:	00 00 00 
	stat->st_isdir = 0;
  802dc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802dd0:	00 00 00 
	stat->st_dev = dev;
  802dd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ddb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dee:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802df2:	48 89 ce             	mov    %rcx,%rsi
  802df5:	48 89 d7             	mov    %rdx,%rdi
  802df8:	ff d0                	callq  *%rax
}
  802dfa:	c9                   	leaveq 
  802dfb:	c3                   	retq   

0000000000802dfc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 83 ec 20          	sub    $0x20,%rsp
  802e04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e10:	be 00 00 00 00       	mov    $0x0,%esi
  802e15:	48 89 c7             	mov    %rax,%rdi
  802e18:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
  802e24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2b:	79 05                	jns    802e32 <stat+0x36>
		return fd;
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	eb 2f                	jmp    802e61 <stat+0x65>
	r = fstat(fd, stat);
  802e32:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e39:	48 89 d6             	mov    %rdx,%rsi
  802e3c:	89 c7                	mov    %eax,%edi
  802e3e:	48 b8 43 2d 80 00 00 	movabs $0x802d43,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax
  802e4a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e50:	89 c7                	mov    %eax,%edi
  802e52:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
	return r;
  802e5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e61:	c9                   	leaveq 
  802e62:	c3                   	retq   

0000000000802e63 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e63:	55                   	push   %rbp
  802e64:	48 89 e5             	mov    %rsp,%rbp
  802e67:	48 83 ec 10          	sub    $0x10,%rsp
  802e6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e79:	00 00 00 
  802e7c:	8b 00                	mov    (%rax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	75 1f                	jne    802ea1 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e82:	bf 01 00 00 00       	mov    $0x1,%edi
  802e87:	48 b8 32 4a 80 00 00 	movabs $0x804a32,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
  802e93:	89 c2                	mov    %eax,%edx
  802e95:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e9c:	00 00 00 
  802e9f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ea1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ea8:	00 00 00 
  802eab:	8b 00                	mov    (%rax),%eax
  802ead:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802eb0:	b9 07 00 00 00       	mov    $0x7,%ecx
  802eb5:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ebc:	00 00 00 
  802ebf:	89 c7                	mov    %eax,%edi
  802ec1:	48 b8 26 48 80 00 00 	movabs $0x804826,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed6:	48 89 c6             	mov    %rax,%rsi
  802ed9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ede:	48 b8 65 47 80 00 00 	movabs $0x804765,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
}
  802eea:	c9                   	leaveq 
  802eeb:	c3                   	retq   

0000000000802eec <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802eec:	55                   	push   %rbp
  802eed:	48 89 e5             	mov    %rsp,%rbp
  802ef0:	48 83 ec 20          	sub    $0x20,%rsp
  802ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ef8:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eff:	48 89 c7             	mov    %rax,%rdi
  802f02:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
  802f0e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f13:	7e 0a                	jle    802f1f <open+0x33>
		return -E_BAD_PATH;
  802f15:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f1a:	e9 a5 00 00 00       	jmpq   802fc4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802f1f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f23:	48 89 c7             	mov    %rax,%rdi
  802f26:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f39:	79 08                	jns    802f43 <open+0x57>
		return r;
  802f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3e:	e9 81 00 00 00       	jmpq   802fc4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	48 89 c6             	mov    %rax,%rsi
  802f4a:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f51:	00 00 00 
  802f54:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  802f5b:	00 00 00 
  802f5e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802f60:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f67:	00 00 00 
  802f6a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f6d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f77:	48 89 c6             	mov    %rax,%rsi
  802f7a:	bf 01 00 00 00       	mov    $0x1,%edi
  802f7f:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  802f86:	00 00 00 
  802f89:	ff d0                	callq  *%rax
  802f8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f92:	79 1d                	jns    802fb1 <open+0xc5>
		fd_close(fd, 0);
  802f94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f98:	be 00 00 00 00       	mov    $0x0,%esi
  802f9d:	48 89 c7             	mov    %rax,%rdi
  802fa0:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
		return r;
  802fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faf:	eb 13                	jmp    802fc4 <open+0xd8>
	}

	return fd2num(fd);
  802fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb5:	48 89 c7             	mov    %rax,%rdi
  802fb8:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax

}
  802fc4:	c9                   	leaveq 
  802fc5:	c3                   	retq   

0000000000802fc6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fc6:	55                   	push   %rbp
  802fc7:	48 89 e5             	mov    %rsp,%rbp
  802fca:	48 83 ec 10          	sub    $0x10,%rsp
  802fce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd6:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fe0:	00 00 00 
  802fe3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fe5:	be 00 00 00 00       	mov    $0x0,%esi
  802fea:	bf 06 00 00 00       	mov    $0x6,%edi
  802fef:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
}
  802ffb:	c9                   	leaveq 
  802ffc:	c3                   	retq   

0000000000802ffd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ffd:	55                   	push   %rbp
  802ffe:	48 89 e5             	mov    %rsp,%rbp
  803001:	48 83 ec 30          	sub    $0x30,%rsp
  803005:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803009:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80300d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803015:	8b 50 0c             	mov    0xc(%rax),%edx
  803018:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80301f:	00 00 00 
  803022:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803024:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80302b:	00 00 00 
  80302e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803032:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803036:	be 00 00 00 00       	mov    $0x0,%esi
  80303b:	bf 03 00 00 00       	mov    $0x3,%edi
  803040:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
  80304c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803053:	79 08                	jns    80305d <devfile_read+0x60>
		return r;
  803055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803058:	e9 a4 00 00 00       	jmpq   803101 <devfile_read+0x104>
	assert(r <= n);
  80305d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803060:	48 98                	cltq   
  803062:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803066:	76 35                	jbe    80309d <devfile_read+0xa0>
  803068:	48 b9 36 53 80 00 00 	movabs $0x805336,%rcx
  80306f:	00 00 00 
  803072:	48 ba 3d 53 80 00 00 	movabs $0x80533d,%rdx
  803079:	00 00 00 
  80307c:	be 86 00 00 00       	mov    $0x86,%esi
  803081:	48 bf 52 53 80 00 00 	movabs $0x805352,%rdi
  803088:	00 00 00 
  80308b:	b8 00 00 00 00       	mov    $0x0,%eax
  803090:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  803097:	00 00 00 
  80309a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80309d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8030a4:	7e 35                	jle    8030db <devfile_read+0xde>
  8030a6:	48 b9 5d 53 80 00 00 	movabs $0x80535d,%rcx
  8030ad:	00 00 00 
  8030b0:	48 ba 3d 53 80 00 00 	movabs $0x80533d,%rdx
  8030b7:	00 00 00 
  8030ba:	be 87 00 00 00       	mov    $0x87,%esi
  8030bf:	48 bf 52 53 80 00 00 	movabs $0x805352,%rdi
  8030c6:	00 00 00 
  8030c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ce:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8030d5:	00 00 00 
  8030d8:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8030db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030de:	48 63 d0             	movslq %eax,%rdx
  8030e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e5:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030ec:	00 00 00 
  8030ef:	48 89 c7             	mov    %rax,%rdi
  8030f2:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
	return r;
  8030fe:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803101:	c9                   	leaveq 
  803102:	c3                   	retq   

0000000000803103 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803103:	55                   	push   %rbp
  803104:	48 89 e5             	mov    %rsp,%rbp
  803107:	48 83 ec 40          	sub    $0x40,%rsp
  80310b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80310f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803113:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803117:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80311b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80311f:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803126:	00 
  803127:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80312b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80312f:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803134:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803138:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80313c:	8b 50 0c             	mov    0xc(%rax),%edx
  80313f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803146:	00 00 00 
  803149:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80314b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803152:	00 00 00 
  803155:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803159:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80315d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803161:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803165:	48 89 c6             	mov    %rax,%rsi
  803168:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80316f:	00 00 00 
  803172:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803179:	00 00 00 
  80317c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80317e:	be 00 00 00 00       	mov    $0x0,%esi
  803183:	bf 04 00 00 00       	mov    $0x4,%edi
  803188:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  80318f:	00 00 00 
  803192:	ff d0                	callq  *%rax
  803194:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803197:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80319b:	79 05                	jns    8031a2 <devfile_write+0x9f>
		return r;
  80319d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031a0:	eb 43                	jmp    8031e5 <devfile_write+0xe2>
	assert(r <= n);
  8031a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031a5:	48 98                	cltq   
  8031a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8031ab:	76 35                	jbe    8031e2 <devfile_write+0xdf>
  8031ad:	48 b9 36 53 80 00 00 	movabs $0x805336,%rcx
  8031b4:	00 00 00 
  8031b7:	48 ba 3d 53 80 00 00 	movabs $0x80533d,%rdx
  8031be:	00 00 00 
  8031c1:	be a2 00 00 00       	mov    $0xa2,%esi
  8031c6:	48 bf 52 53 80 00 00 	movabs $0x805352,%rdi
  8031cd:	00 00 00 
  8031d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d5:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8031dc:	00 00 00 
  8031df:	41 ff d0             	callq  *%r8
	return r;
  8031e2:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8031e5:	c9                   	leaveq 
  8031e6:	c3                   	retq   

00000000008031e7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031e7:	55                   	push   %rbp
  8031e8:	48 89 e5             	mov    %rsp,%rbp
  8031eb:	48 83 ec 20          	sub    $0x20,%rsp
  8031ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fb:	8b 50 0c             	mov    0xc(%rax),%edx
  8031fe:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803205:	00 00 00 
  803208:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80320a:	be 00 00 00 00       	mov    $0x0,%esi
  80320f:	bf 05 00 00 00       	mov    $0x5,%edi
  803214:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  80321b:	00 00 00 
  80321e:	ff d0                	callq  *%rax
  803220:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803223:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803227:	79 05                	jns    80322e <devfile_stat+0x47>
		return r;
  803229:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322c:	eb 56                	jmp    803284 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80322e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803232:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803239:	00 00 00 
  80323c:	48 89 c7             	mov    %rax,%rdi
  80323f:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80324b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803252:	00 00 00 
  803255:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80325b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803265:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80326c:	00 00 00 
  80326f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803275:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803279:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80327f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803284:	c9                   	leaveq 
  803285:	c3                   	retq   

0000000000803286 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803286:	55                   	push   %rbp
  803287:	48 89 e5             	mov    %rsp,%rbp
  80328a:	48 83 ec 10          	sub    $0x10,%rsp
  80328e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803292:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803299:	8b 50 0c             	mov    0xc(%rax),%edx
  80329c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a3:	00 00 00 
  8032a6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8032a8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032af:	00 00 00 
  8032b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8032b8:	be 00 00 00 00       	mov    $0x0,%esi
  8032bd:	bf 02 00 00 00       	mov    $0x2,%edi
  8032c2:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
}
  8032ce:	c9                   	leaveq 
  8032cf:	c3                   	retq   

00000000008032d0 <remove>:

// Delete a file
int
remove(const char *path)
{
  8032d0:	55                   	push   %rbp
  8032d1:	48 89 e5             	mov    %rsp,%rbp
  8032d4:	48 83 ec 10          	sub    $0x10,%rsp
  8032d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8032dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032e0:	48 89 c7             	mov    %rax,%rdi
  8032e3:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
  8032ef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032f4:	7e 07                	jle    8032fd <remove+0x2d>
		return -E_BAD_PATH;
  8032f6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032fb:	eb 33                	jmp    803330 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803301:	48 89 c6             	mov    %rax,%rsi
  803304:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80330b:	00 00 00 
  80330e:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80331a:	be 00 00 00 00       	mov    $0x0,%esi
  80331f:	bf 07 00 00 00       	mov    $0x7,%edi
  803324:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
}
  803330:	c9                   	leaveq 
  803331:	c3                   	retq   

0000000000803332 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803332:	55                   	push   %rbp
  803333:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803336:	be 00 00 00 00       	mov    $0x0,%esi
  80333b:	bf 08 00 00 00       	mov    $0x8,%edi
  803340:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax
}
  80334c:	5d                   	pop    %rbp
  80334d:	c3                   	retq   

000000000080334e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80334e:	55                   	push   %rbp
  80334f:	48 89 e5             	mov    %rsp,%rbp
  803352:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803359:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803360:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803367:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80336e:	be 00 00 00 00       	mov    $0x0,%esi
  803373:	48 89 c7             	mov    %rax,%rdi
  803376:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
  803382:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803385:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803389:	79 28                	jns    8033b3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80338b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338e:	89 c6                	mov    %eax,%esi
  803390:	48 bf 69 53 80 00 00 	movabs $0x805369,%rdi
  803397:	00 00 00 
  80339a:	b8 00 00 00 00       	mov    $0x0,%eax
  80339f:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8033a6:	00 00 00 
  8033a9:	ff d2                	callq  *%rdx
		return fd_src;
  8033ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ae:	e9 76 01 00 00       	jmpq   803529 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8033b3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8033ba:	be 01 01 00 00       	mov    $0x101,%esi
  8033bf:	48 89 c7             	mov    %rax,%rdi
  8033c2:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
  8033ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8033d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033d5:	0f 89 ad 00 00 00    	jns    803488 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8033db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033de:	89 c6                	mov    %eax,%esi
  8033e0:	48 bf 7f 53 80 00 00 	movabs $0x80537f,%rdi
  8033e7:	00 00 00 
  8033ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ef:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8033f6:	00 00 00 
  8033f9:	ff d2                	callq  *%rdx
		close(fd_src);
  8033fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fe:	89 c7                	mov    %eax,%edi
  803400:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
		return fd_dest;
  80340c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80340f:	e9 15 01 00 00       	jmpq   803529 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803417:	48 63 d0             	movslq %eax,%rdx
  80341a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803421:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803424:	48 89 ce             	mov    %rcx,%rsi
  803427:	89 c7                	mov    %eax,%edi
  803429:	48 b8 5e 2b 80 00 00 	movabs $0x802b5e,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803438:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80343c:	79 4a                	jns    803488 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  80343e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803441:	89 c6                	mov    %eax,%esi
  803443:	48 bf 99 53 80 00 00 	movabs $0x805399,%rdi
  80344a:	00 00 00 
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  803459:	00 00 00 
  80345c:	ff d2                	callq  *%rdx
			close(fd_src);
  80345e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803461:	89 c7                	mov    %eax,%edi
  803463:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
			close(fd_dest);
  80346f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803472:	89 c7                	mov    %eax,%edi
  803474:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	callq  *%rax
			return write_size;
  803480:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803483:	e9 a1 00 00 00       	jmpq   803529 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803488:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80348f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803492:	ba 00 02 00 00       	mov    $0x200,%edx
  803497:	48 89 ce             	mov    %rcx,%rsi
  80349a:	89 c7                	mov    %eax,%edi
  80349c:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8034ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034af:	0f 8f 5f ff ff ff    	jg     803414 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8034b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034b9:	79 47                	jns    803502 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8034bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034be:	89 c6                	mov    %eax,%esi
  8034c0:	48 bf ac 53 80 00 00 	movabs $0x8053ac,%rdi
  8034c7:	00 00 00 
  8034ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cf:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8034d6:	00 00 00 
  8034d9:	ff d2                	callq  *%rdx
		close(fd_src);
  8034db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034de:	89 c7                	mov    %eax,%edi
  8034e0:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  8034e7:	00 00 00 
  8034ea:	ff d0                	callq  *%rax
		close(fd_dest);
  8034ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ef:	89 c7                	mov    %eax,%edi
  8034f1:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
		return read_size;
  8034fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803500:	eb 27                	jmp    803529 <copy+0x1db>
	}
	close(fd_src);
  803502:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803505:	89 c7                	mov    %eax,%edi
  803507:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
	close(fd_dest);
  803513:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803516:	89 c7                	mov    %eax,%edi
  803518:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
	return 0;
  803524:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803529:	c9                   	leaveq 
  80352a:	c3                   	retq   

000000000080352b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80352b:	55                   	push   %rbp
  80352c:	48 89 e5             	mov    %rsp,%rbp
  80352f:	48 83 ec 20          	sub    $0x20,%rsp
  803533:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803536:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80353a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80353d:	48 89 d6             	mov    %rdx,%rsi
  803540:	89 c7                	mov    %eax,%edi
  803542:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  803549:	00 00 00 
  80354c:	ff d0                	callq  *%rax
  80354e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803551:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803555:	79 05                	jns    80355c <fd2sockid+0x31>
		return r;
  803557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355a:	eb 24                	jmp    803580 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80355c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803560:	8b 10                	mov    (%rax),%edx
  803562:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803569:	00 00 00 
  80356c:	8b 00                	mov    (%rax),%eax
  80356e:	39 c2                	cmp    %eax,%edx
  803570:	74 07                	je     803579 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803572:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803577:	eb 07                	jmp    803580 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803580:	c9                   	leaveq 
  803581:	c3                   	retq   

0000000000803582 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803582:	55                   	push   %rbp
  803583:	48 89 e5             	mov    %rsp,%rbp
  803586:	48 83 ec 20          	sub    $0x20,%rsp
  80358a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80358d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803591:	48 89 c7             	mov    %rax,%rdi
  803594:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80359b:	00 00 00 
  80359e:	ff d0                	callq  *%rax
  8035a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a7:	78 26                	js     8035cf <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8035a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ad:	ba 07 04 00 00       	mov    $0x407,%edx
  8035b2:	48 89 c6             	mov    %rax,%rsi
  8035b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ba:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
  8035c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cd:	79 16                	jns    8035e5 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d2:	89 c7                	mov    %eax,%edi
  8035d4:	48 b8 91 3a 80 00 00 	movabs $0x803a91,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
		return r;
  8035e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e3:	eb 3a                	jmp    80361f <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e9:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8035f0:	00 00 00 
  8035f3:	8b 12                	mov    (%rdx),%edx
  8035f5:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8035f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803606:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803609:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80360c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803610:	48 89 c7             	mov    %rax,%rdi
  803613:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  80361a:	00 00 00 
  80361d:	ff d0                	callq  *%rax
}
  80361f:	c9                   	leaveq 
  803620:	c3                   	retq   

0000000000803621 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803621:	55                   	push   %rbp
  803622:	48 89 e5             	mov    %rsp,%rbp
  803625:	48 83 ec 30          	sub    $0x30,%rsp
  803629:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80362c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803630:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803634:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803637:	89 c7                	mov    %eax,%edi
  803639:	48 b8 2b 35 80 00 00 	movabs $0x80352b,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
  803645:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803648:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364c:	79 05                	jns    803653 <accept+0x32>
		return r;
  80364e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803651:	eb 3b                	jmp    80368e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803653:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803657:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80365b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365e:	48 89 ce             	mov    %rcx,%rsi
  803661:	89 c7                	mov    %eax,%edi
  803663:	48 b8 6e 39 80 00 00 	movabs $0x80396e,%rax
  80366a:	00 00 00 
  80366d:	ff d0                	callq  *%rax
  80366f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803676:	79 05                	jns    80367d <accept+0x5c>
		return r;
  803678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367b:	eb 11                	jmp    80368e <accept+0x6d>
	return alloc_sockfd(r);
  80367d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803680:	89 c7                	mov    %eax,%edi
  803682:	48 b8 82 35 80 00 00 	movabs $0x803582,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
}
  80368e:	c9                   	leaveq 
  80368f:	c3                   	retq   

0000000000803690 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803690:	55                   	push   %rbp
  803691:	48 89 e5             	mov    %rsp,%rbp
  803694:	48 83 ec 20          	sub    $0x20,%rsp
  803698:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80369b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80369f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a5:	89 c7                	mov    %eax,%edi
  8036a7:	48 b8 2b 35 80 00 00 	movabs $0x80352b,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ba:	79 05                	jns    8036c1 <bind+0x31>
		return r;
  8036bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bf:	eb 1b                	jmp    8036dc <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cb:	48 89 ce             	mov    %rcx,%rsi
  8036ce:	89 c7                	mov    %eax,%edi
  8036d0:	48 b8 ed 39 80 00 00 	movabs $0x8039ed,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
}
  8036dc:	c9                   	leaveq 
  8036dd:	c3                   	retq   

00000000008036de <shutdown>:

int
shutdown(int s, int how)
{
  8036de:	55                   	push   %rbp
  8036df:	48 89 e5             	mov    %rsp,%rbp
  8036e2:	48 83 ec 20          	sub    $0x20,%rsp
  8036e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ef:	89 c7                	mov    %eax,%edi
  8036f1:	48 b8 2b 35 80 00 00 	movabs $0x80352b,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803700:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803704:	79 05                	jns    80370b <shutdown+0x2d>
		return r;
  803706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803709:	eb 16                	jmp    803721 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80370b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80370e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803711:	89 d6                	mov    %edx,%esi
  803713:	89 c7                	mov    %eax,%edi
  803715:	48 b8 51 3a 80 00 00 	movabs $0x803a51,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
}
  803721:	c9                   	leaveq 
  803722:	c3                   	retq   

0000000000803723 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803723:	55                   	push   %rbp
  803724:	48 89 e5             	mov    %rsp,%rbp
  803727:	48 83 ec 10          	sub    $0x10,%rsp
  80372b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80372f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803733:	48 89 c7             	mov    %rax,%rdi
  803736:	48 b8 a3 4a 80 00 00 	movabs $0x804aa3,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
  803742:	83 f8 01             	cmp    $0x1,%eax
  803745:	75 17                	jne    80375e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803747:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374b:	8b 40 0c             	mov    0xc(%rax),%eax
  80374e:	89 c7                	mov    %eax,%edi
  803750:	48 b8 91 3a 80 00 00 	movabs $0x803a91,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
  80375c:	eb 05                	jmp    803763 <devsock_close+0x40>
	else
		return 0;
  80375e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803763:	c9                   	leaveq 
  803764:	c3                   	retq   

0000000000803765 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803765:	55                   	push   %rbp
  803766:	48 89 e5             	mov    %rsp,%rbp
  803769:	48 83 ec 20          	sub    $0x20,%rsp
  80376d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803770:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803774:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803777:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377a:	89 c7                	mov    %eax,%edi
  80377c:	48 b8 2b 35 80 00 00 	movabs $0x80352b,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
  803788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378f:	79 05                	jns    803796 <connect+0x31>
		return r;
  803791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803794:	eb 1b                	jmp    8037b1 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803796:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803799:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80379d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a0:	48 89 ce             	mov    %rcx,%rsi
  8037a3:	89 c7                	mov    %eax,%edi
  8037a5:	48 b8 be 3a 80 00 00 	movabs $0x803abe,%rax
  8037ac:	00 00 00 
  8037af:	ff d0                	callq  *%rax
}
  8037b1:	c9                   	leaveq 
  8037b2:	c3                   	retq   

00000000008037b3 <listen>:

int
listen(int s, int backlog)
{
  8037b3:	55                   	push   %rbp
  8037b4:	48 89 e5             	mov    %rsp,%rbp
  8037b7:	48 83 ec 20          	sub    $0x20,%rsp
  8037bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037be:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c4:	89 c7                	mov    %eax,%edi
  8037c6:	48 b8 2b 35 80 00 00 	movabs $0x80352b,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
  8037d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d9:	79 05                	jns    8037e0 <listen+0x2d>
		return r;
  8037db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037de:	eb 16                	jmp    8037f6 <listen+0x43>
	return nsipc_listen(r, backlog);
  8037e0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e6:	89 d6                	mov    %edx,%esi
  8037e8:	89 c7                	mov    %eax,%edi
  8037ea:	48 b8 22 3b 80 00 00 	movabs $0x803b22,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
}
  8037f6:	c9                   	leaveq 
  8037f7:	c3                   	retq   

00000000008037f8 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037f8:	55                   	push   %rbp
  8037f9:	48 89 e5             	mov    %rsp,%rbp
  8037fc:	48 83 ec 20          	sub    $0x20,%rsp
  803800:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803804:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803808:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80380c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803810:	89 c2                	mov    %eax,%edx
  803812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803816:	8b 40 0c             	mov    0xc(%rax),%eax
  803819:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80381d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803822:	89 c7                	mov    %eax,%edi
  803824:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
}
  803830:	c9                   	leaveq 
  803831:	c3                   	retq   

0000000000803832 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803832:	55                   	push   %rbp
  803833:	48 89 e5             	mov    %rsp,%rbp
  803836:	48 83 ec 20          	sub    $0x20,%rsp
  80383a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80383e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803842:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80384a:	89 c2                	mov    %eax,%edx
  80384c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803850:	8b 40 0c             	mov    0xc(%rax),%eax
  803853:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803857:	b9 00 00 00 00       	mov    $0x0,%ecx
  80385c:	89 c7                	mov    %eax,%edi
  80385e:	48 b8 2e 3c 80 00 00 	movabs $0x803c2e,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
}
  80386a:	c9                   	leaveq 
  80386b:	c3                   	retq   

000000000080386c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80386c:	55                   	push   %rbp
  80386d:	48 89 e5             	mov    %rsp,%rbp
  803870:	48 83 ec 10          	sub    $0x10,%rsp
  803874:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803878:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80387c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803880:	48 be c7 53 80 00 00 	movabs $0x8053c7,%rsi
  803887:	00 00 00 
  80388a:	48 89 c7             	mov    %rax,%rdi
  80388d:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803894:	00 00 00 
  803897:	ff d0                	callq  *%rax
	return 0;
  803899:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80389e:	c9                   	leaveq 
  80389f:	c3                   	retq   

00000000008038a0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8038a0:	55                   	push   %rbp
  8038a1:	48 89 e5             	mov    %rsp,%rbp
  8038a4:	48 83 ec 20          	sub    $0x20,%rsp
  8038a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038ab:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038ae:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038b1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038b4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ba:	89 ce                	mov    %ecx,%esi
  8038bc:	89 c7                	mov    %eax,%edi
  8038be:	48 b8 e6 3c 80 00 00 	movabs $0x803ce6,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
  8038ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d1:	79 05                	jns    8038d8 <socket+0x38>
		return r;
  8038d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d6:	eb 11                	jmp    8038e9 <socket+0x49>
	return alloc_sockfd(r);
  8038d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038db:	89 c7                	mov    %eax,%edi
  8038dd:	48 b8 82 35 80 00 00 	movabs $0x803582,%rax
  8038e4:	00 00 00 
  8038e7:	ff d0                	callq  *%rax
}
  8038e9:	c9                   	leaveq 
  8038ea:	c3                   	retq   

00000000008038eb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038eb:	55                   	push   %rbp
  8038ec:	48 89 e5             	mov    %rsp,%rbp
  8038ef:	48 83 ec 10          	sub    $0x10,%rsp
  8038f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038f6:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038fd:	00 00 00 
  803900:	8b 00                	mov    (%rax),%eax
  803902:	85 c0                	test   %eax,%eax
  803904:	75 1f                	jne    803925 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803906:	bf 02 00 00 00       	mov    $0x2,%edi
  80390b:	48 b8 32 4a 80 00 00 	movabs $0x804a32,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
  803917:	89 c2                	mov    %eax,%edx
  803919:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803920:	00 00 00 
  803923:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803925:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80392c:	00 00 00 
  80392f:	8b 00                	mov    (%rax),%eax
  803931:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803934:	b9 07 00 00 00       	mov    $0x7,%ecx
  803939:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803940:	00 00 00 
  803943:	89 c7                	mov    %eax,%edi
  803945:	48 b8 26 48 80 00 00 	movabs $0x804826,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803951:	ba 00 00 00 00       	mov    $0x0,%edx
  803956:	be 00 00 00 00       	mov    $0x0,%esi
  80395b:	bf 00 00 00 00       	mov    $0x0,%edi
  803960:	48 b8 65 47 80 00 00 	movabs $0x804765,%rax
  803967:	00 00 00 
  80396a:	ff d0                	callq  *%rax
}
  80396c:	c9                   	leaveq 
  80396d:	c3                   	retq   

000000000080396e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80396e:	55                   	push   %rbp
  80396f:	48 89 e5             	mov    %rsp,%rbp
  803972:	48 83 ec 30          	sub    $0x30,%rsp
  803976:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803979:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80397d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803981:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803988:	00 00 00 
  80398b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80398e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803990:	bf 01 00 00 00       	mov    $0x1,%edi
  803995:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  80399c:	00 00 00 
  80399f:	ff d0                	callq  *%rax
  8039a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a8:	78 3e                	js     8039e8 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8039aa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039b1:	00 00 00 
  8039b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bc:	8b 40 10             	mov    0x10(%rax),%eax
  8039bf:	89 c2                	mov    %eax,%edx
  8039c1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c9:	48 89 ce             	mov    %rcx,%rsi
  8039cc:	48 89 c7             	mov    %rax,%rdi
  8039cf:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039df:	8b 50 10             	mov    0x10(%rax),%edx
  8039e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e6:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039eb:	c9                   	leaveq 
  8039ec:	c3                   	retq   

00000000008039ed <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039ed:	55                   	push   %rbp
  8039ee:	48 89 e5             	mov    %rsp,%rbp
  8039f1:	48 83 ec 10          	sub    $0x10,%rsp
  8039f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039fc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8039ff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a06:	00 00 00 
  803a09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a0c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a0e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a15:	48 89 c6             	mov    %rax,%rsi
  803a18:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a1f:	00 00 00 
  803a22:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a2e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a35:	00 00 00 
  803a38:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a3b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a3e:	bf 02 00 00 00       	mov    $0x2,%edi
  803a43:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803a4a:	00 00 00 
  803a4d:	ff d0                	callq  *%rax
}
  803a4f:	c9                   	leaveq 
  803a50:	c3                   	retq   

0000000000803a51 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a51:	55                   	push   %rbp
  803a52:	48 89 e5             	mov    %rsp,%rbp
  803a55:	48 83 ec 10          	sub    $0x10,%rsp
  803a59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a5c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a5f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a66:	00 00 00 
  803a69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a6c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a75:	00 00 00 
  803a78:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a7e:	bf 03 00 00 00       	mov    $0x3,%edi
  803a83:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
}
  803a8f:	c9                   	leaveq 
  803a90:	c3                   	retq   

0000000000803a91 <nsipc_close>:

int
nsipc_close(int s)
{
  803a91:	55                   	push   %rbp
  803a92:	48 89 e5             	mov    %rsp,%rbp
  803a95:	48 83 ec 10          	sub    $0x10,%rsp
  803a99:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a9c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa3:	00 00 00 
  803aa6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aa9:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803aab:	bf 04 00 00 00       	mov    $0x4,%edi
  803ab0:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803ab7:	00 00 00 
  803aba:	ff d0                	callq  *%rax
}
  803abc:	c9                   	leaveq 
  803abd:	c3                   	retq   

0000000000803abe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803abe:	55                   	push   %rbp
  803abf:	48 89 e5             	mov    %rsp,%rbp
  803ac2:	48 83 ec 10          	sub    $0x10,%rsp
  803ac6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ac9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803acd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ad0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad7:	00 00 00 
  803ada:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803add:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803adf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae6:	48 89 c6             	mov    %rax,%rsi
  803ae9:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803af0:	00 00 00 
  803af3:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803aff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b06:	00 00 00 
  803b09:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b0c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b0f:	bf 05 00 00 00       	mov    $0x5,%edi
  803b14:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803b1b:	00 00 00 
  803b1e:	ff d0                	callq  *%rax
}
  803b20:	c9                   	leaveq 
  803b21:	c3                   	retq   

0000000000803b22 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b22:	55                   	push   %rbp
  803b23:	48 89 e5             	mov    %rsp,%rbp
  803b26:	48 83 ec 10          	sub    $0x10,%rsp
  803b2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b2d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b30:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b37:	00 00 00 
  803b3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b3d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b3f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b46:	00 00 00 
  803b49:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b4c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b4f:	bf 06 00 00 00       	mov    $0x6,%edi
  803b54:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803b5b:	00 00 00 
  803b5e:	ff d0                	callq  *%rax
}
  803b60:	c9                   	leaveq 
  803b61:	c3                   	retq   

0000000000803b62 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b62:	55                   	push   %rbp
  803b63:	48 89 e5             	mov    %rsp,%rbp
  803b66:	48 83 ec 30          	sub    $0x30,%rsp
  803b6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b71:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b74:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b7e:	00 00 00 
  803b81:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b84:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b8d:	00 00 00 
  803b90:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b93:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b96:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b9d:	00 00 00 
  803ba0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ba3:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ba6:	bf 07 00 00 00       	mov    $0x7,%edi
  803bab:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803bb2:	00 00 00 
  803bb5:	ff d0                	callq  *%rax
  803bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bbe:	78 69                	js     803c29 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803bc0:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803bc7:	7f 08                	jg     803bd1 <nsipc_recv+0x6f>
  803bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcc:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bcf:	7e 35                	jle    803c06 <nsipc_recv+0xa4>
  803bd1:	48 b9 ce 53 80 00 00 	movabs $0x8053ce,%rcx
  803bd8:	00 00 00 
  803bdb:	48 ba e3 53 80 00 00 	movabs $0x8053e3,%rdx
  803be2:	00 00 00 
  803be5:	be 62 00 00 00       	mov    $0x62,%esi
  803bea:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  803bf1:	00 00 00 
  803bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf9:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  803c00:	00 00 00 
  803c03:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c09:	48 63 d0             	movslq %eax,%rdx
  803c0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c10:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803c17:	00 00 00 
  803c1a:	48 89 c7             	mov    %rax,%rdi
  803c1d:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803c24:	00 00 00 
  803c27:	ff d0                	callq  *%rax
	}

	return r;
  803c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c2c:	c9                   	leaveq 
  803c2d:	c3                   	retq   

0000000000803c2e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c2e:	55                   	push   %rbp
  803c2f:	48 89 e5             	mov    %rsp,%rbp
  803c32:	48 83 ec 20          	sub    $0x20,%rsp
  803c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c3d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c40:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c43:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4a:	00 00 00 
  803c4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c50:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c52:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c59:	7e 35                	jle    803c90 <nsipc_send+0x62>
  803c5b:	48 b9 04 54 80 00 00 	movabs $0x805404,%rcx
  803c62:	00 00 00 
  803c65:	48 ba e3 53 80 00 00 	movabs $0x8053e3,%rdx
  803c6c:	00 00 00 
  803c6f:	be 6d 00 00 00       	mov    $0x6d,%esi
  803c74:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  803c7b:	00 00 00 
  803c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c83:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  803c8a:	00 00 00 
  803c8d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c93:	48 63 d0             	movslq %eax,%rdx
  803c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9a:	48 89 c6             	mov    %rax,%rsi
  803c9d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803ca4:	00 00 00 
  803ca7:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803cae:	00 00 00 
  803cb1:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803cb3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cba:	00 00 00 
  803cbd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cc0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cc3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cca:	00 00 00 
  803ccd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cd0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803cd3:	bf 08 00 00 00       	mov    $0x8,%edi
  803cd8:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803cdf:	00 00 00 
  803ce2:	ff d0                	callq  *%rax
}
  803ce4:	c9                   	leaveq 
  803ce5:	c3                   	retq   

0000000000803ce6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ce6:	55                   	push   %rbp
  803ce7:	48 89 e5             	mov    %rsp,%rbp
  803cea:	48 83 ec 10          	sub    $0x10,%rsp
  803cee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803cf4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803cf7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cfe:	00 00 00 
  803d01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d04:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d0d:	00 00 00 
  803d10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d13:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d16:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1d:	00 00 00 
  803d20:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d23:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d26:	bf 09 00 00 00       	mov    $0x9,%edi
  803d2b:	48 b8 eb 38 80 00 00 	movabs $0x8038eb,%rax
  803d32:	00 00 00 
  803d35:	ff d0                	callq  *%rax
}
  803d37:	c9                   	leaveq 
  803d38:	c3                   	retq   

0000000000803d39 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d39:	55                   	push   %rbp
  803d3a:	48 89 e5             	mov    %rsp,%rbp
  803d3d:	53                   	push   %rbx
  803d3e:	48 83 ec 38          	sub    $0x38,%rsp
  803d42:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d46:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d4a:	48 89 c7             	mov    %rax,%rdi
  803d4d:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803d54:	00 00 00 
  803d57:	ff d0                	callq  *%rax
  803d59:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d60:	0f 88 bf 01 00 00    	js     803f25 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d6a:	ba 07 04 00 00       	mov    $0x407,%edx
  803d6f:	48 89 c6             	mov    %rax,%rsi
  803d72:	bf 00 00 00 00       	mov    $0x0,%edi
  803d77:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  803d7e:	00 00 00 
  803d81:	ff d0                	callq  *%rax
  803d83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d8a:	0f 88 95 01 00 00    	js     803f25 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d90:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d94:	48 89 c7             	mov    %rax,%rdi
  803d97:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803d9e:	00 00 00 
  803da1:	ff d0                	callq  *%rax
  803da3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803da6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803daa:	0f 88 5d 01 00 00    	js     803f0d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803db0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db4:	ba 07 04 00 00       	mov    $0x407,%edx
  803db9:	48 89 c6             	mov    %rax,%rsi
  803dbc:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc1:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  803dc8:	00 00 00 
  803dcb:	ff d0                	callq  *%rax
  803dcd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd4:	0f 88 33 01 00 00    	js     803f0d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803dda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dde:	48 89 c7             	mov    %rax,%rdi
  803de1:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  803de8:	00 00 00 
  803deb:	ff d0                	callq  *%rax
  803ded:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803df1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df5:	ba 07 04 00 00       	mov    $0x407,%edx
  803dfa:	48 89 c6             	mov    %rax,%rsi
  803dfd:	bf 00 00 00 00       	mov    $0x0,%edi
  803e02:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  803e09:	00 00 00 
  803e0c:	ff d0                	callq  *%rax
  803e0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e11:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e15:	0f 88 d9 00 00 00    	js     803ef4 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1f:	48 89 c7             	mov    %rax,%rdi
  803e22:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  803e29:	00 00 00 
  803e2c:	ff d0                	callq  *%rax
  803e2e:	48 89 c2             	mov    %rax,%rdx
  803e31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e35:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e3b:	48 89 d1             	mov    %rdx,%rcx
  803e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  803e43:	48 89 c6             	mov    %rax,%rsi
  803e46:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4b:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  803e52:	00 00 00 
  803e55:	ff d0                	callq  *%rax
  803e57:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e5e:	78 79                	js     803ed9 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e64:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e6b:	00 00 00 
  803e6e:	8b 12                	mov    (%rdx),%edx
  803e70:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e81:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e88:	00 00 00 
  803e8b:	8b 12                	mov    (%rdx),%edx
  803e8d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e93:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9e:	48 89 c7             	mov    %rax,%rdi
  803ea1:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
  803ead:	89 c2                	mov    %eax,%edx
  803eaf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803eb3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803eb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803eb9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ebd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec1:	48 89 c7             	mov    %rax,%rdi
  803ec4:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  803ecb:	00 00 00 
  803ece:	ff d0                	callq  *%rax
  803ed0:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed7:	eb 4f                	jmp    803f28 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ed9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ede:	48 89 c6             	mov    %rax,%rsi
  803ee1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee6:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  803eed:	00 00 00 
  803ef0:	ff d0                	callq  *%rax
  803ef2:	eb 01                	jmp    803ef5 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803ef4:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ef5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ef9:	48 89 c6             	mov    %rax,%rsi
  803efc:	bf 00 00 00 00       	mov    $0x0,%edi
  803f01:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  803f08:	00 00 00 
  803f0b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f11:	48 89 c6             	mov    %rax,%rsi
  803f14:	bf 00 00 00 00       	mov    $0x0,%edi
  803f19:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  803f20:	00 00 00 
  803f23:	ff d0                	callq  *%rax
err:
	return r;
  803f25:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f28:	48 83 c4 38          	add    $0x38,%rsp
  803f2c:	5b                   	pop    %rbx
  803f2d:	5d                   	pop    %rbp
  803f2e:	c3                   	retq   

0000000000803f2f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f2f:	55                   	push   %rbp
  803f30:	48 89 e5             	mov    %rsp,%rbp
  803f33:	53                   	push   %rbx
  803f34:	48 83 ec 28          	sub    $0x28,%rsp
  803f38:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f3c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f40:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  803f47:	00 00 00 
  803f4a:	48 8b 00             	mov    (%rax),%rax
  803f4d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f53:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5a:	48 89 c7             	mov    %rax,%rdi
  803f5d:	48 b8 a3 4a 80 00 00 	movabs $0x804aa3,%rax
  803f64:	00 00 00 
  803f67:	ff d0                	callq  *%rax
  803f69:	89 c3                	mov    %eax,%ebx
  803f6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6f:	48 89 c7             	mov    %rax,%rdi
  803f72:	48 b8 a3 4a 80 00 00 	movabs $0x804aa3,%rax
  803f79:	00 00 00 
  803f7c:	ff d0                	callq  *%rax
  803f7e:	39 c3                	cmp    %eax,%ebx
  803f80:	0f 94 c0             	sete   %al
  803f83:	0f b6 c0             	movzbl %al,%eax
  803f86:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f89:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  803f90:	00 00 00 
  803f93:	48 8b 00             	mov    (%rax),%rax
  803f96:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f9c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fa5:	75 05                	jne    803fac <_pipeisclosed+0x7d>
			return ret;
  803fa7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803faa:	eb 4a                	jmp    803ff6 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803fac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803faf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fb2:	74 8c                	je     803f40 <_pipeisclosed+0x11>
  803fb4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fb8:	75 86                	jne    803f40 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fba:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  803fc1:	00 00 00 
  803fc4:	48 8b 00             	mov    (%rax),%rax
  803fc7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fcd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fd3:	89 c6                	mov    %eax,%esi
  803fd5:	48 bf 15 54 80 00 00 	movabs $0x805415,%rdi
  803fdc:	00 00 00 
  803fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe4:	49 b8 1e 06 80 00 00 	movabs $0x80061e,%r8
  803feb:	00 00 00 
  803fee:	41 ff d0             	callq  *%r8
	}
  803ff1:	e9 4a ff ff ff       	jmpq   803f40 <_pipeisclosed+0x11>

}
  803ff6:	48 83 c4 28          	add    $0x28,%rsp
  803ffa:	5b                   	pop    %rbx
  803ffb:	5d                   	pop    %rbp
  803ffc:	c3                   	retq   

0000000000803ffd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ffd:	55                   	push   %rbp
  803ffe:	48 89 e5             	mov    %rsp,%rbp
  804001:	48 83 ec 30          	sub    $0x30,%rsp
  804005:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804008:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80400c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80400f:	48 89 d6             	mov    %rdx,%rsi
  804012:	89 c7                	mov    %eax,%edi
  804014:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80401b:	00 00 00 
  80401e:	ff d0                	callq  *%rax
  804020:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804023:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804027:	79 05                	jns    80402e <pipeisclosed+0x31>
		return r;
  804029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402c:	eb 31                	jmp    80405f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80402e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804032:	48 89 c7             	mov    %rax,%rdi
  804035:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  80403c:	00 00 00 
  80403f:	ff d0                	callq  *%rax
  804041:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804049:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80404d:	48 89 d6             	mov    %rdx,%rsi
  804050:	48 89 c7             	mov    %rax,%rdi
  804053:	48 b8 2f 3f 80 00 00 	movabs $0x803f2f,%rax
  80405a:	00 00 00 
  80405d:	ff d0                	callq  *%rax
}
  80405f:	c9                   	leaveq 
  804060:	c3                   	retq   

0000000000804061 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804061:	55                   	push   %rbp
  804062:	48 89 e5             	mov    %rsp,%rbp
  804065:	48 83 ec 40          	sub    $0x40,%rsp
  804069:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80406d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804071:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804079:	48 89 c7             	mov    %rax,%rdi
  80407c:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  804083:	00 00 00 
  804086:	ff d0                	callq  *%rax
  804088:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80408c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804090:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804094:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80409b:	00 
  80409c:	e9 90 00 00 00       	jmpq   804131 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8040a1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8040a6:	74 09                	je     8040b1 <devpipe_read+0x50>
				return i;
  8040a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ac:	e9 8e 00 00 00       	jmpq   80413f <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040b9:	48 89 d6             	mov    %rdx,%rsi
  8040bc:	48 89 c7             	mov    %rax,%rdi
  8040bf:	48 b8 2f 3f 80 00 00 	movabs $0x803f2f,%rax
  8040c6:	00 00 00 
  8040c9:	ff d0                	callq  *%rax
  8040cb:	85 c0                	test   %eax,%eax
  8040cd:	74 07                	je     8040d6 <devpipe_read+0x75>
				return 0;
  8040cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d4:	eb 69                	jmp    80413f <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040d6:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8040dd:	00 00 00 
  8040e0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e6:	8b 10                	mov    (%rax),%edx
  8040e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ec:	8b 40 04             	mov    0x4(%rax),%eax
  8040ef:	39 c2                	cmp    %eax,%edx
  8040f1:	74 ae                	je     8040a1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804103:	8b 00                	mov    (%rax),%eax
  804105:	99                   	cltd   
  804106:	c1 ea 1b             	shr    $0x1b,%edx
  804109:	01 d0                	add    %edx,%eax
  80410b:	83 e0 1f             	and    $0x1f,%eax
  80410e:	29 d0                	sub    %edx,%eax
  804110:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804114:	48 98                	cltq   
  804116:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80411b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80411d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804121:	8b 00                	mov    (%rax),%eax
  804123:	8d 50 01             	lea    0x1(%rax),%edx
  804126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80412c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804135:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804139:	72 a7                	jb     8040e2 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80413b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80413f:	c9                   	leaveq 
  804140:	c3                   	retq   

0000000000804141 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804141:	55                   	push   %rbp
  804142:	48 89 e5             	mov    %rsp,%rbp
  804145:	48 83 ec 40          	sub    $0x40,%rsp
  804149:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80414d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804151:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804159:	48 89 c7             	mov    %rax,%rdi
  80415c:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  804163:	00 00 00 
  804166:	ff d0                	callq  *%rax
  804168:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80416c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804170:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804174:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80417b:	00 
  80417c:	e9 8f 00 00 00       	jmpq   804210 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804181:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804189:	48 89 d6             	mov    %rdx,%rsi
  80418c:	48 89 c7             	mov    %rax,%rdi
  80418f:	48 b8 2f 3f 80 00 00 	movabs $0x803f2f,%rax
  804196:	00 00 00 
  804199:	ff d0                	callq  *%rax
  80419b:	85 c0                	test   %eax,%eax
  80419d:	74 07                	je     8041a6 <devpipe_write+0x65>
				return 0;
  80419f:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a4:	eb 78                	jmp    80421e <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041a6:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8041ad:	00 00 00 
  8041b0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b6:	8b 40 04             	mov    0x4(%rax),%eax
  8041b9:	48 63 d0             	movslq %eax,%rdx
  8041bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c0:	8b 00                	mov    (%rax),%eax
  8041c2:	48 98                	cltq   
  8041c4:	48 83 c0 20          	add    $0x20,%rax
  8041c8:	48 39 c2             	cmp    %rax,%rdx
  8041cb:	73 b4                	jae    804181 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d1:	8b 40 04             	mov    0x4(%rax),%eax
  8041d4:	99                   	cltd   
  8041d5:	c1 ea 1b             	shr    $0x1b,%edx
  8041d8:	01 d0                	add    %edx,%eax
  8041da:	83 e0 1f             	and    $0x1f,%eax
  8041dd:	29 d0                	sub    %edx,%eax
  8041df:	89 c6                	mov    %eax,%esi
  8041e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e9:	48 01 d0             	add    %rdx,%rax
  8041ec:	0f b6 08             	movzbl (%rax),%ecx
  8041ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041f3:	48 63 c6             	movslq %esi,%rax
  8041f6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fe:	8b 40 04             	mov    0x4(%rax),%eax
  804201:	8d 50 01             	lea    0x1(%rax),%edx
  804204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804208:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80420b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804214:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804218:	72 98                	jb     8041b2 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80421a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80421e:	c9                   	leaveq 
  80421f:	c3                   	retq   

0000000000804220 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804220:	55                   	push   %rbp
  804221:	48 89 e5             	mov    %rsp,%rbp
  804224:	48 83 ec 20          	sub    $0x20,%rsp
  804228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80422c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804234:	48 89 c7             	mov    %rax,%rdi
  804237:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  80423e:	00 00 00 
  804241:	ff d0                	callq  *%rax
  804243:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80424b:	48 be 28 54 80 00 00 	movabs $0x805428,%rsi
  804252:	00 00 00 
  804255:	48 89 c7             	mov    %rax,%rdi
  804258:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804268:	8b 50 04             	mov    0x4(%rax),%edx
  80426b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80426f:	8b 00                	mov    (%rax),%eax
  804271:	29 c2                	sub    %eax,%edx
  804273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804277:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80427d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804281:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804288:	00 00 00 
	stat->st_dev = &devpipe;
  80428b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80428f:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804296:	00 00 00 
  804299:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8042a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042a5:	c9                   	leaveq 
  8042a6:	c3                   	retq   

00000000008042a7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042a7:	55                   	push   %rbp
  8042a8:	48 89 e5             	mov    %rsp,%rbp
  8042ab:	48 83 ec 10          	sub    $0x10,%rsp
  8042af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8042b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b7:	48 89 c6             	mov    %rax,%rsi
  8042ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8042bf:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8042c6:	00 00 00 
  8042c9:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8042cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042cf:	48 89 c7             	mov    %rax,%rdi
  8042d2:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  8042d9:	00 00 00 
  8042dc:	ff d0                	callq  *%rax
  8042de:	48 89 c6             	mov    %rax,%rsi
  8042e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e6:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8042ed:	00 00 00 
  8042f0:	ff d0                	callq  *%rax
}
  8042f2:	c9                   	leaveq 
  8042f3:	c3                   	retq   

00000000008042f4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8042f4:	55                   	push   %rbp
  8042f5:	48 89 e5             	mov    %rsp,%rbp
  8042f8:	48 83 ec 20          	sub    $0x20,%rsp
  8042fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8042ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804303:	75 35                	jne    80433a <wait+0x46>
  804305:	48 b9 2f 54 80 00 00 	movabs $0x80542f,%rcx
  80430c:	00 00 00 
  80430f:	48 ba 3a 54 80 00 00 	movabs $0x80543a,%rdx
  804316:	00 00 00 
  804319:	be 0a 00 00 00       	mov    $0xa,%esi
  80431e:	48 bf 4f 54 80 00 00 	movabs $0x80544f,%rdi
  804325:	00 00 00 
  804328:	b8 00 00 00 00       	mov    $0x0,%eax
  80432d:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  804334:	00 00 00 
  804337:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80433a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804342:	48 98                	cltq   
  804344:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80434b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804352:	00 00 00 
  804355:	48 01 d0             	add    %rdx,%rax
  804358:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80435c:	eb 0c                	jmp    80436a <wait+0x76>
		sys_yield();
  80435e:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  804365:	00 00 00 
  804368:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80436a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80436e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804374:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804377:	75 0e                	jne    804387 <wait+0x93>
  804379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80437d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804383:	85 c0                	test   %eax,%eax
  804385:	75 d7                	jne    80435e <wait+0x6a>
		sys_yield();
}
  804387:	90                   	nop
  804388:	c9                   	leaveq 
  804389:	c3                   	retq   

000000000080438a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80438a:	55                   	push   %rbp
  80438b:	48 89 e5             	mov    %rsp,%rbp
  80438e:	48 83 ec 20          	sub    $0x20,%rsp
  804392:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804395:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804398:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80439b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80439f:	be 01 00 00 00       	mov    $0x1,%esi
  8043a4:	48 89 c7             	mov    %rax,%rdi
  8043a7:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  8043ae:	00 00 00 
  8043b1:	ff d0                	callq  *%rax
}
  8043b3:	90                   	nop
  8043b4:	c9                   	leaveq 
  8043b5:	c3                   	retq   

00000000008043b6 <getchar>:

int
getchar(void)
{
  8043b6:	55                   	push   %rbp
  8043b7:	48 89 e5             	mov    %rsp,%rbp
  8043ba:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8043be:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8043c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8043c7:	48 89 c6             	mov    %rax,%rsi
  8043ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cf:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
  8043db:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8043de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043e2:	79 05                	jns    8043e9 <getchar+0x33>
		return r;
  8043e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e7:	eb 14                	jmp    8043fd <getchar+0x47>
	if (r < 1)
  8043e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ed:	7f 07                	jg     8043f6 <getchar+0x40>
		return -E_EOF;
  8043ef:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8043f4:	eb 07                	jmp    8043fd <getchar+0x47>
	return c;
  8043f6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8043fa:	0f b6 c0             	movzbl %al,%eax

}
  8043fd:	c9                   	leaveq 
  8043fe:	c3                   	retq   

00000000008043ff <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8043ff:	55                   	push   %rbp
  804400:	48 89 e5             	mov    %rsp,%rbp
  804403:	48 83 ec 20          	sub    $0x20,%rsp
  804407:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80440a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80440e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804411:	48 89 d6             	mov    %rdx,%rsi
  804414:	89 c7                	mov    %eax,%edi
  804416:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80441d:	00 00 00 
  804420:	ff d0                	callq  *%rax
  804422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804429:	79 05                	jns    804430 <iscons+0x31>
		return r;
  80442b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442e:	eb 1a                	jmp    80444a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804434:	8b 10                	mov    (%rax),%edx
  804436:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80443d:	00 00 00 
  804440:	8b 00                	mov    (%rax),%eax
  804442:	39 c2                	cmp    %eax,%edx
  804444:	0f 94 c0             	sete   %al
  804447:	0f b6 c0             	movzbl %al,%eax
}
  80444a:	c9                   	leaveq 
  80444b:	c3                   	retq   

000000000080444c <opencons>:

int
opencons(void)
{
  80444c:	55                   	push   %rbp
  80444d:	48 89 e5             	mov    %rsp,%rbp
  804450:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804454:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804458:	48 89 c7             	mov    %rax,%rdi
  80445b:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  804462:	00 00 00 
  804465:	ff d0                	callq  *%rax
  804467:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80446a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446e:	79 05                	jns    804475 <opencons+0x29>
		return r;
  804470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804473:	eb 5b                	jmp    8044d0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804479:	ba 07 04 00 00       	mov    $0x407,%edx
  80447e:	48 89 c6             	mov    %rax,%rsi
  804481:	bf 00 00 00 00       	mov    $0x0,%edi
  804486:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  80448d:	00 00 00 
  804490:	ff d0                	callq  *%rax
  804492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804499:	79 05                	jns    8044a0 <opencons+0x54>
		return r;
  80449b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449e:	eb 30                	jmp    8044d0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a4:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044ab:	00 00 00 
  8044ae:	8b 12                	mov    (%rdx),%edx
  8044b0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8044bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c1:	48 89 c7             	mov    %rax,%rdi
  8044c4:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  8044cb:	00 00 00 
  8044ce:	ff d0                	callq  *%rax
}
  8044d0:	c9                   	leaveq 
  8044d1:	c3                   	retq   

00000000008044d2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044d2:	55                   	push   %rbp
  8044d3:	48 89 e5             	mov    %rsp,%rbp
  8044d6:	48 83 ec 30          	sub    $0x30,%rsp
  8044da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8044e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044eb:	75 13                	jne    804500 <devcons_read+0x2e>
		return 0;
  8044ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f2:	eb 49                	jmp    80453d <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8044f4:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804500:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  804507:	00 00 00 
  80450a:	ff d0                	callq  *%rax
  80450c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80450f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804513:	74 df                	je     8044f4 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804515:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804519:	79 05                	jns    804520 <devcons_read+0x4e>
		return c;
  80451b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80451e:	eb 1d                	jmp    80453d <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804520:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804524:	75 07                	jne    80452d <devcons_read+0x5b>
		return 0;
  804526:	b8 00 00 00 00       	mov    $0x0,%eax
  80452b:	eb 10                	jmp    80453d <devcons_read+0x6b>
	*(char*)vbuf = c;
  80452d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804530:	89 c2                	mov    %eax,%edx
  804532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804536:	88 10                	mov    %dl,(%rax)
	return 1;
  804538:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80453d:	c9                   	leaveq 
  80453e:	c3                   	retq   

000000000080453f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80453f:	55                   	push   %rbp
  804540:	48 89 e5             	mov    %rsp,%rbp
  804543:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80454a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804551:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804558:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80455f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804566:	eb 76                	jmp    8045de <devcons_write+0x9f>
		m = n - tot;
  804568:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80456f:	89 c2                	mov    %eax,%edx
  804571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804574:	29 c2                	sub    %eax,%edx
  804576:	89 d0                	mov    %edx,%eax
  804578:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80457b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80457e:	83 f8 7f             	cmp    $0x7f,%eax
  804581:	76 07                	jbe    80458a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804583:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80458a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80458d:	48 63 d0             	movslq %eax,%rdx
  804590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804593:	48 63 c8             	movslq %eax,%rcx
  804596:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80459d:	48 01 c1             	add    %rax,%rcx
  8045a0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045a7:	48 89 ce             	mov    %rcx,%rsi
  8045aa:	48 89 c7             	mov    %rax,%rdi
  8045ad:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  8045b4:	00 00 00 
  8045b7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045bc:	48 63 d0             	movslq %eax,%rdx
  8045bf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045c6:	48 89 d6             	mov    %rdx,%rsi
  8045c9:	48 89 c7             	mov    %rax,%rdi
  8045cc:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  8045d3:	00 00 00 
  8045d6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045db:	01 45 fc             	add    %eax,-0x4(%rbp)
  8045de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e1:	48 98                	cltq   
  8045e3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8045ea:	0f 82 78 ff ff ff    	jb     804568 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8045f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045f3:	c9                   	leaveq 
  8045f4:	c3                   	retq   

00000000008045f5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8045f5:	55                   	push   %rbp
  8045f6:	48 89 e5             	mov    %rsp,%rbp
  8045f9:	48 83 ec 08          	sub    $0x8,%rsp
  8045fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804606:	c9                   	leaveq 
  804607:	c3                   	retq   

0000000000804608 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804608:	55                   	push   %rbp
  804609:	48 89 e5             	mov    %rsp,%rbp
  80460c:	48 83 ec 10          	sub    $0x10,%rsp
  804610:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804614:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80461c:	48 be 5f 54 80 00 00 	movabs $0x80545f,%rsi
  804623:	00 00 00 
  804626:	48 89 c7             	mov    %rax,%rdi
  804629:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  804630:	00 00 00 
  804633:	ff d0                	callq  *%rax
	return 0;
  804635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80463a:	c9                   	leaveq 
  80463b:	c3                   	retq   

000000000080463c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80463c:	55                   	push   %rbp
  80463d:	48 89 e5             	mov    %rsp,%rbp
  804640:	48 83 ec 20          	sub    $0x20,%rsp
  804644:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804648:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80464f:	00 00 00 
  804652:	48 8b 00             	mov    (%rax),%rax
  804655:	48 85 c0             	test   %rax,%rax
  804658:	75 6f                	jne    8046c9 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80465a:	ba 07 00 00 00       	mov    $0x7,%edx
  80465f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804664:	bf 00 00 00 00       	mov    $0x0,%edi
  804669:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  804670:	00 00 00 
  804673:	ff d0                	callq  *%rax
  804675:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80467c:	79 30                	jns    8046ae <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  80467e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804681:	89 c1                	mov    %eax,%ecx
  804683:	48 ba 68 54 80 00 00 	movabs $0x805468,%rdx
  80468a:	00 00 00 
  80468d:	be 22 00 00 00       	mov    $0x22,%esi
  804692:	48 bf 87 54 80 00 00 	movabs $0x805487,%rdi
  804699:	00 00 00 
  80469c:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a1:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8046a8:	00 00 00 
  8046ab:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8046ae:	48 be dd 46 80 00 00 	movabs $0x8046dd,%rsi
  8046b5:	00 00 00 
  8046b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8046bd:	48 b8 7b 1c 80 00 00 	movabs $0x801c7b,%rax
  8046c4:	00 00 00 
  8046c7:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8046c9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046d0:	00 00 00 
  8046d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046d7:	48 89 10             	mov    %rdx,(%rax)
}
  8046da:	90                   	nop
  8046db:	c9                   	leaveq 
  8046dc:	c3                   	retq   

00000000008046dd <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8046dd:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8046e0:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8046e7:	00 00 00 
call *%rax
  8046ea:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8046ec:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8046f3:	00 08 
    movq 152(%rsp), %rax
  8046f5:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8046fc:	00 
    movq 136(%rsp), %rbx
  8046fd:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804704:	00 
movq %rbx, (%rax)
  804705:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804708:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80470c:	4c 8b 3c 24          	mov    (%rsp),%r15
  804710:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804715:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80471a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80471f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804724:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804729:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80472e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804733:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804738:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80473d:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804742:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804747:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80474c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804751:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804756:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80475a:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  80475e:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80475f:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804764:	c3                   	retq   

0000000000804765 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804765:	55                   	push   %rbp
  804766:	48 89 e5             	mov    %rsp,%rbp
  804769:	48 83 ec 30          	sub    $0x30,%rsp
  80476d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804771:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804775:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804779:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80477e:	75 0e                	jne    80478e <ipc_recv+0x29>
		pg = (void*) UTOP;
  804780:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804787:	00 00 00 
  80478a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80478e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804792:	48 89 c7             	mov    %rax,%rdi
  804795:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  80479c:	00 00 00 
  80479f:	ff d0                	callq  *%rax
  8047a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047a8:	79 27                	jns    8047d1 <ipc_recv+0x6c>
		if (from_env_store)
  8047aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047af:	74 0a                	je     8047bb <ipc_recv+0x56>
			*from_env_store = 0;
  8047b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8047bb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047c0:	74 0a                	je     8047cc <ipc_recv+0x67>
			*perm_store = 0;
  8047c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8047cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047cf:	eb 53                	jmp    804824 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8047d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047d6:	74 19                	je     8047f1 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8047d8:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8047df:	00 00 00 
  8047e2:	48 8b 00             	mov    (%rax),%rax
  8047e5:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8047eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ef:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8047f1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047f6:	74 19                	je     804811 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8047f8:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8047ff:	00 00 00 
  804802:	48 8b 00             	mov    (%rax),%rax
  804805:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80480b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80480f:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804811:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804818:	00 00 00 
  80481b:	48 8b 00             	mov    (%rax),%rax
  80481e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804824:	c9                   	leaveq 
  804825:	c3                   	retq   

0000000000804826 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804826:	55                   	push   %rbp
  804827:	48 89 e5             	mov    %rsp,%rbp
  80482a:	48 83 ec 30          	sub    $0x30,%rsp
  80482e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804831:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804834:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804838:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80483b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804840:	75 1c                	jne    80485e <ipc_send+0x38>
		pg = (void*) UTOP;
  804842:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804849:	00 00 00 
  80484c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804850:	eb 0c                	jmp    80485e <ipc_send+0x38>
		sys_yield();
  804852:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  804859:	00 00 00 
  80485c:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80485e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804861:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804864:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804868:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80486b:	89 c7                	mov    %eax,%edi
  80486d:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  804874:	00 00 00 
  804877:	ff d0                	callq  *%rax
  804879:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80487c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804880:	74 d0                	je     804852 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804882:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804886:	79 30                	jns    8048b8 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80488b:	89 c1                	mov    %eax,%ecx
  80488d:	48 ba 95 54 80 00 00 	movabs $0x805495,%rdx
  804894:	00 00 00 
  804897:	be 47 00 00 00       	mov    $0x47,%esi
  80489c:	48 bf ab 54 80 00 00 	movabs $0x8054ab,%rdi
  8048a3:	00 00 00 
  8048a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ab:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8048b2:	00 00 00 
  8048b5:	41 ff d0             	callq  *%r8

}
  8048b8:	90                   	nop
  8048b9:	c9                   	leaveq 
  8048ba:	c3                   	retq   

00000000008048bb <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8048bb:	55                   	push   %rbp
  8048bc:	48 89 e5             	mov    %rsp,%rbp
  8048bf:	53                   	push   %rbx
  8048c0:	48 83 ec 28          	sub    $0x28,%rsp
  8048c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8048c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8048cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8048d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048db:	75 0e                	jne    8048eb <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8048dd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048e4:	00 00 00 
  8048e7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8048eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ef:	ba 07 00 00 00       	mov    $0x7,%edx
  8048f4:	48 89 c6             	mov    %rax,%rsi
  8048f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8048fc:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  804903:	00 00 00 
  804906:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804908:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80490c:	48 c1 e8 0c          	shr    $0xc,%rax
  804910:	48 89 c2             	mov    %rax,%rdx
  804913:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80491a:	01 00 00 
  80491d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804921:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804927:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  80492b:	b8 03 00 00 00       	mov    $0x3,%eax
  804930:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804934:	48 89 d3             	mov    %rdx,%rbx
  804937:	0f 01 c1             	vmcall 
  80493a:	89 f2                	mov    %esi,%edx
  80493c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80493f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804942:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804946:	79 05                	jns    80494d <ipc_host_recv+0x92>
		return r;
  804948:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80494b:	eb 03                	jmp    804950 <ipc_host_recv+0x95>
	}
	return val;
  80494d:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804950:	48 83 c4 28          	add    $0x28,%rsp
  804954:	5b                   	pop    %rbx
  804955:	5d                   	pop    %rbp
  804956:	c3                   	retq   

0000000000804957 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804957:	55                   	push   %rbp
  804958:	48 89 e5             	mov    %rsp,%rbp
  80495b:	53                   	push   %rbx
  80495c:	48 83 ec 38          	sub    $0x38,%rsp
  804960:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804963:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804966:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80496a:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80496d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804974:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804979:	75 0e                	jne    804989 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  80497b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804982:	00 00 00 
  804985:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804989:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80498d:	48 c1 e8 0c          	shr    $0xc,%rax
  804991:	48 89 c2             	mov    %rax,%rdx
  804994:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80499b:	01 00 00 
  80499e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049a2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8049a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8049ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8049b1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049b4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8049b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049bb:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8049be:	89 fb                	mov    %edi,%ebx
  8049c0:	0f 01 c1             	vmcall 
  8049c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8049c6:	eb 26                	jmp    8049ee <ipc_host_send+0x97>
		sys_yield();
  8049c8:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8049cf:	00 00 00 
  8049d2:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8049d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8049d9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049dc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8049df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049e3:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8049e6:	89 fb                	mov    %edi,%ebx
  8049e8:	0f 01 c1             	vmcall 
  8049eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8049ee:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8049f2:	74 d4                	je     8049c8 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8049f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8049f8:	79 30                	jns    804a2a <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8049fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049fd:	89 c1                	mov    %eax,%ecx
  8049ff:	48 ba 95 54 80 00 00 	movabs $0x805495,%rdx
  804a06:	00 00 00 
  804a09:	be 79 00 00 00       	mov    $0x79,%esi
  804a0e:	48 bf ab 54 80 00 00 	movabs $0x8054ab,%rdi
  804a15:	00 00 00 
  804a18:	b8 00 00 00 00       	mov    $0x0,%eax
  804a1d:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  804a24:	00 00 00 
  804a27:	41 ff d0             	callq  *%r8

}
  804a2a:	90                   	nop
  804a2b:	48 83 c4 38          	add    $0x38,%rsp
  804a2f:	5b                   	pop    %rbx
  804a30:	5d                   	pop    %rbp
  804a31:	c3                   	retq   

0000000000804a32 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a32:	55                   	push   %rbp
  804a33:	48 89 e5             	mov    %rsp,%rbp
  804a36:	48 83 ec 18          	sub    $0x18,%rsp
  804a3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a44:	eb 4d                	jmp    804a93 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804a46:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a4d:	00 00 00 
  804a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a53:	48 98                	cltq   
  804a55:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a5c:	48 01 d0             	add    %rdx,%rax
  804a5f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a65:	8b 00                	mov    (%rax),%eax
  804a67:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a6a:	75 23                	jne    804a8f <ipc_find_env+0x5d>
			return envs[i].env_id;
  804a6c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a73:	00 00 00 
  804a76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a79:	48 98                	cltq   
  804a7b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a82:	48 01 d0             	add    %rdx,%rax
  804a85:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804a8b:	8b 00                	mov    (%rax),%eax
  804a8d:	eb 12                	jmp    804aa1 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804a8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a93:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a9a:	7e aa                	jle    804a46 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804aa1:	c9                   	leaveq 
  804aa2:	c3                   	retq   

0000000000804aa3 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804aa3:	55                   	push   %rbp
  804aa4:	48 89 e5             	mov    %rsp,%rbp
  804aa7:	48 83 ec 18          	sub    $0x18,%rsp
  804aab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ab3:	48 c1 e8 15          	shr    $0x15,%rax
  804ab7:	48 89 c2             	mov    %rax,%rdx
  804aba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804ac1:	01 00 00 
  804ac4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ac8:	83 e0 01             	and    $0x1,%eax
  804acb:	48 85 c0             	test   %rax,%rax
  804ace:	75 07                	jne    804ad7 <pageref+0x34>
		return 0;
  804ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  804ad5:	eb 56                	jmp    804b2d <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804adb:	48 c1 e8 0c          	shr    $0xc,%rax
  804adf:	48 89 c2             	mov    %rax,%rdx
  804ae2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ae9:	01 00 00 
  804aec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804af0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804af8:	83 e0 01             	and    $0x1,%eax
  804afb:	48 85 c0             	test   %rax,%rax
  804afe:	75 07                	jne    804b07 <pageref+0x64>
		return 0;
  804b00:	b8 00 00 00 00       	mov    $0x0,%eax
  804b05:	eb 26                	jmp    804b2d <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b0b:	48 c1 e8 0c          	shr    $0xc,%rax
  804b0f:	48 89 c2             	mov    %rax,%rdx
  804b12:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b19:	00 00 00 
  804b1c:	48 c1 e2 04          	shl    $0x4,%rdx
  804b20:	48 01 d0             	add    %rdx,%rax
  804b23:	48 83 c0 08          	add    $0x8,%rax
  804b27:	0f b7 00             	movzwl (%rax),%eax
  804b2a:	0f b7 c0             	movzwl %ax,%eax
}
  804b2d:	c9                   	leaveq 
  804b2e:	c3                   	retq   
