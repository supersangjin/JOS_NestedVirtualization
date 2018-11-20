
obj/user/echotest:     file format elf64-x86-64


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
  80003c:	e8 db 02 00 00       	callq  80031c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  80004f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800053:	48 89 c6             	mov    %rax,%rsi
  800056:	48 bf ce 47 80 00 00 	movabs $0x8047ce,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 a0 03 80 00 00 	movabs $0x8003a0,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	90                   	nop
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <umain>:

void umain(int argc, char **argv)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 50          	sub    $0x50,%rsp
  800088:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80008b:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80008f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("Connecting to:\n");
  800096:	48 bf d2 47 80 00 00 	movabs $0x8047d2,%rdi
  80009d:	00 00 00 
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  8000ac:	00 00 00 
  8000af:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b1:	48 bf e2 47 80 00 00 	movabs $0x8047e2,%rdi
  8000b8:	00 00 00 
  8000bb:	48 b8 bd 42 80 00 00 	movabs $0x8042bd,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	48 be e2 47 80 00 00 	movabs $0x8047e2,%rsi
  8000d0:	00 00 00 
  8000d3:	48 bf ec 47 80 00 00 	movabs $0x8047ec,%rdi
  8000da:	00 00 00 
  8000dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e2:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  8000e9:	00 00 00 
  8000ec:	ff d1                	callq  *%rcx

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ee:	ba 06 00 00 00       	mov    $0x6,%edx
  8000f3:	be 01 00 00 00       	mov    $0x1,%esi
  8000f8:	bf 02 00 00 00       	mov    $0x2,%edi
  8000fd:	48 b8 50 32 80 00 00 	movabs $0x803250,%rax
  800104:	00 00 00 
  800107:	ff d0                	callq  *%rax
  800109:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800110:	79 16                	jns    800128 <umain+0xa8>
		die("Failed to create socket");
  800112:	48 bf 01 48 80 00 00 	movabs $0x804801,%rdi
  800119:	00 00 00 
  80011c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800128:	48 bf 19 48 80 00 00 	movabs $0x804819,%rdi
  80012f:	00 00 00 
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  80013e:	00 00 00 
  800141:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800143:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800147:	ba 10 00 00 00       	mov    $0x10,%edx
  80014c:	be 00 00 00 00       	mov    $0x0,%esi
  800151:	48 89 c7             	mov    %rax,%rdi
  800154:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800160:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  800164:	48 bf e2 47 80 00 00 	movabs $0x8047e2,%rdi
  80016b:	00 00 00 
  80016e:	48 b8 bd 42 80 00 00 	movabs $0x8042bd,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
  80017a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017d:	bf 10 27 00 00       	mov    $0x2710,%edi
  800182:	48 b8 0d 47 80 00 00 	movabs $0x80470d,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
  80018e:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800192:	48 bf 28 48 80 00 00 	movabs $0x804828,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  8001a8:	00 00 00 
  8001ab:	ff d2                	callq  *%rdx

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8001ad:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8001b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b4:	ba 10 00 00 00       	mov    $0x10,%edx
  8001b9:	48 89 ce             	mov    %rcx,%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	48 b8 15 31 80 00 00 	movabs $0x803115,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	79 16                	jns    8001e4 <umain+0x164>
		die("Failed to connect with server");
  8001ce:	48 bf 45 48 80 00 00 	movabs $0x804845,%rdi
  8001d5:	00 00 00 
  8001d8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e4:	48 bf 63 48 80 00 00 	movabs $0x804863,%rdi
  8001eb:	00 00 00 
  8001ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f3:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  8001fa:	00 00 00 
  8001fd:	ff d2                	callq  *%rdx

	// Send the word to the server
	echolen = strlen(msg);
  8001ff:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800206:	00 00 00 
  800209:	48 8b 00             	mov    (%rax),%rax
  80020c:	48 89 c7             	mov    %rax,%rdi
  80020f:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  800216:	00 00 00 
  800219:	ff d0                	callq  *%rax
  80021b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(sock, msg, echolen) != echolen)
  80021e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800221:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800228:	00 00 00 
  80022b:	48 8b 08             	mov    (%rax),%rcx
  80022e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800231:	48 89 ce             	mov    %rcx,%rsi
  800234:	89 c7                	mov    %eax,%edi
  800236:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
  800242:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800245:	74 16                	je     80025d <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800247:	48 bf 78 48 80 00 00 	movabs $0x804878,%rdi
  80024e:	00 00 00 
  800251:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025d:	48 bf 99 48 80 00 00 	movabs $0x804899,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  800273:	00 00 00 
  800276:	ff d2                	callq  *%rdx
	while (received < echolen) {
  800278:	eb 6b                	jmp    8002e5 <umain+0x265>
		int bytes = 0;
  80027a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800281:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800285:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800288:	ba 1f 00 00 00       	mov    $0x1f,%edx
  80028d:	48 89 ce             	mov    %rcx,%rsi
  800290:	89 c7                	mov    %eax,%edi
  800292:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
  80029e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a5:	7f 16                	jg     8002bd <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a7:	48 bf a8 48 80 00 00 	movabs $0x8048a8,%rdi
  8002ae:	00 00 00 
  8002b1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002b8:	00 00 00 
  8002bb:	ff d0                	callq  *%rax
		}
		received += bytes;
  8002bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c0:	01 45 fc             	add    %eax,-0x4(%rbp)
		buffer[bytes] = '\0';        // Assure null terminated string
  8002c3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c6:	48 98                	cltq   
  8002c8:	c6 44 05 c0 00       	movb   $0x0,-0x40(%rbp,%rax,1)
		cprintf(buffer);
  8002cd:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  8002e0:	00 00 00 
  8002e3:	ff d2                	callq  *%rdx
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8002e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002eb:	72 8d                	jb     80027a <umain+0x1fa>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8002ed:	48 bf cc 48 80 00 00 	movabs $0x8048cc,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  800303:	00 00 00 
  800306:	ff d2                	callq  *%rdx

	close(sock);
  800308:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030b:	89 c7                	mov    %eax,%edi
  80030d:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  800314:	00 00 00 
  800317:	ff d0                	callq  *%rax
}
  800319:	90                   	nop
  80031a:	c9                   	leaveq 
  80031b:	c3                   	retq   

000000000080031c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80031c:	55                   	push   %rbp
  80031d:	48 89 e5             	mov    %rsp,%rbp
  800320:	48 83 ec 10          	sub    $0x10,%rsp
  800324:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800327:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  80032b:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  800332:	00 00 00 
  800335:	ff d0                	callq  *%rax
  800337:	25 ff 03 00 00       	and    $0x3ff,%eax
  80033c:	48 98                	cltq   
  80033e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800345:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80034c:	00 00 00 
  80034f:	48 01 c2             	add    %rax,%rdx
  800352:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800359:	00 00 00 
  80035c:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80035f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800363:	7e 14                	jle    800379 <libmain+0x5d>
		binaryname = argv[0];
  800365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800369:	48 8b 10             	mov    (%rax),%rdx
  80036c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800373:	00 00 00 
  800376:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800379:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800380:	48 89 d6             	mov    %rdx,%rsi
  800383:	89 c7                	mov    %eax,%edi
  800385:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800391:	48 b8 a0 03 80 00 00 	movabs $0x8003a0,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
}
  80039d:	90                   	nop
  80039e:	c9                   	leaveq 
  80039f:	c3                   	retq   

00000000008003a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a0:	55                   	push   %rbp
  8003a1:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003a4:	48 b8 eb 21 80 00 00 	movabs $0x8021eb,%rax
  8003ab:	00 00 00 
  8003ae:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003b5:	48 b8 f1 18 80 00 00 	movabs $0x8018f1,%rax
  8003bc:	00 00 00 
  8003bf:	ff d0                	callq  *%rax
}
  8003c1:	90                   	nop
  8003c2:	5d                   	pop    %rbp
  8003c3:	c3                   	retq   

00000000008003c4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
  8003c8:	48 83 ec 10          	sub    $0x10,%rsp
  8003cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d7:	8b 00                	mov    (%rax),%eax
  8003d9:	8d 48 01             	lea    0x1(%rax),%ecx
  8003dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e0:	89 0a                	mov    %ecx,(%rdx)
  8003e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003e5:	89 d1                	mov    %edx,%ecx
  8003e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003eb:	48 98                	cltq   
  8003ed:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003fc:	75 2c                	jne    80042a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800402:	8b 00                	mov    (%rax),%eax
  800404:	48 98                	cltq   
  800406:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80040a:	48 83 c2 08          	add    $0x8,%rdx
  80040e:	48 89 c6             	mov    %rax,%rsi
  800411:	48 89 d7             	mov    %rdx,%rdi
  800414:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
        b->idx = 0;
  800420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800424:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80042a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042e:	8b 40 04             	mov    0x4(%rax),%eax
  800431:	8d 50 01             	lea    0x1(%rax),%edx
  800434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800438:	89 50 04             	mov    %edx,0x4(%rax)
}
  80043b:	90                   	nop
  80043c:	c9                   	leaveq 
  80043d:	c3                   	retq   

000000000080043e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80043e:	55                   	push   %rbp
  80043f:	48 89 e5             	mov    %rsp,%rbp
  800442:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800449:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800450:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800457:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80045e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800465:	48 8b 0a             	mov    (%rdx),%rcx
  800468:	48 89 08             	mov    %rcx,(%rax)
  80046b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800473:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800477:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80047b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800482:	00 00 00 
    b.cnt = 0;
  800485:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80048c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80048f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800496:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80049d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004a4:	48 89 c6             	mov    %rax,%rsi
  8004a7:	48 bf c4 03 80 00 00 	movabs $0x8003c4,%rdi
  8004ae:	00 00 00 
  8004b1:	48 b8 88 08 80 00 00 	movabs $0x800888,%rax
  8004b8:	00 00 00 
  8004bb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004bd:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004c3:	48 98                	cltq   
  8004c5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004cc:	48 83 c2 08          	add    $0x8,%rdx
  8004d0:	48 89 c6             	mov    %rax,%rsi
  8004d3:	48 89 d7             	mov    %rdx,%rdi
  8004d6:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004e2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004e8:	c9                   	leaveq 
  8004e9:	c3                   	retq   

00000000008004ea <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ea:	55                   	push   %rbp
  8004eb:	48 89 e5             	mov    %rsp,%rbp
  8004ee:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004f5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004fc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800503:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80050a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800511:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800518:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80051f:	84 c0                	test   %al,%al
  800521:	74 20                	je     800543 <cprintf+0x59>
  800523:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800527:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80052b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80052f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800533:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800537:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80053b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80053f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800543:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80054a:	00 00 00 
  80054d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800554:	00 00 00 
  800557:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80055b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800562:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800569:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800570:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800577:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80057e:	48 8b 0a             	mov    (%rdx),%rcx
  800581:	48 89 08             	mov    %rcx,(%rax)
  800584:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800588:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80058c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800590:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800594:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80059b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005a2:	48 89 d6             	mov    %rdx,%rsi
  8005a5:	48 89 c7             	mov    %rax,%rdi
  8005a8:	48 b8 3e 04 80 00 00 	movabs $0x80043e,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax
  8005b4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005ba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005c0:	c9                   	leaveq 
  8005c1:	c3                   	retq   

00000000008005c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c2:	55                   	push   %rbp
  8005c3:	48 89 e5             	mov    %rsp,%rbp
  8005c6:	48 83 ec 30          	sub    $0x30,%rsp
  8005ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005d6:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005d9:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005dd:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005e4:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005e8:	77 54                	ja     80063e <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ea:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005ed:	8d 78 ff             	lea    -0x1(%rax),%edi
  8005f0:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	48 f7 f6             	div    %rsi
  8005ff:	49 89 c2             	mov    %rax,%r10
  800602:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800605:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800608:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80060c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800610:	41 89 c9             	mov    %ecx,%r9d
  800613:	41 89 f8             	mov    %edi,%r8d
  800616:	89 d1                	mov    %edx,%ecx
  800618:	4c 89 d2             	mov    %r10,%rdx
  80061b:	48 89 c7             	mov    %rax,%rdi
  80061e:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
  80062a:	eb 1c                	jmp    800648 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800630:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800637:	48 89 ce             	mov    %rcx,%rsi
  80063a:	89 d7                	mov    %edx,%edi
  80063c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800642:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800646:	7f e4                	jg     80062c <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800648:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	ba 00 00 00 00       	mov    $0x0,%edx
  800654:	48 f7 f1             	div    %rcx
  800657:	48 b8 d0 4a 80 00 00 	movabs $0x804ad0,%rax
  80065e:	00 00 00 
  800661:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800665:	0f be d0             	movsbl %al,%edx
  800668:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80066c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800670:	48 89 ce             	mov    %rcx,%rsi
  800673:	89 d7                	mov    %edx,%edi
  800675:	ff d0                	callq  *%rax
}
  800677:	90                   	nop
  800678:	c9                   	leaveq 
  800679:	c3                   	retq   

000000000080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %rbp
  80067b:	48 89 e5             	mov    %rsp,%rbp
  80067e:	48 83 ec 20          	sub    $0x20,%rsp
  800682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800686:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800689:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80068d:	7e 4f                	jle    8006de <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	83 f8 30             	cmp    $0x30,%eax
  800698:	73 24                	jae    8006be <getuint+0x44>
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	8b 00                	mov    (%rax),%eax
  8006a8:	89 c0                	mov    %eax,%eax
  8006aa:	48 01 d0             	add    %rdx,%rax
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	8b 12                	mov    (%rdx),%edx
  8006b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	89 0a                	mov    %ecx,(%rdx)
  8006bc:	eb 14                	jmp    8006d2 <getuint+0x58>
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006c6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d2:	48 8b 00             	mov    (%rax),%rax
  8006d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d9:	e9 9d 00 00 00       	jmpq   80077b <getuint+0x101>
	else if (lflag)
  8006de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006e2:	74 4c                	je     800730 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	83 f8 30             	cmp    $0x30,%eax
  8006ed:	73 24                	jae    800713 <getuint+0x99>
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	89 c0                	mov    %eax,%eax
  8006ff:	48 01 d0             	add    %rdx,%rax
  800702:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800706:	8b 12                	mov    (%rdx),%edx
  800708:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070f:	89 0a                	mov    %ecx,(%rdx)
  800711:	eb 14                	jmp    800727 <getuint+0xad>
  800713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800717:	48 8b 40 08          	mov    0x8(%rax),%rax
  80071b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80071f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800723:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800727:	48 8b 00             	mov    (%rax),%rax
  80072a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072e:	eb 4b                	jmp    80077b <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	8b 00                	mov    (%rax),%eax
  800736:	83 f8 30             	cmp    $0x30,%eax
  800739:	73 24                	jae    80075f <getuint+0xe5>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800747:	8b 00                	mov    (%rax),%eax
  800749:	89 c0                	mov    %eax,%eax
  80074b:	48 01 d0             	add    %rdx,%rax
  80074e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800752:	8b 12                	mov    (%rdx),%edx
  800754:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075b:	89 0a                	mov    %ecx,(%rdx)
  80075d:	eb 14                	jmp    800773 <getuint+0xf9>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 40 08          	mov    0x8(%rax),%rax
  800767:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800773:	8b 00                	mov    (%rax),%eax
  800775:	89 c0                	mov    %eax,%eax
  800777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077f:	c9                   	leaveq 
  800780:	c3                   	retq   

0000000000800781 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800781:	55                   	push   %rbp
  800782:	48 89 e5             	mov    %rsp,%rbp
  800785:	48 83 ec 20          	sub    $0x20,%rsp
  800789:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80078d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800790:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800794:	7e 4f                	jle    8007e5 <getint+0x64>
		x=va_arg(*ap, long long);
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	8b 00                	mov    (%rax),%eax
  80079c:	83 f8 30             	cmp    $0x30,%eax
  80079f:	73 24                	jae    8007c5 <getint+0x44>
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	8b 00                	mov    (%rax),%eax
  8007af:	89 c0                	mov    %eax,%eax
  8007b1:	48 01 d0             	add    %rdx,%rax
  8007b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b8:	8b 12                	mov    (%rdx),%edx
  8007ba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c1:	89 0a                	mov    %ecx,(%rdx)
  8007c3:	eb 14                	jmp    8007d9 <getint+0x58>
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007cd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d9:	48 8b 00             	mov    (%rax),%rax
  8007dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e0:	e9 9d 00 00 00       	jmpq   800882 <getint+0x101>
	else if (lflag)
  8007e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007e9:	74 4c                	je     800837 <getint+0xb6>
		x=va_arg(*ap, long);
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	8b 00                	mov    (%rax),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 24                	jae    80081a <getint+0x99>
  8007f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	8b 00                	mov    (%rax),%eax
  800804:	89 c0                	mov    %eax,%eax
  800806:	48 01 d0             	add    %rdx,%rax
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	8b 12                	mov    (%rdx),%edx
  80080f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800812:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800816:	89 0a                	mov    %ecx,(%rdx)
  800818:	eb 14                	jmp    80082e <getint+0xad>
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800822:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082e:	48 8b 00             	mov    (%rax),%rax
  800831:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800835:	eb 4b                	jmp    800882 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083b:	8b 00                	mov    (%rax),%eax
  80083d:	83 f8 30             	cmp    $0x30,%eax
  800840:	73 24                	jae    800866 <getint+0xe5>
  800842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800846:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	8b 00                	mov    (%rax),%eax
  800850:	89 c0                	mov    %eax,%eax
  800852:	48 01 d0             	add    %rdx,%rax
  800855:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800859:	8b 12                	mov    (%rdx),%edx
  80085b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800862:	89 0a                	mov    %ecx,(%rdx)
  800864:	eb 14                	jmp    80087a <getint+0xf9>
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80086e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800872:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800876:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	48 98                	cltq   
  80087e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800886:	c9                   	leaveq 
  800887:	c3                   	retq   

