
vmm/guest/obj/user/testfile:     file format elf64-x86-64


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
  800087:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
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
  8000af:	48 b8 c1 28 80 00 00 	movabs $0x8028c1,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
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
  8000f6:	48 bf a6 4c 80 00 00 	movabs $0x804ca6,%rdi
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
  800127:	48 ba b1 4c 80 00 00 	movabs $0x804cb1,%rdx
  80012e:	00 00 00 
  800131:	be 21 00 00 00       	mov    $0x21,%esi
  800136:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba e0 4c 80 00 00 	movabs $0x804ce0,%rdx
  800160:	00 00 00 
  800163:	be 23 00 00 00       	mov    $0x23,%esi
  800168:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 01 4d 80 00 00 	movabs $0x804d01,%rdi
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
  8001b2:	48 ba 0a 4d 80 00 00 	movabs $0x804d0a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 26 00 00 00       	mov    $0x26,%esi
  8001c1:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800201:	48 ba 28 4d 80 00 00 	movabs $0x804d28,%rdx
  800208:	00 00 00 
  80020b:	be 28 00 00 00       	mov    $0x28,%esi
  800210:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 55 4d 80 00 00 	movabs $0x804d55,%rdi
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
  800279:	48 ba 69 4d 80 00 00 	movabs $0x804d69,%rdx
  800280:	00 00 00 
  800283:	be 2c 00 00 00       	mov    $0x2c,%esi
  800288:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  8002ef:	48 ba 78 4d 80 00 00 	movabs $0x804d78,%rdx
  8002f6:	00 00 00 
  8002f9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8002fe:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  800305:	00 00 00 
  800308:	b8 00 00 00 00       	mov    $0x0,%eax
  80030d:	49 b9 04 0d 80 00 00 	movabs $0x800d04,%r9
  800314:	00 00 00 
  800317:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  80031a:	48 bf 9e 4d 80 00 00 	movabs $0x804d9e,%rdi
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
  80038d:	48 ba b1 4d 80 00 00 	movabs $0x804db1,%rdx
  800394:	00 00 00 
  800397:	be 33 00 00 00       	mov    $0x33,%esi
  80039c:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  8003e2:	48 ba bf 4d 80 00 00 	movabs $0x804dbf,%rdx
  8003e9:	00 00 00 
  8003ec:	be 35 00 00 00       	mov    $0x35,%esi
  8003f1:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  8003f8:	00 00 00 
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800400:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  800407:	00 00 00 
  80040a:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040c:	48 bf dd 4d 80 00 00 	movabs $0x804ddd,%rdi
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
  800450:	48 ba f0 4d 80 00 00 	movabs $0x804df0,%rdx
  800457:	00 00 00 
  80045a:	be 39 00 00 00       	mov    $0x39,%esi
  80045f:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  800466:	00 00 00 
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800475:	00 00 00 
  800478:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  80047b:	48 bf ff 4d 80 00 00 	movabs $0x804dff,%rdi
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
  8004f7:	48 ba 18 4e 80 00 00 	movabs $0x804e18,%rdx
  8004fe:	00 00 00 
  800501:	be 44 00 00 00       	mov    $0x44,%esi
  800506:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  80050d:	00 00 00 
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80051c:	00 00 00 
  80051f:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800522:	48 bf 4f 4e 80 00 00 	movabs $0x804e4f,%rdi
  800529:	00 00 00 
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
  800531:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800538:	00 00 00 
  80053b:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053d:	be 02 01 00 00       	mov    $0x102,%esi
  800542:	48 bf 65 4e 80 00 00 	movabs $0x804e65,%rdi
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
  80056c:	48 ba 6f 4e 80 00 00 	movabs $0x804e6f,%rdx
  800573:	00 00 00 
  800576:	be 49 00 00 00       	mov    $0x49,%esi
  80057b:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  8005d9:	48 bf 88 4e 80 00 00 	movabs $0x804e88,%rdi
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
  80066e:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  800675:	00 00 00 
  800678:	be 4e 00 00 00       	mov    $0x4e,%esi
  80067d:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  800684:	00 00 00 
  800687:	b8 00 00 00 00       	mov    $0x0,%eax
  80068c:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800693:	00 00 00 
  800696:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  800699:	48 bf d7 4e 80 00 00 	movabs $0x804ed7,%rdi
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
  800718:	48 ba f0 4e 80 00 00 	movabs $0x804ef0,%rdx
  80071f:	00 00 00 
  800722:	be 54 00 00 00       	mov    $0x54,%esi
  800727:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  80076e:	48 ba 10 4f 80 00 00 	movabs $0x804f10,%rdx
  800775:	00 00 00 
  800778:	be 56 00 00 00       	mov    $0x56,%esi
  80077d:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  8007c3:	48 ba 48 4f 80 00 00 	movabs $0x804f48,%rdx
  8007ca:	00 00 00 
  8007cd:	be 58 00 00 00       	mov    $0x58,%esi
  8007d2:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  8007d9:	00 00 00 
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  8007e8:	00 00 00 
  8007eb:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  8007ed:	48 bf 78 4f 80 00 00 	movabs $0x804f78,%rdi
  8007f4:	00 00 00 
  8007f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fc:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800803:	00 00 00 
  800806:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800808:	be 00 00 00 00       	mov    $0x0,%esi
  80080d:	48 bf a6 4c 80 00 00 	movabs $0x804ca6,%rdi
  800814:	00 00 00 
  800817:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
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
  80083e:	48 ba 9c 4f 80 00 00 	movabs $0x804f9c,%rdx
  800845:	00 00 00 
  800848:	be 5d 00 00 00       	mov    $0x5d,%esi
  80084d:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  800854:	00 00 00 
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800863:	00 00 00 
  800866:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800869:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80086e:	78 2a                	js     80089a <umain+0x7c2>
		panic("open /not-found succeeded!");
  800870:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  800877:	00 00 00 
  80087a:	be 5f 00 00 00       	mov    $0x5f,%esi
  80087f:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  800886:	00 00 00 
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
  80088e:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  800895:	00 00 00 
  800898:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80089a:	be 00 00 00 00       	mov    $0x0,%esi
  80089f:	48 bf 01 4d 80 00 00 	movabs $0x804d01,%rdi
  8008a6:	00 00 00 
  8008a9:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  8008b0:	00 00 00 
  8008b3:	ff d0                	callq  *%rax
  8008b5:	48 98                	cltq   
  8008b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008c0:	79 32                	jns    8008f4 <umain+0x81c>
		panic("open /newmotd: %e", r);
  8008c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008c6:	48 89 c1             	mov    %rax,%rcx
  8008c9:	48 ba cb 4f 80 00 00 	movabs $0x804fcb,%rdx
  8008d0:	00 00 00 
  8008d3:	be 62 00 00 00       	mov    $0x62,%esi
  8008d8:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800927:	48 ba e0 4f 80 00 00 	movabs $0x804fe0,%rdx
  80092e:	00 00 00 
  800931:	be 65 00 00 00       	mov    $0x65,%esi
  800936:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
  80093d:	00 00 00 
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	48 b9 04 0d 80 00 00 	movabs $0x800d04,%rcx
  80094c:	00 00 00 
  80094f:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800951:	48 bf 07 50 80 00 00 	movabs $0x805007,%rdi
  800958:	00 00 00 
  80095b:	b8 00 00 00 00       	mov    $0x0,%eax
  800960:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  800967:	00 00 00 
  80096a:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80096c:	be 01 01 00 00       	mov    $0x101,%esi
  800971:	48 bf 15 50 80 00 00 	movabs $0x805015,%rdi
  800978:	00 00 00 
  80097b:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
  800987:	48 98                	cltq   
  800989:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80098d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800992:	79 32                	jns    8009c6 <umain+0x8ee>
		panic("creat /big: %e", f);
  800994:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800998:	48 89 c1             	mov    %rax,%rcx
  80099b:	48 ba 1a 50 80 00 00 	movabs $0x80501a,%rdx
  8009a2:	00 00 00 
  8009a5:	be 6a 00 00 00       	mov    $0x6a,%esi
  8009aa:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800a17:	48 b8 a4 31 80 00 00 	movabs $0x8031a4,%rax
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
  800a3e:	48 ba 29 50 80 00 00 	movabs $0x805029,%rdx
  800a45:	00 00 00 
  800a48:	be 6f 00 00 00       	mov    $0x6f,%esi
  800a4d:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800a8b:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  800a92:	00 00 00 
  800a95:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800a97:	be 00 00 00 00       	mov    $0x0,%esi
  800a9c:	48 bf 15 50 80 00 00 	movabs $0x805015,%rdi
  800aa3:	00 00 00 
  800aa6:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 98                	cltq   
  800ab4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ab8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800abd:	79 32                	jns    800af1 <umain+0xa19>
		panic("open /big: %e", f);
  800abf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ac3:	48 89 c1             	mov    %rax,%rcx
  800ac6:	48 ba 3b 50 80 00 00 	movabs $0x80503b,%rdx
  800acd:	00 00 00 
  800ad0:	be 74 00 00 00       	mov    $0x74,%esi
  800ad5:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800b22:	48 b8 2e 31 80 00 00 	movabs $0x80312e,%rax
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
  800b49:	48 ba 49 50 80 00 00 	movabs $0x805049,%rdx
  800b50:	00 00 00 
  800b53:	be 78 00 00 00       	mov    $0x78,%esi
  800b58:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800b92:	48 ba 60 50 80 00 00 	movabs $0x805060,%rdx
  800b99:	00 00 00 
  800b9c:	be 7b 00 00 00       	mov    $0x7b,%esi
  800ba1:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800be1:	48 ba 90 50 80 00 00 	movabs $0x805090,%rdx
  800be8:	00 00 00 
  800beb:	be 7e 00 00 00       	mov    $0x7e,%esi
  800bf0:	48 bf cb 4c 80 00 00 	movabs $0x804ccb,%rdi
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
  800c2e:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  800c35:	00 00 00 
  800c38:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c3a:	48 bf b7 50 80 00 00 	movabs $0x8050b7,%rdi
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
  800ce4:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
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
  800dbe:	48 bf d8 50 80 00 00 	movabs $0x8050d8,%rdi
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
  800dfa:	48 bf fb 50 80 00 00 	movabs $0x8050fb,%rdi
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
  8010ab:	48 b8 f0 52 80 00 00 	movabs $0x8052f0,%rax
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
  80138d:	48 b8 18 53 80 00 00 	movabs $0x805318,%rax
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
  8014d4:	48 b8 40 52 80 00 00 	movabs $0x805240,%rax
  8014db:	00 00 00 
  8014de:	48 63 d3             	movslq %ebx,%rdx
  8014e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8014e5:	4d 85 e4             	test   %r12,%r12
  8014e8:	75 2e                	jne    801518 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8014ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f2:	89 d9                	mov    %ebx,%ecx
  8014f4:	48 ba 01 53 80 00 00 	movabs $0x805301,%rdx
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
  801523:	48 ba 0a 53 80 00 00 	movabs $0x80530a,%rdx
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
  80157a:	49 bc 0d 53 80 00 00 	movabs $0x80530d,%r12
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
  802286:	48 ba c8 55 80 00 00 	movabs $0x8055c8,%rdx
  80228d:	00 00 00 
  802290:	be 24 00 00 00       	mov    $0x24,%esi
  802295:	48 bf e5 55 80 00 00 	movabs $0x8055e5,%rdi
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

0000000000802800 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802800:	55                   	push   %rbp
  802801:	48 89 e5             	mov    %rsp,%rbp
  802804:	48 83 ec 30          	sub    $0x30,%rsp
  802808:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80280c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802810:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802814:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802819:	75 0e                	jne    802829 <ipc_recv+0x29>
		pg = (void*) UTOP;
  80281b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802822:	00 00 00 
  802825:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802829:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80282d:	48 89 c7             	mov    %rax,%rdi
  802830:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802843:	79 27                	jns    80286c <ipc_recv+0x6c>
		if (from_env_store)
  802845:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80284a:	74 0a                	je     802856 <ipc_recv+0x56>
			*from_env_store = 0;
  80284c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802850:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802856:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80285b:	74 0a                	je     802867 <ipc_recv+0x67>
			*perm_store = 0;
  80285d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802861:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286a:	eb 53                	jmp    8028bf <ipc_recv+0xbf>
	}
	if (from_env_store)
  80286c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802871:	74 19                	je     80288c <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  802873:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80287a:	00 00 00 
  80287d:	48 8b 00             	mov    (%rax),%rax
  802880:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288a:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80288c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802891:	74 19                	je     8028ac <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  802893:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80289a:	00 00 00 
  80289d:	48 8b 00             	mov    (%rax),%rax
  8028a0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8028a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028aa:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8028ac:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8028b3:	00 00 00 
  8028b6:	48 8b 00             	mov    (%rax),%rax
  8028b9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8028bf:	c9                   	leaveq 
  8028c0:	c3                   	retq   

