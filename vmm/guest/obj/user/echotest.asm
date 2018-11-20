
vmm/guest/obj/user/echotest:     file format elf64-x86-64


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
  800056:	48 bf 4e 48 80 00 00 	movabs $0x80484e,%rdi
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
  800096:	48 bf 52 48 80 00 00 	movabs $0x804852,%rdi
  80009d:	00 00 00 
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  8000ac:	00 00 00 
  8000af:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b1:	48 bf 62 48 80 00 00 	movabs $0x804862,%rdi
  8000b8:	00 00 00 
  8000bb:	48 b8 38 43 80 00 00 	movabs $0x804338,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	48 be 62 48 80 00 00 	movabs $0x804862,%rsi
  8000d0:	00 00 00 
  8000d3:	48 bf 6c 48 80 00 00 	movabs $0x80486c,%rdi
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
  8000fd:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  800104:	00 00 00 
  800107:	ff d0                	callq  *%rax
  800109:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800110:	79 16                	jns    800128 <umain+0xa8>
		die("Failed to create socket");
  800112:	48 bf 81 48 80 00 00 	movabs $0x804881,%rdi
  800119:	00 00 00 
  80011c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800128:	48 bf 99 48 80 00 00 	movabs $0x804899,%rdi
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
  800164:	48 bf 62 48 80 00 00 	movabs $0x804862,%rdi
  80016b:	00 00 00 
  80016e:	48 b8 38 43 80 00 00 	movabs $0x804338,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
  80017a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017d:	bf 10 27 00 00       	mov    $0x2710,%edi
  800182:	48 b8 88 47 80 00 00 	movabs $0x804788,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
  80018e:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800192:	48 bf a8 48 80 00 00 	movabs $0x8048a8,%rdi
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
  8001be:	48 b8 19 30 80 00 00 	movabs $0x803019,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	79 16                	jns    8001e4 <umain+0x164>
		die("Failed to connect with server");
  8001ce:	48 bf c5 48 80 00 00 	movabs $0x8048c5,%rdi
  8001d5:	00 00 00 
  8001d8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e4:	48 bf e3 48 80 00 00 	movabs $0x8048e3,%rdi
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
  800236:	48 b8 12 24 80 00 00 	movabs $0x802412,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
  800242:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800245:	74 16                	je     80025d <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800247:	48 bf f8 48 80 00 00 	movabs $0x8048f8,%rdi
  80024e:	00 00 00 
  800251:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025d:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
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
  800292:	48 b8 c7 22 80 00 00 	movabs $0x8022c7,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
  80029e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a5:	7f 16                	jg     8002bd <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a7:	48 bf 28 49 80 00 00 	movabs $0x804928,%rdi
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
  8002ed:	48 bf 4c 49 80 00 00 	movabs $0x80494c,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  800303:	00 00 00 
  800306:	ff d2                	callq  *%rdx

	close(sock);
  800308:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030b:	89 c7                	mov    %eax,%edi
  80030d:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
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
  8003a4:	48 b8 ef 20 80 00 00 	movabs $0x8020ef,%rax
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
  800657:	48 b8 50 4b 80 00 00 	movabs $0x804b50,%rax
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
  800939:	48 b8 78 4b 80 00 00 	movabs $0x804b78,%rax
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
  800a80:	48 b8 a0 4a 80 00 00 	movabs $0x804aa0,%rax
  800a87:	00 00 00 
  800a8a:	48 63 d3             	movslq %ebx,%rdx
  800a8d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a91:	4d 85 e4             	test   %r12,%r12
  800a94:	75 2e                	jne    800ac4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9e:	89 d9                	mov    %ebx,%ecx
  800aa0:	48 ba 61 4b 80 00 00 	movabs $0x804b61,%rdx
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
  800acf:	48 ba 6a 4b 80 00 00 	movabs $0x804b6a,%rdx
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
  800b26:	49 bc 6d 4b 80 00 00 	movabs $0x804b6d,%r12
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
  801832:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  801839:	00 00 00 
  80183c:	be 24 00 00 00       	mov    $0x24,%esi
  801841:	48 bf 45 4e 80 00 00 	movabs $0x804e45,%rdi
  801848:	00 00 00 
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	49 b9 5a 3e 80 00 00 	movabs $0x803e5a,%r9
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

0000000000801dac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dac:	55                   	push   %rbp
  801dad:	48 89 e5             	mov    %rsp,%rbp
  801db0:	48 83 ec 08          	sub    $0x8,%rsp
  801db4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801db8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dbc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dc3:	ff ff ff 
  801dc6:	48 01 d0             	add    %rdx,%rax
  801dc9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dcd:	c9                   	leaveq 
  801dce:	c3                   	retq   

0000000000801dcf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dcf:	55                   	push   %rbp
  801dd0:	48 89 e5             	mov    %rsp,%rbp
  801dd3:	48 83 ec 08          	sub    $0x8,%rsp
  801dd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ddb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddf:	48 89 c7             	mov    %rax,%rdi
  801de2:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	callq  *%rax
  801dee:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801df4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801df8:	c9                   	leaveq 
  801df9:	c3                   	retq   

0000000000801dfa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	48 83 ec 18          	sub    $0x18,%rsp
  801e02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e0d:	eb 6b                	jmp    801e7a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e12:	48 98                	cltq   
  801e14:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e1a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e1e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e26:	48 c1 e8 15          	shr    $0x15,%rax
  801e2a:	48 89 c2             	mov    %rax,%rdx
  801e2d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e34:	01 00 00 
  801e37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3b:	83 e0 01             	and    $0x1,%eax
  801e3e:	48 85 c0             	test   %rax,%rax
  801e41:	74 21                	je     801e64 <fd_alloc+0x6a>
  801e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e47:	48 c1 e8 0c          	shr    $0xc,%rax
  801e4b:	48 89 c2             	mov    %rax,%rdx
  801e4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e55:	01 00 00 
  801e58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5c:	83 e0 01             	and    $0x1,%eax
  801e5f:	48 85 c0             	test   %rax,%rax
  801e62:	75 12                	jne    801e76 <fd_alloc+0x7c>
			*fd_store = fd;
  801e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e74:	eb 1a                	jmp    801e90 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e7a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e7e:	7e 8f                	jle    801e0f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e8b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e90:	c9                   	leaveq 
  801e91:	c3                   	retq   

0000000000801e92 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e92:	55                   	push   %rbp
  801e93:	48 89 e5             	mov    %rsp,%rbp
  801e96:	48 83 ec 20          	sub    $0x20,%rsp
  801e9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ea1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ea5:	78 06                	js     801ead <fd_lookup+0x1b>
  801ea7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801eab:	7e 07                	jle    801eb4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ead:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb2:	eb 6c                	jmp    801f20 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801eb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eb7:	48 98                	cltq   
  801eb9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ebf:	48 c1 e0 0c          	shl    $0xc,%rax
  801ec3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ec7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecb:	48 c1 e8 15          	shr    $0x15,%rax
  801ecf:	48 89 c2             	mov    %rax,%rdx
  801ed2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ed9:	01 00 00 
  801edc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee0:	83 e0 01             	and    $0x1,%eax
  801ee3:	48 85 c0             	test   %rax,%rax
  801ee6:	74 21                	je     801f09 <fd_lookup+0x77>
  801ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eec:	48 c1 e8 0c          	shr    $0xc,%rax
  801ef0:	48 89 c2             	mov    %rax,%rdx
  801ef3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801efa:	01 00 00 
  801efd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f01:	83 e0 01             	and    $0x1,%eax
  801f04:	48 85 c0             	test   %rax,%rax
  801f07:	75 07                	jne    801f10 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f0e:	eb 10                	jmp    801f20 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f18:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leaveq 
  801f21:	c3                   	retq   

0000000000801f22 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f22:	55                   	push   %rbp
  801f23:	48 89 e5             	mov    %rsp,%rbp
  801f26:	48 83 ec 30          	sub    $0x30,%rsp
  801f2a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f2e:	89 f0                	mov    %esi,%eax
  801f30:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f37:	48 89 c7             	mov    %rax,%rdi
  801f3a:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	callq  *%rax
  801f46:	89 c2                	mov    %eax,%edx
  801f48:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f4c:	48 89 c6             	mov    %rax,%rsi
  801f4f:	89 d7                	mov    %edx,%edi
  801f51:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	callq  *%rax
  801f5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f64:	78 0a                	js     801f70 <fd_close+0x4e>
	    || fd != fd2)
  801f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f6e:	74 12                	je     801f82 <fd_close+0x60>
		return (must_exist ? r : 0);
  801f70:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f74:	74 05                	je     801f7b <fd_close+0x59>
  801f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f79:	eb 70                	jmp    801feb <fd_close+0xc9>
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	eb 69                	jmp    801feb <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f86:	8b 00                	mov    (%rax),%eax
  801f88:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f8c:	48 89 d6             	mov    %rdx,%rsi
  801f8f:	89 c7                	mov    %eax,%edi
  801f91:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  801f98:	00 00 00 
  801f9b:	ff d0                	callq  *%rax
  801f9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa4:	78 2a                	js     801fd0 <fd_close+0xae>
		if (dev->dev_close)
  801fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801faa:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fae:	48 85 c0             	test   %rax,%rax
  801fb1:	74 16                	je     801fc9 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fbb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fbf:	48 89 d7             	mov    %rdx,%rdi
  801fc2:	ff d0                	callq  *%rax
  801fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc7:	eb 07                	jmp    801fd0 <fd_close+0xae>
		else
			r = 0;
  801fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd4:	48 89 c6             	mov    %rax,%rsi
  801fd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fdc:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801fe3:	00 00 00 
  801fe6:	ff d0                	callq  *%rax
	return r;
  801fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801feb:	c9                   	leaveq 
  801fec:	c3                   	retq   

0000000000801fed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fed:	55                   	push   %rbp
  801fee:	48 89 e5             	mov    %rsp,%rbp
  801ff1:	48 83 ec 20          	sub    $0x20,%rsp
  801ff5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ff8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802003:	eb 41                	jmp    802046 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802005:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80200c:	00 00 00 
  80200f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802012:	48 63 d2             	movslq %edx,%rdx
  802015:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802019:	8b 00                	mov    (%rax),%eax
  80201b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80201e:	75 22                	jne    802042 <dev_lookup+0x55>
			*dev = devtab[i];
  802020:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802027:	00 00 00 
  80202a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202d:	48 63 d2             	movslq %edx,%rdx
  802030:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802034:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802038:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	eb 60                	jmp    8020a2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802042:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802046:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80204d:	00 00 00 
  802050:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802053:	48 63 d2             	movslq %edx,%rdx
  802056:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205a:	48 85 c0             	test   %rax,%rax
  80205d:	75 a6                	jne    802005 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80205f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802066:	00 00 00 
  802069:	48 8b 00             	mov    (%rax),%rax
  80206c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802072:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802075:	89 c6                	mov    %eax,%esi
  802077:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
  80207e:	00 00 00 
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  80208d:	00 00 00 
  802090:	ff d1                	callq  *%rcx
	*dev = 0;
  802092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802096:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80209d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020a2:	c9                   	leaveq 
  8020a3:	c3                   	retq   

00000000008020a4 <close>:

int
close(int fdnum)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	48 83 ec 20          	sub    $0x20,%rsp
  8020ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020b6:	48 89 d6             	mov    %rdx,%rsi
  8020b9:	89 c7                	mov    %eax,%edi
  8020bb:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax
  8020c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ce:	79 05                	jns    8020d5 <close+0x31>
		return r;
  8020d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d3:	eb 18                	jmp    8020ed <close+0x49>
	else
		return fd_close(fd, 1);
  8020d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d9:	be 01 00 00 00       	mov    $0x1,%esi
  8020de:	48 89 c7             	mov    %rax,%rdi
  8020e1:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax
}
  8020ed:	c9                   	leaveq 
  8020ee:	c3                   	retq   

00000000008020ef <close_all>:

void
close_all(void)
{
  8020ef:	55                   	push   %rbp
  8020f0:	48 89 e5             	mov    %rsp,%rbp
  8020f3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020fe:	eb 15                	jmp    802115 <close_all+0x26>
		close(i);
  802100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802103:	89 c7                	mov    %eax,%edi
  802105:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802111:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802115:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802119:	7e e5                	jle    802100 <close_all+0x11>
		close(i);
}
  80211b:	90                   	nop
  80211c:	c9                   	leaveq 
  80211d:	c3                   	retq   