0000000000800888 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800888:	55                   	push   %rbp
  800889:	48 89 e5             	mov    %rsp,%rbp
  80088c:	41 54                	push   %r12
  80088e:	53                   	push   %rbx
  80088f:	48 83 ec 60          	sub    $0x60,%rsp
  800893:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800897:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80089b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80089f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008a3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008a7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008ab:	48 8b 0a             	mov    (%rdx),%rcx
  8008ae:	48 89 08             	mov    %rcx,(%rax)
  8008b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c1:	eb 17                	jmp    8008da <vprintfmt+0x52>
			if (ch == '\0')
  8008c3:	85 db                	test   %ebx,%ebx
  8008c5:	0f 84 b9 04 00 00    	je     800d84 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8008cb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d3:	48 89 d6             	mov    %rdx,%rsi
  8008d6:	89 df                	mov    %ebx,%edi
  8008d8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008da:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e6:	0f b6 00             	movzbl (%rax),%eax
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	83 fb 25             	cmp    $0x25,%ebx
  8008ef:	75 d2                	jne    8008c3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008f5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008fc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80090a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800911:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800915:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800919:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80091d:	0f b6 00             	movzbl (%rax),%eax
  800920:	0f b6 d8             	movzbl %al,%ebx
  800923:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800926:	83 f8 55             	cmp    $0x55,%eax
  800929:	0f 87 22 04 00 00    	ja     800d51 <vprintfmt+0x4c9>
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800938:	00 
  800939:	48 b8 f8 4a 80 00 00 	movabs $0x804af8,%rax
  800940:	00 00 00 
  800943:	48 01 d0             	add    %rdx,%rax
  800946:	48 8b 00             	mov    (%rax),%rax
  800949:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80094b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80094f:	eb c0                	jmp    800911 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800951:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800955:	eb ba                	jmp    800911 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800957:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80095e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800961:	89 d0                	mov    %edx,%eax
  800963:	c1 e0 02             	shl    $0x2,%eax
  800966:	01 d0                	add    %edx,%eax
  800968:	01 c0                	add    %eax,%eax
  80096a:	01 d8                	add    %ebx,%eax
  80096c:	83 e8 30             	sub    $0x30,%eax
  80096f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800972:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800976:	0f b6 00             	movzbl (%rax),%eax
  800979:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80097c:	83 fb 2f             	cmp    $0x2f,%ebx
  80097f:	7e 60                	jle    8009e1 <vprintfmt+0x159>
  800981:	83 fb 39             	cmp    $0x39,%ebx
  800984:	7f 5b                	jg     8009e1 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800986:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80098b:	eb d1                	jmp    80095e <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80098d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800990:	83 f8 30             	cmp    $0x30,%eax
  800993:	73 17                	jae    8009ac <vprintfmt+0x124>
  800995:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800999:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80099c:	89 d2                	mov    %edx,%edx
  80099e:	48 01 d0             	add    %rdx,%rax
  8009a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009a4:	83 c2 08             	add    $0x8,%edx
  8009a7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009aa:	eb 0c                	jmp    8009b8 <vprintfmt+0x130>
  8009ac:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009b0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009b4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009bd:	eb 23                	jmp    8009e2 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8009bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c3:	0f 89 48 ff ff ff    	jns    800911 <vprintfmt+0x89>
				width = 0;
  8009c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009d0:	e9 3c ff ff ff       	jmpq   800911 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009d5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009dc:	e9 30 ff ff ff       	jmpq   800911 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e6:	0f 89 25 ff ff ff    	jns    800911 <vprintfmt+0x89>
				width = precision, precision = -1;
  8009ec:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009ef:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009f9:	e9 13 ff ff ff       	jmpq   800911 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009fe:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a02:	e9 0a ff ff ff       	jmpq   800911 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0a:	83 f8 30             	cmp    $0x30,%eax
  800a0d:	73 17                	jae    800a26 <vprintfmt+0x19e>
  800a0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a16:	89 d2                	mov    %edx,%edx
  800a18:	48 01 d0             	add    %rdx,%rax
  800a1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1e:	83 c2 08             	add    $0x8,%edx
  800a21:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a24:	eb 0c                	jmp    800a32 <vprintfmt+0x1aa>
  800a26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a2a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a32:	8b 10                	mov    (%rax),%edx
  800a34:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	48 89 ce             	mov    %rcx,%rsi
  800a3f:	89 d7                	mov    %edx,%edi
  800a41:	ff d0                	callq  *%rax
			break;
  800a43:	e9 37 03 00 00       	jmpq   800d7f <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4b:	83 f8 30             	cmp    $0x30,%eax
  800a4e:	73 17                	jae    800a67 <vprintfmt+0x1df>
  800a50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a57:	89 d2                	mov    %edx,%edx
  800a59:	48 01 d0             	add    %rdx,%rax
  800a5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5f:	83 c2 08             	add    $0x8,%edx
  800a62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a65:	eb 0c                	jmp    800a73 <vprintfmt+0x1eb>
  800a67:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a6b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a73:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a75:	85 db                	test   %ebx,%ebx
  800a77:	79 02                	jns    800a7b <vprintfmt+0x1f3>
				err = -err;
  800a79:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a7b:	83 fb 15             	cmp    $0x15,%ebx
  800a7e:	7f 16                	jg     800a96 <vprintfmt+0x20e>
  800a80:	48 b8 20 4a 80 00 00 	movabs $0x804a20,%rax
  800a87:	00 00 00 
  800a8a:	48 63 d3             	movslq %ebx,%rdx
  800a8d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a91:	4d 85 e4             	test   %r12,%r12
  800a94:	75 2e                	jne    800ac4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9e:	89 d9                	mov    %ebx,%ecx
  800aa0:	48 ba e1 4a 80 00 00 	movabs $0x804ae1,%rdx
  800aa7:	00 00 00 
  800aaa:	48 89 c7             	mov    %rax,%rdi
  800aad:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab2:	49 b8 8e 0d 80 00 00 	movabs $0x800d8e,%r8
  800ab9:	00 00 00 
  800abc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abf:	e9 bb 02 00 00       	jmpq   800d7f <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ac8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acc:	4c 89 e1             	mov    %r12,%rcx
  800acf:	48 ba ea 4a 80 00 00 	movabs $0x804aea,%rdx
  800ad6:	00 00 00 
  800ad9:	48 89 c7             	mov    %rax,%rdi
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae1:	49 b8 8e 0d 80 00 00 	movabs $0x800d8e,%r8
  800ae8:	00 00 00 
  800aeb:	41 ff d0             	callq  *%r8
			break;
  800aee:	e9 8c 02 00 00       	jmpq   800d7f <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800af3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af6:	83 f8 30             	cmp    $0x30,%eax
  800af9:	73 17                	jae    800b12 <vprintfmt+0x28a>
  800afb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b02:	89 d2                	mov    %edx,%edx
  800b04:	48 01 d0             	add    %rdx,%rax
  800b07:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0a:	83 c2 08             	add    $0x8,%edx
  800b0d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b10:	eb 0c                	jmp    800b1e <vprintfmt+0x296>
  800b12:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b16:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1e:	4c 8b 20             	mov    (%rax),%r12
  800b21:	4d 85 e4             	test   %r12,%r12
  800b24:	75 0a                	jne    800b30 <vprintfmt+0x2a8>
				p = "(null)";
  800b26:	49 bc ed 4a 80 00 00 	movabs $0x804aed,%r12
  800b2d:	00 00 00 
			if (width > 0 && padc != '-')
  800b30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b34:	7e 78                	jle    800bae <vprintfmt+0x326>
  800b36:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b3a:	74 72                	je     800bae <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b3f:	48 98                	cltq   
  800b41:	48 89 c6             	mov    %rax,%rsi
  800b44:	4c 89 e7             	mov    %r12,%rdi
  800b47:	48 b8 3c 10 80 00 00 	movabs $0x80103c,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
  800b53:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b56:	eb 17                	jmp    800b6f <vprintfmt+0x2e7>
					putch(padc, putdat);
  800b58:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b5c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	48 89 ce             	mov    %rcx,%rsi
  800b67:	89 d7                	mov    %edx,%edi
  800b69:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b73:	7f e3                	jg     800b58 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b75:	eb 37                	jmp    800bae <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b7b:	74 1e                	je     800b9b <vprintfmt+0x313>
  800b7d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b80:	7e 05                	jle    800b87 <vprintfmt+0x2ff>
  800b82:	83 fb 7e             	cmp    $0x7e,%ebx
  800b85:	7e 14                	jle    800b9b <vprintfmt+0x313>
					putch('?', putdat);
  800b87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8f:	48 89 d6             	mov    %rdx,%rsi
  800b92:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b97:	ff d0                	callq  *%rax
  800b99:	eb 0f                	jmp    800baa <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba3:	48 89 d6             	mov    %rdx,%rsi
  800ba6:	89 df                	mov    %ebx,%edi
  800ba8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800baa:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bae:	4c 89 e0             	mov    %r12,%rax
  800bb1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bb5:	0f b6 00             	movzbl (%rax),%eax
  800bb8:	0f be d8             	movsbl %al,%ebx
  800bbb:	85 db                	test   %ebx,%ebx
  800bbd:	74 28                	je     800be7 <vprintfmt+0x35f>
  800bbf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc3:	78 b2                	js     800b77 <vprintfmt+0x2ef>
  800bc5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bc9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bcd:	79 a8                	jns    800b77 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcf:	eb 16                	jmp    800be7 <vprintfmt+0x35f>
				putch(' ', putdat);
  800bd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd9:	48 89 d6             	mov    %rdx,%rsi
  800bdc:	bf 20 00 00 00       	mov    $0x20,%edi
  800be1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800beb:	7f e4                	jg     800bd1 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800bed:	e9 8d 01 00 00       	jmpq   800d7f <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bf2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf6:	be 03 00 00 00       	mov    $0x3,%esi
  800bfb:	48 89 c7             	mov    %rax,%rdi
  800bfe:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  800c05:	00 00 00 
  800c08:	ff d0                	callq  *%rax
  800c0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c12:	48 85 c0             	test   %rax,%rax
  800c15:	79 1d                	jns    800c34 <vprintfmt+0x3ac>
				putch('-', putdat);
  800c17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1f:	48 89 d6             	mov    %rdx,%rsi
  800c22:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c27:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2d:	48 f7 d8             	neg    %rax
  800c30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c34:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3b:	e9 d2 00 00 00       	jmpq   800d12 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c44:	be 03 00 00 00       	mov    $0x3,%esi
  800c49:	48 89 c7             	mov    %rax,%rdi
  800c4c:	48 b8 7a 06 80 00 00 	movabs $0x80067a,%rax
  800c53:	00 00 00 
  800c56:	ff d0                	callq  *%rax
  800c58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c5c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c63:	e9 aa 00 00 00       	jmpq   800d12 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800c68:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6c:	be 03 00 00 00       	mov    $0x3,%esi
  800c71:	48 89 c7             	mov    %rax,%rdi
  800c74:	48 b8 7a 06 80 00 00 	movabs $0x80067a,%rax
  800c7b:	00 00 00 
  800c7e:	ff d0                	callq  *%rax
  800c80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c84:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c8b:	e9 82 00 00 00       	jmpq   800d12 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800c90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c98:	48 89 d6             	mov    %rdx,%rsi
  800c9b:	bf 30 00 00 00       	mov    $0x30,%edi
  800ca0:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ca2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800caa:	48 89 d6             	mov    %rdx,%rsi
  800cad:	bf 78 00 00 00       	mov    $0x78,%edi
  800cb2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb7:	83 f8 30             	cmp    $0x30,%eax
  800cba:	73 17                	jae    800cd3 <vprintfmt+0x44b>
  800cbc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc3:	89 d2                	mov    %edx,%edx
  800cc5:	48 01 d0             	add    %rdx,%rax
  800cc8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccb:	83 c2 08             	add    $0x8,%edx
  800cce:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd1:	eb 0c                	jmp    800cdf <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800cd3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cd7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cdb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cdf:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ce6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ced:	eb 23                	jmp    800d12 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf3:	be 03 00 00 00       	mov    $0x3,%esi
  800cf8:	48 89 c7             	mov    %rax,%rdi
  800cfb:	48 b8 7a 06 80 00 00 	movabs $0x80067a,%rax
  800d02:	00 00 00 
  800d05:	ff d0                	callq  *%rax
  800d07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d0b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d12:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d17:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d1a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d21:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d29:	45 89 c1             	mov    %r8d,%r9d
  800d2c:	41 89 f8             	mov    %edi,%r8d
  800d2f:	48 89 c7             	mov    %rax,%rdi
  800d32:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800d39:	00 00 00 
  800d3c:	ff d0                	callq  *%rax
			break;
  800d3e:	eb 3f                	jmp    800d7f <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d48:	48 89 d6             	mov    %rdx,%rsi
  800d4b:	89 df                	mov    %ebx,%edi
  800d4d:	ff d0                	callq  *%rax
			break;
  800d4f:	eb 2e                	jmp    800d7f <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d59:	48 89 d6             	mov    %rdx,%rsi
  800d5c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d61:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d63:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d68:	eb 05                	jmp    800d6f <vprintfmt+0x4e7>
  800d6a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d6f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d73:	48 83 e8 01          	sub    $0x1,%rax
  800d77:	0f b6 00             	movzbl (%rax),%eax
  800d7a:	3c 25                	cmp    $0x25,%al
  800d7c:	75 ec                	jne    800d6a <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d7e:	90                   	nop
		}
	}
  800d7f:	e9 3d fb ff ff       	jmpq   8008c1 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d84:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d85:	48 83 c4 60          	add    $0x60,%rsp
  800d89:	5b                   	pop    %rbx
  800d8a:	41 5c                	pop    %r12
  800d8c:	5d                   	pop    %rbp
  800d8d:	c3                   	retq   

0000000000800d8e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
  800d92:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d99:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800da0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800dae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800db5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dbc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 20                	je     800de7 <printfmt+0x59>
  800dc7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dcb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dcf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ddb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ddf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dee:	00 00 00 
  800df1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800df8:	00 00 00 
  800dfb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e06:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e14:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e1b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e22:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e29:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e30:	48 89 c7             	mov    %rax,%rdi
  800e33:	48 b8 88 08 80 00 00 	movabs $0x800888,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e3f:	90                   	nop
  800e40:	c9                   	leaveq 
  800e41:	c3                   	retq   

0000000000800e42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e42:	55                   	push   %rbp
  800e43:	48 89 e5             	mov    %rsp,%rbp
  800e46:	48 83 ec 10          	sub    $0x10,%rsp
  800e4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e55:	8b 40 10             	mov    0x10(%rax),%eax
  800e58:	8d 50 01             	lea    0x1(%rax),%edx
  800e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e66:	48 8b 10             	mov    (%rax),%rdx
  800e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e71:	48 39 c2             	cmp    %rax,%rdx
  800e74:	73 17                	jae    800e8d <sprintputch+0x4b>
		*b->buf++ = ch;
  800e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7a:	48 8b 00             	mov    (%rax),%rax
  800e7d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e85:	48 89 0a             	mov    %rcx,(%rdx)
  800e88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e8b:	88 10                	mov    %dl,(%rax)
}
  800e8d:	90                   	nop
  800e8e:	c9                   	leaveq 
  800e8f:	c3                   	retq   

0000000000800e90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e90:	55                   	push   %rbp
  800e91:	48 89 e5             	mov    %rsp,%rbp
  800e94:	48 83 ec 50          	sub    $0x50,%rsp
  800e98:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e9c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e9f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eab:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eaf:	48 8b 0a             	mov    (%rdx),%rcx
  800eb2:	48 89 08             	mov    %rcx,(%rax)
  800eb5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ebd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ec1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ecd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ed0:	48 98                	cltq   
  800ed2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ed6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eda:	48 01 d0             	add    %rdx,%rax
  800edd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ee1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eed:	74 06                	je     800ef5 <vsnprintf+0x65>
  800eef:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef3:	7f 07                	jg     800efc <vsnprintf+0x6c>
		return -E_INVAL;
  800ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efa:	eb 2f                	jmp    800f2b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800efc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f00:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f04:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f08:	48 89 c6             	mov    %rax,%rsi
  800f0b:	48 bf 42 0e 80 00 00 	movabs $0x800e42,%rdi
  800f12:	00 00 00 
  800f15:	48 b8 88 08 80 00 00 	movabs $0x800888,%rax
  800f1c:	00 00 00 
  800f1f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f25:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f28:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f2b:	c9                   	leaveq 
  800f2c:	c3                   	retq   

0000000000800f2d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2d:	55                   	push   %rbp
  800f2e:	48 89 e5             	mov    %rsp,%rbp
  800f31:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f38:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f3f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f45:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800f4c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f53:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f5a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f61:	84 c0                	test   %al,%al
  800f63:	74 20                	je     800f85 <snprintf+0x58>
  800f65:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f69:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f6d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f71:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f75:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f79:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f7d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f81:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f85:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f8c:	00 00 00 
  800f8f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f96:	00 00 00 
  800f99:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fab:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fb2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fc0:	48 8b 0a             	mov    (%rdx),%rcx
  800fc3:	48 89 08             	mov    %rcx,(%rax)
  800fc6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fca:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fce:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fd2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fdd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fea:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ff1:	48 89 c7             	mov    %rax,%rdi
  800ff4:	48 b8 90 0e 80 00 00 	movabs $0x800e90,%rax
  800ffb:	00 00 00 
  800ffe:	ff d0                	callq  *%rax
  801000:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801006:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80100c:	c9                   	leaveq 
  80100d:	c3                   	retq   

000000000080100e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 83 ec 18          	sub    $0x18,%rsp
  801016:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801021:	eb 09                	jmp    80102c <strlen+0x1e>
		n++;
  801023:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801027:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	84 c0                	test   %al,%al
  801035:	75 ec                	jne    801023 <strlen+0x15>
		n++;
	return n;
  801037:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103a:	c9                   	leaveq 
  80103b:	c3                   	retq   

000000000080103c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	48 83 ec 20          	sub    $0x20,%rsp
  801044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801053:	eb 0e                	jmp    801063 <strnlen+0x27>
		n++;
  801055:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801059:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801063:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801068:	74 0b                	je     801075 <strnlen+0x39>
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	84 c0                	test   %al,%al
  801073:	75 e0                	jne    801055 <strnlen+0x19>
		n++;
	return n;
  801075:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 20          	sub    $0x20,%rsp
  801082:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801086:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80108a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801092:	90                   	nop
  801093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801097:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80109f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ab:	0f b6 12             	movzbl (%rdx),%edx
  8010ae:	88 10                	mov    %dl,(%rax)
  8010b0:	0f b6 00             	movzbl (%rax),%eax
  8010b3:	84 c0                	test   %al,%al
  8010b5:	75 dc                	jne    801093 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010bb:	c9                   	leaveq 
  8010bc:	c3                   	retq   

00000000008010bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010bd:	55                   	push   %rbp
  8010be:	48 89 e5             	mov    %rsp,%rbp
  8010c1:	48 83 ec 20          	sub    $0x20,%rsp
  8010c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d1:	48 89 c7             	mov    %rax,%rdi
  8010d4:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  8010db:	00 00 00 
  8010de:	ff d0                	callq  *%rax
  8010e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e6:	48 63 d0             	movslq %eax,%rdx
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ed:	48 01 c2             	add    %rax,%rdx
  8010f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f4:	48 89 c6             	mov    %rax,%rsi
  8010f7:	48 89 d7             	mov    %rdx,%rdi
  8010fa:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  801101:	00 00 00 
  801104:	ff d0                	callq  *%rax
	return dst;
  801106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80110a:	c9                   	leaveq 
  80110b:	c3                   	retq   

000000000080110c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80110c:	55                   	push   %rbp
  80110d:	48 89 e5             	mov    %rsp,%rbp
  801110:	48 83 ec 28          	sub    $0x28,%rsp
  801114:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801118:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801124:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801128:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112f:	00 
  801130:	eb 2a                	jmp    80115c <strncpy+0x50>
		*dst++ = *src;
  801132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801136:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801142:	0f b6 12             	movzbl (%rdx),%edx
  801145:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801147:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114b:	0f b6 00             	movzbl (%rax),%eax
  80114e:	84 c0                	test   %al,%al
  801150:	74 05                	je     801157 <strncpy+0x4b>
			src++;
  801152:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801157:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80115c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801160:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801164:	72 cc                	jb     801132 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 28          	sub    $0x28,%rsp
  801174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801184:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801188:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118d:	74 3d                	je     8011cc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80118f:	eb 1d                	jmp    8011ae <strlcpy+0x42>
			*dst++ = *src++;
  801191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801195:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801199:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a9:	0f b6 12             	movzbl (%rdx),%edx
  8011ac:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b8:	74 0b                	je     8011c5 <strlcpy+0x59>
  8011ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	84 c0                	test   %al,%al
  8011c3:	75 cc                	jne    801191 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d4:	48 29 c2             	sub    %rax,%rdx
  8011d7:	48 89 d0             	mov    %rdx,%rax
}
  8011da:	c9                   	leaveq 
  8011db:	c3                   	retq   

00000000008011dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	48 83 ec 10          	sub    $0x10,%rsp
  8011e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ec:	eb 0a                	jmp    8011f8 <strcmp+0x1c>
		p++, q++;
  8011ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 00             	movzbl (%rax),%eax
  8011ff:	84 c0                	test   %al,%al
  801201:	74 12                	je     801215 <strcmp+0x39>
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	0f b6 10             	movzbl (%rax),%edx
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	38 c2                	cmp    %al,%dl
  801213:	74 d9                	je     8011ee <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	0f b6 d0             	movzbl %al,%edx
  80121f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801223:	0f b6 00             	movzbl (%rax),%eax
  801226:	0f b6 c0             	movzbl %al,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
}
  80122d:	c9                   	leaveq 
  80122e:	c3                   	retq   

000000000080122f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80122f:	55                   	push   %rbp
  801230:	48 89 e5             	mov    %rsp,%rbp
  801233:	48 83 ec 18          	sub    $0x18,%rsp
  801237:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80123f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801243:	eb 0f                	jmp    801254 <strncmp+0x25>
		n--, p++, q++;
  801245:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80124a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801254:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801259:	74 1d                	je     801278 <strncmp+0x49>
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	74 12                	je     801278 <strncmp+0x49>
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	0f b6 10             	movzbl (%rax),%edx
  80126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	38 c2                	cmp    %al,%dl
  801276:	74 cd                	je     801245 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801278:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127d:	75 07                	jne    801286 <strncmp+0x57>
		return 0;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	eb 18                	jmp    80129e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128a:	0f b6 00             	movzbl (%rax),%eax
  80128d:	0f b6 d0             	movzbl %al,%edx
  801290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801294:	0f b6 00             	movzbl (%rax),%eax
  801297:	0f b6 c0             	movzbl %al,%eax
  80129a:	29 c2                	sub    %eax,%edx
  80129c:	89 d0                	mov    %edx,%eax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 10          	sub    $0x10,%rsp
  8012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ac:	89 f0                	mov    %esi,%eax
  8012ae:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b1:	eb 17                	jmp    8012ca <strchr+0x2a>
		if (*s == c)
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	0f b6 00             	movzbl (%rax),%eax
  8012ba:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012bd:	75 06                	jne    8012c5 <strchr+0x25>
			return (char *) s;
  8012bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c3:	eb 15                	jmp    8012da <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	0f b6 00             	movzbl (%rax),%eax
  8012d1:	84 c0                	test   %al,%al
  8012d3:	75 de                	jne    8012b3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012da:	c9                   	leaveq 
  8012db:	c3                   	retq   

00000000008012dc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	48 83 ec 10          	sub    $0x10,%rsp
  8012e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e8:	89 f0                	mov    %esi,%eax
  8012ea:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ed:	eb 11                	jmp    801300 <strfind+0x24>
		if (*s == c)
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 00             	movzbl (%rax),%eax
  8012f6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f9:	74 12                	je     80130d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801304:	0f b6 00             	movzbl (%rax),%eax
  801307:	84 c0                	test   %al,%al
  801309:	75 e4                	jne    8012ef <strfind+0x13>
  80130b:	eb 01                	jmp    80130e <strfind+0x32>
		if (*s == c)
			break;
  80130d:	90                   	nop
	return (char *) s;
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801312:	c9                   	leaveq 
  801313:	c3                   	retq   

