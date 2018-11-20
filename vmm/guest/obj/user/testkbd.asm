
vmm/guest/obj/user/testkbd:     file format elf64-x86-64


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
  80003c:	e8 29 04 00 00       	callq  80046a <libmain>
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
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 7a 02 80 00 00 	movabs $0x80027a,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  8000a3:	00 00 00 
  8000a6:	be 10 00 00 00       	mov    $0x10,%esi
  8000ab:	48 bf 4d 46 80 00 00 	movabs $0x80464d,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 5c 46 80 00 00 	movabs $0x80465c,%rdx
  8000d9:	00 00 00 
  8000dc:	be 12 00 00 00       	mov    $0x12,%esi
  8000e1:	48 bf 4d 46 80 00 00 	movabs $0x80464d,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 de 24 80 00 00 	movabs $0x8024de,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba 76 46 80 00 00 	movabs $0x804676,%rdx
  800128:	00 00 00 
  80012b:	be 14 00 00 00       	mov    $0x14,%esi
  800130:	48 bf 4d 46 80 00 00 	movabs $0x80464d,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf 7e 46 80 00 00 	movabs $0x80467e,%rdi
  800153:	00 00 00 
  800156:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be 8c 46 80 00 00 	movabs $0x80468c,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 37 33 80 00 00 	movabs $0x803337,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
  800194:	eb b6                	jmp    80014c <umain+0x109>
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be 90 46 80 00 00 	movabs $0x804690,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 37 33 80 00 00 	movabs $0x803337,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 28 1c 80 00 00 	movabs $0x801c28,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	90                   	nop
  8001e2:	c9                   	leaveq 
  8001e3:	c3                   	retq   

00000000008001e4 <getchar>:

int
getchar(void)
{
  8001e4:	55                   	push   %rbp
  8001e5:	48 89 e5             	mov    %rsp,%rbp
  8001e8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001ec:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001f0:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f5:	48 89 c6             	mov    %rax,%rsi
  8001f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fd:	48 b8 87 26 80 00 00 	movabs $0x802687,%rax
  800204:	00 00 00 
  800207:	ff d0                	callq  *%rax
  800209:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800210:	79 05                	jns    800217 <getchar+0x33>
		return r;
  800212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800215:	eb 14                	jmp    80022b <getchar+0x47>
	if (r < 1)
  800217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021b:	7f 07                	jg     800224 <getchar+0x40>
		return -E_EOF;
  80021d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800222:	eb 07                	jmp    80022b <getchar+0x47>
	return c;
  800224:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800228:	0f b6 c0             	movzbl %al,%eax

}
  80022b:	c9                   	leaveq 
  80022c:	c3                   	retq   

000000000080022d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022d:	55                   	push   %rbp
  80022e:	48 89 e5             	mov    %rsp,%rbp
  800231:	48 83 ec 20          	sub    $0x20,%rsp
  800235:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800238:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	48 89 d6             	mov    %rdx,%rsi
  800242:	89 c7                	mov    %eax,%edi
  800244:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
  800250:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800253:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800257:	79 05                	jns    80025e <iscons+0x31>
		return r;
  800259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025c:	eb 1a                	jmp    800278 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800262:	8b 10                	mov    (%rax),%edx
  800264:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026b:	00 00 00 
  80026e:	8b 00                	mov    (%rax),%eax
  800270:	39 c2                	cmp    %eax,%edx
  800272:	0f 94 c0             	sete   %al
  800275:	0f b6 c0             	movzbl %al,%eax
}
  800278:	c9                   	leaveq 
  800279:	c3                   	retq   

000000000080027a <opencons>:

int
opencons(void)
{
  80027a:	55                   	push   %rbp
  80027b:	48 89 e5             	mov    %rsp,%rbp
  80027e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800282:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800286:	48 89 c7             	mov    %rax,%rdi
  800289:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  800290:	00 00 00 
  800293:	ff d0                	callq  *%rax
  800295:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800298:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029c:	79 05                	jns    8002a3 <opencons+0x29>
		return r;
  80029e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a1:	eb 5b                	jmp    8002fe <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a7:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ac:	48 89 c6             	mov    %rax,%rsi
  8002af:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b4:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <opencons+0x54>
		return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 30                	jmp    8002fe <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d2:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002d9:	00 00 00 
  8002dc:	8b 12                	mov    (%rdx),%edx
  8002de:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ef:	48 89 c7             	mov    %rax,%rdi
  8002f2:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8002f9:	00 00 00 
  8002fc:	ff d0                	callq  *%rax
}
  8002fe:	c9                   	leaveq 
  8002ff:	c3                   	retq   

0000000000800300 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800300:	55                   	push   %rbp
  800301:	48 89 e5             	mov    %rsp,%rbp
  800304:	48 83 ec 30          	sub    $0x30,%rsp
  800308:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800310:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800314:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800319:	75 13                	jne    80032e <devcons_read+0x2e>
		return 0;
  80031b:	b8 00 00 00 00       	mov    $0x0,%eax
  800320:	eb 49                	jmp    80036b <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800322:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  800329:	00 00 00 
  80032c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032e:	48 b8 75 1c 80 00 00 	movabs $0x801c75,%rax
  800335:	00 00 00 
  800338:	ff d0                	callq  *%rax
  80033a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800341:	74 df                	je     800322 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  800343:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800347:	79 05                	jns    80034e <devcons_read+0x4e>
		return c;
  800349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034c:	eb 1d                	jmp    80036b <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80034e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800352:	75 07                	jne    80035b <devcons_read+0x5b>
		return 0;
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	eb 10                	jmp    80036b <devcons_read+0x6b>
	*(char*)vbuf = c;
  80035b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035e:	89 c2                	mov    %eax,%edx
  800360:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800364:	88 10                	mov    %dl,(%rax)
	return 1;
  800366:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036b:	c9                   	leaveq 
  80036c:	c3                   	retq   

000000000080036d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036d:	55                   	push   %rbp
  80036e:	48 89 e5             	mov    %rsp,%rbp
  800371:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800378:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80037f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800386:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800394:	eb 76                	jmp    80040c <devcons_write+0x9f>
		m = n - tot;
  800396:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039d:	89 c2                	mov    %eax,%edx
  80039f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a2:	29 c2                	sub    %eax,%edx
  8003a4:	89 d0                	mov    %edx,%eax
  8003a6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ac:	83 f8 7f             	cmp    $0x7f,%eax
  8003af:	76 07                	jbe    8003b8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bb:	48 63 d0             	movslq %eax,%rdx
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	48 63 c8             	movslq %eax,%rcx
  8003c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cb:	48 01 c1             	add    %rax,%rcx
  8003ce:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d5:	48 89 ce             	mov    %rcx,%rsi
  8003d8:	48 89 c7             	mov    %rax,%rdi
  8003db:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ea:	48 63 d0             	movslq %eax,%rdx
  8003ed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f4:	48 89 d6             	mov    %rdx,%rsi
  8003f7:	48 89 c7             	mov    %rax,%rdi
  8003fa:	48 b8 28 1c 80 00 00 	movabs $0x801c28,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800409:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040f:	48 98                	cltq   
  800411:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800418:	0f 82 78 ff ff ff    	jb     800396 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800421:	c9                   	leaveq 
  800422:	c3                   	retq   

0000000000800423 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800423:	55                   	push   %rbp
  800424:	48 89 e5             	mov    %rsp,%rbp
  800427:	48 83 ec 08          	sub    $0x8,%rsp
  80042b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80042f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800434:	c9                   	leaveq 
  800435:	c3                   	retq   

0000000000800436 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800436:	55                   	push   %rbp
  800437:	48 89 e5             	mov    %rsp,%rbp
  80043a:	48 83 ec 10          	sub    $0x10,%rsp
  80043e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800442:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044a:	48 be ad 46 80 00 00 	movabs $0x8046ad,%rsi
  800451:	00 00 00 
  800454:	48 89 c7             	mov    %rax,%rdi
  800457:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  80045e:	00 00 00 
  800461:	ff d0                	callq  *%rax
	return 0;
  800463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800468:	c9                   	leaveq 
  800469:	c3                   	retq   

000000000080046a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046a:	55                   	push   %rbp
  80046b:	48 89 e5             	mov    %rsp,%rbp
  80046e:	48 83 ec 10          	sub    $0x10,%rsp
  800472:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800475:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800479:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  800480:	00 00 00 
  800483:	ff d0                	callq  *%rax
  800485:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048a:	48 98                	cltq   
  80048c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800493:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80049a:	00 00 00 
  80049d:	48 01 c2             	add    %rax,%rdx
  8004a0:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8004a7:	00 00 00 
  8004aa:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004b1:	7e 14                	jle    8004c7 <libmain+0x5d>
		binaryname = argv[0];
  8004b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b7:	48 8b 10             	mov    (%rax),%rdx
  8004ba:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004c1:	00 00 00 
  8004c4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ce:	48 89 d6             	mov    %rdx,%rsi
  8004d1:	89 c7                	mov    %eax,%edi
  8004d3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004df:	48 b8 ee 04 80 00 00 	movabs $0x8004ee,%rax
  8004e6:	00 00 00 
  8004e9:	ff d0                	callq  *%rax
}
  8004eb:	90                   	nop
  8004ec:	c9                   	leaveq 
  8004ed:	c3                   	retq   

00000000008004ee <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004ee:	55                   	push   %rbp
  8004ef:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8004f2:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8004fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800503:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax
}
  80050f:	90                   	nop
  800510:	5d                   	pop    %rbp
  800511:	c3                   	retq   

0000000000800512 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800512:	55                   	push   %rbp
  800513:	48 89 e5             	mov    %rsp,%rbp
  800516:	53                   	push   %rbx
  800517:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800525:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80052b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800532:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800539:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800540:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800547:	84 c0                	test   %al,%al
  800549:	74 23                	je     80056e <_panic+0x5c>
  80054b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800552:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800556:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80055e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800562:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800566:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800575:	00 00 00 
  800578:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80057f:	00 00 00 
  800582:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800586:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80058d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800594:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80059b:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005a2:	00 00 00 
  8005a5:	48 8b 18             	mov    (%rax),%rbx
  8005a8:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax
  8005b4:	89 c6                	mov    %eax,%esi
  8005b6:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005bc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005c3:	41 89 d0             	mov    %edx,%r8d
  8005c6:	48 89 c1             	mov    %rax,%rcx
  8005c9:	48 89 da             	mov    %rbx,%rdx
  8005cc:	48 bf c0 46 80 00 00 	movabs $0x8046c0,%rdi
  8005d3:	00 00 00 
  8005d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005db:	49 b9 4c 07 80 00 00 	movabs $0x80074c,%r9
  8005e2:	00 00 00 
  8005e5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f6:	48 89 d6             	mov    %rdx,%rsi
  8005f9:	48 89 c7             	mov    %rax,%rdi
  8005fc:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800603:	00 00 00 
  800606:	ff d0                	callq  *%rax
	cprintf("\n");
  800608:	48 bf e3 46 80 00 00 	movabs $0x8046e3,%rdi
  80060f:	00 00 00 
  800612:	b8 00 00 00 00       	mov    $0x0,%eax
  800617:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  80061e:	00 00 00 
  800621:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800623:	cc                   	int3   
  800624:	eb fd                	jmp    800623 <_panic+0x111>

0000000000800626 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800626:	55                   	push   %rbp
  800627:	48 89 e5             	mov    %rsp,%rbp
  80062a:	48 83 ec 10          	sub    $0x10,%rsp
  80062e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800631:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	8d 48 01             	lea    0x1(%rax),%ecx
  80063e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800642:	89 0a                	mov    %ecx,(%rdx)
  800644:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800647:	89 d1                	mov    %edx,%ecx
  800649:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064d:	48 98                	cltq   
  80064f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800657:	8b 00                	mov    (%rax),%eax
  800659:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065e:	75 2c                	jne    80068c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	48 98                	cltq   
  800668:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066c:	48 83 c2 08          	add    $0x8,%rdx
  800670:	48 89 c6             	mov    %rax,%rsi
  800673:	48 89 d7             	mov    %rdx,%rdi
  800676:	48 b8 28 1c 80 00 00 	movabs $0x801c28,%rax
  80067d:	00 00 00 
  800680:	ff d0                	callq  *%rax
        b->idx = 0;
  800682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800686:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80068c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800690:	8b 40 04             	mov    0x4(%rax),%eax
  800693:	8d 50 01             	lea    0x1(%rax),%edx
  800696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80069d:	90                   	nop
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006ab:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c7:	48 8b 0a             	mov    (%rdx),%rcx
  8006ca:	48 89 08             	mov    %rcx,(%rax)
  8006cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e4:	00 00 00 
    b.cnt = 0;
  8006e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006ee:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006f1:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f8:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006ff:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800706:	48 89 c6             	mov    %rax,%rsi
  800709:	48 bf 26 06 80 00 00 	movabs $0x800626,%rdi
  800710:	00 00 00 
  800713:	48 b8 ea 0a 80 00 00 	movabs $0x800aea,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80071f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800725:	48 98                	cltq   
  800727:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072e:	48 83 c2 08          	add    $0x8,%rdx
  800732:	48 89 c6             	mov    %rax,%rsi
  800735:	48 89 d7             	mov    %rdx,%rdi
  800738:	48 b8 28 1c 80 00 00 	movabs $0x801c28,%rax
  80073f:	00 00 00 
  800742:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800744:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80074a:	c9                   	leaveq 
  80074b:	c3                   	retq   

000000000080074c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80074c:	55                   	push   %rbp
  80074d:	48 89 e5             	mov    %rsp,%rbp
  800750:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800757:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80075e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800765:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80076c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800773:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80077a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800781:	84 c0                	test   %al,%al
  800783:	74 20                	je     8007a5 <cprintf+0x59>
  800785:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800789:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80078d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800791:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800795:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800799:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80079d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007a5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007ac:	00 00 00 
  8007af:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b6:	00 00 00 
  8007b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007bd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007cb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e0:	48 8b 0a             	mov    (%rdx),%rcx
  8007e3:	48 89 08             	mov    %rcx,(%rax)
  8007e6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ea:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ee:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007f6:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007fd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800804:	48 89 d6             	mov    %rdx,%rsi
  800807:	48 89 c7             	mov    %rax,%rdi
  80080a:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800811:	00 00 00 
  800814:	ff d0                	callq  *%rax
  800816:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80081c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800822:	c9                   	leaveq 
  800823:	c3                   	retq   

0000000000800824 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800824:	55                   	push   %rbp
  800825:	48 89 e5             	mov    %rsp,%rbp
  800828:	48 83 ec 30          	sub    $0x30,%rsp
  80082c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800830:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800834:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800838:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80083b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80083f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800843:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800846:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80084a:	77 54                	ja     8008a0 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80084f:	8d 78 ff             	lea    -0x1(%rax),%edi
  800852:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	48 f7 f6             	div    %rsi
  800861:	49 89 c2             	mov    %rax,%r10
  800864:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800867:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80086a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80086e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800872:	41 89 c9             	mov    %ecx,%r9d
  800875:	41 89 f8             	mov    %edi,%r8d
  800878:	89 d1                	mov    %edx,%ecx
  80087a:	4c 89 d2             	mov    %r10,%rdx
  80087d:	48 89 c7             	mov    %rax,%rdi
  800880:	48 b8 24 08 80 00 00 	movabs $0x800824,%rax
  800887:	00 00 00 
  80088a:	ff d0                	callq  *%rax
  80088c:	eb 1c                	jmp    8008aa <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800892:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800895:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800899:	48 89 ce             	mov    %rcx,%rsi
  80089c:	89 d7                	mov    %edx,%edi
  80089e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a0:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008a8:	7f e4                	jg     80088e <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008aa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	48 f7 f1             	div    %rcx
  8008b9:	48 b8 f0 48 80 00 00 	movabs $0x8048f0,%rax
  8008c0:	00 00 00 
  8008c3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008c7:	0f be d0             	movsbl %al,%edx
  8008ca:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008d2:	48 89 ce             	mov    %rcx,%rsi
  8008d5:	89 d7                	mov    %edx,%edi
  8008d7:	ff d0                	callq  *%rax
}
  8008d9:	90                   	nop
  8008da:	c9                   	leaveq 
  8008db:	c3                   	retq   

00000000008008dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	48 83 ec 20          	sub    $0x20,%rsp
  8008e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ef:	7e 4f                	jle    800940 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f5:	8b 00                	mov    (%rax),%eax
  8008f7:	83 f8 30             	cmp    $0x30,%eax
  8008fa:	73 24                	jae    800920 <getuint+0x44>
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	8b 00                	mov    (%rax),%eax
  80090a:	89 c0                	mov    %eax,%eax
  80090c:	48 01 d0             	add    %rdx,%rax
  80090f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800913:	8b 12                	mov    (%rdx),%edx
  800915:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091c:	89 0a                	mov    %ecx,(%rdx)
  80091e:	eb 14                	jmp    800934 <getuint+0x58>
  800920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800924:	48 8b 40 08          	mov    0x8(%rax),%rax
  800928:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80092c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800930:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800934:	48 8b 00             	mov    (%rax),%rax
  800937:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093b:	e9 9d 00 00 00       	jmpq   8009dd <getuint+0x101>
	else if (lflag)
  800940:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800944:	74 4c                	je     800992 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094a:	8b 00                	mov    (%rax),%eax
  80094c:	83 f8 30             	cmp    $0x30,%eax
  80094f:	73 24                	jae    800975 <getuint+0x99>
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	8b 00                	mov    (%rax),%eax
  80095f:	89 c0                	mov    %eax,%eax
  800961:	48 01 d0             	add    %rdx,%rax
  800964:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800968:	8b 12                	mov    (%rdx),%edx
  80096a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800971:	89 0a                	mov    %ecx,(%rdx)
  800973:	eb 14                	jmp    800989 <getuint+0xad>
  800975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800979:	48 8b 40 08          	mov    0x8(%rax),%rax
  80097d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800981:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800985:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800989:	48 8b 00             	mov    (%rax),%rax
  80098c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800990:	eb 4b                	jmp    8009dd <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800996:	8b 00                	mov    (%rax),%eax
  800998:	83 f8 30             	cmp    $0x30,%eax
  80099b:	73 24                	jae    8009c1 <getuint+0xe5>
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a9:	8b 00                	mov    (%rax),%eax
  8009ab:	89 c0                	mov    %eax,%eax
  8009ad:	48 01 d0             	add    %rdx,%rax
  8009b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b4:	8b 12                	mov    (%rdx),%edx
  8009b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bd:	89 0a                	mov    %ecx,(%rdx)
  8009bf:	eb 14                	jmp    8009d5 <getuint+0xf9>
  8009c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d5:	8b 00                	mov    (%rax),%eax
  8009d7:	89 c0                	mov    %eax,%eax
  8009d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e1:	c9                   	leaveq 
  8009e2:	c3                   	retq   

00000000008009e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e3:	55                   	push   %rbp
  8009e4:	48 89 e5             	mov    %rsp,%rbp
  8009e7:	48 83 ec 20          	sub    $0x20,%rsp
  8009eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009f6:	7e 4f                	jle    800a47 <getint+0x64>
		x=va_arg(*ap, long long);
  8009f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fc:	8b 00                	mov    (%rax),%eax
  8009fe:	83 f8 30             	cmp    $0x30,%eax
  800a01:	73 24                	jae    800a27 <getint+0x44>
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0f:	8b 00                	mov    (%rax),%eax
  800a11:	89 c0                	mov    %eax,%eax
  800a13:	48 01 d0             	add    %rdx,%rax
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	8b 12                	mov    (%rdx),%edx
  800a1c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a23:	89 0a                	mov    %ecx,(%rdx)
  800a25:	eb 14                	jmp    800a3b <getint+0x58>
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a2f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a37:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a3b:	48 8b 00             	mov    (%rax),%rax
  800a3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a42:	e9 9d 00 00 00       	jmpq   800ae4 <getint+0x101>
	else if (lflag)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a4b:	74 4c                	je     800a99 <getint+0xb6>
		x=va_arg(*ap, long);
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a51:	8b 00                	mov    (%rax),%eax
  800a53:	83 f8 30             	cmp    $0x30,%eax
  800a56:	73 24                	jae    800a7c <getint+0x99>
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a64:	8b 00                	mov    (%rax),%eax
  800a66:	89 c0                	mov    %eax,%eax
  800a68:	48 01 d0             	add    %rdx,%rax
  800a6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6f:	8b 12                	mov    (%rdx),%edx
  800a71:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a78:	89 0a                	mov    %ecx,(%rdx)
  800a7a:	eb 14                	jmp    800a90 <getint+0xad>
  800a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a80:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a84:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a90:	48 8b 00             	mov    (%rax),%rax
  800a93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a97:	eb 4b                	jmp    800ae4 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9d:	8b 00                	mov    (%rax),%eax
  800a9f:	83 f8 30             	cmp    $0x30,%eax
  800aa2:	73 24                	jae    800ac8 <getint+0xe5>
  800aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab0:	8b 00                	mov    (%rax),%eax
  800ab2:	89 c0                	mov    %eax,%eax
  800ab4:	48 01 d0             	add    %rdx,%rax
  800ab7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abb:	8b 12                	mov    (%rdx),%edx
  800abd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac4:	89 0a                	mov    %ecx,(%rdx)
  800ac6:	eb 14                	jmp    800adc <getint+0xf9>
  800ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acc:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ad0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ad4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800adc:	8b 00                	mov    (%rax),%eax
  800ade:	48 98                	cltq   
  800ae0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ae4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ae8:	c9                   	leaveq 
  800ae9:	c3                   	retq   