000000000080211e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
  802122:	48 83 ec 40          	sub    $0x40,%rsp
  802126:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802129:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80212c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802130:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802133:	48 89 d6             	mov    %rdx,%rsi
  802136:	89 c7                	mov    %eax,%edi
  802138:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
  802144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214b:	79 08                	jns    802155 <dup+0x37>
		return r;
  80214d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802150:	e9 70 01 00 00       	jmpq   8022c5 <dup+0x1a7>
	close(newfdnum);
  802155:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802158:	89 c7                	mov    %eax,%edi
  80215a:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802161:	00 00 00 
  802164:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802166:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802169:	48 98                	cltq   
  80216b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802171:	48 c1 e0 0c          	shl    $0xc,%rax
  802175:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802179:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217d:	48 89 c7             	mov    %rax,%rdi
  802180:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  802187:	00 00 00 
  80218a:	ff d0                	callq  *%rax
  80218c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802194:	48 89 c7             	mov    %rax,%rdi
  802197:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
  8021a3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ab:	48 c1 e8 15          	shr    $0x15,%rax
  8021af:	48 89 c2             	mov    %rax,%rdx
  8021b2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021b9:	01 00 00 
  8021bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c0:	83 e0 01             	and    $0x1,%eax
  8021c3:	48 85 c0             	test   %rax,%rax
  8021c6:	74 71                	je     802239 <dup+0x11b>
  8021c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d0:	48 89 c2             	mov    %rax,%rdx
  8021d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021da:	01 00 00 
  8021dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e1:	83 e0 01             	and    $0x1,%eax
  8021e4:	48 85 c0             	test   %rax,%rax
  8021e7:	74 50                	je     802239 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f1:	48 89 c2             	mov    %rax,%rdx
  8021f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fb:	01 00 00 
  8021fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802202:	25 07 0e 00 00       	and    $0xe07,%eax
  802207:	89 c1                	mov    %eax,%ecx
  802209:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80220d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802211:	41 89 c8             	mov    %ecx,%r8d
  802214:	48 89 d1             	mov    %rdx,%rcx
  802217:	ba 00 00 00 00       	mov    $0x0,%edx
  80221c:	48 89 c6             	mov    %rax,%rsi
  80221f:	bf 00 00 00 00       	mov    $0x0,%edi
  802224:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80222b:	00 00 00 
  80222e:	ff d0                	callq  *%rax
  802230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802233:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802237:	78 55                	js     80228e <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80223d:	48 c1 e8 0c          	shr    $0xc,%rax
  802241:	48 89 c2             	mov    %rax,%rdx
  802244:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224b:	01 00 00 
  80224e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802252:	25 07 0e 00 00       	and    $0xe07,%eax
  802257:	89 c1                	mov    %eax,%ecx
  802259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802261:	41 89 c8             	mov    %ecx,%r8d
  802264:	48 89 d1             	mov    %rdx,%rcx
  802267:	ba 00 00 00 00       	mov    $0x0,%edx
  80226c:	48 89 c6             	mov    %rax,%rsi
  80226f:	bf 00 00 00 00       	mov    $0x0,%edi
  802274:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80227b:	00 00 00 
  80227e:	ff d0                	callq  *%rax
  802280:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802287:	78 08                	js     802291 <dup+0x173>
		goto err;

	return newfdnum;
  802289:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80228c:	eb 37                	jmp    8022c5 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80228e:	90                   	nop
  80228f:	eb 01                	jmp    802292 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802291:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802296:	48 89 c6             	mov    %rax,%rsi
  802299:	bf 00 00 00 00       	mov    $0x0,%edi
  80229e:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ae:	48 89 c6             	mov    %rax,%rsi
  8022b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b6:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	callq  *%rax
	return r;
  8022c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022c5:	c9                   	leaveq 
  8022c6:	c3                   	retq   

00000000008022c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022c7:	55                   	push   %rbp
  8022c8:	48 89 e5             	mov    %rsp,%rbp
  8022cb:	48 83 ec 40          	sub    $0x40,%rsp
  8022cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022e1:	48 89 d6             	mov    %rdx,%rsi
  8022e4:	89 c7                	mov    %eax,%edi
  8022e6:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
  8022f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f9:	78 24                	js     80231f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ff:	8b 00                	mov    (%rax),%eax
  802301:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802305:	48 89 d6             	mov    %rdx,%rsi
  802308:	89 c7                	mov    %eax,%edi
  80230a:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  802311:	00 00 00 
  802314:	ff d0                	callq  *%rax
  802316:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802319:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231d:	79 05                	jns    802324 <read+0x5d>
		return r;
  80231f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802322:	eb 76                	jmp    80239a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802328:	8b 40 08             	mov    0x8(%rax),%eax
  80232b:	83 e0 03             	and    $0x3,%eax
  80232e:	83 f8 01             	cmp    $0x1,%eax
  802331:	75 3a                	jne    80236d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802333:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80233a:	00 00 00 
  80233d:	48 8b 00             	mov    (%rax),%rax
  802340:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802346:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802349:	89 c6                	mov    %eax,%esi
  80234b:	48 bf 77 4e 80 00 00 	movabs $0x804e77,%rdi
  802352:	00 00 00 
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
  80235a:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  802361:	00 00 00 
  802364:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802366:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236b:	eb 2d                	jmp    80239a <read+0xd3>
	}
	if (!dev->dev_read)
  80236d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802371:	48 8b 40 10          	mov    0x10(%rax),%rax
  802375:	48 85 c0             	test   %rax,%rax
  802378:	75 07                	jne    802381 <read+0xba>
		return -E_NOT_SUPP;
  80237a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80237f:	eb 19                	jmp    80239a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802385:	48 8b 40 10          	mov    0x10(%rax),%rax
  802389:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80238d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802391:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802395:	48 89 cf             	mov    %rcx,%rdi
  802398:	ff d0                	callq  *%rax
}
  80239a:	c9                   	leaveq 
  80239b:	c3                   	retq   

000000000080239c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80239c:	55                   	push   %rbp
  80239d:	48 89 e5             	mov    %rsp,%rbp
  8023a0:	48 83 ec 30          	sub    $0x30,%rsp
  8023a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023b6:	eb 47                	jmp    8023ff <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bb:	48 98                	cltq   
  8023bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023c1:	48 29 c2             	sub    %rax,%rdx
  8023c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c7:	48 63 c8             	movslq %eax,%rcx
  8023ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ce:	48 01 c1             	add    %rax,%rcx
  8023d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d4:	48 89 ce             	mov    %rcx,%rsi
  8023d7:	89 c7                	mov    %eax,%edi
  8023d9:	48 b8 c7 22 80 00 00 	movabs $0x8022c7,%rax
  8023e0:	00 00 00 
  8023e3:	ff d0                	callq  *%rax
  8023e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023ec:	79 05                	jns    8023f3 <readn+0x57>
			return m;
  8023ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023f1:	eb 1d                	jmp    802410 <readn+0x74>
		if (m == 0)
  8023f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023f7:	74 13                	je     80240c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802402:	48 98                	cltq   
  802404:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802408:	72 ae                	jb     8023b8 <readn+0x1c>
  80240a:	eb 01                	jmp    80240d <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80240c:	90                   	nop
	}
	return tot;
  80240d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802410:	c9                   	leaveq 
  802411:	c3                   	retq   

0000000000802412 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802412:	55                   	push   %rbp
  802413:	48 89 e5             	mov    %rsp,%rbp
  802416:	48 83 ec 40          	sub    $0x40,%rsp
  80241a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80241d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802421:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802425:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802429:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80242c:	48 89 d6             	mov    %rdx,%rsi
  80242f:	89 c7                	mov    %eax,%edi
  802431:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
  80243d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802440:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802444:	78 24                	js     80246a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244a:	8b 00                	mov    (%rax),%eax
  80244c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802450:	48 89 d6             	mov    %rdx,%rsi
  802453:	89 c7                	mov    %eax,%edi
  802455:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	callq  *%rax
  802461:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802464:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802468:	79 05                	jns    80246f <write+0x5d>
		return r;
  80246a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246d:	eb 75                	jmp    8024e4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80246f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802473:	8b 40 08             	mov    0x8(%rax),%eax
  802476:	83 e0 03             	and    $0x3,%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 3a                	jne    8024b7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80247d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802484:	00 00 00 
  802487:	48 8b 00             	mov    (%rax),%rax
  80248a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802490:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802493:	89 c6                	mov    %eax,%esi
  802495:	48 bf 93 4e 80 00 00 	movabs $0x804e93,%rdi
  80249c:	00 00 00 
  80249f:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a4:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  8024ab:	00 00 00 
  8024ae:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b5:	eb 2d                	jmp    8024e4 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024bf:	48 85 c0             	test   %rax,%rax
  8024c2:	75 07                	jne    8024cb <write+0xb9>
		return -E_NOT_SUPP;
  8024c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024c9:	eb 19                	jmp    8024e4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024df:	48 89 cf             	mov    %rcx,%rdi
  8024e2:	ff d0                	callq  *%rax
}
  8024e4:	c9                   	leaveq 
  8024e5:	c3                   	retq   

00000000008024e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024e6:	55                   	push   %rbp
  8024e7:	48 89 e5             	mov    %rsp,%rbp
  8024ea:	48 83 ec 18          	sub    $0x18,%rsp
  8024ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024f1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024fb:	48 89 d6             	mov    %rdx,%rsi
  8024fe:	89 c7                	mov    %eax,%edi
  802500:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802507:	00 00 00 
  80250a:	ff d0                	callq  *%rax
  80250c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802513:	79 05                	jns    80251a <seek+0x34>
		return r;
  802515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802518:	eb 0f                	jmp    802529 <seek+0x43>
	fd->fd_offset = offset;
  80251a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802521:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802529:	c9                   	leaveq 
  80252a:	c3                   	retq   

000000000080252b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80252b:	55                   	push   %rbp
  80252c:	48 89 e5             	mov    %rsp,%rbp
  80252f:	48 83 ec 30          	sub    $0x30,%rsp
  802533:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802536:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802539:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80253d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802540:	48 89 d6             	mov    %rdx,%rsi
  802543:	89 c7                	mov    %eax,%edi
  802545:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  80254c:	00 00 00 
  80254f:	ff d0                	callq  *%rax
  802551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802558:	78 24                	js     80257e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80255a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255e:	8b 00                	mov    (%rax),%eax
  802560:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802564:	48 89 d6             	mov    %rdx,%rsi
  802567:	89 c7                	mov    %eax,%edi
  802569:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
  802575:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802578:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257c:	79 05                	jns    802583 <ftruncate+0x58>
		return r;
  80257e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802581:	eb 72                	jmp    8025f5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802587:	8b 40 08             	mov    0x8(%rax),%eax
  80258a:	83 e0 03             	and    $0x3,%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	75 3a                	jne    8025cb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802591:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802598:	00 00 00 
  80259b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80259e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025a7:	89 c6                	mov    %eax,%esi
  8025a9:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  8025b0:	00 00 00 
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	48 b9 ea 04 80 00 00 	movabs $0x8004ea,%rcx
  8025bf:	00 00 00 
  8025c2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c9:	eb 2a                	jmp    8025f5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025d3:	48 85 c0             	test   %rax,%rax
  8025d6:	75 07                	jne    8025df <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025dd:	eb 16                	jmp    8025f5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025eb:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025ee:	89 ce                	mov    %ecx,%esi
  8025f0:	48 89 d7             	mov    %rdx,%rdi
  8025f3:	ff d0                	callq  *%rax
}
  8025f5:	c9                   	leaveq 
  8025f6:	c3                   	retq   

00000000008025f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025f7:	55                   	push   %rbp
  8025f8:	48 89 e5             	mov    %rsp,%rbp
  8025fb:	48 83 ec 30          	sub    $0x30,%rsp
  8025ff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802602:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802606:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80260a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260d:	48 89 d6             	mov    %rdx,%rsi
  802610:	89 c7                	mov    %eax,%edi
  802612:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802625:	78 24                	js     80264b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262b:	8b 00                	mov    (%rax),%eax
  80262d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802631:	48 89 d6             	mov    %rdx,%rsi
  802634:	89 c7                	mov    %eax,%edi
  802636:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax
  802642:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802645:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802649:	79 05                	jns    802650 <fstat+0x59>
		return r;
  80264b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264e:	eb 5e                	jmp    8026ae <fstat+0xb7>
	if (!dev->dev_stat)
  802650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802654:	48 8b 40 28          	mov    0x28(%rax),%rax
  802658:	48 85 c0             	test   %rax,%rax
  80265b:	75 07                	jne    802664 <fstat+0x6d>
		return -E_NOT_SUPP;
  80265d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802662:	eb 4a                	jmp    8026ae <fstat+0xb7>
	stat->st_name[0] = 0;
  802664:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802668:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80266b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80266f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802676:	00 00 00 
	stat->st_isdir = 0;
  802679:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802684:	00 00 00 
	stat->st_dev = dev;
  802687:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80268b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80269e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026a2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026a6:	48 89 ce             	mov    %rcx,%rsi
  8026a9:	48 89 d7             	mov    %rdx,%rdi
  8026ac:	ff d0                	callq  *%rax
}
  8026ae:	c9                   	leaveq 
  8026af:	c3                   	retq   

00000000008026b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026b0:	55                   	push   %rbp
  8026b1:	48 89 e5             	mov    %rsp,%rbp
  8026b4:	48 83 ec 20          	sub    $0x20,%rsp
  8026b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c4:	be 00 00 00 00       	mov    $0x0,%esi
  8026c9:	48 89 c7             	mov    %rax,%rdi
  8026cc:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	callq  *%rax
  8026d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026df:	79 05                	jns    8026e6 <stat+0x36>
		return fd;
  8026e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e4:	eb 2f                	jmp    802715 <stat+0x65>
	r = fstat(fd, stat);
  8026e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ed:	48 89 d6             	mov    %rdx,%rsi
  8026f0:	89 c7                	mov    %eax,%edi
  8026f2:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
  8026fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802704:	89 c7                	mov    %eax,%edi
  802706:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
	return r;
  802712:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802715:	c9                   	leaveq 
  802716:	c3                   	retq   

