
obj/user/testfdsharing:     file format elf64-x86-64


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
  800057:	48 bf c0 4a 80 00 00 	movabs $0x804ac0,%rdi
  80005e:	00 00 00 
  800061:	48 b8 e8 2f 80 00 00 	movabs $0x802fe8,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba c5 4a 80 00 00 	movabs $0x804ac5,%rdx
  800082:	00 00 00 
  800085:	be 0d 00 00 00       	mov    $0xd,%esi
  80008a:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 82 80 00 00 	movabs $0x808220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 e4 2b 80 00 00 	movabs $0x802be4,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  8000f1:	00 00 00 
  8000f4:	be 10 00 00 00       	mov    $0x10,%esi
  8000f9:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 7d 23 80 00 00 	movabs $0x80237d,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba f2 4a 80 00 00 	movabs $0x804af2,%rdx
  800136:	00 00 00 
  800139:	be 13 00 00 00       	mov    $0x13,%esi
  80013e:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
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
  80016e:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 00 4b 80 00 00 	movabs $0x804b00,%rdi
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
  8001a9:	48 b8 e4 2b 80 00 00 	movabs $0x802be4,%rax
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
  8001cb:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  8001d2:	00 00 00 
  8001d5:	be 18 00 00 00       	mov    $0x18,%esi
  8001da:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
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
  800222:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  800229:	00 00 00 
  80022c:	be 1a 00 00 00       	mov    $0x1a,%esi
  800231:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e4 03 80 00 00 	movabs $0x8003e4,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf ae 4b 80 00 00 	movabs $0x804bae,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 2e 2d 80 00 00 	movabs $0x802d2e,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
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
  80029f:	48 b8 f0 43 80 00 00 	movabs $0x8043f0,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 e4 2b 80 00 00 	movabs $0x802be4,%rax
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
  8002e1:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  8002e8:	00 00 00 
  8002eb:	be 22 00 00 00       	mov    $0x22,%esi
  8002f0:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf eb 4b 80 00 00 	movabs $0x804beb,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
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
  8003c4:	48 b8 37 29 80 00 00 	movabs $0x802937,%rax
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
  80049e:	48 bf 10 4c 80 00 00 	movabs $0x804c10,%rdi
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
  8004da:	48 bf 33 4c 80 00 00 	movabs $0x804c33,%rdi
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
  80078b:	48 b8 30 4e 80 00 00 	movabs $0x804e30,%rax
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
  800a6d:	48 b8 58 4e 80 00 00 	movabs $0x804e58,%rax
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
  800bb4:	48 b8 80 4d 80 00 00 	movabs $0x804d80,%rax
  800bbb:	00 00 00 
  800bbe:	48 63 d3             	movslq %ebx,%rdx
  800bc1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bc5:	4d 85 e4             	test   %r12,%r12
  800bc8:	75 2e                	jne    800bf8 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800bca:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd2:	89 d9                	mov    %ebx,%ecx
  800bd4:	48 ba 41 4e 80 00 00 	movabs $0x804e41,%rdx
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
  800c03:	48 ba 4a 4e 80 00 00 	movabs $0x804e4a,%rdx
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
  800c5a:	49 bc 4d 4e 80 00 00 	movabs $0x804e4d,%r12
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
  801966:	48 ba 08 51 80 00 00 	movabs $0x805108,%rdx
  80196d:	00 00 00 
  801970:	be 24 00 00 00       	mov    $0x24,%esi
  801975:	48 bf 25 51 80 00 00 	movabs $0x805125,%rdi
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

0000000000801ee0 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801ee0:	55                   	push   %rbp
  801ee1:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801ee4:	48 83 ec 08          	sub    $0x8,%rsp
  801ee8:	6a 00                	pushq  $0x0
  801eea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801efb:	ba 00 00 00 00       	mov    $0x0,%edx
  801f00:	be 00 00 00 00       	mov    $0x0,%esi
  801f05:	bf 13 00 00 00       	mov    $0x13,%edi
  801f0a:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801f1a:	90                   	nop
  801f1b:	c9                   	leaveq 
  801f1c:	c3                   	retq   

0000000000801f1d <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801f1d:	55                   	push   %rbp
  801f1e:	48 89 e5             	mov    %rsp,%rbp
  801f21:	48 83 ec 10          	sub    $0x10,%rsp
  801f25:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2b:	48 98                	cltq   
  801f2d:	48 83 ec 08          	sub    $0x8,%rsp
  801f31:	6a 00                	pushq  $0x0
  801f33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f44:	48 89 c2             	mov    %rax,%rdx
  801f47:	be 00 00 00 00       	mov    $0x0,%esi
  801f4c:	bf 14 00 00 00       	mov    $0x14,%edi
  801f51:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	callq  *%rax
  801f5d:	48 83 c4 10          	add    $0x10,%rsp
}
  801f61:	c9                   	leaveq 
  801f62:	c3                   	retq   

0000000000801f63 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801f63:	55                   	push   %rbp
  801f64:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f67:	48 83 ec 08          	sub    $0x8,%rsp
  801f6b:	6a 00                	pushq  $0x0
  801f6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f79:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f83:	be 00 00 00 00       	mov    $0x0,%esi
  801f88:	bf 15 00 00 00       	mov    $0x15,%edi
  801f8d:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801f94:	00 00 00 
  801f97:	ff d0                	callq  *%rax
  801f99:	48 83 c4 10          	add    $0x10,%rsp
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fa3:	48 83 ec 08          	sub    $0x8,%rsp
  801fa7:	6a 00                	pushq  $0x0
  801fa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801faf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbf:	be 00 00 00 00       	mov    $0x0,%esi
  801fc4:	bf 16 00 00 00       	mov    $0x16,%edi
  801fc9:	48 b8 0e 19 80 00 00 	movabs $0x80190e,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
  801fd5:	48 83 c4 10          	add    $0x10,%rsp
}
  801fd9:	90                   	nop
  801fda:	c9                   	leaveq 
  801fdb:	c3                   	retq   

0000000000801fdc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801fdc:	55                   	push   %rbp
  801fdd:	48 89 e5             	mov    %rsp,%rbp
  801fe0:	48 83 ec 30          	sub    $0x30,%rsp
  801fe4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	48 8b 00             	mov    (%rax),%rax
  801fef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801ff3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802001:	83 e0 02             	and    $0x2,%eax
  802004:	85 c0                	test   %eax,%eax
  802006:	75 40                	jne    802048 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802008:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200c:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802013:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802017:	49 89 d0             	mov    %rdx,%r8
  80201a:	48 89 c1             	mov    %rax,%rcx
  80201d:	48 ba 38 51 80 00 00 	movabs $0x805138,%rdx
  802024:	00 00 00 
  802027:	be 1f 00 00 00       	mov    $0x1f,%esi
  80202c:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802033:	00 00 00 
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  802042:	00 00 00 
  802045:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204c:	48 c1 e8 0c          	shr    $0xc,%rax
  802050:	48 89 c2             	mov    %rax,%rdx
  802053:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80205a:	01 00 00 
  80205d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802061:	25 07 08 00 00       	and    $0x807,%eax
  802066:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80206c:	74 4e                	je     8020bc <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80206e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802072:	48 c1 e8 0c          	shr    $0xc,%rax
  802076:	48 89 c2             	mov    %rax,%rdx
  802079:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802080:	01 00 00 
  802083:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80208b:	49 89 d0             	mov    %rdx,%r8
  80208e:	48 89 c1             	mov    %rax,%rcx
  802091:	48 ba 60 51 80 00 00 	movabs $0x805160,%rdx
  802098:	00 00 00 
  80209b:	be 22 00 00 00       	mov    $0x22,%esi
  8020a0:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8020a7:	00 00 00 
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	49 b9 e4 03 80 00 00 	movabs $0x8003e4,%r9
  8020b6:	00 00 00 
  8020b9:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020bc:	ba 07 00 00 00       	mov    $0x7,%edx
  8020c1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020cb:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  8020d2:	00 00 00 
  8020d5:	ff d0                	callq  *%rax
  8020d7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020da:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020de:	79 30                	jns    802110 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8020e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e3:	89 c1                	mov    %eax,%ecx
  8020e5:	48 ba 8b 51 80 00 00 	movabs $0x80518b,%rdx
  8020ec:	00 00 00 
  8020ef:	be 28 00 00 00       	mov    $0x28,%esi
  8020f4:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8020fb:	00 00 00 
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802103:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80210a:	00 00 00 
  80210d:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802114:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802118:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80211c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802122:	ba 00 10 00 00       	mov    $0x1000,%edx
  802127:	48 89 c6             	mov    %rax,%rsi
  80212a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80212f:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  802136:	00 00 00 
  802139:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80213b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80213f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802147:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80214d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802153:	48 89 c1             	mov    %rax,%rcx
  802156:	ba 00 00 00 00       	mov    $0x0,%edx
  80215b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802160:	bf 00 00 00 00       	mov    $0x0,%edi
  802165:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80216c:	00 00 00 
  80216f:	ff d0                	callq  *%rax
  802171:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802174:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802178:	79 30                	jns    8021aa <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80217a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80217d:	89 c1                	mov    %eax,%ecx
  80217f:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  802186:	00 00 00 
  802189:	be 2d 00 00 00       	mov    $0x2d,%esi
  80218e:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802195:	00 00 00 
  802198:	b8 00 00 00 00       	mov    $0x0,%eax
  80219d:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8021a4:	00 00 00 
  8021a7:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8021aa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021af:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b4:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8021bb:	00 00 00 
  8021be:	ff d0                	callq  *%rax
  8021c0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021c3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021c7:	79 30                	jns    8021f9 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8021c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021cc:	89 c1                	mov    %eax,%ecx
  8021ce:	48 ba af 51 80 00 00 	movabs $0x8051af,%rdx
  8021d5:	00 00 00 
  8021d8:	be 31 00 00 00       	mov    $0x31,%esi
  8021dd:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8021e4:	00 00 00 
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8021f3:	00 00 00 
  8021f6:	41 ff d0             	callq  *%r8

}
  8021f9:	90                   	nop
  8021fa:	c9                   	leaveq 
  8021fb:	c3                   	retq   

00000000008021fc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021fc:	55                   	push   %rbp
  8021fd:	48 89 e5             	mov    %rsp,%rbp
  802200:	48 83 ec 30          	sub    $0x30,%rsp
  802204:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802207:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80220a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80220d:	c1 e0 0c             	shl    $0xc,%eax
  802210:	89 c0                	mov    %eax,%eax
  802212:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802216:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80221d:	01 00 00 
  802220:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802223:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802227:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80222b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222f:	25 02 08 00 00       	and    $0x802,%eax
  802234:	48 85 c0             	test   %rax,%rax
  802237:	74 0e                	je     802247 <duppage+0x4b>
  802239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223d:	25 00 04 00 00       	and    $0x400,%eax
  802242:	48 85 c0             	test   %rax,%rax
  802245:	74 70                	je     8022b7 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224b:	25 07 0e 00 00       	and    $0xe07,%eax
  802250:	89 c6                	mov    %eax,%esi
  802252:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802256:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225d:	41 89 f0             	mov    %esi,%r8d
  802260:	48 89 c6             	mov    %rax,%rsi
  802263:	bf 00 00 00 00       	mov    $0x0,%edi
  802268:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80226f:	00 00 00 
  802272:	ff d0                	callq  *%rax
  802274:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802277:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80227b:	79 30                	jns    8022ad <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80227d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802280:	89 c1                	mov    %eax,%ecx
  802282:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  802289:	00 00 00 
  80228c:	be 50 00 00 00       	mov    $0x50,%esi
  802291:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802298:	00 00 00 
  80229b:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a0:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8022a7:	00 00 00 
  8022aa:	41 ff d0             	callq  *%r8
		return 0;
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b2:	e9 c4 00 00 00       	jmpq   80237b <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8022b7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8022bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c2:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8022c8:	48 89 c6             	mov    %rax,%rsi
  8022cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d0:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	callq  *%rax
  8022dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8022df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022e3:	79 30                	jns    802315 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8022e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022e8:	89 c1                	mov    %eax,%ecx
  8022ea:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  8022f1:	00 00 00 
  8022f4:	be 64 00 00 00       	mov    $0x64,%esi
  8022f9:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802300:	00 00 00 
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80230f:	00 00 00 
  802312:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802315:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231d:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802323:	48 89 d1             	mov    %rdx,%rcx
  802326:	ba 00 00 00 00       	mov    $0x0,%edx
  80232b:	48 89 c6             	mov    %rax,%rsi
  80232e:	bf 00 00 00 00       	mov    $0x0,%edi
  802333:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
  80233f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802342:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802346:	79 30                	jns    802378 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802348:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80234b:	89 c1                	mov    %eax,%ecx
  80234d:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  802354:	00 00 00 
  802357:	be 66 00 00 00       	mov    $0x66,%esi
  80235c:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  802363:	00 00 00 
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
  80236b:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  802372:	00 00 00 
  802375:	41 ff d0             	callq  *%r8
	return r;
  802378:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80237b:	c9                   	leaveq 
  80237c:	c3                   	retq   