0000000000800aea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aea:	55                   	push   %rbp
  800aeb:	48 89 e5             	mov    %rsp,%rbp
  800aee:	41 54                	push   %r12
  800af0:	53                   	push   %rbx
  800af1:	48 83 ec 60          	sub    $0x60,%rsp
  800af5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800af9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800afd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b01:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b09:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b0d:	48 8b 0a             	mov    (%rdx),%rcx
  800b10:	48 89 08             	mov    %rcx,(%rax)
  800b13:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b17:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b1b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b1f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b23:	eb 17                	jmp    800b3c <vprintfmt+0x52>
			if (ch == '\0')
  800b25:	85 db                	test   %ebx,%ebx
  800b27:	0f 84 b9 04 00 00    	je     800fe6 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	89 df                	mov    %ebx,%edi
  800b3a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b40:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b44:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b48:	0f b6 00             	movzbl (%rax),%eax
  800b4b:	0f b6 d8             	movzbl %al,%ebx
  800b4e:	83 fb 25             	cmp    $0x25,%ebx
  800b51:	75 d2                	jne    800b25 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b53:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b57:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b5e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b6c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b73:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b7b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b7f:	0f b6 00             	movzbl (%rax),%eax
  800b82:	0f b6 d8             	movzbl %al,%ebx
  800b85:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b88:	83 f8 55             	cmp    $0x55,%eax
  800b8b:	0f 87 22 04 00 00    	ja     800fb3 <vprintfmt+0x4c9>
  800b91:	89 c0                	mov    %eax,%eax
  800b93:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b9a:	00 
  800b9b:	48 b8 18 49 80 00 00 	movabs $0x804918,%rax
  800ba2:	00 00 00 
  800ba5:	48 01 d0             	add    %rdx,%rax
  800ba8:	48 8b 00             	mov    (%rax),%rax
  800bab:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bad:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bb1:	eb c0                	jmp    800b73 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bb3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bb7:	eb ba                	jmp    800b73 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bc0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bc3:	89 d0                	mov    %edx,%eax
  800bc5:	c1 e0 02             	shl    $0x2,%eax
  800bc8:	01 d0                	add    %edx,%eax
  800bca:	01 c0                	add    %eax,%eax
  800bcc:	01 d8                	add    %ebx,%eax
  800bce:	83 e8 30             	sub    $0x30,%eax
  800bd1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bd4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd8:	0f b6 00             	movzbl (%rax),%eax
  800bdb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bde:	83 fb 2f             	cmp    $0x2f,%ebx
  800be1:	7e 60                	jle    800c43 <vprintfmt+0x159>
  800be3:	83 fb 39             	cmp    $0x39,%ebx
  800be6:	7f 5b                	jg     800c43 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bed:	eb d1                	jmp    800bc0 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800bef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf2:	83 f8 30             	cmp    $0x30,%eax
  800bf5:	73 17                	jae    800c0e <vprintfmt+0x124>
  800bf7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bfb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bfe:	89 d2                	mov    %edx,%edx
  800c00:	48 01 d0             	add    %rdx,%rax
  800c03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c06:	83 c2 08             	add    $0x8,%edx
  800c09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0c:	eb 0c                	jmp    800c1a <vprintfmt+0x130>
  800c0e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c12:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1a:	8b 00                	mov    (%rax),%eax
  800c1c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c1f:	eb 23                	jmp    800c44 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c25:	0f 89 48 ff ff ff    	jns    800b73 <vprintfmt+0x89>
				width = 0;
  800c2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c32:	e9 3c ff ff ff       	jmpq   800b73 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c37:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c3e:	e9 30 ff ff ff       	jmpq   800b73 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c43:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c44:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c48:	0f 89 25 ff ff ff    	jns    800b73 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c4e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c51:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c54:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c5b:	e9 13 ff ff ff       	jmpq   800b73 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c60:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c64:	e9 0a ff ff ff       	jmpq   800b73 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6c:	83 f8 30             	cmp    $0x30,%eax
  800c6f:	73 17                	jae    800c88 <vprintfmt+0x19e>
  800c71:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c78:	89 d2                	mov    %edx,%edx
  800c7a:	48 01 d0             	add    %rdx,%rax
  800c7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c80:	83 c2 08             	add    $0x8,%edx
  800c83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c86:	eb 0c                	jmp    800c94 <vprintfmt+0x1aa>
  800c88:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c8c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c90:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c94:	8b 10                	mov    (%rax),%edx
  800c96:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9e:	48 89 ce             	mov    %rcx,%rsi
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	ff d0                	callq  *%rax
			break;
  800ca5:	e9 37 03 00 00       	jmpq   800fe1 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800caa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cad:	83 f8 30             	cmp    $0x30,%eax
  800cb0:	73 17                	jae    800cc9 <vprintfmt+0x1df>
  800cb2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb9:	89 d2                	mov    %edx,%edx
  800cbb:	48 01 d0             	add    %rdx,%rax
  800cbe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc1:	83 c2 08             	add    $0x8,%edx
  800cc4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc7:	eb 0c                	jmp    800cd5 <vprintfmt+0x1eb>
  800cc9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ccd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cd1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cd7:	85 db                	test   %ebx,%ebx
  800cd9:	79 02                	jns    800cdd <vprintfmt+0x1f3>
				err = -err;
  800cdb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cdd:	83 fb 15             	cmp    $0x15,%ebx
  800ce0:	7f 16                	jg     800cf8 <vprintfmt+0x20e>
  800ce2:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  800ce9:	00 00 00 
  800cec:	48 63 d3             	movslq %ebx,%rdx
  800cef:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cf3:	4d 85 e4             	test   %r12,%r12
  800cf6:	75 2e                	jne    800d26 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cf8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d00:	89 d9                	mov    %ebx,%ecx
  800d02:	48 ba 01 49 80 00 00 	movabs $0x804901,%rdx
  800d09:	00 00 00 
  800d0c:	48 89 c7             	mov    %rax,%rdi
  800d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d14:	49 b8 f0 0f 80 00 00 	movabs $0x800ff0,%r8
  800d1b:	00 00 00 
  800d1e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d21:	e9 bb 02 00 00       	jmpq   800fe1 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d26:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2e:	4c 89 e1             	mov    %r12,%rcx
  800d31:	48 ba 0a 49 80 00 00 	movabs $0x80490a,%rdx
  800d38:	00 00 00 
  800d3b:	48 89 c7             	mov    %rax,%rdi
  800d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d43:	49 b8 f0 0f 80 00 00 	movabs $0x800ff0,%r8
  800d4a:	00 00 00 
  800d4d:	41 ff d0             	callq  *%r8
			break;
  800d50:	e9 8c 02 00 00       	jmpq   800fe1 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d58:	83 f8 30             	cmp    $0x30,%eax
  800d5b:	73 17                	jae    800d74 <vprintfmt+0x28a>
  800d5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d61:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d64:	89 d2                	mov    %edx,%edx
  800d66:	48 01 d0             	add    %rdx,%rax
  800d69:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6c:	83 c2 08             	add    $0x8,%edx
  800d6f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d72:	eb 0c                	jmp    800d80 <vprintfmt+0x296>
  800d74:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d78:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d80:	4c 8b 20             	mov    (%rax),%r12
  800d83:	4d 85 e4             	test   %r12,%r12
  800d86:	75 0a                	jne    800d92 <vprintfmt+0x2a8>
				p = "(null)";
  800d88:	49 bc 0d 49 80 00 00 	movabs $0x80490d,%r12
  800d8f:	00 00 00 
			if (width > 0 && padc != '-')
  800d92:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d96:	7e 78                	jle    800e10 <vprintfmt+0x326>
  800d98:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d9c:	74 72                	je     800e10 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800da1:	48 98                	cltq   
  800da3:	48 89 c6             	mov    %rax,%rsi
  800da6:	4c 89 e7             	mov    %r12,%rdi
  800da9:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  800db0:	00 00 00 
  800db3:	ff d0                	callq  *%rax
  800db5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800db8:	eb 17                	jmp    800dd1 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dba:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dbe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	48 89 ce             	mov    %rcx,%rsi
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dcd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd5:	7f e3                	jg     800dba <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd7:	eb 37                	jmp    800e10 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dd9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ddd:	74 1e                	je     800dfd <vprintfmt+0x313>
  800ddf:	83 fb 1f             	cmp    $0x1f,%ebx
  800de2:	7e 05                	jle    800de9 <vprintfmt+0x2ff>
  800de4:	83 fb 7e             	cmp    $0x7e,%ebx
  800de7:	7e 14                	jle    800dfd <vprintfmt+0x313>
					putch('?', putdat);
  800de9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ded:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df1:	48 89 d6             	mov    %rdx,%rsi
  800df4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800df9:	ff d0                	callq  *%rax
  800dfb:	eb 0f                	jmp    800e0c <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800dfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e05:	48 89 d6             	mov    %rdx,%rsi
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e10:	4c 89 e0             	mov    %r12,%rax
  800e13:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e17:	0f b6 00             	movzbl (%rax),%eax
  800e1a:	0f be d8             	movsbl %al,%ebx
  800e1d:	85 db                	test   %ebx,%ebx
  800e1f:	74 28                	je     800e49 <vprintfmt+0x35f>
  800e21:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e25:	78 b2                	js     800dd9 <vprintfmt+0x2ef>
  800e27:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e2b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e2f:	79 a8                	jns    800dd9 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e31:	eb 16                	jmp    800e49 <vprintfmt+0x35f>
				putch(' ', putdat);
  800e33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3b:	48 89 d6             	mov    %rdx,%rsi
  800e3e:	bf 20 00 00 00       	mov    $0x20,%edi
  800e43:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e4d:	7f e4                	jg     800e33 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e4f:	e9 8d 01 00 00       	jmpq   800fe1 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e58:	be 03 00 00 00       	mov    $0x3,%esi
  800e5d:	48 89 c7             	mov    %rax,%rdi
  800e60:	48 b8 e3 09 80 00 00 	movabs $0x8009e3,%rax
  800e67:	00 00 00 
  800e6a:	ff d0                	callq  *%rax
  800e6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e74:	48 85 c0             	test   %rax,%rax
  800e77:	79 1d                	jns    800e96 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e81:	48 89 d6             	mov    %rdx,%rsi
  800e84:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e89:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8f:	48 f7 d8             	neg    %rax
  800e92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e9d:	e9 d2 00 00 00       	jmpq   800f74 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ea2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea6:	be 03 00 00 00       	mov    $0x3,%esi
  800eab:	48 89 c7             	mov    %rax,%rdi
  800eae:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800eb5:	00 00 00 
  800eb8:	ff d0                	callq  *%rax
  800eba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ebe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec5:	e9 aa 00 00 00       	jmpq   800f74 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800eca:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ece:	be 03 00 00 00       	mov    $0x3,%esi
  800ed3:	48 89 c7             	mov    %rax,%rdi
  800ed6:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800edd:	00 00 00 
  800ee0:	ff d0                	callq  *%rax
  800ee2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ee6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800eed:	e9 82 00 00 00       	jmpq   800f74 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800ef2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	48 89 d6             	mov    %rdx,%rsi
  800efd:	bf 30 00 00 00       	mov    $0x30,%edi
  800f02:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0c:	48 89 d6             	mov    %rdx,%rsi
  800f0f:	bf 78 00 00 00       	mov    $0x78,%edi
  800f14:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f19:	83 f8 30             	cmp    $0x30,%eax
  800f1c:	73 17                	jae    800f35 <vprintfmt+0x44b>
  800f1e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f22:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f25:	89 d2                	mov    %edx,%edx
  800f27:	48 01 d0             	add    %rdx,%rax
  800f2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2d:	83 c2 08             	add    $0x8,%edx
  800f30:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f33:	eb 0c                	jmp    800f41 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f35:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f39:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f3d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f41:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f48:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f4f:	eb 23                	jmp    800f74 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f51:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f55:	be 03 00 00 00       	mov    $0x3,%esi
  800f5a:	48 89 c7             	mov    %rax,%rdi
  800f5d:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800f64:	00 00 00 
  800f67:	ff d0                	callq  *%rax
  800f69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f6d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f74:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f79:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f7c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f83:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8b:	45 89 c1             	mov    %r8d,%r9d
  800f8e:	41 89 f8             	mov    %edi,%r8d
  800f91:	48 89 c7             	mov    %rax,%rdi
  800f94:	48 b8 24 08 80 00 00 	movabs $0x800824,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
			break;
  800fa0:	eb 3f                	jmp    800fe1 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800faa:	48 89 d6             	mov    %rdx,%rsi
  800fad:	89 df                	mov    %ebx,%edi
  800faf:	ff d0                	callq  *%rax
			break;
  800fb1:	eb 2e                	jmp    800fe1 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbb:	48 89 d6             	mov    %rdx,%rsi
  800fbe:	bf 25 00 00 00       	mov    $0x25,%edi
  800fc3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fca:	eb 05                	jmp    800fd1 <vprintfmt+0x4e7>
  800fcc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fd5:	48 83 e8 01          	sub    $0x1,%rax
  800fd9:	0f b6 00             	movzbl (%rax),%eax
  800fdc:	3c 25                	cmp    $0x25,%al
  800fde:	75 ec                	jne    800fcc <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fe0:	90                   	nop
		}
	}
  800fe1:	e9 3d fb ff ff       	jmpq   800b23 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fe7:	48 83 c4 60          	add    $0x60,%rsp
  800feb:	5b                   	pop    %rbx
  800fec:	41 5c                	pop    %r12
  800fee:	5d                   	pop    %rbp
  800fef:	c3                   	retq   

0000000000800ff0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ffb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801002:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801009:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801010:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801017:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801025:	84 c0                	test   %al,%al
  801027:	74 20                	je     801049 <printfmt+0x59>
  801029:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80102d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801031:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801035:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801039:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80103d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801041:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801045:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801049:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801050:	00 00 00 
  801053:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80105a:	00 00 00 
  80105d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801061:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801068:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80106f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801076:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80107d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801084:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80108b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801092:	48 89 c7             	mov    %rax,%rdi
  801095:	48 b8 ea 0a 80 00 00 	movabs $0x800aea,%rax
  80109c:	00 00 00 
  80109f:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010a1:	90                   	nop
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 83 ec 10          	sub    $0x10,%rsp
  8010ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b7:	8b 40 10             	mov    0x10(%rax),%eax
  8010ba:	8d 50 01             	lea    0x1(%rax),%edx
  8010bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c8:	48 8b 10             	mov    (%rax),%rdx
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010d3:	48 39 c2             	cmp    %rax,%rdx
  8010d6:	73 17                	jae    8010ef <sprintputch+0x4b>
		*b->buf++ = ch;
  8010d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dc:	48 8b 00             	mov    (%rax),%rax
  8010df:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010e7:	48 89 0a             	mov    %rcx,(%rdx)
  8010ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ed:	88 10                	mov    %dl,(%rax)
}
  8010ef:	90                   	nop
  8010f0:	c9                   	leaveq 
  8010f1:	c3                   	retq   

00000000008010f2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f2:	55                   	push   %rbp
  8010f3:	48 89 e5             	mov    %rsp,%rbp
  8010f6:	48 83 ec 50          	sub    $0x50,%rsp
  8010fa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010fe:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801101:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801105:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801109:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80110d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801111:	48 8b 0a             	mov    (%rdx),%rcx
  801114:	48 89 08             	mov    %rcx,(%rax)
  801117:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80111f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801123:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801127:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80112f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801132:	48 98                	cltq   
  801134:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801138:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80113c:	48 01 d0             	add    %rdx,%rax
  80113f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801143:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80114a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80114f:	74 06                	je     801157 <vsnprintf+0x65>
  801151:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801155:	7f 07                	jg     80115e <vsnprintf+0x6c>
		return -E_INVAL;
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115c:	eb 2f                	jmp    80118d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80115e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801162:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801166:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80116a:	48 89 c6             	mov    %rax,%rsi
  80116d:	48 bf a4 10 80 00 00 	movabs $0x8010a4,%rdi
  801174:	00 00 00 
  801177:	48 b8 ea 0a 80 00 00 	movabs $0x800aea,%rax
  80117e:	00 00 00 
  801181:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801183:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801187:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80118a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80119a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011a1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011a7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011ae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011b5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011bc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011c3:	84 c0                	test   %al,%al
  8011c5:	74 20                	je     8011e7 <snprintf+0x58>
  8011c7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011cb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011cf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011d3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011d7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011db:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011df:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011e3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011e7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011ee:	00 00 00 
  8011f1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011f8:	00 00 00 
  8011fb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011ff:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801206:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80120d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801214:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80121b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801222:	48 8b 0a             	mov    (%rdx),%rcx
  801225:	48 89 08             	mov    %rcx,(%rax)
  801228:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80122c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801230:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801234:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801238:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80123f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801246:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80124c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801253:	48 89 c7             	mov    %rax,%rdi
  801256:	48 b8 f2 10 80 00 00 	movabs $0x8010f2,%rax
  80125d:	00 00 00 
  801260:	ff d0                	callq  *%rax
  801262:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801268:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80126e:	c9                   	leaveq 
  80126f:	c3                   	retq   

0000000000801270 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801270:	55                   	push   %rbp
  801271:	48 89 e5             	mov    %rsp,%rbp
  801274:	48 83 ec 20          	sub    $0x20,%rsp
  801278:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80127c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801281:	74 27                	je     8012aa <readline+0x3a>
		fprintf(1, "%s", prompt);
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	48 89 c2             	mov    %rax,%rdx
  80128a:	48 be c8 4b 80 00 00 	movabs $0x804bc8,%rsi
  801291:	00 00 00 
  801294:	bf 01 00 00 00       	mov    $0x1,%edi
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	48 b9 37 33 80 00 00 	movabs $0x803337,%rcx
  8012a5:	00 00 00 
  8012a8:	ff d1                	callq  *%rcx
