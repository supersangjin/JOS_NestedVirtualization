
obj/user/init:     file format elf64-x86-64


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
  80003c:	e8 6a 06 00 00       	callq  8006ab <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf a0 4f 80 00 00 	movabs $0x804fa0,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf b0 4f 80 00 00 	movabs $0x804fb0,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 8d 09 80 00 00 	movabs $0x80098d,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf e9 4f 80 00 00 	movabs $0x804fe9,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 90 80 00 00 	movabs $0x809020,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf 00 50 80 00 00 	movabs $0x805000,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 2f 50 80 00 00 	movabs $0x80502f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be 45 50 80 00 00 	movabs $0x805045,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 60 15 80 00 00 	movabs $0x801560,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be 51 50 80 00 00 	movabs $0x805051,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 60 15 80 00 00 	movabs $0x801560,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 60 15 80 00 00 	movabs $0x801560,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be 54 50 80 00 00 	movabs $0x805054,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 60 15 80 00 00 	movabs $0x801560,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf 56 50 80 00 00 	movabs $0x805056,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx


	cprintf("init: running sh\n");
  800262:	48 bf 5a 50 80 00 00 	movabs $0x80505a,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba 6c 50 80 00 00 	movabs $0x80506c,%rdx
  8002af:	00 00 00 
  8002b2:	be 39 00 00 00       	mov    $0x39,%esi
  8002b7:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba 85 50 80 00 00 	movabs $0x805085,%rdx
  8002e5:	00 00 00 
  8002e8:	be 3b 00 00 00       	mov    $0x3b,%esi
  8002ed:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 bd 26 80 00 00 	movabs $0x8026bd,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 9f 50 80 00 00 	movabs $0x80509f,%rdx
  800334:	00 00 00 
  800337:	be 3d 00 00 00       	mov    $0x3d,%esi
  80033c:	48 bf 79 50 80 00 00 	movabs $0x805079,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf a7 50 80 00 00 	movabs $0x8050a7,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be ba 50 80 00 00 	movabs $0x8050ba,%rsi
  80037f:	00 00 00 
  800382:	48 bf bd 50 80 00 00 	movabs $0x8050bd,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 d6 36 80 00 00 	movabs $0x8036d6,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 22                	jns    8003c8 <umain+0x33b>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf c5 50 80 00 00 	movabs $0x8050c5,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	eb 2c                	jmp    8003f4 <umain+0x367>
		}
		cprintf("init waiting\n");
  8003c8:	48 bf d9 50 80 00 00 	movabs $0x8050d9,%rdi
  8003cf:	00 00 00 
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  8003de:	00 00 00 
  8003e1:	ff d2                	callq  *%rdx
		wait(r);
  8003e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e6:	89 c7                	mov    %eax,%edi
  8003e8:	48 b8 b3 4c 80 00 00 	movabs $0x804cb3,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax

#ifdef VMM_GUEST
		break;
#endif

	}
  8003f4:	e9 5f ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003f9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003f9:	55                   	push   %rbp
  8003fa:	48 89 e5             	mov    %rsp,%rbp
  8003fd:	48 83 ec 20          	sub    $0x20,%rsp
  800401:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800404:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800407:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80040a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040e:	be 01 00 00 00       	mov    $0x1,%esi
  800413:	48 89 c7             	mov    %rax,%rdi
  800416:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80041d:	00 00 00 
  800420:	ff d0                	callq  *%rax
}
  800422:	90                   	nop
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <getchar>:

int
getchar(void)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800431:	ba 01 00 00 00       	mov    $0x1,%edx
  800436:	48 89 c6             	mov    %rax,%rsi
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800451:	79 05                	jns    800458 <getchar+0x33>
		return r;
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	eb 14                	jmp    80046c <getchar+0x47>
	if (r < 1)
  800458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045c:	7f 07                	jg     800465 <getchar+0x40>
		return -E_EOF;
  80045e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800463:	eb 07                	jmp    80046c <getchar+0x47>
	return c;
  800465:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800469:	0f b6 c0             	movzbl %al,%eax

}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	48 83 ec 20          	sub    $0x20,%rsp
  800476:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800479:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 05                	jns    80049f <iscons+0x31>
		return r;
  80049a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049d:	eb 1a                	jmp    8004b9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a3:	8b 10                	mov    (%rax),%edx
  8004a5:	48 b8 80 87 80 00 00 	movabs $0x808780,%rax
  8004ac:	00 00 00 
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	39 c2                	cmp    %eax,%edx
  8004b3:	0f 94 c0             	sete   %al
  8004b6:	0f b6 c0             	movzbl %al,%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <opencons>:

int
opencons(void)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c7:	48 89 c7             	mov    %rax,%rdi
  8004ca:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
  8004d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dd:	79 05                	jns    8004e4 <opencons+0x29>
		return r;
  8004df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e2:	eb 5b                	jmp    80053f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f5:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
  800501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800508:	79 05                	jns    80050f <opencons+0x54>
		return r;
  80050a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050d:	eb 30                	jmp    80053f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	48 ba 80 87 80 00 00 	movabs $0x808780,%rdx
  80051a:	00 00 00 
  80051d:	8b 12                	mov    (%rdx),%edx
  80051f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800525:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	48 89 c7             	mov    %rax,%rdi
  800533:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	callq  *%rax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 83 ec 30          	sub    $0x30,%rsp
  800549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800551:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800555:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80055a:	75 13                	jne    80056f <devcons_read+0x2e>
		return 0;
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	eb 49                	jmp    8005ac <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800563:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  80056a:	00 00 00 
  80056d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80056f:	48 b8 58 1d 80 00 00 	movabs $0x801d58,%rax
  800576:	00 00 00 
  800579:	ff d0                	callq  *%rax
  80057b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80057e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800582:	74 df                	je     800563 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  800584:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800588:	79 05                	jns    80058f <devcons_read+0x4e>
		return c;
  80058a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058d:	eb 1d                	jmp    8005ac <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80058f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800593:	75 07                	jne    80059c <devcons_read+0x5b>
		return 0;
  800595:	b8 00 00 00 00       	mov    $0x0,%eax
  80059a:	eb 10                	jmp    8005ac <devcons_read+0x6b>
	*(char*)vbuf = c;
  80059c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059f:	89 c2                	mov    %eax,%edx
  8005a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a5:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005b9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005c0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d5:	eb 76                	jmp    80064d <devcons_write+0x9f>
		m = n - tot;
  8005d7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005de:	89 c2                	mov    %eax,%edx
  8005e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e3:	29 c2                	sub    %eax,%edx
  8005e5:	89 d0                	mov    %edx,%eax
  8005e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ed:	83 f8 7f             	cmp    $0x7f,%eax
  8005f0:	76 07                	jbe    8005f9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 63 d0             	movslq %eax,%rdx
  8005ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800602:	48 63 c8             	movslq %eax,%rcx
  800605:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060c:	48 01 c1             	add    %rax,%rcx
  80060f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800616:	48 89 ce             	mov    %rcx,%rsi
  800619:	48 89 c7             	mov    %rax,%rdi
  80061c:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  800623:	00 00 00 
  800626:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 63 d0             	movslq %eax,%rdx
  80062e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800635:	48 89 d6             	mov    %rdx,%rsi
  800638:	48 89 c7             	mov    %rax,%rdi
  80063b:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  800642:	00 00 00 
  800645:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800647:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80064a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800650:	48 98                	cltq   
  800652:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800659:	0f 82 78 ff ff ff    	jb     8005d7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80065f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800662:	c9                   	leaveq 
  800663:	c3                   	retq   

0000000000800664 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 83 ec 08          	sub    $0x8,%rsp
  80066c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800675:	c9                   	leaveq 
  800676:	c3                   	retq   

0000000000800677 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800677:	55                   	push   %rbp
  800678:	48 89 e5             	mov    %rsp,%rbp
  80067b:	48 83 ec 10          	sub    $0x10,%rsp
  80067f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800683:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068b:	48 be ec 50 80 00 00 	movabs $0x8050ec,%rsi
  800692:	00 00 00 
  800695:	48 89 c7             	mov    %rax,%rdi
  800698:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80069f:	00 00 00 
  8006a2:	ff d0                	callq  *%rax
	return 0;
  8006a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006a9:	c9                   	leaveq 
  8006aa:	c3                   	retq   

00000000008006ab <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006ab:	55                   	push   %rbp
  8006ac:	48 89 e5             	mov    %rsp,%rbp
  8006af:	48 83 ec 10          	sub    $0x10,%rsp
  8006b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8006ba:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  8006c1:	00 00 00 
  8006c4:	ff d0                	callq  *%rax
  8006c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006cb:	48 98                	cltq   
  8006cd:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8006d4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006db:	00 00 00 
  8006de:	48 01 c2             	add    %rax,%rdx
  8006e1:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8006e8:	00 00 00 
  8006eb:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006f2:	7e 14                	jle    800708 <libmain+0x5d>
		binaryname = argv[0];
  8006f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f8:	48 8b 10             	mov    (%rax),%rdx
  8006fb:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  800702:	00 00 00 
  800705:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800708:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80070f:	48 89 d6             	mov    %rdx,%rsi
  800712:	89 c7                	mov    %eax,%edi
  800714:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800720:	48 b8 2f 07 80 00 00 	movabs $0x80072f,%rax
  800727:	00 00 00 
  80072a:	ff d0                	callq  *%rax
}
  80072c:	90                   	nop
  80072d:	c9                   	leaveq 
  80072e:	c3                   	retq   

000000000080072f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80072f:	55                   	push   %rbp
  800730:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800733:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  80073a:	00 00 00 
  80073d:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80073f:	bf 00 00 00 00       	mov    $0x0,%edi
  800744:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  80074b:	00 00 00 
  80074e:	ff d0                	callq  *%rax
}
  800750:	90                   	nop
  800751:	5d                   	pop    %rbp
  800752:	c3                   	retq   

0000000000800753 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800753:	55                   	push   %rbp
  800754:	48 89 e5             	mov    %rsp,%rbp
  800757:	53                   	push   %rbx
  800758:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80075f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800766:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80076c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800773:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80077a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800781:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800788:	84 c0                	test   %al,%al
  80078a:	74 23                	je     8007af <_panic+0x5c>
  80078c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800793:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800797:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80079b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80079f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8007a3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007a7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007ab:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007af:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007b6:	00 00 00 
  8007b9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007c0:	00 00 00 
  8007c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007ce:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007dc:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8007e3:	00 00 00 
  8007e6:	48 8b 18             	mov    (%rax),%rbx
  8007e9:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  8007f0:	00 00 00 
  8007f3:	ff d0                	callq  *%rax
  8007f5:	89 c6                	mov    %eax,%esi
  8007f7:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8007fd:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800804:	41 89 d0             	mov    %edx,%r8d
  800807:	48 89 c1             	mov    %rax,%rcx
  80080a:	48 89 da             	mov    %rbx,%rdx
  80080d:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  800814:	00 00 00 
  800817:	b8 00 00 00 00       	mov    $0x0,%eax
  80081c:	49 b9 8d 09 80 00 00 	movabs $0x80098d,%r9
  800823:	00 00 00 
  800826:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800829:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800830:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800837:	48 89 d6             	mov    %rdx,%rsi
  80083a:	48 89 c7             	mov    %rax,%rdi
  80083d:	48 b8 e1 08 80 00 00 	movabs $0x8008e1,%rax
  800844:	00 00 00 
  800847:	ff d0                	callq  *%rax
	cprintf("\n");
  800849:	48 bf 23 51 80 00 00 	movabs $0x805123,%rdi
  800850:	00 00 00 
  800853:	b8 00 00 00 00       	mov    $0x0,%eax
  800858:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  80085f:	00 00 00 
  800862:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800864:	cc                   	int3   
  800865:	eb fd                	jmp    800864 <_panic+0x111>

0000000000800867 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800867:	55                   	push   %rbp
  800868:	48 89 e5             	mov    %rsp,%rbp
  80086b:	48 83 ec 10          	sub    $0x10,%rsp
  80086f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800872:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	8d 48 01             	lea    0x1(%rax),%ecx
  80087f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800883:	89 0a                	mov    %ecx,(%rdx)
  800885:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800888:	89 d1                	mov    %edx,%ecx
  80088a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80088e:	48 98                	cltq   
  800890:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800898:	8b 00                	mov    (%rax),%eax
  80089a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80089f:	75 2c                	jne    8008cd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8008a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a5:	8b 00                	mov    (%rax),%eax
  8008a7:	48 98                	cltq   
  8008a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ad:	48 83 c2 08          	add    $0x8,%rdx
  8008b1:	48 89 c6             	mov    %rax,%rsi
  8008b4:	48 89 d7             	mov    %rdx,%rdi
  8008b7:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  8008be:	00 00 00 
  8008c1:	ff d0                	callq  *%rax
        b->idx = 0;
  8008c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d1:	8b 40 04             	mov    0x4(%rax),%eax
  8008d4:	8d 50 01             	lea    0x1(%rax),%edx
  8008d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008db:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008de:	90                   	nop
  8008df:	c9                   	leaveq 
  8008e0:	c3                   	retq   

00000000008008e1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008e1:	55                   	push   %rbp
  8008e2:	48 89 e5             	mov    %rsp,%rbp
  8008e5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008ec:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008f3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8008fa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800901:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800908:	48 8b 0a             	mov    (%rdx),%rcx
  80090b:	48 89 08             	mov    %rcx,(%rax)
  80090e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800912:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800916:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80091e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800925:	00 00 00 
    b.cnt = 0;
  800928:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80092f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800932:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800939:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800940:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800947:	48 89 c6             	mov    %rax,%rsi
  80094a:	48 bf 67 08 80 00 00 	movabs $0x800867,%rdi
  800951:	00 00 00 
  800954:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  80095b:	00 00 00 
  80095e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800960:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800966:	48 98                	cltq   
  800968:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80096f:	48 83 c2 08          	add    $0x8,%rdx
  800973:	48 89 c6             	mov    %rax,%rsi
  800976:	48 89 d7             	mov    %rdx,%rdi
  800979:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  800980:	00 00 00 
  800983:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800985:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80098b:	c9                   	leaveq 
  80098c:	c3                   	retq   

000000000080098d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80098d:	55                   	push   %rbp
  80098e:	48 89 e5             	mov    %rsp,%rbp
  800991:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800998:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80099f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8009a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 20                	je     8009e6 <cprintf+0x59>
  8009c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009e6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009ed:	00 00 00 
  8009f0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009f7:	00 00 00 
  8009fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a05:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a0c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a13:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a1a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a21:	48 8b 0a             	mov    (%rdx),%rcx
  800a24:	48 89 08             	mov    %rcx,(%rax)
  800a27:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a2b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a33:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a37:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a3e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a45:	48 89 d6             	mov    %rdx,%rsi
  800a48:	48 89 c7             	mov    %rax,%rdi
  800a4b:	48 b8 e1 08 80 00 00 	movabs $0x8008e1,%rax
  800a52:	00 00 00 
  800a55:	ff d0                	callq  *%rax
  800a57:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a5d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a63:	c9                   	leaveq 
  800a64:	c3                   	retq   

0000000000800a65 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a65:	55                   	push   %rbp
  800a66:	48 89 e5             	mov    %rsp,%rbp
  800a69:	48 83 ec 30          	sub    $0x30,%rsp
  800a6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800a75:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800a79:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800a7c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800a80:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a84:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800a87:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800a8b:	77 54                	ja     800ae1 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800a90:	8d 78 ff             	lea    -0x1(%rax),%edi
  800a93:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9f:	48 f7 f6             	div    %rsi
  800aa2:	49 89 c2             	mov    %rax,%r10
  800aa5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800aa8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800aab:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ab3:	41 89 c9             	mov    %ecx,%r9d
  800ab6:	41 89 f8             	mov    %edi,%r8d
  800ab9:	89 d1                	mov    %edx,%ecx
  800abb:	4c 89 d2             	mov    %r10,%rdx
  800abe:	48 89 c7             	mov    %rax,%rdi
  800ac1:	48 b8 65 0a 80 00 00 	movabs $0x800a65,%rax
  800ac8:	00 00 00 
  800acb:	ff d0                	callq  *%rax
  800acd:	eb 1c                	jmp    800aeb <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800acf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800ad3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ada:	48 89 ce             	mov    %rcx,%rsi
  800add:	89 d7                	mov    %edx,%edi
  800adf:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae1:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800ae5:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800ae9:	7f e4                	jg     800acf <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aeb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	48 f7 f1             	div    %rcx
  800afa:	48 b8 30 53 80 00 00 	movabs $0x805330,%rax
  800b01:	00 00 00 
  800b04:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800b08:	0f be d0             	movsbl %al,%edx
  800b0b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800b0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800b13:	48 89 ce             	mov    %rcx,%rsi
  800b16:	89 d7                	mov    %edx,%edi
  800b18:	ff d0                	callq  *%rax
}
  800b1a:	90                   	nop
  800b1b:	c9                   	leaveq 
  800b1c:	c3                   	retq   

0000000000800b1d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1d:	55                   	push   %rbp
  800b1e:	48 89 e5             	mov    %rsp,%rbp
  800b21:	48 83 ec 20          	sub    $0x20,%rsp
  800b25:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b29:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b2c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b30:	7e 4f                	jle    800b81 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800b32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b36:	8b 00                	mov    (%rax),%eax
  800b38:	83 f8 30             	cmp    $0x30,%eax
  800b3b:	73 24                	jae    800b61 <getuint+0x44>
  800b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b41:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b49:	8b 00                	mov    (%rax),%eax
  800b4b:	89 c0                	mov    %eax,%eax
  800b4d:	48 01 d0             	add    %rdx,%rax
  800b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b54:	8b 12                	mov    (%rdx),%edx
  800b56:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5d:	89 0a                	mov    %ecx,(%rdx)
  800b5f:	eb 14                	jmp    800b75 <getuint+0x58>
  800b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b65:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b69:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b71:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b75:	48 8b 00             	mov    (%rax),%rax
  800b78:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7c:	e9 9d 00 00 00       	jmpq   800c1e <getuint+0x101>
	else if (lflag)
  800b81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b85:	74 4c                	je     800bd3 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800b87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8b:	8b 00                	mov    (%rax),%eax
  800b8d:	83 f8 30             	cmp    $0x30,%eax
  800b90:	73 24                	jae    800bb6 <getuint+0x99>
  800b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b96:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9e:	8b 00                	mov    (%rax),%eax
  800ba0:	89 c0                	mov    %eax,%eax
  800ba2:	48 01 d0             	add    %rdx,%rax
  800ba5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba9:	8b 12                	mov    (%rdx),%edx
  800bab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb2:	89 0a                	mov    %ecx,(%rdx)
  800bb4:	eb 14                	jmp    800bca <getuint+0xad>
  800bb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bba:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bbe:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800bc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bca:	48 8b 00             	mov    (%rax),%rax
  800bcd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bd1:	eb 4b                	jmp    800c1e <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd7:	8b 00                	mov    (%rax),%eax
  800bd9:	83 f8 30             	cmp    $0x30,%eax
  800bdc:	73 24                	jae    800c02 <getuint+0xe5>
  800bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bea:	8b 00                	mov    (%rax),%eax
  800bec:	89 c0                	mov    %eax,%eax
  800bee:	48 01 d0             	add    %rdx,%rax
  800bf1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf5:	8b 12                	mov    (%rdx),%edx
  800bf7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bfa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfe:	89 0a                	mov    %ecx,(%rdx)
  800c00:	eb 14                	jmp    800c16 <getuint+0xf9>
  800c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c06:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c0a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c16:	8b 00                	mov    (%rax),%eax
  800c18:	89 c0                	mov    %eax,%eax
  800c1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c22:	c9                   	leaveq 
  800c23:	c3                   	retq   

0000000000800c24 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c24:	55                   	push   %rbp
  800c25:	48 89 e5             	mov    %rsp,%rbp
  800c28:	48 83 ec 20          	sub    $0x20,%rsp
  800c2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c30:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c33:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c37:	7e 4f                	jle    800c88 <getint+0x64>
		x=va_arg(*ap, long long);
  800c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3d:	8b 00                	mov    (%rax),%eax
  800c3f:	83 f8 30             	cmp    $0x30,%eax
  800c42:	73 24                	jae    800c68 <getint+0x44>
  800c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c50:	8b 00                	mov    (%rax),%eax
  800c52:	89 c0                	mov    %eax,%eax
  800c54:	48 01 d0             	add    %rdx,%rax
  800c57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c5b:	8b 12                	mov    (%rdx),%edx
  800c5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c64:	89 0a                	mov    %ecx,(%rdx)
  800c66:	eb 14                	jmp    800c7c <getint+0x58>
  800c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c70:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c78:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c7c:	48 8b 00             	mov    (%rax),%rax
  800c7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c83:	e9 9d 00 00 00       	jmpq   800d25 <getint+0x101>
	else if (lflag)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c8c:	74 4c                	je     800cda <getint+0xb6>
		x=va_arg(*ap, long);
  800c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c92:	8b 00                	mov    (%rax),%eax
  800c94:	83 f8 30             	cmp    $0x30,%eax
  800c97:	73 24                	jae    800cbd <getint+0x99>
  800c99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca5:	8b 00                	mov    (%rax),%eax
  800ca7:	89 c0                	mov    %eax,%eax
  800ca9:	48 01 d0             	add    %rdx,%rax
  800cac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb0:	8b 12                	mov    (%rdx),%edx
  800cb2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb9:	89 0a                	mov    %ecx,(%rdx)
  800cbb:	eb 14                	jmp    800cd1 <getint+0xad>
  800cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800cc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cd1:	48 8b 00             	mov    (%rax),%rax
  800cd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cd8:	eb 4b                	jmp    800d25 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cde:	8b 00                	mov    (%rax),%eax
  800ce0:	83 f8 30             	cmp    $0x30,%eax
  800ce3:	73 24                	jae    800d09 <getint+0xe5>
  800ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf1:	8b 00                	mov    (%rax),%eax
  800cf3:	89 c0                	mov    %eax,%eax
  800cf5:	48 01 d0             	add    %rdx,%rax
  800cf8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfc:	8b 12                	mov    (%rdx),%edx
  800cfe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d05:	89 0a                	mov    %ecx,(%rdx)
  800d07:	eb 14                	jmp    800d1d <getint+0xf9>
  800d09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d11:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d15:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d19:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	48 98                	cltq   
  800d21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d29:	c9                   	leaveq 
  800d2a:	c3                   	retq   

