
obj/user/echosrv:     file format elf64-x86-64


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

0000000000800043 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

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
  800056:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	90                   	nop
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <handle_client>:

void
handle_client(int sock)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 40          	sub    $0x40,%rsp
  800088:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800092:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800096:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800099:	ba 20 00 00 00       	mov    $0x20,%edx
  80009e:	48 89 ce             	mov    %rcx,%rsi
  8000a1:	89 c7                	mov    %eax,%edi
  8000a3:	48 b8 e3 23 80 00 00 	movabs $0x8023e3,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b6:	0f 89 8d 00 00 00    	jns    800149 <handle_client+0xc9>
		die("Failed to receive initial bytes from client");
  8000bc:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  8000c3:	00 00 00 
  8000c6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000d2:	eb 75                	jmp    800149 <handle_client+0xc9>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d7:	48 63 d0             	movslq %eax,%rdx
  8000da:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000de:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000e1:	48 89 ce             	mov    %rcx,%rsi
  8000e4:	89 c7                	mov    %eax,%edi
  8000e6:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax
  8000f2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f5:	74 16                	je     80010d <handle_client+0x8d>
			die("Failed to send bytes to client");
  8000f7:	48 bf 18 48 80 00 00 	movabs $0x804818,%rdi
  8000fe:	00 00 00 
  800101:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80010d:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800111:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800114:	ba 20 00 00 00       	mov    $0x20,%edx
  800119:	48 89 ce             	mov    %rcx,%rsi
  80011c:	89 c7                	mov    %eax,%edi
  80011e:	48 b8 e3 23 80 00 00 	movabs $0x8023e3,%rax
  800125:	00 00 00 
  800128:	ff d0                	callq  *%rax
  80012a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800131:	79 16                	jns    800149 <handle_client+0xc9>
			die("Failed to receive additional bytes from client");
  800133:	48 bf 38 48 80 00 00 	movabs $0x804838,%rdi
  80013a:	00 00 00 
  80013d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800144:	00 00 00 
  800147:	ff d0                	callq  *%rax
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014d:	7f 85                	jg     8000d4 <handle_client+0x54>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80014f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800152:	89 c7                	mov    %eax,%edi
  800154:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
}
  800160:	90                   	nop
  800161:	c9                   	leaveq 
  800162:	c3                   	retq   

0000000000800163 <umain>:

void
umain(int argc, char **argv)
{
  800163:	55                   	push   %rbp
  800164:	48 89 e5             	mov    %rsp,%rbp
  800167:	48 83 ec 70          	sub    $0x70,%rsp
  80016b:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  80016e:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800179:	ba 06 00 00 00       	mov    $0x6,%edx
  80017e:	be 01 00 00 00       	mov    $0x1,%esi
  800183:	bf 02 00 00 00       	mov    $0x2,%edi
  800188:	48 b8 70 32 80 00 00 	movabs $0x803270,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
  800194:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800197:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80019b:	79 16                	jns    8001b3 <umain+0x50>
		die("Failed to create socket");
  80019d:	48 bf 67 48 80 00 00 	movabs $0x804867,%rdi
  8001a4:	00 00 00 
  8001a7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001b3:	48 bf 7f 48 80 00 00 	movabs $0x80487f,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  8001c9:	00 00 00 
  8001cc:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001ce:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001d2:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d7:	be 00 00 00 00       	mov    $0x0,%esi
  8001dc:	48 89 c7             	mov    %rax,%rdi
  8001df:	48 b8 34 13 80 00 00 	movabs $0x801334,%rax
  8001e6:	00 00 00 
  8001e9:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001eb:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f4:	48 b8 72 47 80 00 00 	movabs $0x804772,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
  800200:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  800203:	bf 07 00 00 00       	mov    $0x7,%edi
  800208:	48 b8 2d 47 80 00 00 	movabs $0x80472d,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
  800214:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800218:	48 bf 8e 48 80 00 00 	movabs $0x80488e,%rdi
  80021f:	00 00 00 
  800222:	b8 00 00 00 00       	mov    $0x0,%eax
  800227:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  80022e:	00 00 00 
  800231:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800233:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800237:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80023a:	ba 10 00 00 00       	mov    $0x10,%edx
  80023f:	48 89 ce             	mov    %rcx,%rsi
  800242:	89 c7                	mov    %eax,%edi
  800244:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
  800250:	85 c0                	test   %eax,%eax
  800252:	79 16                	jns    80026a <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800254:	48 bf a0 48 80 00 00 	movabs $0x8048a0,%rdi
  80025b:	00 00 00 
  80025e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800265:	00 00 00 
  800268:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80026a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80026d:	be 05 00 00 00       	mov    $0x5,%esi
  800272:	89 c7                	mov    %eax,%edi
  800274:	48 b8 83 31 80 00 00 	movabs $0x803183,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
  800280:	85 c0                	test   %eax,%eax
  800282:	79 16                	jns    80029a <umain+0x137>
		die("Failed to listen on server socket");
  800284:	48 bf c8 48 80 00 00 	movabs $0x8048c8,%rdi
  80028b:	00 00 00 
  80028e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax

	cprintf("bound\n");
  80029a:	48 bf ea 48 80 00 00 	movabs $0x8048ea,%rdi
  8002a1:	00 00 00 
  8002a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a9:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  8002b0:	00 00 00 
  8002b3:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8002b5:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
  8002bc:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
  8002c0:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8002c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c7:	48 89 ce             	mov    %rcx,%rsi
  8002ca:	89 c7                	mov    %eax,%edi
  8002cc:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
  8002d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002db:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002df:	79 16                	jns    8002f7 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002e1:	48 bf f8 48 80 00 00 	movabs $0x8048f8,%rdi
  8002e8:	00 00 00 
  8002eb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002f2:	00 00 00 
  8002f5:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002fa:	89 c7                	mov    %eax,%edi
  8002fc:	48 b8 fb 45 80 00 00 	movabs $0x8045fb,%rax
  800303:	00 00 00 
  800306:	ff d0                	callq  *%rax
  800308:	48 89 c6             	mov    %rax,%rsi
  80030b:	48 bf 1b 49 80 00 00 	movabs $0x80491b,%rdi
  800312:	00 00 00 
  800315:	b8 00 00 00 00       	mov    $0x0,%eax
  80031a:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  800321:	00 00 00 
  800324:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800326:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800329:	89 c7                	mov    %eax,%edi
  80032b:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  800332:	00 00 00 
  800335:	ff d0                	callq  *%rax
	}
  800337:	e9 79 ff ff ff       	jmpq   8002b5 <umain+0x152>

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
  80034b:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  800352:	00 00 00 
  800355:	ff d0                	callq  *%rax
  800357:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035c:	48 98                	cltq   
  80035e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800365:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80036c:	00 00 00 
  80036f:	48 01 c2             	add    %rax,%rdx
  800372:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
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
  8003a5:	48 b8 63 01 80 00 00 	movabs $0x800163,%rax
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
  8003c4:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  8003cb:	00 00 00 
  8003ce:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d5:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8003dc:	00 00 00 
  8003df:	ff d0                	callq  *%rax
}
  8003e1:	90                   	nop
  8003e2:	5d                   	pop    %rbp
  8003e3:	c3                   	retq   

00000000008003e4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
  8003e8:	48 83 ec 10          	sub    $0x10,%rsp
  8003ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f7:	8b 00                	mov    (%rax),%eax
  8003f9:	8d 48 01             	lea    0x1(%rax),%ecx
  8003fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800400:	89 0a                	mov    %ecx,(%rdx)
  800402:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800405:	89 d1                	mov    %edx,%ecx
  800407:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80040b:	48 98                	cltq   
  80040d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800415:	8b 00                	mov    (%rax),%eax
  800417:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041c:	75 2c                	jne    80044a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80041e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800422:	8b 00                	mov    (%rax),%eax
  800424:	48 98                	cltq   
  800426:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042a:	48 83 c2 08          	add    $0x8,%rdx
  80042e:	48 89 c6             	mov    %rax,%rsi
  800431:	48 89 d7             	mov    %rdx,%rdi
  800434:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  80043b:	00 00 00 
  80043e:	ff d0                	callq  *%rax
        b->idx = 0;
  800440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800444:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80044a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044e:	8b 40 04             	mov    0x4(%rax),%eax
  800451:	8d 50 01             	lea    0x1(%rax),%edx
  800454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800458:	89 50 04             	mov    %edx,0x4(%rax)
}
  80045b:	90                   	nop
  80045c:	c9                   	leaveq 
  80045d:	c3                   	retq   

000000000080045e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80045e:	55                   	push   %rbp
  80045f:	48 89 e5             	mov    %rsp,%rbp
  800462:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800469:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800470:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800477:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80047e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800485:	48 8b 0a             	mov    (%rdx),%rcx
  800488:	48 89 08             	mov    %rcx,(%rax)
  80048b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80048f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800493:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800497:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80049b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004a2:	00 00 00 
    b.cnt = 0;
  8004a5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004ac:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004af:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004b6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004bd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004c4:	48 89 c6             	mov    %rax,%rsi
  8004c7:	48 bf e4 03 80 00 00 	movabs $0x8003e4,%rdi
  8004ce:	00 00 00 
  8004d1:	48 b8 a8 08 80 00 00 	movabs $0x8008a8,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004dd:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004e3:	48 98                	cltq   
  8004e5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004ec:	48 83 c2 08          	add    $0x8,%rdx
  8004f0:	48 89 c6             	mov    %rax,%rsi
  8004f3:	48 89 d7             	mov    %rdx,%rdi
  8004f6:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800502:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800508:	c9                   	leaveq 
  800509:	c3                   	retq   

000000000080050a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80050a:	55                   	push   %rbp
  80050b:	48 89 e5             	mov    %rsp,%rbp
  80050e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800515:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80051c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800523:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80052a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800531:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800538:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80053f:	84 c0                	test   %al,%al
  800541:	74 20                	je     800563 <cprintf+0x59>
  800543:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800547:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80054b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80054f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800553:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800557:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80055b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80055f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800563:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80056a:	00 00 00 
  80056d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800574:	00 00 00 
  800577:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800582:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800589:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800590:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800597:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80059e:	48 8b 0a             	mov    (%rdx),%rcx
  8005a1:	48 89 08             	mov    %rcx,(%rax)
  8005a4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005b4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005bb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005c2:	48 89 d6             	mov    %rdx,%rsi
  8005c5:	48 89 c7             	mov    %rax,%rdi
  8005c8:	48 b8 5e 04 80 00 00 	movabs $0x80045e,%rax
  8005cf:	00 00 00 
  8005d2:	ff d0                	callq  *%rax
  8005d4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005da:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005e0:	c9                   	leaveq 
  8005e1:	c3                   	retq   

00000000008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %rbp
  8005e3:	48 89 e5             	mov    %rsp,%rbp
  8005e6:	48 83 ec 30          	sub    $0x30,%rsp
  8005ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005f6:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005f9:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005fd:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800601:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800604:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800608:	77 54                	ja     80065e <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060a:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80060d:	8d 78 ff             	lea    -0x1(%rax),%edi
  800610:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	48 f7 f6             	div    %rsi
  80061f:	49 89 c2             	mov    %rax,%r10
  800622:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800625:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800628:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80062c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800630:	41 89 c9             	mov    %ecx,%r9d
  800633:	41 89 f8             	mov    %edi,%r8d
  800636:	89 d1                	mov    %edx,%ecx
  800638:	4c 89 d2             	mov    %r10,%rdx
  80063b:	48 89 c7             	mov    %rax,%rdi
  80063e:	48 b8 e2 05 80 00 00 	movabs $0x8005e2,%rax
  800645:	00 00 00 
  800648:	ff d0                	callq  *%rax
  80064a:	eb 1c                	jmp    800668 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80064c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800650:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800653:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800657:	48 89 ce             	mov    %rcx,%rsi
  80065a:	89 d7                	mov    %edx,%edi
  80065c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80065e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800662:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800666:	7f e4                	jg     80064c <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800668:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	48 f7 f1             	div    %rcx
  800677:	48 b8 30 4b 80 00 00 	movabs $0x804b30,%rax
  80067e:	00 00 00 
  800681:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800685:	0f be d0             	movsbl %al,%edx
  800688:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80068c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800690:	48 89 ce             	mov    %rcx,%rsi
  800693:	89 d7                	mov    %edx,%edi
  800695:	ff d0                	callq  *%rax
}
  800697:	90                   	nop
  800698:	c9                   	leaveq 
  800699:	c3                   	retq   

000000000080069a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80069a:	55                   	push   %rbp
  80069b:	48 89 e5             	mov    %rsp,%rbp
  80069e:	48 83 ec 20          	sub    $0x20,%rsp
  8006a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006a9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006ad:	7e 4f                	jle    8006fe <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	83 f8 30             	cmp    $0x30,%eax
  8006b8:	73 24                	jae    8006de <getuint+0x44>
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	89 c0                	mov    %eax,%eax
  8006ca:	48 01 d0             	add    %rdx,%rax
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	8b 12                	mov    (%rdx),%edx
  8006d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	89 0a                	mov    %ecx,(%rdx)
  8006dc:	eb 14                	jmp    8006f2 <getuint+0x58>
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006e6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f2:	48 8b 00             	mov    (%rax),%rax
  8006f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f9:	e9 9d 00 00 00       	jmpq   80079b <getuint+0x101>
	else if (lflag)
  8006fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800702:	74 4c                	je     800750 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	8b 00                	mov    (%rax),%eax
  80070a:	83 f8 30             	cmp    $0x30,%eax
  80070d:	73 24                	jae    800733 <getuint+0x99>
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	89 c0                	mov    %eax,%eax
  80071f:	48 01 d0             	add    %rdx,%rax
  800722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800726:	8b 12                	mov    (%rdx),%edx
  800728:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	89 0a                	mov    %ecx,(%rdx)
  800731:	eb 14                	jmp    800747 <getuint+0xad>
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	48 8b 40 08          	mov    0x8(%rax),%rax
  80073b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80073f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800743:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800747:	48 8b 00             	mov    (%rax),%rax
  80074a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80074e:	eb 4b                	jmp    80079b <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800754:	8b 00                	mov    (%rax),%eax
  800756:	83 f8 30             	cmp    $0x30,%eax
  800759:	73 24                	jae    80077f <getuint+0xe5>
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800767:	8b 00                	mov    (%rax),%eax
  800769:	89 c0                	mov    %eax,%eax
  80076b:	48 01 d0             	add    %rdx,%rax
  80076e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800772:	8b 12                	mov    (%rdx),%edx
  800774:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800777:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077b:	89 0a                	mov    %ecx,(%rdx)
  80077d:	eb 14                	jmp    800793 <getuint+0xf9>
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	48 8b 40 08          	mov    0x8(%rax),%rax
  800787:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800793:	8b 00                	mov    (%rax),%eax
  800795:	89 c0                	mov    %eax,%eax
  800797:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80079b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80079f:	c9                   	leaveq 
  8007a0:	c3                   	retq   

00000000008007a1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007a1:	55                   	push   %rbp
  8007a2:	48 89 e5             	mov    %rsp,%rbp
  8007a5:	48 83 ec 20          	sub    $0x20,%rsp
  8007a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007ad:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007b0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007b4:	7e 4f                	jle    800805 <getint+0x64>
		x=va_arg(*ap, long long);
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	8b 00                	mov    (%rax),%eax
  8007bc:	83 f8 30             	cmp    $0x30,%eax
  8007bf:	73 24                	jae    8007e5 <getint+0x44>
  8007c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cd:	8b 00                	mov    (%rax),%eax
  8007cf:	89 c0                	mov    %eax,%eax
  8007d1:	48 01 d0             	add    %rdx,%rax
  8007d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d8:	8b 12                	mov    (%rdx),%edx
  8007da:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	89 0a                	mov    %ecx,(%rdx)
  8007e3:	eb 14                	jmp    8007f9 <getint+0x58>
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007ed:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f9:	48 8b 00             	mov    (%rax),%rax
  8007fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800800:	e9 9d 00 00 00       	jmpq   8008a2 <getint+0x101>
	else if (lflag)
  800805:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800809:	74 4c                	je     800857 <getint+0xb6>
		x=va_arg(*ap, long);
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	8b 00                	mov    (%rax),%eax
  800811:	83 f8 30             	cmp    $0x30,%eax
  800814:	73 24                	jae    80083a <getint+0x99>
  800816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	8b 00                	mov    (%rax),%eax
  800824:	89 c0                	mov    %eax,%eax
  800826:	48 01 d0             	add    %rdx,%rax
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	8b 12                	mov    (%rdx),%edx
  80082f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	89 0a                	mov    %ecx,(%rdx)
  800838:	eb 14                	jmp    80084e <getint+0xad>
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800842:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800846:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084e:	48 8b 00             	mov    (%rax),%rax
  800851:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800855:	eb 4b                	jmp    8008a2 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	8b 00                	mov    (%rax),%eax
  80085d:	83 f8 30             	cmp    $0x30,%eax
  800860:	73 24                	jae    800886 <getint+0xe5>
  800862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800866:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	8b 00                	mov    (%rax),%eax
  800870:	89 c0                	mov    %eax,%eax
  800872:	48 01 d0             	add    %rdx,%rax
  800875:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800879:	8b 12                	mov    (%rdx),%edx
  80087b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80087e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800882:	89 0a                	mov    %ecx,(%rdx)
  800884:	eb 14                	jmp    80089a <getint+0xf9>
  800886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80088e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800892:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800896:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80089a:	8b 00                	mov    (%rax),%eax
  80089c:	48 98                	cltq   
  80089e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008a6:	c9                   	leaveq 
  8008a7:	c3                   	retq   