000000000080237d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80237d:	55                   	push   %rbp
  80237e:	48 89 e5             	mov    %rsp,%rbp
  802381:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802385:	48 bf dc 1f 80 00 00 	movabs $0x801fdc,%rdi
  80238c:	00 00 00 
  80238f:	48 b8 38 47 80 00 00 	movabs $0x804738,%rax
  802396:	00 00 00 
  802399:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80239b:	b8 07 00 00 00       	mov    $0x7,%eax
  8023a0:	cd 30                	int    $0x30
  8023a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8023a5:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8023a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8023ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023af:	79 08                	jns    8023b9 <fork+0x3c>
		return envid;
  8023b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b4:	e9 0b 02 00 00       	jmpq   8025c4 <fork+0x247>
	if (envid == 0) {
  8023b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023bd:	75 3e                	jne    8023fd <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8023bf:	48 b8 6b 1a 80 00 00 	movabs $0x801a6b,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
  8023cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023d0:	48 98                	cltq   
  8023d2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8023d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023e0:	00 00 00 
  8023e3:	48 01 c2             	add    %rax,%rdx
  8023e6:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8023ed:	00 00 00 
  8023f0:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f8:	e9 c7 01 00 00       	jmpq   8025c4 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8023fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802404:	e9 a6 00 00 00       	jmpq   8024af <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802409:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240c:	c1 f8 12             	sar    $0x12,%eax
  80240f:	89 c2                	mov    %eax,%edx
  802411:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802418:	01 00 00 
  80241b:	48 63 d2             	movslq %edx,%rdx
  80241e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802422:	83 e0 01             	and    $0x1,%eax
  802425:	48 85 c0             	test   %rax,%rax
  802428:	74 21                	je     80244b <fork+0xce>
  80242a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242d:	c1 f8 09             	sar    $0x9,%eax
  802430:	89 c2                	mov    %eax,%edx
  802432:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802439:	01 00 00 
  80243c:	48 63 d2             	movslq %edx,%rdx
  80243f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802443:	83 e0 01             	and    $0x1,%eax
  802446:	48 85 c0             	test   %rax,%rax
  802449:	75 09                	jne    802454 <fork+0xd7>
			pn += NPTENTRIES;
  80244b:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802452:	eb 5b                	jmp    8024af <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802457:	05 00 02 00 00       	add    $0x200,%eax
  80245c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80245f:	eb 46                	jmp    8024a7 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802461:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802468:	01 00 00 
  80246b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80246e:	48 63 d2             	movslq %edx,%rdx
  802471:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802475:	83 e0 05             	and    $0x5,%eax
  802478:	48 83 f8 05          	cmp    $0x5,%rax
  80247c:	75 21                	jne    80249f <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80247e:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802485:	74 1b                	je     8024a2 <fork+0x125>
				continue;
			duppage(envid, pn);
  802487:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80248a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80248d:	89 d6                	mov    %edx,%esi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 fc 21 80 00 00 	movabs $0x8021fc,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	eb 04                	jmp    8024a3 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80249f:	90                   	nop
  8024a0:	eb 01                	jmp    8024a3 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  8024a2:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8024a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024aa:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8024ad:	7c b2                	jl     802461 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8024af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b2:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8024b7:	0f 86 4c ff ff ff    	jbe    802409 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8024bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c0:	ba 07 00 00 00       	mov    $0x7,%edx
  8024c5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024ca:	89 c7                	mov    %eax,%edi
  8024cc:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  8024d3:	00 00 00 
  8024d6:	ff d0                	callq  *%rax
  8024d8:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024db:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024df:	79 30                	jns    802511 <fork+0x194>
		panic("allocating exception stack: %e", r);
  8024e1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024e4:	89 c1                	mov    %eax,%ecx
  8024e6:	48 ba c8 51 80 00 00 	movabs $0x8051c8,%rdx
  8024ed:	00 00 00 
  8024f0:	be 9e 00 00 00       	mov    $0x9e,%esi
  8024f5:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8024fc:	00 00 00 
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80250b:	00 00 00 
  80250e:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802511:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802518:	00 00 00 
  80251b:	48 8b 00             	mov    (%rax),%rax
  80251e:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802525:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802528:	48 89 d6             	mov    %rdx,%rsi
  80252b:	89 c7                	mov    %eax,%edi
  80252d:	48 b8 7b 1c 80 00 00 	movabs $0x801c7b,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80253c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802540:	79 30                	jns    802572 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802542:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802545:	89 c1                	mov    %eax,%ecx
  802547:	48 ba e8 51 80 00 00 	movabs $0x8051e8,%rdx
  80254e:	00 00 00 
  802551:	be a2 00 00 00       	mov    $0xa2,%esi
  802556:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  80255d:	00 00 00 
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
  802565:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  80256c:	00 00 00 
  80256f:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802572:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802575:	be 02 00 00 00       	mov    $0x2,%esi
  80257a:	89 c7                	mov    %eax,%edi
  80257c:	48 b8 e2 1b 80 00 00 	movabs $0x801be2,%rax
  802583:	00 00 00 
  802586:	ff d0                	callq  *%rax
  802588:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80258b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80258f:	79 30                	jns    8025c1 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802591:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802594:	89 c1                	mov    %eax,%ecx
  802596:	48 ba 07 52 80 00 00 	movabs $0x805207,%rdx
  80259d:	00 00 00 
  8025a0:	be a7 00 00 00       	mov    $0xa7,%esi
  8025a5:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8025ac:	00 00 00 
  8025af:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b4:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8025bb:	00 00 00 
  8025be:	41 ff d0             	callq  *%r8

	return envid;
  8025c1:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8025c4:	c9                   	leaveq 
  8025c5:	c3                   	retq   

00000000008025c6 <sfork>:

// Challenge!
int
sfork(void)
{
  8025c6:	55                   	push   %rbp
  8025c7:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025ca:	48 ba 1e 52 80 00 00 	movabs $0x80521e,%rdx
  8025d1:	00 00 00 
  8025d4:	be b1 00 00 00       	mov    $0xb1,%esi
  8025d9:	48 bf 51 51 80 00 00 	movabs $0x805151,%rdi
  8025e0:	00 00 00 
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	48 b9 e4 03 80 00 00 	movabs $0x8003e4,%rcx
  8025ef:	00 00 00 
  8025f2:	ff d1                	callq  *%rcx

00000000008025f4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 08          	sub    $0x8,%rsp
  8025fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802600:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802604:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80260b:	ff ff ff 
  80260e:	48 01 d0             	add    %rdx,%rax
  802611:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802615:	c9                   	leaveq 
  802616:	c3                   	retq   

0000000000802617 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802617:	55                   	push   %rbp
  802618:	48 89 e5             	mov    %rsp,%rbp
  80261b:	48 83 ec 08          	sub    $0x8,%rsp
  80261f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802627:	48 89 c7             	mov    %rax,%rdi
  80262a:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  802631:	00 00 00 
  802634:	ff d0                	callq  *%rax
  802636:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80263c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802640:	c9                   	leaveq 
  802641:	c3                   	retq   

0000000000802642 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802642:	55                   	push   %rbp
  802643:	48 89 e5             	mov    %rsp,%rbp
  802646:	48 83 ec 18          	sub    $0x18,%rsp
  80264a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80264e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802655:	eb 6b                	jmp    8026c2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802657:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265a:	48 98                	cltq   
  80265c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802662:	48 c1 e0 0c          	shl    $0xc,%rax
  802666:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80266a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266e:	48 c1 e8 15          	shr    $0x15,%rax
  802672:	48 89 c2             	mov    %rax,%rdx
  802675:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80267c:	01 00 00 
  80267f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802683:	83 e0 01             	and    $0x1,%eax
  802686:	48 85 c0             	test   %rax,%rax
  802689:	74 21                	je     8026ac <fd_alloc+0x6a>
  80268b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268f:	48 c1 e8 0c          	shr    $0xc,%rax
  802693:	48 89 c2             	mov    %rax,%rdx
  802696:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80269d:	01 00 00 
  8026a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a4:	83 e0 01             	and    $0x1,%eax
  8026a7:	48 85 c0             	test   %rax,%rax
  8026aa:	75 12                	jne    8026be <fd_alloc+0x7c>
			*fd_store = fd;
  8026ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	eb 1a                	jmp    8026d8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026c2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026c6:	7e 8f                	jle    802657 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026d3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026d8:	c9                   	leaveq 
  8026d9:	c3                   	retq   

00000000008026da <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026da:	55                   	push   %rbp
  8026db:	48 89 e5             	mov    %rsp,%rbp
  8026de:	48 83 ec 20          	sub    $0x20,%rsp
  8026e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026ed:	78 06                	js     8026f5 <fd_lookup+0x1b>
  8026ef:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026f3:	7e 07                	jle    8026fc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026fa:	eb 6c                	jmp    802768 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ff:	48 98                	cltq   
  802701:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802707:	48 c1 e0 0c          	shl    $0xc,%rax
  80270b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80270f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802713:	48 c1 e8 15          	shr    $0x15,%rax
  802717:	48 89 c2             	mov    %rax,%rdx
  80271a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802721:	01 00 00 
  802724:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802728:	83 e0 01             	and    $0x1,%eax
  80272b:	48 85 c0             	test   %rax,%rax
  80272e:	74 21                	je     802751 <fd_lookup+0x77>
  802730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802734:	48 c1 e8 0c          	shr    $0xc,%rax
  802738:	48 89 c2             	mov    %rax,%rdx
  80273b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802742:	01 00 00 
  802745:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802749:	83 e0 01             	and    $0x1,%eax
  80274c:	48 85 c0             	test   %rax,%rax
  80274f:	75 07                	jne    802758 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802756:	eb 10                	jmp    802768 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802758:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80275c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802760:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802768:	c9                   	leaveq 
  802769:	c3                   	retq   

000000000080276a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80276a:	55                   	push   %rbp
  80276b:	48 89 e5             	mov    %rsp,%rbp
  80276e:	48 83 ec 30          	sub    $0x30,%rsp
  802772:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802776:	89 f0                	mov    %esi,%eax
  802778:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80277b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277f:	48 89 c7             	mov    %rax,%rdi
  802782:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	89 c2                	mov    %eax,%edx
  802790:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802794:	48 89 c6             	mov    %rax,%rsi
  802797:	89 d7                	mov    %edx,%edi
  802799:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  8027a0:	00 00 00 
  8027a3:	ff d0                	callq  *%rax
  8027a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ac:	78 0a                	js     8027b8 <fd_close+0x4e>
	    || fd != fd2)
  8027ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027b6:	74 12                	je     8027ca <fd_close+0x60>
		return (must_exist ? r : 0);
  8027b8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027bc:	74 05                	je     8027c3 <fd_close+0x59>
  8027be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c1:	eb 70                	jmp    802833 <fd_close+0xc9>
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	eb 69                	jmp    802833 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ce:	8b 00                	mov    (%rax),%eax
  8027d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027d4:	48 89 d6             	mov    %rdx,%rsi
  8027d7:	89 c7                	mov    %eax,%edi
  8027d9:	48 b8 35 28 80 00 00 	movabs $0x802835,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ec:	78 2a                	js     802818 <fd_close+0xae>
		if (dev->dev_close)
  8027ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027f6:	48 85 c0             	test   %rax,%rax
  8027f9:	74 16                	je     802811 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	48 8b 40 20          	mov    0x20(%rax),%rax
  802803:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802807:	48 89 d7             	mov    %rdx,%rdi
  80280a:	ff d0                	callq  *%rax
  80280c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280f:	eb 07                	jmp    802818 <fd_close+0xae>
		else
			r = 0;
  802811:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281c:	48 89 c6             	mov    %rax,%rsi
  80281f:	bf 00 00 00 00       	mov    $0x0,%edi
  802824:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
	return r;
  802830:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802833:	c9                   	leaveq 
  802834:	c3                   	retq   

0000000000802835 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802835:	55                   	push   %rbp
  802836:	48 89 e5             	mov    %rsp,%rbp
  802839:	48 83 ec 20          	sub    $0x20,%rsp
  80283d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802840:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80284b:	eb 41                	jmp    80288e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80284d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802854:	00 00 00 
  802857:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80285a:	48 63 d2             	movslq %edx,%rdx
  80285d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802861:	8b 00                	mov    (%rax),%eax
  802863:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802866:	75 22                	jne    80288a <dev_lookup+0x55>
			*dev = devtab[i];
  802868:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80286f:	00 00 00 
  802872:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802875:	48 63 d2             	movslq %edx,%rdx
  802878:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80287c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802880:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	eb 60                	jmp    8028ea <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80288a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80288e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802895:	00 00 00 
  802898:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80289b:	48 63 d2             	movslq %edx,%rdx
  80289e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a2:	48 85 c0             	test   %rax,%rax
  8028a5:	75 a6                	jne    80284d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028a7:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8028ae:	00 00 00 
  8028b1:	48 8b 00             	mov    (%rax),%rax
  8028b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028ba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028bd:	89 c6                	mov    %eax,%esi
  8028bf:	48 bf 38 52 80 00 00 	movabs $0x805238,%rdi
  8028c6:	00 00 00 
  8028c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ce:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  8028d5:	00 00 00 
  8028d8:	ff d1                	callq  *%rcx
	*dev = 0;
  8028da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028de:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028ea:	c9                   	leaveq 
  8028eb:	c3                   	retq   

00000000008028ec <close>:

int
close(int fdnum)
{
  8028ec:	55                   	push   %rbp
  8028ed:	48 89 e5             	mov    %rsp,%rbp
  8028f0:	48 83 ec 20          	sub    $0x20,%rsp
  8028f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028fe:	48 89 d6             	mov    %rdx,%rsi
  802901:	89 c7                	mov    %eax,%edi
  802903:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  80290a:	00 00 00 
  80290d:	ff d0                	callq  *%rax
  80290f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802912:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802916:	79 05                	jns    80291d <close+0x31>
		return r;
  802918:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291b:	eb 18                	jmp    802935 <close+0x49>
	else
		return fd_close(fd, 1);
  80291d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802921:	be 01 00 00 00       	mov    $0x1,%esi
  802926:	48 89 c7             	mov    %rax,%rdi
  802929:	48 b8 6a 27 80 00 00 	movabs $0x80276a,%rax
  802930:	00 00 00 
  802933:	ff d0                	callq  *%rax
}
  802935:	c9                   	leaveq 
  802936:	c3                   	retq   

0000000000802937 <close_all>:

void
close_all(void)
{
  802937:	55                   	push   %rbp
  802938:	48 89 e5             	mov    %rsp,%rbp
  80293b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80293f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802946:	eb 15                	jmp    80295d <close_all+0x26>
		close(i);
  802948:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294b:	89 c7                	mov    %eax,%edi
  80294d:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802959:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80295d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802961:	7e e5                	jle    802948 <close_all+0x11>
		close(i);
}
  802963:	90                   	nop
  802964:	c9                   	leaveq 
  802965:	c3                   	retq   

0000000000802966 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802966:	55                   	push   %rbp
  802967:	48 89 e5             	mov    %rsp,%rbp
  80296a:	48 83 ec 40          	sub    $0x40,%rsp
  80296e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802971:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802974:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802978:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80297b:	48 89 d6             	mov    %rdx,%rsi
  80297e:	89 c7                	mov    %eax,%edi
  802980:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
  80298c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802993:	79 08                	jns    80299d <dup+0x37>
		return r;
  802995:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802998:	e9 70 01 00 00       	jmpq   802b0d <dup+0x1a7>
	close(newfdnum);
  80299d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a0:	89 c7                	mov    %eax,%edi
  8029a2:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8029ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029b1:	48 98                	cltq   
  8029b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8029bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c5:	48 89 c7             	mov    %rax,%rdi
  8029c8:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	callq  *%rax
  8029d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029dc:	48 89 c7             	mov    %rax,%rdi
  8029df:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
  8029eb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f3:	48 c1 e8 15          	shr    $0x15,%rax
  8029f7:	48 89 c2             	mov    %rax,%rdx
  8029fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a01:	01 00 00 
  802a04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a08:	83 e0 01             	and    $0x1,%eax
  802a0b:	48 85 c0             	test   %rax,%rax
  802a0e:	74 71                	je     802a81 <dup+0x11b>
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	48 c1 e8 0c          	shr    $0xc,%rax
  802a18:	48 89 c2             	mov    %rax,%rdx
  802a1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a22:	01 00 00 
  802a25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a29:	83 e0 01             	and    $0x1,%eax
  802a2c:	48 85 c0             	test   %rax,%rax
  802a2f:	74 50                	je     802a81 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a35:	48 c1 e8 0c          	shr    $0xc,%rax
  802a39:	48 89 c2             	mov    %rax,%rdx
  802a3c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a43:	01 00 00 
  802a46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a4a:	25 07 0e 00 00       	and    $0xe07,%eax
  802a4f:	89 c1                	mov    %eax,%ecx
  802a51:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a59:	41 89 c8             	mov    %ecx,%r8d
  802a5c:	48 89 d1             	mov    %rdx,%rcx
  802a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a64:	48 89 c6             	mov    %rax,%rsi
  802a67:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6c:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax
  802a78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7f:	78 55                	js     802ad6 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a85:	48 c1 e8 0c          	shr    $0xc,%rax
  802a89:	48 89 c2             	mov    %rax,%rdx
  802a8c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a93:	01 00 00 
  802a96:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9a:	25 07 0e 00 00       	and    $0xe07,%eax
  802a9f:	89 c1                	mov    %eax,%ecx
  802aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aa9:	41 89 c8             	mov    %ecx,%r8d
  802aac:	48 89 d1             	mov    %rdx,%rcx
  802aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab4:	48 89 c6             	mov    %rax,%rsi
  802ab7:	bf 00 00 00 00       	mov    $0x0,%edi
  802abc:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acf:	78 08                	js     802ad9 <dup+0x173>
		goto err;

	return newfdnum;
  802ad1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ad4:	eb 37                	jmp    802b0d <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ad6:	90                   	nop
  802ad7:	eb 01                	jmp    802ada <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ad9:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ada:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ade:	48 89 c6             	mov    %rax,%rsi
  802ae1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae6:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802af2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af6:	48 89 c6             	mov    %rax,%rsi
  802af9:	bf 00 00 00 00       	mov    $0x0,%edi
  802afe:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	callq  *%rax
	return r;
  802b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b0d:	c9                   	leaveq 
  802b0e:	c3                   	retq   

0000000000802b0f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b0f:	55                   	push   %rbp
  802b10:	48 89 e5             	mov    %rsp,%rbp
  802b13:	48 83 ec 40          	sub    $0x40,%rsp
  802b17:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b1a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b1e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b22:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b26:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b29:	48 89 d6             	mov    %rdx,%rsi
  802b2c:	89 c7                	mov    %eax,%edi
  802b2e:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802b35:	00 00 00 
  802b38:	ff d0                	callq  *%rax
  802b3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b41:	78 24                	js     802b67 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b47:	8b 00                	mov    (%rax),%eax
  802b49:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4d:	48 89 d6             	mov    %rdx,%rsi
  802b50:	89 c7                	mov    %eax,%edi
  802b52:	48 b8 35 28 80 00 00 	movabs $0x802835,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
  802b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b65:	79 05                	jns    802b6c <read+0x5d>
		return r;
  802b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6a:	eb 76                	jmp    802be2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b70:	8b 40 08             	mov    0x8(%rax),%eax
  802b73:	83 e0 03             	and    $0x3,%eax
  802b76:	83 f8 01             	cmp    $0x1,%eax
  802b79:	75 3a                	jne    802bb5 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b7b:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802b82:	00 00 00 
  802b85:	48 8b 00             	mov    (%rax),%rax
  802b88:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b8e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b91:	89 c6                	mov    %eax,%esi
  802b93:	48 bf 57 52 80 00 00 	movabs $0x805257,%rdi
  802b9a:	00 00 00 
  802b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba2:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  802ba9:	00 00 00 
  802bac:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb3:	eb 2d                	jmp    802be2 <read+0xd3>
	}
	if (!dev->dev_read)
  802bb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb9:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bbd:	48 85 c0             	test   %rax,%rax
  802bc0:	75 07                	jne    802bc9 <read+0xba>
		return -E_NOT_SUPP;
  802bc2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc7:	eb 19                	jmp    802be2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802bc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcd:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bd1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bd5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bd9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bdd:	48 89 cf             	mov    %rcx,%rdi
  802be0:	ff d0                	callq  *%rax
}
  802be2:	c9                   	leaveq 
  802be3:	c3                   	retq   