0000000000800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %rbp
  800d2c:	48 89 e5             	mov    %rsp,%rbp
  800d2f:	41 54                	push   %r12
  800d31:	53                   	push   %rbx
  800d32:	48 83 ec 60          	sub    $0x60,%rsp
  800d36:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d3a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d3e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d42:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d4a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d4e:	48 8b 0a             	mov    (%rdx),%rcx
  800d51:	48 89 08             	mov    %rcx,(%rax)
  800d54:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d58:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d5c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d60:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d64:	eb 17                	jmp    800d7d <vprintfmt+0x52>
			if (ch == '\0')
  800d66:	85 db                	test   %ebx,%ebx
  800d68:	0f 84 b9 04 00 00    	je     801227 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800d6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d76:	48 89 d6             	mov    %rdx,%rsi
  800d79:	89 df                	mov    %ebx,%edi
  800d7b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d81:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d85:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d89:	0f b6 00             	movzbl (%rax),%eax
  800d8c:	0f b6 d8             	movzbl %al,%ebx
  800d8f:	83 fb 25             	cmp    $0x25,%ebx
  800d92:	75 d2                	jne    800d66 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d94:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800d98:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800d9f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800da6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dad:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800db8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dbc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800dc0:	0f b6 00             	movzbl (%rax),%eax
  800dc3:	0f b6 d8             	movzbl %al,%ebx
  800dc6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800dc9:	83 f8 55             	cmp    $0x55,%eax
  800dcc:	0f 87 22 04 00 00    	ja     8011f4 <vprintfmt+0x4c9>
  800dd2:	89 c0                	mov    %eax,%eax
  800dd4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ddb:	00 
  800ddc:	48 b8 58 53 80 00 00 	movabs $0x805358,%rax
  800de3:	00 00 00 
  800de6:	48 01 d0             	add    %rdx,%rax
  800de9:	48 8b 00             	mov    (%rax),%rax
  800dec:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800dee:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800df2:	eb c0                	jmp    800db4 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800df4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800df8:	eb ba                	jmp    800db4 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dfa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e01:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e04:	89 d0                	mov    %edx,%eax
  800e06:	c1 e0 02             	shl    $0x2,%eax
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	01 c0                	add    %eax,%eax
  800e0d:	01 d8                	add    %ebx,%eax
  800e0f:	83 e8 30             	sub    $0x30,%eax
  800e12:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e19:	0f b6 00             	movzbl (%rax),%eax
  800e1c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e1f:	83 fb 2f             	cmp    $0x2f,%ebx
  800e22:	7e 60                	jle    800e84 <vprintfmt+0x159>
  800e24:	83 fb 39             	cmp    $0x39,%ebx
  800e27:	7f 5b                	jg     800e84 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e29:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e2e:	eb d1                	jmp    800e01 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800e30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e33:	83 f8 30             	cmp    $0x30,%eax
  800e36:	73 17                	jae    800e4f <vprintfmt+0x124>
  800e38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e3c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e3f:	89 d2                	mov    %edx,%edx
  800e41:	48 01 d0             	add    %rdx,%rax
  800e44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e47:	83 c2 08             	add    $0x8,%edx
  800e4a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e4d:	eb 0c                	jmp    800e5b <vprintfmt+0x130>
  800e4f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e53:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5b:	8b 00                	mov    (%rax),%eax
  800e5d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e60:	eb 23                	jmp    800e85 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800e62:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e66:	0f 89 48 ff ff ff    	jns    800db4 <vprintfmt+0x89>
				width = 0;
  800e6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e73:	e9 3c ff ff ff       	jmpq   800db4 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e78:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e7f:	e9 30 ff ff ff       	jmpq   800db4 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e84:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e89:	0f 89 25 ff ff ff    	jns    800db4 <vprintfmt+0x89>
				width = precision, precision = -1;
  800e8f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e92:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e95:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e9c:	e9 13 ff ff ff       	jmpq   800db4 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ea5:	e9 0a ff ff ff       	jmpq   800db4 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800eaa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ead:	83 f8 30             	cmp    $0x30,%eax
  800eb0:	73 17                	jae    800ec9 <vprintfmt+0x19e>
  800eb2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eb9:	89 d2                	mov    %edx,%edx
  800ebb:	48 01 d0             	add    %rdx,%rax
  800ebe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ec1:	83 c2 08             	add    $0x8,%edx
  800ec4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ec7:	eb 0c                	jmp    800ed5 <vprintfmt+0x1aa>
  800ec9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ecd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ed1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ed5:	8b 10                	mov    (%rax),%edx
  800ed7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	48 89 ce             	mov    %rcx,%rsi
  800ee2:	89 d7                	mov    %edx,%edi
  800ee4:	ff d0                	callq  *%rax
			break;
  800ee6:	e9 37 03 00 00       	jmpq   801222 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800eeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eee:	83 f8 30             	cmp    $0x30,%eax
  800ef1:	73 17                	jae    800f0a <vprintfmt+0x1df>
  800ef3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800efa:	89 d2                	mov    %edx,%edx
  800efc:	48 01 d0             	add    %rdx,%rax
  800eff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f02:	83 c2 08             	add    $0x8,%edx
  800f05:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f08:	eb 0c                	jmp    800f16 <vprintfmt+0x1eb>
  800f0a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f0e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f16:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f18:	85 db                	test   %ebx,%ebx
  800f1a:	79 02                	jns    800f1e <vprintfmt+0x1f3>
				err = -err;
  800f1c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f1e:	83 fb 15             	cmp    $0x15,%ebx
  800f21:	7f 16                	jg     800f39 <vprintfmt+0x20e>
  800f23:	48 b8 80 52 80 00 00 	movabs $0x805280,%rax
  800f2a:	00 00 00 
  800f2d:	48 63 d3             	movslq %ebx,%rdx
  800f30:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f34:	4d 85 e4             	test   %r12,%r12
  800f37:	75 2e                	jne    800f67 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800f39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f41:	89 d9                	mov    %ebx,%ecx
  800f43:	48 ba 41 53 80 00 00 	movabs $0x805341,%rdx
  800f4a:	00 00 00 
  800f4d:	48 89 c7             	mov    %rax,%rdi
  800f50:	b8 00 00 00 00       	mov    $0x0,%eax
  800f55:	49 b8 31 12 80 00 00 	movabs $0x801231,%r8
  800f5c:	00 00 00 
  800f5f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f62:	e9 bb 02 00 00       	jmpq   801222 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f67:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6f:	4c 89 e1             	mov    %r12,%rcx
  800f72:	48 ba 4a 53 80 00 00 	movabs $0x80534a,%rdx
  800f79:	00 00 00 
  800f7c:	48 89 c7             	mov    %rax,%rdi
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f84:	49 b8 31 12 80 00 00 	movabs $0x801231,%r8
  800f8b:	00 00 00 
  800f8e:	41 ff d0             	callq  *%r8
			break;
  800f91:	e9 8c 02 00 00       	jmpq   801222 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800f96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f99:	83 f8 30             	cmp    $0x30,%eax
  800f9c:	73 17                	jae    800fb5 <vprintfmt+0x28a>
  800f9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fa5:	89 d2                	mov    %edx,%edx
  800fa7:	48 01 d0             	add    %rdx,%rax
  800faa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fad:	83 c2 08             	add    $0x8,%edx
  800fb0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fb3:	eb 0c                	jmp    800fc1 <vprintfmt+0x296>
  800fb5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fb9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fc1:	4c 8b 20             	mov    (%rax),%r12
  800fc4:	4d 85 e4             	test   %r12,%r12
  800fc7:	75 0a                	jne    800fd3 <vprintfmt+0x2a8>
				p = "(null)";
  800fc9:	49 bc 4d 53 80 00 00 	movabs $0x80534d,%r12
  800fd0:	00 00 00 
			if (width > 0 && padc != '-')
  800fd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fd7:	7e 78                	jle    801051 <vprintfmt+0x326>
  800fd9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800fdd:	74 72                	je     801051 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fdf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800fe2:	48 98                	cltq   
  800fe4:	48 89 c6             	mov    %rax,%rsi
  800fe7:	4c 89 e7             	mov    %r12,%rdi
  800fea:	48 b8 df 14 80 00 00 	movabs $0x8014df,%rax
  800ff1:	00 00 00 
  800ff4:	ff d0                	callq  *%rax
  800ff6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ff9:	eb 17                	jmp    801012 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800ffb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800fff:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801003:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801007:	48 89 ce             	mov    %rcx,%rsi
  80100a:	89 d7                	mov    %edx,%edi
  80100c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801012:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801016:	7f e3                	jg     800ffb <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801018:	eb 37                	jmp    801051 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  80101a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80101e:	74 1e                	je     80103e <vprintfmt+0x313>
  801020:	83 fb 1f             	cmp    $0x1f,%ebx
  801023:	7e 05                	jle    80102a <vprintfmt+0x2ff>
  801025:	83 fb 7e             	cmp    $0x7e,%ebx
  801028:	7e 14                	jle    80103e <vprintfmt+0x313>
					putch('?', putdat);
  80102a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80102e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801032:	48 89 d6             	mov    %rdx,%rsi
  801035:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80103a:	ff d0                	callq  *%rax
  80103c:	eb 0f                	jmp    80104d <vprintfmt+0x322>
				else
					putch(ch, putdat);
  80103e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801042:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801046:	48 89 d6             	mov    %rdx,%rsi
  801049:	89 df                	mov    %ebx,%edi
  80104b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80104d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801051:	4c 89 e0             	mov    %r12,%rax
  801054:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801058:	0f b6 00             	movzbl (%rax),%eax
  80105b:	0f be d8             	movsbl %al,%ebx
  80105e:	85 db                	test   %ebx,%ebx
  801060:	74 28                	je     80108a <vprintfmt+0x35f>
  801062:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801066:	78 b2                	js     80101a <vprintfmt+0x2ef>
  801068:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80106c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801070:	79 a8                	jns    80101a <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801072:	eb 16                	jmp    80108a <vprintfmt+0x35f>
				putch(' ', putdat);
  801074:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801078:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80107c:	48 89 d6             	mov    %rdx,%rsi
  80107f:	bf 20 00 00 00       	mov    $0x20,%edi
  801084:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801086:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80108a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80108e:	7f e4                	jg     801074 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  801090:	e9 8d 01 00 00       	jmpq   801222 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801095:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801099:	be 03 00 00 00       	mov    $0x3,%esi
  80109e:	48 89 c7             	mov    %rax,%rdi
  8010a1:	48 b8 24 0c 80 00 00 	movabs $0x800c24,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	callq  *%rax
  8010ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b5:	48 85 c0             	test   %rax,%rax
  8010b8:	79 1d                	jns    8010d7 <vprintfmt+0x3ac>
				putch('-', putdat);
  8010ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c2:	48 89 d6             	mov    %rdx,%rsi
  8010c5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010ca:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d0:	48 f7 d8             	neg    %rax
  8010d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8010d7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010de:	e9 d2 00 00 00       	jmpq   8011b5 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8010e3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010e7:	be 03 00 00 00       	mov    $0x3,%esi
  8010ec:	48 89 c7             	mov    %rax,%rdi
  8010ef:	48 b8 1d 0b 80 00 00 	movabs $0x800b1d,%rax
  8010f6:	00 00 00 
  8010f9:	ff d0                	callq  *%rax
  8010fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8010ff:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801106:	e9 aa 00 00 00       	jmpq   8011b5 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  80110b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80110f:	be 03 00 00 00       	mov    $0x3,%esi
  801114:	48 89 c7             	mov    %rax,%rdi
  801117:	48 b8 1d 0b 80 00 00 	movabs $0x800b1d,%rax
  80111e:	00 00 00 
  801121:	ff d0                	callq  *%rax
  801123:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801127:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80112e:	e9 82 00 00 00       	jmpq   8011b5 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  801133:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801137:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80113b:	48 89 d6             	mov    %rdx,%rsi
  80113e:	bf 30 00 00 00       	mov    $0x30,%edi
  801143:	ff d0                	callq  *%rax
			putch('x', putdat);
  801145:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801149:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80114d:	48 89 d6             	mov    %rdx,%rsi
  801150:	bf 78 00 00 00       	mov    $0x78,%edi
  801155:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801157:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80115a:	83 f8 30             	cmp    $0x30,%eax
  80115d:	73 17                	jae    801176 <vprintfmt+0x44b>
  80115f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801163:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801166:	89 d2                	mov    %edx,%edx
  801168:	48 01 d0             	add    %rdx,%rax
  80116b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80116e:	83 c2 08             	add    $0x8,%edx
  801171:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801174:	eb 0c                	jmp    801182 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801176:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80117a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80117e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801182:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801185:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801189:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801190:	eb 23                	jmp    8011b5 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801192:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801196:	be 03 00 00 00       	mov    $0x3,%esi
  80119b:	48 89 c7             	mov    %rax,%rdi
  80119e:	48 b8 1d 0b 80 00 00 	movabs $0x800b1d,%rax
  8011a5:	00 00 00 
  8011a8:	ff d0                	callq  *%rax
  8011aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011ae:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011b5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011ba:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011bd:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011cc:	45 89 c1             	mov    %r8d,%r9d
  8011cf:	41 89 f8             	mov    %edi,%r8d
  8011d2:	48 89 c7             	mov    %rax,%rdi
  8011d5:	48 b8 65 0a 80 00 00 	movabs $0x800a65,%rax
  8011dc:	00 00 00 
  8011df:	ff d0                	callq  *%rax
			break;
  8011e1:	eb 3f                	jmp    801222 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011eb:	48 89 d6             	mov    %rdx,%rsi
  8011ee:	89 df                	mov    %ebx,%edi
  8011f0:	ff d0                	callq  *%rax
			break;
  8011f2:	eb 2e                	jmp    801222 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fc:	48 89 d6             	mov    %rdx,%rsi
  8011ff:	bf 25 00 00 00       	mov    $0x25,%edi
  801204:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801206:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80120b:	eb 05                	jmp    801212 <vprintfmt+0x4e7>
  80120d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801212:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801216:	48 83 e8 01          	sub    $0x1,%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	3c 25                	cmp    $0x25,%al
  80121f:	75 ec                	jne    80120d <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  801221:	90                   	nop
		}
	}
  801222:	e9 3d fb ff ff       	jmpq   800d64 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801227:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801228:	48 83 c4 60          	add    $0x60,%rsp
  80122c:	5b                   	pop    %rbx
  80122d:	41 5c                	pop    %r12
  80122f:	5d                   	pop    %rbp
  801230:	c3                   	retq   

0000000000801231 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801231:	55                   	push   %rbp
  801232:	48 89 e5             	mov    %rsp,%rbp
  801235:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80123c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801243:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80124a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801251:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801258:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80125f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801266:	84 c0                	test   %al,%al
  801268:	74 20                	je     80128a <printfmt+0x59>
  80126a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80126e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801272:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801276:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80127a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80127e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801282:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801286:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80128a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801291:	00 00 00 
  801294:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80129b:	00 00 00 
  80129e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012a2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012a9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012b0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012b7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012be:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012c5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012cc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012d3:	48 89 c7             	mov    %rax,%rdi
  8012d6:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  8012dd:	00 00 00 
  8012e0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8012e2:	90                   	nop
  8012e3:	c9                   	leaveq 
  8012e4:	c3                   	retq   

00000000008012e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012e5:	55                   	push   %rbp
  8012e6:	48 89 e5             	mov    %rsp,%rbp
  8012e9:	48 83 ec 10          	sub    $0x10,%rsp
  8012ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8012f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8012f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f8:	8b 40 10             	mov    0x10(%rax),%eax
  8012fb:	8d 50 01             	lea    0x1(%rax),%edx
  8012fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801302:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801309:	48 8b 10             	mov    (%rax),%rdx
  80130c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801310:	48 8b 40 08          	mov    0x8(%rax),%rax
  801314:	48 39 c2             	cmp    %rax,%rdx
  801317:	73 17                	jae    801330 <sprintputch+0x4b>
		*b->buf++ = ch;
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	48 8b 00             	mov    (%rax),%rax
  801320:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801324:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801328:	48 89 0a             	mov    %rcx,(%rdx)
  80132b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80132e:	88 10                	mov    %dl,(%rax)
}
  801330:	90                   	nop
  801331:	c9                   	leaveq 
  801332:	c3                   	retq   

0000000000801333 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801333:	55                   	push   %rbp
  801334:	48 89 e5             	mov    %rsp,%rbp
  801337:	48 83 ec 50          	sub    $0x50,%rsp
  80133b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80133f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801342:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801346:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80134a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80134e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801352:	48 8b 0a             	mov    (%rdx),%rcx
  801355:	48 89 08             	mov    %rcx,(%rax)
  801358:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80135c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801360:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801364:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801368:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80136c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801370:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801373:	48 98                	cltq   
  801375:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801379:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80137d:	48 01 d0             	add    %rdx,%rax
  801380:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801384:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80138b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801390:	74 06                	je     801398 <vsnprintf+0x65>
  801392:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801396:	7f 07                	jg     80139f <vsnprintf+0x6c>
		return -E_INVAL;
  801398:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139d:	eb 2f                	jmp    8013ce <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80139f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013a3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013a7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013ab:	48 89 c6             	mov    %rax,%rsi
  8013ae:	48 bf e5 12 80 00 00 	movabs $0x8012e5,%rdi
  8013b5:	00 00 00 
  8013b8:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  8013bf:	00 00 00 
  8013c2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013c8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013cb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013ce:	c9                   	leaveq 
  8013cf:	c3                   	retq   

00000000008013d0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013db:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8013e2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8013e8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8013ef:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013f6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013fd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801404:	84 c0                	test   %al,%al
  801406:	74 20                	je     801428 <snprintf+0x58>
  801408:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80140c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801410:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801414:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801418:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80141c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801420:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801424:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801428:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80142f:	00 00 00 
  801432:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801439:	00 00 00 
  80143c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801440:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801447:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80144e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801455:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80145c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801463:	48 8b 0a             	mov    (%rdx),%rcx
  801466:	48 89 08             	mov    %rcx,(%rax)
  801469:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80146d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801471:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801475:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801479:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801480:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801487:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80148d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801494:	48 89 c7             	mov    %rax,%rdi
  801497:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  80149e:	00 00 00 
  8014a1:	ff d0                	callq  *%rax
  8014a3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014a9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 18          	sub    $0x18,%rsp
  8014b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014c4:	eb 09                	jmp    8014cf <strlen+0x1e>
		n++;
  8014c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	84 c0                	test   %al,%al
  8014d8:	75 ec                	jne    8014c6 <strlen+0x15>
		n++;
	return n;
  8014da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014dd:	c9                   	leaveq 
  8014de:	c3                   	retq   

00000000008014df <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8014df:	55                   	push   %rbp
  8014e0:	48 89 e5             	mov    %rsp,%rbp
  8014e3:	48 83 ec 20          	sub    $0x20,%rsp
  8014e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014f6:	eb 0e                	jmp    801506 <strnlen+0x27>
		n++;
  8014f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801501:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801506:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80150b:	74 0b                	je     801518 <strnlen+0x39>
  80150d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	84 c0                	test   %al,%al
  801516:	75 e0                	jne    8014f8 <strnlen+0x19>
		n++;
	return n;
  801518:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80151b:	c9                   	leaveq 
  80151c:	c3                   	retq   

000000000080151d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80151d:	55                   	push   %rbp
  80151e:	48 89 e5             	mov    %rsp,%rbp
  801521:	48 83 ec 20          	sub    $0x20,%rsp
  801525:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80152d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801531:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801535:	90                   	nop
  801536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801542:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801546:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80154a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80154e:	0f b6 12             	movzbl (%rdx),%edx
  801551:	88 10                	mov    %dl,(%rax)
  801553:	0f b6 00             	movzbl (%rax),%eax
  801556:	84 c0                	test   %al,%al
  801558:	75 dc                	jne    801536 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80155a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80155e:	c9                   	leaveq 
  80155f:	c3                   	retq   

0000000000801560 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801560:	55                   	push   %rbp
  801561:	48 89 e5             	mov    %rsp,%rbp
  801564:	48 83 ec 20          	sub    $0x20,%rsp
  801568:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80156c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801574:	48 89 c7             	mov    %rax,%rdi
  801577:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  80157e:	00 00 00 
  801581:	ff d0                	callq  *%rax
  801583:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801589:	48 63 d0             	movslq %eax,%rdx
  80158c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801590:	48 01 c2             	add    %rax,%rdx
  801593:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801597:	48 89 c6             	mov    %rax,%rsi
  80159a:	48 89 d7             	mov    %rdx,%rdi
  80159d:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
	return dst;
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 28          	sub    $0x28,%rsp
  8015b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015cb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015d2:	00 
  8015d3:	eb 2a                	jmp    8015ff <strncpy+0x50>
		*dst++ = *src;
  8015d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015e5:	0f b6 12             	movzbl (%rdx),%edx
  8015e8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8015ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	84 c0                	test   %al,%al
  8015f3:	74 05                	je     8015fa <strncpy+0x4b>
			src++;
  8015f5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8015fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801603:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801607:	72 cc                	jb     8015d5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80160d:	c9                   	leaveq 
  80160e:	c3                   	retq   

000000000080160f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80160f:	55                   	push   %rbp
  801610:	48 89 e5             	mov    %rsp,%rbp
  801613:	48 83 ec 28          	sub    $0x28,%rsp
  801617:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80161b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80161f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801627:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80162b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801630:	74 3d                	je     80166f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801632:	eb 1d                	jmp    801651 <strlcpy+0x42>
			*dst++ = *src++;
  801634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801638:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80163c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801640:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801644:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801648:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80164c:	0f b6 12             	movzbl (%rdx),%edx
  80164f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801651:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801656:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80165b:	74 0b                	je     801668 <strlcpy+0x59>
  80165d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	84 c0                	test   %al,%al
  801666:	75 cc                	jne    801634 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80166f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801677:	48 29 c2             	sub    %rax,%rdx
  80167a:	48 89 d0             	mov    %rdx,%rax
}
  80167d:	c9                   	leaveq 
  80167e:	c3                   	retq   

000000000080167f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80167f:	55                   	push   %rbp
  801680:	48 89 e5             	mov    %rsp,%rbp
  801683:	48 83 ec 10          	sub    $0x10,%rsp
  801687:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80168b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80168f:	eb 0a                	jmp    80169b <strcmp+0x1c>
		p++, q++;
  801691:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801696:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80169b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 12                	je     8016b8 <strcmp+0x39>
  8016a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016aa:	0f b6 10             	movzbl (%rax),%edx
  8016ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	38 c2                	cmp    %al,%dl
  8016b6:	74 d9                	je     801691 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bc:	0f b6 00             	movzbl (%rax),%eax
  8016bf:	0f b6 d0             	movzbl %al,%edx
  8016c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	0f b6 c0             	movzbl %al,%eax
  8016cc:	29 c2                	sub    %eax,%edx
  8016ce:	89 d0                	mov    %edx,%eax
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
  8016d6:	48 83 ec 18          	sub    $0x18,%rsp
  8016da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8016e6:	eb 0f                	jmp    8016f7 <strncmp+0x25>
		n--, p++, q++;
  8016e8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8016ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8016f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016fc:	74 1d                	je     80171b <strncmp+0x49>
  8016fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	84 c0                	test   %al,%al
  801707:	74 12                	je     80171b <strncmp+0x49>
  801709:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170d:	0f b6 10             	movzbl (%rax),%edx
  801710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801714:	0f b6 00             	movzbl (%rax),%eax
  801717:	38 c2                	cmp    %al,%dl
  801719:	74 cd                	je     8016e8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80171b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801720:	75 07                	jne    801729 <strncmp+0x57>
		return 0;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 18                	jmp    801741 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172d:	0f b6 00             	movzbl (%rax),%eax
  801730:	0f b6 d0             	movzbl %al,%edx
  801733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	0f b6 c0             	movzbl %al,%eax
  80173d:	29 c2                	sub    %eax,%edx
  80173f:	89 d0                	mov    %edx,%eax
}
  801741:	c9                   	leaveq 
  801742:	c3                   	retq   