00000000008028c1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028c1:	55                   	push   %rbp
  8028c2:	48 89 e5             	mov    %rsp,%rbp
  8028c5:	48 83 ec 30          	sub    $0x30,%rsp
  8028c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028cc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8028cf:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8028d3:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8028d6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028db:	75 1c                	jne    8028f9 <ipc_send+0x38>
		pg = (void*) UTOP;
  8028dd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028e4:	00 00 00 
  8028e7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8028eb:	eb 0c                	jmp    8028f9 <ipc_send+0x38>
		sys_yield();
  8028ed:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8028f9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8028fc:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8028ff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802903:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802906:	89 c7                	mov    %eax,%edi
  802908:	48 b8 e7 25 80 00 00 	movabs $0x8025e7,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
  802914:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802917:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80291b:	74 d0                	je     8028ed <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80291d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802921:	79 30                	jns    802953 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  802923:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802926:	89 c1                	mov    %eax,%ecx
  802928:	48 ba f3 55 80 00 00 	movabs $0x8055f3,%rdx
  80292f:	00 00 00 
  802932:	be 47 00 00 00       	mov    $0x47,%esi
  802937:	48 bf 09 56 80 00 00 	movabs $0x805609,%rdi
  80293e:	00 00 00 
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80294d:	00 00 00 
  802950:	41 ff d0             	callq  *%r8

}
  802953:	90                   	nop
  802954:	c9                   	leaveq 
  802955:	c3                   	retq   

0000000000802956 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	53                   	push   %rbx
  80295b:	48 83 ec 28          	sub    $0x28,%rsp
  80295f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  802963:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80296a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  802971:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802976:	75 0e                	jne    802986 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  802978:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80297f:	00 00 00 
  802982:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  802986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298a:	ba 07 00 00 00       	mov    $0x7,%edx
  80298f:	48 89 c6             	mov    %rax,%rsi
  802992:	bf 00 00 00 00       	mov    $0x0,%edi
  802997:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8029a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8029ab:	48 89 c2             	mov    %rax,%rdx
  8029ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029b5:	01 00 00 
  8029b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029bc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8029c2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  8029c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8029cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029cf:	48 89 d3             	mov    %rdx,%rbx
  8029d2:	0f 01 c1             	vmcall 
  8029d5:	89 f2                	mov    %esi,%edx
  8029d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029da:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  8029dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029e1:	79 05                	jns    8029e8 <ipc_host_recv+0x92>
		return r;
  8029e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029e6:	eb 03                	jmp    8029eb <ipc_host_recv+0x95>
	}
	return val;
  8029e8:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  8029eb:	48 83 c4 28          	add    $0x28,%rsp
  8029ef:	5b                   	pop    %rbx
  8029f0:	5d                   	pop    %rbp
  8029f1:	c3                   	retq   

00000000008029f2 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029f2:	55                   	push   %rbp
  8029f3:	48 89 e5             	mov    %rsp,%rbp
  8029f6:	53                   	push   %rbx
  8029f7:	48 83 ec 38          	sub    $0x38,%rsp
  8029fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029fe:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802a01:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802a05:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  802a08:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802a0f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802a14:	75 0e                	jne    802a24 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802a16:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802a1d:	00 00 00 
  802a20:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802a24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a28:	48 c1 e8 0c          	shr    $0xc,%rax
  802a2c:	48 89 c2             	mov    %rax,%rdx
  802a2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a36:	01 00 00 
  802a39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a3d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802a43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802a47:	b8 02 00 00 00       	mov    $0x2,%eax
  802a4c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802a4f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a56:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802a59:	89 fb                	mov    %edi,%ebx
  802a5b:	0f 01 c1             	vmcall 
  802a5e:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802a61:	eb 26                	jmp    802a89 <ipc_host_send+0x97>
		sys_yield();
  802a63:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802a6f:	b8 02 00 00 00       	mov    $0x2,%eax
  802a74:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802a77:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a7e:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802a81:	89 fb                	mov    %edi,%ebx
  802a83:	0f 01 c1             	vmcall 
  802a86:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802a89:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  802a8d:	74 d4                	je     802a63 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  802a8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a93:	79 30                	jns    802ac5 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  802a95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a98:	89 c1                	mov    %eax,%ecx
  802a9a:	48 ba f3 55 80 00 00 	movabs $0x8055f3,%rdx
  802aa1:	00 00 00 
  802aa4:	be 79 00 00 00       	mov    $0x79,%esi
  802aa9:	48 bf 09 56 80 00 00 	movabs $0x805609,%rdi
  802ab0:	00 00 00 
  802ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab8:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  802abf:	00 00 00 
  802ac2:	41 ff d0             	callq  *%r8

}
  802ac5:	90                   	nop
  802ac6:	48 83 c4 38          	add    $0x38,%rsp
  802aca:	5b                   	pop    %rbx
  802acb:	5d                   	pop    %rbp
  802acc:	c3                   	retq   

0000000000802acd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802acd:	55                   	push   %rbp
  802ace:	48 89 e5             	mov    %rsp,%rbp
  802ad1:	48 83 ec 18          	sub    $0x18,%rsp
  802ad5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802adf:	eb 4d                	jmp    802b2e <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  802ae1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802ae8:	00 00 00 
  802aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aee:	48 98                	cltq   
  802af0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802af7:	48 01 d0             	add    %rdx,%rax
  802afa:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802b00:	8b 00                	mov    (%rax),%eax
  802b02:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b05:	75 23                	jne    802b2a <ipc_find_env+0x5d>
			return envs[i].env_id;
  802b07:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802b0e:	00 00 00 
  802b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b14:	48 98                	cltq   
  802b16:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802b1d:	48 01 d0             	add    %rdx,%rax
  802b20:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802b26:	8b 00                	mov    (%rax),%eax
  802b28:	eb 12                	jmp    802b3c <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802b2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b2e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802b35:	7e aa                	jle    802ae1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3c:	c9                   	leaveq 
  802b3d:	c3                   	retq   

0000000000802b3e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802b3e:	55                   	push   %rbp
  802b3f:	48 89 e5             	mov    %rsp,%rbp
  802b42:	48 83 ec 08          	sub    $0x8,%rsp
  802b46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b4a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b4e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802b55:	ff ff ff 
  802b58:	48 01 d0             	add    %rdx,%rax
  802b5b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802b5f:	c9                   	leaveq 
  802b60:	c3                   	retq   

0000000000802b61 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	48 83 ec 08          	sub    $0x8,%rsp
  802b69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802b6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b71:	48 89 c7             	mov    %rax,%rdi
  802b74:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	callq  *%rax
  802b80:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802b86:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802b8a:	c9                   	leaveq 
  802b8b:	c3                   	retq   

0000000000802b8c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b8c:	55                   	push   %rbp
  802b8d:	48 89 e5             	mov    %rsp,%rbp
  802b90:	48 83 ec 18          	sub    $0x18,%rsp
  802b94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b9f:	eb 6b                	jmp    802c0c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba4:	48 98                	cltq   
  802ba6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bac:	48 c1 e0 0c          	shl    $0xc,%rax
  802bb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb8:	48 c1 e8 15          	shr    $0x15,%rax
  802bbc:	48 89 c2             	mov    %rax,%rdx
  802bbf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bc6:	01 00 00 
  802bc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bcd:	83 e0 01             	and    $0x1,%eax
  802bd0:	48 85 c0             	test   %rax,%rax
  802bd3:	74 21                	je     802bf6 <fd_alloc+0x6a>
  802bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd9:	48 c1 e8 0c          	shr    $0xc,%rax
  802bdd:	48 89 c2             	mov    %rax,%rdx
  802be0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802be7:	01 00 00 
  802bea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bee:	83 e0 01             	and    $0x1,%eax
  802bf1:	48 85 c0             	test   %rax,%rax
  802bf4:	75 12                	jne    802c08 <fd_alloc+0x7c>
			*fd_store = fd;
  802bf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bfe:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
  802c06:	eb 1a                	jmp    802c22 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802c08:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c0c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c10:	7e 8f                	jle    802ba1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c16:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802c1d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802c22:	c9                   	leaveq 
  802c23:	c3                   	retq   

0000000000802c24 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802c24:	55                   	push   %rbp
  802c25:	48 89 e5             	mov    %rsp,%rbp
  802c28:	48 83 ec 20          	sub    $0x20,%rsp
  802c2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802c33:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c37:	78 06                	js     802c3f <fd_lookup+0x1b>
  802c39:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802c3d:	7e 07                	jle    802c46 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c44:	eb 6c                	jmp    802cb2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802c46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c49:	48 98                	cltq   
  802c4b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c51:	48 c1 e0 0c          	shl    $0xc,%rax
  802c55:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802c59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5d:	48 c1 e8 15          	shr    $0x15,%rax
  802c61:	48 89 c2             	mov    %rax,%rdx
  802c64:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c6b:	01 00 00 
  802c6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c72:	83 e0 01             	and    $0x1,%eax
  802c75:	48 85 c0             	test   %rax,%rax
  802c78:	74 21                	je     802c9b <fd_lookup+0x77>
  802c7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c7e:	48 c1 e8 0c          	shr    $0xc,%rax
  802c82:	48 89 c2             	mov    %rax,%rdx
  802c85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c8c:	01 00 00 
  802c8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c93:	83 e0 01             	and    $0x1,%eax
  802c96:	48 85 c0             	test   %rax,%rax
  802c99:	75 07                	jne    802ca2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ca0:	eb 10                	jmp    802cb2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802ca2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802caa:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb2:	c9                   	leaveq 
  802cb3:	c3                   	retq   

0000000000802cb4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802cb4:	55                   	push   %rbp
  802cb5:	48 89 e5             	mov    %rsp,%rbp
  802cb8:	48 83 ec 30          	sub    $0x30,%rsp
  802cbc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cc0:	89 f0                	mov    %esi,%eax
  802cc2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802cc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc9:	48 89 c7             	mov    %rax,%rdi
  802ccc:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 c2                	mov    %eax,%edx
  802cda:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802cde:	48 89 c6             	mov    %rax,%rsi
  802ce1:	89 d7                	mov    %edx,%edi
  802ce3:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf6:	78 0a                	js     802d02 <fd_close+0x4e>
	    || fd != fd2)
  802cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802d00:	74 12                	je     802d14 <fd_close+0x60>
		return (must_exist ? r : 0);
  802d02:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802d06:	74 05                	je     802d0d <fd_close+0x59>
  802d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0b:	eb 70                	jmp    802d7d <fd_close+0xc9>
  802d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d12:	eb 69                	jmp    802d7d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802d14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d18:	8b 00                	mov    (%rax),%eax
  802d1a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d1e:	48 89 d6             	mov    %rdx,%rsi
  802d21:	89 c7                	mov    %eax,%edi
  802d23:	48 b8 7f 2d 80 00 00 	movabs $0x802d7f,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	callq  *%rax
  802d2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d36:	78 2a                	js     802d62 <fd_close+0xae>
		if (dev->dev_close)
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d40:	48 85 c0             	test   %rax,%rax
  802d43:	74 16                	je     802d5b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802d45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d49:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d4d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d51:	48 89 d7             	mov    %rdx,%rdi
  802d54:	ff d0                	callq  *%rax
  802d56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d59:	eb 07                	jmp    802d62 <fd_close+0xae>
		else
			r = 0;
  802d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802d62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d66:	48 89 c6             	mov    %rax,%rsi
  802d69:	bf 00 00 00 00       	mov    $0x0,%edi
  802d6e:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	callq  *%rax
	return r;
  802d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d7d:	c9                   	leaveq 
  802d7e:	c3                   	retq   

0000000000802d7f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d7f:	55                   	push   %rbp
  802d80:	48 89 e5             	mov    %rsp,%rbp
  802d83:	48 83 ec 20          	sub    $0x20,%rsp
  802d87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d95:	eb 41                	jmp    802dd8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802d97:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d9e:	00 00 00 
  802da1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802da4:	48 63 d2             	movslq %edx,%rdx
  802da7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dab:	8b 00                	mov    (%rax),%eax
  802dad:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802db0:	75 22                	jne    802dd4 <dev_lookup+0x55>
			*dev = devtab[i];
  802db2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802db9:	00 00 00 
  802dbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802dbf:	48 63 d2             	movslq %edx,%rdx
  802dc2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802dc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dca:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd2:	eb 60                	jmp    802e34 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802dd4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802dd8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802ddf:	00 00 00 
  802de2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802de5:	48 63 d2             	movslq %edx,%rdx
  802de8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dec:	48 85 c0             	test   %rax,%rax
  802def:	75 a6                	jne    802d97 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802df1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802df8:	00 00 00 
  802dfb:	48 8b 00             	mov    (%rax),%rax
  802dfe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e04:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e07:	89 c6                	mov    %eax,%esi
  802e09:	48 bf 18 56 80 00 00 	movabs $0x805618,%rdi
  802e10:	00 00 00 
  802e13:	b8 00 00 00 00       	mov    $0x0,%eax
  802e18:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  802e1f:	00 00 00 
  802e22:	ff d1                	callq  *%rcx
	*dev = 0;
  802e24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e28:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802e2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802e34:	c9                   	leaveq 
  802e35:	c3                   	retq   

0000000000802e36 <close>:

int
close(int fdnum)
{
  802e36:	55                   	push   %rbp
  802e37:	48 89 e5             	mov    %rsp,%rbp
  802e3a:	48 83 ec 20          	sub    $0x20,%rsp
  802e3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e41:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e48:	48 89 d6             	mov    %rdx,%rsi
  802e4b:	89 c7                	mov    %eax,%edi
  802e4d:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
  802e59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e60:	79 05                	jns    802e67 <close+0x31>
		return r;
  802e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e65:	eb 18                	jmp    802e7f <close+0x49>
	else
		return fd_close(fd, 1);
  802e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6b:	be 01 00 00 00       	mov    $0x1,%esi
  802e70:	48 89 c7             	mov    %rax,%rdi
  802e73:	48 b8 b4 2c 80 00 00 	movabs $0x802cb4,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
}
  802e7f:	c9                   	leaveq 
  802e80:	c3                   	retq   

0000000000802e81 <close_all>:

void
close_all(void)
{
  802e81:	55                   	push   %rbp
  802e82:	48 89 e5             	mov    %rsp,%rbp
  802e85:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e90:	eb 15                	jmp    802ea7 <close_all+0x26>
		close(i);
  802e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e95:	89 c7                	mov    %eax,%edi
  802e97:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802ea3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ea7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802eab:	7e e5                	jle    802e92 <close_all+0x11>
		close(i);
}
  802ead:	90                   	nop
  802eae:	c9                   	leaveq 
  802eaf:	c3                   	retq   

0000000000802eb0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802eb0:	55                   	push   %rbp
  802eb1:	48 89 e5             	mov    %rsp,%rbp
  802eb4:	48 83 ec 40          	sub    $0x40,%rsp
  802eb8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802ebb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ebe:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802ec2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802ec5:	48 89 d6             	mov    %rdx,%rsi
  802ec8:	89 c7                	mov    %eax,%edi
  802eca:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  802ed1:	00 00 00 
  802ed4:	ff d0                	callq  *%rax
  802ed6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edd:	79 08                	jns    802ee7 <dup+0x37>
		return r;
  802edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee2:	e9 70 01 00 00       	jmpq   803057 <dup+0x1a7>
	close(newfdnum);
  802ee7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802eea:	89 c7                	mov    %eax,%edi
  802eec:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802ef8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802efb:	48 98                	cltq   
  802efd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802f03:	48 c1 e0 0c          	shl    $0xc,%rax
  802f07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802f0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0f:	48 89 c7             	mov    %rax,%rdi
  802f12:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
  802f1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f26:	48 89 c7             	mov    %rax,%rdi
  802f29:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
  802f35:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3d:	48 c1 e8 15          	shr    $0x15,%rax
  802f41:	48 89 c2             	mov    %rax,%rdx
  802f44:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802f4b:	01 00 00 
  802f4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f52:	83 e0 01             	and    $0x1,%eax
  802f55:	48 85 c0             	test   %rax,%rax
  802f58:	74 71                	je     802fcb <dup+0x11b>
  802f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5e:	48 c1 e8 0c          	shr    $0xc,%rax
  802f62:	48 89 c2             	mov    %rax,%rdx
  802f65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f6c:	01 00 00 
  802f6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f73:	83 e0 01             	and    $0x1,%eax
  802f76:	48 85 c0             	test   %rax,%rax
  802f79:	74 50                	je     802fcb <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7f:	48 c1 e8 0c          	shr    $0xc,%rax
  802f83:	48 89 c2             	mov    %rax,%rdx
  802f86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f8d:	01 00 00 
  802f90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f94:	25 07 0e 00 00       	and    $0xe07,%eax
  802f99:	89 c1                	mov    %eax,%ecx
  802f9b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa3:	41 89 c8             	mov    %ecx,%r8d
  802fa6:	48 89 d1             	mov    %rdx,%rcx
  802fa9:	ba 00 00 00 00       	mov    $0x0,%edx
  802fae:	48 89 c6             	mov    %rax,%rsi
  802fb1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb6:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  802fbd:	00 00 00 
  802fc0:	ff d0                	callq  *%rax
  802fc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc9:	78 55                	js     803020 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcf:	48 c1 e8 0c          	shr    $0xc,%rax
  802fd3:	48 89 c2             	mov    %rax,%rdx
  802fd6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802fdd:	01 00 00 
  802fe0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fe4:	25 07 0e 00 00       	and    $0xe07,%eax
  802fe9:	89 c1                	mov    %eax,%ecx
  802feb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ff3:	41 89 c8             	mov    %ecx,%r8d
  802ff6:	48 89 d1             	mov    %rdx,%rcx
  802ff9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffe:	48 89 c6             	mov    %rax,%rsi
  803001:	bf 00 00 00 00       	mov    $0x0,%edi
  803006:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803015:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803019:	78 08                	js     803023 <dup+0x173>
		goto err;

	return newfdnum;
  80301b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80301e:	eb 37                	jmp    803057 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803020:	90                   	nop
  803021:	eb 01                	jmp    803024 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803023:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803028:	48 89 c6             	mov    %rax,%rsi
  80302b:	bf 00 00 00 00       	mov    $0x0,%edi
  803030:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  803037:	00 00 00 
  80303a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80303c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803040:	48 89 c6             	mov    %rax,%rsi
  803043:	bf 00 00 00 00       	mov    $0x0,%edi
  803048:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  80304f:	00 00 00 
  803052:	ff d0                	callq  *%rax
	return r;
  803054:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803057:	c9                   	leaveq 
  803058:	c3                   	retq   

0000000000803059 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803059:	55                   	push   %rbp
  80305a:	48 89 e5             	mov    %rsp,%rbp
  80305d:	48 83 ec 40          	sub    $0x40,%rsp
  803061:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803064:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803068:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80306c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803070:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803073:	48 89 d6             	mov    %rdx,%rsi
  803076:	89 c7                	mov    %eax,%edi
  803078:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
  803084:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803087:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308b:	78 24                	js     8030b1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80308d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803091:	8b 00                	mov    (%rax),%eax
  803093:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803097:	48 89 d6             	mov    %rdx,%rsi
  80309a:	89 c7                	mov    %eax,%edi
  80309c:	48 b8 7f 2d 80 00 00 	movabs $0x802d7f,%rax
  8030a3:	00 00 00 
  8030a6:	ff d0                	callq  *%rax
  8030a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030af:	79 05                	jns    8030b6 <read+0x5d>
		return r;
  8030b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b4:	eb 76                	jmp    80312c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8030b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ba:	8b 40 08             	mov    0x8(%rax),%eax
  8030bd:	83 e0 03             	and    $0x3,%eax
  8030c0:	83 f8 01             	cmp    $0x1,%eax
  8030c3:	75 3a                	jne    8030ff <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8030c5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8030cc:	00 00 00 
  8030cf:	48 8b 00             	mov    (%rax),%rax
  8030d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030db:	89 c6                	mov    %eax,%esi
  8030dd:	48 bf 37 56 80 00 00 	movabs $0x805637,%rdi
  8030e4:	00 00 00 
  8030e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ec:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  8030f3:	00 00 00 
  8030f6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030fd:	eb 2d                	jmp    80312c <read+0xd3>
	}
	if (!dev->dev_read)
  8030ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803103:	48 8b 40 10          	mov    0x10(%rax),%rax
  803107:	48 85 c0             	test   %rax,%rax
  80310a:	75 07                	jne    803113 <read+0xba>
		return -E_NOT_SUPP;
  80310c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803111:	eb 19                	jmp    80312c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803117:	48 8b 40 10          	mov    0x10(%rax),%rax
  80311b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80311f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803123:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803127:	48 89 cf             	mov    %rcx,%rdi
  80312a:	ff d0                	callq  *%rax
}
  80312c:	c9                   	leaveq 
  80312d:	c3                   	retq   

000000000080312e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80312e:	55                   	push   %rbp
  80312f:	48 89 e5             	mov    %rsp,%rbp
  803132:	48 83 ec 30          	sub    $0x30,%rsp
  803136:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803139:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80313d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803148:	eb 47                	jmp    803191 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80314a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314d:	48 98                	cltq   
  80314f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803153:	48 29 c2             	sub    %rax,%rdx
  803156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803159:	48 63 c8             	movslq %eax,%rcx
  80315c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803160:	48 01 c1             	add    %rax,%rcx
  803163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803166:	48 89 ce             	mov    %rcx,%rsi
  803169:	89 c7                	mov    %eax,%edi
  80316b:	48 b8 59 30 80 00 00 	movabs $0x803059,%rax
  803172:	00 00 00 
  803175:	ff d0                	callq  *%rax
  803177:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80317a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80317e:	79 05                	jns    803185 <readn+0x57>
			return m;
  803180:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803183:	eb 1d                	jmp    8031a2 <readn+0x74>
		if (m == 0)
  803185:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803189:	74 13                	je     80319e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80318b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80318e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803194:	48 98                	cltq   
  803196:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80319a:	72 ae                	jb     80314a <readn+0x1c>
  80319c:	eb 01                	jmp    80319f <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80319e:	90                   	nop
	}
	return tot;
  80319f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031a2:	c9                   	leaveq 
  8031a3:	c3                   	retq   

00000000008031a4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8031a4:	55                   	push   %rbp
  8031a5:	48 89 e5             	mov    %rsp,%rbp
  8031a8:	48 83 ec 40          	sub    $0x40,%rsp
  8031ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031be:	48 89 d6             	mov    %rdx,%rsi
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	callq  *%rax
  8031cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d6:	78 24                	js     8031fc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031dc:	8b 00                	mov    (%rax),%eax
  8031de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e2:	48 89 d6             	mov    %rdx,%rsi
  8031e5:	89 c7                	mov    %eax,%edi
  8031e7:	48 b8 7f 2d 80 00 00 	movabs $0x802d7f,%rax
  8031ee:	00 00 00 
  8031f1:	ff d0                	callq  *%rax
  8031f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fa:	79 05                	jns    803201 <write+0x5d>
		return r;
  8031fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ff:	eb 75                	jmp    803276 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803205:	8b 40 08             	mov    0x8(%rax),%eax
  803208:	83 e0 03             	and    $0x3,%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	75 3a                	jne    803249 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80320f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803216:	00 00 00 
  803219:	48 8b 00             	mov    (%rax),%rax
  80321c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803222:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803225:	89 c6                	mov    %eax,%esi
  803227:	48 bf 53 56 80 00 00 	movabs $0x805653,%rdi
  80322e:	00 00 00 
  803231:	b8 00 00 00 00       	mov    $0x0,%eax
  803236:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  80323d:	00 00 00 
  803240:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803242:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803247:	eb 2d                	jmp    803276 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803251:	48 85 c0             	test   %rax,%rax
  803254:	75 07                	jne    80325d <write+0xb9>
		return -E_NOT_SUPP;
  803256:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80325b:	eb 19                	jmp    803276 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80325d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803261:	48 8b 40 18          	mov    0x18(%rax),%rax
  803265:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803269:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80326d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803271:	48 89 cf             	mov    %rcx,%rdi
  803274:	ff d0                	callq  *%rax
}
  803276:	c9                   	leaveq 
  803277:	c3                   	retq   

0000000000803278 <seek>:

int
seek(int fdnum, off_t offset)
{
  803278:	55                   	push   %rbp
  803279:	48 89 e5             	mov    %rsp,%rbp
  80327c:	48 83 ec 18          	sub    $0x18,%rsp
  803280:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803283:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803286:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80328a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80328d:	48 89 d6             	mov    %rdx,%rsi
  803290:	89 c7                	mov    %eax,%edi
  803292:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
  80329e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a5:	79 05                	jns    8032ac <seek+0x34>
		return r;
  8032a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032aa:	eb 0f                	jmp    8032bb <seek+0x43>
	fd->fd_offset = offset;
  8032ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032b3:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8032b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032bb:	c9                   	leaveq 
  8032bc:	c3                   	retq   

00000000008032bd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8032bd:	55                   	push   %rbp
  8032be:	48 89 e5             	mov    %rsp,%rbp
  8032c1:	48 83 ec 30          	sub    $0x30,%rsp
  8032c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032c8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032d2:	48 89 d6             	mov    %rdx,%rsi
  8032d5:	89 c7                	mov    %eax,%edi
  8032d7:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ea:	78 24                	js     803310 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f0:	8b 00                	mov    (%rax),%eax
  8032f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032f6:	48 89 d6             	mov    %rdx,%rsi
  8032f9:	89 c7                	mov    %eax,%edi
  8032fb:	48 b8 7f 2d 80 00 00 	movabs $0x802d7f,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
  803307:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330e:	79 05                	jns    803315 <ftruncate+0x58>
		return r;
  803310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803313:	eb 72                	jmp    803387 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803319:	8b 40 08             	mov    0x8(%rax),%eax
  80331c:	83 e0 03             	and    $0x3,%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	75 3a                	jne    80335d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803323:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80332a:	00 00 00 
  80332d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803330:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803336:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803339:	89 c6                	mov    %eax,%esi
  80333b:	48 bf 70 56 80 00 00 	movabs $0x805670,%rdi
  803342:	00 00 00 
  803345:	b8 00 00 00 00       	mov    $0x0,%eax
  80334a:	48 b9 3e 0f 80 00 00 	movabs $0x800f3e,%rcx
  803351:	00 00 00 
  803354:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803356:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80335b:	eb 2a                	jmp    803387 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80335d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803361:	48 8b 40 30          	mov    0x30(%rax),%rax
  803365:	48 85 c0             	test   %rax,%rax
  803368:	75 07                	jne    803371 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80336a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80336f:	eb 16                	jmp    803387 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803375:	48 8b 40 30          	mov    0x30(%rax),%rax
  803379:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80337d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803380:	89 ce                	mov    %ecx,%esi
  803382:	48 89 d7             	mov    %rdx,%rdi
  803385:	ff d0                	callq  *%rax
}
  803387:	c9                   	leaveq 
  803388:	c3                   	retq   

