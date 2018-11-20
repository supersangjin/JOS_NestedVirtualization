
vmm/guest/obj/user/init:     file format elf64-x86-64


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
  80003c:	e8 69 06 00 00       	callq  8006aa <libmain>
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
  8000a5:	48 bf 20 50 80 00 00 	movabs $0x805020,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
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
  8000f5:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 69 50 80 00 00 	movabs $0x805069,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
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
  800156:	48 bf 80 50 80 00 00 	movabs $0x805080,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf af 50 80 00 00 	movabs $0x8050af,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be c5 50 80 00 00 	movabs $0x8050c5,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be d1 50 80 00 00 	movabs $0x8050d1,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
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
  8001fe:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be d4 50 80 00 00 	movabs $0x8050d4,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
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
  800247:	48 bf d6 50 80 00 00 	movabs $0x8050d6,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx


	cprintf("init: running sh\n");
  800262:	48 bf da 50 80 00 00 	movabs $0x8050da,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 ba 04 80 00 00 	movabs $0x8004ba,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba ec 50 80 00 00 	movabs $0x8050ec,%rdx
  8002af:	00 00 00 
  8002b2:	be 39 00 00 00       	mov    $0x39,%esi
  8002b7:	48 bf f9 50 80 00 00 	movabs $0x8050f9,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba 05 51 80 00 00 	movabs $0x805105,%rdx
  8002e5:	00 00 00 
  8002e8:	be 3b 00 00 00       	mov    $0x3b,%esi
  8002ed:	48 bf f9 50 80 00 00 	movabs $0x8050f9,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 c0 25 80 00 00 	movabs $0x8025c0,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 1f 51 80 00 00 	movabs $0x80511f,%rdx
  800334:	00 00 00 
  800337:	be 3d 00 00 00       	mov    $0x3d,%esi
  80033c:	48 bf f9 50 80 00 00 	movabs $0x8050f9,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 27 51 80 00 00 	movabs $0x805127,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 3a 51 80 00 00 	movabs $0x80513a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 3d 51 80 00 00 	movabs $0x80513d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 d9 35 80 00 00 	movabs $0x8035d9,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 22                	jns    8003c8 <umain+0x33b>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf 45 51 80 00 00 	movabs $0x805145,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx

#ifdef VMM_GUEST
		break;
#endif

	}
  8003c6:	eb 90                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003c8:	48 bf 59 51 80 00 00 	movabs $0x805159,%rdi
  8003cf:	00 00 00 
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8003de:	00 00 00 
  8003e1:	ff d2                	callq  *%rdx
		wait(r);
  8003e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e6:	89 c7                	mov    %eax,%edi
  8003e8:	48 b8 b6 4b 80 00 00 	movabs $0x804bb6,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax

#ifdef VMM_GUEST
		break;
  8003f4:	90                   	nop
#endif

	}

}
  8003f5:	90                   	nop
  8003f6:	c9                   	leaveq 
  8003f7:	c3                   	retq   

00000000008003f8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	48 83 ec 20          	sub    $0x20,%rsp
  800400:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800403:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800406:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800409:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040d:	be 01 00 00 00       	mov    $0x1,%esi
  800412:	48 89 c7             	mov    %rax,%rdi
  800415:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  80041c:	00 00 00 
  80041f:	ff d0                	callq  *%rax
}
  800421:	90                   	nop
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <getchar>:

int
getchar(void)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800430:	ba 01 00 00 00       	mov    $0x1,%edx
  800435:	48 89 c6             	mov    %rax,%rsi
  800438:	bf 00 00 00 00       	mov    $0x0,%edi
  80043d:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  800444:	00 00 00 
  800447:	ff d0                	callq  *%rax
  800449:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800450:	79 05                	jns    800457 <getchar+0x33>
		return r;
  800452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800455:	eb 14                	jmp    80046b <getchar+0x47>
	if (r < 1)
  800457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045b:	7f 07                	jg     800464 <getchar+0x40>
		return -E_EOF;
  80045d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800462:	eb 07                	jmp    80046b <getchar+0x47>
	return c;
  800464:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800468:	0f b6 c0             	movzbl %al,%eax

}
  80046b:	c9                   	leaveq 
  80046c:	c3                   	retq   

000000000080046d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046d:	55                   	push   %rbp
  80046e:	48 89 e5             	mov    %rsp,%rbp
  800471:	48 83 ec 20          	sub    $0x20,%rsp
  800475:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800478:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80047f:	48 89 d6             	mov    %rdx,%rsi
  800482:	89 c7                	mov    %eax,%edi
  800484:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
  800490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800497:	79 05                	jns    80049e <iscons+0x31>
		return r;
  800499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049c:	eb 1a                	jmp    8004b8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a2:	8b 10                	mov    (%rax),%edx
  8004a4:	48 b8 80 87 80 00 00 	movabs $0x808780,%rax
  8004ab:	00 00 00 
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	39 c2                	cmp    %eax,%edx
  8004b2:	0f 94 c0             	sete   %al
  8004b5:	0f b6 c0             	movzbl %al,%eax
}
  8004b8:	c9                   	leaveq 
  8004b9:	c3                   	retq   

00000000008004ba <opencons>:

int
opencons(void)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 9c 22 80 00 00 	movabs $0x80229c,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
  8004d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dc:	79 05                	jns    8004e3 <opencons+0x29>
		return r;
  8004de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e1:	eb 5b                	jmp    80053e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e7:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ec:	48 89 c6             	mov    %rax,%rsi
  8004ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f4:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  8004fb:	00 00 00 
  8004fe:	ff d0                	callq  *%rax
  800500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800507:	79 05                	jns    80050e <opencons+0x54>
		return r;
  800509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050c:	eb 30                	jmp    80053e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800512:	48 ba 80 87 80 00 00 	movabs $0x808780,%rdx
  800519:	00 00 00 
  80051c:	8b 12                	mov    (%rdx),%edx
  80051e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800524:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80052b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052f:	48 89 c7             	mov    %rax,%rdi
  800532:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  800539:	00 00 00 
  80053c:	ff d0                	callq  *%rax
}
  80053e:	c9                   	leaveq 
  80053f:	c3                   	retq   

0000000000800540 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800540:	55                   	push   %rbp
  800541:	48 89 e5             	mov    %rsp,%rbp
  800544:	48 83 ec 30          	sub    $0x30,%rsp
  800548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800550:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800554:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800559:	75 13                	jne    80056e <devcons_read+0x2e>
		return 0;
  80055b:	b8 00 00 00 00       	mov    $0x0,%eax
  800560:	eb 49                	jmp    8005ab <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800562:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80056e:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  800575:	00 00 00 
  800578:	ff d0                	callq  *%rax
  80057a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80057d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800581:	74 df                	je     800562 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  800583:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800587:	79 05                	jns    80058e <devcons_read+0x4e>
		return c;
  800589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058c:	eb 1d                	jmp    8005ab <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80058e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800592:	75 07                	jne    80059b <devcons_read+0x5b>
		return 0;
  800594:	b8 00 00 00 00       	mov    $0x0,%eax
  800599:	eb 10                	jmp    8005ab <devcons_read+0x6b>
	*(char*)vbuf = c;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	89 c2                	mov    %eax,%edx
  8005a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a4:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ab:	c9                   	leaveq 
  8005ac:	c3                   	retq   

00000000008005ad <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005ad:	55                   	push   %rbp
  8005ae:	48 89 e5             	mov    %rsp,%rbp
  8005b1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005b8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005bf:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d4:	eb 76                	jmp    80064c <devcons_write+0x9f>
		m = n - tot;
  8005d6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005dd:	89 c2                	mov    %eax,%edx
  8005df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e2:	29 c2                	sub    %eax,%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ec:	83 f8 7f             	cmp    $0x7f,%eax
  8005ef:	76 07                	jbe    8005f8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fb:	48 63 d0             	movslq %eax,%rdx
  8005fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800601:	48 63 c8             	movslq %eax,%rcx
  800604:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060b:	48 01 c1             	add    %rax,%rcx
  80060e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800615:	48 89 ce             	mov    %rcx,%rsi
  800618:	48 89 c7             	mov    %rax,%rdi
  80061b:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  800622:	00 00 00 
  800625:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  800627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062a:	48 63 d0             	movslq %eax,%rdx
  80062d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800634:	48 89 d6             	mov    %rdx,%rsi
  800637:	48 89 c7             	mov    %rax,%rdi
  80063a:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  800641:	00 00 00 
  800644:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800646:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800649:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80064f:	48 98                	cltq   
  800651:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800658:	0f 82 78 ff ff ff    	jb     8005d6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80065e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	48 83 ec 08          	sub    $0x8,%rsp
  80066b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800674:	c9                   	leaveq 
  800675:	c3                   	retq   

0000000000800676 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800676:	55                   	push   %rbp
  800677:	48 89 e5             	mov    %rsp,%rbp
  80067a:	48 83 ec 10          	sub    $0x10,%rsp
  80067e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800682:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068a:	48 be 6c 51 80 00 00 	movabs $0x80516c,%rsi
  800691:	00 00 00 
  800694:	48 89 c7             	mov    %rax,%rdi
  800697:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  80069e:	00 00 00 
  8006a1:	ff d0                	callq  *%rax
	return 0;
  8006a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006a8:	c9                   	leaveq 
  8006a9:	c3                   	retq   

00000000008006aa <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006aa:	55                   	push   %rbp
  8006ab:	48 89 e5             	mov    %rsp,%rbp
  8006ae:	48 83 ec 10          	sub    $0x10,%rsp
  8006b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8006b9:	48 b8 d9 1d 80 00 00 	movabs $0x801dd9,%rax
  8006c0:	00 00 00 
  8006c3:	ff d0                	callq  *%rax
  8006c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006ca:	48 98                	cltq   
  8006cc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8006d3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006da:	00 00 00 
  8006dd:	48 01 c2             	add    %rax,%rdx
  8006e0:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8006e7:	00 00 00 
  8006ea:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006f1:	7e 14                	jle    800707 <libmain+0x5d>
		binaryname = argv[0];
  8006f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f7:	48 8b 10             	mov    (%rax),%rdx
  8006fa:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  800701:	00 00 00 
  800704:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80070e:	48 89 d6             	mov    %rdx,%rsi
  800711:	89 c7                	mov    %eax,%edi
  800713:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80071f:	48 b8 2e 07 80 00 00 	movabs $0x80072e,%rax
  800726:	00 00 00 
  800729:	ff d0                	callq  *%rax
}
  80072b:	90                   	nop
  80072c:	c9                   	leaveq 
  80072d:	c3                   	retq   

000000000080072e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80072e:	55                   	push   %rbp
  80072f:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800732:	48 b8 91 25 80 00 00 	movabs $0x802591,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80073e:	bf 00 00 00 00       	mov    $0x0,%edi
  800743:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  80074a:	00 00 00 
  80074d:	ff d0                	callq  *%rax
}
  80074f:	90                   	nop
  800750:	5d                   	pop    %rbp
  800751:	c3                   	retq   

0000000000800752 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	53                   	push   %rbx
  800757:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80075e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800765:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80076b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800772:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800779:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800780:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800787:	84 c0                	test   %al,%al
  800789:	74 23                	je     8007ae <_panic+0x5c>
  80078b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800792:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800796:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80079a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80079e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8007a2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007a6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007aa:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007ae:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007b5:	00 00 00 
  8007b8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007bf:	00 00 00 
  8007c2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007cd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007db:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8007e2:	00 00 00 
  8007e5:	48 8b 18             	mov    (%rax),%rbx
  8007e8:	48 b8 d9 1d 80 00 00 	movabs $0x801dd9,%rax
  8007ef:	00 00 00 
  8007f2:	ff d0                	callq  *%rax
  8007f4:	89 c6                	mov    %eax,%esi
  8007f6:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8007fc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800803:	41 89 d0             	mov    %edx,%r8d
  800806:	48 89 c1             	mov    %rax,%rcx
  800809:	48 89 da             	mov    %rbx,%rdx
  80080c:	48 bf 80 51 80 00 00 	movabs $0x805180,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	49 b9 8c 09 80 00 00 	movabs $0x80098c,%r9
  800822:	00 00 00 
  800825:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800828:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80082f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800836:	48 89 d6             	mov    %rdx,%rsi
  800839:	48 89 c7             	mov    %rax,%rdi
  80083c:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800843:	00 00 00 
  800846:	ff d0                	callq  *%rax
	cprintf("\n");
  800848:	48 bf a3 51 80 00 00 	movabs $0x8051a3,%rdi
  80084f:	00 00 00 
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
  800857:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80085e:	00 00 00 
  800861:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800863:	cc                   	int3   
  800864:	eb fd                	jmp    800863 <_panic+0x111>

0000000000800866 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800866:	55                   	push   %rbp
  800867:	48 89 e5             	mov    %rsp,%rbp
  80086a:	48 83 ec 10          	sub    $0x10,%rsp
  80086e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800871:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800879:	8b 00                	mov    (%rax),%eax
  80087b:	8d 48 01             	lea    0x1(%rax),%ecx
  80087e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800882:	89 0a                	mov    %ecx,(%rdx)
  800884:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800887:	89 d1                	mov    %edx,%ecx
  800889:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80088d:	48 98                	cltq   
  80088f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800897:	8b 00                	mov    (%rax),%eax
  800899:	3d ff 00 00 00       	cmp    $0xff,%eax
  80089e:	75 2c                	jne    8008cc <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8008a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	48 98                	cltq   
  8008a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ac:	48 83 c2 08          	add    $0x8,%rdx
  8008b0:	48 89 c6             	mov    %rax,%rsi
  8008b3:	48 89 d7             	mov    %rdx,%rdi
  8008b6:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  8008bd:	00 00 00 
  8008c0:	ff d0                	callq  *%rax
        b->idx = 0;
  8008c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d0:	8b 40 04             	mov    0x4(%rax),%eax
  8008d3:	8d 50 01             	lea    0x1(%rax),%edx
  8008d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008da:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008dd:	90                   	nop
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008eb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008f2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8008f9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800900:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800907:	48 8b 0a             	mov    (%rdx),%rcx
  80090a:	48 89 08             	mov    %rcx,(%rax)
  80090d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800911:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800915:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800919:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80091d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800924:	00 00 00 
    b.cnt = 0;
  800927:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80092e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800931:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800938:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80093f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800946:	48 89 c6             	mov    %rax,%rsi
  800949:	48 bf 66 08 80 00 00 	movabs $0x800866,%rdi
  800950:	00 00 00 
  800953:	48 b8 2a 0d 80 00 00 	movabs $0x800d2a,%rax
  80095a:	00 00 00 
  80095d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80095f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800965:	48 98                	cltq   
  800967:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80096e:	48 83 c2 08          	add    $0x8,%rdx
  800972:	48 89 c6             	mov    %rax,%rsi
  800975:	48 89 d7             	mov    %rdx,%rdi
  800978:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  80097f:	00 00 00 
  800982:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800984:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80098a:	c9                   	leaveq 
  80098b:	c3                   	retq   

000000000080098c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80098c:	55                   	push   %rbp
  80098d:	48 89 e5             	mov    %rsp,%rbp
  800990:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800997:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80099e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8009a5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009ac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009b3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009ba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009c1:	84 c0                	test   %al,%al
  8009c3:	74 20                	je     8009e5 <cprintf+0x59>
  8009c5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009c9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009cd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009d1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009d5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009d9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009dd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009e1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009e5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009ec:	00 00 00 
  8009ef:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009f6:	00 00 00 
  8009f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009fd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a04:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a0b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a12:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a19:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a20:	48 8b 0a             	mov    (%rdx),%rcx
  800a23:	48 89 08             	mov    %rcx,(%rax)
  800a26:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a2a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a32:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a36:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a3d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a44:	48 89 d6             	mov    %rdx,%rsi
  800a47:	48 89 c7             	mov    %rax,%rdi
  800a4a:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800a51:	00 00 00 
  800a54:	ff d0                	callq  *%rax
  800a56:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a5c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a62:	c9                   	leaveq 
  800a63:	c3                   	retq   

0000000000800a64 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a64:	55                   	push   %rbp
  800a65:	48 89 e5             	mov    %rsp,%rbp
  800a68:	48 83 ec 30          	sub    $0x30,%rsp
  800a6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800a74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800a78:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800a7b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800a7f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a83:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800a86:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800a8a:	77 54                	ja     800ae0 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800a8f:	8d 78 ff             	lea    -0x1(%rax),%edi
  800a92:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a99:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9e:	48 f7 f6             	div    %rsi
  800aa1:	49 89 c2             	mov    %rax,%r10
  800aa4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800aa7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800aaa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ab2:	41 89 c9             	mov    %ecx,%r9d
  800ab5:	41 89 f8             	mov    %edi,%r8d
  800ab8:	89 d1                	mov    %edx,%ecx
  800aba:	4c 89 d2             	mov    %r10,%rdx
  800abd:	48 89 c7             	mov    %rax,%rdi
  800ac0:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
  800acc:	eb 1c                	jmp    800aea <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800ad2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ad5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ad9:	48 89 ce             	mov    %rcx,%rsi
  800adc:	89 d7                	mov    %edx,%edi
  800ade:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae0:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800ae4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800ae8:	7f e4                	jg     800ace <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aea:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af1:	ba 00 00 00 00       	mov    $0x0,%edx
  800af6:	48 f7 f1             	div    %rcx
  800af9:	48 b8 b0 53 80 00 00 	movabs $0x8053b0,%rax
  800b00:	00 00 00 
  800b03:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800b07:	0f be d0             	movsbl %al,%edx
  800b0a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800b0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800b12:	48 89 ce             	mov    %rcx,%rsi
  800b15:	89 d7                	mov    %edx,%edi
  800b17:	ff d0                	callq  *%rax
}
  800b19:	90                   	nop
  800b1a:	c9                   	leaveq 
  800b1b:	c3                   	retq   

0000000000800b1c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1c:	55                   	push   %rbp
  800b1d:	48 89 e5             	mov    %rsp,%rbp
  800b20:	48 83 ec 20          	sub    $0x20,%rsp
  800b24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b28:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b2b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b2f:	7e 4f                	jle    800b80 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	8b 00                	mov    (%rax),%eax
  800b37:	83 f8 30             	cmp    $0x30,%eax
  800b3a:	73 24                	jae    800b60 <getuint+0x44>
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b48:	8b 00                	mov    (%rax),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b53:	8b 12                	mov    (%rdx),%edx
  800b55:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5c:	89 0a                	mov    %ecx,(%rdx)
  800b5e:	eb 14                	jmp    800b74 <getuint+0x58>
  800b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b64:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b68:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b70:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b74:	48 8b 00             	mov    (%rax),%rax
  800b77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7b:	e9 9d 00 00 00       	jmpq   800c1d <getuint+0x101>
	else if (lflag)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b84:	74 4c                	je     800bd2 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8a:	8b 00                	mov    (%rax),%eax
  800b8c:	83 f8 30             	cmp    $0x30,%eax
  800b8f:	73 24                	jae    800bb5 <getuint+0x99>
  800b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b95:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9d:	8b 00                	mov    (%rax),%eax
  800b9f:	89 c0                	mov    %eax,%eax
  800ba1:	48 01 d0             	add    %rdx,%rax
  800ba4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba8:	8b 12                	mov    (%rdx),%edx
  800baa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb1:	89 0a                	mov    %ecx,(%rdx)
  800bb3:	eb 14                	jmp    800bc9 <getuint+0xad>
  800bb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bbd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800bc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bc9:	48 8b 00             	mov    (%rax),%rax
  800bcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bd0:	eb 4b                	jmp    800c1d <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd6:	8b 00                	mov    (%rax),%eax
  800bd8:	83 f8 30             	cmp    $0x30,%eax
  800bdb:	73 24                	jae    800c01 <getuint+0xe5>
  800bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be9:	8b 00                	mov    (%rax),%eax
  800beb:	89 c0                	mov    %eax,%eax
  800bed:	48 01 d0             	add    %rdx,%rax
  800bf0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf4:	8b 12                	mov    (%rdx),%edx
  800bf6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bf9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfd:	89 0a                	mov    %ecx,(%rdx)
  800bff:	eb 14                	jmp    800c15 <getuint+0xf9>
  800c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c05:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c09:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c0d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c11:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c15:	8b 00                	mov    (%rax),%eax
  800c17:	89 c0                	mov    %eax,%eax
  800c19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c21:	c9                   	leaveq 
  800c22:	c3                   	retq   

0000000000800c23 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c23:	55                   	push   %rbp
  800c24:	48 89 e5             	mov    %rsp,%rbp
  800c27:	48 83 ec 20          	sub    $0x20,%rsp
  800c2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c2f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c32:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c36:	7e 4f                	jle    800c87 <getint+0x64>
		x=va_arg(*ap, long long);
  800c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3c:	8b 00                	mov    (%rax),%eax
  800c3e:	83 f8 30             	cmp    $0x30,%eax
  800c41:	73 24                	jae    800c67 <getint+0x44>
  800c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c47:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4f:	8b 00                	mov    (%rax),%eax
  800c51:	89 c0                	mov    %eax,%eax
  800c53:	48 01 d0             	add    %rdx,%rax
  800c56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c5a:	8b 12                	mov    (%rdx),%edx
  800c5c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c63:	89 0a                	mov    %ecx,(%rdx)
  800c65:	eb 14                	jmp    800c7b <getint+0x58>
  800c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c6f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c77:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c7b:	48 8b 00             	mov    (%rax),%rax
  800c7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c82:	e9 9d 00 00 00       	jmpq   800d24 <getint+0x101>
	else if (lflag)
  800c87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c8b:	74 4c                	je     800cd9 <getint+0xb6>
		x=va_arg(*ap, long);
  800c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c91:	8b 00                	mov    (%rax),%eax
  800c93:	83 f8 30             	cmp    $0x30,%eax
  800c96:	73 24                	jae    800cbc <getint+0x99>
  800c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ca0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca4:	8b 00                	mov    (%rax),%eax
  800ca6:	89 c0                	mov    %eax,%eax
  800ca8:	48 01 d0             	add    %rdx,%rax
  800cab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800caf:	8b 12                	mov    (%rdx),%edx
  800cb1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cb4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb8:	89 0a                	mov    %ecx,(%rdx)
  800cba:	eb 14                	jmp    800cd0 <getint+0xad>
  800cbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800cc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cd0:	48 8b 00             	mov    (%rax),%rax
  800cd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cd7:	eb 4b                	jmp    800d24 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdd:	8b 00                	mov    (%rax),%eax
  800cdf:	83 f8 30             	cmp    $0x30,%eax
  800ce2:	73 24                	jae    800d08 <getint+0xe5>
  800ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf0:	8b 00                	mov    (%rax),%eax
  800cf2:	89 c0                	mov    %eax,%eax
  800cf4:	48 01 d0             	add    %rdx,%rax
  800cf7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfb:	8b 12                	mov    (%rdx),%edx
  800cfd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d04:	89 0a                	mov    %ecx,(%rdx)
  800d06:	eb 14                	jmp    800d1c <getint+0xf9>
  800d08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d10:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d18:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d1c:	8b 00                	mov    (%rax),%eax
  800d1e:	48 98                	cltq   
  800d20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d28:	c9                   	leaveq 
  800d29:	c3                   	retq   