0000000000801743 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	48 83 ec 10          	sub    $0x10,%rsp
  80174b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174f:	89 f0                	mov    %esi,%eax
  801751:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801754:	eb 17                	jmp    80176d <strchr+0x2a>
		if (*s == c)
  801756:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801760:	75 06                	jne    801768 <strchr+0x25>
			return (char *) s;
  801762:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801766:	eb 15                	jmp    80177d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801768:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80176d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	84 c0                	test   %al,%al
  801776:	75 de                	jne    801756 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leaveq 
  80177e:	c3                   	retq   

000000000080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %rbp
  801780:	48 89 e5             	mov    %rsp,%rbp
  801783:	48 83 ec 10          	sub    $0x10,%rsp
  801787:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80178b:	89 f0                	mov    %esi,%eax
  80178d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801790:	eb 11                	jmp    8017a3 <strfind+0x24>
		if (*s == c)
  801792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80179c:	74 12                	je     8017b0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80179e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a7:	0f b6 00             	movzbl (%rax),%eax
  8017aa:	84 c0                	test   %al,%al
  8017ac:	75 e4                	jne    801792 <strfind+0x13>
  8017ae:	eb 01                	jmp    8017b1 <strfind+0x32>
		if (*s == c)
			break;
  8017b0:	90                   	nop
	return (char *) s;
  8017b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017b5:	c9                   	leaveq 
  8017b6:	c3                   	retq   

00000000008017b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017b7:	55                   	push   %rbp
  8017b8:	48 89 e5             	mov    %rsp,%rbp
  8017bb:	48 83 ec 18          	sub    $0x18,%rsp
  8017bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017c3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017cf:	75 06                	jne    8017d7 <memset+0x20>
		return v;
  8017d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d5:	eb 69                	jmp    801840 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017db:	83 e0 03             	and    $0x3,%eax
  8017de:	48 85 c0             	test   %rax,%rax
  8017e1:	75 48                	jne    80182b <memset+0x74>
  8017e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e7:	83 e0 03             	and    $0x3,%eax
  8017ea:	48 85 c0             	test   %rax,%rax
  8017ed:	75 3c                	jne    80182b <memset+0x74>
		c &= 0xFF;
  8017ef:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8017f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017f9:	c1 e0 18             	shl    $0x18,%eax
  8017fc:	89 c2                	mov    %eax,%edx
  8017fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801801:	c1 e0 10             	shl    $0x10,%eax
  801804:	09 c2                	or     %eax,%edx
  801806:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801809:	c1 e0 08             	shl    $0x8,%eax
  80180c:	09 d0                	or     %edx,%eax
  80180e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801815:	48 c1 e8 02          	shr    $0x2,%rax
  801819:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80181c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801820:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801823:	48 89 d7             	mov    %rdx,%rdi
  801826:	fc                   	cld    
  801827:	f3 ab                	rep stos %eax,%es:(%rdi)
  801829:	eb 11                	jmp    80183c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80182b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80182f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801832:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801836:	48 89 d7             	mov    %rdx,%rdi
  801839:	fc                   	cld    
  80183a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80183c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801840:	c9                   	leaveq 
  801841:	c3                   	retq   

0000000000801842 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801842:	55                   	push   %rbp
  801843:	48 89 e5             	mov    %rsp,%rbp
  801846:	48 83 ec 28          	sub    $0x28,%rsp
  80184a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801852:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80185a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80185e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801862:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80186e:	0f 83 88 00 00 00    	jae    8018fc <memmove+0xba>
  801874:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801878:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187c:	48 01 d0             	add    %rdx,%rax
  80187f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801883:	76 77                	jbe    8018fc <memmove+0xba>
		s += n;
  801885:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801889:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80188d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801891:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801895:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801899:	83 e0 03             	and    $0x3,%eax
  80189c:	48 85 c0             	test   %rax,%rax
  80189f:	75 3b                	jne    8018dc <memmove+0x9a>
  8018a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a5:	83 e0 03             	and    $0x3,%eax
  8018a8:	48 85 c0             	test   %rax,%rax
  8018ab:	75 2f                	jne    8018dc <memmove+0x9a>
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	83 e0 03             	and    $0x3,%eax
  8018b4:	48 85 c0             	test   %rax,%rax
  8018b7:	75 23                	jne    8018dc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018bd:	48 83 e8 04          	sub    $0x4,%rax
  8018c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c5:	48 83 ea 04          	sub    $0x4,%rdx
  8018c9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018cd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018d1:	48 89 c7             	mov    %rax,%rdi
  8018d4:	48 89 d6             	mov    %rdx,%rsi
  8018d7:	fd                   	std    
  8018d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018da:	eb 1d                	jmp    8018f9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	48 89 d7             	mov    %rdx,%rdi
  8018f3:	48 89 c1             	mov    %rax,%rcx
  8018f6:	fd                   	std    
  8018f7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018f9:	fc                   	cld    
  8018fa:	eb 57                	jmp    801953 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801900:	83 e0 03             	and    $0x3,%eax
  801903:	48 85 c0             	test   %rax,%rax
  801906:	75 36                	jne    80193e <memmove+0xfc>
  801908:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190c:	83 e0 03             	and    $0x3,%eax
  80190f:	48 85 c0             	test   %rax,%rax
  801912:	75 2a                	jne    80193e <memmove+0xfc>
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	83 e0 03             	and    $0x3,%eax
  80191b:	48 85 c0             	test   %rax,%rax
  80191e:	75 1e                	jne    80193e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801920:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801924:	48 c1 e8 02          	shr    $0x2,%rax
  801928:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80192b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801933:	48 89 c7             	mov    %rax,%rdi
  801936:	48 89 d6             	mov    %rdx,%rsi
  801939:	fc                   	cld    
  80193a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80193c:	eb 15                	jmp    801953 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80193e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801942:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801946:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80194a:	48 89 c7             	mov    %rax,%rdi
  80194d:	48 89 d6             	mov    %rdx,%rsi
  801950:	fc                   	cld    
  801951:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801957:	c9                   	leaveq 
  801958:	c3                   	retq   

0000000000801959 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801959:	55                   	push   %rbp
  80195a:	48 89 e5             	mov    %rsp,%rbp
  80195d:	48 83 ec 18          	sub    $0x18,%rsp
  801961:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801965:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801969:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80196d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801971:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801975:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801979:	48 89 ce             	mov    %rcx,%rsi
  80197c:	48 89 c7             	mov    %rax,%rdi
  80197f:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 28          	sub    $0x28,%rsp
  801995:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801999:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80199d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019b1:	eb 36                	jmp    8019e9 <memcmp+0x5c>
		if (*s1 != *s2)
  8019b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b7:	0f b6 10             	movzbl (%rax),%edx
  8019ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019be:	0f b6 00             	movzbl (%rax),%eax
  8019c1:	38 c2                	cmp    %al,%dl
  8019c3:	74 1a                	je     8019df <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c9:	0f b6 00             	movzbl (%rax),%eax
  8019cc:	0f b6 d0             	movzbl %al,%edx
  8019cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019d3:	0f b6 00             	movzbl (%rax),%eax
  8019d6:	0f b6 c0             	movzbl %al,%eax
  8019d9:	29 c2                	sub    %eax,%edx
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	eb 20                	jmp    8019ff <memcmp+0x72>
		s1++, s2++;
  8019df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8019e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ed:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8019f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019f5:	48 85 c0             	test   %rax,%rax
  8019f8:	75 b9                	jne    8019b3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	48 83 ec 28          	sub    $0x28,%rsp
  801a09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a0d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	48 01 d0             	add    %rdx,%rax
  801a1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a23:	eb 19                	jmp    801a3e <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a29:	0f b6 00             	movzbl (%rax),%eax
  801a2c:	0f b6 d0             	movzbl %al,%edx
  801a2f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a32:	0f b6 c0             	movzbl %al,%eax
  801a35:	39 c2                	cmp    %eax,%edx
  801a37:	74 11                	je     801a4a <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a42:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a46:	72 dd                	jb     801a25 <memfind+0x24>
  801a48:	eb 01                	jmp    801a4b <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a4a:	90                   	nop
	return (void *) s;
  801a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   

0000000000801a51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a51:	55                   	push   %rbp
  801a52:	48 89 e5             	mov    %rsp,%rbp
  801a55:	48 83 ec 38          	sub    $0x38,%rsp
  801a59:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a5d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a61:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a6b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a72:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a73:	eb 05                	jmp    801a7a <strtol+0x29>
		s++;
  801a75:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7e:	0f b6 00             	movzbl (%rax),%eax
  801a81:	3c 20                	cmp    $0x20,%al
  801a83:	74 f0                	je     801a75 <strtol+0x24>
  801a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a89:	0f b6 00             	movzbl (%rax),%eax
  801a8c:	3c 09                	cmp    $0x9,%al
  801a8e:	74 e5                	je     801a75 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a94:	0f b6 00             	movzbl (%rax),%eax
  801a97:	3c 2b                	cmp    $0x2b,%al
  801a99:	75 07                	jne    801aa2 <strtol+0x51>
		s++;
  801a9b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801aa0:	eb 17                	jmp    801ab9 <strtol+0x68>
	else if (*s == '-')
  801aa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa6:	0f b6 00             	movzbl (%rax),%eax
  801aa9:	3c 2d                	cmp    $0x2d,%al
  801aab:	75 0c                	jne    801ab9 <strtol+0x68>
		s++, neg = 1;
  801aad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ab2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801abd:	74 06                	je     801ac5 <strtol+0x74>
  801abf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801ac3:	75 28                	jne    801aed <strtol+0x9c>
  801ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac9:	0f b6 00             	movzbl (%rax),%eax
  801acc:	3c 30                	cmp    $0x30,%al
  801ace:	75 1d                	jne    801aed <strtol+0x9c>
  801ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad4:	48 83 c0 01          	add    $0x1,%rax
  801ad8:	0f b6 00             	movzbl (%rax),%eax
  801adb:	3c 78                	cmp    $0x78,%al
  801add:	75 0e                	jne    801aed <strtol+0x9c>
		s += 2, base = 16;
  801adf:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801ae4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801aeb:	eb 2c                	jmp    801b19 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801aed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801af1:	75 19                	jne    801b0c <strtol+0xbb>
  801af3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af7:	0f b6 00             	movzbl (%rax),%eax
  801afa:	3c 30                	cmp    $0x30,%al
  801afc:	75 0e                	jne    801b0c <strtol+0xbb>
		s++, base = 8;
  801afe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b03:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b0a:	eb 0d                	jmp    801b19 <strtol+0xc8>
	else if (base == 0)
  801b0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b10:	75 07                	jne    801b19 <strtol+0xc8>
		base = 10;
  801b12:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1d:	0f b6 00             	movzbl (%rax),%eax
  801b20:	3c 2f                	cmp    $0x2f,%al
  801b22:	7e 1d                	jle    801b41 <strtol+0xf0>
  801b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b28:	0f b6 00             	movzbl (%rax),%eax
  801b2b:	3c 39                	cmp    $0x39,%al
  801b2d:	7f 12                	jg     801b41 <strtol+0xf0>
			dig = *s - '0';
  801b2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b33:	0f b6 00             	movzbl (%rax),%eax
  801b36:	0f be c0             	movsbl %al,%eax
  801b39:	83 e8 30             	sub    $0x30,%eax
  801b3c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b3f:	eb 4e                	jmp    801b8f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b45:	0f b6 00             	movzbl (%rax),%eax
  801b48:	3c 60                	cmp    $0x60,%al
  801b4a:	7e 1d                	jle    801b69 <strtol+0x118>
  801b4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b50:	0f b6 00             	movzbl (%rax),%eax
  801b53:	3c 7a                	cmp    $0x7a,%al
  801b55:	7f 12                	jg     801b69 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5b:	0f b6 00             	movzbl (%rax),%eax
  801b5e:	0f be c0             	movsbl %al,%eax
  801b61:	83 e8 57             	sub    $0x57,%eax
  801b64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b67:	eb 26                	jmp    801b8f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6d:	0f b6 00             	movzbl (%rax),%eax
  801b70:	3c 40                	cmp    $0x40,%al
  801b72:	7e 47                	jle    801bbb <strtol+0x16a>
  801b74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b78:	0f b6 00             	movzbl (%rax),%eax
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 3c                	jg     801bbb <strtol+0x16a>
			dig = *s - 'A' + 10;
  801b7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b83:	0f b6 00             	movzbl (%rax),%eax
  801b86:	0f be c0             	movsbl %al,%eax
  801b89:	83 e8 37             	sub    $0x37,%eax
  801b8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b92:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b95:	7d 23                	jge    801bba <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801b97:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b9c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b9f:	48 98                	cltq   
  801ba1:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ba6:	48 89 c2             	mov    %rax,%rdx
  801ba9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bac:	48 98                	cltq   
  801bae:	48 01 d0             	add    %rdx,%rax
  801bb1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bb5:	e9 5f ff ff ff       	jmpq   801b19 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bba:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801bbb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bc0:	74 0b                	je     801bcd <strtol+0x17c>
		*endptr = (char *) s;
  801bc2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bc6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bca:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd1:	74 09                	je     801bdc <strtol+0x18b>
  801bd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd7:	48 f7 d8             	neg    %rax
  801bda:	eb 04                	jmp    801be0 <strtol+0x18f>
  801bdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801be0:	c9                   	leaveq 
  801be1:	c3                   	retq   

0000000000801be2 <strstr>:

char * strstr(const char *in, const char *str)
{
  801be2:	55                   	push   %rbp
  801be3:	48 89 e5             	mov    %rsp,%rbp
  801be6:	48 83 ec 30          	sub    $0x30,%rsp
  801bea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801bf2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bfa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bfe:	0f b6 00             	movzbl (%rax),%eax
  801c01:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c04:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c08:	75 06                	jne    801c10 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0e:	eb 6b                	jmp    801c7b <strstr+0x99>

	len = strlen(str);
  801c10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c14:	48 89 c7             	mov    %rax,%rdi
  801c17:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	callq  *%rax
  801c23:	48 98                	cltq   
  801c25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c31:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c35:	0f b6 00             	movzbl (%rax),%eax
  801c38:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c3b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c3f:	75 07                	jne    801c48 <strstr+0x66>
				return (char *) 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	eb 33                	jmp    801c7b <strstr+0x99>
		} while (sc != c);
  801c48:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c4c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c4f:	75 d8                	jne    801c29 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c55:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5d:	48 89 ce             	mov    %rcx,%rsi
  801c60:	48 89 c7             	mov    %rax,%rdi
  801c63:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  801c6a:	00 00 00 
  801c6d:	ff d0                	callq  *%rax
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	75 b6                	jne    801c29 <strstr+0x47>

	return (char *) (in - 1);
  801c73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c77:	48 83 e8 01          	sub    $0x1,%rax
}
  801c7b:	c9                   	leaveq 
  801c7c:	c3                   	retq   

0000000000801c7d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c7d:	55                   	push   %rbp
  801c7e:	48 89 e5             	mov    %rsp,%rbp
  801c81:	53                   	push   %rbx
  801c82:	48 83 ec 48          	sub    $0x48,%rsp
  801c86:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c89:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c8c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c90:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c94:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c98:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c9c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c9f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ca3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ca7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cab:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801caf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cb3:	4c 89 c3             	mov    %r8,%rbx
  801cb6:	cd 30                	int    $0x30
  801cb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801cbc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cc0:	74 3e                	je     801d00 <syscall+0x83>
  801cc2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cc7:	7e 37                	jle    801d00 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ccd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cd0:	49 89 d0             	mov    %rdx,%r8
  801cd3:	89 c1                	mov    %eax,%ecx
  801cd5:	48 ba 08 56 80 00 00 	movabs $0x805608,%rdx
  801cdc:	00 00 00 
  801cdf:	be 24 00 00 00       	mov    $0x24,%esi
  801ce4:	48 bf 25 56 80 00 00 	movabs $0x805625,%rdi
  801ceb:	00 00 00 
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf3:	49 b9 53 07 80 00 00 	movabs $0x800753,%r9
  801cfa:	00 00 00 
  801cfd:	41 ff d1             	callq  *%r9

	return ret;
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d04:	48 83 c4 48          	add    $0x48,%rsp
  801d08:	5b                   	pop    %rbx
  801d09:	5d                   	pop    %rbp
  801d0a:	c3                   	retq   

0000000000801d0b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d0b:	55                   	push   %rbp
  801d0c:	48 89 e5             	mov    %rsp,%rbp
  801d0f:	48 83 ec 10          	sub    $0x10,%rsp
  801d13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d23:	48 83 ec 08          	sub    $0x8,%rsp
  801d27:	6a 00                	pushq  $0x0
  801d29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d35:	48 89 d1             	mov    %rdx,%rcx
  801d38:	48 89 c2             	mov    %rax,%rdx
  801d3b:	be 00 00 00 00       	mov    $0x0,%esi
  801d40:	bf 00 00 00 00       	mov    $0x0,%edi
  801d45:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801d4c:	00 00 00 
  801d4f:	ff d0                	callq  *%rax
  801d51:	48 83 c4 10          	add    $0x10,%rsp
}
  801d55:	90                   	nop
  801d56:	c9                   	leaveq 
  801d57:	c3                   	retq   

0000000000801d58 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d58:	55                   	push   %rbp
  801d59:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d5c:	48 83 ec 08          	sub    $0x8,%rsp
  801d60:	6a 00                	pushq  $0x0
  801d62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d73:	ba 00 00 00 00       	mov    $0x0,%edx
  801d78:	be 00 00 00 00       	mov    $0x0,%esi
  801d7d:	bf 01 00 00 00       	mov    $0x1,%edi
  801d82:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
  801d8e:	48 83 c4 10          	add    $0x10,%rsp
}
  801d92:	c9                   	leaveq 
  801d93:	c3                   	retq   

0000000000801d94 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d94:	55                   	push   %rbp
  801d95:	48 89 e5             	mov    %rsp,%rbp
  801d98:	48 83 ec 10          	sub    $0x10,%rsp
  801d9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da2:	48 98                	cltq   
  801da4:	48 83 ec 08          	sub    $0x8,%rsp
  801da8:	6a 00                	pushq  $0x0
  801daa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	be 01 00 00 00       	mov    $0x1,%esi
  801dc3:	bf 03 00 00 00       	mov    $0x3,%edi
  801dc8:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	callq  *%rax
  801dd4:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd8:	c9                   	leaveq 
  801dd9:	c3                   	retq   

0000000000801dda <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801dda:	55                   	push   %rbp
  801ddb:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801dde:	48 83 ec 08          	sub    $0x8,%rsp
  801de2:	6a 00                	pushq  $0x0
  801de4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801df5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfa:	be 00 00 00 00       	mov    $0x0,%esi
  801dff:	bf 02 00 00 00       	mov    $0x2,%edi
  801e04:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801e0b:	00 00 00 
  801e0e:	ff d0                	callq  *%rax
  801e10:	48 83 c4 10          	add    $0x10,%rsp
}
  801e14:	c9                   	leaveq 
  801e15:	c3                   	retq   

0000000000801e16 <sys_yield>:


void
sys_yield(void)
{
  801e16:	55                   	push   %rbp
  801e17:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e1a:	48 83 ec 08          	sub    $0x8,%rsp
  801e1e:	6a 00                	pushq  $0x0
  801e20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e31:	ba 00 00 00 00       	mov    $0x0,%edx
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
  801e3b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e40:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	callq  *%rax
  801e4c:	48 83 c4 10          	add    $0x10,%rsp
}
  801e50:	90                   	nop
  801e51:	c9                   	leaveq 
  801e52:	c3                   	retq   

0000000000801e53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e53:	55                   	push   %rbp
  801e54:	48 89 e5             	mov    %rsp,%rbp
  801e57:	48 83 ec 10          	sub    $0x10,%rsp
  801e5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e62:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e68:	48 63 c8             	movslq %eax,%rcx
  801e6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e72:	48 98                	cltq   
  801e74:	48 83 ec 08          	sub    $0x8,%rsp
  801e78:	6a 00                	pushq  $0x0
  801e7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e80:	49 89 c8             	mov    %rcx,%r8
  801e83:	48 89 d1             	mov    %rdx,%rcx
  801e86:	48 89 c2             	mov    %rax,%rdx
  801e89:	be 01 00 00 00       	mov    $0x1,%esi
  801e8e:	bf 04 00 00 00       	mov    $0x4,%edi
  801e93:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	callq  *%rax
  801e9f:	48 83 c4 10          	add    $0x10,%rsp
}
  801ea3:	c9                   	leaveq 
  801ea4:	c3                   	retq   

0000000000801ea5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ea5:	55                   	push   %rbp
  801ea6:	48 89 e5             	mov    %rsp,%rbp
  801ea9:	48 83 ec 20          	sub    $0x20,%rsp
  801ead:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eb4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801eb7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ebb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ebf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ec2:	48 63 c8             	movslq %eax,%rcx
  801ec5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ec9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ecc:	48 63 f0             	movslq %eax,%rsi
  801ecf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed6:	48 98                	cltq   
  801ed8:	48 83 ec 08          	sub    $0x8,%rsp
  801edc:	51                   	push   %rcx
  801edd:	49 89 f9             	mov    %rdi,%r9
  801ee0:	49 89 f0             	mov    %rsi,%r8
  801ee3:	48 89 d1             	mov    %rdx,%rcx
  801ee6:	48 89 c2             	mov    %rax,%rdx
  801ee9:	be 01 00 00 00       	mov    $0x1,%esi
  801eee:	bf 05 00 00 00       	mov    $0x5,%edi
  801ef3:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	callq  *%rax
  801eff:	48 83 c4 10          	add    $0x10,%rsp
}
  801f03:	c9                   	leaveq 
  801f04:	c3                   	retq   

0000000000801f05 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f05:	55                   	push   %rbp
  801f06:	48 89 e5             	mov    %rsp,%rbp
  801f09:	48 83 ec 10          	sub    $0x10,%rsp
  801f0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1b:	48 98                	cltq   
  801f1d:	48 83 ec 08          	sub    $0x8,%rsp
  801f21:	6a 00                	pushq  $0x0
  801f23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f2f:	48 89 d1             	mov    %rdx,%rcx
  801f32:	48 89 c2             	mov    %rax,%rdx
  801f35:	be 01 00 00 00       	mov    $0x1,%esi
  801f3a:	bf 06 00 00 00       	mov    $0x6,%edi
  801f3f:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801f46:	00 00 00 
  801f49:	ff d0                	callq  *%rax
  801f4b:	48 83 c4 10          	add    $0x10,%rsp
}
  801f4f:	c9                   	leaveq 
  801f50:	c3                   	retq   

0000000000801f51 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f51:	55                   	push   %rbp
  801f52:	48 89 e5             	mov    %rsp,%rbp
  801f55:	48 83 ec 10          	sub    $0x10,%rsp
  801f59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f62:	48 63 d0             	movslq %eax,%rdx
  801f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f68:	48 98                	cltq   
  801f6a:	48 83 ec 08          	sub    $0x8,%rsp
  801f6e:	6a 00                	pushq  $0x0
  801f70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7c:	48 89 d1             	mov    %rdx,%rcx
  801f7f:	48 89 c2             	mov    %rax,%rdx
  801f82:	be 01 00 00 00       	mov    $0x1,%esi
  801f87:	bf 08 00 00 00       	mov    $0x8,%edi
  801f8c:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	48 83 c4 10          	add    $0x10,%rsp
}
  801f9c:	c9                   	leaveq 
  801f9d:	c3                   	retq   