0000000000801314 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801314:	55                   	push   %rbp
  801315:	48 89 e5             	mov    %rsp,%rbp
  801318:	48 83 ec 18          	sub    $0x18,%rsp
  80131c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801320:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801323:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801327:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80132c:	75 06                	jne    801334 <memset+0x20>
		return v;
  80132e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801332:	eb 69                	jmp    80139d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801338:	83 e0 03             	and    $0x3,%eax
  80133b:	48 85 c0             	test   %rax,%rax
  80133e:	75 48                	jne    801388 <memset+0x74>
  801340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801344:	83 e0 03             	and    $0x3,%eax
  801347:	48 85 c0             	test   %rax,%rax
  80134a:	75 3c                	jne    801388 <memset+0x74>
		c &= 0xFF;
  80134c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801353:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801356:	c1 e0 18             	shl    $0x18,%eax
  801359:	89 c2                	mov    %eax,%edx
  80135b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135e:	c1 e0 10             	shl    $0x10,%eax
  801361:	09 c2                	or     %eax,%edx
  801363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801366:	c1 e0 08             	shl    $0x8,%eax
  801369:	09 d0                	or     %edx,%eax
  80136b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80136e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801372:	48 c1 e8 02          	shr    $0x2,%rax
  801376:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801379:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801380:	48 89 d7             	mov    %rdx,%rdi
  801383:	fc                   	cld    
  801384:	f3 ab                	rep stos %eax,%es:(%rdi)
  801386:	eb 11                	jmp    801399 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801388:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80138c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801393:	48 89 d7             	mov    %rdx,%rdi
  801396:	fc                   	cld    
  801397:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 28          	sub    $0x28,%rsp
  8013a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013cb:	0f 83 88 00 00 00    	jae    801459 <memmove+0xba>
  8013d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	48 01 d0             	add    %rdx,%rax
  8013dc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e0:	76 77                	jbe    801459 <memmove+0xba>
		s += n;
  8013e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ee:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f6:	83 e0 03             	and    $0x3,%eax
  8013f9:	48 85 c0             	test   %rax,%rax
  8013fc:	75 3b                	jne    801439 <memmove+0x9a>
  8013fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801402:	83 e0 03             	and    $0x3,%eax
  801405:	48 85 c0             	test   %rax,%rax
  801408:	75 2f                	jne    801439 <memmove+0x9a>
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	83 e0 03             	and    $0x3,%eax
  801411:	48 85 c0             	test   %rax,%rax
  801414:	75 23                	jne    801439 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141a:	48 83 e8 04          	sub    $0x4,%rax
  80141e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801422:	48 83 ea 04          	sub    $0x4,%rdx
  801426:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80142a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80142e:	48 89 c7             	mov    %rax,%rdi
  801431:	48 89 d6             	mov    %rdx,%rsi
  801434:	fd                   	std    
  801435:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801437:	eb 1d                	jmp    801456 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801445:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144d:	48 89 d7             	mov    %rdx,%rdi
  801450:	48 89 c1             	mov    %rax,%rcx
  801453:	fd                   	std    
  801454:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801456:	fc                   	cld    
  801457:	eb 57                	jmp    8014b0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145d:	83 e0 03             	and    $0x3,%eax
  801460:	48 85 c0             	test   %rax,%rax
  801463:	75 36                	jne    80149b <memmove+0xfc>
  801465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801469:	83 e0 03             	and    $0x3,%eax
  80146c:	48 85 c0             	test   %rax,%rax
  80146f:	75 2a                	jne    80149b <memmove+0xfc>
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	83 e0 03             	and    $0x3,%eax
  801478:	48 85 c0             	test   %rax,%rax
  80147b:	75 1e                	jne    80149b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	48 c1 e8 02          	shr    $0x2,%rax
  801485:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801490:	48 89 c7             	mov    %rax,%rdi
  801493:	48 89 d6             	mov    %rdx,%rsi
  801496:	fc                   	cld    
  801497:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801499:	eb 15                	jmp    8014b0 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a7:	48 89 c7             	mov    %rax,%rdi
  8014aa:	48 89 d6             	mov    %rdx,%rsi
  8014ad:	fc                   	cld    
  8014ae:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b4:	c9                   	leaveq 
  8014b5:	c3                   	retq   

00000000008014b6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b6:	55                   	push   %rbp
  8014b7:	48 89 e5             	mov    %rsp,%rbp
  8014ba:	48 83 ec 18          	sub    $0x18,%rsp
  8014be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ce:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d6:	48 89 ce             	mov    %rcx,%rsi
  8014d9:	48 89 c7             	mov    %rax,%rdi
  8014dc:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8014e3:	00 00 00 
  8014e6:	ff d0                	callq  *%rax
}
  8014e8:	c9                   	leaveq 
  8014e9:	c3                   	retq   

00000000008014ea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ea:	55                   	push   %rbp
  8014eb:	48 89 e5             	mov    %rsp,%rbp
  8014ee:	48 83 ec 28          	sub    $0x28,%rsp
  8014f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801506:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80150a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80150e:	eb 36                	jmp    801546 <memcmp+0x5c>
		if (*s1 != *s2)
  801510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801514:	0f b6 10             	movzbl (%rax),%edx
  801517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151b:	0f b6 00             	movzbl (%rax),%eax
  80151e:	38 c2                	cmp    %al,%dl
  801520:	74 1a                	je     80153c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	0f b6 00             	movzbl (%rax),%eax
  801529:	0f b6 d0             	movzbl %al,%edx
  80152c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	0f b6 c0             	movzbl %al,%eax
  801536:	29 c2                	sub    %eax,%edx
  801538:	89 d0                	mov    %edx,%eax
  80153a:	eb 20                	jmp    80155c <memcmp+0x72>
		s1++, s2++;
  80153c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801541:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80154e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801552:	48 85 c0             	test   %rax,%rax
  801555:	75 b9                	jne    801510 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155c:	c9                   	leaveq 
  80155d:	c3                   	retq   

000000000080155e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80155e:	55                   	push   %rbp
  80155f:	48 89 e5             	mov    %rsp,%rbp
  801562:	48 83 ec 28          	sub    $0x28,%rsp
  801566:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80156a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80156d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801571:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	48 01 d0             	add    %rdx,%rax
  80157c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801580:	eb 19                	jmp    80159b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	0f b6 d0             	movzbl %al,%edx
  80158c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80158f:	0f b6 c0             	movzbl %al,%eax
  801592:	39 c2                	cmp    %eax,%edx
  801594:	74 11                	je     8015a7 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801596:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015a3:	72 dd                	jb     801582 <memfind+0x24>
  8015a5:	eb 01                	jmp    8015a8 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015a7:	90                   	nop
	return (void *) s;
  8015a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ac:	c9                   	leaveq 
  8015ad:	c3                   	retq   

00000000008015ae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ae:	55                   	push   %rbp
  8015af:	48 89 e5             	mov    %rsp,%rbp
  8015b2:	48 83 ec 38          	sub    $0x38,%rsp
  8015b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015be:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015c8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015cf:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d0:	eb 05                	jmp    8015d7 <strtol+0x29>
		s++;
  8015d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015db:	0f b6 00             	movzbl (%rax),%eax
  8015de:	3c 20                	cmp    $0x20,%al
  8015e0:	74 f0                	je     8015d2 <strtol+0x24>
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 e5                	je     8015d2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	0f b6 00             	movzbl (%rax),%eax
  8015f4:	3c 2b                	cmp    $0x2b,%al
  8015f6:	75 07                	jne    8015ff <strtol+0x51>
		s++;
  8015f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fd:	eb 17                	jmp    801616 <strtol+0x68>
	else if (*s == '-')
  8015ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801603:	0f b6 00             	movzbl (%rax),%eax
  801606:	3c 2d                	cmp    $0x2d,%al
  801608:	75 0c                	jne    801616 <strtol+0x68>
		s++, neg = 1;
  80160a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801616:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161a:	74 06                	je     801622 <strtol+0x74>
  80161c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801620:	75 28                	jne    80164a <strtol+0x9c>
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	0f b6 00             	movzbl (%rax),%eax
  801629:	3c 30                	cmp    $0x30,%al
  80162b:	75 1d                	jne    80164a <strtol+0x9c>
  80162d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801631:	48 83 c0 01          	add    $0x1,%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	3c 78                	cmp    $0x78,%al
  80163a:	75 0e                	jne    80164a <strtol+0x9c>
		s += 2, base = 16;
  80163c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801641:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801648:	eb 2c                	jmp    801676 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80164a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80164e:	75 19                	jne    801669 <strtol+0xbb>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 30                	cmp    $0x30,%al
  801659:	75 0e                	jne    801669 <strtol+0xbb>
		s++, base = 8;
  80165b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801660:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801667:	eb 0d                	jmp    801676 <strtol+0xc8>
	else if (base == 0)
  801669:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166d:	75 07                	jne    801676 <strtol+0xc8>
		base = 10;
  80166f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	3c 2f                	cmp    $0x2f,%al
  80167f:	7e 1d                	jle    80169e <strtol+0xf0>
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	3c 39                	cmp    $0x39,%al
  80168a:	7f 12                	jg     80169e <strtol+0xf0>
			dig = *s - '0';
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	0f be c0             	movsbl %al,%eax
  801696:	83 e8 30             	sub    $0x30,%eax
  801699:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169c:	eb 4e                	jmp    8016ec <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 60                	cmp    $0x60,%al
  8016a7:	7e 1d                	jle    8016c6 <strtol+0x118>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	3c 7a                	cmp    $0x7a,%al
  8016b2:	7f 12                	jg     8016c6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	0f be c0             	movsbl %al,%eax
  8016be:	83 e8 57             	sub    $0x57,%eax
  8016c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c4:	eb 26                	jmp    8016ec <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3c 40                	cmp    $0x40,%al
  8016cf:	7e 47                	jle    801718 <strtol+0x16a>
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	3c 5a                	cmp    $0x5a,%al
  8016da:	7f 3c                	jg     801718 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	0f be c0             	movsbl %al,%eax
  8016e6:	83 e8 37             	sub    $0x37,%eax
  8016e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ef:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016f2:	7d 23                	jge    801717 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016fc:	48 98                	cltq   
  8016fe:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801703:	48 89 c2             	mov    %rax,%rdx
  801706:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801709:	48 98                	cltq   
  80170b:	48 01 d0             	add    %rdx,%rax
  80170e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801712:	e9 5f ff ff ff       	jmpq   801676 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801717:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801718:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80171d:	74 0b                	je     80172a <strtol+0x17c>
		*endptr = (char *) s;
  80171f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801723:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801727:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80172a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80172e:	74 09                	je     801739 <strtol+0x18b>
  801730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801734:	48 f7 d8             	neg    %rax
  801737:	eb 04                	jmp    80173d <strtol+0x18f>
  801739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <strstr>:

char * strstr(const char *in, const char *str)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 30          	sub    $0x30,%rsp
  801747:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80174f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801753:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801757:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80175b:	0f b6 00             	movzbl (%rax),%eax
  80175e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801761:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801765:	75 06                	jne    80176d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	eb 6b                	jmp    8017d8 <strstr+0x99>

	len = strlen(str);
  80176d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801771:	48 89 c7             	mov    %rax,%rdi
  801774:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
  801780:	48 98                	cltq   
  801782:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80178e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801792:	0f b6 00             	movzbl (%rax),%eax
  801795:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801798:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80179c:	75 07                	jne    8017a5 <strstr+0x66>
				return (char *) 0;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	eb 33                	jmp    8017d8 <strstr+0x99>
		} while (sc != c);
  8017a5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017a9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017ac:	75 d8                	jne    801786 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ba:	48 89 ce             	mov    %rcx,%rsi
  8017bd:	48 89 c7             	mov    %rax,%rdi
  8017c0:	48 b8 2f 12 80 00 00 	movabs $0x80122f,%rax
  8017c7:	00 00 00 
  8017ca:	ff d0                	callq  *%rax
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	75 b6                	jne    801786 <strstr+0x47>

	return (char *) (in - 1);
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	48 83 e8 01          	sub    $0x1,%rax
}
  8017d8:	c9                   	leaveq 
  8017d9:	c3                   	retq   

00000000008017da <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	53                   	push   %rbx
  8017df:	48 83 ec 48          	sub    $0x48,%rsp
  8017e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017e6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017e9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ed:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017f1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017f5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017fc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801800:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801804:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801808:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80180c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801810:	4c 89 c3             	mov    %r8,%rbx
  801813:	cd 30                	int    $0x30
  801815:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801819:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80181d:	74 3e                	je     80185d <syscall+0x83>
  80181f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801824:	7e 37                	jle    80185d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80182d:	49 89 d0             	mov    %rdx,%r8
  801830:	89 c1                	mov    %eax,%ecx
  801832:	48 ba a8 4d 80 00 00 	movabs $0x804da8,%rdx
  801839:	00 00 00 
  80183c:	be 24 00 00 00       	mov    $0x24,%esi
  801841:	48 bf c5 4d 80 00 00 	movabs $0x804dc5,%rdi
  801848:	00 00 00 
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	49 b9 56 3f 80 00 00 	movabs $0x803f56,%r9
  801857:	00 00 00 
  80185a:	41 ff d1             	callq  *%r9

	return ret;
  80185d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801861:	48 83 c4 48          	add    $0x48,%rsp
  801865:	5b                   	pop    %rbx
  801866:	5d                   	pop    %rbp
  801867:	c3                   	retq   

0000000000801868 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 10          	sub    $0x10,%rsp
  801870:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801874:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801880:	48 83 ec 08          	sub    $0x8,%rsp
  801884:	6a 00                	pushq  $0x0
  801886:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801892:	48 89 d1             	mov    %rdx,%rcx
  801895:	48 89 c2             	mov    %rax,%rdx
  801898:	be 00 00 00 00       	mov    $0x0,%esi
  80189d:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a2:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8018a9:	00 00 00 
  8018ac:	ff d0                	callq  *%rax
  8018ae:	48 83 c4 10          	add    $0x10,%rsp
}
  8018b2:	90                   	nop
  8018b3:	c9                   	leaveq 
  8018b4:	c3                   	retq   

00000000008018b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b5:	55                   	push   %rbp
  8018b6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018b9:	48 83 ec 08          	sub    $0x8,%rsp
  8018bd:	6a 00                	pushq  $0x0
  8018bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d5:	be 00 00 00 00       	mov    $0x0,%esi
  8018da:	bf 01 00 00 00       	mov    $0x1,%edi
  8018df:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	callq  *%rax
  8018eb:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ef:	c9                   	leaveq 
  8018f0:	c3                   	retq   

00000000008018f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018f1:	55                   	push   %rbp
  8018f2:	48 89 e5             	mov    %rsp,%rbp
  8018f5:	48 83 ec 10          	sub    $0x10,%rsp
  8018f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ff:	48 98                	cltq   
  801901:	48 83 ec 08          	sub    $0x8,%rsp
  801905:	6a 00                	pushq  $0x0
  801907:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801913:	b9 00 00 00 00       	mov    $0x0,%ecx
  801918:	48 89 c2             	mov    %rax,%rdx
  80191b:	be 01 00 00 00       	mov    $0x1,%esi
  801920:	bf 03 00 00 00       	mov    $0x3,%edi
  801925:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  80192c:	00 00 00 
  80192f:	ff d0                	callq  *%rax
  801931:	48 83 c4 10          	add    $0x10,%rsp
}
  801935:	c9                   	leaveq 
  801936:	c3                   	retq   

0000000000801937 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801937:	55                   	push   %rbp
  801938:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80193b:	48 83 ec 08          	sub    $0x8,%rsp
  80193f:	6a 00                	pushq  $0x0
  801941:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801947:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	be 00 00 00 00       	mov    $0x0,%esi
  80195c:	bf 02 00 00 00       	mov    $0x2,%edi
  801961:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801968:	00 00 00 
  80196b:	ff d0                	callq  *%rax
  80196d:	48 83 c4 10          	add    $0x10,%rsp
}
  801971:	c9                   	leaveq 
  801972:	c3                   	retq   

0000000000801973 <sys_yield>:


void
sys_yield(void)
{
  801973:	55                   	push   %rbp
  801974:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801977:	48 83 ec 08          	sub    $0x8,%rsp
  80197b:	6a 00                	pushq  $0x0
  80197d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801983:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801989:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	be 00 00 00 00       	mov    $0x0,%esi
  801998:	bf 0b 00 00 00       	mov    $0xb,%edi
  80199d:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8019a4:	00 00 00 
  8019a7:	ff d0                	callq  *%rax
  8019a9:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	48 83 ec 10          	sub    $0x10,%rsp
  8019b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019bf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c5:	48 63 c8             	movslq %eax,%rcx
  8019c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cf:	48 98                	cltq   
  8019d1:	48 83 ec 08          	sub    $0x8,%rsp
  8019d5:	6a 00                	pushq  $0x0
  8019d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019dd:	49 89 c8             	mov    %rcx,%r8
  8019e0:	48 89 d1             	mov    %rdx,%rcx
  8019e3:	48 89 c2             	mov    %rax,%rdx
  8019e6:	be 01 00 00 00       	mov    $0x1,%esi
  8019eb:	bf 04 00 00 00       	mov    $0x4,%edi
  8019f0:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
  8019fc:	48 83 c4 10          	add    $0x10,%rsp
}
  801a00:	c9                   	leaveq 
  801a01:	c3                   	retq   

0000000000801a02 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a02:	55                   	push   %rbp
  801a03:	48 89 e5             	mov    %rsp,%rbp
  801a06:	48 83 ec 20          	sub    $0x20,%rsp
  801a0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a11:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a14:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a18:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a1c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a1f:	48 63 c8             	movslq %eax,%rcx
  801a22:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a29:	48 63 f0             	movslq %eax,%rsi
  801a2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 83 ec 08          	sub    $0x8,%rsp
  801a39:	51                   	push   %rcx
  801a3a:	49 89 f9             	mov    %rdi,%r9
  801a3d:	49 89 f0             	mov    %rsi,%r8
  801a40:	48 89 d1             	mov    %rdx,%rcx
  801a43:	48 89 c2             	mov    %rax,%rdx
  801a46:	be 01 00 00 00       	mov    $0x1,%esi
  801a4b:	bf 05 00 00 00       	mov    $0x5,%edi
  801a50:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	callq  *%rax
  801a5c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a60:	c9                   	leaveq 
  801a61:	c3                   	retq   

0000000000801a62 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a62:	55                   	push   %rbp
  801a63:	48 89 e5             	mov    %rsp,%rbp
  801a66:	48 83 ec 10          	sub    $0x10,%rsp
  801a6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a78:	48 98                	cltq   
  801a7a:	48 83 ec 08          	sub    $0x8,%rsp
  801a7e:	6a 00                	pushq  $0x0
  801a80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8c:	48 89 d1             	mov    %rdx,%rcx
  801a8f:	48 89 c2             	mov    %rax,%rdx
  801a92:	be 01 00 00 00       	mov    $0x1,%esi
  801a97:	bf 06 00 00 00       	mov    $0x6,%edi
  801a9c:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801aa3:	00 00 00 
  801aa6:	ff d0                	callq  *%rax
  801aa8:	48 83 c4 10          	add    $0x10,%rsp
}
  801aac:	c9                   	leaveq 
  801aad:	c3                   	retq   

0000000000801aae <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aae:	55                   	push   %rbp
  801aaf:	48 89 e5             	mov    %rsp,%rbp
  801ab2:	48 83 ec 10          	sub    $0x10,%rsp
  801ab6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801abc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abf:	48 63 d0             	movslq %eax,%rdx
  801ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac5:	48 98                	cltq   
  801ac7:	48 83 ec 08          	sub    $0x8,%rsp
  801acb:	6a 00                	pushq  $0x0
  801acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad9:	48 89 d1             	mov    %rdx,%rcx
  801adc:	48 89 c2             	mov    %rax,%rdx
  801adf:	be 01 00 00 00       	mov    $0x1,%esi
  801ae4:	bf 08 00 00 00       	mov    $0x8,%edi
  801ae9:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801af0:	00 00 00 
  801af3:	ff d0                	callq  *%rax
  801af5:	48 83 c4 10          	add    $0x10,%rsp
}
  801af9:	c9                   	leaveq 
  801afa:	c3                   	retq   

0000000000801afb <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 10          	sub    $0x10,%rsp
  801b03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b11:	48 98                	cltq   
  801b13:	48 83 ec 08          	sub    $0x8,%rsp
  801b17:	6a 00                	pushq  $0x0
  801b19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b25:	48 89 d1             	mov    %rdx,%rcx
  801b28:	48 89 c2             	mov    %rax,%rdx
  801b2b:	be 01 00 00 00       	mov    $0x1,%esi
  801b30:	bf 09 00 00 00       	mov    $0x9,%edi
  801b35:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	callq  *%rax
  801b41:	48 83 c4 10          	add    $0x10,%rsp
}
  801b45:	c9                   	leaveq 
  801b46:	c3                   	retq   

0000000000801b47 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b47:	55                   	push   %rbp
  801b48:	48 89 e5             	mov    %rsp,%rbp
  801b4b:	48 83 ec 10          	sub    $0x10,%rsp
  801b4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5d:	48 98                	cltq   
  801b5f:	48 83 ec 08          	sub    $0x8,%rsp
  801b63:	6a 00                	pushq  $0x0
  801b65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b71:	48 89 d1             	mov    %rdx,%rcx
  801b74:	48 89 c2             	mov    %rax,%rdx
  801b77:	be 01 00 00 00       	mov    $0x1,%esi
  801b7c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b81:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	callq  *%rax
  801b8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801b91:	c9                   	leaveq 
  801b92:	c3                   	retq   

0000000000801b93 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	48 83 ec 20          	sub    $0x20,%rsp
  801b9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ba6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ba9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bac:	48 63 f0             	movslq %eax,%rsi
  801baf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb6:	48 98                	cltq   
  801bb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbc:	48 83 ec 08          	sub    $0x8,%rsp
  801bc0:	6a 00                	pushq  $0x0
  801bc2:	49 89 f1             	mov    %rsi,%r9
  801bc5:	49 89 c8             	mov    %rcx,%r8
  801bc8:	48 89 d1             	mov    %rdx,%rcx
  801bcb:	48 89 c2             	mov    %rax,%rdx
  801bce:	be 00 00 00 00       	mov    $0x0,%esi
  801bd3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bd8:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
  801be4:	48 83 c4 10          	add    $0x10,%rsp
}
  801be8:	c9                   	leaveq 
  801be9:	c3                   	retq   