0000000000802717 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802717:	55                   	push   %rbp
  802718:	48 89 e5             	mov    %rsp,%rbp
  80271b:	48 83 ec 10          	sub    $0x10,%rsp
  80271f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802722:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802726:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80272d:	00 00 00 
  802730:	8b 00                	mov    (%rax),%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	75 1f                	jne    802755 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802736:	bf 01 00 00 00       	mov    $0x1,%edi
  80273b:	48 b8 3b 42 80 00 00 	movabs $0x80423b,%rax
  802742:	00 00 00 
  802745:	ff d0                	callq  *%rax
  802747:	89 c2                	mov    %eax,%edx
  802749:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802750:	00 00 00 
  802753:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802755:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80275c:	00 00 00 
  80275f:	8b 00                	mov    (%rax),%eax
  802761:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802764:	b9 07 00 00 00       	mov    $0x7,%ecx
  802769:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802770:	00 00 00 
  802773:	89 c7                	mov    %eax,%edi
  802775:	48 b8 2f 40 80 00 00 	movabs $0x80402f,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802781:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802785:	ba 00 00 00 00       	mov    $0x0,%edx
  80278a:	48 89 c6             	mov    %rax,%rsi
  80278d:	bf 00 00 00 00       	mov    $0x0,%edi
  802792:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  802799:	00 00 00 
  80279c:	ff d0                	callq  *%rax
}
  80279e:	c9                   	leaveq 
  80279f:	c3                   	retq   

00000000008027a0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027a0:	55                   	push   %rbp
  8027a1:	48 89 e5             	mov    %rsp,%rbp
  8027a4:	48 83 ec 20          	sub    $0x20,%rsp
  8027a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b3:	48 89 c7             	mov    %rax,%rdi
  8027b6:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
  8027c2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027c7:	7e 0a                	jle    8027d3 <open+0x33>
		return -E_BAD_PATH;
  8027c9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027ce:	e9 a5 00 00 00       	jmpq   802878 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8027d3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027d7:	48 89 c7             	mov    %rax,%rdi
  8027da:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
  8027e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ed:	79 08                	jns    8027f7 <open+0x57>
		return r;
  8027ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f2:	e9 81 00 00 00       	jmpq   802878 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8027f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fb:	48 89 c6             	mov    %rax,%rsi
  8027fe:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802805:	00 00 00 
  802808:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802814:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80281b:	00 00 00 
  80281e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802821:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282b:	48 89 c6             	mov    %rax,%rsi
  80282e:	bf 01 00 00 00       	mov    $0x1,%edi
  802833:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	callq  *%rax
  80283f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802842:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802846:	79 1d                	jns    802865 <open+0xc5>
		fd_close(fd, 0);
  802848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284c:	be 00 00 00 00       	mov    $0x0,%esi
  802851:	48 89 c7             	mov    %rax,%rdi
  802854:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
		return r;
  802860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802863:	eb 13                	jmp    802878 <open+0xd8>
	}

	return fd2num(fd);
  802865:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802869:	48 89 c7             	mov    %rax,%rdi
  80286c:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  802873:	00 00 00 
  802876:	ff d0                	callq  *%rax

}
  802878:	c9                   	leaveq 
  802879:	c3                   	retq   

000000000080287a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80287a:	55                   	push   %rbp
  80287b:	48 89 e5             	mov    %rsp,%rbp
  80287e:	48 83 ec 10          	sub    $0x10,%rsp
  802882:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80288a:	8b 50 0c             	mov    0xc(%rax),%edx
  80288d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802894:	00 00 00 
  802897:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802899:	be 00 00 00 00       	mov    $0x0,%esi
  80289e:	bf 06 00 00 00       	mov    $0x6,%edi
  8028a3:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
}
  8028af:	c9                   	leaveq 
  8028b0:	c3                   	retq   

00000000008028b1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028b1:	55                   	push   %rbp
  8028b2:	48 89 e5             	mov    %rsp,%rbp
  8028b5:	48 83 ec 30          	sub    $0x30,%rsp
  8028b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028cc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028d3:	00 00 00 
  8028d6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028d8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028df:	00 00 00 
  8028e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028ea:	be 00 00 00 00       	mov    $0x0,%esi
  8028ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8028f4:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  8028fb:	00 00 00 
  8028fe:	ff d0                	callq  *%rax
  802900:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802907:	79 08                	jns    802911 <devfile_read+0x60>
		return r;
  802909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290c:	e9 a4 00 00 00       	jmpq   8029b5 <devfile_read+0x104>
	assert(r <= n);
  802911:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802914:	48 98                	cltq   
  802916:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80291a:	76 35                	jbe    802951 <devfile_read+0xa0>
  80291c:	48 b9 d6 4e 80 00 00 	movabs $0x804ed6,%rcx
  802923:	00 00 00 
  802926:	48 ba dd 4e 80 00 00 	movabs $0x804edd,%rdx
  80292d:	00 00 00 
  802930:	be 86 00 00 00       	mov    $0x86,%esi
  802935:	48 bf f2 4e 80 00 00 	movabs $0x804ef2,%rdi
  80293c:	00 00 00 
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  80294b:	00 00 00 
  80294e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802951:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802958:	7e 35                	jle    80298f <devfile_read+0xde>
  80295a:	48 b9 fd 4e 80 00 00 	movabs $0x804efd,%rcx
  802961:	00 00 00 
  802964:	48 ba dd 4e 80 00 00 	movabs $0x804edd,%rdx
  80296b:	00 00 00 
  80296e:	be 87 00 00 00       	mov    $0x87,%esi
  802973:	48 bf f2 4e 80 00 00 	movabs $0x804ef2,%rdi
  80297a:	00 00 00 
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
  802982:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  802989:	00 00 00 
  80298c:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80298f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802992:	48 63 d0             	movslq %eax,%rdx
  802995:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802999:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029a0:	00 00 00 
  8029a3:	48 89 c7             	mov    %rax,%rdi
  8029a6:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	callq  *%rax
	return r;
  8029b2:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   

00000000008029b7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 40          	sub    $0x40,%rsp
  8029bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8029cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029d3:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8029da:	00 
  8029db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029df:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8029e3:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8029e8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029fa:	00 00 00 
  8029fd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8029ff:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a06:	00 00 00 
  802a09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a0d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a19:	48 89 c6             	mov    %rax,%rsi
  802a1c:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802a23:	00 00 00 
  802a26:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  802a2d:	00 00 00 
  802a30:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a32:	be 00 00 00 00       	mov    $0x0,%esi
  802a37:	bf 04 00 00 00       	mov    $0x4,%edi
  802a3c:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a4f:	79 05                	jns    802a56 <devfile_write+0x9f>
		return r;
  802a51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a54:	eb 43                	jmp    802a99 <devfile_write+0xe2>
	assert(r <= n);
  802a56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a59:	48 98                	cltq   
  802a5b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a5f:	76 35                	jbe    802a96 <devfile_write+0xdf>
  802a61:	48 b9 d6 4e 80 00 00 	movabs $0x804ed6,%rcx
  802a68:	00 00 00 
  802a6b:	48 ba dd 4e 80 00 00 	movabs $0x804edd,%rdx
  802a72:	00 00 00 
  802a75:	be a2 00 00 00       	mov    $0xa2,%esi
  802a7a:	48 bf f2 4e 80 00 00 	movabs $0x804ef2,%rdi
  802a81:	00 00 00 
  802a84:	b8 00 00 00 00       	mov    $0x0,%eax
  802a89:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  802a90:	00 00 00 
  802a93:	41 ff d0             	callq  *%r8
	return r;
  802a96:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802a99:	c9                   	leaveq 
  802a9a:	c3                   	retq   

0000000000802a9b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a9b:	55                   	push   %rbp
  802a9c:	48 89 e5             	mov    %rsp,%rbp
  802a9f:	48 83 ec 20          	sub    $0x20,%rsp
  802aa3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aaf:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ab9:	00 00 00 
  802abc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802abe:	be 00 00 00 00       	mov    $0x0,%esi
  802ac3:	bf 05 00 00 00       	mov    $0x5,%edi
  802ac8:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adb:	79 05                	jns    802ae2 <devfile_stat+0x47>
		return r;
  802add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae0:	eb 56                	jmp    802b38 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802aed:	00 00 00 
  802af0:	48 89 c7             	mov    %rax,%rdi
  802af3:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802aff:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b06:	00 00 00 
  802b09:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b13:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b19:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b20:	00 00 00 
  802b23:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b38:	c9                   	leaveq 
  802b39:	c3                   	retq   

0000000000802b3a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b3a:	55                   	push   %rbp
  802b3b:	48 89 e5             	mov    %rsp,%rbp
  802b3e:	48 83 ec 10          	sub    $0x10,%rsp
  802b42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b46:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b4d:	8b 50 0c             	mov    0xc(%rax),%edx
  802b50:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b57:	00 00 00 
  802b5a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b5c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b63:	00 00 00 
  802b66:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b69:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b6c:	be 00 00 00 00       	mov    $0x0,%esi
  802b71:	bf 02 00 00 00       	mov    $0x2,%edi
  802b76:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
}
  802b82:	c9                   	leaveq 
  802b83:	c3                   	retq   

0000000000802b84 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b84:	55                   	push   %rbp
  802b85:	48 89 e5             	mov    %rsp,%rbp
  802b88:	48 83 ec 10          	sub    $0x10,%rsp
  802b8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b94:	48 89 c7             	mov    %rax,%rdi
  802b97:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	callq  *%rax
  802ba3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ba8:	7e 07                	jle    802bb1 <remove+0x2d>
		return -E_BAD_PATH;
  802baa:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802baf:	eb 33                	jmp    802be4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb5:	48 89 c6             	mov    %rax,%rsi
  802bb8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802bbf:	00 00 00 
  802bc2:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bce:	be 00 00 00 00       	mov    $0x0,%esi
  802bd3:	bf 07 00 00 00       	mov    $0x7,%edi
  802bd8:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802bdf:	00 00 00 
  802be2:	ff d0                	callq  *%rax
}
  802be4:	c9                   	leaveq 
  802be5:	c3                   	retq   

0000000000802be6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802be6:	55                   	push   %rbp
  802be7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bea:	be 00 00 00 00       	mov    $0x0,%esi
  802bef:	bf 08 00 00 00       	mov    $0x8,%edi
  802bf4:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802bfb:	00 00 00 
  802bfe:	ff d0                	callq  *%rax
}
  802c00:	5d                   	pop    %rbp
  802c01:	c3                   	retq   

0000000000802c02 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c02:	55                   	push   %rbp
  802c03:	48 89 e5             	mov    %rsp,%rbp
  802c06:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c0d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c14:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c1b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c22:	be 00 00 00 00       	mov    $0x0,%esi
  802c27:	48 89 c7             	mov    %rax,%rdi
  802c2a:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
  802c36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3d:	79 28                	jns    802c67 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c42:	89 c6                	mov    %eax,%esi
  802c44:	48 bf 09 4f 80 00 00 	movabs $0x804f09,%rdi
  802c4b:	00 00 00 
  802c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c53:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802c5a:	00 00 00 
  802c5d:	ff d2                	callq  *%rdx
		return fd_src;
  802c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c62:	e9 76 01 00 00       	jmpq   802ddd <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c67:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c6e:	be 01 01 00 00       	mov    $0x101,%esi
  802c73:	48 89 c7             	mov    %rax,%rdi
  802c76:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c89:	0f 89 ad 00 00 00    	jns    802d3c <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c92:	89 c6                	mov    %eax,%esi
  802c94:	48 bf 1f 4f 80 00 00 	movabs $0x804f1f,%rdi
  802c9b:	00 00 00 
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802caa:	00 00 00 
  802cad:	ff d2                	callq  *%rdx
		close(fd_src);
  802caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb2:	89 c7                	mov    %eax,%edi
  802cb4:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802cbb:	00 00 00 
  802cbe:	ff d0                	callq  *%rax
		return fd_dest;
  802cc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc3:	e9 15 01 00 00       	jmpq   802ddd <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802cc8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ccb:	48 63 d0             	movslq %eax,%rdx
  802cce:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd8:	48 89 ce             	mov    %rcx,%rsi
  802cdb:	89 c7                	mov    %eax,%edi
  802cdd:	48 b8 12 24 80 00 00 	movabs $0x802412,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	callq  *%rax
  802ce9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cf0:	79 4a                	jns    802d3c <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802cf2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cf5:	89 c6                	mov    %eax,%esi
  802cf7:	48 bf 39 4f 80 00 00 	movabs $0x804f39,%rdi
  802cfe:	00 00 00 
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802d0d:	00 00 00 
  802d10:	ff d2                	callq  *%rdx
			close(fd_src);
  802d12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
			close(fd_dest);
  802d23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d26:	89 c7                	mov    %eax,%edi
  802d28:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax
			return write_size;
  802d34:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d37:	e9 a1 00 00 00       	jmpq   802ddd <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d3c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d46:	ba 00 02 00 00       	mov    $0x200,%edx
  802d4b:	48 89 ce             	mov    %rcx,%rsi
  802d4e:	89 c7                	mov    %eax,%edi
  802d50:	48 b8 c7 22 80 00 00 	movabs $0x8022c7,%rax
  802d57:	00 00 00 
  802d5a:	ff d0                	callq  *%rax
  802d5c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d63:	0f 8f 5f ff ff ff    	jg     802cc8 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d6d:	79 47                	jns    802db6 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802d6f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d72:	89 c6                	mov    %eax,%esi
  802d74:	48 bf 4c 4f 80 00 00 	movabs $0x804f4c,%rdi
  802d7b:	00 00 00 
  802d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d83:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  802d8a:	00 00 00 
  802d8d:	ff d2                	callq  *%rdx
		close(fd_src);
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	89 c7                	mov    %eax,%edi
  802d94:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax
		close(fd_dest);
  802da0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da3:	89 c7                	mov    %eax,%edi
  802da5:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
		return read_size;
  802db1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802db4:	eb 27                	jmp    802ddd <copy+0x1db>
	}
	close(fd_src);
  802db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db9:	89 c7                	mov    %eax,%edi
  802dbb:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
	close(fd_dest);
  802dc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dca:	89 c7                	mov    %eax,%edi
  802dcc:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
	return 0;
  802dd8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ddd:	c9                   	leaveq 
  802dde:	c3                   	retq   