00000000008008a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008a8:	55                   	push   %rbp
  8008a9:	48 89 e5             	mov    %rsp,%rbp
  8008ac:	41 54                	push   %r12
  8008ae:	53                   	push   %rbx
  8008af:	48 83 ec 60          	sub    $0x60,%rsp
  8008b3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008b7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008bb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008bf:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008c3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008c7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008cb:	48 8b 0a             	mov    (%rdx),%rcx
  8008ce:	48 89 08             	mov    %rcx,(%rax)
  8008d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e1:	eb 17                	jmp    8008fa <vprintfmt+0x52>
			if (ch == '\0')
  8008e3:	85 db                	test   %ebx,%ebx
  8008e5:	0f 84 b9 04 00 00    	je     800da4 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8008eb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f3:	48 89 d6             	mov    %rdx,%rsi
  8008f6:	89 df                	mov    %ebx,%edi
  8008f8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800902:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800906:	0f b6 00             	movzbl (%rax),%eax
  800909:	0f b6 d8             	movzbl %al,%ebx
  80090c:	83 fb 25             	cmp    $0x25,%ebx
  80090f:	75 d2                	jne    8008e3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800911:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800915:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80091c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800923:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80092a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800931:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800935:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800939:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80093d:	0f b6 00             	movzbl (%rax),%eax
  800940:	0f b6 d8             	movzbl %al,%ebx
  800943:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800946:	83 f8 55             	cmp    $0x55,%eax
  800949:	0f 87 22 04 00 00    	ja     800d71 <vprintfmt+0x4c9>
  80094f:	89 c0                	mov    %eax,%eax
  800951:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800958:	00 
  800959:	48 b8 58 4b 80 00 00 	movabs $0x804b58,%rax
  800960:	00 00 00 
  800963:	48 01 d0             	add    %rdx,%rax
  800966:	48 8b 00             	mov    (%rax),%rax
  800969:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80096b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80096f:	eb c0                	jmp    800931 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800971:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800975:	eb ba                	jmp    800931 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800977:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80097e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	c1 e0 02             	shl    $0x2,%eax
  800986:	01 d0                	add    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d8                	add    %ebx,%eax
  80098c:	83 e8 30             	sub    $0x30,%eax
  80098f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800992:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800996:	0f b6 00             	movzbl (%rax),%eax
  800999:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80099c:	83 fb 2f             	cmp    $0x2f,%ebx
  80099f:	7e 60                	jle    800a01 <vprintfmt+0x159>
  8009a1:	83 fb 39             	cmp    $0x39,%ebx
  8009a4:	7f 5b                	jg     800a01 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ab:	eb d1                	jmp    80097e <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b0:	83 f8 30             	cmp    $0x30,%eax
  8009b3:	73 17                	jae    8009cc <vprintfmt+0x124>
  8009b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bc:	89 d2                	mov    %edx,%edx
  8009be:	48 01 d0             	add    %rdx,%rax
  8009c1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c4:	83 c2 08             	add    $0x8,%edx
  8009c7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ca:	eb 0c                	jmp    8009d8 <vprintfmt+0x130>
  8009cc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009d0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009d4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d8:	8b 00                	mov    (%rax),%eax
  8009da:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009dd:	eb 23                	jmp    800a02 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8009df:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e3:	0f 89 48 ff ff ff    	jns    800931 <vprintfmt+0x89>
				width = 0;
  8009e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009f0:	e9 3c ff ff ff       	jmpq   800931 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009f5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009fc:	e9 30 ff ff ff       	jmpq   800931 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a01:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a06:	0f 89 25 ff ff ff    	jns    800931 <vprintfmt+0x89>
				width = precision, precision = -1;
  800a0c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a0f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a12:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a19:	e9 13 ff ff ff       	jmpq   800931 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a22:	e9 0a ff ff ff       	jmpq   800931 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2a:	83 f8 30             	cmp    $0x30,%eax
  800a2d:	73 17                	jae    800a46 <vprintfmt+0x19e>
  800a2f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a33:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a36:	89 d2                	mov    %edx,%edx
  800a38:	48 01 d0             	add    %rdx,%rax
  800a3b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3e:	83 c2 08             	add    $0x8,%edx
  800a41:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a44:	eb 0c                	jmp    800a52 <vprintfmt+0x1aa>
  800a46:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a4a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a4e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a52:	8b 10                	mov    (%rax),%edx
  800a54:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5c:	48 89 ce             	mov    %rcx,%rsi
  800a5f:	89 d7                	mov    %edx,%edi
  800a61:	ff d0                	callq  *%rax
			break;
  800a63:	e9 37 03 00 00       	jmpq   800d9f <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6b:	83 f8 30             	cmp    $0x30,%eax
  800a6e:	73 17                	jae    800a87 <vprintfmt+0x1df>
  800a70:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a77:	89 d2                	mov    %edx,%edx
  800a79:	48 01 d0             	add    %rdx,%rax
  800a7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7f:	83 c2 08             	add    $0x8,%edx
  800a82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a85:	eb 0c                	jmp    800a93 <vprintfmt+0x1eb>
  800a87:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a8b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a8f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a93:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a95:	85 db                	test   %ebx,%ebx
  800a97:	79 02                	jns    800a9b <vprintfmt+0x1f3>
				err = -err;
  800a99:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a9b:	83 fb 15             	cmp    $0x15,%ebx
  800a9e:	7f 16                	jg     800ab6 <vprintfmt+0x20e>
  800aa0:	48 b8 80 4a 80 00 00 	movabs $0x804a80,%rax
  800aa7:	00 00 00 
  800aaa:	48 63 d3             	movslq %ebx,%rdx
  800aad:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab1:	4d 85 e4             	test   %r12,%r12
  800ab4:	75 2e                	jne    800ae4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ab6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abe:	89 d9                	mov    %ebx,%ecx
  800ac0:	48 ba 41 4b 80 00 00 	movabs $0x804b41,%rdx
  800ac7:	00 00 00 
  800aca:	48 89 c7             	mov    %rax,%rdi
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad2:	49 b8 ae 0d 80 00 00 	movabs $0x800dae,%r8
  800ad9:	00 00 00 
  800adc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800adf:	e9 bb 02 00 00       	jmpq   800d9f <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aec:	4c 89 e1             	mov    %r12,%rcx
  800aef:	48 ba 4a 4b 80 00 00 	movabs $0x804b4a,%rdx
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 ae 0d 80 00 00 	movabs $0x800dae,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
			break;
  800b0e:	e9 8c 02 00 00       	jmpq   800d9f <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b16:	83 f8 30             	cmp    $0x30,%eax
  800b19:	73 17                	jae    800b32 <vprintfmt+0x28a>
  800b1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b22:	89 d2                	mov    %edx,%edx
  800b24:	48 01 d0             	add    %rdx,%rax
  800b27:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2a:	83 c2 08             	add    $0x8,%edx
  800b2d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b30:	eb 0c                	jmp    800b3e <vprintfmt+0x296>
  800b32:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b36:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3e:	4c 8b 20             	mov    (%rax),%r12
  800b41:	4d 85 e4             	test   %r12,%r12
  800b44:	75 0a                	jne    800b50 <vprintfmt+0x2a8>
				p = "(null)";
  800b46:	49 bc 4d 4b 80 00 00 	movabs $0x804b4d,%r12
  800b4d:	00 00 00 
			if (width > 0 && padc != '-')
  800b50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b54:	7e 78                	jle    800bce <vprintfmt+0x326>
  800b56:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b5a:	74 72                	je     800bce <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b5f:	48 98                	cltq   
  800b61:	48 89 c6             	mov    %rax,%rsi
  800b64:	4c 89 e7             	mov    %r12,%rdi
  800b67:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	callq  *%rax
  800b73:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b76:	eb 17                	jmp    800b8f <vprintfmt+0x2e7>
					putch(padc, putdat);
  800b78:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b7c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b84:	48 89 ce             	mov    %rcx,%rsi
  800b87:	89 d7                	mov    %edx,%edi
  800b89:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b93:	7f e3                	jg     800b78 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b95:	eb 37                	jmp    800bce <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b97:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b9b:	74 1e                	je     800bbb <vprintfmt+0x313>
  800b9d:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba0:	7e 05                	jle    800ba7 <vprintfmt+0x2ff>
  800ba2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba5:	7e 14                	jle    800bbb <vprintfmt+0x313>
					putch('?', putdat);
  800ba7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baf:	48 89 d6             	mov    %rdx,%rsi
  800bb2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bb7:	ff d0                	callq  *%rax
  800bb9:	eb 0f                	jmp    800bca <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800bbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc3:	48 89 d6             	mov    %rdx,%rsi
  800bc6:	89 df                	mov    %ebx,%edi
  800bc8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bce:	4c 89 e0             	mov    %r12,%rax
  800bd1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bd5:	0f b6 00             	movzbl (%rax),%eax
  800bd8:	0f be d8             	movsbl %al,%ebx
  800bdb:	85 db                	test   %ebx,%ebx
  800bdd:	74 28                	je     800c07 <vprintfmt+0x35f>
  800bdf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be3:	78 b2                	js     800b97 <vprintfmt+0x2ef>
  800be5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800be9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bed:	79 a8                	jns    800b97 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bef:	eb 16                	jmp    800c07 <vprintfmt+0x35f>
				putch(' ', putdat);
  800bf1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf9:	48 89 d6             	mov    %rdx,%rsi
  800bfc:	bf 20 00 00 00       	mov    $0x20,%edi
  800c01:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c0b:	7f e4                	jg     800bf1 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800c0d:	e9 8d 01 00 00       	jmpq   800d9f <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c16:	be 03 00 00 00       	mov    $0x3,%esi
  800c1b:	48 89 c7             	mov    %rax,%rdi
  800c1e:	48 b8 a1 07 80 00 00 	movabs $0x8007a1,%rax
  800c25:	00 00 00 
  800c28:	ff d0                	callq  *%rax
  800c2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c32:	48 85 c0             	test   %rax,%rax
  800c35:	79 1d                	jns    800c54 <vprintfmt+0x3ac>
				putch('-', putdat);
  800c37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3f:	48 89 d6             	mov    %rdx,%rsi
  800c42:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c47:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4d:	48 f7 d8             	neg    %rax
  800c50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c54:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c5b:	e9 d2 00 00 00       	jmpq   800d32 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c64:	be 03 00 00 00       	mov    $0x3,%esi
  800c69:	48 89 c7             	mov    %rax,%rdi
  800c6c:	48 b8 9a 06 80 00 00 	movabs $0x80069a,%rax
  800c73:	00 00 00 
  800c76:	ff d0                	callq  *%rax
  800c78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c7c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c83:	e9 aa 00 00 00       	jmpq   800d32 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800c88:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c8c:	be 03 00 00 00       	mov    $0x3,%esi
  800c91:	48 89 c7             	mov    %rax,%rdi
  800c94:	48 b8 9a 06 80 00 00 	movabs $0x80069a,%rax
  800c9b:	00 00 00 
  800c9e:	ff d0                	callq  *%rax
  800ca0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ca4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cab:	e9 82 00 00 00       	jmpq   800d32 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800cb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb8:	48 89 d6             	mov    %rdx,%rsi
  800cbb:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc0:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cca:	48 89 d6             	mov    %rdx,%rsi
  800ccd:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd7:	83 f8 30             	cmp    $0x30,%eax
  800cda:	73 17                	jae    800cf3 <vprintfmt+0x44b>
  800cdc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce3:	89 d2                	mov    %edx,%edx
  800ce5:	48 01 d0             	add    %rdx,%rax
  800ce8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ceb:	83 c2 08             	add    $0x8,%edx
  800cee:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf1:	eb 0c                	jmp    800cff <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800cf3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cf7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cfb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cff:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d06:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d0d:	eb 23                	jmp    800d32 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d13:	be 03 00 00 00       	mov    $0x3,%esi
  800d18:	48 89 c7             	mov    %rax,%rdi
  800d1b:	48 b8 9a 06 80 00 00 	movabs $0x80069a,%rax
  800d22:	00 00 00 
  800d25:	ff d0                	callq  *%rax
  800d27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d2b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d32:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d37:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d3a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d49:	45 89 c1             	mov    %r8d,%r9d
  800d4c:	41 89 f8             	mov    %edi,%r8d
  800d4f:	48 89 c7             	mov    %rax,%rdi
  800d52:	48 b8 e2 05 80 00 00 	movabs $0x8005e2,%rax
  800d59:	00 00 00 
  800d5c:	ff d0                	callq  *%rax
			break;
  800d5e:	eb 3f                	jmp    800d9f <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d68:	48 89 d6             	mov    %rdx,%rsi
  800d6b:	89 df                	mov    %ebx,%edi
  800d6d:	ff d0                	callq  *%rax
			break;
  800d6f:	eb 2e                	jmp    800d9f <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d79:	48 89 d6             	mov    %rdx,%rsi
  800d7c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d81:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d83:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d88:	eb 05                	jmp    800d8f <vprintfmt+0x4e7>
  800d8a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d8f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d93:	48 83 e8 01          	sub    $0x1,%rax
  800d97:	0f b6 00             	movzbl (%rax),%eax
  800d9a:	3c 25                	cmp    $0x25,%al
  800d9c:	75 ec                	jne    800d8a <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d9e:	90                   	nop
		}
	}
  800d9f:	e9 3d fb ff ff       	jmpq   8008e1 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800da4:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800da5:	48 83 c4 60          	add    $0x60,%rsp
  800da9:	5b                   	pop    %rbx
  800daa:	41 5c                	pop    %r12
  800dac:	5d                   	pop    %rbp
  800dad:	c3                   	retq   

0000000000800dae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dae:	55                   	push   %rbp
  800daf:	48 89 e5             	mov    %rsp,%rbp
  800db2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800db9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dc0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dc7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800dce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de3:	84 c0                	test   %al,%al
  800de5:	74 20                	je     800e07 <printfmt+0x59>
  800de7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800deb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800def:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e03:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e07:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e0e:	00 00 00 
  800e11:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e18:	00 00 00 
  800e1b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e1f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e26:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e2d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e34:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e3b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e42:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e49:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e50:	48 89 c7             	mov    %rax,%rdi
  800e53:	48 b8 a8 08 80 00 00 	movabs $0x8008a8,%rax
  800e5a:	00 00 00 
  800e5d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e5f:	90                   	nop
  800e60:	c9                   	leaveq 
  800e61:	c3                   	retq   

0000000000800e62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e62:	55                   	push   %rbp
  800e63:	48 89 e5             	mov    %rsp,%rbp
  800e66:	48 83 ec 10          	sub    $0x10,%rsp
  800e6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e75:	8b 40 10             	mov    0x10(%rax),%eax
  800e78:	8d 50 01             	lea    0x1(%rax),%edx
  800e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e86:	48 8b 10             	mov    (%rax),%rdx
  800e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e91:	48 39 c2             	cmp    %rax,%rdx
  800e94:	73 17                	jae    800ead <sprintputch+0x4b>
		*b->buf++ = ch;
  800e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9a:	48 8b 00             	mov    (%rax),%rax
  800e9d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ea1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ea5:	48 89 0a             	mov    %rcx,(%rdx)
  800ea8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eab:	88 10                	mov    %dl,(%rax)
}
  800ead:	90                   	nop
  800eae:	c9                   	leaveq 
  800eaf:	c3                   	retq   

0000000000800eb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eb0:	55                   	push   %rbp
  800eb1:	48 89 e5             	mov    %rsp,%rbp
  800eb4:	48 83 ec 50          	sub    $0x50,%rsp
  800eb8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ebc:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ebf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ec3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ec7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ecb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ecf:	48 8b 0a             	mov    (%rdx),%rcx
  800ed2:	48 89 08             	mov    %rcx,(%rax)
  800ed5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800edd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eed:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ef0:	48 98                	cltq   
  800ef2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ef6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800efa:	48 01 d0             	add    %rdx,%rax
  800efd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f01:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f08:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f0d:	74 06                	je     800f15 <vsnprintf+0x65>
  800f0f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f13:	7f 07                	jg     800f1c <vsnprintf+0x6c>
		return -E_INVAL;
  800f15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1a:	eb 2f                	jmp    800f4b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f1c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f20:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f24:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f28:	48 89 c6             	mov    %rax,%rsi
  800f2b:	48 bf 62 0e 80 00 00 	movabs $0x800e62,%rdi
  800f32:	00 00 00 
  800f35:	48 b8 a8 08 80 00 00 	movabs $0x8008a8,%rax
  800f3c:	00 00 00 
  800f3f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f45:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f48:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f4b:	c9                   	leaveq 
  800f4c:	c3                   	retq   

0000000000800f4d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f4d:	55                   	push   %rbp
  800f4e:	48 89 e5             	mov    %rsp,%rbp
  800f51:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f58:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f5f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f65:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800f6c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f73:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f7a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f81:	84 c0                	test   %al,%al
  800f83:	74 20                	je     800fa5 <snprintf+0x58>
  800f85:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f89:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f8d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f91:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f95:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f99:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f9d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fa5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fac:	00 00 00 
  800faf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fb6:	00 00 00 
  800fb9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fbd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fc4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fcb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fd2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fd9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fe0:	48 8b 0a             	mov    (%rdx),%rcx
  800fe3:	48 89 08             	mov    %rcx,(%rax)
  800fe6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fea:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fee:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ff6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ffd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801004:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80100a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801011:	48 89 c7             	mov    %rax,%rdi
  801014:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	callq  *%rax
  801020:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801026:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80102c:	c9                   	leaveq 
  80102d:	c3                   	retq   

000000000080102e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80102e:	55                   	push   %rbp
  80102f:	48 89 e5             	mov    %rsp,%rbp
  801032:	48 83 ec 18          	sub    $0x18,%rsp
  801036:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80103a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801041:	eb 09                	jmp    80104c <strlen+0x1e>
		n++;
  801043:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801047:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801050:	0f b6 00             	movzbl (%rax),%eax
  801053:	84 c0                	test   %al,%al
  801055:	75 ec                	jne    801043 <strlen+0x15>
		n++;
	return n;
  801057:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80105a:	c9                   	leaveq 
  80105b:	c3                   	retq   

000000000080105c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 20          	sub    $0x20,%rsp
  801064:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801068:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801073:	eb 0e                	jmp    801083 <strnlen+0x27>
		n++;
  801075:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801079:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801083:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801088:	74 0b                	je     801095 <strnlen+0x39>
  80108a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108e:	0f b6 00             	movzbl (%rax),%eax
  801091:	84 c0                	test   %al,%al
  801093:	75 e0                	jne    801075 <strnlen+0x19>
		n++;
	return n;
  801095:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801098:	c9                   	leaveq 
  801099:	c3                   	retq   

000000000080109a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80109a:	55                   	push   %rbp
  80109b:	48 89 e5             	mov    %rsp,%rbp
  80109e:	48 83 ec 20          	sub    $0x20,%rsp
  8010a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010b2:	90                   	nop
  8010b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010bf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010c7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010cb:	0f b6 12             	movzbl (%rdx),%edx
  8010ce:	88 10                	mov    %dl,(%rax)
  8010d0:	0f b6 00             	movzbl (%rax),%eax
  8010d3:	84 c0                	test   %al,%al
  8010d5:	75 dc                	jne    8010b3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010db:	c9                   	leaveq 
  8010dc:	c3                   	retq   

00000000008010dd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010dd:	55                   	push   %rbp
  8010de:	48 89 e5             	mov    %rsp,%rbp
  8010e1:	48 83 ec 20          	sub    $0x20,%rsp
  8010e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f1:	48 89 c7             	mov    %rax,%rdi
  8010f4:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  8010fb:	00 00 00 
  8010fe:	ff d0                	callq  *%rax
  801100:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801106:	48 63 d0             	movslq %eax,%rdx
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 01 c2             	add    %rax,%rdx
  801110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801114:	48 89 c6             	mov    %rax,%rsi
  801117:	48 89 d7             	mov    %rdx,%rdi
  80111a:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  801121:	00 00 00 
  801124:	ff d0                	callq  *%rax
	return dst;
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80112a:	c9                   	leaveq 
  80112b:	c3                   	retq   

000000000080112c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80112c:	55                   	push   %rbp
  80112d:	48 89 e5             	mov    %rsp,%rbp
  801130:	48 83 ec 28          	sub    $0x28,%rsp
  801134:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801138:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801140:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801144:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801148:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80114f:	00 
  801150:	eb 2a                	jmp    80117c <strncpy+0x50>
		*dst++ = *src;
  801152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801156:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801162:	0f b6 12             	movzbl (%rdx),%edx
  801165:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801167:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116b:	0f b6 00             	movzbl (%rax),%eax
  80116e:	84 c0                	test   %al,%al
  801170:	74 05                	je     801177 <strncpy+0x4b>
			src++;
  801172:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801177:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801180:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801184:	72 cc                	jb     801152 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80118a:	c9                   	leaveq 
  80118b:	c3                   	retq   

000000000080118c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80118c:	55                   	push   %rbp
  80118d:	48 89 e5             	mov    %rsp,%rbp
  801190:	48 83 ec 28          	sub    $0x28,%rsp
  801194:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801198:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80119c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ad:	74 3d                	je     8011ec <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011af:	eb 1d                	jmp    8011ce <strlcpy+0x42>
			*dst++ = *src++;
  8011b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011c5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011c9:	0f b6 12             	movzbl (%rdx),%edx
  8011cc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ce:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011d8:	74 0b                	je     8011e5 <strlcpy+0x59>
  8011da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011de:	0f b6 00             	movzbl (%rax),%eax
  8011e1:	84 c0                	test   %al,%al
  8011e3:	75 cc                	jne    8011b1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	48 29 c2             	sub    %rax,%rdx
  8011f7:	48 89 d0             	mov    %rdx,%rax
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 10          	sub    $0x10,%rsp
  801204:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801208:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80120c:	eb 0a                	jmp    801218 <strcmp+0x1c>
		p++, q++;
  80120e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801213:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121c:	0f b6 00             	movzbl (%rax),%eax
  80121f:	84 c0                	test   %al,%al
  801221:	74 12                	je     801235 <strcmp+0x39>
  801223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801227:	0f b6 10             	movzbl (%rax),%edx
  80122a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	38 c2                	cmp    %al,%dl
  801233:	74 d9                	je     80120e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	0f b6 d0             	movzbl %al,%edx
  80123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	0f b6 c0             	movzbl %al,%eax
  801249:	29 c2                	sub    %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
}
  80124d:	c9                   	leaveq 
  80124e:	c3                   	retq   

000000000080124f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80124f:	55                   	push   %rbp
  801250:	48 89 e5             	mov    %rsp,%rbp
  801253:	48 83 ec 18          	sub    $0x18,%rsp
  801257:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80125f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801263:	eb 0f                	jmp    801274 <strncmp+0x25>
		n--, p++, q++;
  801265:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80126a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801274:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801279:	74 1d                	je     801298 <strncmp+0x49>
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	84 c0                	test   %al,%al
  801284:	74 12                	je     801298 <strncmp+0x49>
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128a:	0f b6 10             	movzbl (%rax),%edx
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	0f b6 00             	movzbl (%rax),%eax
  801294:	38 c2                	cmp    %al,%dl
  801296:	74 cd                	je     801265 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801298:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80129d:	75 07                	jne    8012a6 <strncmp+0x57>
		return 0;
  80129f:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a4:	eb 18                	jmp    8012be <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012aa:	0f b6 00             	movzbl (%rax),%eax
  8012ad:	0f b6 d0             	movzbl %al,%edx
  8012b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b4:	0f b6 00             	movzbl (%rax),%eax
  8012b7:	0f b6 c0             	movzbl %al,%eax
  8012ba:	29 c2                	sub    %eax,%edx
  8012bc:	89 d0                	mov    %edx,%eax
}
  8012be:	c9                   	leaveq 
  8012bf:	c3                   	retq   

00000000008012c0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c0:	55                   	push   %rbp
  8012c1:	48 89 e5             	mov    %rsp,%rbp
  8012c4:	48 83 ec 10          	sub    $0x10,%rsp
  8012c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cc:	89 f0                	mov    %esi,%eax
  8012ce:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d1:	eb 17                	jmp    8012ea <strchr+0x2a>
		if (*s == c)
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012dd:	75 06                	jne    8012e5 <strchr+0x25>
			return (char *) s;
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	eb 15                	jmp    8012fa <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 00             	movzbl (%rax),%eax
  8012f1:	84 c0                	test   %al,%al
  8012f3:	75 de                	jne    8012d3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fa:	c9                   	leaveq 
  8012fb:	c3                   	retq   

00000000008012fc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012fc:	55                   	push   %rbp
  8012fd:	48 89 e5             	mov    %rsp,%rbp
  801300:	48 83 ec 10          	sub    $0x10,%rsp
  801304:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801308:	89 f0                	mov    %esi,%eax
  80130a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80130d:	eb 11                	jmp    801320 <strfind+0x24>
		if (*s == c)
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801319:	74 12                	je     80132d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80131b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801324:	0f b6 00             	movzbl (%rax),%eax
  801327:	84 c0                	test   %al,%al
  801329:	75 e4                	jne    80130f <strfind+0x13>
  80132b:	eb 01                	jmp    80132e <strfind+0x32>
		if (*s == c)
			break;
  80132d:	90                   	nop
	return (char *) s;
  80132e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801332:	c9                   	leaveq 
  801333:	c3                   	retq   

