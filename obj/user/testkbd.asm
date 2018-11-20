
obj/user/testkbd:     file format elf64-x86-64


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
  800076:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
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
  80009c:	48 ba c0 45 80 00 00 	movabs $0x8045c0,%rdx
  8000a3:	00 00 00 
  8000a6:	be 10 00 00 00       	mov    $0x10,%esi
  8000ab:	48 bf cd 45 80 00 00 	movabs $0x8045cd,%rdi
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
  8000d2:	48 ba dc 45 80 00 00 	movabs $0x8045dc,%rdx
  8000d9:	00 00 00 
  8000dc:	be 12 00 00 00       	mov    $0x12,%esi
  8000e1:	48 bf cd 45 80 00 00 	movabs $0x8045cd,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 da 25 80 00 00 	movabs $0x8025da,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba f6 45 80 00 00 	movabs $0x8045f6,%rdx
  800128:	00 00 00 
  80012b:	be 14 00 00 00       	mov    $0x14,%esi
  800130:	48 bf cd 45 80 00 00 	movabs $0x8045cd,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf fe 45 80 00 00 	movabs $0x8045fe,%rdi
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
  800174:	48 be 0c 46 80 00 00 	movabs $0x80460c,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 33 34 80 00 00 	movabs $0x803433,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
  800194:	eb b6                	jmp    80014c <umain+0x109>
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be 10 46 80 00 00 	movabs $0x804610,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 33 34 80 00 00 	movabs $0x803433,%rdx
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
  8001fd:	48 b8 83 27 80 00 00 	movabs $0x802783,%rax
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
  800244:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
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
  800289:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
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
  8002f2:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
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
  80044a:	48 be 2d 46 80 00 00 	movabs $0x80462d,%rsi
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
  8004f2:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
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
  8005cc:	48 bf 40 46 80 00 00 	movabs $0x804640,%rdi
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
  800608:	48 bf 63 46 80 00 00 	movabs $0x804663,%rdi
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
  8008b9:	48 b8 70 48 80 00 00 	movabs $0x804870,%rax
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
  800b9b:	48 b8 98 48 80 00 00 	movabs $0x804898,%rax
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
  800ce2:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  800ce9:	00 00 00 
  800cec:	48 63 d3             	movslq %ebx,%rdx
  800cef:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cf3:	4d 85 e4             	test   %r12,%r12
  800cf6:	75 2e                	jne    800d26 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cf8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d00:	89 d9                	mov    %ebx,%ecx
  800d02:	48 ba 81 48 80 00 00 	movabs $0x804881,%rdx
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
  800d31:	48 ba 8a 48 80 00 00 	movabs $0x80488a,%rdx
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
  800d88:	49 bc 8d 48 80 00 00 	movabs $0x80488d,%r12
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
  80128a:	48 be 48 4b 80 00 00 	movabs $0x804b48,%rsi
  801291:	00 00 00 
  801294:	bf 01 00 00 00       	mov    $0x1,%edi
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	48 b9 33 34 80 00 00 	movabs $0x803433,%rcx
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
  8012e5:	48 bf 4b 4b 80 00 00 	movabs $0x804b4b,%rdi
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
  801bf2:	48 ba 5b 4b 80 00 00 	movabs $0x804b5b,%rdx
  801bf9:	00 00 00 
  801bfc:	be 24 00 00 00       	mov    $0x24,%esi
  801c01:	48 bf 78 4b 80 00 00 	movabs $0x804b78,%rdi
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

000000000080216c <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802170:	48 83 ec 08          	sub    $0x8,%rsp
  802174:	6a 00                	pushq  $0x0
  802176:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80217c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802182:	b9 00 00 00 00       	mov    $0x0,%ecx
  802187:	ba 00 00 00 00       	mov    $0x0,%edx
  80218c:	be 00 00 00 00       	mov    $0x0,%esi
  802191:	bf 13 00 00 00       	mov    $0x13,%edi
  802196:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	callq  *%rax
  8021a2:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  8021a6:	90                   	nop
  8021a7:	c9                   	leaveq 
  8021a8:	c3                   	retq   

00000000008021a9 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  8021a9:	55                   	push   %rbp
  8021aa:	48 89 e5             	mov    %rsp,%rbp
  8021ad:	48 83 ec 10          	sub    $0x10,%rsp
  8021b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  8021b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b7:	48 98                	cltq   
  8021b9:	48 83 ec 08          	sub    $0x8,%rsp
  8021bd:	6a 00                	pushq  $0x0
  8021bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021d0:	48 89 c2             	mov    %rax,%rdx
  8021d3:	be 00 00 00 00       	mov    $0x0,%esi
  8021d8:	bf 14 00 00 00       	mov    $0x14,%edi
  8021dd:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
  8021e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8021ed:	c9                   	leaveq 
  8021ee:	c3                   	retq   

00000000008021ef <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8021ef:	55                   	push   %rbp
  8021f0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8021f3:	48 83 ec 08          	sub    $0x8,%rsp
  8021f7:	6a 00                	pushq  $0x0
  8021f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802205:	b9 00 00 00 00       	mov    $0x0,%ecx
  80220a:	ba 00 00 00 00       	mov    $0x0,%edx
  80220f:	be 00 00 00 00       	mov    $0x0,%esi
  802214:	bf 15 00 00 00       	mov    $0x15,%edi
  802219:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  802220:	00 00 00 
  802223:	ff d0                	callq  *%rax
  802225:	48 83 c4 10          	add    $0x10,%rsp
}
  802229:	c9                   	leaveq 
  80222a:	c3                   	retq   

000000000080222b <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  80222b:	55                   	push   %rbp
  80222c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80222f:	48 83 ec 08          	sub    $0x8,%rsp
  802233:	6a 00                	pushq  $0x0
  802235:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80223b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802241:	b9 00 00 00 00       	mov    $0x0,%ecx
  802246:	ba 00 00 00 00       	mov    $0x0,%edx
  80224b:	be 00 00 00 00       	mov    $0x0,%esi
  802250:	bf 16 00 00 00       	mov    $0x16,%edi
  802255:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	48 83 c4 10          	add    $0x10,%rsp
}
  802265:	90                   	nop
  802266:	c9                   	leaveq 
  802267:	c3                   	retq   

0000000000802268 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802268:	55                   	push   %rbp
  802269:	48 89 e5             	mov    %rsp,%rbp
  80226c:	48 83 ec 08          	sub    $0x8,%rsp
  802270:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802274:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802278:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80227f:	ff ff ff 
  802282:	48 01 d0             	add    %rdx,%rax
  802285:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802289:	c9                   	leaveq 
  80228a:	c3                   	retq   

000000000080228b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80228b:	55                   	push   %rbp
  80228c:	48 89 e5             	mov    %rsp,%rbp
  80228f:	48 83 ec 08          	sub    $0x8,%rsp
  802293:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229b:	48 89 c7             	mov    %rax,%rdi
  80229e:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
  8022aa:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8022b0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8022b4:	c9                   	leaveq 
  8022b5:	c3                   	retq   

00000000008022b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8022b6:	55                   	push   %rbp
  8022b7:	48 89 e5             	mov    %rsp,%rbp
  8022ba:	48 83 ec 18          	sub    $0x18,%rsp
  8022be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022c9:	eb 6b                	jmp    802336 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ce:	48 98                	cltq   
  8022d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8022da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e2:	48 c1 e8 15          	shr    $0x15,%rax
  8022e6:	48 89 c2             	mov    %rax,%rdx
  8022e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022f0:	01 00 00 
  8022f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f7:	83 e0 01             	and    $0x1,%eax
  8022fa:	48 85 c0             	test   %rax,%rax
  8022fd:	74 21                	je     802320 <fd_alloc+0x6a>
  8022ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802303:	48 c1 e8 0c          	shr    $0xc,%rax
  802307:	48 89 c2             	mov    %rax,%rdx
  80230a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802311:	01 00 00 
  802314:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802318:	83 e0 01             	and    $0x1,%eax
  80231b:	48 85 c0             	test   %rax,%rax
  80231e:	75 12                	jne    802332 <fd_alloc+0x7c>
			*fd_store = fd;
  802320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802324:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802328:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80232b:	b8 00 00 00 00       	mov    $0x0,%eax
  802330:	eb 1a                	jmp    80234c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802332:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802336:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80233a:	7e 8f                	jle    8022cb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80233c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802340:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802347:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 20          	sub    $0x20,%rsp
  802356:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802359:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80235d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802361:	78 06                	js     802369 <fd_lookup+0x1b>
  802363:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802367:	7e 07                	jle    802370 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802369:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236e:	eb 6c                	jmp    8023dc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802370:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802373:	48 98                	cltq   
  802375:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80237b:	48 c1 e0 0c          	shl    $0xc,%rax
  80237f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802387:	48 c1 e8 15          	shr    $0x15,%rax
  80238b:	48 89 c2             	mov    %rax,%rdx
  80238e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802395:	01 00 00 
  802398:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239c:	83 e0 01             	and    $0x1,%eax
  80239f:	48 85 c0             	test   %rax,%rax
  8023a2:	74 21                	je     8023c5 <fd_lookup+0x77>
  8023a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ac:	48 89 c2             	mov    %rax,%rdx
  8023af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b6:	01 00 00 
  8023b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bd:	83 e0 01             	and    $0x1,%eax
  8023c0:	48 85 c0             	test   %rax,%rax
  8023c3:	75 07                	jne    8023cc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023ca:	eb 10                	jmp    8023dc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023d4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023dc:	c9                   	leaveq 
  8023dd:	c3                   	retq   