0000000000802be4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
  802be8:	48 83 ec 30          	sub    $0x30,%rsp
  802bec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bf3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bfe:	eb 47                	jmp    802c47 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c03:	48 98                	cltq   
  802c05:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c09:	48 29 c2             	sub    %rax,%rdx
  802c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0f:	48 63 c8             	movslq %eax,%rcx
  802c12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c16:	48 01 c1             	add    %rax,%rcx
  802c19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c1c:	48 89 ce             	mov    %rcx,%rsi
  802c1f:	89 c7                	mov    %eax,%edi
  802c21:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  802c28:	00 00 00 
  802c2b:	ff d0                	callq  *%rax
  802c2d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c30:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c34:	79 05                	jns    802c3b <readn+0x57>
			return m;
  802c36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c39:	eb 1d                	jmp    802c58 <readn+0x74>
		if (m == 0)
  802c3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c3f:	74 13                	je     802c54 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c44:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4a:	48 98                	cltq   
  802c4c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c50:	72 ae                	jb     802c00 <readn+0x1c>
  802c52:	eb 01                	jmp    802c55 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c54:	90                   	nop
	}
	return tot;
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c58:	c9                   	leaveq 
  802c59:	c3                   	retq   

0000000000802c5a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c5a:	55                   	push   %rbp
  802c5b:	48 89 e5             	mov    %rsp,%rbp
  802c5e:	48 83 ec 40          	sub    $0x40,%rsp
  802c62:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c69:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c74:	48 89 d6             	mov    %rdx,%rsi
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8c:	78 24                	js     802cb2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c92:	8b 00                	mov    (%rax),%eax
  802c94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c98:	48 89 d6             	mov    %rdx,%rsi
  802c9b:	89 c7                	mov    %eax,%edi
  802c9d:	48 b8 35 28 80 00 00 	movabs $0x802835,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
  802ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb0:	79 05                	jns    802cb7 <write+0x5d>
		return r;
  802cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb5:	eb 75                	jmp    802d2c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbb:	8b 40 08             	mov    0x8(%rax),%eax
  802cbe:	83 e0 03             	and    $0x3,%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	75 3a                	jne    802cff <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802cc5:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802ccc:	00 00 00 
  802ccf:	48 8b 00             	mov    (%rax),%rax
  802cd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cdb:	89 c6                	mov    %eax,%esi
  802cdd:	48 bf 73 52 80 00 00 	movabs $0x805273,%rdi
  802ce4:	00 00 00 
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cec:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  802cf3:	00 00 00 
  802cf6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cf8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cfd:	eb 2d                	jmp    802d2c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d03:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d07:	48 85 c0             	test   %rax,%rax
  802d0a:	75 07                	jne    802d13 <write+0xb9>
		return -E_NOT_SUPP;
  802d0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d11:	eb 19                	jmp    802d2c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d17:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d1b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d23:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d27:	48 89 cf             	mov    %rcx,%rdi
  802d2a:	ff d0                	callq  *%rax
}
  802d2c:	c9                   	leaveq 
  802d2d:	c3                   	retq   

0000000000802d2e <seek>:

int
seek(int fdnum, off_t offset)
{
  802d2e:	55                   	push   %rbp
  802d2f:	48 89 e5             	mov    %rsp,%rbp
  802d32:	48 83 ec 18          	sub    $0x18,%rsp
  802d36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d39:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d3c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d43:	48 89 d6             	mov    %rdx,%rsi
  802d46:	89 c7                	mov    %eax,%edi
  802d48:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5b:	79 05                	jns    802d62 <seek+0x34>
		return r;
  802d5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d60:	eb 0f                	jmp    802d71 <seek+0x43>
	fd->fd_offset = offset;
  802d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d66:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d69:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d71:	c9                   	leaveq 
  802d72:	c3                   	retq   

0000000000802d73 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d73:	55                   	push   %rbp
  802d74:	48 89 e5             	mov    %rsp,%rbp
  802d77:	48 83 ec 30          	sub    $0x30,%rsp
  802d7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d7e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d81:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d85:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d88:	48 89 d6             	mov    %rdx,%rsi
  802d8b:	89 c7                	mov    %eax,%edi
  802d8d:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
  802d99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da0:	78 24                	js     802dc6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da6:	8b 00                	mov    (%rax),%eax
  802da8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dac:	48 89 d6             	mov    %rdx,%rsi
  802daf:	89 c7                	mov    %eax,%edi
  802db1:	48 b8 35 28 80 00 00 	movabs $0x802835,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	callq  *%rax
  802dbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc4:	79 05                	jns    802dcb <ftruncate+0x58>
		return r;
  802dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc9:	eb 72                	jmp    802e3d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcf:	8b 40 08             	mov    0x8(%rax),%eax
  802dd2:	83 e0 03             	and    $0x3,%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	75 3a                	jne    802e13 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802dd9:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802de0:	00 00 00 
  802de3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802de6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802def:	89 c6                	mov    %eax,%esi
  802df1:	48 bf 90 52 80 00 00 	movabs $0x805290,%rdi
  802df8:	00 00 00 
  802dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802e00:	48 b9 1e 06 80 00 00 	movabs $0x80061e,%rcx
  802e07:	00 00 00 
  802e0a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e11:	eb 2a                	jmp    802e3d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e17:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e1b:	48 85 c0             	test   %rax,%rax
  802e1e:	75 07                	jne    802e27 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e20:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e25:	eb 16                	jmp    802e3d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e33:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e36:	89 ce                	mov    %ecx,%esi
  802e38:	48 89 d7             	mov    %rdx,%rdi
  802e3b:	ff d0                	callq  *%rax
}
  802e3d:	c9                   	leaveq 
  802e3e:	c3                   	retq   

0000000000802e3f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e3f:	55                   	push   %rbp
  802e40:	48 89 e5             	mov    %rsp,%rbp
  802e43:	48 83 ec 30          	sub    $0x30,%rsp
  802e47:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e4a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e4e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e52:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e55:	48 89 d6             	mov    %rdx,%rsi
  802e58:	89 c7                	mov    %eax,%edi
  802e5a:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
  802e66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6d:	78 24                	js     802e93 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e73:	8b 00                	mov    (%rax),%eax
  802e75:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e79:	48 89 d6             	mov    %rdx,%rsi
  802e7c:	89 c7                	mov    %eax,%edi
  802e7e:	48 b8 35 28 80 00 00 	movabs $0x802835,%rax
  802e85:	00 00 00 
  802e88:	ff d0                	callq  *%rax
  802e8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e91:	79 05                	jns    802e98 <fstat+0x59>
		return r;
  802e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e96:	eb 5e                	jmp    802ef6 <fstat+0xb7>
	if (!dev->dev_stat)
  802e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ea0:	48 85 c0             	test   %rax,%rax
  802ea3:	75 07                	jne    802eac <fstat+0x6d>
		return -E_NOT_SUPP;
  802ea5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eaa:	eb 4a                	jmp    802ef6 <fstat+0xb7>
	stat->st_name[0] = 0;
  802eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802eb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ebe:	00 00 00 
	stat->st_isdir = 0;
  802ec1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ecc:	00 00 00 
	stat->st_dev = dev;
  802ecf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ed3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee2:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ee6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eea:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802eee:	48 89 ce             	mov    %rcx,%rsi
  802ef1:	48 89 d7             	mov    %rdx,%rdi
  802ef4:	ff d0                	callq  *%rax
}
  802ef6:	c9                   	leaveq 
  802ef7:	c3                   	retq   