0000000000801334 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801334:	55                   	push   %rbp
  801335:	48 89 e5             	mov    %rsp,%rbp
  801338:	48 83 ec 18          	sub    $0x18,%rsp
  80133c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801340:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801343:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801347:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134c:	75 06                	jne    801354 <memset+0x20>
		return v;
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	eb 69                	jmp    8013bd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801358:	83 e0 03             	and    $0x3,%eax
  80135b:	48 85 c0             	test   %rax,%rax
  80135e:	75 48                	jne    8013a8 <memset+0x74>
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	83 e0 03             	and    $0x3,%eax
  801367:	48 85 c0             	test   %rax,%rax
  80136a:	75 3c                	jne    8013a8 <memset+0x74>
		c &= 0xFF;
  80136c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801373:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801376:	c1 e0 18             	shl    $0x18,%eax
  801379:	89 c2                	mov    %eax,%edx
  80137b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137e:	c1 e0 10             	shl    $0x10,%eax
  801381:	09 c2                	or     %eax,%edx
  801383:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801386:	c1 e0 08             	shl    $0x8,%eax
  801389:	09 d0                	or     %edx,%eax
  80138b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801392:	48 c1 e8 02          	shr    $0x2,%rax
  801396:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801399:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a0:	48 89 d7             	mov    %rdx,%rdi
  8013a3:	fc                   	cld    
  8013a4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013a6:	eb 11                	jmp    8013b9 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013af:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013b3:	48 89 d7             	mov    %rdx,%rdi
  8013b6:	fc                   	cld    
  8013b7:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013bd:	c9                   	leaveq 
  8013be:	c3                   	retq   

00000000008013bf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 83 ec 28          	sub    $0x28,%rsp
  8013c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013eb:	0f 83 88 00 00 00    	jae    801479 <memmove+0xba>
  8013f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	48 01 d0             	add    %rdx,%rax
  8013fc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801400:	76 77                	jbe    801479 <memmove+0xba>
		s += n;
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801416:	83 e0 03             	and    $0x3,%eax
  801419:	48 85 c0             	test   %rax,%rax
  80141c:	75 3b                	jne    801459 <memmove+0x9a>
  80141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801422:	83 e0 03             	and    $0x3,%eax
  801425:	48 85 c0             	test   %rax,%rax
  801428:	75 2f                	jne    801459 <memmove+0x9a>
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	83 e0 03             	and    $0x3,%eax
  801431:	48 85 c0             	test   %rax,%rax
  801434:	75 23                	jne    801459 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143a:	48 83 e8 04          	sub    $0x4,%rax
  80143e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801442:	48 83 ea 04          	sub    $0x4,%rdx
  801446:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80144e:	48 89 c7             	mov    %rax,%rdi
  801451:	48 89 d6             	mov    %rdx,%rsi
  801454:	fd                   	std    
  801455:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801457:	eb 1d                	jmp    801476 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801465:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801469:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146d:	48 89 d7             	mov    %rdx,%rdi
  801470:	48 89 c1             	mov    %rax,%rcx
  801473:	fd                   	std    
  801474:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801476:	fc                   	cld    
  801477:	eb 57                	jmp    8014d0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147d:	83 e0 03             	and    $0x3,%eax
  801480:	48 85 c0             	test   %rax,%rax
  801483:	75 36                	jne    8014bb <memmove+0xfc>
  801485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801489:	83 e0 03             	and    $0x3,%eax
  80148c:	48 85 c0             	test   %rax,%rax
  80148f:	75 2a                	jne    8014bb <memmove+0xfc>
  801491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801495:	83 e0 03             	and    $0x3,%eax
  801498:	48 85 c0             	test   %rax,%rax
  80149b:	75 1e                	jne    8014bb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	48 c1 e8 02          	shr    $0x2,%rax
  8014a5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b0:	48 89 c7             	mov    %rax,%rdi
  8014b3:	48 89 d6             	mov    %rdx,%rsi
  8014b6:	fc                   	cld    
  8014b7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014b9:	eb 15                	jmp    8014d0 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014c7:	48 89 c7             	mov    %rax,%rdi
  8014ca:	48 89 d6             	mov    %rdx,%rsi
  8014cd:	fc                   	cld    
  8014ce:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d4:	c9                   	leaveq 
  8014d5:	c3                   	retq   

00000000008014d6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d6:	55                   	push   %rbp
  8014d7:	48 89 e5             	mov    %rsp,%rbp
  8014da:	48 83 ec 18          	sub    $0x18,%rsp
  8014de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ee:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	48 89 ce             	mov    %rcx,%rsi
  8014f9:	48 89 c7             	mov    %rax,%rdi
  8014fc:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  801503:	00 00 00 
  801506:	ff d0                	callq  *%rax
}
  801508:	c9                   	leaveq 
  801509:	c3                   	retq   

000000000080150a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80150a:	55                   	push   %rbp
  80150b:	48 89 e5             	mov    %rsp,%rbp
  80150e:	48 83 ec 28          	sub    $0x28,%rsp
  801512:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801516:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80151e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801522:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801526:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80152a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80152e:	eb 36                	jmp    801566 <memcmp+0x5c>
		if (*s1 != *s2)
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801534:	0f b6 10             	movzbl (%rax),%edx
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	38 c2                	cmp    %al,%dl
  801540:	74 1a                	je     80155c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801542:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801546:	0f b6 00             	movzbl (%rax),%eax
  801549:	0f b6 d0             	movzbl %al,%edx
  80154c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801550:	0f b6 00             	movzbl (%rax),%eax
  801553:	0f b6 c0             	movzbl %al,%eax
  801556:	29 c2                	sub    %eax,%edx
  801558:	89 d0                	mov    %edx,%eax
  80155a:	eb 20                	jmp    80157c <memcmp+0x72>
		s1++, s2++;
  80155c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801561:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80156e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801572:	48 85 c0             	test   %rax,%rax
  801575:	75 b9                	jne    801530 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157c:	c9                   	leaveq 
  80157d:	c3                   	retq   

000000000080157e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80157e:	55                   	push   %rbp
  80157f:	48 89 e5             	mov    %rsp,%rbp
  801582:	48 83 ec 28          	sub    $0x28,%rsp
  801586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80158a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80158d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801591:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	48 01 d0             	add    %rdx,%rax
  80159c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015a0:	eb 19                	jmp    8015bb <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	0f b6 d0             	movzbl %al,%edx
  8015ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015af:	0f b6 c0             	movzbl %al,%eax
  8015b2:	39 c2                	cmp    %eax,%edx
  8015b4:	74 11                	je     8015c7 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015c3:	72 dd                	jb     8015a2 <memfind+0x24>
  8015c5:	eb 01                	jmp    8015c8 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015c7:	90                   	nop
	return (void *) s;
  8015c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015cc:	c9                   	leaveq 
  8015cd:	c3                   	retq   

00000000008015ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ce:	55                   	push   %rbp
  8015cf:	48 89 e5             	mov    %rsp,%rbp
  8015d2:	48 83 ec 38          	sub    $0x38,%rsp
  8015d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015de:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015e8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015ef:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f0:	eb 05                	jmp    8015f7 <strtol+0x29>
		s++;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 20                	cmp    $0x20,%al
  801600:	74 f0                	je     8015f2 <strtol+0x24>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 09                	cmp    $0x9,%al
  80160b:	74 e5                	je     8015f2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 2b                	cmp    $0x2b,%al
  801616:	75 07                	jne    80161f <strtol+0x51>
		s++;
  801618:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161d:	eb 17                	jmp    801636 <strtol+0x68>
	else if (*s == '-')
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 2d                	cmp    $0x2d,%al
  801628:	75 0c                	jne    801636 <strtol+0x68>
		s++, neg = 1;
  80162a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801636:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163a:	74 06                	je     801642 <strtol+0x74>
  80163c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801640:	75 28                	jne    80166a <strtol+0x9c>
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	3c 30                	cmp    $0x30,%al
  80164b:	75 1d                	jne    80166a <strtol+0x9c>
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	48 83 c0 01          	add    $0x1,%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 78                	cmp    $0x78,%al
  80165a:	75 0e                	jne    80166a <strtol+0x9c>
		s += 2, base = 16;
  80165c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801661:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801668:	eb 2c                	jmp    801696 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80166a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166e:	75 19                	jne    801689 <strtol+0xbb>
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	3c 30                	cmp    $0x30,%al
  801679:	75 0e                	jne    801689 <strtol+0xbb>
		s++, base = 8;
  80167b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801680:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801687:	eb 0d                	jmp    801696 <strtol+0xc8>
	else if (base == 0)
  801689:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168d:	75 07                	jne    801696 <strtol+0xc8>
		base = 10;
  80168f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 2f                	cmp    $0x2f,%al
  80169f:	7e 1d                	jle    8016be <strtol+0xf0>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 39                	cmp    $0x39,%al
  8016aa:	7f 12                	jg     8016be <strtol+0xf0>
			dig = *s - '0';
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	0f be c0             	movsbl %al,%eax
  8016b6:	83 e8 30             	sub    $0x30,%eax
  8016b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016bc:	eb 4e                	jmp    80170c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 60                	cmp    $0x60,%al
  8016c7:	7e 1d                	jle    8016e6 <strtol+0x118>
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 7a                	cmp    $0x7a,%al
  8016d2:	7f 12                	jg     8016e6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	0f be c0             	movsbl %al,%eax
  8016de:	83 e8 57             	sub    $0x57,%eax
  8016e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e4:	eb 26                	jmp    80170c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 40                	cmp    $0x40,%al
  8016ef:	7e 47                	jle    801738 <strtol+0x16a>
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	3c 5a                	cmp    $0x5a,%al
  8016fa:	7f 3c                	jg     801738 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	0f be c0             	movsbl %al,%eax
  801706:	83 e8 37             	sub    $0x37,%eax
  801709:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80170c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801712:	7d 23                	jge    801737 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801714:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801719:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80171c:	48 98                	cltq   
  80171e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801723:	48 89 c2             	mov    %rax,%rdx
  801726:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801729:	48 98                	cltq   
  80172b:	48 01 d0             	add    %rdx,%rax
  80172e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801732:	e9 5f ff ff ff       	jmpq   801696 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801737:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801738:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80173d:	74 0b                	je     80174a <strtol+0x17c>
		*endptr = (char *) s;
  80173f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801743:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801747:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80174a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80174e:	74 09                	je     801759 <strtol+0x18b>
  801750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801754:	48 f7 d8             	neg    %rax
  801757:	eb 04                	jmp    80175d <strtol+0x18f>
  801759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80175d:	c9                   	leaveq 
  80175e:	c3                   	retq   

000000000080175f <strstr>:

char * strstr(const char *in, const char *str)
{
  80175f:	55                   	push   %rbp
  801760:	48 89 e5             	mov    %rsp,%rbp
  801763:	48 83 ec 30          	sub    $0x30,%rsp
  801767:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80176b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80176f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801773:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801777:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801781:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801785:	75 06                	jne    80178d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801787:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178b:	eb 6b                	jmp    8017f8 <strstr+0x99>

	len = strlen(str);
  80178d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801791:	48 89 c7             	mov    %rax,%rdi
  801794:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  80179b:	00 00 00 
  80179e:	ff d0                	callq  *%rax
  8017a0:	48 98                	cltq   
  8017a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b2:	0f b6 00             	movzbl (%rax),%eax
  8017b5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017b8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017bc:	75 07                	jne    8017c5 <strstr+0x66>
				return (char *) 0;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	eb 33                	jmp    8017f8 <strstr+0x99>
		} while (sc != c);
  8017c5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017c9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017cc:	75 d8                	jne    8017a6 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	48 89 ce             	mov    %rcx,%rsi
  8017dd:	48 89 c7             	mov    %rax,%rdi
  8017e0:	48 b8 4f 12 80 00 00 	movabs $0x80124f,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	callq  *%rax
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 b6                	jne    8017a6 <strstr+0x47>

	return (char *) (in - 1);
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f8:	c9                   	leaveq 
  8017f9:	c3                   	retq   

00000000008017fa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	53                   	push   %rbx
  8017ff:	48 83 ec 48          	sub    $0x48,%rsp
  801803:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801806:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801809:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80180d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801811:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801815:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801819:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80181c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801820:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801824:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801828:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80182c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801830:	4c 89 c3             	mov    %r8,%rbx
  801833:	cd 30                	int    $0x30
  801835:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801839:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80183d:	74 3e                	je     80187d <syscall+0x83>
  80183f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801844:	7e 37                	jle    80187d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801846:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80184d:	49 89 d0             	mov    %rdx,%r8
  801850:	89 c1                	mov    %eax,%ecx
  801852:	48 ba 08 4e 80 00 00 	movabs $0x804e08,%rdx
  801859:	00 00 00 
  80185c:	be 24 00 00 00       	mov    $0x24,%esi
  801861:	48 bf 25 4e 80 00 00 	movabs $0x804e25,%rdi
  801868:	00 00 00 
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
  801870:	49 b9 76 3f 80 00 00 	movabs $0x803f76,%r9
  801877:	00 00 00 
  80187a:	41 ff d1             	callq  *%r9

	return ret;
  80187d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801881:	48 83 c4 48          	add    $0x48,%rsp
  801885:	5b                   	pop    %rbx
  801886:	5d                   	pop    %rbp
  801887:	c3                   	retq   

0000000000801888 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	48 83 ec 10          	sub    $0x10,%rsp
  801890:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801894:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a0:	48 83 ec 08          	sub    $0x8,%rsp
  8018a4:	6a 00                	pushq  $0x0
  8018a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b2:	48 89 d1             	mov    %rdx,%rcx
  8018b5:	48 89 c2             	mov    %rax,%rdx
  8018b8:	be 00 00 00 00       	mov    $0x0,%esi
  8018bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c2:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	callq  *%rax
  8018ce:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leaveq 
  8018d4:	c3                   	retq   

00000000008018d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018d9:	48 83 ec 08          	sub    $0x8,%rsp
  8018dd:	6a 00                	pushq  $0x0
  8018df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f5:	be 00 00 00 00       	mov    $0x0,%esi
  8018fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8018ff:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
  80190b:	48 83 c4 10          	add    $0x10,%rsp
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 10          	sub    $0x10,%rsp
  801919:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80191c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191f:	48 98                	cltq   
  801921:	48 83 ec 08          	sub    $0x8,%rsp
  801925:	6a 00                	pushq  $0x0
  801927:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801933:	b9 00 00 00 00       	mov    $0x0,%ecx
  801938:	48 89 c2             	mov    %rax,%rdx
  80193b:	be 01 00 00 00       	mov    $0x1,%esi
  801940:	bf 03 00 00 00       	mov    $0x3,%edi
  801945:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	callq  *%rax
  801951:	48 83 c4 10          	add    $0x10,%rsp
}
  801955:	c9                   	leaveq 
  801956:	c3                   	retq   

0000000000801957 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80195b:	48 83 ec 08          	sub    $0x8,%rsp
  80195f:	6a 00                	pushq  $0x0
  801961:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801967:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801972:	ba 00 00 00 00       	mov    $0x0,%edx
  801977:	be 00 00 00 00       	mov    $0x0,%esi
  80197c:	bf 02 00 00 00       	mov    $0x2,%edi
  801981:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801988:	00 00 00 
  80198b:	ff d0                	callq  *%rax
  80198d:	48 83 c4 10          	add    $0x10,%rsp
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <sys_yield>:


void
sys_yield(void)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801997:	48 83 ec 08          	sub    $0x8,%rsp
  80199b:	6a 00                	pushq  $0x0
  80199d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b3:	be 00 00 00 00       	mov    $0x0,%esi
  8019b8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019bd:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  8019c4:	00 00 00 
  8019c7:	ff d0                	callq  *%rax
  8019c9:	48 83 c4 10          	add    $0x10,%rsp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leaveq 
  8019cf:	c3                   	retq   

00000000008019d0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019d0:	55                   	push   %rbp
  8019d1:	48 89 e5             	mov    %rsp,%rbp
  8019d4:	48 83 ec 10          	sub    $0x10,%rsp
  8019d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019df:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e5:	48 63 c8             	movslq %eax,%rcx
  8019e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ef:	48 98                	cltq   
  8019f1:	48 83 ec 08          	sub    $0x8,%rsp
  8019f5:	6a 00                	pushq  $0x0
  8019f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fd:	49 89 c8             	mov    %rcx,%r8
  801a00:	48 89 d1             	mov    %rdx,%rcx
  801a03:	48 89 c2             	mov    %rax,%rdx
  801a06:	be 01 00 00 00       	mov    $0x1,%esi
  801a0b:	bf 04 00 00 00       	mov    $0x4,%edi
  801a10:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	callq  *%rax
  801a1c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a20:	c9                   	leaveq 
  801a21:	c3                   	retq   

0000000000801a22 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a22:	55                   	push   %rbp
  801a23:	48 89 e5             	mov    %rsp,%rbp
  801a26:	48 83 ec 20          	sub    $0x20,%rsp
  801a2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a31:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a34:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a38:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a3c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a3f:	48 63 c8             	movslq %eax,%rcx
  801a42:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a49:	48 63 f0             	movslq %eax,%rsi
  801a4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a53:	48 98                	cltq   
  801a55:	48 83 ec 08          	sub    $0x8,%rsp
  801a59:	51                   	push   %rcx
  801a5a:	49 89 f9             	mov    %rdi,%r9
  801a5d:	49 89 f0             	mov    %rsi,%r8
  801a60:	48 89 d1             	mov    %rdx,%rcx
  801a63:	48 89 c2             	mov    %rax,%rdx
  801a66:	be 01 00 00 00       	mov    $0x1,%esi
  801a6b:	bf 05 00 00 00       	mov    $0x5,%edi
  801a70:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
  801a7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 10          	sub    $0x10,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a98:	48 98                	cltq   
  801a9a:	48 83 ec 08          	sub    $0x8,%rsp
  801a9e:	6a 00                	pushq  $0x0
  801aa0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aac:	48 89 d1             	mov    %rdx,%rcx
  801aaf:	48 89 c2             	mov    %rax,%rdx
  801ab2:	be 01 00 00 00       	mov    $0x1,%esi
  801ab7:	bf 06 00 00 00       	mov    $0x6,%edi
  801abc:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801ac3:	00 00 00 
  801ac6:	ff d0                	callq  *%rax
  801ac8:	48 83 c4 10          	add    $0x10,%rsp
}
  801acc:	c9                   	leaveq 
  801acd:	c3                   	retq   

0000000000801ace <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ace:	55                   	push   %rbp
  801acf:	48 89 e5             	mov    %rsp,%rbp
  801ad2:	48 83 ec 10          	sub    $0x10,%rsp
  801ad6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801adc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801adf:	48 63 d0             	movslq %eax,%rdx
  801ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae5:	48 98                	cltq   
  801ae7:	48 83 ec 08          	sub    $0x8,%rsp
  801aeb:	6a 00                	pushq  $0x0
  801aed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af9:	48 89 d1             	mov    %rdx,%rcx
  801afc:	48 89 c2             	mov    %rax,%rdx
  801aff:	be 01 00 00 00       	mov    $0x1,%esi
  801b04:	bf 08 00 00 00       	mov    $0x8,%edi
  801b09:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
  801b15:	48 83 c4 10          	add    $0x10,%rsp
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 10          	sub    $0x10,%rsp
  801b23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b31:	48 98                	cltq   
  801b33:	48 83 ec 08          	sub    $0x8,%rsp
  801b37:	6a 00                	pushq  $0x0
  801b39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b45:	48 89 d1             	mov    %rdx,%rcx
  801b48:	48 89 c2             	mov    %rax,%rdx
  801b4b:	be 01 00 00 00       	mov    $0x1,%esi
  801b50:	bf 09 00 00 00       	mov    $0x9,%edi
  801b55:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
  801b61:	48 83 c4 10          	add    $0x10,%rsp
}
  801b65:	c9                   	leaveq 
  801b66:	c3                   	retq   

0000000000801b67 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
  801b6b:	48 83 ec 10          	sub    $0x10,%rsp
  801b6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7d:	48 98                	cltq   
  801b7f:	48 83 ec 08          	sub    $0x8,%rsp
  801b83:	6a 00                	pushq  $0x0
  801b85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b91:	48 89 d1             	mov    %rdx,%rcx
  801b94:	48 89 c2             	mov    %rax,%rdx
  801b97:	be 01 00 00 00       	mov    $0x1,%esi
  801b9c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ba1:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
  801bad:	48 83 c4 10          	add    $0x10,%rsp
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
  801bb7:	48 83 ec 20          	sub    $0x20,%rsp
  801bbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bc2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bc6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcc:	48 63 f0             	movslq %eax,%rsi
  801bcf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd6:	48 98                	cltq   
  801bd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdc:	48 83 ec 08          	sub    $0x8,%rsp
  801be0:	6a 00                	pushq  $0x0
  801be2:	49 89 f1             	mov    %rsi,%r9
  801be5:	49 89 c8             	mov    %rcx,%r8
  801be8:	48 89 d1             	mov    %rdx,%rcx
  801beb:	48 89 c2             	mov    %rax,%rdx
  801bee:	be 00 00 00 00       	mov    $0x0,%esi
  801bf3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bf8:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
  801c04:	48 83 c4 10          	add    $0x10,%rsp
}
  801c08:	c9                   	leaveq 
  801c09:	c3                   	retq   

