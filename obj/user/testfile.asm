
obj/user/testfile:     file format elf64-x86-64


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
  80003c:	e8 1b 0c 00 00       	callq  800c5c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  800060:	00 00 00 
  800063:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 52 2a 80 00 00 	movabs $0x802a52,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 bd 29 80 00 00 	movabs $0x8029bd,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 fc 28 80 00 00 	movabs $0x8028fc,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec d8 02 00 00 	sub    $0x2d8,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 26 4c 80 00 00 	movabs $0x804c26,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 31 4c 80 00 00 	movabs $0x804c31,%rdx
  80012e:	00 00 00 
  800131:	be 21 00 00 00       	mov    $0x21,%esi
  800136:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 60 4c 80 00 00 	movabs $0x804c60,%rdx
  800160:	00 00 00 
  800163:	be 23 00 00 00       	mov    $0x23,%esi
  800168:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 81 4c 80 00 00 	movabs $0x804c81,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 8a 4c 80 00 00 	movabs $0x804c8a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 26 00 00 00       	mov    $0x26,%esi
  8001c1:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  800208:	00 00 00 
  80020b:	be 28 00 00 00       	mov    $0x28,%esi
  800210:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf d5 4c 80 00 00 	movabs $0x804cd5,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba e9 4c 80 00 00 	movabs $0x804ce9,%rdx
  800280:	00 00 00 
  800283:	be 2c 00 00 00       	mov    $0x2c,%esi
  800288:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 c2                	mov    %eax,%edx
  8002c2:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002c5:	39 c2                	cmp    %eax,%edx
  8002c7:	74 51                	je     80031a <umain+0x242>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002d0:	00 00 00 
  8002d3:	48 8b 00             	mov    (%rax),%rax
  8002d6:	48 89 c7             	mov    %rax,%rdi
  8002d9:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax
  8002e5:	89 c2                	mov    %eax,%edx
  8002e7:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002ea:	41 89 d0             	mov    %edx,%r8d
  8002ed:	89 c1                	mov    %eax,%ecx
  8002ef:	48 ba f8 4c 80 00 00 	movabs $0x804cf8,%rdx
  8002f6:	00 00 00 
  8002f9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8002fe:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800305:	00 00 00 
  800308:	b8 00 00 00 00       	mov    $0x0,%eax
  80030d:	49 b9 04 0d 80 00 00 	movabs $0x800d04,%r9
  800314:	00 00 00 
  800317:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  80031a:	48 bf 1e 4d 80 00 00 	movabs $0x804d1e,%rdi
  800321:	00 00 00 
  800324:	b8 00 00 00 00       	mov    $0x0,%eax
  800329:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800330:	00 00 00 
  800333:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800335:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033c:	ba 00 02 00 00       	mov    $0x200,%edx
  800341:	be 00 00 00 00       	mov    $0x0,%esi
  800346:	48 89 c7             	mov    %rax,%rdi
  800349:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  800350:	00 00 00 
  800353:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800355:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80035c:	00 00 00 
  80035f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800363:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  80036a:	ba 00 02 00 00       	mov    $0x200,%edx
  80036f:	48 89 ce             	mov    %rcx,%rsi
  800372:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800377:	ff d0                	callq  *%rax
  800379:	48 98                	cltq   
  80037b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800384:	79 32                	jns    8003b8 <umain+0x2e0>
		panic("file_read: %e", r);
  800386:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80038a:	48 89 c1             	mov    %rax,%rcx
  80038d:	48 ba 31 4d 80 00 00 	movabs $0x804d31,%rdx
  800394:	00 00 00 
  800397:	be 33 00 00 00       	mov    $0x33,%esi
  80039c:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8003a3:	00 00 00 
  8003a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ab:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8003b2:	00 00 00 
  8003b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003bf:	00 00 00 
  8003c2:	48 8b 10             	mov    (%rax),%rdx
  8003c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003cc:	48 89 d6             	mov    %rdx,%rsi
  8003cf:	48 89 c7             	mov    %rax,%rdi
  8003d2:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	callq  *%rax
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	74 2a                	je     80040c <umain+0x334>
		panic("file_read returned wrong data");
  8003e2:	48 ba 3f 4d 80 00 00 	movabs $0x804d3f,%rdx
  8003e9:	00 00 00 
  8003ec:	be 35 00 00 00       	mov    $0x35,%esi
  8003f1:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8003f8:	00 00 00 
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800400:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  800407:	00 00 00 
  80040a:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040c:	48 bf 5d 4d 80 00 00 	movabs $0x804d5d,%rdi
  800413:	00 00 00 
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
  80041b:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800422:	00 00 00 
  800425:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800427:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80042e:	00 00 00 
  800431:	48 8b 40 20          	mov    0x20(%rax),%rax
  800435:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80043a:	ff d0                	callq  *%rax
  80043c:	48 98                	cltq   
  80043e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800442:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800447:	79 32                	jns    80047b <umain+0x3a3>
		panic("file_close: %e", r);
  800449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044d:	48 89 c1             	mov    %rax,%rcx
  800450:	48 ba 70 4d 80 00 00 	movabs $0x804d70,%rdx
  800457:	00 00 00 
  80045a:	be 39 00 00 00       	mov    $0x39,%esi
  80045f:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800466:	00 00 00 
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800475:	00 00 00 
  800478:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  80047b:	48 bf 7f 4d 80 00 00 	movabs $0x804d7f,%rdi
  800482:	00 00 00 
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800491:	00 00 00 
  800494:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800496:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  80049b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049f:	48 8b 00             	mov    (%rax),%rax
  8004a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004aa:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004af:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b4:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004c0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8004c7:	00 00 00 
  8004ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004ce:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d5:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d9:	ba 00 02 00 00       	mov    $0x200,%edx
  8004de:	48 89 cf             	mov    %rcx,%rdi
  8004e1:	ff d0                	callq  *%rax
  8004e3:	48 98                	cltq   
  8004e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e9:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ee:	74 32                	je     800522 <umain+0x44a>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f4:	48 89 c1             	mov    %rax,%rcx
  8004f7:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  8004fe:	00 00 00 
  800501:	be 44 00 00 00       	mov    $0x44,%esi
  800506:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80050d:	00 00 00 
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80051c:	00 00 00 
  80051f:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800522:	48 bf cf 4d 80 00 00 	movabs $0x804dcf,%rdi
  800529:	00 00 00 
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
  800531:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800538:	00 00 00 
  80053b:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053d:	be 02 01 00 00       	mov    $0x102,%esi
  800542:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  800549:	00 00 00 
  80054c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800553:	00 00 00 
  800556:	ff d0                	callq  *%rax
  800558:	48 98                	cltq   
  80055a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800563:	79 32                	jns    800597 <umain+0x4bf>
		panic("serve_open /new-file: %e", r);
  800565:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800569:	48 89 c1             	mov    %rax,%rcx
  80056c:	48 ba ef 4d 80 00 00 	movabs $0x804def,%rdx
  800573:	00 00 00 
  800576:	be 49 00 00 00       	mov    $0x49,%esi
  80057b:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800582:	00 00 00 
  800585:	b8 00 00 00 00       	mov    $0x0,%eax
  80058a:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800591:	00 00 00 
  800594:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800597:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80059e:	00 00 00 
  8005a1:	48 8b 10             	mov    (%rax),%rdx
  8005a4:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005ab:	00 00 00 
  8005ae:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b2:	48 83 ec 08          	sub    $0x8,%rsp
  8005b6:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005bd:	00 00 00 
  8005c0:	ff 70 30             	pushq  0x30(%rax)
  8005c3:	ff 70 28             	pushq  0x28(%rax)
  8005c6:	ff 70 20             	pushq  0x20(%rax)
  8005c9:	ff 70 18             	pushq  0x18(%rax)
  8005cc:	ff 70 10             	pushq  0x10(%rax)
  8005cf:	ff 70 08             	pushq  0x8(%rax)
  8005d2:	ff 30                	pushq  (%rax)
  8005d4:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005d9:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  8005e0:	00 00 00 
  8005e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e8:	49 b8 3e 0f 80 00 00 	movabs $0x800f3e,%r8
  8005ef:	00 00 00 
  8005f2:	41 ff d0             	callq  *%r8
  8005f5:	48 83 c4 40          	add    $0x40,%rsp

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  8005f9:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  800600:	00 00 00 
  800603:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800607:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80060e:	00 00 00 
  800611:	48 8b 00             	mov    (%rax),%rax
  800614:	48 89 c7             	mov    %rax,%rdi
  800617:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80061e:	00 00 00 
  800621:	ff d0                	callq  *%rax
  800623:	48 63 d0             	movslq %eax,%rdx
  800626:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c6             	mov    %rax,%rsi
  800636:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80063b:	ff d3                	callq  *%rbx
  80063d:	48 98                	cltq   
  80063f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800643:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80064a:	00 00 00 
  80064d:	48 8b 00             	mov    (%rax),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	48 98                	cltq   
  800661:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800665:	74 32                	je     800699 <umain+0x5c1>
		panic("file_write: %e", r);
  800667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80066b:	48 89 c1             	mov    %rax,%rcx
  80066e:	48 ba 48 4e 80 00 00 	movabs $0x804e48,%rdx
  800675:	00 00 00 
  800678:	be 4e 00 00 00       	mov    $0x4e,%esi
  80067d:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800684:	00 00 00 
  800687:	b8 00 00 00 00       	mov    $0x0,%eax
  80068c:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800693:	00 00 00 
  800696:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  800699:	48 bf 57 4e 80 00 00 	movabs $0x804e57,%rdi
  8006a0:	00 00 00 
  8006a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a8:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  8006af:	00 00 00 
  8006b2:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006b4:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006c0:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006c7:	ba 00 02 00 00       	mov    $0x200,%edx
  8006cc:	be 00 00 00 00       	mov    $0x0,%esi
  8006d1:	48 89 c7             	mov    %rax,%rdi
  8006d4:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8006db:	00 00 00 
  8006de:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006e0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8006e7:	00 00 00 
  8006ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  8006ee:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  8006f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8006fa:	48 89 ce             	mov    %rcx,%rsi
  8006fd:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800702:	ff d0                	callq  *%rax
  800704:	48 98                	cltq   
  800706:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80070a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80070f:	79 32                	jns    800743 <umain+0x66b>
		panic("file_read after file_write: %e", r);
  800711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800715:	48 89 c1             	mov    %rax,%rcx
  800718:	48 ba 70 4e 80 00 00 	movabs $0x804e70,%rdx
  80071f:	00 00 00 
  800722:	be 54 00 00 00       	mov    $0x54,%esi
  800727:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80072e:	00 00 00 
  800731:	b8 00 00 00 00       	mov    $0x0,%eax
  800736:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80073d:	00 00 00 
  800740:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800743:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80074a:	00 00 00 
  80074d:	48 8b 00             	mov    (%rax),%rax
  800750:	48 89 c7             	mov    %rax,%rdi
  800753:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80075a:	00 00 00 
  80075d:	ff d0                	callq  *%rax
  80075f:	48 98                	cltq   
  800761:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800765:	74 32                	je     800799 <umain+0x6c1>
		panic("file_read after file_write returned wrong length: %d", r);
  800767:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80076b:	48 89 c1             	mov    %rax,%rcx
  80076e:	48 ba 90 4e 80 00 00 	movabs $0x804e90,%rdx
  800775:	00 00 00 
  800778:	be 56 00 00 00       	mov    $0x56,%esi
  80077d:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800784:	00 00 00 
  800787:	b8 00 00 00 00       	mov    $0x0,%eax
  80078c:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800793:	00 00 00 
  800796:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  800799:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8007a0:	00 00 00 
  8007a3:	48 8b 10             	mov    (%rax),%rdx
  8007a6:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007ad:	48 89 d6             	mov    %rdx,%rsi
  8007b0:	48 89 c7             	mov    %rax,%rdi
  8007b3:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8007ba:	00 00 00 
  8007bd:	ff d0                	callq  *%rax
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	74 2a                	je     8007ed <umain+0x715>
		panic("file_read after file_write returned wrong data");
  8007c3:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  8007ca:	00 00 00 
  8007cd:	be 58 00 00 00       	mov    $0x58,%esi
  8007d2:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8007d9:	00 00 00 
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  8007e8:	00 00 00 
  8007eb:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  8007ed:	48 bf f8 4e 80 00 00 	movabs $0x804ef8,%rdi
  8007f4:	00 00 00 
  8007f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fc:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800803:	00 00 00 
  800806:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800808:	be 00 00 00 00       	mov    $0x0,%esi
  80080d:	48 bf 26 4c 80 00 00 	movabs $0x804c26,%rdi
  800814:	00 00 00 
  800817:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
  800823:	48 98                	cltq   
  800825:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800829:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80082e:	79 39                	jns    800869 <umain+0x791>
  800830:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800835:	74 32                	je     800869 <umain+0x791>
		panic("open /not-found: %e", r);
  800837:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80083b:	48 89 c1             	mov    %rax,%rcx
  80083e:	48 ba 1c 4f 80 00 00 	movabs $0x804f1c,%rdx
  800845:	00 00 00 
  800848:	be 5d 00 00 00       	mov    $0x5d,%esi
  80084d:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800854:	00 00 00 
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800863:	00 00 00 
  800866:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800869:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80086e:	78 2a                	js     80089a <umain+0x7c2>
		panic("open /not-found succeeded!");
  800870:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
  800877:	00 00 00 
  80087a:	be 5f 00 00 00       	mov    $0x5f,%esi
  80087f:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800886:	00 00 00 
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
  80088e:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  800895:	00 00 00 
  800898:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80089a:	be 00 00 00 00       	mov    $0x0,%esi
  80089f:	48 bf 81 4c 80 00 00 	movabs $0x804c81,%rdi
  8008a6:	00 00 00 
  8008a9:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  8008b0:	00 00 00 
  8008b3:	ff d0                	callq  *%rax
  8008b5:	48 98                	cltq   
  8008b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008c0:	79 32                	jns    8008f4 <umain+0x81c>
		panic("open /newmotd: %e", r);
  8008c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008c6:	48 89 c1             	mov    %rax,%rcx
  8008c9:	48 ba 4b 4f 80 00 00 	movabs $0x804f4b,%rdx
  8008d0:	00 00 00 
  8008d3:	be 62 00 00 00       	mov    $0x62,%esi
  8008d8:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8008df:	00 00 00 
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e7:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8008ee:	00 00 00 
  8008f1:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  8008f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008f8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8008fe:	48 c1 e0 0c          	shl    $0xc,%rax
  800902:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	83 f8 66             	cmp    $0x66,%eax
  80090f:	75 16                	jne    800927 <umain+0x84f>
  800911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800915:	8b 40 04             	mov    0x4(%rax),%eax
  800918:	85 c0                	test   %eax,%eax
  80091a:	75 0b                	jne    800927 <umain+0x84f>
  80091c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800920:	8b 40 08             	mov    0x8(%rax),%eax
  800923:	85 c0                	test   %eax,%eax
  800925:	74 2a                	je     800951 <umain+0x879>
		panic("open did not fill struct Fd correctly\n");
  800927:	48 ba 60 4f 80 00 00 	movabs $0x804f60,%rdx
  80092e:	00 00 00 
  800931:	be 65 00 00 00       	mov    $0x65,%esi
  800936:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  80093d:	00 00 00 
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  80094c:	00 00 00 
  80094f:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800951:	48 bf 87 4f 80 00 00 	movabs $0x804f87,%rdi
  800958:	00 00 00 
  80095b:	b8 00 00 00 00       	mov    $0x0,%eax
  800960:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800967:	00 00 00 
  80096a:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80096c:	be 01 01 00 00       	mov    $0x101,%esi
  800971:	48 bf 95 4f 80 00 00 	movabs $0x804f95,%rdi
  800978:	00 00 00 
  80097b:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
  800987:	48 98                	cltq   
  800989:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80098d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800992:	79 32                	jns    8009c6 <umain+0x8ee>
		panic("creat /big: %e", f);
  800994:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800998:	48 89 c1             	mov    %rax,%rcx
  80099b:	48 ba 9a 4f 80 00 00 	movabs $0x804f9a,%rdx
  8009a2:	00 00 00 
  8009a5:	be 6a 00 00 00       	mov    $0x6a,%esi
  8009aa:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  8009b1:	00 00 00 
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b9:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8009c0:	00 00 00 
  8009c3:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009c6:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009cd:	ba 00 02 00 00       	mov    $0x200,%edx
  8009d2:	be 00 00 00 00       	mov    $0x0,%esi
  8009d7:	48 89 c7             	mov    %rax,%rdi
  8009da:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8009e1:	00 00 00 
  8009e4:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8009e6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8009ed:	00 
  8009ee:	e9 84 00 00 00       	jmpq   800a77 <umain+0x99f>
		*(int*)buf = i;
  8009f3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a04:	89 c1                	mov    %eax,%ecx
  800a06:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a0d:	ba 00 02 00 00       	mov    $0x200,%edx
  800a12:	48 89 c6             	mov    %rax,%rsi
  800a15:	89 cf                	mov    %ecx,%edi
  800a17:	48 b8 29 31 80 00 00 	movabs $0x803129,%rax
  800a1e:	00 00 00 
  800a21:	ff d0                	callq  *%rax
  800a23:	48 98                	cltq   
  800a25:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a2e:	79 39                	jns    800a69 <umain+0x991>
			panic("write /big@%d: %e", i, r);
  800a30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	49 89 d0             	mov    %rdx,%r8
  800a3b:	48 89 c1             	mov    %rax,%rcx
  800a3e:	48 ba a9 4f 80 00 00 	movabs $0x804fa9,%rdx
  800a45:	00 00 00 
  800a48:	be 6f 00 00 00       	mov    $0x6f,%esi
  800a4d:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800a54:	00 00 00 
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5c:	49 b9 04 0d 80 00 00 	movabs $0x800d04,%r9
  800a63:	00 00 00 
  800a66:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6d:	48 05 00 02 00 00    	add    $0x200,%rax
  800a73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a77:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a7e:	00 
  800a7f:	0f 8e 6e ff ff ff    	jle    8009f3 <umain+0x91b>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800a85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a89:	89 c7                	mov    %eax,%edi
  800a8b:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  800a92:	00 00 00 
  800a95:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800a97:	be 00 00 00 00       	mov    $0x0,%esi
  800a9c:	48 bf 95 4f 80 00 00 	movabs $0x804f95,%rdi
  800aa3:	00 00 00 
  800aa6:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 98                	cltq   
  800ab4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ab8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800abd:	79 32                	jns    800af1 <umain+0xa19>
		panic("open /big: %e", f);
  800abf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ac3:	48 89 c1             	mov    %rax,%rcx
  800ac6:	48 ba bb 4f 80 00 00 	movabs $0x804fbb,%rdx
  800acd:	00 00 00 
  800ad0:	be 74 00 00 00       	mov    $0x74,%esi
  800ad5:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800adc:	00 00 00 
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800aeb:	00 00 00 
  800aee:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800af1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800af8:	00 
  800af9:	e9 1c 01 00 00       	jmpq   800c1a <umain+0xb42>
		*(int*)buf = i;
  800afe:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b09:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b0f:	89 c1                	mov    %eax,%ecx
  800b11:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b18:	ba 00 02 00 00       	mov    $0x200,%edx
  800b1d:	48 89 c6             	mov    %rax,%rsi
  800b20:	89 cf                	mov    %ecx,%edi
  800b22:	48 b8 b3 30 80 00 00 	movabs $0x8030b3,%rax
  800b29:	00 00 00 
  800b2c:	ff d0                	callq  *%rax
  800b2e:	48 98                	cltq   
  800b30:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b34:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b39:	79 39                	jns    800b74 <umain+0xa9c>
			panic("read /big@%d: %e", i, r);
  800b3b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b43:	49 89 d0             	mov    %rdx,%r8
  800b46:	48 89 c1             	mov    %rax,%rcx
  800b49:	48 ba c9 4f 80 00 00 	movabs $0x804fc9,%rdx
  800b50:	00 00 00 
  800b53:	be 78 00 00 00       	mov    $0x78,%esi
  800b58:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800b5f:	00 00 00 
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	49 b9 04 0d 80 00 00 	movabs $0x800d04,%r9
  800b6e:	00 00 00 
  800b71:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b74:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b7b:	00 
  800b7c:	74 3f                	je     800bbd <umain+0xae5>
			panic("read /big from %d returned %d < %d bytes",
  800b7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b86:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800b8c:	49 89 d0             	mov    %rdx,%r8
  800b8f:	48 89 c1             	mov    %rax,%rcx
  800b92:	48 ba e0 4f 80 00 00 	movabs $0x804fe0,%rdx
  800b99:	00 00 00 
  800b9c:	be 7b 00 00 00       	mov    $0x7b,%esi
  800ba1:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800ba8:	00 00 00 
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	49 ba 04 0d 80 00 00 	movabs $0x800d04,%r10
  800bb7:	00 00 00 
  800bba:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bbd:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bc4:	8b 00                	mov    (%rax),%eax
  800bc6:	48 98                	cltq   
  800bc8:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800bcc:	74 3e                	je     800c0c <umain+0xb34>
			panic("read /big from %d returned bad data %d",
  800bce:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bd5:	8b 10                	mov    (%rax),%edx
  800bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdb:	41 89 d0             	mov    %edx,%r8d
  800bde:	48 89 c1             	mov    %rax,%rcx
  800be1:	48 ba 10 50 80 00 00 	movabs $0x805010,%rdx
  800be8:	00 00 00 
  800beb:	be 7e 00 00 00       	mov    $0x7e,%esi
  800bf0:	48 bf 4b 4c 80 00 00 	movabs $0x804c4b,%rdi
  800bf7:	00 00 00 
  800bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800bff:	49 b9 04 0d 80 00 00 	movabs $0x800d04,%r9
  800c06:	00 00 00 
  800c09:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c10:	48 05 00 02 00 00    	add    $0x200,%rax
  800c16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c1a:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c21:	00 
  800c22:	0f 8e d6 fe ff ff    	jle    800afe <umain+0xa26>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c2c:	89 c7                	mov    %eax,%edi
  800c2e:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  800c35:	00 00 00 
  800c38:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c3a:	48 bf 37 50 80 00 00 	movabs $0x805037,%rdi
  800c41:	00 00 00 
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
  800c49:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800c50:	00 00 00 
  800c53:	ff d2                	callq  *%rdx
}
  800c55:	90                   	nop
  800c56:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c5a:	c9                   	leaveq 
  800c5b:	c3                   	retq   

0000000000800c5c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c5c:	55                   	push   %rbp
  800c5d:	48 89 e5             	mov    %rsp,%rbp
  800c60:	48 83 ec 10          	sub    $0x10,%rsp
  800c64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800c6b:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  800c72:	00 00 00 
  800c75:	ff d0                	callq  *%rax
  800c77:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c7c:	48 98                	cltq   
  800c7e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800c85:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800c8c:	00 00 00 
  800c8f:	48 01 c2             	add    %rax,%rdx
  800c92:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800c99:	00 00 00 
  800c9c:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ca3:	7e 14                	jle    800cb9 <libmain+0x5d>
		binaryname = argv[0];
  800ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca9:	48 8b 10             	mov    (%rax),%rdx
  800cac:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cb3:	00 00 00 
  800cb6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800cb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cc0:	48 89 d6             	mov    %rdx,%rsi
  800cc3:	89 c7                	mov    %eax,%edi
  800cc5:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cd1:	48 b8 e0 0c 80 00 00 	movabs $0x800ce0,%rax
  800cd8:	00 00 00 
  800cdb:	ff d0                	callq  *%rax
}
  800cdd:	90                   	nop
  800cde:	c9                   	leaveq 
  800cdf:	c3                   	retq   