0000000000801bea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	48 83 ec 10          	sub    $0x10,%rsp
  801bf2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfa:	48 83 ec 08          	sub    $0x8,%rsp
  801bfe:	6a 00                	pushq  $0x0
  801c00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c11:	48 89 c2             	mov    %rax,%rdx
  801c14:	be 01 00 00 00       	mov    $0x1,%esi
  801c19:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c1e:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801c25:	00 00 00 
  801c28:	ff d0                	callq  *%rax
  801c2a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c2e:	c9                   	leaveq 
  801c2f:	c3                   	retq   

0000000000801c30 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c34:	48 83 ec 08          	sub    $0x8,%rsp
  801c38:	6a 00                	pushq  $0x0
  801c3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c50:	be 00 00 00 00       	mov    $0x0,%esi
  801c55:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c5a:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	callq  *%rax
  801c66:	48 83 c4 10          	add    $0x10,%rsp
}
  801c6a:	c9                   	leaveq 
  801c6b:	c3                   	retq   

0000000000801c6c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	48 83 ec 10          	sub    $0x10,%rsp
  801c74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c78:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801c7b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c82:	48 83 ec 08          	sub    $0x8,%rsp
  801c86:	6a 00                	pushq  $0x0
  801c88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c94:	48 89 d1             	mov    %rdx,%rcx
  801c97:	48 89 c2             	mov    %rax,%rdx
  801c9a:	be 00 00 00 00       	mov    $0x0,%esi
  801c9f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ca4:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	callq  *%rax
  801cb0:	48 83 c4 10          	add    $0x10,%rsp
}
  801cb4:	c9                   	leaveq 
  801cb5:	c3                   	retq   

0000000000801cb6 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801cb6:	55                   	push   %rbp
  801cb7:	48 89 e5             	mov    %rsp,%rbp
  801cba:	48 83 ec 10          	sub    $0x10,%rsp
  801cbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cc2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801cc5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ccc:	48 83 ec 08          	sub    $0x8,%rsp
  801cd0:	6a 00                	pushq  $0x0
  801cd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cde:	48 89 d1             	mov    %rdx,%rcx
  801ce1:	48 89 c2             	mov    %rax,%rdx
  801ce4:	be 00 00 00 00       	mov    $0x0,%esi
  801ce9:	bf 10 00 00 00       	mov    $0x10,%edi
  801cee:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	callq  *%rax
  801cfa:	48 83 c4 10          	add    $0x10,%rsp
}
  801cfe:	c9                   	leaveq 
  801cff:	c3                   	retq   

0000000000801d00 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d00:	55                   	push   %rbp
  801d01:	48 89 e5             	mov    %rsp,%rbp
  801d04:	48 83 ec 20          	sub    $0x20,%rsp
  801d08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d12:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d16:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d1d:	48 63 c8             	movslq %eax,%rcx
  801d20:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d27:	48 63 f0             	movslq %eax,%rsi
  801d2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d31:	48 98                	cltq   
  801d33:	48 83 ec 08          	sub    $0x8,%rsp
  801d37:	51                   	push   %rcx
  801d38:	49 89 f9             	mov    %rdi,%r9
  801d3b:	49 89 f0             	mov    %rsi,%r8
  801d3e:	48 89 d1             	mov    %rdx,%rcx
  801d41:	48 89 c2             	mov    %rax,%rdx
  801d44:	be 00 00 00 00       	mov    $0x0,%esi
  801d49:	bf 11 00 00 00       	mov    $0x11,%edi
  801d4e:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	callq  *%rax
  801d5a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d5e:	c9                   	leaveq 
  801d5f:	c3                   	retq   

0000000000801d60 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d60:	55                   	push   %rbp
  801d61:	48 89 e5             	mov    %rsp,%rbp
  801d64:	48 83 ec 10          	sub    $0x10,%rsp
  801d68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d78:	48 83 ec 08          	sub    $0x8,%rsp
  801d7c:	6a 00                	pushq  $0x0
  801d7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8a:	48 89 d1             	mov    %rdx,%rcx
  801d8d:	48 89 c2             	mov    %rax,%rdx
  801d90:	be 00 00 00 00       	mov    $0x0,%esi
  801d95:	bf 12 00 00 00       	mov    $0x12,%edi
  801d9a:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax
  801da6:	48 83 c4 10          	add    $0x10,%rsp
}
  801daa:	c9                   	leaveq 
  801dab:	c3                   	retq   

0000000000801dac <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801dac:	55                   	push   %rbp
  801dad:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801db0:	48 83 ec 08          	sub    $0x8,%rsp
  801db4:	6a 00                	pushq  $0x0
  801db6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dcc:	be 00 00 00 00       	mov    $0x0,%esi
  801dd1:	bf 13 00 00 00       	mov    $0x13,%edi
  801dd6:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801ddd:	00 00 00 
  801de0:	ff d0                	callq  *%rax
  801de2:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801de6:	90                   	nop
  801de7:	c9                   	leaveq 
  801de8:	c3                   	retq   

0000000000801de9 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801de9:	55                   	push   %rbp
  801dea:	48 89 e5             	mov    %rsp,%rbp
  801ded:	48 83 ec 10          	sub    $0x10,%rsp
  801df1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df7:	48 98                	cltq   
  801df9:	48 83 ec 08          	sub    $0x8,%rsp
  801dfd:	6a 00                	pushq  $0x0
  801dff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e10:	48 89 c2             	mov    %rax,%rdx
  801e13:	be 00 00 00 00       	mov    $0x0,%esi
  801e18:	bf 14 00 00 00       	mov    $0x14,%edi
  801e1d:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801e24:	00 00 00 
  801e27:	ff d0                	callq  *%rax
  801e29:	48 83 c4 10          	add    $0x10,%rsp
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e33:	48 83 ec 08          	sub    $0x8,%rsp
  801e37:	6a 00                	pushq  $0x0
  801e39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4f:	be 00 00 00 00       	mov    $0x0,%esi
  801e54:	bf 15 00 00 00       	mov    $0x15,%edi
  801e59:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801e60:	00 00 00 
  801e63:	ff d0                	callq  *%rax
  801e65:	48 83 c4 10          	add    $0x10,%rsp
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e6f:	48 83 ec 08          	sub    $0x8,%rsp
  801e73:	6a 00                	pushq  $0x0
  801e75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e86:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8b:	be 00 00 00 00       	mov    $0x0,%esi
  801e90:	bf 16 00 00 00       	mov    $0x16,%edi
  801e95:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	48 83 c4 10          	add    $0x10,%rsp
}
  801ea5:	90                   	nop
  801ea6:	c9                   	leaveq 
  801ea7:	c3                   	retq   

0000000000801ea8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
  801eac:	48 83 ec 08          	sub    $0x8,%rsp
  801eb0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801eb4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ebf:	ff ff ff 
  801ec2:	48 01 d0             	add    %rdx,%rax
  801ec5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ec9:	c9                   	leaveq 
  801eca:	c3                   	retq   

0000000000801ecb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ecb:	55                   	push   %rbp
  801ecc:	48 89 e5             	mov    %rsp,%rbp
  801ecf:	48 83 ec 08          	sub    $0x8,%rsp
  801ed3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801edb:	48 89 c7             	mov    %rax,%rdi
  801ede:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax
  801eea:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ef0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ef4:	c9                   	leaveq 
  801ef5:	c3                   	retq   

0000000000801ef6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ef6:	55                   	push   %rbp
  801ef7:	48 89 e5             	mov    %rsp,%rbp
  801efa:	48 83 ec 18          	sub    $0x18,%rsp
  801efe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f09:	eb 6b                	jmp    801f76 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0e:	48 98                	cltq   
  801f10:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f16:	48 c1 e0 0c          	shl    $0xc,%rax
  801f1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f22:	48 c1 e8 15          	shr    $0x15,%rax
  801f26:	48 89 c2             	mov    %rax,%rdx
  801f29:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f30:	01 00 00 
  801f33:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f37:	83 e0 01             	and    $0x1,%eax
  801f3a:	48 85 c0             	test   %rax,%rax
  801f3d:	74 21                	je     801f60 <fd_alloc+0x6a>
  801f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f43:	48 c1 e8 0c          	shr    $0xc,%rax
  801f47:	48 89 c2             	mov    %rax,%rdx
  801f4a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f51:	01 00 00 
  801f54:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f58:	83 e0 01             	and    $0x1,%eax
  801f5b:	48 85 c0             	test   %rax,%rax
  801f5e:	75 12                	jne    801f72 <fd_alloc+0x7c>
			*fd_store = fd;
  801f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f68:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f70:	eb 1a                	jmp    801f8c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f72:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f76:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f7a:	7e 8f                	jle    801f0b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f80:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f87:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f8c:	c9                   	leaveq 
  801f8d:	c3                   	retq   

0000000000801f8e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f8e:	55                   	push   %rbp
  801f8f:	48 89 e5             	mov    %rsp,%rbp
  801f92:	48 83 ec 20          	sub    $0x20,%rsp
  801f96:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fa1:	78 06                	js     801fa9 <fd_lookup+0x1b>
  801fa3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fa7:	7e 07                	jle    801fb0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fa9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fae:	eb 6c                	jmp    80201c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb3:	48 98                	cltq   
  801fb5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fbb:	48 c1 e0 0c          	shl    $0xc,%rax
  801fbf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc7:	48 c1 e8 15          	shr    $0x15,%rax
  801fcb:	48 89 c2             	mov    %rax,%rdx
  801fce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fd5:	01 00 00 
  801fd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdc:	83 e0 01             	and    $0x1,%eax
  801fdf:	48 85 c0             	test   %rax,%rax
  801fe2:	74 21                	je     802005 <fd_lookup+0x77>
  801fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe8:	48 c1 e8 0c          	shr    $0xc,%rax
  801fec:	48 89 c2             	mov    %rax,%rdx
  801fef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ff6:	01 00 00 
  801ff9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffd:	83 e0 01             	and    $0x1,%eax
  802000:	48 85 c0             	test   %rax,%rax
  802003:	75 07                	jne    80200c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80200a:	eb 10                	jmp    80201c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80200c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802010:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802014:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201c:	c9                   	leaveq 
  80201d:	c3                   	retq   

000000000080201e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
  802022:	48 83 ec 30          	sub    $0x30,%rsp
  802026:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80202a:	89 f0                	mov    %esi,%eax
  80202c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80202f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802033:	48 89 c7             	mov    %rax,%rdi
  802036:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
  802042:	89 c2                	mov    %eax,%edx
  802044:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802048:	48 89 c6             	mov    %rax,%rsi
  80204b:	89 d7                	mov    %edx,%edi
  80204d:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802054:	00 00 00 
  802057:	ff d0                	callq  *%rax
  802059:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80205c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802060:	78 0a                	js     80206c <fd_close+0x4e>
	    || fd != fd2)
  802062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802066:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80206a:	74 12                	je     80207e <fd_close+0x60>
		return (must_exist ? r : 0);
  80206c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802070:	74 05                	je     802077 <fd_close+0x59>
  802072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802075:	eb 70                	jmp    8020e7 <fd_close+0xc9>
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
  80207c:	eb 69                	jmp    8020e7 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80207e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802082:	8b 00                	mov    (%rax),%eax
  802084:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802088:	48 89 d6             	mov    %rdx,%rsi
  80208b:	89 c7                	mov    %eax,%edi
  80208d:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  802094:	00 00 00 
  802097:	ff d0                	callq  *%rax
  802099:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80209c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a0:	78 2a                	js     8020cc <fd_close+0xae>
		if (dev->dev_close)
  8020a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020aa:	48 85 c0             	test   %rax,%rax
  8020ad:	74 16                	je     8020c5 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8020af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020b7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020bb:	48 89 d7             	mov    %rdx,%rdi
  8020be:	ff d0                	callq  *%rax
  8020c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c3:	eb 07                	jmp    8020cc <fd_close+0xae>
		else
			r = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d0:	48 89 c6             	mov    %rax,%rsi
  8020d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d8:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	callq  *%rax
	return r;
  8020e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020e7:	c9                   	leaveq 
  8020e8:	c3                   	retq   

00000000008020e9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020e9:	55                   	push   %rbp
  8020ea:	48 89 e5             	mov    %rsp,%rbp
  8020ed:	48 83 ec 20          	sub    $0x20,%rsp
  8020f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ff:	eb 41                	jmp    802142 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802101:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802108:	00 00 00 
  80210b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80210e:	48 63 d2             	movslq %edx,%rdx
  802111:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802115:	8b 00                	mov    (%rax),%eax
  802117:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80211a:	75 22                	jne    80213e <dev_lookup+0x55>
			*dev = devtab[i];
  80211c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802123:	00 00 00 
  802126:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802129:	48 63 d2             	movslq %edx,%rdx
  80212c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802130:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802134:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	eb 60                	jmp    80219e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80213e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802142:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802149:	00 00 00 
  80214c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80214f:	48 63 d2             	movslq %edx,%rdx
  802152:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802156:	48 85 c0             	test   %rax,%rax
  802159:	75 a6                	jne    802101 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80215b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802162:	00 00 00 
  802165:	48 8b 00             	mov    (%rax),%rax
  802168:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80216e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802171:	89 c6                	mov    %eax,%esi
  802173:	48 bf d8 4d 80 00 00 	movabs $0x804dd8,%rdi
  80217a:	00 00 00 
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
  802182:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  802189:	00 00 00 
  80218c:	ff d1                	callq  *%rcx
	*dev = 0;
  80218e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802192:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802199:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80219e:	c9                   	leaveq 
  80219f:	c3                   	retq   

00000000008021a0 <close>:

int
close(int fdnum)
{
  8021a0:	55                   	push   %rbp
  8021a1:	48 89 e5             	mov    %rsp,%rbp
  8021a4:	48 83 ec 20          	sub    $0x20,%rsp
  8021a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b2:	48 89 d6             	mov    %rdx,%rsi
  8021b5:	89 c7                	mov    %eax,%edi
  8021b7:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax
  8021c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ca:	79 05                	jns    8021d1 <close+0x31>
		return r;
  8021cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cf:	eb 18                	jmp    8021e9 <close+0x49>
	else
		return fd_close(fd, 1);
  8021d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d5:	be 01 00 00 00       	mov    $0x1,%esi
  8021da:	48 89 c7             	mov    %rax,%rdi
  8021dd:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
}
  8021e9:	c9                   	leaveq 
  8021ea:	c3                   	retq   

00000000008021eb <close_all>:

void
close_all(void)
{
  8021eb:	55                   	push   %rbp
  8021ec:	48 89 e5             	mov    %rsp,%rbp
  8021ef:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021fa:	eb 15                	jmp    802211 <close_all+0x26>
		close(i);
  8021fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ff:	89 c7                	mov    %eax,%edi
  802201:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80220d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802211:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802215:	7e e5                	jle    8021fc <close_all+0x11>
		close(i);
}
  802217:	90                   	nop
  802218:	c9                   	leaveq 
  802219:	c3                   	retq   

000000000080221a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80221a:	55                   	push   %rbp
  80221b:	48 89 e5             	mov    %rsp,%rbp
  80221e:	48 83 ec 40          	sub    $0x40,%rsp
  802222:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802225:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802228:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80222c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80222f:	48 89 d6             	mov    %rdx,%rsi
  802232:	89 c7                	mov    %eax,%edi
  802234:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  80223b:	00 00 00 
  80223e:	ff d0                	callq  *%rax
  802240:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802243:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802247:	79 08                	jns    802251 <dup+0x37>
		return r;
  802249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224c:	e9 70 01 00 00       	jmpq   8023c1 <dup+0x1a7>
	close(newfdnum);
  802251:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802254:	89 c7                	mov    %eax,%edi
  802256:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  80225d:	00 00 00 
  802260:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802262:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802265:	48 98                	cltq   
  802267:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80226d:	48 c1 e0 0c          	shl    $0xc,%rax
  802271:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802275:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802279:	48 89 c7             	mov    %rax,%rdi
  80227c:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  802283:	00 00 00 
  802286:	ff d0                	callq  *%rax
  802288:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80228c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802290:	48 89 c7             	mov    %rax,%rdi
  802293:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	callq  *%rax
  80229f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a7:	48 c1 e8 15          	shr    $0x15,%rax
  8022ab:	48 89 c2             	mov    %rax,%rdx
  8022ae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b5:	01 00 00 
  8022b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bc:	83 e0 01             	and    $0x1,%eax
  8022bf:	48 85 c0             	test   %rax,%rax
  8022c2:	74 71                	je     802335 <dup+0x11b>
  8022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8022cc:	48 89 c2             	mov    %rax,%rdx
  8022cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d6:	01 00 00 
  8022d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022dd:	83 e0 01             	and    $0x1,%eax
  8022e0:	48 85 c0             	test   %rax,%rax
  8022e3:	74 50                	je     802335 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e9:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ed:	48 89 c2             	mov    %rax,%rdx
  8022f0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f7:	01 00 00 
  8022fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fe:	25 07 0e 00 00       	and    $0xe07,%eax
  802303:	89 c1                	mov    %eax,%ecx
  802305:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230d:	41 89 c8             	mov    %ecx,%r8d
  802310:	48 89 d1             	mov    %rdx,%rcx
  802313:	ba 00 00 00 00       	mov    $0x0,%edx
  802318:	48 89 c6             	mov    %rax,%rsi
  80231b:	bf 00 00 00 00       	mov    $0x0,%edi
  802320:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  802327:	00 00 00 
  80232a:	ff d0                	callq  *%rax
  80232c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802333:	78 55                	js     80238a <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802339:	48 c1 e8 0c          	shr    $0xc,%rax
  80233d:	48 89 c2             	mov    %rax,%rdx
  802340:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802347:	01 00 00 
  80234a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234e:	25 07 0e 00 00       	and    $0xe07,%eax
  802353:	89 c1                	mov    %eax,%ecx
  802355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80235d:	41 89 c8             	mov    %ecx,%r8d
  802360:	48 89 d1             	mov    %rdx,%rcx
  802363:	ba 00 00 00 00       	mov    $0x0,%edx
  802368:	48 89 c6             	mov    %rax,%rsi
  80236b:	bf 00 00 00 00       	mov    $0x0,%edi
  802370:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  802377:	00 00 00 
  80237a:	ff d0                	callq  *%rax
  80237c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802383:	78 08                	js     80238d <dup+0x173>
		goto err;

	return newfdnum;
  802385:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802388:	eb 37                	jmp    8023c1 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80238a:	90                   	nop
  80238b:	eb 01                	jmp    80238e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80238d:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80238e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802392:	48 89 c6             	mov    %rax,%rsi
  802395:	bf 00 00 00 00       	mov    $0x0,%edi
  80239a:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023aa:	48 89 c6             	mov    %rax,%rsi
  8023ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b2:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
	return r;
  8023be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c1:	c9                   	leaveq 
  8023c2:	c3                   	retq   

00000000008023c3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023c3:	55                   	push   %rbp
  8023c4:	48 89 e5             	mov    %rsp,%rbp
  8023c7:	48 83 ec 40          	sub    $0x40,%rsp
  8023cb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023dd:	48 89 d6             	mov    %rdx,%rsi
  8023e0:	89 c7                	mov    %eax,%edi
  8023e2:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
  8023ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f5:	78 24                	js     80241b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fb:	8b 00                	mov    (%rax),%eax
  8023fd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802401:	48 89 d6             	mov    %rdx,%rsi
  802404:	89 c7                	mov    %eax,%edi
  802406:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  80240d:	00 00 00 
  802410:	ff d0                	callq  *%rax
  802412:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802415:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802419:	79 05                	jns    802420 <read+0x5d>
		return r;
  80241b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241e:	eb 76                	jmp    802496 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802424:	8b 40 08             	mov    0x8(%rax),%eax
  802427:	83 e0 03             	and    $0x3,%eax
  80242a:	83 f8 01             	cmp    $0x1,%eax
  80242d:	75 3a                	jne    802469 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80242f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802436:	00 00 00 
  802439:	48 8b 00             	mov    (%rax),%rax
  80243c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802442:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802445:	89 c6                	mov    %eax,%esi
  802447:	48 bf f7 4d 80 00 00 	movabs $0x804df7,%rdi
  80244e:	00 00 00 
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
  802456:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  80245d:	00 00 00 
  802460:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802462:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802467:	eb 2d                	jmp    802496 <read+0xd3>
	}
	if (!dev->dev_read)
  802469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802471:	48 85 c0             	test   %rax,%rax
  802474:	75 07                	jne    80247d <read+0xba>
		return -E_NOT_SUPP;
  802476:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80247b:	eb 19                	jmp    802496 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80247d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802481:	48 8b 40 10          	mov    0x10(%rax),%rax
  802485:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802489:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80248d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802491:	48 89 cf             	mov    %rcx,%rdi
  802494:	ff d0                	callq  *%rax
}
  802496:	c9                   	leaveq 
  802497:	c3                   	retq   