0000000000801c0a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c0a:	55                   	push   %rbp
  801c0b:	48 89 e5             	mov    %rsp,%rbp
  801c0e:	48 83 ec 10          	sub    $0x10,%rsp
  801c12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1a:	48 83 ec 08          	sub    $0x8,%rsp
  801c1e:	6a 00                	pushq  $0x0
  801c20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c31:	48 89 c2             	mov    %rax,%rdx
  801c34:	be 01 00 00 00       	mov    $0x1,%esi
  801c39:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c3e:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801c45:	00 00 00 
  801c48:	ff d0                	callq  *%rax
  801c4a:	48 83 c4 10          	add    $0x10,%rsp
}
  801c4e:	c9                   	leaveq 
  801c4f:	c3                   	retq   

0000000000801c50 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c50:	55                   	push   %rbp
  801c51:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c54:	48 83 ec 08          	sub    $0x8,%rsp
  801c58:	6a 00                	pushq  $0x0
  801c5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c70:	be 00 00 00 00       	mov    $0x0,%esi
  801c75:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c7a:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
  801c86:	48 83 c4 10          	add    $0x10,%rsp
}
  801c8a:	c9                   	leaveq 
  801c8b:	c3                   	retq   

0000000000801c8c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c8c:	55                   	push   %rbp
  801c8d:	48 89 e5             	mov    %rsp,%rbp
  801c90:	48 83 ec 10          	sub    $0x10,%rsp
  801c94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c98:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801c9b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca2:	48 83 ec 08          	sub    $0x8,%rsp
  801ca6:	6a 00                	pushq  $0x0
  801ca8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb4:	48 89 d1             	mov    %rdx,%rcx
  801cb7:	48 89 c2             	mov    %rax,%rdx
  801cba:	be 00 00 00 00       	mov    $0x0,%esi
  801cbf:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cc4:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
  801cd0:	48 83 c4 10          	add    $0x10,%rsp
}
  801cd4:	c9                   	leaveq 
  801cd5:	c3                   	retq   

0000000000801cd6 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801cd6:	55                   	push   %rbp
  801cd7:	48 89 e5             	mov    %rsp,%rbp
  801cda:	48 83 ec 10          	sub    $0x10,%rsp
  801cde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ce2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801ce5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cec:	48 83 ec 08          	sub    $0x8,%rsp
  801cf0:	6a 00                	pushq  $0x0
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	48 89 d1             	mov    %rdx,%rcx
  801d01:	48 89 c2             	mov    %rax,%rdx
  801d04:	be 00 00 00 00       	mov    $0x0,%esi
  801d09:	bf 10 00 00 00       	mov    $0x10,%edi
  801d0e:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801d15:	00 00 00 
  801d18:	ff d0                	callq  *%rax
  801d1a:	48 83 c4 10          	add    $0x10,%rsp
}
  801d1e:	c9                   	leaveq 
  801d1f:	c3                   	retq   

0000000000801d20 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d20:	55                   	push   %rbp
  801d21:	48 89 e5             	mov    %rsp,%rbp
  801d24:	48 83 ec 20          	sub    $0x20,%rsp
  801d28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d32:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d36:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d3a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d3d:	48 63 c8             	movslq %eax,%rcx
  801d40:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d47:	48 63 f0             	movslq %eax,%rsi
  801d4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d51:	48 98                	cltq   
  801d53:	48 83 ec 08          	sub    $0x8,%rsp
  801d57:	51                   	push   %rcx
  801d58:	49 89 f9             	mov    %rdi,%r9
  801d5b:	49 89 f0             	mov    %rsi,%r8
  801d5e:	48 89 d1             	mov    %rdx,%rcx
  801d61:	48 89 c2             	mov    %rax,%rdx
  801d64:	be 00 00 00 00       	mov    $0x0,%esi
  801d69:	bf 11 00 00 00       	mov    $0x11,%edi
  801d6e:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801d75:	00 00 00 
  801d78:	ff d0                	callq  *%rax
  801d7a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d7e:	c9                   	leaveq 
  801d7f:	c3                   	retq   

0000000000801d80 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d80:	55                   	push   %rbp
  801d81:	48 89 e5             	mov    %rsp,%rbp
  801d84:	48 83 ec 10          	sub    $0x10,%rsp
  801d88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d98:	48 83 ec 08          	sub    $0x8,%rsp
  801d9c:	6a 00                	pushq  $0x0
  801d9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801daa:	48 89 d1             	mov    %rdx,%rcx
  801dad:	48 89 c2             	mov    %rax,%rdx
  801db0:	be 00 00 00 00       	mov    $0x0,%esi
  801db5:	bf 12 00 00 00       	mov    $0x12,%edi
  801dba:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	48 83 c4 10          	add    $0x10,%rsp
}
  801dca:	c9                   	leaveq 
  801dcb:	c3                   	retq   

0000000000801dcc <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801dcc:	55                   	push   %rbp
  801dcd:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801dd0:	48 83 ec 08          	sub    $0x8,%rsp
  801dd4:	6a 00                	pushq  $0x0
  801dd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ddc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	be 00 00 00 00       	mov    $0x0,%esi
  801df1:	bf 13 00 00 00       	mov    $0x13,%edi
  801df6:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
  801e02:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801e06:	90                   	nop
  801e07:	c9                   	leaveq 
  801e08:	c3                   	retq   

0000000000801e09 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e09:	55                   	push   %rbp
  801e0a:	48 89 e5             	mov    %rsp,%rbp
  801e0d:	48 83 ec 10          	sub    $0x10,%rsp
  801e11:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e17:	48 98                	cltq   
  801e19:	48 83 ec 08          	sub    $0x8,%rsp
  801e1d:	6a 00                	pushq  $0x0
  801e1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e30:	48 89 c2             	mov    %rax,%rdx
  801e33:	be 00 00 00 00       	mov    $0x0,%esi
  801e38:	bf 14 00 00 00       	mov    $0x14,%edi
  801e3d:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
  801e49:	48 83 c4 10          	add    $0x10,%rsp
}
  801e4d:	c9                   	leaveq 
  801e4e:	c3                   	retq   

0000000000801e4f <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801e4f:	55                   	push   %rbp
  801e50:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e53:	48 83 ec 08          	sub    $0x8,%rsp
  801e57:	6a 00                	pushq  $0x0
  801e59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6f:	be 00 00 00 00       	mov    $0x0,%esi
  801e74:	bf 15 00 00 00       	mov    $0x15,%edi
  801e79:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801e80:	00 00 00 
  801e83:	ff d0                	callq  *%rax
  801e85:	48 83 c4 10          	add    $0x10,%rsp
}
  801e89:	c9                   	leaveq 
  801e8a:	c3                   	retq   

0000000000801e8b <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801e8b:	55                   	push   %rbp
  801e8c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e8f:	48 83 ec 08          	sub    $0x8,%rsp
  801e93:	6a 00                	pushq  $0x0
  801e95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	be 00 00 00 00       	mov    $0x0,%esi
  801eb0:	bf 16 00 00 00       	mov    $0x16,%edi
  801eb5:	48 b8 fa 17 80 00 00 	movabs $0x8017fa,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
  801ec1:	48 83 c4 10          	add    $0x10,%rsp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 08          	sub    $0x8,%rsp
  801ed0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ed4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801edf:	ff ff ff 
  801ee2:	48 01 d0             	add    %rdx,%rax
  801ee5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ee9:	c9                   	leaveq 
  801eea:	c3                   	retq   

0000000000801eeb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801eeb:	55                   	push   %rbp
  801eec:	48 89 e5             	mov    %rsp,%rbp
  801eef:	48 83 ec 08          	sub    $0x8,%rsp
  801ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ef7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efb:	48 89 c7             	mov    %rax,%rdi
  801efe:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  801f05:	00 00 00 
  801f08:	ff d0                	callq  *%rax
  801f0a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f10:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f14:	c9                   	leaveq 
  801f15:	c3                   	retq   

0000000000801f16 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f16:	55                   	push   %rbp
  801f17:	48 89 e5             	mov    %rsp,%rbp
  801f1a:	48 83 ec 18          	sub    $0x18,%rsp
  801f1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f29:	eb 6b                	jmp    801f96 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2e:	48 98                	cltq   
  801f30:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f36:	48 c1 e0 0c          	shl    $0xc,%rax
  801f3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f42:	48 c1 e8 15          	shr    $0x15,%rax
  801f46:	48 89 c2             	mov    %rax,%rdx
  801f49:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f50:	01 00 00 
  801f53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f57:	83 e0 01             	and    $0x1,%eax
  801f5a:	48 85 c0             	test   %rax,%rax
  801f5d:	74 21                	je     801f80 <fd_alloc+0x6a>
  801f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f63:	48 c1 e8 0c          	shr    $0xc,%rax
  801f67:	48 89 c2             	mov    %rax,%rdx
  801f6a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f71:	01 00 00 
  801f74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f78:	83 e0 01             	and    $0x1,%eax
  801f7b:	48 85 c0             	test   %rax,%rax
  801f7e:	75 12                	jne    801f92 <fd_alloc+0x7c>
			*fd_store = fd;
  801f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f88:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	eb 1a                	jmp    801fac <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f92:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f96:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f9a:	7e 8f                	jle    801f2b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fa7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fac:	c9                   	leaveq 
  801fad:	c3                   	retq   

0000000000801fae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fae:	55                   	push   %rbp
  801faf:	48 89 e5             	mov    %rsp,%rbp
  801fb2:	48 83 ec 20          	sub    $0x20,%rsp
  801fb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fc1:	78 06                	js     801fc9 <fd_lookup+0x1b>
  801fc3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fc7:	7e 07                	jle    801fd0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fce:	eb 6c                	jmp    80203c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fd3:	48 98                	cltq   
  801fd5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fdb:	48 c1 e0 0c          	shl    $0xc,%rax
  801fdf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe7:	48 c1 e8 15          	shr    $0x15,%rax
  801feb:	48 89 c2             	mov    %rax,%rdx
  801fee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ff5:	01 00 00 
  801ff8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffc:	83 e0 01             	and    $0x1,%eax
  801fff:	48 85 c0             	test   %rax,%rax
  802002:	74 21                	je     802025 <fd_lookup+0x77>
  802004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802008:	48 c1 e8 0c          	shr    $0xc,%rax
  80200c:	48 89 c2             	mov    %rax,%rdx
  80200f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802016:	01 00 00 
  802019:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201d:	83 e0 01             	and    $0x1,%eax
  802020:	48 85 c0             	test   %rax,%rax
  802023:	75 07                	jne    80202c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802025:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80202a:	eb 10                	jmp    80203c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80202c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802030:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802034:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203c:	c9                   	leaveq 
  80203d:	c3                   	retq   

000000000080203e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80203e:	55                   	push   %rbp
  80203f:	48 89 e5             	mov    %rsp,%rbp
  802042:	48 83 ec 30          	sub    $0x30,%rsp
  802046:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80204a:	89 f0                	mov    %esi,%eax
  80204c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80204f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802053:	48 89 c7             	mov    %rax,%rdi
  802056:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80205d:	00 00 00 
  802060:	ff d0                	callq  *%rax
  802062:	89 c2                	mov    %eax,%edx
  802064:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802068:	48 89 c6             	mov    %rax,%rsi
  80206b:	89 d7                	mov    %edx,%edi
  80206d:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802080:	78 0a                	js     80208c <fd_close+0x4e>
	    || fd != fd2)
  802082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802086:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80208a:	74 12                	je     80209e <fd_close+0x60>
		return (must_exist ? r : 0);
  80208c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802090:	74 05                	je     802097 <fd_close+0x59>
  802092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802095:	eb 70                	jmp    802107 <fd_close+0xc9>
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	eb 69                	jmp    802107 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80209e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a2:	8b 00                	mov    (%rax),%eax
  8020a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020a8:	48 89 d6             	mov    %rdx,%rsi
  8020ab:	89 c7                	mov    %eax,%edi
  8020ad:	48 b8 09 21 80 00 00 	movabs $0x802109,%rax
  8020b4:	00 00 00 
  8020b7:	ff d0                	callq  *%rax
  8020b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c0:	78 2a                	js     8020ec <fd_close+0xae>
		if (dev->dev_close)
  8020c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020ca:	48 85 c0             	test   %rax,%rax
  8020cd:	74 16                	je     8020e5 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8020cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020db:	48 89 d7             	mov    %rdx,%rdi
  8020de:	ff d0                	callq  *%rax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e3:	eb 07                	jmp    8020ec <fd_close+0xae>
		else
			r = 0;
  8020e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f0:	48 89 c6             	mov    %rax,%rsi
  8020f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f8:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8020ff:	00 00 00 
  802102:	ff d0                	callq  *%rax
	return r;
  802104:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802107:	c9                   	leaveq 
  802108:	c3                   	retq   

0000000000802109 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802109:	55                   	push   %rbp
  80210a:	48 89 e5             	mov    %rsp,%rbp
  80210d:	48 83 ec 20          	sub    $0x20,%rsp
  802111:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80211f:	eb 41                	jmp    802162 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802121:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802128:	00 00 00 
  80212b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80212e:	48 63 d2             	movslq %edx,%rdx
  802131:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802135:	8b 00                	mov    (%rax),%eax
  802137:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80213a:	75 22                	jne    80215e <dev_lookup+0x55>
			*dev = devtab[i];
  80213c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802143:	00 00 00 
  802146:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802149:	48 63 d2             	movslq %edx,%rdx
  80214c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802154:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
  80215c:	eb 60                	jmp    8021be <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80215e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802162:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802169:	00 00 00 
  80216c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80216f:	48 63 d2             	movslq %edx,%rdx
  802172:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802176:	48 85 c0             	test   %rax,%rax
  802179:	75 a6                	jne    802121 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80217b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802182:	00 00 00 
  802185:	48 8b 00             	mov    (%rax),%rax
  802188:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80218e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802191:	89 c6                	mov    %eax,%esi
  802193:	48 bf 38 4e 80 00 00 	movabs $0x804e38,%rdi
  80219a:	00 00 00 
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a2:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  8021a9:	00 00 00 
  8021ac:	ff d1                	callq  *%rcx
	*dev = 0;
  8021ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021be:	c9                   	leaveq 
  8021bf:	c3                   	retq   

00000000008021c0 <close>:

int
close(int fdnum)
{
  8021c0:	55                   	push   %rbp
  8021c1:	48 89 e5             	mov    %rsp,%rbp
  8021c4:	48 83 ec 20          	sub    $0x20,%rsp
  8021c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d2:	48 89 d6             	mov    %rdx,%rsi
  8021d5:	89 c7                	mov    %eax,%edi
  8021d7:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  8021de:	00 00 00 
  8021e1:	ff d0                	callq  *%rax
  8021e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ea:	79 05                	jns    8021f1 <close+0x31>
		return r;
  8021ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ef:	eb 18                	jmp    802209 <close+0x49>
	else
		return fd_close(fd, 1);
  8021f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f5:	be 01 00 00 00       	mov    $0x1,%esi
  8021fa:	48 89 c7             	mov    %rax,%rdi
  8021fd:	48 b8 3e 20 80 00 00 	movabs $0x80203e,%rax
  802204:	00 00 00 
  802207:	ff d0                	callq  *%rax
}
  802209:	c9                   	leaveq 
  80220a:	c3                   	retq   

000000000080220b <close_all>:

void
close_all(void)
{
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80221a:	eb 15                	jmp    802231 <close_all+0x26>
		close(i);
  80221c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221f:	89 c7                	mov    %eax,%edi
  802221:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802228:	00 00 00 
  80222b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80222d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802231:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802235:	7e e5                	jle    80221c <close_all+0x11>
		close(i);
}
  802237:	90                   	nop
  802238:	c9                   	leaveq 
  802239:	c3                   	retq   

000000000080223a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80223a:	55                   	push   %rbp
  80223b:	48 89 e5             	mov    %rsp,%rbp
  80223e:	48 83 ec 40          	sub    $0x40,%rsp
  802242:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802245:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802248:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80224c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80224f:	48 89 d6             	mov    %rdx,%rsi
  802252:	89 c7                	mov    %eax,%edi
  802254:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	callq  *%rax
  802260:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802267:	79 08                	jns    802271 <dup+0x37>
		return r;
  802269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226c:	e9 70 01 00 00       	jmpq   8023e1 <dup+0x1a7>
	close(newfdnum);
  802271:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802274:	89 c7                	mov    %eax,%edi
  802276:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  80227d:	00 00 00 
  802280:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802282:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802285:	48 98                	cltq   
  802287:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80228d:	48 c1 e0 0c          	shl    $0xc,%rax
  802291:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802299:	48 89 c7             	mov    %rax,%rdi
  80229c:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  8022a3:	00 00 00 
  8022a6:	ff d0                	callq  *%rax
  8022a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b0:	48 89 c7             	mov    %rax,%rdi
  8022b3:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c7:	48 c1 e8 15          	shr    $0x15,%rax
  8022cb:	48 89 c2             	mov    %rax,%rdx
  8022ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022d5:	01 00 00 
  8022d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022dc:	83 e0 01             	and    $0x1,%eax
  8022df:	48 85 c0             	test   %rax,%rax
  8022e2:	74 71                	je     802355 <dup+0x11b>
  8022e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ec:	48 89 c2             	mov    %rax,%rdx
  8022ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f6:	01 00 00 
  8022f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fd:	83 e0 01             	and    $0x1,%eax
  802300:	48 85 c0             	test   %rax,%rax
  802303:	74 50                	je     802355 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802309:	48 c1 e8 0c          	shr    $0xc,%rax
  80230d:	48 89 c2             	mov    %rax,%rdx
  802310:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802317:	01 00 00 
  80231a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231e:	25 07 0e 00 00       	and    $0xe07,%eax
  802323:	89 c1                	mov    %eax,%ecx
  802325:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232d:	41 89 c8             	mov    %ecx,%r8d
  802330:	48 89 d1             	mov    %rdx,%rcx
  802333:	ba 00 00 00 00       	mov    $0x0,%edx
  802338:	48 89 c6             	mov    %rax,%rsi
  80233b:	bf 00 00 00 00       	mov    $0x0,%edi
  802340:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
  80234c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802353:	78 55                	js     8023aa <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802359:	48 c1 e8 0c          	shr    $0xc,%rax
  80235d:	48 89 c2             	mov    %rax,%rdx
  802360:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802367:	01 00 00 
  80236a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80236e:	25 07 0e 00 00       	and    $0xe07,%eax
  802373:	89 c1                	mov    %eax,%ecx
  802375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802379:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80237d:	41 89 c8             	mov    %ecx,%r8d
  802380:	48 89 d1             	mov    %rdx,%rcx
  802383:	ba 00 00 00 00       	mov    $0x0,%edx
  802388:	48 89 c6             	mov    %rax,%rsi
  80238b:	bf 00 00 00 00       	mov    $0x0,%edi
  802390:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
  80239c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a3:	78 08                	js     8023ad <dup+0x173>
		goto err;

	return newfdnum;
  8023a5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023a8:	eb 37                	jmp    8023e1 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8023aa:	90                   	nop
  8023ab:	eb 01                	jmp    8023ae <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8023ad:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8023ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b2:	48 89 c6             	mov    %rax,%rsi
  8023b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ba:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ca:	48 89 c6             	mov    %rax,%rsi
  8023cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d2:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
	return r;
  8023de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023e1:	c9                   	leaveq 
  8023e2:	c3                   	retq   

00000000008023e3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023e3:	55                   	push   %rbp
  8023e4:	48 89 e5             	mov    %rsp,%rbp
  8023e7:	48 83 ec 40          	sub    $0x40,%rsp
  8023eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023fd:	48 89 d6             	mov    %rdx,%rsi
  802400:	89 c7                	mov    %eax,%edi
  802402:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802409:	00 00 00 
  80240c:	ff d0                	callq  *%rax
  80240e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802411:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802415:	78 24                	js     80243b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241b:	8b 00                	mov    (%rax),%eax
  80241d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802421:	48 89 d6             	mov    %rdx,%rsi
  802424:	89 c7                	mov    %eax,%edi
  802426:	48 b8 09 21 80 00 00 	movabs $0x802109,%rax
  80242d:	00 00 00 
  802430:	ff d0                	callq  *%rax
  802432:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802435:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802439:	79 05                	jns    802440 <read+0x5d>
		return r;
  80243b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243e:	eb 76                	jmp    8024b6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802444:	8b 40 08             	mov    0x8(%rax),%eax
  802447:	83 e0 03             	and    $0x3,%eax
  80244a:	83 f8 01             	cmp    $0x1,%eax
  80244d:	75 3a                	jne    802489 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80244f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802456:	00 00 00 
  802459:	48 8b 00             	mov    (%rax),%rax
  80245c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802462:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802465:	89 c6                	mov    %eax,%esi
  802467:	48 bf 57 4e 80 00 00 	movabs $0x804e57,%rdi
  80246e:	00 00 00 
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  80247d:	00 00 00 
  802480:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802487:	eb 2d                	jmp    8024b6 <read+0xd3>
	}
	if (!dev->dev_read)
  802489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802491:	48 85 c0             	test   %rax,%rax
  802494:	75 07                	jne    80249d <read+0xba>
		return -E_NOT_SUPP;
  802496:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80249b:	eb 19                	jmp    8024b6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80249d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024a5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024a9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ad:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024b1:	48 89 cf             	mov    %rcx,%rdi
  8024b4:	ff d0                	callq  *%rax
}
  8024b6:	c9                   	leaveq 
  8024b7:	c3                   	retq   