00000000008023de <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023de:	55                   	push   %rbp
  8023df:	48 89 e5             	mov    %rsp,%rbp
  8023e2:	48 83 ec 30          	sub    $0x30,%rsp
  8023e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023ea:	89 f0                	mov    %esi,%eax
  8023ec:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f3:	48 89 c7             	mov    %rax,%rdi
  8023f6:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
  802402:	89 c2                	mov    %eax,%edx
  802404:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802408:	48 89 c6             	mov    %rax,%rsi
  80240b:	89 d7                	mov    %edx,%edi
  80240d:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  802414:	00 00 00 
  802417:	ff d0                	callq  *%rax
  802419:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80241c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802420:	78 0a                	js     80242c <fd_close+0x4e>
	    || fd != fd2)
  802422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802426:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80242a:	74 12                	je     80243e <fd_close+0x60>
		return (must_exist ? r : 0);
  80242c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802430:	74 05                	je     802437 <fd_close+0x59>
  802432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802435:	eb 70                	jmp    8024a7 <fd_close+0xc9>
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	eb 69                	jmp    8024a7 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80243e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802442:	8b 00                	mov    (%rax),%eax
  802444:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802448:	48 89 d6             	mov    %rdx,%rsi
  80244b:	89 c7                	mov    %eax,%edi
  80244d:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802460:	78 2a                	js     80248c <fd_close+0xae>
		if (dev->dev_close)
  802462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802466:	48 8b 40 20          	mov    0x20(%rax),%rax
  80246a:	48 85 c0             	test   %rax,%rax
  80246d:	74 16                	je     802485 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80246f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802473:	48 8b 40 20          	mov    0x20(%rax),%rax
  802477:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80247b:	48 89 d7             	mov    %rdx,%rdi
  80247e:	ff d0                	callq  *%rax
  802480:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802483:	eb 07                	jmp    80248c <fd_close+0xae>
		else
			r = 0;
  802485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80248c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802490:	48 89 c6             	mov    %rax,%rsi
  802493:	bf 00 00 00 00       	mov    $0x0,%edi
  802498:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
	return r;
  8024a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	48 83 ec 20          	sub    $0x20,%rsp
  8024b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8024b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024bf:	eb 41                	jmp    802502 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024c1:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8024c8:	00 00 00 
  8024cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024ce:	48 63 d2             	movslq %edx,%rdx
  8024d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d5:	8b 00                	mov    (%rax),%eax
  8024d7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024da:	75 22                	jne    8024fe <dev_lookup+0x55>
			*dev = devtab[i];
  8024dc:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8024e3:	00 00 00 
  8024e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024e9:	48 63 d2             	movslq %edx,%rdx
  8024ec:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024f4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fc:	eb 60                	jmp    80255e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024fe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802502:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802509:	00 00 00 
  80250c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80250f:	48 63 d2             	movslq %edx,%rdx
  802512:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802516:	48 85 c0             	test   %rax,%rax
  802519:	75 a6                	jne    8024c1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80251b:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802522:	00 00 00 
  802525:	48 8b 00             	mov    (%rax),%rax
  802528:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80252e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802531:	89 c6                	mov    %eax,%esi
  802533:	48 bf 88 4b 80 00 00 	movabs $0x804b88,%rdi
  80253a:	00 00 00 
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  802549:	00 00 00 
  80254c:	ff d1                	callq  *%rcx
	*dev = 0;
  80254e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802552:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802559:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80255e:	c9                   	leaveq 
  80255f:	c3                   	retq   

0000000000802560 <close>:

int
close(int fdnum)
{
  802560:	55                   	push   %rbp
  802561:	48 89 e5             	mov    %rsp,%rbp
  802564:	48 83 ec 20          	sub    $0x20,%rsp
  802568:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802572:	48 89 d6             	mov    %rdx,%rsi
  802575:	89 c7                	mov    %eax,%edi
  802577:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
  802583:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258a:	79 05                	jns    802591 <close+0x31>
		return r;
  80258c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258f:	eb 18                	jmp    8025a9 <close+0x49>
	else
		return fd_close(fd, 1);
  802591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802595:	be 01 00 00 00       	mov    $0x1,%esi
  80259a:	48 89 c7             	mov    %rax,%rdi
  80259d:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	callq  *%rax
}
  8025a9:	c9                   	leaveq 
  8025aa:	c3                   	retq   

00000000008025ab <close_all>:

void
close_all(void)
{
  8025ab:	55                   	push   %rbp
  8025ac:	48 89 e5             	mov    %rsp,%rbp
  8025af:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8025b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025ba:	eb 15                	jmp    8025d1 <close_all+0x26>
		close(i);
  8025bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bf:	89 c7                	mov    %eax,%edi
  8025c1:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025d1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025d5:	7e e5                	jle    8025bc <close_all+0x11>
		close(i);
}
  8025d7:	90                   	nop
  8025d8:	c9                   	leaveq 
  8025d9:	c3                   	retq   

00000000008025da <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025da:	55                   	push   %rbp
  8025db:	48 89 e5             	mov    %rsp,%rbp
  8025de:	48 83 ec 40          	sub    $0x40,%rsp
  8025e2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025e5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025e8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025ec:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025ef:	48 89 d6             	mov    %rdx,%rsi
  8025f2:	89 c7                	mov    %eax,%edi
  8025f4:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802603:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802607:	79 08                	jns    802611 <dup+0x37>
		return r;
  802609:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260c:	e9 70 01 00 00       	jmpq   802781 <dup+0x1a7>
	close(newfdnum);
  802611:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802614:	89 c7                	mov    %eax,%edi
  802616:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802622:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802625:	48 98                	cltq   
  802627:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80262d:	48 c1 e0 0c          	shl    $0xc,%rax
  802631:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802639:	48 89 c7             	mov    %rax,%rdi
  80263c:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80264c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802650:	48 89 c7             	mov    %rax,%rdi
  802653:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  80265a:	00 00 00 
  80265d:	ff d0                	callq  *%rax
  80265f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802667:	48 c1 e8 15          	shr    $0x15,%rax
  80266b:	48 89 c2             	mov    %rax,%rdx
  80266e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802675:	01 00 00 
  802678:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80267c:	83 e0 01             	and    $0x1,%eax
  80267f:	48 85 c0             	test   %rax,%rax
  802682:	74 71                	je     8026f5 <dup+0x11b>
  802684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802688:	48 c1 e8 0c          	shr    $0xc,%rax
  80268c:	48 89 c2             	mov    %rax,%rdx
  80268f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802696:	01 00 00 
  802699:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269d:	83 e0 01             	and    $0x1,%eax
  8026a0:	48 85 c0             	test   %rax,%rax
  8026a3:	74 50                	je     8026f5 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8026ad:	48 89 c2             	mov    %rax,%rdx
  8026b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026b7:	01 00 00 
  8026ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026be:	25 07 0e 00 00       	and    $0xe07,%eax
  8026c3:	89 c1                	mov    %eax,%ecx
  8026c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cd:	41 89 c8             	mov    %ecx,%r8d
  8026d0:	48 89 d1             	mov    %rdx,%rcx
  8026d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d8:	48 89 c6             	mov    %rax,%rsi
  8026db:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e0:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f3:	78 55                	js     80274a <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8026fd:	48 89 c2             	mov    %rax,%rdx
  802700:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802707:	01 00 00 
  80270a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270e:	25 07 0e 00 00       	and    $0xe07,%eax
  802713:	89 c1                	mov    %eax,%ecx
  802715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802719:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80271d:	41 89 c8             	mov    %ecx,%r8d
  802720:	48 89 d1             	mov    %rdx,%rcx
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	48 89 c6             	mov    %rax,%rsi
  80272b:	bf 00 00 00 00       	mov    $0x0,%edi
  802730:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
  80273c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802743:	78 08                	js     80274d <dup+0x173>
		goto err;

	return newfdnum;
  802745:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802748:	eb 37                	jmp    802781 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80274a:	90                   	nop
  80274b:	eb 01                	jmp    80274e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80274d:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80274e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802752:	48 89 c6             	mov    %rax,%rsi
  802755:	bf 00 00 00 00       	mov    $0x0,%edi
  80275a:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  802761:	00 00 00 
  802764:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802766:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80276a:	48 89 c6             	mov    %rax,%rsi
  80276d:	bf 00 00 00 00       	mov    $0x0,%edi
  802772:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  802779:	00 00 00 
  80277c:	ff d0                	callq  *%rax
	return r;
  80277e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802781:	c9                   	leaveq 
  802782:	c3                   	retq   

0000000000802783 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802783:	55                   	push   %rbp
  802784:	48 89 e5             	mov    %rsp,%rbp
  802787:	48 83 ec 40          	sub    $0x40,%rsp
  80278b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80278e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802792:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802796:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80279a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80279d:	48 89 d6             	mov    %rdx,%rsi
  8027a0:	89 c7                	mov    %eax,%edi
  8027a2:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
  8027ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b5:	78 24                	js     8027db <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bb:	8b 00                	mov    (%rax),%eax
  8027bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027c1:	48 89 d6             	mov    %rdx,%rsi
  8027c4:	89 c7                	mov    %eax,%edi
  8027c6:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	callq  *%rax
  8027d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d9:	79 05                	jns    8027e0 <read+0x5d>
		return r;
  8027db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027de:	eb 76                	jmp    802856 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e4:	8b 40 08             	mov    0x8(%rax),%eax
  8027e7:	83 e0 03             	and    $0x3,%eax
  8027ea:	83 f8 01             	cmp    $0x1,%eax
  8027ed:	75 3a                	jne    802829 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027ef:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8027f6:	00 00 00 
  8027f9:	48 8b 00             	mov    (%rax),%rax
  8027fc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802802:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802805:	89 c6                	mov    %eax,%esi
  802807:	48 bf a7 4b 80 00 00 	movabs $0x804ba7,%rdi
  80280e:	00 00 00 
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  80281d:	00 00 00 
  802820:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802822:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802827:	eb 2d                	jmp    802856 <read+0xd3>
	}
	if (!dev->dev_read)
  802829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802831:	48 85 c0             	test   %rax,%rax
  802834:	75 07                	jne    80283d <read+0xba>
		return -E_NOT_SUPP;
  802836:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80283b:	eb 19                	jmp    802856 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80283d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802841:	48 8b 40 10          	mov    0x10(%rax),%rax
  802845:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802849:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80284d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802851:	48 89 cf             	mov    %rcx,%rdi
  802854:	ff d0                	callq  *%rax
}
  802856:	c9                   	leaveq 
  802857:	c3                   	retq   

0000000000802858 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802858:	55                   	push   %rbp
  802859:	48 89 e5             	mov    %rsp,%rbp
  80285c:	48 83 ec 30          	sub    $0x30,%rsp
  802860:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802863:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802867:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80286b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802872:	eb 47                	jmp    8028bb <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802877:	48 98                	cltq   
  802879:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80287d:	48 29 c2             	sub    %rax,%rdx
  802880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802883:	48 63 c8             	movslq %eax,%rcx
  802886:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80288a:	48 01 c1             	add    %rax,%rcx
  80288d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802890:	48 89 ce             	mov    %rcx,%rsi
  802893:	89 c7                	mov    %eax,%edi
  802895:	48 b8 83 27 80 00 00 	movabs $0x802783,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	callq  *%rax
  8028a1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028a4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028a8:	79 05                	jns    8028af <readn+0x57>
			return m;
  8028aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028ad:	eb 1d                	jmp    8028cc <readn+0x74>
		if (m == 0)
  8028af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028b3:	74 13                	je     8028c8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028b8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028be:	48 98                	cltq   
  8028c0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028c4:	72 ae                	jb     802874 <readn+0x1c>
  8028c6:	eb 01                	jmp    8028c9 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8028c8:	90                   	nop
	}
	return tot;
  8028c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028cc:	c9                   	leaveq 
  8028cd:	c3                   	retq   