0000000000801f9e <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f9e:	55                   	push   %rbp
  801f9f:	48 89 e5             	mov    %rsp,%rbp
  801fa2:	48 83 ec 10          	sub    $0x10,%rsp
  801fa6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fa9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb4:	48 98                	cltq   
  801fb6:	48 83 ec 08          	sub    $0x8,%rsp
  801fba:	6a 00                	pushq  $0x0
  801fbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc8:	48 89 d1             	mov    %rdx,%rcx
  801fcb:	48 89 c2             	mov    %rax,%rdx
  801fce:	be 01 00 00 00       	mov    $0x1,%esi
  801fd3:	bf 09 00 00 00       	mov    $0x9,%edi
  801fd8:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  801fdf:	00 00 00 
  801fe2:	ff d0                	callq  *%rax
  801fe4:	48 83 c4 10          	add    $0x10,%rsp
}
  801fe8:	c9                   	leaveq 
  801fe9:	c3                   	retq   

0000000000801fea <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801fea:	55                   	push   %rbp
  801feb:	48 89 e5             	mov    %rsp,%rbp
  801fee:	48 83 ec 10          	sub    $0x10,%rsp
  801ff2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ff5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ff9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802000:	48 98                	cltq   
  802002:	48 83 ec 08          	sub    $0x8,%rsp
  802006:	6a 00                	pushq  $0x0
  802008:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802014:	48 89 d1             	mov    %rdx,%rcx
  802017:	48 89 c2             	mov    %rax,%rdx
  80201a:	be 01 00 00 00       	mov    $0x1,%esi
  80201f:	bf 0a 00 00 00       	mov    $0xa,%edi
  802024:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  80202b:	00 00 00 
  80202e:	ff d0                	callq  *%rax
  802030:	48 83 c4 10          	add    $0x10,%rsp
}
  802034:	c9                   	leaveq 
  802035:	c3                   	retq   

0000000000802036 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802036:	55                   	push   %rbp
  802037:	48 89 e5             	mov    %rsp,%rbp
  80203a:	48 83 ec 20          	sub    $0x20,%rsp
  80203e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802041:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802045:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802049:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80204c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80204f:	48 63 f0             	movslq %eax,%rsi
  802052:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802056:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802059:	48 98                	cltq   
  80205b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205f:	48 83 ec 08          	sub    $0x8,%rsp
  802063:	6a 00                	pushq  $0x0
  802065:	49 89 f1             	mov    %rsi,%r9
  802068:	49 89 c8             	mov    %rcx,%r8
  80206b:	48 89 d1             	mov    %rdx,%rcx
  80206e:	48 89 c2             	mov    %rax,%rdx
  802071:	be 00 00 00 00       	mov    $0x0,%esi
  802076:	bf 0c 00 00 00       	mov    $0xc,%edi
  80207b:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	48 83 c4 10          	add    $0x10,%rsp
}
  80208b:	c9                   	leaveq 
  80208c:	c3                   	retq   

000000000080208d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80208d:	55                   	push   %rbp
  80208e:	48 89 e5             	mov    %rsp,%rbp
  802091:	48 83 ec 10          	sub    $0x10,%rsp
  802095:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80209d:	48 83 ec 08          	sub    $0x8,%rsp
  8020a1:	6a 00                	pushq  $0x0
  8020a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b4:	48 89 c2             	mov    %rax,%rdx
  8020b7:	be 01 00 00 00       	mov    $0x1,%esi
  8020bc:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020c1:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	callq  *%rax
  8020cd:	48 83 c4 10          	add    $0x10,%rsp
}
  8020d1:	c9                   	leaveq 
  8020d2:	c3                   	retq   

00000000008020d3 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8020d3:	55                   	push   %rbp
  8020d4:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020d7:	48 83 ec 08          	sub    $0x8,%rsp
  8020db:	6a 00                	pushq  $0x0
  8020dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f3:	be 00 00 00 00       	mov    $0x0,%esi
  8020f8:	bf 0e 00 00 00       	mov    $0xe,%edi
  8020fd:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  802104:	00 00 00 
  802107:	ff d0                	callq  *%rax
  802109:	48 83 c4 10          	add    $0x10,%rsp
}
  80210d:	c9                   	leaveq 
  80210e:	c3                   	retq   

000000000080210f <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  80210f:	55                   	push   %rbp
  802110:	48 89 e5             	mov    %rsp,%rbp
  802113:	48 83 ec 10          	sub    $0x10,%rsp
  802117:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80211b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  80211e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802125:	48 83 ec 08          	sub    $0x8,%rsp
  802129:	6a 00                	pushq  $0x0
  80212b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802131:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802137:	48 89 d1             	mov    %rdx,%rcx
  80213a:	48 89 c2             	mov    %rax,%rdx
  80213d:	be 00 00 00 00       	mov    $0x0,%esi
  802142:	bf 0f 00 00 00       	mov    $0xf,%edi
  802147:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  80214e:	00 00 00 
  802151:	ff d0                	callq  *%rax
  802153:	48 83 c4 10          	add    $0x10,%rsp
}
  802157:	c9                   	leaveq 
  802158:	c3                   	retq   

0000000000802159 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802159:	55                   	push   %rbp
  80215a:	48 89 e5             	mov    %rsp,%rbp
  80215d:	48 83 ec 10          	sub    $0x10,%rsp
  802161:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802165:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802168:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80216b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216f:	48 83 ec 08          	sub    $0x8,%rsp
  802173:	6a 00                	pushq  $0x0
  802175:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80217b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802181:	48 89 d1             	mov    %rdx,%rcx
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	be 00 00 00 00       	mov    $0x0,%esi
  80218c:	bf 10 00 00 00       	mov    $0x10,%edi
  802191:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  802198:	00 00 00 
  80219b:	ff d0                	callq  *%rax
  80219d:	48 83 c4 10          	add    $0x10,%rsp
}
  8021a1:	c9                   	leaveq 
  8021a2:	c3                   	retq   

00000000008021a3 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8021a3:	55                   	push   %rbp
  8021a4:	48 89 e5             	mov    %rsp,%rbp
  8021a7:	48 83 ec 20          	sub    $0x20,%rsp
  8021ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021b2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8021b5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8021b9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8021bd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8021c0:	48 63 c8             	movslq %eax,%rcx
  8021c3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8021c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021ca:	48 63 f0             	movslq %eax,%rsi
  8021cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d4:	48 98                	cltq   
  8021d6:	48 83 ec 08          	sub    $0x8,%rsp
  8021da:	51                   	push   %rcx
  8021db:	49 89 f9             	mov    %rdi,%r9
  8021de:	49 89 f0             	mov    %rsi,%r8
  8021e1:	48 89 d1             	mov    %rdx,%rcx
  8021e4:	48 89 c2             	mov    %rax,%rdx
  8021e7:	be 00 00 00 00       	mov    $0x0,%esi
  8021ec:	bf 11 00 00 00       	mov    $0x11,%edi
  8021f1:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
  8021fd:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802201:	c9                   	leaveq 
  802202:	c3                   	retq   

0000000000802203 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802203:	55                   	push   %rbp
  802204:	48 89 e5             	mov    %rsp,%rbp
  802207:	48 83 ec 10          	sub    $0x10,%rsp
  80220b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80220f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221b:	48 83 ec 08          	sub    $0x8,%rsp
  80221f:	6a 00                	pushq  $0x0
  802221:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802227:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80222d:	48 89 d1             	mov    %rdx,%rcx
  802230:	48 89 c2             	mov    %rax,%rdx
  802233:	be 00 00 00 00       	mov    $0x0,%esi
  802238:	bf 12 00 00 00       	mov    $0x12,%edi
  80223d:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  802244:	00 00 00 
  802247:	ff d0                	callq  *%rax
  802249:	48 83 c4 10          	add    $0x10,%rsp
}
  80224d:	c9                   	leaveq 
  80224e:	c3                   	retq   

000000000080224f <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  80224f:	55                   	push   %rbp
  802250:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802253:	48 83 ec 08          	sub    $0x8,%rsp
  802257:	6a 00                	pushq  $0x0
  802259:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80225f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802265:	b9 00 00 00 00       	mov    $0x0,%ecx
  80226a:	ba 00 00 00 00       	mov    $0x0,%edx
  80226f:	be 00 00 00 00       	mov    $0x0,%esi
  802274:	bf 13 00 00 00       	mov    $0x13,%edi
  802279:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
  802285:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  802289:	90                   	nop
  80228a:	c9                   	leaveq 
  80228b:	c3                   	retq   

000000000080228c <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  80228c:	55                   	push   %rbp
  80228d:	48 89 e5             	mov    %rsp,%rbp
  802290:	48 83 ec 10          	sub    $0x10,%rsp
  802294:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229a:	48 98                	cltq   
  80229c:	48 83 ec 08          	sub    $0x8,%rsp
  8022a0:	6a 00                	pushq  $0x0
  8022a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022b3:	48 89 c2             	mov    %rax,%rdx
  8022b6:	be 00 00 00 00       	mov    $0x0,%esi
  8022bb:	bf 14 00 00 00       	mov    $0x14,%edi
  8022c0:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	callq  *%rax
  8022cc:	48 83 c4 10          	add    $0x10,%rsp
}
  8022d0:	c9                   	leaveq 
  8022d1:	c3                   	retq   

00000000008022d2 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8022d2:	55                   	push   %rbp
  8022d3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8022d6:	48 83 ec 08          	sub    $0x8,%rsp
  8022da:	6a 00                	pushq  $0x0
  8022dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f2:	be 00 00 00 00       	mov    $0x0,%esi
  8022f7:	bf 15 00 00 00       	mov    $0x15,%edi
  8022fc:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
  802308:	48 83 c4 10          	add    $0x10,%rsp
}
  80230c:	c9                   	leaveq 
  80230d:	c3                   	retq   

000000000080230e <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  80230e:	55                   	push   %rbp
  80230f:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802312:	48 83 ec 08          	sub    $0x8,%rsp
  802316:	6a 00                	pushq  $0x0
  802318:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80231e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802324:	b9 00 00 00 00       	mov    $0x0,%ecx
  802329:	ba 00 00 00 00       	mov    $0x0,%edx
  80232e:	be 00 00 00 00       	mov    $0x0,%esi
  802333:	bf 16 00 00 00       	mov    $0x16,%edi
  802338:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	48 83 c4 10          	add    $0x10,%rsp
}
  802348:	90                   	nop
  802349:	c9                   	leaveq 
  80234a:	c3                   	retq   

000000000080234b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80234b:	55                   	push   %rbp
  80234c:	48 89 e5             	mov    %rsp,%rbp
  80234f:	48 83 ec 08          	sub    $0x8,%rsp
  802353:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802357:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80235b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802362:	ff ff ff 
  802365:	48 01 d0             	add    %rdx,%rax
  802368:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80236c:	c9                   	leaveq 
  80236d:	c3                   	retq   

000000000080236e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80236e:	55                   	push   %rbp
  80236f:	48 89 e5             	mov    %rsp,%rbp
  802372:	48 83 ec 08          	sub    $0x8,%rsp
  802376:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80237a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237e:	48 89 c7             	mov    %rax,%rdi
  802381:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
  80238d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802393:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802397:	c9                   	leaveq 
  802398:	c3                   	retq   

0000000000802399 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802399:	55                   	push   %rbp
  80239a:	48 89 e5             	mov    %rsp,%rbp
  80239d:	48 83 ec 18          	sub    $0x18,%rsp
  8023a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023ac:	eb 6b                	jmp    802419 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b1:	48 98                	cltq   
  8023b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8023bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c5:	48 c1 e8 15          	shr    $0x15,%rax
  8023c9:	48 89 c2             	mov    %rax,%rdx
  8023cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023d3:	01 00 00 
  8023d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023da:	83 e0 01             	and    $0x1,%eax
  8023dd:	48 85 c0             	test   %rax,%rax
  8023e0:	74 21                	je     802403 <fd_alloc+0x6a>
  8023e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ea:	48 89 c2             	mov    %rax,%rdx
  8023ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023f4:	01 00 00 
  8023f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023fb:	83 e0 01             	and    $0x1,%eax
  8023fe:	48 85 c0             	test   %rax,%rax
  802401:	75 12                	jne    802415 <fd_alloc+0x7c>
			*fd_store = fd;
  802403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802407:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80240b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
  802413:	eb 1a                	jmp    80242f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802415:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802419:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80241d:	7e 8f                	jle    8023ae <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80241f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802423:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80242a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80242f:	c9                   	leaveq 
  802430:	c3                   	retq   

0000000000802431 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802431:	55                   	push   %rbp
  802432:	48 89 e5             	mov    %rsp,%rbp
  802435:	48 83 ec 20          	sub    $0x20,%rsp
  802439:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80243c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802440:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802444:	78 06                	js     80244c <fd_lookup+0x1b>
  802446:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80244a:	7e 07                	jle    802453 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80244c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802451:	eb 6c                	jmp    8024bf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802453:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802456:	48 98                	cltq   
  802458:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80245e:	48 c1 e0 0c          	shl    $0xc,%rax
  802462:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246a:	48 c1 e8 15          	shr    $0x15,%rax
  80246e:	48 89 c2             	mov    %rax,%rdx
  802471:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802478:	01 00 00 
  80247b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247f:	83 e0 01             	and    $0x1,%eax
  802482:	48 85 c0             	test   %rax,%rax
  802485:	74 21                	je     8024a8 <fd_lookup+0x77>
  802487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248b:	48 c1 e8 0c          	shr    $0xc,%rax
  80248f:	48 89 c2             	mov    %rax,%rdx
  802492:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802499:	01 00 00 
  80249c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a0:	83 e0 01             	and    $0x1,%eax
  8024a3:	48 85 c0             	test   %rax,%rax
  8024a6:	75 07                	jne    8024af <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ad:	eb 10                	jmp    8024bf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024b7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bf:	c9                   	leaveq 
  8024c0:	c3                   	retq   

00000000008024c1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024c1:	55                   	push   %rbp
  8024c2:	48 89 e5             	mov    %rsp,%rbp
  8024c5:	48 83 ec 30          	sub    $0x30,%rsp
  8024c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024cd:	89 f0                	mov    %esi,%eax
  8024cf:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d6:	48 89 c7             	mov    %rax,%rdi
  8024d9:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	callq  *%rax
  8024e5:	89 c2                	mov    %eax,%edx
  8024e7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024eb:	48 89 c6             	mov    %rax,%rsi
  8024ee:	89 d7                	mov    %edx,%edi
  8024f0:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
  8024fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802503:	78 0a                	js     80250f <fd_close+0x4e>
	    || fd != fd2)
  802505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802509:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80250d:	74 12                	je     802521 <fd_close+0x60>
		return (must_exist ? r : 0);
  80250f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802513:	74 05                	je     80251a <fd_close+0x59>
  802515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802518:	eb 70                	jmp    80258a <fd_close+0xc9>
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	eb 69                	jmp    80258a <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802525:	8b 00                	mov    (%rax),%eax
  802527:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80252b:	48 89 d6             	mov    %rdx,%rsi
  80252e:	89 c7                	mov    %eax,%edi
  802530:	48 b8 8c 25 80 00 00 	movabs $0x80258c,%rax
  802537:	00 00 00 
  80253a:	ff d0                	callq  *%rax
  80253c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802543:	78 2a                	js     80256f <fd_close+0xae>
		if (dev->dev_close)
  802545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802549:	48 8b 40 20          	mov    0x20(%rax),%rax
  80254d:	48 85 c0             	test   %rax,%rax
  802550:	74 16                	je     802568 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802556:	48 8b 40 20          	mov    0x20(%rax),%rax
  80255a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80255e:	48 89 d7             	mov    %rdx,%rdi
  802561:	ff d0                	callq  *%rax
  802563:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802566:	eb 07                	jmp    80256f <fd_close+0xae>
		else
			r = 0;
  802568:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80256f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802573:	48 89 c6             	mov    %rax,%rsi
  802576:	bf 00 00 00 00       	mov    $0x0,%edi
  80257b:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax
	return r;
  802587:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80258a:	c9                   	leaveq 
  80258b:	c3                   	retq   

000000000080258c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80258c:	55                   	push   %rbp
  80258d:	48 89 e5             	mov    %rsp,%rbp
  802590:	48 83 ec 20          	sub    $0x20,%rsp
  802594:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802597:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80259b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a2:	eb 41                	jmp    8025e5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025a4:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8025ab:	00 00 00 
  8025ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025b1:	48 63 d2             	movslq %edx,%rdx
  8025b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b8:	8b 00                	mov    (%rax),%eax
  8025ba:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025bd:	75 22                	jne    8025e1 <dev_lookup+0x55>
			*dev = devtab[i];
  8025bf:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8025c6:	00 00 00 
  8025c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025cc:	48 63 d2             	movslq %edx,%rdx
  8025cf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	eb 60                	jmp    802641 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025e5:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8025ec:	00 00 00 
  8025ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025f2:	48 63 d2             	movslq %edx,%rdx
  8025f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f9:	48 85 c0             	test   %rax,%rax
  8025fc:	75 a6                	jne    8025a4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025fe:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802605:	00 00 00 
  802608:	48 8b 00             	mov    (%rax),%rax
  80260b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802611:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802614:	89 c6                	mov    %eax,%esi
  802616:	48 bf 38 56 80 00 00 	movabs $0x805638,%rdi
  80261d:	00 00 00 
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	48 b9 8d 09 80 00 00 	movabs $0x80098d,%rcx
  80262c:	00 00 00 
  80262f:	ff d1                	callq  *%rcx
	*dev = 0;
  802631:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802635:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80263c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802641:	c9                   	leaveq 
  802642:	c3                   	retq   

0000000000802643 <close>:

int
close(int fdnum)
{
  802643:	55                   	push   %rbp
  802644:	48 89 e5             	mov    %rsp,%rbp
  802647:	48 83 ec 20          	sub    $0x20,%rsp
  80264b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802652:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802655:	48 89 d6             	mov    %rdx,%rsi
  802658:	89 c7                	mov    %eax,%edi
  80265a:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax
  802666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266d:	79 05                	jns    802674 <close+0x31>
		return r;
  80266f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802672:	eb 18                	jmp    80268c <close+0x49>
	else
		return fd_close(fd, 1);
  802674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802678:	be 01 00 00 00       	mov    $0x1,%esi
  80267d:	48 89 c7             	mov    %rax,%rdi
  802680:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802687:	00 00 00 
  80268a:	ff d0                	callq  *%rax
}
  80268c:	c9                   	leaveq 
  80268d:	c3                   	retq   

000000000080268e <close_all>:

void
close_all(void)
{
  80268e:	55                   	push   %rbp
  80268f:	48 89 e5             	mov    %rsp,%rbp
  802692:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802696:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80269d:	eb 15                	jmp    8026b4 <close_all+0x26>
		close(i);
  80269f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a2:	89 c7                	mov    %eax,%edi
  8026a4:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8026ab:	00 00 00 
  8026ae:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026b8:	7e e5                	jle    80269f <close_all+0x11>
		close(i);
}
  8026ba:	90                   	nop
  8026bb:	c9                   	leaveq 
  8026bc:	c3                   	retq   

00000000008026bd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026bd:	55                   	push   %rbp
  8026be:	48 89 e5             	mov    %rsp,%rbp
  8026c1:	48 83 ec 40          	sub    $0x40,%rsp
  8026c5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026c8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026cb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026cf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026d2:	48 89 d6             	mov    %rdx,%rsi
  8026d5:	89 c7                	mov    %eax,%edi
  8026d7:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ea:	79 08                	jns    8026f4 <dup+0x37>
		return r;
  8026ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ef:	e9 70 01 00 00       	jmpq   802864 <dup+0x1a7>
	close(newfdnum);
  8026f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026f7:	89 c7                	mov    %eax,%edi
  8026f9:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802700:	00 00 00 
  802703:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802705:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802708:	48 98                	cltq   
  80270a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802710:	48 c1 e0 0c          	shl    $0xc,%rax
  802714:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271c:	48 89 c7             	mov    %rax,%rdi
  80271f:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
  80272b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80272f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802733:	48 89 c7             	mov    %rax,%rdi
  802736:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  80273d:	00 00 00 
  802740:	ff d0                	callq  *%rax
  802742:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274a:	48 c1 e8 15          	shr    $0x15,%rax
  80274e:	48 89 c2             	mov    %rax,%rdx
  802751:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802758:	01 00 00 
  80275b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80275f:	83 e0 01             	and    $0x1,%eax
  802762:	48 85 c0             	test   %rax,%rax
  802765:	74 71                	je     8027d8 <dup+0x11b>
  802767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276b:	48 c1 e8 0c          	shr    $0xc,%rax
  80276f:	48 89 c2             	mov    %rax,%rdx
  802772:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802779:	01 00 00 
  80277c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802780:	83 e0 01             	and    $0x1,%eax
  802783:	48 85 c0             	test   %rax,%rax
  802786:	74 50                	je     8027d8 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278c:	48 c1 e8 0c          	shr    $0xc,%rax
  802790:	48 89 c2             	mov    %rax,%rdx
  802793:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80279a:	01 00 00 
  80279d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8027a6:	89 c1                	mov    %eax,%ecx
  8027a8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	41 89 c8             	mov    %ecx,%r8d
  8027b3:	48 89 d1             	mov    %rdx,%rcx
  8027b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bb:	48 89 c6             	mov    %rax,%rsi
  8027be:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c3:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  8027ca:	00 00 00 
  8027cd:	ff d0                	callq  *%rax
  8027cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d6:	78 55                	js     80282d <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e0:	48 89 c2             	mov    %rax,%rdx
  8027e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ea:	01 00 00 
  8027ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8027f6:	89 c1                	mov    %eax,%ecx
  8027f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802800:	41 89 c8             	mov    %ecx,%r8d
  802803:	48 89 d1             	mov    %rdx,%rcx
  802806:	ba 00 00 00 00       	mov    $0x0,%edx
  80280b:	48 89 c6             	mov    %rax,%rsi
  80280e:	bf 00 00 00 00       	mov    $0x0,%edi
  802813:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
  80281f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802822:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802826:	78 08                	js     802830 <dup+0x173>
		goto err;

	return newfdnum;
  802828:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80282b:	eb 37                	jmp    802864 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80282d:	90                   	nop
  80282e:	eb 01                	jmp    802831 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802830:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802835:	48 89 c6             	mov    %rax,%rsi
  802838:	bf 00 00 00 00       	mov    $0x0,%edi
  80283d:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  802844:	00 00 00 
  802847:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802849:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284d:	48 89 c6             	mov    %rax,%rsi
  802850:	bf 00 00 00 00       	mov    $0x0,%edi
  802855:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  80285c:	00 00 00 
  80285f:	ff d0                	callq  *%rax
	return r;
  802861:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802864:	c9                   	leaveq 
  802865:	c3                   	retq   