0000000000802ef8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ef8:	55                   	push   %rbp
  802ef9:	48 89 e5             	mov    %rsp,%rbp
  802efc:	48 83 ec 20          	sub    $0x20,%rsp
  802f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0c:	be 00 00 00 00       	mov    $0x0,%esi
  802f11:	48 89 c7             	mov    %rax,%rdi
  802f14:	48 b8 e8 2f 80 00 00 	movabs $0x802fe8,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
  802f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f27:	79 05                	jns    802f2e <stat+0x36>
		return fd;
  802f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2c:	eb 2f                	jmp    802f5d <stat+0x65>
	r = fstat(fd, stat);
  802f2e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	48 89 d6             	mov    %rdx,%rsi
  802f38:	89 c7                	mov    %eax,%edi
  802f3a:	48 b8 3f 2e 80 00 00 	movabs $0x802e3f,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
  802f46:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4c:	89 c7                	mov    %eax,%edi
  802f4e:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
	return r;
  802f5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f5d:	c9                   	leaveq 
  802f5e:	c3                   	retq   

0000000000802f5f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f5f:	55                   	push   %rbp
  802f60:	48 89 e5             	mov    %rsp,%rbp
  802f63:	48 83 ec 10          	sub    $0x10,%rsp
  802f67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f6e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f75:	00 00 00 
  802f78:	8b 00                	mov    (%rax),%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	75 1f                	jne    802f9d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f7e:	bf 01 00 00 00       	mov    $0x1,%edi
  802f83:	48 b8 b7 49 80 00 00 	movabs $0x8049b7,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
  802f8f:	89 c2                	mov    %eax,%edx
  802f91:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f98:	00 00 00 
  802f9b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f9d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa4:	00 00 00 
  802fa7:	8b 00                	mov    (%rax),%eax
  802fa9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fac:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fb1:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802fb8:	00 00 00 
  802fbb:	89 c7                	mov    %eax,%edi
  802fbd:	48 b8 22 49 80 00 00 	movabs $0x804922,%rax
  802fc4:	00 00 00 
  802fc7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd2:	48 89 c6             	mov    %rax,%rsi
  802fd5:	bf 00 00 00 00       	mov    $0x0,%edi
  802fda:	48 b8 61 48 80 00 00 	movabs $0x804861,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
}
  802fe6:	c9                   	leaveq 
  802fe7:	c3                   	retq   

0000000000802fe8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fe8:	55                   	push   %rbp
  802fe9:	48 89 e5             	mov    %rsp,%rbp
  802fec:	48 83 ec 20          	sub    $0x20,%rsp
  802ff0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ff4:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffb:	48 89 c7             	mov    %rax,%rdi
  802ffe:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
  80300a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80300f:	7e 0a                	jle    80301b <open+0x33>
		return -E_BAD_PATH;
  803011:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803016:	e9 a5 00 00 00       	jmpq   8030c0 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80301b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80301f:	48 89 c7             	mov    %rax,%rdi
  803022:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
  80302e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803035:	79 08                	jns    80303f <open+0x57>
		return r;
  803037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303a:	e9 81 00 00 00       	jmpq   8030c0 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80303f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803043:	48 89 c6             	mov    %rax,%rsi
  803046:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80304d:	00 00 00 
  803050:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803057:	00 00 00 
  80305a:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80305c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803063:	00 00 00 
  803066:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803069:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80306f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803073:	48 89 c6             	mov    %rax,%rsi
  803076:	bf 01 00 00 00       	mov    $0x1,%edi
  80307b:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
  803087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308e:	79 1d                	jns    8030ad <open+0xc5>
		fd_close(fd, 0);
  803090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803094:	be 00 00 00 00       	mov    $0x0,%esi
  803099:	48 89 c7             	mov    %rax,%rdi
  80309c:	48 b8 6a 27 80 00 00 	movabs $0x80276a,%rax
  8030a3:	00 00 00 
  8030a6:	ff d0                	callq  *%rax
		return r;
  8030a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ab:	eb 13                	jmp    8030c0 <open+0xd8>
	}

	return fd2num(fd);
  8030ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax

}
  8030c0:	c9                   	leaveq 
  8030c1:	c3                   	retq   

00000000008030c2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030c2:	55                   	push   %rbp
  8030c3:	48 89 e5             	mov    %rsp,%rbp
  8030c6:	48 83 ec 10          	sub    $0x10,%rsp
  8030ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030dc:	00 00 00 
  8030df:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030e1:	be 00 00 00 00       	mov    $0x0,%esi
  8030e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8030eb:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
}
  8030f7:	c9                   	leaveq 
  8030f8:	c3                   	retq   

00000000008030f9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030f9:	55                   	push   %rbp
  8030fa:	48 89 e5             	mov    %rsp,%rbp
  8030fd:	48 83 ec 30          	sub    $0x30,%rsp
  803101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803105:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803109:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80310d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803111:	8b 50 0c             	mov    0xc(%rax),%edx
  803114:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80311b:	00 00 00 
  80311e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803120:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803127:	00 00 00 
  80312a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80312e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803132:	be 00 00 00 00       	mov    $0x0,%esi
  803137:	bf 03 00 00 00       	mov    $0x3,%edi
  80313c:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
  803148:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314f:	79 08                	jns    803159 <devfile_read+0x60>
		return r;
  803151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803154:	e9 a4 00 00 00       	jmpq   8031fd <devfile_read+0x104>
	assert(r <= n);
  803159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315c:	48 98                	cltq   
  80315e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803162:	76 35                	jbe    803199 <devfile_read+0xa0>
  803164:	48 b9 b6 52 80 00 00 	movabs $0x8052b6,%rcx
  80316b:	00 00 00 
  80316e:	48 ba bd 52 80 00 00 	movabs $0x8052bd,%rdx
  803175:	00 00 00 
  803178:	be 86 00 00 00       	mov    $0x86,%esi
  80317d:	48 bf d2 52 80 00 00 	movabs $0x8052d2,%rdi
  803184:	00 00 00 
  803187:	b8 00 00 00 00       	mov    $0x0,%eax
  80318c:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  803193:	00 00 00 
  803196:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803199:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8031a0:	7e 35                	jle    8031d7 <devfile_read+0xde>
  8031a2:	48 b9 dd 52 80 00 00 	movabs $0x8052dd,%rcx
  8031a9:	00 00 00 
  8031ac:	48 ba bd 52 80 00 00 	movabs $0x8052bd,%rdx
  8031b3:	00 00 00 
  8031b6:	be 87 00 00 00       	mov    $0x87,%esi
  8031bb:	48 bf d2 52 80 00 00 	movabs $0x8052d2,%rdi
  8031c2:	00 00 00 
  8031c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ca:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8031d1:	00 00 00 
  8031d4:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8031d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031da:	48 63 d0             	movslq %eax,%rdx
  8031dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e1:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031e8:	00 00 00 
  8031eb:	48 89 c7             	mov    %rax,%rdi
  8031ee:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
	return r;
  8031fa:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8031fd:	c9                   	leaveq 
  8031fe:	c3                   	retq   

00000000008031ff <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031ff:	55                   	push   %rbp
  803200:	48 89 e5             	mov    %rsp,%rbp
  803203:	48 83 ec 40          	sub    $0x40,%rsp
  803207:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80320b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80320f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803213:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803217:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80321b:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803222:	00 
  803223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803227:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80322b:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803230:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803234:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803238:	8b 50 0c             	mov    0xc(%rax),%edx
  80323b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803242:	00 00 00 
  803245:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803247:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80324e:	00 00 00 
  803251:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803255:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803259:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80325d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803261:	48 89 c6             	mov    %rax,%rsi
  803264:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80326b:	00 00 00 
  80326e:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803275:	00 00 00 
  803278:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80327a:	be 00 00 00 00       	mov    $0x0,%esi
  80327f:	bf 04 00 00 00       	mov    $0x4,%edi
  803284:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
  803290:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803293:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803297:	79 05                	jns    80329e <devfile_write+0x9f>
		return r;
  803299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329c:	eb 43                	jmp    8032e1 <devfile_write+0xe2>
	assert(r <= n);
  80329e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a1:	48 98                	cltq   
  8032a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032a7:	76 35                	jbe    8032de <devfile_write+0xdf>
  8032a9:	48 b9 b6 52 80 00 00 	movabs $0x8052b6,%rcx
  8032b0:	00 00 00 
  8032b3:	48 ba bd 52 80 00 00 	movabs $0x8052bd,%rdx
  8032ba:	00 00 00 
  8032bd:	be a2 00 00 00       	mov    $0xa2,%esi
  8032c2:	48 bf d2 52 80 00 00 	movabs $0x8052d2,%rdi
  8032c9:	00 00 00 
  8032cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d1:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8032d8:	00 00 00 
  8032db:	41 ff d0             	callq  *%r8
	return r;
  8032de:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8032e1:	c9                   	leaveq 
  8032e2:	c3                   	retq   

00000000008032e3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032e3:	55                   	push   %rbp
  8032e4:	48 89 e5             	mov    %rsp,%rbp
  8032e7:	48 83 ec 20          	sub    $0x20,%rsp
  8032eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f7:	8b 50 0c             	mov    0xc(%rax),%edx
  8032fa:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803301:	00 00 00 
  803304:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803306:	be 00 00 00 00       	mov    $0x0,%esi
  80330b:	bf 05 00 00 00       	mov    $0x5,%edi
  803310:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
  80331c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803323:	79 05                	jns    80332a <devfile_stat+0x47>
		return r;
  803325:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803328:	eb 56                	jmp    803380 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80332a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803335:	00 00 00 
  803338:	48 89 c7             	mov    %rax,%rdi
  80333b:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803347:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80334e:	00 00 00 
  803351:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803361:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803368:	00 00 00 
  80336b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803371:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803375:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80337b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803380:	c9                   	leaveq 
  803381:	c3                   	retq   

0000000000803382 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803382:	55                   	push   %rbp
  803383:	48 89 e5             	mov    %rsp,%rbp
  803386:	48 83 ec 10          	sub    $0x10,%rsp
  80338a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80338e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803395:	8b 50 0c             	mov    0xc(%rax),%edx
  803398:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80339f:	00 00 00 
  8033a2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8033a4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033ab:	00 00 00 
  8033ae:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033b1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033b4:	be 00 00 00 00       	mov    $0x0,%esi
  8033b9:	bf 02 00 00 00       	mov    $0x2,%edi
  8033be:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
}
  8033ca:	c9                   	leaveq 
  8033cb:	c3                   	retq   

00000000008033cc <remove>:

// Delete a file
int
remove(const char *path)
{
  8033cc:	55                   	push   %rbp
  8033cd:	48 89 e5             	mov    %rsp,%rbp
  8033d0:	48 83 ec 10          	sub    $0x10,%rsp
  8033d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033dc:	48 89 c7             	mov    %rax,%rdi
  8033df:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  8033e6:	00 00 00 
  8033e9:	ff d0                	callq  *%rax
  8033eb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033f0:	7e 07                	jle    8033f9 <remove+0x2d>
		return -E_BAD_PATH;
  8033f2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033f7:	eb 33                	jmp    80342c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033fd:	48 89 c6             	mov    %rax,%rsi
  803400:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803407:	00 00 00 
  80340a:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803411:	00 00 00 
  803414:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803416:	be 00 00 00 00       	mov    $0x0,%esi
  80341b:	bf 07 00 00 00       	mov    $0x7,%edi
  803420:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
}
  80342c:	c9                   	leaveq 
  80342d:	c3                   	retq   

000000000080342e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80342e:	55                   	push   %rbp
  80342f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803432:	be 00 00 00 00       	mov    $0x0,%esi
  803437:	bf 08 00 00 00       	mov    $0x8,%edi
  80343c:	48 b8 5f 2f 80 00 00 	movabs $0x802f5f,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
}
  803448:	5d                   	pop    %rbp
  803449:	c3                   	retq   