0000000000802498 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802498:	55                   	push   %rbp
  802499:	48 89 e5             	mov    %rsp,%rbp
  80249c:	48 83 ec 30          	sub    $0x30,%rsp
  8024a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024b2:	eb 47                	jmp    8024fb <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b7:	48 98                	cltq   
  8024b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024bd:	48 29 c2             	sub    %rax,%rdx
  8024c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c3:	48 63 c8             	movslq %eax,%rcx
  8024c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ca:	48 01 c1             	add    %rax,%rcx
  8024cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d0:	48 89 ce             	mov    %rcx,%rsi
  8024d3:	89 c7                	mov    %eax,%edi
  8024d5:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  8024dc:	00 00 00 
  8024df:	ff d0                	callq  *%rax
  8024e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024e8:	79 05                	jns    8024ef <readn+0x57>
			return m;
  8024ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ed:	eb 1d                	jmp    80250c <readn+0x74>
		if (m == 0)
  8024ef:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024f3:	74 13                	je     802508 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024f8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fe:	48 98                	cltq   
  802500:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802504:	72 ae                	jb     8024b4 <readn+0x1c>
  802506:	eb 01                	jmp    802509 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802508:	90                   	nop
	}
	return tot;
  802509:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80250c:	c9                   	leaveq 
  80250d:	c3                   	retq   

000000000080250e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80250e:	55                   	push   %rbp
  80250f:	48 89 e5             	mov    %rsp,%rbp
  802512:	48 83 ec 40          	sub    $0x40,%rsp
  802516:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802519:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80251d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802521:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802525:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802528:	48 89 d6             	mov    %rdx,%rsi
  80252b:	89 c7                	mov    %eax,%edi
  80252d:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802540:	78 24                	js     802566 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802546:	8b 00                	mov    (%rax),%eax
  802548:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80254c:	48 89 d6             	mov    %rdx,%rsi
  80254f:	89 c7                	mov    %eax,%edi
  802551:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802564:	79 05                	jns    80256b <write+0x5d>
		return r;
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	eb 75                	jmp    8025e0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256f:	8b 40 08             	mov    0x8(%rax),%eax
  802572:	83 e0 03             	and    $0x3,%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	75 3a                	jne    8025b3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802579:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802580:	00 00 00 
  802583:	48 8b 00             	mov    (%rax),%rax
  802586:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80258c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80258f:	89 c6                	mov    %eax,%esi
  802591:	48 bf 13 4e 80 00 00 	movabs $0x804e13,%rdi
  802598:	00 00 00 
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  8025a7:	00 00 00 
  8025aa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b1:	eb 2d                	jmp    8025e0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025bb:	48 85 c0             	test   %rax,%rax
  8025be:	75 07                	jne    8025c7 <write+0xb9>
		return -E_NOT_SUPP;
  8025c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c5:	eb 19                	jmp    8025e0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8025c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025d3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025d7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025db:	48 89 cf             	mov    %rcx,%rdi
  8025de:	ff d0                	callq  *%rax
}
  8025e0:	c9                   	leaveq 
  8025e1:	c3                   	retq   

00000000008025e2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025e2:	55                   	push   %rbp
  8025e3:	48 89 e5             	mov    %rsp,%rbp
  8025e6:	48 83 ec 18          	sub    $0x18,%rsp
  8025ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ed:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f7:	48 89 d6             	mov    %rdx,%rsi
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260f:	79 05                	jns    802616 <seek+0x34>
		return r;
  802611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802614:	eb 0f                	jmp    802625 <seek+0x43>
	fd->fd_offset = offset;
  802616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80261d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802625:	c9                   	leaveq 
  802626:	c3                   	retq   

0000000000802627 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802627:	55                   	push   %rbp
  802628:	48 89 e5             	mov    %rsp,%rbp
  80262b:	48 83 ec 30          	sub    $0x30,%rsp
  80262f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802632:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802635:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802639:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80263c:	48 89 d6             	mov    %rdx,%rsi
  80263f:	89 c7                	mov    %eax,%edi
  802641:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802648:	00 00 00 
  80264b:	ff d0                	callq  *%rax
  80264d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802650:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802654:	78 24                	js     80267a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265a:	8b 00                	mov    (%rax),%eax
  80265c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802660:	48 89 d6             	mov    %rdx,%rsi
  802663:	89 c7                	mov    %eax,%edi
  802665:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	callq  *%rax
  802671:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802674:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802678:	79 05                	jns    80267f <ftruncate+0x58>
		return r;
  80267a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267d:	eb 72                	jmp    8026f1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80267f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802683:	8b 40 08             	mov    0x8(%rax),%eax
  802686:	83 e0 03             	and    $0x3,%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	75 3a                	jne    8026c7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80268d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802694:	00 00 00 
  802697:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80269a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026a3:	89 c6                	mov    %eax,%esi
  8026a5:	48 bf 30 4e 80 00 00 	movabs $0x804e30,%rdi
  8026ac:	00 00 00 
  8026af:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b4:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  8026bb:	00 00 00 
  8026be:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c5:	eb 2a                	jmp    8026f1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026cf:	48 85 c0             	test   %rax,%rax
  8026d2:	75 07                	jne    8026db <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026d4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d9:	eb 16                	jmp    8026f1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026df:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026e7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026ea:	89 ce                	mov    %ecx,%esi
  8026ec:	48 89 d7             	mov    %rdx,%rdi
  8026ef:	ff d0                	callq  *%rax
}
  8026f1:	c9                   	leaveq 
  8026f2:	c3                   	retq   

00000000008026f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026f3:	55                   	push   %rbp
  8026f4:	48 89 e5             	mov    %rsp,%rbp
  8026f7:	48 83 ec 30          	sub    $0x30,%rsp
  8026fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802702:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802706:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802709:	48 89 d6             	mov    %rdx,%rsi
  80270c:	89 c7                	mov    %eax,%edi
  80270e:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
  80271a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802721:	78 24                	js     802747 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802727:	8b 00                	mov    (%rax),%eax
  802729:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80272d:	48 89 d6             	mov    %rdx,%rsi
  802730:	89 c7                	mov    %eax,%edi
  802732:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax
  80273e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802741:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802745:	79 05                	jns    80274c <fstat+0x59>
		return r;
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274a:	eb 5e                	jmp    8027aa <fstat+0xb7>
	if (!dev->dev_stat)
  80274c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802750:	48 8b 40 28          	mov    0x28(%rax),%rax
  802754:	48 85 c0             	test   %rax,%rax
  802757:	75 07                	jne    802760 <fstat+0x6d>
		return -E_NOT_SUPP;
  802759:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80275e:	eb 4a                	jmp    8027aa <fstat+0xb7>
	stat->st_name[0] = 0;
  802760:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802764:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802767:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80276b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802772:	00 00 00 
	stat->st_isdir = 0;
  802775:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802779:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802780:	00 00 00 
	stat->st_dev = dev;
  802783:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802787:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80278b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802796:	48 8b 40 28          	mov    0x28(%rax),%rax
  80279a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80279e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027a2:	48 89 ce             	mov    %rcx,%rsi
  8027a5:	48 89 d7             	mov    %rdx,%rdi
  8027a8:	ff d0                	callq  *%rax
}
  8027aa:	c9                   	leaveq 
  8027ab:	c3                   	retq   

00000000008027ac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027ac:	55                   	push   %rbp
  8027ad:	48 89 e5             	mov    %rsp,%rbp
  8027b0:	48 83 ec 20          	sub    $0x20,%rsp
  8027b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c0:	be 00 00 00 00       	mov    $0x0,%esi
  8027c5:	48 89 c7             	mov    %rax,%rdi
  8027c8:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	79 05                	jns    8027e2 <stat+0x36>
		return fd;
  8027dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e0:	eb 2f                	jmp    802811 <stat+0x65>
	r = fstat(fd, stat);
  8027e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e9:	48 89 d6             	mov    %rdx,%rsi
  8027ec:	89 c7                	mov    %eax,%edi
  8027ee:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  8027f5:	00 00 00 
  8027f8:	ff d0                	callq  *%rax
  8027fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802800:	89 c7                	mov    %eax,%edi
  802802:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
	return r;
  80280e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802811:	c9                   	leaveq 
  802812:	c3                   	retq   

0000000000802813 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802813:	55                   	push   %rbp
  802814:	48 89 e5             	mov    %rsp,%rbp
  802817:	48 83 ec 10          	sub    $0x10,%rsp
  80281b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80281e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802822:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802829:	00 00 00 
  80282c:	8b 00                	mov    (%rax),%eax
  80282e:	85 c0                	test   %eax,%eax
  802830:	75 1f                	jne    802851 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802832:	bf 01 00 00 00       	mov    $0x1,%edi
  802837:	48 b8 c0 41 80 00 00 	movabs $0x8041c0,%rax
  80283e:	00 00 00 
  802841:	ff d0                	callq  *%rax
  802843:	89 c2                	mov    %eax,%edx
  802845:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80284c:	00 00 00 
  80284f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802851:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802858:	00 00 00 
  80285b:	8b 00                	mov    (%rax),%eax
  80285d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802860:	b9 07 00 00 00       	mov    $0x7,%ecx
  802865:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80286c:	00 00 00 
  80286f:	89 c7                	mov    %eax,%edi
  802871:	48 b8 2b 41 80 00 00 	movabs $0x80412b,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80287d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802881:	ba 00 00 00 00       	mov    $0x0,%edx
  802886:	48 89 c6             	mov    %rax,%rsi
  802889:	bf 00 00 00 00       	mov    $0x0,%edi
  80288e:	48 b8 6a 40 80 00 00 	movabs $0x80406a,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax
}
  80289a:	c9                   	leaveq 
  80289b:	c3                   	retq   

000000000080289c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80289c:	55                   	push   %rbp
  80289d:	48 89 e5             	mov    %rsp,%rbp
  8028a0:	48 83 ec 20          	sub    $0x20,%rsp
  8028a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a8:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8028ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028af:	48 89 c7             	mov    %rax,%rdi
  8028b2:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  8028b9:	00 00 00 
  8028bc:	ff d0                	callq  *%rax
  8028be:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028c3:	7e 0a                	jle    8028cf <open+0x33>
		return -E_BAD_PATH;
  8028c5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028ca:	e9 a5 00 00 00       	jmpq   802974 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8028cf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028d3:	48 89 c7             	mov    %rax,%rdi
  8028d6:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
  8028e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e9:	79 08                	jns    8028f3 <open+0x57>
		return r;
  8028eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ee:	e9 81 00 00 00       	jmpq   802974 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8028f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f7:	48 89 c6             	mov    %rax,%rsi
  8028fa:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802901:	00 00 00 
  802904:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802910:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802917:	00 00 00 
  80291a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80291d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802927:	48 89 c6             	mov    %rax,%rsi
  80292a:	bf 01 00 00 00       	mov    $0x1,%edi
  80292f:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
  80293b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802942:	79 1d                	jns    802961 <open+0xc5>
		fd_close(fd, 0);
  802944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802948:	be 00 00 00 00       	mov    $0x0,%esi
  80294d:	48 89 c7             	mov    %rax,%rdi
  802950:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  802957:	00 00 00 
  80295a:	ff d0                	callq  *%rax
		return r;
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	eb 13                	jmp    802974 <open+0xd8>
	}

	return fd2num(fd);
  802961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802965:	48 89 c7             	mov    %rax,%rdi
  802968:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax

}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 10          	sub    $0x10,%rsp
  80297e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802982:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802986:	8b 50 0c             	mov    0xc(%rax),%edx
  802989:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802990:	00 00 00 
  802993:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802995:	be 00 00 00 00       	mov    $0x0,%esi
  80299a:	bf 06 00 00 00       	mov    $0x6,%edi
  80299f:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
}
  8029ab:	c9                   	leaveq 
  8029ac:	c3                   	retq   

00000000008029ad <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029ad:	55                   	push   %rbp
  8029ae:	48 89 e5             	mov    %rsp,%rbp
  8029b1:	48 83 ec 30          	sub    $0x30,%rsp
  8029b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029cf:	00 00 00 
  8029d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029d4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029db:	00 00 00 
  8029de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029e2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029e6:	be 00 00 00 00       	mov    $0x0,%esi
  8029eb:	bf 03 00 00 00       	mov    $0x3,%edi
  8029f0:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  8029f7:	00 00 00 
  8029fa:	ff d0                	callq  *%rax
  8029fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a03:	79 08                	jns    802a0d <devfile_read+0x60>
		return r;
  802a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a08:	e9 a4 00 00 00       	jmpq   802ab1 <devfile_read+0x104>
	assert(r <= n);
  802a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a10:	48 98                	cltq   
  802a12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a16:	76 35                	jbe    802a4d <devfile_read+0xa0>
  802a18:	48 b9 56 4e 80 00 00 	movabs $0x804e56,%rcx
  802a1f:	00 00 00 
  802a22:	48 ba 5d 4e 80 00 00 	movabs $0x804e5d,%rdx
  802a29:	00 00 00 
  802a2c:	be 86 00 00 00       	mov    $0x86,%esi
  802a31:	48 bf 72 4e 80 00 00 	movabs $0x804e72,%rdi
  802a38:	00 00 00 
  802a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a40:	49 b8 56 3f 80 00 00 	movabs $0x803f56,%r8
  802a47:	00 00 00 
  802a4a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802a4d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802a54:	7e 35                	jle    802a8b <devfile_read+0xde>
  802a56:	48 b9 7d 4e 80 00 00 	movabs $0x804e7d,%rcx
  802a5d:	00 00 00 
  802a60:	48 ba 5d 4e 80 00 00 	movabs $0x804e5d,%rdx
  802a67:	00 00 00 
  802a6a:	be 87 00 00 00       	mov    $0x87,%esi
  802a6f:	48 bf 72 4e 80 00 00 	movabs $0x804e72,%rdi
  802a76:	00 00 00 
  802a79:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7e:	49 b8 56 3f 80 00 00 	movabs $0x803f56,%r8
  802a85:	00 00 00 
  802a88:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802a8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8e:	48 63 d0             	movslq %eax,%rdx
  802a91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a95:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802a9c:	00 00 00 
  802a9f:	48 89 c7             	mov    %rax,%rdi
  802aa2:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
	return r;
  802aae:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802ab1:	c9                   	leaveq 
  802ab2:	c3                   	retq   

0000000000802ab3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ab3:	55                   	push   %rbp
  802ab4:	48 89 e5             	mov    %rsp,%rbp
  802ab7:	48 83 ec 40          	sub    $0x40,%rsp
  802abb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802abf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ac3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802ac7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802acb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802acf:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802ad6:	00 
  802ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802adb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802adf:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802ae4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ae8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aec:	8b 50 0c             	mov    0xc(%rax),%edx
  802aef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802af6:	00 00 00 
  802af9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802afb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b02:	00 00 00 
  802b05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b09:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802b0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b15:	48 89 c6             	mov    %rax,%rsi
  802b18:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802b1f:	00 00 00 
  802b22:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b2e:	be 00 00 00 00       	mov    $0x0,%esi
  802b33:	bf 04 00 00 00       	mov    $0x4,%edi
  802b38:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b47:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b4b:	79 05                	jns    802b52 <devfile_write+0x9f>
		return r;
  802b4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b50:	eb 43                	jmp    802b95 <devfile_write+0xe2>
	assert(r <= n);
  802b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b55:	48 98                	cltq   
  802b57:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802b5b:	76 35                	jbe    802b92 <devfile_write+0xdf>
  802b5d:	48 b9 56 4e 80 00 00 	movabs $0x804e56,%rcx
  802b64:	00 00 00 
  802b67:	48 ba 5d 4e 80 00 00 	movabs $0x804e5d,%rdx
  802b6e:	00 00 00 
  802b71:	be a2 00 00 00       	mov    $0xa2,%esi
  802b76:	48 bf 72 4e 80 00 00 	movabs $0x804e72,%rdi
  802b7d:	00 00 00 
  802b80:	b8 00 00 00 00       	mov    $0x0,%eax
  802b85:	49 b8 56 3f 80 00 00 	movabs $0x803f56,%r8
  802b8c:	00 00 00 
  802b8f:	41 ff d0             	callq  *%r8
	return r;
  802b92:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802b95:	c9                   	leaveq 
  802b96:	c3                   	retq   

0000000000802b97 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b97:	55                   	push   %rbp
  802b98:	48 89 e5             	mov    %rsp,%rbp
  802b9b:	48 83 ec 20          	sub    $0x20,%rsp
  802b9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ba3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bab:	8b 50 0c             	mov    0xc(%rax),%edx
  802bae:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bb5:	00 00 00 
  802bb8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bba:	be 00 00 00 00       	mov    $0x0,%esi
  802bbf:	bf 05 00 00 00       	mov    $0x5,%edi
  802bc4:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
  802bd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd7:	79 05                	jns    802bde <devfile_stat+0x47>
		return r;
  802bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdc:	eb 56                	jmp    802c34 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be2:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802be9:	00 00 00 
  802bec:	48 89 c7             	mov    %rax,%rdi
  802bef:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bfb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c02:	00 00 00 
  802c05:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c0f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c15:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c1c:	00 00 00 
  802c1f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c29:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c34:	c9                   	leaveq 
  802c35:	c3                   	retq   

0000000000802c36 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c36:	55                   	push   %rbp
  802c37:	48 89 e5             	mov    %rsp,%rbp
  802c3a:	48 83 ec 10          	sub    $0x10,%rsp
  802c3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c42:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c49:	8b 50 0c             	mov    0xc(%rax),%edx
  802c4c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c53:	00 00 00 
  802c56:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c58:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c5f:	00 00 00 
  802c62:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c65:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c68:	be 00 00 00 00       	mov    $0x0,%esi
  802c6d:	bf 02 00 00 00       	mov    $0x2,%edi
  802c72:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax
}
  802c7e:	c9                   	leaveq 
  802c7f:	c3                   	retq   

0000000000802c80 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c80:	55                   	push   %rbp
  802c81:	48 89 e5             	mov    %rsp,%rbp
  802c84:	48 83 ec 10          	sub    $0x10,%rsp
  802c88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c90:	48 89 c7             	mov    %rax,%rdi
  802c93:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ca4:	7e 07                	jle    802cad <remove+0x2d>
		return -E_BAD_PATH;
  802ca6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cab:	eb 33                	jmp    802ce0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb1:	48 89 c6             	mov    %rax,%rsi
  802cb4:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802cbb:	00 00 00 
  802cbe:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cca:	be 00 00 00 00       	mov    $0x0,%esi
  802ccf:	bf 07 00 00 00       	mov    $0x7,%edi
  802cd4:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
}
  802ce0:	c9                   	leaveq 
  802ce1:	c3                   	retq   

0000000000802ce2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ce2:	55                   	push   %rbp
  802ce3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ce6:	be 00 00 00 00       	mov    $0x0,%esi
  802ceb:	bf 08 00 00 00       	mov    $0x8,%edi
  802cf0:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	callq  *%rax
}
  802cfc:	5d                   	pop    %rbp
  802cfd:	c3                   	retq   

0000000000802cfe <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802cfe:	55                   	push   %rbp
  802cff:	48 89 e5             	mov    %rsp,%rbp
  802d02:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d09:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d10:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d17:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d1e:	be 00 00 00 00       	mov    $0x0,%esi
  802d23:	48 89 c7             	mov    %rax,%rdi
  802d26:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  802d2d:	00 00 00 
  802d30:	ff d0                	callq  *%rax
  802d32:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d39:	79 28                	jns    802d63 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3e:	89 c6                	mov    %eax,%esi
  802d40:	48 bf 89 4e 80 00 00 	movabs $0x804e89,%rdi
  802d47:	00 00 00 
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4f:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802d56:	00 00 00 
  802d59:	ff d2                	callq  *%rdx
		return fd_src;
  802d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5e:	e9 76 01 00 00       	jmpq   802ed9 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d63:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d6a:	be 01 01 00 00       	mov    $0x101,%esi
  802d6f:	48 89 c7             	mov    %rax,%rdi
  802d72:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  802d79:	00 00 00 
  802d7c:	ff d0                	callq  *%rax
  802d7e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d81:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d85:	0f 89 ad 00 00 00    	jns    802e38 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d8e:	89 c6                	mov    %eax,%esi
  802d90:	48 bf 9f 4e 80 00 00 	movabs $0x804e9f,%rdi
  802d97:	00 00 00 
  802d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9f:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802da6:	00 00 00 
  802da9:	ff d2                	callq  *%rdx
		close(fd_src);
  802dab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dae:	89 c7                	mov    %eax,%edi
  802db0:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
		return fd_dest;
  802dbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dbf:	e9 15 01 00 00       	jmpq   802ed9 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802dc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dc7:	48 63 d0             	movslq %eax,%rdx
  802dca:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd4:	48 89 ce             	mov    %rcx,%rsi
  802dd7:	89 c7                	mov    %eax,%edi
  802dd9:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax
  802de5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802de8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802dec:	79 4a                	jns    802e38 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802dee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802df1:	89 c6                	mov    %eax,%esi
  802df3:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  802dfa:	00 00 00 
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802e02:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802e09:	00 00 00 
  802e0c:	ff d2                	callq  *%rdx
			close(fd_src);
  802e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e11:	89 c7                	mov    %eax,%edi
  802e13:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
			close(fd_dest);
  802e1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
			return write_size;
  802e30:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e33:	e9 a1 00 00 00       	jmpq   802ed9 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e38:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e42:	ba 00 02 00 00       	mov    $0x200,%edx
  802e47:	48 89 ce             	mov    %rcx,%rsi
  802e4a:	89 c7                	mov    %eax,%edi
  802e4c:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  802e53:	00 00 00 
  802e56:	ff d0                	callq  *%rax
  802e58:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e5f:	0f 8f 5f ff ff ff    	jg     802dc4 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e69:	79 47                	jns    802eb2 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802e6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e6e:	89 c6                	mov    %eax,%esi
  802e70:	48 bf cc 4e 80 00 00 	movabs $0x804ecc,%rdi
  802e77:	00 00 00 
  802e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7f:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802e86:	00 00 00 
  802e89:	ff d2                	callq  *%rdx
		close(fd_src);
  802e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8e:	89 c7                	mov    %eax,%edi
  802e90:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802e97:	00 00 00 
  802e9a:	ff d0                	callq  *%rax
		close(fd_dest);
  802e9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e9f:	89 c7                	mov    %eax,%edi
  802ea1:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	callq  *%rax
		return read_size;
  802ead:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eb0:	eb 27                	jmp    802ed9 <copy+0x1db>
	}
	close(fd_src);
  802eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb5:	89 c7                	mov    %eax,%edi
  802eb7:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802ebe:	00 00 00 
  802ec1:	ff d0                	callq  *%rax
	close(fd_dest);
  802ec3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ec6:	89 c7                	mov    %eax,%edi
  802ec8:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
	return 0;
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ed9:	c9                   	leaveq 
  802eda:	c3                   	retq   