00000000008024b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024b8:	55                   	push   %rbp
  8024b9:	48 89 e5             	mov    %rsp,%rbp
  8024bc:	48 83 ec 30          	sub    $0x30,%rsp
  8024c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024d2:	eb 47                	jmp    80251b <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d7:	48 98                	cltq   
  8024d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024dd:	48 29 c2             	sub    %rax,%rdx
  8024e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e3:	48 63 c8             	movslq %eax,%rcx
  8024e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ea:	48 01 c1             	add    %rax,%rcx
  8024ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024f0:	48 89 ce             	mov    %rcx,%rsi
  8024f3:	89 c7                	mov    %eax,%edi
  8024f5:	48 b8 e3 23 80 00 00 	movabs $0x8023e3,%rax
  8024fc:	00 00 00 
  8024ff:	ff d0                	callq  *%rax
  802501:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802504:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802508:	79 05                	jns    80250f <readn+0x57>
			return m;
  80250a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80250d:	eb 1d                	jmp    80252c <readn+0x74>
		if (m == 0)
  80250f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802513:	74 13                	je     802528 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802515:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802518:	01 45 fc             	add    %eax,-0x4(%rbp)
  80251b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251e:	48 98                	cltq   
  802520:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802524:	72 ae                	jb     8024d4 <readn+0x1c>
  802526:	eb 01                	jmp    802529 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802528:	90                   	nop
	}
	return tot;
  802529:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 40          	sub    $0x40,%rsp
  802536:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802539:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80253d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802541:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802545:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802548:	48 89 d6             	mov    %rdx,%rsi
  80254b:	89 c7                	mov    %eax,%edi
  80254d:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	78 24                	js     802586 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802566:	8b 00                	mov    (%rax),%eax
  802568:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 09 21 80 00 00 	movabs $0x802109,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	79 05                	jns    80258b <write+0x5d>
		return r;
  802586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802589:	eb 75                	jmp    802600 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80258b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258f:	8b 40 08             	mov    0x8(%rax),%eax
  802592:	83 e0 03             	and    $0x3,%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	75 3a                	jne    8025d3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802599:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8025a0:	00 00 00 
  8025a3:	48 8b 00             	mov    (%rax),%rax
  8025a6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025ac:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025af:	89 c6                	mov    %eax,%esi
  8025b1:	48 bf 73 4e 80 00 00 	movabs $0x804e73,%rdi
  8025b8:	00 00 00 
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c0:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  8025c7:	00 00 00 
  8025ca:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025d1:	eb 2d                	jmp    802600 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025db:	48 85 c0             	test   %rax,%rax
  8025de:	75 07                	jne    8025e7 <write+0xb9>
		return -E_NOT_SUPP;
  8025e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025e5:	eb 19                	jmp    802600 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8025e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025eb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025f7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025fb:	48 89 cf             	mov    %rcx,%rdi
  8025fe:	ff d0                	callq  *%rax
}
  802600:	c9                   	leaveq 
  802601:	c3                   	retq   

0000000000802602 <seek>:

int
seek(int fdnum, off_t offset)
{
  802602:	55                   	push   %rbp
  802603:	48 89 e5             	mov    %rsp,%rbp
  802606:	48 83 ec 18          	sub    $0x18,%rsp
  80260a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802610:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802614:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802617:	48 89 d6             	mov    %rdx,%rsi
  80261a:	89 c7                	mov    %eax,%edi
  80261c:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802623:	00 00 00 
  802626:	ff d0                	callq  *%rax
  802628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262f:	79 05                	jns    802636 <seek+0x34>
		return r;
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	eb 0f                	jmp    802645 <seek+0x43>
	fd->fd_offset = offset;
  802636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80263d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802645:	c9                   	leaveq 
  802646:	c3                   	retq   

0000000000802647 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802647:	55                   	push   %rbp
  802648:	48 89 e5             	mov    %rsp,%rbp
  80264b:	48 83 ec 30          	sub    $0x30,%rsp
  80264f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802652:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802655:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802659:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80265c:	48 89 d6             	mov    %rdx,%rsi
  80265f:	89 c7                	mov    %eax,%edi
  802661:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802670:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802674:	78 24                	js     80269a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267a:	8b 00                	mov    (%rax),%eax
  80267c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802680:	48 89 d6             	mov    %rdx,%rsi
  802683:	89 c7                	mov    %eax,%edi
  802685:	48 b8 09 21 80 00 00 	movabs $0x802109,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	79 05                	jns    80269f <ftruncate+0x58>
		return r;
  80269a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269d:	eb 72                	jmp    802711 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80269f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a3:	8b 40 08             	mov    0x8(%rax),%eax
  8026a6:	83 e0 03             	and    $0x3,%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	75 3a                	jne    8026e7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026ad:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026b4:	00 00 00 
  8026b7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026ba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026c3:	89 c6                	mov    %eax,%esi
  8026c5:	48 bf 90 4e 80 00 00 	movabs $0x804e90,%rdi
  8026cc:	00 00 00 
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  8026db:	00 00 00 
  8026de:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e5:	eb 2a                	jmp    802711 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026eb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026ef:	48 85 c0             	test   %rax,%rax
  8026f2:	75 07                	jne    8026fb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026f9:	eb 16                	jmp    802711 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ff:	48 8b 40 30          	mov    0x30(%rax),%rax
  802703:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802707:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80270a:	89 ce                	mov    %ecx,%esi
  80270c:	48 89 d7             	mov    %rdx,%rdi
  80270f:	ff d0                	callq  *%rax
}
  802711:	c9                   	leaveq 
  802712:	c3                   	retq   

0000000000802713 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802713:	55                   	push   %rbp
  802714:	48 89 e5             	mov    %rsp,%rbp
  802717:	48 83 ec 30          	sub    $0x30,%rsp
  80271b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80271e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802722:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802726:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802729:	48 89 d6             	mov    %rdx,%rsi
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax
  80273a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802741:	78 24                	js     802767 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802747:	8b 00                	mov    (%rax),%eax
  802749:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274d:	48 89 d6             	mov    %rdx,%rsi
  802750:	89 c7                	mov    %eax,%edi
  802752:	48 b8 09 21 80 00 00 	movabs $0x802109,%rax
  802759:	00 00 00 
  80275c:	ff d0                	callq  *%rax
  80275e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802765:	79 05                	jns    80276c <fstat+0x59>
		return r;
  802767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276a:	eb 5e                	jmp    8027ca <fstat+0xb7>
	if (!dev->dev_stat)
  80276c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802770:	48 8b 40 28          	mov    0x28(%rax),%rax
  802774:	48 85 c0             	test   %rax,%rax
  802777:	75 07                	jne    802780 <fstat+0x6d>
		return -E_NOT_SUPP;
  802779:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80277e:	eb 4a                	jmp    8027ca <fstat+0xb7>
	stat->st_name[0] = 0;
  802780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802784:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802787:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80278b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802792:	00 00 00 
	stat->st_isdir = 0;
  802795:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802799:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027a0:	00 00 00 
	stat->st_dev = dev;
  8027a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ab:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027be:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027c2:	48 89 ce             	mov    %rcx,%rsi
  8027c5:	48 89 d7             	mov    %rdx,%rdi
  8027c8:	ff d0                	callq  *%rax
}
  8027ca:	c9                   	leaveq 
  8027cb:	c3                   	retq   

00000000008027cc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027cc:	55                   	push   %rbp
  8027cd:	48 89 e5             	mov    %rsp,%rbp
  8027d0:	48 83 ec 20          	sub    $0x20,%rsp
  8027d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e0:	be 00 00 00 00       	mov    $0x0,%esi
  8027e5:	48 89 c7             	mov    %rax,%rdi
  8027e8:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
  8027f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fb:	79 05                	jns    802802 <stat+0x36>
		return fd;
  8027fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802800:	eb 2f                	jmp    802831 <stat+0x65>
	r = fstat(fd, stat);
  802802:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802809:	48 89 d6             	mov    %rdx,%rsi
  80280c:	89 c7                	mov    %eax,%edi
  80280e:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  802815:	00 00 00 
  802818:	ff d0                	callq  *%rax
  80281a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80281d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802820:	89 c7                	mov    %eax,%edi
  802822:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
	return r;
  80282e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802831:	c9                   	leaveq 
  802832:	c3                   	retq   

0000000000802833 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802833:	55                   	push   %rbp
  802834:	48 89 e5             	mov    %rsp,%rbp
  802837:	48 83 ec 10          	sub    $0x10,%rsp
  80283b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80283e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802842:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802849:	00 00 00 
  80284c:	8b 00                	mov    (%rax),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	75 1f                	jne    802871 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802852:	bf 01 00 00 00       	mov    $0x1,%edi
  802857:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
  802863:	89 c2                	mov    %eax,%edx
  802865:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80286c:	00 00 00 
  80286f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802871:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802878:	00 00 00 
  80287b:	8b 00                	mov    (%rax),%eax
  80287d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802880:	b9 07 00 00 00       	mov    $0x7,%ecx
  802885:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80288c:	00 00 00 
  80288f:	89 c7                	mov    %eax,%edi
  802891:	48 b8 4b 41 80 00 00 	movabs $0x80414b,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80289d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a6:	48 89 c6             	mov    %rax,%rsi
  8028a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ae:	48 b8 8a 40 80 00 00 	movabs $0x80408a,%rax
  8028b5:	00 00 00 
  8028b8:	ff d0                	callq  *%rax
}
  8028ba:	c9                   	leaveq 
  8028bb:	c3                   	retq   

00000000008028bc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028bc:	55                   	push   %rbp
  8028bd:	48 89 e5             	mov    %rsp,%rbp
  8028c0:	48 83 ec 20          	sub    $0x20,%rsp
  8028c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8028cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cf:	48 89 c7             	mov    %rax,%rdi
  8028d2:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028e3:	7e 0a                	jle    8028ef <open+0x33>
		return -E_BAD_PATH;
  8028e5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028ea:	e9 a5 00 00 00       	jmpq   802994 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8028ef:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028f3:	48 89 c7             	mov    %rax,%rdi
  8028f6:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
  802902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802909:	79 08                	jns    802913 <open+0x57>
		return r;
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	e9 81 00 00 00       	jmpq   802994 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	48 89 c6             	mov    %rax,%rsi
  80291a:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802921:	00 00 00 
  802924:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802930:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802937:	00 00 00 
  80293a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80293d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802947:	48 89 c6             	mov    %rax,%rsi
  80294a:	bf 01 00 00 00       	mov    $0x1,%edi
  80294f:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
  80295b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802962:	79 1d                	jns    802981 <open+0xc5>
		fd_close(fd, 0);
  802964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802968:	be 00 00 00 00       	mov    $0x0,%esi
  80296d:	48 89 c7             	mov    %rax,%rdi
  802970:	48 b8 3e 20 80 00 00 	movabs $0x80203e,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
		return r;
  80297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297f:	eb 13                	jmp    802994 <open+0xd8>
	}

	return fd2num(fd);
  802981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802985:	48 89 c7             	mov    %rax,%rdi
  802988:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax

}
  802994:	c9                   	leaveq 
  802995:	c3                   	retq   

0000000000802996 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802996:	55                   	push   %rbp
  802997:	48 89 e5             	mov    %rsp,%rbp
  80299a:	48 83 ec 10          	sub    $0x10,%rsp
  80299e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029b0:	00 00 00 
  8029b3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029b5:	be 00 00 00 00       	mov    $0x0,%esi
  8029ba:	bf 06 00 00 00       	mov    $0x6,%edi
  8029bf:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	callq  *%rax
}
  8029cb:	c9                   	leaveq 
  8029cc:	c3                   	retq   

00000000008029cd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029cd:	55                   	push   %rbp
  8029ce:	48 89 e5             	mov    %rsp,%rbp
  8029d1:	48 83 ec 30          	sub    $0x30,%rsp
  8029d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029ef:	00 00 00 
  8029f2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029f4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029fb:	00 00 00 
  8029fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a02:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802a06:	be 00 00 00 00       	mov    $0x0,%esi
  802a0b:	bf 03 00 00 00       	mov    $0x3,%edi
  802a10:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
  802a1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a23:	79 08                	jns    802a2d <devfile_read+0x60>
		return r;
  802a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a28:	e9 a4 00 00 00       	jmpq   802ad1 <devfile_read+0x104>
	assert(r <= n);
  802a2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a30:	48 98                	cltq   
  802a32:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a36:	76 35                	jbe    802a6d <devfile_read+0xa0>
  802a38:	48 b9 b6 4e 80 00 00 	movabs $0x804eb6,%rcx
  802a3f:	00 00 00 
  802a42:	48 ba bd 4e 80 00 00 	movabs $0x804ebd,%rdx
  802a49:	00 00 00 
  802a4c:	be 86 00 00 00       	mov    $0x86,%esi
  802a51:	48 bf d2 4e 80 00 00 	movabs $0x804ed2,%rdi
  802a58:	00 00 00 
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a60:	49 b8 76 3f 80 00 00 	movabs $0x803f76,%r8
  802a67:	00 00 00 
  802a6a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802a6d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802a74:	7e 35                	jle    802aab <devfile_read+0xde>
  802a76:	48 b9 dd 4e 80 00 00 	movabs $0x804edd,%rcx
  802a7d:	00 00 00 
  802a80:	48 ba bd 4e 80 00 00 	movabs $0x804ebd,%rdx
  802a87:	00 00 00 
  802a8a:	be 87 00 00 00       	mov    $0x87,%esi
  802a8f:	48 bf d2 4e 80 00 00 	movabs $0x804ed2,%rdi
  802a96:	00 00 00 
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9e:	49 b8 76 3f 80 00 00 	movabs $0x803f76,%r8
  802aa5:	00 00 00 
  802aa8:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aae:	48 63 d0             	movslq %eax,%rdx
  802ab1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab5:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802abc:	00 00 00 
  802abf:	48 89 c7             	mov    %rax,%rdi
  802ac2:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	callq  *%rax
	return r;
  802ace:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802ad1:	c9                   	leaveq 
  802ad2:	c3                   	retq   

0000000000802ad3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ad3:	55                   	push   %rbp
  802ad4:	48 89 e5             	mov    %rsp,%rbp
  802ad7:	48 83 ec 40          	sub    $0x40,%rsp
  802adb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802adf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ae3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802ae7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802aeb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802aef:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802af6:	00 
  802af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802aff:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802b04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b0c:	8b 50 0c             	mov    0xc(%rax),%edx
  802b0f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b16:	00 00 00 
  802b19:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b1b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b22:	00 00 00 
  802b25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b29:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802b2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b35:	48 89 c6             	mov    %rax,%rsi
  802b38:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802b3f:	00 00 00 
  802b42:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b4e:	be 00 00 00 00       	mov    $0x0,%esi
  802b53:	bf 04 00 00 00       	mov    $0x4,%edi
  802b58:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b67:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b6b:	79 05                	jns    802b72 <devfile_write+0x9f>
		return r;
  802b6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b70:	eb 43                	jmp    802bb5 <devfile_write+0xe2>
	assert(r <= n);
  802b72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b75:	48 98                	cltq   
  802b77:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802b7b:	76 35                	jbe    802bb2 <devfile_write+0xdf>
  802b7d:	48 b9 b6 4e 80 00 00 	movabs $0x804eb6,%rcx
  802b84:	00 00 00 
  802b87:	48 ba bd 4e 80 00 00 	movabs $0x804ebd,%rdx
  802b8e:	00 00 00 
  802b91:	be a2 00 00 00       	mov    $0xa2,%esi
  802b96:	48 bf d2 4e 80 00 00 	movabs $0x804ed2,%rdi
  802b9d:	00 00 00 
  802ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba5:	49 b8 76 3f 80 00 00 	movabs $0x803f76,%r8
  802bac:	00 00 00 
  802baf:	41 ff d0             	callq  *%r8
	return r;
  802bb2:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802bb5:	c9                   	leaveq 
  802bb6:	c3                   	retq   

0000000000802bb7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802bb7:	55                   	push   %rbp
  802bb8:	48 89 e5             	mov    %rsp,%rbp
  802bbb:	48 83 ec 20          	sub    $0x20,%rsp
  802bbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcb:	8b 50 0c             	mov    0xc(%rax),%edx
  802bce:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bd5:	00 00 00 
  802bd8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bda:	be 00 00 00 00       	mov    $0x0,%esi
  802bdf:	bf 05 00 00 00       	mov    $0x5,%edi
  802be4:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802beb:	00 00 00 
  802bee:	ff d0                	callq  *%rax
  802bf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf7:	79 05                	jns    802bfe <devfile_stat+0x47>
		return r;
  802bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfc:	eb 56                	jmp    802c54 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c02:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802c09:	00 00 00 
  802c0c:	48 89 c7             	mov    %rax,%rdi
  802c0f:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c1b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c22:	00 00 00 
  802c25:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c2f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c35:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c3c:	00 00 00 
  802c3f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c49:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c54:	c9                   	leaveq 
  802c55:	c3                   	retq   

0000000000802c56 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c56:	55                   	push   %rbp
  802c57:	48 89 e5             	mov    %rsp,%rbp
  802c5a:	48 83 ec 10          	sub    $0x10,%rsp
  802c5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c62:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c69:	8b 50 0c             	mov    0xc(%rax),%edx
  802c6c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c73:	00 00 00 
  802c76:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c78:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c7f:	00 00 00 
  802c82:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c85:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c88:	be 00 00 00 00       	mov    $0x0,%esi
  802c8d:	bf 02 00 00 00       	mov    $0x2,%edi
  802c92:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
}
  802c9e:	c9                   	leaveq 
  802c9f:	c3                   	retq   

0000000000802ca0 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ca0:	55                   	push   %rbp
  802ca1:	48 89 e5             	mov    %rsp,%rbp
  802ca4:	48 83 ec 10          	sub    $0x10,%rsp
  802ca8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb0:	48 89 c7             	mov    %rax,%rdi
  802cb3:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
  802cbf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cc4:	7e 07                	jle    802ccd <remove+0x2d>
		return -E_BAD_PATH;
  802cc6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ccb:	eb 33                	jmp    802d00 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd1:	48 89 c6             	mov    %rax,%rsi
  802cd4:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802cdb:	00 00 00 
  802cde:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cea:	be 00 00 00 00       	mov    $0x0,%esi
  802cef:	bf 07 00 00 00       	mov    $0x7,%edi
  802cf4:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802cfb:	00 00 00 
  802cfe:	ff d0                	callq  *%rax
}
  802d00:	c9                   	leaveq 
  802d01:	c3                   	retq   

0000000000802d02 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d02:	55                   	push   %rbp
  802d03:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d06:	be 00 00 00 00       	mov    $0x0,%esi
  802d0b:	bf 08 00 00 00       	mov    $0x8,%edi
  802d10:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
}
  802d1c:	5d                   	pop    %rbp
  802d1d:	c3                   	retq   

0000000000802d1e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d29:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d30:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d37:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d3e:	be 00 00 00 00       	mov    $0x0,%esi
  802d43:	48 89 c7             	mov    %rax,%rdi
  802d46:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d59:	79 28                	jns    802d83 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5e:	89 c6                	mov    %eax,%esi
  802d60:	48 bf e9 4e 80 00 00 	movabs $0x804ee9,%rdi
  802d67:	00 00 00 
  802d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6f:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802d76:	00 00 00 
  802d79:	ff d2                	callq  *%rdx
		return fd_src;
  802d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7e:	e9 76 01 00 00       	jmpq   802ef9 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d83:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d8a:	be 01 01 00 00       	mov    $0x101,%esi
  802d8f:	48 89 c7             	mov    %rax,%rdi
  802d92:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
  802d9e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802da1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802da5:	0f 89 ad 00 00 00    	jns    802e58 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802dab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dae:	89 c6                	mov    %eax,%esi
  802db0:	48 bf ff 4e 80 00 00 	movabs $0x804eff,%rdi
  802db7:	00 00 00 
  802dba:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbf:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802dc6:	00 00 00 
  802dc9:	ff d2                	callq  *%rdx
		close(fd_src);
  802dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dce:	89 c7                	mov    %eax,%edi
  802dd0:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
		return fd_dest;
  802ddc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddf:	e9 15 01 00 00       	jmpq   802ef9 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802de4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802de7:	48 63 d0             	movslq %eax,%rdx
  802dea:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802df1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802df4:	48 89 ce             	mov    %rcx,%rsi
  802df7:	89 c7                	mov    %eax,%edi
  802df9:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
  802e05:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e08:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e0c:	79 4a                	jns    802e58 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802e0e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e11:	89 c6                	mov    %eax,%esi
  802e13:	48 bf 19 4f 80 00 00 	movabs $0x804f19,%rdi
  802e1a:	00 00 00 
  802e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e22:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802e29:	00 00 00 
  802e2c:	ff d2                	callq  *%rdx
			close(fd_src);
  802e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e31:	89 c7                	mov    %eax,%edi
  802e33:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802e3a:	00 00 00 
  802e3d:	ff d0                	callq  *%rax
			close(fd_dest);
  802e3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e42:	89 c7                	mov    %eax,%edi
  802e44:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
			return write_size;
  802e50:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e53:	e9 a1 00 00 00       	jmpq   802ef9 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e58:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e62:	ba 00 02 00 00       	mov    $0x200,%edx
  802e67:	48 89 ce             	mov    %rcx,%rsi
  802e6a:	89 c7                	mov    %eax,%edi
  802e6c:	48 b8 e3 23 80 00 00 	movabs $0x8023e3,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e7f:	0f 8f 5f ff ff ff    	jg     802de4 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e89:	79 47                	jns    802ed2 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802e8b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e8e:	89 c6                	mov    %eax,%esi
  802e90:	48 bf 2c 4f 80 00 00 	movabs $0x804f2c,%rdi
  802e97:	00 00 00 
  802e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9f:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802ea6:	00 00 00 
  802ea9:	ff d2                	callq  *%rdx
		close(fd_src);
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	89 c7                	mov    %eax,%edi
  802eb0:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
		close(fd_dest);
  802ebc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ebf:	89 c7                	mov    %eax,%edi
  802ec1:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
		return read_size;
  802ecd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ed0:	eb 27                	jmp    802ef9 <copy+0x1db>
	}
	close(fd_src);
  802ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed5:	89 c7                	mov    %eax,%edi
  802ed7:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802ede:	00 00 00 
  802ee1:	ff d0                	callq  *%rax
	close(fd_dest);
  802ee3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ee6:	89 c7                	mov    %eax,%edi
  802ee8:	48 b8 c0 21 80 00 00 	movabs $0x8021c0,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
	return 0;
  802ef4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ef9:	c9                   	leaveq 
  802efa:	c3                   	retq   