0000000000800d2a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2a:	55                   	push   %rbp
  800d2b:	48 89 e5             	mov    %rsp,%rbp
  800d2e:	41 54                	push   %r12
  800d30:	53                   	push   %rbx
  800d31:	48 83 ec 60          	sub    $0x60,%rsp
  800d35:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d39:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d3d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d41:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d45:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d49:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d4d:	48 8b 0a             	mov    (%rdx),%rcx
  800d50:	48 89 08             	mov    %rcx,(%rax)
  800d53:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d57:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d5b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d5f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d63:	eb 17                	jmp    800d7c <vprintfmt+0x52>
			if (ch == '\0')
  800d65:	85 db                	test   %ebx,%ebx
  800d67:	0f 84 b9 04 00 00    	je     801226 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800d6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d75:	48 89 d6             	mov    %rdx,%rsi
  800d78:	89 df                	mov    %ebx,%edi
  800d7a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d80:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d84:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d88:	0f b6 00             	movzbl (%rax),%eax
  800d8b:	0f b6 d8             	movzbl %al,%ebx
  800d8e:	83 fb 25             	cmp    $0x25,%ebx
  800d91:	75 d2                	jne    800d65 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d93:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800d97:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800d9e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800da5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800db7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dbb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800dbf:	0f b6 00             	movzbl (%rax),%eax
  800dc2:	0f b6 d8             	movzbl %al,%ebx
  800dc5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800dc8:	83 f8 55             	cmp    $0x55,%eax
  800dcb:	0f 87 22 04 00 00    	ja     8011f3 <vprintfmt+0x4c9>
  800dd1:	89 c0                	mov    %eax,%eax
  800dd3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800dda:	00 
  800ddb:	48 b8 d8 53 80 00 00 	movabs $0x8053d8,%rax
  800de2:	00 00 00 
  800de5:	48 01 d0             	add    %rdx,%rax
  800de8:	48 8b 00             	mov    (%rax),%rax
  800deb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ded:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800df1:	eb c0                	jmp    800db3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800df3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800df7:	eb ba                	jmp    800db3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800df9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e00:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e03:	89 d0                	mov    %edx,%eax
  800e05:	c1 e0 02             	shl    $0x2,%eax
  800e08:	01 d0                	add    %edx,%eax
  800e0a:	01 c0                	add    %eax,%eax
  800e0c:	01 d8                	add    %ebx,%eax
  800e0e:	83 e8 30             	sub    $0x30,%eax
  800e11:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e14:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e18:	0f b6 00             	movzbl (%rax),%eax
  800e1b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e1e:	83 fb 2f             	cmp    $0x2f,%ebx
  800e21:	7e 60                	jle    800e83 <vprintfmt+0x159>
  800e23:	83 fb 39             	cmp    $0x39,%ebx
  800e26:	7f 5b                	jg     800e83 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e28:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e2d:	eb d1                	jmp    800e00 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800e2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e32:	83 f8 30             	cmp    $0x30,%eax
  800e35:	73 17                	jae    800e4e <vprintfmt+0x124>
  800e37:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e3b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e3e:	89 d2                	mov    %edx,%edx
  800e40:	48 01 d0             	add    %rdx,%rax
  800e43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e46:	83 c2 08             	add    $0x8,%edx
  800e49:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e4c:	eb 0c                	jmp    800e5a <vprintfmt+0x130>
  800e4e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e52:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e56:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5a:	8b 00                	mov    (%rax),%eax
  800e5c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e5f:	eb 23                	jmp    800e84 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800e61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e65:	0f 89 48 ff ff ff    	jns    800db3 <vprintfmt+0x89>
				width = 0;
  800e6b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e72:	e9 3c ff ff ff       	jmpq   800db3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e77:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e7e:	e9 30 ff ff ff       	jmpq   800db3 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e88:	0f 89 25 ff ff ff    	jns    800db3 <vprintfmt+0x89>
				width = precision, precision = -1;
  800e8e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e91:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e94:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e9b:	e9 13 ff ff ff       	jmpq   800db3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ea4:	e9 0a ff ff ff       	jmpq   800db3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ea9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eac:	83 f8 30             	cmp    $0x30,%eax
  800eaf:	73 17                	jae    800ec8 <vprintfmt+0x19e>
  800eb1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eb8:	89 d2                	mov    %edx,%edx
  800eba:	48 01 d0             	add    %rdx,%rax
  800ebd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ec0:	83 c2 08             	add    $0x8,%edx
  800ec3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ec6:	eb 0c                	jmp    800ed4 <vprintfmt+0x1aa>
  800ec8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ecc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ed0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ed4:	8b 10                	mov    (%rax),%edx
  800ed6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800eda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ede:	48 89 ce             	mov    %rcx,%rsi
  800ee1:	89 d7                	mov    %edx,%edi
  800ee3:	ff d0                	callq  *%rax
			break;
  800ee5:	e9 37 03 00 00       	jmpq   801221 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800eea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eed:	83 f8 30             	cmp    $0x30,%eax
  800ef0:	73 17                	jae    800f09 <vprintfmt+0x1df>
  800ef2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ef9:	89 d2                	mov    %edx,%edx
  800efb:	48 01 d0             	add    %rdx,%rax
  800efe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f01:	83 c2 08             	add    $0x8,%edx
  800f04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f07:	eb 0c                	jmp    800f15 <vprintfmt+0x1eb>
  800f09:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f0d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f15:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f17:	85 db                	test   %ebx,%ebx
  800f19:	79 02                	jns    800f1d <vprintfmt+0x1f3>
				err = -err;
  800f1b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f1d:	83 fb 15             	cmp    $0x15,%ebx
  800f20:	7f 16                	jg     800f38 <vprintfmt+0x20e>
  800f22:	48 b8 00 53 80 00 00 	movabs $0x805300,%rax
  800f29:	00 00 00 
  800f2c:	48 63 d3             	movslq %ebx,%rdx
  800f2f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f33:	4d 85 e4             	test   %r12,%r12
  800f36:	75 2e                	jne    800f66 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800f38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f40:	89 d9                	mov    %ebx,%ecx
  800f42:	48 ba c1 53 80 00 00 	movabs $0x8053c1,%rdx
  800f49:	00 00 00 
  800f4c:	48 89 c7             	mov    %rax,%rdi
  800f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f54:	49 b8 30 12 80 00 00 	movabs $0x801230,%r8
  800f5b:	00 00 00 
  800f5e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f61:	e9 bb 02 00 00       	jmpq   801221 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f66:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6e:	4c 89 e1             	mov    %r12,%rcx
  800f71:	48 ba ca 53 80 00 00 	movabs $0x8053ca,%rdx
  800f78:	00 00 00 
  800f7b:	48 89 c7             	mov    %rax,%rdi
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f83:	49 b8 30 12 80 00 00 	movabs $0x801230,%r8
  800f8a:	00 00 00 
  800f8d:	41 ff d0             	callq  *%r8
			break;
  800f90:	e9 8c 02 00 00       	jmpq   801221 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800f95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f98:	83 f8 30             	cmp    $0x30,%eax
  800f9b:	73 17                	jae    800fb4 <vprintfmt+0x28a>
  800f9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fa4:	89 d2                	mov    %edx,%edx
  800fa6:	48 01 d0             	add    %rdx,%rax
  800fa9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fac:	83 c2 08             	add    $0x8,%edx
  800faf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fb2:	eb 0c                	jmp    800fc0 <vprintfmt+0x296>
  800fb4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fb8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fbc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fc0:	4c 8b 20             	mov    (%rax),%r12
  800fc3:	4d 85 e4             	test   %r12,%r12
  800fc6:	75 0a                	jne    800fd2 <vprintfmt+0x2a8>
				p = "(null)";
  800fc8:	49 bc cd 53 80 00 00 	movabs $0x8053cd,%r12
  800fcf:	00 00 00 
			if (width > 0 && padc != '-')
  800fd2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fd6:	7e 78                	jle    801050 <vprintfmt+0x326>
  800fd8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800fdc:	74 72                	je     801050 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fde:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800fe1:	48 98                	cltq   
  800fe3:	48 89 c6             	mov    %rax,%rsi
  800fe6:	4c 89 e7             	mov    %r12,%rdi
  800fe9:	48 b8 de 14 80 00 00 	movabs $0x8014de,%rax
  800ff0:	00 00 00 
  800ff3:	ff d0                	callq  *%rax
  800ff5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ff8:	eb 17                	jmp    801011 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800ffa:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ffe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801002:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801006:	48 89 ce             	mov    %rcx,%rsi
  801009:	89 d7                	mov    %edx,%edi
  80100b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801011:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801015:	7f e3                	jg     800ffa <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801017:	eb 37                	jmp    801050 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  801019:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80101d:	74 1e                	je     80103d <vprintfmt+0x313>
  80101f:	83 fb 1f             	cmp    $0x1f,%ebx
  801022:	7e 05                	jle    801029 <vprintfmt+0x2ff>
  801024:	83 fb 7e             	cmp    $0x7e,%ebx
  801027:	7e 14                	jle    80103d <vprintfmt+0x313>
					putch('?', putdat);
  801029:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80102d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801031:	48 89 d6             	mov    %rdx,%rsi
  801034:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801039:	ff d0                	callq  *%rax
  80103b:	eb 0f                	jmp    80104c <vprintfmt+0x322>
				else
					putch(ch, putdat);
  80103d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801041:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801045:	48 89 d6             	mov    %rdx,%rsi
  801048:	89 df                	mov    %ebx,%edi
  80104a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80104c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801050:	4c 89 e0             	mov    %r12,%rax
  801053:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	0f be d8             	movsbl %al,%ebx
  80105d:	85 db                	test   %ebx,%ebx
  80105f:	74 28                	je     801089 <vprintfmt+0x35f>
  801061:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801065:	78 b2                	js     801019 <vprintfmt+0x2ef>
  801067:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80106b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80106f:	79 a8                	jns    801019 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801071:	eb 16                	jmp    801089 <vprintfmt+0x35f>
				putch(' ', putdat);
  801073:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801077:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80107b:	48 89 d6             	mov    %rdx,%rsi
  80107e:	bf 20 00 00 00       	mov    $0x20,%edi
  801083:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801085:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801089:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80108d:	7f e4                	jg     801073 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  80108f:	e9 8d 01 00 00       	jmpq   801221 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801094:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801098:	be 03 00 00 00       	mov    $0x3,%esi
  80109d:	48 89 c7             	mov    %rax,%rdi
  8010a0:	48 b8 23 0c 80 00 00 	movabs $0x800c23,%rax
  8010a7:	00 00 00 
  8010aa:	ff d0                	callq  *%rax
  8010ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	48 85 c0             	test   %rax,%rax
  8010b7:	79 1d                	jns    8010d6 <vprintfmt+0x3ac>
				putch('-', putdat);
  8010b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c1:	48 89 d6             	mov    %rdx,%rsi
  8010c4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010c9:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	48 f7 d8             	neg    %rax
  8010d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8010d6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010dd:	e9 d2 00 00 00       	jmpq   8011b4 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8010e2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010e6:	be 03 00 00 00       	mov    $0x3,%esi
  8010eb:	48 89 c7             	mov    %rax,%rdi
  8010ee:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
  8010fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8010fe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801105:	e9 aa 00 00 00       	jmpq   8011b4 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  80110a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80110e:	be 03 00 00 00       	mov    $0x3,%esi
  801113:	48 89 c7             	mov    %rax,%rdi
  801116:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  80111d:	00 00 00 
  801120:	ff d0                	callq  *%rax
  801122:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801126:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80112d:	e9 82 00 00 00       	jmpq   8011b4 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  801132:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801136:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80113a:	48 89 d6             	mov    %rdx,%rsi
  80113d:	bf 30 00 00 00       	mov    $0x30,%edi
  801142:	ff d0                	callq  *%rax
			putch('x', putdat);
  801144:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801148:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80114c:	48 89 d6             	mov    %rdx,%rsi
  80114f:	bf 78 00 00 00       	mov    $0x78,%edi
  801154:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801156:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801159:	83 f8 30             	cmp    $0x30,%eax
  80115c:	73 17                	jae    801175 <vprintfmt+0x44b>
  80115e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801162:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801165:	89 d2                	mov    %edx,%edx
  801167:	48 01 d0             	add    %rdx,%rax
  80116a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80116d:	83 c2 08             	add    $0x8,%edx
  801170:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801173:	eb 0c                	jmp    801181 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801175:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801179:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80117d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801181:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801184:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801188:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80118f:	eb 23                	jmp    8011b4 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801191:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801195:	be 03 00 00 00       	mov    $0x3,%esi
  80119a:	48 89 c7             	mov    %rax,%rdi
  80119d:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  8011a4:	00 00 00 
  8011a7:	ff d0                	callq  *%rax
  8011a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011ad:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011b4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011b9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011bc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011cb:	45 89 c1             	mov    %r8d,%r9d
  8011ce:	41 89 f8             	mov    %edi,%r8d
  8011d1:	48 89 c7             	mov    %rax,%rdi
  8011d4:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  8011db:	00 00 00 
  8011de:	ff d0                	callq  *%rax
			break;
  8011e0:	eb 3f                	jmp    801221 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011e2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ea:	48 89 d6             	mov    %rdx,%rsi
  8011ed:	89 df                	mov    %ebx,%edi
  8011ef:	ff d0                	callq  *%rax
			break;
  8011f1:	eb 2e                	jmp    801221 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fb:	48 89 d6             	mov    %rdx,%rsi
  8011fe:	bf 25 00 00 00       	mov    $0x25,%edi
  801203:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801205:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80120a:	eb 05                	jmp    801211 <vprintfmt+0x4e7>
  80120c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801211:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801215:	48 83 e8 01          	sub    $0x1,%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	3c 25                	cmp    $0x25,%al
  80121e:	75 ec                	jne    80120c <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  801220:	90                   	nop
		}
	}
  801221:	e9 3d fb ff ff       	jmpq   800d63 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801226:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801227:	48 83 c4 60          	add    $0x60,%rsp
  80122b:	5b                   	pop    %rbx
  80122c:	41 5c                	pop    %r12
  80122e:	5d                   	pop    %rbp
  80122f:	c3                   	retq   

0000000000801230 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801230:	55                   	push   %rbp
  801231:	48 89 e5             	mov    %rsp,%rbp
  801234:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80123b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801242:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801249:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801250:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801257:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80125e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801265:	84 c0                	test   %al,%al
  801267:	74 20                	je     801289 <printfmt+0x59>
  801269:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80126d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801271:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801275:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801279:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80127d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801281:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801285:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801289:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801290:	00 00 00 
  801293:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80129a:	00 00 00 
  80129d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012a1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012af:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012b6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012bd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012c4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012cb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012d2:	48 89 c7             	mov    %rax,%rdi
  8012d5:	48 b8 2a 0d 80 00 00 	movabs $0x800d2a,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
	va_end(ap);
}
  8012e1:	90                   	nop
  8012e2:	c9                   	leaveq 
  8012e3:	c3                   	retq   

00000000008012e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012e4:	55                   	push   %rbp
  8012e5:	48 89 e5             	mov    %rsp,%rbp
  8012e8:	48 83 ec 10          	sub    $0x10,%rsp
  8012ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8012ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8012f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f7:	8b 40 10             	mov    0x10(%rax),%eax
  8012fa:	8d 50 01             	lea    0x1(%rax),%edx
  8012fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801301:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801308:	48 8b 10             	mov    (%rax),%rdx
  80130b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801313:	48 39 c2             	cmp    %rax,%rdx
  801316:	73 17                	jae    80132f <sprintputch+0x4b>
		*b->buf++ = ch;
  801318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131c:	48 8b 00             	mov    (%rax),%rax
  80131f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801323:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801327:	48 89 0a             	mov    %rcx,(%rdx)
  80132a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80132d:	88 10                	mov    %dl,(%rax)
}
  80132f:	90                   	nop
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 50          	sub    $0x50,%rsp
  80133a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80133e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801341:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801345:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801349:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80134d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801351:	48 8b 0a             	mov    (%rdx),%rcx
  801354:	48 89 08             	mov    %rcx,(%rax)
  801357:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80135b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80135f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801363:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801367:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80136b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80136f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801372:	48 98                	cltq   
  801374:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801378:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80137c:	48 01 d0             	add    %rdx,%rax
  80137f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801383:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80138a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80138f:	74 06                	je     801397 <vsnprintf+0x65>
  801391:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801395:	7f 07                	jg     80139e <vsnprintf+0x6c>
		return -E_INVAL;
  801397:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139c:	eb 2f                	jmp    8013cd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80139e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013a2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013a6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013aa:	48 89 c6             	mov    %rax,%rsi
  8013ad:	48 bf e4 12 80 00 00 	movabs $0x8012e4,%rdi
  8013b4:	00 00 00 
  8013b7:	48 b8 2a 0d 80 00 00 	movabs $0x800d2a,%rax
  8013be:	00 00 00 
  8013c1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013c7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013ca:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013cd:	c9                   	leaveq 
  8013ce:	c3                   	retq   

00000000008013cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013cf:	55                   	push   %rbp
  8013d0:	48 89 e5             	mov    %rsp,%rbp
  8013d3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013da:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8013e1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8013e7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8013ee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013f5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013fc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801403:	84 c0                	test   %al,%al
  801405:	74 20                	je     801427 <snprintf+0x58>
  801407:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80140b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80140f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801413:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801417:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80141b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80141f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801423:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801427:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80142e:	00 00 00 
  801431:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801438:	00 00 00 
  80143b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80143f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801446:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80144d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801454:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80145b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801462:	48 8b 0a             	mov    (%rdx),%rcx
  801465:	48 89 08             	mov    %rcx,(%rax)
  801468:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80146c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801470:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801474:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801478:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80147f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801486:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80148c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801493:	48 89 c7             	mov    %rax,%rdi
  801496:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  80149d:	00 00 00 
  8014a0:	ff d0                	callq  *%rax
  8014a2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014a8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014ae:	c9                   	leaveq 
  8014af:	c3                   	retq   

00000000008014b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014b0:	55                   	push   %rbp
  8014b1:	48 89 e5             	mov    %rsp,%rbp
  8014b4:	48 83 ec 18          	sub    $0x18,%rsp
  8014b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014c3:	eb 09                	jmp    8014ce <strlen+0x1e>
		n++;
  8014c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	84 c0                	test   %al,%al
  8014d7:	75 ec                	jne    8014c5 <strlen+0x15>
		n++;
	return n;
  8014d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014dc:	c9                   	leaveq 
  8014dd:	c3                   	retq   

00000000008014de <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8014de:	55                   	push   %rbp
  8014df:	48 89 e5             	mov    %rsp,%rbp
  8014e2:	48 83 ec 20          	sub    $0x20,%rsp
  8014e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014f5:	eb 0e                	jmp    801505 <strnlen+0x27>
		n++;
  8014f7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014fb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801500:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801505:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80150a:	74 0b                	je     801517 <strnlen+0x39>
  80150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	84 c0                	test   %al,%al
  801515:	75 e0                	jne    8014f7 <strnlen+0x19>
		n++;
	return n;
  801517:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80151a:	c9                   	leaveq 
  80151b:	c3                   	retq   

000000000080151c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80151c:	55                   	push   %rbp
  80151d:	48 89 e5             	mov    %rsp,%rbp
  801520:	48 83 ec 20          	sub    $0x20,%rsp
  801524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801528:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80152c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801530:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801534:	90                   	nop
  801535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801539:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801541:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801545:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801549:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80154d:	0f b6 12             	movzbl (%rdx),%edx
  801550:	88 10                	mov    %dl,(%rax)
  801552:	0f b6 00             	movzbl (%rax),%eax
  801555:	84 c0                	test   %al,%al
  801557:	75 dc                	jne    801535 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80155d:	c9                   	leaveq 
  80155e:	c3                   	retq   

000000000080155f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80155f:	55                   	push   %rbp
  801560:	48 89 e5             	mov    %rsp,%rbp
  801563:	48 83 ec 20          	sub    $0x20,%rsp
  801567:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80156b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80156f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801573:	48 89 c7             	mov    %rax,%rdi
  801576:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  80157d:	00 00 00 
  801580:	ff d0                	callq  *%rax
  801582:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801585:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801588:	48 63 d0             	movslq %eax,%rdx
  80158b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158f:	48 01 c2             	add    %rax,%rdx
  801592:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801596:	48 89 c6             	mov    %rax,%rsi
  801599:	48 89 d7             	mov    %rdx,%rdi
  80159c:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  8015a3:	00 00 00 
  8015a6:	ff d0                	callq  *%rax
	return dst;
  8015a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ac:	c9                   	leaveq 
  8015ad:	c3                   	retq   

00000000008015ae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015ae:	55                   	push   %rbp
  8015af:	48 89 e5             	mov    %rsp,%rbp
  8015b2:	48 83 ec 28          	sub    $0x28,%rsp
  8015b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015ca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015d1:	00 
  8015d2:	eb 2a                	jmp    8015fe <strncpy+0x50>
		*dst++ = *src;
  8015d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015e4:	0f b6 12             	movzbl (%rdx),%edx
  8015e7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8015e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	84 c0                	test   %al,%al
  8015f2:	74 05                	je     8015f9 <strncpy+0x4b>
			src++;
  8015f4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8015f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801602:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801606:	72 cc                	jb     8015d4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80160c:	c9                   	leaveq 
  80160d:	c3                   	retq   

000000000080160e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
  801612:	48 83 ec 28          	sub    $0x28,%rsp
  801616:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80161a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80161e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801626:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80162a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80162f:	74 3d                	je     80166e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801631:	eb 1d                	jmp    801650 <strlcpy+0x42>
			*dst++ = *src++;
  801633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801637:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80163b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80163f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801643:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801647:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80164b:	0f b6 12             	movzbl (%rdx),%edx
  80164e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801650:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801655:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80165a:	74 0b                	je     801667 <strlcpy+0x59>
  80165c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801660:	0f b6 00             	movzbl (%rax),%eax
  801663:	84 c0                	test   %al,%al
  801665:	75 cc                	jne    801633 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80166e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801676:	48 29 c2             	sub    %rax,%rdx
  801679:	48 89 d0             	mov    %rdx,%rax
}
  80167c:	c9                   	leaveq 
  80167d:	c3                   	retq   

000000000080167e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80167e:	55                   	push   %rbp
  80167f:	48 89 e5             	mov    %rsp,%rbp
  801682:	48 83 ec 10          	sub    $0x10,%rsp
  801686:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80168a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80168e:	eb 0a                	jmp    80169a <strcmp+0x1c>
		p++, q++;
  801690:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801695:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80169a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169e:	0f b6 00             	movzbl (%rax),%eax
  8016a1:	84 c0                	test   %al,%al
  8016a3:	74 12                	je     8016b7 <strcmp+0x39>
  8016a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a9:	0f b6 10             	movzbl (%rax),%edx
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	38 c2                	cmp    %al,%dl
  8016b5:	74 d9                	je     801690 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f b6 d0             	movzbl %al,%edx
  8016c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	0f b6 c0             	movzbl %al,%eax
  8016cb:	29 c2                	sub    %eax,%edx
  8016cd:	89 d0                	mov    %edx,%eax
}
  8016cf:	c9                   	leaveq 
  8016d0:	c3                   	retq   

00000000008016d1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016d1:	55                   	push   %rbp
  8016d2:	48 89 e5             	mov    %rsp,%rbp
  8016d5:	48 83 ec 18          	sub    $0x18,%rsp
  8016d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8016e5:	eb 0f                	jmp    8016f6 <strncmp+0x25>
		n--, p++, q++;
  8016e7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8016ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016f1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8016f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016fb:	74 1d                	je     80171a <strncmp+0x49>
  8016fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	84 c0                	test   %al,%al
  801706:	74 12                	je     80171a <strncmp+0x49>
  801708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170c:	0f b6 10             	movzbl (%rax),%edx
  80170f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801713:	0f b6 00             	movzbl (%rax),%eax
  801716:	38 c2                	cmp    %al,%dl
  801718:	74 cd                	je     8016e7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80171a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80171f:	75 07                	jne    801728 <strncmp+0x57>
		return 0;
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
  801726:	eb 18                	jmp    801740 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	0f b6 d0             	movzbl %al,%edx
  801732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	0f b6 c0             	movzbl %al,%eax
  80173c:	29 c2                	sub    %eax,%edx
  80173e:	89 d0                	mov    %edx,%eax
}
  801740:	c9                   	leaveq 
  801741:	c3                   	retq   