0000000000802866 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 83 ec 40          	sub    $0x40,%rsp
  80286e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802871:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802875:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802879:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80287d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802880:	48 89 d6             	mov    %rdx,%rsi
  802883:	89 c7                	mov    %eax,%edi
  802885:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax
  802891:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802894:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802898:	78 24                	js     8028be <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80289a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289e:	8b 00                	mov    (%rax),%eax
  8028a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a4:	48 89 d6             	mov    %rdx,%rsi
  8028a7:	89 c7                	mov    %eax,%edi
  8028a9:	48 b8 8c 25 80 00 00 	movabs $0x80258c,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
  8028b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bc:	79 05                	jns    8028c3 <read+0x5d>
		return r;
  8028be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c1:	eb 76                	jmp    802939 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c7:	8b 40 08             	mov    0x8(%rax),%eax
  8028ca:	83 e0 03             	and    $0x3,%eax
  8028cd:	83 f8 01             	cmp    $0x1,%eax
  8028d0:	75 3a                	jne    80290c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028d2:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8028d9:	00 00 00 
  8028dc:	48 8b 00             	mov    (%rax),%rax
  8028df:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028e5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028e8:	89 c6                	mov    %eax,%esi
  8028ea:	48 bf 57 56 80 00 00 	movabs $0x805657,%rdi
  8028f1:	00 00 00 
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f9:	48 b9 8d 09 80 00 00 	movabs $0x80098d,%rcx
  802900:	00 00 00 
  802903:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802905:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80290a:	eb 2d                	jmp    802939 <read+0xd3>
	}
	if (!dev->dev_read)
  80290c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802910:	48 8b 40 10          	mov    0x10(%rax),%rax
  802914:	48 85 c0             	test   %rax,%rax
  802917:	75 07                	jne    802920 <read+0xba>
		return -E_NOT_SUPP;
  802919:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80291e:	eb 19                	jmp    802939 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802924:	48 8b 40 10          	mov    0x10(%rax),%rax
  802928:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80292c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802930:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802934:	48 89 cf             	mov    %rcx,%rdi
  802937:	ff d0                	callq  *%rax
}
  802939:	c9                   	leaveq 
  80293a:	c3                   	retq   

000000000080293b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80293b:	55                   	push   %rbp
  80293c:	48 89 e5             	mov    %rsp,%rbp
  80293f:	48 83 ec 30          	sub    $0x30,%rsp
  802943:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802946:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80294a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80294e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802955:	eb 47                	jmp    80299e <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295a:	48 98                	cltq   
  80295c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802960:	48 29 c2             	sub    %rax,%rdx
  802963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802966:	48 63 c8             	movslq %eax,%rcx
  802969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296d:	48 01 c1             	add    %rax,%rcx
  802970:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802973:	48 89 ce             	mov    %rcx,%rsi
  802976:	89 c7                	mov    %eax,%edi
  802978:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
  802984:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802987:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80298b:	79 05                	jns    802992 <readn+0x57>
			return m;
  80298d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802990:	eb 1d                	jmp    8029af <readn+0x74>
		if (m == 0)
  802992:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802996:	74 13                	je     8029ab <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802998:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80299b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80299e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a1:	48 98                	cltq   
  8029a3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029a7:	72 ae                	jb     802957 <readn+0x1c>
  8029a9:	eb 01                	jmp    8029ac <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8029ab:	90                   	nop
	}
	return tot;
  8029ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029af:	c9                   	leaveq 
  8029b0:	c3                   	retq   

00000000008029b1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029b1:	55                   	push   %rbp
  8029b2:	48 89 e5             	mov    %rsp,%rbp
  8029b5:	48 83 ec 40          	sub    $0x40,%rsp
  8029b9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029c0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cb:	48 89 d6             	mov    %rdx,%rsi
  8029ce:	89 c7                	mov    %eax,%edi
  8029d0:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
  8029dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e3:	78 24                	js     802a09 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e9:	8b 00                	mov    (%rax),%eax
  8029eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029ef:	48 89 d6             	mov    %rdx,%rsi
  8029f2:	89 c7                	mov    %eax,%edi
  8029f4:	48 b8 8c 25 80 00 00 	movabs $0x80258c,%rax
  8029fb:	00 00 00 
  8029fe:	ff d0                	callq  *%rax
  802a00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a07:	79 05                	jns    802a0e <write+0x5d>
		return r;
  802a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0c:	eb 75                	jmp    802a83 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a12:	8b 40 08             	mov    0x8(%rax),%eax
  802a15:	83 e0 03             	and    $0x3,%eax
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	75 3a                	jne    802a56 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a1c:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802a23:	00 00 00 
  802a26:	48 8b 00             	mov    (%rax),%rax
  802a29:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a32:	89 c6                	mov    %eax,%esi
  802a34:	48 bf 73 56 80 00 00 	movabs $0x805673,%rdi
  802a3b:	00 00 00 
  802a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a43:	48 b9 8d 09 80 00 00 	movabs $0x80098d,%rcx
  802a4a:	00 00 00 
  802a4d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a54:	eb 2d                	jmp    802a83 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a5e:	48 85 c0             	test   %rax,%rax
  802a61:	75 07                	jne    802a6a <write+0xb9>
		return -E_NOT_SUPP;
  802a63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a68:	eb 19                	jmp    802a83 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a72:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a7a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a7e:	48 89 cf             	mov    %rcx,%rdi
  802a81:	ff d0                	callq  *%rax
}
  802a83:	c9                   	leaveq 
  802a84:	c3                   	retq   

0000000000802a85 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a85:	55                   	push   %rbp
  802a86:	48 89 e5             	mov    %rsp,%rbp
  802a89:	48 83 ec 18          	sub    $0x18,%rsp
  802a8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a90:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a93:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a9a:	48 89 d6             	mov    %rdx,%rsi
  802a9d:	89 c7                	mov    %eax,%edi
  802a9f:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
  802aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab2:	79 05                	jns    802ab9 <seek+0x34>
		return r;
  802ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab7:	eb 0f                	jmp    802ac8 <seek+0x43>
	fd->fd_offset = offset;
  802ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac8:	c9                   	leaveq 
  802ac9:	c3                   	retq   

0000000000802aca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802aca:	55                   	push   %rbp
  802acb:	48 89 e5             	mov    %rsp,%rbp
  802ace:	48 83 ec 30          	sub    $0x30,%rsp
  802ad2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ad8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802adc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802adf:	48 89 d6             	mov    %rdx,%rsi
  802ae2:	89 c7                	mov    %eax,%edi
  802ae4:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
  802af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af7:	78 24                	js     802b1d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afd:	8b 00                	mov    (%rax),%eax
  802aff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b03:	48 89 d6             	mov    %rdx,%rsi
  802b06:	89 c7                	mov    %eax,%edi
  802b08:	48 b8 8c 25 80 00 00 	movabs $0x80258c,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	callq  *%rax
  802b14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1b:	79 05                	jns    802b22 <ftruncate+0x58>
		return r;
  802b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b20:	eb 72                	jmp    802b94 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b26:	8b 40 08             	mov    0x8(%rax),%eax
  802b29:	83 e0 03             	and    $0x3,%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	75 3a                	jne    802b6a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b30:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802b37:	00 00 00 
  802b3a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b3d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b43:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b46:	89 c6                	mov    %eax,%esi
  802b48:	48 bf 90 56 80 00 00 	movabs $0x805690,%rdi
  802b4f:	00 00 00 
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	48 b9 8d 09 80 00 00 	movabs $0x80098d,%rcx
  802b5e:	00 00 00 
  802b61:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b68:	eb 2a                	jmp    802b94 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b72:	48 85 c0             	test   %rax,%rax
  802b75:	75 07                	jne    802b7e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b77:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b7c:	eb 16                	jmp    802b94 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b82:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b8d:	89 ce                	mov    %ecx,%esi
  802b8f:	48 89 d7             	mov    %rdx,%rdi
  802b92:	ff d0                	callq  *%rax
}
  802b94:	c9                   	leaveq 
  802b95:	c3                   	retq   

0000000000802b96 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b96:	55                   	push   %rbp
  802b97:	48 89 e5             	mov    %rsp,%rbp
  802b9a:	48 83 ec 30          	sub    $0x30,%rsp
  802b9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ba1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bac:	48 89 d6             	mov    %rdx,%rsi
  802baf:	89 c7                	mov    %eax,%edi
  802bb1:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc4:	78 24                	js     802bea <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bca:	8b 00                	mov    (%rax),%eax
  802bcc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd0:	48 89 d6             	mov    %rdx,%rsi
  802bd3:	89 c7                	mov    %eax,%edi
  802bd5:	48 b8 8c 25 80 00 00 	movabs $0x80258c,%rax
  802bdc:	00 00 00 
  802bdf:	ff d0                	callq  *%rax
  802be1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be8:	79 05                	jns    802bef <fstat+0x59>
		return r;
  802bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bed:	eb 5e                	jmp    802c4d <fstat+0xb7>
	if (!dev->dev_stat)
  802bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bf7:	48 85 c0             	test   %rax,%rax
  802bfa:	75 07                	jne    802c03 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bfc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c01:	eb 4a                	jmp    802c4d <fstat+0xb7>
	stat->st_name[0] = 0;
  802c03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c07:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c0e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c15:	00 00 00 
	stat->st_isdir = 0;
  802c18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c1c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c23:	00 00 00 
	stat->st_dev = dev;
  802c26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c39:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c41:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c45:	48 89 ce             	mov    %rcx,%rsi
  802c48:	48 89 d7             	mov    %rdx,%rdi
  802c4b:	ff d0                	callq  *%rax
}
  802c4d:	c9                   	leaveq 
  802c4e:	c3                   	retq   

0000000000802c4f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c4f:	55                   	push   %rbp
  802c50:	48 89 e5             	mov    %rsp,%rbp
  802c53:	48 83 ec 20          	sub    $0x20,%rsp
  802c57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c63:	be 00 00 00 00       	mov    $0x0,%esi
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7e:	79 05                	jns    802c85 <stat+0x36>
		return fd;
  802c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c83:	eb 2f                	jmp    802cb4 <stat+0x65>
	r = fstat(fd, stat);
  802c85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8c:	48 89 d6             	mov    %rdx,%rsi
  802c8f:	89 c7                	mov    %eax,%edi
  802c91:	48 b8 96 2b 80 00 00 	movabs $0x802b96,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca3:	89 c7                	mov    %eax,%edi
  802ca5:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
	return r;
  802cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cb4:	c9                   	leaveq 
  802cb5:	c3                   	retq   

0000000000802cb6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cb6:	55                   	push   %rbp
  802cb7:	48 89 e5             	mov    %rsp,%rbp
  802cba:	48 83 ec 10          	sub    $0x10,%rsp
  802cbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cc5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ccc:	00 00 00 
  802ccf:	8b 00                	mov    (%rax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	75 1f                	jne    802cf4 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802cd5:	bf 01 00 00 00       	mov    $0x1,%edi
  802cda:	48 b8 9f 4e 80 00 00 	movabs $0x804e9f,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	callq  *%rax
  802ce6:	89 c2                	mov    %eax,%edx
  802ce8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802cef:	00 00 00 
  802cf2:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cf4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802cfb:	00 00 00 
  802cfe:	8b 00                	mov    (%rax),%eax
  802d00:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d03:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d08:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  802d0f:	00 00 00 
  802d12:	89 c7                	mov    %eax,%edi
  802d14:	48 b8 0a 4e 80 00 00 	movabs $0x804e0a,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d24:	ba 00 00 00 00       	mov    $0x0,%edx
  802d29:	48 89 c6             	mov    %rax,%rsi
  802d2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d31:	48 b8 49 4d 80 00 00 	movabs $0x804d49,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
}
  802d3d:	c9                   	leaveq 
  802d3e:	c3                   	retq   

0000000000802d3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d3f:	55                   	push   %rbp
  802d40:	48 89 e5             	mov    %rsp,%rbp
  802d43:	48 83 ec 20          	sub    $0x20,%rsp
  802d47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d4b:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802d4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d52:	48 89 c7             	mov    %rax,%rdi
  802d55:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	callq  *%rax
  802d61:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d66:	7e 0a                	jle    802d72 <open+0x33>
		return -E_BAD_PATH;
  802d68:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d6d:	e9 a5 00 00 00       	jmpq   802e17 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802d72:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d76:	48 89 c7             	mov    %rax,%rdi
  802d79:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
  802d85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8c:	79 08                	jns    802d96 <open+0x57>
		return r;
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	e9 81 00 00 00       	jmpq   802e17 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9a:	48 89 c6             	mov    %rax,%rsi
  802d9d:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802da4:	00 00 00 
  802da7:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802dae:	00 00 00 
  802db1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802db3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802dba:	00 00 00 
  802dbd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802dc0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	48 89 c6             	mov    %rax,%rsi
  802dcd:	bf 01 00 00 00       	mov    $0x1,%edi
  802dd2:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802dd9:	00 00 00 
  802ddc:	ff d0                	callq  *%rax
  802dde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de5:	79 1d                	jns    802e04 <open+0xc5>
		fd_close(fd, 0);
  802de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802deb:	be 00 00 00 00       	mov    $0x0,%esi
  802df0:	48 89 c7             	mov    %rax,%rdi
  802df3:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
		return r;
  802dff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e02:	eb 13                	jmp    802e17 <open+0xd8>
	}

	return fd2num(fd);
  802e04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e08:	48 89 c7             	mov    %rax,%rdi
  802e0b:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax

}
  802e17:	c9                   	leaveq 
  802e18:	c3                   	retq   

0000000000802e19 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e19:	55                   	push   %rbp
  802e1a:	48 89 e5             	mov    %rsp,%rbp
  802e1d:	48 83 ec 10          	sub    $0x10,%rsp
  802e21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e29:	8b 50 0c             	mov    0xc(%rax),%edx
  802e2c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e33:	00 00 00 
  802e36:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e38:	be 00 00 00 00       	mov    $0x0,%esi
  802e3d:	bf 06 00 00 00       	mov    $0x6,%edi
  802e42:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
}
  802e4e:	c9                   	leaveq 
  802e4f:	c3                   	retq   

0000000000802e50 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e50:	55                   	push   %rbp
  802e51:	48 89 e5             	mov    %rsp,%rbp
  802e54:	48 83 ec 30          	sub    $0x30,%rsp
  802e58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e68:	8b 50 0c             	mov    0xc(%rax),%edx
  802e6b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e72:	00 00 00 
  802e75:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e7e:	00 00 00 
  802e81:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e85:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e89:	be 00 00 00 00       	mov    $0x0,%esi
  802e8e:	bf 03 00 00 00       	mov    $0x3,%edi
  802e93:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802e9a:	00 00 00 
  802e9d:	ff d0                	callq  *%rax
  802e9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea6:	79 08                	jns    802eb0 <devfile_read+0x60>
		return r;
  802ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eab:	e9 a4 00 00 00       	jmpq   802f54 <devfile_read+0x104>
	assert(r <= n);
  802eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb3:	48 98                	cltq   
  802eb5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802eb9:	76 35                	jbe    802ef0 <devfile_read+0xa0>
  802ebb:	48 b9 b6 56 80 00 00 	movabs $0x8056b6,%rcx
  802ec2:	00 00 00 
  802ec5:	48 ba bd 56 80 00 00 	movabs $0x8056bd,%rdx
  802ecc:	00 00 00 
  802ecf:	be 86 00 00 00       	mov    $0x86,%esi
  802ed4:	48 bf d2 56 80 00 00 	movabs $0x8056d2,%rdi
  802edb:	00 00 00 
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee3:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  802eea:	00 00 00 
  802eed:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802ef0:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802ef7:	7e 35                	jle    802f2e <devfile_read+0xde>
  802ef9:	48 b9 dd 56 80 00 00 	movabs $0x8056dd,%rcx
  802f00:	00 00 00 
  802f03:	48 ba bd 56 80 00 00 	movabs $0x8056bd,%rdx
  802f0a:	00 00 00 
  802f0d:	be 87 00 00 00       	mov    $0x87,%esi
  802f12:	48 bf d2 56 80 00 00 	movabs $0x8056d2,%rdi
  802f19:	00 00 00 
  802f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f21:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  802f28:	00 00 00 
  802f2b:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f31:	48 63 d0             	movslq %eax,%rdx
  802f34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f38:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802f3f:	00 00 00 
  802f42:	48 89 c7             	mov    %rax,%rdi
  802f45:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
	return r;
  802f51:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802f54:	c9                   	leaveq 
  802f55:	c3                   	retq   

0000000000802f56 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f56:	55                   	push   %rbp
  802f57:	48 89 e5             	mov    %rsp,%rbp
  802f5a:	48 83 ec 40          	sub    $0x40,%rsp
  802f5e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f62:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f66:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802f6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802f72:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802f79:	00 
  802f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802f82:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802f87:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8f:	8b 50 0c             	mov    0xc(%rax),%edx
  802f92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802f99:	00 00 00 
  802f9c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f9e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802fa5:	00 00 00 
  802fa8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fac:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802fb0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb8:	48 89 c6             	mov    %rax,%rsi
  802fbb:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  802fc2:	00 00 00 
  802fc5:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802fd1:	be 00 00 00 00       	mov    $0x0,%esi
  802fd6:	bf 04 00 00 00       	mov    $0x4,%edi
  802fdb:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fee:	79 05                	jns    802ff5 <devfile_write+0x9f>
		return r;
  802ff0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff3:	eb 43                	jmp    803038 <devfile_write+0xe2>
	assert(r <= n);
  802ff5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff8:	48 98                	cltq   
  802ffa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ffe:	76 35                	jbe    803035 <devfile_write+0xdf>
  803000:	48 b9 b6 56 80 00 00 	movabs $0x8056b6,%rcx
  803007:	00 00 00 
  80300a:	48 ba bd 56 80 00 00 	movabs $0x8056bd,%rdx
  803011:	00 00 00 
  803014:	be a2 00 00 00       	mov    $0xa2,%esi
  803019:	48 bf d2 56 80 00 00 	movabs $0x8056d2,%rdi
  803020:	00 00 00 
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
  803028:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  80302f:	00 00 00 
  803032:	41 ff d0             	callq  *%r8
	return r;
  803035:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803038:	c9                   	leaveq 
  803039:	c3                   	retq   

000000000080303a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80303a:	55                   	push   %rbp
  80303b:	48 89 e5             	mov    %rsp,%rbp
  80303e:	48 83 ec 20          	sub    $0x20,%rsp
  803042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80304a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304e:	8b 50 0c             	mov    0xc(%rax),%edx
  803051:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803058:	00 00 00 
  80305b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80305d:	be 00 00 00 00       	mov    $0x0,%esi
  803062:	bf 05 00 00 00       	mov    $0x5,%edi
  803067:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  80306e:	00 00 00 
  803071:	ff d0                	callq  *%rax
  803073:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803076:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307a:	79 05                	jns    803081 <devfile_stat+0x47>
		return r;
  80307c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307f:	eb 56                	jmp    8030d7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803081:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803085:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80308c:	00 00 00 
  80308f:	48 89 c7             	mov    %rax,%rdi
  803092:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803099:	00 00 00 
  80309c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80309e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8030a5:	00 00 00 
  8030a8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030b8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8030bf:	00 00 00 
  8030c2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030cc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d7:	c9                   	leaveq 
  8030d8:	c3                   	retq   

00000000008030d9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030d9:	55                   	push   %rbp
  8030da:	48 89 e5             	mov    %rsp,%rbp
  8030dd:	48 83 ec 10          	sub    $0x10,%rsp
  8030e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030e5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8030f6:	00 00 00 
  8030f9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030fb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803102:	00 00 00 
  803105:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80310b:	be 00 00 00 00       	mov    $0x0,%esi
  803110:	bf 02 00 00 00       	mov    $0x2,%edi
  803115:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
}
  803121:	c9                   	leaveq 
  803122:	c3                   	retq   

0000000000803123 <remove>:

// Delete a file
int
remove(const char *path)
{
  803123:	55                   	push   %rbp
  803124:	48 89 e5             	mov    %rsp,%rbp
  803127:	48 83 ec 10          	sub    $0x10,%rsp
  80312b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80312f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803133:	48 89 c7             	mov    %rax,%rdi
  803136:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
  803142:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803147:	7e 07                	jle    803150 <remove+0x2d>
		return -E_BAD_PATH;
  803149:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80314e:	eb 33                	jmp    803183 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803150:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803154:	48 89 c6             	mov    %rax,%rsi
  803157:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  80315e:	00 00 00 
  803161:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80316d:	be 00 00 00 00       	mov    $0x0,%esi
  803172:	bf 07 00 00 00       	mov    $0x7,%edi
  803177:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  80317e:	00 00 00 
  803181:	ff d0                	callq  *%rax
}
  803183:	c9                   	leaveq 
  803184:	c3                   	retq   

0000000000803185 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803185:	55                   	push   %rbp
  803186:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803189:	be 00 00 00 00       	mov    $0x0,%esi
  80318e:	bf 08 00 00 00       	mov    $0x8,%edi
  803193:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
}
  80319f:	5d                   	pop    %rbp
  8031a0:	c3                   	retq   

00000000008031a1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8031ac:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8031b3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8031ba:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8031c1:	be 00 00 00 00       	mov    $0x0,%esi
  8031c6:	48 89 c7             	mov    %rax,%rdi
  8031c9:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
  8031d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8031d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031dc:	79 28                	jns    803206 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8031de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e1:	89 c6                	mov    %eax,%esi
  8031e3:	48 bf e9 56 80 00 00 	movabs $0x8056e9,%rdi
  8031ea:	00 00 00 
  8031ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f2:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  8031f9:	00 00 00 
  8031fc:	ff d2                	callq  *%rdx
		return fd_src;
  8031fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803201:	e9 76 01 00 00       	jmpq   80337c <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803206:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80320d:	be 01 01 00 00       	mov    $0x101,%esi
  803212:	48 89 c7             	mov    %rax,%rdi
  803215:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	callq  *%rax
  803221:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803224:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803228:	0f 89 ad 00 00 00    	jns    8032db <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80322e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803231:	89 c6                	mov    %eax,%esi
  803233:	48 bf ff 56 80 00 00 	movabs $0x8056ff,%rdi
  80323a:	00 00 00 
  80323d:	b8 00 00 00 00       	mov    $0x0,%eax
  803242:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  803249:	00 00 00 
  80324c:	ff d2                	callq  *%rdx
		close(fd_src);
  80324e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803251:	89 c7                	mov    %eax,%edi
  803253:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
		return fd_dest;
  80325f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803262:	e9 15 01 00 00       	jmpq   80337c <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803267:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80326a:	48 63 d0             	movslq %eax,%rdx
  80326d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803274:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803277:	48 89 ce             	mov    %rcx,%rsi
  80327a:	89 c7                	mov    %eax,%edi
  80327c:	48 b8 b1 29 80 00 00 	movabs $0x8029b1,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80328b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80328f:	79 4a                	jns    8032db <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803291:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803294:	89 c6                	mov    %eax,%esi
  803296:	48 bf 19 57 80 00 00 	movabs $0x805719,%rdi
  80329d:	00 00 00 
  8032a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a5:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  8032ac:	00 00 00 
  8032af:	ff d2                	callq  *%rdx
			close(fd_src);
  8032b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b4:	89 c7                	mov    %eax,%edi
  8032b6:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8032bd:	00 00 00 
  8032c0:	ff d0                	callq  *%rax
			close(fd_dest);
  8032c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032c5:	89 c7                	mov    %eax,%edi
  8032c7:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
			return write_size;
  8032d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032d6:	e9 a1 00 00 00       	jmpq   80337c <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032db:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e5:	ba 00 02 00 00       	mov    $0x200,%edx
  8032ea:	48 89 ce             	mov    %rcx,%rsi
  8032ed:	89 c7                	mov    %eax,%edi
  8032ef:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
  8032fb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803302:	0f 8f 5f ff ff ff    	jg     803267 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803308:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80330c:	79 47                	jns    803355 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80330e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803311:	89 c6                	mov    %eax,%esi
  803313:	48 bf 2c 57 80 00 00 	movabs $0x80572c,%rdi
  80331a:	00 00 00 
  80331d:	b8 00 00 00 00       	mov    $0x0,%eax
  803322:	48 ba 8d 09 80 00 00 	movabs $0x80098d,%rdx
  803329:	00 00 00 
  80332c:	ff d2                	callq  *%rdx
		close(fd_src);
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	89 c7                	mov    %eax,%edi
  803333:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
		close(fd_dest);
  80333f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803342:	89 c7                	mov    %eax,%edi
  803344:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
		return read_size;
  803350:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803353:	eb 27                	jmp    80337c <copy+0x1db>
	}
	close(fd_src);
  803355:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803358:	89 c7                	mov    %eax,%edi
  80335a:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
	close(fd_dest);
  803366:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803369:	89 c7                	mov    %eax,%edi
  80336b:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  803372:	00 00 00 
  803375:	ff d0                	callq  *%rax
	return 0;
  803377:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80337c:	c9                   	leaveq 
  80337d:	c3                   	retq   