0000000000802edb <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802edb:	55                   	push   %rbp
  802edc:	48 89 e5             	mov    %rsp,%rbp
  802edf:	48 83 ec 20          	sub    $0x20,%rsp
  802ee3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802ee6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eed:	48 89 d6             	mov    %rdx,%rsi
  802ef0:	89 c7                	mov    %eax,%edi
  802ef2:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  802ef9:	00 00 00 
  802efc:	ff d0                	callq  *%rax
  802efe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f05:	79 05                	jns    802f0c <fd2sockid+0x31>
		return r;
  802f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0a:	eb 24                	jmp    802f30 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f10:	8b 10                	mov    (%rax),%edx
  802f12:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  802f19:	00 00 00 
  802f1c:	8b 00                	mov    (%rax),%eax
  802f1e:	39 c2                	cmp    %eax,%edx
  802f20:	74 07                	je     802f29 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f22:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f27:	eb 07                	jmp    802f30 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f30:	c9                   	leaveq 
  802f31:	c3                   	retq   

0000000000802f32 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f32:	55                   	push   %rbp
  802f33:	48 89 e5             	mov    %rsp,%rbp
  802f36:	48 83 ec 20          	sub    $0x20,%rsp
  802f3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f3d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f41:	48 89 c7             	mov    %rax,%rdi
  802f44:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
  802f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f57:	78 26                	js     802f7f <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5d:	ba 07 04 00 00       	mov    $0x407,%edx
  802f62:	48 89 c6             	mov    %rax,%rsi
  802f65:	bf 00 00 00 00       	mov    $0x0,%edi
  802f6a:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  802f71:	00 00 00 
  802f74:	ff d0                	callq  *%rax
  802f76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7d:	79 16                	jns    802f95 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	48 b8 41 34 80 00 00 	movabs $0x803441,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
		return r;
  802f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f93:	eb 3a                	jmp    802fcf <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f99:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  802fa0:	00 00 00 
  802fa3:	8b 12                	mov    (%rdx),%edx
  802fa5:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fb9:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc0:	48 89 c7             	mov    %rax,%rdi
  802fc3:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802fca:	00 00 00 
  802fcd:	ff d0                	callq  *%rax
}
  802fcf:	c9                   	leaveq 
  802fd0:	c3                   	retq   

0000000000802fd1 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fd1:	55                   	push   %rbp
  802fd2:	48 89 e5             	mov    %rsp,%rbp
  802fd5:	48 83 ec 30          	sub    $0x30,%rsp
  802fd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fdc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe7:	89 c7                	mov    %eax,%edi
  802fe9:	48 b8 db 2e 80 00 00 	movabs $0x802edb,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
  802ff5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffc:	79 05                	jns    803003 <accept+0x32>
		return r;
  802ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803001:	eb 3b                	jmp    80303e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803003:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803007:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80300b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300e:	48 89 ce             	mov    %rcx,%rsi
  803011:	89 c7                	mov    %eax,%edi
  803013:	48 b8 1e 33 80 00 00 	movabs $0x80331e,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803026:	79 05                	jns    80302d <accept+0x5c>
		return r;
  803028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302b:	eb 11                	jmp    80303e <accept+0x6d>
	return alloc_sockfd(r);
  80302d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803030:	89 c7                	mov    %eax,%edi
  803032:	48 b8 32 2f 80 00 00 	movabs $0x802f32,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
}
  80303e:	c9                   	leaveq 
  80303f:	c3                   	retq   

0000000000803040 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803040:	55                   	push   %rbp
  803041:	48 89 e5             	mov    %rsp,%rbp
  803044:	48 83 ec 20          	sub    $0x20,%rsp
  803048:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80304b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80304f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803052:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803055:	89 c7                	mov    %eax,%edi
  803057:	48 b8 db 2e 80 00 00 	movabs $0x802edb,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
  803063:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803066:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306a:	79 05                	jns    803071 <bind+0x31>
		return r;
  80306c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306f:	eb 1b                	jmp    80308c <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803071:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803074:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307b:	48 89 ce             	mov    %rcx,%rsi
  80307e:	89 c7                	mov    %eax,%edi
  803080:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
}
  80308c:	c9                   	leaveq 
  80308d:	c3                   	retq   

000000000080308e <shutdown>:

int
shutdown(int s, int how)
{
  80308e:	55                   	push   %rbp
  80308f:	48 89 e5             	mov    %rsp,%rbp
  803092:	48 83 ec 20          	sub    $0x20,%rsp
  803096:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803099:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80309c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80309f:	89 c7                	mov    %eax,%edi
  8030a1:	48 b8 db 2e 80 00 00 	movabs $0x802edb,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b4:	79 05                	jns    8030bb <shutdown+0x2d>
		return r;
  8030b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b9:	eb 16                	jmp    8030d1 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8030bb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c1:	89 d6                	mov    %edx,%esi
  8030c3:	89 c7                	mov    %eax,%edi
  8030c5:	48 b8 01 34 80 00 00 	movabs $0x803401,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
}
  8030d1:	c9                   	leaveq 
  8030d2:	c3                   	retq   

00000000008030d3 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8030d3:	55                   	push   %rbp
  8030d4:	48 89 e5             	mov    %rsp,%rbp
  8030d7:	48 83 ec 10          	sub    $0x10,%rsp
  8030db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e3:	48 89 c7             	mov    %rax,%rdi
  8030e6:	48 b8 31 42 80 00 00 	movabs $0x804231,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
  8030f2:	83 f8 01             	cmp    $0x1,%eax
  8030f5:	75 17                	jne    80310e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8030f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fb:	8b 40 0c             	mov    0xc(%rax),%eax
  8030fe:	89 c7                	mov    %eax,%edi
  803100:	48 b8 41 34 80 00 00 	movabs $0x803441,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
  80310c:	eb 05                	jmp    803113 <devsock_close+0x40>
	else
		return 0;
  80310e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803113:	c9                   	leaveq 
  803114:	c3                   	retq   

0000000000803115 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803115:	55                   	push   %rbp
  803116:	48 89 e5             	mov    %rsp,%rbp
  803119:	48 83 ec 20          	sub    $0x20,%rsp
  80311d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803120:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803124:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803127:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80312a:	89 c7                	mov    %eax,%edi
  80312c:	48 b8 db 2e 80 00 00 	movabs $0x802edb,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313f:	79 05                	jns    803146 <connect+0x31>
		return r;
  803141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803144:	eb 1b                	jmp    803161 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803146:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803149:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80314d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803150:	48 89 ce             	mov    %rcx,%rsi
  803153:	89 c7                	mov    %eax,%edi
  803155:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
}
  803161:	c9                   	leaveq 
  803162:	c3                   	retq   

0000000000803163 <listen>:

int
listen(int s, int backlog)
{
  803163:	55                   	push   %rbp
  803164:	48 89 e5             	mov    %rsp,%rbp
  803167:	48 83 ec 20          	sub    $0x20,%rsp
  80316b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80316e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803171:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803174:	89 c7                	mov    %eax,%edi
  803176:	48 b8 db 2e 80 00 00 	movabs $0x802edb,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
  803182:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803189:	79 05                	jns    803190 <listen+0x2d>
		return r;
  80318b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318e:	eb 16                	jmp    8031a6 <listen+0x43>
	return nsipc_listen(r, backlog);
  803190:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803196:	89 d6                	mov    %edx,%esi
  803198:	89 c7                	mov    %eax,%edi
  80319a:	48 b8 d2 34 80 00 00 	movabs $0x8034d2,%rax
  8031a1:	00 00 00 
  8031a4:	ff d0                	callq  *%rax
}
  8031a6:	c9                   	leaveq 
  8031a7:	c3                   	retq   

00000000008031a8 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031a8:	55                   	push   %rbp
  8031a9:	48 89 e5             	mov    %rsp,%rbp
  8031ac:	48 83 ec 20          	sub    $0x20,%rsp
  8031b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c0:	89 c2                	mov    %eax,%edx
  8031c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c6:	8b 40 0c             	mov    0xc(%rax),%eax
  8031c9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031d2:	89 c7                	mov    %eax,%edi
  8031d4:	48 b8 12 35 80 00 00 	movabs $0x803512,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax
}
  8031e0:	c9                   	leaveq 
  8031e1:	c3                   	retq   

00000000008031e2 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031e2:	55                   	push   %rbp
  8031e3:	48 89 e5             	mov    %rsp,%rbp
  8031e6:	48 83 ec 20          	sub    $0x20,%rsp
  8031ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8031f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fa:	89 c2                	mov    %eax,%edx
  8031fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803200:	8b 40 0c             	mov    0xc(%rax),%eax
  803203:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803207:	b9 00 00 00 00       	mov    $0x0,%ecx
  80320c:	89 c7                	mov    %eax,%edi
  80320e:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
}
  80321a:	c9                   	leaveq 
  80321b:	c3                   	retq   

000000000080321c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80321c:	55                   	push   %rbp
  80321d:	48 89 e5             	mov    %rsp,%rbp
  803220:	48 83 ec 10          	sub    $0x10,%rsp
  803224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803228:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80322c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803230:	48 be e7 4e 80 00 00 	movabs $0x804ee7,%rsi
  803237:	00 00 00 
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
	return 0;
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80324e:	c9                   	leaveq 
  80324f:	c3                   	retq   

0000000000803250 <socket>:

int
socket(int domain, int type, int protocol)
{
  803250:	55                   	push   %rbp
  803251:	48 89 e5             	mov    %rsp,%rbp
  803254:	48 83 ec 20          	sub    $0x20,%rsp
  803258:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80325b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80325e:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803261:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803264:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803267:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80326a:	89 ce                	mov    %ecx,%esi
  80326c:	89 c7                	mov    %eax,%edi
  80326e:	48 b8 96 36 80 00 00 	movabs $0x803696,%rax
  803275:	00 00 00 
  803278:	ff d0                	callq  *%rax
  80327a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803281:	79 05                	jns    803288 <socket+0x38>
		return r;
  803283:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803286:	eb 11                	jmp    803299 <socket+0x49>
	return alloc_sockfd(r);
  803288:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328b:	89 c7                	mov    %eax,%edi
  80328d:	48 b8 32 2f 80 00 00 	movabs $0x802f32,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
}
  803299:	c9                   	leaveq 
  80329a:	c3                   	retq   

000000000080329b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80329b:	55                   	push   %rbp
  80329c:	48 89 e5             	mov    %rsp,%rbp
  80329f:	48 83 ec 10          	sub    $0x10,%rsp
  8032a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8032a6:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032ad:	00 00 00 
  8032b0:	8b 00                	mov    (%rax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	75 1f                	jne    8032d5 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032b6:	bf 02 00 00 00       	mov    $0x2,%edi
  8032bb:	48 b8 c0 41 80 00 00 	movabs $0x8041c0,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	callq  *%rax
  8032c7:	89 c2                	mov    %eax,%edx
  8032c9:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032d0:	00 00 00 
  8032d3:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032d5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032dc:	00 00 00 
  8032df:	8b 00                	mov    (%rax),%eax
  8032e1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032e4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032e9:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8032f0:	00 00 00 
  8032f3:	89 c7                	mov    %eax,%edi
  8032f5:	48 b8 2b 41 80 00 00 	movabs $0x80412b,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803301:	ba 00 00 00 00       	mov    $0x0,%edx
  803306:	be 00 00 00 00       	mov    $0x0,%esi
  80330b:	bf 00 00 00 00       	mov    $0x0,%edi
  803310:	48 b8 6a 40 80 00 00 	movabs $0x80406a,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
}
  80331c:	c9                   	leaveq 
  80331d:	c3                   	retq   

000000000080331e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80331e:	55                   	push   %rbp
  80331f:	48 89 e5             	mov    %rsp,%rbp
  803322:	48 83 ec 30          	sub    $0x30,%rsp
  803326:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803329:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80332d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803331:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803338:	00 00 00 
  80333b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80333e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803340:	bf 01 00 00 00       	mov    $0x1,%edi
  803345:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  80334c:	00 00 00 
  80334f:	ff d0                	callq  *%rax
  803351:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803354:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803358:	78 3e                	js     803398 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80335a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803361:	00 00 00 
  803364:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803368:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336c:	8b 40 10             	mov    0x10(%rax),%eax
  80336f:	89 c2                	mov    %eax,%edx
  803371:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803375:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803379:	48 89 ce             	mov    %rcx,%rsi
  80337c:	48 89 c7             	mov    %rax,%rdi
  80337f:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80338b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338f:	8b 50 10             	mov    0x10(%rax),%edx
  803392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803396:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803398:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 10          	sub    $0x10,%rsp
  8033a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8033af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033b6:	00 00 00 
  8033b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033bc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8033be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c5:	48 89 c6             	mov    %rax,%rsi
  8033c8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8033cf:	00 00 00 
  8033d2:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8033d9:	00 00 00 
  8033dc:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8033de:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033e5:	00 00 00 
  8033e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033eb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8033ee:	bf 02 00 00 00       	mov    $0x2,%edi
  8033f3:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
}
  8033ff:	c9                   	leaveq 
  803400:	c3                   	retq   

0000000000803401 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803401:	55                   	push   %rbp
  803402:	48 89 e5             	mov    %rsp,%rbp
  803405:	48 83 ec 10          	sub    $0x10,%rsp
  803409:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80340c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80340f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803416:	00 00 00 
  803419:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80341c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80341e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803425:	00 00 00 
  803428:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80342b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80342e:	bf 03 00 00 00       	mov    $0x3,%edi
  803433:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  80343a:	00 00 00 
  80343d:	ff d0                	callq  *%rax
}
  80343f:	c9                   	leaveq 
  803440:	c3                   	retq   

0000000000803441 <nsipc_close>:

int
nsipc_close(int s)
{
  803441:	55                   	push   %rbp
  803442:	48 89 e5             	mov    %rsp,%rbp
  803445:	48 83 ec 10          	sub    $0x10,%rsp
  803449:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80344c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803453:	00 00 00 
  803456:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803459:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80345b:	bf 04 00 00 00       	mov    $0x4,%edi
  803460:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
}
  80346c:	c9                   	leaveq 
  80346d:	c3                   	retq   

000000000080346e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	48 83 ec 10          	sub    $0x10,%rsp
  803476:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803479:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80347d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803480:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803487:	00 00 00 
  80348a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80348d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80348f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803496:	48 89 c6             	mov    %rax,%rsi
  803499:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8034a0:	00 00 00 
  8034a3:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8034af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8034b6:	00 00 00 
  8034b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034bc:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8034bf:	bf 05 00 00 00       	mov    $0x5,%edi
  8034c4:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  8034cb:	00 00 00 
  8034ce:	ff d0                	callq  *%rax
}
  8034d0:	c9                   	leaveq 
  8034d1:	c3                   	retq   

00000000008034d2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8034d2:	55                   	push   %rbp
  8034d3:	48 89 e5             	mov    %rsp,%rbp
  8034d6:	48 83 ec 10          	sub    $0x10,%rsp
  8034da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034dd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8034e0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8034e7:	00 00 00 
  8034ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034ed:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8034ef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8034f6:	00 00 00 
  8034f9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034fc:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8034ff:	bf 06 00 00 00       	mov    $0x6,%edi
  803504:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  80350b:	00 00 00 
  80350e:	ff d0                	callq  *%rax
}
  803510:	c9                   	leaveq 
  803511:	c3                   	retq   

0000000000803512 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803512:	55                   	push   %rbp
  803513:	48 89 e5             	mov    %rsp,%rbp
  803516:	48 83 ec 30          	sub    $0x30,%rsp
  80351a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80351d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803521:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803524:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803527:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80352e:	00 00 00 
  803531:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803534:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803536:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80353d:	00 00 00 
  803540:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803543:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803546:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80354d:	00 00 00 
  803550:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803553:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803556:	bf 07 00 00 00       	mov    $0x7,%edi
  80355b:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
  803567:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80356a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356e:	78 69                	js     8035d9 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803570:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803577:	7f 08                	jg     803581 <nsipc_recv+0x6f>
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80357f:	7e 35                	jle    8035b6 <nsipc_recv+0xa4>
  803581:	48 b9 ee 4e 80 00 00 	movabs $0x804eee,%rcx
  803588:	00 00 00 
  80358b:	48 ba 03 4f 80 00 00 	movabs $0x804f03,%rdx
  803592:	00 00 00 
  803595:	be 62 00 00 00       	mov    $0x62,%esi
  80359a:	48 bf 18 4f 80 00 00 	movabs $0x804f18,%rdi
  8035a1:	00 00 00 
  8035a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a9:	49 b8 56 3f 80 00 00 	movabs $0x803f56,%r8
  8035b0:	00 00 00 
  8035b3:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b9:	48 63 d0             	movslq %eax,%rdx
  8035bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c0:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8035c7:	00 00 00 
  8035ca:	48 89 c7             	mov    %rax,%rdi
  8035cd:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
	}

	return r;
  8035d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035dc:	c9                   	leaveq 
  8035dd:	c3                   	retq   

00000000008035de <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035de:	55                   	push   %rbp
  8035df:	48 89 e5             	mov    %rsp,%rbp
  8035e2:	48 83 ec 20          	sub    $0x20,%rsp
  8035e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ed:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8035f0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8035f3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035fa:	00 00 00 
  8035fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803600:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803602:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803609:	7e 35                	jle    803640 <nsipc_send+0x62>
  80360b:	48 b9 24 4f 80 00 00 	movabs $0x804f24,%rcx
  803612:	00 00 00 
  803615:	48 ba 03 4f 80 00 00 	movabs $0x804f03,%rdx
  80361c:	00 00 00 
  80361f:	be 6d 00 00 00       	mov    $0x6d,%esi
  803624:	48 bf 18 4f 80 00 00 	movabs $0x804f18,%rdi
  80362b:	00 00 00 
  80362e:	b8 00 00 00 00       	mov    $0x0,%eax
  803633:	49 b8 56 3f 80 00 00 	movabs $0x803f56,%r8
  80363a:	00 00 00 
  80363d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803640:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803643:	48 63 d0             	movslq %eax,%rdx
  803646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364a:	48 89 c6             	mov    %rax,%rsi
  80364d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803654:	00 00 00 
  803657:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803663:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80366a:	00 00 00 
  80366d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803670:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803673:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80367a:	00 00 00 
  80367d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803680:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803683:	bf 08 00 00 00       	mov    $0x8,%edi
  803688:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 10          	sub    $0x10,%rsp
  80369e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036a1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8036a4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8036a7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036ae:	00 00 00 
  8036b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036b4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8036b6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036bd:	00 00 00 
  8036c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036c3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8036c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036cd:	00 00 00 
  8036d0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8036d3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8036d6:	bf 09 00 00 00       	mov    $0x9,%edi
  8036db:	48 b8 9b 32 80 00 00 	movabs $0x80329b,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	53                   	push   %rbx
  8036ee:	48 83 ec 38          	sub    $0x38,%rsp
  8036f2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036f6:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8036fa:	48 89 c7             	mov    %rax,%rdi
  8036fd:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  803704:	00 00 00 
  803707:	ff d0                	callq  *%rax
  803709:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80370c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803710:	0f 88 bf 01 00 00    	js     8038d5 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371a:	ba 07 04 00 00       	mov    $0x407,%edx
  80371f:	48 89 c6             	mov    %rax,%rsi
  803722:	bf 00 00 00 00       	mov    $0x0,%edi
  803727:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
  803733:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803736:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80373a:	0f 88 95 01 00 00    	js     8038d5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803740:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803744:	48 89 c7             	mov    %rax,%rdi
  803747:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
  803753:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803756:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80375a:	0f 88 5d 01 00 00    	js     8038bd <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803760:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803764:	ba 07 04 00 00       	mov    $0x407,%edx
  803769:	48 89 c6             	mov    %rax,%rsi
  80376c:	bf 00 00 00 00       	mov    $0x0,%edi
  803771:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
  80377d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803780:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803784:	0f 88 33 01 00 00    	js     8038bd <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80378a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378e:	48 89 c7             	mov    %rax,%rdi
  803791:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
  80379d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a5:	ba 07 04 00 00       	mov    $0x407,%edx
  8037aa:	48 89 c6             	mov    %rax,%rsi
  8037ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b2:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
  8037be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037c5:	0f 88 d9 00 00 00    	js     8038a4 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037cf:	48 89 c7             	mov    %rax,%rdi
  8037d2:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
  8037de:	48 89 c2             	mov    %rax,%rdx
  8037e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037eb:	48 89 d1             	mov    %rdx,%rcx
  8037ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8037f3:	48 89 c6             	mov    %rax,%rsi
  8037f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8037fb:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803802:	00 00 00 
  803805:	ff d0                	callq  *%rax
  803807:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80380a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80380e:	78 79                	js     803889 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803814:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80381b:	00 00 00 
  80381e:	8b 12                	mov    (%rdx),%edx
  803820:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803826:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80382d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803831:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803838:	00 00 00 
  80383b:	8b 12                	mov    (%rdx),%edx
  80383d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80383f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803843:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80384a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384e:	48 89 c7             	mov    %rax,%rdi
  803851:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
  80385d:	89 c2                	mov    %eax,%edx
  80385f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803863:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803865:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803869:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80386d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803871:	48 89 c7             	mov    %rax,%rdi
  803874:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80387b:	00 00 00 
  80387e:	ff d0                	callq  *%rax
  803880:	89 03                	mov    %eax,(%rbx)
	return 0;
  803882:	b8 00 00 00 00       	mov    $0x0,%eax
  803887:	eb 4f                	jmp    8038d8 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803889:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80388a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388e:	48 89 c6             	mov    %rax,%rsi
  803891:	bf 00 00 00 00       	mov    $0x0,%edi
  803896:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
  8038a2:	eb 01                	jmp    8038a5 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8038a4:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8038a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a9:	48 89 c6             	mov    %rax,%rsi
  8038ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b1:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8038bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c1:	48 89 c6             	mov    %rax,%rsi
  8038c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c9:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