0000000000801742 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801742:	55                   	push   %rbp
  801743:	48 89 e5             	mov    %rsp,%rbp
  801746:	48 83 ec 10          	sub    $0x10,%rsp
  80174a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174e:	89 f0                	mov    %esi,%eax
  801750:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801753:	eb 17                	jmp    80176c <strchr+0x2a>
		if (*s == c)
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80175f:	75 06                	jne    801767 <strchr+0x25>
			return (char *) s;
  801761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801765:	eb 15                	jmp    80177c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801767:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80176c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801770:	0f b6 00             	movzbl (%rax),%eax
  801773:	84 c0                	test   %al,%al
  801775:	75 de                	jne    801755 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177c:	c9                   	leaveq 
  80177d:	c3                   	retq   

000000000080177e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177e:	55                   	push   %rbp
  80177f:	48 89 e5             	mov    %rsp,%rbp
  801782:	48 83 ec 10          	sub    $0x10,%rsp
  801786:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80178a:	89 f0                	mov    %esi,%eax
  80178c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80178f:	eb 11                	jmp    8017a2 <strfind+0x24>
		if (*s == c)
  801791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801795:	0f b6 00             	movzbl (%rax),%eax
  801798:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80179b:	74 12                	je     8017af <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80179d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a6:	0f b6 00             	movzbl (%rax),%eax
  8017a9:	84 c0                	test   %al,%al
  8017ab:	75 e4                	jne    801791 <strfind+0x13>
  8017ad:	eb 01                	jmp    8017b0 <strfind+0x32>
		if (*s == c)
			break;
  8017af:	90                   	nop
	return (char *) s;
  8017b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017b4:	c9                   	leaveq 
  8017b5:	c3                   	retq   

00000000008017b6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017b6:	55                   	push   %rbp
  8017b7:	48 89 e5             	mov    %rsp,%rbp
  8017ba:	48 83 ec 18          	sub    $0x18,%rsp
  8017be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017c2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ce:	75 06                	jne    8017d6 <memset+0x20>
		return v;
  8017d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d4:	eb 69                	jmp    80183f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017da:	83 e0 03             	and    $0x3,%eax
  8017dd:	48 85 c0             	test   %rax,%rax
  8017e0:	75 48                	jne    80182a <memset+0x74>
  8017e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e6:	83 e0 03             	and    $0x3,%eax
  8017e9:	48 85 c0             	test   %rax,%rax
  8017ec:	75 3c                	jne    80182a <memset+0x74>
		c &= 0xFF;
  8017ee:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8017f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017f8:	c1 e0 18             	shl    $0x18,%eax
  8017fb:	89 c2                	mov    %eax,%edx
  8017fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801800:	c1 e0 10             	shl    $0x10,%eax
  801803:	09 c2                	or     %eax,%edx
  801805:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801808:	c1 e0 08             	shl    $0x8,%eax
  80180b:	09 d0                	or     %edx,%eax
  80180d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801814:	48 c1 e8 02          	shr    $0x2,%rax
  801818:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80181b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80181f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801822:	48 89 d7             	mov    %rdx,%rdi
  801825:	fc                   	cld    
  801826:	f3 ab                	rep stos %eax,%es:(%rdi)
  801828:	eb 11                	jmp    80183b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80182a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80182e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801831:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801835:	48 89 d7             	mov    %rdx,%rdi
  801838:	fc                   	cld    
  801839:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80183b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80183f:	c9                   	leaveq 
  801840:	c3                   	retq   

0000000000801841 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801841:	55                   	push   %rbp
  801842:	48 89 e5             	mov    %rsp,%rbp
  801845:	48 83 ec 28          	sub    $0x28,%rsp
  801849:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801851:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801855:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801859:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80185d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801861:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801869:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80186d:	0f 83 88 00 00 00    	jae    8018fb <memmove+0xba>
  801873:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	48 01 d0             	add    %rdx,%rax
  80187e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801882:	76 77                	jbe    8018fb <memmove+0xba>
		s += n;
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80188c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801890:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801894:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801898:	83 e0 03             	and    $0x3,%eax
  80189b:	48 85 c0             	test   %rax,%rax
  80189e:	75 3b                	jne    8018db <memmove+0x9a>
  8018a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a4:	83 e0 03             	and    $0x3,%eax
  8018a7:	48 85 c0             	test   %rax,%rax
  8018aa:	75 2f                	jne    8018db <memmove+0x9a>
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	83 e0 03             	and    $0x3,%eax
  8018b3:	48 85 c0             	test   %rax,%rax
  8018b6:	75 23                	jne    8018db <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018bc:	48 83 e8 04          	sub    $0x4,%rax
  8018c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c4:	48 83 ea 04          	sub    $0x4,%rdx
  8018c8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018cc:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018d0:	48 89 c7             	mov    %rax,%rdi
  8018d3:	48 89 d6             	mov    %rdx,%rsi
  8018d6:	fd                   	std    
  8018d7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018d9:	eb 1d                	jmp    8018f8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018df:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8018eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ef:	48 89 d7             	mov    %rdx,%rdi
  8018f2:	48 89 c1             	mov    %rax,%rcx
  8018f5:	fd                   	std    
  8018f6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018f8:	fc                   	cld    
  8018f9:	eb 57                	jmp    801952 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ff:	83 e0 03             	and    $0x3,%eax
  801902:	48 85 c0             	test   %rax,%rax
  801905:	75 36                	jne    80193d <memmove+0xfc>
  801907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190b:	83 e0 03             	and    $0x3,%eax
  80190e:	48 85 c0             	test   %rax,%rax
  801911:	75 2a                	jne    80193d <memmove+0xfc>
  801913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801917:	83 e0 03             	and    $0x3,%eax
  80191a:	48 85 c0             	test   %rax,%rax
  80191d:	75 1e                	jne    80193d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	48 c1 e8 02          	shr    $0x2,%rax
  801927:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80192a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801932:	48 89 c7             	mov    %rax,%rdi
  801935:	48 89 d6             	mov    %rdx,%rsi
  801938:	fc                   	cld    
  801939:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80193b:	eb 15                	jmp    801952 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80193d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801941:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801945:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801949:	48 89 c7             	mov    %rax,%rdi
  80194c:	48 89 d6             	mov    %rdx,%rsi
  80194f:	fc                   	cld    
  801950:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 18          	sub    $0x18,%rsp
  801960:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801964:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801968:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80196c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801970:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801974:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801978:	48 89 ce             	mov    %rcx,%rsi
  80197b:	48 89 c7             	mov    %rax,%rdi
  80197e:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  801985:	00 00 00 
  801988:	ff d0                	callq  *%rax
}
  80198a:	c9                   	leaveq 
  80198b:	c3                   	retq   

000000000080198c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80198c:	55                   	push   %rbp
  80198d:	48 89 e5             	mov    %rsp,%rbp
  801990:	48 83 ec 28          	sub    $0x28,%rsp
  801994:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801998:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80199c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019b0:	eb 36                	jmp    8019e8 <memcmp+0x5c>
		if (*s1 != *s2)
  8019b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b6:	0f b6 10             	movzbl (%rax),%edx
  8019b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019bd:	0f b6 00             	movzbl (%rax),%eax
  8019c0:	38 c2                	cmp    %al,%dl
  8019c2:	74 1a                	je     8019de <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c8:	0f b6 00             	movzbl (%rax),%eax
  8019cb:	0f b6 d0             	movzbl %al,%edx
  8019ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	0f b6 c0             	movzbl %al,%eax
  8019d8:	29 c2                	sub    %eax,%edx
  8019da:	89 d0                	mov    %edx,%eax
  8019dc:	eb 20                	jmp    8019fe <memcmp+0x72>
		s1++, s2++;
  8019de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019e3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8019e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ec:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8019f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019f4:	48 85 c0             	test   %rax,%rax
  8019f7:	75 b9                	jne    8019b2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 28          	sub    $0x28,%rsp
  801a08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a0c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1b:	48 01 d0             	add    %rdx,%rax
  801a1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a22:	eb 19                	jmp    801a3d <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a28:	0f b6 00             	movzbl (%rax),%eax
  801a2b:	0f b6 d0             	movzbl %al,%edx
  801a2e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a31:	0f b6 c0             	movzbl %al,%eax
  801a34:	39 c2                	cmp    %eax,%edx
  801a36:	74 11                	je     801a49 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a38:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a41:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a45:	72 dd                	jb     801a24 <memfind+0x24>
  801a47:	eb 01                	jmp    801a4a <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a49:	90                   	nop
	return (void *) s;
  801a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a4e:	c9                   	leaveq 
  801a4f:	c3                   	retq   

0000000000801a50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a50:	55                   	push   %rbp
  801a51:	48 89 e5             	mov    %rsp,%rbp
  801a54:	48 83 ec 38          	sub    $0x38,%rsp
  801a58:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a5c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a60:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a6a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a71:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a72:	eb 05                	jmp    801a79 <strtol+0x29>
		s++;
  801a74:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7d:	0f b6 00             	movzbl (%rax),%eax
  801a80:	3c 20                	cmp    $0x20,%al
  801a82:	74 f0                	je     801a74 <strtol+0x24>
  801a84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a88:	0f b6 00             	movzbl (%rax),%eax
  801a8b:	3c 09                	cmp    $0x9,%al
  801a8d:	74 e5                	je     801a74 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a93:	0f b6 00             	movzbl (%rax),%eax
  801a96:	3c 2b                	cmp    $0x2b,%al
  801a98:	75 07                	jne    801aa1 <strtol+0x51>
		s++;
  801a9a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a9f:	eb 17                	jmp    801ab8 <strtol+0x68>
	else if (*s == '-')
  801aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa5:	0f b6 00             	movzbl (%rax),%eax
  801aa8:	3c 2d                	cmp    $0x2d,%al
  801aaa:	75 0c                	jne    801ab8 <strtol+0x68>
		s++, neg = 1;
  801aac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ab1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801abc:	74 06                	je     801ac4 <strtol+0x74>
  801abe:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801ac2:	75 28                	jne    801aec <strtol+0x9c>
  801ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac8:	0f b6 00             	movzbl (%rax),%eax
  801acb:	3c 30                	cmp    $0x30,%al
  801acd:	75 1d                	jne    801aec <strtol+0x9c>
  801acf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad3:	48 83 c0 01          	add    $0x1,%rax
  801ad7:	0f b6 00             	movzbl (%rax),%eax
  801ada:	3c 78                	cmp    $0x78,%al
  801adc:	75 0e                	jne    801aec <strtol+0x9c>
		s += 2, base = 16;
  801ade:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801ae3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801aea:	eb 2c                	jmp    801b18 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801aec:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801af0:	75 19                	jne    801b0b <strtol+0xbb>
  801af2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af6:	0f b6 00             	movzbl (%rax),%eax
  801af9:	3c 30                	cmp    $0x30,%al
  801afb:	75 0e                	jne    801b0b <strtol+0xbb>
		s++, base = 8;
  801afd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b02:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b09:	eb 0d                	jmp    801b18 <strtol+0xc8>
	else if (base == 0)
  801b0b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b0f:	75 07                	jne    801b18 <strtol+0xc8>
		base = 10;
  801b11:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1c:	0f b6 00             	movzbl (%rax),%eax
  801b1f:	3c 2f                	cmp    $0x2f,%al
  801b21:	7e 1d                	jle    801b40 <strtol+0xf0>
  801b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b27:	0f b6 00             	movzbl (%rax),%eax
  801b2a:	3c 39                	cmp    $0x39,%al
  801b2c:	7f 12                	jg     801b40 <strtol+0xf0>
			dig = *s - '0';
  801b2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b32:	0f b6 00             	movzbl (%rax),%eax
  801b35:	0f be c0             	movsbl %al,%eax
  801b38:	83 e8 30             	sub    $0x30,%eax
  801b3b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b3e:	eb 4e                	jmp    801b8e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b44:	0f b6 00             	movzbl (%rax),%eax
  801b47:	3c 60                	cmp    $0x60,%al
  801b49:	7e 1d                	jle    801b68 <strtol+0x118>
  801b4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4f:	0f b6 00             	movzbl (%rax),%eax
  801b52:	3c 7a                	cmp    $0x7a,%al
  801b54:	7f 12                	jg     801b68 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5a:	0f b6 00             	movzbl (%rax),%eax
  801b5d:	0f be c0             	movsbl %al,%eax
  801b60:	83 e8 57             	sub    $0x57,%eax
  801b63:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b66:	eb 26                	jmp    801b8e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6c:	0f b6 00             	movzbl (%rax),%eax
  801b6f:	3c 40                	cmp    $0x40,%al
  801b71:	7e 47                	jle    801bba <strtol+0x16a>
  801b73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	3c 5a                	cmp    $0x5a,%al
  801b7c:	7f 3c                	jg     801bba <strtol+0x16a>
			dig = *s - 'A' + 10;
  801b7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	0f be c0             	movsbl %al,%eax
  801b88:	83 e8 37             	sub    $0x37,%eax
  801b8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b91:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b94:	7d 23                	jge    801bb9 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801b96:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b9b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b9e:	48 98                	cltq   
  801ba0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ba5:	48 89 c2             	mov    %rax,%rdx
  801ba8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bab:	48 98                	cltq   
  801bad:	48 01 d0             	add    %rdx,%rax
  801bb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bb4:	e9 5f ff ff ff       	jmpq   801b18 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bb9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801bba:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bbf:	74 0b                	je     801bcc <strtol+0x17c>
		*endptr = (char *) s;
  801bc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bc5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bc9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd0:	74 09                	je     801bdb <strtol+0x18b>
  801bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd6:	48 f7 d8             	neg    %rax
  801bd9:	eb 04                	jmp    801bdf <strtol+0x18f>
  801bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bdf:	c9                   	leaveq 
  801be0:	c3                   	retq   

0000000000801be1 <strstr>:

char * strstr(const char *in, const char *str)
{
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	48 83 ec 30          	sub    $0x30,%rsp
  801be9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801bf1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bf9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bfd:	0f b6 00             	movzbl (%rax),%eax
  801c00:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c03:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c07:	75 06                	jne    801c0f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0d:	eb 6b                	jmp    801c7a <strstr+0x99>

	len = strlen(str);
  801c0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c13:	48 89 c7             	mov    %rax,%rdi
  801c16:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  801c1d:	00 00 00 
  801c20:	ff d0                	callq  *%rax
  801c22:	48 98                	cltq   
  801c24:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c34:	0f b6 00             	movzbl (%rax),%eax
  801c37:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c3a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c3e:	75 07                	jne    801c47 <strstr+0x66>
				return (char *) 0;
  801c40:	b8 00 00 00 00       	mov    $0x0,%eax
  801c45:	eb 33                	jmp    801c7a <strstr+0x99>
		} while (sc != c);
  801c47:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c4b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c4e:	75 d8                	jne    801c28 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c54:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5c:	48 89 ce             	mov    %rcx,%rsi
  801c5f:	48 89 c7             	mov    %rax,%rdi
  801c62:	48 b8 d1 16 80 00 00 	movabs $0x8016d1,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	75 b6                	jne    801c28 <strstr+0x47>

	return (char *) (in - 1);
  801c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c76:	48 83 e8 01          	sub    $0x1,%rax
}
  801c7a:	c9                   	leaveq 
  801c7b:	c3                   	retq   

0000000000801c7c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c7c:	55                   	push   %rbp
  801c7d:	48 89 e5             	mov    %rsp,%rbp
  801c80:	53                   	push   %rbx
  801c81:	48 83 ec 48          	sub    $0x48,%rsp
  801c85:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c88:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c8b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c8f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c93:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c97:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c9b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c9e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ca2:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ca6:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801caa:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801cae:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cb2:	4c 89 c3             	mov    %r8,%rbx
  801cb5:	cd 30                	int    $0x30
  801cb7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801cbb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cbf:	74 3e                	je     801cff <syscall+0x83>
  801cc1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cc6:	7e 37                	jle    801cff <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ccc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ccf:	49 89 d0             	mov    %rdx,%r8
  801cd2:	89 c1                	mov    %eax,%ecx
  801cd4:	48 ba 88 56 80 00 00 	movabs $0x805688,%rdx
  801cdb:	00 00 00 
  801cde:	be 24 00 00 00       	mov    $0x24,%esi
  801ce3:	48 bf a5 56 80 00 00 	movabs $0x8056a5,%rdi
  801cea:	00 00 00 
  801ced:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf2:	49 b9 52 07 80 00 00 	movabs $0x800752,%r9
  801cf9:	00 00 00 
  801cfc:	41 ff d1             	callq  *%r9

	return ret;
  801cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d03:	48 83 c4 48          	add    $0x48,%rsp
  801d07:	5b                   	pop    %rbx
  801d08:	5d                   	pop    %rbp
  801d09:	c3                   	retq   

0000000000801d0a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d0a:	55                   	push   %rbp
  801d0b:	48 89 e5             	mov    %rsp,%rbp
  801d0e:	48 83 ec 10          	sub    $0x10,%rsp
  801d12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d22:	48 83 ec 08          	sub    $0x8,%rsp
  801d26:	6a 00                	pushq  $0x0
  801d28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d34:	48 89 d1             	mov    %rdx,%rcx
  801d37:	48 89 c2             	mov    %rax,%rdx
  801d3a:	be 00 00 00 00       	mov    $0x0,%esi
  801d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d44:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
  801d50:	48 83 c4 10          	add    $0x10,%rsp
}
  801d54:	90                   	nop
  801d55:	c9                   	leaveq 
  801d56:	c3                   	retq   

0000000000801d57 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d57:	55                   	push   %rbp
  801d58:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d5b:	48 83 ec 08          	sub    $0x8,%rsp
  801d5f:	6a 00                	pushq  $0x0
  801d61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d72:	ba 00 00 00 00       	mov    $0x0,%edx
  801d77:	be 00 00 00 00       	mov    $0x0,%esi
  801d7c:	bf 01 00 00 00       	mov    $0x1,%edi
  801d81:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax
  801d8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801d91:	c9                   	leaveq 
  801d92:	c3                   	retq   

0000000000801d93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	48 83 ec 10          	sub    $0x10,%rsp
  801d9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da1:	48 98                	cltq   
  801da3:	48 83 ec 08          	sub    $0x8,%rsp
  801da7:	6a 00                	pushq  $0x0
  801da9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dba:	48 89 c2             	mov    %rax,%rdx
  801dbd:	be 01 00 00 00       	mov    $0x1,%esi
  801dc2:	bf 03 00 00 00       	mov    $0x3,%edi
  801dc7:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801dce:	00 00 00 
  801dd1:	ff d0                	callq  *%rax
  801dd3:	48 83 c4 10          	add    $0x10,%rsp
}
  801dd7:	c9                   	leaveq 
  801dd8:	c3                   	retq   

0000000000801dd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801dd9:	55                   	push   %rbp
  801dda:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ddd:	48 83 ec 08          	sub    $0x8,%rsp
  801de1:	6a 00                	pushq  $0x0
  801de3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801def:	b9 00 00 00 00       	mov    $0x0,%ecx
  801df4:	ba 00 00 00 00       	mov    $0x0,%edx
  801df9:	be 00 00 00 00       	mov    $0x0,%esi
  801dfe:	bf 02 00 00 00       	mov    $0x2,%edi
  801e03:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
  801e0f:	48 83 c4 10          	add    $0x10,%rsp
}
  801e13:	c9                   	leaveq 
  801e14:	c3                   	retq   

0000000000801e15 <sys_yield>:


void
sys_yield(void)
{
  801e15:	55                   	push   %rbp
  801e16:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e19:	48 83 ec 08          	sub    $0x8,%rsp
  801e1d:	6a 00                	pushq  $0x0
  801e1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
  801e35:	be 00 00 00 00       	mov    $0x0,%esi
  801e3a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e3f:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801e46:	00 00 00 
  801e49:	ff d0                	callq  *%rax
  801e4b:	48 83 c4 10          	add    $0x10,%rsp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leaveq 
  801e51:	c3                   	retq   

0000000000801e52 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e52:	55                   	push   %rbp
  801e53:	48 89 e5             	mov    %rsp,%rbp
  801e56:	48 83 ec 10          	sub    $0x10,%rsp
  801e5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e61:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e64:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e67:	48 63 c8             	movslq %eax,%rcx
  801e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e71:	48 98                	cltq   
  801e73:	48 83 ec 08          	sub    $0x8,%rsp
  801e77:	6a 00                	pushq  $0x0
  801e79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7f:	49 89 c8             	mov    %rcx,%r8
  801e82:	48 89 d1             	mov    %rdx,%rcx
  801e85:	48 89 c2             	mov    %rax,%rdx
  801e88:	be 01 00 00 00       	mov    $0x1,%esi
  801e8d:	bf 04 00 00 00       	mov    $0x4,%edi
  801e92:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801e99:	00 00 00 
  801e9c:	ff d0                	callq  *%rax
  801e9e:	48 83 c4 10          	add    $0x10,%rsp
}
  801ea2:	c9                   	leaveq 
  801ea3:	c3                   	retq   

0000000000801ea4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ea4:	55                   	push   %rbp
  801ea5:	48 89 e5             	mov    %rsp,%rbp
  801ea8:	48 83 ec 20          	sub    $0x20,%rsp
  801eac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eb3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801eb6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801eba:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ebe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ec1:	48 63 c8             	movslq %eax,%rcx
  801ec4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ec8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ecb:	48 63 f0             	movslq %eax,%rsi
  801ece:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed5:	48 98                	cltq   
  801ed7:	48 83 ec 08          	sub    $0x8,%rsp
  801edb:	51                   	push   %rcx
  801edc:	49 89 f9             	mov    %rdi,%r9
  801edf:	49 89 f0             	mov    %rsi,%r8
  801ee2:	48 89 d1             	mov    %rdx,%rcx
  801ee5:	48 89 c2             	mov    %rax,%rdx
  801ee8:	be 01 00 00 00       	mov    $0x1,%esi
  801eed:	bf 05 00 00 00       	mov    $0x5,%edi
  801ef2:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
  801efe:	48 83 c4 10          	add    $0x10,%rsp
}
  801f02:	c9                   	leaveq 
  801f03:	c3                   	retq   

0000000000801f04 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f04:	55                   	push   %rbp
  801f05:	48 89 e5             	mov    %rsp,%rbp
  801f08:	48 83 ec 10          	sub    $0x10,%rsp
  801f0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1a:	48 98                	cltq   
  801f1c:	48 83 ec 08          	sub    $0x8,%rsp
  801f20:	6a 00                	pushq  $0x0
  801f22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f2e:	48 89 d1             	mov    %rdx,%rcx
  801f31:	48 89 c2             	mov    %rax,%rdx
  801f34:	be 01 00 00 00       	mov    $0x1,%esi
  801f39:	bf 06 00 00 00       	mov    $0x6,%edi
  801f3e:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801f45:	00 00 00 
  801f48:	ff d0                	callq  *%rax
  801f4a:	48 83 c4 10          	add    $0x10,%rsp
}
  801f4e:	c9                   	leaveq 
  801f4f:	c3                   	retq   