000000000080344a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803455:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80345c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803463:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80346a:	be 00 00 00 00       	mov    $0x0,%esi
  80346f:	48 89 c7             	mov    %rax,%rdi
  803472:	48 b8 e8 2f 80 00 00 	movabs $0x802fe8,%rax
  803479:	00 00 00 
  80347c:	ff d0                	callq  *%rax
  80347e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803481:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803485:	79 28                	jns    8034af <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348a:	89 c6                	mov    %eax,%esi
  80348c:	48 bf e9 52 80 00 00 	movabs $0x8052e9,%rdi
  803493:	00 00 00 
  803496:	b8 00 00 00 00       	mov    $0x0,%eax
  80349b:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8034a2:	00 00 00 
  8034a5:	ff d2                	callq  *%rdx
		return fd_src;
  8034a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034aa:	e9 76 01 00 00       	jmpq   803625 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8034af:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8034b6:	be 01 01 00 00       	mov    $0x101,%esi
  8034bb:	48 89 c7             	mov    %rax,%rdi
  8034be:	48 b8 e8 2f 80 00 00 	movabs $0x802fe8,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
  8034ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8034cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034d1:	0f 89 ad 00 00 00    	jns    803584 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8034d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034da:	89 c6                	mov    %eax,%esi
  8034dc:	48 bf ff 52 80 00 00 	movabs $0x8052ff,%rdi
  8034e3:	00 00 00 
  8034e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034eb:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8034f2:	00 00 00 
  8034f5:	ff d2                	callq  *%rdx
		close(fd_src);
  8034f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fa:	89 c7                	mov    %eax,%edi
  8034fc:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
		return fd_dest;
  803508:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80350b:	e9 15 01 00 00       	jmpq   803625 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803510:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803513:	48 63 d0             	movslq %eax,%rdx
  803516:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80351d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803520:	48 89 ce             	mov    %rcx,%rsi
  803523:	89 c7                	mov    %eax,%edi
  803525:	48 b8 5a 2c 80 00 00 	movabs $0x802c5a,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	callq  *%rax
  803531:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803534:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803538:	79 4a                	jns    803584 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  80353a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80353d:	89 c6                	mov    %eax,%esi
  80353f:	48 bf 19 53 80 00 00 	movabs $0x805319,%rdi
  803546:	00 00 00 
  803549:	b8 00 00 00 00       	mov    $0x0,%eax
  80354e:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  803555:	00 00 00 
  803558:	ff d2                	callq  *%rdx
			close(fd_src);
  80355a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355d:	89 c7                	mov    %eax,%edi
  80355f:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  803566:	00 00 00 
  803569:	ff d0                	callq  *%rax
			close(fd_dest);
  80356b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80356e:	89 c7                	mov    %eax,%edi
  803570:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
			return write_size;
  80357c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80357f:	e9 a1 00 00 00       	jmpq   803625 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803584:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80358b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358e:	ba 00 02 00 00       	mov    $0x200,%edx
  803593:	48 89 ce             	mov    %rcx,%rsi
  803596:	89 c7                	mov    %eax,%edi
  803598:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
  8035a4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035ab:	0f 8f 5f ff ff ff    	jg     803510 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8035b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035b5:	79 47                	jns    8035fe <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8035b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035ba:	89 c6                	mov    %eax,%esi
  8035bc:	48 bf 2c 53 80 00 00 	movabs $0x80532c,%rdi
  8035c3:	00 00 00 
  8035c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cb:	48 ba 1e 06 80 00 00 	movabs $0x80061e,%rdx
  8035d2:	00 00 00 
  8035d5:	ff d2                	callq  *%rdx
		close(fd_src);
  8035d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035da:	89 c7                	mov    %eax,%edi
  8035dc:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
		close(fd_dest);
  8035e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035eb:	89 c7                	mov    %eax,%edi
  8035ed:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
		return read_size;
  8035f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035fc:	eb 27                	jmp    803625 <copy+0x1db>
	}
	close(fd_src);
  8035fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803601:	89 c7                	mov    %eax,%edi
  803603:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
	close(fd_dest);
  80360f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803612:	89 c7                	mov    %eax,%edi
  803614:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
	return 0;
  803620:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803625:	c9                   	leaveq 
  803626:	c3                   	retq   

0000000000803627 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803627:	55                   	push   %rbp
  803628:	48 89 e5             	mov    %rsp,%rbp
  80362b:	48 83 ec 20          	sub    $0x20,%rsp
  80362f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803632:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803636:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803639:	48 89 d6             	mov    %rdx,%rsi
  80363c:	89 c7                	mov    %eax,%edi
  80363e:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803651:	79 05                	jns    803658 <fd2sockid+0x31>
		return r;
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803656:	eb 24                	jmp    80367c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365c:	8b 10                	mov    (%rax),%edx
  80365e:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803665:	00 00 00 
  803668:	8b 00                	mov    (%rax),%eax
  80366a:	39 c2                	cmp    %eax,%edx
  80366c:	74 07                	je     803675 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80366e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803673:	eb 07                	jmp    80367c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803679:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80367c:	c9                   	leaveq 
  80367d:	c3                   	retq   

000000000080367e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80367e:	55                   	push   %rbp
  80367f:	48 89 e5             	mov    %rsp,%rbp
  803682:	48 83 ec 20          	sub    $0x20,%rsp
  803686:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803689:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80368d:	48 89 c7             	mov    %rax,%rdi
  803690:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  803697:	00 00 00 
  80369a:	ff d0                	callq  *%rax
  80369c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a3:	78 26                	js     8036cb <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8036ae:	48 89 c6             	mov    %rax,%rsi
  8036b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b6:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c9:	79 16                	jns    8036e1 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8036cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ce:	89 c7                	mov    %eax,%edi
  8036d0:	48 b8 8d 3b 80 00 00 	movabs $0x803b8d,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
		return r;
  8036dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036df:	eb 3a                	jmp    80371b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e5:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8036ec:	00 00 00 
  8036ef:	8b 12                	mov    (%rdx),%edx
  8036f1:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8036f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803702:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803705:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370c:	48 89 c7             	mov    %rax,%rdi
  80370f:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
}
  80371b:	c9                   	leaveq 
  80371c:	c3                   	retq   

000000000080371d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80371d:	55                   	push   %rbp
  80371e:	48 89 e5             	mov    %rsp,%rbp
  803721:	48 83 ec 30          	sub    $0x30,%rsp
  803725:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803728:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80372c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803733:	89 c7                	mov    %eax,%edi
  803735:	48 b8 27 36 80 00 00 	movabs $0x803627,%rax
  80373c:	00 00 00 
  80373f:	ff d0                	callq  *%rax
  803741:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803744:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803748:	79 05                	jns    80374f <accept+0x32>
		return r;
  80374a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374d:	eb 3b                	jmp    80378a <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80374f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803753:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375a:	48 89 ce             	mov    %rcx,%rsi
  80375d:	89 c7                	mov    %eax,%edi
  80375f:	48 b8 6a 3a 80 00 00 	movabs $0x803a6a,%rax
  803766:	00 00 00 
  803769:	ff d0                	callq  *%rax
  80376b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80376e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803772:	79 05                	jns    803779 <accept+0x5c>
		return r;
  803774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803777:	eb 11                	jmp    80378a <accept+0x6d>
	return alloc_sockfd(r);
  803779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377c:	89 c7                	mov    %eax,%edi
  80377e:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
}
  80378a:	c9                   	leaveq 
  80378b:	c3                   	retq   

000000000080378c <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80378c:	55                   	push   %rbp
  80378d:	48 89 e5             	mov    %rsp,%rbp
  803790:	48 83 ec 20          	sub    $0x20,%rsp
  803794:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803797:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80379b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80379e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037a1:	89 c7                	mov    %eax,%edi
  8037a3:	48 b8 27 36 80 00 00 	movabs $0x803627,%rax
  8037aa:	00 00 00 
  8037ad:	ff d0                	callq  *%rax
  8037af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b6:	79 05                	jns    8037bd <bind+0x31>
		return r;
  8037b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bb:	eb 1b                	jmp    8037d8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8037bd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c7:	48 89 ce             	mov    %rcx,%rsi
  8037ca:	89 c7                	mov    %eax,%edi
  8037cc:	48 b8 e9 3a 80 00 00 	movabs $0x803ae9,%rax
  8037d3:	00 00 00 
  8037d6:	ff d0                	callq  *%rax
}
  8037d8:	c9                   	leaveq 
  8037d9:	c3                   	retq   

00000000008037da <shutdown>:

int
shutdown(int s, int how)
{
  8037da:	55                   	push   %rbp
  8037db:	48 89 e5             	mov    %rsp,%rbp
  8037de:	48 83 ec 20          	sub    $0x20,%rsp
  8037e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037e5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037eb:	89 c7                	mov    %eax,%edi
  8037ed:	48 b8 27 36 80 00 00 	movabs $0x803627,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
  8037f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803800:	79 05                	jns    803807 <shutdown+0x2d>
		return r;
  803802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803805:	eb 16                	jmp    80381d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803807:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80380a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380d:	89 d6                	mov    %edx,%esi
  80380f:	89 c7                	mov    %eax,%edi
  803811:	48 b8 4d 3b 80 00 00 	movabs $0x803b4d,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
}
  80381d:	c9                   	leaveq 
  80381e:	c3                   	retq   

000000000080381f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80381f:	55                   	push   %rbp
  803820:	48 89 e5             	mov    %rsp,%rbp
  803823:	48 83 ec 10          	sub    $0x10,%rsp
  803827:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80382b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382f:	48 89 c7             	mov    %rax,%rdi
  803832:	48 b8 28 4a 80 00 00 	movabs $0x804a28,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	83 f8 01             	cmp    $0x1,%eax
  803841:	75 17                	jne    80385a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803843:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803847:	8b 40 0c             	mov    0xc(%rax),%eax
  80384a:	89 c7                	mov    %eax,%edi
  80384c:	48 b8 8d 3b 80 00 00 	movabs $0x803b8d,%rax
  803853:	00 00 00 
  803856:	ff d0                	callq  *%rax
  803858:	eb 05                	jmp    80385f <devsock_close+0x40>
	else
		return 0;
  80385a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80385f:	c9                   	leaveq 
  803860:	c3                   	retq   

0000000000803861 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803861:	55                   	push   %rbp
  803862:	48 89 e5             	mov    %rsp,%rbp
  803865:	48 83 ec 20          	sub    $0x20,%rsp
  803869:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80386c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803870:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803873:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803876:	89 c7                	mov    %eax,%edi
  803878:	48 b8 27 36 80 00 00 	movabs $0x803627,%rax
  80387f:	00 00 00 
  803882:	ff d0                	callq  *%rax
  803884:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803887:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388b:	79 05                	jns    803892 <connect+0x31>
		return r;
  80388d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803890:	eb 1b                	jmp    8038ad <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803892:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803895:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389c:	48 89 ce             	mov    %rcx,%rsi
  80389f:	89 c7                	mov    %eax,%edi
  8038a1:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
}
  8038ad:	c9                   	leaveq 
  8038ae:	c3                   	retq   

00000000008038af <listen>:

int
listen(int s, int backlog)
{
  8038af:	55                   	push   %rbp
  8038b0:	48 89 e5             	mov    %rsp,%rbp
  8038b3:	48 83 ec 20          	sub    $0x20,%rsp
  8038b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c0:	89 c7                	mov    %eax,%edi
  8038c2:	48 b8 27 36 80 00 00 	movabs $0x803627,%rax
  8038c9:	00 00 00 
  8038cc:	ff d0                	callq  *%rax
  8038ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d5:	79 05                	jns    8038dc <listen+0x2d>
		return r;
  8038d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038da:	eb 16                	jmp    8038f2 <listen+0x43>
	return nsipc_listen(r, backlog);
  8038dc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e2:	89 d6                	mov    %edx,%esi
  8038e4:	89 c7                	mov    %eax,%edi
  8038e6:	48 b8 1e 3c 80 00 00 	movabs $0x803c1e,%rax
  8038ed:	00 00 00 
  8038f0:	ff d0                	callq  *%rax
}
  8038f2:	c9                   	leaveq 
  8038f3:	c3                   	retq   

00000000008038f4 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038f4:	55                   	push   %rbp
  8038f5:	48 89 e5             	mov    %rsp,%rbp
  8038f8:	48 83 ec 20          	sub    $0x20,%rsp
  8038fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803900:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803904:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80390c:	89 c2                	mov    %eax,%edx
  80390e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803912:	8b 40 0c             	mov    0xc(%rax),%eax
  803915:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803919:	b9 00 00 00 00       	mov    $0x0,%ecx
  80391e:	89 c7                	mov    %eax,%edi
  803920:	48 b8 5e 3c 80 00 00 	movabs $0x803c5e,%rax
  803927:	00 00 00 
  80392a:	ff d0                	callq  *%rax
}
  80392c:	c9                   	leaveq 
  80392d:	c3                   	retq   

000000000080392e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80392e:	55                   	push   %rbp
  80392f:	48 89 e5             	mov    %rsp,%rbp
  803932:	48 83 ec 20          	sub    $0x20,%rsp
  803936:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80393a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80393e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803946:	89 c2                	mov    %eax,%edx
  803948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394c:	8b 40 0c             	mov    0xc(%rax),%eax
  80394f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803953:	b9 00 00 00 00       	mov    $0x0,%ecx
  803958:	89 c7                	mov    %eax,%edi
  80395a:	48 b8 2a 3d 80 00 00 	movabs $0x803d2a,%rax
  803961:	00 00 00 
  803964:	ff d0                	callq  *%rax
}
  803966:	c9                   	leaveq 
  803967:	c3                   	retq   

0000000000803968 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803968:	55                   	push   %rbp
  803969:	48 89 e5             	mov    %rsp,%rbp
  80396c:	48 83 ec 10          	sub    $0x10,%rsp
  803970:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803974:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397c:	48 be 47 53 80 00 00 	movabs $0x805347,%rsi
  803983:	00 00 00 
  803986:	48 89 c7             	mov    %rax,%rdi
  803989:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803990:	00 00 00 
  803993:	ff d0                	callq  *%rax
	return 0;
  803995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80399a:	c9                   	leaveq 
  80399b:	c3                   	retq   

000000000080399c <socket>:

int
socket(int domain, int type, int protocol)
{
  80399c:	55                   	push   %rbp
  80399d:	48 89 e5             	mov    %rsp,%rbp
  8039a0:	48 83 ec 20          	sub    $0x20,%rsp
  8039a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039a7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039aa:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8039ad:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8039b0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b6:	89 ce                	mov    %ecx,%esi
  8039b8:	89 c7                	mov    %eax,%edi
  8039ba:	48 b8 e2 3d 80 00 00 	movabs $0x803de2,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
  8039c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cd:	79 05                	jns    8039d4 <socket+0x38>
		return r;
  8039cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d2:	eb 11                	jmp    8039e5 <socket+0x49>
	return alloc_sockfd(r);
  8039d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d7:	89 c7                	mov    %eax,%edi
  8039d9:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
}
  8039e5:	c9                   	leaveq 
  8039e6:	c3                   	retq   