00000000008028ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028ce:	55                   	push   %rbp
  8028cf:	48 89 e5             	mov    %rsp,%rbp
  8028d2:	48 83 ec 40          	sub    $0x40,%rsp
  8028d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028dd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028e1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e8:	48 89 d6             	mov    %rdx,%rsi
  8028eb:	89 c7                	mov    %eax,%edi
  8028ed:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	callq  *%rax
  8028f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802900:	78 24                	js     802926 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802906:	8b 00                	mov    (%rax),%eax
  802908:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80290c:	48 89 d6             	mov    %rdx,%rsi
  80290f:	89 c7                	mov    %eax,%edi
  802911:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802918:	00 00 00 
  80291b:	ff d0                	callq  *%rax
  80291d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802924:	79 05                	jns    80292b <write+0x5d>
		return r;
  802926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802929:	eb 75                	jmp    8029a0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80292b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292f:	8b 40 08             	mov    0x8(%rax),%eax
  802932:	83 e0 03             	and    $0x3,%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	75 3a                	jne    802973 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802939:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802940:	00 00 00 
  802943:	48 8b 00             	mov    (%rax),%rax
  802946:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80294c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80294f:	89 c6                	mov    %eax,%esi
  802951:	48 bf c3 4b 80 00 00 	movabs $0x804bc3,%rdi
  802958:	00 00 00 
  80295b:	b8 00 00 00 00       	mov    $0x0,%eax
  802960:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  802967:	00 00 00 
  80296a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80296c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802971:	eb 2d                	jmp    8029a0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802977:	48 8b 40 18          	mov    0x18(%rax),%rax
  80297b:	48 85 c0             	test   %rax,%rax
  80297e:	75 07                	jne    802987 <write+0xb9>
		return -E_NOT_SUPP;
  802980:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802985:	eb 19                	jmp    8029a0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80298f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802993:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802997:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80299b:	48 89 cf             	mov    %rcx,%rdi
  80299e:	ff d0                	callq  *%rax
}
  8029a0:	c9                   	leaveq 
  8029a1:	c3                   	retq   

00000000008029a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8029a2:	55                   	push   %rbp
  8029a3:	48 89 e5             	mov    %rsp,%rbp
  8029a6:	48 83 ec 18          	sub    $0x18,%rsp
  8029aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029ad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029b7:	48 89 d6             	mov    %rdx,%rsi
  8029ba:	89 c7                	mov    %eax,%edi
  8029bc:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax
  8029c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cf:	79 05                	jns    8029d6 <seek+0x34>
		return r;
  8029d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d4:	eb 0f                	jmp    8029e5 <seek+0x43>
	fd->fd_offset = offset;
  8029d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029dd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e5:	c9                   	leaveq 
  8029e6:	c3                   	retq   

00000000008029e7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029e7:	55                   	push   %rbp
  8029e8:	48 89 e5             	mov    %rsp,%rbp
  8029eb:	48 83 ec 30          	sub    $0x30,%rsp
  8029ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029f2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029fc:	48 89 d6             	mov    %rdx,%rsi
  8029ff:	89 c7                	mov    %eax,%edi
  802a01:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
  802a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a14:	78 24                	js     802a3a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1a:	8b 00                	mov    (%rax),%eax
  802a1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a20:	48 89 d6             	mov    %rdx,%rsi
  802a23:	89 c7                	mov    %eax,%edi
  802a25:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a38:	79 05                	jns    802a3f <ftruncate+0x58>
		return r;
  802a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3d:	eb 72                	jmp    802ab1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a43:	8b 40 08             	mov    0x8(%rax),%eax
  802a46:	83 e0 03             	and    $0x3,%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 3a                	jne    802a87 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a4d:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802a54:	00 00 00 
  802a57:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a63:	89 c6                	mov    %eax,%esi
  802a65:	48 bf e0 4b 80 00 00 	movabs $0x804be0,%rdi
  802a6c:	00 00 00 
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	48 b9 4c 07 80 00 00 	movabs $0x80074c,%rcx
  802a7b:	00 00 00 
  802a7e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a85:	eb 2a                	jmp    802ab1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a8f:	48 85 c0             	test   %rax,%rax
  802a92:	75 07                	jne    802a9b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a99:	eb 16                	jmp    802ab1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aa7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802aaa:	89 ce                	mov    %ecx,%esi
  802aac:	48 89 d7             	mov    %rdx,%rdi
  802aaf:	ff d0                	callq  *%rax
}
  802ab1:	c9                   	leaveq 
  802ab2:	c3                   	retq   

0000000000802ab3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ab3:	55                   	push   %rbp
  802ab4:	48 89 e5             	mov    %rsp,%rbp
  802ab7:	48 83 ec 30          	sub    $0x30,%rsp
  802abb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802abe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ac2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac9:	48 89 d6             	mov    %rdx,%rsi
  802acc:	89 c7                	mov    %eax,%edi
  802ace:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  802ad5:	00 00 00 
  802ad8:	ff d0                	callq  *%rax
  802ada:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802add:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae1:	78 24                	js     802b07 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae7:	8b 00                	mov    (%rax),%eax
  802ae9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aed:	48 89 d6             	mov    %rdx,%rsi
  802af0:	89 c7                	mov    %eax,%edi
  802af2:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
  802afe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b05:	79 05                	jns    802b0c <fstat+0x59>
		return r;
  802b07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0a:	eb 5e                	jmp    802b6a <fstat+0xb7>
	if (!dev->dev_stat)
  802b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b10:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b14:	48 85 c0             	test   %rax,%rax
  802b17:	75 07                	jne    802b20 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b19:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1e:	eb 4a                	jmp    802b6a <fstat+0xb7>
	stat->st_name[0] = 0;
  802b20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b24:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b32:	00 00 00 
	stat->st_isdir = 0;
  802b35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b40:	00 00 00 
	stat->st_dev = dev;
  802b43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b4b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b56:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b5e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b62:	48 89 ce             	mov    %rcx,%rsi
  802b65:	48 89 d7             	mov    %rdx,%rdi
  802b68:	ff d0                	callq  *%rax
}
  802b6a:	c9                   	leaveq 
  802b6b:	c3                   	retq   

0000000000802b6c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b6c:	55                   	push   %rbp
  802b6d:	48 89 e5             	mov    %rsp,%rbp
  802b70:	48 83 ec 20          	sub    $0x20,%rsp
  802b74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b80:	be 00 00 00 00       	mov    $0x0,%esi
  802b85:	48 89 c7             	mov    %rax,%rdi
  802b88:	48 b8 5c 2c 80 00 00 	movabs $0x802c5c,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
  802b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9b:	79 05                	jns    802ba2 <stat+0x36>
		return fd;
  802b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba0:	eb 2f                	jmp    802bd1 <stat+0x65>
	r = fstat(fd, stat);
  802ba2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba9:	48 89 d6             	mov    %rdx,%rsi
  802bac:	89 c7                	mov    %eax,%edi
  802bae:	48 b8 b3 2a 80 00 00 	movabs $0x802ab3,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	callq  *%rax
  802bba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc0:	89 c7                	mov    %eax,%edi
  802bc2:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
	return r;
  802bce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bd1:	c9                   	leaveq 
  802bd2:	c3                   	retq   

0000000000802bd3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bd3:	55                   	push   %rbp
  802bd4:	48 89 e5             	mov    %rsp,%rbp
  802bd7:	48 83 ec 10          	sub    $0x10,%rsp
  802bdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802be2:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802be9:	00 00 00 
  802bec:	8b 00                	mov    (%rax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	75 1f                	jne    802c11 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bf2:	bf 01 00 00 00       	mov    $0x1,%edi
  802bf7:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
  802c03:	89 c2                	mov    %eax,%edx
  802c05:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802c0c:	00 00 00 
  802c0f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c11:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802c18:	00 00 00 
  802c1b:	8b 00                	mov    (%rax),%eax
  802c1d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c20:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c25:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c2c:	00 00 00 
  802c2f:	89 c7                	mov    %eax,%edi
  802c31:	48 b8 2b 44 80 00 00 	movabs $0x80442b,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c41:	ba 00 00 00 00       	mov    $0x0,%edx
  802c46:	48 89 c6             	mov    %rax,%rsi
  802c49:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4e:	48 b8 6a 43 80 00 00 	movabs $0x80436a,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
}
  802c5a:	c9                   	leaveq 
  802c5b:	c3                   	retq   

0000000000802c5c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c5c:	55                   	push   %rbp
  802c5d:	48 89 e5             	mov    %rsp,%rbp
  802c60:	48 83 ec 20          	sub    $0x20,%rsp
  802c64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c68:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6f:	48 89 c7             	mov    %rax,%rdi
  802c72:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax
  802c7e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c83:	7e 0a                	jle    802c8f <open+0x33>
		return -E_BAD_PATH;
  802c85:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c8a:	e9 a5 00 00 00       	jmpq   802d34 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c8f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c93:	48 89 c7             	mov    %rax,%rdi
  802c96:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	callq  *%rax
  802ca2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca9:	79 08                	jns    802cb3 <open+0x57>
		return r;
  802cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cae:	e9 81 00 00 00       	jmpq   802d34 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb7:	48 89 c6             	mov    %rax,%rsi
  802cba:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cc1:	00 00 00 
  802cc4:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  802ccb:	00 00 00 
  802cce:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802cd0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd7:	00 00 00 
  802cda:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cdd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce7:	48 89 c6             	mov    %rax,%rsi
  802cea:	bf 01 00 00 00       	mov    $0x1,%edi
  802cef:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d02:	79 1d                	jns    802d21 <open+0xc5>
		fd_close(fd, 0);
  802d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d08:	be 00 00 00 00       	mov    $0x0,%esi
  802d0d:	48 89 c7             	mov    %rax,%rdi
  802d10:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
		return r;
  802d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1f:	eb 13                	jmp    802d34 <open+0xd8>
	}

	return fd2num(fd);
  802d21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d25:	48 89 c7             	mov    %rax,%rdi
  802d28:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax

}
  802d34:	c9                   	leaveq 
  802d35:	c3                   	retq   

0000000000802d36 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d36:	55                   	push   %rbp
  802d37:	48 89 e5             	mov    %rsp,%rbp
  802d3a:	48 83 ec 10          	sub    $0x10,%rsp
  802d3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d46:	8b 50 0c             	mov    0xc(%rax),%edx
  802d49:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d50:	00 00 00 
  802d53:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d55:	be 00 00 00 00       	mov    $0x0,%esi
  802d5a:	bf 06 00 00 00       	mov    $0x6,%edi
  802d5f:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
}
  802d6b:	c9                   	leaveq 
  802d6c:	c3                   	retq   