0000000000803389 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803389:	55                   	push   %rbp
  80338a:	48 89 e5             	mov    %rsp,%rbp
  80338d:	48 83 ec 30          	sub    $0x30,%rsp
  803391:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803394:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803398:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80339c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80339f:	48 89 d6             	mov    %rdx,%rsi
  8033a2:	89 c7                	mov    %eax,%edi
  8033a4:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  8033ab:	00 00 00 
  8033ae:	ff d0                	callq  *%rax
  8033b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b7:	78 24                	js     8033dd <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bd:	8b 00                	mov    (%rax),%eax
  8033bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033c3:	48 89 d6             	mov    %rdx,%rsi
  8033c6:	89 c7                	mov    %eax,%edi
  8033c8:	48 b8 7f 2d 80 00 00 	movabs $0x802d7f,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033db:	79 05                	jns    8033e2 <fstat+0x59>
		return r;
  8033dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e0:	eb 5e                	jmp    803440 <fstat+0xb7>
	if (!dev->dev_stat)
  8033e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8033ea:	48 85 c0             	test   %rax,%rax
  8033ed:	75 07                	jne    8033f6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8033ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033f4:	eb 4a                	jmp    803440 <fstat+0xb7>
	stat->st_name[0] = 0;
  8033f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fa:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8033fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803401:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803408:	00 00 00 
	stat->st_isdir = 0;
  80340b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80340f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803416:	00 00 00 
	stat->st_dev = dev;
  803419:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80341d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803421:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342c:	48 8b 40 28          	mov    0x28(%rax),%rax
  803430:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803434:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803438:	48 89 ce             	mov    %rcx,%rsi
  80343b:	48 89 d7             	mov    %rdx,%rdi
  80343e:	ff d0                	callq  *%rax
}
  803440:	c9                   	leaveq 
  803441:	c3                   	retq   

0000000000803442 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803442:	55                   	push   %rbp
  803443:	48 89 e5             	mov    %rsp,%rbp
  803446:	48 83 ec 20          	sub    $0x20,%rsp
  80344a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80344e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803456:	be 00 00 00 00       	mov    $0x0,%esi
  80345b:	48 89 c7             	mov    %rax,%rdi
  80345e:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  803465:	00 00 00 
  803468:	ff d0                	callq  *%rax
  80346a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803471:	79 05                	jns    803478 <stat+0x36>
		return fd;
  803473:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803476:	eb 2f                	jmp    8034a7 <stat+0x65>
	r = fstat(fd, stat);
  803478:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80347c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347f:	48 89 d6             	mov    %rdx,%rsi
  803482:	89 c7                	mov    %eax,%edi
  803484:	48 b8 89 33 80 00 00 	movabs $0x803389,%rax
  80348b:	00 00 00 
  80348e:	ff d0                	callq  *%rax
  803490:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803496:	89 c7                	mov    %eax,%edi
  803498:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
	return r;
  8034a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8034a7:	c9                   	leaveq 
  8034a8:	c3                   	retq   

00000000008034a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8034a9:	55                   	push   %rbp
  8034aa:	48 89 e5             	mov    %rsp,%rbp
  8034ad:	48 83 ec 10          	sub    $0x10,%rsp
  8034b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8034b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034bf:	00 00 00 
  8034c2:	8b 00                	mov    (%rax),%eax
  8034c4:	85 c0                	test   %eax,%eax
  8034c6:	75 1f                	jne    8034e7 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8034c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8034cd:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	89 c2                	mov    %eax,%edx
  8034db:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034e2:	00 00 00 
  8034e5:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8034e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034ee:	00 00 00 
  8034f1:	8b 00                	mov    (%rax),%eax
  8034f3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034f6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034fb:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803502:	00 00 00 
  803505:	89 c7                	mov    %eax,%edi
  803507:	48 b8 c1 28 80 00 00 	movabs $0x8028c1,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803517:	ba 00 00 00 00       	mov    $0x0,%edx
  80351c:	48 89 c6             	mov    %rax,%rsi
  80351f:	bf 00 00 00 00       	mov    $0x0,%edi
  803524:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
}
  803530:	c9                   	leaveq 
  803531:	c3                   	retq   

0000000000803532 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803532:	55                   	push   %rbp
  803533:	48 89 e5             	mov    %rsp,%rbp
  803536:	48 83 ec 20          	sub    $0x20,%rsp
  80353a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80353e:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803545:	48 89 c7             	mov    %rax,%rdi
  803548:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80354f:	00 00 00 
  803552:	ff d0                	callq  *%rax
  803554:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803559:	7e 0a                	jle    803565 <open+0x33>
		return -E_BAD_PATH;
  80355b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803560:	e9 a5 00 00 00       	jmpq   80360a <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803565:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803569:	48 89 c7             	mov    %rax,%rdi
  80356c:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
  803578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357f:	79 08                	jns    803589 <open+0x57>
		return r;
  803581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803584:	e9 81 00 00 00       	jmpq   80360a <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358d:	48 89 c6             	mov    %rax,%rsi
  803590:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803597:	00 00 00 
  80359a:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8035a6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ad:	00 00 00 
  8035b0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035b3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8035b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bd:	48 89 c6             	mov    %rax,%rsi
  8035c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8035c5:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
  8035d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d8:	79 1d                	jns    8035f7 <open+0xc5>
		fd_close(fd, 0);
  8035da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035de:	be 00 00 00 00       	mov    $0x0,%esi
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 b4 2c 80 00 00 	movabs $0x802cb4,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
		return r;
  8035f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f5:	eb 13                	jmp    80360a <open+0xd8>
	}

	return fd2num(fd);
  8035f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fb:	48 89 c7             	mov    %rax,%rdi
  8035fe:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax

}
  80360a:	c9                   	leaveq 
  80360b:	c3                   	retq   

000000000080360c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80360c:	55                   	push   %rbp
  80360d:	48 89 e5             	mov    %rsp,%rbp
  803610:	48 83 ec 10          	sub    $0x10,%rsp
  803614:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361c:	8b 50 0c             	mov    0xc(%rax),%edx
  80361f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803626:	00 00 00 
  803629:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80362b:	be 00 00 00 00       	mov    $0x0,%esi
  803630:	bf 06 00 00 00       	mov    $0x6,%edi
  803635:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
}
  803641:	c9                   	leaveq 
  803642:	c3                   	retq   

0000000000803643 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803643:	55                   	push   %rbp
  803644:	48 89 e5             	mov    %rsp,%rbp
  803647:	48 83 ec 30          	sub    $0x30,%rsp
  80364b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80364f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803653:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365b:	8b 50 0c             	mov    0xc(%rax),%edx
  80365e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803665:	00 00 00 
  803668:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80366a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803671:	00 00 00 
  803674:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803678:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80367c:	be 00 00 00 00       	mov    $0x0,%esi
  803681:	bf 03 00 00 00       	mov    $0x3,%edi
  803686:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803695:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803699:	79 08                	jns    8036a3 <devfile_read+0x60>
		return r;
  80369b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369e:	e9 a4 00 00 00       	jmpq   803747 <devfile_read+0x104>
	assert(r <= n);
  8036a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a6:	48 98                	cltq   
  8036a8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8036ac:	76 35                	jbe    8036e3 <devfile_read+0xa0>
  8036ae:	48 b9 96 56 80 00 00 	movabs $0x805696,%rcx
  8036b5:	00 00 00 
  8036b8:	48 ba 9d 56 80 00 00 	movabs $0x80569d,%rdx
  8036bf:	00 00 00 
  8036c2:	be 86 00 00 00       	mov    $0x86,%esi
  8036c7:	48 bf b2 56 80 00 00 	movabs $0x8056b2,%rdi
  8036ce:	00 00 00 
  8036d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d6:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8036dd:	00 00 00 
  8036e0:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8036e3:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8036ea:	7e 35                	jle    803721 <devfile_read+0xde>
  8036ec:	48 b9 bd 56 80 00 00 	movabs $0x8056bd,%rcx
  8036f3:	00 00 00 
  8036f6:	48 ba 9d 56 80 00 00 	movabs $0x80569d,%rdx
  8036fd:	00 00 00 
  803700:	be 87 00 00 00       	mov    $0x87,%esi
  803705:	48 bf b2 56 80 00 00 	movabs $0x8056b2,%rdi
  80370c:	00 00 00 
  80370f:	b8 00 00 00 00       	mov    $0x0,%eax
  803714:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  80371b:	00 00 00 
  80371e:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803724:	48 63 d0             	movslq %eax,%rdx
  803727:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372b:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803732:	00 00 00 
  803735:	48 89 c7             	mov    %rax,%rdi
  803738:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80373f:	00 00 00 
  803742:	ff d0                	callq  *%rax
	return r;
  803744:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803747:	c9                   	leaveq 
  803748:	c3                   	retq   

0000000000803749 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803749:	55                   	push   %rbp
  80374a:	48 89 e5             	mov    %rsp,%rbp
  80374d:	48 83 ec 40          	sub    $0x40,%rsp
  803751:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803755:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803759:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80375d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803761:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803765:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80376c:	00 
  80376d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803771:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803775:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80377a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80377e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803782:	8b 50 0c             	mov    0xc(%rax),%edx
  803785:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80378c:	00 00 00 
  80378f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803791:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803798:	00 00 00 
  80379b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80379f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8037a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8037a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ab:	48 89 c6             	mov    %rax,%rsi
  8037ae:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8037b5:	00 00 00 
  8037b8:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8037c4:	be 00 00 00 00       	mov    $0x0,%esi
  8037c9:	bf 04 00 00 00       	mov    $0x4,%edi
  8037ce:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  8037d5:	00 00 00 
  8037d8:	ff d0                	callq  *%rax
  8037da:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037e1:	79 05                	jns    8037e8 <devfile_write+0x9f>
		return r;
  8037e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037e6:	eb 43                	jmp    80382b <devfile_write+0xe2>
	assert(r <= n);
  8037e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037eb:	48 98                	cltq   
  8037ed:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037f1:	76 35                	jbe    803828 <devfile_write+0xdf>
  8037f3:	48 b9 96 56 80 00 00 	movabs $0x805696,%rcx
  8037fa:	00 00 00 
  8037fd:	48 ba 9d 56 80 00 00 	movabs $0x80569d,%rdx
  803804:	00 00 00 
  803807:	be a2 00 00 00       	mov    $0xa2,%esi
  80380c:	48 bf b2 56 80 00 00 	movabs $0x8056b2,%rdi
  803813:	00 00 00 
  803816:	b8 00 00 00 00       	mov    $0x0,%eax
  80381b:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  803822:	00 00 00 
  803825:	41 ff d0             	callq  *%r8
	return r;
  803828:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80382b:	c9                   	leaveq 
  80382c:	c3                   	retq   

000000000080382d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80382d:	55                   	push   %rbp
  80382e:	48 89 e5             	mov    %rsp,%rbp
  803831:	48 83 ec 20          	sub    $0x20,%rsp
  803835:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803839:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80383d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803841:	8b 50 0c             	mov    0xc(%rax),%edx
  803844:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80384b:	00 00 00 
  80384e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803850:	be 00 00 00 00       	mov    $0x0,%esi
  803855:	bf 05 00 00 00       	mov    $0x5,%edi
  80385a:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
  803866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386d:	79 05                	jns    803874 <devfile_stat+0x47>
		return r;
  80386f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803872:	eb 56                	jmp    8038ca <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803874:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803878:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80387f:	00 00 00 
  803882:	48 89 c7             	mov    %rax,%rdi
  803885:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  80388c:	00 00 00 
  80388f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803891:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803898:	00 00 00 
  80389b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8038a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8038ab:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038b2:	00 00 00 
  8038b5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8038bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038bf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8038c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 10          	sub    $0x10,%rsp
  8038d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8038db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038df:	8b 50 0c             	mov    0xc(%rax),%edx
  8038e2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038e9:	00 00 00 
  8038ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8038ee:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038f5:	00 00 00 
  8038f8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038fb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8038fe:	be 00 00 00 00       	mov    $0x0,%esi
  803903:	bf 02 00 00 00       	mov    $0x2,%edi
  803908:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  80390f:	00 00 00 
  803912:	ff d0                	callq  *%rax
}
  803914:	c9                   	leaveq 
  803915:	c3                   	retq   