0000000000802ddf <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ddf:	55                   	push   %rbp
  802de0:	48 89 e5             	mov    %rsp,%rbp
  802de3:	48 83 ec 20          	sub    $0x20,%rsp
  802de7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802dea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802df1:	48 89 d6             	mov    %rdx,%rsi
  802df4:	89 c7                	mov    %eax,%edi
  802df6:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
  802e02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e09:	79 05                	jns    802e10 <fd2sockid+0x31>
		return r;
  802e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0e:	eb 24                	jmp    802e34 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e14:	8b 10                	mov    (%rax),%edx
  802e16:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  802e1d:	00 00 00 
  802e20:	8b 00                	mov    (%rax),%eax
  802e22:	39 c2                	cmp    %eax,%edx
  802e24:	74 07                	je     802e2d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e26:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e2b:	eb 07                	jmp    802e34 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e31:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e34:	c9                   	leaveq 
  802e35:	c3                   	retq   

0000000000802e36 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e36:	55                   	push   %rbp
  802e37:	48 89 e5             	mov    %rsp,%rbp
  802e3a:	48 83 ec 20          	sub    $0x20,%rsp
  802e3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e41:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e45:	48 89 c7             	mov    %rax,%rdi
  802e48:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
  802e54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5b:	78 26                	js     802e83 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e61:	ba 07 04 00 00       	mov    $0x407,%edx
  802e66:	48 89 c6             	mov    %rax,%rsi
  802e69:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6e:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e81:	79 16                	jns    802e99 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e86:	89 c7                	mov    %eax,%edi
  802e88:	48 b8 45 33 80 00 00 	movabs $0x803345,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
		return r;
  802e94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e97:	eb 3a                	jmp    802ed3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9d:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  802ea4:	00 00 00 
  802ea7:	8b 12                	mov    (%rdx),%edx
  802ea9:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eaf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802eb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ebd:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ec0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec4:	48 89 c7             	mov    %rax,%rdi
  802ec7:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  802ece:	00 00 00 
  802ed1:	ff d0                	callq  *%rax
}
  802ed3:	c9                   	leaveq 
  802ed4:	c3                   	retq   

0000000000802ed5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ed5:	55                   	push   %rbp
  802ed6:	48 89 e5             	mov    %rsp,%rbp
  802ed9:	48 83 ec 30          	sub    $0x30,%rsp
  802edd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ee4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ee8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eeb:	89 c7                	mov    %eax,%edi
  802eed:	48 b8 df 2d 80 00 00 	movabs $0x802ddf,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
  802ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f00:	79 05                	jns    802f07 <accept+0x32>
		return r;
  802f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f05:	eb 3b                	jmp    802f42 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f07:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f0b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f12:	48 89 ce             	mov    %rcx,%rsi
  802f15:	89 c7                	mov    %eax,%edi
  802f17:	48 b8 22 32 80 00 00 	movabs $0x803222,%rax
  802f1e:	00 00 00 
  802f21:	ff d0                	callq  *%rax
  802f23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2a:	79 05                	jns    802f31 <accept+0x5c>
		return r;
  802f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2f:	eb 11                	jmp    802f42 <accept+0x6d>
	return alloc_sockfd(r);
  802f31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f34:	89 c7                	mov    %eax,%edi
  802f36:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
}
  802f42:	c9                   	leaveq 
  802f43:	c3                   	retq   

0000000000802f44 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f44:	55                   	push   %rbp
  802f45:	48 89 e5             	mov    %rsp,%rbp
  802f48:	48 83 ec 20          	sub    $0x20,%rsp
  802f4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f4f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f53:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f59:	89 c7                	mov    %eax,%edi
  802f5b:	48 b8 df 2d 80 00 00 	movabs $0x802ddf,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
  802f67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6e:	79 05                	jns    802f75 <bind+0x31>
		return r;
  802f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f73:	eb 1b                	jmp    802f90 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f75:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f78:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7f:	48 89 ce             	mov    %rcx,%rsi
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
}
  802f90:	c9                   	leaveq 
  802f91:	c3                   	retq   

0000000000802f92 <shutdown>:

int
shutdown(int s, int how)
{
  802f92:	55                   	push   %rbp
  802f93:	48 89 e5             	mov    %rsp,%rbp
  802f96:	48 83 ec 20          	sub    $0x20,%rsp
  802f9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f9d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fa0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa3:	89 c7                	mov    %eax,%edi
  802fa5:	48 b8 df 2d 80 00 00 	movabs $0x802ddf,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
  802fb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb8:	79 05                	jns    802fbf <shutdown+0x2d>
		return r;
  802fba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbd:	eb 16                	jmp    802fd5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fbf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc5:	89 d6                	mov    %edx,%esi
  802fc7:	89 c7                	mov    %eax,%edi
  802fc9:	48 b8 05 33 80 00 00 	movabs $0x803305,%rax
  802fd0:	00 00 00 
  802fd3:	ff d0                	callq  *%rax
}
  802fd5:	c9                   	leaveq 
  802fd6:	c3                   	retq   

0000000000802fd7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802fd7:	55                   	push   %rbp
  802fd8:	48 89 e5             	mov    %rsp,%rbp
  802fdb:	48 83 ec 10          	sub    $0x10,%rsp
  802fdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe7:	48 89 c7             	mov    %rax,%rdi
  802fea:	48 b8 ac 42 80 00 00 	movabs $0x8042ac,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
  802ff6:	83 f8 01             	cmp    $0x1,%eax
  802ff9:	75 17                	jne    803012 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fff:	8b 40 0c             	mov    0xc(%rax),%eax
  803002:	89 c7                	mov    %eax,%edi
  803004:	48 b8 45 33 80 00 00 	movabs $0x803345,%rax
  80300b:	00 00 00 
  80300e:	ff d0                	callq  *%rax
  803010:	eb 05                	jmp    803017 <devsock_close+0x40>
	else
		return 0;
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803017:	c9                   	leaveq 
  803018:	c3                   	retq   

0000000000803019 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803019:	55                   	push   %rbp
  80301a:	48 89 e5             	mov    %rsp,%rbp
  80301d:	48 83 ec 20          	sub    $0x20,%rsp
  803021:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803024:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803028:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80302b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80302e:	89 c7                	mov    %eax,%edi
  803030:	48 b8 df 2d 80 00 00 	movabs $0x802ddf,%rax
  803037:	00 00 00 
  80303a:	ff d0                	callq  *%rax
  80303c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803043:	79 05                	jns    80304a <connect+0x31>
		return r;
  803045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803048:	eb 1b                	jmp    803065 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80304a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80304d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803054:	48 89 ce             	mov    %rcx,%rsi
  803057:	89 c7                	mov    %eax,%edi
  803059:	48 b8 72 33 80 00 00 	movabs $0x803372,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <listen>:

int
listen(int s, int backlog)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 20          	sub    $0x20,%rsp
  80306f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803072:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803075:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803078:	89 c7                	mov    %eax,%edi
  80307a:	48 b8 df 2d 80 00 00 	movabs $0x802ddf,%rax
  803081:	00 00 00 
  803084:	ff d0                	callq  *%rax
  803086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308d:	79 05                	jns    803094 <listen+0x2d>
		return r;
  80308f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803092:	eb 16                	jmp    8030aa <listen+0x43>
	return nsipc_listen(r, backlog);
  803094:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309a:	89 d6                	mov    %edx,%esi
  80309c:	89 c7                	mov    %eax,%edi
  80309e:	48 b8 d6 33 80 00 00 	movabs $0x8033d6,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
}
  8030aa:	c9                   	leaveq 
  8030ab:	c3                   	retq   

00000000008030ac <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030ac:	55                   	push   %rbp
  8030ad:	48 89 e5             	mov    %rsp,%rbp
  8030b0:	48 83 ec 20          	sub    $0x20,%rsp
  8030b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c4:	89 c2                	mov    %eax,%edx
  8030c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ca:	8b 40 0c             	mov    0xc(%rax),%eax
  8030cd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030d6:	89 c7                	mov    %eax,%edi
  8030d8:	48 b8 16 34 80 00 00 	movabs $0x803416,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
}
  8030e4:	c9                   	leaveq 
  8030e5:	c3                   	retq   

00000000008030e6 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8030e6:	55                   	push   %rbp
  8030e7:	48 89 e5             	mov    %rsp,%rbp
  8030ea:	48 83 ec 20          	sub    $0x20,%rsp
  8030ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8030fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030fe:	89 c2                	mov    %eax,%edx
  803100:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803104:	8b 40 0c             	mov    0xc(%rax),%eax
  803107:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80310b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803110:	89 c7                	mov    %eax,%edi
  803112:	48 b8 e2 34 80 00 00 	movabs $0x8034e2,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
}
  80311e:	c9                   	leaveq 
  80311f:	c3                   	retq   

0000000000803120 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803120:	55                   	push   %rbp
  803121:	48 89 e5             	mov    %rsp,%rbp
  803124:	48 83 ec 10          	sub    $0x10,%rsp
  803128:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80312c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803134:	48 be 67 4f 80 00 00 	movabs $0x804f67,%rsi
  80313b:	00 00 00 
  80313e:	48 89 c7             	mov    %rax,%rdi
  803141:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
	return 0;
  80314d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803152:	c9                   	leaveq 
  803153:	c3                   	retq   

0000000000803154 <socket>:

int
socket(int domain, int type, int protocol)
{
  803154:	55                   	push   %rbp
  803155:	48 89 e5             	mov    %rsp,%rbp
  803158:	48 83 ec 20          	sub    $0x20,%rsp
  80315c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80315f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803162:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803165:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803168:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80316b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80316e:	89 ce                	mov    %ecx,%esi
  803170:	89 c7                	mov    %eax,%edi
  803172:	48 b8 9a 35 80 00 00 	movabs $0x80359a,%rax
  803179:	00 00 00 
  80317c:	ff d0                	callq  *%rax
  80317e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803181:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803185:	79 05                	jns    80318c <socket+0x38>
		return r;
  803187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318a:	eb 11                	jmp    80319d <socket+0x49>
	return alloc_sockfd(r);
  80318c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318f:	89 c7                	mov    %eax,%edi
  803191:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 10          	sub    $0x10,%rsp
  8031a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031aa:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031b1:	00 00 00 
  8031b4:	8b 00                	mov    (%rax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	75 1f                	jne    8031d9 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031ba:	bf 02 00 00 00       	mov    $0x2,%edi
  8031bf:	48 b8 3b 42 80 00 00 	movabs $0x80423b,%rax
  8031c6:	00 00 00 
  8031c9:	ff d0                	callq  *%rax
  8031cb:	89 c2                	mov    %eax,%edx
  8031cd:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031d4:	00 00 00 
  8031d7:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8031d9:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031e0:	00 00 00 
  8031e3:	8b 00                	mov    (%rax),%eax
  8031e5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031e8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031ed:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8031f4:	00 00 00 
  8031f7:	89 c7                	mov    %eax,%edi
  8031f9:	48 b8 2f 40 80 00 00 	movabs $0x80402f,%rax
  803200:	00 00 00 
  803203:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803205:	ba 00 00 00 00       	mov    $0x0,%edx
  80320a:	be 00 00 00 00       	mov    $0x0,%esi
  80320f:	bf 00 00 00 00       	mov    $0x0,%edi
  803214:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  80321b:	00 00 00 
  80321e:	ff d0                	callq  *%rax
}
  803220:	c9                   	leaveq 
  803221:	c3                   	retq   

0000000000803222 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803222:	55                   	push   %rbp
  803223:	48 89 e5             	mov    %rsp,%rbp
  803226:	48 83 ec 30          	sub    $0x30,%rsp
  80322a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80322d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803231:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803235:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80323c:	00 00 00 
  80323f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803242:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803244:	bf 01 00 00 00       	mov    $0x1,%edi
  803249:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  803250:	00 00 00 
  803253:	ff d0                	callq  *%rax
  803255:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803258:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80325c:	78 3e                	js     80329c <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80325e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803265:	00 00 00 
  803268:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80326c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803270:	8b 40 10             	mov    0x10(%rax),%eax
  803273:	89 c2                	mov    %eax,%edx
  803275:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803279:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80327d:	48 89 ce             	mov    %rcx,%rsi
  803280:	48 89 c7             	mov    %rax,%rdi
  803283:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80328f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803293:	8b 50 10             	mov    0x10(%rax),%edx
  803296:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329a:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80329c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80329f:	c9                   	leaveq 
  8032a0:	c3                   	retq   

00000000008032a1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032a1:	55                   	push   %rbp
  8032a2:	48 89 e5             	mov    %rsp,%rbp
  8032a5:	48 83 ec 10          	sub    $0x10,%rsp
  8032a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032b3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8032ba:	00 00 00 
  8032bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032c2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c9:	48 89 c6             	mov    %rax,%rsi
  8032cc:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8032d3:	00 00 00 
  8032d6:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8032e2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8032e9:	00 00 00 
  8032ec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ef:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8032f2:	bf 02 00 00 00       	mov    $0x2,%edi
  8032f7:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
}
  803303:	c9                   	leaveq 
  803304:	c3                   	retq   