0000000000802efb <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802efb:	55                   	push   %rbp
  802efc:	48 89 e5             	mov    %rsp,%rbp
  802eff:	48 83 ec 20          	sub    $0x20,%rsp
  802f03:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802f06:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0d:	48 89 d6             	mov    %rdx,%rsi
  802f10:	89 c7                	mov    %eax,%edi
  802f12:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
  802f1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f25:	79 05                	jns    802f2c <fd2sockid+0x31>
		return r;
  802f27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2a:	eb 24                	jmp    802f50 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f30:	8b 10                	mov    (%rax),%edx
  802f32:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  802f39:	00 00 00 
  802f3c:	8b 00                	mov    (%rax),%eax
  802f3e:	39 c2                	cmp    %eax,%edx
  802f40:	74 07                	je     802f49 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f42:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f47:	eb 07                	jmp    802f50 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f50:	c9                   	leaveq 
  802f51:	c3                   	retq   

0000000000802f52 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f52:	55                   	push   %rbp
  802f53:	48 89 e5             	mov    %rsp,%rbp
  802f56:	48 83 ec 20          	sub    $0x20,%rsp
  802f5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f5d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f61:	48 89 c7             	mov    %rax,%rdi
  802f64:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  802f6b:	00 00 00 
  802f6e:	ff d0                	callq  *%rax
  802f70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f77:	78 26                	js     802f9f <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7d:	ba 07 04 00 00       	mov    $0x407,%edx
  802f82:	48 89 c6             	mov    %rax,%rsi
  802f85:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8a:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
  802f96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9d:	79 16                	jns    802fb5 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 61 34 80 00 00 	movabs $0x803461,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
		return r;
  802fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb3:	eb 3a                	jmp    802fef <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb9:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  802fc0:	00 00 00 
  802fc3:	8b 12                	mov    (%rdx),%edx
  802fc5:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fd9:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe0:	48 89 c7             	mov    %rax,%rdi
  802fe3:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802fea:	00 00 00 
  802fed:	ff d0                	callq  *%rax
}
  802fef:	c9                   	leaveq 
  802ff0:	c3                   	retq   

0000000000802ff1 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ff1:	55                   	push   %rbp
  802ff2:	48 89 e5             	mov    %rsp,%rbp
  802ff5:	48 83 ec 30          	sub    $0x30,%rsp
  802ff9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ffc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803000:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803004:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803007:	89 c7                	mov    %eax,%edi
  803009:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
  803015:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803018:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301c:	79 05                	jns    803023 <accept+0x32>
		return r;
  80301e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803021:	eb 3b                	jmp    80305e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803023:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803027:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80302b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302e:	48 89 ce             	mov    %rcx,%rsi
  803031:	89 c7                	mov    %eax,%edi
  803033:	48 b8 3e 33 80 00 00 	movabs $0x80333e,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
  80303f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803042:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803046:	79 05                	jns    80304d <accept+0x5c>
		return r;
  803048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304b:	eb 11                	jmp    80305e <accept+0x6d>
	return alloc_sockfd(r);
  80304d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803050:	89 c7                	mov    %eax,%edi
  803052:	48 b8 52 2f 80 00 00 	movabs $0x802f52,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 83 ec 20          	sub    $0x20,%rsp
  803068:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80306b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80306f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803072:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803075:	89 c7                	mov    %eax,%edi
  803077:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308a:	79 05                	jns    803091 <bind+0x31>
		return r;
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	eb 1b                	jmp    8030ac <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803091:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803094:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309b:	48 89 ce             	mov    %rcx,%rsi
  80309e:	89 c7                	mov    %eax,%edi
  8030a0:	48 b8 bd 33 80 00 00 	movabs $0x8033bd,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
}
  8030ac:	c9                   	leaveq 
  8030ad:	c3                   	retq   

00000000008030ae <shutdown>:

int
shutdown(int s, int how)
{
  8030ae:	55                   	push   %rbp
  8030af:	48 89 e5             	mov    %rsp,%rbp
  8030b2:	48 83 ec 20          	sub    $0x20,%rsp
  8030b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030b9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030bf:	89 c7                	mov    %eax,%edi
  8030c1:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d4:	79 05                	jns    8030db <shutdown+0x2d>
		return r;
  8030d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d9:	eb 16                	jmp    8030f1 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8030db:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e1:	89 d6                	mov    %edx,%esi
  8030e3:	89 c7                	mov    %eax,%edi
  8030e5:	48 b8 21 34 80 00 00 	movabs $0x803421,%rax
  8030ec:	00 00 00 
  8030ef:	ff d0                	callq  *%rax
}
  8030f1:	c9                   	leaveq 
  8030f2:	c3                   	retq   

00000000008030f3 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8030f3:	55                   	push   %rbp
  8030f4:	48 89 e5             	mov    %rsp,%rbp
  8030f7:	48 83 ec 10          	sub    $0x10,%rsp
  8030fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803103:	48 89 c7             	mov    %rax,%rdi
  803106:	48 b8 51 42 80 00 00 	movabs $0x804251,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
  803112:	83 f8 01             	cmp    $0x1,%eax
  803115:	75 17                	jne    80312e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80311b:	8b 40 0c             	mov    0xc(%rax),%eax
  80311e:	89 c7                	mov    %eax,%edi
  803120:	48 b8 61 34 80 00 00 	movabs $0x803461,%rax
  803127:	00 00 00 
  80312a:	ff d0                	callq  *%rax
  80312c:	eb 05                	jmp    803133 <devsock_close+0x40>
	else
		return 0;
  80312e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803133:	c9                   	leaveq 
  803134:	c3                   	retq   

0000000000803135 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803135:	55                   	push   %rbp
  803136:	48 89 e5             	mov    %rsp,%rbp
  803139:	48 83 ec 20          	sub    $0x20,%rsp
  80313d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803140:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803144:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803147:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80314a:	89 c7                	mov    %eax,%edi
  80314c:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  803153:	00 00 00 
  803156:	ff d0                	callq  *%rax
  803158:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315f:	79 05                	jns    803166 <connect+0x31>
		return r;
  803161:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803164:	eb 1b                	jmp    803181 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803166:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803169:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80316d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803170:	48 89 ce             	mov    %rcx,%rsi
  803173:	89 c7                	mov    %eax,%edi
  803175:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  80317c:	00 00 00 
  80317f:	ff d0                	callq  *%rax
}
  803181:	c9                   	leaveq 
  803182:	c3                   	retq   

0000000000803183 <listen>:

int
listen(int s, int backlog)
{
  803183:	55                   	push   %rbp
  803184:	48 89 e5             	mov    %rsp,%rbp
  803187:	48 83 ec 20          	sub    $0x20,%rsp
  80318b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80318e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803191:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803194:	89 c7                	mov    %eax,%edi
  803196:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  80319d:	00 00 00 
  8031a0:	ff d0                	callq  *%rax
  8031a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a9:	79 05                	jns    8031b0 <listen+0x2d>
		return r;
  8031ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ae:	eb 16                	jmp    8031c6 <listen+0x43>
	return nsipc_listen(r, backlog);
  8031b0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b6:	89 d6                	mov    %edx,%esi
  8031b8:	89 c7                	mov    %eax,%edi
  8031ba:	48 b8 f2 34 80 00 00 	movabs $0x8034f2,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
}
  8031c6:	c9                   	leaveq 
  8031c7:	c3                   	retq   

00000000008031c8 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	48 83 ec 20          	sub    $0x20,%rsp
  8031d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e0:	89 c2                	mov    %eax,%edx
  8031e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031e6:	8b 40 0c             	mov    0xc(%rax),%eax
  8031e9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031f2:	89 c7                	mov    %eax,%edi
  8031f4:	48 b8 32 35 80 00 00 	movabs $0x803532,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
}
  803200:	c9                   	leaveq 
  803201:	c3                   	retq   

0000000000803202 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803202:	55                   	push   %rbp
  803203:	48 89 e5             	mov    %rsp,%rbp
  803206:	48 83 ec 20          	sub    $0x20,%rsp
  80320a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80320e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803212:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321a:	89 c2                	mov    %eax,%edx
  80321c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803220:	8b 40 0c             	mov    0xc(%rax),%eax
  803223:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803227:	b9 00 00 00 00       	mov    $0x0,%ecx
  80322c:	89 c7                	mov    %eax,%edi
  80322e:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  803235:	00 00 00 
  803238:	ff d0                	callq  *%rax
}
  80323a:	c9                   	leaveq 
  80323b:	c3                   	retq   

000000000080323c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80323c:	55                   	push   %rbp
  80323d:	48 89 e5             	mov    %rsp,%rbp
  803240:	48 83 ec 10          	sub    $0x10,%rsp
  803244:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803248:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80324c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803250:	48 be 47 4f 80 00 00 	movabs $0x804f47,%rsi
  803257:	00 00 00 
  80325a:	48 89 c7             	mov    %rax,%rdi
  80325d:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
	return 0;
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326e:	c9                   	leaveq 
  80326f:	c3                   	retq   

0000000000803270 <socket>:

int
socket(int domain, int type, int protocol)
{
  803270:	55                   	push   %rbp
  803271:	48 89 e5             	mov    %rsp,%rbp
  803274:	48 83 ec 20          	sub    $0x20,%rsp
  803278:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80327b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80327e:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803281:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803284:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803287:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80328a:	89 ce                	mov    %ecx,%esi
  80328c:	89 c7                	mov    %eax,%edi
  80328e:	48 b8 b6 36 80 00 00 	movabs $0x8036b6,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
  80329a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80329d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a1:	79 05                	jns    8032a8 <socket+0x38>
		return r;
  8032a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a6:	eb 11                	jmp    8032b9 <socket+0x49>
	return alloc_sockfd(r);
  8032a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ab:	89 c7                	mov    %eax,%edi
  8032ad:	48 b8 52 2f 80 00 00 	movabs $0x802f52,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
}
  8032b9:	c9                   	leaveq 
  8032ba:	c3                   	retq   

00000000008032bb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032bb:	55                   	push   %rbp
  8032bc:	48 89 e5             	mov    %rsp,%rbp
  8032bf:	48 83 ec 10          	sub    $0x10,%rsp
  8032c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8032c6:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032cd:	00 00 00 
  8032d0:	8b 00                	mov    (%rax),%eax
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	75 1f                	jne    8032f5 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032d6:	bf 02 00 00 00       	mov    $0x2,%edi
  8032db:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 c2                	mov    %eax,%edx
  8032e9:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032f0:	00 00 00 
  8032f3:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032f5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032fc:	00 00 00 
  8032ff:	8b 00                	mov    (%rax),%eax
  803301:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803304:	b9 07 00 00 00       	mov    $0x7,%ecx
  803309:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803310:	00 00 00 
  803313:	89 c7                	mov    %eax,%edi
  803315:	48 b8 4b 41 80 00 00 	movabs $0x80414b,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803321:	ba 00 00 00 00       	mov    $0x0,%edx
  803326:	be 00 00 00 00       	mov    $0x0,%esi
  80332b:	bf 00 00 00 00       	mov    $0x0,%edi
  803330:	48 b8 8a 40 80 00 00 	movabs $0x80408a,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
}
  80333c:	c9                   	leaveq 
  80333d:	c3                   	retq   

000000000080333e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80333e:	55                   	push   %rbp
  80333f:	48 89 e5             	mov    %rsp,%rbp
  803342:	48 83 ec 30          	sub    $0x30,%rsp
  803346:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803349:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80334d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803351:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803358:	00 00 00 
  80335b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80335e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803360:	bf 01 00 00 00       	mov    $0x1,%edi
  803365:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803374:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803378:	78 3e                	js     8033b8 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80337a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803381:	00 00 00 
  803384:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338c:	8b 40 10             	mov    0x10(%rax),%eax
  80338f:	89 c2                	mov    %eax,%edx
  803391:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803395:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803399:	48 89 ce             	mov    %rcx,%rsi
  80339c:	48 89 c7             	mov    %rax,%rdi
  80339f:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8033a6:	00 00 00 
  8033a9:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8033ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033af:	8b 50 10             	mov    0x10(%rax),%edx
  8033b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b6:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8033b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033bb:	c9                   	leaveq 
  8033bc:	c3                   	retq   

00000000008033bd <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033bd:	55                   	push   %rbp
  8033be:	48 89 e5             	mov    %rsp,%rbp
  8033c1:	48 83 ec 10          	sub    $0x10,%rsp
  8033c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8033cf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033d6:	00 00 00 
  8033d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033dc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8033de:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e5:	48 89 c6             	mov    %rax,%rsi
  8033e8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8033ef:	00 00 00 
  8033f2:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8033fe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803405:	00 00 00 
  803408:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80340b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80340e:	bf 02 00 00 00       	mov    $0x2,%edi
  803413:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
}
  80341f:	c9                   	leaveq 
  803420:	c3                   	retq   

0000000000803421 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803421:	55                   	push   %rbp
  803422:	48 89 e5             	mov    %rsp,%rbp
  803425:	48 83 ec 10          	sub    $0x10,%rsp
  803429:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80342c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80342f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803436:	00 00 00 
  803439:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80343c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80343e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803445:	00 00 00 
  803448:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80344b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80344e:	bf 03 00 00 00       	mov    $0x3,%edi
  803453:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  80345a:	00 00 00 
  80345d:	ff d0                	callq  *%rax
}
  80345f:	c9                   	leaveq 
  803460:	c3                   	retq   

0000000000803461 <nsipc_close>:

int
nsipc_close(int s)
{
  803461:	55                   	push   %rbp
  803462:	48 89 e5             	mov    %rsp,%rbp
  803465:	48 83 ec 10          	sub    $0x10,%rsp
  803469:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80346c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803473:	00 00 00 
  803476:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803479:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80347b:	bf 04 00 00 00       	mov    $0x4,%edi
  803480:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  803487:	00 00 00 
  80348a:	ff d0                	callq  *%rax
}
  80348c:	c9                   	leaveq 
  80348d:	c3                   	retq   

000000000080348e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80348e:	55                   	push   %rbp
  80348f:	48 89 e5             	mov    %rsp,%rbp
  803492:	48 83 ec 10          	sub    $0x10,%rsp
  803496:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803499:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80349d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8034a0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8034a7:	00 00 00 
  8034aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034ad:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8034af:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	48 89 c6             	mov    %rax,%rsi
  8034b9:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8034c0:	00 00 00 
  8034c3:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8034cf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8034d6:	00 00 00 
  8034d9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034dc:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8034df:	bf 05 00 00 00       	mov    $0x5,%edi
  8034e4:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
}
  8034f0:	c9                   	leaveq 
  8034f1:	c3                   	retq   

00000000008034f2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8034f2:	55                   	push   %rbp
  8034f3:	48 89 e5             	mov    %rsp,%rbp
  8034f6:	48 83 ec 10          	sub    $0x10,%rsp
  8034fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034fd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803500:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803507:	00 00 00 
  80350a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80350d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80350f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803516:	00 00 00 
  803519:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80351c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80351f:	bf 06 00 00 00       	mov    $0x6,%edi
  803524:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
}
  803530:	c9                   	leaveq 
  803531:	c3                   	retq   

0000000000803532 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803532:	55                   	push   %rbp
  803533:	48 89 e5             	mov    %rsp,%rbp
  803536:	48 83 ec 30          	sub    $0x30,%rsp
  80353a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80353d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803541:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803544:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803547:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80354e:	00 00 00 
  803551:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803554:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803556:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80355d:	00 00 00 
  803560:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803563:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803566:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80356d:	00 00 00 
  803570:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803573:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803576:	bf 07 00 00 00       	mov    $0x7,%edi
  80357b:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
  803587:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80358e:	78 69                	js     8035f9 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803590:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803597:	7f 08                	jg     8035a1 <nsipc_recv+0x6f>
  803599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80359f:	7e 35                	jle    8035d6 <nsipc_recv+0xa4>
  8035a1:	48 b9 4e 4f 80 00 00 	movabs $0x804f4e,%rcx
  8035a8:	00 00 00 
  8035ab:	48 ba 63 4f 80 00 00 	movabs $0x804f63,%rdx
  8035b2:	00 00 00 
  8035b5:	be 62 00 00 00       	mov    $0x62,%esi
  8035ba:	48 bf 78 4f 80 00 00 	movabs $0x804f78,%rdi
  8035c1:	00 00 00 
  8035c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c9:	49 b8 76 3f 80 00 00 	movabs $0x803f76,%r8
  8035d0:	00 00 00 
  8035d3:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d9:	48 63 d0             	movslq %eax,%rdx
  8035dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e0:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8035e7:	00 00 00 
  8035ea:	48 89 c7             	mov    %rax,%rdi
  8035ed:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
	}

	return r;
  8035f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035fc:	c9                   	leaveq 
  8035fd:	c3                   	retq   

00000000008035fe <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035fe:	55                   	push   %rbp
  8035ff:	48 89 e5             	mov    %rsp,%rbp
  803602:	48 83 ec 20          	sub    $0x20,%rsp
  803606:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803609:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80360d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803610:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803613:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80361a:	00 00 00 
  80361d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803620:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803622:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803629:	7e 35                	jle    803660 <nsipc_send+0x62>
  80362b:	48 b9 84 4f 80 00 00 	movabs $0x804f84,%rcx
  803632:	00 00 00 
  803635:	48 ba 63 4f 80 00 00 	movabs $0x804f63,%rdx
  80363c:	00 00 00 
  80363f:	be 6d 00 00 00       	mov    $0x6d,%esi
  803644:	48 bf 78 4f 80 00 00 	movabs $0x804f78,%rdi
  80364b:	00 00 00 
  80364e:	b8 00 00 00 00       	mov    $0x0,%eax
  803653:	49 b8 76 3f 80 00 00 	movabs $0x803f76,%r8
  80365a:	00 00 00 
  80365d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803660:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803663:	48 63 d0             	movslq %eax,%rdx
  803666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366a:	48 89 c6             	mov    %rax,%rsi
  80366d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803674:	00 00 00 
  803677:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803683:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80368a:	00 00 00 
  80368d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803690:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803693:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80369a:	00 00 00 
  80369d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036a0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8036a3:	bf 08 00 00 00       	mov    $0x8,%edi
  8036a8:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
}
  8036b4:	c9                   	leaveq 
  8036b5:	c3                   	retq   

00000000008036b6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8036b6:	55                   	push   %rbp
  8036b7:	48 89 e5             	mov    %rsp,%rbp
  8036ba:	48 83 ec 10          	sub    $0x10,%rsp
  8036be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036c1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8036c4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8036c7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036ce:	00 00 00 
  8036d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8036d6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036dd:	00 00 00 
  8036e0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8036e6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036ed:	00 00 00 
  8036f0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8036f3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8036f6:	bf 09 00 00 00       	mov    $0x9,%edi
  8036fb:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  803702:	00 00 00 
  803705:	ff d0                	callq  *%rax
}
  803707:	c9                   	leaveq 
  803708:	c3                   	retq   

0000000000803709 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803709:	55                   	push   %rbp
  80370a:	48 89 e5             	mov    %rsp,%rbp
  80370d:	53                   	push   %rbx
  80370e:	48 83 ec 38          	sub    $0x38,%rsp
  803712:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803716:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80371a:	48 89 c7             	mov    %rax,%rdi
  80371d:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80372c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803730:	0f 88 bf 01 00 00    	js     8038f5 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373a:	ba 07 04 00 00       	mov    $0x407,%edx
  80373f:	48 89 c6             	mov    %rax,%rsi
  803742:	bf 00 00 00 00       	mov    $0x0,%edi
  803747:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
  803753:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803756:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80375a:	0f 88 95 01 00 00    	js     8038f5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803760:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803764:	48 89 c7             	mov    %rax,%rdi
  803767:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
  803773:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803776:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80377a:	0f 88 5d 01 00 00    	js     8038dd <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803784:	ba 07 04 00 00       	mov    $0x407,%edx
  803789:	48 89 c6             	mov    %rax,%rsi
  80378c:	bf 00 00 00 00       	mov    $0x0,%edi
  803791:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
  80379d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037a4:	0f 88 33 01 00 00    	js     8038dd <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ae:	48 89 c7             	mov    %rax,%rdi
  8037b1:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
  8037bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c5:	ba 07 04 00 00       	mov    $0x407,%edx
  8037ca:	48 89 c6             	mov    %rax,%rsi
  8037cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d2:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
  8037de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037e5:	0f 88 d9 00 00 00    	js     8038c4 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ef:	48 89 c7             	mov    %rax,%rdi
  8037f2:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
  8037fe:	48 89 c2             	mov    %rax,%rdx
  803801:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803805:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80380b:	48 89 d1             	mov    %rdx,%rcx
  80380e:	ba 00 00 00 00       	mov    $0x0,%edx
  803813:	48 89 c6             	mov    %rax,%rsi
  803816:	bf 00 00 00 00       	mov    $0x0,%edi
  80381b:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
  803827:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80382a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80382e:	78 79                	js     8038a9 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803834:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80383b:	00 00 00 
  80383e:	8b 12                	mov    (%rdx),%edx
  803840:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803846:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80384d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803851:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803858:	00 00 00 
  80385b:	8b 12                	mov    (%rdx),%edx
  80385d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80385f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803863:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80386a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80386e:	48 89 c7             	mov    %rax,%rdi
  803871:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
  80387d:	89 c2                	mov    %eax,%edx
  80387f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803883:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803885:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803889:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80388d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803891:	48 89 c7             	mov    %rax,%rdi
  803894:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80389b:	00 00 00 
  80389e:	ff d0                	callq  *%rax
  8038a0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a7:	eb 4f                	jmp    8038f8 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8038a9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ae:	48 89 c6             	mov    %rax,%rsi
  8038b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b6:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
  8038c2:	eb 01                	jmp    8038c5 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8038c4:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8038c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c9:	48 89 c6             	mov    %rax,%rsi
  8038cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d1:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8038dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e1:	48 89 c6             	mov    %rax,%rsi
  8038e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e9:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