0000000000800ce0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ce0:	55                   	push   %rbp
  800ce1:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800ce4:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  800ceb:	00 00 00 
  800cee:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf5:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  800cfc:	00 00 00 
  800cff:	ff d0                	callq  *%rax
}
  800d01:	90                   	nop
  800d02:	5d                   	pop    %rbp
  800d03:	c3                   	retq   

0000000000800d04 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d04:	55                   	push   %rbp
  800d05:	48 89 e5             	mov    %rsp,%rbp
  800d08:	53                   	push   %rbx
  800d09:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d10:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d17:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d1d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800d24:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d2b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d32:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d39:	84 c0                	test   %al,%al
  800d3b:	74 23                	je     800d60 <_panic+0x5c>
  800d3d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d44:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d48:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d4c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d50:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d54:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d58:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d5c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d60:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d67:	00 00 00 
  800d6a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d71:	00 00 00 
  800d74:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d78:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d7f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800d86:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d8d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d94:	00 00 00 
  800d97:	48 8b 18             	mov    (%rax),%rbx
  800d9a:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  800da1:	00 00 00 
  800da4:	ff d0                	callq  *%rax
  800da6:	89 c6                	mov    %eax,%esi
  800da8:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800dae:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800db5:	41 89 d0             	mov    %edx,%r8d
  800db8:	48 89 c1             	mov    %rax,%rcx
  800dbb:	48 89 da             	mov    %rbx,%rdx
  800dbe:	48 bf 58 50 80 00 00 	movabs $0x805058,%rdi
  800dc5:	00 00 00 
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	49 b9 3e 0f 80 00 00 	movabs $0x800f3e,%r9
  800dd4:	00 00 00 
  800dd7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800dda:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800de1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800de8:	48 89 d6             	mov    %rdx,%rsi
  800deb:	48 89 c7             	mov    %rax,%rdi
  800dee:	48 b8 92 0e 80 00 00 	movabs $0x800e92,%rax
  800df5:	00 00 00 
  800df8:	ff d0                	callq  *%rax
	cprintf("\n");
  800dfa:	48 bf 7b 50 80 00 00 	movabs $0x80507b,%rdi
  800e01:	00 00 00 
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800e10:	00 00 00 
  800e13:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e15:	cc                   	int3   
  800e16:	eb fd                	jmp    800e15 <_panic+0x111>

0000000000800e18 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800e18:	55                   	push   %rbp
  800e19:	48 89 e5             	mov    %rsp,%rbp
  800e1c:	48 83 ec 10          	sub    $0x10,%rsp
  800e20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2b:	8b 00                	mov    (%rax),%eax
  800e2d:	8d 48 01             	lea    0x1(%rax),%ecx
  800e30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e34:	89 0a                	mov    %ecx,(%rdx)
  800e36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e39:	89 d1                	mov    %edx,%ecx
  800e3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e3f:	48 98                	cltq   
  800e41:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e49:	8b 00                	mov    (%rax),%eax
  800e4b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e50:	75 2c                	jne    800e7e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e56:	8b 00                	mov    (%rax),%eax
  800e58:	48 98                	cltq   
  800e5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5e:	48 83 c2 08          	add    $0x8,%rdx
  800e62:	48 89 c6             	mov    %rax,%rsi
  800e65:	48 89 d7             	mov    %rdx,%rdi
  800e68:	48 b8 bc 22 80 00 00 	movabs $0x8022bc,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	callq  *%rax
        b->idx = 0;
  800e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e78:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e82:	8b 40 04             	mov    0x4(%rax),%eax
  800e85:	8d 50 01             	lea    0x1(%rax),%edx
  800e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8c:	89 50 04             	mov    %edx,0x4(%rax)
}
  800e8f:	90                   	nop
  800e90:	c9                   	leaveq 
  800e91:	c3                   	retq   

0000000000800e92 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800e92:	55                   	push   %rbp
  800e93:	48 89 e5             	mov    %rsp,%rbp
  800e96:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800e9d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ea4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800eab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800eb2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800eb9:	48 8b 0a             	mov    (%rdx),%rcx
  800ebc:	48 89 08             	mov    %rcx,(%rax)
  800ebf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ec3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ecb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ecf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ed6:	00 00 00 
    b.cnt = 0;
  800ed9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ee0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ee3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800eea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ef1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ef8:	48 89 c6             	mov    %rax,%rsi
  800efb:	48 bf 18 0e 80 00 00 	movabs $0x800e18,%rdi
  800f02:	00 00 00 
  800f05:	48 b8 dc 12 80 00 00 	movabs $0x8012dc,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800f11:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f17:	48 98                	cltq   
  800f19:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f20:	48 83 c2 08          	add    $0x8,%rdx
  800f24:	48 89 c6             	mov    %rax,%rsi
  800f27:	48 89 d7             	mov    %rdx,%rdi
  800f2a:	48 b8 bc 22 80 00 00 	movabs $0x8022bc,%rax
  800f31:	00 00 00 
  800f34:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f36:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f3c:	c9                   	leaveq 
  800f3d:	c3                   	retq   

0000000000800f3e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f3e:	55                   	push   %rbp
  800f3f:	48 89 e5             	mov    %rsp,%rbp
  800f42:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f49:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f50:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f57:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f5e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f65:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f6c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f73:	84 c0                	test   %al,%al
  800f75:	74 20                	je     800f97 <cprintf+0x59>
  800f77:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f7b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f7f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f83:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f87:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f8b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f8f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f93:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800f97:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800f9e:	00 00 00 
  800fa1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fa8:	00 00 00 
  800fab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800faf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fb6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fbd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800fc4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fcb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fd2:	48 8b 0a             	mov    (%rdx),%rcx
  800fd5:	48 89 08             	mov    %rcx,(%rax)
  800fd8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fdc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fe0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fe4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800fe8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800fef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ff6:	48 89 d6             	mov    %rdx,%rsi
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 92 0e 80 00 00 	movabs $0x800e92,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
  801008:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80100e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801014:	c9                   	leaveq 
  801015:	c3                   	retq   

0000000000801016 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	48 83 ec 30          	sub    $0x30,%rsp
  80101e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801022:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801026:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80102a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80102d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  801031:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801035:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801038:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80103c:	77 54                	ja     801092 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80103e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801041:	8d 78 ff             	lea    -0x1(%rax),%edi
  801044:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104b:	ba 00 00 00 00       	mov    $0x0,%edx
  801050:	48 f7 f6             	div    %rsi
  801053:	49 89 c2             	mov    %rax,%r10
  801056:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801059:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80105c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801064:	41 89 c9             	mov    %ecx,%r9d
  801067:	41 89 f8             	mov    %edi,%r8d
  80106a:	89 d1                	mov    %edx,%ecx
  80106c:	4c 89 d2             	mov    %r10,%rdx
  80106f:	48 89 c7             	mov    %rax,%rdi
  801072:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  801079:	00 00 00 
  80107c:	ff d0                	callq  *%rax
  80107e:	eb 1c                	jmp    80109c <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801080:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801084:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	48 89 ce             	mov    %rcx,%rsi
  80108e:	89 d7                	mov    %edx,%edi
  801090:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801092:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  801096:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80109a:	7f e4                	jg     801080 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80109c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a8:	48 f7 f1             	div    %rcx
  8010ab:	48 b8 70 52 80 00 00 	movabs $0x805270,%rax
  8010b2:	00 00 00 
  8010b5:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8010b9:	0f be d0             	movsbl %al,%edx
  8010bc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8010c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c4:	48 89 ce             	mov    %rcx,%rsi
  8010c7:	89 d7                	mov    %edx,%edi
  8010c9:	ff d0                	callq  *%rax
}
  8010cb:	90                   	nop
  8010cc:	c9                   	leaveq 
  8010cd:	c3                   	retq   

00000000008010ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010ce:	55                   	push   %rbp
  8010cf:	48 89 e5             	mov    %rsp,%rbp
  8010d2:	48 83 ec 20          	sub    $0x20,%rsp
  8010d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010da:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8010dd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010e1:	7e 4f                	jle    801132 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8010e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e7:	8b 00                	mov    (%rax),%eax
  8010e9:	83 f8 30             	cmp    $0x30,%eax
  8010ec:	73 24                	jae    801112 <getuint+0x44>
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	8b 00                	mov    (%rax),%eax
  8010fc:	89 c0                	mov    %eax,%eax
  8010fe:	48 01 d0             	add    %rdx,%rax
  801101:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801105:	8b 12                	mov    (%rdx),%edx
  801107:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80110a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80110e:	89 0a                	mov    %ecx,(%rdx)
  801110:	eb 14                	jmp    801126 <getuint+0x58>
  801112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801116:	48 8b 40 08          	mov    0x8(%rax),%rax
  80111a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80111e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801122:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801126:	48 8b 00             	mov    (%rax),%rax
  801129:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80112d:	e9 9d 00 00 00       	jmpq   8011cf <getuint+0x101>
	else if (lflag)
  801132:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801136:	74 4c                	je     801184 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	8b 00                	mov    (%rax),%eax
  80113e:	83 f8 30             	cmp    $0x30,%eax
  801141:	73 24                	jae    801167 <getuint+0x99>
  801143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801147:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80114b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114f:	8b 00                	mov    (%rax),%eax
  801151:	89 c0                	mov    %eax,%eax
  801153:	48 01 d0             	add    %rdx,%rax
  801156:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80115a:	8b 12                	mov    (%rdx),%edx
  80115c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80115f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801163:	89 0a                	mov    %ecx,(%rdx)
  801165:	eb 14                	jmp    80117b <getuint+0xad>
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80116f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801173:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801177:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80117b:	48 8b 00             	mov    (%rax),%rax
  80117e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801182:	eb 4b                	jmp    8011cf <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  801184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801188:	8b 00                	mov    (%rax),%eax
  80118a:	83 f8 30             	cmp    $0x30,%eax
  80118d:	73 24                	jae    8011b3 <getuint+0xe5>
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801193:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119b:	8b 00                	mov    (%rax),%eax
  80119d:	89 c0                	mov    %eax,%eax
  80119f:	48 01 d0             	add    %rdx,%rax
  8011a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a6:	8b 12                	mov    (%rdx),%edx
  8011a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011af:	89 0a                	mov    %ecx,(%rdx)
  8011b1:	eb 14                	jmp    8011c7 <getuint+0xf9>
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011bb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8011bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011c7:	8b 00                	mov    (%rax),%eax
  8011c9:	89 c0                	mov    %eax,%eax
  8011cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d3:	c9                   	leaveq 
  8011d4:	c3                   	retq   

00000000008011d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011d5:	55                   	push   %rbp
  8011d6:	48 89 e5             	mov    %rsp,%rbp
  8011d9:	48 83 ec 20          	sub    $0x20,%rsp
  8011dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8011e4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8011e8:	7e 4f                	jle    801239 <getint+0x64>
		x=va_arg(*ap, long long);
  8011ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ee:	8b 00                	mov    (%rax),%eax
  8011f0:	83 f8 30             	cmp    $0x30,%eax
  8011f3:	73 24                	jae    801219 <getint+0x44>
  8011f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801201:	8b 00                	mov    (%rax),%eax
  801203:	89 c0                	mov    %eax,%eax
  801205:	48 01 d0             	add    %rdx,%rax
  801208:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80120c:	8b 12                	mov    (%rdx),%edx
  80120e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801211:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801215:	89 0a                	mov    %ecx,(%rdx)
  801217:	eb 14                	jmp    80122d <getint+0x58>
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801221:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801225:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801229:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80122d:	48 8b 00             	mov    (%rax),%rax
  801230:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801234:	e9 9d 00 00 00       	jmpq   8012d6 <getint+0x101>
	else if (lflag)
  801239:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80123d:	74 4c                	je     80128b <getint+0xb6>
		x=va_arg(*ap, long);
  80123f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801243:	8b 00                	mov    (%rax),%eax
  801245:	83 f8 30             	cmp    $0x30,%eax
  801248:	73 24                	jae    80126e <getint+0x99>
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801256:	8b 00                	mov    (%rax),%eax
  801258:	89 c0                	mov    %eax,%eax
  80125a:	48 01 d0             	add    %rdx,%rax
  80125d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801261:	8b 12                	mov    (%rdx),%edx
  801263:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801266:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80126a:	89 0a                	mov    %ecx,(%rdx)
  80126c:	eb 14                	jmp    801282 <getint+0xad>
  80126e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801272:	48 8b 40 08          	mov    0x8(%rax),%rax
  801276:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80127a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801282:	48 8b 00             	mov    (%rax),%rax
  801285:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801289:	eb 4b                	jmp    8012d6 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80128b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128f:	8b 00                	mov    (%rax),%eax
  801291:	83 f8 30             	cmp    $0x30,%eax
  801294:	73 24                	jae    8012ba <getint+0xe5>
  801296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	8b 00                	mov    (%rax),%eax
  8012a4:	89 c0                	mov    %eax,%eax
  8012a6:	48 01 d0             	add    %rdx,%rax
  8012a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ad:	8b 12                	mov    (%rdx),%edx
  8012af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b6:	89 0a                	mov    %ecx,(%rdx)
  8012b8:	eb 14                	jmp    8012ce <getint+0xf9>
  8012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8012c2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8012c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012ce:	8b 00                	mov    (%rax),%eax
  8012d0:	48 98                	cltq   
  8012d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8012d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012da:	c9                   	leaveq 
  8012db:	c3                   	retq   

00000000008012dc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	41 54                	push   %r12
  8012e2:	53                   	push   %rbx
  8012e3:	48 83 ec 60          	sub    $0x60,%rsp
  8012e7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8012eb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8012ef:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8012f3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8012f7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012fb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8012ff:	48 8b 0a             	mov    (%rdx),%rcx
  801302:	48 89 08             	mov    %rcx,(%rax)
  801305:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801309:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80130d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801311:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801315:	eb 17                	jmp    80132e <vprintfmt+0x52>
			if (ch == '\0')
  801317:	85 db                	test   %ebx,%ebx
  801319:	0f 84 b9 04 00 00    	je     8017d8 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80131f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801323:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801327:	48 89 d6             	mov    %rdx,%rsi
  80132a:	89 df                	mov    %ebx,%edi
  80132c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80132e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801332:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801336:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	0f b6 d8             	movzbl %al,%ebx
  801340:	83 fb 25             	cmp    $0x25,%ebx
  801343:	75 d2                	jne    801317 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801345:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801349:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801350:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801357:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80135e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801365:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801369:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80136d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801371:	0f b6 00             	movzbl (%rax),%eax
  801374:	0f b6 d8             	movzbl %al,%ebx
  801377:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80137a:	83 f8 55             	cmp    $0x55,%eax
  80137d:	0f 87 22 04 00 00    	ja     8017a5 <vprintfmt+0x4c9>
  801383:	89 c0                	mov    %eax,%eax
  801385:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80138c:	00 
  80138d:	48 b8 98 52 80 00 00 	movabs $0x805298,%rax
  801394:	00 00 00 
  801397:	48 01 d0             	add    %rdx,%rax
  80139a:	48 8b 00             	mov    (%rax),%rax
  80139d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80139f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013a3:	eb c0                	jmp    801365 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013a5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013a9:	eb ba                	jmp    801365 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013ab:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013b2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013b5:	89 d0                	mov    %edx,%eax
  8013b7:	c1 e0 02             	shl    $0x2,%eax
  8013ba:	01 d0                	add    %edx,%eax
  8013bc:	01 c0                	add    %eax,%eax
  8013be:	01 d8                	add    %ebx,%eax
  8013c0:	83 e8 30             	sub    $0x30,%eax
  8013c3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8013c6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013ca:	0f b6 00             	movzbl (%rax),%eax
  8013cd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013d0:	83 fb 2f             	cmp    $0x2f,%ebx
  8013d3:	7e 60                	jle    801435 <vprintfmt+0x159>
  8013d5:	83 fb 39             	cmp    $0x39,%ebx
  8013d8:	7f 5b                	jg     801435 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013da:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8013df:	eb d1                	jmp    8013b2 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8013e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013e4:	83 f8 30             	cmp    $0x30,%eax
  8013e7:	73 17                	jae    801400 <vprintfmt+0x124>
  8013e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013f0:	89 d2                	mov    %edx,%edx
  8013f2:	48 01 d0             	add    %rdx,%rax
  8013f5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013f8:	83 c2 08             	add    $0x8,%edx
  8013fb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013fe:	eb 0c                	jmp    80140c <vprintfmt+0x130>
  801400:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801404:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801408:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80140c:	8b 00                	mov    (%rax),%eax
  80140e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801411:	eb 23                	jmp    801436 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  801413:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801417:	0f 89 48 ff ff ff    	jns    801365 <vprintfmt+0x89>
				width = 0;
  80141d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801424:	e9 3c ff ff ff       	jmpq   801365 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801429:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801430:	e9 30 ff ff ff       	jmpq   801365 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801435:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801436:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80143a:	0f 89 25 ff ff ff    	jns    801365 <vprintfmt+0x89>
				width = precision, precision = -1;
  801440:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801443:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801446:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80144d:	e9 13 ff ff ff       	jmpq   801365 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801452:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801456:	e9 0a ff ff ff       	jmpq   801365 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80145b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80145e:	83 f8 30             	cmp    $0x30,%eax
  801461:	73 17                	jae    80147a <vprintfmt+0x19e>
  801463:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801467:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80146a:	89 d2                	mov    %edx,%edx
  80146c:	48 01 d0             	add    %rdx,%rax
  80146f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801472:	83 c2 08             	add    $0x8,%edx
  801475:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801478:	eb 0c                	jmp    801486 <vprintfmt+0x1aa>
  80147a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80147e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801482:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801486:	8b 10                	mov    (%rax),%edx
  801488:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80148c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801490:	48 89 ce             	mov    %rcx,%rsi
  801493:	89 d7                	mov    %edx,%edi
  801495:	ff d0                	callq  *%rax
			break;
  801497:	e9 37 03 00 00       	jmpq   8017d3 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80149c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80149f:	83 f8 30             	cmp    $0x30,%eax
  8014a2:	73 17                	jae    8014bb <vprintfmt+0x1df>
  8014a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014a8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014ab:	89 d2                	mov    %edx,%edx
  8014ad:	48 01 d0             	add    %rdx,%rax
  8014b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b3:	83 c2 08             	add    $0x8,%edx
  8014b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014b9:	eb 0c                	jmp    8014c7 <vprintfmt+0x1eb>
  8014bb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8014bf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8014c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014c7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8014c9:	85 db                	test   %ebx,%ebx
  8014cb:	79 02                	jns    8014cf <vprintfmt+0x1f3>
				err = -err;
  8014cd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8014cf:	83 fb 15             	cmp    $0x15,%ebx
  8014d2:	7f 16                	jg     8014ea <vprintfmt+0x20e>
  8014d4:	48 b8 c0 51 80 00 00 	movabs $0x8051c0,%rax
  8014db:	00 00 00 
  8014de:	48 63 d3             	movslq %ebx,%rdx
  8014e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8014e5:	4d 85 e4             	test   %r12,%r12
  8014e8:	75 2e                	jne    801518 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8014ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f2:	89 d9                	mov    %ebx,%ecx
  8014f4:	48 ba 81 52 80 00 00 	movabs $0x805281,%rdx
  8014fb:	00 00 00 
  8014fe:	48 89 c7             	mov    %rax,%rdi
  801501:	b8 00 00 00 00       	mov    $0x0,%eax
  801506:	49 b8 e2 17 80 00 00 	movabs $0x8017e2,%r8
  80150d:	00 00 00 
  801510:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801513:	e9 bb 02 00 00       	jmpq   8017d3 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801518:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80151c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801520:	4c 89 e1             	mov    %r12,%rcx
  801523:	48 ba 8a 52 80 00 00 	movabs $0x80528a,%rdx
  80152a:	00 00 00 
  80152d:	48 89 c7             	mov    %rax,%rdi
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
  801535:	49 b8 e2 17 80 00 00 	movabs $0x8017e2,%r8
  80153c:	00 00 00 
  80153f:	41 ff d0             	callq  *%r8
			break;
  801542:	e9 8c 02 00 00       	jmpq   8017d3 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801547:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80154a:	83 f8 30             	cmp    $0x30,%eax
  80154d:	73 17                	jae    801566 <vprintfmt+0x28a>
  80154f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801553:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801556:	89 d2                	mov    %edx,%edx
  801558:	48 01 d0             	add    %rdx,%rax
  80155b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80155e:	83 c2 08             	add    $0x8,%edx
  801561:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801564:	eb 0c                	jmp    801572 <vprintfmt+0x296>
  801566:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80156a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80156e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801572:	4c 8b 20             	mov    (%rax),%r12
  801575:	4d 85 e4             	test   %r12,%r12
  801578:	75 0a                	jne    801584 <vprintfmt+0x2a8>
				p = "(null)";
  80157a:	49 bc 8d 52 80 00 00 	movabs $0x80528d,%r12
  801581:	00 00 00 
			if (width > 0 && padc != '-')
  801584:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801588:	7e 78                	jle    801602 <vprintfmt+0x326>
  80158a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80158e:	74 72                	je     801602 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  801590:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801593:	48 98                	cltq   
  801595:	48 89 c6             	mov    %rax,%rsi
  801598:	4c 89 e7             	mov    %r12,%rdi
  80159b:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  8015a2:	00 00 00 
  8015a5:	ff d0                	callq  *%rax
  8015a7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015aa:	eb 17                	jmp    8015c3 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8015ac:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8015b0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8015b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015b8:	48 89 ce             	mov    %rcx,%rsi
  8015bb:	89 d7                	mov    %edx,%edi
  8015bd:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015bf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8015c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015c7:	7f e3                	jg     8015ac <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015c9:	eb 37                	jmp    801602 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8015cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8015cf:	74 1e                	je     8015ef <vprintfmt+0x313>
  8015d1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015d4:	7e 05                	jle    8015db <vprintfmt+0x2ff>
  8015d6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015d9:	7e 14                	jle    8015ef <vprintfmt+0x313>
					putch('?', putdat);
  8015db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015e3:	48 89 d6             	mov    %rdx,%rsi
  8015e6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8015eb:	ff d0                	callq  *%rax
  8015ed:	eb 0f                	jmp    8015fe <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8015ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015f7:	48 89 d6             	mov    %rdx,%rsi
  8015fa:	89 df                	mov    %ebx,%edi
  8015fc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801602:	4c 89 e0             	mov    %r12,%rax
  801605:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	0f be d8             	movsbl %al,%ebx
  80160f:	85 db                	test   %ebx,%ebx
  801611:	74 28                	je     80163b <vprintfmt+0x35f>
  801613:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801617:	78 b2                	js     8015cb <vprintfmt+0x2ef>
  801619:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80161d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801621:	79 a8                	jns    8015cb <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801623:	eb 16                	jmp    80163b <vprintfmt+0x35f>
				putch(' ', putdat);
  801625:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801629:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80162d:	48 89 d6             	mov    %rdx,%rsi
  801630:	bf 20 00 00 00       	mov    $0x20,%edi
  801635:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801637:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80163b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80163f:	7f e4                	jg     801625 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  801641:	e9 8d 01 00 00       	jmpq   8017d3 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801646:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80164a:	be 03 00 00 00       	mov    $0x3,%esi
  80164f:	48 89 c7             	mov    %rax,%rdi
  801652:	48 b8 d5 11 80 00 00 	movabs $0x8011d5,%rax
  801659:	00 00 00 
  80165c:	ff d0                	callq  *%rax
  80165e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801666:	48 85 c0             	test   %rax,%rax
  801669:	79 1d                	jns    801688 <vprintfmt+0x3ac>
				putch('-', putdat);
  80166b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80166f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801673:	48 89 d6             	mov    %rdx,%rsi
  801676:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80167b:	ff d0                	callq  *%rax
				num = -(long long) num;
  80167d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801681:	48 f7 d8             	neg    %rax
  801684:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801688:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80168f:	e9 d2 00 00 00       	jmpq   801766 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801694:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801698:	be 03 00 00 00       	mov    $0x3,%esi
  80169d:	48 89 c7             	mov    %rax,%rdi
  8016a0:	48 b8 ce 10 80 00 00 	movabs $0x8010ce,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016b0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016b7:	e9 aa 00 00 00       	jmpq   801766 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8016bc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016c0:	be 03 00 00 00       	mov    $0x3,%esi
  8016c5:	48 89 c7             	mov    %rax,%rdi
  8016c8:	48 b8 ce 10 80 00 00 	movabs $0x8010ce,%rax
  8016cf:	00 00 00 
  8016d2:	ff d0                	callq  *%rax
  8016d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8016d8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8016df:	e9 82 00 00 00       	jmpq   801766 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  8016e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016ec:	48 89 d6             	mov    %rdx,%rsi
  8016ef:	bf 30 00 00 00       	mov    $0x30,%edi
  8016f4:	ff d0                	callq  *%rax
			putch('x', putdat);
  8016f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016fe:	48 89 d6             	mov    %rdx,%rsi
  801701:	bf 78 00 00 00       	mov    $0x78,%edi
  801706:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801708:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80170b:	83 f8 30             	cmp    $0x30,%eax
  80170e:	73 17                	jae    801727 <vprintfmt+0x44b>
  801710:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801714:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801717:	89 d2                	mov    %edx,%edx
  801719:	48 01 d0             	add    %rdx,%rax
  80171c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80171f:	83 c2 08             	add    $0x8,%edx
  801722:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801725:	eb 0c                	jmp    801733 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801727:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80172b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80172f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801733:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801736:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80173a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801741:	eb 23                	jmp    801766 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801743:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801747:	be 03 00 00 00       	mov    $0x3,%esi
  80174c:	48 89 c7             	mov    %rax,%rdi
  80174f:	48 b8 ce 10 80 00 00 	movabs $0x8010ce,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
  80175b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80175f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801766:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80176b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80176e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801771:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801775:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801779:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80177d:	45 89 c1             	mov    %r8d,%r9d
  801780:	41 89 f8             	mov    %edi,%r8d
  801783:	48 89 c7             	mov    %rax,%rdi
  801786:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  80178d:	00 00 00 
  801790:	ff d0                	callq  *%rax
			break;
  801792:	eb 3f                	jmp    8017d3 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801794:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801798:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80179c:	48 89 d6             	mov    %rdx,%rsi
  80179f:	89 df                	mov    %ebx,%edi
  8017a1:	ff d0                	callq  *%rax
			break;
  8017a3:	eb 2e                	jmp    8017d3 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ad:	48 89 d6             	mov    %rdx,%rsi
  8017b0:	bf 25 00 00 00       	mov    $0x25,%edi
  8017b5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017b7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017bc:	eb 05                	jmp    8017c3 <vprintfmt+0x4e7>
  8017be:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8017c7:	48 83 e8 01          	sub    $0x1,%rax
  8017cb:	0f b6 00             	movzbl (%rax),%eax
  8017ce:	3c 25                	cmp    $0x25,%al
  8017d0:	75 ec                	jne    8017be <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  8017d2:	90                   	nop
		}
	}
  8017d3:	e9 3d fb ff ff       	jmpq   801315 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017d8:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8017d9:	48 83 c4 60          	add    $0x60,%rsp
  8017dd:	5b                   	pop    %rbx
  8017de:	41 5c                	pop    %r12
  8017e0:	5d                   	pop    %rbp
  8017e1:	c3                   	retq   