0000000000802d6d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d6d:	55                   	push   %rbp
  802d6e:	48 89 e5             	mov    %rsp,%rbp
  802d71:	48 83 ec 30          	sub    $0x30,%rsp
  802d75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d7d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d85:	8b 50 0c             	mov    0xc(%rax),%edx
  802d88:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d8f:	00 00 00 
  802d92:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d9b:	00 00 00 
  802d9e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802da2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802da6:	be 00 00 00 00       	mov    $0x0,%esi
  802dab:	bf 03 00 00 00       	mov    $0x3,%edi
  802db0:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
  802dbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc3:	79 08                	jns    802dcd <devfile_read+0x60>
		return r;
  802dc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc8:	e9 a4 00 00 00       	jmpq   802e71 <devfile_read+0x104>
	assert(r <= n);
  802dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd0:	48 98                	cltq   
  802dd2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802dd6:	76 35                	jbe    802e0d <devfile_read+0xa0>
  802dd8:	48 b9 06 4c 80 00 00 	movabs $0x804c06,%rcx
  802ddf:	00 00 00 
  802de2:	48 ba 0d 4c 80 00 00 	movabs $0x804c0d,%rdx
  802de9:	00 00 00 
  802dec:	be 86 00 00 00       	mov    $0x86,%esi
  802df1:	48 bf 22 4c 80 00 00 	movabs $0x804c22,%rdi
  802df8:	00 00 00 
  802dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802e00:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  802e07:	00 00 00 
  802e0a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802e0d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802e14:	7e 35                	jle    802e4b <devfile_read+0xde>
  802e16:	48 b9 2d 4c 80 00 00 	movabs $0x804c2d,%rcx
  802e1d:	00 00 00 
  802e20:	48 ba 0d 4c 80 00 00 	movabs $0x804c0d,%rdx
  802e27:	00 00 00 
  802e2a:	be 87 00 00 00       	mov    $0x87,%esi
  802e2f:	48 bf 22 4c 80 00 00 	movabs $0x804c22,%rdi
  802e36:	00 00 00 
  802e39:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3e:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  802e45:	00 00 00 
  802e48:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4e:	48 63 d0             	movslq %eax,%rdx
  802e51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e55:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e5c:	00 00 00 
  802e5f:	48 89 c7             	mov    %rax,%rdi
  802e62:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
	return r;
  802e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 40          	sub    $0x40,%rsp
  802e7b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e7f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e83:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802e87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802e8f:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802e96:	00 
  802e97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802e9f:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802ea4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eac:	8b 50 0c             	mov    0xc(%rax),%edx
  802eaf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb6:	00 00 00 
  802eb9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ebb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec2:	00 00 00 
  802ec5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802ecd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ed1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed5:	48 89 c6             	mov    %rax,%rsi
  802ed8:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802edf:	00 00 00 
  802ee2:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802eee:	be 00 00 00 00       	mov    $0x0,%esi
  802ef3:	bf 04 00 00 00       	mov    $0x4,%edi
  802ef8:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
  802f04:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f07:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f0b:	79 05                	jns    802f12 <devfile_write+0x9f>
		return r;
  802f0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f10:	eb 43                	jmp    802f55 <devfile_write+0xe2>
	assert(r <= n);
  802f12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f15:	48 98                	cltq   
  802f17:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f1b:	76 35                	jbe    802f52 <devfile_write+0xdf>
  802f1d:	48 b9 06 4c 80 00 00 	movabs $0x804c06,%rcx
  802f24:	00 00 00 
  802f27:	48 ba 0d 4c 80 00 00 	movabs $0x804c0d,%rdx
  802f2e:	00 00 00 
  802f31:	be a2 00 00 00       	mov    $0xa2,%esi
  802f36:	48 bf 22 4c 80 00 00 	movabs $0x804c22,%rdi
  802f3d:	00 00 00 
  802f40:	b8 00 00 00 00       	mov    $0x0,%eax
  802f45:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  802f4c:	00 00 00 
  802f4f:	41 ff d0             	callq  *%r8
	return r;
  802f52:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802f55:	c9                   	leaveq 
  802f56:	c3                   	retq   

0000000000802f57 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f57:	55                   	push   %rbp
  802f58:	48 89 e5             	mov    %rsp,%rbp
  802f5b:	48 83 ec 20          	sub    $0x20,%rsp
  802f5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f6e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f75:	00 00 00 
  802f78:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f7a:	be 00 00 00 00       	mov    $0x0,%esi
  802f7f:	bf 05 00 00 00       	mov    $0x5,%edi
  802f84:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
  802f90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f97:	79 05                	jns    802f9e <devfile_stat+0x47>
		return r;
  802f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9c:	eb 56                	jmp    802ff4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fa9:	00 00 00 
  802fac:	48 89 c7             	mov    %rax,%rdi
  802faf:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc2:	00 00 00 
  802fc5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fcf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fd5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdc:	00 00 00 
  802fdf:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802fef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff4:	c9                   	leaveq 
  802ff5:	c3                   	retq   

0000000000802ff6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ff6:	55                   	push   %rbp
  802ff7:	48 89 e5             	mov    %rsp,%rbp
  802ffa:	48 83 ec 10          	sub    $0x10,%rsp
  802ffe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803002:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803009:	8b 50 0c             	mov    0xc(%rax),%edx
  80300c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803013:	00 00 00 
  803016:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803018:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80301f:	00 00 00 
  803022:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803025:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803028:	be 00 00 00 00       	mov    $0x0,%esi
  80302d:	bf 02 00 00 00       	mov    $0x2,%edi
  803032:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
}
  80303e:	c9                   	leaveq 
  80303f:	c3                   	retq   

0000000000803040 <remove>:

// Delete a file
int
remove(const char *path)
{
  803040:	55                   	push   %rbp
  803041:	48 89 e5             	mov    %rsp,%rbp
  803044:	48 83 ec 10          	sub    $0x10,%rsp
  803048:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80304c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803050:	48 89 c7             	mov    %rax,%rdi
  803053:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
  80305f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803064:	7e 07                	jle    80306d <remove+0x2d>
		return -E_BAD_PATH;
  803066:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80306b:	eb 33                	jmp    8030a0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80306d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803071:	48 89 c6             	mov    %rax,%rsi
  803074:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80307b:	00 00 00 
  80307e:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  803085:	00 00 00 
  803088:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80308a:	be 00 00 00 00       	mov    $0x0,%esi
  80308f:	bf 07 00 00 00       	mov    $0x7,%edi
  803094:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030a6:	be 00 00 00 00       	mov    $0x0,%esi
  8030ab:	bf 08 00 00 00       	mov    $0x8,%edi
  8030b0:	48 b8 d3 2b 80 00 00 	movabs $0x802bd3,%rax
  8030b7:	00 00 00 
  8030ba:	ff d0                	callq  *%rax
}
  8030bc:	5d                   	pop    %rbp
  8030bd:	c3                   	retq   

00000000008030be <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030be:	55                   	push   %rbp
  8030bf:	48 89 e5             	mov    %rsp,%rbp
  8030c2:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030c9:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030d0:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030d7:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030de:	be 00 00 00 00       	mov    $0x0,%esi
  8030e3:	48 89 c7             	mov    %rax,%rdi
  8030e6:	48 b8 5c 2c 80 00 00 	movabs $0x802c5c,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
  8030f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f9:	79 28                	jns    803123 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fe:	89 c6                	mov    %eax,%esi
  803100:	48 bf 39 4c 80 00 00 	movabs $0x804c39,%rdi
  803107:	00 00 00 
  80310a:	b8 00 00 00 00       	mov    $0x0,%eax
  80310f:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  803116:	00 00 00 
  803119:	ff d2                	callq  *%rdx
		return fd_src;
  80311b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311e:	e9 76 01 00 00       	jmpq   803299 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803123:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80312a:	be 01 01 00 00       	mov    $0x101,%esi
  80312f:	48 89 c7             	mov    %rax,%rdi
  803132:	48 b8 5c 2c 80 00 00 	movabs $0x802c5c,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
  80313e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803141:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803145:	0f 89 ad 00 00 00    	jns    8031f8 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80314b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314e:	89 c6                	mov    %eax,%esi
  803150:	48 bf 4f 4c 80 00 00 	movabs $0x804c4f,%rdi
  803157:	00 00 00 
  80315a:	b8 00 00 00 00       	mov    $0x0,%eax
  80315f:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  803166:	00 00 00 
  803169:	ff d2                	callq  *%rdx
		close(fd_src);
  80316b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316e:	89 c7                	mov    %eax,%edi
  803170:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
		return fd_dest;
  80317c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80317f:	e9 15 01 00 00       	jmpq   803299 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803184:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803187:	48 63 d0             	movslq %eax,%rdx
  80318a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803191:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803194:	48 89 ce             	mov    %rcx,%rsi
  803197:	89 c7                	mov    %eax,%edi
  803199:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
  8031a5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031ac:	79 4a                	jns    8031f8 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8031ae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031b1:	89 c6                	mov    %eax,%esi
  8031b3:	48 bf 69 4c 80 00 00 	movabs $0x804c69,%rdi
  8031ba:	00 00 00 
  8031bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c2:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  8031c9:	00 00 00 
  8031cc:	ff d2                	callq  *%rdx
			close(fd_src);
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	89 c7                	mov    %eax,%edi
  8031d3:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
			close(fd_dest);
  8031df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e2:	89 c7                	mov    %eax,%edi
  8031e4:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	callq  *%rax
			return write_size;
  8031f0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031f3:	e9 a1 00 00 00       	jmpq   803299 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031f8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803202:	ba 00 02 00 00       	mov    $0x200,%edx
  803207:	48 89 ce             	mov    %rcx,%rsi
  80320a:	89 c7                	mov    %eax,%edi
  80320c:	48 b8 83 27 80 00 00 	movabs $0x802783,%rax
  803213:	00 00 00 
  803216:	ff d0                	callq  *%rax
  803218:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80321b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80321f:	0f 8f 5f ff ff ff    	jg     803184 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803225:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803229:	79 47                	jns    803272 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80322b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80322e:	89 c6                	mov    %eax,%esi
  803230:	48 bf 7c 4c 80 00 00 	movabs $0x804c7c,%rdi
  803237:	00 00 00 
  80323a:	b8 00 00 00 00       	mov    $0x0,%eax
  80323f:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  803246:	00 00 00 
  803249:	ff d2                	callq  *%rdx
		close(fd_src);
  80324b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324e:	89 c7                	mov    %eax,%edi
  803250:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  803257:	00 00 00 
  80325a:	ff d0                	callq  *%rax
		close(fd_dest);
  80325c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80325f:	89 c7                	mov    %eax,%edi
  803261:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
		return read_size;
  80326d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803270:	eb 27                	jmp    803299 <copy+0x1db>
	}
	close(fd_src);
  803272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803275:	89 c7                	mov    %eax,%edi
  803277:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
	close(fd_dest);
  803283:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803286:	89 c7                	mov    %eax,%edi
  803288:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  80328f:	00 00 00 
  803292:	ff d0                	callq  *%rax
	return 0;
  803294:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803299:	c9                   	leaveq 
  80329a:	c3                   	retq   