00000000008039e7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039e7:	55                   	push   %rbp
  8039e8:	48 89 e5             	mov    %rsp,%rbp
  8039eb:	48 83 ec 10          	sub    $0x10,%rsp
  8039ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8039f2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039f9:	00 00 00 
  8039fc:	8b 00                	mov    (%rax),%eax
  8039fe:	85 c0                	test   %eax,%eax
  803a00:	75 1f                	jne    803a21 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a02:	bf 02 00 00 00       	mov    $0x2,%edi
  803a07:	48 b8 b7 49 80 00 00 	movabs $0x8049b7,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
  803a13:	89 c2                	mov    %eax,%edx
  803a15:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a1c:	00 00 00 
  803a1f:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a21:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a28:	00 00 00 
  803a2b:	8b 00                	mov    (%rax),%eax
  803a2d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a30:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a35:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a3c:	00 00 00 
  803a3f:	89 c7                	mov    %eax,%edi
  803a41:	48 b8 22 49 80 00 00 	movabs $0x804922,%rax
  803a48:	00 00 00 
  803a4b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a52:	be 00 00 00 00       	mov    $0x0,%esi
  803a57:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5c:	48 b8 61 48 80 00 00 	movabs $0x804861,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
}
  803a68:	c9                   	leaveq 
  803a69:	c3                   	retq   

0000000000803a6a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a6a:	55                   	push   %rbp
  803a6b:	48 89 e5             	mov    %rsp,%rbp
  803a6e:	48 83 ec 30          	sub    $0x30,%rsp
  803a72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a79:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a7d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a84:	00 00 00 
  803a87:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a8a:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a8c:	bf 01 00 00 00       	mov    $0x1,%edi
  803a91:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803a98:	00 00 00 
  803a9b:	ff d0                	callq  *%rax
  803a9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa4:	78 3e                	js     803ae4 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803aa6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aad:	00 00 00 
  803ab0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab8:	8b 40 10             	mov    0x10(%rax),%eax
  803abb:	89 c2                	mov    %eax,%edx
  803abd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803ac1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ac5:	48 89 ce             	mov    %rcx,%rsi
  803ac8:	48 89 c7             	mov    %rax,%rdi
  803acb:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803ad2:	00 00 00 
  803ad5:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803adb:	8b 50 10             	mov    0x10(%rax),%edx
  803ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae2:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ae7:	c9                   	leaveq 
  803ae8:	c3                   	retq   

0000000000803ae9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ae9:	55                   	push   %rbp
  803aea:	48 89 e5             	mov    %rsp,%rbp
  803aed:	48 83 ec 10          	sub    $0x10,%rsp
  803af1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803af4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803af8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803afb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b02:	00 00 00 
  803b05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b08:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b0a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b11:	48 89 c6             	mov    %rax,%rsi
  803b14:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b1b:	00 00 00 
  803b1e:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b2a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b31:	00 00 00 
  803b34:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b37:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b3a:	bf 02 00 00 00       	mov    $0x2,%edi
  803b3f:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803b46:	00 00 00 
  803b49:	ff d0                	callq  *%rax
}
  803b4b:	c9                   	leaveq 
  803b4c:	c3                   	retq   

0000000000803b4d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b4d:	55                   	push   %rbp
  803b4e:	48 89 e5             	mov    %rsp,%rbp
  803b51:	48 83 ec 10          	sub    $0x10,%rsp
  803b55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b5b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b62:	00 00 00 
  803b65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b68:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b6a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b71:	00 00 00 
  803b74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b77:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b7a:	bf 03 00 00 00       	mov    $0x3,%edi
  803b7f:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803b86:	00 00 00 
  803b89:	ff d0                	callq  *%rax
}
  803b8b:	c9                   	leaveq 
  803b8c:	c3                   	retq   

0000000000803b8d <nsipc_close>:

int
nsipc_close(int s)
{
  803b8d:	55                   	push   %rbp
  803b8e:	48 89 e5             	mov    %rsp,%rbp
  803b91:	48 83 ec 10          	sub    $0x10,%rsp
  803b95:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b98:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b9f:	00 00 00 
  803ba2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ba5:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803ba7:	bf 04 00 00 00       	mov    $0x4,%edi
  803bac:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803bb3:	00 00 00 
  803bb6:	ff d0                	callq  *%rax
}
  803bb8:	c9                   	leaveq 
  803bb9:	c3                   	retq   

0000000000803bba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bba:	55                   	push   %rbp
  803bbb:	48 89 e5             	mov    %rsp,%rbp
  803bbe:	48 83 ec 10          	sub    $0x10,%rsp
  803bc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bc9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803bcc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bd3:	00 00 00 
  803bd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bd9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bdb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be2:	48 89 c6             	mov    %rax,%rsi
  803be5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bec:	00 00 00 
  803bef:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803bfb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c02:	00 00 00 
  803c05:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c08:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c0b:	bf 05 00 00 00       	mov    $0x5,%edi
  803c10:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803c17:	00 00 00 
  803c1a:	ff d0                	callq  *%rax
}
  803c1c:	c9                   	leaveq 
  803c1d:	c3                   	retq   

0000000000803c1e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c1e:	55                   	push   %rbp
  803c1f:	48 89 e5             	mov    %rsp,%rbp
  803c22:	48 83 ec 10          	sub    $0x10,%rsp
  803c26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c29:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c2c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c33:	00 00 00 
  803c36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c39:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c3b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c42:	00 00 00 
  803c45:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c48:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c4b:	bf 06 00 00 00       	mov    $0x6,%edi
  803c50:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
}
  803c5c:	c9                   	leaveq 
  803c5d:	c3                   	retq   

0000000000803c5e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c5e:	55                   	push   %rbp
  803c5f:	48 89 e5             	mov    %rsp,%rbp
  803c62:	48 83 ec 30          	sub    $0x30,%rsp
  803c66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c6d:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c70:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7a:	00 00 00 
  803c7d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c80:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c89:	00 00 00 
  803c8c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c8f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c99:	00 00 00 
  803c9c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c9f:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ca2:	bf 07 00 00 00       	mov    $0x7,%edi
  803ca7:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803cae:	00 00 00 
  803cb1:	ff d0                	callq  *%rax
  803cb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cba:	78 69                	js     803d25 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803cbc:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803cc3:	7f 08                	jg     803ccd <nsipc_recv+0x6f>
  803cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803ccb:	7e 35                	jle    803d02 <nsipc_recv+0xa4>
  803ccd:	48 b9 4e 53 80 00 00 	movabs $0x80534e,%rcx
  803cd4:	00 00 00 
  803cd7:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  803cde:	00 00 00 
  803ce1:	be 62 00 00 00       	mov    $0x62,%esi
  803ce6:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  803ced:	00 00 00 
  803cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf5:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  803cfc:	00 00 00 
  803cff:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d05:	48 63 d0             	movslq %eax,%rdx
  803d08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0c:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d13:	00 00 00 
  803d16:	48 89 c7             	mov    %rax,%rdi
  803d19:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
	}

	return r;
  803d25:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d28:	c9                   	leaveq 
  803d29:	c3                   	retq   

0000000000803d2a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	48 83 ec 20          	sub    $0x20,%rsp
  803d32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d39:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d3c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d3f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d46:	00 00 00 
  803d49:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d4c:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d4e:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d55:	7e 35                	jle    803d8c <nsipc_send+0x62>
  803d57:	48 b9 84 53 80 00 00 	movabs $0x805384,%rcx
  803d5e:	00 00 00 
  803d61:	48 ba 63 53 80 00 00 	movabs $0x805363,%rdx
  803d68:	00 00 00 
  803d6b:	be 6d 00 00 00       	mov    $0x6d,%esi
  803d70:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  803d77:	00 00 00 
  803d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7f:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  803d86:	00 00 00 
  803d89:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d8f:	48 63 d0             	movslq %eax,%rdx
  803d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d96:	48 89 c6             	mov    %rax,%rsi
  803d99:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803da0:	00 00 00 
  803da3:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803daf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803db6:	00 00 00 
  803db9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dbc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803dbf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dc6:	00 00 00 
  803dc9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dcc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803dcf:	bf 08 00 00 00       	mov    $0x8,%edi
  803dd4:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	callq  *%rax
}
  803de0:	c9                   	leaveq 
  803de1:	c3                   	retq   

0000000000803de2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803de2:	55                   	push   %rbp
  803de3:	48 89 e5             	mov    %rsp,%rbp
  803de6:	48 83 ec 10          	sub    $0x10,%rsp
  803dea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ded:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803df0:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803df3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfa:	00 00 00 
  803dfd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e00:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e02:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e09:	00 00 00 
  803e0c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e0f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e12:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e19:	00 00 00 
  803e1c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e1f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e22:	bf 09 00 00 00       	mov    $0x9,%edi
  803e27:	48 b8 e7 39 80 00 00 	movabs $0x8039e7,%rax
  803e2e:	00 00 00 
  803e31:	ff d0                	callq  *%rax
}
  803e33:	c9                   	leaveq 
  803e34:	c3                   	retq   

0000000000803e35 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e35:	55                   	push   %rbp
  803e36:	48 89 e5             	mov    %rsp,%rbp
  803e39:	53                   	push   %rbx
  803e3a:	48 83 ec 38          	sub    $0x38,%rsp
  803e3e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e42:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e46:	48 89 c7             	mov    %rax,%rdi
  803e49:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  803e50:	00 00 00 
  803e53:	ff d0                	callq  *%rax
  803e55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e5c:	0f 88 bf 01 00 00    	js     804021 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e66:	ba 07 04 00 00       	mov    $0x407,%edx
  803e6b:	48 89 c6             	mov    %rax,%rsi
  803e6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e73:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  803e7a:	00 00 00 
  803e7d:	ff d0                	callq  *%rax
  803e7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e86:	0f 88 95 01 00 00    	js     804021 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e8c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e90:	48 89 c7             	mov    %rax,%rdi
  803e93:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  803e9a:	00 00 00 
  803e9d:	ff d0                	callq  *%rax
  803e9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ea2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ea6:	0f 88 5d 01 00 00    	js     804009 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb0:	ba 07 04 00 00       	mov    $0x407,%edx
  803eb5:	48 89 c6             	mov    %rax,%rsi
  803eb8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ebd:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  803ec4:	00 00 00 
  803ec7:	ff d0                	callq  *%rax
  803ec9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ecc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ed0:	0f 88 33 01 00 00    	js     804009 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ed6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eda:	48 89 c7             	mov    %rax,%rdi
  803edd:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  803ee4:	00 00 00 
  803ee7:	ff d0                	callq  *%rax
  803ee9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef1:	ba 07 04 00 00       	mov    $0x407,%edx
  803ef6:	48 89 c6             	mov    %rax,%rsi
  803ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  803efe:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  803f05:	00 00 00 
  803f08:	ff d0                	callq  *%rax
  803f0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f11:	0f 88 d9 00 00 00    	js     803ff0 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f1b:	48 89 c7             	mov    %rax,%rdi
  803f1e:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  803f25:	00 00 00 
  803f28:	ff d0                	callq  *%rax
  803f2a:	48 89 c2             	mov    %rax,%rdx
  803f2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f31:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f37:	48 89 d1             	mov    %rdx,%rcx
  803f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  803f3f:	48 89 c6             	mov    %rax,%rsi
  803f42:	bf 00 00 00 00       	mov    $0x0,%edi
  803f47:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  803f4e:	00 00 00 
  803f51:	ff d0                	callq  *%rax
  803f53:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f56:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f5a:	78 79                	js     803fd5 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f60:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f67:	00 00 00 
  803f6a:	8b 12                	mov    (%rdx),%edx
  803f6c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f84:	00 00 00 
  803f87:	8b 12                	mov    (%rdx),%edx
  803f89:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f8f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f9a:	48 89 c7             	mov    %rax,%rdi
  803f9d:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
  803fa9:	89 c2                	mov    %eax,%edx
  803fab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803faf:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803fb1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fb5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fbd:	48 89 c7             	mov    %rax,%rdi
  803fc0:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803fc7:	00 00 00 
  803fca:	ff d0                	callq  *%rax
  803fcc:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fce:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd3:	eb 4f                	jmp    804024 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803fd5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803fd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fda:	48 89 c6             	mov    %rax,%rsi
  803fdd:	bf 00 00 00 00       	mov    $0x0,%edi
  803fe2:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  803fe9:	00 00 00 
  803fec:	ff d0                	callq  *%rax
  803fee:	eb 01                	jmp    803ff1 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803ff0:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ff1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff5:	48 89 c6             	mov    %rax,%rsi
  803ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ffd:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  804004:	00 00 00 
  804007:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804009:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80400d:	48 89 c6             	mov    %rax,%rsi
  804010:	bf 00 00 00 00       	mov    $0x0,%edi
  804015:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80401c:	00 00 00 
  80401f:	ff d0                	callq  *%rax
err:
	return r;
  804021:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804024:	48 83 c4 38          	add    $0x38,%rsp
  804028:	5b                   	pop    %rbx
  804029:	5d                   	pop    %rbp
  80402a:	c3                   	retq   