00000000008017e2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8017ed:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8017f4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8017fb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801802:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801809:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801810:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801817:	84 c0                	test   %al,%al
  801819:	74 20                	je     80183b <printfmt+0x59>
  80181b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80181f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801823:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801827:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80182b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80182f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801833:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801837:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80183b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801842:	00 00 00 
  801845:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80184c:	00 00 00 
  80184f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801853:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80185a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801861:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801868:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80186f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801876:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80187d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801884:	48 89 c7             	mov    %rax,%rdi
  801887:	48 b8 dc 12 80 00 00 	movabs $0x8012dc,%rax
  80188e:	00 00 00 
  801891:	ff d0                	callq  *%rax
	va_end(ap);
}
  801893:	90                   	nop
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 10          	sub    $0x10,%rsp
  80189e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a9:	8b 40 10             	mov    0x10(%rax),%eax
  8018ac:	8d 50 01             	lea    0x1(%rax),%edx
  8018af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8018b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ba:	48 8b 10             	mov    (%rax),%rdx
  8018bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018c5:	48 39 c2             	cmp    %rax,%rdx
  8018c8:	73 17                	jae    8018e1 <sprintputch+0x4b>
		*b->buf++ = ch;
  8018ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ce:	48 8b 00             	mov    (%rax),%rax
  8018d1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8018d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d9:	48 89 0a             	mov    %rcx,(%rdx)
  8018dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018df:	88 10                	mov    %dl,(%rax)
}
  8018e1:	90                   	nop
  8018e2:	c9                   	leaveq 
  8018e3:	c3                   	retq   

00000000008018e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018e4:	55                   	push   %rbp
  8018e5:	48 89 e5             	mov    %rsp,%rbp
  8018e8:	48 83 ec 50          	sub    $0x50,%rsp
  8018ec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018f0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8018f3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8018f7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8018fb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8018ff:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801903:	48 8b 0a             	mov    (%rdx),%rcx
  801906:	48 89 08             	mov    %rcx,(%rax)
  801909:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80190d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801911:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801915:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801919:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80191d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801921:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801924:	48 98                	cltq   
  801926:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80192a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80192e:	48 01 d0             	add    %rdx,%rax
  801931:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801935:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80193c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801941:	74 06                	je     801949 <vsnprintf+0x65>
  801943:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801947:	7f 07                	jg     801950 <vsnprintf+0x6c>
		return -E_INVAL;
  801949:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194e:	eb 2f                	jmp    80197f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801950:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801954:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801958:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80195c:	48 89 c6             	mov    %rax,%rsi
  80195f:	48 bf 96 18 80 00 00 	movabs $0x801896,%rdi
  801966:	00 00 00 
  801969:	48 b8 dc 12 80 00 00 	movabs $0x8012dc,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801975:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801979:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80197c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80197f:	c9                   	leaveq 
  801980:	c3                   	retq   

0000000000801981 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801981:	55                   	push   %rbp
  801982:	48 89 e5             	mov    %rsp,%rbp
  801985:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80198c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801993:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801999:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8019a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8019a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019b5:	84 c0                	test   %al,%al
  8019b7:	74 20                	je     8019d9 <snprintf+0x58>
  8019b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8019bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8019c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8019c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8019c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8019cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8019d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8019d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8019d9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8019e0:	00 00 00 
  8019e3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8019ea:	00 00 00 
  8019ed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019f1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8019f8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8019ff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a06:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a0d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a14:	48 8b 0a             	mov    (%rdx),%rcx
  801a17:	48 89 08             	mov    %rcx,(%rax)
  801a1a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a1e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a22:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a26:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a2a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a31:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a38:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a3e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a45:	48 89 c7             	mov    %rax,%rdi
  801a48:	48 b8 e4 18 80 00 00 	movabs $0x8018e4,%rax
  801a4f:	00 00 00 
  801a52:	ff d0                	callq  *%rax
  801a54:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801a5a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801a60:	c9                   	leaveq 
  801a61:	c3                   	retq   

0000000000801a62 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801a62:	55                   	push   %rbp
  801a63:	48 89 e5             	mov    %rsp,%rbp
  801a66:	48 83 ec 18          	sub    $0x18,%rsp
  801a6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a75:	eb 09                	jmp    801a80 <strlen+0x1e>
		n++;
  801a77:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801a7b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a84:	0f b6 00             	movzbl (%rax),%eax
  801a87:	84 c0                	test   %al,%al
  801a89:	75 ec                	jne    801a77 <strlen+0x15>
		n++;
	return n;
  801a8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	48 83 ec 20          	sub    $0x20,%rsp
  801a98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aa0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aa7:	eb 0e                	jmp    801ab7 <strnlen+0x27>
		n++;
  801aa9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ab2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801ab7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801abc:	74 0b                	je     801ac9 <strnlen+0x39>
  801abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac2:	0f b6 00             	movzbl (%rax),%eax
  801ac5:	84 c0                	test   %al,%al
  801ac7:	75 e0                	jne    801aa9 <strnlen+0x19>
		n++;
	return n;
  801ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801acc:	c9                   	leaveq 
  801acd:	c3                   	retq   

0000000000801ace <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ace:	55                   	push   %rbp
  801acf:	48 89 e5             	mov    %rsp,%rbp
  801ad2:	48 83 ec 20          	sub    $0x20,%rsp
  801ad6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ada:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801ae6:	90                   	nop
  801ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aeb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801af3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801af7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801afb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801aff:	0f b6 12             	movzbl (%rdx),%edx
  801b02:	88 10                	mov    %dl,(%rax)
  801b04:	0f b6 00             	movzbl (%rax),%eax
  801b07:	84 c0                	test   %al,%al
  801b09:	75 dc                	jne    801ae7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 20          	sub    $0x20,%rsp
  801b19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b25:	48 89 c7             	mov    %rax,%rdi
  801b28:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801b2f:	00 00 00 
  801b32:	ff d0                	callq  *%rax
  801b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3a:	48 63 d0             	movslq %eax,%rdx
  801b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b41:	48 01 c2             	add    %rax,%rdx
  801b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b48:	48 89 c6             	mov    %rax,%rsi
  801b4b:	48 89 d7             	mov    %rdx,%rdi
  801b4e:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  801b55:	00 00 00 
  801b58:	ff d0                	callq  *%rax
	return dst;
  801b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b5e:	c9                   	leaveq 
  801b5f:	c3                   	retq   

0000000000801b60 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	48 83 ec 28          	sub    $0x28,%rsp
  801b68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b70:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801b7c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801b83:	00 
  801b84:	eb 2a                	jmp    801bb0 <strncpy+0x50>
		*dst++ = *src;
  801b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b8e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b92:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b96:	0f b6 12             	movzbl (%rdx),%edx
  801b99:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9f:	0f b6 00             	movzbl (%rax),%eax
  801ba2:	84 c0                	test   %al,%al
  801ba4:	74 05                	je     801bab <strncpy+0x4b>
			src++;
  801ba6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801bb8:	72 cc                	jb     801b86 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bbe:	c9                   	leaveq 
  801bbf:	c3                   	retq   

0000000000801bc0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bc0:	55                   	push   %rbp
  801bc1:	48 89 e5             	mov    %rsp,%rbp
  801bc4:	48 83 ec 28          	sub    $0x28,%rsp
  801bc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bd0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801bdc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801be1:	74 3d                	je     801c20 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801be3:	eb 1d                	jmp    801c02 <strlcpy+0x42>
			*dst++ = *src++;
  801be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bf5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801bf9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801bfd:	0f b6 12             	movzbl (%rdx),%edx
  801c00:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c02:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c0c:	74 0b                	je     801c19 <strlcpy+0x59>
  801c0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c12:	0f b6 00             	movzbl (%rax),%eax
  801c15:	84 c0                	test   %al,%al
  801c17:	75 cc                	jne    801be5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c1d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c28:	48 29 c2             	sub    %rax,%rdx
  801c2b:	48 89 d0             	mov    %rdx,%rax
}
  801c2e:	c9                   	leaveq 
  801c2f:	c3                   	retq   

0000000000801c30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	48 83 ec 10          	sub    $0x10,%rsp
  801c38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c40:	eb 0a                	jmp    801c4c <strcmp+0x1c>
		p++, q++;
  801c42:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c47:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c50:	0f b6 00             	movzbl (%rax),%eax
  801c53:	84 c0                	test   %al,%al
  801c55:	74 12                	je     801c69 <strcmp+0x39>
  801c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5b:	0f b6 10             	movzbl (%rax),%edx
  801c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c62:	0f b6 00             	movzbl (%rax),%eax
  801c65:	38 c2                	cmp    %al,%dl
  801c67:	74 d9                	je     801c42 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6d:	0f b6 00             	movzbl (%rax),%eax
  801c70:	0f b6 d0             	movzbl %al,%edx
  801c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c77:	0f b6 00             	movzbl (%rax),%eax
  801c7a:	0f b6 c0             	movzbl %al,%eax
  801c7d:	29 c2                	sub    %eax,%edx
  801c7f:	89 d0                	mov    %edx,%eax
}
  801c81:	c9                   	leaveq 
  801c82:	c3                   	retq   

0000000000801c83 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c83:	55                   	push   %rbp
  801c84:	48 89 e5             	mov    %rsp,%rbp
  801c87:	48 83 ec 18          	sub    $0x18,%rsp
  801c8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801c97:	eb 0f                	jmp    801ca8 <strncmp+0x25>
		n--, p++, q++;
  801c99:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801c9e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ca3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ca8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cad:	74 1d                	je     801ccc <strncmp+0x49>
  801caf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb3:	0f b6 00             	movzbl (%rax),%eax
  801cb6:	84 c0                	test   %al,%al
  801cb8:	74 12                	je     801ccc <strncmp+0x49>
  801cba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbe:	0f b6 10             	movzbl (%rax),%edx
  801cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc5:	0f b6 00             	movzbl (%rax),%eax
  801cc8:	38 c2                	cmp    %al,%dl
  801cca:	74 cd                	je     801c99 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ccc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cd1:	75 07                	jne    801cda <strncmp+0x57>
		return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd8:	eb 18                	jmp    801cf2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cde:	0f b6 00             	movzbl (%rax),%eax
  801ce1:	0f b6 d0             	movzbl %al,%edx
  801ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce8:	0f b6 00             	movzbl (%rax),%eax
  801ceb:	0f b6 c0             	movzbl %al,%eax
  801cee:	29 c2                	sub    %eax,%edx
  801cf0:	89 d0                	mov    %edx,%eax
}
  801cf2:	c9                   	leaveq 
  801cf3:	c3                   	retq   

0000000000801cf4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cf4:	55                   	push   %rbp
  801cf5:	48 89 e5             	mov    %rsp,%rbp
  801cf8:	48 83 ec 10          	sub    $0x10,%rsp
  801cfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d00:	89 f0                	mov    %esi,%eax
  801d02:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d05:	eb 17                	jmp    801d1e <strchr+0x2a>
		if (*s == c)
  801d07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0b:	0f b6 00             	movzbl (%rax),%eax
  801d0e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d11:	75 06                	jne    801d19 <strchr+0x25>
			return (char *) s;
  801d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d17:	eb 15                	jmp    801d2e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d19:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d22:	0f b6 00             	movzbl (%rax),%eax
  801d25:	84 c0                	test   %al,%al
  801d27:	75 de                	jne    801d07 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2e:	c9                   	leaveq 
  801d2f:	c3                   	retq   

0000000000801d30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d30:	55                   	push   %rbp
  801d31:	48 89 e5             	mov    %rsp,%rbp
  801d34:	48 83 ec 10          	sub    $0x10,%rsp
  801d38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d3c:	89 f0                	mov    %esi,%eax
  801d3e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d41:	eb 11                	jmp    801d54 <strfind+0x24>
		if (*s == c)
  801d43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d47:	0f b6 00             	movzbl (%rax),%eax
  801d4a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d4d:	74 12                	je     801d61 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d58:	0f b6 00             	movzbl (%rax),%eax
  801d5b:	84 c0                	test   %al,%al
  801d5d:	75 e4                	jne    801d43 <strfind+0x13>
  801d5f:	eb 01                	jmp    801d62 <strfind+0x32>
		if (*s == c)
			break;
  801d61:	90                   	nop
	return (char *) s;
  801d62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801d66:	c9                   	leaveq 
  801d67:	c3                   	retq   

0000000000801d68 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 18          	sub    $0x18,%rsp
  801d70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d74:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801d77:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801d7b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d80:	75 06                	jne    801d88 <memset+0x20>
		return v;
  801d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d86:	eb 69                	jmp    801df1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8c:	83 e0 03             	and    $0x3,%eax
  801d8f:	48 85 c0             	test   %rax,%rax
  801d92:	75 48                	jne    801ddc <memset+0x74>
  801d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d98:	83 e0 03             	and    $0x3,%eax
  801d9b:	48 85 c0             	test   %rax,%rax
  801d9e:	75 3c                	jne    801ddc <memset+0x74>
		c &= 0xFF;
  801da0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801da7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801daa:	c1 e0 18             	shl    $0x18,%eax
  801dad:	89 c2                	mov    %eax,%edx
  801daf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801db2:	c1 e0 10             	shl    $0x10,%eax
  801db5:	09 c2                	or     %eax,%edx
  801db7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dba:	c1 e0 08             	shl    $0x8,%eax
  801dbd:	09 d0                	or     %edx,%eax
  801dbf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801dc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc6:	48 c1 e8 02          	shr    $0x2,%rax
  801dca:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801dcd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dd1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dd4:	48 89 d7             	mov    %rdx,%rdi
  801dd7:	fc                   	cld    
  801dd8:	f3 ab                	rep stos %eax,%es:(%rdi)
  801dda:	eb 11                	jmp    801ded <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ddc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801de0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801de7:	48 89 d7             	mov    %rdx,%rdi
  801dea:	fc                   	cld    
  801deb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
  801df7:	48 83 ec 28          	sub    $0x28,%rsp
  801dfb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e03:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e0b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e1f:	0f 83 88 00 00 00    	jae    801ead <memmove+0xba>
  801e25:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2d:	48 01 d0             	add    %rdx,%rax
  801e30:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e34:	76 77                	jbe    801ead <memmove+0xba>
		s += n;
  801e36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e42:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4a:	83 e0 03             	and    $0x3,%eax
  801e4d:	48 85 c0             	test   %rax,%rax
  801e50:	75 3b                	jne    801e8d <memmove+0x9a>
  801e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e56:	83 e0 03             	and    $0x3,%eax
  801e59:	48 85 c0             	test   %rax,%rax
  801e5c:	75 2f                	jne    801e8d <memmove+0x9a>
  801e5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e62:	83 e0 03             	and    $0x3,%eax
  801e65:	48 85 c0             	test   %rax,%rax
  801e68:	75 23                	jne    801e8d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6e:	48 83 e8 04          	sub    $0x4,%rax
  801e72:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e76:	48 83 ea 04          	sub    $0x4,%rdx
  801e7a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801e7e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801e82:	48 89 c7             	mov    %rax,%rdi
  801e85:	48 89 d6             	mov    %rdx,%rsi
  801e88:	fd                   	std    
  801e89:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801e8b:	eb 1d                	jmp    801eaa <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e91:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e99:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea1:	48 89 d7             	mov    %rdx,%rdi
  801ea4:	48 89 c1             	mov    %rax,%rcx
  801ea7:	fd                   	std    
  801ea8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801eaa:	fc                   	cld    
  801eab:	eb 57                	jmp    801f04 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ead:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb1:	83 e0 03             	and    $0x3,%eax
  801eb4:	48 85 c0             	test   %rax,%rax
  801eb7:	75 36                	jne    801eef <memmove+0xfc>
  801eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ebd:	83 e0 03             	and    $0x3,%eax
  801ec0:	48 85 c0             	test   %rax,%rax
  801ec3:	75 2a                	jne    801eef <memmove+0xfc>
  801ec5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec9:	83 e0 03             	and    $0x3,%eax
  801ecc:	48 85 c0             	test   %rax,%rax
  801ecf:	75 1e                	jne    801eef <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed5:	48 c1 e8 02          	shr    $0x2,%rax
  801ed9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ee4:	48 89 c7             	mov    %rax,%rdi
  801ee7:	48 89 d6             	mov    %rdx,%rsi
  801eea:	fc                   	cld    
  801eeb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801eed:	eb 15                	jmp    801f04 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801efb:	48 89 c7             	mov    %rax,%rdi
  801efe:	48 89 d6             	mov    %rdx,%rsi
  801f01:	fc                   	cld    
  801f02:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f08:	c9                   	leaveq 
  801f09:	c3                   	retq   

0000000000801f0a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f0a:	55                   	push   %rbp
  801f0b:	48 89 e5             	mov    %rsp,%rbp
  801f0e:	48 83 ec 18          	sub    $0x18,%rsp
  801f12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f22:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2a:	48 89 ce             	mov    %rcx,%rsi
  801f2d:	48 89 c7             	mov    %rax,%rdi
  801f30:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	callq  *%rax
}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 28          	sub    $0x28,%rsp
  801f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f4e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801f5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801f62:	eb 36                	jmp    801f9a <memcmp+0x5c>
		if (*s1 != *s2)
  801f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f68:	0f b6 10             	movzbl (%rax),%edx
  801f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6f:	0f b6 00             	movzbl (%rax),%eax
  801f72:	38 c2                	cmp    %al,%dl
  801f74:	74 1a                	je     801f90 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801f76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7a:	0f b6 00             	movzbl (%rax),%eax
  801f7d:	0f b6 d0             	movzbl %al,%edx
  801f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f84:	0f b6 00             	movzbl (%rax),%eax
  801f87:	0f b6 c0             	movzbl %al,%eax
  801f8a:	29 c2                	sub    %eax,%edx
  801f8c:	89 d0                	mov    %edx,%eax
  801f8e:	eb 20                	jmp    801fb0 <memcmp+0x72>
		s1++, s2++;
  801f90:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f95:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801fa2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fa6:	48 85 c0             	test   %rax,%rax
  801fa9:	75 b9                	jne    801f64 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb0:	c9                   	leaveq 
  801fb1:	c3                   	retq   