0000000000803916 <remove>:

// Delete a file
int
remove(const char *path)
{
  803916:	55                   	push   %rbp
  803917:	48 89 e5             	mov    %rsp,%rbp
  80391a:	48 83 ec 10          	sub    $0x10,%rsp
  80391e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803926:	48 89 c7             	mov    %rax,%rdi
  803929:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803930:	00 00 00 
  803933:	ff d0                	callq  *%rax
  803935:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80393a:	7e 07                	jle    803943 <remove+0x2d>
		return -E_BAD_PATH;
  80393c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803941:	eb 33                	jmp    803976 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803947:	48 89 c6             	mov    %rax,%rsi
  80394a:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803951:	00 00 00 
  803954:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803960:	be 00 00 00 00       	mov    $0x0,%esi
  803965:	bf 07 00 00 00       	mov    $0x7,%edi
  80396a:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  803971:	00 00 00 
  803974:	ff d0                	callq  *%rax
}
  803976:	c9                   	leaveq 
  803977:	c3                   	retq   

0000000000803978 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803978:	55                   	push   %rbp
  803979:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80397c:	be 00 00 00 00       	mov    $0x0,%esi
  803981:	bf 08 00 00 00       	mov    $0x8,%edi
  803986:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
}
  803992:	5d                   	pop    %rbp
  803993:	c3                   	retq   

0000000000803994 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803994:	55                   	push   %rbp
  803995:	48 89 e5             	mov    %rsp,%rbp
  803998:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80399f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8039a6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8039ad:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8039b4:	be 00 00 00 00       	mov    $0x0,%esi
  8039b9:	48 89 c7             	mov    %rax,%rdi
  8039bc:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  8039c3:	00 00 00 
  8039c6:	ff d0                	callq  *%rax
  8039c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8039cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cf:	79 28                	jns    8039f9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8039d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d4:	89 c6                	mov    %eax,%esi
  8039d6:	48 bf c9 56 80 00 00 	movabs $0x8056c9,%rdi
  8039dd:	00 00 00 
  8039e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e5:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  8039ec:	00 00 00 
  8039ef:	ff d2                	callq  *%rdx
		return fd_src;
  8039f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f4:	e9 76 01 00 00       	jmpq   803b6f <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8039f9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803a00:	be 01 01 00 00       	mov    $0x101,%esi
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
  803a14:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803a17:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a1b:	0f 89 ad 00 00 00    	jns    803ace <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803a21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a24:	89 c6                	mov    %eax,%esi
  803a26:	48 bf df 56 80 00 00 	movabs $0x8056df,%rdi
  803a2d:	00 00 00 
  803a30:	b8 00 00 00 00       	mov    $0x0,%eax
  803a35:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  803a3c:	00 00 00 
  803a3f:	ff d2                	callq  *%rdx
		close(fd_src);
  803a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a44:	89 c7                	mov    %eax,%edi
  803a46:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
		return fd_dest;
  803a52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a55:	e9 15 01 00 00       	jmpq   803b6f <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803a5a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a5d:	48 63 d0             	movslq %eax,%rdx
  803a60:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6a:	48 89 ce             	mov    %rcx,%rsi
  803a6d:	89 c7                	mov    %eax,%edi
  803a6f:	48 b8 a4 31 80 00 00 	movabs $0x8031a4,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
  803a7b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803a82:	79 4a                	jns    803ace <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803a84:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a87:	89 c6                	mov    %eax,%esi
  803a89:	48 bf f9 56 80 00 00 	movabs $0x8056f9,%rdi
  803a90:	00 00 00 
  803a93:	b8 00 00 00 00       	mov    $0x0,%eax
  803a98:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  803a9f:	00 00 00 
  803aa2:	ff d2                	callq  *%rdx
			close(fd_src);
  803aa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa7:	89 c7                	mov    %eax,%edi
  803aa9:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
			close(fd_dest);
  803ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ab8:	89 c7                	mov    %eax,%edi
  803aba:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803ac1:	00 00 00 
  803ac4:	ff d0                	callq  *%rax
			return write_size;
  803ac6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ac9:	e9 a1 00 00 00       	jmpq   803b6f <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803ace:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad8:	ba 00 02 00 00       	mov    $0x200,%edx
  803add:	48 89 ce             	mov    %rcx,%rsi
  803ae0:	89 c7                	mov    %eax,%edi
  803ae2:	48 b8 59 30 80 00 00 	movabs $0x803059,%rax
  803ae9:	00 00 00 
  803aec:	ff d0                	callq  *%rax
  803aee:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803af5:	0f 8f 5f ff ff ff    	jg     803a5a <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803aff:	79 47                	jns    803b48 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803b01:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b04:	89 c6                	mov    %eax,%esi
  803b06:	48 bf 0c 57 80 00 00 	movabs $0x80570c,%rdi
  803b0d:	00 00 00 
  803b10:	b8 00 00 00 00       	mov    $0x0,%eax
  803b15:	48 ba 3e 0f 80 00 00 	movabs $0x800f3e,%rdx
  803b1c:	00 00 00 
  803b1f:	ff d2                	callq  *%rdx
		close(fd_src);
  803b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b24:	89 c7                	mov    %eax,%edi
  803b26:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803b2d:	00 00 00 
  803b30:	ff d0                	callq  *%rax
		close(fd_dest);
  803b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b35:	89 c7                	mov    %eax,%edi
  803b37:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803b3e:	00 00 00 
  803b41:	ff d0                	callq  *%rax
		return read_size;
  803b43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b46:	eb 27                	jmp    803b6f <copy+0x1db>
	}
	close(fd_src);
  803b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4b:	89 c7                	mov    %eax,%edi
  803b4d:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
	close(fd_dest);
  803b59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b5c:	89 c7                	mov    %eax,%edi
  803b5e:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803b65:	00 00 00 
  803b68:	ff d0                	callq  *%rax
	return 0;
  803b6a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803b6f:	c9                   	leaveq 
  803b70:	c3                   	retq   

0000000000803b71 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803b71:	55                   	push   %rbp
  803b72:	48 89 e5             	mov    %rsp,%rbp
  803b75:	48 83 ec 20          	sub    $0x20,%rsp
  803b79:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803b7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b83:	48 89 d6             	mov    %rdx,%rsi
  803b86:	89 c7                	mov    %eax,%edi
  803b88:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  803b8f:	00 00 00 
  803b92:	ff d0                	callq  *%rax
  803b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b9b:	79 05                	jns    803ba2 <fd2sockid+0x31>
		return r;
  803b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba0:	eb 24                	jmp    803bc6 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba6:	8b 10                	mov    (%rax),%edx
  803ba8:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803baf:	00 00 00 
  803bb2:	8b 00                	mov    (%rax),%eax
  803bb4:	39 c2                	cmp    %eax,%edx
  803bb6:	74 07                	je     803bbf <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803bb8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803bbd:	eb 07                	jmp    803bc6 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803bbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc3:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803bc6:	c9                   	leaveq 
  803bc7:	c3                   	retq   

0000000000803bc8 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803bc8:	55                   	push   %rbp
  803bc9:	48 89 e5             	mov    %rsp,%rbp
  803bcc:	48 83 ec 20          	sub    $0x20,%rsp
  803bd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803bd3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bd7:	48 89 c7             	mov    %rax,%rdi
  803bda:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
  803be6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bed:	78 26                	js     803c15 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf3:	ba 07 04 00 00       	mov    $0x407,%edx
  803bf8:	48 89 c6             	mov    %rax,%rsi
  803bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  803c00:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  803c07:	00 00 00 
  803c0a:	ff d0                	callq  *%rax
  803c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c13:	79 16                	jns    803c2b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803c15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c18:	89 c7                	mov    %eax,%edi
  803c1a:	48 b8 d7 40 80 00 00 	movabs $0x8040d7,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
		return r;
  803c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c29:	eb 3a                	jmp    803c65 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803c2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2f:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803c36:	00 00 00 
  803c39:	8b 12                	mov    (%rdx),%edx
  803c3b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c4f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c56:	48 89 c7             	mov    %rax,%rdi
  803c59:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
}
  803c65:	c9                   	leaveq 
  803c66:	c3                   	retq   

0000000000803c67 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c67:	55                   	push   %rbp
  803c68:	48 89 e5             	mov    %rsp,%rbp
  803c6b:	48 83 ec 30          	sub    $0x30,%rsp
  803c6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c76:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7d:	89 c7                	mov    %eax,%edi
  803c7f:	48 b8 71 3b 80 00 00 	movabs $0x803b71,%rax
  803c86:	00 00 00 
  803c89:	ff d0                	callq  *%rax
  803c8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c92:	79 05                	jns    803c99 <accept+0x32>
		return r;
  803c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c97:	eb 3b                	jmp    803cd4 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803c99:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c9d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ca1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca4:	48 89 ce             	mov    %rcx,%rsi
  803ca7:	89 c7                	mov    %eax,%edi
  803ca9:	48 b8 b4 3f 80 00 00 	movabs $0x803fb4,%rax
  803cb0:	00 00 00 
  803cb3:	ff d0                	callq  *%rax
  803cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cbc:	79 05                	jns    803cc3 <accept+0x5c>
		return r;
  803cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc1:	eb 11                	jmp    803cd4 <accept+0x6d>
	return alloc_sockfd(r);
  803cc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc6:	89 c7                	mov    %eax,%edi
  803cc8:	48 b8 c8 3b 80 00 00 	movabs $0x803bc8,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
}
  803cd4:	c9                   	leaveq 
  803cd5:	c3                   	retq   

0000000000803cd6 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803cd6:	55                   	push   %rbp
  803cd7:	48 89 e5             	mov    %rsp,%rbp
  803cda:	48 83 ec 20          	sub    $0x20,%rsp
  803cde:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ce1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ce5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ce8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ceb:	89 c7                	mov    %eax,%edi
  803ced:	48 b8 71 3b 80 00 00 	movabs $0x803b71,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
  803cf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d00:	79 05                	jns    803d07 <bind+0x31>
		return r;
  803d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d05:	eb 1b                	jmp    803d22 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803d07:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d0a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d11:	48 89 ce             	mov    %rcx,%rsi
  803d14:	89 c7                	mov    %eax,%edi
  803d16:	48 b8 33 40 80 00 00 	movabs $0x804033,%rax
  803d1d:	00 00 00 
  803d20:	ff d0                	callq  *%rax
}
  803d22:	c9                   	leaveq 
  803d23:	c3                   	retq   

0000000000803d24 <shutdown>:

int
shutdown(int s, int how)
{
  803d24:	55                   	push   %rbp
  803d25:	48 89 e5             	mov    %rsp,%rbp
  803d28:	48 83 ec 20          	sub    $0x20,%rsp
  803d2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d2f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d35:	89 c7                	mov    %eax,%edi
  803d37:	48 b8 71 3b 80 00 00 	movabs $0x803b71,%rax
  803d3e:	00 00 00 
  803d41:	ff d0                	callq  *%rax
  803d43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d4a:	79 05                	jns    803d51 <shutdown+0x2d>
		return r;
  803d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4f:	eb 16                	jmp    803d67 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803d51:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d57:	89 d6                	mov    %edx,%esi
  803d59:	89 c7                	mov    %eax,%edi
  803d5b:	48 b8 97 40 80 00 00 	movabs $0x804097,%rax
  803d62:	00 00 00 
  803d65:	ff d0                	callq  *%rax
}
  803d67:	c9                   	leaveq 
  803d68:	c3                   	retq   

0000000000803d69 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803d69:	55                   	push   %rbp
  803d6a:	48 89 e5             	mov    %rsp,%rbp
  803d6d:	48 83 ec 10          	sub    $0x10,%rsp
  803d71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d79:	48 89 c7             	mov    %rax,%rdi
  803d7c:	48 b8 ec 4b 80 00 00 	movabs $0x804bec,%rax
  803d83:	00 00 00 
  803d86:	ff d0                	callq  *%rax
  803d88:	83 f8 01             	cmp    $0x1,%eax
  803d8b:	75 17                	jne    803da4 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d91:	8b 40 0c             	mov    0xc(%rax),%eax
  803d94:	89 c7                	mov    %eax,%edi
  803d96:	48 b8 d7 40 80 00 00 	movabs $0x8040d7,%rax
  803d9d:	00 00 00 
  803da0:	ff d0                	callq  *%rax
  803da2:	eb 05                	jmp    803da9 <devsock_close+0x40>
	else
		return 0;
  803da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803da9:	c9                   	leaveq 
  803daa:	c3                   	retq   

0000000000803dab <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803dab:	55                   	push   %rbp
  803dac:	48 89 e5             	mov    %rsp,%rbp
  803daf:	48 83 ec 20          	sub    $0x20,%rsp
  803db3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803db6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dba:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc0:	89 c7                	mov    %eax,%edi
  803dc2:	48 b8 71 3b 80 00 00 	movabs $0x803b71,%rax
  803dc9:	00 00 00 
  803dcc:	ff d0                	callq  *%rax
  803dce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd5:	79 05                	jns    803ddc <connect+0x31>
		return r;
  803dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dda:	eb 1b                	jmp    803df7 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803ddc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ddf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de6:	48 89 ce             	mov    %rcx,%rsi
  803de9:	89 c7                	mov    %eax,%edi
  803deb:	48 b8 04 41 80 00 00 	movabs $0x804104,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax
}
  803df7:	c9                   	leaveq 
  803df8:	c3                   	retq   