#endif


	i = 0;
  8012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8012b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8012b6:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  8012bd:	00 00 00 
  8012c0:	ff d0                	callq  *%rax
  8012c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8012c5:	48 b8 e4 01 80 00 00 	movabs $0x8001e4,%rax
  8012cc:	00 00 00 
  8012cf:	ff d0                	callq  *%rax
  8012d1:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8012d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8012d8:	79 30                	jns    80130a <readline+0x9a>

			if (c != -E_EOF)
  8012da:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  8012de:	74 20                	je     801300 <readline+0x90>
				cprintf("read error: %e\n", c);
  8012e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e3:	89 c6                	mov    %eax,%esi
  8012e5:	48 bf cb 4b 80 00 00 	movabs $0x804bcb,%rdi
  8012ec:	00 00 00 
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  8012fb:	00 00 00 
  8012fe:	ff d2                	callq  *%rdx

			return NULL;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	e9 c2 00 00 00       	jmpq   8013cc <readline+0x15c>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80130a:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80130e:	74 06                	je     801316 <readline+0xa6>
  801310:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801314:	75 26                	jne    80133c <readline+0xcc>
  801316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80131a:	7e 20                	jle    80133c <readline+0xcc>
			if (echoing)
  80131c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801320:	74 11                	je     801333 <readline+0xc3>
				cputchar('\b');
  801322:	bf 08 00 00 00       	mov    $0x8,%edi
  801327:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  80132e:	00 00 00 
  801331:	ff d0                	callq  *%rax
			i--;
  801333:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  801337:	e9 8b 00 00 00       	jmpq   8013c7 <readline+0x157>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133c:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801340:	7e 3f                	jle    801381 <readline+0x111>
  801342:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  801349:	7f 36                	jg     801381 <readline+0x111>
			if (echoing)
  80134b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80134f:	74 11                	je     801362 <readline+0xf2>
				cputchar(c);
  801351:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801354:	89 c7                	mov    %eax,%edi
  801356:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  80135d:	00 00 00 
  801360:	ff d0                	callq  *%rax
			buf[i++] = c;
  801362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801365:	8d 50 01             	lea    0x1(%rax),%edx
  801368:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80136b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80136e:	89 d1                	mov    %edx,%ecx
  801370:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801377:	00 00 00 
  80137a:	48 98                	cltq   
  80137c:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  80137f:	eb 46                	jmp    8013c7 <readline+0x157>
		} else if (c == '\n' || c == '\r') {
  801381:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801385:	74 0a                	je     801391 <readline+0x121>
  801387:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80138b:	0f 85 34 ff ff ff    	jne    8012c5 <readline+0x55>
			if (echoing)
  801391:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801395:	74 11                	je     8013a8 <readline+0x138>
				cputchar('\n');
  801397:	bf 0a 00 00 00       	mov    $0xa,%edi
  80139c:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013a3:	00 00 00 
  8013a6:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013a8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013af:	00 00 00 
  8013b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013b5:	48 98                	cltq   
  8013b7:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8013bb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013c2:	00 00 00 
  8013c5:	eb 05                	jmp    8013cc <readline+0x15c>
		}
	}
  8013c7:	e9 f9 fe ff ff       	jmpq   8012c5 <readline+0x55>
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 18          	sub    $0x18,%rsp
  8013d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013e1:	eb 09                	jmp    8013ec <strlen+0x1e>
		n++;
  8013e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 ec                	jne    8013e3 <strlen+0x15>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013fa:	c9                   	leaveq 
  8013fb:	c3                   	retq   

00000000008013fc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013fc:	55                   	push   %rbp
  8013fd:	48 89 e5             	mov    %rsp,%rbp
  801400:	48 83 ec 20          	sub    $0x20,%rsp
  801404:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801408:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801413:	eb 0e                	jmp    801423 <strnlen+0x27>
		n++;
  801415:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801419:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80141e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801423:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801428:	74 0b                	je     801435 <strnlen+0x39>
  80142a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	84 c0                	test   %al,%al
  801433:	75 e0                	jne    801415 <strnlen+0x19>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801438:	c9                   	leaveq 
  801439:	c3                   	retq   

000000000080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %rbp
  80143b:	48 89 e5             	mov    %rsp,%rbp
  80143e:	48 83 ec 20          	sub    $0x20,%rsp
  801442:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801446:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801452:	90                   	nop
  801453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801457:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80145b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80145f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801463:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801467:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80146b:	0f b6 12             	movzbl (%rdx),%edx
  80146e:	88 10                	mov    %dl,(%rax)
  801470:	0f b6 00             	movzbl (%rax),%eax
  801473:	84 c0                	test   %al,%al
  801475:	75 dc                	jne    801453 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80147b:	c9                   	leaveq 
  80147c:	c3                   	retq   

000000000080147d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80147d:	55                   	push   %rbp
  80147e:	48 89 e5             	mov    %rsp,%rbp
  801481:	48 83 ec 20          	sub    $0x20,%rsp
  801485:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801489:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80148d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801491:	48 89 c7             	mov    %rax,%rdi
  801494:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	callq  *%rax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014a6:	48 63 d0             	movslq %eax,%rdx
  8014a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ad:	48 01 c2             	add    %rax,%rdx
  8014b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b4:	48 89 c6             	mov    %rax,%rsi
  8014b7:	48 89 d7             	mov    %rdx,%rdi
  8014ba:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  8014c1:	00 00 00 
  8014c4:	ff d0                	callq  *%rax
	return dst;
  8014c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ca:	c9                   	leaveq 
  8014cb:	c3                   	retq   

00000000008014cc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014cc:	55                   	push   %rbp
  8014cd:	48 89 e5             	mov    %rsp,%rbp
  8014d0:	48 83 ec 28          	sub    $0x28,%rsp
  8014d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014e8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014ef:	00 
  8014f0:	eb 2a                	jmp    80151c <strncpy+0x50>
		*dst++ = *src;
  8014f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801502:	0f b6 12             	movzbl (%rdx),%edx
  801505:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801507:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	84 c0                	test   %al,%al
  801510:	74 05                	je     801517 <strncpy+0x4b>
			src++;
  801512:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801517:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801520:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801524:	72 cc                	jb     8014f2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 28          	sub    $0x28,%rsp
  801534:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801538:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80153c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801544:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801548:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80154d:	74 3d                	je     80158c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80154f:	eb 1d                	jmp    80156e <strlcpy+0x42>
			*dst++ = *src++;
  801551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801555:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801559:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80155d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801561:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801565:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801569:	0f b6 12             	movzbl (%rdx),%edx
  80156c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80156e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801573:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801578:	74 0b                	je     801585 <strlcpy+0x59>
  80157a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157e:	0f b6 00             	movzbl (%rax),%eax
  801581:	84 c0                	test   %al,%al
  801583:	75 cc                	jne    801551 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801589:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80158c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	48 29 c2             	sub    %rax,%rdx
  801597:	48 89 d0             	mov    %rdx,%rax
}
  80159a:	c9                   	leaveq 
  80159b:	c3                   	retq   

000000000080159c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80159c:	55                   	push   %rbp
  80159d:	48 89 e5             	mov    %rsp,%rbp
  8015a0:	48 83 ec 10          	sub    $0x10,%rsp
  8015a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015ac:	eb 0a                	jmp    8015b8 <strcmp+0x1c>
		p++, q++;
  8015ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bc:	0f b6 00             	movzbl (%rax),%eax
  8015bf:	84 c0                	test   %al,%al
  8015c1:	74 12                	je     8015d5 <strcmp+0x39>
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	0f b6 10             	movzbl (%rax),%edx
  8015ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ce:	0f b6 00             	movzbl (%rax),%eax
  8015d1:	38 c2                	cmp    %al,%dl
  8015d3:	74 d9                	je     8015ae <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	0f b6 d0             	movzbl %al,%edx
  8015df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	0f b6 c0             	movzbl %al,%eax
  8015e9:	29 c2                	sub    %eax,%edx
  8015eb:	89 d0                	mov    %edx,%eax
}
  8015ed:	c9                   	leaveq 
  8015ee:	c3                   	retq   

00000000008015ef <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015ef:	55                   	push   %rbp
  8015f0:	48 89 e5             	mov    %rsp,%rbp
  8015f3:	48 83 ec 18          	sub    $0x18,%rsp
  8015f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801603:	eb 0f                	jmp    801614 <strncmp+0x25>
		n--, p++, q++;
  801605:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80160a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801614:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801619:	74 1d                	je     801638 <strncmp+0x49>
  80161b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	84 c0                	test   %al,%al
  801624:	74 12                	je     801638 <strncmp+0x49>
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	0f b6 10             	movzbl (%rax),%edx
  80162d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801631:	0f b6 00             	movzbl (%rax),%eax
  801634:	38 c2                	cmp    %al,%dl
  801636:	74 cd                	je     801605 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801638:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80163d:	75 07                	jne    801646 <strncmp+0x57>
		return 0;
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
  801644:	eb 18                	jmp    80165e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	0f b6 d0             	movzbl %al,%edx
  801650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	0f b6 c0             	movzbl %al,%eax
  80165a:	29 c2                	sub    %eax,%edx
  80165c:	89 d0                	mov    %edx,%eax
}
  80165e:	c9                   	leaveq 
  80165f:	c3                   	retq   

0000000000801660 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	48 83 ec 10          	sub    $0x10,%rsp
  801668:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80166c:	89 f0                	mov    %esi,%eax
  80166e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801671:	eb 17                	jmp    80168a <strchr+0x2a>
		if (*s == c)
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80167d:	75 06                	jne    801685 <strchr+0x25>
			return (char *) s;
  80167f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801683:	eb 15                	jmp    80169a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801685:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80168a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168e:	0f b6 00             	movzbl (%rax),%eax
  801691:	84 c0                	test   %al,%al
  801693:	75 de                	jne    801673 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169a:	c9                   	leaveq 
  80169b:	c3                   	retq   

000000000080169c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80169c:	55                   	push   %rbp
  80169d:	48 89 e5             	mov    %rsp,%rbp
  8016a0:	48 83 ec 10          	sub    $0x10,%rsp
  8016a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016a8:	89 f0                	mov    %esi,%eax
  8016aa:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016ad:	eb 11                	jmp    8016c0 <strfind+0x24>
		if (*s == c)
  8016af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016b9:	74 12                	je     8016cd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	84 c0                	test   %al,%al
  8016c9:	75 e4                	jne    8016af <strfind+0x13>
  8016cb:	eb 01                	jmp    8016ce <strfind+0x32>
		if (*s == c)
			break;
  8016cd:	90                   	nop
	return (char *) s;
  8016ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016d2:	c9                   	leaveq 
  8016d3:	c3                   	retq   

00000000008016d4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016d4:	55                   	push   %rbp
  8016d5:	48 89 e5             	mov    %rsp,%rbp
  8016d8:	48 83 ec 18          	sub    $0x18,%rsp
  8016dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016e0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016ec:	75 06                	jne    8016f4 <memset+0x20>
		return v;
  8016ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f2:	eb 69                	jmp    80175d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f8:	83 e0 03             	and    $0x3,%eax
  8016fb:	48 85 c0             	test   %rax,%rax
  8016fe:	75 48                	jne    801748 <memset+0x74>
  801700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801704:	83 e0 03             	and    $0x3,%eax
  801707:	48 85 c0             	test   %rax,%rax
  80170a:	75 3c                	jne    801748 <memset+0x74>
		c &= 0xFF;
  80170c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801713:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801716:	c1 e0 18             	shl    $0x18,%eax
  801719:	89 c2                	mov    %eax,%edx
  80171b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80171e:	c1 e0 10             	shl    $0x10,%eax
  801721:	09 c2                	or     %eax,%edx
  801723:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801726:	c1 e0 08             	shl    $0x8,%eax
  801729:	09 d0                	or     %edx,%eax
  80172b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80172e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801732:	48 c1 e8 02          	shr    $0x2,%rax
  801736:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801739:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801740:	48 89 d7             	mov    %rdx,%rdi
  801743:	fc                   	cld    
  801744:	f3 ab                	rep stos %eax,%es:(%rdi)
  801746:	eb 11                	jmp    801759 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801748:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80174f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801753:	48 89 d7             	mov    %rdx,%rdi
  801756:	fc                   	cld    
  801757:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80175d:	c9                   	leaveq 
  80175e:	c3                   	retq   

000000000080175f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80175f:	55                   	push   %rbp
  801760:	48 89 e5             	mov    %rsp,%rbp
  801763:	48 83 ec 28          	sub    $0x28,%rsp
  801767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80176b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80176f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801773:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80177b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801787:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80178b:	0f 83 88 00 00 00    	jae    801819 <memmove+0xba>
  801791:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	48 01 d0             	add    %rdx,%rax
  80179c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017a0:	76 77                	jbe    801819 <memmove+0xba>
		s += n;
  8017a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ae:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b6:	83 e0 03             	and    $0x3,%eax
  8017b9:	48 85 c0             	test   %rax,%rax
  8017bc:	75 3b                	jne    8017f9 <memmove+0x9a>
  8017be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c2:	83 e0 03             	and    $0x3,%eax
  8017c5:	48 85 c0             	test   %rax,%rax
  8017c8:	75 2f                	jne    8017f9 <memmove+0x9a>
  8017ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ce:	83 e0 03             	and    $0x3,%eax
  8017d1:	48 85 c0             	test   %rax,%rax
  8017d4:	75 23                	jne    8017f9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017da:	48 83 e8 04          	sub    $0x4,%rax
  8017de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017e2:	48 83 ea 04          	sub    $0x4,%rdx
  8017e6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017ea:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017ee:	48 89 c7             	mov    %rax,%rdi
  8017f1:	48 89 d6             	mov    %rdx,%rsi
  8017f4:	fd                   	std    
  8017f5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017f7:	eb 1d                	jmp    801816 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801805:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	48 89 d7             	mov    %rdx,%rdi
  801810:	48 89 c1             	mov    %rax,%rcx
  801813:	fd                   	std    
  801814:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801816:	fc                   	cld    
  801817:	eb 57                	jmp    801870 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181d:	83 e0 03             	and    $0x3,%eax
  801820:	48 85 c0             	test   %rax,%rax
  801823:	75 36                	jne    80185b <memmove+0xfc>
  801825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801829:	83 e0 03             	and    $0x3,%eax
  80182c:	48 85 c0             	test   %rax,%rax
  80182f:	75 2a                	jne    80185b <memmove+0xfc>
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	83 e0 03             	and    $0x3,%eax
  801838:	48 85 c0             	test   %rax,%rax
  80183b:	75 1e                	jne    80185b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	48 c1 e8 02          	shr    $0x2,%rax
  801845:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801850:	48 89 c7             	mov    %rax,%rdi
  801853:	48 89 d6             	mov    %rdx,%rsi
  801856:	fc                   	cld    
  801857:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801859:	eb 15                	jmp    801870 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80185b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801863:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801867:	48 89 c7             	mov    %rax,%rdi
  80186a:	48 89 d6             	mov    %rdx,%rsi
  80186d:	fc                   	cld    
  80186e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801874:	c9                   	leaveq 
  801875:	c3                   	retq   

0000000000801876 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801876:	55                   	push   %rbp
  801877:	48 89 e5             	mov    %rsp,%rbp
  80187a:	48 83 ec 18          	sub    $0x18,%rsp
  80187e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801882:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801886:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80188a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801892:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801896:	48 89 ce             	mov    %rcx,%rsi
  801899:	48 89 c7             	mov    %rax,%rdi
  80189c:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  8018a3:	00 00 00 
  8018a6:	ff d0                	callq  *%rax
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 28          	sub    $0x28,%rsp
  8018b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018ce:	eb 36                	jmp    801906 <memcmp+0x5c>
		if (*s1 != *s2)
  8018d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d4:	0f b6 10             	movzbl (%rax),%edx
  8018d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018db:	0f b6 00             	movzbl (%rax),%eax
  8018de:	38 c2                	cmp    %al,%dl
  8018e0:	74 1a                	je     8018fc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e6:	0f b6 00             	movzbl (%rax),%eax
  8018e9:	0f b6 d0             	movzbl %al,%edx
  8018ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	0f b6 c0             	movzbl %al,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	eb 20                	jmp    80191c <memcmp+0x72>
		s1++, s2++;
  8018fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801901:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80190e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801912:	48 85 c0             	test   %rax,%rax
  801915:	75 b9                	jne    8018d0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 28          	sub    $0x28,%rsp
  801926:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80192a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80192d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801931:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801939:	48 01 d0             	add    %rdx,%rax
  80193c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801940:	eb 19                	jmp    80195b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801946:	0f b6 00             	movzbl (%rax),%eax
  801949:	0f b6 d0             	movzbl %al,%edx
  80194c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80194f:	0f b6 c0             	movzbl %al,%eax
  801952:	39 c2                	cmp    %eax,%edx
  801954:	74 11                	je     801967 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801956:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80195b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80195f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801963:	72 dd                	jb     801942 <memfind+0x24>
  801965:	eb 01                	jmp    801968 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801967:	90                   	nop
	return (void *) s;
  801968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 38          	sub    $0x38,%rsp
  801976:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80197a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80197e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801981:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801988:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80198f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801990:	eb 05                	jmp    801997 <strtol+0x29>
		s++;
  801992:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199b:	0f b6 00             	movzbl (%rax),%eax
  80199e:	3c 20                	cmp    $0x20,%al
  8019a0:	74 f0                	je     801992 <strtol+0x24>
  8019a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a6:	0f b6 00             	movzbl (%rax),%eax
  8019a9:	3c 09                	cmp    $0x9,%al
  8019ab:	74 e5                	je     801992 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b1:	0f b6 00             	movzbl (%rax),%eax
  8019b4:	3c 2b                	cmp    $0x2b,%al
  8019b6:	75 07                	jne    8019bf <strtol+0x51>
		s++;
  8019b8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019bd:	eb 17                	jmp    8019d6 <strtol+0x68>
	else if (*s == '-')
  8019bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c3:	0f b6 00             	movzbl (%rax),%eax
  8019c6:	3c 2d                	cmp    $0x2d,%al
  8019c8:	75 0c                	jne    8019d6 <strtol+0x68>
		s++, neg = 1;
  8019ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019da:	74 06                	je     8019e2 <strtol+0x74>
  8019dc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019e0:	75 28                	jne    801a0a <strtol+0x9c>
  8019e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	3c 30                	cmp    $0x30,%al
  8019eb:	75 1d                	jne    801a0a <strtol+0x9c>
  8019ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f1:	48 83 c0 01          	add    $0x1,%rax
  8019f5:	0f b6 00             	movzbl (%rax),%eax
  8019f8:	3c 78                	cmp    $0x78,%al
  8019fa:	75 0e                	jne    801a0a <strtol+0x9c>
		s += 2, base = 16;
  8019fc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a01:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a08:	eb 2c                	jmp    801a36 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a0a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a0e:	75 19                	jne    801a29 <strtol+0xbb>
  801a10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a14:	0f b6 00             	movzbl (%rax),%eax
  801a17:	3c 30                	cmp    $0x30,%al
  801a19:	75 0e                	jne    801a29 <strtol+0xbb>
		s++, base = 8;
  801a1b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a20:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a27:	eb 0d                	jmp    801a36 <strtol+0xc8>
	else if (base == 0)
  801a29:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a2d:	75 07                	jne    801a36 <strtol+0xc8>
		base = 10;
  801a2f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3a:	0f b6 00             	movzbl (%rax),%eax
  801a3d:	3c 2f                	cmp    $0x2f,%al
  801a3f:	7e 1d                	jle    801a5e <strtol+0xf0>
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	0f b6 00             	movzbl (%rax),%eax
  801a48:	3c 39                	cmp    $0x39,%al
  801a4a:	7f 12                	jg     801a5e <strtol+0xf0>
			dig = *s - '0';
  801a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a50:	0f b6 00             	movzbl (%rax),%eax
  801a53:	0f be c0             	movsbl %al,%eax
  801a56:	83 e8 30             	sub    $0x30,%eax
  801a59:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a5c:	eb 4e                	jmp    801aac <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a62:	0f b6 00             	movzbl (%rax),%eax
  801a65:	3c 60                	cmp    $0x60,%al
  801a67:	7e 1d                	jle    801a86 <strtol+0x118>
  801a69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6d:	0f b6 00             	movzbl (%rax),%eax
  801a70:	3c 7a                	cmp    $0x7a,%al
  801a72:	7f 12                	jg     801a86 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a78:	0f b6 00             	movzbl (%rax),%eax
  801a7b:	0f be c0             	movsbl %al,%eax
  801a7e:	83 e8 57             	sub    $0x57,%eax
  801a81:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a84:	eb 26                	jmp    801aac <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8a:	0f b6 00             	movzbl (%rax),%eax
  801a8d:	3c 40                	cmp    $0x40,%al
  801a8f:	7e 47                	jle    801ad8 <strtol+0x16a>
  801a91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a95:	0f b6 00             	movzbl (%rax),%eax
  801a98:	3c 5a                	cmp    $0x5a,%al
  801a9a:	7f 3c                	jg     801ad8 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa0:	0f b6 00             	movzbl (%rax),%eax
  801aa3:	0f be c0             	movsbl %al,%eax
  801aa6:	83 e8 37             	sub    $0x37,%eax
  801aa9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801aac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aaf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801ab2:	7d 23                	jge    801ad7 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801ab4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ab9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801abc:	48 98                	cltq   
  801abe:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ac3:	48 89 c2             	mov    %rax,%rdx
  801ac6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ac9:	48 98                	cltq   
  801acb:	48 01 d0             	add    %rdx,%rax
  801ace:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ad2:	e9 5f ff ff ff       	jmpq   801a36 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ad7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ad8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801add:	74 0b                	je     801aea <strtol+0x17c>
		*endptr = (char *) s;
  801adf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ae7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801aea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aee:	74 09                	je     801af9 <strtol+0x18b>
  801af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af4:	48 f7 d8             	neg    %rax
  801af7:	eb 04                	jmp    801afd <strtol+0x18f>
  801af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801afd:	c9                   	leaveq 
  801afe:	c3                   	retq   