0000000000801fb2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fb2:	55                   	push   %rbp
  801fb3:	48 89 e5             	mov    %rsp,%rbp
  801fb6:	48 83 ec 28          	sub    $0x28,%rsp
  801fba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fbe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801fc1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801fc5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fcd:	48 01 d0             	add    %rdx,%rax
  801fd0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801fd4:	eb 19                	jmp    801fef <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fda:	0f b6 00             	movzbl (%rax),%eax
  801fdd:	0f b6 d0             	movzbl %al,%edx
  801fe0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fe3:	0f b6 c0             	movzbl %al,%eax
  801fe6:	39 c2                	cmp    %eax,%edx
  801fe8:	74 11                	je     801ffb <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801fea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801ff7:	72 dd                	jb     801fd6 <memfind+0x24>
  801ff9:	eb 01                	jmp    801ffc <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ffb:	90                   	nop
	return (void *) s;
  801ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 38          	sub    $0x38,%rsp
  80200a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80200e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802012:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802015:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80201c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802023:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802024:	eb 05                	jmp    80202b <strtol+0x29>
		s++;
  802026:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80202b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202f:	0f b6 00             	movzbl (%rax),%eax
  802032:	3c 20                	cmp    $0x20,%al
  802034:	74 f0                	je     802026 <strtol+0x24>
  802036:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80203a:	0f b6 00             	movzbl (%rax),%eax
  80203d:	3c 09                	cmp    $0x9,%al
  80203f:	74 e5                	je     802026 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802041:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802045:	0f b6 00             	movzbl (%rax),%eax
  802048:	3c 2b                	cmp    $0x2b,%al
  80204a:	75 07                	jne    802053 <strtol+0x51>
		s++;
  80204c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802051:	eb 17                	jmp    80206a <strtol+0x68>
	else if (*s == '-')
  802053:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802057:	0f b6 00             	movzbl (%rax),%eax
  80205a:	3c 2d                	cmp    $0x2d,%al
  80205c:	75 0c                	jne    80206a <strtol+0x68>
		s++, neg = 1;
  80205e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802063:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80206a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80206e:	74 06                	je     802076 <strtol+0x74>
  802070:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802074:	75 28                	jne    80209e <strtol+0x9c>
  802076:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207a:	0f b6 00             	movzbl (%rax),%eax
  80207d:	3c 30                	cmp    $0x30,%al
  80207f:	75 1d                	jne    80209e <strtol+0x9c>
  802081:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802085:	48 83 c0 01          	add    $0x1,%rax
  802089:	0f b6 00             	movzbl (%rax),%eax
  80208c:	3c 78                	cmp    $0x78,%al
  80208e:	75 0e                	jne    80209e <strtol+0x9c>
		s += 2, base = 16;
  802090:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802095:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80209c:	eb 2c                	jmp    8020ca <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80209e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020a2:	75 19                	jne    8020bd <strtol+0xbb>
  8020a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a8:	0f b6 00             	movzbl (%rax),%eax
  8020ab:	3c 30                	cmp    $0x30,%al
  8020ad:	75 0e                	jne    8020bd <strtol+0xbb>
		s++, base = 8;
  8020af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020b4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8020bb:	eb 0d                	jmp    8020ca <strtol+0xc8>
	else if (base == 0)
  8020bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020c1:	75 07                	jne    8020ca <strtol+0xc8>
		base = 10;
  8020c3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8020ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ce:	0f b6 00             	movzbl (%rax),%eax
  8020d1:	3c 2f                	cmp    $0x2f,%al
  8020d3:	7e 1d                	jle    8020f2 <strtol+0xf0>
  8020d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d9:	0f b6 00             	movzbl (%rax),%eax
  8020dc:	3c 39                	cmp    $0x39,%al
  8020de:	7f 12                	jg     8020f2 <strtol+0xf0>
			dig = *s - '0';
  8020e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e4:	0f b6 00             	movzbl (%rax),%eax
  8020e7:	0f be c0             	movsbl %al,%eax
  8020ea:	83 e8 30             	sub    $0x30,%eax
  8020ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020f0:	eb 4e                	jmp    802140 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8020f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f6:	0f b6 00             	movzbl (%rax),%eax
  8020f9:	3c 60                	cmp    $0x60,%al
  8020fb:	7e 1d                	jle    80211a <strtol+0x118>
  8020fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802101:	0f b6 00             	movzbl (%rax),%eax
  802104:	3c 7a                	cmp    $0x7a,%al
  802106:	7f 12                	jg     80211a <strtol+0x118>
			dig = *s - 'a' + 10;
  802108:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210c:	0f b6 00             	movzbl (%rax),%eax
  80210f:	0f be c0             	movsbl %al,%eax
  802112:	83 e8 57             	sub    $0x57,%eax
  802115:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802118:	eb 26                	jmp    802140 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80211a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211e:	0f b6 00             	movzbl (%rax),%eax
  802121:	3c 40                	cmp    $0x40,%al
  802123:	7e 47                	jle    80216c <strtol+0x16a>
  802125:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802129:	0f b6 00             	movzbl (%rax),%eax
  80212c:	3c 5a                	cmp    $0x5a,%al
  80212e:	7f 3c                	jg     80216c <strtol+0x16a>
			dig = *s - 'A' + 10;
  802130:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802134:	0f b6 00             	movzbl (%rax),%eax
  802137:	0f be c0             	movsbl %al,%eax
  80213a:	83 e8 37             	sub    $0x37,%eax
  80213d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802140:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802143:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802146:	7d 23                	jge    80216b <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  802148:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80214d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802150:	48 98                	cltq   
  802152:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802157:	48 89 c2             	mov    %rax,%rdx
  80215a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80215d:	48 98                	cltq   
  80215f:	48 01 d0             	add    %rdx,%rax
  802162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802166:	e9 5f ff ff ff       	jmpq   8020ca <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80216b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80216c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802171:	74 0b                	je     80217e <strtol+0x17c>
		*endptr = (char *) s;
  802173:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802177:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80217b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80217e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802182:	74 09                	je     80218d <strtol+0x18b>
  802184:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802188:	48 f7 d8             	neg    %rax
  80218b:	eb 04                	jmp    802191 <strtol+0x18f>
  80218d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802191:	c9                   	leaveq 
  802192:	c3                   	retq   

0000000000802193 <strstr>:

char * strstr(const char *in, const char *str)
{
  802193:	55                   	push   %rbp
  802194:	48 89 e5             	mov    %rsp,%rbp
  802197:	48 83 ec 30          	sub    $0x30,%rsp
  80219b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80219f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8021a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021ab:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8021af:	0f b6 00             	movzbl (%rax),%eax
  8021b2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8021b5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021b9:	75 06                	jne    8021c1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8021bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021bf:	eb 6b                	jmp    80222c <strstr+0x99>

	len = strlen(str);
  8021c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021c5:	48 89 c7             	mov    %rax,%rdi
  8021c8:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8021cf:	00 00 00 
  8021d2:	ff d0                	callq  *%rax
  8021d4:	48 98                	cltq   
  8021d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8021da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8021e6:	0f b6 00             	movzbl (%rax),%eax
  8021e9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8021ec:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8021f0:	75 07                	jne    8021f9 <strstr+0x66>
				return (char *) 0;
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	eb 33                	jmp    80222c <strstr+0x99>
		} while (sc != c);
  8021f9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8021fd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802200:	75 d8                	jne    8021da <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802202:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802206:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80220a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80220e:	48 89 ce             	mov    %rcx,%rsi
  802211:	48 89 c7             	mov    %rax,%rdi
  802214:	48 b8 83 1c 80 00 00 	movabs $0x801c83,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
  802220:	85 c0                	test   %eax,%eax
  802222:	75 b6                	jne    8021da <strstr+0x47>

	return (char *) (in - 1);
  802224:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802228:	48 83 e8 01          	sub    $0x1,%rax
}
  80222c:	c9                   	leaveq 
  80222d:	c3                   	retq   

000000000080222e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80222e:	55                   	push   %rbp
  80222f:	48 89 e5             	mov    %rsp,%rbp
  802232:	53                   	push   %rbx
  802233:	48 83 ec 48          	sub    $0x48,%rsp
  802237:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80223a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80223d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802241:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802245:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802249:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80224d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802250:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802254:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802258:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80225c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802260:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802264:	4c 89 c3             	mov    %r8,%rbx
  802267:	cd 30                	int    $0x30
  802269:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80226d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802271:	74 3e                	je     8022b1 <syscall+0x83>
  802273:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802278:	7e 37                	jle    8022b1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80227a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802281:	49 89 d0             	mov    %rdx,%r8
  802284:	89 c1                	mov    %eax,%ecx
  802286:	48 ba 48 55 80 00 00 	movabs $0x805548,%rdx
  80228d:	00 00 00 
  802290:	be 24 00 00 00       	mov    $0x24,%esi
  802295:	48 bf 65 55 80 00 00 	movabs $0x805565,%rdi
  80229c:	00 00 00 
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a4:	49 b9 04 0d 80 00 00 	movabs $0x800d04,%r9
  8022ab:	00 00 00 
  8022ae:	41 ff d1             	callq  *%r9

	return ret;
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022b5:	48 83 c4 48          	add    $0x48,%rsp
  8022b9:	5b                   	pop    %rbx
  8022ba:	5d                   	pop    %rbp
  8022bb:	c3                   	retq   

00000000008022bc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8022bc:	55                   	push   %rbp
  8022bd:	48 89 e5             	mov    %rsp,%rbp
  8022c0:	48 83 ec 10          	sub    $0x10,%rsp
  8022c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8022cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d4:	48 83 ec 08          	sub    $0x8,%rsp
  8022d8:	6a 00                	pushq  $0x0
  8022da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022e6:	48 89 d1             	mov    %rdx,%rcx
  8022e9:	48 89 c2             	mov    %rax,%rdx
  8022ec:	be 00 00 00 00       	mov    $0x0,%esi
  8022f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f6:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	callq  *%rax
  802302:	48 83 c4 10          	add    $0x10,%rsp
}
  802306:	90                   	nop
  802307:	c9                   	leaveq 
  802308:	c3                   	retq   

0000000000802309 <sys_cgetc>:

int
sys_cgetc(void)
{
  802309:	55                   	push   %rbp
  80230a:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80230d:	48 83 ec 08          	sub    $0x8,%rsp
  802311:	6a 00                	pushq  $0x0
  802313:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802319:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80231f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802324:	ba 00 00 00 00       	mov    $0x0,%edx
  802329:	be 00 00 00 00       	mov    $0x0,%esi
  80232e:	bf 01 00 00 00       	mov    $0x1,%edi
  802333:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
  80233f:	48 83 c4 10          	add    $0x10,%rsp
}
  802343:	c9                   	leaveq 
  802344:	c3                   	retq   

0000000000802345 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802345:	55                   	push   %rbp
  802346:	48 89 e5             	mov    %rsp,%rbp
  802349:	48 83 ec 10          	sub    $0x10,%rsp
  80234d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802353:	48 98                	cltq   
  802355:	48 83 ec 08          	sub    $0x8,%rsp
  802359:	6a 00                	pushq  $0x0
  80235b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802361:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802367:	b9 00 00 00 00       	mov    $0x0,%ecx
  80236c:	48 89 c2             	mov    %rax,%rdx
  80236f:	be 01 00 00 00       	mov    $0x1,%esi
  802374:	bf 03 00 00 00       	mov    $0x3,%edi
  802379:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
  802385:	48 83 c4 10          	add    $0x10,%rsp
}
  802389:	c9                   	leaveq 
  80238a:	c3                   	retq   

000000000080238b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80238b:	55                   	push   %rbp
  80238c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80238f:	48 83 ec 08          	sub    $0x8,%rsp
  802393:	6a 00                	pushq  $0x0
  802395:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80239b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ab:	be 00 00 00 00       	mov    $0x0,%esi
  8023b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8023b5:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	48 83 c4 10          	add    $0x10,%rsp
}
  8023c5:	c9                   	leaveq 
  8023c6:	c3                   	retq   

00000000008023c7 <sys_yield>:


void
sys_yield(void)
{
  8023c7:	55                   	push   %rbp
  8023c8:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8023cb:	48 83 ec 08          	sub    $0x8,%rsp
  8023cf:	6a 00                	pushq  $0x0
  8023d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e7:	be 00 00 00 00       	mov    $0x0,%esi
  8023ec:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023f1:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
  8023fd:	48 83 c4 10          	add    $0x10,%rsp
}
  802401:	90                   	nop
  802402:	c9                   	leaveq 
  802403:	c3                   	retq   

0000000000802404 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802404:	55                   	push   %rbp
  802405:	48 89 e5             	mov    %rsp,%rbp
  802408:	48 83 ec 10          	sub    $0x10,%rsp
  80240c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80240f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802413:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802416:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802419:	48 63 c8             	movslq %eax,%rcx
  80241c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802423:	48 98                	cltq   
  802425:	48 83 ec 08          	sub    $0x8,%rsp
  802429:	6a 00                	pushq  $0x0
  80242b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802431:	49 89 c8             	mov    %rcx,%r8
  802434:	48 89 d1             	mov    %rdx,%rcx
  802437:	48 89 c2             	mov    %rax,%rdx
  80243a:	be 01 00 00 00       	mov    $0x1,%esi
  80243f:	bf 04 00 00 00       	mov    $0x4,%edi
  802444:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  80244b:	00 00 00 
  80244e:	ff d0                	callq  *%rax
  802450:	48 83 c4 10          	add    $0x10,%rsp
}
  802454:	c9                   	leaveq 
  802455:	c3                   	retq   

0000000000802456 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802456:	55                   	push   %rbp
  802457:	48 89 e5             	mov    %rsp,%rbp
  80245a:	48 83 ec 20          	sub    $0x20,%rsp
  80245e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802461:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802465:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802468:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80246c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802470:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802473:	48 63 c8             	movslq %eax,%rcx
  802476:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80247a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80247d:	48 63 f0             	movslq %eax,%rsi
  802480:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802487:	48 98                	cltq   
  802489:	48 83 ec 08          	sub    $0x8,%rsp
  80248d:	51                   	push   %rcx
  80248e:	49 89 f9             	mov    %rdi,%r9
  802491:	49 89 f0             	mov    %rsi,%r8
  802494:	48 89 d1             	mov    %rdx,%rcx
  802497:	48 89 c2             	mov    %rax,%rdx
  80249a:	be 01 00 00 00       	mov    $0x1,%esi
  80249f:	bf 05 00 00 00       	mov    $0x5,%edi
  8024a4:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	48 83 c4 10          	add    $0x10,%rsp
}
  8024b4:	c9                   	leaveq 
  8024b5:	c3                   	retq   

00000000008024b6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024b6:	55                   	push   %rbp
  8024b7:	48 89 e5             	mov    %rsp,%rbp
  8024ba:	48 83 ec 10          	sub    $0x10,%rsp
  8024be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8024c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cc:	48 98                	cltq   
  8024ce:	48 83 ec 08          	sub    $0x8,%rsp
  8024d2:	6a 00                	pushq  $0x0
  8024d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024e0:	48 89 d1             	mov    %rdx,%rcx
  8024e3:	48 89 c2             	mov    %rax,%rdx
  8024e6:	be 01 00 00 00       	mov    $0x1,%esi
  8024eb:	bf 06 00 00 00       	mov    $0x6,%edi
  8024f0:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
  8024fc:	48 83 c4 10          	add    $0x10,%rsp
}
  802500:	c9                   	leaveq 
  802501:	c3                   	retq   

0000000000802502 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802502:	55                   	push   %rbp
  802503:	48 89 e5             	mov    %rsp,%rbp
  802506:	48 83 ec 10          	sub    $0x10,%rsp
  80250a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80250d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802510:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802513:	48 63 d0             	movslq %eax,%rdx
  802516:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802519:	48 98                	cltq   
  80251b:	48 83 ec 08          	sub    $0x8,%rsp
  80251f:	6a 00                	pushq  $0x0
  802521:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802527:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80252d:	48 89 d1             	mov    %rdx,%rcx
  802530:	48 89 c2             	mov    %rax,%rdx
  802533:	be 01 00 00 00       	mov    $0x1,%esi
  802538:	bf 08 00 00 00       	mov    $0x8,%edi
  80253d:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802544:	00 00 00 
  802547:	ff d0                	callq  *%rax
  802549:	48 83 c4 10          	add    $0x10,%rsp
}
  80254d:	c9                   	leaveq 
  80254e:	c3                   	retq   

000000000080254f <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80254f:	55                   	push   %rbp
  802550:	48 89 e5             	mov    %rsp,%rbp
  802553:	48 83 ec 10          	sub    $0x10,%rsp
  802557:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80255a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80255e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802565:	48 98                	cltq   
  802567:	48 83 ec 08          	sub    $0x8,%rsp
  80256b:	6a 00                	pushq  $0x0
  80256d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802573:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802579:	48 89 d1             	mov    %rdx,%rcx
  80257c:	48 89 c2             	mov    %rax,%rdx
  80257f:	be 01 00 00 00       	mov    $0x1,%esi
  802584:	bf 09 00 00 00       	mov    $0x9,%edi
  802589:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802590:	00 00 00 
  802593:	ff d0                	callq  *%rax
  802595:	48 83 c4 10          	add    $0x10,%rsp
}
  802599:	c9                   	leaveq 
  80259a:	c3                   	retq   

000000000080259b <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80259b:	55                   	push   %rbp
  80259c:	48 89 e5             	mov    %rsp,%rbp
  80259f:	48 83 ec 10          	sub    $0x10,%rsp
  8025a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b1:	48 98                	cltq   
  8025b3:	48 83 ec 08          	sub    $0x8,%rsp
  8025b7:	6a 00                	pushq  $0x0
  8025b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025c5:	48 89 d1             	mov    %rdx,%rcx
  8025c8:	48 89 c2             	mov    %rax,%rdx
  8025cb:	be 01 00 00 00       	mov    $0x1,%esi
  8025d0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8025d5:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8025dc:	00 00 00 
  8025df:	ff d0                	callq  *%rax
  8025e1:	48 83 c4 10          	add    $0x10,%rsp
}
  8025e5:	c9                   	leaveq 
  8025e6:	c3                   	retq   

00000000008025e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8025e7:	55                   	push   %rbp
  8025e8:	48 89 e5             	mov    %rsp,%rbp
  8025eb:	48 83 ec 20          	sub    $0x20,%rsp
  8025ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8025fa:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8025fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802600:	48 63 f0             	movslq %eax,%rsi
  802603:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260a:	48 98                	cltq   
  80260c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802610:	48 83 ec 08          	sub    $0x8,%rsp
  802614:	6a 00                	pushq  $0x0
  802616:	49 89 f1             	mov    %rsi,%r9
  802619:	49 89 c8             	mov    %rcx,%r8
  80261c:	48 89 d1             	mov    %rdx,%rcx
  80261f:	48 89 c2             	mov    %rax,%rdx
  802622:	be 00 00 00 00       	mov    $0x0,%esi
  802627:	bf 0c 00 00 00       	mov    $0xc,%edi
  80262c:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802633:	00 00 00 
  802636:	ff d0                	callq  *%rax
  802638:	48 83 c4 10          	add    $0x10,%rsp
}
  80263c:	c9                   	leaveq 
  80263d:	c3                   	retq   

000000000080263e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80263e:	55                   	push   %rbp
  80263f:	48 89 e5             	mov    %rsp,%rbp
  802642:	48 83 ec 10          	sub    $0x10,%rsp
  802646:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80264a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80264e:	48 83 ec 08          	sub    $0x8,%rsp
  802652:	6a 00                	pushq  $0x0
  802654:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80265a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802660:	b9 00 00 00 00       	mov    $0x0,%ecx
  802665:	48 89 c2             	mov    %rax,%rdx
  802668:	be 01 00 00 00       	mov    $0x1,%esi
  80266d:	bf 0d 00 00 00       	mov    $0xd,%edi
  802672:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
  80267e:	48 83 c4 10          	add    $0x10,%rsp
}
  802682:	c9                   	leaveq 
  802683:	c3                   	retq   

0000000000802684 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802684:	55                   	push   %rbp
  802685:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802688:	48 83 ec 08          	sub    $0x8,%rsp
  80268c:	6a 00                	pushq  $0x0
  80268e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802694:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80269a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80269f:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a4:	be 00 00 00 00       	mov    $0x0,%esi
  8026a9:	bf 0e 00 00 00       	mov    $0xe,%edi
  8026ae:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	48 83 c4 10          	add    $0x10,%rsp
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 10          	sub    $0x10,%rsp
  8026c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026cc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8026cf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8026d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d6:	48 83 ec 08          	sub    $0x8,%rsp
  8026da:	6a 00                	pushq  $0x0
  8026dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026e8:	48 89 d1             	mov    %rdx,%rcx
  8026eb:	48 89 c2             	mov    %rax,%rdx
  8026ee:	be 00 00 00 00       	mov    $0x0,%esi
  8026f3:	bf 0f 00 00 00       	mov    $0xf,%edi
  8026f8:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	callq  *%rax
  802704:	48 83 c4 10          	add    $0x10,%rsp
}
  802708:	c9                   	leaveq 
  802709:	c3                   	retq   

000000000080270a <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  80270a:	55                   	push   %rbp
  80270b:	48 89 e5             	mov    %rsp,%rbp
  80270e:	48 83 ec 10          	sub    $0x10,%rsp
  802712:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802716:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802719:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80271c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802720:	48 83 ec 08          	sub    $0x8,%rsp
  802724:	6a 00                	pushq  $0x0
  802726:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80272c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802732:	48 89 d1             	mov    %rdx,%rcx
  802735:	48 89 c2             	mov    %rax,%rdx
  802738:	be 00 00 00 00       	mov    $0x0,%esi
  80273d:	bf 10 00 00 00       	mov    $0x10,%edi
  802742:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802749:	00 00 00 
  80274c:	ff d0                	callq  *%rax
  80274e:	48 83 c4 10          	add    $0x10,%rsp
}
  802752:	c9                   	leaveq 
  802753:	c3                   	retq   

0000000000802754 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802754:	55                   	push   %rbp
  802755:	48 89 e5             	mov    %rsp,%rbp
  802758:	48 83 ec 20          	sub    $0x20,%rsp
  80275c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80275f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802763:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802766:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80276a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80276e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802771:	48 63 c8             	movslq %eax,%rcx
  802774:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802778:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80277b:	48 63 f0             	movslq %eax,%rsi
  80277e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802785:	48 98                	cltq   
  802787:	48 83 ec 08          	sub    $0x8,%rsp
  80278b:	51                   	push   %rcx
  80278c:	49 89 f9             	mov    %rdi,%r9
  80278f:	49 89 f0             	mov    %rsi,%r8
  802792:	48 89 d1             	mov    %rdx,%rcx
  802795:	48 89 c2             	mov    %rax,%rdx
  802798:	be 00 00 00 00       	mov    $0x0,%esi
  80279d:	bf 11 00 00 00       	mov    $0x11,%edi
  8027a2:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
  8027ae:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8027b2:	c9                   	leaveq 
  8027b3:	c3                   	retq   