err:
	return r;
  8038d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038d8:	48 83 c4 38          	add    $0x38,%rsp
  8038dc:	5b                   	pop    %rbx
  8038dd:	5d                   	pop    %rbp
  8038de:	c3                   	retq   

00000000008038df <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038df:	55                   	push   %rbp
  8038e0:	48 89 e5             	mov    %rsp,%rbp
  8038e3:	53                   	push   %rbx
  8038e4:	48 83 ec 28          	sub    $0x28,%rsp
  8038e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038f0:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8038f7:	00 00 00 
  8038fa:	48 8b 00             	mov    (%rax),%rax
  8038fd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803903:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390a:	48 89 c7             	mov    %rax,%rdi
  80390d:	48 b8 31 42 80 00 00 	movabs $0x804231,%rax
  803914:	00 00 00 
  803917:	ff d0                	callq  *%rax
  803919:	89 c3                	mov    %eax,%ebx
  80391b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80391f:	48 89 c7             	mov    %rax,%rdi
  803922:	48 b8 31 42 80 00 00 	movabs $0x804231,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	39 c3                	cmp    %eax,%ebx
  803930:	0f 94 c0             	sete   %al
  803933:	0f b6 c0             	movzbl %al,%eax
  803936:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803939:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803940:	00 00 00 
  803943:	48 8b 00             	mov    (%rax),%rax
  803946:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80394c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80394f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803952:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803955:	75 05                	jne    80395c <_pipeisclosed+0x7d>
			return ret;
  803957:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80395a:	eb 4a                	jmp    8039a6 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80395c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803962:	74 8c                	je     8038f0 <_pipeisclosed+0x11>
  803964:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803968:	75 86                	jne    8038f0 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80396a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803971:	00 00 00 
  803974:	48 8b 00             	mov    (%rax),%rax
  803977:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80397d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803980:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803983:	89 c6                	mov    %eax,%esi
  803985:	48 bf 35 4f 80 00 00 	movabs $0x804f35,%rdi
  80398c:	00 00 00 
  80398f:	b8 00 00 00 00       	mov    $0x0,%eax
  803994:	49 b8 ea 04 80 00 00 	movabs $0x8004ea,%r8
  80399b:	00 00 00 
  80399e:	41 ff d0             	callq  *%r8
	}
  8039a1:	e9 4a ff ff ff       	jmpq   8038f0 <_pipeisclosed+0x11>

}
  8039a6:	48 83 c4 28          	add    $0x28,%rsp
  8039aa:	5b                   	pop    %rbx
  8039ab:	5d                   	pop    %rbp
  8039ac:	c3                   	retq   

00000000008039ad <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8039ad:	55                   	push   %rbp
  8039ae:	48 89 e5             	mov    %rsp,%rbp
  8039b1:	48 83 ec 30          	sub    $0x30,%rsp
  8039b5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039bf:	48 89 d6             	mov    %rdx,%rsi
  8039c2:	89 c7                	mov    %eax,%edi
  8039c4:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  8039cb:	00 00 00 
  8039ce:	ff d0                	callq  *%rax
  8039d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d7:	79 05                	jns    8039de <pipeisclosed+0x31>
		return r;
  8039d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039dc:	eb 31                	jmp    803a0f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e2:	48 89 c7             	mov    %rax,%rdi
  8039e5:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  8039ec:	00 00 00 
  8039ef:	ff d0                	callq  *%rax
  8039f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039fd:	48 89 d6             	mov    %rdx,%rsi
  803a00:	48 89 c7             	mov    %rax,%rdi
  803a03:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
}
  803a0f:	c9                   	leaveq 
  803a10:	c3                   	retq   

0000000000803a11 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a11:	55                   	push   %rbp
  803a12:	48 89 e5             	mov    %rsp,%rbp
  803a15:	48 83 ec 40          	sub    $0x40,%rsp
  803a19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a29:	48 89 c7             	mov    %rax,%rdi
  803a2c:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
  803a38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a4b:	00 
  803a4c:	e9 90 00 00 00       	jmpq   803ae1 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a51:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a56:	74 09                	je     803a61 <devpipe_read+0x50>
				return i;
  803a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5c:	e9 8e 00 00 00       	jmpq   803aef <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a69:	48 89 d6             	mov    %rdx,%rsi
  803a6c:	48 89 c7             	mov    %rax,%rdi
  803a6f:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
  803a7b:	85 c0                	test   %eax,%eax
  803a7d:	74 07                	je     803a86 <devpipe_read+0x75>
				return 0;
  803a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a84:	eb 69                	jmp    803aef <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a86:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a96:	8b 10                	mov    (%rax),%edx
  803a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9c:	8b 40 04             	mov    0x4(%rax),%eax
  803a9f:	39 c2                	cmp    %eax,%edx
  803aa1:	74 ae                	je     803a51 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aab:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803aaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab3:	8b 00                	mov    (%rax),%eax
  803ab5:	99                   	cltd   
  803ab6:	c1 ea 1b             	shr    $0x1b,%edx
  803ab9:	01 d0                	add    %edx,%eax
  803abb:	83 e0 1f             	and    $0x1f,%eax
  803abe:	29 d0                	sub    %edx,%eax
  803ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac4:	48 98                	cltq   
  803ac6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803acb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803acd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad1:	8b 00                	mov    (%rax),%eax
  803ad3:	8d 50 01             	lea    0x1(%rax),%edx
  803ad6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ada:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803adc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ae9:	72 a7                	jb     803a92 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803aef:	c9                   	leaveq 
  803af0:	c3                   	retq   

0000000000803af1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803af1:	55                   	push   %rbp
  803af2:	48 89 e5             	mov    %rsp,%rbp
  803af5:	48 83 ec 40          	sub    $0x40,%rsp
  803af9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803afd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b01:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b09:	48 89 c7             	mov    %rax,%rdi
  803b0c:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
  803b18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b24:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b2b:	00 
  803b2c:	e9 8f 00 00 00       	jmpq   803bc0 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b39:	48 89 d6             	mov    %rdx,%rsi
  803b3c:	48 89 c7             	mov    %rax,%rdi
  803b3f:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803b46:	00 00 00 
  803b49:	ff d0                	callq  *%rax
  803b4b:	85 c0                	test   %eax,%eax
  803b4d:	74 07                	je     803b56 <devpipe_write+0x65>
				return 0;
  803b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b54:	eb 78                	jmp    803bce <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b56:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b66:	8b 40 04             	mov    0x4(%rax),%eax
  803b69:	48 63 d0             	movslq %eax,%rdx
  803b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b70:	8b 00                	mov    (%rax),%eax
  803b72:	48 98                	cltq   
  803b74:	48 83 c0 20          	add    $0x20,%rax
  803b78:	48 39 c2             	cmp    %rax,%rdx
  803b7b:	73 b4                	jae    803b31 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b81:	8b 40 04             	mov    0x4(%rax),%eax
  803b84:	99                   	cltd   
  803b85:	c1 ea 1b             	shr    $0x1b,%edx
  803b88:	01 d0                	add    %edx,%eax
  803b8a:	83 e0 1f             	and    $0x1f,%eax
  803b8d:	29 d0                	sub    %edx,%eax
  803b8f:	89 c6                	mov    %eax,%esi
  803b91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b99:	48 01 d0             	add    %rdx,%rax
  803b9c:	0f b6 08             	movzbl (%rax),%ecx
  803b9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ba3:	48 63 c6             	movslq %esi,%rax
  803ba6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803baa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bae:	8b 40 04             	mov    0x4(%rax),%eax
  803bb1:	8d 50 01             	lea    0x1(%rax),%edx
  803bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bbb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bc8:	72 98                	jb     803b62 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803bca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803bce:	c9                   	leaveq 
  803bcf:	c3                   	retq   

0000000000803bd0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803bd0:	55                   	push   %rbp
  803bd1:	48 89 e5             	mov    %rsp,%rbp
  803bd4:	48 83 ec 20          	sub    $0x20,%rsp
  803bd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bdc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be4:	48 89 c7             	mov    %rax,%rdi
  803be7:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  803bee:	00 00 00 
  803bf1:	ff d0                	callq  *%rax
  803bf3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803bf7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bfb:	48 be 48 4f 80 00 00 	movabs $0x804f48,%rsi
  803c02:	00 00 00 
  803c05:	48 89 c7             	mov    %rax,%rdi
  803c08:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c18:	8b 50 04             	mov    0x4(%rax),%edx
  803c1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1f:	8b 00                	mov    (%rax),%eax
  803c21:	29 c2                	sub    %eax,%edx
  803c23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c27:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c31:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c38:	00 00 00 
	stat->st_dev = &devpipe;
  803c3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3f:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  803c46:	00 00 00 
  803c49:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c55:	c9                   	leaveq 
  803c56:	c3                   	retq   

0000000000803c57 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c57:	55                   	push   %rbp
  803c58:	48 89 e5             	mov    %rsp,%rbp
  803c5b:	48 83 ec 10          	sub    $0x10,%rsp
  803c5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803c63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c67:	48 89 c6             	mov    %rax,%rsi
  803c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6f:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803c7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c7f:	48 89 c7             	mov    %rax,%rdi
  803c82:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  803c89:	00 00 00 
  803c8c:	ff d0                	callq  *%rax
  803c8e:	48 89 c6             	mov    %rax,%rsi
  803c91:	bf 00 00 00 00       	mov    $0x0,%edi
  803c96:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
}
  803ca2:	c9                   	leaveq 
  803ca3:	c3                   	retq   

0000000000803ca4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 20          	sub    $0x20,%rsp
  803cac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803caf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803cb5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803cb9:	be 01 00 00 00       	mov    $0x1,%esi
  803cbe:	48 89 c7             	mov    %rax,%rdi
  803cc1:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803cc8:	00 00 00 
  803ccb:	ff d0                	callq  *%rax
}
  803ccd:	90                   	nop
  803cce:	c9                   	leaveq 
  803ccf:	c3                   	retq   

0000000000803cd0 <getchar>:

int
getchar(void)
{
  803cd0:	55                   	push   %rbp
  803cd1:	48 89 e5             	mov    %rsp,%rbp
  803cd4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803cd8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803cdc:	ba 01 00 00 00       	mov    $0x1,%edx
  803ce1:	48 89 c6             	mov    %rax,%rsi
  803ce4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce9:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  803cf0:	00 00 00 
  803cf3:	ff d0                	callq  *%rax
  803cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfc:	79 05                	jns    803d03 <getchar+0x33>
		return r;
  803cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d01:	eb 14                	jmp    803d17 <getchar+0x47>
	if (r < 1)
  803d03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d07:	7f 07                	jg     803d10 <getchar+0x40>
		return -E_EOF;
  803d09:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d0e:	eb 07                	jmp    803d17 <getchar+0x47>
	return c;
  803d10:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d14:	0f b6 c0             	movzbl %al,%eax

}
  803d17:	c9                   	leaveq 
  803d18:	c3                   	retq   

0000000000803d19 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d19:	55                   	push   %rbp
  803d1a:	48 89 e5             	mov    %rsp,%rbp
  803d1d:	48 83 ec 20          	sub    $0x20,%rsp
  803d21:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d24:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2b:	48 89 d6             	mov    %rdx,%rsi
  803d2e:	89 c7                	mov    %eax,%edi
  803d30:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
  803d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d43:	79 05                	jns    803d4a <iscons+0x31>
		return r;
  803d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d48:	eb 1a                	jmp    803d64 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d4e:	8b 10                	mov    (%rax),%edx
  803d50:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803d57:	00 00 00 
  803d5a:	8b 00                	mov    (%rax),%eax
  803d5c:	39 c2                	cmp    %eax,%edx
  803d5e:	0f 94 c0             	sete   %al
  803d61:	0f b6 c0             	movzbl %al,%eax
}
  803d64:	c9                   	leaveq 
  803d65:	c3                   	retq   

0000000000803d66 <opencons>:

int
opencons(void)
{
  803d66:	55                   	push   %rbp
  803d67:	48 89 e5             	mov    %rsp,%rbp
  803d6a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d6e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d72:	48 89 c7             	mov    %rax,%rdi
  803d75:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  803d7c:	00 00 00 
  803d7f:	ff d0                	callq  *%rax
  803d81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d88:	79 05                	jns    803d8f <opencons+0x29>
		return r;
  803d8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8d:	eb 5b                	jmp    803dea <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d93:	ba 07 04 00 00       	mov    $0x407,%edx
  803d98:	48 89 c6             	mov    %rax,%rsi
  803d9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803da0:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803da7:	00 00 00 
  803daa:	ff d0                	callq  *%rax
  803dac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803daf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db3:	79 05                	jns    803dba <opencons+0x54>
		return r;
  803db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db8:	eb 30                	jmp    803dea <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbe:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  803dc5:	00 00 00 
  803dc8:	8b 12                	mov    (%rdx),%edx
  803dca:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddb:	48 89 c7             	mov    %rax,%rdi
  803dde:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  803de5:	00 00 00 
  803de8:	ff d0                	callq  *%rax
}
  803dea:	c9                   	leaveq 
  803deb:	c3                   	retq   

0000000000803dec <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dec:	55                   	push   %rbp
  803ded:	48 89 e5             	mov    %rsp,%rbp
  803df0:	48 83 ec 30          	sub    $0x30,%rsp
  803df4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803df8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dfc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e00:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e05:	75 13                	jne    803e1a <devcons_read+0x2e>
		return 0;
  803e07:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0c:	eb 49                	jmp    803e57 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e0e:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e1a:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  803e21:	00 00 00 
  803e24:	ff d0                	callq  *%rax
  803e26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e2d:	74 df                	je     803e0e <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803e2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e33:	79 05                	jns    803e3a <devcons_read+0x4e>
		return c;
  803e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e38:	eb 1d                	jmp    803e57 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803e3a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803e3e:	75 07                	jne    803e47 <devcons_read+0x5b>
		return 0;
  803e40:	b8 00 00 00 00       	mov    $0x0,%eax
  803e45:	eb 10                	jmp    803e57 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4a:	89 c2                	mov    %eax,%edx
  803e4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e50:	88 10                	mov    %dl,(%rax)
	return 1;
  803e52:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e57:	c9                   	leaveq 
  803e58:	c3                   	retq   

0000000000803e59 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e59:	55                   	push   %rbp
  803e5a:	48 89 e5             	mov    %rsp,%rbp
  803e5d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e64:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e6b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e72:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e80:	eb 76                	jmp    803ef8 <devcons_write+0x9f>
		m = n - tot;
  803e82:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e89:	89 c2                	mov    %eax,%edx
  803e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8e:	29 c2                	sub    %eax,%edx
  803e90:	89 d0                	mov    %edx,%eax
  803e92:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e98:	83 f8 7f             	cmp    $0x7f,%eax
  803e9b:	76 07                	jbe    803ea4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e9d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ea4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea7:	48 63 d0             	movslq %eax,%rdx
  803eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ead:	48 63 c8             	movslq %eax,%rcx
  803eb0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803eb7:	48 01 c1             	add    %rax,%rcx
  803eba:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ec1:	48 89 ce             	mov    %rcx,%rsi
  803ec4:	48 89 c7             	mov    %rax,%rdi
  803ec7:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  803ece:	00 00 00 
  803ed1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ed3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ed6:	48 63 d0             	movslq %eax,%rdx
  803ed9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ee0:	48 89 d6             	mov    %rdx,%rsi
  803ee3:	48 89 c7             	mov    %rax,%rdi
  803ee6:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803eed:	00 00 00 
  803ef0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ef2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ef5:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efb:	48 98                	cltq   
  803efd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f04:	0f 82 78 ff ff ff    	jb     803e82 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f0d:	c9                   	leaveq 
  803f0e:	c3                   	retq   

0000000000803f0f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f0f:	55                   	push   %rbp
  803f10:	48 89 e5             	mov    %rsp,%rbp
  803f13:	48 83 ec 08          	sub    $0x8,%rsp
  803f17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f20:	c9                   	leaveq 
  803f21:	c3                   	retq   

0000000000803f22 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f22:	55                   	push   %rbp
  803f23:	48 89 e5             	mov    %rsp,%rbp
  803f26:	48 83 ec 10          	sub    $0x10,%rsp
  803f2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f36:	48 be 54 4f 80 00 00 	movabs $0x804f54,%rsi
  803f3d:	00 00 00 
  803f40:	48 89 c7             	mov    %rax,%rdi
  803f43:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  803f4a:	00 00 00 
  803f4d:	ff d0                	callq  *%rax
	return 0;
  803f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f54:	c9                   	leaveq 
  803f55:	c3                   	retq   

0000000000803f56 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803f56:	55                   	push   %rbp
  803f57:	48 89 e5             	mov    %rsp,%rbp
  803f5a:	53                   	push   %rbx
  803f5b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803f62:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803f69:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803f6f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f76:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803f7d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803f84:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803f8b:	84 c0                	test   %al,%al
  803f8d:	74 23                	je     803fb2 <_panic+0x5c>
  803f8f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803f96:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803f9a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803f9e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803fa2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803fa6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803faa:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803fae:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803fb2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803fb9:	00 00 00 
  803fbc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803fc3:	00 00 00 
  803fc6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803fca:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803fd1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803fd8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803fdf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fe6:	00 00 00 
  803fe9:	48 8b 18             	mov    (%rax),%rbx
  803fec:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  803ff3:	00 00 00 
  803ff6:	ff d0                	callq  *%rax
  803ff8:	89 c6                	mov    %eax,%esi
  803ffa:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  804000:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804007:	41 89 d0             	mov    %edx,%r8d
  80400a:	48 89 c1             	mov    %rax,%rcx
  80400d:	48 89 da             	mov    %rbx,%rdx
  804010:	48 bf 60 4f 80 00 00 	movabs $0x804f60,%rdi
  804017:	00 00 00 
  80401a:	b8 00 00 00 00       	mov    $0x0,%eax
  80401f:	49 b9 ea 04 80 00 00 	movabs $0x8004ea,%r9
  804026:	00 00 00 
  804029:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80402c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804033:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80403a:	48 89 d6             	mov    %rdx,%rsi
  80403d:	48 89 c7             	mov    %rax,%rdi
  804040:	48 b8 3e 04 80 00 00 	movabs $0x80043e,%rax
  804047:	00 00 00 
  80404a:	ff d0                	callq  *%rax
	cprintf("\n");
  80404c:	48 bf 83 4f 80 00 00 	movabs $0x804f83,%rdi
  804053:	00 00 00 
  804056:	b8 00 00 00 00       	mov    $0x0,%eax
  80405b:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  804062:	00 00 00 
  804065:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804067:	cc                   	int3   
  804068:	eb fd                	jmp    804067 <_panic+0x111>

000000000080406a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80406a:	55                   	push   %rbp
  80406b:	48 89 e5             	mov    %rsp,%rbp
  80406e:	48 83 ec 30          	sub    $0x30,%rsp
  804072:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804076:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80407a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80407e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804083:	75 0e                	jne    804093 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804085:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80408c:	00 00 00 
  80408f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804097:	48 89 c7             	mov    %rax,%rdi
  80409a:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8040a1:	00 00 00 
  8040a4:	ff d0                	callq  *%rax
  8040a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ad:	79 27                	jns    8040d6 <ipc_recv+0x6c>
		if (from_env_store)
  8040af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040b4:	74 0a                	je     8040c0 <ipc_recv+0x56>
			*from_env_store = 0;
  8040b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8040c0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040c5:	74 0a                	je     8040d1 <ipc_recv+0x67>
			*perm_store = 0;
  8040c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8040d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d4:	eb 53                	jmp    804129 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8040d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040db:	74 19                	je     8040f6 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8040dd:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8040e4:	00 00 00 
  8040e7:	48 8b 00             	mov    (%rax),%rax
  8040ea:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8040f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f4:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8040f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040fb:	74 19                	je     804116 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8040fd:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804104:	00 00 00 
  804107:	48 8b 00             	mov    (%rax),%rax
  80410a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804110:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804114:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804116:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80411d:	00 00 00 
  804120:	48 8b 00             	mov    (%rax),%rax
  804123:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804129:	c9                   	leaveq 
  80412a:	c3                   	retq   