0000000000801f50 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f50:	55                   	push   %rbp
  801f51:	48 89 e5             	mov    %rsp,%rbp
  801f54:	48 83 ec 10          	sub    $0x10,%rsp
  801f58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f61:	48 63 d0             	movslq %eax,%rdx
  801f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f67:	48 98                	cltq   
  801f69:	48 83 ec 08          	sub    $0x8,%rsp
  801f6d:	6a 00                	pushq  $0x0
  801f6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7b:	48 89 d1             	mov    %rdx,%rcx
  801f7e:	48 89 c2             	mov    %rax,%rdx
  801f81:	be 01 00 00 00       	mov    $0x1,%esi
  801f86:	bf 08 00 00 00       	mov    $0x8,%edi
  801f8b:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	callq  *%rax
  801f97:	48 83 c4 10          	add    $0x10,%rsp
}
  801f9b:	c9                   	leaveq 
  801f9c:	c3                   	retq   

0000000000801f9d <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f9d:	55                   	push   %rbp
  801f9e:	48 89 e5             	mov    %rsp,%rbp
  801fa1:	48 83 ec 10          	sub    $0x10,%rsp
  801fa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb3:	48 98                	cltq   
  801fb5:	48 83 ec 08          	sub    $0x8,%rsp
  801fb9:	6a 00                	pushq  $0x0
  801fbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc7:	48 89 d1             	mov    %rdx,%rcx
  801fca:	48 89 c2             	mov    %rax,%rdx
  801fcd:	be 01 00 00 00       	mov    $0x1,%esi
  801fd2:	bf 09 00 00 00       	mov    $0x9,%edi
  801fd7:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax
  801fe3:	48 83 c4 10          	add    $0x10,%rsp
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
  801fed:	48 83 ec 10          	sub    $0x10,%rsp
  801ff1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ff4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ff8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ffc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fff:	48 98                	cltq   
  802001:	48 83 ec 08          	sub    $0x8,%rsp
  802005:	6a 00                	pushq  $0x0
  802007:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802013:	48 89 d1             	mov    %rdx,%rcx
  802016:	48 89 c2             	mov    %rax,%rdx
  802019:	be 01 00 00 00       	mov    $0x1,%esi
  80201e:	bf 0a 00 00 00       	mov    $0xa,%edi
  802023:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
  80202f:	48 83 c4 10          	add    $0x10,%rsp
}
  802033:	c9                   	leaveq 
  802034:	c3                   	retq   

0000000000802035 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802035:	55                   	push   %rbp
  802036:	48 89 e5             	mov    %rsp,%rbp
  802039:	48 83 ec 20          	sub    $0x20,%rsp
  80203d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802040:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802044:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802048:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80204b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80204e:	48 63 f0             	movslq %eax,%rsi
  802051:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802058:	48 98                	cltq   
  80205a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205e:	48 83 ec 08          	sub    $0x8,%rsp
  802062:	6a 00                	pushq  $0x0
  802064:	49 89 f1             	mov    %rsi,%r9
  802067:	49 89 c8             	mov    %rcx,%r8
  80206a:	48 89 d1             	mov    %rdx,%rcx
  80206d:	48 89 c2             	mov    %rax,%rdx
  802070:	be 00 00 00 00       	mov    $0x0,%esi
  802075:	bf 0c 00 00 00       	mov    $0xc,%edi
  80207a:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  802081:	00 00 00 
  802084:	ff d0                	callq  *%rax
  802086:	48 83 c4 10          	add    $0x10,%rsp
}
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 10          	sub    $0x10,%rsp
  802094:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802098:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80209c:	48 83 ec 08          	sub    $0x8,%rsp
  8020a0:	6a 00                	pushq  $0x0
  8020a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b3:	48 89 c2             	mov    %rax,%rdx
  8020b6:	be 01 00 00 00       	mov    $0x1,%esi
  8020bb:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020c0:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  8020c7:	00 00 00 
  8020ca:	ff d0                	callq  *%rax
  8020cc:	48 83 c4 10          	add    $0x10,%rsp
}
  8020d0:	c9                   	leaveq 
  8020d1:	c3                   	retq   

00000000008020d2 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8020d2:	55                   	push   %rbp
  8020d3:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020d6:	48 83 ec 08          	sub    $0x8,%rsp
  8020da:	6a 00                	pushq  $0x0
  8020dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f2:	be 00 00 00 00       	mov    $0x0,%esi
  8020f7:	bf 0e 00 00 00       	mov    $0xe,%edi
  8020fc:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  802103:	00 00 00 
  802106:	ff d0                	callq  *%rax
  802108:	48 83 c4 10          	add    $0x10,%rsp
}
  80210c:	c9                   	leaveq 
  80210d:	c3                   	retq   

000000000080210e <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  80210e:	55                   	push   %rbp
  80210f:	48 89 e5             	mov    %rsp,%rbp
  802112:	48 83 ec 10          	sub    $0x10,%rsp
  802116:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80211a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  80211d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802124:	48 83 ec 08          	sub    $0x8,%rsp
  802128:	6a 00                	pushq  $0x0
  80212a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802130:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802136:	48 89 d1             	mov    %rdx,%rcx
  802139:	48 89 c2             	mov    %rax,%rdx
  80213c:	be 00 00 00 00       	mov    $0x0,%esi
  802141:	bf 0f 00 00 00       	mov    $0xf,%edi
  802146:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  80214d:	00 00 00 
  802150:	ff d0                	callq  *%rax
  802152:	48 83 c4 10          	add    $0x10,%rsp
}
  802156:	c9                   	leaveq 
  802157:	c3                   	retq   

0000000000802158 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802158:	55                   	push   %rbp
  802159:	48 89 e5             	mov    %rsp,%rbp
  80215c:	48 83 ec 10          	sub    $0x10,%rsp
  802160:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802164:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802167:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80216a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216e:	48 83 ec 08          	sub    $0x8,%rsp
  802172:	6a 00                	pushq  $0x0
  802174:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80217a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802180:	48 89 d1             	mov    %rdx,%rcx
  802183:	48 89 c2             	mov    %rax,%rdx
  802186:	be 00 00 00 00       	mov    $0x0,%esi
  80218b:	bf 10 00 00 00       	mov    $0x10,%edi
  802190:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  802197:	00 00 00 
  80219a:	ff d0                	callq  *%rax
  80219c:	48 83 c4 10          	add    $0x10,%rsp
}
  8021a0:	c9                   	leaveq 
  8021a1:	c3                   	retq   

00000000008021a2 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8021a2:	55                   	push   %rbp
  8021a3:	48 89 e5             	mov    %rsp,%rbp
  8021a6:	48 83 ec 20          	sub    $0x20,%rsp
  8021aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021b1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8021b4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8021b8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8021bc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8021bf:	48 63 c8             	movslq %eax,%rcx
  8021c2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8021c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021c9:	48 63 f0             	movslq %eax,%rsi
  8021cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d3:	48 98                	cltq   
  8021d5:	48 83 ec 08          	sub    $0x8,%rsp
  8021d9:	51                   	push   %rcx
  8021da:	49 89 f9             	mov    %rdi,%r9
  8021dd:	49 89 f0             	mov    %rsi,%r8
  8021e0:	48 89 d1             	mov    %rdx,%rcx
  8021e3:	48 89 c2             	mov    %rax,%rdx
  8021e6:	be 00 00 00 00       	mov    $0x0,%esi
  8021eb:	bf 11 00 00 00       	mov    $0x11,%edi
  8021f0:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
  8021fc:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802200:	c9                   	leaveq 
  802201:	c3                   	retq   

0000000000802202 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802202:	55                   	push   %rbp
  802203:	48 89 e5             	mov    %rsp,%rbp
  802206:	48 83 ec 10          	sub    $0x10,%rsp
  80220a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80220e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221a:	48 83 ec 08          	sub    $0x8,%rsp
  80221e:	6a 00                	pushq  $0x0
  802220:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802226:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80222c:	48 89 d1             	mov    %rdx,%rcx
  80222f:	48 89 c2             	mov    %rax,%rdx
  802232:	be 00 00 00 00       	mov    $0x0,%esi
  802237:	bf 12 00 00 00       	mov    $0x12,%edi
  80223c:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
  802248:	48 83 c4 10          	add    $0x10,%rsp
}
  80224c:	c9                   	leaveq 
  80224d:	c3                   	retq   

000000000080224e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80224e:	55                   	push   %rbp
  80224f:	48 89 e5             	mov    %rsp,%rbp
  802252:	48 83 ec 08          	sub    $0x8,%rsp
  802256:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80225a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80225e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802265:	ff ff ff 
  802268:	48 01 d0             	add    %rdx,%rax
  80226b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80226f:	c9                   	leaveq 
  802270:	c3                   	retq   

0000000000802271 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802271:	55                   	push   %rbp
  802272:	48 89 e5             	mov    %rsp,%rbp
  802275:	48 83 ec 08          	sub    $0x8,%rsp
  802279:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80227d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802281:	48 89 c7             	mov    %rax,%rdi
  802284:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax
  802290:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802296:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80229a:	c9                   	leaveq 
  80229b:	c3                   	retq   

000000000080229c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80229c:	55                   	push   %rbp
  80229d:	48 89 e5             	mov    %rsp,%rbp
  8022a0:	48 83 ec 18          	sub    $0x18,%rsp
  8022a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022af:	eb 6b                	jmp    80231c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b4:	48 98                	cltq   
  8022b6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022bc:	48 c1 e0 0c          	shl    $0xc,%rax
  8022c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c8:	48 c1 e8 15          	shr    $0x15,%rax
  8022cc:	48 89 c2             	mov    %rax,%rdx
  8022cf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022d6:	01 00 00 
  8022d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022dd:	83 e0 01             	and    $0x1,%eax
  8022e0:	48 85 c0             	test   %rax,%rax
  8022e3:	74 21                	je     802306 <fd_alloc+0x6a>
  8022e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e9:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ed:	48 89 c2             	mov    %rax,%rdx
  8022f0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f7:	01 00 00 
  8022fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fe:	83 e0 01             	and    $0x1,%eax
  802301:	48 85 c0             	test   %rax,%rax
  802304:	75 12                	jne    802318 <fd_alloc+0x7c>
			*fd_store = fd;
  802306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	eb 1a                	jmp    802332 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802318:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80231c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802320:	7e 8f                	jle    8022b1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802326:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80232d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802332:	c9                   	leaveq 
  802333:	c3                   	retq   

0000000000802334 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802334:	55                   	push   %rbp
  802335:	48 89 e5             	mov    %rsp,%rbp
  802338:	48 83 ec 20          	sub    $0x20,%rsp
  80233c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80233f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802343:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802347:	78 06                	js     80234f <fd_lookup+0x1b>
  802349:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80234d:	7e 07                	jle    802356 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80234f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802354:	eb 6c                	jmp    8023c2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802356:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802359:	48 98                	cltq   
  80235b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802361:	48 c1 e0 0c          	shl    $0xc,%rax
  802365:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80236d:	48 c1 e8 15          	shr    $0x15,%rax
  802371:	48 89 c2             	mov    %rax,%rdx
  802374:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80237b:	01 00 00 
  80237e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802382:	83 e0 01             	and    $0x1,%eax
  802385:	48 85 c0             	test   %rax,%rax
  802388:	74 21                	je     8023ab <fd_lookup+0x77>
  80238a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80238e:	48 c1 e8 0c          	shr    $0xc,%rax
  802392:	48 89 c2             	mov    %rax,%rdx
  802395:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80239c:	01 00 00 
  80239f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a3:	83 e0 01             	and    $0x1,%eax
  8023a6:	48 85 c0             	test   %rax,%rax
  8023a9:	75 07                	jne    8023b2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b0:	eb 10                	jmp    8023c2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023ba:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c2:	c9                   	leaveq 
  8023c3:	c3                   	retq   

00000000008023c4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023c4:	55                   	push   %rbp
  8023c5:	48 89 e5             	mov    %rsp,%rbp
  8023c8:	48 83 ec 30          	sub    $0x30,%rsp
  8023cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023d0:	89 f0                	mov    %esi,%eax
  8023d2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d9:	48 89 c7             	mov    %rax,%rdi
  8023dc:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  8023e3:	00 00 00 
  8023e6:	ff d0                	callq  *%rax
  8023e8:	89 c2                	mov    %eax,%edx
  8023ea:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8023ee:	48 89 c6             	mov    %rax,%rsi
  8023f1:	89 d7                	mov    %edx,%edi
  8023f3:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax
  8023ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802406:	78 0a                	js     802412 <fd_close+0x4e>
	    || fd != fd2)
  802408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802410:	74 12                	je     802424 <fd_close+0x60>
		return (must_exist ? r : 0);
  802412:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802416:	74 05                	je     80241d <fd_close+0x59>
  802418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241b:	eb 70                	jmp    80248d <fd_close+0xc9>
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	eb 69                	jmp    80248d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802428:	8b 00                	mov    (%rax),%eax
  80242a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242e:	48 89 d6             	mov    %rdx,%rsi
  802431:	89 c7                	mov    %eax,%edi
  802433:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  80243a:	00 00 00 
  80243d:	ff d0                	callq  *%rax
  80243f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802446:	78 2a                	js     802472 <fd_close+0xae>
		if (dev->dev_close)
  802448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	74 16                	je     80246b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802459:	48 8b 40 20          	mov    0x20(%rax),%rax
  80245d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802461:	48 89 d7             	mov    %rdx,%rdi
  802464:	ff d0                	callq  *%rax
  802466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802469:	eb 07                	jmp    802472 <fd_close+0xae>
		else
			r = 0;
  80246b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802476:	48 89 c6             	mov    %rax,%rsi
  802479:	bf 00 00 00 00       	mov    $0x0,%edi
  80247e:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
	return r;
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80248d:	c9                   	leaveq 
  80248e:	c3                   	retq   

000000000080248f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80248f:	55                   	push   %rbp
  802490:	48 89 e5             	mov    %rsp,%rbp
  802493:	48 83 ec 20          	sub    $0x20,%rsp
  802497:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80249a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80249e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a5:	eb 41                	jmp    8024e8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024a7:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8024ae:	00 00 00 
  8024b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b4:	48 63 d2             	movslq %edx,%rdx
  8024b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bb:	8b 00                	mov    (%rax),%eax
  8024bd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024c0:	75 22                	jne    8024e4 <dev_lookup+0x55>
			*dev = devtab[i];
  8024c2:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8024c9:	00 00 00 
  8024cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024cf:	48 63 d2             	movslq %edx,%rdx
  8024d2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024da:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	eb 60                	jmp    802544 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024e8:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  8024ef:	00 00 00 
  8024f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024f5:	48 63 d2             	movslq %edx,%rdx
  8024f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fc:	48 85 c0             	test   %rax,%rax
  8024ff:	75 a6                	jne    8024a7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802501:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802508:	00 00 00 
  80250b:	48 8b 00             	mov    (%rax),%rax
  80250e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802514:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802517:	89 c6                	mov    %eax,%esi
  802519:	48 bf b8 56 80 00 00 	movabs $0x8056b8,%rdi
  802520:	00 00 00 
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80252f:	00 00 00 
  802532:	ff d1                	callq  *%rcx
	*dev = 0;
  802534:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802538:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80253f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802544:	c9                   	leaveq 
  802545:	c3                   	retq   

0000000000802546 <close>:

int
close(int fdnum)
{
  802546:	55                   	push   %rbp
  802547:	48 89 e5             	mov    %rsp,%rbp
  80254a:	48 83 ec 20          	sub    $0x20,%rsp
  80254e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802551:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802558:	48 89 d6             	mov    %rdx,%rsi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802570:	79 05                	jns    802577 <close+0x31>
		return r;
  802572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802575:	eb 18                	jmp    80258f <close+0x49>
	else
		return fd_close(fd, 1);
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	be 01 00 00 00       	mov    $0x1,%esi
  802580:	48 89 c7             	mov    %rax,%rdi
  802583:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  80258a:	00 00 00 
  80258d:	ff d0                	callq  *%rax
}
  80258f:	c9                   	leaveq 
  802590:	c3                   	retq   

0000000000802591 <close_all>:

void
close_all(void)
{
  802591:	55                   	push   %rbp
  802592:	48 89 e5             	mov    %rsp,%rbp
  802595:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802599:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a0:	eb 15                	jmp    8025b7 <close_all+0x26>
		close(i);
  8025a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025bb:	7e e5                	jle    8025a2 <close_all+0x11>
		close(i);
}
  8025bd:	90                   	nop
  8025be:	c9                   	leaveq 
  8025bf:	c3                   	retq   

00000000008025c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025c0:	55                   	push   %rbp
  8025c1:	48 89 e5             	mov    %rsp,%rbp
  8025c4:	48 83 ec 40          	sub    $0x40,%rsp
  8025c8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025cb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025ce:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025d2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025d5:	48 89 d6             	mov    %rdx,%rsi
  8025d8:	89 c7                	mov    %eax,%edi
  8025da:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	callq  *%rax
  8025e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ed:	79 08                	jns    8025f7 <dup+0x37>
		return r;
  8025ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f2:	e9 70 01 00 00       	jmpq   802767 <dup+0x1a7>
	close(newfdnum);
  8025f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802608:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80260b:	48 98                	cltq   
  80260d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802613:	48 c1 e0 0c          	shl    $0xc,%rax
  802617:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80261b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261f:	48 89 c7             	mov    %rax,%rdi
  802622:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
  80262e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802636:	48 89 c7             	mov    %rax,%rdi
  802639:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  802640:	00 00 00 
  802643:	ff d0                	callq  *%rax
  802645:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264d:	48 c1 e8 15          	shr    $0x15,%rax
  802651:	48 89 c2             	mov    %rax,%rdx
  802654:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	48 85 c0             	test   %rax,%rax
  802668:	74 71                	je     8026db <dup+0x11b>
  80266a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266e:	48 c1 e8 0c          	shr    $0xc,%rax
  802672:	48 89 c2             	mov    %rax,%rdx
  802675:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267c:	01 00 00 
  80267f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802683:	83 e0 01             	and    $0x1,%eax
  802686:	48 85 c0             	test   %rax,%rax
  802689:	74 50                	je     8026db <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80268b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268f:	48 c1 e8 0c          	shr    $0xc,%rax
  802693:	48 89 c2             	mov    %rax,%rdx
  802696:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80269d:	01 00 00 
  8026a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8026a9:	89 c1                	mov    %eax,%ecx
  8026ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b3:	41 89 c8             	mov    %ecx,%r8d
  8026b6:	48 89 d1             	mov    %rdx,%rcx
  8026b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026be:	48 89 c6             	mov    %rax,%rsi
  8026c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c6:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d9:	78 55                	js     802730 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026df:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e3:	48 89 c2             	mov    %rax,%rdx
  8026e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ed:	01 00 00 
  8026f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8026f9:	89 c1                	mov    %eax,%ecx
  8026fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802703:	41 89 c8             	mov    %ecx,%r8d
  802706:	48 89 d1             	mov    %rdx,%rcx
  802709:	ba 00 00 00 00       	mov    $0x0,%edx
  80270e:	48 89 c6             	mov    %rax,%rsi
  802711:	bf 00 00 00 00       	mov    $0x0,%edi
  802716:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  80271d:	00 00 00 
  802720:	ff d0                	callq  *%rax
  802722:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802729:	78 08                	js     802733 <dup+0x173>
		goto err;

	return newfdnum;
  80272b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80272e:	eb 37                	jmp    802767 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802730:	90                   	nop
  802731:	eb 01                	jmp    802734 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802733:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802738:	48 89 c6             	mov    %rax,%rsi
  80273b:	bf 00 00 00 00       	mov    $0x0,%edi
  802740:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80274c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802750:	48 89 c6             	mov    %rax,%rsi
  802753:	bf 00 00 00 00       	mov    $0x0,%edi
  802758:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
	return r;
  802764:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 40          	sub    $0x40,%rsp
  802771:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802774:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802778:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80277c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802780:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802783:	48 89 d6             	mov    %rdx,%rsi
  802786:	89 c7                	mov    %eax,%edi
  802788:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  80278f:	00 00 00 
  802792:	ff d0                	callq  *%rax
  802794:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802797:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279b:	78 24                	js     8027c1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80279d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a1:	8b 00                	mov    (%rax),%eax
  8027a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a7:	48 89 d6             	mov    %rdx,%rsi
  8027aa:	89 c7                	mov    %eax,%edi
  8027ac:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
  8027b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bf:	79 05                	jns    8027c6 <read+0x5d>
		return r;
  8027c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c4:	eb 76                	jmp    80283c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ca:	8b 40 08             	mov    0x8(%rax),%eax
  8027cd:	83 e0 03             	and    $0x3,%eax
  8027d0:	83 f8 01             	cmp    $0x1,%eax
  8027d3:	75 3a                	jne    80280f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027d5:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8027dc:	00 00 00 
  8027df:	48 8b 00             	mov    (%rax),%rax
  8027e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027eb:	89 c6                	mov    %eax,%esi
  8027ed:	48 bf d7 56 80 00 00 	movabs $0x8056d7,%rdi
  8027f4:	00 00 00 
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  802803:	00 00 00 
  802806:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80280d:	eb 2d                	jmp    80283c <read+0xd3>
	}
	if (!dev->dev_read)
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	48 8b 40 10          	mov    0x10(%rax),%rax
  802817:	48 85 c0             	test   %rax,%rax
  80281a:	75 07                	jne    802823 <read+0xba>
		return -E_NOT_SUPP;
  80281c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802821:	eb 19                	jmp    80283c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802827:	48 8b 40 10          	mov    0x10(%rax),%rax
  80282b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80282f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802833:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802837:	48 89 cf             	mov    %rcx,%rdi
  80283a:	ff d0                	callq  *%rax
}
  80283c:	c9                   	leaveq 
  80283d:	c3                   	retq   

000000000080283e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80283e:	55                   	push   %rbp
  80283f:	48 89 e5             	mov    %rsp,%rbp
  802842:	48 83 ec 30          	sub    $0x30,%rsp
  802846:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802849:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80284d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802851:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802858:	eb 47                	jmp    8028a1 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80285a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285d:	48 98                	cltq   
  80285f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802863:	48 29 c2             	sub    %rax,%rdx
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	48 63 c8             	movslq %eax,%rcx
  80286c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802870:	48 01 c1             	add    %rax,%rcx
  802873:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802876:	48 89 ce             	mov    %rcx,%rsi
  802879:	89 c7                	mov    %eax,%edi
  80287b:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80288a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80288e:	79 05                	jns    802895 <readn+0x57>
			return m;
  802890:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802893:	eb 1d                	jmp    8028b2 <readn+0x74>
		if (m == 0)
  802895:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802899:	74 13                	je     8028ae <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80289b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80289e:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a4:	48 98                	cltq   
  8028a6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028aa:	72 ae                	jb     80285a <readn+0x1c>
  8028ac:	eb 01                	jmp    8028af <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8028ae:	90                   	nop
	}
	return tot;
  8028af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b2:	c9                   	leaveq 
  8028b3:	c3                   	retq   