0000000000803df9 <listen>:

int
listen(int s, int backlog)
{
  803df9:	55                   	push   %rbp
  803dfa:	48 89 e5             	mov    %rsp,%rbp
  803dfd:	48 83 ec 20          	sub    $0x20,%rsp
  803e01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e04:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e0a:	89 c7                	mov    %eax,%edi
  803e0c:	48 b8 71 3b 80 00 00 	movabs $0x803b71,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
  803e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1f:	79 05                	jns    803e26 <listen+0x2d>
		return r;
  803e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e24:	eb 16                	jmp    803e3c <listen+0x43>
	return nsipc_listen(r, backlog);
  803e26:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2c:	89 d6                	mov    %edx,%esi
  803e2e:	89 c7                	mov    %eax,%edi
  803e30:	48 b8 68 41 80 00 00 	movabs $0x804168,%rax
  803e37:	00 00 00 
  803e3a:	ff d0                	callq  *%rax
}
  803e3c:	c9                   	leaveq 
  803e3d:	c3                   	retq   

0000000000803e3e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803e3e:	55                   	push   %rbp
  803e3f:	48 89 e5             	mov    %rsp,%rbp
  803e42:	48 83 ec 20          	sub    $0x20,%rsp
  803e46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e56:	89 c2                	mov    %eax,%edx
  803e58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e5c:	8b 40 0c             	mov    0xc(%rax),%eax
  803e5f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e63:	b9 00 00 00 00       	mov    $0x0,%ecx
  803e68:	89 c7                	mov    %eax,%edi
  803e6a:	48 b8 a8 41 80 00 00 	movabs $0x8041a8,%rax
  803e71:	00 00 00 
  803e74:	ff d0                	callq  *%rax
}
  803e76:	c9                   	leaveq 
  803e77:	c3                   	retq   

0000000000803e78 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803e78:	55                   	push   %rbp
  803e79:	48 89 e5             	mov    %rsp,%rbp
  803e7c:	48 83 ec 20          	sub    $0x20,%rsp
  803e80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e88:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e90:	89 c2                	mov    %eax,%edx
  803e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e96:	8b 40 0c             	mov    0xc(%rax),%eax
  803e99:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ea2:	89 c7                	mov    %eax,%edi
  803ea4:	48 b8 74 42 80 00 00 	movabs $0x804274,%rax
  803eab:	00 00 00 
  803eae:	ff d0                	callq  *%rax
}
  803eb0:	c9                   	leaveq 
  803eb1:	c3                   	retq   

0000000000803eb2 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803eb2:	55                   	push   %rbp
  803eb3:	48 89 e5             	mov    %rsp,%rbp
  803eb6:	48 83 ec 10          	sub    $0x10,%rsp
  803eba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ebe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec6:	48 be 27 57 80 00 00 	movabs $0x805727,%rsi
  803ecd:	00 00 00 
  803ed0:	48 89 c7             	mov    %rax,%rdi
  803ed3:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  803eda:	00 00 00 
  803edd:	ff d0                	callq  *%rax
	return 0;
  803edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ee4:	c9                   	leaveq 
  803ee5:	c3                   	retq   

0000000000803ee6 <socket>:

int
socket(int domain, int type, int protocol)
{
  803ee6:	55                   	push   %rbp
  803ee7:	48 89 e5             	mov    %rsp,%rbp
  803eea:	48 83 ec 20          	sub    $0x20,%rsp
  803eee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ef1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ef4:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803ef7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803efa:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803efd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f00:	89 ce                	mov    %ecx,%esi
  803f02:	89 c7                	mov    %eax,%edi
  803f04:	48 b8 2c 43 80 00 00 	movabs $0x80432c,%rax
  803f0b:	00 00 00 
  803f0e:	ff d0                	callq  *%rax
  803f10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f17:	79 05                	jns    803f1e <socket+0x38>
		return r;
  803f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1c:	eb 11                	jmp    803f2f <socket+0x49>
	return alloc_sockfd(r);
  803f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f21:	89 c7                	mov    %eax,%edi
  803f23:	48 b8 c8 3b 80 00 00 	movabs $0x803bc8,%rax
  803f2a:	00 00 00 
  803f2d:	ff d0                	callq  *%rax
}
  803f2f:	c9                   	leaveq 
  803f30:	c3                   	retq   

0000000000803f31 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803f31:	55                   	push   %rbp
  803f32:	48 89 e5             	mov    %rsp,%rbp
  803f35:	48 83 ec 10          	sub    $0x10,%rsp
  803f39:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803f3c:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803f43:	00 00 00 
  803f46:	8b 00                	mov    (%rax),%eax
  803f48:	85 c0                	test   %eax,%eax
  803f4a:	75 1f                	jne    803f6b <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803f4c:	bf 02 00 00 00       	mov    $0x2,%edi
  803f51:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
  803f58:	00 00 00 
  803f5b:	ff d0                	callq  *%rax
  803f5d:	89 c2                	mov    %eax,%edx
  803f5f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803f66:	00 00 00 
  803f69:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803f6b:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803f72:	00 00 00 
  803f75:	8b 00                	mov    (%rax),%eax
  803f77:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803f7a:	b9 07 00 00 00       	mov    $0x7,%ecx
  803f7f:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803f86:	00 00 00 
  803f89:	89 c7                	mov    %eax,%edi
  803f8b:	48 b8 c1 28 80 00 00 	movabs $0x8028c1,%rax
  803f92:	00 00 00 
  803f95:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803f97:	ba 00 00 00 00       	mov    $0x0,%edx
  803f9c:	be 00 00 00 00       	mov    $0x0,%esi
  803fa1:	bf 00 00 00 00       	mov    $0x0,%edi
  803fa6:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  803fad:	00 00 00 
  803fb0:	ff d0                	callq  *%rax
}
  803fb2:	c9                   	leaveq 
  803fb3:	c3                   	retq   

0000000000803fb4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803fb4:	55                   	push   %rbp
  803fb5:	48 89 e5             	mov    %rsp,%rbp
  803fb8:	48 83 ec 30          	sub    $0x30,%rsp
  803fbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fc3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803fc7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fce:	00 00 00 
  803fd1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fd4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803fd6:	bf 01 00 00 00       	mov    $0x1,%edi
  803fdb:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  803fe2:	00 00 00 
  803fe5:	ff d0                	callq  *%rax
  803fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fee:	78 3e                	js     80402e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803ff0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ff7:	00 00 00 
  803ffa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804002:	8b 40 10             	mov    0x10(%rax),%eax
  804005:	89 c2                	mov    %eax,%edx
  804007:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80400b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400f:	48 89 ce             	mov    %rcx,%rsi
  804012:	48 89 c7             	mov    %rax,%rdi
  804015:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80401c:	00 00 00 
  80401f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804025:	8b 50 10             	mov    0x10(%rax),%edx
  804028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80402e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804031:	c9                   	leaveq 
  804032:	c3                   	retq   

0000000000804033 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804033:	55                   	push   %rbp
  804034:	48 89 e5             	mov    %rsp,%rbp
  804037:	48 83 ec 10          	sub    $0x10,%rsp
  80403b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80403e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804042:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804045:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80404c:	00 00 00 
  80404f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804052:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804054:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405b:	48 89 c6             	mov    %rax,%rsi
  80405e:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804065:	00 00 00 
  804068:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80406f:	00 00 00 
  804072:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804074:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80407b:	00 00 00 
  80407e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804081:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804084:	bf 02 00 00 00       	mov    $0x2,%edi
  804089:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  804090:	00 00 00 
  804093:	ff d0                	callq  *%rax
}
  804095:	c9                   	leaveq 
  804096:	c3                   	retq   

0000000000804097 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804097:	55                   	push   %rbp
  804098:	48 89 e5             	mov    %rsp,%rbp
  80409b:	48 83 ec 10          	sub    $0x10,%rsp
  80409f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040a2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8040a5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040ac:	00 00 00 
  8040af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040b2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8040b4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040bb:	00 00 00 
  8040be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040c1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8040c4:	bf 03 00 00 00       	mov    $0x3,%edi
  8040c9:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  8040d0:	00 00 00 
  8040d3:	ff d0                	callq  *%rax
}
  8040d5:	c9                   	leaveq 
  8040d6:	c3                   	retq   

00000000008040d7 <nsipc_close>:

int
nsipc_close(int s)
{
  8040d7:	55                   	push   %rbp
  8040d8:	48 89 e5             	mov    %rsp,%rbp
  8040db:	48 83 ec 10          	sub    $0x10,%rsp
  8040df:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8040e2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040e9:	00 00 00 
  8040ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040ef:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8040f1:	bf 04 00 00 00       	mov    $0x4,%edi
  8040f6:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
}
  804102:	c9                   	leaveq 
  804103:	c3                   	retq   

0000000000804104 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804104:	55                   	push   %rbp
  804105:	48 89 e5             	mov    %rsp,%rbp
  804108:	48 83 ec 10          	sub    $0x10,%rsp
  80410c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80410f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804113:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804116:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80411d:	00 00 00 
  804120:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804123:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804125:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412c:	48 89 c6             	mov    %rax,%rsi
  80412f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804136:	00 00 00 
  804139:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  804140:	00 00 00 
  804143:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804145:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80414c:	00 00 00 
  80414f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804152:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804155:	bf 05 00 00 00       	mov    $0x5,%edi
  80415a:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
}
  804166:	c9                   	leaveq 
  804167:	c3                   	retq   

0000000000804168 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804168:	55                   	push   %rbp
  804169:	48 89 e5             	mov    %rsp,%rbp
  80416c:	48 83 ec 10          	sub    $0x10,%rsp
  804170:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804173:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804176:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80417d:	00 00 00 
  804180:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804183:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804185:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80418c:	00 00 00 
  80418f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804192:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804195:	bf 06 00 00 00       	mov    $0x6,%edi
  80419a:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  8041a1:	00 00 00 
  8041a4:	ff d0                	callq  *%rax
}
  8041a6:	c9                   	leaveq 
  8041a7:	c3                   	retq   

00000000008041a8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8041a8:	55                   	push   %rbp
  8041a9:	48 89 e5             	mov    %rsp,%rbp
  8041ac:	48 83 ec 30          	sub    $0x30,%rsp
  8041b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8041ba:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8041bd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041c4:	00 00 00 
  8041c7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8041ca:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8041cc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041d3:	00 00 00 
  8041d6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041d9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8041dc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041e3:	00 00 00 
  8041e6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8041e9:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8041ec:	bf 07 00 00 00       	mov    $0x7,%edi
  8041f1:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  8041f8:	00 00 00 
  8041fb:	ff d0                	callq  *%rax
  8041fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804204:	78 69                	js     80426f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804206:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80420d:	7f 08                	jg     804217 <nsipc_recv+0x6f>
  80420f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804212:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804215:	7e 35                	jle    80424c <nsipc_recv+0xa4>
  804217:	48 b9 2e 57 80 00 00 	movabs $0x80572e,%rcx
  80421e:	00 00 00 
  804221:	48 ba 43 57 80 00 00 	movabs $0x805743,%rdx
  804228:	00 00 00 
  80422b:	be 62 00 00 00       	mov    $0x62,%esi
  804230:	48 bf 58 57 80 00 00 	movabs $0x805758,%rdi
  804237:	00 00 00 
  80423a:	b8 00 00 00 00       	mov    $0x0,%eax
  80423f:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  804246:	00 00 00 
  804249:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80424c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424f:	48 63 d0             	movslq %eax,%rdx
  804252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804256:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80425d:	00 00 00 
  804260:	48 89 c7             	mov    %rax,%rdi
  804263:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  80426a:	00 00 00 
  80426d:	ff d0                	callq  *%rax
	}

	return r;
  80426f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804272:	c9                   	leaveq 
  804273:	c3                   	retq   

0000000000804274 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804274:	55                   	push   %rbp
  804275:	48 89 e5             	mov    %rsp,%rbp
  804278:	48 83 ec 20          	sub    $0x20,%rsp
  80427c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80427f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804283:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804286:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804289:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804290:	00 00 00 
  804293:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804296:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804298:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80429f:	7e 35                	jle    8042d6 <nsipc_send+0x62>
  8042a1:	48 b9 64 57 80 00 00 	movabs $0x805764,%rcx
  8042a8:	00 00 00 
  8042ab:	48 ba 43 57 80 00 00 	movabs $0x805743,%rdx
  8042b2:	00 00 00 
  8042b5:	be 6d 00 00 00       	mov    $0x6d,%esi
  8042ba:	48 bf 58 57 80 00 00 	movabs $0x805758,%rdi
  8042c1:	00 00 00 
  8042c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c9:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  8042d0:	00 00 00 
  8042d3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8042d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042d9:	48 63 d0             	movslq %eax,%rdx
  8042dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e0:	48 89 c6             	mov    %rax,%rsi
  8042e3:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8042ea:	00 00 00 
  8042ed:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  8042f4:	00 00 00 
  8042f7:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8042f9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804300:	00 00 00 
  804303:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804306:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804309:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804310:	00 00 00 
  804313:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804316:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804319:	bf 08 00 00 00       	mov    $0x8,%edi
  80431e:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  804325:	00 00 00 
  804328:	ff d0                	callq  *%rax
}
  80432a:	c9                   	leaveq 
  80432b:	c3                   	retq   