000000000080329b <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80329b:	55                   	push   %rbp
  80329c:	48 89 e5             	mov    %rsp,%rbp
  80329f:	48 83 ec 20          	sub    $0x20,%rsp
  8032a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8032a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ab:	8b 40 0c             	mov    0xc(%rax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	7e 67                	jle    803319 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8032b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b6:	8b 40 04             	mov    0x4(%rax),%eax
  8032b9:	48 63 d0             	movslq %eax,%rdx
  8032bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c0:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8032c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c8:	8b 00                	mov    (%rax),%eax
  8032ca:	48 89 ce             	mov    %rcx,%rsi
  8032cd:	89 c7                	mov    %eax,%edi
  8032cf:	48 b8 ce 28 80 00 00 	movabs $0x8028ce,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
  8032db:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8032de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e2:	7e 13                	jle    8032f7 <writebuf+0x5c>
			b->result += result;
  8032e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e8:	8b 50 08             	mov    0x8(%rax),%edx
  8032eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ee:	01 c2                	add    %eax,%edx
  8032f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f4:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8032f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fb:	8b 40 04             	mov    0x4(%rax),%eax
  8032fe:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803301:	74 16                	je     803319 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803303:	b8 00 00 00 00       	mov    $0x0,%eax
  803308:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330c:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803310:	89 c2                	mov    %eax,%edx
  803312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803316:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803319:	90                   	nop
  80331a:	c9                   	leaveq 
  80331b:	c3                   	retq   

000000000080331c <putch>:

static void
putch(int ch, void *thunk)
{
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 83 ec 20          	sub    $0x20,%rsp
  803324:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80332b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803337:	8b 40 04             	mov    0x4(%rax),%eax
  80333a:	8d 48 01             	lea    0x1(%rax),%ecx
  80333d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803341:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803344:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803347:	89 d1                	mov    %edx,%ecx
  803349:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80334d:	48 98                	cltq   
  80334f:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803357:	8b 40 04             	mov    0x4(%rax),%eax
  80335a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80335f:	75 1e                	jne    80337f <putch+0x63>
		writebuf(b);
  803361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803365:	48 89 c7             	mov    %rax,%rdi
  803368:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  80336f:	00 00 00 
  803372:	ff d0                	callq  *%rax
		b->idx = 0;
  803374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803378:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80337f:	90                   	nop
  803380:	c9                   	leaveq 
  803381:	c3                   	retq   

0000000000803382 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803382:	55                   	push   %rbp
  803383:	48 89 e5             	mov    %rsp,%rbp
  803386:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80338d:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803393:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80339a:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8033a1:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8033a7:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8033ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8033b4:	00 00 00 
	b.result = 0;
  8033b7:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8033be:	00 00 00 
	b.error = 1;
  8033c1:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8033c8:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8033cb:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8033d2:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8033d9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8033e0:	48 89 c6             	mov    %rax,%rsi
  8033e3:	48 bf 1c 33 80 00 00 	movabs $0x80331c,%rdi
  8033ea:	00 00 00 
  8033ed:	48 b8 ea 0a 80 00 00 	movabs $0x800aea,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8033f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	7e 16                	jle    803419 <vfprintf+0x97>
		writebuf(&b);
  803403:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80340a:	48 89 c7             	mov    %rax,%rdi
  80340d:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  803414:	00 00 00 
  803417:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803419:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80341f:	85 c0                	test   %eax,%eax
  803421:	74 08                	je     80342b <vfprintf+0xa9>
  803423:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803429:	eb 06                	jmp    803431 <vfprintf+0xaf>
  80342b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803431:	c9                   	leaveq 
  803432:	c3                   	retq   

0000000000803433 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803433:	55                   	push   %rbp
  803434:	48 89 e5             	mov    %rsp,%rbp
  803437:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80343e:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803444:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80344b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803452:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803459:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803460:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803467:	84 c0                	test   %al,%al
  803469:	74 20                	je     80348b <fprintf+0x58>
  80346b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80346f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803473:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803477:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80347b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80347f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803483:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803487:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80348b:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803492:	00 00 00 
  803495:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80349c:	00 00 00 
  80349f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8034a3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8034aa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8034b1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8034b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8034bf:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8034c6:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8034cc:	48 89 ce             	mov    %rcx,%rsi
  8034cf:	89 c7                	mov    %eax,%edi
  8034d1:	48 b8 82 33 80 00 00 	movabs $0x803382,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
  8034dd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8034e3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034e9:	c9                   	leaveq 
  8034ea:	c3                   	retq   

00000000008034eb <printf>:

int
printf(const char *fmt, ...)
{
  8034eb:	55                   	push   %rbp
  8034ec:	48 89 e5             	mov    %rsp,%rbp
  8034ef:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8034f6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8034fd:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803504:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80350b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803512:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803519:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803520:	84 c0                	test   %al,%al
  803522:	74 20                	je     803544 <printf+0x59>
  803524:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803528:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80352c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803530:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803534:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803538:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80353c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803540:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803544:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80354b:	00 00 00 
  80354e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803555:	00 00 00 
  803558:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80355c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803563:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80356a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  803571:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803578:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80357f:	48 89 c6             	mov    %rax,%rsi
  803582:	bf 01 00 00 00       	mov    $0x1,%edi
  803587:	48 b8 82 33 80 00 00 	movabs $0x803382,%rax
  80358e:	00 00 00 
  803591:	ff d0                	callq  *%rax
  803593:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  803599:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80359f:	c9                   	leaveq 
  8035a0:	c3                   	retq   

00000000008035a1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8035a1:	55                   	push   %rbp
  8035a2:	48 89 e5             	mov    %rsp,%rbp
  8035a5:	48 83 ec 20          	sub    $0x20,%rsp
  8035a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8035ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b3:	48 89 d6             	mov    %rdx,%rsi
  8035b6:	89 c7                	mov    %eax,%edi
  8035b8:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8035bf:	00 00 00 
  8035c2:	ff d0                	callq  *%rax
  8035c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cb:	79 05                	jns    8035d2 <fd2sockid+0x31>
		return r;
  8035cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d0:	eb 24                	jmp    8035f6 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8035d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d6:	8b 10                	mov    (%rax),%edx
  8035d8:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8035df:	00 00 00 
  8035e2:	8b 00                	mov    (%rax),%eax
  8035e4:	39 c2                	cmp    %eax,%edx
  8035e6:	74 07                	je     8035ef <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8035e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8035ed:	eb 07                	jmp    8035f6 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8035ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f3:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8035f6:	c9                   	leaveq 
  8035f7:	c3                   	retq   

00000000008035f8 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8035f8:	55                   	push   %rbp
  8035f9:	48 89 e5             	mov    %rsp,%rbp
  8035fc:	48 83 ec 20          	sub    $0x20,%rsp
  803600:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803603:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803607:	48 89 c7             	mov    %rax,%rdi
  80360a:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  803611:	00 00 00 
  803614:	ff d0                	callq  *%rax
  803616:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803619:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80361d:	78 26                	js     803645 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80361f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803623:	ba 07 04 00 00       	mov    $0x407,%edx
  803628:	48 89 c6             	mov    %rax,%rsi
  80362b:	bf 00 00 00 00       	mov    $0x0,%edi
  803630:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
  80363c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803643:	79 16                	jns    80365b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803648:	89 c7                	mov    %eax,%edi
  80364a:	48 b8 07 3b 80 00 00 	movabs $0x803b07,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
		return r;
  803656:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803659:	eb 3a                	jmp    803695 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80365b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365f:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803666:	00 00 00 
  803669:	8b 12                	mov    (%rdx),%edx
  80366b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80366d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803671:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80367f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803686:	48 89 c7             	mov    %rax,%rdi
  803689:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  803690:	00 00 00 
  803693:	ff d0                	callq  *%rax
}
  803695:	c9                   	leaveq 
  803696:	c3                   	retq   

0000000000803697 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803697:	55                   	push   %rbp
  803698:	48 89 e5             	mov    %rsp,%rbp
  80369b:	48 83 ec 30          	sub    $0x30,%rsp
  80369f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ad:	89 c7                	mov    %eax,%edi
  8036af:	48 b8 a1 35 80 00 00 	movabs $0x8035a1,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c2:	79 05                	jns    8036c9 <accept+0x32>
		return r;
  8036c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c7:	eb 3b                	jmp    803704 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8036c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036cd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d4:	48 89 ce             	mov    %rcx,%rsi
  8036d7:	89 c7                	mov    %eax,%edi
  8036d9:	48 b8 e4 39 80 00 00 	movabs $0x8039e4,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
  8036e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ec:	79 05                	jns    8036f3 <accept+0x5c>
		return r;
  8036ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f1:	eb 11                	jmp    803704 <accept+0x6d>
	return alloc_sockfd(r);
  8036f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f6:	89 c7                	mov    %eax,%edi
  8036f8:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
}
  803704:	c9                   	leaveq 
  803705:	c3                   	retq   

0000000000803706 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803706:	55                   	push   %rbp
  803707:	48 89 e5             	mov    %rsp,%rbp
  80370a:	48 83 ec 20          	sub    $0x20,%rsp
  80370e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803711:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803715:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803718:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371b:	89 c7                	mov    %eax,%edi
  80371d:	48 b8 a1 35 80 00 00 	movabs $0x8035a1,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803730:	79 05                	jns    803737 <bind+0x31>
		return r;
  803732:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803735:	eb 1b                	jmp    803752 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803737:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80373a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80373e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803741:	48 89 ce             	mov    %rcx,%rsi
  803744:	89 c7                	mov    %eax,%edi
  803746:	48 b8 63 3a 80 00 00 	movabs $0x803a63,%rax
  80374d:	00 00 00 
  803750:	ff d0                	callq  *%rax
}
  803752:	c9                   	leaveq 
  803753:	c3                   	retq   

0000000000803754 <shutdown>:

int
shutdown(int s, int how)
{
  803754:	55                   	push   %rbp
  803755:	48 89 e5             	mov    %rsp,%rbp
  803758:	48 83 ec 20          	sub    $0x20,%rsp
  80375c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80375f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803762:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803765:	89 c7                	mov    %eax,%edi
  803767:	48 b8 a1 35 80 00 00 	movabs $0x8035a1,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
  803773:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803776:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377a:	79 05                	jns    803781 <shutdown+0x2d>
		return r;
  80377c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377f:	eb 16                	jmp    803797 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803781:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803787:	89 d6                	mov    %edx,%esi
  803789:	89 c7                	mov    %eax,%edi
  80378b:	48 b8 c7 3a 80 00 00 	movabs $0x803ac7,%rax
  803792:	00 00 00 
  803795:	ff d0                	callq  *%rax
}
  803797:	c9                   	leaveq 
  803798:	c3                   	retq   

0000000000803799 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803799:	55                   	push   %rbp
  80379a:	48 89 e5             	mov    %rsp,%rbp
  80379d:	48 83 ec 10          	sub    $0x10,%rsp
  8037a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8037a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a9:	48 89 c7             	mov    %rax,%rdi
  8037ac:	48 b8 31 45 80 00 00 	movabs $0x804531,%rax
  8037b3:	00 00 00 
  8037b6:	ff d0                	callq  *%rax
  8037b8:	83 f8 01             	cmp    $0x1,%eax
  8037bb:	75 17                	jne    8037d4 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8037bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8037c4:	89 c7                	mov    %eax,%edi
  8037c6:	48 b8 07 3b 80 00 00 	movabs $0x803b07,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
  8037d2:	eb 05                	jmp    8037d9 <devsock_close+0x40>
	else
		return 0;
  8037d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d9:	c9                   	leaveq 
  8037da:	c3                   	retq   

00000000008037db <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037db:	55                   	push   %rbp
  8037dc:	48 89 e5             	mov    %rsp,%rbp
  8037df:	48 83 ec 20          	sub    $0x20,%rsp
  8037e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037ea:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f0:	89 c7                	mov    %eax,%edi
  8037f2:	48 b8 a1 35 80 00 00 	movabs $0x8035a1,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
  8037fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803805:	79 05                	jns    80380c <connect+0x31>
		return r;
  803807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380a:	eb 1b                	jmp    803827 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80380c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80380f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803816:	48 89 ce             	mov    %rcx,%rsi
  803819:	89 c7                	mov    %eax,%edi
  80381b:	48 b8 34 3b 80 00 00 	movabs $0x803b34,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
}
  803827:	c9                   	leaveq 
  803828:	c3                   	retq   