0000000000801aff <strstr>:

char * strstr(const char *in, const char *str)
{
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
  801b03:	48 83 ec 30          	sub    $0x30,%rsp
  801b07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b13:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b17:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b1b:	0f b6 00             	movzbl (%rax),%eax
  801b1e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b21:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b25:	75 06                	jne    801b2d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2b:	eb 6b                	jmp    801b98 <strstr+0x99>

	len = strlen(str);
  801b2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b31:	48 89 c7             	mov    %rax,%rdi
  801b34:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
  801b40:	48 98                	cltq   
  801b42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b4e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b52:	0f b6 00             	movzbl (%rax),%eax
  801b55:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b58:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b5c:	75 07                	jne    801b65 <strstr+0x66>
				return (char *) 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b63:	eb 33                	jmp    801b98 <strstr+0x99>
		} while (sc != c);
  801b65:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b69:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b6c:	75 d8                	jne    801b46 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b72:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7a:	48 89 ce             	mov    %rcx,%rsi
  801b7d:	48 89 c7             	mov    %rax,%rdi
  801b80:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	75 b6                	jne    801b46 <strstr+0x47>

	return (char *) (in - 1);
  801b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b94:	48 83 e8 01          	sub    $0x1,%rax
}
  801b98:	c9                   	leaveq 
  801b99:	c3                   	retq   

0000000000801b9a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b9a:	55                   	push   %rbp
  801b9b:	48 89 e5             	mov    %rsp,%rbp
  801b9e:	53                   	push   %rbx
  801b9f:	48 83 ec 48          	sub    $0x48,%rsp
  801ba3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ba6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ba9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bb1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bb5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bb9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bbc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bc0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bc4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801bc8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bcc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bd0:	4c 89 c3             	mov    %r8,%rbx
  801bd3:	cd 30                	int    $0x30
  801bd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bd9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bdd:	74 3e                	je     801c1d <syscall+0x83>
  801bdf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801be4:	7e 37                	jle    801c1d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801be6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bed:	49 89 d0             	mov    %rdx,%r8
  801bf0:	89 c1                	mov    %eax,%ecx
  801bf2:	48 ba db 4b 80 00 00 	movabs $0x804bdb,%rdx
  801bf9:	00 00 00 
  801bfc:	be 24 00 00 00       	mov    $0x24,%esi
  801c01:	48 bf f8 4b 80 00 00 	movabs $0x804bf8,%rdi
  801c08:	00 00 00 
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	49 b9 12 05 80 00 00 	movabs $0x800512,%r9
  801c17:	00 00 00 
  801c1a:	41 ff d1             	callq  *%r9

	return ret;
  801c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c21:	48 83 c4 48          	add    $0x48,%rsp
  801c25:	5b                   	pop    %rbx
  801c26:	5d                   	pop    %rbp
  801c27:	c3                   	retq   

0000000000801c28 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c28:	55                   	push   %rbp
  801c29:	48 89 e5             	mov    %rsp,%rbp
  801c2c:	48 83 ec 10          	sub    $0x10,%rsp
  801c30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c40:	48 83 ec 08          	sub    $0x8,%rsp
  801c44:	6a 00                	pushq  $0x0
  801c46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c52:	48 89 d1             	mov    %rdx,%rcx
  801c55:	48 89 c2             	mov    %rax,%rdx
  801c58:	be 00 00 00 00       	mov    $0x0,%esi
  801c5d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c62:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
  801c6e:	48 83 c4 10          	add    $0x10,%rsp
}
  801c72:	90                   	nop
  801c73:	c9                   	leaveq 
  801c74:	c3                   	retq   

0000000000801c75 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c75:	55                   	push   %rbp
  801c76:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c79:	48 83 ec 08          	sub    $0x8,%rsp
  801c7d:	6a 00                	pushq  $0x0
  801c7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c90:	ba 00 00 00 00       	mov    $0x0,%edx
  801c95:	be 00 00 00 00       	mov    $0x0,%esi
  801c9a:	bf 01 00 00 00       	mov    $0x1,%edi
  801c9f:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801ca6:	00 00 00 
  801ca9:	ff d0                	callq  *%rax
  801cab:	48 83 c4 10          	add    $0x10,%rsp
}
  801caf:	c9                   	leaveq 
  801cb0:	c3                   	retq   

0000000000801cb1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cb1:	55                   	push   %rbp
  801cb2:	48 89 e5             	mov    %rsp,%rbp
  801cb5:	48 83 ec 10          	sub    $0x10,%rsp
  801cb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbf:	48 98                	cltq   
  801cc1:	48 83 ec 08          	sub    $0x8,%rsp
  801cc5:	6a 00                	pushq  $0x0
  801cc7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ccd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cd8:	48 89 c2             	mov    %rax,%rdx
  801cdb:	be 01 00 00 00       	mov    $0x1,%esi
  801ce0:	bf 03 00 00 00       	mov    $0x3,%edi
  801ce5:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801cec:	00 00 00 
  801cef:	ff d0                	callq  *%rax
  801cf1:	48 83 c4 10          	add    $0x10,%rsp
}
  801cf5:	c9                   	leaveq 
  801cf6:	c3                   	retq   

0000000000801cf7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cf7:	55                   	push   %rbp
  801cf8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cfb:	48 83 ec 08          	sub    $0x8,%rsp
  801cff:	6a 00                	pushq  $0x0
  801d01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d12:	ba 00 00 00 00       	mov    $0x0,%edx
  801d17:	be 00 00 00 00       	mov    $0x0,%esi
  801d1c:	bf 02 00 00 00       	mov    $0x2,%edi
  801d21:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
  801d2d:	48 83 c4 10          	add    $0x10,%rsp
}
  801d31:	c9                   	leaveq 
  801d32:	c3                   	retq   

0000000000801d33 <sys_yield>:


void
sys_yield(void)
{
  801d33:	55                   	push   %rbp
  801d34:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d37:	48 83 ec 08          	sub    $0x8,%rsp
  801d3b:	6a 00                	pushq  $0x0
  801d3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d5d:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
  801d69:	48 83 c4 10          	add    $0x10,%rsp
}
  801d6d:	90                   	nop
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 10          	sub    $0x10,%rsp
  801d78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d85:	48 63 c8             	movslq %eax,%rcx
  801d88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8f:	48 98                	cltq   
  801d91:	48 83 ec 08          	sub    $0x8,%rsp
  801d95:	6a 00                	pushq  $0x0
  801d97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d9d:	49 89 c8             	mov    %rcx,%r8
  801da0:	48 89 d1             	mov    %rdx,%rcx
  801da3:	48 89 c2             	mov    %rax,%rdx
  801da6:	be 01 00 00 00       	mov    $0x1,%esi
  801dab:	bf 04 00 00 00       	mov    $0x4,%edi
  801db0:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
  801dbc:	48 83 c4 10          	add    $0x10,%rsp
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 20          	sub    $0x20,%rsp
  801dca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dd1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dd4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dd8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ddc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ddf:	48 63 c8             	movslq %eax,%rcx
  801de2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801de6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801de9:	48 63 f0             	movslq %eax,%rsi
  801dec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df3:	48 98                	cltq   
  801df5:	48 83 ec 08          	sub    $0x8,%rsp
  801df9:	51                   	push   %rcx
  801dfa:	49 89 f9             	mov    %rdi,%r9
  801dfd:	49 89 f0             	mov    %rsi,%r8
  801e00:	48 89 d1             	mov    %rdx,%rcx
  801e03:	48 89 c2             	mov    %rax,%rdx
  801e06:	be 01 00 00 00       	mov    $0x1,%esi
  801e0b:	bf 05 00 00 00       	mov    $0x5,%edi
  801e10:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
  801e1c:	48 83 c4 10          	add    $0x10,%rsp
}
  801e20:	c9                   	leaveq 
  801e21:	c3                   	retq   

0000000000801e22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e22:	55                   	push   %rbp
  801e23:	48 89 e5             	mov    %rsp,%rbp
  801e26:	48 83 ec 10          	sub    $0x10,%rsp
  801e2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e38:	48 98                	cltq   
  801e3a:	48 83 ec 08          	sub    $0x8,%rsp
  801e3e:	6a 00                	pushq  $0x0
  801e40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4c:	48 89 d1             	mov    %rdx,%rcx
  801e4f:	48 89 c2             	mov    %rax,%rdx
  801e52:	be 01 00 00 00       	mov    $0x1,%esi
  801e57:	bf 06 00 00 00       	mov    $0x6,%edi
  801e5c:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	callq  *%rax
  801e68:	48 83 c4 10          	add    $0x10,%rsp
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 10          	sub    $0x10,%rsp
  801e76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e79:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e7f:	48 63 d0             	movslq %eax,%rdx
  801e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e85:	48 98                	cltq   
  801e87:	48 83 ec 08          	sub    $0x8,%rsp
  801e8b:	6a 00                	pushq  $0x0
  801e8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e99:	48 89 d1             	mov    %rdx,%rcx
  801e9c:	48 89 c2             	mov    %rax,%rdx
  801e9f:	be 01 00 00 00       	mov    $0x1,%esi
  801ea4:	bf 08 00 00 00       	mov    $0x8,%edi
  801ea9:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801eb0:	00 00 00 
  801eb3:	ff d0                	callq  *%rax
  801eb5:	48 83 c4 10          	add    $0x10,%rsp
}
  801eb9:	c9                   	leaveq 
  801eba:	c3                   	retq   

0000000000801ebb <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ebb:	55                   	push   %rbp
  801ebc:	48 89 e5             	mov    %rsp,%rbp
  801ebf:	48 83 ec 10          	sub    $0x10,%rsp
  801ec3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed1:	48 98                	cltq   
  801ed3:	48 83 ec 08          	sub    $0x8,%rsp
  801ed7:	6a 00                	pushq  $0x0
  801ed9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801edf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee5:	48 89 d1             	mov    %rdx,%rcx
  801ee8:	48 89 c2             	mov    %rax,%rdx
  801eeb:	be 01 00 00 00       	mov    $0x1,%esi
  801ef0:	bf 09 00 00 00       	mov    $0x9,%edi
  801ef5:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	callq  *%rax
  801f01:	48 83 c4 10          	add    $0x10,%rsp
}
  801f05:	c9                   	leaveq 
  801f06:	c3                   	retq   

0000000000801f07 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f07:	55                   	push   %rbp
  801f08:	48 89 e5             	mov    %rsp,%rbp
  801f0b:	48 83 ec 10          	sub    $0x10,%rsp
  801f0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1d:	48 98                	cltq   
  801f1f:	48 83 ec 08          	sub    $0x8,%rsp
  801f23:	6a 00                	pushq  $0x0
  801f25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f31:	48 89 d1             	mov    %rdx,%rcx
  801f34:	48 89 c2             	mov    %rax,%rdx
  801f37:	be 01 00 00 00       	mov    $0x1,%esi
  801f3c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f41:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801f48:	00 00 00 
  801f4b:	ff d0                	callq  *%rax
  801f4d:	48 83 c4 10          	add    $0x10,%rsp
}
  801f51:	c9                   	leaveq 
  801f52:	c3                   	retq   

0000000000801f53 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f53:	55                   	push   %rbp
  801f54:	48 89 e5             	mov    %rsp,%rbp
  801f57:	48 83 ec 20          	sub    $0x20,%rsp
  801f5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f62:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f66:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f6c:	48 63 f0             	movslq %eax,%rsi
  801f6f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f76:	48 98                	cltq   
  801f78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7c:	48 83 ec 08          	sub    $0x8,%rsp
  801f80:	6a 00                	pushq  $0x0
  801f82:	49 89 f1             	mov    %rsi,%r9
  801f85:	49 89 c8             	mov    %rcx,%r8
  801f88:	48 89 d1             	mov    %rdx,%rcx
  801f8b:	48 89 c2             	mov    %rax,%rdx
  801f8e:	be 00 00 00 00       	mov    $0x0,%esi
  801f93:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f98:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801f9f:	00 00 00 
  801fa2:	ff d0                	callq  *%rax
  801fa4:	48 83 c4 10          	add    $0x10,%rsp
}
  801fa8:	c9                   	leaveq 
  801fa9:	c3                   	retq   

0000000000801faa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801faa:	55                   	push   %rbp
  801fab:	48 89 e5             	mov    %rsp,%rbp
  801fae:	48 83 ec 10          	sub    $0x10,%rsp
  801fb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fba:	48 83 ec 08          	sub    $0x8,%rsp
  801fbe:	6a 00                	pushq  $0x0
  801fc0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd1:	48 89 c2             	mov    %rax,%rdx
  801fd4:	be 01 00 00 00       	mov    $0x1,%esi
  801fd9:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fde:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	callq  *%rax
  801fea:	48 83 c4 10          	add    $0x10,%rsp
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ff4:	48 83 ec 08          	sub    $0x8,%rsp
  801ff8:	6a 00                	pushq  $0x0
  801ffa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802000:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802006:	b9 00 00 00 00       	mov    $0x0,%ecx
  80200b:	ba 00 00 00 00       	mov    $0x0,%edx
  802010:	be 00 00 00 00       	mov    $0x0,%esi
  802015:	bf 0e 00 00 00       	mov    $0xe,%edi
  80201a:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  802021:	00 00 00 
  802024:	ff d0                	callq  *%rax
  802026:	48 83 c4 10          	add    $0x10,%rsp
}
  80202a:	c9                   	leaveq 
  80202b:	c3                   	retq   

000000000080202c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  80202c:	55                   	push   %rbp
  80202d:	48 89 e5             	mov    %rsp,%rbp
  802030:	48 83 ec 10          	sub    $0x10,%rsp
  802034:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802038:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  80203b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80203e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802042:	48 83 ec 08          	sub    $0x8,%rsp
  802046:	6a 00                	pushq  $0x0
  802048:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80204e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802054:	48 89 d1             	mov    %rdx,%rcx
  802057:	48 89 c2             	mov    %rax,%rdx
  80205a:	be 00 00 00 00       	mov    $0x0,%esi
  80205f:	bf 0f 00 00 00       	mov    $0xf,%edi
  802064:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  80206b:	00 00 00 
  80206e:	ff d0                	callq  *%rax
  802070:	48 83 c4 10          	add    $0x10,%rsp
}
  802074:	c9                   	leaveq 
  802075:	c3                   	retq   

0000000000802076 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802076:	55                   	push   %rbp
  802077:	48 89 e5             	mov    %rsp,%rbp
  80207a:	48 83 ec 10          	sub    $0x10,%rsp
  80207e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802082:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802085:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80208c:	48 83 ec 08          	sub    $0x8,%rsp
  802090:	6a 00                	pushq  $0x0
  802092:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802098:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209e:	48 89 d1             	mov    %rdx,%rcx
  8020a1:	48 89 c2             	mov    %rax,%rdx
  8020a4:	be 00 00 00 00       	mov    $0x0,%esi
  8020a9:	bf 10 00 00 00       	mov    $0x10,%edi
  8020ae:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  8020b5:	00 00 00 
  8020b8:	ff d0                	callq  *%rax
  8020ba:	48 83 c4 10          	add    $0x10,%rsp
}
  8020be:	c9                   	leaveq 
  8020bf:	c3                   	retq   

00000000008020c0 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8020c0:	55                   	push   %rbp
  8020c1:	48 89 e5             	mov    %rsp,%rbp
  8020c4:	48 83 ec 20          	sub    $0x20,%rsp
  8020c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020cf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020d2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020d6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020da:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020dd:	48 63 c8             	movslq %eax,%rcx
  8020e0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e7:	48 63 f0             	movslq %eax,%rsi
  8020ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f1:	48 98                	cltq   
  8020f3:	48 83 ec 08          	sub    $0x8,%rsp
  8020f7:	51                   	push   %rcx
  8020f8:	49 89 f9             	mov    %rdi,%r9
  8020fb:	49 89 f0             	mov    %rsi,%r8
  8020fe:	48 89 d1             	mov    %rdx,%rcx
  802101:	48 89 c2             	mov    %rax,%rdx
  802104:	be 00 00 00 00       	mov    $0x0,%esi
  802109:	bf 11 00 00 00       	mov    $0x11,%edi
  80210e:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
  80211a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80211e:	c9                   	leaveq 
  80211f:	c3                   	retq   

0000000000802120 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802120:	55                   	push   %rbp
  802121:	48 89 e5             	mov    %rsp,%rbp
  802124:	48 83 ec 10          	sub    $0x10,%rsp
  802128:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80212c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802130:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802138:	48 83 ec 08          	sub    $0x8,%rsp
  80213c:	6a 00                	pushq  $0x0
  80213e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802144:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80214a:	48 89 d1             	mov    %rdx,%rcx
  80214d:	48 89 c2             	mov    %rax,%rdx
  802150:	be 00 00 00 00       	mov    $0x0,%esi
  802155:	bf 12 00 00 00       	mov    $0x12,%edi
  80215a:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  802161:	00 00 00 
  802164:	ff d0                	callq  *%rax
  802166:	48 83 c4 10          	add    $0x10,%rsp
}
  80216a:	c9                   	leaveq 
  80216b:	c3                   	retq   

000000000080216c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	48 83 ec 08          	sub    $0x8,%rsp
  802174:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802178:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80217c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802183:	ff ff ff 
  802186:	48 01 d0             	add    %rdx,%rax
  802189:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80218d:	c9                   	leaveq 
  80218e:	c3                   	retq   

000000000080218f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80218f:	55                   	push   %rbp
  802190:	48 89 e5             	mov    %rsp,%rbp
  802193:	48 83 ec 08          	sub    $0x8,%rsp
  802197:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80219b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219f:	48 89 c7             	mov    %rax,%rdi
  8021a2:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	callq  *%rax
  8021ae:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021b4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021b8:	c9                   	leaveq 
  8021b9:	c3                   	retq   

00000000008021ba <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 18          	sub    $0x18,%rsp
  8021c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021cd:	eb 6b                	jmp    80223a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d2:	48 98                	cltq   
  8021d4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021da:	48 c1 e0 0c          	shl    $0xc,%rax
  8021de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e6:	48 c1 e8 15          	shr    $0x15,%rax
  8021ea:	48 89 c2             	mov    %rax,%rdx
  8021ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f4:	01 00 00 
  8021f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fb:	83 e0 01             	and    $0x1,%eax
  8021fe:	48 85 c0             	test   %rax,%rax
  802201:	74 21                	je     802224 <fd_alloc+0x6a>
  802203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802207:	48 c1 e8 0c          	shr    $0xc,%rax
  80220b:	48 89 c2             	mov    %rax,%rdx
  80220e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802215:	01 00 00 
  802218:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221c:	83 e0 01             	and    $0x1,%eax
  80221f:	48 85 c0             	test   %rax,%rax
  802222:	75 12                	jne    802236 <fd_alloc+0x7c>
			*fd_store = fd;
  802224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802228:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80222c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	eb 1a                	jmp    802250 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802236:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80223a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80223e:	7e 8f                	jle    8021cf <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802244:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80224b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802250:	c9                   	leaveq 
  802251:	c3                   	retq   

0000000000802252 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802252:	55                   	push   %rbp
  802253:	48 89 e5             	mov    %rsp,%rbp
  802256:	48 83 ec 20          	sub    $0x20,%rsp
  80225a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80225d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802261:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802265:	78 06                	js     80226d <fd_lookup+0x1b>
  802267:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80226b:	7e 07                	jle    802274 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80226d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802272:	eb 6c                	jmp    8022e0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802274:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802277:	48 98                	cltq   
  802279:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80227f:	48 c1 e0 0c          	shl    $0xc,%rax
  802283:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228b:	48 c1 e8 15          	shr    $0x15,%rax
  80228f:	48 89 c2             	mov    %rax,%rdx
  802292:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802299:	01 00 00 
  80229c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a0:	83 e0 01             	and    $0x1,%eax
  8022a3:	48 85 c0             	test   %rax,%rax
  8022a6:	74 21                	je     8022c9 <fd_lookup+0x77>
  8022a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b0:	48 89 c2             	mov    %rax,%rdx
  8022b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ba:	01 00 00 
  8022bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	48 85 c0             	test   %rax,%rax
  8022c7:	75 07                	jne    8022d0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ce:	eb 10                	jmp    8022e0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022d8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e0:	c9                   	leaveq 
  8022e1:	c3                   	retq   