000000000080412b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80412b:	55                   	push   %rbp
  80412c:	48 89 e5             	mov    %rsp,%rbp
  80412f:	48 83 ec 30          	sub    $0x30,%rsp
  804133:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804136:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804139:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80413d:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804140:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804145:	75 1c                	jne    804163 <ipc_send+0x38>
		pg = (void*) UTOP;
  804147:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80414e:	00 00 00 
  804151:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804155:	eb 0c                	jmp    804163 <ipc_send+0x38>
		sys_yield();
  804157:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  80415e:	00 00 00 
  804161:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804163:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804166:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804169:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80416d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804170:	89 c7                	mov    %eax,%edi
  804172:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  804179:	00 00 00 
  80417c:	ff d0                	callq  *%rax
  80417e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804181:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804185:	74 d0                	je     804157 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80418b:	79 30                	jns    8041bd <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80418d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804190:	89 c1                	mov    %eax,%ecx
  804192:	48 ba 85 4f 80 00 00 	movabs $0x804f85,%rdx
  804199:	00 00 00 
  80419c:	be 47 00 00 00       	mov    $0x47,%esi
  8041a1:	48 bf 9b 4f 80 00 00 	movabs $0x804f9b,%rdi
  8041a8:	00 00 00 
  8041ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b0:	49 b8 56 3f 80 00 00 	movabs $0x803f56,%r8
  8041b7:	00 00 00 
  8041ba:	41 ff d0             	callq  *%r8

}
  8041bd:	90                   	nop
  8041be:	c9                   	leaveq 
  8041bf:	c3                   	retq   

00000000008041c0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041c0:	55                   	push   %rbp
  8041c1:	48 89 e5             	mov    %rsp,%rbp
  8041c4:	48 83 ec 18          	sub    $0x18,%rsp
  8041c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041d2:	eb 4d                	jmp    804221 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8041d4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041db:	00 00 00 
  8041de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e1:	48 98                	cltq   
  8041e3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041ea:	48 01 d0             	add    %rdx,%rax
  8041ed:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041f3:	8b 00                	mov    (%rax),%eax
  8041f5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8041f8:	75 23                	jne    80421d <ipc_find_env+0x5d>
			return envs[i].env_id;
  8041fa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804201:	00 00 00 
  804204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804207:	48 98                	cltq   
  804209:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804210:	48 01 d0             	add    %rdx,%rax
  804213:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804219:	8b 00                	mov    (%rax),%eax
  80421b:	eb 12                	jmp    80422f <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80421d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804221:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804228:	7e aa                	jle    8041d4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80422a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80422f:	c9                   	leaveq 
  804230:	c3                   	retq   

0000000000804231 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804231:	55                   	push   %rbp
  804232:	48 89 e5             	mov    %rsp,%rbp
  804235:	48 83 ec 18          	sub    $0x18,%rsp
  804239:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80423d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804241:	48 c1 e8 15          	shr    $0x15,%rax
  804245:	48 89 c2             	mov    %rax,%rdx
  804248:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80424f:	01 00 00 
  804252:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804256:	83 e0 01             	and    $0x1,%eax
  804259:	48 85 c0             	test   %rax,%rax
  80425c:	75 07                	jne    804265 <pageref+0x34>
		return 0;
  80425e:	b8 00 00 00 00       	mov    $0x0,%eax
  804263:	eb 56                	jmp    8042bb <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804269:	48 c1 e8 0c          	shr    $0xc,%rax
  80426d:	48 89 c2             	mov    %rax,%rdx
  804270:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804277:	01 00 00 
  80427a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80427e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804286:	83 e0 01             	and    $0x1,%eax
  804289:	48 85 c0             	test   %rax,%rax
  80428c:	75 07                	jne    804295 <pageref+0x64>
		return 0;
  80428e:	b8 00 00 00 00       	mov    $0x0,%eax
  804293:	eb 26                	jmp    8042bb <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804299:	48 c1 e8 0c          	shr    $0xc,%rax
  80429d:	48 89 c2             	mov    %rax,%rdx
  8042a0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042a7:	00 00 00 
  8042aa:	48 c1 e2 04          	shl    $0x4,%rdx
  8042ae:	48 01 d0             	add    %rdx,%rax
  8042b1:	48 83 c0 08          	add    $0x8,%rax
  8042b5:	0f b7 00             	movzwl (%rax),%eax
  8042b8:	0f b7 c0             	movzwl %ax,%eax
}
  8042bb:	c9                   	leaveq 
  8042bc:	c3                   	retq   

00000000008042bd <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8042bd:	55                   	push   %rbp
  8042be:	48 89 e5             	mov    %rsp,%rbp
  8042c1:	48 83 ec 20          	sub    $0x20,%rsp
  8042c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8042c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d1:	48 89 d6             	mov    %rdx,%rsi
  8042d4:	48 89 c7             	mov    %rax,%rdi
  8042d7:	48 b8 f3 42 80 00 00 	movabs $0x8042f3,%rax
  8042de:	00 00 00 
  8042e1:	ff d0                	callq  *%rax
  8042e3:	85 c0                	test   %eax,%eax
  8042e5:	74 05                	je     8042ec <inet_addr+0x2f>
    return (val.s_addr);
  8042e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8042ea:	eb 05                	jmp    8042f1 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  8042ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8042f1:	c9                   	leaveq 
  8042f2:	c3                   	retq   

00000000008042f3 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8042f3:	55                   	push   %rbp
  8042f4:	48 89 e5             	mov    %rsp,%rbp
  8042f7:	48 83 ec 40          	sub    $0x40,%rsp
  8042fb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8042ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804303:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804307:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  80430b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80430f:	0f b6 00             	movzbl (%rax),%eax
  804312:	0f be c0             	movsbl %al,%eax
  804315:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804318:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80431b:	0f b6 c0             	movzbl %al,%eax
  80431e:	83 f8 2f             	cmp    $0x2f,%eax
  804321:	7e 0b                	jle    80432e <inet_aton+0x3b>
  804323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804326:	0f b6 c0             	movzbl %al,%eax
  804329:	83 f8 39             	cmp    $0x39,%eax
  80432c:	7e 0a                	jle    804338 <inet_aton+0x45>
      return (0);
  80432e:	b8 00 00 00 00       	mov    $0x0,%eax
  804333:	e9 a1 02 00 00       	jmpq   8045d9 <inet_aton+0x2e6>
    val = 0;
  804338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  80433f:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804346:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  80434a:	75 40                	jne    80438c <inet_aton+0x99>
      c = *++cp;
  80434c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804351:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804355:	0f b6 00             	movzbl (%rax),%eax
  804358:	0f be c0             	movsbl %al,%eax
  80435b:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80435e:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804362:	74 06                	je     80436a <inet_aton+0x77>
  804364:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804368:	75 1b                	jne    804385 <inet_aton+0x92>
        base = 16;
  80436a:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804371:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804376:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80437a:	0f b6 00             	movzbl (%rax),%eax
  80437d:	0f be c0             	movsbl %al,%eax
  804380:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804383:	eb 07                	jmp    80438c <inet_aton+0x99>
      } else
        base = 8;
  804385:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80438c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80438f:	0f b6 c0             	movzbl %al,%eax
  804392:	83 f8 2f             	cmp    $0x2f,%eax
  804395:	7e 36                	jle    8043cd <inet_aton+0xda>
  804397:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80439a:	0f b6 c0             	movzbl %al,%eax
  80439d:	83 f8 39             	cmp    $0x39,%eax
  8043a0:	7f 2b                	jg     8043cd <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  8043a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043a5:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  8043a9:	89 c2                	mov    %eax,%edx
  8043ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043ae:	01 d0                	add    %edx,%eax
  8043b0:	83 e8 30             	sub    $0x30,%eax
  8043b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8043b6:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8043bb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043bf:	0f b6 00             	movzbl (%rax),%eax
  8043c2:	0f be c0             	movsbl %al,%eax
  8043c5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8043c8:	e9 97 00 00 00       	jmpq   804464 <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  8043cd:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  8043d1:	0f 85 92 00 00 00    	jne    804469 <inet_aton+0x176>
  8043d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043da:	0f b6 c0             	movzbl %al,%eax
  8043dd:	83 f8 2f             	cmp    $0x2f,%eax
  8043e0:	7e 0b                	jle    8043ed <inet_aton+0xfa>
  8043e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043e5:	0f b6 c0             	movzbl %al,%eax
  8043e8:	83 f8 39             	cmp    $0x39,%eax
  8043eb:	7e 2c                	jle    804419 <inet_aton+0x126>
  8043ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043f0:	0f b6 c0             	movzbl %al,%eax
  8043f3:	83 f8 60             	cmp    $0x60,%eax
  8043f6:	7e 0b                	jle    804403 <inet_aton+0x110>
  8043f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043fb:	0f b6 c0             	movzbl %al,%eax
  8043fe:	83 f8 66             	cmp    $0x66,%eax
  804401:	7e 16                	jle    804419 <inet_aton+0x126>
  804403:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804406:	0f b6 c0             	movzbl %al,%eax
  804409:	83 f8 40             	cmp    $0x40,%eax
  80440c:	7e 5b                	jle    804469 <inet_aton+0x176>
  80440e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804411:	0f b6 c0             	movzbl %al,%eax
  804414:	83 f8 46             	cmp    $0x46,%eax
  804417:	7f 50                	jg     804469 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441c:	c1 e0 04             	shl    $0x4,%eax
  80441f:	89 c2                	mov    %eax,%edx
  804421:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804424:	8d 48 0a             	lea    0xa(%rax),%ecx
  804427:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80442a:	0f b6 c0             	movzbl %al,%eax
  80442d:	83 f8 60             	cmp    $0x60,%eax
  804430:	7e 12                	jle    804444 <inet_aton+0x151>
  804432:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804435:	0f b6 c0             	movzbl %al,%eax
  804438:	83 f8 7a             	cmp    $0x7a,%eax
  80443b:	7f 07                	jg     804444 <inet_aton+0x151>
  80443d:	b8 61 00 00 00       	mov    $0x61,%eax
  804442:	eb 05                	jmp    804449 <inet_aton+0x156>
  804444:	b8 41 00 00 00       	mov    $0x41,%eax
  804449:	29 c1                	sub    %eax,%ecx
  80444b:	89 c8                	mov    %ecx,%eax
  80444d:	09 d0                	or     %edx,%eax
  80444f:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804452:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804457:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80445b:	0f b6 00             	movzbl (%rax),%eax
  80445e:	0f be c0             	movsbl %al,%eax
  804461:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  804464:	e9 23 ff ff ff       	jmpq   80438c <inet_aton+0x99>
    if (c == '.') {
  804469:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  80446d:	75 40                	jne    8044af <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80446f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804473:	48 83 c0 0c          	add    $0xc,%rax
  804477:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80447b:	77 0a                	ja     804487 <inet_aton+0x194>
        return (0);
  80447d:	b8 00 00 00 00       	mov    $0x0,%eax
  804482:	e9 52 01 00 00       	jmpq   8045d9 <inet_aton+0x2e6>
      *pp++ = val;
  804487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80448b:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80448f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804493:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804496:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804498:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80449d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044a1:	0f b6 00             	movzbl (%rax),%eax
  8044a4:	0f be c0             	movsbl %al,%eax
  8044a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8044aa:	e9 69 fe ff ff       	jmpq   804318 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8044af:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8044b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8044b4:	74 44                	je     8044fa <inet_aton+0x207>
  8044b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044b9:	0f b6 c0             	movzbl %al,%eax
  8044bc:	83 f8 1f             	cmp    $0x1f,%eax
  8044bf:	7e 2f                	jle    8044f0 <inet_aton+0x1fd>
  8044c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044c4:	0f b6 c0             	movzbl %al,%eax
  8044c7:	83 f8 7f             	cmp    $0x7f,%eax
  8044ca:	7f 24                	jg     8044f0 <inet_aton+0x1fd>
  8044cc:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8044d0:	74 28                	je     8044fa <inet_aton+0x207>
  8044d2:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8044d6:	74 22                	je     8044fa <inet_aton+0x207>
  8044d8:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8044dc:	74 1c                	je     8044fa <inet_aton+0x207>
  8044de:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8044e2:	74 16                	je     8044fa <inet_aton+0x207>
  8044e4:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  8044e8:	74 10                	je     8044fa <inet_aton+0x207>
  8044ea:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  8044ee:	74 0a                	je     8044fa <inet_aton+0x207>
    return (0);
  8044f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f5:	e9 df 00 00 00       	jmpq   8045d9 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8044fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044fe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804502:	48 29 c2             	sub    %rax,%rdx
  804505:	48 89 d0             	mov    %rdx,%rax
  804508:	48 c1 f8 02          	sar    $0x2,%rax
  80450c:	83 c0 01             	add    $0x1,%eax
  80450f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  804512:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804516:	0f 87 98 00 00 00    	ja     8045b4 <inet_aton+0x2c1>
  80451c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80451f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804526:	00 
  804527:	48 b8 a8 4f 80 00 00 	movabs $0x804fa8,%rax
  80452e:	00 00 00 
  804531:	48 01 d0             	add    %rdx,%rax
  804534:	48 8b 00             	mov    (%rax),%rax
  804537:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804539:	b8 00 00 00 00       	mov    $0x0,%eax
  80453e:	e9 96 00 00 00       	jmpq   8045d9 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804543:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  80454a:	76 0a                	jbe    804556 <inet_aton+0x263>
      return (0);
  80454c:	b8 00 00 00 00       	mov    $0x0,%eax
  804551:	e9 83 00 00 00       	jmpq   8045d9 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  804556:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804559:	c1 e0 18             	shl    $0x18,%eax
  80455c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80455f:	eb 53                	jmp    8045b4 <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804561:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804568:	76 07                	jbe    804571 <inet_aton+0x27e>
      return (0);
  80456a:	b8 00 00 00 00       	mov    $0x0,%eax
  80456f:	eb 68                	jmp    8045d9 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804571:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804574:	c1 e0 18             	shl    $0x18,%eax
  804577:	89 c2                	mov    %eax,%edx
  804579:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80457c:	c1 e0 10             	shl    $0x10,%eax
  80457f:	09 d0                	or     %edx,%eax
  804581:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804584:	eb 2e                	jmp    8045b4 <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804586:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  80458d:	76 07                	jbe    804596 <inet_aton+0x2a3>
      return (0);
  80458f:	b8 00 00 00 00       	mov    $0x0,%eax
  804594:	eb 43                	jmp    8045d9 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804596:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804599:	c1 e0 18             	shl    $0x18,%eax
  80459c:	89 c2                	mov    %eax,%edx
  80459e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8045a1:	c1 e0 10             	shl    $0x10,%eax
  8045a4:	09 c2                	or     %eax,%edx
  8045a6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8045a9:	c1 e0 08             	shl    $0x8,%eax
  8045ac:	09 d0                	or     %edx,%eax
  8045ae:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045b1:	eb 01                	jmp    8045b4 <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8045b3:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8045b4:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8045b9:	74 19                	je     8045d4 <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  8045bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045be:	89 c7                	mov    %eax,%edi
  8045c0:	48 b8 52 47 80 00 00 	movabs $0x804752,%rax
  8045c7:	00 00 00 
  8045ca:	ff d0                	callq  *%rax
  8045cc:	89 c2                	mov    %eax,%edx
  8045ce:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8045d2:	89 10                	mov    %edx,(%rax)
  return (1);
  8045d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045d9:	c9                   	leaveq 
  8045da:	c3                   	retq   

00000000008045db <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8045db:	55                   	push   %rbp
  8045dc:	48 89 e5             	mov    %rsp,%rbp
  8045df:	48 83 ec 30          	sub    $0x30,%rsp
  8045e3:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8045e6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045e9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8045ec:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8045f3:	00 00 00 
  8045f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8045fa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8045fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804602:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804606:	e9 e0 00 00 00       	jmpq   8046eb <inet_ntoa+0x110>
    i = 0;
  80460b:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80460f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804613:	0f b6 08             	movzbl (%rax),%ecx
  804616:	0f b6 d1             	movzbl %cl,%edx
  804619:	89 d0                	mov    %edx,%eax
  80461b:	c1 e0 02             	shl    $0x2,%eax
  80461e:	01 d0                	add    %edx,%eax
  804620:	c1 e0 03             	shl    $0x3,%eax
  804623:	01 d0                	add    %edx,%eax
  804625:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80462c:	01 d0                	add    %edx,%eax
  80462e:	66 c1 e8 08          	shr    $0x8,%ax
  804632:	c0 e8 03             	shr    $0x3,%al
  804635:	88 45 ed             	mov    %al,-0x13(%rbp)
  804638:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80463c:	89 d0                	mov    %edx,%eax
  80463e:	c1 e0 02             	shl    $0x2,%eax
  804641:	01 d0                	add    %edx,%eax
  804643:	01 c0                	add    %eax,%eax
  804645:	29 c1                	sub    %eax,%ecx
  804647:	89 c8                	mov    %ecx,%eax
  804649:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  80464c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804650:	0f b6 00             	movzbl (%rax),%eax
  804653:	0f b6 d0             	movzbl %al,%edx
  804656:	89 d0                	mov    %edx,%eax
  804658:	c1 e0 02             	shl    $0x2,%eax
  80465b:	01 d0                	add    %edx,%eax
  80465d:	c1 e0 03             	shl    $0x3,%eax
  804660:	01 d0                	add    %edx,%eax
  804662:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804669:	01 d0                	add    %edx,%eax
  80466b:	66 c1 e8 08          	shr    $0x8,%ax
  80466f:	89 c2                	mov    %eax,%edx
  804671:	c0 ea 03             	shr    $0x3,%dl
  804674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804678:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  80467a:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80467e:	8d 50 01             	lea    0x1(%rax),%edx
  804681:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804684:	0f b6 c0             	movzbl %al,%eax
  804687:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80468b:	83 c2 30             	add    $0x30,%edx
  80468e:	48 98                	cltq   
  804690:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  804694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804698:	0f b6 00             	movzbl (%rax),%eax
  80469b:	84 c0                	test   %al,%al
  80469d:	0f 85 6c ff ff ff    	jne    80460f <inet_ntoa+0x34>
    while(i--)
  8046a3:	eb 1a                	jmp    8046bf <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8046a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046ad:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8046b1:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8046b5:	48 63 d2             	movslq %edx,%rdx
  8046b8:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8046bd:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8046bf:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8046c3:	8d 50 ff             	lea    -0x1(%rax),%edx
  8046c6:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8046c9:	84 c0                	test   %al,%al
  8046cb:	75 d8                	jne    8046a5 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8046cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046d5:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8046d9:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8046dc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8046e1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8046e5:	83 c0 01             	add    $0x1,%eax
  8046e8:	88 45 ef             	mov    %al,-0x11(%rbp)
  8046eb:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  8046ef:	0f 86 16 ff ff ff    	jbe    80460b <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8046f5:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8046fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046fe:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804701:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804708:	00 00 00 
}
  80470b:	c9                   	leaveq 
  80470c:	c3                   	retq   

000000000080470d <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80470d:	55                   	push   %rbp
  80470e:	48 89 e5             	mov    %rsp,%rbp
  804711:	48 83 ec 08          	sub    $0x8,%rsp
  804715:	89 f8                	mov    %edi,%eax
  804717:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80471b:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80471f:	c1 e0 08             	shl    $0x8,%eax
  804722:	89 c2                	mov    %eax,%edx
  804724:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804728:	66 c1 e8 08          	shr    $0x8,%ax
  80472c:	09 d0                	or     %edx,%eax
}
  80472e:	c9                   	leaveq 
  80472f:	c3                   	retq   

0000000000804730 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804730:	55                   	push   %rbp
  804731:	48 89 e5             	mov    %rsp,%rbp
  804734:	48 83 ec 08          	sub    $0x8,%rsp
  804738:	89 f8                	mov    %edi,%eax
  80473a:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  80473e:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804742:	89 c7                	mov    %eax,%edi
  804744:	48 b8 0d 47 80 00 00 	movabs $0x80470d,%rax
  80474b:	00 00 00 
  80474e:	ff d0                	callq  *%rax
}
  804750:	c9                   	leaveq 
  804751:	c3                   	retq   

0000000000804752 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804752:	55                   	push   %rbp
  804753:	48 89 e5             	mov    %rsp,%rbp
  804756:	48 83 ec 08          	sub    $0x8,%rsp
  80475a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80475d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804760:	c1 e0 18             	shl    $0x18,%eax
  804763:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804765:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804768:	25 00 ff 00 00       	and    $0xff00,%eax
  80476d:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804770:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804772:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804775:	25 00 00 ff 00       	and    $0xff0000,%eax
  80477a:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80477e:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804783:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804786:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  804788:	c9                   	leaveq 
  804789:	c3                   	retq   

000000000080478a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80478a:	55                   	push   %rbp
  80478b:	48 89 e5             	mov    %rsp,%rbp
  80478e:	48 83 ec 08          	sub    $0x8,%rsp
  804792:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804798:	89 c7                	mov    %eax,%edi
  80479a:	48 b8 52 47 80 00 00 	movabs $0x804752,%rax
  8047a1:	00 00 00 
  8047a4:	ff d0                	callq  *%rax
}
  8047a6:	c9                   	leaveq 
  8047a7:	c3                   	retq   