0000000000803829 <listen>:

int
listen(int s, int backlog)
{
  803829:	55                   	push   %rbp
  80382a:	48 89 e5             	mov    %rsp,%rbp
  80382d:	48 83 ec 20          	sub    $0x20,%rsp
  803831:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803834:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803837:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80383a:	89 c7                	mov    %eax,%edi
  80383c:	48 b8 a1 35 80 00 00 	movabs $0x8035a1,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
  803848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384f:	79 05                	jns    803856 <listen+0x2d>
		return r;
  803851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803854:	eb 16                	jmp    80386c <listen+0x43>
	return nsipc_listen(r, backlog);
  803856:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385c:	89 d6                	mov    %edx,%esi
  80385e:	89 c7                	mov    %eax,%edi
  803860:	48 b8 98 3b 80 00 00 	movabs $0x803b98,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
}
  80386c:	c9                   	leaveq 
  80386d:	c3                   	retq   

000000000080386e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80386e:	55                   	push   %rbp
  80386f:	48 89 e5             	mov    %rsp,%rbp
  803872:	48 83 ec 20          	sub    $0x20,%rsp
  803876:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80387a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80387e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803886:	89 c2                	mov    %eax,%edx
  803888:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388c:	8b 40 0c             	mov    0xc(%rax),%eax
  80388f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803893:	b9 00 00 00 00       	mov    $0x0,%ecx
  803898:	89 c7                	mov    %eax,%edi
  80389a:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  8038a1:	00 00 00 
  8038a4:	ff d0                	callq  *%rax
}
  8038a6:	c9                   	leaveq 
  8038a7:	c3                   	retq   

00000000008038a8 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8038a8:	55                   	push   %rbp
  8038a9:	48 89 e5             	mov    %rsp,%rbp
  8038ac:	48 83 ec 20          	sub    $0x20,%rsp
  8038b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8038bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c0:	89 c2                	mov    %eax,%edx
  8038c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c6:	8b 40 0c             	mov    0xc(%rax),%eax
  8038c9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038d2:	89 c7                	mov    %eax,%edi
  8038d4:	48 b8 a4 3c 80 00 00 	movabs $0x803ca4,%rax
  8038db:	00 00 00 
  8038de:	ff d0                	callq  *%rax
}
  8038e0:	c9                   	leaveq 
  8038e1:	c3                   	retq   

00000000008038e2 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8038e2:	55                   	push   %rbp
  8038e3:	48 89 e5             	mov    %rsp,%rbp
  8038e6:	48 83 ec 10          	sub    $0x10,%rsp
  8038ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8038f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f6:	48 be 97 4c 80 00 00 	movabs $0x804c97,%rsi
  8038fd:	00 00 00 
  803900:	48 89 c7             	mov    %rax,%rdi
  803903:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
	return 0;
  80390f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803914:	c9                   	leaveq 
  803915:	c3                   	retq   

0000000000803916 <socket>:

int
socket(int domain, int type, int protocol)
{
  803916:	55                   	push   %rbp
  803917:	48 89 e5             	mov    %rsp,%rbp
  80391a:	48 83 ec 20          	sub    $0x20,%rsp
  80391e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803921:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803924:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803927:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80392a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80392d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803930:	89 ce                	mov    %ecx,%esi
  803932:	89 c7                	mov    %eax,%edi
  803934:	48 b8 5c 3d 80 00 00 	movabs $0x803d5c,%rax
  80393b:	00 00 00 
  80393e:	ff d0                	callq  *%rax
  803940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803947:	79 05                	jns    80394e <socket+0x38>
		return r;
  803949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394c:	eb 11                	jmp    80395f <socket+0x49>
	return alloc_sockfd(r);
  80394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803951:	89 c7                	mov    %eax,%edi
  803953:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  80395a:	00 00 00 
  80395d:	ff d0                	callq  *%rax
}
  80395f:	c9                   	leaveq 
  803960:	c3                   	retq   

0000000000803961 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803961:	55                   	push   %rbp
  803962:	48 89 e5             	mov    %rsp,%rbp
  803965:	48 83 ec 10          	sub    $0x10,%rsp
  803969:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80396c:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  803973:	00 00 00 
  803976:	8b 00                	mov    (%rax),%eax
  803978:	85 c0                	test   %eax,%eax
  80397a:	75 1f                	jne    80399b <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80397c:	bf 02 00 00 00       	mov    $0x2,%edi
  803981:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
  80398d:	89 c2                	mov    %eax,%edx
  80398f:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  803996:	00 00 00 
  803999:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80399b:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8039a2:	00 00 00 
  8039a5:	8b 00                	mov    (%rax),%eax
  8039a7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8039aa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8039af:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8039b6:	00 00 00 
  8039b9:	89 c7                	mov    %eax,%edi
  8039bb:	48 b8 2b 44 80 00 00 	movabs $0x80442b,%rax
  8039c2:	00 00 00 
  8039c5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8039c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8039cc:	be 00 00 00 00       	mov    $0x0,%esi
  8039d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d6:	48 b8 6a 43 80 00 00 	movabs $0x80436a,%rax
  8039dd:	00 00 00 
  8039e0:	ff d0                	callq  *%rax
}
  8039e2:	c9                   	leaveq 
  8039e3:	c3                   	retq   

00000000008039e4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039e4:	55                   	push   %rbp
  8039e5:	48 89 e5             	mov    %rsp,%rbp
  8039e8:	48 83 ec 30          	sub    $0x30,%rsp
  8039ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8039f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039fe:	00 00 00 
  803a01:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a04:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a06:	bf 01 00 00 00       	mov    $0x1,%edi
  803a0b:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803a12:	00 00 00 
  803a15:	ff d0                	callq  *%rax
  803a17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a1e:	78 3e                	js     803a5e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a20:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a27:	00 00 00 
  803a2a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a32:	8b 40 10             	mov    0x10(%rax),%eax
  803a35:	89 c2                	mov    %eax,%edx
  803a37:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803a3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3f:	48 89 ce             	mov    %rcx,%rsi
  803a42:	48 89 c7             	mov    %rax,%rdi
  803a45:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803a4c:	00 00 00 
  803a4f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a55:	8b 50 10             	mov    0x10(%rax),%edx
  803a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a61:	c9                   	leaveq 
  803a62:	c3                   	retq   

0000000000803a63 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a63:	55                   	push   %rbp
  803a64:	48 89 e5             	mov    %rsp,%rbp
  803a67:	48 83 ec 10          	sub    $0x10,%rsp
  803a6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a72:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a7c:	00 00 00 
  803a7f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a82:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a84:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8b:	48 89 c6             	mov    %rax,%rsi
  803a8e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a95:	00 00 00 
  803a98:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803aa4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aab:	00 00 00 
  803aae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ab1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803ab4:	bf 02 00 00 00       	mov    $0x2,%edi
  803ab9:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803ac0:	00 00 00 
  803ac3:	ff d0                	callq  *%rax
}
  803ac5:	c9                   	leaveq 
  803ac6:	c3                   	retq   

0000000000803ac7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ac7:	55                   	push   %rbp
  803ac8:	48 89 e5             	mov    %rsp,%rbp
  803acb:	48 83 ec 10          	sub    $0x10,%rsp
  803acf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ad5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803adc:	00 00 00 
  803adf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ae4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aeb:	00 00 00 
  803aee:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803af1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803af4:	bf 03 00 00 00       	mov    $0x3,%edi
  803af9:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
}
  803b05:	c9                   	leaveq 
  803b06:	c3                   	retq   

0000000000803b07 <nsipc_close>:

int
nsipc_close(int s)
{
  803b07:	55                   	push   %rbp
  803b08:	48 89 e5             	mov    %rsp,%rbp
  803b0b:	48 83 ec 10          	sub    $0x10,%rsp
  803b0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b12:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b19:	00 00 00 
  803b1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b1f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b21:	bf 04 00 00 00       	mov    $0x4,%edi
  803b26:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803b2d:	00 00 00 
  803b30:	ff d0                	callq  *%rax
}
  803b32:	c9                   	leaveq 
  803b33:	c3                   	retq   

0000000000803b34 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b34:	55                   	push   %rbp
  803b35:	48 89 e5             	mov    %rsp,%rbp
  803b38:	48 83 ec 10          	sub    $0x10,%rsp
  803b3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b43:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803b46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b4d:	00 00 00 
  803b50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b53:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803b55:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5c:	48 89 c6             	mov    %rax,%rsi
  803b5f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803b66:	00 00 00 
  803b69:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b7c:	00 00 00 
  803b7f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b82:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b85:	bf 05 00 00 00       	mov    $0x5,%edi
  803b8a:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
}
  803b96:	c9                   	leaveq 
  803b97:	c3                   	retq   

0000000000803b98 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b98:	55                   	push   %rbp
  803b99:	48 89 e5             	mov    %rsp,%rbp
  803b9c:	48 83 ec 10          	sub    $0x10,%rsp
  803ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ba6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bad:	00 00 00 
  803bb0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bb3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803bb5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bbc:	00 00 00 
  803bbf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bc2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803bc5:	bf 06 00 00 00       	mov    $0x6,%edi
  803bca:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
}
  803bd6:	c9                   	leaveq 
  803bd7:	c3                   	retq   

0000000000803bd8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803bd8:	55                   	push   %rbp
  803bd9:	48 89 e5             	mov    %rsp,%rbp
  803bdc:	48 83 ec 30          	sub    $0x30,%rsp
  803be0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803be3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803be7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803bea:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803bed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bf4:	00 00 00 
  803bf7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bfa:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803bfc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c03:	00 00 00 
  803c06:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c09:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c0c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c13:	00 00 00 
  803c16:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c19:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c1c:	bf 07 00 00 00       	mov    $0x7,%edi
  803c21:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax
  803c2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c34:	78 69                	js     803c9f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c36:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803c3d:	7f 08                	jg     803c47 <nsipc_recv+0x6f>
  803c3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c42:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803c45:	7e 35                	jle    803c7c <nsipc_recv+0xa4>
  803c47:	48 b9 9e 4c 80 00 00 	movabs $0x804c9e,%rcx
  803c4e:	00 00 00 
  803c51:	48 ba b3 4c 80 00 00 	movabs $0x804cb3,%rdx
  803c58:	00 00 00 
  803c5b:	be 62 00 00 00       	mov    $0x62,%esi
  803c60:	48 bf c8 4c 80 00 00 	movabs $0x804cc8,%rdi
  803c67:	00 00 00 
  803c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6f:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  803c76:	00 00 00 
  803c79:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7f:	48 63 d0             	movslq %eax,%rdx
  803c82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c86:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c8d:	00 00 00 
  803c90:	48 89 c7             	mov    %rax,%rdi
  803c93:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
	}

	return r;
  803c9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ca2:	c9                   	leaveq 
  803ca3:	c3                   	retq   