err:
	return r;
  8038f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038f8:	48 83 c4 38          	add    $0x38,%rsp
  8038fc:	5b                   	pop    %rbx
  8038fd:	5d                   	pop    %rbp
  8038fe:	c3                   	retq   

00000000008038ff <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038ff:	55                   	push   %rbp
  803900:	48 89 e5             	mov    %rsp,%rbp
  803903:	53                   	push   %rbx
  803904:	48 83 ec 28          	sub    $0x28,%rsp
  803908:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80390c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803910:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803917:	00 00 00 
  80391a:	48 8b 00             	mov    (%rax),%rax
  80391d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803923:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392a:	48 89 c7             	mov    %rax,%rdi
  80392d:	48 b8 51 42 80 00 00 	movabs $0x804251,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
  803939:	89 c3                	mov    %eax,%ebx
  80393b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393f:	48 89 c7             	mov    %rax,%rdi
  803942:	48 b8 51 42 80 00 00 	movabs $0x804251,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
  80394e:	39 c3                	cmp    %eax,%ebx
  803950:	0f 94 c0             	sete   %al
  803953:	0f b6 c0             	movzbl %al,%eax
  803956:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803959:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803960:	00 00 00 
  803963:	48 8b 00             	mov    (%rax),%rax
  803966:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80396c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80396f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803972:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803975:	75 05                	jne    80397c <_pipeisclosed+0x7d>
			return ret;
  803977:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80397a:	eb 4a                	jmp    8039c6 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80397c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80397f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803982:	74 8c                	je     803910 <_pipeisclosed+0x11>
  803984:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803988:	75 86                	jne    803910 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80398a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803991:	00 00 00 
  803994:	48 8b 00             	mov    (%rax),%rax
  803997:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80399d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039a3:	89 c6                	mov    %eax,%esi
  8039a5:	48 bf 95 4f 80 00 00 	movabs $0x804f95,%rdi
  8039ac:	00 00 00 
  8039af:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b4:	49 b8 0a 05 80 00 00 	movabs $0x80050a,%r8
  8039bb:	00 00 00 
  8039be:	41 ff d0             	callq  *%r8
	}
  8039c1:	e9 4a ff ff ff       	jmpq   803910 <_pipeisclosed+0x11>

}
  8039c6:	48 83 c4 28          	add    $0x28,%rsp
  8039ca:	5b                   	pop    %rbx
  8039cb:	5d                   	pop    %rbp
  8039cc:	c3                   	retq   

00000000008039cd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8039cd:	55                   	push   %rbp
  8039ce:	48 89 e5             	mov    %rsp,%rbp
  8039d1:	48 83 ec 30          	sub    $0x30,%rsp
  8039d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039d8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039df:	48 89 d6             	mov    %rdx,%rsi
  8039e2:	89 c7                	mov    %eax,%edi
  8039e4:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
  8039f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f7:	79 05                	jns    8039fe <pipeisclosed+0x31>
		return r;
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	eb 31                	jmp    803a2f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a02:	48 89 c7             	mov    %rax,%rdi
  803a05:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  803a0c:	00 00 00 
  803a0f:	ff d0                	callq  *%rax
  803a11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a1d:	48 89 d6             	mov    %rdx,%rsi
  803a20:	48 89 c7             	mov    %rax,%rdi
  803a23:	48 b8 ff 38 80 00 00 	movabs $0x8038ff,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
}
  803a2f:	c9                   	leaveq 
  803a30:	c3                   	retq   

0000000000803a31 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a31:	55                   	push   %rbp
  803a32:	48 89 e5             	mov    %rsp,%rbp
  803a35:	48 83 ec 40          	sub    $0x40,%rsp
  803a39:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a3d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a41:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a49:	48 89 c7             	mov    %rax,%rdi
  803a4c:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  803a53:	00 00 00 
  803a56:	ff d0                	callq  *%rax
  803a58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a64:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a6b:	00 
  803a6c:	e9 90 00 00 00       	jmpq   803b01 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a71:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a76:	74 09                	je     803a81 <devpipe_read+0x50>
				return i;
  803a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a7c:	e9 8e 00 00 00       	jmpq   803b0f <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a89:	48 89 d6             	mov    %rdx,%rsi
  803a8c:	48 89 c7             	mov    %rax,%rdi
  803a8f:	48 b8 ff 38 80 00 00 	movabs $0x8038ff,%rax
  803a96:	00 00 00 
  803a99:	ff d0                	callq  *%rax
  803a9b:	85 c0                	test   %eax,%eax
  803a9d:	74 07                	je     803aa6 <devpipe_read+0x75>
				return 0;
  803a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa4:	eb 69                	jmp    803b0f <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803aa6:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803ab2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab6:	8b 10                	mov    (%rax),%edx
  803ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abc:	8b 40 04             	mov    0x4(%rax),%eax
  803abf:	39 c2                	cmp    %eax,%edx
  803ac1:	74 ae                	je     803a71 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ac3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ac7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803acb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803acf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad3:	8b 00                	mov    (%rax),%eax
  803ad5:	99                   	cltd   
  803ad6:	c1 ea 1b             	shr    $0x1b,%edx
  803ad9:	01 d0                	add    %edx,%eax
  803adb:	83 e0 1f             	and    $0x1f,%eax
  803ade:	29 d0                	sub    %edx,%eax
  803ae0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae4:	48 98                	cltq   
  803ae6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803aeb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af1:	8b 00                	mov    (%rax),%eax
  803af3:	8d 50 01             	lea    0x1(%rax),%edx
  803af6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803afa:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803afc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b05:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b09:	72 a7                	jb     803ab2 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803b0f:	c9                   	leaveq 
  803b10:	c3                   	retq   

0000000000803b11 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b11:	55                   	push   %rbp
  803b12:	48 89 e5             	mov    %rsp,%rbp
  803b15:	48 83 ec 40          	sub    $0x40,%rsp
  803b19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b29:	48 89 c7             	mov    %rax,%rdi
  803b2c:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  803b33:	00 00 00 
  803b36:	ff d0                	callq  *%rax
  803b38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b4b:	00 
  803b4c:	e9 8f 00 00 00       	jmpq   803be0 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b59:	48 89 d6             	mov    %rdx,%rsi
  803b5c:	48 89 c7             	mov    %rax,%rdi
  803b5f:	48 b8 ff 38 80 00 00 	movabs $0x8038ff,%rax
  803b66:	00 00 00 
  803b69:	ff d0                	callq  *%rax
  803b6b:	85 c0                	test   %eax,%eax
  803b6d:	74 07                	je     803b76 <devpipe_write+0x65>
				return 0;
  803b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b74:	eb 78                	jmp    803bee <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b76:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b86:	8b 40 04             	mov    0x4(%rax),%eax
  803b89:	48 63 d0             	movslq %eax,%rdx
  803b8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b90:	8b 00                	mov    (%rax),%eax
  803b92:	48 98                	cltq   
  803b94:	48 83 c0 20          	add    $0x20,%rax
  803b98:	48 39 c2             	cmp    %rax,%rdx
  803b9b:	73 b4                	jae    803b51 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba1:	8b 40 04             	mov    0x4(%rax),%eax
  803ba4:	99                   	cltd   
  803ba5:	c1 ea 1b             	shr    $0x1b,%edx
  803ba8:	01 d0                	add    %edx,%eax
  803baa:	83 e0 1f             	and    $0x1f,%eax
  803bad:	29 d0                	sub    %edx,%eax
  803baf:	89 c6                	mov    %eax,%esi
  803bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb9:	48 01 d0             	add    %rdx,%rax
  803bbc:	0f b6 08             	movzbl (%rax),%ecx
  803bbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bc3:	48 63 c6             	movslq %esi,%rax
  803bc6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803bca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bce:	8b 40 04             	mov    0x4(%rax),%eax
  803bd1:	8d 50 01             	lea    0x1(%rax),%edx
  803bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bdb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803be0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803be8:	72 98                	jb     803b82 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803bea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803bee:	c9                   	leaveq 
  803bef:	c3                   	retq   

0000000000803bf0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 20          	sub    $0x20,%rsp
  803bf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c04:	48 89 c7             	mov    %rax,%rdi
  803c07:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  803c0e:	00 00 00 
  803c11:	ff d0                	callq  *%rax
  803c13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c1b:	48 be a8 4f 80 00 00 	movabs $0x804fa8,%rsi
  803c22:	00 00 00 
  803c25:	48 89 c7             	mov    %rax,%rdi
  803c28:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  803c2f:	00 00 00 
  803c32:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c38:	8b 50 04             	mov    0x4(%rax),%edx
  803c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3f:	8b 00                	mov    (%rax),%eax
  803c41:	29 c2                	sub    %eax,%edx
  803c43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c47:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c51:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c58:	00 00 00 
	stat->st_dev = &devpipe;
  803c5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c5f:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  803c66:	00 00 00 
  803c69:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c75:	c9                   	leaveq 
  803c76:	c3                   	retq   

0000000000803c77 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c77:	55                   	push   %rbp
  803c78:	48 89 e5             	mov    %rsp,%rbp
  803c7b:	48 83 ec 10          	sub    $0x10,%rsp
  803c7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c87:	48 89 c6             	mov    %rax,%rsi
  803c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c8f:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c9f:	48 89 c7             	mov    %rax,%rdi
  803ca2:	48 b8 eb 1e 80 00 00 	movabs $0x801eeb,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
  803cae:	48 89 c6             	mov    %rax,%rsi
  803cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb6:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
}
  803cc2:	c9                   	leaveq 
  803cc3:	c3                   	retq   

0000000000803cc4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803cc4:	55                   	push   %rbp
  803cc5:	48 89 e5             	mov    %rsp,%rbp
  803cc8:	48 83 ec 20          	sub    $0x20,%rsp
  803ccc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ccf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803cd5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803cd9:	be 01 00 00 00       	mov    $0x1,%esi
  803cde:	48 89 c7             	mov    %rax,%rdi
  803ce1:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  803ce8:	00 00 00 
  803ceb:	ff d0                	callq  *%rax
}
  803ced:	90                   	nop
  803cee:	c9                   	leaveq 
  803cef:	c3                   	retq   

0000000000803cf0 <getchar>:

int
getchar(void)
{
  803cf0:	55                   	push   %rbp
  803cf1:	48 89 e5             	mov    %rsp,%rbp
  803cf4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803cf8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803cfc:	ba 01 00 00 00       	mov    $0x1,%edx
  803d01:	48 89 c6             	mov    %rax,%rsi
  803d04:	bf 00 00 00 00       	mov    $0x0,%edi
  803d09:	48 b8 e3 23 80 00 00 	movabs $0x8023e3,%rax
  803d10:	00 00 00 
  803d13:	ff d0                	callq  *%rax
  803d15:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1c:	79 05                	jns    803d23 <getchar+0x33>
		return r;
  803d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d21:	eb 14                	jmp    803d37 <getchar+0x47>
	if (r < 1)
  803d23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d27:	7f 07                	jg     803d30 <getchar+0x40>
		return -E_EOF;
  803d29:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d2e:	eb 07                	jmp    803d37 <getchar+0x47>
	return c;
  803d30:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d34:	0f b6 c0             	movzbl %al,%eax

}
  803d37:	c9                   	leaveq 
  803d38:	c3                   	retq   

0000000000803d39 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d39:	55                   	push   %rbp
  803d3a:	48 89 e5             	mov    %rsp,%rbp
  803d3d:	48 83 ec 20          	sub    $0x20,%rsp
  803d41:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d4b:	48 89 d6             	mov    %rdx,%rsi
  803d4e:	89 c7                	mov    %eax,%edi
  803d50:	48 b8 ae 1f 80 00 00 	movabs $0x801fae,%rax
  803d57:	00 00 00 
  803d5a:	ff d0                	callq  *%rax
  803d5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d63:	79 05                	jns    803d6a <iscons+0x31>
		return r;
  803d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d68:	eb 1a                	jmp    803d84 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6e:	8b 10                	mov    (%rax),%edx
  803d70:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803d77:	00 00 00 
  803d7a:	8b 00                	mov    (%rax),%eax
  803d7c:	39 c2                	cmp    %eax,%edx
  803d7e:	0f 94 c0             	sete   %al
  803d81:	0f b6 c0             	movzbl %al,%eax
}
  803d84:	c9                   	leaveq 
  803d85:	c3                   	retq   

0000000000803d86 <opencons>:

int
opencons(void)
{
  803d86:	55                   	push   %rbp
  803d87:	48 89 e5             	mov    %rsp,%rbp
  803d8a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d92:	48 89 c7             	mov    %rax,%rdi
  803d95:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  803d9c:	00 00 00 
  803d9f:	ff d0                	callq  *%rax
  803da1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da8:	79 05                	jns    803daf <opencons+0x29>
		return r;
  803daa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dad:	eb 5b                	jmp    803e0a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db3:	ba 07 04 00 00       	mov    $0x407,%edx
  803db8:	48 89 c6             	mov    %rax,%rsi
  803dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc0:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803dc7:	00 00 00 
  803dca:	ff d0                	callq  *%rax
  803dcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd3:	79 05                	jns    803dda <opencons+0x54>
		return r;
  803dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd8:	eb 30                	jmp    803e0a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dde:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  803de5:	00 00 00 
  803de8:	8b 12                	mov    (%rdx),%edx
  803dea:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfb:	48 89 c7             	mov    %rax,%rdi
  803dfe:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  803e05:	00 00 00 
  803e08:	ff d0                	callq  *%rax
}
  803e0a:	c9                   	leaveq 
  803e0b:	c3                   	retq   

0000000000803e0c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e0c:	55                   	push   %rbp
  803e0d:	48 89 e5             	mov    %rsp,%rbp
  803e10:	48 83 ec 30          	sub    $0x30,%rsp
  803e14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e20:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e25:	75 13                	jne    803e3a <devcons_read+0x2e>
		return 0;
  803e27:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2c:	eb 49                	jmp    803e77 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e2e:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803e35:	00 00 00 
  803e38:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e3a:	48 b8 d5 18 80 00 00 	movabs $0x8018d5,%rax
  803e41:	00 00 00 
  803e44:	ff d0                	callq  *%rax
  803e46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e4d:	74 df                	je     803e2e <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803e4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e53:	79 05                	jns    803e5a <devcons_read+0x4e>
		return c;
  803e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e58:	eb 1d                	jmp    803e77 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803e5a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803e5e:	75 07                	jne    803e67 <devcons_read+0x5b>
		return 0;
  803e60:	b8 00 00 00 00       	mov    $0x0,%eax
  803e65:	eb 10                	jmp    803e77 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6a:	89 c2                	mov    %eax,%edx
  803e6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e70:	88 10                	mov    %dl,(%rax)
	return 1;
  803e72:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e77:	c9                   	leaveq 
  803e78:	c3                   	retq   

0000000000803e79 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e79:	55                   	push   %rbp
  803e7a:	48 89 e5             	mov    %rsp,%rbp
  803e7d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e84:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e8b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e92:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ea0:	eb 76                	jmp    803f18 <devcons_write+0x9f>
		m = n - tot;
  803ea2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ea9:	89 c2                	mov    %eax,%edx
  803eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eae:	29 c2                	sub    %eax,%edx
  803eb0:	89 d0                	mov    %edx,%eax
  803eb2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803eb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eb8:	83 f8 7f             	cmp    $0x7f,%eax
  803ebb:	76 07                	jbe    803ec4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ebd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ec4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec7:	48 63 d0             	movslq %eax,%rdx
  803eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ecd:	48 63 c8             	movslq %eax,%rcx
  803ed0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ed7:	48 01 c1             	add    %rax,%rcx
  803eda:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ee1:	48 89 ce             	mov    %rcx,%rsi
  803ee4:	48 89 c7             	mov    %rax,%rdi
  803ee7:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  803eee:	00 00 00 
  803ef1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ef3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ef6:	48 63 d0             	movslq %eax,%rdx
  803ef9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f00:	48 89 d6             	mov    %rdx,%rsi
  803f03:	48 89 c7             	mov    %rax,%rdi
  803f06:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  803f0d:	00 00 00 
  803f10:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f15:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1b:	48 98                	cltq   
  803f1d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f24:	0f 82 78 ff ff ff    	jb     803ea2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f2d:	c9                   	leaveq 
  803f2e:	c3                   	retq   

0000000000803f2f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f2f:	55                   	push   %rbp
  803f30:	48 89 e5             	mov    %rsp,%rbp
  803f33:	48 83 ec 08          	sub    $0x8,%rsp
  803f37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f40:	c9                   	leaveq 
  803f41:	c3                   	retq   

0000000000803f42 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f42:	55                   	push   %rbp
  803f43:	48 89 e5             	mov    %rsp,%rbp
  803f46:	48 83 ec 10          	sub    $0x10,%rsp
  803f4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f56:	48 be b4 4f 80 00 00 	movabs $0x804fb4,%rsi
  803f5d:	00 00 00 
  803f60:	48 89 c7             	mov    %rax,%rdi
  803f63:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  803f6a:	00 00 00 
  803f6d:	ff d0                	callq  *%rax
	return 0;
  803f6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f74:	c9                   	leaveq 
  803f75:	c3                   	retq   

0000000000803f76 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803f76:	55                   	push   %rbp
  803f77:	48 89 e5             	mov    %rsp,%rbp
  803f7a:	53                   	push   %rbx
  803f7b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803f82:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803f89:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803f8f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f96:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803f9d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803fa4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803fab:	84 c0                	test   %al,%al
  803fad:	74 23                	je     803fd2 <_panic+0x5c>
  803faf:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803fb6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803fba:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803fbe:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803fc2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803fc6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803fca:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803fce:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803fd2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803fd9:	00 00 00 
  803fdc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803fe3:	00 00 00 
  803fe6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803fea:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803ff1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803ff8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803fff:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  804006:	00 00 00 
  804009:	48 8b 18             	mov    (%rax),%rbx
  80400c:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 c6                	mov    %eax,%esi
  80401a:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  804020:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804027:	41 89 d0             	mov    %edx,%r8d
  80402a:	48 89 c1             	mov    %rax,%rcx
  80402d:	48 89 da             	mov    %rbx,%rdx
  804030:	48 bf c0 4f 80 00 00 	movabs $0x804fc0,%rdi
  804037:	00 00 00 
  80403a:	b8 00 00 00 00       	mov    $0x0,%eax
  80403f:	49 b9 0a 05 80 00 00 	movabs $0x80050a,%r9
  804046:	00 00 00 
  804049:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80404c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804053:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80405a:	48 89 d6             	mov    %rdx,%rsi
  80405d:	48 89 c7             	mov    %rax,%rdi
  804060:	48 b8 5e 04 80 00 00 	movabs $0x80045e,%rax
  804067:	00 00 00 
  80406a:	ff d0                	callq  *%rax
	cprintf("\n");
  80406c:	48 bf e3 4f 80 00 00 	movabs $0x804fe3,%rdi
  804073:	00 00 00 
  804076:	b8 00 00 00 00       	mov    $0x0,%eax
  80407b:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  804082:	00 00 00 
  804085:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804087:	cc                   	int3   
  804088:	eb fd                	jmp    804087 <_panic+0x111>

000000000080408a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80408a:	55                   	push   %rbp
  80408b:	48 89 e5             	mov    %rsp,%rbp
  80408e:	48 83 ec 30          	sub    $0x30,%rsp
  804092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80409a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80409e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040a3:	75 0e                	jne    8040b3 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8040a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040ac:	00 00 00 
  8040af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8040b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b7:	48 89 c7             	mov    %rax,%rdi
  8040ba:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  8040c1:	00 00 00 
  8040c4:	ff d0                	callq  *%rax
  8040c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040cd:	79 27                	jns    8040f6 <ipc_recv+0x6c>
		if (from_env_store)
  8040cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040d4:	74 0a                	je     8040e0 <ipc_recv+0x56>
			*from_env_store = 0;
  8040d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040da:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8040e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040e5:	74 0a                	je     8040f1 <ipc_recv+0x67>
			*perm_store = 0;
  8040e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040eb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8040f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f4:	eb 53                	jmp    804149 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8040f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040fb:	74 19                	je     804116 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8040fd:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804104:	00 00 00 
  804107:	48 8b 00             	mov    (%rax),%rax
  80410a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804114:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804116:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80411b:	74 19                	je     804136 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80411d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804124:	00 00 00 
  804127:	48 8b 00             	mov    (%rax),%rax
  80412a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804130:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804134:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804136:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80413d:	00 00 00 
  804140:	48 8b 00             	mov    (%rax),%rax
  804143:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804149:	c9                   	leaveq 
  80414a:	c3                   	retq   