00000000008022e2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022e2:	55                   	push   %rbp
  8022e3:	48 89 e5             	mov    %rsp,%rbp
  8022e6:	48 83 ec 30          	sub    $0x30,%rsp
  8022ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022ee:	89 f0                	mov    %esi,%eax
  8022f0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f7:	48 89 c7             	mov    %rax,%rdi
  8022fa:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
  802306:	89 c2                	mov    %eax,%edx
  802308:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80230c:	48 89 c6             	mov    %rax,%rsi
  80230f:	89 d7                	mov    %edx,%edi
  802311:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
  80231d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802320:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802324:	78 0a                	js     802330 <fd_close+0x4e>
	    || fd != fd2)
  802326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80232e:	74 12                	je     802342 <fd_close+0x60>
		return (must_exist ? r : 0);
  802330:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802334:	74 05                	je     80233b <fd_close+0x59>
  802336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802339:	eb 70                	jmp    8023ab <fd_close+0xc9>
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	eb 69                	jmp    8023ab <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802346:	8b 00                	mov    (%rax),%eax
  802348:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80234c:	48 89 d6             	mov    %rdx,%rsi
  80234f:	89 c7                	mov    %eax,%edi
  802351:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  802358:	00 00 00 
  80235b:	ff d0                	callq  *%rax
  80235d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802360:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802364:	78 2a                	js     802390 <fd_close+0xae>
		if (dev->dev_close)
  802366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80236e:	48 85 c0             	test   %rax,%rax
  802371:	74 16                	je     802389 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802373:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802377:	48 8b 40 20          	mov    0x20(%rax),%rax
  80237b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80237f:	48 89 d7             	mov    %rdx,%rdi
  802382:	ff d0                	callq  *%rax
  802384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802387:	eb 07                	jmp    802390 <fd_close+0xae>
		else
			r = 0;
  802389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802390:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802394:	48 89 c6             	mov    %rax,%rsi
  802397:	bf 00 00 00 00       	mov    $0x0,%edi
  80239c:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  8023a3:	00 00 00 
  8023a6:	ff d0                	callq  *%rax
	return r;
  8023a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023ab:	c9                   	leaveq 
  8023ac:	c3                   	retq   

00000000008023ad <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023ad:	55                   	push   %rbp
  8023ae:	48 89 e5             	mov    %rsp,%rbp
  8023b1:	48 83 ec 20          	sub    $0x20,%rsp
  8023b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c3:	eb 41                	jmp    802406 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023c5:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023cc:	00 00 00 
  8023cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023d2:	48 63 d2             	movslq %edx,%rdx
  8023d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d9:	8b 00                	mov    (%rax),%eax
  8023db:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023de:	75 22                	jne    802402 <dev_lookup+0x55>
			*dev = devtab[i];
  8023e0:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023e7:	00 00 00 
  8023ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023ed:	48 63 d2             	movslq %edx,%rdx
  8023f0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802400:	eb 60                	jmp    802462 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802402:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802406:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80240d:	00 00 00 
  802410:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802413:	48 63 d2             	movslq %edx,%rdx
  802416:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241a:	48 85 c0             	test   %rax,%rax
  80241d:	75 a6                	jne    8023c5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80241f:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802426:	00 00 00 
  802429:	48 8b 00             	mov    (%rax),%rax
  80242c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802432:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802435:	89 c6                	mov    %eax,%esi
  802437:	48 bf 08 4c 80 00 00 	movabs $0x804c08,%rdi
  80243e:	00 00 00 
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
  802446:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  80244d:	00 00 00 
  802450:	ff d1                	callq  *%rcx
	*dev = 0;
  802452:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802456:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80245d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802462:	c9                   	leaveq 
  802463:	c3                   	retq   

0000000000802464 <close>:

int
close(int fdnum)
{
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
  802468:	48 83 ec 20          	sub    $0x20,%rsp
  80246c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802473:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802476:	48 89 d6             	mov    %rdx,%rsi
  802479:	89 c7                	mov    %eax,%edi
  80247b:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  802482:	00 00 00 
  802485:	ff d0                	callq  *%rax
  802487:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80248a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80248e:	79 05                	jns    802495 <close+0x31>
		return r;
  802490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802493:	eb 18                	jmp    8024ad <close+0x49>
	else
		return fd_close(fd, 1);
  802495:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802499:	be 01 00 00 00       	mov    $0x1,%esi
  80249e:	48 89 c7             	mov    %rax,%rdi
  8024a1:	48 b8 e2 22 80 00 00 	movabs $0x8022e2,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
}
  8024ad:	c9                   	leaveq 
  8024ae:	c3                   	retq   

00000000008024af <close_all>:

void
close_all(void)
{
  8024af:	55                   	push   %rbp
  8024b0:	48 89 e5             	mov    %rsp,%rbp
  8024b3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024be:	eb 15                	jmp    8024d5 <close_all+0x26>
		close(i);
  8024c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c3:	89 c7                	mov    %eax,%edi
  8024c5:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024d5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024d9:	7e e5                	jle    8024c0 <close_all+0x11>
		close(i);
}
  8024db:	90                   	nop
  8024dc:	c9                   	leaveq 
  8024dd:	c3                   	retq   

00000000008024de <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024de:	55                   	push   %rbp
  8024df:	48 89 e5             	mov    %rsp,%rbp
  8024e2:	48 83 ec 40          	sub    $0x40,%rsp
  8024e6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024e9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024ec:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024f3:	48 89 d6             	mov    %rdx,%rsi
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	callq  *%rax
  802504:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802507:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250b:	79 08                	jns    802515 <dup+0x37>
		return r;
  80250d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802510:	e9 70 01 00 00       	jmpq   802685 <dup+0x1a7>
	close(newfdnum);
  802515:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802518:	89 c7                	mov    %eax,%edi
  80251a:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  802521:	00 00 00 
  802524:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802526:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802529:	48 98                	cltq   
  80252b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802531:	48 c1 e0 0c          	shl    $0xc,%rax
  802535:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253d:	48 89 c7             	mov    %rax,%rdi
  802540:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  802547:	00 00 00 
  80254a:	ff d0                	callq  *%rax
  80254c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802550:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802554:	48 89 c7             	mov    %rax,%rdi
  802557:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
  802563:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256b:	48 c1 e8 15          	shr    $0x15,%rax
  80256f:	48 89 c2             	mov    %rax,%rdx
  802572:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802579:	01 00 00 
  80257c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802580:	83 e0 01             	and    $0x1,%eax
  802583:	48 85 c0             	test   %rax,%rax
  802586:	74 71                	je     8025f9 <dup+0x11b>
  802588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258c:	48 c1 e8 0c          	shr    $0xc,%rax
  802590:	48 89 c2             	mov    %rax,%rdx
  802593:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80259a:	01 00 00 
  80259d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a1:	83 e0 01             	and    $0x1,%eax
  8025a4:	48 85 c0             	test   %rax,%rax
  8025a7:	74 50                	je     8025f9 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b1:	48 89 c2             	mov    %rax,%rdx
  8025b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025bb:	01 00 00 
  8025be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8025c7:	89 c1                	mov    %eax,%ecx
  8025c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d1:	41 89 c8             	mov    %ecx,%r8d
  8025d4:	48 89 d1             	mov    %rdx,%rcx
  8025d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025dc:	48 89 c6             	mov    %rax,%rsi
  8025df:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e4:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  8025eb:	00 00 00 
  8025ee:	ff d0                	callq  *%rax
  8025f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f7:	78 55                	js     80264e <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802601:	48 89 c2             	mov    %rax,%rdx
  802604:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80260b:	01 00 00 
  80260e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802612:	25 07 0e 00 00       	and    $0xe07,%eax
  802617:	89 c1                	mov    %eax,%ecx
  802619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802621:	41 89 c8             	mov    %ecx,%r8d
  802624:	48 89 d1             	mov    %rdx,%rcx
  802627:	ba 00 00 00 00       	mov    $0x0,%edx
  80262c:	48 89 c6             	mov    %rax,%rsi
  80262f:	bf 00 00 00 00       	mov    $0x0,%edi
  802634:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	78 08                	js     802651 <dup+0x173>
		goto err;

	return newfdnum;
  802649:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80264c:	eb 37                	jmp    802685 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80264e:	90                   	nop
  80264f:	eb 01                	jmp    802652 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802651:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802656:	48 89 c6             	mov    %rax,%rsi
  802659:	bf 00 00 00 00       	mov    $0x0,%edi
  80265e:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80266a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80266e:	48 89 c6             	mov    %rax,%rsi
  802671:	bf 00 00 00 00       	mov    $0x0,%edi
  802676:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  80267d:	00 00 00 
  802680:	ff d0                	callq  *%rax
	return r;
  802682:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802685:	c9                   	leaveq 
  802686:	c3                   	retq   

0000000000802687 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802687:	55                   	push   %rbp
  802688:	48 89 e5             	mov    %rsp,%rbp
  80268b:	48 83 ec 40          	sub    $0x40,%rsp
  80268f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802692:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802696:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80269a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80269e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026a1:	48 89 d6             	mov    %rdx,%rsi
  8026a4:	89 c7                	mov    %eax,%edi
  8026a6:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
  8026b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b9:	78 24                	js     8026df <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bf:	8b 00                	mov    (%rax),%eax
  8026c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026c5:	48 89 d6             	mov    %rdx,%rsi
  8026c8:	89 c7                	mov    %eax,%edi
  8026ca:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  8026d1:	00 00 00 
  8026d4:	ff d0                	callq  *%rax
  8026d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026dd:	79 05                	jns    8026e4 <read+0x5d>
		return r;
  8026df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e2:	eb 76                	jmp    80275a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e8:	8b 40 08             	mov    0x8(%rax),%eax
  8026eb:	83 e0 03             	and    $0x3,%eax
  8026ee:	83 f8 01             	cmp    $0x1,%eax
  8026f1:	75 3a                	jne    80272d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026f3:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8026fa:	00 00 00 
  8026fd:	48 8b 00             	mov    (%rax),%rax
  802700:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802706:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802709:	89 c6                	mov    %eax,%esi
  80270b:	48 bf 27 4c 80 00 00 	movabs $0x804c27,%rdi
  802712:	00 00 00 
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
  80271a:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  802721:	00 00 00 
  802724:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802726:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80272b:	eb 2d                	jmp    80275a <read+0xd3>
	}
	if (!dev->dev_read)
  80272d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802731:	48 8b 40 10          	mov    0x10(%rax),%rax
  802735:	48 85 c0             	test   %rax,%rax
  802738:	75 07                	jne    802741 <read+0xba>
		return -E_NOT_SUPP;
  80273a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80273f:	eb 19                	jmp    80275a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802745:	48 8b 40 10          	mov    0x10(%rax),%rax
  802749:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80274d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802751:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802755:	48 89 cf             	mov    %rcx,%rdi
  802758:	ff d0                	callq  *%rax
}
  80275a:	c9                   	leaveq 
  80275b:	c3                   	retq   

000000000080275c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80275c:	55                   	push   %rbp
  80275d:	48 89 e5             	mov    %rsp,%rbp
  802760:	48 83 ec 30          	sub    $0x30,%rsp
  802764:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802767:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80276b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80276f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802776:	eb 47                	jmp    8027bf <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802778:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277b:	48 98                	cltq   
  80277d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802781:	48 29 c2             	sub    %rax,%rdx
  802784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802787:	48 63 c8             	movslq %eax,%rcx
  80278a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80278e:	48 01 c1             	add    %rax,%rcx
  802791:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802794:	48 89 ce             	mov    %rcx,%rsi
  802797:	89 c7                	mov    %eax,%edi
  802799:	48 b8 87 26 80 00 00 	movabs $0x802687,%rax
  8027a0:	00 00 00 
  8027a3:	ff d0                	callq  *%rax
  8027a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ac:	79 05                	jns    8027b3 <readn+0x57>
			return m;
  8027ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027b1:	eb 1d                	jmp    8027d0 <readn+0x74>
		if (m == 0)
  8027b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027b7:	74 13                	je     8027cc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027bc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c2:	48 98                	cltq   
  8027c4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027c8:	72 ae                	jb     802778 <readn+0x1c>
  8027ca:	eb 01                	jmp    8027cd <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8027cc:	90                   	nop
	}
	return tot;
  8027cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027d0:	c9                   	leaveq 
  8027d1:	c3                   	retq   

00000000008027d2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027d2:	55                   	push   %rbp
  8027d3:	48 89 e5             	mov    %rsp,%rbp
  8027d6:	48 83 ec 40          	sub    $0x40,%rsp
  8027da:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027e1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027ec:	48 89 d6             	mov    %rdx,%rsi
  8027ef:	89 c7                	mov    %eax,%edi
  8027f1:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
  8027fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802800:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802804:	78 24                	js     80282a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280a:	8b 00                	mov    (%rax),%eax
  80280c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802810:	48 89 d6             	mov    %rdx,%rsi
  802813:	89 c7                	mov    %eax,%edi
  802815:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	callq  *%rax
  802821:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802824:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802828:	79 05                	jns    80282f <write+0x5d>
		return r;
  80282a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282d:	eb 75                	jmp    8028a4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80282f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802833:	8b 40 08             	mov    0x8(%rax),%eax
  802836:	83 e0 03             	and    $0x3,%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	75 3a                	jne    802877 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80283d:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802844:	00 00 00 
  802847:	48 8b 00             	mov    (%rax),%rax
  80284a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802850:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802853:	89 c6                	mov    %eax,%esi
  802855:	48 bf 43 4c 80 00 00 	movabs $0x804c43,%rdi
  80285c:	00 00 00 
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  80286b:	00 00 00 
  80286e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802870:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802875:	eb 2d                	jmp    8028a4 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80287f:	48 85 c0             	test   %rax,%rax
  802882:	75 07                	jne    80288b <write+0xb9>
		return -E_NOT_SUPP;
  802884:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802889:	eb 19                	jmp    8028a4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80288b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802893:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802897:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80289b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80289f:	48 89 cf             	mov    %rcx,%rdi
  8028a2:	ff d0                	callq  *%rax
}
  8028a4:	c9                   	leaveq 
  8028a5:	c3                   	retq   

00000000008028a6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028a6:	55                   	push   %rbp
  8028a7:	48 89 e5             	mov    %rsp,%rbp
  8028aa:	48 83 ec 18          	sub    $0x18,%rsp
  8028ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028bb:	48 89 d6             	mov    %rdx,%rsi
  8028be:	89 c7                	mov    %eax,%edi
  8028c0:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  8028c7:	00 00 00 
  8028ca:	ff d0                	callq  *%rax
  8028cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d3:	79 05                	jns    8028da <seek+0x34>
		return r;
  8028d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d8:	eb 0f                	jmp    8028e9 <seek+0x43>
	fd->fd_offset = offset;
  8028da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028e1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e9:	c9                   	leaveq 
  8028ea:	c3                   	retq   

00000000008028eb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	48 83 ec 30          	sub    $0x30,%rsp
  8028f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028f9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802900:	48 89 d6             	mov    %rdx,%rsi
  802903:	89 c7                	mov    %eax,%edi
  802905:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	callq  *%rax
  802911:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802918:	78 24                	js     80293e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80291a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291e:	8b 00                	mov    (%rax),%eax
  802920:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802924:	48 89 d6             	mov    %rdx,%rsi
  802927:	89 c7                	mov    %eax,%edi
  802929:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  802930:	00 00 00 
  802933:	ff d0                	callq  *%rax
  802935:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802938:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293c:	79 05                	jns    802943 <ftruncate+0x58>
		return r;
  80293e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802941:	eb 72                	jmp    8029b5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802947:	8b 40 08             	mov    0x8(%rax),%eax
  80294a:	83 e0 03             	and    $0x3,%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	75 3a                	jne    80298b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802951:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802958:	00 00 00 
  80295b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80295e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802964:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802967:	89 c6                	mov    %eax,%esi
  802969:	48 bf 60 4c 80 00 00 	movabs $0x804c60,%rdi
  802970:	00 00 00 
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  80297f:	00 00 00 
  802982:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802984:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802989:	eb 2a                	jmp    8029b5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802993:	48 85 c0             	test   %rax,%rax
  802996:	75 07                	jne    80299f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802998:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80299d:	eb 16                	jmp    8029b5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80299f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ab:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029ae:	89 ce                	mov    %ecx,%esi
  8029b0:	48 89 d7             	mov    %rdx,%rdi
  8029b3:	ff d0                	callq  *%rax
}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   

00000000008029b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 30          	sub    $0x30,%rsp
  8029bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cd:	48 89 d6             	mov    %rdx,%rsi
  8029d0:	89 c7                	mov    %eax,%edi
  8029d2:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e5:	78 24                	js     802a0b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029eb:	8b 00                	mov    (%rax),%eax
  8029ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f1:	48 89 d6             	mov    %rdx,%rsi
  8029f4:	89 c7                	mov    %eax,%edi
  8029f6:	48 b8 ad 23 80 00 00 	movabs $0x8023ad,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
  802a02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a09:	79 05                	jns    802a10 <fstat+0x59>
		return r;
  802a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0e:	eb 5e                	jmp    802a6e <fstat+0xb7>
	if (!dev->dev_stat)
  802a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a14:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a18:	48 85 c0             	test   %rax,%rax
  802a1b:	75 07                	jne    802a24 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a1d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a22:	eb 4a                	jmp    802a6e <fstat+0xb7>
	stat->st_name[0] = 0;
  802a24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a28:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a2f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a36:	00 00 00 
	stat->st_isdir = 0;
  802a39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a3d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a44:	00 00 00 
	stat->st_dev = dev;
  802a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a4f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a62:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a66:	48 89 ce             	mov    %rcx,%rsi
  802a69:	48 89 d7             	mov    %rdx,%rdi
  802a6c:	ff d0                	callq  *%rax
}
  802a6e:	c9                   	leaveq 
  802a6f:	c3                   	retq   

0000000000802a70 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a70:	55                   	push   %rbp
  802a71:	48 89 e5             	mov    %rsp,%rbp
  802a74:	48 83 ec 20          	sub    $0x20,%rsp
  802a78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a84:	be 00 00 00 00       	mov    $0x0,%esi
  802a89:	48 89 c7             	mov    %rax,%rdi
  802a8c:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	callq  *%rax
  802a98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9f:	79 05                	jns    802aa6 <stat+0x36>
		return fd;
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa4:	eb 2f                	jmp    802ad5 <stat+0x65>
	r = fstat(fd, stat);
  802aa6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802aaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aad:	48 89 d6             	mov    %rdx,%rsi
  802ab0:	89 c7                	mov    %eax,%edi
  802ab2:	48 b8 b7 29 80 00 00 	movabs $0x8029b7,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
  802abe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
	return r;
  802ad2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ad5:	c9                   	leaveq 
  802ad6:	c3                   	retq   

0000000000802ad7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ad7:	55                   	push   %rbp
  802ad8:	48 89 e5             	mov    %rsp,%rbp
  802adb:	48 83 ec 10          	sub    $0x10,%rsp
  802adf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ae2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ae6:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802aed:	00 00 00 
  802af0:	8b 00                	mov    (%rax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	75 1f                	jne    802b15 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802af6:	bf 01 00 00 00       	mov    $0x1,%edi
  802afb:	48 b8 3b 45 80 00 00 	movabs $0x80453b,%rax
  802b02:	00 00 00 
  802b05:	ff d0                	callq  *%rax
  802b07:	89 c2                	mov    %eax,%edx
  802b09:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802b10:	00 00 00 
  802b13:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b15:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802b1c:	00 00 00 
  802b1f:	8b 00                	mov    (%rax),%eax
  802b21:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b24:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b29:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b30:	00 00 00 
  802b33:	89 c7                	mov    %eax,%edi
  802b35:	48 b8 2f 43 80 00 00 	movabs $0x80432f,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b45:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4a:	48 89 c6             	mov    %rax,%rsi
  802b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b52:	48 b8 6e 42 80 00 00 	movabs $0x80426e,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
}
  802b5e:	c9                   	leaveq 
  802b5f:	c3                   	retq   