0000000000803ca4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 20          	sub    $0x20,%rsp
  803cac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803caf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cb3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803cb6:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803cb9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cc0:	00 00 00 
  803cc3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cc6:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803cc8:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ccf:	7e 35                	jle    803d06 <nsipc_send+0x62>
  803cd1:	48 b9 d4 4c 80 00 00 	movabs $0x804cd4,%rcx
  803cd8:	00 00 00 
  803cdb:	48 ba b3 4c 80 00 00 	movabs $0x804cb3,%rdx
  803ce2:	00 00 00 
  803ce5:	be 6d 00 00 00       	mov    $0x6d,%esi
  803cea:	48 bf c8 4c 80 00 00 	movabs $0x804cc8,%rdi
  803cf1:	00 00 00 
  803cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf9:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  803d00:	00 00 00 
  803d03:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d09:	48 63 d0             	movslq %eax,%rdx
  803d0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d10:	48 89 c6             	mov    %rax,%rsi
  803d13:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803d1a:	00 00 00 
  803d1d:	48 b8 5f 17 80 00 00 	movabs $0x80175f,%rax
  803d24:	00 00 00 
  803d27:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d29:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d30:	00 00 00 
  803d33:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d36:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803d39:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d40:	00 00 00 
  803d43:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d46:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803d49:	bf 08 00 00 00       	mov    $0x8,%edi
  803d4e:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803d55:	00 00 00 
  803d58:	ff d0                	callq  *%rax
}
  803d5a:	c9                   	leaveq 
  803d5b:	c3                   	retq   

0000000000803d5c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803d5c:	55                   	push   %rbp
  803d5d:	48 89 e5             	mov    %rsp,%rbp
  803d60:	48 83 ec 10          	sub    $0x10,%rsp
  803d64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d67:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d6a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803d6d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d74:	00 00 00 
  803d77:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d7a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d7c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d83:	00 00 00 
  803d86:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d89:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d8c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d93:	00 00 00 
  803d96:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d99:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d9c:	bf 09 00 00 00       	mov    $0x9,%edi
  803da1:	48 b8 61 39 80 00 00 	movabs $0x803961,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	callq  *%rax
}
  803dad:	c9                   	leaveq 
  803dae:	c3                   	retq   

0000000000803daf <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803daf:	55                   	push   %rbp
  803db0:	48 89 e5             	mov    %rsp,%rbp
  803db3:	53                   	push   %rbx
  803db4:	48 83 ec 38          	sub    $0x38,%rsp
  803db8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803dbc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803dc0:	48 89 c7             	mov    %rax,%rdi
  803dc3:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  803dca:	00 00 00 
  803dcd:	ff d0                	callq  *%rax
  803dcf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd6:	0f 88 bf 01 00 00    	js     803f9b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ddc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de0:	ba 07 04 00 00       	mov    $0x407,%edx
  803de5:	48 89 c6             	mov    %rax,%rsi
  803de8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ded:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803df4:	00 00 00 
  803df7:	ff d0                	callq  *%rax
  803df9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e00:	0f 88 95 01 00 00    	js     803f9b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e06:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e0a:	48 89 c7             	mov    %rax,%rdi
  803e0d:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  803e14:	00 00 00 
  803e17:	ff d0                	callq  *%rax
  803e19:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e20:	0f 88 5d 01 00 00    	js     803f83 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e2a:	ba 07 04 00 00       	mov    $0x407,%edx
  803e2f:	48 89 c6             	mov    %rax,%rsi
  803e32:	bf 00 00 00 00       	mov    $0x0,%edi
  803e37:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803e3e:	00 00 00 
  803e41:	ff d0                	callq  *%rax
  803e43:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e46:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e4a:	0f 88 33 01 00 00    	js     803f83 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e54:	48 89 c7             	mov    %rax,%rdi
  803e57:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  803e5e:	00 00 00 
  803e61:	ff d0                	callq  *%rax
  803e63:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6b:	ba 07 04 00 00       	mov    $0x407,%edx
  803e70:	48 89 c6             	mov    %rax,%rsi
  803e73:	bf 00 00 00 00       	mov    $0x0,%edi
  803e78:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803e7f:	00 00 00 
  803e82:	ff d0                	callq  *%rax
  803e84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e8b:	0f 88 d9 00 00 00    	js     803f6a <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e95:	48 89 c7             	mov    %rax,%rdi
  803e98:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  803e9f:	00 00 00 
  803ea2:	ff d0                	callq  *%rax
  803ea4:	48 89 c2             	mov    %rax,%rdx
  803ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eab:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803eb1:	48 89 d1             	mov    %rdx,%rcx
  803eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  803eb9:	48 89 c6             	mov    %rax,%rsi
  803ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec1:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  803ec8:	00 00 00 
  803ecb:	ff d0                	callq  *%rax
  803ecd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ed0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ed4:	78 79                	js     803f4f <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ed6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eda:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803ee1:	00 00 00 
  803ee4:	8b 12                	mov    (%rdx),%edx
  803ee6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ef3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ef7:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803efe:	00 00 00 
  803f01:	8b 12                	mov    (%rdx),%edx
  803f03:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f09:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f14:	48 89 c7             	mov    %rax,%rdi
  803f17:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  803f1e:	00 00 00 
  803f21:	ff d0                	callq  *%rax
  803f23:	89 c2                	mov    %eax,%edx
  803f25:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f29:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f2b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f2f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f37:	48 89 c7             	mov    %rax,%rdi
  803f3a:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f48:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4d:	eb 4f                	jmp    803f9e <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803f4f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f54:	48 89 c6             	mov    %rax,%rsi
  803f57:	bf 00 00 00 00       	mov    $0x0,%edi
  803f5c:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  803f63:	00 00 00 
  803f66:	ff d0                	callq  *%rax
  803f68:	eb 01                	jmp    803f6b <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803f6a:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6f:	48 89 c6             	mov    %rax,%rsi
  803f72:	bf 00 00 00 00       	mov    $0x0,%edi
  803f77:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  803f7e:	00 00 00 
  803f81:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f87:	48 89 c6             	mov    %rax,%rsi
  803f8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8f:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  803f96:	00 00 00 
  803f99:	ff d0                	callq  *%rax
err:
	return r;
  803f9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f9e:	48 83 c4 38          	add    $0x38,%rsp
  803fa2:	5b                   	pop    %rbx
  803fa3:	5d                   	pop    %rbp
  803fa4:	c3                   	retq   

0000000000803fa5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fa5:	55                   	push   %rbp
  803fa6:	48 89 e5             	mov    %rsp,%rbp
  803fa9:	53                   	push   %rbx
  803faa:	48 83 ec 28          	sub    $0x28,%rsp
  803fae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fb2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803fb6:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803fbd:	00 00 00 
  803fc0:	48 8b 00             	mov    (%rax),%rax
  803fc3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803fcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fd0:	48 89 c7             	mov    %rax,%rdi
  803fd3:	48 b8 31 45 80 00 00 	movabs $0x804531,%rax
  803fda:	00 00 00 
  803fdd:	ff d0                	callq  *%rax
  803fdf:	89 c3                	mov    %eax,%ebx
  803fe1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe5:	48 89 c7             	mov    %rax,%rdi
  803fe8:	48 b8 31 45 80 00 00 	movabs $0x804531,%rax
  803fef:	00 00 00 
  803ff2:	ff d0                	callq  *%rax
  803ff4:	39 c3                	cmp    %eax,%ebx
  803ff6:	0f 94 c0             	sete   %al
  803ff9:	0f b6 c0             	movzbl %al,%eax
  803ffc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803fff:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804006:	00 00 00 
  804009:	48 8b 00             	mov    (%rax),%rax
  80400c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804012:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804015:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804018:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80401b:	75 05                	jne    804022 <_pipeisclosed+0x7d>
			return ret;
  80401d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804020:	eb 4a                	jmp    80406c <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804022:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804025:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804028:	74 8c                	je     803fb6 <_pipeisclosed+0x11>
  80402a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80402e:	75 86                	jne    803fb6 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804030:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804037:	00 00 00 
  80403a:	48 8b 00             	mov    (%rax),%rax
  80403d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804043:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804046:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804049:	89 c6                	mov    %eax,%esi
  80404b:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  804052:	00 00 00 
  804055:	b8 00 00 00 00       	mov    $0x0,%eax
  80405a:	49 b8 4c 07 80 00 00 	movabs $0x80074c,%r8
  804061:	00 00 00 
  804064:	41 ff d0             	callq  *%r8
	}
  804067:	e9 4a ff ff ff       	jmpq   803fb6 <_pipeisclosed+0x11>

}
  80406c:	48 83 c4 28          	add    $0x28,%rsp
  804070:	5b                   	pop    %rbx
  804071:	5d                   	pop    %rbp
  804072:	c3                   	retq   

0000000000804073 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804073:	55                   	push   %rbp
  804074:	48 89 e5             	mov    %rsp,%rbp
  804077:	48 83 ec 30          	sub    $0x30,%rsp
  80407b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80407e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804082:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804085:	48 89 d6             	mov    %rdx,%rsi
  804088:	89 c7                	mov    %eax,%edi
  80408a:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  804091:	00 00 00 
  804094:	ff d0                	callq  *%rax
  804096:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804099:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409d:	79 05                	jns    8040a4 <pipeisclosed+0x31>
		return r;
  80409f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a2:	eb 31                	jmp    8040d5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a8:	48 89 c7             	mov    %rax,%rdi
  8040ab:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  8040b2:	00 00 00 
  8040b5:	ff d0                	callq  *%rax
  8040b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8040bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040c3:	48 89 d6             	mov    %rdx,%rsi
  8040c6:	48 89 c7             	mov    %rax,%rdi
  8040c9:	48 b8 a5 3f 80 00 00 	movabs $0x803fa5,%rax
  8040d0:	00 00 00 
  8040d3:	ff d0                	callq  *%rax
}
  8040d5:	c9                   	leaveq 
  8040d6:	c3                   	retq   

00000000008040d7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040d7:	55                   	push   %rbp
  8040d8:	48 89 e5             	mov    %rsp,%rbp
  8040db:	48 83 ec 40          	sub    $0x40,%rsp
  8040df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8040eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040ef:	48 89 c7             	mov    %rax,%rdi
  8040f2:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  8040f9:	00 00 00 
  8040fc:	ff d0                	callq  *%rax
  8040fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804102:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804106:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80410a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804111:	00 
  804112:	e9 90 00 00 00       	jmpq   8041a7 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804117:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80411c:	74 09                	je     804127 <devpipe_read+0x50>
				return i;
  80411e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804122:	e9 8e 00 00 00       	jmpq   8041b5 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804127:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80412b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80412f:	48 89 d6             	mov    %rdx,%rsi
  804132:	48 89 c7             	mov    %rax,%rdi
  804135:	48 b8 a5 3f 80 00 00 	movabs $0x803fa5,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
  804141:	85 c0                	test   %eax,%eax
  804143:	74 07                	je     80414c <devpipe_read+0x75>
				return 0;
  804145:	b8 00 00 00 00       	mov    $0x0,%eax
  80414a:	eb 69                	jmp    8041b5 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80414c:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  804153:	00 00 00 
  804156:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80415c:	8b 10                	mov    (%rax),%edx
  80415e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804162:	8b 40 04             	mov    0x4(%rax),%eax
  804165:	39 c2                	cmp    %eax,%edx
  804167:	74 ae                	je     804117 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804169:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80416d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804171:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804175:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804179:	8b 00                	mov    (%rax),%eax
  80417b:	99                   	cltd   
  80417c:	c1 ea 1b             	shr    $0x1b,%edx
  80417f:	01 d0                	add    %edx,%eax
  804181:	83 e0 1f             	and    $0x1f,%eax
  804184:	29 d0                	sub    %edx,%eax
  804186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80418a:	48 98                	cltq   
  80418c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804191:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804197:	8b 00                	mov    (%rax),%eax
  804199:	8d 50 01             	lea    0x1(%rax),%edx
  80419c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ab:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041af:	72 a7                	jb     804158 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8041b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8041b5:	c9                   	leaveq 
  8041b6:	c3                   	retq   