000000000080337e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80337e:	55                   	push   %rbp
  80337f:	48 89 e5             	mov    %rsp,%rbp
  803382:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  803389:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803390:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803397:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80339e:	be 00 00 00 00       	mov    $0x0,%esi
  8033a3:	48 89 c7             	mov    %rax,%rdi
  8033a6:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
  8033b2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033b9:	79 08                	jns    8033c3 <spawn+0x45>
		return r;
  8033bb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033be:	e9 11 03 00 00       	jmpq   8036d4 <spawn+0x356>
	fd = r;
  8033c3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033c6:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8033c9:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8033d0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8033d4:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8033db:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033de:	ba 00 02 00 00       	mov    $0x200,%edx
  8033e3:	48 89 ce             	mov    %rcx,%rsi
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 3b 29 80 00 00 	movabs $0x80293b,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8033f9:	75 0d                	jne    803408 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8033fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ff:	8b 00                	mov    (%rax),%eax
  803401:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803406:	74 43                	je     80344b <spawn+0xcd>
		close(fd);
  803408:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80340b:	89 c7                	mov    %eax,%edi
  80340d:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  803414:	00 00 00 
  803417:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803419:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341d:	8b 00                	mov    (%rax),%eax
  80341f:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803424:	89 c6                	mov    %eax,%esi
  803426:	48 bf 48 57 80 00 00 	movabs $0x805748,%rdi
  80342d:	00 00 00 
  803430:	b8 00 00 00 00       	mov    $0x0,%eax
  803435:	48 b9 8d 09 80 00 00 	movabs $0x80098d,%rcx
  80343c:	00 00 00 
  80343f:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803441:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803446:	e9 89 02 00 00       	jmpq   8036d4 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80344b:	b8 07 00 00 00       	mov    $0x7,%eax
  803450:	cd 30                	int    $0x30
  803452:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803455:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803458:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80345b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80345f:	79 08                	jns    803469 <spawn+0xeb>
		return r;
  803461:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803464:	e9 6b 02 00 00       	jmpq   8036d4 <spawn+0x356>
	child = r;
  803469:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80346c:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80346f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803472:	25 ff 03 00 00       	and    $0x3ff,%eax
  803477:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80347e:	00 00 00 
  803481:	48 98                	cltq   
  803483:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80348a:	48 01 c2             	add    %rax,%rdx
  80348d:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803494:	48 89 d6             	mov    %rdx,%rsi
  803497:	ba 18 00 00 00       	mov    $0x18,%edx
  80349c:	48 89 c7             	mov    %rax,%rdi
  80349f:	48 89 d1             	mov    %rdx,%rcx
  8034a2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8034a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034a9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8034ad:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8034b4:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8034bb:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8034c2:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8034c9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034cc:	48 89 ce             	mov    %rcx,%rsi
  8034cf:	89 c7                	mov    %eax,%edi
  8034d1:	48 b8 38 39 80 00 00 	movabs $0x803938,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
  8034dd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034e4:	79 08                	jns    8034ee <spawn+0x170>
		return r;
  8034e6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034e9:	e9 e6 01 00 00       	jmpq   8036d4 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8034ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8034f6:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8034fd:	48 01 d0             	add    %rdx,%rax
  803500:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803504:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80350b:	e9 80 00 00 00       	jmpq   803590 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  803510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803514:	8b 00                	mov    (%rax),%eax
  803516:	83 f8 01             	cmp    $0x1,%eax
  803519:	75 6b                	jne    803586 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  80351b:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803526:	8b 40 04             	mov    0x4(%rax),%eax
  803529:	83 e0 02             	and    $0x2,%eax
  80352c:	85 c0                	test   %eax,%eax
  80352e:	74 04                	je     803534 <spawn+0x1b6>
			perm |= PTE_W;
  803530:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803538:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80353c:	41 89 c1             	mov    %eax,%r9d
  80353f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803543:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80354f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803553:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803557:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80355a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80355d:	48 83 ec 08          	sub    $0x8,%rsp
  803561:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803564:	57                   	push   %rdi
  803565:	89 c7                	mov    %eax,%edi
  803567:	48 b8 e4 3b 80 00 00 	movabs $0x803be4,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	48 83 c4 10          	add    $0x10,%rsp
  803577:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80357a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80357e:	0f 88 2a 01 00 00    	js     8036ae <spawn+0x330>
  803584:	eb 01                	jmp    803587 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803586:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803587:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80358b:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803594:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803598:	0f b7 c0             	movzwl %ax,%eax
  80359b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80359e:	0f 8f 6c ff ff ff    	jg     803510 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8035a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8035a7:	89 c7                	mov    %eax,%edi
  8035a9:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8035b0:	00 00 00 
  8035b3:	ff d0                	callq  *%rax
	fd = -1;
  8035b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8035bc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035bf:	89 c7                	mov    %eax,%edi
  8035c1:	48 b8 d0 3d 80 00 00 	movabs $0x803dd0,%rax
  8035c8:	00 00 00 
  8035cb:	ff d0                	callq  *%rax
  8035cd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035d4:	79 30                	jns    803606 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  8035d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035d9:	89 c1                	mov    %eax,%ecx
  8035db:	48 ba 62 57 80 00 00 	movabs $0x805762,%rdx
  8035e2:	00 00 00 
  8035e5:	be 86 00 00 00       	mov    $0x86,%esi
  8035ea:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  8035f1:	00 00 00 
  8035f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f9:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803600:	00 00 00 
  803603:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803606:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80360d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803610:	48 89 d6             	mov    %rdx,%rsi
  803613:	89 c7                	mov    %eax,%edi
  803615:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  80361c:	00 00 00 
  80361f:	ff d0                	callq  *%rax
  803621:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803624:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803628:	79 30                	jns    80365a <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  80362a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80362d:	89 c1                	mov    %eax,%ecx
  80362f:	48 ba 84 57 80 00 00 	movabs $0x805784,%rdx
  803636:	00 00 00 
  803639:	be 8a 00 00 00       	mov    $0x8a,%esi
  80363e:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  803645:	00 00 00 
  803648:	b8 00 00 00 00       	mov    $0x0,%eax
  80364d:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803654:	00 00 00 
  803657:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80365a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80365d:	be 02 00 00 00       	mov    $0x2,%esi
  803662:	89 c7                	mov    %eax,%edi
  803664:	48 b8 51 1f 80 00 00 	movabs $0x801f51,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
  803670:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803673:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803677:	79 30                	jns    8036a9 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  803679:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80367c:	89 c1                	mov    %eax,%ecx
  80367e:	48 ba 9e 57 80 00 00 	movabs $0x80579e,%rdx
  803685:	00 00 00 
  803688:	be 8d 00 00 00       	mov    $0x8d,%esi
  80368d:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  803694:	00 00 00 
  803697:	b8 00 00 00 00       	mov    $0x0,%eax
  80369c:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  8036a3:	00 00 00 
  8036a6:	41 ff d0             	callq  *%r8

	return child;
  8036a9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036ac:	eb 26                	jmp    8036d4 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8036ae:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8036af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036b2:	89 c7                	mov    %eax,%edi
  8036b4:	48 b8 94 1d 80 00 00 	movabs $0x801d94,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
	close(fd);
  8036c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036c3:	89 c7                	mov    %eax,%edi
  8036c5:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
	return r;
  8036d1:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  8036d4:	c9                   	leaveq 
  8036d5:	c3                   	retq   

00000000008036d6 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8036d6:	55                   	push   %rbp
  8036d7:	48 89 e5             	mov    %rsp,%rbp
  8036da:	41 55                	push   %r13
  8036dc:	41 54                	push   %r12
  8036de:	53                   	push   %rbx
  8036df:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8036e6:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8036ed:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  8036f4:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8036fb:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803702:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803709:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803710:	84 c0                	test   %al,%al
  803712:	74 26                	je     80373a <spawnl+0x64>
  803714:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80371b:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803722:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803726:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80372a:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80372e:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803732:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803736:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80373a:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803741:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803744:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80374b:	00 00 00 
  80374e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803755:	00 00 00 
  803758:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80375c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803763:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80376a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803771:	eb 07                	jmp    80377a <spawnl+0xa4>
		argc++;
  803773:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80377a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803780:	83 f8 30             	cmp    $0x30,%eax
  803783:	73 23                	jae    8037a8 <spawnl+0xd2>
  803785:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80378c:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803792:	89 d2                	mov    %edx,%edx
  803794:	48 01 d0             	add    %rdx,%rax
  803797:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80379d:	83 c2 08             	add    $0x8,%edx
  8037a0:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8037a6:	eb 12                	jmp    8037ba <spawnl+0xe4>
  8037a8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8037af:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8037b3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8037ba:	48 8b 00             	mov    (%rax),%rax
  8037bd:	48 85 c0             	test   %rax,%rax
  8037c0:	75 b1                	jne    803773 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8037c2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8037c8:	83 c0 02             	add    $0x2,%eax
  8037cb:	48 89 e2             	mov    %rsp,%rdx
  8037ce:	48 89 d3             	mov    %rdx,%rbx
  8037d1:	48 63 d0             	movslq %eax,%rdx
  8037d4:	48 83 ea 01          	sub    $0x1,%rdx
  8037d8:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8037df:	48 63 d0             	movslq %eax,%rdx
  8037e2:	49 89 d4             	mov    %rdx,%r12
  8037e5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8037eb:	48 63 d0             	movslq %eax,%rdx
  8037ee:	49 89 d2             	mov    %rdx,%r10
  8037f1:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8037f7:	48 98                	cltq   
  8037f9:	48 c1 e0 03          	shl    $0x3,%rax
  8037fd:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803801:	b8 10 00 00 00       	mov    $0x10,%eax
  803806:	48 83 e8 01          	sub    $0x1,%rax
  80380a:	48 01 d0             	add    %rdx,%rax
  80380d:	be 10 00 00 00       	mov    $0x10,%esi
  803812:	ba 00 00 00 00       	mov    $0x0,%edx
  803817:	48 f7 f6             	div    %rsi
  80381a:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80381e:	48 29 c4             	sub    %rax,%rsp
  803821:	48 89 e0             	mov    %rsp,%rax
  803824:	48 83 c0 07          	add    $0x7,%rax
  803828:	48 c1 e8 03          	shr    $0x3,%rax
  80382c:	48 c1 e0 03          	shl    $0x3,%rax
  803830:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803837:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80383e:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803845:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803848:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80384e:	8d 50 01             	lea    0x1(%rax),%edx
  803851:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803858:	48 63 d2             	movslq %edx,%rdx
  80385b:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803862:	00 

	va_start(vl, arg0);
  803863:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80386a:	00 00 00 
  80386d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803874:	00 00 00 
  803877:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80387b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803882:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803889:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803890:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803897:	00 00 00 
  80389a:	eb 60                	jmp    8038fc <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  80389c:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8038a2:	8d 48 01             	lea    0x1(%rax),%ecx
  8038a5:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8038ab:	83 f8 30             	cmp    $0x30,%eax
  8038ae:	73 23                	jae    8038d3 <spawnl+0x1fd>
  8038b0:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8038b7:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8038bd:	89 d2                	mov    %edx,%edx
  8038bf:	48 01 d0             	add    %rdx,%rax
  8038c2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8038c8:	83 c2 08             	add    $0x8,%edx
  8038cb:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8038d1:	eb 12                	jmp    8038e5 <spawnl+0x20f>
  8038d3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8038da:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8038de:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8038e5:	48 8b 10             	mov    (%rax),%rdx
  8038e8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8038ef:	89 c9                	mov    %ecx,%ecx
  8038f1:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8038f5:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8038fc:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803902:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  803908:	72 92                	jb     80389c <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80390a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803911:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803918:	48 89 d6             	mov    %rdx,%rsi
  80391b:	48 89 c7             	mov    %rax,%rdi
  80391e:	48 b8 7e 33 80 00 00 	movabs $0x80337e,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
  80392a:	48 89 dc             	mov    %rbx,%rsp
}
  80392d:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803931:	5b                   	pop    %rbx
  803932:	41 5c                	pop    %r12
  803934:	41 5d                	pop    %r13
  803936:	5d                   	pop    %rbp
  803937:	c3                   	retq   

0000000000803938 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803938:	55                   	push   %rbp
  803939:	48 89 e5             	mov    %rsp,%rbp
  80393c:	48 83 ec 50          	sub    $0x50,%rsp
  803940:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803943:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803947:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80394b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803952:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80395a:	eb 33                	jmp    80398f <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80395c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80395f:	48 98                	cltq   
  803961:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803968:	00 
  803969:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80396d:	48 01 d0             	add    %rdx,%rax
  803970:	48 8b 00             	mov    (%rax),%rax
  803973:	48 89 c7             	mov    %rax,%rdi
  803976:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
  803982:	83 c0 01             	add    $0x1,%eax
  803985:	48 98                	cltq   
  803987:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80398b:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80398f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803992:	48 98                	cltq   
  803994:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80399b:	00 
  80399c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8039a0:	48 01 d0             	add    %rdx,%rax
  8039a3:	48 8b 00             	mov    (%rax),%rax
  8039a6:	48 85 c0             	test   %rax,%rax
  8039a9:	75 b1                	jne    80395c <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8039ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039af:	48 f7 d8             	neg    %rax
  8039b2:	48 05 00 10 40 00    	add    $0x401000,%rax
  8039b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8039bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8039c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c8:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8039cc:	48 89 c2             	mov    %rax,%rdx
  8039cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039d2:	83 c0 01             	add    $0x1,%eax
  8039d5:	c1 e0 03             	shl    $0x3,%eax
  8039d8:	48 98                	cltq   
  8039da:	48 f7 d8             	neg    %rax
  8039dd:	48 01 d0             	add    %rdx,%rax
  8039e0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8039e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e8:	48 83 e8 10          	sub    $0x10,%rax
  8039ec:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8039f2:	77 0a                	ja     8039fe <init_stack+0xc6>
		return -E_NO_MEM;
  8039f4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8039f9:	e9 e4 01 00 00       	jmpq   803be2 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8039fe:	ba 07 00 00 00       	mov    $0x7,%edx
  803a03:	be 00 00 40 00       	mov    $0x400000,%esi
  803a08:	bf 00 00 00 00       	mov    $0x0,%edi
  803a0d:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  803a14:	00 00 00 
  803a17:	ff d0                	callq  *%rax
  803a19:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a20:	79 08                	jns    803a2a <init_stack+0xf2>
		return r;
  803a22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a25:	e9 b8 01 00 00       	jmpq   803be2 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803a2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803a31:	e9 8a 00 00 00       	jmpq   803ac0 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  803a36:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a39:	48 98                	cltq   
  803a3b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a42:	00 
  803a43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a47:	48 01 d0             	add    %rdx,%rax
  803a4a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a53:	48 01 ca             	add    %rcx,%rdx
  803a56:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803a5d:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803a60:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a63:	48 98                	cltq   
  803a65:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a6c:	00 
  803a6d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a71:	48 01 d0             	add    %rdx,%rax
  803a74:	48 8b 10             	mov    (%rax),%rdx
  803a77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7b:	48 89 d6             	mov    %rdx,%rsi
  803a7e:	48 89 c7             	mov    %rax,%rdi
  803a81:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803a88:	00 00 00 
  803a8b:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803a8d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a90:	48 98                	cltq   
  803a92:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a99:	00 
  803a9a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a9e:	48 01 d0             	add    %rdx,%rax
  803aa1:	48 8b 00             	mov    (%rax),%rax
  803aa4:	48 89 c7             	mov    %rax,%rdi
  803aa7:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  803aae:	00 00 00 
  803ab1:	ff d0                	callq  *%rax
  803ab3:	83 c0 01             	add    $0x1,%eax
  803ab6:	48 98                	cltq   
  803ab8:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803abc:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803ac0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ac3:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803ac6:	0f 8c 6a ff ff ff    	jl     803a36 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803acc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803acf:	48 98                	cltq   
  803ad1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ad8:	00 
  803ad9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803add:	48 01 d0             	add    %rdx,%rax
  803ae0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803ae7:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803aee:	00 
  803aef:	74 35                	je     803b26 <init_stack+0x1ee>
  803af1:	48 b9 b8 57 80 00 00 	movabs $0x8057b8,%rcx
  803af8:	00 00 00 
  803afb:	48 ba de 57 80 00 00 	movabs $0x8057de,%rdx
  803b02:	00 00 00 
  803b05:	be f6 00 00 00       	mov    $0xf6,%esi
  803b0a:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  803b11:	00 00 00 
  803b14:	b8 00 00 00 00       	mov    $0x0,%eax
  803b19:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803b20:	00 00 00 
  803b23:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803b26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2a:	48 83 e8 08          	sub    $0x8,%rax
  803b2e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b33:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803b37:	48 01 ca             	add    %rcx,%rdx
  803b3a:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803b41:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  803b44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b48:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803b4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b4f:	48 98                	cltq   
  803b51:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803b54:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803b59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b5d:	48 01 d0             	add    %rdx,%rax
  803b60:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803b66:	48 89 c2             	mov    %rax,%rdx
  803b69:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803b6d:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803b70:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b73:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803b79:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b7e:	89 c2                	mov    %eax,%edx
  803b80:	be 00 00 40 00       	mov    $0x400000,%esi
  803b85:	bf 00 00 00 00       	mov    $0x0,%edi
  803b8a:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b9d:	78 26                	js     803bc5 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803b9f:	be 00 00 40 00       	mov    $0x400000,%esi
  803ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba9:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  803bb0:	00 00 00 
  803bb3:	ff d0                	callq  *%rax
  803bb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bbc:	78 0a                	js     803bc8 <init_stack+0x290>
		goto error;

	return 0;
  803bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc3:	eb 1d                	jmp    803be2 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803bc5:	90                   	nop
  803bc6:	eb 01                	jmp    803bc9 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803bc8:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803bc9:	be 00 00 40 00       	mov    $0x400000,%esi
  803bce:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd3:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
	return r;
  803bdf:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803be2:	c9                   	leaveq 
  803be3:	c3                   	retq   