0000000000803305 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803305:	55                   	push   %rbp
  803306:	48 89 e5             	mov    %rsp,%rbp
  803309:	48 83 ec 10          	sub    $0x10,%rsp
  80330d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803310:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803313:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80331a:	00 00 00 
  80331d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803320:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803322:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803329:	00 00 00 
  80332c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803332:	bf 03 00 00 00       	mov    $0x3,%edi
  803337:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
}
  803343:	c9                   	leaveq 
  803344:	c3                   	retq   

0000000000803345 <nsipc_close>:

int
nsipc_close(int s)
{
  803345:	55                   	push   %rbp
  803346:	48 89 e5             	mov    %rsp,%rbp
  803349:	48 83 ec 10          	sub    $0x10,%rsp
  80334d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803350:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803357:	00 00 00 
  80335a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80335d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80335f:	bf 04 00 00 00       	mov    $0x4,%edi
  803364:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
}
  803370:	c9                   	leaveq 
  803371:	c3                   	retq   

0000000000803372 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803372:	55                   	push   %rbp
  803373:	48 89 e5             	mov    %rsp,%rbp
  803376:	48 83 ec 10          	sub    $0x10,%rsp
  80337a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80337d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803381:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803384:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80338b:	00 00 00 
  80338e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803391:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803393:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80339a:	48 89 c6             	mov    %rax,%rsi
  80339d:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8033a4:	00 00 00 
  8033a7:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033b3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033ba:	00 00 00 
  8033bd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033c0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033c3:	bf 05 00 00 00       	mov    $0x5,%edi
  8033c8:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
}
  8033d4:	c9                   	leaveq 
  8033d5:	c3                   	retq   

00000000008033d6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033d6:	55                   	push   %rbp
  8033d7:	48 89 e5             	mov    %rsp,%rbp
  8033da:	48 83 ec 10          	sub    $0x10,%rsp
  8033de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033e1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8033e4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033eb:	00 00 00 
  8033ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033f1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8033f3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033fa:	00 00 00 
  8033fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803400:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803403:	bf 06 00 00 00       	mov    $0x6,%edi
  803408:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  80340f:	00 00 00 
  803412:	ff d0                	callq  *%rax
}
  803414:	c9                   	leaveq 
  803415:	c3                   	retq   

0000000000803416 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803416:	55                   	push   %rbp
  803417:	48 89 e5             	mov    %rsp,%rbp
  80341a:	48 83 ec 30          	sub    $0x30,%rsp
  80341e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803421:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803425:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803428:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80342b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803432:	00 00 00 
  803435:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803438:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80343a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803441:	00 00 00 
  803444:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803447:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80344a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803451:	00 00 00 
  803454:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803457:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80345a:	bf 07 00 00 00       	mov    $0x7,%edi
  80345f:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
  80346b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803472:	78 69                	js     8034dd <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803474:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80347b:	7f 08                	jg     803485 <nsipc_recv+0x6f>
  80347d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803480:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803483:	7e 35                	jle    8034ba <nsipc_recv+0xa4>
  803485:	48 b9 6e 4f 80 00 00 	movabs $0x804f6e,%rcx
  80348c:	00 00 00 
  80348f:	48 ba 83 4f 80 00 00 	movabs $0x804f83,%rdx
  803496:	00 00 00 
  803499:	be 62 00 00 00       	mov    $0x62,%esi
  80349e:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  8034a5:	00 00 00 
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ad:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  8034b4:	00 00 00 
  8034b7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bd:	48 63 d0             	movslq %eax,%rdx
  8034c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034c4:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8034cb:	00 00 00 
  8034ce:	48 89 c7             	mov    %rax,%rdi
  8034d1:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
	}

	return r;
  8034dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034e0:	c9                   	leaveq 
  8034e1:	c3                   	retq   

00000000008034e2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8034e2:	55                   	push   %rbp
  8034e3:	48 89 e5             	mov    %rsp,%rbp
  8034e6:	48 83 ec 20          	sub    $0x20,%rsp
  8034ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034f1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8034f4:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8034f7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8034fe:	00 00 00 
  803501:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803504:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803506:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80350d:	7e 35                	jle    803544 <nsipc_send+0x62>
  80350f:	48 b9 a4 4f 80 00 00 	movabs $0x804fa4,%rcx
  803516:	00 00 00 
  803519:	48 ba 83 4f 80 00 00 	movabs $0x804f83,%rdx
  803520:	00 00 00 
  803523:	be 6d 00 00 00       	mov    $0x6d,%esi
  803528:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  80352f:	00 00 00 
  803532:	b8 00 00 00 00       	mov    $0x0,%eax
  803537:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  80353e:	00 00 00 
  803541:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803544:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803547:	48 63 d0             	movslq %eax,%rdx
  80354a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354e:	48 89 c6             	mov    %rax,%rsi
  803551:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803558:	00 00 00 
  80355b:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803567:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80356e:	00 00 00 
  803571:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803574:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803577:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80357e:	00 00 00 
  803581:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803584:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803587:	bf 08 00 00 00       	mov    $0x8,%edi
  80358c:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  803593:	00 00 00 
  803596:	ff d0                	callq  *%rax
}
  803598:	c9                   	leaveq 
  803599:	c3                   	retq   

000000000080359a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80359a:	55                   	push   %rbp
  80359b:	48 89 e5             	mov    %rsp,%rbp
  80359e:	48 83 ec 10          	sub    $0x10,%rsp
  8035a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035a5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035a8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035ab:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035b2:	00 00 00 
  8035b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035b8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035ba:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035c1:	00 00 00 
  8035c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035ca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035d1:	00 00 00 
  8035d4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035d7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8035da:	bf 09 00 00 00       	mov    $0x9,%edi
  8035df:	48 b8 9f 31 80 00 00 	movabs $0x80319f,%rax
  8035e6:	00 00 00 
  8035e9:	ff d0                	callq  *%rax
}
  8035eb:	c9                   	leaveq 
  8035ec:	c3                   	retq   

00000000008035ed <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035ed:	55                   	push   %rbp
  8035ee:	48 89 e5             	mov    %rsp,%rbp
  8035f1:	53                   	push   %rbx
  8035f2:	48 83 ec 38          	sub    $0x38,%rsp
  8035f6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035fa:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035fe:	48 89 c7             	mov    %rax,%rdi
  803601:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
  80360d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803610:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803614:	0f 88 bf 01 00 00    	js     8037d9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80361a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361e:	ba 07 04 00 00       	mov    $0x407,%edx
  803623:	48 89 c6             	mov    %rax,%rsi
  803626:	bf 00 00 00 00       	mov    $0x0,%edi
  80362b:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80363e:	0f 88 95 01 00 00    	js     8037d9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803644:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803648:	48 89 c7             	mov    %rax,%rdi
  80364b:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803652:	00 00 00 
  803655:	ff d0                	callq  *%rax
  803657:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80365e:	0f 88 5d 01 00 00    	js     8037c1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803664:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803668:	ba 07 04 00 00       	mov    $0x407,%edx
  80366d:	48 89 c6             	mov    %rax,%rsi
  803670:	bf 00 00 00 00       	mov    $0x0,%edi
  803675:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80367c:	00 00 00 
  80367f:	ff d0                	callq  *%rax
  803681:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803684:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803688:	0f 88 33 01 00 00    	js     8037c1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80368e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803692:	48 89 c7             	mov    %rax,%rdi
  803695:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
  8036a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8036ae:	48 89 c6             	mov    %rax,%rsi
  8036b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b6:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c9:	0f 88 d9 00 00 00    	js     8037a8 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d3:	48 89 c7             	mov    %rax,%rdi
  8036d6:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
  8036e2:	48 89 c2             	mov    %rax,%rdx
  8036e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036ef:	48 89 d1             	mov    %rdx,%rcx
  8036f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8036f7:	48 89 c6             	mov    %rax,%rsi
  8036fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ff:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803706:	00 00 00 
  803709:	ff d0                	callq  *%rax
  80370b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80370e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803712:	78 79                	js     80378d <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803718:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80371f:	00 00 00 
  803722:	8b 12                	mov    (%rdx),%edx
  803724:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803731:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803735:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80373c:	00 00 00 
  80373f:	8b 12                	mov    (%rdx),%edx
  803741:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803743:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803747:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80374e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803752:	48 89 c7             	mov    %rax,%rdi
  803755:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  80375c:	00 00 00 
  80375f:	ff d0                	callq  *%rax
  803761:	89 c2                	mov    %eax,%edx
  803763:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803767:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803769:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80376d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803771:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803775:	48 89 c7             	mov    %rax,%rdi
  803778:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
  803784:	89 03                	mov    %eax,(%rbx)
	return 0;
  803786:	b8 00 00 00 00       	mov    $0x0,%eax
  80378b:	eb 4f                	jmp    8037dc <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80378d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80378e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803792:	48 89 c6             	mov    %rax,%rsi
  803795:	bf 00 00 00 00       	mov    $0x0,%edi
  80379a:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8037a1:	00 00 00 
  8037a4:	ff d0                	callq  *%rax
  8037a6:	eb 01                	jmp    8037a9 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8037a8:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ad:	48 89 c6             	mov    %rax,%rsi
  8037b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b5:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8037bc:	00 00 00 
  8037bf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c5:	48 89 c6             	mov    %rax,%rsi
  8037c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8037cd:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
err:
	return r;
  8037d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037dc:	48 83 c4 38          	add    $0x38,%rsp
  8037e0:	5b                   	pop    %rbx
  8037e1:	5d                   	pop    %rbp
  8037e2:	c3                   	retq   

00000000008037e3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	53                   	push   %rbx
  8037e8:	48 83 ec 28          	sub    $0x28,%rsp
  8037ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037f4:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8037fb:	00 00 00 
  8037fe:	48 8b 00             	mov    (%rax),%rax
  803801:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803807:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80380a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380e:	48 89 c7             	mov    %rax,%rdi
  803811:	48 b8 ac 42 80 00 00 	movabs $0x8042ac,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	89 c3                	mov    %eax,%ebx
  80381f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803823:	48 89 c7             	mov    %rax,%rdi
  803826:	48 b8 ac 42 80 00 00 	movabs $0x8042ac,%rax
  80382d:	00 00 00 
  803830:	ff d0                	callq  *%rax
  803832:	39 c3                	cmp    %eax,%ebx
  803834:	0f 94 c0             	sete   %al
  803837:	0f b6 c0             	movzbl %al,%eax
  80383a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80383d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803844:	00 00 00 
  803847:	48 8b 00             	mov    (%rax),%rax
  80384a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803850:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803853:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803856:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803859:	75 05                	jne    803860 <_pipeisclosed+0x7d>
			return ret;
  80385b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80385e:	eb 4a                	jmp    8038aa <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803860:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803863:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803866:	74 8c                	je     8037f4 <_pipeisclosed+0x11>
  803868:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80386c:	75 86                	jne    8037f4 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80386e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803875:	00 00 00 
  803878:	48 8b 00             	mov    (%rax),%rax
  80387b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803881:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803884:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803887:	89 c6                	mov    %eax,%esi
  803889:	48 bf b5 4f 80 00 00 	movabs $0x804fb5,%rdi
  803890:	00 00 00 
  803893:	b8 00 00 00 00       	mov    $0x0,%eax
  803898:	49 b8 ea 04 80 00 00 	movabs $0x8004ea,%r8
  80389f:	00 00 00 
  8038a2:	41 ff d0             	callq  *%r8
	}
  8038a5:	e9 4a ff ff ff       	jmpq   8037f4 <_pipeisclosed+0x11>

}
  8038aa:	48 83 c4 28          	add    $0x28,%rsp
  8038ae:	5b                   	pop    %rbx
  8038af:	5d                   	pop    %rbp
  8038b0:	c3                   	retq   

00000000008038b1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038b1:	55                   	push   %rbp
  8038b2:	48 89 e5             	mov    %rsp,%rbp
  8038b5:	48 83 ec 30          	sub    $0x30,%rsp
  8038b9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038bc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038c3:	48 89 d6             	mov    %rdx,%rsi
  8038c6:	89 c7                	mov    %eax,%edi
  8038c8:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8038cf:	00 00 00 
  8038d2:	ff d0                	callq  *%rax
  8038d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038db:	79 05                	jns    8038e2 <pipeisclosed+0x31>
		return r;
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e0:	eb 31                	jmp    803913 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e6:	48 89 c7             	mov    %rax,%rdi
  8038e9:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
  8038f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803901:	48 89 d6             	mov    %rdx,%rsi
  803904:	48 89 c7             	mov    %rax,%rdi
  803907:	48 b8 e3 37 80 00 00 	movabs $0x8037e3,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
}
  803913:	c9                   	leaveq 
  803914:	c3                   	retq   