00000000008041b7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041b7:	55                   	push   %rbp
  8041b8:	48 89 e5             	mov    %rsp,%rbp
  8041bb:	48 83 ec 40          	sub    $0x40,%rsp
  8041bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8041cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cf:	48 89 c7             	mov    %rax,%rdi
  8041d2:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  8041d9:	00 00 00 
  8041dc:	ff d0                	callq  *%rax
  8041de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041f1:	00 
  8041f2:	e9 8f 00 00 00       	jmpq   804286 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8041f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041ff:	48 89 d6             	mov    %rdx,%rsi
  804202:	48 89 c7             	mov    %rax,%rdi
  804205:	48 b8 a5 3f 80 00 00 	movabs $0x803fa5,%rax
  80420c:	00 00 00 
  80420f:	ff d0                	callq  *%rax
  804211:	85 c0                	test   %eax,%eax
  804213:	74 07                	je     80421c <devpipe_write+0x65>
				return 0;
  804215:	b8 00 00 00 00       	mov    $0x0,%eax
  80421a:	eb 78                	jmp    804294 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80421c:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  804223:	00 00 00 
  804226:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80422c:	8b 40 04             	mov    0x4(%rax),%eax
  80422f:	48 63 d0             	movslq %eax,%rdx
  804232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804236:	8b 00                	mov    (%rax),%eax
  804238:	48 98                	cltq   
  80423a:	48 83 c0 20          	add    $0x20,%rax
  80423e:	48 39 c2             	cmp    %rax,%rdx
  804241:	73 b4                	jae    8041f7 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804247:	8b 40 04             	mov    0x4(%rax),%eax
  80424a:	99                   	cltd   
  80424b:	c1 ea 1b             	shr    $0x1b,%edx
  80424e:	01 d0                	add    %edx,%eax
  804250:	83 e0 1f             	and    $0x1f,%eax
  804253:	29 d0                	sub    %edx,%eax
  804255:	89 c6                	mov    %eax,%esi
  804257:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80425b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80425f:	48 01 d0             	add    %rdx,%rax
  804262:	0f b6 08             	movzbl (%rax),%ecx
  804265:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804269:	48 63 c6             	movslq %esi,%rax
  80426c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804274:	8b 40 04             	mov    0x4(%rax),%eax
  804277:	8d 50 01             	lea    0x1(%rax),%edx
  80427a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80427e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804281:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80428e:	72 98                	jb     804228 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804294:	c9                   	leaveq 
  804295:	c3                   	retq   

0000000000804296 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804296:	55                   	push   %rbp
  804297:	48 89 e5             	mov    %rsp,%rbp
  80429a:	48 83 ec 20          	sub    $0x20,%rsp
  80429e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042aa:	48 89 c7             	mov    %rax,%rdi
  8042ad:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8042bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042c1:	48 be f8 4c 80 00 00 	movabs $0x804cf8,%rsi
  8042c8:	00 00 00 
  8042cb:	48 89 c7             	mov    %rax,%rdi
  8042ce:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  8042d5:	00 00 00 
  8042d8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8042da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042de:	8b 50 04             	mov    0x4(%rax),%edx
  8042e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e5:	8b 00                	mov    (%rax),%eax
  8042e7:	29 c2                	sub    %eax,%edx
  8042e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042ed:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8042f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042f7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8042fe:	00 00 00 
	stat->st_dev = &devpipe;
  804301:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804305:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  80430c:	00 00 00 
  80430f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80431b:	c9                   	leaveq 
  80431c:	c3                   	retq   

000000000080431d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80431d:	55                   	push   %rbp
  80431e:	48 89 e5             	mov    %rsp,%rbp
  804321:	48 83 ec 10          	sub    $0x10,%rsp
  804325:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80432d:	48 89 c6             	mov    %rax,%rsi
  804330:	bf 00 00 00 00       	mov    $0x0,%edi
  804335:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  80433c:	00 00 00 
  80433f:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804345:	48 89 c7             	mov    %rax,%rdi
  804348:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  80434f:	00 00 00 
  804352:	ff d0                	callq  *%rax
  804354:	48 89 c6             	mov    %rax,%rsi
  804357:	bf 00 00 00 00       	mov    $0x0,%edi
  80435c:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  804363:	00 00 00 
  804366:	ff d0                	callq  *%rax
}
  804368:	c9                   	leaveq 
  804369:	c3                   	retq   

000000000080436a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80436a:	55                   	push   %rbp
  80436b:	48 89 e5             	mov    %rsp,%rbp
  80436e:	48 83 ec 30          	sub    $0x30,%rsp
  804372:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804376:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80437a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80437e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804383:	75 0e                	jne    804393 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804385:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80438c:	00 00 00 
  80438f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804393:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804397:	48 89 c7             	mov    %rax,%rdi
  80439a:	48 b8 aa 1f 80 00 00 	movabs $0x801faa,%rax
  8043a1:	00 00 00 
  8043a4:	ff d0                	callq  *%rax
  8043a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ad:	79 27                	jns    8043d6 <ipc_recv+0x6c>
		if (from_env_store)
  8043af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043b4:	74 0a                	je     8043c0 <ipc_recv+0x56>
			*from_env_store = 0;
  8043b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8043c0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043c5:	74 0a                	je     8043d1 <ipc_recv+0x67>
			*perm_store = 0;
  8043c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8043d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d4:	eb 53                	jmp    804429 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8043d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043db:	74 19                	je     8043f6 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8043dd:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8043e4:	00 00 00 
  8043e7:	48 8b 00             	mov    (%rax),%rax
  8043ea:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8043f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043f4:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8043f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043fb:	74 19                	je     804416 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8043fd:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804404:	00 00 00 
  804407:	48 8b 00             	mov    (%rax),%rax
  80440a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804414:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804416:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80441d:	00 00 00 
  804420:	48 8b 00             	mov    (%rax),%rax
  804423:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804429:	c9                   	leaveq 
  80442a:	c3                   	retq   

000000000080442b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80442b:	55                   	push   %rbp
  80442c:	48 89 e5             	mov    %rsp,%rbp
  80442f:	48 83 ec 30          	sub    $0x30,%rsp
  804433:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804436:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804439:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80443d:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804445:	75 1c                	jne    804463 <ipc_send+0x38>
		pg = (void*) UTOP;
  804447:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80444e:	00 00 00 
  804451:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804455:	eb 0c                	jmp    804463 <ipc_send+0x38>
		sys_yield();
  804457:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  80445e:	00 00 00 
  804461:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804463:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804466:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804469:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80446d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804470:	89 c7                	mov    %eax,%edi
  804472:	48 b8 53 1f 80 00 00 	movabs $0x801f53,%rax
  804479:	00 00 00 
  80447c:	ff d0                	callq  *%rax
  80447e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804481:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804485:	74 d0                	je     804457 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804487:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80448b:	79 30                	jns    8044bd <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80448d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804490:	89 c1                	mov    %eax,%ecx
  804492:	48 ba ff 4c 80 00 00 	movabs $0x804cff,%rdx
  804499:	00 00 00 
  80449c:	be 47 00 00 00       	mov    $0x47,%esi
  8044a1:	48 bf 15 4d 80 00 00 	movabs $0x804d15,%rdi
  8044a8:	00 00 00 
  8044ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b0:	49 b8 12 05 80 00 00 	movabs $0x800512,%r8
  8044b7:	00 00 00 
  8044ba:	41 ff d0             	callq  *%r8

}
  8044bd:	90                   	nop
  8044be:	c9                   	leaveq 
  8044bf:	c3                   	retq   

00000000008044c0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8044c0:	55                   	push   %rbp
  8044c1:	48 89 e5             	mov    %rsp,%rbp
  8044c4:	48 83 ec 18          	sub    $0x18,%rsp
  8044c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8044cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044d2:	eb 4d                	jmp    804521 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8044d4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8044db:	00 00 00 
  8044de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e1:	48 98                	cltq   
  8044e3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8044ea:	48 01 d0             	add    %rdx,%rax
  8044ed:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8044f3:	8b 00                	mov    (%rax),%eax
  8044f5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8044f8:	75 23                	jne    80451d <ipc_find_env+0x5d>
			return envs[i].env_id;
  8044fa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804501:	00 00 00 
  804504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804507:	48 98                	cltq   
  804509:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804510:	48 01 d0             	add    %rdx,%rax
  804513:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804519:	8b 00                	mov    (%rax),%eax
  80451b:	eb 12                	jmp    80452f <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80451d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804521:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804528:	7e aa                	jle    8044d4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80452a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80452f:	c9                   	leaveq 
  804530:	c3                   	retq   

0000000000804531 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804531:	55                   	push   %rbp
  804532:	48 89 e5             	mov    %rsp,%rbp
  804535:	48 83 ec 18          	sub    $0x18,%rsp
  804539:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80453d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804541:	48 c1 e8 15          	shr    $0x15,%rax
  804545:	48 89 c2             	mov    %rax,%rdx
  804548:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80454f:	01 00 00 
  804552:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804556:	83 e0 01             	and    $0x1,%eax
  804559:	48 85 c0             	test   %rax,%rax
  80455c:	75 07                	jne    804565 <pageref+0x34>
		return 0;
  80455e:	b8 00 00 00 00       	mov    $0x0,%eax
  804563:	eb 56                	jmp    8045bb <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804569:	48 c1 e8 0c          	shr    $0xc,%rax
  80456d:	48 89 c2             	mov    %rax,%rdx
  804570:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804577:	01 00 00 
  80457a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80457e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804586:	83 e0 01             	and    $0x1,%eax
  804589:	48 85 c0             	test   %rax,%rax
  80458c:	75 07                	jne    804595 <pageref+0x64>
		return 0;
  80458e:	b8 00 00 00 00       	mov    $0x0,%eax
  804593:	eb 26                	jmp    8045bb <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804599:	48 c1 e8 0c          	shr    $0xc,%rax
  80459d:	48 89 c2             	mov    %rax,%rdx
  8045a0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8045a7:	00 00 00 
  8045aa:	48 c1 e2 04          	shl    $0x4,%rdx
  8045ae:	48 01 d0             	add    %rdx,%rax
  8045b1:	48 83 c0 08          	add    $0x8,%rax
  8045b5:	0f b7 00             	movzwl (%rax),%eax
  8045b8:	0f b7 c0             	movzwl %ax,%eax
}
  8045bb:	c9                   	leaveq 
  8045bc:	c3                   	retq   