00000000008027b4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8027b4:	55                   	push   %rbp
  8027b5:	48 89 e5             	mov    %rsp,%rbp
  8027b8:	48 83 ec 10          	sub    $0x10,%rsp
  8027bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8027c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027cc:	48 83 ec 08          	sub    $0x8,%rsp
  8027d0:	6a 00                	pushq  $0x0
  8027d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027de:	48 89 d1             	mov    %rdx,%rcx
  8027e1:	48 89 c2             	mov    %rax,%rdx
  8027e4:	be 00 00 00 00       	mov    $0x0,%esi
  8027e9:	bf 12 00 00 00       	mov    $0x12,%edi
  8027ee:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8027f5:	00 00 00 
  8027f8:	ff d0                	callq  *%rax
  8027fa:	48 83 c4 10          	add    $0x10,%rsp
}
  8027fe:	c9                   	leaveq 
  8027ff:	c3                   	retq   

0000000000802800 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802800:	55                   	push   %rbp
  802801:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802804:	48 83 ec 08          	sub    $0x8,%rsp
  802808:	6a 00                	pushq  $0x0
  80280a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802810:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802816:	b9 00 00 00 00       	mov    $0x0,%ecx
  80281b:	ba 00 00 00 00       	mov    $0x0,%edx
  802820:	be 00 00 00 00       	mov    $0x0,%esi
  802825:	bf 13 00 00 00       	mov    $0x13,%edi
  80282a:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
  802836:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  80283a:	90                   	nop
  80283b:	c9                   	leaveq 
  80283c:	c3                   	retq   

000000000080283d <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  80283d:	55                   	push   %rbp
  80283e:	48 89 e5             	mov    %rsp,%rbp
  802841:	48 83 ec 10          	sub    $0x10,%rsp
  802845:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284b:	48 98                	cltq   
  80284d:	48 83 ec 08          	sub    $0x8,%rsp
  802851:	6a 00                	pushq  $0x0
  802853:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802859:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80285f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802864:	48 89 c2             	mov    %rax,%rdx
  802867:	be 00 00 00 00       	mov    $0x0,%esi
  80286c:	bf 14 00 00 00       	mov    $0x14,%edi
  802871:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
  80287d:	48 83 c4 10          	add    $0x10,%rsp
}
  802881:	c9                   	leaveq 
  802882:	c3                   	retq   

0000000000802883 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802883:	55                   	push   %rbp
  802884:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802887:	48 83 ec 08          	sub    $0x8,%rsp
  80288b:	6a 00                	pushq  $0x0
  80288d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802893:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802899:	b9 00 00 00 00       	mov    $0x0,%ecx
  80289e:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a3:	be 00 00 00 00       	mov    $0x0,%esi
  8028a8:	bf 15 00 00 00       	mov    $0x15,%edi
  8028ad:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8028b4:	00 00 00 
  8028b7:	ff d0                	callq  *%rax
  8028b9:	48 83 c4 10          	add    $0x10,%rsp
}
  8028bd:	c9                   	leaveq 
  8028be:	c3                   	retq   

00000000008028bf <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  8028bf:	55                   	push   %rbp
  8028c0:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8028c3:	48 83 ec 08          	sub    $0x8,%rsp
  8028c7:	6a 00                	pushq  $0x0
  8028c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8028cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8028d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8028da:	ba 00 00 00 00       	mov    $0x0,%edx
  8028df:	be 00 00 00 00       	mov    $0x0,%esi
  8028e4:	bf 16 00 00 00       	mov    $0x16,%edi
  8028e9:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	48 83 c4 10          	add    $0x10,%rsp
}
  8028f9:	90                   	nop
  8028fa:	c9                   	leaveq 
  8028fb:	c3                   	retq   

00000000008028fc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028fc:	55                   	push   %rbp
  8028fd:	48 89 e5             	mov    %rsp,%rbp
  802900:	48 83 ec 30          	sub    $0x30,%rsp
  802904:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802908:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80290c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802910:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802915:	75 0e                	jne    802925 <ipc_recv+0x29>
		pg = (void*) UTOP;
  802917:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80291e:	00 00 00 
  802921:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802925:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802929:	48 89 c7             	mov    %rax,%rdi
  80292c:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
  802938:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293f:	79 27                	jns    802968 <ipc_recv+0x6c>
		if (from_env_store)
  802941:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802946:	74 0a                	je     802952 <ipc_recv+0x56>
			*from_env_store = 0;
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802952:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802957:	74 0a                	je     802963 <ipc_recv+0x67>
			*perm_store = 0;
  802959:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80295d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802966:	eb 53                	jmp    8029bb <ipc_recv+0xbf>
	}
	if (from_env_store)
  802968:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80296d:	74 19                	je     802988 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80296f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802976:	00 00 00 
  802979:	48 8b 00             	mov    (%rax),%rax
  80297c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802986:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  802988:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80298d:	74 19                	je     8029a8 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80298f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802996:	00 00 00 
  802999:	48 8b 00             	mov    (%rax),%rax
  80299c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8029a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a6:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8029a8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029af:	00 00 00 
  8029b2:	48 8b 00             	mov    (%rax),%rax
  8029b5:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8029bb:	c9                   	leaveq 
  8029bc:	c3                   	retq   

00000000008029bd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 83 ec 30          	sub    $0x30,%rsp
  8029c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029c8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8029cb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8029cf:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8029d2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029d7:	75 1c                	jne    8029f5 <ipc_send+0x38>
		pg = (void*) UTOP;
  8029d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8029e0:	00 00 00 
  8029e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8029e7:	eb 0c                	jmp    8029f5 <ipc_send+0x38>
		sys_yield();
  8029e9:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  8029f0:	00 00 00 
  8029f3:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8029f5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8029f8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8029fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a02:	89 c7                	mov    %eax,%edi
  802a04:	48 b8 e7 25 80 00 00 	movabs $0x8025e7,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	callq  *%rax
  802a10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a13:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802a17:	74 d0                	je     8029e9 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  802a19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1d:	79 30                	jns    802a4f <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  802a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a22:	89 c1                	mov    %eax,%ecx
  802a24:	48 ba 73 55 80 00 00 	movabs $0x805573,%rdx
  802a2b:	00 00 00 
  802a2e:	be 47 00 00 00       	mov    $0x47,%esi
  802a33:	48 bf 89 55 80 00 00 	movabs $0x805589,%rdi
  802a3a:	00 00 00 
  802a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a42:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  802a49:	00 00 00 
  802a4c:	41 ff d0             	callq  *%r8

}
  802a4f:	90                   	nop
  802a50:	c9                   	leaveq 
  802a51:	c3                   	retq   

0000000000802a52 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a52:	55                   	push   %rbp
  802a53:	48 89 e5             	mov    %rsp,%rbp
  802a56:	48 83 ec 18          	sub    $0x18,%rsp
  802a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802a5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a64:	eb 4d                	jmp    802ab3 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  802a66:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a6d:	00 00 00 
  802a70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a73:	48 98                	cltq   
  802a75:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a7c:	48 01 d0             	add    %rdx,%rax
  802a7f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a85:	8b 00                	mov    (%rax),%eax
  802a87:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a8a:	75 23                	jne    802aaf <ipc_find_env+0x5d>
			return envs[i].env_id;
  802a8c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a93:	00 00 00 
  802a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a99:	48 98                	cltq   
  802a9b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802aa2:	48 01 d0             	add    %rdx,%rax
  802aa5:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802aab:	8b 00                	mov    (%rax),%eax
  802aad:	eb 12                	jmp    802ac1 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802aaf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ab3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802aba:	7e aa                	jle    802a66 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac1:	c9                   	leaveq 
  802ac2:	c3                   	retq   

0000000000802ac3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802ac3:	55                   	push   %rbp
  802ac4:	48 89 e5             	mov    %rsp,%rbp
  802ac7:	48 83 ec 08          	sub    $0x8,%rsp
  802acb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802acf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ad3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802ada:	ff ff ff 
  802add:	48 01 d0             	add    %rdx,%rax
  802ae0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802ae4:	c9                   	leaveq 
  802ae5:	c3                   	retq   

0000000000802ae6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	48 83 ec 08          	sub    $0x8,%rsp
  802aee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802af2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af6:	48 89 c7             	mov    %rax,%rdi
  802af9:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  802b00:	00 00 00 
  802b03:	ff d0                	callq  *%rax
  802b05:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802b0b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 18          	sub    $0x18,%rsp
  802b19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b24:	eb 6b                	jmp    802b91 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b29:	48 98                	cltq   
  802b2b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b31:	48 c1 e0 0c          	shl    $0xc,%rax
  802b35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3d:	48 c1 e8 15          	shr    $0x15,%rax
  802b41:	48 89 c2             	mov    %rax,%rdx
  802b44:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b4b:	01 00 00 
  802b4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b52:	83 e0 01             	and    $0x1,%eax
  802b55:	48 85 c0             	test   %rax,%rax
  802b58:	74 21                	je     802b7b <fd_alloc+0x6a>
  802b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5e:	48 c1 e8 0c          	shr    $0xc,%rax
  802b62:	48 89 c2             	mov    %rax,%rdx
  802b65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b6c:	01 00 00 
  802b6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b73:	83 e0 01             	and    $0x1,%eax
  802b76:	48 85 c0             	test   %rax,%rax
  802b79:	75 12                	jne    802b8d <fd_alloc+0x7c>
			*fd_store = fd;
  802b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b83:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8b:	eb 1a                	jmp    802ba7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b91:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b95:	7e 8f                	jle    802b26 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802ba2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802ba7:	c9                   	leaveq 
  802ba8:	c3                   	retq   

0000000000802ba9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ba9:	55                   	push   %rbp
  802baa:	48 89 e5             	mov    %rsp,%rbp
  802bad:	48 83 ec 20          	sub    $0x20,%rsp
  802bb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bbc:	78 06                	js     802bc4 <fd_lookup+0x1b>
  802bbe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802bc2:	7e 07                	jle    802bcb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bc9:	eb 6c                	jmp    802c37 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bce:	48 98                	cltq   
  802bd0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bd6:	48 c1 e0 0c          	shl    $0xc,%rax
  802bda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802bde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be2:	48 c1 e8 15          	shr    $0x15,%rax
  802be6:	48 89 c2             	mov    %rax,%rdx
  802be9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bf0:	01 00 00 
  802bf3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bf7:	83 e0 01             	and    $0x1,%eax
  802bfa:	48 85 c0             	test   %rax,%rax
  802bfd:	74 21                	je     802c20 <fd_lookup+0x77>
  802bff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c03:	48 c1 e8 0c          	shr    $0xc,%rax
  802c07:	48 89 c2             	mov    %rax,%rdx
  802c0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c11:	01 00 00 
  802c14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c18:	83 e0 01             	and    $0x1,%eax
  802c1b:	48 85 c0             	test   %rax,%rax
  802c1e:	75 07                	jne    802c27 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c25:	eb 10                	jmp    802c37 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802c27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c2f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c37:	c9                   	leaveq 
  802c38:	c3                   	retq   

0000000000802c39 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c39:	55                   	push   %rbp
  802c3a:	48 89 e5             	mov    %rsp,%rbp
  802c3d:	48 83 ec 30          	sub    $0x30,%rsp
  802c41:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c45:	89 f0                	mov    %esi,%eax
  802c47:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c4e:	48 89 c7             	mov    %rax,%rdi
  802c51:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  802c58:	00 00 00 
  802c5b:	ff d0                	callq  *%rax
  802c5d:	89 c2                	mov    %eax,%edx
  802c5f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c63:	48 89 c6             	mov    %rax,%rsi
  802c66:	89 d7                	mov    %edx,%edi
  802c68:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	callq  *%rax
  802c74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7b:	78 0a                	js     802c87 <fd_close+0x4e>
	    || fd != fd2)
  802c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c81:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c85:	74 12                	je     802c99 <fd_close+0x60>
		return (must_exist ? r : 0);
  802c87:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c8b:	74 05                	je     802c92 <fd_close+0x59>
  802c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c90:	eb 70                	jmp    802d02 <fd_close+0xc9>
  802c92:	b8 00 00 00 00       	mov    $0x0,%eax
  802c97:	eb 69                	jmp    802d02 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c9d:	8b 00                	mov    (%rax),%eax
  802c9f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ca3:	48 89 d6             	mov    %rdx,%rsi
  802ca6:	89 c7                	mov    %eax,%edi
  802ca8:	48 b8 04 2d 80 00 00 	movabs $0x802d04,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
  802cb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbb:	78 2a                	js     802ce7 <fd_close+0xae>
		if (dev->dev_close)
  802cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc1:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cc5:	48 85 c0             	test   %rax,%rax
  802cc8:	74 16                	je     802ce0 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802cca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cce:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cd2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cd6:	48 89 d7             	mov    %rdx,%rdi
  802cd9:	ff d0                	callq  *%rax
  802cdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cde:	eb 07                	jmp    802ce7 <fd_close+0xae>
		else
			r = 0;
  802ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ce7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ceb:	48 89 c6             	mov    %rax,%rsi
  802cee:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf3:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
	return r;
  802cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d02:	c9                   	leaveq 
  802d03:	c3                   	retq   

0000000000802d04 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d04:	55                   	push   %rbp
  802d05:	48 89 e5             	mov    %rsp,%rbp
  802d08:	48 83 ec 20          	sub    $0x20,%rsp
  802d0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802d13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d1a:	eb 41                	jmp    802d5d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802d1c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d23:	00 00 00 
  802d26:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d29:	48 63 d2             	movslq %edx,%rdx
  802d2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d30:	8b 00                	mov    (%rax),%eax
  802d32:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d35:	75 22                	jne    802d59 <dev_lookup+0x55>
			*dev = devtab[i];
  802d37:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d3e:	00 00 00 
  802d41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d44:	48 63 d2             	movslq %edx,%rdx
  802d47:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d4f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d52:	b8 00 00 00 00       	mov    $0x0,%eax
  802d57:	eb 60                	jmp    802db9 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d5d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d64:	00 00 00 
  802d67:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d6a:	48 63 d2             	movslq %edx,%rdx
  802d6d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d71:	48 85 c0             	test   %rax,%rax
  802d74:	75 a6                	jne    802d1c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d76:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d7d:	00 00 00 
  802d80:	48 8b 00             	mov    (%rax),%rax
  802d83:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d89:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d8c:	89 c6                	mov    %eax,%esi
  802d8e:	48 bf 98 55 80 00 00 	movabs $0x805598,%rdi
  802d95:	00 00 00 
  802d98:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9d:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  802da4:	00 00 00 
  802da7:	ff d1                	callq  *%rcx
	*dev = 0;
  802da9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dad:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802db4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802db9:	c9                   	leaveq 
  802dba:	c3                   	retq   

0000000000802dbb <close>:

int
close(int fdnum)
{
  802dbb:	55                   	push   %rbp
  802dbc:	48 89 e5             	mov    %rsp,%rbp
  802dbf:	48 83 ec 20          	sub    $0x20,%rsp
  802dc3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dc6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dcd:	48 89 d6             	mov    %rdx,%rsi
  802dd0:	89 c7                	mov    %eax,%edi
  802dd2:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  802dd9:	00 00 00 
  802ddc:	ff d0                	callq  *%rax
  802dde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de5:	79 05                	jns    802dec <close+0x31>
		return r;
  802de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dea:	eb 18                	jmp    802e04 <close+0x49>
	else
		return fd_close(fd, 1);
  802dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df0:	be 01 00 00 00       	mov    $0x1,%esi
  802df5:	48 89 c7             	mov    %rax,%rdi
  802df8:	48 b8 39 2c 80 00 00 	movabs $0x802c39,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax
}
  802e04:	c9                   	leaveq 
  802e05:	c3                   	retq   

0000000000802e06 <close_all>:

void
close_all(void)
{
  802e06:	55                   	push   %rbp
  802e07:	48 89 e5             	mov    %rsp,%rbp
  802e0a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e15:	eb 15                	jmp    802e2c <close_all+0x26>
		close(i);
  802e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1a:	89 c7                	mov    %eax,%edi
  802e1c:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802e28:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e2c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e30:	7e e5                	jle    802e17 <close_all+0x11>
		close(i);
}
  802e32:	90                   	nop
  802e33:	c9                   	leaveq 
  802e34:	c3                   	retq   

0000000000802e35 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e35:	55                   	push   %rbp
  802e36:	48 89 e5             	mov    %rsp,%rbp
  802e39:	48 83 ec 40          	sub    $0x40,%rsp
  802e3d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e40:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e43:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e47:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e4a:	48 89 d6             	mov    %rdx,%rsi
  802e4d:	89 c7                	mov    %eax,%edi
  802e4f:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
  802e5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e62:	79 08                	jns    802e6c <dup+0x37>
		return r;
  802e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e67:	e9 70 01 00 00       	jmpq   802fdc <dup+0x1a7>
	close(newfdnum);
  802e6c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e6f:	89 c7                	mov    %eax,%edi
  802e71:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e7d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e80:	48 98                	cltq   
  802e82:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e88:	48 c1 e0 0c          	shl    $0xc,%rax
  802e8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e94:	48 89 c7             	mov    %rax,%rdi
  802e97:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec2:	48 c1 e8 15          	shr    $0x15,%rax
  802ec6:	48 89 c2             	mov    %rax,%rdx
  802ec9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ed0:	01 00 00 
  802ed3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ed7:	83 e0 01             	and    $0x1,%eax
  802eda:	48 85 c0             	test   %rax,%rax
  802edd:	74 71                	je     802f50 <dup+0x11b>
  802edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee3:	48 c1 e8 0c          	shr    $0xc,%rax
  802ee7:	48 89 c2             	mov    %rax,%rdx
  802eea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ef1:	01 00 00 
  802ef4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ef8:	83 e0 01             	and    $0x1,%eax
  802efb:	48 85 c0             	test   %rax,%rax
  802efe:	74 50                	je     802f50 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f04:	48 c1 e8 0c          	shr    $0xc,%rax
  802f08:	48 89 c2             	mov    %rax,%rdx
  802f0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f12:	01 00 00 
  802f15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f19:	25 07 0e 00 00       	and    $0xe07,%eax
  802f1e:	89 c1                	mov    %eax,%ecx
  802f20:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f28:	41 89 c8             	mov    %ecx,%r8d
  802f2b:	48 89 d1             	mov    %rdx,%rcx
  802f2e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f33:	48 89 c6             	mov    %rax,%rsi
  802f36:	bf 00 00 00 00       	mov    $0x0,%edi
  802f3b:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
  802f47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4e:	78 55                	js     802fa5 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f54:	48 c1 e8 0c          	shr    $0xc,%rax
  802f58:	48 89 c2             	mov    %rax,%rdx
  802f5b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f62:	01 00 00 
  802f65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f69:	25 07 0e 00 00       	and    $0xe07,%eax
  802f6e:	89 c1                	mov    %eax,%ecx
  802f70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f78:	41 89 c8             	mov    %ecx,%r8d
  802f7b:	48 89 d1             	mov    %rdx,%rcx
  802f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f83:	48 89 c6             	mov    %rax,%rsi
  802f86:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8b:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  802f92:	00 00 00 
  802f95:	ff d0                	callq  *%rax
  802f97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9e:	78 08                	js     802fa8 <dup+0x173>
		goto err;

	return newfdnum;
  802fa0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802fa3:	eb 37                	jmp    802fdc <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802fa5:	90                   	nop
  802fa6:	eb 01                	jmp    802fa9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802fa8:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fad:	48 89 c6             	mov    %rax,%rsi
  802fb0:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb5:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802fbc:	00 00 00 
  802fbf:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802fc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc5:	48 89 c6             	mov    %rax,%rsi
  802fc8:	bf 00 00 00 00       	mov    $0x0,%edi
  802fcd:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
	return r;
  802fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fdc:	c9                   	leaveq 
  802fdd:	c3                   	retq   

0000000000802fde <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802fde:	55                   	push   %rbp
  802fdf:	48 89 e5             	mov    %rsp,%rbp
  802fe2:	48 83 ec 40          	sub    $0x40,%rsp
  802fe6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fe9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ff1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ff5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ff8:	48 89 d6             	mov    %rdx,%rsi
  802ffb:	89 c7                	mov    %eax,%edi
  802ffd:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  803004:	00 00 00 
  803007:	ff d0                	callq  *%rax
  803009:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803010:	78 24                	js     803036 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803016:	8b 00                	mov    (%rax),%eax
  803018:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80301c:	48 89 d6             	mov    %rdx,%rsi
  80301f:	89 c7                	mov    %eax,%edi
  803021:	48 b8 04 2d 80 00 00 	movabs $0x802d04,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
  80302d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803030:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803034:	79 05                	jns    80303b <read+0x5d>
		return r;
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803039:	eb 76                	jmp    8030b1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80303b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303f:	8b 40 08             	mov    0x8(%rax),%eax
  803042:	83 e0 03             	and    $0x3,%eax
  803045:	83 f8 01             	cmp    $0x1,%eax
  803048:	75 3a                	jne    803084 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80304a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803051:	00 00 00 
  803054:	48 8b 00             	mov    (%rax),%rax
  803057:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80305d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803060:	89 c6                	mov    %eax,%esi
  803062:	48 bf b7 55 80 00 00 	movabs $0x8055b7,%rdi
  803069:	00 00 00 
  80306c:	b8 00 00 00 00       	mov    $0x0,%eax
  803071:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  803078:	00 00 00 
  80307b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80307d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803082:	eb 2d                	jmp    8030b1 <read+0xd3>
	}
	if (!dev->dev_read)
  803084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803088:	48 8b 40 10          	mov    0x10(%rax),%rax
  80308c:	48 85 c0             	test   %rax,%rax
  80308f:	75 07                	jne    803098 <read+0xba>
		return -E_NOT_SUPP;
  803091:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803096:	eb 19                	jmp    8030b1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	48 8b 40 10          	mov    0x10(%rax),%rax
  8030a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030a8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030ac:	48 89 cf             	mov    %rcx,%rdi
  8030af:	ff d0                	callq  *%rax
}
  8030b1:	c9                   	leaveq 
  8030b2:	c3                   	retq   