000000000080432c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80432c:	55                   	push   %rbp
  80432d:	48 89 e5             	mov    %rsp,%rbp
  804330:	48 83 ec 10          	sub    $0x10,%rsp
  804334:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804337:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80433a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80433d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804344:	00 00 00 
  804347:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80434a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80434c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804353:	00 00 00 
  804356:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804359:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80435c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804363:	00 00 00 
  804366:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804369:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80436c:	bf 09 00 00 00       	mov    $0x9,%edi
  804371:	48 b8 31 3f 80 00 00 	movabs $0x803f31,%rax
  804378:	00 00 00 
  80437b:	ff d0                	callq  *%rax
}
  80437d:	c9                   	leaveq 
  80437e:	c3                   	retq   

000000000080437f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80437f:	55                   	push   %rbp
  804380:	48 89 e5             	mov    %rsp,%rbp
  804383:	53                   	push   %rbx
  804384:	48 83 ec 38          	sub    $0x38,%rsp
  804388:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80438c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804390:	48 89 c7             	mov    %rax,%rdi
  804393:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
  80439f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043a6:	0f 88 bf 01 00 00    	js     80456b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043b0:	ba 07 04 00 00       	mov    $0x407,%edx
  8043b5:	48 89 c6             	mov    %rax,%rsi
  8043b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043bd:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8043c4:	00 00 00 
  8043c7:	ff d0                	callq  *%rax
  8043c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043d0:	0f 88 95 01 00 00    	js     80456b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8043d6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8043da:	48 89 c7             	mov    %rax,%rdi
  8043dd:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  8043e4:	00 00 00 
  8043e7:	ff d0                	callq  *%rax
  8043e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043f0:	0f 88 5d 01 00 00    	js     804553 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043fa:	ba 07 04 00 00       	mov    $0x407,%edx
  8043ff:	48 89 c6             	mov    %rax,%rsi
  804402:	bf 00 00 00 00       	mov    $0x0,%edi
  804407:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  80440e:	00 00 00 
  804411:	ff d0                	callq  *%rax
  804413:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804416:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80441a:	0f 88 33 01 00 00    	js     804553 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804424:	48 89 c7             	mov    %rax,%rdi
  804427:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  80442e:	00 00 00 
  804431:	ff d0                	callq  *%rax
  804433:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804437:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80443b:	ba 07 04 00 00       	mov    $0x407,%edx
  804440:	48 89 c6             	mov    %rax,%rsi
  804443:	bf 00 00 00 00       	mov    $0x0,%edi
  804448:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  80444f:	00 00 00 
  804452:	ff d0                	callq  *%rax
  804454:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804457:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80445b:	0f 88 d9 00 00 00    	js     80453a <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804461:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804465:	48 89 c7             	mov    %rax,%rdi
  804468:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  80446f:	00 00 00 
  804472:	ff d0                	callq  *%rax
  804474:	48 89 c2             	mov    %rax,%rdx
  804477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80447b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804481:	48 89 d1             	mov    %rdx,%rcx
  804484:	ba 00 00 00 00       	mov    $0x0,%edx
  804489:	48 89 c6             	mov    %rax,%rsi
  80448c:	bf 00 00 00 00       	mov    $0x0,%edi
  804491:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  804498:	00 00 00 
  80449b:	ff d0                	callq  *%rax
  80449d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044a4:	78 79                	js     80451f <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8044a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044aa:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8044b1:	00 00 00 
  8044b4:	8b 12                	mov    (%rdx),%edx
  8044b6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8044b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8044c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044c7:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8044ce:	00 00 00 
  8044d1:	8b 12                	mov    (%rdx),%edx
  8044d3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8044d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044d9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8044e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044e4:	48 89 c7             	mov    %rax,%rdi
  8044e7:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  8044ee:	00 00 00 
  8044f1:	ff d0                	callq  *%rax
  8044f3:	89 c2                	mov    %eax,%edx
  8044f5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044f9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8044fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044ff:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804507:	48 89 c7             	mov    %rax,%rdi
  80450a:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  804511:	00 00 00 
  804514:	ff d0                	callq  *%rax
  804516:	89 03                	mov    %eax,(%rbx)
	return 0;
  804518:	b8 00 00 00 00       	mov    $0x0,%eax
  80451d:	eb 4f                	jmp    80456e <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80451f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804520:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804524:	48 89 c6             	mov    %rax,%rsi
  804527:	bf 00 00 00 00       	mov    $0x0,%edi
  80452c:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  804533:	00 00 00 
  804536:	ff d0                	callq  *%rax
  804538:	eb 01                	jmp    80453b <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80453a:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80453b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80453f:	48 89 c6             	mov    %rax,%rsi
  804542:	bf 00 00 00 00       	mov    $0x0,%edi
  804547:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  80454e:	00 00 00 
  804551:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804557:	48 89 c6             	mov    %rax,%rsi
  80455a:	bf 00 00 00 00       	mov    $0x0,%edi
  80455f:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  804566:	00 00 00 
  804569:	ff d0                	callq  *%rax
err:
	return r;
  80456b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80456e:	48 83 c4 38          	add    $0x38,%rsp
  804572:	5b                   	pop    %rbx
  804573:	5d                   	pop    %rbp
  804574:	c3                   	retq   

0000000000804575 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804575:	55                   	push   %rbp
  804576:	48 89 e5             	mov    %rsp,%rbp
  804579:	53                   	push   %rbx
  80457a:	48 83 ec 28          	sub    $0x28,%rsp
  80457e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804582:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804586:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80458d:	00 00 00 
  804590:	48 8b 00             	mov    (%rax),%rax
  804593:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804599:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80459c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a0:	48 89 c7             	mov    %rax,%rdi
  8045a3:	48 b8 ec 4b 80 00 00 	movabs $0x804bec,%rax
  8045aa:	00 00 00 
  8045ad:	ff d0                	callq  *%rax
  8045af:	89 c3                	mov    %eax,%ebx
  8045b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045b5:	48 89 c7             	mov    %rax,%rdi
  8045b8:	48 b8 ec 4b 80 00 00 	movabs $0x804bec,%rax
  8045bf:	00 00 00 
  8045c2:	ff d0                	callq  *%rax
  8045c4:	39 c3                	cmp    %eax,%ebx
  8045c6:	0f 94 c0             	sete   %al
  8045c9:	0f b6 c0             	movzbl %al,%eax
  8045cc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8045cf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8045d6:	00 00 00 
  8045d9:	48 8b 00             	mov    (%rax),%rax
  8045dc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8045e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8045e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045e8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045eb:	75 05                	jne    8045f2 <_pipeisclosed+0x7d>
			return ret;
  8045ed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8045f0:	eb 4a                	jmp    80463c <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8045f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045f5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045f8:	74 8c                	je     804586 <_pipeisclosed+0x11>
  8045fa:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8045fe:	75 86                	jne    804586 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804600:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804607:	00 00 00 
  80460a:	48 8b 00             	mov    (%rax),%rax
  80460d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804613:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804616:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804619:	89 c6                	mov    %eax,%esi
  80461b:	48 bf 75 57 80 00 00 	movabs $0x805775,%rdi
  804622:	00 00 00 
  804625:	b8 00 00 00 00       	mov    $0x0,%eax
  80462a:	49 b8 3e 0f 80 00 00 	movabs $0x800f3e,%r8
  804631:	00 00 00 
  804634:	41 ff d0             	callq  *%r8
	}
  804637:	e9 4a ff ff ff       	jmpq   804586 <_pipeisclosed+0x11>

}
  80463c:	48 83 c4 28          	add    $0x28,%rsp
  804640:	5b                   	pop    %rbx
  804641:	5d                   	pop    %rbp
  804642:	c3                   	retq   

0000000000804643 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804643:	55                   	push   %rbp
  804644:	48 89 e5             	mov    %rsp,%rbp
  804647:	48 83 ec 30          	sub    $0x30,%rsp
  80464b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80464e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804652:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804655:	48 89 d6             	mov    %rdx,%rsi
  804658:	89 c7                	mov    %eax,%edi
  80465a:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  804661:	00 00 00 
  804664:	ff d0                	callq  *%rax
  804666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80466d:	79 05                	jns    804674 <pipeisclosed+0x31>
		return r;
  80466f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804672:	eb 31                	jmp    8046a5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804678:	48 89 c7             	mov    %rax,%rdi
  80467b:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  804682:	00 00 00 
  804685:	ff d0                	callq  *%rax
  804687:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80468b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80468f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804693:	48 89 d6             	mov    %rdx,%rsi
  804696:	48 89 c7             	mov    %rax,%rdi
  804699:	48 b8 75 45 80 00 00 	movabs $0x804575,%rax
  8046a0:	00 00 00 
  8046a3:	ff d0                	callq  *%rax
}
  8046a5:	c9                   	leaveq 
  8046a6:	c3                   	retq   

00000000008046a7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046a7:	55                   	push   %rbp
  8046a8:	48 89 e5             	mov    %rsp,%rbp
  8046ab:	48 83 ec 40          	sub    $0x40,%rsp
  8046af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8046bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046bf:	48 89 c7             	mov    %rax,%rdi
  8046c2:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  8046c9:	00 00 00 
  8046cc:	ff d0                	callq  *%rax
  8046ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8046d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046e1:	00 
  8046e2:	e9 90 00 00 00       	jmpq   804777 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8046e7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8046ec:	74 09                	je     8046f7 <devpipe_read+0x50>
				return i;
  8046ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f2:	e9 8e 00 00 00       	jmpq   804785 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8046f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ff:	48 89 d6             	mov    %rdx,%rsi
  804702:	48 89 c7             	mov    %rax,%rdi
  804705:	48 b8 75 45 80 00 00 	movabs $0x804575,%rax
  80470c:	00 00 00 
  80470f:	ff d0                	callq  *%rax
  804711:	85 c0                	test   %eax,%eax
  804713:	74 07                	je     80471c <devpipe_read+0x75>
				return 0;
  804715:	b8 00 00 00 00       	mov    $0x0,%eax
  80471a:	eb 69                	jmp    804785 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80471c:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  804723:	00 00 00 
  804726:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472c:	8b 10                	mov    (%rax),%edx
  80472e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804732:	8b 40 04             	mov    0x4(%rax),%eax
  804735:	39 c2                	cmp    %eax,%edx
  804737:	74 ae                	je     8046e7 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804739:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80473d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804741:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804749:	8b 00                	mov    (%rax),%eax
  80474b:	99                   	cltd   
  80474c:	c1 ea 1b             	shr    $0x1b,%edx
  80474f:	01 d0                	add    %edx,%eax
  804751:	83 e0 1f             	and    $0x1f,%eax
  804754:	29 d0                	sub    %edx,%eax
  804756:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80475a:	48 98                	cltq   
  80475c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804761:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804767:	8b 00                	mov    (%rax),%eax
  804769:	8d 50 01             	lea    0x1(%rax),%edx
  80476c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804770:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804772:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80477b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80477f:	72 a7                	jb     804728 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804781:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804785:	c9                   	leaveq 
  804786:	c3                   	retq   

0000000000804787 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804787:	55                   	push   %rbp
  804788:	48 89 e5             	mov    %rsp,%rbp
  80478b:	48 83 ec 40          	sub    $0x40,%rsp
  80478f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804793:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804797:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80479b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80479f:	48 89 c7             	mov    %rax,%rdi
  8047a2:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  8047a9:	00 00 00 
  8047ac:	ff d0                	callq  *%rax
  8047ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8047b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8047ba:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8047c1:	00 
  8047c2:	e9 8f 00 00 00       	jmpq   804856 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8047c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047cf:	48 89 d6             	mov    %rdx,%rsi
  8047d2:	48 89 c7             	mov    %rax,%rdi
  8047d5:	48 b8 75 45 80 00 00 	movabs $0x804575,%rax
  8047dc:	00 00 00 
  8047df:	ff d0                	callq  *%rax
  8047e1:	85 c0                	test   %eax,%eax
  8047e3:	74 07                	je     8047ec <devpipe_write+0x65>
				return 0;
  8047e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ea:	eb 78                	jmp    804864 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8047ec:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  8047f3:	00 00 00 
  8047f6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8047f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047fc:	8b 40 04             	mov    0x4(%rax),%eax
  8047ff:	48 63 d0             	movslq %eax,%rdx
  804802:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804806:	8b 00                	mov    (%rax),%eax
  804808:	48 98                	cltq   
  80480a:	48 83 c0 20          	add    $0x20,%rax
  80480e:	48 39 c2             	cmp    %rax,%rdx
  804811:	73 b4                	jae    8047c7 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804817:	8b 40 04             	mov    0x4(%rax),%eax
  80481a:	99                   	cltd   
  80481b:	c1 ea 1b             	shr    $0x1b,%edx
  80481e:	01 d0                	add    %edx,%eax
  804820:	83 e0 1f             	and    $0x1f,%eax
  804823:	29 d0                	sub    %edx,%eax
  804825:	89 c6                	mov    %eax,%esi
  804827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80482b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80482f:	48 01 d0             	add    %rdx,%rax
  804832:	0f b6 08             	movzbl (%rax),%ecx
  804835:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804839:	48 63 c6             	movslq %esi,%rax
  80483c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804840:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804844:	8b 40 04             	mov    0x4(%rax),%eax
  804847:	8d 50 01             	lea    0x1(%rax),%edx
  80484a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80484e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804851:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80485a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80485e:	72 98                	jb     8047f8 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804864:	c9                   	leaveq 
  804865:	c3                   	retq   