0000000000803be4 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803be4:	55                   	push   %rbp
  803be5:	48 89 e5             	mov    %rsp,%rbp
  803be8:	48 83 ec 50          	sub    $0x50,%rsp
  803bec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803bef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bf3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803bf7:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803bfa:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803bfe:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803c02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c06:	25 ff 0f 00 00       	and    $0xfff,%eax
  803c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c12:	74 21                	je     803c35 <map_segment+0x51>
		va -= i;
  803c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c17:	48 98                	cltq   
  803c19:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c20:	48 98                	cltq   
  803c22:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c29:	48 98                	cltq   
  803c2b:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c32:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803c35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c3c:	e9 79 01 00 00       	jmpq   803dba <map_segment+0x1d6>
		if (i >= filesz) {
  803c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c44:	48 98                	cltq   
  803c46:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803c4a:	72 3c                	jb     803c88 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4f:	48 63 d0             	movslq %eax,%rdx
  803c52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c56:	48 01 d0             	add    %rdx,%rax
  803c59:	48 89 c1             	mov    %rax,%rcx
  803c5c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c5f:	8b 55 10             	mov    0x10(%rbp),%edx
  803c62:	48 89 ce             	mov    %rcx,%rsi
  803c65:	89 c7                	mov    %eax,%edi
  803c67:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
  803c73:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c7a:	0f 89 33 01 00 00    	jns    803db3 <map_segment+0x1cf>
				return r;
  803c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c83:	e9 46 01 00 00       	jmpq   803dce <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803c88:	ba 07 00 00 00       	mov    $0x7,%edx
  803c8d:	be 00 00 40 00       	mov    $0x400000,%esi
  803c92:	bf 00 00 00 00       	mov    $0x0,%edi
  803c97:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
  803ca3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ca6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803caa:	79 08                	jns    803cb4 <map_segment+0xd0>
				return r;
  803cac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803caf:	e9 1a 01 00 00       	jmpq   803dce <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803cb4:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cba:	01 c2                	add    %eax,%edx
  803cbc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803cbf:	89 d6                	mov    %edx,%esi
  803cc1:	89 c7                	mov    %eax,%edi
  803cc3:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
  803ccf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803cd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803cd6:	79 08                	jns    803ce0 <map_segment+0xfc>
				return r;
  803cd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cdb:	e9 ee 00 00 00       	jmpq   803dce <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803ce0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cea:	48 98                	cltq   
  803cec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803cf0:	48 29 c2             	sub    %rax,%rdx
  803cf3:	48 89 d0             	mov    %rdx,%rax
  803cf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803cfa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803cfd:	48 63 d0             	movslq %eax,%rdx
  803d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d04:	48 39 c2             	cmp    %rax,%rdx
  803d07:	48 0f 47 d0          	cmova  %rax,%rdx
  803d0b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803d0e:	be 00 00 40 00       	mov    $0x400000,%esi
  803d13:	89 c7                	mov    %eax,%edi
  803d15:	48 b8 3b 29 80 00 00 	movabs $0x80293b,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
  803d21:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d24:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d28:	79 08                	jns    803d32 <map_segment+0x14e>
				return r;
  803d2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d2d:	e9 9c 00 00 00       	jmpq   803dce <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d35:	48 63 d0             	movslq %eax,%rdx
  803d38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d3c:	48 01 d0             	add    %rdx,%rax
  803d3f:	48 89 c2             	mov    %rax,%rdx
  803d42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d45:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803d49:	48 89 d1             	mov    %rdx,%rcx
  803d4c:	89 c2                	mov    %eax,%edx
  803d4e:	be 00 00 40 00       	mov    $0x400000,%esi
  803d53:	bf 00 00 00 00       	mov    $0x0,%edi
  803d58:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  803d5f:	00 00 00 
  803d62:	ff d0                	callq  *%rax
  803d64:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d67:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d6b:	79 30                	jns    803d9d <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803d6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d70:	89 c1                	mov    %eax,%ecx
  803d72:	48 ba f3 57 80 00 00 	movabs $0x8057f3,%rdx
  803d79:	00 00 00 
  803d7c:	be 29 01 00 00       	mov    $0x129,%esi
  803d81:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  803d88:	00 00 00 
  803d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d90:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803d97:	00 00 00 
  803d9a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803d9d:	be 00 00 40 00       	mov    $0x400000,%esi
  803da2:	bf 00 00 00 00       	mov    $0x0,%edi
  803da7:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  803dae:	00 00 00 
  803db1:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803db3:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbd:	48 98                	cltq   
  803dbf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dc3:	0f 82 78 fe ff ff    	jb     803c41 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dce:	c9                   	leaveq 
  803dcf:	c3                   	retq   

0000000000803dd0 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803dd0:	55                   	push   %rbp
  803dd1:	48 89 e5             	mov    %rsp,%rbp
  803dd4:	48 83 ec 30          	sub    $0x30,%rsp
  803dd8:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803ddb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803de2:	00 
  803de3:	e9 eb 00 00 00       	jmpq   803ed3 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dec:	48 c1 f8 12          	sar    $0x12,%rax
  803df0:	48 89 c2             	mov    %rax,%rdx
  803df3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803dfa:	01 00 00 
  803dfd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e01:	83 e0 01             	and    $0x1,%eax
  803e04:	48 85 c0             	test   %rax,%rax
  803e07:	74 21                	je     803e2a <copy_shared_pages+0x5a>
  803e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0d:	48 c1 f8 09          	sar    $0x9,%rax
  803e11:	48 89 c2             	mov    %rax,%rdx
  803e14:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e1b:	01 00 00 
  803e1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e22:	83 e0 01             	and    $0x1,%eax
  803e25:	48 85 c0             	test   %rax,%rax
  803e28:	75 0d                	jne    803e37 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  803e2a:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  803e31:	00 
  803e32:	e9 9c 00 00 00       	jmpq   803ed3 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  803e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e3b:	48 05 00 02 00 00    	add    $0x200,%rax
  803e41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  803e45:	eb 7e                	jmp    803ec5 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  803e47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e4e:	01 00 00 
  803e51:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e59:	25 01 04 00 00       	and    $0x401,%eax
  803e5e:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  803e64:	75 5a                	jne    803ec0 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  803e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e6a:	48 c1 e0 0c          	shl    $0xc,%rax
  803e6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  803e72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e79:	01 00 00 
  803e7c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e84:	25 07 0e 00 00       	and    $0xe07,%eax
  803e89:	89 c6                	mov    %eax,%esi
  803e8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e8f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e96:	41 89 f0             	mov    %esi,%r8d
  803e99:	48 89 c6             	mov    %rax,%rsi
  803e9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea1:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
  803ead:	48 98                	cltq   
  803eaf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  803eb3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eb8:	79 06                	jns    803ec0 <copy_shared_pages+0xf0>
						return r;
  803eba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ebe:	eb 28                	jmp    803ee8 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803ec0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803ecd:	0f 8c 74 ff ff ff    	jl     803e47 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803ed3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed7:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  803edd:	0f 86 05 ff ff ff    	jbe    803de8 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ee8:	c9                   	leaveq 
  803ee9:	c3                   	retq   

0000000000803eea <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803eea:	55                   	push   %rbp
  803eeb:	48 89 e5             	mov    %rsp,%rbp
  803eee:	48 83 ec 20          	sub    $0x20,%rsp
  803ef2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803ef5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ef9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803efc:	48 89 d6             	mov    %rdx,%rsi
  803eff:	89 c7                	mov    %eax,%edi
  803f01:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  803f08:	00 00 00 
  803f0b:	ff d0                	callq  *%rax
  803f0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f14:	79 05                	jns    803f1b <fd2sockid+0x31>
		return r;
  803f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f19:	eb 24                	jmp    803f3f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1f:	8b 10                	mov    (%rax),%edx
  803f21:	48 b8 40 88 80 00 00 	movabs $0x808840,%rax
  803f28:	00 00 00 
  803f2b:	8b 00                	mov    (%rax),%eax
  803f2d:	39 c2                	cmp    %eax,%edx
  803f2f:	74 07                	je     803f38 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803f31:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f36:	eb 07                	jmp    803f3f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f3c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803f3f:	c9                   	leaveq 
  803f40:	c3                   	retq   

0000000000803f41 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803f41:	55                   	push   %rbp
  803f42:	48 89 e5             	mov    %rsp,%rbp
  803f45:	48 83 ec 20          	sub    $0x20,%rsp
  803f49:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803f4c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f50:	48 89 c7             	mov    %rax,%rdi
  803f53:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  803f5a:	00 00 00 
  803f5d:	ff d0                	callq  *%rax
  803f5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f66:	78 26                	js     803f8e <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f6c:	ba 07 04 00 00       	mov    $0x407,%edx
  803f71:	48 89 c6             	mov    %rax,%rsi
  803f74:	bf 00 00 00 00       	mov    $0x0,%edi
  803f79:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  803f80:	00 00 00 
  803f83:	ff d0                	callq  *%rax
  803f85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f8c:	79 16                	jns    803fa4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803f8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f91:	89 c7                	mov    %eax,%edi
  803f93:	48 b8 50 44 80 00 00 	movabs $0x804450,%rax
  803f9a:	00 00 00 
  803f9d:	ff d0                	callq  *%rax
		return r;
  803f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa2:	eb 3a                	jmp    803fde <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa8:	48 ba 40 88 80 00 00 	movabs $0x808840,%rdx
  803faf:	00 00 00 
  803fb2:	8b 12                	mov    (%rdx),%edx
  803fb4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fba:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fc8:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fcf:	48 89 c7             	mov    %rax,%rdi
  803fd2:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  803fd9:	00 00 00 
  803fdc:	ff d0                	callq  *%rax
}
  803fde:	c9                   	leaveq 
  803fdf:	c3                   	retq   

0000000000803fe0 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803fe0:	55                   	push   %rbp
  803fe1:	48 89 e5             	mov    %rsp,%rbp
  803fe4:	48 83 ec 30          	sub    $0x30,%rsp
  803fe8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ff3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff6:	89 c7                	mov    %eax,%edi
  803ff8:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
  804004:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400b:	79 05                	jns    804012 <accept+0x32>
		return r;
  80400d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804010:	eb 3b                	jmp    80404d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804012:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804016:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80401a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401d:	48 89 ce             	mov    %rcx,%rsi
  804020:	89 c7                	mov    %eax,%edi
  804022:	48 b8 2d 43 80 00 00 	movabs $0x80432d,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
  80402e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804035:	79 05                	jns    80403c <accept+0x5c>
		return r;
  804037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403a:	eb 11                	jmp    80404d <accept+0x6d>
	return alloc_sockfd(r);
  80403c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403f:	89 c7                	mov    %eax,%edi
  804041:	48 b8 41 3f 80 00 00 	movabs $0x803f41,%rax
  804048:	00 00 00 
  80404b:	ff d0                	callq  *%rax
}
  80404d:	c9                   	leaveq 
  80404e:	c3                   	retq   

000000000080404f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80404f:	55                   	push   %rbp
  804050:	48 89 e5             	mov    %rsp,%rbp
  804053:	48 83 ec 20          	sub    $0x20,%rsp
  804057:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80405a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80405e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804061:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804064:	89 c7                	mov    %eax,%edi
  804066:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  80406d:	00 00 00 
  804070:	ff d0                	callq  *%rax
  804072:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804075:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804079:	79 05                	jns    804080 <bind+0x31>
		return r;
  80407b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80407e:	eb 1b                	jmp    80409b <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804080:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804083:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804087:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80408a:	48 89 ce             	mov    %rcx,%rsi
  80408d:	89 c7                	mov    %eax,%edi
  80408f:	48 b8 ac 43 80 00 00 	movabs $0x8043ac,%rax
  804096:	00 00 00 
  804099:	ff d0                	callq  *%rax
}
  80409b:	c9                   	leaveq 
  80409c:	c3                   	retq   

000000000080409d <shutdown>:

int
shutdown(int s, int how)
{
  80409d:	55                   	push   %rbp
  80409e:	48 89 e5             	mov    %rsp,%rbp
  8040a1:	48 83 ec 20          	sub    $0x20,%rsp
  8040a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040a8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ae:	89 c7                	mov    %eax,%edi
  8040b0:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  8040b7:	00 00 00 
  8040ba:	ff d0                	callq  *%rax
  8040bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c3:	79 05                	jns    8040ca <shutdown+0x2d>
		return r;
  8040c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c8:	eb 16                	jmp    8040e0 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8040ca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d0:	89 d6                	mov    %edx,%esi
  8040d2:	89 c7                	mov    %eax,%edi
  8040d4:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  8040db:	00 00 00 
  8040de:	ff d0                	callq  *%rax
}
  8040e0:	c9                   	leaveq 
  8040e1:	c3                   	retq   

00000000008040e2 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8040e2:	55                   	push   %rbp
  8040e3:	48 89 e5             	mov    %rsp,%rbp
  8040e6:	48 83 ec 10          	sub    $0x10,%rsp
  8040ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8040ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f2:	48 89 c7             	mov    %rax,%rdi
  8040f5:	48 b8 10 4f 80 00 00 	movabs $0x804f10,%rax
  8040fc:	00 00 00 
  8040ff:	ff d0                	callq  *%rax
  804101:	83 f8 01             	cmp    $0x1,%eax
  804104:	75 17                	jne    80411d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410a:	8b 40 0c             	mov    0xc(%rax),%eax
  80410d:	89 c7                	mov    %eax,%edi
  80410f:	48 b8 50 44 80 00 00 	movabs $0x804450,%rax
  804116:	00 00 00 
  804119:	ff d0                	callq  *%rax
  80411b:	eb 05                	jmp    804122 <devsock_close+0x40>
	else
		return 0;
  80411d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804122:	c9                   	leaveq 
  804123:	c3                   	retq   

0000000000804124 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804124:	55                   	push   %rbp
  804125:	48 89 e5             	mov    %rsp,%rbp
  804128:	48 83 ec 20          	sub    $0x20,%rsp
  80412c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80412f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804133:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804136:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804139:	89 c7                	mov    %eax,%edi
  80413b:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  804142:	00 00 00 
  804145:	ff d0                	callq  *%rax
  804147:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80414a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414e:	79 05                	jns    804155 <connect+0x31>
		return r;
  804150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804153:	eb 1b                	jmp    804170 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804155:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804158:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80415c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415f:	48 89 ce             	mov    %rcx,%rsi
  804162:	89 c7                	mov    %eax,%edi
  804164:	48 b8 7d 44 80 00 00 	movabs $0x80447d,%rax
  80416b:	00 00 00 
  80416e:	ff d0                	callq  *%rax
}
  804170:	c9                   	leaveq 
  804171:	c3                   	retq   

0000000000804172 <listen>:

int
listen(int s, int backlog)
{
  804172:	55                   	push   %rbp
  804173:	48 89 e5             	mov    %rsp,%rbp
  804176:	48 83 ec 20          	sub    $0x20,%rsp
  80417a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80417d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804183:	89 c7                	mov    %eax,%edi
  804185:	48 b8 ea 3e 80 00 00 	movabs $0x803eea,%rax
  80418c:	00 00 00 
  80418f:	ff d0                	callq  *%rax
  804191:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804198:	79 05                	jns    80419f <listen+0x2d>
		return r;
  80419a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80419d:	eb 16                	jmp    8041b5 <listen+0x43>
	return nsipc_listen(r, backlog);
  80419f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a5:	89 d6                	mov    %edx,%esi
  8041a7:	89 c7                	mov    %eax,%edi
  8041a9:	48 b8 e1 44 80 00 00 	movabs $0x8044e1,%rax
  8041b0:	00 00 00 
  8041b3:	ff d0                	callq  *%rax
}
  8041b5:	c9                   	leaveq 
  8041b6:	c3                   	retq   

00000000008041b7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8041b7:	55                   	push   %rbp
  8041b8:	48 89 e5             	mov    %rsp,%rbp
  8041bb:	48 83 ec 20          	sub    $0x20,%rsp
  8041bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8041cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041cf:	89 c2                	mov    %eax,%edx
  8041d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d5:	8b 40 0c             	mov    0xc(%rax),%eax
  8041d8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8041dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041e1:	89 c7                	mov    %eax,%edi
  8041e3:	48 b8 21 45 80 00 00 	movabs $0x804521,%rax
  8041ea:	00 00 00 
  8041ed:	ff d0                	callq  *%rax
}
  8041ef:	c9                   	leaveq 
  8041f0:	c3                   	retq   

00000000008041f1 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8041f1:	55                   	push   %rbp
  8041f2:	48 89 e5             	mov    %rsp,%rbp
  8041f5:	48 83 ec 20          	sub    $0x20,%rsp
  8041f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804201:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804209:	89 c2                	mov    %eax,%edx
  80420b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420f:	8b 40 0c             	mov    0xc(%rax),%eax
  804212:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804216:	b9 00 00 00 00       	mov    $0x0,%ecx
  80421b:	89 c7                	mov    %eax,%edi
  80421d:	48 b8 ed 45 80 00 00 	movabs $0x8045ed,%rax
  804224:	00 00 00 
  804227:	ff d0                	callq  *%rax
}
  804229:	c9                   	leaveq 
  80422a:	c3                   	retq   

000000000080422b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80422b:	55                   	push   %rbp
  80422c:	48 89 e5             	mov    %rsp,%rbp
  80422f:	48 83 ec 10          	sub    $0x10,%rsp
  804233:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804237:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80423b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423f:	48 be 15 58 80 00 00 	movabs $0x805815,%rsi
  804246:	00 00 00 
  804249:	48 89 c7             	mov    %rax,%rdi
  80424c:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  804253:	00 00 00 
  804256:	ff d0                	callq  *%rax
	return 0;
  804258:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80425d:	c9                   	leaveq 
  80425e:	c3                   	retq   

000000000080425f <socket>:

int
socket(int domain, int type, int protocol)
{
  80425f:	55                   	push   %rbp
  804260:	48 89 e5             	mov    %rsp,%rbp
  804263:	48 83 ec 20          	sub    $0x20,%rsp
  804267:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80426a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80426d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804270:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804273:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804276:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804279:	89 ce                	mov    %ecx,%esi
  80427b:	89 c7                	mov    %eax,%edi
  80427d:	48 b8 a5 46 80 00 00 	movabs $0x8046a5,%rax
  804284:	00 00 00 
  804287:	ff d0                	callq  *%rax
  804289:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80428c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804290:	79 05                	jns    804297 <socket+0x38>
		return r;
  804292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804295:	eb 11                	jmp    8042a8 <socket+0x49>
	return alloc_sockfd(r);
  804297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80429a:	89 c7                	mov    %eax,%edi
  80429c:	48 b8 41 3f 80 00 00 	movabs $0x803f41,%rax
  8042a3:	00 00 00 
  8042a6:	ff d0                	callq  *%rax
}
  8042a8:	c9                   	leaveq 
  8042a9:	c3                   	retq   

00000000008042aa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8042aa:	55                   	push   %rbp
  8042ab:	48 89 e5             	mov    %rsp,%rbp
  8042ae:	48 83 ec 10          	sub    $0x10,%rsp
  8042b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8042b5:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8042bc:	00 00 00 
  8042bf:	8b 00                	mov    (%rax),%eax
  8042c1:	85 c0                	test   %eax,%eax
  8042c3:	75 1f                	jne    8042e4 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8042c5:	bf 02 00 00 00       	mov    $0x2,%edi
  8042ca:	48 b8 9f 4e 80 00 00 	movabs $0x804e9f,%rax
  8042d1:	00 00 00 
  8042d4:	ff d0                	callq  *%rax
  8042d6:	89 c2                	mov    %eax,%edx
  8042d8:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8042df:	00 00 00 
  8042e2:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8042e4:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8042eb:	00 00 00 
  8042ee:	8b 00                	mov    (%rax),%eax
  8042f0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8042f3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8042f8:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  8042ff:	00 00 00 
  804302:	89 c7                	mov    %eax,%edi
  804304:	48 b8 0a 4e 80 00 00 	movabs $0x804e0a,%rax
  80430b:	00 00 00 
  80430e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804310:	ba 00 00 00 00       	mov    $0x0,%edx
  804315:	be 00 00 00 00       	mov    $0x0,%esi
  80431a:	bf 00 00 00 00       	mov    $0x0,%edi
  80431f:	48 b8 49 4d 80 00 00 	movabs $0x804d49,%rax
  804326:	00 00 00 
  804329:	ff d0                	callq  *%rax
}
  80432b:	c9                   	leaveq 
  80432c:	c3                   	retq   

000000000080432d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80432d:	55                   	push   %rbp
  80432e:	48 89 e5             	mov    %rsp,%rbp
  804331:	48 83 ec 30          	sub    $0x30,%rsp
  804335:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804338:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80433c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804340:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804347:	00 00 00 
  80434a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80434d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80434f:	bf 01 00 00 00       	mov    $0x1,%edi
  804354:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  80435b:	00 00 00 
  80435e:	ff d0                	callq  *%rax
  804360:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804367:	78 3e                	js     8043a7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804369:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804370:	00 00 00 
  804373:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437b:	8b 40 10             	mov    0x10(%rax),%eax
  80437e:	89 c2                	mov    %eax,%edx
  804380:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804388:	48 89 ce             	mov    %rcx,%rsi
  80438b:	48 89 c7             	mov    %rax,%rdi
  80438e:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  804395:	00 00 00 
  804398:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80439a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439e:	8b 50 10             	mov    0x10(%rax),%edx
  8043a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8043a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8043aa:	c9                   	leaveq 
  8043ab:	c3                   	retq   

00000000008043ac <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8043ac:	55                   	push   %rbp
  8043ad:	48 89 e5             	mov    %rsp,%rbp
  8043b0:	48 83 ec 10          	sub    $0x10,%rsp
  8043b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8043bb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8043be:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8043c5:	00 00 00 
  8043c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043cb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8043cd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d4:	48 89 c6             	mov    %rax,%rsi
  8043d7:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8043de:	00 00 00 
  8043e1:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  8043e8:	00 00 00 
  8043eb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8043ed:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8043f4:	00 00 00 
  8043f7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043fa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8043fd:	bf 02 00 00 00       	mov    $0x2,%edi
  804402:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  804409:	00 00 00 
  80440c:	ff d0                	callq  *%rax
}
  80440e:	c9                   	leaveq 
  80440f:	c3                   	retq   

0000000000804410 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804410:	55                   	push   %rbp
  804411:	48 89 e5             	mov    %rsp,%rbp
  804414:	48 83 ec 10          	sub    $0x10,%rsp
  804418:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80441b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80441e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804425:	00 00 00 
  804428:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80442b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80442d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804434:	00 00 00 
  804437:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80443a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80443d:	bf 03 00 00 00       	mov    $0x3,%edi
  804442:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  804449:	00 00 00 
  80444c:	ff d0                	callq  *%rax
}
  80444e:	c9                   	leaveq 
  80444f:	c3                   	retq   

0000000000804450 <nsipc_close>:

int
nsipc_close(int s)
{
  804450:	55                   	push   %rbp
  804451:	48 89 e5             	mov    %rsp,%rbp
  804454:	48 83 ec 10          	sub    $0x10,%rsp
  804458:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80445b:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804462:	00 00 00 
  804465:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804468:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80446a:	bf 04 00 00 00       	mov    $0x4,%edi
  80446f:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
}
  80447b:	c9                   	leaveq 
  80447c:	c3                   	retq   

000000000080447d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80447d:	55                   	push   %rbp
  80447e:	48 89 e5             	mov    %rsp,%rbp
  804481:	48 83 ec 10          	sub    $0x10,%rsp
  804485:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804488:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80448c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80448f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804496:	00 00 00 
  804499:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80449c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80449e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a5:	48 89 c6             	mov    %rax,%rsi
  8044a8:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8044af:	00 00 00 
  8044b2:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  8044b9:	00 00 00 
  8044bc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8044be:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8044c5:	00 00 00 
  8044c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044cb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8044ce:	bf 05 00 00 00       	mov    $0x5,%edi
  8044d3:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  8044da:	00 00 00 
  8044dd:	ff d0                	callq  *%rax
}
  8044df:	c9                   	leaveq 
  8044e0:	c3                   	retq   

00000000008044e1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8044e1:	55                   	push   %rbp
  8044e2:	48 89 e5             	mov    %rsp,%rbp
  8044e5:	48 83 ec 10          	sub    $0x10,%rsp
  8044e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044ec:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8044ef:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8044f6:	00 00 00 
  8044f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044fc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8044fe:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804505:	00 00 00 
  804508:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80450b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80450e:	bf 06 00 00 00       	mov    $0x6,%edi
  804513:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  80451a:	00 00 00 
  80451d:	ff d0                	callq  *%rax
}
  80451f:	c9                   	leaveq 
  804520:	c3                   	retq   

0000000000804521 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804521:	55                   	push   %rbp
  804522:	48 89 e5             	mov    %rsp,%rbp
  804525:	48 83 ec 30          	sub    $0x30,%rsp
  804529:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80452c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804530:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804533:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804536:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80453d:	00 00 00 
  804540:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804543:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804545:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80454c:	00 00 00 
  80454f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804552:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804555:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80455c:	00 00 00 
  80455f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804562:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804565:	bf 07 00 00 00       	mov    $0x7,%edi
  80456a:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  804571:	00 00 00 
  804574:	ff d0                	callq  *%rax
  804576:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80457d:	78 69                	js     8045e8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80457f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804586:	7f 08                	jg     804590 <nsipc_recv+0x6f>
  804588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80458b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80458e:	7e 35                	jle    8045c5 <nsipc_recv+0xa4>
  804590:	48 b9 1c 58 80 00 00 	movabs $0x80581c,%rcx
  804597:	00 00 00 
  80459a:	48 ba 31 58 80 00 00 	movabs $0x805831,%rdx
  8045a1:	00 00 00 
  8045a4:	be 62 00 00 00       	mov    $0x62,%esi
  8045a9:	48 bf 46 58 80 00 00 	movabs $0x805846,%rdi
  8045b0:	00 00 00 
  8045b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b8:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  8045bf:	00 00 00 
  8045c2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8045c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c8:	48 63 d0             	movslq %eax,%rdx
  8045cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045cf:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  8045d6:	00 00 00 
  8045d9:	48 89 c7             	mov    %rax,%rdi
  8045dc:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  8045e3:	00 00 00 
  8045e6:	ff d0                	callq  *%rax
	}

	return r;
  8045e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045eb:	c9                   	leaveq 
  8045ec:	c3                   	retq   

00000000008045ed <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8045ed:	55                   	push   %rbp
  8045ee:	48 89 e5             	mov    %rsp,%rbp
  8045f1:	48 83 ec 20          	sub    $0x20,%rsp
  8045f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8045fc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8045ff:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804602:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804609:	00 00 00 
  80460c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80460f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804611:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804618:	7e 35                	jle    80464f <nsipc_send+0x62>
  80461a:	48 b9 52 58 80 00 00 	movabs $0x805852,%rcx
  804621:	00 00 00 
  804624:	48 ba 31 58 80 00 00 	movabs $0x805831,%rdx
  80462b:	00 00 00 
  80462e:	be 6d 00 00 00       	mov    $0x6d,%esi
  804633:	48 bf 46 58 80 00 00 	movabs $0x805846,%rdi
  80463a:	00 00 00 
  80463d:	b8 00 00 00 00       	mov    $0x0,%eax
  804642:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  804649:	00 00 00 
  80464c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80464f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804652:	48 63 d0             	movslq %eax,%rdx
  804655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804659:	48 89 c6             	mov    %rax,%rsi
  80465c:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  804663:	00 00 00 
  804666:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  80466d:	00 00 00 
  804670:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804672:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804679:	00 00 00 
  80467c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80467f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804682:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804689:	00 00 00 
  80468c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80468f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804692:	bf 08 00 00 00       	mov    $0x8,%edi
  804697:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  80469e:	00 00 00 
  8046a1:	ff d0                	callq  *%rax
}
  8046a3:	c9                   	leaveq 
  8046a4:	c3                   	retq   