0000000000803915 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803915:	55                   	push   %rbp
  803916:	48 89 e5             	mov    %rsp,%rbp
  803919:	48 83 ec 40          	sub    $0x40,%rsp
  80391d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803921:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803925:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392d:	48 89 c7             	mov    %rax,%rdi
  803930:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
  80393c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803940:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803944:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803948:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80394f:	00 
  803950:	e9 90 00 00 00       	jmpq   8039e5 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803955:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80395a:	74 09                	je     803965 <devpipe_read+0x50>
				return i;
  80395c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803960:	e9 8e 00 00 00       	jmpq   8039f3 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803965:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396d:	48 89 d6             	mov    %rdx,%rsi
  803970:	48 89 c7             	mov    %rax,%rdi
  803973:	48 b8 e3 37 80 00 00 	movabs $0x8037e3,%rax
  80397a:	00 00 00 
  80397d:	ff d0                	callq  *%rax
  80397f:	85 c0                	test   %eax,%eax
  803981:	74 07                	je     80398a <devpipe_read+0x75>
				return 0;
  803983:	b8 00 00 00 00       	mov    $0x0,%eax
  803988:	eb 69                	jmp    8039f3 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80398a:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399a:	8b 10                	mov    (%rax),%edx
  80399c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a0:	8b 40 04             	mov    0x4(%rax),%eax
  8039a3:	39 c2                	cmp    %eax,%edx
  8039a5:	74 ae                	je     803955 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039af:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b7:	8b 00                	mov    (%rax),%eax
  8039b9:	99                   	cltd   
  8039ba:	c1 ea 1b             	shr    $0x1b,%edx
  8039bd:	01 d0                	add    %edx,%eax
  8039bf:	83 e0 1f             	and    $0x1f,%eax
  8039c2:	29 d0                	sub    %edx,%eax
  8039c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039c8:	48 98                	cltq   
  8039ca:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039cf:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d5:	8b 00                	mov    (%rax),%eax
  8039d7:	8d 50 01             	lea    0x1(%rax),%edx
  8039da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039de:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039ed:	72 a7                	jb     803996 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8039f3:	c9                   	leaveq 
  8039f4:	c3                   	retq   

00000000008039f5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039f5:	55                   	push   %rbp
  8039f6:	48 89 e5             	mov    %rsp,%rbp
  8039f9:	48 83 ec 40          	sub    $0x40,%rsp
  8039fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0d:	48 89 c7             	mov    %rax,%rdi
  803a10:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  803a17:	00 00 00 
  803a1a:	ff d0                	callq  *%rax
  803a1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a28:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a2f:	00 
  803a30:	e9 8f 00 00 00       	jmpq   803ac4 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3d:	48 89 d6             	mov    %rdx,%rsi
  803a40:	48 89 c7             	mov    %rax,%rdi
  803a43:	48 b8 e3 37 80 00 00 	movabs $0x8037e3,%rax
  803a4a:	00 00 00 
  803a4d:	ff d0                	callq  *%rax
  803a4f:	85 c0                	test   %eax,%eax
  803a51:	74 07                	je     803a5a <devpipe_write+0x65>
				return 0;
  803a53:	b8 00 00 00 00       	mov    $0x0,%eax
  803a58:	eb 78                	jmp    803ad2 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a5a:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a6a:	8b 40 04             	mov    0x4(%rax),%eax
  803a6d:	48 63 d0             	movslq %eax,%rdx
  803a70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a74:	8b 00                	mov    (%rax),%eax
  803a76:	48 98                	cltq   
  803a78:	48 83 c0 20          	add    $0x20,%rax
  803a7c:	48 39 c2             	cmp    %rax,%rdx
  803a7f:	73 b4                	jae    803a35 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a85:	8b 40 04             	mov    0x4(%rax),%eax
  803a88:	99                   	cltd   
  803a89:	c1 ea 1b             	shr    $0x1b,%edx
  803a8c:	01 d0                	add    %edx,%eax
  803a8e:	83 e0 1f             	and    $0x1f,%eax
  803a91:	29 d0                	sub    %edx,%eax
  803a93:	89 c6                	mov    %eax,%esi
  803a95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a9d:	48 01 d0             	add    %rdx,%rax
  803aa0:	0f b6 08             	movzbl (%rax),%ecx
  803aa3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aa7:	48 63 c6             	movslq %esi,%rax
  803aaa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab2:	8b 40 04             	mov    0x4(%rax),%eax
  803ab5:	8d 50 01             	lea    0x1(%rax),%edx
  803ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803abf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803acc:	72 98                	jb     803a66 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ace:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803ad2:	c9                   	leaveq 
  803ad3:	c3                   	retq   

0000000000803ad4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ad4:	55                   	push   %rbp
  803ad5:	48 89 e5             	mov    %rsp,%rbp
  803ad8:	48 83 ec 20          	sub    $0x20,%rsp
  803adc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ae0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ae4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae8:	48 89 c7             	mov    %rax,%rdi
  803aeb:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
  803af7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803afb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aff:	48 be c8 4f 80 00 00 	movabs $0x804fc8,%rsi
  803b06:	00 00 00 
  803b09:	48 89 c7             	mov    %rax,%rdi
  803b0c:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b1c:	8b 50 04             	mov    0x4(%rax),%edx
  803b1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b23:	8b 00                	mov    (%rax),%eax
  803b25:	29 c2                	sub    %eax,%edx
  803b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b35:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b3c:	00 00 00 
	stat->st_dev = &devpipe;
  803b3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b43:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  803b4a:	00 00 00 
  803b4d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b59:	c9                   	leaveq 
  803b5a:	c3                   	retq   

0000000000803b5b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b5b:	55                   	push   %rbp
  803b5c:	48 89 e5             	mov    %rsp,%rbp
  803b5f:	48 83 ec 10          	sub    $0x10,%rsp
  803b63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6b:	48 89 c6             	mov    %rax,%rsi
  803b6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b73:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b83:	48 89 c7             	mov    %rax,%rdi
  803b86:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
  803b92:	48 89 c6             	mov    %rax,%rsi
  803b95:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9a:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	callq  *%rax
}
  803ba6:	c9                   	leaveq 
  803ba7:	c3                   	retq   

0000000000803ba8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ba8:	55                   	push   %rbp
  803ba9:	48 89 e5             	mov    %rsp,%rbp
  803bac:	48 83 ec 20          	sub    $0x20,%rsp
  803bb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bb6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bb9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bbd:	be 01 00 00 00       	mov    $0x1,%esi
  803bc2:	48 89 c7             	mov    %rax,%rdi
  803bc5:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
}
  803bd1:	90                   	nop
  803bd2:	c9                   	leaveq 
  803bd3:	c3                   	retq   

0000000000803bd4 <getchar>:

int
getchar(void)
{
  803bd4:	55                   	push   %rbp
  803bd5:	48 89 e5             	mov    %rsp,%rbp
  803bd8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bdc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803be0:	ba 01 00 00 00       	mov    $0x1,%edx
  803be5:	48 89 c6             	mov    %rax,%rsi
  803be8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bed:	48 b8 c7 22 80 00 00 	movabs $0x8022c7,%rax
  803bf4:	00 00 00 
  803bf7:	ff d0                	callq  *%rax
  803bf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803bfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c00:	79 05                	jns    803c07 <getchar+0x33>
		return r;
  803c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c05:	eb 14                	jmp    803c1b <getchar+0x47>
	if (r < 1)
  803c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0b:	7f 07                	jg     803c14 <getchar+0x40>
		return -E_EOF;
  803c0d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c12:	eb 07                	jmp    803c1b <getchar+0x47>
	return c;
  803c14:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c18:	0f b6 c0             	movzbl %al,%eax

}
  803c1b:	c9                   	leaveq 
  803c1c:	c3                   	retq   

0000000000803c1d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c1d:	55                   	push   %rbp
  803c1e:	48 89 e5             	mov    %rsp,%rbp
  803c21:	48 83 ec 20          	sub    $0x20,%rsp
  803c25:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c2f:	48 89 d6             	mov    %rdx,%rsi
  803c32:	89 c7                	mov    %eax,%edi
  803c34:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  803c3b:	00 00 00 
  803c3e:	ff d0                	callq  *%rax
  803c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c47:	79 05                	jns    803c4e <iscons+0x31>
		return r;
  803c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4c:	eb 1a                	jmp    803c68 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c52:	8b 10                	mov    (%rax),%edx
  803c54:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803c5b:	00 00 00 
  803c5e:	8b 00                	mov    (%rax),%eax
  803c60:	39 c2                	cmp    %eax,%edx
  803c62:	0f 94 c0             	sete   %al
  803c65:	0f b6 c0             	movzbl %al,%eax
}
  803c68:	c9                   	leaveq 
  803c69:	c3                   	retq   

0000000000803c6a <opencons>:

int
opencons(void)
{
  803c6a:	55                   	push   %rbp
  803c6b:	48 89 e5             	mov    %rsp,%rbp
  803c6e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c72:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c76:	48 89 c7             	mov    %rax,%rdi
  803c79:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  803c80:	00 00 00 
  803c83:	ff d0                	callq  *%rax
  803c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c8c:	79 05                	jns    803c93 <opencons+0x29>
		return r;
  803c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c91:	eb 5b                	jmp    803cee <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c97:	ba 07 04 00 00       	mov    $0x407,%edx
  803c9c:	48 89 c6             	mov    %rax,%rsi
  803c9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca4:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803cab:	00 00 00 
  803cae:	ff d0                	callq  *%rax
  803cb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb7:	79 05                	jns    803cbe <opencons+0x54>
		return r;
  803cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbc:	eb 30                	jmp    803cee <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc2:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  803cc9:	00 00 00 
  803ccc:	8b 12                	mov    (%rdx),%edx
  803cce:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdf:	48 89 c7             	mov    %rax,%rdi
  803ce2:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  803ce9:	00 00 00 
  803cec:	ff d0                	callq  *%rax
}
  803cee:	c9                   	leaveq 
  803cef:	c3                   	retq   

0000000000803cf0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cf0:	55                   	push   %rbp
  803cf1:	48 89 e5             	mov    %rsp,%rbp
  803cf4:	48 83 ec 30          	sub    $0x30,%rsp
  803cf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d04:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d09:	75 13                	jne    803d1e <devcons_read+0x2e>
		return 0;
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d10:	eb 49                	jmp    803d5b <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803d12:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d1e:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  803d25:	00 00 00 
  803d28:	ff d0                	callq  *%rax
  803d2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d31:	74 df                	je     803d12 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d37:	79 05                	jns    803d3e <devcons_read+0x4e>
		return c;
  803d39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3c:	eb 1d                	jmp    803d5b <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803d3e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d42:	75 07                	jne    803d4b <devcons_read+0x5b>
		return 0;
  803d44:	b8 00 00 00 00       	mov    $0x0,%eax
  803d49:	eb 10                	jmp    803d5b <devcons_read+0x6b>
	*(char*)vbuf = c;
  803d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4e:	89 c2                	mov    %eax,%edx
  803d50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d54:	88 10                	mov    %dl,(%rax)
	return 1;
  803d56:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d5b:	c9                   	leaveq 
  803d5c:	c3                   	retq   

0000000000803d5d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d5d:	55                   	push   %rbp
  803d5e:	48 89 e5             	mov    %rsp,%rbp
  803d61:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d68:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d6f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d76:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d84:	eb 76                	jmp    803dfc <devcons_write+0x9f>
		m = n - tot;
  803d86:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d8d:	89 c2                	mov    %eax,%edx
  803d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d92:	29 c2                	sub    %eax,%edx
  803d94:	89 d0                	mov    %edx,%eax
  803d96:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d9c:	83 f8 7f             	cmp    $0x7f,%eax
  803d9f:	76 07                	jbe    803da8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803da1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803da8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dab:	48 63 d0             	movslq %eax,%rdx
  803dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db1:	48 63 c8             	movslq %eax,%rcx
  803db4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803dbb:	48 01 c1             	add    %rax,%rcx
  803dbe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dc5:	48 89 ce             	mov    %rcx,%rsi
  803dc8:	48 89 c7             	mov    %rax,%rdi
  803dcb:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  803dd2:	00 00 00 
  803dd5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803dd7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dda:	48 63 d0             	movslq %eax,%rdx
  803ddd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803de4:	48 89 d6             	mov    %rdx,%rsi
  803de7:	48 89 c7             	mov    %rax,%rdi
  803dea:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803df6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df9:	01 45 fc             	add    %eax,-0x4(%rbp)
  803dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dff:	48 98                	cltq   
  803e01:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e08:	0f 82 78 ff ff ff    	jb     803d86 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e11:	c9                   	leaveq 
  803e12:	c3                   	retq   

0000000000803e13 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e13:	55                   	push   %rbp
  803e14:	48 89 e5             	mov    %rsp,%rbp
  803e17:	48 83 ec 08          	sub    $0x8,%rsp
  803e1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e24:	c9                   	leaveq 
  803e25:	c3                   	retq   

0000000000803e26 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e26:	55                   	push   %rbp
  803e27:	48 89 e5             	mov    %rsp,%rbp
  803e2a:	48 83 ec 10          	sub    $0x10,%rsp
  803e2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3a:	48 be d4 4f 80 00 00 	movabs $0x804fd4,%rsi
  803e41:	00 00 00 
  803e44:	48 89 c7             	mov    %rax,%rdi
  803e47:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  803e4e:	00 00 00 
  803e51:	ff d0                	callq  *%rax
	return 0;
  803e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e58:	c9                   	leaveq 
  803e59:	c3                   	retq   