00000000008030b3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8030b3:	55                   	push   %rbp
  8030b4:	48 89 e5             	mov    %rsp,%rbp
  8030b7:	48 83 ec 30          	sub    $0x30,%rsp
  8030bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030cd:	eb 47                	jmp    803116 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8030cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d2:	48 98                	cltq   
  8030d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030d8:	48 29 c2             	sub    %rax,%rdx
  8030db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030de:	48 63 c8             	movslq %eax,%rcx
  8030e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e5:	48 01 c1             	add    %rax,%rcx
  8030e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030eb:	48 89 ce             	mov    %rcx,%rsi
  8030ee:	89 c7                	mov    %eax,%edi
  8030f0:	48 b8 de 2f 80 00 00 	movabs $0x802fde,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
  8030fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803103:	79 05                	jns    80310a <readn+0x57>
			return m;
  803105:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803108:	eb 1d                	jmp    803127 <readn+0x74>
		if (m == 0)
  80310a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80310e:	74 13                	je     803123 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803110:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803113:	01 45 fc             	add    %eax,-0x4(%rbp)
  803116:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803119:	48 98                	cltq   
  80311b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80311f:	72 ae                	jb     8030cf <readn+0x1c>
  803121:	eb 01                	jmp    803124 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803123:	90                   	nop
	}
	return tot;
  803124:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803127:	c9                   	leaveq 
  803128:	c3                   	retq   

0000000000803129 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803129:	55                   	push   %rbp
  80312a:	48 89 e5             	mov    %rsp,%rbp
  80312d:	48 83 ec 40          	sub    $0x40,%rsp
  803131:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803134:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803138:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80313c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803140:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803143:	48 89 d6             	mov    %rdx,%rsi
  803146:	89 c7                	mov    %eax,%edi
  803148:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  80314f:	00 00 00 
  803152:	ff d0                	callq  *%rax
  803154:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803157:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315b:	78 24                	js     803181 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80315d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803161:	8b 00                	mov    (%rax),%eax
  803163:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803167:	48 89 d6             	mov    %rdx,%rsi
  80316a:	89 c7                	mov    %eax,%edi
  80316c:	48 b8 04 2d 80 00 00 	movabs $0x802d04,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
  803178:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317f:	79 05                	jns    803186 <write+0x5d>
		return r;
  803181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803184:	eb 75                	jmp    8031fb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318a:	8b 40 08             	mov    0x8(%rax),%eax
  80318d:	83 e0 03             	and    $0x3,%eax
  803190:	85 c0                	test   %eax,%eax
  803192:	75 3a                	jne    8031ce <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803194:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80319b:	00 00 00 
  80319e:	48 8b 00             	mov    (%rax),%rax
  8031a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031aa:	89 c6                	mov    %eax,%esi
  8031ac:	48 bf d3 55 80 00 00 	movabs $0x8055d3,%rdi
  8031b3:	00 00 00 
  8031b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bb:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  8031c2:	00 00 00 
  8031c5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8031c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031cc:	eb 2d                	jmp    8031fb <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031d6:	48 85 c0             	test   %rax,%rax
  8031d9:	75 07                	jne    8031e2 <write+0xb9>
		return -E_NOT_SUPP;
  8031db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031e0:	eb 19                	jmp    8031fb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8031e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031ea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8031f6:	48 89 cf             	mov    %rcx,%rdi
  8031f9:	ff d0                	callq  *%rax
}
  8031fb:	c9                   	leaveq 
  8031fc:	c3                   	retq   

00000000008031fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8031fd:	55                   	push   %rbp
  8031fe:	48 89 e5             	mov    %rsp,%rbp
  803201:	48 83 ec 18          	sub    $0x18,%rsp
  803205:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803208:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80320b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80320f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803212:	48 89 d6             	mov    %rdx,%rsi
  803215:	89 c7                	mov    %eax,%edi
  803217:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  80321e:	00 00 00 
  803221:	ff d0                	callq  *%rax
  803223:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803226:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322a:	79 05                	jns    803231 <seek+0x34>
		return r;
  80322c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322f:	eb 0f                	jmp    803240 <seek+0x43>
	fd->fd_offset = offset;
  803231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803235:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803238:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80323b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803240:	c9                   	leaveq 
  803241:	c3                   	retq   

0000000000803242 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803242:	55                   	push   %rbp
  803243:	48 89 e5             	mov    %rsp,%rbp
  803246:	48 83 ec 30          	sub    $0x30,%rsp
  80324a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80324d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803250:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803254:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803257:	48 89 d6             	mov    %rdx,%rsi
  80325a:	89 c7                	mov    %eax,%edi
  80325c:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
  803268:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326f:	78 24                	js     803295 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803275:	8b 00                	mov    (%rax),%eax
  803277:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80327b:	48 89 d6             	mov    %rdx,%rsi
  80327e:	89 c7                	mov    %eax,%edi
  803280:	48 b8 04 2d 80 00 00 	movabs $0x802d04,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
  80328c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803293:	79 05                	jns    80329a <ftruncate+0x58>
		return r;
  803295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803298:	eb 72                	jmp    80330c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80329a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329e:	8b 40 08             	mov    0x8(%rax),%eax
  8032a1:	83 e0 03             	and    $0x3,%eax
  8032a4:	85 c0                	test   %eax,%eax
  8032a6:	75 3a                	jne    8032e2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8032a8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8032af:	00 00 00 
  8032b2:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8032b5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8032bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032be:	89 c6                	mov    %eax,%esi
  8032c0:	48 bf f0 55 80 00 00 	movabs $0x8055f0,%rdi
  8032c7:	00 00 00 
  8032ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cf:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  8032d6:	00 00 00 
  8032d9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8032db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032e0:	eb 2a                	jmp    80330c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8032e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032ea:	48 85 c0             	test   %rax,%rax
  8032ed:	75 07                	jne    8032f6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8032ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032f4:	eb 16                	jmp    80330c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8032f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fa:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803302:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803305:	89 ce                	mov    %ecx,%esi
  803307:	48 89 d7             	mov    %rdx,%rdi
  80330a:	ff d0                	callq  *%rax
}
  80330c:	c9                   	leaveq 
  80330d:	c3                   	retq   

000000000080330e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80330e:	55                   	push   %rbp
  80330f:	48 89 e5             	mov    %rsp,%rbp
  803312:	48 83 ec 30          	sub    $0x30,%rsp
  803316:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803319:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80331d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803321:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803324:	48 89 d6             	mov    %rdx,%rsi
  803327:	89 c7                	mov    %eax,%edi
  803329:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  803330:	00 00 00 
  803333:	ff d0                	callq  *%rax
  803335:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803338:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333c:	78 24                	js     803362 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80333e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803342:	8b 00                	mov    (%rax),%eax
  803344:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803348:	48 89 d6             	mov    %rdx,%rsi
  80334b:	89 c7                	mov    %eax,%edi
  80334d:	48 b8 04 2d 80 00 00 	movabs $0x802d04,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803360:	79 05                	jns    803367 <fstat+0x59>
		return r;
  803362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803365:	eb 5e                	jmp    8033c5 <fstat+0xb7>
	if (!dev->dev_stat)
  803367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80336f:	48 85 c0             	test   %rax,%rax
  803372:	75 07                	jne    80337b <fstat+0x6d>
		return -E_NOT_SUPP;
  803374:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803379:	eb 4a                	jmp    8033c5 <fstat+0xb7>
	stat->st_name[0] = 0;
  80337b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803382:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803386:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80338d:	00 00 00 
	stat->st_isdir = 0;
  803390:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803394:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80339b:	00 00 00 
	stat->st_dev = dev;
  80339e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8033ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8033b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033b9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8033bd:	48 89 ce             	mov    %rcx,%rsi
  8033c0:	48 89 d7             	mov    %rdx,%rdi
  8033c3:	ff d0                	callq  *%rax
}
  8033c5:	c9                   	leaveq 
  8033c6:	c3                   	retq   

00000000008033c7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8033c7:	55                   	push   %rbp
  8033c8:	48 89 e5             	mov    %rsp,%rbp
  8033cb:	48 83 ec 20          	sub    $0x20,%rsp
  8033cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8033d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033db:	be 00 00 00 00       	mov    $0x0,%esi
  8033e0:	48 89 c7             	mov    %rax,%rdi
  8033e3:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  8033ea:	00 00 00 
  8033ed:	ff d0                	callq  *%rax
  8033ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f6:	79 05                	jns    8033fd <stat+0x36>
		return fd;
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	eb 2f                	jmp    80342c <stat+0x65>
	r = fstat(fd, stat);
  8033fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803404:	48 89 d6             	mov    %rdx,%rsi
  803407:	89 c7                	mov    %eax,%edi
  803409:	48 b8 0e 33 80 00 00 	movabs $0x80330e,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341b:	89 c7                	mov    %eax,%edi
  80341d:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
	return r;
  803429:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80342c:	c9                   	leaveq 
  80342d:	c3                   	retq   

000000000080342e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80342e:	55                   	push   %rbp
  80342f:	48 89 e5             	mov    %rsp,%rbp
  803432:	48 83 ec 10          	sub    $0x10,%rsp
  803436:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803439:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80343d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803444:	00 00 00 
  803447:	8b 00                	mov    (%rax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	75 1f                	jne    80346c <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80344d:	bf 01 00 00 00       	mov    $0x1,%edi
  803452:	48 b8 52 2a 80 00 00 	movabs $0x802a52,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
  80345e:	89 c2                	mov    %eax,%edx
  803460:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803467:	00 00 00 
  80346a:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80346c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803473:	00 00 00 
  803476:	8b 00                	mov    (%rax),%eax
  803478:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80347b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803480:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803487:	00 00 00 
  80348a:	89 c7                	mov    %eax,%edi
  80348c:	48 b8 bd 29 80 00 00 	movabs $0x8029bd,%rax
  803493:	00 00 00 
  803496:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349c:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a1:	48 89 c6             	mov    %rax,%rsi
  8034a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a9:	48 b8 fc 28 80 00 00 	movabs $0x8028fc,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
}
  8034b5:	c9                   	leaveq 
  8034b6:	c3                   	retq   

00000000008034b7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8034b7:	55                   	push   %rbp
  8034b8:	48 89 e5             	mov    %rsp,%rbp
  8034bb:	48 83 ec 20          	sub    $0x20,%rsp
  8034bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8034c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ca:	48 89 c7             	mov    %rax,%rdi
  8034cd:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034de:	7e 0a                	jle    8034ea <open+0x33>
		return -E_BAD_PATH;
  8034e0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034e5:	e9 a5 00 00 00       	jmpq   80358f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8034ea:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034ee:	48 89 c7             	mov    %rax,%rdi
  8034f1:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
  8034fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803500:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803504:	79 08                	jns    80350e <open+0x57>
		return r;
  803506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803509:	e9 81 00 00 00       	jmpq   80358f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80350e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803512:	48 89 c6             	mov    %rax,%rsi
  803515:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80351c:	00 00 00 
  80351f:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80352b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803532:	00 00 00 
  803535:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803538:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80353e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803542:	48 89 c6             	mov    %rax,%rsi
  803545:	bf 01 00 00 00       	mov    $0x1,%edi
  80354a:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
  803556:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803559:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355d:	79 1d                	jns    80357c <open+0xc5>
		fd_close(fd, 0);
  80355f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803563:	be 00 00 00 00       	mov    $0x0,%esi
  803568:	48 89 c7             	mov    %rax,%rdi
  80356b:	48 b8 39 2c 80 00 00 	movabs $0x802c39,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
		return r;
  803577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357a:	eb 13                	jmp    80358f <open+0xd8>
	}

	return fd2num(fd);
  80357c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803580:	48 89 c7             	mov    %rax,%rdi
  803583:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax

}
  80358f:	c9                   	leaveq 
  803590:	c3                   	retq   

0000000000803591 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803591:	55                   	push   %rbp
  803592:	48 89 e5             	mov    %rsp,%rbp
  803595:	48 83 ec 10          	sub    $0x10,%rsp
  803599:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80359d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a1:	8b 50 0c             	mov    0xc(%rax),%edx
  8035a4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ab:	00 00 00 
  8035ae:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8035b0:	be 00 00 00 00       	mov    $0x0,%esi
  8035b5:	bf 06 00 00 00       	mov    $0x6,%edi
  8035ba:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
}
  8035c6:	c9                   	leaveq 
  8035c7:	c3                   	retq   

00000000008035c8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8035c8:	55                   	push   %rbp
  8035c9:	48 89 e5             	mov    %rsp,%rbp
  8035cc:	48 83 ec 30          	sub    $0x30,%rsp
  8035d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e0:	8b 50 0c             	mov    0xc(%rax),%edx
  8035e3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ea:	00 00 00 
  8035ed:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8035ef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035f6:	00 00 00 
  8035f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035fd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803601:	be 00 00 00 00       	mov    $0x0,%esi
  803606:	bf 03 00 00 00       	mov    $0x3,%edi
  80360b:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  803612:	00 00 00 
  803615:	ff d0                	callq  *%rax
  803617:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80361a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80361e:	79 08                	jns    803628 <devfile_read+0x60>
		return r;
  803620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803623:	e9 a4 00 00 00       	jmpq   8036cc <devfile_read+0x104>
	assert(r <= n);
  803628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362b:	48 98                	cltq   
  80362d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803631:	76 35                	jbe    803668 <devfile_read+0xa0>
  803633:	48 b9 16 56 80 00 00 	movabs $0x805616,%rcx
  80363a:	00 00 00 
  80363d:	48 ba 1d 56 80 00 00 	movabs $0x80561d,%rdx
  803644:	00 00 00 
  803647:	be 86 00 00 00       	mov    $0x86,%esi
  80364c:	48 bf 32 56 80 00 00 	movabs $0x805632,%rdi
  803653:	00 00 00 
  803656:	b8 00 00 00 00       	mov    $0x0,%eax
  80365b:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  803662:	00 00 00 
  803665:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803668:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80366f:	7e 35                	jle    8036a6 <devfile_read+0xde>
  803671:	48 b9 3d 56 80 00 00 	movabs $0x80563d,%rcx
  803678:	00 00 00 
  80367b:	48 ba 1d 56 80 00 00 	movabs $0x80561d,%rdx
  803682:	00 00 00 
  803685:	be 87 00 00 00       	mov    $0x87,%esi
  80368a:	48 bf 32 56 80 00 00 	movabs $0x805632,%rdi
  803691:	00 00 00 
  803694:	b8 00 00 00 00       	mov    $0x0,%eax
  803699:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8036a0:	00 00 00 
  8036a3:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8036a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a9:	48 63 d0             	movslq %eax,%rdx
  8036ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b0:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8036b7:	00 00 00 
  8036ba:	48 89 c7             	mov    %rax,%rdi
  8036bd:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
	return r;
  8036c9:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8036cc:	c9                   	leaveq 
  8036cd:	c3                   	retq   

00000000008036ce <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8036ce:	55                   	push   %rbp
  8036cf:	48 89 e5             	mov    %rsp,%rbp
  8036d2:	48 83 ec 40          	sub    $0x40,%rsp
  8036d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036de:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8036e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036ea:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8036f1:	00 
  8036f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8036fa:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8036ff:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803703:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803707:	8b 50 0c             	mov    0xc(%rax),%edx
  80370a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803711:	00 00 00 
  803714:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803716:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80371d:	00 00 00 
  803720:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803724:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803728:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80372c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803730:	48 89 c6             	mov    %rax,%rsi
  803733:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80373a:	00 00 00 
  80373d:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803749:	be 00 00 00 00       	mov    $0x0,%esi
  80374e:	bf 04 00 00 00       	mov    $0x4,%edi
  803753:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
  80375f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803762:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803766:	79 05                	jns    80376d <devfile_write+0x9f>
		return r;
  803768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376b:	eb 43                	jmp    8037b0 <devfile_write+0xe2>
	assert(r <= n);
  80376d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803770:	48 98                	cltq   
  803772:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803776:	76 35                	jbe    8037ad <devfile_write+0xdf>
  803778:	48 b9 16 56 80 00 00 	movabs $0x805616,%rcx
  80377f:	00 00 00 
  803782:	48 ba 1d 56 80 00 00 	movabs $0x80561d,%rdx
  803789:	00 00 00 
  80378c:	be a2 00 00 00       	mov    $0xa2,%esi
  803791:	48 bf 32 56 80 00 00 	movabs $0x805632,%rdi
  803798:	00 00 00 
  80379b:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a0:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8037a7:	00 00 00 
  8037aa:	41 ff d0             	callq  *%r8
	return r;
  8037ad:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8037b0:	c9                   	leaveq 
  8037b1:	c3                   	retq   

00000000008037b2 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8037b2:	55                   	push   %rbp
  8037b3:	48 89 e5             	mov    %rsp,%rbp
  8037b6:	48 83 ec 20          	sub    $0x20,%rsp
  8037ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8037c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c6:	8b 50 0c             	mov    0xc(%rax),%edx
  8037c9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037d0:	00 00 00 
  8037d3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8037d5:	be 00 00 00 00       	mov    $0x0,%esi
  8037da:	bf 05 00 00 00       	mov    $0x5,%edi
  8037df:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  8037e6:	00 00 00 
  8037e9:	ff d0                	callq  *%rax
  8037eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f2:	79 05                	jns    8037f9 <devfile_stat+0x47>
		return r;
  8037f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f7:	eb 56                	jmp    80384f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8037f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fd:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803804:	00 00 00 
  803807:	48 89 c7             	mov    %rax,%rdi
  80380a:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803816:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80381d:	00 00 00 
  803820:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803826:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80382a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803830:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803837:	00 00 00 
  80383a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803840:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803844:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80384a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80384f:	c9                   	leaveq 
  803850:	c3                   	retq   

0000000000803851 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803851:	55                   	push   %rbp
  803852:	48 89 e5             	mov    %rsp,%rbp
  803855:	48 83 ec 10          	sub    $0x10,%rsp
  803859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80385d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803864:	8b 50 0c             	mov    0xc(%rax),%edx
  803867:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80386e:	00 00 00 
  803871:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803873:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80387a:	00 00 00 
  80387d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803880:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803883:	be 00 00 00 00       	mov    $0x0,%esi
  803888:	bf 02 00 00 00       	mov    $0x2,%edi
  80388d:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  803894:	00 00 00 
  803897:	ff d0                	callq  *%rax
}
  803899:	c9                   	leaveq 
  80389a:	c3                   	retq   

000000000080389b <remove>:

// Delete a file
int
remove(const char *path)
{
  80389b:	55                   	push   %rbp
  80389c:	48 89 e5             	mov    %rsp,%rbp
  80389f:	48 83 ec 10          	sub    $0x10,%rsp
  8038a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8038a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ab:	48 89 c7             	mov    %rax,%rdi
  8038ae:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
  8038ba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8038bf:	7e 07                	jle    8038c8 <remove+0x2d>
		return -E_BAD_PATH;
  8038c1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8038c6:	eb 33                	jmp    8038fb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8038c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038cc:	48 89 c6             	mov    %rax,%rsi
  8038cf:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8038d6:	00 00 00 
  8038d9:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8038e5:	be 00 00 00 00       	mov    $0x0,%esi
  8038ea:	bf 07 00 00 00       	mov    $0x7,%edi
  8038ef:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  8038f6:	00 00 00 
  8038f9:	ff d0                	callq  *%rax
}
  8038fb:	c9                   	leaveq 
  8038fc:	c3                   	retq   

00000000008038fd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8038fd:	55                   	push   %rbp
  8038fe:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803901:	be 00 00 00 00       	mov    $0x0,%esi
  803906:	bf 08 00 00 00       	mov    $0x8,%edi
  80390b:	48 b8 2e 34 80 00 00 	movabs $0x80342e,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
}
  803917:	5d                   	pop    %rbp
  803918:	c3                   	retq   

0000000000803919 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803924:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80392b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803932:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803939:	be 00 00 00 00       	mov    $0x0,%esi
  80393e:	48 89 c7             	mov    %rax,%rdi
  803941:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803950:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803954:	79 28                	jns    80397e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803959:	89 c6                	mov    %eax,%esi
  80395b:	48 bf 49 56 80 00 00 	movabs $0x805649,%rdi
  803962:	00 00 00 
  803965:	b8 00 00 00 00       	mov    $0x0,%eax
  80396a:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  803971:	00 00 00 
  803974:	ff d2                	callq  *%rdx
		return fd_src;
  803976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803979:	e9 76 01 00 00       	jmpq   803af4 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80397e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803985:	be 01 01 00 00       	mov    $0x101,%esi
  80398a:	48 89 c7             	mov    %rax,%rdi
  80398d:	48 b8 b7 34 80 00 00 	movabs $0x8034b7,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
  803999:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80399c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8039a0:	0f 89 ad 00 00 00    	jns    803a53 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8039a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039a9:	89 c6                	mov    %eax,%esi
  8039ab:	48 bf 5f 56 80 00 00 	movabs $0x80565f,%rdi
  8039b2:	00 00 00 
  8039b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ba:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  8039c1:	00 00 00 
  8039c4:	ff d2                	callq  *%rdx
		close(fd_src);
  8039c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c9:	89 c7                	mov    %eax,%edi
  8039cb:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
		return fd_dest;
  8039d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039da:	e9 15 01 00 00       	jmpq   803af4 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8039df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039e2:	48 63 d0             	movslq %eax,%rdx
  8039e5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8039ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039ef:	48 89 ce             	mov    %rcx,%rsi
  8039f2:	89 c7                	mov    %eax,%edi
  8039f4:	48 b8 29 31 80 00 00 	movabs $0x803129,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803a03:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803a07:	79 4a                	jns    803a53 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803a09:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a0c:	89 c6                	mov    %eax,%esi
  803a0e:	48 bf 79 56 80 00 00 	movabs $0x805679,%rdi
  803a15:	00 00 00 
  803a18:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1d:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  803a24:	00 00 00 
  803a27:	ff d2                	callq  *%rdx
			close(fd_src);
  803a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2c:	89 c7                	mov    %eax,%edi
  803a2e:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
			close(fd_dest);
  803a3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a3d:	89 c7                	mov    %eax,%edi
  803a3f:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803a46:	00 00 00 
  803a49:	ff d0                	callq  *%rax
			return write_size;
  803a4b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a4e:	e9 a1 00 00 00       	jmpq   803af4 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803a53:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5d:	ba 00 02 00 00       	mov    $0x200,%edx
  803a62:	48 89 ce             	mov    %rcx,%rsi
  803a65:	89 c7                	mov    %eax,%edi
  803a67:	48 b8 de 2f 80 00 00 	movabs $0x802fde,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
  803a73:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a7a:	0f 8f 5f ff ff ff    	jg     8039df <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a84:	79 47                	jns    803acd <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803a86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a89:	89 c6                	mov    %eax,%esi
  803a8b:	48 bf 8c 56 80 00 00 	movabs $0x80568c,%rdi
  803a92:	00 00 00 
  803a95:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9a:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  803aa1:	00 00 00 
  803aa4:	ff d2                	callq  *%rdx
		close(fd_src);
  803aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa9:	89 c7                	mov    %eax,%edi
  803aab:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
		close(fd_dest);
  803ab7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aba:	89 c7                	mov    %eax,%edi
  803abc:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803ac3:	00 00 00 
  803ac6:	ff d0                	callq  *%rax
		return read_size;
  803ac8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803acb:	eb 27                	jmp    803af4 <copy+0x1db>
	}
	close(fd_src);
  803acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad0:	89 c7                	mov    %eax,%edi
  803ad2:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803ad9:	00 00 00 
  803adc:	ff d0                	callq  *%rax
	close(fd_dest);
  803ade:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae1:	89 c7                	mov    %eax,%edi
  803ae3:	48 b8 bb 2d 80 00 00 	movabs $0x802dbb,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
	return 0;
  803aef:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803af4:	c9                   	leaveq 
  803af5:	c3                   	retq   