0000000000804866 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804866:	55                   	push   %rbp
  804867:	48 89 e5             	mov    %rsp,%rbp
  80486a:	48 83 ec 20          	sub    $0x20,%rsp
  80486e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804872:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80487a:	48 89 c7             	mov    %rax,%rdi
  80487d:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  804884:	00 00 00 
  804887:	ff d0                	callq  *%rax
  804889:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80488d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804891:	48 be 88 57 80 00 00 	movabs $0x805788,%rsi
  804898:	00 00 00 
  80489b:	48 89 c7             	mov    %rax,%rdi
  80489e:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  8048a5:	00 00 00 
  8048a8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8048aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048ae:	8b 50 04             	mov    0x4(%rax),%edx
  8048b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048b5:	8b 00                	mov    (%rax),%eax
  8048b7:	29 c2                	sub    %eax,%edx
  8048b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048bd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8048c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048c7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8048ce:	00 00 00 
	stat->st_dev = &devpipe;
  8048d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048d5:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8048dc:	00 00 00 
  8048df:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8048e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048eb:	c9                   	leaveq 
  8048ec:	c3                   	retq   

00000000008048ed <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8048ed:	55                   	push   %rbp
  8048ee:	48 89 e5             	mov    %rsp,%rbp
  8048f1:	48 83 ec 10          	sub    $0x10,%rsp
  8048f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8048f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048fd:	48 89 c6             	mov    %rax,%rsi
  804900:	bf 00 00 00 00       	mov    $0x0,%edi
  804905:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  80490c:	00 00 00 
  80490f:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804911:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804915:	48 89 c7             	mov    %rax,%rdi
  804918:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  80491f:	00 00 00 
  804922:	ff d0                	callq  *%rax
  804924:	48 89 c6             	mov    %rax,%rsi
  804927:	bf 00 00 00 00       	mov    $0x0,%edi
  80492c:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  804933:	00 00 00 
  804936:	ff d0                	callq  *%rax
}
  804938:	c9                   	leaveq 
  804939:	c3                   	retq   

000000000080493a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80493a:	55                   	push   %rbp
  80493b:	48 89 e5             	mov    %rsp,%rbp
  80493e:	48 83 ec 20          	sub    $0x20,%rsp
  804942:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804945:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804948:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80494b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80494f:	be 01 00 00 00       	mov    $0x1,%esi
  804954:	48 89 c7             	mov    %rax,%rdi
  804957:	48 b8 bc 22 80 00 00 	movabs $0x8022bc,%rax
  80495e:	00 00 00 
  804961:	ff d0                	callq  *%rax
}
  804963:	90                   	nop
  804964:	c9                   	leaveq 
  804965:	c3                   	retq   

0000000000804966 <getchar>:

int
getchar(void)
{
  804966:	55                   	push   %rbp
  804967:	48 89 e5             	mov    %rsp,%rbp
  80496a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80496e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804972:	ba 01 00 00 00       	mov    $0x1,%edx
  804977:	48 89 c6             	mov    %rax,%rsi
  80497a:	bf 00 00 00 00       	mov    $0x0,%edi
  80497f:	48 b8 59 30 80 00 00 	movabs $0x803059,%rax
  804986:	00 00 00 
  804989:	ff d0                	callq  *%rax
  80498b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80498e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804992:	79 05                	jns    804999 <getchar+0x33>
		return r;
  804994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804997:	eb 14                	jmp    8049ad <getchar+0x47>
	if (r < 1)
  804999:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80499d:	7f 07                	jg     8049a6 <getchar+0x40>
		return -E_EOF;
  80499f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8049a4:	eb 07                	jmp    8049ad <getchar+0x47>
	return c;
  8049a6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8049aa:	0f b6 c0             	movzbl %al,%eax

}
  8049ad:	c9                   	leaveq 
  8049ae:	c3                   	retq   

00000000008049af <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8049af:	55                   	push   %rbp
  8049b0:	48 89 e5             	mov    %rsp,%rbp
  8049b3:	48 83 ec 20          	sub    $0x20,%rsp
  8049b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8049ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8049be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049c1:	48 89 d6             	mov    %rdx,%rsi
  8049c4:	89 c7                	mov    %eax,%edi
  8049c6:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  8049cd:	00 00 00 
  8049d0:	ff d0                	callq  *%rax
  8049d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049d9:	79 05                	jns    8049e0 <iscons+0x31>
		return r;
  8049db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049de:	eb 1a                	jmp    8049fa <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8049e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049e4:	8b 10                	mov    (%rax),%edx
  8049e6:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8049ed:	00 00 00 
  8049f0:	8b 00                	mov    (%rax),%eax
  8049f2:	39 c2                	cmp    %eax,%edx
  8049f4:	0f 94 c0             	sete   %al
  8049f7:	0f b6 c0             	movzbl %al,%eax
}
  8049fa:	c9                   	leaveq 
  8049fb:	c3                   	retq   

00000000008049fc <opencons>:

int
opencons(void)
{
  8049fc:	55                   	push   %rbp
  8049fd:	48 89 e5             	mov    %rsp,%rbp
  804a00:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804a04:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804a08:	48 89 c7             	mov    %rax,%rdi
  804a0b:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  804a12:	00 00 00 
  804a15:	ff d0                	callq  *%rax
  804a17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a1e:	79 05                	jns    804a25 <opencons+0x29>
		return r;
  804a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a23:	eb 5b                	jmp    804a80 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a29:	ba 07 04 00 00       	mov    $0x407,%edx
  804a2e:	48 89 c6             	mov    %rax,%rsi
  804a31:	bf 00 00 00 00       	mov    $0x0,%edi
  804a36:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  804a3d:	00 00 00 
  804a40:	ff d0                	callq  *%rax
  804a42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a49:	79 05                	jns    804a50 <opencons+0x54>
		return r;
  804a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a4e:	eb 30                	jmp    804a80 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a54:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804a5b:	00 00 00 
  804a5e:	8b 12                	mov    (%rdx),%edx
  804a60:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a66:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a71:	48 89 c7             	mov    %rax,%rdi
  804a74:	48 b8 3e 2b 80 00 00 	movabs $0x802b3e,%rax
  804a7b:	00 00 00 
  804a7e:	ff d0                	callq  *%rax
}
  804a80:	c9                   	leaveq 
  804a81:	c3                   	retq   

0000000000804a82 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804a82:	55                   	push   %rbp
  804a83:	48 89 e5             	mov    %rsp,%rbp
  804a86:	48 83 ec 30          	sub    $0x30,%rsp
  804a8a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a8e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a92:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804a96:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a9b:	75 13                	jne    804ab0 <devcons_read+0x2e>
		return 0;
  804a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  804aa2:	eb 49                	jmp    804aed <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804aa4:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  804aab:	00 00 00 
  804aae:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804ab0:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  804ab7:	00 00 00 
  804aba:	ff d0                	callq  *%rax
  804abc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ac3:	74 df                	je     804aa4 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ac9:	79 05                	jns    804ad0 <devcons_read+0x4e>
		return c;
  804acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ace:	eb 1d                	jmp    804aed <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804ad0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804ad4:	75 07                	jne    804add <devcons_read+0x5b>
		return 0;
  804ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  804adb:	eb 10                	jmp    804aed <devcons_read+0x6b>
	*(char*)vbuf = c;
  804add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ae0:	89 c2                	mov    %eax,%edx
  804ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ae6:	88 10                	mov    %dl,(%rax)
	return 1;
  804ae8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804aed:	c9                   	leaveq 
  804aee:	c3                   	retq   

0000000000804aef <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804aef:	55                   	push   %rbp
  804af0:	48 89 e5             	mov    %rsp,%rbp
  804af3:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804afa:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804b01:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804b08:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804b0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804b16:	eb 76                	jmp    804b8e <devcons_write+0x9f>
		m = n - tot;
  804b18:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804b1f:	89 c2                	mov    %eax,%edx
  804b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b24:	29 c2                	sub    %eax,%edx
  804b26:	89 d0                	mov    %edx,%eax
  804b28:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804b2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b2e:	83 f8 7f             	cmp    $0x7f,%eax
  804b31:	76 07                	jbe    804b3a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804b33:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804b3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b3d:	48 63 d0             	movslq %eax,%rdx
  804b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b43:	48 63 c8             	movslq %eax,%rcx
  804b46:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804b4d:	48 01 c1             	add    %rax,%rcx
  804b50:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b57:	48 89 ce             	mov    %rcx,%rsi
  804b5a:	48 89 c7             	mov    %rax,%rdi
  804b5d:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  804b64:	00 00 00 
  804b67:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804b69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b6c:	48 63 d0             	movslq %eax,%rdx
  804b6f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b76:	48 89 d6             	mov    %rdx,%rsi
  804b79:	48 89 c7             	mov    %rax,%rdi
  804b7c:	48 b8 bc 22 80 00 00 	movabs $0x8022bc,%rax
  804b83:	00 00 00 
  804b86:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804b88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b8b:	01 45 fc             	add    %eax,-0x4(%rbp)
  804b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b91:	48 98                	cltq   
  804b93:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804b9a:	0f 82 78 ff ff ff    	jb     804b18 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804ba3:	c9                   	leaveq 
  804ba4:	c3                   	retq   

0000000000804ba5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804ba5:	55                   	push   %rbp
  804ba6:	48 89 e5             	mov    %rsp,%rbp
  804ba9:	48 83 ec 08          	sub    $0x8,%rsp
  804bad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804bb6:	c9                   	leaveq 
  804bb7:	c3                   	retq   

0000000000804bb8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804bb8:	55                   	push   %rbp
  804bb9:	48 89 e5             	mov    %rsp,%rbp
  804bbc:	48 83 ec 10          	sub    $0x10,%rsp
  804bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804bc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804bc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bcc:	48 be 94 57 80 00 00 	movabs $0x805794,%rsi
  804bd3:	00 00 00 
  804bd6:	48 89 c7             	mov    %rax,%rdi
  804bd9:	48 b8 ce 1a 80 00 00 	movabs $0x801ace,%rax
  804be0:	00 00 00 
  804be3:	ff d0                	callq  *%rax
	return 0;
  804be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804bea:	c9                   	leaveq 
  804beb:	c3                   	retq   

0000000000804bec <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804bec:	55                   	push   %rbp
  804bed:	48 89 e5             	mov    %rsp,%rbp
  804bf0:	48 83 ec 18          	sub    $0x18,%rsp
  804bf4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bfc:	48 c1 e8 15          	shr    $0x15,%rax
  804c00:	48 89 c2             	mov    %rax,%rdx
  804c03:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c0a:	01 00 00 
  804c0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c11:	83 e0 01             	and    $0x1,%eax
  804c14:	48 85 c0             	test   %rax,%rax
  804c17:	75 07                	jne    804c20 <pageref+0x34>
		return 0;
  804c19:	b8 00 00 00 00       	mov    $0x0,%eax
  804c1e:	eb 56                	jmp    804c76 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c24:	48 c1 e8 0c          	shr    $0xc,%rax
  804c28:	48 89 c2             	mov    %rax,%rdx
  804c2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c32:	01 00 00 
  804c35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c41:	83 e0 01             	and    $0x1,%eax
  804c44:	48 85 c0             	test   %rax,%rax
  804c47:	75 07                	jne    804c50 <pageref+0x64>
		return 0;
  804c49:	b8 00 00 00 00       	mov    $0x0,%eax
  804c4e:	eb 26                	jmp    804c76 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c54:	48 c1 e8 0c          	shr    $0xc,%rax
  804c58:	48 89 c2             	mov    %rax,%rdx
  804c5b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c62:	00 00 00 
  804c65:	48 c1 e2 04          	shl    $0x4,%rdx
  804c69:	48 01 d0             	add    %rdx,%rax
  804c6c:	48 83 c0 08          	add    $0x8,%rax
  804c70:	0f b7 00             	movzwl (%rax),%eax
  804c73:	0f b7 c0             	movzwl %ax,%eax
}
  804c76:	c9                   	leaveq 
  804c77:	c3                   	retq   