0000000000802b60 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b60:	55                   	push   %rbp
  802b61:	48 89 e5             	mov    %rsp,%rbp
  802b64:	48 83 ec 20          	sub    $0x20,%rsp
  802b68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b6c:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b73:	48 89 c7             	mov    %rax,%rdi
  802b76:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
  802b82:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b87:	7e 0a                	jle    802b93 <open+0x33>
		return -E_BAD_PATH;
  802b89:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b8e:	e9 a5 00 00 00       	jmpq   802c38 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802b93:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b97:	48 89 c7             	mov    %rax,%rdi
  802b9a:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
  802ba6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bad:	79 08                	jns    802bb7 <open+0x57>
		return r;
  802baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb2:	e9 81 00 00 00       	jmpq   802c38 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbb:	48 89 c6             	mov    %rax,%rsi
  802bbe:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bc5:	00 00 00 
  802bc8:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802bd4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bdb:	00 00 00 
  802bde:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802be1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802beb:	48 89 c6             	mov    %rax,%rsi
  802bee:	bf 01 00 00 00       	mov    $0x1,%edi
  802bf3:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
  802bff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c06:	79 1d                	jns    802c25 <open+0xc5>
		fd_close(fd, 0);
  802c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0c:	be 00 00 00 00       	mov    $0x0,%esi
  802c11:	48 89 c7             	mov    %rax,%rdi
  802c14:	48 b8 e2 22 80 00 00 	movabs $0x8022e2,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
		return r;
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c23:	eb 13                	jmp    802c38 <open+0xd8>
	}

	return fd2num(fd);
  802c25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c29:	48 89 c7             	mov    %rax,%rdi
  802c2c:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax

}
  802c38:	c9                   	leaveq 
  802c39:	c3                   	retq   

0000000000802c3a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c3a:	55                   	push   %rbp
  802c3b:	48 89 e5             	mov    %rsp,%rbp
  802c3e:	48 83 ec 10          	sub    $0x10,%rsp
  802c42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c4a:	8b 50 0c             	mov    0xc(%rax),%edx
  802c4d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c54:	00 00 00 
  802c57:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c59:	be 00 00 00 00       	mov    $0x0,%esi
  802c5e:	bf 06 00 00 00       	mov    $0x6,%edi
  802c63:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	callq  *%rax
}
  802c6f:	c9                   	leaveq 
  802c70:	c3                   	retq   

0000000000802c71 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c71:	55                   	push   %rbp
  802c72:	48 89 e5             	mov    %rsp,%rbp
  802c75:	48 83 ec 30          	sub    $0x30,%rsp
  802c79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c81:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c89:	8b 50 0c             	mov    0xc(%rax),%edx
  802c8c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c93:	00 00 00 
  802c96:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c98:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c9f:	00 00 00 
  802ca2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ca6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802caa:	be 00 00 00 00       	mov    $0x0,%esi
  802caf:	bf 03 00 00 00       	mov    $0x3,%edi
  802cb4:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802cbb:	00 00 00 
  802cbe:	ff d0                	callq  *%rax
  802cc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc7:	79 08                	jns    802cd1 <devfile_read+0x60>
		return r;
  802cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccc:	e9 a4 00 00 00       	jmpq   802d75 <devfile_read+0x104>
	assert(r <= n);
  802cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd4:	48 98                	cltq   
  802cd6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cda:	76 35                	jbe    802d11 <devfile_read+0xa0>
  802cdc:	48 b9 86 4c 80 00 00 	movabs $0x804c86,%rcx
  802ce3:	00 00 00 
  802ce6:	48 ba 8d 4c 80 00 00 	movabs $0x804c8d,%rdx
  802ced:	00 00 00 
  802cf0:	be 86 00 00 00       	mov    $0x86,%esi
  802cf5:	48 bf a2 4c 80 00 00 	movabs $0x804ca2,%rdi
  802cfc:	00 00 00 
  802cff:	b8 00 00 00 00       	mov    $0x0,%eax
  802d04:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  802d0b:	00 00 00 
  802d0e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802d11:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802d18:	7e 35                	jle    802d4f <devfile_read+0xde>
  802d1a:	48 b9 ad 4c 80 00 00 	movabs $0x804cad,%rcx
  802d21:	00 00 00 
  802d24:	48 ba 8d 4c 80 00 00 	movabs $0x804c8d,%rdx
  802d2b:	00 00 00 
  802d2e:	be 87 00 00 00       	mov    $0x87,%esi
  802d33:	48 bf a2 4c 80 00 00 	movabs $0x804ca2,%rdi
  802d3a:	00 00 00 
  802d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d42:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  802d49:	00 00 00 
  802d4c:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d52:	48 63 d0             	movslq %eax,%rdx
  802d55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d59:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d60:	00 00 00 
  802d63:	48 89 c7             	mov    %rax,%rdi
  802d66:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
	return r;
  802d72:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802d75:	c9                   	leaveq 
  802d76:	c3                   	retq   

0000000000802d77 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d77:	55                   	push   %rbp
  802d78:	48 89 e5             	mov    %rsp,%rbp
  802d7b:	48 83 ec 40          	sub    $0x40,%rsp
  802d7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d83:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d87:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802d8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802d93:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802d9a:	00 
  802d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802da3:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802da8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802dac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802db0:	8b 50 0c             	mov    0xc(%rax),%edx
  802db3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dba:	00 00 00 
  802dbd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802dbf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc6:	00 00 00 
  802dc9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dcd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802dd1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd9:	48 89 c6             	mov    %rax,%rsi
  802ddc:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802de3:	00 00 00 
  802de6:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802df2:	be 00 00 00 00       	mov    $0x0,%esi
  802df7:	bf 04 00 00 00       	mov    $0x4,%edi
  802dfc:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802e03:	00 00 00 
  802e06:	ff d0                	callq  *%rax
  802e08:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e0f:	79 05                	jns    802e16 <devfile_write+0x9f>
		return r;
  802e11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e14:	eb 43                	jmp    802e59 <devfile_write+0xe2>
	assert(r <= n);
  802e16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e19:	48 98                	cltq   
  802e1b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e1f:	76 35                	jbe    802e56 <devfile_write+0xdf>
  802e21:	48 b9 86 4c 80 00 00 	movabs $0x804c86,%rcx
  802e28:	00 00 00 
  802e2b:	48 ba 8d 4c 80 00 00 	movabs $0x804c8d,%rdx
  802e32:	00 00 00 
  802e35:	be a2 00 00 00       	mov    $0xa2,%esi
  802e3a:	48 bf a2 4c 80 00 00 	movabs $0x804ca2,%rdi
  802e41:	00 00 00 
  802e44:	b8 00 00 00 00       	mov    $0x0,%eax
  802e49:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  802e50:	00 00 00 
  802e53:	41 ff d0             	callq  *%r8
	return r;
  802e56:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802e59:	c9                   	leaveq 
  802e5a:	c3                   	retq   

0000000000802e5b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e5b:	55                   	push   %rbp
  802e5c:	48 89 e5             	mov    %rsp,%rbp
  802e5f:	48 83 ec 20          	sub    $0x20,%rsp
  802e63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6f:	8b 50 0c             	mov    0xc(%rax),%edx
  802e72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e79:	00 00 00 
  802e7c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e7e:	be 00 00 00 00       	mov    $0x0,%esi
  802e83:	bf 05 00 00 00       	mov    $0x5,%edi
  802e88:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9b:	79 05                	jns    802ea2 <devfile_stat+0x47>
		return r;
  802e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea0:	eb 56                	jmp    802ef8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ea2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ead:	00 00 00 
  802eb0:	48 89 c7             	mov    %rax,%rdi
  802eb3:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ebf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec6:	00 00 00 
  802ec9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ecf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ed9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee0:	00 00 00 
  802ee3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ee9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eed:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef8:	c9                   	leaveq 
  802ef9:	c3                   	retq   

0000000000802efa <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
  802efe:	48 83 ec 10          	sub    $0x10,%rsp
  802f02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f06:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f10:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f17:	00 00 00 
  802f1a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f23:	00 00 00 
  802f26:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f29:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f2c:	be 00 00 00 00       	mov    $0x0,%esi
  802f31:	bf 02 00 00 00       	mov    $0x2,%edi
  802f36:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
}
  802f42:	c9                   	leaveq 
  802f43:	c3                   	retq   

0000000000802f44 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f44:	55                   	push   %rbp
  802f45:	48 89 e5             	mov    %rsp,%rbp
  802f48:	48 83 ec 10          	sub    $0x10,%rsp
  802f4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f54:	48 89 c7             	mov    %rax,%rdi
  802f57:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  802f5e:	00 00 00 
  802f61:	ff d0                	callq  *%rax
  802f63:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f68:	7e 07                	jle    802f71 <remove+0x2d>
		return -E_BAD_PATH;
  802f6a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f6f:	eb 33                	jmp    802fa4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f75:	48 89 c6             	mov    %rax,%rsi
  802f78:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f7f:	00 00 00 
  802f82:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f8e:	be 00 00 00 00       	mov    $0x0,%esi
  802f93:	bf 07 00 00 00       	mov    $0x7,%edi
  802f98:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
}
  802fa4:	c9                   	leaveq 
  802fa5:	c3                   	retq   

0000000000802fa6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802faa:	be 00 00 00 00       	mov    $0x0,%esi
  802faf:	bf 08 00 00 00       	mov    $0x8,%edi
  802fb4:	48 b8 d7 2a 80 00 00 	movabs $0x802ad7,%rax
  802fbb:	00 00 00 
  802fbe:	ff d0                	callq  *%rax
}
  802fc0:	5d                   	pop    %rbp
  802fc1:	c3                   	retq   

0000000000802fc2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fc2:	55                   	push   %rbp
  802fc3:	48 89 e5             	mov    %rsp,%rbp
  802fc6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fcd:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fd4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802fdb:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802fe2:	be 00 00 00 00       	mov    $0x0,%esi
  802fe7:	48 89 c7             	mov    %rax,%rdi
  802fea:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
  802ff6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffd:	79 28                	jns    803027 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803002:	89 c6                	mov    %eax,%esi
  803004:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  80300b:	00 00 00 
  80300e:	b8 00 00 00 00       	mov    $0x0,%eax
  803013:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  80301a:	00 00 00 
  80301d:	ff d2                	callq  *%rdx
		return fd_src;
  80301f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803022:	e9 76 01 00 00       	jmpq   80319d <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803027:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80302e:	be 01 01 00 00       	mov    $0x101,%esi
  803033:	48 89 c7             	mov    %rax,%rdi
  803036:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
  803042:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803045:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803049:	0f 89 ad 00 00 00    	jns    8030fc <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80304f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803052:	89 c6                	mov    %eax,%esi
  803054:	48 bf cf 4c 80 00 00 	movabs $0x804ccf,%rdi
  80305b:	00 00 00 
  80305e:	b8 00 00 00 00       	mov    $0x0,%eax
  803063:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  80306a:	00 00 00 
  80306d:	ff d2                	callq  *%rdx
		close(fd_src);
  80306f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
		return fd_dest;
  803080:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803083:	e9 15 01 00 00       	jmpq   80319d <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803088:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80308b:	48 63 d0             	movslq %eax,%rdx
  80308e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803095:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803098:	48 89 ce             	mov    %rcx,%rsi
  80309b:	89 c7                	mov    %eax,%edi
  80309d:	48 b8 d2 27 80 00 00 	movabs $0x8027d2,%rax
  8030a4:	00 00 00 
  8030a7:	ff d0                	callq  *%rax
  8030a9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030b0:	79 4a                	jns    8030fc <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8030b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030b5:	89 c6                	mov    %eax,%esi
  8030b7:	48 bf e9 4c 80 00 00 	movabs $0x804ce9,%rdi
  8030be:	00 00 00 
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c6:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  8030cd:	00 00 00 
  8030d0:	ff d2                	callq  *%rdx
			close(fd_src);
  8030d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d5:	89 c7                	mov    %eax,%edi
  8030d7:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  8030de:	00 00 00 
  8030e1:	ff d0                	callq  *%rax
			close(fd_dest);
  8030e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e6:	89 c7                	mov    %eax,%edi
  8030e8:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
			return write_size;
  8030f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030f7:	e9 a1 00 00 00       	jmpq   80319d <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030fc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803106:	ba 00 02 00 00       	mov    $0x200,%edx
  80310b:	48 89 ce             	mov    %rcx,%rsi
  80310e:	89 c7                	mov    %eax,%edi
  803110:	48 b8 87 26 80 00 00 	movabs $0x802687,%rax
  803117:	00 00 00 
  80311a:	ff d0                	callq  *%rax
  80311c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80311f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803123:	0f 8f 5f ff ff ff    	jg     803088 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803129:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80312d:	79 47                	jns    803176 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80312f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803132:	89 c6                	mov    %eax,%esi
  803134:	48 bf fc 4c 80 00 00 	movabs $0x804cfc,%rdi
  80313b:	00 00 00 
  80313e:	b8 00 00 00 00       	mov    $0x0,%eax
  803143:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  80314a:	00 00 00 
  80314d:	ff d2                	callq  *%rdx
		close(fd_src);
  80314f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803152:	89 c7                	mov    %eax,%edi
  803154:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
		close(fd_dest);
  803160:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803163:	89 c7                	mov    %eax,%edi
  803165:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
		return read_size;
  803171:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803174:	eb 27                	jmp    80319d <copy+0x1db>
	}
	close(fd_src);
  803176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803179:	89 c7                	mov    %eax,%edi
  80317b:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
	close(fd_dest);
  803187:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80318a:	89 c7                	mov    %eax,%edi
  80318c:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  803193:	00 00 00 
  803196:	ff d0                	callq  *%rax
	return 0;
  803198:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 20          	sub    $0x20,%rsp
  8031a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8031ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031af:	8b 40 0c             	mov    0xc(%rax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	7e 67                	jle    80321d <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8031b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ba:	8b 40 04             	mov    0x4(%rax),%eax
  8031bd:	48 63 d0             	movslq %eax,%rdx
  8031c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c4:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8031c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cc:	8b 00                	mov    (%rax),%eax
  8031ce:	48 89 ce             	mov    %rcx,%rsi
  8031d1:	89 c7                	mov    %eax,%edi
  8031d3:	48 b8 d2 27 80 00 00 	movabs $0x8027d2,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
  8031df:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8031e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e6:	7e 13                	jle    8031fb <writebuf+0x5c>
			b->result += result;
  8031e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ec:	8b 50 08             	mov    0x8(%rax),%edx
  8031ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f2:	01 c2                	add    %eax,%edx
  8031f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f8:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8031fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ff:	8b 40 04             	mov    0x4(%rax),%eax
  803202:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803205:	74 16                	je     80321d <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803207:	b8 00 00 00 00       	mov    $0x0,%eax
  80320c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803210:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803214:	89 c2                	mov    %eax,%edx
  803216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321a:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80321d:	90                   	nop
  80321e:	c9                   	leaveq 
  80321f:	c3                   	retq   

0000000000803220 <putch>:

static void
putch(int ch, void *thunk)
{
  803220:	55                   	push   %rbp
  803221:	48 89 e5             	mov    %rsp,%rbp
  803224:	48 83 ec 20          	sub    $0x20,%rsp
  803228:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80322b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80322f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803233:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323b:	8b 40 04             	mov    0x4(%rax),%eax
  80323e:	8d 48 01             	lea    0x1(%rax),%ecx
  803241:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803245:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803248:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80324b:	89 d1                	mov    %edx,%ecx
  80324d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803251:	48 98                	cltq   
  803253:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803257:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80325b:	8b 40 04             	mov    0x4(%rax),%eax
  80325e:	3d 00 01 00 00       	cmp    $0x100,%eax
  803263:	75 1e                	jne    803283 <putch+0x63>
		writebuf(b);
  803265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803269:	48 89 c7             	mov    %rax,%rdi
  80326c:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
		b->idx = 0;
  803278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80327c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803283:	90                   	nop
  803284:	c9                   	leaveq 
  803285:	c3                   	retq   

0000000000803286 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803286:	55                   	push   %rbp
  803287:	48 89 e5             	mov    %rsp,%rbp
  80328a:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803291:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803297:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80329e:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8032a5:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8032ab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8032b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8032b8:	00 00 00 
	b.result = 0;
  8032bb:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8032c2:	00 00 00 
	b.error = 1;
  8032c5:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8032cc:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8032cf:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8032d6:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8032dd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8032e4:	48 89 c6             	mov    %rax,%rsi
  8032e7:	48 bf 20 32 80 00 00 	movabs $0x803220,%rdi
  8032ee:	00 00 00 
  8032f1:	48 b8 ea 0a 80 00 00 	movabs $0x800aea,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8032fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803303:	85 c0                	test   %eax,%eax
  803305:	7e 16                	jle    80331d <vfprintf+0x97>
		writebuf(&b);
  803307:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80330e:	48 89 c7             	mov    %rax,%rdi
  803311:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80331d:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 08                	je     80332f <vfprintf+0xa9>
  803327:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80332d:	eb 06                	jmp    803335 <vfprintf+0xaf>
  80332f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803335:	c9                   	leaveq 
  803336:	c3                   	retq   

0000000000803337 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803337:	55                   	push   %rbp
  803338:	48 89 e5             	mov    %rsp,%rbp
  80333b:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803342:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803348:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80334f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803356:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80335d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803364:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80336b:	84 c0                	test   %al,%al
  80336d:	74 20                	je     80338f <fprintf+0x58>
  80336f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803373:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803377:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80337b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80337f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803383:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803387:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80338b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80338f:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803396:	00 00 00 
  803399:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033a0:	00 00 00 
  8033a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033a7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033ae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033b5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8033bc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033c3:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8033ca:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033d0:	48 89 ce             	mov    %rcx,%rsi
  8033d3:	89 c7                	mov    %eax,%edi
  8033d5:	48 b8 86 32 80 00 00 	movabs $0x803286,%rax
  8033dc:	00 00 00 
  8033df:	ff d0                	callq  *%rax
  8033e1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033e7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033ed:	c9                   	leaveq 
  8033ee:	c3                   	retq   

00000000008033ef <printf>:

int
printf(const char *fmt, ...)
{
  8033ef:	55                   	push   %rbp
  8033f0:	48 89 e5             	mov    %rsp,%rbp
  8033f3:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8033fa:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803401:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803408:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80340f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803416:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80341d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803424:	84 c0                	test   %al,%al
  803426:	74 20                	je     803448 <printf+0x59>
  803428:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80342c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803430:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803434:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803438:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80343c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803440:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803444:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803448:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80344f:	00 00 00 
  803452:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803459:	00 00 00 
  80345c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803460:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803467:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80346e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  803475:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80347c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803483:	48 89 c6             	mov    %rax,%rsi
  803486:	bf 01 00 00 00       	mov    $0x1,%edi
  80348b:	48 b8 86 32 80 00 00 	movabs $0x803286,%rax
  803492:	00 00 00 
  803495:	ff d0                	callq  *%rax
  803497:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  80349d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034a3:	c9                   	leaveq 
  8034a4:	c3                   	retq   

00000000008034a5 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034a5:	55                   	push   %rbp
  8034a6:	48 89 e5             	mov    %rsp,%rbp
  8034a9:	48 83 ec 20          	sub    $0x20,%rsp
  8034ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b7:	48 89 d6             	mov    %rdx,%rsi
  8034ba:	89 c7                	mov    %eax,%edi
  8034bc:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
  8034c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034cf:	79 05                	jns    8034d6 <fd2sockid+0x31>
		return r;
  8034d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d4:	eb 24                	jmp    8034fa <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034da:	8b 10                	mov    (%rax),%edx
  8034dc:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8034e3:	00 00 00 
  8034e6:	8b 00                	mov    (%rax),%eax
  8034e8:	39 c2                	cmp    %eax,%edx
  8034ea:	74 07                	je     8034f3 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034ec:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034f1:	eb 07                	jmp    8034fa <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f7:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034fa:	c9                   	leaveq 
  8034fb:	c3                   	retq   

00000000008034fc <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034fc:	55                   	push   %rbp
  8034fd:	48 89 e5             	mov    %rsp,%rbp
  803500:	48 83 ec 20          	sub    $0x20,%rsp
  803504:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803507:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80350b:	48 89 c7             	mov    %rax,%rdi
  80350e:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
  80351a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80351d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803521:	78 26                	js     803549 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803527:	ba 07 04 00 00       	mov    $0x407,%edx
  80352c:	48 89 c6             	mov    %rax,%rsi
  80352f:	bf 00 00 00 00       	mov    $0x0,%edi
  803534:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  80353b:	00 00 00 
  80353e:	ff d0                	callq  *%rax
  803540:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803543:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803547:	79 16                	jns    80355f <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80354c:	89 c7                	mov    %eax,%edi
  80354e:	48 b8 0b 3a 80 00 00 	movabs $0x803a0b,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
		return r;
  80355a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355d:	eb 3a                	jmp    803599 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80355f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803563:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80356a:	00 00 00 
  80356d:	8b 12                	mov    (%rdx),%edx
  80356f:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803575:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80357c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803580:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803583:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358a:	48 89 c7             	mov    %rax,%rdi
  80358d:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
}
  803599:	c9                   	leaveq 
  80359a:	c3                   	retq   

000000000080359b <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80359b:	55                   	push   %rbp
  80359c:	48 89 e5             	mov    %rsp,%rbp
  80359f:	48 83 ec 30          	sub    $0x30,%rsp
  8035a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b1:	89 c7                	mov    %eax,%edi
  8035b3:	48 b8 a5 34 80 00 00 	movabs $0x8034a5,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c6:	79 05                	jns    8035cd <accept+0x32>
		return r;
  8035c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cb:	eb 3b                	jmp    803608 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035d1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d8:	48 89 ce             	mov    %rcx,%rsi
  8035db:	89 c7                	mov    %eax,%edi
  8035dd:	48 b8 e8 38 80 00 00 	movabs $0x8038e8,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
  8035e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f0:	79 05                	jns    8035f7 <accept+0x5c>
		return r;
  8035f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f5:	eb 11                	jmp    803608 <accept+0x6d>
	return alloc_sockfd(r);
  8035f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fa:	89 c7                	mov    %eax,%edi
  8035fc:	48 b8 fc 34 80 00 00 	movabs $0x8034fc,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
}
  803608:	c9                   	leaveq 
  803609:	c3                   	retq   

000000000080360a <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80360a:	55                   	push   %rbp
  80360b:	48 89 e5             	mov    %rsp,%rbp
  80360e:	48 83 ec 20          	sub    $0x20,%rsp
  803612:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803615:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803619:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80361c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361f:	89 c7                	mov    %eax,%edi
  803621:	48 b8 a5 34 80 00 00 	movabs $0x8034a5,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
  80362d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803634:	79 05                	jns    80363b <bind+0x31>
		return r;
  803636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803639:	eb 1b                	jmp    803656 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80363b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80363e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	48 89 ce             	mov    %rcx,%rsi
  803648:	89 c7                	mov    %eax,%edi
  80364a:	48 b8 67 39 80 00 00 	movabs $0x803967,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
}
  803656:	c9                   	leaveq 
  803657:	c3                   	retq   