0000000000803af6 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803af6:	55                   	push   %rbp
  803af7:	48 89 e5             	mov    %rsp,%rbp
  803afa:	48 83 ec 20          	sub    $0x20,%rsp
  803afe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803b01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b08:	48 89 d6             	mov    %rdx,%rsi
  803b0b:	89 c7                	mov    %eax,%edi
  803b0d:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  803b14:	00 00 00 
  803b17:	ff d0                	callq  *%rax
  803b19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b20:	79 05                	jns    803b27 <fd2sockid+0x31>
		return r;
  803b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b25:	eb 24                	jmp    803b4b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803b27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2b:	8b 10                	mov    (%rax),%edx
  803b2d:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803b34:	00 00 00 
  803b37:	8b 00                	mov    (%rax),%eax
  803b39:	39 c2                	cmp    %eax,%edx
  803b3b:	74 07                	je     803b44 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803b3d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b42:	eb 07                	jmp    803b4b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803b44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b48:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803b4b:	c9                   	leaveq 
  803b4c:	c3                   	retq   

0000000000803b4d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803b4d:	55                   	push   %rbp
  803b4e:	48 89 e5             	mov    %rsp,%rbp
  803b51:	48 83 ec 20          	sub    $0x20,%rsp
  803b55:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803b58:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b5c:	48 89 c7             	mov    %rax,%rdi
  803b5f:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  803b66:	00 00 00 
  803b69:	ff d0                	callq  *%rax
  803b6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b72:	78 26                	js     803b9a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803b74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b78:	ba 07 04 00 00       	mov    $0x407,%edx
  803b7d:	48 89 c6             	mov    %rax,%rsi
  803b80:	bf 00 00 00 00       	mov    $0x0,%edi
  803b85:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  803b8c:	00 00 00 
  803b8f:	ff d0                	callq  *%rax
  803b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b98:	79 16                	jns    803bb0 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803b9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b9d:	89 c7                	mov    %eax,%edi
  803b9f:	48 b8 5c 40 80 00 00 	movabs $0x80405c,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
		return r;
  803bab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bae:	eb 3a                	jmp    803bea <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb4:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803bbb:	00 00 00 
  803bbe:	8b 12                	mov    (%rdx),%edx
  803bc0:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bd4:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdb:	48 89 c7             	mov    %rax,%rdi
  803bde:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  803be5:	00 00 00 
  803be8:	ff d0                	callq  *%rax
}
  803bea:	c9                   	leaveq 
  803beb:	c3                   	retq   

0000000000803bec <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bec:	55                   	push   %rbp
  803bed:	48 89 e5             	mov    %rsp,%rbp
  803bf0:	48 83 ec 30          	sub    $0x30,%rsp
  803bf4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bf7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bfb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c02:	89 c7                	mov    %eax,%edi
  803c04:	48 b8 f6 3a 80 00 00 	movabs $0x803af6,%rax
  803c0b:	00 00 00 
  803c0e:	ff d0                	callq  *%rax
  803c10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c17:	79 05                	jns    803c1e <accept+0x32>
		return r;
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1c:	eb 3b                	jmp    803c59 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803c1e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c22:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c29:	48 89 ce             	mov    %rcx,%rsi
  803c2c:	89 c7                	mov    %eax,%edi
  803c2e:	48 b8 39 3f 80 00 00 	movabs $0x803f39,%rax
  803c35:	00 00 00 
  803c38:	ff d0                	callq  *%rax
  803c3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c41:	79 05                	jns    803c48 <accept+0x5c>
		return r;
  803c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c46:	eb 11                	jmp    803c59 <accept+0x6d>
	return alloc_sockfd(r);
  803c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4b:	89 c7                	mov    %eax,%edi
  803c4d:	48 b8 4d 3b 80 00 00 	movabs $0x803b4d,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
}
  803c59:	c9                   	leaveq 
  803c5a:	c3                   	retq   

0000000000803c5b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c5b:	55                   	push   %rbp
  803c5c:	48 89 e5             	mov    %rsp,%rbp
  803c5f:	48 83 ec 20          	sub    $0x20,%rsp
  803c63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c6a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c70:	89 c7                	mov    %eax,%edi
  803c72:	48 b8 f6 3a 80 00 00 	movabs $0x803af6,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
  803c7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c85:	79 05                	jns    803c8c <bind+0x31>
		return r;
  803c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8a:	eb 1b                	jmp    803ca7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803c8c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c8f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c96:	48 89 ce             	mov    %rcx,%rsi
  803c99:	89 c7                	mov    %eax,%edi
  803c9b:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  803ca2:	00 00 00 
  803ca5:	ff d0                	callq  *%rax
}
  803ca7:	c9                   	leaveq 
  803ca8:	c3                   	retq   

0000000000803ca9 <shutdown>:

int
shutdown(int s, int how)
{
  803ca9:	55                   	push   %rbp
  803caa:	48 89 e5             	mov    %rsp,%rbp
  803cad:	48 83 ec 20          	sub    $0x20,%rsp
  803cb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cb4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cba:	89 c7                	mov    %eax,%edi
  803cbc:	48 b8 f6 3a 80 00 00 	movabs $0x803af6,%rax
  803cc3:	00 00 00 
  803cc6:	ff d0                	callq  *%rax
  803cc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ccb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ccf:	79 05                	jns    803cd6 <shutdown+0x2d>
		return r;
  803cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd4:	eb 16                	jmp    803cec <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803cd6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdc:	89 d6                	mov    %edx,%esi
  803cde:	89 c7                	mov    %eax,%edi
  803ce0:	48 b8 1c 40 80 00 00 	movabs $0x80401c,%rax
  803ce7:	00 00 00 
  803cea:	ff d0                	callq  *%rax
}
  803cec:	c9                   	leaveq 
  803ced:	c3                   	retq   

0000000000803cee <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803cee:	55                   	push   %rbp
  803cef:	48 89 e5             	mov    %rsp,%rbp
  803cf2:	48 83 ec 10          	sub    $0x10,%rsp
  803cf6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803cfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cfe:	48 89 c7             	mov    %rax,%rdi
  803d01:	48 b8 71 4b 80 00 00 	movabs $0x804b71,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
  803d0d:	83 f8 01             	cmp    $0x1,%eax
  803d10:	75 17                	jne    803d29 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803d12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d16:	8b 40 0c             	mov    0xc(%rax),%eax
  803d19:	89 c7                	mov    %eax,%edi
  803d1b:	48 b8 5c 40 80 00 00 	movabs $0x80405c,%rax
  803d22:	00 00 00 
  803d25:	ff d0                	callq  *%rax
  803d27:	eb 05                	jmp    803d2e <devsock_close+0x40>
	else
		return 0;
  803d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d2e:	c9                   	leaveq 
  803d2f:	c3                   	retq   

0000000000803d30 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d30:	55                   	push   %rbp
  803d31:	48 89 e5             	mov    %rsp,%rbp
  803d34:	48 83 ec 20          	sub    $0x20,%rsp
  803d38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d3f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d45:	89 c7                	mov    %eax,%edi
  803d47:	48 b8 f6 3a 80 00 00 	movabs $0x803af6,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
  803d53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d5a:	79 05                	jns    803d61 <connect+0x31>
		return r;
  803d5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5f:	eb 1b                	jmp    803d7c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803d61:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d64:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6b:	48 89 ce             	mov    %rcx,%rsi
  803d6e:	89 c7                	mov    %eax,%edi
  803d70:	48 b8 89 40 80 00 00 	movabs $0x804089,%rax
  803d77:	00 00 00 
  803d7a:	ff d0                	callq  *%rax
}
  803d7c:	c9                   	leaveq 
  803d7d:	c3                   	retq   

0000000000803d7e <listen>:

int
listen(int s, int backlog)
{
  803d7e:	55                   	push   %rbp
  803d7f:	48 89 e5             	mov    %rsp,%rbp
  803d82:	48 83 ec 20          	sub    $0x20,%rsp
  803d86:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d89:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d8f:	89 c7                	mov    %eax,%edi
  803d91:	48 b8 f6 3a 80 00 00 	movabs $0x803af6,%rax
  803d98:	00 00 00 
  803d9b:	ff d0                	callq  *%rax
  803d9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da4:	79 05                	jns    803dab <listen+0x2d>
		return r;
  803da6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da9:	eb 16                	jmp    803dc1 <listen+0x43>
	return nsipc_listen(r, backlog);
  803dab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db1:	89 d6                	mov    %edx,%esi
  803db3:	89 c7                	mov    %eax,%edi
  803db5:	48 b8 ed 40 80 00 00 	movabs $0x8040ed,%rax
  803dbc:	00 00 00 
  803dbf:	ff d0                	callq  *%rax
}
  803dc1:	c9                   	leaveq 
  803dc2:	c3                   	retq   

0000000000803dc3 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803dc3:	55                   	push   %rbp
  803dc4:	48 89 e5             	mov    %rsp,%rbp
  803dc7:	48 83 ec 20          	sub    $0x20,%rsp
  803dcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803dd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ddb:	89 c2                	mov    %eax,%edx
  803ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de1:	8b 40 0c             	mov    0xc(%rax),%eax
  803de4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803de8:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ded:	89 c7                	mov    %eax,%edi
  803def:	48 b8 2d 41 80 00 00 	movabs $0x80412d,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 20          	sub    $0x20,%rsp
  803e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e0d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e15:	89 c2                	mov    %eax,%edx
  803e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e1b:	8b 40 0c             	mov    0xc(%rax),%eax
  803e1e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e22:	b9 00 00 00 00       	mov    $0x0,%ecx
  803e27:	89 c7                	mov    %eax,%edi
  803e29:	48 b8 f9 41 80 00 00 	movabs $0x8041f9,%rax
  803e30:	00 00 00 
  803e33:	ff d0                	callq  *%rax
}
  803e35:	c9                   	leaveq 
  803e36:	c3                   	retq   

0000000000803e37 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803e37:	55                   	push   %rbp
  803e38:	48 89 e5             	mov    %rsp,%rbp
  803e3b:	48 83 ec 10          	sub    $0x10,%rsp
  803e3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4b:	48 be a7 56 80 00 00 	movabs $0x8056a7,%rsi
  803e52:	00 00 00 
  803e55:	48 89 c7             	mov    %rax,%rdi
  803e58:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  803e5f:	00 00 00 
  803e62:	ff d0                	callq  *%rax
	return 0;
  803e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e69:	c9                   	leaveq 
  803e6a:	c3                   	retq   

0000000000803e6b <socket>:

int
socket(int domain, int type, int protocol)
{
  803e6b:	55                   	push   %rbp
  803e6c:	48 89 e5             	mov    %rsp,%rbp
  803e6f:	48 83 ec 20          	sub    $0x20,%rsp
  803e73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e76:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e79:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e7c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803e7f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e85:	89 ce                	mov    %ecx,%esi
  803e87:	89 c7                	mov    %eax,%edi
  803e89:	48 b8 b1 42 80 00 00 	movabs $0x8042b1,%rax
  803e90:	00 00 00 
  803e93:	ff d0                	callq  *%rax
  803e95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e9c:	79 05                	jns    803ea3 <socket+0x38>
		return r;
  803e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea1:	eb 11                	jmp    803eb4 <socket+0x49>
	return alloc_sockfd(r);
  803ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea6:	89 c7                	mov    %eax,%edi
  803ea8:	48 b8 4d 3b 80 00 00 	movabs $0x803b4d,%rax
  803eaf:	00 00 00 
  803eb2:	ff d0                	callq  *%rax
}
  803eb4:	c9                   	leaveq 
  803eb5:	c3                   	retq   

0000000000803eb6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803eb6:	55                   	push   %rbp
  803eb7:	48 89 e5             	mov    %rsp,%rbp
  803eba:	48 83 ec 10          	sub    $0x10,%rsp
  803ebe:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803ec1:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ec8:	00 00 00 
  803ecb:	8b 00                	mov    (%rax),%eax
  803ecd:	85 c0                	test   %eax,%eax
  803ecf:	75 1f                	jne    803ef0 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ed1:	bf 02 00 00 00       	mov    $0x2,%edi
  803ed6:	48 b8 52 2a 80 00 00 	movabs $0x802a52,%rax
  803edd:	00 00 00 
  803ee0:	ff d0                	callq  *%rax
  803ee2:	89 c2                	mov    %eax,%edx
  803ee4:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803eeb:	00 00 00 
  803eee:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803ef0:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ef7:	00 00 00 
  803efa:	8b 00                	mov    (%rax),%eax
  803efc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803eff:	b9 07 00 00 00       	mov    $0x7,%ecx
  803f04:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803f0b:	00 00 00 
  803f0e:	89 c7                	mov    %eax,%edi
  803f10:	48 b8 bd 29 80 00 00 	movabs $0x8029bd,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  803f21:	be 00 00 00 00       	mov    $0x0,%esi
  803f26:	bf 00 00 00 00       	mov    $0x0,%edi
  803f2b:	48 b8 fc 28 80 00 00 	movabs $0x8028fc,%rax
  803f32:	00 00 00 
  803f35:	ff d0                	callq  *%rax
}
  803f37:	c9                   	leaveq 
  803f38:	c3                   	retq   

0000000000803f39 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803f39:	55                   	push   %rbp
  803f3a:	48 89 e5             	mov    %rsp,%rbp
  803f3d:	48 83 ec 30          	sub    $0x30,%rsp
  803f41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803f4c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f53:	00 00 00 
  803f56:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f59:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803f5b:	bf 01 00 00 00       	mov    $0x1,%edi
  803f60:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  803f67:	00 00 00 
  803f6a:	ff d0                	callq  *%rax
  803f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f73:	78 3e                	js     803fb3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803f75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f7c:	00 00 00 
  803f7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f87:	8b 40 10             	mov    0x10(%rax),%eax
  803f8a:	89 c2                	mov    %eax,%edx
  803f8c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803f90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f94:	48 89 ce             	mov    %rcx,%rsi
  803f97:	48 89 c7             	mov    %rax,%rdi
  803f9a:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  803fa1:	00 00 00 
  803fa4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803faa:	8b 50 10             	mov    0x10(%rax),%edx
  803fad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803fb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fb6:	c9                   	leaveq 
  803fb7:	c3                   	retq   

0000000000803fb8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803fb8:	55                   	push   %rbp
  803fb9:	48 89 e5             	mov    %rsp,%rbp
  803fbc:	48 83 ec 10          	sub    $0x10,%rsp
  803fc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fc7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803fca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fd1:	00 00 00 
  803fd4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fd7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803fd9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe0:	48 89 c6             	mov    %rax,%rsi
  803fe3:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803fea:	00 00 00 
  803fed:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  803ff4:	00 00 00 
  803ff7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ff9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804000:	00 00 00 
  804003:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804006:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804009:	bf 02 00 00 00       	mov    $0x2,%edi
  80400e:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  804015:	00 00 00 
  804018:	ff d0                	callq  *%rax
}
  80401a:	c9                   	leaveq 
  80401b:	c3                   	retq   

000000000080401c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80401c:	55                   	push   %rbp
  80401d:	48 89 e5             	mov    %rsp,%rbp
  804020:	48 83 ec 10          	sub    $0x10,%rsp
  804024:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804027:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80402a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804031:	00 00 00 
  804034:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804037:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804039:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804040:	00 00 00 
  804043:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804046:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804049:	bf 03 00 00 00       	mov    $0x3,%edi
  80404e:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
}
  80405a:	c9                   	leaveq 
  80405b:	c3                   	retq   

000000000080405c <nsipc_close>:

int
nsipc_close(int s)
{
  80405c:	55                   	push   %rbp
  80405d:	48 89 e5             	mov    %rsp,%rbp
  804060:	48 83 ec 10          	sub    $0x10,%rsp
  804064:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804067:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80406e:	00 00 00 
  804071:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804074:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804076:	bf 04 00 00 00       	mov    $0x4,%edi
  80407b:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
}
  804087:	c9                   	leaveq 
  804088:	c3                   	retq   

0000000000804089 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 10          	sub    $0x10,%rsp
  804091:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804094:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804098:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80409b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a2:	00 00 00 
  8040a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040a8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8040aa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b1:	48 89 c6             	mov    %rax,%rsi
  8040b4:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8040bb:	00 00 00 
  8040be:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  8040c5:	00 00 00 
  8040c8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8040ca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040d1:	00 00 00 
  8040d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040d7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8040da:	bf 05 00 00 00       	mov    $0x5,%edi
  8040df:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  8040e6:	00 00 00 
  8040e9:	ff d0                	callq  *%rax
}
  8040eb:	c9                   	leaveq 
  8040ec:	c3                   	retq   

00000000008040ed <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8040ed:	55                   	push   %rbp
  8040ee:	48 89 e5             	mov    %rsp,%rbp
  8040f1:	48 83 ec 10          	sub    $0x10,%rsp
  8040f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8040fb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804102:	00 00 00 
  804105:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804108:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80410a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804111:	00 00 00 
  804114:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804117:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80411a:	bf 06 00 00 00       	mov    $0x6,%edi
  80411f:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  804126:	00 00 00 
  804129:	ff d0                	callq  *%rax
}
  80412b:	c9                   	leaveq 
  80412c:	c3                   	retq   

000000000080412d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80412d:	55                   	push   %rbp
  80412e:	48 89 e5             	mov    %rsp,%rbp
  804131:	48 83 ec 30          	sub    $0x30,%rsp
  804135:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804138:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80413c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80413f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804142:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804149:	00 00 00 
  80414c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80414f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804151:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804158:	00 00 00 
  80415b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80415e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804161:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804168:	00 00 00 
  80416b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80416e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804171:	bf 07 00 00 00       	mov    $0x7,%edi
  804176:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  80417d:	00 00 00 
  804180:	ff d0                	callq  *%rax
  804182:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804189:	78 69                	js     8041f4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80418b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804192:	7f 08                	jg     80419c <nsipc_recv+0x6f>
  804194:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804197:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80419a:	7e 35                	jle    8041d1 <nsipc_recv+0xa4>
  80419c:	48 b9 ae 56 80 00 00 	movabs $0x8056ae,%rcx
  8041a3:	00 00 00 
  8041a6:	48 ba c3 56 80 00 00 	movabs $0x8056c3,%rdx
  8041ad:	00 00 00 
  8041b0:	be 62 00 00 00       	mov    $0x62,%esi
  8041b5:	48 bf d8 56 80 00 00 	movabs $0x8056d8,%rdi
  8041bc:	00 00 00 
  8041bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8041c4:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8041cb:	00 00 00 
  8041ce:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8041d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d4:	48 63 d0             	movslq %eax,%rdx
  8041d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041db:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8041e2:	00 00 00 
  8041e5:	48 89 c7             	mov    %rax,%rdi
  8041e8:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  8041ef:	00 00 00 
  8041f2:	ff d0                	callq  *%rax
	}

	return r;
  8041f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041f7:	c9                   	leaveq 
  8041f8:	c3                   	retq   

00000000008041f9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8041f9:	55                   	push   %rbp
  8041fa:	48 89 e5             	mov    %rsp,%rbp
  8041fd:	48 83 ec 20          	sub    $0x20,%rsp
  804201:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804204:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804208:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80420b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80420e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804215:	00 00 00 
  804218:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80421b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80421d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804224:	7e 35                	jle    80425b <nsipc_send+0x62>
  804226:	48 b9 e4 56 80 00 00 	movabs $0x8056e4,%rcx
  80422d:	00 00 00 
  804230:	48 ba c3 56 80 00 00 	movabs $0x8056c3,%rdx
  804237:	00 00 00 
  80423a:	be 6d 00 00 00       	mov    $0x6d,%esi
  80423f:	48 bf d8 56 80 00 00 	movabs $0x8056d8,%rdi
  804246:	00 00 00 
  804249:	b8 00 00 00 00       	mov    $0x0,%eax
  80424e:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  804255:	00 00 00 
  804258:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80425b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80425e:	48 63 d0             	movslq %eax,%rdx
  804261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804265:	48 89 c6             	mov    %rax,%rsi
  804268:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  80426f:	00 00 00 
  804272:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  804279:	00 00 00 
  80427c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80427e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804285:	00 00 00 
  804288:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80428b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80428e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804295:	00 00 00 
  804298:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80429b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80429e:	bf 08 00 00 00       	mov    $0x8,%edi
  8042a3:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  8042aa:	00 00 00 
  8042ad:	ff d0                	callq  *%rax
}
  8042af:	c9                   	leaveq 
  8042b0:	c3                   	retq   

00000000008042b1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8042b1:	55                   	push   %rbp
  8042b2:	48 89 e5             	mov    %rsp,%rbp
  8042b5:	48 83 ec 10          	sub    $0x10,%rsp
  8042b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8042bf:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8042c2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042c9:	00 00 00 
  8042cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042cf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8042d1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042d8:	00 00 00 
  8042db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042de:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8042e1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042e8:	00 00 00 
  8042eb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8042ee:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8042f1:	bf 09 00 00 00       	mov    $0x9,%edi
  8042f6:	48 b8 b6 3e 80 00 00 	movabs $0x803eb6,%rax
  8042fd:	00 00 00 
  804300:	ff d0                	callq  *%rax
}
  804302:	c9                   	leaveq 
  804303:	c3                   	retq   