00000000008028b4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028b4:	55                   	push   %rbp
  8028b5:	48 89 e5             	mov    %rsp,%rbp
  8028b8:	48 83 ec 40          	sub    $0x40,%rsp
  8028bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ce:	48 89 d6             	mov    %rdx,%rsi
  8028d1:	89 c7                	mov    %eax,%edi
  8028d3:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
  8028df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e6:	78 24                	js     80290c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ec:	8b 00                	mov    (%rax),%eax
  8028ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f2:	48 89 d6             	mov    %rdx,%rsi
  8028f5:	89 c7                	mov    %eax,%edi
  8028f7:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  8028fe:	00 00 00 
  802901:	ff d0                	callq  *%rax
  802903:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290a:	79 05                	jns    802911 <write+0x5d>
		return r;
  80290c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290f:	eb 75                	jmp    802986 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802915:	8b 40 08             	mov    0x8(%rax),%eax
  802918:	83 e0 03             	and    $0x3,%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	75 3a                	jne    802959 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80291f:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802926:	00 00 00 
  802929:	48 8b 00             	mov    (%rax),%rax
  80292c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802932:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802935:	89 c6                	mov    %eax,%esi
  802937:	48 bf f3 56 80 00 00 	movabs $0x8056f3,%rdi
  80293e:	00 00 00 
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80294d:	00 00 00 
  802950:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802952:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802957:	eb 2d                	jmp    802986 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802961:	48 85 c0             	test   %rax,%rax
  802964:	75 07                	jne    80296d <write+0xb9>
		return -E_NOT_SUPP;
  802966:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296b:	eb 19                	jmp    802986 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80296d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802971:	48 8b 40 18          	mov    0x18(%rax),%rax
  802975:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802979:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80297d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802981:	48 89 cf             	mov    %rcx,%rdi
  802984:	ff d0                	callq  *%rax
}
  802986:	c9                   	leaveq 
  802987:	c3                   	retq   

0000000000802988 <seek>:

int
seek(int fdnum, off_t offset)
{
  802988:	55                   	push   %rbp
  802989:	48 89 e5             	mov    %rsp,%rbp
  80298c:	48 83 ec 18          	sub    $0x18,%rsp
  802990:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802993:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802996:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80299a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80299d:	48 89 d6             	mov    %rdx,%rsi
  8029a0:	89 c7                	mov    %eax,%edi
  8029a2:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
  8029ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b5:	79 05                	jns    8029bc <seek+0x34>
		return r;
  8029b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ba:	eb 0f                	jmp    8029cb <seek+0x43>
	fd->fd_offset = offset;
  8029bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cb:	c9                   	leaveq 
  8029cc:	c3                   	retq   

00000000008029cd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029cd:	55                   	push   %rbp
  8029ce:	48 89 e5             	mov    %rsp,%rbp
  8029d1:	48 83 ec 30          	sub    $0x30,%rsp
  8029d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029d8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029db:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029e2:	48 89 d6             	mov    %rdx,%rsi
  8029e5:	89 c7                	mov    %eax,%edi
  8029e7:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fa:	78 24                	js     802a20 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a00:	8b 00                	mov    (%rax),%eax
  802a02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a06:	48 89 d6             	mov    %rdx,%rsi
  802a09:	89 c7                	mov    %eax,%edi
  802a0b:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802a12:	00 00 00 
  802a15:	ff d0                	callq  *%rax
  802a17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1e:	79 05                	jns    802a25 <ftruncate+0x58>
		return r;
  802a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a23:	eb 72                	jmp    802a97 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a29:	8b 40 08             	mov    0x8(%rax),%eax
  802a2c:	83 e0 03             	and    $0x3,%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	75 3a                	jne    802a6d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a33:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802a3a:	00 00 00 
  802a3d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a40:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a46:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a49:	89 c6                	mov    %eax,%esi
  802a4b:	48 bf 10 57 80 00 00 	movabs $0x805710,%rdi
  802a52:	00 00 00 
  802a55:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5a:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  802a61:	00 00 00 
  802a64:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a6b:	eb 2a                	jmp    802a97 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a71:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a75:	48 85 c0             	test   %rax,%rax
  802a78:	75 07                	jne    802a81 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a7a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a7f:	eb 16                	jmp    802a97 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a85:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a8d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a90:	89 ce                	mov    %ecx,%esi
  802a92:	48 89 d7             	mov    %rdx,%rdi
  802a95:	ff d0                	callq  *%rax
}
  802a97:	c9                   	leaveq 
  802a98:	c3                   	retq   

0000000000802a99 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a99:	55                   	push   %rbp
  802a9a:	48 89 e5             	mov    %rsp,%rbp
  802a9d:	48 83 ec 30          	sub    $0x30,%rsp
  802aa1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aa4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aaf:	48 89 d6             	mov    %rdx,%rsi
  802ab2:	89 c7                	mov    %eax,%edi
  802ab4:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
  802ac0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac7:	78 24                	js     802aed <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acd:	8b 00                	mov    (%rax),%eax
  802acf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad3:	48 89 d6             	mov    %rdx,%rsi
  802ad6:	89 c7                	mov    %eax,%edi
  802ad8:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax
  802ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aeb:	79 05                	jns    802af2 <fstat+0x59>
		return r;
  802aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af0:	eb 5e                	jmp    802b50 <fstat+0xb7>
	if (!dev->dev_stat)
  802af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af6:	48 8b 40 28          	mov    0x28(%rax),%rax
  802afa:	48 85 c0             	test   %rax,%rax
  802afd:	75 07                	jne    802b06 <fstat+0x6d>
		return -E_NOT_SUPP;
  802aff:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b04:	eb 4a                	jmp    802b50 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b11:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b18:	00 00 00 
	stat->st_isdir = 0;
  802b1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b1f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b26:	00 00 00 
	stat->st_dev = dev;
  802b29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b31:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b44:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b48:	48 89 ce             	mov    %rcx,%rsi
  802b4b:	48 89 d7             	mov    %rdx,%rdi
  802b4e:	ff d0                	callq  *%rax
}
  802b50:	c9                   	leaveq 
  802b51:	c3                   	retq   

0000000000802b52 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b52:	55                   	push   %rbp
  802b53:	48 89 e5             	mov    %rsp,%rbp
  802b56:	48 83 ec 20          	sub    $0x20,%rsp
  802b5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b66:	be 00 00 00 00       	mov    $0x0,%esi
  802b6b:	48 89 c7             	mov    %rax,%rdi
  802b6e:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  802b75:	00 00 00 
  802b78:	ff d0                	callq  *%rax
  802b7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b81:	79 05                	jns    802b88 <stat+0x36>
		return fd;
  802b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b86:	eb 2f                	jmp    802bb7 <stat+0x65>
	r = fstat(fd, stat);
  802b88:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8f:	48 89 d6             	mov    %rdx,%rsi
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	48 b8 99 2a 80 00 00 	movabs $0x802a99,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
  802ba0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba6:	89 c7                	mov    %eax,%edi
  802ba8:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802baf:	00 00 00 
  802bb2:	ff d0                	callq  *%rax
	return r;
  802bb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bb7:	c9                   	leaveq 
  802bb8:	c3                   	retq   

0000000000802bb9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bb9:	55                   	push   %rbp
  802bba:	48 89 e5             	mov    %rsp,%rbp
  802bbd:	48 83 ec 10          	sub    $0x10,%rsp
  802bc1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bc8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bcf:	00 00 00 
  802bd2:	8b 00                	mov    (%rax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	75 1f                	jne    802bf7 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bd8:	bf 01 00 00 00       	mov    $0x1,%edi
  802bdd:	48 b8 19 4f 80 00 00 	movabs $0x804f19,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
  802be9:	89 c2                	mov    %eax,%edx
  802beb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bf2:	00 00 00 
  802bf5:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bf7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bfe:	00 00 00 
  802c01:	8b 00                	mov    (%rax),%eax
  802c03:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c06:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c0b:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  802c12:	00 00 00 
  802c15:	89 c7                	mov    %eax,%edi
  802c17:	48 b8 0d 4d 80 00 00 	movabs $0x804d0d,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c27:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2c:	48 89 c6             	mov    %rax,%rsi
  802c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c34:	48 b8 4c 4c 80 00 00 	movabs $0x804c4c,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 20          	sub    $0x20,%rsp
  802c4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c4e:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c55:	48 89 c7             	mov    %rax,%rdi
  802c58:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
  802c64:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c69:	7e 0a                	jle    802c75 <open+0x33>
		return -E_BAD_PATH;
  802c6b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c70:	e9 a5 00 00 00       	jmpq   802d1a <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c75:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c79:	48 89 c7             	mov    %rax,%rdi
  802c7c:	48 b8 9c 22 80 00 00 	movabs $0x80229c,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
  802c88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8f:	79 08                	jns    802c99 <open+0x57>
		return r;
  802c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c94:	e9 81 00 00 00       	jmpq   802d1a <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802c99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9d:	48 89 c6             	mov    %rax,%rsi
  802ca0:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802ca7:	00 00 00 
  802caa:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  802cb1:	00 00 00 
  802cb4:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802cb6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cbd:	00 00 00 
  802cc0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cc3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccd:	48 89 c6             	mov    %rax,%rsi
  802cd0:	bf 01 00 00 00       	mov    $0x1,%edi
  802cd5:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
  802ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce8:	79 1d                	jns    802d07 <open+0xc5>
		fd_close(fd, 0);
  802cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cee:	be 00 00 00 00       	mov    $0x0,%esi
  802cf3:	48 89 c7             	mov    %rax,%rdi
  802cf6:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  802cfd:	00 00 00 
  802d00:	ff d0                	callq  *%rax
		return r;
  802d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d05:	eb 13                	jmp    802d1a <open+0xd8>
	}

	return fd2num(fd);
  802d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0b:	48 89 c7             	mov    %rax,%rdi
  802d0e:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax

}
  802d1a:	c9                   	leaveq 
  802d1b:	c3                   	retq   

0000000000802d1c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d1c:	55                   	push   %rbp
  802d1d:	48 89 e5             	mov    %rsp,%rbp
  802d20:	48 83 ec 10          	sub    $0x10,%rsp
  802d24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d2c:	8b 50 0c             	mov    0xc(%rax),%edx
  802d2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d36:	00 00 00 
  802d39:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d3b:	be 00 00 00 00       	mov    $0x0,%esi
  802d40:	bf 06 00 00 00       	mov    $0x6,%edi
  802d45:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
}
  802d51:	c9                   	leaveq 
  802d52:	c3                   	retq   

0000000000802d53 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d53:	55                   	push   %rbp
  802d54:	48 89 e5             	mov    %rsp,%rbp
  802d57:	48 83 ec 30          	sub    $0x30,%rsp
  802d5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d75:	00 00 00 
  802d78:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d7a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d81:	00 00 00 
  802d84:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d88:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d8c:	be 00 00 00 00       	mov    $0x0,%esi
  802d91:	bf 03 00 00 00       	mov    $0x3,%edi
  802d96:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802d9d:	00 00 00 
  802da0:	ff d0                	callq  *%rax
  802da2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da9:	79 08                	jns    802db3 <devfile_read+0x60>
		return r;
  802dab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dae:	e9 a4 00 00 00       	jmpq   802e57 <devfile_read+0x104>
	assert(r <= n);
  802db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db6:	48 98                	cltq   
  802db8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802dbc:	76 35                	jbe    802df3 <devfile_read+0xa0>
  802dbe:	48 b9 36 57 80 00 00 	movabs $0x805736,%rcx
  802dc5:	00 00 00 
  802dc8:	48 ba 3d 57 80 00 00 	movabs $0x80573d,%rdx
  802dcf:	00 00 00 
  802dd2:	be 86 00 00 00       	mov    $0x86,%esi
  802dd7:	48 bf 52 57 80 00 00 	movabs $0x805752,%rdi
  802dde:	00 00 00 
  802de1:	b8 00 00 00 00       	mov    $0x0,%eax
  802de6:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  802ded:	00 00 00 
  802df0:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802df3:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802dfa:	7e 35                	jle    802e31 <devfile_read+0xde>
  802dfc:	48 b9 5d 57 80 00 00 	movabs $0x80575d,%rcx
  802e03:	00 00 00 
  802e06:	48 ba 3d 57 80 00 00 	movabs $0x80573d,%rdx
  802e0d:	00 00 00 
  802e10:	be 87 00 00 00       	mov    $0x87,%esi
  802e15:	48 bf 52 57 80 00 00 	movabs $0x805752,%rdi
  802e1c:	00 00 00 
  802e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e24:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  802e2b:	00 00 00 
  802e2e:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e34:	48 63 d0             	movslq %eax,%rdx
  802e37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e3b:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802e42:	00 00 00 
  802e45:	48 89 c7             	mov    %rax,%rdi
  802e48:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
	return r;
  802e54:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802e57:	c9                   	leaveq 
  802e58:	c3                   	retq   

0000000000802e59 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e59:	55                   	push   %rbp
  802e5a:	48 89 e5             	mov    %rsp,%rbp
  802e5d:	48 83 ec 40          	sub    $0x40,%rsp
  802e61:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e69:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802e6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802e75:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802e7c:	00 
  802e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e81:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802e85:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802e8a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e92:	8b 50 0c             	mov    0xc(%rax),%edx
  802e95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e9c:	00 00 00 
  802e9f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ea1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802ea8:	00 00 00 
  802eab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802eaf:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802eb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802eb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ebb:	48 89 c6             	mov    %rax,%rsi
  802ebe:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  802ec5:	00 00 00 
  802ec8:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802ed4:	be 00 00 00 00       	mov    $0x0,%esi
  802ed9:	bf 04 00 00 00       	mov    $0x4,%edi
  802ede:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
  802eea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802eed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ef1:	79 05                	jns    802ef8 <devfile_write+0x9f>
		return r;
  802ef3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef6:	eb 43                	jmp    802f3b <devfile_write+0xe2>
	assert(r <= n);
  802ef8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802efb:	48 98                	cltq   
  802efd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f01:	76 35                	jbe    802f38 <devfile_write+0xdf>
  802f03:	48 b9 36 57 80 00 00 	movabs $0x805736,%rcx
  802f0a:	00 00 00 
  802f0d:	48 ba 3d 57 80 00 00 	movabs $0x80573d,%rdx
  802f14:	00 00 00 
  802f17:	be a2 00 00 00       	mov    $0xa2,%esi
  802f1c:	48 bf 52 57 80 00 00 	movabs $0x805752,%rdi
  802f23:	00 00 00 
  802f26:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2b:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  802f32:	00 00 00 
  802f35:	41 ff d0             	callq  *%r8
	return r;
  802f38:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802f3b:	c9                   	leaveq 
  802f3c:	c3                   	retq   

0000000000802f3d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f3d:	55                   	push   %rbp
  802f3e:	48 89 e5             	mov    %rsp,%rbp
  802f41:	48 83 ec 20          	sub    $0x20,%rsp
  802f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f51:	8b 50 0c             	mov    0xc(%rax),%edx
  802f54:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802f5b:	00 00 00 
  802f5e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f60:	be 00 00 00 00       	mov    $0x0,%esi
  802f65:	bf 05 00 00 00       	mov    $0x5,%edi
  802f6a:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802f71:	00 00 00 
  802f74:	ff d0                	callq  *%rax
  802f76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7d:	79 05                	jns    802f84 <devfile_stat+0x47>
		return r;
  802f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f82:	eb 56                	jmp    802fda <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f88:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802f8f:	00 00 00 
  802f92:	48 89 c7             	mov    %rax,%rdi
  802f95:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fa1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802fa8:	00 00 00 
  802fab:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fbb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802fc2:	00 00 00 
  802fc5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fcf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fda:	c9                   	leaveq 
  802fdb:	c3                   	retq   

0000000000802fdc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fdc:	55                   	push   %rbp
  802fdd:	48 89 e5             	mov    %rsp,%rbp
  802fe0:	48 83 ec 10          	sub    $0x10,%rsp
  802fe4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fe8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802feb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fef:	8b 50 0c             	mov    0xc(%rax),%edx
  802ff2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802ff9:	00 00 00 
  802ffc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ffe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803005:	00 00 00 
  803008:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80300e:	be 00 00 00 00       	mov    $0x0,%esi
  803013:	bf 02 00 00 00       	mov    $0x2,%edi
  803018:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
}
  803024:	c9                   	leaveq 
  803025:	c3                   	retq   

0000000000803026 <remove>:

// Delete a file
int
remove(const char *path)
{
  803026:	55                   	push   %rbp
  803027:	48 89 e5             	mov    %rsp,%rbp
  80302a:	48 83 ec 10          	sub    $0x10,%rsp
  80302e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803036:	48 89 c7             	mov    %rax,%rdi
  803039:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80304a:	7e 07                	jle    803053 <remove+0x2d>
		return -E_BAD_PATH;
  80304c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803051:	eb 33                	jmp    803086 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803057:	48 89 c6             	mov    %rax,%rsi
  80305a:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  803061:	00 00 00 
  803064:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  80306b:	00 00 00 
  80306e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803070:	be 00 00 00 00       	mov    $0x0,%esi
  803075:	bf 07 00 00 00       	mov    $0x7,%edi
  80307a:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  803081:	00 00 00 
  803084:	ff d0                	callq  *%rax
}
  803086:	c9                   	leaveq 
  803087:	c3                   	retq   

0000000000803088 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803088:	55                   	push   %rbp
  803089:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80308c:	be 00 00 00 00       	mov    $0x0,%esi
  803091:	bf 08 00 00 00       	mov    $0x8,%edi
  803096:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
}
  8030a2:	5d                   	pop    %rbp
  8030a3:	c3                   	retq   

00000000008030a4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030a4:	55                   	push   %rbp
  8030a5:	48 89 e5             	mov    %rsp,%rbp
  8030a8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030af:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030b6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030bd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030c4:	be 00 00 00 00       	mov    $0x0,%esi
  8030c9:	48 89 c7             	mov    %rax,%rdi
  8030cc:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8030d3:	00 00 00 
  8030d6:	ff d0                	callq  *%rax
  8030d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030df:	79 28                	jns    803109 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e4:	89 c6                	mov    %eax,%esi
  8030e6:	48 bf 69 57 80 00 00 	movabs $0x805769,%rdi
  8030ed:	00 00 00 
  8030f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f5:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8030fc:	00 00 00 
  8030ff:	ff d2                	callq  *%rdx
		return fd_src;
  803101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803104:	e9 76 01 00 00       	jmpq   80327f <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803109:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803110:	be 01 01 00 00       	mov    $0x101,%esi
  803115:	48 89 c7             	mov    %rax,%rdi
  803118:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
  803124:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803127:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80312b:	0f 89 ad 00 00 00    	jns    8031de <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803131:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803134:	89 c6                	mov    %eax,%esi
  803136:	48 bf 7f 57 80 00 00 	movabs $0x80577f,%rdi
  80313d:	00 00 00 
  803140:	b8 00 00 00 00       	mov    $0x0,%eax
  803145:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80314c:	00 00 00 
  80314f:	ff d2                	callq  *%rdx
		close(fd_src);
  803151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803154:	89 c7                	mov    %eax,%edi
  803156:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
		return fd_dest;
  803162:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803165:	e9 15 01 00 00       	jmpq   80327f <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80316a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80316d:	48 63 d0             	movslq %eax,%rdx
  803170:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803177:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80317a:	48 89 ce             	mov    %rcx,%rsi
  80317d:	89 c7                	mov    %eax,%edi
  80317f:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
  80318b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80318e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803192:	79 4a                	jns    8031de <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803194:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803197:	89 c6                	mov    %eax,%esi
  803199:	48 bf 99 57 80 00 00 	movabs $0x805799,%rdi
  8031a0:	00 00 00 
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a8:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8031af:	00 00 00 
  8031b2:	ff d2                	callq  *%rdx
			close(fd_src);
  8031b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b7:	89 c7                	mov    %eax,%edi
  8031b9:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
			close(fd_dest);
  8031c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031c8:	89 c7                	mov    %eax,%edi
  8031ca:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
			return write_size;
  8031d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031d9:	e9 a1 00 00 00       	jmpq   80327f <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031de:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e8:	ba 00 02 00 00       	mov    $0x200,%edx
  8031ed:	48 89 ce             	mov    %rcx,%rsi
  8031f0:	89 c7                	mov    %eax,%edi
  8031f2:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
  8031fe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803201:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803205:	0f 8f 5f ff ff ff    	jg     80316a <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80320b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80320f:	79 47                	jns    803258 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803211:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803214:	89 c6                	mov    %eax,%esi
  803216:	48 bf ac 57 80 00 00 	movabs $0x8057ac,%rdi
  80321d:	00 00 00 
  803220:	b8 00 00 00 00       	mov    $0x0,%eax
  803225:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80322c:	00 00 00 
  80322f:	ff d2                	callq  *%rdx
		close(fd_src);
  803231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803234:	89 c7                	mov    %eax,%edi
  803236:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
		close(fd_dest);
  803242:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803245:	89 c7                	mov    %eax,%edi
  803247:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80324e:	00 00 00 
  803251:	ff d0                	callq  *%rax
		return read_size;
  803253:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803256:	eb 27                	jmp    80327f <copy+0x1db>
	}
	close(fd_src);
  803258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325b:	89 c7                	mov    %eax,%edi
  80325d:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
	close(fd_dest);
  803269:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80326c:	89 c7                	mov    %eax,%edi
  80326e:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803275:	00 00 00 
  803278:	ff d0                	callq  *%rax
	return 0;
  80327a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80327f:	c9                   	leaveq 
  803280:	c3                   	retq   