0000000000803658 <shutdown>:

int
shutdown(int s, int how)
{
  803658:	55                   	push   %rbp
  803659:	48 89 e5             	mov    %rsp,%rbp
  80365c:	48 83 ec 20          	sub    $0x20,%rsp
  803660:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803663:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803666:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803669:	89 c7                	mov    %eax,%edi
  80366b:	48 b8 a5 34 80 00 00 	movabs $0x8034a5,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
  803677:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367e:	79 05                	jns    803685 <shutdown+0x2d>
		return r;
  803680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803683:	eb 16                	jmp    80369b <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803688:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368b:	89 d6                	mov    %edx,%esi
  80368d:	89 c7                	mov    %eax,%edi
  80368f:	48 b8 cb 39 80 00 00 	movabs $0x8039cb,%rax
  803696:	00 00 00 
  803699:	ff d0                	callq  *%rax
}
  80369b:	c9                   	leaveq 
  80369c:	c3                   	retq   

000000000080369d <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80369d:	55                   	push   %rbp
  80369e:	48 89 e5             	mov    %rsp,%rbp
  8036a1:	48 83 ec 10          	sub    $0x10,%rsp
  8036a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ad:	48 89 c7             	mov    %rax,%rdi
  8036b0:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
  8036bc:	83 f8 01             	cmp    $0x1,%eax
  8036bf:	75 17                	jne    8036d8 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c5:	8b 40 0c             	mov    0xc(%rax),%eax
  8036c8:	89 c7                	mov    %eax,%edi
  8036ca:	48 b8 0b 3a 80 00 00 	movabs $0x803a0b,%rax
  8036d1:	00 00 00 
  8036d4:	ff d0                	callq  *%rax
  8036d6:	eb 05                	jmp    8036dd <devsock_close+0x40>
	else
		return 0;
  8036d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036dd:	c9                   	leaveq 
  8036de:	c3                   	retq   

00000000008036df <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036df:	55                   	push   %rbp
  8036e0:	48 89 e5             	mov    %rsp,%rbp
  8036e3:	48 83 ec 20          	sub    $0x20,%rsp
  8036e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036ee:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f4:	89 c7                	mov    %eax,%edi
  8036f6:	48 b8 a5 34 80 00 00 	movabs $0x8034a5,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
  803702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803709:	79 05                	jns    803710 <connect+0x31>
		return r;
  80370b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370e:	eb 1b                	jmp    80372b <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803710:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803713:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371a:	48 89 ce             	mov    %rcx,%rsi
  80371d:	89 c7                	mov    %eax,%edi
  80371f:	48 b8 38 3a 80 00 00 	movabs $0x803a38,%rax
  803726:	00 00 00 
  803729:	ff d0                	callq  *%rax
}
  80372b:	c9                   	leaveq 
  80372c:	c3                   	retq   

000000000080372d <listen>:

int
listen(int s, int backlog)
{
  80372d:	55                   	push   %rbp
  80372e:	48 89 e5             	mov    %rsp,%rbp
  803731:	48 83 ec 20          	sub    $0x20,%rsp
  803735:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803738:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80373b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80373e:	89 c7                	mov    %eax,%edi
  803740:	48 b8 a5 34 80 00 00 	movabs $0x8034a5,%rax
  803747:	00 00 00 
  80374a:	ff d0                	callq  *%rax
  80374c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803753:	79 05                	jns    80375a <listen+0x2d>
		return r;
  803755:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803758:	eb 16                	jmp    803770 <listen+0x43>
	return nsipc_listen(r, backlog);
  80375a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80375d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803760:	89 d6                	mov    %edx,%esi
  803762:	89 c7                	mov    %eax,%edi
  803764:	48 b8 9c 3a 80 00 00 	movabs $0x803a9c,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
}
  803770:	c9                   	leaveq 
  803771:	c3                   	retq   

0000000000803772 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803772:	55                   	push   %rbp
  803773:	48 89 e5             	mov    %rsp,%rbp
  803776:	48 83 ec 20          	sub    $0x20,%rsp
  80377a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80377e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803782:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378a:	89 c2                	mov    %eax,%edx
  80378c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803790:	8b 40 0c             	mov    0xc(%rax),%eax
  803793:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803797:	b9 00 00 00 00       	mov    $0x0,%ecx
  80379c:	89 c7                	mov    %eax,%edi
  80379e:	48 b8 dc 3a 80 00 00 	movabs $0x803adc,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
}
  8037aa:	c9                   	leaveq 
  8037ab:	c3                   	retq   

00000000008037ac <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	48 83 ec 20          	sub    $0x20,%rsp
  8037b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c4:	89 c2                	mov    %eax,%edx
  8037c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ca:	8b 40 0c             	mov    0xc(%rax),%eax
  8037cd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037d6:	89 c7                	mov    %eax,%edi
  8037d8:	48 b8 a8 3b 80 00 00 	movabs $0x803ba8,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
}
  8037e4:	c9                   	leaveq 
  8037e5:	c3                   	retq   

00000000008037e6 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037e6:	55                   	push   %rbp
  8037e7:	48 89 e5             	mov    %rsp,%rbp
  8037ea:	48 83 ec 10          	sub    $0x10,%rsp
  8037ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fa:	48 be 17 4d 80 00 00 	movabs $0x804d17,%rsi
  803801:	00 00 00 
  803804:	48 89 c7             	mov    %rax,%rdi
  803807:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
	return 0;
  803813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803818:	c9                   	leaveq 
  803819:	c3                   	retq   

000000000080381a <socket>:

int
socket(int domain, int type, int protocol)
{
  80381a:	55                   	push   %rbp
  80381b:	48 89 e5             	mov    %rsp,%rbp
  80381e:	48 83 ec 20          	sub    $0x20,%rsp
  803822:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803825:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803828:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80382b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80382e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803834:	89 ce                	mov    %ecx,%esi
  803836:	89 c7                	mov    %eax,%edi
  803838:	48 b8 60 3c 80 00 00 	movabs $0x803c60,%rax
  80383f:	00 00 00 
  803842:	ff d0                	callq  *%rax
  803844:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803847:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384b:	79 05                	jns    803852 <socket+0x38>
		return r;
  80384d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803850:	eb 11                	jmp    803863 <socket+0x49>
	return alloc_sockfd(r);
  803852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803855:	89 c7                	mov    %eax,%edi
  803857:	48 b8 fc 34 80 00 00 	movabs $0x8034fc,%rax
  80385e:	00 00 00 
  803861:	ff d0                	callq  *%rax
}
  803863:	c9                   	leaveq 
  803864:	c3                   	retq   

0000000000803865 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803865:	55                   	push   %rbp
  803866:	48 89 e5             	mov    %rsp,%rbp
  803869:	48 83 ec 10          	sub    $0x10,%rsp
  80386d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803870:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  803877:	00 00 00 
  80387a:	8b 00                	mov    (%rax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	75 1f                	jne    80389f <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803880:	bf 02 00 00 00       	mov    $0x2,%edi
  803885:	48 b8 3b 45 80 00 00 	movabs $0x80453b,%rax
  80388c:	00 00 00 
  80388f:	ff d0                	callq  *%rax
  803891:	89 c2                	mov    %eax,%edx
  803893:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  80389a:	00 00 00 
  80389d:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80389f:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8038a6:	00 00 00 
  8038a9:	8b 00                	mov    (%rax),%eax
  8038ab:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038ae:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038b3:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8038ba:	00 00 00 
  8038bd:	89 c7                	mov    %eax,%edi
  8038bf:	48 b8 2f 43 80 00 00 	movabs $0x80432f,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8038d0:	be 00 00 00 00       	mov    $0x0,%esi
  8038d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038da:	48 b8 6e 42 80 00 00 	movabs $0x80426e,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
}
  8038e6:	c9                   	leaveq 
  8038e7:	c3                   	retq   

00000000008038e8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038e8:	55                   	push   %rbp
  8038e9:	48 89 e5             	mov    %rsp,%rbp
  8038ec:	48 83 ec 30          	sub    $0x30,%rsp
  8038f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803902:	00 00 00 
  803905:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803908:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80390a:	bf 01 00 00 00       	mov    $0x1,%edi
  80390f:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
  80391b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80391e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803922:	78 3e                	js     803962 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803924:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80392b:	00 00 00 
  80392e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803936:	8b 40 10             	mov    0x10(%rax),%eax
  803939:	89 c2                	mov    %eax,%edx
  80393b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80393f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803943:	48 89 ce             	mov    %rcx,%rsi
  803946:	48 89 c7             	mov    %rax,%rdi
  803949:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803950:	00 00 00 
  803953:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803959:	8b 50 10             	mov    0x10(%rax),%edx
  80395c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803960:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803962:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803965:	c9                   	leaveq 
  803966:	c3                   	retq   

0000000000803967 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803967:	55                   	push   %rbp
  803968:	48 89 e5             	mov    %rsp,%rbp
  80396b:	48 83 ec 10          	sub    $0x10,%rsp
  80396f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803972:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803976:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803979:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803980:	00 00 00 
  803983:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803986:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803988:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80398b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398f:	48 89 c6             	mov    %rax,%rsi
  803992:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803999:	00 00 00 
  80399c:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  8039a3:	00 00 00 
  8039a6:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8039a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039af:	00 00 00 
  8039b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039b5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039b8:	bf 02 00 00 00       	mov    $0x2,%edi
  8039bd:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  8039c4:	00 00 00 
  8039c7:	ff d0                	callq  *%rax
}
  8039c9:	c9                   	leaveq 
  8039ca:	c3                   	retq   

00000000008039cb <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039cb:	55                   	push   %rbp
  8039cc:	48 89 e5             	mov    %rsp,%rbp
  8039cf:	48 83 ec 10          	sub    $0x10,%rsp
  8039d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039d6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e0:	00 00 00 
  8039e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039e6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ef:	00 00 00 
  8039f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039f5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039f8:	bf 03 00 00 00       	mov    $0x3,%edi
  8039fd:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803a04:	00 00 00 
  803a07:	ff d0                	callq  *%rax
}
  803a09:	c9                   	leaveq 
  803a0a:	c3                   	retq   

0000000000803a0b <nsipc_close>:

int
nsipc_close(int s)
{
  803a0b:	55                   	push   %rbp
  803a0c:	48 89 e5             	mov    %rsp,%rbp
  803a0f:	48 83 ec 10          	sub    $0x10,%rsp
  803a13:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a16:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a1d:	00 00 00 
  803a20:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a23:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a25:	bf 04 00 00 00       	mov    $0x4,%edi
  803a2a:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803a31:	00 00 00 
  803a34:	ff d0                	callq  *%rax
}
  803a36:	c9                   	leaveq 
  803a37:	c3                   	retq   

0000000000803a38 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a38:	55                   	push   %rbp
  803a39:	48 89 e5             	mov    %rsp,%rbp
  803a3c:	48 83 ec 10          	sub    $0x10,%rsp
  803a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a47:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a4a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a51:	00 00 00 
  803a54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a57:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a59:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a60:	48 89 c6             	mov    %rax,%rsi
  803a63:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a6a:	00 00 00 
  803a6d:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a79:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a80:	00 00 00 
  803a83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a86:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a89:	bf 05 00 00 00       	mov    $0x5,%edi
  803a8e:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
}
  803a9a:	c9                   	leaveq 
  803a9b:	c3                   	retq   

0000000000803a9c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a9c:	55                   	push   %rbp
  803a9d:	48 89 e5             	mov    %rsp,%rbp
  803aa0:	48 83 ec 10          	sub    $0x10,%rsp
  803aa4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803aa7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803aaa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ab1:	00 00 00 
  803ab4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ab7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803ab9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ac0:	00 00 00 
  803ac3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ac6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ac9:	bf 06 00 00 00       	mov    $0x6,%edi
  803ace:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
}
  803ada:	c9                   	leaveq 
  803adb:	c3                   	retq   

0000000000803adc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803adc:	55                   	push   %rbp
  803add:	48 89 e5             	mov    %rsp,%rbp
  803ae0:	48 83 ec 30          	sub    $0x30,%rsp
  803ae4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ae7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803aeb:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803aee:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803af1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af8:	00 00 00 
  803afb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803afe:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b00:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b07:	00 00 00 
  803b0a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b0d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b10:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b17:	00 00 00 
  803b1a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b1d:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b20:	bf 07 00 00 00       	mov    $0x7,%edi
  803b25:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803b2c:	00 00 00 
  803b2f:	ff d0                	callq  *%rax
  803b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b38:	78 69                	js     803ba3 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b3a:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b41:	7f 08                	jg     803b4b <nsipc_recv+0x6f>
  803b43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b46:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b49:	7e 35                	jle    803b80 <nsipc_recv+0xa4>
  803b4b:	48 b9 1e 4d 80 00 00 	movabs $0x804d1e,%rcx
  803b52:	00 00 00 
  803b55:	48 ba 33 4d 80 00 00 	movabs $0x804d33,%rdx
  803b5c:	00 00 00 
  803b5f:	be 62 00 00 00       	mov    $0x62,%esi
  803b64:	48 bf 48 4d 80 00 00 	movabs $0x804d48,%rdi
  803b6b:	00 00 00 
  803b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b73:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  803b7a:	00 00 00 
  803b7d:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b83:	48 63 d0             	movslq %eax,%rdx
  803b86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b8a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b91:	00 00 00 
  803b94:	48 89 c7             	mov    %rax,%rdi
  803b97:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803b9e:	00 00 00 
  803ba1:	ff d0                	callq  *%rax
	}

	return r;
  803ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ba6:	c9                   	leaveq 
  803ba7:	c3                   	retq   

0000000000803ba8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ba8:	55                   	push   %rbp
  803ba9:	48 89 e5             	mov    %rsp,%rbp
  803bac:	48 83 ec 20          	sub    $0x20,%rsp
  803bb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bb7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803bba:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803bbd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bc4:	00 00 00 
  803bc7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bca:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803bcc:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bd3:	7e 35                	jle    803c0a <nsipc_send+0x62>
  803bd5:	48 b9 54 4d 80 00 00 	movabs $0x804d54,%rcx
  803bdc:	00 00 00 
  803bdf:	48 ba 33 4d 80 00 00 	movabs $0x804d33,%rdx
  803be6:	00 00 00 
  803be9:	be 6d 00 00 00       	mov    $0x6d,%esi
  803bee:	48 bf 48 4d 80 00 00 	movabs $0x804d48,%rdi
  803bf5:	00 00 00 
  803bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfd:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  803c04:	00 00 00 
  803c07:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c0d:	48 63 d0             	movslq %eax,%rdx
  803c10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c14:	48 89 c6             	mov    %rax,%rsi
  803c17:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803c1e:	00 00 00 
  803c21:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c2d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c34:	00 00 00 
  803c37:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c3a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c3d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c44:	00 00 00 
  803c47:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c4a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c4d:	bf 08 00 00 00       	mov    $0x8,%edi
  803c52:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803c59:	00 00 00 
  803c5c:	ff d0                	callq  *%rax
}
  803c5e:	c9                   	leaveq 
  803c5f:	c3                   	retq   

0000000000803c60 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c60:	55                   	push   %rbp
  803c61:	48 89 e5             	mov    %rsp,%rbp
  803c64:	48 83 ec 10          	sub    $0x10,%rsp
  803c68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c6e:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c71:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c78:	00 00 00 
  803c7b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c7e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c80:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c87:	00 00 00 
  803c8a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c8d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c90:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c97:	00 00 00 
  803c9a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c9d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803ca0:	bf 09 00 00 00       	mov    $0x9,%edi
  803ca5:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
}
  803cb1:	c9                   	leaveq 
  803cb2:	c3                   	retq   

0000000000803cb3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cb3:	55                   	push   %rbp
  803cb4:	48 89 e5             	mov    %rsp,%rbp
  803cb7:	53                   	push   %rbx
  803cb8:	48 83 ec 38          	sub    $0x38,%rsp
  803cbc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803cc0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803cc4:	48 89 c7             	mov    %rax,%rdi
  803cc7:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  803cce:	00 00 00 
  803cd1:	ff d0                	callq  *%rax
  803cd3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cda:	0f 88 bf 01 00 00    	js     803e9f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ce0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ce9:	48 89 c6             	mov    %rax,%rsi
  803cec:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf1:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803cf8:	00 00 00 
  803cfb:	ff d0                	callq  *%rax
  803cfd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d00:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d04:	0f 88 95 01 00 00    	js     803e9f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d0a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d0e:	48 89 c7             	mov    %rax,%rdi
  803d11:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  803d18:	00 00 00 
  803d1b:	ff d0                	callq  *%rax
  803d1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d20:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d24:	0f 88 5d 01 00 00    	js     803e87 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d2e:	ba 07 04 00 00       	mov    $0x407,%edx
  803d33:	48 89 c6             	mov    %rax,%rsi
  803d36:	bf 00 00 00 00       	mov    $0x0,%edi
  803d3b:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803d42:	00 00 00 
  803d45:	ff d0                	callq  *%rax
  803d47:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d4e:	0f 88 33 01 00 00    	js     803e87 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d58:	48 89 c7             	mov    %rax,%rdi
  803d5b:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  803d62:	00 00 00 
  803d65:	ff d0                	callq  *%rax
  803d67:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d6f:	ba 07 04 00 00       	mov    $0x407,%edx
  803d74:	48 89 c6             	mov    %rax,%rsi
  803d77:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7c:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803d83:	00 00 00 
  803d86:	ff d0                	callq  *%rax
  803d88:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d8f:	0f 88 d9 00 00 00    	js     803e6e <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d95:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d99:	48 89 c7             	mov    %rax,%rdi
  803d9c:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  803da3:	00 00 00 
  803da6:	ff d0                	callq  *%rax
  803da8:	48 89 c2             	mov    %rax,%rdx
  803dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803daf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803db5:	48 89 d1             	mov    %rdx,%rcx
  803db8:	ba 00 00 00 00       	mov    $0x0,%edx
  803dbd:	48 89 c6             	mov    %rax,%rsi
  803dc0:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc5:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  803dcc:	00 00 00 
  803dcf:	ff d0                	callq  *%rax
  803dd1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd8:	78 79                	js     803e53 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803dda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dde:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803de5:	00 00 00 
  803de8:	8b 12                	mov    (%rdx),%edx
  803dea:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803dec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803df7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dfb:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803e02:	00 00 00 
  803e05:	8b 12                	mov    (%rdx),%edx
  803e07:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e0d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e18:	48 89 c7             	mov    %rax,%rdi
  803e1b:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  803e22:	00 00 00 
  803e25:	ff d0                	callq  *%rax
  803e27:	89 c2                	mov    %eax,%edx
  803e29:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e2d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e2f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e33:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3b:	48 89 c7             	mov    %rax,%rdi
  803e3e:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  803e45:	00 00 00 
  803e48:	ff d0                	callq  *%rax
  803e4a:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e51:	eb 4f                	jmp    803ea2 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803e53:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e58:	48 89 c6             	mov    %rax,%rsi
  803e5b:	bf 00 00 00 00       	mov    $0x0,%edi
  803e60:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  803e67:	00 00 00 
  803e6a:	ff d0                	callq  *%rax
  803e6c:	eb 01                	jmp    803e6f <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803e6e:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e73:	48 89 c6             	mov    %rax,%rsi
  803e76:	bf 00 00 00 00       	mov    $0x0,%edi
  803e7b:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e8b:	48 89 c6             	mov    %rax,%rsi
  803e8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e93:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  803e9a:	00 00 00 
  803e9d:	ff d0                	callq  *%rax