000000000080402b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80402b:	55                   	push   %rbp
  80402c:	48 89 e5             	mov    %rsp,%rbp
  80402f:	53                   	push   %rbx
  804030:	48 83 ec 28          	sub    $0x28,%rsp
  804034:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804038:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80403c:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804043:	00 00 00 
  804046:	48 8b 00             	mov    (%rax),%rax
  804049:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80404f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804052:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804056:	48 89 c7             	mov    %rax,%rdi
  804059:	48 b8 28 4a 80 00 00 	movabs $0x804a28,%rax
  804060:	00 00 00 
  804063:	ff d0                	callq  *%rax
  804065:	89 c3                	mov    %eax,%ebx
  804067:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80406b:	48 89 c7             	mov    %rax,%rdi
  80406e:	48 b8 28 4a 80 00 00 	movabs $0x804a28,%rax
  804075:	00 00 00 
  804078:	ff d0                	callq  *%rax
  80407a:	39 c3                	cmp    %eax,%ebx
  80407c:	0f 94 c0             	sete   %al
  80407f:	0f b6 c0             	movzbl %al,%eax
  804082:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804085:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80408c:	00 00 00 
  80408f:	48 8b 00             	mov    (%rax),%rax
  804092:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804098:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80409b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80409e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040a1:	75 05                	jne    8040a8 <_pipeisclosed+0x7d>
			return ret;
  8040a3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040a6:	eb 4a                	jmp    8040f2 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8040a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ab:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040ae:	74 8c                	je     80403c <_pipeisclosed+0x11>
  8040b0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8040b4:	75 86                	jne    80403c <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8040b6:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8040bd:	00 00 00 
  8040c0:	48 8b 00             	mov    (%rax),%rax
  8040c3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040c9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040cf:	89 c6                	mov    %eax,%esi
  8040d1:	48 bf 95 53 80 00 00 	movabs $0x805395,%rdi
  8040d8:	00 00 00 
  8040db:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e0:	49 b8 1e 06 80 00 00 	movabs $0x80061e,%r8
  8040e7:	00 00 00 
  8040ea:	41 ff d0             	callq  *%r8
	}
  8040ed:	e9 4a ff ff ff       	jmpq   80403c <_pipeisclosed+0x11>

}
  8040f2:	48 83 c4 28          	add    $0x28,%rsp
  8040f6:	5b                   	pop    %rbx
  8040f7:	5d                   	pop    %rbp
  8040f8:	c3                   	retq   

00000000008040f9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8040f9:	55                   	push   %rbp
  8040fa:	48 89 e5             	mov    %rsp,%rbp
  8040fd:	48 83 ec 30          	sub    $0x30,%rsp
  804101:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804104:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804108:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80410b:	48 89 d6             	mov    %rdx,%rsi
  80410e:	89 c7                	mov    %eax,%edi
  804110:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  804117:	00 00 00 
  80411a:	ff d0                	callq  *%rax
  80411c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80411f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804123:	79 05                	jns    80412a <pipeisclosed+0x31>
		return r;
  804125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804128:	eb 31                	jmp    80415b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80412a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412e:	48 89 c7             	mov    %rax,%rdi
  804131:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
  80413d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804145:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804149:	48 89 d6             	mov    %rdx,%rsi
  80414c:	48 89 c7             	mov    %rax,%rdi
  80414f:	48 b8 2b 40 80 00 00 	movabs $0x80402b,%rax
  804156:	00 00 00 
  804159:	ff d0                	callq  *%rax
}
  80415b:	c9                   	leaveq 
  80415c:	c3                   	retq   

000000000080415d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80415d:	55                   	push   %rbp
  80415e:	48 89 e5             	mov    %rsp,%rbp
  804161:	48 83 ec 40          	sub    $0x40,%rsp
  804165:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804169:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80416d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804171:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804175:	48 89 c7             	mov    %rax,%rdi
  804178:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  80417f:	00 00 00 
  804182:	ff d0                	callq  *%rax
  804184:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804188:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80418c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804190:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804197:	00 
  804198:	e9 90 00 00 00       	jmpq   80422d <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80419d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041a2:	74 09                	je     8041ad <devpipe_read+0x50>
				return i;
  8041a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a8:	e9 8e 00 00 00       	jmpq   80423b <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8041ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041b5:	48 89 d6             	mov    %rdx,%rsi
  8041b8:	48 89 c7             	mov    %rax,%rdi
  8041bb:	48 b8 2b 40 80 00 00 	movabs $0x80402b,%rax
  8041c2:	00 00 00 
  8041c5:	ff d0                	callq  *%rax
  8041c7:	85 c0                	test   %eax,%eax
  8041c9:	74 07                	je     8041d2 <devpipe_read+0x75>
				return 0;
  8041cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d0:	eb 69                	jmp    80423b <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041d2:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8041d9:	00 00 00 
  8041dc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e2:	8b 10                	mov    (%rax),%edx
  8041e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e8:	8b 40 04             	mov    0x4(%rax),%eax
  8041eb:	39 c2                	cmp    %eax,%edx
  8041ed:	74 ae                	je     80419d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041f7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ff:	8b 00                	mov    (%rax),%eax
  804201:	99                   	cltd   
  804202:	c1 ea 1b             	shr    $0x1b,%edx
  804205:	01 d0                	add    %edx,%eax
  804207:	83 e0 1f             	and    $0x1f,%eax
  80420a:	29 d0                	sub    %edx,%eax
  80420c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804210:	48 98                	cltq   
  804212:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804217:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80421d:	8b 00                	mov    (%rax),%eax
  80421f:	8d 50 01             	lea    0x1(%rax),%edx
  804222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804226:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804228:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80422d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804231:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804235:	72 a7                	jb     8041de <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80423b:	c9                   	leaveq 
  80423c:	c3                   	retq   

000000000080423d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80423d:	55                   	push   %rbp
  80423e:	48 89 e5             	mov    %rsp,%rbp
  804241:	48 83 ec 40          	sub    $0x40,%rsp
  804245:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804249:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80424d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804251:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804255:	48 89 c7             	mov    %rax,%rdi
  804258:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
  804264:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804268:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80426c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804270:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804277:	00 
  804278:	e9 8f 00 00 00       	jmpq   80430c <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80427d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804285:	48 89 d6             	mov    %rdx,%rsi
  804288:	48 89 c7             	mov    %rax,%rdi
  80428b:	48 b8 2b 40 80 00 00 	movabs $0x80402b,%rax
  804292:	00 00 00 
  804295:	ff d0                	callq  *%rax
  804297:	85 c0                	test   %eax,%eax
  804299:	74 07                	je     8042a2 <devpipe_write+0x65>
				return 0;
  80429b:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a0:	eb 78                	jmp    80431a <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8042a2:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8042a9:	00 00 00 
  8042ac:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b2:	8b 40 04             	mov    0x4(%rax),%eax
  8042b5:	48 63 d0             	movslq %eax,%rdx
  8042b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042bc:	8b 00                	mov    (%rax),%eax
  8042be:	48 98                	cltq   
  8042c0:	48 83 c0 20          	add    $0x20,%rax
  8042c4:	48 39 c2             	cmp    %rax,%rdx
  8042c7:	73 b4                	jae    80427d <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042cd:	8b 40 04             	mov    0x4(%rax),%eax
  8042d0:	99                   	cltd   
  8042d1:	c1 ea 1b             	shr    $0x1b,%edx
  8042d4:	01 d0                	add    %edx,%eax
  8042d6:	83 e0 1f             	and    $0x1f,%eax
  8042d9:	29 d0                	sub    %edx,%eax
  8042db:	89 c6                	mov    %eax,%esi
  8042dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e5:	48 01 d0             	add    %rdx,%rax
  8042e8:	0f b6 08             	movzbl (%rax),%ecx
  8042eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042ef:	48 63 c6             	movslq %esi,%rax
  8042f2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042fa:	8b 40 04             	mov    0x4(%rax),%eax
  8042fd:	8d 50 01             	lea    0x1(%rax),%edx
  804300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804304:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804307:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80430c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804310:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804314:	72 98                	jb     8042ae <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80431a:	c9                   	leaveq 
  80431b:	c3                   	retq   

000000000080431c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80431c:	55                   	push   %rbp
  80431d:	48 89 e5             	mov    %rsp,%rbp
  804320:	48 83 ec 20          	sub    $0x20,%rsp
  804324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80432c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804330:	48 89 c7             	mov    %rax,%rdi
  804333:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  80433a:	00 00 00 
  80433d:	ff d0                	callq  *%rax
  80433f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804343:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804347:	48 be a8 53 80 00 00 	movabs $0x8053a8,%rsi
  80434e:	00 00 00 
  804351:	48 89 c7             	mov    %rax,%rdi
  804354:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  80435b:	00 00 00 
  80435e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804364:	8b 50 04             	mov    0x4(%rax),%edx
  804367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80436b:	8b 00                	mov    (%rax),%eax
  80436d:	29 c2                	sub    %eax,%edx
  80436f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804373:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804379:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80437d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804384:	00 00 00 
	stat->st_dev = &devpipe;
  804387:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80438b:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804392:	00 00 00 
  804395:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80439c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043a1:	c9                   	leaveq 
  8043a2:	c3                   	retq   

00000000008043a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8043a3:	55                   	push   %rbp
  8043a4:	48 89 e5             	mov    %rsp,%rbp
  8043a7:	48 83 ec 10          	sub    $0x10,%rsp
  8043ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8043af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b3:	48 89 c6             	mov    %rax,%rsi
  8043b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8043bb:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8043c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043cb:	48 89 c7             	mov    %rax,%rdi
  8043ce:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  8043d5:	00 00 00 
  8043d8:	ff d0                	callq  *%rax
  8043da:	48 89 c6             	mov    %rax,%rsi
  8043dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e2:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8043e9:	00 00 00 
  8043ec:	ff d0                	callq  *%rax
}
  8043ee:	c9                   	leaveq 
  8043ef:	c3                   	retq   

00000000008043f0 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8043f0:	55                   	push   %rbp
  8043f1:	48 89 e5             	mov    %rsp,%rbp
  8043f4:	48 83 ec 20          	sub    $0x20,%rsp
  8043f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8043fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043ff:	75 35                	jne    804436 <wait+0x46>
  804401:	48 b9 af 53 80 00 00 	movabs $0x8053af,%rcx
  804408:	00 00 00 
  80440b:	48 ba ba 53 80 00 00 	movabs $0x8053ba,%rdx
  804412:	00 00 00 
  804415:	be 0a 00 00 00       	mov    $0xa,%esi
  80441a:	48 bf cf 53 80 00 00 	movabs $0x8053cf,%rdi
  804421:	00 00 00 
  804424:	b8 00 00 00 00       	mov    $0x0,%eax
  804429:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  804430:	00 00 00 
  804433:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804436:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804439:	25 ff 03 00 00       	and    $0x3ff,%eax
  80443e:	48 98                	cltq   
  804440:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804447:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80444e:	00 00 00 
  804451:	48 01 d0             	add    %rdx,%rax
  804454:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804458:	eb 0c                	jmp    804466 <wait+0x76>
		sys_yield();
  80445a:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  804461:	00 00 00 
  804464:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80446a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804470:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804473:	75 0e                	jne    804483 <wait+0x93>
  804475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804479:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80447f:	85 c0                	test   %eax,%eax
  804481:	75 d7                	jne    80445a <wait+0x6a>
		sys_yield();
}
  804483:	90                   	nop
  804484:	c9                   	leaveq 
  804485:	c3                   	retq   

0000000000804486 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804486:	55                   	push   %rbp
  804487:	48 89 e5             	mov    %rsp,%rbp
  80448a:	48 83 ec 20          	sub    $0x20,%rsp
  80448e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804491:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804494:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804497:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80449b:	be 01 00 00 00       	mov    $0x1,%esi
  8044a0:	48 89 c7             	mov    %rax,%rdi
  8044a3:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  8044aa:	00 00 00 
  8044ad:	ff d0                	callq  *%rax
}
  8044af:	90                   	nop
  8044b0:	c9                   	leaveq 
  8044b1:	c3                   	retq   

00000000008044b2 <getchar>:

int
getchar(void)
{
  8044b2:	55                   	push   %rbp
  8044b3:	48 89 e5             	mov    %rsp,%rbp
  8044b6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8044ba:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8044be:	ba 01 00 00 00       	mov    $0x1,%edx
  8044c3:	48 89 c6             	mov    %rax,%rsi
  8044c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8044cb:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  8044d2:	00 00 00 
  8044d5:	ff d0                	callq  *%rax
  8044d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8044da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044de:	79 05                	jns    8044e5 <getchar+0x33>
		return r;
  8044e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e3:	eb 14                	jmp    8044f9 <getchar+0x47>
	if (r < 1)
  8044e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e9:	7f 07                	jg     8044f2 <getchar+0x40>
		return -E_EOF;
  8044eb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8044f0:	eb 07                	jmp    8044f9 <getchar+0x47>
	return c;
  8044f2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8044f6:	0f b6 c0             	movzbl %al,%eax

}
  8044f9:	c9                   	leaveq 
  8044fa:	c3                   	retq   

00000000008044fb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8044fb:	55                   	push   %rbp
  8044fc:	48 89 e5             	mov    %rsp,%rbp
  8044ff:	48 83 ec 20          	sub    $0x20,%rsp
  804503:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804506:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80450a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80450d:	48 89 d6             	mov    %rdx,%rsi
  804510:	89 c7                	mov    %eax,%edi
  804512:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  804519:	00 00 00 
  80451c:	ff d0                	callq  *%rax
  80451e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804521:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804525:	79 05                	jns    80452c <iscons+0x31>
		return r;
  804527:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80452a:	eb 1a                	jmp    804546 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80452c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804530:	8b 10                	mov    (%rax),%edx
  804532:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804539:	00 00 00 
  80453c:	8b 00                	mov    (%rax),%eax
  80453e:	39 c2                	cmp    %eax,%edx
  804540:	0f 94 c0             	sete   %al
  804543:	0f b6 c0             	movzbl %al,%eax
}
  804546:	c9                   	leaveq 
  804547:	c3                   	retq   