0000000000803281 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803281:	55                   	push   %rbp
  803282:	48 89 e5             	mov    %rsp,%rbp
  803285:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  80328c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803293:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80329a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8032a1:	be 00 00 00 00       	mov    $0x0,%esi
  8032a6:	48 89 c7             	mov    %rax,%rdi
  8032a9:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
  8032b5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032bc:	79 08                	jns    8032c6 <spawn+0x45>
		return r;
  8032be:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032c1:	e9 11 03 00 00       	jmpq   8035d7 <spawn+0x356>
	fd = r;
  8032c6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032c9:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8032cc:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8032d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8032d7:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8032de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8032e1:	ba 00 02 00 00       	mov    $0x200,%edx
  8032e6:	48 89 ce             	mov    %rcx,%rsi
  8032e9:	89 c7                	mov    %eax,%edi
  8032eb:	48 b8 3e 28 80 00 00 	movabs $0x80283e,%rax
  8032f2:	00 00 00 
  8032f5:	ff d0                	callq  *%rax
  8032f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8032fc:	75 0d                	jne    80330b <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8032fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803302:	8b 00                	mov    (%rax),%eax
  803304:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803309:	74 43                	je     80334e <spawn+0xcd>
		close(fd);
  80330b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80330e:	89 c7                	mov    %eax,%edi
  803310:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80331c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803320:	8b 00                	mov    (%rax),%eax
  803322:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803327:	89 c6                	mov    %eax,%esi
  803329:	48 bf c8 57 80 00 00 	movabs $0x8057c8,%rdi
  803330:	00 00 00 
  803333:	b8 00 00 00 00       	mov    $0x0,%eax
  803338:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80333f:	00 00 00 
  803342:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803344:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803349:	e9 89 02 00 00       	jmpq   8035d7 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80334e:	b8 07 00 00 00       	mov    $0x7,%eax
  803353:	cd 30                	int    $0x30
  803355:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803358:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80335b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80335e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803362:	79 08                	jns    80336c <spawn+0xeb>
		return r;
  803364:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803367:	e9 6b 02 00 00       	jmpq   8035d7 <spawn+0x356>
	child = r;
  80336c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80336f:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803372:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803375:	25 ff 03 00 00       	and    $0x3ff,%eax
  80337a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803381:	00 00 00 
  803384:	48 98                	cltq   
  803386:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80338d:	48 01 c2             	add    %rax,%rdx
  803390:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803397:	48 89 d6             	mov    %rdx,%rsi
  80339a:	ba 18 00 00 00       	mov    $0x18,%edx
  80339f:	48 89 c7             	mov    %rax,%rdi
  8033a2:	48 89 d1             	mov    %rdx,%rcx
  8033a5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8033a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ac:	48 8b 40 18          	mov    0x18(%rax),%rax
  8033b0:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8033b7:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8033be:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8033c5:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8033cc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033cf:	48 89 ce             	mov    %rcx,%rsi
  8033d2:	89 c7                	mov    %eax,%edi
  8033d4:	48 b8 3b 38 80 00 00 	movabs $0x80383b,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
  8033e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033e7:	79 08                	jns    8033f1 <spawn+0x170>
		return r;
  8033e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033ec:	e9 e6 01 00 00       	jmpq   8035d7 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8033f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8033f9:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803400:	48 01 d0             	add    %rdx,%rax
  803403:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803407:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80340e:	e9 80 00 00 00       	jmpq   803493 <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  803413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803417:	8b 00                	mov    (%rax),%eax
  803419:	83 f8 01             	cmp    $0x1,%eax
  80341c:	75 6b                	jne    803489 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  80341e:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803429:	8b 40 04             	mov    0x4(%rax),%eax
  80342c:	83 e0 02             	and    $0x2,%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 04                	je     803437 <spawn+0x1b6>
			perm |= PTE_W;
  803433:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343b:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80343f:	41 89 c1             	mov    %eax,%r9d
  803442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803446:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80344a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80344e:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803456:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80345a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80345d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803460:	48 83 ec 08          	sub    $0x8,%rsp
  803464:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803467:	57                   	push   %rdi
  803468:	89 c7                	mov    %eax,%edi
  80346a:	48 b8 e7 3a 80 00 00 	movabs $0x803ae7,%rax
  803471:	00 00 00 
  803474:	ff d0                	callq  *%rax
  803476:	48 83 c4 10          	add    $0x10,%rsp
  80347a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80347d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803481:	0f 88 2a 01 00 00    	js     8035b1 <spawn+0x330>
  803487:	eb 01                	jmp    80348a <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803489:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80348a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80348e:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803497:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80349b:	0f b7 c0             	movzwl %ax,%eax
  80349e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8034a1:	0f 8f 6c ff ff ff    	jg     803413 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8034a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034aa:	89 c7                	mov    %eax,%edi
  8034ac:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8034b3:	00 00 00 
  8034b6:	ff d0                	callq  *%rax
	fd = -1;
  8034b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8034bf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034c2:	89 c7                	mov    %eax,%edi
  8034c4:	48 b8 d3 3c 80 00 00 	movabs $0x803cd3,%rax
  8034cb:	00 00 00 
  8034ce:	ff d0                	callq  *%rax
  8034d0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034d7:	79 30                	jns    803509 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  8034d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034dc:	89 c1                	mov    %eax,%ecx
  8034de:	48 ba e2 57 80 00 00 	movabs $0x8057e2,%rdx
  8034e5:	00 00 00 
  8034e8:	be 86 00 00 00       	mov    $0x86,%esi
  8034ed:	48 bf f8 57 80 00 00 	movabs $0x8057f8,%rdi
  8034f4:	00 00 00 
  8034f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fc:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  803503:	00 00 00 
  803506:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803509:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803510:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803513:	48 89 d6             	mov    %rdx,%rsi
  803516:	89 c7                	mov    %eax,%edi
  803518:	48 b8 9d 1f 80 00 00 	movabs $0x801f9d,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
  803524:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803527:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80352b:	79 30                	jns    80355d <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  80352d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803530:	89 c1                	mov    %eax,%ecx
  803532:	48 ba 04 58 80 00 00 	movabs $0x805804,%rdx
  803539:	00 00 00 
  80353c:	be 8a 00 00 00       	mov    $0x8a,%esi
  803541:	48 bf f8 57 80 00 00 	movabs $0x8057f8,%rdi
  803548:	00 00 00 
  80354b:	b8 00 00 00 00       	mov    $0x0,%eax
  803550:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  803557:	00 00 00 
  80355a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80355d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803560:	be 02 00 00 00       	mov    $0x2,%esi
  803565:	89 c7                	mov    %eax,%edi
  803567:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803576:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80357a:	79 30                	jns    8035ac <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  80357c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80357f:	89 c1                	mov    %eax,%ecx
  803581:	48 ba 1e 58 80 00 00 	movabs $0x80581e,%rdx
  803588:	00 00 00 
  80358b:	be 8d 00 00 00       	mov    $0x8d,%esi
  803590:	48 bf f8 57 80 00 00 	movabs $0x8057f8,%rdi
  803597:	00 00 00 
  80359a:	b8 00 00 00 00       	mov    $0x0,%eax
  80359f:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  8035a6:	00 00 00 
  8035a9:	41 ff d0             	callq  *%r8

	return child;
  8035ac:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035af:	eb 26                	jmp    8035d7 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8035b1:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8035b2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035b5:	89 c7                	mov    %eax,%edi
  8035b7:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  8035be:	00 00 00 
  8035c1:	ff d0                	callq  *%rax
	close(fd);
  8035c3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8035c6:	89 c7                	mov    %eax,%edi
  8035c8:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
	return r;
  8035d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  8035d7:	c9                   	leaveq 
  8035d8:	c3                   	retq   

00000000008035d9 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8035d9:	55                   	push   %rbp
  8035da:	48 89 e5             	mov    %rsp,%rbp
  8035dd:	41 55                	push   %r13
  8035df:	41 54                	push   %r12
  8035e1:	53                   	push   %rbx
  8035e2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8035e9:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8035f0:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  8035f7:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8035fe:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803605:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80360c:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803613:	84 c0                	test   %al,%al
  803615:	74 26                	je     80363d <spawnl+0x64>
  803617:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80361e:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803625:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803629:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80362d:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803631:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803635:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803639:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80363d:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803644:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803647:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80364e:	00 00 00 
  803651:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803658:	00 00 00 
  80365b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80365f:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803666:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80366d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803674:	eb 07                	jmp    80367d <spawnl+0xa4>
		argc++;
  803676:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80367d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803683:	83 f8 30             	cmp    $0x30,%eax
  803686:	73 23                	jae    8036ab <spawnl+0xd2>
  803688:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80368f:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803695:	89 d2                	mov    %edx,%edx
  803697:	48 01 d0             	add    %rdx,%rax
  80369a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8036a0:	83 c2 08             	add    $0x8,%edx
  8036a3:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036a9:	eb 12                	jmp    8036bd <spawnl+0xe4>
  8036ab:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8036b2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8036b6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8036bd:	48 8b 00             	mov    (%rax),%rax
  8036c0:	48 85 c0             	test   %rax,%rax
  8036c3:	75 b1                	jne    803676 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8036c5:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8036cb:	83 c0 02             	add    $0x2,%eax
  8036ce:	48 89 e2             	mov    %rsp,%rdx
  8036d1:	48 89 d3             	mov    %rdx,%rbx
  8036d4:	48 63 d0             	movslq %eax,%rdx
  8036d7:	48 83 ea 01          	sub    $0x1,%rdx
  8036db:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8036e2:	48 63 d0             	movslq %eax,%rdx
  8036e5:	49 89 d4             	mov    %rdx,%r12
  8036e8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8036ee:	48 63 d0             	movslq %eax,%rdx
  8036f1:	49 89 d2             	mov    %rdx,%r10
  8036f4:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8036fa:	48 98                	cltq   
  8036fc:	48 c1 e0 03          	shl    $0x3,%rax
  803700:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803704:	b8 10 00 00 00       	mov    $0x10,%eax
  803709:	48 83 e8 01          	sub    $0x1,%rax
  80370d:	48 01 d0             	add    %rdx,%rax
  803710:	be 10 00 00 00       	mov    $0x10,%esi
  803715:	ba 00 00 00 00       	mov    $0x0,%edx
  80371a:	48 f7 f6             	div    %rsi
  80371d:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803721:	48 29 c4             	sub    %rax,%rsp
  803724:	48 89 e0             	mov    %rsp,%rax
  803727:	48 83 c0 07          	add    $0x7,%rax
  80372b:	48 c1 e8 03          	shr    $0x3,%rax
  80372f:	48 c1 e0 03          	shl    $0x3,%rax
  803733:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80373a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803741:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803748:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80374b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803751:	8d 50 01             	lea    0x1(%rax),%edx
  803754:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80375b:	48 63 d2             	movslq %edx,%rdx
  80375e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803765:	00 

	va_start(vl, arg0);
  803766:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80376d:	00 00 00 
  803770:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803777:	00 00 00 
  80377a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80377e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803785:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80378c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803793:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80379a:	00 00 00 
  80379d:	eb 60                	jmp    8037ff <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  80379f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8037a5:	8d 48 01             	lea    0x1(%rax),%ecx
  8037a8:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8037ae:	83 f8 30             	cmp    $0x30,%eax
  8037b1:	73 23                	jae    8037d6 <spawnl+0x1fd>
  8037b3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8037ba:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8037c0:	89 d2                	mov    %edx,%edx
  8037c2:	48 01 d0             	add    %rdx,%rax
  8037c5:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8037cb:	83 c2 08             	add    $0x8,%edx
  8037ce:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8037d4:	eb 12                	jmp    8037e8 <spawnl+0x20f>
  8037d6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8037dd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8037e1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8037e8:	48 8b 10             	mov    (%rax),%rdx
  8037eb:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8037f2:	89 c9                	mov    %ecx,%ecx
  8037f4:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8037f8:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8037ff:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803805:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  80380b:	72 92                	jb     80379f <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80380d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803814:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80381b:	48 89 d6             	mov    %rdx,%rsi
  80381e:	48 89 c7             	mov    %rax,%rdi
  803821:	48 b8 81 32 80 00 00 	movabs $0x803281,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
  80382d:	48 89 dc             	mov    %rbx,%rsp
}
  803830:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803834:	5b                   	pop    %rbx
  803835:	41 5c                	pop    %r12
  803837:	41 5d                	pop    %r13
  803839:	5d                   	pop    %rbp
  80383a:	c3                   	retq   

000000000080383b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80383b:	55                   	push   %rbp
  80383c:	48 89 e5             	mov    %rsp,%rbp
  80383f:	48 83 ec 50          	sub    $0x50,%rsp
  803843:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803846:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80384a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80384e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803855:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80385d:	eb 33                	jmp    803892 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80385f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803862:	48 98                	cltq   
  803864:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80386b:	00 
  80386c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803870:	48 01 d0             	add    %rdx,%rax
  803873:	48 8b 00             	mov    (%rax),%rax
  803876:	48 89 c7             	mov    %rax,%rdi
  803879:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  803880:	00 00 00 
  803883:	ff d0                	callq  *%rax
  803885:	83 c0 01             	add    $0x1,%eax
  803888:	48 98                	cltq   
  80388a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80388e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803892:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803895:	48 98                	cltq   
  803897:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80389e:	00 
  80389f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038a3:	48 01 d0             	add    %rdx,%rax
  8038a6:	48 8b 00             	mov    (%rax),%rax
  8038a9:	48 85 c0             	test   %rax,%rax
  8038ac:	75 b1                	jne    80385f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8038ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b2:	48 f7 d8             	neg    %rax
  8038b5:	48 05 00 10 40 00    	add    $0x401000,%rax
  8038bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8038bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038c3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8038c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cb:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8038cf:	48 89 c2             	mov    %rax,%rdx
  8038d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038d5:	83 c0 01             	add    $0x1,%eax
  8038d8:	c1 e0 03             	shl    $0x3,%eax
  8038db:	48 98                	cltq   
  8038dd:	48 f7 d8             	neg    %rax
  8038e0:	48 01 d0             	add    %rdx,%rax
  8038e3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8038e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038eb:	48 83 e8 10          	sub    $0x10,%rax
  8038ef:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8038f5:	77 0a                	ja     803901 <init_stack+0xc6>
		return -E_NO_MEM;
  8038f7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8038fc:	e9 e4 01 00 00       	jmpq   803ae5 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803901:	ba 07 00 00 00       	mov    $0x7,%edx
  803906:	be 00 00 40 00       	mov    $0x400000,%esi
  80390b:	bf 00 00 00 00       	mov    $0x0,%edi
  803910:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  803917:	00 00 00 
  80391a:	ff d0                	callq  *%rax
  80391c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80391f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803923:	79 08                	jns    80392d <init_stack+0xf2>
		return r;
  803925:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803928:	e9 b8 01 00 00       	jmpq   803ae5 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80392d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803934:	e9 8a 00 00 00       	jmpq   8039c3 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  803939:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80393c:	48 98                	cltq   
  80393e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803945:	00 
  803946:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80394a:	48 01 d0             	add    %rdx,%rax
  80394d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803952:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803956:	48 01 ca             	add    %rcx,%rdx
  803959:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803960:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803963:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803966:	48 98                	cltq   
  803968:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80396f:	00 
  803970:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803974:	48 01 d0             	add    %rdx,%rax
  803977:	48 8b 10             	mov    (%rax),%rdx
  80397a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397e:	48 89 d6             	mov    %rdx,%rsi
  803981:	48 89 c7             	mov    %rax,%rdi
  803984:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  80398b:	00 00 00 
  80398e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803990:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803993:	48 98                	cltq   
  803995:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80399c:	00 
  80399d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8039a1:	48 01 d0             	add    %rdx,%rax
  8039a4:	48 8b 00             	mov    (%rax),%rax
  8039a7:	48 89 c7             	mov    %rax,%rdi
  8039aa:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  8039b1:	00 00 00 
  8039b4:	ff d0                	callq  *%rax
  8039b6:	83 c0 01             	add    $0x1,%eax
  8039b9:	48 98                	cltq   
  8039bb:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8039bf:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8039c3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039c6:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8039c9:	0f 8c 6a ff ff ff    	jl     803939 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8039cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039d2:	48 98                	cltq   
  8039d4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8039db:	00 
  8039dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e0:	48 01 d0             	add    %rdx,%rax
  8039e3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8039ea:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8039f1:	00 
  8039f2:	74 35                	je     803a29 <init_stack+0x1ee>
  8039f4:	48 b9 38 58 80 00 00 	movabs $0x805838,%rcx
  8039fb:	00 00 00 
  8039fe:	48 ba 5e 58 80 00 00 	movabs $0x80585e,%rdx
  803a05:	00 00 00 
  803a08:	be f6 00 00 00       	mov    $0xf6,%esi
  803a0d:	48 bf f8 57 80 00 00 	movabs $0x8057f8,%rdi
  803a14:	00 00 00 
  803a17:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1c:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  803a23:	00 00 00 
  803a26:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803a29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a2d:	48 83 e8 08          	sub    $0x8,%rax
  803a31:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a36:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803a3a:	48 01 ca             	add    %rcx,%rdx
  803a3d:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803a44:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  803a47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a4b:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803a4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a52:	48 98                	cltq   
  803a54:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803a57:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803a5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a60:	48 01 d0             	add    %rdx,%rax
  803a63:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803a69:	48 89 c2             	mov    %rax,%rdx
  803a6c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803a70:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803a73:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803a76:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803a7c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a81:	89 c2                	mov    %eax,%edx
  803a83:	be 00 00 40 00       	mov    $0x400000,%esi
  803a88:	bf 00 00 00 00       	mov    $0x0,%edi
  803a8d:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  803a94:	00 00 00 
  803a97:	ff d0                	callq  *%rax
  803a99:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aa0:	78 26                	js     803ac8 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803aa2:	be 00 00 40 00       	mov    $0x400000,%esi
  803aa7:	bf 00 00 00 00       	mov    $0x0,%edi
  803aac:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
  803ab8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803abb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803abf:	78 0a                	js     803acb <init_stack+0x290>
		goto error;

	return 0;
  803ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac6:	eb 1d                	jmp    803ae5 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803ac8:	90                   	nop
  803ac9:	eb 01                	jmp    803acc <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803acb:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803acc:	be 00 00 40 00       	mov    $0x400000,%esi
  803ad1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad6:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  803add:	00 00 00 
  803ae0:	ff d0                	callq  *%rax
	return r;
  803ae2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ae5:	c9                   	leaveq 
  803ae6:	c3                   	retq   

0000000000803ae7 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803ae7:	55                   	push   %rbp
  803ae8:	48 89 e5             	mov    %rsp,%rbp
  803aeb:	48 83 ec 50          	sub    $0x50,%rsp
  803aef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803af2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803af6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803afa:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803afd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803b01:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803b05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b09:	25 ff 0f 00 00       	and    $0xfff,%eax
  803b0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b15:	74 21                	je     803b38 <map_segment+0x51>
		va -= i;
  803b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b1a:	48 98                	cltq   
  803b1c:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b23:	48 98                	cltq   
  803b25:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2c:	48 98                	cltq   
  803b2e:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b35:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803b38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b3f:	e9 79 01 00 00       	jmpq   803cbd <map_segment+0x1d6>
		if (i >= filesz) {
  803b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b47:	48 98                	cltq   
  803b49:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803b4d:	72 3c                	jb     803b8b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b52:	48 63 d0             	movslq %eax,%rdx
  803b55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b59:	48 01 d0             	add    %rdx,%rax
  803b5c:	48 89 c1             	mov    %rax,%rcx
  803b5f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b62:	8b 55 10             	mov    0x10(%rbp),%edx
  803b65:	48 89 ce             	mov    %rcx,%rsi
  803b68:	89 c7                	mov    %eax,%edi
  803b6a:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  803b71:	00 00 00 
  803b74:	ff d0                	callq  *%rax
  803b76:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b79:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b7d:	0f 89 33 01 00 00    	jns    803cb6 <map_segment+0x1cf>
				return r;
  803b83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b86:	e9 46 01 00 00       	jmpq   803cd1 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803b8b:	ba 07 00 00 00       	mov    $0x7,%edx
  803b90:	be 00 00 40 00       	mov    $0x400000,%esi
  803b95:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9a:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	callq  *%rax
  803ba6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ba9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803bad:	79 08                	jns    803bb7 <map_segment+0xd0>
				return r;
  803baf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bb2:	e9 1a 01 00 00       	jmpq   803cd1 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803bb7:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbd:	01 c2                	add    %eax,%edx
  803bbf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803bc2:	89 d6                	mov    %edx,%esi
  803bc4:	89 c7                	mov    %eax,%edi
  803bc6:	48 b8 88 29 80 00 00 	movabs $0x802988,%rax
  803bcd:	00 00 00 
  803bd0:	ff d0                	callq  *%rax
  803bd2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803bd5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803bd9:	79 08                	jns    803be3 <map_segment+0xfc>
				return r;
  803bdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bde:	e9 ee 00 00 00       	jmpq   803cd1 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803be3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bed:	48 98                	cltq   
  803bef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803bf3:	48 29 c2             	sub    %rax,%rdx
  803bf6:	48 89 d0             	mov    %rdx,%rax
  803bf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803bfd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c00:	48 63 d0             	movslq %eax,%rdx
  803c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c07:	48 39 c2             	cmp    %rax,%rdx
  803c0a:	48 0f 47 d0          	cmova  %rax,%rdx
  803c0e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803c11:	be 00 00 40 00       	mov    $0x400000,%esi
  803c16:	89 c7                	mov    %eax,%edi
  803c18:	48 b8 3e 28 80 00 00 	movabs $0x80283e,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
  803c24:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c27:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c2b:	79 08                	jns    803c35 <map_segment+0x14e>
				return r;
  803c2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c30:	e9 9c 00 00 00       	jmpq   803cd1 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c38:	48 63 d0             	movslq %eax,%rdx
  803c3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c3f:	48 01 d0             	add    %rdx,%rax
  803c42:	48 89 c2             	mov    %rax,%rdx
  803c45:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c48:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803c4c:	48 89 d1             	mov    %rdx,%rcx
  803c4f:	89 c2                	mov    %eax,%edx
  803c51:	be 00 00 40 00       	mov    $0x400000,%esi
  803c56:	bf 00 00 00 00       	mov    $0x0,%edi
  803c5b:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  803c62:	00 00 00 
  803c65:	ff d0                	callq  *%rax
  803c67:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c6a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c6e:	79 30                	jns    803ca0 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803c70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c73:	89 c1                	mov    %eax,%ecx
  803c75:	48 ba 73 58 80 00 00 	movabs $0x805873,%rdx
  803c7c:	00 00 00 
  803c7f:	be 29 01 00 00       	mov    $0x129,%esi
  803c84:	48 bf f8 57 80 00 00 	movabs $0x8057f8,%rdi
  803c8b:	00 00 00 
  803c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c93:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  803c9a:	00 00 00 
  803c9d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803ca0:	be 00 00 40 00       	mov    $0x400000,%esi
  803ca5:	bf 00 00 00 00       	mov    $0x0,%edi
  803caa:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803cb6:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc0:	48 98                	cltq   
  803cc2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cc6:	0f 82 78 fe ff ff    	jb     803b44 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cd1:	c9                   	leaveq 
  803cd2:	c3                   	retq   

0000000000803cd3 <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803cd3:	55                   	push   %rbp
  803cd4:	48 89 e5             	mov    %rsp,%rbp
  803cd7:	48 83 ec 30          	sub    $0x30,%rsp
  803cdb:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803cde:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ce5:	00 
  803ce6:	e9 eb 00 00 00       	jmpq   803dd6 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  803ceb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cef:	48 c1 f8 12          	sar    $0x12,%rax
  803cf3:	48 89 c2             	mov    %rax,%rdx
  803cf6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803cfd:	01 00 00 
  803d00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d04:	83 e0 01             	and    $0x1,%eax
  803d07:	48 85 c0             	test   %rax,%rax
  803d0a:	74 21                	je     803d2d <copy_shared_pages+0x5a>
  803d0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d10:	48 c1 f8 09          	sar    $0x9,%rax
  803d14:	48 89 c2             	mov    %rax,%rdx
  803d17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d1e:	01 00 00 
  803d21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d25:	83 e0 01             	and    $0x1,%eax
  803d28:	48 85 c0             	test   %rax,%rax
  803d2b:	75 0d                	jne    803d3a <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  803d2d:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  803d34:	00 
  803d35:	e9 9c 00 00 00       	jmpq   803dd6 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  803d3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3e:	48 05 00 02 00 00    	add    $0x200,%rax
  803d44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  803d48:	eb 7e                	jmp    803dc8 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  803d4a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d51:	01 00 00 
  803d54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d5c:	25 01 04 00 00       	and    $0x401,%eax
  803d61:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  803d67:	75 5a                	jne    803dc3 <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  803d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d6d:	48 c1 e0 0c          	shl    $0xc,%rax
  803d71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  803d75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d7c:	01 00 00 
  803d7f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d87:	25 07 0e 00 00       	and    $0xe07,%eax
  803d8c:	89 c6                	mov    %eax,%esi
  803d8e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d92:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d99:	41 89 f0             	mov    %esi,%r8d
  803d9c:	48 89 c6             	mov    %rax,%rsi
  803d9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803da4:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  803dab:	00 00 00 
  803dae:	ff d0                	callq  *%rax
  803db0:	48 98                	cltq   
  803db2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  803db6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803dbb:	79 06                	jns    803dc3 <copy_shared_pages+0xf0>
						return r;
  803dbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc1:	eb 28                	jmp    803deb <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  803dc3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dcc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803dd0:	0f 8c 74 ff ff ff    	jl     803d4a <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  803dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dda:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  803de0:	0f 86 05 ff ff ff    	jbe    803ceb <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  803de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803deb:	c9                   	leaveq 
  803dec:	c3                   	retq   

0000000000803ded <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803ded:	55                   	push   %rbp
  803dee:	48 89 e5             	mov    %rsp,%rbp
  803df1:	48 83 ec 20          	sub    $0x20,%rsp
  803df5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803df8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dfc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dff:	48 89 d6             	mov    %rdx,%rsi
  803e02:	89 c7                	mov    %eax,%edi
  803e04:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  803e0b:	00 00 00 
  803e0e:	ff d0                	callq  *%rax
  803e10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e17:	79 05                	jns    803e1e <fd2sockid+0x31>
		return r;
  803e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1c:	eb 24                	jmp    803e42 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e22:	8b 10                	mov    (%rax),%edx
  803e24:	48 b8 40 88 80 00 00 	movabs $0x808840,%rax
  803e2b:	00 00 00 
  803e2e:	8b 00                	mov    (%rax),%eax
  803e30:	39 c2                	cmp    %eax,%edx
  803e32:	74 07                	je     803e3b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803e34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e39:	eb 07                	jmp    803e42 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803e42:	c9                   	leaveq 
  803e43:	c3                   	retq   

0000000000803e44 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803e44:	55                   	push   %rbp
  803e45:	48 89 e5             	mov    %rsp,%rbp
  803e48:	48 83 ec 20          	sub    $0x20,%rsp
  803e4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803e4f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e53:	48 89 c7             	mov    %rax,%rdi
  803e56:	48 b8 9c 22 80 00 00 	movabs $0x80229c,%rax
  803e5d:	00 00 00 
  803e60:	ff d0                	callq  *%rax
  803e62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e69:	78 26                	js     803e91 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803e6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6f:	ba 07 04 00 00       	mov    $0x407,%edx
  803e74:	48 89 c6             	mov    %rax,%rsi
  803e77:	bf 00 00 00 00       	mov    $0x0,%edi
  803e7c:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  803e83:	00 00 00 
  803e86:	ff d0                	callq  *%rax
  803e88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e8f:	79 16                	jns    803ea7 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803e91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e94:	89 c7                	mov    %eax,%edi
  803e96:	48 b8 53 43 80 00 00 	movabs $0x804353,%rax
  803e9d:	00 00 00 
  803ea0:	ff d0                	callq  *%rax
		return r;
  803ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea5:	eb 3a                	jmp    803ee1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eab:	48 ba 40 88 80 00 00 	movabs $0x808840,%rdx
  803eb2:	00 00 00 
  803eb5:	8b 12                	mov    (%rdx),%edx
  803eb7:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ecb:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed2:	48 89 c7             	mov    %rax,%rdi
  803ed5:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  803edc:	00 00 00 
  803edf:	ff d0                	callq  *%rax
}
  803ee1:	c9                   	leaveq 
  803ee2:	c3                   	retq   