0000000000803e5a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803e5a:	55                   	push   %rbp
  803e5b:	48 89 e5             	mov    %rsp,%rbp
  803e5e:	53                   	push   %rbx
  803e5f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803e66:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803e6d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803e73:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e7a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803e81:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803e88:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803e8f:	84 c0                	test   %al,%al
  803e91:	74 23                	je     803eb6 <_panic+0x5c>
  803e93:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803e9a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803e9e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ea2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803ea6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803eaa:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803eae:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803eb2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803eb6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803ebd:	00 00 00 
  803ec0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803ec7:	00 00 00 
  803eca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ece:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803ed5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803edc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803ee3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eea:	00 00 00 
  803eed:	48 8b 18             	mov    (%rax),%rbx
  803ef0:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  803ef7:	00 00 00 
  803efa:	ff d0                	callq  *%rax
  803efc:	89 c6                	mov    %eax,%esi
  803efe:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803f04:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f0b:	41 89 d0             	mov    %edx,%r8d
  803f0e:	48 89 c1             	mov    %rax,%rcx
  803f11:	48 89 da             	mov    %rbx,%rdx
  803f14:	48 bf e0 4f 80 00 00 	movabs $0x804fe0,%rdi
  803f1b:	00 00 00 
  803f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f23:	49 b9 ea 04 80 00 00 	movabs $0x8004ea,%r9
  803f2a:	00 00 00 
  803f2d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803f30:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803f37:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f3e:	48 89 d6             	mov    %rdx,%rsi
  803f41:	48 89 c7             	mov    %rax,%rdi
  803f44:	48 b8 3e 04 80 00 00 	movabs $0x80043e,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
	cprintf("\n");
  803f50:	48 bf 03 50 80 00 00 	movabs $0x805003,%rdi
  803f57:	00 00 00 
  803f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5f:	48 ba ea 04 80 00 00 	movabs $0x8004ea,%rdx
  803f66:	00 00 00 
  803f69:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803f6b:	cc                   	int3   
  803f6c:	eb fd                	jmp    803f6b <_panic+0x111>

0000000000803f6e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f6e:	55                   	push   %rbp
  803f6f:	48 89 e5             	mov    %rsp,%rbp
  803f72:	48 83 ec 30          	sub    $0x30,%rsp
  803f76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803f82:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f87:	75 0e                	jne    803f97 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803f89:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f90:	00 00 00 
  803f93:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803f97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f9b:	48 89 c7             	mov    %rax,%rdi
  803f9e:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803fa5:	00 00 00 
  803fa8:	ff d0                	callq  *%rax
  803faa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb1:	79 27                	jns    803fda <ipc_recv+0x6c>
		if (from_env_store)
  803fb3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fb8:	74 0a                	je     803fc4 <ipc_recv+0x56>
			*from_env_store = 0;
  803fba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fbe:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803fc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fc9:	74 0a                	je     803fd5 <ipc_recv+0x67>
			*perm_store = 0;
  803fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fcf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd8:	eb 53                	jmp    80402d <ipc_recv+0xbf>
	}
	if (from_env_store)
  803fda:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fdf:	74 19                	je     803ffa <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803fe1:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803fe8:	00 00 00 
  803feb:	48 8b 00             	mov    (%rax),%rax
  803fee:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ff8:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803ffa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fff:	74 19                	je     80401a <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804001:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804008:	00 00 00 
  80400b:	48 8b 00             	mov    (%rax),%rax
  80400e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804018:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80401a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804021:	00 00 00 
  804024:	48 8b 00             	mov    (%rax),%rax
  804027:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80402d:	c9                   	leaveq 
  80402e:	c3                   	retq   

000000000080402f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80402f:	55                   	push   %rbp
  804030:	48 89 e5             	mov    %rsp,%rbp
  804033:	48 83 ec 30          	sub    $0x30,%rsp
  804037:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80403a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80403d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804041:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804044:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804049:	75 1c                	jne    804067 <ipc_send+0x38>
		pg = (void*) UTOP;
  80404b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804052:	00 00 00 
  804055:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804059:	eb 0c                	jmp    804067 <ipc_send+0x38>
		sys_yield();
  80405b:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804067:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80406a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80406d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804071:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804074:	89 c7                	mov    %eax,%edi
  804076:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  80407d:	00 00 00 
  804080:	ff d0                	callq  *%rax
  804082:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804085:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804089:	74 d0                	je     80405b <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80408b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408f:	79 30                	jns    8040c1 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804094:	89 c1                	mov    %eax,%ecx
  804096:	48 ba 05 50 80 00 00 	movabs $0x805005,%rdx
  80409d:	00 00 00 
  8040a0:	be 47 00 00 00       	mov    $0x47,%esi
  8040a5:	48 bf 1b 50 80 00 00 	movabs $0x80501b,%rdi
  8040ac:	00 00 00 
  8040af:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b4:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  8040bb:	00 00 00 
  8040be:	41 ff d0             	callq  *%r8

}
  8040c1:	90                   	nop
  8040c2:	c9                   	leaveq 
  8040c3:	c3                   	retq   

00000000008040c4 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8040c4:	55                   	push   %rbp
  8040c5:	48 89 e5             	mov    %rsp,%rbp
  8040c8:	53                   	push   %rbx
  8040c9:	48 83 ec 28          	sub    $0x28,%rsp
  8040cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8040d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8040d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8040df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040e4:	75 0e                	jne    8040f4 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8040e6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040ed:	00 00 00 
  8040f0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8040f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f8:	ba 07 00 00 00       	mov    $0x7,%edx
  8040fd:	48 89 c6             	mov    %rax,%rsi
  804100:	bf 00 00 00 00       	mov    $0x0,%edi
  804105:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80410c:	00 00 00 
  80410f:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804111:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804115:	48 c1 e8 0c          	shr    $0xc,%rax
  804119:	48 89 c2             	mov    %rax,%rdx
  80411c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804123:	01 00 00 
  804126:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80412a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804130:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804134:	b8 03 00 00 00       	mov    $0x3,%eax
  804139:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80413d:	48 89 d3             	mov    %rdx,%rbx
  804140:	0f 01 c1             	vmcall 
  804143:	89 f2                	mov    %esi,%edx
  804145:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804148:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80414b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80414f:	79 05                	jns    804156 <ipc_host_recv+0x92>
		return r;
  804151:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804154:	eb 03                	jmp    804159 <ipc_host_recv+0x95>
	}
	return val;
  804156:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804159:	48 83 c4 28          	add    $0x28,%rsp
  80415d:	5b                   	pop    %rbx
  80415e:	5d                   	pop    %rbp
  80415f:	c3                   	retq   

0000000000804160 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804160:	55                   	push   %rbp
  804161:	48 89 e5             	mov    %rsp,%rbp
  804164:	53                   	push   %rbx
  804165:	48 83 ec 38          	sub    $0x38,%rsp
  804169:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80416c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80416f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804173:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804176:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80417d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804182:	75 0e                	jne    804192 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804184:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80418b:	00 00 00 
  80418e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804192:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804196:	48 c1 e8 0c          	shr    $0xc,%rax
  80419a:	48 89 c2             	mov    %rax,%rdx
  80419d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041a4:	01 00 00 
  8041a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041ab:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8041b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8041ba:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8041bd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8041c0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041c4:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8041c7:	89 fb                	mov    %edi,%ebx
  8041c9:	0f 01 c1             	vmcall 
  8041cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8041cf:	eb 26                	jmp    8041f7 <ipc_host_send+0x97>
		sys_yield();
  8041d1:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  8041d8:	00 00 00 
  8041db:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8041dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8041e2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8041e5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8041e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041ec:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8041ef:	89 fb                	mov    %edi,%ebx
  8041f1:	0f 01 c1             	vmcall 
  8041f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8041f7:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8041fb:	74 d4                	je     8041d1 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8041fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804201:	79 30                	jns    804233 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804203:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804206:	89 c1                	mov    %eax,%ecx
  804208:	48 ba 05 50 80 00 00 	movabs $0x805005,%rdx
  80420f:	00 00 00 
  804212:	be 79 00 00 00       	mov    $0x79,%esi
  804217:	48 bf 1b 50 80 00 00 	movabs $0x80501b,%rdi
  80421e:	00 00 00 
  804221:	b8 00 00 00 00       	mov    $0x0,%eax
  804226:	49 b8 5a 3e 80 00 00 	movabs $0x803e5a,%r8
  80422d:	00 00 00 
  804230:	41 ff d0             	callq  *%r8

}
  804233:	90                   	nop
  804234:	48 83 c4 38          	add    $0x38,%rsp
  804238:	5b                   	pop    %rbx
  804239:	5d                   	pop    %rbp
  80423a:	c3                   	retq   

000000000080423b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80423b:	55                   	push   %rbp
  80423c:	48 89 e5             	mov    %rsp,%rbp
  80423f:	48 83 ec 18          	sub    $0x18,%rsp
  804243:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804246:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80424d:	eb 4d                	jmp    80429c <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80424f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804256:	00 00 00 
  804259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425c:	48 98                	cltq   
  80425e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804265:	48 01 d0             	add    %rdx,%rax
  804268:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80426e:	8b 00                	mov    (%rax),%eax
  804270:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804273:	75 23                	jne    804298 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804275:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80427c:	00 00 00 
  80427f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804282:	48 98                	cltq   
  804284:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80428b:	48 01 d0             	add    %rdx,%rax
  80428e:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804294:	8b 00                	mov    (%rax),%eax
  804296:	eb 12                	jmp    8042aa <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804298:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80429c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8042a3:	7e aa                	jle    80424f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8042a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042aa:	c9                   	leaveq 
  8042ab:	c3                   	retq   

00000000008042ac <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8042ac:	55                   	push   %rbp
  8042ad:	48 89 e5             	mov    %rsp,%rbp
  8042b0:	48 83 ec 18          	sub    $0x18,%rsp
  8042b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042bc:	48 c1 e8 15          	shr    $0x15,%rax
  8042c0:	48 89 c2             	mov    %rax,%rdx
  8042c3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042ca:	01 00 00 
  8042cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042d1:	83 e0 01             	and    $0x1,%eax
  8042d4:	48 85 c0             	test   %rax,%rax
  8042d7:	75 07                	jne    8042e0 <pageref+0x34>
		return 0;
  8042d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8042de:	eb 56                	jmp    804336 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8042e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8042e8:	48 89 c2             	mov    %rax,%rdx
  8042eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042f2:	01 00 00 
  8042f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804301:	83 e0 01             	and    $0x1,%eax
  804304:	48 85 c0             	test   %rax,%rax
  804307:	75 07                	jne    804310 <pageref+0x64>
		return 0;
  804309:	b8 00 00 00 00       	mov    $0x0,%eax
  80430e:	eb 26                	jmp    804336 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804314:	48 c1 e8 0c          	shr    $0xc,%rax
  804318:	48 89 c2             	mov    %rax,%rdx
  80431b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804322:	00 00 00 
  804325:	48 c1 e2 04          	shl    $0x4,%rdx
  804329:	48 01 d0             	add    %rdx,%rax
  80432c:	48 83 c0 08          	add    $0x8,%rax
  804330:	0f b7 00             	movzwl (%rax),%eax
  804333:	0f b7 c0             	movzwl %ax,%eax
}
  804336:	c9                   	leaveq 
  804337:	c3                   	retq   

0000000000804338 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804338:	55                   	push   %rbp
  804339:	48 89 e5             	mov    %rsp,%rbp
  80433c:	48 83 ec 20          	sub    $0x20,%rsp
  804340:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804344:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80434c:	48 89 d6             	mov    %rdx,%rsi
  80434f:	48 89 c7             	mov    %rax,%rdi
  804352:	48 b8 6e 43 80 00 00 	movabs $0x80436e,%rax
  804359:	00 00 00 
  80435c:	ff d0                	callq  *%rax
  80435e:	85 c0                	test   %eax,%eax
  804360:	74 05                	je     804367 <inet_addr+0x2f>
    return (val.s_addr);
  804362:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804365:	eb 05                	jmp    80436c <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80436c:	c9                   	leaveq 
  80436d:	c3                   	retq   