err:
	return r;
  803e9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ea2:	48 83 c4 38          	add    $0x38,%rsp
  803ea6:	5b                   	pop    %rbx
  803ea7:	5d                   	pop    %rbp
  803ea8:	c3                   	retq   

0000000000803ea9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ea9:	55                   	push   %rbp
  803eaa:	48 89 e5             	mov    %rsp,%rbp
  803ead:	53                   	push   %rbx
  803eae:	48 83 ec 28          	sub    $0x28,%rsp
  803eb2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803eb6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803eba:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803ec1:	00 00 00 
  803ec4:	48 8b 00             	mov    (%rax),%rax
  803ec7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ecd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ed0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ed4:	48 89 c7             	mov    %rax,%rdi
  803ed7:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  803ede:	00 00 00 
  803ee1:	ff d0                	callq  *%rax
  803ee3:	89 c3                	mov    %eax,%ebx
  803ee5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ee9:	48 89 c7             	mov    %rax,%rdi
  803eec:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
  803ef8:	39 c3                	cmp    %eax,%ebx
  803efa:	0f 94 c0             	sete   %al
  803efd:	0f b6 c0             	movzbl %al,%eax
  803f00:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f03:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803f0a:	00 00 00 
  803f0d:	48 8b 00             	mov    (%rax),%rax
  803f10:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f16:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f1c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f1f:	75 05                	jne    803f26 <_pipeisclosed+0x7d>
			return ret;
  803f21:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f24:	eb 4a                	jmp    803f70 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803f26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f29:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f2c:	74 8c                	je     803eba <_pipeisclosed+0x11>
  803f2e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f32:	75 86                	jne    803eba <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f34:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803f3b:	00 00 00 
  803f3e:	48 8b 00             	mov    (%rax),%rax
  803f41:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f47:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f4d:	89 c6                	mov    %eax,%esi
  803f4f:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  803f56:	00 00 00 
  803f59:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5e:	49 b8 4c 07 80 00 00 	movabs $0x80074c,%r8
  803f65:	00 00 00 
  803f68:	41 ff d0             	callq  *%r8
	}
  803f6b:	e9 4a ff ff ff       	jmpq   803eba <_pipeisclosed+0x11>

}
  803f70:	48 83 c4 28          	add    $0x28,%rsp
  803f74:	5b                   	pop    %rbx
  803f75:	5d                   	pop    %rbp
  803f76:	c3                   	retq   

0000000000803f77 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803f77:	55                   	push   %rbp
  803f78:	48 89 e5             	mov    %rsp,%rbp
  803f7b:	48 83 ec 30          	sub    $0x30,%rsp
  803f7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f82:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f86:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f89:	48 89 d6             	mov    %rdx,%rsi
  803f8c:	89 c7                	mov    %eax,%edi
  803f8e:	48 b8 52 22 80 00 00 	movabs $0x802252,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
  803f9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fa1:	79 05                	jns    803fa8 <pipeisclosed+0x31>
		return r;
  803fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa6:	eb 31                	jmp    803fd9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fac:	48 89 c7             	mov    %rax,%rdi
  803faf:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  803fb6:	00 00 00 
  803fb9:	ff d0                	callq  *%rax
  803fbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fc7:	48 89 d6             	mov    %rdx,%rsi
  803fca:	48 89 c7             	mov    %rax,%rdi
  803fcd:	48 b8 a9 3e 80 00 00 	movabs $0x803ea9,%rax
  803fd4:	00 00 00 
  803fd7:	ff d0                	callq  *%rax
}
  803fd9:	c9                   	leaveq 
  803fda:	c3                   	retq   

0000000000803fdb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fdb:	55                   	push   %rbp
  803fdc:	48 89 e5             	mov    %rsp,%rbp
  803fdf:	48 83 ec 40          	sub    $0x40,%rsp
  803fe3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fe7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803feb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff3:	48 89 c7             	mov    %rax,%rdi
  803ff6:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  803ffd:	00 00 00 
  804000:	ff d0                	callq  *%rax
  804002:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804006:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80400a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80400e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804015:	00 
  804016:	e9 90 00 00 00       	jmpq   8040ab <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80401b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804020:	74 09                	je     80402b <devpipe_read+0x50>
				return i;
  804022:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804026:	e9 8e 00 00 00       	jmpq   8040b9 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80402b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80402f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804033:	48 89 d6             	mov    %rdx,%rsi
  804036:	48 89 c7             	mov    %rax,%rdi
  804039:	48 b8 a9 3e 80 00 00 	movabs $0x803ea9,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	85 c0                	test   %eax,%eax
  804047:	74 07                	je     804050 <devpipe_read+0x75>
				return 0;
  804049:	b8 00 00 00 00       	mov    $0x0,%eax
  80404e:	eb 69                	jmp    8040b9 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804050:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  804057:	00 00 00 
  80405a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80405c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804060:	8b 10                	mov    (%rax),%edx
  804062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804066:	8b 40 04             	mov    0x4(%rax),%eax
  804069:	39 c2                	cmp    %eax,%edx
  80406b:	74 ae                	je     80401b <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80406d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804075:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80407d:	8b 00                	mov    (%rax),%eax
  80407f:	99                   	cltd   
  804080:	c1 ea 1b             	shr    $0x1b,%edx
  804083:	01 d0                	add    %edx,%eax
  804085:	83 e0 1f             	and    $0x1f,%eax
  804088:	29 d0                	sub    %edx,%eax
  80408a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80408e:	48 98                	cltq   
  804090:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804095:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409b:	8b 00                	mov    (%rax),%eax
  80409d:	8d 50 01             	lea    0x1(%rax),%edx
  8040a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040af:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040b3:	72 a7                	jb     80405c <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8040b9:	c9                   	leaveq 
  8040ba:	c3                   	retq   

00000000008040bb <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040bb:	55                   	push   %rbp
  8040bc:	48 89 e5             	mov    %rsp,%rbp
  8040bf:	48 83 ec 40          	sub    $0x40,%rsp
  8040c3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040cb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d3:	48 89 c7             	mov    %rax,%rdi
  8040d6:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  8040dd:	00 00 00 
  8040e0:	ff d0                	callq  *%rax
  8040e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040ee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040f5:	00 
  8040f6:	e9 8f 00 00 00       	jmpq   80418a <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804103:	48 89 d6             	mov    %rdx,%rsi
  804106:	48 89 c7             	mov    %rax,%rdi
  804109:	48 b8 a9 3e 80 00 00 	movabs $0x803ea9,%rax
  804110:	00 00 00 
  804113:	ff d0                	callq  *%rax
  804115:	85 c0                	test   %eax,%eax
  804117:	74 07                	je     804120 <devpipe_write+0x65>
				return 0;
  804119:	b8 00 00 00 00       	mov    $0x0,%eax
  80411e:	eb 78                	jmp    804198 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804120:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  804127:	00 00 00 
  80412a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80412c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804130:	8b 40 04             	mov    0x4(%rax),%eax
  804133:	48 63 d0             	movslq %eax,%rdx
  804136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80413a:	8b 00                	mov    (%rax),%eax
  80413c:	48 98                	cltq   
  80413e:	48 83 c0 20          	add    $0x20,%rax
  804142:	48 39 c2             	cmp    %rax,%rdx
  804145:	73 b4                	jae    8040fb <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80414b:	8b 40 04             	mov    0x4(%rax),%eax
  80414e:	99                   	cltd   
  80414f:	c1 ea 1b             	shr    $0x1b,%edx
  804152:	01 d0                	add    %edx,%eax
  804154:	83 e0 1f             	and    $0x1f,%eax
  804157:	29 d0                	sub    %edx,%eax
  804159:	89 c6                	mov    %eax,%esi
  80415b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80415f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804163:	48 01 d0             	add    %rdx,%rax
  804166:	0f b6 08             	movzbl (%rax),%ecx
  804169:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80416d:	48 63 c6             	movslq %esi,%rax
  804170:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804178:	8b 40 04             	mov    0x4(%rax),%eax
  80417b:	8d 50 01             	lea    0x1(%rax),%edx
  80417e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804182:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804185:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80418a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80418e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804192:	72 98                	jb     80412c <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804198:	c9                   	leaveq 
  804199:	c3                   	retq   

000000000080419a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80419a:	55                   	push   %rbp
  80419b:	48 89 e5             	mov    %rsp,%rbp
  80419e:	48 83 ec 20          	sub    $0x20,%rsp
  8041a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ae:	48 89 c7             	mov    %rax,%rdi
  8041b1:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  8041b8:	00 00 00 
  8041bb:	ff d0                	callq  *%rax
  8041bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c5:	48 be 78 4d 80 00 00 	movabs $0x804d78,%rsi
  8041cc:	00 00 00 
  8041cf:	48 89 c7             	mov    %rax,%rdi
  8041d2:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  8041d9:	00 00 00 
  8041dc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e2:	8b 50 04             	mov    0x4(%rax),%edx
  8041e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e9:	8b 00                	mov    (%rax),%eax
  8041eb:	29 c2                	sub    %eax,%edx
  8041ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041fb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804202:	00 00 00 
	stat->st_dev = &devpipe;
  804205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804209:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  804210:	00 00 00 
  804213:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80421a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80421f:	c9                   	leaveq 
  804220:	c3                   	retq   

0000000000804221 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804221:	55                   	push   %rbp
  804222:	48 89 e5             	mov    %rsp,%rbp
  804225:	48 83 ec 10          	sub    $0x10,%rsp
  804229:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80422d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804231:	48 89 c6             	mov    %rax,%rsi
  804234:	bf 00 00 00 00       	mov    $0x0,%edi
  804239:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  804240:	00 00 00 
  804243:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804249:	48 89 c7             	mov    %rax,%rdi
  80424c:	48 b8 8f 21 80 00 00 	movabs $0x80218f,%rax
  804253:	00 00 00 
  804256:	ff d0                	callq  *%rax
  804258:	48 89 c6             	mov    %rax,%rsi
  80425b:	bf 00 00 00 00       	mov    $0x0,%edi
  804260:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  804267:	00 00 00 
  80426a:	ff d0                	callq  *%rax
}
  80426c:	c9                   	leaveq 
  80426d:	c3                   	retq   

000000000080426e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80426e:	55                   	push   %rbp
  80426f:	48 89 e5             	mov    %rsp,%rbp
  804272:	48 83 ec 30          	sub    $0x30,%rsp
  804276:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80427a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80427e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804282:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804287:	75 0e                	jne    804297 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804289:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804290:	00 00 00 
  804293:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804297:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80429b:	48 89 c7             	mov    %rax,%rdi
  80429e:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
  8042aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b1:	79 27                	jns    8042da <ipc_recv+0x6c>
		if (from_env_store)
  8042b3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042b8:	74 0a                	je     8042c4 <ipc_recv+0x56>
			*from_env_store = 0;
  8042ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8042c4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042c9:	74 0a                	je     8042d5 <ipc_recv+0x67>
			*perm_store = 0;
  8042cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8042d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d8:	eb 53                	jmp    80432d <ipc_recv+0xbf>
	}
	if (from_env_store)
  8042da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042df:	74 19                	je     8042fa <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8042e1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8042e8:	00 00 00 
  8042eb:	48 8b 00             	mov    (%rax),%rax
  8042ee:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042f8:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8042fa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042ff:	74 19                	je     80431a <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804301:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804308:	00 00 00 
  80430b:	48 8b 00             	mov    (%rax),%rax
  80430e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804318:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80431a:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804321:	00 00 00 
  804324:	48 8b 00             	mov    (%rax),%rax
  804327:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80432d:	c9                   	leaveq 
  80432e:	c3                   	retq   

000000000080432f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80432f:	55                   	push   %rbp
  804330:	48 89 e5             	mov    %rsp,%rbp
  804333:	48 83 ec 30          	sub    $0x30,%rsp
  804337:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80433a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80433d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804341:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804344:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804349:	75 1c                	jne    804367 <ipc_send+0x38>
		pg = (void*) UTOP;
  80434b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804352:	00 00 00 
  804355:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804359:	eb 0c                	jmp    804367 <ipc_send+0x38>
		sys_yield();
  80435b:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  804362:	00 00 00 
  804365:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804367:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80436a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80436d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804371:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804374:	89 c7                	mov    %eax,%edi
  804376:	48 b8 53 1f 80 00 00 	movabs $0x801f53,%rax
  80437d:	00 00 00 
  804380:	ff d0                	callq  *%rax
  804382:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804385:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804389:	74 d0                	je     80435b <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80438b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80438f:	79 30                	jns    8043c1 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804394:	89 c1                	mov    %eax,%ecx
  804396:	48 ba 7f 4d 80 00 00 	movabs $0x804d7f,%rdx
  80439d:	00 00 00 
  8043a0:	be 47 00 00 00       	mov    $0x47,%esi
  8043a5:	48 bf 95 4d 80 00 00 	movabs $0x804d95,%rdi
  8043ac:	00 00 00 
  8043af:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b4:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  8043bb:	00 00 00 
  8043be:	41 ff d0             	callq  *%r8

}
  8043c1:	90                   	nop
  8043c2:	c9                   	leaveq 
  8043c3:	c3                   	retq   

00000000008043c4 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8043c4:	55                   	push   %rbp
  8043c5:	48 89 e5             	mov    %rsp,%rbp
  8043c8:	53                   	push   %rbx
  8043c9:	48 83 ec 28          	sub    $0x28,%rsp
  8043cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8043d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8043d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8043df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043e4:	75 0e                	jne    8043f4 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8043e6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043ed:	00 00 00 
  8043f0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8043f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043f8:	ba 07 00 00 00       	mov    $0x7,%edx
  8043fd:	48 89 c6             	mov    %rax,%rsi
  804400:	bf 00 00 00 00       	mov    $0x0,%edi
  804405:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  80440c:	00 00 00 
  80440f:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804415:	48 c1 e8 0c          	shr    $0xc,%rax
  804419:	48 89 c2             	mov    %rax,%rdx
  80441c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804423:	01 00 00 
  804426:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80442a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804430:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804434:	b8 03 00 00 00       	mov    $0x3,%eax
  804439:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80443d:	48 89 d3             	mov    %rdx,%rbx
  804440:	0f 01 c1             	vmcall 
  804443:	89 f2                	mov    %esi,%edx
  804445:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804448:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80444b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80444f:	79 05                	jns    804456 <ipc_host_recv+0x92>
		return r;
  804451:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804454:	eb 03                	jmp    804459 <ipc_host_recv+0x95>
	}
	return val;
  804456:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804459:	48 83 c4 28          	add    $0x28,%rsp
  80445d:	5b                   	pop    %rbx
  80445e:	5d                   	pop    %rbp
  80445f:	c3                   	retq   

0000000000804460 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804460:	55                   	push   %rbp
  804461:	48 89 e5             	mov    %rsp,%rbp
  804464:	53                   	push   %rbx
  804465:	48 83 ec 38          	sub    $0x38,%rsp
  804469:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80446c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80446f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804473:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804476:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80447d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804482:	75 0e                	jne    804492 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804484:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80448b:	00 00 00 
  80448e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804492:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804496:	48 c1 e8 0c          	shr    $0xc,%rax
  80449a:	48 89 c2             	mov    %rax,%rdx
  80449d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044a4:	01 00 00 
  8044a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044ab:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8044b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8044b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8044ba:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8044bd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8044c0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044c4:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8044c7:	89 fb                	mov    %edi,%ebx
  8044c9:	0f 01 c1             	vmcall 
  8044cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8044cf:	eb 26                	jmp    8044f7 <ipc_host_send+0x97>
		sys_yield();
  8044d1:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  8044d8:	00 00 00 
  8044db:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8044dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8044e2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8044e5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8044e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044ec:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8044ef:	89 fb                	mov    %edi,%ebx
  8044f1:	0f 01 c1             	vmcall 
  8044f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8044f7:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8044fb:	74 d4                	je     8044d1 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8044fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804501:	79 30                	jns    804533 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804503:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804506:	89 c1                	mov    %eax,%ecx
  804508:	48 ba 7f 4d 80 00 00 	movabs $0x804d7f,%rdx
  80450f:	00 00 00 
  804512:	be 79 00 00 00       	mov    $0x79,%esi
  804517:	48 bf 95 4d 80 00 00 	movabs $0x804d95,%rdi
  80451e:	00 00 00 
  804521:	b8 00 00 00 00       	mov    $0x0,%eax
  804526:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  80452d:	00 00 00 
  804530:	41 ff d0             	callq  *%r8

}
  804533:	90                   	nop
  804534:	48 83 c4 38          	add    $0x38,%rsp
  804538:	5b                   	pop    %rbx
  804539:	5d                   	pop    %rbp
  80453a:	c3                   	retq   

000000000080453b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80453b:	55                   	push   %rbp
  80453c:	48 89 e5             	mov    %rsp,%rbp
  80453f:	48 83 ec 18          	sub    $0x18,%rsp
  804543:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80454d:	eb 4d                	jmp    80459c <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80454f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804556:	00 00 00 
  804559:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455c:	48 98                	cltq   
  80455e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804565:	48 01 d0             	add    %rdx,%rax
  804568:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80456e:	8b 00                	mov    (%rax),%eax
  804570:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804573:	75 23                	jne    804598 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804575:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80457c:	00 00 00 
  80457f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804582:	48 98                	cltq   
  804584:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80458b:	48 01 d0             	add    %rdx,%rax
  80458e:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804594:	8b 00                	mov    (%rax),%eax
  804596:	eb 12                	jmp    8045aa <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804598:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80459c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8045a3:	7e aa                	jle    80454f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8045a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045aa:	c9                   	leaveq 
  8045ab:	c3                   	retq   

00000000008045ac <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8045ac:	55                   	push   %rbp
  8045ad:	48 89 e5             	mov    %rsp,%rbp
  8045b0:	48 83 ec 18          	sub    $0x18,%rsp
  8045b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8045b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045bc:	48 c1 e8 15          	shr    $0x15,%rax
  8045c0:	48 89 c2             	mov    %rax,%rdx
  8045c3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8045ca:	01 00 00 
  8045cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045d1:	83 e0 01             	and    $0x1,%eax
  8045d4:	48 85 c0             	test   %rax,%rax
  8045d7:	75 07                	jne    8045e0 <pageref+0x34>
		return 0;
  8045d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045de:	eb 56                	jmp    804636 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8045e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8045e8:	48 89 c2             	mov    %rax,%rdx
  8045eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8045f2:	01 00 00 
  8045f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8045fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804601:	83 e0 01             	and    $0x1,%eax
  804604:	48 85 c0             	test   %rax,%rax
  804607:	75 07                	jne    804610 <pageref+0x64>
		return 0;
  804609:	b8 00 00 00 00       	mov    $0x0,%eax
  80460e:	eb 26                	jmp    804636 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804614:	48 c1 e8 0c          	shr    $0xc,%rax
  804618:	48 89 c2             	mov    %rax,%rdx
  80461b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804622:	00 00 00 
  804625:	48 c1 e2 04          	shl    $0x4,%rdx
  804629:	48 01 d0             	add    %rdx,%rax
  80462c:	48 83 c0 08          	add    $0x8,%rax
  804630:	0f b7 00             	movzwl (%rax),%eax
  804633:	0f b7 c0             	movzwl %ax,%eax
}
  804636:	c9                   	leaveq 
  804637:	c3                   	retq   