0000000000803ee3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ee3:	55                   	push   %rbp
  803ee4:	48 89 e5             	mov    %rsp,%rbp
  803ee7:	48 83 ec 30          	sub    $0x30,%rsp
  803eeb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803eee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ef2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ef6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ef9:	89 c7                	mov    %eax,%edi
  803efb:	48 b8 ed 3d 80 00 00 	movabs $0x803ded,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
  803f07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0e:	79 05                	jns    803f15 <accept+0x32>
		return r;
  803f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f13:	eb 3b                	jmp    803f50 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803f15:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803f19:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f20:	48 89 ce             	mov    %rcx,%rsi
  803f23:	89 c7                	mov    %eax,%edi
  803f25:	48 b8 30 42 80 00 00 	movabs $0x804230,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f38:	79 05                	jns    803f3f <accept+0x5c>
		return r;
  803f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3d:	eb 11                	jmp    803f50 <accept+0x6d>
	return alloc_sockfd(r);
  803f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f42:	89 c7                	mov    %eax,%edi
  803f44:	48 b8 44 3e 80 00 00 	movabs $0x803e44,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
}
  803f50:	c9                   	leaveq 
  803f51:	c3                   	retq   

0000000000803f52 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f52:	55                   	push   %rbp
  803f53:	48 89 e5             	mov    %rsp,%rbp
  803f56:	48 83 ec 20          	sub    $0x20,%rsp
  803f5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f61:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f67:	89 c7                	mov    %eax,%edi
  803f69:	48 b8 ed 3d 80 00 00 	movabs $0x803ded,%rax
  803f70:	00 00 00 
  803f73:	ff d0                	callq  *%rax
  803f75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f7c:	79 05                	jns    803f83 <bind+0x31>
		return r;
  803f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f81:	eb 1b                	jmp    803f9e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803f83:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f86:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f8d:	48 89 ce             	mov    %rcx,%rsi
  803f90:	89 c7                	mov    %eax,%edi
  803f92:	48 b8 af 42 80 00 00 	movabs $0x8042af,%rax
  803f99:	00 00 00 
  803f9c:	ff d0                	callq  *%rax
}
  803f9e:	c9                   	leaveq 
  803f9f:	c3                   	retq   

0000000000803fa0 <shutdown>:

int
shutdown(int s, int how)
{
  803fa0:	55                   	push   %rbp
  803fa1:	48 89 e5             	mov    %rsp,%rbp
  803fa4:	48 83 ec 20          	sub    $0x20,%rsp
  803fa8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fab:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803fae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb1:	89 c7                	mov    %eax,%edi
  803fb3:	48 b8 ed 3d 80 00 00 	movabs $0x803ded,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
  803fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc6:	79 05                	jns    803fcd <shutdown+0x2d>
		return r;
  803fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcb:	eb 16                	jmp    803fe3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803fcd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803fd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd3:	89 d6                	mov    %edx,%esi
  803fd5:	89 c7                	mov    %eax,%edi
  803fd7:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
}
  803fe3:	c9                   	leaveq 
  803fe4:	c3                   	retq   

0000000000803fe5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803fe5:	55                   	push   %rbp
  803fe6:	48 89 e5             	mov    %rsp,%rbp
  803fe9:	48 83 ec 10          	sub    $0x10,%rsp
  803fed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff5:	48 89 c7             	mov    %rax,%rdi
  803ff8:	48 b8 8a 4f 80 00 00 	movabs $0x804f8a,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
  804004:	83 f8 01             	cmp    $0x1,%eax
  804007:	75 17                	jne    804020 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80400d:	8b 40 0c             	mov    0xc(%rax),%eax
  804010:	89 c7                	mov    %eax,%edi
  804012:	48 b8 53 43 80 00 00 	movabs $0x804353,%rax
  804019:	00 00 00 
  80401c:	ff d0                	callq  *%rax
  80401e:	eb 05                	jmp    804025 <devsock_close+0x40>
	else
		return 0;
  804020:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804025:	c9                   	leaveq 
  804026:	c3                   	retq   

0000000000804027 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804027:	55                   	push   %rbp
  804028:	48 89 e5             	mov    %rsp,%rbp
  80402b:	48 83 ec 20          	sub    $0x20,%rsp
  80402f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804032:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804036:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804039:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80403c:	89 c7                	mov    %eax,%edi
  80403e:	48 b8 ed 3d 80 00 00 	movabs $0x803ded,%rax
  804045:	00 00 00 
  804048:	ff d0                	callq  *%rax
  80404a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80404d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804051:	79 05                	jns    804058 <connect+0x31>
		return r;
  804053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804056:	eb 1b                	jmp    804073 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804058:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80405b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80405f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804062:	48 89 ce             	mov    %rcx,%rsi
  804065:	89 c7                	mov    %eax,%edi
  804067:	48 b8 80 43 80 00 00 	movabs $0x804380,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
}
  804073:	c9                   	leaveq 
  804074:	c3                   	retq   

0000000000804075 <listen>:

int
listen(int s, int backlog)
{
  804075:	55                   	push   %rbp
  804076:	48 89 e5             	mov    %rsp,%rbp
  804079:	48 83 ec 20          	sub    $0x20,%rsp
  80407d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804080:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804083:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804086:	89 c7                	mov    %eax,%edi
  804088:	48 b8 ed 3d 80 00 00 	movabs $0x803ded,%rax
  80408f:	00 00 00 
  804092:	ff d0                	callq  *%rax
  804094:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804097:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409b:	79 05                	jns    8040a2 <listen+0x2d>
		return r;
  80409d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a0:	eb 16                	jmp    8040b8 <listen+0x43>
	return nsipc_listen(r, backlog);
  8040a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a8:	89 d6                	mov    %edx,%esi
  8040aa:	89 c7                	mov    %eax,%edi
  8040ac:	48 b8 e4 43 80 00 00 	movabs $0x8043e4,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
}
  8040b8:	c9                   	leaveq 
  8040b9:	c3                   	retq   

00000000008040ba <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8040ba:	55                   	push   %rbp
  8040bb:	48 89 e5             	mov    %rsp,%rbp
  8040be:	48 83 ec 20          	sub    $0x20,%rsp
  8040c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8040ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d2:	89 c2                	mov    %eax,%edx
  8040d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d8:	8b 40 0c             	mov    0xc(%rax),%eax
  8040db:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8040df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8040e4:	89 c7                	mov    %eax,%edi
  8040e6:	48 b8 24 44 80 00 00 	movabs $0x804424,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
}
  8040f2:	c9                   	leaveq 
  8040f3:	c3                   	retq   

00000000008040f4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8040f4:	55                   	push   %rbp
  8040f5:	48 89 e5             	mov    %rsp,%rbp
  8040f8:	48 83 ec 20          	sub    $0x20,%rsp
  8040fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804100:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804104:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410c:	89 c2                	mov    %eax,%edx
  80410e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804112:	8b 40 0c             	mov    0xc(%rax),%eax
  804115:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804119:	b9 00 00 00 00       	mov    $0x0,%ecx
  80411e:	89 c7                	mov    %eax,%edi
  804120:	48 b8 f0 44 80 00 00 	movabs $0x8044f0,%rax
  804127:	00 00 00 
  80412a:	ff d0                	callq  *%rax
}
  80412c:	c9                   	leaveq 
  80412d:	c3                   	retq   

000000000080412e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80412e:	55                   	push   %rbp
  80412f:	48 89 e5             	mov    %rsp,%rbp
  804132:	48 83 ec 10          	sub    $0x10,%rsp
  804136:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80413a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80413e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804142:	48 be 95 58 80 00 00 	movabs $0x805895,%rsi
  804149:	00 00 00 
  80414c:	48 89 c7             	mov    %rax,%rdi
  80414f:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  804156:	00 00 00 
  804159:	ff d0                	callq  *%rax
	return 0;
  80415b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804160:	c9                   	leaveq 
  804161:	c3                   	retq   

0000000000804162 <socket>:

int
socket(int domain, int type, int protocol)
{
  804162:	55                   	push   %rbp
  804163:	48 89 e5             	mov    %rsp,%rbp
  804166:	48 83 ec 20          	sub    $0x20,%rsp
  80416a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80416d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804170:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804173:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804176:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804179:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80417c:	89 ce                	mov    %ecx,%esi
  80417e:	89 c7                	mov    %eax,%edi
  804180:	48 b8 a8 45 80 00 00 	movabs $0x8045a8,%rax
  804187:	00 00 00 
  80418a:	ff d0                	callq  *%rax
  80418c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80418f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804193:	79 05                	jns    80419a <socket+0x38>
		return r;
  804195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804198:	eb 11                	jmp    8041ab <socket+0x49>
	return alloc_sockfd(r);
  80419a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80419d:	89 c7                	mov    %eax,%edi
  80419f:	48 b8 44 3e 80 00 00 	movabs $0x803e44,%rax
  8041a6:	00 00 00 
  8041a9:	ff d0                	callq  *%rax
}
  8041ab:	c9                   	leaveq 
  8041ac:	c3                   	retq   

00000000008041ad <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8041ad:	55                   	push   %rbp
  8041ae:	48 89 e5             	mov    %rsp,%rbp
  8041b1:	48 83 ec 10          	sub    $0x10,%rsp
  8041b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8041b8:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8041bf:	00 00 00 
  8041c2:	8b 00                	mov    (%rax),%eax
  8041c4:	85 c0                	test   %eax,%eax
  8041c6:	75 1f                	jne    8041e7 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8041c8:	bf 02 00 00 00       	mov    $0x2,%edi
  8041cd:	48 b8 19 4f 80 00 00 	movabs $0x804f19,%rax
  8041d4:	00 00 00 
  8041d7:	ff d0                	callq  *%rax
  8041d9:	89 c2                	mov    %eax,%edx
  8041db:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8041e2:	00 00 00 
  8041e5:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8041e7:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8041ee:	00 00 00 
  8041f1:	8b 00                	mov    (%rax),%eax
  8041f3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8041f6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8041fb:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  804202:	00 00 00 
  804205:	89 c7                	mov    %eax,%edi
  804207:	48 b8 0d 4d 80 00 00 	movabs $0x804d0d,%rax
  80420e:	00 00 00 
  804211:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804213:	ba 00 00 00 00       	mov    $0x0,%edx
  804218:	be 00 00 00 00       	mov    $0x0,%esi
  80421d:	bf 00 00 00 00       	mov    $0x0,%edi
  804222:	48 b8 4c 4c 80 00 00 	movabs $0x804c4c,%rax
  804229:	00 00 00 
  80422c:	ff d0                	callq  *%rax
}
  80422e:	c9                   	leaveq 
  80422f:	c3                   	retq   

0000000000804230 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804230:	55                   	push   %rbp
  804231:	48 89 e5             	mov    %rsp,%rbp
  804234:	48 83 ec 30          	sub    $0x30,%rsp
  804238:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80423b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80423f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804243:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80424a:	00 00 00 
  80424d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804250:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804252:	bf 01 00 00 00       	mov    $0x1,%edi
  804257:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  80425e:	00 00 00 
  804261:	ff d0                	callq  *%rax
  804263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80426a:	78 3e                	js     8042aa <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80426c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804273:	00 00 00 
  804276:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80427a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80427e:	8b 40 10             	mov    0x10(%rax),%eax
  804281:	89 c2                	mov    %eax,%edx
  804283:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804287:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80428b:	48 89 ce             	mov    %rcx,%rsi
  80428e:	48 89 c7             	mov    %rax,%rdi
  804291:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80429d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a1:	8b 50 10             	mov    0x10(%rax),%edx
  8042a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a8:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8042aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042ad:	c9                   	leaveq 
  8042ae:	c3                   	retq   

00000000008042af <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8042af:	55                   	push   %rbp
  8042b0:	48 89 e5             	mov    %rsp,%rbp
  8042b3:	48 83 ec 10          	sub    $0x10,%rsp
  8042b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042be:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8042c1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042c8:	00 00 00 
  8042cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042ce:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8042d0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d7:	48 89 c6             	mov    %rax,%rsi
  8042da:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8042e1:	00 00 00 
  8042e4:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  8042eb:	00 00 00 
  8042ee:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8042f0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042f7:	00 00 00 
  8042fa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042fd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804300:	bf 02 00 00 00       	mov    $0x2,%edi
  804305:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  80430c:	00 00 00 
  80430f:	ff d0                	callq  *%rax
}
  804311:	c9                   	leaveq 
  804312:	c3                   	retq   

0000000000804313 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804313:	55                   	push   %rbp
  804314:	48 89 e5             	mov    %rsp,%rbp
  804317:	48 83 ec 10          	sub    $0x10,%rsp
  80431b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80431e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804321:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804328:	00 00 00 
  80432b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80432e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804330:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804337:	00 00 00 
  80433a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80433d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804340:	bf 03 00 00 00       	mov    $0x3,%edi
  804345:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  80434c:	00 00 00 
  80434f:	ff d0                	callq  *%rax
}
  804351:	c9                   	leaveq 
  804352:	c3                   	retq   

0000000000804353 <nsipc_close>:

int
nsipc_close(int s)
{
  804353:	55                   	push   %rbp
  804354:	48 89 e5             	mov    %rsp,%rbp
  804357:	48 83 ec 10          	sub    $0x10,%rsp
  80435b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80435e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804365:	00 00 00 
  804368:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80436b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80436d:	bf 04 00 00 00       	mov    $0x4,%edi
  804372:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  804379:	00 00 00 
  80437c:	ff d0                	callq  *%rax
}
  80437e:	c9                   	leaveq 
  80437f:	c3                   	retq   

0000000000804380 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804380:	55                   	push   %rbp
  804381:	48 89 e5             	mov    %rsp,%rbp
  804384:	48 83 ec 10          	sub    $0x10,%rsp
  804388:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80438b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80438f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804392:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804399:	00 00 00 
  80439c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80439f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8043a1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a8:	48 89 c6             	mov    %rax,%rsi
  8043ab:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8043b2:	00 00 00 
  8043b5:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  8043bc:	00 00 00 
  8043bf:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8043c1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8043c8:	00 00 00 
  8043cb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043ce:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8043d1:	bf 05 00 00 00       	mov    $0x5,%edi
  8043d6:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  8043dd:	00 00 00 
  8043e0:	ff d0                	callq  *%rax
}
  8043e2:	c9                   	leaveq 
  8043e3:	c3                   	retq   

00000000008043e4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8043e4:	55                   	push   %rbp
  8043e5:	48 89 e5             	mov    %rsp,%rbp
  8043e8:	48 83 ec 10          	sub    $0x10,%rsp
  8043ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043ef:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8043f2:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8043f9:	00 00 00 
  8043fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043ff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804401:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804408:	00 00 00 
  80440b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80440e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804411:	bf 06 00 00 00       	mov    $0x6,%edi
  804416:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  80441d:	00 00 00 
  804420:	ff d0                	callq  *%rax
}
  804422:	c9                   	leaveq 
  804423:	c3                   	retq   

0000000000804424 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804424:	55                   	push   %rbp
  804425:	48 89 e5             	mov    %rsp,%rbp
  804428:	48 83 ec 30          	sub    $0x30,%rsp
  80442c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80442f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804433:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804436:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804439:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804440:	00 00 00 
  804443:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804446:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804448:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80444f:	00 00 00 
  804452:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804455:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804458:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80445f:	00 00 00 
  804462:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804465:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804468:	bf 07 00 00 00       	mov    $0x7,%edi
  80446d:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  804474:	00 00 00 
  804477:	ff d0                	callq  *%rax
  804479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80447c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804480:	78 69                	js     8044eb <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804482:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804489:	7f 08                	jg     804493 <nsipc_recv+0x6f>
  80448b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804491:	7e 35                	jle    8044c8 <nsipc_recv+0xa4>
  804493:	48 b9 9c 58 80 00 00 	movabs $0x80589c,%rcx
  80449a:	00 00 00 
  80449d:	48 ba b1 58 80 00 00 	movabs $0x8058b1,%rdx
  8044a4:	00 00 00 
  8044a7:	be 62 00 00 00       	mov    $0x62,%esi
  8044ac:	48 bf c6 58 80 00 00 	movabs $0x8058c6,%rdi
  8044b3:	00 00 00 
  8044b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8044bb:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  8044c2:	00 00 00 
  8044c5:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8044c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044cb:	48 63 d0             	movslq %eax,%rdx
  8044ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044d2:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  8044d9:	00 00 00 
  8044dc:	48 89 c7             	mov    %rax,%rdi
  8044df:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  8044e6:	00 00 00 
  8044e9:	ff d0                	callq  *%rax
	}

	return r;
  8044eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044ee:	c9                   	leaveq 
  8044ef:	c3                   	retq   

00000000008044f0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8044f0:	55                   	push   %rbp
  8044f1:	48 89 e5             	mov    %rsp,%rbp
  8044f4:	48 83 ec 20          	sub    $0x20,%rsp
  8044f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044ff:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804502:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804505:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80450c:	00 00 00 
  80450f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804512:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804514:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80451b:	7e 35                	jle    804552 <nsipc_send+0x62>
  80451d:	48 b9 d2 58 80 00 00 	movabs $0x8058d2,%rcx
  804524:	00 00 00 
  804527:	48 ba b1 58 80 00 00 	movabs $0x8058b1,%rdx
  80452e:	00 00 00 
  804531:	be 6d 00 00 00       	mov    $0x6d,%esi
  804536:	48 bf c6 58 80 00 00 	movabs $0x8058c6,%rdi
  80453d:	00 00 00 
  804540:	b8 00 00 00 00       	mov    $0x0,%eax
  804545:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  80454c:	00 00 00 
  80454f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804552:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804555:	48 63 d0             	movslq %eax,%rdx
  804558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455c:	48 89 c6             	mov    %rax,%rsi
  80455f:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  804566:	00 00 00 
  804569:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  804570:	00 00 00 
  804573:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804575:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80457c:	00 00 00 
  80457f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804582:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804585:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80458c:	00 00 00 
  80458f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804592:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804595:	bf 08 00 00 00       	mov    $0x8,%edi
  80459a:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  8045a1:	00 00 00 
  8045a4:	ff d0                	callq  *%rax
}
  8045a6:	c9                   	leaveq 
  8045a7:	c3                   	retq   

00000000008045a8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8045a8:	55                   	push   %rbp
  8045a9:	48 89 e5             	mov    %rsp,%rbp
  8045ac:	48 83 ec 10          	sub    $0x10,%rsp
  8045b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045b3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8045b6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8045b9:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8045c0:	00 00 00 
  8045c3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8045c6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8045c8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8045cf:	00 00 00 
  8045d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045d5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8045d8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8045df:	00 00 00 
  8045e2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8045e5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8045e8:	bf 09 00 00 00       	mov    $0x9,%edi
  8045ed:	48 b8 ad 41 80 00 00 	movabs $0x8041ad,%rax
  8045f4:	00 00 00 
  8045f7:	ff d0                	callq  *%rax
}
  8045f9:	c9                   	leaveq 
  8045fa:	c3                   	retq   

00000000008045fb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8045fb:	55                   	push   %rbp
  8045fc:	48 89 e5             	mov    %rsp,%rbp
  8045ff:	53                   	push   %rbx
  804600:	48 83 ec 38          	sub    $0x38,%rsp
  804604:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804608:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80460c:	48 89 c7             	mov    %rax,%rdi
  80460f:	48 b8 9c 22 80 00 00 	movabs $0x80229c,%rax
  804616:	00 00 00 
  804619:	ff d0                	callq  *%rax
  80461b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80461e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804622:	0f 88 bf 01 00 00    	js     8047e7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80462c:	ba 07 04 00 00       	mov    $0x407,%edx
  804631:	48 89 c6             	mov    %rax,%rsi
  804634:	bf 00 00 00 00       	mov    $0x0,%edi
  804639:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  804640:	00 00 00 
  804643:	ff d0                	callq  *%rax
  804645:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804648:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80464c:	0f 88 95 01 00 00    	js     8047e7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804652:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804656:	48 89 c7             	mov    %rax,%rdi
  804659:	48 b8 9c 22 80 00 00 	movabs $0x80229c,%rax
  804660:	00 00 00 
  804663:	ff d0                	callq  *%rax
  804665:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804668:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80466c:	0f 88 5d 01 00 00    	js     8047cf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804672:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804676:	ba 07 04 00 00       	mov    $0x407,%edx
  80467b:	48 89 c6             	mov    %rax,%rsi
  80467e:	bf 00 00 00 00       	mov    $0x0,%edi
  804683:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  80468a:	00 00 00 
  80468d:	ff d0                	callq  *%rax
  80468f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804692:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804696:	0f 88 33 01 00 00    	js     8047cf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80469c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a0:	48 89 c7             	mov    %rax,%rdi
  8046a3:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  8046aa:	00 00 00 
  8046ad:	ff d0                	callq  *%rax
  8046af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046b7:	ba 07 04 00 00       	mov    $0x407,%edx
  8046bc:	48 89 c6             	mov    %rax,%rsi
  8046bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8046c4:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  8046cb:	00 00 00 
  8046ce:	ff d0                	callq  *%rax
  8046d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046d7:	0f 88 d9 00 00 00    	js     8047b6 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046e1:	48 89 c7             	mov    %rax,%rdi
  8046e4:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  8046eb:	00 00 00 
  8046ee:	ff d0                	callq  *%rax
  8046f0:	48 89 c2             	mov    %rax,%rdx
  8046f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046f7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8046fd:	48 89 d1             	mov    %rdx,%rcx
  804700:	ba 00 00 00 00       	mov    $0x0,%edx
  804705:	48 89 c6             	mov    %rax,%rsi
  804708:	bf 00 00 00 00       	mov    $0x0,%edi
  80470d:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  804714:	00 00 00 
  804717:	ff d0                	callq  *%rax
  804719:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80471c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804720:	78 79                	js     80479b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804726:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80472d:	00 00 00 
  804730:	8b 12                	mov    (%rdx),%edx
  804732:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804738:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80473f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804743:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80474a:	00 00 00 
  80474d:	8b 12                	mov    (%rdx),%edx
  80474f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804751:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804755:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80475c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804760:	48 89 c7             	mov    %rax,%rdi
  804763:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  80476a:	00 00 00 
  80476d:	ff d0                	callq  *%rax
  80476f:	89 c2                	mov    %eax,%edx
  804771:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804775:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804777:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80477b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80477f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804783:	48 89 c7             	mov    %rax,%rdi
  804786:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  80478d:	00 00 00 
  804790:	ff d0                	callq  *%rax
  804792:	89 03                	mov    %eax,(%rbx)
	return 0;
  804794:	b8 00 00 00 00       	mov    $0x0,%eax
  804799:	eb 4f                	jmp    8047ea <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80479b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80479c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047a0:	48 89 c6             	mov    %rax,%rsi
  8047a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8047a8:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  8047af:	00 00 00 
  8047b2:	ff d0                	callq  *%rax
  8047b4:	eb 01                	jmp    8047b7 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8047b6:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8047b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047bb:	48 89 c6             	mov    %rax,%rsi
  8047be:	bf 00 00 00 00       	mov    $0x0,%edi
  8047c3:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  8047ca:	00 00 00 
  8047cd:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8047cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047d3:	48 89 c6             	mov    %rax,%rsi
  8047d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8047db:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  8047e2:	00 00 00 
  8047e5:	ff d0                	callq  *%rax