0000000000804548 <opencons>:

int
opencons(void)
{
  804548:	55                   	push   %rbp
  804549:	48 89 e5             	mov    %rsp,%rbp
  80454c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804550:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804554:	48 89 c7             	mov    %rax,%rdi
  804557:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  80455e:	00 00 00 
  804561:	ff d0                	callq  *%rax
  804563:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456a:	79 05                	jns    804571 <opencons+0x29>
		return r;
  80456c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80456f:	eb 5b                	jmp    8045cc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804575:	ba 07 04 00 00       	mov    $0x407,%edx
  80457a:	48 89 c6             	mov    %rax,%rsi
  80457d:	bf 00 00 00 00       	mov    $0x0,%edi
  804582:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  804589:	00 00 00 
  80458c:	ff d0                	callq  *%rax
  80458e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804595:	79 05                	jns    80459c <opencons+0x54>
		return r;
  804597:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80459a:	eb 30                	jmp    8045cc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80459c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045a0:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8045a7:	00 00 00 
  8045aa:	8b 12                	mov    (%rdx),%edx
  8045ac:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8045ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8045b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045bd:	48 89 c7             	mov    %rax,%rdi
  8045c0:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8045c7:	00 00 00 
  8045ca:	ff d0                	callq  *%rax
}
  8045cc:	c9                   	leaveq 
  8045cd:	c3                   	retq   

00000000008045ce <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045ce:	55                   	push   %rbp
  8045cf:	48 89 e5             	mov    %rsp,%rbp
  8045d2:	48 83 ec 30          	sub    $0x30,%rsp
  8045d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045e2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045e7:	75 13                	jne    8045fc <devcons_read+0x2e>
		return 0;
  8045e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ee:	eb 49                	jmp    804639 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8045f0:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8045f7:	00 00 00 
  8045fa:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8045fc:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  804603:	00 00 00 
  804606:	ff d0                	callq  *%rax
  804608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80460b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80460f:	74 df                	je     8045f0 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804611:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804615:	79 05                	jns    80461c <devcons_read+0x4e>
		return c;
  804617:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80461a:	eb 1d                	jmp    804639 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80461c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804620:	75 07                	jne    804629 <devcons_read+0x5b>
		return 0;
  804622:	b8 00 00 00 00       	mov    $0x0,%eax
  804627:	eb 10                	jmp    804639 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462c:	89 c2                	mov    %eax,%edx
  80462e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804632:	88 10                	mov    %dl,(%rax)
	return 1;
  804634:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804639:	c9                   	leaveq 
  80463a:	c3                   	retq   

000000000080463b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80463b:	55                   	push   %rbp
  80463c:	48 89 e5             	mov    %rsp,%rbp
  80463f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804646:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80464d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804654:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80465b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804662:	eb 76                	jmp    8046da <devcons_write+0x9f>
		m = n - tot;
  804664:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80466b:	89 c2                	mov    %eax,%edx
  80466d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804670:	29 c2                	sub    %eax,%edx
  804672:	89 d0                	mov    %edx,%eax
  804674:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804677:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80467a:	83 f8 7f             	cmp    $0x7f,%eax
  80467d:	76 07                	jbe    804686 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80467f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804686:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804689:	48 63 d0             	movslq %eax,%rdx
  80468c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468f:	48 63 c8             	movslq %eax,%rcx
  804692:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804699:	48 01 c1             	add    %rax,%rcx
  80469c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046a3:	48 89 ce             	mov    %rcx,%rsi
  8046a6:	48 89 c7             	mov    %rax,%rdi
  8046a9:	48 b8 d3 14 80 00 00 	movabs $0x8014d3,%rax
  8046b0:	00 00 00 
  8046b3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8046b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046b8:	48 63 d0             	movslq %eax,%rdx
  8046bb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046c2:	48 89 d6             	mov    %rdx,%rsi
  8046c5:	48 89 c7             	mov    %rax,%rdi
  8046c8:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  8046cf:	00 00 00 
  8046d2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046d7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8046da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046dd:	48 98                	cltq   
  8046df:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046e6:	0f 82 78 ff ff ff    	jb     804664 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8046ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046ef:	c9                   	leaveq 
  8046f0:	c3                   	retq   

00000000008046f1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8046f1:	55                   	push   %rbp
  8046f2:	48 89 e5             	mov    %rsp,%rbp
  8046f5:	48 83 ec 08          	sub    $0x8,%rsp
  8046f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8046fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804702:	c9                   	leaveq 
  804703:	c3                   	retq   

0000000000804704 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804704:	55                   	push   %rbp
  804705:	48 89 e5             	mov    %rsp,%rbp
  804708:	48 83 ec 10          	sub    $0x10,%rsp
  80470c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804710:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804714:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804718:	48 be df 53 80 00 00 	movabs $0x8053df,%rsi
  80471f:	00 00 00 
  804722:	48 89 c7             	mov    %rax,%rdi
  804725:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  80472c:	00 00 00 
  80472f:	ff d0                	callq  *%rax
	return 0;
  804731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804736:	c9                   	leaveq 
  804737:	c3                   	retq   

0000000000804738 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804738:	55                   	push   %rbp
  804739:	48 89 e5             	mov    %rsp,%rbp
  80473c:	48 83 ec 20          	sub    $0x20,%rsp
  804740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804744:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80474b:	00 00 00 
  80474e:	48 8b 00             	mov    (%rax),%rax
  804751:	48 85 c0             	test   %rax,%rax
  804754:	75 6f                	jne    8047c5 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804756:	ba 07 00 00 00       	mov    $0x7,%edx
  80475b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804760:	bf 00 00 00 00       	mov    $0x0,%edi
  804765:	48 b8 e4 1a 80 00 00 	movabs $0x801ae4,%rax
  80476c:	00 00 00 
  80476f:	ff d0                	callq  *%rax
  804771:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804774:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804778:	79 30                	jns    8047aa <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  80477a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80477d:	89 c1                	mov    %eax,%ecx
  80477f:	48 ba e8 53 80 00 00 	movabs $0x8053e8,%rdx
  804786:	00 00 00 
  804789:	be 22 00 00 00       	mov    $0x22,%esi
  80478e:	48 bf 07 54 80 00 00 	movabs $0x805407,%rdi
  804795:	00 00 00 
  804798:	b8 00 00 00 00       	mov    $0x0,%eax
  80479d:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8047a4:	00 00 00 
  8047a7:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8047aa:	48 be d9 47 80 00 00 	movabs $0x8047d9,%rsi
  8047b1:	00 00 00 
  8047b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8047b9:	48 b8 7b 1c 80 00 00 	movabs $0x801c7b,%rax
  8047c0:	00 00 00 
  8047c3:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8047c5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047cc:	00 00 00 
  8047cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047d3:	48 89 10             	mov    %rdx,(%rax)
}
  8047d6:	90                   	nop
  8047d7:	c9                   	leaveq 
  8047d8:	c3                   	retq   

00000000008047d9 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8047d9:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8047dc:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8047e3:	00 00 00 
call *%rax
  8047e6:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8047e8:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8047ef:	00 08 
    movq 152(%rsp), %rax
  8047f1:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8047f8:	00 
    movq 136(%rsp), %rbx
  8047f9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804800:	00 
movq %rbx, (%rax)
  804801:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804804:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804808:	4c 8b 3c 24          	mov    (%rsp),%r15
  80480c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804811:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804816:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80481b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804820:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804825:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80482a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80482f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804834:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804839:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80483e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804843:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804848:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80484d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804852:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804856:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  80485a:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80485b:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804860:	c3                   	retq   

0000000000804861 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804861:	55                   	push   %rbp
  804862:	48 89 e5             	mov    %rsp,%rbp
  804865:	48 83 ec 30          	sub    $0x30,%rsp
  804869:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80486d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804871:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804875:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80487a:	75 0e                	jne    80488a <ipc_recv+0x29>
		pg = (void*) UTOP;
  80487c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804883:	00 00 00 
  804886:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80488a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80488e:	48 89 c7             	mov    %rax,%rdi
  804891:	48 b8 1e 1d 80 00 00 	movabs $0x801d1e,%rax
  804898:	00 00 00 
  80489b:	ff d0                	callq  *%rax
  80489d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048a4:	79 27                	jns    8048cd <ipc_recv+0x6c>
		if (from_env_store)
  8048a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8048ab:	74 0a                	je     8048b7 <ipc_recv+0x56>
			*from_env_store = 0;
  8048ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8048b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048bc:	74 0a                	je     8048c8 <ipc_recv+0x67>
			*perm_store = 0;
  8048be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8048c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048cb:	eb 53                	jmp    804920 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8048cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8048d2:	74 19                	je     8048ed <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8048d4:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8048db:	00 00 00 
  8048de:	48 8b 00             	mov    (%rax),%rax
  8048e1:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8048e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048eb:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8048ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048f2:	74 19                	je     80490d <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8048f4:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8048fb:	00 00 00 
  8048fe:	48 8b 00             	mov    (%rax),%rax
  804901:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804907:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80490b:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80490d:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804914:	00 00 00 
  804917:	48 8b 00             	mov    (%rax),%rax
  80491a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804920:	c9                   	leaveq 
  804921:	c3                   	retq   

0000000000804922 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804922:	55                   	push   %rbp
  804923:	48 89 e5             	mov    %rsp,%rbp
  804926:	48 83 ec 30          	sub    $0x30,%rsp
  80492a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80492d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804930:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804934:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804937:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80493c:	75 1c                	jne    80495a <ipc_send+0x38>
		pg = (void*) UTOP;
  80493e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804945:	00 00 00 
  804948:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80494c:	eb 0c                	jmp    80495a <ipc_send+0x38>
		sys_yield();
  80494e:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  804955:	00 00 00 
  804958:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80495a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80495d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804960:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804964:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804967:	89 c7                	mov    %eax,%edi
  804969:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  804970:	00 00 00 
  804973:	ff d0                	callq  *%rax
  804975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804978:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80497c:	74 d0                	je     80494e <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80497e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804982:	79 30                	jns    8049b4 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804987:	89 c1                	mov    %eax,%ecx
  804989:	48 ba 15 54 80 00 00 	movabs $0x805415,%rdx
  804990:	00 00 00 
  804993:	be 47 00 00 00       	mov    $0x47,%esi
  804998:	48 bf 2b 54 80 00 00 	movabs $0x80542b,%rdi
  80499f:	00 00 00 
  8049a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8049a7:	49 b8 e4 03 80 00 00 	movabs $0x8003e4,%r8
  8049ae:	00 00 00 
  8049b1:	41 ff d0             	callq  *%r8

}
  8049b4:	90                   	nop
  8049b5:	c9                   	leaveq 
  8049b6:	c3                   	retq   

00000000008049b7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8049b7:	55                   	push   %rbp
  8049b8:	48 89 e5             	mov    %rsp,%rbp
  8049bb:	48 83 ec 18          	sub    $0x18,%rsp
  8049bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8049c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8049c9:	eb 4d                	jmp    804a18 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8049cb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8049d2:	00 00 00 
  8049d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049d8:	48 98                	cltq   
  8049da:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8049e1:	48 01 d0             	add    %rdx,%rax
  8049e4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8049ea:	8b 00                	mov    (%rax),%eax
  8049ec:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8049ef:	75 23                	jne    804a14 <ipc_find_env+0x5d>
			return envs[i].env_id;
  8049f1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8049f8:	00 00 00 
  8049fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049fe:	48 98                	cltq   
  804a00:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a07:	48 01 d0             	add    %rdx,%rax
  804a0a:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804a10:	8b 00                	mov    (%rax),%eax
  804a12:	eb 12                	jmp    804a26 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804a14:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a18:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a1f:	7e aa                	jle    8049cb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a26:	c9                   	leaveq 
  804a27:	c3                   	retq   

0000000000804a28 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804a28:	55                   	push   %rbp
  804a29:	48 89 e5             	mov    %rsp,%rbp
  804a2c:	48 83 ec 18          	sub    $0x18,%rsp
  804a30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a38:	48 c1 e8 15          	shr    $0x15,%rax
  804a3c:	48 89 c2             	mov    %rax,%rdx
  804a3f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804a46:	01 00 00 
  804a49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a4d:	83 e0 01             	and    $0x1,%eax
  804a50:	48 85 c0             	test   %rax,%rax
  804a53:	75 07                	jne    804a5c <pageref+0x34>
		return 0;
  804a55:	b8 00 00 00 00       	mov    $0x0,%eax
  804a5a:	eb 56                	jmp    804ab2 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a60:	48 c1 e8 0c          	shr    $0xc,%rax
  804a64:	48 89 c2             	mov    %rax,%rdx
  804a67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804a6e:	01 00 00 
  804a71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804a79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a7d:	83 e0 01             	and    $0x1,%eax
  804a80:	48 85 c0             	test   %rax,%rax
  804a83:	75 07                	jne    804a8c <pageref+0x64>
		return 0;
  804a85:	b8 00 00 00 00       	mov    $0x0,%eax
  804a8a:	eb 26                	jmp    804ab2 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804a8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a90:	48 c1 e8 0c          	shr    $0xc,%rax
  804a94:	48 89 c2             	mov    %rax,%rdx
  804a97:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a9e:	00 00 00 
  804aa1:	48 c1 e2 04          	shl    $0x4,%rdx
  804aa5:	48 01 d0             	add    %rdx,%rax
  804aa8:	48 83 c0 08          	add    $0x8,%rax
  804aac:	0f b7 00             	movzwl (%rax),%eax
  804aaf:	0f b7 c0             	movzwl %ax,%eax
}
  804ab2:	c9                   	leaveq 
  804ab3:	c3                   	retq   