0000000000804304 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804304:	55                   	push   %rbp
  804305:	48 89 e5             	mov    %rsp,%rbp
  804308:	53                   	push   %rbx
  804309:	48 83 ec 38          	sub    $0x38,%rsp
  80430d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804311:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804315:	48 89 c7             	mov    %rax,%rdi
  804318:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  80431f:	00 00 00 
  804322:	ff d0                	callq  *%rax
  804324:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804327:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80432b:	0f 88 bf 01 00 00    	js     8044f0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804335:	ba 07 04 00 00       	mov    $0x407,%edx
  80433a:	48 89 c6             	mov    %rax,%rsi
  80433d:	bf 00 00 00 00       	mov    $0x0,%edi
  804342:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  804349:	00 00 00 
  80434c:	ff d0                	callq  *%rax
  80434e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804351:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804355:	0f 88 95 01 00 00    	js     8044f0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80435b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80435f:	48 89 c7             	mov    %rax,%rdi
  804362:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  804369:	00 00 00 
  80436c:	ff d0                	callq  *%rax
  80436e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804371:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804375:	0f 88 5d 01 00 00    	js     8044d8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80437b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80437f:	ba 07 04 00 00       	mov    $0x407,%edx
  804384:	48 89 c6             	mov    %rax,%rsi
  804387:	bf 00 00 00 00       	mov    $0x0,%edi
  80438c:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  804393:	00 00 00 
  804396:	ff d0                	callq  *%rax
  804398:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80439b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80439f:	0f 88 33 01 00 00    	js     8044d8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8043a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a9:	48 89 c7             	mov    %rax,%rdi
  8043ac:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  8043b3:	00 00 00 
  8043b6:	ff d0                	callq  *%rax
  8043b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043c0:	ba 07 04 00 00       	mov    $0x407,%edx
  8043c5:	48 89 c6             	mov    %rax,%rsi
  8043c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cd:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8043d4:	00 00 00 
  8043d7:	ff d0                	callq  *%rax
  8043d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043e0:	0f 88 d9 00 00 00    	js     8044bf <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ea:	48 89 c7             	mov    %rax,%rdi
  8043ed:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  8043f4:	00 00 00 
  8043f7:	ff d0                	callq  *%rax
  8043f9:	48 89 c2             	mov    %rax,%rdx
  8043fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804400:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804406:	48 89 d1             	mov    %rdx,%rcx
  804409:	ba 00 00 00 00       	mov    $0x0,%edx
  80440e:	48 89 c6             	mov    %rax,%rsi
  804411:	bf 00 00 00 00       	mov    $0x0,%edi
  804416:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  80441d:	00 00 00 
  804420:	ff d0                	callq  *%rax
  804422:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804425:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804429:	78 79                	js     8044a4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80442b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80442f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804436:	00 00 00 
  804439:	8b 12                	mov    (%rdx),%edx
  80443b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80443d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804441:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804448:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80444c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804453:	00 00 00 
  804456:	8b 12                	mov    (%rdx),%edx
  804458:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80445a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80445e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804469:	48 89 c7             	mov    %rax,%rdi
  80446c:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  804473:	00 00 00 
  804476:	ff d0                	callq  *%rax
  804478:	89 c2                	mov    %eax,%edx
  80447a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80447e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804480:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804484:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804488:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80448c:	48 89 c7             	mov    %rax,%rdi
  80448f:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  804496:	00 00 00 
  804499:	ff d0                	callq  *%rax
  80449b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80449d:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a2:	eb 4f                	jmp    8044f3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8044a4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8044a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a9:	48 89 c6             	mov    %rax,%rsi
  8044ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8044b1:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  8044b8:	00 00 00 
  8044bb:	ff d0                	callq  *%rax
  8044bd:	eb 01                	jmp    8044c0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8044bf:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8044c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044c4:	48 89 c6             	mov    %rax,%rsi
  8044c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8044cc:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  8044d3:	00 00 00 
  8044d6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8044d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044dc:	48 89 c6             	mov    %rax,%rsi
  8044df:	bf 00 00 00 00       	mov    $0x0,%edi
  8044e4:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  8044eb:	00 00 00 
  8044ee:	ff d0                	callq  *%rax
err:
	return r;
  8044f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044f3:	48 83 c4 38          	add    $0x38,%rsp
  8044f7:	5b                   	pop    %rbx
  8044f8:	5d                   	pop    %rbp
  8044f9:	c3                   	retq   

00000000008044fa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8044fa:	55                   	push   %rbp
  8044fb:	48 89 e5             	mov    %rsp,%rbp
  8044fe:	53                   	push   %rbx
  8044ff:	48 83 ec 28          	sub    $0x28,%rsp
  804503:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804507:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80450b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804512:	00 00 00 
  804515:	48 8b 00             	mov    (%rax),%rax
  804518:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80451e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804525:	48 89 c7             	mov    %rax,%rdi
  804528:	48 b8 71 4b 80 00 00 	movabs $0x804b71,%rax
  80452f:	00 00 00 
  804532:	ff d0                	callq  *%rax
  804534:	89 c3                	mov    %eax,%ebx
  804536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80453a:	48 89 c7             	mov    %rax,%rdi
  80453d:	48 b8 71 4b 80 00 00 	movabs $0x804b71,%rax
  804544:	00 00 00 
  804547:	ff d0                	callq  *%rax
  804549:	39 c3                	cmp    %eax,%ebx
  80454b:	0f 94 c0             	sete   %al
  80454e:	0f b6 c0             	movzbl %al,%eax
  804551:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804554:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80455b:	00 00 00 
  80455e:	48 8b 00             	mov    (%rax),%rax
  804561:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804567:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80456a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80456d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804570:	75 05                	jne    804577 <_pipeisclosed+0x7d>
			return ret;
  804572:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804575:	eb 4a                	jmp    8045c1 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804577:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80457a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80457d:	74 8c                	je     80450b <_pipeisclosed+0x11>
  80457f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804583:	75 86                	jne    80450b <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804585:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80458c:	00 00 00 
  80458f:	48 8b 00             	mov    (%rax),%rax
  804592:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804598:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80459b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80459e:	89 c6                	mov    %eax,%esi
  8045a0:	48 bf f5 56 80 00 00 	movabs $0x8056f5,%rdi
  8045a7:	00 00 00 
  8045aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8045af:	49 b8 3e 0f 80 00 00 	movabs $0x800f3e,%r8
  8045b6:	00 00 00 
  8045b9:	41 ff d0             	callq  *%r8
	}
  8045bc:	e9 4a ff ff ff       	jmpq   80450b <_pipeisclosed+0x11>

}
  8045c1:	48 83 c4 28          	add    $0x28,%rsp
  8045c5:	5b                   	pop    %rbx
  8045c6:	5d                   	pop    %rbp
  8045c7:	c3                   	retq   

00000000008045c8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8045c8:	55                   	push   %rbp
  8045c9:	48 89 e5             	mov    %rsp,%rbp
  8045cc:	48 83 ec 30          	sub    $0x30,%rsp
  8045d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045d3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8045d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8045da:	48 89 d6             	mov    %rdx,%rsi
  8045dd:	89 c7                	mov    %eax,%edi
  8045df:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8045e6:	00 00 00 
  8045e9:	ff d0                	callq  *%rax
  8045eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f2:	79 05                	jns    8045f9 <pipeisclosed+0x31>
		return r;
  8045f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f7:	eb 31                	jmp    80462a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8045f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045fd:	48 89 c7             	mov    %rax,%rdi
  804600:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  804607:	00 00 00 
  80460a:	ff d0                	callq  *%rax
  80460c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804614:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804618:	48 89 d6             	mov    %rdx,%rsi
  80461b:	48 89 c7             	mov    %rax,%rdi
  80461e:	48 b8 fa 44 80 00 00 	movabs $0x8044fa,%rax
  804625:	00 00 00 
  804628:	ff d0                	callq  *%rax
}
  80462a:	c9                   	leaveq 
  80462b:	c3                   	retq   

000000000080462c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80462c:	55                   	push   %rbp
  80462d:	48 89 e5             	mov    %rsp,%rbp
  804630:	48 83 ec 40          	sub    $0x40,%rsp
  804634:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804638:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80463c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804644:	48 89 c7             	mov    %rax,%rdi
  804647:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  80464e:	00 00 00 
  804651:	ff d0                	callq  *%rax
  804653:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804657:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80465b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80465f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804666:	00 
  804667:	e9 90 00 00 00       	jmpq   8046fc <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80466c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804671:	74 09                	je     80467c <devpipe_read+0x50>
				return i;
  804673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804677:	e9 8e 00 00 00       	jmpq   80470a <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80467c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804684:	48 89 d6             	mov    %rdx,%rsi
  804687:	48 89 c7             	mov    %rax,%rdi
  80468a:	48 b8 fa 44 80 00 00 	movabs $0x8044fa,%rax
  804691:	00 00 00 
  804694:	ff d0                	callq  *%rax
  804696:	85 c0                	test   %eax,%eax
  804698:	74 07                	je     8046a1 <devpipe_read+0x75>
				return 0;
  80469a:	b8 00 00 00 00       	mov    $0x0,%eax
  80469f:	eb 69                	jmp    80470a <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8046a1:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  8046a8:	00 00 00 
  8046ab:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8046ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b1:	8b 10                	mov    (%rax),%edx
  8046b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b7:	8b 40 04             	mov    0x4(%rax),%eax
  8046ba:	39 c2                	cmp    %eax,%edx
  8046bc:	74 ae                	je     80466c <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8046be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046c6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8046ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ce:	8b 00                	mov    (%rax),%eax
  8046d0:	99                   	cltd   
  8046d1:	c1 ea 1b             	shr    $0x1b,%edx
  8046d4:	01 d0                	add    %edx,%eax
  8046d6:	83 e0 1f             	and    $0x1f,%eax
  8046d9:	29 d0                	sub    %edx,%eax
  8046db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046df:	48 98                	cltq   
  8046e1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8046e6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8046e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ec:	8b 00                	mov    (%rax),%eax
  8046ee:	8d 50 01             	lea    0x1(%rax),%edx
  8046f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804700:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804704:	72 a7                	jb     8046ad <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80470a:	c9                   	leaveq 
  80470b:	c3                   	retq   

000000000080470c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80470c:	55                   	push   %rbp
  80470d:	48 89 e5             	mov    %rsp,%rbp
  804710:	48 83 ec 40          	sub    $0x40,%rsp
  804714:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804718:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80471c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804724:	48 89 c7             	mov    %rax,%rdi
  804727:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  80472e:	00 00 00 
  804731:	ff d0                	callq  *%rax
  804733:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80473b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80473f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804746:	00 
  804747:	e9 8f 00 00 00       	jmpq   8047db <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80474c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804754:	48 89 d6             	mov    %rdx,%rsi
  804757:	48 89 c7             	mov    %rax,%rdi
  80475a:	48 b8 fa 44 80 00 00 	movabs $0x8044fa,%rax
  804761:	00 00 00 
  804764:	ff d0                	callq  *%rax
  804766:	85 c0                	test   %eax,%eax
  804768:	74 07                	je     804771 <devpipe_write+0x65>
				return 0;
  80476a:	b8 00 00 00 00       	mov    $0x0,%eax
  80476f:	eb 78                	jmp    8047e9 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804771:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  804778:	00 00 00 
  80477b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80477d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804781:	8b 40 04             	mov    0x4(%rax),%eax
  804784:	48 63 d0             	movslq %eax,%rdx
  804787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80478b:	8b 00                	mov    (%rax),%eax
  80478d:	48 98                	cltq   
  80478f:	48 83 c0 20          	add    $0x20,%rax
  804793:	48 39 c2             	cmp    %rax,%rdx
  804796:	73 b4                	jae    80474c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804798:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80479c:	8b 40 04             	mov    0x4(%rax),%eax
  80479f:	99                   	cltd   
  8047a0:	c1 ea 1b             	shr    $0x1b,%edx
  8047a3:	01 d0                	add    %edx,%eax
  8047a5:	83 e0 1f             	and    $0x1f,%eax
  8047a8:	29 d0                	sub    %edx,%eax
  8047aa:	89 c6                	mov    %eax,%esi
  8047ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047b4:	48 01 d0             	add    %rdx,%rax
  8047b7:	0f b6 08             	movzbl (%rax),%ecx
  8047ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047be:	48 63 c6             	movslq %esi,%rax
  8047c1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8047c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047c9:	8b 40 04             	mov    0x4(%rax),%eax
  8047cc:	8d 50 01             	lea    0x1(%rax),%edx
  8047cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047d3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8047d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047df:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8047e3:	72 98                	jb     80477d <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8047e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8047e9:	c9                   	leaveq 
  8047ea:	c3                   	retq   

00000000008047eb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047eb:	55                   	push   %rbp
  8047ec:	48 89 e5             	mov    %rsp,%rbp
  8047ef:	48 83 ec 20          	sub    $0x20,%rsp
  8047f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8047fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ff:	48 89 c7             	mov    %rax,%rdi
  804802:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  804809:	00 00 00 
  80480c:	ff d0                	callq  *%rax
  80480e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804812:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804816:	48 be 08 57 80 00 00 	movabs $0x805708,%rsi
  80481d:	00 00 00 
  804820:	48 89 c7             	mov    %rax,%rdi
  804823:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  80482a:	00 00 00 
  80482d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80482f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804833:	8b 50 04             	mov    0x4(%rax),%edx
  804836:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80483a:	8b 00                	mov    (%rax),%eax
  80483c:	29 c2                	sub    %eax,%edx
  80483e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804842:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804848:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80484c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804853:	00 00 00 
	stat->st_dev = &devpipe;
  804856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80485a:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804861:	00 00 00 
  804864:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80486b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804870:	c9                   	leaveq 
  804871:	c3                   	retq   

0000000000804872 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804872:	55                   	push   %rbp
  804873:	48 89 e5             	mov    %rsp,%rbp
  804876:	48 83 ec 10          	sub    $0x10,%rsp
  80487a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80487e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804882:	48 89 c6             	mov    %rax,%rsi
  804885:	bf 00 00 00 00       	mov    $0x0,%edi
  80488a:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  804891:	00 00 00 
  804894:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804896:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80489a:	48 89 c7             	mov    %rax,%rdi
  80489d:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  8048a4:	00 00 00 
  8048a7:	ff d0                	callq  *%rax
  8048a9:	48 89 c6             	mov    %rax,%rsi
  8048ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8048b1:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  8048b8:	00 00 00 
  8048bb:	ff d0                	callq  *%rax
}
  8048bd:	c9                   	leaveq 
  8048be:	c3                   	retq   

00000000008048bf <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8048bf:	55                   	push   %rbp
  8048c0:	48 89 e5             	mov    %rsp,%rbp
  8048c3:	48 83 ec 20          	sub    $0x20,%rsp
  8048c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8048ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048cd:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8048d0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8048d4:	be 01 00 00 00       	mov    $0x1,%esi
  8048d9:	48 89 c7             	mov    %rax,%rdi
  8048dc:	48 b8 bc 22 80 00 00 	movabs $0x8022bc,%rax
  8048e3:	00 00 00 
  8048e6:	ff d0                	callq  *%rax
}
  8048e8:	90                   	nop
  8048e9:	c9                   	leaveq 
  8048ea:	c3                   	retq   

00000000008048eb <getchar>:

int
getchar(void)
{
  8048eb:	55                   	push   %rbp
  8048ec:	48 89 e5             	mov    %rsp,%rbp
  8048ef:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8048f3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8048f7:	ba 01 00 00 00       	mov    $0x1,%edx
  8048fc:	48 89 c6             	mov    %rax,%rsi
  8048ff:	bf 00 00 00 00       	mov    $0x0,%edi
  804904:	48 b8 de 2f 80 00 00 	movabs $0x802fde,%rax
  80490b:	00 00 00 
  80490e:	ff d0                	callq  *%rax
  804910:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804913:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804917:	79 05                	jns    80491e <getchar+0x33>
		return r;
  804919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80491c:	eb 14                	jmp    804932 <getchar+0x47>
	if (r < 1)
  80491e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804922:	7f 07                	jg     80492b <getchar+0x40>
		return -E_EOF;
  804924:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804929:	eb 07                	jmp    804932 <getchar+0x47>
	return c;
  80492b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80492f:	0f b6 c0             	movzbl %al,%eax

}
  804932:	c9                   	leaveq 
  804933:	c3                   	retq   

0000000000804934 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804934:	55                   	push   %rbp
  804935:	48 89 e5             	mov    %rsp,%rbp
  804938:	48 83 ec 20          	sub    $0x20,%rsp
  80493c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80493f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804943:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804946:	48 89 d6             	mov    %rdx,%rsi
  804949:	89 c7                	mov    %eax,%edi
  80494b:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  804952:	00 00 00 
  804955:	ff d0                	callq  *%rax
  804957:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80495a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80495e:	79 05                	jns    804965 <iscons+0x31>
		return r;
  804960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804963:	eb 1a                	jmp    80497f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804969:	8b 10                	mov    (%rax),%edx
  80496b:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804972:	00 00 00 
  804975:	8b 00                	mov    (%rax),%eax
  804977:	39 c2                	cmp    %eax,%edx
  804979:	0f 94 c0             	sete   %al
  80497c:	0f b6 c0             	movzbl %al,%eax
}
  80497f:	c9                   	leaveq 
  804980:	c3                   	retq   

0000000000804981 <opencons>:

int
opencons(void)
{
  804981:	55                   	push   %rbp
  804982:	48 89 e5             	mov    %rsp,%rbp
  804985:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804989:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80498d:	48 89 c7             	mov    %rax,%rdi
  804990:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  804997:	00 00 00 
  80499a:	ff d0                	callq  *%rax
  80499c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80499f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049a3:	79 05                	jns    8049aa <opencons+0x29>
		return r;
  8049a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a8:	eb 5b                	jmp    804a05 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8049aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8049b3:	48 89 c6             	mov    %rax,%rsi
  8049b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8049bb:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8049c2:	00 00 00 
  8049c5:	ff d0                	callq  *%rax
  8049c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049ce:	79 05                	jns    8049d5 <opencons+0x54>
		return r;
  8049d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049d3:	eb 30                	jmp    804a05 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8049d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049d9:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8049e0:	00 00 00 
  8049e3:	8b 12                	mov    (%rdx),%edx
  8049e5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8049e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8049f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049f6:	48 89 c7             	mov    %rax,%rdi
  8049f9:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  804a00:	00 00 00 
  804a03:	ff d0                	callq  *%rax
}
  804a05:	c9                   	leaveq 
  804a06:	c3                   	retq   

0000000000804a07 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804a07:	55                   	push   %rbp
  804a08:	48 89 e5             	mov    %rsp,%rbp
  804a0b:	48 83 ec 30          	sub    $0x30,%rsp
  804a0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804a1b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a20:	75 13                	jne    804a35 <devcons_read+0x2e>
		return 0;
  804a22:	b8 00 00 00 00       	mov    $0x0,%eax
  804a27:	eb 49                	jmp    804a72 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804a29:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  804a30:	00 00 00 
  804a33:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804a35:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  804a3c:	00 00 00 
  804a3f:	ff d0                	callq  *%rax
  804a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a48:	74 df                	je     804a29 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a4e:	79 05                	jns    804a55 <devcons_read+0x4e>
		return c;
  804a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a53:	eb 1d                	jmp    804a72 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804a55:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804a59:	75 07                	jne    804a62 <devcons_read+0x5b>
		return 0;
  804a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  804a60:	eb 10                	jmp    804a72 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a65:	89 c2                	mov    %eax,%edx
  804a67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a6b:	88 10                	mov    %dl,(%rax)
	return 1;
  804a6d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804a72:	c9                   	leaveq 
  804a73:	c3                   	retq   

0000000000804a74 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a74:	55                   	push   %rbp
  804a75:	48 89 e5             	mov    %rsp,%rbp
  804a78:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804a7f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804a86:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804a8d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804a94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a9b:	eb 76                	jmp    804b13 <devcons_write+0x9f>
		m = n - tot;
  804a9d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804aa4:	89 c2                	mov    %eax,%edx
  804aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804aa9:	29 c2                	sub    %eax,%edx
  804aab:	89 d0                	mov    %edx,%eax
  804aad:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804ab0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ab3:	83 f8 7f             	cmp    $0x7f,%eax
  804ab6:	76 07                	jbe    804abf <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804ab8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804abf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ac2:	48 63 d0             	movslq %eax,%rdx
  804ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ac8:	48 63 c8             	movslq %eax,%rcx
  804acb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804ad2:	48 01 c1             	add    %rax,%rcx
  804ad5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804adc:	48 89 ce             	mov    %rcx,%rsi
  804adf:	48 89 c7             	mov    %rax,%rdi
  804ae2:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  804ae9:	00 00 00 
  804aec:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804aee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804af1:	48 63 d0             	movslq %eax,%rdx
  804af4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804afb:	48 89 d6             	mov    %rdx,%rsi
  804afe:	48 89 c7             	mov    %rax,%rdi
  804b01:	48 b8 bc 22 80 00 00 	movabs $0x8022bc,%rax
  804b08:	00 00 00 
  804b0b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b10:	01 45 fc             	add    %eax,-0x4(%rbp)
  804b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b16:	48 98                	cltq   
  804b18:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804b1f:	0f 82 78 ff ff ff    	jb     804a9d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804b25:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804b28:	c9                   	leaveq 
  804b29:	c3                   	retq   

0000000000804b2a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804b2a:	55                   	push   %rbp
  804b2b:	48 89 e5             	mov    %rsp,%rbp
  804b2e:	48 83 ec 08          	sub    $0x8,%rsp
  804b32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b3b:	c9                   	leaveq 
  804b3c:	c3                   	retq   

0000000000804b3d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804b3d:	55                   	push   %rbp
  804b3e:	48 89 e5             	mov    %rsp,%rbp
  804b41:	48 83 ec 10          	sub    $0x10,%rsp
  804b45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804b4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b51:	48 be 14 57 80 00 00 	movabs $0x805714,%rsi
  804b58:	00 00 00 
  804b5b:	48 89 c7             	mov    %rax,%rdi
  804b5e:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  804b65:	00 00 00 
  804b68:	ff d0                	callq  *%rax
	return 0;
  804b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b6f:	c9                   	leaveq 
  804b70:	c3                   	retq   

0000000000804b71 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804b71:	55                   	push   %rbp
  804b72:	48 89 e5             	mov    %rsp,%rbp
  804b75:	48 83 ec 18          	sub    $0x18,%rsp
  804b79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b81:	48 c1 e8 15          	shr    $0x15,%rax
  804b85:	48 89 c2             	mov    %rax,%rdx
  804b88:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b8f:	01 00 00 
  804b92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b96:	83 e0 01             	and    $0x1,%eax
  804b99:	48 85 c0             	test   %rax,%rax
  804b9c:	75 07                	jne    804ba5 <pageref+0x34>
		return 0;
  804b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  804ba3:	eb 56                	jmp    804bfb <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ba9:	48 c1 e8 0c          	shr    $0xc,%rax
  804bad:	48 89 c2             	mov    %rax,%rdx
  804bb0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804bb7:	01 00 00 
  804bba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804bbe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bc6:	83 e0 01             	and    $0x1,%eax
  804bc9:	48 85 c0             	test   %rax,%rax
  804bcc:	75 07                	jne    804bd5 <pageref+0x64>
		return 0;
  804bce:	b8 00 00 00 00       	mov    $0x0,%eax
  804bd3:	eb 26                	jmp    804bfb <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804bd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bd9:	48 c1 e8 0c          	shr    $0xc,%rax
  804bdd:	48 89 c2             	mov    %rax,%rdx
  804be0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804be7:	00 00 00 
  804bea:	48 c1 e2 04          	shl    $0x4,%rdx
  804bee:	48 01 d0             	add    %rdx,%rax
  804bf1:	48 83 c0 08          	add    $0x8,%rax
  804bf5:	0f b7 00             	movzwl (%rax),%eax
  804bf8:	0f b7 c0             	movzwl %ax,%eax
}
  804bfb:	c9                   	leaveq 
  804bfc:	c3                   	retq   