err:
	return r;
  8047e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8047ea:	48 83 c4 38          	add    $0x38,%rsp
  8047ee:	5b                   	pop    %rbx
  8047ef:	5d                   	pop    %rbp
  8047f0:	c3                   	retq   

00000000008047f1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8047f1:	55                   	push   %rbp
  8047f2:	48 89 e5             	mov    %rsp,%rbp
  8047f5:	53                   	push   %rbx
  8047f6:	48 83 ec 28          	sub    $0x28,%rsp
  8047fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804802:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804809:	00 00 00 
  80480c:	48 8b 00             	mov    (%rax),%rax
  80480f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804815:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80481c:	48 89 c7             	mov    %rax,%rdi
  80481f:	48 b8 8a 4f 80 00 00 	movabs $0x804f8a,%rax
  804826:	00 00 00 
  804829:	ff d0                	callq  *%rax
  80482b:	89 c3                	mov    %eax,%ebx
  80482d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804831:	48 89 c7             	mov    %rax,%rdi
  804834:	48 b8 8a 4f 80 00 00 	movabs $0x804f8a,%rax
  80483b:	00 00 00 
  80483e:	ff d0                	callq  *%rax
  804840:	39 c3                	cmp    %eax,%ebx
  804842:	0f 94 c0             	sete   %al
  804845:	0f b6 c0             	movzbl %al,%eax
  804848:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80484b:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804852:	00 00 00 
  804855:	48 8b 00             	mov    (%rax),%rax
  804858:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80485e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804861:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804864:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804867:	75 05                	jne    80486e <_pipeisclosed+0x7d>
			return ret;
  804869:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80486c:	eb 4a                	jmp    8048b8 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80486e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804871:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804874:	74 8c                	je     804802 <_pipeisclosed+0x11>
  804876:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80487a:	75 86                	jne    804802 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80487c:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804883:	00 00 00 
  804886:	48 8b 00             	mov    (%rax),%rax
  804889:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80488f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804892:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804895:	89 c6                	mov    %eax,%esi
  804897:	48 bf e3 58 80 00 00 	movabs $0x8058e3,%rdi
  80489e:	00 00 00 
  8048a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a6:	49 b8 8c 09 80 00 00 	movabs $0x80098c,%r8
  8048ad:	00 00 00 
  8048b0:	41 ff d0             	callq  *%r8
	}
  8048b3:	e9 4a ff ff ff       	jmpq   804802 <_pipeisclosed+0x11>

}
  8048b8:	48 83 c4 28          	add    $0x28,%rsp
  8048bc:	5b                   	pop    %rbx
  8048bd:	5d                   	pop    %rbp
  8048be:	c3                   	retq   

00000000008048bf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8048bf:	55                   	push   %rbp
  8048c0:	48 89 e5             	mov    %rsp,%rbp
  8048c3:	48 83 ec 30          	sub    $0x30,%rsp
  8048c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8048ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8048ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8048d1:	48 89 d6             	mov    %rdx,%rsi
  8048d4:	89 c7                	mov    %eax,%edi
  8048d6:	48 b8 34 23 80 00 00 	movabs $0x802334,%rax
  8048dd:	00 00 00 
  8048e0:	ff d0                	callq  *%rax
  8048e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048e9:	79 05                	jns    8048f0 <pipeisclosed+0x31>
		return r;
  8048eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048ee:	eb 31                	jmp    804921 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8048f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048f4:	48 89 c7             	mov    %rax,%rdi
  8048f7:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  8048fe:	00 00 00 
  804901:	ff d0                	callq  *%rax
  804903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80490b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80490f:	48 89 d6             	mov    %rdx,%rsi
  804912:	48 89 c7             	mov    %rax,%rdi
  804915:	48 b8 f1 47 80 00 00 	movabs $0x8047f1,%rax
  80491c:	00 00 00 
  80491f:	ff d0                	callq  *%rax
}
  804921:	c9                   	leaveq 
  804922:	c3                   	retq   

0000000000804923 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804923:	55                   	push   %rbp
  804924:	48 89 e5             	mov    %rsp,%rbp
  804927:	48 83 ec 40          	sub    $0x40,%rsp
  80492b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80492f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804933:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80493b:	48 89 c7             	mov    %rax,%rdi
  80493e:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  804945:	00 00 00 
  804948:	ff d0                	callq  *%rax
  80494a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80494e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804952:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804956:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80495d:	00 
  80495e:	e9 90 00 00 00       	jmpq   8049f3 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804963:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804968:	74 09                	je     804973 <devpipe_read+0x50>
				return i;
  80496a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80496e:	e9 8e 00 00 00       	jmpq   804a01 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804973:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80497b:	48 89 d6             	mov    %rdx,%rsi
  80497e:	48 89 c7             	mov    %rax,%rdi
  804981:	48 b8 f1 47 80 00 00 	movabs $0x8047f1,%rax
  804988:	00 00 00 
  80498b:	ff d0                	callq  *%rax
  80498d:	85 c0                	test   %eax,%eax
  80498f:	74 07                	je     804998 <devpipe_read+0x75>
				return 0;
  804991:	b8 00 00 00 00       	mov    $0x0,%eax
  804996:	eb 69                	jmp    804a01 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804998:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  80499f:	00 00 00 
  8049a2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8049a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049a8:	8b 10                	mov    (%rax),%edx
  8049aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049ae:	8b 40 04             	mov    0x4(%rax),%eax
  8049b1:	39 c2                	cmp    %eax,%edx
  8049b3:	74 ae                	je     804963 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8049b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049bd:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8049c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c5:	8b 00                	mov    (%rax),%eax
  8049c7:	99                   	cltd   
  8049c8:	c1 ea 1b             	shr    $0x1b,%edx
  8049cb:	01 d0                	add    %edx,%eax
  8049cd:	83 e0 1f             	and    $0x1f,%eax
  8049d0:	29 d0                	sub    %edx,%eax
  8049d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049d6:	48 98                	cltq   
  8049d8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8049dd:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8049df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049e3:	8b 00                	mov    (%rax),%eax
  8049e5:	8d 50 01             	lea    0x1(%rax),%edx
  8049e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049ec:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8049ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049f7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049fb:	72 a7                	jb     8049a4 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8049fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804a01:	c9                   	leaveq 
  804a02:	c3                   	retq   

0000000000804a03 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a03:	55                   	push   %rbp
  804a04:	48 89 e5             	mov    %rsp,%rbp
  804a07:	48 83 ec 40          	sub    $0x40,%rsp
  804a0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a0f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804a13:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a1b:	48 89 c7             	mov    %rax,%rdi
  804a1e:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  804a25:	00 00 00 
  804a28:	ff d0                	callq  *%rax
  804a2a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804a2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804a36:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804a3d:	00 
  804a3e:	e9 8f 00 00 00       	jmpq   804ad2 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804a43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a4b:	48 89 d6             	mov    %rdx,%rsi
  804a4e:	48 89 c7             	mov    %rax,%rdi
  804a51:	48 b8 f1 47 80 00 00 	movabs $0x8047f1,%rax
  804a58:	00 00 00 
  804a5b:	ff d0                	callq  *%rax
  804a5d:	85 c0                	test   %eax,%eax
  804a5f:	74 07                	je     804a68 <devpipe_write+0x65>
				return 0;
  804a61:	b8 00 00 00 00       	mov    $0x0,%eax
  804a66:	eb 78                	jmp    804ae0 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804a68:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  804a6f:	00 00 00 
  804a72:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a78:	8b 40 04             	mov    0x4(%rax),%eax
  804a7b:	48 63 d0             	movslq %eax,%rdx
  804a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a82:	8b 00                	mov    (%rax),%eax
  804a84:	48 98                	cltq   
  804a86:	48 83 c0 20          	add    $0x20,%rax
  804a8a:	48 39 c2             	cmp    %rax,%rdx
  804a8d:	73 b4                	jae    804a43 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a93:	8b 40 04             	mov    0x4(%rax),%eax
  804a96:	99                   	cltd   
  804a97:	c1 ea 1b             	shr    $0x1b,%edx
  804a9a:	01 d0                	add    %edx,%eax
  804a9c:	83 e0 1f             	and    $0x1f,%eax
  804a9f:	29 d0                	sub    %edx,%eax
  804aa1:	89 c6                	mov    %eax,%esi
  804aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804aa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aab:	48 01 d0             	add    %rdx,%rax
  804aae:	0f b6 08             	movzbl (%rax),%ecx
  804ab1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ab5:	48 63 c6             	movslq %esi,%rax
  804ab8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804abc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ac0:	8b 40 04             	mov    0x4(%rax),%eax
  804ac3:	8d 50 01             	lea    0x1(%rax),%edx
  804ac6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aca:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804acd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ad6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804ada:	72 98                	jb     804a74 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804adc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804ae0:	c9                   	leaveq 
  804ae1:	c3                   	retq   

0000000000804ae2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804ae2:	55                   	push   %rbp
  804ae3:	48 89 e5             	mov    %rsp,%rbp
  804ae6:	48 83 ec 20          	sub    $0x20,%rsp
  804aea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804aee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804af6:	48 89 c7             	mov    %rax,%rdi
  804af9:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  804b00:	00 00 00 
  804b03:	ff d0                	callq  *%rax
  804b05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804b09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b0d:	48 be f6 58 80 00 00 	movabs $0x8058f6,%rsi
  804b14:	00 00 00 
  804b17:	48 89 c7             	mov    %rax,%rdi
  804b1a:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  804b21:	00 00 00 
  804b24:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804b26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b2a:	8b 50 04             	mov    0x4(%rax),%edx
  804b2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b31:	8b 00                	mov    (%rax),%eax
  804b33:	29 c2                	sub    %eax,%edx
  804b35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b39:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804b3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b43:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804b4a:	00 00 00 
	stat->st_dev = &devpipe;
  804b4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b51:	48 b9 80 88 80 00 00 	movabs $0x808880,%rcx
  804b58:	00 00 00 
  804b5b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b67:	c9                   	leaveq 
  804b68:	c3                   	retq   

0000000000804b69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804b69:	55                   	push   %rbp
  804b6a:	48 89 e5             	mov    %rsp,%rbp
  804b6d:	48 83 ec 10          	sub    $0x10,%rsp
  804b71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804b75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b79:	48 89 c6             	mov    %rax,%rsi
  804b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  804b81:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  804b88:	00 00 00 
  804b8b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804b8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b91:	48 89 c7             	mov    %rax,%rdi
  804b94:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  804b9b:	00 00 00 
  804b9e:	ff d0                	callq  *%rax
  804ba0:	48 89 c6             	mov    %rax,%rsi
  804ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  804ba8:	48 b8 04 1f 80 00 00 	movabs $0x801f04,%rax
  804baf:	00 00 00 
  804bb2:	ff d0                	callq  *%rax
}
  804bb4:	c9                   	leaveq 
  804bb5:	c3                   	retq   

0000000000804bb6 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804bb6:	55                   	push   %rbp
  804bb7:	48 89 e5             	mov    %rsp,%rbp
  804bba:	48 83 ec 20          	sub    $0x20,%rsp
  804bbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bc5:	75 35                	jne    804bfc <wait+0x46>
  804bc7:	48 b9 fd 58 80 00 00 	movabs $0x8058fd,%rcx
  804bce:	00 00 00 
  804bd1:	48 ba 08 59 80 00 00 	movabs $0x805908,%rdx
  804bd8:	00 00 00 
  804bdb:	be 0a 00 00 00       	mov    $0xa,%esi
  804be0:	48 bf 1d 59 80 00 00 	movabs $0x80591d,%rdi
  804be7:	00 00 00 
  804bea:	b8 00 00 00 00       	mov    $0x0,%eax
  804bef:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  804bf6:	00 00 00 
  804bf9:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804bfc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bff:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c04:	48 98                	cltq   
  804c06:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804c0d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804c14:	00 00 00 
  804c17:	48 01 d0             	add    %rdx,%rax
  804c1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804c1e:	eb 0c                	jmp    804c2c <wait+0x76>
		sys_yield();
  804c20:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  804c27:	00 00 00 
  804c2a:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804c2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c30:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804c36:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c39:	75 0e                	jne    804c49 <wait+0x93>
  804c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c3f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804c45:	85 c0                	test   %eax,%eax
  804c47:	75 d7                	jne    804c20 <wait+0x6a>
		sys_yield();
}
  804c49:	90                   	nop
  804c4a:	c9                   	leaveq 
  804c4b:	c3                   	retq   

0000000000804c4c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804c4c:	55                   	push   %rbp
  804c4d:	48 89 e5             	mov    %rsp,%rbp
  804c50:	48 83 ec 30          	sub    $0x30,%rsp
  804c54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804c58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804c5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804c60:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804c65:	75 0e                	jne    804c75 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804c67:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804c6e:	00 00 00 
  804c71:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804c75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c79:	48 89 c7             	mov    %rax,%rdi
  804c7c:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  804c83:	00 00 00 
  804c86:	ff d0                	callq  *%rax
  804c88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c8f:	79 27                	jns    804cb8 <ipc_recv+0x6c>
		if (from_env_store)
  804c91:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804c96:	74 0a                	je     804ca2 <ipc_recv+0x56>
			*from_env_store = 0;
  804c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c9c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804ca2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ca7:	74 0a                	je     804cb3 <ipc_recv+0x67>
			*perm_store = 0;
  804ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804cad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cb6:	eb 53                	jmp    804d0b <ipc_recv+0xbf>
	}
	if (from_env_store)
  804cb8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804cbd:	74 19                	je     804cd8 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804cbf:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804cc6:	00 00 00 
  804cc9:	48 8b 00             	mov    (%rax),%rax
  804ccc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804cd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cd6:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804cd8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804cdd:	74 19                	je     804cf8 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804cdf:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804ce6:	00 00 00 
  804ce9:	48 8b 00             	mov    (%rax),%rax
  804cec:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804cf2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804cf6:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804cf8:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804cff:	00 00 00 
  804d02:	48 8b 00             	mov    (%rax),%rax
  804d05:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804d0b:	c9                   	leaveq 
  804d0c:	c3                   	retq   

0000000000804d0d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d0d:	55                   	push   %rbp
  804d0e:	48 89 e5             	mov    %rsp,%rbp
  804d11:	48 83 ec 30          	sub    $0x30,%rsp
  804d15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804d18:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804d1b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804d1f:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804d22:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d27:	75 1c                	jne    804d45 <ipc_send+0x38>
		pg = (void*) UTOP;
  804d29:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d30:	00 00 00 
  804d33:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804d37:	eb 0c                	jmp    804d45 <ipc_send+0x38>
		sys_yield();
  804d39:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  804d40:	00 00 00 
  804d43:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804d45:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804d48:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804d4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804d4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d52:	89 c7                	mov    %eax,%edi
  804d54:	48 b8 35 20 80 00 00 	movabs $0x802035,%rax
  804d5b:	00 00 00 
  804d5e:	ff d0                	callq  *%rax
  804d60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d63:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804d67:	74 d0                	je     804d39 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804d69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d6d:	79 30                	jns    804d9f <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d72:	89 c1                	mov    %eax,%ecx
  804d74:	48 ba 28 59 80 00 00 	movabs $0x805928,%rdx
  804d7b:	00 00 00 
  804d7e:	be 47 00 00 00       	mov    $0x47,%esi
  804d83:	48 bf 3e 59 80 00 00 	movabs $0x80593e,%rdi
  804d8a:	00 00 00 
  804d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  804d92:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  804d99:	00 00 00 
  804d9c:	41 ff d0             	callq  *%r8

}
  804d9f:	90                   	nop
  804da0:	c9                   	leaveq 
  804da1:	c3                   	retq   

0000000000804da2 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804da2:	55                   	push   %rbp
  804da3:	48 89 e5             	mov    %rsp,%rbp
  804da6:	53                   	push   %rbx
  804da7:	48 83 ec 28          	sub    $0x28,%rsp
  804dab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804daf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804db6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804dbd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804dc2:	75 0e                	jne    804dd2 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804dc4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804dcb:	00 00 00 
  804dce:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804dd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dd6:	ba 07 00 00 00       	mov    $0x7,%edx
  804ddb:	48 89 c6             	mov    %rax,%rsi
  804dde:	bf 00 00 00 00       	mov    $0x0,%edi
  804de3:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  804dea:	00 00 00 
  804ded:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804def:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804df3:	48 c1 e8 0c          	shr    $0xc,%rax
  804df7:	48 89 c2             	mov    %rax,%rdx
  804dfa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804e01:	01 00 00 
  804e04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e08:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804e0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804e12:	b8 03 00 00 00       	mov    $0x3,%eax
  804e17:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804e1b:	48 89 d3             	mov    %rdx,%rbx
  804e1e:	0f 01 c1             	vmcall 
  804e21:	89 f2                	mov    %esi,%edx
  804e23:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e26:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804e29:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e2d:	79 05                	jns    804e34 <ipc_host_recv+0x92>
		return r;
  804e2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e32:	eb 03                	jmp    804e37 <ipc_host_recv+0x95>
	}
	return val;
  804e34:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804e37:	48 83 c4 28          	add    $0x28,%rsp
  804e3b:	5b                   	pop    %rbx
  804e3c:	5d                   	pop    %rbp
  804e3d:	c3                   	retq   

0000000000804e3e <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804e3e:	55                   	push   %rbp
  804e3f:	48 89 e5             	mov    %rsp,%rbp
  804e42:	53                   	push   %rbx
  804e43:	48 83 ec 38          	sub    $0x38,%rsp
  804e47:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804e4a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804e4d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804e51:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804e54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804e5b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804e60:	75 0e                	jne    804e70 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804e62:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e69:	00 00 00 
  804e6c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804e70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e74:	48 c1 e8 0c          	shr    $0xc,%rax
  804e78:	48 89 c2             	mov    %rax,%rdx
  804e7b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804e82:	01 00 00 
  804e85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e89:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804e8f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804e93:	b8 02 00 00 00       	mov    $0x2,%eax
  804e98:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804e9b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804e9e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804ea2:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804ea5:	89 fb                	mov    %edi,%ebx
  804ea7:	0f 01 c1             	vmcall 
  804eaa:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804ead:	eb 26                	jmp    804ed5 <ipc_host_send+0x97>
		sys_yield();
  804eaf:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  804eb6:	00 00 00 
  804eb9:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804ebb:	b8 02 00 00 00       	mov    $0x2,%eax
  804ec0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804ec3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804ec6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804eca:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804ecd:	89 fb                	mov    %edi,%ebx
  804ecf:	0f 01 c1             	vmcall 
  804ed2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804ed5:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804ed9:	74 d4                	je     804eaf <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804edb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804edf:	79 30                	jns    804f11 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804ee1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ee4:	89 c1                	mov    %eax,%ecx
  804ee6:	48 ba 28 59 80 00 00 	movabs $0x805928,%rdx
  804eed:	00 00 00 
  804ef0:	be 79 00 00 00       	mov    $0x79,%esi
  804ef5:	48 bf 3e 59 80 00 00 	movabs $0x80593e,%rdi
  804efc:	00 00 00 
  804eff:	b8 00 00 00 00       	mov    $0x0,%eax
  804f04:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  804f0b:	00 00 00 
  804f0e:	41 ff d0             	callq  *%r8

}
  804f11:	90                   	nop
  804f12:	48 83 c4 38          	add    $0x38,%rsp
  804f16:	5b                   	pop    %rbx
  804f17:	5d                   	pop    %rbp
  804f18:	c3                   	retq   

0000000000804f19 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804f19:	55                   	push   %rbp
  804f1a:	48 89 e5             	mov    %rsp,%rbp
  804f1d:	48 83 ec 18          	sub    $0x18,%rsp
  804f21:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f2b:	eb 4d                	jmp    804f7a <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804f2d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804f34:	00 00 00 
  804f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f3a:	48 98                	cltq   
  804f3c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804f43:	48 01 d0             	add    %rdx,%rax
  804f46:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804f4c:	8b 00                	mov    (%rax),%eax
  804f4e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804f51:	75 23                	jne    804f76 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804f53:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804f5a:	00 00 00 
  804f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f60:	48 98                	cltq   
  804f62:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804f69:	48 01 d0             	add    %rdx,%rax
  804f6c:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804f72:	8b 00                	mov    (%rax),%eax
  804f74:	eb 12                	jmp    804f88 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804f76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f7a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804f81:	7e aa                	jle    804f2d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f88:	c9                   	leaveq 
  804f89:	c3                   	retq   

0000000000804f8a <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804f8a:	55                   	push   %rbp
  804f8b:	48 89 e5             	mov    %rsp,%rbp
  804f8e:	48 83 ec 18          	sub    $0x18,%rsp
  804f92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f9a:	48 c1 e8 15          	shr    $0x15,%rax
  804f9e:	48 89 c2             	mov    %rax,%rdx
  804fa1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804fa8:	01 00 00 
  804fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804faf:	83 e0 01             	and    $0x1,%eax
  804fb2:	48 85 c0             	test   %rax,%rax
  804fb5:	75 07                	jne    804fbe <pageref+0x34>
		return 0;
  804fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  804fbc:	eb 56                	jmp    805014 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804fc2:	48 c1 e8 0c          	shr    $0xc,%rax
  804fc6:	48 89 c2             	mov    %rax,%rdx
  804fc9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804fd0:	01 00 00 
  804fd3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804fdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fdf:	83 e0 01             	and    $0x1,%eax
  804fe2:	48 85 c0             	test   %rax,%rax
  804fe5:	75 07                	jne    804fee <pageref+0x64>
		return 0;
  804fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  804fec:	eb 26                	jmp    805014 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ff2:	48 c1 e8 0c          	shr    $0xc,%rax
  804ff6:	48 89 c2             	mov    %rax,%rdx
  804ff9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805000:	00 00 00 
  805003:	48 c1 e2 04          	shl    $0x4,%rdx
  805007:	48 01 d0             	add    %rdx,%rax
  80500a:	48 83 c0 08          	add    $0x8,%rax
  80500e:	0f b7 00             	movzwl (%rax),%eax
  805011:	0f b7 c0             	movzwl %ax,%eax
}
  805014:	c9                   	leaveq 
  805015:	c3                   	retq   