000000000080436e <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80436e:	55                   	push   %rbp
  80436f:	48 89 e5             	mov    %rsp,%rbp
  804372:	48 83 ec 40          	sub    $0x40,%rsp
  804376:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80437a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80437e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804382:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804386:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80438a:	0f b6 00             	movzbl (%rax),%eax
  80438d:	0f be c0             	movsbl %al,%eax
  804390:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804393:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804396:	0f b6 c0             	movzbl %al,%eax
  804399:	83 f8 2f             	cmp    $0x2f,%eax
  80439c:	7e 0b                	jle    8043a9 <inet_aton+0x3b>
  80439e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043a1:	0f b6 c0             	movzbl %al,%eax
  8043a4:	83 f8 39             	cmp    $0x39,%eax
  8043a7:	7e 0a                	jle    8043b3 <inet_aton+0x45>
      return (0);
  8043a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ae:	e9 a1 02 00 00       	jmpq   804654 <inet_aton+0x2e6>
    val = 0;
  8043b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8043ba:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8043c1:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8043c5:	75 40                	jne    804407 <inet_aton+0x99>
      c = *++cp;
  8043c7:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8043cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043d0:	0f b6 00             	movzbl (%rax),%eax
  8043d3:	0f be c0             	movsbl %al,%eax
  8043d6:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8043d9:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8043dd:	74 06                	je     8043e5 <inet_aton+0x77>
  8043df:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8043e3:	75 1b                	jne    804400 <inet_aton+0x92>
        base = 16;
  8043e5:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  8043ec:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8043f1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043f5:	0f b6 00             	movzbl (%rax),%eax
  8043f8:	0f be c0             	movsbl %al,%eax
  8043fb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8043fe:	eb 07                	jmp    804407 <inet_aton+0x99>
      } else
        base = 8;
  804400:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804407:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80440a:	0f b6 c0             	movzbl %al,%eax
  80440d:	83 f8 2f             	cmp    $0x2f,%eax
  804410:	7e 36                	jle    804448 <inet_aton+0xda>
  804412:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804415:	0f b6 c0             	movzbl %al,%eax
  804418:	83 f8 39             	cmp    $0x39,%eax
  80441b:	7f 2b                	jg     804448 <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  80441d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804420:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804424:	89 c2                	mov    %eax,%edx
  804426:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804429:	01 d0                	add    %edx,%eax
  80442b:	83 e8 30             	sub    $0x30,%eax
  80442e:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804431:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804436:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80443a:	0f b6 00             	movzbl (%rax),%eax
  80443d:	0f be c0             	movsbl %al,%eax
  804440:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804443:	e9 97 00 00 00       	jmpq   8044df <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  804448:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80444c:	0f 85 92 00 00 00    	jne    8044e4 <inet_aton+0x176>
  804452:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804455:	0f b6 c0             	movzbl %al,%eax
  804458:	83 f8 2f             	cmp    $0x2f,%eax
  80445b:	7e 0b                	jle    804468 <inet_aton+0xfa>
  80445d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804460:	0f b6 c0             	movzbl %al,%eax
  804463:	83 f8 39             	cmp    $0x39,%eax
  804466:	7e 2c                	jle    804494 <inet_aton+0x126>
  804468:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80446b:	0f b6 c0             	movzbl %al,%eax
  80446e:	83 f8 60             	cmp    $0x60,%eax
  804471:	7e 0b                	jle    80447e <inet_aton+0x110>
  804473:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804476:	0f b6 c0             	movzbl %al,%eax
  804479:	83 f8 66             	cmp    $0x66,%eax
  80447c:	7e 16                	jle    804494 <inet_aton+0x126>
  80447e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804481:	0f b6 c0             	movzbl %al,%eax
  804484:	83 f8 40             	cmp    $0x40,%eax
  804487:	7e 5b                	jle    8044e4 <inet_aton+0x176>
  804489:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80448c:	0f b6 c0             	movzbl %al,%eax
  80448f:	83 f8 46             	cmp    $0x46,%eax
  804492:	7f 50                	jg     8044e4 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804494:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804497:	c1 e0 04             	shl    $0x4,%eax
  80449a:	89 c2                	mov    %eax,%edx
  80449c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80449f:	8d 48 0a             	lea    0xa(%rax),%ecx
  8044a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044a5:	0f b6 c0             	movzbl %al,%eax
  8044a8:	83 f8 60             	cmp    $0x60,%eax
  8044ab:	7e 12                	jle    8044bf <inet_aton+0x151>
  8044ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044b0:	0f b6 c0             	movzbl %al,%eax
  8044b3:	83 f8 7a             	cmp    $0x7a,%eax
  8044b6:	7f 07                	jg     8044bf <inet_aton+0x151>
  8044b8:	b8 61 00 00 00       	mov    $0x61,%eax
  8044bd:	eb 05                	jmp    8044c4 <inet_aton+0x156>
  8044bf:	b8 41 00 00 00       	mov    $0x41,%eax
  8044c4:	29 c1                	sub    %eax,%ecx
  8044c6:	89 c8                	mov    %ecx,%eax
  8044c8:	09 d0                	or     %edx,%eax
  8044ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8044cd:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8044d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044d6:	0f b6 00             	movzbl (%rax),%eax
  8044d9:	0f be c0             	movsbl %al,%eax
  8044dc:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8044df:	e9 23 ff ff ff       	jmpq   804407 <inet_aton+0x99>
    if (c == '.') {
  8044e4:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8044e8:	75 40                	jne    80452a <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8044ea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8044ee:	48 83 c0 0c          	add    $0xc,%rax
  8044f2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8044f6:	77 0a                	ja     804502 <inet_aton+0x194>
        return (0);
  8044f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8044fd:	e9 52 01 00 00       	jmpq   804654 <inet_aton+0x2e6>
      *pp++ = val;
  804502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804506:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80450a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80450e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804511:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804513:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804518:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80451c:	0f b6 00             	movzbl (%rax),%eax
  80451f:	0f be c0             	movsbl %al,%eax
  804522:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  804525:	e9 69 fe ff ff       	jmpq   804393 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  80452a:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80452b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80452f:	74 44                	je     804575 <inet_aton+0x207>
  804531:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804534:	0f b6 c0             	movzbl %al,%eax
  804537:	83 f8 1f             	cmp    $0x1f,%eax
  80453a:	7e 2f                	jle    80456b <inet_aton+0x1fd>
  80453c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80453f:	0f b6 c0             	movzbl %al,%eax
  804542:	83 f8 7f             	cmp    $0x7f,%eax
  804545:	7f 24                	jg     80456b <inet_aton+0x1fd>
  804547:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80454b:	74 28                	je     804575 <inet_aton+0x207>
  80454d:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804551:	74 22                	je     804575 <inet_aton+0x207>
  804553:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804557:	74 1c                	je     804575 <inet_aton+0x207>
  804559:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80455d:	74 16                	je     804575 <inet_aton+0x207>
  80455f:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804563:	74 10                	je     804575 <inet_aton+0x207>
  804565:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804569:	74 0a                	je     804575 <inet_aton+0x207>
    return (0);
  80456b:	b8 00 00 00 00       	mov    $0x0,%eax
  804570:	e9 df 00 00 00       	jmpq   804654 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804575:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804579:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80457d:	48 29 c2             	sub    %rax,%rdx
  804580:	48 89 d0             	mov    %rdx,%rax
  804583:	48 c1 f8 02          	sar    $0x2,%rax
  804587:	83 c0 01             	add    $0x1,%eax
  80458a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80458d:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804591:	0f 87 98 00 00 00    	ja     80462f <inet_aton+0x2c1>
  804597:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80459a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8045a1:	00 
  8045a2:	48 b8 28 50 80 00 00 	movabs $0x805028,%rax
  8045a9:	00 00 00 
  8045ac:	48 01 d0             	add    %rdx,%rax
  8045af:	48 8b 00             	mov    (%rax),%rax
  8045b2:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8045b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b9:	e9 96 00 00 00       	jmpq   804654 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8045be:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8045c5:	76 0a                	jbe    8045d1 <inet_aton+0x263>
      return (0);
  8045c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8045cc:	e9 83 00 00 00       	jmpq   804654 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  8045d1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045d4:	c1 e0 18             	shl    $0x18,%eax
  8045d7:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045da:	eb 53                	jmp    80462f <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8045dc:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8045e3:	76 07                	jbe    8045ec <inet_aton+0x27e>
      return (0);
  8045e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ea:	eb 68                	jmp    804654 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8045ec:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045ef:	c1 e0 18             	shl    $0x18,%eax
  8045f2:	89 c2                	mov    %eax,%edx
  8045f4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8045f7:	c1 e0 10             	shl    $0x10,%eax
  8045fa:	09 d0                	or     %edx,%eax
  8045fc:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045ff:	eb 2e                	jmp    80462f <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804601:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  804608:	76 07                	jbe    804611 <inet_aton+0x2a3>
      return (0);
  80460a:	b8 00 00 00 00       	mov    $0x0,%eax
  80460f:	eb 43                	jmp    804654 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804611:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804614:	c1 e0 18             	shl    $0x18,%eax
  804617:	89 c2                	mov    %eax,%edx
  804619:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80461c:	c1 e0 10             	shl    $0x10,%eax
  80461f:	09 c2                	or     %eax,%edx
  804621:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804624:	c1 e0 08             	shl    $0x8,%eax
  804627:	09 d0                	or     %edx,%eax
  804629:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80462c:	eb 01                	jmp    80462f <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80462e:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80462f:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804634:	74 19                	je     80464f <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  804636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804639:	89 c7                	mov    %eax,%edi
  80463b:	48 b8 cd 47 80 00 00 	movabs $0x8047cd,%rax
  804642:	00 00 00 
  804645:	ff d0                	callq  *%rax
  804647:	89 c2                	mov    %eax,%edx
  804649:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80464d:	89 10                	mov    %edx,(%rax)
  return (1);
  80464f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804654:	c9                   	leaveq 
  804655:	c3                   	retq   

0000000000804656 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804656:	55                   	push   %rbp
  804657:	48 89 e5             	mov    %rsp,%rbp
  80465a:	48 83 ec 30          	sub    $0x30,%rsp
  80465e:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804661:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804664:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804667:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80466e:	00 00 00 
  804671:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804675:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804679:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80467d:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804681:	e9 e0 00 00 00       	jmpq   804766 <inet_ntoa+0x110>
    i = 0;
  804686:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80468a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468e:	0f b6 08             	movzbl (%rax),%ecx
  804691:	0f b6 d1             	movzbl %cl,%edx
  804694:	89 d0                	mov    %edx,%eax
  804696:	c1 e0 02             	shl    $0x2,%eax
  804699:	01 d0                	add    %edx,%eax
  80469b:	c1 e0 03             	shl    $0x3,%eax
  80469e:	01 d0                	add    %edx,%eax
  8046a0:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8046a7:	01 d0                	add    %edx,%eax
  8046a9:	66 c1 e8 08          	shr    $0x8,%ax
  8046ad:	c0 e8 03             	shr    $0x3,%al
  8046b0:	88 45 ed             	mov    %al,-0x13(%rbp)
  8046b3:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8046b7:	89 d0                	mov    %edx,%eax
  8046b9:	c1 e0 02             	shl    $0x2,%eax
  8046bc:	01 d0                	add    %edx,%eax
  8046be:	01 c0                	add    %eax,%eax
  8046c0:	29 c1                	sub    %eax,%ecx
  8046c2:	89 c8                	mov    %ecx,%eax
  8046c4:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8046c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046cb:	0f b6 00             	movzbl (%rax),%eax
  8046ce:	0f b6 d0             	movzbl %al,%edx
  8046d1:	89 d0                	mov    %edx,%eax
  8046d3:	c1 e0 02             	shl    $0x2,%eax
  8046d6:	01 d0                	add    %edx,%eax
  8046d8:	c1 e0 03             	shl    $0x3,%eax
  8046db:	01 d0                	add    %edx,%eax
  8046dd:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8046e4:	01 d0                	add    %edx,%eax
  8046e6:	66 c1 e8 08          	shr    $0x8,%ax
  8046ea:	89 c2                	mov    %eax,%edx
  8046ec:	c0 ea 03             	shr    $0x3,%dl
  8046ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f3:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8046f5:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8046f9:	8d 50 01             	lea    0x1(%rax),%edx
  8046fc:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8046ff:	0f b6 c0             	movzbl %al,%eax
  804702:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804706:	83 c2 30             	add    $0x30,%edx
  804709:	48 98                	cltq   
  80470b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80470f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804713:	0f b6 00             	movzbl (%rax),%eax
  804716:	84 c0                	test   %al,%al
  804718:	0f 85 6c ff ff ff    	jne    80468a <inet_ntoa+0x34>
    while(i--)
  80471e:	eb 1a                	jmp    80473a <inet_ntoa+0xe4>
      *rp++ = inv[i];
  804720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804724:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804728:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80472c:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  804730:	48 63 d2             	movslq %edx,%rdx
  804733:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804738:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80473a:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80473e:	8d 50 ff             	lea    -0x1(%rax),%edx
  804741:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804744:	84 c0                	test   %al,%al
  804746:	75 d8                	jne    804720 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  804748:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80474c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804750:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804754:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804757:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80475c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804760:	83 c0 01             	add    $0x1,%eax
  804763:	88 45 ef             	mov    %al,-0x11(%rbp)
  804766:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80476a:	0f 86 16 ff ff ff    	jbe    804686 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804770:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804779:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80477c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804783:	00 00 00 
}
  804786:	c9                   	leaveq 
  804787:	c3                   	retq   

0000000000804788 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804788:	55                   	push   %rbp
  804789:	48 89 e5             	mov    %rsp,%rbp
  80478c:	48 83 ec 08          	sub    $0x8,%rsp
  804790:	89 f8                	mov    %edi,%eax
  804792:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804796:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80479a:	c1 e0 08             	shl    $0x8,%eax
  80479d:	89 c2                	mov    %eax,%edx
  80479f:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8047a3:	66 c1 e8 08          	shr    $0x8,%ax
  8047a7:	09 d0                	or     %edx,%eax
}
  8047a9:	c9                   	leaveq 
  8047aa:	c3                   	retq   

00000000008047ab <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8047ab:	55                   	push   %rbp
  8047ac:	48 89 e5             	mov    %rsp,%rbp
  8047af:	48 83 ec 08          	sub    $0x8,%rsp
  8047b3:	89 f8                	mov    %edi,%eax
  8047b5:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8047b9:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8047bd:	89 c7                	mov    %eax,%edi
  8047bf:	48 b8 88 47 80 00 00 	movabs $0x804788,%rax
  8047c6:	00 00 00 
  8047c9:	ff d0                	callq  *%rax
}
  8047cb:	c9                   	leaveq 
  8047cc:	c3                   	retq   

00000000008047cd <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8047cd:	55                   	push   %rbp
  8047ce:	48 89 e5             	mov    %rsp,%rbp
  8047d1:	48 83 ec 08          	sub    $0x8,%rsp
  8047d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8047d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047db:	c1 e0 18             	shl    $0x18,%eax
  8047de:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8047e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047e3:	25 00 ff 00 00       	and    $0xff00,%eax
  8047e8:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8047eb:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8047ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f0:	25 00 00 ff 00       	and    $0xff0000,%eax
  8047f5:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8047f9:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8047fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047fe:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804801:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  804803:	c9                   	leaveq 
  804804:	c3                   	retq   

0000000000804805 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804805:	55                   	push   %rbp
  804806:	48 89 e5             	mov    %rsp,%rbp
  804809:	48 83 ec 08          	sub    $0x8,%rsp
  80480d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804810:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804813:	89 c7                	mov    %eax,%edi
  804815:	48 b8 cd 47 80 00 00 	movabs $0x8047cd,%rax
  80481c:	00 00 00 
  80481f:	ff d0                	callq  *%rax
}
  804821:	c9                   	leaveq 
  804822:	c3                   	retq   