00000000008046a5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8046a5:	55                   	push   %rbp
  8046a6:	48 89 e5             	mov    %rsp,%rbp
  8046a9:	48 83 ec 10          	sub    $0x10,%rsp
  8046ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8046b0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8046b3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8046b6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8046bd:	00 00 00 
  8046c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8046c3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8046c5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8046cc:	00 00 00 
  8046cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8046d2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8046d5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8046dc:	00 00 00 
  8046df:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8046e2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8046e5:	bf 09 00 00 00       	mov    $0x9,%edi
  8046ea:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  8046f1:	00 00 00 
  8046f4:	ff d0                	callq  *%rax
}
  8046f6:	c9                   	leaveq 
  8046f7:	c3                   	retq   

00000000008046f8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8046f8:	55                   	push   %rbp
  8046f9:	48 89 e5             	mov    %rsp,%rbp
  8046fc:	53                   	push   %rbx
  8046fd:	48 83 ec 38          	sub    $0x38,%rsp
  804701:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804705:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804709:	48 89 c7             	mov    %rax,%rdi
  80470c:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  804713:	00 00 00 
  804716:	ff d0                	callq  *%rax
  804718:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80471b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80471f:	0f 88 bf 01 00 00    	js     8048e4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804729:	ba 07 04 00 00       	mov    $0x407,%edx
  80472e:	48 89 c6             	mov    %rax,%rsi
  804731:	bf 00 00 00 00       	mov    $0x0,%edi
  804736:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  80473d:	00 00 00 
  804740:	ff d0                	callq  *%rax
  804742:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804745:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804749:	0f 88 95 01 00 00    	js     8048e4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80474f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804753:	48 89 c7             	mov    %rax,%rdi
  804756:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  80475d:	00 00 00 
  804760:	ff d0                	callq  *%rax
  804762:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804765:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804769:	0f 88 5d 01 00 00    	js     8048cc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80476f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804773:	ba 07 04 00 00       	mov    $0x407,%edx
  804778:	48 89 c6             	mov    %rax,%rsi
  80477b:	bf 00 00 00 00       	mov    $0x0,%edi
  804780:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  804787:	00 00 00 
  80478a:	ff d0                	callq  *%rax
  80478c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80478f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804793:	0f 88 33 01 00 00    	js     8048cc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80479d:	48 89 c7             	mov    %rax,%rdi
  8047a0:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  8047a7:	00 00 00 
  8047aa:	ff d0                	callq  *%rax
  8047ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8047b9:	48 89 c6             	mov    %rax,%rsi
  8047bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8047c1:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  8047c8:	00 00 00 
  8047cb:	ff d0                	callq  *%rax
  8047cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047d4:	0f 88 d9 00 00 00    	js     8048b3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047de:	48 89 c7             	mov    %rax,%rdi
  8047e1:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  8047e8:	00 00 00 
  8047eb:	ff d0                	callq  *%rax
  8047ed:	48 89 c2             	mov    %rax,%rdx
  8047f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047f4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8047fa:	48 89 d1             	mov    %rdx,%rcx
  8047fd:	ba 00 00 00 00       	mov    $0x0,%edx
  804802:	48 89 c6             	mov    %rax,%rsi
  804805:	bf 00 00 00 00       	mov    $0x0,%edi
  80480a:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  804811:	00 00 00 
  804814:	ff d0                	callq  *%rax
  804816:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804819:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80481d:	78 79                	js     804898 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80481f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804823:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80482a:	00 00 00 
  80482d:	8b 12                	mov    (%rdx),%edx
  80482f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804835:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80483c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804840:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  804847:	00 00 00 
  80484a:	8b 12                	mov    (%rdx),%edx
  80484c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80484e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804852:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80485d:	48 89 c7             	mov    %rax,%rdi
  804860:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  804867:	00 00 00 
  80486a:	ff d0                	callq  *%rax
  80486c:	89 c2                	mov    %eax,%edx
  80486e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804872:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804874:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804878:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80487c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804880:	48 89 c7             	mov    %rax,%rdi
  804883:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  80488a:	00 00 00 
  80488d:	ff d0                	callq  *%rax
  80488f:	89 03                	mov    %eax,(%rbx)
	return 0;
  804891:	b8 00 00 00 00       	mov    $0x0,%eax
  804896:	eb 4f                	jmp    8048e7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804898:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804899:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80489d:	48 89 c6             	mov    %rax,%rsi
  8048a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8048a5:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  8048ac:	00 00 00 
  8048af:	ff d0                	callq  *%rax
  8048b1:	eb 01                	jmp    8048b4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8048b3:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8048b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048b8:	48 89 c6             	mov    %rax,%rsi
  8048bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8048c0:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  8048c7:	00 00 00 
  8048ca:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8048cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048d0:	48 89 c6             	mov    %rax,%rsi
  8048d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8048d8:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  8048df:	00 00 00 
  8048e2:	ff d0                	callq  *%rax
err:
	return r;
  8048e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8048e7:	48 83 c4 38          	add    $0x38,%rsp
  8048eb:	5b                   	pop    %rbx
  8048ec:	5d                   	pop    %rbp
  8048ed:	c3                   	retq   

00000000008048ee <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8048ee:	55                   	push   %rbp
  8048ef:	48 89 e5             	mov    %rsp,%rbp
  8048f2:	53                   	push   %rbx
  8048f3:	48 83 ec 28          	sub    $0x28,%rsp
  8048f7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8048fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8048ff:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804906:	00 00 00 
  804909:	48 8b 00             	mov    (%rax),%rax
  80490c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804912:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804919:	48 89 c7             	mov    %rax,%rdi
  80491c:	48 b8 10 4f 80 00 00 	movabs $0x804f10,%rax
  804923:	00 00 00 
  804926:	ff d0                	callq  *%rax
  804928:	89 c3                	mov    %eax,%ebx
  80492a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80492e:	48 89 c7             	mov    %rax,%rdi
  804931:	48 b8 10 4f 80 00 00 	movabs $0x804f10,%rax
  804938:	00 00 00 
  80493b:	ff d0                	callq  *%rax
  80493d:	39 c3                	cmp    %eax,%ebx
  80493f:	0f 94 c0             	sete   %al
  804942:	0f b6 c0             	movzbl %al,%eax
  804945:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804948:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  80494f:	00 00 00 
  804952:	48 8b 00             	mov    (%rax),%rax
  804955:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80495b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80495e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804961:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804964:	75 05                	jne    80496b <_pipeisclosed+0x7d>
			return ret;
  804966:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804969:	eb 4a                	jmp    8049b5 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80496b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80496e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804971:	74 8c                	je     8048ff <_pipeisclosed+0x11>
  804973:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804977:	75 86                	jne    8048ff <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804979:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804980:	00 00 00 
  804983:	48 8b 00             	mov    (%rax),%rax
  804986:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80498c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80498f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804992:	89 c6                	mov    %eax,%esi
  804994:	48 bf 63 58 80 00 00 	movabs $0x805863,%rdi
  80499b:	00 00 00 
  80499e:	b8 00 00 00 00       	mov    $0x0,%eax
  8049a3:	49 b8 8d 09 80 00 00 	movabs $0x80098d,%r8
  8049aa:	00 00 00 
  8049ad:	41 ff d0             	callq  *%r8
	}
  8049b0:	e9 4a ff ff ff       	jmpq   8048ff <_pipeisclosed+0x11>

}
  8049b5:	48 83 c4 28          	add    $0x28,%rsp
  8049b9:	5b                   	pop    %rbx
  8049ba:	5d                   	pop    %rbp
  8049bb:	c3                   	retq   

00000000008049bc <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8049bc:	55                   	push   %rbp
  8049bd:	48 89 e5             	mov    %rsp,%rbp
  8049c0:	48 83 ec 30          	sub    $0x30,%rsp
  8049c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8049c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8049cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8049ce:	48 89 d6             	mov    %rdx,%rsi
  8049d1:	89 c7                	mov    %eax,%edi
  8049d3:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  8049da:	00 00 00 
  8049dd:	ff d0                	callq  *%rax
  8049df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049e6:	79 05                	jns    8049ed <pipeisclosed+0x31>
		return r;
  8049e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049eb:	eb 31                	jmp    804a1e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8049ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049f1:	48 89 c7             	mov    %rax,%rdi
  8049f4:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  8049fb:	00 00 00 
  8049fe:	ff d0                	callq  *%rax
  804a00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a0c:	48 89 d6             	mov    %rdx,%rsi
  804a0f:	48 89 c7             	mov    %rax,%rdi
  804a12:	48 b8 ee 48 80 00 00 	movabs $0x8048ee,%rax
  804a19:	00 00 00 
  804a1c:	ff d0                	callq  *%rax
}
  804a1e:	c9                   	leaveq 
  804a1f:	c3                   	retq   

0000000000804a20 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804a20:	55                   	push   %rbp
  804a21:	48 89 e5             	mov    %rsp,%rbp
  804a24:	48 83 ec 40          	sub    $0x40,%rsp
  804a28:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a2c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804a30:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804a34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a38:	48 89 c7             	mov    %rax,%rdi
  804a3b:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  804a42:	00 00 00 
  804a45:	ff d0                	callq  *%rax
  804a47:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804a4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804a53:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804a5a:	00 
  804a5b:	e9 90 00 00 00       	jmpq   804af0 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804a60:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804a65:	74 09                	je     804a70 <devpipe_read+0x50>
				return i;
  804a67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a6b:	e9 8e 00 00 00       	jmpq   804afe <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a78:	48 89 d6             	mov    %rdx,%rsi
  804a7b:	48 89 c7             	mov    %rax,%rdi
  804a7e:	48 b8 ee 48 80 00 00 	movabs $0x8048ee,%rax
  804a85:	00 00 00 
  804a88:	ff d0                	callq  *%rax
  804a8a:	85 c0                	test   %eax,%eax
  804a8c:	74 07                	je     804a95 <devpipe_read+0x75>
				return 0;
  804a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  804a93:	eb 69                	jmp    804afe <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804a95:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  804a9c:	00 00 00 
  804a9f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aa5:	8b 10                	mov    (%rax),%edx
  804aa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aab:	8b 40 04             	mov    0x4(%rax),%eax
  804aae:	39 c2                	cmp    %eax,%edx
  804ab0:	74 ae                	je     804a60 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aba:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804abe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ac2:	8b 00                	mov    (%rax),%eax
  804ac4:	99                   	cltd   
  804ac5:	c1 ea 1b             	shr    $0x1b,%edx
  804ac8:	01 d0                	add    %edx,%eax
  804aca:	83 e0 1f             	and    $0x1f,%eax
  804acd:	29 d0                	sub    %edx,%eax
  804acf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ad3:	48 98                	cltq   
  804ad5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804ada:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804adc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae0:	8b 00                	mov    (%rax),%eax
  804ae2:	8d 50 01             	lea    0x1(%rax),%edx
  804ae5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804aeb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804af4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804af8:	72 a7                	jb     804aa1 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804afe:	c9                   	leaveq 
  804aff:	c3                   	retq   

0000000000804b00 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804b00:	55                   	push   %rbp
  804b01:	48 89 e5             	mov    %rsp,%rbp
  804b04:	48 83 ec 40          	sub    $0x40,%rsp
  804b08:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b0c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804b10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804b14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b18:	48 89 c7             	mov    %rax,%rdi
  804b1b:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  804b22:	00 00 00 
  804b25:	ff d0                	callq  *%rax
  804b27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b33:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b3a:	00 
  804b3b:	e9 8f 00 00 00       	jmpq   804bcf <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804b40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b48:	48 89 d6             	mov    %rdx,%rsi
  804b4b:	48 89 c7             	mov    %rax,%rdi
  804b4e:	48 b8 ee 48 80 00 00 	movabs $0x8048ee,%rax
  804b55:	00 00 00 
  804b58:	ff d0                	callq  *%rax
  804b5a:	85 c0                	test   %eax,%eax
  804b5c:	74 07                	je     804b65 <devpipe_write+0x65>
				return 0;
  804b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  804b63:	eb 78                	jmp    804bdd <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804b65:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  804b6c:	00 00 00 
  804b6f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b75:	8b 40 04             	mov    0x4(%rax),%eax
  804b78:	48 63 d0             	movslq %eax,%rdx
  804b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b7f:	8b 00                	mov    (%rax),%eax
  804b81:	48 98                	cltq   
  804b83:	48 83 c0 20          	add    $0x20,%rax
  804b87:	48 39 c2             	cmp    %rax,%rdx
  804b8a:	73 b4                	jae    804b40 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804b8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b90:	8b 40 04             	mov    0x4(%rax),%eax
  804b93:	99                   	cltd   
  804b94:	c1 ea 1b             	shr    $0x1b,%edx
  804b97:	01 d0                	add    %edx,%eax
  804b99:	83 e0 1f             	and    $0x1f,%eax
  804b9c:	29 d0                	sub    %edx,%eax
  804b9e:	89 c6                	mov    %eax,%esi
  804ba0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ba4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ba8:	48 01 d0             	add    %rdx,%rax
  804bab:	0f b6 08             	movzbl (%rax),%ecx
  804bae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bb2:	48 63 c6             	movslq %esi,%rax
  804bb5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bbd:	8b 40 04             	mov    0x4(%rax),%eax
  804bc0:	8d 50 01             	lea    0x1(%rax),%edx
  804bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bc7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804bca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bd3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804bd7:	72 98                	jb     804b71 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804bd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804bdd:	c9                   	leaveq 
  804bde:	c3                   	retq   

0000000000804bdf <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804bdf:	55                   	push   %rbp
  804be0:	48 89 e5             	mov    %rsp,%rbp
  804be3:	48 83 ec 20          	sub    $0x20,%rsp
  804be7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804beb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bf3:	48 89 c7             	mov    %rax,%rdi
  804bf6:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  804bfd:	00 00 00 
  804c00:	ff d0                	callq  *%rax
  804c02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804c06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c0a:	48 be 76 58 80 00 00 	movabs $0x805876,%rsi
  804c11:	00 00 00 
  804c14:	48 89 c7             	mov    %rax,%rdi
  804c17:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  804c1e:	00 00 00 
  804c21:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c27:	8b 50 04             	mov    0x4(%rax),%edx
  804c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c2e:	8b 00                	mov    (%rax),%eax
  804c30:	29 c2                	sub    %eax,%edx
  804c32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c36:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804c3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c40:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804c47:	00 00 00 
	stat->st_dev = &devpipe;
  804c4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c4e:	48 b9 80 88 80 00 00 	movabs $0x808880,%rcx
  804c55:	00 00 00 
  804c58:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c64:	c9                   	leaveq 
  804c65:	c3                   	retq   

0000000000804c66 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804c66:	55                   	push   %rbp
  804c67:	48 89 e5             	mov    %rsp,%rbp
  804c6a:	48 83 ec 10          	sub    $0x10,%rsp
  804c6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804c72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c76:	48 89 c6             	mov    %rax,%rsi
  804c79:	bf 00 00 00 00       	mov    $0x0,%edi
  804c7e:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  804c85:	00 00 00 
  804c88:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804c8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c8e:	48 89 c7             	mov    %rax,%rdi
  804c91:	48 b8 6e 23 80 00 00 	movabs $0x80236e,%rax
  804c98:	00 00 00 
  804c9b:	ff d0                	callq  *%rax
  804c9d:	48 89 c6             	mov    %rax,%rsi
  804ca0:	bf 00 00 00 00       	mov    $0x0,%edi
  804ca5:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  804cac:	00 00 00 
  804caf:	ff d0                	callq  *%rax
}
  804cb1:	c9                   	leaveq 
  804cb2:	c3                   	retq   

0000000000804cb3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804cb3:	55                   	push   %rbp
  804cb4:	48 89 e5             	mov    %rsp,%rbp
  804cb7:	48 83 ec 20          	sub    $0x20,%rsp
  804cbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804cbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804cc2:	75 35                	jne    804cf9 <wait+0x46>
  804cc4:	48 b9 7d 58 80 00 00 	movabs $0x80587d,%rcx
  804ccb:	00 00 00 
  804cce:	48 ba 88 58 80 00 00 	movabs $0x805888,%rdx
  804cd5:	00 00 00 
  804cd8:	be 0a 00 00 00       	mov    $0xa,%esi
  804cdd:	48 bf 9d 58 80 00 00 	movabs $0x80589d,%rdi
  804ce4:	00 00 00 
  804ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  804cec:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  804cf3:	00 00 00 
  804cf6:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804cfc:	25 ff 03 00 00       	and    $0x3ff,%eax
  804d01:	48 98                	cltq   
  804d03:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804d0a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d11:	00 00 00 
  804d14:	48 01 d0             	add    %rdx,%rax
  804d17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804d1b:	eb 0c                	jmp    804d29 <wait+0x76>
		sys_yield();
  804d1d:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  804d24:	00 00 00 
  804d27:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804d29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804d33:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804d36:	75 0e                	jne    804d46 <wait+0x93>
  804d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d3c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804d42:	85 c0                	test   %eax,%eax
  804d44:	75 d7                	jne    804d1d <wait+0x6a>
		sys_yield();
}
  804d46:	90                   	nop
  804d47:	c9                   	leaveq 
  804d48:	c3                   	retq   

0000000000804d49 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804d49:	55                   	push   %rbp
  804d4a:	48 89 e5             	mov    %rsp,%rbp
  804d4d:	48 83 ec 30          	sub    $0x30,%rsp
  804d51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804d59:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804d5d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d62:	75 0e                	jne    804d72 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804d64:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d6b:	00 00 00 
  804d6e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d76:	48 89 c7             	mov    %rax,%rdi
  804d79:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  804d80:	00 00 00 
  804d83:	ff d0                	callq  *%rax
  804d85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d8c:	79 27                	jns    804db5 <ipc_recv+0x6c>
		if (from_env_store)
  804d8e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d93:	74 0a                	je     804d9f <ipc_recv+0x56>
			*from_env_store = 0;
  804d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d99:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804d9f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804da4:	74 0a                	je     804db0 <ipc_recv+0x67>
			*perm_store = 0;
  804da6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804daa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804db3:	eb 53                	jmp    804e08 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804db5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804dba:	74 19                	je     804dd5 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804dbc:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804dc3:	00 00 00 
  804dc6:	48 8b 00             	mov    (%rax),%rax
  804dc9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804dd3:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804dd5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804dda:	74 19                	je     804df5 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804ddc:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804de3:	00 00 00 
  804de6:	48 8b 00             	mov    (%rax),%rax
  804de9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804def:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804df3:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804df5:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804dfc:	00 00 00 
  804dff:	48 8b 00             	mov    (%rax),%rax
  804e02:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804e08:	c9                   	leaveq 
  804e09:	c3                   	retq   

0000000000804e0a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804e0a:	55                   	push   %rbp
  804e0b:	48 89 e5             	mov    %rsp,%rbp
  804e0e:	48 83 ec 30          	sub    $0x30,%rsp
  804e12:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804e15:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804e18:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804e1c:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804e1f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804e24:	75 1c                	jne    804e42 <ipc_send+0x38>
		pg = (void*) UTOP;
  804e26:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e2d:	00 00 00 
  804e30:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804e34:	eb 0c                	jmp    804e42 <ipc_send+0x38>
		sys_yield();
  804e36:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  804e3d:	00 00 00 
  804e40:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804e42:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804e45:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804e48:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804e4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e4f:	89 c7                	mov    %eax,%edi
  804e51:	48 b8 36 20 80 00 00 	movabs $0x802036,%rax
  804e58:	00 00 00 
  804e5b:	ff d0                	callq  *%rax
  804e5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e60:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804e64:	74 d0                	je     804e36 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804e66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e6a:	79 30                	jns    804e9c <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e6f:	89 c1                	mov    %eax,%ecx
  804e71:	48 ba a8 58 80 00 00 	movabs $0x8058a8,%rdx
  804e78:	00 00 00 
  804e7b:	be 47 00 00 00       	mov    $0x47,%esi
  804e80:	48 bf be 58 80 00 00 	movabs $0x8058be,%rdi
  804e87:	00 00 00 
  804e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  804e8f:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  804e96:	00 00 00 
  804e99:	41 ff d0             	callq  *%r8

}
  804e9c:	90                   	nop
  804e9d:	c9                   	leaveq 
  804e9e:	c3                   	retq   

0000000000804e9f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804e9f:	55                   	push   %rbp
  804ea0:	48 89 e5             	mov    %rsp,%rbp
  804ea3:	48 83 ec 18          	sub    $0x18,%rsp
  804ea7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804eb1:	eb 4d                	jmp    804f00 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804eb3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804eba:	00 00 00 
  804ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ec0:	48 98                	cltq   
  804ec2:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ec9:	48 01 d0             	add    %rdx,%rax
  804ecc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804ed2:	8b 00                	mov    (%rax),%eax
  804ed4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ed7:	75 23                	jne    804efc <ipc_find_env+0x5d>
			return envs[i].env_id;
  804ed9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ee0:	00 00 00 
  804ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ee6:	48 98                	cltq   
  804ee8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804eef:	48 01 d0             	add    %rdx,%rax
  804ef2:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804ef8:	8b 00                	mov    (%rax),%eax
  804efa:	eb 12                	jmp    804f0e <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804efc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f00:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804f07:	7e aa                	jle    804eb3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f0e:	c9                   	leaveq 
  804f0f:	c3                   	retq   

0000000000804f10 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804f10:	55                   	push   %rbp
  804f11:	48 89 e5             	mov    %rsp,%rbp
  804f14:	48 83 ec 18          	sub    $0x18,%rsp
  804f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f20:	48 c1 e8 15          	shr    $0x15,%rax
  804f24:	48 89 c2             	mov    %rax,%rdx
  804f27:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804f2e:	01 00 00 
  804f31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f35:	83 e0 01             	and    $0x1,%eax
  804f38:	48 85 c0             	test   %rax,%rax
  804f3b:	75 07                	jne    804f44 <pageref+0x34>
		return 0;
  804f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  804f42:	eb 56                	jmp    804f9a <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f48:	48 c1 e8 0c          	shr    $0xc,%rax
  804f4c:	48 89 c2             	mov    %rax,%rdx
  804f4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f56:	01 00 00 
  804f59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f65:	83 e0 01             	and    $0x1,%eax
  804f68:	48 85 c0             	test   %rax,%rax
  804f6b:	75 07                	jne    804f74 <pageref+0x64>
		return 0;
  804f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  804f72:	eb 26                	jmp    804f9a <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804f74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f78:	48 c1 e8 0c          	shr    $0xc,%rax
  804f7c:	48 89 c2             	mov    %rax,%rdx
  804f7f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804f86:	00 00 00 
  804f89:	48 c1 e2 04          	shl    $0x4,%rdx
  804f8d:	48 01 d0             	add    %rdx,%rax
  804f90:	48 83 c0 08          	add    $0x8,%rax
  804f94:	0f b7 00             	movzwl (%rax),%eax
  804f97:	0f b7 c0             	movzwl %ax,%eax
}
  804f9a:	c9                   	leaveq 
  804f9b:	c3                   	retq   