000000000080414b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80414b:	55                   	push   %rbp
  80414c:	48 89 e5             	mov    %rsp,%rbp
  80414f:	48 83 ec 30          	sub    $0x30,%rsp
  804153:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804156:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804159:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80415d:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804160:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804165:	75 1c                	jne    804183 <ipc_send+0x38>
		pg = (void*) UTOP;
  804167:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80416e:	00 00 00 
  804171:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804175:	eb 0c                	jmp    804183 <ipc_send+0x38>
		sys_yield();
  804177:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  80417e:	00 00 00 
  804181:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804183:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804186:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804189:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80418d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804190:	89 c7                	mov    %eax,%edi
  804192:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  804199:	00 00 00 
  80419c:	ff d0                	callq  *%rax
  80419e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041a1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041a5:	74 d0                	je     804177 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8041a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ab:	79 30                	jns    8041dd <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8041ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b0:	89 c1                	mov    %eax,%ecx
  8041b2:	48 ba e5 4f 80 00 00 	movabs $0x804fe5,%rdx
  8041b9:	00 00 00 
  8041bc:	be 47 00 00 00       	mov    $0x47,%esi
  8041c1:	48 bf fb 4f 80 00 00 	movabs $0x804ffb,%rdi
  8041c8:	00 00 00 
  8041cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d0:	49 b8 76 3f 80 00 00 	movabs $0x803f76,%r8
  8041d7:	00 00 00 
  8041da:	41 ff d0             	callq  *%r8

}
  8041dd:	90                   	nop
  8041de:	c9                   	leaveq 
  8041df:	c3                   	retq   

00000000008041e0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041e0:	55                   	push   %rbp
  8041e1:	48 89 e5             	mov    %rsp,%rbp
  8041e4:	48 83 ec 18          	sub    $0x18,%rsp
  8041e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041f2:	eb 4d                	jmp    804241 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8041f4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041fb:	00 00 00 
  8041fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804201:	48 98                	cltq   
  804203:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80420a:	48 01 d0             	add    %rdx,%rax
  80420d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804213:	8b 00                	mov    (%rax),%eax
  804215:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804218:	75 23                	jne    80423d <ipc_find_env+0x5d>
			return envs[i].env_id;
  80421a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804221:	00 00 00 
  804224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804227:	48 98                	cltq   
  804229:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804230:	48 01 d0             	add    %rdx,%rax
  804233:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804239:	8b 00                	mov    (%rax),%eax
  80423b:	eb 12                	jmp    80424f <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80423d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804241:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804248:	7e aa                	jle    8041f4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80424a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80424f:	c9                   	leaveq 
  804250:	c3                   	retq   

0000000000804251 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804251:	55                   	push   %rbp
  804252:	48 89 e5             	mov    %rsp,%rbp
  804255:	48 83 ec 18          	sub    $0x18,%rsp
  804259:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80425d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804261:	48 c1 e8 15          	shr    $0x15,%rax
  804265:	48 89 c2             	mov    %rax,%rdx
  804268:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80426f:	01 00 00 
  804272:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804276:	83 e0 01             	and    $0x1,%eax
  804279:	48 85 c0             	test   %rax,%rax
  80427c:	75 07                	jne    804285 <pageref+0x34>
		return 0;
  80427e:	b8 00 00 00 00       	mov    $0x0,%eax
  804283:	eb 56                	jmp    8042db <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804289:	48 c1 e8 0c          	shr    $0xc,%rax
  80428d:	48 89 c2             	mov    %rax,%rdx
  804290:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804297:	01 00 00 
  80429a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80429e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a6:	83 e0 01             	and    $0x1,%eax
  8042a9:	48 85 c0             	test   %rax,%rax
  8042ac:	75 07                	jne    8042b5 <pageref+0x64>
		return 0;
  8042ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8042b3:	eb 26                	jmp    8042db <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8042b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8042bd:	48 89 c2             	mov    %rax,%rdx
  8042c0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042c7:	00 00 00 
  8042ca:	48 c1 e2 04          	shl    $0x4,%rdx
  8042ce:	48 01 d0             	add    %rdx,%rax
  8042d1:	48 83 c0 08          	add    $0x8,%rax
  8042d5:	0f b7 00             	movzwl (%rax),%eax
  8042d8:	0f b7 c0             	movzwl %ax,%eax
}
  8042db:	c9                   	leaveq 
  8042dc:	c3                   	retq   

00000000008042dd <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8042dd:	55                   	push   %rbp
  8042de:	48 89 e5             	mov    %rsp,%rbp
  8042e1:	48 83 ec 20          	sub    $0x20,%rsp
  8042e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8042e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042f1:	48 89 d6             	mov    %rdx,%rsi
  8042f4:	48 89 c7             	mov    %rax,%rdi
  8042f7:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  8042fe:	00 00 00 
  804301:	ff d0                	callq  *%rax
  804303:	85 c0                	test   %eax,%eax
  804305:	74 05                	je     80430c <inet_addr+0x2f>
    return (val.s_addr);
  804307:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80430a:	eb 05                	jmp    804311 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  80430c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804311:	c9                   	leaveq 
  804312:	c3                   	retq   

0000000000804313 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804313:	55                   	push   %rbp
  804314:	48 89 e5             	mov    %rsp,%rbp
  804317:	48 83 ec 40          	sub    $0x40,%rsp
  80431b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80431f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804323:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804327:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  80432b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80432f:	0f b6 00             	movzbl (%rax),%eax
  804332:	0f be c0             	movsbl %al,%eax
  804335:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804338:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80433b:	0f b6 c0             	movzbl %al,%eax
  80433e:	83 f8 2f             	cmp    $0x2f,%eax
  804341:	7e 0b                	jle    80434e <inet_aton+0x3b>
  804343:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804346:	0f b6 c0             	movzbl %al,%eax
  804349:	83 f8 39             	cmp    $0x39,%eax
  80434c:	7e 0a                	jle    804358 <inet_aton+0x45>
      return (0);
  80434e:	b8 00 00 00 00       	mov    $0x0,%eax
  804353:	e9 a1 02 00 00       	jmpq   8045f9 <inet_aton+0x2e6>
    val = 0;
  804358:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  80435f:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804366:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  80436a:	75 40                	jne    8043ac <inet_aton+0x99>
      c = *++cp;
  80436c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804371:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804375:	0f b6 00             	movzbl (%rax),%eax
  804378:	0f be c0             	movsbl %al,%eax
  80437b:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80437e:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804382:	74 06                	je     80438a <inet_aton+0x77>
  804384:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804388:	75 1b                	jne    8043a5 <inet_aton+0x92>
        base = 16;
  80438a:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804391:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804396:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80439a:	0f b6 00             	movzbl (%rax),%eax
  80439d:	0f be c0             	movsbl %al,%eax
  8043a0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8043a3:	eb 07                	jmp    8043ac <inet_aton+0x99>
      } else
        base = 8;
  8043a5:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  8043ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043af:	0f b6 c0             	movzbl %al,%eax
  8043b2:	83 f8 2f             	cmp    $0x2f,%eax
  8043b5:	7e 36                	jle    8043ed <inet_aton+0xda>
  8043b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043ba:	0f b6 c0             	movzbl %al,%eax
  8043bd:	83 f8 39             	cmp    $0x39,%eax
  8043c0:	7f 2b                	jg     8043ed <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  8043c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043c5:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  8043c9:	89 c2                	mov    %eax,%edx
  8043cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043ce:	01 d0                	add    %edx,%eax
  8043d0:	83 e8 30             	sub    $0x30,%eax
  8043d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8043d6:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8043db:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043df:	0f b6 00             	movzbl (%rax),%eax
  8043e2:	0f be c0             	movsbl %al,%eax
  8043e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8043e8:	e9 97 00 00 00       	jmpq   804484 <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  8043ed:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  8043f1:	0f 85 92 00 00 00    	jne    804489 <inet_aton+0x176>
  8043f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043fa:	0f b6 c0             	movzbl %al,%eax
  8043fd:	83 f8 2f             	cmp    $0x2f,%eax
  804400:	7e 0b                	jle    80440d <inet_aton+0xfa>
  804402:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804405:	0f b6 c0             	movzbl %al,%eax
  804408:	83 f8 39             	cmp    $0x39,%eax
  80440b:	7e 2c                	jle    804439 <inet_aton+0x126>
  80440d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804410:	0f b6 c0             	movzbl %al,%eax
  804413:	83 f8 60             	cmp    $0x60,%eax
  804416:	7e 0b                	jle    804423 <inet_aton+0x110>
  804418:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80441b:	0f b6 c0             	movzbl %al,%eax
  80441e:	83 f8 66             	cmp    $0x66,%eax
  804421:	7e 16                	jle    804439 <inet_aton+0x126>
  804423:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804426:	0f b6 c0             	movzbl %al,%eax
  804429:	83 f8 40             	cmp    $0x40,%eax
  80442c:	7e 5b                	jle    804489 <inet_aton+0x176>
  80442e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804431:	0f b6 c0             	movzbl %al,%eax
  804434:	83 f8 46             	cmp    $0x46,%eax
  804437:	7f 50                	jg     804489 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80443c:	c1 e0 04             	shl    $0x4,%eax
  80443f:	89 c2                	mov    %eax,%edx
  804441:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804444:	8d 48 0a             	lea    0xa(%rax),%ecx
  804447:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80444a:	0f b6 c0             	movzbl %al,%eax
  80444d:	83 f8 60             	cmp    $0x60,%eax
  804450:	7e 12                	jle    804464 <inet_aton+0x151>
  804452:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804455:	0f b6 c0             	movzbl %al,%eax
  804458:	83 f8 7a             	cmp    $0x7a,%eax
  80445b:	7f 07                	jg     804464 <inet_aton+0x151>
  80445d:	b8 61 00 00 00       	mov    $0x61,%eax
  804462:	eb 05                	jmp    804469 <inet_aton+0x156>
  804464:	b8 41 00 00 00       	mov    $0x41,%eax
  804469:	29 c1                	sub    %eax,%ecx
  80446b:	89 c8                	mov    %ecx,%eax
  80446d:	09 d0                	or     %edx,%eax
  80446f:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804472:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804477:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80447b:	0f b6 00             	movzbl (%rax),%eax
  80447e:	0f be c0             	movsbl %al,%eax
  804481:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  804484:	e9 23 ff ff ff       	jmpq   8043ac <inet_aton+0x99>
    if (c == '.') {
  804489:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  80448d:	75 40                	jne    8044cf <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80448f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804493:	48 83 c0 0c          	add    $0xc,%rax
  804497:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80449b:	77 0a                	ja     8044a7 <inet_aton+0x194>
        return (0);
  80449d:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a2:	e9 52 01 00 00       	jmpq   8045f9 <inet_aton+0x2e6>
      *pp++ = val;
  8044a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ab:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8044af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8044b3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044b6:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8044b8:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8044bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044c1:	0f b6 00             	movzbl (%rax),%eax
  8044c4:	0f be c0             	movsbl %al,%eax
  8044c7:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8044ca:	e9 69 fe ff ff       	jmpq   804338 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8044cf:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8044d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8044d4:	74 44                	je     80451a <inet_aton+0x207>
  8044d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044d9:	0f b6 c0             	movzbl %al,%eax
  8044dc:	83 f8 1f             	cmp    $0x1f,%eax
  8044df:	7e 2f                	jle    804510 <inet_aton+0x1fd>
  8044e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044e4:	0f b6 c0             	movzbl %al,%eax
  8044e7:	83 f8 7f             	cmp    $0x7f,%eax
  8044ea:	7f 24                	jg     804510 <inet_aton+0x1fd>
  8044ec:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8044f0:	74 28                	je     80451a <inet_aton+0x207>
  8044f2:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8044f6:	74 22                	je     80451a <inet_aton+0x207>
  8044f8:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8044fc:	74 1c                	je     80451a <inet_aton+0x207>
  8044fe:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  804502:	74 16                	je     80451a <inet_aton+0x207>
  804504:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804508:	74 10                	je     80451a <inet_aton+0x207>
  80450a:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80450e:	74 0a                	je     80451a <inet_aton+0x207>
    return (0);
  804510:	b8 00 00 00 00       	mov    $0x0,%eax
  804515:	e9 df 00 00 00       	jmpq   8045f9 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80451a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80451e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804522:	48 29 c2             	sub    %rax,%rdx
  804525:	48 89 d0             	mov    %rdx,%rax
  804528:	48 c1 f8 02          	sar    $0x2,%rax
  80452c:	83 c0 01             	add    $0x1,%eax
  80452f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  804532:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804536:	0f 87 98 00 00 00    	ja     8045d4 <inet_aton+0x2c1>
  80453c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80453f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804546:	00 
  804547:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80454e:	00 00 00 
  804551:	48 01 d0             	add    %rdx,%rax
  804554:	48 8b 00             	mov    (%rax),%rax
  804557:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804559:	b8 00 00 00 00       	mov    $0x0,%eax
  80455e:	e9 96 00 00 00       	jmpq   8045f9 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804563:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  80456a:	76 0a                	jbe    804576 <inet_aton+0x263>
      return (0);
  80456c:	b8 00 00 00 00       	mov    $0x0,%eax
  804571:	e9 83 00 00 00       	jmpq   8045f9 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  804576:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804579:	c1 e0 18             	shl    $0x18,%eax
  80457c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80457f:	eb 53                	jmp    8045d4 <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804581:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804588:	76 07                	jbe    804591 <inet_aton+0x27e>
      return (0);
  80458a:	b8 00 00 00 00       	mov    $0x0,%eax
  80458f:	eb 68                	jmp    8045f9 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804591:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804594:	c1 e0 18             	shl    $0x18,%eax
  804597:	89 c2                	mov    %eax,%edx
  804599:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80459c:	c1 e0 10             	shl    $0x10,%eax
  80459f:	09 d0                	or     %edx,%eax
  8045a1:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045a4:	eb 2e                	jmp    8045d4 <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8045a6:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8045ad:	76 07                	jbe    8045b6 <inet_aton+0x2a3>
      return (0);
  8045af:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b4:	eb 43                	jmp    8045f9 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8045b6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045b9:	c1 e0 18             	shl    $0x18,%eax
  8045bc:	89 c2                	mov    %eax,%edx
  8045be:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8045c1:	c1 e0 10             	shl    $0x10,%eax
  8045c4:	09 c2                	or     %eax,%edx
  8045c6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8045c9:	c1 e0 08             	shl    $0x8,%eax
  8045cc:	09 d0                	or     %edx,%eax
  8045ce:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045d1:	eb 01                	jmp    8045d4 <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8045d3:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8045d4:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8045d9:	74 19                	je     8045f4 <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  8045db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045de:	89 c7                	mov    %eax,%edi
  8045e0:	48 b8 72 47 80 00 00 	movabs $0x804772,%rax
  8045e7:	00 00 00 
  8045ea:	ff d0                	callq  *%rax
  8045ec:	89 c2                	mov    %eax,%edx
  8045ee:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8045f2:	89 10                	mov    %edx,(%rax)
  return (1);
  8045f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045f9:	c9                   	leaveq 
  8045fa:	c3                   	retq   

00000000008045fb <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8045fb:	55                   	push   %rbp
  8045fc:	48 89 e5             	mov    %rsp,%rbp
  8045ff:	48 83 ec 30          	sub    $0x30,%rsp
  804603:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804606:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804609:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80460c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804613:	00 00 00 
  804616:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  80461a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80461e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804622:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804626:	e9 e0 00 00 00       	jmpq   80470b <inet_ntoa+0x110>
    i = 0;
  80462b:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80462f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804633:	0f b6 08             	movzbl (%rax),%ecx
  804636:	0f b6 d1             	movzbl %cl,%edx
  804639:	89 d0                	mov    %edx,%eax
  80463b:	c1 e0 02             	shl    $0x2,%eax
  80463e:	01 d0                	add    %edx,%eax
  804640:	c1 e0 03             	shl    $0x3,%eax
  804643:	01 d0                	add    %edx,%eax
  804645:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80464c:	01 d0                	add    %edx,%eax
  80464e:	66 c1 e8 08          	shr    $0x8,%ax
  804652:	c0 e8 03             	shr    $0x3,%al
  804655:	88 45 ed             	mov    %al,-0x13(%rbp)
  804658:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80465c:	89 d0                	mov    %edx,%eax
  80465e:	c1 e0 02             	shl    $0x2,%eax
  804661:	01 d0                	add    %edx,%eax
  804663:	01 c0                	add    %eax,%eax
  804665:	29 c1                	sub    %eax,%ecx
  804667:	89 c8                	mov    %ecx,%eax
  804669:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  80466c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804670:	0f b6 00             	movzbl (%rax),%eax
  804673:	0f b6 d0             	movzbl %al,%edx
  804676:	89 d0                	mov    %edx,%eax
  804678:	c1 e0 02             	shl    $0x2,%eax
  80467b:	01 d0                	add    %edx,%eax
  80467d:	c1 e0 03             	shl    $0x3,%eax
  804680:	01 d0                	add    %edx,%eax
  804682:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804689:	01 d0                	add    %edx,%eax
  80468b:	66 c1 e8 08          	shr    $0x8,%ax
  80468f:	89 c2                	mov    %eax,%edx
  804691:	c0 ea 03             	shr    $0x3,%dl
  804694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804698:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  80469a:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80469e:	8d 50 01             	lea    0x1(%rax),%edx
  8046a1:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8046a4:	0f b6 c0             	movzbl %al,%eax
  8046a7:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8046ab:	83 c2 30             	add    $0x30,%edx
  8046ae:	48 98                	cltq   
  8046b0:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8046b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b8:	0f b6 00             	movzbl (%rax),%eax
  8046bb:	84 c0                	test   %al,%al
  8046bd:	0f 85 6c ff ff ff    	jne    80462f <inet_ntoa+0x34>
    while(i--)
  8046c3:	eb 1a                	jmp    8046df <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8046c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046cd:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8046d1:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8046d5:	48 63 d2             	movslq %edx,%rdx
  8046d8:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8046dd:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8046df:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8046e3:	8d 50 ff             	lea    -0x1(%rax),%edx
  8046e6:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8046e9:	84 c0                	test   %al,%al
  8046eb:	75 d8                	jne    8046c5 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8046ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046f5:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8046f9:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8046fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  804701:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804705:	83 c0 01             	add    $0x1,%eax
  804708:	88 45 ef             	mov    %al,-0x11(%rbp)
  80470b:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80470f:	0f 86 16 ff ff ff    	jbe    80462b <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804715:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  80471a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80471e:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804721:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804728:	00 00 00 
}
  80472b:	c9                   	leaveq 
  80472c:	c3                   	retq   

000000000080472d <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80472d:	55                   	push   %rbp
  80472e:	48 89 e5             	mov    %rsp,%rbp
  804731:	48 83 ec 08          	sub    $0x8,%rsp
  804735:	89 f8                	mov    %edi,%eax
  804737:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80473b:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80473f:	c1 e0 08             	shl    $0x8,%eax
  804742:	89 c2                	mov    %eax,%edx
  804744:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804748:	66 c1 e8 08          	shr    $0x8,%ax
  80474c:	09 d0                	or     %edx,%eax
}
  80474e:	c9                   	leaveq 
  80474f:	c3                   	retq   

0000000000804750 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804750:	55                   	push   %rbp
  804751:	48 89 e5             	mov    %rsp,%rbp
  804754:	48 83 ec 08          	sub    $0x8,%rsp
  804758:	89 f8                	mov    %edi,%eax
  80475a:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  80475e:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804762:	89 c7                	mov    %eax,%edi
  804764:	48 b8 2d 47 80 00 00 	movabs $0x80472d,%rax
  80476b:	00 00 00 
  80476e:	ff d0                	callq  *%rax
}
  804770:	c9                   	leaveq 
  804771:	c3                   	retq   

0000000000804772 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804772:	55                   	push   %rbp
  804773:	48 89 e5             	mov    %rsp,%rbp
  804776:	48 83 ec 08          	sub    $0x8,%rsp
  80477a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80477d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804780:	c1 e0 18             	shl    $0x18,%eax
  804783:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804788:	25 00 ff 00 00       	and    $0xff00,%eax
  80478d:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804790:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804795:	25 00 00 ff 00       	and    $0xff0000,%eax
  80479a:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80479e:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8047a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a3:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8047a6:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8047a8:	c9                   	leaveq 
  8047a9:	c3                   	retq   

00000000008047aa <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8047aa:	55                   	push   %rbp
  8047ab:	48 89 e5             	mov    %rsp,%rbp
  8047ae:	48 83 ec 08          	sub    $0x8,%rsp
  8047b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8047b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b8:	89 c7                	mov    %eax,%edi
  8047ba:	48 b8 72 47 80 00 00 	movabs $0x804772,%rax
  8047c1:	00 00 00 
  8047c4:	ff d0                	callq  *%rax
}
  8047c6:	c9                   	leaveq 
  8047c7:	c3                   	retq   
